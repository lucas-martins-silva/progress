{include/i-prgvrs.i BOIN01105 2.00.00.009 } /*** "010009" 13/11/2023 11:45:46 ***/
{include/i-license-manager.i boin01105 MRE}

&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
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
&GLOBAL-DEFINE DBOName BOIN01105
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName rat-despes-cte
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin01105.i RowObject}
{utp/ut-glob.i}

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

define variable c-empresa           LIKE empresa.ep-codigo                NO-UNDO.
define variable h_api_cta_ctbl      AS HANDLE                             NO-UNDO.
define variable h_api_ccusto        AS HANDLE                             NO-UNDO.
DEFINE VARIABLE h-cdapi024          AS HANDLE                             NO-UNDO.
DEFINE VARIABLE l-receb-unid-negoc  AS LOGICAL                            NO-UNDO.
DEFINE VARIABLE l-unidade-negocio   AS LOGICAL                            NO-UNDO.
DEFINE VARIABLE l-mat-unid-negoc    AS LOGICAL                            NO-UNDO.
DEFINE VARIABLE lHiddenUnidNeg      AS LOGICAL                            NO-UNDO.
DEFINE VARIABLE cChave              LIKE docto-orig-cte.cod-aces-comp-nfe NO-UNDO.
DEFINE VARIABLE cCtCodigo           LIKE rat-despes-cte.ct-codigo         NO-UNDO.
DEFINE VARIABLE cCCusto             LIKE rat-despes-cte.sc-codigo         NO-UNDO.

def temp-table tt_log_erro no-undo
         field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Numero" column-label "Numero"
         field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
         field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistencia".

DEF TEMP-TABLE tt-erro-aux NO-UNDO
        FIELD i-sequenc AS INT
        FIELD cd-erro   AS INT
        FIELD mensagem  AS CHAR FORMAT "x(255)".

/* Variÿveis conta ctbl */
def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.
def var i-num-finalid-cta    as int    no-undo.
/* Variÿveis centro de custo */ 
def var v_cod_ccusto         as char   no-undo.
def var v_titulo_ccusto      as char   no-undo.
def var v_log_utz_ccusto     as log    no-undo.


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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-aces-comp-nfe":U THEN ASSIGN pFieldValue = RowObject.cod-aces-comp-nfe.
        WHEN "cod-unid-negoc":U THEN ASSIGN pFieldValue = RowObject.cod-unid-negoc.
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
        WHEN "val-rateio":U THEN ASSIGN pFieldValue = RowObject.val-rateio.
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
        WHEN "num-seq":U THEN ASSIGN pFieldValue = RowObject.num-seq.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice rtdspsct_id2
  Parameters:  
               retorna valor do campo cod-aces-comp-nfe
               retorna valor do campo num-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-aces-comp-nfe LIKE rat-despes-cte.cod-aces-comp-nfe NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq LIKE rat-despes-cte.num-seq NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-aces-comp-nfe = RowObject.cod-aces-comp-nfe
           pnum-seq = RowObject.num-seq.

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
  Purpose:     Reposiciona registro com base no ¡ndice rtdspsct_id2
  Parameters:  
               recebe valor do campo cod-aces-comp-nfe
               recebe valor do campo num-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-aces-comp-nfe LIKE rat-despes-cte.cod-aces-comp-nfe NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq LIKE rat-despes-cte.num-seq NO-UNDO.

    FIND FIRST bfrat-despes-cte WHERE 
        bfrat-despes-cte.cod-aces-comp-nfe = pcod-aces-comp-nfe AND 
        bfrat-despes-cte.num-seq = pnum-seq NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrat-despes-cte THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrat-despes-cte)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDadosConta DBOProgram 
