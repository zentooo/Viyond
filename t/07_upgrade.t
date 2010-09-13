use strict;
use warnings;

use Test::More;
use Data::Util;

use lib 'lib';
use Viyond::Action::Install;
use Viyond::Action::Remove;

BEGIN { use_ok '::Action::Upgrade' }


# upgrade

::Action::Install->install(+{
    username => "zentooo",
    name => "fakeplugin_dir",
    id => "repo-fakeupgrade1",
    description => "This repository data points zentooo's great plugin, but this description is dummy for test.",
});

ok(-d Viyond::Config->get_value('viyond_path') . "/repos/fakeplugin_dir:repo-fakeupgrade", "fake repo has created");

::Action::Upgrade->upgrade("fakeplugin_dir");

::Action::Remove->remove("fakeplugin_dir");


# upgrade all

::Action::Install->install(+{
    username => "zentooo",
    name => "fakeplugin_dir",
    id => "repo-fakeupgrade1",
    description => "This repository data points zentooo's great plugin, but this description is dummy for test.",
});

::Action::Install->install(+{
    username => "zentooo",
    name => "fakeplugin_file",
    id => "repo-fakeupgrade2",
    description => "This repository data points zentooo's great plugin, but this description is dummy for test.",
});

ok(-d Viyond::Config->get_value('viyond_path') . "/repos/vimproc:repo-fakeupgrade1", "fake repo has created");
ok(-d Viyond::Config->get_value('viyond_path') . "/repos/fakeplugin_file:repo-fakeupgrade2", "fake repo has created");

::Action::Upgrade->upgrade_all;

::Action::Remove->remove("vimproc");
::Action::Remove->remove("fakeplugin_file");

done_testing;
