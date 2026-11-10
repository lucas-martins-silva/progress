/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC1001RP 2.00.00.028 } /*** "010028" 22/05/2025 16:59:47  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac1001rp MAC}
&ENDIF

{include/i_fnctrad.i}
/*******************************************************************************
**
**   Programa: ac1001rp.p
**   Autor...: Datasul S/A.
**   Objetivo: Calculo do Rateio  
**   Data....: Agosto de 1997
*********************************************************************************/

{utp/ut-glob.i}
{cdp/cdcfgdis.i} /*include para prÇ-processadores*/

/* Temporary Table Definitions ---                                      */

define temp-table tt-param
        field destino             as integer
        field arquivo             as char
        field usuario             as char format "x(12)"
        field data-exec           as date
        field hora-exec           as integer
        field cod-estab-ini       like cotas.cod-estabel
        field cod-estab-fim       like cotas.cod-estabel
        field cod-canal-venda-ini like cotas.cod-canal-venda
        field cod-canal-venda-fim like cotas.cod-canal-venda
        field periodo-ini         like cotas.dt-inicial
        field periodo-fim         like cotas.dt-inicial
        FIELD ped-ini             like cotas.dt-inicial
        FIELD ped-fim             like cotas.dt-inicial
        field cod-base-rat        as integer
        field desc-base-rat       as char format "x(40)"
        FIELD gera-base-rat       AS INTEGER
        field tg-deleta           as log
        field codigo              like tipo-baserat.codigo.

{acp/ac9000.i} 

def temp-table tt-raw-digita
   field raw-digita      as raw.


def temp-table tt-base-cota
   field cod-estabel     like cotas.cod-estabel
   field cod-canal-venda like cotas.cod-canal-venda
   field cod-gr-cli      like cotas.cod-gr-cli
   field nome-abrev      like cotas.nome-abrev
   field nome-ab-reg     like cotas.nome-ab-reg
   field nome-mic-reg    like cotas.nome-mic-reg
   field cd-produto      like base-cota.cd-produto
   field quantidade      like base-cota.qt-prevista
   INDEX codigo 
         cod-estabel     descending
         cod-canal-venda descending
         cod-gr-cli      descending
         nome-abrev      descending
         nome-ab-reg     descending
         nome-mic-reg    descending
         cd-produto      descending.


define temp-table tt-base-rat
    field cod-estabel     like cotas.cod-estabel
    field cod-canal-venda like cotas.cod-canal-venda
    field cd-produto      like cotas.cd-produto
    field cod-gr-cli      like cotas.cod-gr-cli
    field nome-abrev      like cotas.nome-abrev
    field nome-ab-reg     like cotas.nome-ab-reg
    field nome-mic-reg    like cotas.nome-mic-reg
    field cod-rep         like cotas.cod-rep
    field codigo          like tipo-baserat.codigo
    field quantidade      as   decimal format ">>>>,>>>,>>9.9999"
    INDEX codigo IS PRIMARY UNIQUE 
          cod-estabel
          cod-canal-venda
          cod-gr-cli
          nome-abrev
          nome-ab-reg
          nome-mic-reg
          cod-rep
          cd-produto.

&IF '{&bf_dis_versao_ems}' >= '2.04' &THEN

    DEFINE TEMP-TABLE tt-base-rat-nao-consid LIKE tt-base-rat.
    DEFINE BUFFER     b-tt-base-rat          FOR  tt-base-rat.
    DEFINE BUFFER     b-emitente             FOR  emitente.

    DEFINE TEMP-TABLE tt-produto
        FIELD cd-produto like cotas.cd-produto
        FIELD quantidade  AS DECIMAL FORMAT ">>>>,>>>,>>9.9999"
        INDEX prod IS PRIMARY UNIQUE
              cd-produto.


&ENDIF


/* ************************ Definiá∆o de parametros ************************** */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

/* ************************ Definiá∆o de Vari†veis ************************** */

{include/i-rpvar.i}        

def var l-est-unico        as logical                     no-undo.
def var h-acomp            as handle                      no-undo.
def var c-selecao          as character format "x(11)"    no-undo.
def var c-parametro        as character format "x(14)"    no-undo.
def var c-impressao        as character format "x(12)"    no-undo.
def var c-destino          as character format "x(10)"    no-undo.
def var c-produto          as character format "x(7)"     no-undo.
def var c-descricao        as character format "x(7)"     no-undo.
def var c-codigo           as character format "x(6)"     no-undo.
def var c-it-codigo        like item-cota.it-codigo       no-undo.

def var de-quantidade      like est-prod.qt-aplicada      no-undo.
def var de-tot-pct-rat     as decimal format ">>9.99"     no-undo.
DEF VAR de-tot-previsto    like base-cota.qt-prevista     NO-UNDO.
def var de-qt-dif          as decimal format ">>9.99"     no-undo.
def var de-valor-aux       as decimal format "->>>,>>>,>>9.99999" no-undo.

def var l-log-produto      as logical                     no-undo.
def var l-niveis           as logical                         no-undo.
def var c-estabel          as character format "x(07)"        no-undo.
def var c-canal-venda      as character format "x(11)"        no-undo.
def var c-gr-cli           as character format "x(13)"        no-undo.
def var c-ab-reg           as character format "x(11)"        no-undo.
def var c-mic-reg          as character format "x(12)"        no-undo.
def var c-cod-rep          as character format "x(06)"        no-undo.
def var c-prevista         as character format "x(08)"        no-undo.
def var c-percentual       as character format "x(04)"        no-undo.
def var c-cliente          as character format "x(07)"        no-undo.

def var i-cod-canal-venda like cotas.cod-canal-venda no-undo.
def var i-cod-gr-cli  like cotas.cod-gr-cli no-undo.
def var c-nome-abrev  like cotas.nome-abrev no-undo.
def var c-nome-ab-reg like cotas.nome-ab-reg no-undo.
def var c-nome-mic-reg like cotas.nome-mic-reg no-undo.
def var i-nr-trans like base-rat.nr-trans no-undo.

def var de-vl-devol-liq    like item-doc-est.valor-ipi[1] no-undo.
def var de-vl-devol-bru    like item-doc-est.valor-ipi[1] no-undo.
def var de-quant-devol     like devol-cli.qt-devolvida    no-undo. 

/* ************************* Definiá∆o de Buffer ***************************** */

DEF BUFFER b-tt-base-cota FOR tt-base-cota.
def buffer b-base-rat for base-rat.


/* ************************** Definiá∆o de Form ****************************** */

form skip(01)
     c-selecao                    no-label skip(1)
     &IF "{&mguni_version}" >= "2.071" &THEN
     tt-param.cod-estab-ini       colon 40 space(12) "|< >|"
     &ELSE
     tt-param.cod-estab-ini       colon 40 space(14) "|< >|"
     &ENDIF
     tt-param.cod-estab-fim       no-label colon 73 skip
     tt-param.cod-canal-venda-ini colon 40 space(14)  "|< >|"
     tt-param.cod-canal-venda-fim no-label colon 73 skip     
     tt-param.periodo-ini         colon 40 space(7)  "|< >|"
     tt-param.periodo-fim         no-label colon 73 SKIP
     with down no-box side-labels width 132 stream-io frame f-parametros1.


FORM 
     tt-param.ped-ini             colon 40 space(7)  "|< >|"
     tt-param.ped-fim             no-label colon 73 skip
     with down no-box side-labels width 132 stream-io frame f-parametros2.


FORM 
     skip(1)
     c-parametro no-label         skip(1)
     tt-param.desc-base-rat       colon 40
     tt-param.tg-deleta           colon 40 skip 
     with down no-box side-labels width 132 stream-io frame f-parametros3.

form 
     tt-param.gera-base-rat       colon 40 SKIP
     with down no-box side-labels width 132 stream-io frame f-parametros4.

form
     skip(1)
     c-impressao no-label         skip(1)
     c-destino                    colon 40
     " - ":U
     tt-param.arquivo             no-label format "x(60)":U skip
     tt-param.usuario             colon 40 skip
     with down no-box side-labels width 132 stream-io frame f-parametros5.

/* ************************************* Layout ******************************* */
/*       10        20        30        40        50        60        70        80        90 
123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
Estabel Canal Venda Grupo Cliente      Cliente  Nome Regi∆o Microrregi∆o Repres           Prevista   Perc
------- ----------- ------------- ------------ ------------ ------------ ------ ------------------ ------
    123         123            12 123456789012 123456789012 123456789012  12345 123456789012345678 123456
*/

/* ****************************** Literais ********************************** */

{utp/ut-liter.i SELEÄ«O * R}
assign c-selecao = trim(return-value).

{utp/ut-liter.i PAR∂METROS * R}
assign c-parametro = trim(return-value).

{utp/ut-liter.i IMPRESS«O * R}
assign c-impressao = trim(return-value).

{utp/ut-liter.i Destino * L}
assign c-destino:label in frame f-parametros5 = trim(return-value).

{utp/ut-liter.i Usu†rio * L}
assign tt-param.usuario:label in frame f-parametros5 = trim(return-value).

{utp/ut-liter.i Base_Rateio * L}
assign tt-param.desc-base-rat:label = trim(return-value).

{utp/ut-liter.i Geraá∆o_Base_Rateio * L}
assign tt-param.gera-base-rat:LABEL IN FRAME f-parametros4 = trim(return-value).

{utp/ut-liter.i Elimina_Rateio_Anterior * L}
assign tt-param.tg-deleta:label in frame f-parametros3 = trim(return-value).

{utp/ut-field.i mgdis base-rat cod-estabel 2}
assign c-estabel = trim(return-value).

{utp/ut-field.i mgdis base-rat cod-canal-venda 1}
assign c-canal-venda = trim(return-value).

{utp/ut-field.i mgdis base-rat cod-gr-cli 1}
assign c-gr-cli = trim(return-value).

{utp/ut-field.i mgdis base-rat nome-ab-reg 1}
assign c-ab-reg = trim(return-value).

{utp/ut-field.i mgdis base-rat nome-mic-reg 1}
assign c-mic-reg = trim(return-value).

{utp/ut-field.i mgdis base-rat cod-rep 1}
assign c-cod-rep = trim(return-value).

{utp/ut-liter.i Prevista * R}
assign c-prevista = trim(return-value).

{utp/ut-liter.i Cliente * R}
assign c-cliente = trim(return-value).

{utp/ut-field.i mgdis base-rat pct-rateio 2}
assign c-percentual = trim(return-value).


/* ************************************************************************* */
run utp/ut-trfrrp.p (input frame f-parametros5:handle).
run utp/ut-trfrrp.p (input frame f-parametros4:handle).
run utp/ut-trfrrp.p (input frame f-parametros3:handle).
run utp/ut-trfrrp.p (input frame f-parametros2:handle).
run utp/ut-trfrrp.p (input frame f-parametros1:handle).
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param.

find empresa 
     where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.

{utp/ut-liter.i Cotas MCT L}                 
assign c-programa = "AC/1001"
       c-empresa  = empresa.razao-social
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

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

/* Controla estabelecimento unico */
find first para-ped no-lock no-error.
if substring(para-ped.char-2,1,3) = "yes" then do:
   find par-cota no-lock
        where par-cota.cod-estabel = para-ped.estab-padrao no-error.
   if avail par-cota then 
      assign l-est-unico = yes.     
   else do: 
       {utp/ut-table.i mgdis par-cota 1}
       run utp/ut-msgs.p (input "show",
                          input 2,
                          input return-value).
       return.
   end.
end.



run utp/ut-acomp.p persistent set h-acomp.  
{utp/ut-liter.i Aguarde_... *}
run pi-inicializar in h-acomp (input  Return-value ).

