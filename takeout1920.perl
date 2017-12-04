while (<>) {
($namn,$tilltal,$kon,$fodar,$fodelseforsamling,$fodelseort,$bostadsort,$antal) = split "\t";
next if $fodar < 1920;
print;
}

    
