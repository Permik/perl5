BEGIN {
    if ($ENV{PERL_CORE}) {
	chdir 't' if -d 't';
	@INC = '../lib';
    }
}

use lib 't';
use strict;
use warnings;
use bytes;

use Test::More ;
use ZlibTestUtils;
use Symbol;

BEGIN 
{ 
    # use Test::NoWarnings, if available
    my $extra = 0 ;
    $extra = 1
        if eval { require Test::NoWarnings ;  import Test::NoWarnings; 1 };

    my $count = 0 ;
    if ($] < 5.005) {
        $count = 340 ;
    }
    else {
        $count = 351 ;
    }


    plan tests => $count + $extra ;

    use_ok('Compress::Zlib', 2) ;
    use_ok('Compress::Gzip::Constants') ;

    use_ok('IO::Compress::Gzip', qw($GzipError)) ;
}


my $hello = <<EOM ;
hello world
this is a test
EOM

my $len   = length $hello ;

# Check zlib_version and ZLIB_VERSION are the same.
is Compress::Zlib::zlib_version, ZLIB_VERSION, 
    "ZLIB_VERSION matches Compress::Zlib::zlib_version" ;

# generate a long random string
my $contents = '' ;
foreach (1 .. 5000)
  { $contents .= chr int rand 256 }

my $x ;
my $fil;

# compress/uncompress tests
# =========================

eval { compress([1]); };
ok $@ =~ m#not a scalar reference#
    or print "# $@\n" ;;

eval { uncompress([1]); };
ok $@ =~ m#not a scalar reference#
    or print "# $@\n" ;;

$hello = "hello mum" ;
my $keep_hello = $hello ;

my $compr = compress($hello) ;
ok $compr ne "" ;

my $keep_compr = $compr ;

my $uncompr = uncompress ($compr) ;

ok $hello eq $uncompr ;

ok $hello eq $keep_hello ;
ok $compr eq $keep_compr ;

# compress a number
$hello = 7890 ;
$keep_hello = $hello ;

$compr = compress($hello) ;
ok $compr ne "" ;

$keep_compr = $compr ;

$uncompr = uncompress ($compr) ;

ok $hello eq $uncompr ;

ok $hello eq $keep_hello ;
ok $compr eq $keep_compr ;

# bigger compress

$compr = compress ($contents) ;
ok $compr ne "" ;

$uncompr = uncompress ($compr) ;

ok $contents eq $uncompr ;

# buffer reference

$compr = compress(\$hello) ;
ok $compr ne "" ;


$uncompr = uncompress (\$compr) ;
ok $hello eq $uncompr ;

# bad level
$compr = compress($hello, 1000) ;
ok ! defined $compr;

# change level
$compr = compress($hello, Z_BEST_COMPRESSION) ;
ok defined $compr;
$uncompr = uncompress (\$compr) ;
ok $hello eq $uncompr ;

# corrupt data
$compr = compress(\$hello) ;
ok $compr ne "" ;

substr($compr,0, 1) = "\xFF";
ok !defined uncompress (\$compr) ;

# deflate/inflate - small buffer
# ==============================

$hello = "I am a HAL 9000 computer" ;
my @hello = split('', $hello) ;
my ($err, $X, $status);
 
ok  (($x, $err) = deflateInit( {-Bufsize => 1} ) ) ;
ok $x ;
ok $err == Z_OK ;
 
my $Answer = '';
foreach (@hello)
{
    ($X, $status) = $x->deflate($_) ;
    last unless $status == Z_OK ;

    $Answer .= $X ;
}
 
ok $status == Z_OK ;

ok    ((($X, $status) = $x->flush())[1] == Z_OK ) ;
$Answer .= $X ;
 
 
my @Answer = split('', $Answer) ;
 
my $k;
ok (($k, $err) = inflateInit( {-Bufsize => 1}) ) ;
ok $k ;
ok $err == Z_OK ;
 
