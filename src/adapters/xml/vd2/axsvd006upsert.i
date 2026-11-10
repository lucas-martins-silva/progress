PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/
DEFINE INPUT PARAMETER pTranAction          AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pPriceTableItemRowID AS ROWID      NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/

/*LOCAL VARIABLES - BEGIN*/
DEFINE VARIABLE cont-PriceUpdate    AS INTEGER  INITIAL 0  NO-UNDO.
/*LOCAL VARIABLES - END*/

EMPTY TEMP-TABLE tt_log_erro NO-ERROR.
EMPTY TEMP-TABLE ttPriceTable     NO-ERROR.
EMPTY TEMP-TABLE ttPriceTableItem NO-ERROR.
EMPTY TEMP-TABLE ttPriceUpdate    NO-ERROR.

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

FIND FIRST preco-item WHERE ROWID(preco-item) = pPriceTableItemRowID NO-LOCK NO-ERROR.
                                      
 IF AVAIL preco-item THEN DO:
    
    FOR FIRST ITEM FIELDS(desc-item) NO-LOCK
        WHERE ITEM.it-codigo = preco-item.it-codigo: END.

    FOR FIRST tab-unidade FIELDS(descricao) NO-LOCK
        WHERE tab-unidade.un = preco-item.cod-unid-med: END.

    FOR FIRST markup FIELDS(descricao cod-formula) NO-LOCK
        WHERE markup.cod-markup = preco-item.cod-markup: END.
    
    IF AVAIL markup THEN
        FOR FIRST form-tb-formula FIELDS(des-formula dat-inic-validade dat-fim-validade) NO-LOCK
            WHERE form-tb-formula.cod-formula = markup.cod-formula: END.
                
    CREATE ttPriceTableItem.
    ASSIGN ttPriceTableItem.Sequence         = 1
           ttPriceTableItem.nr-tabpre        = preco-item.nr-tabpre
           ttPriceTableItem.it-codigo        = preco-item.it-codigo
           ttPriceTableItem.desc-item        = ITEM.desc-item WHEN AVAIL ITEM
           ttPriceTableItem.cod-refer        = preco-item.cod-refer
           ttPriceTableItem.cod-unid-med     = preco-item.cod-unid-med
           ttPriceTableItem.descricao        = tab-unidade.descricao WHEN AVAIL tab-unidade
           ttPriceTableItem.dt-inival        = preco-item.dt-inival
           ttPriceTableItem.dt-useralt       = preco-item.dt-useralt
           ttPriceTableItem.quant-min        = preco-item.quant-min
           ttPriceTableItem.cod-markup       = preco-item.cod-markup
           ttPriceTableItem.descr-markup     = markup.descricao   WHEN AVAIL markup
           ttPriceTableItem.cod-formula      = markup.cod-formula WHEN AVAIL markup
           ttPriceTableItem.des-formula      = form-tb-formula.des-formula       WHEN AVAIL form-tb-formula
           ttPriceTableItem.dt-inival        = form-tb-formula.dat-inic-validade WHEN AVAIL form-tb-formula
           ttPriceTableItem.dt-fimval        = form-tb-formula.dat-fim-validade  WHEN AVAIL form-tb-formula
           ttPriceTableItem.situacao         = preco-item.situacao
           ttPriceTableItem.desco-quant      = preco-item.desco-quant
           ttPriceTableItem.preco-venda      = preco-item.preco-venda
           ttPriceTableItem.preco-min-cif    = preco-item.preco-min-cif
           ttPriceTableItem.preco-fob        = preco-item.preco-fob
           ttPriceTableItem.preco-min-fob    = preco-item.preco-min-fob
           ttPriceTableItem.val-pct-lucro    = preco-item.val-pct-lucro
           ttPriceTableItem.preco-lucro-zero = preco-item.preco-lucro-zero.

    FOR EACH hist-preco NO-LOCK
       WHERE hist-preco.nr-tabpre = preco-item.nr-tabpre
       AND   hist-preco.it-codigo = preco-item.it-codigo
       AND   hist-preco.cod-refer = preco-item.cod-refer
       &IF DEFINED(bf_dis_preco_un_med_mult) &THEN
           AND hist-preco.des-un-medida = preco-item.cod-unid-med 
       &ENDIF
       AND   hist-preco.quant-min = preco-item.quant-min
       AND   hist-preco.dt-inival = preco-item.dt-inival:
        
        FOR FIRST gr-preco FIELDS(descr) NO-LOCK
            WHERE gr-preco.cd-gr-preco = hist-preco.cd-gr-preco: END.

        cont-PriceUpdate = cont-PriceUpdate + 1.
        CREATE ttPriceUpdate.
        ASSIGN ttPriceUpdate.Sequence         = cont-PriceUpdate
               ttPriceUpdate.nr-tabpre        = preco-item.nr-tabpre
               ttPriceUpdate.it-codigo        = preco-item.it-codigo
               ttPriceUpdate.cod-refer        = preco-item.cod-refer
               ttPriceUpdate.quant-min        = preco-item.quant-min
               ttPriceUpdate.dt-inival        = preco-item.dt-inival
             &IF DEFINED(bf_dis_preco_un_med_mult) &THEN
                 ttPriceUpdate.des-un-medida    = preco-item.des-un-medida
             &ENDIF
               ttPriceUpdate.dt-movto         = hist-preco.dt-movto
               ttPriceUpdate.hr-movto         = hist-preco.hr-movto
               ttPriceUpdate.cd-origem        = hist-preco.cd-origem
               ttPriceUpdate.usuario-mov      = hist-preco.usuario-mov
               ttPriceUpdate.sit-tabpre       = hist-preco.sit-tabpre
               ttPriceUpdate.sit-hist         = hist-preco.sit-hist
               ttPriceUpdate.cd-gr-preco      = hist-preco.cd-gr-preco
               ttPriceUpdate.descr            = gr-preco.descr WHEN AVAIL gr-preco
               ttPriceUpdate.desco-quant      = hist-preco.desco-quant
               ttPriceUpdate.preco-venda      = hist-preco.preco-venda
               ttPriceUpdate.preco-min-cif    = hist-preco.preco-min-cif
               ttPriceUpdate.preco-fob        = hist-preco.preco-fob
               ttPriceUpdate.preco-min-fob    = hist-preco.preco-min-fob
               ttPriceUpdate.preco-lucro-zero = hist-preco.preco-lucro-zero.
    END.

    FOR FIRST tb-preco FIELDS( nr-tabpre descricao dt-inival dt-fimval situacao 
                               cd-gr-preco mo-codigo desconto observacoes) WHERE 
              tb-preco.nr-tabpre = preco-item.nr-tabpre NO-LOCK: END.

    IF AVAIL tb-preco THEN DO:

       FOR FIRST gr-preco FIELDS(descr) NO-LOCK
           WHERE gr-preco.cd-gr-preco = tb-preco.cd-gr-preco: END.

       FOR FIRST moeda FIELDS(descricao sigla) NO-LOCK 
           WHERE moeda.mo-codigo = tb-preco.mo-codigo: END.

        CREATE ttPriceTable.
        ASSIGN ttPriceTable.nr-tabpre   = tb-preco.nr-tabpre
               ttPriceTable.descricao   = tb-preco.descricao
               ttPriceTable.dt-inival   = tb-preco.dt-inival
               ttPriceTable.dt-fimval   = tb-preco.dt-fimval
               ttPriceTable.situacao    = tb-preco.situacao
               ttPriceTable.cd-gr-preco = tb-preco.cd-gr-preco
               ttPriceTable.descr       = gr-preco.descr WHEN AVAIL gr-preco
               ttPriceTable.mo-codigo   = tb-preco.mo-codigo
               ttPriceTable.descr-moeda = moeda.descricao WHEN AVAIL moeda
               ttPriceTable.sigla       = moeda.sigla     WHEN AVAIL moeda
               ttPriceTable.desconto    = tb-preco.desconto
               ttPriceTable.observacoes = tb-preco.observacoes.
    END.
    
    IF CAN-FIND(FIRST ttPriceTableItem) THEN
       RUN PIUpsert ( INPUT  pTranAction, 
                      INPUT  TABLE ttPriceTable, 
                      INPUT  TABLE ttPriceTableItem, 
                      INPUT  TABLE ttPriceUpdate,
                      OUTPUT TABLE tt_log_erro ).

    RETURN "OK":U.

 END. /* preco-item */

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.