PROCEDURE getDadosConta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAM p-desc-conta AS CHAR NO-UNDO.

    ASSIGN p-desc-conta = ''.

    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

    EMPTY TEMP-TABLE tt_log_erro.
    FIND FIRST docto-orig-cte 
         WHERE docto-orig-cte.cod-aces-comp-nfe = cChave
           AND docto-orig-cte.idi-orig-trad     = 2 NO-LOCK NO-ERROR.

    RUN setEmpresaDocto (INPUT IF AVAIL docto-orig-cte THEN docto-orig-cte.cod-estabel ELSE ""). //c-empresa

    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        c-empresa,                /* EMPRESA EMS2 */
                                                   input        "",                       /* PLANO DE CONTAS */
                                                   input-output cCtCodigo,                /* CONTA */
                                                   input        docto-orig-cte.dt-trans,  /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,        /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl,       /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl,       /* SITUA°€O DA CONTA */
                                                   output       v_ind_finalid_cta,        /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).             /* ERROS */ 

    delete object h_api_cta_ctbl.
    
    IF RETURN-VALUE = "NOK" THEN
        RETURN "NOK".

    ASSIGN p-desc-conta =  v_titulo_cta_ctbl.
    

    RETURN "ok".
    FINALLY:
        DELETE PROCEDURE h_api_cta_ctbl NO-ERROR.
        ASSIGN h_api_cta_ctbl = ?.
    END FINALLY.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescricaoCC DBOProgram 
PROCEDURE getDescricaoCC :
    DEFINE OUTPUT PARAM pDescricaoCC AS CHAR NO-UNDO.

    IF NOT VALID-HANDLE(h_api_ccusto) 
         OR h_api_ccusto:type      <> "PROCEDURE":U 
         OR h_api_ccusto:file-name <> "prgint/utb/utb742za.py":U then
            run prgint/utb/utb742za.py persistent set h_api_ccusto.

    ASSIGN v_cod_ccusto = cCCusto.
    FIND FIRST docto-orig-cte WHERE docto-orig-cte.cod-aces-comp-nfe = cChave
                                AND docto-orig-cte.idi-orig-trad     = 2 NO-LOCK NO-ERROR.

    RUN setEmpresaDocto (INPUT IF AVAIL docto-orig-cte THEN docto-orig-cte.cod-estabel ELSE ""). //c-empresa

    run pi_busca_dados_ccusto in h_api_ccusto (input  c-empresa,                /* EMPRESA EMS2 */
                                               input  "",                       /* CODIGO DO PLANO CCUSTO */
                                               input  v_cod_ccusto,             /* CCUSTO */
                                               input  docto-orig-cte.dt-trans, /* DATA DE TRANSACAO */
                                               output v_titulo_ccusto,          /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro).       /* ERROS */

    ASSIGN pDescricaoCC = v_titulo_ccusto.

    FINALLY:
        DELETE PROCEDURE h_api_ccusto NO-ERROR.
        ASSIGN h_api_ccusto = ?.
    END FINALLY.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE contaUtilizaCC DBOProgram 
