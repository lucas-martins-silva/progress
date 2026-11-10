/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0414RP 2.00.00.012 } /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac0414rp MAC}
&ENDIF

/*******************************************************************************
**
** Ac0414RP.P : ImpressÆo da simula‡ao de saldos para cotas
**
********************************************************************************/
{utp/ut-glob.i}
/* ************************ Defini‡Æo de vari veis *************************** */

{include/i-rpvar.i}
def var r-rd-simula        as rowid                no-undo.
def var c-selecao      as char format "x(11)"      no-undo.
def var c-parametro    as char format "x(14)"      no-undo.
def var c-impressao    as char format "x(12)"      no-undo.
def var c-destino      as char format "x(10)"      no-undo.
def var h-acomp        as handle                   no-undo.
def var c-texto-1      as char    format "x(30)"   no-undo.
def var c-texto-2      as char    format "x(30)"   no-undo.
def var c-origem       as char    format "x(6)"    no-undo.
def var c-dest         as char    format "x(7)"    no-undo.
def var c-repres       as char    format "x(13)"   no-undo.
def var c-ped-cli      as char    format "x(14)"   no-undo.
def var c-nome         as char    format "x(04)"   no-undo.
def var c-seq          as char    format "x(03)"   no-undo.
def var c-item         as char    format "x(05)"   no-undo.
def var c-desc         as char    format "x(09)"   no-undo.
def var c-un           as char    format "x(02)"   no-undo.
def var c-qt-ped       as char    format "x(10)"   no-undo.
def var c-qt-disp      as char    format "x(14)"   no-undo.
def var c-saldo        as char    format "x(05)"   no-undo. 
def var c-nome-estab   as char    format "x(40)"   no-undo.            
def var de-valor-tot   like ped-item.vl-tot-it     no-undo.
def var c-valor-tot    as char    format "x(5)"    no-undo.
def var c-situacao     as char    format "x(09)"   no-undo.
def var c-it-codigo    like cotas.cd-produto       no-undo.
def var l-log-produto  as logical                  no-undo.
def var de-quantidade  like est-prod.qt-aplicada   no-undo.
def var c-cod-estabel  like cotas.cod-estabel      no-undo.
def var de-disp        like cotas.qt-prevista      no-undo.
def var de-saldo-cota  like cotas.qt-pedida        no-undo.
def var l-simula-saldo as logical                  no-undo.
def var de-nr-pontos   like item-cota.nr-pontos    no-undo.
def var r-cotas        as rowid                    no-undo.
def var c-rep-quebra   like ped-venda.no-ab-reppri no-undo.
def var de-pontos      like item-cota.nr-pontos    no-undo.
def var c-tp-contr-lab as char format "x(15)"      no-undo.
def var c-tp-contr     as char format "x(10)"      no-undo.

{cdp/cdcfgdis.i} /*include para pr‚-processadores*/

/* ********************  Defini‡Æo de Temp-Table ****************************** */

define temp-table tt-simula-saldo
    field cod-estabel      like cotas.cod-estabel
    field cod-canal-venda like cotas.cod-canal-venda
    field cd-produto      like cotas.cd-produto
    field cod-gr-cli      like cotas.cod-gr-cli
    field nome-abrev      like emitente.nome-abrev
    field nome-ab-reg     like cotas.nome-ab-reg
    field nome-mic-reg    like cotas.nome-mic-reg
    field cod-rep         like cotas.cod-rep
    field dt-inicial      like cotas.dt-inicial
    field pedida          like cotas.qt-pedida
    field disponivel      like cotas.qt-pedida
    field saldo           like cotas.qt-pedida
    INDEX codigo IS PRIMARY UNIQUE 
          cod-estabel
          cod-canal-venda
          cod-gr-cli
          nome-abrev
          nome-ab-reg
          nome-mic-reg
          cod-rep
          cd-produto
          dt-inicial.

define temp-table tt-param
    field destino          as integer
    field arquivo          as char
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field periodo-ini      like cotas.dt-inicial
    field periodo-fim      like cotas.dt-inicial
    field nao-avaliado     as logical
    field reprovado        as logical
    field nao-aval-cred    as logical
    field aval-cred        as logical
    field aprov-cred       as logical
    field reprov-cred      as logical
    field excedente        as logical
    field wf-desconto      as logical.

