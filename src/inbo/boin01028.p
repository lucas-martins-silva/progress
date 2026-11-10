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
{include/i-prgvrs.i BOIN01028 2.00.00.016 } /*** "010016" 23/11/2023 16:19:40  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin01028 MUT}
&ENDIF

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN01028
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName solicit-cotac
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
&GLOBAL-DEFINE KeyField1 cdd-solicit /*:T Informar os campos da chave quando o Progress nío conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin01028.i RowObject}
{inbo/boin01028.i ttSolicitCotac}
{inbo/boin01028.i1 ttSolicitCotacAux}

DEFINE TEMP-TABLE ttProfile NO-UNDO
    FIELD pageId    AS CHARACTER
    FIELD dataCode  AS CHARACTER
    FIELD dataValue AS CHARACTER.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def new Global shared var c-seg-usuario as char format "x(12)" no-undo.

DEFINE VARIABLE c-lb-processo-cotacao    AS CHARACTER        NO-UNDO.
DEFINE VARIABLE c-lb-comprador           AS CHARACTER        NO-UNDO.
DEFINE VARIABLE c-lb-solicit-cotac       AS CHARACTER        NO-UNDO.
DEFINE VARIABLE cStatusQuotationProcess  AS CHARACTER        NO-UNDO.
DEFINE VARIABLE lExecValidateHeader      AS LOGICAL INIT YES NO-UNDO.
DEFINE VARIABLE lExecValidateEmailConfig AS LOGICAL INIT YES NO-UNDO.

{utp/ut-liter.i "Sem_envio"}
ASSIGN cStatusQuotationProcess = RETURN-VALUE.
{utp/ut-liter.i "Com_envio"}
ASSIGN cStatusQuotationProcess = cStatusQuotationProcess + "," + RETURN-VALUE.
{utp/ut-liter.i "Respondido_parcial"}
ASSIGN cStatusQuotationProcess = cStatusQuotationProcess + "," + RETURN-VALUE.
{utp/ut-liter.i "Respondido_total"}
ASSIGN cStatusQuotationProcess = cStatusQuotationProcess + "," + RETURN-VALUE.
{utp/ut-liter.i "Cotado_parcial"}
ASSIGN cStatusQuotationProcess = cStatusQuotationProcess + "," + RETURN-VALUE.
{utp/ut-liter.i "Finalizado"}
ASSIGN cStatusQuotationProcess = cStatusQuotationProcess + "," + RETURN-VALUE.
{utp/ut-liter.i "Processo_de_Cotaá∆o"}
ASSIGN c-lb-processo-cotacao = RETURN-VALUE.
{utp/ut-liter.i Comprador}
ASSIGN c-lb-comprador = RETURN-VALUE.
{utp/ut-liter.i "Solicitaá∆o_de_Cotaá∆o"}
ASSIGN c-lb-solicit-cotac = RETURN-VALUE.

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
        WHEN "assunto-email":U THEN ASSIGN pFieldValue = RowObject.assunto-email.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-livre-3":U THEN ASSIGN pFieldValue = RowObject.cod-livre-3.
        WHEN "cod-livre-4":U THEN ASSIGN pFieldValue = RowObject.cod-livre-4.
        WHEN "cod-usuar-criac":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-criac.
        WHEN "cod-usuar-solic":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-solic.
        WHEN "dsl-compltar":U THEN ASSIGN pFieldValue = RowObject.dsl-compltar.
        WHEN "des-solicit":U THEN ASSIGN pFieldValue = RowObject.des-solicit.
        WHEN "dsl-texto":U THEN ASSIGN pFieldValue = RowObject.dsl-texto.
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
        WHEN "dat-livre-3":U THEN ASSIGN pFieldValue = RowObject.dat-livre-3.
        WHEN "dat-livre-4":U THEN ASSIGN pFieldValue = RowObject.dat-livre-4.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDatetimeField DBOProgram 
PROCEDURE getDatetimeField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo datetime
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATETIME NO-UNDO.

    /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
	    WHEN "dtm-criac":U  THEN ASSIGN pFieldValue = RowObject.dtm-criac.
        WHEN "dtm-liber":U   THEN ASSIGN pFieldValue = RowObject.dtm-liber.
        WHEN "dtm-expirac":U THEN ASSIGN pFieldValue = RowObject.dtm-expirac.   
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
        WHEN "cdd-solicit":U THEN ASSIGN pFieldValue = RowObject.cdd-solicit.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-livre-3":U THEN ASSIGN pFieldValue = RowObject.val-livre-3.
        WHEN "val-livre-4":U THEN ASSIGN pFieldValue = RowObject.val-livre-4.
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
        WHEN "cdn-mensagem":U THEN ASSIGN pFieldValue = RowObject.cdn-mensagem.
        WHEN "idi-situacao":U THEN ASSIGN pFieldValue = RowObject.idi-situacao.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-livre-3":U THEN ASSIGN pFieldValue = RowObject.num-livre-3.
        WHEN "num-livre-4":U THEN ASSIGN pFieldValue = RowObject.num-livre-4.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice slctctc_id2
  Parameters:  
               retorna valor do campo cdd-solicit
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdd-solicit LIKE solicit-cotac.cdd-solicit NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdd-solicit = RowObject.cdd-solicit.

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
        WHEN "log-confir-entreg":U THEN ASSIGN pFieldValue = RowObject.log-confir-entreg.
        WHEN "log-confir-recebto":U THEN ASSIGN pFieldValue = RowObject.log-confir-recebto.
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        WHEN "log-livre-3":U THEN ASSIGN pFieldValue = RowObject.log-livre-3.
        WHEN "log-livre-4":U THEN ASSIGN pFieldValue = RowObject.log-livre-4.
        WHEN "log-planilha-envda":U THEN ASSIGN pFieldValue = RowObject.log-planilha-envda.
        WHEN "log-responde-via-web":U THEN ASSIGN pFieldValue = RowObject.log-responde-via-web.
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
  Purpose:     Reposiciona registro com base no °ndice slctctc_id2
  Parameters:  
               recebe valor do campo cdd-solicit
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdd-solicit LIKE solicit-cotac.cdd-solicit NO-UNDO.

    FIND FIRST bfsolicit-cotac WHERE 
        bfsolicit-cotac.cdd-solicit = pcdd-solicit NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfsolicit-cotac THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfsolicit-cotac)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findByKey DBOProgram  
PROCEDURE findByKey :
/*------------------------------------------------------------------------------
  Purpose:     Busca registro pela chave e valida se existe
  Parameters:  
               recebe valor do campo cdd-solicit
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdd-solicit LIKE solicit-cotac.cdd-solicit NO-UNDO.

    FIND FIRST bfsolicit-cotac WHERE 
        bfsolicit-cotac.cdd-solicit = pcdd-solicit NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfsolicit-cotac THEN DO:
         {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorParameters=c-lb-processo-cotacao}

        RETURN "NOK":U.
    END.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfsolicit-cotac)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     MÇtodo de abertura da query
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Removido o INDEXED-REPOSITION devido a erro em banco Oracle - Chamado aberto junto a Progress:
       https://supportlink.progress.com/partner/CDetails?id=5000c00001fkKLP */
OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK.

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

    IF pType = "UPDATE":U THEN DO:
        /*Valida se a solicitaá∆o de cotaá∆o existe*/
        IF NOT CAN-FIND (FIRST solicit-cotac 
                         WHERE solicit-cotac.cdd-solicit = RowObject.cdd-solicit) THEN DO:
            {method/svc/errors/inserr.i
                              &ErrorNumber="2"
                              &ErrorType="EMS"
                              &ErrorParameters=c-lb-processo-cotacao}
        END.
    END.

    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:

        IF lExecValidateHeader THEN DO:     
            /*Valida se o comprador foi informado*/
            IF RowObject.cod-usuar-solic = "" THEN DO:
                {method/svc/errors/inserr.i
                                      &ErrorNumber="3553"
                                      &ErrorType="EMS"
                                      &ErrorParameters=c-lb-comprador}
        
        
            END.
            /*Valida se existe comprador com o c¢digo informado*/
            ELSE IF NOT CAN-FIND (FIRST comprador 
                                  WHERE comprador.cod-comprado = RowObject.cod-usuar-solic) THEN DO:
                
                {method/svc/errors/inserr.i
                                  &ErrorNumber="2"
                                  &ErrorType="EMS"
                                  &ErrorParameters=c-lb-comprador}
            END.
        END.

        IF lExecValidateEmailConfig THEN DO:
            IF RowObject.dtm-expirac < NOW THEN DO:
                {method/svc/errors/inserr.i
                                  &ErrorNumber="26638"
                                  &ErrorType="EMS"
                                  &ErrorParameters="''"}   
            END.
    
            IF RowObject.assunto-email = "":U THEN DO:
                {utp/ut-liter.i "Assunto_do_e-mail"}
    
                {method/svc/errors/inserr.i
                                  &ErrorNumber="19007"
                                  &ErrorType="EMS"
                                  &ErrorParameters="return-value + '~~~~' + c-lb-processo-cotacao"}   
            END.
    
            IF RowObject.dsl-texto = "":U THEN DO:
                {utp/ut-liter.i "Texto_do_e-mail"}
    
                {method/svc/errors/inserr.i
                                  &ErrorNumber="19007"
                                  &ErrorType="EMS"
                                  &ErrorParameters="return-value + '~~~~' + c-lb-processo-cotacao"}   
            END.
        END.
    END.  
    
    IF pType = "DELETE":U THEN DO:
        if can-find (first envio-solicit-cotac
                     where envio-solicit-cotac.cdd-solicit = RowObject.cdd-solicit) then do:
            {utp/ut-liter.i "Envio_de_Solicitaá∆o_de_Cotaá∆o"}
            {method/svc/errors/inserr.i
                                &ErrorNumber="5"
                                &ErrorType="EMS"
                                &ErrorParameters="c-lb-processo-cotacao + '~~~~' + return-value"}  
        end.
    END.
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setValidateOptions DBOProgram 
PROCEDURE setValidateOptions :
/*:T------------------------------------------------------------------------------
  Purpose:     Seta opá‰es de validaá∆o (Dados do cabeáalho e/ou 
                                         Dados das Configuraá‰es de e-mail).
  Parameters:  plExecValidateHeader (input) - Informar se deve executar as 
               validaá‰es do cabeáalho(logical).
               plExecValidateEmailConfig (input) - Informar se deve executar as 
               validaá‰es das configuraá‰es de e-mail(logical).
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER plExecValidateHeader      AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER plExecValidateEmailConfig AS LOGICAL NO-UNDO.

    ASSIGN lExecValidateHeader      = plExecValidateHeader
           lExecValidateEmailConfig = plExecValidateEmailConfig.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateCreateRecord DBOProgram 
PROCEDURE updateCreateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Criaá∆o e alteraá∆o do processo de cotaá∆o.
  Parameters:  pcAction (input) - tipo de transaá∆o (CREATE, UPDATE)
               ttSolicitCotacAux (input) - Dados do processo de cotaá∆o - (temp-table)
               pCddSolicit (output) - C¢digo do processo salvo - (decimal)
               RowErrors (output) - temp-table de erros - (temp-table)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcAction AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR ttSolicitCotacAux.
    DEFINE OUTPUT PARAMETER pCddSolicit LIKE solicit-cotac.cdd-solicit NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE iNextNumber LIKE solicit-cotac.cdd-solicit NO-UNDO.

    run openQueryStatic IN THIS-PROCEDURE(input "Main":U) no-error.
    run emptyRowErrors in THIS-PROCEDURE.
    EMPTY TEMP-TABLE ttSolicitCotac NO-ERROR.

    IF pcAction = "CREATE":U THEN DO: /*Criaá∆o*/
        /*Verifica se j† existe processo de cotaá∆o com mesmo c¢digo 
        se tiver altera automaticamente para a pr¢xima sequància*/
        FIND FIRST ttSolicitCotacAux EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL ttSolicitCotacAux THEN DO:
            IF CAN-FIND (FIRST bfsolicit-cotac 
                         WHERE bfsolicit-cotac.cdd-solicit = ttSolicitCotacAux.cdd-solicit) THEN DO:
                RUN getNextCddSolicit (OUTPUT iNextNumber).
                ASSIGN ttSolicitCotacAux.des-solicit = REPLACE(ttSolicitCotacAux.des-solicit, string(ttSolicitCotacAux.cdd-solicit), string(iNextNumber))
                       ttSolicitCotacAux.cdd-solicit = iNextNumber.
            END.
            CREATE ttSolicitCotac.
            BUFFER-COPY ttSolicitCotacAux TO ttSolicitCotac NO-ERROR.
            run setRecord in THIS-PROCEDURE (input table ttSolicitCotac).
            run createRecord in THIS-PROCEDURE.
            ASSIGN pCddSolicit = ttSolicitCotacAux.cdd-solicit.
        END.
    END.
    ELSE DO: /*Alteraá∆o*/
        FIND FIRST ttSolicitCotacAux NO-LOCK NO-ERROR.
        IF AVAIL ttSolicitCotacAux THEN DO:
            ASSIGN pCddSolicit = ttSolicitCotacAux.cdd-solicit.
            RUN goToKey        IN THIS-PROCEDURE (INPUT pCddSolicit).
            CREATE ttSolicitCotac.
            BUFFER-COPY ttSolicitCotacAux TO ttSolicitCotac NO-ERROR.
            RUN setRecord      IN THIS-PROCEDURE (INPUT TABLE ttSolicitCotac).
            RUN updateRecord   IN THIS-PROCEDURE.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDefaults DBOProgram 
