#!/usr/bin/perl
use strict;
use warnings;
use Device::SerialPort;





# Activate serial connection:
my $PORT = "/dev/ttyO1";
my $serialData;
my $rx;


my $ob = Device::SerialPort->new($PORT) || die "Can't Open $PORT: $!";

$ob->baudrate(115200) || die "failed setting baudrate";
$ob->parity("none") || die "failed setting parity";
$ob->databits(8) || die "failed setting databits";
$ob->handshake("none") || die "failed setting handshake";
$ob->write_settings || die "no settings";
$| = 1;


print "\nSerial communication established with bluetooth module\n##############################\n\n";

while(1)
	{
		my $rx = $ob->read(255);
		if ($rx)
			{
				print $rx;
			}
	}


test();
#cmdMode();
#checkSetting();
#setMode(0);
#checkSetting();
#setPin(1111);
#memAddress("000C78329D91");
#setMode(5);
#checkSetting();
#inquiry();


	


CONNECTING:
{
print "Trying to connect\n";
$ob->write("C,000C78329D91\n");


while (1)
	{


                my $rx = $ob->read(255);
		print "Received: $rx\n";
		sleep(1);
	}


}

####################################### Subroutines ##################################

sub cmdMode 
	{
		$ob->write("\$\$\$");
		sleep(1);
		while (1)			
			{
				$rx = $ob->read(255);
				sleep(1);
				print "Rx: $rx\n";
				if ($rx =~ m/CMD/)
					{
						print "Rx data is : $rx\n";
						print "I am in command mode... \n";
						goto POSTCMD;
					}

			}
		POSTCMD:
	}




sub checkSetting 
	{

		$ob->write("D\n");
                sleep(1);
		while(1)
			{
				$rx = $ob->read(255);
				print "Rx: $rx\n";
				sleep(1);
				if ($rx =~ m/Rem/)
					{
						goto ENDCHECK;	
					}
			}
		ENDCHECK:
	}

sub setMode
	{
		# modes: 0- slave, 1 - master, 2 - trigger,  3- auto connect master, 4- auto connect DTR, 5 - Auto-connect any mode
		my $mode = shift;
		$ob->write("SM,$mode\n");
                sleep(1);
		$rx = $ob->read(255);
                print "Rx: $rx\n";
	}

sub inquiry 
	{
		$ob->write("I\n");
                sleep(1);
		while(1)
                        {
                                $rx = $ob->read(255);
                                print ". $rx";
                                sleep(1);
				if ($rx =~ m/Done/)
					{
						goto inqDone;
					}

			}
		inqDone:
	}

sub setPin
	{
		my $pin = shift;
		$ob->write("SP,$pin\n");
                sleep(1);
		 $rx = $ob->read(255);
                print "Rx: $rx\n";
	}

sub memAddress
	{
		my $address = shift;
		$ob->write("SR,$address\n");
                sleep(1);
                 $rx = $ob->read(255);
                print "Rx: $rx\n";
	}

sub test	
	{
		 $ob->write("Test. test , test\n");


	}
