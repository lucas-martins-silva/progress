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
{include/i-prgvrs.i BOIN656 2.00.00.011} /*** "010011" 01/12/2023 10:51:02  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin656 MUT}
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
&GLOBAL-DEFINE DBOName BOIN656
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName unid-neg-nota
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin656.i RowObject}
{utp/ut-glob.i}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def temp-table tt_unid_negoc no-undo
    field cod_unid_negoc   as char form "x(3)"  label "Unid Neg¢cio"         column-label "Un Neg"
    field des_unid_negoc   as char form "x(40)" label "Descriá∆o"            column-label "Descriá∆o"
    field cdn_unid_negoc   as Int  form ">>9"   label "N£mero Unidade Negoc" column-label "N£mero UN" initial 0.

def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

def buffer b-unid-neg-nota for unid-neg-nota.
def buffer b-docum-est     for docum-est.

def var i-sequencia        as int    no-undo.
def var i-cod-emitente     as int    no-undo.
def var c-nat-operacao     as char   no-undo.
def var c-nro-docto        as char   no-undo.
def var c-serie-docto      as char   no-undo.
def var c-desc-unid-negoc  as char   no-undo.
def var de-perc-unid-neg   as dec    no-undo.
def var h-cdapi024         as handle no-undo.

&if "{&mgadm_version}" >= "2.04" &then 
    /*--- Execuå„o OråamentÎria ---*/
    {cdp/cd1002.i}  /*--- funå„o execuå„o oråamentÎria ---*/
&ENDIF
{cdp/cdcfgmat.i}

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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod_unid_negoc":U THEN ASSIGN pFieldValue = RowObject.cod_unid_negoc.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
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
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "perc-unid-neg":U THEN ASSIGN pFieldValue = RowObject.perc-unid-neg.
        WHEN "qtd-unid-neg":U THEN ASSIGN pFieldValue = RowObject.qtd-unid-neg.
        WHEN "val-unid-neg[1]":U THEN ASSIGN pFieldValue = RowObject.val-unid-neg[1].
        WHEN "val-unid-neg[2]":U THEN ASSIGN pFieldValue = RowObject.val-unid-neg[2].
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescUnidNegoc DBOProgram 
PROCEDURE getDescUnidNegoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param piCodUnidNegoc   like unid-neg-nota.cod_unid_negoc  no-undo.
    def output param piDescUnidNegoc  as char                            no-undo.
    
    for each tt_unid_negoc:
        delete tt_unid_negoc.
    end.
 
    create tt_unid_negoc.
    assign tt_unid_negoc.cod_unid_negoc = piCodUnidNegoc.
 
    run prgint/utb/utb907za.py ( input 1,
                                 input-output table tt_unid_negoc ).
 
    find first tt_unid_negoc no-lock no-error.
 
    assign piDescUnidNegoc = if  avail tt_unid_negoc
                             then tt_unid_negoc.des_unid_negoc
                             else " ".
  
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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "tipo-nota":U THEN ASSIGN pFieldValue = RowObject.tipo-nota.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice nota
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo sequencia
               retorna valor do campo tipo-nota
               retorna valor do campo cod_unid_negoc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE unid-neg-nota.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE unid-neg-nota.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE unid-neg-nota.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE unid-neg-nota.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE unid-neg-nota.sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER ptipo-nota LIKE unid-neg-nota.tipo-nota NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod_unid_negoc LIKE unid-neg-nota.cod_unid_negoc NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           psequencia = RowObject.sequencia
           ptipo-nota = RowObject.tipo-nota
           pcod_unid_negoc = RowObject.cod_unid_negoc.

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
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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
  Purpose:     Reposiciona registro com base no °ndice nota
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo sequencia
               recebe valor do campo tipo-nota
               recebe valor do campo cod_unid_negoc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE unid-neg-nota.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE unid-neg-nota.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE unid-neg-nota.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE unid-neg-nota.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE unid-neg-nota.sequencia NO-UNDO.
    DEFINE INPUT PARAMETER ptipo-nota LIKE unid-neg-nota.tipo-nota NO-UNDO.
    DEFINE INPUT PARAMETER pcod_unid_negoc LIKE unid-neg-nota.cod_unid_negoc NO-UNDO.

    FIND FIRST bfunid-neg-nota WHERE 
        bfunid-neg-nota.serie-docto = pserie-docto AND 
        bfunid-neg-nota.nro-docto = pnro-docto AND 
        bfunid-neg-nota.cod-emitente = pcod-emitente AND 
        bfunid-neg-nota.nat-operacao = pnat-operacao AND 
        bfunid-neg-nota.sequencia = psequencia AND 
        bfunid-neg-nota.tipo-nota = ptipo-nota AND 
        bfunid-neg-nota.cod_unid_negoc = pcod_unid_negoc NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfunid-neg-nota THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfunid-neg-nota)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToItem-Doc-Est DBOProgram 
