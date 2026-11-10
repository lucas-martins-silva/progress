&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : boin01189.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/* This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/
{include/i-prgvrs.i BOIN01189 2.00.00.006} /* 14/04/2026 29/10/2026 12:01:24 */
{include/i-license-manager.i BOIN01189 MRE}
/* *************************** Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN01189
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName configur-conta-ctbz
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
&GLOBAL-DEFINE KeyField1          /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
{inbo/boin01189.i RowObject}

{utp/ut-glob.i}  /*variaveis globais, ex: c-seg-usuario*/
{cdp/cd0666.i}   /*defini‡Æo da temp-table de erro tt-erro*/

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    .
    
/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
{method/dboqry.i}

/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ******************** Preprocessor Definitions  ******************** */

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

/* ************************* Create Window  ************************** */

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

/* *************************** Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ********************** Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram  
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "serie":U THEN ASSIGN pFieldValue = RowObject.serie.
        WHEN "fm-codigo":U THEN ASSIGN pFieldValue = RowObject.fm-codigo.
        WHEN "ct-codigo-deb":U THEN ASSIGN pFieldValue = RowObject.ct-codigo-deb.
        WHEN "sc-codigo-deb":U THEN ASSIGN pFieldValue = RowObject.sc-codigo-deb.
        WHEN "cod-unid-neg-deb":U THEN ASSIGN pFieldValue = RowObject.cod-unid-neg-deb.
        WHEN "ct-codigo-cred":U THEN ASSIGN pFieldValue = RowObject.ct-codigo-cred.
        WHEN "sc-codigo-cred":U THEN ASSIGN pFieldValue = RowObject.sc-codigo-cred.
        WHEN "cod-unid-neg-cred":U THEN ASSIGN pFieldValue = RowObject.cod-unid-neg-cred.
        WHEN "ct-codigo-ifrs-deb":U THEN ASSIGN pFieldValue = RowObject.ct-codigo-ifrs-cred.
        WHEN "sc-codigo-ifrs-deb":U THEN ASSIGN pFieldValue = RowObject.sc-codigo-ifrs-deb.
        WHEN "cod-unid-neg-ifrs-deb":U THEN ASSIGN pFieldValue = RowObject.cod-unid-neg-ifrs-deb.
        WHEN "ct-codigo-ifrs-cred":U THEN ASSIGN pFieldValue = RowObject.ct-codigo-ifrs-cred.
        WHEN "sc-codigo-ifrs-cred":U THEN ASSIGN pFieldValue = RowObject.sc-codigo-ifrs-cred.
        WHEN "cod-unid-neg-ifrs-cred":U THEN ASSIGN pFieldValue = RowObject.cod-unid-neg-ifrs-cred.
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
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dt-ini-valid":U THEN ASSIGN pFieldValue = RowObject.dt-ini-valid.
        WHEN "dt-fim-valid":U THEN ASSIGN pFieldValue = RowObject.dt-fim-valid.
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
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

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
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "tipo-docto":U THEN ASSIGN pFieldValue = RowObject.tipo-docto.
        WHEN "ind-tip-ctbz":U THEN ASSIGN pFieldValue = RowObject.ind-tip-ctbz.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-grupo-emit":U THEN ASSIGN pFieldValue = RowObject.cod-grupo-emit.
        WHEN "cod-canal-venda":U THEN ASSIGN pFieldValue = RowObject.cod-canal-venda.
        WHEN "ge-codigo":U THEN ASSIGN pFieldValue = RowObject.ge-codigo.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice idx-unico
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE configur-conta-ctbz.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER ptipo-docto LIKE configur-conta-ctbz.tipo-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pind-tip-ctbz LIKE configur-conta-ctbz.ind-tip-ctbz NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE configur-conta-ctbz.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE configur-conta-ctbz.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-grupo-emit LIKE configur-conta-ctbz.cod-grupo-emit NO-UNDO.
    DEFINE OUTPUT PARAMETER pfm-codigo LIKE configur-conta-ctbz.fm-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pge-codigo LIKE configur-conta-ctbz.ge-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-canal-venda LIKE configur-conta-ctbz.cod-canal-venda NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-ini-valid LIKE configur-conta-ctbz.dt-ini-valid NO-UNDO.

    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           ptipo-docto = RowObject.tipo-docto
           pind-tip-ctbz = RowObject.ind-tip-ctbz
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           pcod-grupo-emit = RowObject.cod-grupo-emit
           pfm-codigo = RowObject.fm-codigo
           pge-codigo = RowObject.ge-codigo
           pcod-canal-venda = RowObject.cod-canal-venda
           pdt-ini-valid = RowObject.dt-ini-valid.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram  
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

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
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

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
  Purpose:     Reposiciona registro com base no ¡ndice idx-unico
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel     LIKE configur-conta-ctbz.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER ptipo-docto      LIKE configur-conta-ctbz.tipo-docto NO-UNDO.
    DEFINE INPUT PARAMETER pind-tip-ctbz    LIKE configur-conta-ctbz.ind-tip-ctbz NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente    LIKE configur-conta-ctbz.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao    LIKE configur-conta-ctbz.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pcod-grupo-emit  LIKE configur-conta-ctbz.cod-grupo-emit NO-UNDO.
    DEFINE INPUT PARAMETER pfm-codigo       LIKE configur-conta-ctbz.fm-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pge-codigo       LIKE configur-conta-ctbz.ge-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-canal-venda LIKE configur-conta-ctbz.cod-canal-venda NO-UNDO.
    DEFINE INPUT PARAMETER pserie           LIKE configur-conta-ctbz.serie NO-UNDO.
    DEFINE INPUT PARAMETER pdt-ini-valid    LIKE configur-conta-ctbz.dt-ini-valid NO-UNDO.
    
    FIND FIRST bfconfigur-conta-ctbz WHERE 
        bfconfigur-conta-ctbz.cod-estabel = pcod-estabel AND
        bfconfigur-conta-ctbz.tipo-docto = ptipo-docto AND
        bfconfigur-conta-ctbz.ind-tip-ctbz = pind-tip-ctbz AND
        bfconfigur-conta-ctbz.cod-emitente = pcod-emitente AND
        bfconfigur-conta-ctbz.nat-operacao = pnat-operacao AND
        bfconfigur-conta-ctbz.cod-grupo-emit = pcod-grupo-emit AND
        bfconfigur-conta-ctbz.fm-codigo = pfm-codigo AND
        bfconfigur-conta-ctbz.ge-codigo = pge-codigo AND
        bfconfigur-conta-ctbz.cod-canal-venda = pcod-canal-venda AND
        bfconfigur-conta-ctbz.serie = pserie AND
        bfconfigur-conta-ctbz.dt-ini-valid = pdt-ini-valid NO-LOCK NO-ERROR.

    IF NOT AVAILABLE bfconfigur-conta-ctbz THEN 
        RETURN "NOK":U.

    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfconfigur-conta-ctbz)).
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
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
------------------------------------------------------------------------------*/
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE utilizaCentroCusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pEstabel     AS CHARACTER          NO-UNDO.       
    DEF INPUT  PARAM pConta       AS CHARACTER          NO-UNDO.
    DEF OUTPUT PARAM pUtilizaCc  AS LOGICAL INITIAL NO  NO-UNDO.

    DEF VAR i-empresa          AS CHAR             NO-UNDO.
    DEF VAR v_log_utz_ccusto   AS LOG   INITIAL NO NO-UNDO.
    DEF VAR h_api_ccusto       AS HANDLE           NO-UNDO.
    
    
    FOR FIRST estabelec FIELDS(ep-codigo)
        WHERE estabelec.cod-estabel = pEstabel NO-LOCK:
        ASSIGN i-empresa = estabelec.ep-codigo.
    END.
        
    IF NOT VALID-HANDLE(h_api_ccusto) THEN
        RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.
        
    RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (input  i-empresa,          /* EMPRESA EMS 2 */
                                                       input  pEstabel, /* ESTABELECIMENTO EMS2 */
                                                       input  "",                 /* PLANO CONTAS */
                                                       input  pConta,            /* CONTA */
                                                       input  today,              /* DT TRANSACAO */
                                                       output v_log_utz_ccusto,   /* UTILIZA CCUSTO ? */
                                                       output table tt_log_erro). /* ERROS */

    for each tt_log_erro: 
        {method/svc/errors/inserr.i &ErrorNumber=string(tt_log_erro.ttv_num_cod_erro)
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + '~~~~' + tt_log_erro.ttv_des_msg_ajuda"}
    end.
   
       
    ASSIGN pUtilizaCc = v_log_utz_ccusto.

    RETURN "OK":U.
    FINALLY:
        DELETE PROCEDURE h_api_ccusto NO-ERROR.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */

PROCEDURE unidNegocAtiva:
    DEFINE OUTPUT PARAM pUnidNegAtiva AS LOGICAL NO-UNDO.

    FIND FIRST param-mat NO-LOCK NO-ERROR.
    ASSIGN pUnidNegAtiva = AVAIL param-mat AND param-mat.ind-unid-neg.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE validaUnidadeNegocio PRIVATE:
    DEFINE INPUT PARAM pUnidNeg AS CHARACTER NO-UNDO.
    DEFINE VARIABLE h-cdapi024 AS HANDLE NO-UNDO.

    FIND FIRST unid-negoc
        WHERE unid-negoc.cod-unid-negoc = pUnidNeg NO-LOCK NO-ERROR.
    IF NOT AVAIL unid-negoc THEN DO:
        {utp/ut-liter.i Unidade_de_Neg¢cio * r}
        {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType = "ERROR":U
                    &ErrorParameters="RETURN-VALUE"}
        RETURN "NOK":U.
    END.

    IF NOT VALID-HANDLE(h-cdapi024) THEN
       RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.

    IF VALID-HANDLE(h-cdapi024) THEN DO:
        EMPTY TEMP-TABLE tt-erro.
        RUN validaUnidadeNegocioEstabel IN h-cdapi024 (INPUT  RowObject.cod-estabel,
                                                       INPUT  RowObject.dt-ini-valid,
                                                       INPUT  pUnidNeg,
                                                       OUTPUT TABLE tt-erro).
        RUN validaUnidadeNegocioUsuario IN h-cdapi024 (INPUT  c-seg-usuario,
                                                       INPUT  pUnidNeg,
                                                       OUTPUT TABLE tt-erro APPEND).
        FOR EACH tt-erro:
            RUN _insertErrorManual IN THIS-PROCEDURE (INPUT tt-erro.cd-erro, INPUT "EMS", INPUT "Error",
                                                      INPUT tt-erro.mensagem, INPUT "", INPUT "").
        END.
    END.
    RETURN "OK":U.
    FINALLY:
        IF VALID-HANDLE(h-cdapi024) THEN DO:
           DELETE PROCEDURE h-cdapi024 NO-ERROR.
           ASSIGN h-cdapi024 = ?.
        END.
    END FINALLY.
END PROCEDURE.

PROCEDURE ValidaContaCentroCusto:
        DEFINE INPUT PARAM pCtCodigo AS CHAR NO-UNDO.
        DEFINE INPUT PARAM pScCodigo AS CHAR NO-UNDO.
        
        DEF VAR i-empresa          AS CHAR             NO-UNDO.
        DEF VAR v_log_utz_ccusto   AS LOG   INITIAL NO NO-UNDO.
        DEF VAR h_api_ccusto       AS HANDLE           NO-UNDO.
        DEF VAR h_api_cta_ctbl     AS HANDLE           NO-UNDO.

        DEF VAR v_cod_cta_ctbl       AS CHAR   NO-UNDO.
        DEF VAR v_titulo_cta_ctbl    AS CHAR   NO-UNDO.
        DEF VAR v_num_tip_cta_ctbl   AS INT    NO-UNDO.
        DEF VAR v_num_sit_cta_ctbl   AS INT    NO-UNDO.
        DEF VAR v_ind_finalid_cta    AS CHAR   NO-UNDO.
        DEF VAR v_cod_ccusto         AS CHAR   NO-UNDO.
        DEF VAR v_titulo_ccusto      AS CHAR   NO-UNDO.

    
        FOR FIRST estabelec FIELDS(ep-codigo)
             WHERE estabelec.cod-estabel = RowObject.cod-estabel NO-LOCK:
            ASSIGN i-empresa = estabelec.ep-codigo.
        END.
        IF pCtCodigo <> "":U THEN DO:

            if not valid-handle(h_api_cta_ctbl)  then
               run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

            if not valid-handle(h_api_ccusto)  then
               run prgint/utb/utb742za.py persistent set h_api_ccusto.

           /* Busca dados da conta cont bil */
           ASSIGN v_cod_cta_ctbl = pCtCodigo.

           run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,                /* EMPRESA EMS2 */
                                                          input        "",                       /* PLANO DE CONTAS */
                                                          input-output v_cod_cta_ctbl,           /* CONTA */
                                                          input        today,/* DATA TRANSACAO */   
                                                          output       v_titulo_cta_ctbl,        /* DESCRICAO CONTA */
                                                          output       v_num_tip_cta_ctbl,       /* TIPO DA CONTA */
                                                          output       v_num_sit_cta_ctbl,       /* SITUA€ÇO DA CONTA */
                                                          output       v_ind_finalid_cta,        /* FINALIDADES DA CONTA */
                                                          output table tt_log_erro).             /* ERROS */ 
 
           find first tt_log_erro no-lock no-error.
           if avail tt_log_erro then do:

                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + '~~~~' + tt_log_erro.ttv_des_msg_ajuda"}  
           end.
           ELSE DO:
               /* Verifica se a conta utiliza centro de custo */
                run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,                 /* EMPRESA EMS 2 */
                                                                   input  RowObject.cod-estabel,  /* ESTABELECIMENTO EMS2 */
                                                                   input  "",                        /* PLANO CONTAS */
                                                                   input  v_cod_cta_ctbl,            /* CONTA */
                                                                   input  today, /* DT TRANSACAO */
                                                                   output v_log_utz_ccusto,          /* UTILIZA CCUSTO ? */
                                                                   output table tt_log_erro).        /* ERROS */        
                IF v_log_utz_ccusto THEN DO:
                    /* Busca dados do centro de custo */
                    ASSIGN v_cod_ccusto = pScCodigo.
                    run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,                /* EMPRESA EMS2 */
                                                               input  "",                       /* CODIGO DO PLANO CCUSTO */
                                                               input  v_cod_ccusto,             /* CCUSTO */
                                                               input  TODAY,/* DATA DE TRANSACAO */
                                                               output v_titulo_ccusto,          /* DESCRICAO DO CCUSTO */
                                                               output table tt_log_erro).       /* ERROS */
                     
                    find first tt_log_erro no-lock no-error.
                    if avail tt_log_erro then do: 
                        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + '~~~~' + tt_log_erro.ttv_des_msg_ajuda"}
                    end. 
                end.
           END.

        END.
    FINALLY:
        DELETE PROCEDURE h_api_cta_ctbl NO-ERROR.
        DELETE PROCEDURE h_api_ccusto NO-ERROR.
    END FINALLY.

