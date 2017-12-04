$threshold = 100;
$minimum = 0.05;
while (<>) {
    ($namn,$tilltal,$kon,$fodar,$fodelseforsamling,$fodelseort,$bostadsort,$antal) = split "\t";
    $man{$namn}++ if $kon eq "M";
    $kvinna{$namn}++ if $kon eq "K";
    $freq{$namn}++;
    if ($tilltal eq "J") {
	$manT{$namn}++ if $kon eq "M";
	$kvinnaT{$namn}++ if $kon eq "K";
	$freqT{$namn}++;
    }
}
for $namn (keys %freq) {
    $kvot = 0;
    $kvotT = 0;
    next if $freq{$namn} < $threshold;

    $kvot = int($kvinna{$namn}/($kvinna{$namn}+$man{$namn})*1000)/1000 if ($man{$namn} && $kvinna{$namn});
    if ($kvot < $minimum || $kvot > 1 - $minimum) {$kvot = 0;}
    $kvi++    if ($kvinna{$namn} && ! $kvot);
    $man++    if ($man{$namn} && ! $kvot);
    $amb++ if $kvot;
    $ambf += $freq{$namn} if $kvot;

    $kvotT = int($kvinnaT{$namn}/($kvinnaT{$namn}+$manT{$namn})*1000)/1000 if ($manT{$namn} && $kvinnaT{$namn});
    if ($kvotT < $minimum || $kvotT > 1 - $minimum) {$kvotT = 0;}
    $kviT++    if ($kvinnaT{$namn} && ! $kvotT);
    $manT++    if ($manT{$namn} && ! $kvotT);
    $ambT++ if $kvotT;
    $ambfT += $freqT{$namn} if $kvotT;
    
    print "$namn\t$kvot\t$freq{$namn}\t$kvinna{$namn}\t$man{$namn}\t$kvotT\t$freqT{$namn}\t$kvinnaT{$namn}\t$manT{$namn}\n" if $kvotT; #($kvot || $kvotT); 
}
print "$kvi $man $amb\n";
print "$kviT $manT $ambT\n";
    
