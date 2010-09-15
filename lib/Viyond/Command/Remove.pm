package Viyond::Command::Remove;

use strict;
use warnings;

use Viyond -command;

use Viyond::Action::Remove;
use Viyond::InstallData::Metadata;
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
    for (map { $_->{name} } values %{Viyond::InstallData::Metadata->load_all}) {
      Viyond::Action::Remove->remove($_);
    }
  }
  else {
    for (@$args) {
      Viyond::Action::Remove->remove($_);
    }
  }
}

sub abstract {
  "remove plugin specified by the name. remove all plugins by 'viyond remove -all'.";
}

1;