main-block:
do  on error  undo main-block, leave main-block
    on endkey undo main-block, leave main-block
    on stop   undo main-block, leave main-block:

    /***************************************************************/
    /*** Apaga todos os registros da tabela base-rat de acordo   ***/
    /*** com o tipo especificado de rateio                       ***/
    /***************************************************************/
    if tt-param.tg-deleta then
       for each base-rat exclusive-lock
           where base-rat.cod-estabel >= tt-param.cod-estab-ini and
                 base-rat.cod-estabel <= tt-param.cod-estab-fim and
                 base-rat.cod-canal-venda >= tt-param.cod-canal-venda-ini and
                 base-rat.cod-canal-venda <= tt-param.cod-canal-venda-fim and
                 base-rat.codigo = tt-param.codigo:

           run pi-acompanhar in h-acomp (input base-rat.codigo).

           delete base-rat.

       end.

    /****************************************************************/
    /*** C†lculo da Base de Rateio de acordo com o tipo escolhido ***/
    /****************************************************************/
    if tt-param.cod-base-rat = 1 then
       run base-rat-cotas.
    else if tt-param.cod-base-rat = 2 then
       run base-rat-pedidos.
    else
       run base-rat-faturados.

    &IF '{&bf_dis_versao_ems}' >= '2.04' &THEN
        RUN rateia-nao-consid.
    &ENDIF

    &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN

        IF tt-param.gera-base-rat = 2 THEN DO:

            for each tt-base-cota:

                find b-emitente where b-emitente.nome-abrev = tt-base-cota.nome-abrev no-lock no-error.
                if avail b-emitente then do:

                    find b-tt-base-cota where b-tt-base-cota.cod-estabel      = tt-base-cota.cod-estabel and
                                             b-tt-base-cota.cod-canal-venda  = tt-base-cota.cod-canal-venda and
                                             b-tt-base-cota.cod-gr-cli       = tt-base-cota.cod-gr-cli and
                                             b-tt-base-cota.nome-abrev       = b-emitente.nome-matriz and
                                             b-tt-base-cota.nome-ab-reg      = tt-base-cota.nome-ab-reg and
                                             b-tt-base-cota.nome-mic-reg     = tt-base-cota.nome-mic-reg and
                                             b-tt-base-cota.cd-produto       = tt-base-cota.cd-produto exclusive-lock no-error.

                    if avail b-tt-base-cota then do:
                        if tt-base-cota.nome-abrev <> b-emitente.nome-matriz then do:
                            assign b-tt-base-cota.quantidade = b-tt-base-cota.quantidade + tt-base-cota.quantidade.
                            /*delete tt-base-cota.*/
                        end.
                    end.
                    else do:
                        assign tt-base-cota.nome-abrev = b-emitente.nome-matriz.
                    end.

                end.
                else do:
                    /*delete tt-base-cota.*/
                end.

            end.

            /***/

            for each tt-base-rat:

                find b-emitente where b-emitente.nome-abrev = tt-base-rat.nome-abrev no-lock no-error.
                if avail b-emitente then do:

                    find b-tt-base-rat where b-tt-base-rat.cod-estabel      = tt-base-rat.cod-estabel and
                                             b-tt-base-rat.cod-canal-venda  = tt-base-rat.cod-canal-venda and
                                             b-tt-base-rat.cod-gr-cli       = tt-base-rat.cod-gr-cli and
                                             b-tt-base-rat.nome-abrev       = b-emitente.nome-matriz and
                                             b-tt-base-rat.nome-ab-reg      = tt-base-rat.nome-ab-reg and
                                             b-tt-base-rat.nome-mic-reg     = tt-base-rat.nome-mic-reg and
                                             b-tt-base-rat.cod-rep          = tt-base-rat.cod-rep and
                                             b-tt-base-rat.cd-produto       = tt-base-rat.cd-produto and
                                             b-tt-base-rat.codigo           = tt-base-rat.codigo exclusive-lock no-error.

                    if avail b-tt-base-rat then do:
                        if tt-base-rat.nome-abrev <> b-emitente.nome-matriz then do:
                            assign b-tt-base-rat.quantidade = b-tt-base-rat.quantidade + tt-base-rat.quantidade.
                            delete tt-base-rat.
                        end.
                    end.
                    else do:
                        assign tt-base-rat.nome-abrev = b-emitente.nome-matriz.
                    end.

                end.
                else do:
                    delete tt-base-rat.
                end.

            end.

        end.

    &endif


     for each tt-base-rat 
        break by tt-base-rat.cd-produto
              by tt-base-rat.quantidade DESCENDING:
       assign l-niveis = no.
       &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
           find par-cota where par-cota.cod-estabel = tt-base-rat.cod-estabel
                no-lock no-error.
           if  par-cota.log-impl-niveis = yes then do:
               assign l-niveis = yes.
               if  tt-base-rat.cod-rep <> ? then do:
                   assign i-cod-canal-venda = tt-base-rat.cod-canal-venda
                          i-cod-gr-cli = tt-base-rat.cod-gr-cli
                          c-nome-abrev = tt-base-rat.nome-abrev
                          c-nome-ab-reg = tt-base-rat.nome-ab-reg
                          c-nome-mic-reg = tt-base-rat.nome-mic-reg.
               end.
               else do:
                   if  tt-base-rat.nome-mic-reg <> ? and
                       par-cota.cont-mic-reg then do:
                       assign i-cod-canal-venda = tt-base-rat.cod-canal-venda
                              i-cod-gr-cli = tt-base-rat.cod-gr-cli
                              c-nome-abrev = tt-base-rat.nome-abrev
                              c-nome-ab-reg = tt-base-rat.nome-ab-reg
                              c-nome-mic-reg = ?.
                   end.
                   else do:
                       if  tt-base-rat.nome-ab-reg <> ? and
                           par-cota.cont-ab-reg then do:
                           assign i-cod-canal-venda = tt-base-rat.cod-canal-venda
                                  i-cod-gr-cli = tt-base-rat.cod-gr-cli
                                  c-nome-abrev = tt-base-rat.nome-abrev
                                  c-nome-ab-reg = ?
                                  c-nome-mic-reg = (if par-cota.cont-mic-reg then ? else "").
                       end.
                       else do:
                           if  tt-base-rat.nome-abrev <> ? and
                               par-cota.cont-cliente then do:
                               assign i-cod-canal-venda = tt-base-rat.cod-canal-venda
                                      i-cod-gr-cli = tt-base-rat.cod-gr-cli
                                      c-nome-abrev = ?
                                      c-nome-ab-reg = (if par-cota.cont-ab-reg then ? else "")
                                      c-nome-mic-reg = (if par-cota.cont-mic-reg then ? else "").
                           end.
                           else do:
                               if  tt-base-rat.cod-gr-cli <> ? and
                                   par-cota.cont-gr-cli then do:
                                   assign i-cod-canal-venda = tt-base-rat.cod-canal-venda
                                          i-cod-gr-cli = ?
                                          c-nome-abrev = (if par-cota.cont-cliente then ? else "")
                                          c-nome-ab-reg = (if par-cota.cont-ab-reg then ? else "")
                                          c-nome-mic-reg = (if par-cota.cont-mic-reg then ? else "").
                               end.
                               else do:
                                   assign i-cod-canal-venda = ?
                                          i-cod-gr-cli = (if par-cota.cont-gr-cli then ? else 0)
                                          c-nome-abrev = (if par-cota.cont-cliente then ? else "")
                                          c-nome-ab-reg = (if par-cota.cont-ab-reg then ? else "")
                                          c-nome-mic-reg = (if par-cota.cont-mic-reg then ? else "").
                               end.
                           end.
                       end.
                   end.
               end.
               find tt-base-cota where
                    tt-base-cota.cod-estabel = tt-base-rat.cod-estabel and
                    tt-base-cota.cod-canal-venda = i-cod-canal-venda and
                    tt-base-cota.cod-gr-cli = i-cod-gr-cli and
                    tt-base-cota.nome-abrev = c-nome-abrev and
                    tt-base-cota.nome-ab-reg = c-nome-ab-reg and
                    tt-base-cota.nome-mic-reg = c-nome-mic-reg and
                    tt-base-cota.cd-produto = tt-base-rat.cd-produto
                    no-lock no-error.
           end.
       &ENDIF

       if  l-niveis = no then 
           find tt-base-cota no-lock where
                tt-base-cota.cod-estabel = "" and
                tt-base-cota.cod-canal-venda = 0 and
                tt-base-cota.cod-gr-cli = 0 and
                tt-base-cota.nome-abrev = "" and
                tt-base-cota.nome-ab-reg = "" and
                tt-base-cota.nome-mic-reg = "" and
                tt-base-cota.cd-produto = tt-base-rat.cd-produto no-error.
       find base-rat 
            where base-rat.cod-estabel     = tt-base-rat.cod-estabel
            and   base-rat.cod-canal-venda = tt-base-rat.cod-canal-venda
            and   base-rat.cod-gr-cli      = tt-base-rat.cod-gr-cli
            and   base-rat.nome-abrev      = tt-base-rat.nome-abrev
            and   base-rat.nome-ab-reg     = tt-base-rat.nome-ab-reg
            and   base-rat.nome-mic-reg    = tt-base-rat.nome-mic-reg
            and   base-rat.cod-rep         = tt-base-rat.cod-rep
            and   base-rat.cd-produto      = tt-base-rat.cd-produto 
            and   base-rat.codigo          = tt-base-rat.codigo EXCLUSIVE-LOCK no-error.
       if avail base-rat then
          assign base-rat.pct-rateio = if avail tt-base-cota then 
                                          round((tt-base-rat.quantidade * 100 / tt-base-cota.quantidade),2)
                                       else 0.
       else do:
             /* nr da transacao */ 
          for last base-rat fields(nr-trans) no-lock use-index ch-trans:
              assign i-nr-trans = base-rat.nr-trans + 1.    
          end.
          if not avail base-rat then
             assign i-nr-trans = 1.    
          create base-rat.
          assign base-rat.cod-estabel     =  tt-base-rat.cod-estabel
                 base-rat.cod-canal-venda =  tt-base-rat.cod-canal-venda
                 base-rat.cod-gr-cli      =  tt-base-rat.cod-gr-cli
                 base-rat.nome-abrev      =  tt-base-rat.nome-abrev
                 base-rat.nome-ab-reg     =  tt-base-rat.nome-ab-reg
                 base-rat.nome-mic-reg    =  tt-base-rat.nome-mic-reg
                 base-rat.cod-rep         =  tt-base-rat.cod-rep
                 base-rat.cd-produto      =  tt-base-rat.cd-produto
                 base-rat.pct-rateio      =  if avail tt-base-cota then
                                                round((tt-base-rat.quantidade * 100 / tt-base-cota.quantidade),2)
                                             else 0
                 base-rat.codigo          =  tt-base-rat.codigo
                 base-rat.nr-trans        = i-nr-trans.
       end.

       /*** Se ocorreu uma divis∆o por 0 percentual de rateio vai conter ? */
       if base-rat.pct-rateio < 0 or base-rat.pct-rateio = ? then assign base-rat.pct-rateio = 0.

       assign de-tot-pct-rat = (de-tot-pct-rat + base-rat.pct-rateio).

       if (de-tot-pct-rat - 100.00) < 0 then
           assign de-qt-dif = (de-tot-pct-rat - 100.00) / -1.
       else
           assign de-qt-dif = (de-tot-pct-rat - 100.00).

       if LINE-COUNTER <= 3 or
          first-of(tt-base-rat.cd-produto) then do:

          ASSIGN de-tot-previsto = 0.

          IF l-niveis THEN  
              FOR EACH b-tt-base-cota where
                       b-tt-base-cota.cod-canal-venda  = (if par-cota.cont-canal-venda then ? else 0) and
                       b-tt-base-cota.cod-gr-cli = (if par-cota.cont-gr-cli then ? else 0) and
                       b-tt-base-cota.nome-abrev = (if par-cota.cont-cliente then ? else "") and
                       b-tt-base-cota.nome-ab-reg = (if par-cota.cont-ab-reg then ? else "") and
                       b-tt-base-cota.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") and
                       b-tt-base-cota.cd-produto = tt-base-cota.cd-produto NO-LOCK: 
                  ASSIGN de-tot-previsto =  de-tot-previsto + b-tt-base-cota.quantidade. 
              END.          

          IF l-niveis = NO THEN 
              FOR EACH b-tt-base-cota WHERE
                       b-tt-base-cota.cd-produto = tt-base-cota.cd-produto NO-LOCK:                
                  ASSIGN de-tot-previsto =  de-tot-previsto + b-tt-base-cota.quantidade.
              END.

          disp base-rat.cd-produto  at 01 skip
               de-tot-previsto  AT 01 skip(1)
          with side-labels stream-io frame f-produto.

          {utp/ut-liter.i Produto/Item * L}
          assign base-rat.cd-produto:label in frame f-produto = trim(return-value).
          {utp/ut-liter.i Prevista * L}
          assign de-tot-previsto:label in frame f-produto = trim(return-value).
          

          put c-estabel     at 01
              c-canal-venda at 09
              c-gr-cli      at 21
              c-cliente     at 40              
              c-ab-reg      at 49
              c-mic-reg     at 61
              c-cod-rep     at 74
              c-prevista    at 91
              c-percentual  at 102
              "-------"             at 01
              "-----------"         at 09 
              "-------------"       at 21
              "------------"        at 35
              "------------"        at 48
              "------------"        at 61
              "------"              at 74
              "------------------"  at 81
              "------"              at 100 skip.

       end.      
       if tt-base-rat.quantidade < 0 then assign tt-base-rat.quantidade = 0.

       put base-rat.cod-estabel     at 01
           base-rat.cod-canal-venda at 17
           base-rat.cod-gr-cli      at 30
           base-rat.nome-abrev      at 35
           base-rat.nome-ab-reg     at 48
           base-rat.nome-mic-reg    at 61
           base-rat.cod-rep         at 74
           tt-base-rat.quantidade   at 81.

       if last-of(tt-base-rat.cd-produto) then do:
          if  l-niveis = no then do:
              if de-tot-pct-rat > 100 then do:
                 find b-base-rat 
                     where b-base-rat.cod-estabel     = base-rat.cod-estabel
                     and   b-base-rat.cod-canal-venda = base-rat.cod-canal-venda
                     and   b-base-rat.cod-gr-cli      = base-rat.cod-gr-cli
                     and   b-base-rat.nome-abrev      = base-rat.nome-abrev
                     and   b-base-rat.nome-ab-reg     = base-rat.nome-ab-reg
                     and   b-base-rat.nome-mic-reg    = base-rat.nome-mic-reg
                     and   b-base-rat.cod-rep         = base-rat.cod-rep
                     and   b-base-rat.cd-produto      = base-rat.cd-produto 
                     and   b-base-rat.codigo          = base-rat.codigo EXCLUSIVE-lock no-error.
                 if avail b-base-rat then
                   assign b-base-rat.pct-rateio = b-base-rat.pct-rateio - de-qt-dif.
              end.
              else do:
                find b-base-rat 
                     where b-base-rat.cod-estabel     = base-rat.cod-estabel
                     and   b-base-rat.cod-canal-venda = base-rat.cod-canal-venda
                     and   b-base-rat.cod-gr-cli      = base-rat.cod-gr-cli
                     and   b-base-rat.nome-abrev      = base-rat.nome-abrev
                     and   b-base-rat.nome-ab-reg     = base-rat.nome-ab-reg
                     and   b-base-rat.nome-mic-reg    = base-rat.nome-mic-reg
                     and   b-base-rat.cod-rep         = base-rat.cod-rep
                     and   b-base-rat.cd-produto      = base-rat.cd-produto 
                     and   b-base-rat.codigo          = base-rat.codigo EXCLUSIVE-LOCK no-error.
                if avail b-base-rat then
                   assign b-base-rat.pct-rateio = b-base-rat.pct-rateio + de-qt-dif.
             end.
          end.
          assign de-tot-pct-rat = 0
                 de-qt-dif      = 0. 
       end.         
       put base-rat.pct-rateio format ">>9.99"  at 100 skip.
    end.   
    put "-------"             at 01
        "-----------"         at 09 
        "-------------"       at 21
        "------------"        at 35        
        "------------"        at 48
        "------------"        at 61
        "------"              at 74
        "------------------"  at 81
        "------"              at 100 skip.


