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
&GLOBAL-DEFINE DBOName BOIN01009
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName naocfedade-carg
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
{inbo/boin01009.i RowObject}
{inbo/boin01009.i RowObjectNC}
{inbo/boin01009.i1 tt-gera-nc row-errors-nc}
{rep/re1005b.i new} /* Definicao TT-MOVTO */
{cdp/cd0666.i}      /* tt-erro */
{utp/ut-glob.i}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
/*{method/dboqry.i}*/


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName}       FOR {&TableName}.
DEFINE BUFFER bf-histor-naocfedade FOR histor-naocfedade.
DEFINE BUFFER bf-carg-rural        FOR carg-rural.
DEFINE BUFFER bf-produt-carg       FOR produt-carg.


DEFINE VARIABLE h-ceapi001k           AS HANDLE                            NO-UNDO.
DEFINE VARIABLE h-movto-event-financ  AS HANDLE                            NO-UNDO.
DEFINE VARIABLE l-dif-quantidade      AS LOG                               NO-UNDO.
DEFINE VARIABLE l-problema-qualidade  AS LOG                               NO-UNDO.
DEFINE VARIABLE l-nao-coleta          AS LOG                               NO-UNDO.
DEFINE VARIABLE l-pendente            AS LOG                               NO-UNDO.  
DEFINE VARIABLE l-em-analise          AS LOG                               NO-UNDO.
DEFINE VARIABLE l-resolvida           AS LOG                               NO-UNDO.  
DEFINE VARIABLE c-estabelecimento     LIKE naocfedade-carg.cod-estabel     NO-UNDO.
DEFINE VARIABLE i-carg-ini            LIKE naocfedade-carg.num-carg        NO-UNDO.
DEFINE VARIABLE i-carg-fim            LIKE naocfedade-carg.num-carg        NO-UNDO.
DEFINE VARIABLE i-naocfedade-ini      LIKE naocfedade-carg.cdn-naocfedade  NO-UNDO.
DEFINE VARIABLE i-naocfedade-fim      LIKE naocfedade-carg.cdn-naocfedade  NO-UNDO.
DEFINE VARIABLE dt-data-ini           LIKE naocfedade-carg.dat-trans       NO-UNDO.
DEFINE VARIABLE dt-data-fim           LIKE naocfedade-carg.dat-trans       NO-UNDO.



    
/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/ 
{include/i-estab-security.i}
/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH histor-naocfedade EXCLUSIVE-LOCK   
       WHERE histor-naocfedade.cdn-naocfedade = RowObject.cdn-naocfedade:   
        DELETE histor-naocfedade.
    END.

    FOR EACH dest-cust-naocfedade EXCLUSIVE-LOCK 
       WHERE dest-cust-naocfedade.cdn-naocfedade = RowObject.cdn-naocfedade: 
        DELETE dest-cust-naocfedade.
    END.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE elimina-nao-conformidade DBOProgram 
