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
{include/i-prgvrs.i BOCX361 2.00.00.011 } /*** "010011" 11/12/2023 10:13:27 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX361 MUT}
&ENDIF

/*:T--------------------------------------------------------------------------
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

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX361
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName grp-despes-estab
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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{cxbo/bocx361.i RowObject}
{cdp/cdcfgdis.i}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE i-empresa           LIKE param-global.empresa-prin      NO-UNDO.
DEFINE VARIABLE c-des-cta-desp-exp  as character format 'x(40)'         NO-UNDO.
DEFINE VARIABLE i-cod-grup-desp-ini LIKE grp-despes-estab.cod-grup-desp NO-UNDO.
DEFINE VARIABLE i-cod-grup-desp-fim LIKE grp-despes-estab.cod-grup-desp NO-UNDO.
DEFINE VARIABLE c-cod-estabel-ini   LIKE grp-despes-estab.cod-estabel   NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim   LIKE grp-despes-estab.cod-estabel   NO-UNDO.
DEFINE VARIABLE c-msg               AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE i-tipo              AS INTEGER                          NO-UNDO.
DEFINE VARIABLE i-estado            AS INTEGER                          NO-UNDO.
DEFINE VARIABLE i-faturamento       AS INTEGER                          NO-UNDO.

def var h_api_cta_ctbl as handle no-undo. /* utb743za.py */
def var h_api_ccusto   as handle no-undo. /* utb742za.py */
def var v_des_cta_ctbl      as character format 'x(40)'             no-undo.
def var v_num_tip_cta_ctbl  as integer                              no-undo.
def var v_num_sit_cta_ctbl  as integer                              no-undo.
def var v_ind_finalid_cta   as char                                 no-undo.

def var v_cod_ccusto        as char   no-undo.
def var v_titulo_ccusto     as char   no-undo.
def var v_log_utz_ccusto    as log    no-undo.
                                                                            
DEFINE TEMP-TABLE tt_log_erro NO-UNDO                                       
     FIELD ttv_num_cod_erro AS integer INITIAL ?                            
     FIELD ttv_des_msg_ajuda AS character INITIAL ?                         
     FIELD ttv_des_msg_erro AS character INITIAL ?.                         

