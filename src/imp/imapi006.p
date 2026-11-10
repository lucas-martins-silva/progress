/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IMAPI006 2.00.00.009} /*** "010009" 19/08/2026 16:23:25 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i imapi006 MIM}
&ENDIF

/********************************************************************************
**
**  IMAPI006.P - Objetivo: para cada despesa ja cotada e nas despesas influenciadas 
**               por esta, recalcula o valor da despesa caso o mapa e a cotacao 
**               estiverem aprovados, ou marca para ser recalculada, caso nao 
**               estejam aprovados.               
**
********************************************************************************/
{cdp/cd4300.i3}  /* include tratamento atributo livre */
{cxbo/bocx250.i50} /* include tratamento atributo livre */
{cdp/cdapi020.i}
{imp/imapi006.i} /* def temp-table tt-desp-ja-recalc */
{cxbo/bocx085.i tt-cotacao-item-cex}

DEF INPUT PARAM p-table-name        AS CHAR                     NO-UNDO.
DEF INPUT PARAM p-rowid-table       AS ROWID                    NO-UNDO.
DEF INPUT PARAM p-cod-desp-alterada LIKE desp-imp.cod-desp      NO-UNDO.
DEF INPUT PARAM p-cod-desp-original LIKE desp-imp.cod-desp      NO-UNDO.
DEF INPUT PARAM TABLE FOR tt-cotacao-item-cex.

DEF INPUT-OUTPUT PARAM TABLE FOR tt-desp-ja-recalc.

DEF VAR i-cont           AS INT                 NO-UNDO.
DEF VAR l-aprovado       AS LOG                 NO-UNDO.
DEF VAR h-bocx085        AS HANDLE              NO-UNDO.
DEF VAR de-valor-despesa LIKE desp-imp.val-desp NO-UNDO.
DEF VAR l-desp-vinculada AS LOGICAL             NO-UNDO.

DEF VAR l-nt2024002      AS LOGICAL             NO-UNDO.
ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002" AND funcao.ativo).

DEF BUFFER b-cotacao-item-cex FOR cotacao-item-cex.

/*--- armazena a despesa que estah sendo
      alterada quando esta api for executada
      pela primeira vez ---*/
IF  p-cod-desp-original = 0 THEN
    ASSIGN p-cod-desp-original = p-cod-desp-alterada.

/*--- verifica se o programa que executou esta api tomou como base 
      a tabela desp-cot-ordem ou a cotacao-item-cex, no caso de 
      eliminacao da cotacao-item-cex, sera passado um registro na 
      temp-table tt-cotacao-item-cex com a despesa eliminada ---*/
IF  p-table-name = "desp-cot-ordem":U THEN DO:

    FOR FIRST desp-cot-ordem FIELDS(cod-agrup mapa-ordem cod-emitente-desp) 
        WHERE ROWID(desp-cot-ordem) = p-rowid-table NO-LOCK: END.
    
    IF  NOT AVAIL desp-cot-ordem THEN
        RETURN "NOK":U.
    
    FOR FIRST cot-ordem FIELDS(numero-ordem cod-agrup mapa-ordem cod-emitente cod-itiner cod-incoterm)
        WHERE cot-ordem.cod-agrup    = desp-cot-ordem.cod-agrup 
          AND cot-ordem.mapa-ordem   = desp-cot-ordem.mapa-ordem 
          AND cot-ordem.cod-emitente = desp-cot-ordem.cod-emitente-desp NO-LOCK: END.
    
    IF  NOT AVAIL cot-ordem then    
         FOR FIRST cot-ordem FIELDS(numero-ordem cod-agrup mapa-ordem cod-emitente cod-itiner cod-incoterm)
             WHERE cot-ordem.cod-agrup    = desp-cot-ordem.cod-agrup
               AND cot-ordem.mapa-ordem   = desp-cot-ordem.mapa-ordem NO-LOCK: END.    
    
    IF  NOT AVAIL cot-ordem THEN
        RETURN "NOK":U.
    
    FOR FIRST ordem-compra FIELDS(cod-estabel it-codigo)
        WHERE ordem-compra.numero-ordem = cot-ordem.numero-ordem NO-LOCK: END.
    
    IF  NOT AVAIL ordem-compra THEN
        RETURN "NOK":U.
    
    FOR FIRST param-imp FIELDS(char-1 cdn-despes-impto-ipi    cdn-despes-impto-pis   
                                      cdn-despes-impto-cofins cdn-despes-impto-icms)
        WHERE param-imp.cod-estabel = ordem-compra.cod-estabel NO-LOCK: END.
    
    IF  NOT AVAIL param-imp THEN
        RETURN "NOK":U.
    
    IF l-nt2024002 THEN
        FIND FIRST param-imp-trib
             WHERE param-imp-trib.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
             
    /*--- busca despesa de importacao ---*/
    {cdp/cd4300.i4 "yes" param-imp.char-1}
    {cxbo/bocx250.i51 "yes"}

    /*--- busca despesas jah cotadas no im0015 ---*/
    FOR EACH  desp-cot-ordem
        WHERE desp-cot-ordem.cod-agrup  = cot-ordem.cod-agrup
          AND desp-cot-ordem.mapa-ordem = cot-ordem.mapa-ordem EXCLUSIVE-LOCK:

        RUN pi-calcula-marca-despesas(INPUT  desp-cot-ordem.cod-desp,
                                      INPUT  desp-cot-ordem.nr-tab,
                                      INPUT  desp-cot-ordem.cod-cond-pag,
                                      INPUT  desp-cot-ordem.cod-emitente-desp,
                                      INPUT  cot-ordem.cod-itiner,
                                      INPUT  cot-ordem.cod-incoterm).

    END.

    /*--- verifica se afeta os impostos ---*/
    RUN pi-verifica-impostos(p-cod-desp-alterada).
