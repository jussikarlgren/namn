use Getopt::Std;
#==========================================================================
# i rullande w-årsfönster (w = 5 by default; $window) 
# kolla vilka m namn (m = 25 by default; $topplista)
# som växt till sig snabbast i det aktuella fönstret jämfört med historien och
# redovisa de o orter (o = 10; $ortlista) som varit de 
# r tidigaste (r = 5; $kreativ) att ge sina barn namnet.
#==========================================================================
$threshold = 100;
$window = 5;
$tilltalsfilter = 0;
$segment=100;
$topplista = 25;
$ortlista = 10;
$kreativ = 5;

&getopts('l:d:k:t:w:f:s:o:r:m:');
$konfilter = $opt_k if $opt_k;
$landsdelsfilter = $opt_l if $opt_l;
$decenniefilter = $opt_d if $opt_d;
$tilltalsfilter = $opt_t if $opt_t;
$threshold = $opt_f if $opt_f;
$window = $opt_w if $opt_w;
$segment = $opt_s if $opt_s;
$topplista = $opt_m if $opt_m;
$kreativ = $opt_r if $opt_r;
$ortlista = $opt_o if $opt_o;

open HH,"<data/ortlandsdel.lista";
while(<HH>) {
    chomp;
    @hh = split "\t";
    $landsdel{$hh[0]} = $hh[2];
    $region{$hh[0]} = $hh[1];
}
close HH;
#==========================================================================
# LÄS IN BASDATA
while (<>) {
    ($namn,$tilltal,$kon,$fodar,$fodelseforsamling,$fodelseort,$bostadsort,$antal) = split "\t";
    next if $fodar < 1920;
    next if ($tilltal ne "J" && $tilltalsfilter);
    next if ($konfilter && $kon ne $konfilter);
    next if ($aldersfilter && $fodar != $aldersfilter);
    next if ($fodelseortsfilter && $fodelseort ne $fodelsortsfilter);
    next if ($landsdelsfilter && $landsdel{$fodelseort} ne $landsdelsfilter);
    $decennium = int($fodar/10) * 10;
    next if ($decenniefilter && $decennium != $decenniefilter);
    $aar{$fodar}++;
    $frekv{$namn} += $antal;
    $fodd{$fodar}{$namn} += $antal;
    $fodelseorter{$fodelseort}++;
    $landsdelar{$landsdel{$fodelseort}}++;
    $fodelseortaar{$fodar}{$namn}{$fodelseort} += $antal;
}
#==========================================================================
for ($i = 0; $i < $window; $i++) {$init[$i] = 0;}
#==========================================================================
# FILTRERA PÅ FREKVENS
$antalolikafiltreradenamn = 0;
for $namn (keys %frekv) {
    if ($frekv{$namn} < $threshold) {delete $frekv{$namn}; next;}
    $antalolikafiltreradenamn++;
    @{ $roller{$namn} } = @init;
}

#==========================================================================
# etablera topp per rullande $window
undef %yearbest;
for $y (sort keys %aar) {
    undef %best;
    for $namn (keys %frekv) {
	$this = $fodd{$y}{$namn}; 
	next unless $this;
#	$this = 0 unless $this;
	$prev = 0;
	for $yy (@{$roller{$namn}}) { $prev += $yy; }
	push @{$roller{$namn}}, $this;
	$hejdo = shift @{$roller{$namn}};
	$numera = $prev - $hejdo + $this;
#	$nyss = $prev/$sofar{$namn};
	$sofar{$namn} += $this;
	$tillvext = $numera/$sofar{$namn};
	$best{$namn}=$tillvext;
    }
    $ll = 0;
    print "$y\n"; for $nn ( (sort {$best{$b} <=> $best{$a}} keys %best)[0..$topplista] ) {print "\t $ll $nn $best{$nn} $sofar{$nn} $frekv{$nn}\n" if $nn;$ll++;}
    @{ $yearbest{$y} } = (sort {$best{$b} <=> $best{$a}} keys %best)[0..$topplista]
}
#==========================================================================
# för varje rullande $window-sekvens av år har nu %yearbest de mest ökande namnen
#
# tag dessa namn och tag BÖRJAN på sådan $windowsekvens och kolla VILKA ORTER först börjat med namnet
for $y (sort keys %aar) {
    for $nn (@{ $yearbest{$y} }) {
	for ($aar = $y - $window; $aar <= $y; $aar++) {
	    $poang = $y - $aar + 1;  
	    for $ort ( keys %{ $fodelseortaar{$aar}{$nn} } ) {
		$kreativitet{$y}{$ort} += $poang;
		$totkreativitet{$ort} += $poang;
	    }
	}
    }
    print "$y\n";
    for $kreativort ( (sort {$kreativitet{$y}{$b} <=> $kreativitet{$y}{$a} } keys %{ $kreativitet{$y} } )[0..$kreativ] ) {
	print "\t$kreativort\t$kreativitet{$y}{$kreativort}\t$totkreativitet{$kreativort}\n";
    }
}

exit();

#	    for $ort ( (sort {$fodelseortaar{$aar}{$nn}{$b} <=> $fodelseortaar{$aar}{$nn}{$a} } keys %{ $fodelseortaar{$aar}{$nn} })[0..$kreativ] ) {
