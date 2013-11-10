# Class: ceilometer::params
#
# Defines all the variables used in the module.
#
class ceilometer::params {

  $extra_package_name = $::osfamily ? {
    default  => 'python-ceilometer',
  }

  $package_name = $::osfamily ? {
    'Redhat' => 'openstack-ceilometer-compute',
    default  => 'ceilometer-compute',
  }

  $service_name = $::osfamily ? {
    'Redhat' => 'openstack-ceilometer-compute',
    default  => 'ceilometer-compute',
  }

  $config_file_path = $::osfamily ? {
    default => '/etc/ceilometer/ceilometer.conf',
  }

  $config_file_mode = $::osfamily ? {
    default => '0644',
  }

  $config_file_owner = $::osfamily ? {
    default => 'root',
  }

  $config_file_group = $::osfamily ? {
    default => 'root',
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
