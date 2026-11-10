/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXRAR003 2.00.00.008 } /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i axrar003 MUT}
&ENDIF






/* DEFINICAO DE PRE-PROCESSADORES - BEGIN */
&GLOBAL-DEFINE XmlApp            AR2
&GLOBAL-DEFINE XmlMod            MCE
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    204
&GLOBAL-DEFINE XmlTranName       ItemBalance
&GLOBAL-DEFINE XmlMinTranVersion 204.000
&GLOBAL-DEFINE XmlMaxTranVersion 204.999
&GLOBAL-DEFINE XmlListOfAction   qry

{cdp/cdcfgman.i}
&if defined (bf_man_sfc_lc) &then 
    &GLOBAL-DEFINE log-cons-saldo-mrp deposito.log-ordens-mrp
&else
    &GLOBAL-DEFINE log-cons-saldo-mrp deposito.log-1
&endif

/* DEFINICAO DE PRE-PROCESSADORES - END */

/*LOCAL VARIABLES - BEGIN*/
DEFINE VAR hGenXml          AS HANDLE              NO-UNDO.
DEFINE VAR cTranAction      AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR cTranEvent       AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR cReturnValue     AS CHARACTER           NO-UNDO.
DEFINE VAR cTranVersion     AS CHARACTER INITIAL ? NO-UNDO.   
DEFINE VAR hBusinessContent AS HANDLE              NO-UNDO.
DEFINE VAR hMessagehandler  AS HANDLE              NO-UNDO.
DEFINE VAR lSuccessProcess  AS LOGICAL   INITIAL ? NO-UNDO.
DEFINE VAR cErrorText       AS CHAR                NO-UNDO.

/* Variaveis utilizadas na leitura da mensagem de consulta */
DEF VAR c-it-codigo-ini   AS CHAR  NO-UNDO.
DEF VAR c-it-codigo-fim   AS CHAR  NO-UNDO INITIAL ?.
DEF VAR c-fm-codigo-ini   AS CHAR  NO-UNDO INITIAL ?.
DEF VAR c-fm-codigo-fim   AS CHAR  NO-UNDO INITIAL ?.
DEF VAR i-ge-codigo-ini   AS INT   NO-UNDO INITIAL ?.
DEF VAR i-ge-codigo-fim   AS INT   NO-UNDO INITIAL ?.
DEF VAR c-cod-estab-ini   AS CHAR  NO-UNDO INITIAL ?.
DEF VAR c-cod-estab-fim   AS CHAR  NO-UNDO INITIAL ?.
DEF VAR c-cod-depos-ini   AS CHAR  NO-UNDO INITIAL ?.
DEF VAR c-cod-depos-fim   AS CHAR  NO-UNDO INITIAL ?.
DEF VAR c-cod-localiz-ini AS CHAR  NO-UNDO INITIAL ?.
DEF VAR c-cod-localiz-fim AS CHAR  NO-UNDO INITIAL ?.
DEF VAR d-dt-saldo        AS DATE  NO-UNDO INITIAL ?.
DEF VAR l-saldo-disp      AS LOG   NO-UNDO INITIAL FALSE.
DEF VAR l-saldo-disp-mrp  AS LOG   NO-UNDO INITIAL FALSE.
DEF VAR l-dep-prod-aca    AS LOG   NO-UNDO INITIAL TRUE.
DEF VAR l-dep-processo    AS LOG   NO-UNDO INITIAL TRUE.
DEF VAR l-dep-reciclado   AS LOG   NO-UNDO INITIAL TRUE.
DEF VAR l-dep-cq          AS LOG   NO-UNDO INITIAL TRUE.
DEF VAR l-dep-rejeito     AS LOG   NO-UNDO INITIAL TRUE.
DEF VAR l-dep-interno     AS LOG   NO-UNDO INITIAL TRUE.
DEF VAR l-dep-externo     AS LOG   NO-UNDO INITIAL TRUE.
DEF VAR l-saldo-detalhado AS LOG   NO-UNDO INITIAL TRUE.

/* Variaveis utilizadas na constru‡Æo da mensagem de retorno */
DEF VAR d-saldo-calculado  AS DEC  NO-UNDO FORMAT "->>>>>,>>>,>>9.9999". 
DEF VAR d-saldo-disponivel AS DEC  NO-UNDO FORMAT "->>>>>,>>>,>>9.9999". 
DEF VAR d-tot-saldo-calc   AS DEC  NO-UNDO FORMAT "->>>>>>,>>9.9999":U INITIAL 0.
DEF VAR d-tot-disponivel   AS DEC  NO-UNDO FORMAT "->>>>>>,>>9.9999":U INITIAL 0.
DEF VAR d-saldo-disp       AS DEC  NO-UNDO FORMAT "->>>>>>,>>9.9999":U INITIAL 0.

