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
{include/i-prgvrs.i BOCX379 2.00.00.009 } /*** "010009" 07/10/2024 16:59:57 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bocx379 MUT}
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
&GLOBAL-DEFINE DBOName BOCX379
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName proces-export-concil
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
{cxbo/bocx379.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE h-bocx380         AS HANDLE  NO-UNDO.

DEFINE VARIABLE cCodEstabIni    LIKE proces-export-concil.cod-estabel  NO-UNDO.
DEFINE VARIABLE cCodEstabFim    LIKE proces-export-concil.cod-estabel  NO-UNDO.
DEFINE VARIABLE cNrProcExpIni   LIKE proces-export-concil.nr-proc-exp  NO-UNDO.
DEFINE VARIABLE cNrProcExpFim   LIKE proces-export-concil.nr-proc-exp  NO-UNDO.
DEFINE VARIABLE iCodEmitenteIni LIKE proces-export-concil.cod-emitente NO-UNDO.
DEFINE VARIABLE iCodEmitenteFim LIKE proces-export-concil.cod-emitente NO-UNDO.
DEFINE VARIABLE cCodTitApIni    LIKE proces-export-concil.cod-tit-ap   NO-UNDO.
DEFINE VARIABLE cCodTitApFim    LIKE proces-export-concil.cod-tit-ap   NO-UNDO.
DEFINE VARIABLE cDtTransIni     LIKE proces-export-concil.dat-trans    NO-UNDO.
DEFINE VARIABLE cDtTransFim     LIKE proces-export-concil.dat-trans    NO-UNDO.
DEFINE VARIABLE iSitIni           AS INTEGER                           NO-UNDO.
DEFINE VARIABLE iSitFim           AS INTEGER                           NO-UNDO.

DEF TEMP-TABLE tt-proc-exp-concil-desp NO-UNDO
    FIELD mark           AS CHAR FORMAT "X(01)":U LABEL "*"
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
         HEIGHT             = 4.46
         WIDTH              = 32.14.
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
    
    RUN cxbo/bocx380.p PERSISTENT SET h-bocx380.
    RUN openQueryStatic IN h-bocx380 ("") NO-ERROR.
    
    FOR EACH  proces-export-concil-despes no-lock
        WHERE proces-export-concil-despes.cod-estabel  = RowObject.cod-estabel
          AND proces-export-concil-despes.nr-proc-exp  = RowObject.nr-proc-exp
          AND proces-export-concil-despes.cod-emitente = RowObject.cod-emitente
          AND proces-export-concil-despes.cod-tit-ap   = RowObject.cod-tit-ap:
        
        FIND FIRST proc-desp-itiner EXCLUSIVE-LOCK
             WHERE proc-desp-itiner.cod-estabel       = proces-export-concil-despes.cod-estabel
               AND proc-desp-itiner.nr-proc-exp       = proces-export-concil-despes.nr-proc-exp
               AND proc-desp-itiner.cod-emitente-desp = proces-export-concil-despes.cod-emitente
               AND proc-desp-itiner.cod-desp          = proces-export-concil-despes.cdn-despes NO-ERROR.
        IF  AVAIL proc-desp-itiner THEN
            ASSIGN proc-desp-itiner.log-1 = NO. /*log-desp-ja-integ-ap*/
        
        RUN goToKey IN h-bocx380(proces-export-concil-despes.cod-estabel,
                                 proces-export-concil-despes.nr-proc-exp,
                                 proces-export-concil-despes.cod-emitente,
                                 proces-export-concil-despes.cod-tit-ap,
                                 proces-export-concil-despes.cdn-despes).
        
        IF  RETURN-VALUE = "OK":U THEN
            RUN deleteRecord IN h-bocx380.
    END.
    
    DELETE PROCEDURE h-bocx380.
    
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
        WHEN "cod-especie":U THEN ASSIGN pFieldValue = RowObject.cod-especie.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-serie":U THEN ASSIGN pFieldValue = RowObject.cod-serie.
        WHEN "cod-tit-ap":U THEN ASSIGN pFieldValue = RowObject.cod-tit-ap.
        WHEN "cod-user":U THEN ASSIGN pFieldValue = RowObject.cod-user.
        WHEN "des-narrat":U THEN ASSIGN pFieldValue = RowObject.des-narrat.
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
        WHEN "dat-base-cobr-despes":U THEN ASSIGN pFieldValue = RowObject.dat-base-cobr-despes.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-trans":U THEN ASSIGN pFieldValue = RowObject.dat-trans.
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
        WHEN "cdn-cond-pagto":U THEN ASSIGN pFieldValue = RowObject.cdn-cond-pagto.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "idi-situacao":U THEN ASSIGN pFieldValue = RowObject.idi-situacao.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
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
  Purpose:     Retorna valores dos campos do °ndice prcsxpre-id
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo nr-proc-exp
               retorna valor do campo cod-emitente
               retorna valor do campo cod-tit-ap
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE proces-export-concil.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-proc-exp LIKE proces-export-concil.nr-proc-exp NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE proces-export-concil.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-tit-ap LIKE proces-export-concil.cod-tit-ap NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pnr-proc-exp = RowObject.nr-proc-exp
           pcod-emitente = RowObject.cod-emitente
           pcod-tit-ap = RowObject.cod-tit-ap.

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
  Purpose:     Reposiciona registro com base no °ndice prcsxpre-id
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo nr-proc-exp
               recebe valor do campo cod-emitente
               recebe valor do campo cod-tit-ap
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE proces-export-concil.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-exp LIKE proces-export-concil.nr-proc-exp NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE proces-export-concil.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tit-ap LIKE proces-export-concil.cod-tit-ap NO-UNDO.

    FIND FIRST bfproces-export-concil WHERE 
        bfproces-export-concil.cod-estabel = pcod-estabel AND 
        bfproces-export-concil.nr-proc-exp = pnr-proc-exp AND 
        bfproces-export-concil.cod-emitente = pcod-emitente AND 
        bfproces-export-concil.cod-tit-ap = pcod-tit-ap NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproces-export-concil THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproces-export-concil)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDtTrans DBOProgram 
