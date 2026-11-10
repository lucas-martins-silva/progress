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
{include/i-prgvrs.i BOIN751 2.00.00.002 } /*** "010002" 11/12/2023 10:13:30 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN751 MUT}
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
&GLOBAL-DEFINE DBOName BOIN751
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ncm-pos
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
{inbo/boin751.i RowObject}
{cxbo/bocx370.i tt-ncm-pos-traduz}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* possui variavel c-seg-usuario */
{utp/ut-glob.i}

DEFINE VARIABLE c-cod-cap-aux LIKE ncm-pos.cod-cap NO-UNDO.
DEFINE VARIABLE c-cod-pos-aux LIKE ncm-pos.cod-pos NO-UNDO.
DEFINE VARIABLE c-cod-cap-ini LIKE ncm-pos.cod-cap NO-UNDO.
DEFINE VARIABLE c-cod-cap-fim LIKE ncm-pos.cod-cap NO-UNDO.
DEFINE VARIABLE c-cod-pos-ini LIKE ncm-pos.cod-pos NO-UNDO.
DEFINE VARIABLE c-cod-pos-fim LIKE ncm-pos.cod-pos NO-UNDO.
DEFINE VARIABLE c-desc-tudo AS CHARACTER   NO-UNDO.

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
         HEIGHT             = 12.79
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH ncm-pos-traduz EXCLUSIVE-LOCK
        WHERE ncm-pos-traduz.cod-cap = c-cod-cap-aux
          AND ncm-pos-traduz.cod-pos = c-cod-pos-aux:
        DELETE ncm-pos-traduz.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaCampos DBOProgram 
PROCEDURE atualizaCampos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN RowObject.dat-ult-alter       = TODAY
           RowObject.hra-ult-alter       = STRING(TIME,"HH:MM:SS")
           RowObject.cod-usuar-ult-alter = c-seg-usuario.
                                                              
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN atualizaCampos.              
              
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN c-cod-cap-aux = RowObject.cod-cap
           c-cod-pos-aux = RowObject.cod-pos.
                  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF RowObject.dsl-pos <> {&TableName}.dsl-pos THEN 
        RUN atualizaCampos.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copiaPosTraduz DBOProgram 
PROCEDURE copiaPosTraduz :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAM p-cod-cap LIKE ncm-pos.cod-cap NO-UNDO.
    DEFINE INPUT PARAM p-cod-pos LIKE ncm-pos.cod-pos NO-UNDO.

    EMPTY TEMP-TABLE tt-ncm-pos-traduz.

    FIND FIRST bf{&TableName} NO-LOCK
         WHERE bf{&TableName}.cod-cap = RowObject.cod-cap 
           AND bf{&TableName}.cod-pos = RowObject.cod-pos NO-ERROR.

    FOR EACH ncm-pos-traduz NO-LOCK
        WHERE ncm-pos-traduz.cod-cap = p-cod-cap
          AND ncm-pos-traduz.cod-pos = p-cod-pos:

        CREATE tt-ncm-pos-traduz.
        BUFFER-COPY ncm-pos-traduz TO tt-ncm-pos-traduz.
        ASSIGN tt-ncm-pos-traduz.cod-cap = bf{&TableName}.cod-cap
               tt-ncm-pos-traduz.cod-pos = bf{&TableName}.cod-pos.
    END.

    FOR EACH tt-ncm-pos-traduz NO-LOCK:
        CREATE ncm-pos-traduz.
        BUFFER-COPY tt-ncm-pos-traduz TO ncm-pos-traduz.
        DELETE tt-ncm-pos-traduz.
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
        WHEN "cod-cap":U THEN ASSIGN pFieldValue = RowObject.cod-cap.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-pos":U THEN ASSIGN pFieldValue = RowObject.cod-pos.
        WHEN "cod-usuar-ult-alter":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-ult-alter.
        WHEN "dsl-pos":U THEN ASSIGN pFieldValue = RowObject.dsl-pos.
        WHEN "hra-ult-alter":U THEN ASSIGN pFieldValue = RowObject.hra-ult-alter.
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
        WHEN "dat-ult-alter":U THEN ASSIGN pFieldValue = RowObject.dat-ult-alter.
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
  Purpose:     Retorna valores dos campos do °ndice ncmpos-id
  Parameters:  
               retorna valor do campo cod-cap
               retorna valor do campo cod-pos
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-cap LIKE ncm-pos.cod-cap NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-pos LIKE ncm-pos.cod-pos NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-cap = RowObject.cod-cap
           pcod-pos = RowObject.cod-pos.

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
  Purpose:     Reposiciona registro com base no °ndice ncmpos-id
  Parameters:  
               recebe valor do campo cod-cap
               recebe valor do campo cod-pos
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-cap LIKE ncm-pos.cod-cap NO-UNDO.
    DEFINE INPUT PARAMETER pcod-pos LIKE ncm-pos.cod-pos NO-UNDO.

    FIND FIRST bfncm-pos WHERE 
        bfncm-pos.cod-cap = pcod-cap AND 
        bfncm-pos.cod-pos = pcod-pos NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfncm-pos THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfncm-pos)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCodigo DBOProgram 
