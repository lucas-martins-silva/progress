/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0401B 2.00.00.019}  /*** 010019 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AC0401B MAC}
&ENDIF



/******************************************************************************
**
**  Programa: AC0401b.p
**
**  Objetivo: Distribui‡Æo de Cotas por produto
**
******************************************************************************/

/* ************************ Defini‡Æo de vari veis *************************** */




def var h-acomp            as handle                       no-undo.
def var c-produto          as character format "x(12)"     no-undo.
def var c-descricao        as character format "x(13)"     no-undo.
def var c-parametro        as character format "x(17)"     no-undo.
def var c-pedido           as character format "x(6)"      no-undo.
def var c-ped-liq          as character format "x(7)"      no-undo.
def var c-faturado         as character format "x(8)"      no-undo.
def var c-canc-reprov        as character format "x(10)"   no-undo.
def var c-fat-canc         as character format "x(9)"      no-undo.
def var c-suspensos        as character format "x(9)"      no-undo.
def var c-fat-liq          as character format "x(7)"      no-undo.
def var de-pedida-aux      like cotas.qt-pedida            no-undo.   
def var de-faturada-aux    like cotas.qt-faturada          no-undo.   
def var de-tot-prev        like cotas.qt-prevista          no-undo.
def var de-tot-ori         like cotas.qt-original          no-undo.
def var de-tot-ped         like cotas.qt-pedida            no-undo.
def var de-tot-fat         like cotas.qt-faturada          no-undo.
def var de-tot-fat-canc    like cotas.qt-faturada          no-undo.
def var de-tot-susp-canc   like cotas.qt-faturada          no-undo.
def var c-total            as character                    no-undo.
def var de-perc-canc       as decimal  format "->>>>>9.99" no-undo.
def var de-perc-ped        as decimal  format "->>>>>9.99" no-undo.
def var de-perc-fat        as decimal  format "->>>>>9.99" no-undo.
def var de-tot-perc-ped    as decimal  format "->>>>>9.99" no-undo.
def var de-tot-perc-fat    as decimal  format "->>>>>9.99" no-undo.

{cdp/cdcfgdis.i} /*include para pr‚-processadores*/

/* ********************  Defini‡Æo de Temp-Table ****************************** */

{acp/ac0401.i}  /* DefinicÆo tt-param */

def temp-table tt-raw-digita
    field raw-digita    as raw.

def buffer b-par-cota for par-cota.

{acp/ac9000.i}    

/* ************************ Defini‡Æo de parametros ********************* */

def input-output parameter raw-param as raw no-undo.         


/* ************************ Defini‡Æo de literais *********************** */
create tt-param.
raw-transfer raw-param to tt-param no-error.

{utp/ut-liter.i Item/Produto * R}
assign c-produto = trim(return-value).

{utp/ut-liter.i Representante * R}
assign c-descricao = trim(return-value).

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

{utp/ut-liter.i Pedido * R}
assign c-pedido = trim(return-value).

{utp/ut-liter.i L¡quido * R}
assign c-ped-liq = trim(return-value)
       c-fat-liq = trim(return-value).

{utp/ut-liter.i Faturado * R}
assign c-faturado = trim(return-value).

&IF DEFINED (bf_dis_adm_cotas) &THEN                
 {utp/ut-liter.i Canc/Repr * R}
 assign c-canc-reprov = trim(return-value).
&ELSE
 {utp/ut-liter.i Cancelado * R}
 assign c-canc-reprov = trim(return-value).
&ENDIF

 {utp/ut-liter.i Cancelado * R}
assign c-fat-canc = trim(return-value).

{utp/ut-liter.i Suspensos * R}
assign c-suspensos = trim(return-value).

