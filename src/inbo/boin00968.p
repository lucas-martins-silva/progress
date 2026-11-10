&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 

{include/i-prgvrs.i BOIN00968 2.00.00.026 } /*** "010026" 13/11/2023 11:45:43 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin00968 MAQ}
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
&GLOBAL-DEFINE DBOName BOIN00968
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName param-aquis-rural
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE excludeFrameDefinition YES

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
{inbo/boin00968.i RowObject}

DEFINE TEMP-TABLE tt-estab-usa-event NO-UNDO
    FIELD cod-estabel AS CHARACTER FORMAT "x(5)"
    FIELD cod-evento  AS CHARACTER FORMAT "x(16)".

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}
{cdp/cdunif001.i} /* Vari veis da unifica‡Æo de conceito Conta Cont bil e Centro de Custo */

{utils/formulDef.i} /* formula */
{cdp/cdapi020.i}    /* Temp-tables API Interpretador de F¢rmulas */
{cdp/cd0666.i}      /* Temp-table geral de erros                 */


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def VARIABLE c-cod-estabel-ini like RowObject.cod-estabel     no-undo.
def VARIABLE c-cod-estabel-fim like RowObject.cod-estabel     no-undo.

DEF VARIABLE cEmpresa          LIKE param-global.empresa-prin NO-UNDO.
    
DEF VAR i-num-tip-cta-cta  AS INT    NO-UNDO.
DEF VAR i-num-sit-cta      AS INT    NO-UNDO.
DEF VAR i-num-finalid-cta  AS INT    NO-UNDO.

def var v_titulo_cta_ctbl  as char   no-undo.
def var v_titulo_ccusto    as char   no-undo.

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
         HEIGHT             = 9.42
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
        WHEN "cod-ccusto-aquis-rural":U THEN ASSIGN pFieldValue = RowObject.cod-ccusto-aquis-rural.
        WHEN "cod-cta-aquis-rural":U THEN ASSIGN pFieldValue = RowObject.cod-cta-aquis-rural.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-periodo":U THEN ASSIGN pFieldValue = RowObject.cod-periodo.
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
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
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
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
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
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "qti-analis-isento":U THEN ASSIGN pFieldValue = RowObject.qti-analis-isento.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice param-aquis-id
  Parameters:  
               retorna valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE param-aquis-rural.cod-estabel NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel.

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
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
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
  Purpose:     Reposiciona registro com base no ¡ndice param-aquis-id
  Parameters:  
               recebe valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE param-aquis-rural.cod-estabel NO-UNDO.

    FIND FIRST bfparam-aquis-rural WHERE 
        bfparam-aquis-rural.cod-estabel = pcod-estabel NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfparam-aquis-rural THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfparam-aquis-rural)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEstabel DBOProgram 
PROCEDURE openQueryEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OPEN QUERY {&QueryName} 
     FOR EACH {&TableName}
         WHERE {&TableName}.cod-estabel >= c-cod-estabel-ini
           AND {&TableName}.cod-estabel <= c-cod-estabel-fim NO-LOCK INDEXED-REPOSITION.

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

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaDadosConta DBOProgram 
PROCEDURE piBuscaDadosConta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM p-cod-conta       AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-num-tip-cta     AS INT  NO-UNDO.
    DEF OUTPUT PARAM p-num-sit-cta     AS INT  NO-UNDO.
    DEF OUTPUT PARAM p-num-finalid-cta AS INT  NO-UNDO.

    DEF VAR icont AS INT NO-UNDO.

    EMPTY TEMP-TABLE tt_log_erro.
    
    assign v_cod_cta_ctbl    = p-cod-conta
           i-num-tip-cta-cta = 0
           i-num-sit-cta     = 0
           i-num-finalid-cta = 0.

    IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:

        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        STRING(cEmpresa),   /* EMPRESA EMS2 */
                                                       input        "",                 /* PLANO DE CONTAS */
                                                       input-output v_cod_cta_ctbl,     /* CONTA */
                                                       input        today,              /* DATA TRANSACAO */   
                                                       output       v_titulo_cta_ctbl,     /* DESCRICAO CONTA */
                                                       output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                       output       v_num_sit_cta_ctbl, /* SITUAø°O DA CONTA */
                                                       output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                       output table tt_log_erro).       /* ERROS */
    
        run pi_busca_dados_cta_ctbl_integr in h_api_cta_ctbl (input        STRING(cEmpresa),  /* EMPRESA EMS2 */
                                                              input        "CEP",             /* M¹DULO */
                                                              input        "",                /* PLANO DE CONTAS */
                                                              input        v_cod_cta_ctbl,    /* CONTA */
                                                              input        today,             /* DATA TRANSACAO */   
                                                              output       v_ind_finalid_cta, /* FINALIDADES DA CONTA */
                                                              output table tt_log_erro).      /* ERROS */ 


        FIND FIRST tt_log_erro NO-ERROR.

        IF NOT AVAIL tt_log_erro THEN DO:
            assign p-num-finalid-cta = {adinc/i05ad049.i 6 v_ind_finalid_cta }
                   p-num-tip-cta     = v_num_tip_cta_ctbl
                   p-num-sit-cta     = v_num_sit_cta_ctbl.
            RETURN "OK":U.
        END.
        ELSE
            RETURN "NOK":U.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaCcusto DBOProgram 
