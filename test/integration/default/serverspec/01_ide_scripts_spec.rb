require_relative 'spec_helper'

describe 'ide scripts' do
  describe command('/usr/bin/ide-setup-identity.sh') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should eq "ide identity set\n" }
  end

  describe command('/usr/bin/ide-fix-uid-gid.sh') do
    its(:exit_status) { should eq 0 }
  end

  describe file('/home/ide/.ssh/id_rsa') do
    it { should be_file }
    it { should be_owned_by 'ide' }
  end

  describe file('/home/ide/.gitconfig') do
    it { should be_file }
    it { should be_owned_by 'ide' }
  end

  describe command('/usr/bin/entrypoint.sh echo "mi" 2>&1') do
    # this would mean that /etc/docker_metadata.txt is incorrect:
    its(:stdout) { should_not contain '/etc/docker_metadata.txt:' }
    # this means that /etc/docker_metadata.txt is correct:
    its(:stdout) { should contain 'ide init finished' }
    its(:stdout) { should contain 'using gitide:' }
    its(:exit_status) { should eq 0 }
  end
end
