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
print "\nProblem 3.2 make-monitored: \n";
$pplusone = sub
{
    my $x = $_[0];
    my $result = $x + 1;
    $result
};
sub make_monitored
{
    my $fp = $_[0];
    my $callcount = 0;
    my $hmc = sub
    {
        $callcount
    };
    my $reset = sub
    {
        $callcount = 0;
    };
    my $increment = sub {$callcount = $callcount +1;};

    sub {
        my $method = $_[0];
        if($method eq hmc){return &$hmc();}
        if($method eq reset){return &$reset();}
        else{&$increment();$fp->($method)}
    }
}
$monitored_ac = make_monitored($pplusone);
print"call count should be zero: ",$monitored_ac->(hmc),"\n";
print "monitored plusone func: ",$monitored_ac->(10),"\n";
print "call count should be 1: ",$monitored_ac->(hmc),"\n";
$monitored_ac->(reset);
print "call count should be 0: ",$monitored_ac->(hmc),"\n";
print "result should be 20: ",$monitored_ac->(19),"\n";
print "call count should be 1: ",$monitored_ac->(hmc),"\n";
print "call count should be 1: ",$monitored_ac->(hmc),"\n";
print "result should be 5: ",$monitored_ac->(4),"\n";
print "call count should be 2: ",$monitored_ac->(hmc),"\n";

#Problem 3.3 modified make-account function:
print "\nProblem 3.3 modified make-account function: \n";
sub newaccount
{
    my $balance = $_[0];

    my $inquiry = sub { $balance };
    my $deposit = sub { $balance = $balance + $_[0]; };

    my $chargefee = sub { $balance -= 3; }; # "private" method
    my $withdraw = sub
    { $balance = $balance - $_[0]; &$chargefee(); };

    # return interface function:
    sub
    {
        my $method = $_[0]; # requested method
        if ($method eq withdraw) { return $withdraw; }
        if ($method eq deposit)  { return $deposit; }
        if ($method eq inquiry)  { return &$inquiry(); }
        else { die "error"; }
    }
}

my $myaccount = newaccount(500);  # the & is actually optional here.
my $youraccount = newaccount(800);