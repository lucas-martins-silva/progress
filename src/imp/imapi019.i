/*Temp-table de retorno da integra‡Æo com o siscomex*/
DEFINE TEMP-TABLE tt-result NO-UNDO
        FIELD cod-registro AS CHARACTER
        FIELD desc-status  AS CHARACTER
        FIELD cod-msg      AS CHARACTER
        FIELD des-msg      AS CHARACTER.

/*Temp-table com as op‡äes de Header*/
DEFINE TEMP-TABLE ttHttpRequestHeaders NO-UNDO
        FIELD headerName  AS CHARACTER
        FIELD headerValue AS CHARACTER.
        
/*Temp-table de retorno do portal*/
DEFINE TEMP-TABLE ttReturnHttpRequest NO-UNDO
        FIELD seq                       AS CHARACTER
        FIELD codigo                    AS CHARACTER
        FIELD codigoInterno             AS CHARACTER
        FIELD success                   AS LOGICAL
        FIELD versao                    AS CHARACTER
        FIELD cpfCnpjRaiz               AS CHARACTER
        FIELD codigoOperadorEstrangeiro AS CHARACTER
        FIELD cpfCnpjFabricante         AS CHARACTER
        FIELD conhecido                 AS LOGICAL
        FIELD codigoProduto             AS INTEGER
        FIELD codigoPais                AS CHARACTER
        FIELD mensagem                  AS CHARACTER
        FIELD numero                    AS CHARACTER
        FIELD dataReferencia            AS CHARACTER.

DEFINE TEMP-TABLE ttReturnHttpRequestErros NO-UNDO
    FIELD seq   AS CHARACTER
    FIELD erros AS CHARACTER
    FIELD codigo AS CHARACTER
    FIELD mensagem AS CHARACTER.

/* Status por item retornado no multiStatus do portal (chave: numeroItem) */
DEFINE TEMP-TABLE ttReturnItemStatus NO-UNDO
    FIELD numeroItem AS INTEGER
    FIELD code       AS INTEGER
    FIELD comErro    AS LOGICAL
    FIELD mensagem   AS CHARACTER
    INDEX idx-item IS PRIMARY numeroItem.
