# Copyright (c) 2016  Timm Murray
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright notice, 
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright 
#       notice, this list of conditions and the following disclaimer in the 
#       documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.
package SQL::Functional::Clause;

use strict;
use warnings;
use Moose::Role;
use Moose::Util::TypeConstraints;


subtype 'SQL::Functional::Type::Literals',
    as 'ArrayRef[SQL::Functional::LiteralClause]';
coerce 'SQL::Functional::Type::Literals',
    from 'ArrayRef[Str|SQL::Functional::LiteralClause]',
    via {
        my @args = @$_;
        my @new_args = map {
            ref $_
                ? $_
                : SQL::Functional::PlaceholderClause->new({
                    literal => $_,
                });
        } @args;
        return \@new_args;
    };

subtype 'SQL::Functional::Type::Clauses',
    as 'ArrayRef[SQL::Functional::Clause]';
coerce 'SQL::Functional::Type::Clauses',
    from 'ArrayRef[Str|SQL::Functional::Clause]',
    via {
        my @args = @$_;
        my @new_args = map {
            ref $_
                ? $_
                : SQL::Functional::PlaceholderClause->new({
                    literal => $_,
                });
        } @args;
        return \@new_args;
    };


has params => (
    is => 'ro',
    isa => 'ArrayRef[Str]',
    default => sub {[]},
    auto_deref => 1,
);

requires 'to_string';

sub get_params
{
    my ($self) = @_;
    return $self->params;
}


1;
__END__


=head1 NAME

  SQL::Functional::Clause - Represents a portion of an SQL string

=head1 DESCRIPTION

A Moose role for representing SQL strings.

=head1 PROVIDED ATTRIBUTES

=head2 params

Arrayref of strings. These represent the bind parameters of your clause. 
Has C<auto_deref> set, so you can say:

  my @params = $obj->params;

Also see C<get_params()> for a method that can potentially fetch the params 
of subclauses recursively.

=head1 PROVIDED METHODS

=head1 get_params

By default, this returns the same thing as C<params>. However, since many 
clauses will need to contain other clauses, overriding this allows for a 
simple mechanism for recursively picking up the params of subclauses.

=head1 REQUIRED METHODS

=head2 to_string

Returns the SQL string that represents this clause.

=cut
