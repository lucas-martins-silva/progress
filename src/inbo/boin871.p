&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
/* Connected Databases 
          mgcte            PROGRESS
*/

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-docto-orig-cte-aux NO-UNDO LIKE docto-orig-cte
       FIELD r-rowid AS ROWID.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/******************************************************************************
** Copyright TOTVS S.A. (2013)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN871 2.00.00.083 } /*** "010083" 16/07/2026 15:18:07 ***/

/*:T-------------------------------------------------------------------------
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
&GLOBAL-DEFINE DBOName BOIN871
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName docto-orig-cte
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
{inbo/boin871.i RowObject}

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}

{cdp/cdcfgmat.i}
{include/i-epc200.i boin871}

/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEF BUFFER bf{&TableName} FOR {&TableName}.
DEF BUFFER bfmsg-ret-nfe  FOR msg-ret-nfe.
DEF BUFFER bf-docum-est   FOR docum-est.

DEF VAR c-chave-acesso LIKE docto-orig-cte.cod-aces-comp-nfe NO-UNDO.
DEF VAR i-idi-origem   LIKE docto-orig-cte.idi-orig-trad     NO-UNDO.

DEF VAR tg-todos             AS LOG                            NO-UNDO.
DEF VAR tg-digitada          AS LOG                            NO-UNDO.
DEF VAR tg-erro-neg          AS LOG                            NO-UNDO.
DEF VAR tg-atualizada        AS LOG                            NO-UNDO.
DEF VAR tg-eliminada         AS LOG                            NO-UNDO.
DEF VAR tg-cancelada         AS LOG                            NO-UNDO.
DEF VAR tg-atualizada-fisico AS LOG                            NO-UNDO.
DEF VAR tg-inutilizada       AS LOG                            NO-UNDO.
DEF VAR tg-validacao         AS LOG                            NO-UNDO.
DEF VAR l-validar-qtde       AS LOG INITIAL YES                NO-UNDO.
DEF VAR l-contrato           AS LOG                            NO-UNDO.
DEF VAR c-cod-emitente-ini   LIKE emitente.cod-emitente        NO-UNDO.
DEF VAR c-cod-emitente-fim   LIKE emitente.cod-emitente        NO-UNDO.
DEF VAR c-cod-estabel-ini    LIKE docum-est.cod-estabel        NO-UNDO.
DEF VAR c-cod-estabel-fim    LIKE docum-est.cod-estabel        NO-UNDO.
DEF VAR c-serie-ini          LIKE docum-est.serie-docto        NO-UNDO.
DEF VAR c-serie-fim          LIKE docum-est.serie-docto        NO-UNDO.
DEF VAR c-nro-docto-ini      LIKE docum-est.nro-docto          NO-UNDO.
DEF VAR c-nro-docto-fim      LIKE docum-est.nro-docto          NO-UNDO.
DEF VAR c-narrativa          like ordem-compra.narrativa       NO-UNDO.
DEF VAR dt-emissao-ini       LIKE docum-est.dt-emissao         NO-UNDO.
DEF VAR dt-emissao-fim       LIKE docum-est.dt-emissao         NO-UNDO.
DEF VAR i-idi-orig-trad      LIKE docto-orig-cte.idi-orig-trad NO-UNDO.
DEF VAR texto-msg            AS CHAR                           NO-UNDO.
DEF VAR l-altera-dt-trans    AS LOGICAL                        NO-UNDO.
DEF VAR c-nat-operacao       LIKE docto-orig-cte.nat-operacao  NO-UNDO.
DEF VAR h-boin862            AS HANDLE                         NO-UNDO.
DEF VAR h-boin356            AS HANDLE                         NO-UNDO.
DEF VAR l-salva-rat-despes   AS LOG INIT NO                    NO-UNDO.

DEFINE VARIABLE l-elimina-item          AS LOGICAL      NO-UNDO.

DEF VAR l-frete-embarcador AS LOG NO-UNDO.
ASSIGN l-frete-embarcador = CAN-FIND(FIRST funcao 
                                     WHERE funcao.cd-funcao = "SPP_TOTVSGFE":U
                                       AND funcao.ativo).

DEFINE VARIABLE h-boin872               AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-boin172desc           AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-boin873orig           AS HANDLE       NO-UNDO.
DEFINE VARIABLE h-boin873trad           AS HANDLE       NO-UNDO.

{inbo/boin090.i tt-docum-est}       
{inbo/boin176.i tt-item-doc-est}    
{inbo/boin092.i tt-dupli-apagar}    
{inbo/boin567.i tt-dupli-imp}       
{inbo/boin366.i tt-rat-docum}   
{dibo/bodi515.i tt-nota-fisc-adc} 
{inbo/boin01104.i tt-docum-est-transp}
{inbo/boin01016.i tt-ext-docum-est}   

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD identif-segment AS CHAR
    FIELD cd-erro         AS INT
    FIELD desc-erro       AS CHAR FORMAT "x(80)".

DEFINE TEMP-TABLE tt-erro-contrato NO-UNDO
    FIELD i-sequen AS INTEGER             
    FIELD cd-erro  AS INTEGER
    FIELD mensagem AS CHARACTER format "x(255)".

def temp-table tt_log_erro  no-undo 
    field ttv_num_cod_erro  as integer   initial ?
    field ttv_des_msg_ajuda as character initial ?
    field ttv_des_msg_erro  as character initial ?.

DEFINE TEMP-TABLE tt-rat-docto-orig-cte NO-UNDO LIKE rat-docto-orig-cte
       field r-rowid as rowid.

DEFINE TEMP-TABLE tt-rat-docto-orig-cte-aux NO-UNDO LIKE rat-docto-orig-cte
       field r-rowid as rowid.

DEFINE TEMP-TABLE tt-item-docto-orig-cte-param NO-UNDO LIKE item-docto-orig-cte
       field r-rowid as rowid.

DEFINE TEMP-TABLE tt-item-docto-orig-cte NO-UNDO LIKE item-docto-orig-cte
       field r-rowid as rowid.

DEFINE TEMP-TABLE tt-item-docto-orig-cte-trad NO-UNDO LIKE item-docto-orig-cte
       field r-rowid as rowid.

DEF TEMP-TABLE tt-docto-orig-cte-engine NO-UNDO LIKE docto-orig-cte.

DEFINE TEMP-TABLE tt-rat-docto-orig-cte-criar NO-UNDO LIKE rat-docto-orig-cte
       field r-rowid as rowid.

DEFINE TEMP-TABLE tt-rat-docto-orig-cte-param NO-UNDO LIKE rat-docto-orig-cte
       field r-rowid as rowid.

DEFINE TEMP-TABLE tt-rat-docto-orig-cte-del NO-UNDO LIKE rat-docto-orig-cte
       field r-rowid as rowid.

DEFINE TEMP-TABLE tt-rat-docto-orig-cte-persist NO-UNDO LIKE rat-docto-orig-cte
       field r-rowid as rowid.

DEFINE TEMP-TABLE tt-rat-despes-cte-param NO-UNDO LIKE rat-despes-cte
       field r-rowid as rowid.

DEFINE TEMP-TABLE tt-rat-despes-cte NO-UNDO LIKE rat-despes-cte
       field r-rowid as rowid.

DEFINE BUFFER bfrat-docto-orig-cte FOR rat-docto-orig-cte.

DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR FORMAT "x(12)" NO-UNDO.

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
   Temp-Tables and Buffers:
      TABLE: tt-docto-orig-cte-aux T "?" NO-UNDO mgcte docto-orig-cte
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 21.58
         WIDTH              = 43.86.
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

DEFINE TEMP-TABLE RowErrorsAdvert NO-UNDO
    LIKE RowErrors.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

FIND FIRST param-global NO-LOCK NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaSituacao DBOProgram 
PROCEDURE atualizaSituacao :
/*------------------------------------------------------------------------------
  Purpose:  
  Atualiza a situa‡Æo do Documento Origem Nota Entrada para a situa‡Æo passada como parƒmetro.

  Parameters:  i-cod-emitente: C¢digo do emitente
               c-cod-estabel : C¢digo do estabelecimento
               c-serie-docto : S‚rie do documento
               c-nro-docto   : N£mero do documento
               i-situacao    : Situa‡Æo para qual o documento serÿ atualizado
  
  Notes: S¢ atualiza o documento se a Origem do mesmo for Traduzido (2)      
------------------------------------------------------------------------------*/

    DEF INPUT PARAM i-cod-emitente LIKE docto-orig-cte.cod-emitente NO-UNDO.
    DEF INPUT PARAM c-cod-estabel  LIKE docto-orig-cte.cod-estabel  NO-UNDO.
    DEF INPUT PARAM c-serie-docto  LIKE docto-orig-cte.nro-docto    NO-UNDO.
    DEF INPUT PARAM c-nro-docto    LIKE docto-orig-cte.nro-docto    NO-UNDO.
    DEF INPUT PARAM i-situacao     AS INTEGER                       NO-UNDO.

    FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
         WHERE bf{&TableName}.cod-emitente  = i-cod-emitente
           AND bf{&TableName}.cod-estabel   = c-cod-estabel
           AND bf{&TableName}.serie-docto   = c-serie-docto
           AND bf{&TableName}.nro-docto     = c-nro-docto
           AND bf{&TableName}.idi-orig-trad = 2 NO-ERROR.

    IF AVAIL bf{&TableName} THEN
        ASSIGN bf{&TableName}.idi-situacao = i-situacao.

    RELEASE bf{&TableName}.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaSituacaoEliminacaoDocumEst DBOProgram 
PROCEDURE atualizaSituacaoEliminacaoDocumEst :
/*------------------------------------------------------------------------------
  Purpose:  
  Atualiza a situa»’o do Documento Origem Nota Entrada quando ocorre a elimina»’o 
  do documento fiscal
    
  Parameters:  
  c-chave-comp-nfe: Chave de acesso completa da NFe
  c-serie-docto:    S²rie do documento
  c-nro-docto:      Nœmero do documento
  i-cod-emitente:   C½digo do emitente
  c-cod-estabel:    C½digo do estabelecimento
  i-tipo-nota:      Tipo da nota
  c-nat-operacao:   Natureza de opera»’o da nota

  Notes: 
  
  Dependendo de como se encontra a nota, seta a situa»’o do documento para 
  1 (Digitada Receb. Fiscal), 
  4 (Eliminada Recebimento)
     
------------------------------------------------------------------------------*/
    DEF INPUT PARAM c-chave-comp-nfe LIKE docto-orig-cte.cod-aces-comp-nfe  NO-UNDO.
    DEF INPUT PARAM c-serie-docto    LIKE docto-orig-cte.serie-docto        NO-UNDO.
    DEF INPUT PARAM c-nro-docto      LIKE docto-orig-cte.nro-docto          NO-UNDO.
    DEF INPUT PARAM i-cod-emitente   LIKE docto-orig-cte.cod-emitente       NO-UNDO.
    DEF INPUT PARAM c-cod-estabel    LIKE docto-orig-cte.cod-estabel        NO-UNDO.
    DEF INPUT PARAM i-tipo-nota      LIKE docum-est.tipo-nota               NO-UNDO.
    DEF INPUT PARAM c-nat-operacao   LIKE docum-est.nat-operacao            NO-UNDO.

    DEF VAR i-parcela                AS INT                                 NO-UNDO.

    FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
         WHERE bf{&TableName}.cod-aces-comp-nfe = c-chave-comp-nfe
           AND bf{&TableName}.idi-orig-trad     = 2 NO-ERROR.

    IF NOT AVAIL bf{&TableName} THEN
        /* Em alguns casos a chave eletr“nica nÆo confere. */
        FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
             WHERE bf{&TableName}.serie-docto  = c-serie-docto
               AND bf{&TableName}.nro-docto    = c-nro-docto
               AND bf{&TableName}.cod-emitente = i-cod-emitente
               AND bf{&TableName}.nat-operacao = c-nat-operacao NO-ERROR.
    
    IF AVAIL bf{&TableName} THEN DO:
        ASSIGN bf{&TableName}.idi-situacao = 4. /* Eliminada Recebimento */

        /* Evento Cancelamento */
        FOR FIRST event-nfe-cte FIELDS(idi-sit-event) EXCLUSIVE-LOCK
            WHERE event-nfe-cte.ch-acesso-comp-nfe = bf{&TableName}.cod-aces-comp-nfe
              AND event-nfe-cte.idi-tip-docto     = 2 /*cte */
              AND event-nfe-cte.idi-sit-event     = 1 /* Pendente */ :

            RUN cancelaDocumento(INPUT ROWID(bf{&TableName}), ?).
            IF RETURN-VALUE = "OK":U THEN DO:              
                ASSIGN event-nfe-cte.idi-sit-event = 2. /* processado */

                {utp/ut-liter.i CT-e_foi_cancelado *}
                RUN utp/ut-msgs.p ("msg":U, 54213, RETURN-VALUE).
                RUN pi-create-msg-ret-nfe (event-nfe-cte.ch-acesso-comp-nfe, 54213, RETURN-VALUE, 4).
            END. 
        END.

        FOR EACH item-doc-est NO-LOCK
           WHERE item-doc-est.serie-docto  = c-serie-docto
             AND item-doc-est.nro-docto    = c-nro-docto
             AND item-doc-est.cod-emitente = i-cod-emitente
             AND item-doc-est.nat-operacao = c-nat-operacao:

            IF item-doc-est.numero-ordem = 0 THEN
                NEXT.

            FOR FIRST item-docto-orig-cte NO-LOCK
                WHERE item-docto-orig-cte.cod-aces-comp-nfe = bf{&TableName}.cod-aces-comp-nfe
                  AND item-docto-orig-cte.idi-orig-trad     = 2:

                /* ############################################################### **
                ** Realoca o saldo para manter a ordem e o pedido no conversor.    **
                ** Caso o usuario digite o documento manualmente, as demais UPCs   **
                ** se encarregarao de desalocar o saldo e zerar a ordem de compra. **
                ** ############################################################### */

                IF  item-docto-orig-cte.numero-ordem <> 0
                AND item-docto-orig-cte.numero-ordem = item-doc-est.numero-ordem THEN DO:
                    IF  NOT VALID-HANDLE(h-boin356) THEN
                        RUN inbo/boin356.p PERSISTEN SET h-boin356.

                    ASSIGN i-parcela = item-docto-orig-cte.num-parcela.
                    RUN aloca-ordem-cc IN h-boin356 (INPUT item-doc-est.numero-ordem,
                                                     INPUT-OUTPUT i-parcela,
                                                     INPUT item-doc-est.quantidade).
                END.
            END.
        END.
    END.

    RELEASE bf{&TableName}.

    RETURN "OK":U.

    FINALLY:
        DELETE PROCEDURE h-boin356 NO-ERROR.
        ASSIGN h-boin356 = ?.
    END FINALLY.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaSituacaoPelaChaveDeAcesso DBOProgram 