END.
ELSE IF  p-table-name = "cotacao-item-cex":U THEN DO:

    FOR FIRST b-cotacao-item-cex FIELDS(numero-ordem seq-cotac mapa-cotacao data-cotacao)
        WHERE ROWID(b-cotacao-item-cex) = p-rowid-table NO-LOCK: END.
    IF  NOT AVAIL b-cotacao-item-cex THEN
        RETURN "NOK":U.
    
    FOR FIRST ordem-compra FIELDS(cod-estabel it-codigo cod-emitente)
        WHERE ordem-compra.numero-ordem = b-cotacao-item-cex.numero-ordem NO-LOCK: END.
    IF  NOT AVAIL ordem-compra THEN
        RETURN "NOK":U.
    
    FOR FIRST param-imp FIELDS(char-1 cdn-despes-impto-ipi    cdn-despes-impto-pis   
                                      cdn-despes-impto-cofins cdn-despes-impto-icms)
         WHERE param-imp.cod-estabel = ordem-compra.cod-estabel NO-LOCK: END.
    IF  NOT AVAIL param-imp THEN
        RETURN "NOK":U.

    IF l-nt2024002 THEN
        FIND FIRST param-imp-trib
             WHERE param-imp-trib.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
    
    /*--- verifica se o mapa e a cotacao
          estao aprovados ---*/
    FOR FIRST cotacao-item
        WHERE cotacao-item.numero-ordem = b-cotacao-item-cex.numero-ordem
          AND cotacao-item.cod-emitente = b-cotacao-item-cex.cod-emitente 
          AND cotacao-item.it-codigo    = ordem-compra.it-codigo
          AND cotacao-item.seq-cotac    = b-cotacao-item-cex.seq-cotac     NO-LOCK: END.
    IF  NOT AVAIL cotacao-item THEN
        RETURN "NOK":U.


    IF  b-cotacao-item-cex.mapa-cotacao = INT(SUBSTRING(cotacao-item.char-1,1,20))
    AND cotacao-item.cot-aprovada THEN
        ASSIGN l-aprovado = YES.

    {cdp/cd4300.i4 "yes" param-imp.char-1}

    /*--- busca despesa de importacao ---*/
    {cxbo/bocx250.i51 "yes"}

    RUN cxbo/bocx085.p PERSISTENT SET h-bocx085.

    /*--- le as despesas da cotacao ---*/
    FOR EACH cotacao-item-cex
        WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
          AND cotacao-item-cex.cod-emitente  = b-cotacao-item-cex.cod-emitente
          AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
          AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
          AND cotacao-item-cex.data-cotacao  = b-cotacao-item-cex.data-cotacao
          AND cotacao-item-cex.mapa-cotacao  = b-cotacao-item-cex.mapa-cotacao EXCLUSIVE-LOCK:

        RUN pi-calcula-marca-despesas(INPUT cotacao-item-cex.cod-desp,
                                      INPUT cotacao-item-cex.nr-tab,
                                      INPUT cotacao-item-cex.cod-cond-pag,
                                      INPUT cotacao-item-cex.cod-emitente-desp,
                                      INPUT cotacao-item-cex.cod-itiner,
                                      INPUT cotacao-item-cex.cod-incoterm).
    END.

    /*--- verifica se afeta os impostos ---*/
    RUN pi-verifica-impostos(p-cod-desp-alterada).

    DELETE PROCEDURE h-bocx085 NO-ERROR.
