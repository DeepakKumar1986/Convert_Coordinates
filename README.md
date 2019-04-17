			#MAP CHROMOSOME REGIONS FROM ONE ASSEMBLY(GRCh38) TO ANOTHER(GRCh37)#

#Description
This perl script converts coordinates of a specific region on a chromosome from GRCh38 assembly to GRCh37 assembly using Ensembl Perl API. 
Ensembl API retrieves queried data from a MySQL relational databas with the help of various objects(such as, frequently used; Gene, Slice, and Exon objects stored in the database through object adaptors), methods(such as; get_all(), fetch_all()), and class(such as, Slice; to get information on this class one can do "perldoc Bio::EnsEMBL::Slice") parameters of the API. Moreover, sequences in Ensembl database are associated with coordinate system which varies from species to species. For example, Homo Sapiens database has the following coordinate systems: supercontig, chromosome, clone, contig. Relationship between these coordinates are stored in the database and the means is provided by the API to convert these coordinates.

#Installation
The perl API installation instructions can be found here:

https://asia.ensembl.org/info/docs/api/api_installation.html

#Execution
To execute the script, simply run:

$ perl convert-coordinates.pl

#Usage

To convert coordinates of your region of interest on a chromosome from one assembly to another, modify this section of the script:

my $slice = $slice_adaptor->fetch_by_region( 'chromosome', '10', 25000, 30000 );

where, "chromosome" is the coordinate system, '10' is the chromosome number, and 25000 and 30000 are the start and the end of the region.

To convert the coordinates of your region of interest to your assembly of interest; modify this section of the script:

my $slice2 = $slice->project( 'chromosome', 'GRCh37' );

where, "project" is the method used to project the region of interest onto another coordinate system version (in this case GRCh37). You can use onther coordinate system version instead of "GRCh37" to project the region of interest to.

#OUTPUT

#######################################
Slice: chromosome 10 25000-30000 (1)
Coordinate system: chromosome GRCh38

#######################################
Conveted Coordinates in GRCh37:
10:1-846 -> 10:70936-71781:1
10:847-1247 -> 10:71784-72184:1
10:1250-2609 -> 10:72185-73544:1
10:2610-5001 -> 10:73546-75937:1

Output from the script is the list of base range from the assembly you are converting the coordinates from, that correspond to the bases of the assembly they are converted to. For example,  bases 1 to 846 on chromosome 10 in GRCh38 correspond to bases 70936 to 71781 on chromosome 10 in GRCh37.

#Other Methods
There are other methods available to do the conversion of coordinates from one assembly to another:

A) LiftOver: can be used for the mass conversion of coordinates from one assembly to another
The tool's binary executable file can be downloaded from:
http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/

Data files required as input to the liftOver utility can be downloaded from:
http://hgdownload.cse.ucsc.edu/goldenpath/hg38/liftOver/
http://hgdownload.cse.ucsc.edu/goldenpath/hg19/liftOver/

#USAGE
liftOver input.bed hg38ToHg19.over.chain.gz output.bed

Where, "input.bed" is the input bed file in the format "chr <start of chromosome region> <end of chromosome region>", "hg18ToHg19.over.chain.gz" is the liftover data file to convert hg18 coordinates to hg19, and "output.bed" is the output bed file.

B) Ensembl REST API: REpresentational State Transfer API is a lanuguage agnostic method to access remote data on Ensembl database.
https://rest.ensembl.org/documentation/info/assembly_map

#USAGE
wget -q --header='Content-type:application/json' 'https://rest.ensembl.org/map/human/GRCh38/10:25000..30000:1/GRCh37?'  -O -

C) NCBI Genome Remapping Service: is a tool to project annotation data from one coordinate system to another. It has web service and API.

Web service: https://www.ncbi.nlm.nih.gov/genome/tools/remap
API: https://www.ncbi.nlm.nih.gov/genome/tools/remap/docs/api

