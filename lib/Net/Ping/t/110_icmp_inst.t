# Test to make sure object can be instantiated for icmp protocol.
# Root access is required to actually perform icmp testing.

BEGIN {
    unless (eval "require Socket") {
	print "1..0 # Skip: no Socket\n";
	exit;
    }
}

use Test;
use Net::Ping;
plan tests => 2;

# Everything loaded fine
ok 1;

my $p = new Net::Ping "tcp";
ok !!$p;
