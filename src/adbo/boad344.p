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
{include/i-prgvrs.i BOAD344 2.00.00.009 } /*** "010009" 28/11/2023 08:46:36 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad344 MUT}
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
&GLOBAL-DEFINE DBOName            BOAD344
&GLOBAL-DEFINE DBOVersion         1.00.00.000 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName          contr-despesa-imp
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName          qr{&TableName} 

{cdp/cdcfgfin.i}

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{adbo/boad344.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


/* ----- Definicoes Gerais -----------***/
{cbp/cbapi013.i}

/** Define TT Integraªío Cxa. Bancos EMS5 **/
{cdp/cd1202.i2}
{cdp/cdapi533a.i}

def temp-table tt_campos_mec_cfl no-undo
    field ttv_cod_estab_ext                as character format "x(3)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_cod_empresa_ext              as character format "x(3)" label "C¢digo Empresa Ext" column-label "C¢d Emp Ext"
    field ttv_cod_contrat_2                as character format "x(15)" label "Nr Contrato" column-label "Nr Contr"
    field ttv_dat_contrat                  as date format "99/99/9999" label "Dt Contrato" column-label "Dt Contr"
    field ttv_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field ttv_dat_refer                    as date format "99/99/9999" initial ? label "Data Referància" column-label "Data Refer"
    field tta_cod_modul_integr             as character format "x(3)" label "M¢dulo Integracao" column-label "M¢dulo Integracao"
    field ttv_val_despes_mec               as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Valor Desp"
    field ttv_cod_docto_empres_despes      as character format "x(16)" label "Docto Empresa"
    .

def temp-table tt_integr_mec_cfl_despes no-undo
    field tta_cod_estab_contrat_cambio     as character format "x(3)" label "Estab Contr CÉmbio" column-label "Estab Contr CÉmbio"
    field tta_cod_contrat_cambio           as character format "x(15)" label "Contrato CÉmbio" column-label "Contrato CÉmbio"
    field tta_cod_refer_contrat_cambio     as character format "x(10)" label "Referància" column-label "Referància"
    field tta_dat_refer_contrat_cambio     as date format "99/99/9999" initial ? label "Dt Referància" column-label "Dt Referància"
    field tta_num_id_movto_fluxo_cx        as integer format "9999999999" initial 0 label "Id Movto Fluxo Cx" column-label "Id Movto Fluxo Cx"
    field tta_num_id_orig_movto_fluxo_cx   as integer format ">>>>,>>9" initial 0 label "Id Origem Movimento" column-label "Id Origem Movimento"
    field ttv_num_tip_despes_mec           as integer format ">>>>,>>9"
    field ttv_val_despes_mec               as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Valor Desp"
    field ttv_cod_docto_empres_despes      as character format "x(16)" label "Docto Empresa"
    .

def temp-table tt_erro_mec no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "SeqÅància" column-label "Seq"
    field ttv_cod_erro_ems2                as int column-label "Cod Erro"
    field ttv_des_msg_erro_ems2            as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància"
    .

def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".
    
def var c-nr-docto-banco   as char    no-undo.
def var c-conta-contabil   as char    no-undo.
def var i-cod-lancto       as int     no-undo.
def var i-tp-desp-rec      as int     no-undo.
def var c-historico        as char    no-undo.
def var c-nr-docto-emp-ant as char    no-undo.
def var c-cod-docto-ant    as char    no-undo.
def var da-movto-ant       as date    no-undo.

def var p-contabilizou   as logical no-undo.

def var i-ep-codigo     like contr-despesa-imp.ep-codigo     no-undo.
def var c-cod-estabel   like contr-despesa-imp.cod-estabel   no-undo.
def var c-referencia    like contr-despesa-imp.referencia    no-undo.
def var d-dt-referencia like contr-despesa-imp.dt-referencia no-undo.
def var v-conta-contabil as char    no-undo.
def var v-ct-codigo      as char    no-undo.
def var v-sc-codigo      as char    no-undo.

def var i-seq-erro       as   integer  no-undo.

DEF VAR p-num-id         AS   INTEGER                        NO-UNDO.

