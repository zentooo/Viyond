use strict;

use Test::More;
use File::Spec;
use YAML::Tiny;
use File::Copy::Recursive qw/pathmk/;

use lib 'lib';
use M9::Config;
use M9::InstallData::Metadata;

# load_all
pathmk(::Config->get_value('m9_path'));

my $emptydata = M9::InstallData::Metadata->load_all;
ok($emptydata);


# save

my $git_uri = 'git://github.com/Shougo/neocomplcache.git';
my $repo_path = 'neocomplcache.git';
my $id = "repo-108625";
my $name = "neocomplcache";
my $pushed = "2010-09-06T03:56:37Z";
my $description = "Ultimate auto-completion system for Vim.";

my $repository = +{
  id => $id,
  name => $name,
  pushed => $pushed,
  description => $description,
};
::InstallData::Metadata->add_entry($git_uri, $repo_path, $repository);

my $metadata = M9::InstallData::Metadata->load_all;
my $repo = $metadata->[0]->{"$name:$id"};

is( $repo->{git_uri}, $git_uri, "github uri is equal to the original");


system('rm -f ' . M9::Config->get_value('m9_path') . '/metadata.yaml');

done_testing;
