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
       field cod-estabel      like controle-preco.cod-estabel
       field it-codigo        like controle-preco.it-codigo  
       field cod-emitente     like emitente.cod-emitente
       field data-cotacao     like controle-preco.data-cotacao 
       field inicio-calculo   as date format "99/99/9999"  label "Data In¡cio C lculo"
       field cod-cond-pag     like cond-pagto.cod-cond-pag
       field valor-taxa       as decimal format "->>9.99"
       field preco-unit-vista as decimal format "->>>,>>9.9999"
       field preco-unit-prazo as decimal format "->>>,>>9.9999"
       field perc-ant         as decimal extent 3 format "->>9.99"
       field perc-acum        as decimal extent 3 format "->>9.99"
       field aliquota-ipi     as decimal format "->>9.99"  
       field nome-emit        like emitente.nome-emit 
       field preco-moeda      as decimal extent 3 format "->>>,>>9.9999"
       field manual-autom     as char
       field sequencia        as integer 
       field r-rowid          as rowid.

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
         HEIGHT             = 2.01
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOTempTable 



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

















