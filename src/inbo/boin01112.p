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
{include/i-prgvrs.i BOIN01112 2.00.00.034 } /*** "010034" 17/06/2025 16:40:44 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin01112 MUT}
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
/* define pre processador*/
{cdp/cdcfgmat.i}

/* ***************************  Definitions  **************************** */
&IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
    {cqp/cqapi001.i}
&else
    {cqp/cq9050.i}
&ENDIF
                    
{cdp/cd0666.i}

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN01112
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ws-docto-transf-depos
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/* Pre-processadores para ativar XML no DBO */
/* Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /* DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /* Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /* Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /* Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /* Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /* Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /* Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /* DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /* Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /* Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin01112.i RowObject}


{inbo/boin01112.i ttws-docto-transf-depos}
{inbo/boin01113.i ttws-item-docto-transf-depos}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
 {method/dboqry.i} 


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE i-num-docto-ini LIKE ws-docto-transf-depos.num-docto-transf NO-UNDO.
DEFINE VARIABLE i-num-docto-fim LIKE ws-docto-transf-depos.num-docto-transf NO-UNDO.

DEFINE VARIABLE h_api_cta_ctbl         AS HANDLE    NO-UNDO.
DEFINE VARIABLE h_api_ccusto           AS HANDLE    NO-UNDO.

DEFINE VARIABLE v_des_cta_ctbl         AS CHAR      NO-UNDO.
DEFINE VARIABLE v_ind_finalid_cta      AS CHAR      NO-UNDO.
DEFINE VARIABLE v_num_tip_cta_ctbl     AS INT       NO-UNDO.
DEFINE VARIABLE v_num_sit_cta_ctbl     AS INT       NO-UNDO.

DEFINE VARIABLE iCount                 AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-val-finalid          AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-flag                 AS LOGICAL   NO-UNDO.

DEF TEMP-TABLE tt_log_erro NO-UNDO
    FIELD ttv_num_cod_erro      AS INTEGER FORMAT ">>>>,>>9" LABEL "N£mero"         COLUMN-LABEL "N£mero"
    FIELD ttv_des_msg_ajuda     AS CHARACTER FORMAT "x(40)"  LABEL "Mensagem Ajuda" COLUMN-LABEL "Mensagem Ajuda"
    FIELD ttv_des_msg_erro      AS CHARACTER FORMAT "x(60)"  LABEL "Mensagem Erro"  COLUMN-LABEL "Inconsistància".

DEFINE BUFFER bf-deposito FOR deposito.

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
         HEIGHT             = 11.96
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN rowObject.num-livre-2 = 0.  /* id-docto */

    &IF "{&mgscm_version}" < "2.06B" &THEN
        ASSIGN rowObject.val-livre-2 = 0. /* id-carga */
    &ENDIF

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRoteiroCQ DBOProgram 
PROCEDURE createRoteiroCQ :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM TABLE FOR ttws-docto-transf-depos.
    DEF INPUT PARAM TABLE FOR ttws-item-docto-transf-depos.

    DEF VAR i-operacao      AS INTEGER NO-UNDO.
    DEF VAR i-ficha-cq      AS INTEGER NO-UNDO.
    DEF VAR i-sequencia     AS INTEGER NO-UNDO.

    FOR EACH tt-erro:
        DELETE tt-erro.
    END.

    EMPTY TEMP-TABLE tt-ficha.

    FIND FIRST ttws-docto-transf-depos NO-LOCK NO-ERROR.
    IF NOT AVAIL ttws-docto-transf-depos THEN
        RETURN "NOK":U.

    FIND FIRST ttws-item-docto-transf-depos NO-LOCK NO-ERROR.
    IF NOT AVAIL ttws-item-docto-transf-depos THEN
        RETURN "NOK":U.

    FIND FIRST deposito
        WHERE deposito.cod-depos = ttws-docto-transf-depos.cod-depos-entr NO-LOCK NO-ERROR.
    IF deposito.ind-dep-cq = NO THEN 
        RETURN "OK":U.

    FIND FIRST param-global NO-LOCK NO-ERROR.
    IF NOT AVAIL param-global THEN DO:
        CREATE tt-erro.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "ParÉmetros_Globais_inv†lidos" *}
        ASSIGN tt-erro.mensagem = RETURN-VALUE
               tt-erro.cd-erro  = 99999.
    END.

    FIND FIRST item WHERE
        item.it-codigo = ttws-item-docto-transf-depos.cod-item NO-LOCK NO-ERROR.
    IF NOT AVAIL item THEN DO:
        CREATE tt-erro.
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-item AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Item" *}
        ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-invalido AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "inv†lido" *}
        ASSIGN c-lbl-liter-invalido = TRIM(RETURN-VALUE).
        ASSIGN tt-erro.mensagem = c-lbl-liter-item + " " + ttws-item-docto-transf-depos.cod-item + " " + c-lbl-liter-invalido
               tt-erro.cd-erro  = 99999.
    END.
 
    FIND FIRST estabelec WHERE 
        estabelec.cod-estabel = ttws-docto-transf-depos.cod-estab NO-LOCK NO-ERROR.
    IF NOT AVAIL item THEN DO:
        CREATE tt-erro.
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-estabelecimento AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Estabelecimento" *}
        ASSIGN c-lbl-liter-estabelecimento = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-invalido-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "inv†lido" *}
        ASSIGN c-lbl-liter-invalido-2 = TRIM(RETURN-VALUE).
        ASSIGN tt-erro.mensagem = c-lbl-liter-estabelecimento + " " + ttws-docto-transf-depos.cod-estab + " " + c-lbl-liter-invalido-2
               tt-erro.cd-erro  = 99999.
    END.

    IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

    /*Valida conta contabil*/            
    RUN pi_valida_conta_contabil IN h_api_cta_ctbl (INPUT  estabelec.ep-codigo,                            /* EMPRESA EMS2 */
                                                    INPUT  ttws-docto-transf-depos.cod-estab,              /* ESTABELECIMENTO EMS2 */
                                                    INPUT  "",                                             /* UNIDADE NEG‡CIO */
                                                    INPUT  "",                                             /* PLANO CONTAS */ 
                                                    INPUT  ttws-docto-transf-depos.cod-cta-ctbl-unif,      /* CONTA */
                                                    INPUT  "",                                             /* PLANO CCUSTO */ 
                                                    INPUT  ttws-docto-transf-depos.cod-ccusto-movto-unif,  /* CCUSTO */
                                                    INPUT  ttws-docto-transf-depos.dat-docto,              /* DATA TRANSACAO */
                                                    OUTPUT TABLE tt_log_erro).                             /* ERROS */
    IF RETURN-VALUE = "NOK" THEN DO:
        FOR FIRST tt_log_erro:
            CREATE tt-erro.
            ASSIGN tt-erro.mensagem = tt_log_erro.ttv_des_msg_erro
                   tt-erro.cd-erro  = tt_log_erro.ttv_num_cod_erro.
        END.
    END.

    IF NOT CAN-FIND(FIRST tt-erro NO-LOCK) AND
       param-global.modulo-cq = YES AND
       item.contr-qualid      = YES THEN DO:
       CREATE tt-ficha.
       ASSIGN tt-ficha.cod-depos    = ttws-docto-transf-depos.cod-depos-entr
              tt-ficha.cod-estabel  = ttws-docto-transf-depos.cod-estab
              tt-ficha.it-codigo    = ttws-item-docto-transf-depos.cod-item
              tt-ficha.cod-localiz  = ttws-item-docto-transf-depos.cod-localiz-entr
              tt-ficha.lote         = ttws-item-docto-transf-depos.cod-lote
              tt-ficha.nro-docto    = STRING(ttws-docto-transf-depos.num-docto-transf)
              tt-ficha.op-seq       = ttws-item-docto-transf-depos.num-seq
              tt-ficha.origem       = 2 /* Estoque */ 
              tt-ficha.ct-destino   = ttws-docto-transf-depos.cod-cta-ctbl-unif
              tt-ficha.sc-destino   = ttws-docto-transf-depos.cod-ccusto-movto-unif
              tt-ficha.qt-original  = ttws-item-docto-transf-depos.qtd-item
              tt-ficha.serie-docto  = "" 
              tt-ficha.baixa-estoq  = YES
              tt-ficha.inspecionado = NO.

       &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
            ASSIGN tt-ficha.cod-refer = ttws-item-docto-transf-depos.cod-refer.
       &ENDIF
         
       &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
            run cqp/cqapi001.p (input-output table tt-ficha,
                                input-output table tt-erro,
                                input-output i-ficha-cq,
                                input-output i-operacao).
       &ELSE
            run cqp/cq9050.p (input-output table tt-ficha,
                              input-output table tt-erro,
                              input-output i-ficha-cq,
                              input-output i-operacao).
       &ENDIF                                               
    END.

    IF CAN-FIND(FIRST tt-erro NO-LOCK) THEN DO:
        FOR EACH tt-erro:
            CREATE RowErrors.
            /* Inicio -- Projeto Internacional */
                    ASSIGN RowErrors.ErrorSequence = tt-erro.i-sequen
                        RowErrors.ErrorNumber      = tt-erro.cd-erro
                        RowErrors.ErrorDescription = tt-erro.mensagem
                        RowErrors.ErrorParameters  = ""
                        RowErrors.ErrorType        = "EMS":U
                        RowErrors.ErrorHelp        = tt-erro.mensagem
                        RowErrors.ErrorSubType     = "ERROR":U.
                                                
                        
                        run utp/ut-msgs.p (Input "type":U,
                            Input tt-erro.cd-erro,
                            Input substitute ("&1~~&2~~&3~~&4~~&5~~&6~~&7~~&8~~&9")).                                   
                                                
                        ASSIGN RowErrors.ErrorSubType = RETURN-VALUE.                           
                                                
        END.            
        RETURN "NOK":U. 
    END.

    IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
      DELETE OBJECT h_api_cta_ctbl.
      ASSIGN h_api_cta_ctbl = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLastNumDocTransf DBOProgram 
