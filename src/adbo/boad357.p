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
{include/i-prgvrs.i BOAD357 2.00.00.047 } /*** "010047" 20/10/2023 10:44:29  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boad357 MUT}
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

/**** Miniflexibilizacao ****/
{cdp/cdcfgfin.i}
{include/i_dbvers.i}

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName              BOAD357
&GLOBAL-DEFINE DBOVersion           2.00.00.045
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName            param-mec
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName            qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{adbo/boad357.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

/************************************** Definiá∆o de Vari†veis **************************************/

define variable h-boad049                   as handle               no-undo.
define variable h-boad355                   as handle               no-undo.
define variable p-ct-codigo                 as character            no-undo.
define variable p-sc-codigo                 as character            no-undo.
define variable v-pagar                     as character            no-undo. /* "EMS 2" ; "EMS 5" */
define variable v-receber                   as character            no-undo. /* "EMS 2" ; "EMS 5" */
define variable v-funcao-pre-pagto          as logical              no-undo.
define variable l-funcao-cta-cancel         as logical              no-undo.
define variable l-funcao-pgto-juros-sdesemb as logical              no-undo.
define variable l-funcao-recta-cambio-fut   as logical   initial no no-undo.
define variable l-funcao-devolucao          as logical   initial no no-undo.

define variable h-api-ccusto                as handle               no-undo. /* API CCusto EMS5             - utb742za */
define variable h-api-conta                 as handle               no-undo. /* API Conta EMS5              - utb743za */
define variable h-bo-unid-negoc             as handle               no-undo. /* DBO Unidade de Neg¢cio EMS5 - utb936wa */

define variable l-utiliza-ccusto            as logical   initial no no-undo. /* Verifica se a Conta Utiliza ou n∆o CCusto*/
/****************************************************************************************************/

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
define buffer bf{&TableName} for {&TableName}.

/*************************************** Definiá∆o Temp-Table ***************************************/

/* Cria um registro na tabela */
define temp-table tt-cria-{&TableName} like {&TableName}.

/* Erros */
define temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer   format ">>>>,>>9" label "N£mero"         column-label "N£mero"
    field ttv_des_msg_ajuda as character format "x(40)"    label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)"    label "Mensagem Erro"  column-label "Inconsistància"
    .

/****************************************************************************************************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetEntryField DBOProgram 
FUNCTION GetEntryField returns character
                  (input p_num_posicao    as integer,
                   input p_cod_campo      as character,
                   input p_cod_separador  as character) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD SetEntryField DBOProgram 
FUNCTION SetEntryField returns character
                  (input p_num_posicao     as integer,
                   input p_cod_campo       as character,
                   input p_cod_separador   as character,
                   input p_cod_valor       as character) FORWARD.

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
/*----include verifica funá∆o pre-pagto----*/
{ecp/ec0003.i}
/* include verifica funá∆o juros liq Ace */
{ecp/ec0003.i2}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */
{include/getdefinedfunction.i}

/* Verificar se funá∆o especial est† habilitada */
assign l-funcao-cta-cancel         = &IF DEFINED(BF_FIN_CONTA_CANCEL)           &THEN YES &ELSE GetDefinedFunction("SPP-CTA-CANCEL")            &ENDIF.
assign l-funcao-pgto-juros-sdesemb = &IF DEFINED(BF_FIN_PAGTO_JUROS_SEM_DESEMB) &THEN YES &ELSE GetDefinedFunction("SPP-PGTO-JUROS-SEM-DESEMB") &ENDIF.
assign l-funcao-devolucao          = &if defined(BF_FIN_DEVOL_BANCO)            &THEN YES &ELSE GetDefinedFunction("SPP-DEVOL-BANCO")           &ENDIF.

