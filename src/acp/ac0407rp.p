/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0407RP 2.00.00.008}  /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AC0407RP MAC}
&ENDIF




/*******************************************************************************
**
** Ac0407RP.P : ImpressÆo de Curva ABC de Pontos Por Cliente
**
********************************************************************************/
{utp/ut-glob.i}
/* ************************ Defini‡Æo de vari veis *************************** */

{include/i-rpvar.i}

def var c-selecao      as char format "x(11)"              no-undo.
def var c-parametro    as char format "x(14)"              no-undo.
def var c-impressao    as char format "x(12)"              no-undo.
def var c-destino      as char format "x(10)"              no-undo.
def var h-acomp        as handle                           no-undo.

/* ********************  Defini‡Æo de Temp-Table ****************************** */

def temp-table tt-raw-digita
   field raw-digita      as raw.
{acp/ac0407.i}  /* Defini‡Æo da Temp-table tt-param */

/* ************************ Defini‡Æo de parametros ************************** */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

/* *********** Defini‡Æo do layout da p gina de parƒmetros ****************** */

form skip(01)
     c-selecao   no-label    skip(1)
     tt-param.cliente-ini    colon 40 space(10) "|< >|"
     tt-param.cliente-fim    no-label colon 73 skip
     tt-param.dt-inicial     colon 40 space(12) "|< >|"
     tt-param.dt-final       no-label colon 73 skip(1)
     c-parametro no-label    skip(1)
     tt-param.perc-amostra   colon 40 skip(1)
     c-impressao no-label    skip(1)
     c-destino               colon 40
     " - ":U
     tt-param.arquivo no-label format "x(60)":U skip
     tt-param.usuario        colon 40 skip
     with down no-box side-labels width 132 stream-io frame f-parametros.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-parametros:HANDLE).


/* *********************** Defini‡Æo de literais  ***************************** */

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

{utp/ut-liter.i Per¡odo * L}
assign tt-param.dt-inicial:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Percentual_da_Amostra * L}
assign tt-param.perc-amostra:label in frame f-parametros = trim(return-value).

/* ************************ Inicio do programa ****************************** */
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.

run utp/ut-acomp.p persistent set h-acomp.
find empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
if avail empresa then
   assign c-empresa = empresa.razao-social.

assign c-programa = 'ac0407'
       c-destino  = {varinc/var00002.i 04 tt-param.destino}.
{utp/ut-liter.i Curva_ABC_de_Pontos_por_Cliente MAP C}
assign c-titulo-relat = return-value.

{include/i-rpout.i}
view frame f-cabec.
view frame f-rodape.

run pi-inicializar in h-acomp (input "Aguarde...").

main-block:
do  on error  undo main-block, leave main-block
    on endkey undo main-block, leave main-block
    on stop   undo main-block, leave main-block:
      run acp/ac0407a.p (input-output raw-param).
      raw-transfer raw-param to tt-param.
end.
run pi-finalizar in h-acomp.

/* **************** ImpressÆo da p gina de parƒmetros ************* */

if  page-number > 0 then page.
display c-selecao 
        tt-param.cliente-ini      
        tt-param.cliente-fim      
        tt-param.dt-inicial
        tt-param.dt-final
        c-parametro
        tt-param.perc-amostra
        c-impressao
        c-destino
        tt-param.arquivo
        tt-param.usuario
        with frame f-parametros.

down with frame f-parametros.

{include/i-rpclo.i}

RETURN "OK".

/* Fim do Programa */


