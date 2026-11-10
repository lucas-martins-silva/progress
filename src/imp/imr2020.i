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
** Include: imr2020.i - Processo Exporta‡Æo - Variaveis e Tamp-table
**
*******************************************************************************/
/***************************** Defini‡Æo de Vari veis *************************/ 
def var c-selecao as char no-undo.
def var c-impressao as char no-undo.
def var c-classifica as char no-undo.
def var c-descr-merc as char no-undo.
def var d-peso-liq as dec no-undo.
def var c-di-re as char no-undo.
def var c-dt-di-re as char no-undo.
def var c-nf as char no-undo.
def var c-dt-nf as char no-undo.
def var c-class-fisc as char no-undo.
def var c-desc-merc as char no-undo.
def var c-peso as char no-undo.
def var c-quant as char no-undo.
def var c-vl-merc as char no-undo.
def var c-vl-tot as char no-undo.
def var d-ncm as dec no-undo.
def var l-item as log no-undo.
def var l-ncm  as log no-undo.
def var l-it-not as log no-undo.
def var l-di as log no-undo.
def var cont as int no-undo.
def var c-text-1 as char no-undo.
def var c-text-2 as char no-undo.
def var i-situacao as int no-undo.
def var i-situacao1 as int no-undo.
def var c-ped-drb as char no-undo format "x(20)".

def var c-dt-emis as char no-undo format "x(12)".
def var c-mod as char no-undo format "x(10)".
def var c-mot as char no-undo format "x(17)".
/******************************Defini‡Æo de Temp Table ****************************/

    define temp-table tt-param NO-UNDO
        field destino          as integer
        field moeda            as integer
        field arquivo          as char
        field diretorio        as char
        field usuario          as char
        field data-exec        as date
        field hora-exec        as integer
        field classifica       as integer
        field desc-classifica  as char
        field parametro        as logical init yes
        field detalhado        as logical
        field nr-copias        as integer
        field c-destino        as char
        field formato          as integer
        field ep-codigo        like empresa.ep-codigo
        field nr-ped-draw-ini  like pedido-drb.nr-pedido-drb
        field nr-ped-draw-fim  like pedido-drb.nr-pedido-drb
        field aprovado         as logical
        field reprovado        as logical.
        
        {cxbo/bocx312.i tt-pedido-drb}
               
        define temp-table tt-aux-aprov NO-UNDO
            field fixo              as char format "x(12)"
            field nr-pedido         as char format "x(20)"
            field dt-emis           as date
            field modalidade        as char format "x(11)".

        define temp-table tt-aux-reprov NO-UNDO
            field fixo              as char format "x(12)" 
            field nr-pedido         as char format "x(20)"
            field dt-emis           as date
            field modalidade        as char format "x(11)"
            field motivo-reprov     as char format "x(70)".


      def temp-table tt-raw-digita
        field raw-digita as raw.
    
        
   {include/tt-edit.i}

    
/* Fim da include */
