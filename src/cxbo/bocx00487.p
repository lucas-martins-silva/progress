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
{include/i-prgvrs.i BOCX00487 1.00.00.009} /*** "010009" 16/12/2025 13:48:13 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX00487
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName duimp-siscomex
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

{utp/ut-glob.i} /*Definiá∆o de vari†veis globais do sistema*/

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
{cxbo/bocx00487.i RowObject}
{cxbo/bocx383.i tt-decla-import}
{inbo/boin090.i tt-docum-est}
DEFINE TEMP-TABLE RowErrorsAux NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE de-cdd-duimp-dts         LIKE duimp-siscomex.cod-duimp-dts NO-UNDO.
DEFINE VARIABLE de-cdd-duimp-dts-ini     LIKE duimp-siscomex.cod-duimp-dts NO-UNDO.
DEFINE VARIABLE de-cdd-duimp-dts-fim     LIKE duimp-siscomex.cod-duimp-dts NO-UNDO.
DEFINE VARIABLE c-cod-duimp-siscomex-ini LIKE duimp-siscomex.cod-duimp-siscomex NO-UNDO.
DEFINE VARIABLE c-cod-duimp-siscomex-fim LIKE duimp-siscomex.cod-duimp-siscomex NO-UNDO.
DEFINE VARIABLE c-cod-estabel-ini        LIKE duimp-siscomex.cod-estabel NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim        LIKE duimp-siscomex.cod-estabel NO-UNDO.
DEFINE VARIABLE d-dt-criacao-ini         LIKE duimp-siscomex.dtz-create NO-UNDO.
DEFINE VARIABLE d-dt-criacao-fim         LIKE duimp-siscomex.dtz-create NO-UNDO.
DEFINE VARIABLE c-lbl-msg                AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lbl-msg1               AS CHARACTER NO-UNDO.
DEFINE VARIABLE h-bocx383 AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-lbl-traducao AS CHARACTER   NO-UNDO.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    FOR EACH decla-import
       WHERE decla-import.num-di-ems = int(RowObject.cod-duimp-dts)
         AND decla-import.cdd-siscomex-dts = RowObject.cdd-siscomex-dts EXCLUSIVE-LOCK:
        DELETE decla-import.
    END.

    RELEASE decla-import.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    RUN piAtualizaDeclaImport.
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    RUN piAtualizaDeclaImport.
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

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
        WHEN "chave-acesso":U THEN ASSIGN pFieldValue = RowObject.chave-acesso.
        WHEN "cod-duimp-siscomex":U THEN ASSIGN pFieldValue = RowObject.cod-duimp-siscomex.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-identific-carga":U THEN ASSIGN pFieldValue = RowObject.cod-identific-carga.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-usuar":U THEN ASSIGN pFieldValue = RowObject.cod-usuar.
        WHEN "des-inform-compl":U THEN ASSIGN pFieldValue = RowObject.des-inform-compl.
        WHEN "des-pais-proced":U THEN ASSIGN pFieldValue = RowObject.des-pais-proced.
        WHEN "end-importador":U THEN ASSIGN pFieldValue = RowObject.end-importador.
        WHEN "ni-importador":U THEN ASSIGN pFieldValue = RowObject.ni-importador.
        WHEN "cod-pais-iso":U THEN ASSIGN pFieldValue = RowObject.cod-pais-iso.        
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
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
        WHEN "data-cotacao":U THEN ASSIGN pFieldValue = RowObject.data-cotacao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram  
