use strict;
use warnings;

use Test::More;
use Path::Class;

use lib 'lib';
use Viyond::Action::Install;

# files_recursive(

my $files = Viyond::Action::Install->files_recursive(file(__FILE__)->dir);
is( scalar @$files, 0, "we do not have files in t/dirs");


# install

Viyond::Action::Install->install(+{
    username => "zentooo",
    name => "fakeplugin_dir",
    id => "repo-fakeinstall",
    description => "This repository data points Shougo's great plugin, but this description is dummy for test.",
});

ok(-d Viyond::Config->get_value('viyond_path') . "/repos/fakeplugin_dir:repo-fakeinstall", "fake repo has created");
ok(-f Viyond::Config->get_value('viyond_path') . "/filelog/fakeplugin_dir:repo-fakeinstall", "fake repo's filelog has created");
isnt(Viyond::InstallData::Metadata->load_all->[0]->{"fakeplugin_dir:repo-fakeinstall"}, undef, "feke repo metadata has created");

ok(1);

done_testing;
