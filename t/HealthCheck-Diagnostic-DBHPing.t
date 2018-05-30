use strict;
use warnings;
use Test::More;

use HealthCheck::Diagnostic::DBHPing;

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


my $fake_dbh = My::Fake::DBI->new;
$My::Fake::DBI::success = "0 but true";

is_deeply( HealthCheck::Diagnostic::DBHPing->new( dbh => $fake_dbh )->check, {
    label  => 'dbh_ping',
    status => 'OK',
    info   => "Successful ping of FakeDSN as FakeUsername",
}, "OK status as expected" );

$My::Fake::DBI::success = 0;
is_deeply( HealthCheck::Diagnostic::DBHPing->check( dbh => $fake_dbh ), {
    status => 'CRITICAL',
    info   => "Unsuccessful ping of FakeDSN as FakeUsername",
}, "CRITICAL status as expected" );

done_testing;

package My::Fake::DBI;

our $success;
sub new {
    bless {
        Name     => 'FakeDSN',
        Username => 'FakeUsername',
        Driver   => { Name => 'FakeDriver' }
    }, $_[0];
}
sub ping { return $success }
