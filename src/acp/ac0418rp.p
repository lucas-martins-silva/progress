/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0418RP 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac0418rp MAC}
&ENDIF

/*******************************************************************************
**
** Ac0418RP.P : ImpressÆo do relat¢rio de Cotas por Representante
**
********************************************************************************/
{utp/ut-glob.i}
/* ************************ Defini‡Æo de vari veis *************************** */

{include/i-rpvar.i}

def var c-descricao            as char format "x(60)"              no-undo.
def var c-selecao              as char format "x(11)"              no-undo.
def var c-parametro            as char format "x(14)"              no-undo.
def var c-impressao            as char format "x(12)"              no-undo.
def var c-destino              as char format "x(10)"              no-undo.
def var h-acomp                as handle                           no-undo.
def var de-tot-solicitado      like cotas.qt-original              no-undo.
def var de-tot-prevista        like cotas.qt-prevista              no-undo.
def var de-tot-pedida          like cotas.qt-pedida                no-undo.
def var de-tot-faturada        like cotas.qt-faturada              no-undo.
def var de-solicitado          like cotas.qt-original              no-undo.
def var de-prevista            like cotas.qt-prevista              no-undo.
def var de-realiz-pedida       like cotas.qt-pedida                no-undo.
def var de-cancel-ped          like cotas.qt-ped-canc              no-undo.
def var de-perc-solicitado     as dec format "Z,ZZ9.99"            no-undo.
def var de-perc-prev           as dec format "ZZ9.99"              no-undo.
def var de-tot-realiz-pedida   like cotas.qt-pedida                no-undo.
def var de-tot-perc-solicitado as dec format "Z,ZZ9.99"            no-undo.
def var de-tot-cancel-ped      like cotas.qt-ped-canc              no-undo.
def var de-tot-perc-prev       as dec format "Z,ZZ9.99"            no-undo.
def var c-un-medida            as char format "x(15)"              no-undo.
def var c-nome-abrev           like emitente.nome-abrev            no-undo.
def var tot-solicitado        like cotas.qt-original   init 0     no-undo.
def var tot-prevista          like cotas.qt-prevista   init 0     no-undo.
def var tot-realiz-pedida     like cotas.qt-pedida     init 0     no-undo.
def var tot-cancel-ped        like cotas.qt-ped-canc   init 0     no-undo.

/* ********************  Defini‡Æo de Temp-Table ****************************** */

def temp-table tt-raw-digita
   field raw-digita      as raw.

/* Defini‡Æo da Temp-table tt-param */
define temp-table tt-param
    field destino              as integer
    field arquivo              as char
    field usuario              as char format "x(12)"
    field data-exec            as date
    field hora-exec            as integer
    field cod-estab-ini        like cotas.cod-estabel
    field cod-estab-fim        like cotas.cod-estabel
    field cod-canal-venda-ini  like cotas.cod-canal-venda
    field cod-canal-venda-fim  like cotas.cod-canal-venda
    field cod-gr-cli-ini       like cotas.cod-gr-cli
    field cod-gr-cli-fim       like cotas.cod-gr-cli
    field nome-abrev-ini       like cotas.nome-abrev
    field nome-abrev-fim       like cotas.nome-abrev
    field nome-ab-reg-ini      like cotas.nome-ab-reg
    field nome-ab-reg-fim      like cotas.nome-ab-reg
    field nome-mic-reg-ini     like cotas.nome-mic-reg
    field nome-mic-reg-fim     like cotas.nome-mic-reg
    field cod-rep-ini          like cotas.cod-rep
    field cod-rep-fim          like cotas.cod-rep
    field cd-produto-ini       like cotas.cd-produto
    field cd-produto-fim       like cotas.cd-produto
    field dt-inicial           like cotas.dt-inicial
    field dt-final             like cotas.dt-inicial
    field l-cons-reprov        as logical
    field l-cons-susp          as logical
    field l-utiliza-decimais   as logical.

/* ************************ Defini‡Æo de parametros ************************** */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

/* *********** Defini‡Æo do layout da p gina de parƒmetros ****************** */

