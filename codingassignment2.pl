#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';


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
sub gcdTest{
    print "Problem 1 GCD: \n";
    my $x = 4;
    my $y = 2;
    print "GCD of $x and $y: ", gcd($x, $y), "\n";
}

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

my $fisone = sub
{
    my $x = $_[0];
    if($x == 1){$x}else{0};
};
sub howmanyTest{
    print"\nProblem 2 howmany: \n";
    my @three = (1, 0, 2, 1, 4, 1);
    print "output of howmany (should be 3): ", howmany($fisone, @three), "\n";
    print "output of howmany (should be 1): ", howmany(sub {$_[0] > 3}, @three), "\n";
}

#Problem 3: Toggle closure

sub maketoggle
{
    my $x = 0;
    sub
    {
        $x = 1-$x;
        $x
    }

}

sub makeToggleTest{
    print"\nProblem 3: Toggle\n";
    my $toggle1 = maketoggle();
    my $toggle2 = maketoggle();
    print "toggle1: ", $toggle1->(), "\n";
    print "toggle1: ", $toggle1->(), "\n";
    print "toggle2: ", $toggle2->(), "\n";
    print "toggle1: ", $toggle1->(), "\n";
    print "toggle2: ", $toggle2->(), "\n";
}

#Problem 3.1 accumulator :


sub make_accumulator
{
    my $x = 0;
    sub
    {
        $x += $_[0];
        $x
    }
}
sub make_accumulatorTest {
    print "\nProblem 3.1 Accumulator: \n";
    my $ac1 = make_accumulator();
    my $ac2 = make_accumulator();
    print "accumulator 1: ", $ac1->(10), "\n";
    print "accumulator 2: ", $ac2->(10), "\n";
    print "accumulator 1: ", $ac1->(5), "\n";
    print "accumulator 2: ", $ac2->(1), "\n";
}
#problem 3.2 make-monitored

my $pplusone = sub
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
        if($method eq "hmc"){return &$hmc();}
        if($method eq "reset"){return &$reset();}
        else{&$increment();$fp->($method)}
    }
}
sub make_monitoredTest {
    print "\nProblem 3.2 make-monitored: \n";
    my $monitored_ac = make_monitored($pplusone);
    print "Call count should be zero: ", $monitored_ac->("hmc"), "\n";
    print "Monitored plusone(10) func (expected 11): ", $monitored_ac->(10), "\n";
    print "Call count should be 1: ", $monitored_ac->("hmc"), "\n";
    $monitored_ac->("reset");
    print "Resetting call count\nCall count should be 0: ", $monitored_ac->("hmc"), "\n";
    print "Monitored plusone(19) (expected 20): ", $monitored_ac->(19), "\n";
    print "Call count should be 1: ", $monitored_ac->("hmc"), "\n";
    print "Call count should be 1: ", $monitored_ac->("hmc"), "\n";
    print "Monitored plusone(4) (expected 5): ", $monitored_ac->(4), "\n";
    print "Call count should be 2 after previous call: ", $monitored_ac->("hmc"), "\n";
}

#Problem 3.3 modified make-account function:


sub newaccount
{
    my ($balance,$secretpassword)= @_;
    my $inquiry = sub { $balance };
    my $deposit = sub { $balance = $balance + $_[0]; };
    my $chargefee = sub { $balance -= 3; }; # "private" method
    my $withdraw = sub
    { $balance = $balance - $_[0]; &$chargefee(); };
    my $passcheck = sub {$secretpassword};
    my $interface = sub
    {
        my $imethod = $_[0];
        if($imethod eq "passcheck"){return &$passcheck();}
        if ($imethod eq "withdraw") { return $withdraw; }
        if ($imethod eq "deposit")  { return $deposit; }
        if ($imethod eq "inquiry") { return &$inquiry();}
        else{ die "error";}
    };
    # return interface function:
    sub
    {
        my $suppliedpass = $_[0];
        my $method = $_[1];
        if($suppliedpass eq $secretpassword)
        {
            return $interface->($method);
        }
        else{ my $error = "Wrong password"; return $error}
    }

}#newaccount
sub passwordprotectedtest {
    print "\nProblem 3.3 modified make-account function: \n";
    my $myaccount = newaccount(500, "password1"); # the & is actually optional here.
    my $youraccount = newaccount(800, "password2");
    print "checking balance: should be 500: ", $myaccount->("password1", "inquiry"), "\n";
    print "checking wrong password, should print wrong password: ", $myaccount->("password2", "inquiry"), "\n";
    print "checking withdraw: \n";
    $myaccount->("password1", "withdraw")->(30);
    print "balance should be 467: ", $myaccount->("password1", "inquiry"), "\n";
    $myaccount->("password1", "withdraw")->(30);
    print "balance should be 434: ", $myaccount->("password1", "inquiry"), "\n";
    print "Accessing second account....\nSuccess if output is 800: ",&$youraccount("password2","inquiry");
}

#problem 3.4 call the cops


