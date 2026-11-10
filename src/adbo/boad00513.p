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

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOAD00513
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName certif-item
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
{adbo/boad00513.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE TEMP-TABLE tt-wt-it-docto NO-UNDO LIKE wt-it-docto
       field r-rowid as rowid.





DEFINE VARIABLE i-cod-emitente  AS INTEGER NO-UNDO.
DEFINE VARIABLE i-tp-codigo     AS INTEGER NO-UNDO.
DEFINE VARIABLE i-cod-transp    AS INTEGER NO-UNDO.
DEFINE VARIABLE de-cdd-certific AS DECIMAL NO-UNDO.
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
        WHEN "cod-certific":U THEN ASSIGN pFieldValue = RowObject.cod-certific.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
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
        WHEN "dat-fim-certific":U THEN ASSIGN pFieldValue = RowObject.dat-fim-certific.
        WHEN "dat-inic-certific":U THEN ASSIGN pFieldValue = RowObject.dat-inic-certific.
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
        WHEN "cdd-certific":U THEN ASSIGN pFieldValue = RowObject.cdd-certific.
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
        WHEN "cdn-tip-cod":U THEN ASSIGN pFieldValue = RowObject.cdn-tip-cod.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
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
  Purpose:     Retorna valores dos campos do °ndice crtftm_id
  Parameters:  
               retorna valor do campo cdd-certific
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdd-certific LIKE certif-item.cdd-certific NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdd-certific = RowObject.cdd-certific.

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
  Purpose:     Reposiciona registro com base no °ndice crtftm_id
  Parameters:  
               recebe valor do campo cdd-certific
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdd-certific LIKE certif-item.cdd-certific NO-UNDO.

    FIND FIRST bfcertif-item WHERE 
        bfcertif-item.cdd-certific = pcdd-certific NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcertif-item THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcertif-item)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCertificEmit DBOProgram 
PROCEDURE openQueryByCertificEmit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE
                                     {&tablename}.cod-emitente = i-cod-emitente AND
                                     {&tablename}.cdn-tip-cod  = i-tp-codigo INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByCertificEmit DBOProgram 
PROCEDURE setConstraintByCertificEmit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-cod-emitente LIKE certif-item.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER p-tp-codigo    LIKE certif-item.cdn-tip-cod    NO-UNDO.
                                                                   
    ASSIGN i-cod-emitente = p-cod-emitente
           i-tp-codigo    = p-tp-codigo.  

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByCertificTransp DBOProgram 
PROCEDURE openQueryByCertifTransp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK WHERE
                                     {&tablename}.cod-transp  = i-cod-transp AND
                                     {&tablename}.cdn-tip-cod = i-tp-codigo INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByCertificTransp DBOProgram 
