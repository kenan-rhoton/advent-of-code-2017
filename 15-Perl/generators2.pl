$GenA = 679;
$GenB = 771;
# $GenA = 65;
# $GenB = 8921;
$judge = 0;
$mask = 131071;

for (my $i=0; $i <= 5_000_000; $i++){
    do {$GenA = ($GenA * 16807) % 2147483647;} while $GenA & 3;
    do {$GenB = ($GenB * 48271) % 2147483647;} while $GenB & 7;
    if (($GenA & 0xFFFF) == ($GenB & 0xFFFF)) {
        $judge++;
    }
}

print $judge;
print "\n";
