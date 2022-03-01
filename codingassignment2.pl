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

print "Problem 1: \n output of gcd $x and $y: ",gcd($x,$y),"\n";


#problem 2: howmany

sub howmany
{
    my($fp,@list) = @_;
    my $result; #variable to hold number
    foreach my $x (@list)
    {
        if ($fp->($x)){$result+=1;}
    }
    $result
}

$fisone = sub
{
    my $x = $_[0];
    if($x == 1){$x}else{0};
};

@three = (1,0,2,1,4,1);

print "Problem 2:\n";
print "output of howmany (should be 3): ",howmany($fisone,@three),"\n";

print "output of howmany (should be 1): ",howmany(sub{$_[0] > 3},@three),"\n";

#Problem 3: Toggle closure

sub maketoggle
{
    my $x = 0;
    sub
    {
        $_[0]
    }

}