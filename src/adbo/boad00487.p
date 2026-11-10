&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T---------------------------------------------------------------------------
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
&GLOBAL-DEFINE DBOName BOAD00487
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName proces-esoc
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
{adbo/boad00487.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-cod-process-judic-ini LIKE proces-esoc.cod-process-judic NO-UNDO.
DEFINE VARIABLE c-cod-process-judic-fim LIKE proces-esoc.cod-process-judic NO-UNDO.
DEFINE VARIABLE c-cod-empresa-ini       LIKE proces-esoc.ep-codigo         NO-UNDO.
DEFINE VARIABLE c-cod-empresa-fim       LIKE proces-esoc.ep-codigo         NO-UNDO.

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
         HEIGHT             = 11.71
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
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-process-judic":U THEN ASSIGN pFieldValue = RowObject.cod-process-judic.
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
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
        WHEN "dat-fim-valid":U THEN ASSIGN pFieldValue = RowObject.dat-fim-valid.
        WHEN "dat-inic-valid":U THEN ASSIGN pFieldValue = RowObject.dat-inic-valid.
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
        WHEN "idi-abrangen":U THEN ASSIGN pFieldValue = RowObject.idi-abrangen.
        WHEN "idi-proces":U THEN ASSIGN pFieldValue = RowObject.idi-proces.
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
  Purpose:     Retorna valores dos campos do °ndice prcssc_id
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-process-judic
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE proces-esoc.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-process-judic LIKE proces-esoc.cod-process-judic NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-process-judic = RowObject.cod-process-judic.

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
  Purpose:     Reposiciona registro com base no °ndice prcssc_id
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-process-judic
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE proces-esoc.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-process-judic LIKE proces-esoc.cod-process-judic NO-UNDO.

    FIND FIRST bfproces-esoc WHERE 
        bfproces-esoc.ep-codigo = pep-codigo AND 
        bfproces-esoc.cod-process-judic = pcod-process-judic NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproces-esoc THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproces-esoc)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoom DBOProgram 
PROCEDURE openQueryZoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-c-estabelec AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR rowObject.

    DEF BUFFER b-proces-esoc FOR proces-esoc.

    EMPTY TEMP-TABLE rowObject.

    FOR EACH b-proces-esoc NO-LOCK
        WHERE b-proces-esoc.cod-process-judic >= c-cod-process-judic-ini
          AND b-proces-esoc.cod-process-judic <= c-cod-process-judic-fim
          AND (b-proces-esoc.dat-inic-valid   <= TODAY
          AND  b-proces-esoc.dat-fim-valid    >= TODAY):

        FIND FIRST estab-proces-esoc
             WHERE estab-proces-esoc.cod-process-judic = b-proces-esoc.cod-process-judic NO-LOCK NO-ERROR.
        IF AVAIL estab-proces-esoc THEN
            IF NOT CAN-FIND(FIRST estab-proces-esoc
                            WHERE estab-proces-esoc.cod-process-judic = b-proces-esoc.cod-process-judic
                              AND estab-proces-esoc.cod-estabel = p-c-estabelec) THEN NEXT.

        CREATE rowObject.
        BUFFER-COPY b-proces-esoc TO rowObject.

        CASE b-proces-esoc.idi-proces:
            WHEN 1 THEN
                ASSIGN rowObject.cod-livre-1 = "Administrativo".
            WHEN 2 THEN
                ASSIGN rowObject.cod-livre-1 = "Judicial".
        END CASE.
    END.

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
  
 OPEN QUERY {&QueryName} FOR EACH proces-esoc NO-LOCK 
       .

 RETURN "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryByEmpresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
 OPEN QUERY {&QueryName} 
        FOR EACH  {&TableName} NO-LOCK  
            WHERE ({&TableName}.ep-codigo >= c-cod-empresa-ini AND 
                   {&TableName}.ep-codigo <= c-cod-empresa-fim) .

 RETURN "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryByProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF c-cod-process-judic-ini = c-cod-process-judic-fim THEN

      OPEN QUERY {&QueryName} FOR EACH  proces-esoc NO-LOCK
           WHERE (proces-esoc.cod-process-judic = c-cod-process-judic-ini) BY proces-esoc.cod-process-judic. 

  ELSE 

      OPEN QUERY {&QueryName} FOR EACH proces-esoc NO-LOCK 
           WHERE (proces-esoc.cod-process-judic >= c-cod-process-judic-ini 
             AND proces-esoc.cod-process-judic <= c-cod-process-judic-fim) BY proces-esoc.cod-process-judic.

 RETURN "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByEmpresa DBOProgram 
