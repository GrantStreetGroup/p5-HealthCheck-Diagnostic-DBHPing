use GSG::Gitc::CPANfile $_environment;

requires 'HealthCheck::Diagnostic';

test_requires 'Test::Strict';
test_requires 'DBI';
test_requires 'DBD::SQLite';

1;
on develop => sub {
    requires 'Dist::Zilla::PluginBundle::Author::GSG::Internal';
};
