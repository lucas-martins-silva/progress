/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0665RP 2.00.00.111 } /*** "010011" 17/08/2026 02:49:41 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0665rp MIM}
&ENDIF

{include/i_fnctrad.i}
/******************************************************************************
**
**       PROGRAMA:  IM0665RP.P
**
**       DATA....:  FEVEREIRO DE 2003
**
**       OBJETIVO:  Custo Real de Importaá∆o
**
**       VERSAO..:  1.00.000 - Ivonei Vock
**
******************************************************************************/
{cdp/cdcfgmat.i}

{imp/im0665.i} /* Definiá∆o tt-param           **
               ** Definiá∆o tt-detalha-item    **
               ** Definiá∆o tt-embarque-cabec  **
               ** Definiá∆o tt-embarque-corpo  **
               ** Definiá∆o tt-embarque-fatura **
               ** Definiá∆o tt-detalha-despesa **
               ** Definiá∆o tt-embarque-rel
               ** Definiá∆o tt-detalha-despesa-aux - despesa total do cabeáalho*/
{imp/im0665.i1} /* Definiá∆o de Forms */

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

def buffer b-docum-est           for docum-est.
def buffer b-docum-est-aux       for docum-est.
def buffer b-embarque-imp        for embarque-imp.
def buffer b-ordens-embarque     for ordens-embarque.
def buffer b-item-doc-est        for item-doc-est.
def buffer b-item-doc-est-aux    for item-doc-est.
def buffer b-item-doc-est-aux2   for item-doc-est.
def buffer b-historico-embarque  for historico-embarque.
def buffer bf-tt-detalha-item    for tt-detalha-item.
def buffer bf-natur-oper         for natur-oper.
def buffer b-embarq-import-docto for embarq-import-docto.
def buffer b-item-doc-est-cex    for item-doc-est-cex.

/*Definiá∆o de Vari†veis*/
def var c-desc-estabel                like estabelec.nome               no-undo.
def var c-desc-emitente               like emitente.nome-abrev          no-undo.
def var d-taxa-moeda                  as   decimal                      no-undo.
def var d-data-conv                   as   date                         no-undo.
def var d-data-emb                    as   date                         no-undo.
def var d-data-nac                    as   date                         no-undo.
def var d-data-ult-prev-nac           as   date                         no-undo.
def var d-data-ult-prev-despacho      as   date                         no-undo.
def var d-data-despacho               as   date                         no-undo.
def var d-data-ult-prev-embarque      as   date                         no-undo.
def var d-data-chegada                as   date                         no-undo.
def var d-data-ult-prev-chegada       as   date                         no-undo.
def var c-taxa                        as   char                         no-undo.
def var c-embarque                    as   char format "x(20)"          no-undo.
DEF VAR c-desc-ii                     AS   CHAR                         NO-UNDO.
def var i-cod-desp-ii                 like docum-est-cex.cod-desp       no-undo.
def VAR c-desc-pto-despacho           LIKE pto-contr.descricao          no-undo.
def var c-desc-pto-emb                like pto-contr.descricao          no-undo.
def var c-desc-pto-nac                like pto-contr.descricao          no-undo.
def var c-desc-pto-chegada            like pto-contr.descricao          no-undo.
def var vl-ii-orcad-det               like cotacao-item-cex.val-desp    no-undo.
def var vl-ii2-orcad-det              like cotacao-item-cex.val-desp    no-undo.
def var vl-ii-reali-det               like item-doc-est-cex.val-desp    no-undo.
def var vl-ii2-reali-det              like item-doc-est-cex.val-desp    no-undo.
def var vl-ipi-orcad-det              like cotacao-item-cex.val-desp    no-undo.
def var vl-icms-orcad-det             like cotacao-item-cex.val-desp    no-undo.
def var vl-pis-orcad-det              like cotacao-item-cex.val-desp    no-undo.
def var vl-cofins-orcad-det           like cotacao-item-cex.val-desp    no-undo.
def var vl-desp-orcad-det             like cotacao-item-cex.val-desp    no-undo.
def var vl-despesa-frete              like item-doc-est-cex.val-desp    no-undo.
def var vl-despesa-embalagem          like item-doc-est-cex.val-desp    no-undo.
def var vl-despesa-seguro             like item-doc-est-cex.val-desp    no-undo.
def var vl-despesa-outras             like item-doc-est-cex.val-desp    no-undo.
def var tot-despesa-orc               like item-doc-est-cex.val-desp    no-undo.
def var tot-despesa-rea               like item-doc-est-cex.val-desp    no-undo.
def var tot-despesa-orc-total         like item-doc-est-cex.val-desp    no-undo.
def var tot-despesa-rea-total         like item-doc-est-cex.val-desp    no-undo.
def var var-preco-unit                like item-doc-est-cex.val-desp    no-undo.
def var var-moeda-conv-orc            like item-doc-est-cex.mo-codigo   no-undo.
def var var-moeda-conv-rea            like item-doc-est-cex.mo-codigo   no-undo.
DEF VAR var-cot-conv-rea              LIKE item-doc-est-cex.cotacao     NO-UNDO.
DEF VAR var-dat-conv-rea              LIKE item-doc-est-cex.dat-cotac   NO-UNDO.
def var var-preco-item-rea            like item-doc-est-cex.val-desp    no-undo.
def var var-valor-ipi-rea             like item-doc-est-cex.val-desp    no-undo.
def var var-valor-icm-rea             like item-doc-est-cex.val-desp    no-undo.
def var var-valor-pis-rea             like item-doc-est-cex.val-desp    no-undo.
def var var-valor-cofins-rea          like item-doc-est-cex.val-desp    no-undo.
def var var-valor-cbs-rea             like item-doc-est-cex.val-desp    no-undo.
def var var-valor-ibs-uf-rea          like item-doc-est-cex.val-desp    no-undo.
def var var-valor-ibs-mun-rea         like item-doc-est-cex.val-desp    no-undo.
def var var-valor-is-rea              like item-doc-est-cex.val-desp    no-undo.
def var var-preco-unit-aux            like item-doc-est-cex.val-desp    no-undo.
def var var-valor-ipi-mattran-rea     like item-doc-est-cex.val-desp    no-undo.
def var var-valor-icm-mattran-rea     like item-doc-est-cex.val-desp    no-undo.
def var var-valor-pis-mattran-rea     like item-doc-est-cex.val-desp    no-undo.
def var var-valor-cofins-mattran-rea  like item-doc-est-cex.val-desp    no-undo.
DEF VAR de-vl-cofins-rea              LIKE cotacao-item-cex.val-desp    NO-UNDO.
DEF VAR de-vl-pis-rea                 LIKE cotacao-item-cex.val-desp    NO-UNDO.
DEF VAR de-vl-cofins-rea-total        LIKE cotacao-item-cex.val-desp    NO-UNDO.
DEF VAR de-vl-pis-rea-total           LIKE cotacao-item-cex.val-desp    NO-UNDO.
DEF VAR vl-desp-orcad-aux             LIKE cotacao-item-cex.val-desp    NO-UNDO.
DEF VAR vl-ii2-orcad-det-aux          LIKE cotacao-item-cex.val-desp    NO-UNDO.
DEF VAR vl-ii-orcad-det-aux           LIKE cotacao-item-cex.val-desp    NO-UNDO.
DEF VAR de-preco-unit-sem-ipi         LIKE ordem-compra.preco-unit      NO-UNDO.
DEF VAR de-valor-icm                  LIKE item-doc-est.valor-icm[1]    NO-UNDO.
DEF VAR de-valor-ipi                  LIKE item-doc-est.valor-ipi[1]    NO-UNDO.
DEF VAR de-valor-imp-nf               LIKE tt-impto-item-docto.val-impto NO-UNDO.
DEF VAR de-valor-pis                  LIKE item-doc-est.valor-pis       NO-UNDO.
DEF VAR de-valor-cofins               LIKE item-doc-est.val-cofins      NO-UNDO.
DEF VAR vl-ii2-reali-det-mo           like item-doc-est-cex.val-desp    no-undo.
DEF VAR mo-ii2-reali-det              like item-doc-est-cex.mo-codigo   no-undo.
DEF VAR dt-cotac-desp                 LIKE item-doc-est-cex.dat-cotac   NO-UNDO.
DEF VAR de-cotac-desp                 LIKE item-doc-est-cex.cotacao     NO-UNDO.
DEF VAR i-mo-codigo-desp              LIKE docum-est.mo-codigo          NO-UNDO.

DEF VAR de-val-desp-nfc2              AS   DECIMAL                      NO-UNDO.
DEF VAR de-val-desp-aux-rea           AS   DECIMAL                      NO-UNDO.
DEF VAR de-tot-orc                    AS   DECIMAL                      NO-UNDO.
DEF VAR de-tot-rea                    AS   DECIMAL                      NO-UNDO.
DEF VAR de-val-desp-nfc-mo            AS   DECIMAL                      NO-UNDO.
DEF VAR de-val-desp-aux-mo            AS   DECIMAL                      NO-UNDO.
DEF VAR de-tot-desp-rea               AS   DECIMAL                      NO-UNDO.

def var no-despesa                    as   logical                      no-undo.
def var l-desemb-parc-modif           as   logical initial no           no-undo.
def var l-cria-embarque-corpo         as   logical initial no           no-undo.
def var h-acomp                       as   handle                       no-undo.
def var i-parcela                     as   integer                      no-undo.
DEF VAR l-nota-mae                    AS   LOGICAL                      NO-UNDO.
DEF VAR r-rowid-mae                   AS ROWID                          NO-UNDO.
DEF VAR bh-dados-excel                AS HANDLE                         NO-UNDO.
DEF VAR bh-dados-excel-detail         AS HANDLE                         NO-UNDO.
DEF VAR bh-dados-excel-total          AS HANDLE                         NO-UNDO.

DEF VAR d-iva-convert                 LIKE dupli-imp.vl-imposto         NO-UNDO.

DEF VAR h-cdapi995                    AS HANDLE                         NO-UNDO.
DEF VAR de-aliquota-pis               AS DEC FORMAT ">>9.9999"          NO-UNDO.
DEF VAR de-aliquota-cofins            AS DEC FORMAT ">>9.9999"          NO-UNDO.

/*Geraá∆o em excel*/
DEFINE VARIABLE h-utapi033 AS HANDLE NO-UNDO.

DEFINE VARIABLE bufferttable-dados AS HANDLE NO-UNDO.

DEFINE VARIABLE l-possui-inf       AS LOG    NO-UNDO.

DEF TEMP-TABLE tt-relat-confer NO-UNDO
    FIELD cod-estabel  AS CHARACTER
    FIELD nome-aba     AS CHARACTER
    FIELD text-livre   AS CHARACTER
    FIELD num-seq      AS INTEGER
    INDEX idx1-relat-confer
          nome-aba.

DEF TEMP-TABLE tt-dados-browse NO-UNDO
   FIELD nome-aba        AS CHAR
   FIELD nr-coluna       AS INT
   FIELD label-campo     AS CHAR
   FIELD formato-campo   AS CHAR
   FIELD tipo-campo      AS CHAR
   FIELD tamanho-label   AS INT
   FIELD tamanho-format  AS INT
   FIELD largura-coluna  AS INT
   INDEX idx1_dados_browse
         nome-aba
         nr-coluna.

DEFINE TEMP-TABLE tt-documentos NO-UNDO
    field cod-estabel                LIKE embarque-imp.cod-estabel
    field embarque                   LIKE embarque-imp.embarque
    field cod-exportador             LIKE processo-imp.cod-exportador LABEL "Exportador"
    field desc-exportador            AS CHAR LABEL "Nome Exportador"
    field nro-docto                  LIKE docum-est.nro-docto
    field serie-docto                LIKE docum-est.serie-docto
    field nat-operacao               LIKE docum-est.nat-operacao
    FIELD cod-emitente               LIKE docum-est.cod-emitente
    FIELD desc-emit                  LIKE emitente.nome-abrev
    field dt-emissao                 LIKE docum-est.dt-emissao
    field des-tipo-nota-imp          AS CHAR LABEL "Tipo Documento".

/*fim das variaveis para o excel.*/

run utp/ut-acomp.p persistent set h-acomp.

{include/i-rpvar.i}
{include/i-rpcab.i}

find first tt-param     no-lock no-error.
find first param-global no-lock no-error.

find first empresa
     where empresa.ep-codigo = param-global.empresa-prin no-lock no-error.
if  avail empresa then
    assign c-empresa = empresa.razao-social.
else do:
    run utp/ut-msgs.p (input "show", input 16, input "").
    return error.
end.

{utp/ut-liter.i "Custo_Real_Importaá∆o" *}
ASSIGN c-titulo-relat = RETURN-VALUE.

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

for each tt-detalha-item:
    delete tt-detalha-item.
end.
for each tt-embarque-cabec:
    delete tt-embarque-cabec.
end.
for each tt-embarque-corpo:
    delete tt-embarque-corpo.
end.
FOR EACH tt-embarque-nota-mae:
    DELETE tt-embarque-nota-mae.
END.
FOR EACH tt-embarque-nf:
    DELETE tt-embarque-nf.
END.
FOR EACH tt-detalha-despesa-aux:
    DELETE tt-detalha-despesa-aux.
END.

IF  i-pais-impto-usuario <> 1 /* Brasil */
AND NOT VALID-HANDLE(h-boin759na) THEN
    RUN inbo/boin759na.p PERSISTENT SET h-boin759na.

IF NOT VALID-HANDLE(h-cdapi995) THEN
    RUN cdp/cdapi995.p PERSISTENT SET h-cdapi995.

run pi-inicializar in h-acomp (input "Preparando Dados...").

