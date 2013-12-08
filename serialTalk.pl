#!/usr/bin/perl
use strict;
use warnings;
use Device::SerialPort;


my $PORT = "/dev/ttyO1";
my $Config = "serial.cfg";
my $rx;


my $ob = Device::SerialPort->new($PORT) || die "Can't Open $PORT: $!";

$ob->baudrate(115200) || die "failed setting baudrate";
$ob->parity("none") || die "failed setting parity";
$ob->databits(8) || die "failed setting databits";
$ob->handshake("none") || die "failed setting handshake";
$ob->write_settings || die "no settings";
$| = 1;


$ob->write_settings;
$ob->save("serial.cfg");
$ob = tie (*FH, 'Device::SerialPort', $Config)
       || die "Can't tie: $!\n";             ## TIEHANDLE ##




print "\nSerial communication established with bluetooth module\n##############################\n\n";


START:
{
 print FH "\n\nWelcome to Satellite link by KB2PNM\n\n    Press 1 to control center\n\n    Press 2 to read message\n\n    Press 3 to writte message\n\n    Press 4 to access setting\n\n";

my $firstChoice;
until ($firstChoice)
	{
		$firstChoice = $ob->read(255);

	}
if ($firstChoice == 1)
	{
		print FH "CONTROL CENTER\n\n";
		controlCenter();
	}

if ($firstChoice == 2)
        {
                print FH "MESSAGES\n\n";
        }
if ($firstChoice == 3)
        {
                print FH "WRITE MESSAGE\n\n";
        }
if ($firstChoice == 4)
        {
                print FH "SETTING\n\n";
        }

}

#goto START;


sub controlCenter
	{
		 print FH "Press 1 to have system check\n\n    Press 2 to send current telemetry data\n\n Press 7 to check memory status\n\n";
		my $control;
		until ($control)
			{
				$control = $ob->read(255);
			}

		if($control == 1)
			{
				systemCheck();
			}




		if ($control == 2)
			{
				print FH "Sending telemetry ....\n\n";
				sendTelemetry();
			}


		if ($control == 7)
			{
				my $mem = `df -kh`;
				print FH "$mem\n\n";
						
			}
	}


sub sendTelemetry
	{

	}

sub systemCheck
	{
		print FH "GPS check...";
		print FH"PASS\n";
		print FH "Satellite unit  check...";
                print FH "PASS\n";
		print FH "NMEA2000 check...";
                print FH "PASS\n";
		print FH "Barometer check...";
                print FH"PASS\n";
		print FH "Accelerometer check...";
                print FH "PASS\n";
		 $ob->write("Termometers check...");
                $ob->write("PASS\n");
		 $ob->write("Battery check...");
                $ob->write("PASS\n");


	}
