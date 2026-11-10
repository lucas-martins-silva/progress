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
{include/i-prgvrs.i BOIN709 2.00.00.004 } /*** "010004" 17/06/2025 16:40:52 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN709 MUT}
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
&GLOBAL-DEFINE DBOName BOIN709
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName desp-item-contrat
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin709.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{utp/ut-glob.i}
/* MULTI-PLANTA */
DEF VAR i-tipo-movto AS INTEGER NO-UNDO.
{cdp/cd7300.i1}
/****************/

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var i-nr-contrato  like item-contrat.nr-contrato       no-undo.
def var i-num-seq-item like item-contrat.num-seq-item      no-undo.
def var i-num-seq-desp like desp-item-contrat.num-seq-desp no-undo.
def var c-cod-despesa  like desp-item-contrat.cod-despesa  no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-contrat DBOProgram 
FUNCTION fn-contrat RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
         HEIGHT             = 9.92
         WIDTH              = 62.29.
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

    DEF INPUT  PARAM rowid-item-contrat AS ROWID   NO-UNDO.
    DEF OUTPUT PARAM de-tot-despesas    AS DECIMAL NO-UNDO.

    DEF VAR de-valor-desp               AS DEC     NO-UNDO.

    FIND item-contrat WHERE
         ROWID(item-contrat) = rowid-item-contrat NO-LOCK NO-ERROR.
         
    IF  NOT AVAIL item-contrat THEN
        RETURN "NOK":U.

    FOR EACH  desp-item-contrat
        WHERE desp-item-contrat.nr-contrato  = item-contrat.nr-contrato
          AND desp-item-contrat.num-seq-item = item-contrat.num-seq-item EXCLUSIVE-LOCK:

        FOR FIRST despesa FIELDS(cdn-tp-calculo) 
            WHERE despesa.cod-despesa = desp-item-contrat.cod-despesa NO-LOCK: END.
        
        IF  NOT AVAIL despesa THEN
            NEXT.
        
        IF  despesa.cdn-tp-calculo = 1 /* Percentual */ THEN
            ASSIGN desp-item-contrat.val-despesa = (item-contrat.pre-unit-for * fn-contrat()) 
                                                   * desp-item-contrat.val-per-desp / 100
                   de-valor-desp                 = desp-item-contrat.val-despesa. 
        ELSE
            ASSIGN de-valor-desp = desp-item-contrat.val-despesa.
          
        ASSIGN de-tot-despesas = de-tot-despesas + de-valor-desp.
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
        WHEN "Cod-despesa":U THEN ASSIGN pFieldValue = RowObject.Cod-despesa.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "Dsl-Narrativa":U THEN ASSIGN pFieldValue = RowObject.Dsl-Narrativa.
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
        WHEN "num-seq-desp":U THEN ASSIGN pFieldValue = RowObject.num-seq-desp.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "Num-seq-desp":U THEN ASSIGN pFieldValue = RowObject.Num-seq-desp.
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice desp-item-contrat
  Parameters:  
               retorna valor do campo nr-contrato
               retorna valor do campo num-seq-item
               retorna valor do campo num-seq-desp
               retorna valor do campo Cod-despesa
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-contrato  LIKE desp-item-contrat.nr-contrato  NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-item LIKE desp-item-contrat.num-seq-item NO-UNDO.
    DEFINE OUTPUT PARAMETER pNum-seq-desp LIKE desp-item-contrat.Num-seq-desp NO-UNDO.
    DEFINE OUTPUT PARAMETER pCod-despesa  LIKE desp-item-contrat.Cod-despesa  NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-contrato = RowObject.nr-contrato
           pnum-seq-desp = RowObject.num-seq-desp
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSeqDespesa DBOProgram 
PROCEDURE getSeqDespesa :
/*------------------------------------------------------------------------------
  Notes: Retorna a sequencia da proxima despesa do contrato
------------------------------------------------------------------------------*/

    def input param p-nr-contrato  like item-contrat.nr-contrato no-undo.
    def input param p-num-seq-item like item-contrat.num-seq-item no-undo.
    def output param p-seq-desp    like desp-item-contrat.num-seq-desp no-undo.
    
    find last desp-item-contrat 
         where desp-item-contrat.nr-contrato  = p-nr-contrato
           and desp-item-contrat.num-seq-item = p-num-seq-item no-lock no-error.
    if  avail desp-item-contrat then
        assign p-seq-desp = desp-item-contrat.num-seq-desp + 1.
    else
        assign p-seq-desp = 1.
        
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice desp-item-contrat
  Parameters:  
               recebe valor do campo nr-contrato
               recebe valor do campo num-seq-item
               recebe valor do campo Num-seq-desp
               recebe valor do campo Cod-despesa
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-contrato  LIKE desp-item-contrat.nr-contrato  NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-item LIKE desp-item-contrat.num-seq-item NO-UNDO.
    DEFINE INPUT PARAMETER pNum-seq-desp LIKE desp-item-contrat.Num-seq-desp NO-UNDO.
    DEFINE INPUT PARAMETER pCod-despesa  LIKE desp-item-contrat.Cod-despesa  NO-UNDO.

    FIND FIRST bfdesp-item-contrat WHERE
        bfdesp-item-contrat.nr-contrato = pnr-contrato AND 
        bfdesp-item-contrat.num-seq-item = pnum-seq-item AND 
        bfdesp-item-contrat.Num-seq-desp = pNum-seq-desp AND 
        bfdesp-item-contrat.Cod-despesa = pCod-despesa NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdesp-item-contrat THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdesp-item-contrat)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToContrat DBOProgram 
