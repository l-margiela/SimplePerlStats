$|++;
use utf8;
use Data::Dumper;
use warnings;
use strict;

use Number::Bytes::Human qw(format_bytes);

my $sleep = 5;
while(){
    my $uptime = convert_time(uptime());
    my $uname = `uname -a`;

    # Disk
    my $hdd = (split/\s+/,`df -h /media/hdd`)[11];
    my $hddfree = (split/\s+/,`df -h /media/hdd`)[10];
    my $hddpercent = (split/\s+/,`df -h /media/hdd`)[12];

    # Network
    my $rx = format_bytes(red("/sys/class/net/eth0/statistics/rx_bytes"));
    my $tx = format_bytes(red("/sys/class/net/eth0/statistics/tx_bytes"));


    open FILE, ">/var/www/stats/index.html" or die $!;

    print FILE <<HTML;
    <!DOCTYPE html>
    <html>
            <head>
            <title>Perl simple stats generator</title>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <!-- Bootstrap -->
            <link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
            <link href="css/style.css" rel="stylesheet" media="screen">
        </head>
        <body>
            <div class="well">
                <p><strong>Uptime:</strong> $uptime</p>
                <p><strong>uname:</strong> $uname</p>
                <p><strong>Free space on HDD:</strong> $hddfree/$hdd <div class="progress"><div class="bar" style="width: $hddpercent; text-indent: 50%; color: rgb(51, 51, 51); ">$hddpercent</div></div></p>
                <p><strong>Downloaded:</strong> $rx</p>
                <p><strong>Uploaded:</strong> $tx</p>
            </div>
        <footer>
            <!--[if lte IE 8]><span style="filter: FlipH; -ms-filter: "FlipH"; display: inline-block;"><![endif]-->
            <span style="-moz-transform: scaleX(-1); -o-transform: scaleX(-1); -webkit-transform: scaleX(-1); transform: scaleX(-1); display: inline-block;">
                &copy;
            </span>
            <!--[if lte IE 8]></span><![endif]-->
            xaxes
        </footer>
        </body>
    </html>
HTML
    print "Updated.\n";

    close FILE;
    sleep($sleep);
}
sub red{
    my($k,$f)=(shift);
    -f $k and open*h,"<".$k and sysread*h,$f,-s*h;
    close*h;
    return $f
}
sub uptime{
    my$f=0;
    open*h,"</proc/uptime" and sysread*h,$f,100;
    close*h;
    return $f=~/^(\d+)/
}
sub convert_time { 
    my $time = shift; 
    my $days = int($time / 86400); 
    $time -= ($days * 86400); 
    my $hours = int($time / 3600); 
    $time -= ($hours * 3600); 
    my $minutes = int($time / 60); 
    my $seconds = $time % 60; 
  
    $days = $days < 1 ? '' : $days .'d '; 
    $hours = $hours < 1 ? '' : $hours .'h '; 
    $minutes = $minutes < 1 ? '' : $minutes . 'm '; 
    $time = $days . $hours . $minutes . $seconds . 's'; 
    return $time; 
}