for each embarque-imp no-lock
   where embarque-imp.cod-estabel >= tt-param.c-cod-estabel-ini
     and embarque-imp.cod-estabel <= tt-param.c-cod-estabel-fim
     and embarque-imp.embarque    >= tt-param.c-embarque-ini
     and embarque-imp.embarque    <= tt-param.c-embarque-fim:

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Embarque" *}
    run pi-acompanhar in h-acomp (input RETURN-VALUE + ": " + string(embarque-imp.embarque)).

    for first ordens-embarque fields( embarque cod-estabel numero-ordem char-2 quantidade )
        where ordens-embarque.embarque    = embarque-imp.embarque
          and ordens-embarque.cod-estabel = embarque-imp.cod-estabel
          and can-find(first ordem-compra
                       where ordem-compra.numero-ordem = ordens-embarque.numero-ordem
                         and ordem-compra.it-codigo   >= tt-param.c-it-codigo-ini
                         and ordem-compra.it-codigo   <= tt-param.c-it-codigo-fim ) no-lock:
    end.
    if  not avail ordens-embarque then next.

    for first ordem-compra fields( numero-ordem  num-pedido cod-emitente it-codigo)
        where ordem-compra.numero-ordem = ordens-embarque.numero-ordem no-lock:
    end.
    if  not avail ordem-compra then next.

    for first b-historico-embarque fields(cod-itiner)
        where b-historico-embarque.cod-estabel = embarque-imp.cod-estabel
          and b-historico-embarque.embarque    = embarque-imp.embarque no-lock:
    end.
    IF  NOT AVAIL b-historico-embarque THEN
        NEXT.

    if  b-historico-embarque.cod-itiner <= tt-param.i-cod-itiner-ini
    and b-historico-embarque.cod-itiner >= tt-param.i-cod-itiner-fim then next.

    for first processo-imp fields( num-pedido   cod-exportador
                                   nr-proc-imp  cod-itiner )
        where processo-imp.num-pedido          =  ordem-compra.num-pedido
          and processo-imp.nr-proc-imp        >= tt-param.c-nr-proc-imp-ini
          and processo-imp.nr-proc-imp        <= tt-param.c-nr-proc-imp-fim
          and processo-imp.cod-exportador     >= tt-param.i-cod-emitente-ini
          and processo-imp.cod-exportador     <= tt-param.i-cod-emitente-fim no-lock:
    end.
    if  not avail processo-imp then next.

    /****** DESCRICAO ******/
    for first estabelec fields( cod-estabel  nome )
        where estabelec.cod-estabel = embarque-imp.cod-estabel no-lock:
    end.
    assign c-desc-estabel = if avail estabelec then estabelec.nome else "":U.

    for first emitente fields( cod-emitente  nome-abrev  pais )
        where emitente.cod-emitente = processo-imp.cod-exportador no-lock:
    end.
    assign c-desc-emitente = if avail emitente then emitente.nome-abrev else "":U.
    /****** ********* ******/

    /******** MOEDA ********/
    for first moeda fields( mo-codigo descricao )
        where moeda.mo-codigo = tt-param.moeda no-lock:
    end.
    if  not avail moeda then next.
    assign d-data-conv  = tt-param.da-dt-conv
           c-desc-moeda = moeda.descricao.
    if  l-dt-nacional OR (i-pais-impto-usuario <> 1 AND tt-param.l-considera-cot-docto) then
        assign d-data-conv = embarque-imp.data-1.

    run cdp/cd0812.p (input  tt-param.moeda, /*moeda origem*/
                      input  0,              /*moeda destino*/
                      input  1,              /*valor origem*/
                      input  d-data-conv,    /*data conversao*/
                      output d-taxa-moeda).  /*valor destino*/
    /******* ******* *******/

    for first itinerario fields( cod-itiner  pto-embarque  pto-desembarque )
        where itinerario.cod-itiner = b-historico-embarque.cod-itiner no-lock:
    end.
    if  not avail itinerario then next.

    /*Data e Ponto de Chegada*/
    for first historico-embarque fields( cod-estabel  embarque  cod-pto-contr
                                         dt-efetiva dt-previsao dt-ult-prev  cod-itiner descricao)
        where historico-embarque.cod-estabel   =  ordens-embarque.cod-estabel
          and historico-embarque.embarque      =  ordens-embarque.embarque
          and historico-embarque.cod-itiner    =  itinerario.cod-itiner
          and historico-embarque.cod-pto-contr =  embarque-imp.cdn-pto-chegad no-lock:
    end.

    if not avail historico-embarque then next.

    for first pto-contr fields( cod-pto-contr  descricao )
        where pto-contr.cod-pto-contr = embarque-imp.cdn-pto-chegad no-lock:
    end.
    if not avail pto-contr then next.

    assign d-data-chegada          = if historico-embarque.dt-efetiva = ? then historico-embarque.dt-previsao
                                     else historico-embarque.dt-efetiva
           d-data-ult-prev-chegada = historico-embarque.dt-ult-prev
           c-desc-pto-chegada      = IF historico-embarque.descricao <> "":U THEN historico-embarque.descricao ELSE pto-contr.descricao.
    /*************************/

    /*Data e Ponto de Despacho*/
    for first historico-embarque fields( cod-estabel  embarque  cod-pto-contr
                                         dt-efetiva dt-previsao dt-ult-prev  cod-itiner descricao)
        where historico-embarque.cod-estabel   =  ordens-embarque.cod-estabel
          and historico-embarque.embarque      =  ordens-embarque.embarque
          and historico-embarque.cod-itiner    =  itinerario.cod-itiner
          and historico-embarque.cod-pto-contr =  embarque-imp.cdn-pto-despch no-lock:
    end.

    if not avail historico-embarque then next.

    for first pto-contr fields( cod-pto-contr  descricao )
        where pto-contr.cod-pto-contr = embarque-imp.cdn-pto-despch no-lock:
    end.
    if not avail pto-contr then next.

    assign d-data-despacho           = if historico-embarque.dt-efetiva = ? then historico-embarque.dt-previsao
                                       else historico-embarque.dt-efetiva
           d-data-ult-prev-despacho  = historico-embarque.dt-ult-prev
           c-desc-pto-despacho       = IF historico-embarque.descricao <> "":U THEN historico-embarque.descricao ELSE pto-contr.descricao.

    /**************************/

    /* Data e Ponto de Embarque */
    for first historico-embarque fields( cod-estabel  embarque  cod-pto-contr
                                         dt-efetiva dt-previsao dt-ult-prev cod-itiner descricao)
        where historico-embarque.cod-estabel   =  ordens-embarque.cod-estabel
          and historico-embarque.embarque      =  ordens-embarque.embarque
          and historico-embarque.cod-itiner    =  itinerario.cod-itiner
          and historico-embarque.cod-pto-contr =  embarque-imp.cdn-pto-embarq no-lock:
    end.

    if  not avail historico-embarque then next.

    for first pto-contr fields( cod-pto-contr  descricao )
        where pto-contr.cod-pto-contr = embarque-imp.cdn-pto-embarq no-lock:
    end.
    if  not avail pto-contr then next.

    assign d-data-emb               = if historico-embarque.dt-efetiva = ? then historico-embarque.dt-previsao
                                      else historico-embarque.dt-efetiva
           d-data-ult-prev-embarque = historico-embarque.dt-ult-prev
           c-desc-pto-emb = IF historico-embarque.descricao <> "":U THEN historico-embarque.descricao ELSE pto-contr.descricao.
    /* ****************************** */

    /* Data e Ponto de Nacionalizaá∆o */
    for first historico-embarque fields( cod-estabel  embarque   cod-pto-contr dt-previsao
                                         dt-efetiva dt-ult-previsao  cod-itiner dt-efetiva descricao)
        where historico-embarque.cod-estabel    =  ordens-embarque.cod-estabel
          and historico-embarque.embarque       =  ordens-embarque.embarque
          and historico-embarque.cod-itiner     =  itinerario.cod-itiner
          and historico-embarque.cod-pto-contr  =  embarque-imp.cdn-pto-desembar no-lock:
    end.

    if  not avail historico-embarque then next.

    if historico-embarque.dt-efetiva <> ? then do:
        if historico-embarque.dt-efetiva < tt-param.da-dt-nac-ini  or
           historico-embarque.dt-efetiva > tt-param.da-dt-nac-fim then
            next.
    end.
    else do:
        if historico-embarque.dt-ult-prev < tt-param.da-dt-nac-ini or
           historico-embarque.dt-ult-prev > tt-param.da-dt-nac-fim then
            next.
    end.

    for first pto-contr fields( cod-pto-contr  descricao )
        where pto-contr.cod-pto-contr = embarque-imp.cdn-pto-desembar no-lock:
    end.
    if  not avail pto-contr then next.

    assign d-data-nac          = if historico-embarque.dt-efetiva = ? then historico-embarque.dt-previsao
                                 else historico-embarque.dt-efetiva
           d-data-ult-prev-nac = historico-embarque.dt-ult-prev
           c-desc-pto-nac      = IF historico-embarque.descricao <> "":U THEN historico-embarque.descricao ELSE pto-contr.descricao.
    /**********************************/

    for first param-imp
        where param-imp.cod-estabel = embarque-imp.cod-estabel no-lock:
    end.
    if  not avail param-imp then next.
    assign i-cod-desp-ii   = int(substring(param-imp.char-1,21,20)).

    IF i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
        FIND FIRST desp-imp NO-LOCK WHERE desp-imp.cod-desp = i-cod-desp-ii NO-ERROR.
        {utp/ut-liter.i "II" *}
        ASSIGN c-desc-ii = IF AVAIL desp-imp THEN desp-imp.descricao ELSE TRIM(RETURN-VALUE).
    END.

    /* => CABEÄALHO *******************************/
    create tt-embarque-cabec.
    assign tt-embarque-cabec.cod-estabel            = embarque-imp.cod-estabel
           tt-embarque-cabec.desc-estab             = if avail estabelec then estabelec.nome else "":U
           tt-embarque-cabec.embarque               = embarque-imp.embarque
           tt-embarque-cabec.cod-emitente           = processo-imp.cod-exportador
           tt-embarque-cabec.desc-emit              = if avail emitente then emitente.nome-abrev else "":U
           tt-embarque-cabec.pais                   = if avail emitente then emitente.pais else "":U
           tt-embarque-cabec.cod-incoterm           = embarque-imp.cod-incoterm
           tt-embarque-cabec.cod-via-transp         = embarque-imp.cod-via-transp
           tt-embarque-cabec.pto-despacho           = c-desc-pto-despacho
           tt-embarque-cabec.data-ult-prev-desp     = d-data-ult-prev-despacho
           tt-embarque-cabec.data-despacho          = d-data-despacho
           tt-embarque-cabec.pto-embarque           = c-desc-pto-emb
           tt-embarque-cabec.data-ult-prev-embarque = d-data-ult-prev-embarque
           tt-embarque-cabec.data-embarque          = d-data-emb
           tt-embarque-cabec.pto-nacional           = c-desc-pto-nac
           tt-embarque-cabec.data-ult-prev-nac      = d-data-ult-prev-nac
           tt-embarque-cabec.pto-chegada            = c-desc-pto-chegada
           tt-embarque-cabec.data-ult-prev-chegada  = d-data-ult-prev-chegada
           tt-embarque-cabec.data-nacional          = d-data-nac
           tt-embarque-cabec.data-chegada           = d-data-chegada
           tt-embarque-cabec.data-cotacao           = embarque-imp.data-1
           tt-embarque-cabec.desc-moeda             = c-desc-moeda
           tt-embarque-cabec.mo-taxa                = d-taxa-moeda
           tt-embarque-cabec.data-convercao         = d-data-conv.

    /******** NOTA FISCAL DE FATURA ********/
    for each invoice-emb-imp no-lock
        where invoice-emb-imp.cod-estabel = embarque-imp.cod-estabel
          and invoice-emb-imp.embarque    = embarque-imp.embarque:
        create tt-embarque-fatura.
        assign tt-embarque-fatura.embarque      = embarque-imp.embarque
               tt-embarque-fatura.cod-estabel   = embarque-imp.cod-estabel
               tt-embarque-fatura.nr-fatura     = invoice-emb-imp.nr-invoice
               tt-embarque-fatura.parcela       = invoice-emb-imp.parcela
               tt-embarque-fatura.dt-venc-fat   = invoice-emb-imp.dt-vencim.
    end.

    /****** NOTA FISCAL PRINCIPAL ******/
    IF CAN-FIND(FIRST embarq-import-docto
                WHERE embarq-import-docto.cod-estab  = embarque-imp.cod-estabel
                  AND embarq-import-docto.cod-embarq = embarque-imp.embarque) THEN DO:

        FOR EACH embarq-import-docto
           WHERE embarq-import-docto.cod-estab  = embarque-imp.cod-estabel
             AND embarq-import-docto.cod-embarq = embarque-imp.embarque NO-LOCK:

            bloco:
            FOR EACH docum-est FIELDS(idi-nf-simples-remes cod-estabel serie-docto nro-docto cod-emitente nat-operacao dt-emissao char-1 mo-codigo cotacao-dia)
               WHERE docum-est.serie-docto  = embarq-import-docto.cod-ser-docto
                 AND docum-est.nro-docto    = embarq-import-docto.cod-docto
                 AND docum-est.cod-emitente = embarq-import-docto.cdn-emitente
                 AND docum-est.nat-operacao = embarq-import-docto.cod-natur-operac NO-LOCK:
                {imp/im0665rp.i}
            END.
        END.
    END.
    ELSE DO:
        bloco:
        FOR EACH docum-est FIELDS(idi-nf-simples-remes cod-estabel serie-docto nro-docto cod-emitente nat-operacao dt-emissao char-1 mo-codigo cotacao-dia)
           WHERE TRIM(SUBSTR(docum-est.char-1,1,20)) = embarque-imp.embarque NO-LOCK:
            {imp/im0665rp.i}
        END.
    END.
    /*docum-est*/


    ASSIGN de-val-desp-aux-rea = 0.

    FOR EACH  tt-embarque-corpo
        WHERE tt-embarque-corpo.embarque    = embarque-imp.embarque
          AND tt-embarque-corpo.cod-estabel = embarque-imp.cod-estabel:

        IF i-pais-impto-usuario <> 1 /* Brasil */ THEN
            ASSIGN tt-embarque-corpo.desc-ger-ii2-rea = c-desc-ii.

        FOR EACH  tt-detalha-item
            WHERE tt-detalha-item.embarque     = tt-embarque-corpo.embarque
             AND  tt-detalha-item.cod-estabel  = tt-embarque-corpo.cod-estabel
            USE-INDEX ch-codigo:

            ASSIGN tt-embarque-corpo.vl-ger-mercado-orc           = tt-embarque-corpo.vl-ger-mercado-orc           + tt-detalha-item.vl-mercado-orc-total
                   tt-embarque-corpo.vl-ger-ii-orc                = tt-embarque-corpo.vl-ger-ii-orc                + tt-detalha-item.vl-ii-orc-aux

                   &IF "{&bf_mat_versao_ems}" < "2.062" &THEN
                   tt-embarque-corpo.vl-ger-ipi-orc               = tt-embarque-corpo.vl-ger-ipi-orc               + tt-detalha-item.vl-ipi-orc
                   tt-embarque-corpo.vl-ger-icms-orc              = tt-embarque-corpo.vl-ger-icms-orc              + tt-detalha-item.vl-icms-orc
                   tt-embarque-corpo.vl-ger-pis-orc               = tt-embarque-corpo.vl-ger-pis-orc               + tt-detalha-item.vl-pis-orc
                   tt-embarque-corpo.vl-ger-cofins-orc            = tt-embarque-corpo.vl-ger-cofins-orc            + tt-detalha-item.vl-cofins-orc
                   tt-embarque-corpo.vl-ger-tot-imp-orc           = tt-embarque-corpo.vl-ger-tot-imp-orc
                                                                    + IF tt-param.i-desp-imposto = 1 THEN  /*Despesa*/
                                                                       tt-detalha-item.vl-ipi-orc + tt-detalha-item.vl-icms-orc + tt-detalha-item.vl-pis-orc + tt-detalha-item.vl-cofins-orc
                                                                    ELSE /*Imposto*/
                                                                       tt-detalha-item.vl-ii-orc-aux + tt-detalha-item.vl-ipi-orc   + tt-detalha-item.vl-icms-orc + tt-detalha-item.vl-pis-orc + tt-detalha-item.vl-cofins-orc
                   &ELSE
                   tt-embarque-corpo.vl-ger-ipi-orc               = tt-embarque-corpo.vl-ger-ipi-orc
                                                                    + IF  tt-param.i-custo-item = 1 THEN
                                                                          tt-detalha-item.vl-ipi-orc * tt-detalha-item.quantidade
                                                                      ELSE
                                                                          tt-detalha-item.vl-ipi-orc
                   tt-embarque-corpo.vl-ger-icms-orc              = tt-embarque-corpo.vl-ger-icms-orc
                                                                    + IF  tt-param.i-custo-item = 1 THEN
                                                                          tt-detalha-item.vl-icms-orc * tt-detalha-item.quantidade
                                                                      ELSE
                                                                          tt-detalha-item.vl-icms-orc
                   tt-embarque-corpo.vl-ger-pis-orc               = tt-embarque-corpo.vl-ger-pis-orc
                                                                    + IF  tt-param.i-custo-item = 1 THEN
                                                                          (tt-detalha-item.vl-pis-orc * tt-detalha-item.quantidade)
                                                                      ELSE
                                                                          tt-detalha-item.vl-pis-orc
                   tt-embarque-corpo.vl-ger-cofins-orc            = tt-embarque-corpo.vl-ger-cofins-orc
                                                                    + IF  tt-param.i-custo-item = 1 THEN
                                                                          tt-detalha-item.vl-cofins-orc * tt-detalha-item.quantidade
                                                                      ELSE
                                                                          tt-detalha-item.vl-cofins-orc
                   tt-embarque-corpo.vl-ger-tot-imp-orc           = IF tt-param.i-desp-imposto = 1 THEN  /*Despesa*/
                                                                       tt-embarque-corpo.vl-ger-ipi-orc + tt-embarque-corpo.vl-ger-icms-orc + tt-embarque-corpo.vl-ger-pis-orc + tt-embarque-corpo.vl-ger-cofins-orc
                                                                    ELSE /*Imposto*/
                                                                       tt-embarque-corpo.vl-ger-ii-orc + tt-embarque-corpo.vl-ger-ipi-orc + tt-embarque-corpo.vl-ger-icms-orc + tt-embarque-corpo.vl-ger-pis-orc + tt-embarque-corpo.vl-ger-cofins-orc
                   &ENDIF
                   tt-embarque-corpo.vl-ger-ii2-orc               = tt-embarque-corpo.vl-ger-ii2-orc               + tt-detalha-item.vl-ii2-orc-aux
                   tt-embarque-corpo.vl-ger-des-orc               = tt-embarque-corpo.vl-ger-des-orc               + tt-detalha-item.vl-des-orc-total

                   tt-embarque-corpo.vl-ger-mercado-rea           = tt-embarque-corpo.vl-ger-mercado-rea           + tt-detalha-item.vl-mercado-rea-total
                   tt-embarque-corpo.vl-ger-ii-rea                = tt-embarque-corpo.vl-ger-ii-rea                + tt-detalha-item.vl-ii-rea-total
                   tt-embarque-corpo.vl-ger-ipi-rea               = tt-embarque-corpo.vl-ger-ipi-rea               + tt-detalha-item.vl-ipi-rea-total
                   tt-embarque-corpo.vl-ger-icms-rea              = tt-embarque-corpo.vl-ger-icms-rea              + tt-detalha-item.vl-icms-rea-total
                   tt-embarque-corpo.vl-ger-pis-rea               = tt-embarque-corpo.vl-ger-pis-rea               + tt-detalha-item.vl-pis-rea-total
                   tt-embarque-corpo.vl-ger-cofins-rea            = tt-embarque-corpo.vl-ger-cofins-rea            + tt-detalha-item.vl-cofins-rea-total
                   tt-embarque-corpo.vl-ger-tot-imp-rea           = tt-embarque-corpo.vl-ger-tot-imp-rea           + tt-detalha-item.vl-tot-imp-rea-total
                   tt-embarque-corpo.vl-ger-ii2-rea               = tt-embarque-corpo.vl-ger-ii2-rea               + tt-detalha-item.vl-ii2-rea-total
                   tt-embarque-corpo.vl-ger-des-rea               = tt-embarque-corpo.vl-ger-des-rea               + tt-detalha-item.vl-des-rea-total
                   tt-embarque-corpo.vl-ger-tot-com-ipi-icms-rea  = tt-embarque-corpo.vl-ger-tot-com-ipi-icms-rea  + tt-detalha-item.vl-tot-com-ipi-icms-rea-total
                   tt-embarque-corpo.vl-ger-tot-sem-ipi-icms-rea  = tt-embarque-corpo.vl-ger-tot-sem-ipi-icms-rea  + tt-detalha-item.vl-tot-sem-ipi-icms-rea-total

                   tt-embarque-corpo.total-vl-frete               = tt-embarque-corpo.total-vl-frete               + tt-detalha-item.vl-des-frete
                   tt-embarque-corpo.total-vl-embalagem           = tt-embarque-corpo.total-vl-embalagem           + tt-detalha-item.vl-des-embalagem
                   tt-embarque-corpo.total-vl-seguro              = tt-embarque-corpo.total-vl-seguro              + tt-detalha-item.vl-des-seguro
                   tt-embarque-corpo.total-vl-outras              = tt-embarque-corpo.total-vl-outras              + tt-detalha-item.vl-des-outras

                   tt-embarque-corpo.per-mercado                  = (tt-embarque-corpo.vl-ger-mercado-rea * 100)   / tt-embarque-corpo.vl-ger-mercado-rea
                   tt-embarque-corpo.per-imposto                  = (tt-embarque-corpo.vl-ger-tot-imp-rea * 100)   / tt-embarque-corpo.vl-ger-mercado-rea
                   tt-embarque-corpo.per-ii                       = (tt-embarque-corpo.vl-ger-ii-rea      * 100)   / tt-embarque-corpo.vl-ger-mercado-rea.

                   IF  i-pais-impto-usuario <> 1 /* Brasil */ THEN
                       ASSIGN tt-embarque-corpo.mo-ger-mercado-rea    = tt-detalha-item.mo-ger-mercado-rea
                              tt-embarque-corpo.vl-ger-mercado-rea-mo = tt-embarque-corpo.vl-ger-mercado-rea-mo + tt-detalha-item.vl-ger-mercado-rea-mo
                              tt-embarque-corpo.vl-ger-ii2-rea-mo     = tt-embarque-corpo.vl-ger-ii2-rea-mo + tt-detalha-item.vl-ger-ii2-rea-mo
                              tt-embarque-corpo.mo-ii2-rea            = tt-detalha-item.mo-ii2-rea.

            /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-820) */
            IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                ASSIGN tt-embarque-corpo.vl-ger-cbs-rea     = tt-embarque-corpo.vl-ger-cbs-rea    + tt-detalha-item.vl-cbs-rea-total
                       tt-embarque-corpo.vl-ger-ibs-uf-rea  = tt-embarque-corpo.vl-ger-ibs-uf-rea + tt-detalha-item.vl-ibs-uf-rea-total
                       tt-embarque-corpo.vl-ger-ibs-mun-rea = tt-embarque-corpo.vl-ger-ibs-mun-rea + tt-detalha-item.vl-ibs-mun-rea-total
                       tt-embarque-corpo.vl-ger-is-rea      = tt-embarque-corpo.vl-ger-is-rea      + tt-detalha-item.vl-is-rea-total
                       tt-embarque-corpo.per-ger-cbs-rea    = (tt-embarque-corpo.vl-ger-cbs-rea / tt-embarque-corpo.vl-ger-mercado-rea) * 100
                       tt-embarque-corpo.per-ger-ibs-uf-rea = (tt-embarque-corpo.vl-ger-ibs-uf-rea / tt-embarque-corpo.vl-ger-mercado-rea) * 100
                       tt-embarque-corpo.per-ger-ibs-mun-rea = (tt-embarque-corpo.vl-ger-ibs-mun-rea / tt-embarque-corpo.vl-ger-mercado-rea) * 100
                       tt-embarque-corpo.per-ger-is-rea      = (tt-embarque-corpo.vl-ger-is-rea      / tt-embarque-corpo.vl-ger-mercado-rea) * 100.

                IF  tt-embarque-corpo.per-ger-cbs-rea = ? THEN
                    ASSIGN tt-embarque-corpo.per-ger-cbs-rea = 0.

                IF  tt-embarque-corpo.per-ger-ibs-uf-rea = ? THEN
                    ASSIGN tt-embarque-corpo.per-ger-ibs-uf-rea = 0.
                    
                IF  tt-embarque-corpo.per-ger-ibs-mun-rea = ? THEN
                    ASSIGN tt-embarque-corpo.per-ger-ibs-mun-rea = 0.

                IF  tt-embarque-corpo.per-ger-is-rea = ? THEN
                    ASSIGN tt-embarque-corpo.per-ger-is-rea = 0.
            END.
            /* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-820) */

            IF  tt-embarque-corpo.vl-ger-mercado-orc = ? THEN
                ASSIGN tt-embarque-corpo.vl-ger-mercado-orc = 0.

            ASSIGN de-tot-rea = 0.
            FOR EACH tt-detalha-despesa-aux
               WHERE tt-detalha-despesa-aux.embarque    = tt-embarque-corpo.embarque
                 AND tt-detalha-despesa-aux.cod-estabel = tt-embarque-corpo.cod-estabel:

                ASSIGN de-tot-rea = de-tot-rea + tt-detalha-despesa-aux.vl-des-rea.

            END.

            IF tt-param.i-desp-imposto = 1 THEN
                ASSIGN tt-embarque-corpo.vl-ger-tot-des-rea = de-tot-rea + tt-embarque-corpo.vl-ger-ii2-rea.
            ELSE
                ASSIGN tt-embarque-corpo.vl-ger-tot-des-rea = de-tot-rea.

            IF tt-param.l-desp-imposto THEN DO: /*detalha despesa/impostos*/
                ASSIGN tt-embarque-corpo.per-despesa     = (tt-embarque-corpo.vl-ger-tot-des-rea * 100) /
                                                            tt-embarque-corpo.vl-ger-mercado-rea.
            END.
            ELSE  DO:
                ASSIGN tt-embarque-corpo.per-despesa     = (tt-embarque-corpo.vl-ger-tot-des-rea * 100) /
                                                            tt-embarque-corpo.vl-ger-mercado-rea.
            END.

            /* Convers∆o */
            IF tt-param.moeda <> var-moeda-conv-rea THEN DO:
                IF tt-param.l-desp-imposto THEN DO:
                    ASSIGN tt-embarque-corpo.vl-ger-tot-imp-des-rea = tt-embarque-corpo.vl-ger-tot-des-rea     +
                                                                      tt-embarque-corpo.vl-ger-tot-imp-rea.
                END.
                ELSE DO:
                    ASSIGN tt-embarque-corpo.vl-ger-tot-imp-des-rea = tt-embarque-corpo.vl-ger-tot-des-rea     +
                                                                      tt-embarque-corpo.vl-ger-tot-imp-rea.
                END.
            END.
            ELSE DO:
                IF NOT tt-param.l-desp-imposto THEN DO:
                    ASSIGN tt-embarque-corpo.per-despesa              = (tt-embarque-corpo.vl-ger-tot-des-rea * 100) /
                                                                         tt-embarque-corpo.vl-ger-mercado-rea.
                END.
                ASSIGN tt-embarque-corpo.vl-ger-tot-imp-des-rea       = tt-embarque-corpo.vl-ger-tot-imp-rea
                                                                      + tt-embarque-corpo.vl-ger-tot-des-rea.
            END.

            ASSIGN tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea   = tt-detalha-item.vl-tot-des-rea +
                                                                        tt-detalha-item.vl-tot-imp-rea +
                                                                        tt-detalha-item.vl-mercado-rea
                   tt-detalha-item.vl-tot-sem-ipi-icms-dsp-merc-rea   = tt-detalha-item.vl-tot-des-rea +
                                                                        tt-detalha-item.vl-mercado-rea
                   tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea = tt-embarque-corpo.vl-ger-tot-des-rea +
                                                                        tt-embarque-corpo.vl-ger-tot-imp-rea +
                                                                        tt-embarque-corpo.vl-ger-mercado-rea
                   tt-embarque-corpo.vl-ger-tot-sem-ipi-icms-merc-rea = tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea -
                                                                        tt-embarque-corpo.vl-ger-tot-imp-rea.
            IF tt-param.i-compar-merc = 1 THEN DO:  /*Total Da nota*/
                /*PERCENTUAL TT-DETALHA-ITEM - REALIZADO*/

                ASSIGN tt-detalha-item.per-ipi-rea                = (tt-detalha-item.vl-ipi-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea) * 100
                       tt-detalha-item.per-icms-rea               = (tt-detalha-item.vl-icms-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea) * 100
                       tt-detalha-item.per-pis-rea                = (tt-detalha-item.vl-pis-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea) * 100
                       tt-detalha-item.per-cofins-rea             = (tt-detalha-item.vl-cofins-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea) * 100
                       tt-detalha-item.per-mercado-orc            = (tt-detalha-item.vl-mercado-orc
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                       tt-detalha-item.per-mercado-rea            = (tt-detalha-item.vl-mercado-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea) * 100
                       tt-detalha-item.per-ii-orc                 = (tt-detalha-item.vl-ii-orc
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                       tt-detalha-item.per-ii-rea                 = (tt-detalha-item.vl-ii-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea) * 100
                       tt-detalha-item.per-ipi-orc                = (tt-detalha-item.vl-ipi-orc
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                       tt-detalha-item.per-icms-orc               = (tt-detalha-item.vl-icms-orc
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                       tt-detalha-item.per-pis-orc                = (tt-detalha-item.vl-pis-orc
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                       tt-detalha-item.per-cofins-orc             = (tt-detalha-item.vl-cofins-orc
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                       tt-detalha-item.per-tot-imp-orc            = (tt-detalha-item.vl-tot-imp-orc
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                       tt-detalha-item.per-tot-imp-rea            = (tt-detalha-item.vl-tot-imp-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea) * 100
                       tt-detalha-item.per-ii2-orc                = (tt-detalha-item.vl-ii2-orc
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                       tt-detalha-item.per-ii2-rea                = (tt-detalha-item.vl-ii2-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea) * 100
                       tt-detalha-item.per-tot-des-orc            = (tt-detalha-item.vl-tot-des-orc
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                       tt-detalha-item.per-tot-des-rea            = (tt-detalha-item.vl-tot-des-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea) * 100
                       tt-detalha-item.per-tot-imp-des-orc        = (tt-detalha-item.vl-tot-imp-des-orc
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                       tt-detalha-item.per-tot-imp-des-rea        = (tt-detalha-item.vl-tot-imp-des-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea) * 100
                       tt-detalha-item.per-tot-com-ipi-icms-orc   = (tt-detalha-item.vl-tot-com-ipi-icms-orc-total
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                       tt-detalha-item.per-tot-com-ipi-icms-rea   = (tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea) * 100
                       tt-detalha-item.per-tot-sem-ipi-icms-orc   = (tt-detalha-item.vl-tot-sem-ipi-icms-orc-total
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                       tt-detalha-item.per-tot-sem-ipi-icms-rea   = (tt-detalha-item.vl-tot-sem-ipi-icms-dsp-merc-rea /
                                                                     tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea) * 100.

                IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                    ASSIGN tt-detalha-item.per-cbs-orc            = (tt-detalha-item.vl-cbs-orc
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                           tt-detalha-item.per-cbs-rea            = (tt-detalha-item.vl-cbs-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea) * 100
                           tt-detalha-item.per-ibs-uf-orc         = (tt-detalha-item.vl-ibs-uf-orc
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                           tt-detalha-item.per-ibs-uf-rea         = (tt-detalha-item.vl-ibs-uf-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea) * 100
                           tt-detalha-item.per-ibs-mun-orc        = (tt-detalha-item.vl-ibs-mun-orc
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                           tt-detalha-item.per-ibs-mun-rea        = (tt-detalha-item.vl-ibs-mun-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea) * 100
                           tt-detalha-item.per-is-orc             = (tt-detalha-item.vl-is-orc
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                           tt-detalha-item.per-is-rea             = (tt-detalha-item.vl-is-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea) * 100.
                END.
            END.
            ELSE DO: /*Valor da Mercadoria*/
                ASSIGN tt-detalha-item.per-ipi-rea                = (tt-detalha-item.vl-ipi-rea
                                                                  /  tt-detalha-item.vl-mercado-rea) * 100
                       tt-detalha-item.per-icms-rea               = (tt-detalha-item.vl-icms-rea
                                                                  /  tt-detalha-item.vl-mercado-rea) * 100
                       tt-detalha-item.per-pis-rea                = (tt-detalha-item.vl-pis-rea
                                                                  /  tt-detalha-item.vl-mercado-rea) * 100
                       tt-detalha-item.per-cofins-rea             = (tt-detalha-item.vl-cofins-rea
                                                                  /  tt-detalha-item.vl-mercado-rea) * 100
                       tt-detalha-item.per-mercado-orc            = (tt-detalha-item.vl-mercado-orc
                                                                  /  tt-detalha-item.vl-mercado-orc) * 100
                       tt-detalha-item.per-mercado-rea            = (tt-detalha-item.vl-mercado-rea
                                                                  /  tt-detalha-item.vl-mercado-rea) * 100
                       tt-detalha-item.per-ii-orc                 = (tt-detalha-item.vl-ii-orc
                                                                  /  tt-detalha-item.vl-mercado-orc) * 100
                       tt-detalha-item.per-ii-rea                 = (tt-detalha-item.vl-ii-rea
                                                                  /  tt-detalha-item.vl-mercado-rea) * 100
                       tt-detalha-item.per-ipi-orc                = (tt-detalha-item.vl-ipi-orc
                                                                  /  tt-detalha-item.vl-mercado-orc) * 100
                       tt-detalha-item.per-icms-orc               = (tt-detalha-item.vl-icms-orc
                                                                  /  tt-detalha-item.vl-mercado-orc) * 100
                       tt-detalha-item.per-pis-orc                = (tt-detalha-item.vl-pis-orc
                                                                  /  tt-detalha-item.vl-mercado-orc) * 100
                       tt-detalha-item.per-cofins-orc             = (tt-detalha-item.vl-cofins-orc
                                                                  /  tt-detalha-item.vl-mercado-orc) * 100
                       tt-detalha-item.per-tot-imp-orc            = (tt-detalha-item.vl-tot-imp-orc
                                                                  /  tt-detalha-item.vl-mercado-orc) * 100
                       tt-detalha-item.per-tot-imp-rea            = (tt-detalha-item.vl-tot-imp-rea
                                                                  /  tt-detalha-item.vl-mercado-rea) * 100
                       tt-detalha-item.per-ii2-orc                = (tt-detalha-item.vl-ii2-orc
                                                                  /  tt-detalha-item.vl-mercado-orc) * 100
                       tt-detalha-item.per-ii2-rea                = (tt-detalha-item.vl-ii2-rea
                                                                  /  tt-detalha-item.vl-mercado-rea) * 100
                       tt-detalha-item.per-tot-des-orc            = (tt-detalha-item.vl-tot-des-orc
                                                                  /  tt-detalha-item.vl-mercado-orc) * 100
                       tt-detalha-item.per-tot-des-rea            = (tt-detalha-item.vl-tot-des-rea
                                                                  /  tt-detalha-item.vl-mercado-rea) * 100
                       tt-detalha-item.per-tot-imp-des-orc        = (tt-detalha-item.vl-tot-imp-des-orc
                                                                  /  tt-detalha-item.vl-mercado-orc) * 100
                       tt-detalha-item.per-tot-imp-des-rea        = (tt-detalha-item.vl-tot-imp-des-rea
                                                                  /  tt-detalha-item.vl-mercado-rea) * 100
                       tt-detalha-item.per-tot-com-ipi-icms-orc   = (tt-detalha-item.vl-tot-com-ipi-icms-orc-total
                                                                  /  tt-detalha-item.vl-mercado-orc) * 100
                       tt-detalha-item.per-tot-com-ipi-icms-rea   = (tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea
                                                                  /  tt-detalha-item.vl-mercado-rea) * 100
                       tt-detalha-item.per-tot-sem-ipi-icms-orc   = (tt-detalha-item.vl-tot-sem-ipi-icms-orc-total
                                                                  /  tt-detalha-item.vl-mercado-orc) * 100
                       tt-detalha-item.per-tot-sem-ipi-icms-rea   = (tt-detalha-item.vl-tot-sem-ipi-icms-dsp-merc-rea /
                                                                     tt-detalha-item.vl-mercado-rea) * 100.

                IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                    ASSIGN tt-detalha-item.per-cbs-orc            = (tt-detalha-item.vl-cbs-orc
                                                                  /  tt-detalha-item.vl-mercado-orc) * 100
                           tt-detalha-item.per-cbs-rea            = (tt-detalha-item.vl-cbs-rea
                                                                  /  tt-detalha-item.vl-mercado-rea) * 100
                           tt-detalha-item.per-ibs-uf-orc         = (tt-detalha-item.vl-ibs-uf-orc
                                                                  /  tt-detalha-item.vl-mercado-orc) * 100
                           tt-detalha-item.per-ibs-uf-rea         = (tt-detalha-item.vl-ibs-uf-rea
                                                                  /  tt-detalha-item.vl-mercado-rea) * 100
                           tt-detalha-item.per-ibs-mun-orc        = (tt-detalha-item.vl-ibs-mun-orc
                                                                  /  tt-detalha-item.vl-mercado-orc) * 100
                           tt-detalha-item.per-ibs-mun-rea        = (tt-detalha-item.vl-ibs-mun-rea
                                                                  /  tt-detalha-item.vl-mercado-rea) * 100
                           tt-detalha-item.per-is-orc             = (tt-detalha-item.vl-is-orc
                                                                  /  tt-detalha-item.vl-mercado-orc) * 100
                           tt-detalha-item.per-is-rea             = (tt-detalha-item.vl-is-rea
                                                                  /  tt-detalha-item.vl-mercado-rea) * 100.
                END.
            END.

            IF tt-detalha-item.vl-tot-com-ipi-icms-orc-total = ? THEN
                ASSIGN tt-detalha-item.vl-tot-com-ipi-icms-orc-total = 0.

            IF tt-detalha-item.vl-tot-sem-ipi-icms-orc-total = ? THEN
                ASSIGN tt-detalha-item.vl-tot-sem-ipi-icms-orc-total = 0.

            IF tt-detalha-item.vl-mercado-orc = ? THEN
                ASSIGN tt-detalha-item.vl-mercado-orc = 0.

            IF tt-detalha-item.per-mercado-orc = ? THEN
                ASSIGN tt-detalha-item.per-mercado-orc = 0.

            IF tt-detalha-item.per-mercado-orc = ? THEN
                ASSIGN tt-detalha-item.per-mercado-orc = 0.

            IF tt-detalha-item.per-ii-orc = ? THEN
                ASSIGN tt-detalha-item.per-ii-orc = 0.

            IF tt-detalha-item.per-ipi-orc = ? THEN
                ASSIGN tt-detalha-item.per-ipi-orc = 0.

            IF tt-detalha-item.per-icms-orc = ? THEN
                ASSIGN tt-detalha-item.per-icms-orc = 0.

            IF tt-detalha-item.per-pis-orc = ? THEN
                ASSIGN tt-detalha-item.per-pis-orc = 0.

            IF tt-detalha-item.per-cofins-orc = ? THEN
                ASSIGN tt-detalha-item.per-cofins-orc = 0.

            IF tt-detalha-item.per-tot-imp-orc = ? THEN
                ASSIGN tt-detalha-item.per-tot-imp-orc = 0.

            IF tt-detalha-item.per-ii2-orc = ? THEN
                ASSIGN tt-detalha-item.per-ii2-orc = 0.

            IF tt-detalha-item.per-tot-des-orc = ? THEN
                ASSIGN tt-detalha-item.per-tot-des-orc = 0.

            IF tt-detalha-item.per-tot-imp-des-orc = ? THEN
                ASSIGN tt-detalha-item.per-tot-imp-des-orc = 0.

            IF tt-detalha-item.per-tot-com-ipi-icms-orc = ? THEN
                ASSIGN tt-detalha-item.per-tot-com-ipi-icms-orc = 0.

            IF tt-detalha-item.per-tot-sem-ipi-icms-orc = ? THEN
                ASSIGN tt-detalha-item.per-tot-sem-ipi-icms-orc = 0.

            /*C†lculo dos percentuais das despesas do tt-detalha-item - Oráado e Realizado*/
            FOR EACH  tt-detalha-despesa WHERE tt-detalha-despesa.embarque     = embarque-imp.embarque
                                         AND   tt-detalha-despesa.cod-estabel  = embarque-imp.cod-estabel
                                         AND   tt-detalha-despesa.numero-ordem = tt-detalha-item.numero-ordem
                                         AND   tt-detalha-despesa.it-codigo    = tt-detalha-item.it-codigo
                                         AND   tt-detalha-despesa.sequencia    = tt-detalha-item.sequencia
                                    BREAK BY   tt-detalha-despesa.cod-despesa:

                ASSIGN de-tot-desp-rea = de-tot-desp-rea + tt-detalha-despesa.vl-des-rea.

                IF LAST-OF(tt-detalha-despesa.cod-despesa) THEN DO:

                    IF tt-param.i-compar-merc = 1 THEN DO:  /*Total Da nota*/

                        ASSIGN tt-detalha-despesa.per-des-orc = (tt-detalha-despesa.vl-des-orc
                                                              /  tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                               tt-detalha-despesa.per-des-rea = (de-tot-desp-rea
                                                              /  tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea) * 100.
                    END.
                    ELSE DO: /*Valor Mercadoria*/

                        ASSIGN tt-detalha-despesa.per-des-orc = (tt-detalha-despesa.vl-des-orc
                                                              /  tt-detalha-item.vl-mercado-rea) * 100
                               tt-detalha-despesa.per-des-rea = (de-tot-desp-rea
                                                              /  tt-detalha-item.vl-mercado-rea) * 100.
                    END.
                    IF tt-detalha-despesa.per-des-orc = ? THEN
                        ASSIGN tt-detalha-despesa.per-des-orc = 0.

                    assign de-tot-desp-rea = 0.

                END.

            END.
            ASSIGN de-tot-orc = 0.
            FOR EACH tt-detalha-despesa-aux
               WHERE tt-detalha-despesa-aux.embarque    = tt-embarque-corpo.embarque
                 AND tt-detalha-despesa-aux.cod-estabel = tt-embarque-corpo.cod-estabel
                 AND tt-detalha-despesa-aux.sequencia   = tt-detalha-despesa-aux.sequencia:

                ASSIGN de-tot-orc = de-tot-orc + tt-detalha-despesa-aux.vl-des-orc.
            END.
        END. /*tt-detalha-item*/

        IF i-pais-impto-usuario = 21 THEN DO:

            FOR EACH docum-est NO-LOCK
                WHERE docum-est.cod-emitente  = ordem-compra.cod-emitente
                AND   docum-est.embarque      = embarque-imp.embarque:

                FOR EACH  dupli-imp
                    WHERE dupli-imp.serie-docto  = docum-est.serie-docto
                    AND   dupli-imp.nro-docto    = docum-est.nro-docto
                    AND   dupli-imp.cod-emitente = docum-est.cod-emitente
                    AND   dupli-imp.nat-operacao = docum-est.nat-operacao NO-LOCK,
                    FIRST tipo-tax NO-LOCK
                    WHERE tipo-tax.cod-tax = dupli-imp.int-1
                    AND   tipo-tax.tipo    = 2 /*IVA*/,
                    FIRST tipo-tax-internac
                    WHERE tipo-tax-internac.cod-tax          = tipo-tax.cod-tax
                      AND tipo-tax-internac.log-cr-saida-div = NO /*CrÇdito ISD*/ :

                    FIND FIRST natur-oper
                         WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR.
                    IF AVAIL natur-oper THEN do:

                        IF natur-oper.nota-rateio = YES THEN DO:

                            ASSIGN tt-embarque-corpo.vl-ger-ii-orc = tt-embarque-corpo.vl-ger-ii-orc + dupli-imp.vl-imposto. /* IVA Complementar */

                            IF tt-param.moeda <> 0 THEN DO:

                                ASSIGN d-iva-convert = 0.
                                run cdp/cd0812.p (input  0,               /*moeda origem*/
                                                  input  tt-param.moeda,  /*moeda destino*/
                                                  input  tt-embarque-corpo.vl-ger-ii-orc,  /*valor origem*/
                                                  input  d-data-conv,     /*data conversao*/
                                                  output d-iva-convert). /*valor destino*/

                                ASSIGN tt-embarque-corpo.vl-ger-ii-orc = TRUNCATE(d-iva-convert,2).

                            END.

                        END.
                        ELSE DO:
                            ASSIGN tt-embarque-corpo.vl-ger-ipi-rea = tt-embarque-corpo.vl-ger-ipi-rea + dupli-imp.vl-imposto. /* valor do IVA da nota principal */

                            IF tt-param.moeda <> 0 THEN DO:

                                ASSIGN d-iva-convert = 0.
                                run cdp/cd0812.p (input  0,               /*moeda origem*/
                                                  input  tt-param.moeda,  /*moeda destino*/
                                                  input  tt-embarque-corpo.vl-ger-ipi-rea,  /*valor origem*/
                                                  input  d-data-conv,     /*data conversao*/
                                                  output d-iva-convert). /*valor destino*/


			                    ASSIGN tt-embarque-corpo.vl-ger-ipi-rea = TRUNCATE(d-iva-convert,2).

                            END.
                        END.
                    END.
                END.
            END.
        END.

        /*C†lculo dos percentuais das despesas do tt-embarque-corpo - Oráado e Realizado*/
        IF tt-param.i-desp-imposto = 1 THEN /*Despesa*/
            ASSIGN tt-embarque-corpo.vl-ger-tot-des-orc  = tt-embarque-corpo.vl-ger-ii2-orc
                                                         + de-tot-orc.
        ELSE /*Imposto*/
            ASSIGN tt-embarque-corpo.vl-ger-tot-des-orc  = de-tot-orc.

        ASSIGN tt-embarque-corpo.vl-ger-tot-imp-des-orc       = tt-embarque-corpo.vl-ger-tot-imp-orc
                                                              + tt-embarque-corpo.vl-ger-tot-des-orc
               tt-embarque-corpo.vl-ger-tot-com-ipi-icms-orc  = tt-embarque-corpo.vl-ger-mercado-orc
                                                              + tt-embarque-corpo.vl-ger-tot-imp-orc
                                                              + tt-embarque-corpo.vl-ger-tot-des-orc
               tt-embarque-corpo.vl-ger-tot-sem-ipi-icms-orc  = tt-embarque-corpo.vl-ger-mercado-orc
                                                              + tt-embarque-corpo.vl-ger-tot-des-orc.
        FOR EACH tt-detalha-despesa-aux
           WHERE tt-detalha-despesa-aux.embarque    = embarque-imp.embarque
             AND tt-detalha-despesa-aux.cod-estabel = embarque-imp.cod-estabel:
            IF tt-param.l-desp-imposto THEN DO:
                IF i-pais-impto-usuario = 1 /* Brasil */ THEN DO:
                    IF tt-param.i-compar-merc = 1 THEN DO:  /*Total Da nota*/
                        ASSIGN tt-detalha-despesa-aux.per-des-orc  = (tt-detalha-despesa-aux.vl-des-orc /
                                                                      tt-embarque-corpo.vl-ger-mercado-orc) * 100
                               tt-detalha-despesa-aux.per-des-rea  = (tt-detalha-despesa-aux.vl-des-rea /
                                                                      tt-embarque-corpo.vl-ger-mercado-orc) * 100.
                    END.
                    ELSE DO: /*Valor Mercadoria*/
                        ASSIGN tt-detalha-despesa-aux.per-des-orc  = (tt-detalha-despesa-aux.vl-des-orc /
                                                                      tt-embarque-corpo.vl-ger-mercado-rea) * 100
                               tt-detalha-despesa-aux.per-des-rea  = (tt-detalha-despesa-aux.vl-des-rea /
                                                                      tt-embarque-corpo.vl-ger-mercado-rea) * 100.
                    END.
                END.
                ELSE DO:
                    ASSIGN tt-detalha-despesa-aux.per-des-rea  = (tt-detalha-despesa-aux.vl-des-rea /
                                                                  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea) * 100.
                END.


                IF tt-detalha-despesa-aux.per-des-orc = ? THEN
                    ASSIGN tt-detalha-despesa-aux.per-des-orc = 0.
            END.
        END.

        IF  i-pais-impto-usuario <> 1 /* Brasil*/ THEN DO:
            /* C†lculo dos Percentuais para os impostos do internacional */
            FOR EACH tt-impto-internac
                WHERE tt-impto-internac.embarque    = tt-embarque-corpo.embarque
                  AND tt-impto-internac.cod-estabel = tt-embarque-corpo.cod-estabel:

                IF tt-param.i-compar-merc = 1 THEN DO:  /*Total Da nota*/
                    ASSIGN tt-impto-internac.perc-impto = (tt-impto-internac.val-impto-moeda-relat
                                                           / tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea) * 100.
                END.
                ELSE DO: /*Valor Mercadoria*/
                    ASSIGN tt-impto-internac.perc-impto = (tt-impto-internac.val-impto-moeda-relat
                                                           / tt-embarque-corpo.vl-ger-mercado-rea) * 100.
                END.

                IF  tt-impto-internac.perc-impto = ? THEN
                    ASSIGN tt-impto-internac.perc-impto = 0.
            END.
        END.

        IF tt-param.i-compar-merc = 1 THEN DO:  /*Total Da nota*/
            /* PERCENTUAIS */
            assign /* -------------- ORÄADO -------------- */
                   tt-embarque-corpo.per-ger-mercado-orc          = (tt-embarque-corpo.vl-ger-mercado-orc
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-orc) * 100
                   tt-embarque-corpo.per-ger-ii-orc               = (tt-embarque-corpo.vl-ger-ii-orc
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-orc) * 100
                   tt-embarque-corpo.per-ger-ipi-orc              = (tt-embarque-corpo.vl-ger-ipi-orc
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-orc) * 100
                   tt-embarque-corpo.per-ger-icms-orc             = (tt-embarque-corpo.vl-ger-icms-orc
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-orc) * 100
                   tt-embarque-corpo.per-ger-pis-orc              = (tt-embarque-corpo.vl-ger-pis-orc
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-orc) * 100
                   tt-embarque-corpo.per-ger-cofins-orc           = (tt-embarque-corpo.vl-ger-cofins-orc
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-orc) * 100
                   tt-embarque-corpo.per-ger-tot-imp-orc          = (tt-embarque-corpo.vl-ger-tot-imp-orc
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-orc) * 100
                   tt-embarque-corpo.per-ger-ii2-orc              = (tt-embarque-corpo.vl-ger-ii2-orc
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-orc) * 100
                   tt-embarque-corpo.per-ger-des-orc              = (tt-embarque-corpo.vl-ger-des-orc
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-orc) * 100
                   tt-embarque-corpo.per-ger-tot-des-orc          = (tt-embarque-corpo.vl-ger-tot-des-orc
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-orc) * 100
                   tt-embarque-corpo.per-ger-tot-imp-des-orc      = (tt-embarque-corpo.vl-ger-tot-imp-des-orc
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-orc) * 100
                   tt-embarque-corpo.per-ger-tot-com-ipi-icms-orc = (tt-embarque-corpo.vl-ger-tot-com-ipi-icms-orc
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-orc) * 100
                   tt-embarque-corpo.per-ger-tot-sem-ipi-icms-orc = (tt-embarque-corpo.vl-ger-tot-sem-ipi-icms-orc
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-orc) * 100

                   /* -------------- REALIZADO -------------- */
                   tt-embarque-corpo.per-ger-mercado-rea          = (tt-embarque-corpo.vl-ger-mercado-rea
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea) * 100
                   tt-embarque-corpo.per-ger-ii-rea               = (tt-embarque-corpo.vl-ger-ii-rea
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea) * 100
                   tt-embarque-corpo.per-ger-ipi-rea              = (tt-embarque-corpo.vl-ger-ipi-rea
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea) * 100
                   tt-embarque-corpo.per-ger-icms-rea             = (tt-embarque-corpo.vl-ger-icms-rea
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea) * 100
                   tt-embarque-corpo.per-ger-pis-rea              = (tt-embarque-corpo.vl-ger-pis-rea
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea) * 100
                   tt-embarque-corpo.per-ger-cofins-rea           = (tt-embarque-corpo.vl-ger-cofins-rea
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea) * 100
                   tt-embarque-corpo.per-ger-tot-imp-rea          = (tt-embarque-corpo.vl-ger-tot-imp-rea
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea) * 100
                   tt-embarque-corpo.per-ger-ii2-rea              = (tt-embarque-corpo.vl-ger-ii2-rea
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea) * 100
                   tt-embarque-corpo.per-ger-des-rea              = (tt-embarque-corpo.vl-ger-des-rea
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea) * 100
                   tt-embarque-corpo.per-ger-tot-des-rea          = (tt-embarque-corpo.vl-ger-tot-des-rea
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea) * 100
                   tt-embarque-corpo.per-ger-tot-imp-des-rea      = (tt-embarque-corpo.vl-ger-tot-imp-des-rea
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea) * 100
                   tt-embarque-corpo.per-ger-tot-com-ipi-icms-rea = (tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea) * 100
                   tt-embarque-corpo.per-ger-tot-sem-ipi-icms-rea = (tt-embarque-corpo.vl-ger-tot-sem-ipi-icms-merc-rea
                                                                  /  tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea) * 100.
        END.
        ELSE DO: /*Valor da mercadoria*/
            /* PERCENTUAIS */
            assign /* -------------- ORÄADO -------------- */
                   tt-embarque-corpo.per-ger-mercado-orc          = (tt-embarque-corpo.vl-ger-mercado-orc
                                                                  /  tt-embarque-corpo.vl-ger-mercado-orc) * 100
                   tt-embarque-corpo.per-ger-ii-orc               = (tt-embarque-corpo.vl-ger-ii-orc
                                                                  /  tt-embarque-corpo.vl-ger-mercado-orc) * 100
                   tt-embarque-corpo.per-ger-ipi-orc              = (tt-embarque-corpo.vl-ger-ipi-orc
                                                                  /  tt-embarque-corpo.vl-ger-mercado-orc) * 100
                   tt-embarque-corpo.per-ger-icms-orc             = (tt-embarque-corpo.vl-ger-icms-orc
                                                                  /  tt-embarque-corpo.vl-ger-mercado-orc) * 100
                   tt-embarque-corpo.per-ger-pis-orc              = (tt-embarque-corpo.vl-ger-pis-orc
                                                                  /  tt-embarque-corpo.vl-ger-mercado-orc) * 100
                   tt-embarque-corpo.per-ger-cofins-orc           = (tt-embarque-corpo.vl-ger-cofins-orc
                                                                  /  tt-embarque-corpo.vl-ger-mercado-orc) * 100
                   tt-embarque-corpo.per-ger-tot-imp-orc          = (tt-embarque-corpo.vl-ger-tot-imp-orc
                                                                  /  tt-embarque-corpo.vl-ger-mercado-orc) * 100
                   tt-embarque-corpo.per-ger-ii2-orc              = (tt-embarque-corpo.vl-ger-ii2-orc
                                                                  /  tt-embarque-corpo.vl-ger-mercado-orc) * 100
                   tt-embarque-corpo.per-ger-des-orc              = (tt-embarque-corpo.vl-ger-des-orc
                                                                  /  tt-embarque-corpo.vl-ger-mercado-orc) * 100
                   tt-embarque-corpo.per-ger-tot-des-orc          = (tt-embarque-corpo.vl-ger-tot-des-orc
                                                                  /  tt-embarque-corpo.vl-ger-mercado-orc) * 100
                   tt-embarque-corpo.per-ger-tot-imp-des-orc      = (tt-embarque-corpo.vl-ger-tot-imp-des-orc
                                                                  /  tt-embarque-corpo.vl-ger-mercado-orc) * 100
                   tt-embarque-corpo.per-ger-tot-com-ipi-icms-orc = (tt-embarque-corpo.vl-ger-mercado-orc
                                                                  /  tt-embarque-corpo.vl-ger-mercado-orc) * 100
                   tt-embarque-corpo.per-ger-tot-sem-ipi-icms-orc = (tt-embarque-corpo.vl-ger-tot-sem-ipi-icms-orc
                                                                  /  tt-embarque-corpo.vl-ger-mercado-orc) * 100

                   /* -------------- REALIZADO -------------- */
                   tt-embarque-corpo.per-ger-mercado-rea          = (tt-embarque-corpo.vl-ger-mercado-rea
                                                                  /  tt-embarque-corpo.vl-ger-mercado-rea) * 100
                   tt-embarque-corpo.per-ger-ii-rea               = (tt-embarque-corpo.vl-ger-ii-rea
                                                                  /  tt-embarque-corpo.vl-ger-mercado-rea) * 100
                   tt-embarque-corpo.per-ger-ipi-rea              = (tt-embarque-corpo.vl-ger-ipi-rea
                                                                  /  tt-embarque-corpo.vl-ger-mercado-rea) * 100
                   tt-embarque-corpo.per-ger-icms-rea             = (tt-embarque-corpo.vl-ger-icms-rea
                                                                  /  tt-embarque-corpo.vl-ger-mercado-rea) * 100
                   tt-embarque-corpo.per-ger-pis-rea              = (tt-embarque-corpo.vl-ger-pis-rea
                                                                  /  tt-embarque-corpo.vl-ger-mercado-rea) * 100
                   tt-embarque-corpo.per-ger-cofins-rea           = (tt-embarque-corpo.vl-ger-cofins-rea
                                                                  /  tt-embarque-corpo.vl-ger-mercado-rea) * 100
                   tt-embarque-corpo.per-ger-tot-imp-rea          = (tt-embarque-corpo.vl-ger-tot-imp-rea
                                                                  /  tt-embarque-corpo.vl-ger-mercado-rea) * 100
                   tt-embarque-corpo.per-ger-ii2-rea              = (tt-embarque-corpo.vl-ger-ii2-rea
                                                                  /  tt-embarque-corpo.vl-ger-mercado-rea) * 100
                   tt-embarque-corpo.per-ger-des-rea              = (tt-embarque-corpo.vl-ger-des-rea
                                                                  /  tt-embarque-corpo.vl-ger-mercado-rea) * 100
                   tt-embarque-corpo.per-ger-tot-des-rea          = (tt-embarque-corpo.vl-ger-tot-des-rea
                                                                  /  tt-embarque-corpo.vl-ger-mercado-rea) * 100
                   tt-embarque-corpo.per-ger-tot-imp-des-rea      = (tt-embarque-corpo.vl-ger-tot-imp-des-rea
                                                                  /  tt-embarque-corpo.vl-ger-mercado-rea) * 100
                   tt-embarque-corpo.per-ger-tot-com-ipi-icms-rea = (tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea
                                                                  /  tt-embarque-corpo.vl-ger-mercado-rea) * 100
                   tt-embarque-corpo.per-ger-tot-sem-ipi-icms-rea = (tt-embarque-corpo.vl-ger-tot-sem-ipi-icms-merc-rea
                                                                  /  tt-embarque-corpo.vl-ger-mercado-rea) * 100.


        END.

        IF tt-embarque-corpo.per-ger-mercado-orc = ? THEN
            ASSIGN tt-embarque-corpo.per-ger-mercado-orc = 0.

        IF tt-embarque-corpo.per-ger-ii-orc = ? THEN
            ASSIGN tt-embarque-corpo.per-ger-ii-orc = 0.

        IF tt-embarque-corpo.per-ger-ipi-orc = ? THEN
            ASSIGN tt-embarque-corpo.per-ger-ipi-orc = 0.

        IF tt-embarque-corpo.per-ger-icms-orc = ? THEN
            ASSIGN tt-embarque-corpo.per-ger-icms-orc = 0.

        IF tt-embarque-corpo.per-ger-pis-orc = ? THEN
            ASSIGN tt-embarque-corpo.per-ger-pis-orc = 0.

        IF tt-embarque-corpo.per-ger-cofins-orc = ? THEN
            ASSIGN tt-embarque-corpo.per-ger-cofins-orc = 0.

        IF tt-embarque-corpo.per-ger-tot-imp-orc = ? THEN
            ASSIGN tt-embarque-corpo.per-ger-tot-imp-orc = 0.

        IF tt-embarque-corpo.per-ger-ii2-orc = ? THEN
            ASSIGN tt-embarque-corpo.per-ger-ii2-orc = 0.

        IF tt-embarque-corpo.per-ger-des-orc = ? THEN
            ASSIGN tt-embarque-corpo.per-ger-des-orc = 0.

        IF tt-embarque-corpo.per-ger-tot-des-orc = ? THEN
            ASSIGN tt-embarque-corpo.per-ger-tot-des-orc = 0.

        IF tt-embarque-corpo.per-ger-tot-imp-des-orc = ? THEN
            ASSIGN tt-embarque-corpo.per-ger-tot-imp-des-orc = 0.

        IF tt-embarque-corpo.per-ger-tot-com-ipi-icms-orc = ? THEN
            ASSIGN tt-embarque-corpo.per-ger-tot-com-ipi-icms-orc = 0.

        IF tt-embarque-corpo.per-ger-tot-sem-ipi-icms-orc = ? THEN
            ASSIGN tt-embarque-corpo.per-ger-tot-sem-ipi-icms-orc = 0.

    END.

END. /*embarque-imp*/

/* Inicio -- Projeto Internacional */
IF tt-param.excel THEN
    {utp/ut-liter.i "Processando_Dados_Planilha" *}
ELSE
    {utp/ut-liter.i "Imprimindo_Dados" *}

run pi-acompanhar in h-acomp (input RETURN-VALUE + "...").

case tt-param.classifica:
    when 1 then do:
        run imp/im0665a.p (input table tt-param,
                           input table tt-detalha-item,
                           input table tt-embarque-cabec,
                           input table tt-embarque-corpo,
                           input table tt-embarque-fatura,
                           input table tt-detalha-despesa,
                           input table tt-detalha-despesa-aux,
                           input table tt-embarque-rel,
                           input table tt-nf-comp,
                           INPUT TABLE tt-embarque-nota-mae,
                           INPUT TABLE tt-embarque-nf,
                           INPUT TABLE tt-impto-internac,
                           OUTPUT      bh-dados-excel,
                           OUTPUT      bh-dados-excel-detail).

        IF tt-param.excel THEN DO:

            {utp/ut-liter.i "1-Custo_Real" *}
            RUN pi-prepara-tt-excel  (INPUT bh-dados-excel, /*Buffer Tabela*/
                                      INPUT "",  /*colunas para ordenaªío do relatΩrio*/
                                      INPUT RETURN-VALUE). /*Nome da aba na planilha*/

            IF tt-param.l-itens THEN DO:
                {utp/ut-liter.i "2-Custo_Real_Detalhado" *}
                RUN pi-prepara-tt-excel  (INPUT bh-dados-excel-detail, /*Buffer Tabela*/
                                          INPUT "",  /*colunas para ordenaªío do relatΩrio*/
                                          INPUT RETURN-VALUE). /*Nome da aba na planilha*/
                {utp/ut-liter.i "3-Notas_Fiscais" *}
            END.
            ELSE
                {utp/ut-liter.i "2-Notas_Fiscais" *}

            RUN pi-prepara-tt-excel (INPUT BUFFER tt-documentos:HANDLE,
                                     INPUT "embarque",
                                     INPUT RETURN-VALUE).
        END.

    END.
    when 2 then do:
        run imp/im0665b.p (input table tt-param,
                           input table tt-detalha-item,
                           input table tt-embarque-cabec,
                           input table tt-embarque-corpo,
                           OUTPUT      bh-dados-excel,
                           OUTPUT      bh-dados-excel-detail,
                           OUTPUT      bh-dados-excel-total).

        IF tt-param.excel THEN DO:

            {utp/ut-liter.i "1-Por_Embarque_Resumido" *}
            RUN pi-prepara-tt-excel (INPUT bh-dados-excel,
                                     INPUT "",
                                     INPUT RETURN-VALUE).


            IF tt-param.l-itens THEN DO:
                {utp/ut-liter.i "2-Itens" *}
                RUN pi-prepara-tt-excel (INPUT bh-dados-excel-detail,
                                         INPUT "",
                                         INPUT RETURN-VALUE).

                {utp/ut-liter.i "3-Total_por_Estabelecimento" *}
            END.
            ELSE
                {utp/ut-liter.i "2-Total_por_Estabelecimento" *}

            RUN pi-prepara-tt-excel (INPUT bh-dados-excel-total,
                                     INPUT "",
                                     INPUT RETURN-VALUE).

            IF tt-param.l-itens THEN
                {utp/ut-liter.i "4-Notas_Fiscais" *}
            ELSE
                {utp/ut-liter.i "3-Notas_Fiscais" *}

            RUN pi-prepara-tt-excel (INPUT BUFFER tt-documentos:HANDLE,
                                     INPUT "embarque",
                                     INPUT RETURN-VALUE).

        END.

    end.
    when 3 then do:
        run imp/im0665c.p (input table tt-param,
                           input table tt-detalha-item,
                           input table tt-embarque-cabec,
                           input table tt-embarque-corpo,
                           OUTPUT bh-dados-excel,
                           OUTPUT bh-dados-excel-detail,
                           OUTPUT bh-dados-excel-total).

        IF tt-param.excel THEN DO:
            {utp/ut-liter.i "1-Por_Fornecedor(Exportador)" *}
            RUN pi-prepara-tt-excel (INPUT bh-dados-excel,
                                     INPUT "",
                                     INPUT RETURN-VALUE).
            IF tt-param.l-itens THEN DO:
                {utp/ut-liter.i "2-Itens" *}
                RUN pi-prepara-tt-excel (INPUT bh-dados-excel-detail,
                                         INPUT "",
                                         INPUT RETURN-VALUE).

                {utp/ut-liter.i "3-Total_por_Exportador" *}
            END.
            ELSE
                {utp/ut-liter.i "2-Total_por_Exportador" *}

            RUN pi-prepara-tt-excel (INPUT bh-dados-excel-total,
                                     INPUT "",
                                     INPUT RETURN-VALUE).

            IF tt-param.l-itens THEN
                {utp/ut-liter.i "4-Notas_Fiscais" *}
            ELSE
                {utp/ut-liter.i "3-Notas_Fiscais" *}

            RUN pi-prepara-tt-excel (INPUT BUFFER tt-documentos:HANDLE,
                                     INPUT "embarque",
                                     INPUT RETURN-VALUE).
        END.

    end.
    when 4 then do:
        run imp/im0665d.p (input table tt-param,
                           input table tt-detalha-item,
                           input table tt-embarque-cabec,
                           input table tt-embarque-corpo,
                           OUTPUT      bh-dados-excel-detail,
                           OUTPUT      bh-dados-excel).

        IF tt-param.excel THEN DO:

            {utp/ut-liter.i "1-Por_Item" *}
            RUN pi-prepara-tt-excel (INPUT bh-dados-excel-detail, /*Buffer Tabela*/
                                     INPUT "",  /*colunas para ordenaªío do relatΩrio*/
                                     INPUT RETURN-VALUE). /*Nome da aba na planilha*/

            {utp/ut-liter.i "2-Total_por_Item" *}
            RUN pi-prepara-tt-excel  (INPUT bh-dados-excel, /*Buffer Tabela*/
                                      INPUT "",  /*colunas para ordenaªío do relatΩrio*/
                                      INPUT RETURN-VALUE). /*Nome da aba na planilha*/

            {utp/ut-liter.i "3-Notas_Fiscais" *}
            RUN pi-prepara-tt-excel  (INPUT BUFFER tt-documentos:HANDLE, /*Buffer Tabela*/
                                      INPUT "embarque",  /*colunas para ordenaªío do relatΩrio*/
                                      INPUT RETURN-VALUE). /*Nome da aba na planilha*/
        END.
    END.
end case.

IF tt-param.excel THEN DO:

    ASSIGN tt-param.dir-arq-excel = tt-param.dir-arq-excel + "IM0665" + "-":U + STRING(YEAR(TODAY),"9999") +
                                                                                STRING(MONTH(TODAY),"99") +
                                                                                STRING(DAY(TODAY),"99") +
                                                                                TRIM(REPLACE(STRING(TIME,"HH:MM:SS"),":","")) + ".xlsx".

    RUN GeraRelatExcel (INPUT tt-param.dir-arq-excel,
                        OUTPUT l-possui-inf).

    IF l-possui-inf THEN DO:
        IF tt-param.dir-arq-excel BEGINS "IM0665" THEN
            ASSIGN tt-param.dir-arq-excel = tt-param.dir-arq-excel + " gerado no diret¢rio configurado no RPW".
        DISPLAY tt-param.dir-arq-excel
            WITH FRAME f-ger-excel.
        PAGE.
    END.

END.

case tt-param.destino:
   when 1 then
       c-destino = "Impressora".
   when 2 then
       c-destino = "Arquivo".
   when 3 then
       c-destino = "Terminal".
end.
IF tt-param.i-compar-merc = 1 THEN DO:
    {utp/ut-liter.i Total_da_nota *}
    ASSIGN c-consider-calc = RETURN-VALUE.
END.
ELSE DO:
    {utp/ut-liter.i Valor_da_Mercadoria *}
    ASSIGN c-consider-calc = RETURN-VALUE.
END.
/* Display do parÉmetros */

IF i-pais-impto-usuario = 1 /* Brasil */ THEN DO:
    /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-820) */
    IF  l-nt2024002 THEN DO:
        DISP tt-param.c-cod-estabel-ini
             tt-param.c-cod-estabel-fim
             tt-param.c-embarque-ini
             tt-param.c-embarque-fim
             tt-param.c-it-codigo-ini
             tt-param.c-it-codigo-fim
             tt-param.i-ge-codigo-ini
             tt-param.i-ge-codigo-fim
             tt-param.c-fm-codigo-ini
             tt-param.c-fm-codigo-fim
             tt-param.i-cod-emitente-ini
             tt-param.i-cod-emitente-fim
             tt-param.c-nr-proc-imp-ini
             tt-param.c-nr-proc-imp-fim
             tt-param.i-cod-itiner-ini
             tt-param.i-cod-itiner-fim
             tt-param.da-dt-nac-ini
             tt-param.da-dt-nac-fim
             tt-param.desc-classifica
             tt-param.moeda
             c-desc-moeda
             tt-param.da-dt-conv
             tt-param.l-dt-nacional
             tt-param.l-orc-real
             c-consider-calc
             tt-param.l-desp-imposto
             tt-param.l-itens
             tt-param.c-custo-item
             tt-param.c-desp-imposto
             tt-param.l-desemb-parc
             tt-param.l-nf-compl
             tt-param.l-novos-tributos
             c-destino
             tt-param.arquivo
             tt-param.excel
             tt-param.usuario
           WITH FRAME f-param-novos-trib.
    END.
    /* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-820) */
    ELSE DO:
        DISP tt-param.c-cod-estabel-ini
             tt-param.c-cod-estabel-fim
             tt-param.c-embarque-ini
             tt-param.c-embarque-fim
             tt-param.c-it-codigo-ini
             tt-param.c-it-codigo-fim
             tt-param.i-ge-codigo-ini
             tt-param.i-ge-codigo-fim
             tt-param.c-fm-codigo-ini
             tt-param.c-fm-codigo-fim
             tt-param.i-cod-emitente-ini
             tt-param.i-cod-emitente-fim
             tt-param.c-nr-proc-imp-ini
             tt-param.c-nr-proc-imp-fim
             tt-param.i-cod-itiner-ini
             tt-param.i-cod-itiner-fim
             tt-param.da-dt-nac-ini
             tt-param.da-dt-nac-fim
             tt-param.desc-classifica
             tt-param.moeda
             c-desc-moeda
             tt-param.da-dt-conv
             tt-param.l-dt-nacional
             tt-param.l-orc-real
             c-consider-calc
             tt-param.l-desp-imposto
             tt-param.l-itens
             tt-param.c-custo-item
             tt-param.c-desp-imposto
             tt-param.l-desemb-parc
             tt-param.l-nf-compl
             c-destino
             tt-param.arquivo
             tt-param.excel
             tt-param.usuario
           WITH FRAME f-parametros.
    END.
END.
ELSE
    disp
        tt-param.c-cod-estabel-ini
        tt-param.c-cod-estabel-fim
        tt-param.c-embarque-ini
        tt-param.c-embarque-fim
        tt-param.c-it-codigo-ini
        tt-param.c-it-codigo-fim
        tt-param.i-ge-codigo-ini
        tt-param.i-ge-codigo-fim
        tt-param.c-fm-codigo-ini
        tt-param.c-fm-codigo-fim
        tt-param.i-cod-emitente-ini
        tt-param.i-cod-emitente-fim
        tt-param.c-nr-proc-imp-ini
        tt-param.c-nr-proc-imp-fim
        tt-param.i-cod-itiner-ini
        tt-param.i-cod-itiner-fim
        tt-param.da-dt-nac-ini
        tt-param.da-dt-nac-fim
        tt-param.desc-classifica
        tt-param.moeda
        c-desc-moeda
        tt-param.da-dt-conv
        tt-param.l-dt-nacional
        tt-param.l-considera-cot-docto
        tt-param.l-orc-real
        c-consider-calc
        tt-param.l-desp-imposto
        tt-param.l-itens
        tt-param.c-custo-item
        tt-param.c-desp-imposto
        tt-param.l-desemb-parc
        tt-param.l-nf-compl
		tt-param.l-desc-desp-item
        c-destino
        tt-param.arquivo
        tt-param.excel
        tt-param.usuario
        with frame f-parametros-int.

IF VALID-HANDLE(h-boin759na) THEN DO:
    RUN destroy IN h-boin759na.
    ASSIGN h-boin759na = ?.
END.

IF VALID-HANDLE(h-cdapi995) THEN DO:
    DELETE PROCEDURE h-cdapi995.
    ASSIGN h-cdapi995 = ?.
END.

run pi-finalizar in h-acomp.

{include/i-rpclo.i}

PROCEDURE pi-prepara-tt-excel:
    DEF INPUT PARAM bufferTable       AS HANDLE           NO-UNDO.
    DEF INPUT PARAM c-campos-order    AS CHAR             NO-UNDO.
    DEF INPUT PARAM p-nome-aba        AS CHAR             NO-UNDO.

    DEF VAR hQuery                 AS HANDLE  NO-UNDO.
    DEF VAR hQuery-son             AS HANDLE  NO-UNDO.
    DEF VAR i-num-field            AS INT     NO-UNDO.
    DEF VAR i-num-field-aux        AS INT     NO-UNDO.
    DEF VAR i-num-field-value      AS INT     NO-UNDO.
    DEF VAR i-num-field-value-aux  AS INT     NO-UNDO.
    DEF VAR l-passed-first         AS LOG     NO-UNDO.
    DEF VAR l-last-reg-extent      AS LOG     NO-UNDO.
    DEF VAR i-extent               AS INT     NO-UNDO.
    DEF VAR c-vlr-campo            AS CHAR    NO-UNDO.
    DEF VAR c-text-livre           AS CHAR    NO-UNDO.
    DEF VAR c-tipo-formato         AS CHAR    NO-UNDO.


    IF trim(c-campos-order) <> "" THEN
        ASSIGN c-campos-order = "BREAK BY " + trim(c-campos-order)
               c-campos-order = REPLACE(c-campos-order, "|", " BY ").

    CREATE QUERY hQuery.
    hQuery:SET-BUFFERS(bufferTable).
    hQuery:QUERY-PREPARE("FOR EACH " + bufferTable:NAME +  " NO-LOCK " + IF trim(c-campos-order) <> " " THEN c-campos-order ELSE "").
    hQuery:QUERY-OPEN.
    hQuery:GET-FIRST.

    DO WHILE NOT hQuery:QUERY-OFF-END:
        DO i-num-field = 1 TO bufferTable:NUM-FIELDS:
            /*Insere as colunas do relat¢rio*/
            IF NOT bufferTable:buffer-field(i-num-field):NAME MATCHES "*livre*" THEN DO:  /* Desconsidera campos livres */

                IF NOT CAN-FIND(FIRST tt-dados-browse WHERE
                                      tt-dados-browse.nome-aba = p-nome-aba AND
                                      tt-dados-browse.nr-coluna = i-num-field) THEN DO:

                    CREATE tt-dados-browse.
                    ASSIGN tt-dados-browse.nome-aba       = p-nome-aba
                           tt-dados-browse.nr-coluna      = IF i-num-field-aux > i-num-field THEN i-num-field-aux ELSE i-num-field
                           tt-dados-browse.label-campo    = bufferTable:buffer-field(i-num-field):LABEL
                           tt-dados-browse.tipo-campo     = bufferTable:buffer-field(i-num-field):DATA-TYPE
                           tt-dados-browse.largura-coluna = LENGTH(bufferTable:buffer-field(i-num-field):buffer-value[i-extent]).



                    IF bufferTable:buffer-field(i-num-field):DATA-TYPE = "decimal" THEN DO:
                        if i-pais-impto-usuario = 1 then
						    ASSIGN c-vlr-campo = trim(string(DEC(bufferTable:buffer-field(i-num-field):buffer-value[i-extent]), bufferTable:buffer-field(i-num-field):FORMAT)).
						else
						    ASSIGN c-vlr-campo = trim(string(DEC(bufferTable:buffer-field(i-num-field):buffer-value[i-extent]))).

                        ASSIGN c-tipo-formato = REPLACE(REPLACE(REPLACE(REPLACE(bufferTable:buffer-field(i-num-field):FORMAT,"-",""),">",""),",",""),"9.","")
                               tt-dados-browse.tipo-campo = "decimal" + trim(string(length(c-tipo-formato))).
					END.

                    IF tt-dados-browse.largura-coluna < LENGTH(TRIM(bufferTable:buffer-field(i-num-field):LABEL)) THEN
                        ASSIGN tt-dados-browse.largura-coluna = LENGTH(TRIM(bufferTable:buffer-field(i-num-field):LABEL)).

                    IF tt-dados-browse.largura-coluna < LENGTH(TRIM(c-vlr-campo)) THEN
                            ASSIGN tt-dados-browse.largura-coluna = LENGTH(TRIM(c-vlr-campo)).

                END.
                ELSE DO:
                    FOR FIRST tt-dados-browse
                        WHERE tt-dados-browse.nome-aba = p-nome-aba
                          AND tt-dados-browse.nr-coluna = i-num-field:

                        IF bufferTable:buffer-field(i-num-field):DATA-TYPE = "decimal" THEN do:
							if i-pais-impto-usuario = 1 then
								c-vlr-campo = trim(string(DEC(bufferTable:buffer-field(i-num-field):buffer-value[i-extent]), bufferTable:buffer-field(i-num-field):FORMAT)).
							else
								c-vlr-campo = trim(string(DEC(bufferTable:buffer-field(i-num-field):buffer-value[i-extent]))).
						END.

                        IF tt-dados-browse.largura-coluna < LENGTH(bufferTable:buffer-field(i-num-field):buffer-value[i-extent]) THEN
                            ASSIGN tt-dados-browse.largura-coluna = LENGTH(bufferTable:buffer-field(i-num-field):buffer-value[i-extent]).

                        IF tt-dados-browse.largura-coluna < LENGTH(TRIM(c-vlr-campo)) THEN
                            ASSIGN tt-dados-browse.largura-coluna = LENGTH(TRIM(c-vlr-campo)).
                    END.
                END.

            END.

            IF bufferTable:buffer-field(i-num-field):DATA-TYPE = "decimal" AND bufferTable:buffer-field(i-num-field):buffer-value[i-extent] = ? THEN
                ASSIGN c-vlr-campo = "0.00".
            ELSE
                ASSIGN c-vlr-campo = bufferTable:buffer-field(i-num-field):buffer-value[i-extent].

            CASE bufferTable:buffer-field(i-num-field):DATA-TYPE:
               WHEN "date" THEN
                  ASSIGN c-vlr-campo = trim(string(date(bufferTable:buffer-field(i-num-field):buffer-value[i-extent]), "99/99/9999")).
               WHEN "logical" THEN
                  ASSIGN c-vlr-campo = trim(string(bufferTable:buffer-field(i-num-field):buffer-value[i-extent],"SIM/N«O")).
            END CASE.

            IF c-vlr-campo = ? THEN
               ASSIGN c-vlr-campo = "".

            ASSIGN c-text-livre = c-text-livre + c-vlr-campo + (IF i-num-field <> bufferTable:NUM-FIELDS THEN "|" ELSE "").

            IF i-num-field = bufferTable:NUM-FIELDS THEN DO:
               ASSIGN i-num-field-aux = i-num-field-aux + 1.
               CREATE tt-relat-confer.
               ASSIGN tt-relat-confer.cod-estabel = '1'
                      tt-relat-confer.nome-aba    = p-nome-aba
                      tt-relat-confer.text-livre  = c-text-livre
                      tt-relat-confer.num-seq     = i-num-field-aux.
               ASSIGN c-text-livre = "".
            END.
        END.
        hQuery:GET-NEXT NO-ERROR.
    END.

    bufferTable:BUFFER-RELEASE().
    hQuery:QUERY-CLOSE().
    DELETE OBJECT hQuery.
    ASSIGN i-num-field-aux = 0.

END PROCEDURE.

PROCEDURE GeraRelatExcel:
    DEFINE INPUT  PARAM c-dir-arq      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM l-possui-inf   AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE c-nome-aba      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-tipo-dado     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-formato       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-num-colunas   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-pos-ponto     AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iColumns        AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-num-aba-reg   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-cont-reg      AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-cont-coluna   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-cont-linha    AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-cont          AS INTEGER   NO-UNDO.
    DEFINE VARIABLE valor-extract   AS CHARACTER NO-UNDO.
    DEFINE BUFFER btt-dados-browse FOR tt-dados-browse.

    IF NOT CAN-FIND(FIRST tt-relat-confer) THEN
       RETURN "NOK":U.

    ASSIGN i-cont-reg = 0
           l-possui-inf = NO.

    IF NOT VALID-HANDLE(h-utapi033) THEN
       RUN utp/utapi033.p PERSISTENT SET h-utapi033.

    FOR EACH btt-dados-browse
       BREAK BY btt-dados-browse.nome-aba:

       IF FIRST-OF (btt-dados-browse.nome-aba) THEN DO:
           ASSIGN c-nome-aba = TRIM(CAPS(btt-dados-browse.nome-aba)).
           RUN piNewWorksheet IN h-utapi033 (INPUT c-nome-aba, INPUT c-titulo-relat).

           ASSIGN i-cont-coluna = 0
                  i-cont-reg    = i-cont-reg + 1.
       END.

       ASSIGN i-cont-coluna = i-cont-coluna + 1.

       IF (btt-dados-browse.largura-coluna + 1) = ? THEN
           ASSIGN btt-dados-browse.largura-coluna = 10.

       IF btt-dados-browse.tipo-campo BEGINS "DECIMAL" THEN
           ASSIGN c-tipo-dado = "DECIMAL":U.
       ELSE
           ASSIGN c-tipo-dado = btt-dados-browse.tipo-campo.

       CASE btt-dados-browse.tipo-campo:
           WHEN "DECIMAL6":U  THEN ASSIGN c-formato = ">>>>>>>>>>>>>9.999999":U.
           WHEN "DECIMAL5":U  THEN ASSIGN c-formato = ">>>>>>>>>>>>>9.99999":U.
           WHEN "DECIMAL4":U  THEN ASSIGN c-formato = ">>>>>>>>>>>>>9.9999":U.
           WHEN "DECIMAL3":U  THEN ASSIGN c-formato = ">>>>>>>>>>>>>9.999":U.
           WHEN "CHARACTER":U THEN ASSIGN c-formato = "":U.
           WHEN "INTEGER":U   THEN ASSIGN c-formato = ">>>>>>>>>9":U.
           WHEN "DATE":U      THEN ASSIGN c-formato = "99/99/9999":U.
           OTHERWISE ASSIGN c-formato = ">>>>>>>>>>>>>9.99":U.
       END CASE.

       RUN piWorksheetColumn IN h-utapi033(INPUT i-cont-reg,
                                           INPUT i-cont-coluna,
                                           INPUT c-tipo-dado,
                                           INPUT btt-dados-browse.label-campo,
                                           INPUT c-formato,
                                           INPUT (btt-dados-browse.largura-coluna + 1)).

       IF LAST-OF(btt-dados-browse.nome-aba) THEN DO:

          ASSIGN i-cont-linha = 1.

          FOR EACH tt-relat-confer
             WHERE tt-relat-confer.nome-aba = c-nome-aba
              BREAK BY tt-relat-confer.num-seq:

             ASSIGN l-possui-inf  = YES
                    i-cont-linha  = i-cont-linha + 1
                    i-num-colunas = NUM-ENTRIES(tt-relat-confer.text-livre,"|")
                    i-cont-coluna = 0.

             RUN piNewLine IN h-utapi033.

             DO i-cont = 1 TO i-num-colunas:
                ASSIGN i-cont-coluna = i-cont-coluna + 1.

                FIND FIRST tt-dados-browse
                     WHERE tt-dados-browse.nr-coluna = i-cont
                       AND tt-dados-browse.nome-aba  = c-nome-aba NO-ERROR.
                IF AVAIL tt-dados-browse THEN
                   IF i-cont-linha >= 2 THEN
                      RUN piLine IN h-utapi033 (INPUT i-cont-coluna,  INPUT ENTRY(i-cont,tt-relat-confer.text-livre,"|")).
             END.
          END.
       END.
    END.

    RUN pi-gera-planilha (INPUT c-dir-arq).

    EMPTY TEMP-TABLE tt-relat-confer.
    EMPTY TEMP-TABLE tt-dados-browse.
    EMPTY TEMP-TABLE btt-dados-browse.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-gera-planilha:
   DEFINE INPUT PARAM c-dir-arq AS CHARACTER NO-UNDO.

   run piProcessa in h-utapi033 (input-output c-dir-arq,
                                 input 'IM0665',
                                 input c-titulo-relat).

   if valid-handle(h-utapi033) then delete procedure h-utapi033.

   RETURN "OK":U.

END PROCEDURE.


PROCEDURE converte-moeda:
    def input-output param p-vl-conversao as decimal no-undo.
    def input parameter p-moeda like moeda.mo-codigo no-undo.

    run cdp/cd0812.p (input  p-moeda,         /*moeda origem*/
                      input  tt-param.moeda,  /*moeda destino*/
                      input  p-vl-conversao,  /*valor origem*/
                      input  d-data-conv,     /*data conversao*/
                      output p-vl-conversao). /*valor destino*/


END PROCEDURE.

PROCEDURE converte-moeda-data:
    def input-output param p-vl-conversao as decimal           no-undo.
    def input        param p-moeda        like moeda.mo-codigo no-undo.
    def input        param p-data-conv    as date              no-undo.

    run cdp/cd0812.p (input  p-moeda,         /*moeda origem*/
                      input  tt-param.moeda,  /*moeda destino*/
                      input  p-vl-conversao,  /*valor origem*/
                      input  p-data-conv,     /*data conversao*/
                      output p-vl-conversao). /*valor destino*/


END PROCEDURE.

PROCEDURE geraEmbarquesRelacionados:

    DEF INPUT PARAM c-embarque-pai LIKE embarque-imp.embarque NO-UNDO.

    &if "{&bf_mat_versao_ems}" >= "2.05" &then
        for each  b-embarque-imp fields( embarque-ori  cod-estabel  embarque
                                         declaracao-import  data-di)
            where b-embarque-imp.embarque-ori = c-embarque-pai no-lock:
    &else
        for each  b-embarque-imp fields( char-1  cod-estabel  embarque
                                         declaracao-import  data-di)
            where trim(substring(b-embarque-imp.char-1,21,20)) = c-embarque-pai no-lock:
    &endif
        FOR FIRST ordens-embarque NO-LOCK
            WHERE ordens-embarque.cod-estabel  = b-embarque-imp.cod-estabel
              AND ordens-embarque.embarque     = b-embarque-imp.embarque
            USE-INDEX embarque:
        END.

        FOR FIRST ordem-compra NO-LOCK
            WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem
            USE-INDEX ordem:
        END.

        create tt-embarque-rel.
        assign tt-embarque-rel.embarque      = embarque-imp.embarque
               tt-embarque-rel.cod-estabel   = b-embarque-imp.cod-estabel
               tt-embarque-rel.embarque-rel  = b-embarque-imp.embarque.
        for first b-docum-est fields( char-1  serie-docto  nro-docto cod-estabel
                                      cod-emitente  nat-operacao  dt-emissao )
            where b-docum-est.cod-emitente              = ordem-compra.cod-emitente
              AND trim(substr(b-docum-est.char-1,1,16)) = b-embarque-imp.embarque no-lock
            USE-INDEX emitente:
        end.
        if  avail b-docum-est then do:

            assign tt-embarque-rel.nr-nota-rel = b-docum-est.nro-docto
                   tt-embarque-rel.dt-emis-rel = b-docum-est.dt-emissao
                   tt-embarque-rel.nr-di-rel   = b-embarque-imp.declaracao-import
                   tt-embarque-rel.dt-di-rel   = b-embarque-imp.data-di.

            RUN gera-valores (INPUT b-docum-est.serie-docto,
                              INPUT b-docum-est.nro-docto,
                              INPUT b-docum-est.cod-emitente,
                              INPUT b-docum-est.nat-operacao,
                              INPUT b-embarque-imp.embarque, /*embarque relacionado*/
                              INPUT b-docum-est.cod-estabel,
                              INPUT 2). /*Nota Relacionada*/
        end.
        RUN geraEmbarquesRelacionados(INPUT b-embarque-imp.embarque).
    end.
END PROCEDURE.

PROCEDURE gera-valores:
    define input parameter p-serie        like docum-est.serie          no-undo.
    define input parameter p-nro-docto    like docum-est.nro-docto      no-undo.
    define input parameter p-cod-emitente like docum-est.cod-emitente   no-undo.
    define input parameter p-nat-operacao like docum-est.nat-operacao   no-undo.
    DEFINE INPUT PARAMETER pc-embarque    LIKE embarque-imp.embarque    NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel LIKE embarque-imp.cod-estabel NO-UNDO.
    define input parameter p-situacao     as int                        no-undo.

    DEF VAR de-tot-des-orc-aux AS DECIMAL NO-UNDO.
    DEF VAR de-tot-desp        AS DECIMAL NO-UNDO.
    DEF VAR de-tot-desp-aux    AS DECIMAL NO-UNDO.
    DEF VAR de-val-desp-aux    AS DECIMAL NO-UNDO.
    DEF VAR de-val-desp-nfc    AS DECIMAL NO-UNDO.
    def var de-val-desp        as decimal no-undo.
    DEF VAR de-tot-imp-rea     AS DECIMAL NO-UNDO.
    DEF VAR de-despesa-total   AS DECIMAL NO-UNDO.
    DEF VAR de-residuo         AS DECIMAL NO-UNDO.
    DEF VAR var-valor-imp-int  AS DEC NO-UNDO format ">>,>>>,>>>,>>9.9999"  decimals 4.

    DEF VAR lok AS LOGICAL NO-UNDO.

    /* p-situacao..: 1- Nota Principal    **
    **               2- Nota Relacionada  **
    **               3- Nota Complementar */

    IF i-pais-impto-usuario <> 1 THEN DO:
        FOR FIRST b-docum-est-aux NO-LOCK
            WHERE b-docum-est-aux.serie-docto  = p-serie
              and b-docum-est-aux.nro-docto    = p-nro-docto
              and b-docum-est-aux.cod-emitente = p-cod-emitente
              and b-docum-est-aux.nat-operacao = p-nat-operacao:
            IF p-situacao = 1 AND b-docum-est-aux.idi-nf-simples-remes = 2 /* Nota Filha */ THEN
                RUN pi-busca-nota-mae (OUTPUT r-rowid-mae).
            ELSE
                ASSIGN r-rowid-mae = ?.
        END.
    END.

    for each  item-doc-est fields( serie-docto   nro-docto      cod-emitente   nat-operacao  sequencia
                                   it-codigo     preco-unit[1]  numero-ordem   quantidade    qt-do-forn
                                   aliquota-ipi  aliquota-icm   valor-ipi[1]   valor-icm[1]  un parcela
                                   item-doc-est.preco-total[1] preco-unit-me
                                   cd-trib-icm cd-trib-ipi seq-comp idi-tributac-pis idi-tributac-cofins
                                   &if "{&bf_mat_versao_ems}" >= "2.06" &then
                                       num-ord-import num-parc-import valor-pis val-cofins val-aliq-pis  val-aliq-cofins
                                   &else
                                       char-2
                                   &endif
                                   )
        where item-doc-est.serie-docto  =  p-serie
          and item-doc-est.nro-docto    =  p-nro-docto
          and item-doc-est.cod-emitente =  p-cod-emitente
          and item-doc-est.nat-operacao =  p-nat-operacao NO-LOCK
        use-index documento
        break by item-doc-est.it-codigo
              by &if "{&bf_mat_versao_ems}" >= "2.06" &then
                     item-doc-est.num-ord-import
                 &ELSE
                     int(substr(item-doc-est.char-2,145,8))
                 &endif
              by item-doc-est.numero-ordem:

        FIND FIRST item-doc-est-cex OF item-doc-est NO-LOCK NO-ERROR.
        IF  AVAIL item-doc-est-cex THEN DO:
                IF  p-situacao = 3 AND
                &if "{&bf_mat_versao_ems}" >= "2.06" &THEN
                    item-doc-est-cex.embarque <> pc-embarque
                &ELSE
                    (trim(substr(item-doc-est-cex.char-1,1,12)) <> pc-embarque)
                &ENDIF
                THEN
                NEXT.
        END.

        if item-doc-est.it-codigo < tt-param.c-it-codigo-ini or
           item-doc-est.it-codigo > tt-param.c-it-codigo-fim then next.

        for first item fields(it-codigo  ge-codigo  fm-codigo desc-item un)
            where item.it-codigo =  item-doc-est.it-codigo
              and item.ge-codigo >= tt-param.i-ge-codigo-ini
              and item.ge-codigo <= tt-param.i-ge-codigo-fim
              and item.fm-codigo >= tt-param.c-fm-codigo-ini
              and item.fm-codigo <= tt-param.c-fm-codigo-fim no-lock:
        end.

        if  not avail item then next.

        /*Notas Complementares*/
        if  p-situacao = 3 then do:

            for first  tt-detalha-item
                 where tt-detalha-item.embarque    = embarque-imp.embarque
                 and   tt-detalha-item.cod-estabel = embarque-imp.cod-estabel
                 and   tt-detalha-item.it-codigo   = item-doc-est.it-codigo
                 AND   tt-detalha-item.sequencia   = item-doc-est.seq-comp no-lock
                use-index ch-codigo:
            end.
            if  not avail tt-detalha-item then next.

            for first ordens-embarque fields(numero-ordem)
                where ordens-embarque.embarque    = embarque-imp.embarque
                  and ordens-embarque.cod-estabel = embarque-imp.cod-estabel no-lock: end.
            if  not avail ordens-embarque then next.

            for first ordem-compra
                where ordem-compra.numero-ordem = ordens-embarque.numero-ordem no-lock: end.
            if  not avail ordem-compra then next.

            &if "{&bf_mat_versao_ems}" >= "2.05" &then
                for first cotacao-item fields( numero-ordem  cod-emitente  mo-codigo  aliquota-ii
                                               data-cotacao  cot-aprovada  it-codigo  seq-cotac char-1)
                    where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                      and cotacao-item.cod-emitente = ordem-compra.cod-emitente
                      and cotacao-item.data-cotacao = ordem-compra.data-cotacao
                      and cotacao-item.cot-aprovada = yes no-lock:
                end.
            &else
                for first cotacao-item fields( numero-ordem  cod-emitente  mo-codigo  char-1
                                               data-cotacao  cot-aprovada  it-codigo  seq-cotac )
                    where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                      and cotacao-item.cod-emitente = ordem-compra.cod-emitente
                      and cotacao-item.data-cotacao = ordem-compra.data-cotacao
                      and cotacao-item.cot-aprovada = yes no-lock:
                end.
            &endif
            if  not avail cotacao-item then
                next.

            assign tot-despesa-rea = 0
                   de-val-desp     = 0
                   de-tot-desp-aux  = 0
                   de-despesa-total = 0.

            for each  item-doc-est-cex fields(val-desp nro-docto sequencia)
                    where item-doc-est-cex.serie-docto  = item-doc-est.serie-docto
                    and   item-doc-est-cex.nro-docto    = item-doc-est.nro-docto
                    and   item-doc-est-cex.cod-emitente = item-doc-est.cod-emitente
                    and   item-doc-est-cex.nat-operacao = item-doc-est.nat-operacao
                    and   item-doc-est-cex.sequencia    = item-doc-est.sequencia
                    &if "{&bf_mat_versao_ems}" <= "2.05" &then
                        and  trim(substr(item-doc-est-cex.char-1,1,12)) = embarque-imp.embarque
                        and  trim(substr(item-doc-est-cex.char-1,13,3)) = pc-cod-estabel no-lock
                    &else
                        and  item-doc-est-cex.embarque    = embarque-imp.embarque
                        and  item-doc-est-cex.cod-estabel = pc-cod-estabel no-lock
                     &endif
                     use-index codigo:

                     assign de-val-desp = de-val-desp + item-doc-est-cex.val-desp.
            end.

            for each  item-doc-est-cex fields(mo-codigo cod-desp val-desp nro-docto sequencia cotacao dat-cotac)
                where item-doc-est-cex.serie-docto  = item-doc-est.serie-docto
                and   item-doc-est-cex.nro-docto    = item-doc-est.nro-docto
                and   item-doc-est-cex.cod-emitente = item-doc-est.cod-emitente
                and   item-doc-est-cex.nat-operacao = item-doc-est.nat-operacao
                and   item-doc-est-cex.sequencia    = item-doc-est.sequencia
                &if "{&bf_mat_versao_ems}" <= '2.05' &then
                    and  trim(substr(item-doc-est-cex.char-1,1,12)) = embarque-imp.embarque
                    and  trim(substr(item-doc-est-cex.char-1,13,3)) = pc-cod-estabel no-lock
                &else
                    and  item-doc-est-cex.embarque    = embarque-imp.embarque
                    and  item-doc-est-cex.cod-estabel = pc-cod-estabel no-lock
                &endif
                use-index codigo BREAK BY item-doc-est-cex.cod-desp:

                /****ORÄADO-INI**/
                for each  cotacao-item-cex fields( numero-ordem  cod-emitente  mapa-cotacao
                                                   cod-incoterm  it-codigo     seq-cotac
                                                   data-cotacao  cod-itiner    cod-desp
                                                   val-desp      mo-codigo)
                    where cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem
                    and   cotacao-item-cex.cod-emitente = cotacao-item.cod-emitente
                    and   cotacao-item-cex.it-codigo    = item-doc-est.it-codigo
                    and   cotacao-item-cex.mapa-cotacao = int(trim(substring(cotacao-item.char-1,1,20)))
                    and   cotacao-item-cex.cod-incoterm = embarque-imp.cod-incoterm
                    and   cotacao-item-cex.cod-itiner   = itinerario.cod-itiner no-lock:

                    for first desp-imp fields (cod-desp tipo descricao char-1)
                         where desp-imp.cod-desp = cotacao-item-cex.cod-desp no-lock:
                    end.
                    FOR FIRST desp-embarque FIELDS(descricao) NO-LOCK
                        WHERE desp-embarque.cod-estabel = embarque-imp.cod-estab
                          AND desp-embarque.embarque = embarque-imp.embarque
                          AND desp-embarque.cod-desp = cotacao-item-cex.cod-desp:
                    END.

                    if  not avail desp-imp then next.

                    IF i-pais-impto-usuario            <> 1   AND
                       tt-param.l-desc-desp-item       =  YES AND
                       substring(desp-imp.char-1,45,1) =  "Y" THEN NEXT.

                    if  tt-param.i-custo-item = 2 and desp-imp.tipo <> 1 then /*Total e Diferente de Fixo*/
                        assign vl-desp-orcad-det = cotacao-item-cex.val-desp
                                                 * item-doc-est.quantidade.
                    else
                        assign vl-desp-orcad-det = cotacao-item-cex.val-desp.

                    if  tt-param.i-custo-item = 2 and desp-imp.tipo <> 1 then /*Total e Diferente de Fixo*/
                        ASSIGN vl-desp-orcad-aux = cotacao-item-cex.val-desp
                                                 * item-doc-est.quantidade.
                    ELSE
                        ASSIGN vl-desp-orcad-aux = cotacao-item-cex.val-desp.

                    /*Oráado*/
                    IF  desp-imp.cod-desp <> i-cod-desp-ii
                    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
                    AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-ipi
                    AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-icms
                    AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-pis
                    AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-cofins
                    &ENDIF
                    THEN DO:

                        for first tt-detalha-despesa-aux
                             where tt-detalha-despesa-aux.embarque     = embarque-imp.embarque
                               and tt-detalha-despesa-aux.cod-estabel  = embarque-imp.cod-estabel
                               and tt-detalha-despesa-aux.cod-despesa  = desp-imp.cod-desp
                               AND tt-detalha-despesa-aux.sequencia    = item-doc-est.sequencia no-lock
                            use-index ch-codigo:
                        end.
                        if not avail tt-detalha-despesa-aux then do:
                            CREATE tt-detalha-despesa-aux.
                            ASSIGN tt-detalha-despesa-aux.embarque     = embarque-imp.embarque
                                   tt-detalha-despesa-aux.cod-estabel  = embarque-imp.cod-estabel
                                   tt-detalha-despesa-aux.cod-despesa  = desp-imp.cod-desp
                                   tt-detalha-despesa-aux.desc-despesa = IF AVAIL desp-embarque AND desp-embarque.descricao <> "":U THEN desp-embarque.descricao ELSE desp-imp.descricao
                                   tt-detalha-despesa-aux.vl-des-orc   = vl-desp-orcad-aux
                                   tt-detalha-despesa-aux.sequencia    = item-doc-est.sequencia
                                   tt-detalha-despesa-aux.situacao     = p-situacao.

                            if tt-param.moeda <> var-moeda-conv-orc THEN DO:
                               IF AVAIL tt-detalha-despesa-aux THEN
                                  run converte-moeda (input-output tt-detalha-despesa-aux.vl-des-orc,
                                                      input var-moeda-conv-orc).
                            END.
                            ASSIGN de-tot-desp-aux = de-tot-desp-aux + tt-detalha-despesa-aux.vl-des-orc.
                        END.
                        ELSE DO:
                            ASSIGN de-tot-desp-aux = de-tot-desp-aux + tt-detalha-despesa-aux.vl-des-orc.
                        END.
                    END.

                    /*----- Notas Complementares -----*/
                    IF  desp-imp.cod-desp <> i-cod-desp-ii
                    &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
                    AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-ipi
                    AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-icms
                    AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-pis
                    AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-cofins
                    &ENDIF
                    THEN DO:
                        find FIRST tt-detalha-despesa
                             WHERE tt-detalha-despesa.embarque    = embarque-imp.embarque
                               AND tt-detalha-despesa.cod-estabel = embarque-imp.cod-estabel
                               AND tt-detalha-despesa.cod-despesa = desp-imp.cod-desp no-lock no-error.

                        if not avail tt-detalha-despesa then do:
                            create tt-detalha-despesa.
                            assign tt-detalha-despesa.embarque      = embarque-imp.embarque
                                   tt-detalha-despesa.cod-estabel   = embarque-imp.cod-estabel
                                   tt-detalha-despesa.numero-ordem  = cotacao-item-cex.numero-ordem
                                   tt-detalha-despesa.nro-docto     = item-doc-est.nro-docto
                                   tt-detalha-despesa.cod-despesa   = desp-imp.cod-desp
                                   tt-detalha-despesa.desc-despesa  = IF AVAIL desp-embarque AND desp-embarque.descricao <> "":U THEN desp-embarque.descricao ELSE desp-imp.descricao
                                   tt-detalha-despesa.situacao      = p-situacao
                                   tt-detalha-despesa.vl-des-orc    = vl-desp-orcad-det
                                   tot-despesa-orc                  = tot-despesa-orc
                                                                    + vl-desp-orcad-det
                                   tt-detalha-despesa.it-codigo     = item-doc-est.it-codigo.

                            assign var-moeda-conv-orc = cotacao-item-cex.mo-codigo.

                            if  tt-param.moeda <> var-moeda-conv-orc THEN
                                run converte-moeda (input-output tt-detalha-despesa.vl-des-orc,
                                                    input var-moeda-conv-orc).
                        END.
                    END.
                end. /*cotacao-item-cex*/

                /*Convers∆o do Valor Adicional*/
                if  tt-param.i-custo-item = 1 then
                    assign var-preco-unit = de-val-desp / tt-detalha-item.quantidade.
                else
                    assign var-preco-unit = de-val-desp.


                assign var-preco-unit-aux = de-val-desp. /*item-doc-est.preco-unit[1].*/


                if  tt-param.moeda <> item-doc-est-cex.mo-codigo then do:
                        run converte-moeda (input-output var-preco-unit,
                                            input item-doc-est-cex.mo-codigo).

                        run converte-moeda (input-output var-preco-unit-aux,
                                            input item-doc-est-cex.mo-codigo).
                end.

                IF item-doc-est.cd-trib-icm <> 1 THEN
                    ASSIGN var-valor-icm-mattran-rea = item-doc-est.valor-icm[1].

                IF item-doc-est.cd-trib-ipi <> 1 THEN
                    assign var-valor-ipi-mattran-rea = item-doc-est.valor-ipi[1].


                ASSIGN var-valor-pis-mattran-rea    = &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
                                                          item-doc-est.valor-pis &ELSE DEC(substring(item-doc-est.char-2,41,14)) &ENDIF
                       var-valor-cofins-mattran-rea = &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
                                                          item-doc-est.val-cofins &ELSE DEC(substring(item-doc-est.char-2,103,14)) &ENDIF.

                if  tt-param.i-custo-item = 1 then /*Unitario*/
                    assign var-valor-ipi-mattran-rea    = var-valor-ipi-mattran-rea    / tt-detalha-item.quantidade
                           var-valor-icm-mattran-rea    = var-valor-icm-mattran-rea    / tt-detalha-item.quantidade
                           var-valor-pis-mattran-rea    = var-valor-pis-mattran-rea    / tt-detalha-item.quantidade
                           var-valor-cofins-mattran-rea = var-valor-cofins-mattran-rea / tt-detalha-item.quantidade.

                for first desp-imp
                    where desp-imp.cod-desp = item-doc-est-cex.cod-desp no-lock: end.

                FOR FIRST desp-embarque FIELDS(descricao val-desp mo-codigo) NO-LOCK
                    WHERE desp-embarque.cod-estabel = embarque-imp.cod-estab
                      AND desp-embarque.embarque = embarque-imp.embarque
                      AND desp-embarque.cod-desp = item-doc-est-cex.cod-desp:
                END.

                FOR FIRST b-item-doc-est-aux2
                    WHERE b-item-doc-est-aux2.serie-docto  = b-item-doc-est.serie-docto
                      AND b-item-doc-est-aux2.nro-docto    = b-item-doc-est.nro-docto
                      AND b-item-doc-est-aux2.cod-emitente = b-item-doc-est.cod-emitente
                      AND b-item-doc-est-aux2.nat-operacao = b-item-doc-est.nat-operacao
                      AND b-item-doc-est-aux2.sequencia    = item-doc-est.seq-comp NO-LOCK:
                END.

                IF NOT AVAIL b-item-doc-est-aux2 THEN NEXT.
                if  avail b-item-doc-est THEN
                    for first b-item-doc-est-aux
                        where b-item-doc-est-aux.serie-docto  = b-item-doc-est.serie-docto
                        and   b-item-doc-est-aux.nro-docto    = b-item-doc-est.nro-docto
                        and   b-item-doc-est-aux.cod-emitente = b-item-doc-est.cod-emitente
                        and   b-item-doc-est-aux.nat-operacao = b-item-doc-est.nat-operacao
                        and   b-item-doc-est-aux.it-codigo    = item-doc-est.it-codigo no-lock:
                    end.

                FOR FIRST bf-natur-oper
                     WHERE bf-natur-oper.nat-operacao = item-doc-est.nat-operacao NO-LOCK:
                END.

                lok = YES.
                IF i-pais-impto-usuario            <> 1   AND
                   tt-param.l-desc-desp-item       =  YES AND
                   substring(desp-imp.char-1,45,1) =  "Y" THEN
                    lok = NO.

                IF lok THEN DO:
                    find first tt-detalha-despesa
                        where  tt-detalha-despesa.embarque     = embarque-imp.embarque
                        and    tt-detalha-despesa.cod-estabel  = embarque-imp.cod-estabel
                        and    tt-detalha-despesa.numero-ordem = (&if "{&bf_mat_versao_ems}" >= "2.06" &then
                                                                      if  docum-est.idi-nf-simples-remes = 1 then
                                                                          b-item-doc-est-aux2.num-ord-import
                                                                  &else
                                                                      if  int(substring(docum-est.char-2,101,1)) = 1 then
                                                                          int(substring(b-item-doc-est.char-2,145,9))
                                                                  &endif
                                                                      else if avail b-item-doc-est-aux2 then
                                                                          b-item-doc-est-aux2.numero-ordem
                                                                          else
                                                                              b-item-doc-est.numero-ordem)
                        and    tt-detalha-despesa.nro-docto    = item-doc-est.nro-docto
                        and    tt-detalha-despesa.cod-despesa  = desp-imp.cod-desp
                        and    tt-detalha-despesa.it-codigo    = item-doc-est.it-codigo
                        AND    tt-detalha-despesa.sequencia    = b-item-doc-est-aux2.sequencia no-lock no-error.

                    if  not avail tt-detalha-despesa then do:
                        create tt-detalha-despesa.
                        assign tt-detalha-despesa.embarque      = embarque-imp.embarque
                               tt-detalha-despesa.cod-estabel   = embarque-imp.cod-estabel
                               tt-detalha-despesa.numero-ordem  = (&if "{&bf_mat_versao_ems}" >= "2.06" &then
                                                                       if  docum-est.idi-nf-simples-remes = 1 then
                                                                           b-item-doc-est-aux2.num-ord-import
                                                                   &else
                                                                       if  int(substring(docum-est.char-2,101,1)) = 1 then
                                                                           int(substring(b-item-doc-est.char-2,145,9))
                                                                   &endif
                                                                       else if avail b-item-doc-est-aux2 then
                                                                           b-item-doc-est-aux2.numero-ordem
                                                                           else
                                                                               b-item-doc-est.numero-ordem)
                               tt-detalha-despesa.nro-docto     = item-doc-est.nro-docto
                               tt-detalha-despesa.cod-despesa   = desp-imp.cod-desp
                               tt-detalha-despesa.desc-despesa  = IF AVAIL desp-embarque AND desp-embarque.descricao <> "":U THEN desp-embarque.descricao ELSE desp-imp.descricao
                               tt-detalha-despesa.it-codigo     = item-doc-est.it-codigo
                               tt-detalha-despesa.situacao      = p-situacao
                               tot-despesa-orc                  = tot-despesa-orc
                                                                + vl-desp-orcad-det.
                               tt-detalha-despesa.sequencia     = b-item-doc-est-aux2.sequencia.

                        IF item-doc-est.cd-trib-icm = 1 AND item-doc-est.valor-icm[1] <> 0 THEN
                            ASSIGN de-valor-icm = (item-doc-est-cex.val-desp * item-doc-est.valor-icm[1]) / item-doc-est.preco-total[1].
                        ELSE
                            ASSIGN de-valor-icm = 0.


                        IF item-doc-est.cd-trib-ipi = 3 AND item-doc-est.valor-ipi[1] <> 0 THEN
                            ASSIGN de-valor-ipi = (item-doc-est-cex.val-desp * item-doc-est.valor-ipi[1]) / item-doc-est.preco-total[1].
                        ELSE
                            ASSIGN de-valor-ipi = 0.

                        IF tt-param.i-custo-item = 1 then DO: /*Unitario*/
                            IF  AVAIL bf-natur-oper
                           &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
                            AND bf-natur-oper.log-icms-despes-import-nfr
                           &ELSE
                            AND SUBSTR(bf-natur-oper.char-2,146,1) = "1"
                           &ENDIF THEN DO:
                               assign tt-detalha-despesa.vl-des-rea = ((item-doc-est-cex.val-desp + de-valor-ipi)
                                                                      / tt-detalha-item.quantidade).
                            END.
                            ELSE DO:
                                assign tt-detalha-despesa.vl-des-rea = ((item-doc-est-cex.val-desp - de-valor-icm + de-valor-ipi)
                                                                        / tt-detalha-item.quantidade).
                            END.

                            IF tt-param.moeda <> var-moeda-conv-rea THEN DO:
                               RUN converte-moeda (INPUT-OUTPUT tt-detalha-despesa.vl-des-rea,
                                                   INPUT var-moeda-conv-rea).
                            END.

                            IF  AVAIL bf-natur-oper
                            &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
                            AND bf-natur-oper.log-icms-despes-import-nfr
                            &ELSE
                            AND SUBSTR(bf-natur-oper.char-2,146,1) = "1"
                            &ENDIF THEN DO:
                                ASSIGN de-val-desp-nfc = item-doc-est-cex.val-desp + de-valor-ipi.
                            END.
                            ELSE DO:
                                ASSIGN de-val-desp-nfc = item-doc-est-cex.val-desp - de-valor-icm + de-valor-ipi.
                            END.
                            IF tt-param.moeda <> 0 THEN
                                RUN converte-moeda (INPUT-OUTPUT de-val-desp-nfc,
                                                    INPUT 0).
                            ASSIGN de-tot-desp      = de-tot-desp + tt-detalha-despesa.vl-des-rea
                                   de-despesa-total = de-despesa-total + de-val-desp-nfc.

                            IF LAST (item-doc-est-cex.cod-desp) THEN DO:
                                IF (de-despesa-total / tt-detalha-item.quantidade) > de-tot-desp THEN
                                    ASSIGN de-residuo = (de-despesa-total / tt-detalha-item.quantidade) - de-tot-desp
                                           tt-detalha-despesa.vl-des-rea = tt-detalha-despesa.vl-des-rea + de-residuo
                                           de-tot-desp = de-tot-desp + de-residuo.
                            END.

                        END.
                        ELSE DO:
                            IF  AVAIL bf-natur-oper
                            &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
                            AND bf-natur-oper.log-icms-despes-import-nfr
                            &ELSE
                            AND SUBSTR(bf-natur-oper.char-2,146,1) = "1"
                            &ENDIF THEN DO:
                                assign tt-detalha-despesa.vl-des-rea = item-doc-est-cex.val-desp + de-valor-ipi.
                            END.
                            ELSE DO:
                                assign tt-detalha-despesa.vl-des-rea = item-doc-est-cex.val-desp - de-valor-icm + de-valor-ipi.
                            END.

                            IF item-doc-est.idi-tributac-pis = 1 AND item-doc-est.valor-pis <> 0 THEN DO:
                                ASSIGN de-valor-pis = (item-doc-est-cex.val-desp * item-doc-est.valor-pis) / item-doc-est.preco-total[1].
                            END.
                            ELSE DO:
                                ASSIGN de-valor-pis = 0.
                            END.

                            IF item-doc-est.idi-tributac-cofins = 1 AND item-doc-est.val-cofins <> 0 THEN DO:
                                ASSIGN de-valor-cofins = (item-doc-est-cex.val-desp * item-doc-est.val-cofins) / item-doc-est.preco-total[1].
                            END.
                            ELSE DO:
                                ASSIGN de-valor-cofins = 0.
                            END.

                            if  tt-param.moeda <> var-moeda-conv-rea THEN
                               RUN converte-moeda (INPUT-OUTPUT tt-detalha-despesa.vl-des-rea,
                                                   INPUT var-moeda-conv-rea).

                            ASSIGN de-tot-desp  = de-tot-desp + (tt-detalha-despesa.vl-des-rea - de-valor-pis - de-valor-cofins).
                        END.
                    END. /* tt-detalha-despesa */
                END. /* lok */
                /*DESPESAS DA NF COMPLEMENTAR*/

                IF item-doc-est.cd-trib-icm = 1 AND item-doc-est.valor-icm[1] <> 0 THEN
                    ASSIGN de-valor-icm = (item-doc-est-cex.val-desp * item-doc-est.valor-icm[1]) / item-doc-est.preco-total[1].
                ELSE
                    ASSIGN de-valor-icm = 0.


                IF item-doc-est.cd-trib-ipi = 3 AND item-doc-est.valor-ipi[1] <> 0 THEN
                    ASSIGN de-valor-ipi = (item-doc-est-cex.val-desp * item-doc-est.valor-ipi[1]) / item-doc-est.preco-total[1].
                ELSE
                    ASSIGN de-valor-ipi = 0.

                /*reposiciona natureza de operacao na nota complementar*/
                IF  AVAIL bf-natur-oper
                   &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
                    AND bf-natur-oper.log-icms-despes-import-nfr
                   &ELSE
                    AND SUBSTR(bf-natur-oper.char-2,146,1) = "1"
                   &ENDIF THEN DO:

                       ASSIGN de-val-desp-nfc = item-doc-est-cex.val-desp + de-valor-ipi.
                   END.
                ELSE DO:
                    ASSIGN de-val-desp-nfc = item-doc-est-cex.val-desp - de-valor-icm + de-valor-ipi.
                END.

                IF item-doc-est.idi-tributac-pis = 1 AND item-doc-est.valor-pis <> 0 THEN DO:
                    ASSIGN de-valor-pis = (item-doc-est-cex.val-desp * item-doc-est.valor-pis) / item-doc-est.preco-total[1].
                END.
                ELSE DO:
                    ASSIGN de-valor-pis = 0.
                END.

                IF item-doc-est.idi-tributac-cofins = 1 AND item-doc-est.val-cofins <> 0 THEN DO:
                    ASSIGN de-valor-cofins = (item-doc-est-cex.val-desp * item-doc-est.val-cofins) / item-doc-est.preco-total[1].
                END.
                ELSE DO:
                    ASSIGN de-valor-cofins = 0.
                END.

                ASSIGN de-val-desp-nfc = de-val-desp-nfc - de-valor-pis - de-valor-cofins.

                IF i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
                    ASSIGN de-val-desp-nfc-mo = de-val-desp-nfc.
                    IF AVAIL desp-embarque AND var-moeda-conv-rea <> desp-embarque.mo-codigo AND desp-embarque.mo-codigo <> b-docum-est-aux.mo-codigo THEN DO:
                        run cdp/cd0812.p (input  var-moeda-conv-rea,         /*moeda origem*/
                                          input  desp-embarque.mo-codigo,    /*moeda destino*/
                                          input  de-val-desp-nfc-mo,         /*valor origem*/
                                          input  item-doc-est-cex.dat-cotac, /*data conversao*/
                                          output de-val-desp-nfc-mo).        /*valor destino*/
                    END.
                END.


                if  tt-param.moeda <> var-moeda-conv-rea THEN DO:

                    IF i-pais-impto-usuario <> 1 /* Brasil */ AND tt-param.l-considera-cot-docto THEN DO:
                        FIND FIRST b-docum-est-aux OF item-doc-est NO-LOCK NO-ERROR.
                        IF AVAIL b-docum-est-aux AND tt-param.moeda = b-docum-est-aux.mo-codigo THEN DO:
                            ASSIGN de-val-desp-nfc =  (de-val-desp-nfc * item-doc-est-cex.cotacao) / b-docum-est-aux.cotacao-dia.
                        END.
                        ELSE DO:
                            run converte-moeda-data (input-output de-val-desp-nfc,
                                                     input var-moeda-conv-rea,
                                                     INPUT item-doc-est-cex.dat-cotac).
                        END.

                    END.
                    ELSE DO:
                        RUN converte-moeda (INPUT-OUTPUT de-val-desp-nfc,
                                            INPUT var-moeda-conv-rea).
                    END.

                END.


                for first tt-detalha-despesa-aux
                     where tt-detalha-despesa-aux.embarque     = tt-detalha-despesa.embarque
                       and tt-detalha-despesa-aux.cod-estabel  = tt-detalha-despesa.cod-estabel
                       and tt-detalha-despesa-aux.cod-despesa  = desp-imp.cod-desp no-lock
                    use-index ch-codigo:
                end.

                if not avail tt-detalha-despesa-aux then do:
                   CREATE tt-detalha-despesa-aux.
                   ASSIGN tt-detalha-despesa-aux.embarque     = embarque-imp.embarque
                          tt-detalha-despesa-aux.cod-estabel  = embarque-imp.cod-estabel
                          tt-detalha-despesa-aux.cod-despesa  = desp-imp.cod-desp
                          tt-detalha-despesa-aux.desc-despesa = IF AVAIL desp-embarque AND desp-embarque.descricao <> "":U THEN desp-embarque.descricao ELSE desp-imp.descricao
                          tt-detalha-despesa-aux.vl-des-rea   = de-val-desp-nfc
                          tt-detalha-despesa-aux.situacao     = p-situacao.

                END.
                ELSE DO:
                    ASSIGN tt-detalha-despesa-aux.vl-des-rea = tt-detalha-despesa-aux.vl-des-rea + de-val-desp-nfc.
                END.

                IF i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
                    IF AVAIL desp-embarque AND desp-embarque.mo-codigo <> b-docum-est-aux.mo-codigo THEN
                        ASSIGN tt-detalha-despesa-aux.vl-des-rea-mo = tt-detalha-despesa-aux.vl-des-rea-mo + de-val-desp-nfc-mo
                               tt-detalha-despesa-aux.moeda-mo      = desp-embarque.mo-codigo.
                    ELSE DO:
                        ASSIGN tt-detalha-despesa-aux.vl-des-rea-mo = tt-detalha-despesa-aux.vl-des-rea-mo + (de-val-desp-nfc-mo * item-doc-est-cex.cotacao) / b-docum-est-aux.cotacao-dia
                               tt-detalha-despesa-aux.moeda-mo      = b-docum-est-aux.mo-codigo.
                    END.
                END.

                ASSIGN de-val-desp-nfc2 = de-val-desp-nfc2 + de-val-desp-nfc.

                assign tt-detalha-item.vl-ipi-rea     = tt-detalha-item.vl-ipi-rea     + var-valor-ipi-mattran-rea
                       tt-detalha-item.vl-icms-rea    = tt-detalha-item.vl-icms-rea    + var-valor-icm-mattran-rea
                       tt-detalha-item.vl-pis-rea     = tt-detalha-item.vl-pis-rea     + var-valor-pis-mattran-rea
                       tt-detalha-item.vl-cofins-rea  = tt-detalha-item.vl-cofins-rea  + var-valor-cofins-mattran-rea
                       tt-detalha-item.vl-tot-imp-rea = tt-detalha-item.vl-tot-imp-rea + var-valor-ipi-mattran-rea + var-valor-icm-mattran-rea + var-valor-pis-mattran-rea + var-valor-cofins-mattran-rea .

                ASSIGN de-tot-imp-rea = tt-detalha-item.vl-tot-imp-des-rea.

                /*Re-calcular Percentuais*/
                assign tt-detalha-item.per-mercado-rea            = (tt-detalha-item.vl-mercado-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                       tt-detalha-item.per-ii-rea                 = (tt-detalha-item.vl-ii-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                       tt-detalha-item.per-ipi-rea                = (tt-detalha-item.vl-ipi-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                       tt-detalha-item.per-icms-rea               = (tt-detalha-item.vl-icms-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                       tt-detalha-item.per-pis-rea                = (tt-detalha-item.vl-pis-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                       tt-detalha-item.per-cofins-rea             = (tt-detalha-item.vl-cofins-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                       tt-detalha-item.per-tot-imp-rea            = (tt-detalha-item.vl-tot-imp-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                       tt-detalha-item.per-ii2-rea                = (tt-detalha-item.vl-ii2-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                       tt-detalha-item.per-tot-des-rea            = (tt-detalha-item.vl-tot-des-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                       tt-detalha-item.per-tot-imp-des-rea        = (tt-detalha-item.vl-tot-imp-des-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                       tt-detalha-item.per-tot-com-ipi-icms-rea   = (tt-detalha-item.vl-tot-com-ipi-icms-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                       tt-detalha-item.per-tot-sem-ipi-icms-rea   = (tt-detalha-item.vl-tot-sem-ipi-icms-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100.

                IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                    ASSIGN tt-detalha-item.per-cbs-rea            = (tt-detalha-item.vl-cbs-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                           tt-detalha-item.per-ibs-uf-rea         = (tt-detalha-item.vl-ibs-uf-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                           tt-detalha-item.per-ibs-mun-rea        = (tt-detalha-item.vl-ibs-mun-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                           tt-detalha-item.per-is-rea             = (tt-detalha-item.vl-is-rea
                                                                  /  tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100.
                END.
            end.  /*item-doc-est-cex*/

            IF tt-param.i-custo-item = 1  then do: /*Unitario*/

                assign tt-detalha-item.vl-des-rea                    = tt-detalha-item.vl-des-rea
                                                                    + de-tot-desp
                      tt-detalha-item.vl-tot-despesa                = tt-detalha-item.vl-tot-despesa
                                                                    + de-tot-desp
                      tt-detalha-item.vl-tot-des-rea                = tt-detalha-item.vl-tot-des-rea
                                                                    + de-tot-desp
                      tt-detalha-item.vl-des-rea-total              = tt-detalha-item.vl-des-rea-total
                                                                    + (de-tot-desp * tt-detalha-item.quantidade)
                      tt-detalha-item.vl-tot-imp-des-rea            = tt-detalha-item.vl-tot-imp-des-rea
                                                                    + de-tot-desp
                      tt-detalha-item.vl-tot-des-rea-total          = tt-detalha-item.vl-tot-des-rea-total
                                                                    + (de-tot-desp * tt-detalha-item.quantidade)
                      tt-detalha-item.vl-tot-imp-des-rea-total      = tt-detalha-item.vl-tot-imp-des-rea-total
                                                                    + (de-tot-desp * tt-detalha-item.quantidade)
                      tt-detalha-item.vl-tot-com-ipi-icms-rea-total = tt-detalha-item.vl-tot-com-ipi-icms-rea-total
                                                                    + (de-tot-desp * tt-detalha-item.quantidade)
                                                                    - de-tot-desp
                      tt-detalha-item.vl-tot-sem-ipi-icms-rea-total = tt-detalha-item.vl-tot-sem-ipi-icms-rea-total
                                                                    + (de-tot-desp * tt-detalha-item.quantidade)
                                                                    - de-tot-desp.

                IF i-pais-impto-usuario <> 1 /* Brasil */ THEN
                    ASSIGN tt-detalha-item.vl-tot-com-ipi-icms-rea          = (tt-detalha-item.vl-tot-com-ipi-icms-rea )  + de-tot-desp
                           tt-detalha-item.vl-tot-sem-ipi-icms-dsp-merc-rea = (tt-detalha-item.vl-tot-sem-ipi-icms-dsp-merc-rea  )  + de-tot-desp.

                ASSIGN de-tot-desp = 0.


            end.
            else do:
                assign tt-detalha-item.vl-tot-des-rea                = tt-detalha-item.vl-tot-des-rea
                                                                     + de-tot-desp
                       tt-detalha-item.vl-des-rea-total              = tt-detalha-item.vl-des-rea-total
                                                                     + (de-tot-desp).

                IF i-pais-impto-usuario = 1 THEN     /* Brasil */
                    ASSIGN tt-detalha-item.vl-tot-imp-des-rea        = de-tot-imp-rea
                                                                     + IF tt-detalha-item.vl-des-rea = 0 THEN de-tot-desp ELSE tt-detalha-item.vl-des-rea
                           tt-detalha-item.vl-tot-com-ipi-icms-rea   = tt-detalha-item.vl-tot-com-ipi-icms-rea
                                                                     + tt-detalha-item.vl-tot-imp-des-rea.
                ELSE
                    ASSIGN tt-detalha-item.vl-tot-imp-des-rea            = tt-detalha-item.vl-tot-imp-des-rea
                           tt-detalha-item.vl-tot-com-ipi-icms-rea-total = tt-detalha-item.vl-tot-com-ipi-icms-rea-total
                           tt-detalha-item.vl-tot-sem-ipi-icms-rea-total = tt-detalha-item.vl-tot-sem-ipi-icms-rea-total
                           tt-detalha-item.vl-tot-com-ipi-icms-rea          = tt-detalha-item.vl-tot-com-ipi-icms-rea
                           tt-detalha-item.vl-tot-sem-ipi-icms-dsp-merc-rea = tt-detalha-item.vl-tot-sem-ipi-icms-dsp-merc-rea.

                ASSIGN tt-detalha-item.vl-tot-des-rea-total          = tt-detalha-item.vl-tot-des-rea-total
                       tt-detalha-item.vl-tot-imp-des-rea-total      = tt-detalha-item.vl-tot-imp-des-rea-total

                       tt-detalha-item.vl-des-rea                    = tt-detalha-item.vl-des-rea
                       tt-detalha-item.vl-tot-despesa                = tt-detalha-item.vl-tot-despesa.



                ASSIGN de-tot-imp-rea = 0
                       de-tot-desp    = 0.

            end.

        END. /*nota fiscal complementar*/

        /*Nota Principal e Relacionadas*/
        ELSE DO:
            /*aqui oráado*/
            IF i-pais-impto-usuario = 1 THEN DO:
                IF  tt-param.l-desemb-parc and p-situacao <> 1 and
                    trim(substring(embarque-imp.char-1,21,20)) <> "" then next.
            END.
            ELSE DO:
                IF  tt-param.l-desemb-parc and p-situacao <> 1 AND docum-est.idi-nf-simples-remes <> 2 and
                    trim(substring(embarque-imp.char-1,21,20)) <> "" then next.
            END.

            for first ordem-compra fields(numero-ordem  char-2  num-pedido  cod-emitente
                                           data-cotacao  preco-fornec preco-unit aliquota-ipi)
                where ordem-compra.numero-ordem = (&if "{&bf_mat_versao_ems}" >= "2.06" &then
                                                     if docum-est.idi-nf-simples-remes = 1 then
                                                         item-doc-est.num-ord-import
                                                   &else
                                                     if int(substring(docum-est.char-2,101,1)) = 1 then
                                                         int(substring(item-doc-est.char-2,145,8))
                                                   &endif
                                                     else item-doc-est.numero-ordem)
                                                  no-lock:
            end.

            if  not avail ordem-compra then next.

            if  p-situacao = 1 then do:
                &if "{&bf_mat_versao_ems}" >= "2.06" &then
                    if docum-est.idi-nf-simples-remes = 1 then do:
                        if first-of(item-doc-est.num-ord-import) then

                &else
                    if int(substring(docum-est.char-2,101,1)) = 1 then do:
                        if first-of(int(substring(item-doc-est.char-2,145,8))) then
                &endif
                        assign l-cria-embarque-corpo = yes.
                end.
                else if first-of(item-doc-est.numero-ordem) then
                    assign l-cria-embarque-corpo = yes.

                if l-cria-embarque-corpo then do : /*Nota Principal*/
                    CREATE tt-embarque-nf.
                    ASSIGN tt-embarque-nf.embarque     = embarque-imp.embarque
                           tt-embarque-nf.cod-estabel  = embarque-imp.cod-estabel
                           tt-embarque-nf.nr-nota-fis  = docum-est.nro-docto
                           tt-embarque-nf.dt-emissao   = docum-est.dt-emissao
                           tt-embarque-nf.nr-di        = embarque-imp.declaracao-import
                           tt-embarque-nf.dt-di        = embarque-imp.data-di.

                    create tt-embarque-corpo.
                    assign tt-embarque-corpo.embarque      = embarque-imp.embarque
                           tt-embarque-corpo.cod-estabel   = embarque-imp.cod-estabel
                           tt-embarque-corpo.desc-estabel  = c-desc-estabel
                           tt-embarque-corpo.cod-emitente  = processo-imp.cod-exportador
                           tt-embarque-corpo.desc-emitente = c-desc-emitente
                           tt-embarque-corpo.nr-nota-fis   = docum-est.nro-docto
                           tt-embarque-corpo.dt-emissao    = docum-est.dt-emissao
                           tt-embarque-corpo.nr-di         = embarque-imp.declaracao-import
                           tt-embarque-corpo.dt-di         = embarque-imp.data-di
                           tt-embarque-corpo.numero-ordem  = (&if "{&bf_mat_versao_ems}" >= "2.06" &then
                                                                if docum-est.idi-nf-simples-remes = 1 then
                                                                    item-doc-est.num-ord-import
                                                              &else
                                                                if int(substring(docum-est.char-2,101,1)) = 1 then
                                                                    int(substring(item-doc-est.char-2,145,8))
                                                              &endif
                                                                else
                                                                    ordem-compra.numero-ordem)
                           tt-embarque-corpo.it-codigo     = item-doc-est.it-codigo
                           tt-embarque-corpo.desc-item     = item.desc-item.
                    assign p-situacao = 2.
                end.
            end.


            assign /*tot-despesa-orc = 0 */
                   tot-despesa-rea = 0.

            /* => DETALHA ITEM *******************************/
            &if "{&bf_mat_versao_ems}" >= "2.05" &then
                for first cotacao-item fields( numero-ordem  cod-emitente  mo-codigo  aliquota-ii char-1
                                               data-cotacao  cot-aprovada  it-codigo  seq-cotac aliquota-ipi)
                    where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                      and cotacao-item.cod-emitente = ordem-compra.cod-emitente
                      and cotacao-item.data-cotacao = ordem-compra.data-cotacao
                      and cotacao-item.cot-aprovada = yes no-lock:
                end.
            &else
                for first cotacao-item fields( numero-ordem  cod-emitente  mo-codigo  char-1
                                               data-cotacao  cot-aprovada  it-codigo  seq-cotac aliquota-ipi)
                    where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                      and cotacao-item.cod-emitente = ordem-compra.cod-emitente
                      and cotacao-item.data-cotacao = ordem-compra.data-cotacao
                      and cotacao-item.cot-aprovada = yes no-lock:
                end.
            &endif

            if  not avail cotacao-item then next.

            ASSIGN i-parcela = &if "{&bf_mat_versao_ems}" >= "2.06" &then
                                    if docum-est.idi-nf-simples-remes = 1 then
                                        item-doc-est.num-parc-import
                               &else
                                    if int(substring(docum-est.char-2,101,1)) = 1 then
                                        int(substring(item-doc-est.char-2,154,5))
                               &endif
                                    else item-doc-est.parcela.

            FOR FIRST b-ordens-embarque FIELDS(char-2 numero-ordem) WHERE
                      b-ordens-embarque.cod-estabel  = embarque-imp.cod-estabel  AND
                      b-ordens-embarque.embarque     = embarque-imp.embarque     AND
                      b-ordens-embarque.numero-ordem = (&if "{&bf_mat_versao_ems}" >= "2.06" &then
                                                            if docum-est.idi-nf-simples-remes = 1 then
                                                                item-doc-est.num-ord-import
                                                        &else
                                                            if int(substring(docum-est.char-2,101,1)) = 1 then
                                                                int(substring(item-doc-est.char-2,145,8))
                                                        &endif
                                                            else item-doc-est.numero-ordem)
                    and b-ordens-embarque.parcela    = i-parcela      NO-LOCK:
            END.

            ASSIGN de-preco-unit-sem-ipi = (ordem-compra.preco-unit * 100) / (100 + ordem-compra.aliquota-ipi).

            create tt-detalha-item.
            assign tt-detalha-item.embarque                   = embarque-imp.embarque
                   tt-detalha-item.cod-estabel                = embarque-imp.cod-estabel
                   tt-detalha-item.embarque-orig              = pc-embarque
                   tt-detalha-item.nro-docto                  = item-doc-est.nro-docto
                   tt-detalha-item.sequencia                  = item-doc-est.sequencia
                   tt-detalha-item.it-codigo                  = ITEM.it-codigo
                   tt-detalha-item.descricao                  = ITEM.desc-item
                   tt-detalha-item.numero-ordem               = ordem-compra.numero-ordem
                   tt-detalha-item.parcela                    = i-parcela
                   tt-detalha-item.quantidade                 = item-doc-est.quantidade
                   tt-detalha-item.un                         = ITEM.un
                   tt-detalha-item.vl-mercado-orc             = de-preco-unit-sem-ipi
                   tt-detalha-item.aliquota-ipi               = item-doc-est.aliquota-ipi
                   tt-detalha-item.aliquota-icms              = item-doc-est.aliquota-icm
                   tt-detalha-item.aliquota-pis               = &IF "{&bf_mat_versao_ems}":U >= "2.06":U &THEN item-doc-est.val-aliq-pis
                                                                &ELSE DEC(SUBSTRING(item-doc-est.char-2,022,05)) &endif
                   tt-detalha-item.aliquota-cofins            = &IF "{&bf_mat_versao_ems}":U >= "2.06":U &THEN item-doc-est.val-aliq-cofins
                                                                &ELSE DEC(SUBSTRING(item-doc-est.char-2,084,05)) &endif
                   tt-detalha-item.situacao                   = p-situacao.

            RUN recupera-aliquotas IN h-cdapi995 (INPUT "item-doc-est":U,
                                                  INPUT item-doc-est.serie-docto + "/" +
                                                        item-doc-est.nro-docto + "/" +
                                                        STRING(item-doc-est.cod-emitente) + "/" +
                                                        item-doc-est.nat-operacao + "/" +
                                                        STRING(item-doc-est.sequencia),
                                                  OUTPUT de-aliquota-pis,
                                                  OUTPUT de-aliquota-cofins).
            IF de-aliquota-pis <> 0 THEN
                ASSIGN tt-detalha-item.aliquota-pis = de-aliquota-pis.
            IF de-aliquota-cofins <> 0 THEN
                ASSIGN tt-detalha-item.aliquota-cofins = de-aliquota-cofins.

            FIND FIRST bf-tt-detalha-item
                 WHERE bf-tt-detalha-item.it-codigo = tt-detalha-item.it-codigo NO-ERROR.
            IF  AVAIL bf-tt-detalha-item THEN
                ASSIGN bf-tt-detalha-item.i-numero-itens = bf-tt-detalha-item.i-numero-itens + 1
                       bf-tt-detalha-item.tot-quantidade = bf-tt-detalha-item.tot-quantidade + tt-detalha-item.quantidade.

            IF AVAIL b-ordens-embarque THEN
               ASSIGN &if "{&bf_mat_versao_ems}" >= "2.05" &then
                         tt-detalha-item.aliquota-ii      = IF  TRIM(SUBSTRING(b-ordens-embarque.char-2,1,6)) = " " THEN cotacao-item.aliquota-ii
                                                            ELSE DEC(TRIM(SUBSTRING(b-ordens-embarque.char-2,1,6)))
                         tt-detalha-item.aliquota-ii2     = IF  TRIM(SUBSTRING(b-ordens-embarque.char-2,1,6)) = " " THEN cotacao-item.aliquota-ii
                                                            ELSE DEC(TRIM(SUBSTRING(b-ordens-embarque.char-2,1,6))).

                      &else
                          tt-detalha-item.aliquota-ii     = IF  TRIM(SUBSTRING(b-ordens-embarque.char-2,1,6)) = " " THEN DEC(TRIM(SUBSTRING(cotacao-item.char-1,61,20)))
                                                            ELSE DEC(TRIM(SUBSTRING(b-ordens-embarque.char-2,1,6)))
                          tt-detalha-item.aliquota-ii2    = IF  TRIM(SUBSTRING(b-ordens-embarque.char-2,1,6)) = " " THEN DEC(TRIM(SUBSTRING(cotacao-item.char-1,61,20)))
                                                            ELSE DEC(TRIM(SUBSTRING(b-ordens-embarque.char-2,1,6))).

                      &endif
            ELSE
                ASSIGN &if "{&bf_mat_versao_ems}" >= "2.05" &then
                          tt-detalha-item.aliquota-ii     = cotacao-item.aliquota-ii
                          tt-detalha-item.aliquota-ii2    = cotacao-item.aliquota-ii.
                       &else
                           tt-detalha-item.aliquota-ii    = DEC(TRIM(SUBSTRING(cotacao-item.char-1,61,20)))
                           tt-detalha-item.aliquota-ii2   = DEC(TRIM(SUBSTRING(cotacao-item.char-1,61,20))).
                       &endif

            if  tt-param.i-custo-item = 2 then /*Total*/
                assign tt-detalha-item.vl-mercado-orc = de-preco-unit-sem-ipi
                                                      * item-doc-est.quantidade.
            ASSIGN de-preco-unit-sem-ipi = 0.
            /*Convers∆o*/

            if  tt-param.moeda <> cotacao-item.mo-codigo THEN DO:
                run converte-moeda (input-output tt-detalha-item.vl-mercado-orc,
                                    input cotacao-item.mo-codigo).
            END.

            assign vl-ii-orcad-det  = 0
                   vl-ii2-orcad-det = 0
                   no-despesa       = no
                   var-moeda-conv-orc = tt-param.moeda
                   tt-detalha-item.vl-mercado-orc-total = if tt-param.i-custo-item = 2 then tt-detalha-item.vl-mercado-orc
                                                          else (tt-detalha-item.vl-mercado-orc * item-doc-est.quantidade).

            &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
            ASSIGN vl-ipi-orcad-det    = 0
                   vl-icms-orcad-det   = 0
                   vl-pis-orcad-det    = 0
                   vl-cofins-orcad-det = 0.
            &ENDIF

             /****ORÄADO-INI*/
            for each  cotacao-item-cex fields( numero-ordem  cod-emitente  mapa-cotacao
                                               cod-incoterm  it-codigo     seq-cotac
                                               data-cotacao  cod-itiner    cod-desp
                                               val-desp      mo-codigo)
                where cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem
                  and cotacao-item-cex.cod-emitente = cotacao-item.cod-emitente
                  and cotacao-item-cex.it-codigo    = cotacao-item.it-codigo
                  and cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac
                  and cotacao-item-cex.data-cotacao = cotacao-item.data-cotacao
                  and cotacao-item-cex.mapa-cotacao = int(trim(substring(cotacao-item.char-1,1,20)))
                  and cotacao-item-cex.cod-incoterm = embarque-imp.cod-incoterm
                  and cotacao-item-cex.cod-itiner   = itinerario.cod-itiner no-lock
                use-index codigo:

                assign var-moeda-conv-orc = cotacao-item-cex.mo-codigo.

                /* II e II2 - ORCADO */
                if  cotacao-item-cex.cod-desp = i-cod-desp-ii and
                    tt-param.i-desp-imposto = 1 then /*Despesa*/
                    assign vl-ii2-orcad-det = cotacao-item-cex.val-desp.

                if  cotacao-item-cex.cod-desp = i-cod-desp-ii and
                    tt-param.i-desp-imposto = 2 then /*Imposto*/
                    assign vl-ii-orcad-det  = cotacao-item-cex.val-desp.

                &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
                    IF  AVAIL param-imp THEN DO:
                        IF  param-imp.cdn-despes-impto-ipi = cotacao-item-cex.cod-desp THEN DO:
                            ASSIGN vl-ipi-orcad-det = cotacao-item-cex.val-desp
                                   no-despesa       = YES.
                        END.

                        IF  param-imp.cdn-despes-impto-icms = cotacao-item-cex.cod-desp THEN DO:
                            ASSIGN vl-icms-orcad-det = cotacao-item-cex.val-desp
                                   no-despesa        = YES.
                        END.
                        IF  param-imp.cdn-despes-impto-pis = cotacao-item-cex.cod-desp THEN DO:
                            ASSIGN vl-pis-orcad-det = cotacao-item-cex.val-desp
                                   no-despesa        = YES.
                        END.
                        IF  param-imp.cdn-despes-impto-cofins = cotacao-item-cex.cod-desp THEN DO:
                            ASSIGN vl-cofins-orcad-det = cotacao-item-cex.val-desp
                                   no-despesa        = YES.
                        END.

                        /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-820) */
                        IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                            FIND FIRST param-imp-trib NO-LOCK
                                WHERE  param-imp-trib.cod-estabel = embarque-imp.cod-estabel NO-ERROR.
                            IF  AVAIL  param-imp THEN DO:
                                IF  param-imp-trib.cdn-despes-impto-CBS = cotacao-item-cex.cod-desp THEN DO:
                                    ASSIGN tt-detalha-item.vl-cbs-orc = cotacao-item-cex.val-desp
                                           no-despesa                 = YES.
                                END.

                                IF  param-imp-trib.cdn-despes-impto-IBSUF = cotacao-item-cex.cod-desp THEN DO:
                                    ASSIGN tt-detalha-item.vl-ibs-uf-orc = cotacao-item-cex.val-desp
                                           no-despesa                    = YES.
                                END.
                                IF  param-imp-trib.cdn-despes-impto-IBSMUN = cotacao-item-cex.cod-desp THEN DO:
                                    ASSIGN tt-detalha-item.vl-ibs-mun-orc = cotacao-item-cex.val-desp
                                           no-despesa                     = YES.
                                END.

                                IF  param-imp-trib.cdn-despes-impto-IS = cotacao-item-cex.cod-desp THEN DO:
                                    ASSIGN tt-detalha-item.vl-is-orc = cotacao-item-cex.val-desp
                                           no-despesa                = YES.
                                END.
                            END.
                        END.
                        /* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-820) */
                    END.

                &ELSE
                    /* IPI - ORCADO */
                    for first desp-imp fields( cod-desp  descricao )
                        where desp-imp.cod-desp = cotacao-item-cex.cod-desp
                          and substring(desp-imp.descricao,1,3) = "IPI":U no-lock:
                    end.
                    if  avail desp-imp then
                        assign vl-ipi-orcad-det = cotacao-item-cex.val-desp
                               no-despesa       = YES.
                    else
                        assign vl-ipi-orcad-det = 0.

                    /* ICMS - ORCADO */
                    for first desp-imp fields( cod-desp  descricao )
                        where desp-imp.cod-desp = cotacao-item-cex.cod-desp
                          and substring(desp-imp.descricao,1,4) = "ICMS":U no-lock:
                    end.
                    if  avail desp-imp then
                        assign vl-icms-orcad-det = cotacao-item-cex.val-desp
                               no-despesa        = YES.
                    else
                        assign vl-icms-orcad-det = 0.

                    /* PIS - ORCADO */
                    for first desp-imp fields( cod-desp  descricao )
                        where desp-imp.cod-desp = cotacao-item-cex.cod-desp
                          and substring(desp-imp.descricao,1,3) = "PIS":U no-lock:
                    end.
                    if  avail desp-imp THEN
                        assign vl-pis-orcad-det = cotacao-item-cex.val-desp
                               no-despesa        = YES.

                    for first desp-imp fields( cod-desp  descricao )
                        where desp-imp.cod-desp = cotacao-item-cex.cod-desp
                          and substring(desp-imp.descricao,1,6) = "COFINS":U no-lock:
                    end.
                    if  avail desp-imp then
                        assign vl-cofins-orcad-det = cotacao-item-cex.val-desp
                               no-despesa        = YES.
                &ENDIF

                /* Despesas - ORCADO */
                for first desp-imp fields ( cod-desp  tipo  descricao char-1)
                    where desp-imp.cod-desp = cotacao-item-cex.cod-desp no-lock:
                end.

                FOR FIRST desp-embarque FIELDS(descricao) NO-LOCK
                    WHERE desp-embarque.cod-estabel = embarque-imp.cod-estab
                      AND desp-embarque.embarque = embarque-imp.embarque
                      AND desp-embarque.cod-desp = cotacao-item-cex.cod-desp:
                END.

                if  not avail desp-imp then
                    next.

                IF i-pais-impto-usuario            <> 1   AND
                   tt-param.l-desc-desp-item       =  YES AND
                   substring(desp-imp.char-1,45,1) =  "Y" THEN NEXT.

                if  tt-param.i-custo-item = 2 and desp-imp.tipo <> 1 then /*Total e Diferente de Fixo*/
                    assign vl-desp-orcad-det = cotacao-item-cex.val-desp
                                             * item-doc-est.quantidade.
                else
                    assign vl-desp-orcad-det = cotacao-item-cex.val-desp.


                if desp-imp.tipo <> 1 then /*Total e Diferente de Fixo*/
                   ASSIGN vl-desp-orcad-aux = cotacao-item-cex.val-desp *
                                              item-doc-est.quantidade.
                ELSE
                    ASSIGN vl-desp-orcad-aux = cotacao-item-cex.val-desp.

                IF  desp-imp.cod-desp <> i-cod-desp-ii
                &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
                AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-ipi
                AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-icms
                AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-pis
                AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-cofins
                &ENDIF
                AND NOT no-despesa THEN DO:
                    find FIRST tt-detalha-despesa
                         WHERE tt-detalha-despesa.embarque    = embarque-imp.embarque
                           AND tt-detalha-despesa.cod-estabel = embarque-imp.cod-estabel
                           AND tt-detalha-despesa.cod-despesa = desp-imp.cod-desp no-lock no-error.
                    if not avail tt-detalha-despesa then do:
                        create tt-detalha-despesa.
                        assign tt-detalha-despesa.embarque      = embarque-imp.embarque
                               tt-detalha-despesa.cod-estabel   = embarque-imp.cod-estabel
                               tt-detalha-despesa.numero-ordem  = cotacao-item-cex.numero-ordem
                               tt-detalha-despesa.nro-docto     = item-doc-est.nro-docto
                               tt-detalha-despesa.cod-despesa   = desp-imp.cod-desp
                               tt-detalha-despesa.desc-despesa  = IF AVAIL desp-embarque AND desp-embarque.descricao <> "":U THEN desp-embarque.descricao ELSE desp-imp.descricao
                               tt-detalha-despesa.situacao      = p-situacao
                               tt-detalha-despesa.vl-des-orc    = vl-desp-orcad-det
                               tot-despesa-orc                  = tot-despesa-orc
                                                                + vl-desp-orcad-det
                               tt-detalha-despesa.it-codigo     = cotacao-item.it-codigo
                               tt-detalha-despesa.sequencia     = item-doc-est.sequencia.

                        if  tt-param.moeda <> var-moeda-conv-orc THEN
                            IF AVAIL tt-detalha-despesa THEN
                                run converte-moeda (input-output tt-detalha-despesa.vl-des-orc,
                                                    input var-moeda-conv-orc).
                            IF desp-imp.tipo = 1 AND tt-param.i-custo-item = 1 THEN
                                ASSIGN tt-detalha-despesa.vl-des-orc = tt-detalha-despesa.vl-des-orc / item-doc-est.quantidade.

                        ASSIGN de-tot-des-orc-aux = de-tot-des-orc-aux + tt-detalha-despesa.vl-des-orc.
                    END.
                    ELSE DO:
                        ASSIGN de-tot-des-orc-aux = de-tot-des-orc-aux + tt-detalha-despesa.vl-des-orc.
                    END.
                END.

                IF  desp-imp.cod-desp <> i-cod-desp-ii
                &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
                AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-ipi
                AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-icms
                AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-pis
                AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-cofins
                &ENDIF
                THEN DO:

                    IF tt-param.moeda <> var-moeda-conv-orc THEN DO:
                        RUN converte-moeda (INPUT-OUTPUT vl-desp-orcad-aux,
                                            INPUT var-moeda-conv-orc).
                    END.
                    for first tt-detalha-despesa-aux
                         where tt-detalha-despesa-aux.embarque     = embarque-imp.embarque
                           and tt-detalha-despesa-aux.cod-estabel  = embarque-imp.cod-estabel
                           and tt-detalha-despesa-aux.cod-despesa  = desp-imp.cod-desp
                           AND tt-detalha-despesa-aux.sequencia    = item-doc-est.sequencia no-lock /**/
                        use-index ch-codigo:
                    end.
                    if not avail tt-detalha-despesa-aux then do:
                        CREATE tt-detalha-despesa-aux.
                        ASSIGN tt-detalha-despesa-aux.embarque     = embarque-imp.embarque
                               tt-detalha-despesa-aux.cod-estabel  = embarque-imp.cod-estabel
                               tt-detalha-despesa-aux.cod-despesa  = desp-imp.cod-desp
                               tt-detalha-despesa-aux.desc-despesa = IF AVAIL desp-embarque AND desp-embarque.descricao <> "":U THEN desp-embarque.descricao ELSE desp-imp.descricao
                               tt-detalha-despesa-aux.vl-des-orc   = vl-desp-orcad-aux
                               tt-detalha-despesa-aux.sequencia    = item-doc-est.sequencia
                               tt-detalha-despesa-aux.situacao     = p-situacao.

                        /*acumula valor total das despesas oráadas convertidas ou nao*/
                        ASSIGN de-tot-desp-aux = de-tot-desp-aux + tt-detalha-despesa-aux.vl-des-orc.
                    END.
                    ELSE DO: /*Soma as despesas dos Desembarques parciais*/
                        ASSIGN tt-detalha-despesa-aux.vl-des-orc = tt-detalha-despesa-aux.vl-des-orc + vl-desp-orcad-aux.
                        ASSIGN de-tot-desp-aux = de-tot-desp-aux + tt-detalha-despesa-aux.vl-des-orc.
                    END.
                END.
                /*Total do Embarque*/
                if  tt-param.i-custo-item = 1 then do:
                    if  desp-imp.tipo = 1 then
                        assign tt-detalha-item.vl-des-orc-total     = tt-detalha-item.vl-des-orc-total
                                                                    + vl-desp-orcad-det.
                    else do:
                        if  not no-despesa then
                            assign tt-detalha-item.vl-des-orc-total = tt-detalha-item.vl-des-orc-total
                                                                    + (vl-desp-orcad-det * item-doc-est.quantidade).
                    end.
                end.
                else
                    assign tt-detalha-item.vl-des-orc-total = tot-despesa-orc.

                /***********************/

                assign tt-detalha-item.vl-tot-des-orc-total = tt-detalha-item.vl-des-orc-total.

                IF tt-param.i-desp-imposto = 1 THEN
                    ASSIGN vl-ii2-orcad-det-aux = vl-ii2-orcad-det * tt-detalha-item.quantidade.
                ELSE
                    ASSIGN vl-ii-orcad-det-aux  = vl-ii-orcad-det * tt-detalha-item.quantidade.

            end. /*cotacao-item-cex*/

            assign tt-detalha-item.vl-ii-orc                  = IF tt-param.i-custo-item = 2 THEN vl-ii-orcad-det * tt-detalha-item.quantidade
                                                                ELSE vl-ii-orcad-det
                   &IF  "{&bf_mat_versao_ems}" < "2.062" &THEN
                   tt-detalha-item.vl-ipi-orc                 = vl-ipi-orcad-det
                   tt-detalha-item.vl-icms-orc                = vl-icms-orcad-det
                   tt-detalha-item.vl-pis-orc                 = vl-pis-orcad-det
                   tt-detalha-item.vl-cofins-orc              = vl-cofins-orcad-det
                   tt-detalha-item.vl-tot-imp-orc             = tt-detalha-item.vl-ii-orc /*Total Imposto  II + IPI + ICMS*/
                                                              + vl-ipi-orcad-det
                                                              + vl-icms-orcad-det
                                                              + vl-pis-orcad-det
                                                              + vl-cofins-orcad-det
                   &ELSE
                   tt-detalha-item.vl-ipi-orc                 = IF tt-param.i-custo-item = 2 THEN vl-ipi-orcad-det * tt-detalha-item.quantidade
                                                                ELSE vl-ipi-orcad-det
                   tt-detalha-item.vl-icms-orc                = IF tt-param.i-custo-item = 2 THEN vl-icms-orcad-det * tt-detalha-item.quantidade
                                                                ELSE vl-icms-orcad-det
                   tt-detalha-item.vl-pis-orc                = IF tt-param.i-custo-item = 2 THEN vl-pis-orcad-det * tt-detalha-item.quantidade
                                                                ELSE vl-pis-orcad-det
                   tt-detalha-item.vl-cofins-orc             = IF tt-param.i-custo-item = 2 THEN vl-cofins-orcad-det * tt-detalha-item.quantidade
                                                                ELSE vl-cofins-orcad-det
                   tt-detalha-item.vl-tot-imp-orc             = tt-detalha-item.vl-ii-orc /*Total Imposto  II + IPI + ICMS*/
                                                                + tt-detalha-item.vl-ipi-orc
                                                                + tt-detalha-item.vl-icms-orc
                                                                + tt-detalha-item.vl-pis-orc
                                                                + tt-detalha-item.vl-cofins-orc
                   &ENDIF
                   tt-detalha-item.vl-ii2-orc                 = IF tt-param.i-custo-item = 2 THEN vl-ii2-orcad-det * tt-detalha-item.quantidade
                                                                ELSE vl-ii2-orcad-det /*II2*/
                   tt-detalha-item.vl-ii2-orc-aux             = vl-ii2-orcad-det-aux
                   tt-detalha-item.vl-ii-orc-aux              = vl-ii-orcad-det-aux
                   tt-detalha-item.vl-des-orc                 = de-tot-des-orc-aux /*tot-despesa-orc*/ /*Despesas*/

                   tt-detalha-item.vl-tot-com-ipi-icms-orc    = tt-detalha-item.vl-mercado-orc  /*Valor Mercado + (Total Imposto + Total Despesa)*/
                                                              + tt-detalha-item.vl-tot-imp-des-orc
                   tt-detalha-item.vl-tot-sem-ipi-icms-orc    = tt-detalha-item.vl-tot-com-ipi-icms-orc /*Valor Mercado + Imposto + Despesa - IPI - ICMS*/
                                                              - vl-ipi-orcad-det
                                                              - vl-icms-orcad-det
                                                              - vl-pis-orcad-det
                                                              - vl-cofins-orcad-det
                   tt-detalha-item.vl-tot-imp-des-orc-total   = tt-detalha-item.vl-tot-imp-orc
                                                              + tt-detalha-item.vl-tot-des-orc-total.


            /****ORÄADO-FIM*/
            assign vl-ii-reali-det     = 0
                   vl-ii2-reali-det    = 0
                   de-val-desp-aux     = 0
                   vl-pis-orcad-det    = 0
                   vl-cofins-orcad-det = 0
                   de-despesa-total    = 0
                   vl-ii2-reali-det-mo = 0
                   mo-ii2-reali-det    = 0.
            /****REALIZADO-INI*/

            IF i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
                   ASSIGN mo-ii2-reali-det = b-docum-est-aux.mo-codigo.
            END.

            for each  item-doc-est-cex fields( serie-docto  nro-docto  cod-emitente  sequencia
                                               nat-operacao  cod-desp  val-desp  mo-codigo cod-emitente-desp cotacao dat-cotac)
                where item-doc-est-cex.serie-docto  = item-doc-est.serie-docto
                  and item-doc-est-cex.nro-docto    = item-doc-est.nro-docto
                  and item-doc-est-cex.cod-emitente = item-doc-est.cod-emitente
                  and item-doc-est-cex.nat-operacao = item-doc-est.nat-operacao
                  and item-doc-est-cex.sequencia    = item-doc-est.sequencia no-lock
                use-index codigo BREAK BY item-doc-est-cex.cod-desp:

                for first desp-imp fields( cod-desp  inc-val-frete  inc-val-embal  tipo
                                           inc-val-seguro  inc-val-outras-desp  descricao char-1)
                    where desp-imp.cod-desp = item-doc-est-cex.cod-desp no-lock:
                end.
                if  not avail desp-imp then next.

                IF  i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:

                    /* Desconsidera a "despesa" dos impostos "IVA", pois s∆o considerados como impostos */
                    IF  item-doc-est-cex.cod-emitente-desp = param-imp.cdn-emit-iva
                    AND item-doc-est-cex.cod-desp          = param-imp.cdn-despes-iva THEN
                        NEXT.

                    /* C†lculo da taxa de estat°stica como imposto */
                    IF  i-pais-impto-usuario = 2 THEN DO:
                        if  item-doc-est-cex.cod-desp = param-imp.cdn-despes-tax-estatis
                        AND tt-param.i-desp-imposto   = 2 then do: /*Imposto*/
                            /*assign vl-est-reali-det = item-doc-est-cex.val-desp.*/

                            CREATE tt-impto-internac.
                            ASSIGN tt-impto-internac.embarque                 = embarque-imp.embarque
                                   tt-impto-internac.cod-estabel              = embarque-imp.cod-estabel
                                   tt-impto-internac.num-seq                  = item-doc-est.sequencia
                                   tt-impto-internac.cdn-imposto              = item-doc-est-cex.cod-desp /* Utiliza o codigo da despesa */
                                   tt-impto-internac.descricao                = desp-imp.descricao
                                   tt-impto-internac.val-impto-moeda-relat    = item-doc-est-cex.val-desp
                                   tt-impto-internac.val-impto-moeda-relat-mo = tt-impto-internac.val-impto-moeda-relat-mo + ((item-doc-est-cex.val-desp * item-doc-est-cex.cotacao) / b-docum-est-aux.cotacao-dia)
                                   tt-impto-internac.mo-impto-moeda-relat     = b-docum-est-aux.mo-codigo.

                            if  tt-param.moeda <> item-doc-est-cex.mo-codigo THEN DO:

                                IF tt-param.l-considera-cot-docto THEN DO:
                                    IF tt-param.moeda = docum-est.mo-codigo THEN DO:
                                        ASSIGN tt-impto-internac.val-impto-moeda-relat =  (tt-impto-internac.val-impto-moeda-relat * item-doc-est-cex.cotacao) / docum-est.cotacao-dia.

                                    END.
                                    ELSE
                                        run converte-moeda-data (input-output tt-impto-internac.val-impto-moeda-relat,
                                                                 input item-doc-est-cex.mo-codigo,
                                                                 INPUT item-doc-est-cex.dat-cotac).

                                END.
                                ELSE DO:
                                    run converte-moeda (input-output tt-impto-internac.val-impto-moeda-relat,
                                                        input item-doc-est-cex.mo-codigo).
                                END.

                            END.

                            /* Desconsidera como despesa */
                            NEXT.
                        END.
                    END.
                END.

                /* II e II2 - REALIZADO */
                if  item-doc-est-cex.cod-desp = i-cod-desp-ii and
                    tt-param.i-desp-imposto = 1 then DO: /*Despesa*/
                    assign vl-ii2-reali-det  = item-doc-est-cex.val-desp.

                    IF i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
                       ASSIGN vl-ii2-reali-det-mo = (item-doc-est-cex.val-desp * item-doc-est-cex.cotacao) / b-docum-est-aux.cotacao-dia
                              mo-ii2-reali-det    = b-docum-est-aux.mo-codigo.
                    END.

                END.

                if  item-doc-est-cex.cod-desp = i-cod-desp-ii and
                    tt-param.i-desp-imposto = 2 then /*Imposto*/ DO:

                    IF  i-pais-impto-usuario = 1 /* Brasil */ THEN
                        assign vl-ii-reali-det = item-doc-est-cex.val-desp.
                    ELSE DO: /* Internacional */
                        CREATE tt-impto-internac.
                        ASSIGN tt-impto-internac.embarque                 = embarque-imp.embarque
                               tt-impto-internac.cod-estabel              = embarque-imp.cod-estabel
                               tt-impto-internac.num-seq                  = item-doc-est.sequencia
                               tt-impto-internac.cdn-imposto              = item-doc-est-cex.cod-desp /* Utiliza o codigo da despesa */
                               tt-impto-internac.descricao                = desp-imp.descricao
                               tt-impto-internac.val-impto-moeda-relat    = item-doc-est-cex.val-desp
                               tt-impto-internac.val-impto-moeda-relat-mo = tt-impto-internac.val-impto-moeda-relat-mo + ((item-doc-est-cex.val-desp * item-doc-est-cex.cotacao) / b-docum-est-aux.cotacao-dia)
                               tt-impto-internac.mo-impto-moeda-relat     = b-docum-est-aux.mo-codigo.

                        if  tt-param.moeda <> item-doc-est-cex.mo-codigo THEN DO:
                            IF tt-param.l-considera-cot-docto THEN DO:
                                IF tt-param.moeda = docum-est.mo-codigo THEN DO:
                                    ASSIGN tt-impto-internac.val-impto-moeda-relat =  (tt-impto-internac.val-impto-moeda-relat * item-doc-est-cex.cotacao) / docum-est.cotacao-dia.

                                END.
                                ELSE
                                    run converte-moeda-data (input-output tt-impto-internac.val-impto-moeda-relat,
                                                             input item-doc-est-cex.mo-codigo,
                                                             INPUT item-doc-est-cex.dat-cotac).

                            END.
                            ELSE DO:
                                run converte-moeda (input-output tt-impto-internac.val-impto-moeda-relat,
                                                    input item-doc-est-cex.mo-codigo).
                            END.
                        END.

                        /* Desconsidera como despesa */
                        NEXT.
                    END.
                END.

                FOR FIRST desp-embarque FIELDS(descricao val-desp mo-codigo) NO-LOCK
                    WHERE desp-embarque.cod-estabel = embarque-imp.cod-estab
                      AND desp-embarque.embarque = embarque-imp.embarque
                      AND desp-embarque.cod-desp = item-doc-est-cex.cod-desp:
                END.

                &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
                    IF  param-imp.cdn-despes-impto-ipi    = item-doc-est-cex.cod-desp
                    OR  param-imp.cdn-despes-impto-icms   = item-doc-est-cex.cod-desp
                    OR  param-imp.cdn-despes-impto-pis    = item-doc-est-cex.cod-desp
                    OR  param-imp.cdn-despes-impto-cofins = item-doc-est-cex.cod-desp     THEN
                        NEXT.
                &ELSE
                    IF  SUBSTRING(desp-imp.descricao,1,3) = "IPI"
                    OR  SUBSTRING(desp-imp.descricao,1,4) = "ICMS"
                    OR  SUBSTRING(desp-imp.descricao,1,3) = "PIS"
                    OR  SUBSTRING(desp-imp.descricao,1,6) = "COFINS" THEN
                        NEXT.
                &ENDIF

                IF i-pais-impto-usuario            <> 1   AND
                   tt-param.l-desc-desp-item       =  YES AND
                   substring(desp-imp.char-1,45,1) =  "Y" THEN NEXT.

                /* Outras Despesas */
                if  desp-imp.inc-val-frete then
                    assign vl-despesa-frete = item-doc-est-cex.val-desp.
                if  desp-imp.inc-val-embal then
                    assign vl-despesa-embalagem = item-doc-est-cex.val-desp.
                if  desp-imp.inc-val-seguro then
                    assign vl-despesa-seguro = item-doc-est-cex.val-desp.
                if  desp-imp.inc-val-outras-desp then
                    assign vl-despesa-outras  = item-doc-est-cex.val-desp.

                if  desp-imp.cod-desp <> i-cod-desp-ii
                &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
                AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-ipi
                AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-icms
                AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-pis
                AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-cofins
                &ENDIF
                then do:

                    find first tt-detalha-despesa
                         where tt-detalha-despesa.embarque     = embarque-imp.embarque
                           and tt-detalha-despesa.cod-estabel  = embarque-imp.cod-estabel
                           and tt-detalha-despesa.numero-ordem = ordem-compra.numero-ordem
                           and tt-detalha-despesa.cod-despesa  = desp-imp.cod-desp
                           AND tt-detalha-despesa.sequencia    = item-doc-est.sequencia no-lock no-error.
                    if not avail tt-detalha-despesa then do:
                        create tt-detalha-despesa.
                        assign tt-detalha-despesa.embarque     = embarque-imp.embarque
                               tt-detalha-despesa.cod-estabel  = embarque-imp.cod-estabel
                               tt-detalha-despesa.numero-ordem = ordem-compra.numero-ordem
                               tt-detalha-despesa.nro-docto    = item-doc-est.nro-docto
                               tt-detalha-despesa.cod-despesa  = desp-imp.cod-desp
                               tt-detalha-despesa.desc-despesa = IF AVAIL desp-embarque AND desp-embarque.descricao <> "":U THEN desp-embarque.descricao ELSE desp-imp.descricao
                               tt-detalha-despesa.situacao     = p-situacao
                               tt-detalha-despesa.it-codigo    = item-doc-est.it-codigo
                               tt-detalha-despesa.sequencia    = item-doc-est.sequencia.
                    END.

                        if  tt-param.i-custo-item = 1 /*Unitario*/ THEN DO:
                            assign tt-detalha-despesa.vl-des-rea = item-doc-est-cex.val-desp / item-doc-est.quantidade
                                   tot-despesa-rea               = tot-despesa-rea +
                                                                   (item-doc-est-cex.val-desp / item-doc-est.quantidade)
                                   de-despesa-total              = de-despesa-total + item-doc-est-cex.val-desp.

                            IF LAST (item-doc-est-cex.cod-desp) THEN DO:
                                IF (de-despesa-total / tt-detalha-item.quantidade) > tot-despesa-rea THEN DO:
                                    ASSIGN de-residuo = (de-despesa-total / tt-detalha-item.quantidade) - tot-despesa-rea
                                           tt-detalha-despesa.vl-des-rea = tt-detalha-despesa.vl-des-rea + de-residuo
                                           tot-despesa-rea = tot-despesa-rea + de-residuo.

                                END.
                            END.
                        END.
                        ELSE
                            assign tt-detalha-despesa.sequencia   = item-doc-est.sequencia
                                   tt-detalha-despesa.vl-des-rea  = item-doc-est-cex.val-desp
                                   tot-despesa-rea                = tot-despesa-rea
                                                                   + item-doc-est-cex.val-desp.

                    /*Moeda Converte Realizado*/
                    assign var-moeda-conv-rea = item-doc-est-cex.mo-codigo.

                    if  tt-param.moeda <> var-moeda-conv-rea THEN
                        run converte-moeda (input-output tt-detalha-despesa.vl-des-rea,
                                            input var-moeda-conv-rea).
                end.

                if not avail tt-detalha-despesa then do:
                    find first tt-detalha-despesa
                         where tt-detalha-despesa.embarque     = embarque-imp.embarque
                           and tt-detalha-despesa.cod-estabel  = embarque-imp.cod-estabel
                           and tt-detalha-despesa.numero-ordem = ordem-compra.numero-ordem
                           and tt-detalha-despesa.nro-docto    = item-doc-est.nro-docto
                           and tt-detalha-despesa.cod-despesa  = desp-imp.cod-desp no-lock no-error.
                    if  not avail tt-detalha-despesa then do:
                        create tt-detalha-despesa.
                        assign tt-detalha-despesa.embarque     = embarque-imp.embarque
                               tt-detalha-despesa.cod-estabel  = embarque-imp.cod-estabel
                               tt-detalha-despesa.numero-ordem = ordem-compra.numero-ordem
                               tt-detalha-despesa.nro-docto    = item-doc-est.nro-docto
                               tt-detalha-despesa.cod-despesa  = desp-imp.cod-desp
                               tt-detalha-despesa.desc-despesa = IF AVAIL desp-embarque AND desp-embarque.descricao <> "":U THEN desp-embarque.descricao ELSE desp-imp.descricao
                               tt-detalha-despesa.situacao     = p-situacao.
                               tt-detalha-despesa.sequencia    = item-doc-est.sequencia.
                    end.
                end.

                assign var-moeda-conv-rea = item-doc-est-cex.mo-codigo.

                IF i-pais-impto-usuario <> 1 THEN DO:
                    ASSIGN var-cot-conv-rea = item-doc-est-cex.cotacao
                           var-dat-conv-rea = item-doc-est-cex.dat-cotac.

                    RUN pi-busca-cotacao-despesa (INPUT item-doc-est-cex.cod-emitente-desp,
                                                  INPUT item-doc-est-cex.cod-desp,
                                                  OUTPUT dt-cotac-desp,
                                                  OUTPUT de-cotac-desp,
                                                  OUTPUT i-mo-codigo-desp).
                END.

                /*Total do Embarque*/
                if  desp-imp.cod-desp <> i-cod-desp-ii
                &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
                AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-ipi
                AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-icms
                AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-pis
                AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-cofins
                &ENDIF
                then
                    assign tt-detalha-item.vl-des-rea-total = tt-detalha-item.vl-des-rea-total
                                                            + item-doc-est-cex.val-desp.

                /*Sem NF complementar - Realizado*/
                IF  desp-imp.cod-desp <> i-cod-desp-ii
                &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
                AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-ipi
                AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-icms
                AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-pis
                AND desp-imp.cod-desp <> param-imp.cdn-despes-impto-cofins
                &ENDIF
                THEN DO:
                    ASSIGN de-val-desp-aux = item-doc-est-cex.val-desp.

                    IF i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
                        ASSIGN de-val-desp-aux-mo = de-val-desp-aux.
                        IF AVAIL desp-embarque
                        AND item-doc-est-cex.mo-codigo <> desp-embarque.mo-codigo
                        AND desp-embarque.mo-codigo <> b-docum-est-aux.mo-codigo THEN DO:

                            run cdp/cd0812.p (input  item-doc-est-cex.mo-codigo, /*moeda origem*/
                                              input  desp-embarque.mo-codigo,    /*moeda destino*/
                                              input  de-val-desp-aux-mo,         /*valor origem*/
                                              input  dt-cotac-desp,              /*data conversao*/
                                              output de-val-desp-aux-mo).        /*valor destino*/
                        END.
                    END.

                    IF tt-param.moeda <> var-moeda-conv-rea THEN DO:
                        IF i-pais-impto-usuario <> 1 /* Brasil */ AND tt-param.l-considera-cot-docto THEN DO:
                            IF tt-param.moeda = i-mo-codigo-desp THEN DO:
                                ASSIGN de-val-desp-aux = de-val-desp-aux / de-cotac-desp.
                            END.
                            ELSE DO:
                                run converte-moeda-data (input-output de-val-desp-aux,
                                                         input 0,
                                                         INPUT dt-cotac-desp).
                            END.
                        END.
                        ELSE
                            RUN converte-moeda (INPUT-OUTPUT de-val-desp-aux,
                                                INPUT var-moeda-conv-rea).
                    END.

                    for first tt-detalha-despesa-aux
                        where tt-detalha-despesa-aux.embarque    = embarque-imp.embarque
                          and tt-detalha-despesa-aux.cod-estabel = embarque-imp.cod-estabel
                          and tt-detalha-despesa-aux.cod-despesa = item-doc-est-cex.cod-desp no-lock
                          use-index ch-codigo:
                    end.
                    if not avail tt-detalha-despesa-aux then do:

                        CREATE tt-detalha-despesa-aux.
                        ASSIGN tt-detalha-despesa-aux.embarque     = embarque-imp.embarque
                               tt-detalha-despesa-aux.cod-estabel  = embarque-imp.cod-estabel
                               tt-detalha-despesa-aux.cod-despesa  = desp-imp.cod-desp
                               tt-detalha-despesa-aux.desc-despesa = IF AVAIL desp-embarque AND desp-embarque.descricao <> "":U THEN desp-embarque.descricao ELSE desp-imp.descricao
                                tt-detalha-despesa-aux.vl-des-rea  = de-val-desp-aux
                                tt-detalha-despesa-aux.sequencia   = item-doc-est-cex.sequencia
                                tt-detalha-despesa-aux.situacao    = p-situacao.
                    END.
                    ELSE DO:
                        ASSIGN tt-detalha-despesa-aux.vl-des-rea = tt-detalha-despesa-aux.vl-des-rea + de-val-desp-aux.
                    END.
                    ASSIGN de-val-desp-aux-rea = de-val-desp-aux-rea + de-val-desp-aux.

                    IF i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:

                        IF AVAIL desp-embarque AND desp-embarque.mo-codigo <> b-docum-est-aux.mo-codigo THEN
                           ASSIGN tt-detalha-despesa-aux.vl-des-rea-mo = tt-detalha-despesa-aux.vl-des-rea-mo + de-val-desp-aux-mo
                                  tt-detalha-despesa-aux.moeda-mo      = desp-embarque.mo-codigo.
                        ELSE DO:
                            ASSIGN tt-detalha-despesa-aux.vl-des-rea-mo = tt-detalha-despesa-aux.vl-des-rea-mo + (de-val-desp-aux-mo * item-doc-est-cex.cotacao) / de-cotac-desp
                                   tt-detalha-despesa-aux.moeda-mo      = b-docum-est-aux.mo-codigo.
                        END.
                    END.
                END.
            end.

            assign var-preco-item-rea   = item-doc-est.preco-unit[1] * item-doc-est.qt-do-forn
                   var-valor-ipi-rea    = item-doc-est.valor-ipi[1]
                   var-valor-icm-rea    = item-doc-est.valor-icm[1]
                   var-valor-pis-rea    = &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
                                              item-doc-est.valor-pis
                                          &ELSE
                                              DEC(SUBSTRING(item-doc-est.CHAR-2,41,14)) &ENDIF
                   var-valor-cofins-rea = &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN
                                              item-doc-est.val-cofins
                                          &ELSE
                                              DEC(SUBSTRING(item-doc-est.CHAR-2,103,14)) &ENDIF.
            /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-820) */
            IF l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                    ASSIGN var-valor-cbs-rea     = 0
                           var-valor-ibs-uf-rea  = 0
                           var-valor-ibs-mun-rea = 0
                           var-valor-is-rea      = 0.

                FOR EACH item-doc-est-tribut NO-LOCK
                   WHERE item-doc-est-tribut.cod-serie-docto  = item-doc-est.serie-docto
                   AND   item-doc-est-tribut.cod-num-docto    = item-doc-est.nro-docto
                   AND   item-doc-est-tribut.cdn-emitente     = item-doc-est.cod-emitente
                   AND   item-doc-est-tribut.cod-natur-operac = item-doc-est.nat-operacao
                   AND   item-doc-est-tribut.num-seq          = item-doc-est.sequencia:

                    IF  (item-doc-est-tribut.nom-trib <> "CBS":U
                    AND  item-doc-est-tribut.nom-trib <> "IBS UF":U
                   AND  item-doc-est-tribut.nom-trib <> "IBS MUN":U
                   AND  item-doc-est-tribut.nom-trib <> "IS":U)
                    OR  (item-doc-est-tribut.cod-campo <> "VALOR":U
                    AND  item-doc-est-tribut.cod-campo <> "ALIQUOTA":U) THEN NEXT.

                    CASE item-doc-est-tribut.cod-campo:
                        WHEN "VALOR":U THEN DO:
                            IF item-doc-est-tribut.nom-trib = "CBS":U THEN
                                ASSIGN var-valor-cbs-rea = DEC(item-doc-est-tribut.cod-conteudo).
                            IF item-doc-est-tribut.nom-trib = "IBS UF":U THEN
                                ASSIGN var-valor-ibs-uf-rea = DEC(item-doc-est-tribut.cod-conteudo).
                            IF item-doc-est-tribut.nom-trib = "IBS MUN":U THEN
                                ASSIGN var-valor-ibs-mun-rea = DEC(item-doc-est-tribut.cod-conteudo).
                            IF item-doc-est-tribut.nom-trib = "IS":U THEN
                                ASSIGN var-valor-is-rea = DEC(item-doc-est-tribut.cod-conteudo).    
                        END.
                        WHEN "ALIQUOTA":U THEN DO:
                            IF item-doc-est-tribut.nom-trib = "CBS":U THEN
                                ASSIGN tt-detalha-item.aliquota-cbs = DEC(item-doc-est-tribut.cod-conteudo).
                            IF item-doc-est-tribut.nom-trib = "IBS UF":U THEN
                                ASSIGN tt-detalha-item.aliquota-ibs-uf = DEC(item-doc-est-tribut.cod-conteudo).
                            IF item-doc-est-tribut.nom-trib = "IBS MUN":U THEN
                                ASSIGN tt-detalha-item.aliquota-ibs-mun = DEC(item-doc-est-tribut.cod-conteudo).
                            IF item-doc-est-tribut.nom-trib = "IS":U THEN
                                ASSIGN tt-detalha-item.aliquota-is = DEC(item-doc-est-tribut.cod-conteudo).
                        END.
                    END CASE.
                END.

                ASSIGN tt-detalha-item.vl-cbs-rea    = IF tt-param.i-custo-item = 2 /* Total */ THEN var-valor-cbs-rea ELSE var-valor-cbs-rea / item-doc-est.quantidade
                       tt-detalha-item.vl-ibs-uf-rea = IF tt-param.i-custo-item = 2 /* Total */ THEN var-valor-ibs-uf-rea ELSE var-valor-ibs-uf-rea / item-doc-est.quantidade
                       tt-detalha-item.vl-ibs-mun-rea = IF tt-param.i-custo-item = 2 THEN var-valor-ibs-mun-rea ELSE var-valor-ibs-mun-rea / item-doc-est.quantidade
                       tt-detalha-item.vl-is-rea      = IF tt-param.i-custo-item = 2 THEN var-valor-is-rea      ELSE var-valor-is-rea / item-doc-est.quantidade.

                ASSIGN tt-detalha-item.vl-cbs-rea-total    = var-valor-cbs-rea
                       tt-detalha-item.vl-ibs-uf-rea-total = var-valor-ibs-uf-rea
                       tt-detalha-item.vl-ibs-mun-rea-total = var-valor-ibs-mun-rea
                       tt-detalha-item.vl-is-rea-total      = var-valor-is-rea.
            END.
            /* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-820) */

            if tt-param.i-custo-item = 1 then do:
                /*Unitario*/
                assign vl-ii2-reali-det     = vl-ii2-reali-det     / item-doc-est.quantidade
                       vl-ii-reali-det      = vl-ii-reali-det      / item-doc-est.quantidade
                       var-valor-ipi-rea    = var-valor-ipi-rea    / item-doc-est.quantidade
                       var-valor-icm-rea    = var-valor-icm-rea    / item-doc-est.quantidade
                       var-valor-pis-rea    = var-valor-pis-rea    / item-doc-est.quantidade
                       var-valor-cofins-rea = var-valor-cofins-rea / item-doc-est.quantidade
                       var-preco-item-rea   = var-preco-item-rea   / item-doc-est.quantidade.
            END.

            IF i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
                ASSIGN tt-detalha-item.mo-ger-mercado-rea    = b-docum-est-aux.mo-codigo
                       tt-detalha-item.vl-ger-mercado-rea-mo = item-doc-est.preco-unit-me * item-doc-est.qt-do-forn.
            END.

            /*tt-detalha-item REALIZADO - NOTA PRINCIPAL*/
            assign tt-detalha-item.vl-mercado-rea = var-preco-item-rea /*Valor Mercado Realizado*/
                   tt-detalha-item.vl-ii-rea      = vl-ii-reali-det
                   tt-detalha-item.vl-ipi-rea     = var-valor-ipi-rea
                   tt-detalha-item.vl-icms-rea    = var-valor-icm-rea
                   tt-detalha-item.vl-pis-rea     = var-valor-pis-rea
                   tt-detalha-item.vl-cofins-rea  = var-valor-cofins-rea
                   tt-detalha-item.vl-tot-imp-rea = vl-ii-reali-det /*Total Imposto  II + IPI + ICMS*/ + var-valor-ipi-rea + var-valor-icm-rea + var-valor-pis-rea + var-valor-cofins-rea.

            /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-820) */
            IF l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                IF tt-param.i-custo-item = 1 /* Unitario */ THEN
                    ASSIGN var-valor-cbs-rea     = var-valor-cbs-rea    / item-doc-est.quantidade
                           var-valor-ibs-uf-rea  = var-valor-ibs-uf-rea / item-doc-est.quantidade
                           var-valor-ibs-mun-rea = var-valor-ibs-mun-rea / item-doc-est.quantidade
                           var-valor-is-rea      = var-valor-is-rea / item-doc-est.quantidade.

                ASSIGN tt-detalha-item.vl-tot-imp-rea = vl-ii-reali-det /*Total Imposto  II + IPI + ICMS*/ + var-valor-ipi-rea + var-valor-cbs-rea + var-valor-ibs-uf-rea + var-valor-ibs-mun-rea + var-valor-is-rea.
            END.
            /* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-820) */

            ASSIGN tt-detalha-item.vl-ii2-rea                    = vl-ii2-reali-det
                   tt-detalha-item.vl-des-rea                    = tot-despesa-rea
                   tt-detalha-item.vl-tot-des-rea                = vl-ii2-reali-det + tot-despesa-rea
                   tt-detalha-item.vl-tot-imp-des-rea            = tt-detalha-item.vl-tot-imp-rea + tt-detalha-item.vl-tot-des-rea
                   tt-detalha-item.vl-tot-com-ipi-icms-rea       = tt-detalha-item.vl-tot-com-ipi-icms-rea + tt-detalha-item.vl-mercado-rea
                   tt-detalha-item.vl-tot-sem-ipi-icms-rea       = tt-detalha-item.vl-tot-com-ipi-icms-rea - var-valor-ipi-rea - var-valor-icm-rea - var-valor-pis-rea - var-valor-cofins-rea
                   tt-detalha-item.vl-mercado-rea-total          = if tt-param.i-custo-item = 2 then var-preco-item-rea else var-preco-item-rea * item-doc-est.quantidade
                   tt-detalha-item.vl-ii-rea-total               = if tt-param.i-custo-item = 2 then vl-ii-reali-det else vl-ii-reali-det * item-doc-est.quantidade
                   tt-detalha-item.vl-ii2-rea-total              = if tt-param.i-custo-item = 2 then vl-ii2-reali-det else vl-ii2-reali-det * item-doc-est.quantidade
                   tt-detalha-item.vl-ipi-rea-total              = if tt-param.i-custo-item = 2 then var-valor-ipi-rea else var-valor-ipi-rea * item-doc-est.quantidade
                   tt-detalha-item.vl-icms-rea-total             = if tt-param.i-custo-item = 2 then var-valor-icm-rea else var-valor-icm-rea * item-doc-est.quantidade
                   tt-detalha-item.vl-pis-rea-total              = if tt-param.i-custo-item = 2 then var-valor-pis-rea else var-valor-pis-rea * item-doc-est.quantidade
                   tt-detalha-item.vl-cofins-rea-total           = if tt-param.i-custo-item = 2 then var-valor-cofins-rea else var-valor-cofins-rea * item-doc-est.quantidade
                   tt-detalha-item.vl-tot-imp-rea-total          = if tt-param.i-custo-item = 2 then tt-detalha-item.vl-tot-imp-rea else tt-detalha-item.vl-tot-imp-rea * item-doc-est.quantidade
                   tt-detalha-item.vl-tot-des-rea-total          = if tt-param.i-custo-item = 1 then tt-detalha-item.vl-des-rea-total + tt-detalha-item.vl-ii2-rea-total else tt-detalha-item.vl-tot-des-rea
                   tt-detalha-item.vl-tot-imp-des-rea-total      = if tt-param.i-custo-item = 1 then tt-detalha-item.vl-tot-imp-rea-total + tt-detalha-item.vl-tot-des-rea-total else tt-detalha-item.vl-tot-imp-des-rea
                   tt-detalha-item.vl-tot-com-ipi-icms-rea-total = tt-detalha-item.vl-mercado-rea-total + tt-detalha-item.vl-tot-imp-des-rea-total
                   tt-detalha-item.vl-tot-sem-ipi-icms-rea-total = tt-detalha-item.vl-tot-com-ipi-icms-rea-total - tt-detalha-item.vl-ipi-rea-total - tt-detalha-item.vl-icms-rea-total - tt-detalha-item.vl-pis-rea-total - tt-detalha-item.vl-cofins-rea-total.

            IF i-pais-impto-usuario <> 1 /* Brasil */ THEN
                ASSIGN tt-detalha-item.vl-ger-ii2-rea-mo = vl-ii2-reali-det-mo
                        tt-detalha-item.mo-ii2-rea        = mo-ii2-reali-det.
            /****REALIZADO-FIM*/

            /*Convers∆o Oráado*/

            IF tt-param.moeda <> var-moeda-conv-orc THEN DO:
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-ii-orc,
                                    input var-moeda-conv-orc).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-ipi-orc,
                                    input var-moeda-conv-orc).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-icms-orc,
                                    input var-moeda-conv-orc).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-pis-orc,
                                    input var-moeda-conv-orc).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-cofins-orc,
                                    input var-moeda-conv-orc).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-tot-imp-orc,
                                    input var-moeda-conv-orc).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-ii2-orc,
                                    input var-moeda-conv-orc).
                run converte-moeda (input-output tt-detalha-item.vl-des-orc,
                                    input var-moeda-conv-orc).
                run converte-moeda (input-output tt-detalha-item.vl-des-orc-total,
                                    input var-moeda-conv-orc).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-tot-des-orc-total,
                                    input var-moeda-conv-orc).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-tot-imp-des-orc-total,
                                    input var-moeda-conv-orc).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-tot-com-ipi-icms-orc,
                                    input var-moeda-conv-orc).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-tot-sem-ipi-icms-orc-total,
                                    input var-moeda-conv-orc).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-ii2-orc-aux,
                                    input var-moeda-conv-orc).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-ii-orc-aux,
                                    input var-moeda-conv-orc).
            end.

            /*C†lculo do valor total do oráado ap¢s valores convertidos*/
            ASSIGN tt-detalha-item.vl-tot-des-orc     = tt-detalha-item.vl-ii2-orc /*Total Despesa II2 + Despesa*/ + de-tot-des-orc-aux /*tot-despesa-orc*/
                   tt-detalha-item.vl-tot-imp-des-orc = tt-detalha-item.vl-tot-imp-orc /*Total Imposto + Depesa*/ + tt-detalha-item.vl-tot-des-orc.
            ASSIGN tt-detalha-item.vl-tot-com-ipi-icms-orc-total = tt-detalha-item.vl-tot-imp-orc + tt-detalha-item.vl-mercado-orc + tt-detalha-item.vl-tot-des-orc.

            ASSIGN tt-detalha-item.vl-tot-sem-ipi-icms-orc-total = tt-detalha-item.vl-tot-com-ipi-icms-orc-total - tt-detalha-item.vl-tot-imp-orc.

            /* Convers∆o Realizado */
            if tt-param.moeda <> var-moeda-conv-rea then do:

                IF i-pais-impto-usuario <> 1 /* Brasil */
                AND tt-param.l-considera-cot-docto
                AND AVAIL docum-est THEN DO:

                    IF tt-param.moeda = docum-est.mo-codigo THEN DO:
                        ASSIGN tt-detalha-item.vl-mercado-rea       = (tt-detalha-item.vl-mercado-rea * var-cot-conv-rea) / docum-est.cotacao-dia
                               tt-detalha-item.vl-mercado-rea-total = (tt-detalha-item.vl-mercado-rea-total * var-cot-conv-rea) / docum-est.cotacao-dia
                               tt-detalha-item.vl-ii2-rea           = (tt-detalha-item.vl-ii2-rea * var-cot-conv-rea) / docum-est.cotacao-dia
                               tt-detalha-item.vl-ii2-rea-total     = (tt-detalha-item.vl-ii2-rea-total * var-cot-conv-rea) / docum-est.cotacao-dia.
                    END.
                    ELSE DO:
                        RUN converte-moeda-data (INPUT-OUTPUT tt-detalha-item.vl-mercado-rea,
                                                 input var-moeda-conv-rea,
                                                 INPUT var-dat-conv-rea).
                        RUN converte-moeda-data (INPUT-OUTPUT tt-detalha-item.vl-mercado-rea-total,
                                                 input var-moeda-conv-rea,
                                                 INPUT var-dat-conv-rea).
                        RUN converte-moeda-data (INPUT-OUTPUT tt-detalha-item.vl-ii2-rea,
                                                 input var-moeda-conv-rea,
                                                 INPUT var-dat-conv-rea).
                        RUN converte-moeda-data (INPUT-OUTPUT tt-detalha-item.vl-ii2-rea-total,
                                                 input var-moeda-conv-rea,
                                                 INPUT var-dat-conv-rea).
                    END.

                END.
                ELSE DO:
                    RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-mercado-rea,
                                        input var-moeda-conv-rea).
                    RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-mercado-rea-total,
                                        input var-moeda-conv-rea).
                    RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-ii2-rea,
                                        input var-moeda-conv-rea).
                    RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-ii2-rea-total,
                                        input var-moeda-conv-rea).

                END.

                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-ii-rea,
                                    input var-moeda-conv-rea).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-ii-rea-total,
                                    input var-moeda-conv-rea).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-ipi-rea,
                                    input var-moeda-conv-rea).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-ipi-rea-total,
                                    input var-moeda-conv-rea).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-icms-rea,
                                    input var-moeda-conv-rea).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-icms-rea-total,
                                    input var-moeda-conv-rea).
                ASSIGN de-vl-pis-rea = tt-detalha-item.vl-pis-rea.
                RUN converte-moeda (INPUT-OUTPUT de-vl-pis-rea,
                                    input var-moeda-conv-rea).
                ASSIGN de-vl-pis-rea-total = tt-detalha-item.vl-pis-rea-total.
                RUN converte-moeda (INPUT-OUTPUT de-vl-pis-rea-total,
                                    input var-moeda-conv-rea).
                ASSIGN de-vl-cofins-rea = tt-detalha-item.vl-cofins-rea.
                RUN converte-moeda (INPUT-OUTPUT de-vl-cofins-rea,
                                    input var-moeda-conv-rea).
                ASSIGN de-vl-cofins-rea-total = tt-detalha-item.vl-cofins-rea-total.
                RUN converte-moeda (INPUT-OUTPUT de-vl-cofins-rea-total,
                                    input var-moeda-conv-rea).
                ASSIGN tt-detalha-item.vl-pis-rea-total    = de-vl-pis-rea-total
                       tt-detalha-item.vl-pis-rea          = de-vl-pis-rea
                       tt-detalha-item.vl-cofins-rea-total = de-vl-cofins-rea-total
                       tt-detalha-item.vl-cofins-rea       = de-vl-cofins-rea.

                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-tot-imp-rea,
                                    input var-moeda-conv-rea).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-tot-imp-rea-total,
                                    input var-moeda-conv-rea).
                run converte-moeda (input-output tt-detalha-item.vl-des-rea,
                                    input var-moeda-conv-rea).
                run converte-moeda (input-output tt-detalha-item.vl-des-rea-total,
                                    input var-moeda-conv-rea).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-tot-des-rea,
                                    input var-moeda-conv-rea).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-tot-des-rea-total,
                                    input var-moeda-conv-rea).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-tot-imp-des-rea,
                                    input var-moeda-conv-rea).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-tot-imp-des-rea-total,
                                    input var-moeda-conv-rea).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-tot-com-ipi-icms-rea,
                                    input var-moeda-conv-rea).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-tot-com-ipi-icms-rea-total,
                                    input var-moeda-conv-rea).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-tot-sem-ipi-icms-rea,
                                    input var-moeda-conv-rea).
                RUN converte-moeda (INPUT-OUTPUT tt-detalha-item.vl-tot-sem-ipi-icms-rea-total,
                                    input var-moeda-conv-rea).
                RUN converte-moeda (INPUT-OUTPUT vl-despesa-frete,
                                    input var-moeda-conv-rea).
                RUN converte-moeda (INPUT-OUTPUT vl-despesa-embalagem,
                                    input var-moeda-conv-rea).
                RUN converte-moeda (INPUT-OUTPUT vl-despesa-seguro,
                                    input var-moeda-conv-rea).
                RUN converte-moeda (INPUT-OUTPUT vl-despesa-outras,
                                    input var-moeda-conv-rea).
            END.

            IF i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
                ASSIGN var-valor-imp-int = 0.
                FOR EACH tt-impto-internac NO-LOCK
                   WHERE tt-impto-internac.embarque    = tt-detalha-item.embarque
                   AND   tt-impto-internac.cod-estabel = tt-detalha-item.cod-estabel
                   AND   tt-impto-internac.num-seq     = item-doc-est.sequencia:

                    ASSIGN var-valor-imp-int = var-valor-imp-int + tt-impto-internac.val-impto-moeda-relat.
                END.

                if tt-param.i-custo-item = 1 then
                    assign var-valor-imp-int = var-valor-imp-int / item-doc-est.quantidade.

                ASSIGN tt-detalha-item.vl-tot-imp-rea                = tt-detalha-item.vl-tot-imp-rea + var-valor-imp-int
                       tt-detalha-item.vl-tot-imp-des-rea            = tt-detalha-item.vl-tot-imp-des-rea + var-valor-imp-int
                       tt-detalha-item.vl-tot-com-ipi-icms-rea       = tt-detalha-item.vl-tot-com-ipi-icms-rea + var-valor-imp-int
                       tt-detalha-item.vl-tot-imp-rea-total          = if tt-param.i-custo-item = 2 then tt-detalha-item.vl-tot-imp-rea else tt-detalha-item.vl-tot-imp-rea * item-doc-est.quantidade
                       tt-detalha-item.vl-tot-imp-des-rea-total      = if tt-param.i-custo-item = 1 then tt-detalha-item.vl-tot-imp-rea-total + tt-detalha-item.vl-tot-des-rea-total else tt-detalha-item.vl-tot-imp-des-rea
                       tt-detalha-item.vl-tot-com-ipi-icms-rea-total = tt-detalha-item.vl-mercado-rea-total + tt-detalha-item.vl-tot-imp-des-rea-total.
            END.

            /* PERCENTUAL */
            assign tt-detalha-item.per-mercado-orc          = (tt-detalha-item.vl-mercado-orc / tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                   tt-detalha-item.per-mercado-rea          = (tt-detalha-item.vl-mercado-rea / tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                   tt-detalha-item.per-ii-orc               = (tt-detalha-item.vl-ii-orc / tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                   tt-detalha-item.per-ii-rea               = (tt-detalha-item.vl-ii-rea / tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                   tt-detalha-item.per-ipi-orc              = (tt-detalha-item.vl-ipi-orc / tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                   tt-detalha-item.per-icms-orc             = (tt-detalha-item.vl-icms-orc / tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                   tt-detalha-item.per-pis-orc              = (tt-detalha-item.vl-pis-orc / tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                   tt-detalha-item.per-cofins-orc           = (tt-detalha-item.vl-cofins-orc / tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                   tt-detalha-item.per-tot-imp-orc          = (tt-detalha-item.vl-tot-imp-orc / tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                   tt-detalha-item.per-tot-imp-rea          = (tt-detalha-item.vl-tot-imp-rea / tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                   tt-detalha-item.per-ii2-orc              = (tt-detalha-item.vl-ii2-orc / tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                   tt-detalha-item.per-ii2-rea              = (tt-detalha-item.vl-ii2-rea / tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                   tt-detalha-item.per-tot-des-orc          = (tt-detalha-item.vl-tot-des-orc / tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                   tt-detalha-item.per-tot-des-rea          = (tt-detalha-item.vl-tot-des-rea / tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                   tt-detalha-item.per-tot-imp-des-orc      = (tt-detalha-item.vl-tot-imp-des-orc / tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                   tt-detalha-item.per-tot-imp-des-rea      = (tt-detalha-item.vl-tot-imp-des-rea / tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                   tt-detalha-item.per-tot-com-ipi-icms-orc = (tt-detalha-item.vl-tot-com-ipi-icms-orc-total / tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                   tt-detalha-item.per-tot-com-ipi-icms-rea = (tt-detalha-item.vl-tot-com-ipi-icms-rea / tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                   tt-detalha-item.per-tot-sem-ipi-icms-orc = (tt-detalha-item.vl-tot-sem-ipi-icms-orc / tt-detalha-item.vl-tot-com-ipi-icms-orc-total) * 100
                   tt-detalha-item.per-tot-sem-ipi-icms-rea = (tt-detalha-item.vl-tot-sem-ipi-icms-rea / tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
            /* DESPESAS */
                   tt-detalha-item.vl-des-frete             = vl-despesa-frete
                   tt-detalha-item.vl-des-embalagem         = vl-despesa-embalagem
                   tt-detalha-item.vl-des-seguro            = vl-despesa-seguro
                   tt-detalha-item.vl-des-outras            = vl-despesa-outras
                   tt-detalha-item.vl-tot-despesa           = vl-despesa-frete + vl-despesa-embalagem + vl-despesa-seguro + vl-despesa-outras.

            assign vl-despesa-frete = 0.

            IF l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                ASSIGN tt-detalha-item.per-cbs-rea     = (tt-detalha-item.vl-cbs-rea-total / tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                       tt-detalha-item.per-ibs-uf-rea  = (tt-detalha-item.vl-ibs-uf-rea-total / tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                       tt-detalha-item.per-ibs-mun-rea = (tt-detalha-item.vl-ibs-mun-rea-total / tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100
                       tt-detalha-item.per-is-rea      = (tt-detalha-item.vl-is-rea-total / tt-detalha-item.vl-tot-com-ipi-icms-rea) * 100.
            END.
        END.
    END.

END PROCEDURE.

procedure busca-nf-complementar:
    define input parameter p-serie        like docum-est.serie-docto    no-undo.
    define input parameter p-nro-docto    like docum-est.nro-docto      no-undo.
    define input parameter p-cod-emitente like docum-est.cod-emitente   no-undo.
    define input parameter p-nat-operacao like docum-est.nat-operacao   no-undo.
    define input parameter p-embarque     like embarque-imp.embarque    no-undo.
    define input parameter p-cod-estabel  like embarque-imp.cod-estabel no-undo.

    for each rat-docum no-lock
        where rat-docum.nf-serie    = p-serie
          and rat-docum.nf-nro      = p-nro-docto
          and rat-docum.nf-emitente = p-cod-emitente
          and rat-docum.nf-nat-oper = p-nat-operacao
          use-index nf-docto:

        for each b-docum-est-aux fields( nro-docto  serie-docto  dt-emissao
                                         cod-emitente  nat-operacao cod-estabel tot-valor-me tot-valor mo-codigo idi-nf-simples-remes)
            where b-docum-est-aux.serie-docto = rat-docum.serie-docto
              and b-docum-est-aux.nro-docto = rat-docum.nro-docto
              and b-docum-est-aux.cod-emitente = rat-docum.cod-emitente
              and b-docum-est-aux.nat-operacao = rat-docum.nat-operacao NO-LOCK
            use-index documento:

            FOR FIRST b-item-doc-est WHERE
                      b-item-doc-est.serie-docto  = rat-docum.nf-serie    AND
                      b-item-doc-est.nro-docto    = rat-docum.nf-nro      AND
                      b-item-doc-est.cod-emitente = rat-docum.nf-emitente AND
                      b-item-doc-est.nat-operacao = rat-docum.nf-nat-oper NO-LOCK:
            END.

            FIND tt-nf-comp where
                 tt-nf-comp.embarque     = p-embarque    AND
                 tt-nf-comp.cod-estabel  = p-cod-estabel AND
                 tt-nf-comp.nr-nf-comp   = b-docum-est-aux.nro-docto AND
                 tt-nf-comp.dt-emis-comp = b-docum-est-aux.dt-emissao NO-ERROR.
            IF NOT AVAIL tt-nf-comp THEN DO:

                create tt-nf-comp.
                assign tt-nf-comp.embarque     = p-embarque
                       tt-nf-comp.cod-estabel  = p-cod-estabel
                       tt-nf-comp.nr-nf-comp   = b-docum-est-aux.nro-docto
                       tt-nf-comp.dt-emis-comp = b-docum-est-aux.dt-emissao
                       tt-nf-comp.moeda-mo     = b-docum-est-aux.mo-codigo
                       tt-nf-comp.tot-valor-mo = b-docum-est-aux.tot-valor-me.

                IF i-pais-impto-usuario = 1 /* Brasil */
                OR NOT tt-param.l-considera-cot-docto THEN DO:

                    IF i-pais-impto-usuario = 1 /* Brasil */ THEN
                        ASSIGN tt-nf-comp.tot-valor = b-docum-est-aux.tot-valor.
                    ELSE
                        ASSIGN tt-nf-comp.tot-valor = b-docum-est-aux.tot-valor-me.

                    if tt-param.moeda <> b-docum-est-aux.mo-codigo then
                        run converte-moeda (input-output tt-nf-comp.tot-valor,
                                            input b-docum-est-aux.mo-codigo).
                END.
                ELSE DO:
                    IF tt-param.moeda = b-docum-est-aux.mo-codigo THEN
                        ASSIGN tt-nf-comp.tot-valor = b-docum-est-aux.tot-valor-me.
                    ELSE DO:
                        ASSIGN tt-nf-comp.tot-valor = b-docum-est-aux.tot-valor.

                        IF tt-param.moeda <> 0 THEN DO:
                            FIND FIRST item-doc-est-cex OF b-docum-est-aux NO-LOCK NO-ERROR.
                            IF AVAIL item-doc-est-cex THEN
                                RUN converte-moeda-data (INPUT-OUTPUT tt-nf-comp.tot-valor,
                                                         INPUT 0, /* moeda origem */
                                                         INPUT item-doc-est-cex.dat-cotac).
                            ELSE
                                RUN converte-moeda-data (INPUT-OUTPUT tt-nf-comp.tot-valor,
                                                         INPUT 0, /* moeda origem */
                                                         INPUT b-docum-est-aux.dt-trans).
                        END.
                    END.
                END.

                if i-pais-impto-usuario <> 1 then do:
                    empty temp-table tt-impto-item-docto.

                    run getImptoItemDoctoByDocumEst IN h-boin759na (input rowid(b-docum-est-aux),
                                                                    input 0,
                                                                    output table tt-impto-item-docto).

                    for each tt-impto-item-docto:

                        IF tt-param.l-considera-cot-docto THEN DO:
                            IF tt-param.moeda = b-docum-est-aux.mo-codigo THEN
                                ASSIGN de-valor-imp-nf = tt-impto-item-docto.val-impto-merc-ext.
                            ELSE DO:
                                ASSIGN de-valor-imp-nf = tt-impto-item-docto.val-impto.

                                IF tt-param.moeda <> 0 THEN DO:
                                    FIND FIRST item-doc-est-cex OF b-docum-est-aux NO-LOCK NO-ERROR.
                                    IF AVAIL item-doc-est-cex THEN
                                        RUN converte-moeda-data (INPUT-OUTPUT de-valor-imp-nf,
                                                                 INPUT 0, /* moeda origem */
                                                                 INPUT item-doc-est-cex.dat-cotac).
                                    ELSE
                                        RUN converte-moeda-data (INPUT-OUTPUT de-valor-imp-nf,
                                                                 INPUT 0, /* moeda origem */
                                                                 INPUT b-docum-est-aux.dt-trans).
                                END.
                            END.
                        END.
                        ELSE DO:
                            ASSIGN de-valor-imp-nf = tt-impto-item-docto.val-impto-merc-ext.

                            IF tt-param.moeda <> b-docum-est-aux.mo-codigo THEN
                                RUN converte-moeda (INPUT-OUTPUT de-valor-imp-nf,
                                                    INPUT b-docum-est-aux.mo-codigo). /* moeda origem */
                        END.

                        assign tt-nf-comp.tot-imposto    = tt-nf-comp.tot-imposto + de-valor-imp-nf
                               tt-nf-comp.tot-imposto-mo = tt-nf-comp.tot-imposto-mo + tt-impto-item-docto.val-impto-merc-ext.
                    end.
                end.

                IF tt-param.excel THEN DO:
                    for first emitente fields( cod-emitente  nome-abrev)
                        where emitente.cod-emitente = b-docum-est-aux.cod-emitente no-lock:
                    END.

                    CREATE tt-documentos.
                    ASSIGN tt-documentos.cod-estabel     = p-cod-estabel
                           tt-documentos.embarque        = p-embarque
                           tt-documentos.cod-exportador  = tt-embarque-cabec.cod-emitente
                           tt-documentos.desc-exportador = tt-embarque-cabec.desc-emit
                           tt-documentos.nro-docto       = b-docum-est-aux.nro-docto
                           tt-documentos.serie-docto     = b-docum-est-aux.serie-docto
                           tt-documentos.nat-operacao    = b-docum-est-aux.nat-operacao
                           tt-documentos.cod-emitente    = b-docum-est-aux.cod-emitente
                           tt-documentos.desc-emit       = if avail emitente then emitente.nome-abrev else "":U
                           tt-documentos.dt-emissao      = b-docum-est-aux.dt-emissao.

                    IF b-docum-est-aux.idi-nf-simples-remes = 1 THEN DO:
                        /* "nota m∆e" */
                        {utp/ut-liter.i "Nota_M∆e"}
                    END.
                    ELSE
                        IF b-docum-est-aux.idi-nf-simples-remes = 2 THEN DO:
                        /* nota filha */
                        {utp/ut-liter.i "Nota_Filha"}
                    END.
                    ELSE
                        IF CAN-FIND(FIRST natur-oper
                                     WHERE natur-oper.nat-operacao = b-docum-est-aux.nat-operacao
                                     AND   natur-oper.nota-rateio) THEN DO:
                        {utp/ut-liter.i "Nota_Complementar"}
                        END.
                        ELSE DO:
                            IF CAN-FIND(FIRST item-doc-est
                                        WHERE item-doc-est.serie-docto  = b-docum-est-aux.serie-docto
                                        AND   item-doc-est.nro-docto    = b-docum-est-aux.nro-docto
                                        AND   item-doc-est.cod-emitente = b-docum-est-aux.cod-emitente
                                        AND   item-doc-est.nat-operacao = b-docum-est-aux.nat-operacao
                                        AND   item-doc-est.log-nota-ajust-import) THEN DO:
                                {utp/ut-liter.i "Nota_Ajuste"}
                            END.
                            ELSE DO:
                                {utp/ut-liter.i "Nota_Normal"}
                            END.
                        END.

                    ASSIGN tt-documentos.des-tipo-nota-imp = TRIM(RETURN-VALUE).
                END.
            END.
            RUN gera-valores (INPUT b-docum-est-aux.serie-docto,
                              INPUT b-docum-est-aux.nro-docto,
                              INPUT b-docum-est-aux.cod-emitente,
                              INPUT b-docum-est-aux.nat-operacao,
                              INPUT p-embarque,
                              INPUT b-docum-est-aux.cod-estabel,
                              INPUT 3). /*Nota Complementar*/
        end.
    end.
end procedure.


PROCEDURE pi-busca-nota-mae:

    DEF OUTPUT PARAM pr-rowid AS ROWID NO-UNDO.

    DEF BUFFER b-docum-est-mae           FOR docum-est.
    DEF BUFFER b-embarq-import-docto-mae FOR embarq-import-docto.
    DEF BUFFER b-embarque-imp-mae        FOR embarque-imp.

    DEF VAR l-sair        AS LOG  NO-UNDO.
    DEF VAR c-prox-embarq AS CHAR NO-UNDO.

    ASSIGN l-sair        = NO
           c-prox-embarq = b-docum-est-aux.embarque.

    REPEAT WHILE l-sair = NO:

        /* N∆o encontrou nota para o embarque relacionado */
        IF NOT CAN-FIND(FIRST b-embarq-import-docto-mae
                        WHERE b-embarq-import-docto-mae.cod-estab = b-docum-est-aux.cod-estabel
                        AND   b-embarq-import-docto-mae.cod-embarq = c-prox-embarq) THEN
           ASSIGN l-sair = YES.

        FOR EACH b-embarq-import-docto-mae FIELDS(cod-estab cod-embarq cod-ser-docto cod-docto cdn-emitente cod-natur-operac)
            WHERE b-embarq-import-docto-mae.cod-estab = b-docum-est-aux.cod-estabel
            AND   b-embarq-import-docto-mae.cod-embarq = c-prox-embarq NO-LOCK:

            /* verifica se Ç a nota m∆e */
            FOR FIRST b-docum-est-mae FIELDS(serie-docto nro-docto cod-emitente nat-operacao idi-nf-simples-remes embarque)
                WHERE b-docum-est-mae.serie-docto = b-embarq-import-docto-mae.cod-ser-docto
                AND   b-docum-est-mae.nro-docto = b-embarq-import-docto-mae.cod-docto
                AND   b-docum-est-mae.cod-emitente = b-embarq-import-docto-mae.cdn-emitente
                AND   b-docum-est-mae.nat-operacao = b-embarq-import-docto-mae.cod-natur-operac NO-LOCK:
            END.
            /* se for nota filha grava o embarque de origem para pr¢xima busca */
            IF b-docum-est-mae.idi-nf-simples-remes = 2 THEN DO:
                FOR FIRST b-embarque-imp-mae NO-LOCK
                    WHERE b-embarque-imp-mae.cod-estab = b-embarq-import-docto-mae.cod-estab
                    AND   b-embarque-imp-mae.embarque = c-prox-embarq:
                    ASSIGN c-prox-embarq = SUBSTRING(b-embarque-imp-mae.char-1,21,20).
                END.
            END.

            IF b-docum-est-mae.idi-nf-simples-remes <> 1 THEN NEXT. /* Nota M∆e idi-nf-simples-remes = 1 */
            IF b-docum-est-mae.embarque <> b-embarq-import-docto-mae.cod-embarq THEN NEXT.

            ASSIGN l-sair   = YES
                   pr-rowid = ROWID(b-docum-est-mae).
        END.

        IF c-prox-embarq = "" THEN
            ASSIGN l-sair = YES.
    END.

    RETURN "OK":U.

END.

PROCEDURE pi-busca-cotacao-despesa:

    DEF INPUT  PARAM p-i-cod-emit-desp  AS INT  NO-UNDO.
    DEF INPUT  PARAM p-i-cod-desp       AS INT  NO-UNDO.
    DEF OUTPUT PARAM p-dt-cotac         AS DATE NO-UNDO.
    DEF OUTPUT PARAM p-de-cotac         AS DEC  NO-UNDO.
    DEF OUTPUT PARAM p-i-mo-codigo      AS INT  NO-UNDO.

    DEF BUFFER b-docum-est-mae  FOR docum-est.
    DEF BUFFER b-docum-est-comp FOR docum-est.

    FOR FIRST b-item-doc-est-cex OF b-docum-est-aux NO-LOCK:
        ASSIGN p-dt-cotac    = b-item-doc-est-cex.dat-cotac
               p-de-cotac    = b-docum-est-aux.cotacao-dia
               p-i-mo-codigo = b-docum-est-aux.mo-codigo.
    END.

    IF r-rowid-mae <> ? THEN DO:
        /* acha a complementar m∆e */
        FOR FIRST b-docum-est-mae NO-LOCK
            WHERE ROWID(b-docum-est-mae) = r-rowid-mae,
            EACH  rat-docum no-lock
            WHERE rat-docum.nf-serie     = b-docum-est-mae.serie-docto
            AND   rat-docum.nf-nro       = b-docum-est-mae.nro-docto
            AND   rat-docum.nf-emitente  = b-docum-est-mae.cod-emitente
            AND   rat-docum.nf-nat-oper  = b-docum-est-mae.nat-operacao
            AND   rat-docum.cod-emitente = p-i-cod-emit-desp,
            FIRST b-docum-est-comp NO-LOCK
            WHERE b-docum-est-comp.serie-docto  = rat-docum.serie-docto
            AND   b-docum-est-comp.nro-docto    = rat-docum.nro-docto
            AND   b-docum-est-comp.cod-emitente = rat-docum.cod-emitente
            AND   b-docum-est-comp.nat-operacao = rat-docum.nat-operacao,
            FIRST b-item-doc-est-cex NO-LOCK
            WHERE b-item-doc-est-cex.serie-docto       = b-docum-est-comp.serie-docto
            AND   b-item-doc-est-cex.nro-docto         = b-docum-est-comp.nro-docto
            AND   b-item-doc-est-cex.cod-emitente      = b-docum-est-comp.cod-emitente
            AND   b-item-doc-est-cex.nat-operacao      = b-docum-est-comp.nat-operacao
            AND   b-item-doc-est-cex.cod-emitente-desp = p-i-cod-emit-desp
            AND   b-item-doc-est-cex.cod-desp          = p-i-cod-desp:

            ASSIGN p-dt-cotac    = b-item-doc-est-cex.dat-cotac
                   p-de-cotac    = b-docum-est-comp.cotacao-dia
                   p-i-mo-codigo = b-docum-est-comp.mo-codigo.
        END.
    END.

    RETURN "OK":U.

END.