PROCEDURE linkToItem-Doc-Est :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pHandle as handle no-undo.

    run getKey in pHandle ( output i-cod-emitente,
                            output c-serie-docto,
                            output c-nro-docto,
                            output c-nat-operacao,
                            output i-sequencia).


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

  open query qr{&tableName} for each {&tableName} 
             no-lock 
             indexed-reposition.

return "OK":U.
  
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
       where {&tableName}.serie-docto  = c-serie-docto
         and {&tableName}.nro-docto    = c-nro-docto
         and {&tableName}.cod-emitente = i-cod-emitente
         and {&tableName}.nat-operacao = c-nat-operacao
         no-lock indexed-reposition.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfItemDocEst DBOProgram 
PROCEDURE openQueryOfItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  open query qr{&tableName} for each {&tableName}
       where {&tableName}.sequencia    = i-sequencia
         and {&tableName}.cod-emitente = i-cod-emitente
         and {&tableName}.nat-operacao = c-nat-operacao
         and {&tableName}.nro-docto    = c-nro-docto
         and {&tableName}.serie-docto  = c-serie-docto
         no-lock
         by {&tableName}.sequencia
         indexed-reposition.

return "OK":U.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintItem-Doc-Est DBOProgram 
PROCEDURE SetConstraintItem-Doc-Est :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param piCodEmitente as integer no-undo.
    def input param pcSerieDocto  as char    no-undo.
    def input param pcNrDocto     as char    no-undo.
    def input param pcNatOperacao as char    no-undo.
    def input param piSequencia   as integer no-undo.
    

    assign i-cod-emitente = piCodEmitente
           c-serie-docto  = pcSerieDocto
           c-nro-docto    = pcNrDocto
           c-nat-operacao = pcNatOperacao
           i-sequencia    = piSequencia.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfDocumEst DBOProgram 
