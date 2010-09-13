package M9::Action::Upgrade;

use strict;
use warnings;

use M9::Config;
use M9::InstallData::Metadata;
use M9::InstallData::Filelog;
use M9::Action::Install;
use M9::Action::Remove;
use File::Path qw/rmtree/;
use File::chdir;
use Carp;
use feature qw/say/;


sub upgrade {
  my ($class, $name) = @_;
  my $metadata = M9::InstallData::Metadata->load_all->[0];

  my @repo_ids = grep /^$name/, keys %$metadata;

  for my $repo_id (@repo_ids) {
    my $repo_path = M9::Config->get_value('m9_path') . "/repos/$repo_id";

    M9::Action::Remove->remove_vimfiles($repo_id);

    if ( ! -d $repo_path ) {
      M9::Action::Install->clone($metadata->{$repo_id}->{git_uri}, $repo_path);
    }
    else {
      local $CWD = $repo_path;
      say("upgrading $repo_id from github ...");
      system("git pull");
    }

    M9::Action::Install->extract_to_vimfiles($repo_id, $repo_path);
  }
}

sub upgrade_all {
  my ($class, $name) = @_;
  my $metadata = M9::InstallData::Metadata->load_all->[0];
  for my $repo_id (keys %$metadata) {
    $class->upgrade($repo_id);
  }
}

1;
