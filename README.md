# puppet-solr

[![Build Status](https://github.com/markt-de/puppet-solr/actions/workflows/ci.yaml/badge.svg)](https://github.com/markt-de/puppet-solr/actions/workflows/ci.yaml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/markt/solr.svg)](https://forge.puppetlabs.com/markt/solr)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/markt/solr.svg)](https://forge.puppetlabs.com/markt/solr)

#### Table of Contents

1. [Overview](#overview)
2. [Requirements](#requirements)
3. [Usage](#usage)
    - [Beginning with Solr](#beginning-with-solr)
    - [Test Solr](#test-solr)
    - [Solr Cloud](#solr-cloud)
    - [Custom Plugins](#custom-plugins)
4. [Reference](#reference)
    - [Public classes](#public-classes)
        - [solr](#class-solr)
    - [Private classes](#private-classes)
        - [solr::config](#class-solrconfig)
        - [solr::install](#class-solrinstall)
        - [solr::service](#class-solrservice)
    - [Defined Types](#defined-types)
        - [solr::core](#class-solrcore)
5. [Reference](#reference)
6. [Development](#development)
    - [Contributing](#contributing)
7. [License and Copyright](#license-and-copyright)

## Overview

This module will install and configure the Solr search platform.

## Requirements

* Puppet 6 or higher
* Java 8 or higher (depending on the Solr version)
* Tested with Solr 7, 8 and 9

It is recommended to use [puppetlabs/java](https://forge.puppet.com/puppetlabs/java) to manage the Java installation.

## Usage

### Beginning with Solr

Install Solr with default settings and start the service afterwards:

```puppet
class { 'solr':
    version => '9.0.0',
}
```

Furthermore, a number of simple options are available:

```puppet
class { 'solr':
    version => '9.0.0',

    # Allow automatic upgrades (when changing $version)
    upgrade => true,

    # Network settings
    solr_port => 8983,
    solr_host => $facts['networking']['fqdn'],

    # Use custom installation and data directories
    extract_dir => '/opt',
    var_dir     => '/opt/solr-home',
    log_dir     => '/opt/solr-home/log',
    solr_home   => '/opt/solr-home/data',

    # Change Solr runtime parameters
    java_mem  => '-Xms2g -Xmx8g',
    solr_time => 'Europe/Berlin',
    solr_opts => [
      '-Duser.language=de',
      '-Duser.country=DE',
    ],

    # Use an alternative download location (for old versions)
    mirror => 'https://archive.apache.org/dist/lucene/solr/',
}
```

### Test Solr
Use cURL to test if Solr is running:

```
curl -v http://localhost:8983/solr/
```

(Or use your browser for more convenience.)

### Solr Cloud
This module makes it pretty easy to configure Solr Cloud:

```puppet
class { 'solr':
    version     => '9.0.0',
    # Setup Solr cloud
    cloud       => true,
    zk_chroot   => 'foo',
    zk_ensemble => 'zookeeper1.example.com:2181,zookeeper2.example.com:2181,zookeeper3.example.com:2181',
    zk_timeout  => 15000,
}
```

It is recommended to use [deric/puppet-zookeeper](https://forge.puppet.com/deric/zookeeper) to manage the ZooKeeper nodes.

### Custom Plugins
When using Solr Cloud, you may use this module to manage your [custom plugins](https://lucene.apache.org/solr/guide/8_2/adding-custom-plugins-in-solrcloud-mode.html) with Puppet (instead of using the API):

```puppet
class { 'solr':
    version     => '9.0.0',
    # Setup Solr cloud
    cloud       => true,
    ...
    # Manage custom plugins
    manage_custom_plugins => true,
    custom_plugin_id      => 'solr.custom_plugins.dir',
    custom_plugins        => [
      {
        source        => 'https://my.example.com/company_solr_plugins.tgz',
        extract       => true,
        creates       => 'company-search-enhancer-1.0.jar',
        checksum_type => 'md5',
        checksum      => 'a5d3ae0781765a702ca274191a4d7c97',
      },
      {
        source        => 'https://my.example.com/more_solr_plugins.tgz',
        extract       => true,
        creates       => 'my-private-plugin-2.0.jar',
        checksum_type => 'md5',
        checksum      => '7a4e95b26ac41250f8a65c4bf4dd1d25',
      }
    ]
}
```

As you can see, the `$custom_plugins` parameter expects options in a format
that is compatible with [voxpupuli/archive](https://github.com/voxpupuli/puppet-archive).

All custom plugins will automatically be installed and Solr will then be restarted.
A new environment variable is added to Solr's startup options which points to the
custom plugins directory. The name of this variable can be adjusted by altering the
`$custom_plugin_id` parameter.

Note that you need to reference the `$custom_plugin_id` environment variable in
your configuration in order to actually load the custom plugins in your Solr Core:

```
<config>
  <lib dir="${solr.custom_plugins.dir}" />
  ...
</config>
```

## Reference

Classes and parameters are documented in [REFERENCE.md](REFERENCE.md).

## Development

### Contributing

Please use the GitHub issues functionality to report any bugs or requests for new features. Feel free to fork and submit pull requests for potential contributions.

## License and Copyright
Copyright (C) 2016-2022 Frank Wall github@moov.de

Copyright (C) 2015-2016 Paul Bailey

See the LICENSE file at the top-level directory of this distribution.