form skip(01)
     c-selecao                      no-label    skip(1)

     &IF "{&mguni_version}" >= "2.071" &THEN
        tt-param.cod-estab-ini            colon 40 space(12) "|< >|"
     &ELSE
        tt-param.cod-estab-ini            colon 40 space(14) "|< >|"
     &ENDIF
     
     tt-param.cod-estab-fim         no-label colon 73 skip
     tt-param.cod-canal-venda-ini      colon 40 space(14) "|< >|"
     tt-param.cod-canal-venda-fim   no-label colon 73 skip
     tt-param.cod-gr-cli-ini           colon 40 space(13) "|< >|"
     tt-param.cod-gr-cli-fim        no-label colon 73 skip
     tt-param.nome-abrev-ini           colon 40 space(5)  "|< >|"
     tt-param.nome-abrev-fim        no-label colon 73 skip     
     tt-param.nome-ab-reg-ini          colon 40 space(05) "|< >|"
     tt-param.nome-ab-reg-fim       no-label colon 73 skip
     tt-param.nome-mic-reg-ini         colon 40 space(05) "|< >|"
     tt-param.nome-mic-reg-fim      no-label colon 73 skip
     tt-param.cod-rep-ini              colon 40 space(12) "|< >|"
     tt-param.cod-rep-fim           no-label colon 73 skip
     tt-param.cd-produto-ini           colon 40 space(1)  "|< >|"
     tt-param.cd-produto-fim        no-label colon 73 skip
     tt-param.dt-inicial               colon 40 space(7)  "|< >|"
     tt-param.dt-final              no-label colon 73 skip(1)     

     c-parametro                    no-label    skip(1)
     tt-param.l-cons-reprov           colon 69 skip
     tt-param.l-cons-susp             colon 70 skip
     tt-param.l-utiliza-decimais      colon 70 skip(1)

     c-impressao                    no-label    skip(1)
     c-destino                         colon 40
     " - ":U
     tt-param.arquivo               no-label format "x(60)":U skip
     tt-param.usuario                  colon 40 skip(1)

     with down no-box side-labels width 132 stream-io frame f-parametros.

form skip(2)
     cotas.cod-estabel colon 20 " - "
     estabelec.nome    no-label skip
     with  side-labels down width 132 stream-io frame f-tit.

form 
     cotas.cd-produto colon 22 " - "
     c-descricao     no-label skip
    with  side-labels down width 132 stream-io frame f-tit2.

form "TOTAL"                colon 13
     de-tot-solicitado      colon 35  format ">,>>>>>>,>>9.99"
     de-tot-prevista        colon 50  format ">,>>>>>>,>>9.99"
     de-tot-realiz-pedida   colon 67  format ">,>>>>>>,>>9.99"
     de-tot-perc-solicitado colon 82  format ">,>>>>>>,>>9.99"
     de-tot-perc-prev       colon 97  format ">,>>>>>>,>>9.99"
     de-tot-cancel-ped      colon 114 format ">,>>>>>>,>>9.99" skip(1)
     with  no-labels  width 132 stream-io frame f-total.

form "TOTAL"                colon 13
     de-tot-solicitado      colon 36  format ">,>>>>>>,>>9"
     de-tot-prevista        colon 50  format ">,>>>>>>,>>9"
     de-tot-realiz-pedida   colon 67  format ">,>>>>>>,>>9"
     de-tot-perc-solicitado colon 80  format ">,>>>>>>,>>9.99"
     de-tot-perc-prev       colon 96 format ">,>>>>>>,>>9.99"
     de-tot-cancel-ped      colon 116 format ">,>>>>>>,>>9" skip(1)
     with  no-labels  width 132 stream-io frame f-total-int.

form "TOTAL GERAL"       colon 13
     tot-solicitado      colon 35  format ">,>>>>>>,>>9.99"
     tot-prevista        colon 50  format ">,>>>>>>,>>9.99"
     tot-realiz-pedida   colon 67  format ">,>>>>>>,>>9.99"
     tot-cancel-ped      colon 114 format ">,>>>>>>,>>9.99" skip(1)
     with  no-labels  width 132 stream-io frame f-tot-total.

form "TOTAL GERAL"       colon 13
     tot-solicitado      colon 36  format ">,>>>>>>,>>9"
     tot-prevista        colon 50  format ">,>>>>>>,>>9"
     tot-realiz-pedida   colon 67  format ">,>>>>>>,>>9"
     tot-cancel-ped      colon 116 format ">,>>>>>>,>>9" skip(1)
     with  no-labels  width 132 stream-io frame f-tot-total-int.

