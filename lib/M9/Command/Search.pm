package M9::Command::Search;

use strict;
use warnings;

use M9 -command;

use M9::Action::Search;

my $repos_search_baseurl = "http://github.com/api/v2/json/repos/search";
my $lang_suffix = "language=VimL";


sub validate_args {
  my ($self, $opt, $args) = @_;

  if ( scalar @$args == 0 ) {
    $self->usage_error("please specify query word to search github repository");
  }

  if ( scalar @$args > 1 ) {
    $self->usage_error("we cannot search multi vim-plugins at once.");
  }
}

sub run {
  my ($self, $opt, $args) = @_;
  M9::Action::Search->search("$repos_search_baseurl/$args->[0]?$lang_suffix");
}

sub abstract {
  "search and install plugin";
}

1;
