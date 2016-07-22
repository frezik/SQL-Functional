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
package SQL::Functional;

use v5.14;
use warnings;
use SQL::Functional::FromClause;
use SQL::Functional::InnerJoinClause;
use SQL::Functional::MatchClause;
use SQL::Functional::OrderByClause;
use SQL::Functional::PlaceholderClause;
use SQL::Functional::SelectClause;
use SQL::Functional::SubSelectClause;
use SQL::Functional::TableClause;
use SQL::Functional::WhereClause;
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
    INNER_JOIN
    SUBSELECT
};
our @EXPORT = @EXPORT_OK;

# ABSTRACT: Create SQL programmatically


sub SELECT ($$@)
{
    my ($fields, @clauses) = @_;
    my $clause = SQL::Functional::SelectClause->new(
        fields => ref $fields ? $fields : [$fields],
        clauses => \@clauses,
    );
    return ($clause->to_string, $clause->get_params);
}

sub star ()
{
    return '*';
}

sub table($)
{
    my ($name) = @_;
    my $table = SQL::Functional::TableClause->new({
        name => $name,
    });
    return $table;
}

sub FROM (@)
{
    my (@tables) = @_;
    my @table_objs = map {
        ref $_ ? $_ : table $_
    } @tables;

    my $clause = SQL::Functional::FromClause->new({
        tables => \@table_objs
    });

    return $clause;
}

sub WHERE ($)
{
    my ($clause) = @_;
    my @params = $clause->params;

    my $where = SQL::Functional::WhereClause->new({
        params => \@params,
        sub_clause => $clause,
    });
    return $where;
}

sub match($$$)
{
    my ($field, $op, $value) = @_;

DEBUG: $DB::single = 1;
    my $clause_value = 
        ref($value) && $value->does( 'SQL::Functional::Clause' )
        ? $value
        : SQL::Functional::PlaceholderClause->new({
            value => $value,
        });
    my $clause = SQL::Functional::MatchClause->new({
        field => $field,
        op => $op,
        value => $clause_value,
    });
    return $clause;
}

sub ORDER_BY($;@)
{
    my (@fields) = @_;
    my $clause = SQL::Functional::OrderByClause->new({
        fields => \@fields,
    });
    return $clause;
}

sub DESC($)
{
    my ($field) = @_;
    # TODO should this be an object? It'd be consistent with everything 
    # else to make it one. Is there an argument besides consistency? 
    # Seems just fine like this so far . . . 
    return "$field DESC";
}

sub INNER_JOIN($$$)
{
    my ($table, $field1, $field2) = @_;
    my $clause = SQL::Functional::InnerJoinClause->new(
        table => $table,
        field1 => $field1,
        field2 => $field2,
    );
    return $clause;
}

sub SUBSELECT($$@)
{
    my ($fields, @clauses) = @_;
    my $clause = SQL::Functional::SubSelectClause->new(
        fields => ref $fields ? $fields : [$fields],
        clauses => \@clauses,
    );
    return $clause;
}


1;
__END__

