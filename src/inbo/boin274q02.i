&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOTempTable 
/*--------------------------------------------------------------------------
    Library    : dbott.i
    Purpose    : Include que cont‚m defini‡Æo da temptable RowObject

    Parameters :
ccp/cc0311rp.p
    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */



DEFINE TEMP-TABLE {1} NO-UNDO
    field documento          as char format "x(14)"
    field cod-comprado       like ordem-compra.cod-comprado
    field numero-ordem       like ordem-compra.numero-ordem
    field it-codigo          like ordem-compra.it-codigo
    field desc-item          as char format "X(60)"
    field situacao           as char format "X(14)"
    field natureza           as char format "X(14)"
    field data-emissao       like ordem-compra.data-emissao
    field cod-emitente       like cotacao-item.cod-emitente
    field num-pedido         like ordem-compra.num-pedido
    field estabelecimento    as char format "x(50)"
    field emitente           as char format "x(50)" 
    field situacao-pedido    as char format "x(16)"
    field item-do-forn       as char format "(16)"
    field fm-codigo          like item.fm-codigo
    field data-pedido        like ordem-compra.data-pedido
    field data-entrega       like ordem-compra.data-pedido
    field un                 as char
    field parcela            as int
    field requisitante       as char 
    field quant-saldo        as dec
    field preco-unit-mat     as dec
    field preco-unit-mat-ipi as dec
    field valor-ipi          as dec
    field quantidade         like  prazo-compra.quantidade
    field cod-estabel    like ordem-compra.cod-estabel
    field nr-processo    like ordem-compra.nr-processo
    field cod-transp     like ordem-compra.cod-transp
    field data-cotacao   like ordem-compra.data-cotacao
    field cod-cond-pag   like ordem-compra.cod-cond-pag
    field nr-requisicao  like ordem-compra.nr-requisicao
    FIELD sequencia      LIKE ordem-compra.sequencia
    field c-rowid         as char 
    field r-rowid        as rowid
    INDEX ordem numero-ordem.

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
         HEIGHT             = 7.88
         WIDTH              = 40.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOTempTable 



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