/* Esta vari†vel verificar† se a funá∆o Destinaá∆o est† habilitada para que possa ser utilizada a funá∆o de Cambio Futuro */
ASSIGN l-funcao-recta-cambio-fut   = &IF DEFINED(BF_FIN_DESTINACAO)             &THEN YES &ELSE GetDefinedFunction("SPP-DESTINACAO")            &ENDIF.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeSaveRecord DBOProgram 
PROCEDURE BeforeSaveRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Proj. 82 - Unificaá∆o de Conceitos
     * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN

        if RowObject.conta-baixa-ace <> "" then do:
            
            run adbo/boad049o.p persistent set h-boad049.
            run pi-busca-conta-contab in h-boad049 (input  RowObject.conta-baixa-ace,
                                                    output p-ct-codigo,
                                                    output p-sc-codigo).
            if valid-handle(h-boad049) then
                delete procedure h-boad049.
    
            assign RowObject.ct-codigo-baixa-ace = p-ct-codigo
                   RowObject.sc-codigo-baixa-ace = p-sc-codigo.

        end.
    &ENDIF
    
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
    
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        &IF "{&mguni_version}" >= "2.07A" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "cod-esp-antec-ap":U    THEN ASSIGN pFieldValue = RowObject.cod-esp-antec-ap.
        WHEN "cod-esp-antec-cr":U    THEN ASSIGN pFieldValue = RowObject.cod-esp-antec-cr.
        WHEN "conta-baixa-ace":U     THEN ASSIGN pFieldValue = RowObject.conta-baixa-ace.
        WHEN "ct-codigo-baixa-ace":U THEN ASSIGN pFieldValue = RowObject.ct-codigo-baixa-ace.
        WHEN "sc-codigo-baixa-ace":U THEN ASSIGN pFieldValue = RowObject.sc-codigo-baixa-ace.
        WHEN "serie-antec-ap":U      THEN ASSIGN pFieldValue = RowObject.serie-antec-ap.
        WHEN "serie-antec-cr":U      THEN ASSIGN pFieldValue = RowObject.serie-antec-cr.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE      NO-UNDO.

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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL   NO-UNDO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetDescFK DBOProgram 
PROCEDURE GetDescFK :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     
     def input  param c-table       as char no-undo.
     def input  param c-param       as char no-undo.
     def output param c-description as char no-undo.

     def var i-ep-codigo like param-mec.ep-codigo no-undo.
     run pi-autenticacao (output i-ep-codigo).

     case c-table:
        when "espec-ap":U then do:
            find first espec-ap where espec-ap.cod-esp = c-param no-lock no-error.
            if avail espec-ap then
                assign c-description = espec-ap.descricao.
            else
                assign c-description = " ".
        end.        
        when "esp-doc":U then do:
            find first esp-doc where esp-doc.cod-esp = c-param no-lock no-error.
            if avail esp-doc then
                assign c-description = esp-doc.descricao.
            else
                assign c-description = " ".
        end.
        when "receita":U then do:
            find first tipo-rec-desp where tipo-rec-desp.tp-codigo = int(c-param) no-lock no-error.
            if avail tipo-rec-desp then
                assign c-description = tipo-rec-desp.descricao.
            else
                assign c-description = " ".
        end.
        
        /* Proj. 82 - Unificaá∆o de Conceitos
         * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
        &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
            when "conta-contab":U then do:
                find conta-contab where conta-contab.ep-codigo      = i-ep-codigo and
                                        conta-contab.conta-contabil = c-param no-lock no-error.
                if avail conta-contab then
                    assign c-description = conta-contab.titulo.
                else
                    assign c-description = " ".
            end.
        &ENDIF
    end case.   
    return "OK":U.
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
    
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER   NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        &IF "{&mguni_version}" < "2.07A" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "tp-codigo-antec-ap":U THEN ASSIGN pFieldValue = RowObject.tp-codigo-antec-ap.
        WHEN "tp-codigo-antec-cr":U THEN ASSIGN pFieldValue = RowObject.tp-codigo-antec-cr.
        OTHERWISE DO:
            &IF DEFINED(BF_FIN_MEC_FUT_CFL2) &THEN
                IF l-funcao-recta-cambio-fut = YES AND pFieldName = "idi-tip-recta-cambio-fut":U THEN DO:
                    ASSIGN pFieldValue = RowObject.idi-tip-recta-cambio-fut.
                END.
                ELSE DO: 
                    RETURN "NOK":U.
                END.
            &ELSE
                RETURN "NOK":U.
            &ENDIF
        END.
    END CASE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo ep-codigo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE OUTPUT PARAMETER pep-codigo LIKE param-mec.ep-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo.

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
    
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL   NO-UNDO.

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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW       NO-UNDO.

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
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo ep-codigo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pep-codigo LIKE param-mec.ep-codigo NO-UNDO.

    find FIRST bfparam-mec WHERE 
        bfparam-mec.ep-codigo = pep-codigo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfparam-mec THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfparam-mec)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
    
    def output param i-ep-codigo like param-mec.ep-codigo no-undo.

    {method/svc/autentic/autentic.i
            &vUserEnterprise="i-ep-codigo"}

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-conta-ajuste DBOProgram 
PROCEDURE pi-busca-conta-ajuste :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Proj. 82 - Unificaá∆o de Conceitos
     * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
    
        def output param p-cod-cta-ctbl-ajust like {&TableName}.cod-cta-ctbl-ajust no-undo.
        def output param p-cod-ccusto-ajust   like {&TableName}.cod-ccusto-ajust   no-undo.
    
    &ELSE
    
        def output param p-cta-ajuste as char no-undo.

    &ENDIF

    def var i-ep-codigo like {&TableName}.ep-codigo no-undo.

    run pi-autenticacao (output i-ep-codigo).

    assign &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
               p-cod-cta-ctbl-ajust = ""
               p-cod-ccusto-ajust   = ""
           &ELSE
               p-cta-ajuste         = ""
           &ENDIF
           .

    find first {&TableName} where
               {&TableName}.ep-codigo = i-ep-codigo
               no-lock no-error.
    if  avail {&TableName} then do:

        /* Proj. 82 - Unificaá∆o de Conceitos
         * Alteraá∆o para incluir o campo Conta e CCusto */
        assign &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
                   p-cod-cta-ctbl-ajust = {&TableName}.cod-cta-ctbl-ajust
                   p-cod-ccusto-ajust   = {&TableName}.cod-ccusto-ajust
               &ELSE
                   p-cta-ajuste         = GetEntryField(1, {&TableName}.char-1, ";")
               &ENDIF
               .
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
                                   
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-conta-ajuste-new DBOProgram 
PROCEDURE pi-busca-conta-ajuste-new :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Proj. 82 - Unificaá∆o de Conceitos
     * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
        def output param p-cod-cta-ctbl-ajust like {&TableName}.cod-cta-ctbl-ajust no-undo.
        def output param p-cod-ccusto-ajust   like {&TableName}.cod-ccusto-ajust   no-undo.
    &ELSE
        def output param p-cta-ajuste as char no-undo.
    &ENDIF
    
    def input param ep-cod-ctt like {&TableName}.ep-codigo no-undo.
    def var i-ep-codigo like {&TableName}.ep-codigo no-undo.

    run pi-autenticacao (output i-ep-codigo).

    &IF "{&mgadm_version}":U <= "2.06B":U &THEN
    if i-ep-codigo = 0 then
    &ELSE
    if i-ep-codigo = "0" then
    &ENDIF
        assign i-ep-codigo = ep-cod-ctt.
    
    assign &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
               p-cod-cta-ctbl-ajust = ""
               p-cod-ccusto-ajust   = ""
           &ELSE
               p-cta-ajuste         = ""
           &ENDIF
           .

    find first {&TableName} where
               {&TableName}.ep-codigo = i-ep-codigo
               no-lock no-error.
    if  avail {&TableName} then do:

        /* Proj. 82 - Unificaá∆o de Conceitos
         * Alteraá∆o para incluir o campo Conta e CCusto */
        assign &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
                   p-cod-cta-ctbl-ajust = {&TableName}.cod-cta-ctbl-ajust
                   p-cod-ccusto-ajust   = {&TableName}.cod-ccusto-ajust
               &ELSE
                   p-cta-ajuste         = GetEntryField(1, {&TableName}.char-1, ";")
               &ENDIF
               .
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-conta-baixa-ace DBOProgram 
PROCEDURE pi-busca-conta-baixa-ace :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Proj. 82 - Unificaá∆o de Conceitos
     * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
    
        def output param p-cod-cta-ctbl-trans-bxa-abat like {&TableName}.cod-cta-ctbl-trans-bxa-abat no-undo.
        def output param p-cod-ccusto-trans-bxa-abat   like {&TableName}.cod-ccusto-trans-bxa-abat   no-undo.
    
    &ELSE
    
        def output param p-conta-baixa-ace     like {&TableName}.conta-baixa-ace     no-undo.
        def output param p-ct-codigo-baixa-ace like {&TableName}.ct-codigo-baixa-ace no-undo.
        def output param p-sc-codigo-baixa-ace like {&TableName}.sc-codigo-baixa-ace no-undo.

    &ENDIF

    def var i-ep-codigo like {&TableName}.ep-codigo no-undo.

    run pi-autenticacao (output i-ep-codigo).

    assign &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
               p-cod-cta-ctbl-trans-bxa-abat = ""
               p-cod-ccusto-trans-bxa-abat   = ""
           &ELSE
               p-conta-baixa-ace     = ""
               p-ct-codigo-baixa-ace = ""
               p-sc-codigo-baixa-ace = ""
           &ENDIF
           .

    find first {&TableName} where
               {&TableName}.ep-codigo = i-ep-codigo
               no-lock no-error.
    if  avail {&TableName} then do:

        /* Proj. 82 - Unificaá∆o de Conceitos
         * Alteraá∆o para incluir o campo Conta e CCusto */
        assign &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
                   p-cod-cta-ctbl-trans-bxa-abat = {&TableName}.cod-cta-ctbl-trans-bxa-abat
                   p-cod-ccusto-trans-bxa-abat   = {&TableName}.cod-ccusto-trans-bxa-abat
               &ELSE
                   p-conta-baixa-ace     = {&TableName}.conta-baixa-ace
                   p-ct-codigo-baixa-ace = {&TableName}.ct-codigo-baixa-ace
                   p-sc-codigo-baixa-ace = {&TableName}.sc-codigo-baixa-ace
               &ENDIF
               .
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-conta-baixa-ace-new DBOProgram 
PROCEDURE pi-busca-conta-baixa-ace-new :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Proj. 82 - Unificaá∆o de Conceitos
     * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
    
        def output param p-cod-cta-ctbl-trans-bxa-abat like {&TableName}.cod-cta-ctbl-trans-bxa-abat no-undo.
        def output param p-cod-ccusto-trans-bxa-abat   like {&TableName}.cod-ccusto-trans-bxa-abat   no-undo.
    
    &ELSE
    
        def output param p-conta-baixa-ace     like {&TableName}.conta-baixa-ace     no-undo.
        def output param p-ct-codigo-baixa-ace like {&TableName}.ct-codigo-baixa-ace no-undo.
        def output param p-sc-codigo-baixa-ace like {&TableName}.sc-codigo-baixa-ace no-undo.

    &ENDIF
    DEF INPUT PARAM p-ep-codigo NO-UNDO LIKE {&TableName}.ep-codigo.
    def var i-ep-codigo like {&TableName}.ep-codigo no-undo.

    run pi-autenticacao (output i-ep-codigo).
    IF &IF "{&mguni_version}" >= "2.07A" &THEN
           i-ep-codigo       = "" 
       &ELSE
           i-ep-codigo       = 0 
       &ENDIF THEN DO:
       
        ASSIGN i-ep-codigo = p-ep-codigo.

    END.

    assign &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
               p-cod-cta-ctbl-trans-bxa-abat = ""
               p-cod-ccusto-trans-bxa-abat   = ""
           &ELSE
               p-conta-baixa-ace     = ""
               p-ct-codigo-baixa-ace = ""
               p-sc-codigo-baixa-ace = ""
           &ENDIF
           .

    find first {&TableName} where
               {&TableName}.ep-codigo = i-ep-codigo
               no-lock no-error.
    if  avail {&TableName} then do:

        /* Proj. 82 - Unificaá∆o de Conceitos
         * Alteraá∆o para incluir o campo Conta e CCusto */
        assign &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
                   p-cod-cta-ctbl-trans-bxa-abat = {&TableName}.cod-cta-ctbl-trans-bxa-abat
                   p-cod-ccusto-trans-bxa-abat   = {&TableName}.cod-ccusto-trans-bxa-abat
               &ELSE
                   p-conta-baixa-ace     = {&TableName}.conta-baixa-ace
                   p-ct-codigo-baixa-ace = {&TableName}.ct-codigo-baixa-ace
                   p-sc-codigo-baixa-ace = {&TableName}.sc-codigo-baixa-ace
               &ENDIF
               .
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-conta-cancelamento DBOProgram 
PROCEDURE pi-busca-conta-cancelamento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Proj. 82 - Unificaá∆o de Conceitos
     * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
    
        def output param p-cod-cta-ctbl-cancel like {&TableName}.cod-cta-ctbl-cancel no-undo.
        def output param p-cod-ccusto-cancel   like {&TableName}.cod-ccusto-cancel   no-undo.
        def output param p-cod-unid-negoc-cancel as char                             no-undo.
    
    &ELSE
    
        def output param p-conta-cancel  as char format "x(17)" no-undo.

    &ENDIF

    def var i-ep-codigo like {&TableName}.ep-codigo no-undo.

    run pi-autenticacao (output i-ep-codigo).

    find first {&TableName} where
               {&TableName}.ep-codigo = i-ep-codigo
               no-lock no-error.
    if  avail {&TableName} then do:

        /* Proj. 82 - Unificaá∆o de Conceitos
         * Alteraá∆o para incluir o campo Conta e CCusto */
        &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
                assign p-cod-cta-ctbl-cancel   = {&TableName}.cod-cta-ctbl-cancel
                       p-cod-ccusto-cancel     = {&TableName}.cod-ccusto-cancel
                       p-cod-unid-negoc-cancel = &IF "{&mgadm_version}":U >= "2.09":U &THEN
                                                     {&TableName}.cod-unid-negoc-cancel
                                                 &ELSE
                                                     GetEntryField(3, {&TableName}.char-1, ";")
                                                 &ENDIF
                       .
        &ELSE
                assign p-conta-cancel  = &IF "{&mgadm_version}":U <= "2.05":U &THEN 
                                             GetEntryField(7, {&TableName}.char-2, ";")
                                         &ELSE
                                             {&TableName}.conta-cancelamento
                                         &ENDIF
                       .
        &ENDIF
    end.
    else
        /* Proj. 82 - Unificaá∆o de Conceitos
         * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
        assign &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
                   p-cod-cta-ctbl-cancel   = ""
                   p-cod-ccusto-cancel     = ""
                   p-cod-unid-negoc-cancel = ""
               &ELSE
                   p-conta-cancel = ""
               &ENDIF
               .

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-param-devolucao DBOProgram 
PROCEDURE pi-busca-param-devolucao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def output param p-espec   as char no-undo.
    def output param p-serie   as char no-undo.
    def output param p-receita as int  no-undo.
    def output param p-conta   as char no-undo.
    /* Proj. 82 - Unificaá∆o de Conceitos
     * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
        def output param p-cod-ccusto-devolv     as char no-undo.
        def output param p-cod-unid-negoc-devolv as char no-undo.
    &ENDIF
    
    def var i-ep-codigo like param-mec.ep-codigo no-undo.
    
    run pi-autenticacao (output i-ep-codigo).
    
    find first param-mec where 
               param-mec.ep-codigo = i-ep-codigo
               no-lock no-error.
    if  avail param-mec then do:
        assign p-espec   = param-mec.cod-esp-devol
               p-serie   = param-mec.cod-ser-devol
               p-receita = param-mec.idi-tip-recta-cr-devol
               /* Proj. 82 - Unificaá∆o de Conceitos
                * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
               &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
                   p-conta             = param-mec.cod-cta-ctbl-devolv
                   p-cod-ccusto-devolv = param-mec.cod-ccusto-devolv
                   &IF "{&mgadm_version}":U >= "2.09":U &THEN
                       p-cod-unid-negoc-devolv = param-mec.cod-unid-negoc-devolv
                   &ELSE
                       p-cod-unid-negoc-devolv = GetEntryField(2, param-mec.char-1, ";")
                   &ENDIF
               &ELSE
                   p-conta = param-mec.cod-cta-ctbl-devol
               &ENDIF
               .
    end.
    else
        assign p-espec   = ""
               p-serie   = ""
               p-receita = 0
               p-conta   = ""
               /* Proj. 82 - Unificaá∆o de Conceitos
                * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
               &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
                   p-cod-ccusto-devolv     = ""
                   p-cod-unid-negoc-devolv = ""
               &ENDIF
               .

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-param-mec DBOProgram 
PROCEDURE pi-busca-param-mec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def input  param p-ep-codigo             like {&TableName}.ep-codigo             no-undo.
    def output param p-cod-esp-antec-ap      like {&TableName}.cod-esp-antec-ap      no-undo.
    def output param p-cod-esp-antec-cr      like {&TableName}.cod-esp-antec-cr      no-undo.
    def output param p-serie-antec-ap        like {&TableName}.serie-antec-ap        no-undo.
    def output param p-serie-antec-cr        like {&TableName}.serie-antec-cr        no-undo.
    def output param p-tp-codigo-antec-ap    like {&TableName}.tp-codigo-antec-ap    no-undo.
    def output param p-tp-codigo-antec-cr    like {&TableName}.tp-codigo-antec-cr    no-undo.

    def var i-ep-codigo like {&TableName}.ep-codigo no-undo.

    run pi-autenticacao (output i-ep-codigo).
 
    find first {&TableName} where 
               {&TableName}.ep-codigo = i-ep-codigo 
               no-lock no-error.
    if not avail {&TableName} then
        find first {&TableName} where
                   {&TableName}.ep-codigo = p-ep-codigo
                   no-lock no-error.
    if avail {&TableName} then do:
        assign p-cod-esp-antec-ap    = {&TableName}.cod-esp-antec-ap
               p-cod-esp-antec-cr    = {&TableName}.cod-esp-antec-cr
               p-serie-antec-ap      = {&TableName}.serie-antec-ap
               p-serie-antec-cr      = {&TableName}.serie-antec-cr
               p-tp-codigo-antec-ap  = {&TableName}.tp-codigo-antec-ap
               p-tp-codigo-antec-cr  = {&TableName}.tp-codigo-antec-cr
               .
    end.
    else
        return "OK":U.
 
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-param-mec-3 DBOProgram 
PROCEDURE pi-busca-param-mec-3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def output param p-cod-especie            as char  no-undo.
    def output param p-serie                  as char  no-undo.
    def output param p-despesa                as char  no-undo.
    def output param p-cod-cta-ctbl-pre-pagto as char  no-undo.
    /* Proj. 82 - Unificaá∆o de Conceitos
     * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
        def output param p-cod-ccusto-pre-pagto     as char no-undo.
        def output param p-cod-unid-negoc-pre-pagto as char no-undo.
    &ENDIF

    def var i-ep-codigo like {&TableName}.ep-codigo no-undo.

    run pi-autenticacao (output i-ep-codigo).

    find first {&TableName} where
               {&TableName}.ep-codigo = i-ep-codigo 
               no-lock no-error.
    if avail {&TableName} then do:
        assign &IF "{&mgadm_version}":U >= "2.06B":U &THEN
                   p-cod-especie  = {&TableName}.cod-esp-pre-pagto
                   p-serie        = {&TableName}.serie-pre-pagto
                   p-despesa      = string({&TableName}.tp-despesa-pre-pagto)
               &ELSE
                   p-cod-especie  = GetEntryField(2 , {&TableName}.char-2, ";")
                   p-serie        = GetEntryField(3 , {&TableName}.char-2, ";")
                   p-despesa      = GetEntryField(4 , {&TableName}.char-2, ";")
               &ENDIF
               .
        
        /* Proj. 82 - Unificaá∆o de Conceitos
         * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
        assign &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
                   p-cod-cta-ctbl-pre-pagto   = {&TableName}.cod-cta-ctbl-pre-pagto
                   p-cod-ccusto-pre-pagto     = {&TableName}.cod-ccusto-pre-pagto
                   p-cod-unid-negoc-pre-pagto = &IF "{&mgadm_version}":U >= "2.09":U &THEN
                                                    {&TableName}.cod-unid-negoc-pre-pagto
                                                &ELSE
                                                    GetEntryField(6, {&TableName}.char-1, ";")
                                                &ENDIF
               &ELSE
                   p-cod-cta-ctbl-pre-pagto = &IF "{&mgadm_version}":U >= "2.06B":U &THEN
                                                  {&TableName}.conta-pre-pagto
                                              &ELSE
                                                  GetEntryField(5 , {&TableName}.char-2, ";")
                                              &ENDIF
               &ENDIF
               .
    end.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-param-mec-4 DBOProgram 
PROCEDURE pi-busca-param-mec-4 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param p-liquidacao-ace as LOG no-undo.

    def var i-ep-codigo like param-mec.ep-codigo no-undo.

    run pi-autenticacao (output i-ep-codigo).
 
    find first param-mec where param-mec.ep-codigo = i-ep-codigo no-lock no-error.
    if avail param-mec then do:

        
        &if "{&mgadm_version}":U >= "2.05":U &then 
            assign p-liquidacao-ace = param-mec.juros-liq-ace.
        &else 
            if num-entries(param-mec.char-2,";") > 5 then               
                if entry(6,param-mec.char-2,";") = "yes" then 
                    assign p-liquidacao-ace = yes. 
                else 
                    assign p-liquidacao-ace = no.
        &endif.    
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-param-mec-5 DBOProgram 
PROCEDURE pi-busca-param-mec-5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    
    def output param p-conta-baixa-ace like {&TableName}.conta-baixa-ace no-undo.

    def var i-ep-codigo like {&TableName}.ep-codigo no-undo.
    def var h-boin407   as handle                   no-undo.

    run pi-autenticacao (output i-ep-codigo).
 
    find first {&TableName} where
               {&TableName}.ep-codigo = i-ep-codigo
               no-lock no-error.
    if avail {&TableName} then
        assign p-conta-baixa-ace = {&TableName}.conta-baixa-ace.
    else
        return "OK":U.
 
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-param-mec2 DBOProgram 
PROCEDURE pi-busca-param-mec2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def output param i-ep-codigo     like {&TableName}.ep-codigo no-undo.
    def output param p-conta-repres  as char format "x(10)"      no-undo.
    def output param p-subcta-repres as char format "x(10)"      no-undo.
    
    def var i-conta   as int.
    def var i-subcta  as int.
    
    run pi-autenticacao (output i-ep-codigo).
    
    find first param-global no-lock no-error.
    if avail param-global then
        assign i-conta  = length(param-global.ct-format)
               i-subcta = length(param-global.sc-format).
    else
        assign i-conta  = 0
               i-subcta = 0.
    
    find first {&TableName} where {&TableName}.ep-codigo = i-ep-codigo no-lock no-error.
    if  avail {&TableName} then do:
        /* Proj. 82 - Unificaá∆o de Conceitos
         * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */ 
        assign &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
                   p-conta-repres  = {&TableName}.cod-cta-ctbl-represen
                   p-subcta-repres = {&TableName}.cod-ccusto-represen
               &ELSE
                   &IF "{&mgadm_version}":U <= "2.04":U &THEN
                       p-conta-repres  = substr({&TableName}.char-2, 1, i-conta)
                       p-subcta-repres = substr({&TableName}.char-2, i-conta + 1, i-subcta)
                   &ELSE
                       p-conta-repres  = substr({&TableName}.conta-representante, 1, i-conta)
                       p-subcta-repres = substr({&TableName}.conta-representante, i-conta + 1, i-subcta)
                   &ENDIF
               &ENDIF
               .
    end.
    else
        assign p-conta-repres  = ""
               p-subcta-repres = "".

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-recta-cambio-fut DBOProgram 
PROCEDURE pi-busca-recta-cambio-fut :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def input  param  p-ep-codigo like {&TableName}.ep-codigo            no-undo.
    def output param p-idi-tip-recta-cambio-fut  as int format ">>9"  no-undo.

    def var i-ep-codigo like {&TableName}.ep-codigo no-undo.
    
    &IF DEFINED(BF_FIN_MEC_FUT_CFL2) &THEN

        if l-funcao-recta-cambio-fut = yes then do:

            run pi-autenticacao (output i-ep-codigo).

            find first {&TableName} where 
                       {&TableName}.ep-codigo = p-ep-codigo
                       no-lock no-error.
            if avail {&TableName} then
                assign p-idi-tip-recta-cambio-fut = {&TableName}.idi-tip-recta-cambio-fut.
            else
                return "OK":U.
        end.
    &ENDIF

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-registro DBOProgram 
PROCEDURE pi-busca-registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def output param table for RowObject.

    def var i-ep-codigo like {&TableName}.ep-codigo.

    run pi-autenticacao (output i-ep-codigo).

    find first {&TableName} where {&TableName}.ep-codigo = i-ep-codigo no-lock no-error.
    
    if avail {&TableName} then do:
        create RowObject.
        buffer-copy {&TableName} to RowObject.
    end.
    else
        return "NOK":U.
        
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-criar-param-mec DBOProgram 
PROCEDURE pi-criar-param-mec :
/*------------------------------------------------------------------------------
  Purpose: Cria um registro na tabela param-mec
  Parameters: tt-cria-{&TableName} like param-mec
  Notes:
------------------------------------------------------------------------------*/

    define input parameter table for tt-cria-{&TableName}.

    define variable i-ep-codigo like {&TableName}.ep-codigo no-undo.

    for each RowErrors:
        delete RowErrors.
    end.

    find first tt-cria-{&TableName} no-error.
    if not avail tt-cria-{&TableName} then
        return "NOK":U.

    run pi-autenticacao (output i-ep-codigo).

    /* Esta procedure valida todas as informaá‰es da param-mec */
    run pi-validar-param-mec in this-procedure (input table tt-cria-{&TableName},
                                                input i-ep-codigo).

    if return-value = "NOK" then
        return "NOK":U.

    find first bf{&TableName} where
               bf{&TableName}.ep-codigo = i-ep-codigo
               exclusive-lock no-error.
    if not avail bf{&TableName} then do:

        assign cQueryUseded = "Main".
        
        for each RowObject:
            delete RowObject.
        end.

        create RowObject.
        buffer-copy tt-cria-{&TableName} to RowObject.

        run CreateRecord in this-procedure.
        return return-value.

    end.
    else
        buffer-copy tt-cria-{&TableName} to bf{&TableName}.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-dados-antec-ap DBOProgram 