PROCEDURE elimina-nao-conformidade :
/*------------------------------------------------------------------------------
  Purpose: Procedure responsavel por excluir nao conformidades da carga.  
  Parameters:  p-num-carg => numero da carga
               p-idi-tip-naocfedade => 1 - Dif. Quantidade
                                       2 - Problema Qualidade
                                       3 - Nao coleta
  Notes: naocfedade-carg.cdn-sit => 1 - Pendente
                                    2 - Em analise
                                    3 - Resolvida
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-carg           AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-idi-tip-naocfedade AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR row-errors-nc.   
    
    RUN openQueryStatic IN THIS-PROCEDURE(INPUT "Main":U).
    blk-nc:
    FOR EACH naocfedade-carg NO-LOCK
       WHERE naocfedade-carg.num-carg           = p-num-carg 
         AND naocfedade-carg.idi-tip-naocfedade = p-idi-tip-naocfedade
         AND naocfedade-carg.cdn-sit < 3:
         
        RUN goToKey IN THIS-PROCEDURE(INPUT naocfedade-carg.cdn-naocfedade).
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN deleteRecord IN THIS-PROCEDURE.        
        END.
        
        RUN getRowErrors IN THIS-PROCEDURE(OUTPUT TABLE row-errors-nc).        
        IF CAN-FIND(FIRST row-errors-nc) THEN DO:
            UNDO blk-nc, LEAVE blk-nc.           
        END.  
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE delete-naocfedade-by-carg-rural DBOProgram 
PROCEDURE delete-naocfedade-by-carg-rural :
/*------------------------------------------------------------------------------
  Purpose: Procedure responsavel por excluir nao conformidades da carga.  
  Parameters: Eliminar todas as NC's de uma carga
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-carg           AS INTEGER NO-UNDO.
    
    RUN openQueryStatic IN THIS-PROCEDURE(INPUT "Main":U).
    
    FOR EACH naocfedade-carg NO-LOCK
       WHERE naocfedade-carg.num-carg = p-num-carg:         
        RUN goToKey IN THIS-PROCEDURE(INPUT naocfedade-carg.cdn-naocfedade).
        IF RETURN-VALUE = "OK":U THEN
            RUN deleteRecord IN THIS-PROCEDURE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gera-evento-financ DBOProgram 
PROCEDURE gera-evento-financ :
/*------------------------------------------------------------------------------
  Purpose:  Geracao de eventos finaceiros 
  Parameters:                                            
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE VARIABLE c-cod-period      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-des-movto-event AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-lbl-carg        AS CHARACTER NO-UNDO.
    
    
    {utp/ut-liter.i NC_Carga}
    ASSIGN c-lbl-carg = RETURN-VALUE .
    IF AVAIL bf{&TableName} AND VALID-HANDLE(h-movto-event-financ) THEN DO:

        FOR EACH dest-cust-naocfedade EXCLUSIVE-LOCK
           WHERE dest-cust-naocfedade.cdn-naocfedade = bf{&TableName}.cdn-naocfedade:
            
            FOR FIRST bf-carg-rural FIELDS(dat-trans it-codigo cod-rota num-carg) NO-LOCK
                WHERE bf-carg-rural.num-carg =  bf{&TableName}.num-carg:
                
                ASSIGN c-des-movto-event = c-lbl-carg + ": " + STRING(bf-carg-rural.num-carg).                     
                FOR FIRST estabelec FIELDS(ep-codigo) NO-LOCK
                    WHERE estabelec.cod-estabel = bf{&TableName}.cod-estabel: END.
                
                EMPTY TEMP-TABLE tt_movto_event_financ NO-ERROR.
                EMPTY TEMP-TABLE tt_row_errors         NO-ERROR.
                
                IF bf{&TableName}.idi-tip-naocfedade = 2 THEN DO:                
                    FOR FIRST liber-carg FIELDS(codigo-rejei) NO-LOCK
                        WHERE liber-carg.num-carg = bf{&TableName}.num-carg
                          AND liber-carg.cdn-compart = bf{&TableName}.cdn-compart:
                          
                        FOR FIRST cod-rejeicao FIELDS(codigo-rejei descricao)NO-LOCK
                            WHERE cod-rejeicao.codigo-rejei = liber-carg.codigo-rejei:
                            {utp/ut-liter.i Rejei‡Æo *}
                            ASSIGN c-des-movto-event = c-des-movto-event + ", " + RETURN-VALUE + ": " + STRING(cod-rejeicao.codigo-rejei) + " - " + cod-rejeicao.descricao.
                        END.
                    END.
                END.
                
                CREATE tt_movto_event_financ.
                ASSIGN tt_movto_event_financ.tta_cod_empresa                = estabelec.ep-codigo WHEN AVAIL estabelec
                       tt_movto_event_financ.tta_cdn_fornecedor             = dest-cust-naocfedade.cdn-destin
                       tt_movto_event_financ.tta_cod_event_financ           = dest-cust-naocfedade.cod-event-financ
                       tt_movto_event_financ.tta_dat_movto_event            = dest-cust-naocfedade.dat-vencto
                       tt_movto_event_financ.tta_num_seq_movto_event        =  0 
                       tt_movto_event_financ.tta_des_movto_event            = c-des-movto-event
                       tt_movto_event_financ.tta_cod_indic_econ             = "" /*EMS5 pega do parâmetro geral dos eventos*/
                       tt_movto_event_financ.tta_val_movto_event            = dest-cust-naocfedade.val-dest
                       tt_movto_event_financ.tta_log_integr                 = YES
                       tt_movto_event_financ.tta_num_id_fechto_event_financ = 0
                       tt_movto_event_financ.tta_ind_orig_movto_event       = "AQR":U                       
                       tt_movto_event_financ.tta_cod_prop_rural             = dest-cust-naocfedade.cod-propried 
                       tt_movto_event_financ.tta_num_parc_movto             = 0 /*Documentacional*/
                       tt_movto_event_financ.tta_cod_estab                  = bf{&TableName}.cod-estabel
                       tt_movto_event_financ.tta_cod_rota                   = bf-carg-rural.cod-rota.
                       
                FOR FIRST item FIELDS(it-codigo un) NO-LOCK
                    WHERE item.it-codigo = bf-carg-rural.it-codigo:
                    FOR FIRST tab-unidade FIELDS(un descricao) NO-LOCK
                        WHERE tab-unidade.un = item.un:
                        ASSIGN tt_movto_event_financ.tta_des_unid_event = tab-unidade.descricao.                       
                    END.
                END.
                       
                RUN pi_create_movto_event_financ in h-movto-event-financ (INPUT-OUTPUT TABLE tt_movto_event_financ,
                                                                          OUTPUT TABLE tt_row_errors).    

                IF CAN-FIND(FIRST tt_row_errors) THEN DO:
                    FOR EACH tt_row_errors:                                                                 
                        CREATE rowErrors.
                        ASSIGN rowErrors.ErrorSequence    = tt_row_errors.ttv_num_seq_erro
                               rowErrors.ErrorNumber      = tt_row_errors.ttv_num_erro
                               rowErrors.ErrorType        = tt_row_errors.ttv_des_type
                               rowErrors.ErrorSubType     = tt_row_errors.ttv_des_sub_type
                               rowErrors.ErrorDescription = tt_row_errors.ttv_des_erro
                               rowErrors.ErrorHelp        = tt_row_errors.ttv_des_help
                               rowErrors.ErrorParameters  = tt_row_errors.ttv_des_param.
                        RETURN "NOK":U. 
                    END.
                END.
                
                FOR FIRST tt_movto_event_financ:
                    ASSIGN dest-cust-naocfedade.cdn-id-movto-event = tt_movto_event_financ.tta_num_id_movto_event.
                END.
            END. 
        END.
    END.    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gera-movto-estoque DBOProgram 
