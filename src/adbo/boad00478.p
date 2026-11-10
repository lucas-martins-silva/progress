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

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOAD00478
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName nota-fisc-social
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
{adbo/boad00478.i RowObject}
{adbo/boad00478.i tt-nota-fisc-social}

DEFINE TEMP-TABLE tt-item-nota-social NO-UNDO LIKE item-nota-social
    FIELD r-rowid AS ROWID.

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cnpj-subempr":U THEN ASSIGN pFieldValue = RowObject.cnpj-subempr.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-nota-fisc":U THEN ASSIGN pFieldValue = RowObject.cod-nota-fisc.
        WHEN "cod-serie":U THEN ASSIGN pFieldValue = RowObject.cod-serie.
        WHEN "id-arquivo":U THEN ASSIGN pFieldValue = RowObject.id-arquivo.
        WHEN "nr-insc-cno":U THEN ASSIGN pFieldValue = RowObject.nr-insc-cno.
        WHEN "nr-proc-jud":U THEN ASSIGN pFieldValue = RowObject.nr-proc-jud.
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
        WHEN "dt-emis-nota":U THEN ASSIGN pFieldValue = RowObject.dt-emis-nota.
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
        WHEN "nr-cno":U THEN ASSIGN pFieldValue = RowObject.nr-cno.
        WHEN "seq-esocial":U THEN ASSIGN pFieldValue = RowObject.seq-esocial.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "vl-adicional[1]":U THEN ASSIGN pFieldValue = RowObject.vl-adicional[1].
        WHEN "vl-adicional[2]":U THEN ASSIGN pFieldValue = RowObject.vl-adicional[2].
        WHEN "vl-adicional[3]":U THEN ASSIGN pFieldValue = RowObject.vl-adicional[3].
        WHEN "vl-base-coop":U THEN ASSIGN pFieldValue = RowObject.vl-base-coop.
        WHEN "vl-base-retencao":U THEN ASSIGN pFieldValue = RowObject.vl-base-retencao.
        WHEN "vl-bruto":U THEN ASSIGN pFieldValue = RowObject.vl-bruto.
        WHEN "vl-comercializacao":U THEN ASSIGN pFieldValue = RowObject.vl-comercializacao.
        WHEN "vl-deducao":U THEN ASSIGN pFieldValue = RowObject.vl-deducao.
        WHEN "vl-mat-equip":U THEN ASSIGN pFieldValue = RowObject.vl-mat-equip.
        WHEN "vl-nao-retido":U THEN ASSIGN pFieldValue = RowObject.vl-nao-retido.
        WHEN "vl-ret-apurada":U THEN ASSIGN pFieldValue = RowObject.vl-ret-apurada.
        WHEN "vl-ret-subempr":U THEN ASSIGN pFieldValue = RowObject.vl-ret-subempr.
        WHEN "vl-retido":U THEN ASSIGN pFieldValue = RowObject.vl-retido.
        WHEN "vl-servicos":U THEN ASSIGN pFieldValue = RowObject.vl-servicos.
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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "idi-obra":U THEN ASSIGN pFieldValue = RowObject.idi-obra.
        WHEN "idi-origem":U THEN ASSIGN pFieldValue = RowObject.idi-origem.
        WHEN "idi-tip-dado":U THEN ASSIGN pFieldValue = RowObject.idi-tip-dado.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-romaneio":U THEN ASSIGN pFieldValue = RowObject.num-romaneio.
        WHEN "num-seq":U THEN ASSIGN pFieldValue = RowObject.num-seq.
        WHEN "seq-wt-docto":U THEN ASSIGN pFieldValue = RowObject.seq-wt-docto.
        WHEN "tp-comercial":U THEN ASSIGN pFieldValue = RowObject.tp-comercial.
        WHEN "tp-insc-cno":U THEN ASSIGN pFieldValue = RowObject.tp-insc-cno.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice ch-seq-esoc
  Parameters:  
               retorna valor do campo seq-esocial
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pseq-esocial LIKE nota-fisc-social.seq-esocial NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pseq-esocial = RowObject.seq-esocial.

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
        WHEN "ind-ativid-subst":U THEN ASSIGN pFieldValue = RowObject.ind-ativid-subst.
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
  Purpose:     Reposiciona registro com base no ¡ndice ch-seq-esoc
  Parameters:  
               recebe valor do campo seq-esocial
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pseq-esocial LIKE nota-fisc-social.seq-esocial NO-UNDO.

    FIND FIRST bfnota-fisc-social WHERE 
        bfnota-fisc-social.seq-esocial = pseq-esocial NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfnota-fisc-social THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfnota-fisc-social)).
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
    
    DEFINE INPUT PARAMETER pType    AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    DEFINE VARIABLE c-texto1 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-texto2 AS CHARACTER NO-UNDO.

    IF pType = "4420" THEN DO:

        IF RowObject.vl-deducao > RowObject.vl-bruto THEN DO:
            {utp/ut-liter.i "Valor_Dedu‡äes"}
            ASSIGN c-texto1 = RETURN-VALUE.
            {utp/ut-liter.i "Valor_Bruto"}
            ASSIGN c-texto2 = RETURN-VALUE.

            {method/svc/errors/inserr.i
                    &ErrorNumber="1208"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-texto1 + '~~~~' + c-texto2"} 
        END.
                                       
        IF RowObject.cnpj-subempr <> ""
        AND RowObject.vl-ret-subempr > RowObject.vl-ret-apurada THEN DO:
            {utp/ut-liter.i "Valor_Reten‡Æo_SubEmpreitada"}
            ASSIGN c-texto1 = RETURN-VALUE.
            {utp/ut-liter.i "Valor_Reten‡Æo_Apurada"}
            ASSIGN c-texto2 = RETURN-VALUE.

            {method/svc/errors/inserr.i
                    &ErrorNumber="1208"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-texto1 + '~~~~' + c-texto2"} 
        END.
    
        IF (RowObject.vl-adicional[1] + 
            RowObject.vl-adicional[2] +
            RowObject.vl-adicional[3]) > 0
        AND
           (RowObject.vl-adicional[1] + 
            RowObject.vl-adicional[2] +
            RowObject.vl-adicional[3]) > RowObject.vl-base-retencao THEN DO:

            {utp/ut-liter.i "Valor_Adicional"}
            ASSIGN c-texto1 = RETURN-VALUE.
            {utp/ut-liter.i "Valor_Base_Reten‡Æo"}
            ASSIGN c-texto2 = RETURN-VALUE.

            {method/svc/errors/inserr.i
                    &ErrorNumber="1208"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-texto1 + '~~~~' + c-texto2"} 
        END.

        IF  RowObject.nr-proc-jud <> ""
        AND RowObject.vl-nao-retido > (RowObject.vl-adicional[1] 
                                    + RowObject.vl-adicional[2] 
                                    + RowObject.vl-adicional[3]
                                    + RowObject.vl-retido)THEN DO:

            {utp/ut-liter.i "Valor_NÆo_Retido"}
            ASSIGN c-texto1 = RETURN-VALUE.
            {utp/ut-liter.i "a_soma_dos_campos_Valor_Reten‡Æo_mais_Valor_Adicional"}
            ASSIGN c-texto2 = RETURN-VALUE.

            {method/svc/errors/inserr.i
                    &ErrorNumber="1208"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-texto1 + '~~~~' + c-texto2"} 
        END.

        IF  RowObject.cnpj-subempr <> ""
        AND RowObject.vl-ret-subempr = 0 THEN DO:
            {utp/ut-liter.i "Valor_Retido_SubEmpreitada"}
            ASSIGN c-texto1 = RETURN-VALUE.            
            {method/svc/errors/inserr.i
                    &ErrorNumber="4241"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-texto1"} 
        END.
        IF  RowObject.cnpj-subempr = ""
        AND RowObject.vl-ret-subempr > 0 THEN DO:
            {utp/ut-liter.i "CNPJ_SubEmpreiteiro"}
            ASSIGN c-texto1 = RETURN-VALUE.            
            {method/svc/errors/inserr.i
                    &ErrorNumber="4241"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-texto1"} 
        END.
        
        IF  RowObject.nr-proc-jud <> ""
        AND RowObject.vl-nao-retido = 0 THEN DO:
            {utp/ut-liter.i "Valor_NÆo_Retido"}
            ASSIGN c-texto1 = RETURN-VALUE.            
            {method/svc/errors/inserr.i
                    &ErrorNumber="4241"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-texto1"} 
        END.

        IF  RowObject.nr-proc-jud = ""
        AND RowObject.vl-nao-retido > 0 THEN DO:
            {utp/ut-liter.i "Nr_Processo_Judicial"}
            ASSIGN c-texto1 = RETURN-VALUE.            
            {method/svc/errors/inserr.i
                    &ErrorNumber="4241"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-texto1"} 
        END.
    END.

    IF pType = "4440" THEN DO:
        IF RowObject.vl-deducao > RowObject.vl-servicos THEN DO:
            {utp/ut-liter.i "Valor_Dedu‡Æo"}
            ASSIGN c-texto1 = RETURN-VALUE.
            {utp/ut-liter.i "Valor_do_Servi‡o"}
            ASSIGN c-texto2 = RETURN-VALUE.

            {method/svc/errors/inserr.i
                    &ErrorNumber="1208"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-texto1 + '~~~~' + c-texto2"} 
        END.

        IF (RowObject.vl-adicional[1] +
            RowObject.vl-adicional[2] +
            RowObject.vl-adicional[3]) > RowObject.vl-base-coop THEN DO:
            {utp/ut-liter.i "As_somas_dos_Valores_de_Servi‡os"}
            ASSIGN c-texto1 = RETURN-VALUE.
            {utp/ut-liter.i "Valor_Base_Cooperativa"}
            ASSIGN c-texto2 = RETURN-VALUE.

            {method/svc/errors/inserr.i
                    &ErrorNumber="1208"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-texto1 + '~~~~' + c-texto2"} 
        END.
    END.    

    IF pType = "4460" THEN DO:
        IF RowObject.vl-retido > RowObject.vl-comercializacao THEN DO:
            {utp/ut-liter.i "Valor_Retido_Prod_Rural"}
            ASSIGN c-texto1 = RETURN-VALUE.
            {utp/ut-liter.i "Valor_Comercializa‡Æo"}
            ASSIGN c-texto2 = RETURN-VALUE.

            {method/svc/errors/inserr.i
                    &ErrorNumber="1208"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-texto1 + '~~~~' + c-texto2"} 
        END.
    END.

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateCodNotaFisc DBOProgram 
PROCEDURE updateCodNotaFisc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-seq-wt-docto AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-serie        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-emitente AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-c-nr-nota    AS CHARACTER NO-UNDO.

    DEFINE VARIABLE h-boad00479 AS HANDLE NO-UNDO.

    IF NOT VALID-HANDLE(h-boad00479) THEN
        RUN adbo/boad00479.p PERSISTENT SET h-boad00479.

    FOR FIRST nota-fisc-social
        WHERE nota-fisc-social.idi-origem   = 1
          AND nota-fisc-social.cod-estabel  = p-cod-estabel
          AND nota-fisc-social.cod-serie    = p-serie
          AND nota-fisc-social.seq-wt-docto = p-seq-wt-docto
          AND nota-fisc-social.cod-emitente = p-cod-emitente NO-LOCK:
            EMPTY TEMP-TABLE tt-nota-fisc-social.
            CREATE tt-nota-fisc-social.
            BUFFER-COPY nota-fisc-social TO tt-nota-fisc-social.
    END.

    FOR FIRST tt-nota-fisc-social:
        ASSIGN tt-nota-fisc-social.cod-nota-fisc = p-c-nr-nota
               tt-nota-fisc-social.idi-origem    = 2.
    END.

    IF AVAIL tt-nota-fisc-social THEN DO:
        RUN openQueryStatic(INPUT "Main").
        RUN emptyRowErrors.
        RUN goToKey        (INPUT tt-nota-fisc-social.seq-esocial).
        RUN setRecord      (INPUT TABLE tt-nota-fisc-social).
        RUN updateRecord.
        RUN getRowErrors   (OUTPUT TABLE RowErrors).

        IF CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.ErrorType   <> "INTERNAL":U
                      AND RowErrors.ErrorSubType = "Error":U) THEN DO:
            RETURN "NOK".
        END.

        FOR EACH  item-nota-social
            WHERE item-nota-social.seq-esocial = tt-nota-fisc-social.seq-esocial:

            EMPTY TEMP-TABLE tt-item-nota-social.
            CREATE tt-item-nota-social.
            BUFFER-COPY item-nota-social TO tt-item-nota-social.

            ASSIGN tt-item-nota-social.cod-nota-fisc = p-c-nr-nota.

            RUN openQueryStatic IN h-boad00479(INPUT "Main").
            RUN emptyRowErrors  IN h-boad00479.
            RUN goToKey         IN h-boad00479(INPUT tt-item-nota-social.seq-esocial,
                                               INPUT tt-item-nota-social.nr-seq-item).
            RUN setRecord       IN h-boad00479(INPUT TABLE tt-item-nota-social).
            RUN updateRecord    IN h-boad00479.
            RUN getRowErrors    IN h-boad00479(OUTPUT TABLE RowErrors).
            
            IF CAN-FIND(FIRST RowErrors
                        WHERE RowErrors.ErrorType   <> "INTERNAL":U
                          AND RowErrors.ErrorSubType = "Error":U) THEN DO:
                RETURN "NOK".
            END.
        END.
    END.

    IF VALID-HANDLE(h-boad00479) THEN DO:
        DELETE PROCEDURE h-boad00479.
        ASSIGN h-boad00479 = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