PROCEDURE pi-dados-antec-ap :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
    def output param c-cod-esp    like {&TableName}.cod-esp-antec-ap   no-undo.
    def output param c-serie      like {&TableName}.serie-antec-ap     no-undo.
    def output param c-tp-despesa like {&TableName}.tp-codigo-antec-ap no-undo.
    def var i-ep-codigo           like {&TableName}.ep-codigo          no-undo.

    run pi-autenticacao (output i-ep-codigo).

    find first {&TableName} where
               {&TableName}.ep-codigo = i-ep-codigo
               no-lock no-error.
    if avail {&TableName} then do:
      
        find espec-ap where
             espec-ap.cod-esp = {&TableName}.cod-esp-antec-ap and 
             espec-ap.tipo    = 2
             no-lock no-error.

        if avail espec-ap then
            assign c-cod-esp    = {&TableName}.cod-esp-antec-ap
                   c-serie      = {&TableName}.serie-antec-ap
                   c-tp-despesa = {&TableName}.tp-codigo-antec-ap.
        else
            assign c-cod-esp    = ""
                   c-serie      = ""
                   c-tp-despesa = 0.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inserir-erros-tt DBOProgram 
PROCEDURE pi-inserir-erros-tt :
/*------------------------------------------------------------------------------
  Purpose: Insere erros da tt_log_erro na RowErrors
  Parameters: tt_log_erro
  Notes:
------------------------------------------------------------------------------*/

    define input-output parameter table for tt_log_erro.
    define input        parameter i-folder as int       no-undo.

    define variable i-seq-erro   as integer   no-undo.
    define variable c-folder     as character no-undo.

    case i-folder:
        when 1 then
            {utp/ut-liter.i Comiss‰es *}
        when 3 then
            {utp/ut-liter.i Aplicaá‰es_e_EmprÇstimo *}
        when 4 then
            {utp/ut-liter.i PrÇ-Pagamento *}
        when 5 then
            {utp/ut-liter.i Arbitragem *}
        when 6 then
            {utp/ut-liter.i Liquidaá∆o *}
        when 7 then
            {utp/ut-liter.i Devoluá∆o *}
    end case.
    assign c-folder = return-value.

    assign i-seq-erro = 0.

    for each tt_log_erro:
    
        find last RowErrors no-lock no-error.
        if avail RowErrors then
            assign i-seq-erro = RowErrors.ErrorSequence + 10.
        else
            assign i-seq-erro = 10.

        create RowErrors.
        assign RowErrors.ErrorSequence    = i-seq-erro
               RowErrors.ErrorNumber      = tt_log_erro.ttv_num_cod_erro
               RowErrors.ErrorParameters  = ""
               RowErrors.ErrorType        = ""
               RowErrors.ErrorSubType     = "ERROR"
               RowErrors.ErrorDescription = if trim(c-folder) <> "" then c-folder + " - " + tt_log_erro.ttv_des_msg_erro
                                            else tt_log_erro.ttv_des_msg_erro
               RowErrors.ErrorHelp        = tt_log_erro.ttv_des_msg_ajuda.
    end.

    if can-find(first tt_log_erro) then do:
        
        for each tt_log_erro:
            delete tt_log_erro.
        end.

        return "NOK":U.

    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-param-arbitragem DBOProgram 
