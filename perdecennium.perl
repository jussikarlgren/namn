# ta en fil med sdev och plocka ut per topp per decennium
# Clark	104	0.461538461538462	10.4	7.93019545786861	 5 21 12 9 10 11 8 11 17 
while (<>) {
    #    ($namn,$f,$a,$b,$sdev,$d2,$d3,$d4,$d5,$d6,$d7,$d8,$d9,$d0,$d10) = split;
    @items = split;
    @array = @items[5..14];
    $max = 0;
    $index = 1920;
    $maxindex = 1920;
    $sdev = int($items[4]*10)/10;
    for $d (@array) {
	if ($d > $max) {$max = $d; $maxindex = $index;}
	$index += 10;
    }
    print "$items[0]\t$sdev\t$maxindex\t$max\n";
}


