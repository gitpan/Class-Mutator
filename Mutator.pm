#!/usr/bin/perl
=head1 NAME

Class::Mutator

=head1 SYNOPSIS

=head1 DESCRIPTION

Class::Mutator adds the power of 'dynamic polymorphism' to Perl objects, 
its similar to Michael Schwern's Sex.pm which he was working on around the
same time, only a little bit more predictable.

Any object that inherits Class::Mutator principally gains two new methods,
mutate and unmutate that allows them to add methods to themselves at runtime
from other packages. With most recently mutated packages having precedence
when methods are defiend in more than one package.

This module came about while i was doing some training at the BBC and someone
asked how you could do this easily, after discussion with my fellow 
London.pm'ers in particular Piers Cawley this module came about.

=head1 TODO

Lots to be done at the minute it requires the extremely useful Memoize module,
this module as always allows be to increase performance without having to think
i'm going to write some code that retains performance if Memoize is not 
installed.

I'm also going to take Michael Schwern's idea of Sex.pm choosing method 
precendence randomly and write an Agent::Sex on top of Steve Purkis' Agent
framework so we can start to do some evolutionary Agents in Perl.

=head1 METHODS

=cut

package Class::Mutator;
$VERSION=' 0.2';


use Memoize;

=head2 build_mutation_package(@package_names)

Builds the new mutation package.

=cut

sub build_mutation_package {
    # no self line, bmp would screw up memoize if it had one
    my (@ingredients) = @_;
    my($code);
    my $package_name = 'Mutator::'.join('::',@ingredients);
    $code .= "package $package_name;\n";
    @ingredients = reverse(@ingredients);
    @ingredients = map {s/__/::/g; $_}  @ingredients; 
    $code .= '@ISA = qw('.join(' ',@ingredients).");\n";  
    eval $code || die "Ack problem with mutant code ...\n$code\n";
    return $package_name;
}

=head2 build_package_list(operation,package)

Builds a new package list based on the current packages list and the
operation and package (the operation is upon) handed to this method.

=cut

sub build_package_list {
    my $self = shift;
    my ($op,$package) = @_;
    my (@ingredients);
    my ($curr);

    $curr = ref($self);

    if ($curr =~ m/^Mutator::/) {
	($curr = $curr ) =~ s/^Mutator:://;
	@ingredients = split /::/,$curr;
    } else {
	($curr = $curr) =~ s/::/__/g;
	push(@ingredients,$curr);    
    }

    @ingredients = grep !/^$package$/, @ingredients;

    if ($op eq '+') {
	($package = $package) =~ s/::/__/g;
	push(@ingredients,$package);
    } elsif ($op eq '-') {
	# We've already got this functionality out of the grep 
	# a few lines above
    } else {
	# Invalid operation
    }
 
    return @ingredients;
}

=head2 unmutate

Remove mutation abilities via a package

=cut

sub unmutate {
    my $self = shift;
    my ($package) = @_;
    return bless $self, build_mutation_package($self->build_package_list('-',$package));
}

=head2 mutate

Adds a mutation.

=cut

sub mutate {
    my $self = shift;
    my ($package) = @_;
    return bless $self, build_mutation_package($self->build_package_list('+',$package));
}

memoize('build_mutation_package');

=head1 AUTHOR

Greg McCarroll (greg@mccarroll.demon.co.uk)

=cut


1;





