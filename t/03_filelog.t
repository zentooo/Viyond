use strict;

use Test::Most;
use File::Spec;
use YAML::Tiny;
use File::Copy::Recursive qw/pathmk pathrm/;

use lib 'lib';
use M9::Config;
use M9::InstallData::Filelog;

# load

my $repo_id = "neocomplcache:repo-108625";

dies_ok {
  M9::InstallData::Metadata->load($repo_id);
}, "die because we do not have filelog yet";


# save

my @files = qw(t/03_filelog.t t/03_filelog.t);
::InstallData::Filelog->save($repo_id, \@files);
my $filelog = M9::InstallData::Filelog->load($repo_id);

my @filenames = map {
  my @filename_hash = split(/, /, $_);
  $filename_hash[0];
} @$filelog;

is_deeply(\@filenames, \@files);

system("rm -rf " . M9::Config->get_value('m9_path') . '/filelog/' . $repo_id);

done_testing;
