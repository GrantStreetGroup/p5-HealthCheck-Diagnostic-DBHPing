# NAME

HealthCheck::Diagnostic::DBHPing - Ping a database handle to check its health

# VERSION

version 1.2.1.1

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

This software is copyright (c) 2018 - 2019 by Grant Street Group.  No
license is granted to other entities.

# CONTRIBUTORS

- Authors:
- (17) Andrew Fresh <andrew.fresh@grantstreet.com>
- (2) Andrew Hewus Fresh <andrew.fresh@grantstreet.com>
- (1) Brandon Messineo <brandon.messineo@grantstreet.com>
- (1) Caroline Roig-Irwin <croigirw@grantstreet.com>
- Reviewers:
- (2) Brandon Messineo <brandon.messineo@grantstreet.com> 
- (1) Mark Flickinger <mark.flickinger@grantstreet.com> 
- Deployers:
- (6) Andrew Fresh <andrew.fresh@grantstreet.com>  
- (3) Brendan Byrd <brendan.byrd@grantstreet.com>  
