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
{include/i-prgvrs.i BOAD343 2.00.00.007} /*** "010007" 18/10/2023 12:27:10  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad343 MUT}
&ENDIF

/*--------------------------------------------------------------------------
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

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName            BOAD343
&GLOBAL-DEFINE DBOVersion         1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName          contr-docto-imp
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName          qr{&TableName} 


/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{adbo/boad343.i RowObject}


/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}

def temp-table tt-doctos-mec
    field empresa            like contr-docto-imp.ep-codigo
    field estabelecimento    like contr-docto-imp.cod-estabel
    field refer              like contr-docto-imp.referenc
    field dt-refer           like contr-docto-imp.dt-referencia
    field nr-documento       like contr-docto-imp.documento
    field emissao            like contr-docto-imp.dt-emissao
    field apresentacao       like contr-docto-imp.dt-apresentacao
    field tipo               like contr-docto-imp.ind-tipo-documento.

/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var i-ep-codigo     like contr-titulo-imp.ep-codigo     no-undo.
def var c-cod-estabel   like contr-titulo-imp.cod-estabel   no-undo.
def var c-referencia    like contr-titulo-imp.referencia    no-undo.
def var d-dt-referencia like contr-titulo-imp.dt-referencia no-undo.

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
         HEIGHT             = 1.83
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforecreateRecord DBOProgram 
PROCEDURE beforecreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  find last contr-docto-imp where contr-docto-imp.ep-codigo     = RowObject.ep-codigo
                              and contr-docto-imp.cod-estabel   = RowObject.cod-estabel
                              and contr-docto-imp.referencia    = RowObject.referencia
                              and contr-docto-imp.dt-referencia = RowObject.dt-referencia no-lock no-error.
  if avail contr-docto-imp then do:
     assign RowObject.sequencia = contr-docto-imp.sequencia + 10.
  end.
  else assign RowObject.sequencia = 10.

  find contrato-imp
       where contrato-imp.ep-codigo     = RowObject.ep-codigo
       and   contrato-imp.cod-estabel   = RowObject.cod-estabel
       and   contrato-imp.referencia    = RowObject.referencia
       and   contrato-imp.dt-referencia = RowObject.dt-referencia exclusive-lock no-error.
  if avail contrato-imp then
     assign RowObject.nr-contrato = contrato-imp.nr-contrato.

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
    DEFINE OUTPUT PARAMETER pep-codigo LIKE contr-docto-imp.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE contr-docto-imp.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER preferencia LIKE contr-docto-imp.referencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-referencia LIKE contr-docto-imp.dt-referencia NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE contr-docto-imp.sequencia NO-UNDO.

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
    DEFINE INPUT PARAMETER pep-codigo LIKE contr-docto-imp.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE contr-docto-imp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER preferencia LIKE contr-docto-imp.referencia NO-UNDO.
    DEFINE INPUT PARAMETER pdt-referencia LIKE contr-docto-imp.dt-referencia NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE contr-docto-imp.sequencia NO-UNDO.

    FIND FIRST bfcontr-docto-imp WHERE 
        bfcontr-docto-imp.ep-codigo = pep-codigo AND 
        bfcontr-docto-imp.cod-estabel = pcod-estabel AND 
        bfcontr-docto-imp.referencia = preferencia AND 
        bfcontr-docto-imp.dt-referencia = pdt-referencia AND 
        bfcontr-docto-imp.sequencia = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcontr-docto-imp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcontr-docto-imp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToContrato-imp DBOProgram 
PROCEDURE linkToContrato-imp :
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
                           
    run setConstraintContratoImp in this-procedure (input i-ep-codigo,
                                                    input c-cod-estabel,
                                                    input c-referencia,
                                                    input d-dt-referencia).
                                                    
    RETURN "OK":U.                                                    


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryContratoImp DBOProgram 
PROCEDURE openQueryContratoImp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
        WHERE contr-docto-imp.ep-codigo     = i-ep-codigo and
              contr-docto-imp.cod-estabel   = c-cod-estabel  and 
              contr-docto-imp.referencia    = c-referencia and 
              contr-docto-imp.dt-referencia = d-dt-referencia.
        
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
    def var c-usuario like contr-docto-imp.usuario.

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
    def input parameter table for tt-doctos-mec.

    def var h-boad341 as handle  no-undo.
    def var i-seq     as integer no-undo.
    
    assign i-seq  = 0.

    find last contr-docto-imp no-lock
        where contr-docto-imp.ep-codigo     = tt-doctos-mec.empresa
        and   contr-docto-imp.cod-estabel   = tt-doctos-mec.estabelecimento
        and   contr-docto-imp.referencia    = tt-doctos-mec.refer
        and   contr-docto-imp.dt-referencia = tt-doctos-mec.dt-refer no-error.
    if avail contr-docto-imp then
        assign i-seq = contr-docto-imp.sequencia.

    assign cQueryUseded = "Main".

    run EmptyRowObject in this-procedure.
    run emptyRowErrors in this-procedure.
    
    for each tt-doctos-mec:
        assign i-seq  = i-seq + 10.

        create RowObject.
        assign RowObject.ep-codigo          = tt-doctos-mec.empresa
               RowObject.cod-estabel        = tt-doctos-mec.estabelecimento
               RowObject.referencia         = tt-doctos-mec.refer
               RowObject.dt-referencia      = tt-doctos-mec.dt-refer
               RowObject.documento          = tt-doctos-mec.nr-documento
               RowObject.dt-emissao         = tt-doctos-mec.emissao
               RowObject.dt-apresentacao    = tt-doctos-mec.apresentacao
               RowObject.ind-tipo-documento = tt-doctos-mec.tipo
               RowObject.sequencia          = i-seq
               RowObject.qtde-original      = 1.
        run createRecord in this-procedure.
        if return-value = "NOK":U then
            return "NOK":U.
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
/*** Include c/ defini‡Æo dos parƒmetros ***/
{ecp/ec0001j.i}

   if can-find (param-global where param-global.modulo-07 = yes) then do:
      run ecp/ec0001i.p (input p-ep-codigo,
                         input p-cod-estabel,
                         input p-referencia,
                         input p-dt-referencia,
                         input p-cod-emitente,
                         input p-cod-esp,
                         input p-serie,
                         input p-nr-docto,
                         input p-parcela).
   end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintContratoImp DBOProgram 