PROCEDURE pi-param-arbitragem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def output param p-espec-acr  as char no-undo.
    def output param p-serie-acr  as char no-undo.
    def output param p-receita    as int  no-undo.
    def output param p-espec-apb  as char no-undo.
    def output param p-serie-apb  as char no-undo.
    def output param p-despesa    as int  no-undo.
    /* Proj. 82 - Unificaá∆o de Conceitos
     * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
        def output param p-cod-unid-negoc-arbit as char no-undo.
    &ENDIF

    def var i-ep-codigo like {&TableName}.ep-codigo no-undo.

    run pi-autenticacao (output i-ep-codigo).
    
    find first {&TableName} where 
               {&TableName}.ep-codigo = i-ep-codigo
               no-lock no-error.
    if avail {&TableName} then do:

        &IF "{&mgadm_version}":U <= "2.06B":U &THEN
            assign p-espec-acr  =     GetEntryField(8 , {&TableName}.char-2, ";")
                   p-serie-acr  =     GetEntryField(9 , {&TableName}.char-2, ";")
                   p-receita    = int(GetEntryField(10, {&TableName}.char-2, ";"))
                   p-espec-apb  =     GetEntryField(11, {&TableName}.char-2, ";")
                   p-serie-apb  =     GetEntryField(12, {&TableName}.char-2, ";")
                   p-despesa    = int(GetEntryField(13, {&TableName}.char-2, ";"))
                   .
        &ELSE
            assign p-espec-acr  =     {&TableName}.cod-espec-acr
                   p-serie-acr  =     {&TableName}.serie-acr
                   p-receita    = int({&TableName}.tp-receita-acr)
                   p-espec-apb  =     {&TableName}.cod-espec-apb
                   p-serie-apb  =     {&TableName}.serie-apb
                   p-despesa    =     {&TableName}.tp-despesa-apb
                   .
        &ENDIF
        
        /* Proj. 82 - Unificaá∆o de Conceitos
         * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
        &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
            assign p-cod-unid-negoc-arbit = &IF "{&mgadm_version}":U >= "2.09":U &THEN
                                                {&TableName}.cod-unid-negoc-arbit
                                            &ELSE
                                                GetEntryField(4, {&TableName}.char-1, ";")
                                            &ENDIF
                   .
        &ENDIF
    end.
    else
        assign p-espec-acr  = ""
               p-serie-acr  = ""
               p-receita    = 0
               p-espec-apb  = ""
               p-serie-apb  = ""
               p-despesa    = 0
               /* Proj. 82 - Unificaá∆o de Conceitos
                * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
               &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
                   p-cod-unid-negoc-arbit = ""
               &ENDIF
               .

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-param-juros-desemb DBOProgram 
PROCEDURE pi-param-juros-desemb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    
    def output param p-espec      as char no-undo.
    def output param p-serie      as char no-undo.
    def output param p-despesa    as int  no-undo.
    def output param p-cta-desp   as char no-undo.
    /* Proj. 82 - Unificaá∆o de Conceitos
     * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
        def output param p-ccusto-desp           as char no-undo.
        def output param p-cod-unid-negoc-desemb as char no-undo.
    &ENDIF

    def var i-ep-codigo like {&TableName}.ep-codigo no-undo.

    run pi-autenticacao (output i-ep-codigo).

    find first {&TableName} where 
               {&TableName}.ep-codigo = i-ep-codigo
               no-lock no-error.
    if avail {&TableName} then do:

        assign &IF "{&mgadm_version}":U < "2.06B":U &THEN
                   p-espec    =     GetEntryField(14, {&TableName}.char-2, ";")
                   p-serie    =     GetEntryField(15, {&TableName}.char-2, ";")
                   p-despesa  = int(GetEntryField(16, {&TableName}.char-2, ";"))
               &ELSE
                   p-espec    = {&TableName}.cod-espec-apb-desemb
                   p-serie    = {&TableName}.serie-apb-desemb
                   p-despesa  = {&TableName}.tp-desp-apb-desemb
               &ENDIF
               .

        /* Proj. 82 - Unificaá∆o de Conceitos
         * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
        &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
            assign p-cta-desp              = {&TableName}.cod-cta-ctbl-desemb
                   p-ccusto-desp           = {&TableName}.cod-ccusto-desemb
                   p-cod-unid-negoc-desemb = &IF "{&mgadm_version}":U >= "2.09":U &THEN
                                                 {&TableName}.cod-unid-negoc-desemb
                                             &ELSE
                                                 GetEntryField(5, {&TableName}.char-1, ";")
                                             &ENDIF
                   .
        &ELSE
            assign &IF "{&mgadm_version}":U < "2.06B":U &THEN
                       p-cta-desp = GetEntryField(17, {&TableName}.char-2, ";")
                   &ELSE
                       p-cta-desp = {&TableName}.conta-apb-desemb
                   &ENDIF
                   .
        &ENDIF
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validar-conta-ccusto DBOProgram 
PROCEDURE pi-validar-conta-ccusto :
/*------------------------------------------------------------------------------
  Purpose: Validaá‰es de Conta e CCusto
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Proj. 82 - Unificaá∆o de Conceitos
     * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto
     * Validaá‰es de Conta e CCusto */
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN

        def input param c-cod-cta-ctbl-represen       like {&TableName}.cod-cta-ctbl-represen       no-undo.
        def input param c-cod-ccusto-represen         like {&TableName}.cod-ccusto-represen         no-undo.
        def input param c-cod-cta-ctbl-trans-bxa-abat like {&TableName}.cod-cta-ctbl-trans-bxa-abat no-undo.
        def input param c-cod-ccusto-trans-bxa-abat   like {&TableName}.cod-ccusto-trans-bxa-abat   no-undo.
        def input param c-cod-cta-ctbl-ajust          like {&TableName}.cod-cta-ctbl-ajust          no-undo.
        def input param c-cod-ccusto-ajust            like {&TableName}.cod-ccusto-ajust            no-undo.
        def input param c-cod-cta-ctbl-cancel         like {&TableName}.cod-cta-ctbl-cancel         no-undo.
        def input param c-cod-ccusto-cancel           like {&TableName}.cod-ccusto-cancel           no-undo.
        def input param c-cod-cta-ctbl-pre-pagto      like {&TableName}.cod-cta-ctbl-pre-pagto      no-undo.
        def input param c-cod-ccusto-pre-pagto        like {&TableName}.cod-ccusto-pre-pagto        no-undo.
        def input param c-cod-cta-ctbl-desemb         like {&TableName}.cod-cta-ctbl-desemb         no-undo.
        def input param c-cod-ccusto-desemb           like {&TableName}.cod-ccusto-desemb           no-undo.

        run prgint/utb/utb743za.py persistent set h-api-conta.
        run prgint/utb/utb742za.py persistent set h-api-ccusto.

        /************************************************************* CONTA DO REPRESENTANTE **************************************************************/

        run pi_valida_conta_contabil in h-api-conta (input "",
                                                     input "",
                                                     input "",
                                                     input "",
                                                     input c-cod-cta-ctbl-represen,
                                                     input "",
                                                     input c-cod-ccusto-represen,
                                                     input today,
                                                     output table tt_log_erro).
        run pi-inserir-erros-tt (input-output table tt_log_erro,
                                 input 1).
        
        if return-value = "OK":U then do:
            run pi_valida_cta_ctbl_integr in h-api-conta (input "",
                                                          input "ACR",
                                                          input "",
                                                          input c-cod-cta-ctbl-represen,
                                                          input "Conta Movimento",
                                                          input today,
                                                          output table tt_log_erro).
            run pi-inserir-erros-tt (input-output table tt_log_erro,
                                     input 1).
        end.

        /***************************************************************************************************************************************************/
        /*************************************************************** CONTA TRANSIT/ABAT ****************************************************************/

        assign l-utiliza-ccusto = no.
        run pi_verifica_utilizacao_ccusto in h-api-ccusto (input  "",
                                                           input  "",
                                                           input  "",
                                                           input  c-cod-cta-ctbl-trans-bxa-abat,
                                                           input  today,
                                                           output l-utiliza-ccusto,
                                                           output table tt_log_erro).
        if l-utiliza-ccusto then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-transitoria-baixaa AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Transit¢ria_Baixa/Abat" *}
            ASSIGN c-lbl-liter-transitoria-baixaa = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                            &ErrorNumber="52226"
                            &ErrorType="EMS"
                            &ErrorParameters="substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9', c-lbl-liter-transitoria-baixaa + ' ', c-cod-cta-ctbl-trans-bxa-abat)"}
        end.
        else do:

            run pi_valida_conta_contabil in h-api-conta (input "",
                                                         input "",
                                                         input "",
                                                         input "",
                                                         input c-cod-cta-ctbl-trans-bxa-abat,
                                                         input "",
                                                         input c-cod-ccusto-trans-bxa-abat,
                                                         input today,
                                                         output table tt_log_erro).
            run pi-inserir-erros-tt (input-output table tt_log_erro,
                                     input 3).
    
            if return-value = "OK":U then do:
                run pi_valida_cta_ctbl_integr in h-api-conta (input "",
                                                              input "APL",
                                                              input "",
                                                              input c-cod-cta-ctbl-trans-bxa-abat,
                                                              input "Saldo",
                                                              input today,
                                                              output table tt_log_erro).
                run pi-inserir-erros-tt (input-output table tt_log_erro,
                                         input 3).
            end.
        end.

        /***************************************************************************************************************************************************/
        /****************************************************************** CONTA AJUSTE *******************************************************************/

        assign l-utiliza-ccusto = no.
        run pi_verifica_utilizacao_ccusto in h-api-ccusto (input  "",
                                                           input  "",
                                                           input  "",
                                                           input  c-cod-cta-ctbl-ajust,
                                                           input  today,
                                                           output l-utiliza-ccusto,
                                                           output table tt_log_erro).
        if l-utiliza-ccusto then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-ajustes AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Ajustes" *}
            ASSIGN c-lbl-liter-ajustes = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                            &ErrorNumber="52226"
                            &ErrorType="EMS"
                            &ErrorParameters="substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9', c-lbl-liter-ajustes + ' ', c-cod-cta-ctbl-ajust)"}
        end.
        else do:
            run pi_valida_conta_contabil in h-api-conta (input "",
                                                         input "",
                                                         input "",
                                                         input "",
                                                         input c-cod-cta-ctbl-ajust,
                                                         input "",
                                                         input c-cod-ccusto-ajust,
                                                         input today,
                                                         output table tt_log_erro).
            run pi-inserir-erros-tt (input-output table tt_log_erro,
                                     input 3).
         
            if return-value = "OK":U then do:
                run pi_valida_cta_ctbl_integr in h-api-conta (input "",
                                                              input "APL",
                                                              input "",
                                                              input c-cod-cta-ctbl-ajust,
                                                              input "Ajustes",
                                                              input today,
                                                              output table tt_log_erro).
                run pi-inserir-erros-tt (input-output table tt_log_erro,
                                         input 3).
            end.
        end.

        /***************************************************************************************************************************************************/
        /*************************************************************** CONTA CANCELAMENTO ****************************************************************/

        assign l-utiliza-ccusto = no.
        run pi_verifica_utilizacao_ccusto in h-api-ccusto (input  "",
                                                           input  "",
                                                           input  "",
                                                           input  c-cod-cta-ctbl-cancel,
                                                           input  today,
                                                           output l-utiliza-ccusto,
                                                           output table tt_log_erro).
        if l-utiliza-ccusto then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-cancelamento AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Cancelamento" *}
            ASSIGN c-lbl-liter-cancelamento = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                            &ErrorNumber="52226"
                            &ErrorType="EMS"
                            &ErrorParameters="substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9', c-lbl-liter-cancelamento + ' ', c-cod-cta-ctbl-cancel)"}
        end.
        else do:
            run pi_valida_conta_contabil in h-api-conta (input "",
                                                         input "",
                                                         input "",
                                                         input "",
                                                         input c-cod-cta-ctbl-cancel,
                                                         input "",
                                                         input c-cod-ccusto-cancel,
                                                         input today,
                                                         output table tt_log_erro).
            run pi-inserir-erros-tt (input-output table tt_log_erro,
                                     input 3).
                      
            if return-value = "OK":U then do:
                run pi_valida_cta_ctbl_integr in h-api-conta (input "",
                                                              input "APL",
                                                              input "",
                                                              input c-cod-cta-ctbl-cancel,
                                                              input "Ajustes",
                                                              input today,
                                                              output table tt_log_erro).
                run pi-inserir-erros-tt (input-output table tt_log_erro,
                                         input 3).
            end.
        end.

        /***************************************************************************************************************************************************/
        /************************************************************** CONTA PRê-PAGAMENTO ****************************************************************/

        assign l-utiliza-ccusto = no.
        run pi_verifica_utilizacao_ccusto in h-api-ccusto (input  "",
                                                           input  "",
                                                           input  "",
                                                           input  c-cod-cta-ctbl-pre-pagto,
                                                           input  today,
                                                           output l-utiliza-ccusto,
                                                           output table tt_log_erro).

        if l-utiliza-ccusto then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-pre-pagamento AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "PrÇ-pagamento" *}
            ASSIGN c-lbl-liter-pre-pagamento = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                            &ErrorNumber="52226"
                            &ErrorType="EMS"
                            &ErrorParameters="substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9', c-lbl-liter-pre-pagamento + ' ', c-cod-cta-ctbl-pre-pagto)"}
        end.
        else do:
            run pi_valida_conta_contabil in h-api-conta (input "",
                                                         input "",
                                                         input "",
                                                         input "",
                                                         input c-cod-cta-ctbl-pre-pagto,
                                                         input "",
                                                         input c-cod-ccusto-pre-pagto,
                                                         input today,
                                                         output table tt_log_erro).
            run pi-inserir-erros-tt (input-output table tt_log_erro,
                                     input 4).
            
            if return-value = "OK":U then do:
                run pi_valida_cta_ctbl_integr in h-api-conta (input "",
                                                              input "APB",
                                                              input "",
                                                              input c-cod-cta-ctbl-pre-pagto,
                                                              input "Conta Movimento",
                                                              input today,
                                                              output table tt_log_erro).
                run pi-inserir-erros-tt (input-output table tt_log_erro,
                                         input 4).
            end.
        end.
        
        /***************************************************************************************************************************************************/
        /**************************************************************** CONTA DESEMBOLSO *****************************************************************/

        assign l-utiliza-ccusto = no.
        run pi_verifica_utilizacao_ccusto in h-api-ccusto (input  "",
                                                           input  "",
                                                           input  "",
                                                           input  c-cod-cta-ctbl-desemb,
                                                           input  today,
                                                           output l-utiliza-ccusto,
                                                           output table tt_log_erro).

        if l-utiliza-ccusto then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-pagamento-de-juros AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Pagamento_de_Juros_Sem_Desembolso" *}
            ASSIGN c-lbl-liter-pagamento-de-juros = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                            &ErrorNumber="52226"
                            &ErrorType="EMS"
                            &ErrorParameters="substitute ('&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9', c-lbl-liter-pagamento-de-juros + ' ', c-cod-cta-ctbl-desemb)"}
        end.
        else do:
            if c-cod-cta-ctbl-desemb <> "" then do:
                run pi_valida_conta_contabil in h-api-conta (input "",
                                                             input "",
                                                             input "",
                                                             input "",
                                                             input c-cod-cta-ctbl-desemb,
                                                             input "",
                                                             input c-cod-ccusto-desemb,
                                                             input today,
                                                             output table tt_log_erro).
                run pi-inserir-erros-tt (input-output table tt_log_erro,
                                         input 6).
                
                if return-value = "OK":U then do:
                    run pi_valida_cta_ctbl_integr in h-api-conta (input "",
                                                                  input "APB",
                                                                  input "",
                                                                  input c-cod-cta-ctbl-desemb,
                                                                  input "Conta Movimento",
                                                                  input today,
                                                                  output table tt_log_erro).
                    run pi-inserir-erros-tt (input-output table tt_log_erro,
                                             input 6).
                end.
            end.
        end.

        /***************************************************************************************************************************************************/

        if valid-handle(h-api-conta) then
            delete procedure h-api-conta.

        if valid-handle(h-api-ccusto) then
            delete procedure h-api-ccusto.

    &ENDIF
    
    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validar-devolucao DBOProgram 
