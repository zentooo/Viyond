use strict;

use Test::More;
use File::Spec;
use YAML::Tiny;
use File::Copy::Recursive qw/pathmk/;

use lib 'lib';
use Viyond::Config;
use Viyond::InstallData::Metadata;

# load_all
pathmk(Viyond::Config->get_value('viyond_path'));

my $emptydata = Viyond::InstallData::Metadata->load_all;
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
Viyond::InstallData::Metadata->add_entry($git_uri, $repository);

my $metadata = Viyond::InstallData::Metadata->load_all;
my $repo = $metadata->{"$name-$id"};

is( $repo->{git_uri}, $git_uri, "github uri is equal to the original");


system('rm -f ' . Viyond::Config->get_value('viyond_path') . '/metadata.json');

done_testing;
