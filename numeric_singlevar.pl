#!/usr/bin/perl -w
my $var;
my %xi;
my @ni;
my $totalni = 0;
my $sumatorio = 0;
my $tipo = 0;
#0 = media normal ; 1 = rango


#### PRINCIPIO BLOQUE MEDIA ####
sub media{

	# Check datos
	foreach $key ( sort keys %xi) {
		if ( $key =~ /[0-9]+-[0-9]+/){
			$tipon=1;
		} else {
			$tipon=0;
		}
		if($tipo == 1 and $tipon == 0){
			die "BAD tipos";			
		}
		$tipo = $tipon;
	}


	if ( $tipo == 0 ){
		&media_normal;
	} else {
		&media_rangos;
	}

	$media = $sumatorio / $totalni ;
	printf("Media: %s\n", $media);

}

sub media_normal{
	# Media normal
	foreach $key ( sort keys %xi ){
	#key es xi
	#value es ni
		$value = $xi{$key};
	#	printf("%s : %s \n", $key , $value);
		$sumatorio = $sumatorio + ( $value * $key );
	}

}

sub media_rangos{
	# Media rangos
	foreach $key ( sort keys %xi ){
	#key es xi
	#value es ni
	#marca de clase = keymax-keymin/2
		$value = $xi{$key};
		my @marca = split("-", $key);
		$sumatorio = $sumatorio + ( ( $marca[1] + $marca[0] )/2 )* $value ;

	}
}
##### FIN BLOQUE MEDIA #####
##### BLOQUE MEDIANA #####
sub mediana{
        # Check datos
        foreach $key ( sort  keys %xi) {
                if ( $key =~ /[0-9]+-[0-9]+/){
                        $tipon=1;
                } else {
                        $tipon=0;
                }
                if($tipo == 1 and $tipon == 0){
                        die "BAD tipos";
                }
                $tipo = $tipon;
        }


        if ( $tipo == 0 ){
                &mediana_normal;
        } else {
                &mediana_rangos;
        }
}

sub mediana_normal{
	my $mitad = 0;
	my $mitadx = 0;
	my $observaciones = keys(%xi);	
	my $mode = 0;
	my $vmediana = 0;
	my @arrayxi ;
	
	if ( $totalni == $observaciones ) {  
		if ($observaciones %2 == 1) {
		#impar
			$mode = 1;	
			$mitad = $observaciones / 2 + 0.5;
		} else {
		#par
			$mode = 2;
			$mitad = $observaciones / 2 - 0.5;
		}
		printf("observaciones = totalni, mitad = %s \n", $mitad);
		foreach $key ( sort keys %xi ){
			push(@arrayxi,$key);	
		}
		my @sort_arrayxi = sort @arrayxi;
		if($mode == 1) { printf("Mediana: %s \n",$sort_arrayxi[$mitad]) };
		if($mode == 2) { printf("Mediana: %s \n", ($sort_arrayxi[$mitad] + $sort_arrayxi[$mitad + 1]) / 2 ) };
	} else {
		$mitad = $totalni / 2;
		foreach $key ( sort { $a <=> $b } keys %xi ){
			printf("Key: %s , Value: %s \n ", $key , $xi{$key});
			$mitadx = $mitadx + $xi{$key} ;
			if($mitadx >= $mitad){ printf("Mediana: %s \n ", $mitadx) ; exit} ;
		}
	}
}

sub mediana_rangos{
	my $mitad = 0;
	my $mitadx = 0;
	$mitad = $totalni / 2;
	printf("%s %s\n", $totalni, $mitad);	
	for $key ( sort { $a <=> $b } keys %xi ){
                printf("Key: %s , Value: %s , mitadx: %s\n ", $key , $xi{$key}, $mitadx);
#		$mitadx = $mitadx + $xi{$key};
#		if($mitadx >= $mitad){ printf("Mediana: %s \n ", $mitadx) ; exit} ;	
	}

}


#MAIN
if ($ARGV[0] !~ /media|mediana/){
	printf("Usage: [media|mediana] filename\n");
	exit;
}else{
	if ( ! $ARGV[1]){
		die "specify a valid filename";
	} else {
		open FILE, "<$ARGV[1]" or die $!;
	}
		
}

while (<FILE>){
	my @field = split(",", $_) ;
	$xi{$field[0]}=$field[1];
	$totalni = $totalni + $field[1];
	printf("Entrada: %s : %s", $field[0] , $field[1]);
}

if ( $ARGV[0] eq "media") { &media };
if ( $ARGV[0] eq "mediana") { &mediana };
