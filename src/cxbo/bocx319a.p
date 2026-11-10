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
{include/i-prgvrs.i BOCX319A 2.00.00.002} /*** "010002" 27/11/2023 16:32:29  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX319A MUT}
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

{cdp/cdcfgmat.i} /* include preprocessadores */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX319
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName pais-aliquota
&GLOBAL-DEFINE TableLabel pais-aliquota
&GLOBAL-DEFINE QueryName qr{&TableName}
&GLOBAL-DEFINE NewRecordOffQuery yes


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/

{cxbo/bocx319.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
      
DEFINE QUERY {&QueryName} FOR {&TableName}, pais SCROLLING.      

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var c-nome-pais-ini like pais.nome-pais no-undo.
def var c-nome-pais-fim like pais.nome-pais no-undo.
def var c-nome-pais     like pais.nome-pais no-undo.


DEF VAR i-cod-regime-ini LIKE pais-aliquota.regime-import NO-UNDO.
DEF VAR i-cod-regime-fim LIKE pais-aliquota.regime-import NO-UNDO.
DEF VAR c-classif-ini    AS CHAR  FORMAT '9999.99.99'     NO-UNDO.
DEF VAR c-classif-fim    AS CHAR  FORMAT '9999.99.99'     NO-UNDO.

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
         HEIGHT             = 12.46
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
        WHEN "class-fiscal":U THEN ASSIGN pFieldValue = RowObject.class-fiscal.
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
        WHEN "aliquota-II":U THEN ASSIGN pFieldValue = RowObject.aliquota-II.
        WHEN "DEC-1":U THEN ASSIGN pFieldValue = RowObject.DEC-1.
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
        WHEN "cod-pais":U THEN ASSIGN pFieldValue = RowObject.cod-pais.
        WHEN "regime-import":U THEN ASSIGN pFieldValue = RowObject.regime-import.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ch-pais
  Parameters:  
               retorna valor do campo cod-pais
               retorna valor do campo regime-import
               retorna valor do campo class-fiscal
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-pais LIKE pais-aliquota.cod-pais NO-UNDO.
    DEFINE OUTPUT PARAMETER pregime-import LIKE pais-aliquota.regime-import NO-UNDO.
    DEFINE OUTPUT PARAMETER pclass-fiscal LIKE pais-aliquota.class-fiscal NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-pais = RowObject.cod-pais
           pregime-import = RowObject.regime-import
           pclass-fiscal = RowObject.class-fiscal.

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
  Purpose:     Reposiciona registro com base no °ndice ch-pais
  Parameters:  
               recebe valor do campo cod-pais
               recebe valor do campo regime-import
               recebe valor do campo class-fiscal
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-pais LIKE pais-aliquota.cod-pais NO-UNDO.
    DEFINE INPUT PARAMETER pregime-import LIKE pais-aliquota.regime-import NO-UNDO.
    DEFINE INPUT PARAMETER pclass-fiscal LIKE pais-aliquota.class-fiscal NO-UNDO.

    FIND FIRST bfpais-aliquota WHERE 
        bfpais-aliquota.cod-pais = pcod-pais AND 
        bfpais-aliquota.regime-import = pregime-import AND 
        bfpais-aliquota.class-fiscal = pclass-fiscal NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpais-aliquota THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpais-aliquota)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openqueryMain DBOProgram 
PROCEDURE openqueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK,
        EACH pais
            WHERE pais.cod-pais = {&TableName}.cod-pais NO-LOCK.
   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openqueryNome DBOProgram 
PROCEDURE openqueryNome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    &IF '{&BF_MAT_VERSAO_EMS}' < '2.062'  &THEN                                                         
        OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK,
            EACH pais 
            WHERE pais.cod-pais = {&TableName}.cod-pais 
              AND pais.nome-pais >= c-nome-pais-ini
              AND pais.nome-pais <= c-nome-pais-fim NO-LOCK. 
     &ELSE  /* 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es */    
          OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK,
              EACH pais NO-LOCK
              WHERE pais.cod-pais = {&TableName}.cod-pais 
                AND pais.nome-pais >= c-nome-pais-ini
                AND pais.nome-pais <= c-nome-pais-fim
                AND {&TableName}.regime-import   >= i-cod-regime-ini
                AND   {&TableName}.regime-import <= i-cod-regime-fim
                AND   {&TableName}.class-fiscal  >= c-classif-ini
                AND   {&TableName}.class-fiscal  <= c-classif-fim.

     &ENDIF
          
   
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

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNome DBOProgram 
PROCEDURE setConstraintNome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es */
    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062'  &THEN                                                         
        def input parameter p-nome-pais-ini like pais.nome-pais               no-undo.
        def input parameter p-nome-pais-fim like pais.nome-pais               no-undo.
        def input parameter p-cod-regime-ini like pais-aliquota.regime-import no-undo.
        def input parameter p-cod-regime-fim like pais-aliquota.regime-import no-undo.
        def input parameter p-classif-ini AS CHAR  FORMAT '9999.99.99'        no-undo.
        def input parameter p-classif-fim AS CHAR  FORMAT '9999.99.99'        no-undo.
        
        assign c-nome-pais-ini  = p-nome-pais-ini
               c-nome-pais-fim  = p-nome-pais-fim
               c-classif-ini    = p-classif-ini
               c-classif-fim    = p-classif-fim      
               i-cod-regime-ini = p-cod-regime-ini
               i-cod-regime-fim = p-cod-regime-fim.
    &else
        def input parameter p-nome-pais-ini like pais.nome-pais               no-undo.
        def input parameter p-nome-pais-fim like pais.nome-pais               no-undo.

        assign c-nome-pais-ini  = p-nome-pais-ini
               c-nome-pais-fim  = p-nome-pais-fim.
    
    &endif

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

