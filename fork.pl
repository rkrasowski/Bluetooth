#!/usr/bin/perl
use strict;
use warnings;
use Device::SerialPort;




my $PORT = "/dev/ttyO1";
my $Config = "serial.cfg";
my $string  = "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20";

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


my $pid = fork();

if( $pid == 0 )
	{
   		while(1)
			{
				my $typed = <STDIN>;
				print FH $typed;	
			}
	}

 


my $command = "";

while(1)
	{	
		my $rx = $ob->read(255);
		if ($rx)
			{
				if ($rx  !~ m/\n/)
					{
					
						$command = $command.$rx;
					}
				else
					{
						my $result = `$command`;
					
						print FH $result;
						$command = "";
					}
			}
	
	}






close FH || warn "close failed";
undef $ob;
untie *FH;



