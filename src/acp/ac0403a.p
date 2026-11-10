/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0403A 2.00.00.015}  /*** 010015 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ac0403a MAC}
&ENDIF

/******************************************************************************
**
**  Programa: AC0403A.p
**
**  Objetivo: Comparativo entre peridos por Representantes
**
******************************************************************************/

/* ************************ Defini‡Æo de vari veis *************************** */

def var h-acomp            as handle                      no-undo.
def var dt-inicial         as date format "99/99/9999"    no-undo.
def var dt-final           like cotas.dt-inicial          no-undo.
def var dt-inicial-1       as date format "99/99/9999"    no-undo.
def var dt-final-1         like cotas.dt-inicial          no-undo.
def var c-tipo-controle    as character format "x(15)"    no-undo.
def var c-label-1          as character format "x(18)"    no-undo.
def var c-label-2          as character format "x(18)"    no-undo.
def var c-rep              as character format "x(13)"    no-undo.
def var c-cod-rep          as character format "x(15)"    no-undo.
def var c-previsto         as character format "x(08)"    no-undo.
def var c-pedido           as character format "x(06)"    no-undo.
def var c-ped-liq          as character format "x(03)"    no-undo.
def var c-faturado         as character format "x(08)"    no-undo.
def var c-fat-liq          as character format "x(03)"    no-undo.
def var c-produto          as character format "x(07)"    no-undo.
def var c-variacao         as character format "x(08)"    no-undo.
def var de-varia-prev      like cotas.qt-prevista         no-undo.
def var de-varia-ped       like cotas.qt-pedida           no-undo.
def var de-varia-fat       like cotas.qt-faturada         no-undo.
def var de-tot-prev-1      like cotas.qt-prevista         no-undo.
def var de-tot-ped-1       like cotas.qt-pedida           no-undo.
def var de-tot-fat-1       like cotas.qt-faturada         no-undo.
def var de-tot-prev-2      like cotas.qt-prevista         no-undo.
def var de-tot-ped-2       like cotas.qt-pedida           no-undo.
def var de-tot-fat-2       like cotas.qt-faturada         no-undo.
def var de-perc-ped        as decimal                     no-undo.
def var de-perc-fat        as decimal                     no-undo.
def var de-perc-pedido     as decimal                     no-undo.
def var de-perc-faturado   as decimal                     no-undo.
def var de-tot-perc-ped-1  as decimal                     no-undo.
def var de-tot-perc-fat-1  as decimal                     no-undo.
def var de-tot-perc-fat-2  as decimal                     no-undo.
def var de-tot-perc-ped-2  as decimal                     no-undo.
def var de-tot-perc-prev   as decimal                     no-undo.
def var de-tot-perc-ped    as decimal                     no-undo.
def var de-tot-perc-fat    as decimal                     no-undo.

{cdp/cdcfgdis.i} /*include para pr‚-processadores*/


/* ********************  Defini‡Æo de Temp-Table ****************************** */

{acp/ac0403.i}  /* DefinicÆo tt-param */

def temp-table tt-raw-digita
    field raw-digita    as raw.
    
{acp/ac9000.i}    

define buffer b-cotas for cotas.
define buffer b-par-cota for par-cota.


/* ************************ Defini‡Æo de parametros ********************* */

def input-output parameter raw-param as raw no-undo.         

/* *********** Defini‡Æo do layout da p gina de parƒmetros ************** */

form c-label-1 at 01
     dt-inicial at 20 skip
     c-label-2 at 02
     dt-inicial-1 at 20 skip(1)
     with no-box no-label no-attr page-top width 132 stream-io frame f-cabecalho.


/* ************************ Defini‡Æo de literais *********************** */

{utp/ut-liter.i Primeiro_Per¡odo: * R}
assign c-label-1 = trim(return-value).

{utp/ut-liter.i Segundo_Per¡odo: * R}
assign c-label-2 = trim(return-value).

{utp/ut-field.i mgdis cotas cd-produto 1}
assign c-produto = trim(return-value).

{utp/ut-field.i mgdis cotas cod-rep 1}
assign c-cod-rep = trim(return-value).

{utp/ut-field.i mgdis cotas qt-prevista 1}
assign c-previsto = trim(return-value).

{utp/ut-field.i mgdis cotas qt-pedida 1}
assign c-pedido = trim(return-value).

