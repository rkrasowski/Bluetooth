#!/usr/bin/perl
use strict;
use warnings;
use Device::SerialPort;





# Activate serial connection:
my $PORT = "/dev/ttyO1";
my $serialData;

my $ob = Device::SerialPort->new($PORT) || die "Can't Open $PORT: $!";

$ob->baudrate(115200) || die "failed setting baudrate";
$ob->parity("none") || die "failed setting parity";
$ob->databits(8) || die "failed setting databits";
$ob->handshake("none") || die "failed setting handshake";
$ob->write_settings || die "no settings";
$| = 1;


print "Serial communication established with bluetooth module\n";

cmdMode();

exit;

#$ob->write("\$\$\$");		#enter command mode
	
sleep(1);
my $rx = $ob->read(255);
                print "Command: $rx\n";


#$ob->write("E\n");

$ob->write("I\n");
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





