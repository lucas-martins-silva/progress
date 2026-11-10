/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0401A 2.00.00.021}  /*** 010021 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac0401a MAC}
&ENDIF

/******************************************************************************
**
**  Programa: AC0401A.p
**
**  Objetivo: Distribui‡Æo de Cotas por Canal de Vendas
**
******************************************************************************/

/* ************************ Defini‡Æo de vari veis *************************** */

def var h-acomp            as handle                      no-undo.
def var c-tipo-controle    as character format "x(15)"    no-undo.
def var c-descricao        as character format "x(09)"    no-undo.
def var c-parametro        as character format "x(17)"    no-undo.
def var c-pedido           as character format "x(06)"    no-undo.
def var c-ped-liq          as character format "x(07)"    no-undo.
def var c-faturado         as character format "x(08)"    no-undo.
def var c-fat-liq          as character format "x(07)"    no-undo.
def var c-produto          as character format "x(12)"    no-undo.
def var c-estabel          as character format "x(15)"    no-undo.
def var c-un               as character format "x(02)"    no-undo.
def var de-tot-orig        like cotas.qt-original         no-undo.
def var de-tot-prev        like cotas.qt-prevista         no-undo.
def var de-tot-ped         like cotas.qt-pedida           no-undo.
def var de-tot-fat         like cotas.qt-faturada         no-undo.
def var c-total            as character                   no-undo.
def var c-desc-regiao      as character format "x(20)"    no-undo.
def var c-nome-abrev       as character format "x(14)"    no-undo.
def var c-nome-mic-reg     as character format "x(13)"    no-undo.
def var c-cod-canal-venda  as character format "x(13)"    no-undo.
def var c-grupo-cliente    as character format "x(13)"    no-undo.
def var c-canal-venda-desc as character format "x(30)"    no-undo.
def var c-grupo-cliente-desc as character format "x(30)"    no-undo.
def var c-nome-abrev-rep   as character format "x(13)"    no-undo.
def var c-nome-ab-reg      as character format "x(13)"    no-undo.
def var c-repres           as character format "x(13)"    no-undo.
def var de-perc-quant      as decimal   format "->>>>>9.99"  no-undo.
def var de-perc-fatu       as decimal   format "->>>>>9.99"  no-undo.
def var de-tot-perc-quant  as decimal   format "->>>>>9.99"  no-undo.
def var de-tot-perc-fatu   as decimal   format "->>>>>9.99"  no-undo.
def var c-label-1          as character format "x(10)"    no-undo.
def var c-label-2          as character                   no-undo.

/* ********************  Defini‡Æo de Temp-Table ****************************** */

/* defini‡Æo pre-processador */
{cdp/cdcfgdis.i}

{acp/ac0401.i}  /* DefinicÆo tt-param */

def temp-table tt-raw-digita
    field raw-digita    as raw.

{acp/ac9000.i}    

/* ************************ Defini‡Æo de parametros ********************* */

def input-output parameter raw-param as raw no-undo.         

/* *********** Defini‡Æo do layout da p gina de parƒmetros ************** */

/*
Produto          Descri‡Æo          Un  Original ou Previsto         Pedido %L¡quido           Faturado %L¡quido
---------------- ------------------ --  ----------------- ----------------- --------  ----------------- --------
                 Debito direto bran un             0,0000            0,0000   0,00               0,0000   0,00
                                        ----------------- ----------------- --------  ----------------- --------
                             Total                 0,0000            0,0000   0,00               0,0000   0,00

*/

form c-estabel               at 01
     ":":U
     estabelec.nome no-label at 19 
     c-label-1               at 01
     c-tipo-controle         at 11  skip
     c-label-2               at 01
     tt-param.dt-inicial     at 11 space(02) "|< >|"
     tt-param.dt-final  no-label colon 27 skip(1)   
     with no-box no-label no-attr page-top width 132 stream-io frame f-cabecalho.

