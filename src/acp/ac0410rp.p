/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0410RP 2.00.00.014 } /*** 010014 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AC0410RP MAC}
&ENDIF



{include/i_fnctrad.i}
/*******************************************************************************
**
** Ac0410RP.P : ImpressÆo do relat¢rio de Cotas
**
********************************************************************************/
{utp/ut-glob.i}
/* ************************ Defini‡Æo de vari veis *************************** */

{include/i-rpvar.i}

def var c-processa        as char format "x(20)"              no-undo.
def var c-selecao         as char format "x(11)"              no-undo.
def var c-parametro       as char format "x(14)"              no-undo.
def var c-repres          as char format "x(14)"              no-undo.
def var c-partic          as char format "x(15)"              no-undo.
def var c-cota            as char format "x(05)"              no-undo.
def var c-total           as char format "x(05)"              no-undo.
def var c-grupo           as char format "x(13)"               no-undo.
def var c-cliente         as char format "x(08)"              no-undo.
def var c-impressao       as char format "x(12)"              no-undo.
def var c-destino         as char format "x(10)"              no-undo.
def var h-acomp           as handle                           no-undo.
def var de-tot-perc       as decimal format ">>9.99"          no-undo.
def var de-tot-repres     like cotas.qt-prevista              no-undo.
def var de-tot-prevista   like cotas.qt-prevista              no-undo.
def var de-qt-prev-canal  like cotas.qt-prevista              no-undo.
def var de-qt-prev-repres like cotas.qt-prevista              no-undo.

/* ********************  Defini‡Æo de Temp-Table ****************************** */

def temp-table tt-raw-digita
   field raw-digita      as raw.

def temp-table tt-cotas 
   field cod-estabel     like cotas.cod-estabel
   field cod-canal-venda like cotas.cod-canal-venda
   field cod-gr-cli      like cotas.cod-gr-cli
   field nome-abrev      like cotas.nome-abrev
   field cod-rep         like cotas.cod-rep
   field prevista        like cotas.qt-prevista
   INDEX grupo IS PRIMARY 
                  cod-estabel
                  cod-canal-venda
                  cod-gr-cli
                  nome-abrev
                  cod-rep ASCENDING.

{acp/ac0410.i}  /* Defini‡Æo da Temp-table tt-param */

def buffer b-tt-repres for tt-cotas.  
def buffer b-tt-canal  for tt-cotas.

/* ************************ Defini‡Æo de parametros ************************** */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

/* *********** Defini‡Æo do layout da p gina de parƒmetros ****************** */

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
     tt-param.cod-rep-ini                colon 40 space(12) "|< >|"
     tt-param.cod-rep-fim             no-label colon 73 skip
     tt-param.dt-inicial                 colon 40 space(7) "|< >|"
     tt-param.dt-final                no-label colon 73 skip     
     c-parametro no-label    skip(1)
     tt-param.imprime        colon 40 skip(1)
     c-impressao             no-label skip(1)
     c-destino               colon 40
     " - ":U
     tt-param.arq-destino no-label format "x(60)":U skip
     tt-param.usuario        colon 40 skip
     with down no-box side-labels width 132 stream-io frame f-parametros.

FORM tt-cotas.cod-estabel
     estabelec.nome no-label at 22 skip
     tt-cotas.cod-canal-venda at 01
     canal-venda.descricao no-label at 22 skip(1)
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
{utp/ut-liter.i Processando * L}
assign c-processa = trim(return-value).

{utp/ut-field.i mgdis cotas cod-rep 1}
assign c-repres = trim(return-value).
{utp/ut-liter.i Participa‡Æo * R}
assign c-partic = trim(return-value).
{utp/ut-liter.i Cota * R}
assign c-cota = trim(return-value).
{utp/ut-liter.i Grupo_Cliente * R}
assign c-grupo = trim(return-value).
{utp/ut-liter.i Cliente * R}
assign c-cliente = trim(return-value).
{utp/ut-liter.i Total * R}
assign c-total = trim(return-value).
{utp/ut-liter.i Imprime_Layout * R}
assign tt-param.imprime:label in frame f-parametros = trim(return-value).

