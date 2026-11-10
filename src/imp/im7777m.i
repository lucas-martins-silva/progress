/*
**
** IM7777M.I - Defini‡äes temp-tables/vari veis IM7777M.P 
** 
*/

{imp/im7777.i1}      /* Definicao das temp-tables de entrada */
{include/boerrtab.i} /* Definicao tt-bo-erro */
{imp/im0091.i}       /* Defini‡Æo temp-table para rateio de despesas */
{cdp/cd4300.i3}      /* Include tratamento atributo livre */
{cxbo/bocx250.i50}   /* Atributo livre parametros de importacao */

def temp-table tt-impto-item-docto no-undo like impto-item-docto.
def temp-table tt-retorno          no-undo like tt-bo-erro.

def temp-table tt-imposto no-undo
    field cod-estabel     as char    format "X(3)"
    field nat-operacao    as char    format "X(6)"
    field nome-pais	      as char    format "X(20)"
    field cod-estado      as char    format "X(4)"
    field nom-cidade	  as char    format "X(25)"
    field fm-codigo	      as char    format "X(8)"
    field it-codigo	      as char    format "X(16)"
    field cdn-imposto     as integer
    field tipo-imposto    as integer 
    index imposto is primary unique cod-estabel 
                                    nat-operacao
                                    nome-pais   
                                    cod-estado  
                                    nom-cidade  
                                    fm-codigo   
                                    it-codigo
                                    cdn-imposto
                                    tipo-imposto.

def temp-table tt-dupli no-undo
    field dt-vencim     as date
    field tp-despesa    as integer
    field vl-apagar     as decimal
    field vl-apagar-mo  as decimal
    field mo-codigo     as int
    index data mo-codigo dt-vencim.

def temp-table tt-dupli-apagar-cex no-undo
    field cod-emitente      like dupli-apagar-cex.cod-emitente
    field nat-operacao      like dupli-apagar-cex.nat-operacao
    field serie-docto       like dupli-apagar-cex.serie-docto
    field nro-docto         like dupli-apagar-cex.nro-docto
    field cod-emitente-desp like dupli-apagar-cex.cod-emitente-desp
    field cod-desp          like docum-est-cex.cod-desp
    field mo-codigo         like dupli-apagar-cex.mo-codigo
    field dt-vencim         like dupli-apagar-cex.dt-vencim
    field tp-despesa        like dupli-apagar-cex.tp-despesa
    field vl-a-pagar        like dupli-apagar-cex.vl-a-pagar
    field vl-a-pagar-mo     like dupli-apagar-cex.vl-a-pagar-mo
    field cod-esp           like dupli-apagar-cex.cod-esp
    index codigo
          serie-docto
          nro-docto
          cod-emitente
          nat-operacao
          cod-desp
          cod-emitente-desp
    index data
          cod-emitente-desp
          dt-vencim.
        
def temp-table tt-erro-aux no-undo
	field identif-segment as char
	field cd-erro         as integer
	field desc-erro       as char format "x(80)".

def temp-table tt-erro-aux-2 no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)"
    field c-param  as char.

def temp-table tt-docum-est-cex    no-undo like docum-est-cex.
def temp-table tt-item-doc-est-cex no-undo like item-doc-est-cex.    
def temp-table tt-it-docto-aux     no-undo like tt-it-docto.
def temp-table tt-it-imposto-aux   no-undo like tt-it-imposto.

def buffer b-emit-estab      for emitente.
def buffer b-item            for item.
def buffer b-tt-dupli-apagar for tt-dupli-apagar.
def buffer btipo-tax         for tipo-tax. 

def var h-cdapi027         as handle                      no-undo.
def var c-docto-aux        as character                   no-undo.
def var c-estabel          as character                   no-undo.
def var c-nat-oper         as character                   no-undo.
def var c-pais             as character                   no-undo.
def var c-uf               as character                   no-undo.
def var c-cidade           as character                   no-undo.
def var c-familia          as character                   no-undo.
def var c-item             as character                   no-undo.  
def var i-emitente         as integer                     no-undo.
def var i-emit-natur       as integer                     no-undo. 
def var i-cod-tax-aux      as integer                     no-undo. 
def var i-nat-imp          as integer                     no-undo. 
def var i-imp-retido       as integer                     no-undo. 
def var l-iva-normal       as logical                     no-undo.

def var de-base-ipi        like docum-est.base-ipi        no-undo.
def var de-base-icm        like docum-est.base-icm        no-undo.
def var de-frete           like item-doc-est.pr-total-cmi no-undo extent 0.
def var de-seguro          like docum-est.valor-seguro    no-undo extent 0.
def var de-embal           like docum-est.valor-embal     no-undo extent 0. 
def var de-outras          like docum-est.valor-outras    no-undo extent 0.
def var de-tot-seguro      like docum-est.valor-seguro    no-undo extent 0.
def var de-tot-embal       like docum-est.valor-embal     no-undo extent 0.
def var de-tot-outras      like docum-est.valor-outras    no-undo extent 0.
def var de-vl-imposto-me   as decimal                     no-undo.
def var de-vl-imposto      as decimal                     no-undo.
def var de-vl-base-calc    as decimal                     no-undo.

def var dat-tipo-dia   like calen-coml.tipo-dia no-undo. /*CD9020.i7*/

/* Arredondamento do valor das despesas para os itens */
def var de-tot-resto       like desp-embarque.val-desp    no-undo.
def var de-tot-resto-frete like desp-embarque.val-desp    no-undo.
def var de-tot-seguro-aux  like desp-embarque.val-desp    no-undo.
def var de-tot-embal-aux   like desp-embarque.val-desp    no-undo.
def var de-tot-outras-aux  like desp-embarque.val-desp    no-undo.

def var i-parcela          as int                         no-undo.
def var i-msg              as int                         no-undo.
def var c-msg              as char                        no-undo.
def var c-char             as char                        no-undo.
def var i-seq              as int                         no-undo init 0.
def var i-seq-aux          as int                         no-undo init 0.
def var i-ind              as int                         no-undo init 0.
def var i-seq-erro         as int                         no-undo init 0.
def var i-avanco           as int                         no-undo.
def var i-seq-item-doc-est as int                         no-undo.

def var l-acomp            as logical                     no-undo initial no.
def var h-acomp            as handle                      no-undo.
def var c-acomp            as char                        no-undo.

/* Integra‡Æo Unidade de Neg¢cio/EMS 5 */
def var l-conecta-emsbas   as logical                     no-undo.
def var l-conecta-emsuni   as logical                     no-undo.
/*
** Tratamento Fundap
*/ 
def var l-fornec-fundap    as logical no-undo. /* Identifica se ‚ opera‡Æo de FUNDAP */
def var de-bicms-fundap    like tt-it-imposto.vl-icms-it  no-undo.
def var de-vlicms-fundap   like tt-it-imposto.vl-icms-it  no-undo.
def var l-loc-unica        like item.loc-unica            no-undo.
def var c-cod-localiz      like item.cod-localiz          no-undo.
/*
** Tratametno PIS e COFINS
*/
def var l-calcula-pis         as logical no-undo.
def var l-calcula-cofins      as logical no-undo.
def var l-calcula-icms-im7777 as logical no-undo.

def new global shared var l-nff as log init no no-undo.

/*Parƒmetros*/
def input  parameter table for tt-nota.
def input  parameter table for tt-itens.
def output parameter table for tt-erro.
def output parameter table for tt-retorno.

/* IM7777M.I */
