#!/usr/bin/perl
#convertendo arquivo fasta numa hash

print "Digite o nome do arquivo fasta a ser convertido numa tabela hash:";
$arquivo_fasta = <STDIN>;
chomp $arquivo_fasta;

# Testando a existência do arquivo
unless (-e $arquivo_fasta) {
       print "Este arquivo não existe: $!. \n Favor digitar o nome do arquivo corretamente! \n";
       exit;
} 

#Criando um filehand (apelido) para o arquivo.
open (IN , "$arquivo_fasta"); 

while ($line = <IN>) {
       chomp $line;
       
       if ($line =~ m/>/) {
       $line =~ s/>//;
       $key = $line ;

       }
       else {
       $fasta{$key} .= $line;
       }
}

# A hash %fasta acabou de ser criada

close (IN);
while (($key , $valor) = each(%fasta)) {	# a função each, dentro do laço while, devolve, até existerem, um par chave e valor correspondente da tabela hash. Quando não existirem mais estes paresm o laçõ se torna falso e o programa e fechado.

	$tam = length ($valor);
	if ($tam > 500) {
	++$count;
	print "$key\n$valor\n";
	
	}
	
}
print "\nO número de sequências é: $count\n\n";