PROCEDURE openQueryDtTrans :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    OPEN QUERY qrproces-export-concil FOR EACH proces-export-concil NO-LOCK
                                         WHERE proces-export-concil.dat-trans    >= cDtTransIni
                                           AND proces-export-concil.dat-trans    <= cDtTransFim
                                           AND proces-export-concil.idi-situacao >= iSitIni
                                           AND proces-export-concil.idi-situacao <= iSitFim INDEXED-REPOSITION.
    
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
    
    OPEN QUERY qrproces-export-concil FOR EACH proces-export-concil
                                         WHERE proces-export-concil.idi-situacao >= iSitIni
                                           AND proces-export-concil.idi-situacao <= iSitFim INDEXED-REPOSITION.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryProcesso DBOProgram 
PROCEDURE openQueryProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    OPEN QUERY qrproces-export-concil FOR EACH proces-export-concil NO-LOCK
                                         WHERE proces-export-concil.cod-estabel  >= cCodEstabIni
                                           AND proces-export-concil.cod-estabel  <= cCodEstabFim
                                           AND proces-export-concil.nr-proc-exp  >= cNrProcExpIni
                                           AND proces-export-concil.nr-proc-exp  <= cNrProcExpFim
                                           AND proces-export-concil.cod-emitente >= iCodEmitenteIni
                                           AND proces-export-concil.cod-emitente <= iCodEmitenteFim
                                           AND proces-export-concil.cod-tit-ap   >= cCodTitApIni
                                           AND proces-export-concil.cod-tit-ap   <= cCodTitApFim
                                           AND proces-export-concil.idi-situacao >= iSitIni
                                           AND proces-export-concil.idi-situacao <= iSitFim INDEXED-REPOSITION.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-desp-proc DBOProgram 
