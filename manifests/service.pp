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

  service { $solr::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    subscribe  => File["/etc/init.d/${solr::service_name}"],
  }
}
