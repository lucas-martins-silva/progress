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
      field aprov-auto       like doc-pend-aprov.aprov-auto
      field aprov-tec        like doc-pend-aprov.aprov-tec
      field aprov-total      like doc-pend-aprov.aprov-total
      field char-1           like doc-pend-aprov.char-1
      field char-2           like doc-pend-aprov.char-2
      field cod-aprov        like doc-pend-aprov.cod-aprov
      field cod-aprov-altern like doc-pend-aprov.cod-aprov-altern
      field cod-emitente     like doc-pend-aprov.cod-emitente
      field cod-rej          like doc-pend-aprov.cod-rej
      field cod-tip-aprov    like doc-pend-aprov.cod-tip-aprov
      field cod-usuario      like doc-pend-aprov.cod-usuario
      field cot-aprovada     like doc-pend-aprov.cot-aprovada
      field data-1           like doc-pend-aprov.data-1
      field data-2           like doc-pend-aprov.data-2
      field dec-1            like doc-pend-aprov.dec-1
      field dec-2            like doc-pend-aprov.dec-2
      field dt-aprova        like doc-pend-aprov.dt-aprova
      field dt-geracao       like doc-pend-aprov.dt-geracao
      field dt-reaprova      like doc-pend-aprov.dt-reaprova
      field dt-rejeita       like doc-pend-aprov.dt-rejeita
      field ind-situacao     like doc-pend-aprov.ind-situacao
      field ind-tip-aprov    like doc-pend-aprov.ind-tip-aprov
      field ind-tip-doc      like doc-pend-aprov.ind-tip-doc
      field int-1            like doc-pend-aprov.int-1
      field int-2            like doc-pend-aprov.int-2
      field it-codigo        like doc-pend-aprov.it-codigo
      field log-1            like doc-pend-aprov.log-1
      field log-2            like doc-pend-aprov.log-2
      field narrativa-apr    like doc-pend-aprov.narrativa-apr
      field narrativa-rej    like doc-pend-aprov.narrativa-rej
      field nr-requisicao    like doc-pend-aprov.nr-requisicao
      field nr-trans         like doc-pend-aprov.nr-trans
      field num-faixa        like doc-pend-aprov.num-faixa
      field num-pedido       like doc-pend-aprov.num-pedido
      field numero-ordem     like doc-pend-aprov.numero-ordem
      field sc-codigo        like doc-pend-aprov.sc-codigo
      field seq-aprov        like doc-pend-aprov.seq-aprov
      field sequencia        like doc-pend-aprov.sequencia
      field sit-aprov        like doc-pend-aprov.sit-aprov
      field prioridade       like doc-pend-aprov.prioridade
      field nr-contrato      like doc-pend-aprov.nr-contrato
      FIELD r-Rowid          AS   ROWID
      index priori-descend is primary prioridade descending.



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

