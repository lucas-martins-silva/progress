DEFINE VAR cEvent AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR Comment AS CHARACTER INITIAL ? NO-UNDO.  
DEFINE VAR cTranAction AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR CustomerVendorCode AS integer INITIAL ? NO-UNDO. 
DEFINE VAR CustomerVendorIdentification AS integer INITIAL ? NO-UNDO.
DEFINE VAR CustomerVendorName AS CHARACTER INITIAL ? NO-UNDO.  
DEFINE VAR CustomerVendorShortName AS CHARACTER INITIAL ? NO-UNDO. 
DEFINE VAR DateAdded AS date INITIAL ? NO-UNDO. 
DEFINE VAR EntityCode AS integer INITIAL ? NO-UNDO.
DEFINE VAR EntityType AS integer INITIAL ? NO-UNDO.
DEFINE VAR Image AS CHARACTER INITIAL ? NO-UNDO.  
DEFINE VAR VendorClassification AS integer INITIAL ? NO-UNDO.  

DEF VAR l-integra-ems5 AS LOG INIT NO NO-UNDO.

/** Defini¯Êo variaveis de conexÊo ems5 **/
{cdp/cd1202.i5}
{btb/btb009za.i}
{include/i_dbvers.i}
{utp/ut-glob.i}

IF CAN-FIND(FIRST funcao WHERE (funcao.cd-funcao = "adm-cdc-ems-5.00" OR funcao.cd-funcao = "adm-cdf-ems-5.00") 
                   AND    funcao.ativo = yes) THEN
    ASSIGN l-integra-ems5 = YES.

