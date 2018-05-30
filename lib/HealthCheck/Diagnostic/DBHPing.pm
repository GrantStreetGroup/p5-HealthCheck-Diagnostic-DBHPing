package HealthCheck::Diagnostic::DBHPing;

# ABSTRACT: Ping a database handle to check its health
# VERSION

use 5.010;
use strict;
use warnings;
use parent 'HealthCheck::Diagnostic';

use Carp;

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

sub check {
    my ( $self, %params ) = @_;

    my $dbh = $params{dbh};
    $dbh ||= $self->{dbh} if ref $self;
    croak("Valid 'dbh' is required") unless $dbh and do {
        local $@; local $SIG{__DIE__}; eval { $dbh->can('ping') } };

    my $res = $self->SUPER::check( %params, dbh => $dbh );
    delete $res->{dbh};    # don't include the object in the result

    return $res;
}

sub run {
    my ( $self, %params ) = @_;
    my $dbh = $params{dbh};

    my $status     = $dbh->ping      ? "OK"         : "CRITICAL";
    my $successful = $status eq "OK" ? "Successful" : "Unsuccessful";
    my $info = "$successful ping of $dbh->{Name} as $dbh->{Username}";

    return { status => $status, info => $info };
}

1;
__END__

=head1 SYNOPSIS

    my $health_check = HealthCheck->new( checks => [
        HealthCheck::Diagnostic::DBHPing->new( dbh => $dbh )
    ] );

    my $result = $health_check->check;

Or register an on-demand C<$dbh> with a callback.

    $health_check->register( sub {
        HealthCheck::Diagnostic::DBHPing->check( dbh => connect_to_db() );
    } );

Or the same thing with a pre-built diagnostic and a custom label:

    my $diagnostic
        = HealthCheck::Diagnostic::DBHPing->new( label => 'custom' );
    $health_check->register(
        sub { $diagnostic->check( dbh => connect_to_db() ) } );

=head1 DESCRIPTION

Calls C<< dbh->ping >> and checks the truthiness of the result to
determine if the database connection is available.

=head1 ATTRIBUTES

=head2 dbh

A L<DBI database handle object|DBI/DBI-DATABSE-HANDLE-OBJECTS>.

Can be passed either to C<new> or C<check>.

=head1 DEPENDENCIES

L<HealthCheck::Diagnostic>

=head1 CONFIGURATION AND ENVIRONMENT

None