PROCEDURE gera-movto-estoque :
/*------------------------------------------------------------------------------
  Purpose:  Valida‡äes pertinentes à rotina de resolução de nao conformidades  
  Parameters:                                            
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-dat-trans AS DATE NO-UNDO.

    DEFINE VARIABLE i-seq-movto      AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-seq-erro       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-cod-depos      AS CHARACTER NO-UNDO.
    
    IF AVAIL bf{&TableName} THEN DO: 
        FOR EACH dest-cust-naocfedade  EXCLUSIVE-LOCK
            WHERE dest-cust-naocfedade.cdn-naocfedade = bf{&TableName}.cdn-naocfedade:
            
            FOR FIRST bf-carg-rural FIELDS(it-codigo cod-estabel cod-refer num-carg) NO-LOCK
                WHERE bf-carg-rural.num-carg =  bf{&TableName}.num-carg:
                
                FOR FIRST item FIELDS(un tipo-con-est) NO-LOCK 
                     WHERE item.it-codigo = bf-carg-rural.it-codigo: END.
                
                FOR FIRST item-uni-estab FIELDS(cod-localiz deposito-pad) NO-LOCK
                    WHERE item-uni-estab.it-codigo   = bf-carg-rural.it-codigo
                      AND item-uni-estab.cod-estabel = bf-carg-rural.cod-estabel: END.
                      
                FOR FIRST liber-carg FIELDS(cod-depos)
                    WHERE liber-carg.num-carg = bf-carg-rural.num-carg
                      AND liber-carg.idi-aprova = 2:  /* APROVADO */ END.
                IF AVAIL liber-carg THEN
                    ASSIGN c-cod-depos = liber-carg.cod-depos.
                ELSE 
                IF AVAIL item-uni-estab THEN 
                    ASSIGN c-cod-depos = item-uni-estab.deposito-pad.                
                
                EMPTY TEMP-TABLE tt-movto      NO-ERROR.
                EMPTY TEMP-TABLE tt_row_errors NO-ERROR.
                EMPTY TEMP-TABLE tt-erro       NO-ERROR.
                CREATE tt-movto.
                ASSIGN tt-movto.cod-versao-integracao = 1 
                       tt-movto.cod-prog-orig  = "AQ0318":U                           
                       tt-movto.cod-emitente   = dest-cust-naocfedade.cdn-destin      
                       tt-movto.nro-docto      = STRING(bf{&TableName}.cdn-naocfedade)
                       tt-movto.serie-docto    = ""                                   
                       tt-movto.cod-estabel    = bf{&TableName}.cod-estabel
                       tt-movto.dt-trans       = p-dat-trans 
                       tt-movto.usuario        = c-seg-usuario             
                       tt-movto.referencia     = "RFAQ"                    
                       tt-movto.sequen-nf      = 0                         
                       tt-movto.tipo-trans     = 2 /* saida */             
                       i-seq-movto             = i-seq-movto + 1           
                       tt-movto.i-sequen       = i-seq-movto /* contador */
                       tt-movto.it-codigo      = bf-carg-rural.it-codigo      
                       tt-movto.cod-refer      = bf-carg-rural.cod-refer      
                       tt-movto.un             = item.un WHEN AVAIL item   
                       tt-movto.numero-ordem   = 0
                       tt-movto.quantidade     = 0
                       tt-movto.valor-mat-m[1] = dest-cust-naocfedade.val-dest
                       tt-movto.esp-docto      = 11 /* EPR - Entrada Produ‡Æo Rural */     
                       tt-movto.peso-liquido   = 0 
                       tt-movto.descricao-db   = ""
                       tt-movto.cod-depos      = c-cod-depos
                       tt-movto.cod-localiz    = item-uni-estab.cod-localiz WHEN AVAIL item-uni-estab.
                       
                IF item.tipo-con-est = 3 THEN /* lote */                       
                    ASSIGN tt-movto.lote           = STRING(bf-carg-rural.num-carg)
                           tt-movto.dt-vali-lote   = DATE('31/12/2999':U).
                
                IF VALID-HANDLE(h-movto-event-financ) THEN DO:
                    /* Busca conta e centro de custo com base no codigo do evento financeiro */
                    
                    RUN pi_retornar_dados_rat_param_event_financ IN h-movto-event-financ (INPUT dest-cust-naocfedade.cod-event-financ, /* codigo evento */
                                                                                          OUTPUT TABLE tt_dados_rat_param_event,
                                                                                          OUTPUT TABLE tt_row_errors).
                 
                    IF CAN-FIND(FIRST tt_row_errors) THEN DO:
                        FOR EACH tt_row_errors:
                            CREATE rowErrors.
                            ASSIGN rowErrors.ErrorSequence    = tt_row_errors.ttv_num_seq_erro
                                   rowErrors.ErrorNumber      = tt_row_errors.ttv_num_erro
                                   rowErrors.ErrorType        = tt_row_errors.ttv_des_type
                                   rowErrors.ErrorSubType     = tt_row_errors.ttv_des_sub_type
                                   rowErrors.ErrorDescription = tt_row_errors.ttv_des_erro
                                   rowErrors.ErrorHelp        = tt_row_errors.ttv_des_help
                                   rowErrors.ErrorParameters  = tt_row_errors.ttv_des_param.
                        END.
                        RETURN "NOK":U.
                    END.
                    
                    FOR FIRST tt_dados_rat_param_event:
                        ASSIGN tt-movto.ct-codigo      = tt_dados_rat_param_event.tta_cod_cta_ctbl
                               tt-movto.sc-codigo      = tt_dados_rat_param_event.tta_cod_ccusto
                               tt-movto.cod-unid-negoc = tt_dados_rat_param_event.tta_cod_unid_negoc .
                    END.
                END.
                
                IF VALID-HANDLE(h-ceapi001k) THEN DO:
                    RUN pi-execute IN h-ceapi001k (INPUT-OUTPUT TABLE tt-movto,
                                                   INPUT-OUTPUT TABLE tt-erro,
                                                   INPUT YES).
                                                   
                    IF CAN-FIND(FIRST tt-erro) OR RETURN-VALUE = "NOK":U THEN DO:

                      IF RETURN-VALUE = "NOK":U THEN DO:
                        RUN utp/ut-msgs.p (INPUT "help":U,
                                           INPUT 55374,
                                           INPUT "":U).

                        FIND LAST tt-erro NO-ERROR.
                        IF AVAIL tt-erro THEN
                          ASSIGN i-seq-erro = tt-erro.i-sequen + 1.
                        ELSE
                          ASSIGN i-seq-erro = 1.

                        CREATE tt-erro.
                        ASSIGN tt-erro.mensagem    = RETURN-VALUE
                               tt-erro.cd-erro     = 55374
                               tt-erro.i-sequen    = i-seq-erro.
                      END.

                      FOR EACH tt-erro:
                        RUN pi-cria-row-errors IN THIS-PROCEDURE(INPUT tt-erro.cd-erro,
                                                                 INPUT STRING(tt-erro.mensagem,"x(255)")).
                      END.
                      RETURN "NOK":U.
                    END.
                    
                    /* Salva numero da transacao gerada */
                    FOR FIRST tt-movto:
                        ASSIGN dest-cust-naocfedade.nr-trans = tt-movto.nr-trans.
                    END.
                END.
            END.
        END.
    END. 
  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gera-nao-conformidade DBOProgram 
