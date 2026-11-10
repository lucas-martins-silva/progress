/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IMAPI011 2.00.00.012 } /*** "010012" 14/11/2025 16:15:34 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i imapi011 MIM}
&ENDIF

{cdp/cdcfgmat.i}

/********************************************************************************
**
**  IMAPI011.P - Objetivo: Calcular o valor dos impostos PIS e COFINS nos itens da Adi‡Æo da DI
**
********************************************************************************/
DEFINE VARIABLE de-aliq-ii                        AS   DECIMAL                                   NO-UNDO.
DEFINE VARIABLE de-aliq-pis                       AS   DECIMAL                                   NO-UNDO.
DEFINE VARIABLE de-valor-un-pis                   AS   DECIMAL                                   NO-UNDO.
DEFINE VARIABLE de-valor-vol-pis                  AS   DECIMAL                                   NO-UNDO.
DEFINE VARIABLE de-aliq-cofins                    AS   DECIMAL                                   NO-UNDO.
DEFINE VARIABLE de-valor-un-cofins                AS   DECIMAL                                   NO-UNDO.
DEFINE VARIABLE de-valor-vol-cofins               AS   DECIMAL                                   NO-UNDO.
DEFINE VARIABLE de-val-merc                       AS   DECIMAL                                   NO-UNDO.
DEFINE VARIABLE de-val-merc-cotac                 AS   DECIMAL                                   NO-UNDO.
DEFINE VARIABLE de-qtd-do-forn                    AS   DECIMAL                                   NO-UNDO.
DEFINE VARIABLE de-val-acum-desp                  AS   DECIMAL                                   NO-UNDO.
DEFINE VARIABLE de-val-acum-desp-pis              AS   DECIMAL                                   NO-UNDO.
DEFINE VARIABLE de-val-acum-desp-cofins           AS   DECIMAL                                   NO-UNDO.
DEFINE VARIABLE de-val-acum-desp-adu-pis          AS   DECIMAL                                   NO-UNDO.
DEFINE VARIABLE de-val-acum-desp-adu-cofins       AS   DECIMAL                                   NO-UNDO.
DEFINE VARIABLE de-valor-aduaneiro-cofins         AS   DECIMAL                                   NO-UNDO.
DEFINE VARIABLE de-valor-aduaneiro-pis            AS   DECIMAL                                   NO-UNDO.
DEFINE VARIABLE deIndice                          AS   DECIMAL                                   NO-UNDO.
DEFINE VARIABLE de-va-pis                         AS   DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999":U NO-UNDO. /* Valor Aduaneiro PIS        */
DEFINE VARIABLE de-da-pis                         AS   DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999":U NO-UNDO. /* Despesas Aduaneiras PIS    */
DEFINE VARIABLE de-va-cofins                      AS   DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999":U NO-UNDO. /* Valor Aduaneiro COFINS     */
DEFINE VARIABLE de-da-cofins                      AS   DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999":U NO-UNDO. /* Despesas Aduaneiras COFINS */
DEFINE VARIABLE de-red-pis                        AS   DECIMAL FORMAT ">>9.99":U                 NO-UNDO. /* Valor Reducao PIS          */
DEFINE VARIABLE de-red-cofins                     AS   DECIMAL FORMAT ">>9.99":U                 NO-UNDO. /* Valor Reducao COFINS       */
DEFINE VARIABLE de-a                              AS   DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999":U NO-UNDO. /* aliq imposto de importacao */
DEFINE VARIABLE de-b                              AS   DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999":U NO-UNDO. /* aliq ipi */
DEFINE VARIABLE de-c                              AS   DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999":U NO-UNDO. /* aliq pis */
DEFINE VARIABLE de-d                              AS   DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999":U NO-UNDO. /* aliq cofins */
DEFINE VARIABLE de-e                              AS   DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999":U NO-UNDO. /* aliq icms */
DEFINE VARIABLE de-VA                             AS   DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999":U NO-UNDO. /* valor aduaneiro */
DEFINE VARIABLE de-DA                             AS   DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99999":U NO-UNDO. /* despesas aduaneiras */
DEFINE VARIABLE h-im9048                          AS   HANDLE                                    NO-UNDO.
DEFINE VARIABLE h-im9042                          AS   HANDLE                                    NO-UNDO.
DEFINE VARIABLE h-bocx383                         AS   HANDLE                                    NO-UNDO.
DEFINE VARIABLE h-boin082ca                       AS   HANDLE                                    NO-UNDO.
DEFINE VARIABLE h-numero-ordem                    AS   HANDLE                                    NO-UNDO.                            
DEFINE VARIABLE h-seq-cotac                       AS   HANDLE                                    NO-UNDO.
DEFINE VARIABLE h-cod-emitente                    AS   HANDLE                                    NO-UNDO.
DEFINE VARIABLE i-trib-ii                         AS   INTEGER                                   NO-UNDO.
DEFINE VARIABLE i-trib-pis                        AS   INTEGER                                   NO-UNDO.
DEFINE VARIABLE i-trib-cofins                     AS   INTEGER                                   NO-UNDO.
DEFINE VARIABLE l-deleta-erros                    AS   LOGICAL                                   NO-UNDO.
DEFINE VARIABLE l-base-pis-manual                 AS   LOGICAL INITIAL NO                        NO-UNDO.
DEFINE VARIABLE l-valor-pis-manual                AS   LOGICAL INITIAL NO                        NO-UNDO.
DEFINE VARIABLE l-base-cofins-manual              AS   LOGICAL INITIAL NO                        NO-UNDO.
DEFINE VARIABLE l-valor-cofins-manual             AS   LOGICAL INITIAL NO                        NO-UNDO.
DEFINE VARIABLE i-trib-ipi                        LIKE item-doc-est.cd-trib-ipi                  NO-UNDO.
DEFINE VARIABLE de-aliq-ipi                       LIKE item-doc-est.aliquota-ipi                 NO-UNDO.
DEFINE VARIABLE c-trib-icm                        LIKE item-doc-est.cd-trib-icm                  NO-UNDO.
DEFINE VARIABLE de-aliq-icm                       LIKE item-doc-est.aliquota-ipi                 NO-UNDO.
DEFINE VARIABLE de-valor-desp                     LIKE cotacao-item-cex.val-desp                 NO-UNDO.
DEFINE VARIABLE de-valor-desp-adu                 LIKE cotacao-item-cex.val-desp                 NO-UNDO.
DEFINE VARIABLE d-val-desp-convert                LIKE desp-imp.val-desp                         NO-UNDO.
DEFINE VARIABLE p-valor-desp-pis                  LIKE desp-imp.val-desp                         NO-UNDO.
DEFINE VARIABLE p-valor-desp-cofins               LIKE desp-imp.val-desp                         NO-UNDO.
DEFINE VARIABLE i-cod-desp-ii                     LIKE desp-imp.cod-desp                         NO-UNDO.
DEFINE VARIABLE i-cod-emitente-ii                 LIKE emitente.cod-emitente                     NO-UNDO.