my $GOT = '';
my $Z;
foreach (@Answer)
{
    ($Z, $status) = $k->inflate($_) ;
    $GOT .= $Z ;
    last if $status == Z_STREAM_END or $status != Z_OK ;
 
}
 
ok $status == Z_STREAM_END ;
ok $GOT eq $hello ;


title 'deflate/inflate - small buffer with a number';
# ==============================

$hello = 6529 ;
 
ok (($x, $err) = deflateInit( {-Bufsize => 1} ) ) ;
ok $x ;
ok $err == Z_OK ;
 
ok !defined $x->msg() ;
ok $x->total_in() == 0 ;
ok $x->total_out() == 0 ;
$Answer = '';
{
    ($X, $status) = $x->deflate($hello) ;

    $Answer .= $X ;
}
 
ok $status == Z_OK ;

ok   ((($X, $status) = $x->flush())[1] == Z_OK ) ;
$Answer .= $X ;
 
ok !defined $x->msg() ;
ok $x->total_in() == length $hello ;
ok $x->total_out() == length $Answer ;

 
@Answer = split('', $Answer) ;
 
ok (($k, $err) = inflateInit( {-Bufsize => 1}) ) ;
ok $k ;
ok $err == Z_OK ;

ok !defined $k->msg() ;
ok $k->total_in() == 0 ;
ok $k->total_out() == 0 ;
 
$GOT = '';
foreach (@Answer)
{
    ($Z, $status) = $k->inflate($_) ;
    $GOT .= $Z ;
    last if $status == Z_STREAM_END or $status != Z_OK ;
 
}
 
ok $status == Z_STREAM_END ;
ok $GOT eq $hello ;

ok !defined $k->msg() ;
is $k->total_in(), length $Answer ;
ok $k->total_out() == length $hello ;


 
title 'deflate/inflate - larger buffer';
# ==============================


ok $x = deflateInit() ;
 
ok ((($X, $status) = $x->deflate($contents))[1] == Z_OK) ;

my $Y = $X ;
 
 
ok ((($X, $status) = $x->flush() )[1] == Z_OK ) ;
$Y .= $X ;
 
 
 
ok $k = inflateInit() ;
 
($Z, $status) = $k->inflate($Y) ;
 
ok $status == Z_STREAM_END ;
ok $contents eq $Z ;

title 'deflate/inflate - preset dictionary';
# ===================================

my $dictionary = "hello" ;
ok $x = deflateInit({-Level => Z_BEST_COMPRESSION,
			 -Dictionary => $dictionary}) ;
 
my $dictID = $x->dict_adler() ;

($X, $status) = $x->deflate($hello) ;
ok $status == Z_OK ;
($Y, $status) = $x->flush() ;
ok $status == Z_OK ;
$X .= $Y ;
$x = 0 ;
 
ok $k = inflateInit(-Dictionary => $dictionary) ;
 
($Z, $status) = $k->inflate($X);
ok $status == Z_STREAM_END ;
ok $k->dict_adler() == $dictID;
ok $hello eq $Z ;

#$Z='';
#while (1) {
#    ($Z, $status) = $k->inflate($X) ;
#    last if $status == Z_STREAM_END or $status != Z_OK ;
#print "status=[$status] hello=[$hello] Z=[$Z]\n";
#}
#ok $status == Z_STREAM_END ;
#ok $hello eq $Z  
# or print "status=[$status] hello=[$hello] Z=[$Z]\n";






title 'inflate - check remaining buffer after Z_STREAM_END';
# ===================================================
 
