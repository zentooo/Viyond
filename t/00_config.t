use strict;
use warnings;

use Test::More;
use Data::Util;

use lib 'lib';

BEGIN { use_ok ' M9::Config' }

# test default settings

my $config_path = "$ENV{'HOME'}/.m9rc";
my @config_keys = qw/nightly force_remove/;

if ( -e $config_path ) {
  for my $key (@config_keys) {
    my $value = M9::Config->get_value($key);
    ok($value == 0 || $value == 1);
  }
}
else {
  # test default settings
  is(::Config->get_value('nightly'), 1);
  is(::Config->get_value('force_remove'), 0);
}


done_testing;