DEFINE BUFFER b-emit-estab       FOR emitente.
DEFINE BUFFER b-desp-imp         FOR desp-imp.
DEFINE BUFFER b-cotacao-item-cex FOR cotacao-item-cex.

{cdp/cd0666.i}    /* definicao da temp-table geral tt-erro */
{cdp/cd4300.i3}   /* variaveis utilizadas pela cc9019.i50 */
{cdp/cdapi020.i}  /* definicao da temp-table tt-formula */
{cxbo/bocx250.i2} /* variaveis utilizadas pela bocx250.i3 */

DEFINE INPUT  PARAMETER p-num-di-ems      LIKE decla-import.num-di-ems            NO-UNDO. /*--- recebe o numero da di (num-di-ems) ---*/
DEFINE INPUT  PARAMETER p-data-di         LIKE decla-import.dat-di                NO-UNDO. /*--- recebe a data di ---*/
DEFINE INPUT  PARAMETER p-num-adic        LIKE decla-import-adic.num-adic         NO-UNDO. /*--- recebe o numero da adicao ---*/
DEFINE INPUT  PARAMETER p-num-seq         LIKE decla-import-adic-itens.num-seq    NO-UNDO. /*--- recebe o numero da sequencia ---*/
DEFINE INPUT  PARAMETER p-cod-estab       LIKE decla-import.cod-estab             NO-UNDO. /*--- recebe o numero da adicao ---*/
DEFINE INPUT  PARAMETER p-cdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts     NO-UNDO.
DEFINE OUTPUT PARAMETER d-val-pis-sist    LIKE decla-import-adic.val-pis-db-cr    NO-UNDO. /*--- retorna o valor de pis --*/
DEFINE OUTPUT PARAMETER d-val-cofins-sist LIKE decla-import-adic.val-cofins-db-cr NO-UNDO. /*--- retorna o valor de cofins --*/


IF VALID-HANDLE (h-boin082ca) THEN DO:
    DELETE PROCEDURE h-boin082ca.
    ASSIGN h-boin082ca = ?.
END.

IF NOT VALID-HANDLE(h-im9048) THEN
    RUN imp/im9048.p PERSISTENT SET h-im9048.

IF NOT VALID-HANDLE(h-bocx383) THEN
    RUN cxbo/bocx383.p PERSISTENT SET h-bocx383.

