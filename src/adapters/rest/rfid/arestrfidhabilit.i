/** Include para verificar se integra com o TOTVS RFID **/
DEFINE VARIABLE h-rfid-api AS HANDLE NO-UNDO.
DEFINE VARIABLE lTOTVSRFID AS LOGICAL NO-UNDO.
ASSIGN lTOTVSRFID = NO.

FIND FIRST funcao WHERE funcao.cd-funcao = "spp-integra-totvs-rfid" NO-LOCK NO-ERROR.
IF AVAIL funcao AND funcao.ativo = YES THEN DO:
    ASSIGN lTOTVSRFID = TRUE.    
END.


