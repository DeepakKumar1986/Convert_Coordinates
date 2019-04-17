-- Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
-- Copyright [2016-2019] EMBL-European Bioinformatics Institute
-- 
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- 
--      http://www.apache.org/licenses/LICENSE-2.0
-- 
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.


DROP TABLE protein_function_predictions;

CREATE TABLE protein_function_predictions (
    translation_md5_id int(11) unsigned NOT NULL,
    analysis_attrib_id int(11) unsigned NOT NULL,
    prediction_matrix mediumblob,
    
    PRIMARY KEY (translation_md5_id, analysis_attrib_id)
);

CREATE TABLE translation_md5 (
    translation_md5_id int(11) NOT NULL AUTO_INCREMENT,
    translation_md5 char(32) NOT NULL,

    PRIMARY KEY (translation_md5_id),
    UNIQUE KEY md5_idx (translation_md5)
);

# patch identifier
INSERT INTO meta (species_id, meta_key, meta_value) VALUES (NULL,'patch', 'patch_66_67_b.sql|update protein function predictions table schema');