{utp/ut-liter.i Ped * R}
assign c-ped-liq = trim(return-value).

{utp/ut-liter.i Fat * R}
assign c-fat-liq = trim(return-value).

{utp/ut-liter.i Faturado * R}
assign c-faturado = trim(return-value).

{utp/ut-liter.i Varia‡Æo * R}
assign c-variacao = trim(return-value).

/* ************************ In¡cio do programa ************************** */

create tt-param.
raw-transfer raw-param to tt-param no-error.

          
assign    de-tot-prev-1 = 0
          de-tot-ped-1  = 0
          de-tot-fat-1  = 0          
          de-tot-prev-2 = 0
          de-tot-ped-2  = 0
          de-tot-fat-2  = 0.
          
      
run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Aguarde"). 
main-block:

do  on error  undo main-block, leave main-block
    on endkey undo main-block, leave main-block
    on stop   undo main-block, leave main-block:

    assign dt-inicial   = tt-param.dt-inicial
           dt-inicial-1 = tt-param.dt-final.
 
    disp c-label-1
         dt-inicial 
         c-label-2
         dt-inicial-1
         with stream-io frame f-cabecalho.
         
    /************************************************************ 
    *  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
    ************************************************************/
 
    &if defined (bf_dis_adm_cotas) &then
        for each cotas no-lock
            where   cotas.cod-estabel     >= tt-param.cod-estab-ini
              and   cotas.cod-estabel     <= tt-param.cod-estab-fim
            and   ((cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
              and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim)
              or    cotas.cod-canal-venda  = ? )
            and   ((cotas.cod-gr-cli      >= tt-param.cod-gr-cli-ini
              and   cotas.cod-gr-cli      <= tt-param.cod-gr-cli-fim)
              or    cotas.cod-gr-cli       = ?)
            and   ((cotas.nome-abrev      >= tt-param.nome-abrev-ini
              and   cotas.nome-abrev      <= tt-param.nome-abrev-fim)
              or    cotas.nome-abrev       = ? )
            and   ((cotas.nome-ab-reg     >= tt-param.nome-ab-reg-ini
              and   cotas.nome-ab-reg     <= tt-param.nome-ab-reg-fim)
              or    cotas.nome-ab-reg      = ? )
            and   ((cotas.nome-mic-reg    >= tt-param.nome-mic-reg-ini
              and   cotas.nome-mic-reg    <= tt-param.nome-mic-reg-fim)
              or    cotas.nome-mic-reg     = ? )
            and     cotas.cod-rep         >= tt-param.cod-rep-ini
              and   cotas.cod-rep         <= tt-param.cod-rep-fim
            and     cotas.cd-produto      >= tt-param.cd-produto-ini
              and   cotas.cd-produto      <= tt-param.cd-produto-fim
            and     cotas.dt-inicial       = tt-param.dt-inicial
            break by cotas.cod-estabel
                  by cotas.cod-rep:
    
    &else
        for each cotas no-lock
            where   cotas.cod-estabel     >= tt-param.cod-estab-ini
              and   cotas.cod-estabel     <= tt-param.cod-estab-fim
            and   ((cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
              and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim)
              or    cotas.cod-canal-venda  = ? )
            and   ((cotas.cod-gr-cli      >= tt-param.cod-gr-cli-ini
              and   cotas.cod-gr-cli      <= tt-param.cod-gr-cli-fim)
              or    cotas.cod-gr-cli       = ?)
            and   ((cotas.nome-abrev      >= tt-param.nome-abrev-ini
              and   cotas.nome-abrev      <= tt-param.nome-abrev-fim)
              or    cotas.nome-abrev       = ? )
            and   ((cotas.nome-ab-reg     >= tt-param.nome-ab-reg-ini
              and   cotas.nome-ab-reg     <= tt-param.nome-ab-reg-fim)
              or    cotas.nome-ab-reg      = ? )
            and   ((cotas.nome-mic-reg    >= tt-param.nome-mic-reg-ini
              and   cotas.nome-mic-reg    <= tt-param.nome-mic-reg-fim)
              or    cotas.nome-mic-reg     = ? )
            and   ((cotas.cod-rep         >= tt-param.cod-rep-ini
              and   cotas.cod-rep         <= tt-param.cod-rep-fim)
              or    cotas.cod-rep          = ? )
            and     cotas.cd-produto      >= tt-param.cd-produto-ini
              and   cotas.cd-produto      <= tt-param.cd-produto-fim
            and     cotas.dt-inicial       = tt-param.dt-inicial
            break by cotas.cod-estabel
                  by cotas.cod-rep:
    &endif
        
         run pi-acompanhar in h-acomp (input cotas.cd-produto).
          
         if LINE-COUNTER <= 08 then 
            put c-label-1      format "x(16)"      at 019
                c-label-2      format "x(15)"      at 073
                "%"                  at 116 
                c-variacao           at 118
                skip
                "+" + fill("-",51) + "+"  format "x(53)" at 01
                "+" + fill("-",51) + "+"  format "x(53)" at 55
                "+" + fill("-",22) + "+"  format "x(24)" at 109
                skip
                c-previsto           at 006
                c-pedido             at 021
                "%":U                at 030
                c-ped-liq            at 031
                c-faturado           at 039
                "%":U                at 050
                c-fat-liq            at 051 
                c-previsto           at 060
                c-pedido             at 075
                "%":U                at 084
                c-ped-liq            at 085
                c-faturado           at 093
                "%":U                at 104
                c-fat-liq            at 105
                c-previsto           at 109 
                c-pedido             at 118
                c-faturado           at 125
                "-------------"      at 001
                "------------"       at 015
                "------"             at 028
                "------------"       at 035
                "------"             at 048
                "-------------"      at 055
                "------------"       at 069
                "------"             at 082
                "------------"       at 089
                "------"             at 102
                "--------"           at 109
                "------"             at 118
                "--------"           at 125
                skip.
                
         {acp/ac9001.i &param-cota=no}

         find repres no-lock
             where repres.cod-rep = tt-cotas.cod-rep no-error.
             
         if first-of(cotas.cod-rep) then
            put skip(01)
                c-cod-rep               at 01
                ":"
                cotas.cod-rep           at 19 
                " - "repres.nome-abrev  at 28 skip(01) .
                
         assign de-perc-ped = (tt-cotas.pedida * 100) / tt-cotas.prevista    
                de-perc-fat = (tt-cotas.faturada * 100) / tt-cotas.pedida.

         if de-perc-ped = ? then assign de-perc-ped = 0.
         if de-perc-fat = ? then assign de-perc-fat = 0.       

         put tt-cotas.prevista   format ">>,>>>,>>9.99"  at 01
             tt-cotas.pedida     format ">>,>>>,>>9.99"  at 14
             de-perc-ped         format ">>>9.99"        at 27
             tt-cotas.faturada   format "->,>>>,>>9.99"  at 34
             de-perc-fat         format ">>>9.99"        at 47. 
         
         if first-of(cotas.cod-rep) then 
            assign de-tot-prev-1 = 0
                   de-tot-ped-1  = 0
                   de-tot-fat-1  = 0
                   de-tot-prev-2 = 0
                   de-tot-ped-2  = 0
                   de-tot-fat-2  = 0.         
         
         assign de-varia-prev = tt-cotas.prevista
                de-varia-ped  = tt-cotas.pedida
                de-varia-fat  = tt-cotas.faturada
                de-tot-prev-1 = de-tot-prev-1 + tt-cotas.prevista
                de-tot-ped-1  = de-tot-ped-1  + tt-cotas.pedida
                de-tot-fat-1  = de-tot-fat-1  + tt-cotas.faturada.    

         if avail tt-cotas then
            delete tt-cotas.
             
         
         find b-cotas no-lock
              where b-cotas.cod-estabel     = cotas.cod-estabel
              and   b-cotas.cod-canal-venda = cotas.cod-canal-venda
              and   b-cotas.cod-gr-cli      = cotas.cod-gr-cli
              and   b-cotas.nome-abrev      = cotas.nome-abrev
              and   b-cotas.nome-ab-reg     = cotas.nome-ab-reg
              and   b-cotas.nome-mic-reg    = cotas.nome-mic-reg
              and   b-cotas.cod-rep         = cotas.cod-rep
              and   b-cotas.cd-produto      = cotas.cd-produto
              and   b-cotas.dt-inicial      = tt-param.dt-final no-error.
              
         if avail b-cotas then
            run atualiza-tt-cotas.
         else
            next.
         
         assign de-varia-prev = ((tt-cotas.prevista - de-varia-prev) * 100) / de-varia-prev
                de-varia-ped  = ((tt-cotas.pedida   - de-varia-ped)  * 100) / de-varia-ped
                de-varia-fat  = ((tt-cotas.faturada - de-varia-fat) * 100)  / de-varia-fat 
                de-tot-prev-2 = de-tot-prev-2 + tt-cotas.prevista
                de-tot-ped-2  = de-tot-ped-2  + tt-cotas.pedida
                de-tot-fat-2  = de-tot-fat-2  + tt-cotas.faturada.    
         
         if de-varia-prev = ? then assign de-varia-prev = 0.
         if de-varia-ped  = ? then assign de-varia-ped  = 0.
         if de-varia-fat  = ? then assign de-varia-fat  = 0.
         
         assign de-perc-pedido   = (tt-cotas.pedida * 100) / tt-cotas.prevista           
                de-perc-faturado = (tt-cotas.faturada * 100) / tt-cotas.pedida.
         
         if de-perc-pedido = ? then assign de-perc-pedido = 0.
         if de-perc-faturado = ? then assign de-perc-faturado = 0.
         
         put tt-cotas.prevista   format ">>,>>>,>>9.99"  at 55
             tt-cotas.pedida     format ">>,>>>,>>9.99"  at 68
             de-perc-pedido      format ">>>9.99"        at 81
             tt-cotas.faturada   format "->,>>>,>>9.99"  at 88
             de-perc-faturado    format ">>>9.99"        at 101
             de-varia-prev       format "->>9.99"        at 110
             de-varia-ped        format "->>9.99"        at 117
             de-varia-fat        format "->>9.99"        at 126. 
             
         if avail tt-cotas then
            delete tt-cotas.
             
         if last-of(cotas.cod-rep) then do:
            assign de-tot-perc-ped-1 = (de-tot-ped-1 * 100) / de-tot-prev-1
                   de-tot-perc-fat-1 = (de-tot-fat-1 * 100) / de-tot-ped-1
                   de-tot-perc-ped-2 = (de-tot-ped-2 * 100) / de-tot-prev-2
                   de-tot-perc-fat-2 = (de-tot-fat-2 * 100) / de-tot-ped-2
                   de-tot-perc-prev  = (de-tot-prev-2 - de-tot-prev-1) * 100 / de-tot-prev-1
                   de-tot-perc-ped   = (de-tot-ped-2 - de-tot-ped-1)   * 100 / de-tot-ped-1
                   de-tot-perc-fat   = (de-tot-fat-2 - de-tot-fat-1)   * 100 / de-tot-fat-1   .
            
            if de-tot-perc-ped-1 = ? then assign de-tot-perc-ped-1 = 0.
            if de-tot-perc-fat-1 = ? then assign de-tot-perc-fat-1 = 0.
            if de-tot-perc-ped-1 = ? then assign de-tot-perc-ped-2 = 0.
            if de-tot-perc-fat-2 = ? then assign de-tot-perc-fat-2 = 0.
            if de-tot-perc-prev  = ? then assign de-tot-perc-prev  = 0.
            if de-tot-perc-ped   = ? then assign de-tot-perc-ped   = 0.
            if de-tot-perc-fat   = ? then assign de-tot-perc-fat   = 0.

            put "-------------"      at 001
                "------------"       at 015
                "------"             at 028
                "------------"       at 035
                "------"             at 048
                "-------------"      at 055
                "------------"       at 069
                "------"             at 082
                "------------"       at 089
                "------"             at 102
                "--------"           at 109
                "------"             at 118
                "--------"           at 125 skip
                de-tot-prev-1                       format ">>,>>>,>>9.99"  at 01
                de-tot-ped-1                        format ">>,>>>,>>9.99"  at 14
                de-tot-perc-ped-1                   format ">>>9.99"        at 27
                de-tot-fat-1                        format "->,>>>,>>9.99"  at 34
                de-tot-perc-fat-1                   format ">>>9.99"        at 47
                de-tot-prev-2                       format ">>,>>>,>>9.99"  at 55
                de-tot-ped-2                        format ">>,>>>,>>9.99"  at 68
                de-tot-perc-ped-2                   format ">>>9.99"        at 81
                de-tot-fat-2                        format "->,>>>,>>9.99"  at 88 
                de-tot-perc-fat-2                   format ">>>9.99"        at 101
                de-tot-perc-prev                    format "->>9.99"        at 110
                de-tot-perc-ped                     format "->>9.99"        at 117
                de-tot-perc-fat                     format "->>9.99"        at 126
                skip(1). 

         end.   
    end.          