PROCEDURE contaUtilizaCC :
/*------------------------------------------------------------------------------
  Purpose: Retorna se a conta utiliza ou nÆo centro de custo
  Parameters: 
  
  Notes:   RowErrors com os erros do EMS5 caso houver inconsistencia
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM p-l-utiliz    AS LOG INITIAL  NO NO-UNDO.
    DEF OUTPUT PARAM pDescCtCodido AS CHAR INITIAL '' NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR RowErrors.

    DEFINE VARIABLE cDescCtCodigo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cDescCcusto   AS CHARACTER   NO-UNDO.
    EMPTY TEMP-TABLE tt_log_erro.

    FIND FIRST docto-orig-cte WHERE docto-orig-cte.cod-aces-comp-nfe = cChave
                                AND docto-orig-cte.idi-orig-trad     = 2 NO-LOCK NO-ERROR.

    RUN setEmpresaDocto (INPUT IF AVAIL docto-orig-cte THEN docto-orig-cte.cod-estabel ELSE ""). //c-empresa

    IF AVAIL docto-orig-cte AND docto-orig-cte.cod-estabel <> "" THEN DO:
        IF NOT VALID-HANDLE(h_api_ccusto) 
         OR h_api_ccusto:type      <> "PROCEDURE":U 
         OR h_api_ccusto:file-name <> "prgint/utb/utb742za.py":U then
            run prgint/utb/utb742za.py persistent set h_api_ccusto.

        RUN getDadosConta ( OUTPUT cDescCtCodigo).
        ASSIGN pDescCtCodido = cDescCtCodigo.
        RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  c-empresa,                    /* EMPRESA EMS 2 */
                                                           INPUT  docto-orig-cte.cod-estabel,   /* ESTABELECIMENTO EMS2 */
                                                           INPUT  "",                           /* PLANO CONTAS */
                                                           INPUT  cCtCodigo,                    /* CONTA */
                                                           INPUT  docto-orig-cte.dt-trans,      /* DT TRANSACAO */
                                                           OUTPUT p-l-utiliz,                   /* UTILIZA CCUSTO ? */
                                                           OUTPUT TABLE tt_log_erro).           /* ERROS */

        for each tt_log_erro: 
            run _insertErrorManual in this-procedure (input tt_log_erro.ttv_num_cod_erro,   /* pErrorNumber      */
                                                      input "EMS":U,                        /* pErrorType        */
                                                      input "Error":U,                      /* pErrorSubType     */
                                                      input tt_log_erro.ttv_des_msg_erro,   /* pErrorDescription */
                                                      input tt_log_erro.ttv_des_msg_ajuda,  /* pErrorHelp        */
                                                      input "":U).                          /* pErrorParameters  */
        end.
        if can-find(FIRST tt_log_erro) then
            RETURN "NOK":U.
    END.

    RETURN "OK":U.

    FINALLY:
        DELETE PROCEDURE h_api_ccusto NO-ERROR.
        ASSIGN h_api_ccusto = ?.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setChave DBOProgram 
PROCEDURE setChave:
    DEFINE INPUT  PARAM pChave      LIKE RowObject.cod-aces-comp-nfe NO-UNDO.

    ASSIGN cChave = pChave.

    RETURN "OK":U.
END PROCEDURE .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setCtCodigo DBOProgram 
PROCEDURE setCtCodigo:
    DEFINE INPUT  PARAM pCtCodigo     LIKE RowObject.ct-codigo NO-UNDO.

    ASSIGN cCtCodigo = pCtCodigo.
    RETURN "OK":U.
END PROCEDURE .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setCCusto DBOProgram 
PROCEDURE setCCusto:
    DEFINE INPUT  PARAM pCCusto     LIKE RowObject.sc-codigo NO-UNDO.

    ASSIGN cCCusto = pCCusto.
    RETURN "OK":U.
END PROCEDURE .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setHiddenUnidNeg DBOProgram 
PROCEDURE setHiddenUnidNeg:
    DEFINE INPUT  PARAM pHiddenUnidNeg      AS LOG NO-UNDO.
    
    ASSIGN lHiddenUnidNeg = pHiddenUnidNeg.

    RETURN "OK":U.
