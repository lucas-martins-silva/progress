/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0402B 2.00.00.017 } /*** "010017" 22/05/2025 16:59:46  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac0402b MAC}
&ENDIF

/******************************************************************************
**
**  Programa: AC0402b.p
**
**  Objetivo: Curva ABC de Cotas por Produto
**
******************************************************************************/

/* ************************ Defini‡Æo de vari veis *************************** */

def var h-acomp            as handle                      no-undo.
def var c-imprime          as character                   no-undo.
def var dt-inicial         as date format "99/99/9999"    no-undo.
def var c-tipo-controle    as character format "x(15)"    no-undo.
def var c-label-1          as character format "x(22)"    no-undo.
def var c-label-2          as character format "x(22)"    no-undo.
def var c-descricao        as character format "x(13)"    no-undo.
def var c-cd-produto       as character format "x(16)"    no-undo.
def var c-previsto         as character format "x(8)"     no-undo.
def var c-pedido           as character format "x(6)"     no-undo.
def var c-ped-liq          as character format "x(3)"     no-undo.
def var c-faturado         as character format "x(8)"     no-undo.
def var c-fat-liq          as character format "x(3)"     no-undo.
def var de-tot-prev        like cotas.qt-prevista         no-undo.
def var de-tot-ped         like cotas.qt-pedida           no-undo.
def var de-tot-fat         like cotas.qt-faturada         no-undo.
def var de-tot-prev-clas   like cotas.qt-prevista         no-undo.
def var de-tot-ped-clas    like cotas.qt-pedida           no-undo.
def var de-tot-fat-clas    like cotas.qt-faturada         no-undo.
def var c-total            as character                   no-undo.
def var c-class            as character  format "x(5)"    no-undo.
def var i-cont             as int                         no-undo.
def var de-total-cota      like cotas.qt-prevista         no-undo.
def var de-total-atu       like cotas.qt-prevista         no-undo.
def var de-tot-prev-perc   as decimal                     no-undo.
def var de-tot-ped-perc    as decimal                     no-undo.
def var de-tot-fat-perc    as decimal                     no-undo.

def var de-perc-prev       as decimal                     no-undo.
def var de-perc-ped        as decimal                     no-undo.
def var de-tot-perc-fat    as decimal                     no-undo.
def var de-tot-perc-ped    as decimal                     no-undo.
def var de-perc-fat        as decimal                     no-undo.

def var de-tot-perc-fat-clas as decimal                   no-undo.
def var de-tot-perc-ped-clas as decimal                   no-undo.
def var de-tot-prev-perc-atu as decimal                   no-undo.
def var de-tot-ped-perc-atu  as decimal                   no-undo.
def var de-tot-fat-perc-atu  as decimal                   no-undo.
def var de-tot-per-amost     as decimal                   no-undo.
def var de-total-perc-fat    as decimal                   no-undo.
def var de-total-perc-ped    as decimal                   no-undo.

{cdp/cdcfgdis.i} /*include para pr‚-processadores*/

/* ********************  Defini‡Æo de Temp-Table ****************************** */

{acp/ac0402.i}  /* DefinicÆo tt-param */

def temp-table tt-raw-digita
    field raw-digita    as raw.
    
{acp/ac9000.i}    


DEFINE TEMP-TABLE temp-cotas
   FIELD cd-produto   LIKE cotas.cd-produto
   FIELD descricao    LIKE item.desc-item
   FIELD prevista     LIKE cotas.qt-prevista
   FIELD pedida       LIKE cotas.qt-pedida
   FIELD faturada     LIKE cotas.qt-faturada
   INDEX i-cd-produto IS   PRIMARY  cd-produto ASCENDING.

/* ************************ Defini‡Æo de parametros ********************* */

def input-output parameter raw-param as raw no-undo.         

/* *********** Defini‡Æo do layout da p gina de parƒmetros ************** */

form c-label-1 at 01
     tt-param.perc-amostra at 25  skip
     with no-box no-label no-attr page-top width 132 stream-io frame f-cabecalho.


/* ************************ Defini‡Æo de literais *********************** */

{utp/ut-liter.i Imprimindo * R}
assign c-imprime = trim(return-value).

