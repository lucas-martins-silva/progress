{include/i_dbvers.i} 
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
    field marca               as char   format "x(1)"         label "" 
    field embarque            LIKE embarque-imp.embarque      label "Embarque"
&IF "{&mguni_version}" >= "2.071" &THEN
    field cod-estabel         as char   format "x(05)"        label "Estabelecimento"
&ELSE
    field cod-estabel         as char   format "x(03)"        label "Estabelecimento"
&ENDIF
    field declaracao-import   as char   format "x(20)"        label "DI Siscomex"
	field num-di-ems          as int    format ">>>>>>>>9"    label "DI EMS"
    field dt-nacionalizacao   as date   format "99/99/9999"   label "Dt Nacionaliza‡Æo"
    field cod-exportador      as int    format ">>>>>>>>9"    label "Exportador"
    field cod-itiner          as int    format ">>,>>9"       label "Itiner rio"
    field nr-conhecimento     as char   format "x(18)"        label "Conhecimento"
    field cod-conhecto-master as char   format "x(25)"        label "Conhecto Master"
    field cod-conhecto-house  as char   format "x(25)"        label "Conhecto House"
    field embarque-original   LIKE embarque-imp.embarque      label "Embarque Original"
    field cod-incoterm        as char   format "x(3)"         label "Incoterm"
    field r-rowid             as rowid
    index leitura embarque cod-estabel
    index selecao marca.

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


