
$|++;
use utf8;
use Data::Dumper;
use warnings;
use strict;

use Config::Simple;

use Number::Bytes::Human qw(format_bytes);
use Encode qw(encode_utf8);

### Config and variables
my $cfg = new Config::Simple('config.ini');
my $disk = $cfg->param('disk');

while(){
    my $uptime = convert_time(uptime());
    my $uname = `uname -a`;
    my $load = join" ",(split/\s+/, loadavg())[0..2];

    # Disk
    my $hdd = (split/\s+/,`df -h $disk`)[11];
    my $hddfree = (split/\s+/,`df -h $disk`)[10];
    my $hddpercent = (split/\s+/,`df -h `.$cfg->param('disk'))[12];

    # Network
    my $rx = format_bytes(red("/sys/class/net/eth0/statistics/rx_bytes"));
    my $tx = format_bytes(red("/sys/class/net/eth0/statistics/tx_bytes"));


    open FILE, ">./index.html" or die $!;

    print FILE encode_utf8 <<HTML;
    <!DOCTYPE html>
    <html>
            <head>
            <meta charset='utf-8'>
            <title>Perl simple stats generator</title>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <!-- Bootstrap -->
            <link href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css" rel="stylesheet">
            <link href="css/style.css" rel="stylesheet" media="screen">
        </head>
        <body>
            <div class="well">
                <p><h4>··General</h4></p>
                <p><strong>Uptime:</strong> $uptime</p>
                <p><strong>uname:</strong> $uname</p>
                <p><strong>Load:</strong> $load</p>
                <p><h4>··Disks</h4></p>
                <p><strong>Free space on HDD:</strong> $hddfree/$hdd
                    <div class="progress"><div class="bar" style="width: $hddpercent; text-indent: 50%; color: rgb(51, 51, 51); ">$hddpercent</div></div>
                </p>
                <p><h4>··Network</h4></p>
                <p><strong>Downloaded:</strong> $rx</p>
                <p><strong>Uploaded:</strong> $tx</p>
            </div>
        <footer>
            <!--[if lte IE 8]><span style="filter: FlipH; -ms-filter: "FlipH"; display: inline-block;"><![endif]-->
            <span style="-moz-transform: scaleX(-1); -o-transform: scaleX(-1); -webkit-transform: scaleX(-1); transform: scaleX(-1); display: inline-block;">
                &copy;
            </span>
            <!--[if lte IE 8]></span><![endif]-->
            <a href="http://github.com/xaxes">xaxes</a>
        </footer>
        </body>
    </html>
HTML
    print "Updated.\n";

    close FILE;
    sleep($cfg->param('sleep'));
    #print $Conf{'sleep'};
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
    return $f=~/^(\d+)/;
}
sub loadavg{
    my$f=0;
    open*h,"</proc/loadavg" and sysread*h,$f,100;
    close*h;
    return $f;
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
