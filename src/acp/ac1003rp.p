/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC1003RP 2.00.00.013} /*** "010013" 04/09/2026 07:22:14  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac1003rp MAC}
&ENDIF

{include/i_fnctrad.i}
/*******************************************************************************
**
** Ac1003RP.P : ExclusÆo de Cotas e impressÆo dos parƒmetros
**
********************************************************************************/
{utp/ut-glob.i}

{cdp/cdcfgdis.i} /*include para pr‚-processadores*/

/* ********************  Defini‡Æo de Temp-Table ****************************** */
def temp-table tt-raw-digita
   field raw-digita      as raw.

/* ************************ Defini‡Æo de parametros ************************** */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

define temp-table tt-param
    field destino          as integer
    field arquivo          as char
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field periodo-ini      like cotas.dt-inicial
    field periodo-fim      like cotas.dt-inicial.


/* ************************ Defini‡Æo de vari veis *************************** */

{include/i-rpvar.i}

def var c-processa       as char format "x(20)"              no-undo.
def var c-selecao        as char format "x(11)"              no-undo.
def var c-parametro      as char format "x(14)"              no-undo.
def var c-impressao      as char format "x(12)"              no-undo.
def var c-destino        as char format "x(10)"              no-undo.
def var h-acomp          as handle                           no-undo.
def var c-can-venda      as char format "x(15)"              no-undo.
def var c-gr-cliente     as char format "x(15)"              no-undo.
def var c-ab-regiao      as char format "x(15)"              no-undo.
def var c-mic-regiao     as char format "x(15)"              no-undo.
def var c-repres         as char format "x(15)"              no-undo.

def buffer b-cotas for cotas.

/* Include i-epc200.i: Defini‡Æo Temp-Table tt-epc e dos programas de EPCs */
{include/i-epc200.i ac1003rp}.


/* *********** Defini‡Æo do layout da p gina de parƒmetros ****************** */

form skip(01)
     c-selecao   no-label    skip(1)
     tt-param.periodo-ini    colon 40 skip
     tt-param.periodo-fim    colon 40 skip
     c-impressao no-label    skip(1)
     c-destino               colon 40
     " - ":U
     tt-param.arquivo no-label format "x(60)":U skip
     tt-param.usuario        colon 40 skip
     with down no-box side-labels width 132 stream-io frame f-parametros.

/* ************ Defini‡Æo do layout do cabe‡alho das cotas ******************* */

form
   c-can-venda   no-label at 05
   c-gr-cliente  no-label
   c-ab-regiao   no-label
   c-mic-regiao  no-label
   c-repres      no-label skip
   "--------------- --------------- --------------- --------------- ---------------" at 05
   with width 132 no-box stream-io frame f-cotas.

/* *********************** Defini‡Æo de literais  ***************************** */

{utp/ut-liter.i SELE€ÇO * R}
assign c-selecao = trim(return-value).

{utp/ut-liter.i IMPRESSÇO * R}
assign c-impressao = trim(return-value).

{utp/ut-liter.i Destino * L}
assign c-destino:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Usu rio * L}
assign tt-param.usuario:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Processando * L}
assign c-processa = trim(return-value).

{utp/ut-liter.i Per¡odo_Inicial * L}
assign tt-param.periodo-ini:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Per¡odo_Final * L}
assign tt-param.periodo-fim:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Canal_Venda * L}
assign c-can-venda = trim(return-value).

{utp/ut-liter.i Grupo_Cliente * L}
assign c-gr-cliente = trim (return-value).

{utp/ut-liter.i RegiÆo * L}
assign c-ab-regiao = trim(return-value).

{utp/ut-liter.i MicrorregiÆo * L}
assign c-mic-regiao = trim(return-value).

{utp/ut-liter.i Representante * L}
assign c-repres = trim(return-value).

/* ************************ Inicio do programa ****************************** */
run utp/ut-trfrrp.p (input frame f-cotas:handle).
run utp/ut-trfrrp.p (input frame f-parametros:handle).
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.

run utp/ut-acomp.p persistent set h-acomp.
find empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
if avail empresa then
   assign c-empresa = empresa.razao-social.

{utp/ut-liter.i ExclusÆo_de_Cotas MAP C}
assign c-programa = 'ac1003'
       c-versao   = 'A.00'
       c-revisao  = '000'
       c-sistema  = return-value
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

