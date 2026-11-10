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
{include/i-prgvrs.i BOCX382 2.00.00.005 } /*** "010005" 11/12/2023 10:13:29 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bocx382 MUT}
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

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX382
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName proces-devol-clien
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
{cxbo/bocx382.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE TEMP-TABLE tt-it-nota-fisc NO-UNDO LIKE it-nota-fisc
    FIELD r-rowid   AS ROWID.
                                 
DEFINE VARIABLE cNrProcExp       AS CHAR        NO-UNDO.
DEFINE VARIABLE cCodEstabel      AS CHAR        NO-UNDO.
DEFINE VARIABLE cSerieIni        AS CHAR        NO-UNDO.
DEFINE VARIABLE cSerieFim        AS CHAR        NO-UNDO.
DEFINE VARIABLE cNrNotaFisIni    AS CHAR        NO-UNDO.
DEFINE VARIABLE cNrNotaFisFim    AS CHAR        NO-UNDO.
DEFINE VARIABLE de-qtd-nota      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-total         AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-qtd-devolucao AS DECIMAL     NO-UNDO.
DEFINE VARIABLE iNrRegistro      AS INTEGER     NO-UNDO.
DEFINE VARIABLE h-bodi088na      AS HANDLE      NO-UNDO.

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
         HEIGHT             = 16.04
         WIDTH              = 39.86.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN de-qtd-devolucao = 0
           de-qtd-nota      = 0.
    
    FOR EACH bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-estab-faturam = {&TableName}.cod-estab-faturam
        AND   bf{&TableName}.cod-serie         = {&TableName}.cod-serie        
        AND   bf{&TableName}.nr-nota-fis       = {&TableName}.nr-nota-fis:

        ASSIGN de-qtd-devolucao = de-qtd-devolucao + bf{&TableName}.qtd-devolvid.
    END.

    IF NOT VALID-HANDLE (h-bodi088na) THEN
        RUN dibo/bodi088na.p PERSISTENT SET h-bodi088na.
    
    RUN setConstraintOfNotaFiscal IN h-bodi088na (INPUT {&TableName}.cod-estab-faturam,
                                                  INPUT {&TableName}.cod-serie,
                                                  INPUT {&TableName}.nr-nota-fis).
    RUN openQueryStatic           IN h-bodi088na (INPUT "OfNotaFiscal":U).
    RUN getBatchRecords           IN h-bodi088na (INPUT ?,
                                                  INPUT NO,
                                                  INPUT ?,
                                                  OUTPUT iNrRegistro,
                                                  OUTPUT TABLE tt-it-nota-fisc).
    
    FOR EACH tt-it-nota-fisc:
        ASSIGN de-qtd-nota = de-qtd-nota + tt-it-nota-fisc.qt-faturada[1].
    END.

    FIND FIRST proc-nota-fiscal EXCLUSIVE-LOCK
        WHERE proc-nota-fiscal.cod-estabel       = {&TableName}.cod-estab 
        AND   proc-nota-fiscal.nr-proc-exp       = {&TableName}.cod-proces-export 
        AND   proc-nota-fiscal.cod-estab-faturam = {&TableName}.cod-estab-faturam 
        AND   proc-nota-fiscal.serie             = {&TableName}.cod-serie 
        AND   proc-nota-fiscal.nr-nota-fis       = {&TableName}.nr-nota-fis NO-ERROR.
    IF AVAIL proc-nota-fiscal 
    AND de-qtd-devolucao >= de-qtd-nota THEN 
        ASSIGN proc-nota-fiscal.log-nf-devolvid = YES.
    ELSE IF AVAIL proc-nota-fiscal THEN
        ASSIGN proc-nota-fiscal.log-nf-devolvid = NO.

    IF VALID-HANDLE (h-bodi088na) THEN
        DELETE PROCEDURE h-bodi088na.
    
    ASSIGN h-bodi088na = ?.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FOR EACH bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-estab-faturam = {&TableName}.cod-estab-faturam
        AND   bf{&TableName}.cod-serie         = {&TableName}.cod-serie        
        AND   bf{&TableName}.nr-nota-fis       = {&TableName}.nr-nota-fis:

        ASSIGN de-qtd-devolucao = de-qtd-devolucao + bf{&TableName}.qtd-devolvid.
    END.

    ASSIGN de-qtd-devolucao = de-qtd-devolucao - {&TableName}.qtd-devolvid.

    IF NOT VALID-HANDLE (h-bodi088na) THEN
        RUN dibo/bodi088na.p PERSISTENT SET h-bodi088na.
    
    RUN setConstraintOfNotaFiscal IN h-bodi088na (INPUT {&TableName}.cod-estab-faturam,
                                                  INPUT {&TableName}.cod-serie,
                                                  INPUT {&TableName}.nr-nota-fis).
    RUN openQueryStatic           IN h-bodi088na (INPUT "OfNotaFiscal":U).
    RUN getBatchRecords           IN h-bodi088na (INPUT ?,
                                                  INPUT NO,
                                                  INPUT ?,
                                                  OUTPUT iNrRegistro,
                                                  OUTPUT TABLE tt-it-nota-fisc).
    
    FOR EACH tt-it-nota-fisc:
        RUN getDecField    IN h-bodi088na (INPUT "qt-faturada[1]",OUTPUT de-total).
    
        ASSIGN de-qtd-nota = de-qtd-nota + de-total.
    END.
    
    FIND FIRST proc-nota-fiscal EXCLUSIVE-LOCK
        WHERE proc-nota-fiscal.cod-estabel       = {&TableName}.cod-estab 
        AND   proc-nota-fiscal.nr-proc-exp       = {&TableName}.cod-proces-export 
        AND   proc-nota-fiscal.cod-estab-faturam = {&TableName}.cod-estab-faturam 
        AND   proc-nota-fiscal.serie             = {&TableName}.cod-serie 
        AND   proc-nota-fiscal.nr-nota-fis       = {&TableName}.nr-nota-fis NO-ERROR.
    IF AVAIL proc-nota-fiscal 
    AND de-qtd-devolucao >= de-qtd-nota THEN 
        ASSIGN proc-nota-fiscal.log-nf-devolvid = YES.
    ELSE IF AVAIL proc-nota-fiscal THEN
        ASSIGN proc-nota-fiscal.log-nf-devolvid = NO.

    IF VALID-HANDLE (h-bodi088na) THEN
        DELETE PROCEDURE h-bodi088na.
    
    ASSIGN h-bodi088na = ?.

    RETURN "OK".

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
        WHEN "cod-docto":U THEN ASSIGN pFieldValue = RowObject.cod-docto.
        WHEN "cod-estab":U THEN ASSIGN pFieldValue = RowObject.cod-estab.
        WHEN "cod-estab-faturam":U THEN ASSIGN pFieldValue = RowObject.cod-estab-faturam.
        WHEN "cod-item":U THEN ASSIGN pFieldValue = RowObject.cod-item.
        WHEN "cod-natur-operac":U THEN ASSIGN pFieldValue = RowObject.cod-natur-operac.
        WHEN "cod-proces-export":U THEN ASSIGN pFieldValue = RowObject.cod-proces-export.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-ser-docto":U THEN ASSIGN pFieldValue = RowObject.cod-ser-docto.
        WHEN "cod-serie":U THEN ASSIGN pFieldValue = RowObject.cod-serie.
        WHEN "nr-nota-fis":U THEN ASSIGN pFieldValue = RowObject.nr-nota-fis.
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
        WHEN "dat-devol-item":U THEN ASSIGN pFieldValue = RowObject.dat-devol-item.
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
        WHEN "qtd-devolvid":U THEN ASSIGN pFieldValue = RowObject.qtd-devolvid.
        WHEN "val-devol":U THEN ASSIGN pFieldValue = RowObject.val-devol.
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
        WHEN "num-entrega":U THEN ASSIGN pFieldValue = RowObject.num-entrega.
        WHEN "num-seq-nota-devol":U THEN ASSIGN pFieldValue = RowObject.num-seq-nota-devol.
        WHEN "num-seq-nota-vda":U THEN ASSIGN pFieldValue = RowObject.num-seq-nota-vda.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice prcsdvlc-id
  Parameters:  
               retorna valor do campo cod-estab         
               retorna valor do campo cod-proces-export 
               retorna valor do campo cod-estab-faturam 
               retorna valor do campo nr-nota-fis       
               retorna valor do campo cod-serie         
               retorna valor do campo num-seq-nota-vda  
               retorna valor do campo num-seq-devol     
               retorna valor do campo cod-item  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estab LIKE proces-devol-clien.cod-estab NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-proces-export LIKE proces-devol-clien.cod-proces-export NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estab-faturam LIKE proces-devol-clien.cod-estab-faturam NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-nota-fis LIKE proces-devol-clien.nr-nota-fis NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-serie LIKE proces-devol-clien.cod-serie NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-nota-vda LIKE proces-devol-clien.num-seq-nota-vda NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-item LIKE proces-devol-clien.cod-item NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-devol LIKE proces-devol-clien.num-seq-devol NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estab = RowObject.cod-estab
           pcod-proces-export = RowObject.cod-proces-export
           pcod-estab-faturam = RowObject.cod-estab-faturam
           pnr-nota-fis = RowObject.nr-nota-fis
           pcod-serie = RowObject.cod-serie
           pnum-seq-nota-vda = RowObject.num-seq-nota-vda
           pcod-item = RowObject.cod-item
           pnum-seq-devol = RowObject.num-seq-devol.

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
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQtdDevolNota DBOProgram 
PROCEDURE getQtdDevolNota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pCodEstabFaturam     AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pSerie               AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pNrNotaFis           AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER pQtdDevolucao       AS DECIMAL      NO-UNDO.

    IF NOT CAN-FIND(FIRST proces-devol-clien
                    WHERE proces-devol-clien.cod-estab-faturam = pCodEstabFaturam  
                    AND   proces-devol-clien.cod-serie         = pSerie            
                    AND   proces-devol-clien.nr-nota-fis       = pNrNotaFis) THEN 
        RETURN "NOK":U.

    FOR EACH proces-devol-clien
            WHERE proces-devol-clien.cod-estab-faturam = pCodEstabFaturam  
            AND   proces-devol-clien.cod-serie         = pSerie            
            AND   proces-devol-clien.nr-nota-fis       = pNrNotaFis NO-LOCK:

        ASSIGN pQtdDevolucao = pQtdDevolucao + proces-devol-clien.qtd-devolvid.
    END.            

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
  Purpose:     Reposiciona registro com base no °ndice prcsdvlc-id
  Parameters:  
               recebe valor do campo cod-estab
               recebe valor do campo cod-proces-export
               recebe valor do campo cod-estab-faturam
               recebe valor do campo nr-nota-fis
               recebe valor do campo cod-serie
               recebe valor do campo num-seq-nota-vda
               recebe valor do campo num-seq-devol
               recebe valor do campo cod-item
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estab LIKE proces-devol-clien.cod-estab NO-UNDO.
    DEFINE INPUT PARAMETER pcod-proces-export LIKE proces-devol-clien.cod-proces-export NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estab-faturam LIKE proces-devol-clien.cod-estab-faturam NO-UNDO.
    DEFINE INPUT PARAMETER pnr-nota-fis LIKE proces-devol-clien.nr-nota-fis NO-UNDO.
    DEFINE INPUT PARAMETER pcod-serie LIKE proces-devol-clien.cod-serie NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-nota-vda LIKE proces-devol-clien.num-seq-nota-vda NO-UNDO.
    DEFINE INPUT PARAMETER pcod-item LIKE proces-devol-clien.cod-item NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-devol LIKE proces-devol-clien.num-seq-devol NO-UNDO.

    FIND FIRST bfproces-devol-clien WHERE 
        bfproces-devol-clien.cod-estab = pcod-estab AND 
        bfproces-devol-clien.cod-proces-export = pcod-proces-export AND 
        bfproces-devol-clien.cod-estab-faturam = pcod-estab-faturam AND 
        bfproces-devol-clien.nr-nota-fis = pnr-nota-fis AND 
        bfproces-devol-clien.cod-serie = pcod-serie AND 
        bfproces-devol-clien.num-seq-nota-vda = pnum-seq-nota-vda AND 
        bfproces-devol-clien.cod-item = pcod-item AND 
        bfproces-devol-clien.num-seq-devol = pnum-seq-devol NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproces-devol-clien THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproces-devol-clien)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQuery DBOProgram 
PROCEDURE OpenQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName} for each {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK".
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryofNotaFiscal DBOProgram 
PROCEDURE OpenQueryofNotaFiscal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
open query {&QueryName} for each {&TableName} no-lock 
    where {&TableName}.cod-estab         =  cCodEstabel
    AND   {&TableName}.cod-proces-export =  cNrProcExp
    AND   {&TableName}.cod-serie        >= cSerieIni 
    and   {&TableName}.cod-serie        <= cSerieFim 
    and   {&TableName}.nr-nota-fis      >= cNrNotaFisIni 
    and   {&TableName}.nr-nota-fis      <= cNrNotaFisFim INDEXED-REPOSITION.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryOfProcesso DBOProgram 
PROCEDURE OpenQueryOfProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
open query {&QueryName} for each {&TableName} no-lock 
    where {&TableName}.cod-estab         =  cCodEstabel
    AND   {&TableName}.cod-proces-export =  cNrProcExp INDEXED-REPOSITION.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint1 DBOProgram 
PROCEDURE setConstraint1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pNrProcExp    as char no-undo.
DEF INPUT PARAM pCodEstabel   AS CHAR NO-UNDO.

ASSIGN cNrProcExp     = pNrProcExp
       cCodEstabel    = pCodEstabel.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint3 DBOProgram 
PROCEDURE setConstraint3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pNrProcExp    as char no-undo.
DEF INPUT PARAM pCodEstabel   AS CHAR NO-UNDO.
def input param pSerieIni     as char no-undo.
def input param pSerieFim     as char no-undo.
def input param pNrNotaFisIni as char no-undo.
def input param pNrNotaFisFim as char no-undo.

ASSIGN cNrProcExp     = pNrProcExp
       cCodEstabel    = pCodEstabel
       cSerieIni      = pSerieIni    
       cSerieFim      = pSerieFim    
       cNrNotaFisIni  = pNrNotaFisIni
       cNrNotaFisFim  = pNrNotaFisFim.

RETURN "OK".

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

