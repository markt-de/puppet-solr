# @summary
#   Configure the embedded prometheus exporter as a service.
#
# @api private
class solr::prometheus_exporter {
  assert_private()

  $solr_dir = "${solr::extract_dir}/${solr::service_name}"
  if versioncmp($solr::version, '9.0.0') >= 0 {
    $exporter_dir = "${solr_dir}/prometheus-exporter"
  } elsif versioncmp($solr::version, '7.3.0') >= 0 {
    $exporter_dir = "${solr_dir}/contrib/prometheus-exporter"
  } else {
    fail("The provided version ${solr::version} does not contain the embedded exporter (min 7.3.0)")
  }

  $bin_path = "${exporter_dir}/bin/solr-exporter"
  # File mode is 0644 by default, set it to executable
  file { $bin_path:
    ensure => 'file',
    mode   => '0755',
  }

  if $solr::prometheus_exporter_extra_options {
    $command = "${bin_path} ${solr::prometheus_exporter_extra_options}"
  } else {
    $command = $bin_path
  }

  include 'systemd'

  systemd::unit_file { "${solr::prometheus_exporter_service_name}.service":
    content => epp('solr/solr-exporter.systemd.epp', {
        'exporter_dir' => $exporter_dir,
        'user'         => $solr::prometheus_exporter_user,
        'env_vars'     => $solr::prometheus_exporter_env_vars,
        'command'      => $command,
    }),
    require => File[$bin_path],
    notify  => Service[$solr::prometheus_exporter_service_name],
  }

  service { $solr::prometheus_exporter_service_name:
    ensure   => 'running',
    enable   => true,
    provider => 'systemd',
  }
}