PROCEDURE linkToContrat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-handle as handle no-undo.
    
    run getKey in p-handle(output i-nr-contrato,
                           output i-num-seq-item,
                           output i-num-seq-desp,
                           output c-cod-despesa).
    
    return "OK":U.
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

    open query {&queryName} for each {&tableName} no-lock indexed-reposition.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfItemContrat DBOProgram 
PROCEDURE openQueryOfItemContrat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&queryName} for each  {&tableName}
                                where {&tableName}.nr-contrato  = i-nr-contrato
                                  and {&tableName}.num-seq-item = i-num-seq-item
                                  and {&tableName}.num-seq-desp = i-num-seq-desp
                                  and {&tableName}.cod-despesa  = c-cod-despesa
                                  no-lock indexed-reposition.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recalculaDespesa DBOProgram 
PROCEDURE recalculaDespesa :
/*------------------------------------------------------------------------------
  Parameters: rw-item-contrat - rowid da item-contrat
              rw-desp-contrat - rowid da desp-item-contrat
  Notes: Calcula o valor da despesa com base nos parÉmetros da despesa.
         Este mÇtodo Ç utilizado por consultas e relat¢rios e serve para que se
         possa consultar o valor total das despesas de uma compra.      
------------------------------------------------------------------------------*/
   DEF INPUT  PARAM rw-item-contrat AS ROWID NO-UNDO.
   DEF INPUT  PARAM rw-desp-contrat AS ROWID NO-UNDO.
   DEF OUTPUT PARAM de-valor-desp   LIKE desp-item-contrat.val-despesa NO-UNDO.
   
   FOR FIRST item-contrat FIELDS(pre-unit-for qtd-total)
       WHERE ROWID(item-contrat) = rw-item-contrat NO-LOCK: END.

   IF  NOT AVAIL item-contrat THEN
       RETURN "NOK":U.

   FIND desp-item-contrat WHERE 
        ROWID(desp-item-contrat) = rw-desp-contrat EXCLUSIVE-LOCK NO-ERROR.

   IF  NOT AVAIL desp-item-contrat THEN
       RETURN "NOK":U.
   
   FOR FIRST despesa FIELDS(cdn-tp-calculo)
       WHERE despesa.cod-despesa = desp-item-contrat.cod-despesa NO-LOCK: END.

   IF  NOT AVAIL despesa THEN
       RETURN "NOK":U.

   IF  despesa.cdn-tp-calculo = 1 /* Percentual */ THEN
       ASSIGN desp-item-contrat.val-despesa = (item-contrat.pre-unit-for * fn-contrat()) 
                                              * desp-item-contrat.val-per-desp / 100
              de-valor-desp                 = desp-item-contrat.val-despesa.
   ELSE
       ASSIGN de-valor-desp = desp-item-contrat.val-despesa.
    
   /* Efetiva a alteraá∆o e libera o registro desp-item-contrat */
   RELEASE desp-item-contrat.

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recalcValorDesp DBOProgram 
PROCEDURE recalcValorDesp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param rowid-contrat as rowid no-undo.
    def input param rowid-desp    as rowid no-undo.
    def var de-total-desp like desp-item-contrat.val-despesa no-undo.
    
    /* C†lculo est† sendo desviado para outra procedure para
       que o c¢digo n∆o fique duplicado */
    run recalculaDespesa (rowid-contrat, rowid-desp, output de-total-desp).
    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnExisteDesp DBOProgram 
