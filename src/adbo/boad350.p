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
{include/i-prgvrs.i BOAD350 2.00.00.036 } /*** "010036" 10/06/2025 09:30:38 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boad350 MUT}
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
&GLOBAL-DEFINE DBOName              BOAD350
&GLOBAL-DEFINE DBOVersion           1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName            contr-emprestimo
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName            qr{&TableName} 


/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{adbo/boad350.i RowObject}


/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var i-ep-codigo     like contr-emprestimo.ep-codigo     no-undo.
def var c-cod-estabel   like contr-emprestimo.cod-estabel   no-undo.
def var c-referencia    like contr-emprestimo.referencia    no-undo.
def var d-dt-referencia like contr-emprestimo.dt-referencia no-undo.
def var c-ep-codigo     like contr-emprestimo.ep-codigo     no-undo.
def var i-seq-erro      as   integer                        no-undo.
def var h-acr788za      as   handle                         no-undo.
def var h-apl768zd      as   handle                         no-undo.
def var h-boad357       as   handle                         no-undo.
def var h-boad049       as   handle                         no-undo.

def new global shared var v_cod_empres_usuar as character format "x(03)" no-undo.
def new global shared var v_cod_usuar_corren as character format "x(12)" no-undo.
def var v_cod_empres_usuar_old as character format "x(3)"  no-undo.
def var v_cod_empres_usuar_old2 as character format "x(3)"  no-undo.
def var v_cod_usuar_corren_old as character format "x(12)" no-undo.
def var v-num-id-operac-financ like contr-emprestimo.num-id-operac-financ. 
DEF VAR l-funcao-pgto-juros-sdesemb   AS LOG NO-UNDO.
DEF VAR l-funcao-recta-cambio-fut AS LOG INITIAL NO NO-UNDO.

{ecp/ec0005c.i}  /* Definicoes para conexao EMS 5 */

/*** Defini‡Æo da tt_operac_financ_cambio_1 ***/
{ecp/ec0005j.i}

def temp-table tt_rateio_valores no-undo
    field tta_cod_plano_cta_ctbl   as char format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl         as char format "x(20)" label "Conta Contabil" column-label "Conta Cont˜bil"
    field tta_cod_tip_fluxo_financ as char format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field ttv_val_rat_aprop_ctbl   as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Valor Aprop Ctbl" column-label "Valor Aprop Ctbl"
    index tt_chave                 is primary unique
          tta_cod_plano_cta_ctbl   ascending
          tta_cod_cta_ctbl         ascending.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer   format ">>>>,>>9" label "N£mero"         column-label "N£mero"
    field ttv_des_msg_ajuda as character format "x(40)"    label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)"    label "Mensagem Erro"  column-label "Inconsistˆncia".

/* Defini‡Æo de Temp-Tables */
def temp-table tt_xml_input_output no-undo
    field ttv_cod_label as char format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo as char format "x(40)" label "Texto" column-label "Texto"
    field ttv_des_conteudo_aux as char format "x(40)"
    field ttv_num_seq_1 as int format ">>>,>>9"
    .
def temp-table tt_log_erros no-undo
    field ttv_num_seq as int format ">>>,>>9" label "Sequˆncia" column-label "Seq"
    field ttv_num_cod_erro as int format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_erro as char format "x(50)" label "Inconsistˆncia" column-label "Inconsistˆncia"
    field ttv_des_ajuda as char format "x(50)" label "Ajuda" column-label "Ajuda"
    .

/**** Miniflexibilizacao ****/
{cdp/cdcfgfin.i}

/*** Verificar se a fun‡Æo especial est ÿ habilitada ***/
{include/getdefinedfunction.i}
assign l-funcao-pgto-juros-sdesemb  = &if defined(BF_FIN_PAGTO_JUROS_SEM_DESEMB) &then yes &else GetDefinedFunction("SPP-PGTO-JUROS-SEM-DESEMB") &endif.
/* esta variavel verificar  se a fun‡Æo Destina‡Æo est  habilitada para que possa ser utilizada a fun‡Æo de Cambio Futuro */
ASSIGN l-funcao-recta-cambio-fut = &if defined(BF_FIN_DESTINACAO) &then YES &else GetDefinedFunction("SPP-DESTINACAO") &endif.

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
         HEIGHT             = 12.42
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
    find last contr-emprestimo 
        where contr-emprestimo.ep-codigo      = RowObject.ep-codigo
        and   contr-emprestimo.cod-estabel    = RowObject.cod-estabel
        and   contr-emprestimo.referencia     = RowObject.referencia
        and   contr-emprestimo.dt-referencia  = RowObject.dt-referencia
        and   contr-emprestimo.cod-banco-ems5 = RowObject.cod-banco-ems5
        and   contr-emprestimo.prod-financ    = RowObject.prod-financ
        and   contr-emprestimo.operac-financ  = RowObject.operac-financ no-lock no-error.
    if avail contr-emprestimo then
        assign RowObject.sequencia = contr-emprestimo.sequencia + 10.
    else
        assign RowObject.sequencia = 10.

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
        WHEN "cod-banco-ems5":U THEN ASSIGN pFieldValue = RowObject.cod-banco-ems5.
        WHEN "cod-banco-ems5-d":U THEN ASSIGN pFieldValue = RowObject.cod-banco-ems5-d.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "operac-financ":U THEN ASSIGN pFieldValue = RowObject.operac-financ.
        WHEN "operac-financ-d":U THEN ASSIGN pFieldValue = RowObject.operac-financ-d.
        WHEN "prod-financ":U THEN ASSIGN pFieldValue = RowObject.prod-financ.
        WHEN "prod-financ-d":U THEN ASSIGN pFieldValue = RowObject.prod-financ-d.
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
        WHEN "dt-contrato":U THEN ASSIGN pFieldValue = RowObject.dt-contrato.
        WHEN "dt-referencia":U THEN ASSIGN pFieldValue = RowObject.dt-referencia.
        WHEN "dt-today":U THEN ASSIGN pFieldValue = RowObject.dt-today.
        WHEN "dt-transacao":U THEN ASSIGN pFieldValue = RowObject.dt-transacao.
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
        WHEN "num-id-operac-financ":U THEN ASSIGN pFieldValue = RowObject.num-id-operac-financ.
        WHEN "num-id-operac-financ-d":U THEN ASSIGN pFieldValue = RowObject.num-id-operac-financ-d.
        WHEN "num-seq-movto-operac-financ":U THEN ASSIGN pFieldValue = RowObject.num-seq-movto-operac-financ.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "transacao":U THEN ASSIGN pFieldValue = RowObject.transacao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice contr-empr
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo referencia
               retorna valor do campo dt-referencia
               retorna valor do campo cod-banco-ems5
               retorna valor do campo prod-financ
               retorna valor do campo operac-financ
               retorna valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE contr-emprestimo.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE contr-emprestimo.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER preferencia LIKE contr-emprestimo.referencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-referencia LIKE contr-emprestimo.dt-referencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-banco-ems5 LIKE contr-emprestimo.cod-banco-ems5 NO-UNDO.
    DEFINE OUTPUT PARAMETER pprod-financ LIKE contr-emprestimo.prod-financ NO-UNDO.
    DEFINE OUTPUT PARAMETER poperac-financ LIKE contr-emprestimo.operac-financ NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE contr-emprestimo.sequencia NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-estabel = RowObject.cod-estabel
           preferencia = RowObject.referencia
           pdt-referencia = RowObject.dt-referencia
           pcod-banco-ems5 = RowObject.cod-banco-ems5
           pprod-financ = RowObject.prod-financ
           poperac-financ = RowObject.operac-financ
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
  Purpose:     Reposiciona registro com base no ¡ndice contr-empr
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo referencia
               recebe valor do campo dt-referencia
               recebe valor do campo cod-banco-ems5
               recebe valor do campo prod-financ
               recebe valor do campo operac-financ
               recebe valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE contr-emprestimo.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE contr-emprestimo.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER preferencia LIKE contr-emprestimo.referencia NO-UNDO.
    DEFINE INPUT PARAMETER pdt-referencia LIKE contr-emprestimo.dt-referencia NO-UNDO.
    DEFINE INPUT PARAMETER pcod-banco-ems5 LIKE contr-emprestimo.cod-banco-ems5 NO-UNDO.
    DEFINE INPUT PARAMETER pprod-financ LIKE contr-emprestimo.prod-financ NO-UNDO.
    DEFINE INPUT PARAMETER poperac-financ LIKE contr-emprestimo.operac-financ NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE contr-emprestimo.sequencia NO-UNDO.

    FIND FIRST bfcontr-emprestimo WHERE 
        bfcontr-emprestimo.ep-codigo = pep-codigo AND 
        bfcontr-emprestimo.cod-estabel = pcod-estabel AND 
        bfcontr-emprestimo.referencia = preferencia AND 
        bfcontr-emprestimo.dt-referencia = pdt-referencia AND 
        bfcontr-emprestimo.cod-banco-ems5 = pcod-banco-ems5 AND 
        bfcontr-emprestimo.prod-financ = pprod-financ AND 
        bfcontr-emprestimo.operac-financ = poperac-financ AND 
        bfcontr-emprestimo.sequencia = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcontr-emprestimo THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcontr-emprestimo)).
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
        WHERE contr-emprestimo.ep-codigo     = i-ep-codigo     and
              contr-emprestimo.cod-estabel   = c-cod-estabel   and 
              contr-emprestimo.referencia    = c-referencia    and 
              contr-emprestimo.dt-referencia = d-dt-referencia and
              contr-emprestimo.transacao     = 4.
        
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
    def var c-usuario like contr-emprestimo.usuario.

    {method/svc/autentic/autentic.i
            &vUserName="c-usuario"}

    assign RowObject.usuario  = c-usuario
           RowObject.c-time   = string(TIME, "HH:MM")
           RowObject.dt-today = today.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cancela-ava DBOProgram 