EMPTY TEMP-TABLE tt_log_erro.

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
         HEIGHT             = 13.88
         WIDTH              = 30.72.
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        /*---[ Conforme DIS de Unificaá∆o de Conceito: Exportaá∆o ]------------------------------------------------------------*/
        WHEN "cod-ct-despes-export":U  THEN ASSIGN pFieldValue = RowObject.cod-ct-despes-export.
        WHEN "cod-cc-despes-export":U  THEN ASSIGN pFieldValue = RowObject.cod-cc-despes-export.
        /*------------------------------------------------------------[ Conforme DIS de Unificaá∆o de Conceito: Exportaá∆o ]---*/
        WHEN "cod-estabel":U           THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U           THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U           THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
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
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDesCct DBOProgram 
PROCEDURE getDesCct :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM c-cod-estabel AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM p-cod-ccusto  AS CHARACTER NO-UNDO.
    
    EMPTY TEMP-TABLE tt_log_erro.

    if not valid-handle(h_api_ccusto)   then run prgint/utb/utb742za.py persistent set h_api_ccusto.


    IF c-cod-estabel <> "?":U THEN DO:
       FIND estabelec WHERE
            estabelec.cod-estabel = c-cod-estabel NO-LOCK NO-ERROR.
       IF AVAIL estabelec THEN 
           RUN cdp/cd9970.p (INPUT  ROWID(estabelec),
                             OUTPUT i-empresa). 
    END.                      
    ELSE DO:
        FIND FIRST param-global NO-LOCK NO-ERROR.
        IF AVAIL param-global THEN 
           ASSIGN i-empresa = param-global.empresa-prin.            
    END.   
         
    run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,          /* EMPRESA EMS2 */
                                               input  "",                 /* CODIGO DO PLANO CCUSTO */
                                               input  p-cod-ccusto,       /* CCUSTO */
                                               input  today,              /* DATA DE TRANSACAO */
                                               output v_titulo_ccusto,    /* DESCRICAO DO CCUSTO */
                                               output table tt_log_erro). /* ERROS */ 

    IF VALID-HANDLE(h_api_ccusto) THEN DO:
        DELETE PROCEDURE h_api_ccusto.
        ASSIGN h_api_ccusto = ?.
    END.

    FIND FIRST tt_log_erro NO-ERROR.
    IF AVAIL tt_log_erro THEN
        RETURN "NOK".

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDesCta DBOProgram 
PROCEDURE getDesCta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM c-cod-estabel         AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM p-cod-ct-despes-export AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM c-des-cta-desp-exp    AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM i-tipo                AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAM i-estado              AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAM i-faturamento         AS INTEGER   NO-UNDO.

    if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.    

    IF c-cod-estabel <> "?":U THEN DO:

        if not valid-handle(h_api_ccusto)   then run prgint/utb/utb742za.py persistent set h_api_ccusto.

        FIND estabelec WHERE
             estabelec.cod-estabel = c-cod-estabel NO-LOCK NO-ERROR.
        IF AVAIL estabelec THEN DO:
            RUN cdp/cd9970.p (INPUT  ROWID(estabelec),
                              OUTPUT i-empresa).

            RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        i-empresa,          /* EMPRESA EMS2 */
                                                           INPUT        "",                 /* PLANO DE CONTAS */
                                                           INPUT-OUTPUT p-cod-ct-despes-export, /* CONTA */
                                                           INPUT        TODAY,              /* DATA TRANSACAO */   
                                                           OUTPUT       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                           OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                           OUTPUT       v_num_sit_cta_ctbl, /* SITUA∞ÄO DA CONTA */
                                                           OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                           OUTPUT TABLE tt_log_erro).       /* ERROS */
            IF RETURN-VALUE = "NOK" THEN RETURN "NOK".
            
            run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,              /* EMPRESA EMS 2 */
                                                               input  c-cod-estabel,          /* ESTABELECIMENTO EMS2 */
                                                               input  "",                     /* PLANO CONTAS */
                                                               input  p-cod-ct-despes-export, /* CONTA */
                                                               input  today,                  /* DT TRANSACAO */
                                                               output v_log_utz_ccusto,       /* UTILIZA CCUSTO ? */
                                                               output table tt_log_erro).     /* ERROS */                                                                                                                            

            ASSIGN c-des-cta-desp-exp = v_des_cta_ctbl
                   i-tipo             = v_num_tip_cta_ctbl
                   i-estado           = v_num_sit_cta_ctbl.
                   
            RUN pi_valida_cta_ctbl_integr IN h_api_cta_ctbl (INPUT        i-empresa,              /* EMPRESA EMS2 */
                                                             INPUT        "FTP",                  /* M‡DULO */
                                                             INPUT        "",                     /* PLANO */
                                                             INPUT        p-cod-ct-despes-export, /* CONTA */
                                                             INPUT        "(nenhum)",             /* FINALIDADE */
                                                             INPUT        TODAY,                  /* DATA TRANSACAO */   
                                                             OUTPUT TABLE tt_log_erro).           /* ERROS */
            IF RETURN-VALUE = "NOK" THEN
                ASSIGN i-faturamento = 1.
            ELSE
                ASSIGN i-faturamento = 0.

            IF VALID-HANDLE(h_api_ccusto) THEN DO:
                DELETE PROCEDURE h_api_ccusto.
                ASSIGN h_api_ccusto = ?.
            END.
            
        END.
    END.
    ELSE DO:
        FIND FIRST param-global NO-LOCK NO-ERROR.
        IF AVAIL param-global THEN DO:
            RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        param-global.empresa-prin,          /* EMPRESA EMS2 */
                                                           INPUT        "",                 /* PLANO DE CONTAS */
                                                           INPUT-OUTPUT p-cod-ct-despes-export, /* CONTA */
                                                           INPUT        TODAY,              /* DATA TRANSACAO */   
                                                           OUTPUT       v_des_cta_ctbl,     /* DESCRICAO CONTA */
                                                           OUTPUT       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                           OUTPUT       v_num_sit_cta_ctbl, /* SITUA∞ÄO DA CONTA */
                                                           OUTPUT       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                           OUTPUT TABLE tt_log_erro).       /* ERROS */
            IF RETURN-VALUE = "NOK" THEN RETURN "NOK".

            ASSIGN c-des-cta-desp-exp = v_des_cta_ctbl
                   i-tipo             = v_num_tip_cta_ctbl
                   i-estado           = v_num_sit_cta_ctbl.
                   
            RUN pi_valida_cta_ctbl_integr IN h_api_cta_ctbl (INPUT        param-global.empresa-prin, /* EMPRESA EMS2 */
                                                             INPUT        "FTP",                  /* M‡DULO */
                                                             INPUT        "",                     /* PLANO */
                                                             INPUT        p-cod-ct-despes-export, /* CONTA */
                                                             INPUT        "(nenhum)",             /* FINALIDADE */
                                                             INPUT        TODAY,                  /* DATA TRANSACAO */   
                                                             OUTPUT TABLE tt_log_erro).           /* ERROS */
            IF RETURN-VALUE = "NOK" THEN
                ASSIGN i-faturamento = 1.
            ELSE
                ASSIGN i-faturamento = 0.
                                   
        END.
    END.

    IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
        DELETE PROCEDURE h_api_cta_ctbl.
        ASSIGN h_api_cta_ctbl = ?.
    END.
        
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
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-grup-desp":U THEN ASSIGN pFieldValue = RowObject.cod-grup-desp.
        WHEN "num-livre-1":U   THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U   THEN ASSIGN pFieldValue = RowObject.num-livre-2.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.


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
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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
  Purpose:     Reposiciona registro com base no °ndice default
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pCodGrupDesp LIKE grp-despes-estab.cod-grup-desp NO-UNDO.
    DEFINE INPUT PARAMETER pCodEstabel  LIKE grp-despes-estab.cod-estabel   NO-UNDO.

    FIND FIRST bfgrp-despes-estab NO-LOCK WHERE
               bfgrp-despes-estab.cod-grup-desp = pCodGrupDesp AND
               bfgrp-despes-estab.cod-estabel   = pCodEstabel NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfgrp-despes-estab THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfgrp-despes-estab)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQuery DBOProgram 
