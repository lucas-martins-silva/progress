/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0408RP 2.00.00.022 } /*** "010022" 22/05/2025 16:59:46  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac0408rp MAC}
&ENDIF

{include/i_fnctrad.i}
/*******************************************************************************
**
** Ac0408RP.P : ImpressÆo do relat¢rio de Composi‡Æo de Cotas
**
********************************************************************************/
{utp/ut-glob.i}
/* ************************ Defini‡Æo de vari veis *************************** */

{include/i-rpvar.i}

{cdp/cdcfgdis.i} /*include para pr‚-processadores*/

def var c-selecao          as char format "x(11)"         no-undo.
def var c-impressao        as char format "x(12)"         no-undo.
def var c-destino          as char format "x(10)"         no-undo.
def var h-acomp            as handle                      no-undo.
def var c-total            as character format "x(05)"    no-undo.
def var c-estabel          as character format "x(15)"    no-undo.
def var c-desc-regiao      as character format "x(20)"    no-undo.
def var c-nome-abrev       as character format "x(12)"    no-undo.
def var c-nome-mic-reg     as character format "x(12)"    no-undo.
def var c-cliente          as character format "x(7)"     no-undo.
def var c-canal-venda      as character format "x(11)"    no-undo.
def var c-mic-reg          as character format "x(12)"    no-undo.
def var c-ab-reg           as character format "x(11)"    no-undo.
def var c-representante    as character format "x(13)"    no-undo.
def var c-gr-cli           as character format "x(13)"    no-undo.
def var c-periodo          as character format "x(7)"     no-undo.
def var c-qt-pedido        as character format "x(17)"    no-undo.
def var c-nr-pedido        as character format "x(10)"    no-undo.
def var c-prevista         as character format "x(17)"    no-undo.
def var c-produto          as character format "x(07)"    no-undo.
def var c-realizado        as character format "x(09)"    no-undo.
def var de-tot-ped-qt      like atu-cota.qt-pedida        no-undo.
def var de-tot-ped-vl      like atu-cota.vl-pedido        no-undo.
def var l-imprime          as logical                     no-undo.
def var de-perc            as decimal format ">>9.99"     no-undo.


/* ********************  Defini‡Æo de Temp-Table ****************************** */

def temp-table tt-raw-digita
   field raw-digita      as raw.

define temp-table tt-param
    field destino              as integer
    field arquivo              as char
    field usuario              as char format "x(12)"
    field data-exec            as date
    field hora-exec            as integer
    field classifica           as integer
    field desc-classifica      as char format "x(40)"
    field cod-estab-ini        like atu-cota.cod-estabel
    field cod-estab-fim        like atu-cota.cod-estabel
    field cod-canal-venda-ini  like atu-cota.cod-canal-venda
    field cod-canal-venda-fim  like atu-cota.cod-canal-venda
    field cod-gr-cli-ini       like atu-cota.cod-gr-cli
    field cod-gr-cli-fim       like atu-cota.cod-gr-cli
    field nome-abrev-ini       like atu-cota.nome-abrev
    field nome-abrev-fim       like atu-cota.nome-abrev
    field nome-ab-reg-ini      like atu-cota.nome-ab-reg
    field nome-ab-reg-fim      like atu-cota.nome-ab-reg
    field nome-mic-reg-ini     like atu-cota.nome-mic-reg
    field nome-mic-reg-fim     like atu-cota.nome-mic-reg
    field cod-rep-ini          like atu-cota.cod-rep
    field cod-rep-fim          like atu-cota.cod-rep
    field cd-produto-ini       like atu-cota.cd-produto
    field cd-produto-fim       like atu-cota.cd-produto
    field dt-inicial           like atu-cota.dt-inicial
    field dt-final             like atu-cota.dt-final.

/* ************************ Defini‡Æo de parametros ************************** */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

/* ************************Defini‡Æo de Frames  ***************************** */

form c-estabel          at 01
     ":"                
     estabelec.nome     at 19 skip(2)
     with no-label stream-io page-top frame f-estab.   

form c-nr-pedido           at 01
     c-cliente             at 14
     c-periodo             at 27
     c-produto             at 36
     c-prevista            to 69
     c-qt-pedido           to 87
     "%":U                 at 90
     c-realizado           to 101
     "------------"        at 01
     "------------"        at 14
     "--------"            at 27
     "----------------"    at 36
     "-----------------"   at 53
     "-----------------"   at 71
     "-------------"       at 89 skip
     with width 132 no-box no-label no-attr stream-io frame f-cab1.   