end.    

run pi-finalizar in h-acomp. 

/* **************** Impress∆o da p†gina de parÉmetros ************* */

if  page-number > 0 then page.
IF tt-param.cod-base-rat = 1 THEN DO:
  {utp/ut-liter.i Per°odo * L}
  assign tt-param.periodo-ini:label in frame f-parametros1 = trim(return-value).
END.
ELSE IF tt-param.cod-base-rat = 2 THEN DO:
  FIND FIRST par-cota NO-LOCK NO-ERROR.
  IF par-cota.tipo-data = 1 THEN DO:
     {utp/ut-liter.i Dt_Emiss∆o * L}
     ASSIGN periodo-ini:label in frame f-parametros1 = trim(return-value).
  END.
  ELSE DO:
     {utp/ut-liter.i Dt_Entrega * L}
     ASSIGN periodo-ini:label in frame f-parametros1 = trim(return-value).
  END.
END.
ELSE DO:
  {utp/ut-liter.i Dt_Emis_Nota * L}
  ASSIGN periodo-ini:label in frame f-parametros1 = trim(return-value).
END.

{utp/ut-liter.i Dt_Implantaá∆o * L}
ASSIGN ped-ini:label in frame f-parametros2 = trim(return-value).

if  tt-param.tg-deleta = yes then  
    {utp/ut-liter.i Sim * R} 
else 
    {utp/ut-liter.i N∆o * R}.

display c-selecao 
        tt-param.cod-estab-ini
        tt-param.cod-estab-fim
        tt-param.cod-canal-venda-ini
        tt-param.cod-canal-venda-fim
        tt-param.periodo-ini
        tt-param.periodo-fim with frame f-parametros1.

IF tt-param.cod-base-rat = 2 THEN
   DISPLAY tt-param.ped-ini
           tt-param.ped-fim with frame f-parametros2.

DISPLAY c-parametro
        tt-param.desc-base-rat with frame f-parametros3.

if  tt-param.tg-deleta = yes then  
    {utp/ut-liter.i Sim * R} 
else 
    {utp/ut-liter.i N∆o * R}.
disp trim(return-value) @ tt-param.tg-deleta 
     with frame f-parametros3.

&IF "{&bf_dis_versao_ems}" >= "2.04" &THEN

    if tt-param.gera-base-rat = 1 then
        {utp/ut-liter.i Cliente * R}
    else 
        {utp/ut-liter.i Matriz * R}

    display trim(return-value) @ tt-param.gera-base-rat with frame f-parametros4.

&ENDIF

display c-impressao
        c-destino
        tt-param.arquivo        
        tt-param.usuario with frame f-parametros5. 

{include/i-rpclo.i}


Return "OK".
/*fim-do-programa*/

/* ************************************ Procedures Internas ************************************ */

/* ************************************ Procedure Base de Rateio por Cotas ************************************ */
procedure base-rat-cotas:

    /***      PI         ***/
    for each cotas no-lock USE-INDEX periodo
        where cotas.cod-estabel  >= (if l-est-unico then para-ped.estab-padrao else tt-param.cod-estab-ini) 
        and   cotas.cod-estabel  <= (if l-est-unico then para-ped.estab-padrao else tt-param.cod-estab-fim)
        and   cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini 
        and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim 
        and   cotas.dt-inicial   >= tt-param.periodo-ini
        and   cotas.dt-inicial   <= tt-param.periodo-fim:


        run pi-acompanhar in h-acomp (input cotas.cd-produto).

        find par-cota where 
             par-cota.cod-estabel = cotas.cod-estabel no-lock no-error.
        if not avail par-cota then next.
        &IF '{&bf_dis_versao_ems}' >= '2.04' &THEN
            IF NOT AVAIL repres OR
                         repres.cod-rep <> cotas.cod-rep THEN
                FOR FIRST repres FIELDS( cod-rep
                                         &if '{&bf_dis_versao_ems}' >= '2.06' 
                                             &THEN log-consid-repres-cotas
                                             &ELSE char-1
                                         &ENDIF ) NO-LOCK
                    WHERE repres.cod-rep = cotas.cod-rep:
                END.
        &ENDIF
        assign l-niveis = no.
        &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
           if  par-cota.log-impl-niveis = yes then do:
               &IF '{&bf_dis_versao_ems}' >= '2.04' &THEN
                   /* N∆o est† sendo tratada a redistribuiá∆o de percentuais
                      quando implantaá∆o for com n°veis, conforme engenharia
                      ~\~\itaguacu~\Pastahst~\Ems20~\Logistics Solutions~\Produto 
                      Padr∆o~\2003~\Engenharias de OS~\Vendas~\Eng_Rateio_Cotas.doc */
                   IF AVAIL repres AND
                      &if '{&bf_dis_versao_ems}' >= '2.06' &THEN 
                         repres.log-consid-repres-cotas = NO 
                      &ELSE 
                         substr(repres.char-1,1,1) = "1" 
                      &ENDIF
                   THEN NEXT.
               &ENDIF
               assign l-niveis = yes.
               if  cotas.cod-rep <> ? then do:
                   assign i-cod-canal-venda = cotas.cod-canal-venda
                          i-cod-gr-cli = cotas.cod-gr-cli
                          c-nome-abrev = cotas.nome-abrev
                          c-nome-ab-reg = cotas.nome-ab-reg
                          c-nome-mic-reg = cotas.nome-mic-reg.
               end.
               else do:
                   if  cotas.nome-mic-reg <> ? and
                       par-cota.cont-mic-reg then do:
                       assign i-cod-canal-venda = cotas.cod-canal-venda
                              i-cod-gr-cli = cotas.cod-gr-cli
                              c-nome-abrev = cotas.nome-abrev
                              c-nome-ab-reg = cotas.nome-ab-reg
                              c-nome-mic-reg = ?.
                   end.
                   else do:
                       if  cotas.nome-ab-reg <> ? and
                           par-cota.cont-ab-reg then do:
                           assign i-cod-canal-venda = cotas.cod-canal-venda
                                  i-cod-gr-cli = cotas.cod-gr-cli
                                  c-nome-abrev = cotas.nome-abrev
                                  c-nome-ab-reg = ?
                                  c-nome-mic-reg = (if par-cota.cont-mic-reg then ? else "").
                       end.
                       else do:
                           if  cotas.nome-abrev <> ? and
                               par-cota.cont-cliente then do:
                               assign i-cod-canal-venda = cotas.cod-canal-venda
                                      i-cod-gr-cli = cotas.cod-gr-cli
                                      c-nome-abrev = ?
                                      c-nome-ab-reg = (if par-cota.cont-ab-reg then ? else "")
                                      c-nome-mic-reg = (if par-cota.cont-mic-reg then ? else "").
                           end.
                           else do:
                               if  cotas.cod-gr-cli <> ? and
                                   par-cota.cont-gr-cli then do:
                                   assign i-cod-canal-venda = cotas.cod-canal-venda
                                          i-cod-gr-cli = ?
                                          c-nome-abrev = (if par-cota.cont-cliente then ? else "")
                                          c-nome-ab-reg = (if par-cota.cont-ab-reg then ? else "")
                                          c-nome-mic-reg = (if par-cota.cont-mic-reg then ? else "").
                               end.
                               else do:
                                   assign i-cod-canal-venda = ?
                                          i-cod-gr-cli = (if par-cota.cont-gr-cli then ? else 0)
                                          c-nome-abrev = (if par-cota.cont-cliente then ? else "")
                                          c-nome-ab-reg = (if par-cota.cont-ab-reg then ? else "")
                                          c-nome-mic-reg = (if par-cota.cont-mic-reg then ? else "").
                               end.
                           end.
                       end.
                   end.
               end.
               find tt-base-cota where
                    tt-base-cota.cod-estabel = cotas.cod-estabel and
                    tt-base-cota.cod-canal-venda = i-cod-canal-venda and
                    tt-base-cota.cod-gr-cli = i-cod-gr-cli and
                    tt-base-cota.nome-abrev = c-nome-abrev and
                    tt-base-cota.nome-ab-reg = c-nome-ab-reg and
                    tt-base-cota.nome-mic-reg = c-nome-mic-reg and
                    tt-base-cota.cd-produto = cotas.cd-produto
                    no-error.
               if  not avail tt-base-cota then do:
                   create tt-base-cota.
                   assign tt-base-cota.cod-estabel = cotas.cod-estabel 
                          tt-base-cota.cod-canal-venda = i-cod-canal-venda
                          tt-base-cota.cod-gr-cli = i-cod-gr-cli
                          tt-base-cota.nome-abrev = c-nome-abrev 
                          tt-base-cota.nome-ab-reg = c-nome-ab-reg 
                          tt-base-cota.nome-mic-reg = c-nome-mic-reg 
                          tt-base-cota.cd-produto = cotas.cd-produto.
               end.
           end.
        &ENDIF
        if  l-niveis = no then do:
            find tt-base-cota 
                 where tt-base-cota.cd-produto = cotas.cd-produto no-error.
            if not avail tt-base-cota then do:
               create tt-base-cota.
               assign tt-base-cota.cd-produto = cotas.cd-produto. 
            end.
        end.

        if par-cota.tipo-controle = 2 then /*controle por valor*/        
           assign  tt-base-cota.quantidade  = tt-base-cota.quantidade + cotas.vl-previsto.
        else /*controle por qtde/pontos*/
           assign  tt-base-cota.quantidade  = tt-base-cota.quantidade + cotas.qt-prevista.

        &IF '{&bf_dis_versao_ems}' >= '2.04' &THEN
           IF AVAIL repres AND
              &if '{&bf_dis_versao_ems}' >= '2.06' &THEN 
                 repres.log-consid-repres-cotas = NO 
              &ELSE 
                 substr(repres.char-1,1,1) = "1" 
              &ENDIF
           THEN DO: 
              /* N∆o considera representante para rateio de cotas */
              {acp/ac1001.i1 tt-base-rat-nao-consid}
           END.
           ELSE DO:
              /* Considera representante para rateio de cotas */
              {acp/ac1001.i1 tt-base-rat}
           END.
        &ELSE
            {acp/ac1001.i1 tt-base-rat}
        &ENDIF
    end.        