PROCEDURE setConstraintContratoImp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo     LIKE contr-docto-imp.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel   LIKE contr-docto-imp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER preferencia    LIKE contr-docto-imp.referencia NO-UNDO.
    DEFINE INPUT PARAMETER pdt-referencia LIKE contr-docto-imp.dt-referencia NO-UNDO.
    
    assign i-ep-codigo     = pep-codigo
           c-cod-estabel   = pcod-estabel
           c-referencia    = preferencia
           d-dt-referencia = pdt-referencia.
    
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
       find contrato-imp where contrato-imp.ep-codigo     = RowObject.ep-codigo
                           and contrato-imp.cod-estabel   = RowObject.cod-estabel
                           and contrato-imp.referencia    = RowObject.referencia
                           and contrato-imp.dt-referencia = RowObject.dt-referencia no-lock no-error.
       {utp/ut-liter.i documento *}
       assign c-string1 = return-value.

       if not avail contrato-imp then
          {method/svc/errors/inserr.i
                    &ErrorNumber="19421"
                    &ErrorType="EMS"
                    &ErrorParameters="c-string1"}

       if RowObject.documento = "" then
          {method/svc/errors/inserr.i
                      &ErrorNumber="19338"
                      &ErrorType="EMS"
                      &ErrorParameters="''"}  /*DOCUMENTO DEVE SER INFORMADO*/
       
       if RowObject.dt-emissao = ? then
          {method/svc/errors/inserr.i
                      &ErrorNumber="19339"
                      &ErrorType="EMS"
                      &ErrorParameters="''"}  /* DT EMISSAO DEVE SER INFORMADA */

        for each contr-docto-imp
           where contr-docto-imp.documento          = RowObject.documento
           and   contr-docto-imp.ind-tipo-documento = RowObject.ind-tipo-documento
           and   contr-docto-imp.desc-tp-documento  = RowObject.desc-tp-documento no-lock:
            if  contr-docto-imp.ep-codigo     = RowObject.ep-codigo
            and contr-docto-imp.cod-estabel   = RowObject.cod-estabel
            and contr-docto-imp.referencia    = RowObject.referencia
            and contr-docto-imp.dt-referencia = RowObject.dt-referencia then do:
                {utp/ut-liter.i Documento_Contrato_de_Cƒmbio_Importa‡Æo *}
                assign c-string1 = return-value.

                {method/svc/errors/inserr.i
                            &ErrorNumber="7"
                            &ErrorType="EMS"
                            &ErrorParameters="c-string1"}
            end.           
        end.

    end.

    if ptype = "Create":U or 
       ptype = "Update":U then do:

       run pi-autenticacao.

       if RowObject.dt-apresentacao < RowObject.dt-emissao then
          {method/svc/errors/inserr.i
                      &ErrorNumber="19348"
                      &ErrorType="EMS"
                      &ErrorParameters="''"}  /* Dt apresent‡Æo menor que dt contrato */

       if RowObject.qtde-original = 0 and RowObject.qtde-copia = 0 then
          {method/svc/errors/inserr.i
                      &ErrorNumber="19349"
                      &ErrorType="EMS"
                      &ErrorParameters="''"}  /*ORIGINAL OU COPIA DEVEM SER INFORMADOS*/
    end.
    
    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


