# -*- Perl -*-
# $Header: /home/mjr/tmp/tlilycvs/lily/tigerlily2/extensions/paste.pl,v 1.6 2001/08/17 00:57:00 kazrak Exp $

use strict;

=head1 NAME

paste.pl - Prevent accidental sends when pasting

=head1 DESCRIPTION

Provides paste mode, a mode which traps carriage returns, and turns them
into spaces.  This prevents the input buffer from being sent, which is
useful when pasting multiple lines into the input buffer.

=over 10

=head1 UI COMMANDS

=item toggle-paste-mode

Toggles paste mode.  Bound to M-p by default.

=item paste-mode

Used internally to intercept each keystroke when paste mode is enabled,
and perform the appropriate magic.

=cut

sub paste_mode {
    my($ui, $command, $key) = @_;
    return 1 if ($ui->{_eat_space_flag} &&
                 ($key eq "nl" || $key eq " " || $key eq ">"));
    if ($key eq "nl") {
	$ui->{_eat_space_flag} = 1;
	$ui->command("insert-self", " ");
	return 1;
    } elsif ($key eq " ") {
        if ($ui->{_eat_space_buffer}) {
            $ui->{_eat_space_flag} = 1;
            return 1;
        } else {
            $ui->{_eat_space_buffer} = $key;
            return;
        }
    }
    $ui->{_eat_space_flag} = 0;
    $ui->{_eat_space_buffer} = '';
    return;
}

sub toggle_paste_mode {
    my($ui, $command) = @_;
    $ui->{_eat_space_flag} = 0;
    $ui->{_eat_space_buffer} = '';
    if ($ui->intercept_u("paste-mode")) {
	$ui->prompt("");
    }
    elsif ($ui->intercept_r("paste-mode")) {
	$ui->prompt("Paste:");
    }
}

my $paste_help = "
Sometimes you want to paste several lines of text into a send.  Pasting
each line one at a time is tedious, and prone to error.  (What happens
if you accidentally paste a newline?)  Paste mode provides a better way.

When paste mode is enabled (it can be toggled with the toggle-paste-mode
key, bound to M-p by default), newlines are translated into spaces.  To
help with occasions when several lines of text are indented, any spaces
following a newline are not entered.
";

TLily::UI::command_r("paste-mode"        => \&paste_mode);
TLily::UI::command_r("toggle-paste-mode" => \&toggle_paste_mode);
TLily::UI::bind("M-p" => "toggle-paste-mode");
TLily::User::shelp_r("paste" => "Pasting multi-line text.", "concepts");
TLily::User::help_r("paste" => $paste_help);
