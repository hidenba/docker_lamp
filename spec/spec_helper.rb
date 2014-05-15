require 'serverspec'
require 'pathname'
require 'net/ssh'

include SpecInfra::Helper::Ssh
include SpecInfra::Helper::DetectOS

require 'docker'
require 'tapp'

Docker.url = 'http://192.168.33.10:4243'

RSpec.configure do |c|

  c.add_setting :container

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
      c.container = Docker::Container.create(Image: host,
                                           Entrypoint: ['/usr/sbin/sshd'],
                                           Cmd: ['-D'],
                                           ExposedPorts: {'22/tcp' => {}})
      c.container.start(PortBindings: {'22/tcp' => [{HostIp: '0.0.0.0'}]})
      sleep 1
      c.ssh.close if c.ssh
      c.host  = host
      options = {
        keys: [File.expand_path('docker_files/sshd/key/id_rsa')],
        port: c.container.json['HostConfig']['PortBindings']['22/tcp'][0]['HostPort']
      }
      c.ssh   = Net::SSH.start('192.168.33.10', 'root', options)
    end
  end

  c.after do
    c.container.kill.delete
  end
end
