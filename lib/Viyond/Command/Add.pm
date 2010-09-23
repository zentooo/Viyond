package Viyond::Command::Add;

use strict;
use warnings;

use Viyond -command;

use Path::Class;
use File::chdir;

use Viyond::Config;

sub run {
  my ($self, $opt, $args) = @_;

  my $vimfiles_path = Viyond::Config->get_value('vimfiles_path');
  my $viyond_path = Viyond::Config->get_value('viyond_path');

  {
    local $CWD = $vimfiles_path;
    for my $dir (dir($CWD)->children(no_hidden => 1)) {
      next unless $dir->is_dir;
      $dir =~ s/$vimfiles_path\///;
      next if $dir =~ $Viyond::Config::ignores;
      system("git add $dir/*");
    }
  }

  {
    local $CWD = $viyond_path;
    system("git add metadata.json");
    system("git add filelog/*");
  }
}

sub abstract {
  "exec 'git add' after chdir to .vim and .viyond";
}

1;