PROCEDURE openQueryByCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
                               WHERE {&TableName}.cod-cap >= c-cod-cap-ini
                                 AND {&TableName}.cod-cap <= c-cod-cap-fim 
                                 AND {&TableName}.cod-pos >= c-cod-pos-ini 
                                 AND {&TableName}.cod-pos <= c-cod-pos-fim INDEXED-REPOSITION.           
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByCodigo DBOProgram 
PROCEDURE setConstraintByCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-cod-cap-ini LIKE ncm-pos.cod-cap NO-UNDO.
    DEF INPUT PARAM p-cod-cap-fim LIKE ncm-pos.cod-cap NO-UNDO.
    DEF INPUT PARAM p-cod-pos-ini LIKE ncm-pos.cod-pos NO-UNDO.
    DEF INPUT PARAM p-cod-pos-fim LIKE ncm-pos.cod-pos NO-UNDO.

    ASSIGN c-cod-cap-ini =  p-cod-cap-ini
           c-cod-cap-fim =  p-cod-cap-fim
           c-cod-pos-ini =  p-cod-pos-ini
           c-cod-pos-fim =  p-cod-pos-fim.
                        
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
    
    IF pType = "CREATE" THEN DO:
        IF CAN-FIND(FIRST bf{&TableName}
                        WHERE bf{&TableName}.cod-cap = RowObject.cod-cap
                          AND bf{&TableName}.cod-pos = RowObject.cod-pos) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-capitulo-informados AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "cap°tulo_informado(s)" *}
            ASSIGN c-lbl-liter-capitulo-informados = TRIM(RETURN-VALUE).
            {utp/ut-table.i mgind ncm-pos 1} /* Busca o label da tabela */
            ASSIGN c-desc-tudo = TRIM(RETURN-VALUE) + '~~' + c-lbl-liter-capitulo-informados.
            {method/svc/errors/inserr.i
                               &ErrorNumber="428"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR" 
                               &ErrorParameters="c-desc-tudo"}
        END.
        IF RowObject.cod-cap = "" THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-codigo-do-capitulo AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "C¢digo_do_Cap°tulo" *}
            ASSIGN c-lbl-liter-codigo-do-capitulo = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                                &ErrorNumber="265"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-codigo-do-capitulo"}
        END.
        ELSE DO:
            IF NOT CAN-FIND(FIRST ncm-cap WHERE ncm-cap.cod-cap = RowObject.cod-cap NO-LOCK) THEN DO:
                /* Inicio -- Projeto Internacional */
                {utp/ut-table.i mgind ncm-cap 1} /* Busca o label da tabela */
                {method/svc/errors/inserr.i
                                    &ErrorNumber="47"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters=TRIM(RETURN-VALUE)}
            END.
        END.
        IF RowObject.cod-pos = "" THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-codigo-da-posicao-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "C¢digo_da_Posiá∆o" *}
            ASSIGN c-lbl-liter-codigo-da-posicao-2 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                                &ErrorNumber="265"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-codigo-da-posicao-2"}
        END.
    END.
    IF pType = "CREATE" OR pType = "UPDATE" THEN DO:
        IF RowObject.dsl-pos = "" THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-descricao-da-posicao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Descriá∆o_da_Posiá∆o" *}
            ASSIGN c-lbl-liter-descricao-da-posicao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                                &ErrorNumber="265"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-descricao-da-posicao"}
        END.
    END.
    IF pType = "DELETE" THEN DO:
        IF CAN-FIND(FIRST ncm-subpos
                        WHERE ncm-subpos.cod-cap = RowObject.cod-cap
                          AND ncm-subpos.cod-pos = RowObject.cod-pos) 
            OR CAN-FIND(FIRST ncm-item 
                        WHERE ncm-item.cod-cap = RowObject.cod-cap
                          AND ncm-item.cod-pos = RowObject.cod-pos) THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgind ncm-pos 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i
                                &ErrorNumber="3"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters=TRIM(RETURN-VALUE)}
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
