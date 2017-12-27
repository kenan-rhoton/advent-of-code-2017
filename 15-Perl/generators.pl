$GenA = 679;
$GenB = 771;
# $GenA = 65;
# $GenB = 8921;
$judge = 0;
$mask = 131071;

for (my $i=0; $i <= 40_000_000; $i++){
    $GenA = ($GenA * 16807) % 2147483647;
    $GenB = ($GenB * 48271) % 2147483647;
    if (($GenA & 0xFFFF) == ($GenB & 0xFFFF)) {
        $judge++;
    }
}

print $judge;
print "\n";
