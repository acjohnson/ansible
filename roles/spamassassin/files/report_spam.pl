#!/usr/bin/perl -w
#created by Kurt Yoder; see
#http://wiki.spamassassin.org/w/KurtYoder
#for updates on this script see
#http://wiki.spamassassin.org/w/report_5fspam_2epl
#
#If you have "maildir" mailboxes, running spamassassin -r multiple
#times can be tedious for large numbers of spam. So you can use this
#script to run it for you.  Run it like this: "report_spam.pl
#your_spam_directory". Each message in your_spam_directory will then
#be learned in bayes *and* reported to the checksum services.

use strict;
use diagnostics;

my $spamassassin = '/usr/bin/spamassassin';
my $sa_learn = '/usr/bin/sa-learn';

if( ! -x $spamassassin ){
   die( "Spamassassin not found; I looked in $spamassassin\n" );
}

if(
   ( defined( $ARGV[0] ) ) &&
   ( -d $ARGV[0] ) &&
   ( -r $ARGV[0] ) &&
   ( -x $ARGV[0] )
){
   my $path = $ARGV[0];
   #ensure received path has trailing slash
   $path =~ s|/?$|/|;
   print( "reporting messages in $path as spam\n" );
   my @files = `ls -A $path`;
   chomp( @files );
   foreach my $file( @files ){
      if( -r $path . $file ){
         #shell-escape all '=' and ':'
         $file =~ s/([=:])/\\$1/g;
         print( "reporting $file\n" );
         system( "$spamassassin -r < $path$file" );
         system( "$sa_learn --spam --no-sync $path" );
      } else {
         print( "Ignoring un-readable file $file\n" );
      }
   }
} else {
   print( "Spam directory is empty or does not exist.\n" );
}
print( "rebuilding spamassassin database...\n" );
system( "$sa_learn --sync" );
