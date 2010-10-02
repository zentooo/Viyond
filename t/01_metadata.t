use strict;

use Test::More;
use YAML::Tiny;
use File::Copy::Recursive qw/pathmk/;

use Data::Util qw/:check/;
use File::Temp;

use lib 'lib';
use Viyond::Config;
use Viyond::InstallData::Metadata;


$ENV{'HOME'} = File::Temp::tempdir;


my $git_uri = 'git://github.com/zentooo/fakeplugin_dir.git';
my $repo_path = 'fakeplugin_dir.git';
my $id = "repo-fakemetadata";
my $name = "fakeplugin_dir";
my $pushed = "2010-09-06T03:56:37Z";
my $description = "Ultimate auto-completion system for Vim.";


sub create_neocom_metadata {

  my $repository = +{
    id => $id,
    name => $name,
    pushed => $pushed,
    description => $description,
  };
  Viyond::InstallData::Metadata->add_entry($git_uri, $repository);
}


# load_all

pathmk(Viyond::Config->get_value('viyond_path'));

my $original_metadata = Viyond::InstallData::Metadata->load_all;
ok(is_hash_ref $original_metadata);


# update

Viyond::InstallData::Metadata->update($original_metadata);

my $metadata = Viyond::InstallData::Metadata->load_all;

is_deeply($original_metadata, $metadata);


# add_entry

create_neocom_metadata;

my $new_metadata = Viyond::InstallData::Metadata->load_all;

my $repo = $new_metadata->{"$name-$id"};

is( $repo->{git_uri}, $git_uri, "github uri is equal to the original");

Viyond::InstallData::Metadata->update($original_metadata);


# find

create_neocom_metadata;

my $repo_ids = Viyond::InstallData::Metadata->find($name);
is(scalar @$repo_ids, 1, "find 1 fakeplugin_dir");

Viyond::InstallData::Metadata->update($original_metadata);


done_testing;
