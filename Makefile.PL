use inc::Module::Install;
name 'Viyond';
all_from 'lib/Viyond.pm';

requires 'App::Cmd';
requires 'Config::Any';
requires 'Data::Util';
requires 'File::Copy::Recursive';
requires 'File::Path';
requires 'File::chdir';
requires 'HTTP::Status';
requires 'Hash::Merge::Simple';
requires 'JSON::XS';
requires 'LWP::UserAgent';
requires 'Path::Class';
requires 'Term::ANSIColor';
requires 'Try::Tiny';
requires 'YAML::Tiny';

tests 't/*.t';

install_script 'bin/viyond';

test_requires 'Test::More';
auto_include;
auto_install;
WriteAll;
