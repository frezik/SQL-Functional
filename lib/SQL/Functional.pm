package SQL::Functional;

use v5.14;
use warnings;
use Exporter;
our @ISA = qw{ Exporter };

our @EXPORT_OK = qw{
    SELECT
    star
    FROM
    WHERE
    match
    table
    ORDER_BY
    DESC
};
our @EXPORT = @EXPORT_OK;

# ABSTRACT: Create SQL through abstract functions


sub SELECT ($@)
{
    my ($fields, @substrs) = @_;

    if( ref($fields) eq 'ARRAY' ) {
        unshift @substrs, join( ', ', @$fields );
    }
    else {
        unshift @substrs, $fields;
    }

    return join ' ', 'SELECT', @substrs;
}

sub star ()
{
    return '*';
}

sub FROM (@)
{
    my (@list) = @_;
    return 'FROM ' . join( ', ', @list );
}

sub WHERE ($)
{
    my ($clause) = @_;
    return "WHERE $clause";
}

sub match($$$)
{
    my ($field, $op, $value) = @_;
    return "$field $op ?";
}

sub table($)
{
    my ($name) = @_;
    return $name;
}

sub ORDER_BY($;@)
{
    my (@fields) = @_;
    return "ORDER BY " . join( ', ', @fields );
}

sub DESC($)
{
    my ($field) = @_;
    return "$field DESC";
}


1;
__END__

