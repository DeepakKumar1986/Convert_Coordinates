						Ensembl Perl API vs LiftOver


-> LiftOver binary executable can be used for multiple coordinate conversions of chromosome regions from one assembly to another. Such multiple conversions in Perl API could lead to heavy memory usage; such as, when using "foreach" loop. Ensembl API uses lazy loading of the data that makes up the object for faster code processing by minimizing the number of queries to the database and by only filling in the data in the object that the program asked for. Consequently, looping over large number of these objects increases the memory usage. Whereas, in LiftOver the query execution is processed fast and easy becasue of the "over.chain"(such as, hg38ToHg19.over.chain.gz) data files present locally when running the liftover executable.

-> Ensembl Perl API produces more comprehensive and informative output compared to liftover; for example, output of chromosome 10 from region 25000 to 30000 coordinates from GRCh38 version converted to GRCh37 version gives this output:
10:1-846 -> 10:70936-71781:1
10:847-1247 -> 10:71784-72184:1
10:1250-2609 -> 10:72185-73544:1
10:2610-5001 -> 10:73546-75937:1

Whereas, liftOver conversion gives:

chr10   70936   75937

As we see, Ensembli Perl API not only gives the converted coordinates of the region of chromosome 10 in GRCh37 but, also gives the number of bases in GRCh38 that mapped to the corressponding specific number of bases in GRCh37. For instance, in the above example, 1 to 846 bases of chromosome 10 from region 25000 to 30000 in GRCh38 corresspond to region 70936 to 71781 of chromosome 10 in GRCh37.

-> Ensembl Perl API retrieves data from a  well-structured MySQL relational database with the help of various object, method and class features of the program. The Perl API has organized approach to extract the needful information from the database; such as, to get a slice covering region 10000 to 20000 of chromosome 10 in GRCh38 can be obtained by:

$slice_adaptor->fetch_by_region( 'chromosome', '10', 10000, 20000 );

Where, slice_adaptor is the object and fetch_by_region is the method of the object calling the necessary information from the database. Although, liftOver has comprehensive selection of assemblies for different organisms, such organized retrieval approach of specific data is not possible in liftOver.

-> Ensembl Perl API gives detailed information on various features of genes, transcripts, and exons; such as, one can retrieve information on repeats, alignments, translated proteins, markers, and also cross-reference the data with external references. These features are not present in liftOver. Morover, unlike liftover, Ensembl Perl API has parameters to transfer coordinates to not only other coordinate systems but also to another slice of a region in the same coordinate system.

-> In the case of liftover, if a SNP in a contig only exists in the older assembly, liftover cannot convert the coorodinates to new assembly. In addition, liftover heavily relies on dbSNP database and compatibility between NCBI dbSNP and UCSC bdSNP release needs to be maintained to get same results by liftover, since there could be issues where liftover gives different result for a SNP compared to NCBI dbSNP. 


