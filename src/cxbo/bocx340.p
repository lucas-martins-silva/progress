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
{include/i-prgvrs.i BOCX340 2.00.00.001} /*** "010001" 11/12/2023 10:13:25 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX340 MUT}
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
&GLOBAL-DEFINE DBOName BOCX340
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName memorando-movto
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{cxbo/bocx340.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF VAR cCodEstabel  LIKE memorando-movto.nfe-cod-estabel   NO-UNDO.
DEF VAR cSerie       LIKE memorando-movto.nfe-serie         NO-UNDO.
DEF VAR cNroDocto    LIKE memorando-movto.nfe-nro-docto     NO-UNDO.
DEF VAR iCodEmitente LIKE memorando-movto.nfe-cod-emitente  NO-UNDO. 
DEF VAR cNatOperacao LIKE memorando-movto.nfe-nat-operacao  NO-UNDO.
DEF VAR iNrSeq       LIKE memorando-movto.nfe-nr-seq        NO-UNDO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaMovtosSdo DBOProgram 
PROCEDURE eliminaMovtosSdo :
/*------------------------------------------------------------------------------
  Purpose:     Elimina os Memorando Movimentos relacionados ao Memorando Saldo
  Parameters:  
  Notes: Antes de ser referenciada a chamada a esta procedure dever† ser executada
         a goToKey com o primeiro registro da memorando-movto relacionada ao 
         memorando-sdo       
------------------------------------------------------------------------------*/

    FOR EACH  bfmemorando-movto 
        WHERE bfmemorando-movto.nfe-cod-estabel  = RowObject.nfe-cod-estabel 
        AND   bfmemorando-movto.nfe-serie        = RowObject.nfe-serie 
        AND   bfmemorando-movto.nfe-nro-docto    = RowObject.nfe-nro-docto 
        AND   bfmemorando-movto.nfe-cod-emitente = RowObject.nfe-cod-emitente 
        AND   bfmemorando-movto.nfe-nat-operacao = RowObject.nfe-nat-operacao 
        AND   bfmemorando-movto.nfe-nr-seq       = RowObject.nfe-nr-seq NO-LOCK:

        /*--- Reposiciona rowid do registro corrente ---*/
        RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmemorando-movto)).

        /*--- Elimina registro corrente ---*/
        RUN deleteRecord IN THIS-PROCEDURE.
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
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-usuar":U THEN ASSIGN pFieldValue = RowObject.cod-usuar.
        WHEN "dsl-histor-movto-memorando":U THEN ASSIGN pFieldValue = RowObject.dsl-histor-movto-memorando.
        WHEN "hra-movto":U THEN ASSIGN pFieldValue = RowObject.hra-movto.
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
        WHEN "dat-movto":U THEN ASSIGN pFieldValue = RowObject.dat-movto.
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
        WHEN "qtd-movto":U THEN ASSIGN pFieldValue = RowObject.qtd-movto.
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
        WHEN "idi-tip-movto":U THEN ASSIGN pFieldValue = RowObject.idi-tip-movto.
        WHEN "nfe-cod-emitente":U THEN ASSIGN pFieldValue = RowObject.nfe-cod-emitente.
        WHEN "nfe-nr-seq":U THEN ASSIGN pFieldValue = RowObject.nfe-nr-seq.
        WHEN "nfs-nr-seq-fat":U THEN ASSIGN pFieldValue = RowObject.nfs-nr-seq-fat.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-seq-movto":U THEN ASSIGN pFieldValue = RowObject.num-seq-movto.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice mmrndmvt-id
  Parameters:  
               retorna valor do campo nfe-cod-estabel
               retorna valor do campo nfe-serie
               retorna valor do campo nfe-nro-docto
               retorna valor do campo nfe-cod-emitente
               retorna valor do campo nfe-nat-operacao
               retorna valor do campo nfe-nr-seq
               retorna valor do campo num-seq-movto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnfe-cod-estabel LIKE memorando-movto.nfe-cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnfe-serie LIKE memorando-movto.nfe-serie NO-UNDO.
    DEFINE OUTPUT PARAMETER pnfe-nro-docto LIKE memorando-movto.nfe-nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnfe-cod-emitente LIKE memorando-movto.nfe-cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnfe-nat-operacao LIKE memorando-movto.nfe-nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pnfe-nr-seq LIKE memorando-movto.nfe-nr-seq NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-movto LIKE memorando-movto.num-seq-movto NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnfe-cod-estabel = RowObject.nfe-cod-estabel
           pnfe-serie = RowObject.nfe-serie
           pnfe-nro-docto = RowObject.nfe-nro-docto
           pnfe-cod-emitente = RowObject.nfe-cod-emitente
           pnfe-nat-operacao = RowObject.nfe-nat-operacao
           pnfe-nr-seq = RowObject.nfe-nr-seq
           pnum-seq-movto = RowObject.num-seq-movto.

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
  Purpose:     Reposiciona registro com base no °ndice mmrndmvt-id
  Parameters:  
               recebe valor do campo nfe-cod-estabel
               recebe valor do campo nfe-serie
               recebe valor do campo nfe-nro-docto
               recebe valor do campo nfe-cod-emitente
               recebe valor do campo nfe-nat-operacao
               recebe valor do campo nfe-nr-seq
               recebe valor do campo num-seq-movto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnfe-cod-estabel  LIKE memorando-movto.nfe-cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER pnfe-serie        LIKE memorando-movto.nfe-serie        NO-UNDO.
    DEFINE INPUT PARAMETER pnfe-nro-docto    LIKE memorando-movto.nfe-nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pnfe-cod-emitente LIKE memorando-movto.nfe-cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnfe-nat-operacao LIKE memorando-movto.nfe-nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pnfe-nr-seq       LIKE memorando-movto.nfe-nr-seq       NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-movto    LIKE memorando-movto.num-seq-movto    NO-UNDO.

    FIND FIRST bfmemorando-movto WHERE 
        bfmemorando-movto.nfe-cod-estabel = pnfe-cod-estabel AND 
        bfmemorando-movto.nfe-serie = pnfe-serie AND 
        bfmemorando-movto.nfe-nro-docto = pnfe-nro-docto AND 
        bfmemorando-movto.nfe-cod-emitente = pnfe-cod-emitente AND 
        bfmemorando-movto.nfe-nat-operacao = pnfe-nat-operacao AND 
        bfmemorando-movto.nfe-nr-seq = pnfe-nr-seq AND 
        bfmemorando-movto.num-seq-movto = pnum-seq-movto NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmemorando-movto THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmemorando-movto)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey2 DBOProgram 
