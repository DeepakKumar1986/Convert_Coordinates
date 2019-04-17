#!/usr/bin/perl

=begin comment
# I followed the Perl API installation instructions from "https://asia.ensembl.org/info/docs/api/api_installation.html" to install the Perl API

#The Perl version I have on my cluster is compatible for API installation:
[deepakk1@grieg-n22 ensembl]# perl --version
This is perl 5, version 16, subversion 3 (v5.16.3) built for x86_64-linux-thread-multi
(with 39 registered patches, see perl -V for more detail)

Copyright 1987-2012, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.

[deepakk1@grieg-n22 ensembl]# 

The .bashrc file looks like this after API installation:

export PERL_LOCAL_LIB_ROOT="$PERL_LOCAL_LIB_ROOT:/root/perl5";
export PERL_MB_OPT="--install_base /root/perl5";
export PERL_MM_OPT="INSTALL_BASE=/root/perl5";
export PERL5LIB="/root/perl5/lib/perl5:$PERL5LIB";
export PATH="/root/perl5/bin:$PATH";
PERL5LIB=${PERL5LIB}:/data/deepak-data/ensembl/ensembl/modules
PERL5LIB=${PERL5LIB}:/data/deepak-data/ensembl/ensembl-compara/modules
PERL5LIB=${PERL5LIB}:/data/deepak-data/ensembl/ensembl-variation/modules
PERL5LIB=${PERL5LIB}:/data/deepak-data/ensembl/ensembl-funcgen/modules
PERL5LIB=${PERL5LIB}:/data/deepak-data/ensembl/ensembl-io/modules
export PERL5LIB

USAGE: perl convert-coordinates.pl

OUTPUT:

#######################################
Slice: chromosome 10 25000-30000 (1)
Coordinate system: chromosome GRCh38

#######################################
Converted Coordinates in GRCh37:
10:1-846 -> 10:70936-71781:1
10:847-1247 -> 10:71784-72184:1
10:1250-2609 -> 10:72185-73544:1
10:2610-5001 -> 10:73546-75937:1
 
=end comment
=cut

########################################################################
use warnings;
use strict;
use Bio::EnsEMBL::Registry;  #import the Registry module to connect to Ensembl database
my $registry = 'Bio::EnsEMBL::Registry'; 

$registry->load_registry_from_db( ## connect to the database
    -host => 'ensembldb.ensembl.org',
    -user => 'anonymous'
);

my $slice_adaptor = $registry->get_adaptor( 'Human', 'Core', 'Slice' ); # get a slice adaptor from humar core database; where "Slice" presents a single continuous region of a genome
my $slice = $slice_adaptor->fetch_by_region( 'chromosome', '10', 25000, 30000 ); # fetch the region 25000 to 30000 for chromosome 10 by using the fetch_by_region method of slice_adaptor ### MODIFY ME ##
my $coord_sys1  = $slice->coord_system()->name(); # get the coordinate system: chromosome
my $seq_region1 = $slice->seq_region_name(); # get the region: 10
my $start1      = $slice->start(); # get the start of the region: 25000
my $end1        = $slice->end(); # get the end of the region: 30000
my $strand1     = $slice->strand(); # get the strand: 1
printf "#######################################\n";
print "Slice: $coord_sys1 $seq_region1 $start1-$end1 ($strand1)\n"; # print the details
my $cs_adaptor = $registry->get_adaptor( 'Human', 'Core', 'CoordSystem' ); # get a coordinate system adaptor from human core database
my $cs = $cs_adaptor->fetch_by_name('chromosome'); # fetch the chromosome coordinate system object from the database by using fetch_by_name method of cs_adaptor
printf "Coordinate system: %s %s\n\n", $cs->name(), $cs->version(); # print the coordinate system name and version
printf "#######################################\n";
printf "Converted Coordinates in GRCh37:\n"; 
my $slice2 = $slice->project( 'chromosome', 'GRCh37' ); # use the project method to project the slice onto GRCh37 coordinate system ## MODIFY ME ##
foreach my $segment (@$slice2) {       # loop over the slice array; a region in one assembly may necessarily not project to only one region on the other assembly
      my $chromosome = $segment->to_Slice(); # get the details of GRCh37 assembly in the variable chromosome using to_Slice method
      print $slice->seq_region_name(), ':', $segment->from_start(), '-',
            $segment->from_end(), ' -> ',
            $chromosome->seq_region_name(), ':', $chromosome->start(), '-',$chromosome->end(),
            ':', $chromosome->strand(), "\n"; # print the slice region and the range of bases from the original region "10:1-846 ->" that correspond to the new region in GRCh37 "10:70936-71781:1"
    }
