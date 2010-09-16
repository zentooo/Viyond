package Viyond::Action::Upgrade;

use strict;
use warnings;

use Viyond::Config;
use Viyond::InstallData::Metadata;
use Viyond::InstallData::Filelog;
use Viyond::Action::Install;
use Viyond::Action::Remove;
use File::Path qw/rmtree/;
use File::chdir;
use Carp;
use feature qw/say/;


sub upgrade {
  my ($class, $query) = @_;

  my $metadata = Viyond::InstallData::Metadata->load_all;
  my $repo_ids = Viyond::InstallData::Metadata->find($query);

  for my $repo_id (@$repo_ids) {
    say "will upgrade $repo_id ...";

    my $repo_path = Viyond::Config->get_value('viyond_path') . "/repos/$repo_id";

    Viyond::Action::Remove->remove_vimfiles($repo_id);

    if ( ! -d $repo_path ) {
      Viyond::Action::Install->clone($metadata->{$repo_id}->{git_uri}, $repo_path);
    }
    else {
      local $CWD = $repo_path;
      say("upgrading $repo_id from github ...");
      system("git pull");
    }

    Viyond::Action::Install->extract_to_vimfiles($repo_id, $repo_path);
  }
}

sub upgrade_all {
  my ($class, $name) = @_;
  my $metadata = Viyond::InstallData::Metadata->load_all;
  for my $repo_id (keys %$metadata) {
    $class->upgrade($repo_id);
  }
}

1;
