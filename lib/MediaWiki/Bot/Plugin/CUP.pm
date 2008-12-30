package MediaWiki::Bot::Plugin::CUP;

use strict;

our $VERSION = '0.2.0';

=head1 NAME

MediaWiki::Bot::Plugin::CUP - a plugin for MediaWiki::Bot which contains data retrieval tools for the 2009 WikiCup hosted on the English Wikipedia

=head1 SYNOPSIS

use MediaWiki::Bot;

my $editor = MediaWiki::Bot->new('Account');
$editor->login('Account', 'password');
$editor->cup_get_all('User:Contestant');

=head1 DESCRIPTION

MediaWiki::Bot is a framework that can be used to write Wikipedia bots. MediaWiki::Bot::Plugin::CUP can be used for data retrieval and reporting bots related to the 2009 WikiCup

=head1 AUTHOR

Dan Collins (ST47) and others

=head1 METHODS

=over 4

=item import()

Calling import from any module will, quite simply, transfer these subroutines into that module's namespace. This is possible from any module which is compatible with MediaWiki/Bot.pm.

=cut

sub import {
	no strict 'refs';
	foreach my $method (qw/cup_get_all cup_get_fa cup_get_ga cup_get_fl cup_get_fs cup_get_fpi cup_get_fpo cup_get_ft cup_get_gt cup_get_dyk cup_get_itn cup_get_edits/) {
		*{caller() . "::$method"} = \&{$method};
	}
}

=item cup_get_all($contestant[, $text])

Will retrieve the contestant's total score. $text is optional but recommended if you will be calling these functions multiple times for the same user or if you will be using the submisssions pages, for performance reasons. Also, if you need to get several users' stats, please use MediaWiki::Bot's get_pages sub to retrieve all the submissions pages in one go. Also, if you want any control at all over where we get the data, say if there's a capitalization mismatch or the submissions pages are not located where I think they are, then if you pass the text of the submission page to me, I will use your submissions page. Finally, note that for purposes of getting edit counts, we use $contestant as the username, so please don't do anything to mangle that just so that I get the right submissions page. File a bug first.

Data is returned as edits, gas, fas, fls, fss, fpis, fpos, dyks, itns, fts, gts, and total score. All are in number of points claimed, not number of articles submitted.

=cut

sub cup_get_all {
	my $self    = shift;
	my $user    = shift;
	my $text    = shift;
	unless ($text) {
		$text=$self->get_text("User:Garden/WikiCup/Submissions/$user");
	}
	my ($edits, $minor, $fa, $ga, $fl, $fs, $fpi, $fpo, $ft, $gt, $dyk, $itn, $score);
	($edits, $minor)=$self->cup_get_edits($user);
	$edits/=10;
	$minor/=1000;
	$fa=50*$self->cup_get_fa($user, $text);
	$ga=30*$self->cup_get_ga($user, $text);
	$fl=30*$self->cup_get_fl($user, $text);
	$fs=35*$self->cup_get_fs($user, $text);
	$fpi=35*$self->cup_get_fpi($user, $text);
	$fpo=25*$self->cup_get_fpo($user, $text);
	$dyk=5*$self->cup_get_dyk($user, $text);
	$itn=5*$self->cup_get_itn($user, $text);
	$ft=10*${$self->cup_get_ft($user, $text)}[1];
	$gt=5*${$self->cup_get_gt($user, $text)}[1];
	$score=sprintf("%d", $dyk+$itn+$ga+$fl+$fpi+
		$fpo+$fs+$fa+$ft+$gt+$edits+$minor);
	return (sprintf("%d", $edits+$minor), $ga, $fa, 
		$fl, $fs, $fpi, $fpo, $dyk, $itn, $ft, $gt, $score);
}

=item cup_get_fa($contestant[, $text])

Each of these will retrieve the contestant's subscore for a particular item. $text is optional but recommended.

Data is returned as number of claimed good or featured items.

=cut

