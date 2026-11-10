/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0407A 2.00.00.013}  /*** 010013 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac0407a MAC}
&ENDIF

/******************************************************************************
**
**  Programa: AC0407A.p
**
**  Objetivo: Curva ABC de Pontos por Cliente
**
******************************************************************************/

/* ************************ Defini‡Æo de vari veis *************************** */

def var h-acomp            as handle                      no-undo.
def var dt-inicial         as date format "99/99/9999"    no-undo.
def var dt-final           as date format "99/99/9999"    no-undo.
def var c-tipo-controle    as character format "x(15)"    no-undo.
def var c-label-1          as character format "x(22)"    no-undo.
def var c-label-2          as character format "x(22)"    no-undo.
def var c-cli              as character format "x(07)"    no-undo.
def var c-pedido           as character format "x(06)"    no-undo.
def var c-suspenso         as character format "x(08)"    no-undo.
def var c-reprovada        as character format "x(09)"    no-undo.
def var c-ped-liq          as character format "x(03)"    no-undo.
def var c-faturado         as character format "x(08)"    no-undo.
def var c-devolvido        as character format "x(09)"    no-undo.
def var c-fat-liq          as character format "x(03)"    no-undo.
def var c-total            as character format "x(05)"    no-undo.
def var c-outros           as character format "x(06)"    no-undo.
def var c-class            as character format "x(05)"    no-undo.
def var i-cont             as int                         no-undo.
def var de-tot-ped         like ped-item.qt-pedida        no-undo.
def var de-tot-susp        like ped-item.qt-pedida        no-undo.
def var de-tot-reprov      like ped-item.qt-pedida        no-undo.
def var de-tot-fat         like ped-item.qt-pedida        no-undo.
def var de-tot-devol       like ped-item.qt-pedida        no-undo.
def var de-tot-ped-clas    like ped-item.qt-pedida        no-undo.
def var de-tot-susp-clas   like ped-item.qt-pedida        no-undo.
def var de-tot-reprov-clas like ped-item.qt-pedida        no-undo.
def var de-tot-fat-clas    like ped-item.qt-pedida        no-undo.
def var de-tot-dev-clas    like ped-item.qt-pedida        no-undo.
def var de-total-ped       like ped-item.qt-pedida        no-undo.
def var de-total-atu       like ped-item.qt-pedida        no-undo.
def var c-it-codigo        like ped-item.it-codigo        no-undo.
def var l-log-produto      as logical                     no-undo.

def var de-pontos          like item-cota.nr-pontos       no-undo.
def var de-valor-aux       like it-nota-fisc.vl-preuni    no-undo.
def var de-quantidade      like est-prod.qt-aplicada      no-undo.
def var de-perc-ped        as decimal                     no-undo.
def var de-perc-fat        as decimal                     no-undo.
def var de-tot-perc-ped    as decimal                     no-undo.
def var de-tot-perc-fat    as decimal                     no-undo.
def var de-perc-amost      as decimal                     no-undo.

{cdp/cdcfgdis.i} /*include para pr‚-processadores*/

/* ********************  Defini‡Æo de Temp-Table ****************************** */

{acp/ac0407.i}  /* DefinicÆo tt-param */

def temp-table tt-raw-digita
    field raw-digita    as raw.

/************************************************************ 
*  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
************************************************************/

&if defined (bf_dis_adm_cotas) &then
    DEFINE TEMP-TABLE temp-pedido
       FIELD nome-abrev  like emitente.nome-abrev
       FIELD pedida      like ped-item.qt-pedida 
       FIELD suspensa    like ped-item.qt-pedida
       FIELD reprovada   like ped-item.qt-pedida
       FIELD faturada    like ped-item.qt-pedida
       FIELD devolvida   like ped-item.qt-pedida
       INDEX nome-cli    IS PRIMARY  nome-abrev  ASCENDING.
&else
    DEFINE TEMP-TABLE temp-pedido
       FIELD nome-abrev  like emitente.nome-abrev
       FIELD pedida      like ped-item.qt-pedida 
       FIELD suspensa    like ped-item.qt-pedida
       FIELD faturada    like ped-item.qt-pedida
       FIELD devolvida   like ped-item.qt-pedida
       INDEX nome-cli    IS PRIMARY  nome-abrev  ASCENDING.
