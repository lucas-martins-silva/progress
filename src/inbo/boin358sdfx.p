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
{include/i-prgvrs.i BOIN358SDFX 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin358sdfx MUT}
&ENDIF

/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN358
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName proc-compra
&GLOBAL-DEFINE TableLabel Pacotes de Compra
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin358.i RowObject}
{inbo/boin358.i RowObjectDefault}

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


{utp/ut-glob.i} /* Vari veis Globais  */

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
         HEIGHT             = 8.75
         WIDTH              = 36.86.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields DBOProgram 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Habilitar os campos de interface segundo a regra de neg¢cio.
  Parameters:  pType: Tipo de Transa‡Æo ("Create", "Update" ou "Delete") 
               pFieldName: Atributo da tabela.
               pFieldEnable: Habilita ou nÆo o atributo.
  Notes:       
------------------------------------------------------------------------------*/

    def input  param pType        as char               no-undo.
    def input  param pFieldName   as char               no-undo.
    def output param pFieldEnable as log    init yes    no-undo.
        
    case pFieldName:
        when "nr-processo" then
            assign pFieldEnable = pType = "create".

    end case.

    return "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice codigo
  Parameters:  
               recebe valor do campo nr-processo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-processo LIKE proc-compra.nr-processo NO-UNDO.

    FIND FIRST bfproc-compra WHERE 
        bfproc-compra.nr-processo = pnr-processo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproc-compra THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproc-compra)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setBuyer DBOProgram 
PROCEDURE setBuyer :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir comprador respons vel pelo pacote de compra
  Parameters:  pCodComprado: retorna o usu rio logado como comprador respons vel
                             pelo pacote de compra
  Notes:       
------------------------------------------------------------------------------*/

    def output param pCodComprado like proc-compra.cod-comprado no-undo.

    assign pCodComprado = c-seg-usuario.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaults DBOProgram 
PROCEDURE setDefaults :
/*------------------------------------------------------------------------------
  Purpose:     Executar o leave dos campos para sugestÆo de valores default.
  Parameters:  pType: Tipo de Transa‡Æo ("Create", "Update" ou "Delete")
               pFieldName: Atributo da tabela
               RowObject: temp-table com os dados da tela
               RowObjectDefault: temp-table com os dados default
  Notes:       O m‚todo SetDefaults deve ser executado apenas quando tratar-se
               de uma inclusÆo ou da modifica‡Æo de algum campo.
------------------------------------------------------------------------------*/

    def input  param pType        as char no-undo.
    def input  param pFieldName   as char no-undo.
    def input  param table for RowObject.
    def output param table for RowObjectDefault.

    empty temp-table RowObjectDefault.

    find first RowObject       no-error.

    /* Defaults na inicializa‡Æo da tela */
    if  pType      = "create"
    and pFieldName = "" then do:

        create RowObjectDefault.
        
        run setPackageNumber    (output RowObjectDefault.nr-processo).
        run setBuyer            (output RowObjectDefault.cod-comprado).
        run setStartDate        (output RowObjectDefault.dt-inicio).
        
    end.
    /* Defaults de leave de campos (cria‡Æo e modifica‡Æo) */
    else do:
    
        if  avail RowObject then do:
            create RowObjectDefault.
            buffer-copy RowObject to RowObjectDefault.
        end.
    end.

    /* Regras de neg¢cio para sugestÆo de valores defaults decorrente do Leave do campo */
    /*case pFieldName:
        when "<nome_do_campo>"    then run leave<nome_do_campo>  (output table RowObjectDefault).       
    end case.*/

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setPackageNumber DBOProgram 
PROCEDURE setPackageNumber :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir o pr¢ximo n£mero do pacote de compra
  Parameters:  pNrProcesso: pr¢ximo n£mero do pacote de compra
  Notes:       
------------------------------------------------------------------------------*/

    def output param pNrProcesso       like proc-compra.nr-processo no-undo.

    find last proc-compra no-lock no-error.
    if  avail proc-compra then
        assign pNrProcesso = proc-compra.nr-processo + 1.
    else
        assign pNrProcesso = 1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setStartDate DBOProgram 
PROCEDURE setStartDate :
/*------------------------------------------------------------------------------
  Purpose:     Retornar a data de cria‡Æo do pacote
  Parameters:  pDtInicio: retornar como data de in¡cio do pacote como TODAY
  Notes:       
------------------------------------------------------------------------------*/

    def output param pDtInicio like proc-compra.dt-inicio no-undo.
               
    assign pDtInicio = today.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