/* ************************ Inicio do programa ****************************** */
run utp/ut-trfrrp.p (input frame f-parametros:handle).
run utp/ut-trfrrp.p (input frame f-canal:handle).
{include/i-rpcab.i}
create tt-param.
raw-transfer raw-param to tt-param no-error.

run utp/ut-acomp.p persistent set h-acomp.
find empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
if avail empresa then
   assign c-empresa = empresa.razao-social.

{utp/ut-liter.i Cotas MAP C}
assign c-programa = 'ap0410'
       c-sistema  = return-value.

case tt-param.destino:
   when 1 then do:
       {utp/ut-liter.i Impressora *} 
        assign c-destino = return-value.
   end.
   when 2 then do:
       {utp/ut-liter.i Arquivo *} 
        assign c-destino = return-value.
   end.
   when 3 then do:
       {utp/ut-liter.i Terminal *} 
        assign c-destino = return-value.
   end.
end.


{utp/ut-liter.i Relat¢rio_de_Cotas_Previstas MAP C}
assign c-titulo-relat = return-value.

{include/i-rpout.i &tofile=tt-param.arq-destino}
view frame f-cabec.
view frame f-rodape.
{utp/ut-liter.i Aguarde... *}

run pi-inicializar in h-acomp (input  Return-value ).
main-block:
do  on error  undo main-block, leave main-block
    on endkey undo main-block, leave main-block
    on stop   undo main-block, leave main-block:

    for each cotas no-lock
        where cotas.cod-estabel       >= tt-param.cod-estab-ini
          and cotas.cod-estabel       <= tt-param.cod-estab-fim
          and ((cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
          and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim)
          or    cotas.cod-canal-venda  = ? )
          and ((cotas.cod-gr-cli      >= tt-param.cod-gr-cli-ini
          and   cotas.cod-gr-cli      <= tt-param.cod-gr-cli-fim)
          or    cotas.cod-gr-cli       = ? )
          and ((cotas.nome-abrev      >= tt-param.nome-abrev-ini
          and   cotas.nome-abrev      <= tt-param.nome-abrev-fim)
          or    cotas.nome-abrev       = ? )          
          and  (cotas.cod-rep         >= tt-param.cod-rep-ini
          and   cotas.cod-rep         <= tt-param.cod-rep-fim
          and   cotas.cod-rep         <> ? )
          and   cotas.dt-inicial      >= tt-param.dt-inicial
          and   cotas.dt-inicial      <= tt-param.dt-final
        break by cotas.cod-estabel
              by cotas.cod-canal-venda
              by cotas.cod-gr-cli
              by cotas.nome-abrev
              by cotas.cod-rep:

        run pi-acompanhar in h-acomp (input cotas.cod-rep).

        find par-cota where par-cota.cod-estabel = cotas.cod-estabel no-lock no-error.
        if not avail par-cota then next.

        find tt-cotas 
             where tt-cotas.cod-estabel     = cotas.cod-estabel
             and   tt-cotas.cod-canal-venda = cotas.cod-canal-venda
             and   tt-cotas.cod-gr-cli      = cotas.cod-gr-cli
             and   tt-cotas.nome-abrev      = cotas.nome-abrev 
             and   tt-cotas.cod-rep         = cotas.cod-rep no-error.

        if not avail  tt-cotas then do:
           create tt-cotas.
           assign tt-cotas.cod-estabel      = cotas.cod-estabel
                  tt-cotas.cod-canal-venda  = cotas.cod-canal-venda
                  tt-cotas.cod-gr-cli       = cotas.cod-gr-cli
                  tt-cotas.nome-abrev       = cotas.nome-abrev
                  tt-cotas.cod-rep          = cotas.cod-rep.
           if par-cota.tipo-controle = 2 /*valor*/ then
              assign tt-cotas.prevista      = cotas.vl-previsto.
           else /*quantidade ou pontos*/
              assign tt-cotas.prevista      = cotas.qt-prevista.
        end.
        else do:
           if par-cota.tipo-controle = 2 /*valor*/ then
              assign tt-cotas.prevista      = tt-cotas.prevista + cotas.vl-previsto.
           else /*quantidade ou pontos*/
              assign tt-cotas.prevista      = tt-cotas.prevista + cotas.qt-prevista.
        end.
    end. /*for each cotas*/


    for each tt-cotas use-index grupo 
        break by tt-cotas.cod-estabel
              by tt-cotas.cod-canal-venda
              by tt-cotas.cod-rep:

        run pi-acompanhar in h-acomp (input tt-cotas.cod-rep).

        /***************** first-of *********************/
        if first-of(tt-cotas.cod-canal-venda) then do:
           disp tt-cotas.cod-estabel                
                with frame f-canal.
           find estabelec no-lock
                where estabelec.cod-estabel = tt-cotas.cod-estabel no-error.
           if avail estabelec then
              disp estabelec.nome 
                   with frame f-canal.         
           disp tt-cotas.cod-canal-venda 
                with frame f-canal.
           find canal-venda no-lock
                where canal-venda.cod-canal-venda = tt-cotas.cod-canal-venda no-error.
           if avail canal-venda then
              disp canal-venda.descricao 
                   with frame f-canal.  

           put c-repres            at 01
               "%":U               at 20
               c-cota              at 41
               c-grupo             at 49
               c-cliente           at 66
               "%"                 at 85
               c-cota              at 105
               "-------------"     at 01
               "------"            at 18
               "-----------------" at 28
               "-------------"     at 49
               "------------"      at 66
               "------"            at 82
               "-----------------" at 92.                             
        end.  /* if first-of */

        assign de-qt-prev-repres = 0
               de-qt-prev-canal  = 0.

        for each b-tt-repres 
            where b-tt-repres.cod-estabel     = tt-cotas.cod-estabel
            and   b-tt-repres.cod-canal-venda = tt-cotas.cod-canal-venda
            and   b-tt-repres.cod-rep         = tt-cotas.cod-rep no-lock:

            assign de-qt-prev-repres = de-qt-prev-repres + b-tt-repres.prevista.

        end.

        if first-of(tt-cotas.cod-rep) then do:
           for each b-tt-canal
               where b-tt-canal.cod-estabel = tt-cotas.cod-estabel
               and   b-tt-canal.cod-canal-venda = tt-cotas.cod-canal-venda:
               assign de-qt-prev-canal = de-qt-prev-canal + b-tt-canal.prevista.
           end.
           put tt-cotas.cod-rep  at 09
               (de-qt-prev-repres * 100) / de-qt-prev-canal  format ">>9.99" at 18
               de-qt-prev-repres at 28 .

           assign de-tot-perc = de-tot-perc + ((de-qt-prev-repres * 100) / de-qt-prev-canal)
                  de-tot-repres = de-tot-repres + de-qt-prev-repres. 
        end.

        put tt-cotas.cod-gr-cli at 60
            tt-cotas.nome-abrev at 66
            (tt-cotas.prevista * 100) / de-qt-prev-repres format ">>9.99" at 82
            tt-cotas.prevista at 92.

        assign de-tot-prevista = de-tot-prevista + tt-cotas.prevista.

        if last-of(tt-cotas.cod-canal-venda) then do:
           put  "------"            at 18
                "-----------------" at 28
                "-----------------" at 92 
                c-total             at 06                              
                de-tot-perc         at 18 
                de-tot-repres       at 28 
                de-tot-prevista     at 92 skip(2).

           if tt-param.imprime = yes then
              put tt-param.texto at 01.

           page.

           assign de-tot-perc = 0
                  de-tot-repres = 0
                  de-tot-prevista = 0.           

        end.
    end.
end.
run pi-finalizar in h-acomp.

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
        tt-param.cod-rep-ini      
        tt-param.cod-rep-fim      
        tt-param.dt-inicial
        tt-param.dt-final
        c-parametro
        c-impressao
        c-destino
        tt-param.arq-destino
        tt-param.usuario
        with frame f-parametros.

if  tt-param.imprime = yes then  
    {utp/ut-liter.i Sim * R} 
else 
    {utp/ut-liter.i NÆo * R}.

disp trim(return-value) @ tt-param.imprime 
     with frame f-parametros.
down with frame f-parametros.

{include/i-rpclo.i}

RETURN "OK".


/* Fim do Programa */