END.
ELSE IF  p-table-name = "tt-cotacao-item-cex":U THEN DO:

    FIND FIRST tt-cotacao-item-cex NO-ERROR.
    
    IF  NOT AVAIL tt-cotacao-item-cex THEN
        RETURN "NOK":U.
    
    FOR FIRST ordem-compra FIELDS(cod-estabel it-codigo cod-emitente)
        WHERE ordem-compra.numero-ordem = tt-cotacao-item-cex.numero-ordem NO-LOCK: END.
    
    IF  NOT AVAIL ordem-compra THEN
        RETURN "NOK":U.
    
    FOR FIRST param-imp FIELDS(char-1 cdn-despes-impto-ipi    cdn-despes-impto-pis   
                                      cdn-despes-impto-cofins cdn-despes-impto-icms)
         WHERE param-imp.cod-estabel = ordem-compra.cod-estabel NO-LOCK: END.
    
    IF  NOT AVAIL param-imp THEN
        RETURN "NOK":U.

    IF l-nt2024002 THEN
        FIND FIRST param-imp-trib
             WHERE param-imp-trib.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
             
    /*--- verifica se o mapa e a cotacao
          estao aprovados ---*/
    FOR FIRST cotacao-item
        WHERE cotacao-item.numero-ordem = tt-cotacao-item-cex.numero-ordem
          AND cotacao-item.cod-emitente = tt-cotacao-item-cex.cod-emitente 
          AND cotacao-item.it-codigo    = ordem-compra.it-codigo
          AND cotacao-item.seq-cotac    = tt-cotacao-item-cex.seq-cotac     NO-LOCK: END.
    IF  NOT AVAIL cotacao-item THEN
        RETURN "NOK":U.

    IF  tt-cotacao-item-cex.mapa-cotacao = INT(SUBSTRING(cotacao-item.char-1,1,20))
    AND cotacao-item.cot-aprovada THEN
        ASSIGN l-aprovado = YES.

    {cdp/cd4300.i4 "yes" param-imp.char-1}

    /*--- busca despesa de importacao ---*/
    {cxbo/bocx250.i51 "yes"}

    RUN cxbo/bocx085.p PERSISTENT SET h-bocx085.

    /*--- le as despesas da cotacao ---*/
    FOR EACH cotacao-item-cex
        WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
          AND cotacao-item-cex.cod-emitente  = tt-cotacao-item-cex.cod-emitente
          AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
          AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
          AND cotacao-item-cex.data-cotacao  = tt-cotacao-item-cex.data-cotacao
          AND cotacao-item-cex.mapa-cotacao  = tt-cotacao-item-cex.mapa-cotacao EXCLUSIVE-LOCK:

        RUN pi-calcula-marca-despesas(INPUT cotacao-item-cex.cod-desp,
                                      INPUT  cotacao-item-cex.nr-tab,
                                      INPUT  cotacao-item-cex.cod-cond-pag,
                                      INPUT  cotacao-item-cex.cod-emitente-desp,
                                      INPUT  cotacao-item-cex.cod-itiner,
                                      INPUT  cotacao-item-cex.cod-incoterm).
    END.

    /*--- verifica se afeta os impostos ---*/
    RUN pi-verifica-impostos(p-cod-desp-alterada).
    
    DELETE PROCEDURE h-bocx085 NO-ERROR.
END.
ELSE IF  p-table-name = "cotacao-item-cex-boin082i":U THEN DO:
    
    FOR FIRST b-cotacao-item-cex FIELDS(numero-ordem seq-cotac mapa-cotacao data-cotacao)
        WHERE ROWID(b-cotacao-item-cex) = p-rowid-table NO-LOCK: END.
    
    IF  NOT AVAIL b-cotacao-item-cex THEN
        RETURN "NOK":U.
    
    FOR FIRST ordem-compra FIELDS(cod-estabel it-codigo cod-emitente)
        WHERE ordem-compra.numero-ordem = b-cotacao-item-cex.numero-ordem NO-LOCK: END.
    
    IF  NOT AVAIL ordem-compra THEN
        RETURN "NOK":U.
    
    FOR FIRST param-imp FIELDS(char-1 cdn-despes-impto-ipi    cdn-despes-impto-pis   
                                      cdn-despes-impto-cofins cdn-despes-impto-icms)
         WHERE param-imp.cod-estabel = ordem-compra.cod-estabel NO-LOCK: END.
    
    IF  NOT AVAIL param-imp THEN
        RETURN "NOK":U.
    
    IF l-nt2024002 THEN
        FIND FIRST param-imp-trib
             WHERE param-imp-trib.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
             
    /*--- verifica se o mapa e a cotacao
          estao aprovados ---*/
    FOR FIRST cotacao-item
        WHERE cotacao-item.numero-ordem = b-cotacao-item-cex.numero-ordem
          AND cotacao-item.cod-emitente = b-cotacao-item-cex.cod-emitente 
          AND cotacao-item.it-codigo    = ordem-compra.it-codigo
          AND cotacao-item.seq-cotac    = b-cotacao-item-cex.seq-cotac     NO-LOCK: END.
    IF  NOT AVAIL cotacao-item THEN
        RETURN "NOK":U.

    IF  b-cotacao-item-cex.mapa-cotacao = INT(SUBSTRING(cotacao-item.char-1,1,20))
    AND cotacao-item.cot-aprovada THEN
        ASSIGN l-aprovado = YES.

    {cdp/cd4300.i4 "yes" param-imp.char-1}

    /*--- busca despesa de importacao ---*/
    {cxbo/bocx250.i51 "yes"}

    RUN cxbo/bocx085.p PERSISTENT SET h-bocx085.

    /*--- le as despesas da cotacao ---*/
    FOR EACH cotacao-item-cex
        WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
          AND cotacao-item-cex.cod-emitente  = b-cotacao-item-cex.cod-emitente
          AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
          AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
          AND cotacao-item-cex.data-cotacao  = b-cotacao-item-cex.data-cotacao
          AND cotacao-item-cex.mapa-cotacao  = b-cotacao-item-cex.mapa-cotacao EXCLUSIVE-LOCK:

        RUN pi-calcula-marca-despesas(INPUT cotacao-item-cex.cod-desp,
                                      INPUT  cotacao-item-cex.nr-tab,
                                      INPUT  cotacao-item-cex.cod-cond-pag,
                                      INPUT  cotacao-item-cex.cod-emitente-desp,
                                      INPUT  cotacao-item-cex.cod-itiner,
                                      INPUT  cotacao-item-cex.cod-incoterm).
    END.

    /*--- verifica se afeta os impostos ---*/
    RUN pi-verifica-impostos(p-cod-desp-alterada).
    
    DELETE PROCEDURE h-bocx085 NO-ERROR.
END.


RETURN "OK":U.

