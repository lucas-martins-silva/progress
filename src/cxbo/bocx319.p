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
{include/i-prgvrs.i BOCX319 2.00.00.005} /*** "010005" 27/11/2023 16:32:29  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX319 MUT}
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
&GLOBAL-DEFINE DBOVersion 2.00.00.004
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
{method/dboqry.i}

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var i-cod-pais-ini like pais.cod-pais  no-undo.
def var i-cod-pais-fim like pais.cod-pais  no-undo.
def var c-nome-pais    like pais.nome-pais no-undo.
DEF VAR i-cod-regime-ini LIKE pais-aliquota.regime-import NO-UNDO.
DEF VAR i-cod-regime-fim LIKE pais-aliquota.regime-import NO-UNDO.
DEF VAR c-classif-ini    AS CHAR  FORMAT '9999.99.99' NO-UNDO.
DEF VAR c-classif-fim    AS CHAR  FORMAT '9999.99.99'  NO-UNDO.

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
         HEIGHT             = 13.5
         WIDTH              = 41.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaRegimePadrao DBOProgram 
PROCEDURE buscaRegimePadrao :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor do campo regime de importacao
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    &if '{&bf_mat_versao_ems}' >= '2.062' &then
    define input  parameter i-cdn-pais-orig as integer   format ">>,>>9":U no-undo.
    define input  parameter c-class-fiscal  as character format "x(8)":U   no-undo.
    define output parameter i-regime-import as integer   format ">9":U     no-undo.

    for first bfPais-aliquota fields (regime-import)
        where bfPais-aliquota.cod-pais     = i-cdn-pais-orig 
        and   bfPais-aliquota.class-fiscal = c-class-fiscal  
        and   bfPais-aliquota.log-regim-import-padr no-lock: end.
    if  avail bfPais-aliquota then
        assign i-regime-import = bfPais-aliquota.regime-import.
    else 
        assign i-regime-import = 0.

    return "OK":U.
    &endif
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
        WHEN "class-fiscal":U THEN ASSIGN pFieldValue = RowObject.class-fiscal.
        &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
        WHEN "des-regim-import":U THEN ASSIGN pFieldValue = RowObject.des-regim-import.
        &endif

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
   OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.
   
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openqueryPais DBOProgram 
PROCEDURE openqueryPais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062'  &THEN
        OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
            WHERE {&TableName}.cod-pais >= i-cod-pais-ini
              AND {&TableName}.cod-pais <= i-cod-pais-fim 
              AND {&TableName}.regime-import >= i-cod-regime-ini
              AND {&TableName}.regime-import <= i-cod-regime-fim
              AND {&TableName}.class-fiscal  >= c-classif-ini
              AND {&TableName}.class-fiscal  <= c-classif-fim.
    &ELSE
        OPEN QUERY {&QueryName} FOR EACH {&TableName} 
            WHERE {&TableName}.cod-pais >= i-cod-pais-ini
              AND {&TableName}.cod-pais <= i-cod-pais-fim  NO-LOCK.
    
    &ENDIF

   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaNome-pais DBOProgram 
PROCEDURE setaNome-pais :
/*------------------------------------------------------------------------------
  Purpose:    setar o codigo do pais correspondente ao nome do pais no Magnus
  Parameters: recebe nome do pais
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-nome-pais like pais.nome-pais no-undo.
    
    assign c-nome-pais = p-nome-pais.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPais DBOProgram 
PROCEDURE setConstraintPais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es */
    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.062'  &THEN                                                         

        def input parameter p-cod-pais-ini   like pais.cod-pais               no-undo.
        def input parameter p-cod-pais-fim   like pais.cod-pais               no-undo.
        def input parameter p-cod-regime-ini like pais-aliquota.regime-import no-undo.
        def input parameter p-cod-regime-fim like pais-aliquota.regime-import no-undo.
        def input parameter p-classif-ini AS CHAR  FORMAT '9999.99.99'        no-undo.
        def input parameter p-classif-fim AS CHAR  FORMAT '9999.99.99'        no-undo.
        
        assign i-cod-pais-ini   = p-cod-pais-ini
               i-cod-pais-fim   = p-cod-pais-fim
               i-cod-regime-ini = p-cod-regime-ini
               i-cod-regime-fim = p-cod-regime-fim
               c-classif-ini    = p-classif-ini
               c-classif-fim    = p-classif-fim.
   &else
       def input parameter p-cod-pais-ini   like pais.cod-pais               no-undo.
       def input parameter p-cod-pais-fim   like pais.cod-pais               no-undo.

       assign i-cod-pais-ini   = p-cod-pais-ini
              i-cod-pais-fim   = p-cod-pais-fim.
   &endif

        

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRegimePadrao DBOProgram 
PROCEDURE updateRegimePadrao :
/*------------------------------------------------------------------------------
  Purpose:  MÇtodo chamado apenas para vers∆o superior a 2.062   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM  p-resp AS CHAR                     NO-UNDO.   
DEF INPUT PARAM  p-pais LIKE pais-aliquota.cod-pais NO-UNDO.   
DEF INPUT PARAM  p-classif AS CHAR                  NO-UNDO.
DEF INPUT PARAM  p-regime  AS LOGICAL               NO-UNDO.
DEF INPUT PARAM  p-cod-reg LIKE pais-aliquota.regime-import NO-UNDO.

    /** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
    &if '{&bf_mat_versao_ems}' >= '2.062' &then
    FIND bfpais-aliquota
        WHERE bfpais-aliquota.cod-pais      = p-pais
        AND   bfpais-aliquota.regime-import = p-cod-reg
        AND   bfpais-aliquota.class-fiscal  = STRING(p-classif,"99999999")
        EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL bfpais-aliquota THEN 
        ASSIGN bfpais-aliquota.log-regim-import-padr = NO.
    &endif

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateImportCex DBOProgram 
PROCEDURE validateImportCex :
/*------------------------------------------------------------------------------
  Purpose:  MÇtodo chamado apenas para vers∆o superior a 2.062   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/** 2.1.10 Geraá∆o de Impostos Padr‰es na Inclus∆o das Cotaá‰es **/
