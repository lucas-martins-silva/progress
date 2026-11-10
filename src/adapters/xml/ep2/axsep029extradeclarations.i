{adapters/xml/ep2/axsep006extradeclarations.i}

DEFINE VARIABLE lcXMLDCe              AS LONGCHAR NO-UNDO.
DEFINE VARIABLE lObtemXMLDCe          AS LOGICAL  NO-UNDO.
DEFINE VARIABLE cHoraContingencia     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCodEstabel           AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cgc                 AS CHARACTER NO-UNDO.

DEFINE TEMP-TABLE ttDCeTSS NO-UNDO
    FIELD ID   AS CHAR
    FIELD MAIL AS CHAR
    FIELD XML  AS CLOB.
    
DEFINE TEMP-TABLE ttDCeTSSRet NO-UNDO
    FIELD k    AS ROWID
    FIELD STR  AS CHAR LABEL "STRING".  
    
DEFINE VARIABLE d-total-vProd        AS DECIMAL NO-UNDO.    
    
FUNCTION fn-retorna-codigo-cidade RETURNS CHARACTER (INPUT c-cidade AS CHAR, INPUT c-estado AS CHAR, INPUT c-pais AS CHAR).

    DEFINE VARIABLE c-codigo-cidade AS CHARACTER NO-UNDO.
 
    DEFINE BUFFER bf-cidade FOR cidade.

    FOR FIRST bf-cidade NO-LOCK
        WHERE bf-cidade.cidade = TRIM(c-cidade)
          AND bf-cidade.estado = TRIM(c-estado)
          AND bf-cidade.pais   = TRIM(c-pais):

        IF  bf-cidade.pais = "Brasil" THEN
            ASSIGN c-codigo-cidade = STRING(bf-cidade.cdn-munpio-ibge).
        ELSE
            ASSIGN c-codigo-cidade = "9999999".
    END.
    IF  NOT AVAIL bf-cidade THEN
        ASSIGN c-codigo-cidade = "0".

    IF  TRIM(c-pais) <> "Brasil" THEN
        ASSIGN c-codigo-cidade = "9999999".

    RETURN c-codigo-cidade.
	
END FUNCTION.