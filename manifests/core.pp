# This define creates a Solr core or collection.
#
define solr::core (
  String $core_name = $name,
) {
  if ! defined(Class['solr']) {
    fail('You must include the solr base class before using the solr core defined resource')
  }

  exec { "create ${core_name} core":
    command => "${solr::solr_base}/bin/solr create -c ${core_name}",
    cwd     => $solr::solr_base,
    creates => "${solr::solr_home}/${core_name}",
    user    => $solr::solr_user,
  }
}