{
    ok $x = deflateInit(-Level => Z_BEST_COMPRESSION ) ;
 
    ($X, $status) = $x->deflate($hello) ;
    ok $status == Z_OK ;
    ($Y, $status) = $x->flush() ;
    ok $status == Z_OK ;
    $X .= $Y ;
    $x = 0 ;
 
    ok $k = inflateInit()  ;
 
    my $first = substr($X, 0, 2) ;
    my $last  = substr($X, 2) ;
    ($Z, $status) = $k->inflate($first);
    ok $status == Z_OK ;
    ok $first eq "" ;

    $last .= "appendage" ;
    my $T;
    ($T, $status) = $k->inflate($last);
    ok $status == Z_STREAM_END ;
    ok $hello eq $Z . $T ;
    ok $last eq "appendage" ;

}

title 'memGzip & memGunzip';
{
    my $name = "test.gz" ;
    my $buffer = <<EOM;
some sample 
text

EOM

    my $len = length $buffer ;
    my ($x, $uncomp) ;


    # create an in-memory gzip file
    my $dest = Compress::Zlib::memGzip($buffer) ;
    ok length $dest ;

    # write it to disk
    ok open(FH, ">$name") ;
    binmode(FH);
    print FH $dest ;
    close FH ;

    # uncompress with gzopen
    ok my $fil = gzopen($name, "rb") ;
 
    is $fil->gzread($uncomp, 0), 0 ;
    ok (($x = $fil->gzread($uncomp)) == $len) ;
 
    ok ! $fil->gzclose ;

    ok $uncomp eq $buffer ;
 
    unlink $name ;

    # now check that memGunzip can deal with it.
    my $ungzip = Compress::Zlib::memGunzip($dest) ;
    ok defined $ungzip ;
    ok $buffer eq $ungzip ;
 
    # now do the same but use a reference 

    $dest = Compress::Zlib::memGzip(\$buffer) ; 
    ok length $dest ;

    # write it to disk
    ok open(FH, ">$name") ;
    binmode(FH);
    print FH $dest ;
    close FH ;

    # uncompress with gzopen
    ok $fil = gzopen($name, "rb") ;
 
    ok (($x = $fil->gzread($uncomp)) == $len) ;
 
    ok ! $fil->gzclose ;

    ok $uncomp eq $buffer ;
 
    # now check that memGunzip can deal with it.
    my $keep = $dest;
    $ungzip = Compress::Zlib::memGunzip(\$dest) ;
    ok defined $ungzip ;
    ok $buffer eq $ungzip ;

    # check memGunzip can cope with missing gzip trailer
    my $minimal = substr($keep, 0, -1) ;
    $ungzip = Compress::Zlib::memGunzip(\$minimal) ;
    ok defined $ungzip ;
    ok $buffer eq $ungzip ;

    $minimal = substr($keep, 0, -2) ;
    $ungzip = Compress::Zlib::memGunzip(\$minimal) ;
    ok defined $ungzip ;
    ok $buffer eq $ungzip ;

    $minimal = substr($keep, 0, -3) ;
    $ungzip = Compress::Zlib::memGunzip(\$minimal) ;
    ok defined $ungzip ;
    ok $buffer eq $ungzip ;

    $minimal = substr($keep, 0, -4) ;
    $ungzip = Compress::Zlib::memGunzip(\$minimal) ;
    ok defined $ungzip ;
    ok $buffer eq $ungzip ;

    $minimal = substr($keep, 0, -5) ;
    $ungzip = Compress::Zlib::memGunzip(\$minimal) ;
    ok defined $ungzip ;
    ok $buffer eq $ungzip ;

    $minimal = substr($keep, 0, -6) ;
    $ungzip = Compress::Zlib::memGunzip(\$minimal) ;
    ok defined $ungzip ;
    ok $buffer eq $ungzip ;

    $minimal = substr($keep, 0, -7) ;
    $ungzip = Compress::Zlib::memGunzip(\$minimal) ;
    ok defined $ungzip ;
    ok $buffer eq $ungzip ;

    $minimal = substr($keep, 0, -8) ;
    $ungzip = Compress::Zlib::memGunzip(\$minimal) ;
    ok defined $ungzip ;
    ok $buffer eq $ungzip ;

    $minimal = substr($keep, 0, -9) ;
    $ungzip = Compress::Zlib::memGunzip(\$minimal) ;
    ok ! defined $ungzip ;

 
    unlink $name ;

    # check corrupt header -- too short
    $dest = "x" ;
    my $result = Compress::Zlib::memGunzip($dest) ;
    ok !defined $result ;

    # check corrupt header -- full of junk
    $dest = "x" x 200 ;
    $result = Compress::Zlib::memGunzip($dest) ;
    ok !defined $result ;

    # corrupt header - 1st byte wrong
    my $bad = $keep ;
    substr($bad, 0, 1) = "\xFF" ;
    $ungzip = Compress::Zlib::memGunzip(\$bad) ;
    ok ! defined $ungzip ;

    # corrupt header - 2st byte wrong
    $bad = $keep ;
    substr($bad, 1, 1) = "\xFF" ;
    $ungzip = Compress::Zlib::memGunzip(\$bad) ;
    ok ! defined $ungzip ;

    # corrupt header - method not deflated
    $bad = $keep ;
    substr($bad, 2, 1) = "\xFF" ;
    $ungzip = Compress::Zlib::memGunzip(\$bad) ;
    ok ! defined $ungzip ;

    # corrupt header - reserverd bits used
    $bad = $keep ;
    substr($bad, 3, 1) = "\xFF" ;
    $ungzip = Compress::Zlib::memGunzip(\$bad) ;
    ok ! defined $ungzip ;

    # corrupt trailer - length wrong
    $bad = $keep ;
    substr($bad, -8, 4) = "\xFF" x 4 ;
    $ungzip = Compress::Zlib::memGunzip(\$bad) ;
    ok ! defined $ungzip ;

    # corrupt trailer - CRC wrong
    $bad = $keep ;
    substr($bad, -4, 4) = "\xFF" x 4 ;
    $ungzip = Compress::Zlib::memGunzip(\$bad) ;
    ok ! defined $ungzip ;
}