PROCEDURE atualizaSituacaoPelaChaveDeAcesso :
/*------------------------------------------------------------------------------
  Purpose:  
  Atualiza a situa‡Æo do Documento Origem Nota Entrada para a situa‡Æo passada como parƒmetro.
    
  Parameters:  
  c-chave-comp-nfe: Chave de acesso completa da NFe
  c-serie-docto:    S‚rie do Documento
  c-nro-docto:      N£mero do Documento
  i-cod-emitente:   C¢digo do Emitente
  c-nat-operacao:   Natureza de opera‡Æo
  i-situacao:       Situa‡Æo para a qual o documento deve ser atualizado.

  
  Notes: S¢ atualiza o documento se a Origem do mesmo for Traduzido (2)
------------------------------------------------------------------------------*/
    DEF INPUT PARAM c-chave-comp-nfe LIKE docto-orig-cte.cod-aces-comp-nfe  NO-UNDO.
    DEF INPUT PARAM c-serie-docto    LIKE docto-orig-cte.serie-docto        NO-UNDO.
    DEF INPUT PARAM c-nro-docto      LIKE docto-orig-cte.nro-docto          NO-UNDO.
    DEF INPUT PARAM i-cod-emitente   LIKE docto-orig-cte.cod-emitente       NO-UNDO.
    DEF INPUT PARAM c-nat-operacao   LIKE docum-est.nat-operacao          NO-UNDO.
    DEF INPUT PARAM i-situacao       AS INTEGER                           NO-UNDO.

    FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
         WHERE bf{&TableName}.cod-aces-comp-nfe = c-chave-comp-nfe
           AND bf{&TableName}.idi-orig-trad     = 2 NO-ERROR.
       
    IF AVAIL bf{&TableName} THEN
        ASSIGN bf{&TableName}.idi-situacao = i-situacao.
    ELSE DO:
        FOR FIRST bf{&TableName} EXCLUSIVE-LOCK
            WHERE bf{&TableName}.serie-docto   = c-serie-docto
              AND bf{&TableName}.nro-docto     = c-nro-docto
              AND bf{&TableName}.cod-emitente  = i-cod-emitente
              AND bf{&TableName}.nat-operacao  = c-nat-operacao
              AND bf{&TableName}.idi-orig-trad = 2:
            ASSIGN bf{&TableName}.idi-situacao = i-situacao.
        END.
    END.

    RELEASE bf{&TableName}.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaNaturezaOperacao DBOProgram
PROCEDURE buscaNaturezaOperacao:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pchave-acesso  LIKE docto-orig-cte.cod-aces-comp-nfe NO-UNDO.
    DEFINE OUTPUT PARAM c-nat-oper         LIKE item-docto-orig-cte.nat-operacao  NO-UNDO.
    
    FOR EACH docto-orig-cte FIELDS() NO-LOCK 
        WHERE docto-orig-cte.cod-aces-comp-nfe = pchave-acesso 
          AND docto-orig-cte.idi-orig-trad     = 2:   
        FOR EACH item-docto-orig-cte FIELDS(nat-operacao) 
              OF docto-orig-cte NO-LOCK:  
            IF item-docto-orig-cte.nat-operacao <> "" THEN
                ASSIGN c-nat-oper = item-docto-orig-cte.nat-operacao.
            LEAVE.  
        END.
    END.  
     
    RETURN "OK":U.

END PROCEDURE.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelaDocumento DBOProgram 
PROCEDURE cancelaDocumento :
/*------------------------------------------------------------------------------
  Purpose:     Cancela o documento
  Parameters:  pr-nota: Rowid da nota a ser cancelada
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pr-nota  AS ROWID    NO-UNDO.
    DEFINE INPUT  PARAMETER c-motivo AS CHAR     NO-UNDO.

    FOR FIRST bf{&TableName} FIELDS (cod-aces-comp-nfe nro-docto)
        WHERE ROWID(bf{&TableName}) = pr-nota NO-LOCK:
    END.

    IF AVAIL bf{&TableName} THEN DO:
        /** CRIA MENSAGEM NOTIFICANDO QUE A NF FOI CANCELADA **/
        FOR EACH msg-ret-nfe FIELDS (seq-msg) NO-LOCK
           WHERE msg-ret-nfe.ch-acesso-comp-nfe = bf{&TableName}.cod-aces-comp-nfe
             AND msg-ret-nfe.idi-orig-trad      = 2
             AND msg-ret-nfe.log-ativo:

            FOR FIRST bfmsg-ret-nfe EXCLUSIVE-LOCK
                WHERE bfmsg-ret-nfe.seq-msg    = msg-ret-nfe.seq-msg
                  AND bfmsg-ret-nfe.cd-msg    <> 52843: // nao jogar para historico a mensagem de consulta que retornou que está cancelada, isso ja eh o motivo do cancelamento:
                ASSIGN bfmsg-ret-nfe.log-ativo = NO.
            END.
            RELEASE bfmsg-ret-nfe.
        END.

        RUN utp/ut-msgs.p ("MSG":U, 19531, "" + "~~" + "" + "~~" + bf{&TableName}.nro-docto).
        RUN pi-create-msg-ret-nfe (bf{&TableName}.cod-aces-comp-nfe, 19531, RETURN-VALUE, 4).

        IF c-motivo <> ? AND TRIM(c-motivo) <> "" THEN DO:
            RUN utp/ut-msgs.p ("MSG":U, 57446, c-motivo).
            RUN pi-create-msg-ret-nfe (bf{&TableName}.cod-aces-comp-nfe, 57446, RETURN-VALUE, 4).
        END.
    END.

    FOR FIRST bf{&TableName}
        WHERE ROWID(bf{&TableName}) = pr-nota EXCLUSIVE-LOCK:
    END.

    IF AVAIL bf{&TableName} THEN
        ASSIGN bf{&TableName}.idi-situacao = 5 /** CANCELADA **/.

    RELEASE bf{&TableName}.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTT-docum-est DBOProgram 
PROCEDURE createTT-docum-est :
/*------------------------------------------------------------------------------
  Purpose:     Cria a Temp-table docum-est
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN verificaParamNfe.

    IF  l-altera-dt-trans THEN DO:  /*verifica parâmetro RE0119*/
        ASSIGN bf{&TableName}.dt-trans = TODAY.
    END.
    
    CREATE tt-docum-est.
    ASSIGN tt-docum-est.nro-docto              = bf{&TableName}.nro-docto
           tt-docum-est.nat-operacao           = bf{&TableName}.nat-operacao
           tt-docum-est.serie-docto            = bf{&TableName}.serie-docto
           tt-docum-est.cod-emitente           = bf{&TableName}.cod-emitente
           tt-docum-est.cod-estabel            = bf{&TableName}.cod-estabel
           tt-docum-est.cod-observa            = 1
           tt-docum-est.dt-trans               = bf{&TableName}.dt-trans 
           tt-docum-est.valor-mercad           = bf{&TableName}.val-tot-mercad
           tt-docum-est.tipo-nota              = 1 /* nota de rateio */
           tt-docum-est.via-transp             = bf{&TableName}.cdn-modalid-frete
           tt-docum-est.usuario                = c-seg-usuario
           tt-docum-est.dt-emissao             = bf{&TableName}.dt-emissao
           tt-docum-est.origem                 = "XML"
           tt-docum-est.cod-chave-aces-cte-sub = bf{&TableName}.cod-chave-aces-cte-sub
           OVERLAY(tt-docum-est.char-2,153,13) = string(bf{&TableName}.val-livre-1).

    &IF '{&bf_mat_versao_ems}' > '2.08' &THEN
        ASSIGN tt-docum-est.cod-item-serv   = bf{&TableName}.cod-item-serv.
    &ELSE
        ASSIGN OVERLAY(tt-docum-est.char-1,176,16)   = bf{&TableName}.cod-item-serv.
    &ENDIF
    
    &IF "{&bf_mat_versao_ems}" < "2.07" &THEN
        ASSIGN OVERLAY(tt-docum-est.char-1,93,60) = bf{&TableName}.cod-aces-comp-nfe
               OVERLAY(tt-docum-est.char-1,153,1) = "1".
    &ELSE
        ASSIGN tt-docum-est.cod-chave-aces-nf-eletro = bf{&TableName}.cod-aces-comp-nfe
               tt-docum-est.cdn-sit-nfe              = 1.
    &ENDIF
     
    /*1 - CT-e Normal, 2 - CT-e de Complemento de Valores, 3 - CT-e de Anula‡Æo de Valores, 4 - CT-e Substituto, 5- CT-e Simplificado, 6-Substitui‡Æo CT-e Simplificado*/  
    ASSIGN OVERLAY(tt-docum-est.char-2,151,2)  = STRING( INT(bf{&TableName}.tp-nf) + 1).   
   
    FOR FIRST cidade NO-LOCK
        WHERE cidade.cidade = bf{&TableName}.cod-munpio-emit
          AND cidade.estado = bf{&TableName}.cod-uf-emit:
        ASSIGN tt-docum-est.pais = cidade.pais.
    END.
    
    ASSIGN tt-docum-est.cod-placa[1] = bf{&TableName}.cod-placa
           tt-docum-est.bairro       = bf{&TableName}.cod-bairro-emit
           tt-docum-est.cidade       = bf{&TableName}.cod-munpio-emit
           tt-docum-est.endereco     = bf{&TableName}.cod-lograd-emit + ", " + bf{&TableName}.num-end-emit
           tt-docum-est.mod-frete    = bf{&TableName}.cdn-modalid-frete.
    
    FOR FIRST emitente FIELDS (cgc)
        WHERE emitente.cod-emitente = bf{&TableName}.cod-emitente NO-LOCK:

        FOR FIRST transporte FIELDS (nome-abrev)
            WHERE transporte.cgc = emitente.cgc NO-LOCK:

            ASSIGN tt-docum-est.nome-transp = transporte.nome-abrev.

        END.
    END.

    ASSIGN OVERLAY(tt-docum-est.char-2,236,10)= SUBSTRING(bf{&TableName}.cod-livre-1,31,10) /*C¢d IBGE Munic Dest*/
           OVERLAY(tt-docum-est.char-2,246,10)= SUBSTRING(bf{&TableName}.cod-livre-1,21,10) /*C¢d IBGE Munic Orig*/
           OVERLAY(tt-docum-est.char-2,211,2) = SUBSTRING(bf{&TableName}.cod-livre-1,41,2). /*UF Orig/Dest GIA SP*/
           
    IF CAN-FIND(FIRST funcao NO-LOCK
                WHERE funcao.cd-funcao = "spp-NT2024002" AND funcao.ativo) THEN DO:
       RUN createTTExtDocumEst.     
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTTExtDocumEst DBOProgram 
PROCEDURE createTTExtDocumEst :
    EMPTY TEMP-TABLE tt-ext-docum-est.
    CASE SUBSTRING(tt-docum-est.cod-chave-aces-nf-eletro,21,2):
        WHEN '57' THEN DO:
            IF INT(SUBSTRING(tt-docum-est.char-2,236,10)) <> 0 THEN DO:  /*C¢d IBGE Munic Dest - local da entrega da carga ou disponibilizada ao destinat rio*/
               RUN createOrUpdateTTExtDocumEst(INPUT INT(SUBSTRING(tt-docum-est.char-2,236,10)), 
                                               INPUT ?, 
                                               INPUT ?, 
                                               INPUT ?). 
            END.
        END.
        WHEN '67' THEN DO:
            IF  INT(SUBSTRING(bf{&TableName}.cod-livre-1,43,2)) = 6 /*transporte de passageiro*/
            AND INT(SUBSTRING(tt-docum-est.char-2,246,10)) <> 0 THEN DO:   /*C¢d IBGE Munic Orig - local onde inicia o transporte*/
               RUN createOrUpdateTTExtDocumEst(INPUT INT(SUBSTRING(tt-docum-est.char-2,246,10)), 
                                               INPUT ?, 
                                               INPUT ?, 
                                               INPUT ?). 
            END. 
            ELSE DO:
                IF INT(SUBSTRING(bf{&TableName}.cod-livre-1,43,2)) = 7
                OR INT(SUBSTRING(bf{&TableName}.cod-livre-1,43,2)) = 8 THEN    /*excesso bagagem ou trasnporte de valores*/
                   IF INT(SUBSTRING(tt-docum-est.char-2,236,10)) <> 0 THEN DO:    /*C¢d IBGE Munic Dest - local da entrega da carga ou disponibilizada ao destinat rio*/
                    
                      RUN createOrUpdateTTExtDocumEst(INPUT INT(SUBSTRING(tt-docum-est.char-2,236,10)), 
                                                      INPUT ?, 
                                                      INPUT ?, 
                                                      INPUT ?). 
                   END.
                   ELSE DO:  /*local onde ‚ disponibilizada o excesso de carga ou transporte de valor*/
                       FIND FIRST estabelec NO-LOCK
                            WHERE estabelec.cod-estabel = tt-docum-est.cod-estabel NO-ERROR.
                           
                       IF AVAIL estabelec THEN DO:
                           RUN createOrUpdateTTExtDocumEst(INPUT 0, /* Informa que nÆo tem IBGE */
                                                           INPUT estabelec.cidade, 
                                                           INPUT estabelec.estado, 
                                                           INPUT estabelec.pais).
                       END.
                   END.
            END.
            
        END.
    END CASE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createOrUpdateTTExtDocumEst DBOProgram 
