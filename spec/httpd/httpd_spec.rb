require 'spec_helper'

describe package('apache2') do
  it { should be_installed }
end

describe package('php5') do
  it { should be_installed }
end

describe package('libapache2-mod-php5') do
  it { should be_installed }
end

describe port(80) do
  it { should be_listening }
end

describe process("apache2") do
  it { should be_running }
end