PROCEDURE gera-nao-conformidade :
/*------------------------------------------------------------------------------
  Purpose: Procedure responsavel por gerar nao conformidades da carga.  
  Parameters:  
  Notes:                                                                   
         
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR tt-gera-nc.
    DEFINE OUTPUT PARAMETER TABLE FOR row-errors-nc.     
    DEFINE VARIABLE l-atualiza-dif-qtd AS LOGICAL NO-UNDO.

    EMPTY TEMP-TABLE row-errors-nc NO-ERROR.
    blk-nc:
    FOR EACH tt-gera-nc:

        EMPTY TEMP-TABLE RowObjectNC NO-ERROR.
        
        RUN emptyRowErrors  IN THIS-PROCEDURE.        
        RUN openQueryStatic IN THIS-PROCEDURE(INPUT "Main":U).
        
        ASSIGN l-atualiza-dif-qtd = NO.
        
        /* Verifica se já existe NC do tipo Diferença de quantidade para essa carga. Se já tem deverá atualizar */
        IF tt-gera-nc.idi-tip-naocfedade = 1 THEN DO:        
            FIND FIRST naocfedade-carg NO-LOCK
                 WHERE naocfedade-carg.num-carg           = tt-gera-nc.num-carg
                   AND naocfedade-carg.cdn-compart        = tt-gera-nc.cdn-compart
                   AND naocfedade-carg.idi-tip-naocfedade = tt-gera-nc.idi-tip-naocfedade
                   AND naocfedade-carg.cdn-sit            < 3  NO-ERROR. 
            IF AVAIL naocfedade-carg THEN
                ASSIGN l-atualiza-dif-qtd = YES.
        END.       
        
        /* Verifica se já existe NC do tipo Qualidade para essa carga. Se já tem não será necessário criar nova NC. */
        IF tt-gera-nc.idi-tip-naocfedade = 2 THEN DO: /* QUALIDADE */            
            IF CAN-FIND(FIRST naocfedade-carg
                        WHERE naocfedade-carg.num-carg           = tt-gera-nc.num-carg
                          AND naocfedade-carg.cdn-compart        = tt-gera-nc.cdn-compart
                          AND naocfedade-carg.idi-tip-naocfedade = tt-gera-nc.idi-tip-naocfedade
                          AND naocfedade-carg.cdn-sit            < 3) THEN NEXT.
        END.
        
        /* Se existe NC do tipo Diferença de quantidade para essa carga deverá atualizar */
        IF l-atualiza-dif-qtd THEN DO:
            RUN goToKey   IN THIS-PROCEDURE(INPUT naocfedade-carg.cdn-naocfedade).
            RUN getRecord IN THIS-PROCEDURE(OUTPUT TABLE RowObjectNC).
            FOR FIRST RowObjectNC:
                ASSIGN RowObjectNC.val-quant      = tt-gera-nc.val-quant
                       RowObjectNC.des-naocfedade = tt-gera-nc.des-naocfedade. 
            END.
        END.
        ELSE DO:
            CREATE RowObjectNC. 
            RUN get-create-sequence IN THIS-PROCEDURE(OUTPUT RowObjectNC.cdn-naocfedade).       
            ASSIGN RowObjectNC.num-carg           = tt-gera-nc.num-carg          
                   RowObjectNC.idi-tip-naocfedade = tt-gera-nc.idi-tip-naocfedade
                   RowObjectNC.cod-pto-coleta     = tt-gera-nc.cod-pto-coleta    
                   RowObjectNC.val-quant          = tt-gera-nc.val-quant         
                   RowObjectNC.cdn-identif        = tt-gera-nc.cdn-identif       
                   RowObjectNC.cdn-sit            = tt-gera-nc.cdn-sit           
                   RowObjectNC.cdn-compart        = tt-gera-nc.cdn-compart
                   RowObjectNC.des-naocfedade     = tt-gera-nc.des-naocfedade.
        
            FOR FIRST bf-carg-rural FIELDS(cod-estabel dat-trans) NO-LOCK
                WHERE bf-carg-rural.num-carg = tt-gera-nc.num-carg:
                ASSIGN RowObjectNC.cod-estabel  = bf-carg-rural.cod-estabel.
                       RowObjectNC.dat-trans    = bf-carg-rural.dat-trans.
            END.
        END.
        
        RUN setRecord IN THIS-PROCEDURE(INPUT TABLE RowObjectNC).
        
         /* Se existe NC do tipo Diferença de quantidade para essa carga deverá atualizar */
        IF l-atualiza-dif-qtd THEN
            RUN updateRecord IN THIS-PROCEDURE.
        ELSE 
            RUN createRecord IN THIS-PROCEDURE.
    
        RUN getRowErrors IN THIS-PROCEDURE(OUTPUT TABLE row-errors-nc).

        IF CAN-FIND(FIRST row-errors-nc) THEN DO:
            UNDO blk-nc, LEAVE blk-nc.           
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-cdn-naocfedade-by-produt-carg DBOProgram 
PROCEDURE get-cdn-naocfedade-by-produt-carg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-cdn-identif    AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-cdn-naocfedade AS INTEGER NO-UNDO.

    FOR LAST bf{&TableName} FIELDS(cdn-naocfedade) NO-LOCK
        WHERE bf{&TableName}.cdn-identif = pi-cdn-identif: END.

    IF NOT AVAIL bf{&TableName} THEN
        RETURN "NOK":U.

    ASSIGN pi-cdn-naocfedade = bf{&TableName}.cdn-naocfedade.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE can-find-naocfedade-by-carg DBOProgram 
