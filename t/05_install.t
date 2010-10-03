use strict;
use warnings;

use Test::More;
use Path::Class;
use File::Temp qw/tempdir/;

$ENV{'HOME'} = tempdir CLEANUP => 1;

use lib 'lib';
use Viyond::Action::Install;

sub touch {
    my $file = shift;
    unless (-e $file) {
        open my $fh, '>', $file;
        close $fh;
    }
}

# files_recursive

my $files = Viyond::Action::Install->files_recursive(file(__FILE__)->dir);
is( scalar @$files, 0, "we do not have files in t/dirs");


# clone 

my $tmpclone = tempdir(CLEANUP => 1) . "/clone_repo_viyond";
mkdir $tmpclone or die $!;
Viyond::Action::Install->clone("git://github.com/zentooo/Viyond.git", $tmpclone);


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


# get_vimfiles

my $tmpvim = tempdir(CLEANUP => 1) . "/vimfiles_viyond";
mkdir $tmpvim or die $!;

my $nofiles = Viyond::Action::Install->get_vimfiles(dir($tmpvim));
is(scalar @$nofiles, 0, "tempdir has not .vim files");

touch "$tmpvim/I.vim";
touch "$tmpvim/my.vim";
touch "$tmpvim/me.vim";
touch "$tmpvim/mine.vim";

$files = Viyond::Action::Install->get_vimfiles(dir($tmpvim));
is(scalar @$files, 4, "tempdir has 4 .vim files");

done_testing;