PROCEDURE pi-cancela-ava :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  ATENCAO! ATENCAO! ATENCAO! ATENCAO!
          O conte£do desta pi foi replicado para pi-cancela-ava-ems5 
          atendendo a necessidade da funcao "integr. MEC ems2 X Financeiro EMS5".
-----------------------------------------------------------------------------*/
    def input  param p-ep-codigo              like contr-emprestimo.ep-codigo.
    def input  param p-cod-estabel            like contr-emprestimo.cod-estabel. 
    def input  param p-referencia             like contr-emprestimo.referencia.
    def input  param p-dt-referencia          like contr-emprestimo.dt-referencia. 
    def input  param p-num-id-mov-tit         like contr-emprestimo.int-1.
    def output param p-nr-msgs                as   integer.
    def output param p_num_msg                as integer format ">>>>,>>9" no-undo.

    ASSIGN c-ep-codigo = p-ep-codigo
           p-nr-msgs   = 0
           p_num_msg   = 0.

    find first contr-emprestimo exclusive-lock
         where contr-emprestimo.ep-codigo     = p-ep-codigo
         and   contr-emprestimo.cod-estabel   = p-cod-estabel
         and   contr-emprestimo.referencia    = p-referencia
         and   contr-emprestimo.dt-referencia = p-dt-referencia
         and   contr-emprestimo.int-1         = p-num-id-mov-tit
         no-error.
    if avail contr-emprestimo then do:
        /* Conecta Bases EMS 5 */
        {ecp/ec0005b.i 1}
                
        /*** Verifica Erro na ConexÆo das Bases ***/
        {ecp/ec0005k.i}
    
        if i-seq-erro <> 0 then
            RETURN "NOK":U.

        &IF "{&mguni_version}" <= "2.06B" &THEN
        assign v_cod_usuar_corren_old = v_cod_usuar_corren 
               v_cod_empres_usuar_old = v_cod_empres_usuar
               v_cod_usuar_corren     = ""
               v_cod_empres_usuar     = "".
    
        /*** chama login do usuario ***/
        run prgtec/btb/btb906za.py.
        
        if v_cod_usuar_corren = "" or 
           v_cod_empres_usuar = "" then do:
            assign v_cod_usuar_corren = v_cod_usuar_corren_old 
                   v_cod_empres_usuar = v_cod_empres_usuar_old.
           return "NOK":U.
        end.
        &ENDIF

        run prgfin/acr/acr788za.py persistent set h-acr788za.

        run pi_verifica_pagamento_juros_cambio in h-acr788za (input contr-emprestimo.num-seq-movto-operac-financ,
                                                              output p_num_msg).
        delete procedure h-acr788za.
    
        run prgfin/apl/apl007zu.py (INPUT  1,
                                    input  "Cancelamento",
                                    input  "Movimento",
                                    input  contr-emprestimo.num-id-operac-financ,
                                    input  contr-emprestimo.num-seq-movto-operac-financ,
                                    input  "",
                                    output table tt_log_erro).
    
        /*** Desconecta bases do EMS 5.0 ***/
        {ecp/ec0005b.i 2}

        find first tt_log_erro no-lock no-error.
        if avail tt_log_erro then do:
            if tt_log_erro.ttv_num_cod_erro = 9101 then
                assign p-nr-msgs = 26498.

            if tt_log_erro.ttv_num_cod_erro = 9907 then
                assign p-nr-msgs = 26499.

            if tt_log_erro.ttv_num_cod_erro <> 9101 and 
               tt_log_erro.ttv_num_cod_erro <> 9907 then
                assign p-nr-msgs = 26512.
        end.

        delete contr-emprestimo.
    end.
    
    &IF "{&mguni_version}" <= "2.06B" &THEN
    assign v_cod_usuar_corren = v_cod_usuar_corren_old 
           v_cod_empres_usuar = v_cod_empres_usuar_old.
    &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cancela-ava-ems5 DBOProgram 
