/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/******************************************************************************
**
** Include: imr2000.i - Processo Exporta‡Æo - Variaveis e Tamp-table
**
*******************************************************************************/
/***************************** Defini‡Æo de Vari veis *************************/ 
/*Include VersÆo Cex*/
{cdp/cdcfgcex.i}
def var c-selecao       as char no-undo.
def var c-impressao     as char no-undo.
def var c-classifica    as char no-undo.
def var c-descr-merc    as char no-undo.
def var d-peso-liq      as dec no-undo.
def var c-di-re         as char no-undo.

DEFINE VARIABLE c-empresa-prin    AS CHARACTER format "x(49)"  NO-UNDO.
DEFINE VARIABLE c-empresa-cgc     AS CHARACTER format "x(25)"  NO-UNDO.
DEFINE VARIABLE c-nr-ato-con      AS character format "x(40)"  NO-UNDO.

def var c-dt-di-re      as char no-undo.
def var c-nf            as char no-undo.
def var c-dt-nf         as char no-undo.
def var c-class-fisc    as char no-undo.
def var c-desc-merc     as char no-undo.
def var c-peso          as char no-undo.
def var c-quant         as char no-undo.
def var c-vl-merc       as char no-undo format "x(14)".
def var c-moeda-merc    as char no-undo.
def var c-vl-tot        as char no-undo format "x(09)".
def var c-moeda-tot     as char no-undo format "x(06)".
def var d-ncm           as dec no-undo.
def var l-item          as log no-undo.
def var l-ncm           as log no-undo.
def var l-it-not        as log no-undo.
def var l-di            as log no-undo.
def var cont            as int no-undo.
def var c-text-1        as char no-undo.
def var c-text-2        as char no-undo.

def var c-cod-estabel-tmp like estabelec.cod-estabel    no-undo.
def var c-serie-tmp       like it-nota-fisc.serie       no-undo.
def var c-nr-nota-fis-tmp like it-nota-fisc.nr-nota-fis no-undo.
def var i-nr-seq-fat-tmp  like it-nota-fisc.nr-seq-fat  no-undo.
def var c-it-codigo-tmp   like item.it-codigo           no-undo.
def var c-nr-re           like proc-ped-ent.nr-re       no-undo.
/******************************Defini‡Æo de Temp Table ****************************/


define temp-table tt-unificado-re NO-UNDO 
    field nr-re         like proc-ped-ent.nr-re 
    field data-re as    date format "99/99/9999"
    field nr-nota-fis   like nota-fiscal.nr-nota-fis
    field data-nf       like tt-unificado-re.data-re
    field cod-ncm       like classif-fisc.cod-ncm
    field class-fiscal  like classif-fisc.class-fiscal
    field descricao     as char format "x(36)"
    field peso          like it-nota-fisc.peso-liq
    field quantidade    as decimal
    field un            as char
    field sigla         as char format "x(6)"
    field valor         like it-nota-fisc.vl-merc-liq
    field valor-me      as decimal format ">,>>>,>>9.99"
    field mo-codigo     like moeda.mo-codigo
    field dat-cotac     like tt-unificado-re.data-re
    field serie         as char format "x(5)"
    field r-rowid       as rowid.
  
define temp-table tt-unificado-di NO-UNDO
    field declaracao-import like embarque-imp.declaracao-import 
    field data-di           as date format "99/99/9999"
    field nr-nota-fis       like nota-fiscal.nr-nota-fis
    field data-nf           like tt-unificado-di.data-di
    field cod-ncm           like classif-fisc.cod-ncm
    field class-fiscal      like classif-fisc.class-fiscal
    field descricao         as char format "x(36)"
    field peso              like it-nota-fisc.peso-liq
    field quantidade        as decimal
    field un                as char
    field sigla             as char format "x(6)"
    field valor             like it-nota-fisc.vl-merc-liq
    field valor-me          as decimal format ">,>>>,>>9.99"
    field mo-codigo         like moeda.mo-codigo
    field dat-cotac         like tt-unificado-di.data-di
    field serie             as char format "x(5)"
    field r-rowid           as rowid.

define temp-table tt-param NO-UNDO
    field destino                   as integer
    field moeda                     as integer
    field arquivo                   as char
    field diretorio                 as char
    field usuario                   as char
    field data-exec                 as date
    field hora-exec                 as integer
    field classifica                as integer
    field desc-classifica           as char
    field parametro                 as logical init yes
    field detalhado                 as logical
    field nr-copias                 as integer
    field c-destino                 as char
    field formato                   as integer
    field ep-codigo                 like empresa.ep-codigo
    field nr-pedido-drb-ini         like pedido-drb.nr-pedido-drb
    field nr-pedido-drb-fim         like pedido-drb.nr-pedido-drb
    field nr-ato-concessorio        like pedido-drb.nr-ato-concessorio
    FIELD nr-ato-concessorio-fim    LIKE pedido-drb.nr-ato-concessorio
    FIELD imprime-un-ncm            AS LOGICAL
    field i-moeda                   as int.
        
    {cxbo/bocx312.i tt-pedido-drb}
               
define temp-table tt-aux-re NO-UNDO
    field fixo              as char 
    field estab             as char
    field proc              as char
    field re                as char
    field data-re           as date format "99/99/9999"
    field nr-nf             as char
    field dt-nf             as char
    field class-fisc        as decimal
    field desc-merc         as char
    field peso              as decimal
    field quantidade        as int
    field un                as char
    field vl-embarque       as decimal
    field total             as decimal.

define temp-table tt-aux-di NO-UNDO
    field fixo              as char 
    field estab             as char
    field proc              as char        
    field di                as char
    field data-di           as date format "99/99/9999"
    field nr-nf             as char
    field dt-nf             as char
    field class-fisc        as decimal
    field desc-merc         as char
    field peso              as decimal
    field quantidade        as int
    field un                as char    
    field vl-embarque       as decimal
    field total             as decimal.            

def temp-table tt-raw-digita
    field raw-digita as raw.    
        
{include/tt-edit.i}
    
/* Fim da include */
