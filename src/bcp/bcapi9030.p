&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOFunction 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI9030 2.00.00.002}  /*** 010002 ***/
/*:T--------------------------------------------------------------------------
    File       : dbofun.p
    Purpose    : O DBO Function (Datasul Business Objects) ‚ um programa 
                 PROGRESS que cont‚m a l¢gica de neg¢cio.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName    BCAPI9030
&GLOBAL-DEFINE DBOVersion 1.00.00.000

/*:T--- OPC ServerState ---*/
&GLOBAL-DEFINE OPCRunning      1
&GLOBAL-DEFINE OPCFailed       2
&GLOBAL-DEFINE OPCNoconfig     3
&GLOBAL-DEFINE OPCSuspended    4
&GLOBAL-DEFINE OPCTest         5
&GLOBAL-DEFINE OPCDisconnected 6

DEFINE TEMP-TABLE tt-opc-group NO-UNDO
    FIELD groupName AS CHARACTER
    FIELD groupHandle AS COMPONENT-HANDLE
    FIELD itemsColHandle AS COMPONENT-HANDLE

    INDEX idxPrimary IS PRIMARY UNIQUE
        groupName.

DEFINE TEMP-TABLE tt-opc-item NO-UNDO
    FIELD itemId AS INTEGER
    FIELD itemName AS CHARACTER
    FIELD groupName AS CHARACTER
    FIELD itemHandle AS COMPONENT-HANDLE

    INDEX idxPrimary IS PRIMARY UNIQUE
        itemId

    INDEX idxGroupItem IS UNIQUE
        groupName
        itemName.

{bcp/bc0706.i}

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER TABLE FOR tt-server-param.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cDefaultGroup AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cServerName   AS CHARACTER  NO-UNDO.