FOR FIRST decla-import-adic EXCLUSIVE-LOCK
    WHERE decla-import-adic.num-di-ems = p-num-di-ems
      AND decla-import-adic.num-adic   = p-num-adic
      AND decla-import-adic.cdd-siscomex-dts = p-cdd-siscomex-dts:

    /* base pis */
    IF SUBSTRING(decla-import-adic.cod-livre-1,6,1) = "":U OR SUBSTRING(decla-import-adic.cod-livre-1,6,1) = "N":U THEN
        ASSIGN l-base-pis-manual = NO.
    ELSE 
        ASSIGN l-base-pis-manual = YES.

    /* base cofins */
    IF SUBSTRING(decla-import-adic.cod-livre-1,7,1) = "":U OR SUBSTRING(decla-import-adic.cod-livre-1,7,1) = "N":U THEN
        ASSIGN l-base-cofins-manual = NO.
    ELSE 
        ASSIGN l-base-cofins-manual = YES.

    FIND FIRST decla-import-adic-itens EXCLUSIVE-LOCK
         WHERE decla-import-adic-itens.num-di-ems = p-num-di-ems
           AND decla-import-adic-itens.num-adic   = p-num-adic
           AND decla-import-adic-itens.num-seq    = p-num-seq 
           AND decla-import-adic-itens.cdd-siscomex-dts = p-cdd-siscomex-dts NO-ERROR.

    FIND FIRST decla-import-ord EXCLUSIVE-LOCK
        WHERE decla-import-ord.num-di-ems  = decla-import-adic-itens.num-di-ems
          AND decla-import-ord.num-ordem   = decla-import-adic-itens.num-ordem
          AND decla-import-ord.num-parcela = decla-import-adic-itens.num-parcela 
          AND decla-import-ord.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts NO-ERROR.

    FIND FIRST param-imp NO-LOCK
         WHERE param-imp.cod-estabel = p-cod-estab NO-ERROR.

    /* verifica se o valor ou a base do pis e cofins foram alterados manualmente */
    &IF '{&BF_MAT_VERSAO_EMS}' < '2.09' &THEN
        /* valor pis */
        IF SUBSTRING(decla-import-adic.cod-livre-1,11,1) = "":U OR SUBSTRING(decla-import-adic.cod-livre-1,11,1) = "N":U THEN
            ASSIGN l-valor-pis-manual = NO.
        ELSE 
            ASSIGN l-valor-pis-manual = YES.
    
       /* valor cofins */
        IF SUBSTRING(decla-import-adic.cod-livre-1,12,1) = "":U OR SUBSTRING(decla-import-adic.cod-livre-1,12,1) = "N":U THEN
            ASSIGN l-valor-cofins-manual = NO.
        ELSE 
            ASSIGN l-valor-cofins-manual = YES.
    &ELSE
        /* valor pis */
        IF NOT decla-import-adic.log-ava-valor-pis THEN
            ASSIGN l-valor-pis-manual = NO.
        ELSE 
            ASSIGN l-valor-pis-manual = YES.

        /* valor cofins */
        IF NOT decla-import-adic.log-ava-valor-cofins THEN
            ASSIGN l-valor-cofins-manual = NO.
        ELSE 
            ASSIGN l-valor-cofins-manual = YES.

    &ENDIF
    
    /*--- verifica se foi informado valor unitario neste caso assume estes valores e nao aplica a formula ---*/
    IF  decla-import-adic-itens.val-unit-pis    > 0
    OR  decla-import-adic-itens.val-unit-cofins > 0 THEN DO:
        
        /*--- determina valor do PIS ---*/
        IF  decla-import-adic-itens.val-unit-pis > 0 THEN
            ASSIGN p-valor-desp-pis = decla-import-adic-itens.val-unit-pis * decla-import-ord.qtd-item.
                
        /*--- determina valor da COFINS ---*/
        IF  decla-import-adic.val-unit-cofins > 0 THEN
            ASSIGN p-valor-desp-cofins = decla-import-adic-itens.val-unit-cofins * decla-import-ord.qtd-item.
            
    
        /* atualizar o PIS e COFINS para a adi‡Æo. */ 
        /* guardar os valores calculados nas variaveis de acordo com a seu tipo de tributa‡Æo */
            
        /*---[ PIS ]------------------------------------------*/
        IF NOT l-valor-pis-manual THEN DO:

            &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN
                IF decla-import-adic.log-suspens-pis THEN
            &ELSE
                IF SUBSTRING(decla-import-adic.cod-livre-1,2,1) = '1':U THEN
            &ENDIF
                ASSIGN decla-import-adic-itens.val-pis-nao-tribut = ROUND(p-valor-desp-pis,8).
                
        
            CASE decla-import-adic-itens.idi-tributac-pis:
                WHEN 1 THEN
                    ASSIGN decla-import-adic-itens.val-pis-db-cr  = ROUND(p-valor-desp-pis,8).
                WHEN 2 THEN
                    ASSIGN decla-import-adic-itens.val-pis-db-cr  = 0.
                WHEN 3 THEN
                    ASSIGN decla-import-adic-itens.val-pis-outras = ROUND(p-valor-desp-pis,8).
                WHEN 4 THEN
                    ASSIGN decla-import-adic-itens.val-pis-db-cr  = ROUND(p-valor-desp-pis,8).
            END CASE.
        END.

        ASSIGN d-val-pis-sist = ROUND(p-valor-desp-pis,8).
        /*--------------------------------------------------*/

        /*---[ COFINS ]-------------------------------------*/
        IF NOT l-valor-cofins-manual THEN DO:

            &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN
                IF decla-import-adic.log-suspens-cofins THEN
            &ELSE
                IF SUBSTRING(decla-import-adic.cod-livre-1,3,1) = '1':U THEN
            &ENDIF
                ASSIGN decla-import-adic-itens.val-cofins-nao-tribut = ROUND(p-valor-desp-cofins,8).
                    
            
            CASE decla-import-adic-itens.idi-tributac-cofins:
                WHEN 1 THEN
                    ASSIGN decla-import-adic-itens.val-cofins-db-cr  = ROUND(p-valor-desp-cofins,8).
                WHEN 2 THEN
                    ASSIGN decla-import-adic-itens.val-cofins-db-cr  = 0.
                WHEN 3 THEN
                    ASSIGN decla-import-adic-itens.val-cofins-outras = ROUND(p-valor-desp-cofins,8).
                WHEN 4 THEN
                    ASSIGN decla-import-adic-itens.val-cofins-db-cr  = ROUND(p-valor-desp-cofins,8).
            END CASE.
        END.

        ASSIGN d-val-cofins-sist = ROUND(p-valor-desp-cofins,8).
        
        ASSIGN decla-import-adic-itens.log-pis-unid    = YES
               decla-import-adic-itens.log-cofins-unid = YES.
    END.
    ELSE DO:
        
        /*--- calcula o valor do PIS e COFINS utilizando a formula do param-imp ---*/

        /*--- encontra o valor da mercadoria ---*/
        ASSIGN de-val-merc        = decla-import-adic-itens.val-vmcv
               de-val-acum-desp   = 0
               d-val-desp-convert = 0.
        
        FOR EACH despes-adic-itens NO-LOCK
            WHERE despes-adic-itens.num-di-ems = decla-import-adic-itens.num-di-ems
            AND   despes-adic-itens.num-adic   = decla-import-adic-itens.num-adic
            AND   despes-adic-itens.num-seq    = decla-import-adic-itens.num-seq
            AND   despes-adic-itens.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts
            AND   despes-adic-itens.log-forma-preco-compra:

            /*--- converte para a moeda corrente ---*/
            IF  despes-adic-itens.cdn-moed <> 0 THEN
                RUN converteValorMoeda IN h-bocx383 (INPUT  decla-import-adic-itens.num-di-ems,
                                                     INPUT  decla-import-adic-itens.cdd-siscomex-dts,
                                                     INPUT  despes-adic-itens.cdn-moeda,   /* moeda de origem */
                                                     INPUT  0,                       /* moeda de destino */
                                                     INPUT  despes-adic-itens.val-despes,  /* valor da despesa */
                                                     INPUT  p-data-di,               /* data da di  */
                                                     OUTPUT d-val-desp-convert).
            ELSE
                ASSIGN d-val-desp-convert = despes-adic-itens.val-despes.

            ASSIGN de-val-merc = de-val-merc - d-val-desp-convert.
        END.

        /* pegar o valor do II (db-cr) se incide em pis / cofins aduaneiro e soma*/
        {cxbo/bocx250.i50} /* include tratamento atributo livre */
    
        {cdp/cd4300.i4 "yes" param-imp.char-1}
        {cxbo/bocx250.i51 "yes"}
    
        /* verifica se a despesa de II incide nos valores aduaneiros e/ou despesas de pis e cofins */
        ASSIGN i-cod-desp-ii     = i-desp-ii-i50
               i-cod-emitente-ii = i-emitente-ii-i50.

        FIND FIRST desp-imp NO-LOCK
             WHERE desp-imp.cod-desp = i-cod-desp-ii NO-ERROR.
        
        IF AVAIL desp-imp THEN DO:
            ASSIGN de-val-acum-desp-adu-cofins = de-val-acum-desp-adu-cofins + decla-import-adic-itens.val-ii-db-cr WHEN desp-imp.log-incid-base-cofins-val    
                   de-val-acum-desp-adu-pis    = de-val-acum-desp-adu-pis    + decla-import-adic-itens.val-ii-db-cr WHEN desp-imp.log-incid-base-pis-val       
                   de-val-acum-desp-cofins     = de-val-acum-desp-cofins     + decla-import-adic-itens.val-ii-db-cr WHEN desp-imp.log-incid-base-cofins-despes 
                   de-val-acum-desp-pis        = de-val-acum-desp-pis        + decla-import-adic-itens.val-ii-db-cr WHEN desp-imp.log-incid-base-pis-despes.   
        END.
            
        ASSIGN de-valor-aduaneiro-pis    = de-val-merc + de-val-acum-desp-adu-pis
               de-valor-aduaneiro-cofins = de-val-merc + de-val-acum-desp-adu-cofins
               i-trib-pis                = decla-import-adic-itens.idi-tributac-pis
               de-aliq-pis               = decla-import-adic-itens.val-aliq-pis
               de-valor-un-pis           = decla-import-adic-itens.val-unit-pis
               i-trib-cofins             = decla-import-adic-itens.idi-tributac-cofins
               de-aliq-cofins            = decla-import-adic-itens.val-aliq-cofins
               de-valor-un-cofins        = decla-import-adic-itens.val-unit-cofins
               de-qtd-do-forn            = 0
               de-qtd-do-forn            = decla-import-ord.qtd-item
               i-trib-ii                 = decla-import-adic-itens.idi-tributac-impto-import.

        /*--- busca aliquota do II ---*/
        IF  i-trib-ii = 2 /* isento */ THEN
            ASSIGN de-aliq-ii = 0.
        ELSE
            ASSIGN de-aliq-ii = decla-import-adic-itens.val-aliq-ii.
            
        /*--- Determina tributacao e aliquota do IPI carrega nas variaveis de-aliq-ipi e i-trib-ipi ---*/
        ASSIGN i-trib-ipi  = decla-import-adic-itens.idi-tributac-ipi
               de-aliq-ipi = decla-import-adic-itens.val-aliq-ipi.
            
        IF i-trib-ipi = 2 /* isento */ THEN
            ASSIGN de-aliq-ipi = 0.
        
        /*--- aplica reducao do IPI ---*/
        IF  i-trib-ipi = 4 /* reduzido */ THEN
            ASSIGN de-aliq-ipi = de-aliq-ipi - (de-aliq-ipi * decla-import-adic-itens.val-perc-reduc-ipi / 100). 
        
        /*--- Calcula a tributacao do ICMS ---*/
        ASSIGN c-trib-icm = decla-import-adic-itens.idi-tributac-icms.
     
        /*--- Calcula a aliquota do ICMS ---*/
        IF  c-trib-icm <> 2 THEN DO:
            ASSIGN de-aliq-icm = decla-import-adic-itens.val-aliq-icms.
        
            /*--- aplica reducao do ICMS ---*/
            IF  c-trib-icm = 4 /* reduzido */ THEN
                ASSIGN de-aliq-icm = de-aliq-icm - (de-aliq-icm * decla-import-adic-itens.val-perc-reduc-icms / 100). /*buscar redu‡ao da adi‡Æo*/
        END.
        ELSE
            ASSIGN de-aliq-icm = 0. /* item isento */
            
        
        /*--- acumula o valor das despesas que incidem no valor aduaneiro ---*/
        FOR EACH despes-adic-itens NO-LOCK
           WHERE despes-adic-itens.num-di-ems = decla-import-adic-itens.num-di-ems
             AND despes-adic-itens.num-adic   = decla-import-adic-itens.num-adic
             AND despes-adic-itens.num-seq    = decla-import-adic-itens.num-seq
             AND despes-adic-itens.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts:
            
            FOR FIRST b-desp-imp 
                WHERE b-desp-imp.cod-desp = despes-adic-itens.cdn-despes NO-LOCK: END.
    
            /*--- se a despesa incide na base do PIS ou COFINS e compoe os calculos da nota fiscal, entao acumula o valor da despesa ---*/
            /* separar para pis e cofins */

            IF  AVAIL b-desp-imp
            AND (   b-desp-imp.log-incid-base-pis-val
                 OR b-desp-imp.log-incid-base-cofins-val)
            AND (   b-desp-imp.inc-val-embal       <> NO
                 OR b-desp-imp.inc-val-frete       <> NO 
                 OR b-desp-imp.inc-val-outras-desp <> NO 
                 OR b-desp-imp.inc-val-seguro  <> NO) THEN DO:
    
                /*--- converte para a moeda corrente ---*/
                IF  despes-adic-itens.cdn-moed <> 0 THEN
                    RUN converteValorMoeda IN h-bocx383 (INPUT  decla-import-adic-itens.num-di-ems, 
                                                         INPUT  decla-import-adic-itens.cdd-siscomex-dts,
                                                         INPUT  despes-adic-itens.cdn-moeda,   /* moeda de origem */
                                                         INPUT  0,                       /* moeda de destino */
                                                         INPUT  despes-adic-itens.val-despes,  /* valor da despesa */
                                                         INPUT  p-data-di,               /* data da di  */
                                                         OUTPUT de-valor-desp-adu).
                ELSE
                    ASSIGN de-valor-desp-adu = despes-adic-itens.val-despes.
    
                IF b-desp-imp.tipo = 1 THEN
                    ASSIGN de-valor-desp-adu = de-valor-desp-adu / de-qtd-do-forn.
    

                IF b-desp-imp.log-incid-base-pis-val THEN
                    ASSIGN de-valor-aduaneiro-pis = de-valor-aduaneiro-pis + de-valor-desp-adu.

                IF b-desp-imp.log-incid-base-cofins-val THEN
                    ASSIGN de-valor-aduaneiro-cofins = de-valor-aduaneiro-cofins + de-valor-desp-adu.
    
            END. /* if avail b-desp-imp */            
        END. /* FOR EACH despes-adic */

            
        /*--- se a despesa incide na base do PIS ou COFINS e compoe os calculos da nota fiscal, entao acumula o valor da despesa ---*/
        FOR EACH despes-adic-itens NO-LOCK
           WHERE despes-adic-itens.num-di-ems = decla-import-adic-itens.num-di-ems
             AND despes-adic-itens.num-adic   = decla-import-adic-itens.num-adic
             AND despes-adic-itens.num-seq    = decla-import-adic-itens.num-seq
             AND despes-adic-itens.cdd-siscomex-dts = decla-import-adic-itens.cdd-siscomex-dts:
            
            /* separar para pis e cofins */
            FOR FIRST b-desp-imp 
                WHERE b-desp-imp.cod-desp = despes-adic-itens.cdn-despes NO-LOCK: END.

            IF  AVAIL b-desp-imp
            AND (   b-desp-imp.log-incid-base-pis-despes
                 OR b-desp-imp.log-incid-base-cofins-despes)
            AND (   b-desp-imp.inc-val-embal       <> NO
                 OR b-desp-imp.inc-val-frete       <> NO 
                 OR b-desp-imp.inc-val-outras-desp <> NO 
                 OR b-desp-imp.inc-val-seguro  <> NO) THEN DO:
    
                /*--- converte para a moeda corrente ---*/
                IF  despes-adic-itens.cdn-moed <> 0 THEN DO:
                    RUN converteValorMoeda IN h-bocx383 (INPUT decla-import-adic-itens.num-di-ems, 
                                                         INPUT decla-import-adic-itens.cdd-siscomex-dts,
                                                         INPUT despes-adic-itens.cdn-moeda,   /* moeda de origem */
                                                         INPUT 0,                       /* moeda de destino */
                                                         INPUT despes-adic-itens.val-despes,  /* valor da despesa */
                                                         INPUT p-data-di,               /* data da di  */
                                                         OUTPUT de-valor-desp).
                END.
                ELSE
                    ASSIGN de-valor-desp = despes-adic-itens.val-despes.
    
                IF b-desp-imp.tipo = 1 THEN
                     ASSIGN de-valor-desp = de-valor-desp / de-qtd-do-forn.
               
                IF b-desp-imp.log-incid-base-pis-despes THEN
                     ASSIGN de-val-acum-desp-pis = de-val-acum-desp-pis + de-valor-desp.
               
                IF b-desp-imp.log-incid-base-cofins-despes THEN
                     ASSIGN de-val-acum-desp-cofins = de-val-acum-desp-cofins + de-valor-desp.
    
            END. /* if avail b-desp-imp */
        END. /* for each despes-adic */

        /*--- Calcula o valor do PIS/COFINS ---*/
        EMPTY TEMP-TABLE tt-formula.
        EMPTY TEMP-TABLE tt-var.

        /* As aliquotas dos impostos II, IPI e ICMS dever’o ser zeradas quando a natureza de opera»’o esteja marcada p/ suspens’o */
        /*buscar a suspensao dos impostos da adic */

        IF decla-import-adic-itens.val-unit-ipi > 0 THEN
            ASSIGN de-aliq-ipi = ((decla-import-adic-itens.val-ipi-db-cr         +
                                   decla-import-adic-itens.val-ipi-nao-tributad  +
                                   decla-import-adic-itens.val-ipi-outras        ) / decla-import-adic-itens.val-base-ipi) * 100.

        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-operacao = decla-import-adic-itens.cod-natur-oper NO-ERROR.

        IF decla-import-adic-itens.log-suspens-impto-import AND SUBSTR(natur-oper.char-1,154,1) = "1":U THEN ASSIGN de-aliq-ii  = 0.00000.    
        IF decla-import-adic-itens.log-suspens-ipi-import   AND SUBSTR(natur-oper.char-1,155,1) = "1":U THEN ASSIGN de-aliq-ipi = 0.00000.

        &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN
          IF decla-import-adic-itens.log-suspens-icms AND SUBSTR(natur-oper.char-1,156,1) = "1":U THEN ASSIGN de-aliq-icm = 0.00000. 
        &ELSE
          IF SUBSTR(decla-import-adic-itens.cod-livre-1,1,1) = "1" AND SUBSTR(natur-oper.char-1,156,1) = "1":U THEN ASSIGN de-aliq-icm = 0.00000.
        &ENDIF
        
        IF l-base-pis-manual THEN
            ASSIGN de-valor-aduaneiro-pis = (decla-import-adic.val-base-pis * decla-import-adic-itens.val-vmcv) / decla-import-adic.val-vmcv.

        ASSIGN de-VA = de-valor-aduaneiro-pis
               de-DA = de-val-acum-desp-pis
               de-a  = de-aliq-ii
               de-b  = de-aliq-ipi
               de-c  = de-aliq-pis
               de-d  = de-aliq-cofins
               de-e  = de-aliq-icm.
      
        /* busca a formula do param-imp */
        {cxbo/bocx250.i3 param-imp}

        CREATE tt-formula.
        ASSIGN tt-formula.formula = c-formula-pis-param-imp
               tt-formula.cod-versao-integracao = 001.

        CREATE tt-var.
        ASSIGN tt-var.nome      = "VA":U
               tt-var.valor     = de-VA
               tt-var.tipo-res  = 1.

        CREATE tt-var.
        ASSIGN tt-var.nome      = "DA":U
               tt-var.valor     = de-DA
               tt-var.tipo-res  = 1.

        CREATE tt-var.
        ASSIGN tt-var.nome      = "a":U
               tt-var.valor     = de-a / 100
               tt-var.tipo-res  = 1.

        CREATE tt-var.
        ASSIGN tt-var.nome      = "b":U
               tt-var.valor     = de-b / 100
               tt-var.tipo-res  = 1.

        CREATE tt-var.
        ASSIGN tt-var.nome      = "c":U
               tt-var.valor     = de-c / 100
               tt-var.tipo-res  = 1.  

        CREATE tt-var.
        ASSIGN tt-var.nome      = "d":U
               tt-var.valor     = de-d / 100
               tt-var.tipo-res  = 1.

        CREATE tt-var.
        ASSIGN tt-var.nome      = "e":U
               tt-var.valor     = de-e / 100
               tt-var.tipo-res  = 1.               

        RUN cdp/cdapi020.p (INPUT-OUTPUT TABLE tt-formula,
                            INPUT TABLE tt-var,
                            INPUT-OUTPUT TABLE tt-erro,
                            INPUT l-deleta-erros).

        IF  NOT CAN-FIND(FIRST tt-erro) THEN DO:
            FIND FIRST tt-formula NO-LOCK NO-ERROR.        
            IF AVAIL tt-formula THEN
                ASSIGN p-valor-desp-pis = tt-formula.RESULT.
        END. 

        /*--- Calcula o valor do COFINS ---*/
        EMPTY TEMP-TABLE tt-formula.
        EMPTY TEMP-TABLE tt-var.

        IF decla-import-adic-itens.val-unit-ipi > 0 THEN
            ASSIGN de-aliq-ipi = ((decla-import-adic-itens.val-ipi-db-cr         +
                                   decla-import-adic-itens.val-ipi-nao-tributad  +
                                   decla-import-adic-itens.val-ipi-outras        ) / decla-import-adic-itens.val-base-ipi) * 100.

        /* As aliquotas dos impostos II, IPI e ICMS dever’o ser zeradas quando a natureza de opera»’o esteja marcada p/ suspens’o */
        /*buscar a suspensao dos impostos da adic */

        IF decla-import-adic-itens.log-suspens-impto-import THEN ASSIGN de-aliq-ii  = 0.00000.     
        IF decla-import-adic-itens.log-suspens-ipi-import   THEN ASSIGN de-aliq-ipi = 0.00000.     
        
        IF l-base-cofins-manual THEN
            ASSIGN de-valor-aduaneiro-cofins = (decla-import-adic.val-base-cofins * decla-import-adic-itens.val-vmcv) / decla-import-adic.val-vmcv.

        ASSIGN de-VA = de-valor-aduaneiro-cofins 
               de-DA = de-val-acum-desp-cofins
               de-a  = de-aliq-ii
               de-b  = de-aliq-ipi
               de-c  = de-aliq-pis
               de-d  = de-aliq-cofins
               de-e  = de-aliq-icm.

        /* busca a formula do param-imp */
        {cxbo/bocx250.i3 param-imp}

        CREATE tt-formula.
        ASSIGN tt-formula.formula = c-formula-cofins-param-imp
               tt-formula.cod-versao-integracao = 001.

        CREATE tt-var.
        ASSIGN tt-var.nome      = "VA":U
               tt-var.valor     = de-VA
               tt-var.tipo-res  = 1.

        CREATE tt-var.
        ASSIGN tt-var.nome      = "DA":U
               tt-var.valor     = de-DA
               tt-var.tipo-res  = 1.

        CREATE tt-var.
        ASSIGN tt-var.nome      = "a":U
               tt-var.valor     = de-a / 100
               tt-var.tipo-res  = 1.

        CREATE tt-var.
        ASSIGN tt-var.nome      = "b":U
               tt-var.valor     = de-b / 100
               tt-var.tipo-res  = 1.

        CREATE tt-var.
        ASSIGN tt-var.nome      = "c":U
               tt-var.valor     = de-c / 100
               tt-var.tipo-res  = 1.  

        CREATE tt-var.
        ASSIGN tt-var.nome      = "d":U
               tt-var.valor     = de-d / 100
               tt-var.tipo-res  = 1.

        CREATE tt-var.
        ASSIGN tt-var.nome      = "e":U
               tt-var.valor     = de-e / 100
               tt-var.tipo-res  = 1.               

        RUN cdp/cdapi020.p (INPUT-OUTPUT TABLE tt-formula,
                            INPUT TABLE tt-var,
                            INPUT-OUTPUT TABLE tt-erro,
                            INPUT l-deleta-erros).

        IF  NOT CAN-FIND(FIRST tt-erro) THEN DO:
            FIND FIRST tt-formula NO-LOCK NO-ERROR.        
            IF AVAIL tt-formula THEN
                ASSIGN p-valor-desp-cofins = tt-formula.RESULT.
        END.
        
        /* Atualizar o PIS e COFINS para a adi‡Æo. */ 
        /* Guardar os valores calculados nas variaveis de acordo com a seu tipo de tributa‡Æo */
        
        /*---[ PIS ]------------------------------------------*/
        IF NOT l-valor-pis-manual THEN DO:

            &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN
                IF decla-import-adic-itens.log-suspens-pis THEN
            &ELSE
                IF SUBSTRING(decla-import-adic-itens.cod-livre-1,2,1) = '1':U THEN
            &ENDIF
                ASSIGN decla-import-adic-itens.val-pis-nao-tribut = ROUND(p-valor-desp-pis,8).
                    
                ELSE DO:
                    CASE decla-import-adic-itens.idi-tributac-pis:
                        WHEN 1 THEN
                            ASSIGN decla-import-adic-itens.val-pis-db-cr      = ROUND(p-valor-desp-pis,8).
                        WHEN 2 THEN
                            ASSIGN decla-import-adic-itens.val-pis-nao-tribut = ROUND(p-valor-desp-pis,8).
                        WHEN 3 THEN
                            ASSIGN decla-import-adic-itens.val-pis-outras     = ROUND(p-valor-desp-pis,8).
                        WHEN 4 THEN
                            ASSIGN decla-import-adic-itens.val-pis-db-cr      = ROUND(p-valor-desp-pis,8).
                    END CASE.
                END.
        END.

        ASSIGN d-val-pis-sist = ROUND(p-valor-desp-pis,8).

        /*---[ COFINS ]-------------------------------------*/
        IF NOT l-valor-cofins-manual THEN DO:
            
            &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN
                IF decla-import-adic-itens.log-suspens-cofins THEN
            &ELSE
                IF SUBSTRING(decla-import-adic-itens.cod-livre-1,3,1) = '1':U THEN
            &ENDIF
                ASSIGN decla-import-adic-itens.val-cofins-nao-tribut = ROUND(p-valor-desp-cofins,8).
                    
                ELSE DO:
                    CASE decla-import-adic-itens.idi-tributac-cofins:
                        WHEN 1 THEN
                            ASSIGN decla-import-adic-itens.val-cofins-db-cr      = ROUND(p-valor-desp-cofins,8).
                        WHEN 2 THEN
                            ASSIGN decla-import-adic-itens.val-cofins-nao-tribut = ROUND(p-valor-desp-cofins,8).
                        WHEN 3 THEN
                            ASSIGN decla-import-adic-itens.val-cofins-outras     = ROUND(p-valor-desp-cofins,8).
                        WHEN 4 THEN
                            ASSIGN decla-import-adic-itens.val-cofins-db-cr      = ROUND(p-valor-desp-cofins,8).
                    END CASE.
                END.
        END.

        ASSIGN OVERLAY(decla-import-adic-itens.cod-livre-2,1,22)  = IF de-valor-aduaneiro-cofins > 0 THEN TRIM(STRING(de-valor-aduaneiro-cofins * 100000)) 
                                                                    ELSE STRING(0,"9999999999999999999999":U)
               OVERLAY(decla-import-adic-itens.cod-livre-2,23,22) = IF de-val-acum-desp-cofins   > 0 THEN TRIM(STRING(de-val-acum-desp-cofins   * 100000)) 
                                                                    ELSE STRING(0,"9999999999999999999999":U)
               OVERLAY(decla-import-adic-itens.cod-livre-2,45,22) = IF de-valor-aduaneiro-pis    > 0 THEN TRIM(STRING(de-valor-aduaneiro-pis    * 100000)) 
                                                                    ELSE STRING(0,"9999999999999999999999":U) 
               OVERLAY(decla-import-adic-itens.cod-livre-2,67,22) = IF de-val-acum-desp-pis      > 0 THEN TRIM(STRING(de-val-acum-desp-pis      * 100000)) 
                                                                    ELSE STRING(0,"9999999999999999999999":U).

        ASSIGN d-val-cofins-sist = ROUND(p-valor-desp-cofins,8).

    END. /* else do */
END. /* for first decla-import-adic */


IF VALID-HANDLE(h-im9048) THEN DO:
    DELETE PROCEDURE h-im9048.
    ASSIGN h-im9048 = ?.
END.

IF VALID-HANDLE(h-bocx383) THEN DO:
    DELETE PROCEDURE h-bocx383.
    ASSIGN h-bocx383 = ?.
END.
