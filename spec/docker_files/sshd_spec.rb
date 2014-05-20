require 'spec_helper'

describe package('openssh-server') do
  it { should be_installed }
end

describe file('/var/run/sshd') do
  it { should be_directory }
end

describe file('/root/.ssh') do
  it { should be_directory }
  it { should be_mode '600' }
end
