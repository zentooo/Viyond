use strict;
use warnings;

use Test::More;
use Data::Util qw/:check/;
use File::Spec;

use lib 'lib';

BEGIN { use_ok ' Viyond::Config' }

$ENV{'HOME'} = File::Spec->tmpdir;

# test default settings

my $config_path = "$ENV{'HOME'}/.viyondrc";
my @config_keys = qw/viyond_path vimfiles_path/;

if ( -e $config_path ) {
  for my $key (@config_keys) {
    my $value = Viyond::Config->get_value($key);
    ok(is_string $value);
  }
}
else {
  # test default settings
  ok(is_string(Viyond::Config->get_value('viyond_path')));
  ok(is_string(Viyond::Config->get_value('vimfiles_path')));
}


done_testing;
