package M9::Command::Add;

use strict;
use warnings;

use M9 -command;

use Path::Class;
use File::chdir;

use M9::Config;

sub run {
  my ($self, $opt, $args) = @_;

  my $vimfiles_path = M9::Config->get_value('vimfiles_path');
  my $m9_path = M9::Config->get_value('m9_path');

  {
    local $CWD = $vimfiles_path;
    for my $dir (dir($CWD)->children) {
      $dir =~ s/$vimfiles_path\///;
      next if $dir =~ /view/;
      system("git add $dir/*");
    }
  }

  {
    local $CWD = $m9_path;
    system("git add metadata.yaml");
    system("git add filelog/*");
  }
}

sub abstract {
  "add all vimfiles after chdir to .vim/vimfiles";
}

1;