def temp-table tt-raw-digita
   field raw-digita      as raw.

/* ************************ Defini‡Æo de parametros ************************** */
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

/* *********** Defini‡Æo do layout da p gina de parƒmetros ****************** */

form skip(1)
     c-repres                  at 01
     ":":U                     at 16    
     ped-venda.no-ab-reppri    at 20 
     c-tp-contr-lab            at 80
     ":":U                     at 98    
     c-tp-contr                at 100
     with  stream-io width 132 no-label attr-space frame f-cabec-repres.

form c-ped-cli              at 01
     c-nome                 at 17
     c-seq                  at 30
     c-item                 at 38   
     c-desc                 at 55
     c-un                   at 74
     c-qt-ped               at 82
     c-qt-disp              at 97
     c-saldo                at 120
     "--------------"       at 01
     "------------"         at 17
     "------"               at 30
     "----------------"     at 38
     "------------------"   at 55
     "--"                   at 74
     "----------------"       at 78
     "------------------"     at 96
     "----------------"       at 115
     with stream-io width 132  no-label page-top attr-space frame f-cabec-colum.

form skip(01)
     c-selecao   no-label     skip(1)
     tt-param.periodo-ini        colon 40 space(11) "|< >|"
     tt-param.periodo-fim     no-label colon 73 skip(1)
     c-parametro no-label     skip(1)
     c-texto-1   no-label        colon 30 skip(1)
     tt-param.nao-aval-cred      colon 40 skip
     tt-param.aval-cred          colon 40 skip
     tt-param.aprov-cred         colon 40 skip
     tt-param.reprov-cred        colon 40 skip(1)
     c-texto-2    no-label       colon 30 skip(1) 
     tt-param.nao-avaliado       colon 40 skip
     tt-param.reprovado          colon 40 skip(1)
     tt-param.excedente          colon 40 
     tt-param.wf-desconto        colon 40 skip(1)
     c-impressao no-label     skip(1)
     c-destino                   colon 40
     " - ":U
     tt-param.arquivo no-label format "x(60)":U skip
     tt-param.usuario        colon 40 skip(4)     
     with down no-box side-labels width 132 stream-io frame f-parametros.


/* *********************** Defini‡Æo de literais  ***************************** */

FIND FIRST para-ped NO-LOCK NO-ERROR.

{utp/ut-liter.i SELE€ÇO * R}
assign c-selecao = trim(return-value).
{utp/ut-liter.i Per¡odo * L}
assign tt-param.periodo-ini:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i PAR¶METROS * R}
assign c-parametro = trim(return-value).

{utp/ut-liter.i Situa‡Æo_Itens_em_Cotas * L}
assign c-texto-1 = return-value.
{utp/ut-liter.i Situa‡Æo_Cr‚dito_Pedido * L}
assign c-texto-2 = return-value.

{utp/ut-liter.i NÆo_Avaliados * L}
assign tt-param.nao-avaliado:label in frame f-parametros = trim(return-value)
       tt-param.nao-aval-cred:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Aprovados * L}
assign tt-param.aprov-cred:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Reprovados * L}
assign tt-param.reprovado:label in frame f-parametros = trim(return-value)
       tt-param.reprov-cred:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Avaliados * L}
assign tt-param.aval-cred:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Somente_Excedentes_do_Saldo * L}
assign tt-param.excedente:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Somente_pedidos_aprovados_WF_desconto * L}
assign tt-param.wf-desconto:label in frame f-parametros = trim(return-value).


{utp/ut-liter.i IMPRESSÇO * R}
assign c-impressao = trim(return-value).
{utp/ut-liter.i Destino * L}
assign c-destino:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Usu rio * L}
assign tt-param.usuario:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Total * L}
assign c-valor-tot = trim(return-value).
{utp/ut-liter.i ORIGEM * L}
assign c-origem = trim(return-value).
{utp/ut-liter.i DESTINO * L}
assign c-dest = trim(return-value).
{utp/ut-field.i mgdis cotas cod-rep 1}
assign c-repres = trim(return-value).
{utp/ut-liter.i Pedido_Cliente * L}
assign c-ped-cli = trim(return-value).
{utp/ut-liter.i Nome * L}
assign c-nome = trim(return-value).
{utp/ut-liter.i Seq * L}
assign c-seq = trim(return-value).
{utp/ut-liter.i Item * L}
assign c-item = trim(return-value).
{utp/ut-liter.i Descri‡Æo * L}
assign c-desc = trim(return-value).
{utp/ut-liter.i Un * L}
assign c-un = trim(return-value).
{utp/ut-liter.i Dispon¡vel * L}
assign c-qt-disp = trim(return-value).
{utp/ut-liter.i Saldo * L}
assign c-saldo = trim(return-value).
{utp/ut-liter.i Quantidade * L}
assign c-qt-ped = trim(return-value).
{utp/ut-field.i mgdis par-cota tipo-controle 1}
assign c-tp-contr-lab = trim(return-value).

