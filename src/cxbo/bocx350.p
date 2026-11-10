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
{include/i-prgvrs.i BOCX350 2.00.00.003 } /*** "010003" 11/12/2023 10:13:26 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX350 MUT}
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
&GLOBAL-DEFINE DBOName BOCX350
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName reg-export-fabrican
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
{cxbo/bocx350.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE i-nr-re-ems  LIKE reg-export.nr-re-ems NO-UNDO.
DEFINE VARIABLE i-cdn-anexo  LIKE reg-export-anexo.cdn-anexo NO-UNDO.

DEFINE VARIABLE h-bocx347    AS HANDLE NO-UNDO.

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
         HEIGHT             = 19.67
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT VALID-HANDLE (h-bocx347) THEN
     RUN cxbo/bocx347.p PERSISTENT SET h-bocx347.
 
  IF AVAIL {&TableName} THEN DO:

     IF VALID-HANDLE (h-bocx347) THEN
        RUN atualizaUltAlteracao IN h-bocx347 (INPUT {&TableName}.nr-re-ems).

  end. 
              
  IF VALID-HANDLE (h-bocx347) THEN
     DELETE PROCEDURE h-bocx347.

  ASSIGN h-bocx347 = ?.
               
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF AVAIL rowobject THEN DO:

     IF NOT VALID-HANDLE (h-bocx347) THEN
        RUN cxbo/bocx347.p PERSISTENT SET h-bocx347.

     IF VALID-HANDLE (h-bocx347) THEN
        RUN atualizaUltAlteracao IN h-bocx347 (INPUT rowobject.nr-re-ems).

     IF VALID-HANDLE (h-bocx347) THEN
        DELETE PROCEDURE h-bocx347.

     ASSIGN h-bocx347 = ?.

  END.
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT VALID-HANDLE (h-bocx347) THEN
     RUN cxbo/bocx347.p PERSISTENT SET h-bocx347.
 
  IF AVAIL {&TableName} THEN DO:

     IF VALID-HANDLE (h-bocx347) THEN
        RUN atualizaUltAlteracao IN h-bocx347 (INPUT {&TableName}.nr-re-ems).

  end. 
              
  IF VALID-HANDLE (h-bocx347) THEN
     DELETE PROCEDURE h-bocx347.

  ASSIGN h-bocx347 = ?.
               
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
  
  IF AVAIL rowobject THEN DO:

     IF NOT VALID-HANDLE (h-bocx347) THEN
        RUN cxbo/bocx347.p PERSISTENT SET h-bocx347.

     IF VALID-HANDLE (h-bocx347) THEN
        RUN atualizaUltAlteracao IN h-bocx347 (INPUT rowobject.nr-re-ems).

     IF VALID-HANDLE (h-bocx347) THEN
        DELETE PROCEDURE h-bocx347.

     ASSIGN h-bocx347 = ?.

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
        WHEN "class-fiscal":U THEN ASSIGN pFieldValue = RowObject.class-fiscal.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-uf-fab":U THEN ASSIGN pFieldValue = RowObject.cod-uf-fab.
        WHEN "nr-ato-consessorio":U THEN ASSIGN pFieldValue = RowObject.nr-ato-consessorio.
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
        WHEN "qtd-unid-ncm":U THEN ASSIGN pFieldValue = RowObject.qtd-unid-ncm.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-mercad":U THEN ASSIGN pFieldValue = RowObject.val-mercad.
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
        WHEN "cdn-anexo":U THEN ASSIGN pFieldValue = RowObject.cdn-anexo.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "nr-re-ems":U THEN ASSIGN pFieldValue = RowObject.nr-re-ems.
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
  Purpose:     Retorna valores dos campos do °ndice rgxprtfb-id
  Parameters:  
               retorna valor do campo nr-re-ems
               retorna valor do campo cdn-anexo
               retorna valor do campo cod-emitente
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-re-ems LIKE reg-export-fabrican.nr-re-ems NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-anexo LIKE reg-export-fabrican.cdn-anexo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE reg-export-fabrican.cod-emitente NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-re-ems = RowObject.nr-re-ems
           pcdn-anexo = RowObject.cdn-anexo
           pcod-emitente = RowObject.cod-emitente.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQuantTotFabrics DBOProgram 
PROCEDURE getQuantTotFabrics:
/*------------------------------------------------------------------------------
  Purpose: Retorna a quantidade total dos fabricantes para o anexo 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
       DEFINE INPUT  PARAMETER p-nr-re-ems AS INTEGER NO-UNDO.
       DEFINE INPUT  PARAMETER p-cdn-anexo AS INTEGER NO-UNDO.
       DEFINE OUTPUT PARAMETER p-qtd-anexo AS INTEGER NO-UNDO.
       
       ASSIGN p-qtd-anexo = 0.

       FOR EACH bf{&TableName} NO-LOCK 
           WHERE bf{&TableName}.nr-re-ems = p-nr-re-ems
             AND bf{&TableName}.cdn-anexo = p-cdn-anexo:
           ASSIGN p-qtd-anexo = p-qtd-anexo +  bf{&TableName}.qtd-unid-ncm.
       END.
   
       RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQuantFabric DBOProgram 
PROCEDURE getQuantFabric :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

       DEFINE OUTPUT PARAMETER pCont AS INTEGER NO-UNDO.
       
       ASSIGN pCont = 0.

       FOR EACH bf{&TableName} NO-LOCK 
           WHERE bf{&TableName}.nr-re-ems = rowobject.nr-re-ems
             AND bf{&TableName}.cdn-anexo = rowobject.cdn-anexo:
           ASSIGN pCont = pCont + 1.
       END.
   
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
  Purpose:     Reposiciona registro com base no °ndice rgxprtfb-id
  Parameters:  
               recebe valor do campo nr-re-ems
               recebe valor do campo cdn-anexo
               recebe valor do campo cod-emitente
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-re-ems LIKE reg-export-fabrican.nr-re-ems NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-anexo LIKE reg-export-fabrican.cdn-anexo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE reg-export-fabrican.cod-emitente NO-UNDO.

    FIND FIRST bfreg-export-fabrican WHERE 
        bfreg-export-fabrican.nr-re-ems = pnr-re-ems AND 
        bfreg-export-fabrican.cdn-anexo = pcdn-anexo AND 
        bfreg-export-fabrican.cod-emitente = pcod-emitente NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfreg-export-fabrican THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfreg-export-fabrican)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValMercTotFabrics DBOProgram 
PROCEDURE getValMercTotFabrics:
/*------------------------------------------------------------------------------
  Purpose: Retorna o valor da mercadoria total dos fabricantes para o anexo 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
       DEFINE INPUT  PARAMETER p-nr-re-ems        AS INTEGER NO-UNDO.
       DEFINE INPUT  PARAMETER p-cdn-anexo        AS INTEGER NO-UNDO.
       DEFINE OUTPUT PARAMETER p-val-mercad-anexo AS DECIMAL NO-UNDO.
       
       ASSIGN p-val-mercad-anexo = 0.

       FOR EACH bf{&TableName} NO-LOCK 
           WHERE bf{&TableName}.nr-re-ems = p-nr-re-ems
             AND bf{&TableName}.cdn-anexo = p-cdn-anexo:
           ASSIGN p-val-mercad-anexo = p-val-mercad-anexo +  bf{&TableName}.val-mercad.
       END.
   
       RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToRegExportAnexo DBOProgram 
PROCEDURE linkToRegExportAnexo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


   DEFINE INPUT PARAMETER P-HANDLE AS HANDLE NO-UNDO.

   RUN getKey IN P-HANDLE (OUTPUT i-nr-re-ems, OUTPUT i-cdn-anexo ).

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFabric DBOProgram 
PROCEDURE openQueryFabric :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME} for each {&TableName} NO-LOCK
                                WHERE {&TableName}.nr-re-ems = i-nr-re-ems 
                                  AND {&TableName}.cdn-anexo = i-cdn-anexo INDEXED-REPOSITION.

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

    OPEN QUERY {&QUERYNAME} for each {&TableName} NO-LOCK INDEXED-REPOSITION.

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
    DEFINE VAR i-cont AS INTEGER NO-UNDO.

    
    IF pType = "Create" THEN DO:

       FIND FIRST bf{&TableName} NO-LOCK 
            WHERE bf{&TableName}.nr-re-ems = rowobject.nr-re-ems
              AND bf{&TableName}.cdn-anexo = rowobject.cdn-anexo
              AND bf{&TableName}.cod-emitente = rowobject.cod-emitente NO-ERROR.
       IF AVAIL bf{&TableName} THEN DO:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-fabricante AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Fabricante" *}
           ASSIGN c-lbl-liter-fabricante = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                  &ErrorNumber="8"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="c-lbl-liter-fabricante"}
       END.

       ASSIGN i-cont = 0.

       FOR EACH bf{&TableName} NO-LOCK 
           WHERE bf{&TableName}.nr-re-ems = rowobject.nr-re-ems
             AND bf{&TableName}.cdn-anexo = rowobject.cdn-anexo:
           ASSIGN i-cont = i-cont + 1.
       END.

       IF i-cont = 10 THEN DO:
           {method/svc/errors/inserr.i
                  &ErrorNumber="30556"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="''"}
       END.


    END.

    IF pType = "Create" OR pType = "Update" THEN DO:

        FOR FIRST emitente FIELDS(cod-emitente identific)
            WHERE emitente.cod-emitente = RowObject.cod-emitente NO-LOCK:
            IF  emitente.identific = 1 THEN DO:
                {method/svc/errors/inserr.i
                       &ErrorNumber="31840"
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR"
                       &ErrorParameters="''"}
            END.
        END.

        FIND FIRST unid-feder NO-LOCK 
              WHERE unid-feder.pais = "Brasil" 
               AND unid-feder.estado = rowobject.cod-uf-fab NO-ERROR.
        IF NOT AVAIL unid-feder THEN DO:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-estado AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Estado" *}
           ASSIGN c-lbl-liter-estado = TRIM(RETURN-VALUE).
           DEFINE VARIABLE c-lbl-liter-brasil AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Brasil" *}
           ASSIGN c-lbl-liter-brasil = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                  &ErrorNumber="2"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="c-lbl-liter-estado + '~~~~' + c-lbl-liter-brasil"}
        END.

        IF rowobject.qtd-unid-ncm <= 0 THEN DO:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-quantidade AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Quantidade" *}
           ASSIGN c-lbl-liter-quantidade = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                  &ErrorNumber="30555"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="c-lbl-liter-quantidade"}
        END.

        IF rowobject.qtd-unid-ncm = ? THEN DO:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-quantidade-2 AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Quantidade" *}
           ASSIGN c-lbl-liter-quantidade-2 = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                  &ErrorNumber="25379"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="c-lbl-liter-quantidade-2"}
        END.

        IF rowobject.val-mercad <= 0 THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-valor-mercadoria AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Valor_Mercadoria" *}
            ASSIGN c-lbl-liter-valor-mercadoria = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                   &ErrorNumber="30555"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters="c-lbl-liter-valor-mercadoria"}
        END.


        IF rowobject.val-mercad = ? THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-valor-mercadoria-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Valor_Mercadoria" *}
            ASSIGN c-lbl-liter-valor-mercadoria-2 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                   &ErrorNumber="25379"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters="c-lbl-liter-valor-mercadoria-2"}
        END.

    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

