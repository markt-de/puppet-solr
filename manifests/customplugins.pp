# @summary
#   Manages custom plugins for Solr.
#
# @api private
class solr::customplugins {
  assert_private()

  if ($solr::manage_custom_plugins and !empty($solr::custom_plugins)) {
    # Calculate a checksum to know when custom pluginshave changed. This may
    # be overkill for cases where only the sort order was changed, but this is
    # the only reliable way to identify changes in custom plugins. For
    # safekeeping, prefer to restart Solr one time too often instead of running
    # it with obsolete (and possibly incompatible) custom plugins.
    $sum = md5($solr::custom_plugins.convert_to(String))

    # Setup a directory structure where every configuration "version" (that is
    # the calculated checksum) has it's own directory. Each directory is fully
    # managed by Puppet with purge/recurse/force set to true to ensure a
    # consistent state.
    $staging_custom_plugins_dir = "${solr::staging_dir}/customplugins"
    $current_custom_plugins_dir = "${staging_custom_plugins_dir}/customplugins-${sum}"
    $current_custom_plugins_file = "${staging_custom_plugins_dir}/customplugins-${sum}.txt"

    # Create and manage staging directories. Ensure that obsolete files and
    # directories are automatically removed when they are no longer required
    # (when they are not in the catalog).
    file { $staging_custom_plugins_dir:
      ensure  => directory,
      purge   => true,
      recurse => true,
      force   => true,
      backup  => false,
    }
    ~> file { $current_custom_plugins_dir:
      ensure => directory,
      purge  => true,
      force  => true,
      backup => false,
    }
    ~> file { $current_custom_plugins_file:
      ensure  => file,
      content => $sum,
      backup  => false,
    }

    $solr::custom_plugins.map |$_tmp| {
      # The user cannot guess our hash-based staging path, so we strip the path
      # information and only use the filename.
      $_basename = basename($_tmp['creates'])
      $_creates = "${current_custom_plugins_dir}/${_basename}"

      # Guess the filename to make it more comfortable for the user. Otherwise
      # the user would need to provide yet another parameter.
      $_filename = basename($_tmp['source'])
      $_path = "${staging_custom_plugins_dir}/${_filename}"

      # Ensure that user-provided values do not conflict with what is needed
      # in order to properly manage custom plugins. Simply overwrite all
      # user-provided values for options that are required.
      $_custom_plugin = deep_merge($_tmp, {
          ensure       => present,
          path         => $_path,
          extract_path => $current_custom_plugins_dir,
          temp_dir     => $staging_custom_plugins_dir,
          cleanup      => true,
          creates      => $_creates,
          subscribe    => File[$current_custom_plugins_file],
          notify       => File[$solr::custom_plugins_dir],
      })

      # Extract or copy the custom plugin(s) to our staging directory.
      archive { $_custom_plugin['source']:
        * => $_custom_plugin,
      }
    }

    # Create and manage target directory contents. Also ensure that removed
    # plugins are re-added and that obsolete plugins are removed.
    file { $solr::custom_plugins_dir:
      ensure  => directory,
      # Copy the contents from the staging directory to Solr's custom plugins dir.
      source  => "file://${current_custom_plugins_dir}",
      # Ensure to remove all files that belong to an older configuration.
      purge   => true,
      recurse => true,
      backup  => false,
      # Solr must be restarted when adding/removing custom plugins.
      notify  => Service[$solr::service_name],
    }
  }
}