PROCEDURE  createOrUpdateTTExtDocumEst:
    DEFINE INPUT PARAMETER piCodIBGE AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER pcCidade  AS CHARACTER NO-UNDO. 
    DEFINE INPUT PARAMETER pcEstado  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcPais    AS CHARACTER NO-UNDO.
                 
    FIND FIRST tt-ext-docum-est EXCLUSIVE-LOCK
         WHERE tt-ext-docum-est.serie-docto  = tt-docum-est.serie-docto
           AND tt-ext-docum-est.nro-docto    = tt-docum-est.nro-docto
           AND tt-ext-docum-est.cod-emitente = tt-docum-est.cod-emitente
           AND tt-ext-docum-est.nat-operacao = tt-docum-est.nat-operacao
           AND tt-ext-docum-est.cod-param    = "fatogeradorCBS-IBS":U NO-ERROR.

    IF NOT AVAIL tt-ext-docum-est THEN DO:
        CREATE tt-ext-docum-est.
        ASSIGN tt-ext-docum-est.serie-docto  = tt-docum-est.serie-docto
               tt-ext-docum-est.nro-docto    = tt-docum-est.nro-docto
               tt-ext-docum-est.cod-emitente = tt-docum-est.cod-emitente
               tt-ext-docum-est.nat-operacao = tt-docum-est.nat-operacao
               tt-ext-docum-est.cod-param    = "fatogeradorCBS-IBS":U.
    END.
    

    IF piCodIBGE > 0 THEN DO:
        FOR FIRST cidade NO-LOCK
            WHERE cidade.cdn-munpio-ibge = piCodIBGE:
            ASSIGN OVERLAY(tt-ext-docum-est.cod-livre-1,1,50) = cidade.cidade
                   OVERLAY(tt-ext-docum-est.cod-livre-2,1,4)  = cidade.estado
                   OVERLAY(tt-ext-docum-est.cod-livre-3,1,20) = cidade.pais.
        END. 
    END.
    ELSE DO:
        ASSIGN OVERLAY(tt-ext-docum-est.cod-livre-1,1,50) = pcCidade
               OVERLAY(tt-ext-docum-est.cod-livre-2,1,4)  = pcEstado
               OVERLAY(tt-ext-docum-est.cod-livre-3,1,20) = pcPais.
    END.

    RETURN "OK":U.
END PROCEDURE.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EliminaCTe DBOProgram 
PROCEDURE EliminaCTe :
/*------------------------------------------------------------------------------
  Purpose:     Eliminar os registros da CT-e.
  Parameters:  c-chave-cte -> Chave £nica de acesso a CT-e no SEFAZ.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER c-chave-cte AS CHAR NO-UNDO.

    /*--- In¡cio - Elimina tabelas CT-e ---*/
    FOR EACH item-docto-orig-cte WHERE item-docto-orig-cte.cod-aces-comp-nfe = c-chave-cte EXCLUSIVE-LOCK:
        DELETE item-docto-orig-cte.
    END.

    FOR EACH rat-docto-orig-cte WHERE rat-docto-orig-cte.cod-aces-comp-nfe = c-chave-cte EXCLUSIVE-LOCK:
        DELETE rat-docto-orig-cte.
    END.

    FOR EACH msg-ret-nfe WHERE msg-ret-nfe.ch-acesso-comp-nfe = c-chave-cte EXCLUSIVE-LOCK:
        DELETE msg-ret-nfe.
    END.

    /* Eliminar tabela de eventos */
    FOR EACH event-nfe-cte 
       WHERE event-nfe-cte.ch-acesso-comp-nfe = c-chave-cte 
         AND event-nfe-cte.idi-tip-docto = 2 /* Evento CT-e */ EXCLUSIVE-LOCK:
        DELETE event-nfe-cte.
    END.

    FOR EACH log-config-regra WHERE log-config-regra.cod-chave = c-chave-cte EXCLUSIVE-LOCK:
        DELETE log-config-regra.
    END.

    FOR EACH rat-despes-cte WHERE rat-despes-cte.cod-aces-comp-nfe = c-chave-cte EXCLUSIVE-LOCK:
        DELETE rat-despes-cte.
    END.

    /* Verifica se existe o registro com a chave passada por parƒmetro. */
    IF  NOT CAN-FIND(FIRST docto-orig-cte WHERE docto-orig-cte.cod-aces-comp-nfe = c-chave-cte) THEN
        RETURN "NOK":U.

    FOR EACH docto-orig-cte WHERE docto-orig-cte.cod-aces-comp-nfe = c-chave-cte EXCLUSIVE-LOCK:
        DELETE docto-orig-cte.
    END.

    /*--- Fim - elimina tabelas CT-e ---*/

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerarNotaEntrada DBOProgram 
PROCEDURE gerarNotaEntrada :
/*------------------------------------------------------------------------------
  Purpose:     Essa BO ‚ utilizada para efetivar os registros do conversor em notas de entrada
                   que podem ser visualizadas pelo RE1001. 
  Parameters:  pr-nota -> ROWID nota a ser processada
               l-ok    -> Indica se o processamento da nota ocorreu com sucesso
  Notes:       
------------------------------------------------------------------------------*/

    {inbo/boin871.m1}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE engineRegras DBOProgram 
PROCEDURE engineRegras:
    DEFINE INPUT  PARAMETER pCodChaveAcessoCte   AS CHAR   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
       
    DEFINE VARIABLE c-situacao-txt AS CHARACTER   NO-UNDO.

    FIND FIRST bf{&TableName} 
         WHERE bf{&TableName}.cod-aces-comp-nfe = pCodChaveAcessoCte
         AND bf{&TableName}.idi-orig-trad       = 2 NO-LOCK NO-ERROR.

    IF NOT AVAIL bf{&TableName} THEN
        RETURN "NOK":U.

    IF bf{&TableName}.idi-situacao  = 2           /* 2 - Erro de Neg«cio. */
    OR bf{&TableName}.idi-situacao  = 4           /* 4 - Eliminada.       */
    OR bf{&TableName}.idi-situacao  = 5 THEN DO:  /* 5 - Cancelada.       */
        
        
        EMPTY TEMP-TABLE tt-docto-orig-cte-engine.
        CREATE tt-docto-orig-cte-engine.
        BUFFER-COPY bf{&TableName} TO tt-docto-orig-cte-engine.
         
        RUN rep/reapi326.p (INPUT TABLE tt-docto-orig-cte-engine,
                            INPUT "todos":U).

        IF RETURN-VALUE = "OK":U THEN DO:
           {utp/ut-liter.i "Regras_aplicadas"}
           {method/svc/errors/inserr.i &ErrorNumber="32388" /*&1 com sucesso*/
                                       &ErrorType="EMS"
                                       &ErrorSubType="INFORMATION"
                                       &ErrorParameters="RETURN-VALUE"}
        END.
    END.
    ELSE DO:

        assign c-situacao-txt = {ininc/i01in847.i 04 bf{&TableName}.idi-situacao}.
        {method/svc/errors/inserr.i &ErrorNumber="57052"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters="c-situacao-txt"}
        RETURN "NOK":U.

    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaCteApi DBOProgram 
PROCEDURE eliminaCteApi :
/*------------------------------------------------------------------------------
  Purpose: Elimina o documento Cte 
  Parameters:  pr-nota: Rowid da nota a ser cancelada
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pCodChaveAcessoCte   AS CHAR             NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE c-sit-txt   AS CHARACTER   NO-UNDO.

    RUN verificaEmProcessamento (INPUT pCodChaveAcessoCte). /* Verifica se ja esta em processamento */

    IF RETURN-VALUE = "NOK":U THEN /* documento ja esta em processamento ou nao esta avail */
        RETURN RETURN-VALUE.

    IF bf{&TableName}.idi-situacao <> 9 AND
       bf{&TableName}.idi-situacao <> 5 AND
       bf{&TableName}.idi-situacao <> 8 THEN DO:

       ASSIGN c-sit-txt = {ininc/i01in847.i 04 bf{&TableName}.idi-situacao}.
       {method/svc/errors/inserr.i &ErrorNumber="57054"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR" 
                                   &ErrorParameters="c-sit-txt"}
        RETURN "NOK":U.
    END.

    RUN EliminaCTe (INPUT bf{&TableName}.cod-aces-comp-nfe).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN RETURN-VALUE.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaEmProcessamento DBOProgram 
PROCEDURE verificaEmProcessamento :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se o documento esta em processamento e gera os erros caso
               nao esteja o registro disponivel ou ja em processamento
  Parameters:  chave de acesso da nota
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pCodChaveAcessoCte   AS CHAR   NO-UNDO.

    FIND FIRST bf{&TableName} 
         WHERE bf{&TableName}.cod-aces-comp-nfe = pCodChaveAcessoCte
         AND bf{&TableName}.idi-orig-trad       = 2 NO-LOCK NO-ERROR.

    IF NOT AVAIL  bf{&TableName} THEN DO:

        {utp/ut-liter.i Documento_XML_CT-e *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="RETURN-VALUE + '~~~~' + pCodChaveAcessoCte"}
        RETURN "NOK":U.
    END.

    IF bf{&TableName}.log-procmto THEN DO:
        IF INTERVAL (NOW, DATETIME(STRING(bf{&TableName}.dat-process) + " " + bf{&TableName}.hra-proces), "minutes":U) > 15 THEN // Ja faz mais de 15 minutos que esta em processamento
           RETURN "OK":U. // libera para que seja reprocessado 


        {method/svc/errors/inserr.i &ErrorNumber="57036"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="pCodChaveAcessoCte + '~~~~' + bf{&TableName}.cod-usuar-proces + '~~~~' + string(bf{&TableName}.dat-process) + ' ' + bf{&TableName}.hra-proces"}
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaChaveSefazApi DBOProgram 
PROCEDURE validaChaveSefazApi:
/*------------------------------------------------------------------------------
  Purpose:     Executa a validacao da chave SEFAZ e cancela o docto se necessario
  Parameters:  chave de acesso da nota
  Notes:       doc-orig-cte deverao estar posicionados
  Return:      OK - continuar a geracao, NOK - nao continuar
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pCodChaveAcessoCte   AS CHAR   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE i-cod-msg         as INT   NO-UNDO.
    DEFINE VARIABLE c-texto-msg       as CHAR  NO-UNDO.
    DEFINE VARIABLE cTpTrans          AS CHARACTER  NO-UNDO.

    FIND FIRST bf{&TableName} 
         WHERE bf{&TableName}.cod-aces-comp-nfe = pCodChaveAcessoCte
         AND bf{&TableName}.idi-orig-trad       = 2 NO-LOCK NO-ERROR.

    IF NOT AVAIL bf{&TableName} THEN DO:
        {utp/ut-liter.i Documento_XML_CT-e *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="RETURN-VALUE + '~~~~' + pCodChaveAcessoCte"}
        RETURN "NOK":U.                            
    END.
        
    RUN validaChaveSEFAZ (INPUT pCodChaveAcessoCte,
                          OUTPUT i-cod-msg,
                          OUTPUT c-texto-msg).
   
          
    IF i-cod-msg <> 0 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="i-cod-msg"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-texto-msg"}
    END.
    ELSE DO :
   
         /* Nova tela que configura o tipo de integra‡Æo da chave de acesso por estabelecimento (CD0360) */
    	RUN cdp/cd0360b.p (INPUT bf{&TableName}.cod-estabel,
    					   INPUT "ConsChave":U, /* Consulta Chave */
    					   OUTPUT cTpTrans).
        IF cTpTrans = "Nenhum":U THEN DO:
           {method/svc/errors/inserr.i &ErrorNumber="57100"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"}
        END.
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
        WHEN "cnpj-emit":U THEN ASSIGN pFieldValue = RowObject.cnpj-emit.
        WHEN "cod-aces-comp-nfe":U THEN ASSIGN pFieldValue = RowObject.cod-aces-comp-nfe.
        WHEN "cod-bairro-emit":U THEN ASSIGN pFieldValue = RowObject.cod-bairro-emit.
        WHEN "cod-cep-emit":U THEN ASSIGN pFieldValue = RowObject.cod-cep-emit.
        WHEN "cod-cfop":U THEN ASSIGN pFieldValue = RowObject.cod-cfop.
        WHEN "cod-cnpj-dest":U THEN ASSIGN pFieldValue = RowObject.cod-cnpj-dest.
        WHEN "cod-compl-emit":U THEN ASSIGN pFieldValue = RowObject.cod-compl-emit.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-lograd-emit":U THEN ASSIGN pFieldValue = RowObject.cod-lograd-emit.
        WHEN "cod-munpio-emit":U THEN ASSIGN pFieldValue = RowObject.cod-munpio-emit.
        WHEN "cod-placa":U THEN ASSIGN pFieldValue = RowObject.cod-placa.
        WHEN "cod-uf":U THEN ASSIGN pFieldValue = RowObject.cod-uf.
        WHEN "cod-uf-emit":U THEN ASSIGN pFieldValue = RowObject.cod-uf-emit.
        WHEN "cod-uf-dest":U THEN ASSIGN pFieldValue = RowObject.cod-uf-dest.
        WHEN "cod-uf-entreg":U THEN ASSIGN pFieldValue = RowObject.cod-uf-entreg.
        WHEN "cod-uf-envio":U THEN ASSIGN pFieldValue = RowObject.cod-uf-envio.
        WHEN "des-checksum":U THEN ASSIGN pFieldValue = RowObject.des-checksum.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "num-end-emit":U THEN ASSIGN pFieldValue = RowObject.num-end-emit.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "tp-nf":U THEN ASSIGN pFieldValue = RowObject.tp-nf.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1. 
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
        WHEN "dt-emissao":U THEN ASSIGN pFieldValue = RowObject.dt-emissao.
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
        WHEN "val-tot-mercad":U THEN ASSIGN pFieldValue = RowObject.val-tot-mercad.
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
        WHEN "cdn-modalid-frete":U THEN ASSIGN pFieldValue = RowObject.cdn-modalid-frete.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "idi-orig-trad":U THEN ASSIGN pFieldValue = RowObject.idi-orig-trad.
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
  Purpose:     Retorna valores dos campos do ¡ndice chave-id
  Parameters:  
               retorna valor do campo cod-aces-comp-nfe
               retorna valor do campo idi-orig-trad
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-aces-comp-nfe LIKE docto-orig-cte.cod-aces-comp-nfe NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-orig-trad LIKE docto-orig-cte.idi-orig-trad NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-aces-comp-nfe = RowObject.cod-aces-comp-nfe
           pidi-orig-trad = RowObject.idi-orig-trad.

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
        WHEN "log-doacao":U  THEN ASSIGN pFieldValue = RowObject.log-doacao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNaturOperRateio DBOProgram 
PROCEDURE getNaturOperRateio :
/*------------------------------------------------------------------------------
  Purpose:     Verificar se a natureza ‚ de rateio
  Parameters:  c-natureza - c¢digo da natureza
               l-log-rateio - caso a natureza seja de rateio, retorno yes.
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM c-natureza   LIKE docto-orig-cte.nat-operaca NO-UNDO.
    DEF OUTPUT PARAM l-log-rateio AS LOG                          NO-UNDO.

    FIND FIRST natur-oper NO-LOCK
         WHERE natur-oper.nat-operacao = c-natureza NO-ERROR.

    IF AVAIL natur-oper AND natur-oper.nota-rateio THEN
        ASSIGN l-log-rateio = YES.
    ELSE
        ASSIGN l-log-rateio = NO.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getParamCte DBOProgram 
PROCEDURE getParamCte :
/*------------------------------------------------------------------------------
  Purpose:     Verificar se existe algum registro com a situa‡Æo igual a 2 ou 9
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR FIRST bf{&TableName} FIELDS() 
        WHERE (   bf{&TableName}.idi-situacao = 2 /* 2 - Nota com erro de neg¢cio */
               OR bf{&TableName}.idi-situacao = 9 /* 9 - Em valida‡Æo */)
          AND bf{&TableName}.idi-orig-trad = 2 /* Traduzido */ NO-LOCK: END.

    IF AVAIL bf{&TableName} THEN
        RETURN "NOK":U.
    ELSE
        RETURN "OK":U.

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
  Purpose:     Reposiciona registro com base no ¡ndice chave-id
  Parameters:  
               recebe valor do campo cod-aces-comp-nfe
               recebe valor do campo idi-orig-trad
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-aces-comp-nfe LIKE docto-orig-cte.cod-aces-comp-nfe NO-UNDO.
    DEFINE INPUT PARAMETER pidi-orig-trad LIKE docto-orig-cte.idi-orig-trad NO-UNDO.

    FIND FIRST bfdocto-orig-cte WHERE 
        bfdocto-orig-cte.cod-aces-comp-nfe = pcod-aces-comp-nfe AND 
        bfdocto-orig-cte.idi-orig-trad = pidi-orig-trad NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdocto-orig-cte THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdocto-orig-cte)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDocumento DBOProgram 
