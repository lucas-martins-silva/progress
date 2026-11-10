
&IF "{1}" = "RowErrors" &THEN
    /* Temp-table para retorno de erro */
    DEF TEMP-TABLE RowErrors NO-UNDO
        FIELD ErrorSequence    AS INTEGER
        FIELD ErrorNumber      AS INTEGER
        FIELD ErrorDescription AS CHARACTER
        FIELD ErrorParameters  AS CHARACTER
        FIELD ErrorType        AS CHARACTER
        FIELD ErrorHelp        AS CHARACTER
        FIELD ErrorSubType     AS CHARACTER.
&ENDIF

DEFINE TEMP-TABLE ttProdutoEstoque NO-UNDO
    FIELD codigo            AS CHARACTER
    FIELD nome              AS CHARACTER
    FIELD codigoDeBarra     AS CHARACTER
    FIELD custoDeReposicao  AS DECIMAL
    .
DEFINE TEMP-TABLE ttEstoque NO-UNDO
    FIELD codProduto    AS CHARACTER
    FIELD deposito      AS CHARACTER
    FIELD local         AS CHARACTER
    FIELD estoque       AS DECIMAL
    .    
DEFINE TEMP-TABLE ttProdutoPendente NO-UNDO
    FIELD codProduto AS CHARACTER
    FIELD codEstabel AS CHARACTER
    .