/********************************************************************************
** Copyright DATASUL S.A. (2014)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0730RP 2.00.00.037 } /*** "010037" 17/08/2026 03:18:46 ***/
/*****************************************************************************
**       Programa: IM0730RP.P
**       Data....: 01/10/2014
**       Autor...: DATASUL S.A.
**       Objetivo: Importa‡Æo
**       Versao..: 2.00.00.001 - MIM
*******************************************************************************/
{include/i-rpvar.i}
{cdp/cdcfgdis.i}
{utp/ut-glob.i}
{include/boerrtab.i} /*Defini‡Æo tt-bo-erro*/

/* Include de defini‡Æo de vari veis Unifica‡Æo de conceitos */
{laphtml/mlaUnifDefine.i}

/* TT Param */
{imp/im0730.i}
{imp/im0730.i2}
{imp/im0730.i3}
{imp/im0730.i4}
{imp/im0730.i5} /* definicao de temp-table para integracao com EMS5 */
{cdp/cd4300.i3} /*definicao das variaveis utilizadas no cd4300.i4*/

/***************************Defini‡Æo de Parƒmetros *****************************/
def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

/*************************** Defini‡Æo de Vari veis *****************************/
DEFINE VARIABLE i-empresa             LIKE param-global.empresa-prin              NO-UNDO.
DEFINE VARIABLE h-acomp               AS   HANDLE                                 NO-UNDO.
DEFINE VARIABLE i-dias-total          AS   INTEGER FORMAT ">,>>9.99":U            NO-UNDO.
DEFINE VARIABLE c-data-extenso        AS   CHARACTER FORMAT "x(70)":U             NO-UNDO.
DEFINE VARIABLE i-fabrican            AS   INTEGER                                NO-UNDO.
DEFINE VARIABLE i-cdn-pto-nacionaliz  LIKE histor-decla-import.cdn-pto-nacionaliz NO-UNDO.
DEFINE VARIABLE i-cdn-pto-chegada     LIKE histor-decla-import.cdn-pto-chegad     NO-UNDO.
DEFINE VARIABLE c-desc-pto-nacionaliz LIKE histor-decla-import.descricao          NO-UNDO.
DEFINE VARIABLE c-desc-pto-chegada    LIKE histor-decla-import.descricao          NO-UNDO.
DEFINE VARIABLE c_cod_format_cta_ctbl AS   CHARACTER                              NO-UNDO.
DEFINE VARIABLE c_cod_format_ccusto   AS   CHARACTER                              NO-UNDO.


DEFINE VARIABLE h-bocx383  AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx230  AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-acr933zb AS HANDLE      NO-UNDO.

/* Utilizadas na impressÆo dos documentos impressos/documentos erros */
DEF VAR i-nr-mensag AS INTEGER   FORMAT ">>>>9":U       NO-UNDO.
DEF VAR c-mensagem  AS CHARACTER FORMAT "x(120)":U      NO-UNDO.
DEF VAR c-destino   AS CHARACTER FORMAT "x(132)":U      NO-UNDO.

 /****************Fun‡äes ******************/
DEF VAR l-integra-ems-his AS LOGICAL NO-UNDO.
ASSIGN l-integra-ems-his = CAN-FIND(FIRST funcao NO-LOCK
                                    WHERE funcao.cd-funcao = "spp-integra-ems-his":U
                                      AND funcao.ativo = YES).

FORM c-destino FORMAT "x(132)":U
     with down no-box width 132 stream-io frame f-doc-impressos.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-doc-impressos:HANDLE).

FORM i-nr-mensag
     c-mensagem FORMAT "x(120)":U
     with down no-box width 132 stream-io frame f-doc-erros.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-doc-erros:HANDLE).

{utp/ut-liter.i Mensagem * L}
ASSIGN c-mensagem:LABEL IN FRAME f-doc-erros = TRIM(RETURN-VALUE).

{utp/ut-liter.i Nr_Mensagem * L}
ASSIGN i-nr-mensag:LABEL IN FRAME f-doc-erros = TRIM(RETURN-VALUE).

{utp/ut-liter.i Destino * L}
ASSIGN c-destino:LABEL IN FRAME f-doc-impressos = TRIM(RETURN-VALUE).

/******************************************************  E X E C U € Ç O  *************************************************************/
{include/i-rpcab.i}

DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
DEFINE BUFFER bf-item-doc-est        FOR item-doc-est.
DEFINE BUFFER bf-docum-est           FOR docum-est.
DEFINE BUFFER bf-docum-est-aux       FOR docum-est.
DEFINE BUFFER bf-histor-decla-import FOR histor-decla-import.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR FIRST param-global NO-LOCK:
END.

FOR FIRST param-imp NO-LOCK:
END.

for first empresa no-lock
    where empresa.ep-codigo = param-global.empresa-prin.
end.

assign c-empresa  = (if avail empresa then empresa.nome else "":U)
       c-programa = "IM0730":U.

{include/i-rpout.i}
view frame f-cabec.
view frame f-rodape.

IF tt-param.lPedidoCompra OR
   tt-param.lProcessoImp  OR
   tt-param.lFornecedor   OR
   tt-param.lOrdemCompra  OR
   tt-param.lDeclaImport  OR
   tt-param.lEmbarqueImp  OR
   tt-param.lDocumentos   THEN DO:

    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
    RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.
    RUN cxbo/bocx230a.p PERSISTENT SET h-bocx230.
    IF  tt-param.lMaterialTransito AND NOT VALID-HANDLE(h-acr933zb) THEN
        RUN prgfin/acr/acr933zb.py PERSISTENT SET h-acr933zb.

    {utp/ut-liter.i "Processando_Informa‡äes"}
    RUN pi-inicializar IN h-acomp (INPUT TRIM(RETURN-VALUE)).

    IF  param-global.modulo-07 THEN DO:
        /*Leitura por processo de importa‡Æo*/
        IF  tt-param.iOpcao = 1 THEN
            RUN pi-leitura-imp.

        /*Leitura por embarque*/
        IF  tt-param.iOpcao = 2 THEN
            RUN pi-leitura-emb.

        /*Leitura por pedido/ordem de compra*/
        IF  tt-param.iOpcao = 3 THEN
            RUN pi-leitura-ped.
    END.

    RUN pi-finalizar IN h-acomp.

    IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
        DELETE PROCEDURE h_api_cta_ctbl.
        ASSIGN h_api_cta_ctbl = ?.
    END.

    IF VALID-HANDLE(h_api_ccusto) THEN DO:
        DELETE PROCEDURE h_api_ccusto.
        ASSIGN h_api_ccusto = ?.
    END.

    IF VALID-HANDLE(h-bocx230) THEN DO:
        DELETE PROCEDURE h-bocx230.
        ASSIGN h-bocx230 = ?.
    END.

    IF VALID-HANDLE(h-acr933zb) THEN DO:
        DELETE PROCEDURE h-acr933zb.
        ASSIGN h-acr933zb = ?.
    END.

    /*Cria planilha com base nas TTs*/
    RUN pi-envia-tts-excel.

END.

RUN pi-relatorio-acomp.

RUN pi-imprime-parametros.

{include/i-rpclo.i}

/******************************************** P R O C E D U R E S     I N T E R N A S **************************************************/
PROCEDURE pi-leitura-imp:
/*------------------------------------------------------------------------------
  Purpose:     Executa a leitura pelo processo de importa‡Æo
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    FOR EACH processo-imp FIELDS(cod-estabel nr-proc-imp num-pedido dt-emissao cod-itiner cod-transportador cdn-corretor-cambio-import
                                 cdn-despa-exter-import cdn-segurad-import cdn-corretor-import cod-despachante cod-exportador cod-consignatario
                                 cod-agente nr-conhecimento carta-credito destino-documentacao regime-import estab-fisc contrato-cambio)
       WHERE processo-imp.cod-estabel    >= tt-param.cProcEstabIni
         AND processo-imp.cod-estabel    <= tt-param.cProcEstabFim
         AND processo-imp.nr-proc-imp    >= tt-param.cProcImpIni
         AND processo-imp.nr-proc-imp    <= tt-param.cProcImpFim
         AND processo-imp.cod-exportador >= tt-param.iEmitProcIni
         AND processo-imp.cod-exportador <= tt-param.iEmitProcFim NO-LOCK:

         IF processo-imp.dt-emissao     < tt-param.dDataEmisIni
         OR processo-imp.dt-emissao     > tt-param.dDataEmisFim THEN NEXT.

        {utp/ut-liter.i "Processo_de_Importa‡Æo: "}
        RUN pi-acompanhar IN h-acomp (INPUT STRING(RETURN-VALUE + " ":U + TRIM(processo-imp.nr-proc-imp))).

        /* Dados Processo Importa‡Æo */
        RUN pi-cria-processo-imp (INPUT processo-imp.num-pedido).

    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-leitura-emb:
/*------------------------------------------------------------------------------
  Purpose:     Executa a leitura pelo Embarque
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    FOR EACH embarque-imp NO-LOCK
       WHERE embarque-imp.cod-estabel       >= tt-param.cEmbEstabIni
         AND embarque-imp.cod-estabel       <= tt-param.cEmbEstabFim
         AND embarque-imp.embarque          >= tt-param.cEmbarqueIni
         AND embarque-imp.embarque          <= tt-param.cEmbarqueFim
         AND embarque-imp.declaracao-import >= tt-param.cDISiscomexIni
         AND embarque-imp.declaracao-import <= tt-param.cDISiscomexFim:

        IF embarque-imp.data-di < tt-param.dDataDIIni
        OR embarque-imp.data-di > tt-param.dDataDIFim THEN NEXT.

        IF embarque-imp.int-2   < tt-param.iDIEMSIni
        OR embarque-imp.int-2   > tt-param.iDIEMSFim THEN NEXT.

        {utp/ut-liter.i "Embarque_de_Importa‡Æo: "}
        RUN pi-acompanhar IN h-acomp (INPUT STRING(RETURN-VALUE + " ":U + TRIM(embarque-imp.embarque))).

        /* Dados Embarque de Importa‡Æo */
        RUN pi-cria-embarque-imp (INPUT embarque-imp.cod-estabel,
                                  INPUT embarque-imp.embarque,
                                  INPUT 0,
                                  INPUT 0).
    END.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-leitura-ped:
/*------------------------------------------------------------------------------
  Purpose:     Executa a leitura pelo Pedido/Ordem de Compra
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    FOR EACH ordem-compra NO-LOCK
       WHERE ordem-compra.numero-ordem     >= tt-param.iOrdemCompraIni
         AND ordem-compra.numero-ordem     <= tt-param.iOrdemCompraFim
         AND ordem-compra.num-pedido       >= tt-param.iPedidoIni
         AND ordem-compra.num-pedido       <= tt-param.iPedidoFim
         AND ordem-compra.cod-emitente     >= tt-param.iEmitPedIni
         AND ordem-compra.cod-emitente     <= tt-param.iEmitPedFim
         AND ordem-compra.data-pedido      >= tt-param.dDataPedIni
         AND ordem-compra.data-pedido      <= tt-param.dDataPedFim
         AND ordem-compra.cod-estabel      >= tt-param.cPedEstabIni
         AND ordem-compra.cod-estabel      <= tt-param.cPedEstabFim,
        FIRST processo-imp NO-LOCK
        WHERE processo-imp.num-pedido = ordem-compra.num-pedido:

        {utp/ut-liter.i "Ordem_de_Compra: "}
        RUN pi-acompanhar IN h-acomp (INPUT STRING(RETURN-VALUE + " ":U + TRIM(STRING(ordem-compra.numero-ordem)))).

        /* Dados Ordem de Compra */
        RUN pi-cria-ordem-compra (INPUT ordem-compra.num-pedido,
                                  INPUT ordem-compra.numero-ordem).
    END.

    RETURN "OK":U.

END PROCEDURE.