DEF VAR iId                AS INT  NO-UNDO INITIAL ?.
DEF VAR pSendSuccess       AS LOG  NO-UNDO INITIAL YES.
DEF VAR pTotalErrors       AS INT  NO-UNDO.
DEF VAR pErrorNumber       AS INT  NO-UNDO.
DEF VAR pErrorType         AS CHAR NO-UNDO.
DEF VAR pErrorDesc         AS CHAR NO-UNDO.
DEF VAR iCount             AS INT  NO-UNDO.
DEF VAR iErrorCount        AS INT  NO-UNDO.

DEFINE TEMP-TABLE tt-item NO-UNDO
    FIELD it-codigo LIKE ITEM.it-codigo.

DEFINE TEMP-TABLE tt-saldo NO-UNDO
    FIELD cod-estabel   LIKE saldo-estoq.cod-estabel
    FIELD des-estabel   LIKE estabelec.nome
    FIELD cod-depos     LIKE saldo-estoq.cod-depos
    FIELD des-depos     LIKE deposito.nome
    FIELD cod-localiz   LIKE saldo-estoq.cod-localiz
    FIELD des-localiz   LIKE localizacao.descricao
    FIELD it-codigo     LIKE saldo-estoq.it-codigo
    FIELD cod-refer     LIKE saldo-estoq.cod-refer
    FIELD lote          LIKE saldo-estoq.lote
    FIELD dt-vali-lote  LIKE saldo-estoq.dt-vali-lote
    FIELD qtidade-atu   LIKE saldo-estoq.qtidade-atu 
    FIELD qt-alocada    LIKE saldo-estoq.qt-alocada  
    FIELD qt-aloc-prod  LIKE saldo-estoq.qt-aloc-prod
    FIELD qt-aloc-ped   LIKE saldo-estoq.qt-aloc-ped
    FIELD qt-saldo-data LIKE saldo-estoq.qtidade-atu
    FIELD qt-saldo-disp LIKE saldo-estoq.qtidade-atu.

/*LOCAL VARIABLES - END*/

{method/dbotterr.i} 

{xmlinc/xmlloadmessagehandlerrecdef.i}
{xmlinc/xmlloadgenxmlrecdef.i}
{xmlinc/xmlgettranssubsinfo.i}

DEFINE TEMP-TABLE ttStack NO-UNDO
     FIELD ttID AS INTEGER
     FIELD ttPos AS INTEGER
     INDEX tt_id IS PRIMARY UNIQUE
           ttID  ASCENDING.

FUNCTION addStack RETURN INTEGER (INPUT val AS INTEGER).
     DEFINE VAR id AS INTEGER INITIAL 1 NO-UNDO.
     FIND LAST ttStack NO-ERROR.
     IF AVAIL(ttStack) THEN
          id = ttStack.ttID + 1.

     CREATE ttStack.
     ASSIGN ttStack.ttID = id.
     ASSIGN ttStack.ttPos = val.
END FUNCTION.

FUNCTION delStack RETURN INTEGER.
     FIND LAST ttStack NO-ERROR.
     IF AVAIL(ttStack) THEN
          DELETE ttStack.

     FIND LAST ttStack NO-ERROR.
END FUNCTION.

FUNCTION getStack RETURN INTEGER.
     IF AVAIL(ttStack) THEN
          RETURN ttStack.ttPos.
     ELSE
          RETURN 0.
END FUNCTION.


FUNCTION fn-qtd-data RETURNS DECIMAL. /* conforme l¢gica do ce0830 */

    ASSIGN d-saldo-calculado = saldo-estoq.qtidade-atu.

    IF  item.tipo-con-est = 1
        OR   d-dt-saldo   = TODAY /* se for a data padrÆo (today) nao ira localizar nenhum movimento.
                                    neste caso o melhor indice ‚ por data, mesmo que o controle seja por lote */
        THEN OPEN QUERY qr-movto 
             FOR EACH movto-estoq use-index item-data WHERE
                      movto-estoq.it-codigo   = saldo-estoq.it-codigo    AND
                      movto-estoq.cod-refer   = saldo-estoq.cod-refer    AND
                      movto-estoq.cod-estabel = saldo-estoq.cod-estabel  AND
                      movto-estoq.cod-depos   = saldo-estoq.cod-depos    AND
                      movto-estoq.lote        = saldo-estoq.lote         AND
                      movto-estoq.cod-localiz = saldo-estoq.cod-localiz  AND
                      movto-estoq.esp-docto   <> 37                      AND
                      movto-estoq.dt-trans     > d-dt-saldo              NO-LOCK.

    ELSE OPEN QUERY qr-movto
         FOR EACH movto-estoq use-index item-estab WHERE
                  movto-estoq.it-codigo   = saldo-estoq.it-codigo    AND
                  movto-estoq.cod-refer   = saldo-estoq.cod-refer    AND
                  movto-estoq.cod-estabel = saldo-estoq.cod-estabel  AND
                  movto-estoq.cod-depos   = saldo-estoq.cod-depos    AND
                  movto-estoq.lote        = saldo-estoq.lote         AND
                  movto-estoq.cod-localiz = saldo-estoq.cod-localiz  AND
                  movto-estoq.esp-docto   <> 37                      AND   
                  movto-estoq.dt-trans     > d-dt-saldo              NO-LOCK.

    GET FIRST qr-movto NO-LOCK.
    DO WHILE AVAIL (movto-estoq):
        IF movto-estoq.tipo-trans = 1 THEN
            ASSIGN d-saldo-calculado = d-saldo-calculado - movto-estoq.quantidade.
        ELSE
            ASSIGN d-saldo-calculado = d-saldo-calculado + movto-estoq.quantidade.
        GET NEXT qr-movto NO-LOCK.
    END. 

    RETURN d-saldo-calculado.   