PROCEDURE pi-retorna-desp-proc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF  INPUT PARAM pRowId AS ROWID NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-proc-exp-concil-desp.
    
    EMPTY TEMP-TABLE tt-proc-exp-concil-desp.
    
    FIND FIRST proces-export-concil NO-LOCK
         WHERE ROWID(proces-export-concil) = pRowId NO-ERROR.
    
    FOR EACH  proc-desp-itiner NO-LOCK
        WHERE proc-desp-itiner.cod-estabel  = proces-export-concil.cod-estabel
          AND proc-desp-itiner.nr-proc-exp  = proces-export-concil.nr-proc-exp
          AND proc-desp-itiner.cod-emitente-desp = proces-export-concil.cod-emitente
          AND proc-desp-itiner.mo-codigo    = proces-export-concil.mo-codigo
          AND proc-desp-itiner.log-1        = NO  /*log-desp-ja-integ-ap*/
          AND proc-desp-itiner.log-despes-integr-ap = YES:
        
        IF  CAN-FIND(FIRST proces-export-concil-despes
                     WHERE proces-export-concil-despes.cod-estabel  = proces-export-concil.cod-estabel
                       AND proces-export-concil-despes.nr-proc-exp  = proces-export-concil.nr-proc-exp
                       AND proces-export-concil-despes.cod-emitente = proces-export-concil.cod-emitente
                       AND proces-export-concil-despes.cdn-despes   = proc-desp-itiner.cod-desp) THEN
            NEXT.
        
        FIND FIRST desp-imp NO-LOCK
             WHERE desp-imp.cod-desp = proc-desp-itiner.cod-desp NO-ERROR.

        CREATE tt-proc-exp-concil-desp.
        ASSIGN tt-proc-exp-concil-desp.cod-despesa  = proc-desp-itiner.cod-desp
               tt-proc-exp-concil-desp.des-despesa  = IF TRIM(proc-desp-itiner.descricao) <> "":U THEN
                                                             proc-desp-itiner.descricao ELSE 
                                                      IF AVAIL desp-imp THEN desp-imp.descricao ELSE ""
               tt-proc-exp-concil-desp.cod-classif  = proc-desp-itiner.classif-despesa
               tt-proc-exp-concil-desp.val-despesa  = proc-desp-itiner.val-desp
               tt-proc-exp-concil-desp.log-provisao = NO.
        
        FOR EACH  proc-it-nota-desp NO-LOCK
            WHERE proc-it-nota-desp.cod-estabel = proces-export-concil.cod-estabel
              AND proc-it-nota-desp.nr-proc-exp = proces-export-concil.nr-proc-exp
              AND proc-it-nota-desp.cdn-despes  = proc-desp-itiner.cod-desp:
            FIND FIRST proc-nota-fiscal NO-LOCK
                 WHERE proc-nota-fiscal.cod-estabel        = proc-it-nota-desp.cod-estabel
                   AND proc-nota-fiscal.nr-proc-exp        = proc-it-nota-desp.nr-proc-exp
                   AND proc-nota-fiscal.cod-estab-faturam  = proc-it-nota-desp.cod-estab-faturam
                   AND proc-nota-fiscal.serie              = proc-it-nota-desp.serie
                   AND proc-nota-fiscal.nr-nota-fis        = proc-it-nota-desp.nr-nota-fis NO-ERROR.
            IF  AVAIL proc-nota-fiscal THEN DO:
                &if '{&bf_dis_versao_ems}' >= '2.08' &then
                 ASSIGN tt-proc-exp-concil-desp.log-provisao = proc-nota-fiscal.log-gerou-provis.
                &else
                 ASSIGN tt-proc-exp-concil-desp.log-provisao = proc-nota-fiscal.log-2.
                &endif
                
                IF  tt-proc-exp-concil-desp.log-provisao THEN
                   LEAVE.
            END.
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDtTrans DBOProgram 
PROCEDURE setConstraintDtTrans :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pDtTransIni    LIKE proces-export-concil.dat-trans  NO-UNDO.
    DEFINE INPUT PARAM pDtTransFim    LIKE proces-export-concil.dat-trans  NO-UNDO.
    DEFINE INPUT PARAM pSituacao        AS INTEGER                         NO-UNDO.
    
    ASSIGN cDtTransIni    = pDtTransIni
           cDtTransFim    = pDtTransFim.
    
    IF  pSituacao = 0 THEN
        ASSIGN iSitIni = 0
               iSitFim = 99.
    ELSE
        ASSIGN iSitIni = pSituacao
               iSitFim = pSituacao.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pSituacao   AS INTEGER                         NO-UNDO.
    
    IF  pSituacao = 0 THEN
        ASSIGN iSitIni = 0
               iSitFim = 99.
    ELSE
        ASSIGN iSitIni = pSituacao
               iSitFim = pSituacao.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintProcesso DBOProgram 