title 'memGunzip with a gzopen created file';
{
    my $name = "test.gz" ;
    my $buffer = <<EOM;
some sample 
text

EOM

    ok $fil = gzopen($name, "wb") ;

    ok $fil->gzwrite($buffer) == length $buffer ;

    ok ! $fil->gzclose ;

    my $compr = readFile($name);
    ok length $compr ;
    my $unc = Compress::Zlib::memGunzip($compr) ;
    ok defined $unc ;
    ok $buffer eq $unc ;
    unlink $name ;
}

{

    # Check - MAX_WBITS
    # =================
    
    $hello = "Test test test test test";
    @hello = split('', $hello) ;
     
    ok (($x, $err) = deflateInit( -Bufsize => 1, -WindowBits => -MAX_WBITS() ) ) ;
    ok $x ;
    ok $err == Z_OK ;
     
    $Answer = '';
    foreach (@hello)
    {
        ($X, $status) = $x->deflate($_) ;
        last unless $status == Z_OK ;
    
        $Answer .= $X ;
    }
     
    ok $status == Z_OK ;
    
    ok   ((($X, $status) = $x->flush())[1] == Z_OK ) ;
    $Answer .= $X ;
     
     
    @Answer = split('', $Answer) ;
    # Undocumented corner -- extra byte needed to get inflate to return 
    # Z_STREAM_END when done.  
    push @Answer, " " ; 
     
    ok (($k, $err) = inflateInit(-Bufsize => 1, -WindowBits => -MAX_WBITS()) ) ;
    ok $k ;
    ok $err == Z_OK ;
     
    $GOT = '';
    foreach (@Answer)
    {
        ($Z, $status) = $k->inflate($_) ;
        $GOT .= $Z ;
        last if $status == Z_STREAM_END or $status != Z_OK ;
     
    }
     
    ok $status == Z_STREAM_END ;
    ok $GOT eq $hello ;
    
}