END FUNCTION.


/****** INTERNAL PROCEDURES - BEGIN*/

PROCEDURE piQuery: 

    EMPTY TEMP-TABLE RowErrors NO-ERROR.

    RUN getBusinessContent IN hMessagehandler (OUTPUT hBusinessContent).
    RUN reset              IN hGenXml.
    RUN loadXml            IN hGenXml (hBusinessContent).

    DELETE OBJECT hBusinessContent NO-ERROR.

    /* Lˆ mensagem enviada que cont‚m as faixas/parƒmetros de sele‡Æo da consulta */
    RUN getFirstSonId IN hGenXml (INPUT getStack(), OUTPUT iId). /* Query */
    addStack(iId). 

          RUN searchTag IN hGenXml (INPUT "Item":U, INPUT getStack(), OUTPUT iId).
          addStack(iId).

               RUN searchTag IN hGenXml (INPUT "FindByRangeOfItens", INPUT getStack(), OUTPUT iId).
               addStack(iId).
                    /* Faixa de c¢digo de item */
                    RUN searchTag IN hGenXml (INPUT "ItemCode", INPUT getStack(), OUTPUT iId).
                    addStack(iId).

                         RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "InitialItemCode":U, OUTPUT c-it-codigo-ini).
                         RUN searchTag IN hGenXml (INPUT "FinalItemCode":U, INPUT getStack(), OUTPUT iId).
                         IF  iId <> ? THEN
                             RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "FinalItemCode":U, OUTPUT c-it-codigo-fim).
                    delStack().

                    /* Faixa de c¢digo de familia */
                    RUN searchTag IN hGenXml (INPUT "MaterialFamilyCode", INPUT getStack(), OUTPUT iId).
                    IF  iId <> ? THEN DO:
                        addStack(iId).
                            RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "InitialMaterialFamilyCode":U, OUTPUT c-fm-codigo-ini).
                            RUN searchTag IN hGenXml (INPUT "FinalMaterialFamilyCode":U, INPUT getStack(), OUTPUT iId).
                            IF  iId <> ? THEN
                                RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "FinalMaterialFamilyCode":U, OUTPUT c-fm-codigo-fim).
                        delStack().
                    END.

                    /* Faixa de c¢digo de grupo estoque */
                    RUN searchTag IN hGenXml (INPUT "InventoryGroupCode", INPUT getStack(), OUTPUT iId).
                    IF  iId <> ? THEN DO:
                        addStack(iId).
                            RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "InitialInventoryGroupCode":U, OUTPUT i-ge-codigo-ini).
                            RUN searchTag IN hGenXml (INPUT "FinalInventoryGroupCode":U, INPUT getStack(), OUTPUT iId).
                            IF  iId <> ? THEN
                                RUN getSonDec IN hGenXml (INPUT getStack(), INPUT "FinalInventoryGroupCode":U, OUTPUT i-ge-codigo-fim).
                        delStack().
                    END.

               delStack(). /* FindByRangeOfItens */

               RUN searchTag IN hGenXml (INPUT "FindByListOfItens", INPUT getStack(), OUTPUT iId).
               addStack(iId).
                    RUN searchTag IN hGenXml (INPUT "ListOfItens", INPUT getStack(), OUTPUT iId).
                    addStack(iId).
                        RUN getFirstSonId IN hGenXml (INPUT getStack(), OUTPUT iId).
                        DO WHILE iId <> ?:
                             addStack(iId).
                                CREATE tt-item.
                                RUN getValue IN hGenXml (INPUT getStack(), OUTPUT tt-item.it-codigo).
                                ASSIGN iId = getStack().
                             delStack().
                             RUN getNextSonId IN hGenXml (INPUT getStack(), INPUT iId, OUTPUT iId).
                        END.
                    delStack().
               delStack().

          delStack(). /* Item */

          /* Estabelecimento */
          RUN searchTag IN hGenXml (INPUT "Site", INPUT getStack(), OUTPUT iId).
          IF  iId <> ? THEN DO:
              addStack(iId).
                   RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "InitialSiteID", OUTPUT c-cod-estab-ini).
                   RUN searchTag IN hGenXml (INPUT "FinalSiteID":U, INPUT getStack(), OUTPUT iId).
                   IF  iId <> ? THEN
                       RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "FinalSiteID",   OUTPUT c-cod-estab-fim).
              delStack().
          END.

          /* Dep¢sito */
          RUN searchTag IN hGenXml (INPUT "Warehouse", INPUT getStack(), OUTPUT iId).
          IF  iId <> ? THEN DO:
              addStack(iId).

                   RUN searchTag IN hGenXml (INPUT "InitialWarehouseID":U, INPUT getStack(), OUTPUT iId).
                   IF  iId <> ? THEN
                       RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "InitialWarehouseID", OUTPUT c-cod-depos-ini).

                   RUN searchTag IN hGenXml (INPUT "FinalWarehouseID":U, INPUT getStack(), OUTPUT iId).
                   IF  iId <> ? THEN
                       RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "FinalWarehouseID", OUTPUT c-cod-depos-fim).

                   RUN searchTag IN hGenXml (INPUT "WarehouseCharacteristics", INPUT getStack(), OUTPUT iId).
                   IF  iId <> ? THEN DO:
                       addStack(iId).

                           /* Somente depositos Considera Saldo Disponivel */
                           RUN searchTag IN hGenXml (INPUT "OnlyAvaiableBalanceWarehouses":U, INPUT getStack(), OUTPUT iId).
                           IF  iId <> ? THEN
                               RUN getSonLog IN hGenXml (INPUT getStack(), INPUT "OnlyAvaiableBalanceWarehouses", OUTPUT l-saldo-disp).

                           /* Somente depositos Considera Saldo Disponivel MRP*/
                           RUN searchTag IN hGenXml (INPUT "OnlyAvaiableBalanceForMRPWarehouses":U, INPUT getStack(), OUTPUT iId).
                           IF  iId <> ? THEN
                               RUN getSonLog IN hGenXml (INPUT getStack(), INPUT "OnlyAvaiableBalanceForMRPWarehouses", OUTPUT l-saldo-disp-mrp).

                           /* Considera dep¢sitos de produto acabado */
                           RUN searchTag IN hGenXml (INPUT "FinishedProductWarehouse":U, INPUT getStack(), OUTPUT iId).
                           IF  iId <> ? THEN
                               RUN getSonLog IN hGenXml (INPUT getStack(), INPUT "FinishedProductWarehouse", OUTPUT l-dep-prod-aca).

                           /* Considera dep¢sitos de processo */
                           RUN searchTag IN hGenXml (INPUT "ProcessWarehouse":U, INPUT getStack(), OUTPUT iId).
                           IF  iId <> ? THEN
                               RUN getSonLog IN hGenXml (INPUT getStack(), INPUT "ProcessWarehouse", OUTPUT l-dep-processo).

                           /* Considera dep¢sitos de produto reciclado */
                           RUN searchTag IN hGenXml (INPUT "RecycledWarehouse":U, INPUT getStack(), OUTPUT iId).
                           IF  iId <> ? THEN
                               RUN getSonLog IN hGenXml (INPUT getStack(), INPUT "RecycledWarehouse", OUTPUT l-dep-reciclado).

                           /* Considera dep¢sitos de CQ */
                           RUN searchTag IN hGenXml (INPUT "QualityControlWarehouse":U, INPUT getStack(), OUTPUT iId).
                           IF  iId <> ? THEN
                               RUN getSonLog IN hGenXml (INPUT getStack(), INPUT "QualityControlWarehouse", OUTPUT l-dep-cq).

                           /* Considera dep¢sitos de Rejei‡Æo */
                           RUN searchTag IN hGenXml (INPUT "RejectWarehouse":U, INPUT getStack(), OUTPUT iId).
                           IF  iId <> ? THEN
                               RUN getSonLog IN hGenXml (INPUT getStack(), INPUT "RejectWarehouse", OUTPUT l-dep-rejeito).

                           /* Considera dep¢sitos Internos */
                           RUN searchTag IN hGenXml (INPUT "InternalWarehouse":U, INPUT getStack(), OUTPUT iId).
                           IF  iId <> ? THEN
                               RUN getSonLog IN hGenXml (INPUT getStack(), INPUT "InternalWarehouse", OUTPUT l-dep-interno).

                           /* Considera dep¢sitos Externos */
                            /* Considera dep¢sitos Internos */
                           RUN searchTag IN hGenXml (INPUT "ExternalWarehouse":U, INPUT getStack(), OUTPUT iId).
                           IF  iId <> ? THEN
                               RUN getSonLog IN hGenXml (INPUT getStack(), INPUT "ExternalWarehouse", OUTPUT l-dep-externo).

                       delStack().
                   END.

              delStack().
          END.

          /* Localiza‡Æo */
          RUN searchTag IN hGenXml (INPUT "BinLocation", INPUT getStack(), OUTPUT iId).
          IF  iId <> ? THEN DO:
              addStack(iId).
                   RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "InitialBinLocationID", OUTPUT c-cod-localiz-ini).
                   RUN searchTag IN hGenXml (INPUT "FinalBinLocationID":U, INPUT getStack(), OUTPUT iId).
                   IF  iId <> ? THEN
                       RUN getSonVal IN hGenXml (INPUT getStack(), INPUT "FinalBinLocationID", OUTPUT c-cod-localiz-fim).
              delStack().
          END.

          /* Saldo Detalhado */
          RUN searchTag IN hGenXml (INPUT "DetailedBalance", INPUT getStack(), OUTPUT iId).
          IF  iId <> ? THEN
              RUN getSonLog IN hGenXml (INPUT getStack(), INPUT "DetailedBalance", OUTPUT l-saldo-detalhado).

          /* Data Saldo */
          RUN searchTag IN hGenXml (INPUT "BalanceDate", INPUT getStack(), OUTPUT iId).
          IF  iId <> ? THEN
              RUN getSonDate IN hGenXml (INPUT getStack(), INPUT "BalanceDate", OUTPUT d-dt-saldo).

    delStack(). /* Query */   

    /* Define os defaults para as faixas */
    IF c-it-codigo-ini    = ? THEN ASSIGN c-it-codigo-ini   = "".
    IF c-fm-codigo-ini    = ? THEN ASSIGN c-fm-codigo-ini   = "".
    IF i-ge-codigo-ini    = ? THEN ASSIGN i-ge-codigo-ini   = 0.
    IF c-cod-estab-ini    = ? THEN ASSIGN c-cod-estab-ini   = "".
    IF c-cod-depos-ini    = ? THEN ASSIGN c-cod-depos-ini   = "".
    IF c-cod-localiz-ini  = ? THEN ASSIGN c-cod-localiz-ini = "".
    IF c-it-codigo-fim    = ? THEN ASSIGN c-it-codigo-fim   = IF c-it-codigo-ini   <> "" THEN c-it-codigo-ini   ELSE "ZZZZZZZZZZZZZZZZ".
    IF c-fm-codigo-fim    = ? THEN ASSIGN c-fm-codigo-fim   = IF c-fm-codigo-ini   <> "" THEN c-fm-codigo-ini   ELSE "ZZZZZZZZ".
    IF i-ge-codigo-fim    = ? THEN ASSIGN i-ge-codigo-fim   = IF i-ge-codigo-ini   <> 0  THEN i-ge-codigo-ini   ELSE 99.
    &IF "{&mguni_version}" >= "2.071" &THEN
    IF c-cod-estab-fim    = ? THEN ASSIGN c-cod-estab-fim   = IF c-cod-estab-ini   <> "" THEN c-cod-estab-ini   ELSE "ZZZZZ".
    &ELSE
    IF c-cod-estab-fim    = ? THEN ASSIGN c-cod-estab-fim   = IF c-cod-estab-ini   <> "" THEN c-cod-estab-ini   ELSE "ZZZ".
    &ENDIF
    IF c-cod-depos-fim    = ? THEN ASSIGN c-cod-depos-fim   = IF c-cod-depos-ini   <> "" THEN c-cod-depos-ini   ELSE "ZZZ".
    IF c-cod-localiz-fim  = ? THEN ASSIGN c-cod-localiz-fim = IF c-cod-localiz-ini <> "" THEN c-cod-localiz-ini ELSE "ZZZZZZZZZZ".

    /* Data p/ c lculo de saldo retroativo. Quando nÆo informada ou posterior … data corrente, considera data atual */
    IF d-dt-saldo       = ? OR d-dt-saldo > TODAY THEN ASSIGN d-dt-saldo = TODAY.

    /* Cria mensagem com os pedidos encontrados */
    RUN reset       IN hGenXml.
    RUN setEncoding IN hGenXml ("UTF-8":U).

    RUN addNode     IN hGenXml (0, "ListOfItens":U, "":U, OUTPUT iId). 
    addStack(iId).

      IF NOT CAN-FIND(FIRST tt-item) THEN
         FOR EACH  ITEM FIELDS (it-codigo desc-item un tipo-con-est) NO-LOCK 
             WHERE ITEM.it-codigo >= c-it-codigo-ini
               AND ITEM.it-codigo <= c-it-codigo-fim
               AND ITEM.fm-codigo >= c-fm-codigo-ini
               AND ITEM.fm-codigo <= c-fm-codigo-fim
               AND ITEM.ge-codigo >= i-ge-codigo-ini
               AND ITEM.ge-codigo <= i-ge-codigo-fim:

               CREATE tt-item.
               ASSIGN tt-item.it-codigo = ITEM.it-codigo.
         END.

      FOR EACH tt-item NO-LOCK:

          EMPTY TEMP-TABLE tt-saldo NO-ERROR.

          ASSIGN d-tot-saldo-calc  = 0 
                 d-tot-disponivel  = 0
                 d-saldo-disp      = 0
                 d-saldo-calculado = 0.

          FOR FIRST ITEM FIELDS ( it-codigo desc-item un tipo-con-est)
              WHERE ITEM.it-codigo = tt-item.it-codigo NO-LOCK: END.

          if not avail item then next.

          FOR EACH  saldo-estoq NO-LOCK
              WHERE saldo-estoq.it-codigo   =  ITEM.it-codigo
              AND   saldo-estoq.cod-estabel >= c-cod-estab-ini
              AND   saldo-estoq.cod-estabel <= c-cod-estab-fim
              AND   saldo-estoq.cod-depos   >= c-cod-depos-ini
              AND   saldo-estoq.cod-depos   <= c-cod-depos-fim
              AND   saldo-estoq.cod-localiz >= c-cod-localiz-ini
              AND   saldo-estoq.cod-localiz <= c-cod-localiz-fim:

              FOR FIRST deposito FIELDS ( cons-saldo ind-acabado log-reciclagem ind-dep-cq ind-dep-rej 
                                          ind-processo ind-tipo-dep &if defined (bf_man_sfc_lc) &then log-ordens-mrp &else log-1 &endif nome)
                  WHERE deposito.cod-depos = saldo-estoq.cod-depos NO-LOCK: END.

              IF NOT AVAIL deposito
              OR (l-saldo-disp     = TRUE  AND deposito.cons-saldo     = FALSE ) 
              OR (l-saldo-disp-mrp = TRUE  AND {&log-cons-saldo-mrp}   = FALSE )
              OR (l-dep-prod-aca   = FALSE AND deposito.ind-acabado    = TRUE  )
              OR (l-dep-reciclado  = FALSE AND deposito.log-reciclagem = TRUE  )
              OR (l-dep-cq         = FALSE AND deposito.ind-dep-cq     = TRUE  )
              OR (l-dep-rejeito    = FALSE AND deposito.ind-dep-rej    = TRUE  )
              OR (l-dep-processo   = FALSE AND deposito.ind-processo   = TRUE  )
              OR (l-dep-interno    = FALSE AND deposito.ind-tipo-dep   = 1     )
              OR (l-dep-externo    = FALSE AND deposito.ind-tipo-dep   = 2     )
                 THEN NEXT.

              ASSIGN d-saldo-calculado = fn-qtd-data().
                  IF d-saldo-calculado = 0 THEN NEXT.
              ASSIGN d-saldo-disp      = (saldo-estoq.qtidade-atu  -
                                          saldo-estoq.qt-alocada   -
                                          saldo-estoq.qt-aloc-prod -
                                          saldo-estoq.qt-aloc-ped    )
                     d-tot-saldo-calc  = d-tot-saldo-calc  + d-saldo-calculado
                     d-tot-disponivel  = d-tot-disponivel  + d-saldo-disp.

              IF  l-saldo-detalhado THEN DO:

                  /* Localizar descricao do estabelecimento */
                  IF  NOT AVAIL estabelec
                  OR  estabelec.cod-estabel <> saldo-estoq.cod-estabel THEN
                      FOR FIRST estabelec FIELDS (cod-estabel nome)
                          WHERE estabelec.cod-estabel = saldo-estoq.cod-estabel NO-LOCK: END.

                  /* Localizar descricao da localizacao */
                  IF  NOT AVAIL localizacao
                  OR  localizacao.cod-estabel <> saldo-estoq.cod-estabel 
                  OR  localizacao.cod-depos   <> saldo-estoq.cod-depos
                  OR  localizacao.cod-localiz <> saldo-estoq.cod-localiz THEN
                      FOR FIRST localizacao FIELDS (cod-estabel cod-depos cod-localiz descricao) 
                          WHERE localizacao.cod-localiz = saldo-estoq.cod-localiz NO-LOCK: END.

                  CREATE tt-saldo.
                  ASSIGN tt-saldo.cod-estabel   = saldo-estoq.cod-estabel  
                         tt-saldo.cod-depos     = saldo-estoq.cod-depos
                         tt-saldo.cod-localiz   = saldo-estoq.cod-localiz
                         tt-saldo.it-codigo     = saldo-estoq.it-codigo    
                         tt-saldo.cod-refer     = saldo-estoq.cod-refer    
                         tt-saldo.lote          = saldo-estoq.lote
                         tt-saldo.dt-vali-lote  = saldo-estoq.dt-vali-lote
                         tt-saldo.qtidade-atu   = saldo-estoq.qtidade-atu  
                         tt-saldo.qt-alocada    = saldo-estoq.qt-alocada   
                         tt-saldo.qt-aloc-prod  = saldo-estoq.qt-aloc-prod 
                         tt-saldo.qt-aloc-ped   = saldo-estoq.qt-aloc-ped
                         tt-saldo.qt-saldo-data = d-saldo-calculado
                         tt-saldo.qt-saldo-disp = d-saldo-disp
                         tt-saldo.des-depos     = IF AVAIL deposito    THEN deposito.nome        ELSE ""
                         tt-saldo.des-estabel   = IF AVAIL estabelec   THEN estabelec.nome       ELSE ""
                         tt-saldo.des-localiz   = IF AVAIL localizacao THEN localizaca.descricao ELSE "".
              END.
          END.

          RUN addNode IN hGenXml (getStack(), "Item":U, "":U, OUTPUT iId).
          addStack(iId).

              RUN addNode IN hGenXml (getStack(), "ItemCode":U,        ITEM.it-codigo, OUTPUT iId).
              RUN addNode IN hGenXml (getStack(), "ItemDescription":U, ITEM.desc-item, OUTPUT iId).
              RUN addNode IN hGenXml (getStack(), "UnitOfMeasure":U,   "":U,           OUTPUT iId).
              addStack(iId).

                   RUN addNode IN hGenXml (getStack(), "UnitOfMeasureCode":U, ITEM.un, OUTPUT iId).

                   FOR FIRST tab-unidade FIELDS (descricao)
                       WHERE tab-unidade.un = ITEM.un NO-LOCK: END.
                    IF AVAIL tab-unidade THEN
                       RUN addNode IN hGenXml (getStack(), "UnitOfMeasureDescription":U, tab-unidade.descricao, OUTPUT iId).
              delStack().

              RUN addNodeDate IN hGenXml (getStack(), "BalanceDate":U,       d-dt-saldo,       OUTPUT iId).
              RUN addNodeDec  IN hGenXml (getStack(), "TotalQuantity":U,     d-tot-saldo-calc, OUTPUT iId).
              RUN addNodeDec  IN hGenXml (getStack(), "AvailableQuantity":U, d-tot-disponivel, OUTPUT iId).

              IF  l-saldo-detalhado AND CAN-FIND (FIRST tt-saldo) THEN DO:

                  RUN addNode IN hGenXml (getStack(), "ListOfItemBalances":U, "":U, OUTPUT iId).
                  addStack(iId).

                       FOR EACH tt-saldo NO-LOCK:

                            RUN addNode IN hGenXml (getStack(), "ItemBalance":U, "":U, OUTPUT iId).
                            addStack(iId).

                                 RUN addNode IN hGenXml (getStack(), "Site":U, "":U, OUTPUT iId).
                                 addStack(iId).
                                      RUN addNode IN hGenXml (getStack(), "SiteID":U,          tt-saldo.cod-estabel, OUTPUT iId).
                                      RUN addNode IN hGenXml (getStack(), "SiteDescription":U, tt-saldo.des-estabel, OUTPUT iId).
                                 delStack().

                                 RUN addNode IN hGenXml (getStack(), "Warehouse":U, "":U, OUTPUT iId).
                                 addStack(iId).
                                      RUN addNode IN hGenXml (getStack(), "WarehouseID":U,          tt-saldo.cod-depos, OUTPUT iId).
                                      RUN addNode IN hGenXml (getStack(), "WarehouseDescription":U, tt-saldo.des-depos, OUTPUT iId).
                                 delStack().

                                 RUN addNode IN hGenXml (getStack(), "BinLocation":U, "":U, OUTPUT iId).
                                 addStack(iId).
                                      RUN addNode IN hGenXml (getStack(), "BinLocationID":U,          tt-saldo.cod-localiz, OUTPUT iId).
                                      RUN addNode IN hGenXml (getStack(), "BinLocationDescription":U, tt-saldo.des-localiz, OUTPUT iId).
                                 delStack().

                                 RUN addNode     IN hGenXml (getStack(), "LotOrSerialNumber":U,                 tt-saldo.lote,          OUTPUT iId).
                                 RUN addNodeDate IN hGenXml (getStack(), "LotValidityDate":U,                   tt-saldo.dt-vali-lote,  OUTPUT iId).
                                 RUN addNodeDec  IN hGenXml (getStack(), "DateQuantity":U,                      tt-saldo.qt-saldo-data, OUTPUT iId).
                                 RUN addNodeDec  IN hGenXml (getStack(), "CurrentQuantity":U,                   tt-saldo.qtidade-atu,   OUTPUT iId).
                                 RUN addNodeDec  IN hGenXml (getStack(), "AvailableQuantity":U,                 tt-saldo.qt-saldo-disp, OUTPUT iId).
                                 RUN addNodeDec  IN hGenXml (getStack(), "AllocatedQuantity":U,                 tt-saldo.qt-alocada,    OUTPUT iId).
                                 RUN addNodeDec  IN hGenXml (getStack(), "ProductionOrdersAllocatedQuantity":U, tt-saldo.qt-aloc-prod,  OUTPUT iId).
                                 RUN addNodeDec  IN hGenXml (getStack(), "SalesOrdersAllocatedQuantity":U,      tt-saldo.qt-aloc-ped,   OUTPUT iId).
                            delStack().

                       END. /* each salod-estoq */
                  delStack().
              END.

          delStack().

       END. /* each item */

    delStack(). /* List */

    RUN generateXML        IN hGenXml (OUTPUT hBusinessContent). /* gera XML com os itens ncontrados */
    &IF "{&mguni_version}" >= "2.071" &THEN
    RUN sendMessage        IN hMessageHandler (INPUT "ar2/ItemBalance_204_001.xsd":U). 
    &ELSE
    RUN sendMessage        IN hMessageHandler (INPUT "ar2/ItemBalance_204_000.xsd":U). 
    &ENDIF
    RUN getReturnStatus    IN hMessageHandler (OUTPUT pSendSuccess, OUTPUT pTotalErrors).

    IF NOT pSendSuccess THEN DO: /* Erro na gera‡Æo da mensagem de retorno */
       REPEAT iCount = 1 TO pTotalErrors:

          RUN getError IN hMessageHandler (iCount, OUTPUT pErrorNumber, OUTPUT pErrorType, OUTPUT pErrorDesc ).
          CREATE RowErrors.
          ASSIGN RowErrors.ErrorSequence     = iErrorCount + 1
                 RowErrors.ErrorNumber       = pErrorNumber
                 RowErrors.ErrorType         = pErrorType
                 RowErrors.ErrorSubType      = "Error":U
                 RowErrors.ErrorDescription  = SUBSTRING(pErrorDesc,1,2000)
                 RowErrors.ErrorHelp         = SUBSTRING(pErrorDesc,1,20000)
                 iErrorCount                 = iErrorCount + 1.
       END.
    END.