PROCEDURE setConstraintProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pCodEstabIni    LIKE proces-export-concil.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAM pCodEstabFim    LIKE proces-export-concil.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAM pNrProcExpIni   LIKE proces-export-concil.nr-proc-exp  NO-UNDO.
    DEFINE INPUT PARAM pNrProcExpFim   LIKE proces-export-concil.nr-proc-exp  NO-UNDO.
    DEFINE INPUT PARAM pCodEmitenteIni LIKE proces-export-concil.cod-emitente NO-UNDO.
    DEFINE INPUT PARAM pCodEmitenteFim LIKE proces-export-concil.cod-emitente NO-UNDO.
    DEFINE INPUT PARAM pCodTitApIni    LIKE proces-export-concil.cod-tit-ap   NO-UNDO.
    DEFINE INPUT PARAM pCodTitApFim    LIKE proces-export-concil.cod-tit-ap   NO-UNDO.
    DEFINE INPUT PARAM pSituacao         AS INTEGER                           NO-UNDO.
    
    ASSIGN cCodEstabIni    = pCodEstabIni
           cCodEstabFim    = pCodEstabFim
           cNrProcExpIni   = pNrProcExpIni
           cNrProcExpFim   = pNrProcExpFim
           iCodEmitenteIni = pCodEmitenteIni
           iCodEmitenteFim = pCodEmitenteFim
           cCodTitApIni    = pCodTitApIni
           cCodTitApFim    = pCodTitApFim.
    
    IF  pSituacao = 0 THEN
        ASSIGN iSitIni = 0
               iSitFim = 99.
    ELSE
        ASSIGN iSitIni = pSituacao
               iSitFim = pSituacao.
    
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
    
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    IF  pType = "Create":U THEN DO:
        IF  NOT CAN-FIND(FIRST estabelec
                         WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            RUN _insertError (INPUT 2,
                              INPUT "EMS":U,
                              INPUT ?,
                              INPUT 'Estabelecimento').
        END.
        
        IF  NOT CAN-FIND(FIRST processo-exp
                         WHERE processo-exp.cod-estabel = RowObject.cod-estabel
                           AND processo-exp.nr-proc-exp = RowObject.nr-proc-exp) THEN DO:
            RUN _insertError (INPUT 2,
                              INPUT "EMS":U,
                              INPUT ?,
                              INPUT 'Processo de Exportaá∆o').
        END.
        
        IF  NOT CAN-FIND(FIRST emitente
                         WHERE emitente.cod-emitente = RowObject.cod-emitente) THEN DO:
            RUN _insertError (INPUT 2,
                              INPUT "EMS":U,
                              INPUT ?,
                              INPUT 'Fornecedor').
        END.
        
        IF  NOT CAN-FIND(FIRST moeda
                         WHERE moeda.mo-codigo = RowObject.mo-codigo) THEN DO:
            RUN _insertError (INPUT 2,
                              INPUT "EMS":U,
                              INPUT ?,
                              INPUT 'Moeda').
        END.
        
        IF  NOT CAN-FIND(FIRST espec-ap
                         WHERE espec-ap.cod-esp = RowObject.cod-especie) THEN DO:
            RUN _insertError (INPUT 2,
                              INPUT "EMS":U,
                              INPUT ?,
                              INPUT 'EspÇcie').
        END.
        
        IF  NOT CAN-FIND(FIRST serie
                         WHERE serie.serie = RowObject.cod-serie) THEN DO:
            RUN _insertError (INPUT 2,
                              INPUT "EMS":U,
                              INPUT ?,
                              INPUT 'SÇrie').
        END.
        
        IF  RowObject.cod-tit-ap = "" THEN DO:
            RUN _insertError (INPUT 6104,
                              INPUT "EMS":U,
                              INPUT ?,
                              INPUT '').
        END.
        
        IF  CAN-FIND(FIRST bfproces-export-concil
             WHERE bfproces-export-concil.cod-estabel  = RowObject.cod-estabel
               AND bfproces-export-concil.nr-proc-exp  = RowObject.nr-proc-exp
               AND bfproces-export-concil.cod-emitente = RowObject.cod-emitente 
               AND bfproces-export-concil.cod-tit-ap   = RowObject.cod-tit-ap) THEN DO:
            RUN utp/ut-table.p (INPUT "mgcex":U,
                                INPUT "proces-export-concil":U,
                                INPUT 1).
            RUN _insertError (INPUT 7,
                              INPUT "EMS":U,
                              INPUT ?,
                              INPUT RETURN-VALUE).
        END.
    END.
    
    IF  pType = "Create":U OR pType = "Update":U THEN DO:
        IF  NOT CAN-FIND(FIRST cond-pagto
                         WHERE cond-pagto.cod-cond-pag = RowObject.cdn-cond-pagto) THEN DO:
            RUN _insertError (INPUT 2,
                              INPUT "EMS":U,
                              INPUT ?,
                              INPUT 'Condiá∆o de Pagamento').
        END.
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

