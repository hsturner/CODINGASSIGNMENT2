#!/usr/bin/perl
#use strict;
#use warnings FATAL => 'all';


#problem 1: GCD
sub gcd
{
    my ($x,$y) = @_;
    while(($x!=0) && ($y!=0))
    {
        if ($x>$y) {$x=$x%$y;} else{$y=$y%$x;}
    }
    $x+$y;

}

$x = 4;
$y = 2;

print "Problem 1: \ngcd output of $x and $y: ",gcd($x,$y),"\n";


#problem 2: howmany

sub howmany
{

}


