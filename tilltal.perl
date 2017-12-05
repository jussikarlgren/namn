$threshold = 10;  # set to VERY LARGE to avoid filtering
$listoutput=0;

while (<>) {
    ($namn,$tilltal,$kon,$fodar,$fodelseforsamling,$fodelseort,$bostadsort,$antal) = split "\t";
    $freq{$namn}++;
    $pervij{$namn}++ if $tilltal eq "J";
    $vtoroj{$namn}++ if $tilltal eq "N";
    $neznato{$namn}++ unless $tilltal;
    $i++;
}
$truperv = 0;
$mozperv = 0;
$someperv = 0;
$truvtor = 0;
$mozvtor = 0;
$somevtor = 0;
$truneznato = 0;
$neznatoall = 0;
$someneznato = 0;
for $namn (keys %pervij) {
    next if $freq{$namn} < $threshold;
    $truperv++ unless ($vtoroj{$namn} || $neznato{$namn});   # förekommer enbart som tilltalsnamn
    $mozperv++ if (! $vtoroj{$namn} && $neznato{$namn});     # förekommer enbart som tilltalsnamn eller icke angivet namn
    $known++ if (! $neznato{$namn});                         # förekommer enbart som antingen tilltals- eller andranamn, aldrig okän
}
for $namn (keys %vtoroj) {
    next if $freq{$namn} < $threshold;
    $truvtor++ unless ($pervij{$namn} || $neznato{$namn});   # förekommer enbart som andranamn
    $mozvtor++ if (! $pervij{$namn} && $neznato{$namn});     # förekommer enbart som andranamn eller icke angivet namn
}
for $namn (keys %neznato) {
    next if $freq{$namn} < $threshold;
    $truneznato++ unless ($pervij{$namn} || $vtoroj{$namn}); # har aldrig förekommit som angivet tilltals- eller andranamn
    $neznatoall++  if ($pervij{$namn} && $vtoroj{$namn});      # har förekommit som icke angivet namn, tilltalsnamn och andranamn
}

if ($listoutput) {
    for $namn (keys %freq) {
	next if $freq{$namn} < $threshold;
	print "$namn\t$freq{$namn}\t$pervij{$namn}\t$vtoroj{$namn}\t$neznato{$namn}\n";
    }
}

print "namn: $i\n";
print "threshold: $threshold\n";
print "tru 1: $truperv\n";
print "tru 2: $truvtor\n";
print "tru 0: $truneznato\n";
print "moz 1: $mozperv\n";
print "moz 2: $mozvtor\n";
print "unk12: $neznatoall\n";
print "knw12: $known\n";

