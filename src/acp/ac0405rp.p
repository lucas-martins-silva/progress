/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0405RP 2.00.00.017}  /*** 010017 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AC0405RP MAC}
&ENDIF



{include/i_fnctrad.i}
/*******************************************************************************
**
** Ac0405RP.P : ImpressÆo do itens por cotas
**
********************************************************************************/
{utp/ut-glob.i}
/* ************************ Defini‡Æo de vari veis *************************** */

{include/i-rpvar.i}

{cdp/cdcfgdis.i} /*defini‡Æo pr‚-processador*/

def var c-selecao      as char format "x(11)"      no-undo.
def var c-parametro    as char format "x(14)"      no-undo.
def var c-impressao    as char format "x(12)"      no-undo.
def var c-destino      as char format "x(10)"      no-undo.
def var h-acomp        as handle                   no-undo.
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
def var c-valor        as char    format "x(05)"   no-undo. 
def var c-nome-estab   as char    format "x(40)"   no-undo.            
def var c-valor-tot    as char    format "x(5)"    no-undo.
def var c-situacao     as char    format "x(08)"   no-undo.
def var de-valor-tot   as decimal format ">,>>>,>>>,>>>,>>9.99" no-undo.
def var de-quant-tot   as decimal format ">>>,>>>,>>>,>>9.9999" no-undo.

/* ********************  Defini‡Æo de Temp-Table ****************************** */

define temp-table tt-ped-venda 
    field no-ab-reppri like ped-venda.no-ab-reppri
    field nome-abrev   like ped-item.nome-abrev
    field nr-pedcli    like ped-item.nr-pedcli
    field nr-sequencia like ped-item.nr-sequencia
    field it-codigo    like ped-item.it-codigo
    field descricao    like item.desc-item
    field un           like item.un
    field qt-pedida    like ped-item.qt-pedida
    field vl-tot-it    like ped-item.vl-tot-it
    field situacao     as char format "x(12)"
    INDEX ped-venda IS PRIMARY no-ab-reppri ASCENDING.


define temp-table tt-param
    field destino          as integer
    field arquivo          as char
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field periodo-ini      like cotas.dt-inicial
    field periodo-fim      like cotas.dt-inicial
    field nao-avaliado     as logical
    field aprovado         as logical
    field reprovado        as logical
    field desc-sit-com     as char format "x(40)".

def temp-table tt-raw-digita
   field raw-digita      as raw.

/* ************************ Defini‡Æo de parametros ************************** */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

/* *********** Defini‡Æo do layout da p gina de parƒmetros ****************** */

form skip(1)
     c-repres                  at 01
     ":":U                     at 16    
     tt-ped-venda.no-ab-reppri at 17 
     with  stream-io width 132 no-label attr-space frame f-cabec-repres.

form c-ped-cli              at 01
     c-nome                 at 17
     c-seq                  at 30
     c-item                 at 38   
     c-desc                 at 55
     c-un                   at 74
     c-qt-ped               at 78
     c-valor                at 99
     c-situacao             at 120     
     "--------------"       at 01
     "------------"         at 17
     "------"               at 30
     "----------------"     at 38
     "------------------"   at 55
     "--"                   at 74
     "-------------------"  at 78
     "-------------------"  at 99
     "-----------"          at 120
     with  stream-io width 132  no-label page-top attr-space frame f-cabec-colum.

form skip(01)
     c-selecao   no-label     skip(1)
     tt-param.periodo-ini        colon 40 space(11) "|< >|"
     tt-param.periodo-fim     no-label colon 73 skip(1)
     c-parametro no-label     skip(1)
     tt-param.desc-sit-com       colon 40 skip(1)   
     c-impressao no-label     skip(1)
     c-destino                   colon 40
     " - ":U
     tt-param.arquivo no-label format "x(60)":U skip
     tt-param.usuario        colon 40 skip(4)     
     with down no-box side-labels width 132 stream-io frame f-parametros.


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
{utp/ut-liter.i Total * L}
assign c-valor-tot = trim(return-value).
{utp/ut-liter.i Dt_Emis_Ped * L}
assign tt-param.periodo-ini:label in frame f-parametros = trim(return-value).
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
{utp/ut-liter.i Valor * L}
assign c-valor = trim(return-value).
{utp/ut-liter.i Situa‡Æo * L}
assign c-situacao = trim(return-value).
{utp/ut-liter.i Quantidade * L}
assign c-qt-ped = trim(return-value).
{utp/ut-liter.i Situa‡Æo * L}
assign tt-param.desc-sit-com:label in frame f-parametros = trim(return-value).

/* ************************ Inicio do programa ****************************** */
run utp/ut-trfrrp.p (input frame f-parametros:handle).
run utp/ut-trfrrp.p (input frame f-cabec-colum:handle).
run utp/ut-trfrrp.p (input frame f-cabec-repres:handle).
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.

find empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
if avail empresa then
   assign c-empresa = empresa.razao-social.

assign c-programa = 'ap0405'
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

{utp/ut-liter.i Situa‡Æo_dos_Itens_do_Pedido_em_Cotas MAP C}
assign c-titulo-relat = return-value.

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.
run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Aguarde... *}
run pi-inicializar in h-acomp (input  Return-value ).

