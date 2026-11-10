/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL,  sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM3100A 2.00.00.081 } /*** "010081" 09/09/2026 16:59:37 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im3100a MIM}
&ENDIF
 
/*******************************************************************************
**
** IM3100a - Integracao entre Importacao e Recebimento (EMS)
**
** Objetivo: Criacao dos arquivos tt-docum-est e tt-item-doc-est para posterior
**           geracao dos arquivos docum-est e item-doc-est ( EMS: REAPI316B.P). 
**
*******************************************************************************/

/************************** INICIO Variavel Global ****************************/
&GLOBAL-DEFINE excludeFrameDefinition YES 
/**************************** FIM Variavel Global *****************************/

/************************** INICIO PrÇ-processadores **************************/
{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}
/**************************** FIM PrÇ-processadores ***************************/
 
/****************************** INICIO TEMP-TABLE *****************************/

{include/boerrtab.i}              /* Definicao tt-bo-erro */
{cdp/cd0666.i}                    /* definiá∆o da temp-table de erros */
{inbo/boin090.i tt-docum-est} 
{inbo/boin176.i tt-item-doc-est}
{inbo/boin092.i tt-dupli-apagar}
{inbo/boin567.i tt-dupli-imp}
{inbo/boin366.i tt-rat-docum}
{inbo/boin01066.i tt-docto-estoq-internac}
{imp/im7777.i1}
{imp/im3100a.i}
{imp/im0091.i}                    /* Definiá∆o temp-table p/ Rateio Despesas */
{cdp/cd1234.i}    /* Validaá∆o Decimais */
{include/i-epc200.i im3100a}

DEF TEMP-TABLE tt-retorno          NO-UNDO LIKE tt-bo-erro.
DEF TEMP-TABLE tt-dupli-apagar2    NO-UNDO LIKE tt-dupli-apagar.
{inbo/boin759.i tt-impto-item-docto}

define temp-table tt-embarque-filho-aux no-undo
   field cod-estabel like embarque-imp.cod-estabel
   field embarque    like embarque-imp.embarque.

DEF TEMP-TABLE tt-desp-comp NO-UNDO
    FIELD cod-desp  AS INT
    FIELD mo-codigo AS INT
    FIELD dt-cotac  AS DATE
    FIELD cotacao   AS DEC.

DEF TEMP-TABLE tt-imposto NO-UNDO
    FIELD cod-estabel     AS CHAR    FORMAT "X(3)"
    FIELD nat-operacao    AS CHAR    FORMAT "X(6)"
    FIELD nome-pais	      AS CHAR    FORMAT "X(20)"
    FIELD cod-estado      AS CHAR    FORMAT "X(4)"
    FIELD nom-cidade	  AS CHAR    FORMAT "X(25)"
    FIELD fm-codigo	      AS CHAR    FORMAT "X(8)"
    FIELD it-codigo	      AS CHAR    FORMAT "X(16)"
    FIELD cdn-imposto     AS INTEGER
    FIELD tipo-imposto    AS INTEGER 
    INDEX imposto IS PRIMARY UNIQUE cod-estabel
                                    nat-operacao
                                    nome-pais
                                    cod-estado
                                    nom-cidade
                                    fm-codigo
                                    it-codigo
                                    cdn-imposto
                                    tipo-imposto.

def temp-table tt-erro-316b no-undo
	field identif-segment as char
	field cd-erro         as integer
	field desc-erro       as char format "x(80)".

def temp-table tt-erro-402 no-undo
	field identif-segment as char
	field cd-erro         as integer
	field desc-erro       as char format "x(80)".

DEF TEMP-TABLE tt-erro-aux NO-UNDO
    FIELD i-sequen AS INT             
    FIELD cd-erro  AS INT
    FIELD mensagem AS CHAR FORMAT "x(255)"
    FIELD c-param  AS CHAR.

/******************************** FIM TEMP-TABLE ******************************/

/****************************** INICIO Parametro ******************************/

DEF INPUT  PARAMETER TABLE FOR tt-nota.
DEF INPUT  PARAMETER TABLE FOR tt-itens.
DEF INPUT  PARAMETER TABLE FOR tt-docto-estoq-internac.
DEF OUTPUT PARAMETER TABLE FOR tt-erro.
DEF OUTPUT PARAMETER TABLE FOR tt-retorno.

/******************************** FIM Parametro *******************************/

/****************************** INICIO Variaveis ******************************/
DEF NEW GLOBAL SHARED VAR l-nff          AS LOG INIT NO NO-UNDO.
def new global shared var i-pais-impto-usuario as integer format ">>9" no-undo.

DEF VAR c-docto-aux           AS CHARACTER FORMAT "x(16)"   NO-UNDO.
DEF VAR c-familia             AS CHARACTER                  NO-UNDO.
DEF VAR c-item                AS CHARACTER                  NO-UNDO.
DEF VAR c-estabel             AS CHARACTER                  NO-UNDO.
DEF VAR c-pais                AS CHARACTER                  NO-UNDO.
DEF VAR c-uf                  AS CHARACTER                  NO-UNDO.
DEF VAR c-cidade              AS CHARACTER                  NO-UNDO.
DEF VAR c-nat-oper            AS CHARACTER                  NO-UNDO.
DEF VAR i-imp-retido          AS INTEGER                    NO-UNDO. 
DEF VAR i-nat-imp             AS INTEGER                    NO-UNDO.
DEF VAR i-emitente            AS INTEGER                    NO-UNDO.
DEF VAR i-emit-natur          AS INTEGER                    NO-UNDO.
DEF VAR i-cod-tax-aux         AS INTEGER                    NO-UNDO.
DEF VAR i-cod-tax-ganan       AS INTEGER                    NO-UNDO.
DEF VAR i-parcela             AS INT                        NO-UNDO.
DEF VAR i-msg                 AS INT                        NO-UNDO.
DEF VAR c-msg                 AS CHAR                       NO-UNDO.
DEF VAR c-char                AS CHAR                       NO-UNDO.
DEF VAR i-seq                 AS INT                        NO-UNDO INIT 0.
DEF VAR i-seq-aux             AS INT                        NO-UNDO INIT 0.
DEF VAR i-ind                 AS INT                        NO-UNDO INIT 0.
DEF VAR i-seq-erro            AS INT                        NO-UNDO INIT 0.
DEF VAR i-avanco              AS INT                        NO-UNDO.
DEF VAR i-seq-item-doc-est    AS INTEGER                    NO-UNDO.
DEF VAR l-imp                 AS LOGICAL                    NO-UNDO.
DEF VAR l-fornec-imp          AS LOGICAL                    NO-UNDO.
DEF VAR l-iva-normal          AS LOGICAL                    NO-UNDO.
DEF VAR l-acomp               AS LOGICAL                    NO-UNDO INITIAL NO.
DEF VAR h-acomp               AS HANDLE                     NO-UNDO.
DEF VAR c-acomp               AS CHAR                       NO-UNDO.
DEF VAR l-first-numero-ordem  AS LOGICAL                    NO-UNDO.
DEF VAR l-loc-unica           AS LOGICAL                    NO-UNDO.
DEF VAR de-vl-imposto-me      AS DECIMAL                    NO-UNDO.
DEF VAR de-vl-imposto         AS DECIMAL                    NO-UNDO.
DEF VAR de-vl-base-calc       AS DECIMAL                    NO-UNDO.
DEF VAR de-cot-var-cambial    AS DECIMAL                    NO-UNDO.
DEF VAR i-moeda-material      AS INTEGER                    NO-UNDO.
DEF VAR c-texto1              AS CHARACTER FORMAT "x(13)"   NO-UNDO.
DEF VAR c-texto2              AS CHARACTER FORMAT "x(13)"   NO-UNDO.
DEF VAR c-texto3              AS CHARACTER FORMAT "x(13)"   NO-UNDO.
DEF VAR c-lb-remes            AS CHARACTER FORMAT "x(13)"   NO-UNDO.
DEF VAR i-cod-tax-isd         AS INTEGER                    NO-UNDO.

{cdp/cd4300.i3}    /* Include tratamento atributo livre       */
{cxbo/bocx250.i50} /* Atributo livre parametros de importacao */
{rep/re1001c.i50}  /* vari†veis e informaá‰es utilizadas pelo re1001c.i51 */

DEF VAR de-base-ipi        LIKE desp-embarque.val-desp      NO-UNDO.
DEF VAR de-base-icm        LIKE desp-embarque.val-desp      NO-UNDO.
DEF VAR de-frete           LIKE desp-embarque.val-desp      NO-UNDO EXTENT 0.
DEF VAR de-seguro          LIKE desp-embarque.val-desp      NO-UNDO EXTENT 0.
DEF VAR de-embal           LIKE desp-embarque.val-desp      NO-UNDO EXTENT 0. 
DEF VAR de-outras          LIKE desp-embarque.val-desp      NO-UNDO EXTENT 0.
DEF VAR de-tot-seguro      LIKE desp-embarque.val-desp      NO-UNDO EXTENT 0.
DEF VAR de-tot-embal       LIKE desp-embarque.val-desp      NO-UNDO EXTENT 0.
DEF VAR de-tot-outras      LIKE desp-embarque.val-desp      NO-UNDO EXTENT 0.
DEF VAR c-cod-localiz      LIKE tt-item-doc-est.cod-localiz NO-UNDO.

DEF VAR de-despesa-nota    LIKE desp-embarque.val-desp      NO-UNDO.
DEF VAR de-valor-frete     LIKE desp-embarque.val-desp      NO-UNDO.
DEF VAR de-valor-seguro    LIKE desp-embarque.val-desp      NO-UNDO.
DEF VAR de-valor-embal     LIKE desp-embarque.val-desp      NO-UNDO.
DEF VAR de-valor-outras    LIKE desp-embarque.val-desp      NO-UNDO.
DEF VAR de-tot-frete      LIKE desp-embarque.val-desp      NO-UNDO.
DEF VAR de-tot-frete-me   LIKE desp-embarque.val-desp      NO-UNDO.
DEF VAR de-despesa-item   LIKE desp-embarque.val-desp      NO-UNDO.
/* ***** Arredondamento do valor das despesas para os itens ***** */
DEF VAR de-tot-resto       LIKE desp-embarque.val-desp      NO-UNDO.
DEF VAR de-tot-resto-frete LIKE desp-embarque.val-desp      NO-UNDO.
DEF VAR de-tot-seguro-aux  LIKE desp-embarque.val-desp      NO-UNDO.
DEF VAR de-tot-embal-aux   LIKE desp-embarque.val-desp      NO-UNDO.
DEF VAR de-tot-outras-aux  LIKE desp-embarque.val-desp      NO-UNDO.
/******************************** FIM Variaveis *******************************/

/******************************* INICIO Buffer *******************************/
DEF BUFFER b-emit-estab      FOR emitente.
DEF BUFFER b-item            FOR ITEM.
DEF BUFFER b-tt-dupli-apagar FOR tt-dupli-apagar.
DEF BUFFER b-tt-itens        FOR tt-itens.
DEF BUFFER btipo-tax         FOR tipo-tax.
DEF BUFFER b-embarque-imp    FOR embarque-imp.
/******************************** FIM Buffer **********************************/

DEFINE VARIABLE h-bocx250na     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boar2006      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bopy2006      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-reapi402      AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin01066     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boar2016      AS HANDLE NO-UNDO.
def var dat-tipo-dia   like calen-coml.tipo-dia no-undo. /*CD9020.i7*/
DEFINE VARIABLE l-transf        AS LOGICAL INITIAL NO    NO-UNDO.
DEF VAR de-total LIKE desp-embarque.val-desp NO-UNDO.
DEF VAR de-val-preco-unit-com-iva AS DECIMAL NO-UNDO.
DEF VAR d-preco-total LIKE tt-item-doc-est.preco-total-me NO-UNDO.

DEF VAR d-valor-item-docto    LIKE desp-embarque.val-desp NO-UNDO.
DEF VAR d-valor-item-docto-me LIKE desp-embarque.val-desp NO-UNDO.
def var i-cod-desp-ii      like desp-imp.cod-desp      no-undo.
def var i-cod-desp-est     like desp-imp.cod-desp      no-undo.
def var i-cod-emitente-ii  like emitente.cod-emitente  no-undo.
def var i-cod-emitente-est like emitente.cod-emitente  no-undo.

/* procedure pi-busca-portador-modalidade */
{cdp/cd9900.i5}

FIND FIRST tt-nota NO-ERROR.

ASSIGN l-acomp = tt-nota.pl-acomp
       h-acomp = tt-nota.ph-acomp.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST param-cq     NO-LOCK NO-ERROR.

FIND emitente NO-LOCK
     WHERE emitente.cod-emitente   = tt-nota.cod-emitente NO-ERROR.

FIND natur-oper NO-LOCK
     WHERE natur-oper.nat-operacao = tt-nota.nat-operacao NO-ERROR.

FIND estabelec NO-LOCK
     WHERE estabelec.cod-estabel = tt-nota.cod-estabel NO-ERROR.

FIND b-emit-estab NO-LOCK
     WHERE b-emit-estab.cod-emitente = estabelec.cod-emitente NO-ERROR.

FIND param-re NO-LOCK
     WHERE param-re.usuario = tt-nota.usuario NO-ERROR.

FIND serie NO-LOCK
     WHERE serie.serie = tt-nota.serie-docto NO-ERROR.

FIND param-imp
    WHERE param-imp.cod-estabel = tt-nota.cod-estabel NO-LOCK NO-ERROR.

FIND FIRST param-estoq-internac NO-LOCK NO-ERROR.

/* ***** Inicia Acompanhamento ***** */
IF l-acomp THEN DO:
    {utp/ut-liter.i Consiste_documento... * L}
    ASSIGN c-acomp = TRIM(RETURN-VALUE).
    RUN pi-acompanhar IN h-acomp (INPUT c-acomp).
END.

/* ***** Consiste se o documento ja existe no recebimento ***** */
FIND docum-est NO-LOCK
    WHERE docum-est.serie-docto  = tt-nota.serie-docto
      AND docum-est.nro-docto    = tt-nota.nro-docto
      AND docum-est.cod-emitente = tt-nota.cod-emitente
      AND docum-est.nat-operacao = tt-nota.nat-operacao NO-ERROR.
IF  AVAIL docum-est THEN DO:
    ASSIGN i-msg  = 5569
           c-msg  = STRING(tt-nota.nro-docto)
           c-char = "".
    RUN pi-gera-erro.
END.

/* ***** Consiste numero da nota ***** */
IF param-global.modulo-ft AND natur-oper.imp-nota THEN
    RUN pi-consiste-numero.

/* ***** Cria temp-tables de cabecalho da nota ***** */
RUN pi-gera-docto.

ASSIGN de-cot-var-cambial = 0.
IF l-nff AND AVAIL param-estoq-internac AND param-estoq-internac.log-atu-ce-var-camb
         AND AVAIL param-imp AND param-imp.log-descons-iva-tit-mercad THEN DO:
    FOR FIRST tt-docto-estoq-internac NO-LOCK:
        ASSIGN de-cot-var-cambial = tt-docto-estoq-internac.cotacao-ce.
    END.
END.

{cdp/cd4300.i4 "yes" param-imp.char-1}
{cxbo/bocx250.i51 "yes"}

/* ***** Cria temp-tables de despesas do embarque ***** */
run pi-gera-tt-despesas.

IF  CAN-FIND (FIRST tt-erro) THEN
    RETURN.

FIND FIRST tt-docum-est NO-ERROR.

IF  param-global.modulo-07 THEN DO:
    IF  tt-nota.embarque <> "" THEN
        ASSIGN l-imp = YES.
    IF  AVAIL emitente
    AND emitente.pais <> estabelec.pais THEN
        ASSIGN l-fornec-imp = YES.
END.