END PROCEDURE .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE determinaUnidNeg DBOProgram 
PROCEDURE determinaUnidNeg :
/*------------------------------------------------------------------------------
  Purpose: Determina a unidade de neg¢cio    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM pCodUnidNegoc AS CHAR NO-UNDO.

    DEF VAR c-conta         AS CHAR NO-UNDO.

    RUN atualizaVarUnidNeg.

     /* API sugestao unidade de negocio do item. */
    if not valid-handle(h-cdapi024) then
        run cdp/cdapi024.p persistent set h-cdapi024.

    
    FOR FIRST docto-orig-cte 
        WHERE docto-orig-cte.cod-aces-comp-nfe = cChave
          AND docto-orig-cte.idi-orig-trad     = 2 NO-LOCK:
    END.
    IF NOT AVAIL docto-orig-cte THEN
           RETURN "NOK":U.
    FOR FIRST item-docto-orig-cte
        WHERE item-docto-orig-cte.cod-aces-comp-nfe = cChave
          AND item-docto-orig-cte.idi-orig-trad     = 2 NO-LOCK:
    END.
    
    IF NOT AVAIL item-docto-orig-cte THEN
           RETURN "NOK":U.

    FOR FIRST item-uni-estab
        WHERE item-uni-estab.it-codigo   = item-docto-orig-cte.it-codigo
        AND   item-uni-estab.cod-estabel = docto-orig-cte.cod-estabel NO-LOCK:
    END.
    
    IF NOT AVAIL item-uni-estab THEN
        RETURN "NOK":U.

    assign pCodUnidNegoc = ""
           c-conta        = cCtCodigo
           c-conta        = replace(c-conta, ".", "").
    
    IF   lHiddenUnidNeg = NO 
    AND  l-mat-unid-negoc THEN DO:
         run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input docto-orig-cte.cod-estabel,
                                                            input item-uni-estab.it-codigo,
                                                            input item-uni-estab.deposito-pad,
                                                            output pCodUnidNegoc).
         
        
    END.
    
    
    IF VALID-HANDLE(h-cdapi024) THEN DO:
        DELETE PROCEDURE h-cdapi024.
        ASSIGN h-cdapi024 = ?.
    END.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaVarUnidNeg DBOProgram 
PROCEDURE atualizaVarUnidNeg:
    find first param-mat no-lock no-error.
    assign l-mat-unid-negoc = avail param-mat
                              and   param-mat.ind-unid-neg.
    
    /* Funcao unidade de negocio. */
    find first funcao no-lock
        where funcao.cd-funcao = "ems2-unidade-negocio":U
        and   funcao.ativo no-error.
    assign l-receb-unid-negoc  = avail funcao
           l-unidade-negocio   = avail funcao.

    find first param-re no-lock 
        where param-re.usuario = c-seg-usuario no-error.
    if  avail param-re then
        assign l-receb-unid-negoc = param-re.log-pedir-unid-negoc.

    RETURN "NOK":U.
END PROCEDURE. 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableUnidNeg DBOProgram 
PROCEDURE enableUnidNeg :
/*------------------------------------------------------------------------------
  Purpose: Habilitar/Desabilitar Unidade de neg½cio    
  Parameters: pi-nr-ord-produ: Nœmero da ordem de produ»’o
              pi-tipo-nota: Tipo de nota
              pc-conta-contabil: Conta contÿbil
              l-habilita: Indica se o campo de unidade de neg½cio deve ou n’o ser habilitado
  
  Notes:       
------------------------------------------------------------------------------*/
    def output param l-habilita         as log init no  no-undo.

    RUN atualizaVarUnidNeg.

    /*** Se n’o utiliza unidade de neg½cio, ou o usuario do recebimento n’o permite atualiza»’o, 
         n’o habilita o campo ***/
    if  not l-mat-unid-negoc
    or  not l-receb-unid-negoc then do:
        assign l-habilita = no.
    end.
    else do:
            /* Material permanecerÿ no estoque, n’o foi informada a conta -> UNeg n’o habilitada.
               Se foi informada a conta, somente habilita se o usuario do receb. permite informar UNeg. */
            if  cCtCodigo = "" then do:
                assign l-habilita = no.
            end.
            else do:
                  assign l-habilita = l-receb-unid-negoc 
                                      and l-unidade-negocio. /* Somente habilita se o usuario permite alterar
                                                                                     e a fun»’o estÿ ativa */
            end.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNaturOper DBOProgram 