sub cup_get_fa {
	my $self    = shift;
	my $user    = shift;
	my $text    = shift;
	unless ($text) {
		$text=$self->get_text("User:Garden/WikiCup/Submissions/$user");
	}
	my $res=0;
	my @text=split(/==.+?==/, $text);
	while ($text[9]=~/\n\#[^\#\*\:]/g) {$res++}
	return $res;
}

=item cup_get_ga($contestant[, $text])

Each of these will retrieve the contestant's subscore for a particular item. $text is optional but recommended.

Data is returned as number of claimed good or featured items.

=cut

sub cup_get_ga {
	my $self    = shift;
	my $user    = shift;
	my $text    = shift;
	unless ($text) {
		$text=$self->get_text("User:Garden/WikiCup/Submissions/$user");
	}
	my $res=0;
	my @text=split(/==.+?==/, $text);
	while ($text[5]=~/\n\#[^\#\*\:]/g) {$res++}
	return $res;
}

=item cup_get_fl($contestant[, $text])

Each of these will retrieve the contestant's subscore for a particular item. $text is optional but recommended.

Data is returned as number of claimed good or featured items.

=cut

sub cup_get_fl {
	my $self    = shift;
	my $user    = shift;
	my $text    = shift;
	unless ($text) {
		$text=$self->get_text("User:Garden/WikiCup/Submissions/$user");
	}
	my $res=0;
	my @text=split(/==.+?==/, $text);
	while ($text[6]=~/\n\#[^\#\*\:]/g) {$res++}
	return $res;
}

=item cup_get_fs($contestant[, $text])

Each of these will retrieve the contestant's subscore for a particular item. $text is optional but recommended.

Data is returned as number of claimed good or featured items.

=cut

sub cup_get_fs {
	my $self    = shift;
	my $user    = shift;
	my $text    = shift;
	unless ($text) {
		$text=$self->get_text("User:Garden/WikiCup/Submissions/$user");
	}
	my $res=0;
	my @text=split(/==.+?==/, $text);
	while ($text[8]=~/\n\#[^\#\*\:]/g) {$res++}
	return $res;
}

=item cup_get_fpi($contestant[, $text])

Each of these will retrieve the contestant's subscore for a particular item. $text is optional but recommended.

Data is returned as number of claimed good or featured items.

=cut

sub cup_get_fpi {
	my $self    = shift;
	my $user    = shift;
	my $text    = shift;
	unless ($text) {
		$text=$self->get_text("User:Garden/WikiCup/Submissions/$user");
	}
	my $res=0;
	my @text=split(/==.+?==/, $text);
	while ($text[7]=~/\n\#[^\#\*\:]/g) {$res++}
	return $res;
}

=item cup_get_fpo($contestant[, $text])

Each of these will retrieve the contestant's subscore for a particular item. $text is optional but recommended.

Data is returned as number of claimed good or featured items.

=cut

sub cup_get_fpo {
	my $self    = shift;
	my $user    = shift;
	my $text    = shift;
	unless ($text) {
		$text=$self->get_text("User:Garden/WikiCup/Submissions/$user");
	}
	my $res=0;
	my @text=split(/==.+?==/, $text);
	while ($text[4]=~/\n\#[^\#\*\:]/g) {$res++}
	return $res;
}

=item cup_get_gt($contestant[, $text])

Each of these will retrieve the contestant's subscore for a particular item. $text is optional but recommended.

Data is returned as number of claimed good or featured topics, number of articles in those topics

=cut

sub cup_get_gt {
	my $self    = shift;
	my $user    = shift;
	my $text    = shift;
	unless ($text) {
		$text=$self->get_text("User:Garden/WikiCup/Submissions/$user");
	}
	my @res=(0,0);
	my @text=split(/==.+?==/, $text);
	while ($text[11]=~/\n\#[^\#\*\:]/g) {$res[0]++}
	while ($text[11]=~/\n\#\#[^\#\*\:]/g) {$res[1]++}
	return \@res;
}

=item cup_get_ft($contestant[, $text])

Each of these will retrieve the contestant's subscore for a particular item. $text is optional but recommended.

Data is returned as number of claimed good or featured topic, number of aricles in those topics.

=cut

sub cup_get_ft {
	my $self    = shift;
	my $user    = shift;
	my $text    = shift;
	unless ($text) {
		$text=$self->get_text("User:Garden/WikiCup/Submissions/$user");
	}
	my @res=(0,0);
	my @text=split(/==.+?==/, $text);
	while ($text[10]=~/\n\#[^\#\*\:]/g) {$res[0]++}
	while ($text[10]=~/\n\#\#[^\#\*\:]/g) {$res[1]++}
	return \@res;
}

=item cup_get_dyk($contestant[, $text])

Each of these will retrieve the contestant's subscore for a particular item. $text is optional but recommended.

Data is returned as number of claimed good or featured items.

=cut

sub cup_get_dyk {
	my $self    = shift;
	my $user    = shift;
	my $text    = shift;
	unless ($text) {
		$text=$self->get_text("User:Garden/WikiCup/Submissions/$user");
	}
	my $res=0;
	my @text=split(/==.+?==/, $text);
	while ($text[2]=~/\n\#[^\#\*\:]/g) {$res++}
	return $res;
}

=item cup_get_itn($contestant[, $text])

Each of these will retrieve the contestant's subscore for a particular item. $text is optional but recommended.

Data is returned as number of claimed good or featured items.

=cut

sub cup_get_itn {
	my $self    = shift;
	my $user    = shift;
	my $text    = shift;
	unless ($text) {
		$text=$self->get_text("User:Garden/WikiCup/Submissions/$user");
	}
	my $res=0;
	my @text=split(/==.+?==/, $text);
	while ($text[3]=~/\n\#[^\#\*\:]/g) {$res++}
	return $res;
}

=item cup_get_edits($contestant[, $text])

Each of these will retrieve the contestant's subscore for a particular item. $text is optional but recommended.

Data is returned as number of major edits, number of minor edits since Jan 1, 2009, 00:00:00 UTC.

=cut

sub cup_get_edits {
	my $self    = shift;
	my $user    = shift;
	my $hash={	action	=> 'query',
			list	=> 'usercontribs',
			ucuser	=> "User:$user",
			ucstart => '2009-01-01T00:00:00Z',
			ucnamespace => 0,
			uclimit	=> 5000,
			ucdir	=> 'newer',
			ucshow	=> '!minor'};
	my $res=$self->{api}->list($hash);
	my $major=scalar(@{$res});
	$hash={	action	=> 'query',
		list	=> 'usercontribs',
		ucuser	=> "User:$user",
		ucstart => '2009-01-01T00:00:00Z',
		ucnamespace => 0,
		uclimit	=> 5000,
		ucdir	=> 'newer',
		ucshow	=> 'minor'};
	$res=$self->{api}->list($hash);
	my $minor=scalar(@{$res});
	return ($major, $minor);
}

1;
