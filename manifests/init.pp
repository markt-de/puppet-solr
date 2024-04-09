# @summary
#   Installs and configures the Solr search platform.
#
# @param additional_packages
#   Specifies a list of additional packages that are required for Solr or one of its components.
#
# @param allow_paths
#   Specifies a list of directories that should be added to the allowPath Solr option.
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
# @param enable_prometheus_exporter
#   Determines whether to enable embedded prometheus exporter as a service.
#
# @param enable_remote_jmx
#   Determines whether to enable remote JMX support.
#
# @param enable_security_manager
#   Enable Java Security Manager. This affects filesystem access permissions and
#   may require to provide a custom security policy.
#
# @param enable_syslog
#   Configure syslog appender instead of file.
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
# @param jetty_host
#   Sets the IP address that Solr binds to.
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
# @param manage_allow_paths
#   Whether to add the allowPaths option to the Solr config. When storing data
#   outside the default paths, allowPaths must be used.
#
# @param manage_additional_packages
#   Whether to manage the installation of additional packages.
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
# @param prometheus_exporter_user
#   Sets the user running the solr-exporter binary.
#
# @param prometheus_exporter_env_vars
#   Sets solr-exporter environment variables in service file (see https://solr.apache.org/guide/solr/latest/deployment-guide/monitoring-with-prometheus-and-grafana.html#environment-variable-options).
#
# @param prometheus_exporter_extra_options
#   Sets solr-exporter custom command line options (see https://solr.apache.org/guide/solr/latest/deployment-guide/monitoring-with-prometheus-and-grafana.html#command-line-parameters).
#
# @param prometheus_exporter_service_name
#   Sets the name of the prometheus exporter system service that should be setup.
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
# @param syslog_app_name
#   Sets the appName for syslog.
#
# @param syslog_facility
#   Sets the destination facility for syslog.
#
# @param syslog_host
#   Sets the destination host for syslog.
#
# @param syslog_port
#   Sets the destination port for syslog.
#
# @param syslog_protocol
#   Sets the protocol for syslog.
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
  Stdlib::Absolutepath $extract_dir,
  Stdlib::Absolutepath $var_dir,
  Stdlib::Absolutepath $solr_home,
  Stdlib::Absolutepath $log_dir,
  Boolean $enable_syslog,
  String $syslog_host,
  Integer $syslog_port,
  String $syslog_protocol,
  String $syslog_app_name,
  String $syslog_facility,
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
  Boolean $enable_security_manager,
  Boolean $enable_prometheus_exporter,
  Boolean $enable_remote_jmx,
  String $service_name,
  Stdlib::Absolutepath $solr_base,
  Array $additional_packages,
  Array $allow_paths,
  Boolean $manage_allow_paths,
  Boolean $manage_additional_packages,
  Boolean $manage_custom_plugins,
  Array $custom_plugins,
  Stdlib::Absolutepath $custom_plugins_dir,
  String $custom_plugins_id,
  String $staging_dir,
  Boolean $manage_service_limits,
  Integer $limit_file_max,
  Integer $limit_proc_max,
  String $prometheus_exporter_service_name,
  String $prometheus_exporter_user,
  Array $solr_opts,
  Optional[Hash] $prometheus_exporter_env_vars,
  Optional[String] $prometheus_exporter_extra_options,
  Optional[Array] $gc_log_opts,
  Optional[Array] $gc_tune,
  Optional[Stdlib::Absolutepath] $java_home,
  Optional[String] $jetty_host,
) {
  Class { 'solr::install': }
  -> Class { 'solr::config': }
  -> Class { 'solr::customplugins': }
  -> Class { 'solr::service': }
  -> Class['solr']

  if $enable_prometheus_exporter {
    Class { 'solr::prometheus_exporter':
      require => Class['solr'],
    }
  }
}