/* ***** Cria Itens do Documento ***** */ 
FOR EACH tt-itens
    BREAK BY numero-ordem:

    ASSIGN l-first-numero-ordem = NO.
    IF FIRST-OF(tt-itens.numero-ordem) THEN
       ASSIGN l-first-numero-ordem = YES.
    
    FIND item NO-LOCK
         WHERE item.it-codigo = tt-itens.it-codigo NO-ERROR.
    
    FIND ordem-compra NO-LOCK
         WHERE ordem-compra.numero-ordem = tt-itens.numero-ordem NO-ERROR.

    FIND ordens-embarque NO-LOCK
        WHERE ordens-embarque.cod-estabel = tt-nota.cod-estabel
          AND ordens-embarque.embarque    = tt-nota.embarque NO-ERROR.
    
    ASSIGN de-frete      = 0
           de-seguro     = 0
           de-embal      = 0
           de-outras     = 0
           de-base-ipi   = 0
           de-base-icm   = 0
           de-tot-frete  = 0
           de-despesa-item = 0.
    
    IF  l-acomp THEN DO:
        {utp/ut-liter.i Consiste_itens... * L}
        ASSIGN c-acomp = TRIM(RETURN-VALUE).
        RUN pi-acompanhar IN h-acomp (INPUT c-acomp).
    END.
    
    FIND item-uni-estab NO-LOCK
         WHERE item-uni-estab.it-codigo   = ordem-compra.it-codigo
           AND item-uni-estab.cod-estabel = ordem-compra.cod-estabel NO-ERROR.
    IF  AVAIL item-uni-estab THEN
        ASSIGN l-loc-unica = item-uni-estab.loc-unica
               c-cod-localiz = item-uni-estab.cod-localiz.
    ELSE 
        ASSIGN l-loc-unica   = item.loc-unica
               c-cod-localiz = item.cod-localiz.
    
    IF i-seq-item-doc-est = 0 THEN
        ASSIGN i-seq-item-doc-est = param-re.seq-item-um.
    ELSE
        ASSIGN i-seq-item-doc-est = i-seq-item-doc-est + param-re.inc-seq.
    
    CREATE tt-item-doc-est.
    ASSIGN tt-itens.sequencia               = i-seq-item-doc-est.

    ASSIGN tt-item-doc-est.cod-emitente     = tt-docum-est.cod-emitente
           tt-item-doc-est.nat-operacao     = tt-docum-est.nat-operacao
           tt-item-doc-est.nro-docto        = tt-docum-est.nro-docto
           tt-item-doc-est.serie-docto      = tt-docum-est.serie-docto
           tt-item-doc-est.sequencia        = i-seq-item-doc-est
           tt-item-doc-est.quantidade       = tt-itens.quantidade
           tt-item-doc-est.qt-saldo         = tt-item-doc-est.quantidade
           tt-item-doc-est.preco-unit[1]    = tt-itens.preco-unit
           tt-item-doc-est.preco-unit-me    = tt-itens.preco-unit / tt-nota.cotacao-dia
           tt-item-doc-est.lote             = tt-itens.lote
           tt-item-doc-est.dt-vali-lote     = tt-itens.dt-vali-lote
           tt-item-doc-est.cod-refer        = tt-itens.cod-refer
           tt-item-doc-est.encerra-pa       = tt-itens.encerra-pa
           tt-item-doc-est.parcela          = tt-itens.parcela
           tt-item-doc-est.cod-depos        = tt-itens.cod-depos
           tt-item-doc-est.it-codigo        = ordem-compra.it-codigo
           tt-item-doc-est.num-pedido       = tt-itens.num-pedido
           tt-item-doc-est.numero-ordem     = ordem-compra.numero-ordem
           tt-item-doc-est.nr-ord-produ     = ordem-compra.ordem-servic
           tt-item-doc-est.narrativa        = ordem-compra.narrativa
           
           tt-item-doc-est.ct-codigo   = IF  ordem-compra.ct-codigo = ""
                                             AND (item.tipo-contr = 1 OR item.tipo-contr = 4) THEN
                                                  item.ct-codigo
                                              ELSE
                                                  ordem-compra.ct-codigo

           tt-item-doc-est.sc-codigo   = IF  ordem-compra.sc-codigo = ""
                                             AND (item.tipo-contr = 1 OR item.tipo-contr = 4) THEN
                                                  item.sc-codigo
                                              ELSE
                                                  ordem-compra.sc-codigo
           
           tt-item-doc-est.cod-localiz      = c-cod-localiz
           tt-item-doc-est.class-fiscal     = tt-itens.class-fiscal
           tt-item-doc-est.peso-liquido     = tt-itens.peso-liquido
           tt-item-doc-est.nr-proc-imp      = tt-itens.nr-proc-imp
           tt-item-doc-est.desconto[1]      = 0
           tt-item-doc-est.baixa-ce         = YES
           tt-item-doc-est.valor-iss        = 0
           tt-item-doc-est.vl-subs          = 0
           tt-item-doc-est.nr-ato-concessorio = tt-itens.nr-ato-concessorio
           OVERLAY(tt-item-doc-est.char-2,940,1) = "N":U.
           
     IF  tt-nota.idi-nf-simples-remes = 2 /* Nota Filha */
     AND natur-oper.tp-oper-terc      = 4 /* Faturamento Consignacao */
     THEN
         ASSIGN tt-item-doc-est.cod-unid-negoc = ordem-compra.cod-unid-negoc.

     if  tt-nota.l-nf-simples-remessa 
     and tt-nota.idi-nf-simples-remes = 1 then do: /** nota mae **/ 
         assign tt-item-doc-est.ct-codigo = tt-nota.ct-codigo
                tt-item-doc-est.sc-codigo = tt-nota.sc-codigo. 
     end.

     if  tt-nota.l-nf-simples-remessa
      and tt-nota.idi-nf-simples-remes = 2 then  /** nf simples remessa filha **/   
          assign tt-item-doc-est.nr-ato-concessorio = "":U.    


    IF  natur-oper.tipo = 1 AND NOT natur-oper.terceiros
    OR (natur-oper.tp-oper-terc <> 1    /* Remessa Beneficiamento   */  
    AND natur-oper.tp-oper-terc <> 2    /* Retorno Beneficiamento   */ 
    AND natur-oper.tp-oper-terc <> 8    /* Remessa Dep¢sito Fechado */ 
    AND natur-oper.tp-oper-terc <> 9    /* Retorno Dep¢sito Fechado */
    AND natur-oper.tp-oper-terc <> 10   /* Remessa ArmazÇm Geral    */
    AND natur-oper.tp-oper-terc <> 11)  /* Retorno ArmazÇm Geral    */ THEN DO:
        IF  param-global.modulo-cq
        AND param-cq.tipo-cq > 1
        AND natur-oper.transf = NO
        AND AVAIL item-uni-estab
        AND item-uni-estab.contr-qualid
        AND item.it-codigo <> "" THEN
            RUN pi-skip-lote.
    END.
    
    FIND item-fornec NO-LOCK
         WHERE item-fornec.it-codigo    = tt-item-doc-est.it-codigo
           AND item-fornec.cod-emitente = tt-item-doc-est.cod-emitente NO-ERROR.
    IF  AVAIL item-fornec THEN
        ASSIGN tt-item-doc-est.qt-do-forn = tt-item-doc-est.quantidade
                                          * (item-fornec.fator-conver /
                                             IF  item-fornec.num-casa-dec = 0 THEN 1
                                             ELSE EXP(10,item-fornec.num-casa-dec)).
    ELSE
        ASSIGN tt-item-doc-est.qt-do-forn = tt-item-doc-est.quantidade.
    
    IF  tt-item-doc-est.nr-ord-produ <> 0 
        AND NOT l-transf /*Embarque de transferencia de Drawback n∆o deve fazer nenhum tipo de reserva na produá∆o, pois a mercadoria j† est† no estoque e essa nota somente Ç gerada para pagto dos impostos*/ 
        THEN DO:
        FIND FIRST reservas NO-LOCK
             WHERE reservas.nr-ord-produ = tt-item-doc-est.nr-ord-produ
               AND reservas.it-codigo   = tt-item-doc-est.it-codigo NO-ERROR.
        IF  NOT AVAIL reservas THEN DO:
            ASSIGN tt-item-doc-est.item-pai = "".
            
            /*
             * N∆o exige reserva para ordens de produá∆o de itens de pol°tica configurado e controlado por referància
             */
            FIND ord-prod NO-LOCK
                 WHERE ord-prod.nr-ord-produ = tt-item-doc-est.nr-ord-produ NO-ERROR.
            IF  AVAIL ord-prod THEN DO:
                FIND b-item NO-LOCK
                     WHERE b-item.it-codigo = ord-prod.it-codigo NO-ERROR.
                IF  AVAIL b-item THEN DO:
                    IF  b-item.politica     = 5 AND /* configurado */
                        b-item.tipo-con-est = 4 THEN /* referància  */
                        ASSIGN tt-item-doc-est.item-pai = "".
                    
                    IF  b-item.tipo-contr = 4 THEN /* DÇbito Direto */
                        ASSIGN tt-item-doc-est.item-pai = "".
                END.
            END.
            
            IF  ITEM.tipo-contr = 4 THEN /* DÇbito Direto */
                ASSIGN tt-item-doc-est.item-pai = "".
            
            ASSIGN tt-item-doc-est.cod-roteiro = ""
                   tt-item-doc-est.op-codigo   = 0.
        END.
        ELSE DO:
            ASSIGN tt-item-doc-est.item-pai    = reservas.item-pai
                   tt-item-doc-est.cod-roteiro = reservas.cod-roteiro
                   tt-item-doc-est.op-codigo   = reservas.op-codigo.
        END.
    END.


    
    IF  l-acomp THEN DO:
        {utp/ut-liter.i Despesas_dos_itens... * L}
        ASSIGN c-acomp = TRIM(RETURN-VALUE).
        RUN pi-acompanhar IN h-acomp (INPUT c-acomp).
    END.
    
    /* ***** Despesas dos itens ***** */ 
    RUN pi-despesas.
    

    ASSIGN de-tot-seguro = de-tot-seguro + de-seguro
           de-tot-embal  = de-tot-embal  + de-embal
           de-tot-outras = de-tot-outras + de-outras.
    
    IF  l-acomp THEN DO:
        {utp/ut-liter.i Calculo_IPI/ICMS... * L}
        ASSIGN c-acomp = TRIM(RETURN-VALUE).
        RUN pi-acompanhar IN h-acomp (INPUT c-acomp).
    END.
    
    ASSIGN de-total = (de-frete  * tt-nota.cotacao-dia) + (de-seguro * tt-nota.cotacao-dia) + (de-embal  * tt-nota.cotacao-dia) + (de-outras * tt-nota.cotacao-dia).

    ASSIGN tt-item-doc-est.despesas[1]    = ROUND(de-total,2)
           tt-item-doc-est.preco-total[1] = tt-itens.preco-total
           tt-item-doc-est.preco-total-me = tt-itens.preco-total / tt-nota.cotacao-dia.          
          
    
    IF tt-itens.l-ordens-embarque AND item.tipo-con-est = 2 THEN DO: 
       FIND ordens-embarque NO-LOCK
           WHERE ordens-embarque.cod-estabel   = tt-nota.cod-estabel
             AND ordens-embarque.embarque      = tt-nota.embarque
             AND ordens-embarque.numero-ordem  = tt-item-doc-est.numero-ordem
             AND ordens-embarque.parcela       = tt-item-doc-est.parcela NO-ERROR.
       if AVAIL ordens-embarque THEN
          ASSIGN tt-item-doc-est.peso-liquido = tt-item-doc-est.peso-liquido / ordens-embarque.quantidade.
    END.
    
    /* ***** Acumula totais ***** */
    ASSIGN tt-docum-est.tot-peso       = tt-docum-est.tot-peso       + tt-item-doc-est.peso-liquido
           tt-docum-est.valor-frete-me = tt-docum-est.valor-frete-me + tt-item-doc-est.pr-total-cmi
           tt-docum-est.valor-mercad   = tt-docum-est.valor-mercad   + tt-itens.preco-total
           de-tot-frete-me             = de-tot-frete-me             + de-tot-frete
           tt-docum-est.despesa-nota   = tt-docum-est.despesa-nota   + tt-item-doc-est.despesas[1].

    IF i-pais-impto-usuario <> 1 THEN DO:   
        /* Documento Relacionado */
        ASSIGN tt-item-doc-est.nro-comp   = tt-itens.nro-comp
               tt-item-doc-est.nat-comp   = tt-itens.nat-comp
               tt-item-doc-est.serie-comp = tt-itens.serie-comp
               tt-item-doc-est.seq-comp   = tt-itens.seq-comp.
    END.           
END.

IF  CAN-FIND (FIRST tt-erro) THEN
    RETURN.

IF  NOT CAN-FIND (FIRST tt-item-doc-est) THEN
    RETURN.

/* ***** Arredondamento dos valores das despesas do item  ***** */
RUN pi-arredondamento-itens.

/* ***** Arredondamento dos valores das despesas no documento  ***** */
ASSIGN tt-docum-est.valor-seguro-me = de-tot-seguro + (de-tot-seguro-aux - de-tot-seguro)
       tt-docum-est.valor-embal-me  = de-tot-embal  + (de-tot-embal-aux  - de-tot-embal)
       tt-docum-est.valor-outras-me = de-tot-outras + (de-tot-outras-aux - de-tot-outras)
       tt-docum-est.despesa-nota-me = (tt-docum-est.valor-frete-me + tt-docum-est.valor-seguro-me + tt-docum-est.valor-embal-me + tt-docum-est.valor-outras-me)
       tt-docum-est.valor-mercad-me = tt-docum-est.valor-mercad / tt-nota.cotacao-dia
       tt-docum-est.tot-valor-me    = tt-docum-est.valor-mercad-me + tt-docum-est.despesa-nota-me.  

/* ***** Verifica se ser† gerado duplicatas ***** */
IF  natur-oper.emite-duplic 
    AND NOT l-transf /*Para o tipo transferància deve ser gerado o t°tulo no final ap¢s o calculo dos impostos*/ THEN DO:
    RUN pi-gera-duplicata (OUTPUT TABLE tt-dupli-apagar).
    
END.

if  tt-nota.l-nf-simples-remessa 
and tt-nota.idi-nf-simples-remes = 1 then do:  /** nf simples remessa e nf simples remessa mae **/ 
    for each  tt-item-doc-est
        where tt-item-doc-est.serie-docto  = tt-docum-est.serie-docto
        and   tt-item-doc-est.nro-docto    = tt-docum-est.nro-docto
        and   tt-item-doc-est.cod-emitente = tt-docum-est.cod-emitente
        and   tt-item-doc-est.nat-operacao = tt-docum-est.nat-operacao:        
        assign tt-item-doc-est.baixa-ce = no.
    end.
end.

IF  l-acomp THEN DO:
    {utp/ut-liter.i Gerando_documento... * L}
    ASSIGN c-acomp = TRIM(RETURN-VALUE).
    RUN pi-acompanhar in h-acomp (INPUT c-acomp).
END.

/* Necess†rio transaá∆o para n∆o criar o documento no recebimento quando houver erro no reapi402 */
DO TRANS:

    /* Se existe registro na tabela de erro, n∆o executa a l¢gica da transaá∆o */
    IF CAN-FIND (FIRST tt-erro) THEN
        UNDO, LEAVE.

    /* ***** Executa programa para a geracao do documento no recebimento ***** */
    RUN rep/reapi316b.p (INPUT 'ADD',
                         INPUT TABLE tt-docum-est,
                         INPUT TABLE tt-rat-docum,
                         INPUT TABLE tt-item-doc-est,
                         INPUT TABLE tt-dupli-apagar,
                         INPUT TABLE tt-dupli-imp,
                         OUTPUT TABLE tt-erro-316b).
    
    IF  NOT CAN-FIND (FIRST tt-erro-316b) THEN DO:
    
        FIND FIRST tt-docum-est NO-LOCK NO-ERROR.
        FIND FIRST tt-nota NO-LOCK NO-ERROR.    
    
        RUN piImpostos.
    
        FIND FIRST tt-docum-est NO-LOCK NO-ERROR.
        FIND FIRST tt-nota NO-LOCK NO-ERROR.
    
        IF AVAIL tt-docum-est AND AVAIL tt-nota THEN DO:
    
            IF  l-transf THEN DO:
                RUN pi-trata-transf-drb.
    
                IF CAN-FIND(FIRST tt-erro) THEN
                    UNDO, LEAVE.
            END.
    
            IF natur-oper.emite-duplic THEN DO:
                IF  NOT VALID-HANDLE(h-reapi402) THEN
                    RUN rep/reapi402.p PERSISTENT SET h-reapi402.
                
                IF tt-nota.d-cotacao <> 0 THEN
                    RUN setaValorCotacao IN h-reapi402 (INPUT tt-nota.d-cotacao).
                
                RUN pi-gera-duplicatas-impostos IN h-reapi402 (INPUT  tt-docum-est.cod-emitente,
                                                               INPUT  tt-docum-est.nat-operacao,
                                                               INPUT  tt-docum-est.nro-docto   ,
                                                               INPUT  tt-docum-est.serie-docto ,
                                                               INPUT  tt-nota.da-cotacao,
                                                               INPUT  de-cot-var-cambial,
                                                               OUTPUT TABLE tt-erro-402).    

                FOR EACH tt-erro-402:
                    ASSIGN i-msg = tt-erro-402.cd-erro
                           c-msg = tt-erro-402.desc-erro
                           c-char= "".
                    
                    RUN pi-gera-erro.
                END.
                
                                            
                IF VALID-HANDLE(h-reapi402) THEN DO:
                    DELETE PROCEDURE h-reapi402.  
                    ASSIGN h-reapi402 = ?.
                END.            

                IF CAN-FIND(FIRST tt-erro-402) THEN
                    UNDO, LEAVE.
            END.
    
            /* Cria extens∆o docto-estoq-internac */
            IF  (CAN-FIND(FIRST tt-docto-estoq-internac) OR i-pais-impto-usuario = 21)
            AND CAN-FIND(FIRST docum-est
                         WHERE docum-est.serie-docto   = tt-docum-est.serie-docto
                           AND docum-est.nro-docto     = tt-docum-est.nro-docto
                           AND docum-est.cod-emitente  = tt-docum-est.cod-emitente
                           AND docum-est.nat-operacao  = tt-docum-est.nat-operacao) 
            AND NOT CAN-FIND(FIRST tt-erro-402) THEN DO:
    
                IF  NOT VALID-HANDLE(h-boin01066) THEN
                    RUN inbo/boin01066.p PERSISTENT SET h-boin01066.
    
                FIND FIRST tt-docto-estoq-internac EXCLUSIVE-LOCK NO-ERROR.
    
                IF  NOT AVAIL tt-docto-estoq-internac THEN DO:
                    FIND embarque-imp NO-LOCK
                        WHERE embarque-imp.cod-estabel = tt-nota.cod-estabel
                          AND embarque-imp.embarque    = tt-nota.embarque NO-ERROR.
                
                    CREATE tt-docto-estoq-internac.
                    ASSIGN tt-docto-estoq-internac.data-di = embarque-imp.data-di.
                END.
                ASSIGN tt-docto-estoq-internac.cod-emitente = tt-docum-est.cod-emitente
                       tt-docto-estoq-internac.nat-operacao = tt-docum-est.nat-operacao
                       tt-docto-estoq-internac.nro-docto    = tt-docum-est.nro-docto
                       tt-docto-estoq-internac.serie-docto  = tt-docum-est.serie-docto.            
    
                if  i-pais-impto-usuario = 21 /*Ecuador*/ 
                and l-nff = yes then
                    assign tt-docto-estoq-internac.idi-tip-comprov = 6.
    
                RUN openQueryStatic IN h-boin01066 (INPUT "Main":U).
                RUN emptyRowErrors  IN h-boin01066.
                RUN setRecord       IN h-boin01066 (INPUT TABLE tt-docto-estoq-internac).
                RUN createRecord    IN h-boin01066.
                RUN destroy         IN h-boin01066.
                
            END.
    
            &if defined(bf_mat_nf_simp_remes_desp_imp) &then        
                run imp/im9049.p (input tt-docum-est.serie-docto,   
                                  input tt-docum-est.nro-docto,     
                                  input tt-docum-est.cod-emitente,  
                                  input tt-docum-est.nat-operacao,
                                  input tt-nota.l-nf-simples-remessa,
                                  input tt-nota.idi-nf-simples-remes).  
            &endif 
    
            /*** Atualiza dados aduana Argentina ***/
            IF  i-pais-impto-usuario = 2
            AND CAN-FIND(FIRST docum-est
                         WHERE docum-est.serie-docto   = tt-docum-est.serie-docto
                           AND docum-est.nro-docto     = tt-docum-est.nro-docto
                           AND docum-est.cod-emitente  = tt-docum-est.cod-emitente
                           AND docum-est.nat-operacao  = tt-docum-est.nat-operacao) THEN DO:
    
                IF  NOT VALID-HANDLE(h-boar2016) THEN
                    RUN local/arg/boar2016.p PERSISTENT SET h-boar2016.
    
                RUN pi-atualiza-dados-imp IN h-boar2016 (INPUT tt-docum-est.cod-emitente,
                                                         INPUT tt-docum-est.nat-operacao,
                                                         INPUT tt-docum-est.nro-docto,
                                                         INPUT tt-docum-est.serie-docto).
                RUN destroy IN h-boar2016.
            END.
        END.
    
    END.
  
