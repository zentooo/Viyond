package M9::Command::List;

use strict;
use warnings;

use M9 -command;

use Term::ANSIColor qw/:constants/;

use M9::InstallData::Metadata;

sub run {
  my ($self, $opt, $args) = @_;

  my $metadata = M9::InstallData::Metadata->load_all->[0];

  $Term::ANSIColor::AUTORESET = 1;

  for my $repo_data (values %$metadata) {
    print BOLD BLUE "$repo_data->{username}/";
    print BOLD WHITE "$repo_data->{name}";
    print " - $repo_data->{description}\n";
  }
}

sub abstract {
  "list all installed plugins";
}

1;
