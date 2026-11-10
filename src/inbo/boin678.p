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
{include/i-prgvrs.i BOIN678 2.00.00.011 } /*** "010011" 17/06/2025 16:40:51 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin678 MUT}
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
&GLOBAL-DEFINE DBOName            BOIN678
&GLOBAL-DEFINE DBOVersion         1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName          matriz-rat-med
&GLOBAL-DEFINE TableLabel         
&GLOBAL-DEFINE QueryName          qr{&TableName} 

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{cdp/cdcfgmat.i}
{inbo/boin678.i RowObject}

/* Defini‡Æo de Temp-Table  tt-matriz  --- */
DEFINE TEMP-TABLE tt-matriz NO-UNDO 
       field nr-contrato       as inte format  ">>>>>>>>9"
       field num-seq-item      as inte format  ">,>>9"
       field numero-ordem      as inte format  "zzzzz9,99"
       field num-seq-event     as inte format  ">,>>9"
       field num-seq-medicao   as inte format  ">,>>9"
       field ct-codigo         as char format  "X(20)"
       field sc-codigo         as char format  "X(20)"
       field cod-unid-negoc    as char format  "X(03)"
       field titulo            as char format  "X(32)"
       field titulo-cc         as char format  "X(32)"
       field int-1             as int  format  ">>>,>>>,>>9":U
       field valor-acum        as deci format  ">>>>>,>>>,>>9.99"
       field perc-rateio       as deci format  ">>9.99"
       index ch-conta as unique primary
             nr-contrato
             num-seq-item
             numero-ordem
             num-seq-event
             num-seq-medicao
             ct-codigo
             sc-codigo
             cod-unid-negoc.
/*----------------------------*/
def var v_des_ccusto       as char   no-undo.
def var h_api_ccusto       as handle no-undo.
def var h_api_cta_ctbl     as handle no-undo.
def var v_cod_cta_ctbl     as char   no-undo.
def var v_des_cta_ctbl     as char   no-undo.
def var v_num_tip_cta_ctbl as int    no-undo.
def var v_num_sit_cta_ctbl as int    no-undo.
def var v_ind_finalid_cta  as char   no-undo.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¼ncia"
    .

/*-- Defini‡Æo de Variaveis ----*/
DEFINE VARIABLE i-nr-contrat   AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-num-seq-item AS INTEGER    NO-UNDO.
DEFINE VARIABLE d-valor        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE d-dat-medicao  LIKE medicao-contrat.dat-medicao  NO-UNDO.
DEFINE VARIABLE i-moeda-param  AS INTEGER FORMAT ">9" NO-UNDO.
/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}
{cdp/cd9731.i8}

&IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
    {cdp/cd9590.i}    /*Include verifica‡Æo Unidade Neg¢cio*/
&ENDIF

