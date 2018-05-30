use strict;
use warnings;
use Test::More;

use HealthCheck::Diagnostic::DBHPing;
use DBI;
use DBD::SQLite;

eval { HealthCheck::Diagnostic::DBHPing->check };
is $@, sprintf( "Valid 'dbh' is required at %s line %d.\n",
    __FILE__, __LINE__ - 2 );

eval { HealthCheck::Diagnostic::DBHPing->new->check };
is $@, sprintf( "Valid 'dbh' is required at %s line %d.\n",
    __FILE__, __LINE__ - 2 );

eval { HealthCheck::Diagnostic::DBHPing->new( dbh => {} )->check };
is $@, sprintf( "Valid 'dbh' is required at %s line %d.\n",
    __FILE__, __LINE__ - 2 );

eval { HealthCheck::Diagnostic::DBHPing->check( dbh => bless {} ) };
is $@, sprintf( "Valid 'dbh' is required at %s line %d.\n",
    __FILE__, __LINE__ - 2 );


my $dbname = 'dbname=:memory:';
my $dbh = DBI->connect("dbi:SQLite:$dbname","","");

is_deeply( HealthCheck::Diagnostic::DBHPing->new( dbh => $dbh )->check, {
    label  => 'dbh_ping',
    status => 'OK',
    info   => "Successful ping of $dbname",
}, "OK status as expected" );

$dbh->disconnect;
is_deeply( HealthCheck::Diagnostic::DBHPing->check( dbh => $dbh ), {
    status => 'CRITICAL',
    info   => "Unsuccessful ping of dbname=:memory:",
}, "CRITICAL status as expected" );

# Now try it with a username
$dbh = DBI->connect("dbi:SQLite:$dbname","FakeUser","");

is_deeply( HealthCheck::Diagnostic::DBHPing->new( dbh => $dbh )->check, {
    label  => 'dbh_ping',
    status => 'OK',
    info   => "Successful ping of $dbname as FakeUser",
}, "OK status as expected" );

$dbh->disconnect;
is_deeply( HealthCheck::Diagnostic::DBHPing->check( dbh => $dbh ), {
    status => 'CRITICAL',
    info   => "Unsuccessful ping of $dbname as FakeUser",
}, "CRITICAL status as expected" );

done_testing;