END.

IF c-nom-prog-upc-mg97 <> "" THEN DO:

    FOR EACH tt-epc
        WHERE tt-epc.cod-event = "After_piImpostos":U:
        DELETE tt-epc.
    END.

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "After_piImpostos":U
           tt-epc.cod-parameter = "Table_tt-docum-est"
           tt-epc.val-parameter = STRING(TEMP-TABLE tt-docum-est:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "After_piImpostos":U
           tt-epc.cod-parameter = "Table_tt-nota"
           tt-epc.val-parameter = STRING(TEMP-TABLE tt-nota:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "After_piImpostos":U
           tt-epc.cod-parameter = "Table_tt-itens"
           tt-epc.val-parameter = STRING(TEMP-TABLE tt-itens:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "After_piImpostos":U
           tt-epc.cod-parameter = "Table_tt-erro"
           tt-epc.val-parameter = STRING(TEMP-TABLE tt-erro:HANDLE).

    {include/i-epc201.i After_piImpostos}

END. /* IF c-nom-prog-upc-mg97 <> "" THEN DO: */

/* ***** Ajusta sequencia dos erros com origem na api ***** */
FOR EACH tt-erro-316b:
    IF  i-seq-erro = 0 THEN
        ASSIGN i-seq-erro = 1.
    
    CREATE tt-erro.
    ASSIGN tt-erro.i-sequen = i-seq-erro
           tt-erro.cd-erro  = tt-erro-316b.cd-erro
           tt-erro.mensagem = tt-erro-316b.desc-erro
           i-seq-erro       = i-seq-erro + 1.
END.


/* Elimina as despesas do documento no Importacao quando houve problemas    *
 * na API e o documento nao foi criado no Recebimento                       */
FIND FIRST tt-docum-est NO-LOCK NO-ERROR.
IF  NOT CAN-FIND(docum-est
                 WHERE docum-est.serie-docto   = tt-docum-est.serie-docto
                   AND docum-est.nro-docto     = tt-docum-est.nro-docto
                   AND docum-est.cod-emitente  = tt-docum-est.cod-emitente
                   AND docum-est.nat-operacao  = tt-docum-est.nat-operacao) THEN DO:
    
    FOR EACH  docum-est-cex EXCLUSIVE-LOCK
        WHERE docum-est-cex.serie-docto   = tt-docum-est.serie-docto
          AND docum-est-cex.nro-docto = tt-docum-est.nro-docto
          AND docum-est-cex.cod-emitente  = tt-docum-est.cod-emitente
          AND docum-est-cex.nat-operacao  = tt-docum-est.nat-operacao:
        
        FOR EACH  item-doc-est-cex EXCLUSIVE-LOCK
            WHERE item-doc-est-cex.serie-docto       = docum-est-cex.serie-docto
              AND item-doc-est-cex.nro-docto         = docum-est-cex.nro-docto
              AND item-doc-est-cex.cod-emitente      = docum-est-cex.cod-emitente
              AND item-doc-est-cex.nat-operacao      = docum-est-cex.nat-operacao
              AND item-doc-est-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp
              AND item-doc-est-cex.cod-desp          = docum-est-cex.cod-desp:
            DELETE item-doc-est-cex.
        END.
        
        FOR EACH  desp-item-doc-est EXCLUSIVE-LOCK
            WHERE desp-item-doc-est.serie-docto       = docum-est-cex.serie-docto
              AND desp-item-doc-est.nro-docto         = docum-est-cex.nro-docto
              AND desp-item-doc-est.cod-emitente      = docum-est-cex.cod-emitente
              AND desp-item-doc-est.nat-operacao      = docum-est-cex.nat-operacao
              AND desp-item-doc-est.cod-despesa       = STRING(docum-est-cex.cod-desp):
            DELETE desp-item-doc-est.
        END.
        
        FIND FIRST desp-docum-est EXCLUSIVE-LOCK
             WHERE desp-docum-est.serie-docto  = docum-est-cex.serie-docto
               AND desp-docum-est.nro-docto    = docum-est-cex.nro-docto
               AND desp-docum-est.cod-emitente = docum-est-cex.cod-emitente
               AND desp-docum-est.nat-operacao = docum-est-cex.nat-operacao
               AND desp-docum-est.cod-despesa  = STRING(docum-est-cex.cod-desp) NO-ERROR.
        IF  AVAIL desp-docum-est THEN
            DELETE desp-docum-est.
        
        DELETE docum-est-cex.
    END.
    
    FOR EACH  dupli-apagar-cex EXCLUSIVE-LOCK
        WHERE dupli-apagar-cex.serie-docto  = tt-docum-est.serie-docto
          AND dupli-apagar-cex.nro-docto    = tt-docum-est.nro-docto
          AND dupli-apagar-cex.cod-emitente = tt-docum-est.cod-emitente
          AND dupli-apagar-cex.nat-operacao = tt-docum-est.nat-operacao:
        DELETE dupli-apagar-cex.
    END.
END.


/****************************************** Procedures Internas **************************************************/

PROCEDURE pi-consiste-numero:
    /* ***** Consiste n£mero do documento de entrada ***** */
    
    IF  serie.forma-emis = 1   THEN DO:
        FIND ser-estab NO-LOCK
             WHERE ser-estab.serie       = tt-nota.serie-docto
               AND ser-estab.cod-estabel = tt-nota.cod-estabel NO-ERROR.        
        IF  NOT AVAIL ser-estab THEN DO:
            ASSIGN i-msg = 6514
                   c-msg = ""
                   c-char= "".
            RUN pi-gera-erro.
        END.
        ELSE DO:
            IF  tt-nota.pais-impto-usuario = 1 THEN
                ASSIGN c-docto-aux = string(int(ser-estab.nr-ult-nota) + 1,"9999999").
            ELSE
                ASSIGN c-docto-aux = string(int(ser-estab.nr-ult-nota) + 1).
            
            FIND docum-est NO-LOCK
                 WHERE docum-est.serie-docto  = tt-nota.serie-docto
                   AND docum-est.nro-docto    = c-docto-aux
                   AND docum-est.cod-emitente = tt-nota.cod-emitente
                   AND docum-est.nat-operacao = tt-nota.nat-operacao NO-ERROR.
            IF  AVAIL docum-est THEN DO:
                ASSIGN i-msg  = 5569
                       c-msg  = c-docto-aux                       
                       c-char = "".
                RUN pi-gera-erro.
            END.
            ELSE DO:
                ASSIGN tt-nota.nro-docto = c-docto-aux.
                
                RUN utp/ut-msgs.p (INPUT "msg":U,
                                   INPUT 6511,
                                   INPUT c-docto-aux).
                CREATE tt-retorno.
                ASSIGN tt-retorno.i-sequen = 1
                       tt-retorno.cd-erro  = 6511
                       tt-retorno.mensagem = RETURN-VALUE
                       tt-retorno.parametros = c-docto-aux /*utilizado para imprimir no relatorio de conferencia, nao retirar*/
                       .
            END.
        END.
    END.
    
END PROCEDURE.

PROCEDURE pi-gera-docto:
    /* ***** Cabeáalho para a API do Recebimento  ***** */
    
    FIND embarque-imp NO-LOCK
         WHERE embarque-imp.cod-estabel = tt-nota.cod-estabel
           AND embarque-imp.embarque    = tt-nota.embarque NO-ERROR.
           
    FIND  estabelec NO-LOCK
    WHERE estabelec.cod-estabel = tt-nota.cod-estabel NO-ERROR.

    if (AVAIL embarque-imp 
        AND   embarque-imp.log-embarq-transf-draw) THEN
        ASSIGN l-transf = YES.
    ELSE
        ASSIGN l-transf = NO.

    CREATE tt-docum-est.
    ASSIGN tt-docum-est.cod-emitente   = tt-nota.cod-emitente
           tt-docum-est.uf             = IF AVAIL estabelec THEN estabelec.estado ELSE ""
           tt-docum-est.pais           = IF AVAIL estabelec THEN estabelec.pais ELSE ""
           tt-docum-est.nat-operacao   = tt-nota.nat-operacao       
           tt-docum-est.nro-docto      = tt-nota.nro-docto
           tt-docum-est.serie-docto    = tt-nota.serie-docto
           tt-docum-est.cod-estabel    = tt-nota.cod-estabel       
           tt-docum-est.dt-emissao     = tt-nota.dt-emissao
           tt-docum-est.dt-trans       = tt-nota.dt-trans
           tt-docum-est.dt-venc-icm    = tt-nota.dt-venc-icm       
           tt-docum-est.dt-venc-ipi    = tt-nota.dt-venc-ipi
           tt-docum-est.estab-fisc     = tt-nota.cod-estabel
           tt-docum-est.usuario        = tt-nota.usuario
           tt-docum-est.ct-transit     = tt-nota.ct-transit
           tt-docum-est.sc-transit     = tt-nota.sc-transit
           tt-docum-est.cod-observa    = 1 /* industria */
           tt-docum-est.embarque       = tt-nota.embarque
           tt-docum-est.nff            = l-nff
           tt-docum-est.valor-embal    = 0
           tt-docum-est.pais-origem    = "RE1001":U
           tt-docum-est.esp-docto      = 21
           tt-docum-est.rec-fisico     = no
           tt-docum-est.log-memorando  = no
           tt-docum-est.origem         = "I":U
           tt-docum-est.via-transp     = tt-nota.via-transp           
           tt-docum-est.mod-frete      = 1
           tt-docum-est.mo-codigo      = tt-nota.mo-codigo                     
           tt-docum-est.dat-validade   = 12.31.9999
           tt-docum-est.cotacao-dia    = tt-nota.cotacao-dia
           OVERLAY(tt-docum-est.char-1,1,20) = tt-nota.embarque
           OVERLAY(tt-docum-est.char-1,209,1) = "N":U.

    {utp/ut-liter.i "Conforme DI" *}
    ASSIGN c-texto1 = RETURN-VALUE.
    {utp/ut-liter.i "Emitida em" *}
    ASSIGN c-texto2 = RETURN-VALUE.
    {utp/ut-liter.i "Embarque" *}
    ASSIGN c-texto3 = RETURN-VALUE.

    ASSIGN tt-docum-est.observacao = c-texto1 + ": " + embarque-imp.declaracao-import + " " +
                                     c-texto2 + ": " + STRING(embarque-imp.data-di) + " - " +
                                     c-texto3 + ": " + tt-nota.embarque +
                                     " - "    + tt-nota.observacao.
    
    ASSIGN tt-docum-est.sit-docum = IF  l-nff OR (NOT l-nff AND NOT natur-oper.emite-duplic)
                                    THEN 1 
                                    ELSE 2.
    
END PROCEDURE.

PROCEDURE pi-gera-tt-despesas:
    /* ***** Criacao das temp-tables com as despesas e os valores calculados para rateio ***** */    
    
    DEF VAR h-im0091 AS HANDLE NO-UNDO.
    
    /* ***** Rateio das despesas informadas para o embarque ***** */
    RUN imp/im0091.p PERSISTENT SET h-im0091.
    RUN setaValorinicial     IN h-im0091 (INPUT tt-nota.da-cotacao,
                                          INPUT tt-nota.cod-estabel).
    
    IF tt-nota.d-cotacao <> 0 THEN                                  
        RUN setaValorCotacao IN h-im0091 (INPUT tt-nota.d-cotacao).
                                          
    RUN setaValorInternac    IN h-im0091 (INPUT de-cot-var-cambial,
                                          INPUT tt-nota.idi-nf-simples-remes = 2).
    RUN setTTitens           IN h-im0091 (INPUT TABLE tt-itens).
    RUN rateioEmbarque       IN h-im0091 (INPUT tt-nota.cod-estabel,
                                          INPUT tt-nota.embarque,
                                          INPUT tt-nota.nat-operacao,
                                          OUTPUT TABLE tt-desp-rateio).       

    RUN geradiferencavalores IN h-im0091 (OUTPUT TABLE tt-itens-rateio).
    RUN getTTdesp-totais     IN h-im0091 (OUTPUT TABLE tt-desp-totais).
    RUN getTTordens-totais   IN h-im0091 (OUTPUT TABLE tt-ordens-totais).
    RUN getTTdesp-comp       IN h-im0091 (OUTPUT TABLE tt-desp-comp).
    RUN getTTbo-erro         IN h-im0091 (OUTPUT TABLE tt-bo-erro).
    DELETE PROCEDURE h-im0091.
    
    FOR EACH tt-bo-erro:
        ASSIGN i-msg = tt-bo-erro.cd-erro
               c-msg = tt-bo-erro.parametros
               c-char= "".
        RUN pi-gera-erro.
    END.
    
END PROCEDURE.

PROCEDURE pi-skip-lote:
    /* ***** Atualiza o campo cod-depos se o item for controlado por CQ ***** */
    
    DEF VAR l-sugere-cq     AS LOG NO-UNDO.
    DEF VAR i-indice-cq   LIKE param-estoq.ins-pref-x EXTENT 0 NO-UNDO.
    DEF VAR l-leitura-item-fornec-estab AS LOG NO-UNDO.
    DEF VAR i-tp-skip-lote-aux AS INT NO-UNDO.
    DEF VAR i-ind           AS INT NO-UNDO.

    ASSIGN l-sugere-cq = YES.
    
    IF  param-cq.tipo-cq = 3 THEN DO: /* CQ Total */
        ASSIGN l-leitura-item-fornec-estab = YES.
        
        IF  l-leitura-item-fornec-estab THEN DO:                    
            FIND FIRST item-fornec-estab EXCLUSIVE-LOCK
                 WHERE item-fornec-estab.it-codigo    = tt-item-doc-est.it-codigo 
                   AND item-fornec-estab.cod-emitente = tt-item-doc-est.cod-emitente 
                   AND item-fornec-estab.cod-estabel  = tt-nota.cod-estabel NO-ERROR.
            IF  AVAIL item-fornec-estab THEN DO:
                IF  item-fornec-estab.tp-inspecao > 3 THEN DO:
				    ASSIGN i-ind = item-fornec-estab.tp-inspecao - 3.
					&IF '{&bf_lote_avancado_liberado}' = 'yes' &THEN
						IF CAN-FIND(FIRST funcao 
									WHERE funcao.cd-funcao = "lote-avancado" 
									AND   funcao.ativo     = true NO-LOCK) THEN DO:
							FIND fda-param-inspec-fornec WHERE fda-param-inspec-fornec.cdn-emit = tt-item-doc-est.cod-emitente NO-LOCK NO-ERROR .
							IF AVAIL fda-param-inspec-fornec THEN DO:
								CASE item.criticidade:
									WHEN 1 THEN do:
                                        CASE i-ind:
                                            WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-1.
                                            WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-2.
                                            WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-3.
                                        END CASE.
                                        
                                    END.
                			        WHEN 2 THEN do:
                                        CASE i-ind:
                                            WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-1.
                                            WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-2.
                                            WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-3.
                                        END CASE.
                                    end. 
                			        WHEN 3 THEN DO:
                                        CASE i-ind:
                                            WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-1.
                                            WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-2.
                                            WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-3.
                                        END CASE.
                                    END.
								END CASE.
								ASSIGN i-tp-skip-lote-aux = fda-param-inspec-fornec.idi-tip-skip-lote.
							END.
							ELSE DO:
								FIND emitente WHERE emitente.cod-emitente = tt-item-doc-est.cod-emitente NO-LOCK NO-ERROR.
								FIND fda-param-inspec WHERE fda-param-inspec.cdn-grp-emit = emitente.cod-gr-forn NO-LOCK NO-ERROR.
								IF AVAIL fda-param-inspec THEN DO:
									CASE item.criticidade:
										WHEN 1 THEN do:
                                            CASE i-ind:
                                                WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-1.
                                                WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-2.
                                                WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-3.
                                            END CASE.
                                        END.
            							WHEN 2 THEN do:
                                            CASE i-ind:
                                                WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-1.
                                                WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-2.
                                                WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-3.
                                            END CASE.
                                        end. 
            							WHEN 3 THEN DO:
                                            CASE i-ind:
                                                WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-1.
                                                WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-2.
                                                WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-3.
                                            END CASE.
                                        END.
									END CASE.
									ASSIGN i-tp-skip-lote-aux = fda-param-inspec.idi-tip-skip-lote.
								END.
								ELSE DO:
									CASE item.criticidade:
										WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec-estab.tp-inspecao - 3].
										WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec-estab.tp-inspecao - 3].
										WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec-estab.tp-inspecao - 3].
									END CASE.
									ASSIGN i-tp-skip-lote-aux = param-cq.tp-skip-lot.
								END.
							END.
						END.
						ELSE DO:
							CASE item.criticidade:
								WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec-estab.tp-inspecao - 3].
								WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec-estab.tp-inspecao - 3].
								WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec-estab.tp-inspecao - 3].
							END CASE.
							ASSIGN i-tp-skip-lote-aux = param-cq.tp-skip-lot.
						END.
					&ELSE
						CASE item.criticidade:
							WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec-estab.tp-inspecao - 3].
							WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec-estab.tp-inspecao - 3].
							WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec-estab.tp-inspecao - 3].
						END CASE.
						ASSIGN i-tp-skip-lote-aux = param-cq.tp-skip-lot.
					&ENDIF
					IF  i-tp-skip-lote-aux = 1 THEN
						ASSIGN l-sugere-cq = ( random(0,100) <= i-indice-cq ).
					ELSE DO:
						 ASSIGN l-sugere-cq = no.
						 IF  i-indice-cq <= item-fornec-estab.niv-inspecao THEN 
							 ASSIGN l-sugere-cq = yes
									item-fornec-estab.niv-inspecao = 0.
					END.
					IF  l-sugere-cq = no THEN
						ASSIGN item-fornec-estab.niv-inspecao =
							   item-fornec-estab.niv-inspecao + 1.
					
                END.
                ELSE ASSIGN l-sugere-cq = yes.
            END.          
            ELSE 
                ASSIGN l-leitura-item-fornec-estab = NO.
        END.
        
        IF  NOT l-leitura-item-fornec-estab THEN DO:
            FIND item-fornec EXCLUSIVE-LOCK
                 WHERE item-fornec.it-codigo    = tt-item-doc-est.it-codigo 
                   AND item-fornec.cod-emitente = tt-item-doc-est.cod-emitente NO-ERROR.
            IF  AVAIL item-fornec THEN DO:
                IF  item-fornec.tp-inspecao > 3 THEN DO:
				    ASSIGN i-ind = item-fornec.tp-inspecao - 3.  
					&IF '{&bf_lote_avancado_liberado}' = 'yes' &THEN
						IF CAN-FIND(FIRST funcao 
									WHERE funcao.cd-funcao = "lote-avancado" 
									AND   funcao.ativo     = true NO-LOCK) THEN DO:					
							FIND fda-param-inspec-fornec WHERE fda-param-inspec-fornec.cdn-emit = tt-item-doc-est.cod-emitente NO-LOCK NO-ERROR .
							IF AVAIL fda-param-inspec-fornec THEN DO:
								CASE item.criticidade:
									WHEN 1 THEN do:
                                        CASE i-ind:
                                            WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-1.
                                            WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-2.
                                            WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-3.
                                        END CASE.
                                        
                                    END.
                			        WHEN 2 THEN do:
                                        CASE i-ind:
                                            WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-1.
                                            WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-2.
                                            WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-3.
                                        END CASE.
                                    end. 
                			        WHEN 3 THEN DO:
                                        CASE i-ind:
                                            WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-1.
                                            WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-2.
                                            WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-3.
                                        END CASE.
                                    END.
								END CASE.
								ASSIGN i-tp-skip-lote-aux = fda-param-inspec-fornec.idi-tip-skip-lote.
							END.
							ELSE DO:
								FIND emitente WHERE emitente.cod-emitente = tt-item-doc-est.cod-emitente NO-LOCK NO-ERROR.
								FIND fda-param-inspec WHERE fda-param-inspec.cdn-grp-emit = emitente.cod-gr-forn NO-LOCK NO-ERROR.
								IF AVAIL fda-param-inspec THEN DO:
									CASE item.criticidade:
										WHEN 1 THEN do:
                                            CASE i-ind:
                                                WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-1.
                                                WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-2.
                                                WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-3.
                                            END CASE.
                                        END.
            							WHEN 2 THEN do:
                                            CASE i-ind:
                                                WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-1.
                                                WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-2.
                                                WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-3.
                                            END CASE.
                                        end. 
            							WHEN 3 THEN DO:
                                            CASE i-ind:
                                                WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-1.
                                                WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-2.
                                                WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-3.
                                            END CASE.
                                        END.
									END CASE.
									ASSIGN i-tp-skip-lote-aux = fda-param-inspec.idi-tip-skip-lote.
								END.
								ELSE DO:
									CASE item.criticidade:
										WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec.tp-inspecao - 3].
										WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec.tp-inspecao - 3].
										WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec.tp-inspecao - 3].
									END CASE.
									ASSIGN i-tp-skip-lote-aux = param-cq.tp-skip-lot.
								END.
							END.
						END.
						ELSE DO:
							CASE item.criticidade:
								WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec.tp-inspecao - 3].
								WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec.tp-inspecao - 3].
								WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec.tp-inspecao - 3].
							END CASE.
							ASSIGN i-tp-skip-lote-aux = param-cq.tp-skip-lot.
						END.
					&ELSE
						CASE item.criticidade:
							WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec.tp-inspecao - 3].
							WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec.tp-inspecao - 3].
							WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec.tp-inspecao - 3].
						END CASE.
						ASSIGN i-tp-skip-lote-aux = param-cq.tp-skip-lot.
					&ENDIF
				   
					IF  i-tp-skip-lote-aux = 1 THEN
						ASSIGN l-sugere-cq = ( RANDOM(0,100) <= i-indice-cq ).
					ELSE DO:
						 ASSIGN l-sugere-cq = no.
						 IF  i-indice-cq <= item-fornec.niv-inspecao THEN
							 ASSIGN l-sugere-cq = yes
									item-fornec.niv-inspecao = 0.
					END.
					IF  l-sugere-cq = no THEN
						ASSIGN item-fornec.niv-inspecao =
							   item-fornec.niv-inspecao + 1.
					
                END.
                ELSE ASSIGN l-sugere-cq = yes.
            END.
        END.
    END.
    
    IF  l-sugere-cq THEN DO:
        ASSIGN tt-item-doc-est.cod-depos = estabelec.deposito-cq.
        
        IF  l-loc-unica = NO THEN
            ASSIGN tt-item-doc-est.cod-localiz = "".
    END.