PROCEDURE getDefaults:
/*:T------------------------------------------------------------------------------
  Purpose:     Busca dados padr‰es para criaá∆o do processo de cotaá∆o
  Parameters:  ttSolicitCotacAux (output) - Dados do processo de cotaá∆o - (temp-table)
               RowErrors (output) - temp-table de erros - (temp-table)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR ttSolicitCotacAux.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE iNextNumber LIKE solicit-cotac.cdd-solicit NO-UNDO.
    DEFINE VARIABLE h-btapi930za  AS HANDLE                    NO-UNDO.

    IF NOT VALID-HANDLE(h-btapi930za) THEN
        RUN btb/btapi930za.p PERSISTENT SET h-btapi930za.

    RUN getNextCddSolicit IN THIS-PROCEDURE (OUTPUT iNextNumber).

    CREATE ttSolicitCotacAux.
    ASSIGN ttSolicitCotacAux.cdd-solicit     = iNextNumber
           ttSolicitCotacAux.cod-usuar-solic = c-seg-usuario
           ttSolicitCotacAux.des-solicit     = c-lb-solicit-cotac + " " + string(iNextNumber)
           ttSolicitCotacAux.situacao        = 1 /*Sem solicitaá∆o*/
           ttSolicitCotacAux.des-situacao    = ENTRY(1,cStatusQuotationProcess)
           ttSolicitCotacAux.dtm-expirac     = DATETIME(12, 31, 9999, 23, 59)
		   ttSolicitCotacAux.dtm-criac       = NOW
           ttSolicitCotacAux.dtm-liber       = NOW.
           

    RUN REST_GET_getProfile IN h-btapi930za (INPUT c-seg-usuario,
                                             INPUT "/dts/mcc/requestquotation":U,
                                             INPUT "":U, /* Todas as configuraá‰es */
                                             OUTPUT TABLE ttProfile,
                                             OUTPUT TABLE RowErrors).

    FIND FIRST ttProfile NO-LOCK NO-ERROR.

    IF AVAIL ttProfile THEN DO:
        FOR EACH ttProfile NO-LOCK:
            CASE ttProfile.dataCode:
                WHEN "EmailTitle":U THEN
                    ASSIGN ttSolicitCotacAux.assunto-email = substring(ttProfile.dataValue, 2, LENGTH(ttProfile.dataValue) - 2).
                WHEN "EmailMsg":U THEN
                    ASSIGN ttSolicitCotacAux.cdn-mensagem = int(ttProfile.dataValue). 
                WHEN "EmailText":U THEN
                    ASSIGN ttSolicitCotacAux.dsl-texto = replace(substring(ttProfile.dataValue, 2, LENGTH(ttProfile.dataValue) - 2),"\n":U, CHR(10)).
                WHEN "sendSpreadsheet":U THEN
                    ASSIGN ttSolicitCotacAux.log-planilha-envda = logical(ttProfile.dataValue).
                WHEN "answerByWeb":U THEN
                    ASSIGN ttSolicitCotacAux.log-responde-via-web = logical(ttProfile.dataValue).
            END CASE.
        END.
    END.
    ELSE DO:
        ASSIGN ttSolicitCotacAux.assunto-email        = c-lb-solicit-cotac
               ttSolicitCotacAux.log-planilha-envda   = YES
               ttSolicitCotacAux.log-responde-via-web = TRUE
               ttSolicitCotacAux.cdn-mensagem         = 0.
    END.

    IF VALID-HANDLE(h-btapi930za) THEN DO:
        DELETE PROCEDURE h-btapi930za.
        ASSIGN h-btapi930za = ?.
    END.

    RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQuotationProcess DBOProgram 
