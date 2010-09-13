package M9::InstallData::Filelog;

use strict;
use warnings;

use M9::Config;
use Path::Class;
use File::Copy::Recursive qw/pathmk/;
use Try::Tiny;
use Carp;

my $filelog_dir = M9::Config->get_value('m9_path') . '/filelog';
my $vimfiles_path = M9::Config->get_value('vimfiles_path');
pathmk $filelog_dir unless -d $filelog_dir;

sub load {
  my ($class, $repo_id) = @_;
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

  open my $filelog_fh, '>', "$filelog_dir/$repo_id" or croak "cannot open $filelog_dir/$repo_id!";

  for my $file_path (@$files) {
    $file_path =~ s/$vimfiles_path\///;
    print $filelog_fh "$file_path\n";
  }
}