END PROCEDURE.

PROCEDURE pi-despesas:
    /* ***** Calcula despesas para os itens da nota ***** */
    
    DEF VAR de-tot-despesa-aux     LIKE desp-embarque.val-desp    NO-UNDO.
    DEF VAR de-tot-frete-aux       LIKE desp-embarque.val-desp    NO-UNDO.
    DEF VAR de-val-desp-inc        LIKE desp-embarque.val-desp    NO-UNDO.
    DEF VAR de-val-desp-fre        LIKE desp-embarque.val-desp    NO-UNDO.
    DEF VAR de-val-desp-rateio     LIKE desp-embarque.val-desp    NO-UNDO.
    DEF VAR de-val-desp-rateio-dif LIKE desp-embarque.val-desp    NO-UNDO.
    DEF VAR de-val-desp-conv       LIKE desp-embarque.val-desp    NO-UNDO.
    DEF VAR de-val-maior           LIKE prazo-compra.quantidade   NO-UNDO.
    DEF VAR i-numero-ordem         LIKE prazo-compra.numero-ordem NO-UNDO.
    DEF VAR i-parcela              LIKE prazo-compra.parcela      NO-UNDO.
    DEF VAR i-seq                    AS INT                       NO-UNDO.
    DEF VAR i-seq-despesa            AS INT                       NO-UNDO.
    DEF VAR i-cod-desp             LIKE desp-embarque.cod-desp    NO-UNDO.
    
    ASSIGN i-seq-despesa = 0.

    FOR EACH tt-desp-rateio
        WHERE tt-desp-rateio.numero-ordem = tt-item-doc-est.numero-ordem
          AND tt-desp-rateio.parcela      = tt-item-doc-est.parcela
          BREAK BY tt-desp-rateio.cod-desp:
        
        FIND FIRST tt-desp-totais
             WHERE tt-desp-totais.cod-desp = tt-desp-rateio.cod-desp NO-ERROR.
        
        FIND tt-ordens-totais
            WHERE tt-ordens-totais.numero-ordem = tt-item-doc-est.numero-ordem
              AND tt-ordens-totais.parcela      = tt-item-doc-est.parcela NO-ERROR.
        
        IF  l-first-numero-ordem THEN DO:
            FOR EACH  tt-itens-rateio NO-LOCK
                WHERE tt-itens-rateio.numero-ordem = tt-desp-rateio.numero-ordem
                  AND tt-itens-rateio.parcela      = tt-desp-rateio.parcela
                  AND tt-itens-rateio.cod-desp     = tt-desp-rateio.cod-desp:
                ASSIGN de-val-desp-rateio = de-val-desp-rateio + round(tt-itens-rateio.val-desp,2).
            END.
            
            IF  de-val-desp-rateio <> tt-desp-rateio.val-desp THEN DO:
                ASSIGN de-val-desp-rateio-dif = IF (de-val-desp-rateio - tt-desp-rateio.val-desp) < 0 THEN
                                                   (de-val-desp-rateio - tt-desp-rateio.val-desp) * (-1) 
                                                ELSE (de-val-desp-rateio - tt-desp-rateio.val-desp).
                
                FOR EACH  tt-itens-rateio NO-LOCK
                    WHERE tt-itens-rateio.numero-ordem = tt-desp-rateio.numero-ordem
                      AND tt-itens-rateio.parcela      = tt-desp-rateio.parcela
                      AND tt-itens-rateio.cod-desp     = tt-desp-rateio.cod-desp:
                     
                    IF  tt-itens-rateio.quantidade > de-val-maior THEN
                        ASSIGN i-numero-ordem = tt-itens-rateio.numero-ordem
                               i-parcela      = tt-itens-rateio.parcela
                               i-seq          = tt-itens-rateio.seq
                               i-cod-desp     = tt-itens-rateio.cod-desp
                               de-val-maior   = tt-itens-rateio.quantidade.
                END.         
                
                FIND FIRST tt-itens-rateio NO-LOCK
                     WHERE tt-itens-rateio.numero-ordem = i-numero-ordem
                       AND tt-itens-rateio.parcela      = i-parcela
                       AND tt-itens-rateio.seq          = i-seq
                       AND tt-itens-rateio.cod-desp     = i-cod-desp NO-ERROR. 
                    
                ASSIGN tt-itens-rateio.val-desp = tt-itens-rateio.val-desp - de-val-desp-rateio-dif.
            
            END.
        END.
        
        FIND FIRST tt-itens-rateio NO-LOCK
             WHERE tt-itens-rateio.numero-ordem = tt-desp-rateio.numero-ordem
               AND tt-itens-rateio.parcela      = tt-desp-rateio.parcela
               AND tt-itens-rateio.seq          = tt-itens.seq
               AND tt-itens-rateio.cod-desp     = tt-desp-rateio.cod-desp NO-ERROR.
        
        ASSIGN de-val-desp-rateio = 0
               i-numero-ordem    = 0
               i-parcela         = 0
               i-seq             = 0
               i-cod-desp        = 0
               de-val-maior      = 0
               de-val-desp-rateio-dif = 0.
        
        FIND docum-est-cex EXCLUSIVE-LOCK
             WHERE docum-est-cex.serie-docto       = tt-docum-est.serie-docto
               AND docum-est-cex.nro-docto         = tt-docum-est.nro-docto
               AND docum-est-cex.cod-emitente      = tt-docum-est.cod-emitente
               AND docum-est-cex.nat-operacao      = tt-docum-est.nat-operacao
               AND docum-est-cex.cod-emitente-desp = tt-desp-totais.cod-emitente-desp
               AND docum-est-cex.cod-desp          = tt-desp-rateio.cod-desp NO-ERROR.
        IF  NOT AVAIL docum-est-cex THEN DO:
            CREATE docum-est-cex.
            ASSIGN docum-est-cex.serie-docto       = tt-docum-est.serie-docto
                   docum-est-cex.nro-docto         = tt-docum-est.nro-docto          
                   docum-est-cex.cod-emitente      = tt-docum-est.cod-emitente
                   docum-est-cex.nat-operacao      = tt-docum-est.nat-operacao
                   docum-est-cex.cod-emitente-desp = tt-desp-totais.cod-emitente-desp
                   docum-est-cex.cod-desp          = tt-desp-rateio.cod-desp
                   docum-est-cex.mo-codigo         = tt-desp-totais.mo-codigo
                   docum-est-cex.cod-cond-pag      = tt-desp-totais.cod-cond-pag
                   docum-est-cex.cotacao           = 1
                  &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
                   docum-est-cex.idi-sit-despes = 1
                  &ELSE
                   docum-est-cex.int-1 = 1
                  &ENDIF.
        END.
        
        ASSIGN docum-est-cex.val-desp = docum-est-cex.val-desp + tt-itens-rateio.val-desp.
        
        FIND FIRST desp-docum-est EXCLUSIVE-LOCK
             WHERE desp-docum-est.serie-docto  = docum-est-cex.serie-docto
               AND desp-docum-est.nro-docto    = docum-est-cex.nro-docto
               AND desp-docum-est.cod-emitente = docum-est-cex.cod-emitente
               AND desp-docum-est.nat-operacao = docum-est-cex.nat-operacao
               AND desp-docum-est.cod-despesa  = STRING(docum-est-cex.cod-desp) NO-ERROR.
        IF  NOT AVAIL desp-docum-est THEN DO:
            CREATE desp-docum-est.
            ASSIGN desp-docum-est.serie-docto  = docum-est-cex.serie-docto
                   desp-docum-est.nro-docto    = docum-est-cex.nro-docto
                   desp-docum-est.cod-emitente = docum-est-cex.cod-emitente
                   desp-docum-est.nat-operacao = docum-est-cex.nat-operacao
                   desp-docum-est.cod-despesa  = STRING(docum-est-cex.cod-desp).
        END.        
        
        IF CAN-FIND(FIRST tt-desp-comp 
                    WHERE tt-desp-comp.cod-desp = docum-est-cex.cod-desp) THEN DO:
                    
            FOR FIRST tt-desp-comp NO-LOCK
               WHERE  tt-desp-comp.cod-desp = docum-est-cex.cod-desp:
                RUN cdp/cd0812.p (INPUT tt-desp-totais.mo-codigo,
                                  INPUT tt-docum-est.mo-codigo,
                                  INPUT tt-desp-rateio.val-desp-mo,
                                  INPUT tt-desp-comp.dt-cotac,
                                  OUTPUT de-val-desp-conv).
            END.  
        END.
        ELSE DO:
            if de-cot-var-cambial <> 0 and tt-desp-totais.mo-codigo = 0 AND
               (tt-desp-totais.cod-desp = i-desp-ii-i50 or tt-desp-totais.cod-desp = param-imp.cdn-despes-tax-estatis)  then do:
               assign de-val-desp-conv = tt-desp-rateio.val-desp-mo / de-cot-var-cambial.
            end.
            ELSE DO:
                RUN cdp/cd0812.p (INPUT tt-desp-totais.mo-codigo,
                                  INPUT tt-docum-est.mo-codigo,
                                  INPUT tt-desp-rateio.val-desp-mo,
                                  INPUT tt-nota.da-cotacao,
                                  OUTPUT de-val-desp-conv).
            END.
        END.
        
        ASSIGN desp-docum-est.val-despesa  = desp-docum-est.val-despesa + de-val-desp-conv.
        
        CREATE item-doc-est-cex.
        ASSIGN item-doc-est-cex.serie-docto       = tt-docum-est.serie-docto
               item-doc-est-cex.nro-docto         = tt-docum-est.nro-docto
               item-doc-est-cex.cod-emitente      = tt-docum-est.cod-emitente
               item-doc-est-cex.nat-operacao      = tt-docum-est.nat-operacao
               item-doc-est-cex.sequencia         = tt-item-doc-est.sequencia
               item-doc-est-cex.cod-emitente-desp = tt-desp-totais.cod-emitente-desp
               item-doc-est-cex.cod-desp          = tt-desp-rateio.cod-desp
               item-doc-est-cex.mo-codigo         = 0 /*ser† gravado fixo a moeda zero, pois na tt-itens-rateio.val-desp sempre vem o valor j† convertido para a moeda 0*/
               item-doc-est-cex.dat-cotac         = tt-nota.da-cotacao
               item-doc-est-cex.cotacao           = 1
               item-doc-est-cex.val-desp          = tt-itens-rateio.val-desp /*tt-desp-rateio.val-desp-mo*/
               i-seq-despesa                      = i-seq-despesa + 1
              &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
               item-doc-est-cex.idi-sit-despes  = 1
              &ELSE
               item-doc-est-cex.int-1           = 1
              &ENDIF.
        
        CREATE desp-item-doc-est.
        ASSIGN desp-item-doc-est.num-seq-desp = i-seq-despesa
               desp-item-doc-est.serie-docto  = item-doc-est-cex.serie-docto
               desp-item-doc-est.nro-docto    = item-doc-est-cex.nro-docto
               desp-item-doc-est.cod-emitente = item-doc-est-cex.cod-emitente
               desp-item-doc-est.nat-operacao = item-doc-est-cex.nat-operacao
               desp-item-doc-est.sequencia    = item-doc-est-cex.sequencia 
               desp-item-doc-est.cod-despesa  = STRING(item-doc-est-cex.cod-desp)
               desp-item-doc-est.val-despesa  = de-val-desp-conv
               desp-item-doc-est.val-per-desp = 0
               desp-item-doc-est.situacao     = 1.
        
        IF NOT l-transf THEN DO:
            RUN pi-rateio-item-desp (INPUT  tt-desp-rateio.cod-desp,
                                     INPUT  desp-item-doc-est.val-despesa,
                                     OUTPUT de-val-desp-inc,
                                     OUTPUT de-val-desp-fre).

            ASSIGN de-tot-despesa-aux = de-tot-despesa-aux + de-val-desp-inc
                   de-tot-frete-aux   = de-tot-frete-aux   + de-val-desp-fre.
        END.    
    END.    
    ASSIGN de-tot-resto       = de-tot-resto       + (de-tot-despesa-aux - tt-item-doc-est.despesas-me[1])
           de-tot-resto-frete = de-tot-resto-frete + (de-tot-frete-aux   - tt-item-doc-est.pr-total-cmi).