PROCEDURE pi-calcula-marca-despesas:

    DEF INPUT PARAM p-cod-desp          LIKE desp-imp.cod-desp                  NO-UNDO.
    DEF INPUT PARAM p-nr-tab            LIKE cotacao-item-cex.nr-tab            NO-UNDO.          
    DEF INPUT PARAM p-cod-cond-pag      LIKE cotacao-item-cex.cod-cond-pag      NO-UNDO.    
    DEF INPUT PARAM p-cod-emitente      LIKE cotacao-item-cex.cod-emitente-desp NO-UNDO.
    DEF INPUT PARAM p-cod-itiner        LIKE cotacao-item-cex.cod-itiner        NO-UNDO.
    DEF INPUT PARAM p-cod-incoterm      LIKE cotacao-item-cex.cod-incoterm      NO-UNDO.   

    FOR EACH tt-desp-vinc:
        DELETE tt-desp-vinc.
    END.
    
    FOR FIRST desp-imp FIELDS( tipo log-2 inc-base-ipi log-incid-base-pis-val log-incid-base-pis-despes
                               log-incid-base-cofins-val log-incid-base-cofins-despes inc-base-icms cod-desp )
        WHERE desp-imp.cod-desp = p-cod-desp NO-LOCK: END.

    IF  NOT AVAIL desp-imp THEN
        NEXT.

    /* verificar as despesas que dever∆o ser marcadas 
       para serem recalculadas */
    run getFormulaDesp (input  p-cod-desp,
                        input  p-nr-tab,
                        input  p-cod-cond-pag,
                        input  p-cod-emitente,
                        input  p-cod-itiner,
                        input  p-cod-incoterm,
                        OUTPUT l-desp-vinculada,
                        output table tt-desp-vinc).

    /*--- verifica se eh despesa Ç despesa vinculada ---*/
    /*IF l-desp-vinculada THEN DO:*/

        /*--- verifica se a despesa que estah sendo inclusa/alterada, faz parte da formula
              de alguma despesa ja cotada para este grupo/mapa ---*/
        IF CAN-FIND(FIRST tt-desp-vinc WHERE
                        tt-desp-vinc.cod-desp      = desp-imp.cod-desp AND
                        tt-desp-vinc.cod-desp-form = p-cod-desp-alterada)

            /*--- verifica se a despesa jah nao havia sido marcada antes ---*/
        AND NOT CAN-FIND(FIRST tt-desp-ja-recalc
                        WHERE tt-desp-ja-recalc.cod-desp = desp-imp.cod-desp) 
        /*--- verifica se eh diferente da despesa que estah sendo inclusa/alterada ---*/
        AND desp-imp.cod-desp <> p-cod-desp-original THEN DO:

            /*--- se o mapa e a cotacao estiverem aprovados chama o calculo da despesa,
                  senao apenas marca para serem recalculadas ---*/
            IF  l-aprovado THEN DO:

                IF  p-table-name = "cotacao-item-cex":U 
                OR  p-table-name = "tt-cotacao-item-cex":U 
                OR  p-table-name = "cotacao-item-cex-boin082i":U THEN DO:
                    IF  VALID-HANDLE(h-bocx085) THEN
                        RUN pi-calcula-despesa IN h-bocx085 (INPUT  ROWID(cotacao-item-cex),
                                                             OUTPUT de-valor-despesa).

                    ASSIGN cotacao-item-cex.val-desp = de-valor-despesa.
                END.
            END.
            ELSE DO:
                IF  p-table-name = "desp-cot-ordem":U THEN
                    ASSIGN desp-cot-ordem.log-recalc-val = YES.
                ELSE
                    ASSIGN cotacao-item-cex.log-recalc-val = YES.
            END.
            
            /*--- cria temp-table armazenando historico
                  das despesas que jah foram marcadas, 
                  evita que o programa entre em looping ---*/
            CREATE tt-desp-ja-recalc.
            ASSIGN tt-desp-ja-recalc.cod-desp = desp-imp.cod-desp.

            /*--- chama esta api novamente para buscar 
                  nas despesas cotadas, se alguma tem a 
                  despesa alterada como parte da formula ---*/
            IF  p-table-name = "desp-cot-ordem":U THEN
                RUN imp/imapi006.p(INPUT "desp-cot-ordem":U,  
                                   INPUT rowid(desp-cot-ordem),
                                   INPUT desp-imp.cod-desp,
                                   INPUT p-cod-desp-original,
                                   INPUT TABLE tt-cotacao-item-cex,
                                   INPUT-OUTPUT TABLE tt-desp-ja-recalc).
            ELSE
                RUN imp/imapi006.p(INPUT "cotacao-item-cex":U,  
                                   INPUT rowid(cotacao-item-cex),
                                   INPUT desp-imp.cod-desp,
                                   INPUT p-cod-desp-original,
                                   INPUT TABLE tt-cotacao-item-cex,
                                   INPUT-OUTPUT TABLE tt-desp-ja-recalc).
        END.
    /*END. /* despesa influenciada por outras */*/

END PROCEDURE.


