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
{include/i-prgvrs.i BOIN710 2.00.00.001} /*** "010001" 29/11/2023 09:07:14  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN710 MUT}
&ENDIF

/*--------------------------------------------------------------------------
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

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN710
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName Desp-item-doc-est
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin710.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram



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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaTotalDespesas DBOProgram 
PROCEDURE calculaTotalDespesas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param rowid-item-doc-est as rowid no-undo.
    def input  param de-quantidade   like item-doc-est.quantidade     no-undo.
    def input  param de-preco-me     like item-doc-est.preco-total-me no-undo.
    def input  param de-desconto-me  like item-doc-est.desconto-me    no-undo.
    def output param de-tot-despesas as dec   no-undo.
    
    def var de-total-me like item-doc-est.preco-total-me no-undo.
    
    find item-doc-est where
         rowid(item-doc-est) = rowid-item-doc-est no-lock no-error.
    
    if  not avail item-doc-est then
        return "NOK":U.
    
    assign de-total-me = (de-preco-me * de-quantidade) - de-desconto-me.

    for each  desp-item-doc-est 
        where desp-item-doc-est.serie-docto  = item-doc-est.serie-docto
          and desp-item-doc-est.nro-docto    = item-doc-est.nro-docto
          and desp-item-doc-est.cod-emitente = item-doc-est.cod-emitente
          and desp-item-doc-est.nat-operacao = item-doc-est.nat-operacao
          and desp-item-doc-est.sequencia    = item-doc-est.sequencia no-lock:
          
        find despesa where
             despesa.cod-despesa = desp-item-doc-est.cod-despesa no-lock no-error.
             
        if  not avail despesa then
            next.
 
        /* Se a despesa Ç aplicada somente na primeira nota e
           n∆o for a primeira parcela ignora a despesa */    
        if  despesa.cdn-aplic-desp = 2 
        and item-doc-est.parcela <> 1 then 
            next.    
        
        /* S¢ recalcula quando nao for informado um valor pelo usu†rio */
        if  despesa.cdn-tp-calculo = 1 /* Percentual */ then do:
            if  desp-item-doc-est.val-despesa = 0 then do:
                assign de-tot-despesas = de-tot-despesas +
                                         (  de-total-me * (desp-item-doc-est.val-per-desp / 100)).
            end.
            else do:
                assign de-tot-despesas = de-tot-despesas + desp-item-doc-est.val-despesa.
            end.
        end.                                 
        else if despesa.cdn-tp-calculo = 2 /* Valor */ then
             assign de-tot-despesas = de-tot-despesas + desp-item-doc-est.val-despesa.
    end.

    return "OK":U.
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
        WHEN "Cod-despesa":U THEN ASSIGN pFieldValue = RowObject.Cod-despesa.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "Dsl-Narrativa":U THEN ASSIGN pFieldValue = RowObject.Dsl-Narrativa.
        WHEN "Nat-operacao":U THEN ASSIGN pFieldValue = RowObject.Nat-operacao.
        WHEN "Nro-docto":U THEN ASSIGN pFieldValue = RowObject.Nro-docto.
        WHEN "Serie-docto":U THEN ASSIGN pFieldValue = RowObject.Serie-docto.
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
        WHEN "Val-despesa":U THEN ASSIGN pFieldValue = RowObject.Val-despesa.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "Val-per-desp":U THEN ASSIGN pFieldValue = RowObject.Val-per-desp.
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
        WHEN "Cod-emitente":U THEN ASSIGN pFieldValue = RowObject.Cod-emitente.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "Num-seq-desp":U THEN ASSIGN pFieldValue = RowObject.Num-seq-desp.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "Situacao":U THEN ASSIGN pFieldValue = RowObject.Situacao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice Desp-item
  Parameters:  
               retorna valor do campo Serie-docto
               retorna valor do campo Nro-docto
               retorna valor do campo Cod-emitente
               retorna valor do campo Nat-operacao
               retorna valor do campo sequencia
               retorna valor do campo Num-seq-desp
               retorna valor do campo Cod-despesa
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pSerie-docto LIKE Desp-item-doc-est.Serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pNro-docto LIKE Desp-item-doc-est.Nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pCod-emitente LIKE Desp-item-doc-est.Cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pNat-operacao LIKE Desp-item-doc-est.Nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE Desp-item-doc-est.sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pNum-seq-desp LIKE Desp-item-doc-est.Num-seq-desp NO-UNDO.
    DEFINE OUTPUT PARAMETER pCod-despesa LIKE Desp-item-doc-est.Cod-despesa NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pSerie-docto = RowObject.Serie-docto
           pNro-docto = RowObject.Nro-docto
           pCod-emitente = RowObject.Cod-emitente
           pNat-operacao = RowObject.Nat-operacao
           psequencia = RowObject.sequencia
           pNum-seq-desp = RowObject.Num-seq-desp
           pCod-despesa = RowObject.Cod-despesa.

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
  Purpose:     Reposiciona registro com base no °ndice Desp-item
  Parameters:  
               recebe valor do campo Serie-docto
               recebe valor do campo Nro-docto
               recebe valor do campo Cod-emitente
               recebe valor do campo Nat-operacao
               recebe valor do campo sequencia
               recebe valor do campo Num-seq-desp
               recebe valor do campo Cod-despesa
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pSerie-docto LIKE Desp-item-doc-est.Serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pNro-docto LIKE Desp-item-doc-est.Nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pCod-emitente LIKE Desp-item-doc-est.Cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pNat-operacao LIKE Desp-item-doc-est.Nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE Desp-item-doc-est.sequencia NO-UNDO.
    DEFINE INPUT PARAMETER pNum-seq-desp LIKE Desp-item-doc-est.Num-seq-desp NO-UNDO.
    DEFINE INPUT PARAMETER pCod-despesa LIKE Desp-item-doc-est.Cod-despesa NO-UNDO.

    FIND FIRST bfDesp-item-doc-est WHERE 
        bfDesp-item-doc-est.Serie-docto = pSerie-docto AND 
        bfDesp-item-doc-est.Nro-docto = pNro-docto AND 
        bfDesp-item-doc-est.Cod-emitente = pCod-emitente AND 
        bfDesp-item-doc-est.Nat-operacao = pNat-operacao AND 
        bfDesp-item-doc-est.sequencia = psequencia AND 
        bfDesp-item-doc-est.Num-seq-desp = pNum-seq-desp AND 
        bfDesp-item-doc-est.Cod-despesa = pCod-despesa NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfDesp-item-doc-est THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfDesp-item-doc-est)).
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
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&queryName} for each {&tableName} 
         no-lock indexed-reposition.

     return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