DEFINE VARIABLE chOPCGroupCollection AS COMPONENT-HANDLE NO-UNDO.
DEFINE VARIABLE chOPCServer          AS COMPONENT-HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOFunction
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getParameter DBOFunction 
FUNCTION getParameter RETURNS CHARACTER
    (INPUT ipcParamName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOFunction
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOFunction ASSIGN
         HEIGHT             = 11.08
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOFunction 
/* ************************* Included-Libraries *********************** */

{method/dbofun.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOFunction 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE connectOPCServer DBOFunction 
PROCEDURE connectOPCServer :
/*------------------------------------------------------------------------------
  Purpose:     Conecta e configura o cliente do servidor opc
  Parameters:  <none>
  Notes:       Serao 3 passos:registrar, conectar e configurar
------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-server-error.
    
    DEFINE VARIABLE cServerHost AS CHARACTER  NO-UNDO.

    /* Criacao do objeto OLE responsavel pela comunicacao com o servidor */
    IF NOT VALID-HANDLE(chOPCServer) THEN DO:
        RUN createOPCServer IN THIS-PROCEDURE.

        IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    END.

    /* Busca o nome do servidor a ser conectado */
    ASSIGN cServerName = TRIM(getParameter(INPUT "OPCServerName":U)).

    IF cServerName = "":U THEN DO:
        RUN insServError IN THIS-PROCEDURE (INPUT cServerName, /* Codigo do Servidor */
                                            INPUT "":U, /* Codigo da Transacao */
                                            INPUT "":U, /* Codigo do Equipamento */
                                            INPUT "":U, /* Codigo da Variavel Datasul */
                                            INPUT "":U, /* Codigo da Variavel Equipamento */
                                            INPUT 0, /* Numero do Erro */
                                            INPUT 'Parametro "OPCServerName" ‚ invalido.':U, /* Mensagem de Erro */
                                            INPUT "":U). /* Detalhe da Mensagem */
        RETURN "NOK":U.
    END.

    /* Busca o host do servidor a ser conectado */
    ASSIGN cServerHost = TRIM(getParameter(INPUT "OPCServerIP":U)).

    IF cServerHost = "":U THEN DO:
        RUN insServError IN THIS-PROCEDURE (INPUT cServerName, /* Codigo do Servidor */
                                            INPUT "":U, /* Codigo da Transacao */
                                            INPUT "":U, /* Codigo do Equipamento */
                                            INPUT "":U, /* Codigo da Variavel Datasul */
                                            INPUT "":U, /* Codigo da Variavel Equipamento */
                                            INPUT 0, /* Numero do Erro */
                                            INPUT 'Parametro "OPCServerIP" ‚ invalido.':U, /* Mensagem de Erro */
                                            INPUT "":U). /* Detalhe da Mensagem */
        RETURN "NOK":U.
    END.

    chOPCServer:Connect(cServerName, cServerHost) NO-ERROR.

    /* Se estiver com estado de nao conectado, retorna erro */
    IF chOPCServer:ServerState = {&OPCDisconnected} THEN DO:
        RUN insServError IN THIS-PROCEDURE (INPUT cServerName, /* Codigo do Servidor */
                                            INPUT "":U, /* Codigo da Transacao */
                                            INPUT "":U, /* Codigo do Equipamento */
                                            INPUT "":U, /* Codigo da Variavel Datasul */
                                            INPUT "":U, /* Codigo da Variavel Equipamento */
                                            INPUT 0, /* Numero do Erro */
                                            INPUT "Nao foi possivel conectar o servidor.":U, /* Mensagem de Erro */
                                            INPUT "":U). /* Detalhe da Mensagem */
        RETURN "NOK":U.
    END.

    /* Busca o nome do grupo OPC a ser criado */
    ASSIGN cDefaultGroup = TRIM(getParameter(INPUT "OPCGroupName":U)).

    IF cDefaultGroup = "":U THEN DO:
        RUN insServError IN THIS-PROCEDURE (INPUT cServerName, /* Codigo do Servidor */
                                            INPUT "":U, /* Codigo da Transacao */
                                            INPUT "":U, /* Codigo do Equipamento */
                                            INPUT "":U, /* Codigo da Variavel Datasul */
                                            INPUT "":U, /* Codigo da Variavel Equipamento */
                                            INPUT 0, /* Numero do Erro */
                                            INPUT 'Parametro "OPCGroupName" ‚ invalido.':U, /* Mensagem de Erro */
                                            INPUT "":U). /* Detalhe da Mensagem */
        RETURN "NOK":U.
    END.

    RUN createOPCGroup IN THIS-PROCEDURE (INPUT cDefaultGroup).

    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createOPCGroup DBOFunction 
PROCEDURE createOPCGroup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER ipcGroupName AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE chOPCGroup AS COMPONENT-HANDLE NO-UNDO.

    FIND tt-opc-group EXCLUSIVE-LOCK WHERE
         tt-opc-group.groupName = ipcGroupName NO-ERROR.

    IF AVAIL tt-opc-group THEN DO:
        RUN insServError IN THIS-PROCEDURE (INPUT cServerName, /* Codigo do Servidor */
                                            INPUT "":U, /* Codigo da Transacao */
                                            INPUT "":U, /* Codigo do Equipamento */
                                            INPUT "":U, /* Codigo da Variavel Datasul */
                                            INPUT "":U, /* Codigo da Variavel Equipamento */
                                            INPUT 0, /* Numero do Erro */
                                            INPUT "Grupo '" + ipcGroupName + "' ja existente para o servidor.":U, /* Mensagem de Erro */
                                            INPUT "":U). /* Detalhe da Mensagem */
        RETURN "NOK":U.
    END.

    ASSIGN chOPCGroupCollection = chOPCServer:OPCGroups
           chOPCGroup           = chOPCGroupCollection:Add(ipcGroupName).

    CREATE tt-opc-group.
    ASSIGN tt-opc-group.groupName      = ipcGroupName
           tt-opc-group.groupHandle    = chOPCGroup
           tt-opc-group.itemsColHandle = chOPCGroup:OPCItems.

    /* Validar erro */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createOPCItem DBOFunction 
PROCEDURE createOPCItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER ipcGroupName AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER ipiItemId    AS INTEGER    NO-UNDO.
    DEFINE INPUT PARAMETER ipcItemName  AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE chOPCItem AS COMPONENT-HANDLE NO-UNDO.
    DEFINE VARIABLE iErro     AS INTEGER          NO-UNDO.

    IF ipcGroupName = "":U THEN
        ASSIGN ipcGroupName = cDefaultGroup.

    FIND tt-opc-group NO-LOCK WHERE
         tt-opc-group.groupName = ipcGroupName NO-ERROR.

    IF NOT AVAIL tt-opc-group THEN DO:
        RUN insServError IN THIS-PROCEDURE (INPUT cServerName, /* Codigo do Servidor */
                                            INPUT tt-var-equip.cd-trans, /* Codigo da Transacao */
                                            INPUT tt-var-equip.cod-eqpto, /* Codigo do Equipamento */
                                            INPUT "":U, /* Codigo da Variavel Datasul */
                                            INPUT "":U, /* Codigo da Variavel Equipamento */
                                            INPUT 0, /* Numero do Erro */
                                            INPUT "Grupo '" + ipcGroupName + "' nao encontrado.":U, /* Mensagem de Erro */
                                            INPUT "":U). /* Detalhe da Mensagem */
        RETURN "NOK":U.
    END.

    FIND tt-opc-item EXCLUSIVE-LOCK WHERE
         tt-opc-item.itemId = ipiItemId NO-ERROR.

    IF AVAIL tt-opc-item THEN DO:
        /* Erro - Codigo do item ja existente */
        RUN insServError IN THIS-PROCEDURE (INPUT cServerName, /* Codigo do Servidor */
                                            INPUT tt-var-equip.cd-trans, /* Codigo da Transacao */
                                            INPUT tt-var-equip.cod-eqpto, /* Codigo do Equipamento */
                                            INPUT "":U, /* Codigo da Variavel Datasul */
                                            INPUT ipcItemName, /* Codigo da Variavel Equipamento */
                                            INPUT 0, /* Numero do Erro */
                                            INPUT "Codigo ":U + STRING(ipiItemId) + " para a variavel '":U + ipcItemName +
                                                 "' ja existe no equipamento.":U, /* Mensagem de Erro */
                                            INPUT "":U). /* Detalhe da Mensagem */
        RETURN "NOK":U.
    END.

    FIND tt-opc-item EXCLUSIVE-LOCK WHERE
         tt-opc-item.groupName = ipcGroupName AND
         tt-opc-item.itemName  = ipcItemName NO-ERROR.

    IF AVAIL tt-opc-item THEN DO:
        /* Erro - Item ja existente para o grupo */
        RUN insServError IN THIS-PROCEDURE (INPUT cServerName, /* Codigo do Servidor */
                                            INPUT tt-var-equip.cd-trans, /* Codigo da Transacao */
                                            INPUT tt-var-equip.cod-eqpto, /* Codigo do Equipamento */
                                            INPUT "":U, /* Codigo da Variavel Datasul */
                                            INPUT ipcItemName, /* Codigo da Variavel Equipamento */
                                            INPUT 0, /* Numero do Erro */
                                            INPUT "Variavel '":U + ipcItemName + "' ja existe no equipamento.":U, /* Mensagem de Erro */
                                            INPUT "":U). /* Detalhe da Mensagem */
        RETURN "NOK":U.
    END.

    IF ipiItemId = 0 THEN DO:
        FOR LAST tt-opc-item EXCLUSIVE-LOCK
            BY tt-opc-item.itemId:

            ASSIGN ipiItemId = tt-opc-item.itemId.
        END.

        ASSIGN ipiItemId = ipiItemId + 1.
    END.

    ASSIGN chOPCItem = tt-opc-group.itemsColHandle:AddItem(ipcItemName, ipiItemId) NO-ERROR.
    
    IF ERROR-STATUS:ERROR OR
      (ERROR-STATUS:GET-NUMBER(1) <> 138 AND ERROR-STATUS:NUM-MESSAGES <> 0) THEN DO:
        ASSIGN iErro = ERROR-STATUS:GET-NUMBER(1).
        RUN insServError IN THIS-PROCEDURE (INPUT cServerName,               /* Codigo do Servidor */
                                            INPUT tt-var-equip.cd-trans,     /* Codigo da Transacao */
                                            INPUT tt-var-equip.cod-eqpto,    /* Codigo do Equipamento */
                                            INPUT tt-var-equip.cod-var-dtsul,/* Codigo da Variavel Datasul */
                                            INPUT ipcItemName,               /* Codigo da Variavel Equipamento */
                                            INPUT iErro,                     /* Numero do Erro */
                                            INPUT ("Variavel '":U + ipcItemName + "' invalida para o equipamento.":U), /* Mensagem de Erro */
                                            INPUT "":U).                     /* Detalhe da Mensagem */
        RETURN "NOK":U.
    END.

    CREATE tt-opc-item.
    ASSIGN tt-opc-item.itemId = ipiItemId
           tt-opc-item.itemName = ipcItemName
           tt-opc-item.groupName = ipcGroupName
           tt-opc-item.itemHandle = chOPCItem.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createOPCServer DBOFunction 
PROCEDURE createOPCServer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CREATE "OPC.Automation":U chOPCServer NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disconnectOPCServer DBOFunction 
PROCEDURE disconnectOPCServer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    chOPCServer:Disconnect.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getOPCValues DBOFunction 
PROCEDURE getOPCValues :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-var-equip.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-server-error.

    DEFINE BUFFER bfTTOPCItem FOR tt-opc-item.

    FOR EACH tt-var-equip EXCLUSIVE-LOCK:
        FIND FIRST bfTTOPCItem NO-LOCK
             WHERE bfTTOPCItem.itemName = tt-var-equip.cod-var-eqpto NO-ERROR.

        IF NOT AVAIL bfTTOPCItem THEN DO:
            RUN createOPCItem IN THIS-PROCEDURE (INPUT "":U,
                                                 INPUT 0,
                                                 INPUT tt-var-equip.cod-var-eqpto).
            
            IF RETURN-VALUE <> "OK":U THEN NEXT.
            
            FIND FIRST bfTTOPCItem NO-LOCK
                 WHERE bfTTOPCItem.itemName = tt-var-equip.cod-var-eqpto NO-ERROR.
        END.
        
        RUN readValue IN THIS-PROCEDURE (INPUT  bfTTOPCItem.itemId,
                                         OUTPUT tt-var-equip.valor).
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE readValue DBOFunction 
PROCEDURE readValue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER ipiItemId    AS INTEGER    NO-UNDO. /* Ponteiro utilizado no handle */
    DEFINE OUTPUT PARAMETER opcReadValue AS CHARACTER  NO-UNDO. /* Retorno do valor consultado */

    DEFINE VARIABLE cTimeStamp AS CHARACTER  NO-UNDO. /* Data de retorno da leitura */

    DEFINE VARIABLE iQuality AS INTEGER    NO-UNDO. /* Retorna se a leitura ‚ boa ou ruim */

    FIND tt-opc-item NO-LOCK WHERE
         tt-opc-item.itemId = ipiItemId NO-ERROR.

    IF NOT AVAIL tt-opc-item THEN DO:
        /* Erro - item nao encontrado */
        RUN insServError IN THIS-PROCEDURE (INPUT cServerName, /* Codigo do Servidor */
                                            INPUT "":U, /* Codigo da Transacao */
                                            INPUT "":U, /* Codigo do Equipamento */
                                            INPUT "":U, /* Codigo da Variavel Datasul */
                                            INPUT "":U, /* Codigo da Variavel Equipamento */
                                            INPUT 0, /* Numero do Erro */
                                            INPUT "Variavel '" + STRING(ipiItemId) + "' nao encontrada.":U, /* Mensagem de Erro */
                                            INPUT "":U). /* Detalhe da Mensagem */
        RETURN "NOK":U.
    END.

    tt-opc-item.itemHandle:READ(2 /* Utiliza o "2" para que retorne o VALOR da vari vel no CLP */,
                                OUTPUT opcReadValue BY-VARIANT-POINTER,
                                OUTPUT iQuality     BY-VARIANT-POINTER,
                                OUTPUT cTimeStamp   BY-VARIANT-POINTER) NO-ERROR.

    /* Erro - validar erro de leitura */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setOPCValues DBOFunction 
PROCEDURE setOPCValues :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-var-equip.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-server-error.

    DEFINE BUFFER bfTTOPCItem FOR tt-opc-item.

    FOR EACH tt-var-equip EXCLUSIVE-LOCK:
        FIND FIRST bfTTOPCItem NO-LOCK
             WHERE bfTTOPCItem.itemName = tt-var-equip.cod-var-eqpto NO-ERROR.

        IF NOT AVAIL bfTTOPCItem THEN DO:
            RUN createOPCItem IN THIS-PROCEDURE (INPUT "":U,
                                                 INPUT 0,
                                                 INPUT tt-var-equip.cod-var-eqpto).
            
            IF RETURN-VALUE <> "OK":U THEN NEXT.

            FIND FIRST bfTTOPCItem NO-LOCK
                 WHERE bfTTOPCItem.itemName = tt-var-equip.cod-var-eqpto NO-ERROR.
        END.

        RUN writeValue IN THIS-PROCEDURE (INPUT bfTTOPCItem.itemId,
                                          INPUT tt-var-equip.valor).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeValue DBOFunction 
PROCEDURE writeValue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER ipiItemId     AS INTEGER    NO-UNDO. /* Ponteiro utilizado no handle */
    DEFINE INPUT  PARAMETER ipcWriteValue AS CHARACTER  NO-UNDO. /* Valor a ser escrito */

    FIND tt-opc-item NO-LOCK WHERE
         tt-opc-item.itemId = ipiItemId NO-ERROR.

    IF NOT AVAIL tt-opc-item THEN DO:
        /* Erro - item nao encontrado */
        RUN insServError IN THIS-PROCEDURE (INPUT cServerName, /* Codigo do Servidor */
                                            INPUT "":U, /* Codigo da Transacao */
                                            INPUT "":U, /* Codigo do Equipamento */
                                            INPUT "":U, /* Codigo da Variavel Datasul */
                                            INPUT "":U, /* Codigo da Variavel Equipamento */
                                            INPUT 0, /* Numero do Erro */
                                            INPUT "Variavel '" + STRING(ipiItemId) + "' nao encontrada.":U, /* Mensagem de Erro */
                                            INPUT "":U). /* Detalhe da Mensagem */
        RETURN "NOK":U.
    END.

    tt-opc-item.itemHandle:WRITE(ipcWriteValue) NO-ERROR.

    /* Erro - validar erro de leitura */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getParameter DBOFunction 
FUNCTION getParameter RETURNS CHARACTER
    (INPUT ipcParamName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FIND FIRST tt-server-param NO-LOCK
         WHERE tt-server-param.paramName = ipcParamName NO-ERROR.

    IF AVAIL tt-server-param THEN
        RETURN tt-server-param.paramValue.

    RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

