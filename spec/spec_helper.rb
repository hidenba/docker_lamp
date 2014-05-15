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

  if ENV['ASK_SUDO_PASSWORD']
    require 'highline/import'
    c.sudo_password = ask("Enter sudo password: ") { |q| q.echo = false }
  else
    c.sudo_password = ENV['SUDO_PASSWORD']
  end

  c.before :all do
    block = self.class.metadata[:example_group_block]
    file = block.source_location.first
    host  = File.basename(Pathname.new(file).dirname)
    if c.host != host
      image = Docker::Image.build_from_dir(File.expand_path("docker_files/#{host}"))
      image.tag(repo: host, force: true)
      container = Docker::Container.create(Image: host,
                                           Entrypoint: ['/usr/sbin/sshd'],
                                           Cmd: ['-D'],
                                           ExposedPorts: {'22/tcp' => {}})
      container.start(PortBindings: {'22/tcp' => [{HostIp: '0.0.0.0'}]})
      c.containers << container

      sleep 1
      options = {
        keys: [File.expand_path('docker_files/sshd/key/id_rsa')],
        port: container.json['HostConfig']['PortBindings']['22/tcp'][0]['HostPort']
      }
      c.ssh.close if c.ssh
      c.host  = host
      c.ssh   = Net::SSH.start('192.168.33.10', 'root', options)
    end
  end

  c.after :suite do
    c.containers.each { |con| con.kill.delete }
  end
end