PROCEDURE can-find-naocfedade-by-carg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-num-carg AS INTEGER NO-UNDO.
    
    IF NOT CAN-FIND(FIRST bf{&TableName} WHERE bf{&TableName}.num-carg = pi-num-carg) THEN
        RETURN "NOK":U.  

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-create-sequence DBOProgram 
PROCEDURE get-create-sequence :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-seq AS INTEGER NO-UNDO.
    blk-1:
    REPEAT: 
        ASSIGN p-seq = NEXT-VALUE(seq-naocfedade).
        IF NOT CAN-FIND(bf{&TableName}
                  WHERE bf{&TableName}.cdn-naocfedade = p-seq) AND p-seq > 0 THEN
            LEAVE blk-1.
    END.

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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-pto-coleta":U THEN ASSIGN pFieldValue = RowObject.cod-pto-coleta.
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
        WHEN "dat-trans":U THEN ASSIGN pFieldValue = RowObject.dat-trans.
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
        WHEN "val-quant":U THEN ASSIGN pFieldValue = RowObject.val-quant.
        WHEN "val-total":U THEN ASSIGN pFieldValue = RowObject.val-total.
        WHEN "val-unit":U THEN ASSIGN pFieldValue = RowObject.val-unit.
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
        WHEN "cdn-compart":U THEN ASSIGN pFieldValue = RowObject.cdn-compart.
        WHEN "cdn-identif":U THEN ASSIGN pFieldValue = RowObject.cdn-identif.
        WHEN "cdn-naocfedade":U THEN ASSIGN pFieldValue = RowObject.cdn-naocfedade.
        WHEN "cdn-sit":U THEN ASSIGN pFieldValue = RowObject.cdn-sit.
        WHEN "idi-tip-naocfedade":U THEN ASSIGN pFieldValue = RowObject.idi-tip-naocfedade.
        WHEN "num-carg":U THEN ASSIGN pFieldValue = RowObject.num-carg.
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
  Purpose:     Retorna valores dos campos do ¡ndice naocfedade-id
  Parameters:  
               retorna valor do campo cdn-naocfedade
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn-naocfedade LIKE naocfedade-carg.cdn-naocfedade NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn-naocfedade = RowObject.cdn-naocfedade.

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
  Purpose:     Reposiciona registro com base no ¡ndice naocfedade-id
  Parameters:  
               recebe valor do campo cdn-naocfedade
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-naocfedade LIKE naocfedade-carg.cdn-naocfedade NO-UNDO.

    FIND FIRST bfnaocfedade-carg WHERE 
        bfnaocfedade-carg.cdn-naocfedade = pcdn-naocfedade NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfnaocfedade-carg THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfnaocfedade-carg)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inic-elimina-handle DBOProgram 
PROCEDURE inic-elimina-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  pi-action => 1- Inicializa  2 - Elimina
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-action AS INTEGER NO-UNDO.
    
    CASE pi-action:
        WHEN 1 THEN DO:
            IF NOT VALID-HANDLE(h-movto-event-financ) THEN 
                RUN prgfin/apb/apb061za.p PERSISTENT SET h-movto-event-financ.
        END.
        
        WHEN 2 THEN DO:            
            IF VALID-HANDLE(h-movto-event-financ) THEN DO:
                DELETE PROCEDURE h-movto-event-financ.
                ASSIGN h-movto-event-financ = ?.
            END.            
        END.
        OTHERWISE
            RETURN "NOK":U.     
    END CASE. 
    
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
    /* Seguran»a por estabelecimento */
    &scoped-define KEY-PHRASE TRUE NO-LOCK 
    /* inativo */                        
    &Scoped-define BY-ESTAB-IN
    /* ativo */                 
    &Scoped-define BY-ESTAB-AT
    
    {include/i-estab-openquery.i} 
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMonitor DBOProgram 
PROCEDURE openQueryMonitor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Seguran»a por estabelecimento */
    &scoped-define KEY-PHRASE naocfedade-carg.cod-estabel = c-estabelecimento ~
                              AND naocfedade-carg.cdn-naocfedade >= i-naocfedade-ini ~
                              AND naocfedade-carg.cdn-naocfedade <= i-naocfedade-fim ~
                              AND naocfedade-carg.num-carg >= i-carg-ini ~
                              AND naocfedade-carg.num-carg <= i-carg-fim ~
                              AND naocfedade-carg.dat-trans >= dt-data-ini ~
                              AND naocfedade-carg.dat-trans <= dt-data-fim ~
                              AND ((naocfedade-carg.cdn-sit = 1 AND l-pendente)~
                                OR (naocfedade-carg.cdn-sit = 2 AND l-em-analise)~
                                OR (naocfedade-carg.cdn-sit = 3 AND l-resolvida))~
                              AND ((naocfedade-carg.idi-tip-naocfedade = 1 AND l-dif-quantidade)~
                                OR (naocfedade-carg.idi-tip-naocfedade = 2 AND l-problema-qualidade)~
                                OR (naocfedade-carg.idi-tip-naocfedade = 3 AND l-nao-coleta))

    /* inativo */                        
    &Scoped-define BY-ESTAB-IN
    /* ativo */                 
    &Scoped-define BY-ESTAB-AT

    {include/i-estab-openquery.i}
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-row-errors DBOProgram 
PROCEDURE pi-cria-row-errors PRIVATE :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-msg AS INTEGER                   NO-UNDO.
    DEFINE INPUT PARAMETER p-texto   AS CHARACTER FORMAT "X(255)" NO-UNDO.

    DEFINE VARIABLE iErrorSequence    AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cErrorSubType     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cErrorDescription AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cErrorHelp        AS CHARACTER  NO-UNDO.

    userCodeBlock:
    DO ON ERROR UNDO, LEAVE userCodeBlock
       ON STOP  UNDO, LEAVE userCodeBlock
       ON QUIT  UNDO, LEAVE userCodeBlock:

        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT p-num-msg,
                           INPUT p-texto).                       
        ASSIGN cErrorDescription = RETURN-VALUE.
        
        /** Busca o Tipo de Mensagem do EMS **/
        RUN utp/ut-msgs.p (INPUT "TYPE":U,
                           INPUT p-num-msg,
                           INPUT p-texto).
        CASE {uninc/i01un001.i 06 RETURN-VALUE}:
        WHEN 1 THEN
            ASSIGN cErrorSubType = "ERROR":U.
        WHEN 2 THEN
            ASSIGN cErrorSubType = "WARNING":U.
        WHEN 3 THEN
            ASSIGN cErrorSubType = "QUESTION":U.
        WHEN 4 THEN
            ASSIGN cErrorSubType = "INFORMATION":U.
        END CASE.
        
        /** Busca Help da Mensagem **/
        RUN utp/ut-msgs.p (INPUT "HELP":U,
                       INPUT p-num-msg,  
                       INPUT p-texto).   
        ASSIGN cErrorHelp = RETURN-VALUE.
        
        /*--- Atualiza variëvel de sequ¦ncia de erros ---*/
        IF CAN-FIND(LAST rowErrors) THEN DO:
            FIND LAST rowErrors NO-ERROR.
            ASSIGN iErrorSequence = rowErrors.ErrorSequence + 1.
        END.
        ELSE
            ASSIGN iErrorSequence = iErrorSequence + 1.
        
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorSequence    = iErrorSequence
               rowErrors.ErrorNumber      = p-num-msg
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = cErrorSubType
               rowErrors.ErrorDescription = cErrorDescription
               rowErrors.ErrorHelp        = cErrorHelp
               rowErrors.ErrorParameters  = p-texto.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reabrir-nc DBOProgram 
