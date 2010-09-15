package Viyond::Action::Remove;

use strict;
use warnings;

use Viyond::Config;
use Viyond::InstallData::Metadata;
use Viyond::InstallData::Filelog;
use File::Path qw/rmtree/;
use File::chdir;
use Path::Class;
use Data::Util qw/:check/;
use Carp;
use feature qw/say/;


my $vimfiles_path = Viyond::Config->get_value('vimfiles_path');

sub remove {
  my ($class, $name) = @_;

  my @repo_ids;
  my $metadata = Viyond::InstallData::Metadata->load_all;

  if ( is_string $name && $name !~ /\d+/ ) {
    @repo_ids = grep /^$name-repo-\w+$/, keys %$metadata;
  }
  elsif ( 1 <= $name && $name <= scalar keys %$metadata ) {
    @repo_ids = ([keys %$metadata]->[$name - 1]);
  }

  if ( scalar @repo_ids == 0 ) {
    say "we cannot find the vim plugin named $name";
    return;
  }

  for my $repo_id (@repo_ids) {
    say "will remove $repo_id ...";

    my $repo_path = Viyond::Config->get_value('viyond_path') . "/repos/$repo_id";
    rmtree($repo_path);

    $class->remove_vimfiles($repo_id);

    unlink Viyond::Config->get_value('viyond_path') . "/filelog/$repo_id";

    delete $metadata->{$repo_id};
  }

  Viyond::InstallData::Metadata->update($metadata);
}

sub remove_vimfiles {
  my ($class, $repo_id) = @_;

  my $files = Viyond::InstallData::Filelog->load($repo_id);
  my @not_removed;

  for my $file (@$files) {
    $class->remove_vimfile($file);
  }

  $class->purge_empty_dirs;

  return \@not_removed;
}

sub remove_vimfile {
  my ($class, $filename) = @_;
  {
    local $CWD = $vimfiles_path;
    unlink $filename;
  }
}

sub purge_empty_dirs {
  my ($class, $dir) = @_;
  my $base_dir = $dir || dir($vimfiles_path);
  my @dirs = grep { $_->is_dir } $base_dir->children;

  for (@dirs) {
    if ( scalar $_->children != 0 ) {
      $class->purge_empty_dirs($_);
    }
    rmdir $_ if scalar $_->children == 0;
  }
}

1;
