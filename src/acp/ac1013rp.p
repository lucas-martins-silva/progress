/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC1013RP 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac1013rp MAC}
&ENDIF

/*******************************************************************************
**
** Ac1013RP.P : C¢pia Base Rateio e impressÆo dos parƒmetros
**
********************************************************************************/
{utp/ut-glob.i}
/* ********************  Defini‡Æo de Temp-Table ****************************** */

def temp-table tt-raw-digita
   field raw-digita      as raw.

define temp-table tt-param
    field destino          as integer
    field arquivo          as char
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field codigo-origem    like base-rat.codigo
    field codigo-dest      like base-rat.codigo
    field elimina          as logical
    field estabel-ini      like base-rat.cod-estabel
    field estabel-fim      like base-rat.cod-estabel.

/* ************************ Defini‡Æo de parametros ************************** */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

/* ************************ Defini‡Æo de vari veis *************************** */

{include/i-rpvar.i}

def var c-processa       as char format "x(20)"              no-undo.
def var c-selecao        as char format "x(11)"              no-undo.
def var c-parametro      as char format "x(14)"              no-undo.
def var c-impressao      as char format "x(12)"              no-undo.
def var c-destino        as char format "x(10)"              no-undo.
def var h-acomp          as handle                           no-undo.
def var i-cont           as integer                          no-undo.

/* ************************* Defini‡Æo de Buffers *************************** */

def buffer b-base-rat for base-rat.
def buffer b-base-rat-2 for base-rat.

/* *********** Defini‡Æo do layout da p gina de parƒmetros ****************** */

form skip(01)
     c-selecao   no-label    skip(1)
     tt-param.estabel-ini    colon 40 space(14) "|< >|" 
     tt-param.estabel-fim  no-label colon 73 skip(1)
     c-parametro no-label    skip(1)
     tt-param.codigo-origem  colon 40 skip
     tt-param.codigo-dest    colon 40 skip
     tt-param.elimina        colon 40 skip(1)
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

{utp/ut-liter.i Processando * L}
assign c-processa = trim(return-value).

{utp/ut-liter.i Tipo_Base_Rateio_Origem * L}
assign tt-param.codigo-origem:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Tipo_Base_Rateio_Destino * L}
assign tt-param.codigo-dest:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Elimina_Registros_Existentes * L}
assign tt-param.elimina:label in frame f-parametros = trim(return-value).

/* ************************ Inicio do programa ****************************** */
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.
assign i-cont = 0.

find empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
if avail empresa then
   assign c-empresa = empresa.razao-social.

{utp/ut-liter.i Controle_de_Cotas MAP C}
assign c-programa = 'ac1013'
       c-versao   = 'A.00'
       c-revisao  = '000'
       c-sistema  = return-value
       c-destino  = {varinc/var00002.i 04 tt-param.destino}.
 
{utp/ut-liter.i C¢pia_de_Base_Rateio MAP C}
assign c-titulo-relat = return-value.

/********************************************************************/
/***                     C¢pia de Base Rateio                     ***/
/********************************************************************/

assign i-cont = 0.

if tt-param.elimina then do:
   for each base-rat exclusive-lock
      where base-rat.cod-estabel >= tt-param.estabel-ini 
        and base-rat.cod-estabel <= tt-param.estabel-fim
        and base-rat.codigo       = tt-param.codigo-dest:
        delete base-rat.
   end.
end.
             
run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Criando_Arquivo... *}
run pi-inicializar in h-acomp (input RETURN-VALUE).

main-block:
do  on error  undo main-block, leave main-block
    on endkey undo main-block, leave main-block
    on stop   undo main-block, leave main-block:
 
    for each base-rat no-lock
        where base-rat.cod-estabel >= tt-param.estabel-ini
          and base-rat.cod-estabel <= tt-param.estabel-fim
          and base-rat.codigo       = tt-param.codigo-origem
        break by base-rat.cod-estabel
              by base-rat.cd-produto
              by base-rat.codigo:
        
        run pi-acompanhar in h-acomp (input base-rat.cd-produto).

        find first b-base-rat exclusive-lock use-index ch-baserat
             where b-base-rat.cod-estabel     = base-rat.cod-estabel
             and   b-base-rat.cod-canal-venda = base-rat.cod-canal-venda
             and   b-base-rat.cod-gr-cli      = base-rat.cod-gr-cli
             and   b-base-rat.nome-abrev      = base-rat.nome-abrev
             and   b-base-rat.nome-ab-reg     = base-rat.nome-ab-reg
             and   b-base-rat.nome-mic-reg    = base-rat.nome-mic-reg
             and   b-base-rat.cod-rep         = base-rat.cod-rep
             and   b-base-rat.cd-produto      = base-rat.cd-produto
             and   b-base-rat.codigo          = tt-param.codigo-dest no-error.

        if not avail b-base-rat then do:
           create b-base-rat.
           assign b-base-rat.cod-estabel     = base-rat.cod-estabel
                  b-base-rat.cod-canal-venda = base-rat.cod-canal-venda
                  b-base-rat.cod-gr-cli      = base-rat.cod-gr-cli
                  b-base-rat.nome-abrev      = base-rat.nome-abrev
                  b-base-rat.nome-ab-reg     = base-rat.nome-ab-reg
                  b-base-rat.nome-mic-reg    = base-rat.nome-mic-reg
                  b-base-rat.cod-rep         = base-rat.cod-rep 
                  b-base-rat.cd-produto      = base-rat.cd-produto
                  b-base-rat.codigo          = tt-param.codigo-dest.
           for last b-base-rat-2 use-index ch-trans no-lock :
               assign b-base-rat.nr-trans = b-base-rat-2.nr-trans + 1.
           end. 
           if not avail b-base-rat-2 then
              assign base-rat.nr-trans = 1.
        end.
        
        assign b-base-rat.pct-rateio      = base-rat.pct-rateio.
        
    end.
end.
run pi-finalizar in h-acomp.


/* **************** ImpressÆo da p gina de parƒmetros ************* */

{include/i-rpout.i}
view frame f-cabec.
view frame f-rodape.

if  page-number > 0 then page.
display c-selecao 
        tt-param.estabel-ini
        tt-param.estabel-fim
        c-parametro
        tt-param.codigo-origem
        tt-param.codigo-dest
        c-impressao
        c-destino
        tt-param.arquivo
        tt-param.usuario
        with frame f-parametros.
if tt-param.elimina then 
   {utp/ut-liter.i Sim * R}
else 
   {utp/ut-liter.i NÆo * R}

disp trim(return-value) @ tt-param.elimina with frame f-parametros.

down with frame f-parametros.
RETURN "OK".

{include/i-rpclo.i}

/* Fim do Programa */


