require 'spec_helper'

describe 'solr::core', type: 'define' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      let :pre_condition do
        "class {'solr': version => '8.2.0'}"
      end

      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'solr::core define without any parameters' do
          let(:params) { {} }
          let(:title) { 'test' }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_solr__core('test') }

          it {
            is_expected.to contain_exec('create test core').with(
              command: '/opt/solr/bin/solr create -c test',
              cwd: '/opt/solr',
              creates: '/var/solr/data/test',
              user: 'solr',
            )
          }
        end
      end
    end
  end
end