/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

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
         HEIGHT             = 6.42
         WIDTH              = 44.72.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "conta-contabil":U THEN ASSIGN pFieldValue = RowObject.conta-contabil.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "perc-rateio":U THEN ASSIGN pFieldValue = RowObject.perc-rateio.
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
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "num-seq-event":U THEN ASSIGN pFieldValue = RowObject.num-seq-event.
        WHEN "num-seq-item":U THEN ASSIGN pFieldValue = RowObject.num-seq-item.
        WHEN "num-seq-medicao":U THEN ASSIGN pFieldValue = RowObject.num-seq-medicao.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
        WHEN "nr-ord-produ":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        &ENDIF
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice ch-matriz-med
  Parameters:  
               retorna valor do campo nr-contrato
               retorna valor do campo num-seq-item
               retorna valor do campo numero-ordem
               retorna valor do campo num-seq-event
               retorna valor do campo num-seq-medicao
               retorna valor do campo conta-contabil
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-contrato LIKE matriz-rat-med.nr-contrato NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-item LIKE matriz-rat-med.num-seq-item NO-UNDO.
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE matriz-rat-med.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-event LIKE matriz-rat-med.num-seq-event NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-medicao LIKE matriz-rat-med.num-seq-medicao NO-UNDO.
    DEFINE OUTPUT PARAMETER pconta-contabil LIKE matriz-rat-med.conta-contabil NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-contrato = RowObject.nr-contrato
           pnum-seq-item = RowObject.num-seq-item
           pnumero-ordem = RowObject.numero-ordem
           pnum-seq-event = RowObject.num-seq-event
           pnum-seq-medicao = RowObject.num-seq-medicao
           pconta-contabil = RowObject.conta-contabil.

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
  Purpose:     Reposiciona registro com base no ¡ndice ch-matriz-med
  Parameters:  
               recebe valor do campo nr-contrato
               recebe valor do campo num-seq-item
               recebe valor do campo numero-ordem
               recebe valor do campo num-seq-event
               recebe valor do campo num-seq-medicao
               recebe valor do campo ct-codigo
               recebe valor do campo sc-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-contrato     LIKE matriz-rat-med.nr-contrato NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-item    LIKE matriz-rat-med.num-seq-item NO-UNDO.
    DEFINE INPUT PARAMETER pnumero-ordem    LIKE matriz-rat-med.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-event   LIKE matriz-rat-med.num-seq-event NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-medicao LIKE matriz-rat-med.num-seq-medicao NO-UNDO.
    DEFINE INPUT PARAMETER pct-codigo AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER psc-codigo AS CHAR NO-UNDO.

    FIND FIRST bfmatriz-rat-med WHERE 
        bfmatriz-rat-med.nr-contrato     = pnr-contrato     AND 
        bfmatriz-rat-med.num-seq-item    = pnum-seq-item    AND 
        bfmatriz-rat-med.numero-ordem    = pnumero-ordem    AND 
        bfmatriz-rat-med.num-seq-event   = pnum-seq-event   AND 
        bfmatriz-rat-med.num-seq-medicao = pnum-seq-medicao AND 
        bfmatriz-rat-med.ct-codigo       = pct-codigo       AND
        bfmatriz-rat-med.sc-codigo       = psc-codigo       NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmatriz-rat-med THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmatriz-rat-med)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
    open query {&queryname} for each {&tablename} no-lock.
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-valor DBOProgram 
PROCEDURE pi-retorna-valor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input  param p-nr-contrato       like matriz-rat-med.nr-contrato    no-undo.
def input  param p-num-seq-item      like matriz-rat-med.num-seq-item   no-undo.
def input  param p-numero-ordem      like matriz-rat-med.numero-ordem   no-undo.
def input  param p-dat-medicao       like medicao-contrat.dat-medicao   no-undo.
def input  param l-conv-g            as logical no-undo.
def input  param i-moeda-g           as integer format ">9" no-undo.
def output param p-it-codigo         like item.it-codigo                no-undo.
def output param p-desc-item         like item.desc-item                no-undo.
def output param p-desc-contrat      like contrato-for.des-contrat      no-undo.
def output param p-cod-estab         like estabelec.cod-estabel         no-undo.
def output param p-desc-estab        like estabelec.nome                no-undo.
def input-output param d-val-medicao like medicao-contrat.val-medicao   no-undo.

assign i-nr-contrat   = p-nr-contrato 
       i-num-seq-item = p-num-seq-item
       d-valor        = d-val-medicao
       d-dat-medicao  = p-dat-medicao
       i-moeda-param  = i-moeda-g.
      
    find first param-global no-lock no-error.
    find first ordem-compra where ordem-compra.numero-ordem = p-numero-ordem no-lock no-error.
    
    find contrato-for 
        where contrato-for.nr-contrato = p-nr-contrato no-lock no-error.
    if avail contrato-for then
        assign p-desc-contrat = contrato-for.des-contrat.

    
    find estabelec 
       where estabelec.cod-estabel = ordem-compra.cod-estabel no-lock no-error.
    if avail estabelec then
        assign p-cod-estab  = estabelec.cod-estabel
               p-desc-estab = estabelec.nome.

    
    find item where item.it-codigo = ordem-compra.it-codigo no-lock no-error.
    if  avail item then do:
        assign p-it-codigo = item.it-codigo
               p-desc-item = item.desc-item.
        
        if  item.it-codigo  = "" and
            item.tipo-contr = 4 then do: /*debito direto*/

            find item-contrat where
                 item-contrat.nr-contrato  = p-nr-contrato  and
                 item-contrat.num-seq-item = p-num-seq-item no-lock no-error.
            
            if  avail item-contrat then
                assign p-desc-item = item-contrat.narrat-item.
        end.
    end.
    
    &if defined (bf_mat_contrato_moedas) &then
        if  contrato-for.mo-codigo <> i-moeda-param then do:
            run cdp/cd0812.p (input  contrato-for.mo-codigo,
                              input  i-moeda-g,
                              input  d-val-medicao,
                              input  p-dat-medicao,
                              output d-val-medicao).
    
            if  d-val-medicao = ? then
                assign d-val-medicao = 0.
        end.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valor-browse DBOProgram 
