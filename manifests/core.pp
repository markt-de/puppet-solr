# This define creates a Solr core or collection.
#
define solr::core (
  String $core_name = $name,
) {
  require solr

  exec { "create ${core_name} core":
    command => "${solr::solr_base}/bin/solr create -c ${core_name}",
    cwd     => $solr::solr_base,
    creates => "${solr::solr_home}/${core_name}",
    user    => $solr::solr_user,
  }
}