PROCEDURE pi-cancela-ava-ems5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       ATENCAO! ATENCAO! ATENCAO! ATENCAO!
               Esta pi foi replicada da pi-cancela-ava para atender a necessidade
               da funcao "integr. MEC ems2 X Financeiro EMS5", sendo utilizado
               no ACR ao estornar AVA a menor.
               
               Foi alterado para estornar movimento no APL para que fique como hist¢rico
               
------------------------------------------------------------------------------*/
    def input  param p-ep-codigo              like contr-emprestimo.ep-codigo.
    def input  param p-cod-estabel            like contr-emprestimo.cod-estabel. 
    def input  param p-referencia             like contr-emprestimo.referencia.
    def input  param p-dt-referencia          like contr-emprestimo.dt-referencia. 
    def input  param p-num-id-mov-tit         like contr-emprestimo.int-1.
    def output param v_des_msg                as character format "x(40)":U  no-undo.
    def output param v_des_help_erro          as character format "x(200)":U no-undo.
    def input  param p-dt-estorno             AS DATE. 
    def output param p_num_msg                as integer format ">>>>,>>9" no-undo.
    
    DEF VAR v-val-movto-operac-financ         AS DEC  NO-UNDO.
    DEF VAR v-cta-ajuste                      AS CHAR NO-UNDO.
    DEF VAR c-cod-ccusto-ajust                AS CHAR NO-UNDO.
    DEF VAR v-ct-codigo                       AS CHAR NO-UNDO.
    DEF VAR v-sc-codigo                       AS CHAR NO-UNDO.
    DEF VAR p_cod_plano_cta_ctbl              AS CHAR NO-UNDO.
    DEF VAR p_cod_cta_ctbl                    AS CHAR NO-UNDO.
    DEF VAR p_cod_plano_ccusto                AS CHAR NO-UNDO.
    DEF VAR p_cod_ccusto                      AS CHAR NO-UNDO.
    DEF VAR p_cod_unid_negoc                  AS CHAR NO-UNDO.
    DEF VAR c-historico                       AS CHAR NO-UNDO.
    DEF VAR p_num_id_movto_acerto_sdo         AS INT  NO-UNDO.
    DEF VAR p_num_id_movto_acerto_sdo_princ   AS INT  NO-UNDO.
    def var c-datacalc                        as char no-undo.
    DEF VAR v-num-moeda                       AS INT  NO-UNDO.
    DEF VAR v-val-cotacao AS DECIMAL FORMAT "->>>,>9.99999999":U INITIAL 0 NO-UNDO.
    DEF VAR v-val-cotacao-tit-ap AS DECIMAL FORMAT "->>>,>9.99999999":U INITIAL 0 NO-UNDO.
    
    
    ASSIGN c-ep-codigo     = p-ep-codigo
           v_des_help_erro = ''
           v_des_msg       = ''
           p_num_msg       = 0.
    
    DEF VAR h-apb798za AS HANDLE NO-UNDO.
    def var h-boad346  as handle no-undo.

    assign v_cod_usuar_corren_old = v_cod_usuar_corren 
           v_cod_empres_usuar_old = v_cod_empres_usuar.

    &IF "{&mguni_version}" <= "2.06B" &THEN
        assign v_cod_usuar_corren_old = v_cod_usuar_corren 
           v_cod_empres_usuar_old = v_cod_empres_usuar
           v_cod_usuar_corren     = ""
           v_cod_empres_usuar     = "".

    /*** chama login do usuario ***/
    run prgtec/btb/btb906za.py.
    
    if v_cod_usuar_corren = "" or 
       v_cod_empres_usuar = "" then do:
        assign v_cod_usuar_corren = v_cod_usuar_corren_old 
               v_cod_empres_usuar = v_cod_empres_usuar_old.
       return "NOK":U.
    end.
    &ENDIF
    
    IF  l-funcao-pgto-juros-sdesemb THEN DO:
        IF  NOT VALID-HANDLE(h-boad357) THEN
            RUN adbo/boad357.p PERSISTENT SET h-boad357.

        /** BUSCA CONTA AJUSTE **/
        run pi-busca-conta-ajuste-new in h-boad357 (output v-cta-ajuste
                                                    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
                                                        ,output c-cod-ccusto-ajust
                                                    &ENDIF
                                                    ,input c-ep-codigo).
        
        &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
                                                
            assign v-ct-codigo = v-cta-ajuste
                   v-sc-codigo = c-cod-ccusto-ajust.
        
        &ELSE
            if not valid-handle(h-boad049) then
               run adbo/boad049o.p persistent set h-boad049.
            
            run pi-busca-conta-contab in h-boad049 (input  v-cta-ajuste,
                                                    output v-ct-codigo,
                                                    output v-sc-codigo).
        &ENDIF
        
        IF VALID-HANDLE(h-boad049) THEN
            delete procedure h-boad049.
        delete procedure h-boad357.
        &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
            if   v-ct-codigo = ''
            and  v-sc-codigo = '' then do:
    
                find first param-global no-lock no-error.
                if avail param-global then do:
                    assign v-ct-codigo = substring(v-cta-ajuste,1,length(param-global.ct-format)).
                           v-sc-codigo = substring(v-cta-ajuste,length(param-global.ct-format) + 1,length(param-global.sc-format)).
                end.
            end.
        &ENDIF
        
        FOR EACH tt_xml_input_output:
            DELETE tt_xml_input_output.
        END.
        FOR EACH tt_log_erros.
            DELETE tt_log_erros.
        END.
        
        create tt_xml_input_output.
        assign tt_xml_input_output.ttv_cod_label = "Fun‡Æo" 
               tt_xml_input_output.ttv_des_conteudo = "Cƒmbio 2.00" 
               tt_xml_input_output.ttv_num_seq_1 = 1.
        create tt_xml_input_output.
        assign tt_xml_input_output.ttv_cod_label = "Produto"
               tt_xml_input_output.ttv_des_conteudo = "EMS 5"
               tt_xml_input_output.ttv_num_seq_1 = 1.
        create tt_xml_input_output.
        assign tt_xml_input_output.ttv_cod_label = "Empresa"
               tt_xml_input_output.ttv_des_conteudo = string(p-ep-codigo)
               tt_xml_input_output.ttv_num_seq_1 = 1.
        create tt_xml_input_output.
        assign tt_xml_input_output.ttv_cod_label = "Estabel"
               tt_xml_input_output.ttv_des_conteudo = p-cod-estabel
               tt_xml_input_output.ttv_num_seq_1 = 1.
        create tt_xml_input_output.
        assign tt_xml_input_output.ttv_cod_label = "Contas"
               tt_xml_input_output.ttv_des_conteudo = v-ct-codigo   + ';' + 
                                                      v-sc-codigo   + ';' +
                                                      ""            + ';' +
                                                      p-cod-estabel + ';' + /*Estabelecimento Externo*/
                                                      ""            + ';' +
                                                      string(p-dt-estorno).
               tt_xml_input_output.ttv_num_seq_1 = 1.
        
        run prgint/utb/utb786za.py (input-output table tt_xml_input_output,
                                    output table tt_log_erros).
        
        FIND FIRST tt_log_erros NO-LOCK NO-ERROR.
        IF  AVAIL tt_log_erros THEN DO:
            ASSIGN p_num_msg       = tt_log_erros.ttv_num_cod_erro
                   v_des_msg       = tt_log_erros.ttv_des_erro
                   v_des_help_erro = tt_log_erros.ttv_des_ajuda.
            RETURN "NOK":U.
        END.
        else do:
            find first tt_xml_input_output no-lock
                 where tt_xml_input_output.ttv_cod_label = "Contas" no-error.
            if  avail tt_xml_input_output then
                assign p_cod_plano_cta_ctbl = entry(1,tt_xml_input_output.ttv_des_conteudo_aux, ";")
                       p_cod_cta_ctbl       = entry(2,tt_xml_input_output.ttv_des_conteudo_aux, ";")
                       p_cod_plano_ccusto   = entry(3,tt_xml_input_output.ttv_des_conteudo_aux, ";")
                       p_cod_ccusto         = entry(4,tt_xml_input_output.ttv_des_conteudo_aux, ";")
                       p_cod_unid_negoc     = entry(5,tt_xml_input_output.ttv_des_conteudo_aux, ";").

            find first tt_xml_input_output no-lock
                 where tt_xml_input_output.ttv_cod_label = "Empresa" no-error.
            if  avail tt_xml_input_output then
                assign v_cod_empres_usuar = tt_xml_input_output.ttv_des_conteudo_aux.
        end.
    END.

    find first contrato-exp no-lock
        where contrato-exp.ep-codigo     = p-ep-codigo    
          and contrato-exp.cod-estabel   = p-cod-estabel  
          and contrato-exp.referencia    = p-referencia   
          and contrato-exp.dt-referencia = p-dt-referencia no-error.
    if avail contrato-exp then do:
        if contrato-exp.tp-contrato-exp = 3 then /*empr‚stimo*/
            IF NOT CAN-FIND(FIRST contr-emprestimo NO-LOCK
                where contr-emprestimo.ep-codigo     = p-ep-codigo
                and   contr-emprestimo.cod-estabel   = p-cod-estabel
                and   contr-emprestimo.referencia    = p-referencia
                and   contr-emprestimo.dt-referencia = p-dt-referencia
                and   contr-emprestimo.int-1         = p-num-id-mov-tit) THEN DO:
        
                run utp/ut-msgs.p (input "msg",input 53973, input "").
                assign v_des_msg = return-value.
                run utp/ut-msgs.p (input "help",input 53973, input "").
                assign v_des_help_erro = return-value.
        
                RETURN "NOK":U.
            END.
    end.

    FOR EACH contr-emprestimo exclusive-lock
         where contr-emprestimo.ep-codigo     = p-ep-codigo
         and   contr-emprestimo.cod-estabel   = p-cod-estabel
         and   contr-emprestimo.referencia    = p-referencia
         and   contr-emprestimo.dt-referencia = p-dt-referencia
         and   contr-emprestimo.int-1         = p-num-id-mov-tit
        BREAK BY contr-emprestimo.num-seq-movto-operac-financ DESC:

        run prgfin/acr/acr788za.py persistent set h-acr788za.
        IF  contr-emprestimo.transacao <> 16 /*arbitragem apb*/
        AND contr-emprestimo.transacao <> 17 /*arbitragem acr*/
        AND contr-emprestimo.transacao <> 18 /*pgto sem desembolso*/ THEN do:

            run pi_verifica_pagamento_juros_cambio in h-acr788za (input contr-emprestimo.num-seq-movto-operac-financ,
                                                                  output p_num_msg).
    
            run pi_cria_elimina_repas_pend_apl in h-acr788za (input contr-emprestimo.num-id-operac-financ,
                                                              input contr-emprestimo.num-seq-movto-operac-financ,
                                                              input contr-emprestimo.dt-transacao,
                                                              input "",
                                                              input 0,
                                                              input NO).
            delete procedure h-acr788za.
            
            run prgfin/apl/apl007zu.py (INPUT  1,
                                        input  "Estorno",
                                        input  "Movimento",
                                        input  contr-emprestimo.num-id-operac-financ,
                                        input  contr-emprestimo.num-seq-movto-operac-financ,
                                        input  p-dt-estorno ,
                                        output table tt_log_erro).
                        if return-value = '4557' then
                                return '4557'.
            
            find first tt_log_erro no-lock no-error.
            if avail tt_log_erro then do:
                if  tt_log_erro.ttv_num_cod_erro = 9101 then do:
                    run utp/ut-msgs.p (input "msg",input 26498, input "").
                    assign v_des_msg = return-value.
                    run utp/ut-msgs.p (input "help",input 26498, input "").
                    assign v_des_help_erro = return-value.
                end.
    
                if tt_log_erro.ttv_num_cod_erro = 9907 then do:
                    run utp/ut-msgs.p (input "msg",input 26499, input "").
                    assign v_des_msg = return-value.
                    run utp/ut-msgs.p (input "help",input 26499, input "").
                    assign v_des_help_erro = return-value.
                end.
    
                if tt_log_erro.ttv_num_cod_erro <> 9101 and 
                   tt_log_erro.ttv_num_cod_erro <> 9907 then do:
                    run utp/ut-msgs.p (input "msg",input 26512, input "").
                    assign v_des_msg = RETURN-VALUE.
                    run utp/ut-msgs.p (input "help",input 26512, input "").
                    assign v_des_help_erro = RETURN-VALUE + STRING("COD MSG: " + string(tt_log_erro.ttv_num_cod_erro)).
                end.
            end.

        END.
        ELSE DO:
            /* aqui estar  sendo procurado o t¡tulo do ACR ou APB correspondente ao valor de diferen‡a dos t¡tulos arbitrados */
                /*dever  ser colocada a l¢gica para procurar o t¡tulo no APB ou ACR e cancel -lo 
                Verificar se apb ou acr e enviar para os programas apb798za ou acr788za
                tratar os erros.*/
            IF NOT VALID-HANDLE (h-apb798za) THEN
                run prgfin/apb/apb798za.py persistent set h-apb798za.
            
            IF NOT VALID-HANDLE (h-acr788za) THEN
                run prgfin/acr/acr788za.py persistent set h-acr788za.
            
            IF NOT VALID-HANDLE (h-boad346) THEN
                run adbo/boad346.p  persistent set h-boad346.

            IF  contr-emprestimo.transacao = 16 THEN  /* APB */
                RUN pi_cancela_tit_apb IN h-apb798za (INPUT  contr-emprestimo.num-seq-movto-operac-financ,
                                                      INPUT  contr-emprestimo.cod-estabel,
                                                      OUTPUT TABLE tt_log_erro).
            IF  contr-emprestimo.transacao = 17 THEN  /* ACR */
                RUN pi_cancela_tit_acr IN h-acr788za (INPUT contr-emprestimo.num-seq-movto-operac-financ,
                                                      INPUT p-ep-codigo,
                                                      INPUT p-cod-estabel,
                                                      OUTPUT TABLE tt_log_erro).

            IF  contr-emprestimo.transacao = 18 THEN DO:

                assign c-datacalc  = string(year(contr-emprestimo.dt-transacao),"9999") + string(month(contr-emprestimo.dt-transacao),"99")
                       v-num-moeda = contrato-exp.moeda.

                run GetDescFK in h-boad346 (input "cotacao":U,
                                            input string(v-num-moeda) + chr(10)
                                            + c-datacalc + chr(10)
                                            + string(contr-emprestimo.dt-transacao),
                                            output v-val-cotacao).

              //No ec0006c.i9 chama a boad350 passando para atualizar a dec-1 do mec com o valor em moeda corrente, faz a conversÆo conforme cota‡Æo informada na tela.
              //Para realizar o Acerto na moeda estrangeira foi alterado para desconverter com a mesma cota‡Æo.
           
                RUN  pi_retorna_cotac_tit_ap in h-apb798za (INPUT  p-ep-codigo,
                                                            INPUT  p-cod-estabel,
                                                            INPUT  contr-emprestimo.num-seq-movto-operac-financ,
                                                            OUTPUT v-val-cotacao-tit-ap).
                IF v-val-cotacao-tit-ap = 0 THEN
                    ASSIGN v-val-cotacao-tit-ap = 1 / v-val-cotacao.

                RUN pi_alterar_titulo_apb in h-apb798za (INPUT  p-ep-codigo,
                                                         INPUT  p-cod-estabel,
                                                         INPUT  p-dt-estorno,
                                                         INPUT  contr-emprestimo.num-seq-movto-operac-financ,
                                                         INPUT  (contr-emprestimo.dec-1 * v-val-cotacao-tit-ap),
                                                         OUTPUT TABLE tt_log_erros).
                
                IF CAN-FIND(FIRST tt_log_erros
                   WHERE tt_log_erros.ttv_num_cod_erro <> 6542) THEN do:
                   FIND FIRST tt_log_erros NO-LOCK 
                        WHERE tt_log_erros.ttv_num_cod_erro <> 6542 NO-ERROR.
                   IF  AVAIL tt_log_erros THEN DO:
                       ASSIGN p_num_msg       = tt_log_erros.ttv_num_cod_erro
                              v_des_msg       = tt_log_erros.ttv_des_erro
                              v_des_help_erro = tt_log_erros.ttv_des_ajuda.
                   END.
                   IF CAN-FIND(FIRST tt_log_erros
                       WHERE tt_log_erros.ttv_num_cod_erro = 12707) THEN do:
                       RETURN "12707":U.
                   END.
                   RETURN "nok".
                END.
            END.
            
            DELETE PROCEDURE h-apb798za.
            
            DELETE PROCEDURE h-acr788za.

            if valid-handle(h-boad346) then
               delete procedure h-boad346.

            IF AVAIL tt_log_erro THEN do:
                FOR EACH tt_log_erro:
                    ASSIGN v_des_help_erro = tt_log_erro.ttv_des_msg_ajuda.
                END.
                RETURN "nok".
            END.
        END.
        delete contr-emprestimo.
    end.

    assign v_cod_usuar_corren = v_cod_usuar_corren_old 
           v_cod_empres_usuar = v_cod_empres_usuar_old.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cancela-destinado DBOProgram 