{utp/ut-liter.i %_Amostra: * R}
assign c-label-1 = trim(return-value).

{utp/ut-liter.i Classificado_por: * R}
assign c-label-2 = trim(return-value).

{utp/ut-liter.i Class * R}
assign c-class = trim(return-value).

{utp/ut-liter.i Descri‡Æo * R}
assign c-descricao = trim(return-value).

{utp/ut-field.i mgdis cotas cd-produto 1}
assign c-cd-produto = trim(return-value).

{utp/ut-field.i mgdis cotas qt-prevista 1}
assign c-previsto = trim(return-value).

{utp/ut-liter.i Pedida * R}
assign c-pedido = trim(return-value).

{utp/ut-liter.i L¡q * R}
assign c-ped-liq = trim(return-value)
       c-fat-liq = trim(return-value).

{utp/ut-liter.i Faturada * R}
assign c-faturado = trim(return-value).

{utp/ut-liter.i Total * R}
assign c-total = trim(return-value).

/************************* In¡cio do programa ***************************/

create tt-param.
raw-transfer raw-param to tt-param no-error.

assign de-total-cota = 0.

if tt-param.perc-amostra <>  0 then
   disp c-label-1 at 08
        tt-param.perc-amostra  at 30
        c-label-2 at 01
        tt-param.desc-classifica-1 no-label at 30 skip(1)
        with stream-io frame f-cabecalho.
       
