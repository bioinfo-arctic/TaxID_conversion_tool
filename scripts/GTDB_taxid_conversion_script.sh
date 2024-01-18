###########################################################
# This software was created on 16.01.2024                 #
# By:                                                     #
# Mads Reinhold Jensen and Daniel Kumazawa Morais.        #
#                                                         #
# It starts from a GTDB fasta file and uses it's taxonomy # 
# information in it's headers to generate a table of GTDB #
# accession and a TaxID value from NCBI.                  #
# This is usefull to rely on the NCBI's taxonomy strucure #
# backbone when processing data from databases other      #
# than NCBI.                                              #
#                                                         #
# For the conversion between taxa name and NCBI TaxID,    #
# we rely on the taxonkit software (v0.15.1 used here):   #
# https://github.com/shenwei356/taxonkit                  #
#                                                         #
###########################################################

grep '^>' ar53_ssu_reps_r207.fna | cut -d ' ' -f1 | sed 's/>//g' > ar53.accessions.txt
grep '^>' ar53_ssu_reps_r207.fna | cut -d '[' -f1 | cut -d ';' -f7 | sed 's/s__//g' > ar53.species.txt
grep '^>' ar53_ssu_reps_r207.fna | cut -d '[' -f1 | cut -d ';' -f6 | sed 's/g__//g' > ar53.genus.txt
grep '^>' ar53_ssu_reps_r207.fna | cut -d '[' -f1 | cut -d ';' -f5 | sed 's/f__//g' > ar53.family.txt
grep '^>' ar53_ssu_reps_r207.fna | cut -d '[' -f1 | cut -d ';' -f4 | sed 's/o__//g' > ar53.order.txt
grep '^>' ar53_ssu_reps_r207.fna | cut -d '[' -f1 | cut -d ';' -f3 | sed 's/c__//g' > ar53.class.txt
grep '^>' ar53_ssu_reps_r207.fna | cut -d '[' -f1 | cut -d ';' -f2 | sed 's/p__//g' > ar53.phylum.txt
grep '^>' ar53_ssu_reps_r207.fna | cut -d '[' -f1 | cut -d ';' -f1 | sed 's/.*d__//g' > ar53.domain.txt
 
taxonkit name2taxid ar53.species.txt > col1.txt
taxonkit name2taxid ar53.genus.txt > col2.txt
taxonkit name2taxid ar53.family.txt > col3.txt
taxonkit name2taxid ar53.order.txt > col4.txt
taxonkit name2taxid ar53.class.txt > col5.txt
taxonkit name2taxid ar53.phylum.txt > col6.txt
taxonkit name2taxid ar53.domain.txt > col7.txt
 
echo -e "Accession\tSpecies\tGenus\tFamily\tOrder\tClass\tPhylum\tDomain" > header.txt
paste ar53.accessions.txt col1.txt col2.txt col3.txt col4.txt col5.txt col6.txt col7.txt | cut -f1,3,5,7,9,11,13,15 > temp.txt
cat header.txt temp.txt > Taxids_conversion_table.txt
