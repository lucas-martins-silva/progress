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

DEFINE TEMP-TABLE {1} NO-UNDO 
    FIELD cod-rep          as integer   format ">>>>9"          /* repres */
    FIELD nome             as character format "x(40)"          /* repres */
    FIELD nome-abrev       as character format "x(12)"          /* repres */
    FIELD tipo-repres      as integer   format "9"              /* repres */
    FIELD calendario-pagto as character format "x(08)"          /* repres */
    FIELD cod-emitente     as integer   format ">>>>>>>>9"      /* repres */
    FIELD bloqueado-pagto  as logical                           /* repres */
    FIELD cod-portador     as integer   format ">>>>9"          /* emitente */
    FIELD modalidade       as integer   format "9"              /* emitente */
    FIELD cod-imposto      as integer   format ">>>9"           /* repres */
    FIELD perc-imposto     as decimal   format ">>>.99"         /* tipo-tax */
    FIELD conta-imposto    as character format "x(17)"          /* tipo-tax */
    FIELD ct-imposto       as character format "x(20)"          /* tipo-tax */
    FIELD sc-imposto       as character format "x(20)"          /* tipo-tax */
    FIELD cod-retencao     as integer   format ">>>>9"          /* tipo-tax */
    FIELD cod-esp-ir       as char      format "x(02)"          /* tipo-tax */
    FIELD serie-ir         as char      format "x(05)"          /* tipo-tax */
    FIELD vl-minimo-ret    as decimal   format ">>>,>>>,>>9.99" /* tipo-tax */
    FIELD tp-pagto         as integer   format "99"             /* emitente */
    FIELD r-Rowid          as rowid                             /* repres */
    FIELD vl-minimo-comis  as decimal   format ">>>,>>>,>>9.99" initial 0 /* repres */
    FIELD mo-codigo        as integer   format ">9" initial 0 /* repres */
    FIELD log-desligado    AS LOGICAL   INITIAL NO
    FIELD log-bloqueado    AS LOGICAL   INITIAL NO. 

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


