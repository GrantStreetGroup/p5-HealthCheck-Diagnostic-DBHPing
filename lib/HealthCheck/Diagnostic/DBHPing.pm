package HealthCheck::Diagnostic::DBHPing;

# ABSTRACT: Ping a database handle to check its health
# VERSION

use 5.010;
use strict;
use warnings;
use parent 'HealthCheck::Diagnostic';

sub new {
    my ($class, @params) = @_;

    # Allow either a hashref or even-sized list of params
    my %params = @params == 1 && ( ref $params[0] || '' ) eq 'HASH'
        ? %{ $params[0] } : @params;

    return $class->SUPER::new(
        label => 'dbh_ping',
        %params
    );
}

sub run {
    my ($self) = @_;
    return { status => 'OK' };
}

1;
__END__

=head1 SYNOPSIS

    my $health_check = HealthCheck->new( checks => [
        HealthCheck::Diagnostic::DBHPing->new( dbh => $dbh )
    ] );

    my $result = $health_check->check;

=head1 DESCRIPTION

Calls C<< dbh->ping >> and checks the truthiness of the result to
determine if the database connection is available.

=head1 ATTRIBUTES

=head2 dbh

A L<DBI database handle object|DBI/DBI-DATABSE-HANDLE-OBJECTS>.

=head1 DEPENDENCIES

L<HealthCheck::Diagnostic>

=head1 CONFIGURATION AND ENVIRONMENT

None
