package Viyond::Command::List;

use strict;
use warnings;

use Viyond -command;

use Term::ANSIColor qw/:constants/;

use Viyond::InstallData::Metadata;

sub run {
  my ($self, $opt, $args) = @_;

  my $metadata = Viyond::InstallData::Metadata->load_all;

  $Term::ANSIColor::AUTORESET = 1;

  my $repos_num = 1;

  for my $repo_data (values %$metadata) {
    print BOLD WHITE ON_BLUE $repos_num;
    print " ";
    print BOLD WHITE "$repo_data->{username}/";
    print BOLD CYAN "$repo_data->{name}";
    print " - $repo_data->{description}\n";
    $repos_num++;
  }
}

sub abstract {
  "list all installed plugins";
}

1;