&if '{&bf_mat_versao_ems}' >= '2.062' &then
  
      DEF INPUT PARAM p-cod-pais    LIKE pais-aliquota.cod-pais              NO-UNDO.
      DEF INPUT PARAM p-class-fis   AS CHAR  FORMAT '9999.99.99'             NO-UNDO.
      DEF INPUT PARAM p-regime-imp  LIKE pais-aliquota.regime-import         NO-UNDO.
      DEF INPUT PARAM p-regime-padr LIKE pais-aliquota.log-regim-import-padr NO-UNDO.
      DEF OUTPUT PARAM p-cod-reg    LIKE pais-aliquota.regime-import         NO-UNDO.
    
      DEF BUFFER b-pais-aliquota FOR pais-aliquota.
    
      IF p-regime-padr THEN DO:
          FIND FIRST b-pais-aliquota
              WHERE b-pais-aliquota.cod-pais              = p-cod-pais
              AND   b-pais-aliquota.class-fiscal          = p-class-fis
              AND   b-pais-aliquota.regime-import         <> p-regime-imp
              AND   b-pais-aliquota.log-regim-import-padr = YES    NO-LOCK NO-ERROR.
          IF AVAIL b-pais-aliquota THEN DO:
              ASSIGN p-cod-reg = b-pais-aliquota.regime-import.
              RETURN "NOK":U. 
          END.
      END.