/****************************************  C R I A € Ç O    D A S    T E M P - T A B L E S   ****************************************/
PROCEDURE pi-cria-processo-imp:
/*------------------------------------------------------------------------------
  Purpose:     Cria as temp-tables com os dados relacionados aos processos de
               importa‡Æo
  Parameters:  p-num-pedido: N£mero do pedido de compra (integer)
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-num-pedido   LIKE pedido-compr.num-pedido NO-UNDO.

    IF tt-param.iOpcao = 1 THEN DO:

        CREATE tt-processo-imp.
        ASSIGN tt-processo-imp.cod-estabel                   = processo-imp.cod-estabel
               tt-processo-imp.nr-proc-imp 	                 = processo-imp.nr-proc-imp
               tt-processo-imp.num-pedido                    = processo-imp.num-pedido
               tt-processo-imp.dt-emissao                    = processo-imp.dt-emissao
               tt-processo-imp.cod-itiner                    = processo-imp.cod-itiner
               tt-processo-imp.cod-transportador             = processo-imp.cod-transportador
               tt-processo-imp.cdn-corretor-cambio-import    = processo-imp.cdn-corretor-cambio-import
               tt-processo-imp.cdn-despa-exter-import        = processo-imp.cdn-despa-exter-import
               tt-processo-imp.cdn-segurad-import            = processo-imp.cdn-segurad-import
               tt-processo-imp.cdn-corretor-import           = processo-imp.cdn-corretor-import
               tt-processo-imp.cod-despachante               = processo-imp.cod-despachante
               tt-processo-imp.cod-exportador                = processo-imp.cod-exportador
               tt-processo-imp.cod-consignatario             = processo-imp.cod-consignatario
               tt-processo-imp.cod-agente                    = processo-imp.cod-agente
               tt-processo-imp.nr-conhecimento               = processo-imp.nr-conhecimento
               tt-processo-imp.carta-credito                 = processo-imp.carta-credito
               tt-processo-imp.destino-documentacao          = processo-imp.destino-documentacao
               tt-processo-imp.regime-import                 = processo-imp.regime-import
               tt-processo-imp.estab-fisc                    = processo-imp.estab-fisc
               tt-processo-imp.contrato-cambio               = processo-imp.contrato-cambio
               .

        RUN pi-campos-descricao (INPUT "processo-imp":U).

        /* Dados Ordem de Compra */
        RUN pi-cria-ordem-compra (INPUT p-num-pedido,
                                  INPUT 0).

        /* Dados Embarque de Importa‡Æo */
        RUN pi-cria-embarque-imp (INPUT "":U,
                                  INPUT 0,
                                  INPUT p-num-pedido,
                                  INPUT 0).
    END.
    ELSE DO:
        FOR FIRST processo-imp NO-LOCK
            WHERE processo-imp.num-pedido = p-num-pedido:
            CREATE tt-processo-imp.
            BUFFER-COPY processo-imp TO tt-processo-imp.
            RUN pi-campos-descricao (INPUT "processo-imp":U).
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-cria-embarque-imp:
/*------------------------------------------------------------------------------
  Purpose:     Cria as temp-tables com os dados relacionados aos embarques
  Parameters:  p-cod-estabel: C¢digo do estabelecimento (character)
               p-embarque: C¢digo do embarque (integer)
               p-num-pedido: N£mero do pedido (integer)
               p-numero-ordem: N£mero da ordem de compra (integer)
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-cod-estabel  LIKE embarque-imp.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAM p-embarque     LIKE embarque-imp.embarque     NO-UNDO.
    DEFINE INPUT PARAM p-num-pedido   LIKE pedido-compr.num-pedido   NO-UNDO.
    DEFINE INPUT PARAM p-numero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

    IF tt-param.iOpcao = 2 THEN DO:
        CREATE tt-embarque-imp.
        BUFFER-COPY embarque-imp TO tt-embarque-imp.
        RUN calcularDiasAcompanhamentoHistEmb IN h-bocx230 (INPUT  tt-embarque-imp.cod-estabel,
                                                            INPUT  tt-embarque-imp.embarque,
                                                            OUTPUT i-dias-total,
                                                            OUTPUT TABLE tt-bo-erro).
        ASSIGN tt-embarque-imp.i-dias-total = i-dias-total.
        RUN pi-campos-descricao (INPUT "embarque-imp":U).

        FOR EACH ordens-embarque NO-LOCK
            WHERE ordens-embarque.cod-estabel = p-cod-estabel
              AND ordens-embarque.embarque    = p-embarque:

            FOR FIRST ordem-compra NO-LOCK
                WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem:
            END.

            CREATE tt-ordens-embarque.
            BUFFER-COPY ordens-embarque TO tt-ordens-embarque.
            RUN pi-campos-descricao (INPUT "ordens-embarque":U).

            /* Dados Processo Importa‡Æo */
            IF NOT CAN-FIND (FIRST tt-processo-imp
                              WHERE tt-processo-imp.num-pedido = ordem-compra.num-pedido) THEN DO:
                RUN pi-cria-processo-imp (INPUT ordem-compra.num-pedido).
            END.

            /* Dados Ordem de Compra */
            IF NOT CAN-FIND (FIRST tt-ordem-compra
                             WHERE tt-ordem-compra.numero-ordem = ordens-embarque.numero-ordem) THEN
                RUN pi-cria-ordem-compra (INPUT ordem-compra.num-pedido,
                                          INPUT ordens-embarque.numero-ordem).

            RUN pi-cria-dados-detalhe (INPUT ordens-embarque.cod-estabel,
                                       INPUT ordens-embarque.embarque,
                                       INPUT ordens-embarque.numero-ordem,
                                       INPUT ordens-embarque.parcela).
        END.
    END.
    ELSE DO:
        IF tt-param.iOpcao = 1 THEN DO:
            FOR EACH tt-ordem-compra NO-LOCK
                WHERE tt-ordem-compra.num-pedido = p-num-pedido:
                FOR EACH ordens-embarque NO-LOCK
                    WHERE ordens-embarque.numero-ordem = tt-ordem-compra.numero-ordem:
                    CREATE tt-ordens-embarque.
                    BUFFER-COPY ordens-embarque EXCEPT char-1 char-2 TO tt-ordens-embarque.
                    RUN pi-campos-descricao (INPUT "ordens-embarque":U).

                    RUN pi-cria-dados-detalhe (INPUT ordens-embarque.cod-estabel,
                                               INPUT ordens-embarque.embarque,
                                               INPUT ordens-embarque.numero-ordem,
                                               INPUT ordens-embarque.parcela).

                    IF NOT CAN-FIND (FIRST tt-embarque-imp
                                     WHERE tt-embarque-imp.cod-estabel = ordens-embarque.cod-estabel
                                       AND tt-embarque-imp.embarque    = ordens-embarque.embarque) THEN DO:
                        FOR FIRST embarque-imp NO-LOCK
                            WHERE embarque-imp.cod-estabel = ordens-embarque.cod-estabel
                              AND embarque-imp.embarque    = ordens-embarque.embarque:
                            CREATE tt-embarque-imp.
                            BUFFER-COPY embarque-imp EXCEPT char-1 char-2 TO tt-embarque-imp.
                            RUN calcularDiasAcompanhamentoHistEmb IN h-bocx230 (INPUT  tt-embarque-imp.cod-estabel,
                                                                                INPUT  tt-embarque-imp.embarque,
                                                                                OUTPUT i-dias-total,
                                                                                OUTPUT TABLE tt-bo-erro).
                            ASSIGN tt-embarque-imp.i-dias-total = i-dias-total.
                            RUN pi-campos-descricao (INPUT "embarque-imp":U).
                        END.
                    END.
                END.
            END.
        END.
        ELSE DO:
            FOR EACH ordens-embarque NO-LOCK
                WHERE ordens-embarque.numero-ordem = p-numero-ordem:
                CREATE tt-ordens-embarque.
                BUFFER-COPY ordens-embarque TO tt-ordens-embarque.
                RUN pi-campos-descricao (INPUT "ordens-embarque":U).

                RUN pi-cria-dados-detalhe (INPUT ordens-embarque.cod-estabel,
                                           INPUT ordens-embarque.embarque,
                                           INPUT ordens-embarque.numero-ordem,
                                           INPUT ordens-embarque.parcela).

                IF NOT CAN-FIND (FIRST tt-embarque-imp
                                 WHERE tt-embarque-imp.cod-estabel = ordens-embarque.cod-estabel
                                   AND tt-embarque-imp.embarque    = ordens-embarque.embarque) THEN DO:
                    FOR FIRST embarque-imp NO-LOCK
                        WHERE embarque-imp.cod-estabel = ordens-embarque.cod-estabel
                          AND embarque-imp.embarque    = ordens-embarque.embarque:
                        CREATE tt-embarque-imp.
                        BUFFER-COPY embarque-imp TO tt-embarque-imp.
                        RUN calcularDiasAcompanhamentoHistEmb IN h-bocx230 (INPUT  tt-embarque-imp.cod-estabel,
                                                                            INPUT  tt-embarque-imp.embarque,
                                                                            OUTPUT i-dias-total,
                                                                            OUTPUT TABLE tt-bo-erro).
                        ASSIGN tt-embarque-imp.i-dias-total = i-dias-total.
                        RUN pi-campos-descricao (INPUT "embarque-imp":U).
                    END.
                END.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-cria-ordem-compra:
/*------------------------------------------------------------------------------
  Cria as temp-tables com os dados relacionados aos pedidos e ordens de compra
  Parameters:  p-num-pedido: N£mero do pedido (integer)
               p-numero-ordem: N£mero da ordem de compra (integer)
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-num-pedido   LIKE pedido-compr.num-pedido   NO-UNDO.
    DEFINE INPUT PARAM p-numero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

    IF NOT CAN-FIND (FIRST tt-pedido-compr
                     WHERE tt-pedido-compr.num-pedido = p-num-pedido) THEN DO:
        FOR FIRST pedido-compr FIELDS(num-pedido cod-emitente cod-estabel data-pedido situacao cod-emit-terc nr-processo
                                      cod-transp cod-cond-pag responsavel nr-contrato via-transp)
            WHERE pedido-compr.num-pedido = p-num-pedido NO-LOCK:
            CREATE tt-pedido-compr.
            ASSIGN tt-pedido-compr.num-pedido     = pedido-compr.num-pedido
                   tt-pedido-compr.cod-emitente   = pedido-compr.cod-emitente
                   tt-pedido-compr.cod-estabel    = pedido-compr.cod-estabel
                   tt-pedido-compr.data-pedido    = pedido-compr.data-pedido
                   tt-pedido-compr.situacao       = pedido-compr.situacao
                   tt-pedido-compr.cod-emit-terc  = pedido-compr.cod-emit-terc
                   tt-pedido-compr.nr-processo    = pedido-compr.nr-processo
                   tt-pedido-compr.cod-transp     = pedido-compr.cod-transp
                   tt-pedido-compr.cod-cond-pag   = pedido-compr.cod-cond-pag
                   tt-pedido-compr.responsavel    = pedido-compr.responsavel
                   tt-pedido-compr.nr-contrato    = pedido-compr.nr-contrato
                   tt-pedido-compr.via-transp     = pedido-compr.via-transp
                   .

            RUN pi-campos-descricao (INPUT "pedido-compr":U).
        END.
    END.

    IF tt-param.iOpcao = 3 THEN DO:

        CREATE tt-ordem-compra.
        BUFFER-COPY ordem-compra TO tt-ordem-compra.
        RUN pi-campos-descricao (INPUT "ordem-compra":U).

        /* Dados Processo Importa‡Æo */
        IF NOT CAN-FIND (FIRST tt-processo-imp
                         WHERE tt-processo-imp.num-pedido = ordem-compra.num-pedido) THEN
            RUN pi-cria-processo-imp (INPUT p-num-pedido).

        /* Dados Embarque de Importa‡Æo */
        RUN pi-cria-embarque-imp (INPUT "":U,
                                  INPUT 0,
                                  INPUT p-num-pedido,
                                  INPUT p-numero-ordem).
    END.
    ELSE DO:
        IF tt-param.iOpcao = 1 THEN DO:
            FOR EACH ordem-compra NO-LOCK
                WHERE ordem-compra.num-pedido = p-num-pedido:
                CREATE tt-ordem-compra.
                BUFFER-COPY ordem-compra EXCEPT char-1 char-2 TO tt-ordem-compra.
                RUN pi-campos-descricao (INPUT "ordem-compra":U).
            END.
        END.
        ELSE DO:
            FOR FIRST ordem-compra NO-LOCK
                WHERE ordem-compra.numero-ordem = p-numero-ordem:
                CREATE tt-ordem-compra.
                BUFFER-COPY ordem-compra TO tt-ordem-compra.
                RUN pi-campos-descricao (INPUT "ordem-compra":U).
            END.
        END.
    END.

    /* Dados Fornecedor */
    IF tt-param.lFornecedor THEN DO:

        FOR FIRST tt-pedido-compr NO-LOCK
            WHERE tt-pedido-compr.num-pedido = p-num-pedido:

            IF NOT CAN-FIND (FIRST tt-emitente
                             WHERE tt-emitente.cod-emitente = tt-pedido-compr.cod-emitente) THEN DO:
                FOR FIRST emitente NO-LOCK
                    WHERE emitente.cod-emitente = tt-pedido-compr.cod-emitente:
                    CREATE tt-emitente.
                    BUFFER-COPY emitente TO tt-emitente.
                    RUN pi-campos-descricao (INPUT "emitente":U).
                END.
                FOR FIRST emitente-cex NO-LOCK
                    WHERE emitente-cex.cod-emitente = tt-pedido-compr.cod-emitente:
                    ASSIGN tt-emitente.cod-idioma           = emitente-cex.cod-idioma
                           tt-emitente.cod-repres           = emitente-cex.cod-repres
                           tt-emitente.cod-itiner-imp       = emitente-cex.cod-itiner-imp
                           tt-emitente.cod-incoterm-imp     = emitente-cex.cod-incoterm-imp
                           tt-emitente.cod-ident-fisc-exter = emitente-cex.cod-ident-fisc-exter.
                END.
            END.
        END.
    END.

    /* Dados Cota‡Æo Item */
    FOR EACH tt-ordem-compra NO-LOCK
        WHERE tt-ordem-compra.num-pedido = p-num-pedido:
        IF tt-ordem-compra.numero-ordem = p-numero-ordem OR tt-param.iOpcao = 1 THEN DO:
            FOR FIRST cotacao-item NO-LOCK
                WHERE cotacao-item.numero-ordem = tt-ordem-compra.numero-ordem
                  AND cotacao-item.cot-aprovada:

                ASSIGN tt-ordem-compra.un                    = cotacao-item.un
                       tt-ordem-compra.aliquota-ii           = DECIMAL(SUBSTRING(cotacao-item.char-1,61,20))
                       tt-ordem-compra.cod-incoterm          = SUBSTRING(cotacao-item.char-1,21,20)
                       tt-ordem-compra.cod-fabricante        = INTEGER(SUBSTRING(cotacao-item.char-2,41,20))
                       tt-ordem-compra.regime-impot          = INTEGER(SUBSTRING(cotacao-item.char-2,61,20))
                       tt-ordem-compra.cod-pto-controle-base = INTEGER(SUBSTRING(cotacao-item.char-1,41,20))
                       tt-ordem-compra.mapa-cotacao          = INTEGER(SUBSTRING(cotacao-item.char-1,1,20))
                       tt-ordem-compra.cdn-pais-orig         = cotacao-item.cdn-pais-orig
                       tt-ordem-compra.ex-tarifario          = IF SUBSTRING(cotacao-item.char-1,148,1) = "1":U THEN YES ELSE NO
                       tt-ordem-compra.cod-itinerario        = cotacao-item.int-1 NO-ERROR.

                RUN pi-campos-descricao (INPUT "cotacao-item":U).
            END.
            /* Dados Item */
            IF  tt-param.lItem
            AND NOT CAN-FIND (FIRST tt-item
                              WHERE tt-item.it-codigo = tt-ordem-compra.it-codigo) THEN DO:
                FOR FIRST ITEM
                    WHERE ITEM.it-codigo = tt-ordem-compra.it-codigo NO-LOCK:
                    CREATE tt-item.
                    BUFFER-COPY ITEM TO tt-item.
                    RUN pi-campos-descricao (INPUT "item":U).
                END.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-cria-dados-detalhe:
/*------------------------------------------------------------------------------
  Purpose:     Cria temp-tables com os dados detalhados dos Processos, Embarque
               ou Pedidos/Ordens
  Parameters:  p-cod-estabel: C¢digo do estabelecimento (character)
               p-embarque: C¢digo do embarque (integer)
               p-numero-ordem: N£mero da ordem de compra (integer)
               p-parcela: C¢digo da parcela (integer)
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-cod-estabel  LIKE ordens-embarque.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAM p-embarque     LIKE ordens-embarque.embarque     NO-UNDO.
    DEFINE INPUT PARAM p-numero-ordem LIKE ordens-embarque.numero-ordem NO-UNDO.
    DEFINE INPUT PARAM p-parcela      LIKE ordens-embarque.parcela      NO-UNDO.

    DEF VAR c-moeda-adic             AS CHAR FORMAT "X(30)"              NO-UNDO.
    DEF VAR c-moeda-frete            AS CHAR FORMAT "X(30)"              NO-UNDO.
    DEF VAR c-moeda-seguro           AS CHAR FORMAT "X(30)"              NO-UNDO.
    DEF VAR c-moeda-acres            AS CHAR FORMAT "X(30)"              NO-UNDO.
    DEF VAR d-val-vmcv               LIKE decla-import-adic.val-vmcv     NO-UNDO.
    DEF VAR d-val-vmcv-me            LIKE decla-import-adic.val-vmcv     NO-UNDO.
    DEF VAR d-val-vmle               LIKE decla-import-adic.val-vmle     NO-UNDO.
    DEF VAR d-val-vmle-me            LIKE decla-import-adic.val-vmle     NO-UNDO.
    DEF VAR d-val-vmld               LIKE decla-import-adic.val-vmld     NO-UNDO.
    DEF VAR d-val-vmld-me            LIKE decla-import-adic.val-vmld     NO-UNDO.
    DEF VAR d-val-frete              LIKE decla-import-adic.val-frete    NO-UNDO.
    DEF VAR d-val-frete-me           LIKE decla-import-adic.val-frete    NO-UNDO.
    DEF VAR d-val-seguro             LIKE decla-import-adic.val-seguro   NO-UNDO.
    DEF VAR d-val-seguro-me          LIKE decla-import-adic.val-seguro   NO-UNDO.
    DEF VAR d-val-acresc             LIKE decla-import-adic.val-acresc   NO-UNDO.
    DEF VAR d-val-acresc-me          LIKE decla-import-adic.val-acresc   NO-UNDO.
    DEF VAR d-tot-val-desp-nacion-me LIKE despes-decla-import.val-despes NO-UNDO.
    DEF VAR d-tot-val-desp-nacion    LIKE despes-decla-import.val-despes NO-UNDO.
    DEF VAR d-tot-val-desp-compl-me  LIKE despes-decla-import.val-despes NO-UNDO.
    DEF VAR d-tot-val-desp-compl     LIKE despes-decla-import.val-despes NO-UNDO.
    DEF VAR d-tot-val-desp-di-me     LIKE despes-decla-import.val-despes NO-UNDO.
    DEF VAR d-tot-val-desp-di        LIKE despes-decla-import.val-despes NO-UNDO.

    /* Parcelas */
    IF tt-param.lParcelas THEN DO:
        FOR FIRST prazo-compra NO-LOCK
            WHERE prazo-compra.numero-ordem = p-numero-ordem
              AND prazo-compra.parcela      = p-parcela:

            CREATE tt-prazo-compra.
            BUFFER-COPY prazo-compra TO tt-prazo-compra.
            RUN pi-campos-descricao (INPUT "prazo-compra":U).

            FOR FIRST licenciam-import-oc FIELDS (licenca-import) NO-LOCK
                WHERE licenciam-import-oc.numero-ordem = p-numero-ordem
                  AND licenciam-import-oc.parcela      = p-parcela:

                ASSIGN tt-prazo-compra.licenca-import = licenciam-import-oc.licenca-import.
            END.
        END.
    END.

    /* Historico Embarque */
    IF  tt-param.lAcompEmb THEN DO:

        IF NOT CAN-FIND (FIRST tt-historico-embarque
                         WHERE tt-historico-embarque.cod-estabel = p-cod-estabel
                           AND tt-historico-embarque.embarque    = p-embarque) THEN DO:
            FOR EACH historico-embarque NO-LOCK
                WHERE historico-embarque.cod-estabel = p-cod-estabel
                  AND historico-embarque.embarque    = p-embarque:

                CREATE tt-historico-embarque.
                BUFFER-COPY historico-embarque TO tt-historico-embarque.
                RUN pi-campos-descricao (INPUT "historico-embarque":U).
            END.
        END.
        IF NOT CAN-FIND (FIRST tt-desp-embarque
                         WHERE tt-desp-embarque.cod-estabel = p-cod-estabel
                           AND tt-desp-embarque.embarque    = p-embarque) THEN DO:
            FOR EACH desp-embarque NO-LOCK
                WHERE desp-embarque.cod-estabel = p-cod-estabel
                  AND desp-embarque.embarque    = p-embarque:

                CREATE tt-desp-embarque.
                BUFFER-COPY desp-embarque TO tt-desp-embarque.
                RUN pi-campos-descricao (INPUT "desp-embarque":U).
            END.
        END.

    END.

    /* Material em Transito */
    IF tt-param.lMaterialTransito THEN DO:
        IF NOT CAN-FIND(FIRST tt-embarque-contab
                        WHERE tt-embarque-contab.embarque    = p-embarque
                          AND tt-embarque-contab.cod-estabel = p-cod-estabel) THEN DO:

            FIND FIRST ordem-compra
                 WHERE ordem-compra.numero-ordem = p-numero-ordem NO-LOCK NO-ERROR.

            FIND FIRST processo-imp
                 WHERE processo-imp.num-pedido = ordem-compra.num-pedido NO-LOCK NO-ERROR.

            FIND FIRST embarque-imp
                 WHERE embarque-imp.cod-estabel = p-cod-estabel
                   AND embarque-imp.embarque    = p-embarque NO-LOCK NO-ERROR.

            FOR EACH historico-embarque
               WHERE historico-embarque.cod-estabel = p-cod-estabel
                 AND historico-embarque.embarque    = p-embarque NO-LOCK:

                IF NOT CAN-FIND(FIRST incoterm-itiner
                                WHERE incoterm-itiner.cod-itiner    = historico-embarque.cod-itiner
                                  AND incoterm-itiner.cod-pto-contr = historico-embarque.cod-pto-contr
                                  AND incoterm-itiner.cod-incoterm  = embarque-imp.cod-incoterm) THEN NEXT.


                RUN pi-cria-dados-material-transito.

            END.
        END.
    END.


    /* Declara‡Æo de Importa‡Æo */
    IF tt-param.lDeclaImport THEN DO:

        FOR FIRST decla-import-ord NO-LOCK
            WHERE decla-import-ord.cod-estab   = p-cod-estabel
              AND decla-import-ord.cod-embarq  = p-embarque
              AND decla-import-ord.num-ordem   = p-numero-ordem
              AND decla-import-ord.num-parcela = p-parcela:

            CREATE tt-decla-import-ord.
            BUFFER-COPY decla-import-ord TO tt-decla-import-ord.
            RUN pi-campos-descricao (INPUT "decla-import-ord":U).

            IF NOT CAN-FIND (FIRST tt-decla-import
                             WHERE tt-decla-import.num-di-ems       = decla-import-ord.num-di-ems
                             AND   tt-decla-import.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts) THEN DO:
                FOR LAST decla-import NO-LOCK
                    WHERE decla-import.num-di-ems       = decla-import-ord.num-di-ems
                    AND   decla-import.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts:
                    CREATE tt-decla-import.
                    BUFFER-COPY decla-import TO tt-decla-import.
                    RUN pi-campos-descricao (INPUT "decla-import":U).
                    /* total despesas at‚ o ponto de nacionalizacao e despesas complementares */
                    IF NOT VALID-HANDLE(h-bocx383) THEN DO:
                        RUN cxbo/bocx383.p PERSISTENT SET h-bocx383.
                        RUN openQueryStatic IN h-bocx383 (INPUT "Main":U) NO-ERROR.
                    END.
                    RUN goToKeyCustom IN h-bocx383 (INPUT decla-import-ord.num-di-ems,
                                                    INPUT decla-import-ord.cdd-siscomex-dts).
                    RUN pi-busca-valores IN h-bocx383(INPUT decla-import-ord.num-di-ems,
                                                      INPUT decla-import-ord.cdd-siscomex-dts,
                                                      INPUT decla-import-ord.cod-estab,
                                                      OUTPUT c-moeda-adic,
                                                      OUTPUT c-moeda-frete,
                                                      OUTPUT c-moeda-seguro,
                                                      OUTPUT c-moeda-acres,
                                                      OUTPUT d-val-vmcv,
                                                      OUTPUT d-val-vmcv-me,
                                                      OUTPUT d-val-vmle,
                                                      OUTPUT d-val-vmle-me,
                                                      OUTPUT d-val-vmld,
                                                      OUTPUT d-val-vmld-me,
                                                      OUTPUT d-val-frete,
                                                      OUTPUT d-val-frete-me,
                                                      OUTPUT d-val-seguro,
                                                      OUTPUT d-val-seguro-me,
                                                      OUTPUT d-val-acresc,
                                                      OUTPUT d-val-acresc-me,
                                                      OUTPUT d-tot-val-desp-nacion-me,
                                                      OUTPUT d-tot-val-desp-nacion,
                                                      OUTPUT d-tot-val-desp-compl-me,
                                                      OUTPUT d-tot-val-desp-compl,
                                                      OUTPUT d-tot-val-desp-di-me,
                                                      OUTPUT d-tot-val-desp-di).
                    IF AVAIL tt-decla-import THEN
                        ASSIGN tt-decla-import.val-despes-nac            = d-tot-val-desp-nacion
                               tt-decla-import.val-despes-nac-me[1]      = d-tot-val-desp-nacion-me
                               tt-decla-import.val-despes-di             = d-tot-val-desp-di
                               tt-decla-import.val-despes-di-me[1]       = d-tot-val-desp-di-me
                               tt-decla-import.val-despes-compltar       = d-tot-val-desp-compl
                               tt-decla-import.val-despes-compltar-me[1] = d-tot-val-desp-compl-me.
                    /* fim - total despesas at‚ o ponto de nacionalizacao e despesas complementares */
                END.
            END.



            //A temp-table tt-decla-import-adic ‚ usada nos c lculos da DI, por isso deve sempre ser craida.
            IF NOT CAN-FIND (FIRST tt-decla-import-adic
                             WHERE tt-decla-import-adic.num-di-ems       = decla-import-ord.num-di-ems
                             AND   tt-decla-import-adic.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts) THEN DO:
                FOR EACH decla-import-adic NO-LOCK
                    WHERE decla-import-adic.num-di-ems       = decla-import-ord.num-di-ems
                    AND   decla-import-adic.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts:
                    CREATE tt-decla-import-adic.
                    BUFFER-COPY decla-import-adic TO tt-decla-import-adic.
                    RUN pi-campos-descricao (INPUT "decla-import-adic":U).
                END.
            END.

            IF tt-param.lAcompDI THEN DO:
                IF NOT CAN-FIND (FIRST tt-histor-decla-import
                                 WHERE tt-histor-decla-import.num-di-ems = decla-import-ord.num-di-ems
                                 AND   tt-histor-decla-import.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts) THEN DO:

                    ASSIGN i-cdn-pto-nacionaliz  = 0
                           i-cdn-pto-chegada     = 0
                           c-desc-pto-nacionaliz = "":U
                           c-desc-pto-chegada    = "":U.

                    FOR EACH histor-decla-import NO-LOCK
                        WHERE histor-decla-import.num-di-ems = decla-import-ord.num-di-ems
                        AND   histor-decla-import.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts:
                        CREATE tt-histor-decla-import.
                        BUFFER-COPY histor-decla-import TO tt-histor-decla-import.
                        RUN pi-campos-descricao (INPUT "histor-decla-import":U).
                    END.
                END.
                IF NOT CAN-FIND (FIRST tt-despes-decla-import
                                 WHERE tt-despes-decla-import.num-di-ems       = decla-import-ord.num-di-ems
                                 AND   tt-despes-decla-import.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts) THEN DO:
                    FOR EACH despes-decla-import NO-LOCK
                        WHERE despes-decla-import.num-di-ems       = decla-import-ord.num-di-ems
                        AND   despes-decla-import.cdd-siscomex-dts = decla-import-ord.cdd-siscomex-dts:
                        CREATE tt-despes-decla-import.
                        BUFFER-COPY despes-decla-import TO tt-despes-decla-import.
                        RUN pi-campos-descricao (INPUT "despes-decla-import":U).
                    END.
                END.
            END.
        END.
        IF VALID-HANDLE(h-bocx383) THEN DO:
            DELETE PROCEDURE h-bocx383.
            ASSIGN h-bocx383 = ?.
        END.
    END.

    /* Documentos */
    IF tt-param.lDocumentos THEN DO:
        FOR FIRST tt-ordem-compra
            WHERE tt-ordem-compra.numero-ordem = p-numero-ordem:
        END.

        RUN pi-documentos (INPUT p-cod-estabel,
                           INPUT p-embarque).
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-campos-descricao:
/*------------------------------------------------------------------------------
  Purpose:     Busca descri‡äes dos c¢digos de chave estrangeira
  Parameters:  p-c-tabela: Tabela com os c¢digos utilizados para a busca das
               descri‡äes (character)
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-c-tabela AS CHARACTER NO-UNDO.

    /* Pedido de Compra */
    IF p-c-tabela = "pedido-compr":U THEN DO:
        ASSIGN tt-pedido-compr.r-rowid        = ROWID(pedido-compr)
               tt-pedido-compr.des-via-transp = {adinc/i01ad268.i 4 tt-pedido-compr.via-transp} NO-ERROR.

        FOR FIRST estabelec FIELDS(cod-estabel nome) NO-LOCK
            WHERE estabelec.cod-estabel = tt-pedido-compr.cod-estabel:
            ASSIGN tt-pedido-compr.nome-estabel = estabelec.nome.
        END.
        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-pedido-compr.cod-emit-terc:
            ASSIGN tt-pedido-compr.nome-ab-terc = emitente.nome-abrev.
        END.
        FOR FIRST transporte FIELDS(nome-abrev) NO-LOCK
            WHERE transporte.cod-transp = tt-pedido-compr.cod-transp:
            ASSIGN tt-pedido-compr.nome-ab-transp = transporte.nome-abrev.
        END.
        FOR FIRST cond-pagto FIELDS(descricao) NO-LOCK
            WHERE cond-pagto.cod-cond-pag = tt-pedido-compr.cod-cond-pag:
            ASSIGN tt-pedido-compr.des-cond-pag = cond-pagto.descricao.
        END.

   END.

    /* Processo de Importa‡Æo */
    IF p-c-tabela = "processo-imp":U THEN DO:
        ASSIGN tt-processo-imp.r-rowid        = ROWID(processo-imp)
               tt-processo-imp.des-via-transp = {adinc/i01ad268.i 4 tt-processo-imp.via-transp}
               tt-processo-imp.des-situacao   = {cxinc/i01cx140.i 4 tt-processo-imp.situacao}   NO-ERROR.

        FOR FIRST estabelec FIELDS(cod-estabel nome) NO-LOCK
            WHERE estabelec.cod-estabel = tt-processo-imp.cod-estabel:
            ASSIGN tt-processo-imp.nome-estabel = estabelec.nome.
        END.
        FOR FIRST itinerario FIELDS(descricao) NO-LOCK
            WHERE itinerario.cod-itiner = tt-processo-imp.cod-itiner:
            ASSIGN tt-processo-imp.des-itiner = itinerario.descricao.
        END.
        FOR FIRST transporte FIELDS(nome-abrev) NO-LOCK
            WHERE transporte.cod-transp = tt-processo-imp.cod-transp:
            ASSIGN tt-processo-imp.nome-ab-transp = transporte.nome-abrev.
        END.
        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-processo-imp.cod-consignatario:
            ASSIGN tt-processo-imp.nome-consignatario = emitente.nome-abrev.
        END.
        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-processo-imp.cod-despachante:
            ASSIGN tt-processo-imp.nome-despachante = emitente.nome-abrev.
        END.
        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-processo-imp.cdn-corretor-cambio-import:
            ASSIGN tt-processo-imp.nome-corretor-cambio = emitente.nome-abrev.
        END.
        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-processo-imp.cdn-despa-exter-import:
            ASSIGN tt-processo-imp.nome-despa-exter = emitente.nome-abrev.
        END.
        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-processo-imp.cdn-segurad-import:
            ASSIGN tt-processo-imp.nome-segurad = emitente.nome-abrev.
        END.
        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-processo-imp.cdn-corretor-import:
            ASSIGN tt-processo-imp.nome-corretor = emitente.nome-abrev.
        END.
        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-processo-imp.cod-agente:
            ASSIGN tt-processo-imp.nome-agente = emitente.nome-abrev.
        END.

    END.

    /* Embarque de Importa‡Æo */
    IF p-c-tabela = "embarque-imp":U THEN DO:
        ASSIGN tt-embarque-imp.r-rowid           = ROWID(embarque-imp)
               tt-embarque-imp.des-via-transp    = {adinc/i01ad268.i 4 tt-embarque-imp.cod-via-transp}
               tt-embarque-imp.des-situacao      = {cxinc/i01cx220.i 4 tt-embarque-imp.situacao}
               tt-embarque-imp.des-natur-cambial = {cxinc/i01cx403.i 4 tt-embarque-imp.int-1} NO-ERROR.
        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-embarque-imp.cod-despachante:
            ASSIGN tt-embarque-imp.nome-despachante = emitente.nome-abrev.
        END.
        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-embarque-imp.cdn-corretor-cambio-import:
            ASSIGN tt-embarque-imp.nome-corretor-cambio = emitente.nome-abrev.
        END.
        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-embarque-imp.cdn-despa-exter-import:
            ASSIGN tt-embarque-imp.nome-despa-exter = emitente.nome-abrev.
        END.
        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-embarque-imp.cdn-segurad-import:
            ASSIGN tt-embarque-imp.nome-segurad = emitente.nome-abrev.
        END.
        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-embarque-imp.cdn-corretor-import:
            ASSIGN tt-embarque-imp.nome-corretor = emitente.nome-abrev.
        END.
        FOR FIRST transporte FIELDS(nome-abrev) NO-LOCK
            WHERE transporte.cod-transp = tt-embarque-imp.cod-transportador:
            ASSIGN tt-embarque-imp.nome-transportador = transporte.nome-abrev.
        END.
        FOR FIRST pto-contr FIELDS(descricao) NO-LOCK
            WHERE pto-contr.cod-pto-contr = tt-embarque-imp.cdn-pto-despch:
            ASSIGN tt-embarque-imp.des-pto-despch = pto-contr.descricao.
        END.
        FOR FIRST pto-contr FIELDS(descricao) NO-LOCK
            WHERE pto-contr.cod-pto-contr = tt-embarque-imp.cdn-pto-embarq:
            ASSIGN tt-embarque-imp.des-pto-embarq = pto-contr.descricao.
        END.
        FOR FIRST pto-contr FIELDS(descricao) NO-LOCK
            WHERE pto-contr.cod-pto-contr = tt-embarque-imp.cdn-pto-desembar:
            ASSIGN tt-embarque-imp.des-pto-desembar = pto-contr.descricao.
        END.
        FOR FIRST pto-contr FIELDS(descricao) NO-LOCK
            WHERE pto-contr.cod-pto-contr = tt-embarque-imp.cdn-pto-chegad:
            ASSIGN tt-embarque-imp.des-pto-chegad = pto-contr.descricao.
        END.
        FOR FIRST estabelec FIELDS(cod-estabel nome) NO-LOCK
            WHERE estabelec.cod-estabel = tt-embarque-imp.cod-estabel:
            ASSIGN tt-embarque-imp.nome-estabel = estabelec.nome.
        END.
        FOR FIRST historico-embarque
            WHERE historico-embarque.cod-estabel = tt-embarque-imp.cod-estabel
              AND historico-embarque.embarque    = tt-embarque-imp.embarque NO-LOCK:
            FOR FIRST incoterm-itiner
                WHERE incoterm-itiner.cod-itiner    = historico-embarque.cod-itiner
                  AND incoterm-itiner.cod-incoterm  = tt-embarque-imp.cod-incoterm:
                FOR FIRST pto-contr
                    WHERE pto-contr.cod-pto-contr = incoterm-itiner.cod-pto-contr NO-LOCK:
                    ASSIGN tt-embarque-imp.pto-incoterm = string(incoterm-itiner.cod-pto-contr) + " - " + pto-contr.descricao.
                END.
            END.
        END.
    END.

    /* Ordem de Compra */
    IF p-c-tabela = "ordem-compra":U THEN DO:

        ASSIGN tt-ordem-compra.r-rowid        = ROWID(ordem-compra)
               tt-ordem-compra.des-situacao   = {ininc/i02in274.i 4 tt-ordem-compra.situacao} NO-ERROR.

        FOR FIRST moeda FIELDS(descricao) NO-LOCK
            WHERE moeda.mo-codigo = tt-ordem-compra.mo-codigo:
            ASSIGN tt-ordem-compra.des-moeda = moeda.descricao.
        END.
        FOR FIRST tipo-rec-desp FIELDS(descricao) NO-LOCK
            WHERE tipo-rec-desp.tp-codigo = tt-ordem-compra.tp-despesa:
            ASSIGN tt-ordem-compra.des-tp-despesa = tipo-rec-desp.descricao.
        END.
        FOR FIRST estabelec FIELDS(cod-estabel nome) NO-LOCK
            WHERE estabelec.cod-estabel = tt-ordem-compra.cod-estabel:
            ASSIGN tt-ordem-compra.nome-estabel = estabelec.nome.

            /* Realiza a busca da conta contabil */
            RUN cdp/cd9970.p (INPUT ROWID(estabelec),
                              OUTPUT i-empresa).

            {laphtml/mlaUnifBuscaConta.i i-empresa tt-ordem-compra.ct-codigo TODAY}
            FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
            IF AVAIL tt_log_erro THEN DO:
                ASSIGN tt-ordem-compra.des-ct-codigo = "".
            END.
            ELSE DO:
                ASSIGN tt-ordem-compra.des-ct-codigo = v_titulo_cta_ctbl.
            END.

            /*Formato conta contabil*/
            RUN pi_retorna_formato_cta_ctbl IN h_api_cta_ctbl (INPUT  i-empresa,               /* EMPRESA EMS 2 */
                                                               INPUT  "",                      /* PLANO CONTAS */
                                                               INPUT  TODAY,                   /* DATA DE TRANSACAO */
                                                               OUTPUT c_cod_format_cta_ctbl,   /* FORMATO cta */
                                                               OUTPUT TABLE tt_log_erro).      /* ERROS */

            IF c_cod_format_cta_ctbl <> "" THEN
                ASSIGN tt-ordem-compra.ct-codigo = STRING(tt-ordem-compra.ct-codigo, c_cod_format_cta_ctbl).
            ELSE
                ASSIGN tt-ordem-compra.ct-codigo = tt-ordem-compra.ct-codigo.

            {laphtml/mlaUnifBuscaCC.i i-empresa tt-ordem-compra.sc-codigo TODAY}
            FIND first tt_log_erro NO-LOCK NO-ERROR.
            IF AVAIL tt_log_erro THEN DO:
                ASSIGN tt-ordem-compra.des-sc-codigo = "".
            END.
            ELSE DO:
                ASSIGN tt-ordem-compra.des-sc-codigo = v_titulo_ccusto.
            END.

            /* Formato centro de custo*/
            RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT  i-empresa,           /* EMPRESA EMS2 */
                                                           INPUT  "",                  /* PLANO CCUSTO */
                                                           INPUT  TODAY,               /* DATA DE TRANSACAO */
                                                           OUTPUT c_cod_format_ccusto, /* FORMATO CCUSTO */
                                                           OUTPUT TABLE tt_log_erro).  /* ERROS */
            IF c-formato-ccusto <> "" then
                ASSIGN tt-ordem-compra.sc-codigo = STRING(tt-ordem-compra.sc-codigo, c-formato-ccusto).
            ELSE
                ASSIGN tt-ordem-compra.sc-codigo = tt-ordem-compra.sc-codigo.
        END.
        FOR FIRST unid-negoc FIELDS (des-unid-negoc) NO-LOCK
            WHERE unid-negoc.cod-unid-negoc = tt-ordem-compra.cod-unid-negoc:
            ASSIGN tt-ordem-compra.des-cod-unid-negoc = unid-negoc.des-unid-negoc.
        END.
    END.

    /* Cota‡Æo Item */
    IF p-c-tabela = "cotacao-item":U THEN DO:
        FOR FIRST emitente FIELDS (cod-emitente nome-abrev)
            WHERE emitente.cod-emitente = tt-ordem-compra.cod-fabricante NO-LOCK:
            ASSIGN tt-ordem-compra.nome-abrev-fabricante = emitente.nome-abrev.
        END.
        FOR FIRST pto-contr FIELDS(descricao) NO-LOCK
            WHERE pto-contr.cod-pto-contr = tt-ordem-compra.cod-pto-controle-base:
            ASSIGN tt-ordem-compra.des-pto-controle-base = pto-contr.descricao.
        END.
        FOR FIRST pais FIELDS(nome-pais) NO-LOCK
            WHERE pais.cod-pais = tt-ordem-compra.cdn-pais-orig:
            ASSIGN tt-ordem-compra.des-pais-orig = pais.nome-pais.
        END.
        FOR FIRST itinerario FIELDS(descricao) NO-LOCK
            WHERE itinerario.cod-itiner = tt-ordem-compra.cod-itinerario:
            ASSIGN tt-ordem-compra.des-itinerario = itinerario.descricao.
        END.
    END.

    /* Emitente */
    IF p-c-tabela = "emitente":U THEN DO:
        ASSIGN tt-emitente.r-rowid        = ROWID(emitente).

        FOR FIRST grupo-fornec FIELDS(descricao) NO-LOCK
            WHERE grupo-fornec.cod-gr-forn = tt-emitente.cod-gr-forn:
            ASSIGN tt-emitente.des-gr-forn = grupo-fornec.descricao.
        END.
        FOR FIRST itinerario FIELDS(descricao) NO-LOCK
            WHERE itinerario.cod-itiner = tt-emitente.cod-itiner:
            ASSIGN tt-emitente.des-itiner-imp = itinerario.descricao.
        END.
        FOR FIRST pais FIELDS(nome-pais cod-pais)
            WHERE pais.nome-pais = tt-emitente.pais NO-LOCK:
            ASSIGN tt-emitente.cod-pais = pais.cod-pais.
        END.
    END.

    /* Item */
    IF p-c-tabela = "item":U THEN DO:
        ASSIGN tt-item.r-rowid        = ROWID(item)
               tt-item.des-obsoleto   = {ininc/i17in172.i 4 tt-item.cod-obsoleto}
               tt-item.des-tipo-contr   = {ininc/i09in122.i 4 tt-item.tipo-contr}
               tt-item.des-codigo-orig  = {ininc/i18in122.i 4 tt-item.codigo-orig} NO-ERROR.

        FOR FIRST grup-estoque FIELDS(descricao) NO-LOCK
            WHERE grup-estoque.ge-codigo = tt-item.ge-codigo:
            ASSIGN tt-item.ge-descricao = grup-estoque.descricao.
        END.
        FOR FIRST familia FIELDS(descricao) NO-LOCK
            WHERE familia.fm-codigo = tt-item.fm-codigo:
            ASSIGN tt-item.fm-descricao = familia.descricao.
        END.

    END.

    /* Parcelas */
    IF p-c-tabela = "prazo-compra":U THEN DO:
        ASSIGN tt-prazo-compra.r-rowid        = ROWID(prazo-compra)
               tt-prazo-compra.des-situacao   = {ininc/i02in274.i 4 tt-prazo-compra.situacao} NO-ERROR.
    END.

    /* Hist¢rico Embarque */
    IF p-c-tabela = "historico-embarque":U THEN DO:
        ASSIGN tt-historico-embarque.r-rowid        = ROWID(historico-embarque).

        FOR FIRST itinerario FIELDS(descricao) NO-LOCK
            WHERE itinerario.cod-itiner = tt-historico-embarque.cod-itiner:
            ASSIGN tt-historico-embarque.des-itiner = itinerario.descricao.
        END.
        FOR FIRST estabelec FIELDS(cod-estabel nome) NO-LOCK
            WHERE estabelec.cod-estabel = tt-historico-embarque.cod-estabel:
            ASSIGN tt-historico-embarque.nome-estabel = estabelec.nome.
        END.

    END.

    /* Despesas do Embarque */
    IF p-c-tabela = "desp-embarque":U THEN DO:
        ASSIGN tt-desp-embarque.r-rowid        = ROWID(desp-embarque).

        FOR FIRST itinerario FIELDS(descricao) NO-LOCK
            WHERE itinerario.cod-itiner = tt-desp-embarque.cod-itiner:
            ASSIGN tt-desp-embarque.des-itiner = itinerario.descricao.
        END.
        FOR FIRST historico-embarque FIELDS(descricao) NO-LOCK
            WHERE historico-embarque.cod-estabel   = tt-desp-embarque.cod-estabel
              AND historico-embarque.embarque      = tt-desp-embarque.embarque
              AND historico-embarque.cod-itiner    = tt-desp-embarque.cod-itiner
              AND historico-embarque.cod-pto-contr = tt-desp-embarque.cod-pto-contr:
            ASSIGN tt-desp-embarque.des-pto-contr = historico-embarque.descricao.
        END.
        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-desp-embarque.cod-emitente-desp:
            ASSIGN tt-desp-embarque.nome-emitente-desp = emitente.nome-abrev.
        END.
        FOR FIRST cond-pagto FIELDS(descricao) NO-LOCK
            WHERE cond-pagto.cod-cond-pag = tt-desp-embarque.cod-cond-pag:
            ASSIGN tt-desp-embarque.des-cond-pag = cond-pagto.descricao.
        END.
        FOR FIRST moeda FIELDS(descricao) NO-LOCK
            WHERE moeda.mo-codigo = tt-desp-embarque.mo-codigo:
            ASSIGN tt-desp-embarque.des-moeda = moeda.descricao.
        END.
        FOR FIRST estabelec FIELDS(cod-estabel nome) NO-LOCK
            WHERE estabelec.cod-estabel = tt-desp-embarque.cod-estabel:
            ASSIGN tt-desp-embarque.nome-estabel = estabelec.nome.
        END.

    END.

    /* Ordens da DI */
    IF p-c-tabela = "decla-import-ord":U THEN DO:
        ASSIGN tt-decla-import-ord.r-rowid        = ROWID(decla-import-ord).
    END.

    /* Declara‡Æo de Importa‡Æo */
    IF p-c-tabela = "decla-import":U THEN DO:
        ASSIGN tt-decla-import.r-rowid              = ROWID(decla-import)
               tt-decla-import.des-tip-decla-import = {cxinc/i02cx383.i 4 tt-decla-import.idi-tip-decla-import}
               tt-decla-import.des-caract-operac    = {cxinc/i03cx383.i 4 tt-decla-import.idi-caract-operac}
               tt-decla-import.des-modalid-despch   = {cxinc/i04cx383.i 4 tt-decla-import.idi-modalid-despch}
               tt-decla-import.des-via-transp-di    = {adinc/i01ad268.i 4 tt-decla-import.idi-via-transp-di}
               tt-decla-import.des-docto-carg       = {cxinc/i06cx383.i 4 tt-decla-import.idi-docto-carg}
               tt-decla-import.des-tip-conhecto     = {cxinc/i07cx383.i 4 tt-decla-import.idi-tip-conhecto}
               tt-decla-import.des-motiv-retif      = {cxinc/i01cx383.i 4 tt-decla-import.idi-motiv-retif}
               tt-decla-import.des-motiv-retif      = "" WHEN tt-decla-import.idi-motiv-retif = 0
               tt-decla-import.des-util-conhecto    = {cxinc/i08cx383.i 04 tt-decla-import.idi-ind-utiliz} NO-ERROR.

        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-decla-import.cdn-consign:
            ASSIGN tt-decla-import.nome-consign = emitente.nome-abrev.
        END.
        FOR FIRST transporte FIELDS(nome-abrev) NO-LOCK
            WHERE transporte.cod-transp = tt-decla-import.cdn-agent-carg-import:
            ASSIGN tt-decla-import.nome-agent-carg = transporte.nome-abrev.
        END.
        FOR FIRST transporte FIELDS(nome-abrev) NO-LOCK
            WHERE transporte.cod-transp = tt-decla-import.cdn-transpdor:
            ASSIGN tt-decla-import.nome-transpdor = transporte.nome-abrev.
        END.
        FOR FIRST natur-oper FIELDS(denominacao) NO-LOCK
            WHERE natur-oper.nat-operacao = tt-decla-import.cod-natur-operac:
            ASSIGN tt-decla-import.des-nat-operacao = natur-oper.denominacao.
        END.
    END.

    /* Adi‡äes da DI */
    IF p-c-tabela = "decla-import-adic":U THEN DO:
        ASSIGN tt-decla-import-adic.r-rowid                   = ROWID(decla-import-adic)
               tt-decla-import-adic.log-suspens-pis-import    = IF SUBSTRING(tt-decla-import-adic.cod-livre-1,1,1) = "1":U THEN YES ELSE NO
               tt-decla-import-adic.log-suspens-cofins-import = IF SUBSTRING(tt-decla-import-adic.cod-livre-1,2,1) = "1":U THEN YES ELSE NO
               tt-decla-import-adic.log-suspens-icms-import   = IF SUBSTRING(tt-decla-import-adic.cod-livre-1,3,1) = "1":U THEN YES ELSE NO
               tt-decla-import-adic.des-natur-cambial         = {cxinc/i01cx403.i 4 tt-decla-import-adic.idi-natur-cambial}
               tt-decla-import-adic.des-tributac-ii           = {cxinc/i01cx402.i 04 tt-decla-import-adic.idi-tributac-impto-import}
               tt-decla-import-adic.des-tributac-ipi          = {cxinc/i01cx402.i 04 tt-decla-import-adic.idi-tributac-ipi}
               tt-decla-import-adic.des-tributac-pis          = {cxinc/i01cx402.i 04 tt-decla-import-adic.idi-tributac-pis}
               tt-decla-import-adic.des-tributac-cofins       = {cxinc/i01cx402.i 04 tt-decla-import-adic.idi-tributac-cofins}
               tt-decla-import-adic.des-tributac-icms         = {cxinc/i02cx402.i 04 tt-decla-import-adic.idi-tributac-icms} NO-ERROR.

        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-decla-import-adic.cdn-fabrican:
            ASSIGN tt-decla-import-adic.nome-fabrican = emitente.nome-abrev.
        END.
        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-decla-import-adic.cdn-fornec:
            ASSIGN tt-decla-import-adic.nome-fornec = emitente.nome-abrev.
        END.
        FOR FIRST modalid-pagto FIELDS(des-modalid-pagto) NO-LOCK
            WHERE modalid-pagto.cdn-modalid-pagto = tt-decla-import-adic.cdn-modal-pagto:
            ASSIGN tt-decla-import-adic.des-modal-pagto = modalid-pagto.des-modalid-pagto.
        END.
        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-decla-import-adic.cdn-corretor:
            ASSIGN tt-decla-import-adic.nome-corretor = emitente.nome-abrev.
        END.
        FOR FIRST banco FIELDS(nome-banco) NO-LOCK
            WHERE banco.cod-banco = tt-decla-import-adic.cdn-banco:
            ASSIGN tt-decla-import-adic.nome-banco = banco.nome-banco.
        END.
        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-decla-import-adic.cdn-agent:
            ASSIGN tt-decla-import-adic.nome-agent = emitente.nome-abrev.
        END.
        FOR FIRST moeda FIELDS(descricao) NO-LOCK
            WHERE moeda.mo-codigo = tt-decla-import-adic.cdn-moeda:
            ASSIGN tt-decla-import-adic.des-moeda = moeda.descricao.
        END.
        FOR FIRST moeda FIELDS(descricao) NO-LOCK
            WHERE moeda.mo-codigo = tt-decla-import-adic.cdn-moed-frete:
            ASSIGN tt-decla-import-adic.des-moed-frete = moeda.descricao.
        END.
        FOR FIRST moeda FIELDS(descricao) NO-LOCK
            WHERE moeda.mo-codigo = tt-decla-import-adic.cdn-moed-seguro:
            ASSIGN tt-decla-import-adic.des-moed-seguro = moeda.descricao.
        END.
        FOR FIRST moeda FIELDS(descricao) NO-LOCK
            WHERE moeda.mo-codigo = param-imp.int-2:
            ASSIGN tt-decla-import-adic.des-acresc-moed = moeda.descricao.
        END.
        FOR FIRST moeda FIELDS(descricao) NO-LOCK
            WHERE moeda.mo-codigo = tt-decla-import-adic.cdn-moed-deduc:
            ASSIGN tt-decla-import-adic.des-moed-deduc = moeda.descricao.
        END.

    END.

    /* Hist¢rico da DI */
    IF p-c-tabela = "histor-decla-import":U THEN DO:
        ASSIGN tt-histor-decla-import.r-rowid        = ROWID(histor-decla-import).

        FOR FIRST bf-histor-decla-import FIELDS(cdn-pto-nacionaliz descricao)  NO-LOCK
            WHERE bf-histor-decla-import.num-di-ems         = tt-histor-decla-import.num-di-ems
              AND bf-histor-decla-import.cdd-siscomex-dts   = tt-histor-decla-import.cdd-siscomex-dts
              AND bf-histor-decla-import.cdn-pto-nacionaliz <> 0
              AND bf-histor-decla-import.cdn-pto-nacionaliz = bf-histor-decla-import.cdn-pto-contr:

            IF  i-cdn-pto-nacionaliz = 0 THEN
                ASSIGN i-cdn-pto-nacionaliz  = bf-histor-decla-import.cdn-pto-nacionaliz
                       c-desc-pto-nacionaliz = bf-histor-decla-import.descricao.
        END.

        IF tt-histor-decla-import.cdn-pto-nacionaliz = 0 THEN
            ASSIGN tt-histor-decla-import.cdn-pto-nacionaliz = i-cdn-pto-nacionaliz.
        IF tt-histor-decla-import.des-pto-nacionaliz = "":U THEN
            ASSIGN tt-histor-decla-import.des-pto-nacionaliz = c-desc-pto-nacionaliz.

        IF tt-histor-decla-import.cdn-pto-contr = tt-histor-decla-import.cdn-pto-nacionaliz THEN
            ASSIGN tt-histor-decla-import.des-pto-nacionaliz = tt-histor-decla-import.descricao.

        FOR FIRST bf-histor-decla-import FIELDS(cdn-pto-chegad descricao) NO-LOCK
            WHERE bf-histor-decla-import.num-di-ems       = tt-histor-decla-import.num-di-ems
              AND bf-histor-decla-import.cdd-siscomex-dts = tt-histor-decla-import.cdd-siscomex-dts
              AND bf-histor-decla-import.cdn-pto-chegad <> 0
              AND bf-histor-decla-import.cdn-pto-chegad = bf-histor-decla-import.cdn-pto-contr:

            IF i-cdn-pto-chegada = 0 THEN
                ASSIGN i-cdn-pto-chegada  = bf-histor-decla-import.cdn-pto-chegad
                       c-desc-pto-chegada = bf-histor-decla-import.descricao.
        END.
        IF tt-histor-decla-import.cdn-pto-chegad = 0 THEN
            ASSIGN tt-histor-decla-import.cdn-pto-chegad = i-cdn-pto-chegada.
        IF tt-histor-decla-import.des-pto-chegad = "":U THEN
            ASSIGN tt-histor-decla-import.des-pto-chegad = c-desc-pto-chegada.

        IF tt-histor-decla-import.cdn-pto-contr = tt-histor-decla-import.cdn-pto-chegad THEN
            ASSIGN tt-histor-decla-import.des-pto-chegad = tt-histor-decla-import.descricao.
    END.

    /* Despesas da DI */
    IF p-c-tabela = "despes-decla-import":U THEN DO:
        ASSIGN tt-despes-decla-import.r-rowid          = ROWID(despes-decla-import)
               tt-despes-decla-import.des-tip-incid-nf = {cxinc/i01cx406.i 4 tt-despes-decla-import.idi-tip-incid-nf} NO-ERROR.

        FOR FIRST bf-histor-decla-import FIELDS(descricao) NO-LOCK
            WHERE bf-histor-decla-import.num-di-ems       = tt-despes-decla-import.num-di-ems
              AND bf-histor-decla-import.cdd-siscomex-dts = tt-despes-decla-import.cdd-siscomex-dts
              AND bf-histor-decla-import.cdn-pto-contr = tt-despes-decla-import.cdn-pto-contr:
            ASSIGN tt-despes-decla-import.des-pto-contr = bf-histor-decla-import.descricao.
        END.
        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-despes-decla-import.cdn-emit-despes:
            ASSIGN tt-despes-decla-import.nome-emit-despes = emitente.nome-abrev.
        END.

        FOR EACH decla-import-embarq FIELDS (cod-estab cod-embarq)
           WHERE decla-import-embarq.num-di-ems       = tt-despes-decla-import.num-di-ems
             AND decla-import-embarq.cdd-siscomex-dts = tt-despes-decla-import.cdd-siscomex-dts NO-LOCK:
            FOR FIRST desp-embarque FIELDS(descricao)
                WHERE desp-embarque.cod-estabel = decla-import-embarq.cod-estab
                  AND desp-embarque.embarque    = decla-import-embarq.cod-embarq
                  AND desp-embarque.cod-desp    = tt-despes-decla-import.cdn-desp NO-LOCK:
                ASSIGN tt-despes-decla-import.des-desp = desp-embarque.descricao.
            END.
        END.

        IF tt-despes-decla-import.des-desp = "":U THEN DO:
            FOR FIRST desp-imp FIELDS(descricao) NO-LOCK
                WHERE desp-imp.cod-desp = tt-despes-decla-import.cdn-despes:
                ASSIGN tt-despes-decla-import.des-desp = desp-imp.descricao.
            END.
        END.

        FOR FIRST cond-pagto FIELDS(descricao) NO-LOCK
            WHERE cond-pagto.cod-cond-pag = tt-despes-decla-import.cdn-cond-pagto:
            ASSIGN tt-despes-decla-import.des-cond-pagto = cond-pagto.descricao.
        END.
        FOR FIRST moeda FIELDS(descricao) NO-LOCK
            WHERE moeda.mo-codigo = tt-despes-decla-import.cdn-moeda:
            ASSIGN tt-despes-decla-import.des-moeda = moeda.descricao.
        END.

    END.

    /* Documento */
    IF p-c-tabela = "docum-est":U OR p-c-tabela = "bf-docum-est":U THEN DO:

        IF p-c-tabela = "docum-est":U THEN
            ASSIGN tt-docum-est.r-rowid        = ROWID(docum-est).
        IF p-c-tabela = "bf-docum-est":U THEN
            ASSIGN tt-docum-est.r-rowid        = ROWID(bf-docum-est).

        ASSIGN tt-docum-est.des-esp-docto        = IF tt-docum-est.esp-docto <> 0 THEN {cxinc/i02cx383.i 4 tt-docum-est.esp-docto} ELSE "":U
               tt-docum-est.des-tipo-docto       = IF tt-docum-est.tipo-docto <> 0 THEN {ininc/i01in218.i 4 tt-docum-est.tipo-docto} ELSE "":U
               tt-docum-est.des-via-transp       = IF tt-docum-est.via-transp <> 0 THEN {adinc/i01ad268.i 4 tt-docum-est.via-transp} ELSE "":U
               tt-docum-est.des-mod-frete        = IF tt-docum-est.mod-frete <> 0 THEN {diinc/i01di037.i 4 tt-docum-est.mod-frete} ELSE "":U
               tt-docum-est.des-tipo-nota        = IF tt-docum-est.tipo-nota <> 0 THEN {ininc/i01in089.i 4 tt-docum-est.tipo-nota} ELSE "":U
               tt-docum-est.des-modalid-transp   = IF tt-docum-est.cdn-modalid-transp <> 0 THEN {adinc/i01ad268.i 4 tt-docum-est.cdn-modalid-transp} ELSE "":U
               tt-docum-est.des-sit-nf-eletro    = IF tt-docum-est.idi-sit-nf-eletro <> 0 THEN {diinc/i01di135.i 4 tt-docum-est.idi-sit-nf-eletro} ELSE "":U NO-ERROR.

        FOR FIRST natur-oper FIELDS(denominacao) NO-LOCK
            WHERE natur-oper.nat-operacao = tt-docum-est.nat-operacao:
            ASSIGN tt-docum-est.des-nat-operacao = natur-oper.denominacao.
        END.
        FOR FIRST moeda FIELDS(descricao) NO-LOCK
            WHERE moeda.mo-codigo = tt-docum-est.mo-codigo:
            ASSIGN tt-docum-est.des-moeda = moeda.descricao.
        END.
        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-docum-est.cod-emitente:
            ASSIGN tt-docum-est.nome-abrev = emitente.nome-abrev.
        END.
        FOR FIRST estabelec FIELDS(cod-estabel nome) NO-LOCK
            WHERE estabelec.cod-estabel = tt-docum-est.cod-estabel:
            ASSIGN tt-docum-est.nome-estabel = estabelec.nome.

            /* Realiza a busca da conta contabil */
            RUN cdp/cd9970.p (INPUT ROWID(estabelec),
                              OUTPUT i-empresa).

            {laphtml/mlaUnifBuscaConta.i i-empresa tt-docum-est.ct-transit TODAY}
            FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
            IF AVAIL tt_log_erro THEN DO:
                ASSIGN tt-docum-est.des-ct-transit = "".
            END.
            ELSE DO:
                ASSIGN tt-docum-est.des-ct-transit = v_titulo_cta_ctbl.
            END.

            /*Formato conta contabil*/
            RUN pi_retorna_formato_cta_ctbl IN h_api_cta_ctbl (INPUT  i-empresa,               /* EMPRESA EMS 2 */
                                                               INPUT  "",                      /* PLANO CONTAS */
                                                               INPUT  TODAY,                   /* DATA DE TRANSACAO */
                                                               OUTPUT c_cod_format_cta_ctbl,   /* FORMATO cta */
                                                               OUTPUT TABLE tt_log_erro).      /* ERROS */

            IF c_cod_format_cta_ctbl <> "" THEN
                ASSIGN tt-docum-est.ct-transit = STRING(tt-docum-est.ct-transit, c_cod_format_cta_ctbl).
            ELSE
                ASSIGN tt-docum-est.ct-transit = tt-docum-est.ct-transit.

            {laphtml/mlaUnifBuscaCC.i i-empresa tt-docum-est.sc-transit TODAY}
            FIND first tt_log_erro NO-LOCK NO-ERROR.
            IF AVAIL tt_log_erro THEN DO:
                ASSIGN tt-docum-est.des-sc-transit = "".
            END.
            ELSE DO:
                ASSIGN tt-docum-est.des-sc-transit = v_titulo_ccusto.
            END.

            /* formato centro de custo*/
            RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT  i-empresa,           /* EMPRESA EMS2 */
                                                           INPUT  "",                  /* PLANO CCUSTO */
                                                           INPUT  TODAY,               /* DATA DE TRANSACAO */
                                                           OUTPUT c_cod_format_ccusto, /* FORMATO CCUSTO */
                                                           OUTPUT TABLE tt_log_erro).  /* ERROS */
            IF c_cod_format_ccusto <> "" THEN
                ASSIGN tt-docum-est.sc-transit = STRING(tt-docum-est.sc-transit, c_cod_format_ccusto).
            ELSE
                ASSIGN tt-docum-est.sc-transit = tt-docum-est.sc-transit.
        END.
    END.

    /* Item do Documento */
    IF p-c-tabela = "item-doc-est":U OR p-c-tabela = "bf-item-doc-est":U THEN DO:
        IF p-c-tabela = "item-doc-est":U THEN
            ASSIGN tt-item-doc-est.r-rowid        = ROWID(item-doc-est).
        IF p-c-tabela = "bf-item-doc-est":U THEN
            ASSIGN tt-item-doc-est.r-rowid        = ROWID(bf-item-doc-est).

        ASSIGN tt-item-doc-est.des-trib-icm        = {ininc/i07in122.i 4 tt-item-doc-est.cd-trib-icm}
               tt-item-doc-est.des-trib-ipi        = {ininc/i10in172.i 4 tt-item-doc-est.cd-trib-ipi}
               tt-item-doc-est.des-tributac-cofins = {ininc/i04in176.i 4 tt-item-doc-est.idi-tributac-cofins}
               tt-item-doc-est.des-tributac-pis    = {ininc/i04in176.i 4 tt-item-doc-est.idi-tributac-pis}    NO-ERROR.

        FOR FIRST bf-docum-est-aux FIELDS(cod-estabel)
            WHERE bf-docum-est-aux.serie-docto  = tt-item-doc-est.serie-docto
              AND bf-docum-est-aux.nro-docto    = tt-item-doc-est.nro-docto
              AND bf-docum-est-aux.cod-emitente = tt-item-doc-est.cod-emitente
              AND bf-docum-est-aux.nat-operacao = tt-item-doc-est.nat-operacao NO-LOCK:

            FOR FIRST estabelec NO-LOCK
                WHERE estabelec.cod-estabel = bf-docum-est-aux.cod-estabel:
                /* Realiza a busca da conta contabil */
                RUN cdp/cd9970.p (INPUT ROWID(estabelec),
                                  OUTPUT i-empresa).

                {laphtml/mlaUnifBuscaConta.i i-empresa tt-item-doc-est.ct-codigo TODAY}
                FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
                IF AVAIL tt_log_erro THEN DO:
                    ASSIGN tt-item-doc-est.des-ct-codigo = "".
                END.
                ELSE DO:
                    ASSIGN tt-item-doc-est.des-ct-codigo = v_titulo_cta_ctbl.
                END.

                /*Formato conta contabil*/
                RUN pi_retorna_formato_cta_ctbl IN h_api_cta_ctbl (INPUT  i-empresa,               /* EMPRESA EMS 2 */
                                                                   INPUT  "",                      /* PLANO CONTAS */
                                                                   INPUT  TODAY,                   /* DATA DE TRANSACAO */
                                                                   OUTPUT c_cod_format_cta_ctbl,   /* FORMATO cta */
                                                                   OUTPUT TABLE tt_log_erro).      /* ERROS */

                IF c_cod_format_cta_ctbl <> "" THEN
                    ASSIGN tt-item-doc-est.ct-codigo = STRING(tt-item-doc-est.ct-codigo, c_cod_format_cta_ctbl).
                ELSE
                    ASSIGN tt-item-doc-est.ct-codigo = tt-item-doc-est.ct-codigo.

                {laphtml/mlaUnifBuscaCC.i i-empresa tt-item-doc-est.sc-codigo TODAY}
                FIND first tt_log_erro NO-LOCK NO-ERROR.
                IF AVAIL tt_log_erro THEN DO:
                    ASSIGN tt-item-doc-est.des-sc-codigo = "".
                END.
                ELSE DO:
                    ASSIGN tt-item-doc-est.des-sc-codigo = v_titulo_ccusto.
                END.

                /* Formato centro de custo*/
                RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT  i-empresa,           /* EMPRESA EMS2 */
                                                               INPUT  "",                  /* PLANO CCUSTO */
                                                               INPUT  TODAY,               /* DATA DE TRANSACAO */
                                                               OUTPUT c_cod_format_ccusto, /* FORMATO CCUSTO */
                                                               OUTPUT TABLE tt_log_erro).  /* ERROS */
                IF c-formato-ccusto <> "" then
                    ASSIGN tt-item-doc-est.sc-codigo = STRING(tt-item-doc-est.sc-codigo, c-formato-ccusto).
                ELSE
                    ASSIGN tt-item-doc-est.sc-codigo = tt-item-doc-est.sc-codigo.
            END.
        END.

        FOR FIRST ITEM FIELDS (desc-item) NO-LOCK
            WHERE ITEM.it-codigo = tt-item-doc-est.it-codigo:
            ASSIGN tt-item-doc-est.des-it-codigo = ITEM.desc-item.
        END.


        /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-965) */
        IF  l-nt2024002 THEN DO:
            FOR EACH  item-doc-est-tribut NO-LOCK
                WHERE item-doc-est-tribut.cod-serie-docto  = tt-item-doc-est.serie-docto
                AND   item-doc-est-tribut.cod-num-docto    = tt-item-doc-est.nro-docto
                AND   item-doc-est-tribut.cdn-emitente     = tt-item-doc-est.cod-emitente
                AND   item-doc-est-tribut.cod-natur-operac = tt-item-doc-est.nat-operacao
                AND   item-doc-est-tribut.num-seq          = tt-item-doc-est.sequencia:

                IF (item-doc-est-tribut.nom-trib <> "CBS":U
                AND item-doc-est-tribut.nom-trib <> "IBS UF":U
                AND item-doc-est-tribut.nom-trib <> "IBS MUN":U
                AND item-doc-est-tribut.nom-trib <> "IS":U)
                OR (item-doc-est-tribut.cod-campo <> "VALOR":U
                AND item-doc-est-tribut.cod-campo <> "ALIQUOTA":U
                AND item-doc-est-tribut.cod-campo <> "ALIQ ESPEC UN":U
                AND item-doc-est-tribut.cod-campo <> "QTDE TRIBUT":U
                AND item-doc-est-tribut.cod-campo <> "BASE":U
                AND item-doc-est-tribut.cod-campo <> "COD CLASS TRIB":U
                AND item-doc-est-tribut.cod-campo <> "CST":U) THEN
                    NEXT.

                CASE item-doc-est-tribut.cod-campo:
                    WHEN "VALOR":U THEN DO:
                        IF  item-doc-est-tribut.nom-trib = "CBS":U THEN
                            ASSIGN tt-item-doc-est.val-cbs = DEC(item-doc-est-tribut.cod-conteudo).
                        IF  item-doc-est-tribut.nom-trib = "IBS UF":U THEN
                            ASSIGN tt-item-doc-est.val-ibs-uf = DEC(item-doc-est-tribut.cod-conteudo).
                        IF item-doc-est-tribut.nom-trib = "IBS MUN":U THEN
                            ASSIGN tt-item-doc-est.val-ibs-mun = DEC(item-doc-est-tribut.cod-conteudo). 
                        IF item-doc-est-tribut.nom-trib = "IS":U THEN
                            ASSIGN tt-item-doc-est.val-is = DEC(item-doc-est-tribut.cod-conteudo).
                    END.

                    WHEN "ALIQUOTA":U THEN DO:
                        IF  item-doc-est-tribut.nom-trib = "CBS":U THEN
                            ASSIGN tt-item-doc-est.aliquota-cbs = DEC(item-doc-est-tribut.cod-conteudo).
                        IF  item-doc-est-tribut.nom-trib = "IBS UF":U THEN
                            ASSIGN tt-item-doc-est.aliquota-ibs-uf = DEC(item-doc-est-tribut.cod-conteudo).
                        IF item-doc-est-tribut.nom-trib = "IBS MUN":U THEN
                            ASSIGN tt-item-doc-est.aliquota-ibs-mun = DEC(item-doc-est-tribut.cod-conteudo).
                        IF item-doc-est-tribut.nom-trib = "IS":U THEN
                            ASSIGN tt-item-doc-est.aliquota-is = DEC(item-doc-est-tribut.cod-conteudo).    
                    END.
                    
                    WHEN "ALIQ ESPEC UN":U THEN DO:
                        IF item-doc-est-tribut.nom-trib = "IS":U THEN
                            ASSIGN tt-item-doc-est.aliq-espec-un-is =
                                       DEC(item-doc-est-tribut.cod-conteudo).
                    END.
                    
                    WHEN "QTDE TRIBUT":U THEN DO:
                        IF item-doc-est-tribut.nom-trib = "IS":U THEN
                            ASSIGN tt-item-doc-est.qtde-tribut-is =
                                       DEC(item-doc-est-tribut.cod-conteudo).
                    END.
                    
                    WHEN "BASE":U THEN DO:
                        IF  item-doc-est-tribut.nom-trib = "CBS":U THEN
                            ASSIGN tt-item-doc-est.base-cbs = DEC(item-doc-est-tribut.cod-conteudo).
                        IF  item-doc-est-tribut.nom-trib = "IBS UF":U THEN
                            ASSIGN tt-item-doc-est.base-ibs-uf = DEC(item-doc-est-tribut.cod-conteudo).
                        IF item-doc-est-tribut.nom-trib = "IBS MUN":U THEN
                            ASSIGN tt-item-doc-est.base-ibs-mun = DEC(item-doc-est-tribut.cod-conteudo). 
                        IF item-doc-est-tribut.nom-trib = "IS":U THEN
                            ASSIGN tt-item-doc-est.base-is = DEC(item-doc-est-tribut.cod-conteudo).
                    END.

                    WHEN "COD CLASS TRIB":U THEN DO:
                        IF  item-doc-est-tribut.nom-trib = "CBS":U THEN
                            ASSIGN tt-item-doc-est.class-trib-cbs = TRIM(item-doc-est-tribut.cod-conteudo).
                        IF  item-doc-est-tribut.nom-trib = "IBS UF":U THEN
                            ASSIGN tt-item-doc-est.class-trib-ibs-uf = TRIM(item-doc-est-tribut.cod-conteudo).
                        IF item-doc-est-tribut.nom-trib = "IBS MUN":U THEN
                            ASSIGN tt-item-doc-est.class-trib-ibs-mun = TRIM(item-doc-est-tribut.cod-conteudo).
                        IF item-doc-est-tribut.nom-trib = "IS":U THEN
                            ASSIGN tt-item-doc-est.class-trib-is = TRIM(item-doc-est-tribut.cod-conteudo).
                    END.

                    WHEN "CST":U THEN DO:
                        IF  item-doc-est-tribut.nom-trib = "CBS":U THEN
                            ASSIGN tt-item-doc-est.cst-cbs = TRIM(item-doc-est-tribut.cod-conteudo).
                        IF  item-doc-est-tribut.nom-trib = "IBS UF":U THEN
                            ASSIGN tt-item-doc-est.cst-ibs-uf = TRIM(item-doc-est-tribut.cod-conteudo).
                        IF item-doc-est-tribut.nom-trib = "IBS MUN":U THEN
                            ASSIGN tt-item-doc-est.cst-ibs-mun = TRIM(item-doc-est-tribut.cod-conteudo).
                        IF item-doc-est-tribut.nom-trib = "IS":U THEN
                            ASSIGN tt-item-doc-est.cst-is = TRIM(item-doc-est-tribut.cod-conteudo).
                    END.
                END CASE.
            END.
        END.
        /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-965) */
    END.

    /* Estoque */
    IF p-c-tabela = "rat-lote":U THEN DO:
        ASSIGN tt-rat-lote.r-rowid        = ROWID(rat-lote)
               tt-rat-lote.des-tipo-nota  = {ininc/i01in089.i 4 tt-rat-lote.tipo-nota} NO-ERROR.
    END.

    /* Despesas Item Documento */
    IF p-c-tabela = "item-doc-est-cex":U THEN DO:
        ASSIGN tt-item-doc-est-cex.r-rowid        = ROWID(tt-item-doc-est-cex)
               tt-item-doc-est-cex.des-sit-despes = {ininc/i01in710.i 4 tt-item-doc-est-cex.idi-sit-despes} NO-ERROR.

        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-item-doc-est-cex.cod-emitente-desp:
            ASSIGN tt-item-doc-est-cex.nome-emitente-desp = emitente.nome-abrev.
        END.
        FOR FIRST desp-imp FIELDS(descricao) NO-LOCK
            WHERE desp-imp.cod-desp = tt-item-doc-est-cex.cod-desp:
            ASSIGN tt-item-doc-est-cex.des-desp = desp-imp.descricao.
        END.
        FOR FIRST moeda FIELDS(descricao) NO-LOCK
            WHERE moeda.mo-codigo = tt-item-doc-est-cex.mo-codigo:
            ASSIGN tt-item-doc-est-cex.des-moeda = moeda.descricao.
        END.

    END.

    /* Duplicatas */
    IF p-c-tabela = "dupli-apagar":U THEN DO:
        ASSIGN tt-dupli-apagar.r-rowid        = ROWID(dupli-apagar)
               tt-dupli-apagar.des-esp-movto  = {ininc/i01in088.i 4 tt-dupli-apagar.esp-movto} NO-ERROR.

        FOR FIRST tipo-rec-desp FIELDS(descricao) NO-LOCK
            WHERE tipo-rec-desp.tp-codigo = tt-dupli-apagar.tp-despesa:
            ASSIGN tt-dupli-apagar.des-tp-despesa = tipo-rec-desp.descricao.
        END.
        FOR FIRST moeda FIELDS(descricao) NO-LOCK
            WHERE moeda.mo-codigo = tt-dupli-apagar.mo-codigo:
            ASSIGN tt-dupli-apagar.des-moeda = moeda.descricao.
        END.
        FOR FIRST moeda FIELDS(descricao) NO-LOCK
            WHERE moeda.mo-codigo = tt-dupli-apagar.mo-codigo-mo:
            ASSIGN tt-dupli-apagar.des-moeda-mo = moeda.descricao.
        END.

    END.

    /* Despesas de Importa‡Æo */
    IF p-c-tabela = "docum-est-cex":U THEN DO:
        ASSIGN tt-docum-est-cex.r-rowid        = ROWID(docum-est-cex).

        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-docum-est-cex.cod-emitente-desp:
            ASSIGN tt-docum-est-cex.nome-emitente-desp = emitente.nome-abrev.
        END.
        FOR FIRST desp-imp FIELDS(descricao) NO-LOCK
            WHERE desp-imp.cod-desp = tt-docum-est-cex.cod-desp:
            ASSIGN tt-docum-est-cex.des-desp = desp-imp.descricao.
        END.
        FOR FIRST cond-pagto FIELDS(descricao) NO-LOCK
            WHERE cond-pagto.cod-cond-pag = tt-docum-est-cex.cod-cond-pag:
            ASSIGN tt-docum-est-cex.des-cond-pag = cond-pagto.descricao.
        END.
        FOR FIRST moeda FIELDS(descricao) NO-LOCK
            WHERE moeda.mo-codigo = tt-docum-est-cex.mo-codigo:
            ASSIGN tt-docum-est-cex.des-moeda = moeda.descricao.
        END.

    END.

    /* Duplicatas Despesas */
    IF p-c-tabela = "dupli-apagar-cex":U THEN DO:
        ASSIGN tt-dupli-apagar-cex.r-rowid        = ROWID(dupli-apagar-cex)
               tt-dupli-apagar-cex.des-esp-movto  = {ininc/i01in088.i 4 tt-dupli-apagar-cex.esp-movto} NO-ERROR.

        FOR FIRST emitente FIELDS(cod-emitente nome-abrev) NO-LOCK
            WHERE emitente.cod-emitente = tt-dupli-apagar-cex.cod-emitente-desp:
            ASSIGN tt-dupli-apagar-cex.nome-emitente-desp = emitente.nome-abrev.
        END.
        FOR FIRST tipo-rec-desp FIELDS(descricao) NO-LOCK
            WHERE tipo-rec-desp.tp-codigo = tt-dupli-apagar-cex.tp-despesa:
            ASSIGN tt-dupli-apagar-cex.des-tp-despesa = tipo-rec-desp.descricao.
        END.
        FOR FIRST moeda FIELDS(descricao) NO-LOCK
            WHERE moeda.mo-codigo = tt-dupli-apagar-cex.mo-codigo:
            ASSIGN tt-dupli-apagar-cex.des-moeda = moeda.descricao.
        END.

    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-envia-tts-excel:
