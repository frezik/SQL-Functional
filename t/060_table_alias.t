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
use Test::More tests => 2;
use strict;
use warnings;
use SQL::Functional;

my $foo_tbl = table 'foo';
my $bar_tbl = table 'bar';
$foo_tbl->as( 'f' );
$bar_tbl->as( 'b' );

my ($sql, @sql_params) = SELECT [
        $foo_tbl->field( 'qux' ),
        $foo_tbl->field( 'quux' ),
        $bar_tbl->field( 'quuux' ),
    ],
    FROM( $foo_tbl ), 
    INNER_JOIN(
        $bar_tbl, $foo_tbl->field( 'id' ), $bar_tbl->field( 'foo_id' )
    ),
    WHERE match( $foo_tbl->field( 'baz' ), '=', 1 );
cmp_ok( $sql, 'eq', 'SELECT f.qux, f.quux, b.quuux FROM foo AS f INNER JOIN bar AS b ON f.id = b.foo_id WHERE f.baz = ?',
    'Table alias set' );
is_deeply( \@sql_params, [1], "Correct SQL params" );