PROCEDURE piValidaCcusto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER pConta  AS CHAR FORMAT "X(20)" NO-UNDO.
    DEF INPUT PARAMETER pCCusto AS CHAR FORMAT "X(20)" NO-UNDO.
    DEF INPUT PARAMETER pMsg    AS CHAR FORMAT "X(20)" NO-UNDO.

    DEF VAR l-hab-ccusto AS LOG NO-UNDO.

    run prgint/utb/utb742za.py persistent set h_api_ccusto.

    EMPTY TEMP-TABLE tt_log_erro.

    IF VALID-HANDLE(h_api_ccusto) THEN DO:
        /* Verifica se a conta utiliza centro de custo */
        RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  STRING(cEmpresa),               /* EMPRESA EMS 2 */
                                                           INPUT  RowObject.cod-estabel,          /* ESTABELECIMENTO EMS2 */
                                                           INPUT  "",                             /* PLANO CONTAS */
                                                           INPUT  pConta,                         /* CONTA */
                                                           INPUT  TODAY,                          /* DT TRANSACAO */
                                                           OUTPUT l-hab-ccusto,                   /* UTILIZA CCUSTO ? */
                                                           OUTPUT TABLE tt_log_erro).             /* ERROS */
    
        IF l-hab-ccusto THEN DO:
    
            EMPTY TEMP-TABLE tt_log_erro.
            
            run pi_busca_dados_ccusto in h_api_ccusto (input  STRING(cEmpresa),                 /* EMPRESA EMS2 */
                                                       input  "",                               /* CODIGO DO PLANO CCUSTO */
                                                       input  pCCusto,                          /* CCUSTO */
                                                       input  today,                            /* DATA DE TRANSACAO */
                                                       output v_titulo_ccusto,                  /* DESCRICAO DO CCUSTO */
                                                       output table tt_log_erro).               /* ERROS */ 
            
        END.

        FIND FIRST tt_log_erro NO-ERROR.
        IF AVAIL tt_log_erro THEN DO:
    
            /* Inicio -- Projeto Internacional */
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="pMsg"}

        END.
        
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaConta DBOProgram 
PROCEDURE piValidaConta :
/*------------------------------------------------------------------------------
  Purpose:    
  Parameters: 
  Notes:      
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-cod-conta AS CHAR NO-UNDO.

    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
    
    IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
        RUN pi_valida_cta_ctbl_integr in h_api_cta_ctbl (input  STRING(cEmpresa),              /* EMPRESA EMS2 */
                                                         input  "CEP",                         /* MODULO */
                                                         input  "",                            /* PLANO CONTAS */ 
                                                         input  p-cod-conta,                   /* CONTA */
                                                         input  "(nenhum)",                    /* FINALIDADES */
                                                         input  today,                         /* DATA DE TRANSACAO */ 
                                                         output table tt_log_erro).            /* ERROS */

        for first tt_log_erro:
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro)"}
            return "NOK".
        end.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEstabel DBOProgram 
PROCEDURE setConstraintEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter p-cod-estabel-ini like RowObject.cod-estabel no-undo.
def input parameter p-cod-estabel-fim like RowObject.cod-estabel no-undo.

    assign c-cod-estabel-ini = p-cod-estabel-ini        
           c-cod-estabel-fim = p-cod-estabel-fim.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaSerieEstab DBOProgram 
