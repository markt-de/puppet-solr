# @summary
#   Installs and configures the Solr service.
#
# @api private
class solr::service {
  assert_private()

  service { $solr::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    subscribe  => File["/etc/init.d/${solr::service_name}"],
  }
}