PROCEDURE returnExisteDesp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Verifica se existe alguma despesa para o contrato.       
------------------------------------------------------------------------------*/

    def input  param rowid-contrat as rowid no-undo.
    def output param l-existe      as log   no-undo.
    
    for first item-contrat fields(nr-contrato num-seq-item)
        where rowid(item-contrat) = rowid-contrat no-lock,
        first desp-item-contrat fields()
        where desp-item-contrat.nr-contrato  = item-contrat.nr-contrato
          and desp-item-contrat.num-seq-item = item-contrat.num-seq-item no-lock: end.
          
    assign l-existe = avail item-contrat.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sugereDespesas DBOProgram 
PROCEDURE sugereDespesas :
/*------------------------------------------------------------------------------
  Parameters: rowid-contrat - rowid da tabela item-contrat
  Notes:      Esta procedure somente deve ser executada se n∆o existir nenhuma
              despesa cadastrada para a cotaá∆o, caso contr†rio as mesmas ser∆o
              eliminadas e substitu°das
------------------------------------------------------------------------------*/
    def input param rowid-contrat as rowid no-undo.
    
    def var de-valor-display like desp-item-contrat.val-despesa no-undo.

    find item-contrat where
         rowid(item-contrat) = rowid-contrat no-lock no-error.
    
    if  not avail item-contrat then
        return "NOK":U.

    find contrato-for where 
         contrato-for.nr-contrato = item-contrat.nr-contrato no-lock no-error.

    if  not avail contrato-for then
        return "NOK":U.

    session:set-wait-state("general":U).
    
    /*--- Elimina todas as despesas da cotaá∆o antes de sugerir ---*/ 
    for each  desp-item-contrat
        where desp-item-contrat.nr-contrato  = item-contrat.nr-contrato
          and desp-item-contrat.num-seq-item = item-contrat.num-seq-item exclusive-lock:
          delete desp-item-contrat no-error.
    end.

    /*********************************************************************
    ** Para criaá∆o da desp-item-contrat deve-se observar o seguinte:
    ** 1. Quando  houver relacionamento  item-fornec-estab deve-se dar
    **    prioridade para este n°vel.
    ** 2. Caso n∆o haja despesas a n°vel de item-fornec-estab, deve-se
    **    buscar as despesas no relacionamento item-fornec.
    ** 3. Dever† verificar se o item-fornec est† ativo.
    *********************************************************************/
    /* Verifica a existància do relacionamento item-fornec-estab. */     
    if  can-find(first item-fornec-estab
                 where item-fornec-estab.it-codigo    = item-contrat.it-codigo
                   and item-fornec-estab.cod-emitente    = item-contrat.cod-emitente
                   and item-fornec-estab.cod-estabel  = contrato-for.cod-estabel
                   and item-fornec-estab.ativo)
    and can-find(first desp-item-fornec-estab
                 where desp-item-fornec-estab.it-codigo   = item-contrat.it-codigo
                   and desp-item-fornec-estab.Cod-emite   = item-contrat.cod-emitente
                   and desp-item-fornec-estab.cod-estabel = contrato-for.cod-estabel) then do:

        /* Caso exista o relacionamento item-fornec-estab e esteja ativo e
           tenha alguma despesa cadastrada para o relacionamento, copia as 
           despesas para o contrato */
        for each  desp-item-fornec-estab
            where desp-item-fornec-estab.it-codigo   = item-contrat.it-codigo
              and desp-item-fornec-estab.cod-emite   = item-contrat.cod-emitente 
              and desp-item-fornec-estab.cod-estabel = contrato-for.cod-estabel no-lock:
              
            find despesa where
                 despesa.cod-despesa = desp-item-fornec-estab.cod-despesa no-lock no-error.
            if  not avail despesa then
                next.
            
            /* Cria registro na base */
            create desp-item-contrat.
            assign desp-item-contrat.nr-contrato  = item-contrat.nr-contrato
                   desp-item-contrat.num-seq-item = item-contrat.num-seq-item
                   desp-item-contrat.cod-despesa  = desp-item-fornec-estab.cod-despesa
                   desp-item-contrat.num-seq-desp = desp-item-fornec-estab.num-seq-desp
                   desp-item-contrat.val-despesa  = desp-item-fornec-estab.val-despesa
                   desp-item-contrat.val-per-desp = desp-item-fornec-estab.val-per-desp.        
            
            /* Recalcula o valor da despesa pelo valor da cotacao */           
            run recalculaDespesa (input rowid(item-contrat),
                                  input rowid(desp-item-contrat),
                                  output de-valor-display).
        end.       
    end.
    /* Verifica a existància do relacionamento item-fornec. */
    else if  can-find(first item-fornec
                      where item-fornec.it-codigo = item-contrat.it-codigo
                        and item-fornec.cod-emitente = item-contrat.cod-emitente
                        and item-fornec.ativo)
         and can-find(first desp-item-fornec
                      where desp-item-fornec.it-codigo = item-contrat.it-codigo
                        and desp-item-fornec.cod-emitente = item-contrat.cod-emitente) then do:

        /* Caso exista o relacionamento item-fornec e esteja ativo e
           tenha alguma despesa cadastrada para o relacionamento, 
           copia as despesas para a cotacao */

        for each  desp-item-fornec
            where desp-item-fornec.it-codigo = item-contrat.it-codigo
              and desp-item-fornec.cod-emitente = item-contrat.cod-emitente no-lock:
              
            find despesa where
                 despesa.cod-despesa = desp-item-fornec.cod-despesa no-lock no-error.
            if  not avail despesa then
                next.

            /* Cria registro na base */
            create desp-item-contrat.
            assign desp-item-contrat.nr-contrato  = item-contrat.nr-contrato
                   desp-item-contrat.num-seq-item = item-contrat.num-seq-item
                   desp-item-contrat.cod-despesa  = desp-item-fornec.cod-despesa
                   desp-item-contrat.num-seq-desp = desp-item-fornec.num-seq-desp
                   desp-item-contrat.val-despesa  = desp-item-fornec.val-despesa
                   desp-item-contrat.val-per-desp = desp-item-fornec.val-per-desp.            
                   
            /* Recalcula o valor da despesa pelo valor da cotacao */           
            run recalculaDespesa (input rowid(item-contrat),
                                  input rowid(desp-item-contrat),
                                  output de-valor-display).                                      
        end.       
    end.
    
    session:set-wait-state("":U).

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/*
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados DBOProgram 
PROCEDURE pi-cria-tt-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAM i-tipo-movto AS INT NO-UNDO.

  IF  NOT AVAIL param-global THEN
      FIND FIRST param-global NO-LOCK NO-ERROR.
  IF  param-global.modulo-mp AND
      tt-replica-msg.log-replica-msg = YES THEN DO:
      CREATE tt-dados-env.
      ASSIGN tt-dados-env.num-sequencia  = i-seq
             tt-dados-env.cod-tipo-reg   = 298
             tt-dados-env.ind-tipo-movto = i-tipo-movto
             tt-dados-env.identif-msg    = STRING(desp-item-contrat.nr-contrato)  + " , " +
                                           STRING(desp-item-contrat.num-seq-item) + " , " +
                                           STRING(desp-item-contrat.num-seq-desp) + " , " +
                                           STRING(desp-item-contrat.cod-despesa).
      RAW-TRANSFER desp-item-contrat TO tt-dados-env.conteudo-msg.
      ASSIGN i-seq = i-seq + 1.
  END.

END PROCEDURE.
*/


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verifica-despesa DBOProgram 
PROCEDURE verifica-despesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Esta procedure Ç chamada na inclus∆o ou modificaá∆o de uma despesa
               do contrato (cn0201n.w).
