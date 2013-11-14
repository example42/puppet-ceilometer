#
# = Class: ceilometer
#
# This class installs and manages ceilometer
#
#
# == Parameters
#
# Refer to https://github.com/stdmod for official documentation
# on the stdmod parameters used
#
class ceilometer (

  $package_name              = $ceilometer::params::package_name,
  $package_ensure            = 'present',

  $service_name              = $ceilometer::params::service_name,
  $service_ensure            = 'running',
  $service_enable            = true,

  $config_file_path          = $ceilometer::params::config_file_path,
  $config_file_replace       = $ceilometer::params::config_file_replace,
  $config_file_require       = 'Package[ceilometer]',
  $config_file_notify        = 'Service[ceilometer]',
  $config_file_source        = undef,
  $config_file_template      = undef,
  $config_file_content       = undef,
  $config_file_options_hash  = undef,

  $config_dir_path           = $ceilometer::params::config_dir_path,
  $config_dir_source         = undef,
  $config_dir_purge          = false,
  $config_dir_recurse        = true,

  $dependency_class          = undef,
  $my_class                  = undef,

  $monitor_class             = undef,
  $monitor_options_hash      = { } ,

  $firewall_class            = undef,
  $firewall_options_hash     = { } ,

  $scope_hash_filter         = '(uptime.*|timestamp)',

  $tcp_port                  = undef,
  $udp_port                  = undef,

  ) inherits ceilometer::params {


  # Class variables validation and management

  validate_bool($service_enable)
  validate_bool($config_dir_recurse)
  validate_bool($config_dir_purge)
  if $config_file_options_hash { validate_hash($config_file_options_hash) }
  if $monitor_options_hash { validate_hash($monitor_options_hash) }
  if $firewall_options_hash { validate_hash($firewall_options_hash) }

  $config_file_owner          = $ceilometer::params::config_file_owner
  $config_file_group          = $ceilometer::params::config_file_group
  $config_file_mode           = $ceilometer::params::config_file_mode

  $manage_config_file_content = default_content($config_file_content, $config_file_template)

  $manage_config_file_notify  = $config_file_notify ? {
    'class_default' => 'Service[ceilometer]',
    ''              => undef,
    default         => $config_file_notify,
  }

  if $package_ensure == 'absent' {
    $manage_service_enable = undef
    $manage_service_ensure = stopped
    $config_dir_ensure = absent
    $config_file_ensure = absent
  } else {
    $manage_service_enable = $service_enable
    $manage_service_ensure = $service_ensure
    $config_dir_ensure = directory
    $config_file_ensure = present
  }


  # Resources managed

  if $ceilometer::package_name {
    package { 'ceilometer':
      ensure   => $ceilometer::package_ensure,
      name     => $ceilometer::package_name,
    }
  }

  if $ceilometer::service_name {
    service { 'ceilometer':
      ensure     => $ceilometer::manage_service_ensure,
      name       => $ceilometer::service_name,
      enable     => $ceilometer::manage_service_enable,
    }
  }

  if $ceilometer::config_file_path {
    file { 'ceilometer.conf':
      ensure  => $ceilometer::config_file_ensure,
      path    => $ceilometer::config_file_path,
      mode    => $ceilometer::config_file_mode,
      owner   => $ceilometer::config_file_owner,
      group   => $ceilometer::config_file_group,
      source  => $ceilometer::config_file_source,
      content => $ceilometer::manage_config_file_content,
      notify  => $ceilometer::manage_config_file_notify,
      require => $ceilometer::config_file_require,
    }
  }

  if $ceilometer::config_dir_source {
    file { 'ceilometer.dir':
      ensure  => $ceilometer::config_dir_ensure,
      path    => $ceilometer::config_dir_path,
      source  => $ceilometer::config_dir_source,
      recurse => $ceilometer::config_dir_recurse,
      purge   => $ceilometer::config_dir_purge,
      force   => $ceilometer::config_dir_purge,
      notify  => $ceilometer::manage_config_file_notify,
      require => $ceilometer::config_file_require,
    }
  }


  # Extra classes

  if $ceilometer::dependency_class {
    include $ceilometer::dependency_class
  }

  if $ceilometer::my_class {
    include $ceilometer::my_class
  }

  if $ceilometer::monitor_class {
    class { $ceilometer::monitor_class:
      options_hash => $ceilometer::monitor_options_hash,
      scope_hash   => {}, # TODO: Find a good way to inject class' scope
    }
  }

  if $ceilometer::firewall_class {
    class { $ceilometer::firewall_class:
      options_hash => $ceilometer::firewall_options_hash,
      scope_hash   => {},
    }
  }

}

