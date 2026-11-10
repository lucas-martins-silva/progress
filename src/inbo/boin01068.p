&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters :  

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/
{include/i-prgvrs.i BOIN01068 2.00.00.011 } /*** "010011" 09/04/2026 09:59:07 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin01068 MUT}
&ENDIF
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN01068
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName movto-estoq-internac
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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin01068.i RowObject}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE TEMP-TABLE tt-class NO-UNDO
  FIELD esp-docto LIKE movto-estoq.esp-docto
  INDEX pk IS UNIQUE esp-docto.

{utp/ut-glob.i}

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
         HEIGHT             = 8.33
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaMovto DBOProgram 
PROCEDURE atualizaMovto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-rw-movto AS ROWID NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR RowErrors.
    
    EMPTY TEMP-TABLE rowErrors.
    
    CASE i-pais-impto-usuario:
        WHEN 33 /* Peru */ THEN DO:
            FIND FIRST movto-estoq NO-LOCK
                WHERE ROWID(movto-estoq) = p-rw-movto NO-ERROR.
                
            IF  NOT AVAIL movto-estoq
            OR  NOT (movto-estoq.cod-prog-orig BEGINS "RE") THEN
                LEAVE.

            FIND FIRST ext-docum-est NO-LOCK
                WHERE ext-docum-est.cod-emitente = movto-estoq.cod-emitente 
                  AND ext-docum-est.nat-operacao = movto-estoq.nat-operacao 
                  AND ext-docum-est.nro-docto    = movto-estoq.nro-docto
                  AND ext-docum-est.serie-docto  = movto-estoq.serie-docto
                  AND ext-docum-est.cod-param    = "dadosPeru":U NO-ERROR.
            IF  AVAIL ext-docum-est THEN DO:

                FIND FIRST movto-estoq-internac NO-LOCK
                    WHERE movto-estoq-internac.nr-trans         = movto-estoq.nr-trans
                      AND movto-estoq-internac.des-decla-import = ext-docum-est.cod-param NO-ERROR.
                IF  NOT AVAIL movto-estoq-internac THEN DO:
                    CREATE movto-estoq-internac.
                    ASSIGN movto-estoq-internac.nr-trans         = movto-estoq.nr-trans
                           movto-estoq-internac.des-decla-import = ext-docum-est.cod-param
                           movto-estoq-internac.cdn-tip-comprov  = ext-docum-est.num-livre-1
                           movto-estoq-internac.cdn-tip-operac   = ext-docum-est.num-livre-2.
                END.
            END.
        END.
    END CASE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaMovtoEstoqInternac DBOProgram 
PROCEDURE atualizaMovtoEstoqInternac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-rw-movto       AS ROWID NO-UNDO.
    DEF INPUT PARAM p-tp-comprov-doc AS INT   NO-UNDO.
    DEF INPUT PARAM p-tp-operacao    AS INT   NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR RowErrors.
    
    EMPTY TEMP-TABLE rowErrors.
    
    IF i-pais-impto-usuario = 33 THEN DO:
        
        FIND FIRST movto-estoq NO-LOCK
             WHERE ROWID(movto-estoq) = p-rw-movto NO-ERROR.
                
        IF NOT AVAIL movto-estoq THEN
            LEAVE.
        
        FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
             WHERE bf{&TableName}.nr-trans         = movto-estoq.nr-trans
               AND bf{&TableName}.des-decla-import = "dadosPeru":U NO-ERROR.
        IF NOT AVAIL bf{&TableName} THEN DO:
            CREATE bf{&TableName}.
            ASSIGN bf{&TableName}.nr-trans         = movto-estoq.nr-trans
                   bf{&TableName}.des-decla-import = "dadosPeru".
        END.
        ASSIGN bf{&TableName}.cdn-tip-comprov = p-tp-comprov-doc
               bf{&TableName}.cdn-tip-operac  = p-tp-operacao.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaMovtoEstoqInternac DBOProgram 
