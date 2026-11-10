/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0411RP 2.00.00.014 } /*** "010014" 22/05/2025 16:59:46  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac0411rp MAC}
&ENDIF

{include/i_fnctrad.i}
/*******************************************************************************
**
** Ac0411RP.P : Relat¢rio de Cotas por Condi‡Æo Pagto
**
********************************************************************************/
{utp/ut-glob.i}
/* ************************ Defini‡Æo de vari veis *************************** */

{include/i-rpvar.i}

{cdp/cdcfgdis.i} /*include para pr‚-processadores*/

def var c-selecao          as char format "x(11)"              no-undo.
def var c-parametro        as char format "x(14)"              no-undo.
def var c-repres           as char format "x(06)"              no-undo.
def var c-cota             as char format "x(04)"              no-undo.
def var c-sintetico        as char format "x(09)"              no-undo.
def var c-analitico        as char format "x(09)"              no-undo.
def var c-tot-ger          as char format "x(11)"              no-undo.
def var c-tot-est          as char format "x(11)"              no-undo.
def var c-realizado        as char format "x(09)"              no-undo.
def var c-grupo            as char format "x(05)"              no-undo.
def var c-cliente          as char format "x(08)"              no-undo.
def var c-impressao        as char format "x(12)"              no-undo.
def var c-destino          as char format "x(10)"              no-undo.
def var h-acomp            as handle                           no-undo.

def var i-cont             as inte                             no-undo.
def var de-prazo-medio     as decimal                          no-undo.
def var de-tot-prazo-medio as decimal                          no-undo.
def var r-cotas            as rowid                            no-undo.
def var de-tot-realizado   like cotas.qt-pedida                no-undo.
def var de-tot-prevista    like cotas.qt-prevista              no-undo.
def var de-tot-prev-canal  like cotas.qt-prevista              no-undo.
def var de-tot-real-canal  like cotas.qt-pedida                no-undo.
def var de-tot-prev-est    like cotas.qt-prevista              no-undo.
def var de-tot-real-est    like cotas.qt-pedida                no-undo.

/* ********************  Defini‡Æo de Temp-Table ****************************** */

define shared temp-table tt-digita
    field cod-cond-pagto   like cond-pagto.cod-cond-pag
    field exemplo          like cond-pagto.descricao
        index id is primary unique
        cod-cond-pagto.


def temp-table tt-raw-digita
   field raw-digita      as raw.

def temp-table tt-cotas 
   field cod-estabel     like cotas.cod-estabel
   field cod-canal-venda like cotas.cod-canal-venda
   field cod-gr-cli      like cotas.cod-gr-cli
   field nome-abrev      like cotas.nome-abrev
   field cod-rep         like cotas.cod-rep
   field qt-prevista     like cotas.qt-prevista
   field qt-pedida       like cotas.qt-pedida
   INDEX grupo IS PRIMARY
                  cod-estabel
                  cod-canal-venda
                  cod-gr-cli
                  nome-abrev
                  cod-rep ASCENDING.

def temp-table tt-cond-pagto
   field cod-estabel     like cotas.cod-estabel
   field cod-canal-venda like cotas.cod-canal-venda
   field cod-gr-cli      like cotas.cod-gr-cli
   field nome-abrev      like cotas.nome-abrev
   field cod-rep         like cotas.cod-rep
   field cod-cond-pag    like cond-pagto.cod-cond-pag
   field qt-pedida       like cotas.qt-pedida
   INDEX grupo IS PRIMARY
                  cod-estabel
                  cod-canal-venda
                  cod-gr-cli
                  nome-abrev
                  cod-rep 
                  cod-cond-pag ASCENDING.

{acp/ac0411.i}  /* Defini‡Æo da Temp-table tt-param */



/* ************************ Defini‡Æo de parametros ************************** */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

/* *********** Defini‡Æo do layout da p gina de parƒmetros ****************** */

/************************************************************ 
*  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
************************************************************/

&if defined (bf_dis_adm_cotas) &then
    form skip(01)
         c-selecao                 no-label     skip(1)
         tt-param.cod-estabel-ini  colon 40 space(18) "|< >|"
         tt-param.cod-estabel-fim  no-label colon 73 skip(1)
         tt-param.nr-pedido-ini    colon 40 space(11) "|< >|"
         tt-param.nr-pedido-fim    no-label colon 73 skip(1)
         tt-param.nome-abrev-ini   colon 40 space(11) "|< >|"
         tt-param.nome-abrev-fim   no-label colon 73 skip(1)
         tt-param.dt-ini           colon 40 space(13) "|< >|"
         tt-param.dt-fim           no-label colon 73 skip(1)
         tt-param.cod-canal-venda-ini colon 40 space(20) "|< >|"
         tt-param.cod-canal-venda-fim no-label colon 73 skip(1)
         c-impressao no-label      skip(1)
         c-destino                 colon 40
         " - ":U
         tt-param.arquivo no-label format "x(60)":U skip
         tt-param.usuario        colon 40 skip(4)     
         with down no-box side-labels width 132 stream-io frame f-parametros.