for each ped-venda no-lock
    where ped-venda.dt-emissao >= tt-param.periodo-ini
    and   ped-venda.dt-emissao <= tt-param.periodo-fim:

    find natur-oper where 
         natur-oper.nat-operacao = ped-venda.nat-operacao no-lock no-error.

    &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
       if avail natur-oper and natur-oper.log-atual-cotas = no then /* NAO CONTROLA COTAS */
          next.     
    &else
       if avail natur-oper and substr(natur-oper.char-2,31,1) <> "1"  then /* NAO CONTROLA COTAS */
          next. 
    &endif    

    run pi-acompanhar in h-acomp ( input ped-venda.nome-abrev).

    /* itens do pedido */
    for each ped-item no-lock  
        where ped-item.nome-abrev  = ped-venda.nome-abrev
         and  ped-item.nr-pedcli   = ped-venda.nr-pedcli:    

        if ped-item.cod-sit-com = 4 then 
           next.

        if  ped-item.nat-operacao <> ped-venda.nat-operacao then do:
            find natur-oper where 
                 natur-oper.nat-operacao = ped-item.nat-operacao no-lock no-error.

         &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
           if avail natur-oper and natur-oper.log-atual-cotas = no then /* NAO CONTROLA COTAS */
              next.     
         &else
           if avail natur-oper and substr(natur-oper.char-2,31,1) <> "1"  then /* NAO CONTROLA COTAS */
              next. 
         &endif    

        end.

        run pi-acompanhar in h-acomp ( input ped-item.it-codigo).

        /****************************************/
        /*** Verifica parƒmetros do relat¢rio ***/
        /****************************************/
        if (tt-param.nao-avaliado = no) and (ped-item.cod-sit-com = 1) then
           next.
        if (tt-param.aprovado     = no) and (ped-item.cod-sit-com = 2) then
           next.
        if (tt-param.reprovado    = no) and (ped-item.cod-sit-com = 3) then
           next.

        if (ped-item.cod-sit-com <> 1) and
           (ped-item.cod-sit-com <> 2) and
           (ped-item.cod-sit-com <> 3) then
           next.

        create tt-ped-venda.
        assign tt-ped-venda.no-ab-reppri = ped-venda.no-ab-reppri
               tt-ped-venda.nome-abrev   = ped-item.nome-abrev
               tt-ped-venda.nr-pedcli    = ped-item.nr-pedcli
               tt-ped-venda.nr-sequencia = ped-item.nr-sequencia
               tt-ped-venda.it-codigo    = ped-item.it-codigo.

        find item no-lock
             where item.it-codigo = ped-item.it-codigo no-error.
        if avail item then do: 
           assign tt-ped-venda.descricao = item.desc-item
                  tt-ped-venda.un        = item.un.         
        end.

        /*nesse relat¢rio nÆo vai ser considerado se controla por pontos,qtde,valor,
          se valor liquido ou bruto... serÆo impressas as informa‡äes originais do pedido*/
        assign tt-ped-venda.qt-pedida = ped-item.qt-pedida 
               tt-ped-venda.vl-tot-it = ped-item.vl-tot-it
        .
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao002 = {diinc/i05di154.i 04 ped-item.cod-sit-com}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN tt-ped-venda.situacao = RETURN-VALUE. 
        &else
            ASSIGN tt-ped-venda.situacao = {diinc/i05di154.i 04 ped-item.cod-sit-com}.
        &endif
    end. /*for each ped-item*/
end. /*for each ped-venda*/



/* leitura da tt-ped-venda */
for each tt-ped-venda no-lock
    break by tt-ped-venda.no-ab-reppri
          by tt-ped-venda.nr-pedcli:
{utp/ut-liter.i Imprimindo..._ *}

    run pi-acompanhar in h-acomp (input  Return-value  + tt-ped-venda.nr-pedcli).

    if  first-of(tt-ped-venda.no-ab-reppri) then do:        
        hide frame f-cabec-colum.
        disp c-repres       
             tt-ped-venda.no-ab-reppri
             with frame f-cabec-repres.

        if line-counter > 60 then page.        
        disp c-ped-cli              
             c-nome                 
             c-seq                 
             c-item                
             c-desc                
             c-un                  
             c-qt-ped              
             c-valor 
             c-situacao              
             with frame f-cabec-colum.
    end.

    put tt-ped-venda.nr-pedcli    at 01
        tt-ped-venda.nome-abrev   at 17
        tt-ped-venda.nr-sequencia at 30
        tt-ped-venda.it-codigo    at 38        
        tt-ped-venda.descricao    FORMAT "x(18)" AT 55 
        tt-ped-venda.un           at 74
        tt-ped-venda.qt-pedida   format ">>>>,>>9.9999" at 84
        tt-ped-venda.vl-tot-it    at 103 
        tt-ped-venda.situacao     at 120.

    assign de-valor-tot = de-valor-tot + tt-ped-venda.vl-tot-it
           de-quant-tot = de-quant-tot + tt-ped-venda.qt-pedida.  


    if last-of(tt-ped-venda.no-ab-reppri) then do:
        if line-counter > 60 then page.        
        put skip
            "-------------------"                         at 78
            "-------------------"                         at 99 skip
            c-valor-tot                                   at 40 
            de-quant-tot                                  at 77
            de-valor-tot                                  at 98 .

        assign de-valor-tot = 0
               de-quant-tot = 0.
    end.
end.
run pi-finalizar in h-acomp.

/* **************** ImpressÆo da p gina de parƒmetros ************* */

if  page-number > 0 then page.
hide frame f-cabec-colum.
display c-selecao 
        tt-param.periodo-ini   
        tt-param.periodo-fim
        c-parametro   
        tt-param.desc-sit-com
        c-impressao
        c-destino
        tt-param.arquivo
        tt-param.usuario
        with frame f-parametros.
down with frame f-parametros.

{include/i-rpclo.i}

RETURN "OK".

/* Fim do Programa */


