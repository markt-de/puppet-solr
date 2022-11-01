require 'spec_helper'

describe 'solr' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'solr class without optional parameters' do
          let(:params) do
            {
              version: '9.0.0',
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('solr') }

          it { is_expected.to contain_class('solr::install').that_comes_before('Class[solr::config]') }
          it { is_expected.to contain_class('solr::config').that_comes_before('Class[solr::service]') }
          it { is_expected.to contain_class('solr::service') }

          it {
            is_expected.to contain_archive('/opt/staging/solr-9.0.0.tgz').with(
              extract_path: '/opt/staging',
              source: 'https://dlcdn.apache.org/solr/solr/9.0.0/solr-9.0.0.tgz',
              creates: '/opt/staging/solr-9.0.0',
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
              command: '/opt/staging/solr-9.0.0/bin/install_solr_service.sh /opt/staging/solr-9.0.0.tgz -i /opt -d /var/solr -u solr -s solr -p 8983 -n ',
              cwd: '/opt/staging/solr-9.0.0',
              creates: '/opt/solr-9.0.0',
            ).that_requires('Archive[/opt/staging/solr-9.0.0.tgz]')
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
            )
            is_expected.to contain_file('/var/solr/solr.in.sh').with_content(%r{SOLR_PID_DIR=/var/solr})
            is_expected.to contain_file('/var/solr/solr.in.sh').with_content(%r{SOLR_HOME=/var/solr/data})
            is_expected.to contain_file('/var/solr/solr.in.sh').with_content(%r{LOG4J_PROPS=/var/solr/log4j2.xml})
            is_expected.to contain_file('/var/solr/solr.in.sh').with_content(%r{SOLR_LOGS_DIR=/var/log/solr})
            is_expected.to contain_file('/var/solr/solr.in.sh').with_content(%r{SOLR_PORT=8983})
          }
          it {
            is_expected.to contain_file('/opt/solr-9.0.0/server/resources/log4j2.xml').with(
              ensure: 'file',
              mode: '0644',
              owner: 'solr',
              group: 'solr',
            ).with_content(%r{fileName=\"\$\{sys:solr.log.dir\}/solr.log\"})
          }
          it {
            is_expected.to contain_file('/var/solr/log4j2.xml').with(
              ensure: 'file',
              mode: '0644',
              owner: 'solr',
              group: 'solr',
            ).with_content(%r{fileName=\"\$\{sys:solr.log.dir\}/solr.log\"})
          }
          it {
            is_expected.to contain_file('/etc/init.d/solr').with(
              ensure: 'file',
              mode: '0744',
            ).with_content(%r{SOLR_ENV="/var/solr/solr.in.sh"})
          }

          it { is_expected.to contain_systemd__service_limits('solr.service') }
          it { is_expected.to contain_limits__limits('solr/nofile') }
          it { is_expected.to contain_limits__limits('solr/nproc') }

          it { is_expected.to contain_service('solr') }
        end

        context 'solr class when manage_service_limits is set to false' do
          let(:params) do
            {
              manage_service_limits: false,
              version: '9.0.0',
            }
          end

          it { is_expected.to compile.with_all_deps }

          it { is_expected.not_to contain_systemd__service_limits('solr.service') }
          it { is_expected.not_to contain_limits__limits('solr/nofile') }
          it { is_expected.not_to contain_limits__limits('solr/nproc') }
        end
      end
    end
  end
end