PROCEDURE getQuotationProcess :
/*:T------------------------------------------------------------------------------
  Purpose:     Busca dados do processo de cotaá∆o existente.
  Parameters:  pCddSolicit (input) - C¢digo do processo de cotaá∆o - decimal
               ttSolicitCotacAux (output) - Dados do processo de cotaá∆o - (temp-table)
               RowErrors (output) - temp-table de erros - (temp-table)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pCddSolicit LIKE solicit-cotac.cdd-solicit NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttSolicitCotacAux.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE iStatusProcess AS INTEGER NO-UNDO.

    EMPTY TEMP-TABLE ttSolicitCotacAux.
    
    FIND FIRST solicit-cotac WHERE solicit-cotac.cdd-solicit = pCddSolicit
                             NO-LOCK NO-ERROR.
    IF AVAIL solicit-cotac THEN DO:
        CREATE ttSolicitCotacAux.
        BUFFER-COPY solicit-cotac TO ttSolicitCotacAux NO-ERROR.
        RUN getStatusQuotationProcess IN THIS-PROCEDURE (INPUT  pCddSolicit,
                                                         OUTPUT iStatusProcess,
                                                         OUTPUT TABLE RowErrors).
        
        ASSIGN ttSolicitCotacAux.situacao = iStatusProcess
               ttSolicitCotacAux.des-situacao = ENTRY(iStatusProcess,cStatusQuotationProcess).
    END.
    ELSE DO:
        IF NOT AVAIL solicit-cotac THEN DO:
            {method/svc/errors/inserr.i
                              &ErrorNumber="2"
                              &ErrorType="EMS"
                              &ErrorParameters=c-lb-processo-cotacao}
            RETURN "NOK":U.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

   /* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNextCddSolicit DBOProgram 
PROCEDURE getNextCddSolicit :
/*:T------------------------------------------------------------------------------
  Purpose:     Busca pr¢ximo n£mero do processo de cotaá∆o.
  Parameters:  iNextNumber (input) - Pr¢ximo n£mero do processo de cotaá∆o
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM iNextNumber LIKE solicit-cotac.cdd-solicit NO-UNDO.

    FIND LAST solicit-cotac NO-LOCK NO-ERROR.
    IF AVAIL solicit-cotac THEN
        ASSIGN iNextNumber = solicit-cotac.cdd-solicit + 1.
    ELSE
        ASSIGN iNextNumber = 1.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getStatusQuotationProcess DBOProgram 
PROCEDURE getStatusQuotationProcess :
/*:T------------------------------------------------------------------------------
  Purpose: Retorna a situaá∆o do processo de cotaá∆o.     
  Parameters:  pCddSolicit (input) - C¢digo do processo de cotaá∆o     
               piStatus (output) - Situaá∆o do processo de cotaá∆o 
                                    1 - Sem solicitaá∆o
                                    2 - Com solicitaá∆o
                                    3 - Respondido Parcial
                                    4 - Respondido Total
                                    5 - Cotado Parcial
                                    6 - Finalizado
              RowErrors (output) - temp-table de erros - (temp-table)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM pCddSolicit LIKE solicit-cotac.cdd-solicit NO-UNDO.
    DEFINE OUTPUT PARAM piStatus    AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE lAnswered     AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lNotAnswered  AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lSend         AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lApproved     AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lNotApproved  AS LOGICAL NO-UNDO.

    IF NOT CAN-FIND(FIRST solicit-cotac 
         WHERE solicit-cotac.cdd-solicit = pCddSolicit) THEN DO:
        {method/svc/errors/inserr.i
                          &ErrorNumber="2"
                          &ErrorType="EMS"
                          &ErrorParameters=c-lb-processo-cotacao}
    END.
    ELSE DO:
        /*Sem solicitaá∆o*/
        ASSIGN piStatus = 1.

        FOR EACH item-solicit-cotac FIELDS(numero-ordem cdd-solicit)
           WHERE item-solicit-cotac.cdd-solicit = pCddSolicit NO-LOCK:

            /*Verifica se h† cotaá‰es aprovadas e n∆o aprovadas*/ 
            IF CAN-FIND (FIRST ordem-compra 
                         WHERE ordem-compra.numero-ordem = item-solicit-cotac.numero-ordem
                           AND (ordem-compra.situacao = 3 /*Cotada*/
                             OR ordem-compra.situacao = 2 /*Confirmada*/
                             OR ordem-compra.situacao = 4 /*Eliminada*/
                             OR ordem-compra.situacao = 6 /*Recebida*/)) THEN
                ASSIGN lApproved = YES.
            ELSE DO:
                ASSIGN lNotApproved = YES.

                IF NOT lApproved THEN DO: 

                    /*Verifica se h† cotaá∆o para a ordem*/
                    IF CAN-FIND(FIRST cotacao-item 
                                WHERE cotacao-item.numero-ordem = item-solicit-cotac.numero-ordem
                                  AND cotacao-item.preco-fornec > 0) THEN
                        ASSIGN lAnswered = YES.
                    ELSE
                        ASSIGN lNotAnswered = YES.

                    /*Se existir envio*/
                    IF CAN-FIND (FIRST item-envio-solicit-cotac
                                 WHERE item-envio-solicit-cotac.cdd-solicit  = item-solicit-cotac.cdd-solicit
                                   AND item-envio-solicit-cotac.numero-ordem = item-solicit-cotac.numero-ordem)THEN DO:

                        FOR EACH item-envio-solicit-cotac FIELDS(cdn-fornec)
                           WHERE item-envio-solicit-cotac.cdd-solicit  = item-solicit-cotac.cdd-solicit
                             AND item-envio-solicit-cotac.numero-ordem = item-solicit-cotac.numero-ordem NO-LOCK:
                            ASSIGN lSend = YES.
                            IF NOT CAN-FIND(FIRST cotacao-item 
                                        WHERE cotacao-item.numero-ordem = item-solicit-cotac.numero-ordem
                                          AND cotacao-item.cod-emitente = item-envio-solicit-cotac.cdn-fornec
                                          AND cotacao-item.preco-fornec > 0) THEN
                                ASSIGN lNotAnswered = YES.
                        END.
                    END.
                END.
            END.
        END.

        /*Se existir ordens cotadas e n∆o existir ordens que n∆o est∆o cotadas*/
        IF lApproved AND NOT lNotApproved THEN 
            ASSIGN piStatus = 6. /*Finalizado*/
        /*Se existir ordens cotadas e tabÇm existir ordens que n∆o est∆o cotadas*/
        ELSE IF lApproved AND lNotApproved THEN 
            ASSIGN piStatus = 5. /*Cotado Parcial*/
        /*Se existir itens respondidos e n∆o exisitir itens n∆o respondidos*/
        ELSE IF lAnswered AND NOT lNotAnswered THEN
            ASSIGN piStatus = 4. /*Respondido Total*/
        /*Se existir itens respondidos e tambÇm exisitir itens n∆o respondidos*/
        ELSE IF lAnswered AND lNotAnswered THEN
            ASSIGN piStatus = 3. /*Respondido Parcial*/
        /*Se existir itens enviados*/
        ELSE IF lSend THEN
            ASSIGN piStatus = 2. /*Com solicitaá∆o*/
        /*Se n∆o se enquadrar nas opá‰es acima*/
        ELSE 
            ASSIGN piStatus = 1. /*Sem solicitaá∆o*/
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