form c-cod-canal-venda      at 03 
     ":":U
     c-canal-venda-desc  

     c-grupo-cliente        at 03 
     ":":U
     c-grupo-cliente-desc       

     c-nome-abrev           at 51 
     ":":U
     cotas.nome-abrev       

     c-nome-ab-reg          at 03 
     ":":U
     cotas.nome-ab-reg      

     c-nome-mic-reg         at 51 
     " :":U
     cotas.nome-mic-reg    

     c-repres               at 03
     ":":U
     cotas.cod-rep          
     " - " c-nome-abrev-rep 
     skip(1)
     with width 132 no-box no-attr-space stream-io no-label frame f-cotas.   

/* ************************ Defini‡Æo de literais *********************** */

create tt-param.
raw-transfer raw-param to tt-param no-error.

{utp/ut-liter.i Cotas_por * R}
assign c-label-1 = trim(return-value).

{utp/ut-liter.i Per¡odo * R}
assign c-label-2 = trim(return-value).

{utp/ut-field.i mgdis cotas cd-produto 1}
assign c-produto = trim(return-value).

{utp/ut-liter.i Descri‡Æo * R}
assign c-descricao = trim(return-value).

{utp/ut-liter.i Un * R}
assign c-un = trim(return-value).

{utp/ut-field.i mgdis cotas cod-estabel 1}
assign c-estabel = trim(return-value).

{utp/ut-liter.i Pedido * R}
assign c-pedido = trim(return-value).

{utp/ut-liter.i L¡quido * R}
assign c-ped-liq = trim(return-value)
       c-fat-liq = trim(return-value).

{utp/ut-liter.i Faturado * R}
assign c-faturado = trim(return-value).

{utp/ut-liter.i Total * R}
assign c-total = trim(return-value).

{utp/ut-field.i mgdis cotas cod-canal-venda 1}
assign c-cod-canal-venda = trim(return-value).

{utp/ut-field.i mgdis cotas cod-gr-cli 1}
assign c-grupo-cliente = trim(return-value).

{utp/ut-field.i mgdis cotas nome-abrev 1}
assign c-nome-abrev = trim(return-value).

{utp/ut-field.i mgdis cotas nome-ab-reg 1}
assign c-nome-ab-reg = trim(return-value).

{utp/ut-field.i mgdis cotas nome-mic-reg 1}
assign c-nome-mic-reg = trim(return-value).

{utp/ut-field.i mgdis cotas cod-rep 1}
assign c-repres = trim(return-value).

/* Parƒmetro: Calcular Percentual sobre: (Prevista/ Original)*/
IF tt-param.rs-quantidade = 1 THEN 
DO: 
    {utp/ut-liter.i Previsto * R}
    assign c-parametro = trim(return-value).
END.
ELSE
DO:
    {utp/ut-liter.i Original * R}
    assign c-parametro = trim(return-value).
END.

/* ************************ In¡cio do programa ************************** */