def new global shared var i-ep-codigo-usuario  like empresa.ep-codigo no-undo.

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
         WIDTH              = 39.86.
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

    find last bfcontr-despesa-imp where 
              bfcontr-despesa-imp.ep-codigo     = RowObject.ep-codigo     and
              bfcontr-despesa-imp.cod-estabel   = RowObject.cod-estabel   and
              bfcontr-despesa-imp.referencia    = RowObject.referencia    and
              bfcontr-despesa-imp.dt-referencia = RowObject.dt-referencia 
              no-lock no-error.
    if avail bfcontr-despesa-imp then do:
       assign RowObject.sequencia = bfcontr-despesa-imp.sequencia + 10.
    end.
    else assign RowObject.sequencia = 10.

    assign p-num-id = 0.

    find contrato-imp
         where contrato-imp.ep-codigo     = RowObject.ep-codigo
         and   contrato-imp.cod-estabel   = RowObject.cod-estabel
         and   contrato-imp.referencia    = RowObject.referencia
         and   contrato-imp.dt-referencia = RowObject.dt-referencia exclusive-lock no-error.
    if avail contrato-imp THEN DO:
       assign p-num-id = integer(string(string(contrato-imp.num-id-contrato-imp) + string(RowObject.sequencia))).

       assign RowObject.nr-contrato = contrato-imp.nr-contrato
              RowObject.int-1       = p-num-id.

    END.
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

        {ecp/ec0001g.i}
   
    
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
        WHEN "cod-docto":U THEN ASSIGN pFieldValue = RowObject.cod-docto.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cta-corrente":U THEN ASSIGN pFieldValue = RowObject.cta-corrente.
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "nr-docto-emp":U THEN ASSIGN pFieldValue = RowObject.nr-docto-emp.
        WHEN "referencia":U THEN ASSIGN pFieldValue = RowObject.referencia.
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
   def output param i-complemento as int  no-undo.

   case c-table:
      when "tipo-rec-desp":u then do:
         find tipo-rec-desp where tipo-rec-desp.tp-codigo = int(c-param) no-lock no-error.
         if  avail tipo-rec-desp then
            assign c-description = tipo-rec-desp.descricao.
         else
            assign c-description = "".
      end.
      when "hist-padrao":u then do:
         find hist-padrao where hist-padrao.hp-codigo = int(c-param) no-lock no-error.
         if avail hist-padrao then do:
            assign c-description = hist-padrao.descricao
                   i-complemento = hist-padrao.complemento.
         end.
         else
            assign c-description = "".
      end.
   end.

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
  Purpose:     Retorna valores dos campos do °ndice referencia
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo referencia
               retorna valor do campo dt-referencia
               retorna valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE OUTPUT PARAMETER pep-codigo     LIKE contr-despesa-imp.ep-codigo     NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel   LIKE contr-despesa-imp.cod-estabel   NO-UNDO.
    DEFINE OUTPUT PARAMETER preferencia    LIKE contr-despesa-imp.referencia    NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-referencia LIKE contr-despesa-imp.dt-referencia NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia     LIKE contr-despesa-imp.sequencia     NO-UNDO.

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
  Purpose:     Reposiciona registro com base no °ndice referencia
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo referencia
               recebe valor do campo dt-referencia
               recebe valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pep-codigo     LIKE contr-despesa-imp.ep-codigo     NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel   LIKE contr-despesa-imp.cod-estabel   NO-UNDO.
    DEFINE INPUT PARAMETER preferencia    LIKE contr-despesa-imp.referencia    NO-UNDO.
    DEFINE INPUT PARAMETER pdt-referencia LIKE contr-despesa-imp.dt-referencia NO-UNDO.
    DEFINE INPUT PARAMETER psequencia     LIKE contr-despesa-imp.sequencia     NO-UNDO.

    FIND FIRST bfcontr-despesa-imp WHERE 
               bfcontr-despesa-imp.ep-codigo = pep-codigo         AND 
               bfcontr-despesa-imp.cod-estabel = pcod-estabel     AND 
               bfcontr-despesa-imp.referencia = preferencia       AND 
               bfcontr-despesa-imp.dt-referencia = pdt-referencia AND 
               bfcontr-despesa-imp.sequencia = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcontr-despesa-imp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcontr-despesa-imp)).
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
        WHERE {&tablename}.ep-codigo     = i-ep-codigo   and
              {&tablename}.cod-estabel   = c-cod-estabel and 
              {&tablename}.referencia    = c-referencia  and 
              {&tablename}.dt-referencia = d-dt-referencia.
        
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-contr-despesa-imp DBOProgram 
PROCEDURE pi-altera-contr-despesa-imp :
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

    {ecp/ec0001g.i}

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-cb DBOProgram 
PROCEDURE pi-atualiza-cb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param pType as character no-undo.

    def var h-boad341     as handle    no-undo.
    def var p-portador    as int       no-undo.  
    def var p-modalidade  as int       no-undo.
    def var seq           as int       no-undo.

    assign i-seq-erro = 0.
    for each RowErrors:
        delete RowErrors.
    end.

    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
        assign c-conta-contabil = ""
               v-ct-codigo      = "" 
               v-sc-codigo      = ""
               .
    &ENDIF

    find contrato-imp where
         contrato-imp.ep-codigo     = RowObject.ep-codigo   and
         contrato-imp.cod-estabel   = RowObject.cod-estabel and
         contrato-imp.referencia    = RowObject.referencia  and
         contrato-imp.dt-referencia = RowObject.dt-referencia
         no-lock no-error.

    if avail contrato-imp then do:
        
        assign RowObject.cod-docto = "10".

            for each tt-integra-cta-corren-2 exclusive-lock:
                delete tt-integra-cta-corren-2.
            end.

            for each tt-integra-cta-corren exclusive-lock:
                delete tt-integra-cta-corren.
            end.

            for each tt-integra-fluxo exclusive-lock:
                delete tt-integra-fluxo.
            end.

            for each tt-erro exclusive-lock:
                delete tt-erro.
            end.

            if ptype = "CREATE":U  then do:
                
                find last bfcontr-despesa-imp where 
                          bfcontr-despesa-imp.ep-codigo     = contrato-imp.ep-codigo     and
                          bfcontr-despesa-imp.cod-estabel   = contrato-imp.cod-estabel   and
                          bfcontr-despesa-imp.referencia    = contrato-imp.referencia    and
                          bfcontr-despesa-imp.dt-referencia = contrato-imp.dt-referencia 
                          no-lock no-error.
                if avail bfcontr-despesa-imp then 
                    assign seq = bfcontr-despesa-imp.sequencia + 10.
                else 
                    assign seq = 10.
            end.

            if ptype = "UPDATE":U  then do:

                find bfcontr-despesa-imp where 
                     bfcontr-despesa-imp.ep-codigo     = RowObject.ep-codigo     and
                     bfcontr-despesa-imp.cod-estabel   = RowObject.cod-estabel   and
                     bfcontr-despesa-imp.referencia    = RowObject.referencia    and
                     bfcontr-despesa-imp.dt-referencia = RowObject.dt-referencia AND
                     bfcontr-despesa-imp.sequencia     = RowObject.sequencia
                     no-lock no-error.
                assign seq = bfcontr-despesa-imp.sequencia.
                run pi-altera-contr-despesa-imp.
            end.

            assign p-portador   = 0
                   p-modalidade = 0.

            assign p-num-id = integer(string(string(contrato-imp.num-id-contrato-imp) + string(seq))).
            
            create tt-integra-cta-corren-2.
            assign tt-integra-cta-corren-2.tta-cod-modul-dtsul            = "MEC"
                   tt-integra-cta-corren-2.tta-ind-tip-movto-cta-corren   = "RE" /* Realizado */
                   tt-integra-cta-corren-2.tta-ind-fluxo-movto-cta-corren = "SAI"
                   tt-integra-cta-corren-2.tta-val-movto-cta-corren       = RowObject.valor-movto
                   tt-integra-cta-corren-2.ttv-ind-finalid-integr         = "Criaá∆o"
                   tt-integra-cta-corren-2.tta-num-id-tt-movto-ap-cr      = p-num-id
                   tt-integra-cta-corren-2.tta-estab                      = contrato-imp.cod-estabel
                   tt-integra-cta-corren-2.tta-portador                   = p-portador
                   tt-integra-cta-corren-2.tta-modalidade                 = p-modalidade
                   tt-integra-cta-corren-2.tta-cod-moeda                  = 0
                   tt-integra-cta-corren-2.tta-dat-movto-cta-corren       = RowObject.dt-movto
                   tt-integra-cta-corren-2.tta-cod-docto-movto-cta-bco    = /*"1" /* Fixo */ */ RowObject.nr-docto-emp
                   tt-integra-cta-corren-2.tta-chave-des-banc             = ""
                   tt-integra-cta-corren-2.tta-cod-tip-trans-cx           = &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN RowObject.cod-tip-trans-cx &ELSE "92" &ENDIF
                   tt-integra-cta-corren-2.tta-ind-orig-movto             = "IMP"
                   tt-integra-cta-corren-2.tta-cod-banco                  = RowObject.banco
                   tt-integra-cta-corren-2.tta-cod-agencia                = RowObject.agencia
                   tt-integra-cta-corren-2.tta-cod-cta-corren             = RowObject.cta-corrente
                   tt-integra-cta-corren-2.tta-val-movto-cta-corren-me    = RowObject.valor-movto /*suzana*/
                   tt-integra-cta-corren-2.tta-val-cotacao                = 1 /*suzana*/
                   tt-integra-cta-corren-2.tta-conta-contabil             = c-conta-contabil
                   tt-integra-cta-corren-2.tta-ct-codigo                  = v-ct-codigo
                   tt-integra-cta-corren-2.tta-sc-codigo                  = v-sc-codigo
                   &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
                       tt-integra-cta-corren-2.tta-cod-unid-negoc         = ""
                   &ENDIF
                   .

            create tt-integra-fluxo.
            assign tt-integra-fluxo.tp-codigo         = i-tp-desp-rec
                   tt-integra-fluxo.conta-contabil    = c-conta-contabil
                   tt-integra-fluxo.ct-conta          = v-ct-codigo
                   tt-integra-fluxo.sc-conta          = v-sc-codigo
                   tt-integra-fluxo.vl-movto-fluxo    = RowObject.valor-movto
                   tt-integra-fluxo.vl-movto-fluxo-me = RowObject.valor-movto
                   tt-integra-fluxo.moeda             = 0
                   tt-integra-fluxo.cotacao-dia       = 1
                   tt-integra-fluxo.cod-estabel       = contrato-imp.cod-estabel
                   tt-integra-fluxo.dt-fluxo          = RowObject.dt-movto
                   tt-integra-fluxo.dt-emissao        = RowObject.dt-movto
                   tt-integra-fluxo.modulo-origem     = "MEC"
                   tt-integra-fluxo.ind-orig-movto    = "MOV"
                   tt-integra-fluxo.num-id-orig-movto = p-num-id
                   tt-integra-fluxo.cod-funcao        = "Inclus∆o"
                   tt-integra-fluxo.ind-fluxo-movto   = "SAI"
                   tt-integra-fluxo.ind-tipo-movto    = "RE"
                   tt-integra-fluxo.chave-des-banc    = ""
                   tt-integra-fluxo.unid-negoc        = ""
                   tt-integra-fluxo.num-seq           = 1
                   &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
                       tt-integra-fluxo.cod-tip-trans-cx  = RowObject.cod-tip-trans-cx
                       tt-integra-fluxo.cod-cta-corren    = RowObject.cta-corrente
                   &ENDIF
                   .

            run cdp/cdapi533a.p (input        table tt-integra-fluxo,
                                 input        table tt-integra-fluxo-conta,
                                 input        table tt-integra-cta-corren-2,
                                 input-output table tt-erro).

            for each tt-erro:
                
                assign i-seq-erro = i-seq-erro + 10.
                create RowErrors.
                assign RowErrors.ErrorSequence    = i-seq-erro
                       RowErrors.ErrorNumber      = tt-erro.cd-erro
                       RowErrors.ErrorParameters  = ""
                       RowErrors.ErrorType        = ""
                       RowErrors.ErrorSubType     = "ERROR"
                       RowErrors.ErrorDescription = tt-erro.mensagem
                       RowErrors.ErrorHelp        = tt-erro.mensagem.
            end.

    end.

    /*--- Verifica ocorrància de erros ---*/
    if can-find(first RowErrors where RowErrors.ErrorSubType = "ERROR":U) then
        return "NOK":U.
    
    return "OK":U.

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
    def var c-usuario like contr-despesa-imp.usuario no-undo.

    {method/svc/autentic/autentic.i
            &vUserName="c-usuario"}

    assign RowObject.usuario  = c-usuario
           RowObject.c-time   = string(TIME, "HH:MM")
           RowObject.dt-today = today.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-campos-ems2-cfl DBOProgram 