END PROCEDURE.


PROCEDURE receiveMessage:

/*PARAMETERS - BEGIN*/
DEFINE INPUT PARAM hInputXML AS HANDLE NO-UNDO.
DEFINE OUTPUT PARAM hOutputXML AS HANDLE NO-UNDO.
/*PARAMETERS - END*/

     {xmlinc/xmlloadmessagehandlerrec.i &Messagehandler="hMessagehandler" &MHReturnValue="cReturnValue" &MHReturnError="hOutputXML"}

     IF  cReturnValue <> "OK":U THEN 
      IF cReturnValue <> ? AND cReturnValue <> "" THEN 
        RUN setError IN hMessagehandler (INPUT 0,
                                         INPUT "enviroment_error":U,
                                         INPUT cReturnValue).

     RUN parseMessage IN hMessagehandler (INPUT  hInputXml, INPUT "{&XmlTranName}":U, 
                                          INPUT "{&XmlMaxTranVersion}":U, 
                                          INPUT "{&XmlMinTranVersion}":U, 
                                          INPUT "{&XmlListOfEvents}":U,
                                          OUTPUT lSuccessProcess,
                                          OUTPUT cTranAction, 
                                          OUTPUT cTranEvent,
                                          OUTPUT cTranVersion,
                                          OUTPUT hOutputXML ).

     IF NOT lSuccessProcess OR RETURN-VALUE <> "OK":U THEN 
        IF cReturnValue <> ? AND cReturnValue <> " " THEN
           RUN setError IN hMessagehandler (INPUT 0,
                                            INPUT "enviroment_error":U,
                                            INPUT cReturnValue).

     {xmlinc/xmlloadgenxmlrec.i &GenXml="hGenXml" &GXReturnValue="cReturnValue" &GXReturnError="hOutputXML"}

      IF cReturnValue <> "OK":U THEN 
         IF cReturnValue <> ? AND cReturnValue <> "" THEN DO:

            DELETE OBJECT hBusinessContent NO-ERROR.
            RUN setError IN hMessagehandler (INPUT 0,
                                             INPUT "enviroment_error":U,
                                             INPUT cReturnValue).
         END.

      IF cTranAction = "qry":U THEN RUN piQuery.

      FOR EACH RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U : 

          RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber,
                                           INPUT "enviroment_error":U, 
                                           INPUT RowErrors.ErrorDescription).
      END.

      RUN setQueryReturnContent IN hMessageHandler (INPUT hBusinessContent). /* inclui mensagem de retorno no XML */
      RUN getReturnMessage      IN hMessageHandler (OUTPUT hOutputXML). 

END PROCEDURE.

/****** INTERNAL PROCEDURES - END*/




