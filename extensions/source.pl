# -*- Perl -*-
# $Header: /home/mjr/tmp/tlilycvs/lily/tigerlily2/extensions/source.pl,v 1.2 1999/03/15 23:53:16 josh Exp $

use strict;

sub do_source($) {
    my ($ui,$fname) = @_;
    my $i;
    local(*FH);
    
    return if $fname eq "";
    
    my $rc = open (FH, "<$fname");
    unless ($rc) {
	$ui->print("($fname not found)\n");
	return;
    }
    
    $ui->print("(sourcing $fname)\n");
    
    my @data = <FH>;
    my $size = @data;
    $ui->print("$size lines\n");
    close FH;
    
    my $l;
    foreach $l (@data) {
	chomp $l;
	TLily::Event::send({type => 'user_input',
			    ui   => $ui,
			    text => "$l\n"});
    }
    return;
}   
	      
command_r('source' => \&do_source);
shelp_r("source", "Evaluate a file as if entered by the user");
help_r("source", "
%source [file] - Play the file to the client as if it was typed by the user.

");

1;
