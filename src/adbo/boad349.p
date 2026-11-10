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
{include/i-prgvrs.i BOAD349 2.00.00.009 } /*** "010009" 28/11/2023 08:46:37 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad349 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : boad349.p
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
&GLOBAL-DEFINE DBOName              BOAD349
&GLOBAL-DEFINE DBOVersion           1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName            contr-despesa-exp
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName            qr{&TableName} 

{cdp/cdcfgfin.i}

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{adbo/boad349.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/** Define TT Integraá∆o Cxa. Bancos EMS5 **/
{cdp/cd1202.i2}
{cdp/cdapi533a.i}

def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

def var p-contabilizou   as   logical                        no-undo.
def var c-nr-docto-banco as   char                           no-undo.
def var c-conta-contabil as   char                           no-undo.
def var i-cod-lancto     as   int                            no-undo.
def var i-tp-desp-rec    as   int                            no-undo.
def var i-ep-codigo      like contr-titulo-exp.ep-codigo     no-undo.
def var c-cod-estabel    like contr-titulo-exp.cod-estabel   no-undo.
def var c-referencia     like contr-titulo-exp.referencia    no-undo.
def var d-dt-referencia  like contr-titulo-exp.dt-referencia no-undo.
def var i-seq-erro       as   integer                        no-undo.
DEF VAR p-num-id         AS   INTEGER                        NO-UNDO.
DEF VAR v-num-id-desp    AS   INTEGER                        NO-UNDO.

def var l-funcao-melhoria-desp as LOG      no-undo.

def var h-bo-cta-corren   as handle no-undo.
def var h-bo-tip-trans-cx as handle no-undo.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer   format ">>>>,>>9" label "N£mero"         column-label "N£mero"
    field ttv_des_msg_ajuda as character format "x(40)"    label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)"    label "Mensagem Erro"  column-label "Inconsistància"
    .

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

{include/getdefinedfunction.i}
assign l-funcao-melhoria-desp  = &if defined(BF-FIN-INFORM-DESPES) &then yes &else GetDefinedFunction("SPP-INFORM-DESPES") &endif.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualiza_query DBOProgram 
PROCEDURE atualiza_query :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    if  avail contr-despesa-exp then do:
        RUN repositionRecord IN this-procedure (ROWID(contr-despesa-exp)).
        GET CURRENT qrcontr-despesa-exp EXCLUSIVE-LOCK NO-WAIT.
    end.
    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeCreateRecord DBOProgram 
PROCEDURE BeforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    find last contr-despesa-exp where contr-despesa-exp.ep-codigo     = RowObject.ep-codigo
                                  and contr-despesa-exp.cod-estabel   = RowObject.cod-estabel
                                  and contr-despesa-exp.referencia    = RowObject.referencia
                                  and contr-despesa-exp.dt-referencia = RowObject.dt-referencia no-lock no-error.
    if avail contr-despesa-exp then do:
       assign RowObject.sequencia = contr-despesa-exp.sequencia + 10.
    end.
    else assign RowObject.sequencia = 10.

    assign p-num-id = 0.

    find contrato-exp
         where contrato-exp.ep-codigo     = RowObject.ep-codigo
         and   contrato-exp.cod-estabel   = RowObject.cod-estabel
         and   contrato-exp.referencia    = RowObject.referencia
         and   contrato-exp.dt-referencia = RowObject.dt-referencia exclusive-lock no-error.
    if avail contrato-exp then do:

        /* Verificar se ja existe o num-id agrupado
           Ex. contrato-exp com num-id 36  e sequencia da despesa 210 = 36210
               contrato-exp com num-id 362 e sequencia da despesa  10 = 36210 */
        verifica_despesa:
        repeat:
            assign v-num-id-desp = integer(string(string(contrato-exp.num-id-contrato-exp) + string(RowObject.sequencia))).
            find first contr-despesa-exp
                 where contr-despesa-exp.int-1 = v-num-id-desp no-lock no-error.
            if avail contr-despesa-exp then
                assign RowObject.sequencia = RowObject.sequencia + 10.
            else
                leave verifica_despesa.
        end. 

        assign p-num-id = integer(string(string(contrato-exp.num-id-contrato-exp) + string(RowObject.sequencia))).
    
        assign RowObject.nr-contrato = contrato-exp.nr-contrato
               RowObject.int-1       = p-num-id.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeDeleteRecord DBOProgram 