{
    # inflateSync

    # create a deflate stream with flush points

    my $hello = "I am a HAL 9000 computer" x 2001 ;
    my $goodbye = "Will I dream?" x 2010;
    my ($err, $answer, $X, $status, $Answer);
     
    ok (($x, $err) = deflateInit() ) ;
    ok $x ;
    ok $err == Z_OK ;
     
    ($Answer, $status) = $x->deflate($hello) ;
    ok $status == Z_OK ;
    
    # create a flush point
    ok ((($X, $status) = $x->flush(Z_FULL_FLUSH))[1] == Z_OK ) ;
    $Answer .= $X ;
     
    ($X, $status) = $x->deflate($goodbye) ;
    ok $status == Z_OK ;
    $Answer .= $X ;
    
    ok ((($X, $status) = $x->flush())[1] == Z_OK ) ;
    $Answer .= $X ;
     
    my ($first, @Answer) = split('', $Answer) ;
     
    my $k;
    ok (($k, $err) = inflateInit()) ;
    ok $k ;
    ok $err == Z_OK ;
     
    ($Z, $status) = $k->inflate($first) ;
    ok $status == Z_OK ;

    # skip to the first flush point.
    while (@Answer)
    {
        my $byte = shift @Answer;
        $status = $k->inflateSync($byte) ;
        last unless $status == Z_DATA_ERROR;
     
    }

    ok $status == Z_OK;
     
    my $GOT = '';
    my $Z = '';
    foreach (@Answer)
    {
        my $Z = '';
        ($Z, $status) = $k->inflate($_) ;
        $GOT .= $Z if defined $Z ;
        # print "x $status\n";
        last if $status == Z_STREAM_END or $status != Z_OK ;
     
    }
     
    # zlib 1.0.9 returns Z_STREAM_END here, all others return Z_DATA_ERROR
    ok $status == Z_DATA_ERROR || $status == Z_STREAM_END ;
    ok $GOT eq $goodbye ;


    # Check inflateSync leaves good data in buffer
    $Answer =~ /^(.)(.*)$/ ;
    my ($initial, $rest) = ($1, $2);

    
    ok (($k, $err) = inflateInit()) ;
    ok $k ;
    ok $err == Z_OK ;
     
    ($Z, $status) = $k->inflate($initial) ;
    ok $status == Z_OK ;

    $status = $k->inflateSync($rest) ;
    ok $status == Z_OK;
     
    ($GOT, $status) = $k->inflate($rest) ;
     
    ok $status == Z_DATA_ERROR ;
    ok $Z . $GOT eq $goodbye ;
}