end.
run pi-finalizar in h-acomp.
raw-transfer tt-param to raw-param no-error.

/* ************************ PIïs ************************** */
procedure atualiza-tt-cotas:
/*Faz o mesmo que a include ac9001 para o b-cotas*/
    find first para-ped no-lock no-error.
    if substring(para-ped.char-2,1,3) = "yes" then
       FIND par-cota 
            where par-cota.cod-estabel = para-ped.estab-padrao NO-LOCK NO-ERROR.
    else 
       find par-cota no-lock 
            where par-cota.cod-estabel = b-cotas.cod-estabel no-error.

    if avail par-cota then do:
       find tt-cotas 
            where tt-cotas.cod-estabel     = par-cota.cod-estabel
            and   tt-cotas.cod-canal-venda = b-cotas.cod-canal-venda
            and   tt-cotas.cod-gr-cli      = b-cotas.cod-gr-cli
            and   tt-cotas.nome-abrev      = b-cotas.nome-abrev
            and   tt-cotas.nome-ab-reg     = b-cotas.nome-ab-reg
            and   tt-cotas.nome-mic-reg    = b-cotas.nome-mic-reg
            and   tt-cotas.cod-rep         = b-cotas.cod-rep
            and   tt-cotas.cd-produto      = b-cotas.cd-produto
            and   tt-cotas.dt-inicial      = b-cotas.dt-inicial no-error.
       if not avail tt-cotas then do:
          create tt-cotas.
          assign tt-cotas.cod-estabel     = par-cota.cod-estabel
                 tt-cotas.cod-canal-venda = b-cotas.cod-canal-venda
                 tt-cotas.cod-gr-cli      = b-cotas.cod-gr-cli
                 tt-cotas.nome-abrev      = b-cotas.nome-abrev
                 tt-cotas.nome-ab-reg     = b-cotas.nome-ab-reg
                 tt-cotas.nome-mic-reg    = b-cotas.nome-mic-reg
                 tt-cotas.cod-rep         = b-cotas.cod-rep
                 tt-cotas.cd-produto      = b-cotas.cd-produto
                 tt-cotas.dt-inicial      = b-cotas.dt-inicial
                 tt-cotas.cota-liberada   = b-cotas.cota-liberada
                 tt-cotas.tp-contr        = par-cota.tipo-controle.
       end.
       if par-cota.tipo-controle = 2 then do:
          assign tt-cotas.prevista     = b-cotas.vl-previsto
                 tt-cotas.pedida       = b-cotas.vl-pedido
                 tt-cotas.faturada     = b-cotas.vl-faturado
                 tt-cotas.ped-canc     = b-cotas.vl-ped-canc
                 tt-cotas.fat-canc     = b-cotas.vl-fat-canc
                 tt-cotas.ped-susp     = b-cotas.vl-ped-susp
                 tt-cotas.original     = b-cotas.vl-original
                 tt-cotas.solicitado   = b-cotas.vl-solicitado.
          /************************************************************ 
          *  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
          ************************************************************/
 
          &if defined (bf_dis_adm_cotas) &then
              assign tt-cotas.reprovada = b-cotas.vl-ped-reprov.
          &endif
       end. 
       else do:
          assign tt-cotas.prevista     = b-cotas.qt-prevista
                 tt-cotas.pedida       = b-cotas.qt-pedida
                 tt-cotas.faturada     = b-cotas.qt-faturada
                 tt-cotas.ped-canc     = b-cotas.qt-ped-canc
                 tt-cotas.fat-canc     = b-cotas.qt-fat-canc
                 tt-cotas.ped-susp     = b-cotas.qt-ped-susp
                 tt-cotas.original     = b-cotas.qt-original
                 tt-cotas.solicitado   = b-cotas.qt-solicitado.
          /************************************************************ 
          *  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
          ************************************************************/
 
          &if defined (bf_dis_adm_cotas) &then
              assign tt-cotas.reprovada = b-cotas.qt-ped-reprov.
          &endif
       end. 
    end.
end procedure