PROCEDURE openQueryDocumento :
/*------------------------------------------------------------------------------
  Purpose: Abertura da query com base na chave do documento e origem    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName}
      FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.cod-aces-comp-nfe = c-chave-acesso
           AND {&TableName}.idi-orig-trad     = i-idi-origem INDEXED-REPOSITION.

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMonitorCTe DBOProgram 
PROCEDURE openQueryMonitorCTe :
/*------------------------------------------------------------------------------
  Purpose: Abertura da query utilizada pelo monitor do conversor de notas fiscais 
           de entrada     
  Parameters: tt-docto-orig-cte-aux: Temp-table contendo os registros da abertura da query
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAM TABLE FOR tt-docto-orig-cte-aux.

    DEFINE VARIABLE c-lista-param AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-cont        AS INTEGER     NO-UNDO.

    EMPTY TEMP-TABLE tt-docto-orig-cte-aux.

    IF tg-digitada          THEN ASSIGN c-lista-param = "1" + ";".
    IF tg-erro-neg          THEN ASSIGN c-lista-param = c-lista-param + "2" + ";".
    IF tg-atualizada        THEN ASSIGN c-lista-param = c-lista-param + "3" + ";".
    IF tg-eliminada         THEN ASSIGN c-lista-param = c-lista-param + "4" + ";".
    IF tg-cancelada         THEN ASSIGN c-lista-param = c-lista-param + "5" + ";".
    IF tg-inutilizada       THEN ASSIGN c-lista-param = c-lista-param + "8" + ";".
    IF tg-validacao         THEN ASSIGN c-lista-param = c-lista-param + "9" + ";".
    
    IF NUM-ENTRIES(c-lista-param, ";") - 1 > 0 THEN DO:

        DO i-cont = 1 TO NUM-ENTRIES(c-lista-param, ";") - 1:

            FOR EACH {&TableName} NO-LOCK
               WHERE {&TableName}.idi-situacao   = INT(ENTRY(i-cont, c-lista-param, ";"))
                 AND {&TableName}.idi-orig-trad  = 2 /* traduzido */
                 AND {&TableName}.cod-emitente  >= c-cod-emitente-ini
                 AND {&TableName}.cod-emitente  <= c-cod-emitente-fim
                 AND {&TableName}.cod-estabel   >= c-cod-estabel-ini 
                 AND {&TableName}.cod-estabel   <= c-cod-estabel-fim 
                 AND {&TableName}.serie-docto   >= c-serie-ini       
                 AND {&TableName}.serie-docto   <= c-serie-fim       
                 AND {&TableName}.nro-docto     >= c-nro-docto-ini   
                 AND {&TableName}.nro-docto     <= c-nro-docto-fim   
                 AND {&TableName}.dt-emissao    >= dt-emissao-ini    
                 AND {&TableName}.dt-emissao    <= dt-emissao-fim:
                
                CREATE tt-docto-orig-cte-aux.
                BUFFER-COPY {&TableName} TO tt-docto-orig-cte-aux.
                ASSIGN tt-docto-orig-cte-aux.r-rowid = ROWID({&TableName}).
            END.
        END.
    END.

    IF  c-nom-prog-upc-mg97 <> ""   /* Se existe UPC cadastrada */
    AND c-nom-prog-upc-mg97 <> ? THEN DO:
        FOR EACH tt-epc
           WHERE tt-epc.cod-event = "OpenQueryMonitorCTE":
           DELETE tt-epc.
        END.
        
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "OpenQueryMonitorCTE":U
               tt-epc.cod-parameter = "tt-docto-orig-cte-aux":U
               tt-epc.val-parameter = string(TEMP-TABLE tt-docto-orig-cte-aux:HANDLE).
        
        {include/i-epc201.i "OpenQueryMonitorCTE"}
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryTraduzido DBOProgram 
PROCEDURE openQueryTraduzido :
/*------------------------------------------------------------------------------
  Purpose: Abertura da query para mostrar apenas documentos traduzidos    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} 
      FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.idi-orig-trad = 2 INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDocumento DBOProgram 
PROCEDURE retornaDocumento :
/*------------------------------------------------------------------------------
  Purpose: Retorna o Rowid da docum-est com base na chave     
  Parameters: pserie-docto : S‚rie do documento
              pnro-docto   : N£mero do documento
              pcod-emitente: C¢digo do emitente
              pr-docto     : Rowid do documento
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM pserie-docto  LIKE docum-est.serie-docto  NO-UNDO.
    DEF INPUT  PARAM pnro-docto    LIKE docum-est.nro-docto    NO-UNDO.
    DEF INPUT  PARAM pcod-emitente LIKE docum-est.cod-emitente NO-UNDO.
    DEF INPUT  PARAM pnat-operacao LIKE docum-est.nat-operacao NO-UNDO.
    DEF OUTPUT PARAM pr-docto      AS ROWID                    NO-UNDO.

    FOR FIRST docum-est NO-LOCK
        WHERE docum-est.serie-docto  = pserie-docto
          AND docum-est.nro-docto    = pnro-docto
          AND docum-est.cod-emitente = pcod-emitente
          AND docum-est.nat-operacao = pnat-operacao: END.

    IF AVAIL docum-est THEN
        ASSIGN pr-docto = ROWID(docum-est).
    ELSE
        ASSIGN pr-docto = ?.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaNomeAbrev DBOProgram 
PROCEDURE retornaNomeAbrev :
/*------------------------------------------------------------------------------
  Purpose:    Retorna o nome abreviado do emitente     
  Parameters: p-cod-emitente: C½digo do emitente 
              p-nome-abrev:   Nome abreviado do emitente
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAMETER p-cod-emitente LIKE emitente.cod-emitente NO-UNDO.
    DEF OUTPUT PARAMETER p-nome-abrev   LIKE emitente.nome-abrev   NO-UNDO.

    FOR FIRST emitente FIELDS (nome-abrev pais estado)
        WHERE emitente.cod-emitente = p-cod-emitente NO-LOCK:
    END.
    IF AVAIL emitente THEN
        ASSIGN p-nome-abrev = emitente.nome-abrev.
    ELSE 
        ASSIGN p-nome-abrev = "".

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDocumento DBOProgram 
PROCEDURE setConstraintDocumento :
/*------------------------------------------------------------------------------
  Purpose: Setar a chave do documento    
  Parameters: p-chave-acesso: Chave de acesso do documento
              p-idi-origem:   Origem do documento
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-chave-acesso LIKE docto-orig-cte.cod-aces-comp-nfe NO-UNDO.
    DEF INPUT PARAM p-idi-origem   LIKE docto-orig-cte.idi-orig-trad     NO-UNDO.

    ASSIGN c-chave-acesso = p-chave-acesso
           i-idi-origem   = p-idi-origem  .

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE  setNatOperacao DBOProgram
PROCEDURE setNatOperacao:
/*------------------------------------------------------------------------------
  Purpose: Setar a natureza de operacao do documento    
  Parameters: p-nat-operacao: Natureza de operacao do documento
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-nat-operacao LIKE docto-orig-cte.nat-operacao NO-UNDO.

    ASSIGN c-nat-operacao = p-nat-operacao.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields DBOProgram 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:   
  Parameters: 
              
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER  pFieldName   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldEnable AS LOGICAL   NO-UNDO.

    IF AVAIL {&TableName} THEN DO:

        IF c-nat-operacao <> "" THEN
            FIND FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = c-nat-operacao NO-ERROR.
        ELSE 
            FIND FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = {&TableName}.nat-operacao NO-ERROR.

        FIND FIRST param-re where param-re.usuario = c-seg-usuario no-lock no-error. 

        CASE pFieldName:
            WHEN "de-valor-pedagio":U THEN ASSIGN pFieldEnable = (  avail param-re
                                                                and substring(param-re.char-1,21,1) = "1" 
                                                                and avail natur-oper
                                                                and natur-oper.tipo-compra = 2). 
            WHEN "log-encerra-pa":U THEN DO:
                ASSIGN pFieldEnable = (AVAIL param-re
                                       AND   param-re.encerra-cc
                                       AND   param-global.modulo-cc).
            END.
            WHEN "log-frete-saida" THEN DO:
                IF AVAIL natur-oper THEN DO:
                    IF natur-oper.nota-rateio = YES THEN  /*Rateio*/
                        ASSIGN pFieldEnable = NO.
                    ELSE
                        ASSIGN pFieldEnable = YES.
                END.
                ELSE
                    ASSIGN pFieldEnable = YES.
            END.
            OTHERWISE ASSIGN pFieldEnable = yes.
        END CASE.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMonitorCTe DBOProgram 
