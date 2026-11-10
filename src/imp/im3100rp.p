/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM3100RP 2.00.00.031 } /*** "010031" 11/12/2025 08:58:33 ***/

/*****************************************************************************
*
*  IM3100RP.P - Relat¢rio de Conferància Embarque Importaá∆o
*
*  Objetivo: Relat¢rio de Conferància Embarque Importaá∆o  - Internacional
*
******************************************************************************/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im3100rp MIM}
&ENDIF

{include/i_fnctrad.i}

/************************** INICIO PrÇ-processadores **************************/
{cdp/cdcfgmat.i}   /* pre-processadores */
{cdp/cdcfgdis.i}   /* pre-processadores */
/**************************** FIM PrÇ-processadores ***************************/

/************************** INICIO Variavel Global ****************************/
{utp/ut-glob.i}    /* variaveis globais */
/**************************** FIM Variavel Global *****************************/

/****************************** INICIO TEMP-TABLE *****************************/
/*{cxbo/bocx220a.i}   definicoes temp-table tt-parametros*/
{imp/im0100x.i tt-parametros}
{imp/im0100.i}     /*tt-recebe e tt-param*/
{inbo/boin759.i tt-impto-item-docto}
{inbo/boin759.i tt-impto-item-docto-tot}
{cxbo/bocx310.i tt-desp-embarque}

DEF TEMP-TABLE tt-desp-nacion NO-UNDO
    FIELD cod-desp       LIKE desp-embarque.cod-desp
    FIELD cod-emit-desp  LIKE desp-embarque.cod-emitente-desp
    FIELD sequencia      LIKE historico-embarque.sequencia
    FIELD descricao      LIKE desp-imp.descricao
    FIELD cod-cond-pag   LIKE desp-embarque.cod-cond-pag
    FIELD mo-codigo      LIKE desp-embarque.mo-codigo
    FIELD val-desp-orig  LIKE item-doc-est-cex.val-desp
    FIELD de-cotacao     AS DECIMAL FORMAT ">>,>>9.99999999"
    FIELD val-desp       LIKE item-doc-est-cex.val-desp 
    FIELD tipo             AS CHAR FORMAT "x(20)" 
    FIELD base-iva         AS CHAR FORMAT "x(03)"
    FIELD base-ii          AS CHAR FORMAT "x(03)"
    FIELD val-duplic       AS CHAR FORMAT "x(03)"
    FIELD val-desp-mn      LIKE item-doc-est-cex.val-desp.

/******************************** FIM TEMP-TABLE ******************************/

/****************************** INICIO Parametro ******************************/

DEF INPUT PARAM TABLE FOR tt-parametros.
DEF INPUT PARAM TABLE FOR tt-param.
/******************************** FIM Parametro *******************************/

/****************************** INICIO Variaveis ******************************/
{cxbo/bocx225e.i1}                /* vari†veis atributo livre ordens-embarque */
{include/i-epc200.i IM3100RP}

DEF VAR i-numero-ordem           LIKE ordem-compra.numero-ordem         NO-UNDO.
DEF VAR i-parcela                LIKE ordens-embarque.parcela           NO-UNDO.
DEF VAR i-mo-codigo              LIKE moeda.mo-codigo                   NO-UNDO.
DEF VAR c-desc-moeda             LIKE moeda.descricao                   NO-UNDO.
DEF VAR c-desc-emitente          LIKE emitente.nome-emit                NO-UNDO.
DEF VAR de-cotacao-dia           AS DECIMAL FORMAT ">>,>>9.99999999"    NO-UNDO.
DEF VAR de-cotacao-var-camb      AS DECIMAL FORMAT ">>,>>9.99999999"    NO-UNDO.
DEF VAR c-desc-natur             LIKE natur-oper.denominacao            NO-UNDO.
DEF VAR c-desc-class-fisc        LIKE classif-fisc.descricao            NO-UNDO.
DEF VAR i-seq-item               LIKE item-doc-est.sequencia            NO-UNDO.
DEF VAR c-desc-item              LIKE ITEM.desc-item                    NO-UNDO.
DEF VAR de-preco-total-me        LIKE item-doc-est.preco-total[1]       NO-UNDO.
DEF VAR de-peso-bruto            LIKE item-doc-est.peso-liquido         NO-UNDO.
DEF VAR l-gravado                  AS LOGICAL INITIAL NO                NO-UNDO.
DEF VAR de-quant-sub-tot         LIKE item-doc-est.qt-do-forn           NO-UNDO.
DEF VAR de-preco-sub-tot-me      LIKE item-doc-est.preco-total[1]       NO-UNDO.
DEF VAR de-preco-tot-geral-me    LIKE item-doc-est.preco-total[1]       NO-UNDO.
DEF VAR de-preco-sub-tot-mn      LIKE item-doc-est.preco-total[1]       NO-UNDO.
DEF VAR de-preco-tot-geral-mn    LIKE item-doc-est.preco-total[1]       NO-UNDO.
DEF VAR de-peso-bruto-sub-tot    LIKE item-doc-est.peso-liquido         NO-UNDO.
DEF VAR de-peso-bruto-tot-geral  LIKE item-doc-est.peso-liquido         NO-UNDO.
DEF VAR de-peso-liq-tot-sub      LIKE item-doc-est.peso-liquido         NO-UNDO.
DEF VAR de-peso-liq-tot-geral    LIKE item-doc-est.peso-liquido         NO-UNDO.
DEF VAR de-tot-impto             LIKE impto-item-docto.val-impto        NO-UNDO.
DEF VAR de-tot-impto-me          LIKE impto-item-docto.val-impto        NO-UNDO.
DEF VAR de-base-calc-impto       LIKE impto-item-docto.val-impto        NO-UNDO.
DEF VAR de-base-calc-impto-convertido       LIKE impto-item-docto.val-impto        NO-UNDO.
DEF VAR c-desc-impto               AS CHAR FORMAT "X(28)"               NO-UNDO.
DEF VAR l-var-cambial            AS LOG                                 NO-UNDO.
DEF VAR r-rowid-mae              AS ROWID                               NO-UNDO.
DEF VAR dt-cotacao-dia           AS DATE                                NO-UNDO.

DEF VAR i-cod-itiner             LIKE itinerario.cod-itiner             NO-UNDO.
DEF VAR i-seq-nacionalizacao     LIKE historico-embarque.sequencia      NO-UNDO.
DEF VAR l-val-duplic             AS LOGICAL                             NO-UNDO.
DEF VAR c-log-sim                AS CHAR FORMAT "x(3)"                  NO-UNDO.
DEF VAR c-log-nao                AS CHAR FORMAT "x(3)"                  NO-UNDO.

DEF VAR c-tipo                     AS CHAR FORMAT "x(20)"               NO-UNDO.
DEF VAR de-val-tot-desp            LIKE desp-embarque.val-desp            NO-UNDO.
DEF VAR de-val-tot-desp-mn         LIKE desp-embarque.val-desp            NO-UNDO.
DEF VAR de-val-tot-desp-orig       LIKE desp-embarque.val-desp            NO-UNDO.

def var i-cod-desp-ii     like desp-imp.cod-desp      no-undo.
def var i-cod-emitente-ii like emitente.cod-emitente  no-undo.

DEF VAR de-val-desp-ii          LIKE item-doc-est-cex.val-desp      NO-UNDO.
DEF VAR de-tot-valor-ii         LIKE item-doc-est-cex.val-desp      NO-UNDO.
DEF VAR de-tot-emb-valor-ii     LIKE item-doc-est-cex.val-desp      NO-UNDO.