PROCEDURE PITransUpdateByDate:

/*PARAMETERS - BEGIN*/
DEFINE INPUT PARAMETER pTranAction          AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER pPriceTableRowID     AS ROWID NO-UNDO.
DEFINE INPUT PARAMETER pPriceItemUpdateDate AS DATE  NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/

/*LOCAL VARIABLES - BEGIN*/
DEFINE VARIABLE cont-PriceUpdate    AS INTEGER           NO-UNDO.
DEFINE VARIABLE cont-PriceTableItem AS INTEGER INITIAL 0 NO-UNDO.
/*LOCAL VARIABLES - END*/

EMPTY TEMP-TABLE tt_log_erro      NO-ERROR.
EMPTY TEMP-TABLE ttPriceTable     NO-ERROR.
EMPTY TEMP-TABLE ttPriceTableItem NO-ERROR.
EMPTY TEMP-TABLE ttPriceUpdate    NO-ERROR.

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

FOR FIRST tb-preco FIELDS( descricao dt-inival dt-fimval situacao
                           cd-gr-preco mo-codigo desconto observacoes) WHERE 
    ROWID(tb-preco) = pPriceTableRowID NO-LOCK: END.

IF AVAIL tb-preco THEN DO:

    FOR FIRST moeda FIELDS(descricao sigla) NO-LOCK 
        WHERE moeda.mo-codigo = tb-preco.mo-codigo: END.

    CREATE ttPriceTable.
    ASSIGN ttPriceTable.nr-tabpre   = tb-preco.nr-tabpre
           ttPriceTable.descricao   = tb-preco.descricao
           ttPriceTable.dt-inival   = tb-preco.dt-inival
           ttPriceTable.dt-fimval   = tb-preco.dt-fimval
           ttPriceTable.situacao    = tb-preco.situacao
           ttPriceTable.cd-gr-preco = tb-preco.cd-gr-preco
           ttPriceTable.descr       = gr-preco.descr  WHEN AVAIL gr-preco
           ttPriceTable.mo-codigo   = tb-preco.mo-codigo
           ttPriceTable.descr-moeda = moeda.descricao WHEN AVAIL moeda
           ttPriceTable.sigla       = moeda.sigla     WHEN AVAIL moeda
           ttPriceTable.desconto    = tb-preco.desconto
           ttPriceTable.observacoes = tb-preco.observacoes.

    FOR EACH preco-item
       WHERE preco-item.dt-useralt = pPriceItemUpdateDate
         AND preco-item.nr-tabpre  = tb-preco.nr-tabpre NO-LOCK:
        
            /* Sequencial */
            cont-PriceTableItem = cont-PriceTableItem + 1.
    
            FOR FIRST ITEM FIELDS(desc-item) NO-LOCK
                WHERE ITEM.it-codigo = preco-item.it-codigo: END.

            FOR FIRST tab-unidade FIELDS(descricao) NO-LOCK
                WHERE tab-unidade.un = preco-item.cod-unid-med: END.

            FOR FIRST markup FIELDS(descricao cod-formula) NO-LOCK
                WHERE markup.cod-markup = preco-item.cod-markup: END.
    
            IF AVAIL markup THEN
               FOR FIRST form-tb-formula FIELDS(des-formula dat-inic-validade dat-fim-validade) NO-LOCK
                   WHERE form-tb-formula.cod-formula = markup.cod-formula: END.
    
            CREATE ttPriceTableItem.
            ASSIGN ttPriceTableItem.Sequence         = cont-PriceTableItem
                   ttPriceTableItem.nr-tabpre        = preco-item.nr-tabpre
                   ttPriceTableItem.it-codigo        = preco-item.it-codigo
                   ttPriceTableItem.desc-item        = ITEM.desc-item WHEN AVAIL ITEM
                   ttPriceTableItem.cod-refer        = preco-item.cod-refer
                   ttPriceTableItem.cod-unid-med     = preco-item.cod-unid-med
                   ttPriceTableItem.descricao        = tab-unidade.descricao WHEN AVAIL tab-unidade
                   ttPriceTableItem.dt-inival        = preco-item.dt-inival
                   ttPriceTableItem.dt-useralt       = preco-item.dt-useralt
                   ttPriceTableItem.quant-min        = preco-item.quant-min
                   ttPriceTableItem.cod-markup       = preco-item.cod-markup
                   ttPriceTableItem.descricao        = markup.descricao   WHEN AVAIL markup
                   ttPriceTableItem.cod-formula      = markup.cod-formula WHEN AVAIL markup
                   ttPriceTableItem.des-formula      = form-tb-formula.des-formula       WHEN AVAIL form-tb-formula
                   ttPriceTableItem.dt-inival        = form-tb-formula.dat-inic-validade WHEN AVAIL form-tb-formula
                   ttPriceTableItem.dt-fimval        = form-tb-formula.dat-fim-validade  WHEN AVAIL form-tb-formula
                   ttPriceTableItem.situacao         = preco-item.situacao
                   ttPriceTableItem.desco-quant      = preco-item.desco-quant
                   ttPriceTableItem.preco-venda      = preco-item.preco-venda
                   ttPriceTableItem.preco-min-cif    = preco-item.preco-min-cif
                   ttPriceTableItem.preco-fob        = preco-item.preco-fob
                   ttPriceTableItem.preco-min-fob    = preco-item.preco-min-fob
                   ttPriceTableItem.val-pct-lucro    = preco-item.val-pct-lucro
                   ttPriceTableItem.preco-lucro-zero = preco-item.preco-lucro-zero.
    
            /* Sequencial */
            cont-PriceUpdate = 0.
            FOR EACH hist-preco NO-LOCK
               WHERE hist-preco.nr-tabpre = preco-item.nr-tabpre
               AND   hist-preco.it-codigo = preco-item.it-codigo
               AND   hist-preco.cod-refer = preco-item.cod-refer
               &IF DEFINED(bf_dis_preco_un_med_mult) &THEN
                   AND hist-preco.des-un-medida = preco-item.cod-unid-med 
               &ENDIF
               AND   hist-preco.quant-min = preco-item.quant-min
               AND   hist-preco.dt-inival = preco-item.dt-inival:
    
                FOR FIRST gr-preco FIELDS(descr) NO-LOCK
                    WHERE gr-preco.cd-gr-preco = hist-preco.cd-gr-preco: END.
    
                cont-PriceUpdate = cont-PriceUpdate + 1.
                CREATE ttPriceUpdate.
                ASSIGN ttPriceUpdate.Sequence         = cont-PriceUpdate
                       ttPriceUpdate.nr-tabpre        = preco-item.nr-tabpre
                       ttPriceUpdate.it-codigo        = preco-item.it-codigo
                       ttPriceUpdate.cod-refer        = preco-item.cod-refer
                       ttPriceUpdate.quant-min        = preco-item.quant-min
                       ttPriceUpdate.dt-inival        = preco-item.dt-inival
                    &IF DEFINED(bf_dis_preco_un_med_mult) &THEN
                       ttPriceUpdate.des-un-medida    = preco-item.des-un-medida
                    &ENDIF
                       ttPriceUpdate.dt-movto         = hist-preco.dt-movto
                       ttPriceUpdate.hr-movto         = hist-preco.hr-movto
                       ttPriceUpdate.cd-origem        = hist-preco.cd-origem
                       ttPriceUpdate.usuario-mov      = hist-preco.usuario-mov
                       ttPriceUpdate.sit-tabpre       = hist-preco.sit-tabpre
                       ttPriceUpdate.sit-hist         = hist-preco.sit-hist
                       ttPriceUpdate.cd-gr-preco      = hist-preco.cd-gr-preco
                       ttPriceUpdate.descr            = gr-preco.descr WHEN AVAIL gr-preco
                       ttPriceUpdate.desco-quant      = hist-preco.desco-quant
                       ttPriceUpdate.preco-venda      = hist-preco.preco-venda
                       ttPriceUpdate.preco-min-cif    = hist-preco.preco-min-cif
                       ttPriceUpdate.preco-fob        = hist-preco.preco-fob
                       ttPriceUpdate.preco-min-fob    = hist-preco.preco-min-fob
                       ttPriceUpdate.preco-lucro-zero = hist-preco.preco-lucro-zero.
            END.
    END. /* preco-item */
END. /* tb-preco */

IF CAN-FIND(FIRST ttPriceTableItem) THEN
   RUN PIUpsert ( INPUT  pTranAction, 
                  INPUT  TABLE ttPriceTable, 
                  INPUT  TABLE ttPriceTableItem, 
                  INPUT  TABLE ttPriceUpdate,
                  OUTPUT TABLE tt_log_erro ).

RETURN "OK":U.

END PROCEDURE.

