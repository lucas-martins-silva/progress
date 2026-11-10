&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME    
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
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
{include/i-prgvrs.i BOCX00450 2.00.00.010 } /*** "010010" 11/12/2023 10:13:19 ***/
/* ***************************  Definitions  ***************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX00450
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName tip-movto-export
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
{cxbo/bocx00450.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE iCdnMovtoIni  LIKE tip-movto-export.cdn-movto NO-UNDO.
DEFINE VARIABLE iCdnMovtoFim  LIKE tip-movto-export.cdn-movto NO-UNDO.
DEFINE VARIABLE cDescMovtoIni LIKE tip-movto-export.desc-movto NO-UNDO.
DEFINE VARIABLE cDescMovtoFim LIKE tip-movto-export.desc-movto NO-UNDO.
DEFINE VARIABLE cSigMovtoIni  LIKE tip-movto-export.sig-movto NO-UNDO.
DEFINE VARIABLE cSigMovtoFim  LIKE tip-movto-export.sig-movto NO-UNDO.

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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 2
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-sugere-cod-movto DBOProgram  
PROCEDURE pi-sugere-cod-movto :
/*------------------------------------------------------------------------------
  Purpose:     Retorna o pr¢ximo c¢digo para o tipo de movimento
  Parameters:  
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER i-cdn-movto LIKE tip-movto-export.cdn-movto NO-UNDO.

    FIND LAST bftip-movto-export NO-LOCK NO-ERROR.

    IF AVAIL bftip-movto-export THEN DO:
        ASSIGN i-cdn-movto = bftip-movto-export.cdn-movto + 1.
    END.
    ELSE DO:
        /* Sugere 5, pois de 1 a 4 s∆o registros padr‰es */
        ASSIGN i-cdn-movto = 5.
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
        WHEN "sig-movto":U THEN ASSIGN pFieldValue = RowObject.sig-movto.
        WHEN "desc-movto":U THEN ASSIGN pFieldValue = RowObject.desc-movto.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
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
        WHEN "cdn-movto":U THEN ASSIGN pFieldValue = RowObject.cdn-movto.
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
  Purpose:     Retorna valores dos campos do °ndice tpmvtxpr_id2
  Parameters:  
               retorna valor do campo cdn-movto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn-movto LIKE tip-movto-export.cdn-movto NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn-movto = RowObject.cdn-movto.

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
  Purpose:     Reposiciona registro com base no °ndice tpmvtxpr_id2
  Parameters:  
               recebe valor do campo cdn-movto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-movto LIKE tip-movto-export.cdn-movto NO-UNDO.

    FIND FIRST bftip-movto-export WHERE 
        bftip-movto-export.cdn-movto = pcdn-movto NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bftip-movto-export THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bftip-movto-export)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura de todos os registros da query
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryTipoMovimento DBOProgram 
PROCEDURE openQueryTipoMovimento :
/*------------------------------------------------------------------------------
  Purpose: Realiza abertura da query com base na procedure setConstraintTipoMovimento   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK 
                               WHERE {&TABLENAME}.cdn-movto  >= iCdnMovtoIni  AND 
                                     {&TABLENAME}.cdn-movto  <= iCdnMovtoFim  AND 
                                     {&TABLENAME}.desc-movto >= cDescMovtoIni AND 
                                     {&TABLENAME}.desc-movto <= cDescMovtoFim BY cdn-movto INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDescMovimento DBOProgram 
PROCEDURE openQueryDescMovimento :
/*------------------------------------------------------------------------------
  Purpose: Realiza abertura da query com base na procedure setConstraintDescMovimento      
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK 
                               WHERE {&TABLENAME}.cdn-movto  >= iCdnMovtoIni  AND 
                                     {&TABLENAME}.cdn-movto  <= iCdnMovtoFim  AND 
                                     {&TABLENAME}.desc-movto >= cDescMovtoIni AND 
                                     {&TABLENAME}.desc-movto <= cDescMovtoFim BY desc-movto INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySigla DBOProgram 
PROCEDURE openQuerySigla :
/*------------------------------------------------------------------------------
  Purpose: Realiza abertura da query com base na procedure setConstraintSigla     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK 
                               WHERE {&TABLENAME}.cdn-movto  >= iCdnMovtoIni  AND 
                                     {&TABLENAME}.cdn-movto  <= iCdnMovtoFim  AND 
                                     {&TABLENAME}.desc-movto >= cDescMovtoIni AND 
                                     {&TABLENAME}.desc-movto <= cDescMovtoFim AND 
                                     {&TABLENAME}.sig-movto  >= cSigMovtoIni  AND 
                                     {&TABLENAME}.sig-movto  <= cSigMovtoFim  BY sig-movto INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintTipoMovimento DBOProgram 
PROCEDURE setConstraintTipoMovimento :
/*------------------------------------------------------------------------------
  Purpose: Recebe os parÉmetros para abertura da query "TipoMovimento"    
  Parameters: pCdnMovtoIni (integer): C¢digo inicial do movimento
              pCdnMovtoFim (integer): C¢digo final do movimento
              pDescMovtoIni (Character): Descriá∆o inicial do movimento
              pDescMovtoFim (Character): Descriá∆o final do movimento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pCdnMovtoIni  LIKE tip-movto-export.cdn-movto  NO-UNDO.
    DEFINE INPUT PARAM pCdnMovtoFim  LIKE tip-movto-export.cdn-movto  NO-UNDO.
    DEFINE INPUT PARAM pDescMovtoIni LIKE tip-movto-export.desc-movto NO-UNDO.
    DEFINE INPUT PARAM pDescMovtoFim LIKE tip-movto-export.desc-movto NO-UNDO.

    ASSIGN iCdnMovtoIni  = pCdnMovtoIni  
           iCdnMovtoFim  = pCdnMovtoFim  
           cDescMovtoIni = pDescMovtoIni 
           cDescMovtoFim = pDescMovtoFim.  

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDescMovimento DBOProgram 
PROCEDURE setConstraintDescMovimento :
/*------------------------------------------------------------------------------
  Purpose: Recebe os parÉmetros para abertura da query "DescMovimento"    
  Parameters: pDescMovtoIni (Character): Descriá∆o inicial do movimento
              pDescMovtoFim (Character): Descriá∆o final do movimento
              pCdnMovtoIni (integer): C¢digo inicial do movimento
              pCdnMovtoFim (integer): C¢digo final do movimento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pDescMovtoIni LIKE tip-movto-export.desc-movto NO-UNDO.
    DEFINE INPUT PARAM pDescMovtoFim LIKE tip-movto-export.desc-movto NO-UNDO.
    DEFINE INPUT PARAM pCdnMovtoIni  LIKE tip-movto-export.cdn-movto  NO-UNDO.
    DEFINE INPUT PARAM pCdnMovtoFim  LIKE tip-movto-export.cdn-movto  NO-UNDO.

    ASSIGN iCdnMovtoIni  = pCdnMovtoIni  
           iCdnMovtoFim  = pCdnMovtoFim  
           cDescMovtoIni = pDescMovtoIni 
           cDescMovtoFim = pDescMovtoFim.  

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSigla DBOProgram 
PROCEDURE setConstraintSigla :
/*------------------------------------------------------------------------------
  Purpose: Recebe os parÉmetros para abertura da query "Sigla"     
  Parameters: pSigMovtoIni (character): Sigla inicial
              pSigMovtoFim (character): Sigla final
              pCdnMovtoIni (integer): C¢digo inicial do movimento
              pCdnMovtoFim (integer): C¢digo final do movimento
              pDescMovtoIni (Character): Descriá∆o inicial do movimento
              pDescMovtoFim (Character): Descriá∆o final do movimento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pSigMovtoIni  LIKE tip-movto-export.sig-movto  NO-UNDO.
    DEFINE INPUT PARAM pSigMovtoFim  LIKE tip-movto-export.sig-movto  NO-UNDO.
    DEFINE INPUT PARAM pCdnMovtoIni  LIKE tip-movto-export.cdn-movto  NO-UNDO.
    DEFINE INPUT PARAM pCdnMovtoFim  LIKE tip-movto-export.cdn-movto  NO-UNDO.
    DEFINE INPUT PARAM pDescMovtoIni LIKE tip-movto-export.desc-movto NO-UNDO.
    DEFINE INPUT PARAM pDescMovtoFim LIKE tip-movto-export.desc-movto NO-UNDO.

    ASSIGN iCdnMovtoIni  = pCdnMovtoIni  
           iCdnMovtoFim  = pCdnMovtoFim  
           cDescMovtoIni = pDescMovtoIni 
           cDescMovtoFim = pDescMovtoFim 
           cSigMovtoIni  = pSigMovtoIni  
           cSigMovtoFim  = pSigMovtoFim.  

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

    IF pType = "CREATE":U THEN DO:
        IF CAN-FIND(FIRST bf{&TableName}
             WHERE bf{&TableName}.cdn-movto   = RowObject.cdn-movto) THEN DO:
            {utp/ut-liter.i Tipo_de_Movimento * R}
            {method/svc/errors/inserr.i &ErrorNumber="1"
                            &ErrorType="EMS"
                            &ErrorSubType="Error"
                            &ErrorParameters="return-value"}
        END.
    END.
    
    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
        IF RowObject.desc-movto = "" THEN DO:
            {utp/ut-liter.i Descriá∆o * R}
            {method/svc/errors/inserr.i &ErrorNumber="3553"
                            &ErrorType="EMS"
                            &ErrorSubType="Error"
                            &ErrorParameters="return-value"}
        END.

        IF RowObject.sig-movto = "" THEN DO:
            {utp/ut-liter.i Sigla * R}
            {method/svc/errors/inserr.i &ErrorNumber="3553"
                            &ErrorType="EMS"
                            &ErrorSubType="Error"
                            &ErrorParameters="return-value"}
        END.
    END.

    IF pType = "CREATE":U OR pType = "DELETE":U THEN DO:
        /* Registros padr‰es n∆o podem ser inclusos, alterados ou eliminados */
        IF RowObject.cdn-movto >= 1 AND RowObject.cdn-movto <= 4 THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="53707"
                                &ErrorType="EMS"
                                &ErrorSubType="Error"
                                &ErrorParameters="return-value"}       
        END.
        ELSE IF pType = "DELETE":U THEN DO:
            /*N∆o permite eliminaá∆o quando possui relacionamento ativo*/
            IF CAN-FIND (FIRST proces-exp-adic
                         WHERE proces-exp-adic.cdn-movto = RowObject.cdn-movto) OR
               CAN-FIND (FIRST ped-venda-cex
                         WHERE INT(TRIM(SUBSTRING(ped-venda-cex.char-2,101,6))) = RowObject.cdn-movto) THEN DO:
                {utp/ut-table.i mgcex tip-movto-export 1}
                {method/svc/errors/inserr.i
                        &ErrorNumber="3"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="RETURN-VALUE"}
            END.
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodigo DBOProgram 
PROCEDURE findCodigo :
/*:T------------------------------------------------------------------------------
  Purpose:     Busca tipo do movimento pelo c¢digo
  Parameters:  i-cdn-movto - C¢digo do movimento
               c-return - retorna mensagem de erro padrao do EMS.
  Notes:       
------------------------------------------------------------------------------*/
    run startMethod ("find").
    def input parameter i-cdn-movto LIKE tip-movto-export.cdn-movto no-undo.
    def output parameter c-return as char no-undo.

    FIND FIRST tip-movto-export 
         WHERE tip-movto-export.cdn-movto = i-cdn-movto
        NO-LOCK NO-ERROR.
    IF NOT AVAIL tip-movto-export THEN DO:
       
        {utp/ut-table.i mgcex tip-movto-export 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.
    end.
    else do:
       run setCurrent.
    end.
    run endMethod ("find").

    RETURN "OK":U.
end procedure.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