end procedure.

/* ************************************ Procedure Base de Rateio por Pedidos ************************************ */

procedure base-rat-pedidos:

for each  ped-venda fields(cod-sit-ped cod-sit-com nr-pedcli cod-estabel dt-emissao cod-emitente 
                           no-ab-reppri nome-abrev cod-canal-venda cod-gr-cli) no-lock
          USE-INDEX ch-implant
    where ped-venda.dt-implant >= tt-param.ped-ini and
          ped-venda.dt-implant <= tt-param.ped-fim and
          ped-venda.cod-estabel >= tt-param.cod-estab-ini and
          ped-venda.cod-estabel <= tt-param.cod-estab-fim and
          ped-venda.cod-canal-venda >= tt-param.cod-canal-venda-ini and
          ped-venda.cod-canal-venda <= tt-param.cod-canal-venda-fim and  
          ped-venda.cod-sit-ped <> 6 and
          ped-venda.cod-sit-com <> 3:

    run pi-acompanhar in h-acomp (input ped-venda.nr-pedcli).

    if substring(para-ped.char-2, 1, 3) = "yes" then 
       find par-cota no-lock
            where par-cota.cod-estabel = para-ped.estab-padrao no-error.
    else         
       find par-cota no-lock
            where par-cota.cod-estabel = ped-venda.cod-estabel no-error.
    if not avail par-cota then next. 

   /* quando data de emissao */
   if par-cota.tipo-data = 1 then
      if ped-venda.dt-emissao < tt-param.periodo-ini or
         ped-venda.dt-emissao > tt-param.periodo-fim then 
         next.        

   for first emitente fields(cod-emitente cod-gr-cli nome-abrev nome-mic-reg) no-lock
        where emitente.cod-emitente = ped-venda.cod-emitente.
   end. 
   if not avail emitente then next.

   FOR FIRST repres FIELDS(nome-abrev cod-rep nome-ab-reg
                           &if '{&bf_dis_versao_ems}' >= '2.06' 
                               &THEN log-consid-repres-cotas
                               &ELSE char-1
                           &ENDIF) NO-LOCK
       WHERE repres.nome-abrev = ped-venda.no-ab-reppri.
   END.
   IF NOT AVAIL repres THEN NEXT.

   /* N∆o est† sendo tratada a redistribuiá∆o de percentuais
   quando implantaá∆o for com n°veis, conforme engenharia
   ~\~\itaguacu~\Pastahst~\Ems20~\Logistics Solutions~\Produto 
   Padr∆o~\2003~\Engenharias de OS~\Vendas~\Eng_Rateio_Cotas.doc */
   &IF '{&bf_dis_versao_ems}' >= '2.04' &THEN
       if  par-cota.log-impl-niveis = yes AND
           &if '{&bf_dis_versao_ems}' >= '2.06' &THEN 
               repres.log-consid-repres-cotas = NO 
           &ELSE 
               substr(repres.char-1,1,1) = "1" 
           &ENDIF
       THEN NEXT.
   &ENDIF

   for each ped-item fields(nome-abrev nr-pedcli cod-sit-item cod-sit-com nat-operacao it-codigo
                            dt-entrega vl-preuni qt-pedida vl-liq-it) no-lock
       where ped-item.nome-abrev    = ped-venda.nome-abrev
       and   ped-item.nr-pedcli     = ped-venda.nr-pedcli
       and   ped-item.cod-sit-item <> 6
       and   ped-item.cod-sit-com  <> 3:

       &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
           if not can-find ( first natur-oper where
                                   natur-oper.nat-operacao = ped-item.nat-operacao and
                                   natur-oper.log-atual-cotas = yes) 
              then next.              

       &else
           if not can-find ( first natur-oper where
                                   natur-oper.nat-operacao = ped-item.nat-operacao and
                                   substr(natur-oper.char-2,31,1) = "1") 
              then next.       
       &endif           

       run pi-acompanhar in h-acomp (input ped-item.it-codigo).

       /*quando data de entrega*/
       if par-cota.tipo-data = 2 then
          if ped-item.dt-entrega < tt-param.periodo-ini or
             ped-item.dt-entrega > tt-param.periodo-fim then
             next.

       assign l-log-produto = no.

       /* trata o item. se Ç item padr∆o ou se Ç controlado por produto*/
       if not par-cota.cont-produto then do:
           assign c-it-codigo = par-cota.it-codigo-padrao.
           find item-cota no-lock
                where item-cota.it-codigo = par-cota.it-codigo-padrao no-error.
           if not avail item-cota then next.     
       end.
       else do:
           find item-cota no-lock
                where item-cota.it-codigo = ped-item.it-codigo no-error.
           if avail item-cota then do:
              if item-cota.log-produto and
                 par-cota.cont-produto then do : /*controla por produto*/

                 /************************************************************ 
                 *  PrÇ-Processador para o m¢dulo de Administraá∆o de Cotas
                 ************************************************************/
                 &if defined (bf_dis_adm_cotas) &then
                     find est-prod-coml where est-prod-coml.it-codigo = item-cota.it-codigo no-lock no-error.
                     assign de-quantidade = est-prod-coml.qt-aplicada
                            c-it-codigo   = est-prod-coml.cod-produto-coml
                            l-log-produto = yes.
                 &else
                     find est-prod where est-prod.it-codigo = item-cota.it-codigo no-lock no-error.
                     assign de-quantidade = est-prod.qt-aplicada
                            c-it-codigo   = est-prod.cd-produto
                            l-log-produto = yes.
                 &endif
              end.
              else    
                 assign c-it-codigo   = item-cota.it-codigo.  
           end.
           else /*se n∆o existir item-cota*/ 
               next.
       end.

       run grava-temp-tables.
   end.
end.

end procedure.

/* ************************************ Procedure Base de Rateio por Faturado ************************************ */

