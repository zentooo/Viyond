use strict;
use warnings;

use Test::Most;
use Data::Util;

use lib 'lib';
use Viyond::InstallData::Metadata;
use Viyond::Action::Install;

BEGIN { use_ok 'Viyond::Action::Remove' }

Viyond::Action::Install->install(+{
    username => "zentooo",
    name => "fakeplugin_dir",
    id => "repo-fakeremove",
    description => "This repository data points Shougo's great plugin, but this description is dummy for test.",
});

ok(-d Viyond::Config->get_value('viyond_path') . "/repos/fakeplugin_dir-repo-fakeremove", "fake repo has created");

Viyond::Action::Remove->remove("fakeplugin_dir");

ok(! -d Viyond::Config->get_value('viyond_path') . "/repos/fakeplugin_dir-repo-fakeremove", "fake repo has removed");
ok(! -f Viyond::Config->get_value('viyond_path') . "/filelog/fakeplugin_dir-repo-fakeremove", "fake repo's filelog has removed");

is(Viyond::InstallData::Metadata->load_all->{"fakeplugin_dir-repo-fakeremove"}, undef, "feke repo metadata has removed");


ok(1);

done_testing;
