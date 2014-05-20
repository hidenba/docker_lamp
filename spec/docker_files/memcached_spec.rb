require 'spec_helper'

describe package('memcached') do
  it { should be_installed.with_version('1.4.14-0ubuntu9') }
end

describe port(11211) do
  it { should be_listening }
end

describe process("memcached") do
  it { should be_running }
end
