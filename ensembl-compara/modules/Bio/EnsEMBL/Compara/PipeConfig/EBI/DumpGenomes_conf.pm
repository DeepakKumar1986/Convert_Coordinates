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

Bio::EnsEMBL::Compara::PipeConfig::EBI::DumpGenomes_conf

=head1 SYNOPSIS

    # Typical invocation
    init_pipeline.pl Bio::EnsEMBL::Compara::PipeConfig::EBI::DumpGenomes_conf $(mysql-ens-compara-prod-2-ensadmin details hive)

    # Different registry file and species-set
    init_pipeline.pl Bio::EnsEMBL::Compara::PipeConfig::EBI::DumpGenomes_conf -reg_conf path/to/reg_conf -collection_name '' -mlss_id 1234

=head1 DESCRIPTION

EBI version of DumpGenomes_conf, a pipeline to dump the genomic sequences
of a given species-set.

=head1 CONTACT

Please email comments or questions to the public Ensembl
developers list at <http://lists.ensembl.org/mailman/listinfo/dev>.

Questions may also be sent to the Ensembl help desk at
<http://www.ensembl.org/Help/Contact>.

=cut

package Bio::EnsEMBL::Compara::PipeConfig::EBI::DumpGenomes_conf;

use strict;
use warnings;

use base ('Bio::EnsEMBL::Compara::PipeConfig::DumpGenomes_conf');


sub default_options {
    my ($self) = @_;

    return {
        %{$self->SUPER::default_options},

        # Which species-set to dump
        'species_set_id'    => undef,
        'species_set_name'  => undef,
        'collection_name'   => $self->o('division'),
        'mlss_id'           => undef,
        'all_current'       => undef,

        # the production database itself (will be created)
        # it inherits most of the properties from HiveGeneric, we usually only need to redefine the host, but you may want to also redefine 'port'
        'host'              => 'mysql-ens-compara-prod-2.ebi.ac.uk',
        'port'              => 4522,

        # Where to put the genome dumps
        'genome_dumps_dir'  => '/hps/nobackup2/production/ensembl/compara_ensembl/genome_dumps/'.($self->o('division')).'/',
        # Which user has access to this directory
        'shared_user'       => 'compara_ensembl',

        # the master database to get the genome_dbs
        'master_db'         => 'compara_master',
        # the pipeline won't redump genomes unless their size is different, or listed here
        'force_redump'      => [],

        # the registry file to indicate how to get the core databases
        'reg_conf'          => $self->o('ensembl_cvs_root_dir').'/ensembl-compara/scripts/pipeline/production_reg_'.$self->o('division').'_conf.pl',

        # Executables
        'fasta2esd_exe'     => $self->check_exe_in_cellar('exonerate24/2.4.0/bin/fasta2esd'),
        'esd2esi_exe'       => $self->check_exe_in_cellar('exonerate24/2.4.0/bin/esd2esi'),
        'samtools_exe'      => $self->check_exe_in_cellar('samtools/1.6/bin/samtools'),

        # Capacities
        'dump_capacity'     => 10,
    };
}


sub resource_classes {
    my ($self) = @_;
    my $reg_requirement = '--reg_conf '.$self->o('reg_conf');
    return {
        %{$self->SUPER::resource_classes},  # inherit 'default' from the parent class

         '100Mb_job'    => {'LSF' => ['-C0 -M100  -R"select[mem>100]  rusage[mem=100]"', $reg_requirement], 'LOCAL' => ['', $reg_requirement] },
         '250Mb_job'    => {'LSF' => ['-C0 -M250  -R"select[mem>250]  rusage[mem=250]"', $reg_requirement], 'LOCAL' => ['', $reg_requirement] },
         '500Mb_job'    => {'LSF' => ['-C0 -M500  -R"select[mem>500]  rusage[mem=500]"', $reg_requirement], 'LOCAL' => ['', $reg_requirement] },
         '1Gb_job'      => {'LSF' => ['-C0 -M1000 -R"select[mem>1000] rusage[mem=1000]"', $reg_requirement], 'LOCAL' => ['', $reg_requirement] },
         '2Gb_job'      => {'LSF' => ['-C0 -M2000 -R"select[mem>2000] rusage[mem=2000]"', $reg_requirement], 'LOCAL' => ['', $reg_requirement] },
         '4Gb_job'      => {'LSF' => ['-C0 -M4000 -R"select[mem>4000] rusage[mem=4000]"', $reg_requirement], 'LOCAL' => ['', $reg_requirement] },
         '8Gb_job'      => {'LSF' => ['-C0 -M8000 -R"select[mem>8000] rusage[mem=8000]"', $reg_requirement], 'LOCAL' => ['', $reg_requirement] },
    };
}


1;
