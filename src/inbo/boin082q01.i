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


def temp-table {1} no-undo
    field cod-emitente   like cotacao-item.cod-emitente
    field pre-unit-for   like cotacao-item.pre-unit-for
    field preco-fornec   like cotacao-item.preco-fornec
    field cod-cond-pag   like cotacao-item.cod-cond-pag
    field cond-pag-desc  like cond-pagto.descricao
    field mo-codigo      like cotacao-item.mo-codigo
    field mo-desc        like moeda.descricao
    field perc-descto    like cotacao-item.perc-descto
    field valor-descto   like cotacao-item.valor-descto
    field frete          like cotacao-item.frete
    field valor-frete    like cotacao-item.valor-frete
    field dias-validade  like cotacao-item.dias-validade
    field prazo-entreg   like cotacao-item.prazo-entreg
    field data-cotacao   like cotacao-item.data-cotacao
    field aliquota-icm   like cotacao-item.aliquota-icm
    field aliquota-ipi   like cotacao-item.aliquota-ipi
    field aliquota-iss   like cotacao-item.aliquota-iss
    field codigo-icm     like cotacao-item.codigo-icm 
    field codigo-ipi     like cotacao-item.codigo-ipi     
    field taxa-financ    like cotacao-item.taxa-financ
    field valor-taxa     like cotacao-item.valor-taxa       
    field nr-dias-taxa   like cotacao-item.nr-dias-taxa
    field chave-seq      as   int     
    field numero-ordem   like ordem-compra.numero-ordem
    field situacao       like ordem-compra.situacao
    field it-codigo      like cotacao-item.it-codigo
    field seq-cotac      like cotacao-item.seq-cotac
    field un             as   char format "x(2)"
    field qt-acum-nec    like ordem-compra.qt-acum-nec
    field entrega        as   char format "x(10)"
    field preco-unit     like cotacao-item.preco-unit
    field log-2          like cotacao-item.log-2
    field narrativa      like item.narrativa format "x(80)"
    field descricao      like item.desc-item 
    field r-rowid        as   rowid
    index chave-seq is primary chave-seq.

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
         HEIGHT             = 8
         WIDTH              = 37.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOTempTable 



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


