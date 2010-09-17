package Viyond::Command::Desc;

use strict;
use warnings;

use Viyond -command;

use Term::ANSIColor qw/:constants/;

use Viyond::InstallData::Metadata;

sub run {
  my ($self, $opt, $args) = @_;

  $Term::ANSIColor::AUTORESET = 1;

  my $metadata = Viyond::InstallData::Metadata->load_all;
  my $repo_ids = Viyond::InstallData::Metadata->find($args->[0]);

  for my $repo_id (@$repo_ids) {
    my $repo_data = Viyond::InstallData::Metadata->load_all->{$repo_id};

    print BOLD WHITE "$repo_data->{username}/";
    print BOLD CYAN "$repo_data->{name}";
    print "\n";
    print BOLD GREEN "name: ";
    print "$repo_data->{name}\n";
    print BOLD GREEN "user: ";
    print "$repo_data->{username}\n";
    print BOLD GREEN "description: ";
    print "$repo_data->{description}\n";
    print BOLD GREEN "Web: ";
    my $web_uri = $repo_data->{git_uri};
    $web_uri =~ s/git:/http:/;
    $web_uri =~ s/\.git$//;
    print "$web_uri\n";
    print BOLD GREEN "Git: ";
    print "$repo_data->{git_uri}\n";
  }
}

sub abstract {
  "print description of installed plugin";
}

1;