{
    # deflateParams

    my $hello = "I am a HAL 9000 computer" x 2001 ;
    my $goodbye = "Will I dream?" x 2010;
    my ($input, $err, $answer, $X, $status, $Answer);
     
    ok (($x, $err) = deflateInit(-Level    => Z_BEST_COMPRESSION,
                                     -Strategy => Z_DEFAULT_STRATEGY) ) ;
    ok $x ;
    ok $err == Z_OK ;

    ok $x->get_Level()    == Z_BEST_COMPRESSION;
    ok $x->get_Strategy() == Z_DEFAULT_STRATEGY;
     
    ($Answer, $status) = $x->deflate($hello) ;
    ok $status == Z_OK ;
    $input .= $hello;
    
    # error cases
    eval { $x->deflateParams() };
    ok $@ =~ m#^Compress::Zlib::deflateParams needs Level and/or Strategy#;

    eval { $x->deflateParams(-Joe => 3) };
    ok $@ =~ /^Compress::Zlib::deflateStream::deflateParams: unknown key value\(s\) Joe at/
        or print "# $@\n" ;

    ok $x->get_Level()    == Z_BEST_COMPRESSION;
    ok $x->get_Strategy() == Z_DEFAULT_STRATEGY;
     
    # change both Level & Strategy
    $status = $x->deflateParams(-Level => Z_BEST_SPEED, -Strategy => Z_HUFFMAN_ONLY) ;
    ok $status == Z_OK ;
    
    ok $x->get_Level()    == Z_BEST_SPEED;
    ok $x->get_Strategy() == Z_HUFFMAN_ONLY;
     
    ($X, $status) = $x->deflate($goodbye) ;
    ok $status == Z_OK ;
    $Answer .= $X ;
    $input .= $goodbye;
    
    # change only Level 
    $status = $x->deflateParams(-Level => Z_NO_COMPRESSION) ;
    ok $status == Z_OK ;
    
    ok $x->get_Level()    == Z_NO_COMPRESSION;
    ok $x->get_Strategy() == Z_HUFFMAN_ONLY;
     
    ($X, $status) = $x->deflate($goodbye) ;
    ok $status == Z_OK ;
    $Answer .= $X ;
    $input .= $goodbye;
    
    # change only Strategy
    $status = $x->deflateParams(-Strategy => Z_FILTERED) ;
    ok $status == Z_OK ;
    
    ok $x->get_Level()    == Z_NO_COMPRESSION;
    ok $x->get_Strategy() == Z_FILTERED;
     
    ($X, $status) = $x->deflate($goodbye) ;
    ok $status == Z_OK ;
    $Answer .= $X ;
    $input .= $goodbye;
    
    ok ((($X, $status) = $x->flush())[1] == Z_OK ) ;
    $Answer .= $X ;
     
    my ($first, @Answer) = split('', $Answer) ;
     
    my $k;
    ok (($k, $err) = inflateInit()) ;
    ok $k ;
    ok $err == Z_OK ;
     
    ($Z, $status) = $k->inflate($Answer) ;

    ok $status == Z_STREAM_END 
        or print "# status $status\n";
    ok $Z  eq $input ;
}

{
    # error cases

    eval { deflateInit(-Level) };
    like $@, '/^Compress::Zlib::deflateInit: Expected even number of parameters, got 1/';

    eval { inflateInit(-Level) };
    like $@, '/^Compress::Zlib::inflateInit: Expected even number of parameters, got 1/';

    eval { deflateInit(-Joe => 1) };
    ok $@ =~ /^Compress::Zlib::deflateInit: unknown key value\(s\) Joe at/;

    eval { inflateInit(-Joe => 1) };
    ok $@ =~ /^Compress::Zlib::inflateInit: unknown key value\(s\) Joe at/;

    eval { deflateInit(-Bufsize => 0) };
    ok $@ =~ /^.*?: Bufsize must be >= 1, you specified 0 at/;

    eval { inflateInit(-Bufsize => 0) };
    ok $@ =~ /^.*?: Bufsize must be >= 1, you specified 0 at/;

    eval { deflateInit(-Bufsize => -1) };
    #ok $@ =~ /^.*?: Bufsize must be >= 1, you specified -1 at/;
    ok $@ =~ /^Compress::Zlib::deflateInit: Parameter 'Bufsize' must be an unsigned int, got '-1'/;

    eval { inflateInit(-Bufsize => -1) };
    ok $@ =~ /^Compress::Zlib::inflateInit: Parameter 'Bufsize' must be an unsigned int, got '-1'/;

    eval { deflateInit(-Bufsize => "xxx") };
    ok $@ =~ /^Compress::Zlib::deflateInit: Parameter 'Bufsize' must be an unsigned int, got 'xxx'/;

    eval { inflateInit(-Bufsize => "xxx") };
    ok $@ =~ /^Compress::Zlib::inflateInit: Parameter 'Bufsize' must be an unsigned int, got 'xxx'/;

    eval { gzopen([], 0) ; }  ;
    ok $@ =~ /^gzopen: file parameter is not a filehandle or filename at/
	or print "# $@\n" ;

    my $x = Symbol::gensym() ;
    eval { gzopen($x, 0) ; }  ;
    ok $@ =~ /^gzopen: file parameter is not a filehandle or filename at/
	or print "# $@\n" ;

}