PROCEDURE findLastNumDocTransf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER pNumDoctoTransf AS INTEGER NO-UNDO.
    
    FIND LAST bf{&TableName} NO-LOCK NO-ERROR.
    
    IF AVAIL bf{&TableName} THEN
        ASSIGN pNumDoctoTransf = INTEGER(bf{&TableName}.num-docto-transf) + 1.
    ELSE
        ASSIGN pNumDoctoTransf = 1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gera-numero-op-manual DBOProgram 
PROCEDURE gera-numero-op-manual :
DEFINE OUTPUT PARAMETER num-digitado AS INTEGER NO-UNDO.

FIND LAST ws-docto-transf-depos NO-LOCK NO-ERROR.
  IF AVAIL ws-docto-transf-depos AND ws-docto-transf-depos.num-docto-transf < 9999999 THEN
      ASSIGN num-digitado = ws-docto-transf-depos.num-docto-transf + 1.
  ELSE DO:
      ASSIGN num-digitado = 1.  
      REPEAT:
      /*find last embarque WHERE embarque.cdd-embarq = de-cdd-embarq no-lock no-error.*/
      IF CAN-FIND(FIRST ws-docto-transf-depos WHERE ws-docto-transf-depos.num-docto-transf = num-digitado) THEN
          ASSIGN num-digitado = num-digitado + 1. 
      ELSE
          LEAVE.
      END.
