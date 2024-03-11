require 'spec_helper'

describe package('nfs-server') do
  it { should be_installed }
end

describe service('nfs-server') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/nfs-server') do
  it { should be_directory }
  it { should exist }
end
