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
{include/i-prgvrs.i BOCX380 2.00.00.012 } /*** "010012" 07/10/2024 16:59:57 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bocx380 MUT}
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

{cdp/cdcfgdis.i} /*  definiá∆o de prÇ-processadores distribuiá∆o */

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX380
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName proces-export-concil-despes
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
{cxbo/bocx380.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF TEMP-TABLE tt-proc-exp-concil-desp-ap NO-UNDO
    FIELD cod-despesa  LIKE proc-desp-itiner.cod-desp
    FIELD des-despesa    AS char format "x(30)" LABEL "Descriá∆o"
    FIELD cod-classif  LIKE proc-desp-itiner.classif-despesa
    FIELD val-despesa  LIKE proc-desp-itiner.val-desp
    FIELD log-provisao   AS LOG LABEL "Previs∆o".

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
         HEIGHT             = 4.96
         WIDTH              = 32.43.
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
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Somente ir† eliminar os impostos ap¢s a eliminaá∆o da £ltima despesa 
     * vinculada ao processo de conciliaá∆o */
    IF  NOT CAN-FIND(FIRST {&TableName} NO-LOCK
                     WHERE {&TableName}.cod-estabel  = RowObject.cod-estabel
                       AND {&TableName}.nr-proc-exp  = RowObject.nr-proc-exp
                       AND {&TableName}.cod-emitente = RowObject.cod-emitente
                       AND {&TableName}.cod-tit-ap   = RowObject.cod-tit-ap) THEN DO:
        
        FOR EACH  proces-export-concil-impto EXCLUSIVE-LOCK
            WHERE proces-export-concil-impto.cod-estabel  = RowObject.cod-estabel
              AND proces-export-concil-impto.nr-proc-exp  = RowObject.nr-proc-exp
              AND proces-export-concil-impto.cod-emitente = RowObject.cod-emitente
              AND proces-export-concil-impto.cod-tit-ap   = RowObject.cod-tit-ap:
            DELETE proces-export-concil-impto.
        END.
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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-tit-ap":U THEN ASSIGN pFieldValue = RowObject.cod-tit-ap.
        WHEN "nr-proc-exp":U THEN ASSIGN pFieldValue = RowObject.nr-proc-exp.
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
        WHEN "val-desp":U THEN ASSIGN pFieldValue = RowObject.val-desp.
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
        WHEN "cdn-despes":U THEN ASSIGN pFieldValue = RowObject.cdn-despes.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
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
  Purpose:     Retorna valores dos campos do °ndice prcsxpr-id
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo nr-proc-exp
               retorna valor do campo cod-emitente
               retorna valor do campo cod-tit-ap
               retorna valor do campo cdn-despes
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE proces-export-concil-despes.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-proc-exp LIKE proces-export-concil-despes.nr-proc-exp NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE proces-export-concil-despes.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-tit-ap LIKE proces-export-concil-despes.cod-tit-ap NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-despes LIKE proces-export-concil-despes.cdn-despes NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pnr-proc-exp = RowObject.nr-proc-exp
           pcod-emitente = RowObject.cod-emitente
           pcod-tit-ap = RowObject.cod-tit-ap
           pcdn-despes = RowObject.cdn-despes.

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
  Purpose:     Reposiciona registro com base no °ndice prcsxpr-id
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo nr-proc-exp
               recebe valor do campo cod-emitente
               recebe valor do campo cod-tit-ap
               recebe valor do campo cdn-despes
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE proces-export-concil-despes.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-exp LIKE proces-export-concil-despes.nr-proc-exp NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE proces-export-concil-despes.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tit-ap LIKE proces-export-concil-despes.cod-tit-ap NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-despes LIKE proces-export-concil-despes.cdn-despes NO-UNDO.

    FIND FIRST bfproces-export-concil-despes WHERE 
        bfproces-export-concil-despes.cod-estabel = pcod-estabel AND 
        bfproces-export-concil-despes.nr-proc-exp = pnr-proc-exp AND 
        bfproces-export-concil-despes.cod-emitente = pcod-emitente AND 
        bfproces-export-concil-despes.cod-tit-ap = pcod-tit-ap AND 
        bfproces-export-concil-despes.cdn-despes = pcdn-despes NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproces-export-concil-despes THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproces-export-concil-despes)).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  OPEN QUERY qr{&TableName} FOR EACH {&TableName}
       NO-LOCK
       INDEXED-REPOSITION.
  
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-concil-desp DBOProgram 
PROCEDURE pi-retorna-concil-desp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF  INPUT PARAM pRowId AS ROWID NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-proc-exp-concil-desp-ap.
    
    EMPTY TEMP-TABLE tt-proc-exp-concil-desp-ap.
    
    FIND FIRST proces-export-concil NO-LOCK
         WHERE ROWID(proces-export-concil) = pRowId NO-ERROR.
    
    FOR EACH  bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-estabel  = proces-export-concil.cod-estabel
          AND bf{&TableName}.nr-proc-exp  = proces-export-concil.nr-proc-exp
          AND bf{&TableName}.cod-emitente = proces-export-concil.cod-emitente
          AND bf{&TableName}.cod-tit-ap   = proces-export-concil.cod-tit-ap:
        
        FIND FIRST desp-imp NO-LOCK
             WHERE desp-imp.cod-desp = bf{&TableName}.cdn-despes NO-ERROR.
        
        FIND FIRST proc-desp-itiner NO-LOCK
             WHERE proc-desp-itiner.cod-estabel       = proces-export-concil.cod-estabel
               AND proc-desp-itiner.nr-proc-exp       = proces-export-concil.nr-proc-exp
               AND proc-desp-itiner.cod-emitente-desp = proces-export-concil.cod-emitente
               AND proc-desp-itiner.cod-desp          = bf{&TableName}.cdn-despes NO-ERROR.

        CREATE tt-proc-exp-concil-desp-ap.
        ASSIGN tt-proc-exp-concil-desp-ap.cod-despesa  = bf{&TableName}.cdn-despes
               tt-proc-exp-concil-desp-ap.des-despesa  = IF AVAIL proc-desp-itiner AND TRIM(proc-desp-itiner.descricao) <> "":U THEN proc-desp-itiner.descricao 
                                                                                                                        ELSE IF AVAIL desp-imp THEN desp-imp.descricao ELSE ""
               tt-proc-exp-concil-desp-ap.cod-classif  = IF AVAIL proc-desp-itiner THEN proc-desp-itiner.classif-despesa ELSE 0
               tt-proc-exp-concil-desp-ap.val-despesa  = bf{&TableName}.val-desp 
               tt-proc-exp-concil-desp-ap.log-provisao = NO.
        
        FOR EACH  proc-it-nota-desp NO-LOCK
            WHERE proc-it-nota-desp.cod-estabel = proces-export-concil.cod-estabel
              AND proc-it-nota-desp.nr-proc-exp = proces-export-concil.nr-proc-exp
              AND proc-it-nota-desp.cdn-despes  = bf{&TableName}.cdn-despes:
            FIND FIRST proc-nota-fiscal NO-LOCK
                 WHERE proc-nota-fiscal.cod-estabel        = proc-it-nota-desp.cod-estabel
                   AND proc-nota-fiscal.nr-proc-exp        = proc-it-nota-desp.nr-proc-exp
                   AND proc-nota-fiscal.cod-estab-faturam  = proc-it-nota-desp.cod-estab-faturam
                   AND proc-nota-fiscal.serie              = proc-it-nota-desp.serie
                   AND proc-nota-fiscal.nr-nota-fis        = proc-it-nota-desp.nr-nota-fis NO-ERROR.
            IF  AVAIL proc-nota-fiscal THEN DO:
                &if '{&bf_dis_versao_ems}' >= '2.08' &then
                 ASSIGN tt-proc-exp-concil-desp-ap.log-provisao = proc-nota-fiscal.log-gerou-provis.
                &else
                 ASSIGN tt-proc-exp-concil-desp-ap.log-provisao = proc-nota-fiscal.log-2.
                &endif
                
                IF  tt-proc-exp-concil-desp-ap.log-provisao THEN
                    LEAVE.
            END.
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retornarTitulo DBOProgram 
PROCEDURE pi-retornarTitulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-estabel  LIKE proces-export-concil-despes.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-pro   LIKE proces-export-concil-despes.nr-proc-exp  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-emit LIKE proces-export-concil-despes.cod-emitente NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-desp LIKE proces-export-concil-despes.cdn-despes   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-titulo   LIKE proces-export-concil-despes.cod-tit-ap   NO-UNDO.
    
    FIND FIRST proces-export-concil-despes NO-LOCK
         WHERE proces-export-concil-despes.cod-estabel  = p-estabel
           AND proces-export-concil-despes.nr-proc-exp  = p-nr-pro
           AND proces-export-concil-despes.cod-emitente = p-cod-emit
           AND proces-export-concil-despes.cdn-despes   = p-cod-desp NO-ERROR.
    IF  AVAIL proces-export-concil-despes THEN DO:
        ASSIGN p-titulo = proces-export-concil-despes.cod-tit-ap.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-TituloxDespesa DBOProgram 