&else
    form skip(01)
         c-selecao                 no-label     skip(1)
         tt-param.cod-estabel-ini  colon 40 space(18) "|< >|"
         tt-param.cod-estabel-fim  no-label colon 73 skip(1)
         tt-param.nr-pedido-ini    colon 40 space(11) "|< >|"
         tt-param.nr-pedido-fim    no-label colon 73 skip(1)
         tt-param.nome-abrev-ini   colon 40 space(11) "|< >|"
         tt-param.nome-abrev-fim   no-label colon 73 skip(1)
         tt-param.dt-ini           colon 40 space(13) "|< >|"
         tt-param.dt-fim           no-label colon 73 skip(1)
         c-impressao no-label      skip(1)
         c-destino                 colon 40
         " - ":U
         tt-param.arquivo no-label format "x(60)":U skip
         tt-param.usuario        colon 40 skip(4)     
         with down no-box side-labels width 132 stream-io frame f-parametros.
&endif

form tt-cotas.cod-estabel           at 01                  
     estabelec.nome no-label        at 32 skip
     tt-cotas.cod-canal-venda       at 01
     canal-venda.descricao no-label at 32 skip(1)
     with side-labels stream-io no-attr-space frame f-canal.  


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

/************************************************************ 
*  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
************************************************************/

&if defined (bf_dis_adm_cotas) &then
    {utp/ut-liter.i Per¡odo * R}
    assign tt-param.dt-ini:label in frame f-parametros = trim(return-value).
&endif

{utp/ut-liter.i Repres * R}
assign c-repres = trim(return-value).
{utp/ut-liter.i Cota * R}
assign c-cota = trim(return-value).
{utp/ut-liter.i Realizado * R}
assign c-realizado = trim(return-value).
{utp/ut-liter.i Grupo * R}
assign c-grupo = trim(return-value).
{utp/ut-liter.i Total * R}
assign c-sintetico = trim(return-value).
{utp/ut-liter.i Anal¡tico * R}
assign c-analitico = trim(return-value).
{utp/ut-liter.i Total_Canal * R}
assign c-tot-ger = trim(return-value).
{utp/ut-liter.i Total_Estabel * R}
assign c-tot-est = trim(return-value).

/* ************************ Inicio do programa ****************************** */
run utp/ut-trfrrp.p (input frame f-canal:handle).
run utp/ut-trfrrp.p (input frame f-parametros:handle).
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.

run utp/ut-acomp.p persistent set h-acomp.

find empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
if avail empresa then
   assign c-empresa = empresa.razao-social.

{utp/ut-liter.i Cotas MAP C}
assign c-programa = 'ap0411'
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

{utp/ut-liter.i Relat¢rio_Cotas_por_Condi‡Æo_Pagto MAP C}
assign c-titulo-relat = return-value.

{include/i-rpout.i}
view frame f-cabec.
view frame f-rodape.
{utp/ut-liter.i Aguarde... *}

run pi-inicializar in h-acomp (input  Return-value ).

main-block:

do  on error  undo main-block, leave main-block
    on endkey undo main-block, leave main-block
    on stop   undo main-block, leave main-block:

    /************************************************************ 
    *  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
    ************************************************************/

    &if defined (bf_dis_adm_cotas) &then
        for each atu-cota no-lock
            where atu-cota.cod-estabel     >= tt-param.cod-estabel-ini
            and   atu-cota.cod-estabel     <= tt-param.cod-estabel-fim
            and   atu-cota.nr-pedcli       >= tt-param.nr-pedido-ini
            and   atu-cota.nr-pedcli       <= tt-param.nr-pedido-fim
            and   atu-cota.nome-abrev      >= tt-param.nome-abrev-ini
            and   atu-cota.nome-abrev      <= tt-param.nome-abrev-fim
            and   atu-cota.dt-inicial      >= tt-param.dt-ini
            and   atu-cota.dt-inicial      <= tt-param.dt-fim
            and   atu-cota.cod-canal-venda >= tt-param.cod-canal-venda-ini
            and   atu-cota.cod-canal-venda <= tt-param.cod-canal-venda-fim
            and   atu-cota.cod-rep         <> ?:
    &else
        for each atu-cota no-lock
            where atu-cota.cod-estabel >= tt-param.cod-estabel-ini
            and   atu-cota.cod-estabel <= tt-param.cod-estabel-fim
            and   atu-cota.nr-pedcli   >= tt-param.nr-pedido-ini
            and   atu-cota.nr-pedcli   <= tt-param.nr-pedido-fim
            and   atu-cota.nome-abrev  >= tt-param.nome-abrev-ini
            and   atu-cota.nome-abrev  <= tt-param.nome-abrev-fim
            and   atu-cota.dt-inicial  >= tt-param.dt-ini
            and   atu-cota.dt-inicial  <= tt-param.dt-fim  :
    &endif

        run pi-acompanhar in h-acomp (input atu-cota.nome-abrev).

        find first para-ped no-lock no-error.
        if substring(para-ped.char-2,1,3) = "yes" then
           find par-cota no-lock 
                where par-cota.cod-estabel = para-ped.estab-padrao no-error.
        else
           find par-cota NO-LOCK
                where par-cota.cod-estabel = atu-cota.cod-estabel no-error.

        if not avail par-cota then
            next.

        find emitente no-lock
             where emitente.nome-abrev = atu-cota.nome-abrev no-error.
        if not avail emitente then next.

        find repres no-lock
             where repres.cod-rep = atu-cota.cod-rep no-error.
        if not avail repres then next.

        run acp/acapi004.p (input par-cota.cod-estabel,
                            input repres.cod-rep,
                            input (if par-cota.cont-produto     then atu-cota.cd-produto else par-cota.it-codigo-padrao),
                            input atu-cota.dt-inicial,
                            input (if par-cota.cont-canal-venda then atu-cota.cod-canal-venda else 0),
                            input (if par-cota.cont-gr-cli      then atu-cota.cod-gr-cli      else 0),
                            input (if par-cota.cont-cliente     then atu-cota.nome-abrev      else ""),
                            input (if par-cota.cont-ab-reg      then repres.nome-ab-reg        else ""),
                            input (if par-cota.cont-mic-reg     then emitente.nome-mic-reg     else ""),
                            output r-cotas).

        IF par-cota.cont-cliente THEN DO:

            FIND cotas NO-LOCK WHERE ROWID(cotas) = r-cotas NO-ERROR.
            IF NOT AVAIL cotas THEN DO:

                IF emitente.nome-abrev <> emitente.nome-matriz THEN DO:

                    RUN acp/acapi004.p (INPUT par-cota.cod-estabel,                                                                    
                                        INPUT repres.cod-rep,                                                                          
                                        INPUT (if par-cota.cont-produto     then atu-cota.cd-produto else par-cota.it-codigo-padrao),  
                                        INPUT atu-cota.dt-inicial,                                                                     
                                        INPUT (if par-cota.cont-canal-venda then atu-cota.cod-canal-venda else 0),                     
                                        INPUT (if par-cota.cont-gr-cli      then atu-cota.cod-gr-cli      else 0),                     
                                        INPUT emitente.nome-matriz,
                                        INPUT (if par-cota.cont-ab-reg      then repres.nome-ab-reg        else ""),     
                                        INPUT (if par-cota.cont-mic-reg     then emitente.nome-mic-reg     else ""),     
                                        OUTPUT r-cotas).

                END.

            END.

        END.

        find cotas no-lock
             where rowid(cotas) = r-cotas no-error.

        if avail cotas then do: 
          find tt-cotas 
               where tt-cotas.cod-estabel     = par-cota.cod-estabel
               and   tt-cotas.cod-canal-venda = atu-cota.cod-canal-venda
               and   tt-cotas.cod-gr-cli      = atu-cota.cod-gr-cli
               and   tt-cotas.nome-abrev      = atu-cota.nome-abrev 
               and   tt-cotas.cod-rep         = repres.cod-rep no-error.

          if not avail tt-cotas then do:
             create tt-cotas.
             assign tt-cotas.cod-estabel     = par-cota.cod-estabel
                    tt-cotas.cod-canal-venda = atu-cota.cod-canal-venda
                    tt-cotas.cod-gr-cli      = atu-cota.cod-gr-cli
                    tt-cotas.nome-abrev      = atu-cota.nome-abrev
                    tt-cotas.cod-rep         = repres.cod-rep
                    tt-cotas.qt-prevista     = cotas.qt-prevista
                    tt-cotas.qt-pedida       = atu-cota.qt-pedida.
          end. 
          else
             assign tt-cotas.qt-pedida   = tt-cotas.qt-pedida   + atu-cota.qt-pedida.

          find ped-venda no-lock where 
               ped-venda.nome-abrev = atu-cota.nome-abrev and
               ped-venda.nr-pedcli  = atu-cota.nr-pedcli  no-error.
          if not avail ped-venda then next.

          find tt-digita no-lock
               where tt-digita.cod-cond-pagto = ped-venda.cod-cond-pag no-error.   

          if avail tt-digita then do:
             find tt-cond-pagto
                  where tt-cond-pagto.cod-estabel     = atu-cota.cod-estabel
                  and   tt-cond-pagto.cod-canal-venda = atu-cota.cod-canal-venda
                  and   tt-cond-pagto.cod-gr-cli      = atu-cota.cod-gr-cli
                  and   tt-cond-pagto.nome-abrev      = atu-cota.nome-abrev
                  and   tt-cond-pagto.cod-rep         = repres.cod-rep
                  and   tt-cond-pagto.cod-cond-pag    = ped-venda.cod-cond-pag no-error.
             if not avail tt-cond-pagto then do:
                create tt-cond-pagto.
                assign tt-cond-pagto.cod-estabel     = atu-cota.cod-estabel
                       tt-cond-pagto.cod-canal-venda = atu-cota.cod-canal-venda
                       tt-cond-pagto.cod-rep         = repres.cod-rep
                       tt-cond-pagto.cod-gr-cli      = atu-cota.cod-gr-cli
                       tt-cond-pagto.nome-abrev      = atu-cota.nome-abrev
                       tt-cond-pagto.cod-cond-pag    = ped-venda.cod-cond-pag
                       tt-cond-pagto.qt-pedida       = atu-cota.qt-pedida.
             end.
             else
                assign tt-cond-pagto.qt-pedida = tt-cond-pagto.qt-pedida + atu-cota.qt-pedida.
          end.
        end. /*avail cotas*/            
    end. /*for each ped-venda*/         

    for each tt-cotas use-index grupo 
        break by tt-cotas.cod-estabel
              by tt-cotas.cod-canal-venda
              by tt-cotas.cod-gr-cli
              by tt-cotas.nome-abrev
              by tt-cotas.cod-rep:

        if first-of(tt-cotas.cod-canal-venda) then do:
           disp tt-cotas.cod-estabel with frame f-canal.
           find estabelec no-lock where estabelec.cod-estabel = tt-cotas.cod-estabel no-error.
           if avail estabelec then
              disp estabelec.nome with frame f-canal.         
           disp tt-cotas.cod-canal-venda  with frame f-canal.
           find canal-venda no-lock where canal-venda.cod-canal-venda = tt-cotas.cod-canal-venda no-error.
           if avail canal-venda then
              disp canal-venda.descricao no-label with frame f-canal.
           put c-repres            at 01
               c-grupo             at 08
               c-cota              at 27
               c-realizado         at 40
               "%"                 at 53
               " "                 at 55.

           for each tt-digita
               by tt-digita.cod-cond-pagto:
               put " "
                   tt-digita.exemplo format "x(06)".
           end.

           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-prmed AS CHARACTER FORMAT "X(8)" NO-UNDO.
           {utp/ut-liter.i "Pr.Med" *}
           ASSIGN c-lbl-liter-prmed = TRIM(RETURN-VALUE).
           put c-lbl-liter-prmed            at 127 skip 
               "------"            at 01
               "-----"             at 08
               "-----------------" at 14
               "-----------------" at 32
               "------"            at 50.

           for each tt-digita
               by tt-digita.cod-cond-pagto:
               put " ------" format "x(07)".
           end.

           put "------" at 127.

        end. /*first-of*/

        if first-of(tt-cotas.cod-rep) then do:
           put tt-cotas.cod-rep  at 02.
        end.

        put tt-cotas.cod-gr-cli  at 09
            tt-cotas.qt-prevista at 14
            tt-cotas.qt-pedida   at 32
            (tt-cotas.qt-pedida * 100) / tt-cotas.qt-prevista format ">>9.99" at 50
            " ".

        for each tt-digita
            by tt-digita.cod-cond-pagto:

            find tt-cond-pagto
                 where tt-cond-pagto.cod-estabel     = tt-cotas.cod-estabel
                 and   tt-cond-pagto.cod-canal-venda = tt-cotas.cod-canal-venda
                 and   tt-cond-pagto.cod-gr-cli      = tt-cotas.cod-gr-cli
                 and   tt-cond-pagto.nome-abrev      = tt-cotas.nome-abrev
                 and   tt-cond-pagto.cod-rep         = tt-cotas.cod-rep
                 and   tt-cond-pagto.cod-cond-pag    = tt-digita.cod-cond-pagto no-error.
            if avail tt-cond-pagto then do:
               put tt-cond-pagto.qt-pedida * 100 / tt-cotas.qt-pedida format ">>9.99"
                   " ". 
               find cond-pagto no-lock
                    where cond-pagto.cod-cond-pag = tt-digita.cod-cond-pagto no-error.
               if avail cond-pagto then do:
                  do i-cont = 1 to cond-pagto.num-parcelas:
                     assign de-prazo-medio = de-prazo-medio + cond-pagto.prazos[i-cont].
                  end.
                  assign de-prazo-medio = de-prazo-medio / cond-pagto.num-parcelas.
               end.
               de-tot-prazo-medio = de-tot-prazo-medio + (tt-cond-pagto.qt-pedida * de-prazo-medio).
            end.
            else
               put "       ".

        end. /*for each tt-digita*/

        put de-tot-prazo-medio / tt-cotas.qt-pedida  format ">>9.99" at 127.


        assign de-tot-prazo-medio = 0
               de-prazo-medio     = 0
               de-tot-prevista    = de-tot-prevista + tt-cotas.qt-prevista
               de-tot-realizado   = de-tot-realizado + tt-cotas.qt-pedida. 

        if last-of(tt-cotas.cod-rep) then do:
/*           put  "-----------------" at 14
 *                 "-----------------" at 32
 *                 "------"            at 50.
 * 
 *            for each tt-digita
 *                by tt-digita.cod-cond-pagto:
 *                put " ------" format "x(07)".
 *            end.
 *            
 *            put "------" at 127.
 *            
 *            put  c-sintetico         at 01
 *                 de-tot-prevista     at 14
 *                 de-tot-realizado    at 32
 *                 (de-tot-realizado * 100) / de-tot-prevista format ">>9.99" at 50 skip(2).
 *                 */

           assign de-tot-prev-canal = de-tot-prev-canal + de-tot-prevista
                  de-tot-real-canal = de-tot-real-canal + de-tot-realizado
                  de-tot-prevista   = 0
                  de-tot-realizado  = 0.

        end. /*last-of*/

        if last-of(tt-cotas.cod-canal-venda) then do:
           put  "-----------------" at 14
                "-----------------" at 32
                "------"            at 50
                c-tot-ger           at 01
                de-tot-prev-canal   at 14
                de-tot-real-canal   at 32
                (de-tot-real-canal * 100) / de-tot-prev-canal format ">>9.99" at 50 skip(2).

           assign de-tot-prev-est   = de-tot-prev-est + de-tot-prev-canal
                  de-tot-real-est   = de-tot-real-est + de-tot-real-canal
                  de-tot-prev-canal = 0
                  de-tot-real-canal = 0.           

           if last-of(tt-cotas.cod-estabel) then do:
              put  "-----------------" at 14
                   "-----------------" at 32
                   "------"            at 50
                   c-tot-est           at 01
                   de-tot-prev-est     at 14
                   de-tot-real-est     at 32
                   (de-tot-real-est * 100) / de-tot-prev-est format ">>9.99" at 50 skip(2).
              assign de-tot-prev-est = 0
                     de-tot-real-est = 0.           
           end. /*if last-of*/

           page.

        end. /*if last-of*/
    end. /*for each tt-cotas*/