&endif

/* ************************ Defini‡Æo de parametros ********************* */

def input-output parameter raw-param as raw no-undo.         

/* *********** Defini‡Æo do layout da p gina de parƒmetros ************** */

form
    c-label-1            at 06
    tt-param.perc-amostra
    c-label-2            at 11
    tt-param.desc-classifica  skip(1)
    c-class              at 01
    c-cli                at 08
    c-pedido             at 22
    c-suspenso           at 40
    "%":U                at 58
    c-ped-liq            at 59
    c-faturado           at 66
    c-devolvido          at 84
    "%":U                at 102
    c-fat-liq            at 103 
    skip
    "-----"              at 01 
    "------------"       at 08
    "----------------"   at 22
    "----------------"   at 40
    "------"             at 58
    "----------------"   at 66
    "----------------"   at 84
    "------"             at 102
    skip
    with no-box no-label no-attr page-top width 132 stream-io frame f-cabecalho.

form
    c-label-1            at 06
    tt-param.perc-amostra
    c-label-2            at 11
    tt-param.desc-classifica  skip(1)
    c-class              at 01
    c-cli                at 08
    c-pedido             at 22
    c-suspenso           at 40
    c-reprovada          at 58
    "%":U                at 76
    c-ped-liq            at 77
    c-faturado           at 84
    c-devolvido          at 102
    "%":U                at 120
    c-fat-liq            at 121 
    skip
    "-----"              at 01 
    "------------"       at 08
    "----------------"   at 22
    "----------------"   at 40
    "----------------"   at 58
    "------"             at 76
    "----------------"   at 84
    "----------------"   at 102
    "------"             at 120
    skip
    with no-box no-label no-attr page-top width 132 stream-io frame f-cabecalho-2.


/* ************************ Defini‡Æo de literais *********************** */

{utp/ut-liter.i Percentual_de_Amostra: * R}
assign c-label-1 = trim(return-value).

{utp/ut-liter.i Classificado_por: * R}
assign c-label-2 = trim(return-value).

{utp/ut-liter.i Cliente * R}
assign c-cli = trim(return-value).

{utp/ut-liter.i Class * R}
assign c-class = trim(return-value).

{utp/ut-liter.i Pedido * R}
assign c-Pedido = trim(return-value).

{utp/ut-liter.i Suspenso * R}
assign c-suspenso = trim(return-value).

{utp/ut-liter.i Reprovada * R}
assign c-reprovada = trim(return-value).

{utp/ut-liter.i L¡q * R}
assign c-ped-liq = trim(return-value)
       c-fat-liq = trim(return-value).

{utp/ut-liter.i Faturado * R}
assign c-faturado = trim(return-value).

{utp/ut-liter.i Devolvido *  R}
assign c-devolvido = trim(return-value).

{utp/ut-liter.i Total * R}
assign c-total = trim(return-value).

{utp/ut-liter.i Outros * R}
assign c-outros = trim(return-value).


/* ************************ In¡cio do programa ************************** */

create tt-param.
raw-transfer raw-param to tt-param no-error.

assign de-total-ped = 0.

/************************************************************ 
*  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
************************************************************/

&if defined (bf_dis_adm_cotas) &then
    if tt-param.perc-amostra <> 0 then do:
       disp c-label-1
            tt-param.perc-amostra    
            c-label-2 
            tt-param.desc-classifica 
            c-class
            c-cli                
            c-pedido             
            c-suspenso
            c-reprovada
            c-ped-liq            
            c-faturado           
            c-devolvido          
            c-fat-liq            
            with frame f-cabecalho-2.
    end.
&else
    if tt-param.perc-amostra <> 0 then
       disp c-label-1
            tt-param.perc-amostra    
            c-label-2 
            tt-param.desc-classifica 
            c-class
            c-cli                
            c-pedido             
            c-suspenso           
            c-ped-liq            
            c-faturado           
            c-devolvido          
            c-fat-liq            
            with frame f-cabecalho.
&endif

run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Aguarde... *}
run pi-inicializar in h-acomp (input  Return-value ). 

main-block:

do  on error  undo main-block, leave main-block
    on endkey undo main-block, leave main-block
    on stop   undo main-block, leave main-block:

    if tt-param.classifica = 1 then do:

        /***************** PEDIDOS ***********************/
        /* Lˆ atu-cota, pois possui as informa‡äes de pedidos */

        /************************************************************ 
        *  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
        ************************************************************/

        &if defined (bf_dis_adm_cotas) &then
            for each  atu-cota no-lock
                where atu-cota.nome-abrev >= tt-param.cliente-ini
                and   atu-cota.nome-abrev <= tt-param.cliente-fim
                and   atu-cota.dt-inicial >= tt-param.dt-inicial
                and   atu-cota.dt-inicial <= tt-param.dt-final
                and   atu-cota.cod-rep    <> ?:
        &else
            for each  atu-cota no-lock
                where atu-cota.nome-abrev >= tt-param.cliente-ini
                and   atu-cota.nome-abrev <= tt-param.cliente-fim
                and   atu-cota.dt-inicial >= tt-param.dt-inicial
                and   atu-cota.dt-inicial <= tt-param.dt-final :
        &endif

            run pi-acompanhar in h-acomp (atu-cota.nr-pedcli).

            find par-cota no-lock where
                 par-cota.cod-estabel = atu-cota.cod-estabel no-error.
            if not avail par-cota then next.

            if tt-param.perc-amostra = 0 then leave.

            /* Cria temp-pedido */
            find temp-pedido  
                 where temp-pedido.nome-abrev = atu-cota.nome-abrev no-error.
            if not avail temp-pedido then do:
               create temp-pedido.
               assign temp-pedido.nome-abrev = atu-cota.nome-abrev
                      temp-pedido.pedida     = (if par-cota.tipo-controle = 2 then atu-cota.vl-pedido   else atu-cota.qt-pedida)
                      temp-pedido.suspensa   = (if par-cota.tipo-controle = 2 then atu-cota.vl-ped-susp else atu-cota.qt-ped-susp).

               /************************************************************ 
               *  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
               ************************************************************/

               &if defined (bf_dis_adm_cotas) &then
                   assign temp-pedido.reprovada = (if par-cota.tipo-controle = 2 then atu-cota.vl-ped-reprov else atu-cota.qt-ped-reprov).

               &endif
            end.
            else do:
               assign temp-pedido.pedida   = temp-pedido.pedida   + (if par-cota.tipo-controle = 2 then atu-cota.vl-pedido   else atu-cota.qt-pedida)
                      temp-pedido.suspensa = temp-pedido.suspensa + (if par-cota.tipo-controle = 2 then atu-cota.vl-ped-susp else atu-cota.qt-ped-susp).

               /************************************************************ 
               *  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
               ************************************************************/

               &if defined (bf_dis_adm_cotas) &then
                   assign temp-pedido.reprovada = temp-pedido.reprovada + (if par-cota.tipo-controle = 2 then atu-cota.vl-ped-reprov else atu-cota.qt-ped-reprov).
               &endif

            end.

            if tt-param.classifica = 1 then
               assign de-total-ped = de-total-ped + (if par-cota.tipo-controle = 2 then atu-cota.vl-pedido   else atu-cota.qt-pedida).

            assign de-tot-ped  = de-tot-ped  +  (if par-cota.tipo-controle = 2 then atu-cota.vl-pedido   else atu-cota.qt-pedida)
                   de-tot-susp = de-tot-susp +  (if par-cota.tipo-controle = 2 then atu-cota.vl-ped-susp else atu-cota.qt-ped-susp).

            /************************************************************ 
            *  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
            ************************************************************/

            &if defined (bf_dis_adm_cotas) &then
                assign de-tot-reprov = de-tot-reprov + (if par-cota.tipo-controle = 2 then atu-cota.vl-ped-reprov else atu-cota.qt-ped-reprov).
            &endif

        end. /*for each atu-cota*/

        for each temp-pedido
            break by temp-pedido.pedida DESCENDING:
            run pi-imprime.
        end.

    end.

    else do: 

        /***********************  FATURADOS *****************************/ 

        for each nota-fiscal no-lock
            where nota-fiscal.nome-ab-cli  >= tt-param.cliente-ini
            and   nota-fiscal.nome-ab-cli  <= tt-param.cliente-fim
            and   nota-fiscal.dt-emis-nota >= tt-param.dt-inicial
            and   nota-fiscal.dt-emis-nota <= tt-param.dt-final
            and  (nota-fiscal.ind-sit-nota  = 3 /*conf*/  or nota-fiscal.ind-sit-nota = 5 /*atucr*/
            or    nota-fiscal.ind-sit-nota  = 6 /*atuof*/ or nota-fiscal.ind-sit-nota = 7 /*atu-est*/):

            run pi-acompanhar in h-acomp (nota-fiscal.nr-nota-fis).

            if tt-param.perc-amostra = 0 then leave.

            find first par-cota no-lock where
                       par-cota.cod-estabel = nota-fiscal.cod-estabel no-error.
            if not avail par-cota then next.

            /*itens da nota*/
            for each it-nota-fisc no-lock of nota-fiscal:

                run pi-acompanhar in h-acomp (it-nota-fisc.it-codigo).

                find ped-item no-lock
                     where ped-item.nome-abrev   = it-nota-fisc.nome-ab-cli
                     and   ped-item.nr-pedcli    = it-nota-fisc.nr-pedcli
                     and   ped-item.nr-sequencia = it-nota-fisc.nr-seq-ped
                     and   ped-item.it-codigo    = it-nota-fisc.it-codigo
                     and   ped-item.cod-sit-com  = 2  no-error.

                find natur-oper where
                     natur-oper.nat-operacao = ped-item.nat-operacao no-lock no-error.
                /* natureza nÆo controla cotas entÆo proximo */                        

                &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
                   if not avail natur-oper or
                      natur-oper.log-atual-cotas = no then next.
                &else
                   if not avail natur-oper                   or
                      substr(natur-oper.char-2,31,1) <> "1"  then  next.
                &endif    

                assign l-log-produto = no.

                /* trata o item. se ‚ item padrÆo ou se ‚ controlado por produto*/
                if not par-cota.cont-produto then do:
                    assign c-it-codigo = par-cota.it-codigo-padrao.
                    find item-cota no-lock
                         where item-cota.it-codigo = it-nota-fisc.it-codigo no-error.
                    if not avail item-cota then next.     
                end.
                else do:
                    find item-cota no-lock
                         where item-cota.it-codigo = it-nota-fisc.it-codigo no-error.
                    if avail item-cota then do:
                       if item-cota.log-produto and
                          par-cota.cont-produto then do : /*controla por produto*/
                          /************************************************************ 
                          *  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
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
                    else /*se nÆo existir item-cota*/ 
                        next.
                end.

                /********** defini‡Æo do nr de pontos ************/
                find first base-cota 
                     where base-cota.cod-estabel = par-cota.cod-estabel 
                     and   base-cota.cd-produto  = c-it-codigo 
                     and   base-cota.dt-inicial <= nota-fiscal.dt-emis-nota no-lock no-error.

                if not avail base-cota then next.

                if par-cota.cont-produto = yes then
                   assign de-pontos = base-cota.nr-pontos.
                else do:
                   find item-cota no-lock
                        where item-cota.it-codigo = it-nota-fisc.it-codigo no-error.
                   assign de-pontos = if avail item-cota then item-cota.nr-pontos else 1. 
                end.
                if l-log-produto = yes then do: /*item controlado por produto*/
                   find item-cota no-lock
                        where item-cota.it-codigo = it-nota-fisc.it-codigo no-error.
                   assign de-pontos = if avail item-cota then item-cota.nr-pontos else 1. 
                end.   
                if par-cota.tipo-controle <> 3 then de-pontos = 1.
                /*****************************************************/

                if par-cota.tipo-controle = 2 then do: /*controla por valor*/
                  /* calcula valor bruto ou liquido*/            
                    if par-cota.tipo-valor = 1 then 
                       assign de-valor-aux = it-nota-fisc.vl-preuni. 
                    else
                       assign de-valor-aux = it-nota-fisc.vl-merc-sicm.
                end. 
                else /*controla por pontos ou quantidade*/
                     assign de-valor-aux = it-nota-fisc.qt-faturada[1] * de-pontos. 

                /************************************************************ 
                *  Pr‚-Processador m¢dulo de Adm. de Cotas - Release 2.03
                ************************************************************/
                &if defined (bf_dis_adm_cotas) &then                
                    /* caso seja controlado por produto */  
                    if l-log-produto then
                       assign de-valor-aux = de-valor-aux * de-quantidade.
                &else 
                    /* caso seja controlado por produto */  
                    if l-log-produto then
                       assign de-valor-aux = de-valor-aux / de-quantidade.
                &endif  

                /***** cria temp-pedido *******/ 
                find temp-pedido where 
                     temp-pedido.nome-abrev = nota-fiscal.nome-ab-cli no-error.
                if not avail temp-pedido then do:
                   create temp-pedido.
                   assign temp-pedido.nome-abrev  = it-nota-fisc.nome-ab-cli
                          temp-pedido.faturada    = de-valor-aux.
                end.
                else
                   assign  temp-pedido.faturada   = temp-pedido.faturada + de-valor-aux.

                if tt-param.classifica = 2 then 
                   assign de-total-ped = de-total-ped + de-valor-aux.

                assign de-tot-fat = de-tot-fat +  de-valor-aux.

                for each devol-cli no-lock of nota-fiscal:
                    assign temp-pedido.devolvida  = temp-pedido.devolvida + devol-cli.qt-devolvida.
                end.
            end.   
        end.
        for each temp-pedido 
            break by temp-pedido.faturada  DESCENDING:
            run pi-imprime.
        end.
    end.

    assign i-cont = i-cont + 1.

    /************************************************************ 
    *  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
    ************************************************************/

    &if defined (bf_dis_adm_cotas) &then
        if de-tot-ped-clas  > 0   or
           de-tot-susp-clas > 0   or
           de-tot-reprov-clas > 0 or
           de-tot-fat-clas  > 0   or
           de-tot-dev-clas  > 0   then
    &else
        if de-tot-ped-clas  > 0 or
           de-tot-susp-clas > 0 or
           de-tot-fat-clas  > 0 or
           de-tot-dev-clas  > 0 then
    &endif

       assign de-tot-perc-ped = (de-tot-ped-clas * 100) / de-tot-ped
              de-tot-perc-fat = (de-tot-fat-clas * 100) / de-tot-fat.

       if de-tot-perc-ped = ? then assign de-tot-perc-ped = 0.
       if de-tot-perc-fat = ? then assign de-tot-perc-fat = 0.

       /************************************************************ 
       *  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
       ************************************************************/

       &if defined (bf_dis_adm_cotas) &then
           if tt-param.perc-amostra <> 0 then 
              put i-cont                              format "999"              at 01
                  c-outros                                                      at 08
                  de-tot-ped-clas                     format ">>>,>>>,>>9.9999" at 22
                  de-tot-susp-clas                    format ">>>,>>>,>>9.9999" at 40
                  de-tot-reprov-clas                  format ">>>,>>>,>>9.9999" at 58
                  de-tot-perc-ped                     format ">>9.99"           at 76
                  de-tot-fat-clas                     format ">>>,>>>,>>9.9999" at 84
                  de-tot-devol                        format ">>>,>>>,>>9.9999" at 102
                  de-tot-perc-fat                     format ">>9.99"           at 120.

           if tt-param.perc-amostra <> 0 then 
              put "----------------"     at 22
                  "----------------"     at 40
                  "----------------"     at 58
                  "----------------"     at 84
                  "----------------"     at 102
                  c-total              at 08
                  de-tot-ped     format ">>>,>>>,>>9.9999"   at 22
                  de-tot-susp    format ">>>,>>>,>>9.9999"   at 40
                  de-tot-reprov  format ">>>,>>>,>>9.9999"   at 58
                  de-tot-fat     format ">>>,>>>,>>9.9999"   at 84
                  de-tot-devol   format ">>>,>>>,>>9.9999"   at 102.
       &else
           if tt-param.perc-amostra <> 0 then 
              put i-cont                              format "999"              at 01
                  c-outros                                                      at 08
                  de-tot-ped-clas                     format ">>>,>>>,>>9.9999" at 22
                  de-tot-susp-clas                    format ">>>,>>>,>>9.9999" at 40
                  de-tot-perc-ped                     format ">>9.99"           at 58
                  de-tot-fat-clas                     format ">>>,>>>,>>9.9999" at 66
                  de-tot-devol                        format ">>>,>>>,>>9.9999" at 84
                  de-tot-perc-fat                     format ">>9.99"           at 102.

           if tt-param.perc-amostra <> 0 then 
              put "----------------"     at 22
                  "----------------"     at 40
                  "----------------"     at 66
                  "----------------"     at 84
                  c-total              at 08
                  de-tot-ped     format ">>>,>>>,>>9.9999"   at 22
                  de-tot-susp    format ">>>,>>>,>>9.9999"   at 40
                  de-tot-fat     format ">>>,>>>,>>9.9999"   at 66
                  de-tot-devol   format ">>>,>>>,>>9.9999"   at 84.
       &endif
