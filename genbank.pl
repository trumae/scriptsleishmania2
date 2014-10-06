#!/usr/bin/perl -W
use Data::Dumper;


# Converte os dados em origin em uma string unica e continua
sub origin2string {
    my ($entry) = @_;
    my $result;  

    $entry =~ s/\n//g;
    if ($entry =~ /ORIGIN(.*)/) {
      $result = $1;
    }
    $result =~ s/\s//g; 
    $result =~ s/[^NACGT]//g; 
    return $result; 
}


#converte uma entrada genbak em uma entrada fasta
sub convert_entry {
     my ($entry) = @_;
     my $result = ">";
     if (length($entry) == 0) {
        return;
     }

     if($entry =~ m/\/locus_tag="(LBRM_\d*_\d*)"/){
        $result.= $1;
     }

     if($entry =~ m/\/product="([\sa-zA-Z\-0-9]*)"/){
        $result.= " " . $1 . "\n";
     }

     my $primeiro = 1;
     my $inicio;
     my $fim;
     my $proxinic = -1;
     while ($entry =~ /CDS\s*<*(\d+)\.\.>*(\d+)/g) {
        if($primeiro) {
           $inicio = $1;
           $fim = $2; 
           $primeiro = 0;
        } else {
           $proxinic = $1;
           last;
        }
     }
     $inicio = 1;
     if (($fim + 1000) > $proxinic) {
        $fim = $proxinic;
     } else {
        $fim = $fim + 1000;
     }

     $origin = origin2string($entry);
     my $selected = substr $origin, $inicio -1, $fim -1;
     $result .= $selected;
     $result .= "\n";

     return $result;
}

$arquivo_fasta = $ARGV[0];

# Testando a existência do arquivo
unless (-e $arquivo_fasta) {
       print "Este arquivo não existe: $!. \n Favor digitar o nome do arquivo corretamente! \n";
       exit;
} 


#Criando um filehand (apelido) para o arquivo.
open (IN , "<$arquivo_fasta"); 
my $conteudo = "";
while(<IN>){
   $conteudo .= $_;
}
close (IN);


my @registros = split(/LOCUS/, $conteudo);

#print Dumper(@registros); 

my $count = 0;
foreach my $reg (@registros) {
#    if ($count > 642 && $count < 644) {
#       print STDERR "$reg\n";
#    }
    print convert_entry($reg);
#    print STDERR "$count\n";
    $count ++;
}