END PROCEDURE.

PROCEDURE pi-rateio-item-desp:
    /* ***** Rateia o valor da despesa para o item do documento ***** */
    
    DEF INPUT  PARAMETER p-cod-desp     LIKE desp-imp.cod-desp      NO-UNDO.
    DEF INPUT  PARAMETER p-val-desp     LIKE desp-embarque.val-desp NO-UNDO.
    DEF OUTPUT PARAMETER p-val-desp-inc LIKE desp-embarque.val-desp NO-UNDO.
    DEF OUTPUT PARAMETER p-val-desp-fre LIKE desp-embarque.val-desp NO-UNDO.
    
    FIND desp-imp NO-LOCK
        WHERE desp-imp.cod-desp = p-cod-desp NO-ERROR.

    IF  AVAIL desp-imp THEN DO:
        
        IF (desp-imp.inc-val-frete  OR
            desp-imp.inc-val-seguro OR 
            desp-imp.inc-val-embal  OR
            desp-imp.inc-val-outras-desp) AND
            SUBSTRING(desp-imp.char-1,45,1) <> "Y":U THEN DO:

            ASSIGN tt-item-doc-est.despesas-me[1] = tt-item-doc-est.despesas-me[1] + p-val-desp
                   p-val-desp-inc           = p-val-desp
                   de-despesa-item          = de-despesa-item + p-val-desp.
            IF  desp-imp.inc-val-frete THEN
                ASSIGN tt-item-doc-est.pr-total-cmi = tt-item-doc-est.pr-total-cmi + p-val-desp
                       de-frete                     = de-frete                     + p-val-desp
                       p-val-desp-fre               = p-val-desp
                       de-tot-frete                 = de-tot-frete + p-val-desp.
            IF  desp-imp.inc-val-seguro THEN
                ASSIGN de-seguro         = de-seguro         + p-val-desp
                       de-tot-seguro-aux = de-tot-seguro-aux + p-val-desp.
            IF  desp-imp.inc-val-embal THEN
                ASSIGN de-embal          = de-embal         + p-val-desp
                       de-tot-embal-aux  = de-tot-embal-aux + p-val-desp.
            IF  desp-imp.inc-val-outras-desp THEN
                ASSIGN de-outras         = de-outras         + p-val-desp
                       de-tot-outras-aux = de-tot-outras-aux + p-val-desp.
        END.
        IF  desp-imp.inc-base-ipi THEN
            ASSIGN de-base-ipi    = de-base-ipi + p-val-desp.
        IF  desp-imp.inc-base-icms THEN
            ASSIGN de-base-icm    = de-base-icm + p-val-desp.
     END.
END PROCEDURE.

PROCEDURE pi-arredondamento-itens:
    /* ***** Arredonda o valor das despesas dos itens para que o valor da despesa na nota fique correto ***** */
    DEF VAR i-maior-sequencia   AS INTEGER                     NO-UNDO.
    DEF VAR de-val-despesas   LIKE tt-item-doc-est.despesas[0] NO-UNDO.

    DEF VAR d-val-frete-it  LIKE item-doc-est-cex.val-desp NO-UNDO.
    DEF VAR d-val-seguro-it LIKE item-doc-est-cex.val-desp NO-UNDO.
    DEF VAR d-val-embal-it  LIKE item-doc-est-cex.val-desp NO-UNDO.
    DEF VAR d-val-outras-it LIKE item-doc-est-cex.val-desp NO-UNDO.
    DEF VAR d-val-frete-tot  LIKE item-doc-est-cex.val-desp NO-UNDO.
    DEF VAR d-val-seguro-tot LIKE item-doc-est-cex.val-desp NO-UNDO.
    DEF VAR d-val-embal-tot  LIKE item-doc-est-cex.val-desp NO-UNDO.
    DEF VAR d-val-outras-tot LIKE item-doc-est-cex.val-desp NO-UNDO.
    DEF VAR d-tot-desp-it    LIKE item-doc-est.despesas[1] NO-UNDO.
    DEF VAR d-diferenca-item LIKE item-doc-est-cex.val-desp NO-UNDO.

    ASSIGN de-val-despesas = 0.
    FOR EACH tt-item-doc-est:
        IF  de-val-despesas < tt-item-doc-est.despesas[1] THEN
            ASSIGN de-val-despesas   = tt-item-doc-est.despesas[1]
                   i-maior-sequencia = tt-item-doc-est.sequencia.
    END.

    FIND tt-item-doc-est 
         WHERE tt-item-doc-est.sequencia = i-maior-sequencia NO-ERROR.
    IF  AVAIL tt-item-doc-est THEN DO:
        ASSIGN tt-item-doc-est.pr-total-cmi    = tt-item-doc-est.pr-total-cmi + de-tot-resto-frete
               de-tot-frete                    = de-tot-frete                 + de-tot-resto-frete
               tt-docum-est.valor-frete-me     = tt-docum-est.valor-frete-me  + de-tot-resto-frete.
    END.

    ASSIGN d-val-frete-tot  = 0 
           d-val-seguro-tot = 0 
           d-val-embal-tot  = 0 
           d-val-outras-tot = 0 
           d-tot-desp-it    = 0.
        
    FOR FIRST tt-docum-est EXCLUSIVE-LOCK:
        FOR EACH  tt-item-doc-est EXCLUSIVE-LOCK
            WHERE tt-item-doc-est.cod-emitente = tt-docum-est.cod-emitente
            AND   tt-item-doc-est.nat-operacao = tt-docum-est.nat-operacao
            AND   tt-item-doc-est.serie-docto  = tt-docum-est.serie-docto 
            AND   tt-item-doc-est.nro-docto    = tt-docum-est.nro-docto   :
        
            ASSIGN d-val-frete-it  = 0
                   d-val-seguro-it = 0
                   d-val-embal-it  = 0
                   d-val-outras-it = 0
                   d-tot-desp-it   = 0.
        
            FOR EACH item-doc-est-cex NO-LOCK
                WHERE item-doc-est-cex.cod-emitente = tt-item-doc-est.cod-emitente 
                AND   item-doc-est-cex.nat-operacao = tt-item-doc-est.nat-operacao 
                AND   item-doc-est-cex.serie-docto  = tt-item-doc-est.serie-docto  
                AND   item-doc-est-cex.nro-docto    = tt-item-doc-est.nro-docto 
                AND   item-doc-est-cex.sequencia    = tt-item-doc-est.sequencia:
        
                FIND FIRST desp-imp NO-LOCK
                     WHERE desp-imp.cod-desp = item-doc-est-cex.cod-desp NO-ERROR.

                IF  SUBSTRING(desp-imp.char-1,45,1) = "Y":U THEN NEXT.
        
                IF desp-imp.inc-val-frete THEN
                    ASSIGN d-val-frete-it = d-val-frete-it + item-doc-est-cex.val-desp.
            
                IF desp-imp.inc-val-seguro THEN
                    ASSIGN d-val-seguro-it = d-val-seguro-it + item-doc-est-cex.val-desp.
            
                IF desp-imp.inc-val-embal THEN
                    ASSIGN d-val-embal-it = d-val-embal-it + item-doc-est-cex.val-desp.
            
                IF desp-imp.inc-val-outras-desp THEN
                    ASSIGN d-val-outras-it = d-val-outras-it + item-doc-est-cex.val-desp.
            
            END.
        
            ASSIGN d-tot-desp-it    = d-tot-desp-it + (d-val-frete-it  +
                                                       d-val-seguro-it +
                                                       d-val-embal-it  +
                                                       d-val-outras-it )
                   d-val-frete-tot  = d-val-frete-tot  + d-val-frete-it  
                   d-val-seguro-tot = d-val-seguro-tot + d-val-seguro-it 
                   d-val-embal-tot  = d-val-embal-tot  + d-val-embal-it  
                   d-val-outras-tot = d-val-outras-tot + d-val-outras-it.
        
            assign d-diferenca-item = 0.
            IF d-tot-desp-it <> tt-item-doc-est.despesas[1] THEN
                ASSIGN d-diferenca-item = tt-item-doc-est.despesas[1] - d-tot-desp-it.
        
            IF d-diferenca-item <> 0 THEN
                ASSIGN tt-item-doc-est.despesas[1] = tt-item-doc-est.despesas[1] - d-diferenca-item
                       tt-docum-est.despesa-nota   = tt-docum-est.despesa-nota   - d-diferenca-item.
        END.

        ASSIGN tt-docum-est.valor-frete  = ROUND(d-val-frete-tot, 2)    
               tt-docum-est.valor-seguro = ROUND(d-val-seguro-tot, 2)    
               tt-docum-est.valor-embal  = ROUND(d-val-embal-tot, 2)     
               tt-docum-est.valor-outras = ROUND(d-val-outras-tot, 2).

    END.

RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-gera-duplicata:
    /* ***** Gera duplicatas para o material  ***** */
    
    DEF OUTPUT PARAM TABLE FOR tt-dupli-apagar2.
    
    DEF VAR de-tot-vl-docto    LIKE dupli-apagar-cex.vl-a-pagar NO-UNDO.
    DEF VAR de-tot-vl-docto-mo LIKE dupli-apagar-cex.vl-a-pagar NO-UNDO.

    def var de-tot-vl-docto-aux     like dupli-apagar-cex.vl-a-pagar no-undo.
    def var de-tot-vl-docto-mo-aux  like dupli-apagar-cex.vl-a-pagar no-undo.
    DEF VAR r-cotacao-item          AS ROWID                         NO-UNDO.
    
    DEF VAR de-total-dup       LIKE dupli-apagar.vl-a-pagar     NO-UNDO.
    DEF VAR de-total-dup-mo    LIKE dupli-apagar.vl-a-pagar     NO-UNDO.
    DEF VAR de-dup-tot         LIKE dupli-apagar.vl-a-pagar     NO-UNDO.
    DEF VAR de-dup-tot-mo      LIKE dupli-apagar.vl-a-pagar     NO-UNDO.
    DEF VAR de-dup-tot-me      LIKE dupli-apagar.vl-a-pagar     NO-UNDO.    
    def var de-dup-tot-aux     like dupli-apagar.vl-a-pagar     no-undo.
    def var de-dup-tot-mo-aux  like dupli-apagar.vl-a-pagar     no-undo.  
    DEF VAR de-vl-docto        LIKE dupli-apagar.vl-a-pagar     NO-UNDO.
    DEF VAR de-vl-docto-mo     LIKE dupli-apagar.vl-a-pagar     NO-UNDO.
    DEF VAR da-data              AS DATE                        NO-UNDO EXTENT 12.
    DEF VAR da-partida           AS DATE                        NO-UNDO.    
    DEF VAR i-cod-emitente-desp-ant LIKE emitente.cod-emitente  NO-UNDO.
    DEF VAR da-dt-vencto-ant     AS DATE                        NO-UNDO INIT ?.
    
    IF  l-acomp THEN DO:
        {utp/ut-liter.i Gerando_duplicatas... * L}
        ASSIGN c-acomp = TRIM(RETURN-VALUE).
        RUN pi-acompanhar IN h-acomp (INPUT c-acomp).
    END.
    
    FOR EACH tt-dupli:
        DELETE tt-dupli.
    END.
    
    FOR EACH tt-dupli-apagar:
        DELETE tt-dupli-apagar.
    END.
    
    FOR EACH tt-dupli-apagar2:
        DELETE tt-dupli-apagar2.
    END.
    
    FIND CURRENT param-imp NO-LOCK NO-ERROR.

	{cdp/cd4300.i4 "yes" param-imp.char-1}
	{cxbo/bocx250.i51 "yes"}
    
    /* Qdo n∆o for NFF e o embarque estiver contabilizado, n∆o deve gerar duplicatas de material para o documento */
    IF  (NOT l-nff AND embarque-imp.contabilizado) OR (tt-nota.l-nf-simples-remessa and tt-nota.idi-nf-simples-remes = 2 /* Nota Filha */) THEN.
    ELSE DO:
        FIND historico-embarque NO-LOCK
            WHERE historico-embarque.cod-estabel   = tt-docum-est.cod-estabel
              AND historico-embarque.embarque      = tt-docum-est.embarque
              AND historico-embarque.cod-itiner    = tt-nota.cod-itiner
              AND historico-embarque.cod-pto-contr = tt-nota.cod-pto-contr-base NO-ERROR.
        
        FOR EACH tt-item-doc-est
            WHERE tt-item-doc-est.serie-docto  = tt-docum-est.serie-docto
              AND tt-item-doc-est.nro-docto    = tt-docum-est.nro-docto
              AND tt-item-doc-est.cod-emitente = tt-docum-est.cod-emitente
              AND tt-item-doc-est.nat-operacao = tt-docum-est.nat-operacao:
            
            FIND tt-itens
                 WHERE tt-itens.numero-ordem = tt-item-doc-est.numero-ordem
                   AND tt-itens.parcela      = tt-item-doc-est.parcela
                   AND tt-itens.sequencia    = tt-item-doc-est.sequencia NO-ERROR.
            
            ASSIGN de-vl-docto        = tt-itens.preco-total - tt-item-doc-est.desconto[1].
            ASSIGN de-tot-vl-docto    = de-tot-vl-docto + de-vl-docto
                   de-vl-docto-mo     = 0
                   de-tot-vl-docto-mo = de-tot-vl-docto-mo  + tt-itens.preco-total-mo.
            
            FIND cond-pagto NO-LOCK
                 WHERE cond-pagto.cod-cond-pag = tt-nota.cod-cond-pag NO-ERROR.
            IF  NOT AVAIL cond-pagto THEN DO:
                FIND cond-especif NO-LOCK
                     WHERE cond-especif.num-pedido = tt-itens.num-pedido NO-ERROR.
                IF  NOT AVAIL cond-especif THEN 
                    NEXT.
                
                ELSE DO:
                    DO  i-ind = 1 TO 6:
                        IF  cond-especif.data-pagto[i-ind] <> ? THEN DO:                        
                            CREATE tt-dupli.
                            ASSIGN tt-dupli.dt-vencim    = cond-especif.data-pagto[i-ind]
                                   tt-dupli.tp-despesa   = emitente.tp-desp-padrao
                                   tt-dupli.vl-apagar    = de-vl-docto 
                                                         * cond-especif.perc-pagto[i-ind]
                                                         / 100
                                   tt-dupli.mo-codigo    = tt-nota.mo-codigo
                                   tt-dupli.vl-apagar-mo = tt-itens.preco-total-mo
                                                         * cond-especif.perc-pagto[i-ind]
                                                         / 100.
                                   
                        END.
                    END.
                END.
            END.
            ELSE DO:
                
                ASSIGN da-data = TODAY.
    
                IF  NOT AVAIL historico-embarque THEN
                    ASSIGN da-partida = tt-docum-est.dt-emissao.
                ELSE
                    ASSIGN da-partida = IF  historico-embarque.dt-efetiva <> ? THEN
                                            historico-embarque.dt-efetiva
                                        ELSE
                                            tt-docum-est.dt-emissao.
                
                {cdp/cd9020.i7 tt-docum-est.cod-estabel a} /* calculo data de vencimento */
                
                DO  i-ind = 1 TO cond-pagto.num-parcelas:
    
                    IF  da-data[i-ind] < TODAY THEN 
                        ASSIGN da-data[i-ind] = tt-docum-est.dt-emissao.
    
                    CREATE tt-dupli.
                    ASSIGN tt-dupli.dt-vencim    = da-data[i-ind]
                           tt-dupli.tp-despesa   = tt-itens.tp-despesa
                           tt-dupli.vl-apagar    = de-vl-docto 
                                                 * cond-pagto.per-pg-dup[i-ind] / 100
                           tt-dupli.mo-codigo    = tt-nota.mo-codigo
                           tt-dupli.vl-apagar-mo = tt-itens.preco-total-mo
                                                 * cond-pagto.per-pg-dup[i-ind]
                                                 / 100.
                END.
            END.
        END.
        
        FOR EACH tt-dupli 
            BREAK BY tt-dupli.mo-codigo
                  BY tt-dupli.dt-vencim:
    
            IF  FIRST-OF(tt-dupli.mo-codigo) OR
                FIRST-OF(tt-dupli.dt-vencim) THEN DO:
                ASSIGN de-total-dup    = 0
                       de-total-dup-mo = 0
                       i-parcela       = i-parcela + 1.
            END.
            
            ASSIGN de-total-dup    = de-total-dup    + tt-dupli.vl-apagar
                   de-total-dup-mo = de-total-dup-mo + tt-dupli.vl-apagar-mo.
            
            IF  LAST-OF(tt-dupli.mo-codigo) OR
                LAST-OF(tt-dupli.dt-vencim) THEN DO:
                
                CREATE tt-dupli-apagar.
                ASSIGN tt-dupli-apagar.cod-emitente     = tt-docum-est.cod-emitente
                       tt-dupli-apagar.dt-vencim        = tt-dupli.dt-vencim
                       tt-dupli-apagar.dt-emissao       = tt-docum-est.dt-emissao 
                       tt-dupli-apagar.dt-trans         = tt-docum-est.dt-trans
                       tt-dupli-apagar.nat-operacao     = tt-docum-est.nat-operacao
                       tt-dupli-apagar.nro-docto        = tt-docum-est.nro-docto
                       tt-dupli-apagar.parcela          = string(i-parcela)
                       tt-dupli-apagar.serie-docto      = tt-docum-est.serie-docto
                       tt-dupli-apagar.nr-duplic        = tt-docum-est.nro-docto
                       tt-dupli-apagar.tp-despesa       = tt-dupli.tp-despesa
                       tt-dupli-apagar.vl-a-pagar       = de-total-dup
                       tt-dupli-apagar.vl-a-pagar-mo    = de-total-dup-mo
                       tt-dupli-apagar.mo-codigo        = tt-nota.mo-codigo
                       tt-dupli-apagar.valor-a-pagar-me = de-total-dup.
                
                assign i-moeda-material = tt-dupli-apagar.mo-codigo.
                IF  l-nff THEN
                    ASSIGN tt-dupli-apagar.cod-esp = param-imp.esp-tit-rec.
                ELSE
                    ASSIGN tt-dupli-apagar.cod-esp = param-re.esp-def-dup.
    
                /*
                 ** Integracao Modulo Importacao 
                 ** Grava moeda original e duplicata no valor em moeda estrangeira
                 */
                IF  l-imp
                OR  l-fornec-imp THEN DO:
                    
                    ASSIGN i-mo-codigo      = tt-dupli-apagar.mo-codigo
                           de-vl-a-pagar-mo = tt-dupli-apagar.vl-a-pagar-mo
                           de-vl-descto-mo  = 0.
                    {rep/re1001c.i51 "no"}
                    {cdp/cd4300.i4  "no" tt-dupli-apagar.char-1}
                END.
                /**************************************************************************/
            END.
        END.  
        
        /* Ajuste das diferenáas do total das duplicatas com o valor do material */
        ASSIGN de-dup-tot    = 0
               de-dup-tot-mo = 0.
        FOR EACH tt-dupli-apagar:
            ASSIGN de-dup-tot    = de-dup-tot    + tt-dupli-apagar.vl-a-pagar 
                   de-dup-tot-mo = de-dup-tot-mo + tt-dupli-apagar.vl-a-pagar-mo.
        END.
        
        IF  de-tot-vl-docto <> de-dup-tot THEN DO:
            FIND LAST tt-dupli-apagar NO-ERROR.
            ASSIGN tt-dupli-apagar.vl-a-pagar = tt-dupli-apagar.vl-a-pagar
                                              + (de-tot-vl-docto - de-dup-tot).
        END.
        
        IF  de-tot-vl-docto-mo <> de-dup-tot-mo THEN DO:
            FIND LAST tt-dupli-apagar NO-ERROR.
            ASSIGN tt-dupli-apagar.vl-a-pagar-mo = tt-dupli-apagar.vl-a-pagar-mo
                                                  + ( de-tot-vl-docto-mo - de-dup-tot-mo ).
        END.
    END.

    /* ***** Geraá∆o das Duplicatas das despesas ***** */
    {imp/im3100a.i1 "tt-item-doc-est" "dupli-apagar-cex"}
        
    IF CAN-FIND(FIRST tt-erro) THEN
        RETURN.

    /* ***** Re-sequenciar as parcelas conforme Data de Vencimento ******/
    ASSIGN i-cont = 0.
    FOR EACH tt-dupli-apagar NO-LOCK
        BREAK BY tt-dupli-apagar.dt-vencim:
        ASSIGN i-cont = i-cont + 1.
        
        CREATE tt-dupli-apagar2.
        BUFFER-COPY tt-dupli-apagar EXCEPT parcela TO tt-dupli-apagar2
             ASSIGN tt-dupli-apagar2.parcela = STRING(i-cont).
        
        /*
        ** Integracao Modulo Importacao 
        ** Grava moeda original e duplicata no valor em moeda estrangeira
        */
        IF  l-imp OR  l-fornec-imp THEN DO:
            ASSIGN i-mo-codigo      = tt-dupli-apagar2.mo-codigo
                   de-vl-a-pagar-mo = tt-dupli-apagar2.vl-a-pagar-mo
                   de-vl-descto-mo  = 0.
            {rep/re1001c.i51 "no"}
            {cdp/cd4300.i4  "no" tt-dupli-apagar2.char-1}
        END.
        /**************************************************************************/
        
    END.

RETURN "OK":U.    
END PROCEDURE.

PROCEDURE pi-gera-erro:

    ASSIGN i-seq-erro = i-seq-erro + 1.
    RUN utp/ut-msgs.p (INPUT "msg":U,
                       INPUT i-msg,
                       INPUT c-msg).
    DO  TRANSACTION:
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = i-seq-erro
               tt-erro.cd-erro  = i-msg
               tt-erro.mensagem = RETURN-VALUE + c-char.
    END.
END PROCEDURE.

