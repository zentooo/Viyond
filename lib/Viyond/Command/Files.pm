package Viyond::Command::Files;

use strict;
use warnings;

use Viyond -command;

use Viyond::InstallData::Metadata;
use Viyond::InstallData::Filelog;

use Path::Class;
use feature qw/say/;

my $vimfiles_path = Viyond::Config->get_value('vimfiles_path');

sub run {
  my ($self, $opt, $args) = @_;

  my $repo_ids = Viyond::InstallData::Metadata->find($args->[0]);

  for my $repo_id (@$repo_ids) {
    my $files = Viyond::InstallData::Filelog->load($repo_id);

    for my $file (@$files) {
      say file("$vimfiles_path/$file")->cleanup;
    }
  }
}

sub abstract {
  "show installed files of specified plugin";
}

1;
