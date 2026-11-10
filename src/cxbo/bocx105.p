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
/*******************************************************************************/
{include/i-prgvrs.i BOCX105 2.00.00.002 } /*** "010002" 27/11/2023 16:32:28  ***/
/* ***************************  Definitions  **************************** */

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX105
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName form-desp-imp
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
{cxbo/bocx105.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{utp/ut-glob.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/*DEFINE VARIABLE r-rowid AS ROWID NO-UNDO.*/

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
         HEIGHT             = 13.58
         WIDTH              = 49.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE autoNumber DBOProgram 
PROCEDURE autoNumber :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para retornar a pr¢xima sequància da tabela
  Parameters:  p-auto-num -  retorna a sequància da tabela
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-auto-num AS INTEGER NO-UNDO.
        
    FIND LAST bf{&TableName} 
        WHERE bf{&TableName}.cod-desp = rowObject.cod-desp NO-LOCK NO-ERROR.
    IF AVAIL bf{&TableName} THEN
        assign p-auto-num = bf{&TableName}.sequencia + 1.
    ELSE
        ASSIGN p-auto-num = 1.

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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
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
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "fat-ponder":U THEN ASSIGN pFieldValue = RowObject.fat-ponder.
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
        WHEN "cod-desp":U THEN ASSIGN pFieldValue = RowObject.cod-desp.
        WHEN "cod-desp-form[1]":U THEN ASSIGN pFieldValue = RowObject.cod-desp-form[1].
        WHEN "cod-desp-form[2]":U THEN ASSIGN pFieldValue = RowObject.cod-desp-form[2].
        WHEN "cod-desp-form[3]":U THEN ASSIGN pFieldValue = RowObject.cod-desp-form[3].
        WHEN "cod-desp-form[4]":U THEN ASSIGN pFieldValue = RowObject.cod-desp-form[4].
        WHEN "cod-desp-form[5]":U THEN ASSIGN pFieldValue = RowObject.cod-desp-form[5].
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo cod-desp
               retorna valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-desp LIKE form-desp-imp.cod-desp NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE form-desp-imp.sequencia NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-desp = RowObject.cod-desp
           psequencia = RowObject.sequencia.

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
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo cod-desp
               recebe valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-desp LIKE form-desp-imp.cod-desp NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE form-desp-imp.sequencia NO-UNDO.

    FIND FIRST bfform-desp-imp WHERE 
        bfform-desp-imp.cod-desp = pcod-desp AND 
        bfform-desp-imp.sequencia = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfform-desp-imp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfform-desp-imp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDespImp DBOProgram 
PROCEDURE openQueryDespImp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY qr{&TableName} FOR EACH {&TableName} 
        WHERE OF desp-imp NO-LOCK 
        BY {&TableName}.cod-desp.

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
    OPEN QUERY qr{&TableName} FOR EACH {&TableName} NO-LOCK.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint DBOProgram 
PROCEDURE setConstraint :
/*------------------------------------------------------------------------------
  Purpose:     ParÉmetros para filtrar a QueryDespImp
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER r-chave AS ROWID NO-UNDO.
    FIND desp-imp NO-LOCK 
        WHERE ROWID(desp-imp) = r-chave NO-ERROR.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCodigo DBOProgram 
PROCEDURE validateCodigo :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para validar os c¢digos das formulas de despesa.
  Parameters:  c-cod-desp-form-01 - c¢digo da f¢mula da despesa
               c-cod-desp-form-02 - c¢digo da f¢mula da despesa
               c-cod-desp-form-03 - c¢digo da f¢mula da despesa
               c-cod-desp-form-04 - c¢digo da f¢mula da despesa
               c-cod-desp-form-05 - c¢digo da f¢mula da despesa
  Notes:       
------------------------------------------------------------------------------*/
    def input-output parameter c-cod-desp-form-01          as char no-undo.
    def input-output parameter c-cod-desp-form-02          as char no-undo.
    def input-output parameter c-cod-desp-form-03          as char no-undo.
    def input-output parameter c-cod-desp-form-04          as char no-undo.
    def input-output parameter c-cod-desp-form-05          as char no-undo.    
    def var i-teste1 as integer no-undo.
    def var i-teste2 as integer no-undo.
    def var i-teste3 as integer no-undo.
    def var i-teste4 as integer no-undo.
    def var i-teste5 as integer no-undo.

    EMPTY TEMP-TABLE RowErrors.
     
    assign i-teste1 = int(c-cod-desp-form-01) no-error.
    if  error-status:error then do:
       assign c-cod-desp-form-01 = "0".
       /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
          pre-processador em chamada de includes */
       {utp/ut-field.i mgcex form-desp-imp fat-ponder 1}
       /******************************************/
       {method/svc/errors/inserr.i &ErrorNumber="16963"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters=" return-value "}        
    end.

    assign i-teste2 = int(c-cod-desp-form-02) no-error.
    if  error-status:error then do:
       assign c-cod-desp-form-02 = "0".
       /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
          pre-processador em chamada de includes */       
       {utp/ut-field.i mgcex form-desp-imp fat-ponder 1}
       /******************************************/
       {method/svc/errors/inserr.i &ErrorNumber="16963"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters=" return-value "}
    end.

    assign i-teste3 = int(c-cod-desp-form-03) no-error.
    if  error-status:error then do:
       assign c-cod-desp-form-03 = "0".
       /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
          pre-processador em chamada de includes */
       {utp/ut-field.i mgcex form-desp-imp fat-ponder 1}
       /******************************************/
       {method/svc/errors/inserr.i &ErrorNumber="16963"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters=" return-value "}
    end.

    assign i-teste4 = int(c-cod-desp-form-04) no-error.
    if  error-status:error then do:
       assign c-cod-desp-form-04 = "0".
       /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
          pre-processador em chamada de includes */
       {utp/ut-field.i mgcex form-desp-imp fat-ponder 1}
       /******************************************/
       {method/svc/errors/inserr.i &ErrorNumber="16963"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters=" return-value "}
    end.

    assign i-teste5 = int(c-cod-desp-form-05) no-error.
    if  error-status:error then do:
       assign c-cod-desp-form-05 = "0".
       /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
          pre-processador em chamada de includes */
       {utp/ut-field.i mgcex form-desp-imp fat-ponder 1}
       /******************************************/
       {method/svc/errors/inserr.i &ErrorNumber="16963"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters=" return-value "}
    end.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

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
                
        DEFINE VARIABLE i-auto-num  AS INTEGER NO-UNDO.
        DEFINE VARIABLE i-count     AS INTEGER INITIAL 1 NO-UNDO.

        run autoNumber(output i-auto-num).        
        assign rowObject.sequencia = i-auto-num.            
         
        /*ValidateFields - Inicio*/        
        if rowObject.cod-desp-form[01] = 0 and
           rowObject.cod-desp-form[02] = 0 and
           rowObject.cod-desp-form[03] = 0 and
           rowObject.cod-desp-form[04] = 0 and
           rowObject.cod-desp-form[05] = 0 then do:            
           /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
               pre-processador em chamada de includes */
            {utp/ut-field.i mgcex form-desp-imp cod-desp-form 1}
            /******************************************/
            {method/svc/errors/inserr.i &ErrorNumber="17324"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters=" return-value "} 
        end.
    
        do while i-count <= 5:
            if rowObject.cod-desp-form[i-count] <> 0 then do:
                if not can-find(desp-imp where desp-imp.cod-desp = rowObject.cod-desp-form[i-count]) then do:                    
                    /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
                       pre-processador em chamada de includes */
                    {utp/ut-table.i mgcex desp-imp 1}
                    /******************************************/
                    {method/svc/errors/inserr.i &ErrorNumber="47"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters=" return-value "}
                    ASSIGN i-count = 6.                                    
                end.
                if rowObject.cod-desp-form[i-count] = rowObject.cod-desp then do:                    
                    {method/svc/errors/inserr.i &ErrorNumber="17107"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters=" "}
                    ASSIGN i-count = 6.                                    
                end.
            end.            
            ASSIGN i-count = i-count + 1.
        end.
 
        if rowObject.fat-ponder = 0 then do:
            /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
               pre-processador em chamada de includes */
            {utp/ut-field.i mgcex form-desp-imp fat-ponder 1}
            /******************************************/
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=" return-value "}            
        end.    
        
        /*ValidateFields - fim*/
        
        if can-find(first form-desp-imp where
                          form-desp-imp.cod-desp  = rowObject.cod-desp and
                          form-desp-imp.sequencia = rowObject.sequencia) then do:                       
           /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
              pre-processador em chamada de includes */
           {utp/ut-table.i mgcex form-desp-imp 1}
           /******************************************/ 
           {method/svc/errors/inserr.i &ErrorNumber="8"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters=" return-value "}
        end.        
    END.


    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