PROCEDURE piImpostos:
    DEFINE VARIABLE h-cdapi027     AS HANDLE NO-UNDO.    
    
    RUN cdp/cdapi027.p PERSISTENT SET h-cdapi027.
    
    IF i-pais-impto-usuario = 2 AND NOT VALID-HANDLE(h-boar2006) THEN
        RUN local/arg/boar2006.p PERSISTENT SET h-boar2006.

    IF i-pais-impto-usuario = 9 /* Paraguai */ AND NOT VALID-HANDLE(h-bopy2006) THEN DO:
        RUN local/pry/bopy2006.p PERSISTENT SET h-bopy2006.

        RUN openQueryStatic IN h-bopy2006 (INPUT "Main":U) NO-ERROR.
    END.    

    FOR EACH tt-docum-est:

        FIND FIRST docum-est EXCLUSIVE-LOCK
             WHERE docum-est.serie-docto  = tt-docum-est.serie-docto
               AND docum-est.nro-docto    = tt-docum-est.nro-docto
               AND docum-est.cod-emitente = tt-docum-est.cod-emitente
               AND docum-est.nat-operacao = tt-docum-est.nat-operacao NO-ERROR.
        IF  AVAIL docum-est THEN
            ASSIGN docum-est.base-icm   = 0
                   docum-est.base-ipi   = 0
                   docum-est.icm-outras = 0.
    
        IF  i-pais-impto-usuario = 2 OR i-pais-impto-usuario = 21 THEN DO:                                                   
            /*Necess†rio para verificar se existe ISD a se tomar crÇdito no embarque*/
            FIND FIRST param-imp-internac NO-LOCK WHERE param-imp-internac.cod-estabel = tt-docum-est.cod-estabel NO-ERROR.
            
            FOR FIRST embarq-imp-internac NO-LOCK
                WHERE embarq-imp-internac.cod-estabel = tt-docum-est.cod-estabel
                AND   embarq-imp-internac.embarque    = TRIM(SUBSTRING(tt-docum-est.char-1,1,20)): END.

            FOR FIRST param-imp NO-LOCK
                WHERE param-imp.cod-estabel = tt-docum-est.cod-estabel: END.
        END.

        FOR EACH tt-item-doc-est
           WHERE tt-item-doc-est.serie-docto  = tt-docum-est.serie-docto
             AND tt-item-doc-est.nro-docto    = tt-docum-est.nro-docto
             AND tt-item-doc-est.cod-emitente = tt-docum-est.cod-emitente
             AND tt-item-doc-est.nat-operacao = tt-docum-est.nat-operacao:
            
            FIND FIRST item-doc-est EXCLUSIVE-LOCK
                 WHERE item-doc-est.serie-docto  = tt-item-doc-est.serie-docto
                   AND item-doc-est.nro-docto    = tt-item-doc-est.nro-docto
                   AND item-doc-est.cod-emitente = tt-item-doc-est.cod-emitente
                   AND item-doc-est.nat-operacao = tt-item-doc-est.nat-operacao
                   AND item-doc-est.sequencia    = tt-item-doc-est.sequencia NO-ERROR.
            IF  AVAIL item-doc-est THEN
                ASSIGN item-doc-est.ipi-outras           = 0
                       item-doc-est.val-base-calc-cofins = 0
                       item-doc-est.base-cofins-subs     = 0
                       item-doc-est.icm-outras           = 0
                       item-doc-est.sit-item             = 2
                       item-doc-est.pr-total-cmi         = 0
                       item-doc-est.dec-1                = 0.
            
            FOR EACH rat-lote EXCLUSIVE-LOCK
                WHERE rat-lote.cod-emitente = tt-item-doc-est.cod-emitente
                  AND rat-lote.nro-docto    = tt-item-doc-est.nro-docto
                  AND rat-lote.nat-operacao = tt-item-doc-est.nat-operacao
                  AND rat-lote.serie-docto  = tt-item-doc-est.serie-docto
                  AND rat-lote.sequencia    = tt-item-doc-est.sequencia:
                ASSIGN rat-lote.qtd-origin  = rat-lote.quantidade.
            END.
            
            EMPTY TEMP-TABLE tt-imposto.
            EMPTY TEMP-TABLE tt-impto-item-docto.
            
            FIND FIRST item NO-LOCK
                 WHERE item.it-codigo = tt-item-doc-est.it-codigo NO-ERROR.
            IF  AVAIL item THEN
                ASSIGN c-item    = item.it-codigo
                       c-familia = item.fm-codigo.
            
            FIND FIRST estabelec NO-LOCK
                 WHERE estabelec.cod-estabel = docum-est.cod-estabel NO-ERROR.
            IF  AVAIL estabelec THEN
                ASSIGN c-estabel = estabelec.cod-estabel.
            
            FIND FIRST emitente NO-LOCK
                 WHERE emitente.cod-emitente = docum-est.cod-emitente NO-ERROR.
            IF  AVAIL emitente THEN
                ASSIGN i-emitente   = emitente.cod-emitente
                       i-emit-natur = emitente.natureza
                       c-pais       = emitente.pais    WHEN c-pais = ""
                       c-uf         = emitente.estado  WHEN c-uf = ""
                       c-cidade     = emitente.cidade  WHEN c-cidade = "".
            
            FIND FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = tt-docum-est.nat-operacao NO-ERROR.
            
            IF  AVAIL natur-oper
            AND natur-oper.tipo-trib = 2 /* normal */
            AND (tt-docum-est.nff OR (NOT tt-docum-est.nff AND natur-oper.emite-duplic)) THEN DO:
                RUN pi-busca-impostos IN h-cdapi027(INPUT c-estabel,
                                                    INPUT tt-docum-est.nat-operacao,
                                                    INPUT c-pais,
                                                    INPUT c-uf,
                                                    INPUT c-cidade,
                                                    INPUT c-familia,
                                                    INPUT c-item,
                                                    INPUT-OUTPUT TABLE tt-imposto,
                                                    INPUT-OUTPUT TABLE tt-erro-aux).
            END.
            
            FIND FIRST tt-imposto NO-ERROR.

            IF  NOT CAN-FIND(FIRST impto-remito-fatur
                             WHERE impto-remito-fatur.cod-estabel  = c-estabel
                               AND impto-remito-fatur.nat-operacao = c-nat-oper
                               AND impto-remito-fatur.nome-pais    = c-pais
                               AND impto-remito-fatur.cod-estado   = c-uf
                               AND impto-remito-fatur.nom-cidade   = c-cidade
                               AND impto-remito-fatur.fm-codigo    = c-familia
                               AND impto-remito-fatur.it-codigo    = c-item)
            AND NOT AVAIL tt-imposto THEN DO:
                                

                IF  AVAIL natur-oper AND natur-oper.tipo-trib = 2 /* normal */
                AND (tt-docum-est.nff OR (NOT tt-docum-est.nff AND natur-oper.emite-duplic)) THEN DO:                    
                                        
                    FIND FIRST ordem-compra WHERE ordem-compra.numero-ordem = tt-item-doc-est.numero-ordem NO-LOCK NO-ERROR.
                    IF AVAIL ordem-compra THEN 
                        FIND FIRST cotacao-item NO-LOCK
                             WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                               AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                               AND cotacao-item.data-cotacao = ordem-compra.data-cotacao NO-ERROR.

                    IF i-pais-impto-usuario = 9 /* Paraguai */ AND AVAIL cotacao-item THEN DO:
                        
                        /* criaá∆o da impto-item-docto com base no imposto informado no CC0300B */
                        RUN goToKeyItem IN h-bopy2006 (INPUT tt-item-doc-est.numero-ordem,
                                                       INPUT tt-item-doc-est.cod-emitente,
                                                       INPUT tt-item-doc-est.it-codigo).
        
                        IF RETURN-VALUE = "OK":U THEN DO:
                            RUN getIntField IN h-bopy2006 (INPUT "cdn-imposto":U,
                                                           OUTPUT i-cod-tax-aux).
        
                            RUN getDecField IN h-bopy2006 (INPUT "val-preco-unit-com-iva":U,
                                                           OUTPUT de-val-preco-unit-com-iva).

                            IF i-cod-tax-aux = 0 THEN DO:
                                FOR FIRST item-mat
                                    FIELDS(cod-tax) NO-LOCK
                                    WHERE item-mat.it-codigo = item.it-codigo
                                      AND item-mat.cod-tax > 0:
                                END.
                                ASSIGN i-cod-tax-aux = IF AVAIL item-mat THEN item-mat.cod-tax ELSE 0.
                            END.
                        
                        END.
                    END.
                    ELSE DO:                    
                        FOR FIRST item-mat
                            FIELDS(cod-tax) NO-LOCK
                            WHERE item-mat.it-codigo = item.it-codigo
                              AND item-mat.cod-tax > 0:
                        END.
                        ASSIGN i-cod-tax-aux = IF AVAIL item-mat THEN item-mat.cod-tax ELSE 0.
                    END.

                    ASSIGN i-cod-tax-isd = 0.

                    /*Verifica se para o pa°s Equador deve gerar o imposto de ISD*/
                    IF (i-pais-impto-usuario = 21 /*Equador*/
                    AND (AVAIL embarq-imp-internac AND embarq-imp-internac.cdn-emitente-saida-div <> 0) /*Fornecedor do ISD*/
                    AND (AVAIL param-imp-internac  AND param-imp-internac.cdn-despes-saida-div     > 0) /*Despesa ISD*/)
                    OR (i-pais-impto-usuario = 2  /*Argentina*/
                    AND (AVAIL param-imp-internac 
                    AND param-imp-internac.num-livre-1          <> 0 /*Fornecedor do Imp Pa°s*/
                    AND param-imp-internac.cdn-despes-saida-div  > 0) /*Despesa Imp Pa°s*/)
                    THEN DO:
                        FIND item-internac NO-LOCK 
                            WHERE item-internac.it-codigo = ITEM.it-codigo NO-ERROR.
                        IF  AVAIL item-internac AND item-internac.cdn-imposto-saida-div > 0 THEN
                            ASSIGN i-cod-tax-isd = item-internac.cdn-imposto-saida-div.
                    END.

                    FOR FIRST nat-imp
                        FIELDS(cod-imposto) NO-LOCK
                        WHERE nat-imp.nat-operacao = natur-oper.nat-operacao 
                          AND nat-imp.cod-imposto > 0:
                    END.
                    ASSIGN i-nat-imp = IF AVAIL nat-imp THEN nat-imp.cod-imposto ELSE 0. 
                    
                    IF  AVAIL item
                    AND item.cod-tax-serv > 0
                    AND i-emit-natur      = 1 THEN
                        ASSIGN i-imp-retido = item.cod-tax-serv.
                    
                    ASSIGN i-cod-tax-ganan = 0.

                    IF i-pais-impto-usuario = 2
                        AND AVAIL ITEM THEN
                        ASSIGN i-cod-tax-ganan = INTEGER(SUBSTRING(ITEM.char-2,319,4)). /*Imposto de Ganancias*/

                    IF i-cod-tax-ganan <> 0
                        AND NOT CAN-FIND(FIRST tt-imposto
                                         WHERE tt-imposto.cdn-imposto = i-cod-tax-ganan) THEN DO:
                        FOR FIRST btipo-tax
                            FIELDS(tipo) NO-LOCK
                            WHERE btipo-tax.cod-tax = i-cod-tax-ganan:
                            
                            CREATE tt-imposto.
                            ASSIGN tt-imposto.cdn-imposto  = i-cod-tax-ganan
                                   tt-imposto.tipo-imposto = btipo-tax.tipo
                                   tt-imposto.cod-estabel  = c-estabel
                                   tt-imposto.nat-operacao = c-nat-oper
                                   tt-imposto.nome-pais    = c-pais
                                   tt-imposto.cod-estado   = c-uf
                                   tt-imposto.nom-cidade   = c-cidade
                                   tt-imposto.fm-codigo    = c-familia
                                   tt-imposto.it-codigo    = c-item.
                        END.
                    END.
                    FIND FIRST tt-imposto NO-LOCK
                         WHERE tt-imposto.cdn-imposto = i-cod-tax-aux NO-ERROR.
                    IF  NOT AVAIL tt-imposto THEN DO:
                        FOR FIRST btipo-tax
                            FIELDS(tipo) NO-LOCK
                            WHERE btipo-tax.cod-tax = i-cod-tax-aux:
                            
                            CREATE tt-imposto.
                            ASSIGN tt-imposto.cdn-imposto  = i-cod-tax-aux
                                   tt-imposto.tipo-imposto = btipo-tax.tipo
                                   tt-imposto.cod-estabel  = c-estabel
                                   tt-imposto.nat-operacao = c-nat-oper
                                   tt-imposto.nome-pais    = c-pais
                                   tt-imposto.cod-estado   = c-uf
                                   tt-imposto.nom-cidade   = c-cidade
                                   tt-imposto.fm-codigo    = c-familia
                                   tt-imposto.it-codigo    = c-item.
                        END.
                    END.
                    
                    IF (i-pais-impto-usuario = 2 OR i-pais-impto-usuario = 21)
                    AND i-cod-tax-isd      <> 0 THEN DO:
                    
                        FIND FIRST tt-imposto NO-LOCK
                             WHERE tt-imposto.cdn-imposto = i-cod-tax-isd NO-ERROR.
                        IF  NOT AVAIL tt-imposto THEN DO:
                            FOR FIRST tipo-tax-internac NO-LOCK
                                WHERE tipo-tax-internac.cod-tax = i-cod-tax-isd
                                  AND tipo-tax-internac.log-cr-saida-div = YES,
                                FIRST btipo-tax NO-LOCK
                                    WHERE btipo-tax.cod-tax = i-cod-tax-isd:

                                CREATE tt-imposto.
                                ASSIGN tt-imposto.cdn-imposto  = i-cod-tax-isd
                                       tt-imposto.tipo-imposto = btipo-tax.tipo
                                       tt-imposto.cod-estabel  = c-estabel
                                       tt-imposto.nat-operacao = c-nat-oper
                                       tt-imposto.nome-pais    = c-pais
                                       tt-imposto.cod-estado   = c-uf
                                       tt-imposto.nom-cidade   = c-cidade
                                       tt-imposto.fm-codigo    = c-familia
                                       tt-imposto.it-codigo    = c-item.
                            END.
                        END.
                    END.

                    FIND FIRST tt-imposto NO-LOCK
                         WHERE tt-imposto.cdn-imposto = i-nat-imp NO-ERROR.
                    IF  NOT AVAIL tt-imposto THEN DO:
                        FOR FIRST btipo-tax
                            FIELDS(tipo) NO-LOCK
                            WHERE btipo-tax.cod-tax = i-nat-imp: 
                            
                            CREATE tt-imposto.
                            ASSIGN tt-imposto.cdn-imposto  = i-nat-imp
                                   tt-imposto.tipo-imposto = btipo-tax.tipo
                                   tt-imposto.cod-estabel  = c-estabel
                                   tt-imposto.nat-operacao = c-nat-oper
                                   tt-imposto.nome-pais    = c-pais
                                   tt-imposto.cod-estado   = c-uf
                                   tt-imposto.nom-cidade   = c-cidade
                                   tt-imposto.fm-codigo    = c-familia
                                   tt-imposto.it-codigo    = c-item.
                        END.
                    END.
                    
                    FIND FIRST tt-imposto NO-LOCK
                         WHERE tt-imposto.cdn-imposto = i-imp-retido NO-ERROR.
                    IF  NOT AVAIL tt-imposto THEN DO:
                        FOR FIRST btipo-tax
                            FIELDS(tipo) NO-LOCK
                            WHERE btipo-tax.cod-tax = i-imp-retido:
                            
                            CREATE tt-imposto.
                            ASSIGN tt-imposto.cdn-imposto  = i-imp-retido
                                   tt-imposto.tipo-imposto = btipo-tax.tipo
                                   tt-imposto.cod-estabel  = c-estabel
                                   tt-imposto.nat-operacao = c-nat-oper
                                   tt-imposto.nome-pais    = c-pais
                                   tt-imposto.cod-estado   = c-uf
                                   tt-imposto.nom-cidade   = c-cidade
                                   tt-imposto.fm-codigo    = c-familia
                                   tt-imposto.it-codigo    = c-item.
                        END.
                    END.
                END.
            END.
            
            FOR EACH  tt-imposto NO-LOCK
                WHERE tt-imposto.cdn-imposto <> 0 
                   BY tt-imposto.tipo-imposto DESC:
                FIND FIRST tipo-tax NO-LOCK
                     WHERE tipo-tax.cod-tax = tt-imposto.cdn-imposto NO-ERROR.
                
                IF  tipo-tax.tipo                = 1
                AND tipo-tax.idi-val-base-retenc = 2 THEN DO:
                    FOR EACH  tt-impto-item-docto 
                        WHERE tt-impto-item-docto.serie-docto  = tt-docum-est.serie-docto   
                          AND tt-impto-item-docto.nro-docto    = tt-docum-est.nro-docto     
                          AND tt-impto-item-docto.cod-emitente = tt-docum-est.cod-emitente  
                          AND tt-impto-item-docto.nat-operacao = tt-docum-est.nat-operacao  
                          AND tt-impto-item-docto.num-seq      = tt-item-doc-est.sequencia,
                        FIRST btipo-tax NO-LOCK
                        WHERE btipo-tax.cod-tax = tt-impto-item-docto.cdn-imposto 
                          AND btipo-tax.tipo    = 2:
                        ASSIGN l-iva-normal = yes.
                    END.
                    IF  NOT l-iva-normal THEN NEXT.
                END.
                
                CREATE tt-impto-item-docto.
                ASSIGN tt-impto-item-docto.serie-docto  = tt-docum-est.serie-docto
                       tt-impto-item-docto.nro-docto    = tt-docum-est.nro-docto
                       tt-impto-item-docto.cod-emitente = tt-docum-est.cod-emitente
                       tt-impto-item-docto.nat-operacao = tt-docum-est.nat-operacao
                       tt-impto-item-docto.num-seq      = tt-item-doc-est.sequencia
                       tt-impto-item-docto.cdn-imposto  = tt-imposto.cdn-imposto
                       tt-impto-item-docto.perc-imposto = IF AVAIL tipo-tax THEN tipo-tax.tax-perc ELSE 0.

                IF tipo-tax.tipo = 2 THEN DO:
                    ASSIGN tt-impto-item-docto.idi-tipo-impto = 1. /*Imposto de Iva Normal*/
                    
                    IF i-pais-impto-usuario = 2
                       AND tipo-tax.cod-tax = i-cod-tax-ganan THEN
                        ASSIGN tt-impto-item-docto.idi-tipo-impto = 2. /*Imposto de Percepá∆o Ganancias*/
                END.

                IF (i-pais-impto-usuario = 2 OR i-pais-impto-usuario = 21)
                AND CAN-FIND(FIRST tipo-tax-internac
                             WHERE tipo-tax-internac.cod-tax          = tipo-tax.cod-tax
                               AND tipo-tax-internac.log-cr-saida-div = YES) /* CrÇdito ISD */ THEN DO:

                    /*Calcula base do ISD*/
                    ASSIGN de-base-ipi = 0.
                    FOR EACH  desp-item-doc-est NO-LOCK
                        WHERE desp-item-doc-est.serie-docto  = tt-docum-est.serie-docto
                          AND desp-item-doc-est.nro-docto    = tt-docum-est.nro-docto
                          AND desp-item-doc-est.cod-emitente = tt-docum-est.cod-emitente
                          AND desp-item-doc-est.nat-operacao = tt-docum-est.nat-operacao
                          AND desp-item-doc-est.sequencia    = tt-item-doc-est.sequencia:
                        FIND FIRST desp-imp NO-LOCK
                             WHERE desp-imp.cod-desp = INT(desp-item-doc-est.cod-despesa) NO-ERROR.
                        IF  AVAIL desp-imp AND desp-imp.log-incid-base-isd = YES AND 
                            NOT CAN-FIND(FIRST tt-desp-comp 
                                         WHERE tt-desp-comp.cod-desp = int(desp-item-doc-est.cod-despesa)) THEN
                            ASSIGN de-base-ipi = de-base-ipi + desp-item-doc-est.val-despesa.
                    END.
                END.
                ELSE DO:
                    /* Base demais impostos */
                    ASSIGN de-base-ipi = 0.
                    FOR EACH  desp-item-doc-est NO-LOCK
                        WHERE desp-item-doc-est.serie-docto  = tt-docum-est.serie-docto
                          AND desp-item-doc-est.nro-docto    = tt-docum-est.nro-docto
                          AND desp-item-doc-est.cod-emitente = tt-docum-est.cod-emitente
                          AND desp-item-doc-est.nat-operacao = tt-docum-est.nat-operacao
                          AND desp-item-doc-est.sequencia    = tt-item-doc-est.sequencia:
                        FIND FIRST desp-imp NO-LOCK
                             WHERE desp-imp.cod-desp = INT(desp-item-doc-est.cod-despesa) NO-ERROR.
                        IF  AVAIL desp-imp AND desp-imp.inc-base-ipi AND 
                            NOT CAN-FIND(FIRST tt-desp-comp 
                                         WHERE tt-desp-comp.cod-desp = INT(desp-item-doc-est.cod-despesa)) THEN DO:
                                ASSIGN de-base-ipi = de-base-ipi + desp-item-doc-est.val-despesa.
                        END.
                    END.                
                END.

                IF i-pais-impto-usuario = 9 /* Paraguai */ AND tipo-tax.tipo = 2 AND
                   AVAIL cotacao-item AND cotacao-item.codigo-ipi THEN
                    ASSIGN d-preco-total = (de-val-preco-unit-com-iva / (1 + (tt-impto-item-docto.perc-imposto / 100))) * ordem-compra.qt-solic.
                ELSE
                    ASSIGN d-preco-total = tt-item-doc-est.preco-total-me.
                
                IF  l-transf /* Transferància de drawback */ THEN
                    ASSIGN d-preco-total = 0. /* Somente as despesas que incidem no IVA devem contar na base do imposto */

                IF de-cot-var-cambial <> 0 THEN DO:
                    RUN rep/re0412.p (INPUT (d-preco-total + de-base-ipi),
                                      INPUT tt-item-doc-est.desconto-me,
                                      INPUT tt-impto-item-docto.cdn-imposto,
                                      INPUT tt-impto-item-docto.perc-imposto,
                                      INPUT TABLE tt-impto-item-docto,
                                      INPUT tt-docum-est.mo-codigo,
                                      INPUT de-cot-var-cambial,
                                      OUTPUT de-vl-base-calc,
                                      OUTPUT de-vl-imposto,
                                      OUTPUT de-vl-imposto-me).
                END.
                ELSE DO:
                    RUN rep/re0412.p (INPUT (d-preco-total + de-base-ipi),
                                      INPUT tt-item-doc-est.desconto-me,
                                      INPUT tt-impto-item-docto.cdn-imposto,
                                      INPUT tt-impto-item-docto.perc-imposto,
                                      INPUT TABLE tt-impto-item-docto,
                                      INPUT tt-docum-est.mo-codigo,
                                      INPUT tt-docum-est.cotacao-dia,
                                      OUTPUT de-vl-base-calc,
                                      OUTPUT de-vl-imposto,
                                      OUTPUT de-vl-imposto-me).
                END.
                
                ASSIGN tt-impto-item-docto.val-impto-merc-ext = de-vl-imposto-me
                       tt-impto-item-docto.val-impto          = de-vl-imposto
                       tt-impto-item-docto.val-base-me        = (d-preco-total + de-base-ipi).

                IF  l-transf /* Transferància de drawback */ THEN
                    ASSIGN tt-impto-item-docto.val-base-me = de-base-ipi.

                IF tt-docum-est.mo-codigo <> 0 THEN
                    ASSIGN tt-impto-item-docto.val-base = IF de-cot-var-cambial <> 0 THEN (tt-impto-item-docto.val-base-me * de-cot-var-cambial) ELSE (tt-impto-item-docto.val-base-me * tt-nota.cotacao-dia).
                ELSE
                    ASSIGN tt-impto-item-docto.val-base = tt-impto-item-docto.val-base-me.
            END.
            
            FOR EACH tt-impto-item-docto:
                FIND FIRST impto-item-docto EXCLUSIVE-LOCK
                     WHERE impto-item-docto.serie-docto  = tt-item-doc-est.serie-docto
                       AND impto-item-docto.nro-docto    = tt-item-doc-est.nro-docto
                       AND impto-item-docto.cod-emitente = tt-item-doc-est.cod-emitente
                       AND impto-item-docto.nat-operacao = tt-item-doc-est.nat-operacao
                       AND impto-item-docto.num-seq      = tt-item-doc-est.sequencia
                       AND impto-item-docto.cdn-imposto  = tt-impto-item-docto.cdn-imposto NO-ERROR.
                IF  NOT AVAIL impto-item-docto THEN DO:
                    CREATE impto-item-docto.
                    ASSIGN impto-item-docto.serie-docto        = tt-item-doc-est.serie-docto
                           impto-item-docto.nro-docto          = tt-item-doc-est.nro-docto
                           impto-item-docto.cod-emitente       = tt-item-doc-est.cod-emitente
                           impto-item-docto.nat-operacao       = tt-item-doc-est.nat-operacao
                           impto-item-docto.num-seq            = tt-item-doc-est.sequencia
                           impto-item-docto.cdn-imposto        = tt-impto-item-docto.cdn-imposto
                           impto-item-docto.perc-imposto       = tt-impto-item-docto.perc-imposto
                           impto-item-docto.val-impto-merc-ext = tt-impto-item-docto.val-impto-merc-ext
                           impto-item-docto.val-impto          = tt-impto-item-docto.val-impto.
                END.
                ELSE DO:
                   ASSIGN impto-item-docto.perc-imposto       = tt-impto-item-docto.perc-imposto
                          impto-item-docto.val-impto-merc-ext = tt-impto-item-docto.val-impto-merc-ext
                          impto-item-docto.val-impto          = tt-impto-item-docto.val-impto.
                END.

                ASSIGN impto-item-docto.idi-tipo-impto = tt-impto-item-docto.idi-tipo-impto
                       impto-item-docto.val-base-me    = tt-impto-item-docto.val-base-me
                       impto-item-docto.val-base       = tt-impto-item-docto.val-base.
            END.

            IF i-pais-impto-usuario = 2       
                AND tt-docum-est.nff /*Fatura*/
                AND VALID-HANDLE(h-boar2006) 
                AND (AVAIL natur-oper AND natur-oper.tipo-trib = 2 /*Normal*/ ) THEN DO:
                
                /* Recalcula o valor de-base-ipi devido ao Imposto Pa°s - Base demais impostos */
                ASSIGN de-base-ipi = 0.
                FOR EACH  desp-item-doc-est NO-LOCK
                    WHERE desp-item-doc-est.serie-docto  = tt-docum-est.serie-docto
                      AND desp-item-doc-est.nro-docto    = tt-docum-est.nro-docto
                      AND desp-item-doc-est.cod-emitente = tt-docum-est.cod-emitente
                      AND desp-item-doc-est.nat-operacao = tt-docum-est.nat-operacao
                      AND desp-item-doc-est.sequencia    = tt-item-doc-est.sequencia:
                    FIND FIRST desp-imp NO-LOCK
                         WHERE desp-imp.cod-desp = INT(desp-item-doc-est.cod-despesa) NO-ERROR.
                    IF  AVAIL desp-imp AND desp-imp.inc-base-ipi AND 
                        NOT CAN-FIND(FIRST tt-desp-comp 
                                     WHERE tt-desp-comp.cod-desp = INT(desp-item-doc-est.cod-despesa)) THEN DO:
                            ASSIGN de-base-ipi = de-base-ipi + desp-item-doc-est.val-despesa.
                    END.
                END.

                EMPTY TEMP-TABLE tt-impto-item-docto.
                RUN setCotacao IN h-boar2006 (INPUT de-cot-var-cambial).
                RUN calcularImpostoPercep IN h-boar2006 (INPUT tt-item-doc-est.it-codigo,
                                                         INPUT tt-item-doc-est.sequencia,
                                                         INPUT ROWID(docum-est),
                                                         INPUT IF  l-transf /* Transf drawback */ THEN de-base-ipi ELSE (tt-item-doc-est.preco-total-me + de-base-ipi),
                                                         INPUT-OUTPUT TABLE tt-impto-item-docto).
                FOR EACH tt-impto-item-docto:
                    FIND FIRST impto-item-docto EXCLUSIVE-LOCK
                         WHERE impto-item-docto.serie-docto  = tt-item-doc-est.serie-docto
                           AND impto-item-docto.nro-docto    = tt-item-doc-est.nro-docto
                           AND impto-item-docto.cod-emitente = tt-item-doc-est.cod-emitente
                           AND impto-item-docto.nat-operacao = tt-item-doc-est.nat-operacao
                           AND impto-item-docto.num-seq      = tt-item-doc-est.sequencia
                           AND impto-item-docto.cdn-imposto  = tt-impto-item-docto.cdn-imposto NO-ERROR.
                    IF  NOT AVAIL impto-item-docto THEN DO:
                        CREATE impto-item-docto.
                        ASSIGN impto-item-docto.serie-docto        = tt-item-doc-est.serie-docto
                               impto-item-docto.nro-docto          = tt-item-doc-est.nro-docto
                               impto-item-docto.cod-emitente       = tt-item-doc-est.cod-emitente
                               impto-item-docto.nat-operacao       = tt-item-doc-est.nat-operacao
                               impto-item-docto.num-seq            = tt-item-doc-est.sequencia
                               impto-item-docto.cdn-imposto        = tt-impto-item-docto.cdn-imposto
                               impto-item-docto.perc-imposto       = tt-impto-item-docto.perc-imposto
                               impto-item-docto.val-impto-merc-ext = tt-impto-item-docto.val-impto-merc-ext
                               impto-item-docto.val-impto          = tt-impto-item-docto.val-impto.
                    END.
                    ELSE DO:
                       ASSIGN impto-item-docto.perc-imposto       = tt-impto-item-docto.perc-imposto
                              impto-item-docto.val-impto-merc-ext = tt-impto-item-docto.val-impto-merc-ext
                              impto-item-docto.val-impto          = tt-impto-item-docto.val-impto.
                    END.
                    ASSIGN impto-item-docto.idi-tipo-impto = tt-impto-item-docto.idi-tipo-impto
                           impto-item-docto.val-base-me    = tt-impto-item-docto.val-base-me
                           impto-item-docto.val-base       = tt-impto-item-docto.val-base.
                END.
            END.
        END.            
    END.                           
    
    IF  VALID-HANDLE (h-cdapi027) THEN DO:
        DELETE PROCEDURE h-cdapi027.
        ASSIGN h-cdapi027 = ?.
    END.
    
    IF VALID-HANDLE(h-boar2006) THEN DO:
        RUN destroy IN h-boar2006.
        ASSIGN h-boar2006 = ?.
    END.

    IF VALID-HANDLE(h-bopy2006) THEN DO:
        RUN destroy IN h-bopy2006.
        ASSIGN h-bopy2006 = ?.
    END.
    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-trata-transf-drb:
    DEF BUFFER b-embarq-import-docto FOR embarq-import-docto.
    DEF BUFFER b-docum-est           FOR docum-est.
    DEF BUFFER b-item-doc-est        FOR item-doc-est.
    
    FIND FIRST tt-docum-est NO-LOCK NO-ERROR.
    
    FOR FIRST docum-est EXCLUSIVE-LOCK
        WHERE docum-est.cod-emitente = tt-docum-est.cod-emitente
        AND   docum-est.nat-operacao = tt-docum-est.nat-operacao
        AND   docum-est.nro-docto    = tt-docum-est.nro-docto   
        AND   docum-est.serie-docto  = tt-docum-est.serie-docto:

        FOR FIRST embarq-import-docto EXCLUSIVE-LOCK
            WHERE embarq-import-docto.cod-ser-docto    = docum-est.serie-docto
            AND   embarq-import-docto.cod-docto        = docum-est.nro-docto
            AND   embarq-import-docto.cdn-emitente     = docum-est.cod-emitente
            AND   embarq-import-docto.cod-natur-operac = docum-est.nat-operacao: 
            ASSIGN embarq-import-docto.log-transf-draw = YES.
        END.  

        FOR FIRST param-imp NO-LOCK
            WHERE param-imp.cod-estabel = embarq-import-docto.cod-estab: END.

        {cdp/cd4300.i4 "yes" param-imp.char-1}
        {cxbo/bocx250.i51 "yes"}
        
        assign i-cod-desp-ii     = i-desp-ii-i50
               i-cod-emitente-ii = i-emitente-ii-i50.

        ASSIGN docum-est.nff             = YES
               docum-est.valor-embal     = 0
               docum-est.valor-frete     = 0
               docum-est.valor-mercad    = 0
               docum-est.valor-outras    = 0
               docum-est.valor-seguro    = 0
               docum-est.valor-embal-me  = 0
               docum-est.valor-frete-me  = 0
               docum-est.valor-mercad-me = 0
               docum-est.valor-outras-me = 0
               docum-est.valor-seguro-me = 0
               docum-est.despesa-nota    = 0
               docum-est.tot-peso        = 0
               docum-est.peso-bruto-tot  = 0
               docum-est.tot-valor       = 0.

        FOR EACH item-doc-est EXCLUSIVE-LOCK
            WHERE item-doc-est.cod-emitente = docum-est.cod-emitente
            AND   item-doc-est.nat-operacao = docum-est.nat-operacao
            AND   item-doc-est.nro-docto    = docum-est.nro-docto   
            AND   item-doc-est.serie-docto  = docum-est.serie-docto:

            /* Procura o documento original para encontrar o lote do item. Necess†rio pois a api do estoque valida a exitància do lote */
            IF  CAN-FIND (FIRST ITEM
                          WHERE ITEM.it-codigo = item-doc-est.it-codigo
                            AND ITEM.tipo-con-est > 1) THEN DO:
                for each b-embarq-import-docto 
                   where b-embarq-import-docto.cod-estab   = docum-est.cod-estabel
                     and b-embarq-import-docto.cod-embarq  = substr(embarque-imp.char-1,61,20) no-lock,
                   first b-docum-est
                   where b-docum-est.serie-docto  = b-embarq-import-docto.cod-ser-docto             
                     and b-docum-est.nro-docto    = b-embarq-import-docto.cod-docto                 
                     and b-docum-est.cod-emitente = b-embarq-import-docto.cdn-emitente              
                     and b-docum-est.nat-operacao = b-embarq-import-docto.cod-natur-operac
                     and b-docum-est.ce-atual     = YES no-lock,
                   FIRST b-item-doc-est
                        WHERE b-item-doc-est.serie-docto  = b-docum-est.serie-docto
                          AND b-item-doc-est.nro-docto    = b-docum-est.nro-docto
                          AND b-item-doc-est.cod-emitente = b-docum-est.cod-emitente
                          AND b-item-doc-est.nat-operacao = b-docum-est.nat-operacao
                          AND b-item-doc-est.it-codigo    = item-doc-est.it-codigo
                          AND b-item-doc-est.cod-refer    = item-doc-est.cod-refer NO-LOCK: 

                    IF  b-item-doc-est.lote <> "" THEN DO:
                        ASSIGN item-doc-est.lote         = b-item-doc-est.lote
                               item-doc-est.dt-vali-lote = b-item-doc-est.dt-vali-lote.

                        FOR FIRST rat-lote EXCLUSIVE-LOCK
                            WHERE rat-lote.cod-emitente = item-doc-est.cod-emitente
                              AND rat-lote.nat-operacao = item-doc-est.nat-operacao
                              AND rat-lote.nro-docto    = item-doc-est.nro-docto   
                              AND rat-lote.serie-docto  = item-doc-est.serie-docto
                              AND rat-lote.sequencia    = item-doc-est.sequencia:

                            ASSIGN rat-lote.lote         = item-doc-est.lote        
                                   rat-lote.dt-vali-lote = item-doc-est.dt-vali-lote
                                   rat-lote.quantidade   = 0.
                        END.

                        LEAVE. 
                    END. 
                end.
            END.
            ELSE DO:
                IF  CAN-FIND (FIRST ITEM
                              WHERE ITEM.it-codigo = item-doc-est.it-codigo
                                AND ITEM.tipo-con-est = 1) THEN DO:
                    FOR FIRST rat-lote EXCLUSIVE-LOCK
                        WHERE rat-lote.cod-emitente = item-doc-est.cod-emitente
                          AND rat-lote.nat-operacao = item-doc-est.nat-operacao
                          AND rat-lote.nro-docto    = item-doc-est.nro-docto   
                          AND rat-lote.serie-docto  = item-doc-est.serie-docto
                          AND rat-lote.sequencia    = item-doc-est.sequencia:

                        ASSIGN rat-lote.quantidade   = 0.
                    END.      
                END.
            END.
            
            /*Se tiver sido criado a rat-ordem deve ser eliminada pois n∆o haver† atualizaá∆o de qtdes no estoque*/
            FOR EACH rat-ordem EXCLUSIVE-LOCK
                {cdp/cd8900.i rat-ordem item-doc-est} 
                AND rat-ordem.sequencia = item-doc-est.sequencia:
                DELETE rat-ordem.
            END.

            ASSIGN item-doc-est.qt-do-forn        = 0
                   item-doc-est.quantidade        = 0 
                   item-doc-est.qt-saldo          = 0
                   item-doc-est.num-event-contrat = 0
                   item-doc-est.log-fifo-oc       = NO
                   item-doc-est.encerra-pa        = NO
                   item-doc-est.nr-ord-produ      = 0
                   item-doc-est.item-pai          = ""
                   item-doc-est.cod-roteiro       = ""
                   item-doc-est.op-codigo         = 0
                   item-doc-est.qt-etiquetas      = 0
                   item-doc-est.qt-do-forn        = 0
                   item-doc-est.quantidade        = 0
                   item-doc-est.desconto          = 0
                   item-doc-est.peso-liquido      = 0
                   item-doc-est.despesas[1]       = 0
                   item-doc-est.preco-total[1]    = 0
                   item-doc-est.preco-unit[1]     = 0
                   item-doc-est.preco-total-me    = 0
                   item-doc-est.preco-unit-me     = 0
                   d-valor-item-docto             = 0
                   d-valor-item-docto-me          = 0.

            FOR EACH  item-doc-est-cex NO-LOCK
                WHERE item-doc-est-cex.serie-docto  = item-doc-est.serie-docto      
                  AND item-doc-est-cex.nro-docto    = string(item-doc-est.nro-docto)
                  AND item-doc-est-cex.cod-emitente = item-doc-est.cod-emitente     
                  AND item-doc-est-cex.nat-operacao = item-doc-est.nat-operacao     
                  AND item-doc-est-cex.sequencia    = item-doc-est.sequencia:

                IF NOT CAN-FIND(FIRST desp-embarque NO-LOCK
                                WHERE desp-embarque.embarque    = embarq-import-docto.cod-embarq
                                AND   desp-embarque.cod-estabel = embarq-import-docto.cod-estab
                                AND   desp-embarque.cod-desp    = item-doc-est-cex.cod-desp) 
                    AND item-doc-est-cex.cod-desp <> param-imp.cdn-despes-tax-estatis /*Taxa de Estat°stica*/
                    AND item-doc-est-cex.cod-desp <> i-cod-desp-ii                    /*II*/ THEN
                    NEXT.

                FOR FIRST desp-imp NO-LOCK
                    WHERE desp-imp.cod-desp = item-doc-est-cex.cod-desp: END.            

                IF (AVAIL desp-imp AND SUBSTRING(desp-imp.char-1,45,1) <> "Y":U)                    
                    OR item-doc-est-cex.cod-desp = param-imp.cdn-despes-tax-estatis  
                    OR item-doc-est-cex.cod-desp = i-cod-desp-ii THEN DO:

                    IF docum-est.mo-codigo <> 0 THEN DO:                        
                        
                        ASSIGN d-valor-item-docto-me = d-valor-item-docto-me + (item-doc-est-cex.val-desp / docum-est.cotacao-dia).
                    END.    
                    ELSE 
                        ASSIGN d-valor-item-docto-me = d-valor-item-docto-me + item-doc-est-cex.val-desp.
                END.
            END.

            ASSIGN item-doc-est.preco-total[1]  = IF docum-est.mo-codigo <> 0 THEN ROUND((ROUND(d-valor-item-docto-me,2) * docum-est.cotacao-dia),2) ELSE ROUND(d-valor-item-docto-me,2)
                   item-doc-est.preco-unit[1]   = IF docum-est.mo-codigo <> 0 THEN ROUND((ROUND(d-valor-item-docto-me,2) * docum-est.cotacao-dia),2) ELSE ROUND(d-valor-item-docto-me,2)
                   item-doc-est.preco-total-me  = ROUND(d-valor-item-docto-me,2)
                   item-doc-est.preco-unit-me   = ROUND(d-valor-item-docto-me,2)
                   docum-est.valor-mercad       = docum-est.valor-mercad + item-doc-est.preco-total[1]
                   docum-est.tot-valor          = docum-est.tot-valor + item-doc-est.preco-total[1].
    
            FOR FIRST tt-itens 
                WHERE tt-itens.sequencia = item-doc-est.sequencia:
                ASSIGN tt-itens.preco-total    = item-doc-est.preco-total[1]
                       tt-itens.preco-unit     = item-doc-est.preco-unit[1]
                       tt-itens.preco-total-mo = item-doc-est.preco-total-me
                       tt-itens.preco-unit-mo  = item-doc-est.preco-unit-me.
            END.

            FOR FIRST tt-item-doc-est
                WHERE tt-item-doc-est.sequencia = item-doc-est.sequencia:
                ASSIGN tt-item-doc-est.preco-total    = item-doc-est.preco-total[1]
                       tt-item-doc-est.preco-unit     = item-doc-est.preco-unit[1]
                       tt-item-doc-est.preco-total-me = item-doc-est.preco-total-me
                       tt-item-doc-est.preco-unit-me  = item-doc-est.preco-unit-me.
            END.
        END.

        /*Para o tipo transferància deve ser gerado o t°tulo no final ap¢s o calculo dos impostos*/
        RUN pi-gera-duplicata (OUTPUT TABLE tt-dupli-apagar).
    END.  

    RETURN "OK":U.
END PROCEDURE.