/*--------------------------------------------------------------------------------
  Purpose:     Envia as temp-tables para o programa que far  a gera‡Æo da planilha
  Parameters:  <none>
  Notes:
---------------------------------------------------------------------------------*/
    IF param-global.modulo-07 THEN DO:
        IF tt-param.lUtilizaLayout THEN DO:
            FOR FIRST usuar-import NO-LOCK
                 WHERE usuar-import.cod-usuar = c-seg-usuario:
                ASSIGN tt-param.cLayoutPadrao = TRIM(usuar-import.des-layout-origin-gerc).
            END.
        END.
        RUN imp/im0730a.p(INPUT  TABLE tt-param,
                          INPUT  TABLE tt-pedido-compr,
                          INPUT  TABLE tt-emitente,
                          INPUT  TABLE tt-processo-imp,
                          INPUT  TABLE tt-ordem-compra,
                          INPUT  TABLE tt-item,
                          INPUT  TABLE tt-embarque-imp,
                          INPUT  TABLE tt-ordens-embarque,
                          INPUT  TABLE tt-prazo-compra,
                          INPUT  TABLE tt-historico-embarque,
                          INPUT  TABLE tt-desp-embarque,
                          INPUT  TABLE tt-embarque-contab,
                          INPUT  TABLE tt-decla-import,
                          INPUT  TABLE tt-decla-import-ord,
                          INPUT  TABLE tt-decla-import-adic,
                          INPUT  TABLE tt-histor-decla-import,
                          INPUT  TABLE tt-despes-decla-import,
                          INPUT  TABLE tt-docum-est,
                          INPUT  TABLE tt-item-doc-est,
                          INPUT  TABLE tt-item-doc-est-cex,
                          INPUT  TABLE tt-rat-lote,
                          INPUT  TABLE tt-docum-est-cex,
                          INPUT  TABLE tt-dupli-apagar,
                          INPUT  TABLE tt-dupli-apagar-cex,
                          INPUT  TABLE tt-rat-docum,
                          OUTPUT TABLE tt-documentos-erros,
                          OUTPUT TABLE tt-documentos-impressos,
                          OUTPUT TABLE tt-erros-email).
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-relatorio-acomp:
/*------------------------------------------------------------------------------
  Purpose:     Cria o relat¢rio TXT apresentado no fim da execu‡Æo
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    IF  CAN-FIND (FIRST tt-documentos-erros) OR
       (CAN-FIND (FIRST tt-erros-email) AND tt-param.lEnviaDoct) THEN DO:
        {utp/ut-liter.i ERROS * L}
        put RETURN-VALUE formaT "x(10)":U.
        PUT UNFORMATTED skip(1).
    END.
    FOR EACH tt-documentos-erros:

        disp tt-documentos-erros.nr-mensag   @ i-nr-mensag
             tt-documentos-erros.mensagem    @ c-mensagem
             with frame f-doc-erros.
        down with frame f-doc-erros.
    END.

    IF  CAN-FIND (FIRST tt-documentos-impressos) THEN DO:
        IF  CAN-FIND (FIRST tt-documentos-erros) THEN
            put unformaTted skip(1).

        {utp/ut-liter.i DOCUMENTOS_IMPRESSOS * L}
        put RETURN-VALUE formaT "x(30)":U.
        put unformaTted skip(1).
    END.
    FOR EACH tt-documentos-impressos:

        disp tt-documentos-impressos.destino     @ c-destino
             with frame f-doc-impressos.
        down with frame f-doc-impressos.
    END.

    IF tt-param.lEnviaDoct THEN DO:
        PUT UNFORMATTED skip(1).
        {utp/ut-liter.i Envio_de_E-mail: * L}
        put RETURN-VALUE formaT "x(100)":U.
        PUT UNFORMATTED SKIP.
        PUT UNFORMATTED "-------------------------------------------------------------------------------":U.
        put UNFORMATTED SKIP.
        IF CAN-FIND(FIRST tt-erros-email) THEN DO:
            FOR EACH tt-erros-email:
                disp tt-erros-email.codigo    @ i-nr-mensag
                     tt-erros-email.descricao @ c-mensagem
                     with frame f-doc-erros.
                down with frame f-doc-erros.
            END.
        END.
        ELSE DO:
            run utp/ut-msgs.p (input "msg":U,
                               input 25695,
                               input "":U).
            PUT UNFORMATTED RETURN-VALUE formaT "x(90)":U.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-parametros:
/*------------------------------------------------------------------------------
  Purpose:     Imprime os parƒmetros selecionados em rela no Relat¢rio TXT
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    IF NOT CAN-FIND (FIRST tt-documentos-erros) AND
       NOT CAN-FIND (FIRST tt-documentos-impressos) AND
       NOT CAN-FIND (FIRST tt-erros-email) THEN
       PAGE.

    /* Sele‡Æo */
    DISPLAY c-titulo-s
            c-lbl-dados-imp
            c-lbl-estabel
            tt-param.cProcEstabIni
            tt-param.cProcEstabFim
            c-lbl-proc-imp
            tt-param.cProcImpIni
            tt-param.cProcImpFim
            c-lbl-emit-proc
            tt-param.iEmitProcIni
            tt-param.iEmitProcFim
            c-lbl-dt-emis
            tt-param.dDataEmisIni
            tt-param.dDataEmisFim
            c-lbl-dados-emb
            c-lbl-estab-emb
            tt-param.cEmbEstabIni
            tt-param.cEmbEstabFim
            c-lbl-embarq
            tt-param.cEmbarqueIni
            tt-param.cEmbarqueFim
            c-lbl-di-sis
            tt-param.cDISiscomexIni
            tt-param.cDISiscomexFim
            c-lbl-di-ems
            tt-param.iDIEMSIni
            tt-param.iDIEMSFim
            c-lbl-dt-di
            tt-param.dDataDIIni
            tt-param.dDataDIFim
            c-lbl-dados-ped
            c-lbl-estab-ped
            tt-param.cPedEstabIni
            tt-param.cPedEstabFim
            c-lbl-pedido
            tt-param.iPedidoIni
            tt-param.iPedidoFim
            c-lbl-ordem
            tt-param.iOrdemCompraIni
            tt-param.iOrdemCompraFim
            c-lbl-emit-ped
            tt-param.iEmitPedIni
            tt-param.iEmitPedFim
            c-lbl-dt-ped
            tt-param.dDataPedIni
            tt-param.dDataPedFim
            WITH FRAME f-selecao.

    {utp/ut-liter.i Sim/NÆo *}
    assign tt-param.lPedidoCompra :FORMAT IN FRAME f-parametros = RETURN-VALUE
           tt-param.lProcessoImp  :FORMAT IN FRAME f-parametros = RETURN-VALUE
           tt-param.lFornecedor   :FORMAT IN FRAME f-parametros = RETURN-VALUE
           tt-param.lOrdemCompra  :FORMAT IN FRAME f-parametros = RETURN-VALUE
           tt-param.lParcelas     :FORMAT IN FRAME f-parametros = RETURN-VALUE
           tt-param.lItem         :FORMAT IN FRAME f-parametros = RETURN-VALUE
           tt-param.lDeclaImport  :FORMAT IN FRAME f-parametros = RETURN-VALUE
           tt-param.lAdicoesDI    :FORMAT IN FRAME f-parametros = RETURN-VALUE
           tt-param.lAcompDI      :FORMAT IN FRAME f-parametros = RETURN-VALUE
           tt-param.lEmbarqueImp  :FORMAT IN FRAME f-parametros = RETURN-VALUE
           tt-param.lAcompEmb     :FORMAT IN FRAME f-parametros = RETURN-VALUE
           tt-param.lDocumentos   :FORMAT IN FRAME f-parametros = RETURN-VALUE
           tt-param.lItensDoc     :FORMAT IN FRAME f-parametros = RETURN-VALUE
           tt-param.lDespItemDoc  :FORMAT IN FRAME f-parametros = RETURN-VALUE
           tt-param.lMovtoEstoq   :FORMAT IN FRAME f-parametros = RETURN-VALUE
           tt-param.lDuplicatas   :FORMAT IN FRAME f-parametros = RETURN-VALUE
           tt-param.lDespImp      :FORMAT IN FRAME f-parametros = RETURN-VALUE
           tt-param.lDupDespesas  :FORMAT IN FRAME f-parametros = RETURN-VALUE
           tt-param.lNFCompl      :FORMAT IN FRAME f-parametros = RETURN-VALUE
           tt-param.lEnviaDocto   :FORMAT IN FRAME f-parametros = RETURN-VALUE
           tt-param.lUtilizaLayout:FORMAT IN FRAME f-parametros = RETURN-VALUE
           tt-param.lSobreporArq  :FORMAT IN FRAME f-parametros = RETURN-VALUE.

    /* Parametros */
    DISPLAY c-titulo-p
            c-lbl-detalhar
            c-lbl-pedcomp      tt-param.lPedidoCompra
            c-lbl-procimp      tt-param.lProcessoImp
            c-lbl-fornec       tt-param.lFornecedor
            c-lbl-ordcomp      tt-param.lOrdemCompra
            c-lbl-parcela      tt-param.lParcelas
            c-lbl-item         tt-param.lItem
            c-lbl-declimp      tt-param.lDeclaImport
            c-lbl-adicdi       tt-param.lAdicoesDI
            c-lbl-acompdi      tt-param.lAcompDI
            c-lbl-embimp       tt-param.lEmbarqueImp
            c-lbl-acompemb     tt-param.lAcompEmb
            c-lbl-docto        tt-param.lDocumentos
            c-lbl-itdocto      tt-param.lItensDoc
            c-lbl-despitemdoc  tt-param.lDespItemDoc
            c-lbl-movestoq     tt-param.lMovtoEstoq
            c-lbl-duplic       tt-param.lDuplicatas
            c-lbl-despimp      tt-param.lDespImp
            c-lbl-dupdesp      tt-param.lDupDespesas
            c-lbl-nfcompl      tt-param.lNFCompl
            c-lbl-envia-doct   tt-param.lEnviaDocto
            c-lbl-destinatario tt-param.cDestinatario
            c-lbl-utiliza-lay  tt-param.lUtilizaLayout
            c-lbl-layout-p     tt-param.cLayoutPadrao   FORMAT "x(80)":U
            c-lbl-sobrepor     tt-param.lSobreporArq
            c-lbl-destino-text tt-param.cDestinoArq     FORMAT "x(80)":U WITH FRAME f-parametros.

    /* ImpressÆo */
    DISPLAY c-titulo-imp
            c-lbl-usuario         tt-param.usuario
            c-lbl-destino-txt     tt-param.arquivo  WITH FRAME f-impressao.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-documentos:
/*------------------------------------------------------------------------------
  Purpose:     Cria as temp-tables com os dados de Documentos relacionados aos
               processos de importa‡Æo
  Parameters:  p-cod-estabel: C¢digo do estabelecimento (character)
               p-embarque: C¢digo do embarque (character)
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-estabel LIKE embarque-imp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER p-embarque    LIKE embarque-imp.embarque    NO-UNDO.

    FOR EACH embarq-import-docto
       WHERE embarq-import-docto.cod-estab  = p-cod-estabel
         AND embarq-import-docto.cod-embarq = p-embarque    NO-LOCK:

        IF NOT CAN-FIND (FIRST tt-docum-est
                         WHERE tt-docum-est.serie-docto  = embarq-import-docto.cod-ser-docto
                           AND tt-docum-est.nro-docto    = embarq-import-docto.cod-docto
                           AND tt-docum-est.cod-emitente = embarq-import-docto.cdn-emitente
                           AND tt-docum-est.nat-operacao = embarq-import-docto.cod-natur-operac) THEN DO:

            FOR FIRST docum-est
                WHERE docum-est.serie-docto  = embarq-import-docto.cod-ser-docto
                  AND docum-est.nro-docto    = embarq-import-docto.cod-docto
                  AND docum-est.cod-emitente = embarq-import-docto.cdn-emitente
                  AND docum-est.nat-operacao = embarq-import-docto.cod-natur-operac NO-LOCK:

                CREATE tt-docum-est.
                BUFFER-COPY docum-est TO tt-docum-est.
                ASSIGN tt-docum-est.log-gera-prim-remes-nf-mae = IF TRIM(SUBSTRING(docum-est.char-1,209,1)) = "S":U THEN YES ELSE NO.
                IF tt-docum-est.idi-nf-simples-remes = 1 THEN DO: /* "nota mÆe" */
                    {utp/ut-liter.i "Nota_MÆe"}
                END.
                ELSE IF tt-docum-est.idi-nf-simples-remes = 2 THEN DO: /* nota filha */
                     {utp/ut-liter.i "Nota_Filha"}
                END.
                ELSE DO:
                    IF CAN-FIND(FIRST natur-oper
                                WHERE natur-oper.nat-operacao = tt-docum-est.nat-operacao
                                  AND natur-oper.nota-rateio) THEN DO:
                        {utp/ut-liter.i "Nota_Complementar"}
                    END.
                    ELSE DO:
                        IF CAN-FIND(FIRST item-doc-est
                                     WHERE item-doc-est.serie-docto     = tt-docum-est.serie-docto
                                       AND item-doc-est.nro-docto       = tt-docum-est.nro-docto
                                       AND item-doc-est.cod-emitente    = tt-docum-est.cod-emitente
                                       AND item-doc-est.nat-operacao    = tt-docum-est.nat-operacao
                                       AND item-doc-est.log-nota-ajust-import) THEN
                           {utp/ut-liter.i "Nota_Ajuste"}
                        ELSE
                           {utp/ut-liter.i "Nota_Normal"}
                    END.
                END.
                ASSIGN tt-docum-est.des-tipo-nota-imp = TRIM(RETURN-VALUE).

                RUN pi-campos-descricao (INPUT "docum-est":U).

                FOR EACH item-doc-est NO-LOCK
                    WHERE item-doc-est.serie-docto  = docum-est.serie-docto
                      AND item-doc-est.nro-docto    = docum-est.nro-docto
                      AND item-doc-est.cod-emitente = docum-est.cod-emitente
                      AND item-doc-est.nat-operacao = docum-est.nat-operacao:

                    CREATE tt-item-doc-est.
                    BUFFER-COPY item-doc-est TO tt-item-doc-est.
                    ASSIGN tt-item-doc-est.log-gera-prim-remes-nf-mae = IF TRIM(SUBSTRING(tt-item-doc-est.char-2,940,1)) = "S":U THEN YES ELSE NO.

                    RUN pi-campos-descricao (INPUT "item-doc-est":U).

                    /* Nota Fiscal Simples Remessa
                       N£mero da Ordem/Parcela para relacionamento na impressÆo */
                    IF  docum-est.idi-nf-simples-remes = 1 THEN
                        ASSIGN tt-item-doc-est.numero-ordem-aux = tt-item-doc-est.num-ord-import
                               tt-item-doc-est.parcela-aux      = tt-item-doc-est.num-parc-import.
                    ELSE
                        ASSIGN tt-item-doc-est.numero-ordem-aux = tt-item-doc-est.numero-ordem
                               tt-item-doc-est.parcela-aux      = tt-item-doc-est.parcela.


                    IF tt-param.lMovtoEstoq THEN DO:
                        FOR EACH rat-lote NO-LOCK
                            WHERE rat-lote.serie-docto  = item-doc-est.serie-docto
                              AND rat-lote.nro-docto    = item-doc-est.nro-docto
                              AND rat-lote.cod-emitente = item-doc-est.cod-emitente
                              AND rat-lote.nat-operacao = item-doc-est.nat-operacao
                              AND rat-lote.sequencia    = item-doc-est.sequencia:

                            CREATE tt-rat-lote.
                            BUFFER-COPY rat-lote TO tt-rat-lote.
                            RUN pi-campos-descricao (INPUT "rat-lote":U).

                            IF l-integra-ems-his THEN DO:
                                &if "{&bf_mat_versao_ems}" >= "2.09":U &then
                                    ASSIGN i-fabrican = rat-lote.cdn-fabrican.
                                &ELSE
                                    ASSIGN i-fabrican = int(substring(rat-lote.char-2, 71, 9)).
                                &ENDIF

                                ASSIGN tt-rat-lote.cdn-fabrican = i-fabrican
                                       tt-rat-lote.nom-fabrican = "".

                                FOR FIRST fab-medic FIELDS (nom-fabrican) NO-LOCK
                                     WHERE fab-medic.cdn-fabrican = tt-rat-lote.cdn-fabrican:
                                    ASSIGN tt-rat-lote.nom-fabrican = fab-medic.nom-fabrican.
                                END.
                            END.

                        END.
                    END.

                    IF tt-param.lDespItemDoc THEN DO:
                        FOR EACH item-doc-est-cex NO-LOCK
                            WHERE item-doc-est-cex.serie-docto  = item-doc-est.serie-docto
                              AND item-doc-est-cex.nro-docto    = item-doc-est.nro-docto
                              AND item-doc-est-cex.cod-emitente = item-doc-est.cod-emitente
                              AND item-doc-est-cex.nat-operacao = item-doc-est.nat-operacao
                              AND item-doc-est-cex.sequencia    = item-doc-est.sequencia:

                            CREATE tt-item-doc-est-cex.
                            BUFFER-COPY item-doc-est-cex TO tt-item-doc-est-cex.
                            RUN pi-campos-descricao (INPUT "item-doc-est-cex":U).
                        END.
                    END.
                END.

                IF tt-param.lDuplicatas THEN DO:
                    IF NOT CAN-FIND (FIRST tt-dupli-apagar
                                     WHERE tt-dupli-apagar.serie-docto  = docum-est.serie-docto
                                       AND tt-dupli-apagar.nro-docto    = docum-est.nro-docto
                                       AND tt-dupli-apagar.cod-emitente = docum-est.cod-emitente
                                       AND tt-dupli-apagar.nat-operacao = docum-est.nat-operacao) THEN DO:

                        FOR EACH dupli-apagar NO-LOCK
                            WHERE dupli-apagar.serie-docto  = docum-est.serie-docto
                              AND dupli-apagar.nro-docto    = docum-est.nro-docto
                              AND dupli-apagar.cod-emitente = docum-est.cod-emitente
                              AND dupli-apagar.nat-operacao = docum-est.nat-operacao:

                            CREATE tt-dupli-apagar.
                            BUFFER-COPY dupli-apagar TO tt-dupli-apagar.

                            {rep/re1001c.i50}
                            {cdp/cd4300.i4  "yes" tt-dupli-apagar.char-1}
                            {rep/re1001c.i51 "yes"}

                            ASSIGN tt-dupli-apagar.mo-codigo-mo  = i-mo-codigo
                                   tt-dupli-apagar.vl-a-pagar-mo = de-vl-a-pagar-mo
                                   tt-dupli-apagar.vl-descto-mo  = de-vl-descto-mo.

                            RUN pi-campos-descricao (INPUT "dupli-apagar":U).
                        END.
                    END.
                END.

                IF tt-param.lDespImp THEN DO:
                    IF NOT CAN-FIND (FIRST tt-docum-est-cex
                                     WHERE tt-docum-est-cex.serie-docto  = docum-est.serie-docto
                                       AND tt-docum-est-cex.nro-docto    = docum-est.nro-docto
                                       AND tt-docum-est-cex.cod-emitente = docum-est.cod-emitente
                                       AND tt-docum-est-cex.nat-operacao = docum-est.nat-operacao) THEN DO:

                        FOR EACH docum-est-cex NO-LOCK
                            WHERE docum-est-cex.serie-docto  = docum-est.serie-docto
                              AND docum-est-cex.nro-docto    = docum-est.nro-docto
                              AND docum-est-cex.cod-emitente = docum-est.cod-emitente
                              AND docum-est-cex.nat-operacao = docum-est.nat-operacao:

                            CREATE tt-docum-est-cex.
                            BUFFER-COPY docum-est-cex TO tt-docum-est-cex.
                            RUN pi-campos-descricao (INPUT "docum-est-cex":U).
                        END.
                    END.
                END.

                IF tt-param.lDupDespesas THEN DO:
                    IF NOT CAN-FIND (FIRST tt-dupli-apagar-cex
                                     WHERE tt-dupli-apagar-cex.serie-docto  = docum-est.serie-docto
                                       AND tt-dupli-apagar-cex.nro-docto    = docum-est.nro-docto
                                       AND tt-dupli-apagar-cex.cod-emitente = docum-est.cod-emitente
                                       AND tt-dupli-apagar-cex.nat-operacao = docum-est.nat-operacao) THEN DO:

                        FOR EACH dupli-apagar-cex NO-LOCK
                            WHERE dupli-apagar-cex.serie-docto  = docum-est.serie-docto
                              AND dupli-apagar-cex.nro-docto    = docum-est.nro-docto
                              AND dupli-apagar-cex.cod-emitente = docum-est.cod-emitente
                              AND dupli-apagar-cex.nat-operacao = docum-est.nat-operacao:

                            CREATE tt-dupli-apagar-cex.
                            BUFFER-COPY dupli-apagar-cex TO tt-dupli-apagar-cex.
                            RUN pi-campos-descricao (INPUT "dupli-apagar-cex":U).
                        END.
                    END.
                END.

                /* Nota Fiscal Complementar */
                IF tt-param.lNFCompl THEN DO:
                    IF NOT CAN-FIND (FIRST tt-rat-docum
                                     WHERE tt-rat-docum.nf-serie    = docum-est.serie-docto
                                       AND tt-rat-docum.nf-nro      = docum-est.nro-docto
                                       AND tt-rat-docum.nf-emitente = docum-est.cod-emitente
                                       AND tt-rat-docum.nf-nat-oper = docum-est.nat-operacao) THEN DO:

                        FOR EACH rat-docum NO-LOCK
                           WHERE rat-docum.nf-serie    = docum-est.serie-docto
                             AND rat-docum.nf-nro      = docum-est.nro-docto
                             AND rat-docum.nf-emitente = docum-est.cod-emitente
                             AND rat-docum.nf-nat-oper = docum-est.nat-operacao:

                            CREATE tt-rat-docum.
                            BUFFER-COPY rat-docum TO tt-rat-docum.

                            IF NOT CAN-FIND (FIRST tt-docum-est
                                             WHERE tt-docum-est.serie-docto  = rat-docum.serie-docto
                                               AND tt-docum-est.nro-docto    = rat-docum.nro-docto
                                               AND tt-docum-est.cod-emitente = rat-docum.cod-emitente
                                               AND tt-docum-est.nat-operacao = rat-docum.nat-operacao) THEN DO:

                                FOR FIRST bf-docum-est NO-LOCK
                                    WHERE bf-docum-est.serie-docto  = rat-docum.serie-docto
                                      AND bf-docum-est.nro-docto    = rat-docum.nro-docto
                                      AND bf-docum-est.cod-emitente = rat-docum.cod-emitente
                                      AND bf-docum-est.nat-operacao = rat-docum.nat-operacao:

                                    CREATE tt-docum-est.
                                    BUFFER-COPY bf-docum-est TO tt-docum-est.
                                    {utp/ut-liter.i "Nota_Complementar"}
                                    ASSIGN tt-docum-est.des-tipo-nota-imp = TRIM(RETURN-VALUE).

                                    RUN pi-campos-descricao (INPUT "bf-docum-est":U).
                                    IF tt-param.lDespImp THEN DO:
                                        IF NOT CAN-FIND (FIRST tt-docum-est-cex
                                                         WHERE tt-docum-est-cex.serie-docto  = bf-docum-est.serie-docto
                                                           AND tt-docum-est-cex.nro-docto    = bf-docum-est.nro-docto
                                                           AND tt-docum-est-cex.cod-emitente = bf-docum-est.cod-emitente
                                                           AND tt-docum-est-cex.nat-operacao = bf-docum-est.nat-operacao) THEN DO:

                                            FOR EACH docum-est-cex NO-LOCK
                                                WHERE docum-est-cex.serie-docto  = bf-docum-est.serie-docto
                                                  AND docum-est-cex.nro-docto    = bf-docum-est.nro-docto
                                                  AND docum-est-cex.cod-emitente = bf-docum-est.cod-emitente
                                                  AND docum-est-cex.nat-operacao = bf-docum-est.nat-operacao:

                                                CREATE tt-docum-est-cex.
                                                BUFFER-COPY docum-est-cex TO tt-docum-est-cex.
                                                RUN pi-campos-descricao (INPUT "docum-est-cex":U).
                                            END.
                                        END.
                                    END.
                                END.
                                FOR EACH bf-item-doc-est NO-LOCK
                                    WHERE bf-item-doc-est.serie-docto  = rat-docum.serie-docto
                                      AND bf-item-doc-est.nro-docto    = rat-docum.nro-docto
                                      AND bf-item-doc-est.cod-emitente = rat-docum.cod-emitente
                                      AND bf-item-doc-est.nat-operacao = rat-docum.nat-operacao:

                                    CREATE tt-item-doc-est.
                                    BUFFER-COPY bf-item-doc-est TO tt-item-doc-est.
                                    RUN pi-campos-descricao (INPUT "bf-item-doc-est":U).

                                    IF tt-param.lDespItemDoc THEN DO:
                                        FOR EACH item-doc-est-cex NO-LOCK
                                           WHERE item-doc-est-cex.serie-docto  = bf-item-doc-est.serie-docto
                                             AND item-doc-est-cex.nro-docto    = bf-item-doc-est.nro-docto
                                             AND item-doc-est-cex.cod-emitente = bf-item-doc-est.cod-emitente
                                             AND item-doc-est-cex.nat-operacao = bf-item-doc-est.nat-operacao
                                             AND item-doc-est-cex.sequencia    = bf-item-doc-est.sequencia:

                                           CREATE tt-item-doc-est-cex.
                                           BUFFER-COPY item-doc-est-cex TO tt-item-doc-est-cex.
                                           RUN pi-campos-descricao (INPUT "item-doc-est-cex":U).
                                        END.
                                    END.

                                END.
                            END.
                        END.
                    END.
                END.
           END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-cria-dados-material-transito:
/*------------------------------------------------------------------------------
  Purpose:     Cria a temp-table com os dados dos titulos de material em transito
               referente aos embarques
  Parameters:

  Notes:  Tabelas embarque-imp, processo-imp e historico-embarque devem estar posicionadas
------------------------------------------------------------------------------*/

    IF AVAIL embarque-imp AND AVAIL processo-imp AND AVAIL historico-embarque THEN DO:


        EMPTY TEMP-TABLE tt_consult_tit_ap.
        EMPTY TEMP-TABLE tt_retorno_tit_ap.

        FIND FIRST param-imp
             WHERE param-imp.cod-estabel = embarque-imp.cod-estabel NO-LOCK NO-ERROR.




        CREATE tt_consult_tit_ap.
        ASSIGN tt_consult_tit_ap.ttv_num_tip_leitura      = 6 /* chave sem parcela */
               tt_consult_tit_ap.tta_cod_estab            = embarque-imp.cod-estabel
               tt_consult_tit_ap.tta_cdn_fornecedor       = INTEGER(processo-imp.cod-exportador)
               tt_consult_tit_ap.tta_cod_espec_docto      = param-imp.esp-tit-transit
               tt_consult_tit_ap.tta_cod_ser_docto        = ""
               tt_consult_tit_ap.tta_cod_tit_ap           = embarque-imp.embarque.


        RUN pi_consult_tit_ap IN h-acr933zb (INPUT TABLE  tt_consult_tit_ap,
                                             OUTPUT TABLE tt_retorno_tit_ap,
                                             OUTPUT TABLE tt_retorno_val_tit_ap,
                                             OUTPUT TABLE tt_retorno_movto_tit_ap,
                                             OUTPUT TABLE tt_retorno_val_movto_tit_ap,
                                             OUTPUT TABLE tt_log_erro_tit_ap).

        IF CAN-FIND(FIRST tt_retorno_tit_ap) THEN DO:
            IF NOT AVAIL emitente OR (AVAIL emitente AND emitente.cod-emitente <> INTEGER(processo-imp.cod-exportador)) THEN
                FOR FIRST emitente FIELDS(cod-emitente nome-abrev)
                    WHERE emitente.cod-emitente = INTEGER(processo-imp.cod-exportador) NO-LOCK: END.

            IF NOT AVAIL estabelec OR (AVAIL estabelec AND estabelec.cod-estabel <> embarque-imp.cod-estabel)THEN
                FOR FIRST estabelec FIELDS(cod-estabel nome)
                    WHERE estabelec.cod-estabel = embarque-imp.cod-estabel NO-LOCK: END.
        END.

        FOR EACH tt_retorno_tit_ap NO-LOCK:
            CREATE tt-embarque-contab.
            ASSIGN tt-embarque-contab.ep-codigo       = tt_retorno_tit_ap.cod_empresa
                   tt-embarque-contab.cod-estabel     = embarque-imp.cod-estabel
                   tt-embarque-contab.nome-estabel    = estabelec.nome
                   tt-embarque-contab.embarque        = embarque-imp.embarque
                   tt-embarque-contab.cod-emitente    = tt_retorno_tit_ap.cdn_fornecedor
                   tt-embarque-contab.nome-emitente   = emitente.nome-abrev
                   tt-embarque-contab.nr-docto        = tt_retorno_tit_ap.cod_tit_ap
                   tt-embarque-contab.serie           = tt_retorno_tit_ap.cod_ser_docto
                   tt-embarque-contab.cod-especie     = tt_retorno_tit_ap.cod_espec_docto
                   tt-embarque-contab.parcela         = tt_retorno_tit_ap.cod_parcela
                   tt-embarque-contab.situacao        = tt_retorno_tit_ap.ind_sit_tit_ap
                   tt-embarque-contab.data-emissao    = tt_retorno_tit_ap.dat_emis_docto
                   tt-embarque-contab.data-prev-pag   = tt_retorno_tit_ap.dat_prev_pagto
                   tt-embarque-contab.desc-moeda      = tt_retorno_tit_ap.cod_indic_econ
                   tt-embarque-contab.de-vl-orig      = tt_retorno_tit_ap.val_origin_tit_ap
                   tt-embarque-contab.de-vl-saldo     = tt_retorno_tit_ap.val_sdo_tit_ap
                   tt-embarque-contab.pto-incoterm    = historico-embarque.cod-pto-contr
                   tt-embarque-contab.data-incoterm   = historico-embarque.dt-efetiva.
        END.
    END.


END PROCEDURE.