form cotas.cod-rep      TO 13  column-label "             "    format ">>>>9"            
     repres.nome-abrev  TO 26  column-label "            "     format "x(12)"
     cotas.dt-inicial   TO 36 
     de-solicitado      to 51  column-label "          "       format ">,>>>>>>,>>9.99"
     de-prevista        to 66  column-label "        "         format ">,>>>>>>,>>9.99"
     de-realiz-pedida   TO 83  column-label "                " format ">,>>>>>>,>>9.99"
     de-perc-solicitado TO 98  column-label "            "     format ">,>>>>>>,>>9.99"
     de-perc-prev       TO 113 column-label "          "       format ">,>>>>>>,>>9.99"
     de-cancel-ped      TO 130 column-label "                " format ">,>>>>>>,>>9.99"
     with  down width 132 stream-io frame f-imp.

form cotas.cod-rep            column-label "             "    format ">>>>9"            
     repres.nome-abrev        column-label "            "     format "x(12)"
     cotas.dt-inicial
     de-solicitado      to 49 column-label "          "       format ">,>>>>>>,>>9"
     de-prevista        to 63 column-label "        "         format ">,>>>>>>,>>9"
     de-realiz-pedida         column-label "                " format ">,>>>>>>,>>9"
     de-perc-solicitado       column-label "            "     format ">,>>>>>>,>>9.99"
     de-perc-prev             column-label "          "       format ">,>>>>>>,>>9.99"
     de-cancel-ped            column-label "                " format ">,>>>>>>,>>9"
     with  down width 132 stream-io frame f-imp-int.


/* *********************** Defini‡Æo de literais  ***************************** */

{utp/ut-liter.i Representante MAC c} 
assign cotas.cod-rep:label in frame f-imp = trim(return-value). 
{utp/ut-liter.i Nome MAC c} 
assign repres.nome-abrev:label in frame f-imp = trim(return-value). 
{utp/ut-liter.i Solicitada MAC c} 
assign de-solicitado:label in frame f-imp = trim(return-value). 
{utp/ut-liter.i Prevista MAC c} 
assign de-prevista:label in frame f-imp = trim(return-value). 
{utp/ut-liter.i Realizada_Pedida MAC c} 
assign de-realiz-pedida:label in frame f-imp = trim(return-value). 
{utp/ut-liter.i %_Solicitada MAC c} 
assign de-perc-solicitado:label in frame f-imp = trim(return-value).
{utp/ut-liter.i %_Prevista MAC c} 
assign de-perc-prev:label in frame f-imp = trim(return-value).
{utp/ut-liter.i Cancelada_Pedida MAC c} 
assign de-cancel-ped:label in frame f-imp = trim(return-value).

{utp/ut-liter.i Representante MAC c} 
assign cotas.cod-rep:label in frame f-imp-int = trim(return-value). 
{utp/ut-liter.i Nome MAC c} 
assign repres.nome-abrev:label in frame f-imp-int = trim(return-value). 
{utp/ut-liter.i Solicitada MAC c} 
assign de-solicitado:label in frame f-imp-int = trim(return-value). 
{utp/ut-liter.i Prevista MAC c} 
assign de-prevista:label in frame f-imp-int = trim(return-value). 
{utp/ut-liter.i Realizada_Pedida MAC c} 
assign de-realiz-pedida:label in frame f-imp-int = trim(return-value). 
{utp/ut-liter.i %_Solicitada MAC c} 
assign de-perc-solicitado:label in frame f-imp-int = trim(return-value).
{utp/ut-liter.i %_Prevista MAC c} 
assign de-perc-prev:label in frame f-imp-int = trim(return-value).
{utp/ut-liter.i Cancelada_Pedida MAC c} 
assign de-cancel-ped:label in frame f-imp-int = trim(return-value).


{utp/ut-liter.i SELE€ÇO * R}
assign c-selecao = trim(return-value).

