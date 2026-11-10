/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC1006RP 2.00.00.020}  /*** 010020 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac1006rp MAC}
&ENDIF

/*******************************************************************************
**
**   Programa: ac1006rp.p
**   Autor...: Datasul S/A.
**   Objetivo: Rotina para Exporta‡Æo de Base de Cota  
**   Data....: Julho de 1997
*********************************************************************************/
{utp/ut-glob.i}
/* ********************  Defini‡Æo de Temp-Table ****************************** */

/* Temporary Table Definitions ---                                      */

{acp/ac9000.i} 

define temp-table tt-param
    field destino          as   integer
    field arquivo          as   character
    field arq-destino      as   character
    field arq-entrada      as   character format "x(40)"
    field exporta          as   integer
    field desc-exporta     as   character format "x(40)"
    field usuario          as   character
    field data-exec        as   date
    field hora-exec        as   integer
    field cod-estab-ini    like cotas.cod-estabel
    field cod-estab-fim    like cotas.cod-estabel
    field produto-ini      like cotas.cd-produto
    field produto-fim      like cotas.cd-produto
    field data-ini         like cotas.dt-inicial
    field data-fim         like cotas.dt-inicial.

DEFINE TEMP-TABLE tt-base-cota NO-UNDO LIKE base-cota 
    FIELD r-Rowid AS ROWID
    FIELD des-produto-coml LIKE produto-coml.des-produto-coml
    FIELD descricao        LIKE produto.descricao
    FIELD desc-item        LIKE ITEM.desc-item
    FIELD cd-produtos      LIKE cotas.cd-produto.
def temp-table tt-raw-digita
   field raw-digita      as raw.

{utp/utapi003.i} /* defini‡äes de temp-table usadas para transportar dados para */
                 /* o excel.                                                    */

/* ************************ Defini‡Æo de parametros ************************** */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
DEFINE VARIABLE ch-excel   AS COM-HANDLE NO-UNDO.

/* ************************ Defini‡Æo de Vari veis ************************** */

{include/i-rpvar.i}        

def var h-acomp            as handle                      no-undo.
def var c-selecao          as character format "x(11)"    no-undo.
def var c-parametro        as character format "x(14)"    no-undo.
def var c-impressao        as character format "x(12)"    no-undo.
def var c-destino          as character format "x(10)"    no-undo.
def var c-exporta          as character format "x(30)"    no-undo.
def var c-produto          as character format "x(13)"    no-undo.
def var c-descricao        as character format "x(9)"     no-undo.
def var c-previsto         as character format "x(8)"     no-undo.
def var c-pedido           as character format "x(6)"     no-undo.
def var c-liberado         as character format "x(9)"     no-undo.
def var c-data-liber       as character format "x(9)"     no-undo.
def var c-data-alter       as character format "x(9)"     no-undo.
def var c-pontos           as character format "x(6)"     no-undo.
def var c-periodo          as character format "x(7)"     no-undo.
def var i-cont-colun       as integer                     no-undo.
def var i-linha            as integer   initial 1         no-undo.
def var c-titulo-planilha  as character                   no-undo.
def var l-european-format  as logical                     no-undo.

{cdp/cdcfgdis.i} /*include para pr‚-processadores*/

/* ************************* Defini‡Æo de Stream ***************************** */

def stream s-exporta.

/* ************************** Defini‡Æo de Form ****************************** */
form skip(2) 
     base-cota.cod-estabel    at 01
     "-"                      at 24
     estabelec.nome  no-label at 27 skip(1)
     with side-labels stream-io attr-space frame f-estabel.

