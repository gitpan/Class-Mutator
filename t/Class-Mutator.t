#!perl

use strict;
use Test::More tests => 7;
BEGIN { use_ok('Class::Mutator'); }

package Princess;
sub new { return bless {}, $_[0] }
sub go_to_ball { return 'before midnight' }

package Frog;
use Class::Mutator;
our @ISA=qw( Class::Mutator );
sub new { return bless {}, $_[0] }
sub ribbit { return 'ribbit' }


package main;

my $f = Frog->new();
my $p = Princess->new();

ok($f->can('ribbit'),'frog can ribbit at the start');
ok(!($f->can('go_to_ball')),'frog cannot go_to_ball at the start');

$f->mutate('Princess');

ok($f->can('ribbit'),'frog can ribbit still');
ok($f->can('go_to_ball'),'frog can go_to_ball');

$f->unmutate('Princess');

ok($f->can('ribbit'),'frog can ribbit at the end');
ok(!($f->can('go_to_ball')),'frog cannot go_to_ball at the end');
