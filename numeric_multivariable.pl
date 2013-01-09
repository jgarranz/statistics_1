#!/usr/bin/perl 
use warnings;
use diagnostics;

my $media_x = 0;
my $media_y = 0;
my $covxy = 0;
my %valores_x;
my $length_x = 0;
my %valores_y;
my $length_y = 0;
my $s2x = 0;
my $s2y = 0;
my $regre_a = 0;
my $regre_b = 0;
my $var_residual = 0;
my $valor_coeficiente = 0;


sub media{

foreach $key (keys %valores_x){
	$media_x = $media_x + $valores_x{$key};
}
foreach $key (keys %valores_y){
	$media_y = $media_y + $valores_y{$key};
}

$media_x = $media_x / $length_x;
$media_y = $media_y / $length_y;

printf("Media X: %s\n", $media_x);
printf("Media Y: %s\n", $media_y);
}

sub covarianza{
	foreach $key (keys %valores_x){
		$covxy = $covxy + (($valores_x{$key} - $media_x) * ($valores_y{$key} - $media_y) );
	}
	$covxy = $covxy / $length_x ;
	printf("Covarianza: %s \n", $covxy);
}

sub calcular_sx{
	foreach $key (keys %valores_x){
		$s2x = $s2x + ($valores_x{$key} - $media_x)**2;
		$s2y = $s2y + ($valores_y{$key} - $media_y)**2;
	}
	$s2x = $s2x / $length_x ;
	$s2y = $s2y / $length_y ;
}

sub regresion{
	&calcular_sx ;
	$regre_b = $covxy / $s2x ;
	$regre_a = $media_y - ( $regre_b * $media_x) ;
	printf("Recta regresion Y = %s + %s X \n", $regre_a , $regre_b);
}

sub varianza_residual{
	foreach $key (keys %valores_x){
		$var_residual = $var_residual + (($regre_a + $regre_b * $valores_x{$key}) - $valores_y{$key})**2;
	}
	$var_residual = $var_residual / $length_x ;
	printf("Varianza residual: %s\n", $var_residual);
}

sub coeficiente{
	$valor_coeficiente = $covxy**2 / ( $s2x * $s2y);
	printf("Coeficiente: %s \n", $valor_coeficiente);
}

#MAIN
if ( ! $ARGV[0] ){
		die "specify a valid filename";
} else {
		open FILE, "<$ARGV[0]" or die $!;
}
		


while (<FILE>){
	my @field = split(",", $_) ;
	$valores_x{$field[0]}=$field[1];
	$valores_y{$field[0]}=$field[2];
	printf("Entrada: %s | x : %s | y : %s", $field[0] , $field[1] , $field[2]);
}
$length_x = scalar(keys %valores_x);
$length_y = scalar(keys %valores_y);

&media ;
&covarianza ;
&regresion ;
&coeficiente ;
&varianza_residual;

