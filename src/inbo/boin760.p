&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN760 2.00.00.003 } /*** "010003" 24/11/2023 13:25:27  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN760 MUT}
&ENDIF

/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN760
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName tip-lote-pregao
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin760.i RowObject}
{inbo/boin761.i tt-campo-lote-pregao}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
/* Vari†veis da setConstraintcodTipLote */
DEFINE VARIABLE codtiplote-ini-0001 AS INTEGER NO-UNDO.
DEFINE VARIABLE codtiplote-fim-0002 AS INTEGER NO-UNDO.
/* Vari†veis da setConstraintdesTipLote */
DEFINE VARIABLE desTipLote-ini-0001 AS CHARACTER NO-UNDO.
DEFINE VARIABLE desTipLote-fim-0002 AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 15.92
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copiaCamposTipoLote DBOProgram 
PROCEDURE copiaCamposTipoLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pRowidOrigem AS ROWID NO-UNDO.
    DEFINE INPUT PARAMETER pCdnTipLotePregaoDestino LIKE tip-lote-pregao.cdn-tip-lote-pregao NO-UNDO.

    DEFINE VARIABLE h-boin761 AS HANDLE NO-UNDO.
    RUN inbo/boin761.p PERSISTENT SET h-boin761.
    RUN openQueryStatic IN h-boin761 (INPUT "Main":U).

    DO TRANSACTION:

        RUN emptyRowErrors IN h-boin761.

        FIND FIRST tip-lote-pregao NO-LOCK WHERE ROWID(tip-lote-pregao) = pRowidOrigem NO-ERROR.
        IF AVAIL tip-lote-pregao THEN DO:
                
            FOR EACH campo-lote-pregao
                WHERE campo-lote-pregao.cdn-tip-lote-pregao = tip-lote-pregao.cdn-tip-lote-pregao NO-LOCK:
                            
                EMPTY TEMP-TABLE tt-campo-lote-pregao.
    
                BUFFER-COPY campo-lote-pregao EXCEPT cdn-tip-lote-pregao TO tt-campo-lote-pregao.
                ASSIGN tt-campo-lote-pregao.cdn-tip-lote-pregao = pCdnTipLotePregaoDestino.

                FIND FIRST tt-campo-lote-pregao NO-LOCK NO-ERROR.
    
                RUN setRecord    IN h-boin761 (INPUT TABLE tt-campo-lote-pregao).
                RUN createRecord IN h-boin761.                
            END.
        END.
        RUN getRowErrors IN h-boin761 (OUTPUT TABLE RowErrors).

        IF CAN-FIND (FIRST RowErrors NO-LOCK 
                     WHERE RowErrors.ErrorSubType <> "WARNING":U) THEN 
            RETURN "NOK":U.
    END.

    RUN destroy IN h-boin761.
    ASSIGN h-boin761 = ?.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deletaCamposTipoLote DBOProgram 
PROCEDURE deletaCamposTipoLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH campo-lote-pregao
      WHERE campo-lote-pregao.cdn-tip-lote-pregao = rowObject.cdn-tip-lote-pregao EXCLUSIVE-LOCK:
      DELETE campo-lote-pregao.
  END.
  
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.
    
    CASE pFieldName:
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "des-tip-lote-pregao":U THEN ASSIGN pFieldValue = RowObject.des-tip-lote-pregao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cdn-tip-lote-pregao":U THEN ASSIGN pFieldValue = RowObject.cdn-tip-lote-pregao.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice emp-unico
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn-tip-lote-pregao LIKE tip-lote-pregao.cdn-tip-lote-pregao NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn-tip-lote-pregao = RowObject.cdn-tip-lote-pregao.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice emp-unico
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-tip-lote-pregao LIKE tip-lote-pregao.cdn-tip-lote-pregao NO-UNDO.

    FIND FIRST bftip-lote-pregao WHERE
        bftip-lote-pregao.cdn-tip-lote-pregao = pcdn-tip-lote-pregao NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE tip-lote-pregao THEN
        RETURN 'NOK':U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bftip-lote-pregao)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerycodTipLote DBOProgram 
PROCEDURE openQuerycodTipLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OPEN QUERY {&QueryName}
    FOR EACH {&TableName} NO-LOCK
        WHERE tip-lote-pregao.cdn-tip-lote-pregao >= codtiplote-ini-0001
        AND   tip-lote-pregao.cdn-tip-lote-pregao <= codtiplote-fim-0002
        BY tip-lote-pregao.cdn-tip-lote-pregao.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerydesTipLote DBOProgram 
