package M9::Command::Upgrade;

use strict;
use warnings;

use M9 -command;

use M9::Action::Upgrade;


sub run {
  my ($self, $opt, $args) = @_;

  my $arg_num = scalar @$args;

  if ( $arg_num == 0 ) {
    M9::Action::Upgrade->upgrade_all;
  }
  else {
    for (@$args) {
      M9::Action::Upgrade->upgrade($_);
    }
  }
}

sub abstract {
  "upgrade all plugins or plugin(s) specified by arguments";
}

1;