/* ************************ Inicio do programa ****************************** */
run utp/ut-trfrrp.p (input frame f-parametros:handle).
run utp/ut-trfrrp.p (input frame f-cabec-repres:handle).
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.

find empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
if avail empresa then
   assign c-empresa = empresa.razao-social.

assign c-programa = 'ap0414'
       c-destino  = {varinc/var00002.i 04 tt-param.destino}.

{utp/ut-liter.i Relat¢rio_Simula‡Æo_Saldos_Cotas MAP C}
assign c-titulo-relat = return-value.

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Aguarde...").

for each ped-venda no-lock 
    where ped-venda.dt-emissao >= tt-param.periodo-ini
    and   ped-venda.dt-emissao <= tt-param.periodo-fim
    by ped-venda.no-ab-reppri  
    by ped-venda.nr-pedcli  :

    find natur-oper where
         natur-oper.nat-operacao = ped-venda.nat-operacao no-lock no-error.
    /* natureza nÆo controla cotas entÆo proximo */                        

    &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
       if not avail natur-oper or
          natur-oper.log-atual-cotas = no  then  next.
    &else
       if not avail natur-oper                   or
          substr(natur-oper.char-2,31,1) <> "1"  then  next.
    &endif    

    /* ****************************************************************** */
    /*** Consiste cfe. os parƒmetros, a situa‡Æo do cr‚dito do pedido  ***/

    if (tt-param.nao-aval-cred = no) and (ped-venda.cod-sit-aval = 1) then
       next.
    if (tt-param.aval-cred     = no) and (ped-venda.cod-sit-aval = 2) then
       next.
    if (tt-param.aprov-cred    = no) and (ped-venda.cod-sit-aval = 3) then
       next.
    if (tt-param.reprov-cred   = no) and (ped-venda.cod-sit-aval = 4) then
       next.
    if ped-venda.cod-sit-aval  = 5 then 
       next.

    /* Desconsidera os pedidos aprovados no WF de desconto */
    IF para-ped.log-usa-aprovac-workflow THEN
       IF (tt-param.wf-desconto = YES) AND (ped-venda.log-aprov-workflow = NO) THEN
          NEXT.

    /************  ITENS DO PEDIDO **********/

    for each ped-item no-lock where
             ped-item.nr-pedcli  = ped-venda.nr-pedcli and
             ped-item.nome-abrev = ped-venda.nome-abrev  :

        find natur-oper where
             natur-oper.nat-operacao = ped-item.nat-operacao no-lock no-error.

        /* natureza nÆo controla cotas entÆo proximo */                        
        &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
           if not avail natur-oper or
              natur-oper.log-atual-cotas = no  then  next.
        &else
           if not avail natur-oper                   or
              substr(natur-oper.char-2,31,1) <> "1"  then  next.
        &endif            

        run pi-acompanhar in h-acomp (ped-item.it-codigo).

        /*** Consiste cfe. parƒmetros a situa‡Æo de avalia‡Æo por cotas ***/
        if (tt-param.nao-avaliado = no) and (ped-item.cod-sit-com = 1) then
           next.
        if (tt-param.reprovado    = no) and (ped-item.cod-sit-com = 3) then
           next.
        if ped-item.cod-sit-com   = 4 then 
           next.

        /* ****************************************************************** */

        find par-cota no-lock where
             par-cota.cod-estabel = ped-venda.cod-estabel no-error.
        if not avail par-cota then
           next.

        find item no-lock
             where item.it-codigo = ped-item.it-codigo no-error.
        if not avail item then 
           next.              

        find emitente no-lock
             where emitente.cod-emitente = ped-venda.cod-emitente no-error.
        if not avail emitente then 
           next.

        find repres no-lock
             where repres.nome-abrev = ped-venda.no-ab-reppri no-error.
        if not avail repres then 
           next.     

        assign l-log-produto = no.
        /* trata o item. se ‚ item padrÆo ou se ‚ controlado por produto*/
        if not par-cota.cont-produto then do:
            assign c-it-codigo = par-cota.it-codigo-padrao.
            find item-cota no-lock
                 where item-cota.it-codigo = ped-item.it-codigo no-error.
            if not avail item-cota then next.     
        end.
        else do:
            find item-cota no-lock
                 where item-cota.it-codigo = ped-item.it-codigo no-error.
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
             and   base-cota.dt-inicial <= (if par-cota.tipo-data = 1 then ped-venda.dt-emissao else ped-item.dt-entrega) NO-LOCK no-error.    
        if not avail base-cota then next.

        if par-cota.cont-produto = yes then
           assign de-pontos = base-cota.nr-pontos.
        else do:
           find item-cota no-lock
                where item-cota.it-codigo = ped-item.it-codigo no-error.
           assign de-pontos = if avail item-cota then item-cota.nr-pontos else 1. 
        end.
        if l-log-produto = yes then do: /*item controlado por produto*/
           find item-cota no-lock
                where item-cota.it-codigo = ped-item.it-codigo no-error.
           assign de-pontos = if avail item-cota then item-cota.nr-pontos else 1. 
        end.   
        if par-cota.tipo-controle <> 3 then de-pontos = 1.
        /*****************************************************/        

        /* leitura de cotas*/
        run acp/acapi004.p (input ped-venda.cod-estabel,
                            input repres.cod-rep,
                            input c-it-codigo,
                            input (if par-cota.tipo-data = 1    then ped-venda.dt-emissao      else ped-item.dt-entrega),
                            input (if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0),
                            input (if par-cota.cont-gr-cli      then ped-venda.cod-gr-cli      else 0),
                            input (if par-cota.cont-cliente     then ped-venda.nome-abrev      else ""),
                            input (if par-cota.cont-ab-reg      then repres.nome-ab-reg        else ""),
                            input (if par-cota.cont-mic-reg     then emitente.nome-mic-reg     else ""),
                            output r-cotas).
        
        IF par-cota.cont-cliente THEN DO:

            FIND cotas NO-LOCK WHERE ROWID(cotas) = r-cotas NO-ERROR.
            IF NOT AVAIL cotas THEN DO:
    
                IF emitente.nome-abrev <> emitente.nome-matriz THEN DO:
                
                    RUN acp/acapi004.p (INPUT ped-venda.cod-estabel,                                                                   
                                        INPUT repres.cod-rep,                                                                          
                                        INPUT c-it-codigo,                                                                             
                                        INPUT (if par-cota.tipo-data = 1    then ped-venda.dt-emissao      else ped-item.dt-entrega),  
                                        INPUT (if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0),                    
                                        INPUT (if par-cota.cont-gr-cli      then ped-venda.cod-gr-cli      else 0),                    
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

           find tt-simula-saldo exclusive-lock where
                tt-simula-saldo.cod-estabel     = cotas.cod-estabel     and
                tt-simula-saldo.cod-canal-venda = cotas.cod-canal-venda and
                tt-simula-saldo.cd-produto      = cotas.cd-produto      and
                tt-simula-saldo.cod-gr-cli      = cotas.cod-gr-cli      and
                tt-simula-saldo.nome-abrev      = cotas.nome-abrev      and
                tt-simula-saldo.nome-ab-reg     = cotas.nome-ab-reg     and
                tt-simula-saldo.nome-mic-reg    = cotas.nome-mic-reg    and
                tt-simula-saldo.cod-rep         = cotas.cod-rep         and
                tt-simula-saldo.dt-inicial      = cotas.dt-inicial no-error.

           /*** cria tt-simula-saldo ***/  
           if not avail tt-simula-saldo then do:
              create tt-simula-saldo.
              assign tt-simula-saldo.cod-estabel     = cotas.cod-estabel
                     tt-simula-saldo.cod-canal-venda = cotas.cod-canal-venda
                     tt-simula-saldo.cd-produto      = cotas.cd-produto
                     tt-simula-saldo.cod-gr-cli      = cotas.cod-gr-cli
                     tt-simula-saldo.nome-abrev      = cotas.nome-abrev
                     tt-simula-saldo.nome-ab-reg     = cotas.nome-ab-reg
                     tt-simula-saldo.nome-mic-reg    = cotas.nome-mic-reg
                     tt-simula-saldo.cod-rep         = cotas.cod-rep
                     tt-simula-saldo.dt-inicial      = cotas.dt-inicial.
              if par-cota.tipo-controle = 2 /*valor*/then do:
                 assign tt-simula-saldo.pedida       = (if par-cota.tipo-valor = 1 then ped-item.vl-preuni else ped-item.vl-liq-it)
                        de-disp                      = (cotas.vl-previsto  - cotas.vl-pedido)
                        tt-simula-saldo.saldo        = de-disp - (if par-cota.tipo-valor = 1 then ped-item.vl-preuni else ped-item.vl-liq-it) .
              end.
              else do: /*pontos e quantidade*/
                 assign tt-simula-saldo.pedida       = (ped-item.qt-pedida * de-pontos) 
                        de-disp                      = (cotas.qt-prevista  - cotas.qt-pedida)
                        tt-simula-saldo.saldo        = (de-disp - (ped-item.qt-pedida * de-pontos)).
              end.
           end.
           /*** se j  existir tt-simula saldo ***/
           else do: 
              if par-cota.tipo-controle = 2 /*valor*/ then do:
                 assign de-disp                      = tt-simula-saldo.saldo
                        tt-simula-saldo.saldo        = de-disp - (if par-cota.tipo-valor = 1 then ped-item.vl-preuni else ped-item.vl-liq-it).
              end.
              else do: /*pontos e quantidade*/
                 assign de-disp                      = tt-simula-saldo.saldo
                        tt-simula-saldo.saldo        = (de-disp - (ped-item.qt-pedida * de-pontos)).
              end. 
           end.

           /******************************************************************/

           /* Imprimir s¢ os excedentes*/
           if tt-param.excedente and tt-simula-saldo.saldo <= 0 then do:

              if ped-venda.no-ab-reppri <> c-rep-quebra then do:        

                 /* Descri‡Æo : quantidade, valor ,pontos. */
                 assign c-tp-contr  = {diinc/i04di257.i 04 par-cota.tipo-controle}.

                 hide frame f-cabec-colum.
                 disp c-repres       
                      ped-venda.no-ab-reppri
                      c-tp-contr-lab
                      c-tp-contr
                      with frame f-cabec-repres.

                 if line-counter > 60 then page.        
                 disp c-ped-cli              
                      c-nome                 
                      c-seq                 
                      c-item                
                      c-desc                
                      c-un                  
                      c-qt-ped  
                      c-qt-disp            
                      c-saldo 
                      with frame f-cabec-colum.
              end.
              assign c-rep-quebra = ped-venda.no-ab-reppri.

              put ped-venda.nr-pedcli    at 01
                  ped-venda.nome-abrev   at 17
                  ped-item.nr-sequencia  at 30
                  ped-item.it-codigo     at 38.        

              if avail item then do: 
                 put item.desc-item    FORMAT "x(18)" AT 55
                     item.un           at 74.    
              end.

              if par-cota.tipo-controle = 2 /*valor*/ then do:
                 if par-cota.tipo-valor = 1 then 
                    put ped-item.vl-preuni format ">>>,>>>,>>9.9999"  at 78.
                 else 
                    put ped-item.vl-liq-it format ">>>,>>>,>>9.9999"  at 78.

                 put 0                     format "->>>,>>>,>>9.9999" at 97
                     tt-simula-saldo.saldo format "->>>,>>>,>>9.9999" at 114.
              end. 
              else do: /*quantidade,pontos*/
                 put ped-item.qt-pedida * de-pontos format ">>>,>>>,>>9.9999"  at 78
                     0                              format "->>>,>>>,>>9.9999" at 97
                     tt-simula-saldo.saldo          format "->>>,>>>,>>9.9999" at 114.
              end.
           end. /*excedente*/






           /* Imprimir todos os pedidos*/
           if tt-param.excedente = no then do:

              if ped-venda.no-ab-reppri <> c-rep-quebra then do:        
                 /* Descri‡Æo : quantidade, valor ,pontos. */
                 assign c-tp-contr  = {diinc/i04di257.i 04 par-cota.tipo-controle}.
                 hide frame f-cabec-colum.
                 disp c-repres       
                      ped-venda.no-ab-reppri
                      c-tp-contr-lab
                      c-tp-contr
                      with frame f-cabec-repres.

                 if line-counter > 60 then page.        
                 disp c-ped-cli              
                      c-nome                 
                      c-seq                 
                      c-item                
                      c-desc                
                      c-un                  
                      c-qt-ped  
                      c-qt-disp            
                      c-saldo 
                      with frame f-cabec-colum.
              end.
              assign c-rep-quebra = ped-venda.no-ab-reppri.

              put ped-venda.nr-pedcli    at 01
                  ped-venda.nome-abrev   at 17
                  ped-item.nr-sequencia  at 30
                  ped-item.it-codigo     at 38.        

              if avail item then do: 
                 put item.desc-item      FORMAT "x(18)" at 55
                     item.un             at 74.    
              end.

              if par-cota.tipo-controle = 2 /*valor*/ then do:
                 if par-cota.tipo-valor = 1 then 
                    put ped-item.vl-preuni format ">>>,>>>,>>9.9999"  at 78.
                 else 
                    put ped-item.vl-liq-it format ">>>,>>>,>>9.9999"  at 78.

                 put cotas.vl-previsto     format "->>>,>>>,>>9.9999" at 97
                     tt-simula-saldo.saldo format "->>>,>>>,>>9.9999" at 114.
              end. 
              else do: /*quantidade,pontos*/
                 put ped-item.qt-pedida * de-pontos format ">>>,>>>,>>9.9999"  at 78
                     cotas.qt-prevista              format "->>>,>>>,>>9.9999" at 97
                     tt-simula-saldo.saldo          format "->>>,>>>,>>9.9999" at 114.
              end.


           end. /*excedente*/










        end. /* avail cotas */
    end. /*for each ped-item*/
end. /*for each ped-venda*/

run pi-finalizar in h-acomp.

/* **************** ImpressÆo da p gina de parƒmetros ************* */

if  page-number > 0 then page.
hide frame f-cabec-colum.
display c-selecao 
        tt-param.periodo-ini   
        tt-param.periodo-fim
        c-parametro
        c-texto-1
        c-texto-2   
        c-impressao
        c-destino
        tt-param.arquivo
        tt-param.usuario
        with frame f-parametros.
if tt-param.nao-avaliado = yes then 
   {utp/ut-liter.i Sim * R} 
else {utp/ut-liter.i NÆo * R} 
disp trim(return-value) @ tt-param.nao-avaliado 
     with frame f-parametros.

if tt-param.reprovado = yes then 
   {utp/ut-liter.i Sim * R} 
else {utp/ut-liter.i NÆo * R}
disp trim(return-value) @ tt-param.reprovado 
     with frame f-parametros.

if tt-param.nao-aval-cred = yes then 
   {utp/ut-liter.i Sim * R} 
else {utp/ut-liter.i NÆo * R} 
disp trim(return-value) @ tt-param.nao-aval-cred 
     with frame f-parametros.

if tt-param.wf-desconto = yes then 
   {utp/ut-liter.i Sim * R} 
else {utp/ut-liter.i NÆo * R} 
disp trim(return-value) @ tt-param.wf-desconto 
     with frame f-parametros.

if tt-param.aval-cred = yes then 
   {utp/ut-liter.i Sim * R} 
else {utp/ut-liter.i NÆo * R} 
disp trim(return-value) @ tt-param.aval-cred 
     with frame f-parametros.

if tt-param.aprov-cred = yes then 
   {utp/ut-liter.i Sim * R} 
else {utp/ut-liter.i NÆo * R} 
disp trim(return-value) @ tt-param.aprov-cred 
     with frame f-parametros.

if tt-param.reprov-cred = yes then 
   {utp/ut-liter.i Sim * R} 
else {utp/ut-liter.i NÆo * R} 
disp trim(return-value) @ tt-param.reprov-cred 
     with frame f-parametros.

if tt-param.excedente = yes then 
   {utp/ut-liter.i Sim * R} 
else {utp/ut-liter.i NÆo * R} 
disp trim(return-value) @ tt-param.excedente 
     with frame f-parametros.
down with frame f-parametros.


{include/i-rpclo.i}

RETURN "OK".


/* Fim do Programa */


