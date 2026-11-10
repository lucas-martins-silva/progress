/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0401C 2.00.00.020}  /*** "010020" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AC0401C MAC}
&ENDIF




/******************************************************************************
**
**  Programa: AC0401c.p
**
**  Objetivo: Distribui‡Æo de Cotas por Representante
**
******************************************************************************/

/* ************************ Defini‡Æo de vari veis *************************** */

def var h-acomp            as handle                       no-undo.
def var c-tipo-controle    as character format "x(15)"     no-undo.
def var c-descricao        as character format "x(11)"      no-undo.
def var c-parametro        as character format "x(17)"     no-undo.
def var c-pedido           as character format "x(6)"      no-undo.
def var c-ped-liq          as character format "x(3)"      no-undo.
def var c-faturado         as character format "x(8)"      no-undo.
def var c-cancelado        as character format "x(15)"     no-undo.
def var c-codigo           as character format "x(16)"     no-undo.
def var c-fat-canc         as character format "x(9)"      no-undo.
def var c-suspensos        as character format "x(9)"      no-undo.
def var c-fat-liq          as character format "x(3)"      no-undo.
def var de-tot-prev        like cotas.qt-prevista          no-undo.
def var de-tot-ori         like cotas.qt-original           no-undo.
def var de-tot-ped         like cotas.qt-pedida            no-undo.
def var de-tot-fat         like cotas.qt-faturada          no-undo.
def var de-tot-fat-canc    like cotas.qt-faturada          no-undo.
def var de-tot-susp-canc   like cotas.qt-faturada          no-undo.
def var de-pedida-aux      like cotas.qt-pedida            no-undo.   
def var de-faturada-aux    like cotas.qt-faturada          no-undo.   
def var c-total            as character                    no-undo.
def var de-perc-ped        as decimal  format "->>>>>9.99" no-undo.
def var de-perc-fat        as decimal  format "->>>>>9.99" no-undo.
def var de-tot-perc-ped    as decimal  FORMAT "->>>>>9.99" no-undo.
def var de-tot-perc-fat    as decimal  format "->>>>>9.99" no-undo.

/* ********************  Defini‡Æo de Temp-Table ****************************** */



/* Uso de pre-processador */
{cdp/cdcfgdis.i}

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

{utp/ut-liter.i Descri‡Æo * R}
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

{utp/ut-field.i mgdis cotas qt-pedida 1}
assign c-pedido = trim(return-value).

{utp/ut-liter.i L¡q * R}
assign c-ped-liq = trim(return-value)
       c-fat-liq = trim(return-value).

{utp/ut-liter.i Faturado * R}
assign c-faturado = trim(return-value).

/**************** USO DE PRE-PROCESSADOR *********************/
&IF DEFINED (bf_dis_adm_cotas) &THEN          
    {utp/ut-liter.i Susp/Canc/Repr * R}
    assign c-cancelado = trim(return-value).
&ELSE
    {utp/ut-liter.i Cancelados * R}
    assign c-cancelado = trim(return-value).
&ENDIF

{utp/ut-liter.i Cancelado * R}
assign c-fat-canc = trim(return-value).

{utp/ut-liter.i Suspensos * R}
assign c-suspensos = trim(return-value).

