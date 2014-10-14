#!perl -w
use strict;

###############
## Variables ##
###############
my $monnum    = "3";                                      #the monitor you want to enable/disable
my $file      = "report.txt";                             #name of report file
my $enable    = "MultiMonitorTool /enable $monnum";       #enable command 
my $disable   = "MultiMonitorTool /disable $monnum";      #disable command
my $report    = "MultiMonitorTool.exe /scomma $file";     #report to show active monitors
my $search    = "DISPLAY3";                               #search string to find the montior name
my $mainsound = "Speakers";                               #name of main sound device
my $tvsound   = "LG TV-4";                                #name of television sound device

#enable and disable sound
my $esound  = "nircmd\\nircmdc setdefaultsounddevice \"$mainsound\" 1";
my $dsound  = "nircmd\\nircmdc setdefaultsounddevice \"$tvsound\" 1";
my @array;

##########
## Main ##
##########

#run the the report
qx($report);

#open the file and push the contents into @array
open my $searchfile, '<', $file or die "Cant open file $!"; 
while (my $line = <$searchfile>){
  chomp $line;
  push(@array,$line);
}

#loop through the array then search for the display name
#then split by the delimeter and see if the monitor status.
foreach(@array){
 if($_ =~ /$search/){
    my @results = split(/,/,$_);
    #if not active enable, else disable
    if($results[5] eq "No"){
      qx($enable);
      qx($dsound);
    }else{
      qx($disable);
      qx($esound);
    }
  }
}