PROCEDURE setConstraintByEmpresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
    DEFINE INPUT PARAMETER p-ini-empresa LIKE proces-esoc.ep-codigo.
    DEFINE INPUT PARAMETER p-fim-empresa LIKE proces-esoc.ep-codigo.

    assign c-cod-empresa-ini = p-ini-empresa
           c-cod-empresa-fim = p-fim-empresa.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByProcesso DBOProgram 
PROCEDURE setConstraintByProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
    DEFINE INPUT PARAMETER p-ini-processo LIKE proces-esoc.cod-process-judic.
    DEFINE INPUT PARAMETER p-fim-processo LIKE proces-esoc.cod-process-judic.

    assign c-cod-process-judic-ini = p-ini-processo
           c-cod-process-judic-fim = p-fim-processo.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodProcessJudic DBOProgram 
PROCEDURE setConstraintCodProcessJudic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-cod-process-judic-ini LIKE proces-esoc.cod-process-judic NO-UNDO.
    DEF INPUT PARAM p-cod-process-judic-fim LIKE proces-esoc.cod-process-judic NO-UNDO.
    
    ASSIGN c-cod-process-judic-ini = p-cod-process-judic-ini
           c-cod-process-judic-fim = p-cod-process-judic-fim.
    
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

    DEFINE VARIABLE c-texto1 AS CHAR.
    DEFINE VARIABLE c-texto2 AS CHAR.
    
      IF pType = "Create" THEN DO:

          IF CAN-FIND(proces-esoc WHERE proces-esoc.ep-codigo       = RowObject.ep-codigo
                                  AND proces-esoc.cod-process-judic = RowObject.cod-process-judic) THEN DO:
                
               {method/svc/errors/inserr.i
                     &ErrorNumber="1"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"} 
                                       
          END.

          IF NOT CAN-FIND(empresa WHERE empresa.ep-codigo = RowObject.ep-codigo) THEN DO:

              {method/svc/errors/inserr.i
                     &ErrorNumber="27502"                                          
                     &ErrorType="EMS"                               
                     &ErrorSubType="ERROR"}

          END.

          IF RowObject.cod-process-judic = "" OR RowObject.cod-process-judic = "0" THEN DO:

              {method/svc/errors/inserr.i
                     &ErrorNumber="52569"                                          
                     &ErrorType="EMS"                               
                     &ErrorSubType="ERROR"} 

          END.

          IF RowObject.dat-inic-valid > RowObject.dat-fim-valid THEN DO:      
          
              {method/svc/errors/inserr.i                                     
                     &ErrorNumber="5360"                                
                     &ErrorType="EMS"                             
                     &ErrorSubType="ERROR"}                
                     
          END.
      END.

      IF pType = "Update" THEN DO:
          IF RowObject.dat-inic-valid > RowObject.dat-fim-valid THEN DO:   

              {method/svc/errors/inserr.i         
                     &ErrorNumber="5360"   
                     &ErrorType="EMS"    
                     &ErrorSubType="ERROR"}                                                                                                   
          END.
      END.

      IF pType = "Delete" THEN DO:  

          FOR EACH estabelec WHERE estabelec.ep-codigo = RowObject.ep-codigo NO-LOCK :                                                                             
               IF CAN-FIND(FIRST nota-fisc-social WHERE nota-fisc-social.nr-proc-jud = RowObject.cod-process-judic
                                                    AND nota-fisc-social.cod-estabel = estabelec.cod-estabel)THEN DO:    

                     {utp/ut-table.i movadm nota-fisc-social 1}                     
                     ASSIGN c-texto2 = RETURN-VALUE.                            
                     {utp/ut-liter.i "O_processo_possui_v°nculo_com_a_tabela_"}   
                     ASSIGN c-texto1 = RETURN-VALUE + c-texto2 + "!".             
                     {method/svc/errors/inserr.i                                  
                            &ErrorNumber="44029"                                  
                            &ErrorType="EMS"                                      
                            &ErrorSubType="ERROR"                                 
                            &ErrorParameters="c-texto1"}                          
                                                                                                
               END. 
           END. 

           IF CAN-FIND(FIRST docum-est-esoc WHERE docum-est-esoc.nr-proc-jud = RowObject.cod-process-judic
                                              AND docum-est-esoc.ep-codigo   = RowObject.ep-codigo) THEN DO: 
                   
                     {utp/ut-table.i movadm docum-est-esoc 1}
                     ASSIGN c-texto2 = RETURN-VALUE.       
                     {utp/ut-liter.i "O_processo_possui_v°nculo_com_a_tabela_"}      
                     ASSIGN c-texto1 = RETURN-VALUE + c-texto2 + "!".                      
                     {method/svc/errors/inserr.i                                       
                            &ErrorNumber="44029"                                       
                            &ErrorType="EMS"                                           
                            &ErrorSubType="ERROR"                                    
                            &ErrorParameters="c-texto1"}   
                                                                                                                                                                    
           END.                                                                                                                                                                                
       END.                                                                     

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

