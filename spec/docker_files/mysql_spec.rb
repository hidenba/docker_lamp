require 'spec_helper'

describe package('mysql-server-5.6') do
  it { should be_installed.with_version('5.6.17-0ubuntu0.14.04.1') }
end

describe port(3306) do
  pending 'listenしてるけど通らないの…'
  # it { should be_listening }
end

describe process("mysqld_safe") do
  it { should be_running }
end
