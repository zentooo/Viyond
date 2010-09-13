use strict;
use warnings;

use Test::More;
use Path::Class;

use lib 'lib';
use M9::Action::Install;

# files_recursive(

my $files = M9::Action::Install->files_recursive(file(__FILE__)->dir);
is( scalar @$files, 0, "we do not have files in t/dirs");


# install

::Action::Install->install(+{
    username => "zentooo",
    name => "fakeplugin_dir",
    id => "repo-fakeinstall",
    description => "This repository data points Shougo's great plugin, but this description is dummy for test.",
});

ok(-d M9::Config->get_value('m9_path') . "/repos/fakeplugin_dir:repo-fakeinstall", "fake repo has created");
ok(-f M9::Config->get_value('m9_path') . "/filelog/fakeplugin_dir:repo-fakeinstall", "fake repo's filelog has created");
isnt(::InstallData::Metadata->load_all->[0]->{"fakeplugin_dir:repo-fakeinstall"}, undef, "feke repo metadata has created");

ok(1);

done_testing;