PROCEDURE setConstraintMonitorCTe :
/*------------------------------------------------------------------------------
  Purpose: Setar variÿveis utilizadas na abertura da query utilizada pelo monitor   
  Parameters: p-tg-digitada: mostra os conhecimentos digitadas no recebimento fiscal      
              p-tg-erro-neg: mostra os conhecimentos com erro de neg¢cio 
              p-tg-atualizada: mostra os conhecimentos atualizados no recebimento fiscal    
              p-tg-eliminada: mostra os conhecimentos eliminados no recebimento fiscal     
              p-tg-cancelada: mostra os conhecimentos cancelados    
              p-tg-inutilizada: mostra os conhecimentos inutilizados
              p-tg-validacao: mostra os conhecimentos em valida‡Æo     
              p-tg-todos: mostra os conhecimentos em qualquer situa‡Æo         
              p-cod-emitente-ini: c¢digo do fornecedor inicial 
              p-cod-emitente-fim: c¢digo do fornecedor final 
              p-cod-estabel-ini: c¢digo do estabelecimento inicial  
              p-cod-estabel-fim: c¢digo do estabelecimento fiscal  
              p-serie-ini: s‚rie inicial        
              p-serie-fim: s‚rie final        
              p-nro-docto-ini: n£mero do conhecimento inicial    
              p-nro-docto-fim: n£mero do conhecimento final    
              p-dt-emissao-ini: data de emissÆo inicial   
              p-dt-emissao-fim: data de emissÆo final   
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-tg-digitada            AS LOG                          NO-UNDO.
    DEF INPUT PARAM p-tg-erro-neg            AS LOG                          NO-UNDO.
    DEF INPUT PARAM p-tg-atualizada          AS LOG                          NO-UNDO.
    DEF INPUT PARAM p-tg-eliminada           AS LOG                          NO-UNDO.
    DEF INPUT PARAM p-tg-cancelada           AS LOG                          NO-UNDO.
    def input param p-tg-inutilizada         AS log                          NO-UNDO.
    DEF INPUT PARAM p-tg-validacao           AS LOG                          NO-UNDO.
    DEF INPUT PARAM p-tg-todos               AS LOG                          NO-UNDO.
    DEF INPUT PARAM p-cod-emitente-ini       LIKE emitente.cod-emitente      NO-UNDO.
    DEF INPUT PARAM p-cod-emitente-fim       LIKE emitente.cod-emitente      NO-UNDO.
    DEF INPUT PARAM p-cod-estabel-ini        LIKE docum-est.cod-estabel      NO-UNDO.
    DEF INPUT PARAM p-cod-estabel-fim        LIKE docum-est.cod-estabel      NO-UNDO.
    DEF INPUT PARAM p-serie-ini              LIKE docum-est.serie-docto      NO-UNDO.
    DEF INPUT PARAM p-serie-fim              LIKE docum-est.serie-docto      NO-UNDO.
    DEF INPUT PARAM p-nro-docto-ini          LIKE docum-est.nro-docto        NO-UNDO.
    DEF INPUT PARAM p-nro-docto-fim          LIKE docum-est.nro-docto        NO-UNDO.
    DEF INPUT PARAM p-dt-emissao-ini         LIKE docum-est.dt-emissao       NO-UNDO.
    DEF INPUT PARAM p-dt-emissao-fim         LIKE docum-est.dt-emissao       NO-UNDO.

    ASSIGN tg-digitada          = p-tg-digitada 
           tg-erro-neg          = p-tg-erro-neg     
           tg-atualizada        = p-tg-atualizada   
           tg-eliminada         = p-tg-eliminada   
           tg-cancelada         = p-tg-cancelada   
           tg-inutilizada       = p-tg-inutilizada
           tg-validacao         = p-tg-validacao
           tg-todos             = p-tg-todos
           c-cod-emitente-ini   = p-cod-emitente-ini
           c-cod-emitente-fim   = p-cod-emitente-fim
           c-cod-estabel-ini    = p-cod-estabel-ini 
           c-cod-estabel-fim    = p-cod-estabel-fim 
           c-serie-ini          = p-serie-ini       
           c-serie-fim          = p-serie-fim       
           c-nro-docto-ini      = p-nro-docto-ini   
           c-nro-docto-fim      = p-nro-docto-fim   
           dt-emissao-ini       = p-dt-emissao-ini  
           dt-emissao-fim       = p-dt-emissao-fim.

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
    DEFINE VARIABLE c-lbl-liter-transacao   AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE h-boad098na             AS HANDLE       NO-UNDO.
    DEFINE VARIABLE h-boad268na             AS HANDLE       NO-UNDO.
    DEFINE VARIABLE c-cgc                   AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE i-tipo                  AS INTEGER      NO-UNDO.
    DEFINE VARIABLE i-tipo-contr            AS INTEGER      NO-UNDO.


    IF pType = "CREATE" THEN DO:

        FIND FIRST bf{&TableName} NO-LOCK
             WHERE bf{&TableName}.cod-aces-comp-nfe = RowObject.cod-aces-comp-nfe
               AND bf{&TableName}.idi-orig-trad     = RowObject.idi-orig-trad NO-ERROR.

        /*-- J  existe Registro com Chave Informada --*/
        IF  AVAIL bf{&TableName} THEN DO:
            {utp/ut-liter.i Conhecimento_Transporte *}
            {method/svc/errors/inserr.i &ErrorNumber="8"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=RETURN-VALUE}
        END.                       
    END.
    
    IF pType = "UPDATE" THEN DO:  
        /* VALIDA€ÇO ESTABELECIMENTO */ 
        IF NOT CAN-FIND(FIRST estabelec WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            {utp/ut-liter.i "Estabelecimento" *}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
             RETURN "NOK":U.          
        END.         
        /* VALIDA€ÇO CNPJ DESTINO */
        FIND FIRST estabelec 
             WHERE estabelec.cod-estabel = RowObject.cod-estabel NO-LOCK NO-ERROR.             
        IF AVAIL estabelec THEN DO:                   
            FOR FIRST bf{&TableName} NO-LOCK
                WHERE bf{&TableName}.cod-aces-comp-nfe = RowObject.cod-aces-comp-nfe
                  AND bf{&TableName}.idi-orig-trad      = 1:                  
                IF substring(bf{&TableName}.cod-livre-1,1,20) <> estabelec.cgc THEN DO:                        
                    {utp/ut-liter.i "do_Tomador" * }
                    {method/svc/errors/inserr.i &ErrorNumber="54356"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="TRIM(RETURN-VALUE)"}
                END.
            END. 
        END.
        
        /** VALIDA€ÇO SERIE **/
        IF NOT CAN-FIND(FIRST serie NO-LOCK
                        WHERE serie.serie = RowObject.serie-docto) THEN DO:                             
            {utp/ut-liter.i "Serie" *}            
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END. 

        /* Valida‡Æo C¢digo IBGE Municipio Origem*/
        IF SUBSTRING(RowObject.cod-livre-1,21,10) <> "" THEN DO:
            IF NOT CAN-FIND(FIRST cidade 
                            WHERE cidade.cdn-munpio-ibge = INT(SUBSTRING(RowObject.cod-livre-1,21,10))) THEN DO:
                {utp/ut-liter.i "Origem" *}
                {method/svc/errors/inserr.i &ErrorNumber="55635"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="TRIM(RETURN-VALUE)"}
            END.
        END.
        
        /* Valida‡Æo C¢digo IBGE Municipio Destino*/
        IF substring(RowObject.cod-livre-1,31,10) <> "" THEN DO: 
            IF NOT CAN-FIND(FIRST cidade 
                            WHERE cidade.cdn-munpio-ibge = INT(SUBSTRING(RowObject.cod-livre-1,31,10))) THEN DO:
                {utp/ut-liter.i "Destino" *}
                {method/svc/errors/inserr.i &ErrorNumber="55635"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="TRIM(RETURN-VALUE)"}
            END.
        END.
    END.

    IF pType <> "DELETE" THEN DO: 

        IF NOT VALID-HANDLE(h-boad098na) THEN
            RUN adbo/boad098na.p PERSISTENT SET h-boad098na.
            
        RUN openQueryStatic IN h-boad098na (INPUT  "Main":U)  NO-ERROR.
        RUN goToKey IN h-boad098na (INPUT  RowObject.cod-emitente).
        IF  RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Emitente" *}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END. 
        
        RUN getCharField IN h-boad098na (INPUT  "cgc",
                                         OUTPUT c-cgc).

        IF  VALID-HANDLE(h-boad098na) THEN DO:
            DELETE PROCEDURE h-boad098na.
            ASSIGN h-boad098na = ?.
        END.
                                         
        IF RowObject.cnpj-emit <> c-cgc THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="52406"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
        END.

        IF NOT VALID-HANDLE(h-boad268na) THEN
            RUN adbo/boad268na.p PERSISTENT SET h-boad268na.
        
        RUN openQueryStatic IN h-boad268na (INPUT  "Main":U)  NO-ERROR.

        /* Validar se o fornecedor ‚ transportadora */
        RUN goToCGC IN h-boad268na (INPUT c-cgc).

        IF RETURN-VALUE = "NOK":U THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="52405"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
        END.

        IF  VALID-HANDLE(h-boad268na) THEN DO:
            DELETE PROCEDURE h-boad268na.
            ASSIGN h-boad268na = ?.
        END.

        /*******************************/
        RUN validaNaturOper (INPUT RowObject.cod-aces-comp-nfe,
                             INPUT RowObject.nat-operacao).
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.

        IF natur-oper.nota-rateio THEN DO:
        
           FOR FIRST tt-rat-docto-orig-cte-criar: END.
           FOR FIRST tt-rat-docto-orig-cte-del: END.

           IF NOT AVAIL tt-rat-docto-orig-cte-criar OR  
              NOT AVAIL tt-rat-docto-orig-cte-del   THEN
               RUN validaRatDoctoOrigCte.
        END.

        IF l-salva-rat-despes THEN
            RUN validateRateioDespesa.

        IF RowObject.dt-trans < RowObject.dt-emissao THEN DO:
            {utp/ut-liter.i "de transa‡Æo" *}
            ASSIGN c-lbl-liter-transacao = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "de emissÆo" *}
            {method/svc/errors/inserr.i &ErrorNumber="89"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-transacao + '~~~~' + TRIM(RETURN-VALUE)"}
        END.
        
        IF RowObject.dt-trans > TODAY THEN DO:
            {utp/ut-liter.i "Data de transa‡Æo" *}
            {method/svc/errors/inserr.i &ErrorNumber="17043"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.
    END.

    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
        RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaChaveSEFAZ DBOProgram 
PROCEDURE validaChaveSEFAZ :
/*------------------------------------------------------------------------------
  Purpose: Valida CT-e na SEFAZ    
  Parameters:  pc-ch-acesso-comp-cte: Chave de acesso do CT-e
               pi-cod-msg: Codigo da mensagem
               pc-texto-msg: Texto da mensagem
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-ch-acesso-comp-cte like docto-orig-cte.cod-aces-comp-nfe no-undo.
    def output param pi-cod-msg            as int initial 0                      no-undo.
    def output param pc-texto-msg          as char                               no-undo.
    
    DEF VAR i-meio-validacao     AS INT INIT 0 NO-UNDO.
    DEF VAR cTpTrans             AS CHARACTER  NO-UNDO.

    find first bf{&TableName} no-lock
        where bf{&TableName}.cod-aces-comp-nfe  = pc-ch-acesso-comp-cte
        and   bf{&TableName}.idi-orig-trad      = 2 no-error.   
        
    /* Nova tela que configura o tipo de integra‡Æo da chave de acesso por estabelecimento (CD0360) */
    RUN cdp/cd0360b.p (INPUT bf{&TableName}.cod-estabel,
                       INPUT "ConsChave":U, /* Consulta Chave */
                       OUTPUT cTpTrans).
    CASE cTpTrans:
        WHEN "Nenhum":U THEN RETURN "OK":U.
        WHEN "TSS":U    THEN ASSIGN i-meio-validacao = 2.
        WHEN "TC":U     THEN ASSIGN i-meio-validacao = 2.
        WHEN "TC2":U    THEN ASSIGN i-meio-validacao = 3.
        WHEN "TPF":U    THEN ASSIGN i-meio-validacao = 3.
        OTHERWISE            ASSIGN i-meio-validacao = 99. /* NÆo configurado no CD0360 */
    END CASE.

    /* NÆo foi configurado o CD0360 - suaviza‡Æo */
    IF i-meio-validacao = 99 THEN DO:
        DEF VAR l-integr-totvs-colab AS LOG  NO-UNDO.
        RUN cdp/cd0029a.p (output l-integr-totvs-colab).      

        IF RETURN-VALUE >= "2.0":U THEN
            ASSIGN i-meio-validacao = 3. /* Colabora‡Æo Ass¡ncrono (TC 2.0) */
        ELSE
            ASSIGN i-meio-validacao = 2. /* TSS - S¡ncrono */
    END.

    IF i-meio-validacao = 3 THEN DO: /* TOTVS COLABORA€ÇO 2.0 - Ass¡ncrono - Envio da mensagem consSitNFe ou consSitCTe */
        RUN rep/reapi331.p (INPUT TRIM(pc-ch-acesso-comp-cte),
                            INPUT bf{&TableName}.cod-estabel,
                            INPUT i-meio-validacao,                /* 0-Nenhum; 1-EAI; 2-TSS; 3-Colabora‡Æo Ass¡ncrono */
                            INPUT 1,                               /* Etapa s¢ ‚ utilizado quando o i-meio-validacao = 3 (Ass¡ncrono) */
                            INPUT "",                              /* S¢ ‚ usado na integra‡Æo via EAI - Neogrid */
                            OUTPUT TABLE tt_log_erro).
    END.

    RUN rep/reapi331.p (INPUT TRIM(pc-ch-acesso-comp-cte),
                        INPUT bf{&TableName}.cod-estabel,
                        INPUT i-meio-validacao,                /* 0-Nenhum; 1-EAI; 2-TSS; 3-Colabora‡Æo Ass¡ncrono */
                        INPUT 2,                               /* Etapa s¢ ‚ utilizado quando o i-meio-validacao = 3 (Ass¡ncrono) */
                        INPUT "",                              /* S¢ ‚ usado na integra‡Æo via EAI - Neogrid */
                        OUTPUT TABLE tt_log_erro).

    for each msg-ret-nfe no-lock
        where msg-ret-nfe.ch-acesso-comp-nfe = bf{&TableName}.cod-aces-comp-nfe
        and   msg-ret-nfe.idi-orig-trad      = 2:

        for first bfmsg-ret-nfe exclusive-lock
            where bfmsg-ret-nfe.seq-msg    = msg-ret-nfe.seq-msg:
            assign bfmsg-ret-nfe.log-ativo = no.
        end.
        release bfmsg-ret-nfe.
    end.

    FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
    IF NOT AVAIL tt_log_erro THEN RETURN "NOK":U.
    
    ASSIGN pi-cod-msg   = tt_log_erro.ttv_num_cod_erro
           pc-texto-msg = tt_log_erro.ttv_des_msg_erro.

    IF pi-cod-msg = 17006 THEN DO:
        {utp/ut-liter.i NÆo_foi_poss¡vel_validar_a_chave_do_CT-e._Verifique_a_configura‡Æo_do_ambiente_de_integra‡Æo. *}
        ASSIGN pc-texto-msg = RETURN-VALUE.
    END.

    IF tt_log_erro.ttv_des_msg_ajuda <> "" AND tt_log_erro.ttv_des_msg_ajuda <> ? THEN
        ASSIGN pc-texto-msg = pc-texto-msg + "~~":U + tt_log_erro.ttv_des_msg_ajuda.

    /* Cancelada ou Danfe invalido */
    if  pi-cod-msg = 52843 OR pi-cod-msg = 33140 THEN
        RUN pi-create-msg-ret-nfe (pc-ch-acesso-comp-cte, pi-cod-msg, pc-texto-msg, 1). /* Erro */
    else
        RUN pi-create-msg-ret-nfe (pc-ch-acesso-comp-cte, pi-cod-msg, pc-texto-msg, 4). /* Informacao */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaCodIBGE DBOProgram 
PROCEDURE validaCodIBGE :
/*------------------------------------------------------------------------------
  Purpose: Valida Codigo IBGE Municipio    
  Parameters: p-cod-ibge
  Notes:      1 = Origem, 2 = Destino 
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-cod-ibge AS INTEGER NO-UNDO.

    IF CAN-FIND(FIRST natur-oper
                WHERE natur-oper.nat-operacao = RowObject.nat-operacao 
                  AND natur-oper.tipo-compra = 2) AND 
       (SUBSTRING(RowObject.cod-aces-comp-nfe,21,2) = "57" OR 
        SUBSTRING(RowObject.cod-aces-comp-nfe,21,2) = "63" OR 
        SUBSTRING(RowObject.cod-aces-comp-nfe,21,2) = "67") THEN DO:

        IF p-cod-ibge = 1 THEN
            {utp/ut-liter.i "Origem" *}
        ELSE 
            {utp/ut-liter.i "Destino" *}

        {method/svc/errors/inserr.i
                          &ErrorNumber="55636"
                          &ErrorType="EMS"
                          &ErrorSubType="ERROR"
                          &ErrorParameters=RETURN-VALUE}

        RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableEncerraPa DBOProgram 
PROCEDURE enableEncerraPa :
/*------------------------------------------------------------------------------
  Purpose: Retorna se deve habilitar o campo encerra parcela
  Parameters: pi-numero-ordem: numero da ordem de compra
              pi-num-seq-event: numero do evento
              pl-enable : Indica se habilita ou n’o
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAM pi-numero-ordem  LIKE item-doc-orig-nfe.numero-ordem  NO-UNDO.
    DEFINE INPUT  PARAM pi-num-seq-event LIKE item-doc-orig-nfe.int-1         NO-UNDO.
    DEFINE OUTPUT PARAM pl-enable        AS LOGICAL NO-UNDO.

    DEF VAR de-val-aux          AS DECIMAL NO-UNDO.
    DEF VAR l-erro-co           AS LOGICAL NO-UNDO.
    DEF VAR l-contrato          AS LOGICAL NO-UNDO.

    FIND FIRST ordem-compra NO-LOCK 
         WHERE ordem-compra.numero-ordem = pi-numero-ordem NO-ERROR.
    IF AVAIL ordem-compra THEN DO:

        IF param-global.modulo-cn AND ordem-compra.nr-contrato <> 0 THEN DO:
            RUN cnp/cn9074.p (pi-numero-ordem,
                              1,
                              pi-num-seq-event,
                              0,
                              TODAY,
                              OUTPUT de-val-aux,
                              OUTPUT l-erro-co,
                              OUTPUT l-contrato,
                              INPUT-OUTPUT TABLE tt-erro-contrato).
        END.

        RUN enableFields (INPUT "log-encerra-pa":U, OUTPUT pl-enable).

        IF pl-enable AND NOT l-contrato THEN
            ASSIGN pl-enable = YES.
        ELSE 
            ASSIGN pl-enable = NO.
    END.
    ELSE 
        ASSIGN pl-enable = NO.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaParamNfe DBOProgram 
PROCEDURE verificaParamNfe : 
/*------------------------------------------------------------------------------
  Purpose: Verificar parâmetro do re0119, se marcado para alterar data de transação,
  CT-e irá gerar o documento automaticamente com a data da geração do documento.  
 ------------------------------------------------------------------------------*/
       
    IF NOT VALID-HANDLE(h-boin862) /* -> BO param-convrsr-nfe */
    OR h-boin862:TYPE      <> "PROCEDURE":U 
    OR h-boin862:FILE-NAME <> "inbo/boin862.p":U THEN
        RUN inbo/boin862.p PERSISTENT SET h-boin862.
    
    RUN openQueryStatic IN h-boin862 (INPUT "Main":U) NO-ERROR.
    RUN getFirst IN h-boin862.
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    ELSE DO:
        RUN getLogField IN h-boin862 (INPUT "log-altera-dat-trans":U,         OUTPUT l-altera-dt-trans).
    END.   

    IF  VALID-HANDLE(h-boin862)        AND
        h-boin862:TYPE = "PROCEDURE":U AND
        h-boin862:FILE-NAME = "inbo/boin862.p":U THEN DO:
        DELETE PROCEDURE h-boin862.
        ASSIGN h-boin862 = ?.
    END.    
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaNaturOper DBOProgram 
PROCEDURE validaNaturOper : 
    DEFINE INPUT PARAM pc-chave-acesso          LIKE RowObject.cod-aces-comp-nfe            NO-UNDO.
    DEFINE INPUT PARAM pc-nat-operacao          LIKE RowObject.nat-operacao                 NO-UNDO.

    DEFINE VARIABLE iRowid AS INTEGER      NO-UNDO.

    ASSIGN l-elimina-item = NO.

    FIND FIRST natur-oper WHERE natur-oper.nat-operacao = pc-nat-operacao NO-LOCK NO-ERROR.
    IF NOT AVAIL natur-oper THEN DO:
        {utp/ut-liter.i "Natureza_de_Opera‡Æo" *}
        {method/svc/errors/inserr.i
                          &ErrorNumber="2"
                          &ErrorType="EMS"
                          &ErrorSubType="ERROR"
                          &ErrorParameters=RETURN-VALUE}
        RETURN "NOK":U.
    END.

    IF natur-oper.tipo = 2 /* Sa¡da */ 
    OR natur-oper.tipo = 3 /* Servico */ THEN DO:
        {method/svc/errors/inserr.i
                          &ErrorNumber="15026"
                          &ErrorType="EMS"
                          &ErrorSubType="ERROR"}
        RETURN "NOK":U.
    END.

    IF natur-oper.terceiros THEN DO:
        {method/svc/errors/inserr.i
                          &ErrorNumber="19491"
                          &ErrorType="EMS"
                          &ErrorSubType="ERROR"}
    END.

    IF natur-oper.nota-rateio THEN DO:
       IF CAN-FIND(FIRST item-docto-orig-cte 
                 WHERE item-docto-orig-cte.cod-aces-comp-nfe = pc-chave-acesso) THEN DO:
            ASSIGN l-elimina-item = YES.
            // Aviso que o item sera eliminado
            {method/svc/errors/inserr.i
                            &ErrorNumber="57083"
                            &ErrorType="EMS"
                            &ErrorSubType="WARNING"}
       END.
    END.
    ELSE DO: /*se for rateio*/
        IF NOT VALID-HANDLE(h-boin872) THEN 
            RUN inbo/boin872.p PERSISTENT SET h-boin872.

        RUN emptyRowObject          IN h-boin872.
        RUN openQueryStatic IN h-boin872 (INPUT "Main":U) NO-ERROR. 
        RUN setConstraintAcessoChave IN h-boin872 (INPUT  pc-chave-acesso, INPUT 2).
        RUN openQueryStatic          IN h-boin872 (INPUT  "AcessoChave":U) NO-ERROR.
        RUN getBatchRecords          IN h-boin872 (INPUT  ?,
                                                   INPUT  NO,
                                                   INPUT  9999,
                                                   OUTPUT iRowid,
                                                   OUTPUT TABLE tt-rat-docto-orig-cte).
    
        FIND FIRST tt-rat-docto-orig-cte NO-LOCK NO-ERROR.
        IF  AVAIL tt-rat-docto-orig-cte THEN DO:
           {method/svc/errors/inserr.i
                          &ErrorNumber="57084"
                          &ErrorType="EMS"
                          &ErrorSubType="WARNING"}
        END.

        IF  AVAIL tt-rat-docto-orig-cte THEN DO:
        
            EMPTY TEMP-TABLE tt-rat-docto-orig-cte.
            RUN setConstraintAcessoChave IN h-boin872 (INPUT  pc-chave-acesso, INPUT 1).
            RUN openQueryStatic          IN h-boin872 (INPUT  "AcessoChave":U) NO-ERROR.
            RUN getBatchRecords          IN h-boin872 (INPUT  ?,
                                                       INPUT  NO,
                                                       INPUT  9999,
                                                       OUTPUT iRowid,
                                                       OUTPUT TABLE tt-rat-docto-orig-cte).
    
            FOR EACH tt-rat-docto-orig-cte:
                EMPTY TEMP-TABLE tt-rat-docto-orig-cte-aux.
                CREATE tt-rat-docto-orig-cte-aux.
                BUFFER-COPY tt-rat-docto-orig-cte TO tt-rat-docto-orig-cte-aux.
        
                RUN openQueryStatic  IN h-boin872 (INPUT 'Main':U).
                RUN repositionRecord IN h-boin872 (INPUT tt-rat-docto-orig-cte-aux.r-rowid).
                RUN validateRecord (INPUT "DELETE":U).
                
                IF RETURN-VALUE = "NOK" THEN DO:
                    RUN getRowErrors IN h-boin872 (OUTPUT TABLE RowErrors APPEND).
                    FOR EACH RowErrors
                        WHERE (   rowErrors.ErrorNumber = 10
                               OR rowErrors.ErrorNumber = 8
                               OR rowErrors.ErrorNumber = 3):
                        IF  rowErrors.ErrorType = "Internal":U THEN
                            DELETE rowErrors.
                    END.
                END.
            END.
        END. /* IF AVAIL tt-rat-docto-orig-cte */
    END.

    RETURN "OK":U.
    FINALLY:
        IF VALID-HANDLE(h-boin872) THEN DO:
            DELETE PROCEDURE h-boin872 NO-ERROR.
            ASSIGN h-boin872 = ?.
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord:

    /* ORIGEM */
    EMPTY TEMP-TABLE RowErrors.

    IF NOT VALID-HANDLE(h-boin872) THEN DO:
        RUN inbo/boin872.p PERSISTENT SET h-boin872.
        RUN openQueryStatic IN h-boin872 (INPUT "Main").
    END.

    IF CAN-FIND(FIRST tt-rat-docto-orig-cte-del) THEN
        RUN deletarRatDoctoOrigCte.
    IF CAN-FIND(FIRST tt-rat-docto-orig-cte-criar) THEN
        RUN criarRatDoctoOrigCte.

    IF l-salva-rat-despes THEN
        RUN updateRateioDespesa.

    FOR FIRST item-docto-orig-cte 
        WHERE item-docto-orig-cte.cod-aces-comp-nfe = RowObject.cod-aces-comp-nfe
        AND   item-docto-orig-cte.idi-orig-trad = 2 EXCLUSIVE-LOCK:
        ASSIGN item-docto-orig-cte.serie-docto  = RowObject.serie-docto 
               item-docto-orig-cte.nat-operacao = RowObject.nat-operacao.
    END.
    FIND CURRENT item-docto-orig-cte NO-LOCK NO-ERROR.

    IF l-elimina-item THEN DO:
        RUN pi-elimina-item.
        IF  RETURN-VALUE = "NOK":U THEN DO:
            RETURN "NOK":U.
        END.
    END.

    IF CAN-FIND (FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = RowObject.nat-operacao
                 AND   natur-oper.nota-rateio  = NO)  THEN DO:   
        /*16044 - Se natureza nÆo for rateio elimina o rateio de compras*/
        FOR EACH rat-docto-orig-cte EXCLUSIVE-LOCK
            WHERE rat-docto-orig-cte.cod-aces-comp-nfe  = RowObject.cod-aces-comp-nfe
            AND   rat-docto-orig-cte.idi-orig-trad      = 2:  //Manter os dados originais = 1 e o 3 = Rateio de venda
            DELETE rat-docto-orig-cte.
        END.

        RUN pi-cria-item.
    END.

    /*15807 - NÆo gerar erro de fim de query - INTERNAL*/
    FOR EACH RowErrors
        WHERE (   rowErrors.ErrorNumber = 10
               OR rowErrors.ErrorNumber = 8
               OR rowErrors.ErrorNumber = 3):
        IF  rowErrors.ErrorType = "INTERNAL":U THEN
            DELETE rowErrors.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

    FINALLY:
        IF VALID-HANDLE(h-boin872) THEN DO:
            DELETE PROCEDURE h-boin872 NO-ERROR.
            ASSIGN h-boin872 = ?.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-item wMaintenance 
PROCEDURE pi-cria-item :
    IF  NOT VALID-HANDLE(h-boin873trad) THEN DO:
        RUN inbo/boin873.p PERSISTEN SET h-boin873trad.
    END.
    RUN emptyRowObject  IN h-boin873trad.
    RUN emptyRowErrors  IN h-boin873trad. 
    RUN setConstraintChaveItemDoc IN h-boin873trad (INPUT  RowObject.cod-aces-comp-nfe, INPUT 2).
    RUN openQueryStatic IN h-boin873trad (INPUT 'ChaveItemDoc':U).
    RUN goToKey         IN h-boin873trad (INPUT  RowObject.cod-aces-comp-nfe, INPUT 2).
              
    IF RETURN-VALUE = "NOK":U THEN DO:
        CREATE tt-item-docto-orig-cte-trad.
        ASSIGN tt-item-docto-orig-cte-trad.cod-aces-comp-nfe = RowObject.cod-aces-comp-nfe
               tt-item-docto-orig-cte-trad.serie-docto       = RowObject.serie-docto
               tt-item-docto-orig-cte-trad.nro-docto         = RowObject.nro-docto
               tt-item-docto-orig-cte-trad.nat-operacao      = RowObject.nat-operacao
               tt-item-docto-orig-cte-trad.cod-emitente      = RowObject.cod-emitente
               tt-item-docto-orig-cte-trad.nat-operacao      = RowObject.nat-operacao
               tt-item-docto-orig-cte-trad.serie-docto       = RowObject.serie-docto
               tt-item-docto-orig-cte-trad.idi-orig-trad     = 2
               tt-item-docto-orig-cte-trad.qtd-inter         = 1. 

        RUN setRecord IN h-boin873trad (INPUT TABLE tt-item-docto-orig-cte-trad).
        IF RETURN-VALUE = "OK":U THEN
            RUN createRecord IN h-boin873trad.
        RUN getRowErrors IN h-boin873trad (OUTPUT TABLE rowErrors).

        IF CAN-FIND(FIRST RowErrors) THEN
           RETURN "NOK":U.
    END.
    
    RETURN "OK":U.

    FINALLY:
        IF VALID-HANDLE(h-boin873trad) THEN DO:
            DELETE PROCEDURE h-boin873trad NO-ERROR.
            ASSIGN h-boin873trad = ?.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina-item wMaintenance 
PROCEDURE pi-elimina-item :
/*------------------------------------------------------------------------------
  Purpose:     Eliminar item da Conhecimento Transporte
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  NOT VALID-HANDLE(h-boin873orig) THEN DO:
        RUN inbo/boin873.p PERSISTEN SET h-boin873orig.
    END.
        
    RUN openQueryStatic IN h-boin873orig("Main":U).
    RUN gotoKey IN h-boin873orig(INPUT RowObject.cod-aces-comp-nfe,
                                 INPUT 1).
    RUN getRecord IN h-boin873orig(OUTPUT TABLE tt-item-docto-orig-cte).

    RUN gotoKey IN h-boin873orig(INPUT RowObject.cod-aces-comp-nfe,
                                 INPUT 2).
    RUN getRecord IN h-boin873orig(OUTPUT TABLE tt-item-docto-orig-cte-trad).

    FIND FIRST tt-item-docto-orig-cte NO-ERROR.
    FIND FIRST tt-item-docto-orig-cte-trad NO-ERROR.

    IF  AVAIL tt-item-docto-orig-cte
    OR  AVAIL tt-item-docto-orig-cte-trad THEN DO:

        RUN openQueryStatic IN h-boin873orig("Main":U).

        RUN repositionRecord IN h-boin873orig (INPUT tt-item-docto-orig-cte.r-rowid).

        IF  RETURN-VALUE = "OK":U THEN
            RUN deleteRecord IN h-boin873orig.

        RUN openQueryStatic IN h-boin873orig("Main":U).

        RUN repositionRecord IN h-boin873orig (INPUT tt-item-docto-orig-cte-trad.r-rowid).

        IF  RETURN-VALUE = "OK":U THEN
            RUN deleteRecord IN h-boin873orig.
    
        RUN getRowErrors IN h-boin873orig(OUTPUT TABLE RowErrors APPEND).
    END.

    RETURN "OK":U.

    FINALLY:
        IF VALID-HANDLE(h-boin873orig) THEN DO:
            DELETE PROCEDURE h-boin873orig NO-ERROR.
            ASSIGN h-boin873orig = ?.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setProcessamento DBOProgram 
PROCEDURE setProcessamento :
/*------------------------------------------------------------------------------
  Purpose:     Coloca o documento em processamento ou retira do processamento
  Parameters:  chave de acesso da nota
               l-processamento = yes/no
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-codAcesCompCte   AS CHAR             NO-UNDO.
    DEFINE INPUT  PARAMETER l-processamento    AS LOG              NO-UNDO.

    FIND FIRST {&TableName}
         WHERE {&TableName}.cod-aces-comp-nfe = c-codAcesCompCte
           AND {&TableName}.idi-orig-trad     = 2 EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAIL {&TableName} THEN
        RETURN "NOK":U.

    ASSIGN {&TableName}.log-procmto      = l-processamento
           {&TableName}.cod-usuar-proces = c-seg-usuario
           {&TableName}.dat-process      = TODAY
           {&TableName}.hra-proces       = STRING(TIME,"HH:MM:SS").

    FIND CURRENT {&TableName} NO-LOCK NO-ERROR. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelaCteApi DBOProgram 
PROCEDURE cancelaCteApi :
/*------------------------------------------------------------------------------
  Purpose: Cancela o documento    
  Parameters:  pr-nota: Rowid da nota a ser cancelada
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-codAcesCompCte     AS CHAR             NO-UNDO.
    DEFINE INPUT  PARAMETER c-motivo             AS CHAR             NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE c-sit-txt   AS CHARACTER   NO-UNDO.

    RUN validacaoParametrosConversor.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RUN verificaEmProcessamento (INPUT c-codAcesCompCte). /* Verifica se ja esta em processamento */
    IF RETURN-VALUE = "NOK":U THEN /* documento ja esta em processamento ou nao esta avail */
        RETURN RETURN-VALUE.

    IF  bf{&TableName}.idi-situacao <> 2 AND
        bf{&TableName}.idi-situacao <> 4 THEN DO:
        ASSIGN c-sit-txt = {ininc/i01in847.i 04 bf{&TableName}.idi-situacao}.
        {method/svc/errors/inserr.i &ErrorNumber="57050"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-sit-txt"}
        RETURN "NOK":U.
    END.

    RUN inativarMensagensDocto (INPUT c-codAcesCompCte).
    IF param-convrsr-nfe.log-justif-cancel THEN DO: /* Motivo cancelamento obrigatorio */
        IF (c-motivo = ? OR TRIM(c-motivo) = "") THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="57451"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}

            RUN utp/ut-msgs.p ("MSG":U, 57451, "").
            RUN pi-create-msg-ret-nfe (c-codAcesCompCte, 57451, RETURN-VALUE, 1).

            RETURN "NOK":U.
        END.

        IF LENGTH(TRIM(c-motivo)) < 15 THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="57452"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}

            RUN utp/ut-msgs.p ("MSG":U, 57452, "").
            RUN pi-create-msg-ret-nfe (c-codAcesCompCte, 57452, RETURN-VALUE, 1).

            RETURN "NOK":U.
        END.
    END.

    RUN setProcessamento (INPUT c-codAcesCompCte, INPUT TRUE).

    RUN cancelaDocumento(INPUT ROWID(bf{&TableName}),
                         INPUT c-motivo).
    IF RETURN-VALUE = "OK":U THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="19531"
                                    &ErrorType="EMS"
                                    &ErrorSubType="INFORMATION"
                                    &ErrorParameters="TRIM(SUBSTRING({&TableName}.cod-livre-2,1,5)) + '~~~~' + {&TableName}.serie-docto + '~~~~' + {&TableName}.nro-docto"}

    END.

    /* Retira do 'em processamento' */
    RUN setProcessamento (INPUT c-codAcesCompCte, INPUT FALSE).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerarFiscalAPI DBOProgram 
