/********************************************************************************
** Copyright DATASUL S.A. (2014)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0730A 2.00.00.073 } /*** "010073" 17/08/2026 03:18:46 ***/

{include/i-epc200.i im0730a}

&IF "{&EMSFND_VERSION}":U >= "1.00":U &THEN
    {include/i-license-manager.i im0730a MIM}
&ENDIF

{cdp/cdcfgdis.i}
{utp/ut-glob.i}
{utp/utapi019.i} /*** Include API CORREIO ELETR‚NICO ***/
{office/office-defs.i}

{imp/im0730.i}  /* TT Param */
{imp/im0730.i2} /* Include com as TT'S */


DEFINE INPUT  PARAM TABLE FOR tt-param.
DEFINE INPUT  PARAM TABLE FOR tt-pedido-compr.
DEFINE INPUT  PARAM TABLE FOR tt-emitente.
DEFINE INPUT  PARAM TABLE FOR tt-processo-imp.
DEFINE INPUT  PARAM TABLE FOR tt-ordem-compra.
DEFINE INPUT  PARAM TABLE FOR tt-item.
DEFINE INPUT  PARAM TABLE FOR tt-embarque-imp.
DEFINE INPUT  PARAM TABLE FOR tt-ordens-embarque.
DEFINE INPUT  PARAM TABLE FOR tt-prazo-compra.
DEFINE INPUT  PARAM TABLE FOR tt-historico-embarque.
DEFINE INPUT  PARAM TABLE FOR tt-desp-embarque.
DEFINE INPUT  PARAM TABLE FOR tt-embarque-contab.
DEFINE INPUT  PARAM TABLE FOR tt-decla-import.
DEFINE INPUT  PARAM TABLE FOR tt-decla-import-ord.
DEFINE INPUT  PARAM TABLE FOR tt-decla-import-adic.
DEFINE INPUT  PARAM TABLE FOR tt-histor-decla-import.
DEFINE INPUT  PARAM TABLE FOR tt-despes-decla-import.
DEFINE INPUT  PARAM TABLE FOR tt-docum-est.
DEFINE INPUT  PARAM TABLE FOR tt-item-doc-est.
DEFINE INPUT  PARAM TABLE FOR tt-item-doc-est-cex.
DEFINE INPUT  PARAM TABLE FOR tt-rat-lote.
DEFINE INPUT  PARAM TABLE FOR tt-docum-est-cex.
DEFINE INPUT  PARAM TABLE FOR tt-dupli-apagar.
DEFINE INPUT  PARAM TABLE FOR tt-dupli-apagar-cex.
DEFINE INPUT  PARAM TABLE FOR tt-rat-docum.
DEFINE OUTPUT PARAM TABLE FOR tt-documentos-erros.
DEFINE OUTPUT PARAM TABLE FOR tt-documentos-impressos.
DEFINE OUTPUT PARAM TABLE FOR tt-erros-email.

/* Vari†veis excel/relat¢rio acomp */
DEFINE VARIABLE chExcelApplication AS office.iface.excel.ExcelWrapper NO-UNDO.
DEFINE VARIABLE chWorkbook         AS office.iface.excel.Workbook     NO-UNDO.
DEFINE VARIABLE chWorkSheet        AS office.iface.excel.WorkSheet    NO-UNDO.
DEFINE VARIABLE c-layout-padrao     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-arquivo-final     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE h-acomp             AS HANDLE     NO-UNDO.

/* Utilizadas nas leituras e impress∆o */
DEFINE VARIABLE i-linha            AS INTEGER   INIT 3  NO-UNDO.  /* 3 - Linha inicial do layout - linha atual                           */
DEFINE VARIABLE i-linha-ficha      AS INTEGER   INIT 2  NO-UNDO.  /* 2 - Linha Cabeáalho - £ltima linha impressa                         */
DEFINE VARIABLE c-range-subs       AS CHARACTER NO-UNDO.          /* ContÇm o range onde ser† impresso o valor ou pintada a linha        */

/* Usadas para literais e criaá∆o da tt-matriz-ficha e controle de colunas */
DEFINE VARIABLE i-cont              AS INTEGER    NO-UNDO.
DEFINE VARIABLE c-range             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-valor             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i-col               AS INTEGER    NO-UNDO.
DEFINE VARIABLE p-literal           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-alfabeto          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i-alf               AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-alf2              AS INTEGER    NO-UNDO.
DEFINE VARIABLE h-im0730b           AS HANDLE     NO-UNDO.
DEFINE VARIABLE ultima-coluna       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-coluna-formatacao AS CHARACTER  NO-UNDO. /* Armazena a coluna da literal que ser† formatada pela procedure pi-formata-coluna */
DEFINE VARIABLE p-tipo-formatacao   AS CHARACTER  NO-UNDO. /* Armazena o tipo de formaá∆o que a coluna ir† receber */
DEFINE VARIABLE p-alinha-direita    AS LOGICAL    NO-UNDO. /* Yes se for para alinha a os resultados da coluna a direita */
DEFINE VARIABLE l-last-ordem-embarq AS LOGICAL    NO-UNDO. /* Indica se Ç a £ltima ordem de embarque com o n£mero de ordem */
DEFINE VARIABLE l-last-forn         AS LOGICAL    NO-UNDO. /* Indica se Ç o £ltimo fornecedor*/
DEFINE VARIABLE l-somente-embarques           AS LOGICAL NO-UNDO. /* Quando selecionada apenas a opá∆o Embarque de Importaá∆o */
DEFINE VARIABLE l-somente-Fornecedores        AS LOGICAL NO-UNDO. /* Quando selecionada apenas a opá∆o Fornecedor */
DEFINE VARIABLE l-somente-embarques-pedidos   AS LOGICAL NO-UNDO. /* Quando selecionada apenas as opá‰es Embarques e Pedidos */
DEFINE VARIABLE l-somente-embarques-processos AS LOGICAL NO-UNDO. /* Quando selecionada apenas as opá‰es Embarques e Processos */
DEFINE VARIABLE l-somente-embarques-docs      AS LOGICAL NO-UNDO. /* Quando selecionada apenas as opá‰es Embarques e Documentos */

/* V A R I µ V E I S   G E R A I S */
DEFINE VARIABLE c-arquivo              AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-layout               AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-cont-aux             AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-lb-sim               AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-nao               AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-tent                 AS INTEGER   NO-UNDO.
DEFINE VARIABLE h-cdapi995             AS HANDLE    NO-UNDO.
DEFINE VARIABLE de-aliquota-pis        AS DEC FORMAT ">>9.9999" NO-UNDO.
DEFINE VARIABLE de-aliquota-cofins     AS DEC FORMAT ">>9.9999" NO-UNDO.

DEFINE VARIABLE c-liter-traduc-ordem-embarque    AS CHAR NO-UNDO.
DEFINE VARIABLE c-liter-traduc-hist-embarque     AS CHAR NO-UNDO.
DEFINE VARIABLE c-liter-traduc-desp-embarque     AS CHAR NO-UNDO.
DEFINE VARIABLE c-liter-traduc-rat-doc           AS CHAR NO-UNDO.
DEFINE VARIABLE c-liter-traduc-ajust-coluns      AS CHAR NO-UNDO.
DEFINE VARIABLE c-liter-traduc-cria-arq          AS CHAR NO-UNDO.
DEFINE VARIABLE c-liter-traduc-ordem-compra      AS CHAR NO-UNDO.
DEFINE VARIABLE c-liter-traduc-ficha-matriz      AS CHAR NO-UNDO.
DEFINE VARIABLE c-liter-traduc-process-imp       AS CHAR NO-UNDO.
DEFINE VARIABLE c-liter-traduc-arq-doc           AS CHAR NO-UNDO.
DEFINE VARIABLE c-liter-traduc-itens-doc         AS CHAR NO-UNDO.
DEFINE VARIABLE c-liter-traduc-arq-emb-impres    AS CHAR NO-UNDO.
DEFINE VARIABLE c-liter-traduc-arq-ordens-impres AS CHAR NO-UNDO.

{utp/ut-liter.i "Sim" *}
ASSIGN c-lb-sim = RETURN-VALUE.
{utp/ut-liter.i "N∆o" *}
ASSIGN c-lb-nao = RETURN-VALUE.

{utp/ut-liter.i "Criando_Arquivo_Ordens_Embarque"}
ASSIGN c-liter-traduc-ordem-embarque = RETURN-VALUE.

{utp/ut-liter.i "Criando_Arquivo_Hist_Embarque"}
ASSIGN c-liter-traduc-hist-embarque = RETURN-VALUE.

{utp/ut-liter.i "Criando_Arquivo_Desp_Embarque"}
ASSIGN c-liter-traduc-desp-embarque = RETURN-VALUE.

{utp/ut-liter.i "Criando_Arquivo_-_Rat_Documento"}
ASSIGN c-liter-traduc-rat-doc = RETURN-VALUE.

{utp/ut-liter.i "Ajustes_das_Colunas"}
ASSIGN c-liter-traduc-ajust-coluns = RETURN-VALUE.

{utp/ut-liter.i "Criando_Colunas_Excel"}
ASSIGN c-liter-traduc-cria-arq = RETURN-VALUE.

{utp/ut-liter.i "Criando_Arquivo_Ordem_Compra"}
ASSIGN c-liter-traduc-ordem-compra = RETURN-VALUE.

{utp/ut-liter.i "Criando_Arquivo_-_Ficha_Matriz"}
ASSIGN c-liter-traduc-ficha-matriz = RETURN-VALUE.

{utp/ut-liter.i "Processo_Importaá∆o: "}
ASSIGN c-liter-traduc-process-imp = RETURN-VALUE.

{utp/ut-liter.i "Criando_Arquivo_Documento"}
ASSIGN c-liter-traduc-arq-doc = RETURN-VALUE.

{utp/ut-liter.i "Criando_Arquivo_Itens_Documento"}
ASSIGN c-liter-traduc-itens-doc = RETURN-VALUE.

{utp/ut-liter.i "Criando_Arquivo_Embarque_Impress∆o"}
ASSIGN c-liter-traduc-arq-emb-impres = RETURN-VALUE.

{utp/ut-liter.i "Criando_Arquivo_Ordens_Impress∆o"}
ASSIGN c-liter-traduc-arq-ordens-impres = RETURN-VALUE.

FOR FIRST tt-param NO-LOCK: END.
/*Somente opá∆o Embarque de Importaá∆o selecionada*/
ASSIGN l-somente-embarques = tt-param.lEmbarqueImp AND
                             NOT tt-param.lPedidoCompra AND
                             NOT tt-param.lProcessoImp AND
                             NOT tt-param.lFornecedor AND
                             NOT tt-param.lOrdemCompra AND
                             NOT tt-param.lDeclaImport AND
                             NOT tt-param.lDocumentos.
/* Quando selecionada apenas as opá‰es Embarques e Processos */
ASSIGN l-somente-embarques-processos = tt-param.lEmbarqueImp AND
                                       tt-param.lProcessoImp AND
                                       NOT tt-param.lPedidoCompra AND
                                       NOT tt-param.lOrdemCompra AND
                                       NOT tt-param.lDeclaImport AND
                                       NOT tt-param.lDocumentos.
/* Quando selecionada apenas as opá‰es Embarques e Pedidos */
ASSIGN l-somente-embarques-pedidos  = tt-param.lEmbarqueImp AND
                                      tt-param.lPedidoCompra AND
                                      NOT tt-param.lProcessoImp AND
                                      NOT tt-param.lOrdemCompra AND
                                      NOT tt-param.lDeclaImport AND
                                      NOT tt-param.lDocumentos.
/* Quando selecionada apenas a opá∆o Fornecedor */
ASSIGN l-somente-Fornecedores       = tt-param.lFornecedor AND
                                      NOT tt-param.lEmbarqueImp AND
                                      NOT tt-param.lPedidoCompra AND
                                      NOT tt-param.lProcessoImp AND
                                      NOT tt-param.lOrdemCompra AND
                                      NOT tt-param.lDeclaImport AND
                                      NOT tt-param.lDocumentos.
/* Quando selecionada apenas as opá‰es Embarques e Documentos */
ASSIGN l-somente-embarques-docs = tt-param.lEmbarqueImp AND
                                  tt-param.lDocumentos AND
                                  NOT tt-param.lOrdemCompra AND
                                  NOT tt-param.lDeclaImport AND
                                  NOT tt-param.lItensDoc.

/* Verifica qual layout ir† utilizar */
ASSIGN c-arquivo = "IM0730GerencialImportacao":U
       c-layout  = "im0730-layout":U.

