package Viyond::InstallData::Filelog;

use strict;
use warnings;

use Viyond::Config;
use Path::Class;
use File::Copy::Recursive qw/pathmk/;
use Try::Tiny;
use Carp;


sub load {
  my ($class, $repo_id) = @_;

  my $filelog_dir = Viyond::Config->get_value('viyond_path') . '/filelog';
  pathmk $filelog_dir unless -d $filelog_dir;
  my @filelog;

  try {
    @filelog = file("$filelog_dir/$repo_id")->slurp('chomp' => 1);
  }
  catch {
    croak "cannot read file log from $filelog_dir/$repo_id. Did you remove it?";
  };
  return \@filelog;
}

sub save {
  my ($class, $repo_id, $files) = @_;

  my $vimfiles_path = Viyond::Config->get_value('vimfiles_path');
  my $filelog_dir = Viyond::Config->get_value('viyond_path') . '/filelog';
  pathmk $filelog_dir unless -d $filelog_dir;

  open my $filelog_fh, '>', "$filelog_dir/$repo_id" or croak "cannot open $filelog_dir/$repo_id!";

  for my $file_path (@$files) {
    $file_path =~ s/$vimfiles_path\///;
    print $filelog_fh "$file_path\n";
  }
}

1;
