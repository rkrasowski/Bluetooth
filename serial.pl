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

#cmdMode();
#checkSetting();
#setMode(0);
#checkSetting();
inquiry();
exit;

	



$ob->write("E\n");
	while(1)
		{
			my $rx = $ob->read(255);
			print "rx: $rx\n";
			sleep(1);
			if ($rx =~ m/000C78329D91/)
				{
					print "$rx\n";
					goto CONNECTING;
				}
		}


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
