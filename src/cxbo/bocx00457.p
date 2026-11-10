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
{include/i-prgvrs.i BOCX00457 2.00.00.005 } /*** "010005" 09/02/2026 08:53:25 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX00457
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName param-exp-siscomex
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
{cxbo/bocx00457.i RowObject}
{cxbo/bocx00457.i1} /*Temp-table de comunicaá∆o*/
{utp/ut-glob.i} 

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE l-erro-param-exp AS LOGICAL INITIAL NO NO-UNDO.

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
         HEIGHT             = 3.79
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
        WHEN "cod-arq-certif":U THEN ASSIGN pFieldValue = RowObject.cod-arq-certif.
        WHEN "cod-chave-certif":U THEN ASSIGN pFieldValue = RowObject.cod-chave-certif.
        WHEN "cod-cnpj-cpf":U THEN ASSIGN pFieldValue = RowObject.cod-cnpj-cpf.
        WHEN "cod-dir-histor-xml":U THEN ASSIGN pFieldValue = RowObject.cod-dir-histor-xml.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-senha-certif":U THEN ASSIGN pFieldValue = RowObject.cod-senha-certif.
        WHEN "cod-url-homol":U THEN ASSIGN pFieldValue = RowObject.cod-url-homol.
        WHEN "cod-url-produc":U THEN ASSIGN pFieldValue = RowObject.cod-url-produc.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDefaults DBOProgram 
PROCEDURE getDefaults :
/*------------------------------------------------------------------------------
  Purpose: Retorna a temp-table RowObject com informaá‰es padr‰es para criaá∆o de um
           novo registro    
  Parameters: RowObject (OUTPUT - Temp-table): Registro contendo os valores padr‰es para 
                                               criaá∆o de um novo registro.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR RowObject.

    EMPTY TEMP-TABLE RowObject.
    CREATE RowObject.
    ASSIGN RowObject.cod-cnpj-cpf              = "":U           
           RowObject.idi-tipo-certif-digital   = 1 /* A1 */
           RowObject.idi-format-certif-digital = 1 /* PEM */ 
           RowObject.cod-arq-certif            = "":U       
           RowObject.cod-senha-certif          = "":U       
           RowObject.idi-tip-ambiente          = 1 /* Homologaá∆o */        
           RowObject.cod-url-homol             = "https://val.portalunico.siscomex.gov.br":U         
           RowObject.cod-url-produc            = "https://portalunico.siscomex.gov.br":U             
           RowObject.log-histor-envio          = NO                                               
           RowObject.cod-dir-histor-xml        = "":U                                       
           RowObject.idi-usuar-integr          = 1. /* Declarante Importador/Exportador */    

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
        WHEN "idi-format-certif-digital":U THEN ASSIGN pFieldValue = RowObject.idi-format-certif-digital.
        WHEN "idi-tip-ambiente":U THEN ASSIGN pFieldValue = RowObject.idi-tip-ambiente.
        WHEN "idi-tipo-certif-digital":U THEN ASSIGN pFieldValue = RowObject.idi-tipo-certif-digital.
        WHEN "idi-usuar-integr":U THEN ASSIGN pFieldValue = RowObject.idi-usuar-integr.
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
  Purpose:     Retorna valores dos campos do °ndice prmxpssc_id2
  Parameters:  
               retorna valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE param-exp-siscomex.cod-estabel NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel.

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
        WHEN "log-histor-envio":U THEN ASSIGN pFieldValue = RowObject.log-histor-envio.
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
  Purpose:     Reposiciona registro com base no °ndice prmxpssc_id2
  Parameters:  
               recebe valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE param-exp-siscomex.cod-estabel NO-UNDO.

    FIND FIRST bfparam-exp-siscomex WHERE 
        bfparam-exp-siscomex.cod-estabel = pcod-estabel NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfparam-exp-siscomex THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfparam-exp-siscomex)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetaErroParamExp DBOProgram 
