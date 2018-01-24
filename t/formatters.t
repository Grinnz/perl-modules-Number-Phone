#!/usr/bin/perl -w

use strict;
use lib 't/inc';
use fatalwarnings;

use Number::Phone;
use Number::Phone::Lib;
use Test::More;
use Scalar::Util qw(blessed);

END { done_testing(); }

my %tests = (
    '+44 20 8771 2924' => '2087712924',   # UK
    '+1 202 418 1440'  => '2024181440',   # NANP::US
    '+81 3-3580-3311'  => '335803311'     # StubCountry::JP
);

note("format_using('Raw')");
while (my ($num, $expect) = each %tests) {
    my $number = Number::Phone->new($num);
    is($number->format_using('Raw'), $expect, blessed($number)."'s raw_number() works");
}

note("format_using('E123')");
is(
    Number::Phone->new('+44 20 8771 2924')->format_using('E123'),
    '+44 20 8771 2924',
    "format_using('E123') works too"
);

note("format_using('NationallyPreferred')");
is(
    Number::Phone::Lib->new('+1 202 418 1440')->format_using('NationallyPreferred'),
    '+1 202-418-1440',
    "format_using('NationallyPreferred') works too"
);
is(
    Number::Phone->new('+1 202 418 1440')->format_using('NationallyPreferred'),
    '+1 202 418 1440',
    "format_using('NationallyPreferred') fails gracefully if no data is available"
);

note("format_using('non-existent formatter')");
eval { Number::Phone->new('+44 20 8771 2924')->format_using('FishAndChips') };
like(
    $@,
    qr/^Couldn't load format 'FishAndChips':/,
    "format_using dies when asked to use a non-existent formatter"
)