PROCEDURE pi-TituloxDespesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pCodEstab         LIKE proces-export-concil-despes.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pNrProcExp        LIKE proces-export-concil-despes.nr-proc-exp NO-UNDO.
    DEFINE INPUT PARAMETER pCodDespesa       LIKE proces-export-concil-despes.cdn-despes  NO-UNDO.
    DEFINE INPUT PARAMETER pLogDespJaIntegAp AS LOGICAL NO-UNDO.

    DEF VAR lb-texto AS CHARACTER NO-UNDO.
    
    FIND FIRST proces-export-concil-despes NO-LOCK
         WHERE proces-export-concil-despes.cod-estabel = pCodEstab
           AND proces-export-concil-despes.nr-proc-exp = pNrProcExp
           AND proces-export-concil-despes.cdn-despes  = pCodDespesa NO-ERROR.

    
    IF  (pLogDespJaIntegAp = YES AND  NOT AVAIL proces-export-concil-despes)
    OR  (pLogDespJaIntegAp = NO  AND      AVAIL proces-export-concil-despes) THEN DO:
        
        IF  pLogDespJaIntegAp THEN
            ASSIGN lb-texto = "marcada, porÇm n∆o".
        ELSE
            ASSIGN lb-texto = "desmarcada, porÇm".
        
        RUN utp/ut-msgs.p (INPUT "help", INPUT 34496, INPUT lb-texto).
        
        {method/svc/errors/inserr.i &ErrorNumber=27979
                                    &ErrorType="EMS"
                                    &ErrorSubType="WARNING"
                                    &ErrorParameters ="RETURN-VALUE" }
    END.
    
    IF  CAN-FIND(FIRST RowErrors) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaValor DBOProgram 
PROCEDURE piRetornaValor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE  INPUT PARAMETER pcod-estabel  LIKE {&TableName}.cod-estabel  NO-UNDO.
    DEFINE  INPUT PARAMETER pnr-proc-exp  LIKE {&TableName}.nr-proc-exp  NO-UNDO.
    DEFINE  INPUT PARAMETER pcod-emitente LIKE {&TableName}.cod-emitente NO-UNDO.
    DEFINE  INPUT PARAMETER pcod-tit-ap   LIKE {&TableName}.cod-tit-ap   NO-UNDO.
    DEFINE OUTPUT PARAMETER pval-despesa  LIKE {&TableName}.val-desp     NO-UNDO.
    
    FOR EACH  bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-estabel = pcod-estabel
          AND bf{&TableName}.nr-proc-exp = pnr-proc-exp
          AND bf{&TableName}.cod-emitente = pcod-emitente
          AND bf{&TableName}.cod-tit-ap = pcod-tit-ap:
        ASSIGN pval-despesa = pval-despesa + bf{&TableName}.val-desp.
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
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

