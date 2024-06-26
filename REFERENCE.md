# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

### Classes

#### Public Classes

* [`solr`](#solr): Installs and configures the Solr search platform.

#### Private Classes

* `solr::config`: Setup and configure Solr.
* `solr::customplugins`: Manages custom plugins for Solr.
* `solr::install`: Installs and prepares the Solr application.
* `solr::prometheus_exporter`: Configure the embedded prometheus exporter as a service.
* `solr::service`: Installs and configures the Solr service.

### Defined types

* [`solr::core`](#solr--core): Creates a Solr core or collection.

## Classes

### <a name="solr"></a>`solr`

Installs and configures the Solr search platform.

#### Parameters

The following parameters are available in the `solr` class:

* [`additional_packages`](#-solr--additional_packages)
* [`allow_paths`](#-solr--allow_paths)
* [`cloud`](#-solr--cloud)
* [`custom_plugins`](#-solr--custom_plugins)
* [`custom_plugins_dir`](#-solr--custom_plugins_dir)
* [`custom_plugins_id`](#-solr--custom_plugins_id)
* [`enable_prometheus_exporter`](#-solr--enable_prometheus_exporter)
* [`enable_remote_jmx`](#-solr--enable_remote_jmx)
* [`enable_security_manager`](#-solr--enable_security_manager)
* [`enable_syslog`](#-solr--enable_syslog)
* [`extract_dir`](#-solr--extract_dir)
* [`gc_log_opts`](#-solr--gc_log_opts)
* [`gc_tune`](#-solr--gc_tune)
* [`java_home`](#-solr--java_home)
* [`java_mem`](#-solr--java_mem)
* [`jetty_host`](#-solr--jetty_host)
* [`limit_file_max`](#-solr--limit_file_max)
* [`limit_proc_max`](#-solr--limit_proc_max)
* [`log_dir`](#-solr--log_dir)
* [`manage_allow_paths`](#-solr--manage_allow_paths)
* [`manage_additional_packages`](#-solr--manage_additional_packages)
* [`manage_custom_plugins`](#-solr--manage_custom_plugins)
* [`manage_service_limits`](#-solr--manage_service_limits)
* [`mirror`](#-solr--mirror)
* [`service_name`](#-solr--service_name)
* [`prometheus_exporter_user`](#-solr--prometheus_exporter_user)
* [`prometheus_exporter_env_vars`](#-solr--prometheus_exporter_env_vars)
* [`prometheus_exporter_extra_options`](#-solr--prometheus_exporter_extra_options)
* [`prometheus_exporter_service_name`](#-solr--prometheus_exporter_service_name)
* [`solr_base`](#-solr--solr_base)
* [`solr_home`](#-solr--solr_home)
* [`solr_host`](#-solr--solr_host)
* [`solr_opts`](#-solr--solr_opts)
* [`solr_port`](#-solr--solr_port)
* [`solr_time`](#-solr--solr_time)
* [`solr_user`](#-solr--solr_user)
* [`staging_dir`](#-solr--staging_dir)
* [`syslog_app_name`](#-solr--syslog_app_name)
* [`syslog_facility`](#-solr--syslog_facility)
* [`syslog_host`](#-solr--syslog_host)
* [`syslog_port`](#-solr--syslog_port)
* [`syslog_protocol`](#-solr--syslog_protocol)
* [`upgrade`](#-solr--upgrade)
* [`var_dir`](#-solr--var_dir)
* [`version`](#-solr--version)
* [`zk_chroot`](#-solr--zk_chroot)
* [`zk_ensemble`](#-solr--zk_ensemble)
* [`zk_timeout`](#-solr--zk_timeout)

##### <a name="-solr--additional_packages"></a>`additional_packages`

Data type: `Array`

Specifies a list of additional packages that are required for Solr or one of its components.

##### <a name="-solr--allow_paths"></a>`allow_paths`

Data type: `Array`

Specifies a list of directories that should be added to the allowPath Solr option.

##### <a name="-solr--cloud"></a>`cloud`

Data type: `Boolean`

Determines whether to enable Solr Cloud.

##### <a name="-solr--custom_plugins"></a>`custom_plugins`

Data type: `Array`

A list of custom plugins that will be installed.

##### <a name="-solr--custom_plugins_dir"></a>`custom_plugins_dir`

Data type: `Stdlib::Absolutepath`

Sets the target directory for custom plugins.

##### <a name="-solr--custom_plugins_id"></a>`custom_plugins_id`

Data type: `String`

Sets the Solr config option that is used to configure custom plugins.

##### <a name="-solr--enable_prometheus_exporter"></a>`enable_prometheus_exporter`

Data type: `Boolean`

Determines whether to enable embedded prometheus exporter as a service.

##### <a name="-solr--enable_remote_jmx"></a>`enable_remote_jmx`

Data type: `Boolean`

Determines whether to enable remote JMX support.

##### <a name="-solr--enable_security_manager"></a>`enable_security_manager`

Data type: `Boolean`

Enable Java Security Manager. This affects filesystem access permissions and
may require to provide a custom security policy.

##### <a name="-solr--enable_syslog"></a>`enable_syslog`

Data type: `Boolean`

Configure syslog appender instead of file.

##### <a name="-solr--extract_dir"></a>`extract_dir`

Data type: `Stdlib::Absolutepath`

Sets the directory where the Solr installation archive should be extracted.

##### <a name="-solr--gc_log_opts"></a>`gc_log_opts`

Data type: `Optional[Array]`

Sets the contents of the GC_LOG_OPTS environment variable to enable verbose GC logging.

##### <a name="-solr--gc_tune"></a>`gc_tune`

Data type: `Optional[Array]`

Sets the contents of the GC_TUNE environment variable to enable custom GC settings.

##### <a name="-solr--java_home"></a>`java_home`

Data type: `Optional[Stdlib::Absolutepath]`

Sets the path to a Java installation that should be used by Solr instead of the default.

##### <a name="-solr--java_mem"></a>`java_mem`

Data type: `String`

Sets JVM memory settings for Solr.

##### <a name="-solr--jetty_host"></a>`jetty_host`

Data type: `Optional[String]`

Sets the IP address that Solr binds to.

##### <a name="-solr--limit_file_max"></a>`limit_file_max`

Data type: `Integer`

Sets the maximum number of file descriptors.

##### <a name="-solr--limit_proc_max"></a>`limit_proc_max`

Data type: `Integer`

Sets the maximum number of processes.

##### <a name="-solr--log_dir"></a>`log_dir`

Data type: `Stdlib::Absolutepath`

Sets the directory for Solr logs.

##### <a name="-solr--manage_allow_paths"></a>`manage_allow_paths`

Data type: `Boolean`

Whether to add the allowPaths option to the Solr config. When storing data
outside the default paths, allowPaths must be used.

##### <a name="-solr--manage_additional_packages"></a>`manage_additional_packages`

Data type: `Boolean`

Whether to manage the installation of additional packages.

##### <a name="-solr--manage_custom_plugins"></a>`manage_custom_plugins`

Data type: `Boolean`

Determines whether to enable support for custom plugins.

##### <a name="-solr--manage_service_limits"></a>`manage_service_limits`

Data type: `Boolean`

Determines whether to set resource limits for the Solr service. The service
is NOT restarted when limits are changed.

##### <a name="-solr--mirror"></a>`mirror`

Data type: `Variant[Stdlib::HTTPUrl,Stdlib::HTTPSUrl]`

Sets the download location for Solr archives. It will be used during installations and upgrades.

##### <a name="-solr--service_name"></a>`service_name`

Data type: `String`

Sets the name of the system service that should be setup.

##### <a name="-solr--prometheus_exporter_user"></a>`prometheus_exporter_user`

Data type: `String`

Sets the user running the solr-exporter binary.

##### <a name="-solr--prometheus_exporter_env_vars"></a>`prometheus_exporter_env_vars`

Data type: `Optional[Hash]`

Sets solr-exporter environment variables in service file (see https://solr.apache.org/guide/solr/latest/deployment-guide/monitoring-with-prometheus-and-grafana.html#environment-variable-options).

##### <a name="-solr--prometheus_exporter_extra_options"></a>`prometheus_exporter_extra_options`

Data type: `Optional[String]`

Sets solr-exporter custom command line options (see https://solr.apache.org/guide/solr/latest/deployment-guide/monitoring-with-prometheus-and-grafana.html#command-line-parameters).

##### <a name="-solr--prometheus_exporter_service_name"></a>`prometheus_exporter_service_name`

Data type: `String`

Sets the name of the prometheus exporter system service that should be setup.

##### <a name="-solr--solr_base"></a>`solr_base`

Data type: `Stdlib::Absolutepath`

Internal module parameter, SHOULD NOT BE CHANGED! Specifies a symlink that is created by the Solr installer.

##### <a name="-solr--solr_home"></a>`solr_home`

Data type: `Stdlib::Absolutepath`

Sets the Solr data directory.

##### <a name="-solr--solr_host"></a>`solr_host`

Data type: `String`

Sets the hostname that should be used for Solr.

##### <a name="-solr--solr_opts"></a>`solr_opts`

Data type: `Array`

Changes optional parameters to customize Solr's startup parameters.

##### <a name="-solr--solr_port"></a>`solr_port`

Data type: `Integer`

Sets the TCP port that should be used to access the Solr service.

##### <a name="-solr--solr_time"></a>`solr_time`

Data type: `String`

Sets the timezone that shoule be used by Solr.

##### <a name="-solr--solr_user"></a>`solr_user`

Data type: `String`

Sets the name of the user to use for Solr.

##### <a name="-solr--staging_dir"></a>`staging_dir`

Data type: `String`

Sets the staging directory that is used when installing or upgrading Solr.

##### <a name="-solr--syslog_app_name"></a>`syslog_app_name`

Data type: `String`

Sets the appName for syslog.

##### <a name="-solr--syslog_facility"></a>`syslog_facility`

Data type: `String`

Sets the destination facility for syslog.

##### <a name="-solr--syslog_host"></a>`syslog_host`

Data type: `String`

Sets the destination host for syslog.

##### <a name="-solr--syslog_port"></a>`syslog_port`

Data type: `Integer`

Sets the destination port for syslog.

##### <a name="-solr--syslog_protocol"></a>`syslog_protocol`

Data type: `String`

Sets the protocol for syslog.

##### <a name="-solr--upgrade"></a>`upgrade`

Data type: `Boolean`

Determines whether to enable upgrades to a new Solr version (see `$version`).

##### <a name="-solr--var_dir"></a>`var_dir`

Data type: `Stdlib::Absolutepath`

Sets the base directory for Solr configuration, data and logs.

##### <a name="-solr--version"></a>`version`

Data type: `String`

Sets the version of Solr that should be installed or the target version for an upgrade (see `$upgrade`).

##### <a name="-solr--zk_chroot"></a>`zk_chroot`

Data type: `Optional[String]`

Sets the ZooKeeper chroot path when using Solr Cloud (see `$cloud`).

##### <a name="-solr--zk_ensemble"></a>`zk_ensemble`

Data type: `Optional[String]`

Sets the host:port information for every machine that is part of the ZooKeeper ensemble when using Solr Cloud (see `$cloud`).

##### <a name="-solr--zk_timeout"></a>`zk_timeout`

Data type: `Integer`

Sets the timeout (in milliseconds) for connections to machines in the ZooKeeper ensemble.

## Defined types

### <a name="solr--core"></a>`solr::core`

Creates a Solr core or collection.

#### Parameters

The following parameters are available in the `solr::core` defined type:

* [`core_name`](#-solr--core--core_name)

##### <a name="-solr--core--core_name"></a>`core_name`

Data type: `String`

Sets the name of the core or collection.

Default value: `$name`

