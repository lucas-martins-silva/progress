/**
Programa responsavel pela montagem de e envio de JSON no modelo:

    [
      {
        "codigo": "",
        "nome": "",
        "codigoDeBarra": ""
      }
    ]
**/

/** Definicao de Temp-Tables **/
{adapters/rest/rfid/arestrfidprodutos.i "RowErrors"}


PROCEDURE integrate:
    DEFINE INPUT PARAMETER TABLE FOR ttProduto .
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors .

    DEFINE VARIABLE pJson AS LONGCHAR NO-UNDO.

    DEFINE VARIABLE h-json AS HANDLE      NO-UNDO.
    RUN utp/ut-json-builder.p PERSISTENT SET h-json.

    RUN startArray IN h-json.

    DEFINE VARIABLE lAppended AS LOGICAL     NO-UNDO.
    
    FOR EACH ttProduto:
        
        IF lAppended THEN
            RUN addObjectSeparator IN h-json.
        
        RUN startObject IN h-json.
        RUN addStringObject IN h-json (INPUT "codigo", INPUT ttProduto.codigo).
        RUN addObjectSeparator IN h-json.
        RUN addStringObject IN h-json (INPUT "nome", ttProduto.nome).
        RUN addObjectSeparator IN h-json.
        RUN addStringObject IN h-json (INPUT "codigoDeBarra", INPUT ttProduto.codigoDeBarra).
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

    RUN postDefault IN h-api  (INPUT cLoad,
                               OUTPUT pJson,
                               OUTPUT TABLE RowErrors).
                               
    IF VALID-HANDLE(h-json) THEN DELETE OBJECT h-json.
    IF VALID-HANDLE(h-api) THEN DELETE OBJECT h-api.

END PROCEDURE.