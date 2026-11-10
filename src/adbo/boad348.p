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
{include/i-prgvrs.i BOAD348 2.00.00.008} /*** "010008" 18/10/2023 12:27:11  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad348 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : boad348.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName              BOAD348
&GLOBAL-DEFINE DBOVersion           1.00.00.000    
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName            contr-docto-exp
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName            qr{&TableName} 


/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{adbo/boad348.i RowObject}


/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def buffer bfContrDocto for contr-docto-exp.

def var i-ep-codigo     like contr-titulo-exp.ep-codigo     no-undo.
def var c-cod-estabel   like contr-titulo-exp.cod-estabel   no-undo.
def var c-referencia    like contr-titulo-exp.referencia    no-undo.
def var d-dt-referencia like contr-titulo-exp.dt-referencia no-undo.
def var i-last-seq as integer no-undo.
def var l-executa  as logical init yes no-undo.

def temp-table tt-documentos like contr-docto-exp.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeCreateRecord DBOProgram 
PROCEDURE BeforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if l-executa = yes then do:
        find last bfContrDocto where bfContrDocto.ep-codigo     = RowObject.ep-codigo
                               and   bfContrDocto.cod-estabel   = RowObject.cod-estabel
                               and   bfContrDocto.referencia    = RowObject.referencia
                               and   bfContrDocto.dt-referencia = RowObject.dt-referencia                                
                               no-lock no-error.
         if avail bfContrDocto then
            assign RowObject.sequencia = bfContrDocto.sequencia + 10.
    end.

    find contrato-exp
         where contrato-exp.ep-codigo     = RowObject.ep-codigo
         and   contrato-exp.cod-estabel   = RowObject.cod-estabel
         and   contrato-exp.referencia    = RowObject.referencia
         and   contrato-exp.dt-referencia = RowObject.dt-referencia exclusive-lock no-error.
    if avail contrato-exp then
       assign RowObject.nr-contrato = contrato-exp.nr-contrato
              RowObject.dt-contrato = contrato-exp.dt-contrato.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        &IF "{&mguni_version}" >= "2.07A" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "c-time":U THEN ASSIGN pFieldValue = RowObject.c-time.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "desc-tp-documento":U THEN ASSIGN pFieldValue = RowObject.desc-tp-documento.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "documento":U THEN ASSIGN pFieldValue = RowObject.documento.
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "referencia":U THEN ASSIGN pFieldValue = RowObject.referencia.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dt-apresentacao":U THEN ASSIGN pFieldValue = RowObject.dt-apresentacao.
        WHEN "dt-contrato":U THEN ASSIGN pFieldValue = RowObject.dt-contrato.
        WHEN "dt-emissao":U THEN ASSIGN pFieldValue = RowObject.dt-emissao.
        WHEN "dt-referencia":U THEN ASSIGN pFieldValue = RowObject.dt-referencia.
        WHEN "dt-today":U THEN ASSIGN pFieldValue = RowObject.dt-today.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        &IF "{&mguni_version}" < "2.07A" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "ind-tipo-documento":U THEN ASSIGN pFieldValue = RowObject.ind-tipo-documento.
        WHEN "qtde-copia":U THEN ASSIGN pFieldValue = RowObject.qtde-copia.
        WHEN "qtde-original":U THEN ASSIGN pFieldValue = RowObject.qtde-original.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice referencia
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo referencia
               retorna valor do campo dt-referencia
               retorna valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE contr-docto-exp.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE contr-docto-exp.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER preferencia LIKE contr-docto-exp.referencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-referencia LIKE contr-docto-exp.dt-referencia NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE contr-docto-exp.sequencia NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-estabel = RowObject.cod-estabel
           preferencia = RowObject.referencia
           pdt-referencia = RowObject.dt-referencia
           psequencia = RowObject.sequencia.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
  Purpose:     Reposiciona registro com base no ¡ndice referencia
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo referencia
               recebe valor do campo dt-referencia
               recebe valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE contr-docto-exp.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE contr-docto-exp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER preferencia LIKE contr-docto-exp.referencia NO-UNDO.
    DEFINE INPUT PARAMETER pdt-referencia LIKE contr-docto-exp.dt-referencia NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE contr-docto-exp.sequencia NO-UNDO.

    FIND FIRST bfcontr-docto-exp WHERE 
        bfcontr-docto-exp.ep-codigo = pep-codigo AND 
        bfcontr-docto-exp.cod-estabel = pcod-estabel AND 
        bfcontr-docto-exp.referencia = preferencia AND 
        bfcontr-docto-exp.dt-referencia = pdt-referencia AND 
        bfcontr-docto-exp.sequencia = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcontr-docto-exp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcontr-docto-exp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LinkToContrato-Exp DBOProgram 
PROCEDURE LinkToContrato-Exp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter phandle as handle no-undo.
    
    run getkey in phandle (output i-ep-codigo,
                           output c-cod-estabel,
                           output c-referencia,
                           output d-dt-referencia).
                           
    run setConstraintContratoExp in this-procedure (input i-ep-codigo,
                                                    input c-cod-estabel,
                                                    input c-referencia,
                                                    input d-dt-referencia).
                                                    
    RETURN "OK":U.                                                    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryContratoExp DBOProgram 
PROCEDURE OpenQueryContratoExp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
        WHERE contr-docto-exp.ep-codigo     = i-ep-codigo and
              contr-docto-exp.cod-estabel   = c-cod-estabel  and 
              contr-docto-exp.referencia    = c-referencia and 
              contr-docto-exp.dt-referencia = d-dt-referencia.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryMain DBOProgram 
PROCEDURE OpenQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-autenticacao DBOProgram 
PROCEDURE pi-autenticacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-usuario like contr-docto-exp.usuario.

    {method/svc/autentic/autentic.i
            &vUserName="c-usuario"}

    assign RowObject.usuario  = c-usuario
           RowObject.c-time   = string(TIME, "HH:MM")
           RowObject.dt-today = today.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-docto DBOProgram 
PROCEDURE pi-cria-docto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter table for tt-documentos.

    assign l-executa = no.

    assign cQueryUseded = "Main".
    for each RowObject:
       delete RowObject.
    end.
    for each tt-documentos:
        create RowObject.
        assign RowObject.ep-codigo          = tt-documentos.ep-codigo
               RowObject.cod-estabel        = tt-documentos.cod-estabel
               RowObject.referencia         = tt-documentos.referencia
               RowObject.dt-referencia      = tt-documentos.dt-referencia
               RowObject.sequencia          = tt-documentos.sequencia
               RowObject.documento          = tt-documentos.documento
               RowObject.dt-emissao         = tt-documentos.dt-emissao
               RowObject.char-1             = tt-documentos.char-1
               RowObject.dt-apresentacao    = tt-documentos.dt-apresentacao
               RowObject.ind-tipo-documento = tt-documentos.ind-tipo-documento
               RowObject.qtde-original      = 1.
        run createRecord in this-procedure.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-docto-automatico DBOProgram 
PROCEDURE pi-cria-docto-automatico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF "{&mguni_version}" >= "2.07A" &THEN
    def input parameter p-ep-codigo      LIKE empresa.ep-codigo   no-undo.
&ELSE
    def input parameter p-ep-codigo      as integer   no-undo.
&ENDIF
    def input parameter p-cod-estabel    as character no-undo.
    def input parameter p-referencia     as character no-undo.
    def input parameter p-dt-referencia  as date      no-undo.
    def input parameter p-cod-emitente   as integer   no-undo.
    def input parameter p-cod-esp        as character no-undo.
    def input parameter p-serie          as character no-undo.
    def input parameter p-nr-docto       as character no-undo.
    def input parameter p-parcela        as character no-undo.

    if can-find (param-global where param-global.modulo-ex = yes) then do:
        run ecp/ec0003h.p (input p-ep-codigo,
                           input p-cod-estabel,
                           input p-referencia,
                           input p-dt-referencia,
                           input p-cod-emitente,
                           input p-cod-esp,
                           input p-serie,
                           input p-nr-docto,
                           input p-parcela).
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintContratoExp DBOProgram 
PROCEDURE SetConstraintContratoExp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo     LIKE contr-docto-exp.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel   LIKE contr-docto-exp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER preferencia    LIKE contr-docto-exp.referencia NO-UNDO.
    DEFINE INPUT PARAMETER pdt-referencia LIKE contr-docto-exp.dt-referencia NO-UNDO.
    
    assign i-ep-codigo     = pep-codigo
           c-cod-estabel   = pcod-estabel
           c-referencia    = preferencia
           d-dt-referencia = pdt-referencia.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintMain DBOProgram 
PROCEDURE SetConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡äes ---*/
    def var c-string1 as char no-undo.

    if ptype = "Create":U then do:
        if RowObject.ind-tipo-documento <> 12 then
            assign RowObject.desc-tp-documento = "".

        for each contr-docto-exp
           where contr-docto-exp.documento          = RowObject.documento
           and   contr-docto-exp.ind-tipo-documento = RowObject.ind-tipo-documento
           and   contr-docto-exp.desc-tp-documento  = RowObject.desc-tp-documento no-lock:
            if contr-docto-exp.ep-codigo     = RowObject.ep-codigo     and
               contr-docto-exp.cod-estabel   = RowObject.cod-estabel   and
               contr-docto-exp.referencia    = RowObject.referencia    and
               contr-docto-exp.dt-referencia = RowObject.dt-referencia then do:
                {utp/ut-liter.i Documento_Contrato_de_Cƒmbio_Exporta‡Æo *}
                assign c-string1 = return-value.

                {method/svc/errors/inserr.i
                            &ErrorNumber="7"
                            &ErrorType="EMS"
                            &ErrorParameters="c-string1"}
            end.           
        end.
    end.
    if ptype = "Create":U or ptype = "Update":U then do:
       if RowObject.documento = "" then
            {method/svc/errors/inserr.i
                        &ErrorNumber="26253"
                        &ErrorType="EMS"
                        &ErrorParameters="''"}

       if RowObject.qtde-original = 0 and RowObject.qtde-copia = 0 then
          {method/svc/errors/inserr.i
                      &ErrorNumber="19349"
                      &ErrorType="EMS"
                      &ErrorParameters="''"}  /*ORIGINAL OU COPIA DEVEM SER INFORMADOS*/

        if RowObject.dt-apresentacao < RowObject.dt-emissao then
            {method/svc/errors/inserr.i
                        &ErrorNumber="19348"
                        &ErrorType="EMS"
                        &ErrorParameters="''"}

       run pi-autenticacao.
    end.
   
    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


