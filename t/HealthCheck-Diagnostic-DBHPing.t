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

done_testing;