PROCEDURE pi-verifica-impostos:

    DEF INPUT PARAM p-cod-desp LIKE desp-imp.cod-desp NO-UNDO.

    FIND FIRST desp-imp
         WHERE desp-imp.cod-desp = p-cod-desp NO-LOCK NO-ERROR.

    IF  NOT AVAIL desp-imp THEN
        RETURN "NOK":U.

    IF l-nt2024002 THEN
        FIND FIRST desp-imp-trib
             WHERE desp-imp-trib.cod-desp = p-cod-desp NO-LOCK NO-ERROR.

    IF  p-table-name = "cotacao-item-cex-boin082i":U THEN DO:
        FIND FIRST cotacao-item-cex
             WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
               AND cotacao-item-cex.cod-emitente  = b-cotacao-item-cex.cod-emitente
               AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
               AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
               AND cotacao-item-cex.data-cotacao  = b-cotacao-item-cex.data-cotacao
               AND cotacao-item-cex.mapa-cotacao  = b-cotacao-item-cex.mapa-cotacao 
               AND cotacao-item-cex.cod-desp      = p-cod-desp EXCLUSIVE-LOCK NO-ERROR.

        IF  AVAIL cotacao-item-cex THEN DO:
            RUN pi-trata-impto.
        END.
    END.
    ELSE DO:

        /* incide base II */
        IF  desp-imp.log-2 THEN DO:
            IF  p-table-name = "desp-cot-ordem":U THEN DO:
                FIND FIRST desp-cot-ordem
                     WHERE desp-cot-ordem.cod-agrup  = cot-ordem.cod-agrup
                       AND desp-cot-ordem.mapa-ordem = cot-ordem.mapa-ordem
                       AND desp-cot-ordem.cod-desp   = i-desp-ii-i50 EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL desp-cot-ordem THEN
                    RUN pi-trata-impto.
            END.
            ELSE IF  p-table-name = "tt-cotacao-item-cex":U THEN DO:
                FIND FIRST cotacao-item-cex
                     WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
                       AND cotacao-item-cex.cod-emitente  = tt-cotacao-item-cex.cod-emitente
                       AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
                       AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                       AND cotacao-item-cex.data-cotacao  = tt-cotacao-item-cex.data-cotacao
                       AND cotacao-item-cex.mapa-cotacao  = tt-cotacao-item-cex.mapa-cotacao 
                       AND cotacao-item-cex.cod-desp      = i-desp-ii-i50 EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL cotacao-item-cex THEN
                    RUN pi-trata-impto.
            END.
            ELSE DO:
                FIND FIRST cotacao-item-cex
                     WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
                       AND cotacao-item-cex.cod-emitente  = b-cotacao-item-cex.cod-emitente
                       AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
                       AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                       AND cotacao-item-cex.data-cotacao  = b-cotacao-item-cex.data-cotacao
                       AND cotacao-item-cex.mapa-cotacao  = b-cotacao-item-cex.mapa-cotacao 
                       AND cotacao-item-cex.cod-desp      = i-desp-ii-i50 EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL cotacao-item-cex THEN
                    RUN pi-trata-impto.
            END.
        END.

        IF  desp-imp.inc-base-ipi THEN DO:
            IF  p-table-name = "desp-cot-ordem":U THEN DO:
                FIND FIRST desp-cot-ordem
                     WHERE desp-cot-ordem.cod-agrup  = cot-ordem.cod-agrup
                       AND desp-cot-ordem.mapa-ordem = cot-ordem.mapa-ordem
                       AND desp-cot-ordem.cod-desp   = param-imp.cdn-despes-impto-ipi EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL desp-cot-ordem THEN
                    RUN pi-trata-impto.
            END.
            ELSE IF  p-table-name = "tt-cotacao-item-cex":U THEN DO:
    
                FIND FIRST cotacao-item-cex
                     WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
                       AND cotacao-item-cex.cod-emitente  = tt-cotacao-item-cex.cod-emitente
                       AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
                       AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                       AND cotacao-item-cex.data-cotacao  = tt-cotacao-item-cex.data-cotacao
                       AND cotacao-item-cex.mapa-cotacao  = tt-cotacao-item-cex.mapa-cotacao 
                       AND cotacao-item-cex.cod-desp      = param-imp.cdn-despes-impto-ipi EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL cotacao-item-cex THEN
                    RUN pi-trata-impto.
            END.
            ELSE DO:
                FIND FIRST cotacao-item-cex
                     WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
                       AND cotacao-item-cex.cod-emitente  = b-cotacao-item-cex.cod-emitente
                       AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
                       AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                       AND cotacao-item-cex.data-cotacao  = b-cotacao-item-cex.data-cotacao
                       AND cotacao-item-cex.mapa-cotacao  = b-cotacao-item-cex.mapa-cotacao 
                       AND cotacao-item-cex.cod-desp      = param-imp.cdn-despes-impto-ipi EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL cotacao-item-cex THEN
                    RUN pi-trata-impto.
            END.
        END.
    
        IF  desp-imp.log-incid-base-pis-val
        OR  desp-imp.log-incid-base-pis-despes THEN DO:
            IF  p-table-name = "desp-cot-ordem":U THEN DO:
                FIND FIRST desp-cot-ordem
                     WHERE desp-cot-ordem.cod-agrup  = cot-ordem.cod-agrup
                       AND desp-cot-ordem.mapa-ordem = cot-ordem.mapa-ordem
                       AND desp-cot-ordem.cod-desp   = param-imp.cdn-despes-impto-pis EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL desp-cot-ordem THEN
                    RUN pi-trata-impto.
            END.
            ELSE IF  p-table-name = "tt-cotacao-item-cex":U THEN DO:
    
                FIND FIRST cotacao-item-cex
                     WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
                       AND cotacao-item-cex.cod-emitente  = tt-cotacao-item-cex.cod-emitente
                       AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
                       AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                       AND cotacao-item-cex.data-cotacao  = tt-cotacao-item-cex.data-cotacao
                       AND cotacao-item-cex.mapa-cotacao  = tt-cotacao-item-cex.mapa-cotacao 
                       AND cotacao-item-cex.cod-desp      = param-imp.cdn-despes-impto-pis EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL cotacao-item-cex THEN
                    RUN pi-trata-impto.
            END.
            ELSE DO:
                FIND FIRST cotacao-item-cex
                     WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
                       AND cotacao-item-cex.cod-emitente  = b-cotacao-item-cex.cod-emitente
                       AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
                       AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                       AND cotacao-item-cex.data-cotacao  = b-cotacao-item-cex.data-cotacao
                       AND cotacao-item-cex.mapa-cotacao  = b-cotacao-item-cex.mapa-cotacao 
                       AND cotacao-item-cex.cod-desp      = param-imp.cdn-despes-impto-pis EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL cotacao-item-cex THEN
                    RUN pi-trata-impto.
            END.
        END.
    
        IF  desp-imp.log-incid-base-cofins-val 
        OR  desp-imp.log-incid-base-cofins-despes THEN DO:
            IF  p-table-name = "desp-cot-ordem":U THEN DO:
                FIND FIRST desp-cot-ordem
                     WHERE desp-cot-ordem.cod-agrup  = cot-ordem.cod-agrup
                       AND desp-cot-ordem.mapa-ordem = cot-ordem.mapa-ordem
                       AND desp-cot-ordem.cod-desp   = param-imp.cdn-despes-impto-cofins EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL desp-cot-ordem THEN
                    RUN pi-trata-impto.
            END.
            ELSE IF  p-table-name = "tt-cotacao-item-cex":U THEN DO:
    
                FIND FIRST cotacao-item-cex
                     WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
                       AND cotacao-item-cex.cod-emitente  = tt-cotacao-item-cex.cod-emitente
                       AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
                       AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                       AND cotacao-item-cex.data-cotacao  = tt-cotacao-item-cex.data-cotacao
                       AND cotacao-item-cex.mapa-cotacao  = tt-cotacao-item-cex.mapa-cotacao 
                       AND cotacao-item-cex.cod-desp      = param-imp.cdn-despes-impto-cofins EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL cotacao-item-cex THEN
                    RUN pi-trata-impto.
            END.
            ELSE DO:
                FIND FIRST cotacao-item-cex
                     WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
                       AND cotacao-item-cex.cod-emitente  = b-cotacao-item-cex.cod-emitente
                       AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
                       AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                       AND cotacao-item-cex.data-cotacao  = b-cotacao-item-cex.data-cotacao
                       AND cotacao-item-cex.mapa-cotacao  = b-cotacao-item-cex.mapa-cotacao 
                       AND cotacao-item-cex.cod-desp      = param-imp.cdn-despes-impto-cofins EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL cotacao-item-cex THEN
                    RUN pi-trata-impto.
            END.
        END.

        IF  desp-imp.inc-base-icms THEN DO:
            IF  p-table-name = "desp-cot-ordem":U THEN DO:
                FIND FIRST desp-cot-ordem
                     WHERE desp-cot-ordem.cod-agrup  = cot-ordem.cod-agrup
                       AND desp-cot-ordem.mapa-ordem = cot-ordem.mapa-ordem
                       AND desp-cot-ordem.cod-desp   = param-imp.cdn-despes-impto-icms EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL desp-cot-ordem THEN
                    RUN pi-trata-impto.
            END.
            ELSE IF  p-table-name = "tt-cotacao-item-cex":U THEN DO:
                FIND FIRST cotacao-item-cex
                     WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
                       AND cotacao-item-cex.cod-emitente  = tt-cotacao-item-cex.cod-emitente
                       AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
                       AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                       AND cotacao-item-cex.data-cotacao  = tt-cotacao-item-cex.data-cotacao
                       AND cotacao-item-cex.mapa-cotacao  = tt-cotacao-item-cex.mapa-cotacao 
                       AND cotacao-item-cex.cod-desp      = param-imp.cdn-despes-impto-icms EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL cotacao-item-cex THEN
                    RUN pi-trata-impto.
            END.
            ELSE DO:
                FIND FIRST cotacao-item-cex
                     WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
                       AND cotacao-item-cex.cod-emitente  = b-cotacao-item-cex.cod-emitente
                       AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
                       AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                       AND cotacao-item-cex.data-cotacao  = b-cotacao-item-cex.data-cotacao
                       AND cotacao-item-cex.mapa-cotacao  = b-cotacao-item-cex.mapa-cotacao 
                       AND cotacao-item-cex.cod-desp      = param-imp.cdn-despes-impto-icms EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL cotacao-item-cex THEN
                    RUN pi-trata-impto.
            END.
        END.
        
        IF l-nt2024002
        AND AVAIL desp-imp-trib
        AND AVAIL param-imp-trib
        AND desp-imp-trib.log-incide-base-IBSUF THEN DO:
            IF  p-table-name = "desp-cot-ordem":U THEN DO:
                FIND FIRST desp-cot-ordem
                     WHERE desp-cot-ordem.cod-agrup  = cot-ordem.cod-agrup
                       AND desp-cot-ordem.mapa-ordem = cot-ordem.mapa-ordem
                       AND desp-cot-ordem.cod-desp   = param-imp-trib.cdn-despes-impto-IBSUF EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL desp-cot-ordem THEN
                    RUN pi-trata-impto.
            END.
            ELSE IF  p-table-name = "tt-cotacao-item-cex":U THEN DO:
                FIND FIRST cotacao-item-cex
                     WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
                       AND cotacao-item-cex.cod-emitente  = tt-cotacao-item-cex.cod-emitente
                       AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
                       AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                       AND cotacao-item-cex.data-cotacao  = tt-cotacao-item-cex.data-cotacao
                       AND cotacao-item-cex.mapa-cotacao  = tt-cotacao-item-cex.mapa-cotacao 
                       AND cotacao-item-cex.cod-desp      = param-imp-trib.cdn-despes-impto-IBSUF EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL cotacao-item-cex THEN
                    RUN pi-trata-impto.
            END.
            ELSE DO:
                FIND FIRST cotacao-item-cex
                     WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
                       AND cotacao-item-cex.cod-emitente  = b-cotacao-item-cex.cod-emitente
                       AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
                       AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                       AND cotacao-item-cex.data-cotacao  = b-cotacao-item-cex.data-cotacao
                       AND cotacao-item-cex.mapa-cotacao  = b-cotacao-item-cex.mapa-cotacao 
                       AND cotacao-item-cex.cod-desp      = param-imp-trib.cdn-despes-impto-IBSUF EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL cotacao-item-cex THEN
                    RUN pi-trata-impto.
            END.
        END.
        
        IF l-nt2024002
        AND AVAIL desp-imp-trib
        AND AVAIL param-imp-trib
        AND desp-imp-trib.log-incide-base-CBS-vladu THEN DO:
            IF  p-table-name = "desp-cot-ordem":U THEN DO:
                FIND FIRST desp-cot-ordem
                     WHERE desp-cot-ordem.cod-agrup  = cot-ordem.cod-agrup
                       AND desp-cot-ordem.mapa-ordem = cot-ordem.mapa-ordem
                       AND desp-cot-ordem.cod-desp   = param-imp-trib.cdn-despes-impto-CBS EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL desp-cot-ordem THEN
                    RUN pi-trata-impto.
            END.
            ELSE IF  p-table-name = "tt-cotacao-item-cex":U THEN DO:
                FIND FIRST cotacao-item-cex
                     WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
                       AND cotacao-item-cex.cod-emitente  = tt-cotacao-item-cex.cod-emitente
                       AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
                       AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                       AND cotacao-item-cex.data-cotacao  = tt-cotacao-item-cex.data-cotacao
                       AND cotacao-item-cex.mapa-cotacao  = tt-cotacao-item-cex.mapa-cotacao 
                       AND cotacao-item-cex.cod-desp      = param-imp-trib.cdn-despes-impto-CBS EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL cotacao-item-cex THEN
                    RUN pi-trata-impto.
            END.
            ELSE DO:
                FIND FIRST cotacao-item-cex
                     WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
                       AND cotacao-item-cex.cod-emitente  = b-cotacao-item-cex.cod-emitente
                       AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
                       AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                       AND cotacao-item-cex.data-cotacao  = b-cotacao-item-cex.data-cotacao
                       AND cotacao-item-cex.mapa-cotacao  = b-cotacao-item-cex.mapa-cotacao 
                       AND cotacao-item-cex.cod-desp      = param-imp-trib.cdn-despes-impto-CBS EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL cotacao-item-cex THEN
                    RUN pi-trata-impto.
            END.
        END.

        IF l-nt2024002
        AND AVAIL desp-imp-trib
        AND AVAIL param-imp-trib
        AND desp-imp-trib.log-incide-base-IBSMun THEN DO:
            IF  p-table-name = "desp-cot-ordem":U THEN DO:
                FIND FIRST desp-cot-ordem
                     WHERE desp-cot-ordem.cod-agrup  = cot-ordem.cod-agrup
                       AND desp-cot-ordem.mapa-ordem = cot-ordem.mapa-ordem
                       AND desp-cot-ordem.cod-desp   = param-imp-trib.cdn-despes-impto-IBSMun EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL desp-cot-ordem THEN
                    RUN pi-trata-impto.
            END.
            ELSE IF  p-table-name = "tt-cotacao-item-cex":U THEN DO:
                FIND FIRST cotacao-item-cex
                     WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
                       AND cotacao-item-cex.cod-emitente  = tt-cotacao-item-cex.cod-emitente
                       AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
                       AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                       AND cotacao-item-cex.data-cotacao  = tt-cotacao-item-cex.data-cotacao
                       AND cotacao-item-cex.mapa-cotacao  = tt-cotacao-item-cex.mapa-cotacao 
                       AND cotacao-item-cex.cod-desp      = param-imp-trib.cdn-despes-impto-IBSMun EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL cotacao-item-cex THEN
                    RUN pi-trata-impto.
            END.
            ELSE DO:
                FIND FIRST cotacao-item-cex
                     WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
                       AND cotacao-item-cex.cod-emitente  = b-cotacao-item-cex.cod-emitente
                       AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
                       AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                       AND cotacao-item-cex.data-cotacao  = b-cotacao-item-cex.data-cotacao
                       AND cotacao-item-cex.mapa-cotacao  = b-cotacao-item-cex.mapa-cotacao 
                       AND cotacao-item-cex.cod-desp      = param-imp-trib.cdn-despes-impto-IBSMun EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL cotacao-item-cex THEN
                    RUN pi-trata-impto.
            END.
        END.
        
        IF l-nt2024002
        AND AVAIL desp-imp-trib
        AND AVAIL param-imp-trib
        AND desp-imp-trib.log-incide-base-IS THEN DO:      
            IF  p-table-name = "desp-cot-ordem":U THEN DO:
                FIND FIRST desp-cot-ordem
                     WHERE desp-cot-ordem.cod-agrup  = cot-ordem.cod-agrup
                       AND desp-cot-ordem.mapa-ordem = cot-ordem.mapa-ordem
                       AND desp-cot-ordem.cod-desp   = param-imp-trib.cdn-despes-impto-IS EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL desp-cot-ordem THEN
                    RUN pi-trata-impto.
            END.
            ELSE IF  p-table-name = "tt-cotacao-item-cex":U THEN DO:
                FIND FIRST cotacao-item-cex
                     WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
                       AND cotacao-item-cex.cod-emitente  = tt-cotacao-item-cex.cod-emitente
                       AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
                       AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                       AND cotacao-item-cex.data-cotacao  = tt-cotacao-item-cex.data-cotacao
                       AND cotacao-item-cex.mapa-cotacao  = tt-cotacao-item-cex.mapa-cotacao 
                       AND cotacao-item-cex.cod-desp      = param-imp-trib.cdn-despes-impto-IS EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL cotacao-item-cex THEN
                    RUN pi-trata-impto.
            END.
            ELSE DO:
                FIND FIRST cotacao-item-cex
                     WHERE cotacao-item-cex.numero-ordem  = cotacao-item.numero-ordem
                       AND cotacao-item-cex.cod-emitente  = b-cotacao-item-cex.cod-emitente
                       AND cotacao-item-cex.it-codigo     = ordem-compra.it-codigo
                       AND cotacao-item-cex.seq-cotac     = cotacao-item.seq-cotac
                       AND cotacao-item-cex.data-cotacao  = b-cotacao-item-cex.data-cotacao
                       AND cotacao-item-cex.mapa-cotacao  = b-cotacao-item-cex.mapa-cotacao 
                       AND cotacao-item-cex.cod-desp      = param-imp-trib.cdn-despes-impto-IS EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL cotacao-item-cex THEN
                    RUN pi-trata-impto.
            END.
        END.
    END.

