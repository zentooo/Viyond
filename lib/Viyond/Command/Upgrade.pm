package Viyond::Command::Upgrade;

use strict;
use warnings;

use Viyond -command;

use Viyond::Action::Upgrade;


sub run {
  my ($self, $opt, $args) = @_;

  my $arg_num = scalar @$args;

  if ( $arg_num == 0 ) {
    Viyond::Action::Upgrade->upgrade_all;
  }
  else {
    for (@$args) {
      Viyond::Action::Upgrade->upgrade($_);
    }
  }
}

sub abstract {
  "upgrade all plugins or plugin(s) specified by arguments";
}

1;