PROCEDURE OpenQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER i-abertura AS INTEGER NO-UNDO.

    CASE i-abertura:
        WHEN 1 THEN
            RUN openQueryStatic (INPUT "Main":U).

        WHEN 2 THEN
            RUN openQueryStatic (input "ByGrupDesp":U).
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByGrupDesp DBOProgram 
PROCEDURE openQueryByGrupDesp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&QUERYNAME} for each {&TABLENAME} where
               (grp-despes-estab.cod-grup-desp >= i-cod-grup-desp-ini and
                grp-despes-estab.cod-grup-desp <= i-cod-grup-desp-fim or grp-despes-estab.cod-grup-desp = ?) and
               (grp-despes-estab.cod-estabel   >= c-cod-estabel-ini   and
                grp-despes-estab.cod-estabel   <= c-cod-estabel-fim   or grp-despes-estab.cod-estabel   = ?) no-lock indexed-reposition.

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

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraint2 DBOProgram 
PROCEDURE setconstraint2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-grup-desp-ini AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-grup-desp-fim AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-ini   AS CHAR    NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-fim   AS CHAR    NO-UNDO.

    RUN setconstraintByGrupDesp (INPUT p-cod-grup-desp-ini,
                                 INPUT p-cod-grup-desp-fim,
                                 INPUT p-cod-estabel-ini,
                                 INPUT p-cod-estabel-fim).

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setconstraintByGrupDesp DBOProgram 
PROCEDURE setconstraintByGrupDesp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-cod-grup-desp-ini AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-grup-desp-fim AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-ini   AS CHAR    NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-fim   AS CHAR    NO-UNDO.

    ASSIGN i-cod-grup-desp-ini = p-cod-grup-desp-ini
           i-cod-grup-desp-fim = p-cod-grup-desp-fim
           c-cod-estabel-ini   = p-cod-estabel-ini
           c-cod-estabel-fim   = p-cod-estabel-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    IF pType = "CREATE":U THEN DO:

        IF CAN-FIND (FIRST bfgrp-despes-estab WHERE
                           bfgrp-despes-estab.cod-grup-desp = RowObject.cod-grup-desp AND
                           bfgrp-despes-estab.cod-estabel   = RowObject.cod-estabel NO-LOCK) THEN DO:

            {utp/ut-table.i mgcex grp-despes-estab 1}
            ASSIGN c-msg = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="1"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-msg"}
        END.

        IF RowObject.cod-grup-desp <> ? THEN DO:
            FIND FIRST grupo-desp NO-LOCK WHERE
                       grupo-desp.cod-grup-desp = RowObject.cod-grup-desp NO-ERROR.
            IF NOT AVAIL grupo-desp THEN DO:
                {utp/ut-field.i mgcex grp-despes-estab cod-grup-desp 1}
                ASSIGN c-msg = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="2"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="c-msg"}
            END.
        END.
        
        IF RowObject.cod-estabel <> ? THEN DO:
            FIND FIRST estabelec NO-LOCK WHERE
                       estabelec.cod-estabel = RowObject.cod-estabel NO-ERROR.
            IF NOT AVAIL estabelec THEN DO:
                {utp/ut-field.i mgcex grp-despes-estab cod-estabel 1}
                ASSIGN c-msg = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="2"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="c-msg"}
            END.
        END.

    END.

    IF pType = "CREATE":U OR
       pType = "UPDATE":U THEN DO:

        RUN getDesCta (INPUT  RowObject.cod-estabel,
                       /*---[ Conforme DIS de Unificaá∆o de Conceito: Exportaá∆o ]------------------------------------------------------------*/
                       INPUT RowObject.cod-ct-despes-export,
                       /*------------------------------------------------------------[ Conforme DIS de Unificaá∆o de Conceito: Exportaá∆o ]---*/
                       OUTPUT c-des-cta-desp-exp,
                       OUTPUT i-tipo,
                       OUTPUT i-estado,
                       OUTPUT i-faturamento).

        IF RETURN-VALUE = "NOK":U THEN DO:
            /*---[ Conforme DIS de Unificaá∆o de Conceito: Exportaá∆o ]------------------------------------------------------------*/
            {utp/ut-field.i mgcex grp-despes-estab cod-ct-despes-export 1}
            /*------------------------------------------------------------[ Conforme DIS de Unificaá∆o de Conceito: Exportaá∆o ]---*/
            
            ASSIGN c-msg = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-msg"}
        END.
        ELSE DO:
            IF i-tipo = 6 THEN DO: /*Conta Contabil nao pode ser do tipo Titulo*/
                {method/svc/errors/inserr.i &ErrorNumber="5000"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="''"}
            END.
            IF  i-estado = 1 THEN DO: /*Conta Contabil deve ser de Sistema*/
                /*---[ Conforme DIS de Unificaá∆o de Conceito: Exportaá∆o ]------------------------------------------------------------*/
                {method/svc/errors/inserr.i &ErrorNumber="638"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="RowObject.cod-ct-despes-export"}
                /*------------------------------------------------------------[ Conforme DIS de Unificaá∆o de Conceito: Exportaá∆o ]---*/                                                
            END.

            IF  i-estado = 2 THEN DO: /*Conta Contabil esta desativada*/
                /*---[ Conforme DIS de Unificaá∆o de Conceito: Exportaá∆o ]------------------------------------------------------------*/
                {method/svc/errors/inserr.i &ErrorNumber="913"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="RowObject.cod-ct-despes-export"}
                /*------------------------------------------------------------[ Conforme DIS de Unificaá∆o de Conceito: Exportaá∆o ]---*/
            END.

            IF i-faturamento = 1 THEN DO: /*Conta Contabil nao pode receber lancamentos do modulo de Faturamento*/
                {method/svc/errors/inserr.i &ErrorNumber="915"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="''"}
            END.
        END.
        
        IF v_log_utz_ccusto THEN DO:
           RUN getDesCct (INPUT RowObject.cod-estabel,
                          INPUT RowObject.cod-cc-despes-export).

           IF RETURN-VALUE = "NOK":U THEN DO: 
              {utp/ut-liter.i Centro_Custo * L}
            
              ASSIGN c-msg = TRIM(RETURN-VALUE). 
              {method/svc/errors/inserr.i &ErrorNumber="2"
                                          &ErrorType="EMS":U
                                          &ErrorSubType="ERROR":U
                                          &ErrorParameters="c-msg"}
           END.                               
        END.           
    END.

    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

