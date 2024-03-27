require 'spec_helper_acceptance'

describe 'solr class' do
  let(:solr_version) { '9.4.1' }

  before(:all) do
    apply_manifest(%(
      # Tests will fail if `ss` is not installed.
      if ($facts['os']['family'] == 'RedHat') and (versioncmp($facts['os']['release']['major'], '8') >= 0) {
        ensure_packages('iproute')
      }

      if ($facts['os']['family'] == 'Debian') {
        $target_path = '/usr/lib/jvm'
      } else {
        $target_path = '/usr/java'
      }

      java::adopt { 'jdk11':
        ensure        => 'present',
        java          => 'jdk',
        version_major => '11.0.6',
        version_minor => '10',
      }
      -> file { '/usr/bin/java':
        ensure => link,
        target => "${target_path}/jdk-11.0.6+10/bin/java",
      }
    ), catch_failures: true)
  end
  context 'default parameters' do
    describe 'work idempotently with no errors' do
      let(:pp) do
        <<-MANIFEST
        class { 'solr':
          version   => '#{solr_version}',
          # Use 'localhost' for acceptance tests.
          solr_host => 'localhost',
          # Use Apache Archive, because "old" releases get removed
          # very quickly from the official mirrors.
          mirror    => 'https://archive.apache.org/dist/solr/solr',
        }
        MANIFEST
      end

      it 'runs successfully' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'is idempotent' do
        apply_manifest(pp, catch_changes: true)
      end
    end

    describe service('solr') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe port(8983) do
      it {
        # Solr may take a while to start up
        sleep(10)
        # Depending on the host system, this may be either IPv4-
        # or IPv6-only, so both needs to work.
        is_expected.to be_listening
      }
    end
  end
  context 'with exporter' do
    describe 'work idempotently with no errors' do
      let(:pp) do
        <<-MANIFEST
        class { 'solr':
          version                    => '9.4.1',
          # Use 'localhost' for acceptance tests.
          solr_host                  => 'localhost',
          # Use Apache Archive, because "old" releases get removed
          # very quickly from the official mirrors.
          # mirror    => 'https://archive.apache.org/dist/lucene/solr',
          enable_prometheus_exporter => true,
        }
        MANIFEST
      end

      it 'runs successfully' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'is idempotent' do
        apply_manifest(pp, catch_changes: true)
      end
    end

    describe service('solr-exporter') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe port(8989) do
      it {
        # Solr-exporter may take a while to start up
        sleep(10)
        # Depending on the host system, this may be either IPv4-
        # or IPv6-only, so both needs to work.
        is_expected.to be_listening
      }
    end
  end
end