{utp/ut-field.i mgdis cotas cd-produto 1}
assign c-codigo = trim(return-value).

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
        break by cotas.cod-rep
              by cotas.cd-produto:

        run pi-acompanhar in h-acomp (cotas.cod-rep).

        if first-of(cotas.cod-rep) then do:
           if LINE-COUNTER >= 57 then page.
           disp skip(1) cotas.cod-rep at 01 
                with stream-io side-labels frame f-representante.
           find repres no-lock
                where repres.cod-rep = cotas.cod-rep no-error.
           if avail repres then
              disp " - " repres.nome no-label format "x(80)" at 28
                   with width 132 stream-io frame f-representante.

           /**************** USO DE PRE-PROCESSADOR *********************/
           &IF DEFINED (bf_dis_adm_cotas) &THEN          
           put skip(2)
               c-codigo     at 01
               c-descricao  at 18
               c-parametro  at 39
               c-pedido     at 58
               c-cancelado  at 66
               "%":U        at 86
               c-ped-liq    at 88
               c-faturado   at 100
               c-fat-canc   at 115
               "%":U        at 130
               c-fat-liq    at 132 
               "----------------"  at 01
               "------------"      at 18 
               "----------------"  at 31
               "----------------"  at 48
               "---------------"   at 65
               "----------"        at 81
               "----------------"  at 92
               "---------------"   at 109
               "----------"        at 125 .
       &ELSE
           put skip(2)
               c-suspensos  at 68
               c-codigo     at 01
               c-descricao  at 18
               c-parametro  at 39
               c-pedido     at 58
               c-cancelado  at 66
               "%":U        at 86
               c-ped-liq    at 88
               c-faturado   at 100
               c-fat-canc   at 115
               "%":U        at 130
               c-fat-liq    at 132 
               "----------------"  at 01
               "------------"      at 18 
               "----------------"  at 31
               "----------------"  at 48
               "---------------"   at 65
               "----------"        at 81
               "----------------"  at 92
               "---------------"   at 109
               "----------"        at 125 .
       &ENDIF                     
       end.

        {acp/ac9001.i &param-cota=no}

        if avail tt-cotas then do:

            put cotas.cd-produto at 01.   
            
            &if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */
              find first produto-coml no-lock where
                         produto-coml.cod-produto-coml = tt-cotas.cd-produto no-error.
              if avail produto-coml then
                 put  produto-coml.des-produto-coml format "x(13)" at 18.
              ELSE DO:
            &else
              find first produto no-lock where
                         produto.cd-produto = tt-cotas.cd-produto no-error.
              if avail produto then
                 put  produto.descricao format "x(13)" at 18.
              ELSE DO:
            &endif
                 for first item fields(desc-item) no-lock where
                           item.it-codigo = tt-cotas.cd-produto :
                     put item.desc-item format "x(13)" at 18 .
                 end.
              end.   
           
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
                   de-perc-fat = 0.
            end.
            else /*S¢ efetua o c lculo se a divisÆo nÆo for por zero. */
            do:
                assign 
                de-perc-ped = (de-pedida-aux * 100) / if tt-param.rs-quantidade = 1 then tt-cotas.prevista else tt-cotas.original
                de-perc-fat = (de-faturada-aux * 100) / if tt-param.rs-quantidade = 1 then tt-cotas.prevista else tt-cotas.original.
            end.
            if de-perc-ped = ?  then assign de-perc-ped = 0.
            if de-perc-fat = ?  then assign de-perc-fat = 0.
           
           
           /**************** USO DE PRE-PROCESSADOR *********************/
            &IF DEFINED (bf_dis_adm_cotas) &THEN   
                /* Lista reprovada somada a suspensa e cancelada */  
           
                IF tt-param.rs-quantidade = 1 THEN     
                    put  tt-cotas.prevista at 31 FORMAT "->>,>>>,>>9.9999".
                ELSE 
                    put  tt-cotas.original at 31 format "->>,>>>,>>9.9999".                    
           
                PUT
                     tt-cotas.pedida                        format "->>,>>>,>>9.9999"     at 48
                     (tt-cotas.ped-susp + tt-cotas.ped-canc + tt-cotas.reprovada) format  "->>,>>>,>>9.9999" at 64
                     de-perc-ped                            format "->>>>>9.99"           at 81
                     tt-cotas.faturada                      format "->>,>>>,>>9.9999"     at 92
                     tt-cotas.fat-canc                      format "->>,>>>,>>9.9999"     at 108
                     de-perc-fat                            format "->>>>>9.99"           at 125. 
                assign de-tot-prev = de-tot-prev + tt-cotas.prevista
                       de-tot-ori  = de-tot-ori + tt-cotas.original
                       de-tot-ped  = de-tot-ped  + tt-cotas.pedida
                       de-tot-susp-canc = de-tot-susp-canc + (tt-cotas.ped-susp + tt-cotas.ped-canc + tt-cotas.reprovada)
                       de-tot-fat       = de-tot-fat  + tt-cotas.faturada
                       de-tot-fat-canc  = de-tot-fat-canc + tt-cotas.fat-canc.
           
            &ELSE
           
                IF tt-param.rs-quantidade = 1 THEN          
                    put  tt-cotas.prevista at 32 format "->>,>>>,>>9.9999".
                ELSE 
                    put  tt-cotas.original at 32 format "->>,>>>,>>9.9999".                    
           
                put  
                    tt-cotas.pedida                        format "->>,>>>,>>9.9999"     at 48
                    (tt-cotas.ped-susp + tt-cotas.ped-canc)format "->>,>>>,>>9.9999"     at 64
                    de-perc-ped                            format "->>>>>9.99"           at 81
                    tt-cotas.faturada                      format "->>,>>>,>>9.9999"     at 92
                    tt-cotas.fat-canc                      format "->>,>>>,>>9.9999"     at 108
                    de-perc-fat                            format "->>>>>9.99"           at 125. 
           
                assign de-tot-prev = de-tot-prev + tt-cotas.prevista
                       de-tot-ori       = de-tot-ori + tt-cotas.original
                       de-tot-ped  = de-tot-ped  + tt-cotas.pedida
                       de-tot-susp-canc = de-tot-susp-canc + (tt-cotas.ped-susp + tt-cotas.ped-canc)
                       de-tot-fat       = de-tot-fat  + tt-cotas.faturada
                       de-tot-fat-canc  = de-tot-fat-canc + tt-cotas.fat-canc.
            &ENDIF                   

            delete tt-cotas.

        end.
           
        if last-of(cotas.cod-rep) then do:

           assign de-pedida-aux    = de-tot-ped
                  de-faturada-aux  = de-tot-fat.

           if tt-param.considera = yes then 
              assign de-pedida-aux    = de-pedida-aux + de-tot-susp-canc
                     de-faturada-aux  = de-faturada-aux + de-tot-fat-canc. 


           if ( tt-param.rs-quantidade = 1 and de-tot-prev = 0 )  or
              ( tt-param.rs-quantidade = 2 and de-tot-ori = 0 ) then
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
           if de-tot-perc-ped = ?  then assign de-tot-perc-ped = 0.
           if de-tot-perc-fat = ?  then assign de-tot-perc-fat = 0.

            put  skip(1)                  
                "----------------"  at 31
                "----------------"  at 48
                "---------------"   at 65
                "----------"        at 81
                "----------------"  at 92
                "---------------"   at 109
                "----------"        at 125 
                c-total             at 14.

           IF tt-param.rs-quantidade = 1 THEN
               put   de-tot-prev format  "->>,>>>,>>9.9999"  at 31.
           ELSE 
               put   de-tot-ori format   "->>,>>>,>>9.9999"  at 31.

           put                                                                   
               de-tot-ped         format "->>,>>>,>>9.9999" at 48
               de-tot-susp-canc   format "->>,>>>,>>9.9999" at 64
               de-tot-perc-ped    format "->>>>>9.99"       at 81
               de-tot-fat         format "->>,>>>,>>9.9999" at 92 
               de-tot-fat-canc    format "->>,>>>,>>9.9999" at 108
               de-tot-perc-fat    format "->>>>>9.99"       at 125. 


           assign de-tot-prev = 0
                  de-tot-ori  = 0
                  de-tot-ped  = 0
                  de-tot-fat  = 0
                  de-tot-susp-canc = 0
                  de-tot-fat-canc  = 0.

        end.                  
    end.  
end.
run pi-finalizar in h-acomp.
raw-transfer tt-param to raw-param no-error.
