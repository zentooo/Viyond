use strict;

use Test::More;
use Data::Dump qw/dump/;

use lib 'lib';
use Viyond::Config;

BEGIN { use_ok 'Viyond::Command::Search' }


# fetch

#::Action::Search->search("http://github.com/api/v2/json/repos/search/commenter?language=VimL");

ok(1);

done_testing;
