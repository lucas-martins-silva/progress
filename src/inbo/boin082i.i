&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOTempTable 
/*--------------------------------------------------------------------------
    Library    : dbott.i
    Purpose    : Include que cont‚m defini‡Æo da temptable RowObject

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

{cdp/cdcfgmat.i}
DEFINE TEMP-TABLE {1} NO-UNDO
    FIELD numero-ordem   like cotacao-item.numero-ordem
    FIELD cod-emitente   like cotacao-item.cod-emitente 
    FIELD it-codigo      like cotacao-item.it-codigo
    FIELD seq-cotac      like cotacao-item.seq-cotac
    FIELD mapa-cotacao   like cotacao-item-cex.mapa-cotacao
    FIELD cod-incoterm   like inco-cx.cod-incoterm
    FIELD cod-pto-contr  like pto-contr.cod-pto-contr
    FIELD cod-fabricante like emitente.cod-emitente
    &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
    field cdn-pais-orig  as   integer format ">>,>>9":U
    &endif
    FIELD regime-import  like pais-aliquota.regime-import
    FIELD class-fiscal   like classif-fisc.class-fiscal
    FIELD aliq-ii        as   decimal format ">>9.99"
    FIELD l-ex-tarifario AS   LOGICAL
    FIELD aliq-ipi       as   decimal format ">>9.99"
    FIELD cod-itiner     like itinerario.cod-itiner
    FIELD i-informa      AS   INTEGER
    FIELD da-entrega-embarque AS DATE
    FIELD nbs            as   character
    FIELD r-Rowid AS ROWID.

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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOTempTable 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