{utp/ut-liter.i PAR¶METROS * R}
assign c-parametro = trim(return-value).
{utp/ut-liter.i Considera_Cotas_Reprovadas_como_Realizadas * L}
assign tt-param.l-cons-reprov:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Considera_Cotas_Suspensas_como_Realizadas * L}
assign tt-param.l-cons-susp:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Utiliza_casas_decimais * L}
assign tt-param.l-utiliza-decimais:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i IMPRESSÇO * R}
assign c-impressao = trim(return-value).
{utp/ut-liter.i Destino * L}
assign c-destino:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Usu rio * L}
assign tt-param.usuario:label in frame f-parametros = trim(return-value).

/* ************************ Inicio do programa ****************************** */

run utp/ut-trfrrp.p (input frame f-imp-int:handle).
run utp/ut-trfrrp.p (input frame f-imp:handle).
run utp/ut-trfrrp.p (input frame f-tot-total-int:handle).
run utp/ut-trfrrp.p (input frame f-tot-total:handle).
run utp/ut-trfrrp.p (input frame f-total-int:handle).
run utp/ut-trfrrp.p (input frame f-total:handle).
run utp/ut-trfrrp.p (input frame f-tit2:handle).
run utp/ut-trfrrp.p (input frame f-tit:handle).
run utp/ut-trfrrp.p (input frame f-parametros:handle).
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.

run utp/ut-acomp.p persistent set h-acomp.

find empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
if avail empresa then
   assign c-empresa = empresa.razao-social.


assign c-programa = 'ac0418'
       c-destino  = {varinc/var00002.i 04 tt-param.destino}.

{utp/ut-liter.i Relat¢rio_de_Cotas_por_Representante MAP C}
assign c-titulo-relat = return-value.

{include/i-rpout.i}
view frame f-cabec.
view frame f-rodape.

run pi-inicializar in h-acomp (input "Aguarde...").

