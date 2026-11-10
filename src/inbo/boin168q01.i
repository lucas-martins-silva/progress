&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOTempTable
/*--------------------------------------------------------------------------
    Library    : dbott.i
    Purpose    : Include que cont²m defini»’o da temptable RowObject

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

DEFINE TEMP-TABLE {1} NO-UNDO
    field it-codigo       like it-requisicao.it-codigo
    field qt-requisitada  like it-requisicao.qt-requisitada
    field sequen          like it-requisicao.sequencia    
    field un              like it-requisicao.un
    field nr-requis       like it-requisicao.nr-requisicao
    field num-ord-inv     like it-requisicao.num-ord-inv   
    field cod-estabel     like it-requisicao.cod-estabel
    field dt-entrega      like it-requisicao.dt-entrega
    field ct-codigo       like it-requisicao.ct-codigo
    field sc-codigo       like it-requisicao.sc-codigo
    field numero-ordem    like ordem-compra.numero-ordem 
    field situacao-ordem  as char format "x(18)"
    field cod-emitente    like cotacao-item.cod-emitente
    field num-pedido      like pedido-compr.num-pedido
    field situacao-pedido as char format "x(16)"
    field quant-receb     like recebimento.quant-receb
    field parcela         like prazo-compra.parcela
    field situacao        as char format "X(14)"
    field descricao       as char format "X(60)"
    field quantidade      like prazo-compra.quantidade
    field qtd-rec         like recebimento.qtd-rec    
    field urgente         like it-requisicao.log-1
    field homologa        like it-requisicao.log-1
    field afeta-qld       like it-requisicao.log-1
    field c-rowid         as char 
    field r-rowid         as rowid
    index codigo nr-requis 
                 sequen 
                 it-codigo
    index agrupa nr-requis 
                 it-codigo
                 num-ord-inv 
                 cod-estabel 
                 ct-codigo
                 sc-codigo.

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
