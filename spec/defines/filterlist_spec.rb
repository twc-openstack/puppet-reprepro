require 'spec_helper'

describe 'reprepro::filterlist' do

  context "With default basedir" do
    let(:title) { 'lenny-backports' }
    let(:params) do
      {
        :repository => 'dev',
        :packages   => ['git install', 'git-email install'],
      }
    end

    it { should include_class('reprepro::params') }

    it { should contain_file('/var/packages/dev/conf/lenny-backports-filter-list') }
  end

end
