&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : imp/im0410a.i1
    Description : Necess rio para o folder Impostos do IM0410a.w

    Author(s)   : TOTVS S.A.
    Created     : 19.08.2011
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{cxbo/bocx225e.i tt-ordens-desemb}

/*DEFINE TEMP-TABLE tt-bo-erro no-undo
                  field i-sequen as int
                  field cd-erro  as int
                  field mensagem as char format "x(255)"
                  field parametros as char format "x(255)" init ""
                  field errortype as char format "x(20)"
                  field errorhelp as char format "x(20)"
                  field errorsubtype as character.*/

def var vpeso-bruto-i1  AS DECIMAL FORMAT '>>>>,>>9.9999999999'  no-undo. 
def var vpeso-liquido-i1 AS DECIMAL FORMAT '>>>>,>>9.9999999999' no-undo.  
def var vcubagem           like ordens-embarque.val-cub-tot no-undo.
def var vtrib-ii-i1        as integer no-undo.
def var vtrib-ipi-i1       as integer no-undo.
def var vtrib-icms-i1      as integer no-undo.
def var vtrib-pis-i1       as integer no-undo.
def var vtrib-cofins-i1    as integer no-undo.
def var vde-aliq-ii-i1     as decimal format ">>>9.9999" no-undo.
def var vde-aliq-ipi-i1    as decimal format ">>>9.99" no-undo.
def var vde-aliq-icms-i1   as decimal format ">>>9.99" no-undo.
def var vde-aliq-pis-i1    as decimal format ">>9.9999" no-undo.
def var vde-aliq-cofins-i1 as decimal format ">>9.9999" no-undo.

def var vsuspensoII     AS LOGICAL NO-UNDO.
def var vsuspensoIPI    AS LOGICAL NO-UNDO.
def var vsuspensoICMS   AS LOGICAL NO-UNDO.
def var vsuspensoPIS    AS LOGICAL NO-UNDO.
def var vsuspensoCOFINS AS LOGICAL NO-UNDO.

def var vtrib-cbs                 AS INTEGER                  NO-UNDO.
def var vtrib-ibs-uf              AS INTEGER                  NO-UNDO.
def var vtrib-ibs-mun             AS INTEGER                  NO-UNDO.
def var vtrib-is                  AS INTEGER                  NO-UNDO.
def var vde-aliq-cbs              as decimal format ">>>9.99" no-undo.
def var vde-aliq-ibs-uf           as decimal format ">>>9.99" no-undo.
def var vde-aliq-ibs-mun          as decimal format ">>>9.99" no-undo.
def var vde-aliq-red-cbs          as decimal format ">>>9.99" no-undo.
def var vde-aliq-red-ibs-uf       as decimal format ">>>9.99" no-undo.
def var vde-aliq-red-ibs-mun      as decimal format ">>>9.99" no-undo.
def var vde-aliq-is               as decimal format ">>>9.9999" no-undo.
def var vde-aliq-un-is            as decimal format ">>>9.9999" no-undo.
DEF VAR vde-qtde-trib-is          AS DECIMAL FORMAT ">>>>>,>>9.9999" NO-UNDO.
DEF VAR vc-un-trib-is             AS CHARACTER                NO-UNDO.
def var vcClassTribCBS            AS CHARACTER                NO-UNDO.
def var vcClassTribIBS-UF         AS CHARACTER                NO-UNDO.
def var vcClassTribIBS-Mun        AS CHARACTER                NO-UNDO.
def var vcClassTribIS             AS CHARACTER                NO-UNDO.
def var vcCST-CBS                 AS CHARACTER                NO-UNDO.
def var vcCST-IBS-UF              AS CHARACTER                NO-UNDO.
def var vcCST-IBS-Mun             AS CHARACTER                NO-UNDO.
def var vcCST-IS                  AS CHARACTER                NO-UNDO.
def var vcCalssTribREG-CBS        AS CHAR                     NO-UNDO.
def var vcCST-REG-CBS             AS CHAR                     NO-UNDO.
def var vdeAliqEfetivaREG-CBS     AS DECIMAL FORMAT ">>9.99"  NO-UNDO.
def var vcCalssTribREG-IBS-UF     AS CHAR                     NO-UNDO.
def var vcCST-REG-IBS-UF          AS CHAR                     NO-UNDO.
def var vdeAliqEfetivaREG-IBS-UF  AS DECIMAL FORMAT ">>9.99"  NO-UNDO.
def var vcCalssTribREG-IBS-Mun    AS CHAR                     NO-UNDO.
def var vcCST-REG-IBS-Mun         AS CHAR                     NO-UNDO.
def var vdeAliqEfetivaREG-IBS-Mun AS DECIMAL FORMAT ">>9.99"  NO-UNDO.



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


