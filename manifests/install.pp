# @summary
#   Installs and prepares the Solr application.
#
# @api private
class solr::install {
  assert_private()

  include 'archive'

  file { $solr::staging_dir:
    ensure  => directory,
    recurse => true,
  }

  archive { "${solr::staging_dir}/solr-${solr::version}.tgz":
    source       => "${solr::mirror}/${solr::version}/solr-${solr::version}.tgz",
    extract      => true,
    extract_path => $solr::staging_dir,
    creates      => "${solr::staging_dir}/solr-${solr::version}",
    cleanup      => false,
  }

  user { $solr::solr_user:
    ensure     => present,
    managehome => true,
    system     => true,
    before     => Exec['run solr install script'],
  }

  if $solr::upgrade {
    $upgrade_flag = '-f'
  }
  else {
    $upgrade_flag = ''
  }

  $install_command = join([
      "${solr::staging_dir}/solr-${solr::version}/bin/install_solr_service.sh",
      "${solr::staging_dir}/solr-${solr::version}.tgz",
      "-i ${solr::extract_dir}",
      "-d ${solr::var_dir}",
      "-u ${solr::solr_user}",
      "-s ${solr::service_name}",
      "-p ${solr::solr_port}",
      '-n',
      $upgrade_flag,
  ], ' ')

  exec { 'run solr install script':
    command => $install_command,
    cwd     => "${solr::staging_dir}/solr-${solr::version}",
    creates => "${solr::extract_dir}/solr-${solr::version}",
    require => Archive["${solr::staging_dir}/solr-${solr::version}.tgz"],
  }

  file { $solr::var_dir:
    ensure  => directory,
    owner   => $solr::solr_user,
    group   => $solr::solr_user,
    recurse => true,
    require => Exec['run solr install script'],
  }

  file { $solr::log_dir:
    ensure  => directory,
    owner   => $solr::solr_user,
    group   => $solr::solr_user,
    require => Exec['run solr install script'],
  }
}
