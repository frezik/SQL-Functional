package SQL::Functional::SetClause;
use v5.14;
use warnings;
use Moose;
use namespace::autoclean;
use SQL::Functional::SetClause;

with 'SQL::Functional::Clause';

has clauses => (
    is => 'ro',
    isa => 'ArrayRef[SQL::Functional::MatchClause]',
    required => 1,
    auto_deref => 1,
);


sub to_string
{
    my ($self) = @_;
    my @clauses = $self->clauses;
    my $str = 'SET ' . join( ', ', map $_->to_string, @clauses );
    return $str;
}

sub get_params
{
    my ($self) = @_;
    return map { $_->get_params } $self->clauses;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