PROCEDURE gerarFiscalAPI :
/*------------------------------------------------------------------------------
  Purpose:     Gera fiscal, sera utilizado pela API rest
  Parameters:  chave de acesso da nota a ser processada
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER cCodAcesCompNfe     AS CHAR             NO-UNDO.
    DEFINE OUTPUT PARAMETER l-docGerado         AS LOGICAL  INIT NO NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE iCodMsg AS INTEGER     NO-UNDO.

    /*Verifica se estÿ em processamento e se a situa»’o da nota permite gerar o documento no fiscal*/
    RUN validacoesGeracao (INPUT cCodAcesCompNfe).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN RETURN-VALUE.

    /* Coloca em 'processamento' */
    RUN setProcessamento (INPUT cCodAcesCompNfe, INPUT TRUE).

    RUN gerarNotaEntrada (INPUT rowid({&TableName}),
                          OUTPUT l-docGerado).

    RUN ativarMensagensDocto (INPUT cCodAcesCompNfe,
                              INPUT iCodMsg).

    /* Retira do 'em processamento' */
    RUN setProcessamento (INPUT cCodAcesCompNfe, INPUT FALSE).

    RETURN "OK":U.

    FINALLY:
        DELETE PROCEDURE h-boin862 NO-ERROR.
    END FINALLY.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validacoesGeracao DBOProgram 
