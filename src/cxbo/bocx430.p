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
&GLOBAL-DEFINE DBOName BOCX00430
&GLOBAL-DEFINE DBOVersion 2.0
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName usuar-export
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
{cxbo/bocx430.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

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
        WHEN "cod-livre-1":U            THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U            THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-usuar":U              THEN ASSIGN pFieldValue = RowObject.cod-usuar.
        WHEN "des-layout-origin-gerc":U THEN ASSIGN pFieldValue = RowObject.des-layout-origin-gerc.
        WHEN "cod-cpf":U                THEN ASSIGN pFieldValue = RowObject.cod-cpf.
        WHEN "cod-arq-certif":U         THEN ASSIGN pFieldValue = RowObject.cod-arq-certif.
        WHEN "cod-chave-certif":U       THEN ASSIGN pFieldValue = RowObject.cod-chave-certif.
        WHEN "cod-senha-certif":U       THEN ASSIGN pFieldValue = RowObject.cod-senha-certif.
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
        WHEN "num-livre-1":U             THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U             THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "idi-usuar-integr"          THEN ASSIGN pFieldValue = RowObject.idi-usuar-integr.
        WHEN "idi-tipo-certif-digital"   THEN ASSIGN pFieldValue = RowObject.idi-tipo-certif-digital.
        WHEN "idi-format-certif-digital" THEN ASSIGN pFieldValue = RowObject.idi-format-certif-digital.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice usrxprt_id
  Parameters:  
               retorna valor do campo cod-usuar
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-usuar LIKE usuar-export.cod-usuar NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-usuar = RowObject.cod-usuar.

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
        WHEN "log-perm-pto-control-exp":U THEN ASSIGN pFieldValue = RowObject.log-perm-pto-control-exp.
        WHEN "log-perm-pto-despes-exp":U THEN ASSIGN pFieldValue = RowObject.log-perm-pto-despes-exp.
        WHEN "log-perm-pto-decla-exp":U THEN ASSIGN pFieldValue = RowObject.log-perm-pto-decla-exp.
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
  Purpose:     Reposiciona registro com base no °ndice usrxprt_id
  Parameters:  
               recebe valor do campo cod-usuar
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-usuar LIKE usuar-export.cod-usuar NO-UNDO.

    FIND FIRST bfusuar-export WHERE 
        bfusuar-export.cod-usuar = pcod-usuar NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfusuar-export THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfusuar-export)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnNameUsuar DBOProgram 