PROCEDURE pi-busca-campos-ems2-cfl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param p-num-id-contrato as integer no-undo.
    def input-output param table for tt_campos_mec_cfl.

    find first contr-despesa-imp no-lock
        where contr-despesa-imp.int-1 = p-num-id-contrato no-error.
    if avail contr-despesa-imp then do:
        find first contrato-imp no-lock
             where contrato-imp.ep-codigo     = contr-despesa-imp.ep-codigo
             and   contrato-imp.cod-estabel   = contr-despesa-imp.cod-estabel
             and   contrato-imp.referencia    = contr-despesa-imp.referencia
             and   contrato-imp.dt-referencia = contr-despesa-imp.dt-referencia no-error.
        if avail contrato-imp then do:
            create tt_campos_mec_cfl.
            assign tt_campos_mec_cfl.ttv_cod_estab_ext           = contrato-imp.cod-estabel
                   tt_campos_mec_cfl.ttv_cod_empresa_ext         = string(contrato-imp.ep-codigo)
                   tt_campos_mec_cfl.ttv_cod_contrat_2           = contrato-imp.nr-contrato
                   tt_campos_mec_cfl.ttv_dat_contrat             = contrato-imp.dt-contrato
                   tt_campos_mec_cfl.ttv_cod_refer               = contrato-imp.referencia
                   tt_campos_mec_cfl.ttv_dat_refer               = contrato-imp.dt-referencia
                   tt_campos_mec_cfl.tta_cod_modul_integr        = "IMP"
                   tt_campos_mec_cfl.ttv_val_despes_mec          = contr-despesa-imp.valor-movto    
                   tt_campos_mec_cfl.ttv_cod_docto_empres_despes = contr-despesa-imp.nr-docto-emp.
        end.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-integra-fluxo-despes-imp DBOProgram 
