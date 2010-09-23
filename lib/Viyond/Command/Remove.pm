package Viyond::Command::Remove;

use strict;
use warnings;

use Viyond -command;

use Viyond::Action::Remove;
use Viyond::InstallData::Metadata;
use Carp;
use feature qw/say/;
use Data::Dump qw/dump/;


sub opt_spec {
  return (
    [ "all|a", "remove all plugins" ]
  );
}

sub run {
  my ($self, $opt, $args) = @_;

  # TODO: validate args

  if ($opt->{all}) {
    Viyond::Action::Remove->remove([map { $_->{'name'} } values %{Viyond::InstallData::Metadata->load_all}]);
  }
  else {
    Viyond::Action::Remove->remove($args);
  }
}

sub abstract {
  "remove plugin specified by the name. remove all plugins by 'viyond remove -all'.";
}

1;