END.

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
        WHEN "cod-depos-entr":U THEN ASSIGN pFieldValue = RowObject.cod-depos-entr.
        WHEN "cod-depos-saida":U THEN ASSIGN pFieldValue = RowObject.cod-depos-saida.
        WHEN "cod-estab":U THEN ASSIGN pFieldValue = RowObject.cod-estab.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-usuar":U THEN ASSIGN pFieldValue = RowObject.cod-usuar.
        WHEN "cod-cta-ctbl-unif":U THEN ASSIGN pFieldValue = RowObject.cod-cta-ctbl-unif.
        WHEN "cod-ccsuto-movto-unif":U THEN ASSIGN pFieldValue = RowObject.cod-ccusto-movto-unif.
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
        WHEN "dat-docto":U THEN ASSIGN pFieldValue = RowObject.dat-docto.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-livre-3":U THEN ASSIGN pFieldValue = RowObject.val-livre-3.
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
        WHEN "idi-sit-docto":U THEN ASSIGN pFieldValue = RowObject.idi-sit-docto.
        WHEN "num-docto-transf":U THEN ASSIGN pFieldValue = RowObject.num-docto-transf.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice dcttrnsf-num-docto-transf-id
  Parameters:  
               retorna valor do campo num-docto-transf
               retorna valor do campo cod-estab
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-docto-transf LIKE ws-docto-transf-depos.num-docto-transf NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estab LIKE ws-docto-transf-depos.cod-estab NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnum-docto-transf = RowObject.num-docto-transf
           pcod-estab = RowObject.cod-estab.

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
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        WHEN "log-livre-3":U THEN ASSIGN pFieldValue = RowObject.log-livre-3.
        WHEN "log-livre-4":U THEN ASSIGN pFieldValue = RowObject.log-livre-4.
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
  Purpose:     Reposiciona registro com base no °ndice dcttrnsf-num-docto-transf-id
  Parameters:  
               recebe valor do campo num-docto-transf
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-docto-transf LIKE ws-docto-transf-depos.num-docto-transf NO-UNDO.

    FIND FIRST bfws-docto-transf-depos WHERE 
        bfws-docto-transf-depos.num-docto-transf = pnum-docto-transf NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfws-docto-transf-depos THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfws-docto-transf-depos)).
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

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNumDocto DBOProgram 
PROCEDURE openQueryNumDocto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
        WHERE {&TableName}.num-docto-transf >= i-num-docto-ini AND
              {&TableName}.num-docto-transf <= i-num-docto-fim NO-LOCK BY {&TableName}.num-docto-transf INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNumDocto DBOProgram 
