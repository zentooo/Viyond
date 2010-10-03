package Viyond;
use strict;
use warnings;
our $VERSION = '0.01';

use App::Cmd::Setup -app;

use File::Copy::Recursive qw/pathmk/;

use Viyond::Config;

sub run {
    my ($self) = shift;

    my $viyond_dir = Viyond::Config->get_value('viyond_path');
    pathmk $viyond_dir unless -d $viyond_dir;

    return $self->SUPER::run(@_);
}

1;
__END__

=head1 NAME

Viyond - Vim plugin manager which uses github as repository. It's still experimental one, so be careful to use.

=head1 SYNOPSIS

  viyond search neocomplcache   - search and install vim plugin
  viyond list                   - list all installed vim plugins with their numbers
  viyond remove neocomplcache   - remove installed plugin
  viyond remove 1               - remove installed plugin with listed number
  viyond remove -all            - remove all installed plugins
  viyond files neocomplcache    - show installed files of installed plugin
  viyond files 1                - show installed files of installed plugin with listed number
  viyond upgrade                - upgrade all installed plugins
  viyond upgrade neocomplcache  - upgrade installed plugin
  viyond upgrade 1              - upgrade installed plugin with listed number
  viyond desc neocomplcache     - print description of installed plugin
  viyond desc 1                 - print description of installed plugin with listed number
  viyond add                    - execute 'git add' after chdir to .vim and .viyond. Ignores .vim/view and .viyond/repos

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

zentooo E<lt>zentoooo@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
