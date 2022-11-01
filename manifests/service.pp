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
      systemd::service_limits { "${solr::service_name}.service":
        limits          => {
          'LimitNOFILE' => $solr::limit_file_max,
          'LimitNPROC'  => $solr::limit_proc_max,
          'TasksMax'    => $solr::limit_proc_max,
        },
        restart_service => false,
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
