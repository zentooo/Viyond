use inc::Module::Install;
name 'Viyond';
all_from 'lib/Viyond.pm';
readme_from 'lib/Viyond.pm';

requires 'App::Cmd';
requires 'Data::Util';
requires 'File::Copy::Recursive';
requires 'File::Path';
requires 'File::chdir';
requires 'HTTP::Status';
requires 'Hash::Merge::Simple';
requires 'JSON';
requires 'LWP::UserAgent';
requires 'Path::Class';
requires 'Term::ANSIColor';
requires 'Try::Tiny';

tests 't/*.t';

install_script 'bin/viyond';

unless (can_run 'git') {
    print "*** `git` command not installed!!\n";
    exit 1;
}

test_requires 'Test::More' => '0.94';
test_requires 'File::Temp';
auto_include;
auto_install;
WriteAll;
