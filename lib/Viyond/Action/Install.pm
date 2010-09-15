package Viyond::Action::Install;

use strict;
use warnings;

use Path::Class;
use File::Copy::Recursive qw/pathmk fcopy/;
use feature qw/say/;

use Viyond::Config;
use Viyond::InstallData::Metadata;
use Viyond::InstallData::Filelog;

use Viyond::Action::Upgrade;

my $clone_dir = Viyond::Config->get_value('viyond_path') . "/repos";
pathmk $clone_dir unless -d $clone_dir;

sub install {
  my ($class, $repository) = @_;
  my $git_uri = "git://github.com/$repository->{username}/$repository->{name}.git";
  my $repo_id = "$repository->{name}-$repository->{id}";
  my $repo_path = "$clone_dir/$repo_id";

  if ( Viyond::InstallData::Metadata->load_all->{$repo_id} ) {
    Viyond::Action::Upgrade->upgrade($repo_id);
  }
  else {
    pathmk($repo_path);

    $class->clone($git_uri, $repo_path);

    Viyond::InstallData::Metadata->add_entry($git_uri, $repository);
    $class->extract_to_vimfiles($repo_id, $repo_path);

    print "\n";
    say "Successfully Installed $repository->{name}";
  }
}

sub clone {
  my ($class, $git_uri, $repo_path) = @_;
  say "git clone from $git_uri to $repo_path";
  system "git clone $git_uri $repo_path";
}

sub extract_to_vimfiles {
  my ($class, $repo_id, $repo_path) = @_;

  my $dir = dir($repo_path);
  my $files = $class->files_recursive($dir);

  my @destinations;
  my $vimfiles_path = Viyond::Config->get_value('vimfiles_path');

  # assume that plugin puts .vim files directly, not separated by dir
  if (scalar @$files == 0 ) {
    $files = $class->get_vimfiles($dir);

    for my $file (@$files) {
      my $dest = $file;
      $dest =~ s/$repo_path//;
      $dest = "/plugin" . $dest;
      fcopy($file, $vimfiles_path . $dest);
      push @destinations, $vimfiles_path . $dest;
    }
  }
  # plugins are under directories
  else {
    for my $file (@$files) {
      my $dest = $file;
      $dest =~ s/$repo_path//;
      fcopy($file, $vimfiles_path . $dest);
      push @destinations, $vimfiles_path . $dest;
    }
  }

  Viyond::InstallData::Filelog->save($repo_id, \@destinations);
}

sub files_recursive {
  my ($class, $basepath, $depth) = @_;

  $depth ||= 0;
  my @files;

  for my $entry ($basepath->children(no_hidden => 1)) {
    if ( $entry->is_dir ) {
      push @files, @{$class->files_recursive($entry, $depth + 1)};
    }
    elsif ( ! $entry->is_dir && $depth > 0 && $entry !~ /unittest\.vim/ ) {
      push @files, $entry->stringify;
    }
  }

  return \@files;
}

sub get_vimfiles {
  my ($class, $basepath) = @_;
  my @files;

  for my $entry ($basepath->children(no_hidden => 1)) {
    if ( ! $entry->is_dir && $entry =~ /\.vim$/ && $entry !~ /unittest\.vim/ ) {
      push @files, $entry;
    }
  }

  return \@files;
}

1;
