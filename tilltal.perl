$threshold = 100;
while (<>) {
    ($namn,$tilltal,$kon,$fodar,$fodelseforsamling,$fodelseort,$bostadsort,$antal) = split "\t";
    $freq{$namn}++;
    $pervij{$namn}++ if $tilltal eq "J";
    $vtoroj{$namn}++ if $tilltal eq "N";
    $neznat{$namn}++ unless $tilltal;
    $i++;
}
$truperv = 0;
$mozperv = 0;
$someperv = 0;
$truvtor = 0;
$mozvtor = 0;
$somevtor = 0;
$truneznat = 0;
$neznatb = 0;
$neznatp = 0;
$neznatv = 0;
$someneznat = 0;
for $namn (keys %pervij) {
    $truperv++ unless ($vtoroj{$namn} || $neznat{$namn}); 
    $mozperv++ if (! $vtoroj{$namn} && $neznat{$namn}); 
    $someperv++;}
for $namn (keys %vtoroj) {
    $truvtor++ unless ($pervij{$namn} || $neznat{$namn}); 
    $mozvtor++ if (! $pervij{$namn} && $neznat{$namn}); 
    $somevtor++;}
for $namn (keys %neznat) {
    $truneznat++ unless ($pervij{$namn} || $vtoroj{$namn}); 
    $neznatb++  if ($pervij{$namn} && $vtoroj{$namn});
    $neznatp++  if ($pervij{$namn} && ! $vtoroj{$namn});
    $neznatv++ if (! $pervij{$namn} && $vtoroj{$namn});
    $someneznat++;}
    
print "$i\n";
print "$truperv\t$mozperv\t".$mozperv+$truperv."\t$someperv\n";
print "$truvtor\t$mozvtor\t".$mozvtor+$truvtor."\t$somevtor\n";
print "$truneznat\t$neznatb\t$neznatp\t$neznatv\t$someneznat\n";
