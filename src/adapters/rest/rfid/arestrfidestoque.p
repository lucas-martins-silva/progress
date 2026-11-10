/**
Programa responsavel pela montagem de e envio de JSON no modelo:

    [
      {
        "codigo": "",
        "nome": "",
        "codigoDeBarra": "",
        "custoDeReposicao": 0,
        "estoques": [
          {
            "deposito": "",
            "local": "",
            "estoque": 0
          }
        ]
      }
    ]

**/

/** Definicao de Temp-Tables **/
{adapters/rest/rfid/arestrfidestoque.i "RowErrors"}

PROCEDURE integrate:
    DEFINE INPUT PARAMETER codEstabel AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER TABLE FOR ttProdutoEstoque.
    DEFINE INPUT PARAMETER TABLE FOR ttEstoque.
    /* DEFINE OUTPUT PARAMETER pJson AS LONGCHAR NO-UNDO. */
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE pJson AS LONGCHAR NO-UNDO.

    DEFINE VARIABLE h-json AS HANDLE      NO-UNDO.
    RUN utp/ut-json-builder.p PERSISTENT SET h-json.

    RUN startArray IN h-json.

    DEFINE VARIABLE lAppended AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE lAppended2 AS LOGICAL     NO-UNDO.

    FOR EACH ttProdutoEstoque:

        IF lAppended THEN
            RUN addObjectSeparator IN h-json.

        RUN startObject IN h-json.
        RUN addStringObject IN h-json (INPUT "codigo", INPUT ttProdutoEstoque.codigo).
        RUN addObjectSeparator IN h-json.
        RUN addStringObject IN h-json (INPUT "nome", INPUT ttProdutoEstoque.nome).
        RUN addObjectSeparator IN h-json.
        RUN addStringObject IN h-json (INPUT "codigoDeBarra", INPUT ttProdutoEstoque.codigoDeBarra).
        RUN addObjectSeparator IN h-json.
        RUN addDecimalObject IN h-json (INPUT "custoDeReposicao", INPUT ttProdutoEstoque.custoDeReposicao).
        RUN addObjectSeparator IN h-json.
        RUN addObjectLabel IN h-json (INPUT "estoques").
        RUN startArray IN h-json.


        ASSIGN lAppended2 = NO.

        FOR EACH ttEstoque WHERE ttEstoque.codProduto = ttProdutoEstoque.codigo:
            IF lAppended2 THEN
                RUN addObjectSeparator IN h-json.
                
            RUN startObject IN h-json.
            RUN addStringObject IN h-json (INPUT "codigo", INPUT ttEstoque.deposito).
            RUN addObjectSeparator IN h-json.
            RUN addStringObject IN h-json (INPUT "local", INPUT ttEstoque.local).
            RUN addObjectSeparator IN h-json.
            RUN addDecimalObject IN h-json (INPUT "estoque", INPUT ttEstoque.estoque).
            RUN endObject IN h-json.

            ASSIGN lAppended2 = YES.
        END.

        RUN endArray IN h-json.
        RUN endObject IN h-json.

        ASSIGN lAppended = YES.
    END.

    RUN endArray IN h-json.

    DEFINE VARIABLE cLoad AS LONGCHAR   NO-UNDO.
    RUN getJSON IN h-json (OUTPUT cLoad).


    DEFINE VARIABLE h-api AS HANDLE NO-UNDO.
    RUN fch/fchrfid/client/fchrfidcliprodutos.p PERSISTENT SET h-api.

    /** Ajusta parametros conforme funcao **/
    {adapters/rest/rfid/arestrfidparams.i "h-api"}

    RUN postEstoque IN h-api  (INPUT codEstabel,
                               INPUT cLoad,
                               OUTPUT pJson,
                               OUTPUT TABLE RowErrors).

    IF VALID-HANDLE(h-json) THEN DELETE OBJECT h-json.
    IF VALID-HANDLE(h-api) THEN DELETE OBJECT h-api.


END PROCEDURE.