PROCEDURE validacoesGeracao PRIVATE:
/*------------------------------------------------------------------------------
  Purpose:     Gera mensagem de erro se o documento esta em situacao invalida
               ou em processamento
  Parameters:  chave de acesso da nota
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER cCodAcesCompNfe   AS CHAR             NO-UNDO.
    DEF VAR c-sit-txt AS CHAR NO-UNDO.

    FIND param-convrsr-nfe NO-LOCK NO-ERROR.
    IF NOT AVAIL param-convrsr-nfe THEN DO:
        {utp/ut-liter.i Parametros_conversor_NF-e *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="RETURN-VALUE"}
        RETURN "NOK":U.
    END.

    RUN verificaEmProcessamento (INPUT cCodAcesCompNfe). /* Verifica se ja esta em processamento */
    IF RETURN-VALUE = "NOK":U THEN /* documento ja esta em processamento ou nao esta avail */
        RETURN RETURN-VALUE.

    /* valida situacoes que nao pode ser executada a geracao */
    IF CAN-DO("1,3,5,6,7,8,9,10", STRING(bf{&TableName}.idi-situacao)) THEN DO:
        IF (bf{&TableName}.idi-situacao = 5 /* Cancelada */ AND param-convrsr-nfe.log-bloq-nfe-cancda) OR 
            bf{&TableName}.idi-situacao <> 5 THEN DO:

            assign c-sit-txt = {ininc/i01in847.i 04 bf{&TableName}.idi-situacao}.
            {method/svc/errors/inserr.i &ErrorNumber="57040"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" 
                                        &ErrorParameters="c-sit-txt"}
            RETURN "NOK":U.
        END.
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ativarMensagensDocto DBOProgram 
PROCEDURE ativarMensagensDocto PRIVATE:
    DEFINE INPUT PARAMETER cCodAcesCompNfe AS CHAR    NO-UNDO.
    DEFINE INPUT PARAMETER pCodMsg         AS INTEGER NO-UNDO.
    
    IF pCodMsg <> 0 THEN DO:
       
       FOR LAST msg-ret-nfe EXCLUSIVE-LOCK
           WHERE msg-ret-nfe.ch-acesso-comp-nfe = cCodAcesCompNfe
           AND   msg-ret-nfe.idi-orig-trad      = 2
           AND   msg-ret-nfe.cd-msg             = pCodMsg:
           ASSIGN msg-ret-nfe.log-ativo = YES. /* Atualiza para ativa a msg criada j˜ criada na BO */
       END.
       RELEASE msg-ret-nfe.
    END.
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE salvaNarrativa DBOProgram 
PROCEDURE salvaNarrativa:
    DEFINE INPUT PARAMETER pcCodAcesCompNfe AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pcNarrativa      AS CHARACTER    NO-UNDO.
    
    FOR FIRST bf{&TableName}  
        WHERE bf{&TableName}.cod-aces-comp-nfe  = pcCodAcesCompNfe
        AND   bf{&TableName}.idi-orig-trad      = 2 EXCLUSIVE-LOCK:
        ASSIGN bf{&TableName}.cod-livre-2  = pcNarrativa.
    END.
    FIND CURRENT bf{&TableName}   NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTTRatDoctoOrigCte DBOProgram 
PROCEDURE setTTRatDoctoOrigCte:
    DEFINE INPUT PARAM TABLE FOR tt-rat-docto-orig-cte-param. 

    EMPTY TEMP-TABLE tt-rat-docto-orig-cte-del.     /* deletar */
    EMPTY TEMP-TABLE tt-rat-docto-orig-cte-criar.   /* criar */

    FOR FIRST tt-rat-docto-orig-cte-param: END.

    IF NOT AVAIL tt-rat-docto-orig-cte-param THEN DO:
        FOR EACH bfrat-docto-orig-cte
            WHERE bfrat-docto-orig-cte.cod-aces-comp-nfe    = RowObject.cod-aces-comp-nfe
              AND bfrat-docto-orig-cte.idi-orig-trad        = 2 NO-LOCK:

            CREATE tt-rat-docto-orig-cte-del.
            BUFFER-COPY bfrat-docto-orig-cte TO tt-rat-docto-orig-cte-del.
        END.
    END.
    ELSE DO:
        FOR EACH tt-rat-docto-orig-cte-param:
            IF NOT CAN-FIND(FIRST bfrat-docto-orig-cte 
                            WHERE bfrat-docto-orig-cte.cod-aces-comp-nfe    = tt-rat-docto-orig-cte-param.cod-aces-comp-nfe 
                            AND   bfrat-docto-orig-cte.idi-orig-trad        = 2 
                            AND   bfrat-docto-orig-cte.nf-serie             = tt-rat-docto-orig-cte-param.nf-serie 
                            AND   bfrat-docto-orig-cte.nf-nro               = tt-rat-docto-orig-cte-param.nf-nro 
                            AND   bfrat-docto-orig-cte.nf-emitente          = tt-rat-docto-orig-cte-param.nf-emitente 
                            AND   bfrat-docto-orig-cte.nf-nat-oper          = tt-rat-docto-orig-cte-param.nf-nat-oper) THEN DO:

                CREATE tt-rat-docto-orig-cte-criar.
                BUFFER-COPY tt-rat-docto-orig-cte-param TO tt-rat-docto-orig-cte-criar.
            END.
        END.

        FOR EACH bfrat-docto-orig-cte
            WHERE bfrat-docto-orig-cte.cod-aces-comp-nfe    = RowObject.cod-aces-comp-nfe
              AND bfrat-docto-orig-cte.idi-orig-trad        = 2 NO-LOCK:
            FOR FIRST tt-rat-docto-orig-cte-param 
                WHERE tt-rat-docto-orig-cte-param.cod-aces-comp-nfe = bfrat-docto-orig-cte.cod-aces-comp-nfe  
                AND   tt-rat-docto-orig-cte-param.idi-orig-trad     = bfrat-docto-orig-cte.idi-orig-trad
                AND   tt-rat-docto-orig-cte-param.nf-serie          = bfrat-docto-orig-cte.nf-serie          
                AND   tt-rat-docto-orig-cte-param.nf-nro            = bfrat-docto-orig-cte.nf-nro            
                AND   tt-rat-docto-orig-cte-param.nf-emitente       = bfrat-docto-orig-cte.nf-emitente       
                AND   tt-rat-docto-orig-cte-param.nf-nat-oper       = bfrat-docto-orig-cte.nf-nat-oper:
            END.
            IF NOT AVAIL tt-rat-docto-orig-cte-param THEN DO:
                CREATE tt-rat-docto-orig-cte-del.
                BUFFER-COPY bfrat-docto-orig-cte TO tt-rat-docto-orig-cte-del.
            END.
        END.
    END.

    EMPTY TEMP-TABLE tt-rat-docto-orig-cte-param.

    RETURN "OK":U.
END PROCEDURE .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTTRateioDespesa DBOProgram 
PROCEDURE setTTRateioDespesa:
    DEFINE INPUT PARAM TABLE FOR tt-rat-despes-cte-param. 

    DEFINE VARIABLE iSeq AS INTEGER     NO-UNDO.
    EMPTY TEMP-TABLE tt-rat-despes-cte.

    ASSIGN l-salva-rat-despes = TRUE.

    FOR EACH tt-rat-despes-cte-param:

        ASSIGN iSeq = 0.
        FIND LAST tt-rat-despes-cte NO-LOCK
             WHERE tt-rat-despes-cte.cod-aces-comp-nfe    = RowObject.cod-aces-comp-nfe NO-ERROR.
        IF NOT AVAIL tt-rat-despes-cte THEN
            ASSIGN iSeq = 1.
        ELSE 
            ASSIGN iSeq =  tt-rat-despes-cte.num-seq + 1.

        CREATE tt-rat-despes-cte.
        BUFFER-COPY tt-rat-despes-cte-param EXCEPT num-seq TO tt-rat-despes-cte.
        ASSIGN  tt-rat-despes-cte.num-seq = iSeq.
    END.
    EMPTY TEMP-TABLE tt-rat-despes-cte-param.

    RETURN "OK":U.
END PROCEDURE .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRateioDespesa DBOProgram 
PROCEDURE updateRateioDespesa PRIVATE:
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-boin01105     AS HANDLE NO-UNDO.

    IF NOT AVAIL RowObject THEN RETURN "NOK":U.

    RUN inbo/boin01105.p PERSISTENT SET h-boin01105.
    RUN openQueryStatic IN h-boin01105 (INPUT 'Main':U).

    FOR EACH rat-despes-cte EXCLUSIVE-LOCK
        WHERE rat-despes-cte.cod-aces-comp-nfe    = RowObject.cod-aces-comp-nfe:
        DELETE rat-despes-cte.
    END.
    
    FOR EACH tt-rat-despes-cte:
        EMPTY TEMP-TABLE tt-rat-despes-cte-param NO-ERROR.
        CREATE tt-rat-despes-cte-param.
        BUFFER-COPY tt-rat-despes-cte TO tt-rat-despes-cte-param.
  
        RUN emptyRowObject IN h-boin01105.
        RUN emptyRowErrors IN h-boin01105.
        RUN setRecord IN h-boin01105 (INPUT TABLE tt-rat-despes-cte-param).
        RUN createRecord IN h-boin01105. /* nao tem nada no validate record da BO, por isso nao eh buscada a RowErrors */
    END.

    RETURN "OK":U.

    FINALLY:
        DELETE PROCEDURE h-boin01105 NO-ERROR.
        ASSIGN h-boin01105 = ?.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRateioDespesa DBOProgram 
PROCEDURE validateRateioDespesa:
   DEFINE VARIABLE h-boin01105         AS HANDLE NO-UNDO.
   DEFINE VARIABLE deValorTotalRateio  AS DECIMAL   NO-UNDO.

   IF NOT AVAIL RowObject THEN RETURN "NOK":U.

   RUN inbo/boin01105.p PERSISTENT SET h-boin01105.
   RUN openQueryStatic IN h-boin01105 (INPUT 'Main':U).

   FOR EACH tt-rat-despes-cte:
       ASSIGN deValorTotalRateio = deValorTotalRateio  + tt-rat-despes-cte.val-rateio.

       EMPTY TEMP-TABLE tt-rat-despes-cte-param NO-ERROR.
       CREATE tt-rat-despes-cte-param.
       BUFFER-COPY tt-rat-despes-cte TO tt-rat-despes-cte-param.
 
       RUN emptyRowObject IN h-boin01105.
       RUN emptyRowErrors IN h-boin01105.
       RUN setRecord IN h-boin01105 (INPUT TABLE tt-rat-despes-cte-param).
       RUN validaRatDespesa IN h-boin01105.
       RUN getRowErrors IN h-boin01105 (OUTPUT TABLE RowErrors APPEND).
   END.

   IF CAN-FIND(FIRST tt-rat-despes-cte) AND
      RowObject.val-tot-mercad <> deValorTotalRateio THEN DO:
       {method/svc/errors/inserr.i
                         &ErrorNumber="57229"
                         &ErrorType="EMS"
                         &ErrorSubType="ERROR"}
   END.

   IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
       RETURN "NOK":U.

   RETURN "OK":U.

    FINALLY:
        DELETE PROCEDURE h-boin01105 NO-ERROR.
        ASSIGN h-boin01105 = ?.
    END FINALLY.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaRatDoctoOrigCte DBOProgram 