def var i-cod-desp-est           like desp-imp.cod-desp             NO-UNDO.
def var de-aliq-est              like item.aliquota-ipi             NO-UNDO.
DEF VAR de-val-desp-est          LIKE item-doc-est-cex.val-desp     NO-UNDO.
def var i-cod-emitente-est       like emitente.cod-emitente         NO-UNDO.
DEF VAR de-tot-valor-est         LIKE item-doc-est-cex.val-desp     NO-UNDO.
DEF VAR de-tot-emb-valor-est     LIKE item-doc-est-cex.val-desp      NO-UNDO.
def var i-trib-est                as   integer                no-undo.
DEF VAR lb-embarque                AS CHAR NO-UNDO.
DEF VAR lb-DI                      AS CHAR NO-UNDO.
DEF VAR lb-moeda                   AS CHAR NO-UNDO.
DEF VAR lb-fornec                  AS CHAR NO-UNDO.
DEF VAR lb-txCambio                AS CHAR NO-UNDO.
DEF VAR lb-txVarCambial            AS CHAR NO-UNDO.
DEF VAR lb-natOperacao             AS CHAR NO-UNDO.
DEF VAR lb-incotem                 AS CHAR NO-UNDO.
DEF VAR lb-classFiscal             AS CHAR NO-UNDO.
DEF VAR lb-descricao               AS CHAR NO-UNDO.
DEF VAR lb-seq                     AS CHAR NO-UNDO.
DEF VAR lb-item                    AS CHAR NO-UNDO.
DEF VAR lb-qtde                    AS CHAR NO-UNDO.
DEF VAR lb-vlUnitMe                AS CHAR NO-UNDO.
DEF VAR lb-totalME                 AS CHAR NO-UNDO.
DEF VAR lb-totalMN                 AS CHAR NO-UNDO.
DEF VAR lb-pesoBrutoTot            AS CHAR NO-UNDO.
DEF VAR lb-pesoLiqTot              AS CHAR NO-UNDO.
DEF VAR lb-imposto                 AS CHAR NO-UNDO.
DEF VAR lb-imposto-total           AS CHAR NO-UNDO.
DEFINE VARIABLE c-lb-imposto-item  AS CHAR FORMAT "x(30)"      NO-UNDO.
DEF VAR lb-imposto-item            AS CHAR FORMAT "x(30)"      NO-UNDO.
DEF VAR lb-baseCalculo             AS CHAR NO-UNDO.
DEF VAR lb-valorMe                 AS CHAR NO-UNDO.
DEF VAR lb-valorMN                 AS CHAR NO-UNDO.
DEF VAR lb-fornDesp                AS CHAR NO-UNDO.
DEF VAR lb-nomeAbrev               AS CHAR NO-UNDO.
DEF VAR lb-despesa                 AS CHAR NO-UNDO.
DEF VAR lb-condPgto                AS CHAR NO-UNDO.
DEF VAR lb-vlDespME                AS CHAR NO-UNDO.
DEF VAR lb-vlDespMN                AS CHAR NO-UNDO.
DEF VAR lb-moDespe                 AS CHAR NO-UNDO.
DEF VAR lb-vlOrigMo                AS CHAR NO-UNDO.
DEF VAR lb-taxaCambio              AS CHAR NO-UNDO.
DEF VAR lb-dupl                    AS CHAR NO-UNDO.
DEF VAR lb-tipo                    AS CHAR NO-UNDO.
DEF VAR lb-baseIva                 AS CHAR NO-UNDO.
DEF VAR lb-baseII                  AS CHAR NO-UNDO.
DEF VAR lb-totalQuant              AS CHAR NO-UNDO.
DEF VAR lb-subTotal                AS CHAR NO-UNDO.
DEF VAR lb-totalEmbarq             AS CHAR NO-UNDO.
DEF VAR lb-totalImpost             AS CHAR NO-UNDO.
DEF VAR lb-despAtepto              AS CHAR NO-UNDO.
DEF VAR lb-totalDesp               AS CHAR NO-UNDO.
DEF VAR lb-despApospto             AS CHAR NO-UNDO.
DEF VAR lb-aliqII                  AS CHAR NO-UNDO.
DEF VAR lb-valorII                 AS CHAR NO-UNDO.
DEF VAR lb-aliqEst                 AS CHAR NO-UNDO.
DEF VAR lb-valorEst                AS CHAR NO-UNDO.
DEF VAR l-transf                   AS LOG  NO-UNDO.

DEFINE VARIABLE h-boin759na AS HANDLE      NO-UNDO.

/******************************** FIM Variaveis *******************************/

/******************************* INICIO Buffer *******************************/
DEF BUFFER b-ordens-embarque FOR ordens-embarque.
DEF BUFFER b-docum-est       FOR docum-est.
DEF BUFFER b-docum-est-2     FOR docum-est.
DEF BUFFER b-embarque-imp    FOR embarque-imp.
/******************************** FIM Buffer **********************************/

FUNCTION fn-trad-label RETURNS CHAR (INPUT p-liter AS CHAR):
    RUN utp/ut-liter.p (INPUT p-liter, INPUT "*", INPUT "R") NO-ERROR.
    RETURN TRIM(RETURN-VALUE).
END FUNCTION.

FORM impto-item-docto.cdn-imposto       TO 50 COLUMN-LABEL "Imposto"
     c-desc-impto                        COLUMN-LABEL "Descriá∆o"
     impto-item-docto.val-base           COLUMN-LABEL "Base C†lculo"
     impto-item-docto.perc-imposto       COLUMN-LABEL "% Imp"
     impto-item-docto.val-impto-merc-ext COLUMN-LABEL "Valor ME"
     impto-item-docto.val-impto          COLUMN-LABEL "Valor MN"
     WITH FRAME f-impto-item STREAM-IO 64 DOWN WIDTH 200.
RUN utp/ut-trfrrp.p (INPUT FRAME f-impto-item:HANDLE).

FORM tt-impto-item-docto-tot.cdn-imposto       TO 50 COLUMN-LABEL "Imposto"
     c-desc-impto                               COLUMN-LABEL "Descriá∆o"
     tt-impto-item-docto-tot.val-base           COLUMN-LABEL "Base C†lculo"
     tt-impto-item-docto-tot.perc-imposto       COLUMN-LABEL "% Imp"
     tt-impto-item-docto-tot.val-impto-merc-ext COLUMN-LABEL "Valor ME"
     tt-impto-item-docto-tot.val-impto          COLUMN-LABEL "Valor MN"
     WITH FRAME f-impto-total STREAM-IO 64 DOWN WIDTH 200.
RUN utp/ut-trfrrp.p (INPUT FRAME f-impto-total:HANDLE).
FORM i-seq-item                     COLUMN-LABEL "Seq"
     item-doc-est.it-codigo         COLUMN-LABEL "Item"
     c-desc-item                    COLUMN-LABEL "Descriá∆o"
     item-doc-est.qt-do-forn        COLUMN-LABEL "Qtde"
     item-doc-est.preco-unit-me     COLUMN-LABEL "Valor Unit ME"
     de-preco-total-me              COLUMN-LABEL "Total ME"
     item-doc-est.preco-total[1]    COLUMN-LABEL "Total MN" FORMAT ">>>,>>>,>>>,>>9.99"
     de-peso-bruto                  COLUMN-LABEL "Peso Bruto Tot"
     item-doc-est.peso-liquido      COLUMN-LABEL "Peso Liq Tot"
     de-aliq-ii-i1                  COLUMN-LABEL "Al°q II"
     de-val-desp-ii                 COLUMN-LABEL "Valor II"
     de-aliq-est                    COLUMN-LABEL "Al°q Est"
     de-val-desp-est                COLUMN-LABEL "Valor Est"
     WITH FRAME f-item-arg STREAM-IO 64 DOWN WIDTH 300.
RUN utp/ut-trfrrp.p (INPUT FRAME f-item-arg:HANDLE).

FORM i-seq-item                     COLUMN-LABEL "Seq"            
     item-doc-est.it-codigo         COLUMN-LABEL "Item"           
     c-desc-item                    COLUMN-LABEL "Descriá∆o"      
     item-doc-est.qt-do-forn        COLUMN-LABEL "Qtde"           
     item-doc-est.preco-unit-me     COLUMN-LABEL "Valor Unit ME"  
     de-preco-total-me              COLUMN-LABEL "Total ME"       
     item-doc-est.preco-total[1]    COLUMN-LABEL "Total MN" FORMAT ">>>,>>>,>>>,>>9.99"
     de-peso-bruto                  COLUMN-LABEL "Peso Bruto Tot" 
     item-doc-est.peso-liquido      COLUMN-LABEL "Peso Liq Tot"   
     de-aliq-ii-i1                  COLUMN-LABEL "Al°q II"        
     de-val-desp-ii                 COLUMN-LABEL "Valor II"       
     WITH FRAME f-item STREAM-IO 64 DOWN WIDTH 300.
RUN utp/ut-trfrrp.p (INPUT FRAME f-item:HANDLE).

RUN piTraduzLabels.