main-block:
do  on error  undo main-block, leave main-block
    on endkey undo main-block, leave main-block
    on stop   undo main-block, leave main-block:

    for each cotas no-lock
        where   cotas.cod-estabel     >= tt-param.cod-estab-ini
          and   cotas.cod-estabel     <= tt-param.cod-estab-fim
        and   ((cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
          and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim)
          or    cotas.cod-canal-venda  = ? )
        and   ((cotas.cod-gr-cli      >= tt-param.cod-gr-cli-ini
          and   cotas.cod-gr-cli      <= tt-param.cod-gr-cli-fim)
          or    cotas.cod-gr-cli       = ? )
        and   ((cotas.nome-abrev      >= tt-param.nome-abrev-ini
          and   cotas.nome-abrev      <= tt-param.nome-abrev-fim)
          or    cotas.nome-abrev       = ? )          
        and   ((cotas.nome-ab-reg     >= tt-param.nome-ab-reg-ini
          and   cotas.nome-ab-reg     <= tt-param.nome-ab-reg-fim)
          or    cotas.nome-ab-reg      = ? )
        and   ((cotas.nome-mic-reg    >= tt-param.nome-mic-reg-ini
          and   cotas.nome-mic-reg    <= tt-param.nome-mic-reg-fim)
          or    cotas.nome-mic-reg     = ? )
        and    (cotas.cod-rep         >= tt-param.cod-rep-ini
          and   cotas.cod-rep         <= tt-param.cod-rep-fim)
        and     cotas.cd-produto      >= tt-param.cd-produto-ini
          and   cotas.cd-produto      <= tt-param.cd-produto-fim
        and   cotas.dt-inicial        >= tt-param.dt-inicial
          and cotas.dt-inicial        <= tt-param.dt-final
        break by cotas.cod-estabel
              by cotas.cd-produto
              by cotas.cod-rep
              by cotas.dt-inicial :

        run pi-acompanhar in h-acomp (input cotas.cod-rep).

        find first par-cota where
                   par-cota.cod-estabel = cotas.cod-estabel no-lock no-error.
        if not avail par-cota then next. 

        /****** Quebra por Cliente **********************************/ 

        if first-of(cotas.cod-estabel) then do:
           find estabelec where
                estabelec.cod-estabel = cotas.cod-estabel no-lock no-error.

           disp cotas.cod-estabel
                estabelec.nome
                with frame f-tit.
        end. /*if first-of*/     

        /****** Quebra por Produto/Item **********************************/ 


        if first-of(cotas.cd-produto) then do:
          find first produto-coml no-lock where
                     produto-coml.cod-produto-coml = cotas.cd-produto no-error.
          if avail produto-coml then
            assign c-descricao = produto-coml.des-produto-coml.
          else 
          do:
            find first item where 
                 item.it-codigo = cotas.cd-produto no-lock no-error.
            if avail item then 
              assign c-descricao = item.desc-item.
          end.

          disp cotas.cd-produto
               c-descricao with frame f-tit2.
        end.

        /************* Calculo Valores acumulando os itens produtos *******/ 

        if par-cota.tipo-controle = 2 then do: /*controle por valor*/
           assign de-solicitado = de-solicitado + if tt-param.l-utiliza-decimais then cotas.vl-solicitado 
                                                                                 else trunc(cotas.vl-solicitado, 0)
                  de-prevista = de-prevista + if tt-param.l-utiliza-decimais then cotas.vl-previsto
                                                                             else trunc(cotas.vl-previsto, 0)
                  de-realiz-pedida   = de-realiz-pedida   + if tt-param.l-utiliza-decimais then cotas.vl-pedido
                                                                                           else trunc(cotas.vl-pedido, 0)
                  de-cancel-ped      = de-cancel-ped      + if tt-param.l-utiliza-decimais then cotas.vl-ped-canc
                                                                                           else trunc(cotas.vl-ped-canc, 0).
           if tt-param.l-cons-reprov then /*considera reprovados*/
              assign de-realiz-pedida   = de-realiz-pedida + if tt-param.l-utiliza-decimais then cotas.vl-ped-reprov
                                                                                            else trunc(cotas.vl-ped-reprov, 0).
           if tt-param.l-cons-susp then /*considera suspensos*/
              assign de-realiz-pedida   = de-realiz-pedida + if tt-param.l-utiliza-decimais then cotas.vl-ped-susp
                                                                                            else trunc(cotas.vl-ped-susp, 0).
           assign de-perc-solicitado = de-realiz-pedida * 100 / de-solicitado
                  de-perc-prev       = de-realiz-pedida * 100 / de-prevista.
        end.
        else do: /*controle por qtde ou pontos*/
           assign de-solicitado = de-solicitado + if tt-param.l-utiliza-decimais then cotas.qt-solicitado 
                                                                                 else trunc(cotas.qt-solicitado, 0)
                  de-prevista = de-prevista + if tt-param.l-utiliza-decimais then cotas.qt-prevista
                                                                             else trunc(cotas.qt-prevista, 0)
                  de-realiz-pedida   = de-realiz-pedida   + if tt-param.l-utiliza-decimais then cotas.qt-pedida
                                                                                           else trunc(cotas.qt-pedida, 0)
                  de-cancel-ped      = de-cancel-ped      + if tt-param.l-utiliza-decimais then cotas.qt-ped-canc
                                                                                           else trunc(cotas.qt-ped-canc, 0).
           if tt-param.l-cons-reprov then /*considera reprovados*/
              assign de-realiz-pedida   = de-realiz-pedida + if tt-param.l-utiliza-decimais then cotas.qt-ped-reprov
                                                                                            else trunc(cotas.qt-ped-reprov, 0).
           if tt-param.l-cons-susp then /*considera suspensos*/
              assign de-realiz-pedida   = de-realiz-pedida + if tt-param.l-utiliza-decimais then cotas.qt-ped-susp
                                                                                            else trunc(cotas.qt-ped-susp, 0).
           assign de-perc-solicitado = de-realiz-pedida * 100 / de-solicitado
                  de-perc-prev       = de-realiz-pedida * 100 / de-prevista.
        end.

        /********** Quebra de item/produto *****************/ 

        if last-of(cotas.cod-rep) then do:
           find first repres where 
                      repres.cod-rep = cotas.cod-rep no-lock no-error.
           if de-solicitado      < 0 then de-solicitado = 0.
           if de-prevista        < 0 then de-prevista = 0.
           if de-realiz-pedida   < 0 then de-realiz-pedida   = 0.
           if de-cancel-ped      < 0 then de-cancel-ped = 0. 

           if de-perc-solicitado = ? then
              assign de-perc-solicitado = 0.
           if de-perc-prev = ? then 
              assign de-perc-prev = 0.

           assign de-tot-solicitado      = de-tot-solicitado + de-solicitado
                  de-tot-prevista        = de-tot-prevista + de-prevista
                  de-tot-realiz-pedida   = de-tot-realiz-pedida   + de-realiz-pedida
                  de-tot-cancel-ped      = de-tot-cancel-ped + de-cancel-ped
                  de-tot-perc-solicitado = de-tot-realiz-pedida * 100 / de-tot-solicitado
                  de-tot-perc-prev       = de-tot-realiz-pedida * 100 / de-tot-prevista.
           assign tot-solicitado      = tot-solicitado + de-solicitado
                  tot-prevista        = tot-prevista + de-prevista
                  tot-realiz-pedida   = tot-realiz-pedida + de-realiz-pedida
                  tot-cancel-ped      = tot-cancel-ped + de-cancel-ped.      

           if tt-param.l-utiliza-decimais then do:

              disp cotas.cod-rep
                   repres.nome-abrev
                   cotas.dt-inicial
                   de-solicitado 
                   de-prevista 
                   de-realiz-pedida   
                   de-perc-solicitado
                   de-perc-prev
                   de-cancel-ped                 
                   with frame f-imp.
              down with frame f-imp.
           end.
           else do:
               
              disp cotas.cod-rep
                   repres.nome-abrev
                   cotas.dt-inicial
                   de-solicitado 
                   de-prevista 
                   de-realiz-pedida   
                   de-perc-solicitado
                   de-perc-prev
                   de-cancel-ped                 
                   with frame f-imp-int.
              down with frame f-imp-int.
           end.

           assign de-solicitado = 0
                  de-prevista = 0
                  de-realiz-pedida   = 0
                  de-cancel-ped = 0.
        end. /*if last-of*/

        /************** ImpressÆo Valores Totais *************/     

        if last-of(cotas.cd-produto) then do:
           if  de-tot-perc-solicitado = ? then 
               assign de-tot-perc-solicitado = 0.
           if  de-tot-perc-prev = ? then
               assign de-tot-perc-prev = 0.
           if tt-param.l-utiliza-decimais then do:
               
              disp de-tot-solicitado 
                   de-tot-prevista 
                   de-tot-realiz-pedida   
                   de-tot-perc-solicitado
                   de-tot-perc-prev
                   de-tot-cancel-ped
                   with frame f-total.
           end.
           else do:

              disp de-tot-solicitado 
                   de-tot-prevista 
                   de-tot-realiz-pedida   
                   de-tot-perc-solicitado
                   de-tot-perc-prev
                   de-tot-cancel-ped
                   with frame f-total-int. 
           end.             

           assign de-tot-solicitado    = 0
                  de-tot-prevista      = 0
                  de-tot-realiz-pedida = 0
                  de-tot-cancel-ped    = 0.
        end.    

    end. /* for each cotas*/      


