require 'spec_helper'

describe package('apache2') do
  it { should be_installed.with_version('2.2.22-1ubuntu1') }
end

describe package('php5') do
  it { should be_installed.with_version('5.3.10-1ubuntu3') }
end

describe package('libapache2-mod-php5') do
  it { should be_installed.with_version('5.3.10-1ubuntu3') }
end

describe port(80) do
  it { should be_listening }
end

describe process("apache2") do
  it { should be_running }
end
