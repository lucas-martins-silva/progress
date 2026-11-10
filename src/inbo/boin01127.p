&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/**************************************************************************
** Copyright TOTVS S.A. (2025)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa. 
***************************************************************************/
{include/i-prgvrs.i BOIN01127 2.00.00.011 } /* 23/10/2026 10:05:26 */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin01127 MUT}
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
&GLOBAL-DEFINE DBOName BOIN01127
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName class-trib
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
{inbo/boin01127.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VAR cClassTribIni AS CHARACTER NO-UNDO.
DEFINE VAR cClassTribFim AS CHARACTER NO-UNDO.
DEFINE VAR iTribRegular  AS INTEGER   NO-UNDO.
    
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
        WHEN "cod-cclass-trib":U THEN ASSIGN pFieldValue = RowObject.cod-cclass-trib.
        WHEN "credito-anterior":U THEN ASSIGN pFieldValue = RowObject.credito-anterior.
        WHEN "credito-posterior":U THEN ASSIGN pFieldValue = RowObject.credito-posterior.
        WHEN "descricao-cclass-trib":U THEN ASSIGN pFieldValue = RowObject.descricao-cclass-trib.
        WHEN "emenda-const":U THEN ASSIGN pFieldValue = RowObject.emenda-const.
        WHEN "tomador-espec":U THEN ASSIGN pFieldValue = RowObject.tomador-espec.
        WHEN "tipo-documento":U THEN ASSIGN pFieldValue = RowObject.tipo-documento.
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
        WHEN "dt-vigencia-fim":U THEN ASSIGN pFieldValue = RowObject.dt-vigencia-fim.
        WHEN "dt-vigencia-ini":U THEN ASSIGN pFieldValue = RowObject.dt-vigencia-ini.
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
        WHEN "ind-tributo":U THEN ASSIGN pFieldValue = RowObject.ind-tributo.
        WHEN "exige-trib":U THEN ASSIGN pFieldValue = RowObject.exige-trib.
        WHEN "monofasico":U THEN ASSIGN pFieldValue = RowObject.monofasico.
        WHEN "mono-retencao":U THEN ASSIGN pFieldValue = RowObject.mono-retencao.
        WHEN "mono-retido-ant":U THEN ASSIGN pFieldValue = RowObject.mono-retido-ant.
        WHEN "mono-dif":U THEN ASSIGN pFieldValue = RowObject.mono-dif.
        WHEN "red-aliq":U THEN ASSIGN pFieldValue = RowObject.red-aliq.
        WHEN "diferimento":U THEN ASSIGN pFieldValue = RowObject.diferimento.
        WHEN "red-base-calc":U THEN ASSIGN pFieldValue = RowObject.red-base-calc.
        WHEN "transf-cred":U THEN ASSIGN pFieldValue = RowObject.transf-cred.
        WHEN "trib-regular":U THEN ASSIGN pFieldValue = RowObject.trib-regular.
        WHEN "credito-pres":U THEN ASSIGN pFieldValue = RowObject.credito-pres.
        WHEN "biocombustivel":U THEN ASSIGN pFieldValue = RowObject.biocombustivel.
        WHEN "tipo-doacao":U THEN ASSIGN pFieldValue = RowObject.tipo-doacao.
        WHEN "tipo-receita-bruta-sn":U THEN ASSIGN pFieldValue = RowObject.tipo-receita-bruta-sn.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice cclasstrib
  Parameters:  
               retorna valor do campo cod-cclass-trib
               retorna valor do campo ind-tributo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-cclass-trib LIKE class-trib.cod-cclass-trib NO-UNDO.
    DEFINE OUTPUT PARAMETER pind-tributo LIKE class-trib.ind-tributo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-cclass-trib = RowObject.cod-cclass-trib
           pind-tributo = RowObject.ind-tributo.

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
  Purpose:     Reposiciona registro com base no °ndice cclasstrib
  Parameters:  
               recebe valor do campo cod-cclass-trib
               recebe valor do campo ind-tributo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-cclass-trib LIKE class-trib.cod-cclass-trib NO-UNDO.
    DEFINE INPUT PARAMETER pind-tributo LIKE class-trib.ind-tributo NO-UNDO.

    FIND FIRST bfclass-trib WHERE 
        bfclass-trib.cod-cclass-trib = pcod-cclass-trib AND 
        bfclass-trib.ind-tributo = pind-tributo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfclass-trib THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfclass-trib)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaClassTrib DBOProgram 
PROCEDURE setConstraintFaixaClassTrib :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pClassTribIni AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pClassTribFim AS CHARACTER NO-UNDO.
        
    ASSIGN   cClassTribIni   = pClassTribIni
             cClassTribFim = pClassTribFim. 
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaClassTrib DBOProgram 
PROCEDURE openQueryFaixaClassTrib :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH  {&TableName} NO-LOCK
                                WHERE {&TableName}.cod-cclass-trib >= cClassTribIni
                                  AND {&TableName}.cod-cclass-trib <= cClassTribFim INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixaClassTribReg DBOProgram 