form skip(01)
     c-selecao   no-label    skip(1)
     tt-param.cod-estab-ini              colon 40 space(14) "|< >|"
     tt-param.cod-estab-fim           no-label colon 73 skip
     tt-param.produto-ini                colon 40 space(1)  "|< >|"
     tt-param.produto-fim             no-label colon 73 skip
     tt-param.data-ini                   colon 40 space(7)  "|< >|"
     tt-param.data-fim                no-label colon 73 skip
     c-parametro no-label    skip(1)
     tt-param.desc-exporta   colon 40
     tt-param.arq-entrada      colon 40 skip(1)
     c-impressao no-label    skip(1)
     c-destino               colon 40
     " - ":U
     tt-param.arq-destino no-label format "x(60)":U skip
     tt-param.usuario        colon 40 skip
     with down no-box side-labels width 132 stream-io frame f-parametros.

/* ****************************** Literais ********************************** */

{utp/ut-liter.i SELE€ÇO * R}
assign c-selecao = trim(return-value).

{utp/ut-liter.i PAR¶METROS * R}
assign c-parametro = trim(return-value).

{utp/ut-liter.i IMPRESSÇO * R}
assign c-impressao = trim(return-value).

{utp/ut-liter.i Destino * L}
assign c-destino:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Usu rio * L}
assign tt-param.usuario:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Exporta_para * L}
assign tt-param.desc-exporta:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Arquivo_Sa¡da * L}
assign tt-param.arq-entrada:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Produto/Item * R}
assign c-produto = trim(return-value).

{utp/ut-liter.i Previsto * R}
assign c-previsto = trim(return-value).

{utp/ut-liter.i Pedido * R}
assign c-pedido = trim(return-value).

{utp/ut-liter.i Descri‡Æo * R}
assign c-descricao = trim(return-value).

{utp/ut-liter.i Per¡odo * R}
assign c-periodo = trim(return-value).

{utp/ut-liter.i Liberada * R}
assign c-liberado = trim(return-value).

{utp/ut-liter.i Libera‡Æo * R}
assign c-data-liber = trim(return-value).

{utp/ut-liter.i Altera‡Æo * R}
assign c-data-alter = trim(return-value).

{utp/ut-liter.i Pontos * R}
assign c-pontos = trim(return-value).

{utp/ut-liter.i Exportando_Cotas MCT C}
assign c-exporta = trim(return-value).

{utp/ut-liter.i Exporta‡Æo_Cotas MCT C}  
assign c-titulo-relat = return-value.

{utp/ut-liter.i Produto/Item * R}
assign tt-param.produto-ini:LABEL IN FRAM f-parametros = trim(return-value).

/* ************************************************************************* */
run utp/ut-trfrrp.p (input frame f-parametros:handle).
run utp/ut-trfrrp.p (input frame f-estabel:handle).
{include/i-rpcab.i}

/*
** Verifica se formato num‚rico ‚ europeu ou americano
*/
if session:numeric-format = "EUROPEAN":U then
    assign l-european-format = yes.
else
    assign l-european-format = no.

create tt-param.
raw-transfer raw-param to tt-param.
find empresa 
     where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.

{utp/ut-liter.i Base_Cota MCT L}                 
assign c-programa = "AC/1006"
       c-empresa  = empresa.razao-social
       c-sistema  = return-value
       c-destino  = {varinc/var00002.i 04 tt-param.destino}.

{include/i-rpout.i &tofile=tt-param.arq-destino}

view frame f-cabec.
view frame f-rodape.

run utp/ut-acomp.p persistent set h-acomp.  
run pi-inicializar in h-acomp (input c-exporta).

if tt-param.exporta = 1 then
   run pi-exporta-arquivo.
else
   run pi-exporta-excel.

run pi-finalizar in h-acomp. 

/* **************** ImpressÆo da p gina de parƒmetros ************* */

if  page-number > 0 then page.
display c-selecao 
        tt-param.cod-estab-ini   
        tt-param.cod-estab-fim  
        tt-param.produto-ini   
        tt-param.produto-fim  
        tt-param.data-ini
        tt-param.data-fim
        c-parametro
        tt-param.desc-exporta
        tt-param.arq-entrada
        c-impressao
        c-destino
        tt-param.arq-destino        
        tt-param.usuario
        with frame f-parametros.

{include/i-rpclo.i}

Return "OK".
/*fim-do-programa*/