{utp/ut-liter.i ExclusÆo_de_Cotas MAP C}
assign c-titulo-relat = return-value.

{include/i-rpout.i}
view frame f-cabec.
view frame f-rodape.
{utp/ut-liter.i Aguarde... *}

run pi-inicializar in h-acomp (input  Return-value ).

for each base-cota exclusive-lock use-index periodo
    where base-cota.dt-inicial >= tt-param.periodo-ini
    and   base-cota.dt-inicial <= tt-param.periodo-fim:

    find first par-cota where par-cota.cod-estabel = base-cota.cod-estabel no-lock no-error.

    run pi-acompanhar in h-acomp ( input base-cota.cd-produto ).

    disp base-cota.cod-estabel
         base-cota.cd-produto
         base-cota.dt-inicial to 83
         skip(1)
         with width 132 side-labels STREAM-IO FRAME f-base.
    run utp/ut-trfrrp.p (input frame f-base:handle).

    /*** Cabe‡alho das cotas ***/
    find first cotas exclusive-lock 
         where cotas.cod-estabel = base-cota.cod-estabel
         and   cotas.cd-produto  = base-cota.cd-produto
         and   cotas.dt-inicial  = base-cota.dt-inicial no-error.
    if avail cotas then 
       disp c-can-venda
            c-gr-cliente
            c-ab-regiao
            c-mic-regiao
            c-repres
            with frame f-cotas.

    for each cotas USE-INDEX periodo  
             where cotas.cod-estabel = base-cota.cod-estabel
             and   cotas.cd-produto  = base-cota.cd-produto
             and   cotas.dt-inicial  = base-cota.dt-inicial exclusive-lock:

       run pi-elimina-cota.

    end.

    delete base-cota.

end.

for each cotas exclusive-lock use-index periodo
    where cotas.dt-inicial >= tt-param.periodo-ini
    and   cotas.dt-inicial <= tt-param.periodo-fim
    break by cotas.cod-estabel
          by cotas.cd-produto
          by cotas.dt-inicial:

    if first-of(cotas.dt-inicial) then do:
       find first par-cota where par-cota.cod-estabel = cotas.cod-estabel no-lock no-error.

       disp cotas.cod-estabel
            cotas.cd-produto
            cotas.dt-inicial to 83
            skip(1)
            with width 132 side-labels STREAM-IO FRAME f-cota-sem-base.
       run utp/ut-trfrrp.p (input frame f-cota-sem-base:handle).

       disp c-can-venda
            c-gr-cliente
            c-ab-regiao
            c-mic-regiao
            c-repres
            with frame f-cotas.
    end.

    run pi-elimina-cota.

end.

run pi-finalizar in h-acomp.