end. 

if tt-param.l-utiliza-decimais then
   disp    tot-solicitado 
           tot-prevista 
           tot-realiz-pedida
           tot-cancel-ped
           with frame f-tot-total.
else
   disp    tot-solicitado 
           tot-prevista 
           tot-realiz-pedida
           tot-cancel-ped
           with frame f-tot-total-int.



/* **************** ImpressÆo da p gina de parƒmetros ************* */

if  page-number > 0 then page.

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
        c-parametro
        c-impressao
        c-destino
        tt-param.arquivo
        tt-param.usuario
        with stream-io frame f-parametros.

  if  tt-param.l-cons-reprov = yes then  
      {utp/ut-liter.i Sim * R} 
  else 
      {utp/ut-liter.i NÆo * R}.
  disp trim(return-value) @ tt-param.l-cons-reprov 
       with stream-io frame f-parametros.

  if  tt-param.l-cons-susp = yes then  
      {utp/ut-liter.i Sim * R} 
  else 
      {utp/ut-liter.i NÆo * R}.
  disp trim(return-value) @ tt-param.l-cons-susp 
       with stream-io frame f-parametros.

  if  tt-param.l-utiliza-decimais = yes then  
      {utp/ut-liter.i Sim * R} 
  else 
      {utp/ut-liter.i NÆo * R}.
  disp trim(return-value) @ tt-param.l-utiliza-decimais 
       with stream-io frame f-parametros.

run pi-finalizar in h-acomp.
{include/i-rpclo.i}
RETURN "OK".