PROCEDURE setConstraintOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCodEmitente as integer no-undo.
    def input param pcNatOperacao as char    no-undo.
    def input param pcSerieDocto  as char    no-undo.
    def input param pcNrDocto     as char    no-undo.

    assign i-cod-emitente = piCodEmitente
           c-serie-docto  = pcSerieDocto
           c-nro-docto    = pcNrDocto
           c-nat-operacao = pcNatOperacao.

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
    
    for first b-docum-est
        fields ( cod-emitente serie-docto nro-docto nat-operacao ce-atual
                 &if "{&bf_mat_versao_ems}" >= "2.062" &then
                     b-docum-est.cod-estabel b-docum-est.dt-trans
                 &endif )
        where b-docum-est.cod-emitente = RowObject.cod-emitente
          and b-docum-est.serie-docto  = RowObject.serie-docto
          and b-docum-est.nro-docto    = RowObject.nro-docto
          and b-docum-est.nat-operacao = RowObject.nat-operacao no-lock: end.

    if  avail b-docum-est
    and b-docum-est.ce-atual then do:
        {method/svc/errors/inserr.i
                    &ErrorNumber="19515" /*Nota fiscal j† atualizada*/
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" }
    end.
    
    if  pType <> "DELETE":U then do:
    
        if  pType = "CREATE" then do:
     
            find first unid-neg-nota 
                where unid-neg-nota.cod_unid_negoc = RowObject.cod_unid_negoc 
                  and unid-neg-nota.cod-emitente   = RowObject.cod-emitente 
                  and unid-neg-nota.nro-docto      = RowObject.nro-docto 
                  and unid-neg-nota.serie-docto    = RowObject.serie-docto 
                  and unid-neg-nota.nat-operacao   = RowObject.nat-operacao 
                  and unid-neg-nota.sequencia      = RowObject.sequencia no-lock no-error.

            if  avail unid-neg-nota then do:
                {utp/ut-table.i movind unid-neg-nota 1}
            
                {method/svc/errors/inserr.i
                                    &ErrorNumber="7"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters=return-value}
            end.     
    
            &if "{&bf_mat_versao_ems}" < "2.062" &then
                run getDescUnidNegoc (RowObject.cod_unid_negoc,
                                      output c-desc-unid-negoc).
            
                if c-desc-unid-negoc = " " then do:
                    {utp/ut-field.i movind unid-neg-nota cod_unid_negoc 1}
                
                    {method/svc/errors/inserr.i &ErrorNumber="56"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR" 
                                                &ErrorParameters=return-value}
                end.
            &else
                find unid-negoc no-lock where
                     unid-negoc.cod-unid-negoc = RowObject.cod_unid_negoc no-error.
                if not avail unid-negoc then do:
                    {utp/ut-field.i movind unid-neg-nota cod_unid_negoc 1}

                    {method/svc/errors/inserr.i &ErrorNumber="56"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR" 
                                                &ErrorParameters=return-value}
                end.

                if not valid-handle(h-cdapi024)   or
                   h-cdapi024:type <> "PROCEDURE" or
                   h-cdapi024:file-name <> "cdp/cdapi024.p" then do:
                    run cdp/cdapi024.p persistent set h-cdapi024.
                end.

                if valid-handle(h-cdapi024) then do:
                    
                    empty temp-table tt-erro.

                    /*Valida se a UN pode ser utilizada pelo Estabelecimento da Notal Fiscal*/
                    run ValidaUnidadeNegocioEstabel in h-cdapi024 (input b-docum-est.cod-estabel,
                                                                   input b-docum-est.dt-trans,
                                                                   input RowObject.cod_unid_negoc,
                                                                   output table tt-erro append).

                    /*Valida ser a UN pode ser utilizada pelo Usu†rio da Nota Fiscal*/
                    run ValidaUnidadeNegocioUsuario in h-cdapi024 (input c-seg-usuario,
                                                                   input RowObject.cod_unid_negoc,
                                                                   output table tt-erro append).

                    /*Cria os erros na BO*/
                    for each tt-erro:
                        run _insertErrorManual in this-procedure (input tt-erro.cd-erro,  /* pErrorNumber      */
                                                                  input "EMS",            /* pErrorType        */
                                                                  input "Error",          /* pErrorSubType     */
                                                                  input tt-erro.mensagem, /* pErrorDescription */
                                                                  input "",               /* pErrorHelp        */
                                                                  input "").              /* pErrorParameters  */
                    end.
                end.
                
                if valid-handle(h-cdapi024) then do:
                    RUN pi-finalizar IN h-cdapi024.
                    assign h-cdapi024 = ?.
                end.

            &endif
        end.
        
        if  RowObject.perc-unid-neg <= 0
        or  RowObject.perc-unid-neg > 100 then do:
            {utp/ut-field.i movind unid-neg-nota perc-unid-neg 1}
    
            {method/svc/errors/inserr.i
                                &ErrorNumber="5376"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters=return-value}
        end.
           
        assign de-perc-unid-neg = 0.
        
        for each b-unid-neg-nota 
            where b-unid-neg-nota.cod_unid_negoc <> RowObject.cod_unid_negoc
              and b-unid-neg-nota.cod-emitente    = RowObject.cod-emitente 
              and b-unid-neg-nota.nro-docto       = RowObject.nro-docto 
              and b-unid-neg-nota.serie-docto     = RowObject.serie-docto 
              and b-unid-neg-nota.nat-operacao    = RowObject.nat-operacao 
              and b-unid-neg-nota.sequencia       = RowObject.sequencia no-lock:

            assign de-perc-unid-neg = de-perc-unid-neg + b-unid-neg-nota.perc-unid-neg.

        end.    
        
        assign de-perc-unid-neg = de-perc-unid-neg + RowObject.perc-unid-neg.
        
        if  de-perc-unid-neg > 100 then do:
            {method/svc/errors/inserr.i
                                &ErrorNumber="2208"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"}
        end.  

    end.    

        
    if pType = "DELETE":U  OR pType = "CREATE" OR  pType = "UPDATE" then do:

            /* Se tiver execucao orcamentaria, nao pode alterar a Unid Neg. Tudo deve ser feito direto na ordem de compra.
               Tivemos que fazer isso, pois a rotina na estornava o empenho corretamente */
            IF l-execucao-orcamentaria THEN DO:
               find first item-doc-est
                    where item-doc-est.cod-emitente = RowObject.cod-emitente
                      and item-doc-est.serie-docto  = RowObject.serie-docto
                      and item-doc-est.nro-docto    = RowObject.nro-docto
                      and item-doc-est.nat-operacao = RowObject.nat-operacao
                      and item-doc-est.sequencia    = RowObject.sequencia no-lock no-error.

               IF AVAIL item-doc-est THEN DO:

                  IF (item-doc-est.numero-ordem <> 0) OR /*ordem informada no item*/
                     (CAN-FIND (FIRST rat-ordem WHERE  /* ordem informada atraves funcao fifo*/
                                      rat-ordem.serie-docto   = item-doc-est.serie-docto  AND
                                      rat-ordem.nro-docto     = item-doc-est.nro-docto    AND
                                      rat-ordem.cod-emitente  = item-doc-est.cod-emitente AND
                                      rat-ordem.nat-operacao  = item-doc-est.nat-operacao AND
                                      rat-ordem.sequencia     = item-doc-est.sequencia    AND
                                      rat-ordem.numero-ordem  <> 0 )) THEN DO:
                     {method/svc/errors/inserr.i
                                 &ErrorNumber="51354" /**/
                                 &ErrorType="EMS"
                                 &ErrorSubType="Error"}
                  END.

               END.
            END.  
    end.
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

