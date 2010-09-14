package Viyond::InstallData::Metadata;

use strict;
use warnings;

use Viyond::Config;
use YAML::Tiny;
use Carp;

my $metadata_file = Viyond::Config->get_value('viyond_path') . '/metadata.yaml';

sub load_all {
  my $class = shift;
  return YAML::Tiny->read($metadata_file) || YAML::Tiny->new();
}

sub add_entry {
  my ($class, $git_uri, $repository) = @_;
  my $canonical_name = "$repository->{name}:$repository->{id}";

  my $metadata = $class->load_all();

  my $repo_data = +{
    git_uri => $git_uri,
    name => $repository->{name},
    username => $repository->{username},
    description => $repository->{description},
  };
  $metadata->[0]->{$canonical_name} = $repo_data;

  $metadata->write($metadata_file) or carp "cannot write metadata to $metadata_file";
}

sub update {
  my ($class, $metadata) = @_;
  my $realdata = YAML::Tiny->new;
  $realdata->[0] = $metadata;
  $realdata->write($metadata_file) or carp "cannot write metadata to $metadata_file";
}
