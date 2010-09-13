package M9::Command::Remove;

use strict;
use warnings;

use M9 -command;

use M9::Action::Remove;
use M9::InstallData::Metadata;
use Carp;
use feature qw/say/;

sub opt_spec {
  return (
    [ "all|a", "remove all plugins" ]
  );
}

sub run {
  my ($self, $opt, $args) = @_;

  if ($opt->{all}) {
    for (map { $_->{name} } values %{M9::InstallData::Metadata->load_all->[0]}) {
      M9::Action::Remove->remove($_);
    }
  }
  else {
    for (@$args) {
      M9::Action::Remove->remove($_);
    }
  }
}

sub abstract {
  "remove plugin specified by the name. remove all plugins by 'm9 remove -all'.";
}

1;