PROCEDURE setConstraintClassTribAndReg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pClassTribIni AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pClassTribFim AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pTribRegular  AS INTEGER   NO-UNDO.
        
    ASSIGN   cClassTribIni = pClassTribIni
             cClassTribFim = pClassTribFim
             iTribRegular  = pTribRegular. 
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixaClassTribReg DBOProgram 
PROCEDURE openQueryClassTribAndReg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH  {&TableName} NO-LOCK
                                WHERE {&TableName}.cod-cclass-trib >= cClassTribIni
                                  AND {&TableName}.cod-cclass-trib <= cClassTribFim
                                  AND {&TableName}.trib-regular     = iTribRegular INDEXED-REPOSITION.

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

    IF pType = 'create':U
    OR pType = 'update':U THEN DO:
        
        IF pType = 'create' 
        AND CAN-FIND (FIRST bfclass-trib  NO-LOCK
                      WHERE bfclass-trib.cod-cclass-trib = RowObject.cod-cclass-trib 
                      AND   bfclass-trib.ind-tributo     = RowObject.ind-tributo) THEN DO:
                {utp/ut-liter.i "cClassTrib" *}        
                {method/svc/errors/inserr.i &ErrorNumber="1"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}           
                         
        END.
        IF RowObject.cod-cclass-trib = "" THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'cClassTrib'"}
        END.
        IF RowObject.ind-tributo = 0 THEN DO:
           {utp/ut-liter.i Tipo_tributo *}
            {method/svc/errors/inserr.i
                               &ErrorNumber="1491"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"
                               &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.
        
        IF LENGTH(RowObject.cod-cclass-trib) > 9 THEN DO:
            {utp/ut-liter.i cClassTrib *}
            {method/svc/errors/inserr.i
                &ErrorNumber="57359"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="TRIM(RETURN-VALUE) + '~~~~9'"}
        END.
        
        IF LENGTH(RowObject.descricao-cclass-trib ) > 2000 THEN DO:
            {utp/ut-liter.i Descriá∆o *}
            {method/svc/errors/inserr.i
                &ErrorNumber="57359"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="TRIM(RETURN-VALUE) + '~~~~2000'"}
        END.
        IF LENGTH(RowObject.emenda-const) > 50 THEN DO:
            {utp/ut-liter.i Emenda_constitucional *}
            {method/svc/errors/inserr.i
                &ErrorNumber="57359"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="TRIM(RETURN-VALUE) + '~~~~50'"}
        END.        
        
        IF LENGTH(RowObject.credito-anterior) > 500 THEN DO:
            {utp/ut-liter.i CrÇdito_anterior *}
            {method/svc/errors/inserr.i
                &ErrorNumber="57359"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="TRIM(RETURN-VALUE) + '~~~~500'"}
        END.   
        IF LENGTH(RowObject.credito-posterior) > 500 THEN DO:
            {utp/ut-liter.i CrÇdito_para_frente *}
            {method/svc/errors/inserr.i
                &ErrorNumber="57359"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="TRIM(RETURN-VALUE) + '~~~~500'"}
        END.       
        
        IF LENGTH(RowObject.tomador-espec) > 200 THEN DO:
            {utp/ut-liter.i Tomador_espec°fico *}
            {method/svc/errors/inserr.i
                &ErrorNumber="57359"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="TRIM(RETURN-VALUE) + '~~~~200'"}
        END.   
        
        IF  RowObject.dt-vigencia-ini = ? THEN DO:
            {utp/ut-liter.i Data_vigància_inicial *}
            {method/svc/errors/inserr.i
                            &ErrorNumber="822"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.
        
        IF  RowObject.dt-vigencia-fim <> ? 
        AND RowObject.dt-vigencia-ini > RowObject.dt-vigencia-fim THEN DO:
        
            {method/svc/errors/inserr.i &ErrorNumber="36306"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
        END.
       
    END.
    
    IF pType = 'delete':U THEN DO:
    
        FIND FIRST relac-class-trib NO-LOCK
             WHERE relac-class-trib.cod-cclass-trib = RowObject.cod-cclass-trib
               AND relac-class-trib.ind-tributo     = RowObject.ind-tributo     NO-ERROR.
        IF AVAIL relac-class-trib THEN DO:
            {utp/ut-liter.i Relacionamento_cClassTrib *}
            {method/svc/errors/inserr.i &ErrorNumber="5"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
PROCEDURE validaTribRegular:
    DEFINE INPUT PARAM  pTribRegular AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAM  pcClassTrib  LIKE RowObject.cod-cclass-trib  NO-UNDO.
    DEFINE INPUT PARAM  pIndTributo  LIKE  RowObject.ind-tributo  NO-UNDO.
    
    IF  pTribRegular = NO
    AND CAN-FIND (FIRST relac-class-trib NO-LOCK
                  WHERE relac-class-trib.cod-cclass-trib = pcClassTrib
                    AND relac-class-trib.ind-tributo     = pIndTributo
                    AND relac-class-trib.cod-cclass-trib-reg <> '') THEN DO:
        {utp/ut-liter.i tributaá∆o_regular *}
        {method/svc/errors/inserr.i
                        &ErrorNumber="58083"
                        &ErrorType="EMS"
                        &ErrorSubType="WARNNING"
                        &ErrorParameters="TRIM(RETURN-VALUE)"}                  
 
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
PROCEDURE validaCredPres:
    DEFINE INPUT PARAM  pCredPres     AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAM  pcClassTrib  LIKE RowObject.cod-cclass-trib  NO-UNDO.
    DEFINE INPUT PARAM  pIndTributo  LIKE  RowObject.ind-tributo  NO-UNDO.
    
    IF  pCredPres = NO
    AND CAN-FIND (FIRST relac-class-trib NO-LOCK
                  WHERE relac-class-trib.cod-cclass-trib = pcClassTrib
                    AND relac-class-trib.ind-tributo     = pIndTributo
                    AND relac-class-trib.cod-cred-pres <> '') THEN DO:
        {utp/ut-liter.i crÇdito_presumido *}
        {method/svc/errors/inserr.i
                        &ErrorNumber="58083"
                        &ErrorType="EMS"
                        &ErrorSubType="WARNNING"
                        &ErrorParameters="TRIM(RETURN-VALUE)"}                  
 
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