PROCEDURE setConstraintByCertifTransp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-cod-transp LIKE certif-item.cod-transp NO-UNDO.
    DEFINE INPUT PARAMETER p-tp-codigo  LIKE certif-item.cdn-tip-cod  NO-UNDO.
                                                                   
    ASSIGN i-cod-transp = p-cod-transp
           i-tp-codigo  = p-tp-codigo.  

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidaCertifItem DBOProgram 
PROCEDURE ValidaCertifItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-cod-emitente    LIKE wt-docto.cod-emitente       NO-UNDO.
    DEFINE INPUT  PARAMETER p-dat-emis-nota   LIKE wt-docto.dt-emis-nota       NO-UNDO.
    DEFINE INPUT  PARAMETER p-cdd-embarq      LIKE wt-docto.cdd-embarq         NO-UNDO.
    DEFINE INPUT  PARAMETER p-nome-transp     LIKE wt-docto.nome-transp        NO-UNDO.
    DEFINE INPUT  PARAMETER p-it-codigo       LIKE wt-it-docto.it-codigo       NO-UNDO.
    DEFINE INPUT  PARAMETER p-seq-wt-it-docto LIKE wt-it-docto.seq-wt-it-docto NO-UNDO. 
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR RowErrors.

    FIND FIRST para-ped NO-LOCK NO-ERROR.

    find first emitente                                                                                                                                       
         where emitente.cod-emitente   = p-cod-emitente no-lock no-error.

    if avail emitente and                                                                                                                                     
       emitente.natureza <> 3 then do:

        find first item-dist
             where item-dist.it-codigo = p-it-codigo
               and item-dist.log-possui-certif = yes no-lock no-error.
                                                                                                                                                                           
        if avail item-dist then DO:

            find first certif-item
                 where certif-item.it-codigo    = item-dist.it-codigo
                   and certif-item.cod-emitente = p-cod-emitente
                   and certif-item.cdn-tip-cod  = 1 no-lock no-error.

            if not avail certif-item then do:

                if substring(para-ped.char-2,9,1) = '2' THEN 

                    {method/svc/errors/inserr.i
                           &ErrorNumber="53976"
                           &ErrorType="EMS"
                           &ErrorParameters="p-it-codigo + '~~~~' + emitente.nome-abrev"}                                                      
                else if substring(para-ped.char-2,9,1) = '3' THEN
                    {method/svc/errors/inserr.i
                           &ErrorNumber="53975"
                           &ErrorType="EMS"
                           &ErrorParameters="p-it-codigo + '~~~~' + emitente.nome-abrev"}                                                                                                                                                         
            end.
            else do:
                find first certif
                     where certif.cod-emitente = emitente.cod-emitente
                       and certif.cdn-tip-cod  = 1 no-lock no-error.

                if not avail certif then do:                          
                                                                      
                    if substring(para-ped.char-2,9,1) = '2' then      
                       {method/svc/errors/inserr.i                    
                               &ErrorNumber="53978"                   
                               &ErrorType="EMS"                       
                               &ErrorParameters="emitente.nome-abrev"}
                    else if substring(para-ped.char-2,9,1) = '3' then 
                       {method/svc/errors/inserr.i                    
                               &ErrorNumber="53977"                   
                               &ErrorType="EMS"                       
                               &ErrorParameters="emitente.nome-abrev"}
                end.                                                  
                else do:                                              

                    if (p-dat-emis-nota < certif.dat-inic-certific OR
                        p-dat-emis-nota > certif.dat-fim-certific) then do:

                        if substring(para-ped.char-2,9,1) = '2' THEN
                            {method/svc/errors/inserr.i                     
                                   &ErrorNumber="53984"                      
                                   &ErrorType="EMS"                       
                                   &ErrorParameters="emitente.nome-abrev + '~~~~' + string(p-seq-wt-it-docto) + '0' + '~~~~' + p-it-codigo"}                                                                   
                        else if substring(para-ped.char-2,9,1) = '3' THEN
                            {method/svc/errors/inserr.i
                                   &ErrorNumber="53983"
                                   &ErrorType="EMS"
                                   &ErrorParameters="emitente.nome-abrev + '~~~~' + string(p-seq-wt-it-docto) + '0' + '~~~~' + p-it-codigo"}
                                                                                                                   
                    end.
                end. 
            end. 
                
            if  substring(para-ped.char-2,9,1) <> ""                                                          
            and substring(para-ped.char-2,9,1) <> "1" then do:

                find first transporte                                                                       
                     where transporte.nome-abrev = p-nome-transp no-lock no-error.
                                                                                                            
                if avail transporte then do:

                    find first certif-item                                                                   
                         where certif-item.cod-transp  = transporte.cod-transp                               
                           and certif-item.it-codigo   = p-it-codigo                               
                           and certif-item.cdn-tip-cod = 2 no-lock no-error.    
                                                                                             
                    if not avail certif-item then do:
                                                                                             
                        if substring(para-ped.char-2,9,1) = '2' THEN
                            {method/svc/errors/inserr.i                                                        
                                    &ErrorNumber="53990"                                                       
                                    &ErrorType="EMS"                                                           
                                    &ErrorParameters="p-it-codigo + '~~~~' + transporte.nome-abrev"}                                                                  
                        else if substring(para-ped.char-2,9,1) = '3' then                                     
                           {method/svc/errors/inserr.i                                                        
                                   &ErrorNumber="53989"                                                       
                                   &ErrorType="EMS"                                                           
                                   &ErrorParameters="p-it-codigo + '~~~~' + transporte.nome-abrev"}                                                                                                                   
                    end.
                    else do:
                   
                        find first certif
                             where certif.cod-transp  = transporte.cod-transp
                               and certif.cdn-tip-cod = 2 no-lock no-error.

                        if avail certif then do:   
                                                  
                            if (p-dat-emis-nota < certif.dat-inic-certific OR
                                p-dat-emis-nota > certif.dat-fim-certific) then do:
                        
                                if substring(para-ped.char-2,9,1) = '2' THEN
                                    {method/svc/errors/inserr.i                     
                                           &ErrorNumber="53988"                      
                                           &ErrorType="EMS"                       
                                           &ErrorParameters="transporte.nome-abrev + '~~~~' + string(p-seq-wt-it-docto) + '0' + '~~~~' + p-it-codigo"}                                                                   
                                else if substring(para-ped.char-2,9,1) = '3' THEN
                                    {method/svc/errors/inserr.i
                                           &ErrorNumber="53987"
                                           &ErrorType="EMS"
                                           &ErrorParameters="transporte.nome-abrev + '~~~~' + string(p-seq-wt-it-docto) + '0' + '~~~~' + p-it-codigo"}
                                                                                                                           
                            end.
                        end. 
                    end.
                end.
            end. 
        end.
    end.
                                                  
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


    IF pType = "Create":U THEN DO:                                                    
                                                                                      
      IF CAN-FIND(FIRST bf{&TableName}  WHERE                                        
                         bf{&TableName}.cod-emitente = RowObject.cod-emitente AND     
                         bf{&TableName}.cod-transp   = RowObject.cod-transp   AND     
                         bf{&TableName}.cdn-tip-cod  = RowObject.cdn-tip-cod  AND     
                         bf{&TableName}.cod-certific = RowObject.cod-certific AND     
                         bf{&TableName}.it-codigo    = RowObject.it-codigo)   THEN DO:
                                                                                      
            /* J† existe ocorrància do registro */                         
             
            {utp/ut-liter.i "Item_do_certificado" *} 
            {method/svc/errors/inserr.i &ErrorNumber="1"                              
                                        &ErrorType="EMS":U                            
                                        &ErrorSubType="ERROR":U                       
                                        &ErrorParameters="return-value"}      
       END.                                                                           
                     
    END.

    IF NOT CAN-FIND(FIRST ITEM WHERE ITEM.it-codigo = RowObject.it-codigo) THEN DO:

       /* N∆o existe Item */    
         {utp/ut-liter.i "Item_do_certificado" *}
         {method/svc/errors/inserr.i &ErrorNumber="166"                         
                                     &ErrorType="EMS":U                       
                                     &ErrorSubType="ERROR":U                  
                                     &ErrorParameters="return-value"} 

    END. 
         
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