PROCEDURE piSetaErroParamExp :
/*------------------------------------------------------------------------------
  Purpose: - Seta dentro desta DBO se houve alguma validaá∆o na BOCX180 para que os
           registros da param-exp-siscomex n∆o sejam salvos na base de dados.
           Devem ser salvos somente se n∆o ocorrer erro de validaá∆o tambÇm na bocx180
           - Setado atravÇs da procedure "ValidateFields" da BOCX180
  Parameters:  pl-erro-param-exp: l¢gico (entrada)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pl-erro-param-exp AS LOGICAL NO-UNDO.

    ASSIGN l-erro-param-exp = pl-erro-param-exp.

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

    DEFINE VARIABLE i-ini-extensao1 AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-ini-extensao2 AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-extensao      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-erro-caracter AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-cont          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-cnpj          AS CHARACTER   NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    IF pType = "Create":U OR pType = "Update":U THEN DO:
        ASSIGN c-extensao = {cxinc/i03cx00457.i 04 RowObject.idi-format-certif-digital}.

        /*IF RowObject.cod-cnpj-cpf <> "":U THEN DO:
            ASSIGN l-erro-caracter = NO.
             DO  i-cont = 1 TO LENGTH(RowObject.cod-cnpj-cpf):
                IF  CAN-DO("0,1,2,3,4,5,6,7,8,9",SUBSTRING(RowObject.cod-cnpj-cpf,i-cont,1)) THEN
                    ASSIGN c-cnpj = c-cnpj + SUBSTR(RowObject.cod-cnpj-cpf,i-cont,1).
                ELSE DO:
                    IF  SUBSTRING(RowObject.cod-cnpj-cpf,i-cont,1) <> ".":U
                    AND SUBSTRING(RowObject.cod-cnpj-cpf,i-cont,1) <> "/":U
                    AND SUBSTRING(RowObject.cod-cnpj-cpf,i-cont,1) <> "-":U
                    AND SUBSTRING(RowObject.cod-cnpj-cpf,i-cont,1) <> " ":U  THEN DO:
                        ASSIGN l-erro-caracter = YES.
                    END.
                END.
             END.
             IF l-erro-caracter THEN DO:
                 {utp/ut-liter.i CNPJ/CPF_referente_a_integraá∆o_Siscomex * }    
                 {method/svc/errors/inserr.i
                         &ErrorNumber="55900"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters="RETURN-VALUE"}
             END.
             ELSE DO:
                IF DEC(RowObject.cod-cnpj-cpf) = 0 THEN DO: 
                    {utp/ut-liter.i CNPJ/CPF_referente_a_integraá∆o_Siscomex * }
                    {method/svc/errors/inserr.i
                            &ErrorNumber="1491"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="RETURN-VALUE"}
                END.
             END.
             ASSIGN l-erro-caracter = NO.
        END.*/

        IF (RowObject.cod-arq-certif <> "":U OR RowObject.cod-chave-certif <> "":U) THEN DO: 
            ASSIGN i-ini-extensao1 = LENGTH(RowObject.cod-arq-certif) - 2
                   i-ini-extensao2 = LENGTH(RowObject.cod-chave-certif) - 2.

            IF RowObject.cod-arq-certif <> "":U THEN DO:  
                /* Arquivo de certificado n∆o existe */
                IF SEARCH(RowObject.cod-arq-certif) = ? THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="8064"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters=RowObject.cod-arq-certif}
                END.
                /* Extens∆o de certificado inv†lida */
                IF substring(RowObject.cod-arq-certif, i-ini-extensao1, 3) <> c-extensao THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="26426"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters=c-extensao}
                END.         
            END.
            IF RowObject.cod-chave-certif <> "":U THEN DO:
                /* Arquivo de chave de certificado n∆o existe */
                IF SEARCH(RowObject.cod-chave-certif) = ? THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="8064"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters=RowObject.cod-chave-certif}
                END.
                /* Extens∆o de chave de certificado inv†lida */
                IF substring(RowObject.cod-chave-certif, i-ini-extensao2, 3) <> c-extensao THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="26426"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters=c-extensao}
                END.
            END. 
        END.

        IF RowObject.log-histor-envio THEN DO:
            IF RowObject.cod-dir-histor-xml = "" THEN DO:
                {utp/ut-liter.i Diret¢rio_de_Hist¢rico_XML * }
                {method/svc/errors/inserr.i
                        &ErrorNumber="265"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters=RETURN-VALUE}

            END.
            ELSE DO:
                ASSIGN FILE-INFO:FILE-NAME = RowObject.cod-dir-histor-xml.
                /* Diret¢rio de geraá∆o de XML n∆o existe */
                IF FILE-INFO:FILE-TYPE <> "DRW":U THEN DO: /*Verifica se o conte£do inserido refere-se a um diret¢rio*/
                    {method/svc/errors/inserr.i
                        &ErrorNumber="4715"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters=RowObject.cod-dir-histor-xml}
                END.
            END.
        END. 
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    /*Se encontrou algum erro de validaá∆o realizada pela BOCX180, 
      o registro n∆o deve ser efetivado na base de dados*/
    IF l-erro-param-exp THEN
        RETURN "NOK":U.

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSiscomexAuthInfo DBOProgram 
PROCEDURE getSiscomexAuthInfo:
/*:T------------------------------------------------------------------------------
  Purpose:     Busca as informaá‰es necess†rias para a autenticaá∆o no Siscomex
  Parameters:  pcSiteCode (entrada) - C¢digo do estabelecimento - character
               l-only-generate-file (entrada) - Identifica se apenas gera o arquivo XML, pois caso positivo 
                                                n∆o ser† necess†rio validar autenticaá∆o - logical
               ttSiscomexAuthInfo (sa°da) - Retorna as informaá‰es da tabela param-exp-siscomex - temp-table
               RowErrors (sa°da) - Retorna os erros - temp-table
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pcSiteCode             AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM pl-only-generate-file  AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR ttSiscomexAuthInfo.
    DEFINE OUTPUT PARAM TABLE FOR RowErrors.

    DEFINE VARIABLE c-lb-cod-estabel AS CHARACTER NO-UNDO.

    EMPTY TEMP-TABLE ttSiscomexAuthInfo NO-ERROR.
    FIND FIRST param-exp-siscomex
         WHERE param-exp-siscomex.cod-estabel = pcSiteCode NO-LOCK NO-ERROR.
         
    FIND FIRST usuar-export WHERE 
               usuar-export.cod-usuar = c-seg-usuario NO-LOCK NO-ERROR.
        
    IF AVAIL param-exp-siscomex THEN DO:
        CREATE ttSiscomexAuthInfo.                
        ASSIGN ttSiscomexAuthInfo.siteCode          = param-exp-siscomex.cod-estabel             
               ttSiscomexAuthInfo.cnpjCpf           = param-exp-siscomex.cod-cnpj-cpf            
               ttSiscomexAuthInfo.envType           = param-exp-siscomex.idi-tip-ambiente      
               ttSiscomexAuthInfo.urlTestEnv        = param-exp-siscomex.cod-url-homol           
               ttSiscomexAuthInfo.urlProdEnv        = param-exp-siscomex.cod-url-produc         
               ttSiscomexAuthInfo.certifType        = param-exp-siscomex.idi-tipo-certif-digital
               ttSiscomexAuthInfo.certifFormat      = param-exp-siscomex.idi-format-certif-digital
               ttSiscomexAuthInfo.certifFile        = param-exp-siscomex.cod-arq-certif        
               ttSiscomexAuthInfo.certifKeyFile     = param-exp-siscomex.cod-chave-certif        
               ttSiscomexAuthInfo.certifPassword    = param-exp-siscomex.cod-senha-certif        
               ttSiscomexAuthInfo.saveXmlFiles      = param-exp-siscomex.log-histor-envio        
               ttSiscomexAuthInfo.dirXmlFiles       = param-exp-siscomex.cod-dir-histor-xml      
               ttSiscomexAuthInfo.userIntegrProfile = param-exp-siscomex.idi-usuar-integr.        

        IF NOT pl-only-generate-file THEN
            RUN validateAuthInfo IN THIS-PROCEDURE.

    END.
    ELSE DO:
        {utp/ut-field.i mgcex param-exp-siscomex cod-estabel 1}
         ASSIGN c-lb-cod-estabel = RETURN-VALUE.

        {utp/ut-table.i mgcex param-exp-siscomex 1}
        {method/svc/errors/inserr.i
                        &ErrorNumber="2"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="RETURN-VALUE + '~~~~' + c-lb-cod-estabel + ': ' + pcSiteCode"}

    END.
    IF AVAIL usuar-export THEN DO:
         IF usuar-export.idi-tipo-certif-digital    > 0 AND
            usuar-export.idi-format-certif-digital  > 0 AND
            usuar-export.cod-arq-certif            <> "" AND
            usuar-export.cod-chave-certif          <> "" AND
            usuar-export.cod-senha-certif          <> ""
         THEN DO:
              ASSIGN ttSiscomexAuthInfo.certifType        = usuar-export.idi-tipo-certif-digital
                     ttSiscomexAuthInfo.certifFormat      = usuar-export.idi-format-certif-digital
                     ttSiscomexAuthInfo.certifFile        = STRING(BASE64-DECODE(usuar-export.cod-arq-certif))
                     ttSiscomexAuthInfo.certifKeyFile     = STRING(BASE64-DECODE(usuar-export.cod-chave-certif))
                     ttSiscomexAuthInfo.certifPassword    = usuar-export.cod-senha-certif.
         END.
    END.
    
     /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateAuthInfo DBOProgram 
PROCEDURE validateAuthInfo:
/*:T------------------------------------------------------------------------------
  Purpose:     Valida as informaá‰es para autenticaá∆o com o siscomex
  Parameters:  
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-lb-estabel AS CHARACTER NO-UNDO.

    IF AVAIL param-exp-siscomex THEN DO:
        {utp/ut-liter.i "estabelecimento"}
        ASSIGN c-lb-estabel = RETURN-VALUE + " " + param-exp-siscomex.cod-estabel + ".".

        IF param-exp-siscomex.idi-tip-ambiente = 1 THEN DO: /*Homologaá∆o*/
            /*Url de homologaá∆o*/
            IF param-exp-siscomex.cod-url-homol = "":U THEN DO:
                {utp/ut-field.i mgcex param-exp-siscomex cod-url-homol 1}
                {method/svc/errors/inserr.i
                                &ErrorNumber="34998"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="RETURN-VALUE + '~~~~' + c-lb-estabel"}
            END.
        END.
        ELSE DO:
            /*Url de produá∆o*/
            IF param-exp-siscomex.cod-url-produc = "":U THEN DO:
                {utp/ut-field.i mgcex param-exp-siscomex cod-url-produc 1}
                {method/svc/errors/inserr.i
                                &ErrorNumber="34998"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="RETURN-VALUE + '~~~~' + c-lb-estabel"}
            END.
        END.

        /*Arquivo certificado*/
        IF param-exp-siscomex.cod-arq-certif = "":U THEN DO:
            {utp/ut-field.i mgcex param-exp-siscomex cod-arq-certif 1}
            {method/svc/errors/inserr.i
                            &ErrorNumber="34998"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="RETURN-VALUE + '~~~~' + c-lb-estabel"}
        END.

        /*Arquivo de chave do certificado*/
        IF param-exp-siscomex.idi-format-certif-digital = 1 AND /*PEM*/
            param-exp-siscomex.cod-chave-certif = "":U THEN DO:
            {utp/ut-field.i mgcex param-exp-siscomex cod-chave-certif 1}
            {method/svc/errors/inserr.i
                            &ErrorNumber="34998"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="RETURN-VALUE + '~~~~' + c-lb-estabel"}
        END.

        /*Senha do certificado*/
        IF param-exp-siscomex.cod-senha-certif = "":U THEN DO:
            {utp/ut-field.i mgcex param-exp-siscomex cod-senha-certif 1}
            {method/svc/errors/inserr.i
                            &ErrorNumber="34998"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="RETURN-VALUE + '~~~~' + c-lb-estabel"}
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