{utp/ut-liter.i Total * R}
assign c-total = trim(return-value).

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
        break by cotas.cd-produto
              by cotas.cod-rep:

        run pi-acompanhar in h-acomp (cotas.cd-produto).

        {acp/ac9001.i &param-cota=no}

        if first-of(cotas.cd-produto) then do:
           if LINE-COUNTER >= 57 then page.

           PUT  skip(1) c-produto " : " cotas.cd-produto "  -  "  .

           &if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */
              find first produto-coml no-lock where
                         produto-coml.cod-produto-coml = cotas.cd-produto no-error.
              if avail produto-coml then
                 PUT  produto-coml.des-produto-coml format "x(40)" at 37.  
              ELSE
           &else
              find first produto no-lock where
                         produto.cd-produto = cotas.cd-produto no-error.
              if avail produto then
                 PUT  produto.descricao  format "x(40)" at 37.
              ELSE
           &endif
                 for first item fields(desc-item) no-lock where
                           item.it-codigo = cotas.cd-produto :
                     PUT item.desc-item format "x(50)" at 37.
                 end.

           put c-suspensos  at 61
               c-descricao  at 01
               c-parametro  at 27
               c-pedido     at 44
               c-canc-reprov  at 61
               "%":U        at 79
               c-ped-liq    at 81
               c-faturado   at 89
               c-fat-canc   at 106
               "%":U        at 124
               c-fat-liq    at 126 
               "-----------------------" at 01 
               "-----------------"       at 26
               "----------------"        at 44
               "----------------"        at 61
               "----------"              at 78
               "----------------"        at 89
               "----------------"        at 106
               "----------"              at 123 skip.
        end.

        find repres no-lock
             where repres.cod-rep = tt-cotas.cod-rep no-error.
        if avail repres then
           put repres.nome format "x(23)" at 01.
        else
           put cotas.cod-rep at 01.   

        assign de-pedida-aux    = tt-cotas.pedida
               de-faturada-aux  = tt-cotas.faturada.

        &IF DEFINED (bf_dis_adm_cotas) &THEN
           if tt-param.considera = yes then 
              assign de-pedida-aux    = (tt-cotas.pedida + (tt-cotas.ped-canc + tt-cotas.ped-susp + tt-cotas.reprovada))
                     de-faturada-aux  = (tt-cotas.faturada + tt-cotas.fat-canc).
        &ELSE
           if tt-param.considera = yes then 
              assign de-pedida-aux    = tt-cotas.pedida + (tt-cotas.ped-canc + tt-cotas.ped-susp  )
                     de-faturada-aux  = tt-cotas.faturada + tt-cotas.fat-canc.        
        &ENDIF

        if ( tt-param.rs-quantidade = 1 and tt-cotas.prevista = 0 )  or
           ( tt-param.rs-quantidade = 2 and tt-cotas.original = 0 ) then
        do:
            de-perc-ped = 0.
            de-perc-fat  = 0.
        end.
        else /*S¢ efetua o c lculo se a divisÆo nÆo for por zero. */
        do:
             assign 
             de-perc-ped = (de-pedida-aux * 100) / if tt-param.rs-quantidade = 1 then tt-cotas.prevista else tt-cotas.original
             de-perc-fat = (de-faturada-aux * 100) / if tt-param.rs-quantidade = 1 then tt-cotas.prevista else tt-cotas.original.
        end.
        if de-perc-ped = ? then assign de-perc-ped = 0.
        if de-perc-fat = ? then assign de-perc-fat = 0.       

        IF tt-param.rs-quantidade = 1 THEN
            put  tt-cotas.prevista at 25 format "->>>>,>>>,>>9.9999".
        ELSE 
            put  tt-cotas.original at 25 format "->>>>,>>>,>>9.9999".

        put  
            tt-cotas.pedida   format ">>>>,>>>,>>9.9999" at 43

           &IF DEFINED (bf_dis_adm_cotas) &THEN
             (tt-cotas.ped-susp + tt-cotas.ped-canc + tt-cotas.reprovada ) format ">>>>,>>>,>>9.9999" at 60 
           &ELSE
             (tt-cotas.ped-susp + tt-cotas.ped-canc ) format ">>>>,>>>,>>9.9999" at 60 
           &ENDIF
             de-perc-ped       format "->>>>>9.99" at 78
             tt-cotas.faturada format "->>>,>>>,>>9.9999" at 88
             tt-cotas.fat-canc format "->>>,>>>,>>9.9999" at 105
             de-perc-fat       format "->>>>>9.99" at 123. 

        assign de-tot-prev      = de-tot-prev + tt-cotas.prevista
               de-tot-ori       = de-tot-ori + tt-cotas.original
               de-tot-ped       = de-tot-ped  + tt-cotas.pedida
               de-tot-fat       = de-tot-fat  + tt-cotas.faturada
               de-tot-fat-canc  = de-tot-fat-canc + tt-cotas.fat-canc.

        &IF DEFINED (bf_dis_adm_cotas) &THEN
           assign de-tot-susp-canc = de-tot-susp-canc + (tt-cotas.ped-susp + tt-cotas.ped-canc + tt-cotas.reprovada).
        &ELSE
           assign de-tot-susp-canc = de-tot-susp-canc + (tt-cotas.ped-susp + tt-cotas.ped-canc).
        &ENDIF

        if avail tt-cotas then 
           delete tt-cotas.

        if last-of(cotas.cd-produto) then do:

           assign de-pedida-aux    = de-tot-ped
                  de-faturada-aux  = de-tot-fat.

           if tt-param.considera = yes then 
              assign de-pedida-aux    = de-pedida-aux + de-tot-susp-canc
                     de-faturada-aux  = de-faturada-aux + de-tot-fat-canc. 

           if ( tt-param.rs-quantidade = 1 and de-tot-prev = 0 )  or
              ( tt-param.rs-quantidade = 2 and de-tot-ori  = 0 ) then
           do:
               de-tot-perc-ped = 0.
               de-tot-perc-fat = 0.
           end.
           else /*S¢ efetua o c lculo se a divisÆo nÆo for por zero. */
           do:
               assign 
               de-tot-perc-ped = ((de-pedida-aux  * 100) /  if tt-param.rs-quantidade = 1 then de-tot-prev else de-tot-ori) 
               de-tot-perc-fat = ((de-faturada-aux * 100) / if tt-param.rs-quantidade = 1 then de-tot-prev else de-tot-ori).
           end.
           if de-tot-perc-ped = ? then assign de-tot-perc-ped = 0.
           if de-tot-perc-fat = ? then assign de-tot-perc-fat = 0.       


           put  skip(1) 
                "-----------------" at 26
                "----------------" at 44
                "----------------" at 61
                "----------"       at 78
                "----------------" at 89
                "----------------" at 106
                "----------"       at 123
                c-total            at 16.

           IF tt-param.rs-quantidade = 1 THEN
               put de-tot-prev format  "->>>>,>>>,>>9.9999"  at 25.
           ELSE 
               put de-tot-ori format  "->>>>,>>>,>>9.9999"  at 25.

           put  

                de-tot-ped         format ">>>>,>>>,>>9.9999" at 43
                de-tot-susp-canc   format ">>>>,>>>,>>9.9999" at 60
                de-tot-perc-ped    format "->>>>>9.99" at 78
                de-tot-fat         format "->>>,>>>,>>9.9999" at 88
                de-tot-fat-canc    format "->>>,>>>,>>9.9999" at 105
                de-tot-perc-fat    format "->>>>>9.99" at 123. 


           assign de-tot-prev = 0
                  de-tot-ori = 0
                  de-tot-ped  = 0
                  de-tot-fat  = 0
                  de-tot-susp-canc = 0
                  de-tot-fat-canc  = 0.

        end.                  
    end.  
end.
run pi-finalizar in h-acomp.
raw-transfer tt-param to raw-param no-error.

