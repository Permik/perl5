#
# $Id: Unicode.t,v 1.6 2002/04/12 20:23:05 dankogai Exp dankogai $
#
# This script is written entirely in ASCII, even though quoted literals
# do include non-BMP unicode characters -- Are you happy, jhi?
#

BEGIN {
    require Config; import Config;
    if ($Config{'extensions'} !~ /\bEncode\b/) {
      print "1..0 # Skip: Encode was not built\n";
      exit 0;
    }
# should work without perlio
#     unless (find PerlIO::Layer 'perlio') {
# 	print "1..0 # Skip: PerlIO was not built\n";
# 	exit 0;
#     }
# should work on EBCDIC
#    if (ord("A") == 193) {
# 	print "1..0 # Skip: EBCDIC\n";
# 	exit 0;
#    }
    $| = 1;
}

use strict;
#use Test::More 'no_plan';
use Test::More tests => 22;
use Encode qw(encode decode);

#
# see
# http://www.unicode.org/unicode/reports/tr19/
#

my $dankogai   = "\x{5c0f}\x{98fc}\x{3000}\x{5f3e}";
my $nasty      = "$dankogai\x{1abcd}";
my $fallback   = "$dankogai\x{fffd}";

#hi: (0x1abcd - 0x10000) / 0x400 + 0xD800 = 0xd82a
#lo: (0x1abcd - 0x10000) % 0x400 + 0xDC00 = 0xdfcd

my $n_16be = 
    pack("C*", map {hex($_)} qw<5c 0f 98 fc 30 00 5f 3e  d8 2a df cd>);
my $n_16le =
    pack("C*", map {hex($_)} qw<0f 5c fc 98 00 30 3e 5f  2a d8 cd df>);
my $f_16be = 
    pack("C*", map {hex($_)} qw<5c 0f 98 fc 30 00 5f 3e  ff fd>);
my $f_16le =
    pack("C*", map {hex($_)} qw<0f 5c fc 98 00 30 3e 5f  fd ff>);
my $n_32be =
    pack("C*", map {hex($_)} 
	 qw<00 00 5c 0f 00 00 98 fc 00 00 30 00 00 00 5f 3e  00 01 ab cd>);
my $n_32le = 
    pack("C*", map {hex($_)} 
	 qw<0f 5c 00 00 fc 98 00 00 00 30 00 00 3e 5f 00 00  cd ab 01 00>);

my $n_16bb = pack('n', 0xFeFF) . $n_16be;
my $n_16lb = pack('v', 0xFeFF) . $n_16le;
my $n_32bb = pack('N', 0xFeFF) . $n_32be;
my $n_32lb = pack('V', 0xFeFF) . $n_32le;

is($n_16be, encode('UTF-16BE', $nasty),  qq{encode UTF-16BE});
is($n_16le, encode('UTF-16LE', $nasty),  qq{encode UTF-16LE});
is($n_32be, encode('UTF-32BE', $nasty),  qq{encode UTF-32BE});
is($n_32le, encode('UTF-32LE', $nasty),  qq{encode UTF-16LE});

is($nasty,  decode('UTF-16BE', $n_16be), qq{decode UTF-16BE});
is($nasty,  decode('UTF-16LE', $n_16le), qq{decode UTF-16LE});
is($nasty,  decode('UTF-32BE', $n_32be), qq{decode UTF-32BE});
is($nasty,  decode('UTF-32LE', $n_32le), qq{decode UTF-32LE});

is($n_16bb, encode('UTF-16',   $nasty),  qq{encode UTF-16});
is($n_32bb, encode('UTF-32',   $nasty),  qq{encode UTF-32});
is($nasty,  decode('UTF-16',   $n_16bb), qq{decode UTF-16, bom=be});
is($nasty,  decode('UTF-16',   $n_16lb), qq{decode UTF-16, bom=le});
is($nasty,  decode('UTF-32',   $n_32bb), qq{decode UTF-32, bom=be});
is($nasty,  decode('UTF-32',   $n_32lb), qq{decode UTF-32, bom=le});

is(decode('UCS-2BE', $n_16be), $fallback, "decode UCS-2BE: fallback");
is(decode('UCS-2LE', $n_16le), $fallback, "decode UCS-2LE: fallback");
eval { decode('UCS-2BE', $n_16be, 1) }; 
ok($@=~/^UCS-2BE:/, "decode UCS-2BE: exception");
eval { decode('UCS-2LE', $n_16le, 1) }; 
ok($@=~/^UCS-2LE:/, "decode UCS-2LE: exception");
is(encode('UCS-2BE', $nasty), $f_16be, "encode UCS-2BE: fallback");
is(encode('UCS-2LE', $nasty), $f_16le, "encode UCS-2LE: fallback");
eval { encode('UCS-2BE', $nasty, 1) }; 
ok($@=~/^UCS-2BE:/, "encode UCS-2BE: exception");
eval { encode('UCS-2LE', $nasty, 1) }; 
ok($@=~/^UCS-2LE:/, "encode UCS-2LE: exception");

1;
__END__