PROCEDURE atualizaMovtoEstoqInternacHTML :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/     
    EMPTY TEMP-TABLE rowErrors. 
    
    IF i-pais-impto-usuario = 33 THEN DO:
         
        RUN validateRecord IN THIS-PROCEDURE (INPUT "Update":U).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RETURN "NOK":U.    
        END.
    
        FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
             WHERE bf{&TableName}.nr-trans         = RowObject.nr-trans 
               AND bf{&TableName}.des-decla-import = "dadosPeru":U NO-ERROR.
        IF NOT AVAIL bf{&TableName} THEN DO:
    
            CREATE bf{&TableName}.
            ASSIGN bf{&TableName}.nr-trans         = RowObject.nr-trans 
                   bf{&TableName}.des-decla-import = "dadosPeru".
        END.
        
        ASSIGN bf{&TableName}.cdn-tip-comprov = RowObject.cdn-tip-comprov
               bf{&TableName}.cdn-tip-operac  = RowObject.cdn-tip-operac.           
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaMovtoControleAduana DBOProgram 
PROCEDURE criaMovtoControleAduana :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-nr-trans       LIKE movto-estoq.nr-trans      NO-UNDO.
    DEF INPUT PARAM p-rw-sdo-estoq-internac   AS ROWID              NO-UNDO.
    DEF INPUT PARAM p-quantidade     LIKE movto-estoq.quantidade    NO-UNDO.

    FIND FIRST sdo-estoq-internac
        WHERE ROWID(sdo-estoq-internac) = p-rw-sdo-estoq-internac NO-LOCK NO-ERROR.
    IF  NOT AVAIL sdo-estoq-internac THEN
        RETURN "NOK":U.

    CREATE bf{&TableName}.
    ASSIGN bf{&TableName}.nr-trans         =  p-nr-trans
           bf{&TableName}.cod-estabel      =  sdo-estoq-internac.cod-estabel   
           bf{&TableName}.cod-depos        =  sdo-estoq-internac.cod-depos     
           bf{&TableName}.cod-localiz      =  sdo-estoq-internac.cod-localiz   
           bf{&TableName}.it-codigo        =  sdo-estoq-internac.it-codigo     
           bf{&TableName}.cod-refer        =  sdo-estoq-internac.cod-refer     
           bf{&TableName}.lote             =  sdo-estoq-internac.lote          
           bf{&TableName}.des-decla-import =  sdo-estoq-internac.declaracao-import
           bf{&TableName}.quantidade       =  p-quantidade.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "des-decla-import":U THEN ASSIGN pFieldValue = RowObject.des-decla-import.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "nr-trans":U THEN ASSIGN pFieldValue = RowObject.nr-trans.
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
  Purpose:     Retorna valores dos campos do ¡ndice mvtstqnt_id2
  Parameters:  
               retorna valor do campo nr-trans
               retorna valor do campo des-decla-import
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-trans LIKE movto-estoq-internac.nr-trans NO-UNDO.
    DEFINE OUTPUT PARAMETER pdes-decla-import LIKE movto-estoq-internac.des-decla-import NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-trans = RowObject.nr-trans
           pdes-decla-import = RowObject.des-decla-import.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
  Purpose:     Reposiciona registro com base no ¡ndice mvtstqnt_id2
  Parameters:  
               recebe valor do campo nr-trans
               recebe valor do campo des-decla-import
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-trans LIKE movto-estoq-internac.nr-trans NO-UNDO.
    DEFINE INPUT PARAMETER pdes-decla-import LIKE movto-estoq-internac.des-decla-import NO-UNDO.

    FIND FIRST bfmovto-estoq-internac WHERE 
        bfmovto-estoq-internac.nr-trans = pnr-trans AND 
        bfmovto-estoq-internac.des-decla-import = pdes-decla-import NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmovto-estoq-internac THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmovto-estoq-internac)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyNrtrans DBOProgram 
PROCEDURE goToKeyNrtrans :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice mvtstqnt_id2
  Parameters:  
               recebe valor do campo nr-trans
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-trans LIKE movto-estoq-internac.nr-trans NO-UNDO.                
    FIND FIRST bfmovto-estoq-internac WHERE 
        bfmovto-estoq-internac.nr-trans = pnr-trans NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmovto-estoq-internac THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmovto-estoq-internac)).
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
    Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.
        
    RETURN "OK":U. 
    
    END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-liter      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-liter2     AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    
    IF pType = "CREATE" OR  pType = "UPDATE"  THEN DO:
    
        IF i-pais-impto-usuario = 33 THEN DO:
     
           IF  RowObject.cdn-tip-operac = 0 THEN DO:
                   {utp/ut-liter.i "Tipo Opera‡Æo"}          
                   {method/svc/errors/inserr.i &ErrorNumber="265" /*&1 deve ser informado(a).*/
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters="RETURN-VALUE"}
            END. 
             
            IF  RowObject.cdn-tip-operac >= 1
            AND RowObject.cdn-tip-operac <= 6 THEN DO:
                
                /* tipo de documento de traslado - ² obrigat¢rio informar quando o tipo de opera‡Æo estiver entre os valores 1 e 6 */
                IF  RowObject.cdn-tip-comprov = 0 THEN DO:
                    {utp/ut-liter.i "Tipo de comprovante de traslado" *} ASSIGN c-liter = TRIM(RETURN-VALUE).
                    {utp/ut-liter.i "movimento de estoque" *} ASSIGN c-liter2 = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber="32266" /*&1 nÆo foi informado para o(a) &2.*/
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters= c-liter + '~~' + c-liter2}
                END.
            END.
        END.    
    END.
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