end. /*bloco*/
run pi-finalizar in h-acomp.

/* **************** ImpressÆo da p gina de parƒmetros ************* */

if  page-number > 0 then page.
/************************************************************ 
*  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
************************************************************/

&if defined (bf_dis_adm_cotas) &then
    display c-selecao 
            tt-param.cod-estabel-ini 
            tt-param.cod-estabel-fim 
            tt-param.nr-pedido-ini   
            tt-param.nr-pedido-fim   
            tt-param.nome-abrev-ini  
            tt-param.nome-abrev-fim  
            tt-param.dt-ini          
            tt-param.dt-fim
            tt-param.cod-canal-venda-ini
            tt-param.cod-canal-venda-fim
            c-impressao
            c-destino
            tt-param.arquivo
            tt-param.usuario
            with frame f-parametros.
&else
    display c-selecao 
            tt-param.cod-estabel-ini 
            tt-param.cod-estabel-fim 
            tt-param.nr-pedido-ini   
            tt-param.nr-pedido-fim   
            tt-param.nome-abrev-ini  
            tt-param.nome-abrev-fim  
            tt-param.dt-ini          
            tt-param.dt-fim
            c-impressao
            c-destino
            tt-param.arquivo
            tt-param.usuario
            with frame f-parametros.
&endif

{include/i-rpclo.i}

RETURN "OK".

/* Fim do Programa */