PROCEDURE pi-validar-devolucao :
/*------------------------------------------------------------------------------
  Purpose: Valida as informaá‰es do folder Devoluá∆o
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input param p-cod-ser-devol             as char no-undo.
    def input param p-cod-esp-devol             as char no-undo.
    def input param p-idi-tip-recta-cr-devol    as int  no-undo.
    /* Proj. 82 - Unificaá∆o de Conceitos
     * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
        def input param p-cod-cta-ctbl-devol    as char no-undo.
    &ELSE
        def input param p-cod-cta-ctbl-devolv   as char no-undo.
        def input param p-cod-ccusto-devolv     as char no-undo.
        def input param p-cod-unid-negoc-devolv as char no-undo.
    &ENDIF

    if  p-cod-esp-devol             = ""
    and p-cod-ser-devol             = ""
    and p-idi-tip-recta-cr-devol    = 0
    /* Proj. 82 - Unificaá∆o de Conceitos
     * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
        and p-cod-cta-ctbl-devol    = ""
    &ELSE
        and p-cod-cta-ctbl-devolv   = ""
        and p-cod-ccusto-devolv     = ""
        and p-cod-unid-negoc-devolv = ""
    &ENDIF
    then
        return "OK":U.

    if can-find (first esp-doc
                 where esp-doc.cod-esp = p-cod-esp-devol) = no
                    or p-cod-esp-devol = "" then
        {method/svc/errors/inserr.i
                    &ErrorNumber="25917"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    if can-find (first esp-doc
                 where esp-doc.cod-esp  = p-cod-esp-devol
                   and esp-doc.tipo    <> 1) = yes then
        {method/svc/errors/inserr.i
                    &ErrorNumber="52543"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    if can-find (first serie
                 where serie.serie = p-cod-ser-devol) = no then
        {method/svc/errors/inserr.i
                    &ErrorNumber="25919"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    if can-find (first tipo-rec-desp
                 where tipo-rec-desp.tp-codigo = p-idi-tip-recta-cr-devol) = no
                    or p-idi-tip-recta-cr-devol = 0 then
        {method/svc/errors/inserr.i
                    &ErrorNumber="141"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    if can-find (first tipo-rec-desp
                 where tipo-rec-desp.tp-codigo  = p-idi-tip-recta-cr-devol
                   and tipo-rec-desp.tipo      <> 1) = yes then
        {method/svc/errors/inserr.i
                    &ErrorNumber="25050"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    /* Proj. 82 - Unificaá∆o de Conceitos
     * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN

        if p-cod-cta-ctbl-devol = "" then
            {method/svc/errors/inserr.i
                        &ErrorNumber="6726"
                        &ErrorType="EMS"
                        &ErrorParameters="''"}

    &ELSE

        run prgint/utb/utb743za.py persistent set h-api-conta.
        run prgint/utb/utb936wa.py persistent set h-bo-unid-negoc.

        run pi_valida_conta_contabil in h-api-conta (input "",
                                                     input "",
                                                     input "",
                                                     input "",
                                                     input p-cod-cta-ctbl-devolv,
                                                     input "",
                                                     input p-cod-ccusto-devolv,
                                                     input today,
                                                     output table tt_log_erro).
        run pi-inserir-erros-tt (input-output table tt_log_erro,
                                 input 7).
        
        if return-value = "OK":U then do:
            run pi_valida_cta_ctbl_integr in h-api-conta (input "",
                                                          input "ACR",
                                                          input "",
                                                          input p-cod-cta-ctbl-devolv,
                                                          input "Conta Movimento",
                                                          input today,
                                                          output table tt_log_erro).
            run pi-inserir-erros-tt (input-output table tt_log_erro,
                                     input 7).
        end.

        run pi_vld_info_unid_negoc in h-bo-unid-negoc (input  p-cod-unid-negoc-devolv,
                                                       output table tt_log_erro).

        run pi-inserir-erros-tt (input-output table tt_log_erro,
                                 input 7).

        if valid-handle(h-api-conta) then
            delete procedure h-api-conta.

        if valid-handle(h-bo-unid-negoc) then
            delete procedure h-bo-unid-negoc.

    &ENDIF

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validar-param-mec DBOProgram 
PROCEDURE pi-validar-param-mec :
/*------------------------------------------------------------------------------
  Purpose: Valida informaá‰es da param-mec
  Parameters: tt-cria-{&TableName} like param-mec / p-ep-codigo: Empresa
  Notes:
------------------------------------------------------------------------------*/
    
    define input parameter table for tt-cria-{&TableName}.
    define input parameter p-ep-codigo like {&TableName}.ep-codigo no-undo.

    find first tt-cria-{&TableName} no-error.
    if not avail tt-cria-{&TableName} then
        return "NOK":U.

    run adbo/boad355.p persistent set h-boad355.
    run pi-verificar-produto in h-boad355 (output v-pagar,
                                           output v-receber).
    delete procedure h-boad355.

    if can-find (first espec-ap where 
                       espec-ap.cod-esp = tt-cria-{&TableName}.cod-esp-antec-ap) = no
    or tt-cria-{&TableName}.cod-esp-antec-ap = "" then
        {method/svc/errors/inserr.i
                    &ErrorNumber="25914"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    if can-find (first espec-ap where 
                       espec-ap.cod-esp  = tt-cria-{&TableName}.cod-esp-antec-ap and
                       espec-ap.tipo    <> 2) = yes then
        {method/svc/errors/inserr.i
                    &ErrorNumber="25915"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    if can-find (first serie where
                       serie.serie = tt-cria-{&TableName}.serie-antec-ap) = no then
        {method/svc/errors/inserr.i
                    &ErrorNumber="25916"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    if can-find (first tipo-rec-desp where
                       tipo-rec-desp.tp-codigo = tt-cria-{&TableName}.tp-codigo-antec-ap) = no
    or tt-cria-{&TableName}.tp-codigo-antec-ap = 0 then
        {method/svc/errors/inserr.i
                    &ErrorNumber="3299"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}       

    if can-find (first tipo-rec-desp where 
                       tipo-rec-desp.tp-codigo  = tt-cria-{&TableName}.tp-codigo-antec-ap and
                       tipo-rec-desp.tipo      <> 2) = yes then
        {method/svc/errors/inserr.i
                    &ErrorNumber="25049"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    if can-find (first esp-doc where
                       esp-doc.cod-esp = tt-cria-{&TableName}.cod-esp-antec-cr) = no 
    or tt-cria-{&TableName}.cod-esp-antec-cr = "" then
        {method/svc/errors/inserr.i
                    &ErrorNumber="25917"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    if can-find (first esp-doc where
                       esp-doc.cod-esp = tt-cria-{&TableName}.cod-esp-antec-cr and
                       esp-doc.tipo   <> 2) = yes then
        {method/svc/errors/inserr.i
                    &ErrorNumber="25918"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    if can-find (first serie where
                       serie.serie = tt-cria-{&TableName}.serie-antec-cr) = no then
        {method/svc/errors/inserr.i
                    &ErrorNumber="25919"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    if can-find (first tipo-rec-desp where
                       tipo-rec-desp.tp-codigo = tt-cria-{&TableName}.tp-codigo-antec-cr) = no 
    or tt-cria-{&TableName}.tp-codigo-antec-cr = 0 then
        {method/svc/errors/inserr.i
                    &ErrorNumber="3299"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    &IF DEFINED(BF_FIN_MEC_FUT_CFL2) &THEN

        if l-funcao-recta-cambio-fut then do:
            if can-find (first tipo-rec-desp where
                               tipo-rec-desp.tp-codigo = tt-cria-{&TableName}.idi-tip-recta-cambio-fut) = no
            or tt-cria-{&TableName}.idi-tip-recta-cambio-fut = 0 then
                {method/svc/errors/inserr.i
                            &ErrorNumber="3299"
                            &ErrorType="EMS"
                            &ErrorParameters="''"}
        end.
    &ENDIF

    if can-find (first tipo-rec-desp where
                       tipo-rec-desp.tp-codigo  = tt-cria-{&TableName}.tp-codigo-antec-cr and
                       tipo-rec-desp.tipo      <> 1) = yes then
        {method/svc/errors/inserr.i
                    &ErrorNumber="25050"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    &IF DEFINED(BF_FIN_MEC_FUT_CFL2) &THEN

        if l-funcao-recta-cambio-fut then do:
            if can-find (first tipo-rec-desp where
                               tipo-rec-desp.tp-codigo  = tt-cria-{&TableName}.idi-tip-recta-cambio-fut and
                               tipo-rec-desp.tipo      <> 1) = yes then
                {method/svc/errors/inserr.i
                            &ErrorNumber="25050"
                            &ErrorType="EMS"
                            &ErrorParameters="''"}
        end.
    &ENDIF

    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN

        find first integr-mec-modul-funcao where
                   integr-mec-modul-funcao.cod-modul-integr  = "MEC"          and
                   integr-mec-modul-funcao.ind-funcao-integr = "Aplica_Empre" and
                   &IF "{&mguni_version}" >= "2.07A" &THEN
                   integr-mec-modul-funcao.cod-empresa       = ""             and
                   &ELSE
                   integr-mec-modul-funcao.cod-empresa       = 0              and
                   &ENDIF
                   integr-mec-modul-funcao.cod-estab         = ""             and         
                   integr-mec-modul-funcao.cod-produt-modul  = "EMS 5"        no-lock no-error.
        if avail integr-mec-modul-funcao then do:

    &ENDIF

        /* Proj. 82 - Unificaá∆o de Conceitos
         * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
        &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN

            if can-find (first conta-contab where
                               conta-contab.ep-codigo      = p-ep-codigo and
                               conta-contab.conta-contabil = tt-cria-{&TableName}.conta-baixa-ace) = no
            or tt-cria-{&TableName}.conta-baixa-ace = "" then do:
                {method/svc/errors/inserr.i
                            &ErrorNumber="1883"
                            &ErrorType="EMS"
                            &ErrorParameters="''"}
            end.

            if can-find (first conta-contab where
                               conta-contab.ep-codigo      = p-ep-codigo and
                               conta-contab.conta-contabil = tt-cria-{&TableName}.conta-baixa-ace) = no
            or tt-cria-{&TableName}.conta-baixa-ace = "" then do:
                {method/svc/errors/inserr.i
                            &ErrorNumber="1883"
                            &ErrorType="EMS"
                            &ErrorParameters="''"}
            end.

            if v-receber = "EMS 5" then do:
                /*Conta Cont†bil do Representante*/    
                if can-find (first conta-contab where 
                                   conta-contab.ep-codigo      = p-ep-codigo and
                                   conta-contab.conta-contabil = GetEntryField(1, tt-cria-{&TableName}.char-2, ";")) = no
                or GetEntryField(1, tt-cria-{&TableName}.char-2, ";") = "" then do:
                    {method/svc/errors/inserr.i
                                &ErrorNumber="1883"
                                &ErrorType="EMS"
                                &ErrorParameters="''"}
                end.
            end.

        &ENDIF

        if v-funcao-pre-pagto then do:

            /* Proj. 82 - Unificaá∆o de Conceitos
             * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
            &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
                /*Conta Cont†bil do PrÇ-Pagamento*/
                if can-find (first conta-contab where
                                   conta-contab.ep-codigo      = p-ep-codigo and
                                   conta-contab.conta-contabil = GetEntryField(5, tt-cria-{&TableName}.char-2, ";")) = no
                or GetEntryField(5, tt-cria-{&TableName}.char-2, ";") = "" then do:
                    {method/svc/errors/inserr.i
                                &ErrorNumber="1883"
                                &ErrorType="EMS"
                                &ErrorParameters="''"}
                end.
            &ENDIF

            /*EspÇcie PrÇ-Pagamento*/
            if can-find (first espec-ap where
                               espec-ap.cod-esp = GetEntryField(2, tt-cria-{&TableName}.char-2, ";")) = no
            or GetEntryField(2, tt-cria-{&TableName}.char-2, ";") = "" then
                {method/svc/errors/inserr.i
                            &ErrorNumber="25914"
                            &ErrorType="EMS"
                            &ErrorParameters="''"}

            if can-find (first espec-ap where
                               espec-ap.cod-esp  = GetEntryField(2, tt-cria-{&TableName}.char-2, ";") and
                               espec-ap.tipo    <> 1) = yes then do:
                {utp/ut-liter.i Normal * }
                {method/svc/errors/inserr.i
                            &ErrorNumber="144"
                            &ErrorType="EMS"
                            &ErrorParameters=return-value}
            end.

            /*SÇrie PrÇ-Pagamento*/   
            if can-find (first serie where
                               serie.serie = GetEntryField(3, tt-cria-{&TableName}.char-2, ";")) = no then
                {method/svc/errors/inserr.i
                            &ErrorNumber="25916"
                            &ErrorType="EMS"
                            &ErrorParameters="''"}

            /*Tipo Despesa PrÇ-Pagamento*/    
            if can-find (first tipo-rec-desp where
                               tipo-rec-desp.tp-codigo = integer(GetEntryField(4, tt-cria-{&TableName}.char-2, ";"))) = no
            or integer(GetEntryField(4, tt-cria-{&TableName}.char-2, ";")) = 0 then
                {method/svc/errors/inserr.i
                            &ErrorNumber="3299"
                            &ErrorType="EMS"
                            &ErrorParameters="''"}

            if can-find (first tipo-rec-desp where
                               tipo-rec-desp.tp-codigo = integer(GetEntryField(4, tt-cria-{&TableName}.char-2, ";")) and
                               tipo-rec-desp.tipo     <> 2) = yes then
                {method/svc/errors/inserr.i
                            &ErrorNumber="25049"
                            &ErrorType="EMS"
                            &ErrorParameters="''"}
        end.

        /* Proj. 82 - Unificaá∆o de Conceitos
         * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
        &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
            /*Transitoria Cancelamento*/    
            if l-funcao-cta-cancel then do:
                if can-find (first conta-contab where
                                   conta-contab.ep-codigo      = p-ep-codigo and
                                   conta-contab.conta-contabil = GetEntryField(7, tt-cria-{&TableName}.char-2, ";")) = no
                or GetEntryField(7, tt-cria-{&TableName}.char-2, ";") = "" then do:
                    {method/svc/errors/inserr.i
                                &ErrorNumber="1883"
                                &ErrorType="EMS"
                                &ErrorParameters="''"}
                end.
            end.
        &ENDIF

    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
        
        end.

    &ENDIF

    if l-funcao-pgto-juros-sdesemb then do:
        
        /* EspÇcie */
        if GetEntryField(14, tt-cria-{&TableName}.char-2, ";") <> "" then do:
            if can-find (first espec-ap where
                               espec-ap.cod-esp = GetEntryField(14, tt-cria-{&TableName}.char-2, ";")) = no then
                {method/svc/errors/inserr.i
                            &ErrorNumber="25914"
                            &ErrorType="EMS"
                            &ErrorParameters="''"}

            if can-find (first espec-ap where
                               espec-ap.cod-esp  = GetEntryField(14, tt-cria-{&TableName}.char-2, ";") and
                               espec-ap.tipo    <> 1) = yes then do:
                {utp/ut-liter.i Normal * }
                {method/svc/errors/inserr.i
                            &ErrorNumber="144"
                            &ErrorType="EMS"
                            &ErrorParameters=return-value}
            end.              
        end.

        /* Despesa */
        if tt-cria-{&TableName}.tp-codigo-antec-ap <> 0 then do:
            if can-find (first tipo-rec-desp where
                               tipo-rec-desp.tp-codigo = tt-cria-{&TableName}.tp-codigo-antec-ap) = no then
                {method/svc/errors/inserr.i
                            &ErrorNumber="3299"
                            &ErrorType="EMS"
                            &ErrorParameters="''"}

            if can-find (first tipo-rec-desp where
                               tipo-rec-desp.tp-codigo  = tt-cria-{&TableName}.tp-codigo-antec-ap and
                               tipo-rec-desp.tipo      <> 2) = yes then
                {method/svc/errors/inserr.i
                            &ErrorNumber="25049"
                            &ErrorType="EMS"
                            &ErrorParameters="''"}
        end.

        /* Proj. 82 - Unificaá∆o de Conceitos
         * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
        &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
            
            /*Conta Cont†bil*/
            if GetEntryField(17, tt-cria-{&TableName}.char-2, ";") <> "" then do:
                if can-find (first conta-contab where
                                   conta-contab.ep-codigo      = p-ep-codigo and
                                   conta-contab.conta-contabil = GetEntryField(17, tt-cria-{&TableName}.char-2, ";")) = no then
                    {method/svc/errors/inserr.i
                                &ErrorNumber="1883"
                                &ErrorType="EMS"
                                &ErrorParameters="''"}
            end.
        &ENDIF
    end.

    if l-funcao-devolucao then
        run pi-validar-devolucao in this-procedure (input tt-cria-{&TableName}.cod-ser-devol,
                                                    input tt-cria-{&TableName}.cod-esp-devol,
                                                    input tt-cria-{&TableName}.idi-tip-recta-cr-devol,
                                                    /* Proj. 82 - Unificaá∆o de Conceitos
                                                     * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto */
                                                    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
                                                        input tt-cria-{&TableName}.cod-cta-ctbl-devol
                                                    &ELSE
                                                        input tt-cria-{&TableName}.cod-cta-ctbl-devolv,
                                                        input tt-cria-{&TableName}.cod-ccusto-devolv,
                                                        input GetEntryField(2, tt-cria-{&TableName}.char-1, ";")
                                                    &ENDIF).

    /* Proj. 82 - Unificaá∆o de Conceitos
     * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto
     * Validaá‰es de Conta e CCusto */
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN

        run pi-validar-conta-ccusto in this-procedure (input tt-cria-{&TableName}.cod-cta-ctbl-represen,
                                                       input tt-cria-{&TableName}.cod-ccusto-represen,        
                                                       input tt-cria-{&TableName}.cod-cta-ctbl-trans-bxa-abat,
                                                       input tt-cria-{&TableName}.cod-ccusto-trans-bxa-abat,  
                                                       input tt-cria-{&TableName}.cod-cta-ctbl-ajust,         
                                                       input tt-cria-{&TableName}.cod-ccusto-ajust,           
                                                       input tt-cria-{&TableName}.cod-cta-ctbl-cancel,        
                                                       input tt-cria-{&TableName}.cod-ccusto-cancel,          
                                                       input tt-cria-{&TableName}.cod-cta-ctbl-pre-pagto,     
                                                       input tt-cria-{&TableName}.cod-ccusto-pre-pagto,       
                                                       input tt-cria-{&TableName}.cod-cta-ctbl-desemb,        
                                                       input tt-cria-{&TableName}.cod-ccusto-desemb).

        run pi-validar-unidade-negocio in this-procedure (&IF "{&mgadm_version}":U >= "2.09":U &THEN
                                                              input tt-cria-{&TableName}.cod-unid-negoc-cancel,
                                                              input tt-cria-{&TableName}.cod-unid-negoc-arbit,
                                                              input tt-cria-{&TableName}.cod-unid-negoc-desemb,
                                                              input tt-cria-{&TableName}.cod-unid-negoc-pre-pagto
                                                          &ELSE
                                                              input GetEntryField(3, tt-cria-{&TableName}.char-1, ";"),
                                                              input GetEntryField(4, tt-cria-{&TableName}.char-1, ";"),
                                                              input GetEntryField(5, tt-cria-{&TableName}.char-1, ";"),
                                                              input GetEntryField(6, tt-cria-{&TableName}.char-1, ";")
                                                          &ENDIF).
    &ENDIF

    /*--- Verifica ocorrencia de erros ---*/
    if can-find(first RowErrors where RowErrors.ErrorSubType = "ERROR":U) then
        return "NOK":U.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validar-unidade-negocio DBOProgram 
PROCEDURE pi-validar-unidade-negocio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Proj. 82 - Unificaá∆o de Conceitos
     * Alteraá∆o Conta Cont†bil e inclus∆o do CCusto
     * Validaá‰es de Unidade de Neg¢cio */
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN

        def input param p-cod-unid-negoc-cancel    as char no-undo.
        def input param p-cod-unid-negoc-arbit     as char no-undo.
        def input param p-cod-unid-negoc-desemb    as char no-undo.
        def input param p-cod-unid-negoc-pre-pagto as char no-undo.

        /* Persiste a DBO na mem¢ria */
        run prgint/utb/utb936wa.py persistent set h-bo-unid-negoc.

        /***** Valida Unidade de Neg¢cio de PrÇ-pagamento *****/
        run pi_vld_info_unid_negoc in h-bo-unid-negoc (input p-cod-unid-negoc-pre-pagto,
                                                       output table tt_log_erro).
        run pi-inserir-erros-tt (input-output table tt_log_erro,
                                 input 4).

        /***** Valida Unidade de Neg¢cio de Arbitragem *****/
        if p-cod-unid-negoc-arbit <> "" then do:
            run pi_vld_info_unid_negoc in h-bo-unid-negoc (input p-cod-unid-negoc-arbit,
                                                           output table tt_log_erro).
            run pi-inserir-erros-tt (input-output table tt_log_erro,
                                     input 5).
        end.

        /***** Valida Unidade de Neg¢cio de Desembolso *****/
        if p-cod-unid-negoc-desemb <> "" then do:
            run pi_vld_info_unid_negoc in h-bo-unid-negoc (input p-cod-unid-negoc-desemb,
                                                           output table tt_log_erro).
            run pi-inserir-erros-tt (input-output table tt_log_erro,
                                     input 6).
        end.

        /* Elimina o handle da DBO */
        if valid-handle(h-bo-unid-negoc) then
            delete procedure h-bo-unid-negoc.

    &ENDIF
    
    return "OK".

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
    
    def input param pType as char no-undo.

    def var i-ep-codigo like param-mec.ep-codigo no-undo.

    run pi-autenticacao (output i-ep-codigo).

    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/

    if can-find (first espec-ap 
                 where espec-ap.cod-esp           = RowObject.cod-esp-antec-ap) = no
                    or RowObject.cod-esp-antec-ap = "" then
        {method/svc/errors/inserr.i
                    &ErrorNumber="25914"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    if can-find (first espec-ap 
                 where espec-ap.cod-esp  = RowObject.cod-esp-antec-ap
                   and espec-ap.tipo    <> 2) = yes then
        {method/svc/errors/inserr.i
                    &ErrorNumber="25915"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    if can-find (first serie 
                 where serie.serie = RowObject.serie-antec-ap) = no then
        {method/svc/errors/inserr.i
                    &ErrorNumber="25916"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    if can-find (first tipo-rec-desp 
                 where tipo-rec-desp.tp-codigo = RowObject.tp-codigo-antec-ap) = no
                    or RowObject.tp-codigo-antec-ap = 0 then
        {method/svc/errors/inserr.i
                    &ErrorNumber="3299"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    if can-find (first tipo-rec-desp
                 where tipo-rec-desp.tp-codigo  = RowObject.tp-codigo-antec-ap
                   and tipo-rec-desp.tipo      <> 2) = yes then
        {method/svc/errors/inserr.i
                    &ErrorNumber="25049"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    if can-find (first esp-doc
                 where esp-doc.cod-esp            = RowObject.cod-esp-antec-cr) = no
                    or RowObject.cod-esp-antec-cr = "" then
        {method/svc/errors/inserr.i
                    &ErrorNumber="25917"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    if can-find (first esp-doc 
                 where esp-doc.cod-esp  = RowObject.cod-esp-antec-cr
                   and  esp-doc.tipo   <> 2) = yes then
        {method/svc/errors/inserr.i
                    &ErrorNumber="25918"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    if can-find (first serie
                 where serie.serie = RowObject.serie-antec-cr) = no then
        {method/svc/errors/inserr.i
                    &ErrorNumber="25919"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    if can-find (first tipo-rec-desp where tipo-rec-desp.tp-codigo = RowObject.tp-codigo-antec-cr) = no or
       RowObject.tp-codigo-antec-cr = 0 then
        {method/svc/errors/inserr.i
                   &ErrorNumber="3299"
                   &ErrorType="EMS"
                   &ErrorParameters="''"}

    &IF DEFINED(BF_FIN_MEC_FUT_CFL2) &THEN
        if l-funcao-recta-cambio-fut then do:
            if can-find (first tipo-rec-desp
                         where tipo-rec-desp.tp-codigo            = RowObject.idi-tip-recta-cambio-fut) = no
                            or RowObject.idi-tip-recta-cambio-fut = 0 then
                {method/svc/errors/inserr.i
                            &ErrorNumber="3299"
                            &ErrorType="EMS"
                            &ErrorParameters="''"}
        end.
    &ENDIF

    if can-find (first tipo-rec-desp
                 where tipo-rec-desp.tp-codigo  = RowObject.tp-codigo-antec-cr
                   and tipo-rec-desp.tipo      <> 1) = yes then
        {method/svc/errors/inserr.i
                    &ErrorNumber="25050"
                    &ErrorType="EMS"
                    &ErrorParameters="''"}

    &IF DEFINED(BF_FIN_MEC_FUT_CFL2) &THEN
        if l-funcao-recta-cambio-fut then do:
            if can-find (first tipo-rec-desp
                         where tipo-rec-desp.tp-codigo  = RowObject.idi-tip-recta-cambio-fut
                           and tipo-rec-desp.tipo      <> 1) = yes then
                {method/svc/errors/inserr.i
                            &ErrorNumber="25050"
                            &ErrorType="EMS"
                            &ErrorParameters="''"}
        end.
    &ENDIF

    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN

        find first integr-mec-modul-funcao no-lock
             where integr-mec-modul-funcao.cod-modul-integr  = "MEC"          and
                   integr-mec-modul-funcao.ind-funcao-integr = "Aplica_Empre" and
                   &IF "{&mguni_version}" >= "2.07A" &THEN
                   integr-mec-modul-funcao.cod-empresa       = ""             and
                   &ELSE
                   integr-mec-modul-funcao.cod-empresa       = 0              and
                   &ENDIF
                   integr-mec-modul-funcao.cod-estab         = ""             and         
                   integr-mec-modul-funcao.cod-produt-modul  = "EMS 5"        no-error.
        if avail integr-mec-modul-funcao then do:

            if can-find (first conta-contab 
                         where conta-contab.ep-codigo      = i-ep-codigo
                           and conta-contab.conta-contabil = RowObject.conta-baixa-ace) = no
                            or RowObject.conta-baixa-ace   = "" then do:
                {method/svc/errors/inserr.i
                            &ErrorNumber="1883"
                            &ErrorType="EMS"
                            &ErrorParameters="''"}
            end.
        end.

    &ENDIF

    /*--- Verifica ocorrància de erros ---*/
    if can-find(first RowErrors where RowErrors.ErrorSubType = "ERROR":U) then
        return "NOK":U.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetEntryField DBOProgram 
FUNCTION GetEntryField returns character
                  (input p_num_posicao    as integer,
                   input p_cod_campo      as character,
                   input p_cod_separador  as character):

/* ************* Parametros da FUNÄ«O *******************************
** Funá∆o para tratamento dos Entries dos c¢digos livres
** 
**  p_num_posicao     - N£mero do Entry que ser† atualizado
**  p_cod_campo       - Campo / Vari†vel que ser† atualizada
**  p_cod_separador   - Separador que ser† utilizado
*******************************************************************/

    if  p_num_posicao <= 0  then do:
        assign p_num_posicao  = 1.
    end.
    if num-entries(p_cod_campo,p_cod_separador) >= p_num_posicao  then do:
       return entry(p_num_posicao,p_cod_campo,p_cod_separador).
    end.

    RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION SetEntryField DBOProgram 
FUNCTION SetEntryField returns character
                  (input p_num_posicao     as integer,
                   input p_cod_campo       as character,
                   input p_cod_separador   as character,
                   input p_cod_valor       as character):

/* ************* Parametros da FUNÄ«O *******************************
** Funá∆o para tratamento dos Entries dos c¢digos livres
** 
**  p_num_posicao     - N£mero do Entry / Posiá∆o que ser† atualizado
**  p_cod_campo       - Campo / Vari†vel que ser† atualizada
**  p_cod_separador   - Separador que ser† utilizado
**  p_cod_valor       - Valor que ser† atualizado no Entry passado 
*******************************************************************/

    def var v_num_cont        as integer initial 0 no-undo.
    def var v_num_entries_ini as integer initial 0 no-undo.

    /* ** No progress a menor Entry Ç 1 ***/
    if p_num_posicao <= 0 then 
       assign p_num_posicao = 1.       

    /* ** Caso o Campo contenha um valor inv†lido, este valor ser† convertido para Branco
         para possibilitar os c†lculo ***/
    if p_cod_campo = ? then do:
       assign p_cod_campo = "" /* l_*/ .
    end.

    assign v_num_entries_ini = num-entries(p_cod_campo,p_cod_separador) + 1 .    
    if p_cod_campo = "" /* l_*/  then do:
       assign v_num_entries_ini = 2.
    end.

    do v_num_cont =  v_num_entries_ini to p_num_posicao :
       assign p_cod_campo = p_cod_campo + p_cod_separador.
    end.

    assign entry(p_num_posicao,p_cod_campo,p_cod_separador) = p_cod_valor.

    RETURN p_cod_campo.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

