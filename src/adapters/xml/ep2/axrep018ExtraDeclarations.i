DEF VAR cOrgao           AS CHARACTER INITIAL ?       NO-UNDO. 
DEF VAR cReturnValue     AS CHARACTER INITIAL ?       NO-UNDO.
DEF VAR cStat            AS CHARACTER INITIAL ?       NO-UNDO. 
DEF VAR cTranAction      AS CHARACTER INITIAL ?       NO-UNDO.
DEF VAR cTranEvent       AS CHARACTER INITIAL ?       NO-UNDO.
DEF VAR cTranVersion     AS CHARACTER INITIAL ?       NO-UNDO.
DEF VAR hBusinessContent AS HANDLE                    NO-UNDO.
DEF VAR hGenXml          AS HANDLE                    NO-UNDO.
DEF VAR hMessageHandler  AS HANDLE                    NO-UNDO.
DEF VAR idLote           AS CHARACTER INITIAL ?       NO-UNDO.
DEF VAR lSuccessProcess  AS LOGICAL   INITIAL ?       NO-UNDO.
DEF VAR tpAmb            AS CHARACTER INITIAL ?       NO-UNDO. 
DEF VAR h-bodi601        AS HANDLE                    NO-UNDO.
DEF VAR verAplic         AS CHARACTER INITIAL ?       NO-UNDO.  
DEF VAR xMotivo          AS CHARACTER INITIAL ?       NO-UNDO.  

DEF VAR c-serie          LIKE nota-fiscal.serie       NO-UNDO.
DEF VAR c-nota-fisc      LIKE nota-fiscal.nr-nota-fis NO-UNDO.
DEF VAR c-hora           AS CHAR                      NO-UNDO.
DEF VAR c-dia            AS CHAR                      NO-UNDO.
DEF VAR c-mes            AS CHAR                      NO-UNDO.
DEF VAR c-ano            AS CHAR                      NO-UNDO.
                       
{method/dbotterr.i}  

{utp/ut-glob.i}

{dibo/bodi601.i tt-carta-correc-eletro}

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
     FIELD ttv_num_cod_erro  AS INTEGER   INITIAL ?
     FIELD ttv_des_msg_ajuda AS CHARACTER INITIAL ?
     FIELD ttv_des_msg_erro  AS CHARACTER INITIAL ?.
                                     
DEFINE TEMP-TABLE ttretEvento NO-UNDO
     FIELD chNFe         AS CHARACTER INITIAL ? 
     FIELD cOrgao        AS CHARACTER INITIAL ? 
     FIELD cStat         AS CHARACTER INITIAL ? 
     FIELD dhRegEvento   AS CHARACTER INITIAL ? 
     FIELD emailDest     AS CHARACTER INITIAL ? 
     FIELD nProt         AS CHARACTER INITIAL ? 
     FIELD nSeqEvento    AS CHARACTER INITIAL ? 
     FIELD tpAmb         AS CHARACTER INITIAL ? 
     FIELD tpEvento      AS CHARACTER INITIAL ? 
     FIELD ttretEventoID AS INTEGER   INITIAL ?
     FIELD verAplic      AS CHARACTER INITIAL ? 
     FIELD xEvento       AS CHARACTER INITIAL ? 
     FIELD xMotivo       AS CHARACTER INITIAL ? 
     INDEX ixttretEventoID IS PRIMARY UNIQUE ttretEventoID ASCENDING.

DEFINE TEMP-TABLE ttStack NO-UNDO
     FIELD ttID  AS INTEGER
     FIELD ttPos AS INTEGER
     INDEX tt_id IS PRIMARY UNIQUE
           ttID  ASCENDING.

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
