# @api private
#
# This class ensures that the service is running.
#
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
