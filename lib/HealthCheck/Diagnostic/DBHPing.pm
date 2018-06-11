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

    my $driver = $dbh->{Driver}->{Name};
    my $info   = "$successful $driver ping of $dbh->{Name}";
    $info .= " as $dbh->{Username}" if $dbh->{Username};

    return { status => $status, info => $info };
}

1;
__END__

=head1 SYNOPSIS

    my $health_check = HealthCheck->new( checks => [
        HealthCheck::Diagnostic::DBHPing->new( dbh => $dbh )
    ] );

    my $result = $health_check->check;
    $result->{status}; # Returns either OK on a successful ping

Or register an on-demand C<$dbh> with a callback.

    $health_check->register( sub {
        HealthCheck::Diagnostic::DBHPing->check( dbh => connect_to_db() );
    } );

Or perform the same action with a pre-built diagnostic and a custom label:

    my $diagnostic
        = HealthCheck::Diagnostic::DBHPing->new( label => 'custom' );
    $health_check->register(
        sub { $diagnostic->check( dbh => connect_to_db() ) } );

=head1 DESCRIPTION

Determines if the database connection is available.
Sets the C<status> to "OK" or "CRITICAL" based on the
return value from C<< dbh->ping >>.

=head1 ATTRIBUTES

=head2 dbh

A L<DBI database handle object|DBI/DBI-DATABSE-HANDLE-OBJECTS>.

Can be passed either to C<new> or C<check>.

=head1 DEPENDENCIES

L<HealthCheck::Diagnostic>

=head1 CONFIGURATION AND ENVIRONMENT

None
