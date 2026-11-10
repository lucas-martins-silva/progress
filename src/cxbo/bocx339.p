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

{include/i-prgvrs.i BOCX339 2.00.00.004 } /*** "010004" 11/12/2023 10:13:25 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX339 MUT}
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
&GLOBAL-DEFINE DBOName BOCX339
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName memorando-nf-item
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{cxbo/bocx339.i RowObject}
 
/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF VAR cCodEstabel LIKE estabelec.cod-estabel       NO-UNDO.
DEF VAR cSerie      LIKE serie.serie                 NO-UNDO.
DEF VAR cNrNotaFis  LIKE nota-fiscal.nr-nota-fis     NO-UNDO.
def var iNrSeqFat   like it-nota-fisc.nr-seq-fat     no-undo.
DEF VAR iCodEmitIni LIKE emitente.cod-emitente       NO-UNDO.
DEF VAR iCodEmitFim LIKE emitente.cod-emitente       NO-UNDO.
DEF VAR iNrFormIni  LIKE memorando-nf-item.num-form  NO-UNDO.
DEF VAR iNrFormFim  LIKE memorando-nf-item.num-form  NO-UNDO.

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
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "nfe-cod-estabel":U THEN ASSIGN pFieldValue = RowObject.nfe-cod-estabel.
        WHEN "nfe-nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nfe-nat-operacao.
        WHEN "nfe-nro-docto":U THEN ASSIGN pFieldValue = RowObject.nfe-nro-docto.
        WHEN "nfe-serie":U THEN ASSIGN pFieldValue = RowObject.nfe-serie.
        WHEN "nfs-cod-estabel":U THEN ASSIGN pFieldValue = RowObject.nfs-cod-estabel.
        WHEN "nfs-nr-nota-fis":U THEN ASSIGN pFieldValue = RowObject.nfs-nr-nota-fis.
        WHEN "nfs-serie":U THEN ASSIGN pFieldValue = RowObject.nfs-serie.
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
        WHEN "qtd-bxada":U THEN ASSIGN pFieldValue = RowObject.qtd-bxada.
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
        WHEN "nfe-cod-emitente":U THEN ASSIGN pFieldValue = RowObject.nfe-cod-emitente.
        WHEN "nfe-nr-seq":U THEN ASSIGN pFieldValue = RowObject.nfe-nr-seq.
        WHEN "nfs-nr-seq-fat":U THEN ASSIGN pFieldValue = RowObject.nfs-nr-seq-fat.
        WHEN "num-form":U THEN ASSIGN pFieldValue = RowObject.num-form.
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
  Purpose:     Retorna valores dos campos do °ndice mmrndnft-id
  Parameters:  
               retorna valor do campo nfs-cod-estabel
               retorna valor do campo nfs-serie
               retorna valor do campo nfs-nr-nota-fis
               retorna valor do campo nfs-nr-seq-fat
               retorna valor do campo nfe-cod-estabel
               retorna valor do campo nfe-serie
               retorna valor do campo nfe-nro-docto
               retorna valor do campo nfe-cod-emitente
               retorna valor do campo nfe-nat-operacao
               retorna valor do campo nfe-nr-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnfs-cod-estabel LIKE memorando-nf-item.nfs-cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnfs-serie LIKE memorando-nf-item.nfs-serie NO-UNDO.
    DEFINE OUTPUT PARAMETER pnfs-nr-nota-fis LIKE memorando-nf-item.nfs-nr-nota-fis NO-UNDO.
    DEFINE OUTPUT PARAMETER pnfs-nr-seq-fat LIKE memorando-nf-item.nfs-nr-seq-fat NO-UNDO.
    DEFINE OUTPUT PARAMETER pnfe-cod-estabel LIKE memorando-nf-item.nfe-cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnfe-serie LIKE memorando-nf-item.nfe-serie NO-UNDO.
    DEFINE OUTPUT PARAMETER pnfe-nro-docto LIKE memorando-nf-item.nfe-nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnfe-cod-emitente LIKE memorando-nf-item.nfe-cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnfe-nat-operacao LIKE memorando-nf-item.nfe-nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pnfe-nr-seq LIKE memorando-nf-item.nfe-nr-seq NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnfs-cod-estabel = RowObject.nfs-cod-estabel
           pnfs-serie = RowObject.nfs-serie
           pnfs-nr-nota-fis = RowObject.nfs-nr-nota-fis
           pnfs-nr-seq-fat = RowObject.nfs-nr-seq-fat
           pnfe-cod-estabel = RowObject.nfe-cod-estabel
           pnfe-serie = RowObject.nfe-serie
           pnfe-nro-docto = RowObject.nfe-nro-docto
           pnfe-cod-emitente = RowObject.nfe-cod-emitente
           pnfe-nat-operacao = RowObject.nfe-nat-operacao
           pnfe-nr-seq = RowObject.nfe-nr-seq.

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
  Purpose:     Reposiciona registro com base no °ndice mmrndnft-id
  Parameters:  
               recebe valor do campo nfs-cod-estabel
               recebe valor do campo nfs-serie
               recebe valor do campo nfs-nr-nota-fis
               recebe valor do campo nfs-nr-seq-fat
               recebe valor do campo nfe-cod-estabel
               recebe valor do campo nfe-serie
               recebe valor do campo nfe-nro-docto
               recebe valor do campo nfe-cod-emitente
               recebe valor do campo nfe-nat-operacao
               recebe valor do campo nfe-nr-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnfs-cod-estabel LIKE memorando-nf-item.nfs-cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnfs-serie LIKE memorando-nf-item.nfs-serie NO-UNDO.
    DEFINE INPUT PARAMETER pnfs-nr-nota-fis LIKE memorando-nf-item.nfs-nr-nota-fis NO-UNDO.
    DEFINE INPUT PARAMETER pnfs-nr-seq-fat LIKE memorando-nf-item.nfs-nr-seq-fat NO-UNDO.
    DEFINE INPUT PARAMETER pnfe-cod-estabel LIKE memorando-nf-item.nfe-cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnfe-serie LIKE memorando-nf-item.nfe-serie NO-UNDO.
    DEFINE INPUT PARAMETER pnfe-nro-docto LIKE memorando-nf-item.nfe-nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnfe-cod-emitente LIKE memorando-nf-item.nfe-cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnfe-nat-operacao LIKE memorando-nf-item.nfe-nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pnfe-nr-seq LIKE memorando-nf-item.nfe-nr-seq NO-UNDO.

    FIND FIRST bfmemorando-nf-item WHERE 
        bfmemorando-nf-item.nfs-cod-estabel = pnfs-cod-estabel AND 
        bfmemorando-nf-item.nfs-serie = pnfs-serie AND 
        bfmemorando-nf-item.nfs-nr-nota-fis = pnfs-nr-nota-fis AND 
        bfmemorando-nf-item.nfs-nr-seq-fat = pnfs-nr-seq-fat AND 
        bfmemorando-nf-item.nfe-cod-estabel = pnfe-cod-estabel AND 
        bfmemorando-nf-item.nfe-serie = pnfe-serie AND 
        bfmemorando-nf-item.nfe-nro-docto = pnfe-nro-docto AND 
        bfmemorando-nf-item.nfe-cod-emitente = pnfe-cod-emitente AND 
        bfmemorando-nf-item.nfe-nat-operacao = pnfe-nat-operacao AND 
        bfmemorando-nf-item.nfe-nr-seq = pnfe-nr-seq NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmemorando-nf-item THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmemorando-nf-item)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToMemorandoNF DBOProgram 
PROCEDURE linkToMemorandoNF :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.

    RUN getKey IN pHandle(OUTPUT cCodEstabel,
                          OUTPUT cSerie,
                          OUTPUT cNrNotaFis).
    
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
     open query qr{&tableName} FOR EACH {&tableName} 
          NO-LOCK INDEXED-REPOSITION.                                         

     RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfItNotaFisc DBOProgram 
PROCEDURE openQueryOfItNotaFisc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     open query qr{&tableName} FOR EACH  {&tableName} 
                                   WHERE {&tableName}.nfs-cod-estabel = cCodEstabel
                                   AND   {&tableName}.nfs-serie       = cSerie
                                   AND   {&tableName}.nfs-nr-nota-fis = cNrNotaFis
                                   and   {&tableName}.nfs-nr-seq-fat  = iNrSeqFat
                   NO-LOCK INDEXED-REPOSITION.                                         

     RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfNF DBOProgram 
PROCEDURE openQueryOfNF :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     open query qr{&tableName} FOR EACH  {&tableName} 
                                   WHERE {&tableName}.nfs-cod-estabel = cCodEstabel
                                   AND   {&tableName}.nfs-serie       = cSerie
                                   AND   {&tableName}.nfs-nr-nota-fis = cNrNotaFis
                   NO-LOCK 
                   by {&tableName}.nfs-cod-estabel
                   by {&tableName}.nfs-serie
                   by {&tableName}.nfs-nr-nota-fis 
                   by {&tableName}.nfs-nr-seq-fat INDEXED-REPOSITION.                                         

     RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfNF2 DBOProgram 
PROCEDURE openQueryOfNF2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     open query qr{&tableName} FOR EACH  {&tableName} 
                                   WHERE {&tableName}.nfs-cod-estabel  = cCodEstabel
                                   AND   {&tableName}.nfs-serie        = cSerie
                                   AND   {&tableName}.nfs-nr-nota-fis  = cNrNotaFis
                                   and   {&tableName}.nfe-cod-emitente >= iCodEmitIni
                                   and   {&tableName}.nfe-cod-emitente <= iCodEmitFim
                                   and   {&tableName}.num-form >= iNrFormIni
                                   and   {&tableName}.num-form <= iNrFormFim
                   NO-LOCK INDEXED-REPOSITION.                                         

     RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItNotaFisc DBOProgram 
PROCEDURE setConstraintItNotaFisc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF input param pcCodEstabel LIKE estabelec.cod-estabel   NO-UNDO.
    DEF input param pcSerie      LIKE serie.serie             NO-UNDO.
    DEF input param pcNrNotaFis  LIKE nota-fiscal.nr-nota-fis NO-UNDO.
    def input param piNrSeqFat   like it-nota-fisc.nr-seq-fat no-undo.
    
    assign cCodEstabel = pcCodEstabel
           cSerie      = pcSerie     
           cNrNotaFis  = pcNrNotaFis 
           iNrSeqFat   = piNrSeqFat.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfNF DBOProgram 
PROCEDURE setConstraintOfNF :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pcCodEstabel LIKE estabelec.cod-estabel   NO-UNDO.
    DEF INPUT PARAM pcSerie      LIKE serie.serie             NO-UNDO.
    DEF INPUT PARAM pcNrNotaFis  LIKE nota-fiscal.nr-nota-fis NO-UNDO.

    ASSIGN cCodEstabel = pcCodEstabel
           cSerie      = pcSerie     
           cNrNotaFis  = pcNrNotaFis.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfNF2 DBOProgram 
PROCEDURE setConstraintOfNF2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM piCodEmitIni LIKE emitente.cod-emitente       NO-UNDO.
    DEF INPUT PARAM piCodEmitFim LIKE emitente.cod-emitente       NO-UNDO.
    DEF INPUT PARAM piNrFormIni  LIKE memorando-nf-item.num-form  NO-UNDO.
    DEF INPUT PARAM piNrFormFim  LIKE memorando-nf-item.num-form  NO-UNDO.

    ASSIGN iCodEmitIni = piCodEmitIni
           iCodEmitFim = piCodEmitFim
           iNrFormIni  = piNrFormIni 
           iNrFormFim  = piNrFormFim.

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
    IF CAN-FIND(FIRST RowErrors 
                WHERE RowErrors.ErrorSubType = "ERROR":U   
                  AND RowErrors.ErrorType   <> "INTERNAL":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