if ($] >= 5.005)
{
    # test inflate with a substr

    ok my $x = deflateInit() ;
     
    ok ((my ($X, $status) = $x->deflate($contents))[1] == Z_OK) ;
    
    my $Y = $X ;

     
     
    ok ((($X, $status) = $x->flush() )[1] == Z_OK ) ;
    $Y .= $X ;
     
    my $append = "Appended" ;
    $Y .= $append ;
     
    ok $k = inflateInit() ;
     
    #($Z, $status) = $k->inflate(substr($Y, 0, -1)) ;
    ($Z, $status) = $k->inflate(substr($Y, 0)) ;
     
    ok $status == Z_STREAM_END ;
    ok $contents eq $Z ;
    is $Y, $append;
    
}

if ($] >= 5.005)
{
    # deflate/inflate in scalar context

    ok my $x = deflateInit() ;
     
    my $X = $x->deflate($contents);
    
    my $Y = $X ;

     
     
    $X = $x->flush();
    $Y .= $X ;
     
    my $append = "Appended" ;
    $Y .= $append ;
     
    ok $k = inflateInit() ;
     
    #$Z = $k->inflate(substr($Y, 0, -1)) ;
    $Z = $k->inflate(substr($Y, 0)) ;
     
    ok $contents eq $Z ;
    is $Y, $append;
    
}

{
    title 'CRC32' ;

    my $data = 'ZgRNtjgSUW'; # CRC32 of this data should have the high bit set
    my $expected_crc = 0xCF707A2B ; # 3480255019 
    my $crc = crc32($data) ;
    is $crc, $expected_crc;
}

{
    title 'Adler32' ;

    my $data = 'lpscOVsAJiUfNComkOfWYBcPhHZ[bT'; # adler of this data should have the high bit set
    my $expected_crc = 0xAAD60AC7 ; # 2866154183 
    my $crc = adler32($data) ;
    is $crc, $expected_crc;
}

{
    # memGunzip - input > 4K

    my $contents = '' ;
    foreach (1 .. 20000)
      { $contents .= chr int rand 256 }

    ok my $compressed = Compress::Zlib::memGzip(\$contents) ;

    ok length $compressed > 4096 ;
    ok my $out = Compress::Zlib::memGunzip(\$compressed) ;
     
    ok $contents eq $out ;
    is length $out, length $contents ;

    
}


{
    # memGunzip Header Corruption Tests

    my $string = <<EOM;
some text
EOM

    my $good ;
    ok my $x = new IO::Compress::Gzip \$good, Append => 1, -HeaderCRC => 1 ;
    ok $x->write($string) ;
    ok  $x->close ;

    {
        title "Header Corruption - Fingerprint wrong 1st byte" ;
        my $buffer = $good ;
        substr($buffer, 0, 1) = 'x' ;

        ok ! Compress::Zlib::memGunzip(\$buffer) ;
    }

    {
        title "Header Corruption - Fingerprint wrong 2nd byte" ;
        my $buffer = $good ;
        substr($buffer, 1, 1) = "\xFF" ;

        ok ! Compress::Zlib::memGunzip(\$buffer) ;
    }

    {
        title "Header Corruption - CM not 8";
        my $buffer = $good ;
        substr($buffer, 2, 1) = 'x' ;

        ok ! Compress::Zlib::memGunzip(\$buffer) ;
    }

    {
        title "Header Corruption - Use of Reserved Flags";
        my $buffer = $good ;
        substr($buffer, 3, 1) = "\xff";

        ok ! Compress::Zlib::memGunzip(\$buffer) ;
    }

}