PROCEDURE findNaturOper :
/*------------------------------------------------------------------------------
  Purpose: Permite a programas externos posicionarem a natureza de opera»’o.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    define input param pc-nat-operacao as char no-undo.
    
    find first natur-oper no-lock
        where natur-oper.nat-operacao = pc-nat-operacao no-error.
    if avail natur-oper then
        return "OK":U.
    else 
        return "NOK":U.

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

    OPEN QUERY {&queryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaRatDespesa DBOProgram 
PROCEDURE validaRatDespesa :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lValidaValor           AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-habilita-unid-negoc  AS LOGICAL     NO-UNDO.

    IF RowObject.ct-codigo = '' THEN DO:
          {utp/ut-liter.i Conta_cont bil *} /*&1 nÆo pode ser branco*/
          {method/svc/errors/inserr.i
                   &ErrorNumber="164"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"
                   &ErrorParameters="return-value"} 
    END.

    FIND FIRST docto-orig-cte
         WHERE docto-orig-cte.cod-aces-comp-nfe = RowObject.cod-aces-comp-nfe
           AND docto-orig-cte.idi-orig-trad     = 2 NO-LOCK NO-ERROR.

    /** VALIDA°€O CONTA CONTABIL **/
    IF  RowObject.ct-codigo <> "":U THEN DO:
        RUN setEmpresaDocto (INPUT IF AVAIL docto-orig-cte THEN docto-orig-cte.cod-estabel ELSE ""). //c-empresa

        if not valid-handle(h_api_cta_ctbl) 
        or h_api_cta_ctbl:type      <> "PROCEDURE":U 
        or h_api_cta_ctbl:file-name <> "prgint/utb/utb743za.py":U then
            run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

        if not valid-handle(h_api_ccusto) 
        or h_api_ccusto:type      <> "PROCEDURE":U 
        or h_api_ccusto:file-name <> "prgint/utb/utb742za.py":U then
            run prgint/utb/utb742za.py persistent set h_api_ccusto.

       /* Busca dados da conta contÿbil */
       ASSIGN v_cod_cta_ctbl = RowObject.ct-codigo
              v_cod_ccusto   = RowObject.sc-codigo.

       run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        c-empresa,                  /* EMPRESA EMS2 */
                                                      input        "",                         /* PLANO DE CONTAS */
                                                      input-output v_cod_cta_ctbl,             /* CONTA */
                                                      input        docto-orig-cte.dt-trans,    /* DATA TRANSACAO */   
                                                      output       v_titulo_cta_ctbl,          /* DESCRICAO CONTA */
                                                      output       v_num_tip_cta_ctbl,         /* TIPO DA CONTA */
                                                      output       v_num_sit_cta_ctbl,         /* SITUA°€O DA CONTA */
                                                      output       v_ind_finalid_cta,          /* FINALIDADES DA CONTA */
                                                      output table tt_log_erro).               /* ERROS */ 

       run pi_busca_dados_cta_ctbl_integr in h_api_cta_ctbl (input  c-empresa,                 /* EMPRESA EMS2 */
                                                             input  "CEP":U,                   /* MODULO */
                                                             input  "",                        /* PLANO DE CONTAS */
                                                             input  v_cod_cta_ctbl,            /* CONTA */
                                                             input  docto-orig-cte.dt-trans,   /* DATA TRANSACAO */   
                                                             output v_ind_finalid_cta,         /* FINALIDADES DA CONTA */
                                                             output table tt_log_erro APPEND). /* ERROS */ 

       run pi_valida_conta_contabil in h_api_cta_ctbl (input  c-empresa,                       /* EMPRESA EMS2 */
                                                       input  docto-orig-cte.cod-estabel,      /* ESTABELECIMENTO EMS2 */
                                                       input  RowObject.cod-unid-negoc,        /* UNIDADE NEGûCIO */
                                                       input  "",                              /* PLANO CONTAS */ 
                                                       input  v_cod_cta_ctbl,                  /* CONTA */
                                                       input  "",                              /* PLANO CCUSTO */ 
                                                       input  v_cod_ccusto,                    /* CCUSTO */
                                                       input  docto-orig-cte.dt-trans,         /* DATA TRANSACAO */
                                                       output table tt_log_erro APPEND).       /* ERROS */

       FOR EACH tt_log_erro:
            run _insertErrorManual in this-procedure (input tt_log_erro.ttv_num_cod_erro,   /* pErrorNumber      */
                                                      input "EMS":U,                        /* pErrorType        */
                                                      input "Error":U,                      /* pErrorSubType     */
                                                      input tt_log_erro.ttv_des_msg_erro,   /* pErrorDescription */
                                                      input tt_log_erro.ttv_des_msg_ajuda,  /* pErrorHelp        */
                                                      input "":U).                          /* pErrorParameters  */
       END.
       IF NOT CAN-FIND (FIRST tt_log_erro) THEN DO:
           /* Verifica se a conta utiliza centro de custo */
            run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  c-empresa,                   /* EMPRESA EMS 2 */
                                                               input  docto-orig-cte.cod-estabel,  /* ESTABELECIMENTO EMS2 */
                                                               input  "",                          /* PLANO CONTAS */
                                                               input  v_cod_cta_ctbl,              /* CONTA */
                                                               input  docto-orig-cte.dt-trans,     /* DT TRANSACAO */
                                                               output v_log_utz_ccusto,            /* UTILIZA CCUSTO ? */
                                                               output table tt_log_erro).          /* ERROS */
            IF v_log_utz_ccusto THEN DO:
                /* Busca dados do centro de custo */
                run pi_busca_dados_ccusto in h_api_ccusto (input  c-empresa,                 /* EMPRESA EMS2 */
                                                           input  "",                        /* CODIGO DO PLANO CCUSTO */
                                                           input  v_cod_ccusto,              /* CCUSTO */
                                                           input  docto-orig-cte.dt-trans,   /* DATA DE TRANSACAO */
                                                           output v_titulo_ccusto,           /* DESCRICAO DO CCUSTO */
                                                           output table tt_log_erro).        /* ERROS */

                 FOR EACH tt_log_erro:
                    run _insertErrorManual in this-procedure (input tt_log_erro.ttv_num_cod_erro,   /* pErrorNumber      */
                                                              input "EMS":U,                        /* pErrorType        */
                                                              input "Error":U,                      /* pErrorSubType     */
                                                              input tt_log_erro.ttv_des_msg_erro,   /* pErrorDescription */
                                                              input tt_log_erro.ttv_des_msg_ajuda,  /* pErrorHelp        */
                                                              input "":U).                          /* pErrorParameters  */
                 END.
            END.

            if v_num_sit_cta_ctbl <> 3 then do:
                {method/svc/errors/inserr.i
                                    &ErrorNumber="443" /*Conta nao eh de sistema*/
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}  
            end.

            if not can-do("1,2,4,5",string(v_num_tip_cta_ctbl)) then do:
                {method/svc/errors/inserr.i
                                    &ErrorNumber="5543" /*Conta deve ser de despesa, receita, ativo ou passivo*/
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}
            end.

            assign i-num-finalid-cta = {adinc/i05ad049.i 6 v_ind_finalid_cta}.
            if  i-num-finalid-cta = 10 then do:
                {method/svc/errors/inserr.i
                                    &ErrorNumber="15190" /*Conta nao aceita lancamentos do estoque*/
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"} 
            end.

            if not can-do("1,2,3,6",string(i-num-finalid-cta)) then do:
                {method/svc/errors/inserr.i
                                    &ErrorNumber="107" /*Conta nao aceita lancamentos de requisicoes*/
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"} 
            end.
       END.
    END.

    find first param-mat no-lock no-error.
    assign l-mat-unid-negoc = avail param-mat
                              and   param-mat.ind-unid-neg.

    RUN setCtCodigo (INPUT rowObject.ct-codigo).
    RUN enableUnidNeg(output l-habilita-unid-negoc).

    IF  l-habilita-unid-negoc THEN DO:
       IF  NOT CAN-FIND(FIRST unid-negoc 
                        WHERE unid-negoc.cod-unid-negoc = rowObject.cod-unid-negoc NO-LOCK) THEN DO:
           {utp/ut-table.i mgind unid-negoc 1} /* Busca o label da tabela */
           {method/svc/errors/inserr.i &ErrorNumber="2"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters=TRIM(RETURN-VALUE)}
       END.
       ELSE DO:
           IF  NOT VALID-HANDLE(h-cdapi024) THEN
                RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.
            
            IF  VALID-HANDLE(h-cdapi024) THEN DO:
                EMPTY TEMP-TABLE tt-erro-aux.
                
                /* UN x Estabel */
                RUN ValidaUnidadeNegocioEstabel IN h-cdapi024 (INPUT docto-orig-cte.cod-estabel,
                                                               INPUT TODAY,
                                                               INPUT RowObject.cod-unid-negoc,
                                                               OUTPUT TABLE tt-erro-aux).
                IF  CAN-FIND(FIRST tt-erro-aux) THEN DO:
                    FOR EACH tt-erro-aux:
                        CREATE RowErrors.
                        ASSIGN RowErrors.ErrorNumber      = tt-erro-aux.cd-erro
                               RowErrors.ErrorType        = "EMS":U
                               RowErrors.ErrorSubType     = "ERROR":U
                               RowErrors.ErrorDescription = tt-erro-aux.mensagem
                               RowErrors.ErrorHelp        = tt-erro-aux.mensagem.
                    END.
                END.
            END.
       END.
    END.
    ELSE DO:
        // unidade de negocio nao esta ativa mas foi informada unidade negocio
        IF RowObject.cod-unid-negoc <> "" THEN DO:
            def var lb-erro-foi-inf-conteudo as char no-undo.
            {utp/ut-liter.i Foi_informado_o_conte£do *}
            assign lb-erro-foi-inf-conteudo = TRIM(RETURN-VALUE) + ": ":U + RowObject.cod-unid-negoc + ".":U.
            {utp/ut-liter.i Unidade_neg¢cio *}
            {method/svc/errors/inserr.i &ErrorNumber="31352"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE) + '~~~~' + lb-erro-foi-inf-conteudo"}
        END.
    END.

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
    FINALLY:
        IF  VALID-HANDLE(h_api_cta_ctbl)   THEN DO:
            DELETE PROCEDURE h_api_cta_ctbl.
            ASSIGN h_api_cta_ctbl = ?.
        END.

        IF  VALID-HANDLE(h_api_ccusto)   THEN DO:
             DELETE PROCEDURE h_api_ccusto.
             ASSIGN h_api_ccusto = ?.
        END.

        if valid-handle(h-cdapi024) then do:
            DELETE PROCEDURE h-cdapi024.
            ASSIGN h-cdapi024 = ?.
        end.
    END FINALLY.
    
        
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaRateiosDespesaCte DBOProgram 
PROCEDURE eliminaRateiosDespesaCte:
    DEFINE INPUT PARAM pChaveAcessoCte AS CHARACTER NO-UNDO.

    FOR EACH rat-despes-cte EXCLUSIVE-LOCK
       WHERE rat-despes-cte.cod-aces-comp-nfe = pChaveAcessoCte:
        DELETE rat-despes-cte.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEmpresaDocto DBOProgram 
PROCEDURE setEmpresaDocto :
    DEFINE INPUT PARAM pCodEstabel AS CHARACTER NO-UNDO.

    FIND FIRST estabelec WHERE estabelec.cod-estabel = pCodEstabel NO-LOCK NO-ERROR.
    IF NOT AVAIL estabelec THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.

    ASSIGN c-empresa = IF AVAIL estabelec THEN estabelec.ep-codigo ELSE param-global.empresa-prin.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