run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input c-imprime). 
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
        break by cotas.cd-produto:
        
        
        run pi-acompanhar in h-acomp (cotas.cd-produto).
        
        if tt-param.perc-amostra = 0 then leave.
        
        {acp/ac9001.i &param-cota=no}
        
        find temp-cotas no-lock
             where temp-cotas.cd-produto = tt-cotas.cd-produto no-error.
        if avail temp-cotas then do:
           /************************************************************ 
           *  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
           ************************************************************/
 
           &if defined (bf_dis_adm_cotas) &then
               assign temp-cotas.prevista = temp-cotas.prevista + tt-cotas.prevista
                      temp-cotas.pedida   = temp-cotas.pedida   + tt-cotas.pedida - if tt-param.considera then 
                                                                                       tt-cotas.ped-canc + tt-cotas.ped-susp +
                                                                                       tt-cotas.reprovada 
                                                                                    else 0.
                      temp-cotas.faturada = temp-cotas.faturada + tt-cotas.faturada - if tt-param.considera then 
                                                                                         tt-cotas.fat-canc 
                                                                                      else 0.
           &else
               assign temp-cotas.prevista = temp-cotas.prevista + tt-cotas.prevista
                      temp-cotas.pedida   = temp-cotas.pedida   + tt-cotas.pedida - if tt-param.considera then 
                                                                                       tt-cotas.ped-can + tt-cotas.ped-susp 
                                                                                    else 0.
                      temp-cotas.faturada = temp-cotas.faturada + tt-cotas.faturada - if tt-param.considera then 
                                                                                         tt-cotas.fat-canc 
                                                                                      else 0.
           &endif
        end.
        else do:
             
          &if defined (bf_dis_adm_cotas) &then
           find produto-coml no-lock
                where produto-coml.cod-produto-coml = tt-cotas.cd-produto no-error.
           IF NOT AVAIL produto-coml THEN
          &else
           find produto no-lock
                where produto.cd-produto = tt-cotas.cd-produto no-error.
           IF NOT AVAIL produto THEN
          &endif
              find item no-lock
                   where item.it-codigo = tt-cotas.cd-produto no-error.
                 
          create temp-cotas.
          /************************************************************ 
          *  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
          ************************************************************/
 
          &if defined (bf_dis_adm_cotas) &then
              assign temp-cotas.cd-produto  = tt-cotas.cd-produto
                     temp-cotas.descricao   = if avail item then item.desc-item else if avail produto-coml then produto-coml.des-produto-coml else "":U
                     temp-cotas.prevista    = tt-cotas.prevista
                     temp-cotas.pedida      = tt-cotas.pedida - if tt-param.considera then 
                                                                   tt-cotas.ped-canc + tt-cotas.ped-susp +
                                                                   tt-cotas.reprovada
                                                                else 0.
                     temp-cotas.faturada    = tt-cotas.faturada - if tt-param.considera then 
                                                                     tt-cotas.fat-canc 
                                                                  else 0.
          &else
              assign temp-cotas.cd-produto  = tt-cotas.cd-produto
                     temp-cotas.descricao   = if avail item then item.desc-item else if avail produto then produto.descricao else "":U
                     temp-cotas.prevista    = tt-cotas.prevista
                     temp-cotas.pedida      = tt-cotas.pedida - if tt-param.considera then 
                                                                   tt-cotas.ped-can + tt-cotas.ped-susp 
                                                                else 0.
                     temp-cotas.faturada    = tt-cotas.faturada - if tt-param.considera then 
                                                                     tt-cotas.fat-canc 
                                                                  else 0.
          &endif
        end.   
        assign de-total-cota = de-total-cota + if tt-param.classifica-1 = 1 then 
                                                  tt-cotas.prevista 
                                               else if tt-param.classifica-1 = 2 then 
                                                       tt-cotas.pedida 
                                                    else tt-cotas.faturada
               de-tot-prev  = de-tot-prev + tt-cotas.prevista
               de-tot-ped   = de-tot-ped  + tt-cotas.pedida
               de-tot-fat   = de-tot-fat  + tt-cotas.faturada.
                              
        if avail tt-cotas then
           delete tt-cotas.
    end.          
    
    assign i-cont = 0.
    
    if tt-param.classifica-1 = 1 then 
       for each temp-cotas 
           break by temp-cotas.prevista DESCENDING:
           run pi-imprime.
       end.
    else if tt-param.classifica-1 = 2 then
       for each temp-cotas 
           break by temp-cotas.pedida DESCENDING:
           run pi-imprime.
       end.
    else 
       for each temp-cotas 
           break by temp-cotas.faturada DESCENDING:
           run pi-imprime.
       end.

    assign i-cont = i-cont + 1.
    if de-tot-prev-clas > 0 or
       de-tot-prev-clas > 0 or
       de-tot-prev-clas > 0 then do:
     
       assign de-tot-perc-ped-clas = (de-tot-ped-clas * 100) / de-tot-prev-clas
              de-tot-perc-fat-clas = (de-tot-fat-clas * 100) / de-tot-prev-clas.
       if de-tot-perc-ped-clas = ? then assign de-tot-perc-ped-clas = 0.
       if de-tot-perc-fat-clas = ? then assign de-tot-perc-fat-clas = 0.
     
       if tt-param.perc-amostra <> 0 then 
          /* Inicio -- Projeto Internacional */
          DO:
          DEFINE VARIABLE c-lbl-liter-outros AS CHARACTER FORMAT "X(8)" NO-UNDO.
          {utp/ut-liter.i "Outros" *}
          ASSIGN c-lbl-liter-outros = TRIM(RETURN-VALUE).
          put i-cont                at 01 format "999"
              c-lbl-liter-outros              at 24
              de-tot-prev-clas           format ">>>>,>>>,>>9.99"   at 51
              100 - de-tot-prev-perc-atu format ">>9.99"            at 67
              de-tot-ped-clas            format ">>>>,>>>,>>9.99"   at 74
              de-tot-perc-ped-clas       format ">>9.99"            at 90
              100 - de-tot-ped-perc-atu  format ">>9.99"            at 97
              de-tot-fat-clas            format "->>>>,>>>,>>9.99"  at 104
              de-tot-perc-fat-clas       format ">>9.99"            at 120
             100 - de-tot-fat-perc-atu   format ">>9.99"            at 127.
          END. 
    end.   
   
    assign de-total-perc-ped = (de-tot-ped * 100  / de-tot-prev)
           de-total-perc-fat = (de-tot-fat * 100  / de-tot-prev).
   
    if de-total-perc-ped = ? then
       assign de-total-perc-ped = 0.
    if de-total-perc-fat = ? then
       assign de-total-perc-fat = 0.
    
    if tt-param.perc-amostra <> 0 then
        put  "---------------"  at 51
             /*"------"         at 67*/
             "---------------"  at 74
             "------"           at 90
             /*"------"         at 97*/
             "---------------"  at 104
             "------"           at 120
             /*"------"         at 127 */
             c-total            at 30
             de-tot-prev          format ">>>>,>>>,>>9.99" at 51
             de-tot-ped           format ">>>>,>>>,>>9.99"   at 74
             de-total-perc-ped    format ">>9.99"            at 90
             de-tot-fat           format "->>>>,>>>,>>9.99"  at 104
             de-total-perc-fat    format ">>9.99"            at 120 .
         