PROCEDURE reabrir-nc :
/*------------------------------------------------------------------------------
  Purpose: reabrir nao conformidades da carga    
  Parameters:  p-cdn-naocfedade => Codigo identificador da NC
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cdn-naocfedade AS INTEGER NO-UNDO.   
    DEFINE OUTPUT PARAMETER TABLE FOR row-errors-nc.

    RUN inic-elimina-handle IN THIS-PROCEDURE(INPUT 1). /* INICIALIZA */    
    
    EMPTY TEMP-TABLE row-errors-nc NO-ERROR.
    EMPTY TEMP-TABLE RowErrors     NO-ERROR.
    
    blk-nc: 
    FOR FIRST bf{&TableName} EXCLUSIVE-LOCK
        WHERE bf{&TableName}.cdn-naocfedade = p-cdn-naocfedade: 

        RUN valida-situacao-carga IN THIS-PROCEDURE.
        IF RETURN-VALUE = "NOK" THEN DO:
            UNDO blk-nc, LEAVE blk-nc.
        END.        

         /* SE ENCONTRAR PENALIZACAO , REALIZA VALIDACOES - MOVTO-ESTOQ - EVENTO FINANC */
        IF CAN-FIND(FIRST dest-cust-naocfedade
                    WHERE dest-cust-naocfedade.cdn-naocfedade = bf{&TableName}.cdn-naocfedade) THEN DO:        

            IF VALID-HANDLE(h-movto-event-financ) THEN DO: /* ELIMINA EVENTO FINANCEIRO */
                FOR EACH dest-cust-naocfedade EXCLUSIVE-LOCK
                   WHERE dest-cust-naocfedade.cdn-naocfedade = bf{&TableName}.cdn-naocfedade:    

                    RUN pi_apagar_movto_event_financ IN h-movto-event-financ(INPUT dest-cust-naocfedade.cdn-id-movto-event, 
                                                                             INPUT YES, 
                                                                             OUTPUT TABLE tt_row_errors).
                    IF CAN-FIND(FIRST tt_row_errors) THEN DO:
                        FOR EACH tt_row_errors:
                            CREATE rowErrors.
                            ASSIGN rowErrors.ErrorSequence    = tt_row_errors.ttv_num_seq_erro
                                   rowErrors.ErrorNumber      = tt_row_errors.ttv_num_erro
                                   rowErrors.ErrorType        = tt_row_errors.ttv_des_type
                                   rowErrors.ErrorSubType     = tt_row_errors.ttv_des_sub_type
                                   rowErrors.ErrorDescription = tt_row_errors.ttv_des_erro
                                   rowErrors.ErrorHelp        = tt_row_errors.ttv_des_help
                                   rowErrors.ErrorParameters  = tt_row_errors.ttv_des_param.
                            UNDO blk-nc, LEAVE blk-nc.
                        END.
                    END.

                    /* inicializa id do movto evento */
                    ASSIGN dest-cust-naocfedade.cdn-id-movto-event = 0.
                END.
            END.
        END.

        ASSIGN bf{&TableName}.cdn-sit = 2. /* EM ANALISE*/
    END.
    
    RUN getRowErrors        IN THIS-PROCEDURE(OUTPUT TABLE row-errors-nc).
    RUN inic-elimina-handle IN THIS-PROCEDURE(INPUT 2). /* ELIMINA */

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resolver-nc DBOProgram 
PROCEDURE resolver-nc :
/*------------------------------------------------------------------------------
  Purpose: resolver nao conformidades da carga    
  Parameters:  p-cdn-naocfedade => Codigo identificador da NC
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cdn-naocfedade AS INTEGER NO-UNDO. 
    DEFINE OUTPUT PARAMETER TABLE FOR row-errors-nc.
    
    RUN inic-elimina-handle IN THIS-PROCEDURE(INPUT 1). /* INICIALIZA */    
    
    EMPTY TEMP-TABLE row-errors-nc NO-ERROR.
    EMPTY TEMP-TABLE RowErrors     NO-ERROR.
    
    blk-nc: 
    FOR FIRST bf{&TableName} EXCLUSIVE-LOCK
        WHERE bf{&TableName}.cdn-naocfedade = p-cdn-naocfedade: 

        RUN valida-resolucao-nc IN THIS-PROCEDURE(INPUT bf{&TableName}.cdn-naocfedade,
                                                  INPUT bf{&TableName}.idi-tip-naocfedade,
                                                  INPUT bf{&TableName}.cod-estabel).
        IF RETURN-VALUE = "NOK" THEN DO:
            UNDO blk-nc, LEAVE blk-nc.
        END.    
        
        FOR EACH bf-histor-naocfedade FIELDS(idi-tip-histor) NO-LOCK 
           WHERE bf-histor-naocfedade.cdn-naocfedade = bf{&TableName}.cdn-naocfedade:           
           
            /* TRATAMENTO NAO COLETA */
            IF bf{&TableName}.idi-tip-naocfedade = 3 THEN DO: /* Nao Coleta */
                FOR FIRST produt-carg NO-LOCK
                    WHERE produt-carg.num-carg    = bf{&TableName}.num-carg
                      AND produt-carg.cdn-identif = bf{&TableName}.cdn-identif:                      

                    /*atualizar nÆo conformidades para todos os produtores*/
                    FOR EACH bf-produt-carg EXCLUSIVE-LOCK
                       WHERE bf-produt-carg.num-carg           = produt-carg.num-carg          
                         AND bf-produt-carg.cod-pto-coleta     = produt-carg.cod-pto-coleta    
                         AND bf-produt-carg.cdn-produt-respons = produt-carg.cdn-produt-respons
                         AND bf-produt-carg.cdn-compart        = produt-carg.cdn-compart       
                         AND bf-produt-carg.cdn-repos          = produt-carg.cdn-repos:

                        CASE bf-histor-naocfedade.idi-tip-histor:
                            WHEN 2 THEN DO: /* Penaliza */ 
                                ASSIGN bf-produt-carg.idi-nao-coleta = 3. /* Reprovado */
                            END.
                            WHEN 3 THEN DO: /*  Nao Penaliza */
                                ASSIGN bf-produt-carg.idi-nao-coleta = 2. /* Aprovado */
                            END. 
                        END CASE.

                    END.
                    
                END.
                
                ASSIGN bf{&TableName}.cdn-sit = 3. /* Resolvida */
            END.
            ELSE DO: /* DIF QUANTIDADE e QUALIDADE */
            
                IF bf-histor-naocfedade.idi-tip-histor = 2 THEN DO: /* Penaliza */
                    RUN gera-evento-financ IN THIS-PROCEDURE.
                    IF RETURN-VALUE = "NOK":U THEN DO:                    
                        UNDO blk-nc, LEAVE blk-nc.
                    END.                   
                    /* Se não ocorrer erro atualiza a situacao */
                    ASSIGN bf{&TableName}.cdn-sit = 3. /* Resolvida */                    
                END.
                ELSE IF bf-histor-naocfedade.idi-tip-histor = 3 THEN /* NAO PENALIZA */
                    ASSIGN bf{&TableName}.cdn-sit = 3. /* Resolvida */  
            END.
            
        END.
    END.
    
    RUN getRowErrors IN THIS-PROCEDURE(OUTPUT TABLE row-errors-nc).
    
    RUN inic-elimina-handle IN THIS-PROCEDURE(INPUT 2). /* ELIMINA */
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNaocfedade DBOProgram 
PROCEDURE setConstraintNaocfedade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAM p-dif-quantidade     AS LOGICAL                          NO-UNDO.
    DEFINE INPUT PARAM p-problema-qualidade AS LOGICAL                          NO-UNDO.
    DEFINE INPUT PARAM p-nao-coleta         AS LOGICAL                          NO-UNDO.
    DEFINE INPUT PARAM p-peddente           AS LOGICAL                          NO-UNDO.
    DEFINE INPUT PARAM p-em-analise         AS LOGICAL                          NO-UNDO.
    DEFINE INPUT PARAM p-resolvida          AS LOGICAL                          NO-UNDO.
    DEFINE INPUT PARAM p-estabelecimento    LIKE naocfedade-carg.cod-estabel    NO-UNDO.
    DEFINE INPUT PARAM p-carga-ini          LIKE naocfedade-carg.num-carg       NO-UNDO.
    DEFINE INPUT PARAM p-carga-fim          LIKE naocfedade-carg.num-carg       NO-UNDO.
    DEFINE INPUT PARAM p-naocfedade-ini     LIKE naocfedade-carg.cdn-naocfedade NO-UNDO.
    DEFINE INPUT PARAM p-naocfedade-fim     LIKE naocfedade-carg.cdn-naocfedade NO-UNDO.
    DEFINE INPUT PARAM p-data-ini           LIKE naocfedade-carg.dat-trans      NO-UNDO.
    DEFINE INPUT PARAM p-data-fim           LIKE naocfedade-carg.dat-trans      NO-UNDO.

    ASSIGN l-dif-quantidade     = p-dif-quantidade
           l-problema-qualidade = p-problema-qualidade
           l-nao-coleta         = p-nao-coleta
           l-pendente           = p-peddente
           l-em-analise         = p-em-analise        
           l-resolvida          = p-resolvida         
           c-estabelecimento    = p-estabelecimento
           i-carg-ini           = p-carga-ini      
           i-carg-fim           = p-carga-fim      
           i-naocfedade-ini     = p-naocfedade-ini 
           i-naocfedade-fim     = p-naocfedade-fim 
           dt-data-ini          = p-data-ini       
           dt-data-fim          = p-data-fim.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-resolucao-nc DBOProgram 