PROCEDURE pi-cancela-destinado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-num-id-operac LIKE contr-emprestimo.num-id-operac-financ        NO-UNDO.
    DEF INPUT  PARAM p-num-id-movto  LIKE contr-emprestimo.num-seq-movto-operac-financ NO-UNDO.
    DEF INPUT  PARAM p-acao          AS   CHAR                                         NO-UNDO.
    DEF OUTPUT PARAM p-resultado     AS   CHAR                                         NO-UNDO.

    DEF VAR h-boad346 AS HANDLE NO-UNDO.
    DEF VAR h-boad347 AS HANDLE NO-UNDO.
    DEF VAR h-boad391 AS HANDLE NO-UNDO.

    FIND FIRST contr-emprestimo NO-LOCK
         WHERE contr-emprestimo.num-id-operac-financ        = p-num-id-operac 
         AND   contr-emprestimo.num-seq-movto-operac-financ = p-num-id-movto  NO-ERROR.
    IF AVAIL contr-emprestimo THEN DO:
        IF p-acao                     = "Consulta" AND 
           contr-emprestimo.transacao = 19         THEN
            ASSIGN p-resultado = "Destina‡Æo".

        IF p-acao = "Estorna" THEN DO:
            /* Atualiza Saldo Contrato*/
            IF NOT VALID-HANDLE(h-boad346) THEN
                RUN adbo/boad346.p PERSISTEN SET h-boad346.
            run pi-atualiza-saldo-contrato in h-boad346 (input contr-emprestimo.ep-codigo,
                                                         input contr-emprestimo.cod-estabel,
                                                         input contr-emprestimo.referencia,
                                                         input contr-emprestimo.dt-referencia,
                                                         input 0,
                                                         input contr-emprestimo.dec-1 * -1,
                                                         input contr-emprestimo.dec-1 * -1).
            DELETE PROCEDURE h-boad346.

            /* Atualiza Saldo da Cambial*/
            IF NOT VALID-HANDLE(h-boad347) THEN
                RUN adbo/boad347.p PERSISTEN SET h-boad347.

            FOR EACH contr-titulo-exp
               WHERE contr-titulo-exp.ep-codigo     = contr-emprestimo.ep-codigo
               AND   contr-titulo-exp.cod-estabel     = contr-emprestimo.cod-estabel
               AND   contr-titulo-exp.referencia    = contr-emprestimo.referencia
               AND   contr-titulo-exp.dt-referencia = contr-emprestimo.dt-referencia NO-LOCK:
                IF contr-titulo-exp.num-id-operac-financ = p-num-id-operac THEN
                    RUN pi-atualiza-saldo-titulo IN h-boad347 (input contr-titulo-exp.ep-codigo,
                                                               input contr-titulo-exp.cod-estabel,
                                                               input contr-titulo-exp.referencia,
                                                               input contr-titulo-exp.dt-referencia,
                                                               input contr-titulo-exp.cod-emitente,
                                                               input contr-titulo-exp.cod-esp,
                                                               input contr-titulo-exp.serie,
                                                               input contr-titulo-exp.nr-docto,
                                                               input contr-titulo-exp.parcela,
                                                               input contr-emprestimo.dec-1 * -1,
                                                               input contr-titulo-exp.dt-vinculado,
                                                               INPUT contr-emprestimo.dec-1 * -1).

            END.
            DELETE PROCEDURE h-boad347.

            &if defined(BF_FIN_MEC_FUT_CFL2) &then
                IF l-funcao-recta-cambio-fut THEN DO:
                    
                    run adbo/boad391.p  persistent set h-boad391.
                    FIND FIRST movto-contrat-tit-export NO-LOCK
                        WHERE movto-contrat-tit-export.num-id-movto-operac-financ = p-num-id-movto NO-ERROR.
                    IF AVAIL movto-contrat-tit-export THEN DO:
                        
                        RUN pi-estorna IN h-boad391 (INPUT movto-contrat-tit-export.cdn-empresa,
                                                     INPUT movto-contrat-tit-export.cod-estab,
                                                     INPUT movto-contrat-tit-export.cod-refer,
                                                     INPUT movto-contrat-tit-export.dat-refer-contrat,
                                                     INPUT movto-contrat-tit-export.cdn-emitente,
                                                     INPUT movto-contrat-tit-export.cod-espec-docto,
                                                     INPUT movto-contrat-tit-export.cod-serie,
                                                     INPUT movto-contrat-tit-export.cod-docto,
                                                     INPUT movto-contrat-tit-export.cod-parcela,
                                                     INPUT movto-contrat-tit-export.dat-vinculac-tit,
                                                     INPUT 9).
                    END.
                    DELETE PROCEDURE h-boad391.
                END.
            &endif
        END.
    END.
    ELSE
        ASSIGN p-resultado = "NOK".

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-emprestimo-efetivo DBOProgram 
PROCEDURE pi-cria-emprestimo-efetivo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-ep-codigo              like contr-emprestimo.ep-codigo.
    def input param p-cod-banco-ems5         like contr-emprestimo.cod-banco-ems5.
    def input param p-cod-estabel            like contr-emprestimo.cod-estabel. 
    def input param p-dt-contrato            like contr-emprestimo.dt-contrato. 
    def input param p-dt-referencia          like contr-emprestimo.dt-referencia. 
    def input param p-dt-transacao           like contr-emprestimo.dt-transacao. 
    def input param p-nr-contrato            like contr-emprestimo.nr-contrato. 
    def input param p-num-id-operac-financ   like contr-emprestimo.num-id-operac-financ. 
    def input param p-operac-financ          like contr-emprestimo.operac-financ. 
    def input param p-prod-financ            like contr-emprestimo.prod-financ. 
    def input param p-referencia             like contr-emprestimo.referencia.
    def input param p-cod-banco-ems5-d       like contr-emprestimo.cod-banco-ems5-d.
    def input param p-num-id-operac-financ-d like contr-emprestimo.num-id-operac-financ-d.
    def input param p-operac-financ-d        like contr-emprestimo.operac-financ-d.
    def input param p-prod-financ-d          like contr-emprestimo.prod-financ-d.
    def input param p-num-id-movto-operac    like contr-emprestimo.num-seq-movto-operac-financ.
    def input param p-transacao              like contr-emprestimo.transacao.
    def input param p-ind-origem             like contr-emprestimo.log-1.
    def input param p-vl-movto-me            like contr-emprestimo.dec-1.
    def input param p-num-id-mov-tit         like contr-emprestimo.int-1.

    /***** 
        Informa‡äes dos campos:
        log-1 -> NO  = Indica que o movimento ‚ referente vincula‡Æo do t¡tulo.
                 YES = Indica que o movimento ‚ referente a um cancelamento de 
                       Saldo no Cƒmbio.
        dec-1 -> Valor do movimento em moeda estrangeira no caso de cancelamento,
                 sem o valor dos juros.
        int-1 -> Possui o num-id do movimento de ava da baixa do emprestimo, usado para
                 cancelamento.
    ******/

    def var i-ep-codigo                      like contr-emprestimo.ep-codigo.
    def var c-usuario                        like contr-emprestimo.usuario.
    DEF VAR h-boad391 AS HANDLE NO-UNDO.

    DEF BUFFER b-movto-contrat-tit-export FOR
        movto-contrat-tit-export.
    
    assign cQueryUseded = "Main".
    for each RowObject:
       delete RowObject.
    end.

    create RowObject.
    assign RowObject.cod-banco-ems5              = p-cod-banco-ems5 
           RowObject.cod-estabel                 = p-cod-estabel 
           RowObject.dt-contrato                 = p-dt-contrato 
           RowObject.dt-referencia               = p-dt-referencia 
           RowObject.dt-transacao                = p-dt-transacao 
           RowObject.nr-contrato                 = p-nr-contrato 
           RowObject.num-id-operac-financ        = p-num-id-operac-financ 
           RowObject.operac-financ               = p-operac-financ 
           RowObject.prod-financ                 = p-prod-financ 
           RowObject.referencia                  = p-referencia
           RowObject.cod-banco-ems5-d            = p-cod-banco-ems5-d
           RowObject.num-id-operac-financ-d      = p-num-id-operac-financ-d
           RowObject.operac-financ-d             = p-operac-financ-d
           RowObject.prod-financ-d               = p-prod-financ-d
           RowObject.num-seq-movto-operac-financ = p-num-id-movto-operac
           RowObject.ep-codigo                   = p-ep-codigo
           RowObject.usuario                     = c-usuario
           RowObject.c-time                      = string(TIME, "HH:MM")
           RowObject.dt-today                    = today
           RowObject.transacao                   = p-transacao
           RowObject.log-1                       = p-ind-origem
           RowObject.dec-1                       = p-vl-movto-me
           RowObject.int-1                       = p-num-id-mov-tit.

    run createRecord in this-procedure.

    &if defined(BF_FIN_MEC_FUT_CFL2) &then
        IF l-funcao-recta-cambio-fut AND p-transacao = 19 THEN DO:
            
            run adbo/boad391.p  persistent set h-boad391.
            
            Find first contr-titulo-exp NO-LOCK
               where contr-titulo-exp.ep-codigo      = p-ep-codigo       
                 and contr-titulo-exp.cod-estabel    = p-cod-estabel     
                 and contr-titulo-exp.referencia     = p-referencia      
                 and contr-titulo-exp.dt-referencia  = p-dt-referencia   
                 and contr-titulo-exp.cod-banco-ems5 = p-cod-banco-ems5-d
                 and contr-titulo-exp.prod-financ    = p-prod-financ-d  
                 and contr-titulo-exp.operac-financ  = p-operac-financ-d NO-ERROR.
            IF AVAIL contr-titulo-exp THEN DO:
                
                find first movto-contrat-tit-export NO-LOCK
                    where movto-contrat-tit-export.cod-estab             = contr-titulo-exp.cod-estabel
                      and    movto-contrat-tit-export.cod-docto          = contr-titulo-exp.nr-docto         
                      and    movto-contrat-tit-export.cod-espec-docto    = contr-titulo-exp.cod-esp
                      and    movto-contrat-tit-export.cdn-empresa        = contr-titulo-exp.ep-codigo  
                      and    movto-contrat-tit-export.cdn-emitente       = contr-titulo-exp.cod-emitente      
                      and    movto-contrat-tit-export.cod-parcela        = contr-titulo-exp.parcela
                      and    movto-contrat-tit-export.cod-serie          = contr-titulo-exp.serie      
                      and    movto-contrat-tit-export.cod-refer          = contr-titulo-exp.referencia 
                      and    movto-contrat-tit-export.cod-contrat-cambio = contr-titulo-exp.nr-contrato
                      and    movto-contrat-tit-export.dat-refer-contrat  = contr-titulo-exp.dt-referencia
                      and    movto-contrat-tit-export.cdn-trans          = 1 /* vincula‡Æo */ NO-ERROR. 
                IF AVAIL movto-contrat-tit-export THEN DO:
                    
                    FIND FIRST b-movto-contrat-tit-export NO-LOCK
                            WHERE b-movto-contrat-tit-export.cdn-empresa     = movto-contrat-tit-export.cdn-empresa            
                            AND   b-movto-contrat-tit-export.cod-estab       = movto-contrat-tit-export.cod-estab
                            AND   b-movto-contrat-tit-export.cdn-emitente    = movto-contrat-tit-export.cdn-emitente
                            AND   b-movto-contrat-tit-export.cod-espec-docto = movto-contrat-tit-export.cod-espec-docto
                            AND   b-movto-contrat-tit-export.cod-serie       = movto-contrat-tit-export.cod-serie
                            AND   b-movto-contrat-tit-export.cod-docto       = movto-contrat-tit-export.cod-docto
                            AND   b-movto-contrat-tit-export.cod-parcela     = movto-contrat-tit-export.cod-parcela
                            AND   b-movto-contrat-tit-export.cdn-trans       = 3
                            AND   b-movto-contrat-tit-export.cod-refer       = movto-contrat-tit-export.cod-contrat-cambio-orig
                            AND   b-movto-contrat-tit-export.dat-vinculac-tit = movto-contrat-tit-export.dat-vinculac-tit 
                            AND   b-movto-contrat-tit-export.cod-contrat-cambio-dest = movto-contrat-tit-export.cod-refer  NO-ERROR.
                    IF AVAIL b-movto-contrat-tit-export THEN DO:
    
                        
                        RUN pi-cria-tabela IN h-boad391 (INPUT contr-titulo-exp.cod-emitente,
                                                         INPUT contr-titulo-exp.ep-codigo,
                                                         INPUT b-movto-contrat-tit-export.cdn-portador,
                                                         INPUT 9, /* Liquida‡Æo T¡tulo Empr‚stimo Destinado */
                                                         INPUT contr-titulo-exp.nr-contrato,
                                                         INPUT "",
                                                         INPUT "",
                                                         INPUT contr-titulo-exp.nr-docto,
                                                         INPUT contr-titulo-exp.cod-esp,
                                                         INPUT contr-titulo-exp.cod-estabel,
                                                         INPUT contr-titulo-exp.parcela,
                                                         INPUT contr-titulo-exp.referencia,              
                                                         INPUT contr-titulo-exp.serie,
                                                         INPUT ?,
                                                         INPUT p-dt-transacao, /* parƒmetro da PI */ 
                                                         INPUT contr-titulo-exp.dt-vinculado,
                                                         INPUT contr-titulo-exp.dt-referencia,
                                                         INPUT contr-titulo-exp.dt-vinculado,
                                                         INPUT 1,             
                                                         INPUT NO,
                                                         INPUT b-movto-contrat-tit-export.val-cotac-dia,
                                                         INPUT b-movto-contrat-tit-export.val-movto,
                                                         INPUT p-num-id-movto-operac).  /* parƒmetro da PI */
                    END.
                END.
            END.
            if valid-handle(h-boad391) then
                delete procedure h-boad391.
        END.
    &endif
    
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-registro DBOProgram 
PROCEDURE pi-cria-registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-c-time               like contr-emprestimo.c-time.
    def input param p-check-sum            like contr-emprestimo.check-sum. 
    def input param p-cod-banco-ems5       like contr-emprestimo.cod-banco-ems5.
    def input param p-cod-estabel          like contr-emprestimo.cod-estabel. 
    def input param p-dt-contrato          like contr-emprestimo.dt-contrato. 
    def input param p-dt-referencia        like contr-emprestimo.dt-referencia. 
    def input param p-dt-today             like contr-emprestimo.dt-today. 
    def input param p-dt-transacao         like contr-emprestimo.dt-transacao. 
    def input param p-ep-codigo            like contr-emprestimo.ep-codigo. 
    def input param p-nr-contrato          like contr-emprestimo.nr-contrato. 
    def input param p-num-id-operac-financ like contr-emprestimo.num-id-operac-financ. 
    def input param p-operac-financ        like contr-emprestimo.operac-financ. 
    def input param p-prod-financ          like contr-emprestimo.prod-financ. 
    def input param p-referencia           like contr-emprestimo.referencia. 
    def input param p-usuario              like contr-emprestimo.usuario.
    def input param p-transacao            like contr-emprestimo.transacao.

    assign cQueryUseded = "Main".
    for each RowObject:
       delete RowObject.
    end.

    create RowObject.
    assign RowObject.c-time                      = p-c-time 
           RowObject.check-sum                   = p-check-sum 
           RowObject.cod-banco-ems5              = p-cod-banco-ems5 
           RowObject.cod-estabel                 = p-cod-estabel 
           RowObject.dt-contrato                 = p-dt-contrato 
           RowObject.dt-referencia               = p-dt-referencia 
           RowObject.dt-today                    = p-dt-today 
           RowObject.dt-transacao                = p-dt-transacao 
           RowObject.ep-codigo                   = p-ep-codigo 
           RowObject.nr-contrato                 = p-nr-contrato 
           RowObject.num-id-operac-financ        = p-num-id-operac-financ 
           RowObject.operac-financ               = p-operac-financ 
           RowObject.prod-financ                 = p-prod-financ 
           RowObject.referencia                  = p-referencia 
           RowObject.usuario                     = p-usuario
           RowObject.transacao                   = p-transacao.

    run createRecord in this-procedure.
   
    RETURN "OK":U.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-localiza-contr-titulo DBOProgram 
