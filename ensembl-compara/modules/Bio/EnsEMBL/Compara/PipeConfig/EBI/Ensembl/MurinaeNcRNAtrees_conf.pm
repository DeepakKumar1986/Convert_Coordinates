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



=head1 CONTACT

  Please email comments or questions to the public Ensembl
  developers list at <http://lists.ensembl.org/mailman/listinfo/dev>.

  Questions may also be sent to the Ensembl help desk at
  <http://www.ensembl.org/Help/Contact>.

=head1 NAME

Bio::EnsEMBL::Compara::PipeConfig::EBI::Ensembl::ncRNAtrees_conf

=head1 SYNOPSIS

    init_pipeline.pl Bio::EnsEMBL::Compara::PipeConfig::EBI::Ensembl::MurinaeNcRNAtrees_conf -password <your_password> -mlss_id <your_MLSS_id>

=head1 DESCRIPTION

This is the Ensembl PipeConfig for the ncRNAtree pipeline.

=head1 AUTHORSHIP

Ensembl Team. Individual contributions can be found in the GIT log.

=head1 APPENDIX

The rest of the documentation details each of the object methods.
Internal methods are usually preceded with an underscore (_)

=cut

package Bio::EnsEMBL::Compara::PipeConfig::EBI::Ensembl::MurinaeNcRNAtrees_conf;

use strict;
use warnings;
use base ('Bio::EnsEMBL::Compara::PipeConfig::EBI::Ensembl::ncRNAtrees_conf');

sub default_options {
    my ($self) = @_;

    return {
            %{$self->SUPER::default_options},

            # the production database itself (will be created)
            # it inherits most of the properties from EnsemblGeneric, we usually only need to redefine the host, but you may want to also redefine 'port'
            #'host' => 'mysql-ens-compara-prod-4',
            #'port' => 4401,

            # Must be given on the command line
            #'mlss_id'          => 40100,
            # Found automatically if the Core API is in PERL5LIB
            #'ensembl_release'          => '76',
            'rel_suffix'       => '',

            'division'          => 'murinae',
            'reg_conf'  => $self->o('ensembl_cvs_root_dir').'/ensembl-compara/scripts/pipeline/production_reg_vertebrates_conf.pl',
            'dbID_range_index'  => 19,
            'label_prefix'      => 'mur_',

            'skip_epo'          => 1,

            # Where to draw the orthologues from
            'ref_ortholog_db'   => 'compara_nctrees',

            'pipeline_name'    => 'murinae_nctrees_'.$self->o('rel_with_suffix'),

            'clustering_mode'   => 'ortholog',

            # CAFE parameters
            'initialise_cafe_pipeline'  => 0,

            # For the homology_id_mapping
            'prev_rel_db'  => 'compara_prev',
    };
}   

sub pipeline_wide_parameters {  # these parameter values are visible to all analyses, can be overridden by parameters{} and input_id{}
    my ($self) = @_;
    return {
        %{$self->SUPER::pipeline_wide_parameters},          # here we inherit anything from the base class

        'ref_ortholog_db'   => $self->o('ref_ortholog_db'),
    }
}

sub tweak_analyses {
    my $self = shift;
    my $analyses_by_name = shift;

    $analyses_by_name->{'insert_member_projections'}->{'-parameters'}->{'source_species_names'} = [ 'mus_musculus' ];
    $analyses_by_name->{'make_species_tree'}->{'-parameters'}->{'allow_subtaxa'} = 1;  # We have sub-species
    $analyses_by_name->{'make_species_tree'}->{'-parameters'}->{'multifurcation_deletes_all_subnodes'} = [ 10088 ];    # All the species under the "Mus" genus are flattened, i.e. it's rat vs a rake of mice
    $analyses_by_name->{'orthotree_himem'}->{'-rc_name'} = '2Gb_job';
}


1;