PROCEDURE openQuerydesTipLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OPEN QUERY {&QueryName}
    FOR EACH {&TableName} NO-LOCK
        WHERE tip-lote-pregao.des-tip-lote-pregao >= desTipLote-ini-0001
        AND   tip-lote-pregao.des-tip-lote-pregao <= desTipLote-fim-0002
        BY tip-lote-pregao.des-tip-lote-pregao.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*:T------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName}
        FOR EACH {&TableName}.    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintcodTipLote DBOProgram 
PROCEDURE setConstraintcodTipLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcodtiplote-ini-0001 AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER pcodtiplote-fim-0002 AS INTEGER NO-UNDO.

ASSIGN codtiplote-ini-0001 = pcodtiplote-ini-0001
       codtiplote-fim-0002 = pcodtiplote-fim-0002.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintdesTipLote DBOProgram 
PROCEDURE setConstraintdesTipLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pdesTipLote-ini-0001 AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pdesTipLote-fim-0002 AS CHARACTER NO-UNDO.

ASSIGN desTipLote-ini-0001 = pdesTipLote-ini-0001
       desTipLote-fim-0002 = pdesTipLote-fim-0002.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    /*:T--- Verifica ocorrància de erros ---*/
    IF pType = "Create" OR
       pType = "Update" THEN DO:
       IF rowObject.cdn-tip-lote-pregao = 0 THEN DO:
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-codigo AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "C¢digo" *}
          ASSIGN c-lbl-liter-codigo = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i
                    &ErrorNumber="265"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters="c-lbl-liter-codigo"} 
       END.
       IF rowObject.des-tip-lote-pregao = "" THEN DO:
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-descricao AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Descriá∆o" *}
          ASSIGN c-lbl-liter-descricao = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i
                    &ErrorNumber="265"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters="c-lbl-liter-descricao"} 
       END.
    END.
    IF pType = "Create" THEN DO:
       IF CAN-FIND(FIRST tip-lote-pregao WHERE tip-lote-pregao.cdn-tip-lote-pregao = rowObject.cdn-tip-lote-pregao) THEN DO:
          /* Inicio -- Projeto Internacional */
          {utp/ut-table.i mgind tip-lote-pregao 1} /* Busca o label da tabela */
          {method/svc/errors/inserr.i
                    &ErrorNumber="8"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=TRIM(RETURN-VALUE)}
       END.
    END.

    IF pType = "Delete" THEN DO:
       &IF "{&bf_mat_versao_ems}" >= "2.07" &THEN
           IF CAN-FIND(FIRST ordem-compra WHERE ordem-compra.cdn-tip-lote-pregao = rowObject.cdn-tip-lote-pregao) THEN DO:
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-campo-de-lote AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Campo_de_Lote" *}
              ASSIGN c-lbl-liter-campo-de-lote = TRIM(RETURN-VALUE).
              DEFINE VARIABLE c-lbl-liter-ordem-de-compra AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Ordem_de_Compra" *}
              ASSIGN c-lbl-liter-ordem-de-compra = TRIM(RETURN-VALUE).
              {method/svc/errors/inserr.i
                         &ErrorNumber="5"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR" 
                         &ErrorParameters="c-lbl-liter-campo-de-lote + '~~~~' + c-lbl-liter-ordem-de-compra"}
           END.
       &ELSE
           IF CAN-FIND (FIRST ordem-compra WHERE INT(SUBSTRING(ordem-compra.char-1,64,5)) = rowObject.cdn-tip-lote-pregao) THEN DO:
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-campo-de-lote-2 AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Campo_de_Lote" *}
              ASSIGN c-lbl-liter-campo-de-lote-2 = TRIM(RETURN-VALUE).
              DEFINE VARIABLE c-lbl-liter-ordem-de-compra-2 AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Ordem_de_Compra" *}
              ASSIGN c-lbl-liter-ordem-de-compra-2 = TRIM(RETURN-VALUE).
              {method/svc/errors/inserr.i
                   &ErrorNumber="5"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR" 
                   &ErrorParameters="c-lbl-liter-campo-de-lote-2 + '~~~~' + c-lbl-liter-ordem-de-compra-2"}
           
           END.
       &ENDIF
    END.
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
       RETURN "NOK":U.

    IF pType = "Delete" THEN
       RUN deletaCamposTipoLote. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
