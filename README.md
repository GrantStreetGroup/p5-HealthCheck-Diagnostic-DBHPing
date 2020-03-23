# NAME

HealthCheck::Diagnostic::DBHPing - Ping a database handle to check its health

# VERSION

version v1.2.3

# SYNOPSIS

    my $health_check = HealthCheck->new( checks => [
        HealthCheck::Diagnostic::DBHPing->new( dbh => \&connect_to_db )
    ] );

    my $result = $health_check->check;
    $result->{status}; # OK on a successful ping or CRITICAL otherwise

# DESCRIPTION

Determines if the database connection is available.
Sets the `status` to "OK" or "CRITICAL" based on the
return value from `dbh->ping`.

# ATTRIBUTES

Those inherited from ["ATTRIBUTES" in HealthCheck::Diagnostic](https://metacpan.org/pod/HealthCheck%3A%3ADiagnostic#ATTRIBUTES) plus:

## dbh

A coderef that returns a
[DBI database handle object](https://metacpan.org/pod/DBI#DBI-DATABSE-HANDLE-OBJECTS)
or optionally the handle itself.

Can be passed either to `new` or `check`.

# DEPENDENCIES

[HealthCheck::Diagnostic](https://metacpan.org/pod/HealthCheck%3A%3ADiagnostic)

# CONFIGURATION AND ENVIRONMENT

None

# AUTHOR

Grant Street Group <developers@grantstreet.com>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2018 - 2020 by Grant Street Group.

This is free software, licensed under:

    The Artistic License 2.0 (GPL Compatible)
