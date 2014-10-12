require 'spec_helper'

describe 'reprepro' do

  let :default_params do
    {
      :basedir => '/var/packages',
      :homedir => '/var/packages',
    }
  end

  context "With default parameters" do
    let :params do
      default_params
    end

    it { should contain_package('reprepro') }
    it { should contain_group('reprepro').with_name('reprepro') }
    it do
      should contain_user('reprepro').with({
        :name       => 'reprepro',
        :home       => '/var/packages',
        :shell      => '/bin/bash',
        :comment    => 'Reprepro user',
        :gid        => 'reprepro',
        :managehome => true,
      }).that_requires('Group[reprepro]')
    end

    it do
      should contain_file('/var/packages/bin').with({
        :ensure => 'directory',
        :mode   => '0755',
        :owner  => 'reprepro',
        :group  => 'reprepro',
      }).that_requires('User[reprepro]')
      end

    it do
      should contain_file('/var/packages/bin/update-distribution.sh').with({
        :mode    => '0755',
        :content => /while getopts/,
        :owner   => 'reprepro',
        :group   => 'reprepro',
      }).that_requires('File[/var/packages/bin]')
    end

  end

  context "With non-default parameters" do
    let :params do
      {
        :basedir => '/home/packages',
        :homedir => '/home/packages',
      }
    end

    it { should contain_package('reprepro') }
    it { should contain_group('reprepro').with_name('reprepro') }
    it do
      should contain_user('reprepro').with({
        :name       => 'reprepro',
        :home       => '/home/packages',
        :shell      => '/bin/bash',
        :comment    => 'Reprepro user',
        :gid        => 'reprepro',
        :managehome => true,
      }).that_requires('Group[reprepro]')
    end

    it do
      should contain_file('/home/packages/bin').with({
        :ensure => 'directory',
        :mode   => '0755',
        :owner  => 'reprepro',
        :group  => 'reprepro',
      }).that_requires('User[reprepro]')
      end

    it do
      should contain_file('/home/packages/bin/update-distribution.sh').with({
        :mode    => '0755',
        :content => /while getopts/,
        :owner   => 'reprepro',
        :group   => 'reprepro',
      }).that_requires('File[/home/packages/bin]')
    end

  end
end
