while (<>) {
   next if /Helsingfors/;
    @h = split;
    $landsdel = "Svealand";
    for ($i = 0; $i < 5; $i++) {
	$landsdel = "Norrland" if $h[$i] eq "Umeå";
#	$landsdel = "Finland" if $h[$i] eq "Helsingfors";
	$landsdel = "Götaland" if $h[$i] eq "Göteborg"; 
	$landsdel = "Skåne" if $h[$i] eq "Malmö";
    }
    print "$h[0]\t$landsdel\n";
}
