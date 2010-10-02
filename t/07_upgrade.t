use strict;
use warnings;

use Test::More;
use Data::Util;
use File::Spec;

use lib 'lib';
use Viyond::Action::Install;
use Viyond::Action::Remove;

$ENV{'HOME'} = File::Spec->tmpdir;

BEGIN { use_ok 'Viyond::Action::Upgrade' }

# upgrade

Viyond::Action::Install->install(+{
    username => "zentooo",
    name => "fakeplugin_dir",
    id => "repo-fakeupgrade",
    description => "This repository data points zentooo's great plugin, but this description is dummy for test.",
});

ok(-d Viyond::Config->get_value('viyond_path') . "/repos/fakeplugin_dir-repo-fakeupgrade", "fake repo has created");

Viyond::Action::Upgrade->upgrade("fakeplugin_dir");

Viyond::Action::Remove->remove(["fakeplugin_dir"]);


# upgrade all

Viyond::Action::Install->install(+{
    username => "zentooo",
    name => "fakeplugin_dir",
    id => "repo-fakeupgrade1",
    description => "This repository data points zentooo's great plugin, but this description is dummy for test.",
});

Viyond::Action::Install->install(+{
    username => "zentooo",
    name => "fakeplugin_file",
    id => "repo-fakeupgrade2",
    description => "This repository data points zentooo's great plugin, but this description is dummy for test.",
});

ok(-d Viyond::Config->get_value('viyond_path') . "/repos/fakeplugin_dir-repo-fakeupgrade1", "fake repo has created");
ok(-d Viyond::Config->get_value('viyond_path') . "/repos/fakeplugin_file-repo-fakeupgrade2", "fake repo has created");

Viyond::Action::Upgrade->upgrade_all;

Viyond::Action::Remove->remove(["fakeplugin_dir"]);
Viyond::Action::Remove->remove(["fakeplugin_file"]);

done_testing;
