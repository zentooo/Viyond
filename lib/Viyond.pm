package Viyond;
use strict;
use warnings;
our $VERSION = '0.01';

use App::Cmd::Setup -app;

use File::Copy::Recursive qw/pathmk/;

use Viyond::Config;

my $viyond_dir = Viyond::Config->get_value('viyond_path');
pathmk $viyond_dir unless -d $viyond_dir;

1;
__END__

=head1 NAME

Viyond - Vim plugin manager which uses github as repository. It's still experimental one, so be careful to use.

=head1 SYNOPSIS

  viyond search neocomplcache   - search and install vim plugin
  viyond list                   - list all installed vim plugins
  viyond remove neocomplcache   - remove existing plugin
  viyond remove -all            - remove all existing plugins
  viyond upgrade                - upgrade all existing plugins
  viyond upgrade neocomplcache  - upgrade specified plugin
  viyond add                    - execute 'git add' after chdir to .vim and .viyond with ignoring .vim/view

=head1 DESCRIPTION

Viyond is Vim plugin manager, inspired by Vimana and Yaourt. It uses github as a repository for searching, installing and upgrading plugins.
It also privides functions as removing and listing vim plugins installed.
Currently it does not support vim-plugin management style with pathogen and git submodule.

=head1 CONFIGURATION

You can use Viyond with your own config file ($HOME/.viyondrc) with JSON format.

{
  "viyond_path": "/home/neko/.viyond",
  "vimfiles_path": "/home/neko/.vim"
}

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