PROCEDURE pi-integra-fluxo-despes-imp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &IF "{&mguni_version}" >= "2.07A" &THEN
        def input param p-cdn-empresa LIKE empresa.ep-codigo format "x(03)" no-undo.
    &ELSE
        def input    param p-cdn-empresa as int format ">>9" no-undo.
    &ENDIF
    def input        param p-dat-inic    as date             no-undo.
    def input        param p-dat-fim     as date             no-undo.
    def input-output param table for tt_integr_mec_cfl_despes.
    def input-output param table for tt_erro_mec.

    def var i-num-seq as int no-undo.

    for each tt-integra-fluxo:
        delete tt-integra-fluxo.
    end.

    for each tt-integra-fluxo-conta:
        delete tt-integra-fluxo-conta.
    end.

    for each tt-integra-cta-corren-2:
        delete tt-integra-cta-corren-2.
    end.

    for each tt-integra-cta-corren:
        delete tt-integra-cta-corren.
    end.

    for each tt-erro:
        delete tt-erro.
    end.

    assign i-num-seq = 0.

    for each contr-despesa-imp where
             contr-despesa-imp.ep-codigo = p-cdn-empresa and
             contr-despesa-imp.dt-movto >= p-dat-inic    and
             contr-despesa-imp.dt-movto <= p-dat-fim
             no-lock:

        find first contrato-imp where
                   contrato-imp.ep-codigo     = contr-despesa-imp.ep-codigo   and
                   contrato-imp.cod-estabel   = contr-despesa-imp.cod-estabel and
                   contrato-imp.referencia    = contr-despesa-imp.referencia  and
                   contrato-imp.dt-referencia = contr-despesa-imp.dt-referencia
                   no-lock no-error.
        if avail contrato-imp then do:

            assign i-num-seq = i-num-seq + 1.

            create tt-integra-fluxo.
            assign tt-integra-fluxo.tp-codigo         = contr-despesa-imp.dec-1
                   tt-integra-fluxo.conta-contabil    = ""
                   tt-integra-fluxo.vl-movto-fluxo    = contr-despesa-imp.valor-movto
                   tt-integra-fluxo.vl-movto-fluxo-me = contr-despesa-imp.valor-movto
                   tt-integra-fluxo.moeda             = 0
                   tt-integra-fluxo.cotacao-dia       = 1
                   tt-integra-fluxo.cod-estabel       = contr-despesa-imp.cod-estabel
                   tt-integra-fluxo.dt-fluxo          = contr-despesa-imp.dt-movto
                   tt-integra-fluxo.dt-emissao        = contr-despesa-imp.dt-movto
                   tt-integra-fluxo.modulo-origem     = "MEC"
                   tt-integra-fluxo.ind-orig-movto    = "MOV"
                   tt-integra-fluxo.num-id-orig-movto = integer(string(string(contrato-imp.num-id-contrato-imp) + string(contr-despesa-imp.sequencia)))
                   tt-integra-fluxo.cod-funcao        = "Inclus∆o"
                   tt-integra-fluxo.ind-fluxo-movto   = "SAI"
                   tt-integra-fluxo.ind-tipo-movto    = "RE"
                   tt-integra-fluxo.chave-des-banc    = ""
                   tt-integra-fluxo.unid-negoc        = ""
                   tt-integra-fluxo.num-seq           = i-num-seq
                   .

            &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN

                assign tt-integra-fluxo.cod-tip-trans-cx = contr-despesa-imp.cod-tip-trans-cx
                       tt-integra-fluxo.cod-cta-corren   = contr-despesa-imp.cta-corrente
                       tt-integra-fluxo.conta-contabil   = ""
                       tt-integra-fluxo.ct-conta         = ""
                       tt-integra-fluxo.sc-conta         = ""
                       .

            &ELSE

                if  contr-despesa-imp.char-1 <> "" and
                    contr-despesa-imp.char-1 <> ?  and
                    num-entries(contr-despesa-imp.char-1) >= 2 then
                    assign tt-integra-fluxo.conta-contabil = entry(2, contr-despesa-imp.char-1, ",").

                find first conta-contab where
                           conta-contab.ep-codigo      = contr-despesa-imp.ep-codigo     and
                           conta-contab.conta-contabil = tt-integra-fluxo.conta-contabil
                           no-lock no-error.
                if avail conta-contab then
                    assign tt-integra-fluxo.ct-conta = conta-contab.ct-codigo
                           tt-integra-fluxo.sc-conta = conta-contab.sc-codigo.

            &ENDIF

            create tt_integr_mec_cfl_despes.
            assign tt_integr_mec_cfl_despes.tta_cod_estab_contrat_cambio   = contrato-imp.cod-estabel
                   tt_integr_mec_cfl_despes.tta_cod_contrat_cambio         = contrato-imp.nr-contrato
                   tt_integr_mec_cfl_despes.tta_cod_refer_contrat_cambio   = contrato-imp.referencia
                   tt_integr_mec_cfl_despes.tta_dat_refer_contrat_cambio   = contrato-imp.dt-referencia
                   tt_integr_mec_cfl_despes.ttv_val_despes_mec             = tt-integra-fluxo.vl-movto-fluxo
                   tt_integr_mec_cfl_despes.ttv_num_tip_despes_mec         = tt-integra-fluxo.tp-codigo 
                   tt_integr_mec_cfl_despes.tta_num_id_orig_movto_fluxo_cx = tt-integra-fluxo.num-id-orig-movto
                   tt_integr_mec_cfl_despes.ttv_cod_docto_empres_despes    = contr-despesa-imp.nr-docto-emp.
        end.
    end.

    if can-find (first tt-integra-fluxo) then do:
        run cdp/cdapi533a.p (input table  tt-integra-fluxo,
                             input table  tt-integra-fluxo-conta,
                             input table  tt-integra-cta-corren-2,
                             input-output table tt-erro).

        if can-find (first tt-erro) then do:
            for each tt-erro:
                create tt_erro_mec.
                assign tt_erro_mec.ttv_num_seq           = tt-erro.i-sequen
                       tt_erro_mec.ttv_cod_erro_ems2     = tt-erro.cd-erro
                       tt_erro_mec.ttv_des_msg_erro_ems2 = tt-erro.mensagem.
            end.
        end.
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
    
    def input param pnr-docto-banco   like tt-movto-banco.nr-docto-banco   no-undo.
    def input param pconta-contabil   like tt-movto-banco.conta-contabil   no-undo.
    def input param pcod-lancto       like tt-movto-banco.cod-lancto       no-undo.
    def input param ptp-desp-rec      like tt-movto-banco.tp-desp-rec      no-undo.
    def input param phistorico        like tt-movto-banco.historico        no-undo.
    def input param pnr-docto-emp-ant like tt-movto-banco.nr-docto-emp-ant no-undo.
    def input param pcod-docto-ant    like tt-movto-banco.cod-docto-ant    no-undo.
    def input param pda-movto-ant     like tt-movto-banco.dt-movto-ant     no-undo.
       
    assign c-nr-docto-banco   = pnr-docto-banco
           c-conta-contabil   = pconta-contabil 
           i-cod-lancto       = pcod-lancto
           i-tp-desp-rec      = ptp-desp-rec
           c-historico        = phistorico
           c-nr-docto-emp-ant = pnr-docto-emp-ant
           c-cod-docto-ant    = pcod-docto-ant
           da-movto-ant       = pda-movto-ant.
           
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
    
  def input parameter i-banco          like contr-despesa-imp.banco         no-undo.
  def input parameter c-agencia        like contr-despesa-imp.Agencia       no-undo.
  def input parameter c-cta-cor        like contr-despesa-imp.cta-corrente  no-undo.
  def input parameter c-cod-docto      like contr-despesa-imp.cod-docto     no-undo.
  def input parameter c-nr-docto       like contr-despesa-imp.nr-docto-emp  no-undo.
  def input parameter d-dt-movto       like contr-despesa-imp.dt-movto      no-undo.

  def output parameter i-ep-codigo     like contr-despesa-imp.ep-codigo     no-undo.
  def output parameter c-cod-estab     like contr-despesa-imp.cod-estabel   no-undo.
  def output parameter c-referencia    like contr-despesa-imp.referencia    no-undo.
  def output parameter d-dt-referencia like contr-despesa-imp.dt-referencia no-undo. 
  def output parameter i-sequencia     like contr-despesa-imp.sequencia     no-undo. 

  assign &IF "{&mguni_version}" >= "2.07A" &THEN
         i-ep-codigo     = ""
         &ELSE
         i-ep-codigo     = 0
         &ENDIF
         c-cod-estab     = " "
         c-referencia    = " "
         d-dt-referencia = ?
         i-sequencia     = 0.
       
  find first bfcontr-despesa-imp 
       where bfcontr-despesa-imp.banco        = i-banco 
       and   bfcontr-despesa-imp.agencia      = c-agencia
       and   bfcontr-despesa-imp.cta-corrente = c-cta-cor
       and   bfcontr-despesa-imp.cod-docto    = c-cod-docto 
       and   bfcontr-despesa-imp.nr-docto-emp = c-nr-docto
       and   bfcontr-despesa-imp.dt-movto     = d-dt-movto 
       no-lock no-error.

  if avail bfcontr-despesa-imp then
     assign i-ep-codigo     = bfcontr-despesa-imp.ep-codigo
            c-cod-estab     = bfcontr-despesa-imp.cod-estabel
            c-referencia    = bfcontr-despesa-imp.referencia
            d-dt-referencia = bfcontr-despesa-imp.dt-referencia
            i-sequencia     = bfcontr-despesa-imp.sequencia.
    
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
    
    DEFINE INPUT PARAMETER pep-codigo     LIKE contr-despesa-imp.ep-codigo     NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel   LIKE contr-despesa-imp.cod-estabel   NO-UNDO.
    DEFINE INPUT PARAMETER preferencia    LIKE contr-despesa-imp.referencia    NO-UNDO.
    DEFINE INPUT PARAMETER pdt-referencia LIKE contr-despesa-imp.dt-referencia NO-UNDO.
    
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

    if ptype = "Create":U then do:
        find first contrato-imp where 
                   contrato-imp.ep-codigo     = RowObject.ep-codigo   and 
                   contrato-imp.cod-estabel   = RowObject.cod-estabel and 
                   contrato-imp.referencia    = RowObject.referencia  and 
                   contrato-imp.dt-referencia = RowObject.dt-referencia no-lock no-error.
        {utp/ut-liter.i despesa *}
        assign c-string1 = return-value.
        
        if not avail contrato-imp then                  
            {method/svc/errors/inserr.i &ErrorNumber="19421"
                                        &ErrorType="EMS"
                                        &ErrorParameters="c-string1"}

        &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
            run prgfin\cmg\cmg900wd.py persistent set h-bo-cta-corren.
            run pi_vld_info_cta_corren in h-bo-cta-corren (input RowObject.cta-corrente,
                                                           output table tt_log_erro).
            run pi-inserir-erros-tt (input-output table tt_log_erro).
            delete procedure h-bo-cta-corren.
        &ELSE
            if can-find (cta-corrente where
                         cta-corrente.cod-banco    = RowObject.banco and
                         cta-corrente.agencia      = RowObject.agencia and
                         cta-corrente.conta-corren = RowObject.cta-corrente) = no then
                {method/svc/errors/inserr.i &ErrorNumber="42"
                                            &ErrorType="EMS"
                                            &ErrorParameters="''"}
        &ENDIF

    end.

    if ptype = "Create":U or 
       ptype = "Update":U then do:
            
        run pi-autenticacao.

        if 
                RowObject.cta-corrente     = "" or
                RowObject.dt-movto         = ?  or
                RowObject.valor-movto      = 0  or
                RowObject.nr-docto-emp     = "" or
           &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
                RowObject.cod-tip-trans-cx = "" or
           &ENDIF
                RowObject.cod-docto        = "" then
            {method/svc/errors/inserr.i &ErrorNumber="19350"
                                        &ErrorType="EMS"
                                        &ErrorParameters="''"}  /*TODOS OS DADOS DEVEM SER PREENCHIDOS*/

        &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
            run prgfin\cmg\cmg900we.py persistent set h-bo-tip-trans-cx.
            run pi_vld_info_tip_trans_cx in h-bo-tip-trans-cx (input RowObject.cod-tip-trans-cx,
                                                               output table tt_log_erro).
            run pi-inserir-erros-tt (input-output table tt_log_erro).
            delete procedure h-bo-tip-trans-cx.
        &ENDIF
        
        if avail contrato-imp and
            RowObject.dt-movto < contrato-imp.dt-referencia then
            {method/svc/errors/inserr.i &ErrorNumber="26117"
                                        &ErrorType="EMS"
                                        &ErrorParameters="''"}  /*Data do Movimento deve ser menor que a referencia do contrato */
                      
        if not can-find(tipo-rec-desp where 
                        tipo-rec-desp.tp-codigo = i-tp-desp-rec) then
            {method/svc/errors/inserr.i &ErrorNumber="17967"
                                        &ErrorType="EMS"
                                        &ErrorParameters="i-tp-desp-rec"}

    end.

    if ptype = "Delete":U then do:


    end.
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    if ptype = "Create":U or 
       ptype = "Update":U then do:    
       
       run pi-atualiza-cb (input pType).
       if return-value = "NOK":U then
          return "NOK":U.       
    end.      
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

