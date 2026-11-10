/**
Programa responsavel pela montagem de e envio de JSON no modelo:

    [
      {
        "codigo": "",
        "nome": "",
        "locais": [
          {
            "codigo": "",
            "nome": "" 
          }
        ]
      }
    ]

**/


/** Definicao de Temp-Tables **/
{adapters/rest/rfid/arestrfiddepositos.i "RowErrors"}

PROCEDURE integrate:
    DEFINE INPUT PARAMETER codEstabel AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER TABLE FOR ttDeposito .
    DEFINE INPUT PARAMETER TABLE FOR ttLocal.
    /* DEFINE OUTPUT PARAMETER pJson AS LONGCHAR NO-UNDO. */
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors .

    DEFINE VARIABLE pJson AS LONGCHAR NO-UNDO.
    
    /**
    CREATE ttDeposito.
    ASSIGN ttDeposito.codDepos = "ALM"
           ttDeposito.nome     = "Almoxarifado".

    CREATE ttDeposito.
    ASSIGN ttDeposito.codDepos = "PRO"
           ttDeposito.nome     = "Processo".


    CREATE ttLocal.
    ASSIGN ttLocal.codDepos = "ALM"
           ttLocal.codigo   = ""
           ttLocal.nome     = "Local Branco".
    CREATE ttLocal.
    ASSIGN ttLocal.codDepos = "PRO"
           ttLocal.codigo   = "001"
           ttLocal.nome     = "Local 001".
    CREATE ttLocal.
    ASSIGN ttLocal.codDepos = "PRO"
           ttLocal.codigo   = "002"
           ttLocal.nome     = "Local 002".
    CREATE ttLocal.
    ASSIGN ttLocal.codDepos = "PRO"
           ttLocal.codigo   = "003"
           ttLocal.nome     = "Local 003".
    **/

    DEFINE VARIABLE h-json AS HANDLE      NO-UNDO.
    RUN utp/ut-json-builder.p PERSISTENT SET h-json.

    RUN startArray IN h-json.

    DEFINE VARIABLE lAppended AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE lAppended2 AS LOGICAL     NO-UNDO.

    FOR EACH ttDeposito:

        IF lAppended THEN
            RUN addObjectSeparator IN h-json.

        RUN startObject IN h-json.
        RUN addStringObject IN h-json (INPUT "codigo", INPUT ttDeposito.codDepos).
        RUN addObjectSeparator IN h-json.
        RUN addStringObject IN h-json (INPUT "nome", INPUT ttDeposito.nome).
        RUN addObjectSeparator IN h-json.
        RUN addObjectLabel IN h-json (INPUT "locais").
        RUN startArray IN h-json.

        ASSIGN lAppended2 = NO.

        FOR EACH ttLocal WHERE ttLocal.codDepos = ttDeposito.codDepos:
            IF lAppended2 THEN
                RUN addObjectSeparator IN h-json.
                
            RUN startObject IN h-json.
            RUN addStringObject IN h-json (INPUT "codigo", INPUT ttLocal.codigo).
            RUN addObjectSeparator IN h-json.
            RUN addStringObject IN h-json (INPUT "nome", INPUT ttLocal.nome).
            RUN endObject IN h-json.

            ASSIGN lAppended2 = YES.
        END.

        RUN endArray IN h-json.
        RUN endObject IN h-json.

        ASSIGN lAppended = YES.
    END.

    RUN endArray IN h-json.

    DEFINE VARIABLE cLoad AS LONGCHAR   NO-UNDO.
    DEFINE VARIABLE cNewLoad AS LONGCHAR   NO-UNDO.
    RUN getJSON IN h-json (OUTPUT cLoad).

    DEFINE VARIABLE h-api AS HANDLE NO-UNDO.
    RUN fch/fchrfid/client/fchrfidclidepositos.p PERSISTENT SET h-api.

    def var memptrBuffer as memptr no-undo.
    COPY-LOB FROM OBJECT cLoad TO OBJECT memptrBuffer CONVERT TARGET CODEPAGE "UTF-8".

    COPY-LOB FROM OBJECT memptrBuffer TO OBJECT cLoad CONVERT TARGET CODEPAGE "UTF-8".

    /** Ajusta parametros conforme funcao **/
    {adapters/rest/rfid/arestrfidparams.i "h-api"}

    RUN postDefault IN h-api  (INPUT codEstabel,
                               INPUT cLoad,
                               OUTPUT pJson,
                               OUTPUT TABLE RowErrors).

    IF VALID-HANDLE(h-json) THEN DELETE OBJECT h-json.
    IF VALID-HANDLE(h-api) THEN DELETE OBJECT h-api.

END PROCEDURE.