procedure pi-exporta-arquivo:
output stream s-exporta to value(tt-param.arq-entrada).
main-block:
do  on error  undo main-block, leave main-block
    on endkey undo main-block, leave main-block
    on stop   undo main-block, leave main-block:

    for each base-cota no-lock 
        where base-cota.cod-estabel >= tt-param.cod-estab-ini
        and   base-cota.cod-estabel <= tt-param.cod-estab-fim
        and   base-cota.cd-produto  >= tt-param.produto-ini        
        and   base-cota.cd-produto  <= tt-param.produto-fim
        and   base-cota.dt-inicial  >= tt-param.data-ini
        and   base-cota.dt-inicial  <= tt-param.data-fim
        break by base-cota.cod-estabel:

        IF  VALID-HANDLE(h-acomp) THEN  
        /* Inicio -- Projeto Internacional */
        DO:
        {utp/ut-liter.i "Gerando" *}
        run pi-acompanhar in h-acomp (input RETURN-VALUE + ": " + base-cota.cd-produto).
        END. 
        if first-of(base-cota.cod-estabel) then do:
            disp base-cota.cod-estabel with frame f-estabel.
            find estabelec no-lock
                 where estabelec.cod-estabel = base-cota.cod-estabel no-error.
            if avail estabelec then 
               disp estabelec.nome with frame f-estabel.

            put c-produto    at 01
                c-descricao  at 18
                c-periodo    at 38
                c-previsto   at 58
                c-pedido     at 78
                c-liberado   at 94
                c-data-liber at 105
                c-data-alter at 117
                c-pontos     at 127 
                "----------------"   at 01
                "------------------" at 18
                "----------"         at 38
                "-----------------"  at 49
                "-----------------"  at 67
                "-----------------"  at 85
                "----------"         at 104
                "----------"         at 116
                "--------"           at 127 skip.
        end.

        find par-cota no-lock
             where par-cota.cod-estabel = base-cota.cod-estabel no-error.

        if LINE-COUNTER >= 57 then page.

        put base-cota.cd-produto at 01. 

        &if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */
          find first produto-coml no-lock where
                     produto-coml.cod-produto-coml = base-cota.cd-produto no-error.
          if avail produto-coml then 
             put  produto-coml.des-produto-coml format "x(18)" at 18.
          if not avail produto-coml then do:
        &else
          find first produto no-lock where
                     produto.cd-produto = base-cota.cd-produto no-error.
          if avail produto then 
             put  produto.descricao format "x(18)" at 18.
          if not avail produto then do:
        &endif

             for first item fields(desc-item) no-lock where
                       item.it-codigo = base-cota.cd-produto :
                 put item.desc-item format "x(18)" at 18.
             end.
          end.   

        /*gera log*/
        put  base-cota.dt-inicial  at 38 
             base-cota.qt-prevista at 49
             base-cota.qt-pedida   at 67
             base-cota.qt-liberada at 85
             base-cota.data-liber  at 104
             base-cota.data-alter  at 116
             base-cota.nr-pontos   at 127.

        /*exporta para arquivo texto*/
        put stream s-exporta 
&IF "{&mguni_version}" >= "2.071" &THEN
            base-cota.cod-estabel            format "x(05)"   
&ELSE
            base-cota.cod-estabel            format "X(3)"   
&ENDIF
            base-cota.cd-produto             format "X(16)"
            base-cota.dt-inicial             format "99999999"
            base-cota.dt-final               format "99999999"
            base-cota.qt-prevista   * 10000  format ">>>>>>>>>>>>>>"
            base-cota.qt-pedida     * 10000  format ">>>>>>>>>>>>>>"
            base-cota.qt-liberada   * 10000  format ">>>>>>>>>>>>>>"
            base-cota.data-liber             format "99999999"
            base-cota.data-alter             format "99999999"
            base-cota.nr-pontos     * 100    format ">>>>>>>"
            base-cota.dt-bloqueio            format "99999999" skip.

    end.        
end.    
output stream s-exporta close.
end procedure.