PROCEDURE setConstraintNumDocto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pNumDoctoIni LIKE ws-docto-transf-depos.num-docto-transf NO-UNDO.
DEFINE INPUT PARAMETER pNumDoctoFim LIKE ws-docto-transf-depos.num-docto-transf NO-UNDO.

ASSIGN i-num-docto-ini = pNumDoctoIni
       i-num-docto-fim = pNumDoctoFim.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validacoes pertinentes ao DBO
  Parameters:  recebe o tipo de validacao (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.    
    
    /*Inicializa DBO's*/
    IF NOT VALID-HANDLE(h_api_ccusto) THEN
        RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.
    IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

    IF pType = "Create":U THEN DO:
        IF CAN-FIND(FIRST bf{&TableName}
        WHERE bf{&TableName}.num-docto-transf = RowObject.num-docto-transf NO-LOCK) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-documento-transferencia AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Documento_Transferància" *}
            ASSIGN c-lbl-liter-documento-transferencia = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                  &ErrorNumber="1"
                  &ErrorType="EMS"
                  &ErrorParameters="c-lbl-liter-documento-transferencia"}    
        END.          
    END.
    
    IF pType = "Create":U OR pType = "update":U THEN DO:

        /* Alteracao SOH EH PERMITIDA se a SITUACAO do DOCUMENTO estiver como NAO INICIADO ou INATIVO */
        IF RowObject.idi-sit-docto = 1 OR RowObject.idi-sit-docto = 5 THEN DO:

            IF RowObject.dat-docto > TODAY THEN DO:
                {method/svc/errors/inserr.i
                        &ErrorNumber="3375"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters="''"}   
            END.

            FIND FIRST estabelec WHERE
                estabelec.cod-estabel = RowObject.cod-estab NO-LOCK NO-ERROR.
            IF NOT AVAIL estabelec THEN
                /* Inicio -- Projeto Internacional */
                DO:
                DEFINE VARIABLE c-lbl-liter-estabelecimento-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Estabelecimento" *}
                ASSIGN c-lbl-liter-estabelecimento-2 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                        &ErrorNumber="56"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters="c-lbl-liter-estabelecimento-2"}
                END. 
            ELSE DO:
                /*Valida conta contabil*/            
                RUN pi_valida_conta_contabil IN h_api_cta_ctbl (INPUT  estabelec.ep-codigo,             /* EMPRESA EMS2 */
                                                                INPUT  RowObject.cod-estab,             /* ESTABELECIMENTO EMS2 */
                                                                INPUT  "",                              /* UNIDADE NEG‡CIO */
                                                                INPUT  "",                              /* PLANO CONTAS */ 
                                                                INPUT  RowObject.cod-cta-ctbl-unif,     /* CONTA */
                                                                INPUT  "",                              /* PLANO CCUSTO */ 
                                                                INPUT  RowObject.cod-ccusto-movto-unif, /* CCUSTO */
                                                                INPUT  RowObject.dat-docto,             /* DATA TRANSACAO */
                                                                OUTPUT TABLE tt_log_erro).              /* ERROS */
    
                IF RETURN-VALUE = "NOK" THEN DO:
                    FOR FIRST tt_log_erro:
                        RUN _insertErrorManual IN THIS-PROCEDURE (INPUT tt_log_erro.ttv_num_cod_erro,  
                                                                  INPUT "EMS5",                
                                                                  INPUT "ERROR",              
                                                                  INPUT tt_log_erro.ttv_des_msg_erro, 
                                                                  INPUT tt_log_erro.ttv_des_msg_ajuda,
                                                                  INPUT "").                                                    
    
                    END.
                END.
                /*Busca dados da conta*/
                RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT        estabelec.ep-codigo,                  /* EMPRESA EMS2 */
                                                               INPUT        "",                         /* PLANO DE CONTAS */
                                                               INPUT-OUTPUT RowObject.cod-cta-ctbl-unif,/* CONTA */
                                                               INPUT        RowObject.dat-docto,        /* DATA TRANSACAO */   
                                                               OUTPUT       v_des_cta_ctbl,             /* DESCRICAO CONTA */
                                                               OUTPUT       v_num_tip_cta_ctbl,         /* TIPO DA CONTA */
                                                               OUTPUT       v_num_sit_cta_ctbl,         /* SITUAÄ«O DA CONTA */
                                                               OUTPUT       v_ind_finalid_cta,          /* FINALIDADES DA CONTA */
                                                               OUTPUT TABLE tt_log_erro).               /* ERROS */ 
    
                IF RETURN-VALUE = "NOK" THEN DO:
                    FOR FIRST tt_log_erro:
                        RUN _insertErrorManual IN THIS-PROCEDURE (INPUT tt_log_erro.ttv_num_cod_erro,  
                                                                  INPUT "EMS5",                
                                                                  INPUT "ERROR",              
                                                                  INPUT tt_log_erro.ttv_des_msg_erro, 
                                                                  INPUT tt_log_erro.ttv_des_msg_ajuda,                   
                                                                  INPUT "").                                                    
                    END.
                END.
                ELSE DO:         
                    /*verifica se a situaá∆o da conta Ç diferente 3*/
                    IF v_num_sit_cta_ctbl <> 3 THEN DO:
                        {method/svc/errors/inserr.i
                            &ErrorNumber="443"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="''"}
                    END.
                    
                    /*Verifica se Finalidade Ç diferente de 4*/
                    ASSIGN l-flag = YES.
                    DO iCount = 1 TO NUM-ENTRIES(v_ind_finalid_cta):
                      ASSIGN c-val-finalid = ENTRY(iCount, v_ind_finalid_cta).
                      IF {adinc/i05ad049.i 06 c-val-finalid} = 4 THEN
                        ASSIGN l-flag = NO.
                    END.
                    IF l-flag THEN DO:
                        {method/svc/errors/inserr.i
                            &ErrorNumber="2786"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="''"}            
                    END.
                END.
            END.

            IF NOT CAN-FIND(FIRST usuar-mater
            WHERE usuar-mater.cod-usuario = RowObject.cod-usuar NO-LOCK) THEN DO:
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-usuario AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Usu†rio" *}
               ASSIGN c-lbl-liter-usuario = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i
                      &ErrorNumber="56"
                      &ErrorType="EMS"
                      &ErrorSubType="ERROR" 
                      &ErrorParameters="c-lbl-liter-usuario"}
            END.
            
            IF RowObject.cod-depos-entr = RowObject.cod-depos-saida THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-deposito AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Dep¢sito" *}
                ASSIGN c-lbl-liter-deposito = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                    &ErrorNumber="27735"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters="c-lbl-liter-deposito"}
            END.
            
            FIND FIRST deposito
                 WHERE deposito.cod-depos = RowObject.cod-depos-entr NO-LOCK NO-ERROR.
            
            IF NOT AVAIL deposito THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-deposito-entrada AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Dep¢sito_Entrada" *}
                ASSIGN c-lbl-liter-deposito-entrada = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                    &ErrorNumber="56"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters="c-lbl-liter-deposito-entrada"}
            END.
            ELSE DO:
                /* Deposito NAO pode ser de Rejeitos */            
                IF deposito.ind-dep-rej = YES THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-rejeitos-entrada AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Rejeitos" *}
                    ASSIGN c-lbl-liter-rejeitos-entrada = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-deposito-entrada1 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Dep¢sito_Entrada" *}
                    ASSIGN c-lbl-liter-deposito-entrada1 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-merge-rejeitosdeposito-entrada AS CHARACTER NO-UNDO.
                    ASSIGN c-lbl-merge-rejeitosdeposito-entrada = c-lbl-liter-rejeitos-entrada + "~~" + c-lbl-liter-deposito-entrada.
                    {method/svc/errors/inserr.i
                        &ErrorNumber="27581"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters="c-lbl-merge-rejeitosdeposito-entrada"}            
                END.  

                /* Deposito NAO pode ser WMS */
                IF deposito.log-gera-wms = YES THEN DO:
                    //Dep¢sito de entrada com controle de WMS no ERP
                    {method/svc/errors/inserr.i
                        &ErrorNumber="57487" 
                        &ErrorType="EMS"
                        &ErrorParameters="  "}    
                END.

                /* Deposito NAO pode ser externo */
                IF deposito.ind-tipo-dep = 2 THEN DO:
                    //N∆o Ç permitida a movimentaá∆o de Dep¢sitos Externos
                    {method/svc/errors/inserr.i
                        &ErrorNumber="57486"
                        &ErrorType="EMS"
                        &ErrorParameters=" "}
                END.

                /* Deposito de entrada ou saida deve ser Saas
                IF NOT deposito.log-wms-externo THEN DO:
                    FIND FIRST bf-deposito NO-LOCK
                         WHERE bf-deposito.cod-depos = RowObject.cod-depos-sai NO-ERROR.
                    IF AVAIL bf-deposito THEN DO:
                        IF NOT bf-deposito.log-wms-externo THEN DO:
                            //Dep¢sito de entrada ou sa°da deve ser de Controle Saas
                            {method/svc/errors/inserr.i
                                &ErrorNumber="57488" 
                                &ErrorType="EMS"
                                &ErrorParameters="  "}
                        END.
                    END.
                END.
                 */
            END.
            
            FIND FIRST deposito
                 WHERE deposito.cod-depos = RowObject.cod-depos-saida NO-LOCK NO-ERROR.
            
            IF NOT AVAIL deposito THEN DO:    
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-deposito-saida AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Dep¢sito_Sa°da" *}
                ASSIGN c-lbl-liter-deposito-saida = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                    &ErrorNumber="56"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters="c-lbl-liter-deposito-saida"}
            END.     
            ELSE DO:
                /* Deposito NAO pode ser de CQ */        
                IF deposito.ind-dep-cq = YES THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-cq AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "CQ" *}
                    ASSIGN c-lbl-liter-cq = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-deposito-saida-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Dep¢sito_Sa°da" *}
                    ASSIGN c-lbl-liter-deposito-saida-2 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-merge-cqdeposito-saida AS CHARACTER NO-UNDO.
                    ASSIGN c-lbl-merge-cqdeposito-saida = c-lbl-liter-cq + "~~" + c-lbl-liter-deposito-saida-2.
                    {method/svc/errors/inserr.i
                        &ErrorNumber="27581"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters="c-lbl-merge-cqdeposito-saida"}
                END.
                /* Deposito NAO pode ser de Rejeitos */            
                IF deposito.ind-dep-rej = YES THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-rejeitos AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Rejeitos" *}
                    ASSIGN c-lbl-liter-rejeitos = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-deposito-saida-3 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Dep¢sito_Sa°da" *}
                    ASSIGN c-lbl-liter-deposito-saida-3 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-merge-rejeitosdeposito-saida AS CHARACTER NO-UNDO.
                    ASSIGN c-lbl-merge-rejeitosdeposito-saida = c-lbl-liter-rejeitos + "~~" + c-lbl-liter-deposito-saida-3.
                    {method/svc/errors/inserr.i
                        &ErrorNumber="27581"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters="c-lbl-merge-rejeitosdeposito-saida"}            
                END.
                /* Deposito NAO pode ser WMS */
                IF deposito.log-gera-wms THEN DO:
                    /* Inicio -- Projeto Internacional */
                    //Dep¢sito de saida com controle de WMS no ERP
                    {method/svc/errors/inserr.i
                        &ErrorNumber="57487" 
                        &ErrorType="EMS"
                        &ErrorParameters="  "}    
                END.
                    
                /* Deposito NAO pode ser externo */
                IF deposito.ind-tipo-dep = 2 THEN DO:
                    //N∆o Ç permitida a movimentaá∆o de Dep¢sitos Externos
                    {method/svc/errors/inserr.i
                        &ErrorNumber="57486"
                        &ErrorType="EMS"
                        &ErrorParameters=" "}
                END.
            END.   
        END.        
        ELSE DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="6619"
                &ErrorType="EMS"
                &ErrorSubType="ERROR" 
                &ErrorParameters="''"}  
        END.
    END.
    
    IF pType = "Delete":U THEN DO: 
        IF RowObject.idi-sit-docto <> 1
        AND RowObject.idi-sit-docto <> 5 THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-documento AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Documento" *}
            ASSIGN c-lbl-liter-documento = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                &ErrorNumber="16668"
                &ErrorType="EMS"
                &ErrorSubType="ERROR" 
                &ErrorParameters="c-lbl-liter-documento"}                    
        END.
        
        IF CAN-FIND(FIRST ws-item-docto-transf-depos WHERE
            ws-item-docto-transf-depos.num-docto-transf = RowObject.num-docto-transf NO-LOCK) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-docto-transf AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Docto_Transf" *}
            ASSIGN c-lbl-liter-docto-transf = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-item-do-docto-transf AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item_do_Docto_Transf" *}
            ASSIGN c-lbl-liter-item-do-docto-transf = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-merge-docto-transfitem-do-docto-tran AS CHARACTER NO-UNDO.
            ASSIGN c-lbl-merge-docto-transfitem-do-docto-tran = c-lbl-liter-docto-transf + '.' + "~~" + c-lbl-liter-item-do-docto-transf + '.'.
            {method/svc/errors/inserr.i
                &ErrorNumber="5"
                &ErrorType="EMS"
                &ErrorSubType="ERROR" 
                &ErrorParameters="c-lbl-merge-docto-transfitem-do-docto-tran"}                    
        END.
    END.
    
    /*Destroy DBO*/
    IF VALID-HANDLE(h_api_ccusto) THEN DO:
      DELETE OBJECT h_api_ccusto.
      ASSIGN h_api_ccusto = ?.
    END.
    IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
      DELETE OBJECT h_api_cta_ctbl.
      ASSIGN h_api_cta_ctbl = ?.
    END.

    /*--- Verifica ocorr¨ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