END PROCEDURE.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    DEFINE VARIABLE cliteral      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE lUnidNegAtiva AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lUtilizaIfrs  AS LOGICAL   INITIAL NO NO-UNDO.

    FOR FIRST param-global FIELDS(char-2) NO-LOCK:
        ASSIGN lUtilizaIfrs = (SUBSTRING(param-global.char-2, 34, 1) = "S":U) = YES.
    END.

    IF pType = 'create':U THEN DO:
         
        FIND FIRST bfconfigur-conta-ctbz 
             WHERE bfconfigur-conta-ctbz.cod-estabel     = RowObject.cod-estabel 
               AND bfconfigur-conta-ctbz.tipo-docto      = RowObject.tipo-docto 
               AND bfconfigur-conta-ctbz.ind-tip-ctbz    = RowObject.ind-tip-ctbz 
               AND bfconfigur-conta-ctbz.cod-emitente    = RowObject.cod-emitente 
               AND bfconfigur-conta-ctbz.nat-operacao    = RowObject.nat-operacao 
               AND bfconfigur-conta-ctbz.cod-grupo-emit  = RowObject.cod-grupo-emit 
               AND bfconfigur-conta-ctbz.fm-codigo       = RowObject.fm-codigo 
               AND bfconfigur-conta-ctbz.ge-codigo       = RowObject.ge-codigo 
               AND bfconfigur-conta-ctbz.cod-canal-venda = RowObject.cod-canal-venda 
               AND bfconfigur-conta-ctbz.serie           = RowObject.serie 
               AND bfconfigur-conta-ctbz.dt-ini-valid    = RowObject.dt-ini-valid NO-LOCK NO-ERROR.    
               
        IF AVAIL bfconfigur-conta-ctbz THEN DO:
            {utp/ut-liter.i "Configura‡Æo_conta_contabiliza‡Æo" *}        
            {method/svc/errors/inserr.i &ErrorNumber="1"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}           

        END.
    END.
       
    IF pType = 'create':U 
    OR pType = 'update':U THEN DO:
        IF RowObject.cod-estabel = ''  THEN DO:
           {utp/ut-liter.i "Estabelecimento"}
           {method/svc/errors/inserr.i &ErrorNumber="5793"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="trim(return-value)"}   
        END.
        ELSE DO:
            IF RowObject.cod-estabel <> '*' AND 
               NOT CAN-FIND(FIRST estabelec NO-LOCK
                            WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
                
                {utp/ut-liter.i "Estabelecimento"}
                {method/svc/errors/inserr.i &ErrorNumber="2"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="trim(return-value)"}
            END.
        END.
        IF RowObject.nat-operacao = '' THEN DO:
           {utp/ut-liter.i "Natureza_opera‡Æo"}
           {method/svc/errors/inserr.i &ErrorNumber="5793"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="trim(return-value)"}   
        END.
        ELSE DO:
            IF  RowObject.nat-operacao <> '*'
            AND NOT CAN-FIND(FIRST natur-oper NO-LOCK
                            WHERE natur-oper.nat-operacao = RowObject.nat-operacao) THEN DO:
                
                {utp/ut-liter.i "Natureza_opera‡Æo"}
                {method/svc/errors/inserr.i &ErrorNumber="2"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="trim(return-value)"}
            END.
        END.
        
        IF RowObject.fm-codigo = '' THEN DO:
           {utp/ut-liter.i "Fam¡lia_material"}
           {method/svc/errors/inserr.i &ErrorNumber="5793"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="trim(return-value)"}   
        END.
        ELSE IF RowObject.fm-codigo <> '*' THEN DO:
            IF RowObject.tipo-docto = 1 THEN DO: /* entrada */
                IF NOT CAN-FIND(FIRST familia-mat NO-LOCK
                                WHERE familia-mat.fm-codigo = RowObject.fm-codigo) THEN DO:
                    {utp/ut-liter.i "Fam¡lia_material"}
                    {method/svc/errors/inserr.i &ErrorNumber="2"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="trim(return-value)"}
                END.
            END.
            ELSE IF RowObject.tipo-docto = 2 THEN DO: /* sa¡da */
                FIND FIRST para-fat NO-LOCK NO-ERROR.

                // ind-contab-ft marcado no ft0301 como familia comercial deve validar familia comercial
                IF AVAIL para-fat AND para-fat.ind-contab-ft = 2 THEN DO:
                    IF NOT CAN-FIND(FIRST fam-comerc NO-LOCK
                                    WHERE fam-comerc.fm-cod-com = RowObject.fm-codigo) THEN DO:
                        {utp/ut-liter.i "Fam¡lia_comercial"}
                        {method/svc/errors/inserr.i &ErrorNumber="2"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="trim(return-value)"}
                    END.
                END.
                ELSE DO: // demais parametros valida familia material
                    IF NOT CAN-FIND(FIRST familia-mat NO-LOCK
                                    WHERE familia-mat.fm-codigo = RowObject.fm-codigo) THEN DO:
                        {utp/ut-liter.i "Fam¡lia_material"}
                        {method/svc/errors/inserr.i &ErrorNumber="2"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="trim(return-value)"}
                    END.
                END.
            END.
        END.
       
        IF RowObject.ct-codigo-deb = '' THEN DO:
           {utp/ut-liter.i "Conta_d‚bito"}
           {method/svc/errors/inserr.i &ErrorNumber="5793"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="trim(return-value)"}   
        END.
        ELSE DO:
            RUN ValidaContaCentroCusto (INPUT RowObject.ct-codigo-deb,
                                        INPUT RowObject.sc-codigo-deb).
        END.
        IF RowObject.ct-codigo-cred = '' THEN DO:
           {utp/ut-liter.i "Conta_d‚bito"}
           {method/svc/errors/inserr.i &ErrorNumber="5793"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="trim(return-value)"}   
        END.
        ELSE DO:
          RUN ValidaContaCentroCusto (INPUT RowObject.ct-codigo-cred,
                                      INPUT RowObject.sc-codigo-cred).

        END.

        RUN unidNegocAtiva (OUTPUT lUnidNegAtiva).
        IF lUnidNegAtiva THEN DO:
            IF RowObject.cod-unid-neg-deb = '' THEN DO:
               {utp/ut-liter.i "Unidade_de_neg¢cio"}
               {method/svc/errors/inserr.i &ErrorNumber="5793"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters="trim(return-value)"}
            END.
            ELSE
                RUN validaUnidadeNegocio (INPUT RowObject.cod-unid-neg-deb).

            IF RowObject.cod-unid-neg-cred = '' THEN DO:
               {utp/ut-liter.i "Unidade_de_neg¢cio"}
               {method/svc/errors/inserr.i &ErrorNumber="5793"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters="trim(return-value)"}
            END.
            ELSE
                RUN validaUnidadeNegocio (INPUT RowObject.cod-unid-neg-cred).

            IF RowObject.tipo-docto = 2 THEN DO: /* Campos IFRS s¢ existem/aparecem para Sa¡da */
                IF lUtilizaIfrs THEN DO:
                    IF RowObject.cod-unid-neg-ifrs-deb = '' THEN DO:
                    {utp/ut-liter.i "Unidade_de_neg¢cio"}
                    {method/svc/errors/inserr.i &ErrorNumber="5793"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="trim(return-value)"}
                    END.
                    ELSE
                        RUN validaUnidadeNegocio (INPUT RowObject.cod-unid-neg-ifrs-deb).

                    IF RowObject.cod-unid-neg-ifrs-cred = '' THEN DO:
                    {utp/ut-liter.i "Unidade_de_neg¢cio"}
                    {method/svc/errors/inserr.i &ErrorNumber="5793"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="trim(return-value)"}
                    END.
                    ELSE
                        RUN validaUnidadeNegocio (INPUT RowObject.cod-unid-neg-ifrs-cred).
                END.
                ELSE DO:
                    /* Se IFRS nÆo estiver ativo no CD0101, valida a UN apenas se tiver sido preenchida */
                    IF RowObject.cod-unid-neg-ifrs-deb <> '' THEN
                        RUN validaUnidadeNegocio (INPUT RowObject.cod-unid-neg-ifrs-deb).

                    IF RowObject.cod-unid-neg-ifrs-cred <> '' THEN
                        RUN validaUnidadeNegocio (INPUT RowObject.cod-unid-neg-ifrs-cred).
                END. /* ELSE */
            END.
        END.

        IF RowObject.dt-ini-valid  > RowObject.dt-fim-valid THEN DO:
           {utp/ut-liter.i "Data_validade_inicial"}
           ASSIGN cliteral = trim(return-value).
           {utp/ut-liter.i "data_validade_final"}
           
           {method/svc/errors/inserr.i &ErrorNumber="26175"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="cliteral + '~~~~' + trim(return-value)"}   
        END.
       
    END.
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
