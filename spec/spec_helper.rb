require 'serverspec'
require 'pathname'
require 'net/ssh'

include SpecInfra::Helper::Ssh
include SpecInfra::Helper::DetectOS

require 'docker'
require 'tapp'

Docker.url = 'http://192.168.33.10:4243'

RSpec.configure do |c|

  c.add_setting :containers
  c.containers = []

  c.before :all do
    block = self.class.metadata[:example_group_block]
    host  = Pathname(block.source_location.first).basename('_spec.rb')
    if c.host != host
      image = Docker::Image.build_from_dir(File.expand_path("docker_files/#{host}"))
      image.tag(repo: host, force: true)
      container = Docker::Container.create(Image: host,
                                           Cmd: ['/usr/bin/supervisord'],
                                           ExposedPorts: {'22/tcp' => {}})
      container.start(PortBindings: {'22/tcp' => [{HostIp: '0.0.0.0'}]})
      c.containers << container

      options = {
        keys: [File.expand_path('docker_files/sshd/key/id_rsa')],
        port: container.json['HostConfig']['PortBindings']['22/tcp'][0]['HostPort']
      }
      tcp_pooling(container, options)

      c.ssh.close if c.ssh
      c.host  = host
      c.ssh   = Net::SSH.start('192.168.33.10', 'root', options)
    end
  end

  c.after :suite do
    c.containers.each { |con| con.kill.delete }
    Docker::Container.all(all: true).select{ |con| con.info['Status'].include?('Exit') }.each(&:delete)
    Docker::Image.all.select {|img| img.info['RepoTags'] == ['<none>:<none>']}.each(&:remove)
  end

  def tcp_pooling(container, options)
    sock = TCPSocket.open('192.168.33.10', options[:port])
    sock.close
  rescue Errno::ECONNREFUSED
    container.json['State']['Running'] ? tcp_pooling(container, options) : raise('Container not Running')
  end
end
