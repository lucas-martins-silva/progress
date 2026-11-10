/********************************************************************************/
/** Autor : Datasul S.A.                                                       **/
/**                                                                            **/
/** Objetivo  : Definicao da tt-param                                          **/
/**                                                                            **/
/********************************************************************************/

DEFINE TEMP-TABLE tt-param
    FIELD cod-estabel-ini  LIKE nota-fiscal.cod-estabel
    FIELD cod-estabel-fim  LIKE nota-fiscal.cod-estabel
    FIELD serie-ini        LIKE nota-fiscal.serie
    FIELD serie-fim        LIKE nota-fiscal.serie
    FIELD nr-nota-fis-ini  LIKE nota-fiscal.nr-nota-fis
    FIELD nr-nota-fis-fim  LIKE nota-fiscal.nr-nota-fis
    FIELD dt-emis-nota-ini LIKE nota-fiscal.dt-emis-nota
    FIELD dt-emis-nota-fim LIKE nota-fiscal.dt-emis-nota
    FIELD it-codigo-ini    LIKE it-nota-fisc.it-codigo 
    FIELD it-codigo-fim    LIKE it-nota-fisc.it-codigo 
    FIELD it-prod-ini      LIKE it-nota-fisc.it-codigo 
    FIELD it-prod-fim      LIKE it-nota-fisc.it-codigo 
    FIELD no-ab-reppri-ini LIKE nota-fiscal.no-ab-reppri 
    FIELD no-ab-reppri-fim LIKE nota-fiscal.no-ab-reppri 
    FIELD classificacao    AS INTEGER     
    FIELD imp-resumo       AS LOGICAL
    FIELD destino          AS INTEGER     
    FIELD arquivo          AS CHAR
    FIELD usuario          AS CHAR
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER.

/* fim da include */
