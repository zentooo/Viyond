package Viyond::InstallData::Metadata;

use strict;
use warnings;

use Viyond::Config;
use Path::Class;
use JSON;
use Data::Util qw/:check/;
use Carp;
use feature qw/say/;

my $metadata_file = Viyond::Config->get_value('viyond_path') . '/metadata.json';

sub load_all {
  my $class = shift;
  return +{} unless -f $metadata_file;
  return decode_json(file($metadata_file)->slurp);
}

sub find {
  my ($class, $query) = @_;

  my $metadata = $class->load_all();
  my @repo_ids;

  if ( is_string $query && $query !~ /^\d+$/ ) {
    @repo_ids = grep /^$query/, keys %$metadata;
  }
  elsif ( 1 <= $query && $query <= scalar keys %$metadata ) {
    @repo_ids = ([keys %$metadata]->[$query - 1]);
  }

  if ( scalar @repo_ids == 0 ) {
    say "we cannot find the vim plugin with given query";
    exit;
  }

  return \@repo_ids;
}

sub add_entry {
  my ($class, $git_uri, $repository) = @_;
  my $canonical_name = "$repository->{name}-$repository->{id}";

  my $metadata = $class->load_all();

  my $repo_data = +{
    git_uri => $git_uri,
    name => $repository->{name},
    username => $repository->{username},
    description => $repository->{description},
  };
  $metadata->{$canonical_name} = $repo_data;

  $class->update($metadata);
}

sub update {
  my ($class, $metadata) = @_;
  my $json = JSON->new;
  my $data = $json->pretty->encode($metadata);
  my $fh = file($metadata_file)->open('w') or carp "cannot write metadata to $metadata_file";
  print $fh $data;
}