PROCEDURE BeforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
    def var h-boad341    as handle no-undo.
    def var p-portador   as int    no-undo.  
    def var p-modalidade as int    no-undo.

    assign i-seq-erro = 0.
    for each RowErrors:
        delete RowErrors.
    end.

    {ecp/ec0003f.i}

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
        &IF "{&mguni_version}" >= "2.07A" &THEN 
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "agencia":U THEN ASSIGN pFieldValue = RowObject.agencia.
        WHEN "c-time":U THEN ASSIGN pFieldValue = RowObject.c-time.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-docto":U THEN ASSIGN pFieldValue = RowObject.cod-docto.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cta-corrente":U THEN ASSIGN pFieldValue = RowObject.cta-corrente.
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "nr-docto-emp":U THEN ASSIGN pFieldValue = RowObject.nr-docto-emp.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dt-contrato":U THEN ASSIGN pFieldValue = RowObject.dt-contrato.
        WHEN "dt-movto":U THEN ASSIGN pFieldValue = RowObject.dt-movto.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "valor-movto":U THEN ASSIGN pFieldValue = RowObject.valor-movto.
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
        WHEN "banco":U THEN ASSIGN pFieldValue = RowObject.banco.
        &IF "{&mguni_version}" < "2.07A" &THEN  
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
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
  Purpose:     Retorna valores dos campos do °ndice default
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE contr-despesa-exp.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE contr-despesa-exp.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER preferencia LIKE contr-despesa-exp.referencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-referencia LIKE contr-despesa-exp.dt-referencia NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE contr-despesa-exp.sequencia NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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
  Purpose:     Reposiciona registro com base no °ndice default
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE contr-despesa-exp.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE contr-despesa-exp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER preferencia LIKE contr-despesa-exp.referencia NO-UNDO.
    DEFINE INPUT PARAMETER pdt-referencia LIKE contr-despesa-exp.dt-referencia NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE contr-despesa-exp.sequencia NO-UNDO.

    FIND FIRST bfcontr-despesa-exp WHERE 
        bfcontr-despesa-exp.ep-codigo = pep-codigo AND 
        bfcontr-despesa-exp.cod-estabel = pcod-estabel AND 
        bfcontr-despesa-exp.referencia = preferencia AND 
        bfcontr-despesa-exp.dt-referencia = pdt-referencia AND 
        bfcontr-despesa-exp.sequencia = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcontr-despesa-exp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcontr-despesa-exp)).
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
                           
    run SetConstraintContratoExp in this-procedure (input i-ep-codigo,
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
        WHERE contr-despesa-exp.ep-codigo     = i-ep-codigo and
              contr-despesa-exp.cod-estabel   = c-cod-estabel  and 
              contr-despesa-exp.referencia    = c-referencia and 
              contr-despesa-exp.dt-referencia = d-dt-referencia.
        
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
    def var c-usuario like contr-despesa-exp.usuario.

    {method/svc/autentic/autentic.i
            &vUserName="c-usuario"}

    assign RowObject.usuario  = c-usuario
           RowObject.c-time   = string(TIME, "HH:MM")
           RowObject.dt-today = today.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-historico DBOProgram 
PROCEDURE pi-busca-historico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-banco      like movto-banco.banco        no-undo.
    def input  param p-agencia    like movto-banco.agencia      no-undo.
    def input  param p-conta      like movto-banco.cta-corrente no-undo.
    def input  param p-dt-movto   like movto-banco.dt-movto     no-undo.
    def input  param p-cod-lancto like movto-banco.cod-lancto   no-undo.
    def input  param p-acao       as   char                     no-undo.
    def output param p-historico  as   char                     no-undo.
    def output param p-habilita   as   logical init no          no-undo.

    find first hist-padrao where hist-padrao.hp-codigo = p-cod-lancto no-lock no-error.
    if avail hist-padrao then do:
        if  (hist-padrao.complemento) = 3 then
            assign p-habilita = NO.
        else
            assign p-habilita = YES.

        assign p-historico = hist-padrao.descricao.
    end.
    else
        assign p-historico = "".

    RETURN "OK":U.
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

    define variable i-seq-erro   as integer   no-undo.

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
               RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-valores DBOProgram 
PROCEDURE pi-recebe-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pnr-docto-banco like movto-banco.nr-docto-banco.
    def input param pconta-contabil like movto-banco.conta-contabil.
    def input param pcod-lancto     like movto-banco.cod-lancto.
    def input param ptp-desp-rec    like movto-banco.tp-desp-rec.
    
    assign c-nr-docto-banco = pnr-docto-banco
           c-conta-contabil = pconta-contabil 
           i-cod-lancto     = pcod-lancto
           i-tp-desp-rec    = ptp-desp-rec.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-vld-alt-movto-cb DBOProgram 
PROCEDURE pi-vld-alt-movto-cb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter i-banco          like contr-despesa-exp.banco         no-undo.
def input parameter c-agencia        like contr-despesa-exp.Agencia       no-undo.
def input parameter c-cta-cor        like contr-despesa-exp.cta-corrente  no-undo.
def input parameter c-cod-docto      like contr-despesa-exp.cod-docto     no-undo.
def input parameter c-nr-docto       like contr-despesa-exp.nr-docto-emp  no-undo.
def input parameter d-dt-movto       like contr-despesa-exp.dt-movto      no-undo.

def output parameter i-ep-codigo     like contr-despesa-exp.ep-codigo     no-undo.
def output parameter c-cod-estabel   like contr-despesa-exp.cod-estabel   no-undo.
def output parameter c-referencia    like contr-despesa-exp.referencia    no-undo.
def output parameter d-dt-referencia like contr-despesa-exp.dt-referencia no-undo.
def output parameter i-sequencia     like contr-despesa-exp.sequencia     no-undo.

assign &IF "{&mguni_version}" >= "2.07A" &THEN
       i-ep-codigo     = ""
       &ELSE
       i-ep-codigo     = 0
       &ENDIF
       c-cod-estabel   = " "
       c-referencia    = " "
       d-dt-referencia = ?
       i-sequencia     = 0.
       
find first contr-despesa-exp no-lock 
     where contr-despesa-exp.banco        = i-banco 
     and   contr-despesa-exp.agencia      = c-agencia
     and   contr-despesa-exp.cta-corrente = c-cta-cor
     and   contr-despesa-exp.cod-docto    = c-cod-docto 
     and   contr-despesa-exp.nr-docto-emp = c-nr-docto
     and   contr-despesa-exp.dt-movto     = d-dt-movto no-error.

    if avail contr-despesa-exp then 
       assign i-ep-codigo     = contr-despesa-exp.ep-codigo
              c-cod-estabel   = contr-despesa-exp.cod-estabel
              c-referencia    = contr-despesa-exp.referencia
              d-dt-referencia = contr-despesa-exp.dt-referencia
              i-sequencia     = contr-despesa-exp.sequencia.

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
    DEFINE INPUT PARAMETER pep-codigo     LIKE contr-despesa-exp.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel   LIKE contr-despesa-exp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER preferencia    LIKE contr-despesa-exp.referencia NO-UNDO.
    DEFINE INPUT PARAMETER pdt-referencia LIKE contr-despesa-exp.dt-referencia NO-UNDO.
    
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
    def var c-string1 as char no-undo.

    if ptype = "Create":U or ptype = "Update":U then do:
       run pi-autenticacao.

        find first contrato-exp no-lock
             where contrato-exp.ep-codigo     = RowObject.ep-codigo
             and   contrato-exp.cod-estabel   = RowObject.cod-estabel
             and   contrato-exp.referencia    = RowObject.referencia
             and   contrato-exp.dt-referencia = RowObject.dt-referencia no-error.
        if avail contrato-exp then do:

            if RowObject.dt-movto < contrato-exp.dt-referencia then do:
                {method/svc/errors/inserr.i
                            &ErrorNumber="26117"
                            &ErrorType="EMS"
                            &ErrorParameters="''"}
            end.
        end.
    end.

    if ptype="Create":U then do:
       {utp/ut-liter.i despesa *}
       assign c-string1 = return-value.

       if can-find (first contrato-exp where contrato-exp.ep-codigo     = RowObject.ep-codigo 
                                         and contrato-exp.cod-estabel   = RowObject.cod-estabel
                                         and contrato-exp.referencia    = RowObject.referencia
                                         and contrato-exp.dt-referencia = RowObject.dt-referencia) = no then
                                         {method/svc/errors/inserr.i
                                                     &ErrorNumber="19421"
                                                     &ErrorType="EMS"
                                                     &ErrorParameters="c-string1"}
                                                            
        if
            RowObject.cta-corrente         = "" or
            RowObject.dt-movto             = ?  or
            RowObject.valor-movto          = 0  or
            RowObject.nr-docto-emp         = "" or
            &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
                RowObject.cod-tip-trans-cx = "" or
            &ENDIF
            RowObject.cod-docto            = "" then
            {method/svc/errors/inserr.i &ErrorNumber="19350"
                                        &ErrorType="EMS"
                                        &ErrorParameters="''"}  /*TODOS OS DADOS DEVEM SER PREENCHIDOS*/

        &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
            run prgfin\cmg\cmg900wd.py persistent set h-bo-cta-corren.
            run pi_vld_info_cta_corren in h-bo-cta-corren (input RowObject.cta-corrente,
                                                           output table tt_log_erro).
            run pi-inserir-erros-tt (input-output table tt_log_erro).
            delete procedure h-bo-cta-corren.

            run prgfin\cmg\cmg900we.py persistent set h-bo-tip-trans-cx.
            run pi_vld_info_tip_trans_cx in h-bo-tip-trans-cx (input RowObject.cod-tip-trans-cx,
                                                               output table tt_log_erro).
            run pi-inserir-erros-tt (input-output table tt_log_erro).
            delete procedure h-bo-tip-trans-cx.
        &ELSE
            if can-find (cta-corrente where cta-corrente.cod-banco    = RowObject.banco
                                        and cta-corrente.agencia      = RowObject.agencia
                                        and cta-corrente.conta-corren = RowObject.cta-corrente) = no then
                {method/svc/errors/inserr.i &ErrorNumber="42"
                                            &ErrorType="EMS"
                                            &ErrorParameters="''"}
        &ENDIF

    end.

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

