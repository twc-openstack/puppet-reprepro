# == Class: reprepro
#
#   Configures reprepro on a server
#
# === Parameters
#
#   - *basedir*: The base directory to house the repository.
#   - *homedir*: The home directory of the reprepro user.
#
# === Example
#
#   class { 'reprepro': }
#
class reprepro (
  $basedir     = $::reprepro::params::basedir,
  $homedir     = $::reprepro::params::homedir,
  $manage_user = true,
) inherits reprepro::params {
  validate_bool($manage_user)

  package { $::reprepro::params::package_name:
    ensure => $::reprepro::params::ensure,
  }

  if $manage_user {
    group { 'reprepro':
      ensure => present,
      name   => $::reprepro::params::group_name,
      system => true,
    }

    user { 'reprepro':
      ensure     => present,
      name       => $::reprepro::params::user_name,
      home       => $homedir,
      shell      => '/bin/bash',
      comment    => 'Reprepro user',
      gid        => 'reprepro',
      managehome => true,
      system     => true,
      require    => Group['reprepro'],
      notify     => [
        File["${homedir}/.gnupg"],
        File["${homedir}/bin"],
      ],
    }
  }

  if ($basedir != $homedir) {
    file { $basedir:
      ensure  => directory,
      owner   => $::reprepro::params::user_name,
      group   => $::reprepro::params::group_name,
      mode    => '0755',
      require => User[$user_name],
    }
  }

  file { "${homedir}/.gnupg":
    ensure  => directory,
    owner   => $::reprepro::params::user_name,
    group   => $::reprepro::params::group_name,
    mode    => '0700',
  }

  file { "${homedir}/bin":
    ensure  => directory,
    mode    => '0755',
    owner   => $::reprepro::params::user_name,
    group   => $::reprepro::params::group_name,
  }
  ->
  file { "${homedir}/bin/update-distribution.sh":
    ensure  => file,
    mode    => '0755',
    content => template('reprepro/update-distribution.sh.erb'),
    owner   => $::reprepro::params::user_name,
    group   => $::reprepro::params::group_name,
  }

}