{utp/ut-liter.i "Sim" *}
ASSIGN c-log-sim = RETURN-VALUE.
{utp/ut-liter.i "N∆o" *}
ASSIGN c-log-nao = RETURN-VALUE.

    {include/i-rpvar.i}
    
    {utp/ut-liter.i "RELATORIO DE CONFERENCIA DO EMBARQUE IMPORTACAO" *}

    ASSIGN c-programa     = "IM3100"
           c-versao       = "2.00"
           c-revisao      = "000"
           c-titulo-relat = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "ComÇrcio Exterior" *}
    ASSIGN c-sistema      = TRIM(RETURN-VALUE).
    
    FIND FIRST tt-parametros NO-LOCK NO-ERROR.
    FIND FIRST tt-param      NO-LOCK NO-ERROR.
    
    {include/i-rpcab.i}
    {cdp/cd-rpout.i}   /* include customizada Comex */
    
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    FIND param-imp NO-LOCK
         WHERE param-imp.cod-estabel = tt-parametros.cod-estabel NO-ERROR.
    
    IF  NOT AVAIL param-imp THEN
        RETURN NO-APPLY. 

    IF NOT VALID-HANDLE(h-boin759na) THEN
        RUN inbo/boin759na.p PERSISTENT SET h-boin759na.
    
    FIND embarque-imp NO-LOCK
         WHERE embarque-imp.cod-estabel = tt-parametros.cod-estabel
           AND embarque-imp.embarque    = tt-parametros.embarque NO-ERROR.
    
    IF  NOT AVAIL embarque-imp THEN 
        RETURN NO-APPLY.
    
    FOR FIRST ordens-embarque NO-LOCK
        WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
          AND ordens-embarque.embarque    = embarque-imp.embarque:
    END.
    IF  NOT AVAIL ordens-embarque THEN
        RETURN NO-APPLY.
    
    FOR FIRST ordem-compra NO-LOCK
        WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem:
    END.
    
    ASSIGN i-mo-codigo = IF AVAIL ordem-compra THEN ordem-compra.mo-codigo ELSE 0.
    
    FOR FIRST moeda NO-LOCK
        WHERE moeda.mo-codigo = i-mo-codigo:
    END.
    ASSIGN c-desc-moeda = IF AVAIL moeda THEN moeda.descricao ELSE "".
    
    FOR FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = tt-parametros.cod-emitente:
    END.
    ASSIGN c-desc-emitente = IF AVAIL emitente THEN emitente.nome-emit ELSE "".
    
    ASSIGN de-cotacao-dia = tt-parametros.d-cotacao. 

    FIND FIRST param-estoq-internac NO-LOCK NO-ERROR.
    IF tt-parametros.nff AND param-imp.log-descons-iva-tit-mercad AND
       AVAIL param-estoq-internac AND param-estoq-internac.log-atu-ce-var-camb  THEN DO:
        ASSIGN l-var-cambial = YES.

        FOR FIRST docto-estoq-internac NO-LOCK
            WHERE docto-estoq-internac.serie-docto  = tt-parametros.serie
              AND docto-estoq-internac.nro-docto    = tt-parametros.nro-docto
              AND docto-estoq-internac.cod-emitente = tt-parametros.cod-emitente
              AND docto-estoq-internac.nat-operacao = tt-parametros.nat-operacao:
    
            ASSIGN de-cotacao-var-camb = docto-estoq-internac.cotacao-ce.
    
        END.
    END.

    /* chamada UPC */
    FOR EACH tt-epc  
        WHERE tt-epc.cod-event = "CalculoPrecoUnitario":U:
        DELETE tt-epc.
    END.
    
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "CalculoPrecoUnitario":U
           tt-epc.cod-parameter = "RowidOrdemCompra":U
           tt-epc.val-parameter = STRING(ROWID(ordem-compra)).
    
    {include/i-epc201.i "CalculoPrecoUnitario"} 
    
    FIND FIRST tt-epc
         WHERE tt-epc.cod-event     = "CalculoPrecoUnitario":U
           AND tt-epc.cod-parameter = "AlteraCotacao":U NO-ERROR.
    
    IF  AVAIL tt-epc THEN
        ASSIGN de-cotacao-dia = DEC(tt-epc.val-parameter).
    
    FIND natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao = tt-parametros.nat-operacao NO-ERROR.
    
    ASSIGN c-desc-natur = IF AVAIL natur-oper THEN natur-oper.denominacao ELSE "".
           

    {cdp/cd4300.i3}
    {cxbo/bocx250.i50}
    {cdp/cd4300.i4 "yes" param-imp.char-1}
    {cxbo/bocx250.i51 "yes"}
    
    PUT CAPS(lb-embarque)    FORMAT 'x(12)':U    AT 01 embarque-imp.embarque          AT 16
        CAPS(lb-DI)          FORMAT 'x(05)':U    AT 34 embarque-imp.declaracao-import AT 41
        CAPS(lb-moeda)          AT 64 c-desc-moeda
        CAPS(lb-fornec)      FORMAT 'x(12)':U    AT 01 c-desc-emitente                AT 16
        CAPS(lb-txCambio)    FORMAT 'x(12)':U    AT 01 de-cotacao-dia                 TO 40.

    IF l-var-cambial THEN
        PUT CAPS(lb-txVarCambial) FORMAT 'x(22)':U  AT 01 de-cotacao-var-camb         TO 40.

    PUT CAPS(lb-natOperacao) FORMAT 'x(14)':U    AT 01 tt-parametros.nat-operacao     AT 16 SPACE(3) c-desc-natur
        CAPS(lb-incotem)     FORMAT 'x(12)':U    AT 01 embarque-imp.cod-incoterm      AT 16.
    
    FIND docum-est NO-LOCK
         WHERE docum-est.serie-docto  = tt-parametros.serie
           AND docum-est.nro-docto    = tt-parametros.nro-docto
           AND docum-est.cod-emitente = tt-parametros.cod-emitente
           AND docum-est.nat-operacao = tt-parametros.nat-operacao NO-ERROR.
    IF  NOT AVAIL docum-est THEN DO:
        RETURN NO-APPLY.
    END.

    IF  i-pais-impto-usuario = 2
    AND embarque-imp.log-embarq-transf-draw THEN
        ASSIGN l-transf = YES.
    ELSE
        ASSIGN l-transf = NO.
    
    ASSIGN i-seq-item = 1.

    FOR EACH  item-doc-est NO-LOCK
        WHERE item-doc-est.serie-docto  = docum-est.serie-docto
          AND item-doc-est.nro-docto    = docum-est.nro-docto
          AND item-doc-est.cod-emitente = docum-est.cod-emitente
          AND item-doc-est.nat-operacao = docum-est.nat-operacao
        BREAK BY item-doc-est.class-fisc
              BY item-doc-est.un:

        FIND classif-fisc NO-LOCK
             WHERE classif-fisc.class-fisc = item-doc-est.class-fisc NO-ERROR.
        
        ASSIGN c-desc-class-fisc = IF AVAIL classif-fisc THEN classif-fisc.descricao ELSE "".
        ASSIGN i-seq-item = i-seq-item + 1.
        IF  FIRST-OF(item-doc-est.class-fisc) THEN DO:
            PUT SKIP(1)
                lb-classFiscal AT 01 FORMAT 'x(12)':U
                lb-descricao   AT 14 FORMAT 'x(12)':U
                "------------" AT 01
                "-----------------------------------" AT 14
                item-doc-est.class-fisc AT 01
                c-desc-class-fisc       AT 14 SKIP(1).
        END.
        
        IF  FIRST-OF(item-doc-est.un) THEN
            ASSIGN i-seq-item = 1.            
                          
        FOR FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-doc-est.it-codigo:
        END.
        
        ASSIGN c-desc-item    = IF AVAIL ITEM THEN ITEM.desc-item ELSE "".

        IF  tt-parametros.l-nf-simples-remessa     AND
            tt-parametros.idi-nf-simples-remes = 1 THEN DO:                
            ASSIGN i-numero-ordem = item-doc-est.num-ord-import
                   i-parcela      = item-doc-est.num-parc-import.                       
        END.
        ELSE
            ASSIGN i-numero-ordem = item-doc-est.numero-ordem
                   i-parcela      = item-doc-est.parcela.

        FIND FIRST ordem-compra NO-LOCK
             WHERE ordem-compra.numero-ordem = i-numero-ordem NO-ERROR.
        
        FOR FIRST cotacao-item NO-LOCK
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
              AND cotacao-item.cod-emitente = item-doc-est.cod-emitente
              AND cotacao-item.it-codigo    = item-doc-est.it-codigo
              AND cotacao-item.cot-aprovada:
        END.
        
        FIND FIRST tt-epc
             WHERE tt-epc.cod-event     = "CalculoPrecoUnitario":U
               AND tt-epc.cod-parameter = "AlteraCotacao":U NO-ERROR.
        
        IF  AVAIL tt-epc THEN
           ASSIGN de-preco-total-me = item-doc-est.preco-total[1] / de-cotacao-dia.
        ELSE DO:
            IF AVAIL cotacao-item THEN DO:
                run cdp/cd0812a.p (INPUT  0,
                                   INPUT  cotacao-item.mo-codigo,
                                   INPUT  item-doc-est.preco-total[1], 
                                   INPUT  tt-parametros.d-cotacao,
                                   OUTPUT de-preco-total-me).
            END.
        END.
        
        ASSIGN de-peso-bruto = item.peso-bruto * item-doc-est.quantidade.
        
        FIND FIRST ordens-embarque NO-LOCK
             WHERE ordens-embarque.cod-estabel  = embarque-imp.cod-estabel
               AND ordens-embarque.embarque     = embarque-imp.embarque
               AND ordens-embarque.numero-ordem = ordem-compra.numero-ordem
               AND ordens-embarque.parcela      = i-parcela NO-ERROR.
        
        IF  AVAIL ordens-embarque THEN DO:
            {cxbo/bocx225e.i2 no ordens-embarque} /* busca valores atributos livres */

            {cxbo/bocx225e.i4 no ordens-embarque} /* busca valores atributos livres */
            ASSIGN l-gravado = l-ja-gravado.
            ASSIGN de-peso-bruto = de-peso-bruto-i1.
        END.
                        

        IF  NOT l-gravado THEN DO:
            FOR FIRST cotacao-item NO-LOCK
                WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                  AND cotacao-item.cod-emitente = item-doc-est.cod-emitente
                  AND cotacao-item.it-codigo    = item-doc-est.it-codigo
                  AND cotacao-item.cot-aprovada:
            END.
            IF  AVAIL cotacao-item THEN DO:
                {ccp/cc9019.i50} /* include tratamento atributo livre cotacao-item.char-1 */
                {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                {ccp/cc9019.i51 "yes"}
            END.
            ASSIGN i-trib-ii-i1 = integer(substring(item.char-2,20,2))
                   de-aliq-ii-i1 = de-aliq-ii-i50.
        END.
        
        ASSIGN i-trib-est  = integer(substring(item.char-2,276,2))
               de-aliq-est = decimal(substring(item.char-2,270,6)).
        

        {cdp/cd4300.i4 "yes" param-imp.char-1}
        {cxbo/bocx250.i51 "yes"}
        
        assign i-cod-desp-ii     = i-desp-ii-i50
               i-cod-emitente-ii = i-emitente-ii-i50.

        if i-pais-impto-usuario = 2 then 
            assign i-cod-desp-est     = param-imp.cdn-despes-tax-estatis
                   i-cod-emitente-est = param-imp.cdn-emit-tax-estatis.

        ASSIGN de-val-desp-ii = 0.
        FOR EACH item-doc-est-cex NO-LOCK
             WHERE item-doc-est-cex.serie-docto       = item-doc-est.serie-docto
               AND item-doc-est-cex.nro-docto         = item-doc-est.nro-docto
               AND item-doc-est-cex.cod-emitente      = item-doc-est.cod-emitente
               AND item-doc-est-cex.nat-operacao      = item-doc-est.nat-operacao
               AND item-doc-est-cex.sequencia         = item-doc-est.sequencia:
            IF item-doc-est-cex.cod-emitente-desp = i-cod-emitente-ii
               AND item-doc-est-cex.cod-desp      = i-cod-desp-ii THEN
                ASSIGN de-val-desp-ii = item-doc-est-cex.val-desp.

            IF item-doc-est-cex.cod-desp      = i-cod-desp-est
                AND item-doc-est-cex.cod-desp = i-cod-desp-est THEN
                ASSIGN de-val-desp-est = item-doc-est-cex.val-desp.
        END.
        
        IF  AVAIL ITEM AND ITEM.tipo-con-est = 2 AND AVAIL ordens-embarque THEN
            ASSIGN de-peso-bruto = de-peso-bruto / ordens-embarque.quantidade.
        
        FOR FIRST  processo-imp
            FIELDS (nr-proc-imp)
            WHERE  processo-imp.num-pedido = ordem-compra.num-pedido NO-LOCK:
        END.

        IF i-pais-impto-usuario = 2 THEN DO:       
            DISP i-seq-item                 
                 item-doc-est.it-codigo      
                 c-desc-item                 
                 item-doc-est.qt-do-forn     
                 item-doc-est.preco-unit-me  
                 de-preco-total-me           
                 item-doc-est.preco-total[1] 
                 de-peso-bruto               
                 item-doc-est.peso-liquido   
                 de-aliq-ii-i1               
                 de-val-desp-ii              
                 de-aliq-est                 
                 de-val-desp-est            
                 WITH FRAME f-item-arg.
			DOWN WITH FRAME f-item-arg.
		END.
        ELSE DO:
            DISP i-seq-item                   
                 item-doc-est.it-codigo       
                 c-desc-item                  
                 item-doc-est.qt-do-forn      
                 item-doc-est.preco-unit-me    
                 de-preco-total-me            
                 item-doc-est.preco-total[1]  
                 de-peso-bruto                
                 item-doc-est.peso-liquido    
                 de-aliq-ii-i1                
                 de-val-desp-ii               
                 WITH FRAME f-item.
			DOWN WITH FRAME f-item.
		END.

        ASSIGN de-quant-sub-tot       = de-quant-sub-tot       + item-doc-est.qt-do-forn
               de-preco-sub-tot-me    = de-preco-sub-tot-me    + de-preco-total-me
               de-preco-sub-tot-mn    = de-preco-sub-tot-mn    + item-doc-est.preco-total[1]
               de-peso-bruto-sub-tot  = de-peso-bruto-sub-tot  + de-peso-bruto
               de-peso-liq-tot-sub    = de-peso-liq-tot-sub    + item-doc-est.peso-liquido
               de-tot-valor-ii        = de-tot-valor-ii        + de-val-desp-ii
               de-tot-valor-est       = de-tot-valor-est       + de-val-desp-est
               de-preco-total-me      = 0
               de-peso-bruto          = 0
               de-val-desp-ii         = 0
               de-val-desp-est        = 0.

        /* ***** Imposto ***** */
        IF  CAN-FIND(FIRST impto-item-docto NO-LOCK
                 WHERE impto-item-docto.serie-docto  = docum-est.serie-docto
                   AND impto-item-docto.nro-docto    = docum-est.nro-docto
                   AND impto-item-docto.cod-emitente = docum-est.cod-emitente
                   AND impto-item-docto.nat-operacao = docum-est.nat-operacao) THEN DO:       

            ASSIGN de-tot-impto    = 0
                   de-tot-impto-me = 0.

            FOR EACH impto-item-docto NO-LOCK
               WHERE impto-item-docto.serie-docto  = item-doc-est.serie-docto
                 AND impto-item-docto.nro-docto    = item-doc-est.nro-docto
                 AND impto-item-docto.cod-emitente = item-doc-est.cod-emitente
                 AND impto-item-docto.nat-operacao = item-doc-est.nat-operacao
                 AND impto-item-docto.num-seq      = item-doc-est.sequencia:
               
               /* para notas de transferencia de drawback a base de c†lculo s∆o somente as despesas que incidem no iva */
               IF  l-transf THEN
                   ASSIGN de-base-calc-impto = 0.
               ELSE 
                   ASSIGN de-base-calc-impto = item-doc-est.preco-total-me.
               
               FIND FIRST tipo-tax NO-LOCK
                    WHERE tipo-tax.cod-tax = impto-item-docto.cdn-imposto NO-ERROR.
               ASSIGN c-desc-impto = IF  AVAIL tipo-tax THEN tipo-tax.descricao ELSE "".
                       
               DISP impto-item-docto.cdn-imposto       
                    c-desc-impto                       
                    impto-item-docto.val-base
                    impto-item-docto.perc-imposto      
                    impto-item-docto.val-impto-merc-ext
                    impto-item-docto.val-impto         
                    WITH FRAME f-impto-item.
               DOWN WITH FRAME f-impto-item.
               
               ASSIGN de-tot-impto    = de-tot-impto    + impto-item-docto.val-impto
                      de-tot-impto-me = de-tot-impto-me + impto-item-docto.val-impto-merc-ext.           
            END.
        END.
    
        IF  de-tot-impto > 0 OR de-tot-impto-me > 0 THEN
            PUT "-------------------- --------------------" AT 112
                CAPS(lb-totalImpost) AT  90 FORMAT 'x(17)':U
                de-tot-impto-me      TO 131
                de-tot-impto         TO 152
                SKIP(1).
        
        IF  LAST-OF(item-doc-est.un) THEN DO:
            PUT "-----------------"   AT 85
                CAPS(lb-totalQuant)   AT 73 FORMAT 'x(11)':U
                de-quant-sub-tot      AT 85 SKIP(1). 
            
            ASSIGN de-quant-sub-tot    = 0.
        END.
        
        IF  LAST-OF(item-doc-est.class-fisc) THEN DO:

            IF i-pais-impto-usuario = 2 THEN
                PUT SKIP(1)
                    "---------------"       AT 123
                    "------------------"    AT 139
                    "-----------------"     AT 158
                    "-----------------"     AT 176
                    "-------------------"   AT 201
                    "-------------------"   AT 231
                    CAPS(lb-subTotal)       AT 74  FORMAT 'x(9)':U
                    de-preco-sub-tot-me     AT 123
                    de-preco-sub-tot-mn     AT 139 FORMAT ">>>,>>>,>>>,>>9.99"
                    de-peso-bruto-sub-tot   AT 158
                    de-peso-liq-tot-sub     AT 176
                    de-tot-valor-ii         AT 202
                    de-tot-valor-est        AT 231.
            ELSE
                PUT "---------------"      AT 123
                    "------------------"   AT 139
                    "-----------------"    AT 158
                    "-----------------"    AT 176
                    "-------------------"  AT 201
                    CAPS(lb-subTotal)       AT 74  FORMAT 'x(9)':U
                    de-preco-sub-tot-me     AT 123
                    de-preco-sub-tot-mn     AT 139 FORMAT ">>>,>>>,>>>,>>9.99"
                    de-peso-bruto-sub-tot   AT 158
                    de-peso-liq-tot-sub     AT 176
                    de-tot-valor-ii         AT 201.

            ASSIGN de-preco-tot-geral-me     = de-preco-tot-geral-me + de-preco-sub-tot-me
                   de-preco-tot-geral-mn     = de-preco-tot-geral-mn + de-preco-sub-tot-mn
                   de-peso-bruto-tot-geral   = de-peso-bruto-tot-geral + de-peso-bruto-sub-tot
                   de-peso-liq-tot-geral     = de-peso-liq-tot-geral + de-peso-liq-tot-sub 
                   de-tot-emb-valor-ii       = de-tot-emb-valor-ii + de-tot-valor-ii
                   de-tot-emb-valor-est      = de-tot-emb-valor-est + de-tot-valor-est
                   de-preco-sub-tot-me       = 0
                   de-preco-sub-tot-mn       = 0
                   de-peso-bruto-sub-tot     = 0
                   de-peso-liq-tot-sub       = 0
                   de-tot-valor-ii           = 0
                   de-tot-valor-est          = 0.
        END.
    END.

    IF i-pais-impto-usuario = 2 THEN
        PUT skip(3)
        "---------------"         AT 123
        "------------------"      AT 139
        "-----------------"       AT 158
        "-----------------"       AT 176
        "-------------------"     AT 201
        "-------------------"     AT 231
        CAPS(lb-totalEmbarq)      AT 66  FORMAT 'x(20)':U
        de-preco-tot-geral-me     AT 123
        de-preco-tot-geral-mn     AT 139 FORMAT ">>>,>>>,>>>,>>9.99"
        de-peso-bruto-tot-geral   AT 158
        de-peso-liq-tot-geral     AT 176
        de-tot-emb-valor-ii       AT 201
        de-tot-emb-valor-est      AT 231.
    ELSE
        PUT skip(1)
            "---------------"         AT 123
            "------------------"      AT 139
            "-----------------"       AT 158
            "-----------------"       AT 176
            "-------------------"     AT 201
            CAPS(lb-totalEmbarq)      AT 66  FORMAT 'x(20)':U
            de-preco-tot-geral-me     AT 123
            de-preco-tot-geral-mn     AT 139 FORMAT ">>>,>>>,>>>,>>9.99"
            de-peso-bruto-tot-geral   AT 158
            de-peso-liq-tot-geral     AT 176
            de-tot-emb-valor-ii       AT 201.

    EMPTY TEMP-TABLE tt-impto-item-docto-tot.
    RUN getImptoItemDoctoByDocumEst IN h-boin759na (INPUT ROWID(docum-est),
                                                    INPUT 0, /*retornar todos*/
                                                    OUTPUT TABLE tt-impto-item-docto-tot).
    /* ***** Imposto ***** */
    IF  CAN-FIND(FIRST tt-impto-item-docto-tot) THEN DO:   
        
        ASSIGN de-tot-impto    = 0
               de-tot-impto-me = 0.

        FOR EACH tt-impto-item-docto-tot NO-LOCK:    

           FIND FIRST tipo-tax NO-LOCK
                WHERE tipo-tax.cod-tax = tt-impto-item-docto-tot.cdn-imposto NO-ERROR.
           ASSIGN c-desc-impto = IF  AVAIL tipo-tax THEN tipo-tax.descricao ELSE "".
        
           DISP tt-impto-item-docto-tot.cdn-imposto       
                c-desc-impto                       
                tt-impto-item-docto-tot.val-base
                tt-impto-item-docto-tot.perc-imposto      
                tt-impto-item-docto-tot.val-impto-merc-ext
                tt-impto-item-docto-tot.val-impto         
                WITH FRAME f-impto-total.
           DOWN WITH FRAME f-impto-total.

           ASSIGN de-tot-impto    = de-tot-impto    + tt-impto-item-docto-tot.val-impto
                  de-tot-impto-me = de-tot-impto-me + tt-impto-item-docto-tot.val-impto-merc-ext.           
        END.
    END.

    IF  de-tot-impto-me > 0 OR de-tot-impto > 0 THEN
        PUT "-------------------- --------------------" AT 112
            CAPS(lb-totalImpost) AT  90 FORMAT 'x(17)':U
            de-tot-impto-me      TO 131
            de-tot-impto         TO 152
            SKIP(1).

    FOR FIRST historico-embarque WHERE
              historico-embarque.cod-estabel = embarque-imp.cod-estabel AND
              historico-embarque.embarque    = embarque-imp.embarque NO-LOCK:
    END.
    
    ASSIGN i-cod-itiner = historico-embarque.cod-itiner.
    
    FIND itinerario NO-LOCK
         WHERE itinerario.cod-itiner = i-cod-itiner NO-ERROR.
    
    FIND historico-embarque NO-LOCK
         WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
           AND historico-embarque.embarque      = embarque-imp.embarque 
           AND historico-embarque.cod-itiner    = i-cod-itiner 
           AND historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar NO-ERROR.
    IF  AVAIL historico-embarque THEN
        ASSIGN i-seq-nacionalizacao = historico-embarque.sequencia.
    
    RUN piTotalizaDespEmbarque IN THIS-PROCEDURE (INPUT embarque-imp.cod-estabel,
                                                  INPUT embarque-imp.embarque,
                                                  INPUT embarque-imp.cod-estabel,
                                                  INPUT embarque-imp.embarque,
                                                  OUTPUT TABLE tt-desp-embarque).

    ASSIGN de-cotacao-dia = 0
           dt-cotacao-dia = ?.
    
    IF docum-est.idi-nf-simples-remes = 2 /* Nota filha */ THEN
        RUN pi-busca-nota-mae (OUTPUT r-rowid-mae).


    FOR EACH  historico-embarque NO-LOCK
        WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
          AND historico-embarque.embarque    = embarque-imp.embarque
          AND historico-embarque.cod-itiner  = i-cod-itiner:
        
        FOR EACH  tt-desp-embarque NO-LOCK
            WHERE tt-desp-embarque.cod-estabel   = historico-embarque.cod-estabel
              AND tt-desp-embarque.embarque      = historico-embarque.embarque
              AND tt-desp-embarque.cod-itiner    = historico-embarque.cod-itiner
              AND tt-desp-embarque.cod-pto-contr = historico-embarque.cod-pto-contr:
            
            FIND desp-imp NO-LOCK
                 WHERE desp-imp.cod-desp = tt-desp-embarque.cod-desp NO-ERROR.
            
            IF NOT AVAIL desp-imp THEN NEXT.
            
            IF  NOT desp-imp.inc-val-frete
            AND NOT desp-imp.inc-val-seguro
            AND NOT desp-imp.inc-val-embal
            AND NOT desp-imp.inc-val-outras-desp THEN NEXT.
            
            ASSIGN l-val-duplic = desp-imp.inc-val-duplic.
            
            RUN pi-retornarDescricao IN THIS-PROCEDURE (INPUT  "desp-imp.tipo":U,
                                                        INPUT  desp-imp.tipo,
                                                        OUTPUT c-tipo).           

            IF docum-est.idi-nf-simples-remes = 2 AND 
               historico-embarque.sequencia > i-seq-nacionalizacao AND 
               tt-desp-embarque.log-despes-ja-recbda THEN DO:

                ASSIGN de-cotacao-dia = 0
                       dt-cotacao-dia = ?.
                                
                IF r-rowid-mae <> ? THEN DO:
                    FOR FIRST b-docum-est NO-LOCK
                        WHERE ROWID(b-docum-est) = r-rowid-mae,
                        EACH  item-doc-est NO-LOCK
                        WHERE item-doc-est.serie-comp   = b-docum-est.serie-docto
                          AND item-doc-est.nro-comp     = b-docum-est.nro-docto
                          AND item-doc-est.cod-emitente = tt-desp-embarque.cod-emitente-desp
                          AND item-doc-est.nat-comp     = b-docum-est.nat-operacao,                    
                        FIRST item-doc-est-cex NO-LOCK          
                        WHERE item-doc-est-cex.serie-docto       = item-doc-est.serie-docto    
                          AND item-doc-est-cex.nro-docto         = item-doc-est.nro-docto      
                          AND item-doc-est-cex.cod-emitente      = item-doc-est.cod-emitente  
                          AND item-doc-est-cex.nat-operacao      = item-doc-est.nat-operacao     
                          AND item-doc-est-cex.cod-emitente-desp = tt-desp-embarque.cod-emitente-desp
                          AND item-doc-est-cex.cod-desp          = tt-desp-embarque.cod-desp:
    
                        ASSIGN dt-cotacao-dia = item-doc-est-cex.dat-cotac.

                        IF docum-est.mo-codigo = tt-desp-embarque.mo-codigo THEN DO:
    
                            FOR FIRST b-docum-est-2 NO-LOCK
                                WHERE b-docum-est-2.serie-docto  = item-doc-est.serie-docto  
                                  AND b-docum-est-2.nro-docto    = item-doc-est.nro-docto    
                                  AND b-docum-est-2.cod-emitente = item-doc-est.cod-emitente 
                                  AND b-docum-est-2.nat-operacao = item-doc-est.nat-operacao:
                                ASSIGN de-cotacao-dia = b-docum-est-2.cotacao-dia.
                            END.
    
                        END.
                        ELSE DO:
                            FIND FIRST cotacao NO-LOCK
                                 WHERE cotacao.mo-codigo   = tt-desp-embarque.mo-codigo
                                   AND cotacao.ano-periodo = STRING(YEAR(item-doc-est-cex.dat-cotac)) + STRING(MONTH(item-doc-est-cex.dat-cotac),"99")
                                   AND cotacao.cotacao[INT(DAY(tt-parametros.da-cotacao))] <> 0 NO-ERROR.
                        
                            ASSIGN de-cotacao-dia = IF AVAIL cotacao then cotacao.cotacao[int(day(item-doc-est-cex.dat-cotac))] ELSE 1.   
                        END.

                        LEAVE.

                    END.
                END.

                IF de-cotacao-dia = 0 THEN DO:
                    IF docum-est.mo-codigo = tt-desp-embarque.mo-codigo THEN
                        ASSIGN de-cotacao-dia = tt-parametros.d-cotacao.
                    ELSE DO:
                        FIND cotacao NO-LOCK
                             WHERE cotacao.mo-codigo   = tt-desp-embarque.mo-codigo
                               AND cotacao.ano-periodo = STRING(YEAR(tt-parametros.da-cotacao)) + STRING(MONTH(tt-parametros.da-cotacao),"99")
                               AND cotacao.cotacao[INT(DAY(tt-parametros.da-cotacao))] <> 0 NO-ERROR.
                        
                        ASSIGN de-cotacao-dia = IF AVAIL cotacao then cotacao.cotacao[int(day(tt-parametros.da-cotacao))] ELSE 1.
                    END.    
                END.

                IF dt-cotacao-dia = ? THEN
                    ASSIGN dt-cotacao-dia = tt-parametros.da-cotacao.

            END.
            ELSE DO:
                IF docum-est.mo-codigo = tt-desp-embarque.mo-codigo THEN
                    ASSIGN de-cotacao-dia = tt-parametros.d-cotacao.
                ELSE DO:
                    FIND cotacao NO-LOCK
                         WHERE cotacao.mo-codigo   = tt-desp-embarque.mo-codigo
                           AND cotacao.ano-periodo = STRING(YEAR(tt-parametros.da-cotacao)) + STRING(MONTH(tt-parametros.da-cotacao),"99")
                           AND cotacao.cotacao[INT(DAY(tt-parametros.da-cotacao))] <> 0 NO-ERROR.
                    
                    ASSIGN de-cotacao-dia = IF AVAIL cotacao then cotacao.cotacao[int(day(tt-parametros.da-cotacao))] ELSE 1.
                END.
            END.
            
            FIND FIRST tt-epc
                 WHERE tt-epc.cod-event     = "CalculoPrecoUnitario":U
                   AND tt-epc.cod-parameter = "AlteraCotacao":U NO-ERROR.
            
            IF  AVAIL tt-epc THEN
                ASSIGN de-cotacao-dia    = DEC(tt-epc.val-parameter).
            
            CREATE tt-desp-nacion.
            ASSIGN tt-desp-nacion.cod-desp       = tt-desp-embarque.cod-desp
                   tt-desp-nacion.descricao      = desp-imp.descricao
                   tt-desp-nacion.cod-emit-desp  = tt-desp-embarque.cod-emitente-desp 
                   tt-desp-nacion.sequencia      = historico-embarque.sequencia
                   tt-desp-nacion.cod-cond-pag   = tt-desp-embarque.cod-cond-pag
                   tt-desp-nacion.mo-codigo      = tt-desp-embarque.mo-codigo
                   tt-desp-nacion.val-desp-orig  = tt-desp-embarque.val-desp
                   tt-desp-nacion.de-cotacao     = IF tt-desp-embarque.mo-codigo = 0 THEN 1 ELSE de-cotacao-dia
                   tt-desp-nacion.tipo           = c-tipo.


            IF  desp-imp.inc-base-ipi = YES THEN
                ASSIGN tt-desp-nacion.base-iva   = c-log-sim.
            ELSE
                ASSIGN tt-desp-nacion.base-iva   = c-log-nao.
            IF  desp-imp.log-2 = YES THEN
                ASSIGN tt-desp-nacion.base-ii    = c-log-sim.
            ELSE
                ASSIGN tt-desp-nacion.base-ii    = c-log-nao.
            IF  l-val-duplic = YES THEN
                ASSIGN tt-desp-nacion.val-duplic = c-log-sim. 
            ELSE
                ASSIGN tt-desp-nacion.val-duplic = c-log-nao.

            ASSIGN c-tipo          = ""
                   l-val-duplic    = NO
                   de-cotacao-dia  = 0.
            
            IF  docum-est.mo-codigo <> tt-desp-embarque.mo-codigo THEN DO:
                IF docum-est.idi-nf-simples-remes = 2 AND 
                   historico-embarque.sequencia > i-seq-nacionalizacao AND 
                   tt-desp-embarque.log-despes-ja-recbda THEN DO:
                    run cdp/cd0812.p (input tt-desp-embarque.mo-codigo,
                                      input docum-est.mo-codigo,
                                      input tt-desp-embarque.val-desp,
                                      input dt-cotacao-dia,
                                      output tt-desp-nacion.val-desp).                                      
                END.
                ELSE DO:
                    run cdp/cd0812.p (input tt-desp-embarque.mo-codigo,
                                      input docum-est.mo-codigo,
                                      input tt-desp-embarque.val-desp,
                                      input tt-parametros.da-cotacao,
                                      output tt-desp-nacion.val-desp).                                      
                END.
            END.
            ELSE
                ASSIGN tt-desp-nacion.val-desp = tt-desp-embarque.val-desp.


            if tt-desp-embarque.mo-codigo <> 0 THEN DO: 

                IF docum-est.idi-nf-simples-remes = 2 AND 
                   historico-embarque.sequencia > i-seq-nacionalizacao AND 
                   tt-desp-embarque.log-despes-ja-recbda THEN DO:
                    ASSIGN tt-desp-nacion.val-desp-mn = tt-desp-embarque.val-desp * tt-desp-nacion.de-cotacao.
                END.
                ELSE DO:
                    IF docum-est.mo-codigo <> tt-desp-embarque.mo-codigo THEN
                        run cdp/cd0812.p (input tt-desp-embarque.mo-codigo,
                                          input 0,
                                          input tt-desp-embarque.val-desp,
                                          input tt-parametros.da-cotacao,
                                          output tt-desp-nacion.val-desp-mn).     
                    ELSE
                        run cdp/cd0812a.p (input tt-desp-embarque.mo-codigo,
                                           input 0,
                                           input tt-desp-embarque.val-desp,
                                           input tt-parametros.d-cotacao,
                                           output tt-desp-nacion.val-desp-mn).
                END.
            END.
            ELSE
                ASSIGN tt-desp-nacion.val-desp-mn = tt-desp-embarque.val-desp.
        END.
    END.
    
    IF  CAN-FIND(FIRST tt-desp-nacion
                 WHERE tt-desp-nacion.sequencia <= i-seq-nacionalizacao) THEN DO:
        
        PUT SKIP(1) CAPS(lb-despAtepto) FORMAT 'x(45)':U SKIP(1).
        
        PUT lb-fornDesp   AT 001 FORMAT 'x(09)':U
            lb-nomeAbrev  AT 011 FORMAT 'x(12)':U
            lb-despesa    AT 024
            lb-descricao  AT 032 FORMAT 'x(12)':U
            lb-condPgto   AT 061 FORMAT 'x(09)':U
            lb-vlDespME   AT 073 FORMAT 'x(16)':U
            lb-vlDespMN   AT 092 FORMAT 'x(16)':U
            lb-moDespe    AT 109
            lb-vlOrigMo   AT 122 FORMAT 'x(13)':U
            lb-taxaCambio AT 140 FORMAT 'x(11)':U
            lb-dupl       AT 152 FORMAT 'x(04)':U
            lb-tipo       AT 167 FORMAT 'x(04)':U
            lb-baseIva    AT 173
            lb-baseII     AT 182 SKIP
            "--------- ------------ ------- ---------------------------- --------- ------------------ ------------------ ------- ------------------ --------------- ---- --------------- -------- -------" SKIP.
        
        FOR EACH  tt-desp-nacion NO-LOCK
            WHERE tt-desp-nacion.sequencia <= i-seq-nacionalizacao
            BREAK BY tt-desp-nacion.cod-emit-desp
                  BY tt-desp-nacion.sequencia:
            
            FIND emitente NO-LOCK
                 WHERE emitente.cod-emitente = tt-desp-nacion.cod-emit-desp NO-ERROR.
            
            PUT tt-desp-nacion.cod-emit-desp  AT 01
                emitente.nome-abrev           AT 11
                tt-desp-nacion.cod-desp       AT 25
                tt-desp-nacion.descricao      AT 32 
                tt-desp-nacion.cod-cond-pag   AT 66
                tt-desp-nacion.val-desp       AT 70 
                tt-desp-nacion.val-desp-mn    at 89
                tt-desp-nacion.mo-codigo      AT 114 
                tt-desp-nacion.val-desp-orig  AT 116 
                tt-desp-nacion.de-cotacao     AT 136 
                tt-desp-nacion.val-duplic     AT 152 
                tt-desp-nacion.tipo           AT 157
                tt-desp-nacion.base-iva       AT 178
                tt-desp-nacion.base-ii        AT 186.

            ASSIGN de-val-tot-desp      = de-val-tot-desp      + tt-desp-nacion.val-desp
                   de-val-tot-desp-mn   = de-val-tot-desp-mn   + tt-desp-nacion.val-desp-mn
                   de-val-tot-desp-orig = de-val-tot-desp-orig + tt-desp-nacion.val-desp-orig .
        END.
        
        PUT SKIP "------------------" AT 71
                 "------------------" AT 90
                 lb-totalDesp AT 55 FORMAT 'x(15)':U
                 de-val-tot-desp
                 de-val-tot-desp-mn.
    END.
    
    ASSIGN de-val-tot-desp      = 0
           de-val-tot-desp-mn   = 0
           de-val-tot-desp-orig = 0.

    IF  CAN-FIND(FIRST tt-desp-nacion
                 WHERE tt-desp-nacion.sequencia > i-seq-nacionalizacao) THEN DO:  

        PUT SKIP(3) CAPS(lb-despApospto) FORMAT 'x(45)':U SKIP(2).
        
        PUT lb-fornDesp   AT 001 FORMAT 'x(09)':U
            lb-nomeAbrev  AT 011 FORMAT 'x(12)':U
            lb-despesa    AT 024
            lb-descricao  AT 032 FORMAT 'x(12)':U
            lb-condPgto   AT 061 FORMAT 'x(09)':U
            lb-vlDespME   AT 073 FORMAT 'x(16)':U
            lb-vlDespMN   AT 092 FORMAT 'x(16)':U
            lb-moDespe    AT 109
            lb-vlOrigMo   AT 122 FORMAT 'x(13)':U
            lb-taxaCambio AT 140 FORMAT 'x(11)':U
            lb-dupl       AT 152 FORMAT 'x(04)':U
            lb-tipo       AT 167 FORMAT 'x(04)':U
            lb-baseIva    AT 173
            lb-baseII     AT 182 SKIP
            "--------- ------------ ------- ---------------------------- --------- ------------------ ------------------ ------- ------------------ --------------- ---- --------------- -------- -------" SKIP.
        
        FOR EACH  tt-desp-nacion NO-LOCK
            WHERE tt-desp-nacion.sequencia > i-seq-nacionalizacao
            BREAK BY tt-desp-nacion.cod-emit-desp
                  BY tt-desp-nacion.sequencia:
            
            FIND emitente NO-LOCK
                 WHERE emitente.cod-emitente = tt-desp-nacion.cod-emit-desp NO-ERROR.
            

            PUT  tt-desp-nacion.cod-emit-desp AT 01   
                 emitente.nome-abrev          AT 11   
                 tt-desp-nacion.cod-desp      AT 25   
                 tt-desp-nacion.descricao     AT 32   
                 tt-desp-nacion.cod-cond-pag  AT 66   
                 tt-desp-nacion.val-desp      AT 70   
                 tt-desp-nacion.val-desp-mn   at 89  
                 tt-desp-nacion.mo-codigo     AT 114  
                 tt-desp-nacion.val-desp-orig AT 116  
                 tt-desp-nacion.de-cotacao    AT 136  
                 tt-desp-nacion.val-duplic    AT 152  
                 tt-desp-nacion.tipo          AT 157  
                 tt-desp-nacion.base-iva      AT 178  
                 tt-desp-nacion.base-ii       AT 186. 
            
            ASSIGN de-val-tot-desp      = de-val-tot-desp      + tt-desp-nacion.val-desp
                   de-val-tot-desp-mn   = de-val-tot-desp-mn   + tt-desp-nacion.val-desp-mn
                   de-val-tot-desp-orig = de-val-tot-desp-orig + tt-desp-nacion.val-desp-orig.
        END.
        
        PUT SKIP "------------------" AT 71
                 "------------------" AT 90
                 lb-totalDesp AT 55 FORMAT 'x(15)':U
                 de-val-tot-desp
                 de-val-tot-desp-mn.
    END.
    
    ASSIGN de-val-tot-desp      = 0
           de-val-tot-desp-mn   = 0
           de-val-tot-desp-orig = 0.
    
    PAGE.
    
    {include/i-rpclo.i}

    IF VALID-HANDLE(h-boin759na) THEN DO:
        RUN destroy IN h-boin759na.
        ASSIGN h-boin759na = ?.
    END.
    
RETURN 'OK':U.


/* Procedures Internas */

PROCEDURE pi-retornarDescricao:

    /* Objetivo: Retornar a descricao dos campos conforme a include padrao.
       Isto e necessario, pois alguns valores foram retirados das includes
       a partir da versao 2.06B */

    /* Definicao de Parametros */
    DEFINE INPUT  PARAMETER p-campo     AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-valor     AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-descricao AS CHARACTER NO-UNDO.

    /* Definicao de Variaveis */
    DEFINE VARIABLE c-lista   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-indice  AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE i-entrada AS INTEGER   NO-UNDO.

    /* Carregar lista com os valores para a propriedade Radio-Buttons de um Radio-Set */
    CASE p-campo:
        WHEN "desp-imp.tipo":U THEN ASSIGN c-lista = {cxinc/i01cx010.i 07}.
    END CASE.

    ASSIGN l-indice = NO.

    DO  i-entrada = 1 TO NUM-ENTRIES(c-lista):
        /* Os indices (numeros) somente estao nas entradas pares, por isto este controle */
        IF  l-indice THEN DO:
            ASSIGN l-indice = NO.

            /* Se entrada atual for igual ao valor do parametro, carregar descricao */
            IF  INTEGER(ENTRY(i-entrada, c-lista)) = p-valor THEN DO:
                ASSIGN p-descricao = ENTRY(i-entrada - 1, c-lista).
                LEAVE.
            END.
        END.
        ELSE
            ASSIGN l-indice = YES.
    END.

    /* Tratamento para ambiente Multi-Idioma */
    &IF "{&FNC_MULTI_IDIOMA}":U = "Yes":U &THEN
        RUN utp/ut-liter.p (input replace(trim(p-descricao)," ","_"),
                            INPUT "",
                            INPUT "").

        ASSIGN p-descricao = RETURN-VALUE.
    &ENDIF
    
END PROCEDURE.

PROCEDURE piTraduzLabels:
    
    ASSIGN lb-embarque     = fn-trad-label("Embarque:")
           lb-DI           = fn-trad-label("D.I.:")
           lb-moeda        = fn-trad-label("Moeda:")
           lb-fornec       = fn-trad-label("Fornecedor:")
           lb-txCambio     = fn-trad-label("Taxa_Cambio:")
           lb-txVarCambial = fn-trad-label("Taxa_Variaá∆o_Cambial:")
           lb-natOperacao  = fn-trad-label("Nat_Operacao:")
           lb-incotem      = fn-trad-label("Incoterm:")
           lb-classFiscal  = fn-trad-label("Class_Fiscal")
           lb-descricao    = fn-trad-label("Descricao")
           lb-seq          = fn-trad-label("Seq")
           lb-item         = fn-trad-label("Item")
           lb-qtde         = fn-trad-label("Qtde")
           lb-vlUnitMe     = fn-trad-label("Valor_Unit_ME")
           lb-totalME      = fn-trad-label("Total_ME")
           lb-totalMN      = fn-trad-label("Total_MN")
           lb-pesoBrutoTot = fn-trad-label("Peso_Bruto_Tot")
           lb-pesoLiqTot   = fn-trad-label("Peso_Liq_Tot")
           lb-imposto      = fn-trad-label("Imposto")
           lb-baseCalculo  = fn-trad-label("Base_Calculo")
           lb-valorMe      = fn-trad-label("Valor_ME")
           lb-valorMN      = fn-trad-label("Valor_MN")
           lb-fornDesp     = fn-trad-label("Forn_Desp")
           lb-nomeAbrev    = fn-trad-label("Nome_Abrev")
           lb-despesa      = fn-trad-label("Despesa")
           lb-condPgto     = fn-trad-label("Cond_Pgto")
           lb-vlDespME     = fn-trad-label("Valor_Despesa_MP")
           lb-moDespe      = fn-trad-label("Mo_Desp")
           lb-vlOrigMo     = fn-trad-label("Valor_Orig_MO")
           lb-taxaCambio   = fn-trad-label("Taxa_Cambio")
           lb-dupl         = fn-trad-label("Dupl")
           lb-tipo         = fn-trad-label("Tipo")
           lb-baseIva      = fn-trad-label("Base_IVA")
           lb-baseII       = fn-trad-label("Base_II")
           lb-totalQuant   = fn-trad-label("Total_quant")
           lb-subTotal     = fn-trad-label("Sub_total")
           lb-totalEmbarq  = fn-trad-label("Total_do_Embarque")
           lb-totalImpost  = fn-trad-label("Total_Impostos:")
           lb-despAtepto   = fn-trad-label("Despesas_ate_o_ponto_de_Nacionalizacao")
           lb-despApospto  = fn-trad-label("Despesas_apos_o_ponto_de_Nacionalizacao")
           lb-totalDesp    = fn-trad-label("Total_Despesas:")
           lb-vlDespMN     = fn-trad-label("Valor_Despesa_MN")
           lb-aliqII       = fn-trad-label("Al°q_II")
           lb-valorII      = fn-trad-label("Valor_II")
           lb-aliqEst      = fn-trad-label("Al°q_Est")
           lb-valorEst     = fn-trad-label("Valor_Est")
           lb-imposto-item  = fn-trad-label("Impostos_Item_Sequància")
           lb-imposto-total = fn-trad-label("Total_Impostos_Documento_Nacionalizaá∆o").
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piTotalizaDespEmbarque:

    /*
    ** Procedure respons vel por totalizar os valores das Despesas quando 
    ** a primeira remessa est† sendo gerado com a nota M∆e
    */

    DEFINE INPUT PARAMETER pc-cod-estabel-orig LIKE embarque-imp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pc-embarque-orig    LIKE embarque-imp.embarque    NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel      LIKE embarque-imp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pc-embarque         LIKE embarque-imp.embarque    NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-desp-embarque.

    FOR EACH desp-embarque
       WHERE desp-embarque.cod-estabel = pc-cod-estabel
         AND desp-embarque.embarque    = pc-embarque    NO-LOCK:

        FIND FIRST tt-desp-embarque
             WHERE tt-desp-embarque.cod-estabel       = pc-cod-estabel-orig
               AND tt-desp-embarque.embarque          = pc-embarque-orig
               AND tt-desp-embarque.cod-itiner        = desp-embarque.cod-itiner       
               AND tt-desp-embarque.cod-pto-contr     = desp-embarque.cod-pto-contr    
               AND tt-desp-embarque.cod-desp          = desp-embarque.cod-desp         
               AND tt-desp-embarque.cod-emitente-desp = desp-embarque.cod-emitente-desp EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAIL tt-desp-embarque THEN DO:
           CREATE tt-desp-embarque.
           BUFFER-COPY desp-embarque EXCEPT val-desp TO tt-desp-embarque.
           ASSIGN tt-desp-embarque.cod-estabel = pc-cod-estabel-orig
                  tt-desp-embarque.embarque    = pc-embarque-orig.
        END.
        ASSIGN tt-desp-embarque.val-desp = tt-desp-embarque.val-desp + desp-embarque.val-desp.
    END.

    RETURN "OK":U.

END.

PROCEDURE pi-busca-nota-mae:

    DEF OUTPUT PARAM pr-rowid AS ROWID NO-UNDO.

    DEF VAR l-sair AS LOG NO-UNDO.
    DEF VAR c-prox-embarq AS CHAR NO-UNDO.

    ASSIGN l-sair        = NO
           c-prox-embarq = docum-est.embarque.   

    REPEAT WHILE l-sair = NO:        

        /* N∆o encontrou nota para o embarque relacionado */
         IF NOT CAN-FIND(FIRST embarq-import-docto 
                         WHERE embarq-import-docto.cod-estab  = docum-est.cod-estabel 
                         AND   embarq-import-docto.cod-embarq = c-prox-embarq) THEN
            ASSIGN l-sair = YES. 


         FOR EACH embarq-import-docto FIELDS(cod-estab cod-embarq cod-ser-docto cod-docto cdn-emitente cod-natur-operac)
             WHERE embarq-import-docto.cod-estab  = docum-est.cod-estabel 
             AND   embarq-import-docto.cod-embarq = c-prox-embarq  NO-LOCK:

             /* verifica se Ç a nota m∆e */ 
             FOR FIRST b-docum-est FIELDS(serie-docto nro-docto cod-emitente nat-operacao idi-nf-simples-remes embarque) 
                  WHERE b-docum-est.serie-docto  = embarq-import-docto.cod-ser-docto             
                    AND b-docum-est.nro-docto    = embarq-import-docto.cod-docto                 
                    AND b-docum-est.cod-emitente = embarq-import-docto.cdn-emitente              
                    AND b-docum-est.nat-operacao = embarq-import-docto.cod-natur-operac NO-LOCK:
             END. 
             /* se for nota filha grava o embarque de origem para prΩxima busca */
             IF b-docum-est.idi-nf-simples-remes   = 2 THEN DO:
                FOR FIRST b-embarque-imp NO-LOCK                                                                                                           
                    WHERE b-embarque-imp.cod-estab = embarq-import-docto.cod-estab                                                                    
                    AND   b-embarque-imp.embarque  = c-prox-embarq:                  
                    ASSIGN c-prox-embarq = SUBSTRING(b-embarque-imp.char-1,21,20).    
                END.
             END. 
    
             IF b-docum-est.idi-nf-simples-remes   <> 1    THEN NEXT. /* Nota M∆e idi-nf-simples-remes = 1 */
             IF b-docum-est.embarque <> embarq-import-docto.cod-embarq THEN NEXT.
           
             ASSIGN l-sair = YES
                    pr-rowid = ROWID(b-docum-est).
           
         END.

         IF c-prox-embarq = "" THEN
            ASSIGN l-sair = YES. 
    END.

END.