end.

/************************************************************ 
*  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
************************************************************/

&if defined (bf_dis_adm_cotas) &then
    hide frame f-cabecalho-2.
&else
    hide frame f-cabecalho.
&endif

run pi-finalizar in h-acomp.
raw-transfer tt-param to raw-param no-error.


/* ************************ PIïs ************************** */
procedure pi-imprime:


        assign de-perc-amost = (de-total-atu * 100 / de-total-ped).
        if de-perc-amost = ? then assign de-perc-amost = 0.

        if de-perc-amost <= tt-param.perc-amostra then do:
           assign i-cont      = i-cont + 1    
                  de-perc-ped = (temp-pedido.pedida * 100) / de-tot-ped
                  de-perc-fat = (temp-pedido.faturada * 100) / de-tot-fat.

           if de-perc-ped = ? then assign de-perc-ped = 0.
           if de-perc-fat = ? then assign de-perc-fat = 0.     

           /************************************************************ 
           *  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
           ************************************************************/

           &if defined (bf_dis_adm_cotas) &then
               put i-cont                  format "999"              at 01
                   temp-pedido.nome-abrev                            at 08
                   temp-pedido.pedida      format ">>>,>>>,>>9.9999" at 22
                   temp-pedido.suspensa    format ">>>,>>>,>>9.9999" at 40
                   temp-pedido.reprovada   format ">>>,>>>,>>9.9999" at 58
                   de-perc-ped             format ">>9.99"           at 76
                   temp-pedido.faturada    format ">>>,>>>,>>9.9999" at 84
                   temp-pedido.devolvida   format ">>>,>>>,>>9.9999" at 102  
                   de-perc-fat             format ">>9.99"           at 120.
           &else
               put i-cont                  format "999"              at 01
                   temp-pedido.nome-abrev                            at 08
                   temp-pedido.pedida      format ">>>,>>>,>>9.9999" at 22
                   temp-pedido.suspensa    format ">>>,>>>,>>9.9999" at 40
                   de-perc-ped             format ">>9.99"           at 58
                   temp-pedido.faturada    format ">>>,>>>,>>9.9999" at 66
                   temp-pedido.devolvida   format ">>>,>>>,>>9.9999" at 84  
                   de-perc-fat             format ">>9.99"           at 102.
           &endif          

        end.  
        else
           /************************************************************ 
           *  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
           ************************************************************/

           &if defined (bf_dis_adm_cotas) &then
               assign de-tot-ped-clas  = de-tot-ped-clas  + temp-pedido.pedida
                      de-tot-susp-clas = de-tot-susp-clas + temp-pedido.suspensa
                      de-tot-reprov-clas = de-tot-reprov-clas + temp-pedido.reprovada
                      de-tot-fat-clas  = de-tot-fat-clas  + temp-pedido.faturada
                      de-tot-dev-clas  = de-tot-dev-clas  + temp-pedido.devolvida.
           &else
               assign de-tot-ped-clas  = de-tot-ped-clas  + temp-pedido.pedida
                      de-tot-susp-clas = de-tot-susp-clas + temp-pedido.suspensa
                      de-tot-fat-clas  = de-tot-fat-clas  + temp-pedido.faturada
                      de-tot-dev-clas  = de-tot-dev-clas  + temp-pedido.devolvida.
           &endif

        assign de-total-atu = de-total-atu + if tt-param.classifica = 1 then 
                                                temp-pedido.pedida      else
                                                temp-pedido.faturada.

end.
