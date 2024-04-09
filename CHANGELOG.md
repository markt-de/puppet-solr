# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Add new parameter `$jetty_host`
- Add new parameter `$enable_security_manager`

### Changed
- Remove all `$gc_tune` default values

## [4.0.0] - 2024-04-03

### Added
- Add support for embedded prometheus exporter ([#10])
- Add support for configuring a custom Syslog appender ([#11])
- Add support for managing the allowPaths option

### Changed
- Manage the `which` package on RedHat-based systems
- Switch tests to Solr 9.4.1
- Improve test coverage
- Update to PDK 3.0.1

### Fixed
- Java 17 not possible due to incompatible settings in `$gc_tune`

### Removed
- Remove obsolete GC options from `$gc_tune`
- Drop support for EOL operating systems

## [3.2.0] - 2023-07-25

### Fixed
- Fix compatibility with puppetlabs/stdlib v9.0.0 ([#12])
- Fix unit/acceptance tests
- Fix GitHub Actions

## [3.1.1] - 2022-11-01

### Fixed
- Parameter `$manage_service_limits` not working ([#8])

## [3.1.0] - 2022-10-31

### Added
- Add new parameters: `$limit_file_max`, `$limit_proc_max`, `$manage_service_limits`
- New dependency: saz/limits

### Changed
- Set service limits for maximum number of processes and file descriptors
- New param `$manage_service_limits` will cause ALL other limits to be purged

### Fixed
- Suppress Puppet warning about limit for number of files in /opt/staging exceeded ([#5])
- Solve Solr warning about ulimit checks

## [3.0.0] - 2022-08-17

### Added
- New dependency: voxpupuli/systemd

### Changed
- Replace camptocamp/systemd with voxpupuli/systemd
- Module no longer provides a default value for $version
- The solr::core define no longer includes the solr class
- Update OS support, Puppet versions and module dependencies
- Use modern facts instead of $fqdn
- Switch to new Apache download mirror
- Switch unit/acceptance tests to Solr 9.0.0
- Migrate tests to GitHub Actions
- Convert documentation to Puppet Strings

### Fixed
- Fix incompatibility with new systemd module ([#4])
- Fix puppet-lint offenses
- Fix rubocop offenses
- Fix unit tests
- Fix acceptance tests
- Update PDK to 2.5.0

## [2.2.1] - 2020-06-02

### Changed
- Update PDK to 1.18.0

### Fixed
- Ensure correct systemd dependency is used ([#3])

## [2.2.0] - 2019-11-04

### Changed
- Make `$zk_chroot` optional to support a ZooKeeper ensemble without a chroot ([#2])
- Change default of `$zk_chroot` from `solrcloud` to `undef` ([#2])

## [2.1.0] - 2019-10-24

### Changed
- Use camptocamp/systemd (new dependency) to trigger systemd reloads
- Declare private classes private

### Fixed
- Fix non-zookeeper/cloud installs by making `$zk_ensemble` optional ([#1])

## [2.0.0] - 2019-10-08
This is a feature release that may contain backwards incompatible changes.

### Added
- Add support to manage custom plugins
- Add new parameters: `$custom_plugins`, `$custom_plugins_dir`, `$custom_plugins_id`, `$manage_custom_plugins`
- Add new parameter `$staging_dir` to make the staging directory configurable

### Changed
- Only support Solr 7.x and 8.x (older versions may work but are unsupported)

## [1.0.0] - 2019-10-01
This is the first release after forking the module. It should be possible to
migrate from spacepants/puppet-solr to this version with only minor modifications.

### Added
- Add new parameter `$zk_chroot` to customize the ZooKeeper chroot when using Solr Cloud
- Add new parameter `$enable_remote_jmx` to enable remote JMX support
- Support log4j2 on Solr >= 7.4.0
- Add new parameter `$solr_opts` to customize Solr startup parameters

### Changed
- Style: move parameters to the appropiate location in templates/solr.in.sh.erb
- Various style fixes to make puppet-lint happy
- Make default configuration compatible with JDK 11
- Migrate default settings from params.pp to Hiera module data
- Convert main template to EPP
- Convert module to PDK
- Update depencency and Puppet versions
- Use native Puppet data types
- Update default version to use most recent version of Solr
- Migrate to puppet/archive (replacing nanliu/staging)
- Run Solr installer with new -n parameter for more reliable installation

### Fixed
- Prevent Solr installer from starting an unconfigured instance (fixes a startup error)
- Fix user creation by respecting the `$solr_user` parameter
- Fix copy'n'paste errors in templates/solr.in.sh.erb (checking wrong parameters)
- Reload systemd after changing the init script (fixes a warning message)

### Removed
- Remove unused parameter `$install_dir`

[Unreleased]: https://github.com/markt-de/puppet-solr/compare/4.0.0...HEAD
[4.0.0]: https://github.com/markt-de/puppet-solr/compare/3.2.0...4.0.0
[3.2.0]: https://github.com/markt-de/puppet-solr/compare/3.1.1...3.2.0
[3.1.1]: https://github.com/markt-de/puppet-solr/compare/3.1.0...3.1.1
[3.1.0]: https://github.com/markt-de/puppet-solr/compare/3.0.0...3.1.0
[3.0.0]: https://github.com/markt-de/puppet-solr/compare/2.2.1...3.0.0
[2.2.1]: https://github.com/markt-de/puppet-solr/compare/2.2.0...2.2.1
[2.2.0]: https://github.com/markt-de/puppet-solr/compare/2.1.0...2.2.0
[2.1.0]: https://github.com/markt-de/puppet-solr/compare/2.0.0...2.1.0
[2.0.0]: https://github.com/markt-de/puppet-solr/compare/1.0.0...2.0.0
[#12]: https://github.com/markt-de/puppet-solr/pull/12
[#11]: https://github.com/markt-de/puppet-solr/pull/11
[#10]: https://github.com/markt-de/puppet-solr/pull/10
[#8]: https://github.com/markt-de/puppet-solr/pull/8
[#5]: https://github.com/markt-de/puppet-solr/pull/5
[#4]: https://github.com/markt-de/puppet-solr/pull/4
[#3]: https://github.com/markt-de/puppet-solr/pull/3
[#2]: https://github.com/markt-de/puppet-solr/pull/2
[#1]: https://github.com/markt-de/puppet-solr/pull/1
