use strict;
use warnings;

use Test::Most;
use Data::Util;

use lib 'lib';
use M9::InstallData::Metadata;
use M9::Action::Install;

BEGIN { use_ok '::Action::Remove' }

::Action::Install->install(+{
    username => "zentooo",
    name => "fakeplugin_dir",
    id => "repo-fakeremove",
    description => "This repository data points Shougo's great plugin, but this description is dummy for test.",
});

ok(-d M9::Config->get_value('m9_path') . "/repos/fakeplugin_dir:repo-fakeremove", "fake repo has created");

::Action::Remove->remove("fakeplugin_dir");

ok(! -d M9::Config->get_value('m9_path') . "/repos/fakeplugin_dir:repo-fakeremove", "fake repo has removed");
ok(! -f M9::Config->get_value('m9_path') . "/filelog/fakeplugin_dir:repo-fakeremove", "fake repo's filelog has removed");

is(::InstallData::Metadata->load_all->[0]->{"fakeplugin_dir:repo-fakeremove"}, undef, "feke repo metadata has removed");


ok(1);

done_testing;
