require 'spec_helper'

describe 'solr' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'solr class without any parameters' do
          let(:params) { {} }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('solr') }

          it { is_expected.to contain_class('solr::params') }
          it { is_expected.to contain_class('solr::install').that_comes_before('solr::config') }
          it { is_expected.to contain_class('solr::config') }
          it { is_expected.to contain_class('solr::service').that_subscribes_to('solr::config') }

          it {
            is_expected.to contain_staging__deploy('solr-5.1.0.tgz').with(
              target: '/opt/staging',
              source: 'http://www.apache.org/dist/lucene/solr/5.1.0/solr-5.1.0.tgz',
              staging_path: '/opt/staging/solr-5.1.0.tgz',
            )
          }
          it {
            is_expected.to contain_user('solr').with(
              ensure: 'present',
              managehome: true,
              system: true,
            ).that_comes_before('Exec[run solr install script]')
          }
          it {
            is_expected.to contain_exec('run solr install script').with(
              command: '/opt/staging/solr-5.1.0/bin/install_solr_service.sh /opt/staging/solr-5.1.0.tgz -i /opt -d /var/solr -u solr -s solr -p 8983',
              cwd: '/opt/staging/solr-5.1.0',
              creates: '/opt/solr-5.1.0',
            ).that_requires('Staging::Deploy[solr-5.1.0.tgz]')
          }
          it {
            is_expected.to contain_file('/var/solr').with(
              ensure: 'directory',
              owner: 'solr',
              group: 'solr',
              recurse: true,
            ).that_requires('Exec[run solr install script]')
          }
          it {
            is_expected.to contain_file('/var/log/solr').with(
              ensure: 'directory',
              owner: 'solr',
              group: 'solr',
            ).that_requires('Exec[run solr install script]')
          }

          it {
            is_expected.to contain_file('/var/solr/solr.in.sh').with(
              ensure: 'file',
              mode: '0755',
              owner: 'solr',
              group: 'solr',
            ).with_content(%r{SOLR_PID_DIR=/var/solr\nSOLR_HOME=/var/solr/data\nLOG4J_PROPS=/var/solr/log4j.properties\nSOLR_LOGS_DIR=/var/log/solr\nSOLR_PORT=8983})
          }
          it {
            is_expected.to contain_file('/opt/solr-5.1.0/server/resources/log4j.properties').with(
              ensure: 'file',
              mode: '0644',
              owner: 'solr',
              group: 'solr',
            ).with_content(%r{solr.log=/var/log/solr})
          }
          it {
            is_expected.to contain_file('/var/solr/log4j.properties').with(
              ensure: 'file',
              mode: '0644',
              owner: 'solr',
              group: 'solr',
            ).with_content(%r{solr.log=/var/log/solr})
          }
          it {
            is_expected.to contain_file('/etc/init.d/solr').with(
              ensure: 'file',
              mode: '0744',
            ).with_content(%r{SOLR_ENV=/var/solr/solr.in.sh})
          }

          it { is_expected.to contain_service('solr') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'solr class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          osfamily: 'Solaris',
          operatingsystem: 'Nexenta',
        }
      end

      it {
        expect { is_expected.to contain_package('solr') }.to raise_error(Puppet::Error, %r{Nexenta not supported})
      }
    end
  end
end
