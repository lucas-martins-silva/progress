DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino             AS INTEGER
    FIELD arquivo             AS CHAR FORMAT "x(35)":U
    FIELD usuario             AS CHAR FORMAT "x(12)":U
    FIELD data-exec           AS DATE
    FIELD hora-exec           AS INTEGER
    FIELD classifica          AS INTEGER
    FIELD desc-classifica     AS CHAR FORMAT "x(40)":U
    FIELD modelo              AS CHAR FORMAT "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    FIELD l-habilitaRtf       AS LOG
    /* Vars Relatat¢rio */
    FIELD iOpcao              AS INT
    FIELD cProcEstabIni       LIKE estabelec.cod-estabel
    FIELD cProcEstabFim       LIKE estabelec.cod-estabel
    FIELD cProcImpIni         AS CHAR
    FIELD cProcImpFim         AS CHAR
    FIELD iEmitProcIni        LIKE emitente.cod-emitente
    FIELD iEmitProcFim        LIKE emitente.cod-emitente
    FIELD dDataEmisIni        LIKE processo-imp.dt-emissao
    FIELD dDataEmisFim        LIKE processo-imp.dt-emissao
    FIELD cEmbEstabIni        AS CHAR
    FIELD cEmbEstabFim        AS CHAR
    FIELD cEmbarqueIni        AS CHAR
    FIELD cEmbarqueFim        AS CHAR
    FIELD cDISiscomexIni      AS CHAR
    FIELD cDISiscomexFim      AS CHAR
    FIELD iDIEMSIni           LIKE decla-import.num-di-ems
    FIELD iDIEMSFim           LIKE decla-import.num-di-ems
    FIELD dDataDIIni          LIKE processo-imp.dt-emissao
    FIELD dDataDIFim          LIKE processo-imp.dt-emissao
    FIELD cPedEstabIni        AS CHAR
    FIELD cPedEstabFim        AS CHAR
    FIELD iPedidoIni          LIKE pedido-compr.num-pedido
    FIELD iPedidoFim          LIKE pedido-compr.num-pedido
    FIELD iOrdemCompraIni     LIKE ordem-compra.numero-ordem
    FIELD iOrdemCompraFim     LIKE ordem-compra.numero-ordem
    FIELD iEmitPedIni         LIKE emitente.cod-emitente
    FIELD iEmitPedFim         LIKE emitente.cod-emitente
    FIELD dDataPedIni         LIKE processo-imp.dt-emissao
    FIELD dDataPedFim         LIKE processo-imp.dt-emissao
    FIELD lPedidoCompra       AS LOG
    FIELD lProcessoImp        AS LOG
    FIELD lFornecedor         AS LOG
    FIELD lOrdemCompra        AS LOG
    FIELD lParcelas           AS LOG
    FIELD lItem               AS LOG
    FIELD lDeclaImport        AS LOG
    FIELD lAdicoesDI          AS LOG
    FIELD lAcompDI            AS LOG
    FIELD lMaterialTransito   AS LOG
    FIELD lEmbarqueImp        AS LOG
    FIELD lAcompEmb           AS LOG
    FIELD lDocumentos         AS LOG
    FIELD lItensDoc           AS LOG
    FIELD lDespItemDoc        AS LOG
    FIELD lMovtoEstoq         AS LOG
    FIELD lDuplicatas         AS LOG
    FIELD lDespImp            AS LOG
    FIELD lDupDespesas        AS LOG
    FIELD lNFCompl            AS LOG
    FIELD lEnviaDocto         AS LOG
    FIELD cDestinatario       AS CHAR
    FIELD lUtilizaLayout      AS LOG
    FIELD cLayoutPadrao       AS CHAR
    FIELD lSobreporArq        AS LOG
    FIELD cDestinoArq         AS CHAR
    FIELD iDestinoExcel       AS INT.

DEF TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.


/* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-965) */
DEFINE VARIABLE l-nt2024002 AS LOGICAL     NO-UNDO.
ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002" AND funcao.ativo).
/* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-965) */