&endif

  RETURN "OK":U.

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
    
    if pType = "Create":u then do:
    
        if RowObject.cod-pais = 0 then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-codigo-do-pais AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "C¢digo_do_Pa°s" *}
            ASSIGN c-lbl-liter-codigo-do-pais = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
            &ErrorNumber="265"                 
            &ErrorType="EMS":U
            &ErrorSubType="Error":U
            &ErrorParameters="c-lbl-liter-codigo-do-pais"}
        end.
        else
          &if defined(bf-mat-comex) &then
            /* vari†vel c-nome-pais Ç setada atravÇs da procedure setaNome-pais */
            if not can-find(pais where pais.nome-pais = c-nome-pais) then do:
          &else
            if not can-find(pais where pais.cod-pais  = rowObject.cod-pais) then do:
          &endif
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-pais AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Pais" *}
                ASSIGN c-lbl-liter-pais = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                &ErrorNumber="2"
                &ErrorType="EMS":U
                &ErrorSubType="Error":U
                &ErrorParameters="c-lbl-liter-pais"}
            end.
        
        if RowObject.regime-import = 0 then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-regime-de-importacao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Regime_de_Importaá∆o" *}
            ASSIGN c-lbl-liter-regime-de-importacao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
            &ErrorNumber="265"
            &ErrorType="EMS":U
            &ErrorSubType="Error":U
            &ErrorParameters="c-lbl-liter-regime-de-importacao"}
        end.

        find classif-fisc 
            where classif-fisc.class-fiscal = RowObject.class-fiscal no-lock no-error.
        if not avail classif-fisc then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-classificacao-fiscal AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Classificaá∆o_Fiscal" *}
            ASSIGN c-lbl-liter-classificacao-fiscal = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
            &ErrorNumber="2"
            &ErrorType="EMS":U
            &ErrorSubType="Error":U
            &ErrorParameters="c-lbl-liter-classificacao-fiscal"}
        end.
        
        if can-find(pais-aliquota
                        where pais-aliquota.cod-pais      = RowObject.cod-pais
                          and pais-aliquota.regime-import = RowObject.regime-import
                          and pais-aliquota.class-fiscal  = RowObject.class-fiscal) then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-pais-aliquota-x-origem AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Pa°s_Al°quota_x_Origem" *}
            ASSIGN c-lbl-liter-pais-aliquota-x-origem = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
            &ErrorNumber="8"
            &ErrorType="EMS":U
            &ErrorSubType="Error":U
            &ErrorParameters="c-lbl-liter-pais-aliquota-x-origem"}
        end.
        
    end.

    &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
        IF RowObject.val-perc-reduc-impto-import > 100 THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-de-reducao-do-ii AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "de_reduá∆o_do_II" *}
            ASSIGN c-lbl-liter-de-reducao-do-ii = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
            &ErrorNumber="5638"
            &ErrorType="EMS":U
            &ErrorSubType="Error":U
            &ErrorParameters="c-lbl-liter-de-reducao-do-ii"}
        END.
    
        IF RowObject.cod-natur-operac-ipi <> "" THEN DO:
            FIND FIRST natur-oper
                WHERE natur-oper.nat-operacao = RowObject.cod-natur-operac-ipi NO-LOCK NO-ERROR.
            IF NOT AVAIL natur-oper THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-natureza-de-operacao AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Natureza_de_Operaá∆o" *}
                ASSIGN c-lbl-liter-natureza-de-operacao = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                &ErrorNumber="2"
                &ErrorType="EMS":U
                &ErrorSubType="Error":U
                &ErrorParameters="c-lbl-liter-natureza-de-operacao"}
            END.
        END.

        if pType = "Create":u OR 
           pType = "Update":U then do:

            IF RowObject.des-regim-import = "":U THEN DO:

                {utp/ut-liter.i "Descriá∆o_do_Regime_de_Importaá∆o" *}

                {method/svc/errors/inserr.i
                &ErrorNumber="265"
                &ErrorType="EMS":U
                &ErrorSubType="Error":U
                &ErrorParameters="return-value"}
            END.

        END.

    &endif
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