procedure base-rat-faturados:

    for each  nota-fiscal fields(dt-emis-nota dt-cancela nr-nota-fis cod-estabel cod-emitente
                                 no-ab-reppri serie cod-canal-venda nome-ab-reg) use-index ch-sit-nota no-lock
        where nota-fiscal.cod-estabel >= tt-param.cod-estab-ini 
        and   nota-fiscal.cod-estabel <= tt-param.cod-estab-fim
        and   nota-fiscal.cod-canal-venda >= tt-param.cod-canal-venda-ini 
        and   nota-fiscal.cod-canal-venda <= tt-param.cod-canal-venda-fim
        and   nota-fiscal.dt-emis-nota >= tt-param.periodo-ini
        and   nota-fiscal.dt-emis-nota <= tt-param.periodo-fim
        and   nota-fiscal.dt-cancela    = ?:

        run pi-acompanhar in h-acomp (input nota-fiscal.nr-nota-fis).

        if substring(para-ped.char-2, 1, 3) = "yes" then 
           find par-cota no-lock
                where par-cota.cod-estabel = para-ped.estab-padrao no-error.
        else         
           find par-cota no-lock
                where par-cota.cod-estabel = nota-fiscal.cod-estabel no-error.
        if not avail par-cota then next. 

        for first emitente fields (cod-emitente cod-gr-cli nome-abrev nome-mic-reg) no-lock
            where emitente.cod-emitente = nota-fiscal.cod-emitente.
        end. 
        if not avail emitente then next.

        FOR FIRST repres FIELDS(nome-abrev cod-rep nome-ab-reg
                                &if '{&bf_dis_versao_ems}' >= '2.06' 
                                    &THEN log-consid-repres-cotas
                                    &ELSE char-1
                                &ENDIF) NO-LOCK
            WHERE repres.nome-abrev = nota-fiscal.no-ab-reppri.
        END.
        IF NOT AVAIL repres THEN NEXT.

        /* N∆o est† sendo tratada a redistribuiá∆o de percentuais
        quando implantaá∆o for com n°veis, conforme engenharia
        ~\~\itaguacu~\Pastahst~\Ems20~\Logistics Solutions~\Produto 
        Padr∆o~\2003~\Engenharias de OS~\Vendas~\Eng_Rateio_Cotas.doc */
        &IF '{&bf_dis_versao_ems}' >= '2.04' &THEN
            if  par-cota.log-impl-niveis = yes AND
                &if '{&bf_dis_versao_ems}' >= '2.06' &THEN 
                    repres.log-consid-repres-cotas = NO 
                &ELSE 
                    substr(repres.char-1,1,1) = "1" 
                &ENDIF
            THEN NEXT.
        &ENDIF

        for each  it-nota-fisc FIELDS(cod-estabel serie nr-nota-fis dt-cancela nat-operacao vl-preuni
                                      qt-faturada[1] vl-merc-sicm nr-seq-fat it-codigo)
            where it-nota-fisc.cod-estabel  = nota-fiscal.cod-estabel
            and   it-nota-fisc.serie        = nota-fiscal.serie
            and   it-nota-fisc.nr-nota-fis  = nota-fiscal.nr-nota-fis 
            and   it-nota-fisc.dt-cancela   = ? no-lock:

            &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
                if not can-find ( first natur-oper where
                                        natur-oper.nat-operacao = it-nota-fisc.nat-operacao and
                                        natur-oper.log-atual-cotas = yes ) 
                   then next.
            &else
                if not can-find ( first natur-oper where
                                        natur-oper.nat-operacao = it-nota-fisc.nat-operacao and
                                        substr(natur-oper.char-2,31,1) = "1") 
                   then next.
            &endif


                run pi-acompanhar in h-acomp (input it-nota-fisc.it-codigo).

                assign l-log-produto = no.
                /* trata o item. se Ç item padr∆o ou se Ç controlado por produto*/
                if not par-cota.cont-produto then do:
                    assign c-it-codigo = par-cota.it-codigo-padrao.
                    find item-cota no-lock
                         where item-cota.it-codigo = par-cota.it-codigo-padrao no-error.
                    if not avail item-cota then next.     
                end.
                else do:
                    find item-cota no-lock
                         where item-cota.it-codigo = it-nota-fisc.it-codigo no-error.
                    if avail item-cota then do:
                       if item-cota.log-produto and
                          par-cota.cont-produto then do : /*controla por produto*/

                          /************************************************************ 
                          *  PrÇ-Processador para o m¢dulo de Administraá∆o de Cotas
                          ************************************************************/
                          &if defined (bf_dis_adm_cotas) &then
                              find est-prod-coml where est-prod-coml.it-codigo = item-cota.it-codigo no-lock no-error.
                              assign de-quantidade = est-prod-coml.qt-aplicada
                                     c-it-codigo   = est-prod-coml.cod-produto-coml
                                     l-log-produto = yes.
                          &else
                              find est-prod where est-prod.it-codigo = item-cota.it-codigo no-lock no-error.
                              assign de-quantidade = est-prod.qt-aplicada
                                     c-it-codigo   = est-prod.cd-produto
                                     l-log-produto = yes.
                          &endif
                       end.
                       else    
                          assign c-it-codigo   = item-cota.it-codigo.  
                    end.
                    else /*se n∆o existir item-cota*/ 
                        next.
                end.

                if par-cota.tipo-controle = 2 then do: /*controla por valor*/
                  /* calcula valor bruto ou liquido*/            
                    if par-cota.tipo-valor = 1 then 
                       assign de-valor-aux = it-nota-fisc.vl-preuni * it-nota-fisc.qt-faturada[1]. 
                    else
                       assign de-valor-aux = it-nota-fisc.vl-merc-sicm.
                end. 
                else /*controla por pontos ou quantidade*/
                     assign de-valor-aux = it-nota-fisc.qt-faturada[1] * if par-cota.tipo-controle = 3 then item-cota.nr-pontos else 1.   

                /**** Desconsidera as Devoluá‰es de notas fiscais *****/
                for first devol-cli fields(qt-devolvida) where
                          devol-cli.cod-estabel = it-nota-fisc.cod-estabel and                 
                          devol-cli.serie = it-nota-fisc.serie and
                          devol-cli.nr-nota-fis = it-nota-fisc.nr-nota-fis and
                          devol-cli.nr-sequencia = it-nota-fisc.nr-seq-fat and
                          devol-cli.it-codigo = it-nota-fisc.it-codigo no-lock :

                    assign de-vl-devol-liq = (it-nota-fisc.vl-merc-sicm * devol-cli.qt-devolvida / it-nota-fisc.qt-faturada[1])  
                           de-vl-devol-bru = ((it-nota-fisc.vl-preuni * it-nota-fisc.qt-faturada[1])  * devol-cli.qt-devolvida / it-nota-fisc.qt-faturada[1])
                           de-quant-devol  = devol-cli.qt-devolvida.
                    if par-cota.tipo-controle = 2 then do: /*controla por valor*/
                       /*calcula valor bruto ou liquido*/            
                       if par-cota.tipo-valor = 1 then 
                          assign de-valor-aux = de-valor-aux - de-vl-devol-bru.
                       else
                          assign de-valor-aux = de-valor-aux - de-vl-devol-liq.
                    end. 
                    else /*controla por pontos ou quantidade*/
                       assign de-quant-devol = de-quant-devol * (if par-cota.tipo-controle = 3 then item-cota.nr-pontos else 1)
                              de-valor-aux = de-valor-aux - de-quant-devol.
                end. 
                /**** Fim tratamento Devoluá‰es de notas fiscais *****/                


                &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR 2.03*/
                    /* caso seja controlado por produto 2.03 multiplica*/  
                    if l-log-produto then
                       assign de-valor-aux = de-valor-aux * de-quantidade.
                &ELSE
                    /* caso seja controlado por produto  2.02 divide*/  
                    if l-log-produto then
                       assign de-valor-aux = de-valor-aux / de-quantidade.
                &ENDIF

                assign l-niveis = no.


                &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */

                   if  par-cota.log-impl-niveis = yes then do:
                       assign l-niveis = yes.
                                                  /* Estabelecimento */
                       find tt-base-cota where
                            tt-base-cota.cod-estabel = par-cota.cod-estabel and
                            tt-base-cota.cod-canal-venda  = (if par-cota.cont-canal-venda then ? else 0) and
                            tt-base-cota.cod-gr-cli = (if par-cota.cont-gr-cli then ? else 0) and
                            tt-base-cota.nome-abrev = (if par-cota.cont-cliente then ? else "") and
                            tt-base-cota.nome-ab-reg = (if par-cota.cont-ab-reg then ? else "") and
                            tt-base-cota.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") and
                            tt-base-cota.cd-produto = c-it-codigo
                            no-error.                          
                       if not avail tt-base-cota then do:
                          create tt-base-cota.
                          assign tt-base-cota.cod-estabel = par-cota.cod-estabel 
                                 tt-base-cota.cod-canal-venda  = (if par-cota.cont-canal-venda then ? else 0) 
                                 tt-base-cota.cod-gr-cli = (if par-cota.cont-gr-cli then ? else 0) 
                                 tt-base-cota.nome-abrev = (if par-cota.cont-cliente then ? else "") 
                                 tt-base-cota.nome-ab-reg = (if par-cota.cont-ab-reg then ? else "") 
                                 tt-base-cota.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "")
                                 tt-base-cota.cd-produto = c-it-codigo.
                       end.
                       assign tt-base-cota.quantidade = tt-base-cota.quantidade + de-valor-aux.
                       if  par-cota.cont-canal-venda then do:
                           find tt-base-cota where
                                tt-base-cota.cod-estabel = par-cota.cod-estabel and
                                tt-base-cota.cod-canal-venda  = nota-fiscal.cod-canal-venda and
                                tt-base-cota.cod-gr-cli = (if par-cota.cont-gr-cli then ? else 0) and
                                tt-base-cota.nome-abrev = (if par-cota.cont-cliente then ? else "") and
                                tt-base-cota.nome-ab-reg = (if par-cota.cont-ab-reg then ? else "") and
                                tt-base-cota.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") and
                                tt-base-cota.cd-produto = c-it-codigo
                                no-error.                          
                             if not avail tt-base-cota then do:
                                create tt-base-cota.
                                assign tt-base-cota.cod-estabel = par-cota.cod-estabel 
                                       tt-base-cota.cod-canal-venda  = nota-fiscal.cod-canal-venda 
                                       tt-base-cota.cod-gr-cli = (if par-cota.cont-gr-cli then ? else 0) 
                                       tt-base-cota.nome-abrev = (if par-cota.cont-cliente then ? else "") 
                                       tt-base-cota.nome-ab-reg = (if par-cota.cont-ab-reg then ? else "") 
                                       tt-base-cota.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") 
                                       tt-base-cota.cd-produto = c-it-codigo.
                             end.
                             assign tt-base-cota.quantidade = tt-base-cota.quantidade + de-valor-aux.
                       end.
                       if  par-cota.cont-gr-cli then do:
                           find tt-base-cota where
                                tt-base-cota.cod-estabel = par-cota.cod-estabel and
                                tt-base-cota.cod-canal-venda  = (if par-cota.cont-canal-venda then nota-fiscal.cod-canal-venda else 0) and
                                tt-base-cota.cod-gr-cli = emitente.cod-gr-cli and
                                tt-base-cota.nome-abrev = (if par-cota.cont-cliente then ? else "") and
                                tt-base-cota.nome-ab-reg = (if par-cota.cont-ab-reg then ? else "") and
                                tt-base-cota.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") and
                                tt-base-cota.cd-produto = c-it-codigo
                                no-error.                          
                             if not avail tt-base-cota then do:
                                create tt-base-cota.
                                assign tt-base-cota.cod-estabel = par-cota.cod-estabel 
                                       tt-base-cota.cod-canal-venda  = (if par-cota.cont-canal-venda then nota-fiscal.cod-canal-venda else 0) 
                                       tt-base-cota.cod-gr-cli = emitente.cod-gr-cli 
                                       tt-base-cota.nome-abrev = (if par-cota.cont-cliente then ? else "") 
                                       tt-base-cota.nome-ab-reg = (if par-cota.cont-ab-reg then ? else "") 
                                       tt-base-cota.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") 
                                       tt-base-cota.cd-produto = c-it-codigo.
                             end.
                             assign tt-base-cota.quantidade = tt-base-cota.quantidade + de-valor-aux.
                       end. 
                       if  par-cota.cont-cliente then do:
                           find tt-base-cota where
                                tt-base-cota.cod-estabel = par-cota.cod-estabel and
                                tt-base-cota.cod-canal-venda  = (if par-cota.cont-canal-venda then nota-fiscal.cod-canal-venda else 0) and
                                tt-base-cota.cod-gr-cli = (if par-cota.cont-gr-cli then emitente.cod-gr-cli else 0) and
                                tt-base-cota.nome-abrev = emitente.nome-abrev and
                                tt-base-cota.nome-ab-reg = (if par-cota.cont-ab-reg then ? else "") and
                                tt-base-cota.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") and
                                tt-base-cota.cd-produto = c-it-codigo
                                no-error.                          
                             if not avail tt-base-cota then do:
                                create tt-base-cota.
                                assign tt-base-cota.cod-estabel = par-cota.cod-estabel 
                                       tt-base-cota.cod-canal-venda  = (if par-cota.cont-canal-venda then nota-fiscal.cod-canal-venda else 0) 
                                       tt-base-cota.cod-gr-cli = (if par-cota.cont-gr-cli then emitente.cod-gr-cli else 0) 
                                       tt-base-cota.nome-abrev = emitente.nome-abrev 
                                       tt-base-cota.nome-ab-reg = (if par-cota.cont-ab-reg then ? else "") 
                                       tt-base-cota.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") 
                                       tt-base-cota.cd-produto = c-it-codigo.
                             end.
                             assign tt-base-cota.quantidade = tt-base-cota.quantidade + de-valor-aux.
                       end. 
                       if  par-cota.cont-ab-reg then do:
                           find tt-base-cota where
                                tt-base-cota.cod-estabel = par-cota.cod-estabel and
                                tt-base-cota.cod-canal-venda  = (if par-cota.cont-canal-venda then nota-fiscal.cod-canal-venda else 0) and
                                tt-base-cota.cod-gr-cli = (if par-cota.cont-gr-cli then emitente.cod-gr-cli else 0) and
                                tt-base-cota.nome-abrev = (if par-cota.cont-cliente then emitente.nome-abrev else "") and
                                tt-base-cota.nome-ab-reg = nota-fiscal.nome-ab-reg and
                                tt-base-cota.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") and
                                tt-base-cota.cd-produto = c-it-codigo
                                no-error.                          
                             if not avail tt-base-cota then do:
                                create tt-base-cota.
                                assign tt-base-cota.cod-estabel = par-cota.cod-estabel 
                                       tt-base-cota.cod-canal-venda  = (if par-cota.cont-canal-venda then nota-fiscal.cod-canal-venda else 0) 
                                       tt-base-cota.cod-gr-cli = (if par-cota.cont-gr-cli then emitente.cod-gr-cli else 0) 
                                       tt-base-cota.nome-abrev = (if par-cota.cont-cliente then emitente.nome-abrev else "") 
                                       tt-base-cota.nome-ab-reg = nota-fiscal.nome-ab-reg 
                                       tt-base-cota.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") 
                                       tt-base-cota.cd-produto = c-it-codigo.
                             end.
                             assign tt-base-cota.quantidade = tt-base-cota.quantidade + de-valor-aux.
                       end.
                       if  par-cota.cont-mic-reg then do:
                           find tt-base-cota where
                                tt-base-cota.cod-estabel = par-cota.cod-estabel and
                                tt-base-cota.cod-canal-venda  = (if par-cota.cont-canal-venda then nota-fiscal.cod-canal-venda else 0) and
                                tt-base-cota.cod-gr-cli = (if par-cota.cont-gr-cli then emitente.cod-gr-cli else 0) and
                                tt-base-cota.nome-abrev = (if par-cota.cont-cliente then emitente.nome-abrev else "") and
                                tt-base-cota.nome-ab-reg = (if par-cota.cont-ab-reg then nota-fiscal.nome-ab-reg else "") and
                                tt-base-cota.nome-mic-reg = emitente.nome-mic-reg and
                                tt-base-cota.cd-produto = c-it-codigo
                                no-error.                          
                           if not avail tt-base-cota then do:
                              create tt-base-cota.
                              assign tt-base-cota.cod-estabel = par-cota.cod-estabel 
                                     tt-base-cota.cod-canal-venda  = (if par-cota.cont-canal-venda then nota-fiscal.cod-canal-venda else 0) 
                                     tt-base-cota.cod-gr-cli = (if par-cota.cont-gr-cli then emitente.cod-gr-cli else 0) 
                                     tt-base-cota.nome-abrev = (if par-cota.cont-cliente then emitente.nome-abrev else "") 
                                     tt-base-cota.nome-ab-reg = (if par-cota.cont-ab-reg then nota-fiscal.nome-ab-reg else "")
                                     tt-base-cota.nome-mic-reg = emitente.nome-mic-reg 
                                     tt-base-cota.cd-produto = c-it-codigo.
                           end.
                           assign tt-base-cota.quantidade = tt-base-cota.quantidade + de-valor-aux.
                       end.

                       if  par-cota.cont-canal-venda then do:
                           find tt-base-rat
                                where tt-base-rat.cod-estabel     = par-cota.cod-estabel
                                and   tt-base-rat.cod-canal-venda = nota-fiscal.cod-canal-venda 
                                and   tt-base-rat.cod-gr-cli      = (if par-cota.cont-gr-cli then ? else 0)
                                and   tt-base-rat.nome-abrev      = (if par-cota.cont-cliente then ? else "")
                                and   tt-base-rat.nome-ab-reg     = (if par-cota.cont-ab-reg then ? else "")
                                and   tt-base-rat.nome-mic-reg    = (if par-cota.cont-mic-reg then ? else "")
                                and   tt-base-rat.cod-rep         = ?
                                and   tt-base-rat.cd-produto      = c-it-codigo
                                and   tt-base-rat.codigo          = tt-param.codigo
                                no-error.

                           if not avail tt-base-rat then do:
                              create tt-base-rat.
                              assign tt-base-rat.cod-estabel     = par-cota.cod-estabel
                                     tt-base-rat.cod-canal-venda = nota-fiscal.cod-canal-venda 
                                     tt-base-rat.cod-gr-cli      = (if par-cota.cont-gr-cli then ? else 0)
                                     tt-base-rat.nome-abrev      = (if par-cota.cont-cliente then ? else "")
                                     tt-base-rat.nome-ab-reg     = (if par-cota.cont-ab-reg then ? else "")
                                     tt-base-rat.nome-mic-reg    = (if par-cota.cont-mic-reg then ? else "")
                                     tt-base-rat.cod-rep         = ?
                                     tt-base-rat.cd-produto      = c-it-codigo
                                     tt-base-rat.codigo          = tt-param.codigo.
                           end.
                           assign tt-base-rat.quantidade  = tt-base-rat.quantidade + de-valor-aux.
                       end.
                       if  par-cota.cont-gr-cli then do:
                           find tt-base-rat
                                where tt-base-rat.cod-estabel     = par-cota.cod-estabel
                                and   tt-base-rat.cod-canal-venda = (if par-cota.cont-canal-venda then nota-fiscal.cod-canal-venda else 0) 
                                and   tt-base-rat.cod-gr-cli      = emitente.cod-gr-cli
                                and   tt-base-rat.nome-abrev      = (if par-cota.cont-cliente then ? else "")
                                and   tt-base-rat.nome-ab-reg     = (if par-cota.cont-ab-reg then ? else "")
                                and   tt-base-rat.nome-mic-reg    = (if par-cota.cont-mic-reg then ? else "")
                                and   tt-base-rat.cod-rep         = ?
                                and   tt-base-rat.cd-produto      = c-it-codigo
                                and   tt-base-rat.codigo          = tt-param.codigo
                                no-error.

                           if not avail tt-base-rat then do:
                              create tt-base-rat.
                              assign tt-base-rat.cod-estabel     = par-cota.cod-estabel
                                     tt-base-rat.cod-canal-venda = (if par-cota.cont-canal-venda then nota-fiscal.cod-canal-venda else 0)
                                     tt-base-rat.cod-gr-cli      = emitente.cod-gr-cli
                                     tt-base-rat.nome-abrev      = (if par-cota.cont-cliente then ? else "")
                                     tt-base-rat.nome-ab-reg     = (if par-cota.cont-ab-reg then ? else "")
                                     tt-base-rat.nome-mic-reg    = (if par-cota.cont-mic-reg then ? else "")
                                     tt-base-rat.cod-rep         = ?
                                     tt-base-rat.cd-produto      = c-it-codigo
                                     tt-base-rat.codigo          = tt-param.codigo.
                           end.
                           assign tt-base-rat.quantidade  = tt-base-rat.quantidade + de-valor-aux.
                       end.
                       if  par-cota.cont-cliente then do:
                           find tt-base-rat
                                where tt-base-rat.cod-estabel     = par-cota.cod-estabel
                                and   tt-base-rat.cod-canal-venda = (if par-cota.cont-canal-venda then nota-fiscal.cod-canal-venda else 0) 
                                and   tt-base-rat.cod-gr-cli      = (if par-cota.cont-gr-cli then emitente.cod-gr-cli else 0)
                                and   tt-base-rat.nome-abrev      = emitente.nome-abrev
                                and   tt-base-rat.nome-ab-reg     = (if par-cota.cont-ab-reg then ? else "")
                                and   tt-base-rat.nome-mic-reg    = (if par-cota.cont-mic-reg then ? else "")
                                and   tt-base-rat.cod-rep         = ?
                                and   tt-base-rat.cd-produto      = c-it-codigo
                                and   tt-base-rat.codigo          = tt-param.codigo
                                no-error.

                           if not avail tt-base-rat then do:
                              create tt-base-rat.
                              assign tt-base-rat.cod-estabel     = par-cota.cod-estabel
                                     tt-base-rat.cod-canal-venda = (if par-cota.cont-canal-venda then nota-fiscal.cod-canal-venda else 0)
                                     tt-base-rat.cod-gr-cli      = (if par-cota.cont-gr-cli then emitente.cod-gr-cli else 0)
                                     tt-base-rat.nome-abrev      = emitente.nome-abrev
                                     tt-base-rat.nome-ab-reg     = (if par-cota.cont-ab-reg then ? else "")
                                     tt-base-rat.nome-mic-reg    = (if par-cota.cont-mic-reg then ? else "")
                                     tt-base-rat.cod-rep         = ?
                                     tt-base-rat.cd-produto      = c-it-codigo
                                     tt-base-rat.codigo          = tt-param.codigo.
                           end.
                           assign tt-base-rat.quantidade  = tt-base-rat.quantidade + de-valor-aux.
                       end.
                       if  par-cota.cont-ab-reg then do:
                           find tt-base-rat
                                where tt-base-rat.cod-estabel     = par-cota.cod-estabel
                                and   tt-base-rat.cod-canal-venda = (if par-cota.cont-canal-venda then nota-fiscal.cod-canal-venda else 0) 
                                and   tt-base-rat.cod-gr-cli      = (if par-cota.cont-gr-cli then emitente.cod-gr-cli else 0)
                                and   tt-base-rat.nome-abrev      = (if par-cota.cont-cliente then emitente.nome-abrev else "")
                                and   tt-base-rat.nome-ab-reg     = nota-fiscal.nome-ab-reg
                                and   tt-base-rat.nome-mic-reg    = (if par-cota.cont-mic-reg then ? else "")
                                and   tt-base-rat.cod-rep         = ?
                                and   tt-base-rat.cd-produto      = c-it-codigo
                                and   tt-base-rat.codigo          = tt-param.codigo
                                no-error.

                           if not avail tt-base-rat then do:
                              create tt-base-rat.
                              assign tt-base-rat.cod-estabel     = par-cota.cod-estabel
                                     tt-base-rat.cod-canal-venda = (if par-cota.cont-canal-venda then nota-fiscal.cod-canal-venda else 0)
                                     tt-base-rat.cod-gr-cli      = (if par-cota.cont-gr-cli then emitente.cod-gr-cli else 0)
                                     tt-base-rat.nome-abrev      = (if par-cota.cont-cliente then emitente.nome-abrev else "")
                                     tt-base-rat.nome-ab-reg     = nota-fiscal.nome-ab-reg
                                     tt-base-rat.nome-mic-reg    = (if par-cota.cont-mic-reg then ? else "")
                                     tt-base-rat.cod-rep         = ?
                                     tt-base-rat.cd-produto      = c-it-codigo
                                     tt-base-rat.codigo          = tt-param.codigo.
                           end.
                           assign tt-base-rat.quantidade  = tt-base-rat.quantidade + de-valor-aux.
                       end.
                       if  par-cota.cont-mic-reg then do:
                           find tt-base-rat
                                where tt-base-rat.cod-estabel     = par-cota.cod-estabel
                                and   tt-base-rat.cod-canal-venda = (if par-cota.cont-canal-venda then nota-fiscal.cod-canal-venda else 0) 
                                and   tt-base-rat.cod-gr-cli      = (if par-cota.cont-gr-cli then emitente.cod-gr-cli else 0)
                                and   tt-base-rat.nome-abrev      = (if par-cota.cont-cliente then emitente.nome-abrev else "")
                                and   tt-base-rat.nome-ab-reg     = (if par-cota.cont-ab-reg then nota-fiscal.nome-ab-reg else "")
                                and   tt-base-rat.nome-mic-reg    = emitente.nome-mic-reg
                                and   tt-base-rat.cod-rep         = ?
                                and   tt-base-rat.cd-produto      = c-it-codigo
                                and   tt-base-rat.codigo          = tt-param.codigo
                                no-error.

                           if not avail tt-base-rat then do:
                              create tt-base-rat.
                              assign tt-base-rat.cod-estabel     = par-cota.cod-estabel
                                     tt-base-rat.cod-canal-venda = (if par-cota.cont-canal-venda then nota-fiscal.cod-canal-venda else 0)
                                     tt-base-rat.cod-gr-cli      = (if par-cota.cont-gr-cli then emitente.cod-gr-cli else 0)
                                     tt-base-rat.nome-abrev      = (if par-cota.cont-cliente then emitente.nome-abrev else "")
                                     tt-base-rat.nome-ab-reg     = (if par-cota.cont-ab-reg then nota-fiscal.nome-ab-reg else "")
                                     tt-base-rat.nome-mic-reg    = emitente.nome-mic-reg
                                     tt-base-rat.cod-rep         = ?
                                     tt-base-rat.cd-produto      = c-it-codigo
                                     tt-base-rat.codigo          = tt-param.codigo.
                           end.
                           assign tt-base-rat.quantidade  = tt-base-rat.quantidade + de-valor-aux.
                       end.

                       find tt-base-rat
                            where tt-base-rat.cod-estabel     = par-cota.cod-estabel
                            and   tt-base-rat.cod-canal-venda = (if par-cota.cont-canal-venda then nota-fiscal.cod-canal-venda else 0) 
                            and   tt-base-rat.cod-gr-cli      = (if par-cota.cont-gr-cli then emitente.cod-gr-cli else 0)
                            and   tt-base-rat.nome-abrev      = (if par-cota.cont-cliente then emitente.nome-abrev else "")
                            and   tt-base-rat.nome-ab-reg     = (if par-cota.cont-ab-reg then nota-fiscal.nome-ab-reg else "")
                            and   tt-base-rat.nome-mic-reg    = (if par-cota.cont-mic-reg then emitente.nome-mic-reg else "")
                            and   tt-base-rat.cod-rep         = repres.cod-rep
                            and   tt-base-rat.cd-produto      = c-it-codigo
                            and   tt-base-rat.codigo          = tt-param.codigo
                            no-error.

                       if not avail tt-base-rat then do:
                          create tt-base-rat.
                          assign tt-base-rat.cod-estabel     = par-cota.cod-estabel
                                 tt-base-rat.cod-canal-venda = (if par-cota.cont-canal-venda then nota-fiscal.cod-canal-venda else 0)
                                 tt-base-rat.cod-gr-cli      = (if par-cota.cont-gr-cli then emitente.cod-gr-cli else 0)
                                 tt-base-rat.nome-abrev      = (if par-cota.cont-cliente then emitente.nome-abrev else "")
                                 tt-base-rat.nome-ab-reg     = (if par-cota.cont-ab-reg then nota-fiscal.nome-ab-reg else "")
                                 tt-base-rat.nome-mic-reg    = (if par-cota.cont-mic-reg then emitente.nome-mic-reg else "")
                                 tt-base-rat.cod-rep         = repres.cod-rep
                                 tt-base-rat.cd-produto      = c-it-codigo
                                 tt-base-rat.codigo          = tt-param.codigo.
                       end.
                       assign tt-base-rat.quantidade  = tt-base-rat.quantidade + de-valor-aux.
                   end.    
                &ENDIF   
                if  l-niveis = no then do:   
                    find tt-base-cota 
                         where tt-base-cota.cd-produto = c-it-codigo no-error.
                    if not avail tt-base-cota then do:
                       create tt-base-cota.
                       assign tt-base-cota.cd-produto = c-it-codigo
                              tt-base-cota.quantidade = de-valor-aux.
                    end.
                    else
                       assign tt-base-cota.quantidade = tt-base-cota.quantidade + de-valor-aux.

                    &IF '{&bf_dis_versao_ems}' >= '2.04' &THEN
                       IF &if '{&bf_dis_versao_ems}' >= '2.06' &THEN 
                             repres.log-consid-repres-cotas = NO 
                          &ELSE 
                             substr(repres.char-1,1,1) = "1" 
                          &ENDIF
                       THEN DO: 
                          /* N∆o considera representante para rateio de cotas */
                          {acp/ac1001.i3 tt-base-rat-nao-consid}
                       END.
                       ELSE DO:
                          /* Considera representante para rateio de cotas */
                          {acp/ac1001.i3 tt-base-rat}
                       END.
                    &ELSE
                        {acp/ac1001.i3 tt-base-rat}
                    &ENDIF
                end.
        end.  /*for each it-nota-fisc*/
    end. /* for each nota-fiscal*/
