//
//  description: Antlr4 grammar for Archetype Definition Language (ADL2)
//  author:      Thomas Beale <thomas.beale@openehr.org>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2015 openEHR Foundation
//  license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

grammar adl;
import cadl, odin;

//
//  ============== Parser rules ==============
//

adl: ( archetype | template | template_overlay | operational_template ) EOF ;

archetype: 
    SYM_ARCHETYPE meta_data?
    ARCHETYPE_HRID
    specialization_section?
    language_section
    description_section
    definition_section
    rules_section?
    terminology_section
    annotations_section?
    ;

template: 
    SYM_TEMPLATE meta_data? 
    ARCHETYPE_HRID
    specialization_section
    language_section
    description_section
    definition_section
    rules_section?
    terminology_section
    annotations_section?
    (HLINE template_overlay)*
    ;

template_overlay: 
    SYM_TEMPLATE_OVERLAY 
    ARCHETYPE_HRID
    specialization_section
    definition_section
    terminology_section
    ;

operational_template: 
    SYM_OPERATIONAL_TEMPLATE meta_data? 
    ARCHETYPE_HRID
    language_section
    description_section
    definition_section
    rules_section?
    terminology_section
    annotations_section?
    component_terminologies_section?
    ;

specialization_section : SYM_SPECIALIZE ARCHETYPE_REF ;
language_section       : SYM_LANGUAGE odin_text ;
description_section    : SYM_DESCRIPTION odin_text ;
definition_section     : SYM_DEFINITION c_complex_object ;
rules_section          : SYM_RULES assertion+ ;
terminology_section    : SYM_TERMINOLOGY odin_text ;
annotations_section    : SYM_ANNOTATIONS odin_text ;
component_terminologies_section: SYM_COMPONENT_TERMINOLOGIES odin_text ;

meta_data: '(' meta_data_item  (';' meta_data_item )* ')' ;

meta_data_item:
      SYM_ADL_VERSION '=' VERSION_ID
    | SYM_UID '=' ( DOTTED_NUMERIC | GUID )  // TODO: this won't match all Oids properly
    | SYM_BUILD_UID '=' ( DOTTED_NUMERIC | GUID )
    | SYM_RM_RELEASE '=' VERSION_ID
    | SYM_IS_CONTROLLED
    | SYM_IS_GENERATED
    | PROPER_ID  ( '=' ( PROPER_ID | meta_data_value ))?
    ;

meta_data_value:
      primitive_value
    | GUID
    | VERSION_ID
    ;