ASSIGN c-layout-padrao = tt-param.cLayoutPadrao.
ASSIGN c-layout-padrao =  IF LENGTH (c-layout-padrao) > 3 AND SUBSTR(c-layout-padrao, LENGTH(c-layout-padrao), 1) <> "~\":U
                          THEN (c-layout-padrao + "~\":U)
                          ELSE c-layout-padrao.

ASSIGN c-layout-padrao = c-layout-padrao + c-layout + ".xlsx":U
       c-layout-padrao =  REPLACE ( c-layout-padrao , "/":U , "~\":U ).

IF SEARCH(c-layout-padrao) = ? THEN
    ASSIGN c-layout-padrao = SEARCH("imp/":U + c-layout + ".xlsx":U).

IF SEARCH(c-layout-padrao) = ? THEN DO:
    CREATE tt-documentos-erros.

    RUN utp/ut-msgs.p (input "msg":U,
                       INPUT 4715,
                       INPUT c-layout-padrao).

    ASSIGN tt-documentos-erros.nr-mensag   =  "4715":U
           tt-documentos-erros.mensagem    =  TRIM(RETURN-VALUE).
    RETURN "NOK":U.
END.
ASSIGN c-arquivo-final = if LENGTH (tt-param.cDestinoArq) > 3 and SUBSTR(tt-param.cDestinoArq, LENGTH(tt-param.cDestinoArq), 1) <> "~\":U
                                  THEN (tt-param.cDestinoArq + "~\":U)
                                  ELSE tt-param.cDestinoArq.

ASSIGN c-arquivo-final = c-arquivo-final + c-arquivo + ".xlsx":U
       c-arquivo-final = REPLACE ( c-arquivo-final , "/":U , "~\":U ).

IF NOT tt-param.lSobreporArq  THEN DO:
    bloco:
    REPEAT WHILE SEARCH(c-arquivo-final) <> ? AND i-cont-aux < 20:
        ASSIGN i-cont-aux = i-cont-aux + 1
               c-arquivo       = "IM0730GerencialImportacao":U
               c-arquivo       = c-arquivo + string(i-cont-aux)
               c-arquivo-final = if LENGTH (tt-param.cDestinoArq) > 3 and SUBSTR(tt-param.cDestinoArq, LENGTH(tt-param.cDestinoArq), 1) <> "~\":U
                                            THEN (tt-param.cDestinoArq + "~\":U)
                                            ELSE tt-param.cDestinoArq
               c-arquivo-final = c-arquivo-final + c-arquivo + ".xlsx":U
               c-arquivo-final = REPLACE ( c-arquivo-final , "/":U , "~\":U ).

        IF SEARCH(c-arquivo-final) = ? THEN LEAVE bloco.
    END.
END.

FOR EACH tt-docum-est-rat:
    DELETE tt-docum-est-rat.
END.

RUN pi-processa.

PROCEDURE pi-processa:
/*------------------------------------------------------------------------------
  Purpose:     Efetua o processamento do relat¢rio.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    RUN piValidaEmail.
    IF RETURN-VALUE <> "OK":U THEN
        RETURN "NOK":U.

    RUN pi-inicializaExcel.
    RUN pi-valida-documento.

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    {utp/ut-liter.i "Criando_Planilha"}
    RUN pi-inicializar IN h-acomp (INPUT TRIM(RETURN-VALUE)).
    RUN pi-desabilita-cancela IN h-acomp.
    {utp/ut-liter.i "Criando_Planilha"}
    RUN pi-acompanhar IN h-acomp (INPUT STRING(RETURN-VALUE + "...":U)).

    FOR FIRST tt-documentos-erros NO-LOCK:

        /* Fecha planilha e limpa objetos */
        ASSIGN chExcelApplication:VISIBLE = NO.
        chWorkbook:CLOSE().
        chExcelApplication:APPLICATION:QUIT().

        DELETE OBJECT chExcelApplication NO-ERROR.
        DELETE OBJECT chWorkbook         NO-ERROR.
        DELETE OBJECT chWorkSheet        NO-ERROR.

        RUN pi-finalizar IN h-acomp.

        IF VALID-HANDLE(h-acomp) THEN DO:
            DELETE PROCEDURE h-acomp.
            ASSIGN h-acomp = ?.
        END.

        RETURN "NOK":U.
    END.
	IF NOT VALID-HANDLE(h-cdapi995) THEN
        RUN cdp/cdapi995.p PERSISTENT SET h-cdapi995.

    IF  NOT AVAIL param-imp THEN
        FIND FIRST param-imp NO-LOCK NO-ERROR.

    /* Se n∆o existirem erros continua a execuá∆o */
    RUN pi-traduz-literais-formata-colunas. /* Substitui as vari†veis literais e executa a criaá∆o da tt-matriz-ficha */
    RUN pi-gera-dados-importacao.

    CREATE tt-documentos-impressos.
    ASSIGN tt-documentos-impressos.destino = c-arquivo-final.

    {utp/ut-liter.i "Criando_Arquivo"}
    RUN pi-acompanhar IN h-acomp (INPUT STRING(RETURN-VALUE + "...":U)).
    RUN pi-insere-borda.
    RUN pi-autofit-columns.

    RUN pi-finalizaExcel (INPUT c-arquivo-final,
                          INPUT tt-param.destino,
                          INPUT tt-param.iDestinoExcel).

    IF  tt-param.lEnviaDocto THEN DO:
        {utp/ut-liter.i "Enviando_E-mail"}
        RUN pi-acompanhar IN h-acomp (INPUT STRING(RETURN-VALUE + "...":U)).
        RUN pi-envia-email.
    END.

    RUN pi-finalizar IN h-acomp.

    IF  VALID-HANDLE(h-acomp) THEN DO:
        DELETE PROCEDURE h-acomp.
        ASSIGN h-acomp = ?.
    END.

    IF VALID-HANDLE(h-cdapi995) THEN DO:
        DELETE PROCEDURE h-cdapi995.
        ASSIGN h-cdapi995 = ?.
	END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-inicializaExcel:
/*------------------------------------------------------------------------------
  Purpose:     Inicializa o handle da planilha.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    {office/office.i Excel chExcelApplication}

    chExcelApplication:DisplayAlerts  = FALSE.
    chExcelApplication:VISIBLE        = FALSE.
    chExcelApplication:ScreenUpdating = FALSE.

    chWorkbook = chExcelApplication:Workbooks:OPEN(c-layout-padrao).

    RETURN "OK":U.
END PROCEDURE.

/* ContÇm a l¢gica para a traduá∆o das literais do Excel */
PROCEDURE pi-traduz-literais-formata-colunas:
/*------------------------------------------------------------------------------
  Purpose:     Efetua a traduá∆o das literais da planilha e formata as colunas.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE l-literal       AS LOGICAL NO-UNDO.
    DEFINE VARIABLE l-literal-espec AS LOGICAL NO-UNDO.

    ASSIGN c-alfabeto = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z":U.

    REPEAT i-alf = 1 TO 26:
        REPEAT i-alf2 = 1 TO 26:
            ASSIGN c-alfabeto = c-alfabeto + ",":U + ENTRY(i-alf, c-alfabeto, ",":U) + ENTRY(i-alf2, c-alfabeto, ",":U).
        END.
    END.

    RUN imp/im0730b.p PERSISTENT SET h-im0730b. /* ContÇm a traduá∆o das literais do Excel */

    EMPTY TEMP-TABLE tt-matriz-ficha.

    main:
    REPEAT:
        ASSIGN i-cont = i-cont + 1
               c-range = 'A':U + STRING(i-cont).

        chExcelApplication:Range(c-range):SELECT() NO-ERROR.
        ASSIGN c-valor = STRING(chExcelApplication:Range(c-range):VALUE) NO-ERROR.

        IF (c-valor = ? OR c-valor = "":U) AND i-cont >= 3 THEN LEAVE main.

        IF  c-valor MATCHES "*#lit-*":U THEN DO:

            ASSIGN i-col = 1.

            bloco_traducao:
            REPEAT:

                ASSIGN l-literal = YES
                       c-range   = ENTRY(i-col,c-alfabeto,',':U) + '2':U     /* i-col Ç a coluna (Ex: A, B, C, AB, BC, CD)   */
                       c-coluna-formatacao = ENTRY(i-col,c-alfabeto,',':U).

                chExcelApplication:Range(c-range):SELECT() NO-ERROR.
                ASSIGN c-valor = STRING(chExcelApplication:Range(c-range):VALUE) NO-ERROR.

                IF  TRIM(c-valor) = ? OR TRIM(c-valor) = "":U THEN
                    LEAVE bloco_traducao.

                ASSIGN p-literal = ?.
                /*somente entra na procedure para traduá∆o das literais para as vari†veis padr‰es.
                  para as espec°ficas entra no bloco quando a p-literal = ? */
                IF  NOT TRIM(c-valor) MATCHES "*var-espec*":U THEN DO:
                    RUN pi-traduz-literais IN h-im0730b (INPUT TRIM(c-valor), INPUT TABLE tt-param, OUTPUT p-literal, OUTPUT p-tipo-formatacao, OUTPUT p-alinha-direita).
                END.

                IF  p-literal <> ? AND p-literal <> '':U THEN DO:
                    chExcelApplication:Range(c-range):VALUE = p-literal.

                    IF  p-tipo-formatacao <> ? AND p-tipo-formatacao <> "":U THEN
                        chExcelApplication:Range(c-coluna-formatacao + ":":U + c-coluna-formatacao):NumberFormat = p-tipo-formatacao. /* Formata a coluna */

                    IF  p-alinha-direita THEN
                        chExcelApplication:Range(c-coluna-formatacao + ":":U + c-coluna-formatacao):HorizontalAlignment = -4152.
                END.
                ELSE DO:
                    ASSIGN l-literal       = NO
                           l-literal-espec = NO.
                    IF  TRIM(c-valor) MATCHES "*var-espec*":U THEN DO:

                        IF tt-param.lPedidoCompra     AND TRIM(SUBSTRING(c-valor,1,17)) = "#lit-pc-var-espec":U  THEN ASSIGN l-literal-espec = YES.
                        IF tt-param.lFornecedor       AND TRIM(SUBSTRING(c-valor,1,18)) = "#lit-for-var-espec":U THEN ASSIGN l-literal-espec = YES.
                        IF tt-param.lProcessoImp      AND TRIM(SUBSTRING(c-valor,1,17)) = "#lit-pi-var-espec":U  THEN ASSIGN l-literal-espec = YES.
                        IF tt-param.lOrdemCompra      AND TRIM(SUBSTRING(c-valor,1,17)) = "#lit-oc-var-espec":U  THEN ASSIGN l-literal-espec = YES.
                        IF tt-param.lItem             AND TRIM(SUBSTRING(c-valor,1,17)) = "#lit-it-var-espec":U  THEN ASSIGN l-literal-espec = YES.
                        IF tt-param.lEmbarqueImp      AND TRIM(SUBSTRING(c-valor,1,18)) = "#lit-emb-var-espec":U THEN ASSIGN l-literal-espec = YES.
                        IF tt-param.lParcelas         AND TRIM(SUBSTRING(c-valor,1,18)) = "#lit-par-var-espec":U THEN ASSIGN l-literal-espec = YES.
                        IF tt-param.lAcompEmb         AND TRIM(SUBSTRING(c-valor,1,17)) = "#lit-he-var-espec":U  THEN ASSIGN l-literal-espec = YES.
                        IF tt-param.lAcompEmb         AND TRIM(SUBSTRING(c-valor,1,17)) = "#lit-de-var-espec":U  THEN ASSIGN l-literal-espec = YES.
                        IF tt-param.lDeclaImport      AND TRIM(SUBSTRING(c-valor,1,17)) = "#lit-di-var-espec":U  THEN ASSIGN l-literal-espec = YES.
                        IF tt-param.lAdicoesDI        AND TRIM(SUBSTRING(c-valor,1,18)) = "#lit-adi-var-espec":U THEN ASSIGN l-literal-espec = YES.
                        IF tt-param.lDeclaImport      AND TRIM(SUBSTRING(c-valor,1,18)) = "#lit-odi-var-espec":U THEN ASSIGN l-literal-espec = YES.
                        IF tt-param.lAcompDI          AND TRIM(SUBSTRING(c-valor,1,18)) = "#lit-hdi-var-espec":U THEN ASSIGN l-literal-espec = YES.
                        IF tt-param.lAcompDI          AND TRIM(SUBSTRING(c-valor,1,18)) = "#lit-ddi-var-espec":U THEN ASSIGN l-literal-espec = YES.
                        IF tt-param.lDocumentos       AND TRIM(SUBSTRING(c-valor,1,18)) = "#lit-doc-var-espec":U THEN ASSIGN l-literal-espec = YES.
                        IF tt-param.lItensDoc         AND TRIM(SUBSTRING(c-valor,1,18)) = "#lit-itd-var-espec":U THEN ASSIGN l-literal-espec = YES.
                        IF tt-param.lDespItemDoc      AND TRIM(SUBSTRING(c-valor,1,18)) = "#lit-did-var-espec":U THEN ASSIGN l-literal-espec = YES.
                        IF tt-param.lMovtoEstoq       AND TRIM(SUBSTRING(c-valor,1,18)) = "#lit-lot-var-espec":U THEN ASSIGN l-literal-espec = YES.
                        IF tt-param.lDespImp          AND TRIM(SUBSTRING(c-valor,1,18)) = "#lit-des-var-espec":U THEN ASSIGN l-literal-espec = YES.
                        IF tt-param.lDuplicatas       AND TRIM(SUBSTRING(c-valor,1,18)) = "#lit-dup-var-espec":U THEN ASSIGN l-literal-espec = YES.
                        IF tt-param.lDupDespesas      AND TRIM(SUBSTRING(c-valor,1,18)) = "#lit-dpd-var-espec":U THEN ASSIGN l-literal-espec = YES.
                        IF tt-param.lMaterialTransito AND TRIM(SUBSTRING(c-valor,1,17)) = "#lit-mt-var-espec":U  THEN ASSIGN l-literal-espec = YES.

                        IF  l-literal-espec THEN DO:
                            RUN pi-literais-espec (INPUT  TRIM(c-valor),
                                                   OUTPUT l-literal).
                            IF  NOT l-literal THEN
                                ASSIGN l-literal = l-literal-espec.
                        END.
                    END.
                END.

                RUN pi-cria-tt-matriz-ficha (INPUT l-literal).

                ASSIGN i-col = i-col + 1.
            END.
        END.
    END.

    IF VALID-HANDLE(h-im0730b) THEN DO:
        DELETE PROCEDURE h-im0730b.
        ASSIGN h-im0730b = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-cria-tt-matriz-ficha.
/*------------------------------------------------------------------------------
  Purpose:     Cria TT matriz com as informaá‰es da coluna.
  Parameters:  p-l-literal: Indica se a literal foi traduzida (logical).
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-l-literal AS LOGICAL NO-UNDO.

    ASSIGN c-range = ENTRY(i-col,c-alfabeto,',':U) + '3':U. /* '3' =  ? a terceira linha (Ex: A'3', B'3', C'3')
                                                        // i-col Ç a coluna (Ex: A, B, C, AB, BC, CD) */
    ASSIGN ultima-coluna = ENTRY(i-col,c-alfabeto,',':U).

    CREATE tt-matriz-ficha.
    ASSIGN tt-matriz-ficha.c-linha  = TRIM(STRING(chExcelApplication:Range(c-range):VALUE))
           tt-matriz-ficha.c-column = ENTRY(i-col,c-alfabeto,',':U)
           tt-matriz-ficha.l-oculto = NOT p-l-literal.

    ASSIGN chExcelApplication:Range(c-range):VALUE = "".

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-insere-borda:
/*------------------------------------------------------------------------------
  Purpose:     Insere as bordas na planilha.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-linha-borda  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-total-linhas AS INTEGER     NO-UNDO.

    ASSIGN i-total-linhas = i-linha-ficha.

    chExcelApplication:Range("A3:":U + ultima-coluna + STRING(i-total-linhas)):SELECT.
    chExcelApplication:SELECTION:Borders(5):LineStyle = -4142.
    chExcelApplication:SELECTION:Borders(6):LineStyle = -4142.

    chExcelApplication:SELECTION:Borders(7):LineStyle = 1.
    chExcelApplication:SELECTION:Borders(7):ColorIndex = -4105.

    chExcelApplication:SELECTION:Borders(8):LineStyle = 1.
    chExcelApplication:SELECTION:Borders(8):ColorIndex = -4105.

    chExcelApplication:SELECTION:Borders(9):LineStyle = 1.
    chExcelApplication:SELECTION:Borders(9):ColorIndex = -4105.

    chExcelApplication:SELECTION:Borders(10):LineStyle = 1.
    chExcelApplication:SELECTION:Borders(10):ColorIndex = -4105.

    chExcelApplication:SELECTION:Borders(11):LineStyle = 1.
    chExcelApplication:SELECTION:Borders(11):ColorIndex = -4105.

    chExcelApplication:SELECTION:Borders(12):LineStyle = 1.
    chExcelApplication:SELECTION:Borders(12):ColorIndex = -4105.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-autofit-columns:
/*------------------------------------------------------------------------------
  Purpose:     Redimensiona a coluna ou esconde caso a literal n∆o possa ser
               traduzida.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    FOR EACH tt-matriz-ficha:
        chExcelApplication:Range(tt-matriz-ficha.c-column + ":":U + tt-matriz-ficha.c-column):SELECT.
        IF tt-matriz-ficha.l-oculto THEN
            chExcelApplication:SELECTION:EntireColumn:HIDDEN = TRUE. /* Pega a coluna corrente -> ENTRY(i-col,c-alfabeto,',') e oculta */
        ELSE
            chExcelApplication:SELECTION:EntireColumn:AutoFit().
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-envia-email:
/*------------------------------------------------------------------------------
  Purpose:     Executa o envio de e-mail com a planilha em anexo
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    FOR FIRST param-global NO-LOCK: END.

    DEFINE VARIABLE c-remetente     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-assunto-email AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-utapi019      AS HANDLE      NO-UNDO.

    {utp/ut-liter.i Enviado_do_Relat¢rio_Gerencial_de_Importaá∆o }
    ASSIGN c-assunto-email = TRIM(RETURN-VALUE).

    RUN utp/utapi019.p PERSISTENT SET h-utapi019. /* Para enviar e-mail */

    FOR FIRST usuar_mestre FIELDS(cod_e_mail_local) NO-LOCK
        WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren:
        assign c-remetente = trim(usuar_mestre.cod_e_mail_local).
    END.

    FOR FIRST param_email NO-LOCK: END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.exchange          = param_email.log_servid_exchange   WHEN AVAIL param_email
           tt-envio2.servidor          = param_email.cod_servid_e_mail     WHEN AVAIL param_email
           tt-envio2.porta             = param_email.num_porta             WHEN AVAIL param_email
           tt-envio2.destino           = tt-param.cDestinatario
           tt-envio2.assunto           = c-assunto-email
           tt-envio2.remetente         = c-remetente
           tt-envio2.mensagem          = "":U
           tt-envio2.importancia       = 1
           tt-envio2.log-enviada       = YES
           tt-envio2.log-lida          = NO
           tt-envio2.acomp             = NO
           tt-envio2.arq-anexo         = c-arquivo-final.

    RUN pi-execute2 IN h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).

    if  return-value = "NOK":U then do:
        for each tt-erros:
            CREATE tt-erros-email.
            ASSIGN tt-erros-email.codigo    = tt-erros.cod-erro
                   tt-erros-email.descricao = tt-erros.desc-erro.
        end.
    end.

    IF VALID-HANDLE(h-utapi019) THEN DO:
        DELETE PROCEDURE h-utapi019.
        ASSIGN h-utapi019 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piValidaEmail:
/*------------------------------------------------------------------------------
  Purpose:     Valida se usu†rio possui e-mail cadastrado
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-usuario      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-destinatario AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-msg          AS CHARACTER   NO-UNDO.
    {utp/ut-liter.i Usu†rio}
    ASSIGN c-usuario = TRIM(RETURN-VALUE).
    {utp/ut-liter.i Destinat†rio}
    ASSIGN c-destinatario = TRIM(RETURN-VALUE).

    IF tt-param.lEnviaDocto THEN DO:
        /*Valida Remetente*/
        FOR FIRST usuar_mestre FIELDS(cod_usuario cod_e_mail_local) NO-LOCK
            WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren:
           if usuar_mestre.cod_e_mail_local = " ":U then do:

                run utp/ut-msgs.p (input "msg":U,
                                   input 26337,
                                   input string(c-usuario) + "~~":U + string(usuar_mestre.cod_usuario)).
                ASSIGN c-msg = TRIM(RETURN-VALUE).

                run utp/ut-msgs.p (input "help":U,
                                   input 26337,
                                   input string(c-usuario) + "~~":U + string(usuar_mestre.cod_usuario)).
                ASSIGN c-msg = c-msg + " " + TRIM(RETURN-VALUE).

                CREATE tt-erros-email.
                ASSIGN tt-erros-email.codigo    =  26337
                       tt-erros-email.descricao =  c-msg.
           end.
        END.

        /*Valida Destinat†rio*/
        IF tt-param.cDestinatario = " ":U THEN DO:
            run utp/ut-msgs.p (input "msg":U,
                               input 3553,
                               input c-destinatario).
            ASSIGN c-msg = TRIM(RETURN-VALUE).

            run utp/ut-msgs.p (input "help":U,
                               input 3553,
                               input c-destinatario).
            ASSIGN c-msg = c-msg + " " + TRIM(RETURN-VALUE).

            CREATE tt-erros-email.
            ASSIGN tt-erros-email.codigo    =  3553
                   tt-erros-email.descricao =  c-msg.
        END.

        IF CAN-FIND (FIRST tt-erros-email) THEN
            RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-valida-documento:
/*------------------------------------------------------------------------------
  Purpose:     Verifica se o arquivo j† existe e emite mensagem de erro caso n∆o
               esteja marcado para sobrepor as informaá‰es
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-msg-erro AS CHARACTER   NO-UNDO.
    IF SEARCH(c-arquivo-final) <> ? AND (NOT tt-param.lSobreporArq) THEN DO:

        RUN utp/ut-msgs.p (input "msg":U,
                           INPUT 5455,
                           INPUT c-arquivo-final).

        ASSIGN c-msg-erro = RETURN-VALUE.

        CREATE tt-documentos-erros.
        ASSIGN tt-documentos-erros.nr-mensag   =  "5455":U
               tt-documentos-erros.mensagem    =  c-msg-erro.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-finalizaExcel:
/*------------------------------------------------------------------------------
  Purpose:     Finaliza as configuraá‰es do arquivo de planilha
  Parameters:  pcNomeArqLayout: Nome do arquivo (character)
               piDestino: Destino do relat¢rio de acompanhamento (integer)
                          1 - Impressora,
                          2 - Arquivo,
                          3 - Terminal.
               piDestinoExcel: Destino da planilha (integer)
                               1 - Terminal,
                               2 - Arquivo.
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pcNomeArqLayout AS CHAR NO-UNDO.
    DEFINE INPUT PARAM piDestino       AS INT  NO-UNDO.
    DEFINE INPUT PARAM piDestinoExcel  AS INT  NO-UNDO.

    DEFINE VARIABLE cNomeArqLayoutXML AS CHARACTER   NO-UNDO.

    ASSIGN cNomeArqLayoutXML = SUBSTRING ( pcNomeArqLayout , 1, LENGTH(pcNomeArqLayout) - 5 )  /* Retira a extens∆o do arquivo e o ponto (.xlsx)  */
           cNomeArqLayoutXML = cNomeArqLayoutXML + ".xml":U.                                     /* Adiciona a extens∆o do arquivo e o ponto (.xml) */

    /*------- Controla Destino do Excel -------------*/
    IF  piDestino = 1 THEN DO:
        chExcelApplication:Sheets:PrintOut().
        chExcelApplication:APPLICATION:DisplayAlerts = FALSE.
        chExcelApplication:QUIT().
        IF  VALID-OBJECT(chExcelApplication) THEN
            DELETE OBJECT chExcelApplication NO-ERROR.
    END.

    IF  piDestino = 2 OR (piDestino = 3 AND piDestinoExcel = 2) THEN DO:
        chExcelApplication:APPLICATION:DisplayAlerts = False.
        chWorkbook:SaveAs(pcNomeArqLayout,1,"":U,"":U,NO,NO,NO).
        chExcelApplication:APPLICATION:QUIT().
        IF  VALID-OBJECT(chExcelApplication) THEN
            DELETE OBJECT chExcelApplication NO-ERROR.
    END.

    IF  piDestino = 3 AND piDestinoExcel = 1 THEN DO:

        ASSIGN chExcelApplication:VISIBLE = NO.
        chWorkbook:SaveAs(pcNomeArqLayout,?,?,?,?,?,?) NO-ERROR.
        chWorkbook:CLOSE().
        chExcelApplication:APPLICATION:QUIT().


        DELETE OBJECT chExcelApplication NO-ERROR.
        DELETE OBJECT chWorkbook         NO-ERROR.
        DELETE OBJECT chWorkSheet        NO-ERROR.

        RUN pi-abre-arquivo-final.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-abre-arquivo-final:
/*------------------------------------------------------------------------------
  Purpose:     Abre o arquivo de planilha ap¢s a geraá∆o.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    {office/office.i Excel chExcelApplication}

    chWorkbook = chExcelApplication:Workbooks:OPEN(c-arquivo-final) NO-ERROR.
    chExcelApplication:VISIBLE = YES NO-ERROR.
    chExcelApplication:ScreenUpdating = TRUE NO-ERROR.

    DELETE OBJECT chExcelApplication NO-ERROR.
    DELETE OBJECT chWorkbook         NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-epc:
/*------------------------------------------------------------------------------
  Purpose:     Imprime no arquivo a informaá∆o customizada.
  Parameters:  p-cod-event: identificador da customizaá∆o (character).
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-event AS CHARACTER   NO-UNDO.

    FOR EACH tt-epc WHERE tt-epc.cod-event = p-cod-event:
        IF  tt-matriz-ficha.c-linha MATCHES(tt-epc.cod-parameter) THEN
            RUN pi-imprime-campos-char(INPUT tt-epc.val-parameter).
    END.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-campos-char:
/*------------------------------------------------------------------------------
  Purpose:     Imprime informaá∆o do tipo caracter.
  Parameters:  c-campo: Valor a ser impresso (character).
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER c-campo AS CHARACTER   NO-UNDO.

    ASSIGN c-range-subs = tt-matriz-ficha.c-column + STRING(i-linha)
           i-tent       = 0.
    DO WHILE i-tent < 5:
        chExcelApplication:Range(c-range-subs):SELECT() NO-ERROR.
        chExcelApplication:Range(c-range-subs):VALUE = trim(c-campo) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            ASSIGN i-tent = i-tent + 1.
            PROCESS EVENTS.
            PAUSE 0.5.
        END.
        ELSE LEAVE.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-imprime-campos-int:
/*------------------------------------------------------------------------------
  Purpose:     Imprime informaá∆o do tipo inteiro.
  Parameters:  i-campo: Valor a ser impresso (integer).
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER i-campo AS INTEGER     NO-UNDO.

    IF i-campo <> ? THEN DO:
        ASSIGN c-range-subs = tt-matriz-ficha.c-column + STRING(i-linha)
               i-tent       = 0.
        DO WHILE i-tent < 5:
            chExcelApplication:Range(c-range-subs):SELECT() NO-ERROR.
            chExcelApplication:Range(c-range-subs):SetValue(i-campo) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                ASSIGN i-tent = i-tent + 1.
                PROCESS EVENTS.
                PAUSE 1.
            END.
            ELSE DO:
                LEAVE.
            END.
        END.
    END.
    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-imprime-campos-dec:
/*------------------------------------------------------------------------------
  Purpose:     Imprime informaá∆o do tipo decimal.
  Parameters:  de-campo: Valor a ser impresso (decimal).
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER de-campo AS DECIMAL NO-UNDO.

    IF de-campo <> ? THEN DO:
        ASSIGN c-range-subs = tt-matriz-ficha.c-column + STRING(i-linha)
               i-tent       = 0.
        DO WHILE i-tent < 5:
            chExcelApplication:Range(c-range-subs):SELECT() NO-ERROR.
            chExcelApplication:Range(c-range-subs):SetValue(de-campo) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                ASSIGN i-tent = i-tent + 1.
                PROCESS EVENTS.
                PAUSE 0.5.
            END.
            ELSE LEAVE.
        END.
    END.
    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-imprime-campos-date:
/*------------------------------------------------------------------------------
  Purpose:     Imprime informaá∆o do tipo data.
  Parameters:  d-campo: Valor a ser impresso (date).
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER d-campo AS CHAR FORMAT "99/99/9999":U NO-UNDO.

    IF d-campo <> ? THEN DO:
        ASSIGN c-range-subs = tt-matriz-ficha.c-column + STRING(i-linha)
               i-tent       = 0.
        DO WHILE i-tent < 5:
            chExcelApplication:Range(c-range-subs):SELECT() NO-ERROR.
            chExcelApplication:Range(c-range-subs):VALUE = d-campo NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                ASSIGN
                    i-tent = i-tent + 1
                    .
                PROCESS EVENTS.
                PAUSE 0.5.
            END.
            ELSE LEAVE.
        END.
    END.
    ELSE
        RUN pi-imprime-campos-char(INPUT "":U).

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-imprime-campos-log:
/*------------------------------------------------------------------------------
  Purpose:     Imprime informaá∆o do tipo l¢gico.
  Parameters:  l-campo: Valor a ser impresso (logical).
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER l-campo AS LOGICAL NO-UNDO.

    ASSIGN c-range-subs = tt-matriz-ficha.c-column + STRING(i-linha)
           i-tent       = 0.
    DO WHILE i-tent < 5:
        chExcelApplication:Range(c-range-subs):SELECT() NO-ERROR.
        chExcelApplication:Range(c-range-subs):VALUE = IF l-campo THEN c-lb-sim ELSE c-lb-nao NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            ASSIGN
                i-tent = i-tent + 1
                .
            PROCESS EVENTS.
            PAUSE 0.5.
        END.
        ELSE LEAVE.
    END.
    RETURN "OK":U.
END PROCEDURE.


/*************************************************************************************************************************************************/
                                                     /* Bloco principal - Leitura dos dados */
/*************************************************************************************************************************************************/
/* Procedure Impress∆o Chaves Tabelas */
PROCEDURE pi-imprime-chave:
/*------------------------------------------------------------------------------
  Purpose:     Imprime as informaá‰es chave das tabelas.
  Parameters:  p-i-nivel-tabela: N°vel das informaá‰es (integer).
                                 1 - Processo de Importaá∆o - Pedido de Compra - Fornecedor
                                 2 - Ordem de Compra - Item
                                 3 - Declaraá∆o de Importaá∆o
                                 4 - Hist¢rico da DI
                                 5 - Adiá‰es da DI
                                 6 - Embarque de Importaá∆o
                                 7 - Hist¢rico Embarque
                                 8 - Documento
                                 9 - Item Documento.
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-i-nivel-tabela AS INTEGER   NO-UNDO.

    IF p-i-nivel-tabela >= 1 THEN DO:
        IF tt-param.lProcessoImp  AND AVAIL tt-processo-imp  THEN RUN pi-imprime-ficha (INPUT "processo-imp":U, INPUT YES, INPUT "":U).
        IF tt-param.lPedidoCompra AND AVAIL tt-pedido-compr  THEN RUN pi-imprime-ficha (INPUT "pedido-compr":U, INPUT YES, INPUT "":U).
        IF tt-param.lFornecedor   AND AVAIL tt-emitente      THEN RUN pi-imprime-ficha (INPUT "emitente":U,     INPUT YES, INPUT "":U).
    END.
    IF p-i-nivel-tabela >= 2 THEN DO:
        IF tt-param.lOrdemCompra AND AVAIL tt-ordem-compra THEN RUN pi-imprime-ficha (INPUT "ordem-compra":U, INPUT YES, INPUT "":U).
        IF tt-param.lItem        AND AVAIL tt-item         THEN RUN pi-imprime-ficha (INPUT "item":U,         INPUT YES, INPUT "":U).
    END.
    IF p-i-nivel-tabela >= 3 THEN
        IF tt-param.lDeclaImport AND AVAIL tt-decla-import        THEN RUN pi-imprime-ficha (INPUT "decla-import":U, INPUT YES, INPUT "":U).
    IF p-i-nivel-tabela =  4 THEN
        IF tt-param.lAcompDI     AND AVAIL tt-histor-decla-import THEN RUN pi-imprime-ficha (INPUT "histor-decla-import":U, INPUT YES, INPUT "":U).
    IF p-i-nivel-tabela >= 5 THEN DO:
        IF tt-param.lAdicoesDI   AND AVAIL tt-decla-import-adic   THEN RUN pi-imprime-ficha (INPUT "decla-import-adic":U,  INPUT YES, INPUT "":U).
        IF tt-param.lDeclaImport AND AVAIL tt-decla-import-ord    THEN RUN pi-imprime-ficha (INPUT "decla-import-ord":U, INPUT YES, INPUT "":U).
    END.
    IF p-i-nivel-tabela >= 6 THEN
        IF tt-param.lEmbarqueImp AND AVAIL tt-embarque-imp       THEN RUN pi-imprime-ficha (INPUT "embarque-imp":U,       INPUT YES, INPUT "":U).
    IF p-i-nivel-tabela =  7 THEN
        IF tt-param.lAcompEmb    AND AVAIL tt-historico-embarque THEN RUN pi-imprime-ficha (INPUT "historico-embarque":U, INPUT YES, INPUT "":U).
    IF p-i-nivel-tabela >=  8 THEN
        IF tt-param.lDocumentos  AND AVAIL tt-docum-est          THEN RUN pi-imprime-ficha (INPUT "docum-est":U,    INPUT YES, INPUT "":U).
    IF p-i-nivel-tabela >=  9 THEN
        IF tt-param.lItensDoc    AND AVAIL tt-item-doc-est       THEN RUN pi-imprime-ficha (INPUT "item-doc-est":U, INPUT YES, INPUT "":U).

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-imprime-ficha:
/*------------------------------------------------------------------------------
  Purpose:     Imprime as imformaá‰es na planilha
  Parameters:  c-tabela: Tabela onde est† a informaá∆o que est† sendo impressa (character)
               l-chave: Indica se imprime somente as informaá‰es chave da tabela (logical)
               c-rowid: Rowid da tabela (character)
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER c-tabela    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER l-chave     AS LOGICAL   NO-UNDO.
    DEFINE INPUT PARAMETER c-rowid     AS CHARACTER NO-UNDO.

    DEFINE VARIABLE c-prefixo-var      AS CHARACTER NO-UNDO.

    /* Atualiza £ltima linha impressa */
    ASSIGN i-linha-ficha = i-linha.

    CASE c-tabela:
        WHEN "processo-imp":U        THEN ASSIGN c-prefixo-var = "#pi-":U.
        WHEN "pedido-compr":U        THEN ASSIGN c-prefixo-var = "#pc-":U.
        WHEN "emitente":U            THEN ASSIGN c-prefixo-var = "#for-":U.
        WHEN "ordem-compra":U        THEN ASSIGN c-prefixo-var = "#oc-":U.
        WHEN "item":U                THEN ASSIGN c-prefixo-var = "#it-":U.
        WHEN "embarque-imp":U        THEN ASSIGN c-prefixo-var = "#emb-":U.
        WHEN "prazo-compra":U        THEN ASSIGN c-prefixo-var = "#par-":U.
        WHEN "historico-embarque":U  THEN ASSIGN c-prefixo-var = "#he-":U.
        WHEN "desp-embarque":U       THEN ASSIGN c-prefixo-var = "#de-":U.
        WHEN "decla-import":U        THEN ASSIGN c-prefixo-var = "#di-":U.
        WHEN "decla-import-adic":U   THEN ASSIGN c-prefixo-var = "#adi-":U.
        WHEN "decla-import-ord":U    THEN ASSIGN c-prefixo-var = "#odi-":U.
        WHEN "histor-decla-import":U THEN ASSIGN c-prefixo-var = "#hdi-":U.
        WHEN "despes-decla-import":U THEN ASSIGN c-prefixo-var = "#ddi-":U.
        WHEN "docum-est":U           THEN ASSIGN c-prefixo-var = "#doc-":U.
        WHEN "item-doc-est":U        THEN ASSIGN c-prefixo-var = "#itd-":U.
        WHEN "item-doc-est-cex":U    THEN ASSIGN c-prefixo-var = "#did-":U.
        WHEN "rat-lote":U            THEN ASSIGN c-prefixo-var = "#lot-":U.
        WHEN "docum-est-cex":U       THEN ASSIGN c-prefixo-var = "#des-":U.
        WHEN "dupli-apagar":U        THEN ASSIGN c-prefixo-var = "#dup-":U.
        WHEN "dupli-apagar-cex":U    THEN ASSIGN c-prefixo-var = "#dpd-":U.
        WHEN "embarque-contab":U     THEN ASSIGN c-prefixo-var = "#mt-":U.
    END CASE.

    IF NOT l-chave THEN DO:
         IF CAN-FIND(FIRST tt-matriz-ficha
                     WHERE tt-matriz-ficha.c-linha BEGINS (c-prefixo-var + "var-espec":U) ) THEN DO:

             FOR EACH tt-epc EXCLUSIVE-LOCK
                 WHERE tt-epc.cod-event = "Custom-Fields-tt-":U + c-tabela:
                 DELETE tt-epc.
             END.

             {include/i-epc200.i2 &CodEvent='"Custom-Fields-tt-' + c-tabela + '"'
                                  &CodParameter='"rowid-' + c-tabela + '"'
                                  &ValueParameter="c-rowid"}

             CASE c-tabela:
                 WHEN "processo-imp":U        THEN DO: {include/i-epc201.i "Custom-Fields-tt-processo-imp"}        END.
                 WHEN "pedido-compr":U        THEN DO: {include/i-epc201.i "Custom-Fields-tt-pedido-compr"}        END.
                 WHEN "emitente":U            THEN DO: {include/i-epc201.i "Custom-Fields-tt-emitente"}            END.
                 WHEN "ordem-compra":U        THEN DO: {include/i-epc201.i "Custom-Fields-tt-ordem-compra"}        END.
                 WHEN "item":U                THEN DO: {include/i-epc201.i "Custom-Fields-tt-item"}                END.
                 WHEN "embarque-imp":U        THEN DO: {include/i-epc201.i "Custom-Fields-tt-embarque-imp"}        END.
                 WHEN "prazo-compra":U        THEN DO: {include/i-epc201.i "Custom-Fields-tt-prazo-compra"}        END.
                 WHEN "historico-embarque":U  THEN DO: {include/i-epc201.i "Custom-Fields-tt-historico-embarque"}  END.
                 WHEN "desp-embarque":U       THEN DO: {include/i-epc201.i "Custom-Fields-tt-desp-embarque"}       END.
                 WHEN "decla-import":U        THEN DO: {include/i-epc201.i "Custom-Fields-tt-decla-import"}        END.
                 WHEN "decla-import-adic":U   THEN DO: {include/i-epc201.i "Custom-Fields-tt-decla-import-adic"}   END.
                 WHEN "decla-import-ord":U    THEN DO: {include/i-epc201.i "Custom-Fields-tt-decla-import-ord"}    END.
                 WHEN "histor-decla-import":U THEN DO: {include/i-epc201.i "Custom-Fields-tt-histor-decla-import"} END.
                 WHEN "despes-decla-import":U THEN DO: {include/i-epc201.i "Custom-Fields-tt-despes-decla-import"} END.
                 WHEN "docum-est":U           THEN DO: {include/i-epc201.i "Custom-Fields-tt-docum-est"}           END.
                 WHEN "item-doc-est":U        THEN DO: {include/i-epc201.i "Custom-Fields-tt-item-doc-est"}        END.
                 WHEN "item-doc-est-cex":U    THEN DO: {include/i-epc201.i "Custom-Fields-tt-item-doc-est-cex"}    END.
                 WHEN "rat-lote":U            THEN DO: {include/i-epc201.i "Custom-Fields-tt-rat-lote"}            END.
                 WHEN "docum-est-cex":U       THEN DO: {include/i-epc201.i "Custom-Fields-tt-docum-est-cex"}       END.
                 WHEN "dupli-apagar":U        THEN DO: {include/i-epc201.i "Custom-Fields-tt-dupli-apagar"}        END.
                 WHEN "dupli-apagar-cex":U    THEN DO: {include/i-epc201.i "Custom-Fields-tt-dupli-apagar-cex"}    END.
                 WHEN "embarque-contab":U     THEN DO: {include/i-epc201.i "Custom-Fields-tt-embarque-contab"}     END.
             END CASE.
         END.
    END.

    FOR EACH tt-matriz-ficha
        WHERE tt-matriz-ficha.c-linha BEGINS (c-prefixo-var)
          AND NOT tt-matriz-ficha.l-oculto:

        IF NOT tt-matriz-ficha.c-linha BEGINS (c-prefixo-var + "var-espec":U) THEN
            RUN pi-imprime-campos (INPUT c-tabela,
                                   INPUT l-chave).

        IF NOT l-chave THEN DO:
            IF  CAN-FIND(FIRST tt-epc WHERE tt-epc.cod-event = "Custom-Fields-tt-":U + c-tabela)
            AND tt-matriz-ficha.c-linha BEGINS (c-prefixo-var + "var-espec":U) THEN RUN pi-imprime-epc(INPUT "Custom-Fields-tt-":U + c-tabela).
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* ================== Processo de Importaá∆o ================== */
PROCEDURE pi-gera-dados-importacao:
/*------------------------------------------------------------------------------
  Purpose:     Imprime as informaá‰es do processo de importaá∆o
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE BUFFER bf-tt-emitente FOR tt-emitente.

    ASSIGN i-linha       = 3  /* 3 Ç o n£mero da linha inicial do layout - Linha atual */
           i-linha-ficha = 2. /* Linha cabeáalho - £ltima linha impressa */

    FOR EACH tt-processo-imp NO-LOCK
        BREAK BY tt-processo-imp.cod-estabel
              BY tt-processo-imp.nr-proc-imp:

        RUN pi-acompanhar IN h-acomp (INPUT STRING(c-liter-traduc-process-imp + TRIM(tt-processo-imp.cod-estabel + "/" + tt-processo-imp.nr-proc-imp))).

        IF tt-param.lProcessoImp THEN DO:
            RUN pi-imprime-ficha (INPUT "processo-imp":U,
                                  INPUT NO,
                                  INPUT STRING(tt-processo-imp.r-rowid)).
        END.

        /* Geraá∆o dados Pedido/Ordem de Compra */
        RUN pi-gera-pedido-compr (INPUT tt-processo-imp.num-pedido).

        /*Quando marcado apenas fornecedores*/
        IF l-somente-fornecedores THEN DO:
            ASSIGN l-last-forn = YES.
            FOR EACH bf-tt-emitente:
                IF NOT CAN-FIND(FIRST tt-emitente-impresso
                                WHERE tt-emitente-impresso.cod-emitente = bf-tt-emitente.cod-emitente) THEN
                    ASSIGN l-last-forn = NO.
            END.
            IF NOT l-last-forn THEN
                ASSIGN i-linha = i-linha-ficha + 1.
        END.
        ELSE
            ASSIGN i-linha = i-linha-ficha + 1.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* ================== Pedido/Ordem de Compra ================== */
PROCEDURE pi-gera-pedido-compr:
/*------------------------------------------------------------------------------
  Purpose:     Imprime as informaá‰es do pedido de compra.
  Parameters:  p-num-pedido: N£mero do pedido de compra (integer).
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-num-pedido LIKE pedido-compr.num-pedido NO-UNDO.

    IF l-somente-embarques-processos OR
       l-somente-embarques-pedidos OR (l-somente-embarques-docs AND
                                      (tt-param.lProcessoImp OR tt-param.lPedidoCompra)) THEN
        EMPTY TEMP-TABLE tt-embarque-impresso NO-ERROR.

    FOR FIRST tt-pedido-compr NO-LOCK
        WHERE tt-pedido-compr.num-pedido = p-num-pedido:

        IF  tt-param.lPedidoCompra THEN DO:
            RUN pi-imprime-ficha (INPUT "pedido-compr":U,
                                  INPUT NO,
                                  INPUT STRING(tt-pedido-compr.r-rowid)).
        END.

        IF  tt-param.lFornecedor THEN DO:
            FOR FIRST tt-emitente NO-LOCK
                WHERE tt-emitente.cod-emitente = tt-pedido-compr.cod-emitente:
                IF  l-somente-fornecedores THEN DO:
                    IF NOT CAN-FIND(FIRST tt-emitente-impresso
                                    WHERE tt-emitente-impresso.cod-emitente = tt-emitente.cod-emitente) THEN DO:
                        CREATE tt-emitente-impresso.
                        ASSIGN tt-emitente-impresso.cod-emitente = tt-emitente.cod-emitente.
                        RUN pi-imprime-ficha (INPUT "emitente":U,
                                              INPUT NO,
                                              INPUT STRING(tt-emitente.r-rowid)).
                    END.
                END.
                ELSE
                    RUN pi-imprime-ficha (INPUT "emitente":U,
                                          INPUT NO,
                                          INPUT STRING(tt-emitente.r-rowid)).
            END.
        END.
    END.

    IF tt-param.lOrdemCompra
    OR tt-param.lDeclaImport
    OR tt-param.lEmbarqueImp
    OR tt-param.lDocumentos THEN DO:

        FOR EACH tt-ordem-compra NO-LOCK
            WHERE tt-ordem-compra.num-pedido = p-num-pedido
            BREAK BY tt-ordem-compra.num-pedido:

            RUN pi-acompanhar IN h-acomp (INPUT STRING(c-liter-traduc-ordem-compra + " - " + TRIM(STRING(tt-ordem-compra.num-pedido)) + " - " + TRIM(STRING(tt-ordem-compra.it-codigo)))).

            /* Imprime Chave Tabelas */
            IF  NOT FIRST-OF(tt-ordem-compra.num-pedido) THEN RUN pi-imprime-chave (INPUT 1).

            IF  tt-param.lOrdemCompra THEN RUN pi-imprime-ficha (INPUT "ordem-compra":U,
                                      INPUT NO,
                                      INPUT STRING(tt-ordem-compra.r-rowid)).

            IF tt-param.lItem THEN DO:
                FOR FIRST tt-item NO-LOCK
                    WHERE tt-item.it-codigo = tt-ordem-compra.it-codigo:
                    RUN pi-imprime-ficha (INPUT "item":U,
                                          INPUT NO,
                                          INPUT STRING(tt-item.r-rowid)).
                END.
            END.

            /* Geraá∆o dados Declaraá∆o Importaá∆o */
            IF  tt-param.lDeclaImport THEN RUN pi-gera-decla-import (INPUT tt-ordem-compra.numero-ordem).

            /* Geraá∆o dados Embarque */
            IF NOT tt-param.lDeclaImport
            OR (   tt-param.lDeclaImport
               AND NOT CAN-FIND (FIRST tt-decla-import-ord
                                 WHERE tt-decla-import-ord.num-ordem = tt-ordem-compra.numero-ordem)) THEN RUN pi-gera-embarque (INPUT tt-ordem-compra.numero-ordem,
                                      INPUT ?,
                                      INPUT YES).

            IF NOT l-somente-embarques-processos AND
               NOT l-somente-embarques-pedidos AND
               NOT l-somente-embarques-docs AND
               NOT l-somente-embarques AND
               NOT LAST-OF (tt-ordem-compra.num-pedido) THEN
                ASSIGN i-linha = i-linha-ficha + 1.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* ================== Declaraá∆o Importaá∆o ================== */
PROCEDURE pi-gera-decla-import:
/*------------------------------------------------------------------------------
  Purpose:     Imprime as informaá‰es de declaraá∆o de importaá∆o.
  Parameters:  p-numero-ordem: N£mero da ordem de compra (integer).
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-numero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

    FOR EACH tt-decla-import-ord NO-LOCK
        WHERE tt-decla-import-ord.num-ordem = p-numero-ordem
        BREAK BY tt-decla-import-ord.num-ordem
              BY tt-decla-import-ord.num-di-ems
              BY tt-decla-import-ord.num-adic
              BY tt-decla-import-ord.cod-estab
              BY tt-decla-import-ord.cod-embarq:

        FOR FIRST tt-decla-import WHERE tt-decla-import.num-di-ems       = tt-decla-import-ord.num-di-ems
                                  AND   tt-decla-import.cdd-siscomex-dts = tt-decla-import-ord.cdd-siscomex-dts
                                  NO-LOCK:
        END.


        IF NOT CAN-FIND(FIRST tt-decla-import-imp WHERE tt-decla-import-imp.num-di-ems       = tt-decla-import-ord.num-di-ems
                                                  AND   tt-decla-import-imp.cdd-siscomex-dts = tt-decla-import-ord.cdd-siscomex-dts) THEN DO:
            RUN pi-imprime-chave (INPUT 2).
            RUN pi-imprime-ficha (INPUT "decla-import":U,
                                  INPUT NO,
                                  INPUT STRING(tt-decla-import.r-rowid)).
            /* grava que esta DI j† foi impressa */
            CREATE tt-decla-import-imp.
            ASSIGN tt-decla-import-imp.num-di-ems       = tt-decla-import-ord.num-di-ems
                   tt-decla-import-imp.cdd-siscomex-dts = tt-decla-import-ord.cdd-siscomex-dts.

            IF  tt-param.lAcompDI THEN DO:
                FOR EACH tt-histor-decla-import NO-LOCK
                    WHERE tt-histor-decla-import.num-di-ems       = tt-decla-import.num-di-ems
                    AND   tt-histor-decla-import.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts
                    BREAK BY tt-histor-decla-import.num-di-ems
                          BY tt-histor-decla-import.cdn-pto-control:

                    IF NOT CAN-FIND(FIRST tt-histor-decla-import-imp
                                        WHERE tt-histor-decla-import-imp.num-di-ems       = tt-histor-decla-import.num-di-ems
                                        AND   tt-histor-decla-import-imp.cdd-siscomex-dts = tt-histor-decla-import.cdd-siscomex-dts
                                        AND   tt-histor-decla-import-imp.num-seq          = tt-histor-decla-import.num-seq) THEN DO:
                        IF NOT FIRST-OF(tt-histor-decla-import.num-di-ems) THEN
                            RUN pi-imprime-chave (INPUT 3).
                        RUN pi-imprime-ficha (INPUT "histor-decla-import":U,
                                              INPUT NO,
                                              INPUT STRING(tt-histor-decla-import.r-rowid)).
                        CREATE tt-histor-decla-import-imp.
                        ASSIGN tt-histor-decla-import-imp.num-di-ems       = tt-histor-decla-import.num-di-ems
                               tt-histor-decla-import-imp.cdd-siscomex-dts = tt-histor-decla-import.cdd-siscomex-dts
                               tt-histor-decla-import-imp.num-seq          = tt-histor-decla-import.num-seq.
                    END.

                    FOR EACH tt-despes-decla-import NO-LOCK
                        WHERE tt-despes-decla-import.num-di-ems       = tt-histor-decla-import.num-di-ems
                          AND tt-despes-decla-import.cdd-siscomex-dts = tt-histor-decla-import.cdd-siscomex-dts
                          AND tt-despes-decla-import.cdn-pto-control  = tt-histor-decla-import.cdn-pto-control
                        BREAK BY tt-despes-decla-import.cdn-pto-control:

                        IF NOT CAN-FIND(FIRST tt-despes-decla-import-imp
                                            WHERE tt-despes-decla-import-imp.num-di-ems       = tt-despes-decla-import.num-di-ems
                                            AND   tt-despes-decla-import-imp.cdd-siscomex-dts = tt-despes-decla-import.cdd-siscomex-dts
                                            AND   tt-despes-decla-import-imp.cdn-pto-control  = tt-despes-decla-import.cdn-pto-control
                                            AND   tt-despes-decla-import-imp.cdn-despes       = tt-despes-decla-import.cdn-despes
                                            AND   tt-despes-decla-import-imp.cdn-emit-despes  = tt-despes-decla-import.cdn-emit-despes) THEN DO:
                            IF NOT FIRST-OF(tt-despes-decla-import.cdn-pto-control) THEN
                                RUN pi-imprime-chave (INPUT 4).
                            RUN pi-imprime-ficha (INPUT "despes-decla-import":U,
                                                  INPUT NO,
                                                  INPUT STRING(tt-despes-decla-import.r-rowid)).
                            CREATE tt-despes-decla-import-imp.
                            ASSIGN tt-despes-decla-import-imp.num-di-ems       = tt-despes-decla-import.num-di-ems
                                   tt-despes-decla-import-imp.cdd-siscomex-dts = tt-despes-decla-import.cdd-siscomex-dts
                                   tt-despes-decla-import-imp.cdn-pto-control  = tt-despes-decla-import.cdn-pto-control
                                   tt-despes-decla-import-imp.cdn-despes       = tt-despes-decla-import.cdn-despes
                                   tt-despes-decla-import-imp.cdn-emit-despes  = tt-despes-decla-import.cdn-emit-despes.
                        END.

                        IF NOT LAST(tt-despes-decla-import.cdn-pto-control) THEN
                            ASSIGN i-linha = i-linha-ficha + 1.
                    END.
                    ASSIGN i-linha = i-linha-ficha + 1.
                END.
            END.
        END.

        RUN pi-imprime-chave (INPUT 3).
        RUN pi-imprime-ficha (INPUT "decla-import-ord":U,
                              INPUT NO,
                              INPUT STRING(tt-decla-import-ord.r-rowid)).

        IF tt-param.lAdicoesDI AND tt-decla-import-ord.num-adic <> 0 THEN DO:
            FOR FIRST tt-decla-import-adic NO-LOCK
                WHERE tt-decla-import-adic.num-di-ems = tt-decla-import-ord.num-di-ems
                  AND tt-decla-import-adic.cdd-siscomex-dts = tt-decla-import-ord.cdd-siscomex-dts
                  AND tt-decla-import-adic.num-adic   = tt-decla-import-ord.num-adic:


                IF NOT CAN-FIND(FIRST tt-decla-import-adic-imp
                                    WHERE tt-decla-import-adic-imp.num-di-ems = tt-decla-import-adic.num-di-ems
                                    AND   tt-decla-import-adic-imp.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts
                                    AND   tt-decla-import-adic-imp.num-adic   = tt-decla-import-adic.num-adic) THEN DO:
                    CREATE tt-decla-import-adic-imp.
                    ASSIGN tt-decla-import-adic-imp.num-di-ems = tt-decla-import-adic.num-di-ems
                           tt-decla-import-adic-imp.cdd-siscomex-dts = tt-decla-import-adic.cdd-siscomex-dts
                           tt-decla-import-adic-imp.num-adic   = tt-decla-import-adic.num-adic.
                    RUN pi-imprime-ficha (INPUT "decla-import-adic":U,
                                          INPUT NO,
                                          INPUT STRING(tt-decla-import-adic.r-rowid)).
                END.
                ELSE DO:
                    RUN pi-imprime-ficha (INPUT "decla-import-adic":U,
                                          INPUT YES,
                                          INPUT STRING(tt-decla-import-adic.r-rowid)).
                END.
            END.
        END.

        /* Geraá∆o dados Embarque */
        RUN pi-gera-embarque (INPUT tt-decla-import-ord.num-ordem,
                              INPUT tt-decla-import-ord.num-parcela,
                              INPUT (LAST-OF(tt-decla-import-ord.cod-estab)  OR LAST-OF(tt-decla-import-ord.cod-embarq))).

        IF NOT l-somente-embarques-processos AND
           NOT l-somente-embarques-pedidos AND
           NOT l-somente-embarques-docs AND
           NOT LAST-OF (tt-decla-import-ord.num-ordem) THEN
            ASSIGN i-linha = i-linha-ficha + 1.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* ================== Embarque de Importaá∆o ================== */
PROCEDURE pi-gera-embarque:
/*------------------------------------------------------------------------------
  Purpose:     Imprime as informaá‰es de embarque
  Parameters:  p-numero-ordem: N£mero da ordem de compra (integer)
               p-parcela: N£mero da parcela (integer)
               l-last-of: Indica se Ç o £ltimo embarque (integer)
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-numero-ordem LIKE ordens-embarque.numero-ordem NO-UNDO.
    DEFINE INPUT PARAM p-parcela      LIKE ordens-embarque.parcela      NO-UNDO.
    DEFINE INPUT PARAM l-last-of      AS   LOGICAL                      NO-UNDO.

    DEFINE BUFFER bf-tt-item-doc-est    FOR tt-item-doc-est.
    DEFINE BUFFER bf-tt-embarque-imp    FOR tt-embarque-imp.
    DEFINE BUFFER bf-tt-processo-imp    FOR tt-processo-imp.
    DEFINE BUFFER bf-tt-pedido-compr    FOR tt-pedido-compr.
    DEFINE BUFFER bf-tt-ordens-embarque FOR tt-ordens-embarque.

    DEFINE VARIABLE l-imprime-embarque       AS LOGICAL NO-UNDO.
    DEFINE VARIABLE l-imprime-acomp-embarque AS LOGICAL NO-UNDO.
    DEFINE VARIABLE l-last-embarque          AS LOGICAL NO-UNDO.
    DEFINE VARIABLE l-chave                  AS LOGICAL NO-UNDO.
    DEFINE VARIABLE l-imprime                AS LOGICAL NO-UNDO.
    DEFINE VARIABLE l-ordem-multipl-embarq   AS LOGICAL NO-UNDO.

    FOR EACH tt-ordens-embarque NO-LOCK
        WHERE tt-ordens-embarque.numero-ordem = p-numero-ordem
         AND (tt-ordens-embarque.parcela      = p-parcela OR p-parcela = ?)
        BREAK BY tt-ordens-embarque.numero-ordem
              BY tt-ordens-embarque.cod-estabel
              BY tt-ordens-embarque.embarque:

        RUN pi-acompanhar IN h-acomp (INPUT STRING(c-liter-traduc-ordem-embarque + " - " + TRIM(STRING(tt-ordens-embarque.numero-ordem)) + " - " + TRIM(STRING(tt-ordens-embarque.embarque)))).

        ASSIGN l-last-ordem-embarq = LAST-OF(tt-ordens-embarque.numero-ordem)
               l-imprime-acomp-embarque = NO
               l-imprime-embarque  = NO.

        IF tt-param.lEmbarqueImp THEN DO:
            FOR FIRST tt-embarque-imp NO-LOCK
                WHERE tt-embarque-imp.cod-estabel = tt-ordens-embarque.cod-estabel
                  AND tt-embarque-imp.embarque    = tt-ordens-embarque.embarque:
            END.
             ASSIGN l-chave = NO.
            /*Tratamento quando apenas a opá∆o Embarque de Importaá∆o est† selecionada
              Impress∆o do embarque apenas uma vez*/
            IF l-somente-embarques OR (l-somente-embarques-docs AND NOT tt-param.lProcessoImp AND NOT tt-param.lPedidoCompra) THEN DO:
                IF NOT CAN-FIND(FIRST tt-embarque-impresso
                                WHERE tt-embarque-impresso.cod-estabel = tt-embarque-imp.cod-estabel
                                  AND tt-embarque-impresso.embarque    = tt-embarque-imp.embarque) THEN DO:
                    ASSIGN l-imprime-embarque = YES.
                    CREATE tt-embarque-impresso.
                    ASSIGN tt-embarque-impresso.cod-estabel = tt-embarque-imp.cod-estabel
                           tt-embarque-impresso.embarque    = tt-embarque-imp.embarque.
                END.
            END.
            ELSE DO:
                IF  (FIRST-OF (tt-ordens-embarque.cod-estabel) OR
                     FIRST-OF (tt-ordens-embarque.embarque)) THEN DO:

                    IF NOT CAN-FIND(FIRST tt-embarque-impresso
                                    WHERE tt-embarque-impresso.cod-estabel = tt-embarque-imp.cod-estabel
                                      AND tt-embarque-impresso.embarque    = tt-embarque-imp.embarque) THEN DO:
                        ASSIGN l-imprime-embarque = YES.
                        CREATE tt-embarque-impresso.
                        ASSIGN tt-embarque-impresso.cod-estabel        = tt-embarque-imp.cod-estabel
                               tt-embarque-impresso.embarque           = tt-embarque-imp.embarque
                               tt-embarque-impresso.cod-estab-proc-imp = tt-processo-imp.cod-estabel
                               tt-embarque-impresso.nr-proc-imp        = tt-processo-imp.nr-proc-imp
                               tt-embarque-impresso.num-pedido         = tt-pedido-compr.num-pedido.
                    END.
                    ELSE DO:
                        ASSIGN l-chave = YES.
                        IF l-somente-embarques-processos OR (l-somente-embarques-docs AND tt-param.lProcessoImp) THEN DO:
                            IF NOT CAN-FIND(FIRST tt-embarque-impresso
                                    WHERE tt-embarque-impresso.cod-estabel        = tt-embarque-imp.cod-estabel
                                      AND tt-embarque-impresso.embarque           = tt-embarque-imp.embarque
                                      AND tt-embarque-impresso.cod-estab-proc-imp = tt-processo-imp.cod-estabel
                                      AND tt-embarque-impresso.nr-proc-imp        = tt-processo-imp.nr-proc-imp) THEN DO:
                                ASSIGN l-imprime-embarque = YES.
                                CREATE tt-embarque-impresso.
                                ASSIGN tt-embarque-impresso.cod-estabel        = tt-embarque-imp.cod-estabel
                                       tt-embarque-impresso.embarque           = tt-embarque-imp.embarque
                                       tt-embarque-impresso.cod-estab-proc-imp = tt-processo-imp.cod-estabel
                                       tt-embarque-impresso.nr-proc-imp        = tt-processo-imp.nr-proc-imp
                                       tt-embarque-impresso.num-pedido         = tt-pedido-compr.num-pedido.
                            END.
                        END.
                        ELSE IF l-somente-embarques-pedidos OR (l-somente-embarques-docs AND tt-param.lPedidoCompra) THEN DO:
                            IF NOT CAN-FIND(FIRST tt-embarque-impresso
                                    WHERE tt-embarque-impresso.cod-estabel        = tt-embarque-imp.cod-estabel
                                      AND tt-embarque-impresso.embarque           = tt-embarque-imp.embarque
                                      AND tt-embarque-impresso.num-pedido         = tt-pedido-compr.num-pedido) THEN DO:
                                ASSIGN l-imprime-embarque = YES.
                                CREATE tt-embarque-impresso.
                                ASSIGN tt-embarque-impresso.cod-estabel        = tt-embarque-imp.cod-estabel
                                       tt-embarque-impresso.embarque           = tt-embarque-imp.embarque
                                       tt-embarque-impresso.cod-estab-proc-imp = tt-processo-imp.cod-estabel
                                       tt-embarque-impresso.nr-proc-imp        = tt-processo-imp.nr-proc-imp
                                       tt-embarque-impresso.num-pedido         = tt-pedido-compr.num-pedido.
                            END.
                        END.
                        ELSE
                            ASSIGN l-imprime-embarque = YES.
                    END.
                END.
            END.

            IF l-imprime-embarque THEN DO:
                IF NOT CAN-FIND(FIRST tt-ord-emb-impresso
                                WHERE tt-ord-emb-impresso.cod-estabel = tt-ordens-embarque.cod-estabel
                                  AND tt-ord-emb-impresso.embarque = tt-ordens-embarque.embarque
                                  AND tt-ord-emb-impresso.numero-ordem = tt-ordens-embarque.numero-ordem) THEN DO:
                    CREATE tt-ord-emb-impresso.
                    ASSIGN tt-ord-emb-impresso.cod-estabel = tt-ordens-embarque.cod-estabel
                           tt-ord-emb-impresso.embarque = tt-ordens-embarque.embarque
                           tt-ord-emb-impresso.numero-ordem = tt-ordens-embarque.numero-ordem.

                END.
                RUN pi-imprime-chave (INPUT 5).
                RUN pi-imprime-ficha (INPUT "embarque-imp":U,
                                      INPUT l-chave,
                                      INPUT STRING(tt-embarque-imp.r-rowid)).
            END.
        END.

        /* Hist¢rico do Embarque - Gera bloco para £ltimo Embarque */
        IF  tt-param.lAcompEmb THEN DO:
            IF l-somente-embarques OR l-somente-embarques-processos OR l-somente-embarques-pedidos THEN
                ASSIGN l-imprime-acomp-embarque = l-imprime-embarque.
            ELSE
                ASSIGN l-imprime-acomp-embarque = (FIRST-OF (tt-ordens-embarque.cod-estabel) OR FIRST-OF (tt-ordens-embarque.embarque)).

            IF l-imprime-acomp-embarque THEN DO:

                FOR EACH tt-historico-embarque NO-LOCK
                    WHERE tt-historico-embarque.cod-estabel = tt-ordens-embarque.cod-estabel
                      AND tt-historico-embarque.embarque    = tt-ordens-embarque.embarque
                      BREAK BY tt-historico-embarque.cod-estabel
                            BY tt-historico-embarque.embarque:


                    RUN pi-acompanhar IN h-acomp (INPUT STRING(c-liter-traduc-hist-embarque + " - " + TRIM(STRING(tt-historico-embarque.embarque)) + " - " + TRIM(STRING(tt-historico-embarque.cod-pto-contr)))).

                    RUN pi-imprime-chave (INPUT 6).
                    RUN pi-imprime-ficha (INPUT "historico-embarque":U,
                                          INPUT NO,
                                          INPUT STRING(tt-historico-embarque.r-rowid)).

                    FOR EACH tt-desp-embarque NO-LOCK
                        WHERE tt-desp-embarque.cod-estabel   = tt-historico-embarque.cod-estabel
                          AND tt-desp-embarque.embarque      = tt-historico-embarque.embarque
                          AND tt-desp-embarque.cod-itiner    = tt-historico-embarque.cod-itiner
                          AND tt-desp-embarque.cod-pto-contr = tt-historico-embarque.cod-pto-contr
                        BREAK BY tt-desp-embarque.cod-pto-contr:

                        RUN pi-acompanhar IN h-acomp (INPUT STRING(c-liter-traduc-desp-embarque + " - " + TRIM(STRING(tt-desp-embarque.embarque)) + " - " + TRIM(STRING(tt-desp-embarque.cod-pto-contr)))).

                        IF NOT FIRST-OF (tt-desp-embarque.cod-pto-contr) THEN
                           RUN pi-imprime-chave (INPUT 7).

                        RUN pi-imprime-ficha (INPUT "desp-embarque":U,
                                              INPUT NO,
                                              INPUT STRING(tt-desp-embarque.r-rowid)).

                        IF NOT LAST-OF (tt-desp-embarque.cod-pto-contr) THEN
                            ASSIGN i-linha = i-linha-ficha + 1.
                    END.

                    ASSIGN i-linha = i-linha-ficha + 1.
                END.
                /*Release necess†rio para n∆o imprimir a chave do acompanhamento
                  do embarque quando imprimir o documento*/
                RELEASE tt-historico-embarque.
            END.
        END.

        /* Material em Transito*/
        IF tt-param.lMaterialTransito THEN DO:

            FOR EACH tt-embarque-contab NO-LOCK
                WHERE tt-embarque-contab.cod-estabel = tt-ordens-embarque.cod-estabel
                  AND tt-embarque-contab.embarque    = tt-ordens-embarque.embarque:

                IF CAN-FIND(FIRST tt-embarque-contab-impresso
                            WHERE tt-embarque-contab-impresso.embarque     = tt-embarque-contab.embarque
                              AND tt-embarque-contab-impresso.cod-estabel  = tt-embarque-contab.cod-estabel
                              AND tt-embarque-contab-impresso.ep-codigo    = tt-embarque-contab.ep-codigo
                              AND tt-embarque-contab-impresso.cod-especie  = tt-embarque-contab.cod-especie
                              AND tt-embarque-contab-impresso.serie        = tt-embarque-contab.serie
                              AND tt-embarque-contab-impresso.nr-docto     = tt-embarque-contab.nr-docto
                              AND tt-embarque-contab-impresso.parcela      = tt-embarque-contab.parcela
                              AND tt-embarque-contab-impresso.cod-emitente = tt-embarque-contab.cod-emitente) THEN NEXT.



                CREATE tt-embarque-contab-impresso.
                ASSIGN tt-embarque-contab-impresso.embarque      = tt-embarque-contab.embarque
                       tt-embarque-contab-impresso.cod-estabel   = tt-embarque-contab.cod-estabel
                       tt-embarque-contab-impresso.ep-codigo     = tt-embarque-contab.ep-codigo
                       tt-embarque-contab-impresso.cod-especie   = tt-embarque-contab.cod-especie
                       tt-embarque-contab-impresso.serie         = tt-embarque-contab.serie
                       tt-embarque-contab-impresso.nr-docto      = tt-embarque-contab.nr-docto
                       tt-embarque-contab-impresso.parcela       = tt-embarque-contab.parcela
                       tt-embarque-contab-impresso.cod-emitente  = tt-embarque-contab.cod-emitente.


                RUN pi-imprime-chave (INPUT 6).
                RUN pi-imprime-ficha (INPUT "embarque-contab":U,
                                      INPUT NO,
                                      INPUT STRING(rowid(tt-embarque-contab))).


                ASSIGN i-linha = i-linha-ficha + 1.
            END.
        END.

        /* Geraá∆o dados Documentos */
        IF tt-param.lDocumentos
        OR tt-param.lParcelas THEN
            RUN pi-gera-documentos (INPUT tt-ordens-embarque.numero-ordem,
                                    INPUT tt-ordens-embarque.parcela).

        /* NF Complementar */
        IF tt-param.lNFCompl THEN DO:
            FOR FIRST bf-tt-item-doc-est NO-LOCK
                WHERE bf-tt-item-doc-est.numero-ordem = tt-ordens-embarque.numero-ordem
                  AND bf-tt-item-doc-est.parcela      = tt-ordens-embarque.parcela:

                FOR EACH tt-rat-docum NO-LOCK
                   WHERE tt-rat-docum.nf-serie    = bf-tt-item-doc-est.serie-docto
                     AND tt-rat-docum.nf-nro      = bf-tt-item-doc-est.nro-docto
                     AND tt-rat-docum.nf-emitente = bf-tt-item-doc-est.cod-emitente
                     AND tt-rat-docum.nf-nat-oper = bf-tt-item-doc-est.nat-operacao
                    BREAK BY tt-rat-docum.serie-docto
                          BY tt-rat-docum.nro-docto
                          BY tt-rat-docum.cod-emitente
                          BY tt-rat-docum.nat-operacao:

                    RUN pi-acompanhar IN h-acomp (INPUT STRING(c-liter-traduc-rat-doc + " - " + TRIM(STRING(tt-rat-docum.nf-nro)))).

                    IF FIRST-OF(tt-rat-docum.serie-docto)
                    OR FIRST-OF(tt-rat-docum.nro-docto)
                    OR FIRST-OF(tt-rat-docum.cod-emitente)
                    OR FIRST-OF(tt-rat-docum.nat-operacao) THEN DO:

                        FOR FIRST tt-docum-est NO-LOCK
                            WHERE tt-docum-est.serie-docto  = tt-rat-docum.serie-docto
                              AND tt-docum-est.nro-docto    = tt-rat-docum.nro-docto
                              AND tt-docum-est.cod-emitente = tt-rat-docum.cod-emitente
                              AND tt-docum-est.nat-operacao = tt-rat-docum.nat-operacao:

                            ASSIGN i-linha = i-linha-ficha + 1.
                            RUN pi-imprime-chave (INPUT 6).

                            IF NOT tt-param.lItensDoc THEN DO:
                                IF NOT CAN-FIND(FIRST tt-docum-est-rat
                                                WHERE tt-docum-est-rat.serie-docto  = tt-docum-est.serie-docto
                                                  AND tt-docum-est-rat.nro-docto    = tt-docum-est.nro-docto
                                                  AND tt-docum-est-rat.cod-emitente = tt-docum-est.cod-emitente
                                                  AND tt-docum-est-rat.nat-operacao = tt-docum-est.nat-operacao) THEN DO:

                                    RUN pi-imprime-ficha (INPUT "docum-est":U,
                                                          INPUT NO,
                                                          INPUT STRING(tt-docum-est.r-rowid)).
                                    CREATE tt-docum-est-rat.
                                    ASSIGN tt-docum-est-rat.serie-docto  = tt-docum-est.serie-docto
                                           tt-docum-est-rat.nro-docto    = tt-docum-est.nro-docto
                                           tt-docum-est-rat.cod-emitente = tt-docum-est.cod-emitente
                                           tt-docum-est-rat.nat-operacao = tt-docum-est.nat-operacao.

                                    IF tt-param.lDespImp THEN DO:
                                        FOR EACH tt-docum-est-cex NO-LOCK
                                            WHERE tt-docum-est-cex.serie-docto  = tt-docum-est-rat.serie-docto
                                              AND tt-docum-est-cex.nro-docto    = tt-docum-est-rat.nro-docto
                                              AND tt-docum-est-cex.cod-emitente = tt-docum-est-rat.cod-emitente
                                              AND tt-docum-est-cex.nat-operacao = tt-docum-est-rat.nat-operacao:

                                            RUN pi-acompanhar IN h-acomp (INPUT STRING(c-liter-traduc-arq-doc + " - " + TRIM(STRING(tt-docum-est-cex.nro-docto )))).

                                            RUN pi-imprime-chave (INPUT 8).
                                            RUN pi-imprime-ficha (INPUT "docum-est-cex":U,
                                                                  INPUT NO,
                                                                  INPUT STRING(tt-docum-est-cex.r-rowid)).
                                            ASSIGN i-linha = i-linha-ficha + 1.
                                        END.
                                    END.
                                END.
                            END.
                            ELSE DO:
                                IF NOT CAN-FIND(FIRST tt-docum-est-rat
                                                WHERE tt-docum-est-rat.serie-docto  = tt-docum-est.serie-docto
                                                  AND tt-docum-est-rat.nro-docto    = tt-docum-est.nro-docto
                                                  AND tt-docum-est-rat.cod-emitente = tt-docum-est.cod-emitente
                                                  AND tt-docum-est-rat.nat-operacao = tt-docum-est.nat-operacao) THEN DO:

                                    RUN pi-imprime-ficha (INPUT "docum-est":U,
                                                          INPUT NO,
                                                          INPUT STRING(tt-docum-est.r-rowid)).
                                    CREATE tt-docum-est-rat.
                                    ASSIGN tt-docum-est-rat.serie-docto  = tt-docum-est.serie-docto
                                           tt-docum-est-rat.nro-docto    = tt-docum-est.nro-docto
                                           tt-docum-est-rat.cod-emitente = tt-docum-est.cod-emitente
                                           tt-docum-est-rat.nat-operacao = tt-docum-est.nat-operacao.

                                    IF tt-param.lDespImp THEN DO:
                                        FOR EACH tt-docum-est-cex NO-LOCK
                                            WHERE tt-docum-est-cex.serie-docto  = tt-docum-est-rat.serie-docto
                                              AND tt-docum-est-cex.nro-docto    = tt-docum-est-rat.nro-docto
                                              AND tt-docum-est-cex.cod-emitente = tt-docum-est-rat.cod-emitente
                                              AND tt-docum-est-cex.nat-operacao = tt-docum-est-rat.nat-operacao:

                                            RUN pi-acompanhar IN h-acomp (INPUT STRING(c-liter-traduc-arq-doc + " - " + TRIM(STRING(tt-docum-est-cex.nro-docto )))).

                                            RUN pi-imprime-chave (INPUT 8).
                                            RUN pi-imprime-ficha (INPUT "docum-est-cex":U,
                                                                  INPUT NO,
                                                                  INPUT STRING(tt-docum-est-cex.r-rowid)).
                                            ASSIGN i-linha = i-linha-ficha + 1.
                                        END.
                                    END.
                                END.
                                ELSE DO:
                                    RUN pi-imprime-ficha (INPUT "docum-est":U,
                                                          INPUT YES, /*imprime s¢ as chaves*/
                                                          INPUT STRING(tt-docum-est.r-rowid)).
                                END.
                            END.

                            IF tt-param.lItensDoc THEN DO:
                                FOR EACH tt-item-doc-est NO-LOCK
                                   WHERE tt-item-doc-est.serie-docto  = tt-docum-est.serie-docto
                                     AND tt-item-doc-est.nro-docto    = tt-docum-est.nro-docto
                                     AND tt-item-doc-est.cod-emitente = tt-docum-est.cod-emitente
                                     AND tt-item-doc-est.nat-operacao = tt-docum-est.nat-operacao
                                   BREAK BY tt-item-doc-est.sequencia
                                         BY tt-item-doc-est.serie-docto:

                                    RUN pi-acompanhar IN h-acomp (INPUT STRING(c-liter-traduc-itens-doc + " - " + TRIM(STRING(tt-item-doc-est.sequencia)))).

                                   /*L¢gica para imprimir o item da nota complementar correspondente ao item da nota principal*/
                                   IF CAN-FIND (FIRST tt-item-doc-est-nf-comp
                                                WHERE tt-item-doc-est-nf-comp.serie-docto  = tt-item-doc-est.serie-docto
                                                  AND tt-item-doc-est-nf-comp.nro-docto    = tt-item-doc-est.nro-docto
                                                  AND tt-item-doc-est-nf-comp.cod-emitente = tt-item-doc-est.cod-emitente
                                                  AND tt-item-doc-est-nf-comp.nat-operacao = tt-item-doc-est.nat-operacao
                                                  AND tt-item-doc-est-nf-comp.sequencia    = tt-item-doc-est.sequencia) THEN NEXT.
                                   ELSE DO:
                                       CREATE tt-item-doc-est-nf-comp.
                                       ASSIGN tt-item-doc-est-nf-comp.serie-docto  = tt-item-doc-est.serie-docto
                                              tt-item-doc-est-nf-comp.nro-docto    = tt-item-doc-est.nro-docto
                                              tt-item-doc-est-nf-comp.cod-emitente = tt-item-doc-est.cod-emitente
                                              tt-item-doc-est-nf-comp.nat-operacao = tt-item-doc-est.nat-operacao
                                              tt-item-doc-est-nf-comp.sequencia    = tt-item-doc-est.sequencia.
                                   END.

                                    IF NOT FIRST-OF (tt-item-doc-est.serie-docto) THEN
                                        RUN pi-imprime-chave (INPUT 8).

                                    /*Tratamento para imprimir valores dos itens de notas complementares apenas
                                      na primeira vez que o item Ç impresso*/
                                    ASSIGN l-chave = NO.
                                    IF NOT CAN-FIND(FIRST tt-item-doc-est-imp
                                                    WHERE tt-item-doc-est-imp.serie-docto  = tt-item-doc-est.serie-docto
                                                      AND tt-item-doc-est-imp.nro-docto    = tt-item-doc-est.nro-docto
                                                      AND tt-item-doc-est-imp.cod-emitente = tt-item-doc-est.cod-emitente
                                                      AND tt-item-doc-est-imp.nat-operacao = tt-item-doc-est.nat-operacao
                                                      AND tt-item-doc-est-imp.sequencia    = tt-item-doc-est.sequencia) THEN DO:
                                        CREATE tt-item-doc-est-imp.
                                        ASSIGN tt-item-doc-est-imp.serie-docto  = tt-item-doc-est.serie-docto
                                               tt-item-doc-est-imp.nro-docto    = tt-item-doc-est.nro-docto
                                               tt-item-doc-est-imp.cod-emitente = tt-item-doc-est.cod-emitente
                                               tt-item-doc-est-imp.nat-operacao = tt-item-doc-est.nat-operacao
                                               tt-item-doc-est-imp.sequencia    = tt-item-doc-est.sequencia.
                                    END.
                                    ELSE
                                        ASSIGN l-chave = YES.

                                    RUN pi-imprime-ficha (INPUT "item-doc-est":U,
                                                          INPUT l-chave,
                                                          INPUT STRING(tt-item-doc-est.r-rowid)).

                                    /* Despesas Item Nota Fiscal */
                                    IF tt-param.lDespItemDoc THEN DO:
                                        FOR EACH tt-item-doc-est-cex NO-LOCK
                                            WHERE tt-item-doc-est-cex.serie-docto  = tt-item-doc-est.serie-docto
                                              AND tt-item-doc-est-cex.nro-docto    = tt-item-doc-est.nro-docto
                                              AND tt-item-doc-est-cex.cod-emitente = tt-item-doc-est.cod-emitente
                                              AND tt-item-doc-est-cex.nat-operacao = tt-item-doc-est.nat-operacao
                                              AND tt-item-doc-est-cex.sequencia    = tt-item-doc-est.sequencia:

                                            RUN pi-acompanhar IN h-acomp (INPUT STRING(c-liter-traduc-itens-doc + " - " + TRIM(STRING(tt-item-doc-est-cex.sequencia)))).

                                            RUN pi-imprime-chave (INPUT 9).
                                            ASSIGN l-chave = NO.
                                            IF NOT CAN-FIND(FIRST tt-item-doc-est-cex-imp
                                                            WHERE tt-item-doc-est-cex-imp.serie-docto       = tt-item-doc-est-cex.serie-docto
                                                              AND tt-item-doc-est-cex-imp.nro-docto         = tt-item-doc-est-cex.nro-docto
                                                              AND tt-item-doc-est-cex-imp.cod-emitente      = tt-item-doc-est-cex.cod-emitente
                                                              AND tt-item-doc-est-cex-imp.nat-operacao      = tt-item-doc-est-cex.nat-operacao
                                                              AND tt-item-doc-est-cex-imp.sequencia         = tt-item-doc-est-cex.sequencia
                                                              AND tt-item-doc-est-cex-imp.cod-emitente-desp = tt-item-doc-est-cex.cod-emitente-desp
                                                              AND tt-item-doc-est-cex-imp.cod-desp          = tt-item-doc-est-cex.cod-desp)  THEN DO:

                                                CREATE tt-item-doc-est-cex-imp.
                                                ASSIGN tt-item-doc-est-cex-imp.serie-docto       = tt-item-doc-est-cex.serie-docto
                                                       tt-item-doc-est-cex-imp.nro-docto         = tt-item-doc-est-cex.nro-docto
                                                       tt-item-doc-est-cex-imp.cod-emitente      = tt-item-doc-est-cex.cod-emitente
                                                       tt-item-doc-est-cex-imp.nat-operacao      = tt-item-doc-est-cex.nat-operacao
                                                       tt-item-doc-est-cex-imp.sequencia         = tt-item-doc-est-cex.sequencia
                                                       tt-item-doc-est-cex-imp.cod-emitente-desp = tt-item-doc-est-cex.cod-emitente-desp
                                                       tt-item-doc-est-cex-imp.cod-desp          = tt-item-doc-est-cex.cod-desp.
                                            END.
                                            ELSE DO:
                                                ASSIGN l-chave = YES.
                                            END.
                                            RUN pi-imprime-ficha (INPUT "item-doc-est-cex":U,
                                                                  INPUT l-chave,
                                                                  INPUT STRING(tt-item-doc-est-cex.r-rowid)).
                                            ASSIGN i-linha = i-linha-ficha + 1.
                                        END.
                                    END.

                                    IF NOT LAST-OF (tt-item-doc-est.serie-docto) THEN
                                        ASSIGN i-linha = i-linha-ficha + 1.

                                    /*O leave Ç utilizado para que seja impresso apenas
                                    o item da nota complemtentar correspondente ao
                                    item da nota principal*/
                                    LEAVE.

                                END. /*FOR EACH tt-item-doc-est*/
                            END. /*IF tt-param.lItensDoc*/
                        END. /*FOR FIRST tt-docum-est*/
                    END. /*IF FIRST-OF(tt-rat-docum.serie-docto)*/
                END. /*FOR EACH tt-rat-docum*/
            END. /*FOR FIRST bf-tt-item-doc-est*/
        END. /*IF tt-param.lNFCompl*/

        ASSIGN l-imprime = NO.
        IF tt-param.lEmbarqueImp THEN DO:
            ASSIGN l-last-embarque = YES.
            FOR EACH bf-tt-embarque-imp:
                /*Tratamento para pular linha e imprimir chave apenas se n∆o existir
                  outro embarque para a mesma ordem de compra*/

                RUN pi-acompanhar IN h-acomp (INPUT STRING(c-liter-traduc-arq-emb-impres + " - " + TRIM(STRING(bf-tt-embarque-imp.embarque)))).

                IF NOT CAN-FIND(FIRST tt-embarque-impresso
                                WHERE tt-embarque-impresso.cod-estabel = bf-tt-embarque-imp.cod-estabel
                                  AND tt-embarque-impresso.embarque    = bf-tt-embarque-imp.embarque)
                   AND CAN-FIND(FIRST bf-tt-ordens-embarque
                                WHERE bf-tt-ordens-embarque.cod-estabel  = bf-tt-embarque-imp.cod-estabel
                                  AND bf-tt-ordens-embarque.embarque     = bf-tt-embarque-imp.embarque
                                  AND bf-tt-ordens-embarque.nr-proc-imp  = tt-ordens-embarque.nr-proc-imp) THEN

                    ASSIGN l-last-embarque = NO.
            END.
            IF tt-param.lOrdemCompra THEN DO:
                ASSIGN l-last-embarque = YES.
                FOR EACH bf-tt-ordens-embarque
                   WHERE bf-tt-ordens-embarque.numero-ordem = tt-ordens-embarque.numero-ordem:

                    RUN pi-acompanhar IN h-acomp (INPUT STRING(c-liter-traduc-arq-ordens-impres + " - " + TRIM(STRING(bf-tt-ordens-embarque.embarque)) + " - " + TRIM(STRING(bf-tt-ordens-embarque.numero-ordem)))).
                    IF NOT CAN-FIND(FIRST tt-ord-emb-impresso
                                WHERE tt-ord-emb-impresso.cod-estabel        = bf-tt-ordens-embarque.cod-estabel
                                  AND tt-ord-emb-impresso.embarque           = bf-tt-ordens-embarque.embarque
                                  AND tt-ord-emb-impresso.numero-ordem       = bf-tt-ordens-embarque.numero-ordem) THEN
                        ASSIGN l-last-embarque = NO.
                END.
            END.

            ASSIGN l-imprime = NOT l-last-embarque AND l-imprime-embarque.

        END.

        IF tt-param.lParcelas OR tt-param.lItensDoc OR (NOT tt-param.lOrdemCompra AND NOT tt-param.lEmbarqueImp) THEN
            ASSIGN l-imprime = NOT LAST-OF(tt-ordens-embarque.numero-ordem).

        IF l-imprime THEN DO:
            ASSIGN i-linha = i-linha-ficha + 1.
			RUN pi-imprime-chave (INPUT 6).
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* ================== Documentos ================== */
PROCEDURE pi-gera-documentos:
/*------------------------------------------------------------------------------
  Purpose:     Imprime as informaá‰es dos documentos de entrada.
  Parameters:  p-numero-ordem: N£mero da ordem de compra (integer).
               p-parcela: N£mero da parcela (integer).
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-numero-ordem LIKE prazo-compra.numero-ordem NO-UNDO.
    DEFINE INPUT PARAM p-parcela      LIKE prazo-compra.parcela      NO-UNDO.

    DEFINE VARIABLE l-first-docum-est   AS LOGICAL NO-UNDO.
    DEFINE VARIABLE l-existe-desp-compl AS LOGICAL NO-UNDO.

    IF tt-param.lParcelas THEN
        FOR FIRST tt-prazo-compra NO-LOCK
            WHERE tt-prazo-compra.numero-ordem = p-numero-ordem
              AND tt-prazo-compra.parcela      = p-parcela:
            RUN pi-imprime-chave (INPUT 7).
            RUN pi-imprime-ficha (INPUT "prazo-compra":U,
                                  INPUT NO,
                                  INPUT STRING(tt-prazo-compra.r-rowid)).
        END.

    IF tt-param.lDocumentos THEN DO:

        FOR EACH tt-item-doc-est NO-LOCK
            WHERE tt-item-doc-est.numero-ordem-aux = p-numero-ordem
              AND tt-item-doc-est.parcela-aux      = p-parcela
            BREAK BY tt-item-doc-est.numero-ordem-aux:

            ASSIGN l-first-docum-est = NO.
            FOR FIRST tt-docum-est NO-LOCK
                WHERE tt-docum-est.serie-docto  = tt-item-doc-est.serie-docto
                  AND tt-docum-est.nro-docto    = tt-item-doc-est.nro-docto
                  AND tt-docum-est.cod-emitente = tt-item-doc-est.cod-emitente
                  AND tt-docum-est.nat-operacao = tt-item-doc-est.nat-operacao:


                /*L¢gica para n∆o repetir o documento quando n∆o marcado o item do documento ou parcela*/
                IF NOT CAN-FIND (FIRST tt-docum-est-imp
                                 WHERE tt-docum-est-imp.serie-docto   = tt-docum-est.serie-docto
                                   AND tt-docum-est-imp.nro-docto     = tt-docum-est.nro-docto
                                   AND tt-docum-est-imp.cod-emitente  = tt-docum-est.cod-emitente
                                   AND tt-docum-est-imp.nat-operacao  = tt-docum-est.nat-operacao) THEN DO:

                    /*L¢gica para imprimir a chave dos agrupadores quando a nota for simples remessa filha*/
                    RUN pi-imprime-nota-filha-embarque-mae.

                    RUN pi-imprime-chave (INPUT 7).
                    RUN pi-imprime-ficha (INPUT "docum-est":U,
                                          INPUT NO,
                                          INPUT STRING(tt-docum-est.r-rowid)).


                    CREATE tt-docum-est-imp.
                    ASSIGN tt-docum-est-imp.serie-docto  = tt-docum-est.serie-docto
                           tt-docum-est-imp.nro-docto    = tt-docum-est.nro-docto
                           tt-docum-est-imp.cod-emitente = tt-docum-est.cod-emitente
                           tt-docum-est-imp.nat-operacao = tt-docum-est.nat-operacao
                           tt-docum-est-imp.numero-ordem = tt-item-doc-est.numero-ordem-aux
                           tt-docum-est-imp.parcela      = tt-item-doc-est.parcela-aux
                           tt-docum-est-imp.embarque     = tt-ordens-embarque.embarque
                           l-first-docum-est = YES.




                END.
                ELSE IF tt-param.lItensDoc OR tt-param.lParcelas OR tt-param.lOrdemCompra OR tt-param.lPedidoCompra OR tt-param.lProcessoImp THEN DO:

                        RUN pi-imprime-chave (INPUT 7).
                        RUN pi-imprime-ficha (INPUT "docum-est":U,
                                              INPUT YES,
                                              INPUT STRING(tt-docum-est.r-rowid)).
                END.
            END.

            IF l-first-docum-est THEN DO:
    			/* Despesas Nota Fiscal */
                IF tt-param.lDespImp THEN DO:
                    FOR EACH tt-docum-est-cex NO-LOCK
                        WHERE tt-docum-est-cex.serie-docto  = tt-docum-est.serie-docto
                          AND tt-docum-est-cex.nro-docto    = tt-docum-est.nro-docto
                          AND tt-docum-est-cex.cod-emitente = tt-docum-est.cod-emitente
                          AND tt-docum-est-cex.nat-operacao = tt-docum-est.nat-operacao:

                        RUN pi-imprime-chave (INPUT 8).
                        RUN pi-imprime-ficha (INPUT "docum-est-cex":U,
                                              INPUT NO,
                                              INPUT STRING(tt-docum-est-cex.r-rowid)).
                        ASSIGN i-linha = i-linha-ficha + 1.
                    END.


                    /* Imprime as despesas da NF Complementar */
                    IF tt-param.lNFCompl THEN DO:
                        ASSIGN l-existe-desp-compl = NO.
                        FOR EACH tt-rat-docum NO-LOCK
                           WHERE tt-rat-docum.nf-serie    = tt-item-doc-est.serie-docto
                             AND tt-rat-docum.nf-nro      = tt-item-doc-est.nro-docto
                             AND tt-rat-docum.nf-emitente = tt-item-doc-est.cod-emitente
                             AND tt-rat-docum.nf-nat-oper = tt-item-doc-est.nat-operacao
                            BREAK BY tt-rat-docum.serie-docto
                                  BY tt-rat-docum.nro-docto
                                  BY tt-rat-docum.cod-emitente
                                  BY tt-rat-docum.nat-operacao:

                            IF FIRST-OF(tt-rat-docum.serie-docto)
                            OR FIRST-OF(tt-rat-docum.nro-docto)
                            OR FIRST-OF(tt-rat-docum.cod-emitente)
                            OR FIRST-OF(tt-rat-docum.nat-operacao) THEN DO:

                                IF NOT CAN-FIND(FIRST tt-docum-est-rat
                                                WHERE tt-docum-est-rat.serie-docto  = tt-rat-docum.serie-docto
                                                  AND tt-docum-est-rat.nro-docto    = tt-rat-docum.nro-docto
                                                  AND tt-docum-est-rat.cod-emitente = tt-rat-docum.cod-emitente
                                                  AND tt-docum-est-rat.nat-operacao = tt-rat-docum.nat-operacao)
                                   AND CAN-FIND(FIRST tt-docum-est-cex
                                                WHERE tt-docum-est-cex.serie-docto  = tt-rat-docum.serie-docto
                                                  AND tt-docum-est-cex.nro-docto    = tt-rat-docum.nro-docto
                                                  AND tt-docum-est-cex.cod-emitente = tt-rat-docum.cod-emitente
                                                  AND tt-docum-est-cex.nat-operacao = tt-rat-docum.nat-operacao) THEN DO:

                                    FOR FIRST tt-docum-est NO-LOCK
                                        WHERE tt-docum-est.serie-docto  = tt-rat-docum.serie-docto
                                          AND tt-docum-est.nro-docto    = tt-rat-docum.nro-docto
                                          AND tt-docum-est.cod-emitente = tt-rat-docum.cod-emitente
                                          AND tt-docum-est.nat-operacao = tt-rat-docum.nat-operacao:

                                        ASSIGN i-linha = i-linha-ficha + 1
                                               l-existe-desp-compl = YES.
                                        RUN pi-imprime-chave (INPUT 6).

                                        RUN pi-imprime-ficha (INPUT "docum-est":U,
                                                              INPUT NO,
                                                              INPUT STRING(tt-docum-est.r-rowid)).
                                        CREATE tt-docum-est-rat.
                                        ASSIGN tt-docum-est-rat.serie-docto  = tt-docum-est.serie-docto
                                               tt-docum-est-rat.nro-docto    = tt-docum-est.nro-docto
                                               tt-docum-est-rat.cod-emitente = tt-docum-est.cod-emitente
                                               tt-docum-est-rat.nat-operacao = tt-docum-est.nat-operacao.

                                        FOR EACH tt-docum-est-cex NO-LOCK
                                            WHERE tt-docum-est-cex.serie-docto  = tt-docum-est-rat.serie-docto
                                              AND tt-docum-est-cex.nro-docto    = tt-docum-est-rat.nro-docto
                                              AND tt-docum-est-cex.cod-emitente = tt-docum-est-rat.cod-emitente
                                              AND tt-docum-est-cex.nat-operacao = tt-docum-est-rat.nat-operacao:

                                            RUN pi-imprime-chave (INPUT 8).
                                            RUN pi-imprime-ficha (INPUT "docum-est-cex":U,
                                                                  INPUT NO,
                                                                  INPUT STRING(tt-docum-est-cex.r-rowid)).
                                            ASSIGN i-linha = i-linha-ficha + 1.
                                        END. /*FOR EACH tt-docum-est-cex*/
                                    END. /*FOR FIRST tt-docum-est*/
                                END. /*IF NOT CAN-FIND(FIRST tt-docum-est-rat*/
                            END. /*IF FIRST-OF(tt-rat-docum.serie-docto)*/
                        END. /*FOR EACH tt-rat-docum*/

                        IF l-existe-desp-compl THEN
                           FOR FIRST tt-docum-est NO-LOCK
                               WHERE tt-docum-est.serie-docto  = tt-item-doc-est.serie-docto
                                 AND tt-docum-est.nro-docto    = tt-item-doc-est.nro-docto
                                 AND tt-docum-est.cod-emitente = tt-item-doc-est.cod-emitente
                                 AND tt-docum-est.nat-operacao = tt-item-doc-est.nat-operacao:
                               RUN pi-imprime-chave (INPUT 8).
                           END.
                    END. /*IF tt-param.lNFCompl*/
                END. /*IF tt-param.lDespImp*/

                /* Duplicatas Nota Fiscal */
                IF tt-param.lDuplicatas THEN DO:
                    FOR EACH tt-dupli-apagar NO-LOCK
                        WHERE tt-dupli-apagar.serie-docto  = tt-docum-est.serie-docto
                          AND tt-dupli-apagar.nro-docto    = tt-docum-est.nro-docto
                          AND tt-dupli-apagar.cod-emitente = tt-docum-est.cod-emitente
                          AND tt-dupli-apagar.nat-operacao = tt-docum-est.nat-operacao:

                        RUN pi-imprime-chave (INPUT 8).
                        RUN pi-imprime-ficha (INPUT "dupli-apagar":U,
                                              INPUT NO,
                                              INPUT STRING(tt-dupli-apagar.r-rowid)).
                        ASSIGN i-linha = i-linha-ficha + 1.
                    END.
                END.

                /* Duplicatas Despesas Nota Fiscal */
                IF tt-param.lDupDespesas THEN DO:
                    FOR EACH tt-dupli-apagar-cex NO-LOCK
                        WHERE tt-dupli-apagar-cex.serie-docto  = tt-docum-est.serie-docto
                          AND tt-dupli-apagar-cex.nro-docto    = tt-docum-est.nro-docto
                          AND tt-dupli-apagar-cex.cod-emitente = tt-docum-est.cod-emitente
                          AND tt-dupli-apagar-cex.nat-operacao = tt-docum-est.nat-operacao:

                        RUN pi-imprime-chave (INPUT 8).
                        RUN pi-imprime-ficha (INPUT "dupli-apagar-cex":U,
                                              INPUT NO,
                                              INPUT STRING(tt-dupli-apagar-cex.r-rowid)).
                        ASSIGN i-linha = i-linha-ficha + 1.
                    END.
                END.
            END.
            IF tt-param.lItensDoc THEN DO:
                RUN pi-imprime-chave (INPUT 8).
                RUN pi-imprime-ficha (INPUT "item-doc-est":U,
                                      INPUT NO,
                                      INPUT STRING(tt-item-doc-est.r-rowid)).
            END.

            /* Despesas Item Nota Fiscal */
            IF tt-param.lDespItemDoc THEN DO:
                FOR EACH tt-item-doc-est-cex NO-LOCK
                    WHERE tt-item-doc-est-cex.serie-docto  = tt-item-doc-est.serie-docto
                      AND tt-item-doc-est-cex.nro-docto    = tt-item-doc-est.nro-docto
                      AND tt-item-doc-est-cex.cod-emitente = tt-item-doc-est.cod-emitente
                      AND tt-item-doc-est-cex.nat-operacao = tt-item-doc-est.nat-operacao
                      AND tt-item-doc-est-cex.sequencia    = tt-item-doc-est.sequencia:

                    RUN pi-imprime-chave (INPUT 9).
                    RUN pi-imprime-ficha (INPUT "item-doc-est-cex":U,
                                          INPUT NO,
                                          INPUT STRING(tt-item-doc-est-cex.r-rowid)).
                    ASSIGN i-linha = i-linha-ficha + 1.
                END.
            END.

            /* Informaá‰es de Estoque */
            IF tt-param.lMovtoEstoq THEN DO:
                FOR EACH tt-rat-lote NO-LOCK
                    WHERE tt-rat-lote.serie-docto  = tt-item-doc-est.serie-docto
                      AND tt-rat-lote.nro-docto    = tt-item-doc-est.nro-docto
                      AND tt-rat-lote.cod-emitente = tt-item-doc-est.cod-emitente
                      AND tt-rat-lote.nat-operacao = tt-item-doc-est.nat-operacao
                      AND tt-rat-lote.sequencia    = tt-item-doc-est.sequencia:

                    RUN pi-imprime-chave (INPUT 9).
                    RUN pi-imprime-ficha (INPUT "rat-lote":U,
                                          INPUT NO,
                                          INPUT STRING(tt-rat-lote.r-rowid)).
                    ASSIGN i-linha = i-linha-ficha + 1.
                END.
            END.

            /*Pula linha se n∆o for a £ltima ordem do item do documento ou
              quando for nota filha e ainda existe outras ordens de embarque
              para serem lidas e n∆o estiver marcado lParcelas
              (Caso esteja marcado ir† pular a linha para cada ordens-embarque)*/
            IF (NOT LAST-OF(tt-item-doc-est.numero-ordem-aux) OR
               (NOT l-last-ordem-embarq AND NOT tt-param.lParcelas)) AND tt-param.lItensDoc THEN
                ASSIGN i-linha = i-linha-ficha + 1.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-nota-filha-embarque-mae:
/*------------------------------------------------------------------------------
  Purpose:     Imprime as chaves dos relacionamentos quando notas de simples
               remessa filha de mesma ordens-embarque que a nota m∆e.
  Parameters:
  Notes:       TRATAMENTO PARA NOTA DE SIMPLES REMESSA COMUM
               (SEM CONSIDERAR PRIMEIRA REMESSA COM NF M«E)
------------------------------------------------------------------------------*/
    IF CAN-FIND(FIRST tt-docum-est-imp
                WHERE tt-docum-est-imp.numero-ordem = tt-item-doc-est.numero-ordem-aux
                  AND tt-docum-est-imp.parcela      = tt-item-doc-est.parcela-aux
                  AND tt-docum-est-imp.embarque     = tt-ordens-embarque.embarque) THEN DO:

        RUN pi-imprime-chave (INPUT 6).
        IF tt-param.lParcelas AND AVAIL tt-prazo-compra THEN
            RUN pi-imprime-ficha (INPUT "prazo-compra":U, INPUT YES, INPUT "":U).


    END.

    RETURN "OK":U.
END PROCEDURE.

/***********************************************************************************************************************************************/
/*                                                            I M P R E S S « O                                                                */
/***********************************************************************************************************************************************/
PROCEDURE pi-imprime-campos:
/*------------------------------------------------------------------------------
  Purpose:     Imprime os campos na planilha.
  Parameters:  p-c-tabela: Tabela que est† sendo impressa (character).
               l-chave: Indica se imprime somente a chave (logical).
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-c-tabela AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM l-chave    AS LOGICAL   NO-UNDO.

    IF p-c-tabela = "pedido-compr":U THEN DO:

        CASE tt-matriz-ficha.c-linha:
            WHEN "#pc-num-pedido":U THEN RUN pi-imprime-campos-int(INPUT tt-pedido-compr.num-pedido ).
            WHEN "#pc-cod-estabel":U THEN RUN pi-imprime-campos-char(INPUT tt-pedido-compr.cod-estabel ).
            WHEN "#pc-nome-estabel":U THEN RUN pi-imprime-campos-char(INPUT tt-pedido-compr.nome-estabel ).
            WHEN "#pc-data-pedido":U THEN RUN pi-imprime-campos-date(INPUT tt-pedido-compr.data-pedido ).
            WHEN "#pc-cod-emitente":U THEN RUN pi-imprime-campos-int(INPUT tt-pedido-compr.cod-emitente ).
            WHEN "#pc-situacao":U THEN RUN pi-imprime-campos-int(INPUT tt-pedido-compr.situacao ).
            WHEN "#pc-nome-ab-transp":U THEN RUN pi-imprime-campos-char(INPUT tt-pedido-compr.nome-ab-transp ).
            WHEN "#pc-des-cond-pag":U THEN RUN pi-imprime-campos-char(INPUT tt-pedido-compr.des-cond-pag ).
            WHEN "#pc-cod-emit-terc":U THEN RUN pi-imprime-campos-int(INPUT tt-pedido-compr.cod-emit-terc ).
            WHEN "#pc-nome-ab-terc":U THEN RUN pi-imprime-campos-char(INPUT tt-pedido-compr.nome-ab-terc ).
            WHEN "#pc-nr-processo":U THEN RUN pi-imprime-campos-int(INPUT tt-pedido-compr.nr-processo ).
            WHEN "#pc-cod-transp":U THEN RUN pi-imprime-campos-int(INPUT tt-pedido-compr.cod-transp ).
            WHEN "#pc-des-via-transp":U THEN RUN pi-imprime-campos-char(INPUT tt-pedido-compr.des-via-transp ).
            WHEN "#pc-cod-cond-pag":U THEN RUN pi-imprime-campos-int(INPUT tt-pedido-compr.cod-cond-pag ).
            WHEN "#pc-responsavel":U THEN RUN pi-imprime-campos-char(INPUT tt-pedido-compr.responsavel ).
            WHEN "#pc-nr-contrato":U THEN RUN pi-imprime-campos-int(INPUT tt-pedido-compr.nr-contrato ).
        END CASE.

        IF NOT l-chave THEN DO:
        END.
    END.

    IF p-c-tabela = "emitente":U THEN DO:

        CASE tt-matriz-ficha.c-linha:
            WHEN "#for-cod-emitente":U THEN RUN pi-imprime-campos-int(INPUT tt-emitente.cod-emitente ).
            WHEN "#for-nome-abrev":U THEN RUN pi-imprime-campos-char(INPUT tt-emitente.nome-abrev ).
            WHEN "#for-nome-emit":U THEN RUN pi-imprime-campos-char(INPUT tt-emitente.nome-emit ).
            WHEN "#for-endereco":U THEN RUN pi-imprime-campos-char(INPUT tt-emitente.endereco ).
            WHEN "#for-bairro":U THEN RUN pi-imprime-campos-char(INPUT tt-emitente.bairro ).
            WHEN "#for-cidade":U THEN RUN pi-imprime-campos-char(INPUT tt-emitente.cidade ).
            WHEN "#for-estado":U THEN RUN pi-imprime-campos-char(INPUT tt-emitente.estado ).
            WHEN "#for-cep":U THEN RUN pi-imprime-campos-char(INPUT tt-emitente.cep ).
            WHEN "#for-cod-pais":U THEN RUN pi-imprime-campos-int(INPUT tt-emitente.cod-pais ).
            WHEN "#for-pais":U THEN RUN pi-imprime-campos-char(INPUT tt-emitente.pais ).
            WHEN "#for-zip-code":U THEN RUN pi-imprime-campos-char(INPUT tt-emitente.zip-code ).
            WHEN "#for-endereco_text":U THEN RUN pi-imprime-campos-char(INPUT tt-emitente.endereco_text ).
            WHEN "#for-cod-gr-forn":U THEN RUN pi-imprime-campos-int(INPUT tt-emitente.cod-gr-forn ).
            WHEN "#for-des-gr-forn":U THEN RUN pi-imprime-campos-char(INPUT tt-emitente.des-gr-forn ).
            WHEN "#for-contato":U THEN RUN pi-imprime-campos-char(INPUT  tt-emitente.contato[1] ).
            WHEN "#for-telefone_1":U THEN RUN pi-imprime-campos-char(INPUT  tt-emitente.telefone[1] ).
            WHEN "#for-telefone_2":U THEN RUN pi-imprime-campos-char(INPUT  tt-emitente.telefone[2] ).
            WHEN "#for-ramal_1":U THEN RUN pi-imprime-campos-char(INPUT  tt-emitente.ramal[1] ).
            WHEN "#for-ramal_2":U THEN RUN pi-imprime-campos-char(INPUT  tt-emitente.ramal[2] ).
            WHEN "#for-caixa-postal":U THEN RUN pi-imprime-campos-char(INPUT tt-emitente.caixa-postal ).
            WHEN "#for-e-mail":U THEN RUN pi-imprime-campos-char(INPUT tt-emitente.e-mail ).
            WHEN "#for-cod-idioma":U THEN RUN pi-imprime-campos-char(INPUT tt-emitente.cod-idioma ).
            WHEN "#for-cod-rep":U THEN RUN pi-imprime-campos-char(INPUT tt-emitente.cod-rep ).
            WHEN "#for-cod-itiner-imp":U THEN RUN pi-imprime-campos-int(INPUT tt-emitente.cod-itiner-imp ).
            WHEN "#for-des-itiner-imp":U THEN RUN pi-imprime-campos-char(INPUT tt-emitente.des-itiner-imp ).
            WHEN "#for-cod-incoterm-imp":U THEN RUN pi-imprime-campos-char(INPUT tt-emitente.cod-incoterm-imp ).
            WHEN "#for-cod-ident-fisc-exter":U THEN RUN pi-imprime-campos-char(INPUT tt-emitente.cod-ident-fisc-exter ).
        END CASE.

        IF NOT l-chave THEN DO:
        END.
    END.

    IF p-c-tabela = "processo-imp":U THEN DO:
        CASE tt-matriz-ficha.c-linha:
            WHEN "#pi-cod-estabel":U THEN RUN pi-imprime-campos-char(INPUT tt-processo-imp.cod-estabel ).
            WHEN "#pi-nr-proc-imp":U THEN RUN pi-imprime-campos-char(INPUT tt-processo-imp.nr-proc-imp ).
            WHEN "#pi-num-pedido":U THEN RUN pi-imprime-campos-int(INPUT tt-processo-imp.num-pedido ).
            WHEN "#pi-dt-emissao":U THEN RUN pi-imprime-campos-date(INPUT tt-processo-imp.dt-emissao ).
            WHEN "#pi-des-situacao":U THEN RUN pi-imprime-campos-char(INPUT tt-processo-imp.des-situacao ).
            WHEN "#pi-nome-estabel":U THEN RUN pi-imprime-campos-char(INPUT tt-processo-imp.nome-estabel ).
            WHEN "#pi-des-itiner":U THEN RUN pi-imprime-campos-char(INPUT tt-processo-imp.des-itiner ).
            WHEN "#pi-nome-ab-transp":U THEN RUN pi-imprime-campos-char(INPUT tt-processo-imp.nome-ab-transp ).
            WHEN "#pi-nome-corretor-cambio":U THEN RUN pi-imprime-campos-char(INPUT tt-processo-imp.nome-corretor-cambio ).
            WHEN "#pi-nome-despa-exter":U THEN RUN pi-imprime-campos-char(INPUT tt-processo-imp.nome-despa-exter ).
            WHEN "#pi-nome-segurad":U THEN RUN pi-imprime-campos-char(INPUT tt-processo-imp.nome-segurad ).
            WHEN "#pi-nome-corretor":U THEN RUN pi-imprime-campos-char(INPUT tt-processo-imp.nome-corretor ).
            WHEN "#pi-nome-despachante":U THEN RUN pi-imprime-campos-char(INPUT tt-processo-imp.nome-despachante ).
            WHEN "#pi-nome-consignatario":U THEN RUN pi-imprime-campos-char(INPUT tt-processo-imp.nome-consignatario ).
            WHEN "#pi-nome-agente":U THEN RUN pi-imprime-campos-char(INPUT tt-processo-imp.nome-agente ).
            WHEN "#pi-cod-itiner":U THEN RUN pi-imprime-campos-int(INPUT tt-processo-imp.cod-itiner ).
            WHEN "#pi-cod-transportador":U THEN RUN pi-imprime-campos-int(INPUT tt-processo-imp.cod-transportador ).
            WHEN "#pi-des-via-transp":U THEN RUN pi-imprime-campos-char(INPUT tt-processo-imp.des-via-transp ).
            WHEN "#pi-cdn-corretor-cambio-import":U THEN RUN pi-imprime-campos-int(INPUT tt-processo-imp.cdn-corretor-cambio-import ).
            WHEN "#pi-cdn-despa-exter-import":U THEN RUN pi-imprime-campos-int(INPUT tt-processo-imp.cdn-despa-exter-import ).
            WHEN "#pi-cdn-segurad-import":U THEN RUN pi-imprime-campos-int(INPUT tt-processo-imp.cdn-segurad-import ).
            WHEN "#pi-cdn-corretor-import":U THEN RUN pi-imprime-campos-int(INPUT tt-processo-imp.cdn-corretor-import ).
            WHEN "#pi-cod-despachante":U THEN RUN pi-imprime-campos-int(INPUT tt-processo-imp.cod-despachante ).
            WHEN "#pi-cod-exportador":U THEN RUN pi-imprime-campos-int(INPUT tt-processo-imp.cod-exportador ).
            WHEN "#pi-cod-consignatario":U THEN RUN pi-imprime-campos-int(INPUT tt-processo-imp.cod-consignatario ).
            WHEN "#pi-cod-agente":U THEN RUN pi-imprime-campos-int(INPUT tt-processo-imp.cod-agente ).
            WHEN "#pi-nr-conhecimento":U THEN RUN pi-imprime-campos-char(INPUT tt-processo-imp.nr-conhecimento ).
            WHEN "#pi-carta-credito":U THEN RUN pi-imprime-campos-char(INPUT tt-processo-imp.carta-credito ).
            WHEN "#pi-destino-documentacao":U THEN RUN pi-imprime-campos-char(INPUT tt-processo-imp.destino-documentacao ).
            WHEN "#pi-regime-import":U THEN RUN pi-imprime-campos-int(INPUT tt-processo-imp.regime-import ).
            WHEN "#pi-estab-fisc":U THEN RUN pi-imprime-campos-char(INPUT tt-processo-imp.estab-fisc ).
            WHEN "#pi-contrato-cambio":U THEN RUN pi-imprime-campos-char(INPUT tt-processo-imp.contrato-cambio ).
        END CASE.

        IF NOT l-chave THEN DO:
        END.
    END.

    IF p-c-tabela = "ordem-compra":U THEN DO:
        CASE tt-matriz-ficha.c-linha:
            WHEN "#oc-num-pedido":U THEN RUN pi-imprime-campos-int(INPUT tt-ordem-compra.num-pedido ).
            WHEN "#oc-numero-ordem":U THEN RUN pi-imprime-campos-int(INPUT tt-ordem-compra.numero-ordem ).
            WHEN "#oc-it-codigo":U THEN RUN pi-imprime-campos-char(INPUT tt-ordem-compra.it-codigo ).
            WHEN "#oc-cod-estabel":U THEN RUN pi-imprime-campos-char(INPUT tt-ordem-compra.cod-estabel ).
            WHEN "#oc-cod-unid-negoc":U THEN RUN pi-imprime-campos-char(INPUT tt-ordem-compra.cod-unid-negoc ).
            WHEN "#oc-des-situacao":U THEN RUN pi-imprime-campos-char(INPUT tt-ordem-compra.des-situacao ).
            WHEN "#oc-des-ct-codigo":U THEN RUN pi-imprime-campos-char(INPUT tt-ordem-compra.des-ct-codigo ).
            WHEN "#oc-des-sc-codigo":U THEN RUN pi-imprime-campos-char(INPUT tt-ordem-compra.des-sc-codigo ).
            WHEN "#oc-des-cod-unid-negoc":U THEN RUN pi-imprime-campos-char(INPUT tt-ordem-compra.des-cod-unid-negoc ).
            WHEN "#oc-nr-contrato":U THEN RUN pi-imprime-campos-int(INPUT tt-ordem-compra.nr-contrato ).
            WHEN "#oc-des-moeda":U THEN RUN pi-imprime-campos-char(INPUT tt-ordem-compra.des-moeda ).
            WHEN "#oc-des-tp-despesa":U THEN RUN pi-imprime-campos-char(INPUT tt-ordem-compra.des-tp-despesa ).
            WHEN "#oc-requisitante":U THEN RUN pi-imprime-campos-char(INPUT tt-ordem-compra.requisitante ).
            WHEN "#oc-cod-comprado":U THEN RUN pi-imprime-campos-char(INPUT tt-ordem-compra.cod-comprado ).
            WHEN "#oc-ct-codigo":U THEN RUN pi-imprime-campos-char(INPUT tt-ordem-compra.ct-codigo ).
            WHEN "#oc-sc-codigo":U THEN RUN pi-imprime-campos-char(INPUT tt-ordem-compra.sc-codigo ).
            WHEN "#oc-tp-despesa":U THEN RUN pi-imprime-campos-int(INPUT tt-ordem-compra.tp-despesa ).
            WHEN "#oc-data-emissao":U THEN RUN pi-imprime-campos-date(INPUT tt-ordem-compra.data-emissao ).
            WHEN "#oc-num-seq-item":U THEN RUN pi-imprime-campos-int(INPUT tt-ordem-compra.num-seq-item ).
            WHEN "#oc-narrativa":U THEN RUN pi-imprime-campos-char(INPUT tt-ordem-compra.narrativa ).
            WHEN "#oc-data-cotacao":U THEN RUN pi-imprime-campos-date(INPUT tt-ordem-compra.data-cotacao ).
            WHEN "#oc-un":U THEN RUN pi-imprime-campos-char(INPUT tt-ordem-compra.un ).
            WHEN "#oc-mo-codigo":U THEN RUN pi-imprime-campos-int(INPUT tt-ordem-compra.mo-codigo ).
            WHEN "#oc-cod-incoterm":U THEN RUN pi-imprime-campos-char(INPUT tt-ordem-compra.cod-incoterm ).
            WHEN "#oc-cod-fabricante":U THEN RUN pi-imprime-campos-int(INPUT tt-ordem-compra.cod-fabricante ).
            WHEN "#oc-nome-abrev-fabricante":U THEN RUN pi-imprime-campos-char(INPUT tt-ordem-compra.nome-abrev-fabricante ).
            WHEN "#oc-nome-estabel":U THEN RUN pi-imprime-campos-char(INPUT tt-ordem-compra.nome-estabel ).
            WHEN "#oc-regime-impot":U THEN RUN pi-imprime-campos-int(INPUT tt-ordem-compra.regime-impot ).
            WHEN "#oc-cod-pto-controle-base":U THEN RUN pi-imprime-campos-int(INPUT tt-ordem-compra.cod-pto-controle-base ).
            WHEN "#oc-des-pto-controle-base":U THEN RUN pi-imprime-campos-char(INPUT tt-ordem-compra.des-pto-controle-base ).
            WHEN "#oc-mapa-cotacao":U THEN RUN pi-imprime-campos-int(INPUT tt-ordem-compra.mapa-cotacao ).
            WHEN "#oc-cdn-pais-orig":U THEN RUN pi-imprime-campos-int(INPUT tt-ordem-compra.cdn-pais-orig ).
            WHEN "#oc-des-pais-orig":U THEN RUN pi-imprime-campos-char(INPUT tt-ordem-compra.des-pais-orig ).
            WHEN "#oc-ex-tarifario":U THEN RUN pi-imprime-campos-log(INPUT tt-ordem-compra.ex-tarifario ).
            WHEN "#oc-cod-itinerario":U THEN RUN pi-imprime-campos-int(INPUT tt-ordem-compra.cod-itinerario ).
            WHEN "#oc-des-itinerario":U THEN RUN pi-imprime-campos-char(INPUT tt-ordem-compra.des-itinerario ).
        END CASE.

        IF NOT l-chave THEN DO:
            CASE tt-matriz-ficha.c-linha:
                WHEN "#oc-qt-solic":U THEN RUN pi-imprime-campos-dec(INPUT tt-ordem-compra.qt-solic ).
                WHEN "#oc-preco-unit":U THEN RUN pi-imprime-campos-dec(INPUT tt-ordem-compra.preco-unit ).
                WHEN "#oc-pre-unit-for":U THEN RUN pi-imprime-campos-dec(INPUT tt-ordem-compra.pre-unit-for ).
                WHEN "#oc-preco-fornec":U THEN RUN pi-imprime-campos-dec(INPUT tt-ordem-compra.preco-fornec ).
                WHEN "#oc-frete":U THEN RUN pi-imprime-campos-log(INPUT tt-ordem-compra.frete ).
                WHEN "#oc-valor-frete":U THEN RUN pi-imprime-campos-dec(INPUT tt-ordem-compra.valor-frete ).
                WHEN "#oc-aliquota-ipi":U THEN RUN pi-imprime-campos-dec(INPUT tt-ordem-compra.aliquota-ipi ).
                WHEN "#oc-aliquota-icm":U THEN RUN pi-imprime-campos-dec(INPUT tt-ordem-compra.aliquota-icm ).
                WHEN "#oc-aliquota-ii":U THEN RUN pi-imprime-campos-dec(INPUT tt-ordem-compra.aliquota-ii ).
                WHEN "#oc-valor-taxa":U THEN RUN pi-imprime-campos-dec(INPUT tt-ordem-compra.valor-taxa ).
                WHEN "#oc-perc-descto":U THEN RUN pi-imprime-campos-dec(INPUT tt-ordem-compra.perc-descto ).
                WHEN "#oc-valor-descto":U THEN RUN pi-imprime-campos-dec(INPUT tt-ordem-compra.valor-descto ).
            END CASE.
        END.
    END.

    IF p-c-tabela = "item":U THEN DO:
        CASE tt-matriz-ficha.c-linha:
            WHEN "#it-it-codigo":U THEN RUN pi-imprime-campos-char(INPUT tt-item.it-codigo ).
            WHEN "#it-desc-item":U THEN RUN pi-imprime-campos-char(INPUT tt-item.desc-item ).
            WHEN "#it-un":U THEN RUN pi-imprime-campos-char(INPUT tt-item.un ).
            WHEN "#it-fm-codigo":U THEN RUN pi-imprime-campos-char(INPUT tt-item.fm-codigo ).
            WHEN "#it-class-fiscal":U THEN RUN pi-imprime-campos-char(INPUT tt-item.class-fiscal ).
            WHEN "#it-ge-descricao":U THEN RUN pi-imprime-campos-char(INPUT tt-item.ge-descricao ).
            WHEN "#it-fm-descricao":U THEN RUN pi-imprime-campos-char(INPUT tt-item.fm-descricao ).
            WHEN "#it-narrativa":U THEN RUN pi-imprime-campos-char(INPUT tt-item.narrativa ).
            WHEN "#it-ge-codigo":U THEN RUN pi-imprime-campos-int(INPUT tt-item.ge-codigo ).
            WHEN "#it-inform-compl":U THEN RUN pi-imprime-campos-char(INPUT tt-item.inform-compl ).
            WHEN "#it-des-obsoleto":U THEN RUN pi-imprime-campos-char(INPUT tt-item.des-obsoleto ).
            WHEN "#it-des-codigo-orig":U THEN RUN pi-imprime-campos-char(INPUT tt-item.des-codigo-orig).
            WHEN "#it-des-tipo-contr":U THEN RUN pi-imprime-campos-char(INPUT tt-item.des-tipo-contr ).
        END CASE.
    END.

    IF p-c-tabela = "embarque-imp":U THEN DO:
        CASE tt-matriz-ficha.c-linha:
            WHEN "#emb-cod-estabel":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.cod-estabel ).
            WHEN "#emb-embarque":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.embarque ).
            WHEN "#emb-cod-transportador":U THEN RUN pi-imprime-campos-int(INPUT tt-embarque-imp.cod-transportador ).
            WHEN "#emb-des-via-transp":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.des-via-transp ).
            WHEN "#emb-cod-incoterm":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.cod-incoterm ).
            WHEN "#emb-declaracao-import":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.declaracao-import ).
            WHEN "#emb-data-DI":U THEN RUN pi-imprime-campos-date(INPUT tt-embarque-imp.data-DI ).
            WHEN "#emb-des-situacao":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.des-situacao ).
            WHEN "#emb-cod-despachante":U THEN RUN pi-imprime-campos-int(INPUT tt-embarque-imp.cod-despachante ).
            WHEN "#emb-carta-credito":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.carta-credito ).
            WHEN "#emb-narrativa":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.narrativa ).
            WHEN "#emb-embarque-ori":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.embarque-ori ).
            WHEN "#emb-cod-conhecto-master":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.cod-conhecto-master ).
            WHEN "#emb-cod-conhecto-house":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.cod-conhecto-house ).
            WHEN "#emb-cdn-corretor-cambio-import":U THEN RUN pi-imprime-campos-int(INPUT tt-embarque-imp.cdn-corretor-cambio-import ).
            WHEN "#emb-cdn-despa-exter-import":U THEN RUN pi-imprime-campos-int(INPUT tt-embarque-imp.cdn-despa-exter-import ).
            WHEN "#emb-cdn-segurad-import":U THEN RUN pi-imprime-campos-int(INPUT tt-embarque-imp.cdn-segurad-import ).
            WHEN "#emb-cdn-corretor-import":U THEN RUN pi-imprime-campos-int(INPUT tt-embarque-imp.cdn-corretor-import ).
            WHEN "#emb-cdn-pto-despch":U THEN RUN pi-imprime-campos-int(INPUT tt-embarque-imp.cdn-pto-despch ).
            WHEN "#emb-cdn-pto-embarq":U THEN RUN pi-imprime-campos-int(INPUT tt-embarque-imp.cdn-pto-embarq ).
            WHEN "#emb-cdn-pto-desembar":U THEN RUN pi-imprime-campos-int(INPUT tt-embarque-imp.cdn-pto-desembar ).
            WHEN "#emb-cdn-pto-chegad":U THEN RUN pi-imprime-campos-int(INPUT tt-embarque-imp.cdn-pto-chegad ).
            WHEN "#emb-nome-despachante":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.nome-despachante ).
            WHEN "#emb-nome-estabel":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.nome-estabel ).
            WHEN "#emb-nome-transportador":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.nome-transportador ).
            WHEN "#emb-nome-corretor-cambio":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.nome-corretor-cambio ).
            WHEN "#emb-nome-despa-exter":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.nome-despa-exter ).
            WHEN "#emb-nome-segurad":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.nome-segurad ).
            WHEN "#emb-nome-corretor":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.nome-corretor ).
            WHEN "#emb-des-pto-despch":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.des-pto-despch ).
            WHEN "#emb-des-pto-embarq":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.des-pto-embarq ).
            WHEN "#emb-des-pto-desembar":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.des-pto-desembar ).
            WHEN "#emb-des-pto-chegad":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.des-pto-chegad ).
            WHEN "#emb-des-natur-cambial":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.des-natur-cambial ).
            WHEN "#emb-di-ems":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.int-2 ).
            WHEN "#emb-rof":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.nr-rof ).
            WHEN "#emb-contabilizado":U THEN RUN pi-imprime-campos-log(INPUT tt-embarque-imp.contabilizado ).
            WHEN "#emb-pto-incoterm":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-imp.pto-incoterm ).
        END CASE.

        IF NOT l-chave THEN DO:
            IF tt-matriz-ficha.c-linha = "#emb-dias-transporte-total":U THEN
               RUN pi-imprime-campos-char(INPUT tt-embarque-imp.i-dias-total ).
        END.

    END.

    IF p-c-tabela = "prazo-compra":U THEN DO:
        CASE tt-matriz-ficha.c-linha:
            WHEN "#par-numero-ordem":U THEN RUN pi-imprime-campos-int(INPUT tt-prazo-compra.numero-ordem ).
            WHEN "#par-parcela":U THEN RUN pi-imprime-campos-int(INPUT tt-prazo-compra.parcela ).
            WHEN "#par-data-entrega":U THEN RUN pi-imprime-campos-date(INPUT tt-prazo-compra.data-entrega ).
            WHEN "#par-des-situacao":U THEN RUN pi-imprime-campos-char(INPUT tt-prazo-compra.des-situacao ).
            WHEN "#par-un":U THEN RUN pi-imprime-campos-char(INPUT tt-prazo-compra.un ).
            WHEN "#par-cod-refer":U THEN RUN pi-imprime-campos-char(INPUT tt-prazo-compra.cod-refer ).
            WHEN "#par-licenca-import":U THEN RUN pi-imprime-campos-char(INPUT tt-prazo-compra.licenca-import ).
        END CASE.

        IF NOT l-chave THEN DO:
            CASE tt-matriz-ficha.c-linha:
                WHEN "#par-quantidade":U THEN RUN pi-imprime-campos-dec(INPUT tt-prazo-compra.quantidade ).
                WHEN "#par-qtd-sal-forn":U THEN RUN pi-imprime-campos-dec(INPUT tt-prazo-compra.qtd-sal-forn ).
                WHEN "#par-quantid-orig":U THEN RUN pi-imprime-campos-dec(INPUT tt-prazo-compra.quantid-orig ).
                WHEN "#par-quant-saldo":U THEN RUN pi-imprime-campos-dec(INPUT tt-prazo-compra.quant-saldo ).
                WHEN "#par-quant-rejeit":U THEN RUN pi-imprime-campos-dec(INPUT tt-prazo-compra.quant-rejeit ).
                WHEN "#par-quant-receb":U THEN RUN pi-imprime-campos-dec(INPUT tt-prazo-compra.quant-receb ).
            END CASE.
        END.
    END.

    IF p-c-tabela = "historico-embarque":U THEN DO:
        CASE tt-matriz-ficha.c-linha:
            WHEN "#he-cod-estabel":U THEN RUN pi-imprime-campos-char(INPUT tt-historico-embarque.cod-estabel ).
            WHEN "#he-embarque":U THEN RUN pi-imprime-campos-char(INPUT tt-historico-embarque.embarque ).
            WHEN "#he-cod-itiner":U THEN RUN pi-imprime-campos-int(INPUT tt-historico-embarque.cod-itiner ).
            WHEN "#he-cod-pto-contr":U THEN RUN pi-imprime-campos-int(INPUT tt-historico-embarque.cod-pto-contr ).
            WHEN "#he-sequencia":U THEN RUN pi-imprime-campos-int(INPUT tt-historico-embarque.sequencia ).
            WHEN "#he-id-meio-transp":U THEN RUN pi-imprime-campos-char(INPUT tt-historico-embarque.id-meio-transp ).
            WHEN "#he-dt-previsao":U THEN RUN pi-imprime-campos-date(INPUT tt-historico-embarque.dt-previsao ).
            WHEN "#he-dt-ult-previsao":U THEN RUN pi-imprime-campos-date(INPUT tt-historico-embarque.dt-ult-previsao ).
            WHEN "#he-dt-efetiva":U THEN RUN pi-imprime-campos-date(INPUT tt-historico-embarque.dt-efetiva ).
            WHEN "#he-observacao":U THEN RUN pi-imprime-campos-char(INPUT tt-historico-embarque.observacao ).
            WHEN "#he-descricao":U THEN RUN pi-imprime-campos-char(INPUT tt-historico-embarque.descricao ).
            WHEN "#he-nr-dias":U THEN RUN pi-imprime-campos-int(INPUT tt-historico-embarque.nr-dias ).
            WHEN "#he-des-itiner":U THEN RUN pi-imprime-campos-char(INPUT tt-historico-embarque.des-itiner ).
            WHEN "#he-nome-estabel":U THEN RUN pi-imprime-campos-char(INPUT tt-historico-embarque.nome-estabel ).
        END CASE.
    END.

    IF p-c-tabela = "desp-embarque":U THEN DO:
        CASE tt-matriz-ficha.c-linha:
            WHEN "#de-cod-estabel":U THEN RUN pi-imprime-campos-char(INPUT tt-desp-embarque.cod-estabel ).
            WHEN "#de-embarque":U THEN RUN pi-imprime-campos-char(INPUT tt-desp-embarque.embarque ).
            WHEN "#de-cod-itiner":U THEN RUN pi-imprime-campos-int(INPUT tt-desp-embarque.cod-itiner ).
            WHEN "#de-cod-pto-contr":U THEN RUN pi-imprime-campos-int(INPUT tt-desp-embarque.cod-pto-contr ).
            WHEN "#de-cod-desp":U THEN RUN pi-imprime-campos-int(INPUT tt-desp-embarque.cod-desp ).
            WHEN "#de-cod-emitente-desp":U THEN RUN pi-imprime-campos-int(INPUT tt-desp-embarque.cod-emitente-desp ).
            WHEN "#de-cod-cond-pag":U THEN RUN pi-imprime-campos-int(INPUT tt-desp-embarque.cod-cond-pag ).
            WHEN "#de-val-desp":U THEN RUN pi-imprime-campos-dec(INPUT tt-desp-embarque.val-desp ).
            WHEN "#de-mo-codigo":U THEN RUN pi-imprime-campos-int(INPUT tt-desp-embarque.mo-codigo ).
            WHEN "#de-log-despes-ja-recbda":U THEN RUN pi-imprime-campos-log(INPUT tt-desp-embarque.log-despes-ja-recbda ).
            WHEN "#de-cod-incoterm-rat":U THEN RUN pi-imprime-campos-char(INPUT tt-desp-embarque.cod-incoterm-rat ).
            WHEN "#de-log-forma-preco-compra":U THEN RUN pi-imprime-campos-log(INPUT tt-desp-embarque.log-forma-preco-compra ).
            WHEN "#de-descricao":U THEN RUN pi-imprime-campos-char(INPUT tt-desp-embarque.descricao ).
            WHEN "#de-des-itiner":U THEN RUN pi-imprime-campos-char(INPUT tt-desp-embarque.des-itiner ).
            WHEN "#de-des-pto-contr":U THEN RUN pi-imprime-campos-char(INPUT tt-desp-embarque.des-pto-contr ).
            WHEN "#de-nome-emitente-desp":U THEN RUN pi-imprime-campos-char(INPUT tt-desp-embarque.nome-emitente-desp ).
            WHEN "#de-des-cond-pag":U THEN RUN pi-imprime-campos-char(INPUT tt-desp-embarque.des-cond-pag ).
            WHEN "#de-des-moeda":U THEN RUN pi-imprime-campos-char(INPUT tt-desp-embarque.des-moeda ).
            WHEN "#de-nome-estabel":U THEN RUN pi-imprime-campos-char(INPUT tt-desp-embarque.nome-estabel ).
        END CASE.
    END.

    IF p-c-tabela = "decla-import":U THEN DO:
        IF NOT AVAIL tt-decla-import-adic THEN
            FIND FIRST tt-decla-import-adic WHERE tt-decla-import-adic.num-di-ems       = tt-decla-import.num-di-ems
                                            AND   tt-decla-import-adic.cdd-siscomex-dts = tt-decla-import.cdd-siscomex-dts
                                            NO-LOCK NO-ERROR.
        CASE tt-matriz-ficha.c-linha:
            WHEN "#di-cod-estab":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import.cod-estab ).
            WHEN "#di-cod-di-siscomex":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import.cod-di-siscomex ).
            WHEN "#di-num-di-ems":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import.num-di-ems ).
            WHEN "#di-dat-di":U THEN RUN pi-imprime-campos-date(INPUT tt-decla-import.dat-di ).
            WHEN "#di-des-tip-decla-import":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import.des-tip-decla-import ).
            WHEN "#di-des-caract-operac":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import.des-caract-operac ).
            WHEN "#di-cdn-consign":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import.cdn-consign ).
            WHEN "#di-des-modalid-despch":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import.des-modalid-despch ).
            WHEN "#di-cdn-urf-entr":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import.cdn-urf-entr ).
            WHEN "#di-cdn-urf-despch":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import.cdn-urf-despch ).
            WHEN "#di-cdn-pais-proceden":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import.cdn-pais-proceden ).
            WHEN "#di-cdn-agent-carg-import":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import.cdn-agent-carg-import ).
            WHEN "#di-des-via-transp-di":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import.des-via-transp-di ).
            WHEN "#di-des-docto-carg":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import.des-docto-carg ).
            WHEN "#di-cod-identif":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import.cod-identif ).
            WHEN "#di-cdn-transpdor":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import.cdn-transpdor ).
            WHEN "#di-des-tip-conhecto":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import.des-tip-conhecto ).
            WHEN "#di-cod-conhecto-master":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import.cod-conhecto-master ).
            WHEN "#di-cod-conhecto-house":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import.cod-conhecto-house ).
            WHEN "#di-nome-consign":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import.nome-consign ).
            WHEN "#di-nome-agent-carg":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import.nome-agent-carg ).
            WHEN "#di-nome-transpdor":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import.nome-transpdor ).
            WHEN "#di-num-seq-retif":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import.num-seq-retif ).
            WHEN "#di-des-motiv-retif":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import.des-motiv-retif  ).
            WHEN "#di-dat-retif":U THEN RUN pi-imprime-campos-date(INPUT tt-decla-import.dat-retif ).
            WHEN "#di-log-fundap":U THEN RUN pi-imprime-campos-log(INPUT tt-decla-import.log-fundap).
            WHEN "#di-cod-natur-oper":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import.cod-natur-operac).
            WHEN "#di-des-natur-oper":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import.des-nat-operacao).
            WHEN "#di-util-conhecto":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import.des-util-conhecto).
            WHEN "#di-recinto-alfand":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import.cdn-recinto-alfand).
            WHEN "#di-setor-armazenamento":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import.cdn-setor-armaz).
        END CASE.
        IF NOT l-chave THEN DO:
            CASE tt-matriz-ficha.c-linha:
                WHEN "#di-val-peso-liq-di":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-peso-liq-di ).
                WHEN "#di-val-peso-brut-merc":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-peso-brut-merc ).
                WHEN "#di-val-peso-embal-di":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-peso-embal-di ).
                WHEN "#di-val-peso-brut-tot-di":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-peso-brut-tot-di ).
                WHEN "#di-val-vmld":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-vmld ).
                WHEN "#di-val-vmld-me":U THEN DO:
                    IF tt-decla-import-adic.cdn-moeda <> param-imp.int-2 THEN
                        RUN pi-imprime-campos-dec(INPUT  tt-decla-import.val-vmld-me[1]).
                    ELSE
                        RUN pi-imprime-campos-dec(INPUT  tt-decla-import.val-vmld-me[2]).
                END.
                WHEN "#di-val-vmle":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-vmle ).
                WHEN "#di-val-vmle-me":U THEN DO:
                    IF tt-decla-import-adic.cdn-moeda <> param-imp.int-2 THEN
                        RUN pi-imprime-campos-dec(INPUT  tt-decla-import.val-vmle-me[1]).
                    ELSE
                        RUN pi-imprime-campos-dec(INPUT  tt-decla-import.val-vmle-me[2]).
                END.
                WHEN "#di-val-vmcv":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-vmcv ).
                WHEN "#di-val-vmcv-me":U THEN DO:
                    IF tt-decla-import-adic.cdn-moeda <> param-imp.int-2 THEN
                        RUN pi-imprime-campos-dec(INPUT  tt-decla-import.val-vmcv-me[1]).
                    ELSE
                        RUN pi-imprime-campos-dec(INPUT  tt-decla-import.val-vmcv-me[2]).
                END.
                WHEN "#di-val-frete":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-frete ).
                WHEN "#di-val-frete-me":U THEN DO:
                    IF tt-decla-import-adic.cdn-moed-frete <> param-imp.int-2 THEN
                        RUN pi-imprime-campos-dec(INPUT  tt-decla-import.val-frete-me[1] ).
                    ELSE
                        RUN pi-imprime-campos-dec(INPUT  tt-decla-import.val-frete-me[2] ).
                END.
                WHEN "#di-val-seguro":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-seguro ).
                WHEN "#di-val-seguro-me":U THEN DO:
                    IF tt-decla-import-adic.cdn-moed-seguro <> param-imp.int-2 THEN
                        RUN pi-imprime-campos-dec(INPUT  tt-decla-import.val-seguro-me[1] ).
                    ELSE
                        RUN pi-imprime-campos-dec(INPUT  tt-decla-import.val-seguro-me[2] ).
                END.
                WHEN "#di-val-acresc":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-acresc ).
                WHEN "#di-val-acresc-me":U THEN RUN pi-imprime-campos-dec(INPUT  tt-decla-import.val-acresc-me[1] ).
                WHEN "#di-val-despes-nac":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-despes-nac ).
                WHEN "#di-val-despes-nac-me":U THEN RUN pi-imprime-campos-dec(INPUT  tt-decla-import.val-despes-nac-me[1] ).
                WHEN "#di-val-despes-di":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-despes-di ).
                WHEN "#di-val-despes-di-me":U THEN RUN pi-imprime-campos-dec(INPUT  tt-decla-import.val-despes-di-me[1] ).
                WHEN "#di-val-despes-compltar":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-despes-compltar ).
                WHEN "#di-val-despes-compltar-me":U THEN RUN pi-imprime-campos-dec(INPUT  tt-decla-import.val-despes-compltar-me[1] ).
                WHEN "#di-val-base-ii":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-base-ii).
                WHEN "#di-val-ii-suspenso":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-ii-nao-tribut).
                WHEN "#di-val-ii-recolher":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-ii-db-cr).
                WHEN "#di-val-ii-outros":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-ii-outras).
                WHEN "#di-val-base-ipi":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-base-ipi).
                WHEN "#di-val-ipi-suspenso":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-ipi-nao-tribut).
                WHEN "#di-val-ipi-recolher":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-ipi-db-cr).
                WHEN "#di-val-ipi-outros":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-ipi-outras).
                WHEN "#di-val-base-pis":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-base-pis).
                WHEN "#di-val-pis-suspenso":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-pis-nao-tribut).
                WHEN "#di-val-pis-recolher":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-pis-db-cr).
                WHEN "#di-val-pis-outros":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-pis-outras).
                WHEN "#di-val-base-cofins":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-base-cofins).
                WHEN "#di-val-cofins-suspenso":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-cofins-nao-tribut).
                WHEN "#di-val-cofins-recolher":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-cofins-db-cr).
                WHEN "#di-val-cofins-outros":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-cofins-outras).
                WHEN "#di-val-base-icms":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-base-icms).
                WHEN "#di-val-icms-suspenso":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-icms-nao-tribut).
                WHEN "#di-val-icms-recolher":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-icms-db-cr).
                WHEN "#di-val-icms-outros":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import.val-icms-outras).
            END CASE.
        END.
    END.

    IF p-c-tabela = "decla-import-adic":U THEN DO:

        CASE tt-matriz-ficha.c-linha:
            WHEN "#adi-num-di-ems":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import-adic.num-di-ems ).
            WHEN "#adi-num-adic":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import-adic.num-adic ).
            WHEN "#adi-cdn-fornec":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import-adic.cdn-fornec ).
            WHEN "#adi-log-emite-fabrican":U THEN RUN pi-imprime-campos-log(INPUT tt-decla-import-adic.log-emite-fabrican ).
            WHEN "#adi-cdn-fabrican":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import-adic.cdn-fabrican ).
            WHEN "#adi-cod-classif-fisc":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.cod-classif-fisc ).
            WHEN "#adi-cdn-classif-fisc-ex":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import-adic.cdn-classif-fisc-ex ).
            WHEN "#adi-cod-incoterm":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.cod-incoterm ).
            WHEN "#adi-cod-contrat-cambio":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.cod-contrat-cambio ).
            WHEN "#adi-cdn-modal-pagto":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import-adic.cdn-modal-pagto ).
            WHEN "#adi-cdn-moeda":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import-adic.cdn-moeda ).
            WHEN "#adi-cdn-corretor":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import-adic.cdn-corretor ).
            WHEN "#adi-cdn-banco":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import-adic.cdn-banco ).
            WHEN "#adi-cod-rof":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.cod-rof ).
            WHEN "#adi-cdn-agent":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import-adic.cdn-agent ).
            WHEN "#adi-cdn-bco-agent":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import-adic.cdn-bco-agent ).
            WHEN "#adi-cod-agenc-agent":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.cod-agenc-agent ).
            WHEN "#adi-cdn-moed-frete":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import-adic.cdn-moed-frete ).
            WHEN "#adi-cdn-moed-seguro":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import-adic.cdn-moed-seguro ).
            WHEN "#adi-cdn-acresc-moed":U THEN RUN pi-imprime-campos-int(INPUT param-imp.int-2 ).
            WHEN "#adi-cdn-moed-deduc":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import-adic.cdn-moed-deduc ).
            WHEN "#adi-dsl-compl-adic":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.dsl-compl-adic ).
            WHEN "#adi-cod-licenc-import":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.cod-licenc-import ).
            WHEN "#adi-des-natur-cambial":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.des-natur-cambial ).
            WHEN "#adi-nome-fabrican":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.nome-fabrican ).
            WHEN "#adi-des-modal-pagto":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.des-modal-pagto ).
            WHEN "#adi-des-moeda":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.des-moeda ).
            WHEN "#adi-nome-corretor":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.nome-corretor ).
            WHEN "#adi-nome-banco":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.nome-banco ).
            WHEN "#adi-nome-agent":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.nome-agent ).
            WHEN "#adi-des-moed-frete":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.des-moed-frete ).
            WHEN "#adi-des-moed-seguro":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.des-moed-seguro ).
            WHEN "#adi-des-acresc-moed":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.des-acresc-moed ).
            WHEN "#adi-des-moed-deduc":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.des-moed-deduc ).
            WHEN "#adi-nome-fornec":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.nome-fornec ).
            WHEN "#adi-naladi-sh":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.cdn-naladi-sist-harmon ).
            WHEN "#adi-naladi-ncca":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.cod-naladi-ncca ).
            WHEN "#adi-nbm":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.cod-nbm ).
            WHEN "#adi-acordo-aladi":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.cod-aladi ).
        END CASE.

        IF NOT l-chave THEN DO:
            CASE tt-matriz-ficha.c-linha:
                WHEN "#adi-val-peso-liq":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-peso-liq ).
                WHEN "#adi-qtd-ncm":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.qtd-ncm ).
                WHEN "#adi-val-vmcv":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-vmcv ).
                WHEN "#adi-val-vmcv-me":U THEN DO:
                    IF tt-decla-import-adic.cdn-moeda = 0 THEN
                        RUN pi-imprime-campos-dec(INPUT 0).
                    ELSE DO:
                        IF tt-decla-import-adic.cdn-moeda <> param-imp.int-2 THEN
                            RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-vmcv-me[2]).
                        ELSE
                            RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-vmcv-me[1]).
                    END.
                END.
                WHEN "#adi-val-cotac":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-cotac ).
                WHEN "#adi-val-vmle":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-vmle ).
                WHEN "#adi-val-vmle-me":U THEN DO:
                    IF tt-decla-import-adic.cdn-moeda = 0 THEN
                        RUN pi-imprime-campos-dec(INPUT 0).
                    ELSE DO:
                        IF tt-decla-import-adic.cdn-moeda <> param-imp.int-2 THEN
                            RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-vmle-me[2]).
                        ELSE
                            RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-vmle-me[1]).
                    END.
                END.
                WHEN "#adi-val-vmld":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-vmld ).
                WHEN "#adi-val-vmld-me":U THEN DO:
                    IF tt-decla-import-adic.cdn-moeda = 0 THEN
                        RUN pi-imprime-campos-dec(INPUT 0).
                    ELSE DO:
                        IF tt-decla-import-adic.cdn-moeda <> param-imp.int-2 THEN
                            RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-vmld-me[2]).
                        ELSE
                            RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-vmld-me[1]).
                    END.
                END.
                WHEN "#adi-val-frete":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-frete ).
                WHEN "#adi-val-frete-me":U THEN DO:
                    IF tt-decla-import-adic.cdn-moed-frete <> param-imp.int-2  THEN
                        RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-frete-me[1]).
                    ELSE
                        RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-frete-me[2]).
                END.
                WHEN "#adi-val-seguro":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-seguro ).
                WHEN "#adi-val-seguro-me":U THEN DO:
                    IF tt-decla-import-adic.cdn-moed-seguro <> param-imp.int-2  THEN
                        RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-seguro-me[1]).
                    ELSE
                        RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-seguro-me[2]).
                END.
                WHEN "#adi-val-acresc":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-acresc ).
                WHEN "#adi-val-acresc-me":U THEN DO:
                    IF tt-decla-import-adic.cdn-acresc-moed <> param-imp.int-2  THEN
                        RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-acresc-me[1]).
                    ELSE
                        RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-acresc-me[2]).
                END.
                WHEN "#adi-val-deduc":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-deduc ).
                WHEN "#adi-tributac-ii":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.des-tributac-ii ).
                WHEN "#adi-aliq-ii":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-aliq-ii ).
                WHEN "#adi-perc-red-ii":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-perc-reduc-impto-import ).
                WHEN "#adi-log-suspenso-ii":U THEN RUN pi-imprime-campos-log(INPUT tt-decla-import-adic.log-suspens-impto-import ).
                WHEN "#adi-val-base-ii":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-base-ii ).
                WHEN "#adi-val-ii-suspenso":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-ii-nao-tribut ).
                WHEN "#adi-val-ii-recolher":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-ii-db-cr ).
                WHEN "#adi-val-ii-outros":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-ii-outras ).
                WHEN "#adi-tributac-ipi":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.des-tributac-ipi ).
                WHEN "#adi-aliq-ipi":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-aliq-ipi ).
                WHEN "#adi-perc-red-ipi":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-perc-reduc-ipi ).
                WHEN "#adi-log-suspenso-ipi":U THEN RUN pi-imprime-campos-log(INPUT tt-decla-import-adic.log-suspens-ipi-import ).
                WHEN "#adi-val-base-ipi":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-base-ipi ).
                WHEN "#adi-val-ipi-suspenso":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-ipi-nao-tribut ).
                WHEN "#adi-val-ipi-recolher":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-ipi-db-cr ).
                WHEN "#adi-val-ipi-outros":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-ipi-outras ).
                WHEN "#adi-val-ipi-unit":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-unit-ipi ).
                WHEN "#adi-tributac-pis":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.des-tributac-pis ).
                WHEN "#adi-aliq-pis":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-aliq-pis ).
                WHEN "#adi-perc-red-pis":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-perc-reduc-pis ).
                WHEN "#adi-log-suspenso-pis":U THEN RUN pi-imprime-campos-log(INPUT tt-decla-import-adic.log-suspens-pis-import ).
                WHEN "#adi-val-base-pis":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-base-pis ).
                WHEN "#adi-val-pis-suspenso":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-pis-nao-tribut ).
                WHEN "#adi-val-pis-recolher":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-pis-db-cr ).
                WHEN "#adi-val-pis-outros":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-pis-outras ).
                WHEN "#adi-val-pis-unit":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-unit-pis ).
                WHEN "#adi-tributac-cofins":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.des-tributac-cofins ).
                WHEN "#adi-aliq-cofins":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-aliq-cofins ).
                WHEN "#adi-perc-red-cofins":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-perc-reduc-cofins ).
                WHEN "#adi-log-suspenso-cofins":U THEN RUN pi-imprime-campos-log(INPUT tt-decla-import-adic.log-suspens-cofins-import ).
                WHEN "#adi-val-base-cofins":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-base-cofins ).
                WHEN "#adi-val-cofins-suspenso":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-cofins-nao-tribut ).
                WHEN "#adi-val-cofins-recolher":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-cofins-db-cr ).
                WHEN "#adi-val-cofins-outros":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-cofins-outras ).
                WHEN "#adi-val-cofins-unit":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-unit-cofins ).
                WHEN "#adi-tributac-icms":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-adic.des-tributac-icms ).
                WHEN "#adi-aliq-icms":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-aliq-icms ).
                WHEN "#adi-perc-red-icms":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-perc-reduc-icms ).
                WHEN "#adi-log-suspenso-icms":U THEN RUN pi-imprime-campos-log(INPUT tt-decla-import-adic.log-suspens-icms-import ).
                WHEN "#adi-val-base-icms":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-base-icms ).
                WHEN "#adi-val-icms-suspenso":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-icms-nao-tribut ).
                WHEN "#adi-val-icms-recolher":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-icms-db-cr ).
                WHEN "#adi-val-icms-outros":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-adic.val-icms-outras ).
            END CASE.
        END.
    END.

    IF p-c-tabela = "decla-import-ord":U THEN DO:
        CASE tt-matriz-ficha.c-linha:
            WHEN "#odi-num-di-ems":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import-ord.num-di-ems ).
            WHEN "#odi-cod-estab":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-ord.cod-estab ).
            WHEN "#odi-cod-embarq":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-ord.cod-embarq ).
            WHEN "#odi-num-ordem":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import-ord.num-ordem ).
            WHEN "#odi-num-parcela":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import-ord.num-parcela ).
            WHEN "#odi-num-adic":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import-ord.num-adic ).
            WHEN "#odi-num-seq":U THEN RUN pi-imprime-campos-int(INPUT tt-decla-import-ord.num-seq ).
        END CASE.

        IF NOT l-chave THEN DO:
            CASE tt-matriz-ficha.c-linha:
                WHEN "#odi-qtd-item":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-ord.qtd-item ).
                WHEN "#odi-cod-unid-medid-item":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-ord.cod-unid-medid-item ).
                WHEN "#odi-val-peso-liq":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-ord.val-peso-liq ).
                WHEN "#odi-val-peso-brut-merc":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-ord.val-peso-brut-merc ).
                WHEN "#odi-val-peso-embal":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-ord.val-peso-embal ).
                WHEN "#odi-cod-licenc-import":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-ord.cod-licenc-import ).
                WHEN "#odi-qtd-fornec":U THEN RUN pi-imprime-campos-dec(INPUT tt-decla-import-ord.qtd-fornec ).
                WHEN "#odi-cod-unid-med-fornec":U THEN RUN pi-imprime-campos-char(INPUT tt-decla-import-ord.cod-unid-med-fornec ).
            END CASE.
        END.
    END.

    IF p-c-tabela = "histor-decla-import":U THEN DO:
        CASE tt-matriz-ficha.c-linha:
            WHEN "#hdi-num-di-ems":U THEN RUN pi-imprime-campos-int(INPUT tt-histor-decla-import.num-di-ems ).
            WHEN "#hdi-num-seq":U THEN RUN pi-imprime-campos-int(INPUT tt-histor-decla-import.num-seq ).
            WHEN "#hdi-cdn-pto-control":U THEN RUN pi-imprime-campos-int(INPUT tt-histor-decla-import.cdn-pto-control ).
            WHEN "#hdi-cod-meio-transp":U THEN RUN pi-imprime-campos-char(INPUT tt-histor-decla-import.cod-meio-transp ).
            WHEN "#hdi-dat-prev-origin":U THEN RUN pi-imprime-campos-date(INPUT tt-histor-decla-import.dat-prev-origin ).
            WHEN "#hdi-cdn-pto-nacionaliz":U THEN RUN pi-imprime-campos-int(INPUT tt-histor-decla-import.cdn-pto-nacionaliz ).
            WHEN "#hdi-dat-ult-prev":U THEN RUN pi-imprime-campos-date(INPUT tt-histor-decla-import.dat-ult-prev ).
            WHEN "#hdi-dat-efetiva":U THEN RUN pi-imprime-campos-date(INPUT tt-histor-decla-import.dat-efetiva ).
            WHEN "#hdi-cdn-pto-chegad":U THEN RUN pi-imprime-campos-int(INPUT tt-histor-decla-import.cdn-pto-chegad ).
            WHEN "#hdi-descricao":U THEN RUN pi-imprime-campos-char(INPUT tt-histor-decla-import.descricao ).
            WHEN "#hdi-nr-dias":U THEN RUN pi-imprime-campos-int(INPUT tt-histor-decla-import.nr-dias ).
            WHEN "#hdi-des-pto-nacionaliz":U THEN RUN pi-imprime-campos-char(INPUT tt-histor-decla-import.des-pto-nacionaliz ).
            WHEN "#hdi-des-pto-chegad":U THEN RUN pi-imprime-campos-char(INPUT tt-histor-decla-import.des-pto-chegad ).
        END CASE.
    END.

    IF p-c-tabela = "despes-decla-import":U THEN DO:
        CASE tt-matriz-ficha.c-linha:
            WHEN "#ddi-num-di-ems":U THEN RUN pi-imprime-campos-int(INPUT tt-despes-decla-import.num-di-ems ).
            WHEN "#ddi-cdn-pto-control":U THEN RUN pi-imprime-campos-int(INPUT tt-despes-decla-import.cdn-pto-control ).
            WHEN "#ddi-cdn-despes":U THEN RUN pi-imprime-campos-int(INPUT tt-despes-decla-import.cdn-despes ).
            WHEN "#ddi-cdn-emit-despes":U THEN RUN pi-imprime-campos-int(INPUT tt-despes-decla-import.cdn-emit-despes ).
            WHEN "#ddi-cdn-cond-pagto":U THEN RUN pi-imprime-campos-int(INPUT tt-despes-decla-import.cdn-cond-pagto ).
            WHEN "#ddi-val-despes":U THEN RUN pi-imprime-campos-dec(INPUT tt-despes-decla-import.val-despes ).
            WHEN "#ddi-cdn-moeda":U THEN RUN pi-imprime-campos-int(INPUT tt-despes-decla-import.cdn-moeda ).
            WHEN "#ddi-log-forma-preco-compra":U THEN RUN pi-imprime-campos-log(INPUT tt-despes-decla-import.log-forma-preco-compra ).
            WHEN "#ddi-cod-incoterm-rat":U THEN RUN pi-imprime-campos-char(INPUT tt-despes-decla-import.cod-incoterm-rat ).
            WHEN "#ddi-val-cotac-despes-compltar":U THEN RUN pi-imprime-campos-dec(INPUT tt-despes-decla-import.val-cotac-despes-compltar ).
            WHEN "#ddi-des-tip-incid-nf":U THEN RUN pi-imprime-campos-char(INPUT tt-despes-decla-import.des-tip-incid-nf ).
            WHEN "#ddi-log-incid-vmle":U THEN RUN pi-imprime-campos-log(INPUT tt-despes-decla-import.log-incid-vmle ).
            WHEN "#ddi-des-pto-control":U THEN RUN pi-imprime-campos-char(INPUT tt-despes-decla-import.des-pto-control ).
            WHEN "#ddi-des-despes":U THEN RUN pi-imprime-campos-char(INPUT tt-despes-decla-import.des-despes ).
            WHEN "#ddi-nome-emit-despes":U THEN RUN pi-imprime-campos-char(INPUT tt-despes-decla-import.nome-emit-despes ).
            WHEN "#ddi-des-cond-pagto":U THEN RUN pi-imprime-campos-char(INPUT tt-despes-decla-import.des-cond-pagto ).
            WHEN "#ddi-des-moeda":U THEN RUN pi-imprime-campos-char(INPUT tt-despes-decla-import.des-moeda ).
        END CASE.
    END.

    IF p-c-tabela = "docum-est":U THEN DO:
        CASE tt-matriz-ficha.c-linha:
            WHEN "#doc-serie-docto":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.serie-docto ).
            WHEN "#doc-nro-docto":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.nro-docto ).
            WHEN "#doc-cod-emitente":U THEN RUN pi-imprime-campos-int(INPUT tt-docum-est.cod-emitente ).
            WHEN "#doc-nat-operacao":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.nat-operacao ).
            WHEN "#doc-cod-estabel":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.cod-estabel ).
            WHEN "#doc-dt-emissao":U THEN RUN pi-imprime-campos-date(INPUT tt-docum-est.dt-emissao ).
            WHEN "#doc-des-esp-docto":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.des-esp-docto ).
            WHEN "#doc-dt-trans":U THEN RUN pi-imprime-campos-date(INPUT tt-docum-est.dt-trans ).
            WHEN "#doc-dt-atualiza":U THEN RUN pi-imprime-campos-date(INPUT tt-docum-est.dt-atualiza ).
            WHEN "#doc-ct-transit":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.ct-transit ).
            WHEN "#doc-sc-transit":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.sc-transit ).
            WHEN "#doc-des-ct-transit":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.des-ct-transit ).
            WHEN "#doc-des-sc-transit":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.des-sc-transit ).
            WHEN "#doc-des-tipo-docto":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.des-tipo-docto ).
            WHEN "#doc-des-via-transp":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.des-via-transp ).
            WHEN "#doc-CE-atual":U THEN RUN pi-imprime-campos-log(INPUT tt-docum-est.CE-atual ).
            WHEN "#doc-observacao":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.observacao ).
            WHEN "#doc-des-mod-frete":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.des-mod-frete ).
            WHEN "#doc-estab-fisc":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.estab-fisc ).
            WHEN "#doc-c-nr-invoice":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.c-nr-invoice ).
            WHEN "#doc-dt-entr-merc":U THEN RUN pi-imprime-campos-date(INPUT tt-docum-est.dt-entr-merc ).
            WHEN "#doc-mo-codigo":U THEN RUN pi-imprime-campos-int(INPUT tt-docum-est.mo-codigo ).
            WHEN "#doc-cotacao-dia":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est.cotacao-dia ).
            WHEN "#doc-des-tipo-nota":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.des-tipo-nota ).
            WHEN "#doc-esp-fiscal":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.esp-fiscal ).
            WHEN "#doc-embarque":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.embarque ).
            WHEN "#doc-declaracao-import":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.declaracao-import ).
            WHEN "#doc-log-draw-atlzdo":U THEN RUN pi-imprime-campos-log(INPUT tt-docum-est.log-draw-atlzdo ).
            WHEN "#doc-log-memorando":U THEN RUN pi-imprime-campos-log(INPUT tt-docum-est.log-memorando ).
            WHEN "#doc-des-modalid-transp":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.des-modalid-transp ).
            WHEN "#doc-cod-placa":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.cod-placa[1] ).
            WHEN "#doc-cod-uf-placa":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.cod-uf-placa[1] ).
            WHEN "#doc-nome-transp":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.nome-transp ).
            WHEN "#doc-cod-entrega":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.cod-entrega ).
            WHEN "#doc-endereco":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.endereco ).
            WHEN "#doc-bairro":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.bairro ).
            WHEN "#doc-cep":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.cep ).
            WHEN "#doc-cidade":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.cidade ).
            WHEN "#doc-uf":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.uf ).
            WHEN "#doc-pais":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.pais ).
            WHEN "#doc-cod-chave-aces-nf-eletro":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.cod-chave-aces-nf-eletro ).
            WHEN "#doc-log-tax-siscomex":U THEN RUN pi-imprime-campos-log(INPUT tt-docum-est.log-tax-siscomex ).
            WHEN "#doc-des-sit-nf-eletro":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.des-sit-nf-eletro ).
            WHEN "#doc-des-nat-operacao":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.des-nat-operacao ).
            WHEN "#doc-des-moeda":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.des-moeda ).
            WHEN "#doc-nome-estabel":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.nome-estabel ).
            WHEN "#doc-nome-emitente":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.nome-abrev ).
            WHEN "#doc-tipo-docto":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est.des-tipo-nota-imp ).
            WHEN "#doc-gera-prim-remes-mae":U THEN RUN pi-imprime-campos-log(INPUT tt-docum-est.log-gera-prim-remes-nf-mae ).
        END CASE.

        IF NOT l-chave THEN DO:
            CASE tt-matriz-ficha.c-linha:
                WHEN "#doc-tot-peso":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est.tot-peso ).
                WHEN "#doc-despesa-nota":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est.despesa-nota ).
                WHEN "#doc-valor-embal":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est.valor-embal ).
                WHEN "#doc-valor-frete":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est.valor-frete ).
                WHEN "#doc-valor-mercad":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est.valor-mercad ).
                WHEN "#doc-valor-outras":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est.valor-outras ).
                WHEN "#doc-valor-seguro":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est.valor-seguro ).
                WHEN "#doc-tot-desconto":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est.tot-desconto ).
                WHEN "#doc-taxa-conv-imp":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est.taxa-conv-imp ).
                WHEN "#doc-qt-tot-imp":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est.qt-tot-imp ).
                WHEN "#doc-valor-frete-me":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est.valor-frete-me ).
                WHEN "#doc-valor-seguro-me":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est.valor-seguro-me ).
                WHEN "#doc-valor-embal-me":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est.valor-embal-me ).
                WHEN "#doc-valor-outras-me":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est.valor-outras-me ).
                WHEN "#doc-tot-desconto-me":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est.tot-desconto-me ).
                WHEN "#doc-tot-valor-me":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est.tot-valor-me ).
                WHEN "#doc-valor-mercad-me":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est.valor-mercad-me ).
                WHEN "#doc-despesa-nota-me":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est.despesa-nota-me ).
                WHEN "#doc-tot-taxa-me":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est.tot-taxa-me ).
                WHEN "#doc-peso-bruto-tot":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est.peso-bruto-tot ).
                WHEN "#doc-peso-liquido-tot":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est.tot-peso ).
            END CASE.
        END.
    END.

    IF  p-c-tabela = "item-doc-est":U THEN DO:
        CASE tt-matriz-ficha.c-linha:
            WHEN "#itd-serie-docto":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.serie-docto ).
            WHEN "#itd-nro-docto":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.nro-docto ).
            WHEN "#itd-cod-emitente":U THEN RUN pi-imprime-campos-int(INPUT tt-item-doc-est.cod-emitente ).
            WHEN "#itd-nat-operacao":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.nat-operacao ).
            WHEN "#itd-class-fiscal":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.class-fiscal ).
            WHEN "#itd-nat-of":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.nat-of ).
            WHEN "#itd-it-codigo":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.it-codigo ).
            WHEN "#itd-des-it-codigo":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.des-it-codigo ).
            WHEN "#itd-sequencia":U THEN RUN pi-imprime-campos-int(INPUT tt-item-doc-est.sequencia ).
            WHEN "#itd-cod-refer":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.cod-refer ).
            WHEN "#itd-un":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.un ).
            WHEN "#itd-des-trib-icm":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.des-trib-icm ).
            WHEN "#itd-des-trib-ipi":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.des-trib-ipi ).
            WHEN "#itd-componente":U THEN RUN pi-imprime-campos-log(INPUT tt-item-doc-est.componente ).
            WHEN "#itd-ct-codigo":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.ct-codigo ).
            WHEN "#itd-sc-codigo":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.sc-codigo ).
            WHEN "#itd-des-ct-codigo":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.des-ct-codigo ).
            WHEN "#itd-des-sc-codigo":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.des-sc-codigo ).
            WHEN "#itd-dt-vali-lote":U THEN RUN pi-imprime-campos-date(INPUT tt-item-doc-est.dt-vali-lote ).
            WHEN "#itd-nat-comp":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.nat-comp ).
            WHEN "#itd-num-pedido":U THEN RUN pi-imprime-campos-int(INPUT tt-item-doc-est.num-pedido ).
            WHEN "#itd-numero-ordem":U THEN RUN pi-imprime-campos-int(INPUT tt-item-doc-est.numero-ordem ).
            WHEN "#itd-parcela":U THEN RUN pi-imprime-campos-int(INPUT tt-item-doc-est.parcela ).
            WHEN "#itd-narrativa":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.narrativa ).
            WHEN "#itd-baixa-ce":U THEN RUN pi-imprime-campos-log(INPUT tt-item-doc-est.baixa-ce ).
            WHEN "#itd-c-nr-invoice":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.c-nr-invoice ).
            WHEN "#itd-i-seq-inv":U THEN RUN pi-imprime-campos-int(INPUT tt-item-doc-est.i-seq-inv ).
            WHEN "#itd-cod-esp":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.cod-esp ).
            WHEN "#itd-cota-moeda":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.cota-moeda[1] ).
            WHEN "#itd-data":U THEN RUN pi-imprime-campos-date(INPUT tt-item-doc-est.data ).
            WHEN "#itd-est-cob":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.est-cob ).
            WHEN "#itd-nr-ato-concessorio":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.nr-ato-concessorio ).
            WHEN "#itd-nr-proc-imp":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.nr-proc-imp ).
            WHEN "#itd-declaracao-import":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.declaracao-import ).
            WHEN "#itd-des-tributac-cofins":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.des-tributac-cofins ).
            WHEN "#itd-des-tributac-pis":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.des-tributac-pis ).
            WHEN "#itd-num-ord-import":U THEN RUN pi-imprime-campos-int(INPUT tt-item-doc-est.num-ord-import ).
            WHEN "#itd-num-parc-import":U THEN RUN pi-imprime-campos-int(INPUT tt-item-doc-est.num-parc-import ).
            WHEN "#itd-cod-unid-negoc":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.cod-unid-negoc ).
            WHEN "#itd-log-gerou-ncredito":U THEN RUN pi-imprime-campos-log(INPUT tt-item-doc-est.log-gerou-ncredito ).
            WHEN "#itd-log-nota-ajust-import":U THEN RUN pi-imprime-campos-log(INPUT tt-item-doc-est.log-nota-ajust-import ).
            WHEN "#itd-gera-prim-remes-mae":U THEN RUN pi-imprime-campos-log(INPUT tt-item-doc-est.log-gera-prim-remes-nf-mae ).
        END CASE.

        /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-965) */
        IF  l-nt2024002 THEN DO:
            IF  tt-matriz-ficha.c-linha = "#itd-class-trib-cbs":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.class-trib-cbs).
            IF  tt-matriz-ficha.c-linha = "#itd-cst-cbs":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.cst-cbs).
            IF  tt-matriz-ficha.c-linha = "#itd-aliquota-cbs":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.aliquota-cbs).
            IF  tt-matriz-ficha.c-linha = "#itd-base-cbs":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.base-cbs).
            IF  tt-matriz-ficha.c-linha = "#itd-val-cbs":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.val-cbs).
            IF  tt-matriz-ficha.c-linha = "#itd-class-trib-ibs-uf":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.class-trib-ibs-uf).
            IF  tt-matriz-ficha.c-linha = "#itd-cst-ibs-uf":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.cst-ibs-uf).
            IF  tt-matriz-ficha.c-linha = "#itd-aliquota-ibs-uf":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.aliquota-ibs-uf).
            IF  tt-matriz-ficha.c-linha = "#itd-base-ibs-uf":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.base-ibs-uf).
            IF  tt-matriz-ficha.c-linha = "#itd-val-ibs-uf":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.val-ibs-uf).
            IF tt-matriz-ficha.c-linha = "#itd-class-trib-ibs-mun":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.class-trib-ibs-mun).
            IF tt-matriz-ficha.c-linha = "#itd-cst-ibs-mun":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.cst-ibs-mun).
            IF tt-matriz-ficha.c-linha = "#itd-aliquota-ibs-mun":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.aliquota-ibs-mun).  
            IF tt-matriz-ficha.c-linha = "#itd-base-ibs-mun":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.base-ibs-mun).  
            IF tt-matriz-ficha.c-linha = "#itd-val-ibs-mun":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.val-ibs-mun).
            IF tt-matriz-ficha.c-linha = "#itd-class-trib-is":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.class-trib-is).   
            IF tt-matriz-ficha.c-linha = "#itd-cst-is":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est.cst-is).     
            IF tt-matriz-ficha.c-linha = "#itd-aliquota-is":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.aliquota-is).  
            IF tt-matriz-ficha.c-linha = "#itd-aliq-espec-un-is":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.aliq-espec-un-is).  
            IF tt-matriz-ficha.c-linha = "#itd-qtde-tribut-is":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.qtde-tribut-is).  
            IF tt-matriz-ficha.c-linha = "#itd-base-is":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.base-is).  
            IF tt-matriz-ficha.c-linha = "#itd-val-is":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.val-is).
        END.
        /* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-965) */

        IF  NOT l-chave THEN DO:
            RUN recupera-aliquotas IN h-cdapi995 (INPUT "item-doc-est",
                                                  INPUT tt-item-doc-est.serie-docto + "/" +
                                                        tt-item-doc-est.nro-docto + "/" +
                                                        STRING(tt-item-doc-est.cod-emitente) + "/" +
                                                        tt-item-doc-est.nat-operacao + "/" +
                                                        STRING(tt-item-doc-est.sequencia),
                                                  OUTPUT de-aliquota-pis,
                                                  OUTPUT de-aliquota-cofins).
            IF de-aliquota-pis = 0 THEN ASSIGN de-aliquota-pis = tt-item-doc-est.val-aliq-pis.
            IF de-aliquota-cofins = 0 THEN ASSIGN de-aliquota-cofins = tt-item-doc-est.val-aliq-cofins.

            CASE tt-matriz-ficha.c-linha:
                WHEN "#itd-peso-liquido":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.peso-liquido ).
                WHEN "#itd-quantidade":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.quantidade ).
                WHEN "#itd-aliquota-ipi":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.aliquota-ipi ).
                WHEN "#itd-aliquota-icm":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.aliquota-icm ).
                WHEN "#itd-base-ipi":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.base-ipi[1] ).
                WHEN "#itd-base-icm":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.base-icm[1] ).
                WHEN "#itd-despesas":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.despesas[1] ).
                WHEN "#itd-ipi-outras":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.ipi-outras[1] ).
                WHEN "#itd-icm-outras":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.icm-outras[1] ).
                WHEN "#itd-valor-ipi":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.valor-ipi[1] ).
                WHEN "#itd-valor-icm":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.valor-icm[1] ).
                WHEN "#itd-preco-unit":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.preco-unit[1] ).
                WHEN "#itd-preco-total":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.preco-total[1] ).
                WHEN "#itd-icm-complem":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.icm-complem[1] ).
                WHEN "#itd-desconto":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.desconto[1] ).
                WHEN "#itd-qt-do-forn":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.qt-do-forn ).
                WHEN "#itd-vl-imp-impor":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.vl-imp-impor[1] ).
                WHEN "#itd-vl-taxa":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.vl-taxa ).
                WHEN "#itd-cod-tax":U THEN RUN pi-imprime-campos-int(INPUT tt-item-doc-est.cod-tax ).
                WHEN "#itd-preco-unit-me":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.preco-unit-me ).
                WHEN "#itd-preco-total-me":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.preco-total-me ).
                WHEN "#itd-desconto-me":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.desconto-me ).
                WHEN "#itd-despesas-me":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.despesas-me[1] ).
                WHEN "#itd-valor-frete":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.valor-frete ).
                WHEN "#itd-peso-bruto-item":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.peso-bruto-item ).
                WHEN "#itd-peso-liquido-item":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.peso-liquido-item ).
                WHEN "#itd-val-aliq-cofins":U THEN RUN pi-imprime-campos-dec(INPUT de-aliquota-cofins ).
                WHEN "#itd-val-base-calc-cofins":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.val-base-calc-cofins ).
                WHEN "#itd-val-cofins":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.val-cofins ).
                WHEN "#itd-val-aliq-pis":U THEN RUN pi-imprime-campos-dec(INPUT de-aliquota-pis ).
                WHEN "#itd-base-pis":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.base-pis ).
                WHEN "#itd-valor-pis":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.valor-pis ).
                WHEN "#itd-val-aduana-pis":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.val-aduana-pis ).
                WHEN "#itd-val-despes-aduana-pis":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.val-despes-aduana-pis ).
                WHEN "#itd-val-aliq-impto-import":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.val-aliq-impto-import ).
                WHEN "#itd-val-aliq-ext-ipi":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.val-aliq-ext-ipi ).
                WHEN "#itd-val-aliq-ext-pis":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.val-aliq-ext-pis ).
                WHEN "#itd-val-aliq-ext-cofins":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.val-aliq-ext-cofins ).
                WHEN "#itd-val-aliq-ext-icms":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.val-aliq-ext-icms ).
                WHEN "#itd-val-aduana-cofins":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.val-aduana-cofins ).
                WHEN "#itd-val-despes-aduana-cofins":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.val-despes-aduana-cofins ).
                WHEN "#itd-val-unit-pis-import":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.val-unit-pis-import ).
                WHEN "#itd-val-unit-vol-pis-import":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.val-unit-vol-pis-import ).
                WHEN "#itd-val-unit-cofins-import":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.val-unit-cofins-import ).
                WHEN "#itd-val-unit-vol-cofins-import":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.val-unit-vol-cofins-import ).
                WHEN "#itd-val-reduc-cofins-import":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.val-reduc-cofins-import ).
                WHEN "#itd-val-reduc-pis-import":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est.val-reduc-pis-import ).
            END CASE.
        END.
    END.

    IF p-c-tabela = "rat-lote":U THEN DO:
        CASE tt-matriz-ficha.c-linha:
            WHEN "#lot-serie-docto":U THEN RUN pi-imprime-campos-char(INPUT tt-rat-lote.serie-docto ).
            WHEN "#lot-nro-docto":U THEN RUN pi-imprime-campos-char(INPUT tt-rat-lote.nro-docto ).
            WHEN "#lot-cod-emitente":U THEN RUN pi-imprime-campos-int(INPUT tt-rat-lote.cod-emitente ).
            WHEN "#lot-nat-operacao":U THEN RUN pi-imprime-campos-char(INPUT tt-rat-lote.nat-operacao ).
            WHEN "#lot-sequencia":U THEN RUN pi-imprime-campos-int(INPUT tt-rat-lote.sequencia ).
            WHEN "#lot-it-codigo":U THEN RUN pi-imprime-campos-char(INPUT tt-rat-lote.it-codigo ).
            WHEN "#lot-cod-refer":U THEN RUN pi-imprime-campos-char(INPUT tt-rat-lote.cod-refer ).
            WHEN "#lot-cod-depos":U THEN RUN pi-imprime-campos-char(INPUT tt-rat-lote.cod-depos ).
            WHEN "#lot-lote":U THEN RUN pi-imprime-campos-char(INPUT tt-rat-lote.lote ).
            WHEN "#lot-cod-localiz":U THEN RUN pi-imprime-campos-char(INPUT tt-rat-lote.cod-localiz ).
            WHEN "#lot-cod-lote-fabrican":U THEN RUN pi-imprime-campos-char(INPUT tt-rat-lote.cod-lote-fabrican ).
            WHEN "#lot-dt-vali-lote":U THEN RUN pi-imprime-campos-date(INPUT tt-rat-lote.dt-vali-lote ).
            WHEN "#lot-quantidade":U THEN RUN pi-imprime-campos-dec(INPUT tt-rat-lote.quantidade ).
            WHEN "#lot-des-tipo-nota":U THEN RUN pi-imprime-campos-char(INPUT tt-rat-lote.des-tipo-nota ).
            WHEN "#lot-vl-movto":U THEN RUN pi-imprime-campos-dec(INPUT tt-rat-lote.vl-movto ).
            WHEN "#lot-dat-valid-lote-fabrican":U THEN RUN pi-imprime-campos-date(INPUT tt-rat-lote.dat-valid-lote-fabrican ).
            WHEN "#lot-dat-fabricc-lote":U THEN RUN pi-imprime-campos-date(INPUT tt-rat-lote.dat-fabricc-lote ).
            WHEN "#lot-cdn-fabrican":U THEN RUN pi-imprime-campos-char(INPUT tt-rat-lote.cdn-fabrican ).
            WHEN "#lot-nom-fabrican":U THEN RUN pi-imprime-campos-char(INPUT tt-rat-lote.nom-fabrican ).
            WHEN "#lot-cod-lote-orig":U THEN RUN pi-imprime-campos-char(INPUT tt-rat-lote.cod-lote-orig ).
        END CASE.
    END.

    IF p-c-tabela = "docum-est-cex":U THEN DO:
        CASE tt-matriz-ficha.c-linha:
            WHEN "#des-serie-docto":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est-cex.serie-docto ).
            WHEN "#des-nro-docto":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est-cex.nro-docto ).
            WHEN "#des-cod-emitente":U THEN RUN pi-imprime-campos-int(INPUT tt-docum-est-cex.cod-emitente ).
            WHEN "#des-nat-operacao":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est-cex.nat-operacao ).
            WHEN "#des-cod-emitente-desp":U THEN RUN pi-imprime-campos-int(INPUT tt-docum-est-cex.cod-emitente-desp ).
            WHEN "#des-cod-desp":U THEN RUN pi-imprime-campos-int(INPUT tt-docum-est-cex.cod-desp ).
            WHEN "#des-val-desp":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est-cex.val-desp ).
            WHEN "#des-cod-cond-pag":U THEN RUN pi-imprime-campos-int(INPUT tt-docum-est-cex.cod-cond-pag ).
            WHEN "#des-mo-codigo":U THEN RUN pi-imprime-campos-int(INPUT tt-docum-est-cex.mo-codigo ).
            WHEN "#des-cotacao":U THEN RUN pi-imprime-campos-dec(INPUT tt-docum-est-cex.cotacao ).
            WHEN "#des-nome-emitente-desp":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est-cex.nome-emitente-desp ).
            WHEN "#des-des-desp":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est-cex.des-desp ).
            WHEN "#des-des-cond-pag":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est-cex.des-cond-pag ).
            WHEN "#des-des-moeda":U THEN RUN pi-imprime-campos-char(INPUT tt-docum-est-cex.des-moeda ).
        END CASE.
    END.

    IF p-c-tabela = "dupli-apagar":U THEN DO:
        CASE tt-matriz-ficha.c-linha:
            WHEN "#dup-serie-docto":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar.serie-docto ).
            WHEN "#dup-nro-docto":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar.nro-docto ).
            WHEN "#dup-cod-emitente":U THEN RUN pi-imprime-campos-int(INPUT tt-dupli-apagar.cod-emitente ).
            WHEN "#dup-nat-operacao":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar.nat-operacao ).
            WHEN "#dup-ep-codigo":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar.ep-codigo ).
            WHEN "#dup-cod-estabel":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar.cod-estabel ).
            WHEN "#dup-cod-esp":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar.cod-esp ).
            WHEN "#dup-parcela":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar.parcela ).
            WHEN "#dup-dt-emissao":U THEN RUN pi-imprime-campos-date(INPUT tt-dupli-apagar.dt-emissao ).
            WHEN "#dup-dt-trans":U THEN RUN pi-imprime-campos-date(INPUT tt-dupli-apagar.dt-trans ).
            WHEN "#dup-dt-vencim":U THEN RUN pi-imprime-campos-date(INPUT tt-dupli-apagar.dt-vencim ).
            WHEN "#dup-vl-a-pagar":U THEN RUN pi-imprime-campos-dec(INPUT tt-dupli-apagar.vl-a-pagar ).
            WHEN "#dup-dt-venc-desc":U THEN RUN pi-imprime-campos-date(INPUT tt-dupli-apagar.dt-venc-desc ).
            WHEN "#dup-des-esp-movto":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar.des-esp-movto ).
            WHEN "#dup-estado-cq":U THEN RUN pi-imprime-campos-int(INPUT tt-dupli-apagar.estado-cq ).
            WHEN "#dup-desconto":U THEN RUN pi-imprime-campos-dec(INPUT tt-dupli-apagar.desconto ).
            WHEN "#dup-vl-desconto":U THEN RUN pi-imprime-campos-dec(INPUT tt-dupli-apagar.vl-desconto ).
            WHEN "#dup-nr-duplic":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar.nr-duplic ).
            WHEN "#dup-observacao":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar.observacao ).
            WHEN "#dup-perc-juros":U THEN RUN pi-imprime-campos-dec(INPUT tt-dupli-apagar.perc-juros ).
            WHEN "#dup-dias-atraso":U THEN RUN pi-imprime-campos-dec(INPUT tt-dupli-apagar.dias-atraso ).
            WHEN "#dup-perc-mora":U THEN RUN pi-imprime-campos-dec(INPUT tt-dupli-apagar.perc-mora ).
            WHEN "#dup-tp-despesa":U THEN RUN pi-imprime-campos-int(INPUT tt-dupli-apagar.tp-despesa ).
            WHEN "#dup-vl-taxa":U THEN RUN pi-imprime-campos-dec(INPUT tt-dupli-apagar.vl-taxa ).
            WHEN "#dup-vl-frete":U THEN RUN pi-imprime-campos-dec(INPUT tt-dupli-apagar.vl-frete ).
            WHEN "#dup-vl-outros":U THEN RUN pi-imprime-campos-dec(INPUT tt-dupli-apagar.vl-outros ).
            WHEN "#dup-mo-codigo":U THEN RUN pi-imprime-campos-int(INPUT tt-dupli-apagar.mo-codigo ).
            WHEN "#dup-vl-a-pagar-mo":U THEN RUN pi-imprime-campos-dec(INPUT tt-dupli-apagar.vl-a-pagar-mo ).
            WHEN "#dup-vl-descto-mo":U THEN RUN pi-imprime-campos-dec(INPUT tt-dupli-apagar.vl-descto-mo ).
            WHEN "#dup-des-tp-despesa":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar.des-tp-despesa ).
            WHEN "#dup-des-moeda":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar.des-moeda ).
            WHEN "#dup-mo-codigo-mo":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar.mo-codigo-mo ).
            WHEN "#dup-des-moeda-mo":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar.des-moeda-mo ).
        END CASE.
    END.

    IF p-c-tabela = "dupli-apagar-cex":U THEN DO:
        CASE tt-matriz-ficha.c-linha:
            WHEN "#dpd-serie-docto":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar-cex.serie-docto ).
            WHEN "#dpd-nro-docto":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar-cex.nro-docto ).
            WHEN "#dpd-cod-emitente":U THEN RUN pi-imprime-campos-int(INPUT tt-dupli-apagar-cex.cod-emitente ).
            WHEN "#dpd-nat-operacao":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar-cex.nat-operacao ).
            WHEN "#dpd-cod-emitente-desp":U THEN RUN pi-imprime-campos-int(INPUT tt-dupli-apagar-cex.cod-emitente-desp ).
            WHEN "#dpd-cod-esp":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar-cex.cod-esp ).
            WHEN "#dpd-parcela":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar-cex.parcela ).
            WHEN "#dpd-dt-emissao":U THEN RUN pi-imprime-campos-date(INPUT tt-dupli-apagar-cex.dt-emissao ).
            WHEN "#dpd-dt-trans":U THEN RUN pi-imprime-campos-date(INPUT tt-dupli-apagar-cex.dt-trans ).
            WHEN "#dpd-dt-vencim":U THEN RUN pi-imprime-campos-date(INPUT tt-dupli-apagar-cex.dt-vencim ).
            WHEN "#dpd-vl-a-pagar":U THEN RUN pi-imprime-campos-dec(INPUT tt-dupli-apagar-cex.vl-a-pagar ).
            WHEN "#dpd-desconto":U THEN RUN pi-imprime-campos-dec(INPUT tt-dupli-apagar-cex.desconto ).
            WHEN "#dpd-dt-venc-desc":U THEN RUN pi-imprime-campos-date(INPUT tt-dupli-apagar-cex.dt-venc-desc ).
            WHEN "#dpd-des-esp-movto":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar-cex.des-esp-movto ).
            WHEN "#dpd-vl-desconto":U THEN RUN pi-imprime-campos-dec(INPUT tt-dupli-apagar-cex.vl-desconto ).
            WHEN "#dpd-nr-duplic":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar-cex.nr-duplic ).
            WHEN "#dpd-observacao":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar-cex.observacao ).
            WHEN "#dpd-perc-juros":U THEN RUN pi-imprime-campos-dec(INPUT tt-dupli-apagar-cex.perc-juros ).
            WHEN "#dpd-dias-atraso":U THEN RUN pi-imprime-campos-int(INPUT tt-dupli-apagar-cex.dias-atraso ).
            WHEN "#dpd-perc-mora":U THEN RUN pi-imprime-campos-dec(INPUT tt-dupli-apagar-cex.perc-mora ).
            WHEN "#dpd-tp-despesa":U THEN RUN pi-imprime-campos-int(INPUT tt-dupli-apagar-cex.tp-despesa ).
            WHEN "#dpd-historico":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar-cex.historico ).
            WHEN "#dpd-vl-taxa":U THEN RUN pi-imprime-campos-dec(INPUT tt-dupli-apagar-cex.vl-taxa ).
            WHEN "#dpd-vl-frete":U THEN RUN pi-imprime-campos-dec(INPUT tt-dupli-apagar-cex.vl-frete ).
            WHEN "#dpd-vl-outros":U THEN RUN pi-imprime-campos-dec(INPUT tt-dupli-apagar-cex.vl-outros ).
            WHEN "#dpd-valor-a-pagar-me":U THEN RUN pi-imprime-campos-dec(INPUT tt-dupli-apagar-cex.valor-a-pagar-me ).
            WHEN "#dpd-mo-codigo":U THEN RUN pi-imprime-campos-int(INPUT tt-dupli-apagar-cex.mo-codigo ).
            WHEN "#dpd-vl-a-pagar-mo":U THEN RUN pi-imprime-campos-dec(INPUT tt-dupli-apagar-cex.vl-a-pagar-mo ).
            WHEN "#dpd-nome-emitente-desp":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar-cex.nome-emitente-desp ).
            WHEN "#dpd-des-tp-despesa":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar-cex.des-tp-despesa ).
            WHEN "#dpd-des-moeda":U THEN RUN pi-imprime-campos-char(INPUT tt-dupli-apagar-cex.des-moeda ).
        END CASE.
    END.

    IF p-c-tabela = "item-doc-est-cex":U THEN DO:
        CASE tt-matriz-ficha.c-linha:
            WHEN "#did-serie-docto":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est-cex.serie-docto ).
            WHEN "#did-nro-docto":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est-cex.nro-docto ).
            WHEN "#did-cod-emitente":U THEN RUN pi-imprime-campos-int(INPUT tt-item-doc-est-cex.cod-emitente ).
            WHEN "#did-nat-operacao":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est-cex.nat-operacao ).
            WHEN "#did-sequencia":U THEN RUN pi-imprime-campos-int(INPUT tt-item-doc-est-cex.sequencia ).
            WHEN "#did-cod-emitente-desp":U THEN RUN pi-imprime-campos-int(INPUT tt-item-doc-est-cex.cod-emitente-desp ).
            WHEN "#did-cod-desp":U THEN RUN pi-imprime-campos-int(INPUT tt-item-doc-est-cex.cod-desp ).
            WHEN "#did-mo-codigo":U THEN RUN pi-imprime-campos-int(INPUT tt-item-doc-est-cex.mo-codigo ).
            WHEN "#did-cotacao":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est-cex.cotacao ).
            WHEN "#did-embarque":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est-cex.embarque ).
            WHEN "#did-cod-estabel":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est-cex.cod-estabel ).
            WHEN "#did-num-seq-orig":U THEN RUN pi-imprime-campos-int(INPUT tt-item-doc-est-cex.num-seq-orig ).
            WHEN "#did-dat-cotac":U THEN RUN pi-imprime-campos-date(INPUT tt-item-doc-est-cex.dat-cotac ).
            WHEN "#did-des-sit-despes":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est-cex.des-sit-despes ).
            WHEN "#did-nome-emitente-desp":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est-cex.nome-emitente-desp ).
            WHEN "#did-des-desp":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est-cex.des-desp ).
            WHEN "#did-des-moeda":U THEN RUN pi-imprime-campos-char(INPUT tt-item-doc-est-cex.des-moeda ).
        END CASE.

        IF NOT l-chave THEN DO:
            IF tt-matriz-ficha.c-linha = "#did-val-desp":U THEN RUN pi-imprime-campos-dec(INPUT tt-item-doc-est-cex.val-desp ).
        END.

    END.

    IF p-c-tabela = "embarque-contab":U THEN DO:
        CASE tt-matriz-ficha.c-linha:
            WHEN "#mt-ep-codigo":U THEN RUN pi-imprime-campos-int(INPUT tt-embarque-contab.ep-codigo ).
            WHEN "#mt-cod-estabel":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-contab.cod-estabel ).
            WHEN "#mt-nome-estabel":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-contab.nome-estabel ).
            WHEN "#mt-embarque":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-contab.embarque ).
            WHEN "#mt-cod-emitente":U THEN RUN pi-imprime-campos-int(INPUT tt-embarque-contab.cod-emitente ).
            WHEN "#mt-nome-emitente":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-contab.nome-emitente ).
            WHEN "#mt-nr-docto":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-contab.nr-docto ).
            WHEN "#mt-serie":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-contab.serie ).
            WHEN "#mt-cod-especie":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-contab.cod-especie ).
            WHEN "#mt-parcela":U THEN RUN pi-imprime-campos-int(INPUT tt-embarque-contab.parcela ).
            WHEN "#mt-situacao":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-contab.situacao ).
            WHEN "#mt-data-emissao":U THEN RUN pi-imprime-campos-date(INPUT tt-embarque-contab.data-emissao ).
            WHEN "#mt-prev-pag":U THEN RUN pi-imprime-campos-date(INPUT tt-embarque-contab.data-prev-pag ).
            WHEN "#mt-moeda":U THEN RUN pi-imprime-campos-char(INPUT tt-embarque-contab.desc-moeda ).
            WHEN "#mt-vl-orig":U THEN RUN pi-imprime-campos-dec(INPUT tt-embarque-contab.de-vl-orig ).
            WHEN "#mt-vl-saldo":U THEN RUN pi-imprime-campos-dec(INPUT tt-embarque-contab.de-vl-saldo ).
            WHEN "#mt-pto-incoterm":U THEN RUN pi-imprime-campos-int(INPUT tt-embarque-contab.pto-incoterm ).
            WHEN "#mt-dt-incoterm":U THEN RUN pi-imprime-campos-date(INPUT tt-embarque-contab.data-incoterm ).
        END CASE.
        IF NOT l-chave THEN DO:
        END.
    END.


    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-literais-espec:
/*------------------------------------------------------------------------------
  Purpose:     Imprime as literais espec°ficas do relat¢rio
  Parameters:  p-c-literal:  literal que est† sendo lido para impress∆o
               p-l-literal: Retorna se imprimiu a literal espec°fica
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-c-literal AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-l-literal AS LOGICAL   NO-UNDO.

    FOR EACH tt-epc
       WHERE tt-epc.cod-event = "Custom-literals":U EXCLUSIVE-LOCK:
        DELETE tt-epc.
    END.
    {include/i-epc200.i2 &CodEvent='"Custom-literals"'
                         &CodParameter='"literal"'
                         &ValueParameter="p-c-literal"}

    {include/i-epc201.i "Custom-literals"}

    ASSIGN p-l-literal = NO.
    FOR FIRST tt-epc
        WHERE tt-epc.cod-event     = "Custom-literals":U
        AND   tt-epc.cod-parameter = p-c-literal:

        IF tt-epc.val-parameter <> "":U THEN DO:
            chExcelApplication:Range(c-range):SELECT() NO-ERROR.
            chExcelApplication:Range(c-range):SetValue(tt-epc.val-parameter).
            ASSIGN p-l-literal = YES.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.