PROCEDURE goToKey2 :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice mmrndmvt-id
  Parameters:  
               recebe valor do campo nfe-cod-estabel
               recebe valor do campo nfe-serie
               recebe valor do campo nfe-nro-docto
               recebe valor do campo nfe-cod-emitente
               recebe valor do campo nfe-nat-operacao
               recebe valor do campo nfe-nr-seq
               recebe valor do campo num-seq-movto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnfe-cod-estabel  LIKE memorando-movto.nfe-cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER pnfe-serie        LIKE memorando-movto.nfe-serie        NO-UNDO.
    DEFINE INPUT PARAMETER pnfe-nro-docto    LIKE memorando-movto.nfe-nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pnfe-cod-emitente LIKE memorando-movto.nfe-cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnfe-nat-operacao LIKE memorando-movto.nfe-nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pnfe-nr-seq       LIKE memorando-movto.nfe-nr-seq       NO-UNDO.
    
    FIND FIRST bfmemorando-movto WHERE 
        bfmemorando-movto.nfe-cod-estabel = pnfe-cod-estabel AND 
        bfmemorando-movto.nfe-serie = pnfe-serie AND 
        bfmemorando-movto.nfe-nro-docto = pnfe-nro-docto AND 
        bfmemorando-movto.nfe-cod-emitente = pnfe-cod-emitente AND 
        bfmemorando-movto.nfe-nat-operacao = pnfe-nat-operacao AND 
        bfmemorando-movto.nfe-nr-seq = pnfe-nr-seq NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmemorando-movto THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmemorando-movto)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToMemorandoSdo DBOProgram 
PROCEDURE linkToMemorandoSdo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pHandle AS HANDLE NO-UNDO.

    RUN getKey IN pHandle (OUTPUT cCodEstabel, 
                           OUTPUT cSerie,
                           OUTPUT cNroDocto,
                           OUTPUT iCodEmitente,
                           OUTPUT cNatOperacao,
                           OUTPUT iNrSeq).
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItem DBOProgram 
PROCEDURE openQueryItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query qr{&tableName} 
         FOR EACH  {&tableName} 
             WHERE {&tableName}.nfe-cod-estabel  = cCodEstabel 
             AND   {&tableName}.nfe-serie        = cSerie      
             AND   {&tableName}.nfe-nro-docto    = cNroDocto   
             AND   {&tableName}.nfe-cod-emitente = iCodEmitente
             AND   {&tableName}.nfe-nat-operacao = cNatOperacao
             AND   {&tableName}.nfe-nr-seq       = iNrSeq
        NO-LOCK INDEXED-REPOSITION.                                         

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItem DBOProgram 
PROCEDURE setConstraintItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pcCodEstabel  LIKE memorando-movto.nfe-cod-estabel    NO-UNDO.
    DEF INPUT PARAM pcSerie       LIKE memorando-movto.nfe-serie          NO-UNDO.
    DEF INPUT PARAM pcNroDocto    LIKE memorando-movto.nfe-nro-docto      NO-UNDO.
    DEF INPUT PARAM piCodEmitente LIKE memorando-movto.nfe-cod-emitente   NO-UNDO.
    DEF INPUT PARAM pcNatOperacao LIKE memorando-movto.nfe-nat-operacao   NO-UNDO.
    DEF INPUT PARAM piNrSeq       LIKE memorando-movto.nfe-nr-seq         NO-UNDO.

    ASSIGN cCodEstabel  = pcCodEstabel 
           cSerie       = pcSerie      
           cNroDocto    = pcNroDocto   
           iCodEmitente = piCodEmitente
           cNatOperacao = pcNatOperacao
           iNrSeq       = piNrSeq.

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

