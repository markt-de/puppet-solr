# @summary
#   Installs and configures the Solr service.
#
# @api private
class solr::service {
  assert_private()

  # Configure resource limits on Linux.
  if ($solr::manage_service_limits) {
    if ($facts['kernel'] == 'Linux') {
      # Configure systemd service limits.
      systemd::manage_dropin { "${solr::service_name}.service-90-limits.conf":
        filename       => '90-limits.conf',
        unit           => "${solr::service_name}.service",
        service_entry  => {
          'LimitNOFILE' => $solr::limit_file_max,
          'LimitNPROC'  => $solr::limit_proc_max,
          'TasksMax'    => $solr::limit_proc_max,
        },
        notify_service => false,
      }

      # Additionally set limits for the Solr user.
      limits::limits { "${solr::solr_user}/nofile": both => $solr::limit_file_max }
      limits::limits { "${solr::solr_user}/nproc": both => $solr::limit_proc_max }
    }
  }

  # Solr 10 is managed via systemd, older releases via the init.d script that
  # this module deploys (see solr::config).
  if versioncmp($solr::version, '10.0.0') >= 0 {
    include 'systemd'

    # In Solr 10 SolrCloud is the default startup mode. To keep standalone
    # (user-managed) behavior the "--user-managed" switch must be passed.
    if $solr::cloud {
      $exec_start = "${solr::solr_base}/bin/solr start"
    } else {
      $exec_start = "${solr::solr_base}/bin/solr start --user-managed"
    }

    # Manage our own unit file. The installer drops one at the same path, but
    # this lets Puppet control the startup mode and the include file location.
    # It lives here (rather than in solr::config) so that it shares the class
    # with the resource limits dropin and does not create a daemon-reload cycle.
    systemd::unit_file { "${solr::service_name}.service":
      content => epp('solr/solr.service.epp', {
          'solr_base'    => $solr::solr_base,
          'solr_user'    => $solr::solr_user,
          'solr_include' => $solr::config::solr_include,
          'exec_start'   => $exec_start,
      }),
      notify  => Service[$solr::service_name],
    }

    $service_provider = 'systemd'
    $service_subscribe = Systemd::Unit_file["${solr::service_name}.service"]
  } else {
    $service_provider = undef
    $service_subscribe = File["/etc/init.d/${solr::service_name}"]
  }

  service { $solr::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    provider   => $service_provider,
    subscribe  => $service_subscribe,
  }
}
