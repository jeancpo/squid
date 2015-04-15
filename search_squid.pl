#!/usr/bin/perl
#
############################################################################
#                                                       		   #
# version 0.1								   #
#	- verifica que exista o no parametro (usuario)                     #
#	- genera reporte en pagina web html donde se ejecuta el script	   #
#	 								   #
############################################################################

use File::Basename;
use warnings; 
use strict; 
use Data::Dumper; 
use File::Spec;

#vars
my $dir = dirname(File::Spec->rel2abs(__FILE__));
my $dir_log ="/var/log/squid"; 
my $report = $dir."/report.htm"; 
my @meses = ("01","02","03","04","05","06","07","08","09","10","11","12");
my $usuario=$ARGV[0];
my $fontColor="D2L";
my ($unix_timestamp, $peso, $ip, $code, $value, $cmd, $url, $users, $destino, $type);
$unix_timestamp= $peso= $ip= $code= $value= $cmd= $url= $users= $destino= $type ="";

if (!defined($usuario)) {
  $usuario = '';
}

if (-e $report) #if the file exists 
{ 
my $cmd="rm $report"; 
system($cmd)==0 or die "Error: No Se puede Eliminar '$cmd'"; 
}

open (OUT, ">$report") or die ("No Se puede Abrir $report: $!");
print OUT "<html lang=\"es\">\n<head>\n<META http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n<title>Reporte Proxy</title><style type=\"text/css\">table {border: 1 solid black; border-collapse: collapse; } th {border: 1 solid black; width: 20%; text-align: left; background: #B8B8B8} td {border: 1 solid black; width: 80%} .H25H {border: 1 solid black; width: 25%; text-align: center} .H25L {border: 1 solid black; width: 25%; text-align: left} .D2L {border: 1 solid black; width: 25%; text-align: left; background: #DDDDDD} .W30L {border: 1 solid black; width: 25%; text-align: left; background: #DDDDDD ; font-size : 12pt; font-weight: bold; color:red}</style></head>\n";
print OUT "<table width=\"100%\">\n<tr><th colspan=\"4\" class=\"H25H\">REPORTE PROXY</th></tr>\n";
print OUT "<tr><th class=\"H25L\">NUMERO</th><th class=\"H25L\">FECHA</th><th class=\"H25L\">DIRECCION IP</th><th class=\"H25L\">USUARIO</th></tr>\n"; 

my $Logfile=$dir_log."/access.log";
my $count = 1;
open (IN, "<$Logfile") or die ("No se Puede Abrir el Archivo.");		
	while (my $line = <IN>) 
	{
		next if $line =~ m/^\s*$/;
		($unix_timestamp, $peso, $ip, $code, $value, $cmd, $url, $users, $destino, $type) = split(' ',$line);
			my ($sec, $min, $hora, $dia,$mes,$year) = (localtime($unix_timestamp))[0,1,2,3,4,5];
        		my $fecha=$dia."/".$meses[$mes]."/".($year+1900)." ".$hora.":".$min.":".$sec;
			if ($usuario eq $users){
			if ($users eq ''){$users = 'N/A';}			
			print OUT "<tr><td class=$fontColor>$count</td><td class=$fontColor>$fecha</td><td class=$fontColor>$ip</td><td class=$fontColor>$users</td></tr>\n";
			}
			elsif ($usuario eq ''){
			if ($users eq ''){$users = 'N/A';}
			print OUT "<tr><td class=$fontColor>$count</td><td class=$fontColor>$fecha</td><td class=$fontColor>$ip</td><td class=$fontColor>$users</td></tr>\n";
			}
		$count++;
	}
close(IN);
print OUT "</table>\n</html>\n";
close(OUT);