END PROCEDURE.


PROCEDURE pi-trata-impto:

    DEFINE VARIABLE i-cod-desp AS INTEGER NO-UNDO.

    IF p-table-name = "desp-cot-ordem":U THEN
        ASSIGN i-cod-desp = desp-cot-ordem.cod-desp.
    ELSE
        ASSIGN i-cod-desp = cotacao-item-cex.cod-desp.

    find first desp-tb-pr-cex NO-LOCK WHERE 
        desp-tb-pr-cex.cod-desp     = cotacao-item-cex.cod-desp          and
        desp-tb-pr-cex.nr-tab       = cotacao-item-cex.nr-tab            and
        desp-tb-pr-cex.cod-cond-pag = cotacao-item-cex.cod-cond-pag      and
        desp-tb-pr-cex.cod-emitente = cotacao-item-cex.cod-emitente-desp and
        desp-tb-pr-cex.cod-itiner   = cotacao-item-cex.cod-itiner        and
        desp-tb-pr-cex.cod-incoterm = cotacao-item-cex.cod-incoterm no-error.
    IF AVAILABLE desp-tb-pr-cex THEN
        IF desp-tb-pr-cex.val-desp <> 0 THEN RETURN.

    /*--- verifica se a despesa jah nao 
          havia sido marcada antes ---*/
    IF  NOT CAN-FIND(FIRST tt-desp-ja-recalc
                     WHERE tt-desp-ja-recalc.cod-desp = i-cod-desp) THEN DO:
               
        /*--- se o mapa e a cotacao estiverem aprovados
              chama o calculo da despesa, senao apenas
              marca para serem recalculadas ---*/
        IF  l-aprovado THEN DO:
            IF  p-table-name = "cotacao-item-cex":U 
            OR  p-table-name = "tt-cotacao-item-cex":U 
            OR  p-table-name = "cotacao-item-cex-boin082i":U THEN DO:
                IF  VALID-HANDLE(h-bocx085) THEN
                    RUN pi-calcula-despesa IN h-bocx085 (INPUT  ROWID(cotacao-item-cex),
                                                         OUTPUT de-valor-despesa).

                ASSIGN cotacao-item-cex.val-desp = de-valor-despesa.
            END.
        END.
        ELSE DO:
            IF  p-table-name = "desp-cot-ordem":U THEN
                ASSIGN desp-cot-ordem.log-recalc-val = YES.
            ELSE
                ASSIGN cotacao-item-cex.log-recalc-val = YES.
        END.
    END.


END PROCEDURE.

/* Verifica se a Despesa possui F¢rmula com 
   Despesas Complementares - getFormulaDesp */
{imp/imapi001.i4} 

/* FIM: IMAPI006.P */