form skip(1)
     c-canal-venda         no-label at 01
     " :":U                colon 14
     canal-venda.descricao no-label format "x(25)" at 19

     c-gr-cli              no-label at 56
     " :":U                colon 70
     gr-cli.descricao      no-label format "x(25)" at 75 

     c-nome-abrev          no-label at 01
     " :":U                colon 14
     atu-cota.nome-abrev   no-label format "x(25)" at 19

     c-ab-reg              no-label at 56
     " :":U                colon 70
     c-desc-regiao         no-label format "x(20)" at 75

     c-mic-reg             no-label at 01 
     " :":U                colon 14
     c-nome-mic-reg        no-label format "x(25)" at 19  

     c-representante       no-label at 56
     " :":U                colon 70
     repres.nome-abrev     no-label format "x(25)" at 75

     skip(1)    
     with width 132 no-box no-attr stream-io side-label frame f-atu-cota.   




form skip(01)
     c-selecao   no-label    skip(1)
     tt-param.cod-estab-ini              colon 40 space(12) "|< >|"
     tt-param.cod-estab-fim           no-label colon 73 skip
     tt-param.cod-canal-venda-ini        colon 40 space(14) "|< >|"
     tt-param.cod-canal-venda-fim     no-label colon 73 skip
     tt-param.cod-gr-cli-ini             colon 40 space(13) "|< >|"
     tt-param.cod-gr-cli-fim          no-label colon 73 skip
     tt-param.nome-abrev-ini             colon 40 space(5) "|< >|"
     tt-param.nome-abrev-fim          no-label colon 73 skip
     tt-param.nome-ab-reg-ini            colon 40 space(05) "|< >|"
     tt-param.nome-ab-reg-fim         no-label colon 73 skip
     tt-param.nome-mic-reg-ini           colon 40 space(05) "|< >|"
     tt-param.nome-mic-reg-fim        no-label colon 73 skip
     tt-param.cod-rep-ini                colon 40 space(12) "|< >|"
     tt-param.cod-rep-fim             no-label colon 73 skip
     tt-param.cd-produto-ini             colon 40 space(1)  "|< >|"
     tt-param.cd-produto-fim          no-label colon 73 skip
     tt-param.dt-inicial                 colon 40 space(7)  "|< >|"
     tt-param.dt-final                no-label colon 73 skip(1)     
     c-impressao                      no-label    skip(1)
     c-destino                        colon 40
     " - ":U
     tt-param.arquivo                 no-label format "x(60)":U skip
     tt-param.usuario                 colon 40 skip(1)
     with down no-box side-labels width 132 stream-io frame f-parametros.


/************************ Defini‡Æo de literais  ***************************** */


{utp/ut-liter.i SELE€ÇO * R}
assign c-selecao = trim(return-value).

{utp/ut-field.i mgdis atu-cota cod-estabel 1}
assign tt-param.cod-estab-ini:label in frame f-parametros = trim(return-value).

{utp/ut-field.i mgdis atu-cota cod-canal-venda 1}
assign tt-param.cod-canal-venda-ini:label in frame f-parametros = trim(return-value).

{utp/ut-field.i mgdis atu-cota cod-gr-cli 1}
assign tt-param.cod-gr-cli-ini:label in frame f-parametros = trim(return-value).

{utp/ut-field.i mgdis atu-cota nome-abrev 1}
assign tt-param.nome-abrev-ini:label in frame f-parametros = trim(return-value).

{utp/ut-field.i mgdis atu-cota nome-ab-reg 1}
assign tt-param.nome-ab-reg-ini:label in frame f-parametros = trim(return-value).

{utp/ut-field.i mgdis atu-cota nome-mic-reg 1}
assign tt-param.nome-mic-reg-ini:label in frame f-parametros = trim(return-value).

{utp/ut-field.i mgdis atu-cota cod-rep 1}
assign tt-param.cod-rep-ini:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Produto/Item * R}
assign tt-param.cd-produto-ini:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Per¡odo * L}
assign tt-param.dt-inicial:label in frame f-parametros = trim(return-value).