PROCEDURE validaRatDoctoOrigCte:
    IF NOT VALID-HANDLE(h-boin872) THEN 
       RUN inbo/boin872.p PERSISTENT SET h-boin872.
    FOR EACH tt-rat-docto-orig-cte-criar:
        RUN emptyRowObject  IN h-boin872.                                            
        RUN emptyRowErrors  IN h-boin872.                                        
        RUN setRecord       IN h-boin872 (INPUT TABLE tt-rat-docto-orig-cte-criar).
        run validateRecord  IN h-boin872 (INPUT "CREATE":U ).
        RUN getRowErrors    IN h-boin872(OUTPUT TABLE RowErrors APPEND).
    END.

    FOR EACH tt-rat-docto-orig-cte-del:
        RUN emptyRowObject  IN h-boin872.                                            
        RUN emptyRowErrors  IN h-boin872.                                        
        RUN setRecord       IN h-boin872 (INPUT TABLE tt-rat-docto-orig-cte-del).     
        run validateRecord  IN h-boin872 (INPUT "DELETE":U ).
        RUN getRowErrors    IN h-boin872(OUTPUT TABLE RowErrors APPEND).
    END.

    RETURN "OK":U.
    FINALLY:
        IF VALID-HANDLE(h-boin872) THEN DO:
            DELETE PROCEDURE h-boin872 NO-ERROR.
            ASSIGN h-boin872 = ?.
        END.
    END.
END PROCEDURE .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deletarRatDoctoOrigCte DBOProgram 
PROCEDURE deletarRatDoctoOrigCte PRIVATE:

    FOR EACH tt-rat-docto-orig-cte-del NO-LOCK:
        RUN emptyRowObject IN h-boin872.
        RUN emptyRowErrors IN h-boin872.
        RUN goToKey IN h-boin872 (INPUT tt-rat-docto-orig-cte-del.cod-aces-comp-nfe,
                                  INPUT tt-rat-docto-orig-cte-del.idi-orig-trad,    
                                  INPUT tt-rat-docto-orig-cte-del.nf-serie,         
                                  INPUT tt-rat-docto-orig-cte-del.nf-nro,           
                                  INPUT tt-rat-docto-orig-cte-del.nf-emitente,      
                                  INPUT tt-rat-docto-orig-cte-del.nf-nat-oper). 
        RUN deleteRecord IN h-boin872.
        RUN getRowErrors IN h-boin872(OUTPUT TABLE RowErrors APPEND).
    END.

    IF CAN-FIND(FIRST RowErrors) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criarRatDoctoOrigCte DBOProgram 
PROCEDURE criarRatDoctoOrigCte PRIVATE:

    EMPTY TEMP-TABLE tt-rat-docto-orig-cte-persist.

    FOR EACH tt-rat-docto-orig-cte-criar NO-LOCK:
        CREATE tt-rat-docto-orig-cte-persist.
        BUFFER-COPY tt-rat-docto-orig-cte-criar TO tt-rat-docto-orig-cte-persist.
        RUN emptyRowObject IN h-boin872.
        RUN emptyRowErrors IN h-boin872.
        RUN setRecord      IN h-boin872(INPUT TABLE tt-rat-docto-orig-cte-persist).
        RUN createRecord   IN h-boin872.  
        RUN getRowErrors IN h-boin872(OUTPUT TABLE RowErrors APPEND).
        DELETE tt-rat-docto-orig-cte-persist.
    END.

    IF CAN-FIND(FIRST RowErrors) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-create-msg-ret-nfe DBOProgram 
PROCEDURE pi-create-msg-ret-nfe PRIVATE:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pcod-aces-comp-nfe   LIKE docto-orig-cte.cod-aces-comp-nfe NO-UNDO.
    DEFINE INPUT PARAM pcd-erro             AS INT                                NO-UNDO.
    DEFINE INPUT PARAM pdesc-erro           AS CHAR                               NO-UNDO.
    DEFINE INPUT PARAM ptipo                AS INT                                NO-UNDO.

    CREATE msg-ret-nfe.
    ASSIGN msg-ret-nfe.ch-acesso-comp-nfe = pcod-aces-comp-nfe
           msg-ret-nfe.idi-orig-trad      = 2
           msg-ret-nfe.dt-msg             = TODAY
           msg-ret-nfe.hr-msg             = string(TIME, "HH:MM:SS")
           msg-ret-nfe.log-ativo          = YES
           msg-ret-nfe.cd-msg             = pcd-erro
           msg-ret-nfe.texto-msg          = pdesc-erro
           msg-ret-nfe.seq-msg            = NEXT-VALUE(seq-msg-ret-nfe)
           msg-ret-nfe.tipo-msg           = ptipo.
    release msg-ret-nfe.

    RETURN "OK":U.
END PROCEDURE .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTT-docum-est-transp DBOProgram 
PROCEDURE createTT-docum-est-transp :
/*------------------------------------------------------------------------------
  Purpose:     Cria a Temp-table tt-docum-est-transp
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR iSeqDocumEstTransp AS INT  INIT 0 NO-UNDO.

    FOR EACH rat-docto-orig-cte NO-LOCK
       WHERE rat-docto-orig-cte.cod-aces-comp-nfe = bf{&TableName}.cod-aces-comp-nfe
         AND rat-docto-orig-cte.idi-orig-trad     = 3:

        ASSIGN iSeqDocumEstTransp = iSeqDocumEstTransp + 1.

        CREATE tt-docum-est-transp.
        ASSIGN tt-docum-est-transp.nro-docto                = bf{&TableName}.nro-docto
               tt-docum-est-transp.nat-operacao             = bf{&TableName}.nat-operacao
               tt-docum-est-transp.serie-docto              = bf{&TableName}.serie-docto
               tt-docum-est-transp.cod-emitente             = bf{&TableName}.cod-emitente
               tt-docum-est-transp.num-seq                  = iSeqDocumEstTransp
               tt-docum-est-transp.cod-ser-docto-relac      = rat-docto-orig-cte.nf-serie
               tt-docum-est-transp.cod-num-docto-relac      = rat-docto-orig-cte.nf-nro
               tt-docum-est-transp.cod-estab-relac          = rat-docto-orig-cte.cod-estab-relac
               tt-docum-est-transp.cdn-emit-relac           = rat-docto-orig-cte.nf-emitente
               tt-docum-est-transp.cod-natur-operac-relac   = rat-docto-orig-cte.nf-nat-oper 
               tt-docum-est-transp.idi-tip-nf               = 1 //saida
               tt-docum-est-transp.cod-chave-aces-nf-eletro = substring (rat-docto-orig-cte.cod-livre-1,1,50).
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTT-item-doc-est DBOProgram 
PROCEDURE createTT-item-doc-est PRIVATE:
/*------------------------------------------------------------------------------
  Purpose:     Cria a Temp-table tt-item-doc-est
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pi-sequencia   LIKE item-doc-est.sequencia        NO-UNDO.
    DEFINE INPUT PARAM pd-quantidade  LIKE item-doc-est.quantidade       NO-UNDO.
    DEFINE INPUT PARAM pd-preco-total LIKE docum-est.valor-mercad        NO-UNDO.
    DEFINE INPUT PARAM pc-conta       LIKE item-doc-est.ct-codigo        NO-UNDO.
    DEFINE INPUT PARAM pc-ccusto      LIKE item-doc-est.sc-codigo        NO-UNDO.
    DEFINE INPUT PARAM pc-unid-negoc  LIKE item-doc-est.cod-unid-negoc   NO-UNDO.

    FIND FIRST item-docto-orig-cte NO-LOCK
         WHERE item-docto-orig-cte.cod-aces-comp-nfe = bf{&TableName}.cod-aces-comp-nfe
           AND item-docto-orig-cte.idi-orig-trad     = 2 NO-ERROR.
    IF AVAIL item-docto-orig-cte THEN DO:

        CREATE tt-item-doc-est.
        ASSIGN tt-item-doc-est.cod-emitente   = item-docto-orig-cte.cod-emitente
               tt-item-doc-est.nat-operacao   = item-docto-orig-cte.nat-operacao
               tt-item-doc-est.nro-docto      = item-docto-orig-cte.nro-docto
               tt-item-doc-est.serie-docto    = item-docto-orig-cte.serie-docto
               tt-item-doc-est.it-codigo      = item-docto-orig-cte.it-codigo
               tt-item-doc-est.nat-of         = item-docto-orig-cte.nat-operacao
               tt-item-doc-est.preco-total[1] = pd-preco-total
               tt-item-doc-est.quantidade     = pd-quantidade
               tt-item-doc-est.sequencia      = pi-sequencia
               tt-item-doc-est.narrativa      = bf{&TableName}.cod-livre-2  /* Narrativa do item CT-e*/
               tt-item-doc-est.cd-trib-icm    = 0
               tt-item-doc-est.cd-trib-ipi    = 0
               tt-item-doc-est.num-pedido     = item-docto-orig-cte.num-pedido
               tt-item-doc-est.numero-ordem   = item-docto-orig-cte.numero-ordem
               tt-item-doc-est.int-1          = item-docto-orig-cte.num-seq-event /* Evento */
               tt-item-doc-est.parcela        = item-docto-orig-cte.num-parcela
               tt-item-doc-est.encerra-pa     = item-docto-orig-cte.log-encerra-pa
               tt-item-doc-est.ct-codigo      = pc-conta
               tt-item-doc-est.sc-codigo      = pc-ccusto
               tt-item-doc-est.cod-unid-negoc = pc-unid-negoc
        OVERLAY(tt-item-doc-est.char-2,819,13) = SUBSTRING(tt-docum-est.char-2,153,13).
            
        /* Desaloca o saldo da OC */
        IF  item-docto-orig-cte.num-parcela <> 0 THEN DO:
            IF  NOT VALID-HANDLE(h-boin356) THEN
                RUN inbo/boin356.p PERSISTEN SET h-boin356.

            RUN pi-desaloca-ordem-cc IN h-boin356 (INPUT tt-item-doc-est.numero-ordem,
                                                   INPUT tt-item-doc-est.parcela,
                                                   INPUT tt-item-doc-est.quantidade).
        END.

        /* Posiciona a ordem de compra do item para buscar a conta e centro de custo */
        IF item-docto-orig-cte.numero-ordem <> 0 THEN
            FOR FIRST ordem-compra FIELDS (ct-codigo sc-codigo)
                WHERE ordem-compra.numero-ordem = item-docto-orig-cte.numero-ordem NO-LOCK:
                ASSIGN tt-item-doc-est.ct-codigo = ordem-compra.ct-codigo
                       tt-item-doc-est.sc-codigo = ordem-compra.sc-codigo.
            END.

        IF NOT AVAIL ordem-compra AND tt-item-doc-est.ct-codigo = "":U THEN DO:
            /* Posiciona o item para buscar a conta de aplica‡Æo, caso nÆo tenha encontrado na ordem */
            FOR FIRST item FIELDS (ct-codigo sc-codigo)
                WHERE item.it-codigo = item-docto-orig-cte.it-codigo NO-LOCK:

                IF  tt-item-doc-est.ct-codigo = "" THEN
                    ASSIGN tt-item-doc-est.ct-codigo = item.ct-codigo
                           tt-item-doc-est.sc-codigo = item.sc-codigo.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTT-item-doc-est-rateio-despesas DBOProgram 
PROCEDURE createTT-item-doc-est-rateio-despesas PRIVATE:
/*------------------------------------------------------------------------------
  Purpose:     Cria a Temp-table tt-item-doc-est com base no rateio de despesas, um item para cada rat-despes-cte
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR lb-rat-desp AS CHAR NO-UNDO.
    {utp/ut-liter.i "Rateio_despesas"}
    ASSIGN lb-rat-desp = '[':U + RETURN-VALUE + '] ':U.

    RUN setConstraintDocumento (INPUT bf{&TableName}.cod-aces-comp-nfe,
                                INPUT 2).
    RUN openQueryStatic ("Documento":U).
    RUN repositionRecord (INPUT ROWID(bf{&TableName})).

    EMPTY TEMP-TABLE tt-rat-despes-cte.
    FOR EACH rat-despes-cte NO-LOCK
       WHERE rat-despes-cte.cod-aces-comp-nfe = bf{&TableName}.cod-aces-comp-nfe:
        CREATE tt-rat-despes-cte.
        BUFFER-COPY rat-despes-cte TO tt-rat-despes-cte.
    END.

    RUN validateRateioDespesa.
    IF RETURN-VALUE = "NOK":U THEN DO:
        FOR EACH RowErrors:
            RUN pi-create-msg-ret-nfe (INPUT bf{&TableName}.cod-aces-comp-nfe, 
                                       INPUT RowErrors.ErrorNumber, 
                                       INPUT lb-rat-desp + RowErrors.ErrorDescription + ' - ':U + RowErrors.ErrorHelp, 
                                       INPUT 0).
        END.
        EMPTY TEMP-TABLE RowErrors.
        RETURN "NOK":U.
    END.

    FOR EACH rat-despes-cte NO-LOCK
       WHERE rat-despes-cte.cod-aces-comp-nfe = bf{&TableName}.cod-aces-comp-nfe:

        RUN createTT-item-doc-est (INPUT rat-despes-cte.num-seq,          //Sequencia
                                   INPUT 1,                               //Quantidade
                                   INPUT rat-despes-cte.val-rateio,       //Preco total
                                   INPUT rat-despes-cte.ct-codigo,        //Conta
                                   INPUT rat-despes-cte.sc-codigo,        //Centro custo
                                   INPUT rat-despes-cte.cod-unid-negoc).  //Unidade negocio
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inativarMensagensDocto DBOProgram 
PROCEDURE inativarMensagensDocto :
/*------------------------------------------------------------------------------
  Purpose:     Inativar as mensagens do documento
  Parameters:  chave de acesso da nota
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-chaveAcessoCte   AS CHAR      NO-UNDO.

    FOR EACH msg-ret-nfe EXCLUSIVE-LOCK
       WHERE msg-ret-nfe.ch-acesso-comp-nfe = c-chaveAcessoCte
         AND msg-ret-nfe.idi-orig-trad      = 2
         AND msg-ret-nfe.log-ativo:
        ASSIGN msg-ret-nfe.log-ativo = NO.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validacaoParametrosConversor DBOProgram 
PROCEDURE validacaoParametrosConversor:
/*------------------------------------------------------------------------------
  Purpose:     Valida se os parametros do conversor existem
------------------------------------------------------------------------------*/

    IF AVAIL param-convrsr-nfe THEN
        RETURN "OK":U.

    FIND FIRST param-convrsr-nfe NO-LOCK NO-ERROR.
    IF NOT AVAIL param-convrsr-nfe THEN DO:
        {utp/ut-liter.i Parametros_conversor_NF-e *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U 
                                    &ErrorParameters="RETURN-VALUE"}
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
