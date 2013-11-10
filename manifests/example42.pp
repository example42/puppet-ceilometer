# = Class: ceilometer::example42
#
# Example42 puppi additions. To add them set:
#   my_class => 'ceilometer::example42'
#
class ceilometer::example42 {

  puppi::info::module { 'ceilometer':
    packagename => $ceilometer::package_name,
    servicename => $ceilometer::service_name,
    processname => 'ceilometer',
    configfile  => $ceilometer::config_file_path,
    configdir   => $ceilometer::config_dir_path,
    pidfile     => '/var/run/ceilometer.pid',
    datadir     => '',
    logdir      => '/var/log/ceilometer',
    protocol    => 'tcp',
    port        => '5000',
    description => 'What Puppet knows about ceilometer' ,
    # run         => 'ceilometer -V###',
  }

  puppi::log { 'ceilometer':
    description => 'Logs of ceilometer',
    log         => [ '/var/log/ceilometer/ceilometer.log' ],
  }

}
