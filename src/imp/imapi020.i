DEFINE TEMP-TABLE RowErrorsAux NO-UNDO LIKE RowErrors.

DEFINE TEMP-TABLE ttDuimpInstr NO-UNDO 
    FIELD cod-duimp-dts        AS INTEGER   INIT ?
    FIELD cod-tipo-docto       AS INTEGER   INIT ?.

DEFINE TEMP-TABLE ttDuimpPalavrasChave NO-UNDO
    FIELD cod-duimp-dts        AS INTEGER   INIT ?
    FIELD cod-tipo-docto       AS INTEGER   INIT ?
    FIELD tipoCodigo           AS INTEGER   INIT ?
    FIELD codigo               AS INTEGER   INIT ?
    FIELD valor                AS CHARACTER INIT ?.
    
DEFINE TEMP-TABLE ttDuimpProcessos NO-UNDO
    FIELD cod-duimp-dts        AS INTEGER   INIT ?
    FIELD identificacao        AS CHARACTER INIT ?
    FIELD tipo                 AS CHARACTER INIT ?.

DEFINE TEMP-TABLE ttDuimpDEE NO-UNDO
    FIELD cod-duimp-dts        AS INTEGER   INIT ?
    FIELD numero               AS CHARACTER INIT ?
    FIELD faixaInicio          AS CHARACTER INIT ?
    FIELD faixaFim             AS CHARACTER INIT ?.
    
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
        FIELD dataReferencia            AS character.
    
/* Temp-table de retorno da integra‡Æo com o siscomex */
DEFINE TEMP-TABLE tt-result NO-UNDO
        FIELD cod-registro AS CHARACTER
        FIELD desc-status  AS CHARACTER
        FIELD cod-msg      AS CHARACTER
        FIELD des-msg      AS CHARACTER.

/* Status por item retornado no multiStatus do portal (chave: numeroItem) */
DEFINE TEMP-TABLE ttReturnItemStatus NO-UNDO
        FIELD numeroItem AS INTEGER
        FIELD code       AS INTEGER
        FIELD comErro    AS LOGICAL
        FIELD mensagem   AS CHARACTER
        INDEX idx-item IS PRIMARY numeroItem.