PROCEDURE pi-valor-browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-numero-ordem    LIKE matriz-rat-med.numero-ordem     NO-UNDO.
    DEF INPUT  PARAM p-num-seq-event   LIKE matriz-rat-med.num-seq-event    NO-UNDO.
    DEF INPUT  PARAM p-num-seq-medicao LIKE matriz-rat-med.num-seq-medicao  NO-UNDO.
    DEF OUTPUT PARAMETER TABLE FOR tt-matriz. 
    
    def var i-empresa    like param-global.empresa-prin no-undo.
    def var c-formato-conta  as char no-undo.
    def var c-formato-ccusto as char no-undo.

    run prgint/utb/utb742za.py persistent set h_api_ccusto.
    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

    for each tt-matriz:
        delete tt-matriz.
    end.
    
    find first param-global no-lock no-error.
    find first contrato-for 
         where contrato-for.nr-contrato = i-nr-contrat no-lock no-error.
    
    if  avail contrato-for then do:
        for first estabelec fields(cod-estabel ep-codigo) where
             estabelec.cod-estabel = contrato-for.cod-estabel no-lock: end.
        if avail estabelec THEN
            assign i-empresa = estabelec.ep-codigo.
    end.
    
    for each matriz-rat-med
        where matriz-rat-med.nr-contrato      = i-nr-contrat
          and matriz-rat-med.num-seq-item    = i-num-seq-item
          and matriz-rat-med.numero-ordem    = p-numero-ordem
          and matriz-rat-med.num-seq-event   = p-num-seq-event
          and matriz-rat-med.num-seq-medicao = p-num-seq-medicao no-lock:
                                       
        run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,                /* EMPRESA EMS2 */
                                                   input  "",                       /* CODIGO DO PLANO CCUSTO */
                                                   input  matriz-rat-med.sc-codigo, /* CCUSTO */
                                                   input  today,                    /* DATA DE TRANSACAO */
                                                   output v_des_ccusto,             /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro).       /* ERROS */
                                                   
        /* Retorna formato do centro de custo */
        run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                                   input  "",                 /* PLANO CCUSTO */
                                                   input  TODAY,              /* DATA DE TRANSACAO */
                                                   output c-formato-ccusto,   /* FORMATO CCUSTO */
                                                   output table tt_log_erro). /* ERROS */                                           

        assign v_cod_cta_ctbl = matriz-rat-med.ct-codigo.
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,          /* EMPRESA EMS2 */
                                                       input        "",                 /* PLANO DE CONTAS */
                                                       input-output v_cod_cta_ctbl,     /* CONTA */
                                                       input        today,              /* DATA TRANSACAO */   
                                                       output       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                       output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                       output       v_num_sit_cta_ctbl, /* SITUA°€O DA CONTA */
                                                       output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                       output table tt_log_erro).       /* ERROS */ 
                                                       
        run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,          /* EMPRESA EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  TODAY,              /* DATA DE TRANSACAO */
                                                       output c-formato-conta,    /* FORMATO CONTA */
                                                       output table tt_log_erro). /* ERROS */                                               
        
        FIND FIRST tt_log_erro NO-ERROR.
                
        if NOT AVAIL tt_log_erro then do:
            
            create tt-matriz.
            assign tt-matriz.nr-contrato     = matriz-rat-med.nr-contrato     
                   tt-matriz.num-seq-item    = matriz-rat-med.num-seq-item   
                   tt-matriz.numero-ordem    = matriz-rat-med.numero-ordem   
                   tt-matriz.num-seq-event   = matriz-rat-med.num-seq-event  
                   tt-matriz.num-seq-medicao = matriz-rat-med.num-seq-medicao
                   tt-matriz.titulo          = v_des_cta_ctbl
                   tt-matriz.titulo-cc       = v_des_ccusto
                   tt-matriz.perc-rateio     = matriz-rat-med.perc-rateio
                   tt-matriz.valor-acum      = d-valor * matriz-rat-med.perc-rateio / 100
                   tt-matriz.ct-codigo       = string(matriz-rat-med.ct-codigo,c-formato-conta)
                   tt-matriz.sc-codigo       = string(matriz-rat-med.sc-codigo,c-formato-ccusto).    

            if l-spp-integra-cn-mi-med then
               assign tt-matriz.int-1 = matriz-rat-med.int-1.

            &if defined (bf_mat_contrato_moedas) &then
                if  contrato-for.mo-codigo <> i-moeda-param then do:
                    run cdp/cd0812.p (input  contrato-for.mo-codigo,
                                      input  i-moeda-param,
                                      input  tt-matriz.valor-acum,
                                      input  d-dat-medicao,
                                      output tt-matriz.valor-acum).
            
                    if  tt-matriz.valor-acum = ? then
                        assign tt-matriz.valor-acum = 0.
                end.
            &endif
            
            &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
             IF  l-unidade-negocio THEN
                 ASSIGN tt-matriz.cod-unid-negoc = matriz-rat-med.cod-unid-negoc.
            &ENDIF
        end.
    end.

    delete object h_api_ccusto.
    delete object h_api_cta_ctbl.

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
    return "OK":U.
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

