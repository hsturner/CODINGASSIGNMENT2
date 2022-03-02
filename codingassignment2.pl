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

print "\nProblem 2:\n";
print "output of howmany (should be 3): ",howmany($fisone,@three),"\n";

print "output of howmany (should be 1): ",howmany(sub{$_[0] > 3},@three),"\n";

#Problem 3: Toggle closure
print"\nProblem 3: Toggle\n";
sub maketoggle
{
    my $x = 0;
    sub
    {
        $x = 1-$x;
        $x
    }

}

$toggle1 = maketoggle();

$toggle2 = maketoggle();

print "toggle1: ",$toggle1->(),"\n";
print "toggle1: ",$toggle1->(),"\n";
print "toggle2: ",$toggle2->(),"\n";
print "toggle1: ",$toggle1->(),"\n";
print "toggle2: ",$toggle2->(),"\n";

#Problem 3.1 accumulator :
print "\nProblem 3.1 Accumulator: \n";

sub make_accumulator
{
    my $x = 0;
    sub
    {
        $x += $_[0];
        $x
    }
}
$ac1 = make_accumulator();
$ac2 = make_accumulator();
print "accumulator 1: ",$ac1->(10),"\n";
print "accumulator 2: ",$ac2->(10),"\n";
print "accumulator 1: ",$ac1->(5),"\n";
print "accumulator 2: ",$ac2->(1),"\n";

#problem 3.2 make-monitored