$|++;
use utf8;
use Data::Dumper;
use warnings;
use strict;

my $sleep = 5;
while(){
    my $uptime = `uptime`;
    my $uname = `uname -a`;
    my $hdd = (split/\s+/,`df -h /media/hdd`)[11];
    my $hddfree = (split/\s+/,`df -h /media/hdd`)[10];
    my $hddpercent = (split/\s+/,`df -h /media/hdd`)[12];

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
                <p><strong>Free space on HDD:</strong> $hddfree/$hdd <div class="progress"><div class="bar" style="width: $hddpercent; text-indent: 50%; color: rgb(51, 51, 51);">$hddpercent</div></div></p>
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