run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Aguarde... *}
run pi-inicializar in h-acomp (input  Return-value ). 
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
          and   cotas.cod-rep         <= tt-param.cod-rep-fim
          and   cotas.cod-rep         <> ? )
        and     cotas.cd-produto      >= tt-param.cd-produto-ini
          and   cotas.cd-produto      <= tt-param.cd-produto-fim
        and   cotas.dt-inicial        >= tt-param.dt-inicial
          and cotas.dt-inicial        <= tt-param.dt-final

        break by cotas.cod-estabel
              by cotas.cod-canal-venda
              by cotas.cod-gr-cli
              by cotas.nome-abrev
              by cotas.nome-ab-reg
              by cotas.nome-mic-reg
              by cotas.cod-rep
              by cotas.cd-produto:

        run pi-acompanhar in h-acomp (cotas.cd-produto).

        {acp/ac9001.i &param-cota=no}
        if first-of(cotas.cod-estabel) then do:
           if par-cota.tipo-controle = 1 then do:
              {utp/ut-liter.i Quantidade * R}
              assign c-tipo-controle = trim(return-value).
           end.
           if par-cota.tipo-controle = 2 then do:
              {utp/ut-liter.i Valor * R}
              assign c-tipo-controle = trim(return-value).
           end.
           if par-cota.tipo-controle = 3 then do:
              {utp/ut-liter.i Pontos * R}
              assign c-tipo-controle = trim(return-value).
           end.

           find estabelec no-lock
                where estabelec.cod-estabel = tt-cotas.cod-estabel no-error.

           disp c-estabel 
                estabelec.nome           
                c-label-1
                c-tipo-controle
                c-label-2
                tt-param.dt-inicial
                tt-param.dt-final
                with stream-io frame f-cabecalho.
        end.
        if first-of(cotas.cod-canal-venda) or first-of(cotas.cod-gr-cli)   or 
           first-of(cotas.nome-abrev)      or first-of(cotas.nome-ab-reg)  or 
           first-of(cotas.nome-mic-reg)    or first-of(cotas.cod-rep)      then do:

           if LINE-COUNTER >= 54 then page.
           disp c-cod-canal-venda with stream-io frame f-cotas.

           find canal-venda no-lock
               where canal-venda.cod-canal-venda = cotas.cod-canal-venda no-error.
           IF cotas.cod-canal-venda = ? THEN
               ASSIGN c-canal-venda-desc = "?".
           ELSE
           IF AVAIL canal-venda THEN  
               ASSIGN c-canal-venda-desc = canal-venda.descricao.

           disp c-canal-venda-desc 
                c-grupo-cliente with stream-io frame f-cotas.

           find gr-cli no-lock where gr-cli.cod-gr-cli = cotas.cod-gr-cli no-error.
           IF cotas.cod-gr-cli = ? THEN
               ASSIGN c-grupo-cliente-desc = "?".
           ELSE
           IF AVAIL gr-cli THEN 
               ASSIGN c-grupo-cliente-desc = gr-cli.descricao.

           disp c-grupo-cliente-desc with stream-io frame f-cotas.

           disp c-nome-abrev
                cotas.nome-abrev
                c-nome-ab-reg
                cotas.nome-ab-reg 
                c-nome-mic-reg 
                cotas.nome-mic-reg 
                c-repres
                cotas.cod-rep 
                with stream-io frame f-cotas.

           find repres no-lock
                where repres.cod-rep = cotas.cod-rep no-error.
           if avail repres then
              assign c-nome-abrev-rep = repres.nome-abrev.
           disp c-nome-abrev-rep with stream-io frame f-cotas.   

           put 
               c-produto            AT 01
               c-descricao          AT 18
               c-un                 AT 37
               c-parametro          AT 50
               c-pedido             AT 71
               "%":U                AT 85
               c-ped-liq            AT 87
               c-faturado           AT 105 
               "%":U                AT 119
               c-fat-liq            AT 121 

               "----------------"       at 01
               "------------------"     at 18
               "--"                     at 37
               "------------------"     at 40
               "------------------"     at 59
               "----------------"       at 78
               "------------------"     at 95
               "--------------"         at 114 
               SKIP.


        end. 

        put cotas.cd-produto  at 01.

        &if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */
          find first produto-coml no-lock where
                     produto-coml.cod-produto-coml = tt-cotas.cd-produto no-error.
          if avail produto-coml then
             put  produto-coml.des-produto-coml format "x(18)" at 18
                  produto-coml.un        at 37.   
          ELSE DO:
        &else
          find first produto no-lock where
                     produto.cd-produto = tt-cotas.cd-produto no-error.
          if avail produto then
             put  produto.descricao format "x(18)" at 18
                  produto.un        at 37.
          ELSE DO:
        &endif

             for first item fields(desc-item un) no-lock where
                       item.it-codigo = tt-cotas.cd-produto :
                 put item.desc-item format "x(18)" at 18
                     item.un          at 37.
             end.
          end.   


        /**************** USO DE PRE-PROCESSADOR *********************/


        &IF DEFINED (bf_dis_adm_cotas) &THEN
           if tt-param.considera = yes then 
              assign tt-cotas.pedida    = tt-cotas.pedida + (tt-cotas.ped-canc + tt-cotas.ped-susp + tt-cotas.reprovada)
                     tt-cotas.faturada  = tt-cotas.faturada + tt-cotas.fat-canc.
        &ELSE
           if tt-param.considera = yes then 
              assign tt-cotas.pedida    = tt-cotas.pedida + (tt-cotas.ped-canc + tt-cotas.ped-susp  )
                     tt-cotas.faturada  = tt-cotas.faturada + tt-cotas.fat-canc.        
        &ENDIF

       if ( tt-param.rs-quantidade = 1 and tt-cotas.prevista = 0 )  or
          ( tt-param.rs-quantidade = 2 and tt-cotas.original = 0 ) then
       do: 
           de-perc-quant = 0.
           de-perc-fatu  = 0.
       end.
       else /*S¢ efetua o c lculo se a divisÆo nÆo for por zero. */
       do:
              assign 
              de-perc-quant = (tt-cotas.pedida * 100) / if tt-param.rs-quantidade = 1 then tt-cotas.prevista else tt-cotas.original
              de-perc-fatu  = (tt-cotas.faturada * 100) / if tt-param.rs-quantidade = 1 then tt-cotas.prevista else tt-cotas.original.

       end.
       if de-perc-quant = ? then assign de-perc-quant = 0.
       if de-perc-fatu  = ? then assign de-perc-fatu  = 0.       

       IF tt-param.rs-quantidade = 1 THEN
            put  tt-cotas.prevista at 40 format "->>>>,>>>,>>9.9999".
        ELSE 
            put  tt-cotas.original at 40 format "->>>>,>>>,>>9.9999".

        put  tt-cotas.pedida   at 59 format "->>>>,>>>,>>9.9999"
             de-perc-quant format "->>>>>9.99" at 84             
             tt-cotas.faturada at 95 format "->>>>,>>>,>>9.9999"
             de-perc-fatu  format "->>>>>9.99" at 118.

        assign de-tot-orig = de-tot-orig + tt-cotas.original
               de-tot-prev = de-tot-prev + tt-cotas.prevista
               de-tot-ped  = de-tot-ped  + tt-cotas.pedida
               de-tot-fat  = de-tot-fat  + tt-cotas.faturada.

        if avail tt-cotas then 
           delete tt-cotas.

        if last-of(cotas.cod-canal-venda) or last-of(cotas.cod-gr-cli)   or 
           last-of(cotas.nome-ab-reg)     or last-of(cotas.nome-mic-reg) or 
           last-of(cotas.cod-rep)         then do:

           if ( tt-param.rs-quantidade = 1 and de-tot-prev = 0 )  or
              ( tt-param.rs-quantidade = 2 and de-tot-orig = 0 ) then
           do:
               de-tot-perc-quant = 0.
               de-tot-perc-fatu  = 0.
           end.
           else /*S¢ efetua o c lculo se a divisÆo nÆo for por zero. */
           do:
               assign 
               de-tot-perc-quant = (de-tot-ped * 100) / if tt-param.rs-quantidade = 1 then de-tot-prev else de-tot-orig
               de-tot-perc-fatu  = (de-tot-fat * 100) / if tt-param.rs-quantidade = 1 then de-tot-prev else de-tot-orig.
           end.
           if de-tot-perc-quant = ? then assign de-tot-perc-quant = 0.
           if de-tot-perc-fatu  = ? then assign de-tot-perc-fatu  = 0.       

           put  skip(1)

                "------------------"     at 40
                "------------------"     at 59
                "----------------"       at 78
                "------------------"     at 95
                "--------------"         at 114  
                c-total             at 30.

           IF tt-param.rs-quantidade = 1 THEN
                put  de-tot-prev format  "->>>>,>>>,>>9.9999"  at 40.
            ELSE 
                put  de-tot-orig format  "->>>>,>>>,>>9.9999"  at 40.

           PUT 
                de-tot-ped          at 59 format "->>>>,>>>,>>9.9999"
                de-tot-perc-quant format "->>>>>9.99" at 84 
                de-tot-fat          at 95 format "->>>>,>>>,>>9.9999"
                de-tot-perc-fatu  format "->>>>>9.99" at 118 skip(1).



           assign de-tot-orig = 0
                  de-tot-prev = 0
                  de-tot-ped  = 0
                  de-tot-fat  = 0
                  de-tot-perc-quant = 0 
                  de-tot-perc-fatu  = 0.

        end.


        if last-of(cotas.cod-estabel) then do:
           page.
           hide frame f-cabecalho.
        end.                  
    end.
end.
run pi-finalizar in h-acomp.
raw-transfer tt-param to raw-param no-error.

