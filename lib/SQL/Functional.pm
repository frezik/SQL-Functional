package SQL::Functional;

use v5.14;
use warnings;
use Exporter;
our @ISA = qw{ Exporter };

our @EXPORT_OK = qw{
    SELECT
    star
    FROM
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
    return( 'FROM', join( ', ', @list ) );
}

1;
__END__