PROCEDURE returnNameUsuar :
/*------------------------------------------------------------------------------
  Purpose:    Retorna nome do usu†rio 
  Parameters:  pc-cod-usuar = c¢digo do usu†rio
               pc-nom-usuar = nome do usu†rio(descriá∆o)
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER pc-cod-usuar AS CHARACTER  NO-UNDO.
   DEFINE OUTPUT PARAMETER pc-nom-usuar AS CHARACTER  NO-UNDO.

   FOR FIRST usuar_mestre
       FIELDS (nom_usuario) NO-LOCK
       WHERE usuar_mestre.cod_usuario = pc-cod-usuar.

       ASSIGN pc-nom-usuar = usuar_mestre.nom_usuario.
   END.
   

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
    
    DEFINE VARIABLE i-ini-extensao1         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-ini-extensao2         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-extensao              AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-arq-certif-desc   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-chave-certif-desc AS CHARACTER   NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /*:T--- Verifica ocorrància de erros ---*/

    IF pType = "CREATE":U THEN DO:

        IF NOT CAN-FIND(FIRST usuar_mestre
                        WHERE usuar_mestre.cod_usuario = RowObject.cod-usuar) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-usuario-de-exportacao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Usu†rio_de_Exportaá∆o" *}
            ASSIGN c-lbl-liter-usuario-de-exportacao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
               &ErrorNumber="2"
               &ErrorType="EMS"
               &ErrorSubType="ERROR"
               &ErrorParameters="c-lbl-liter-usuario-de-exportacao"}
        END.

        IF CAN-FIND(FIRST bf{&TableName} WHERE
                          bf{&TableName}.cod-usuar = RowObject.cod-usuar) THEN DO:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-usuario-de-exportacao-2 AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Usuario_de_Exportaá∆o" *}
           ASSIGN c-lbl-liter-usuario-de-exportacao-2 = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                &ErrorNumber="1"
                &ErrorType="EMS"
                &ErrorSubType="Error"
                &ErrorParameters="c-lbl-liter-usuario-de-exportacao-2"}
        END.
    END.

    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
    ASSIGN c-extensao = {cxinc/i03cx00457.i 04 RowObject.idi-format-certif-digital}.

        if  rowObject.des-layout-origin-gerc <> "" then do:
        
            assign file-info:file-name = rowObject.des-layout-origin-gerc.
        
            if  file-info:pathname = ? 
            or  search(rowObject.des-layout-origin-gerc) <> ? then do:
           
               {method/svc/errors/inserr.i
                    &ErrorNumber="4715"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="RowObject.des-layout-origin-gerc"}
            
                RETURN "NOK".
 
            end. 
        end.

        IF (RowObject.cod-arq-certif <> "":U OR RowObject.cod-chave-certif <> "":U) THEN DO: 
                
            IF RowObject.cod-arq-certif   <> "" THEN DO:
               IF STRING(BASE64-DECODE(RowObject.cod-arq-certif)) <> "?":U THEN 
                  assign c-cod-arq-certif-desc = STRING(BASE64-DECODE(RowObject.cod-arq-certif)) NO-ERROR.
               ELSE DO:
                   assign c-cod-arq-certif-desc = "":U.
                   IF SEARCH(c-cod-arq-certif-desc) = ? THEN DO:
                      {utp/ut-liter.i Arquivo_Certificado *}
                      {method/svc/errors/inserr.i &ErrorNumber="158"
                                                  &ErrorType="EMS"
                                                  &ErrorSubType="ERROR"
                                                  &ErrorParameters=TRIM(RETURN-VALUE)}
                   END.
               END.
            END.
            ELSE 
               assign c-cod-arq-certif-desc = "":U.
               
            IF RowObject.cod-chave-certif <> "" THEN DO:
               IF STRING(BASE64-DECODE(RowObject.cod-chave-certif)) <> "?":U THEN
                  ASSIGN c-cod-chave-certif-desc = STRING(BASE64-DECODE(RowObject.cod-chave-certif)) NO-ERROR.
               ELSE DO:
                  ASSIGN c-cod-chave-certif-desc = "".
                  IF SEARCH(c-cod-arq-certif-desc) = ? THEN DO:
                    {utp/ut-liter.i Chave_do_Certificado_Digital *}
                    {method/svc/errors/inserr.i &ErrorNumber="158"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters=TRIM(RETURN-VALUE)}
                  END.
               END.
            END.
            ELSE 
               ASSIGN c-cod-chave-certif-desc = "":U.
               
            ASSIGN i-ini-extensao1         = LENGTH(c-cod-arq-certif-desc) - 2
                   i-ini-extensao2         = LENGTH(c-cod-chave-certif-desc) - 2.

            IF c-cod-arq-certif-desc <> "":U THEN DO:  
            
                /* Arquivo de certificado n∆o existe */
                IF SEARCH(c-cod-arq-certif-desc) = ? THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="8064"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters=c-cod-arq-certif-desc}
                END.
                /* Extens∆o de certificado inv†lida */
                IF substring(c-cod-arq-certif-desc, i-ini-extensao1, 3) <> c-extensao THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="26426"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters=c-extensao}
                END.         
            END. //IF c-cod-arq-certif-desc <> "":U
            IF c-cod-chave-certif-desc <> "":U THEN DO:
            
                /* Arquivo de chave de certificado n∆o existe */
                IF SEARCH(c-cod-chave-certif-desc) = ? THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="8064"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters=c-cod-chave-certif-desc}
                END.
                /* Extens∆o de chave de certificado inv†lida */
                IF substring(c-cod-chave-certif-desc, i-ini-extensao2, 3) <> c-extensao THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="26426"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters=c-extensao}
                END.
            END. //IF c-cod-chave-certif-desc <> "":U
        END. //IF (RowObject.cod-arq-certif <> "":U OR RowObject.cod-chave-certif <> "":U)
    END. //IF pType = "CREATE":U OR pType = "UPDATE"
    
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