procedure pi-elimina-cota.
       run pi-acompanhar in h-acomp ( input cotas.cd-produto ).

       /************************************************************ 
        *  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
        ************************************************************/

       &if defined (bf_dis_adm_cotas) &then

          for each atu-cota exclusive-lock where
                  atu-cota.cod-estabel      = cotas.cod-estabel     and
                  atu-cota.cod-canal-venda  = cotas.cod-canal-venda and 
                  atu-cota.cod-gr-cli       = cotas.cod-gr-cli      and
                  atu-cota.nome-abrev-cotas = cotas.nome-abrev      and
                  atu-cota.nome-ab-reg      = cotas.nome-ab-reg     and
                  atu-cota.nome-mic-reg     = cotas.nome-mic-reg    and
                  atu-cota.cod-rep          = cotas.cod-rep         and
                  atu-cota.cd-produto       = cotas.cd-produto      and
                  atu-cota.dt-inicial      >= cotas.dt-inicial      and 
                  atu-cota.dt-final        <= cotas.dt-final        :

                  run pi-acompanhar in h-acomp ( input atu-cota.cd-produto ).

             delete atu-cota.
         end.
       &else
         if par-cota.cont-cliente then
            for each atu-cota exclusive-lock where
                     atu-cota.cod-estabel     = cotas.cod-estabel     and
                     atu-cota.cod-canal-venda = cotas.cod-canal-venda and 
                     atu-cota.cod-gr-cli      = cotas.cod-gr-cli      and
                     atu-cota.nome-abrev      = cotas.nome-abrev      and
                     atu-cota.nome-ab-reg     = cotas.nome-ab-reg     and
                     atu-cota.nome-mic-reg    = cotas.nome-mic-reg    and
                     atu-cota.cod-rep         = cotas.cod-rep         and
                     atu-cota.cd-produto      = cotas.cd-produto      and
                     atu-cota.dt-inicial     >= cotas.dt-inicial      and 
                     atu-cota.dt-final       <= cotas.dt-final        :

                     run pi-acompanhar in h-acomp ( input atu-cota.cd-produto ).

                delete atu-cota.

            end.   
         else 
            for each atu-cota exclusive-lock where
                     atu-cota.cod-estabel     = cotas.cod-estabel     and
                     atu-cota.cod-canal-venda = cotas.cod-canal-venda and 
                     atu-cota.cod-gr-cli      = cotas.cod-gr-cli      and
                     atu-cota.nome-ab-reg     = cotas.nome-ab-reg     and
                     atu-cota.nome-mic-reg    = cotas.nome-mic-reg    and
                     atu-cota.cod-rep         = cotas.cod-rep         and
                     atu-cota.cd-produto      = cotas.cd-produto      and
                     atu-cota.dt-inicial     >= cotas.dt-inicial      and 
                     atu-cota.dt-final       <= cotas.dt-final        :

                     run pi-acompanhar in h-acomp ( input atu-cota.cd-produto ).

                delete atu-cota.

            end.   

       &endif

       for each movto-cota exclusive-lock where
                movto-cota.cod-estabel     = cotas.cod-estabel     and
                movto-cota.cod-canal-venda = cotas.cod-canal-venda and
                movto-cota.cod-gr-cli      = cotas.cod-gr-cli      and
                movto-cota.nome-abrev      = cotas.nome-abrev      and
                movto-cota.nome-ab-reg     = cotas.nome-ab-reg     and
                movto-cota.nome-mic-reg    = cotas.nome-mic-reg    and
                movto-cota.cod-rep         = cotas.cod-rep         and
                movto-cota.cd-produto      = cotas.cd-produto      and
                movto-cota.dt-inicial      = cotas.dt-inicial      :

                run pi-acompanhar in h-acomp (input movto-cota.cd-produto).

           delete movto-cota. 
       end.         

       for each transfer exclusive-lock where 
                transfer.cod-estabel       = cotas.cod-estabel     and
                transfer.cod-canal-venda-o = cotas.cod-canal-venda and
                transfer.cod-gr-cli-o      = cotas.cod-gr-cli      and 
                transfer.nome-abrev-o      = cotas.nome-abrev      and
                transfer.nome-ab-reg-o     = cotas.nome-ab-reg     and
                transfer.nome-mic-reg-o    = cotas.nome-mic-reg    and 
                transfer.cod-rep-o         = cotas.cod-rep         and
                transfer.cd-produto-o      = cotas.cd-produto      and 
                transfer.dt-inicial        = cotas.dt-inicial      :

                run pi-acompanhar in h-acomp (input transfer.cd-produto-o).

            delete transfer.
       end.         


       /*** CHAMADA ESTRATGICA DE UPC **/
       run pi-chamada-upc.  

       put cotas.cod-canal-venda  to 19
           cotas.cod-gr-cli       to 35
           cotas.nome-ab-reg      at 37
           cotas.nome-mic-reg     at 53
           cotas.cod-rep          to 83.

       delete cotas.
end procedure.


procedure pi-chamada-upc.
 /*
   Chamada de upc num ponto estrat‚gico desse programa, com objetivo de eliminar outras tabelas, espec¡ficas
   de alguns clientes, como por exemplo , a Grandene 
  */   
    for each tt-epc where tt-epc.cod-event = "elimina registros".
        delete tt-epc.
    end.
    /* Include i-epc200.i2: Cria‡Æo de registro para Temp-Table tt-epc */
    {include/i-epc200.i2 &CodEvent='"elimina registros"'
                         &CodParameter='"cotas rowid"'
                         &ValueParameter="string(rowid(cotas))"}

    /* Include i-epc201.i: Chamada do programa de EPC */
    {include/i-epc201.i "elimina registros"}.
end procedure.

/* **************** ImpressÆo da p gina de parƒmetros ************* */

if  page-number > 0 then page.
display c-selecao 
        tt-param.periodo-ini
        tt-param.periodo-fim
        c-impressao
        c-destino
        tt-param.arquivo
        tt-param.usuario
        with frame f-parametros.

down with frame f-parametros.

{include/i-rpclo.i}

RETURN "OK".

/* Fim do Programa */



