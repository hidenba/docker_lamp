require 'spec_helper'

describe package('mysql-server') do
  it { should be_installed.with_version('5.6.17+dfsg-1+deb.sury.org~trusty+1') }
end

describe port(3306) do
  it { should be_listening }
end

describe process("apache2") do
  it { should be_running }
end
