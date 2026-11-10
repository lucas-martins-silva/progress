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
{include/i-prgvrs.i BOCX337 2.00.00.002 } /*** "010002" 11/12/2023 10:13:25 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX337 MUT}
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
&GLOBAL-DEFINE DBOName BOCX337
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName memorando-sdo
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{cxbo/bocx337.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var iCodEmitente as int   no-undo.
def var cSerieDocto  as char  no-undo.
def var cNroDocto    as char  no-undo.
def var cNatOperacao as char  no-undo.


DEF VAR cDoctoIni   LIKE memorando-sdo.nfe-nro-docto       NO-UNDO.
DEF VAR cDoctoFim   LIKE memorando-sdo.nfe-nro-docto       NO-UNDO.
DEF VAR iCodEmitIni LIKE memorando-sdo.nfe-cod-emitente    NO-UNDO.
DEF VAR iCodEmitFim LIKE memorando-sdo.nfe-cod-emitente    NO-UNDO.
DEF VAR cNatOperIni LIKE memorando-sdo.nfe-nat-operacao    NO-UNDO.
DEF VAR cNatOperFim LIKE memorando-sdo.nfe-nat-operacao    NO-UNDO.
DEF VAR cItemIni    LIKE memorando-sdo.nfe-it-codigo       NO-UNDO.
DEF VAR cItemFim    LIKE memorando-sdo.nfe-it-codigo       NO-UNDO.   
DEF VAR cSerieIni   LIKE memorando-sdo.nfe-serie           NO-UNDO.
DEF VAR cSerieFim   LIKE memorando-sdo.nfe-serie           NO-UNDO.
DEF VAR iSeqIni     LIKE memorando-sdo.nfe-nr-seq          NO-UNDO.
DEF VAR iSeqFim     LIKE memorando-sdo.nfe-nr-seq          NO-UNDO.
DEF VAR daDtParam   LIKE memorando-sdo.dat-entr            NO-UNDO.

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
        WHEN "nfe-cod-refer":U THEN ASSIGN pFieldValue = RowObject.nfe-cod-refer.
        WHEN "nfe-it-codigo":U THEN ASSIGN pFieldValue = RowObject.nfe-it-codigo.
        WHEN "nfe-nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nfe-nat-operacao.
        WHEN "nfe-nro-docto":U THEN ASSIGN pFieldValue = RowObject.nfe-nro-docto.
        WHEN "nfe-serie":U THEN ASSIGN pFieldValue = RowObject.nfe-serie.
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
        WHEN "dat-entr":U THEN ASSIGN pFieldValue = RowObject.dat-entr.
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
        WHEN "qtd-origin":U THEN ASSIGN pFieldValue = RowObject.qtd-origin.
        WHEN "qtd-sdo-memorando":U THEN ASSIGN pFieldValue = RowObject.qtd-sdo-memorando.
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
  Purpose:     Retorna valores dos campos do °ndice mmrndsd-id
  Parameters:  
               retorna valor do campo nfe-cod-estabel
               retorna valor do campo nfe-serie
               retorna valor do campo nfe-nro-docto
               retorna valor do campo nfe-cod-emitente
               retorna valor do campo nfe-nat-operacao
               retorna valor do campo nfe-nr-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnfe-cod-estabel LIKE memorando-sdo.nfe-cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnfe-serie LIKE memorando-sdo.nfe-serie NO-UNDO.
    DEFINE OUTPUT PARAMETER pnfe-nro-docto LIKE memorando-sdo.nfe-nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnfe-cod-emitente LIKE memorando-sdo.nfe-cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnfe-nat-operacao LIKE memorando-sdo.nfe-nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pnfe-nr-seq LIKE memorando-sdo.nfe-nr-seq NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnfe-cod-estabel = RowObject.nfe-cod-estabel
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
  Purpose:     Reposiciona registro com base no °ndice mmrndsd-id
  Parameters:  
               recebe valor do campo nfe-cod-estabel
               recebe valor do campo nfe-serie
               recebe valor do campo nfe-nro-docto
               recebe valor do campo nfe-cod-emitente
               recebe valor do campo nfe-nat-operacao
               recebe valor do campo nfe-nr-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnfe-cod-estabel     LIKE memorando-sdo.nfe-cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER pnfe-serie           LIKE memorando-sdo.nfe-serie        NO-UNDO.
    DEFINE INPUT PARAMETER pnfe-nro-docto       LIKE memorando-sdo.nfe-nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pnfe-cod-emitente    LIKE memorando-sdo.nfe-cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnfe-nat-operacao    LIKE memorando-sdo.nfe-nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pnfe-nr-seq          LIKE memorando-sdo.nfe-nr-seq       NO-UNDO.

    FIND FIRST bfmemorando-sdo WHERE 
        bfmemorando-sdo.nfe-cod-estabel = pnfe-cod-estabel AND 
        bfmemorando-sdo.nfe-serie = pnfe-serie AND 
        bfmemorando-sdo.nfe-nro-docto = pnfe-nro-docto AND 
        bfmemorando-sdo.nfe-cod-emitente = pnfe-cod-emitente AND 
        bfmemorando-sdo.nfe-nat-operacao = pnfe-nat-operacao AND 
        bfmemorando-sdo.nfe-nr-seq = pnfe-nr-seq NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmemorando-sdo THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmemorando-sdo)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToDocumEst DBOProgram 
PROCEDURE linkToDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter pHandle as handle no-undo.                              

    run getKey in pHandle ( output cSerieDocto,
                            output cNroDocto,
                            output iCodEmitente,
                            output cNatOperacao ).

    RETURN "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixa DBOProgram 
PROCEDURE openQueryFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   open query qr{&tableName} 
       FOR EACH  {&tableName} 
           WHERE {&tableName}.nfe-nro-docto    >= cDoctoIni  
           AND   {&tableName}.nfe-nro-docto    <= cDoctoFim  
           AND   {&tableName}.nfe-cod-emitente >= iCodEmitIni
           AND   {&tableName}.nfe-cod-emitente <= iCodEmitFim
           AND   {&tableName}.nfe-nat-operacao >= cNatOperIni
           AND   {&tableName}.nfe-nat-operacao <= cNatOperFim
           AND   {&tableName}.nfe-it-codigo    >= cItemIni   
           AND   {&tableName}.nfe-it-codigo    <= cItemFim   
           AND   {&tableName}.nfe-serie        >= cSerieIni  
           AND   {&tableName}.nfe-serie        <= cSerieFim  
           AND   {&tableName}.nfe-nr-seq       >= iSeqIni    
           AND   {&tableName}.nfe-nr-seq       <= iSeqFim NO-LOCK 
            BY {&tableName}.nfe-nro-docto 
            BY {&tableName}.nfe-cod-emitente
            BY {&tableName}.nfe-nat-operacao
            BY {&tableName}.nfe-it-codigo
            BY {&tableName}.nfe-serie 
            BY {&tableName}.nfe-nr-seq INDEXED-REPOSITION.                                         
    
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEntrSdo DBOProgram 
PROCEDURE openQueryEntrSdo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   open query qr{&tableName} FOR EACH {&tableName} 
       WHERE  {&tableName}.dat-entr  >= daDtParam
       AND    {&tableName}.qtd-sdo-memorando > 0
       NO-LOCK INDEXED-REPOSITION.                                         
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDocumEst DBOProgram 
PROCEDURE openQueryOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
         where {&tableName}.nfe-cod-emitente = iCodEmitente
           and {&tableName}.nfe-serie        = cSerieDocto
           and {&tableName}.nfe-nro-docto    = cNroDocto
           and {&tableName}.nfe-nat-operacao = cNatOperacao no-lock
        BY {&tableName}.nfe-cod-emitente
        BY {&tableName}.nfe-serie       
        BY {&tableName}.nfe-nro-docto   
        BY {&tableName}.nfe-nat-operacao
        BY {&tableName}.nfe-nr-seq
        indexed-reposition.

    return "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEntrSdo DBOProgram 
PROCEDURE setConstraintEntrSdo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pdaDtParam   LIKE memorando-sdo.dat-entr            NO-UNDO.

    ASSIGN daDtParam   = pdaDtParam.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixa DBOProgram 
PROCEDURE setConstraintFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pcDoctoIni   LIKE memorando-sdo.nfe-nro-docto       NO-UNDO.
    DEF INPUT PARAM pcDoctoFim   LIKE memorando-sdo.nfe-nro-docto       NO-UNDO.
    DEF INPUT PARAM piCodEmitIni LIKE memorando-sdo.nfe-cod-emitente    NO-UNDO.
    DEF INPUT PARAM piCodEmitFim LIKE memorando-sdo.nfe-cod-emitente    NO-UNDO.
    DEF INPUT PARAM pcNatOperIni LIKE memorando-sdo.nfe-nat-operacao    NO-UNDO.
    DEF INPUT PARAM pcNatOperFim LIKE memorando-sdo.nfe-nat-operacao    NO-UNDO.
    DEF INPUT PARAM pcItemIni    LIKE memorando-sdo.nfe-it-codigo       NO-UNDO.
    DEF INPUT PARAM pcItemFim    LIKE memorando-sdo.nfe-it-codigo       NO-UNDO.   
    DEF INPUT PARAM pcSerieIni   LIKE memorando-sdo.nfe-serie           NO-UNDO.
    DEF INPUT PARAM pcSerieFim   LIKE memorando-sdo.nfe-serie           NO-UNDO.
    DEF INPUT PARAM piSeqIni     LIKE memorando-sdo.nfe-nr-seq          NO-UNDO.
    DEF INPUT PARAM piSeqFim     LIKE memorando-sdo.nfe-nr-seq          NO-UNDO.

    ASSIGN cDoctoIni   = pcDoctoIni  
           cDoctoFim   = pcDoctoFim  
           iCodEmitIni = piCodEmitIni
           iCodEmitFim = piCodEmitFim
           cNatOperIni = pcNatOperIni
           cNatOperFim = pcNatOperFim
           cItemIni    = pcItemIni   
           cItemFim    = pcItemFim   
           cSerieIni   = pcSerieIni  
           cSerieFim   = pcSerieFim  
           iSeqIni     = piSeqIni    
           iSeqFim     = piSeqFim.

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
    CASE pType:
        WHEN "Delete":U THEN DO:
            IF RowObject.qtd-sdo-memorando <> RowObject.qtd-origin THEN
                IF NOT CAN-FIND(FIRST RowErrors 
                                WHERE RowErrors.ErrorNumber = 30166) THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="30166" 
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"}
                END.
        END.
    END CASE.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors 
                WHERE RowErrors.ErrorSubType = "ERROR":U
                  AND RowErrors.ErrorType   <> "INTERNAL":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

