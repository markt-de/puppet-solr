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
              version: '9.4.1',
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('solr') }

          it { is_expected.to contain_class('solr::install').that_comes_before('Class[solr::config]') }
          it { is_expected.to contain_class('solr::config').that_comes_before('Class[solr::service]') }
          it { is_expected.to contain_class('solr::service') }

          case facts[:osfamily]
          when 'RedHat'
            it {
              is_expected.to contain_package('which').with(
                ensure: 'installed',
              )
            }
          end

          it {
            is_expected.to contain_archive('/opt/staging/solr-9.4.1.tgz').with(
              extract_path: '/opt/staging',
              source: 'https://dlcdn.apache.org/solr/solr/9.4.1/solr-9.4.1.tgz',
              creates: '/opt/staging/solr-9.4.1',
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
              command: '/opt/staging/solr-9.4.1/bin/install_solr_service.sh /opt/staging/solr-9.4.1.tgz -i /opt -d /var/solr -u solr -s solr -p 8983 -n ',
              cwd: '/opt/staging/solr-9.4.1',
              creates: '/opt/solr-9.4.1',
            ).that_requires('Archive[/opt/staging/solr-9.4.1.tgz]')
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
            is_expected.to contain_file('/opt/solr-9.4.1/server/resources/log4j2.xml').with(
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
              version: '9.4.1',
            }
          end

          it { is_expected.to compile.with_all_deps }

          it { is_expected.not_to contain_systemd__service_limits('solr.service') }
          it { is_expected.not_to contain_limits__limits('solr/nofile') }
          it { is_expected.not_to contain_limits__limits('solr/nproc') }
        end

        context 'solr class when enable_prometheus_exporter is set to true' do
          let(:params) do
            {
              enable_prometheus_exporter: true,
              version: '9.4.1',
            }
          end

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('solr::prometheus_exporter').that_requires('Class[solr]') }

          it { is_expected.to contain_file('/opt/solr/prometheus-exporter/bin/solr-exporter').with('mode' => '0755') }
          it { is_expected.to contain_systemd__unit_file('solr-exporter.service').that_requires('File[/opt/solr/prometheus-exporter/bin/solr-exporter]').that_notifies('Service[solr-exporter]') }
          it { is_expected.to contain_service('solr-exporter').with('ensure' => 'running', 'enable' => true) }
        end

        context 'solr class when enable_prometheus_exporter is set to true with version < 9.0.0' do
          let(:params) do
            {
              enable_prometheus_exporter: true,
              version: '8.11.2',
            }
          end

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('solr::prometheus_exporter').that_requires('Class[solr]') }

          it { is_expected.to contain_file('/opt/solr/contrib/prometheus-exporter/bin/solr-exporter').with('mode' => '0755') }
          it {
            is_expected.to contain_systemd__unit_file('solr-exporter.service')
              .that_requires('File[/opt/solr/contrib/prometheus-exporter/bin/solr-exporter]')
              .that_notifies('Service[solr-exporter]')
          }
          it { is_expected.to contain_service('solr-exporter').with('ensure' => 'running', 'enable' => true) }
        end

        context 'solr class fails when enable_prometheus_exporter is set to true with version < 7.3.0' do
          let(:params) do
            {
              enable_prometheus_exporter: true,
              version: '7.2.1',
              mirror: 'https://archive.apache.org/dist/lucene/solr/',
            }
          end

          it { is_expected.to compile.with_all_deps.and_raise_error(%r{The provided version 7\.2\.1 does not contain the embedded exporter \(min 7\.3\.0\)}) }
        end

        context 'solr class when enable_prometheus_exporter is set to true and env_vars are provided' do
          let(:params) do
            {
              enable_prometheus_exporter: true,
              prometheus_exporter_env_vars: { 'JAVA_HEAP': '128m' },
              version: '9.4.1',
            }
          end

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_systemd__unit_file('solr-exporter.service').with_content(%r{Environment="JAVA_HEAP=128m"}) }
        end

        context 'solr class when manage_allow_paths is set to true' do
          let(:params) do
            {
              manage_allow_paths: true,
              allow_paths: [ '/tmp/CustomAllowPath' ],
              version: '9.4.1',
            }
          end

          it { is_expected.to contain_file('/var/solr/solr.in.sh').with_content(%r{-Dsolr.allowPaths=}) }
          it { is_expected.to contain_file('/var/solr/solr.in.sh').with_content(%r{/tmp/CustomAllowPath}) }
        end

        context 'solr class when manage_allow_paths is set to false' do
          let(:params) do
            {
              manage_allow_paths: false,
              allow_paths: [ '/tmp/solrAllowPath' ],
              version: '9.4.1',
            }
          end

          it { is_expected.to contain_file('/var/solr/solr.in.sh').without_content(%r{-Dsolr.allowPaths=}) }
          it { is_expected.to contain_file('/var/solr/solr.in.sh').without_content(%r{/tmp/CustomAllowPath}) }
        end

        context 'solr class when solr_opts is not empty' do
          let(:params) do
            {
              solr_opts: ['-Duser.language=de'],
              version: '9.4.1',
            }
          end

          it { is_expected.to contain_file('/var/solr/solr.in.sh').with_content(%r{-Duser.language=de}) }
        end

        context 'solr class when jetty_host is empty' do
          let(:params) do
            {
              version: '9.4.1',
            }
          end

          it { is_expected.to contain_file('/var/solr/solr.in.sh').with_content(%r{#SOLR_JETTY_HOST="127.0.0.1"}) }
        end

        context 'solr class when jetty_host is not empty' do
          let(:params) do
            {
              jetty_host: '10.1.2.3',
              version: '9.4.1',
            }
          end

          it { is_expected.to contain_file('/var/solr/solr.in.sh').with_content(%r{SOLR_JETTY_HOST="10.1.2.3"}) }
        end

        context 'solr class when gc_tune is empty' do
          let(:params) do
            {
              version: '9.4.1',
            }
          end

          it { is_expected.to contain_file('/var/solr/solr.in.sh').without_content(%r{GC_TUNE=}) }
        end

        context 'solr class when gc_tune is not empty' do
          let(:params) do
            {
              gc_tune: ['-XX:+UseG1GC'],
              version: '9.4.1',
            }
          end

          it { is_expected.to contain_file('/var/solr/solr.in.sh').with_content(%r{GC_TUNE="-XX:\+UseG1GC"}) }
        end

        context 'solr class when enable_security_manager is false' do
          let(:params) do
            {
              version: '9.4.1',
              enable_security_manager: false,
            }
          end

          it { is_expected.to contain_file('/var/solr/solr.in.sh').with_content(%r{SOLR_SECURITY_MANAGER_ENABLED=false}) }
        end

        context 'solr class when enable_security_manager is true' do
          let(:params) do
            {
              version: '9.4.1',
              enable_security_manager: true,
            }
          end

          it { is_expected.to contain_file('/var/solr/solr.in.sh').with_content(%r{SOLR_SECURITY_MANAGER_ENABLED=true}) }
        end
      end
    end
  end
end
