# Install and configure the Solr search platform.
#
class solr (
  String $version,
  Variant[Stdlib::HTTPUrl,Stdlib::HTTPSUrl] $mirror,
  Stdlib::Compat::Absolute_path $extract_dir,
  Stdlib::Compat::Absolute_path $var_dir,
  Stdlib::Compat::Absolute_path $solr_home,
  Stdlib::Compat::Absolute_path $log_dir,
  Integer $solr_port,
  String $solr_user,
  String $java_mem,
  Boolean $cloud,
  Boolean $upgrade,
  Optional[String] $zk_ensemble,
  Optional[String] $zk_chroot,
  Integer $zk_timeout,
  String $solr_host,
  String $solr_time,
  Boolean $enable_remote_jmx,
  String $service_name,
  Stdlib::Compat::Absolute_path $solr_base,
  Boolean $manage_custom_plugins,
  Array $custom_plugins,
  Stdlib::Compat::Absolute_path $custom_plugins_dir,
  String $custom_plugins_id,
  String $staging_dir,
  Optional[Array] $gc_log_opts,
  Optional[Array] $gc_tune,
  Optional[Stdlib::Compat::Absolute_path] $java_home,
  Optional[Array] $solr_opts,
) {
  Class { 'solr::install': }
  -> Class { 'solr::config': }
  -> Class { 'solr::customplugins': }
  -> Class { 'solr::service': }
  -> Class['solr']
}