sub newaccountcop
{
    my ($balance,$secretpassword)= @_;
    my $fuckups = 0;
    my $inquiry = sub { $balance };
    my $deposit = sub { $balance = $balance + $_[0]; };
    my $chargefee = sub { $balance -= 3; }; # "private" method
    my $withdraw = sub
    { $balance = $balance - $_[0]; &$chargefee(); };
    my $passcheck = sub {$secretpassword};
    my $callthecops = sub
    {
        #print "should be calling the cops!\n";
        my $message = "You've entered the wrong password too many times! I'm calling the cops!\n";
        print $message;
    };
    my $fuckuphandler = sub
    {
        $fuckups+=1;
        #print "current fuckups: ",$fuckups,"\n";
        my $fuckuplimit = 7;
        my $errlim = $fuckuplimit - $fuckups;
        if($fuckups eq $fuckuplimit){&$callthecops}
        else{my $error = "You've entered the wrong password! Attempts left: $errlim\n"; print $error;}
    }; #private method

    my $interface = sub
    {
        my $imethod = $_[0];
        if ($imethod eq "passcheck"){return &$passcheck();}
        if ($imethod eq "withdraw") { return $withdraw; }
        if ($imethod eq "deposit")  { return $deposit; }
        if ($imethod eq "inquiry") { return &$inquiry();}
            #else{ die "error";}
    };
    # return interface function:
    sub
    {
        my $suppliedpass = $_[0];
        my $method = $_[1];
        if($suppliedpass eq $secretpassword)
        {
            return $interface->($method);
        }else{
            &$fuckuphandler;
        }
    }
}#newacountcop
sub coptest {
    print "\nProblem 3.4 Call the cops: \n";
    my $copaccount = newaccountcop(500, "easypass");
    print "Inquiring about cop account using incorrect password: \n";
    $copaccount->("notpass", "inquiry");
    $copaccount->("notpass", "inquiry");
    $copaccount->("notpass", "inquiry");
    $copaccount->("notpass", "inquiry");
    $copaccount->("notpass", "inquiry");
    $copaccount->("notpass", "inquiry");
    $copaccount->("notpass", "inquiry");
}

#problem 3.7 Joint accounts

sub makejoin
{
    my($acp,$curpass,$newpass) = @_;
    &$acp($curpass,$newpass);


}

sub jointaccount
{
    my ($balance, $secretpassword) = @_;
    my @passlist;



    #when implementing new pass, add an entry to the hashtable with the name "pass+#ofentriesinhashtable+1"
    #so name will be automated and will increase for each entry
    #therefore need a function to get the size of the hash array when adding a new entry to the array


    my $fuckups = 0;
    my $inquiry = sub {$balance};
    my $deposit = sub {$balance = $balance + $_[0];};
    my $chargefee = sub {$balance -= 3;}; # "private" method
    my $withdraw = sub
    {
        $balance = $balance - $_[0];
        &$chargefee();
    };
    my $addpass = sub
    {
        my $newpass = $_[0]; #new password
        push(@passlist,$newpass);
    };
    &$addpass($secretpassword); #adding initial password to the list of passwords
    #print "making sure the initial password is in the password list:",@passlist,"\n";

    my $passcheck = sub
    {
        my $result = 0;
        my $checkpass = $_[0];
        foreach (@passlist){
            if($_ eq $checkpass){$result += 1;}else{$result += 0;}

        }
        print "result of passcheck on $checkpass was: $result\n";
        $result;
    };
    my $callthecops = sub
    {
        #print "should be calling the cops!\n";
        my $message = "You've entered the wrong password too many times! I'm calling the cops!";
        print $message;
    };
    my $fuckuphandler = sub
    {
        $fuckups += 1;
        #print "current fuckups: ",$fuckups,"\n";
        my $fuckuplimit = 7;
        my $errlim = $fuckuplimit - $fuckups;
        if ($fuckups eq $fuckuplimit) {&$callthecops}
        else {
            my $error = "You've entered the wrong password! Attempts left: $errlim\n";
            print $error;
        }
    }; #private method
    my $getpass = sub {join(",",@passlist)};

    my $interface = sub
    {
        my $imethod = $_[0];
        if ($imethod eq "listpass") {return &$getpass();}
        if ($imethod eq "withdraw") {return $withdraw;}
        if ($imethod eq "deposit") {return $deposit;}
        if ($imethod eq "inquiry") {return &$inquiry();}
        else{return &$addpass($imethod)}
    };
    # return interface function:
    sub
    {
        my $suppliedpass = $_[0];
        my $method = $_[1];
        if (&$passcheck($suppliedpass) eq 1) {
            return $interface->($method);
        }
        else {
            &$fuckuphandler;
        }
    }
}#joint account

sub makejointest {
    print "\nProblem 3.7 Join accounts: \n";
    my $firstpass = "firstpass";
    my $joint1 = jointaccount(500, $firstpass);
    print "Initial password list (should only contain one value): ", &$joint1($firstpass, "listpass"), "\n";
    my $newpass = "secondpass";
    print "adding new password $newpass...\n";
    &$joint1($firstpass, $newpass);
    print "Password list should contain $newpass: \nPassword List: ";
    print &$joint1($firstpass, "listpass"), "\n";
    print "Checking that access is possible using second password: $newpass .....\n";
    print "If output is 500, access is possible with new password .... Output: ", &$joint1($newpass, "inquiry"), "\n";
    print "\nTesting MakeJoin .....\n";
    my $thirdpass = "password3";
    print "Joining with newpassword $thirdpass...\n";
    makejoin($joint1, $newpass, $thirdpass);
    print"Attempting to access with joined password...\n";
    print "MakeJoin was successful if output is 500.\n Output: ", &$joint1($thirdpass, "inquiry"), "\n";
}

gcdTest();
howmanyTest();
makeToggleTest();
make_accumulatorTest();
make_monitoredTest();
passwordprotectedtest();
coptest();
makejointest();