for my $index ( GZIP_MIN_HEADER_SIZE + 1 ..  GZIP_MIN_HEADER_SIZE + GZIP_FEXTRA_HEADER_SIZE + 1)
{
    title "Header Corruption - Truncated in Extra";
    my $string = <<EOM;
some text
EOM

    my $truncated ;
    ok  my $x = new IO::Compress::Gzip \$truncated, Append => 1, -HeaderCRC => 1, Strict => 0,
				-ExtraField => "hello" x 10  ;
    ok  $x->write($string) ;
    ok  $x->close ;

    substr($truncated, $index) = '' ;

    ok ! Compress::Zlib::memGunzip(\$truncated) ;


}

my $Name = "fred" ;
for my $index ( GZIP_MIN_HEADER_SIZE ..  GZIP_MIN_HEADER_SIZE + length($Name) -1)
{
    title "Header Corruption - Truncated in Name";
    my $string = <<EOM;
some text
EOM

    my $truncated ;
    ok  my $x = new IO::Compress::Gzip \$truncated, Append => 1, -Name => $Name;
    ok  $x->write($string) ;
    ok  $x->close ;

    substr($truncated, $index) = '' ;

    ok ! Compress::Zlib::memGunzip(\$truncated) ;
}

my $Comment = "comment" ;
for my $index ( GZIP_MIN_HEADER_SIZE ..  GZIP_MIN_HEADER_SIZE + length($Comment) -1)
{
    title "Header Corruption - Truncated in Comment";
    my $string = <<EOM;
some text
EOM

    my $truncated ;
    ok  my $x = new IO::Compress::Gzip \$truncated, -Comment => $Comment;
    ok  $x->write($string) ;
    ok  $x->close ;

    substr($truncated, $index) = '' ;
    ok ! Compress::Zlib::memGunzip(\$truncated) ;
}

for my $index ( GZIP_MIN_HEADER_SIZE ..  GZIP_MIN_HEADER_SIZE + GZIP_FHCRC_SIZE -1)
{
    title "Header Corruption - Truncated in CRC";
    my $string = <<EOM;
some text
EOM

    my $truncated ;
    ok  my $x = new IO::Compress::Gzip \$truncated, -HeaderCRC => 1;
    ok  $x->write($string) ;
    ok  $x->close ;

    substr($truncated, $index) = '' ;

    ok ! Compress::Zlib::memGunzip(\$truncated) ;
}

{
    title "memGunzip can cope with a gzip header with all possible fields";
    my $string = <<EOM;
some text
EOM

    my $buffer ;
    ok  my $x = new IO::Compress::Gzip \$buffer, 
                             -Append     => 1,
                             -Strict     => 0,
                             -HeaderCRC  => 1,
                             -Name       => "Fred",
                             -ExtraField => "Extra",
                             -Comment    => 'Comment';
    ok  $x->write($string) ;
    ok  $x->close ;

    ok defined $buffer ;

    ok my $got = Compress::Zlib::memGunzip($buffer) 
        or diag "gzerrno is $gzerrno" ;
    is $got, $string ;
}


{
    # Trailer Corruption tests

    my $string = <<EOM;
some text
EOM

    my $good ;
    ok  my $x = new IO::Compress::Gzip \$good, Append => 1 ;
    ok  $x->write($string) ;
    ok  $x->close ;

    foreach my $trim (-8 .. -1)
    {
        my $got = $trim + 8 ;
        title "Trailer Corruption - Trailer truncated to $got bytes" ;
        my $buffer = $good ;

        substr($buffer, $trim) = '';

        ok my $u = Compress::Zlib::memGunzip(\$buffer) ;
        ok $u eq $string;

    }

    {
        title "Trailer Corruption - Length Wrong, CRC Correct" ;
        my $buffer = $good ;
        substr($buffer, -4, 4) = pack('V', 1234);

        ok ! Compress::Zlib::memGunzip(\$buffer) ;
    }

    {
        title "Trailer Corruption - Length Wrong, CRC Wrong" ;
        my $buffer = $good ;
        substr($buffer, -4, 4) = pack('V', 1234);
        substr($buffer, -8, 4) = pack('V', 1234);

        ok ! Compress::Zlib::memGunzip(\$buffer) ;

    }
}