------------------------------------------------------------------------------*/

  DEF INPUT PARAM row-desp AS ROWID NO-UNDO.

  FIND desp-item-contrat WHERE rowid(desp-item-contrat) = row-desp NO-LOCK NO-ERROR.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/*
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-envia-multiplanta DBOProgram 
PROCEDURE pi-envia-multiplanta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAM p-movimento AS INT NO-UNDO.

  IF  NOT AVAIL param-global THEN
      FIND FIRST param-global NO-LOCK NO-ERROR.
  IF  param-global.modulo-mp THEN DO:
      ASSIGN c-transacao = "MAT060".
      {cdp/cd7300.i5 "001" c-transacao}
      ASSIGN i-tipo-movto = p-movimento.
      RUN pi-cria-tt-dados (INPUT i-tipo-movto).
      {cdp/cd7300.i6 "001" c-transacao}
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
*/

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
    
    if  not avail rowObject then
        return "NOK":U.
    
    if  pType = "create":U then do:
        /* Verifica duplicidade de registro */
        if  can-find(first desp-item-contrat 
                     where desp-item-contrat.nr-contrato  = rowObject.nr-contrato
                       and desp-item-contrat.num-seq-item = rowObject.num-seq-item
                       and desp-item-contrat.cod-despesa  = rowObject.cod-despesa
                       and desp-item-contrat.num-seq-desp = rowObject.num-seq-desp) 
            then do:
            
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgind desp-item-contrat 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i
                                &ErrorNumber="7" /* J† existe despesa com a chave informada */
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters=TRIM(RETURN-VALUE)}
        end.        
    end.
        
    find despesa where
         despesa.cod-despesa = rowObject.cod-despesa no-lock no-error.
    if  avail despesa then do:
        if  despesa.cdn-tp-calculo = 1 /* Percentual */
        then do:
            if  rowObject.val-per-desp = 0 then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-percentual AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Percentual" *}
                ASSIGN c-lbl-liter-percentual = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                    &ErrorNumber="822" /* Percentual deve ser informado */
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-liter-percentual" }
            end.
            /* Zera o Valor qdo a despesa for percentual */
            assign rowObject.val-despesa = 0.
        end.
        else if despesa.cdn-tp-calculo = 2 /* Valor */
        then do:
            if  rowObject.val-despesa = 0 then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-valor AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Valor" *}
                ASSIGN c-lbl-liter-valor = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                    &ErrorNumber="822" /* Valor deve ser informado */
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-liter-valor" }
            end.
            /* Zera o Percentual qdo tipo da despesa for valor */
            assign rowObject.val-per-desp = 0. 
        end.
    end.
    else do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-table.i mgdis despesa 1} /* Busca o label da tabela */
        {method/svc/errors/inserr.i
                            &ErrorNumber="2" /* Despesa n∆o cadastrada */
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters=TRIM(RETURN-VALUE)}
    end.

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-contrat DBOProgram 
FUNCTION fn-contrat RETURNS DECIMAL
  ( /* parameter-definitions */ ) :

  RETURN IF item-contrat.qtd-total > 0 THEN item-contrat.qtd-total
         ELSE 1.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