PROCEDURE valida-resolucao-nc :
/*------------------------------------------------------------------------------
  Purpose:  Valida‡äes pertinentes à rotina de resolução de nao conformidades  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cdn-naocfedade     AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-idi-tip-naocfedade AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel        AS CHARACTER NO-UNDO.
    
    RUN emptyRowErrors IN THIS-PROCEDURE.

    IF p-idi-tip-naocfedade = 3 THEN DO: /* nao coleta */
        IF NOT CAN-FIND(FIRST histor-naocfedade 
                        WHERE histor-naocfedade.cdn-naocfedade = p-cdn-naocfedade
                          AND histor-naocfedade.idi-tip-histor > 1 ) THEN DO:
                          
            {method/svc/errors/inserr.i
                     &ErrorNumber= "54885" /*NC não pode ser resolvida!*/
                     &ErrorType="EMS"      /*Somente é permitido resolver NCs com algum movimento do tipo "Penaliza".*/
                     &ErrorSubType="ERROR"
                     &ErrorParameters="string(p-cdn-naocfedade)"}       
        END.
    END.
    ELSE DO:       
        IF CAN-FIND(FIRST carg-rural 
                    WHERE carg-rural.num-carg = bf{&TableName}.num-carg AND carg-rural.cdn-sit <> 5) THEN DO:       
            {method/svc/errors/inserr.i
                    &ErrorNumber= "54937"  /*NC não pode ser resolvida!*/
                    &ErrorType="EMS"     /*Somente é permitido resolver NCs com carga encerrada".*/
                    &ErrorSubType="ERROR"
                    &ErrorParameters="string(p-cdn-naocfedade)"}       
        END.       
        /* SE NAO EXISTIR MOVIMENTACAO DE NAO PENALIZA */
        IF NOT CAN-FIND(FIRST histor-naocfedade 
                        WHERE histor-naocfedade.cdn-naocfedade = p-cdn-naocfedade
                          AND histor-naocfedade.idi-tip-histor = 3) THEN DO:    
    
            FOR FIRST dest-cust-naocfedade FIELDS(cdn-naocfedade) NO-LOCK
                WHERE dest-cust-naocfedade.cdn-naocfedade = p-cdn-naocfedade,
                FIRST histor-naocfedade FIELDS() NO-LOCK
                WHERE histor-naocfedade.cdn-naocfedade = dest-cust-naocfedade.cdn-naocfedade
                  AND histor-naocfedade.idi-tip-histor = 2: /* Penaliza */ 
            END.
            
            IF NOT AVAIL dest-cust-naocfedade THEN DO:
                {method/svc/errors/inserr.i
                         &ErrorNumber= "54885" /*NC não pode ser resolvida!*/
                         &ErrorType="EMS"      /*Somente é permitido resolver NCs com algum movimento do tipo "Penaliza".*/
                         &ErrorSubType="ERROR"
                         &ErrorParameters="string(p-cdn-naocfedade)"}       
            END.            
        END.    
    END.
    
    
    IF CAN-FIND(FIRST histor-naocfedade 
                WHERE histor-naocfedade.cdn-naocfedade = p-cdn-naocfedade
                  AND histor-naocfedade.idi-tip-histor = 3) THEN DO: /* Nao Penaliza */ 
                  
        IF CAN-FIND(FIRST dest-cust-naocfedade 
                    WHERE dest-cust-naocfedade.cdn-naocfedade = p-cdn-naocfedade) THEN DO:
                {method/svc/errors/inserr.i
                     &ErrorNumber= "54854" /*NC não pode ser resolvida! */
                     &ErrorType="EMS"      /* Não deve existir registro de penalização para NC quando o tipo de movimento é igual a "Não Penaliza" */
                     &ErrorSubType="ERROR"
                     &ErrorParameters="RETURN-VALUE"}                                
        END.      
    END.
        
    

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

      RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-situacao-carga DBOProgram 