end procedure.

/* ************************************ Procedure Grava Tabelas Tempor†rias ************************************ */
procedure grava-temp-tables:

    if par-cota.tipo-controle = 2 then do: /*controla por valor*/
        /* calcula valor bruto ou liquido*/            
        if par-cota.tipo-valor = 1 then
           assign de-valor-aux = ped-item.vl-preuni * ped-item.qt-pedida. 
        else   
           assign de-valor-aux = ped-item.vl-liq-it * ped-item.qt-pedida. 
    end.
    else /*controla por pontos ou quantidade*/
        assign de-valor-aux = ped-item.qt-pedida * if par-cota.tipo-controle = 3 then item-cota.nr-pontos else 1. 

    &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR 2.03*/
        /* caso seja controlado por produto - multiplica */  
        if l-log-produto then
           assign de-valor-aux = de-valor-aux * de-quantidade.
    &ELSE
        /* caso seja controlado por produto - divide */  
        if l-log-produto then
           assign de-valor-aux = de-valor-aux / de-quantidade.
    &ENDIF

    assign l-niveis = no.
    &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
        if  par-cota.log-impl-niveis = yes then do:
            assign l-niveis = yes.
                                       /* Estabelecimento */
            find tt-base-cota where
                 tt-base-cota.cod-estabel = par-cota.cod-estabel and
                 tt-base-cota.cod-canal-venda  = (if par-cota.cont-canal-venda then ? else 0) and
                 tt-base-cota.cod-gr-cli = (if par-cota.cont-gr-cli then ? else 0) and
                 tt-base-cota.nome-abrev = (if par-cota.cont-cliente then ? else "") and
                 tt-base-cota.nome-ab-reg = (if par-cota.cont-ab-reg then ? else "") and
                 tt-base-cota.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") and
                 tt-base-cota.cd-produto = c-it-codigo
                 no-error.                          
            if not avail tt-base-cota then do:
               create tt-base-cota.
               assign tt-base-cota.cod-estabel = par-cota.cod-estabel 
                      tt-base-cota.cod-canal-venda  = (if par-cota.cont-canal-venda then ? else 0) 
                      tt-base-cota.cod-gr-cli = (if par-cota.cont-gr-cli then ? else 0) 
                      tt-base-cota.nome-abrev = (if par-cota.cont-cliente then ? else "") 
                      tt-base-cota.nome-ab-reg = (if par-cota.cont-ab-reg then ? else "") 
                      tt-base-cota.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") 
                      tt-base-cota.cd-produto = c-it-codigo.
            end.
            assign tt-base-cota.quantidade = tt-base-cota.quantidade + de-valor-aux.
            if  par-cota.cont-canal-venda then do:
                find tt-base-cota where
                     tt-base-cota.cod-estabel = par-cota.cod-estabel and
                     tt-base-cota.cod-canal-venda  = ped-venda.cod-canal-venda and
                     tt-base-cota.cod-gr-cli = (if par-cota.cont-gr-cli then ? else 0) and
                     tt-base-cota.nome-abrev = (if par-cota.cont-cliente then ? else "") and
                     tt-base-cota.nome-ab-reg = (if par-cota.cont-ab-reg then ? else "") and
                     tt-base-cota.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") and
                     tt-base-cota.cd-produto = c-it-codigo
                     no-error.                          
                  if not avail tt-base-cota then do:
                     create tt-base-cota.
                     assign tt-base-cota.cod-estabel = par-cota.cod-estabel 
                            tt-base-cota.cod-canal-venda  = ped-venda.cod-canal-venda 
                            tt-base-cota.cod-gr-cli = (if par-cota.cont-gr-cli then ? else 0) 
                            tt-base-cota.nome-abrev = (if par-cota.cont-cliente then ? else "") 
                            tt-base-cota.nome-ab-reg = (if par-cota.cont-ab-reg then ? else "") 
                            tt-base-cota.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") 
                            tt-base-cota.cd-produto = c-it-codigo.
                  end.
                  assign tt-base-cota.quantidade = tt-base-cota.quantidade + de-valor-aux.
            end.
            if  par-cota.cont-gr-cli then do:
                find tt-base-cota where
                     tt-base-cota.cod-estabel = par-cota.cod-estabel and
                     tt-base-cota.cod-canal-venda  = (if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0) and
                     tt-base-cota.cod-gr-cli = ped-venda.cod-gr-cli and
                     tt-base-cota.nome-abrev = (if par-cota.cont-cliente then ? else "") and
                     tt-base-cota.nome-ab-reg = (if par-cota.cont-ab-reg then ? else "") and
                     tt-base-cota.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") and
                     tt-base-cota.cd-produto = c-it-codigo
                     no-error.                          
                  if not avail tt-base-cota then do:
                     create tt-base-cota.
                     assign tt-base-cota.cod-estabel = par-cota.cod-estabel 
                            tt-base-cota.cod-canal-venda  = (if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0) 
                            tt-base-cota.cod-gr-cli = ped-venda.cod-gr-cli 
                            tt-base-cota.nome-abrev = (if par-cota.cont-cliente then ? else "") 
                            tt-base-cota.nome-ab-reg = (if par-cota.cont-ab-reg then ? else "") 
                            tt-base-cota.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") 
                            tt-base-cota.cd-produto = c-it-codigo.
                  end.
                  assign tt-base-cota.quantidade = tt-base-cota.quantidade + de-valor-aux.
            end. 
            if  par-cota.cont-cliente then do:
                find tt-base-cota where
                     tt-base-cota.cod-estabel = par-cota.cod-estabel and
                     tt-base-cota.cod-canal-venda  = (if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0) and
                     tt-base-cota.cod-gr-cli = (if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0) and
                     tt-base-cota.nome-abrev = ped-venda.nome-abrev and
                     tt-base-cota.nome-ab-reg = (if par-cota.cont-ab-reg then ? else "") and
                     tt-base-cota.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") and
                     tt-base-cota.cd-produto = c-it-codigo
                     no-error.                          
                  if not avail tt-base-cota then do:
                     create tt-base-cota.
                     assign tt-base-cota.cod-estabel = par-cota.cod-estabel 
                            tt-base-cota.cod-canal-venda  = (if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0) 
                            tt-base-cota.cod-gr-cli = (if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0) 
                            tt-base-cota.nome-abrev = ped-venda.nome-abrev 
                            tt-base-cota.nome-ab-reg = (if par-cota.cont-ab-reg then ? else "") 
                            tt-base-cota.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") 
                            tt-base-cota.cd-produto = c-it-codigo.
                  end.
                  assign tt-base-cota.quantidade = tt-base-cota.quantidade + de-valor-aux.
            end. 
            if  par-cota.cont-ab-reg then do:
                find tt-base-cota where
                     tt-base-cota.cod-estabel = par-cota.cod-estabel and
                     tt-base-cota.cod-canal-venda  = (if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0) and
                     tt-base-cota.cod-gr-cli = (if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0) and
                     tt-base-cota.nome-abrev = (if par-cota.cont-cliente then ped-venda.nome-abrev else "") and
                     tt-base-cota.nome-ab-reg = repres.nome-ab-reg and
                     tt-base-cota.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") and
                     tt-base-cota.cd-produto = c-it-codigo
                     no-error.                          
                  if not avail tt-base-cota then do:
                     create tt-base-cota.
                     assign tt-base-cota.cod-estabel = par-cota.cod-estabel 
                            tt-base-cota.cod-canal-venda  = (if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0) 
                            tt-base-cota.cod-gr-cli = (if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0) 
                            tt-base-cota.nome-abrev = (if par-cota.cont-cliente then ped-venda.nome-abrev else "") 
                            tt-base-cota.nome-ab-reg = repres.nome-ab-reg 
                            tt-base-cota.nome-mic-reg = (if par-cota.cont-mic-reg then ? else "") 
                            tt-base-cota.cd-produto = c-it-codigo.
                  end.
                  assign tt-base-cota.quantidade = tt-base-cota.quantidade + de-valor-aux.
            end.
            if  par-cota.cont-mic-reg then do:
                find tt-base-cota where
                     tt-base-cota.cod-estabel = par-cota.cod-estabel and
                     tt-base-cota.cod-canal-venda  = (if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0) and
                     tt-base-cota.cod-gr-cli = (if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0) and
                     tt-base-cota.nome-abrev = (if par-cota.cont-cliente then ped-venda.nome-abrev else "") and
                     tt-base-cota.nome-ab-reg = (if par-cota.cont-ab-reg then repres.nome-ab-reg else "") and
                     tt-base-cota.nome-mic-reg = emitente.nome-mic-reg and
                     tt-base-cota.cd-produto = c-it-codigo
                     no-error.                          
                if not avail tt-base-cota then do:
                   create tt-base-cota.
                   assign tt-base-cota.cod-estabel = par-cota.cod-estabel 
                          tt-base-cota.cod-canal-venda  = (if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0) 
                          tt-base-cota.cod-gr-cli = (if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0) 
                          tt-base-cota.nome-abrev = (if par-cota.cont-cliente then ped-venda.nome-abrev else "") 
                          tt-base-cota.nome-ab-reg = (if par-cota.cont-ab-reg then repres.nome-ab-reg else "") 
                          tt-base-cota.nome-mic-reg = emitente.nome-mic-reg 
                          tt-base-cota.cd-produto = c-it-codigo.
                end.
                assign tt-base-cota.quantidade = tt-base-cota.quantidade + de-valor-aux.
            end.

            if  par-cota.cont-canal-venda then do:
                find tt-base-rat
                     where tt-base-rat.cod-estabel     = par-cota.cod-estabel
                     and   tt-base-rat.cod-canal-venda = ped-venda.cod-canal-venda 
                     and   tt-base-rat.cod-gr-cli      = (if par-cota.cont-gr-cli then ? else 0)
                     and   tt-base-rat.nome-abrev      = (if par-cota.cont-cliente then ? else "")
                     and   tt-base-rat.nome-ab-reg     = (if par-cota.cont-ab-reg then ? else "")
                     and   tt-base-rat.nome-mic-reg    = (if par-cota.cont-mic-reg then ? else "")
                     and   tt-base-rat.cod-rep         = ?
                     and   tt-base-rat.cd-produto      = c-it-codigo
                     and   tt-base-rat.codigo          = tt-param.codigo
                     no-error.

                if not avail tt-base-rat then do:
                   create tt-base-rat.
                   assign tt-base-rat.cod-estabel     = par-cota.cod-estabel
                          tt-base-rat.cod-canal-venda = ped-venda.cod-canal-venda 
                          tt-base-rat.cod-gr-cli      = (if par-cota.cont-gr-cli then ? else 0)
                          tt-base-rat.nome-abrev      = (if par-cota.cont-cliente then ? else "")
                          tt-base-rat.nome-ab-reg     = (if par-cota.cont-ab-reg then ? else "")
                          tt-base-rat.nome-mic-reg    = (if par-cota.cont-mic-reg then ? else "")
                          tt-base-rat.cod-rep         = ?
                          tt-base-rat.cd-produto      = c-it-codigo
                          tt-base-rat.codigo          = tt-param.codigo.
                end.
                assign tt-base-rat.quantidade  = tt-base-rat.quantidade + de-valor-aux.
            end.
            if  par-cota.cont-gr-cli then do:
                find tt-base-rat
                     where tt-base-rat.cod-estabel     = par-cota.cod-estabel
                     and   tt-base-rat.cod-canal-venda = (if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0) 
                     and   tt-base-rat.cod-gr-cli      = ped-venda.cod-gr-cli
                     and   tt-base-rat.nome-abrev      = (if par-cota.cont-cliente then ? else "")
                     and   tt-base-rat.nome-ab-reg     = (if par-cota.cont-ab-reg then ? else "")
                     and   tt-base-rat.nome-mic-reg    = (if par-cota.cont-mic-reg then ? else "")
                     and   tt-base-rat.cod-rep         = ?
                     and   tt-base-rat.cd-produto      = c-it-codigo
                     and   tt-base-rat.codigo          = tt-param.codigo
                     no-error.

                if not avail tt-base-rat then do:
                   create tt-base-rat.
                   assign tt-base-rat.cod-estabel     = par-cota.cod-estabel
                          tt-base-rat.cod-canal-venda = (if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0)
                          tt-base-rat.cod-gr-cli      = ped-venda.cod-gr-cli
                          tt-base-rat.nome-abrev      = (if par-cota.cont-cliente then ? else "")
                          tt-base-rat.nome-ab-reg     = (if par-cota.cont-ab-reg then ? else "")
                          tt-base-rat.nome-mic-reg    = (if par-cota.cont-mic-reg then ? else "")
                          tt-base-rat.cod-rep         = ?
                          tt-base-rat.cd-produto      = c-it-codigo
                          tt-base-rat.codigo          = tt-param.codigo.
                end.
                assign tt-base-rat.quantidade  = tt-base-rat.quantidade + de-valor-aux.
            end.
            if  par-cota.cont-cliente then do:
                find tt-base-rat
                     where tt-base-rat.cod-estabel     = par-cota.cod-estabel
                     and   tt-base-rat.cod-canal-venda = (if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0) 
                     and   tt-base-rat.cod-gr-cli      = (if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0)
                     and   tt-base-rat.nome-abrev      = ped-venda.nome-abrev
                     and   tt-base-rat.nome-ab-reg     = (if par-cota.cont-ab-reg then ? else "")
                     and   tt-base-rat.nome-mic-reg    = (if par-cota.cont-mic-reg then ? else "")
                     and   tt-base-rat.cod-rep         = ?
                     and   tt-base-rat.cd-produto      = c-it-codigo
                     and   tt-base-rat.codigo          = tt-param.codigo
                     no-error.

                if not avail tt-base-rat then do:
                   create tt-base-rat.
                   assign tt-base-rat.cod-estabel     = par-cota.cod-estabel
                          tt-base-rat.cod-canal-venda = (if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0)
                          tt-base-rat.cod-gr-cli      = (if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0)
                          tt-base-rat.nome-abrev      = ped-venda.nome-abrev
                          tt-base-rat.nome-ab-reg     = (if par-cota.cont-ab-reg then ? else "")
                          tt-base-rat.nome-mic-reg    = (if par-cota.cont-mic-reg then ? else "")
                          tt-base-rat.cod-rep         = ?
                          tt-base-rat.cd-produto      = c-it-codigo
                          tt-base-rat.codigo          = tt-param.codigo.
                end.
                assign tt-base-rat.quantidade  = tt-base-rat.quantidade + de-valor-aux.
            end.
            if  par-cota.cont-ab-reg then do:
                find tt-base-rat
                     where tt-base-rat.cod-estabel     = par-cota.cod-estabel
                     and   tt-base-rat.cod-canal-venda = (if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0) 
                     and   tt-base-rat.cod-gr-cli      = (if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0)
                     and   tt-base-rat.nome-abrev      = (if par-cota.cont-cliente then ped-venda.nome-abrev else "")
                     and   tt-base-rat.nome-ab-reg     = repres.nome-ab-reg
                     and   tt-base-rat.nome-mic-reg    = (if par-cota.cont-mic-reg then ? else "")
                     and   tt-base-rat.cod-rep         = ?
                     and   tt-base-rat.cd-produto      = c-it-codigo
                     and   tt-base-rat.codigo          = tt-param.codigo
                     no-error.

                if not avail tt-base-rat then do:
                   create tt-base-rat.
                   assign tt-base-rat.cod-estabel     = par-cota.cod-estabel
                          tt-base-rat.cod-canal-venda = (if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0)
                          tt-base-rat.cod-gr-cli      = (if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0)
                          tt-base-rat.nome-abrev      = (if par-cota.cont-cliente then ped-venda.nome-abrev else "")
                          tt-base-rat.nome-ab-reg     = repres.nome-ab-reg
                          tt-base-rat.nome-mic-reg    = (if par-cota.cont-mic-reg then ? else "")
                          tt-base-rat.cod-rep         = ?
                          tt-base-rat.cd-produto      = c-it-codigo
                          tt-base-rat.codigo          = tt-param.codigo.
                end.
                assign tt-base-rat.quantidade  = tt-base-rat.quantidade + de-valor-aux.
            end.
            if  par-cota.cont-mic-reg then do:
                find tt-base-rat
                     where tt-base-rat.cod-estabel     = par-cota.cod-estabel
                     and   tt-base-rat.cod-canal-venda = (if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0) 
                     and   tt-base-rat.cod-gr-cli      = (if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0)
                     and   tt-base-rat.nome-abrev      = (if par-cota.cont-cliente then ped-venda.nome-abrev else "")
                     and   tt-base-rat.nome-ab-reg     = (if par-cota.cont-ab-reg then repres.nome-ab-reg else "")
                     and   tt-base-rat.nome-mic-reg    = emitente.nome-mic-reg
                     and   tt-base-rat.cod-rep         = ?
                     and   tt-base-rat.cd-produto      = c-it-codigo
                     and   tt-base-rat.codigo          = tt-param.codigo
                     no-error.

                if not avail tt-base-rat then do:
                   create tt-base-rat.
                   assign tt-base-rat.cod-estabel     = par-cota.cod-estabel
                          tt-base-rat.cod-canal-venda = (if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0)
                          tt-base-rat.cod-gr-cli      = (if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0)
                          tt-base-rat.nome-abrev      = (if par-cota.cont-cliente then ped-venda.nome-abrev else "")
                          tt-base-rat.nome-ab-reg     = (if par-cota.cont-ab-reg then repres.nome-ab-reg else "")
                          tt-base-rat.nome-mic-reg    = emitente.nome-mic-reg
                          tt-base-rat.cod-rep         = ?
                          tt-base-rat.cd-produto      = c-it-codigo
                          tt-base-rat.codigo          = tt-param.codigo.
                end.
                assign tt-base-rat.quantidade  = tt-base-rat.quantidade + de-valor-aux.
            end.

            find tt-base-rat
                 where tt-base-rat.cod-estabel     = par-cota.cod-estabel
                 and   tt-base-rat.cod-canal-venda = (if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0) 
                 and   tt-base-rat.cod-gr-cli      = (if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0)
                 and   tt-base-rat.nome-abrev      = (if par-cota.cont-cliente then ped-venda.nome-abrev else "")
                 and   tt-base-rat.nome-ab-reg     = (if par-cota.cont-ab-reg then repres.nome-ab-reg else "")
                 and   tt-base-rat.nome-mic-reg    = (if par-cota.cont-mic-reg then emitente.nome-mic-reg else "")
                 and   tt-base-rat.cod-rep         = repres.cod-rep
                 and   tt-base-rat.cd-produto      = c-it-codigo
                 and   tt-base-rat.codigo          = tt-param.codigo
                 no-error.

            if not avail tt-base-rat then do:
               create tt-base-rat.
               assign tt-base-rat.cod-estabel     = par-cota.cod-estabel
                      tt-base-rat.cod-canal-venda = (if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0)
                      tt-base-rat.cod-gr-cli      = (if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0)
                      tt-base-rat.nome-abrev      = (if par-cota.cont-cliente then ped-venda.nome-abrev else "")
                      tt-base-rat.nome-ab-reg     = (if par-cota.cont-ab-reg then repres.nome-ab-reg else "")
                      tt-base-rat.nome-mic-reg    = (if par-cota.cont-mic-reg then emitente.nome-mic-reg else "")
                      tt-base-rat.cod-rep         = repres.cod-rep
                      tt-base-rat.cd-produto      = c-it-codigo
                      tt-base-rat.codigo          = tt-param.codigo.
            end.
            assign tt-base-rat.quantidade  = tt-base-rat.quantidade + de-valor-aux.
       end.
    &ENDIF

    if  l-niveis = no then do:
        find tt-base-cota exclusive-lock 
             where tt-base-cota.cd-produto = c-it-codigo no-error.
        if not avail tt-base-cota then do:
           create tt-base-cota.
           assign tt-base-cota.cd-produto = c-it-codigo
                  tt-base-cota.quantidade = de-valor-aux.
        end.
        else
           assign tt-base-cota.quantidade  = tt-base-cota.quantidade + de-valor-aux.

        &IF '{&bf_dis_versao_ems}' >= '2.04' &THEN
           IF &if '{&bf_dis_versao_ems}' >= '2.06' &THEN 
                 repres.log-consid-repres-cotas = NO 
              &ELSE 
                 substr(repres.char-1,1,1) = "1" 
              &ENDIF
           THEN DO: 
              /* N∆o considera representante para rateio de cotas */
              {acp/ac1001.i2 tt-base-rat-nao-consid}
           END.
           ELSE DO:
              /* Considera representante para rateio de cotas */
              {acp/ac1001.i2 tt-base-rat}
           END.
        &ELSE
            {acp/ac1001.i2 tt-base-rat}
        &ENDIF

    end.
