# @summary
#   Installs and configures the Solr search platform.
#
# @param cloud
#   Determines whether to enable Solr Cloud.
#
# @param custom_plugins
#   A list of custom plugins that will be installed.
#
# @param custom_plugins_dir
#   Sets the target directory for custom plugins.
#
# @param custom_plugins_id
#   Sets the Solr config option that is used to configure custom plugins.
#
# @param enable_remote_jmx
#   Determines whether to enable remote JMX support.
#
# @param extract_dir
#   Sets the directory where the Solr installation archive should be extracted.
#
# @param gc_log_opts
#   Sets the contents of the GC_LOG_OPTS environment variable to enable verbose GC logging.
#
# @param gc_tune
#   Sets the contents of the GC_TUNE environment variable to enable custom GC settings.
#
# @param java_home
#   Sets the path to a Java installation that should be used by Solr instead of the default.
#
# @param java_mem
#   Sets JVM memory settings for Solr.
#
# @param limit_file_max
#   Sets the maximum number of file descriptors.
#
# @param limit_proc_max
#   Sets the maximum number of processes.
#
# @param log_dir
#   Sets the directory for Solr logs.
#
# @param manage_custom_plugins
#   Determines whether to enable support for custom plugins.
#
# @param manage_service_limits
#   Determines whether to set resource limits for the Solr service. The service
#   is NOT restarted when limits are changed.
#
# @param mirror
#   Sets the download location for Solr archives. It will be used during installations and upgrades.
#
# @param service_name
#   Sets the name of the system service that should be setup.
#
# @param solr_base
#   Internal module parameter, SHOULD NOT BE CHANGED! Specifies a symlink that is created by the Solr installer.
#
# @param solr_home
#   Sets the Solr data directory.
#
# @param solr_host
#   Sets the hostname that should be used for Solr.
#
# @param solr_opts
#   Changes optional parameters to customize Solr's startup parameters.
#
# @param solr_port
#   Sets the TCP port that should be used to access the Solr service.
#
# @param solr_time
#   Sets the timezone that shoule be used by Solr.
#
# @param solr_user
#   Sets the name of the user to use for Solr.
#
# @param staging_dir
#   Sets the staging directory that is used when installing or upgrading Solr.
#
# @param upgrade
#   Determines whether to enable upgrades to a new Solr version (see `$version`).
#
# @param var_dir
#   Sets the base directory for Solr configuration, data and logs.
#
# @param version
#   Sets the version of Solr that should be installed or the target version for an upgrade (see `$upgrade`).
#
# @param zk_chroot
#   Sets the ZooKeeper chroot path when using Solr Cloud (see `$cloud`).
#
# @param zk_ensemble
#   Sets the host:port information for every machine that is part of the ZooKeeper ensemble when using Solr Cloud (see `$cloud`).
#
# @param zk_timeout
#   Sets the timeout (in milliseconds) for connections to machines in the ZooKeeper ensemble.
#
class solr (
  String $version,
  Variant[Stdlib::HTTPUrl,Stdlib::HTTPSUrl] $mirror,
  Stdlib::Absolute_path $extract_dir,
  Stdlib::Absolute_path $var_dir,
  Stdlib::Absolute_path $solr_home,
  Stdlib::Absolute_path $log_dir,
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
  Stdlib::Absolute_path $solr_base,
  Boolean $manage_custom_plugins,
  Array $custom_plugins,
  Stdlib::Absolute_path $custom_plugins_dir,
  String $custom_plugins_id,
  String $staging_dir,
  Boolean $manage_service_limits,
  Integer $limit_file_max,
  Integer $limit_proc_max,
  Optional[Array] $gc_log_opts,
  Optional[Array] $gc_tune,
  Optional[Stdlib::Absolute_path] $java_home,
  Optional[Array] $solr_opts,
) {
  Class { 'solr::install': }
  -> Class { 'solr::config': }
  -> Class { 'solr::customplugins': }
  -> Class { 'solr::service': }
  -> Class['solr']
}