PROCEDURE getDateTimeField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATETIME-TZ NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dtz-create":U THEN ASSIGN pFieldValue = RowObject.dtz-create.
        WHEN "dtz-reg-siscomex":U THEN ASSIGN pFieldValue = RowObject.dtz-reg-siscomex.
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
        WHEN "cod-duimp-dts":U THEN ASSIGN pFieldValue = RowObject.cod-duimp-dts.
        WHEN "peso-liq-carga":U THEN ASSIGN pFieldValue = RowObject.peso-liq-carga.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "vlr-frete-moeda":U THEN ASSIGN pFieldValue = RowObject.vlr-frete-moeda.
        WHEN "vlr-seguro-moeda":U THEN ASSIGN pFieldValue = RowObject.vlr-seguro-moeda.
        WHEN "vlr-tot-frete":U THEN ASSIGN pFieldValue = RowObject.vlr-tot-frete.
        WHEN "vlr-tot-frete-me":U THEN ASSIGN pFieldValue = RowObject.vlr-tot-frete-me.
        WHEN "vlr-tot-seguro":U THEN ASSIGN pFieldValue = RowObject.vlr-tot-seguro.
        WHEN "vlr-tot-seguro-me":U THEN ASSIGN pFieldValue = RowObject.vlr-tot-seguro-me.
        WHEN "cdd-siscomex-dts":U THEN ASSIGN pFieldValue = RowObject.cdd-siscomex-dts.
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
        WHEN "cdn-importador":U THEN ASSIGN pFieldValue = RowObject.cdn-importador.
        WHEN "cdn-urf-despch":U THEN ASSIGN pFieldValue = RowObject.cdn-urf-despch.
        WHEN "idi-sit-retific":U THEN ASSIGN pFieldValue = RowObject.idi-sit-retific.
        WHEN "idi-sit-siscomex":U THEN ASSIGN pFieldValue = RowObject.idi-sit-siscomex.
        WHEN "mot-esp-despacho":U THEN ASSIGN pFieldValue = RowObject.mot-esp-despacho.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-versao-duimp":U THEN ASSIGN pFieldValue = RowObject.num-versao-duimp.
        WHEN "tipo-importador":U THEN ASSIGN pFieldValue = RowObject.tipo-importador.
        WHEN "tp-identific-carga":U THEN ASSIGN pFieldValue = RowObject.tp-identific-carga.
        WHEN "moeda-frete":U THEN ASSIGN pFieldValue = RowObject.moeda-frete.
        WHEN "moeda-seguro":U THEN ASSIGN pFieldValue = RowObject.moeda-seguro.
        WHEN "cdn-pais":U THEN ASSIGN pFieldValue = RowObject.cdn-pais.
        WHEN "cdn-moed-siscomex-frete":U THEN ASSIGN pFieldValue = RowObject.cdn-moed-siscomex-frete.
        WHEN "cdn-moed-siscomex-seguro":U THEN ASSIGN pFieldValue = RowObject.cdn-moed-siscomex-seguro.        
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice id1-chave
  Parameters:  
               retorna valor do campo cod-duimp-dts
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-duimp-dts LIKE duimp-siscomex.cod-duimp-dts NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-duimp-dts = RowObject.cod-duimp-dts.

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
        WHEN "log-mercosul":U THEN ASSIGN pFieldValue = RowObject.log-mercosul.
        WHEN "sit-esp-despacho":U THEN ASSIGN pFieldValue = RowObject.sit-esp-despacho.
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
  Purpose:     Reposiciona registro com base no °ndice id1-chave
  Parameters:  
               recebe valor do campo cod-duimp-dts
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-duimp-dts LIKE duimp-siscomex.cod-duimp-dts NO-UNDO.

    FIND FIRST bfduimp-siscomex WHERE 
        bfduimp-siscomex.cod-duimp-dts = pcod-duimp-dts NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfduimp-siscomex THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfduimp-siscomex)).
    IF RETURN-VALUE = "NOK":U THEN
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
    
    DEFINE INPUT PARAMETER pType     AS CHARACTER NO-UNDO.

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    IF  pType = "CREATE":U THEN DO:
        IF  RowObject.cod-duimp-dts = 0 THEN DO:
            {utp/ut-liter.i N£mero_Interno_da_DUIMP *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="1491"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
        ELSE
        IF  CAN-FIND(FIRST bfduimp-siscomex 
                     WHERE bfduimp-siscomex.cod-duimp-dts = RowObject.cod-duimp-dts) THEN DO:
            {utp/ut-liter.i Declaraá∆o_Ènica_de_Importaá∆o *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="8"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
    END.

    IF  RowObject.cod-duimp-siscomex <> "":U THEN DO:
        IF CAN-FIND(FIRST bfduimp-siscomex 
                    WHERE bfduimp-siscomex.cod-duimp-dts <> RowObject.cod-duimp-dts
                      AND bfduimp-siscomex.cod-duimp-siscomex = RowObject.cod-duimp-siscomex) THEN DO:
            {utp/ut-liter.i "C¢digo_DUIMP_Siscomex" *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="8"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
        IF  RowObject.dtz-reg-siscomex = ? THEN DO: /*Data de Registro da DUIMP no Siscomex*/
            {utp/ut-liter.i Data_de_Registro_da_DUIMP_no_Siscomex *}
            ASSIGN c-lbl-msg1 = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Quando_informado_o_N£mero_da_DUIMP_do_SISCOMEX_≤_obrigat¢rio_informar_a_Data_do_seu_registro *}
            {method/svc/errors/inserr.i
                   &ErrorNumber="56116"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters="c-lbl-msg1 + '~~~~' + RETURN-VALUE "}
        END.
    END.    
    
    IF  RowObject.cod-estabel = "":U THEN DO:
        {utp/ut-liter.i Estabelecimento *}
        {method/svc/errors/inserr.i
                &ErrorNumber="265"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="RETURN-VALUE"}
    END.
    ELSE DO:
        IF  NOT CAN-FIND(FIRST estabelec
                         WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            {utp/ut-liter.i Estabelecimento *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
    END.

    /* Importador */
    IF  RowObject.cdn-importador = 0 THEN DO:
        {utp/ut-liter.i Importador *}
        {method/svc/errors/inserr.i
                &ErrorNumber="265"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="RETURN-VALUE"}        
    END.
    ELSE DO:
        IF NOT CAN-FIND(FIRST emitente NO-LOCK
                        WHERE emitente.cod-emitente = RowObject.cdn-importador
                        AND   emitente.identific   <> 1 /* Cliente */) THEN DO:
            {utp/ut-liter.i Importador *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
    END.

    /*Local de Despacho*/
    IF RowObject.cdn-urf-despch = 0 THEN DO:
        {utp/ut-liter.i Unidade_da_RFB_para_Despacho *} 
        {method/svc/errors/inserr.i
                &ErrorNumber="265"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="RETURN-VALUE"}

    END.
    ELSE DO:
        IF NOT CAN-FIND(FIRST unid-rf 
                        WHERE unid-rf.cdn-unid-recta-feder = RowObject.cdn-urf-despch) THEN DO:
            {utp/ut-liter.i Unidade_da_RFB_para_Despacho *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
    END.        
    
    /* Pa°s Procedància */
    IF  RowObject.cdn-pais <> 0 THEN DO:
        IF  NOT CAN-FIND(FIRST pais NO-LOCK
                         WHERE pais.cod-pais = RowObject.cdn-pais) THEN DO:
            {utp/ut-liter.i Pa°s_Procedància *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
    END.

    IF pType = "create":U AND RowObject.nat-operacao = "" THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="52132" &ErrorType="EMS" &ErrorParameters="''"}
    END.
    ELSE DO:
        
        /* Declaracao de Importacao nao tem natureza de operacao quando seus embarques possuem naturezas diferentes enrte si */
        IF RowObject.nat-operacao <> "" AND
        NOT CAN-FIND(FIRST natur-oper
                     WHERE natur-oper.nat-operacao = RowObject.nat-operacao) THEN DO:
            
            {utp/ut-liter.i "Natureza_Operacaá∆o" *}
            {method/svc/errors/inserr.i &ErrorNumber="2" &ErrorType="EMS" &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.
    END.
    
    IF  pType = "DELETE":U THEN DO:    
        IF CAN-FIND(FIRST duimp-docto NO-LOCK
                    WHERE duimp-docto.cod-duimp-dts = RowObject.cod-duimp-dts) THEN DO:
            {utp/ut-liter.i Declaraá∆o_Ènica_de_Importaá∆o *}
            ASSIGN c-lbl-msg = RETURN-VALUE.
            {utp/ut-liter.i de_Documentos_da_DUIMP *}
            ASSIGN c-lbl-msg1 = RETURN-VALUE.            
            {method/svc/errors/inserr.i
                    &ErrorNumber="5"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-lbl-msg + '~~~~' + c-lbl-msg1"}
        END.
                     
        IF CAN-FIND(FIRST duimp-item NO-LOCK
                    WHERE duimp-item.cod-duimp-dts    = RowObject.cod-duimp-dts) THEN DO:
            {utp/ut-liter.i Declaraá∆o_Ènica_de_Importaá∆o *}
            ASSIGN c-lbl-msg = RETURN-VALUE.
            {utp/ut-liter.i Itens_da_DUIMP *}
            ASSIGN c-lbl-msg1 = RETURN-VALUE.            
            {method/svc/errors/inserr.i
                    &ErrorNumber="5"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-lbl-msg + '~~~~' + c-lbl-msg1"}
        END.
        
        FIND FIRST decla-import 
            WHERE decla-import.num-di-ems       = int(RowObject.cod-duimp-dts)
              AND decla-import.cdd-siscomex-dts = RowObject.cod-duimp-dts NO-LOCK NO-ERROR.
        IF  AVAIL decla-import THEN DO:

            FIND FIRST decla-import-embarq
                 WHERE decla-import-embarq.num-di-ems       = decla-import.num-di-ems
                   AND decla-import-embarq.cdd-siscomex-dts = decla-import.cdd-siscomex-dts NO-LOCK NO-ERROR.
             IF AVAIL decla-import-embarq THEN DO:
                {utp/ut-liter.i "N∆o_Ç_poss°vel_excluir_Declaraá∆o_Ènica_de_Importaá∆o" *}
                ASSIGN c-lbl-traducao = TRIM(RETURN-VALUE).
                {utp/ut-liter.i "N∆o_Ç_poss°vel_excluir_Declaraá∆o_Ènica_de_Importaá∆o_pois_existe_embarques_vinculados" *}

                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorParameters="c-lbl-traducao + '!' + '~~~~' + TRIM(RETURN-VALUE) + '!'"}
            END.
        END.
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query com todos os registros da tabela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryData DBOProgram 
PROCEDURE openQueryData :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query a partir do campo "Data de Criaá∆o" e "Estabelecimento"
               Filtrados pelo programa de pesquisa z01cx00458
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                               WHERE {&TABLENAME}.cod-estabel >= c-cod-estabel-ini
                                 AND {&TABLENAME}.cod-estabel <= c-cod-estabel-fim 
                                 AND {&TABLENAME}.dtz-create  >= d-dt-criacao-ini 
                                 AND {&TABLENAME}.dtz-create  <= d-dt-criacao-fim NO-LOCK 
                                  BY {&TABLENAME}.dtz-create
                                  BY {&TABLENAME}.cod-estabel INDEXED-REPOSITION.
                                 
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDUIMP DBOProgram 
PROCEDURE openQueryDUIMP :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query a partir do campo "DUIMP Interno" e "DUIMP Siscomex" 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                               WHERE {&TABLENAME}.cod-duimp-dts      >= de-cdd-duimp-dts-ini
                                 AND {&TABLENAME}.cod-duimp-dts      <= de-cdd-duimp-dts-fim
                                 AND {&TABLENAME}.cod-duimp-siscomex >= c-cod-duimp-siscomex-ini
                                 AND {&TABLENAME}.cod-duimp-siscomex <= c-cod-duimp-siscomex-fim NO-LOCK 
                                  BY {&TABLENAME}.cod-duimp-dts INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintData DBOProgram 
PROCEDURE setConstraintData :
/*------------------------------------------------------------------------------
  Purpose:     Recebe os parÉmetros para abertura da query "Data"
  Parameters:  Entrada: pc-cod-estabel-ini (character): C¢digo inicial do Estabelecimento
               Entrada: pc-cod-estabel-fim (character): C¢digo final do Estabelecimento
               Entrada: pd-dt-criacao-ini (date): Data Inicial de Criaá∆o do registro no sistema
               Entrada: pd-dt-criacao-fim (date): Data Final de Criaá∆o do registro no sistema
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-estabel-ini LIKE duimp-siscomex.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel-fim LIKE duimp-siscomex.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pd-dt-criacao-ini    AS DATE                       NO-UNDO.
    DEFINE INPUT PARAMETER pd-dt-criacao-fim    AS DATE                       NO-UNDO.
    
    ASSIGN c-cod-estabel-ini = pc-cod-estabel-ini
           c-cod-estabel-fim = pc-cod-estabel-fim
           d-dt-criacao-ini  = datetime-tz(pd-dt-criacao-ini, 0, TIMEZONE)
           d-dt-criacao-fim  = datetime-tz(pd-dt-criacao-fim, 86399999, TIMEZONE). 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDUIMP DBOProgram 
PROCEDURE setConstraintDUIMP :
/*------------------------------------------------------------------------------
  Purpose:     Recebe os parÉmetros para abertura da query "DUIMP"
  Parameters:  Entrada: pde-cdd-duimp-dts-ini (decimal): C¢digo inicial do DUIMP Interno
               Entrada: pde-cdd-duimp-dts-fim (decimal): C¢digo final do DUIMP Interno
               Entrada: pc-cod-duimp-siscomex-ini (character): C¢digo inicial da DUIMP registrada no Siscomex
               Entrada: pc-cod-duimp-siscomex-fim (character): C¢digo final da DUIMP registrada no Siscomex
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pde-cdd-duimp-dts-ini     LIKE duimp-siscomex.cod-duimp-dts      NO-UNDO.
    DEFINE INPUT PARAMETER pde-cdd-duimp-dts-fim     LIKE duimp-siscomex.cod-duimp-dts      NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-duimp-siscomex-ini LIKE duimp-siscomex.cod-duimp-siscomex NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-duimp-siscomex-fim LIKE duimp-siscomex.cod-duimp-siscomex NO-UNDO.

    ASSIGN de-cdd-duimp-dts-ini     = pde-cdd-duimp-dts-ini    
           de-cdd-duimp-dts-fim     = pde-cdd-duimp-dts-fim    
           c-cod-duimp-siscomex-ini = pc-cod-duimp-siscomex-ini
           c-cod-duimp-siscomex-fim = pc-cod-duimp-siscomex-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDuimpByKey DBOProgram 
PROCEDURE openQueryDuimpByKey :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query a partir do campo "DUIMP Interna" 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                               WHERE {&TABLENAME}.cod-duimp-dts = de-cdd-duimp-dts NO-LOCK 
                                  BY {&TABLENAME}.cod-duimp-dts INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDuimpPKey DBOProgram 
PROCEDURE setConstraintDuimpPKey :
/*------------------------------------------------------------------------------
  Purpose:     Recebe os parÉmetros para abertura da query "DUIMP"
  Parameters:  Entrada: pde-cdd-duimp-dts (decimal): C¢digo da DUIMP Interno
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pde-cdd-duimp-dts LIKE duimp-siscomex.cod-duimp-dts NO-UNDO.

    ASSIGN de-cdd-duimp-dts = pde-cdd-duimp-dts.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Respons†vel por atualizar informaá‰es na tabela antes da 
               criaá∆o do registro
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piProximaDUIMP DBOProgram 
PROCEDURE piProximaDUIMP :
/*------------------------------------------------------------------------------
  Purpose:     Sugere proxima numeracao do codigo da DUIMP Interno
  Parameters:  Sa°da p-cod-duimp-dts: proxima numeracao sugerida pelo sistema
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-cod-duimp-dts LIKE bf{&TableName}.cod-duimp-dts NO-UNDO.
                
    FIND LAST bf{&TableName} NO-LOCK NO-ERROR.
    IF NOT AVAIL bf{&TableName} THEN
       ASSIGN p-cod-duimp-dts = 1.
    ELSE 
        ASSIGN p-cod-duimp-dts = bf{&TableName}.cod-duimp-dts + 1.

    IF p-cod-duimp-dts > 9999999999999999 THEN
       ASSIGN p-cod-duimp-dts = 1.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodigo DBOProgram 
PROCEDURE findCodigo :
/*------------------------------------------------------------------------------
  Purpose:     Procura pelo indice, caso nao ache retorna mensagem de erro padrao do EMS
  Parameters:  Sa°da p-return
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-duimp-dts LIKE bf{&TableName}.cod-duimp-dts NO-UNDO.
    DEFINE OUTPUT PARAMETER c-return AS CHAR NO-UNDO.
    RUN startMethod ("find").
 
    FIND duimp-siscomex NO-LOCK 
        WHERE duimp-siscomex.cod-duimp-dts = p-cod-duimp-dts NO-ERROR.
    IF  NOT AVAIL duimp-siscomex then do:
        {utp/ut-table.i mgcex duimp-siscomex 1}
        RUN utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        ASSIGN c-return = RETURN-VALUE.
    END.
    ELSE DO:
        RUN setCurrent.
    END.
    run endMethod ("find").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDoctoRecebimento DBOProgram 
PROCEDURE piDoctoRecebimento :
/*-----------------------------------------------------------------------------------
  Purpose: Existe um campo na docum-est para a declaraá∆o de importaá∆o, sendo assim,
           deve ser feita a busca na tabela para verificar se j† tem n£mero da DUIMP
  Notes:       
-------------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pcod-duimp-siscomex  LIKE {&TableName}.cod-duimp-siscomex NO-UNDO.
    DEFINE OUTPUT PARAMETER plog-encontrou       AS   LOGICAL                         NO-UNDO.

    IF pcod-duimp-siscomex <> "" THEN DO:
        IF CAN-FIND(FIRST docum-est
                    WHERE docum-est.declaracao-import = pcod-duimp-siscomex) 
        THEN ASSIGN plog-encontrou = YES.
        ELSE ASSIGN plog-encontrou = NO.
    END.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-doc-relacs DBOProgram 
PROCEDURE pi-busca-doc-relacs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pr-decla-import AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-docum-est.
    
    EMPTY TEMP-TABLE tt-docum-est.
    
    FOR FIRST decla-import NO-LOCK
        WHERE ROWID(decla-import) = pr-decla-import : END.
    
    IF NOT AVAIL decla-import OR decla-import.cod-di-siscomex = "" THEN
        RETURN "NOK":U.
    
    FOR EACH docum-est NO-LOCK
        WHERE docum-est.declaracao-import = decla-import.cod-di-siscomex:
        CREATE tt-docum-est.
        BUFFER-COPY docum-est TO tt-docum-est.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetTT-decla-import DBOProgram 
PROCEDURE piSetTT-decla-import :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM TABLE FOR tt-decla-import.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaDeclaImport DBOProgram 
PROCEDURE piAtualizaDeclaImport :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE l-create AS LOGICAL NO-UNDO.
    
    IF NOT VALID-HANDLE(h-bocx383) THEN DO:
        RUN cxbo/bocx383.p PERSISTENT SET h-bocx383.
    END.
    EMPTY TEMP-TABLE RowErrorsAux.

    FIND FIRST tt-decla-import /*NO-LOCK*/ NO-ERROR.
    IF  AVAIL tt-decla-import THEN DO:

        RUN emptyRowObject  IN h-bocx383.
        RUN openQueryStatic IN h-bocx383 (INPUT "Main":U) NO-ERROR.
        RUN emptyRowErrors  IN h-bocx383.
        RUN goToKey         IN h-bocx383 (INPUT tt-decla-import.num-di-ems,
                                          INPUT tt-decla-import.num-seq-retif, 
                                          INPUT tt-decla-import.cdd-siscomex-dts). 
                                          
        ASSIGN l-create = IF RETURN-VALUE = "NOK":U THEN YES ELSE NO.
        IF l-create THEN DO:
            RUN setRecord       IN h-bocx383 (INPUT TABLE tt-decla-import).
            RUN validateRecord  IN h-bocx383 (INPUT "CREATE":U).    
        END.
        ELSE DO:
            RUN setRecord       IN h-bocx383 (INPUT TABLE tt-decla-import).
            RUN validateRecord  IN h-bocx383 (INPUT "UPDATE":U).
        END.

        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN getRowErrors    IN h-bocx383 (OUTPUT TABLE RowErrorsAux APPEND).
            FOR EACH RowErrorsAux:
                CREATE RowErrors.
                BUFFER-COPY rowErrorsAux TO RowErrors.
            END.
        END.
        ELSE DO:
            IF  l-create THEN
                RUN createRecord IN h-bocx383.
            ELSE  
                RUN updateRecord IN h-bocx383.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