end procedure.

&IF '{&bf_dis_versao_ems}' >= '2.04' &THEN
/* *************************** Procedure Rateio de Cotas de Representantes Inativos **************************** */
procedure rateia-nao-consid:

    DEF VAR tot-quantidade AS DECIMAL FORMAT ">>>,>>>,>>9.9999" NO-UNDO.
    def var de-tot-qtd-rat as decimal format ">>>,>>>,>>9.9999" no-undo.
    def var de-qt-dif-rat  as decimal format ">>>,>>>,>>9.9999" no-undo.

    /* Total rateado de representantes ativos */
    FOR EACH tt-base-rat
        BREAK BY tt-base-rat.cd-produto :

       ASSIGN tot-quantidade = tot-quantidade + tt-base-rat.quantidade.

       IF LAST-OF(tt-base-rat.cd-produto) THEN DO:
           CREATE tt-produto.
           ASSIGN tt-produto.cd-produto = tt-base-rat.cd-produto
                  tt-produto.quantidade = tot-quantidade
                  tot-quantidade        = 0.
       END. 

    END.

    FOR EACH tt-base-rat-nao-consid
        BREAK BY tt-base-rat-nao-consid.cd-produto :

        /* Acumula quantidade rateada de representantes inativos */
        ASSIGN tot-quantidade = tot-quantidade + tt-base-rat-nao-consid.quantidade.

        IF LAST-OF(tt-base-rat-nao-consid.cd-produto) THEN DO:
            FIND FIRST tt-produto WHERE
                       tt-produto.cd-produto = tt-base-rat-nao-consid.cd-produto 
                NO-LOCK NO-ERROR.

            IF AVAIL tt-produto THEN DO: 
                FOR EACH  tt-base-rat EXCLUSIVE-LOCK
                    WHERE tt-base-rat.cd-produto = tt-base-rat-nao-consid.cd-produto 
                    BREAK BY tt-base-rat.cd-produto :

                    /* Rateio das quantidades inativas proporcional ao total rateado */
                    assign de-tot-qtd-rat         = (de-tot-qtd-rat + ROUND(
                                                    ((tt-base-rat.quantidade / 
                                                     tt-produto.quantidade) * tot-quantidade),4))
                           tt-base-rat.quantidade = tt-base-rat.quantidade + 
                                                    ((tt-base-rat.quantidade / 
                                                      tt-produto.quantidade) * tot-quantidade).

                    if (de-tot-qtd-rat - tot-quantidade) < 0 then
                        assign de-qt-dif-rat = (de-tot-qtd-rat - tot-quantidade) / -1.
                    else
                        assign de-qt-dif-rat = (de-tot-qtd-rat - tot-quantidade).

                    IF LAST-OF(tt-base-rat.cd-produto) THEN DO:    
                        IF de-tot-qtd-rat > tot-quantidade THEN DO:
                           FIND LAST b-tt-base-rat WHERE 
                                     b-tt-base-rat.cd-produto = tt-produto.cd-produto 
                                     EXCLUSIVE-LOCK NO-ERROR.
                           IF AVAIL b-tt-base-rat THEN
                               ASSIGN b-tt-base-rat.quantidade = tt-base-rat.quantidade - de-qt-dif-rat.
                        END.
                        ELSE DO:
                           FIND LAST b-tt-base-rat WHERE 
                                     b-tt-base-rat.cd-produto = tt-produto.cd-produto 
                                     EXCLUSIVE-LOCK NO-ERROR.
                           IF AVAIL b-tt-base-rat THEN
                               ASSIGN b-tt-base-rat.quantidade = tt-base-rat.quantidade + de-qt-dif-rat.
                        END.
                        ASSIGN  de-tot-qtd-rat = 0
                                de-qt-dif-rat  = 0.
                    END.
                END.
            END. /* if */
            ASSIGN tot-quantidade = 0.
        END. /* last-of */
    END. /* for each */

end procedure.
&ENDIF
