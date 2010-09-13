package M9::Config;

use strict;
use warnings;

use Config::Any;
use YAML::Tiny;

use M9::Config;


my $config_path = "$ENV{HOME}/.m9rc";

sub get_value {
  my ($class, $key) = @_;

  my $default = sub {
    my $conf = shift;

    # default settings
    $conf->{vimfiles_path} ||= ($^O eq 'MSWin32') ? "$ENV{'HOME'}/vimfiles" : "$ENV{'HOME'}/.vim";
    $conf->{m9_path} ||= ($^O eq 'MSWin32') ? "$ENV{'HOME'}/m9" : "$ENV{'HOME'}/.m9";

    return $conf;
  };

  return $default->(+{})->{$key} unless -e $config_path;

  my $config = Config::Any->load_files(
    +{
      files => [$config_path],
      filter => $default,
      force_plugins => ['Config::Any::YAML']
    }
  );

  return $config->[0]->{$config_path}->{$key};
}

1;
