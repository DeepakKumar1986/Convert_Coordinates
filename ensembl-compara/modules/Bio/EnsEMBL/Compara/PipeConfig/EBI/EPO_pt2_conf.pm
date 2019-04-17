=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
Copyright [2016-2019] EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

=head1 NAME

Bio::EnsEMBL::Compara::PipeConfig::EBI::EPO_pt2_conf

=head1 SYNOPSIS

    EBI-specific configuration of EPO_pt2 pipeline (anchor mapping). Options that
    may need to be checked include:

       'species_set_name'  - used in the naming of the database
	   'compara_anchor_db' - database containing the anchor sequences (entered in the anchor_sequence table)
       'mlss_id'       - mlss_id for the epo alignment (in master)

    #4. Run init_pipeline.pl script:
        Using command line arguments:
        init_pipeline.pl Bio::EnsEMBL::Compara::PipeConfig::EPO_pt2_conf.pm

    #5. Run the "beekeeper.pl ... -sync" and then " -loop" command suggested by init_pipeline.pl

    #6. Fix the code when it crashes

=head1 DESCRIPTION  

    This configuaration file gives defaults for mapping (using exonerate at the moment) anchors to a set of target genomes (dumped text files)

=head1 CONTACT

Please email comments or questions to the public Ensembl
developers list at <http://lists.ensembl.org/mailman/listinfo/dev>.

Questions may also be sent to the Ensembl help desk at
<http://www.ensembl.org/Help/Contact>.

=cut

package Bio::EnsEMBL::Compara::PipeConfig::EBI::EPO_pt2_conf;

use strict;
use warnings;

use Bio::EnsEMBL::Hive::Version 2.4;

use base ('Bio::EnsEMBL::Compara::PipeConfig::EPO_pt2_conf');

sub default_options {
    my ($self) = @_;

    return {
	%{$self->SUPER::default_options},

    'species_set_name' => 'sauropsids',
    #'rel_suffix' => 'b',

    # Where the pipeline lives
    'host' => 'mysql-ens-compara-prod-1.ebi.ac.uk',
    'port' => 4485,

    'division' => 'ensembl',
    'reg_conf' => $self->o('ensembl_cvs_root_dir').'/ensembl-compara/scripts/pipeline/production_reg_'.$self->o('division').'_conf.pl',


	# database containing the anchors for mapping
	'compara_anchor_db' => $self->o('species_set_name').'_epo_anchors',
    'reuse_db' => $self->o('species_set_name').'_epo_prev',

    'exonerate_exe'  => $self->check_exe_in_cellar('exonerate24/2.4.0/bin/exonerate'),
    'server_exe'     => $self->check_exe_in_cellar('exonerate24/2.4.0/bin/exonerate-server'),
    'fasta2esd_exe'  => $self->check_exe_in_cellar('exonerate24/2.4.0/bin/fasta2esd'),
    'esd2esi_exe'    => $self->check_exe_in_cellar('exonerate24/2.4.0/bin/esd2esi'),
    'samtools_exe'   => $self->check_exe_in_cellar('samtools/1.6/bin/samtools'),
    'ortheus_c_exe'  => $self->check_exe_in_cellar('ortheus/0.5.0_1/bin/ortheus_core'),

        # Capacities
        'low_capacity'                  => 10,
        'map_anchors_batch_size'        => 10,
        'map_anchors_capacity'          => 1000,
        'trim_anchor_align_batch_size'  => 20,
        'trim_anchor_align_capacity'    => 500,

	 # place to get the genome dumps
    'genome_dumps_dir' => '/hps/nobackup2/production/ensembl/compara_ensembl/genome_dumps/'.$self->o('division').'/',
    'master_db' => 'compara_master',
     };
}

1;
