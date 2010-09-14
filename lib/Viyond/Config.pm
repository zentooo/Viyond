package Viyond::Config;

use strict;
use warnings;

use JSON::XS;
use Path::Class;
use Hash::Merge::Simple qw/merge/;
use File::Copy::Recursive qw/pathmk/;

use Viyond::Config;


my $config_path = "$ENV{HOME}/.viyondrc";

my $default_config = +{
  vimfiles_path => ($^O eq 'MSWin32') ? "$ENV{'HOME'}/vimfiles" : "$ENV{'HOME'}/test",
  viyond_path => ($^O eq 'MSWin32') ? "$ENV{'HOME'}/viyond" : "$ENV{'HOME'}/.test",
};

sub get_value {
  my ($class, $key) = @_;

  return $default_config->{$key} unless -e $config_path;

  my $file_config = decode_json(file($config_path)->slurp);

  my $config = merge $default_config, $file_config;

  pathmk $config->{vimfiles_path} unless -d $config->{vimfiles_path};
  pathmk $config->{viyond_path} unless -d $config->{viyond_path};

  return $config->{$key};
}

1;
