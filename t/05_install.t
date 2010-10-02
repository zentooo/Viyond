use strict;
use warnings;

use Test::More;
use Path::Class;
use File::Temp;

$ENV{'HOME'} = File::Temp::tempdir;

use lib 'lib';
use Viyond::Action::Install;


# files_recursive

my $files = Viyond::Action::Install->files_recursive(file(__FILE__)->dir);
is( scalar @$files, 0, "we do not have files in t/dirs");


# clone 

my $tmpclone = File::Spec->tmpdir . "/clone_repo_viyond";
Viyond::Action::Install->clone("git://github.com/zentooo/Viyond.git", $tmpclone);
system("rm -rf $tmpclone");


# install

Viyond::Action::Install->install(+{
    username => "zentooo",
    name => "fakeplugin_dir",
    id => "repo-fakeinstall",
    description => "This repository data points Shougo's great plugin, but this description is dummy for test.",
});

ok(-d Viyond::Config->get_value('viyond_path') . "/repos/fakeplugin_dir-repo-fakeinstall", "fake repo has created");
ok(-f Viyond::Config->get_value('viyond_path') . "/filelog/fakeplugin_dir-repo-fakeinstall", "fake repo's filelog has created");
isnt(Viyond::InstallData::Metadata->load_all->{"fakeplugin_dir-repo-fakeinstall"}, undef, "feke repo metadata has created");

ok(1);


# get_vimfiles

my $tmpvim = File::Spec->tmpdir . "/vimfiles_viyond";
system("rm -rf $tmpvim");
system("mkdir $tmpvim");

my $nofiles = Viyond::Action::Install->get_vimfiles(dir($tmpvim));
is(scalar @$nofiles, 0, "tmpdir has not .vim files");

system("touch $tmpvim/I.vim");
system("touch $tmpvim/my.vim");
system("touch $tmpvim/me.vim");
system("touch $tmpvim/mine.vim");

$files = Viyond::Action::Install->get_vimfiles(dir($tmpvim));
is(scalar @$files, 4, "tmpdir has 4 .vim files");

done_testing;
