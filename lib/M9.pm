package M9;
use strict;
use warnings;
our $VERSION = '0.01';

use App::Cmd::Setup -app;

use File::Copy::Recursive qw/pathmk/;

use M9::Config;

my $m9_dir = M9::Config->get_value('m9_path');
pathmk $m9_dir unless -d $m9_dir;

1;
__END__

=head1 NAME

M9 - Vim plugin manager which uses github as repository.

=head1 SYNOPSIS

  m9 search neocomplcache   - search and install vim plugin
  m9 list                   - list all installed vim plugins
  m9 remove neocomplcache   - remove existing plugin
  m9 remove -all            - remove all existing plugins
  m9 upgrade                - upgrade all existing plugins
  m9 upgrade neocomplcache  - upgrade specified plugin
  m9 add                    - execute 'git add' after chdir to .vim and .m9 with ignoring .vim/view

=head1 DESCRIPTION

M9 is Vim plugin manager. It uses github as a repository for searching, installing and upgrading plugins.
It also privides functions as removing and listing vim plugins installed via m9 command.

=head1 AUTHOR

zentooo E<lt>ankerasoy@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 TODO

make a github repository just to test installing, upgrading and removing
implement pathogen mode

=cut
