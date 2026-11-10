{include/i-freeac.i}

{utp/ut-glob.i}
{cdp/cdcfgdis.i}

{include/i-epc200.i AXSEP020}

DEFINE VAR cReturnValue     AS CHARACTER INITIAL ?     NO-UNDO.
DEFINE VAR hMessageHandler  AS HANDLE                  NO-UNDO.
DEFINE VAR lCreateMsg       AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE VAR pSendSuccess     AS LOGICAL   INITIAL YES   NO-UNDO.
DEFINE VAR pTotalErrors     AS INTEGER   INITIAL ?     NO-UNDO.
DEFINE VAR hBusinessContent AS HANDLE                  NO-UNDO.
DEFINE VAR hGenXml          AS HANDLE                  NO-UNDO.
DEFINE VAR lcXMLEvento      AS LONGCHAR                NO-UNDO.
DEFINE VAR lObtemXMLEvento  AS LOGICAL                 NO-UNDO.

DEFINE VAR iCount           AS INTEGER   INITIAL ?     NO-UNDO.
DEFINE VAR iId              AS INTEGER   INITIAL ?     NO-UNDO.
DEFINE VAR pErrorId         AS INTEGER   INITIAL ?     NO-UNDO.
DEFINE VAR pErrorType       AS CHARACTER INITIAL ?     NO-UNDO.
DEFINE VAR inPtr            AS MEMPTR                  NO-UNDO.
DEFINE VAR lcConteudo       AS LONGCHAR                NO-UNDO.
DEFINE VAR cVersaoMDFe      AS CHARACTER               NO-UNDO.

DEFINE VAR cValue          AS CHARACTER INITIAL ?     NO-UNDO.
DEFINE VAR lLayoutTXT      AS LOGICAL   INITIAL ?     NO-UNDO.
DEFINE VAR lLayoutXML      AS LOGICAL   INITIAL ?     NO-UNDO.

DEF VAR c-nome-arquivo-xml AS CHAR        NO-UNDO.
DEF VAR c-dia              AS CHAR        NO-UNDO.
DEF VAR c-mes              AS CHAR        NO-UNDO.
DEF VAR c-ano              AS CHAR        NO-UNDO.
DEF VAR c-hora             AS CHAR        NO-UNDO FORMAT "x(15)".
DEF VAR da-tz              AS DATETIME-TZ NO-UNDO.

DEF VAR l-integr-totvs-colab AS LOGICAL NO-UNDO.
DEF VAR lMDFe                AS LOGICAL NO-UNDO.

DEFINE VARIABLE iSeq AS INTEGER     NO-UNDO.

DEFINE VARIABLE cTpTrans AS CHARACTER NO-UNDO.

DEFINE VARIABLE c-dt-enc       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-uf           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-mun-ibge AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
     FIELD ttv_num_cod_erro  AS INTEGER   INITIAL ?
     FIELD ttv_des_msg_ajuda AS CHARACTER INITIAL ?
     FIELD ttv_des_msg_erro  AS CHARACTER INITIAL ? .

DEFINE TEMP-TABLE tt-selec-docto
    FIELD cod-versao         AS CHARACTER
    FIELD cod-estabel        AS CHARACTER
    FIELD ident              AS CHARACTER
    FIELD ambiente           AS INTEGER
    FIELD chave-nfe          AS CHARACTER
    FIELD tp-evento          AS CHARACTER 
    FIELD justificativa      AS CHARACTER FORMAT "x(1000)"
    FIELD des-dat-hora-event AS CHARACTER.

DEFINE TEMP-TABLE ttStack NO-UNDO
     FIELD ttID  AS INTEGER
     FIELD ttPos AS INTEGER
     INDEX tt_id IS PRIMARY UNIQUE
           ttID  ASCENDING.
                 
DEFINE TEMP-TABLE ttEvento NO-UNDO
     FIELD codEstab     AS CHARACTER INITIAL ?
     FIELD codSerie     AS CHARACTER INITIAL ?
     FIELD codNrNota    AS CHARACTER INITIAL ? FORMAT "x(16)"
     FIELD chNFe        AS CHARACTER INITIAL ? FORMAT "x(44)"
     FIELD cOrgao       AS CHARACTER INITIAL ? FORMAT "x(02)"
     FIELD descEvento   AS CHARACTER INITIAL ? FORMAT "x(18)"
     FIELD dhEvento     AS CHARACTER INITIAL ? FORMAT "x(25)"
     FIELD nSeqEvento   AS CHARACTER INITIAL ? 
     FIELD tpAmb        AS CHARACTER INITIAL ? 
     FIELD cnpj         AS CHARACTER INITIAL ? FORMAT "x(14)"
     FIELD cpf          AS CHARACTER INITIAL ? FORMAT "x(11)"
     FIELD tpEvento     AS CHARACTER INITIAL ? 
     FIELD infEventoID  AS CHARACTER INITIAL ? FORMAT "x(54)"
     FIELD verEvento    AS CHARACTER INITIAL ? 
     FIELD xJust        AS CHARACTER INITIAL ? FORMAT "x(1000)"
     FIELD nProt        AS CHARACTER INITIAL ?
     INDEX ixttEventoID IS PRIMARY UNIQUE infEventoID ASCENDING.

