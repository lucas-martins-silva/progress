&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOTempTable 
/*:T--------------------------------------------------------------------------
    Library    : dbott.i
    Purpose    : Include que cont‚m defini‡Æo da temptable RowObject

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

DEFINE TEMP-TABLE {1} NO-UNDO
    field cod-desp          like desp-embarque.cod-desp
    field desc-desp         like desp-imp.descricao
    field cod-emitente-desp like desp-embarque.cod-emitente-desp
    field nome-abrev        like emitente.nome-abrev
    field embarque          like desp-embarque.embarque
    field cod-pto-contr     like desp-embarque.cod-pto-contr
    field desc-pto          like pto-contr.descricao
    field moeda             like desp-embarque.mo-codigo
    field cond-pagto        like desp-embarque.cod-cond-pag
    field val-desp          like desp-embarque.val-desp
    field cod-estabel       like desp-embarque.cod-estabel
    field cod-itiner        like desp-embarque.cod-itiner
    field r-rowid           as rowid
    field selecionado       as logical
    index ch-embarque       cod-estabel embarque cod-itiner cod-pto-contr cod-desp cod-emitente-desp.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOTempTable
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOTempTable ASSIGN
         HEIGHT             = 12.04
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOTempTable 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


