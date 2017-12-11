$debug=0;
open(REF,"<tot.dist");
while (<REF>) {
    ($a,$b,$c)=split;
    $ref{int(100*$a)}=$c;
}
close REF;

while (<>) {
    ($a,$b,$c)=split;
    $obs{int(100*$a)}=$c;
}

$dist = 0;
$n = 0;
for $k (keys %ref) {
    next unless $obs{$k};
    print "$k    $dist += ($obs{$k}-$ref{$k})**2;\n" if $debug;
    $dist += ($obs{$k}-$ref{$k})**2;
    $n++;
}
$dist = $dist/$n if $n;
print "$dist\n";
