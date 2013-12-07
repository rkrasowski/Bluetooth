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


START:
{
$ob->write( "\n\nWelcome to Satellite link by KB2PNM\n\n    Press 1 to control center\n\n    Press 2 to read message\n\n    Press 3 to writte message\n\n    Press 4 to access setting\n\n");

my $firstChoice;
until ($firstChoice)
	{
		$firstChoice = $ob->read(255);

	}
if ($firstChoice == 1)
	{
		$ob->write("CONTROL CENTER\n\n");
		controlCenter();
	}

if ($firstChoice == 2)
        {
                $ob->write("MESSAGES\n\n");
        }
if ($firstChoice == 3)
        {
                $ob->write("WRITE MESSAGE\n\n");
        }
if ($firstChoice == 4)
        {
                $ob->write("SETTING\n\n");
        }

}

#goto START;


sub controlCenter
	{
		 $ob->write("    Press 1 to check memory\n\n");
		my $control;
		until ($control)
			{
				$control = $ob->read(255);
			}
		if ($control == 1)
			{
				my $mem = `df -kh`;
				$ob->write("$mem\n\n");
			}
	}