PROCEDURE valida-situacao-carga :
/*------------------------------------------------------------------------------
  Purpose:  Valida a situação da carga para reabertura da NC.  
  Parameters:  <none>
  Notes: Se a carga não estiver encerrada, retorna NOK.
------------------------------------------------------------------------------*/     
    IF CAN-FIND(FIRST carg-rural 
                WHERE carg-rural.num-carg = bf{&TableName}.num-carg
                  AND carg-rural.cdn-sit <> 5) THEN DO:
        {method/svc/errors/inserr.i
                         &ErrorNumber= "54893" /* Não é possível reabrir a NC! */
                         &ErrorType="EMS"      
                         &ErrorSubType="ERROR"
                         &ErrorParameters="STRING(bf{&TableName}.num-carg)"}        
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
        
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
    
    DEFINE VARIABLE c-msg AS CHARACTER NO-UNDO.

    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    
    IF pType = "Create" THEN DO:
        IF  RowObject.num-carg = 0 THEN DO:
           {utp/ut-field.i movind carg-rural num-carg}
           {method/svc/errors/inserr.i
                     &ErrorNumber="265"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="RETURN-VALUE"} 

        END.
        ELSE DO:
            IF NOT CAN-FIND(FIRST carg-rural
                            WHERE carg-rural.num-carg = RowObject.num-carg) THEN DO:
                {utp/ut-table.i movind carg-rural 1}
                {method/svc/errors/inserr.i 
                         &ErrorNumber="56"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters="return-value"} 
            END.
        END.

        IF RowObject.idi-tip-naocfedade <= 0 OR RowObject.idi-tip-naocfedade > 3 THEN DO:
           {utp/ut-field.i movind naocfedade-carg idi-tip-naocfedade}
           ASSIGN c-msg = RETURN-VALUE + "~~" + '4'.
           {method/svc/errors/inserr.i
                     &ErrorNumber="19543"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="c-msg"}
        END.


        IF RowObject.cod-pto-coleta <> "" THEN DO:
            IF NOT CAN-FIND(FIRST produt-carg
                            WHERE produt-carg.num-carg       = RowObject.num-carg
                              AND produt-carg.cod-pto-coleta = RowObject.cod-pto-coleta) THEN DO:

                {utp/ut-field.i movind produt-carg cod-pto-coleta}
                {method/svc/errors/inserr.i 
                         &ErrorNumber="56"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters="return-value"} 
            END.                                                       
        END.

        IF RowObject.cdn-identif > 0 THEN DO:
            IF NOT CAN-FIND(FIRST produt-carg
                            WHERE produt-carg.num-carg    = RowObject.num-carg
                              AND produt-carg.cdn-identif = RowObject.cdn-identif) THEN DO:

                {utp/ut-field.i movind produt-carg cdn-produt-rural}
                {method/svc/errors/inserr.i 
                         &ErrorNumber="56"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"
                         &ErrorParameters="return-value"} 
            END.                                                       
        END.


        IF RowObject.cdn-compart > 0 THEN DO:
            FOR FIRST bf-carg-rural FIELDS(qti-comptmento) NO-LOCK
                WHERE bf-carg-rural.num-carg = RowObject.num-carg:
                IF RowObject.cdn-compart > bf-carg-rural.qti-comptmento THEN DO:
                  
                    ASSIGN c-msg = STRING(bf-carg-rural.num-carg) + "~~" +  STRING(bf-carg-rural.qti-comptmento).
                    {method/svc/errors/inserr.i 
                             &ErrorNumber="54655" /*Compartimento invÿlido!*/
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR"
                             &ErrorParameters="c-msg"} 
                END.                                                            
            END.
        END.
    END.
    
    

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

