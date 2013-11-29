# Class: ceilometer::params
#
# Defines all the variables used in the module.
#
class ceilometer::params {

  $package_name = $::osfamily ? {
    'RedHat' => 'openstack-ceilometer-common',
    default  => 'ceilometer-common',
  }

  $service_name = $::osfamily ? {
    default  => '',
  }

  $config_file_path = $::osfamily ? {
    default => '/etc/ceilometer/ceilometer.conf',
  }

  $config_file_mode = $::osfamily ? {
    default => '0644',
  }

  $config_file_owner = $::osfamily ? {
    default => 'ceilometer',
  }

  $config_file_group = $::osfamily ? {
    default => 'ceilometer',
  }

  $config_dir_path = $::osfamily ? {
    default => '/etc/ceilometer',
  }

  case $::osfamily {
    'Debian','RedHat','Amazon': { }
    default: {
      fail("${::operatingsystem} not supported. Review params.pp for extending support.")
    }
  }
}