PROCEDURE pi-localiza-contr-titulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /************************ Parameter Definition Begin ************************/

    def Input param p-num-id-operac-financ       like contr-emprestimo.num-id-operac-financ.
    def Input param p-num-id-movto-operac-financ like contr-emprestimo.num-id-operac-financ-d.
        
    def output param p-cod-empresa-ems2 like contr-titulo-exp.ep-codigo.
    def output param p-cod-estab-ems2   like contr-titulo-exp.cod-estabel.
    def output param p-cod-emitente     like contr-titulo-exp.cod-emitente.
    def output param p-cod_esp          like contr-titulo-exp.cod-esp.
    def output param p-serie            like contr-titulo-exp.serie.
    def output param p-nr-docto         like contr-titulo-exp.nr-docto.
    def output param p-parcela          like contr-titulo-exp.parcela.
    def output param p-num-id           like contr-emprestimo.int-1.


    /************************* Parameter Definition End *************************/
   find contr-emprestimo no-lock
        where contr-emprestimo.num-id-operac-financ-d      = p-num-id-operac-financ
        and   contr-emprestimo.num-seq-movto-operac-financ = p-num-id-movto-operac-financ
        and   contr-emprestimo.transacao                   = 13  no-error.
   /*Rodrigo - COMPL ATV 235243*/
   if not avail contr-emprestimo then
       return "nok".
   /*Rodrigo - COMPL ATV 235243*/

   find contr-titulo-exp no-lock
        where contr-titulo-exp.operac-financ    = contr-emprestimo.operac-financ-d no-error.
   /*Rodrigo - COMPL ATV 235243*/
   if not avail contr-titulo-exp then
       return "nok".
   /*Rodrigo - COMPL ATV 235243*/

   /*
   contr-titulo-exp.ep-codigo        = contr-emprestimo.ep-codigo
        and   contr-titulo-exp.cod-estabel      = contr-emprestimo.cod-estabel
        and   contr-titulo-exp.referencia       = contr-emprestimo.referencia 
        and   contr-titulo-exp.dt-referencia    = contr-emprestimo.dt-referencia
        and   contr-titulo-exp.cod-banco-ems5   = contr-emprestimo.cod-banco-ems5-d
        and   contr-titulo-exp.prod-financ      = contr-emprestimo.prod-financ-d
        and   
   */

   assign p-cod-empresa-ems2 = contr-titulo-exp.ep-codigo
          p-cod-estab-ems2   = contr-titulo-exp.cod-estabel
          p-cod-emitente     = contr-titulo-exp.cod-emitente 
          p-cod_esp          = contr-titulo-exp.cod-esp 
          p-serie            = contr-titulo-exp.serie
          p-nr-docto         = contr-titulo-exp.nr-docto
          p-parcela          = contr-titulo-exp.parcela
          p-num-id           = contr-emprestimo.int-1.

   /*Rodrigo - COMPL ATV 235243*/
   return "ok".
   /*Rodrigo - COMPL ATV 235243*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-operacao-filho DBOProgram 
PROCEDURE pi-retorna-operacao-filho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p-ep-codigo              AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER p-cod-estabel            AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER p-referencia             AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER p-dt-referencia          AS DATE         NO-UNDO.
  DEFINE OUTPUT PARAMETER p-num-id-operac-financ  AS INTEGER      NO-UNDO.

  EMPTY TEMP-TABLE RowObject.

  FOR EACH contr-emprestimo WHERE contr-emprestimo.ep-codigo     = p-ep-codigo
                              AND contr-emprestimo.cod-estabel   = p-cod-estabel
                              AND contr-emprestimo.referencia    = p-referencia
                              AND contr-emprestimo.dt-referencia = p-dt-referencia
                              AND contr-emprestimo.transacao     = 4 //LIBERA°€O
                                  NO-LOCK.

      IF contr-emprestimo.num-id-operac-financ = 0 THEN DO:
         NEXT.
      END.

      ASSIGN p-num-id-operac-financ = contr-emprestimo.num-id-operac-financ.

      IF contr-emprestimo.num-id-operac-financ-d = 0 THEN DO:
         NEXT.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verif-contr-emprest-tit-ems5 DBOProgram 
PROCEDURE pi-verif-contr-emprest-tit-ems5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       PI para verificar se existe contr-emprestimo vinculado ao titulo cancelado
               
------------------------------------------------------------------------------*/
    def input  param p-num-seq-movto-operac-financ  like contr-emprestimo.num-seq-movto-operac-financ.
    def output param p-nr-contrato                  like contr-emprestimo.nr-contrato.
    
    assign p-nr-contrato = "".
    find first contr-emprestimo no-lock
         where contr-emprestimo.num-seq-movto-operac-financ = p-num-seq-movto-operac-financ no-error.
    if avail contr-emprestimo then do:
        assign p-nr-contrato = contr-emprestimo.nr-contrato.
        RETURN "NOK":U.
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-operacao-filho DBOProgram 
PROCEDURE pi-verifica-operacao-filho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-num-id-operac-financ  AS INTEGER      NO-UNDO.
    DEFINE OUTPUT PARAMETER p-log-existe            AS LOGICAL      NO-UNDO.
    DEFINE OUTPUT PARAMETER p-ep-codigo             AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER p-cod-estabel           AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER p-referencia            AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER p-dt-referencia         AS DATE         NO-UNDO.

    
    ASSIGN p-log-existe = NO.
    
    FIND FIRST contr-emprestimo WHERE contr-emprestimo.num-id-operac-financ-d = p-num-id-operac-financ NO-LOCK NO-ERROR.

    ASSIGN p-log-existe = AVAIL contr-emprestimo.

    IF AVAIL contr-emprestimo THEN DO:
       ASSIGN p-ep-codigo     = contr-emprestimo.ep-codigo
              p-cod-estabel   = contr-emprestimo.cod-estabel
              p-referencia    = contr-emprestimo.referencia
              p-dt-referencia = contr-emprestimo.dt-referencia.
    END.
    
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
    DEFINE INPUT PARAMETER pep-codigo     LIKE contr-emprestimo.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel   LIKE contr-emprestimo.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER preferencia    LIKE contr-emprestimo.referencia NO-UNDO.
    DEFINE INPUT PARAMETER pdt-referencia LIKE contr-emprestimo.dt-referencia NO-UNDO.
    
    assign i-ep-codigo     = pep-codigo
           c-cod-estabel   = pcod-estabel
           c-referencia    = preferencia
           d-dt-referencia = pdt-referencia.
    
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

    if ptype = "Create":U or ptype = "Update":U then do:
       run pi-autenticacao.
    end.
    
    if ptype = "Create":U then do:
        /* Verifica ocorr¼ncia de chave duplicada */
       find first contr-emprestimo no-lock
            where contr-emprestimo.ep-codigo      = RowObject.ep-codigo  
            and   contr-emprestimo.cod-estabel    = RowObject.cod-estabel
            and   contr-emprestimo.referencia     = RowObject.referencia
            and   contr-emprestimo.dt-referencia  = RowObject.dt-referencia
            and   contr-emprestimo.cod-banco-ems5 = RowObject.cod-banco-ems5
            and   contr-emprestimo.prod-financ    = RowObject.prod-financ
            and   contr-emprestimo.operac-financ  = RowObject.operac-financ
            and   contr-emprestimo.sequencia      = RowObject.sequencia      no-error.
       if avail contr-emprestimo then do:
           {utp/ut-liter.i Contrato_de_Empr‚stimo *}
           assign c-string1 = return-value.

           {method/svc/errors/inserr.i
                       &ErrorNumber="7"
                       &ErrorType="EMS"
                       &ErrorParameters="c-string1"}
       end.
    end.

    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

