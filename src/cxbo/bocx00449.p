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
{include/i-prgvrs.i BOCX00449 2.00.00.007 } /*** "010007" 13/10/2026 10:30:38 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOCX00449
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName docto-export
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*--- Pre-processadores para acelerador de implanta‡Æo ---*/
&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

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
{cxbo/bocx00449.i RowObject}

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}

/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE iCdnDoctoExpIni  LIKE docto-export.cdn-docto-exp NO-UNDO.
DEFINE VARIABLE iCdnDoctoExpFim  LIKE docto-export.cdn-docto-exp NO-UNDO.
DEFINE VARIABLE cDescDoctoExpIni LIKE docto-export.desc-docto    NO-UNDO.
DEFINE VARIABLE cDescDoctoExpFim LIKE docto-export.desc-docto    NO-UNDO.
DEFINE VARIABLE lDocumentIsDefault AS LOGICAL                 NO-UNDO.

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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "desc-docto":U THEN ASSIGN pFieldValue = RowObject.desc-docto.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
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
        WHEN "cdn-docto-exp":U THEN ASSIGN pFieldValue = RowObject.cdn-docto-exp.
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
  Purpose:     Retorna valores dos campos do ¡ndice dctxprt_id2
  Parameters:  
               retorna valor do campo cdn-docto-exp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn-docto-exp LIKE docto-export.cdn-docto-exp NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn-docto-exp = RowObject.cdn-docto-exp.

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
  Purpose:     Reposiciona registro com base no ¡ndice dctxprt_id2
  Parameters:  
               recebe valor do campo cdn-docto-exp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-docto-exp LIKE docto-export.cdn-docto-exp NO-UNDO.

    FIND FIRST bfdocto-export WHERE 
        bfdocto-export.cdn-docto-exp = pcdn-docto-exp NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdocto-export THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdocto-export)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/

    IF pType = "CREATE":U THEN DO:
        IF CAN-FIND(FIRST bfdocto-export 
                    WHERE bfdocto-export.cdn-docto-exp = RowObject.cdn-docto-exp) THEN DO:
            /*msg:  J  existe ocorrˆncia &1 informada
              help: J  existe ocorrˆncia em &1 com a chave informada.*/
            {utp/ut-table.i mgcex docto-export 1}
            {method/svc/errors/inserr.i
                    &ErrorNumber="1"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
        
    END.

    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
        IF RowObject.cdn-docto-exp = 0 THEN DO:
            /*msg:  &1 ‚ obrigat¢rio(a).
              help: Informa‡Æo Obrigat¢ria.*/
            {utp/ut-liter.i "O_c¢digo_do_documento_de_exporta‡Æo"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="17394"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
        ELSE IF RowObject.desc-docto = "" THEN DO:
            /*msg:  &1 ‚ obrigat¢rio(a).
              help: Informa‡Æo Obrigat¢ria.*/
            {utp/ut-liter.i "A_descri‡Æo_do_documento_de_exporta‡Æo"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="17394"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
    END.

    IF pType = "CREATE":U OR pType = "DELETE":U THEN DO:
        /*Verifica se pode alterar ou eliminar o documento*/
        RUN checkIfDocumentIsDefault (INPUT RowObject.cdn-docto-exp,
                                      OUTPUT lDocumentIsDefault).

        IF lDocumentIsDefault THEN DO:
            /*msg: NÆo ‚ permitido incluir, alterar e excluir registro padrÆo.
              help: NÆo ‚ permitido incluir, alterar e excluir registro padrÆo.*/
            {method/svc/errors/inserr.i
                    &ErrorNumber="53707"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"}
        END.
        ELSE IF pType = "DELETE":U THEN DO:
            /*NÆo permite elimina‡Æo quando possui relacionamento ativo*/
            IF CAN-FIND (FIRST proc-docto-export 
                         WHERE proc-docto-export.idi-tip-docto = RowObject.cdn-docto-exp) THEN DO:
                {utp/ut-table.i mgcex docto-export 1}
                {method/svc/errors/inserr.i
                        &ErrorNumber="3"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="RETURN-VALUE"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodeAndDescription DBOProgram 
PROCEDURE setConstraintCodeAndDescription :
/*------------------------------------------------------------------------------
  Purpose:     Seta as v ri veis utilizadas na query que utiliza 
               faixa de c¢digo e descri‡Æo
  Parameters:  piCdnDoctoExpIni  - C¢digo do Documento de Exporta‡Æo Inicial
               piCdnDoctoExpFim  - C¢digo do Documento de Exporta‡Æo Final
               pcDescDoctoExpIni - Descri‡Æo do Documento de Exporta‡Æo Inicial
               pcDescDoctoExpFim - Descri‡Æo do Documento de Exporta‡Æo Final 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piCdnDoctoExpIni  LIKE docto-export.cdn-docto-exp NO-UNDO.
    DEFINE INPUT PARAMETER piCdnDoctoExpFim  LIKE docto-export.cdn-docto-exp NO-UNDO.
    DEFINE INPUT PARAMETER pcDescDoctoExpIni LIKE docto-export.desc-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pcDescDoctoExpFim LIKE docto-export.desc-docto    NO-UNDO.

    ASSIGN iCdnDoctoExpIni  = piCdnDoctoExpIni  
           iCdnDoctoExpFim  = piCdnDoctoExpFim  
           cDescDoctoExpIni = pcDescDoctoExpIni 
           cDescDoctoExpFim = pcDescDoctoExpFim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH docto-export NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodeAndDescription DBOProgram 
PROCEDURE openQueryCodeAndDescription :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query que utiliza faixa de c¢digo e descri‡Æo
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH docto-export
        WHERE docto-export.cdn-docto-exp >= iCdnDoctoExpIni 
          AND docto-export.cdn-docto-exp <= iCdnDoctoExpFim 
          AND docto-export.desc-docto    >= cDescDoctoExpIni
          AND docto-export.desc-docto    <= cDescDoctoExpFim NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNextCode DBOProgram 
PROCEDURE getNextCode :
/*------------------------------------------------------------------------------
  Purpose:     Busca pr¢xima numera‡Æo para o c¢digo do documento
  Parameters:  piNextNumber - Pr¢ximo n£mero para o c¢digo do documento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER piNextNumber AS INTEGER NO-UNDO.
    FIND LAST bfdocto-export NO-LOCK NO-ERROR.
    IF AVAIL bfdocto-export THEN
        ASSIGN piNextNumber = bfdocto-export.cdn-docto-exp + 1.
    ELSE 
        ASSIGN piNextNumber = 1.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkIfDocumentIsDefault DBOProgram 
PROCEDURE checkIfDocumentIsDefault :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se o documento ‚ padrÆo. Documentos de 1 a 19 sÆo 
               padräes do sistema, por este motivo nÆo podem ser inclu¡dos, 
               eliminados ou terem seu c¢digo e descri‡Æo alterados via programa de cadastro.
  Parameters:  piCdnDoctoExp - C¢digo do documento consultado.
               plDocumentIsDefault - L¢gico que indica se o documento ‚ padrÆo.
  Notes:      
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER piCdnDoctoExp       AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER plDocumentIsDefault AS LOGICAL NO-UNDO.

    ASSIGN plDocumentIsDefault = (piCdnDoctoExp > 0 AND piCdnDoctoExp <= 19).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDocumentDescriptionLiteral DBOProgram
PROCEDURE getDocumentDescriptionLiteral :
    DEFINE INPUT PARAMETER piCdnDoctoExp AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcLiterTraducao AS CHARACTER NO-UNDO.

    ASSIGN pcLiterTraducao = "":U.

    CASE piCdnDoctoExp:
        WHEN 1  THEN ASSIGN pcLiterTraducao = "Outros":U.
        WHEN 2  THEN ASSIGN pcLiterTraducao = "Packing List":U.
        WHEN 3  THEN ASSIGN pcLiterTraducao = "Invoice":U.
        WHEN 4  THEN ASSIGN pcLiterTraducao = "Saque":U.
        WHEN 5  THEN ASSIGN pcLiterTraducao = "Conhecimento":U.
        WHEN 6  THEN ASSIGN pcLiterTraducao = "Conhecimento Master":U.
        WHEN 7  THEN ASSIGN pcLiterTraducao = "Averba‡Æo":U.
        WHEN 8  THEN ASSIGN pcLiterTraducao = "Certificado de Origem":U.
        WHEN 9  THEN ASSIGN pcLiterTraducao = "Certificado de Seguro":U.
        WHEN 10 THEN ASSIGN pcLiterTraducao = "Ap¢lice":U.
        WHEN 11 THEN ASSIGN pcLiterTraducao = "Courier":U.
        WHEN 12 THEN ASSIGN pcLiterTraducao = "Instru‡Æo de Embarque":U.
        WHEN 13 THEN ASSIGN pcLiterTraducao = "Certificado Mercosul Bolivia":U.
        WHEN 14 THEN ASSIGN pcLiterTraducao = "Certificado Mercosul Chile":U.
        WHEN 15 THEN ASSIGN pcLiterTraducao = "Certificado Mercosul II (CO/EQ/VEN)":U.
        WHEN 16 THEN ASSIGN pcLiterTraducao = "Certificado ALADI":U.
        WHEN 17 THEN ASSIGN pcLiterTraducao = "Certificado Form A":U.
        WHEN 18 THEN ASSIGN pcLiterTraducao = "Certificado Comum":U.
        WHEN 19 THEN ASSIGN pcLiterTraducao = "Proforma Invoice Gr fico":U.
    END CASE.

    IF pcLiterTraducao <> ? AND TRIM(pcLiterTraducao) <> "":U THEN DO:
        ASSIGN pcLiterTraducao = REPLACE(TRIM(pcLiterTraducao), " ":U, "_":U).
    END.

RETURN "OK":U.
END PROCEDURE.

  /* _UIB-CODE-BLOCK-END */
  &ANALYZE-RESUME
