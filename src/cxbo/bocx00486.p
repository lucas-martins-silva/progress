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
{include/i-prgvrs.i BOCX00486 2.00.00.006 } /*** "010006" 09/02/2026 08:53:26 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX00486
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-fabrican-siscomex
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
{cxbo/BOCX00486.i RowObject}
{utp/ut-glob.i} 

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-item          LIKE item-fabrican-siscomex.cod-item NO-UNDO.
DEFINE VARIABLE c-lbl-help      AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE l-erro-caracter AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE c-cnpj          AS CHARACTER       FORMAT "x(19)":U  NO-UNDO.
DEFINE VARIABLE i-cont          AS INTEGER                           NO-UNDO.

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
         HEIGHT             = 10.21
         WIDTH              = 41.29.
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
        WHEN "cod-cnpj-cpf":U          THEN ASSIGN pFieldValue = RowObject.cod-cnpj-cpf.
        WHEN "cod-item":U              THEN ASSIGN pFieldValue = RowObject.cod-item.
        WHEN "cod-livre-1":U           THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U           THEN ASSIGN pFieldValue = RowObject.cod-livre-2.       
        WHEN "cod-pais-iso":U          THEN ASSIGN pFieldValue = RowObject.cod-pais-iso.
        WHEN "cod-trader":U           THEN ASSIGN pFieldValue = RowObject.cod-trader.
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
        WHEN "dat-refer":U   THEN ASSIGN pFieldValue = RowObject.dat-refer.
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
        WHEN "val-livre-1":U                THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U                THEN ASSIGN pFieldValue = RowObject.val-livre-2.
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
        WHEN "cdn-emitente":U THEN ASSIGN pFieldValue = RowObject.cdn-emitente.
        WHEN "idi-situacao":U THEN ASSIGN pFieldValue = RowObject.idi-situacao.
        WHEN "num-livre-1":U  THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U  THEN ASSIGN pFieldValue = RowObject.num-livre-2.        
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice prim†rio
  Parameters:  
               retorna valor do campo cod-item
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-item     LIKE item-fabrican-siscomex.cod-item      NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-emitente LIKE item-fabrican-siscomex.cdn-emitente  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-pais-iso LIKE item-fabrican-siscomex.cod-pais-iso  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-cnpj-cpf LIKE item-fabrican-siscomex.cod-cnpj-cpf  NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-item     = RowObject.cod-item
           pcdn-emitente = RowObject.cdn-emitente
           pcod-pais-iso = RowObject.cod-pais-iso 
           pcod-cnpj-cpf = RowObject.cod-cnpj-cpf.

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
        WHEN "log-fabrican-conhecid":U THEN ASSIGN pFieldValue = RowObject.log-fabrican-conhecid.
        WHEN "log-livre-1":U           THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U           THEN ASSIGN pFieldValue = RowObject.log-livre-2.
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
  Purpose:     Reposiciona registro com base no °ndice prim†rio
  Parameters:  
               recebe valor do campo cod-item
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-item     LIKE item-fabrican-siscomex.cod-item      NO-UNDO.       
    DEFINE INPUT PARAMETER pcdn-emitente LIKE item-fabrican-siscomex.cdn-emitente  NO-UNDO.       
    DEFINE INPUT PARAMETER pcod-pais-iso LIKE item-fabrican-siscomex.cod-pais-iso  NO-UNDO.       
    DEFINE INPUT PARAMETER pcod-cnpj-cpf LIKE item-fabrican-siscomex.cod-cnpj-cpf  NO-UNDO.       

    FIND FIRST bfitem-fabrican-siscomex 
         WHERE bfitem-fabrican-siscomex.cod-item     = pcod-item     
           AND bfitem-fabrican-siscomex.cdn-emitente = pcdn-emitente 
           AND bfitem-fabrican-siscomex.cod-pais-iso = pcod-pais-iso 
           AND bfitem-fabrican-siscomex.cod-cnpj-cpf = pcod-cnpj-cpf NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-fabrican-siscomex THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-fabrican-siscomex)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItem DBOProgram 
PROCEDURE openQueryItem :
/*------------------------------------------------------------------------------
  Purpose: Realiza a abertura da query por item    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName}
                               WHERE {&TableName}.cod-item = c-item NO-LOCK.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose: Realiza a abertura da query principal, com todos os registros da tabela    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItem DBOProgram 
PROCEDURE setConstraintItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-item LIKE item-atrib-siscomex.cod-item NO-UNDO.

    ASSIGN c-item = pc-item.

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

    IF pType = "CREATE":U 
    OR pType = "COPY":U THEN DO:
        IF CAN-FIND(FIRST bfitem-fabrican-siscomex 
                    WHERE bfitem-fabrican-siscomex.cod-item     = RowObject.cod-item
                    AND   bfitem-fabrican-siscomex.cdn-emitente = RowObject.cdn-emitente 
                    AND   bfitem-fabrican-siscomex.cod-pais-iso = RowObject.cod-pais-iso 
                    AND   bfitem-fabrican-siscomex.cod-cnpj-cpf = RowObject.cod-cnpj-cpf ) THEN DO:
            {utp/ut-liter.i o_item *}
            ASSIGN c-lbl-help = RETURN-VALUE + " : " + RowObject.cod-item. 
            {utp/ut-liter.i Fabricante_Siscomex *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="428"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE + '~~~~' + c-lbl-help"}
        END. 

        IF RowObject.log-fabrican-conhecid THEN DO:
            IF RowObject.cdn-emitente = 0 OR 
               NOT CAN-FIND(FIRST emitente-siscomex 
               WHERE emitente-siscomex.cdn-emitente = RowObject.cdn-emitente) THEN DO:
               {utp/ut-liter.i O_Fabricante_conhecido_deve_ser_um_operador_estrangeiro_cadastrado_(CD2576) *}
               ASSIGN c-lbl-help = RETURN-VALUE. 
               {utp/ut-liter.i Fabricante_Siscomex *}
                {method/svc/errors/inserr.i
                        &ErrorNumber="34626"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="RETURN-VALUE + '~~~~' + c-lbl-help"}    
            END.
        END.
 
        IF RowObject.cod-pais-iso = "":U THEN DO:
           {utp/ut-liter.i Verifique_se_foi_informado_Pa°s_ISO_3166-2_v†lido_para_o_pa°s_do_fabricante_no_Cadastro_de_Pa°s_(CD0181) *}
           ASSIGN c-lbl-help = RETURN-VALUE.
           {utp/ut-liter.i Pa°s_ISO *}
           {method/svc/errors/inserr.i
                   &ErrorNumber="5561"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters="RETURN-VALUE + '~~~~' + c-lbl-help"} 
        END.    

        FOR FIRST pais 
            WHERE TRIM(SUBSTRING(pais.char-1,23,02)) = RowObject.cod-pais-iso NO-LOCK:
            IF pais.nome-pais = "Brasil":U AND
               RowObject.log-fabrican-conhecid AND 
               RowObject.cod-cnpj-cpf = "" THEN DO:
               {utp/ut-liter.i CNPJ/CPF_do_fabricante_brasileiro *}   
               {method/svc/errors/inserr.i                                                                                               
                       &ErrorNumber="265"                                                                                               
                       &ErrorType="EMS"                                                                                                  
                       &ErrorSubType="ERROR"                                                                                             
                       &ErrorParameters="RETURN-VALUE"}                                                                                  
            END.
        END.

        IF RowObject.dat-refer > TODAY THEN DO:
            {utp/ut-liter.i Data_Referància *}   
            {method/svc/errors/inserr.i                 
                    &ErrorNumber="3778"                  
                    &ErrorType="EMS"                    
                    &ErrorSubType="ERROR"               
                    &ErrorParameters="RETURN-VALUE"}                      
        END.

        /*IF RowObject.cod-cnpj-cpf <> "":U THEN DO:
        
            ASSIGN l-erro-caracter = NO
                   RowObject.cod-cnpj-cpf = UPPER(RowObject.cod-cnpj-cpf).
           
            DO i-cont = 1 TO LENGTH(RowObject.cod-cnpj-cpf):
                IF i-cont >= 13 THEN DO:                   /* D°gito verificador n∆o aceita letras */
                    IF  CAN-DO("0,1,2,3,4,5,6,7,8,9",SUBSTRING(RowObject.cod-cnpj-cpf,i-cont,1)) THEN
                        ASSIGN c-cnpj = c-cnpj + SUBSTR(RowObject.cod-cnpj-cpf,i-cont,1).
                    ELSE
                        ASSIGN l-erro-caracter = YES.
                END.
                ELSE DO:
                    IF i-cont < 13                                          AND 
                       (ASC(SUBSTR(RowObject.cod-cnpj-cpf,i-cont,1)) >= 48  AND       /*  48  = 0  */
                        ASC(SUBSTR(RowObject.cod-cnpj-cpf,i-cont,1)) <= 57) OR        /*  57  = 9  */
                       (ASC(SUBSTR(RowObject.cod-cnpj-cpf,i-cont,1)) >= 65  AND       /*  65  = A  */
                        ASC(SUBSTR(RowObject.cod-cnpj-cpf,i-cont,1)) <= 90) THEN      /*  90  = Z  */ 
                        ASSIGN c-cnpj = c-cnpj + SUBSTR(RowObject.cod-cnpj-cpf,i-cont,1).
                    ELSE
                        ASSIGN l-erro-caracter = YES.
                END.
            END.
            
            IF l-erro-caracter THEN DO:
                {utp/ut-liter.i CNPJ_Fabricante * }
                {method/svc/errors/inserr.i
                        &ErrorNumber="55900"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="RETURN-VALUE"}
            END.
            ASSIGN l-erro-caracter = NO.
        END.*/           
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