end.
run pi-finalizar in h-acomp.
raw-transfer tt-param to raw-param no-error.

/* ************************ PIïs ************************** */
procedure pi-imprime:

       if LINE-COUNTER <= 08 then 
            put c-class              at 01
                c-cd-produto         at 07
                c-descricao          at 24
                c-previsto           at 58
                "%":U                at 67
                c-total              at 68
                c-pedido             at 83
                "%":U                at 92
                c-ped-liq            at 93
                "%":U                at 97
                c-total              at 98
                c-faturado           at 111
                "%":U                at 122
                c-fat-liq            at 123 
                "%":U                at 127
                c-total              at 128
                skip
                "-----"              at 01 
                "----------------"   at 07
                "--------------------------"  at 24
                "---------------"    at 51
                "------"             at 67
                "---------------"    at 74
                "------"             at 90
                "------"             at 97
                "---------------"    at 104
                "------"             at 120
                "------"             at 127 
                skip.

        assign de-tot-per-amost = (de-total-atu * 100 / de-total-cota).        
       
        if de-tot-per-amost = ? then 
           assign de-tot-per-amost = 0.
       
        if de-tot-per-amost <= tt-param.perc-amostra 
        then do:
           assign i-cont = i-cont + 1
                  de-perc-prev =     (temp-cotas.prevista * 100) / de-tot-prev
                  de-perc-ped  =     (temp-cotas.pedida   * 100) / temp-cotas.prevista
                  de-tot-perc-ped  = (temp-cotas.pedida   * 100) / de-tot-ped
                  de-perc-fat  =     (temp-cotas.faturada * 100) / temp-cotas.prevista
                  de-tot-perc-fat  = (temp-cotas.faturada * 100) / de-tot-fat.
                  
           if de-perc-prev = ? then 
              assign de-perc-prev = 0.
           if de-perc-ped  = ? then 
              assign de-perc-ped  = 0.
           if de-tot-perc-ped = ? then 
              assign de-tot-perc-ped = 0.
           if de-perc-fat = ? then 
              assign de-perc-fat = 0.
           if de-tot-perc-fat = ? then 
              assign de-tot-perc-fat = 0.

           put i-cont                at 01 format "999"
               temp-cotas.cd-produto at 07
               temp-cotas.descricao  at 24 FORMAT "x(26)" 
               temp-cotas.prevista   format ">>>>,>>>,>>9.99"  at 051                
               de-perc-prev          format ">>9.99"           at 067
               temp-cotas.pedida     format ">>>>,>>>,>>9.99"  at 074
               de-perc-ped           format ">>9.99"           at 090
               de-tot-perc-ped       format ">>9.99"           at 097
               temp-cotas.faturada   format "->>>>,>>>,>>9.99" at 104
               de-perc-fat           format ">>9.99"           at 120 
               de-tot-perc-fat       format ">>9.99"           at 127.
              
           assign de-tot-prev-perc = de-tot-prev-perc + de-perc-prev
                  de-tot-ped-perc  = de-tot-ped-perc  + de-tot-perc-ped                                  
                  de-tot-fat-perc  = de-tot-fat-perc  + de-tot-perc-fat.
              
        end.                  
        else
           assign de-tot-prev-clas  = de-tot-prev-clas + temp-cotas.prevista
                  de-tot-ped-clas   = de-tot-ped-clas  + temp-cotas.pedida
                  de-tot-fat-clas   = de-tot-fat-clas  + temp-cotas.faturada.

        assign de-total-atu = de-total-atu + if tt-param.classifica-1 = 1 then 
                                                temp-cotas.prevista 
                                             else if tt-param.classifica-1 = 2 then 
                                                     temp-cotas.pedida 
                                                  else temp-cotas.faturada.
           
end.