PROCEDURE validaSerieEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER p-cod-estab LIKE ser-estab.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER p-serie     LIKE ser-estab.serie       NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-emis   AS DATE                    NO-UNDO.


    FOR FIRST ser-estab FIELDS(dt-ult-fat) NO-LOCK
        WHERE ser-estab.cod-estabel = p-cod-estab
          AND ser-estab.serie       = p-serie: END.
    IF NOT AVAIL ser-estab THEN DO:
        run utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 6514, 
                           INPUT "").
        RETURN "NOK":U.
    END.
    ELSE DO:

        if p-dt-emis > ser-estab.dt-ult-fat then do:
            run utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 5135, 
                           INPUT "").
            IF RETURN-VALUE = "YES" THEN
                RETURN "OK":U.
            ELSE
                RETURN "NOK":U.
        end.

        if p-dt-emis < today then do:
            run utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 15046, 
                           INPUT "").
            RETURN "OK":U.
        end.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaDtEmissSerieEstab DBOProgram 
PROCEDURE buscaDtEmissSerieEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER p-cod-estab LIKE ser-estab.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER p-serie     LIKE ser-estab.serie       NO-UNDO.
    DEFINE OUTPUT PARAMETER p-dt-emis  AS DATE                    NO-UNDO.


    FOR FIRST ser-estab FIELDS(dt-ult-fat) NO-LOCK
        WHERE ser-estab.cod-estabel = p-cod-estab
          AND ser-estab.serie       = p-serie: 

        ASSIGN p-dt-emis = ser-estab.dt-ult-fat.

    END.
    
    IF NOT AVAIL ser-estab THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 6514, 
                           INPUT "").
        RETURN "NOK":U.
    END.
    
    RETURN "OK":U.

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

    DEF VAR c-label-tabela AS CHAR   NO-UNDO.
    DEF VAR c-label-relac  AS CHAR   NO-UNDO.

    {utp/ut-liter.i Parƒmetros_de_Aquisi‡Æo_Rural * L}
    ASSIGN c-label-tabela = RETURN-VALUE.

    IF pType = "Create" THEN DO:
        IF CAN-FIND(FIRST bf{&TableName} WHERE bf{&TableName}.cod-estabel = RowObject.cod-estabel) THEN DO:
            {utp/ut-liter.i Estabelecimento *}
            {method/svc/errors/inserr.i
                     &ErrorNumber="1"
                     &ErrorType="EMS"
                     &ErrorParameters="return-value"} 
        END.
    END.

    IF NOT CAN-FIND(first estabelec where estabelec.cod-estabel = RowObject.cod-estabel)  THEN DO:
            {utp/ut-liter.i Estabelecimento *}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
            return "NOK".                            
    END.

    IF pType = "Delete" THEN DO:

        IF CAN-FIND(FIRST rota-coleta WHERE rota-coleta.cod-estabel = RowObject.cod-estabel) THEN DO:

            {utp/ut-liter.i Rota_Coleta * L}
            ASSIGN c-label-relac = RETURN-VALUE.

            {method/svc/errors/inserr.i
                 &ErrorNumber="5"
                 &ErrorType="EMS"
                 &ErrorParameters="c-label-tabela + '~~~~' + c-label-relac"}
        END.

        IF CAN-FIND(FIRST item-estab-rural WHERE item-estab-rural.cod-estabel = RowObject.cod-estabel) THEN DO:

            {utp/ut-liter.i Item_Estabelecimento_Rural * L}
            ASSIGN c-label-relac = RETURN-VALUE.

            {method/svc/errors/inserr.i
                 &ErrorNumber="5"
                 &ErrorType="EMS"
                 &ErrorParameters="c-label-tabela + '~~~~' + c-label-relac"}
        END.

        IF CAN-FIND(FIRST regra-form-preco WHERE regra-form-preco.cod-estabel = RowObject.cod-estabel) THEN DO:

            {utp/ut-liter.i Regra_de_Forma‡Æo_de_Pre‡o * L}
            ASSIGN c-label-relac = RETURN-VALUE.

            {method/svc/errors/inserr.i
                 &ErrorNumber="5"
                 &ErrorType="EMS"
                 &ErrorParameters="c-label-tabela + '~~~~' + c-label-relac"}
        END. 

        IF CAN-FIND(FIRST preco-frete-coleta WHERE preco-frete-coleta.cod-estabel = RowObject.cod-estabel) THEN DO:

            {utp/ut-liter.i Tabela_de_Preco_Frete_Coleta * L}
            ASSIGN c-label-relac = RETURN-VALUE.

            {method/svc/errors/inserr.i &ErrorNumber="5"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=" c-label-tabela + '~~~~' + c-label-relac"}
        END.

        IF CAN-FIND(FIRST carg-rural WHERE carg-rural.cod-estabel = RowObject.cod-estabel) THEN DO:
        
            {utp/ut-liter.i Carga_Rural * L}
            ASSIGN c-label-relac = RETURN-VALUE. 
    
            {method/svc/errors/inserr.i
                 &ErrorNumber="5"
                 &ErrorType="EMS"
                 &ErrorParameters="c-label-tabela + '~~~~' + c-label-relac"}
        END.

    END.

    IF pType = "Create" OR pType = "Update" THEN DO:

        /*valida formula impto sanid*/
        IF RowObject.dsl-formul-event <> "" THEN DO:
            RUN createTTVariaveisImptoSanid IN THIS-PROCEDURE.
            
            EMPTY TEMP-TABLE tt-formula.

            FOR EACH tt-variaveis:
                CREATE tt-var-valid.
                ASSIGN tt-var-valid.nome      = tt-variaveis.nome-variavel
                       tt-var-valid.valor     = 2
                       tt-var-valid.tipo-res  = 1.
            END.
            
            CREATE tt-formula.
            ASSIGN tt-formula.formula = RowObject.dsl-formul-event
                   tt-formula.cod-versao-integracao = 001.
            
            RUN cdp/cdapi020.p (INPUT-OUTPUT TABLE tt-formula,
                                INPUT TABLE tt-var-valid,
                                INPUT-OUTPUT TABLE tt-erro,
                                INPUT YES).
            
            FOR EACH tt-erro:
                RUN _insertErrorManual (INPUT tt-erro.cd-erro,
                                        INPUT "EMS":U,
                                        INPUT "ERROR":U,
                                        INPUT tt-erro.mensagem,
                                        INPUT "",
                                        INPUT "":U).
            END.
        END.
        /****************************/

        /* Busca empresa */
        FIND FIRST param-global NO-LOCK NO-ERROR.
        ASSIGN cEmpresa = param-global.empresa-prin.
        
        RUN piValidaConta (INPUT RowObject.cod-cta-aquis-rural).
    
        RUN piBuscaDadosConta (INPUT  RowObject.cod-cta-aquis-rural,
                               OUTPUT i-num-tip-cta-cta,  /* conta-contab.tipo    */
                               OUTPUT i-num-sit-cta,      /* conta-contab.estado  */
                               OUTPUT i-num-finalid-cta). /* conta-contab.estoque */
    
        IF RETURN-VALUE = "OK" THEN DO:
    
            if i-num-finalid-cta <> 2 then do:
                {method/svc/errors/inserr.i &ErrorNumber="19027"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}
            end.
    
        END.
    
        {utp/ut-liter.i "Centro_Custo" *}
        RUN piValidaCcusto (INPUT RowObject.cod-cta-aquis-rural,
                            INPUT RowObject.cod-ccusto-aquis-rural,
                            INPUT RETURN-VALUE).
    
        RUN piValidaConta (INPUT RowObject.cod-cta-dif-quant).
    
        RUN piBuscaDadosConta (INPUT  RowObject.cod-cta-dif-quant,
                               OUTPUT i-num-tip-cta-cta,  /* conta-contab.tipo    */
                               OUTPUT i-num-sit-cta,      /* conta-contab.estado  */
                               OUTPUT i-num-finalid-cta). /* conta-contab.estoque */
    
        IF RETURN-VALUE = "OK" THEN DO:
            /* Conta Contabil deve ser Consumo ou NÆo Consumo. */
            if (i-num-finalid-cta <> 1) and 
               (i-num-finalid-cta <> 2) then do:
               {method/svc/errors/inserr.i &errorNumber = "26456"
                                   &errorType       = "EMS"
                                   &errorSubType    = "ERROR"
                                   &ErrorParameters ="''"}
            END.
        END.
    
        {utp/ut-liter.i "Centro_Custo_Diferen‡a_Qtd" *}
        RUN piValidaCcusto (INPUT RowObject.cod-cta-dif-quant, 
                            INPUT RowObject.cod-ccusto-dif-quant,
                            INPUT RETURN-VALUE).
    
        if valid-handle(h_api_cta_ctbl) then
            delete object h_api_cta_ctbl.
    
        if valid-handle(h_api_ccusto) then
            delete object h_api_ccusto.

    END.

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-ult-fech-dia DBOProgram 
PROCEDURE pi-verifica-ult-fech-dia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param c-cod-estabel   like saldo-terc.cod-estabel   no-undo.
    def output param da-ult-fech-dia like param-estoq.ult-fech-dia no-undo.

    FIND FIRST param-estoq NO-LOCK NO-ERROR.

    &if defined (bf_mat_fech_estab) &then
        if  avail param-estoq and param-estoq.tp-fech = 2 then do:
            find estab-mat
                 where estab-mat.cod-estabel = c-cod-estabel no-lock no-error.
            IF  avail estab-mat THEN 
                assign da-ult-fech-dia = estab-mat.ult-fech-dia.
        end.
        else
            IF  avail param-estoq and param-estoq.tp-fech = 1 then
                assign da-ult-fech-dia = param-estoq.ult-fech-dia.
    &else
        if  avail param-estoq then
            assign da-ult-fech-dia = param-estoq.ult-fech-dia.
    &endif
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bloqueiaExclusaoEventoEMS5 DBOProgram 
PROCEDURE bloqueiaExclusaoEventoEMS5 :
/*------------------------------------------------------------------------------
  Purpose:    bloquear delete no EMS5 se o MAQ usar o evento
  Parameters: p-cod-evento tt-estab-usa-event
  Notes:      retornar tt com estabel que utilizam o param de entrada  
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAM p-cod-evento LIKE event-aquis-rural.cod-evento NO-UNDO.
  DEFINE OUTPUT PARAM TABLE FOR tt-estab-usa-event.

  EMPTY TEMP-TABLE tt-estab-usa-event NO-ERROR.

  FOR EACH event-aquis-rural FIELDS (cod-estabel) NO-LOCK 
    WHERE event-aquis-rural.cod-estabel = p-cod-evento:

      CREATE tt-estab-usa-event.
      ASSIGN tt-estab-usa-event.cod-evento  = event-aquis-rural.cod-evento
             tt-estab-usa-event.cod-estabel = event-aquis-rural.cod-estabel.

  END.
  
  RETURN "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaEstabelPerFechado DBOProgram 
PROCEDURE verificaEstabelPerFechado :
/*------------------------------------------------------------------------------
  Purpose:    gerar aviso estabelecimentos com periodo fechado
  Notes:      retornar lista com estabel que tenham periodo fechado
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAM p-cod-periodo     LIKE param-aquis-rural.cod-periodo NO-UNDO.
    DEFINE INPUT  PARAM p-cod-estabel-ini LIKE param-aquis-rural.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAM p-cod-estabel-fim LIKE param-aquis-rural.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAM p-c-lista         AS   CHARACTER                     NO-UNDO.
    
    FOR EACH param-aquis-rural FIELDS(cod-estabel cod-periodo) NO-LOCK
        WHERE param-aquis-rural.cod-estabel >= p-cod-estabel-ini
          AND param-aquis-rural.cod-estabel <= p-cod-estabel-fim
          AND param-aquis-rural.cod-periodo >= p-cod-periodo:

        ASSIGN p-c-lista = p-c-lista + param-aquis-rural.cod-estabel + ", ".

    END.
    
    
    RETURN "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTTVariaveisImptoSanid DBOProgram 
PROCEDURE createTTVariaveisImptoSanid :
/*------------------------------------------------------------------------------
  Purpose:    criar a temp-table de variaveis para calculo do imposto
              de sanidade animal
------------------------------------------------------------------------------*/

    empty temp-table tt-variaveis.
    
    {utp/ut-liter.i "Volume_mensal_do_produtor/propriedade"}

    create tt-variaveis.
    assign tt-variaveis.nome-variavel = "VOLUME_MES":U
           tt-variaveis.descricao     = return-value
           tt-variaveis.sequencia     = 1.    
    
    RETURN "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTTVariaveisImptoSanid DBOProgram 
PROCEDURE getTTVariaveisImptoSanid :
/*------------------------------------------------------------------------------
  Purpose:    retornar a temp-table de variaveis para calculo do imposto
              de sanidade animal
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM TABLE FOR tt-variaveis.
    
    RETURN "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