{utp/ut-liter.i IMPRESSÇO * R}
assign c-impressao = trim(return-value).
{utp/ut-liter.i Destino * L}
assign c-destino:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Usu rio * L}
assign tt-param.usuario:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Cliente * R}
assign c-cliente = trim(return-value).
{utp/ut-liter.i Per¡odo * R}
assign c-periodo = trim(return-value).
{utp/ut-field.i mgdis atu-cota nr-pedcli 1}
assign c-nr-pedido = trim(return-value).
{utp/ut-liter.i Total * R}
assign c-total = trim(return-value).
{utp/ut-field.i mgdis atu-cota cod-estabel 1}
assign c-estabel = return-value.
{utp/ut-field.i mgdis atu-cota cod-canal-venda 1}
assign c-canal-venda = return-value.
{utp/ut-field.i mgdis atu-cota cod-gr-cli 1}
assign c-gr-cli = return-value.
{utp/ut-field.i mgdis atu-cota nome-abrev 1}
assign c-nome-abrev = return-value.
{utp/ut-field.i mgdis atu-cota nome-ab-reg 1}
assign c-ab-reg = return-value.
{utp/ut-field.i mgdis atu-cota nome-mic-reg 1}
assign c-mic-reg = return-value.
{utp/ut-field.i mgdis atu-cota cod-rep 1}
assign c-representante = return-value.
{utp/ut-field.i mgdis atu-cota cd-produto 1}
assign c-produto = return-value.
{utp/ut-liter.i Realizado * R}
assign c-realizado = return-value.

/************************* Inicio do programa ****************************** */
run utp/ut-trfrrp.p (input frame f-parametros:handle).
run utp/ut-trfrrp.p (input frame f-atu-cota:handle).
run utp/ut-trfrrp.p (input frame f-cab1:handle).
run utp/ut-trfrrp.p (input frame f-estab:handle).
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.

run utp/ut-acomp.p persistent set h-acomp.
find empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
if avail empresa then
   assign c-empresa = empresa.razao-social.

assign c-programa = 'ap0408'
.
&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao001 = {varinc/var00002.i 04 tt-param.destino}.
    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                        INPUT "",
                        INPUT "").
    ASSIGN c-destino  = RETURN-VALUE.
&else
    ASSIGN c-destino  = {varinc/var00002.i 04 tt-param.destino}.
&endif

{utp/ut-liter.i Relat¢rio_Composi‡Æo_Cotas_Per¡odo MAP C}
assign c-titulo-relat = return-value.

{include/i-rpout.i}
view frame f-cabec.
view frame f-rodape.

FIND FIRST par-cota NO-LOCK NO-ERROR.
IF NOT AVAIL par-cota THEN
    RETURN "NOK".
{utp/ut-liter.i Aguarde... *}


run pi-inicializar in h-acomp (input  Return-value ).

/* Foi criada essa include, porque existe na tela AC0301 - Parƒmetros Cotas a op‡Æo (p gina Complementar):
"Cliente". Esse parƒmetro interfere no break by do for each principal do programa. 
Existiu a tentativa de passar apenas o for each do programa para a include (variando apenas o break by), 
por‚m no restante do c¢digo haviam comandos first-of e last-of que impossibilitaram essa separa‡Æo.*/

IF par-cota.Cont-cliente THEN
    {acp/ac0408.i1 "by atu-cota.nome-abrev"}
ELSE
    {acp/ac0408.i1 "by atu-cota.cod-gr-cli"}

run pi-finalizar in h-acomp.

/***************** ImpressÆo da p gina de parƒmetros **************/

if  page-number > 0 then page.
    hide frame f-estab.

display c-selecao 
        tt-param.cod-estab-ini   
        tt-param.cod-estab-fim   
        tt-param.cod-canal-venda-ini   
        tt-param.cod-canal-venda-fim   
        tt-param.cod-gr-cli-ini
        tt-param.cod-gr-cli-fim
        tt-param.nome-abrev-ini
        tt-param.nome-abrev-fim
        tt-param.nome-ab-reg-ini    
        tt-param.nome-ab-reg-fim    
        tt-param.nome-mic-reg-ini     
        tt-param.nome-mic-reg-fim    
        tt-param.cod-rep-ini      
        tt-param.cod-rep-fim      
        tt-param.cd-produto-ini   
        tt-param.cd-produto-fim  
        tt-param.dt-inicial
        tt-param.dt-final
        c-impressao
        c-destino
        tt-param.arquivo
        tt-param.usuario
        with stream-io frame f-parametros.

{include/i-rpclo.i}


RETURN "OK".


/* Fim do Programa */
