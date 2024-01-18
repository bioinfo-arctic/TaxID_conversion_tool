###########################################################
# GTDB_taxid_conversion_script.sh                         #
# Usage: GTDB_taxid_conversion_script.sh your_fasta.file  #
#                                                         #
# This software was created on 16.01.2024                 #
# By: Mads Reinholdt Jensen and Daniel Kumazawa Morais.   #
# Contact: daniel.morais@uit.no                           #
#                                                         #
# It starts from a GTDB fasta file and uses it's taxonomy # 
# information in it's headers to generate a table of GTDB #
# accession and a TaxID value from NCBI.                  #
#                                                         #
# This is usefull to rely on the NCBI's taxonomy strucure #
# backbone when processing data from databases other      #
# than NCBI.                                              #
#                                                         #
# For the conversion between taxa name and NCBI TaxID,    #
# we rely on the taxonkit software (v0.15.1 used here):   #
# https://github.com/shenwei356/taxonkit                  #
#                                                         #
###########################################################

# For this script to work the starting fasta file must have the header with a structure similar to the line below:
# >GB_GCA_000016605.1 d__Archaea;p__Thermoproteota;c__Thermoproteia;o__Sulfolobales;f__Sulfolobaceae;g__Metallosphaera;s__Metallosphaera sedula [locus_tag=CP000682.1] [location=1705272..1706766] [ssu_len=1494] [contig_len=2191517]
# You also need taxonkit installed at your $HOME directory. For installation and usage of taxonkit, please see at:
# https://github.com/shenwei356/taxonkit

# This command will create a taxonomy table
grep '^>' $1 | sed 's/>//; s/;/\t/g' | awk 'BEGIN{print "Accession\tSpecies\tGenus\tFamily\tOrder\tClass\tPhylum\tDomain"}{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7}' > taxonomy_table_names.txt

# This loop will generate 7 intermatiade files called col_[2-8].txt
# These files will be the TaxID for each of the taxonomical levels in the headers of your fasta file:  (s__, g__, f__, c__, o__, p__, d__) and they should have the same number of rows as the number of headers of your fasta file.
for i in {2..8}; do cut -f ${i} taxonomy_table_names.txt | tail -n +2 | sed 's/[a-z]__//' | ./taxonkit name2taxid --data-dir ../taxdump/ | cut -f 2 > col_${i}.txt ; done

# This command will generaet a table of TaxIDs for each taxonomic level it could find using the taxonkit software. Your table should contain empty spaces, specially for the species column (s__), but shouldn't have gaps at the domain column (d__).
cat <(head -n 1 taxonomy_table_names.txt) <(paste <(tail -n +2 taxonomy_table_names.txt | cut -f 1) col_* ) > Taxids_conversion_table.txt

# This command generates a table connecting the lowest taxonomic TaxID found with taxonkit and the GTDB Accession.
awk '{print $1"\t"$2}' Taxids_conversion_table.txt > Final_GTDB_and_TaxID_table.txt