DEFINE TEMP-TABLE ttevIncDFeMDFe NO-UNDO 
    FIELD descEvento      AS CHARACTER INITIAL ?
    FIELD nProt           AS CHARACTER INITIAL ?
    FIELD cMunCarrega     AS CHARACTER INITIAL ?
    FIELD xMunCarrega     AS CHARACTER INITIAL ?
.

DEFINE TEMP-TABLE ttinfDoc NO-UNDO 
    FIELD cMunDescarga    AS CHARACTER INITIAL ?
    FIELD xMunDescarga    AS CHARACTER INITIAL ?
    FIELD chNFe           AS CHARACTER INITIAL ?
.

DEFINE TEMP-TABLE ttevPagtoOperMDFe NO-UNDO
    FIELD descEvento      AS CHARACTER INITIAL ?
    FIELD nProt           AS CHARACTER INITIAL ?
    FIELD qtdViagens      AS CHARACTER INITIAL ?
    FIELD nroViagem       AS CHARACTER INITIAL ?.
    
DEFINE TEMP-TABLE ttinfPag NO-UNDO
    FIELD id             AS INTEGER   INITIAL ?
    FIELD xNome          AS CHARACTER INITIAL ?
    FIELD CPF            AS CHARACTER INITIAL ?
    FIELD CNPJ           AS CHARACTER INITIAL ?
    FIELD idEstrangeiro  AS CHARACTER INITIAL ?
    FIELD vContrato      AS DECIMAL   INITIAL ?
    FIELD indPag         AS CHARACTER INITIAL ?
    FIELD codBanco       AS CHARACTER INITIAL ?
    FIELD codAgencia     AS CHARACTER INITIAL ?
    FIELD CNPJIPEF       AS CHARACTER INITIAL ?
    FIELD PIX            AS CHARACTER INITIAL ? FORMAT "X(60)"
    FIELD vAdiant        AS DECIMAL   INITIAL  ?.    .

DEFINE TEMP-TABLE ttComp NO-UNDO
    FIELD id             AS INTEGER   INITIAL ?
    FIELD tpComp         AS CHARACTER INITIAL ?
    FIELD vComp          AS DECIMAL   INITIAL ?
    FIELD xComp          AS CHARACTER INITIAL ?. 
    
DEFINE TEMP-TABLE ttinfPrazo NO-UNDO
    FIELD id             AS INTEGER   INITIAL ?
    FIELD nParcela       AS CHARACTER INITIAL ?
    FIELD dVenc          AS CHARACTER INITIAL ?
    FIELD vParcela       AS DECIMAL   INITIAL ?.        

FUNCTION addStack RETURN INTEGER (INPUT val AS INTEGER).

    DEFINE VAR id AS INTEGER INITIAL 1 NO-UNDO.
    
    FIND LAST ttStack NO-ERROR.
    IF  AVAIL(ttStack) THEN
        id = ttStack.ttID + 1.

    CREATE ttStack.
    ASSIGN ttStack.ttID = id.
    ASSIGN ttStack.ttPos = val.

END FUNCTION.
    
FUNCTION delStack RETURN INTEGER.
     
    FIND LAST ttStack NO-ERROR.
    IF  AVAIL(ttStack) THEN
        DELETE ttStack.

    FIND LAST ttStack NO-ERROR.

END FUNCTION.
    
FUNCTION getStack RETURN INTEGER.
     
    IF  AVAIL(ttStack) THEN
        RETURN ttStack.ttPos.
    ELSE
        RETURN 0.

END FUNCTION.

DEFINE TEMP-TABLE ttEventoTSS NO-UNDO
    FIELD ID   AS CHAR
    FIELD XML  AS CLOB.

DEFINE TEMP-TABLE ttNFES4 NO-UNDO
    FIELD k        AS ROWID
    FIELD ID       AS CHAR
    FIELD MENSAGEM AS CHAR.

FUNCTION fn-ajusta-espacos-branco RETURNS CHAR (INPUT cCampo AS CHAR).

    /*--- Em uma string, retirar os espacos em branco a mais entre as palavras [mais de 2 espacos] ---*/
    DEFINE VARIABLE cRetiraEspacos AS CHARACTER  NO-UNDO.

    ASSIGN cRetiraEspacos = cCampo.
    DO  WHILE INDEX(cRetiraEspacos, "  ") > 0.
        ASSIGN cRetiraEspacos = REPLACE(cRetiraEspacos, "  ", " ").
    END.
    
    RETURN TRIM(cRetiraEspacos).

END FUNCTION.
