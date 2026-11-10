&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T-----------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/
{include/i-prgvrs.i BOIN874 2.00.00.049 } /*** "010049" 25/09/2026 17:15:56 ***/

/* ***************************  Definitions  ***************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN874
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName docto-orig-nfse
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
{inbo/boin874.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bfmsg-ret-nfe  FOR msg-ret-nfe.

DEFINE TEMP-TABLE tt-docto-orig-nfse-aux NO-UNDO LIKE docto-orig-nfse
       FIELD r-rowid AS ROWID.

DEF TEMP-TABLE tt-docto-orig-nfse NO-UNDO LIKE docto-orig-nfse.
/*--- Definiá‰es padr‰es para o programa reapi316b ---*/
{inbo/boin090.i tt-docum-est}       
{inbo/boin366.i tt-rat-docum}
{inbo/boin176.i tt-item-doc-est}    
{inbo/boin092.i tt-dupli-apagar}    
{inbo/boin567.i tt-dupli-imp}       
{dibo/bodi515.i tt-nota-fisc-adc}   

{cdp/cd9700.i} /* definiá∆o de vari†veis utilizadas pela cd9700.i1 */
{cdp/cd9590.i} /*Verifica se a funcao EMS2-UNIDADE-NEGOCIO esta definida*/
DEF TEMP-TABLE tt-erro-aux NO-UNDO
    FIELD i-sequen AS INT
    FIELD cd-erro  AS INT
    FIELD mensagem AS CHAR FORMAT "x(255)".

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD identif-segment AS CHAR
    FIELD cd-erro         AS INTEGER
    FIELD desc-erro       AS CHAR FORMAT "x(80)".   

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren  LIKE usuar_mestre.cod_usuar NO-UNDO. 
DEF NEW GLOBAL SHARED VAR c-seg-usuario       AS   CHAR                   NO-UNDO.
DEF NEW GLOBAL SHARED VAR i-ep-codigo-usuario AS   CHARACTER              NO-UNDO.

DEF VAR h-boin356     AS HANDLE    NO-UNDO.
DEF VAR h-boin567     AS HANDLE    NO-UNDO.
DEF VAR c-parcela-imp AS CHARACTER NO-UNDO.

DEF VAR i-cod-emitente LIKE docto-orig-nfse.cod-emitente         NO-UNDO.
DEF VAR c-serie-docto  LIKE docto-orig-nfse.nro-docto           NO-UNDO.
DEF VAR c-nro-docto    LIKE docto-orig-nfse.nro-docto           NO-UNDO.
DEF VAR d-dt-emissao   LIKE docto-orig-nfse.dt-emissao          NO-UNDO. 
DEF VAR c-cod-estabel  LIKE docum-est.cod-estabel               NO-UNDO.
DEF VAR ch-acesso      LIKE docto-orig-nfse.cod-chave-aces-nfse NO-UNDO.

DEF var c-chave-acesso     LIKE docto-orig-nfse.cod-chave-aces-nfse NO-UNDO.
DEF var i-idi-origem       LIKE docto-orig-nfse.idi-orig-trad       NO-UNDO.
DEF VAR i-idi-situacao-ini LIKE docto-orig-nfse.idi-situacao        NO-UNDO.
DEF VAR i-idi-situacao-fin LIKE docto-orig-nfse.idi-situacao        NO-UNDO.

DEF VAR tg-todos             AS LOG                            NO-UNDO.
DEF VAR tg-digitada          AS LOG                            NO-UNDO.
DEF VAR tg-erro-neg          AS LOG                            NO-UNDO.
DEF VAR tg-atualizada        AS LOG                            NO-UNDO.
DEF VAR tg-eliminada         AS LOG                            NO-UNDO.
DEF VAR tg-cancelada         AS LOG                            NO-UNDO.
DEF VAR tg-inutilizada       AS LOG                            NO-UNDO.
DEF VAR tg-validacao         AS LOG                            NO-UNDO.
DEF VAR c-cod-emitente-ini   LIKE emitente.cod-emitente        NO-UNDO.
DEF VAR c-cod-emitente-fim   LIKE emitente.cod-emitente        NO-UNDO.
DEF VAR c-cod-estabel-ini    LIKE docum-est.cod-estabel        NO-UNDO.
DEF VAR c-cod-estabel-fim    LIKE docum-est.cod-estabel        NO-UNDO.
DEF VAR c-serie-ini          LIKE docum-est.serie-docto        NO-UNDO.
DEF VAR c-serie-fim          LIKE docum-est.serie-docto        NO-UNDO.
DEF VAR c-nro-docto-ini      LIKE docum-est.nro-docto          NO-UNDO.
DEF VAR c-nro-docto-fim      LIKE docum-est.nro-docto          NO-UNDO.
DEF VAR dt-emissao-ini       LIKE docum-est.dt-emissao         NO-UNDO.
DEF VAR dt-emissao-fim       LIKE docum-est.dt-emissao         NO-UNDO.
DEF VAR c-msg                AS CHARACTER   NO-UNDO.
DEF VAR i-num-ordem-old      LIKE docto-orig-nfse.numero-ordem NO-UNDO.
DEF VAR i-num-parcela-old    LIKE docto-orig-nfse.num-parcela  NO-UNDO.
DEF VAR i-empresa            LIKE empresa.ep-codigo            NO-UNDO.
DEF VAR l-receb-unid-negoc   AS LOGICAL                        NO-UNDO.
DEF VAR c-origem-save        AS CHARACTER    INIT "RE0122":U   NO-UNDO.
DEF VAR h_api_cta_ctbl       AS HANDLE                         NO-UNDO.
DEF VAR h_api_ccusto         AS HANDLE                         NO-UNDO.
DEF VAR h-cdapi024           AS HANDLE                         NO-UNDO.

/* Vari†veis conta ctbl */
def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.
/* Vari†veis centro de custo */ 
def var v_cod_ccusto         as char   no-undo.
def var v_titulo_ccusto      as char   no-undo.
def var v_log_utz_ccusto     as log    no-undo.

def temp-table tt_log_erro no-undo
         field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Numero" column-label "Numero"
         field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
         field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistencia".

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
         HEIGHT             = 8.04
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

FIND FIRST param-re 
    WHERE param-re.usuario = v_cod_usuar_corren NO-LOCK NO-ERROR.
FIND FIRST param-global NO-LOCK NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaSituacao DBOProgram 
PROCEDURE atualizaSituacao :
/*------------------------------------------------------------------------------
  Purpose:  
  Atualiza a situaá∆o do Documento Origem Nota Entrada para a situaá∆o passada como parÉmetro.

  Parameters:   c-chave-acesso: Chave da NFS-e
                i-situacao    : Situaá∆o para qual o documento serˇ atualizado
  
  Notes: S¢ atualiza o documento se a Origem do mesmo for Traduzido (2)    
  
  Situaá‰es Poss°veis: 
    1 Œ Digitada Receb. Fiscal
    2 Œ Erro
    3 - Atualizada Receb. Fiscal
    4 - Eliminada Receb. Fiscal
    5 - Cancelada
    6 - Digitada Recebimento Fisico (Nao utilizada para NFSE)
    7 - Atualizada Recebimento Fisico (Nao utilizada para NFSE)
    8 - Inutilizada
    9 - Em Validaá∆o   

------------------------------------------------------------------------------*/       
    DEF INPUT PARAM c-chave-acesso LIKE docto-orig-nfse.cod-chave-aces-nfse NO-UNDO.    
    DEF INPUT PARAM i-situacao     AS INTEGER                       NO-UNDO.
      
    FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
         WHERE bf{&TableName}.cod-chave-aces-nfse = c-chave-acesso
           AND bf{&TableName}.idi-orig-trad = 2 NO-ERROR.

    IF AVAIL bf{&TableName} THEN
        ASSIGN bf{&TableName}.idi-situacao = i-situacao.

    RELEASE bf{&TableName}.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaSituacaoPeloDocumento DBOProgram 
PROCEDURE atualizaSituacaoPeloDocumento :
/*------------------------------------------------------------------------------
  Purpose:  
  Atualiza a situaá∆o do Documento Origem Nota Entrada para a situaá∆o passada como parÉmetro.

  Parameters:   c-chave-acesso: Chave da NFS-e
                i-situacao    : Situaá∆o para qual o documento serˇ atualizado
  
  Notes: S¢ atualiza o documento se a Origem do mesmo for Traduzido (2)    
  
  Situaá‰es Poss°veis: 
    1 - Digitada Receb. Fiscal
    2 - Erro
    3 - Atualizada Receb. Fiscal
    4 - Eliminada Receb. Fiscal
    5 - Cancelada
    6 - Digitada Recebimento Fisico (Nao utilizada para NFSE)
    7 - Atualizada Recebimento Fisico (Nao utilizada para NFSE)
    8 - Inutilizada
    9 - Em Validaá∆o   

------------------------------------------------------------------------------*/   
    DEF INPUT PARAM i-cod-emitente LIKE {&TableName}.cod-emitente NO-UNDO.
    DEF INPUT PARAM c-nro-docto    LIKE {&TableName}.nro-docto    NO-UNDO.
    DEF INPUT PARAM c-serie-docto  LIKE {&TableName}.serie-docto  NO-UNDO.
    DEF INPUT PARAM d-dt-emissao   LIKE {&TableName}.dt-emissao   NO-UNDO.
    DEF INPUT PARAM i-situacao     AS INTEGER                     NO-UNDO.

    DEF VAR c-chave-acesso-nfse AS CHAR NO-UNDO.

    FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
         WHERE bf{&TableName}.cod-emitente = i-cod-emitente
           AND bf{&TableName}.nro-docto    = c-nro-docto   
           AND bf{&TableName}.serie-docto  = c-serie-docto 
           AND bf{&TableName}.dt-emissao   = d-dt-emissao
           AND bf{&TableName}.idi-orig-trad = 2 NO-ERROR.

    IF NOT AVAIL bf{&TableName} THEN
        RETURN "NOK":U.
        
    ASSIGN bf{&TableName}.idi-situacao = i-situacao
           c-chave-acesso-nfse         = bf{&TableName}.cod-chave-aces-nfse.

    IF bf{&TableName}.idi-situacao = 4 /* Eliminada Recebimento */ THEN DO:                
        /** Realoca o saldo para manter a ordem e o pedido no conversor.  **/
        IF bf{&TableName}.numero-ordem <> 0 THEN DO:
            RUN validaContratoOrdem (INPUT bf{&TableName}.numero-ordem).
            IF RETURN-VALUE = "OK":U THEN DO:
                /* BO prazo-compra */
                RUN inbo/boin356.p PERSISTENT SET h-boin356.
                RUN aloca-ordem-cc IN h-boin356 (INPUT bf{&TableName}.numero-ordem,
                                                 INPUT-OUTPUT bf{&TableName}.num-parcela,
                                                 INPUT 1).
                DELETE PROCEDURE h-boin356.
                ASSIGN h-boin356 = ?.
            END.
        END.

        /* Evento Cancelamento */
        FOR FIRST event-nfe-cte FIELDS(idi-sit-event) EXCLUSIVE-LOCK
            WHERE event-nfe-cte.idi-sit-event   = 1  /* Pendente */
              AND event-nfe-cte.idi-tip-docto   = 3  /* NFS-e */ 
              AND event-nfe-cte.idi-tip-event   = 1  /* CANCELAMENTO */
              AND event-nfe-cte.nro-docto       = bf{&TableName}.nro-docto
              AND event-nfe-cte.cod-livre-1     = bf{&TableName}.cod-cnpj-prestdor:

            RUN cancelaDocumento(INPUT ROWID(bf{&TableName}), ?).
            IF RETURN-VALUE = "OK":U THEN DO:
                ASSIGN event-nfe-cte.idi-sit-event = 2. /* processado */
            
                {utp/ut-liter.i NFS-e_foi_cancelada *}
                RUN utp/ut-msgs.p ("msg":U, 54213, RETURN-VALUE).
                RUN pi-create-msg-ret-nfe (c-chave-acesso-nfse, 54213, RETURN-VALUE, 4).
            END.
        END.
        RELEASE event-nfe-cte.
        RELEASE bf{&TableName}.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* BO prazo-compra */
    RUN inbo/boin356.p PERSISTENT SET h-boin356.

    FOR FIRST bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-chave-aces-nfse = RowObject.cod-chave-aces-nfse
          AND bf{&TableName}.idi-orig-trad       = RowObject.idi-orig-trad: 

        IF bf{&TableName}.numero-ordem > 0 THEN DO: //DESALOCA
            RUN validaContratoOrdem (INPUT bf{&TableName}.numero-ordem).       
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN pi-desaloca-ordem-cc IN h-boin356 (INPUT bf{&TableName}.numero-ordem,
                                                       INPUT bf{&TableName}.num-parcela,
                                                       INPUT 1).
            END.
        END.

        IF RowObject.numero-ordem > 0 THEN DO: //ALOCA
            RUN validaContratoOrdem (INPUT RowObject.numero-ordem).       
            IF RETURN-VALUE = "OK":U THEN DO:                
                RUN aloca-ordem-cc IN h-boin356 (INPUT RowObject.numero-ordem,
                                                 INPUT-OUTPUT RowObject.num-parcela,
                                                 INPUT 1).
            END.
        END.
    END.

    RETURN "OK":U.
    FINALLY:
        /* BO Prazo-compra */
        DELETE PROCEDURE h-boin356 NO-ERROR.
        ASSIGN h-boin356 = ?.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord:
    DEFINE VAR cCtCodigo     LIKE docto-orig-nfse.ct-codigo      NO-UNDO.
    DEFINE VAR cScCodigo     LIKE docto-orig-nfse.sc-codigo      NO-UNDO.
    DEFINE VAR cCodUnidNegoc LIKE docto-orig-nfse.cod-unid-negoc NO-UNDO.
    
    IF c-origem-save = 'RE0122':U THEN DO:
        RUN sugereContaECentroCusto (INPUT  RowObject.numero-ordem,
                                     INPUT  RowObject.cod-item-serv,
                                     OUTPUT cCtCodigo,
                                     OUTPUT cScCodigo).
                                                       
        RUN sugereUnidNegoc          (INPUT  TRIM(SUBSTRING(RowObject.cod-livre-2,1,5)),  //Estabelecimento
                                      INPUT  RowObject.numero-ordem,
                                      INPUT  cCtCodigo,
                                      INPUT  RowObject.cod-item-serv,
                                      OUTPUT cCodUnidNegoc).
                                      
        FIND FIRST docto-orig-nfse EXCLUSIVE-LOCK
             WHERE docto-orig-nfse.cod-chave-aces-nfse = RowObject.cod-chave-aces-nfse
             AND   docto-orig-nfse.idi-orig-trad = 2 NO-ERROR.                                     
        IF AVAIL docto-orig-nfse THEN DO:
            ASSIGN docto-orig-nfse.ct-codigo      = cCtCodigo
                   docto-orig-nfse.sc-codigo      = cScCodigo
                   docto-orig-nfse.cod-unid-negoc = cCodUnidNegoc.
        END.
        FIND CURRENT docto-orig-nfse NO-LOCK NO-ERROR.                                     
    END.   
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelaDocumento DBOProgram 
PROCEDURE cancelaDocumento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pr-nota             AS ROWID    NO-UNDO.
    DEFINE INPUT  PARAMETER p-motivo-cancela    AS CHAR     NO-UNDO.

    FOR FIRST bf{&TableName} FIELDS (cod-chave-aces-nfse nro-docto)
        WHERE ROWID(bf{&TableName}) = pr-nota NO-LOCK:
    END.

    IF AVAIL bf{&TableName} THEN DO:

        /** CRIA MENSAGEM NOTIFICANDO QUE A NF FOI CANCELADA **/
        FOR EACH msg-ret-nfe FIELDS (seq-msg) NO-LOCK
           WHERE msg-ret-nfe.ch-acesso-comp-nfe = bf{&TableName}.cod-chave-aces-nfse
             AND msg-ret-nfe.idi-orig-trad      = 2:

            FOR FIRST bfmsg-ret-nfe EXCLUSIVE-LOCK
                WHERE bfmsg-ret-nfe.seq-msg    = msg-ret-nfe.seq-msg:
                ASSIGN bfmsg-ret-nfe.log-ativo = NO.
            END.
            RELEASE bfmsg-ret-nfe.
        END.

        RUN utp/ut-msgs.p (INPUT "MSG":U,
                           INPUT 19531,
                           INPUT "" + "~~" + "" + "~~" + bf{&TableName}.nro-docto).    
        RUN pi-create-msg-ret-nfe (bf{&TableName}.cod-chave-aces-nfse, 19531, RETURN-VALUE, 0).

        IF p-motivo-cancela <> ? AND TRIM(p-motivo-cancela) <> "" THEN
            RUN pi-create-msg-ret-nfe (bf{&TableName}.cod-chave-aces-nfse, 57446, p-motivo-cancela, 0).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerarNotaEntrada DBOProgram 
PROCEDURE gerarNotaEntrada :
/*------------------------------------------------------------------------------
  Purpose:     Essa BO Ç utilizada para efetivar os registros do conversor em notas de entrada
                   que podem ser visualizadas pelo RE1001. 
  Parameters:  pr-nota -> ROWID nota a ser processada
               l-ok    -> Indica se o processamento da nota ocorreu com sucesso
  Notes:       
------------------------------------------------------------------------------*/

    {inbo/boin874.m1}

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
    DEFINE INPUT  PARAMETER c-codChaveAcessoNFse   AS CHAR             NO-UNDO.
    DEFINE OUTPUT PARAMETER l-docGerado        AS LOGICAL  INIT NO NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE iCodMsg AS INTEGER     NO-UNDO.
    /*Verifica se est† em processamento e se a situaá∆o da nota permite gerar o documento no fiscal*/
    RUN validacoesGeracao (INPUT c-codChaveAcessoNFse).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN RETURN-VALUE.

    /* Coloca em 'processamento' */
    RUN setProcessamento (INPUT c-codChaveAcessoNFse, INPUT TRUE).

    RUN gerarNotaEntrada (INPUT rowid(docto-orig-nfse),
                          OUTPUT l-docGerado).

    RUN ativarMensagensDocto (INPUT c-codChaveAcessoNFse,
                              INPUT iCodMsg).
    /* Retira do 'em processamento' */
    RUN setProcessamento (INPUT c-codChaveAcessoNFse, INPUT FALSE).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE engineRegras DBOProgram 
PROCEDURE engineRegras:
    DEFINE INPUT  PARAMETER c-codChaveAcessoNFse   AS CHAR   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
       
    DEFINE VARIABLE c-situacao-txt AS CHARACTER   NO-UNDO.

    FIND FIRST bf{&TableName} 
         WHERE bf{&TableName}.cod-chave-aces-nfse = c-codChaveAcessoNFse
         AND bf{&TableName}.idi-orig-trad      = 2 NO-LOCK NO-ERROR.

    IF NOT AVAIL bf{&TableName} THEN
        RETURN "NOK":U.

    IF bf{&TableName}.idi-situacao  = 2           /* 2 - Erro de NegΩcio. */
    OR bf{&TableName}.idi-situacao  = 4           /* 4 - Eliminada.       */
    OR bf{&TableName}.idi-situacao  = 5 THEN DO:  /* 5 - Cancelada.       */
        
        EMPTY TEMP-TABLE tt-docto-orig-nfse.
        CREATE tt-docto-orig-nfse.
        BUFFER-COPY bf{&TableName} TO tt-docto-orig-nfse.

        RUN rep/reapi328.p (INPUT TABLE tt-docto-orig-nfse,
                             INPUT "todos":U).
         
        IF RETURN-VALUE = "OK":U THEN DO:
           {utp/ut-liter.i "Regras_aplicadas"}
           {method/svc/errors/inserr.i &ErrorNumber="32388" /*&1 com sucesso*/
                                       &ErrorType="EMS":U
                                       &ErrorSubType="INFORMATION":U
                                       &ErrorParameters="RETURN-VALUE"}
        END.
    END.
    ELSE DO:
        assign c-situacao-txt = {ininc/i01in847.i 04 bf{&TableName}.idi-situacao}.
        {method/svc/errors/inserr.i &ErrorNumber="57052"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U 
                                    &ErrorParameters="c-situacao-txt"}
        RETURN "NOK":U.

    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaNfseApi DBOProgram 
PROCEDURE eliminaNfseApi :
/*------------------------------------------------------------------------------
  Purpose: Elimina o documento NFS-e   
  Parameters:  pr-nota: Rowid da nota a ser cancelada
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-codChaveAcessoNFse   AS CHAR             NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE c-sit-txt   AS CHARACTER   NO-UNDO.

    RUN verificaEmProcessamento (INPUT c-codChaveAcessoNFse). /* Verifica se ja esta em processamento */
    IF RETURN-VALUE = "NOK":U THEN /* documento ja esta em processamento ou nao esta avail */
        RETURN RETURN-VALUE.

    IF  {&TableName}.idi-situacao <> 9 AND
        {&TableName}.idi-situacao <> 5 AND
        {&TableName}.idi-situacao <> 8 THEN DO:

        ASSIGN c-sit-txt = {ininc/i01in847.i 04 {&TableName}.idi-situacao}.
        {method/svc/errors/inserr.i &ErrorNumber="57054"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U 
                                    &ErrorParameters="c-sit-txt"}
        RETURN "NOK":U.
    END.

    RUN EliminaNFse (INPUT {&TableName}.cod-chave-aces-nfse).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN RETURN-VALUE.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelaNfseApi DBOProgram 
PROCEDURE cancelaNfseApi :
/*------------------------------------------------------------------------------
  Purpose: Cancela o documento    
  Parameters:  pr-nota: Rowid da nota a ser cancelada
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-codChaveAcessoNFse   AS CHAR             NO-UNDO.
    DEFINE INPUT  PARAMETER c-motivoCancela        AS CHAR             NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE c-sit-txt   AS CHARACTER   NO-UNDO.

    RUN verificaEmProcessamento (INPUT c-codChaveAcessoNFse). /* Verifica se ja esta em processamento */
    IF RETURN-VALUE = "NOK":U THEN /* documento ja esta em processamento ou nao esta avail */
        RETURN RETURN-VALUE.

    IF  {&TableName}.idi-situacao <> 2 AND
        {&TableName}.idi-situacao <> 4 THEN DO:
        ASSIGN c-sit-txt = {ininc/i01in847.i 04 {&TableName}.idi-situacao}.
        {method/svc/errors/inserr.i &ErrorNumber="57050"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U 
                                    &ErrorParameters="c-sit-txt"}
        RETURN "NOK":U.
    END.

    RUN setProcessamento (INPUT c-codChaveAcessoNFse, INPUT TRUE).

    RUN cancelaDocumento(INPUT ROWID({&TableName}),
                         INPUT c-motivoCancela).  
    IF RETURN-VALUE = "OK":U THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="19531"
                                    &ErrorType="EMS"
                                    &ErrorSubType="INFORMATION"
                                    &ErrorParameters="TRIM(SUBSTRING(docto-orig-nfse.cod-livre-2,1,5)) + '~~~~' + docto-orig-nfse.serie-docto + '~~~~' + docto-orig-nfse.nro-docto" }

    END.

    /* Retira do 'em processamento' */
    RUN setProcessamento (INPUT c-codChaveAcessoNFse, INPUT FALSE).

    RETURN "OK":U.

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
    DEFINE INPUT  PARAMETER c-codChaveAcessoNFse   AS CHAR             NO-UNDO.
    DEF VAR c-sit-txt AS CHAR NO-UNDO.

    FIND param-convrsr-nfe NO-LOCK NO-ERROR.
    IF NOT AVAIL param-convrsr-nfe THEN DO:
        {utp/ut-liter.i Parametros_conversor_NF-e *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U 
                                    &ErrorParameters="RETURN-VALUE"}
        RETURN "NOK":U.
    END.

    RUN verificaEmProcessamento (INPUT c-codChaveAcessoNFse). /* Verifica se ja esta em processamento */
    IF RETURN-VALUE = "NOK":U THEN /* documento ja esta em processamento ou nao esta avail */
        RETURN RETURN-VALUE.

    /* valida situacoes que nao pode ser executada a geracao */
    IF CAN-DO("1,3,5,8,9", STRING(docto-orig-nfse.idi-situacao)) THEN DO:
        IF (docto-orig-nfse.idi-situacao = 5 /* Cancelada */ AND param-convrsr-nfe.log-bloq-nfe-cancda) OR 
            docto-orig-nfse.idi-situacao <> 5 THEN DO:

            assign c-sit-txt = {ininc/i01in847.i 04 docto-orig-nfse.idi-situacao}.
            {method/svc/errors/inserr.i &ErrorNumber="57040"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U 
                                        &ErrorParameters="c-sit-txt"}
            RETURN "NOK":U.
        END.
    END.
    
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
    DEFINE INPUT PARAMETER c-codChaveAcessoNFse   AS CHAR   NO-UNDO.

    FIND FIRST docto-orig-nfse
         WHERE docto-orig-nfse.cod-chave-aces-nfse = c-codChaveAcessoNFse
           AND docto-orig-nfse.idi-orig-trad       = 2 NO-LOCK NO-ERROR.
                                
    IF NOT AVAIL  docto-orig-nfse THEN DO:
        {utp/ut-liter.i Documento_XML_NFS-e *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U 
                                    &ErrorParameters="RETURN-VALUE + '~~~~' + c-codChaveAcessoNFse"}
        RETURN "NOK":U.
    END.

    IF  docto-orig-nfse.log-procmto THEN DO:
        IF INTERVAL (NOW, DATETIME(STRING(docto-orig-nfse.dat-process) + " " + docto-orig-nfse.hra-proces), "minutes":U) > 15 THEN // Ja faz mais de 15 minutos que esta em processamento
           RETURN "OK":U. // libera para que seja reprocessado 

        {method/svc/errors/inserr.i &ErrorNumber="57093"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U 
                                    &ErrorParameters="docto-orig-nfse.nro-docto + '~~~~' + docto-orig-nfse.cod-usuar-proces + '~~~~' + string(docto-orig-nfse.dat-process) + ' ' + docto-orig-nfse.hra-proces"}
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
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
    DEFINE INPUT  PARAMETER c-codChaveAcessoNFse   AS CHAR             NO-UNDO.
    DEFINE INPUT  PARAMETER l-processamento    AS LOG              NO-UNDO.

    FIND FIRST docto-orig-nfse
         WHERE docto-orig-nfse.cod-chave-aces-nfse = c-codChaveAcessoNFse
           AND docto-orig-nfse.idi-orig-trad      = 2 EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAIL docto-orig-nfse THEN
        RETURN "NOK":U.

    ASSIGN docto-orig-nfse.log-procmto      = l-processamento
           docto-orig-nfse.cod-usuar-proces = c-seg-usuario
           docto-orig-nfse.dat-process      = TODAY
           docto-orig-nfse.hra-proces       = STRING(TIME,"HH:MM:SS").

    FIND CURRENT docto-orig-nfse NO-LOCK NO-ERROR. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ativarMensagensDocto DBOProgram 
PROCEDURE ativarMensagensDocto PRIVATE:
    DEFINE INPUT PARAMETER c-codChaveAcessoNFse AS CHAR    NO-UNDO.
    DEFINE INPUT PARAMETER pCodMsg         AS INTEGER NO-UNDO.
    
    IF pCodMsg <> 0 THEN DO:
       
       FOR LAST msg-ret-nfe EXCLUSIVE-LOCK
           WHERE msg-ret-nfe.ch-acesso-comp-nfe = c-codChaveAcessoNFse
           AND   msg-ret-nfe.idi-orig-trad      = 2
           AND   msg-ret-nfe.cd-msg             = pCodMsg:
           ASSIGN msg-ret-nfe.log-ativo = YES. /* Atualiza para ativa a msg criada jˇ criada na BO */
       END.
       RELEASE msg-ret-nfe.
    END.
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setOrigemSave DBOProgram 
PROCEDURE setOrigemSave :
/*------------------------------------------------------------------------------
  Purpose: Seta se a origem do save Ç APIREST por exemplo para salvar os lotes
  Parameters:
  Por padrao fica o c-origem-save como RE0118A
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-origem-save AS CHAR NO-UNDO.

    ASSIGN c-origem-save = p-origem-save.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE contaUtilizaCC DBOProgram 
PROCEDURE contaUtilizaCC :
/*------------------------------------------------------------------------------
  Purpose: Retorna se a conta utiliza ou n∆o centro de custo
  Parameters: 
  
  Notes:   RowErrors com os erros do EMS5 caso houver inconsistencia
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-ch-acesso LIKE docto-orig-nfse.cod-chave-aces-nfse NO-UNDO.
    DEF INPUT  PARAM p-ct-codigo LIKE docto-orig-nfse.ct-codigo NO-UNDO.
    DEF OUTPUT PARAM p-l-utiliz  AS LOG INIT NO NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR RowErrors.

    EMPTY TEMP-TABLE tt_log_erro.

    
    FIND FIRST docto-orig-nfse NO-LOCK
         WHERE docto-orig-nfse.cod-chave-aces-nfse= p-ch-acesso
         AND   docto-orig-nfse.idi-orig-trad      = 2 NO-ERROR.
    
    IF  AVAIL docto-orig-nfse 
    AND TRIM(SUBSTRING(docto-orig-nfse.cod-livre-2,1,5)) <> "" THEN DO:
    
        IF NOT VALID-HANDLE(h_api_ccusto) 
         OR h_api_ccusto:type      <> "PROCEDURE":U 
         OR h_api_ccusto:file-name <> "prgint/utb/utb742za.py":U then
            run prgint/utb/utb742za.py persistent set h_api_ccusto.

        RUN findEmpresa (INPUT docto-orig-nfse.cod-chave-aces-nfse,
                         OUTPUT i-empresa).

        RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  i-empresa,                     /* EMPRESA EMS 2 */
                                                           INPUT  TRIM(SUBSTRING(docto-orig-nfse.cod-livre-2,1,5)),      /* ESTABELECIMENTO EMS2 */
                                                           INPUT  "",                            /* PLANO CONTAS */
                                                           INPUT  p-ct-codigo,                   /* CONTA */
                                                           INPUT  docto-orig-nfse.dt-transacao,     /* DT TRANSACAO */
                                                           OUTPUT p-l-utiliz,                    /* UTILIZA CCUSTO ? */
                                                           OUTPUT TABLE tt_log_erro).            /* ERROS */

        for each tt_log_erro: 
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + '~~~~' + tt_log_erro.ttv_des_msg_ajuda"}
        end.
        if can-find(tt_log_erro) then
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableUnidNeg DBOProgram 
PROCEDURE enableUnidNeg :
/*------------------------------------------------------------------------------
  Purpose: Habilitar/Desabilitar Unidade de Neg¢cio    
  Parameters: pc-conta-contabil: Conta cont†bil
              l-habilita: Indica se o campo de unidade de Neg¢cio deve ou n∆o ser habilitado
  
  Notes:       
------------------------------------------------------------------------------*/

    def input  param pc-conta-contabil  as char         no-undo. /* SEM FORMATO. */
    def output param l-habilita         as log init no  no-undo.
    
    def var c-conta-aux as char no-undo.
    
    find first param-mat no-lock no-error.
    assign l-mat-unid-negoc = avail param-mat
                              and   param-mat.ind-unid-neg.
    
    find first param-re no-lock 
        where param-re.usuario = c-seg-usuario no-error.
    if  avail param-re then
        assign l-receb-unid-negoc = param-re.log-pedir-unid-negoc.

    /*** Se n∆o utiliza unidade de Neg¢cio, ou o usuario do recebimento nío permite atualizaªío, 
         nío habilita o campo ***/
    if  not l-mat-unid-negoc
    or  not l-receb-unid-negoc then do:
        assign l-habilita = no.
    end.
    else do:
        /* Material permanecerˇ no estoque, nío foi informada a conta -> UNeg nío habilitada.
           Se foi informada a conta, somente habilita se o usuario do receb. permite informar UNeg. */
        if  pc-conta-contabil = "" then do:
            assign l-habilita = no.
        end.
        else do:
            assign l-habilita = l-receb-unid-negoc.
        end.
    end.
    
    return "OK":U.

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
        WHEN "cod-art":U THEN ASSIGN pFieldValue = RowObject.cod-art.
        WHEN "cod-cep-prestdor":U THEN ASSIGN pFieldValue = RowObject.cod-cep-prestdor.
        WHEN "cod-cep-tomador":U THEN ASSIGN pFieldValue = RowObject.cod-cep-tomador.
        WHEN "cod-cfop":U THEN ASSIGN pFieldValue = RowObject.cod-cfop.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-cnpj-interm":U THEN ASSIGN pFieldValue = RowObject.cod-cnpj-interm.
        WHEN "cod-cnpj-prestdor":U THEN ASSIGN pFieldValue = RowObject.cod-cnpj-prestdor.
        WHEN "cod-cnpj-refer":U THEN ASSIGN pFieldValue = RowObject.cod-cnpj-refer.
        WHEN "cod-cnpj-tomador":U THEN ASSIGN pFieldValue = RowObject.cod-cnpj-tomador.
        WHEN "cod-cpf-interm":U THEN ASSIGN pFieldValue = RowObject.cod-cpf-interm.
        WHEN "cod-cpf-refer":U THEN ASSIGN pFieldValue = RowObject.cod-cpf-refer.
        WHEN "cod-cpf-tomador":U THEN ASSIGN pFieldValue = RowObject.cod-cpf-tomador.
        WHEN "cod-deduc":U THEN ASSIGN pFieldValue = RowObject.cod-deduc.
        WHEN "cod-email-prestdor":U THEN ASSIGN pFieldValue = RowObject.cod-email-prestdor.
        WHEN "cod-erp-subst":U THEN ASSIGN pFieldValue = RowObject.cod-erp-subst.
        WHEN "cod-estab":U THEN ASSIGN pFieldValue = TRIM(SUBSTR(RowObject.cod-livre-2,1,5)).
        WHEN "cod-inscr-munic-prestdor":U THEN ASSIGN pFieldValue = RowObject.cod-inscr-munic-prestdor.
        WHEN "cod-inscr-munpio-interm":U THEN ASSIGN pFieldValue = RowObject.cod-inscr-munpio-interm.
        WHEN "cod-item-serv":U THEN ASSIGN pFieldValue = RowObject.cod-item-serv.
        WHEN "cod-chave-aces-nfse":U THEN ASSIGN pFieldValue = RowObject.cod-chave-aces-nfse.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-nf-refer":U THEN ASSIGN pFieldValue = RowObject.cod-nf-refer.
        WHEN "cod-nfse-pref":U THEN ASSIGN pFieldValue = RowObject.cod-nfse-pref.
        WHEN "cod-nfse-subst":U THEN ASSIGN pFieldValue = RowObject.cod-nfse-subst.
        WHEN "cod-num-ender-prestdor":U THEN ASSIGN pFieldValue = RowObject.cod-num-ender-prestdor.
        WHEN "cod-num-tomador":U THEN ASSIGN pFieldValue = RowObject.cod-num-tomador.
        WHEN "cod-obra":U THEN ASSIGN pFieldValue = RowObject.cod-obra.
        WHEN "cod-operac":U THEN ASSIGN pFieldValue = RowObject.cod-operac.
        WHEN "cod-protoc":U THEN ASSIGN pFieldValue = RowObject.cod-protoc.
        WHEN "cod-razao-social-tomador":U THEN ASSIGN pFieldValue = RowObject.cod-razao-social-tomador.
        WHEN "cod-rps-subst":U THEN ASSIGN pFieldValue = RowObject.cod-rps-subst.
        WHEN "cod-ser-prestac":U THEN ASSIGN pFieldValue = RowObject.cod-ser-prestac.
        WHEN "cod-ser-subst":U THEN ASSIGN pFieldValue = RowObject.cod-ser-subst.
        WHEN "cod-telef-prestdor":U THEN ASSIGN pFieldValue = RowObject.cod-telef-prestdor.
        WHEN "cod-telef-tomador":U THEN ASSIGN pFieldValue = RowObject.cod-telef-tomador.
        WHEN "cod-tip-deduc":U THEN ASSIGN pFieldValue = RowObject.cod-tip-deduc.
        WHEN "cod-trib":U THEN ASSIGN pFieldValue = RowObject.cod-trib.
        WHEN "cod-tributac":U THEN ASSIGN pFieldValue = RowObject.cod-tributac.
        WHEN "cod-uf-prestdor":U THEN ASSIGN pFieldValue = RowObject.cod-uf-prestdor.
        WHEN "cod-uf-tomador":U THEN ASSIGN pFieldValue = RowObject.cod-uf-tomador.
        WHEN "cod-un":U THEN ASSIGN pFieldValue = RowObject.cod-un.
        WHEN "cod-verific-nf-serv-eletro":U THEN ASSIGN pFieldValue = RowObject.cod-verific-nf-serv-eletro.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "des-bairro-prestdor":U THEN ASSIGN pFieldValue = RowObject.des-bairro-prestdor.
        WHEN "des-bairro-tomador":U THEN ASSIGN pFieldValue = RowObject.des-bairro-tomador.
        WHEN "des-compl-prestdor":U THEN ASSIGN pFieldValue = RowObject.des-compl-prestdor.
        WHEN "des-compl-tomador":U THEN ASSIGN pFieldValue = RowObject.des-compl-tomador.
        WHEN "des-email-tomador":U THEN ASSIGN pFieldValue = RowObject.des-email-tomador.
        WHEN "des-ender-prestdor":U THEN ASSIGN pFieldValue = RowObject.des-ender-prestdor.
        WHEN "des-ender-tomador":U THEN ASSIGN pFieldValue = RowObject.des-ender-tomador.
        WHEN "des-motivo":U THEN ASSIGN pFieldValue = RowObject.des-motivo.
        WHEN "des-munic-prestdor":U THEN ASSIGN pFieldValue = RowObject.des-munic-prestdor.
        WHEN "des-munpio-tomador":U THEN ASSIGN pFieldValue = RowObject.des-munpio-tomador.
        WHEN "des-narrat":U THEN ASSIGN pFieldValue = RowObject.des-narrat.
        WHEN "des-nom-fantasia-prestdor":U THEN ASSIGN pFieldValue = RowObject.des-nom-fantasia-prestdor.
        WHEN "des-razao-social-interm":U THEN ASSIGN pFieldValue = RowObject.des-razao-social-interm.
        WHEN "des-razao-social-prestdor":U THEN ASSIGN pFieldValue = RowObject.des-razao-social-prestdor.
        WHEN "des-tip-bairro-tomador":U THEN ASSIGN pFieldValue = RowObject.des-tip-bairro-tomador.
        WHEN "des-tip-lograd-tomador":U THEN ASSIGN pFieldValue = RowObject.des-tip-lograd-tomador.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "cod-unid-negoc":U THEN ASSIGN pFieldValue = RowObject.cod-unid-negoc.
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
        WHEN "dat-emis-nfse-subst":U THEN ASSIGN pFieldValue = RowObject.dat-emis-nfse-subst.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dt-emissao":U THEN ASSIGN pFieldValue = RowObject.dt-emissao.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

     CASE pFieldName:
        WHEN "val-aliq-cofins":U THEN ASSIGN pFieldValue = RowObject.val-aliq-cofins.
        WHEN "val-aliq-csll":U THEN ASSIGN pFieldValue = RowObject.val-aliq-csll.
        WHEN "val-aliq-inss":U THEN ASSIGN pFieldValue = RowObject.val-aliq-inss.
        WHEN "val-aliq-ir":U THEN ASSIGN pFieldValue = RowObject.val-aliq-ir.
        WHEN "val-aliq-iss":U THEN ASSIGN pFieldValue = RowObject.val-aliq-iss.
        WHEN "val-aliq-pis":U THEN ASSIGN pFieldValue = RowObject.val-aliq-pis.
        WHEN "val-base-calc":U THEN ASSIGN pFieldValue = RowObject.val-base-calc.
        WHEN "val-base-deduc":U THEN ASSIGN pFieldValue = RowObject.val-base-deduc.
        WHEN "val-cnae":U THEN ASSIGN pFieldValue = RowObject.val-cnae.
        WHEN "val-deduc":U THEN ASSIGN pFieldValue = RowObject.val-deduc.
        WHEN "val-desc-cond":U THEN ASSIGN pFieldValue = RowObject.val-desc-cond.
        WHEN "val-desc-inc":U THEN ASSIGN pFieldValue = RowObject.val-desc-inc.
        WHEN "val-iss":U THEN ASSIGN pFieldValue = RowObject.val-iss.
        WHEN "val-iss-retid":U THEN ASSIGN pFieldValue = RowObject.val-iss-retid.
        WHEN "val-liq":U THEN ASSIGN pFieldValue = RowObject.val-liq.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-outras-retenc":U THEN ASSIGN pFieldValue = RowObject.val-outras-retenc.
        WHEN "val-perc-deduc":U THEN ASSIGN pFieldValue = RowObject.val-perc-deduc.
        WHEN "val-retenc-cofins":U THEN ASSIGN pFieldValue = RowObject.val-retenc-cofins.
        WHEN "val-retenc-csll":U THEN ASSIGN pFieldValue = RowObject.val-retenc-csll.
        WHEN "val-retenc-inss":U THEN ASSIGN pFieldValue = RowObject.val-retenc-inss.
        WHEN "val-retenc-ir":U THEN ASSIGN pFieldValue = RowObject.val-retenc-ir.
        WHEN "val-retenc-pis":U THEN ASSIGN pFieldValue = RowObject.val-retenc-pis.
        WHEN "val-servico":U THEN ASSIGN pFieldValue = RowObject.val-servico.
        WHEN "val-tot-refer":U THEN ASSIGN pFieldValue = RowObject.val-tot-refer.
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
        WHEN "cdn-iss-retid":U THEN ASSIGN pFieldValue = RowObject.cdn-iss-retid.
        WHEN "cdn-iss-retid":U THEN ASSIGN pFieldValue = RowObject.cdn-iss-retid.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "idi-incent-cultura":U THEN ASSIGN pFieldValue = RowObject.idi-incent-cultura.
        WHEN "idi-orig-trad":U THEN ASSIGN pFieldValue = RowObject.idi-orig-trad.
        WHEN "idi-regim-especial-tributac":U THEN ASSIGN pFieldValue = RowObject.idi-regim-especial-tributac.
        WHEN "idi-simples-nacion":U THEN ASSIGN pFieldValue = RowObject.idi-simples-nacion.
        WHEN "idi-status-rps":U THEN ASSIGN pFieldValue = RowObject.idi-status-rps.
        WHEN "idi-tip-rps":U THEN ASSIGN pFieldValue = RowObject.idi-tip-rps.
        WHEN "idi-tip-rps-subst":U THEN ASSIGN pFieldValue = RowObject.idi-tip-rps-subst.
        WHEN "idi-situacao":U THEN ASSIGN pFieldValue = RowObject.idi-situacao.
        WHEN "num-cod-munic-tomador":U THEN ASSIGN pFieldValue = RowObject.num-cod-munic-tomador.
        WHEN "num-ddd-tomador":U THEN ASSIGN pFieldValue = RowObject.num-ddd-tomador.
        WHEN "num-evento":U THEN ASSIGN pFieldValue = RowObject.num-evento.
        WHEN "num-ibge-prestdor":U THEN ASSIGN pFieldValue = RowObject.num-ibge-prestdor.
        WHEN "num-inscr-munic-tomador":U THEN ASSIGN pFieldValue = RowObject.num-inscr-munic-tomador.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-munpio-prestac":U THEN ASSIGN pFieldValue = RowObject.num-munpio-prestac.
        WHEN "num-parcela":U THEN ASSIGN pFieldValue = RowObject.num-parcela.
        WHEN "num-pedido":U THEN ASSIGN pFieldValue = RowObject.num-pedido.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice dcto-nfse-chave
  Parameters:  
               retorna valor do campo cod-chave-aces-nfse
               retorna valor do campo idi-orig-trad
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-chave-aces-nfse LIKE docto-orig-nfse.cod-chave-aces-nfse NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-orig-trad LIKE docto-orig-nfse.idi-orig-trad NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-chave-aces-nfse = RowObject.cod-chave-aces-nfse
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        WHEN "log-encerra-pa":U THEN  ASSIGN pFieldValue = RowObject.log-encerra-pa.
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
  Purpose:     Reposiciona registro com base no °ndice dcto-nfse-chave
  Parameters:  
               recebe valor do campo cod-chave-aces-nfse
               recebe valor do campo idi-orig-trad
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-chave-aces-nfse LIKE docto-orig-nfse.cod-chave-aces-nfse NO-UNDO.
    DEFINE INPUT PARAMETER pidi-orig-trad LIKE docto-orig-nfse.idi-orig-trad NO-UNDO.

    FIND FIRST bfdocto-orig-nfse WHERE 
        bfdocto-orig-nfse.cod-chave-aces-nfse = pcod-chave-aces-nfse AND 
        bfdocto-orig-nfse.idi-orig-trad = pidi-orig-trad NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdocto-orig-nfse THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdocto-orig-nfse)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDocumento DBOProgram 
PROCEDURE openQueryDocumento :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query com base na chave do documento e origem    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName}
      FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.cod-chave-aces-nfse = c-chave-acesso
           AND {&TableName}.idi-orig-trad = i-idi-origem INDEXED-REPOSITION.  

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMonitorNFSE DBOProgram 
PROCEDURE openQueryMonitorNFSE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM TABLE FOR tt-docto-orig-nfse-aux.

    EMPTY TEMP-TABLE tt-docto-orig-nfse-aux.

    FOR EACH {&TableName} NO-LOCK 
       WHERE {&TableName}.idi-orig-trad  = 2 /* traduzido */
         AND {&TableName}.cod-emitente  >= c-cod-emitente-ini
         AND {&TableName}.cod-emitente  <= c-cod-emitente-fim
         AND TRIM(SUBSTRING({&TableName}.cod-livre-2,1,5)) >= c-cod-estabel-ini 
         AND TRIM(SUBSTRING({&TableName}.cod-livre-2,1,5)) <= c-cod-estabel-fim 
         AND {&TableName}.serie-docto   >= c-serie-ini       
         AND {&TableName}.serie-docto   <= c-serie-fim       
         AND {&TableName}.nro-docto     >= c-nro-docto-ini   
         AND {&TableName}.nro-docto     <= c-nro-docto-fim   
         AND {&TableName}.dt-emissao    >= dt-emissao-ini    
         AND {&TableName}.dt-emissao    <= dt-emissao-fim    
         AND ( tg-todos OR( ({&TableName}.idi-situacao = 1 AND tg-digitada)
                        OR  ({&TableName}.idi-situacao = 2 AND tg-erro-neg)
                        OR  ({&TableName}.idi-situacao = 3 AND tg-atualizada)
                        OR  ({&TableName}.idi-situacao = 4 AND tg-eliminada)
                        OR  ({&TableName}.idi-situacao = 5 AND tg-cancelada)
                        OR  ({&TableName}.idi-situacao = 8 AND tg-inutilizada)
                        OR  ({&TableName}.idi-situacao = 9 AND tg-validacao))):

        CREATE tt-docto-orig-nfse-aux.
        BUFFER-COPY {&TableName} TO tt-docto-orig-nfse-aux.
        ASSIGN tt-docto-orig-nfse-aux.r-rowid = ROWID({&TableName}).
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySituacao DBOProgram 
PROCEDURE openQuerySituacao :
/*------------------------------------------------------------------------------
  Purpose:     Abrir a query com base na restriá∆o feita somente ao campo idi-situacao (situaá∆o da NFS-e).
  
  Parameters:  <none>
  
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.idi-situacao >= i-idi-situacao-ini
           AND {&TableName}.idi-situacao <= i-idi-situacao-fin 
           AND {&TableName}.idi-orig-trad = 2 INDEXED-REPOSITION. /* Somente registros traduzidos (idi-orig-trad = 2)*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-impto-retido-cofins DBOProgram 
PROCEDURE pi-cria-impto-retido-cofins :
IF NOT VALID-HANDLE(h-boin567) THEN 
       RUN inbo/boin567.p PERSISTENT SET h-boin567.

    EMPTY TEMP-TABLE tt-dupli-imp.
    EMPTY TEMP-TABLE RowErrors.

    RUN openQueryStatic   IN h-boin567 (INPUT "Main":U).
    RUN getParcelaImposto IN h-boin567 (INPUT  dupli-apagar.cod-emitente,
                                        INPUT  dupli-apagar.serie-docto,
                                        INPUT  dupli-apagar.nr-duplic,  
                                        INPUT  dupli-apagar.nat-operacao,
                                        INPUT  dupli-apagar.parcela,     
                                        OUTPUT c-parcela-imp).    
    CREATE tt-dupli-imp.
    ASSIGN tt-dupli-imp.serie-docto         = dupli-apagar.serie-docto
           tt-dupli-imp.nro-docto           = dupli-apagar.nr-duplic
           tt-dupli-imp.cod-emitente        = dupli-apagar.cod-emitente
           tt-dupli-imp.nat-operacao        = dupli-apagar.nat-operacao
           tt-dupli-imp.parcela             = dupli-apagar.parcela
           tt-dupli-imp.parcela-imp         = c-parcela-imp
           tt-dupli-imp.int-1               = INT(SUBSTRING(param-convrsr-nfe.cod-livre-2,11,8)) /*param-convrsr-nfe.num-impto-retid-cofins*/
           tt-dupli-imp.cod-esp             = TRIM(SUBSTRING(param-convrsr-nfe.cod-livre-2,53,2)) /*param-convrsr-nfe.cod-espec-cofins*/
           OVERLAY(tt-dupli-imp.char-1,1,5) = dupli-apagar.serie-docto 
           tt-dupli-imp.nro-docto-imp       = dupli-apagar.nro-docto
           tt-dupli-imp.cod-retencao        = INT(SUBSTRING(param-convrsr-nfe.cod-livre-2,72,8)) /*param-convrsr-nfe.num-retenc-cofins*/
           tt-dupli-imp.aliquota            = docto-orig-nfse.val-aliq-cofins
           tt-dupli-imp.rend-trib           = dupli-apagar.vl-a-pagar
           tt-dupli-imp.vl-imposto          = IF  docto-orig-nfse.val-retenc-cofins = ? THEN 0 ELSE docto-orig-nfse.val-retenc-cofins.

    RUN emptyRowObject IN h-boin567.
    RUN emptyRowErrors IN h-boin567.

    RUN setRecord      IN h-boin567 (INPUT TABLE tt-dupli-imp).
    RUN setDtVencImp   IN h-boin567 (NO /* valor 'NO' significa que sugere a data de vencto*/).

    RUN createRecord   IN h-boin567.

    RUN getRowErrors IN h-boin567 (OUTPUT TABLE rowErrors).

    FOR FIRST rowErrors:
        {inbo/boin874.m3 RowErrors.ErrorNumber RowErrors.ErrorDescription}
    END.
    
    IF  VALID-HANDLE(h-boin567) THEN DO:
        DELETE PROCEDURE h-boin567.
        ASSIGN h-boin567 = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-impto-retido-csll DBOProgram 
PROCEDURE pi-cria-impto-retido-csll :
IF NOT VALID-HANDLE(h-boin567) THEN 
       RUN inbo/boin567.p PERSISTENT SET h-boin567.

    EMPTY TEMP-TABLE tt-dupli-imp.
    EMPTY TEMP-TABLE RowErrors.

    RUN openQueryStatic   IN h-boin567 (INPUT "Main":U).
    RUN getParcelaImposto IN h-boin567 (INPUT  dupli-apagar.cod-emitente,
                                        INPUT  dupli-apagar.serie-docto,
                                        INPUT  dupli-apagar.nr-duplic,  
                                        INPUT  dupli-apagar.nat-operacao,
                                        INPUT  dupli-apagar.parcela,     
                                        OUTPUT c-parcela-imp).
    CREATE tt-dupli-imp.
    ASSIGN tt-dupli-imp.serie-docto         = dupli-apagar.serie-docto
           tt-dupli-imp.nro-docto           = dupli-apagar.nr-duplic
           tt-dupli-imp.cod-emitente        = dupli-apagar.cod-emitente
           tt-dupli-imp.nat-operacao        = dupli-apagar.nat-operacao
           tt-dupli-imp.parcela             = dupli-apagar.parcela
           tt-dupli-imp.parcela-imp         = c-parcela-imp
           tt-dupli-imp.int-1               = INT(SUBSTRING(param-convrsr-nfe.cod-livre-2,27,8)) /*param-convrsr-nfe.num-impto-retid-csll*/
           tt-dupli-imp.cod-esp             = TRIM(SUBSTRING(param-convrsr-nfe.cod-livre-2,57,2)) /*param-convrsr-nfe.cod-espec-csll*/
           OVERLAY(tt-dupli-imp.char-1,1,5) = dupli-apagar.serie-docto 
           tt-dupli-imp.nro-docto-imp       = dupli-apagar.nro-docto
           tt-dupli-imp.cod-retencao        = INT(SUBSTRING(param-convrsr-nfe.cod-livre-2,88,8)) /*param-convrsr-nfe.num-retenc-csll*/
           tt-dupli-imp.aliquota            = docto-orig-nfse.val-aliq-csll
           tt-dupli-imp.rend-trib           = dupli-apagar.vl-a-pagar 
           tt-dupli-imp.vl-imposto          = IF  docto-orig-nfse.val-retenc-csll = ? THEN 0 ELSE docto-orig-nfse.val-retenc-csll.

    RUN emptyRowObject IN h-boin567.
    RUN emptyRowErrors IN h-boin567.

    RUN setRecord      IN h-boin567 (INPUT TABLE tt-dupli-imp).
    RUN setDtVencImp   IN h-boin567 (NO /* valor 'NO' significa que sugere a data de vencto*/).

    RUN createRecord   IN h-boin567.

    RUN getRowErrors IN h-boin567 (OUTPUT TABLE rowErrors).

    FOR FIRST rowErrors:
        {inbo/boin874.m3 RowErrors.ErrorNumber RowErrors.ErrorDescription}
    END.
    
    IF  VALID-HANDLE(h-boin567) THEN DO:
        DELETE PROCEDURE h-boin567.
        ASSIGN h-boin567 = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-impto-retido-inss DBOProgram 
PROCEDURE pi-cria-impto-retido-inss :
IF NOT VALID-HANDLE(h-boin567) THEN 
       RUN inbo/boin567.p PERSISTENT SET h-boin567.

    EMPTY TEMP-TABLE tt-dupli-imp.
    EMPTY TEMP-TABLE RowErrors.

    RUN openQueryStatic   IN h-boin567 (INPUT "Main":U).
    RUN getParcelaImposto IN h-boin567 (INPUT  dupli-apagar.cod-emitente,
                                        INPUT  dupli-apagar.serie-docto,
                                        INPUT  dupli-apagar.nr-duplic,  
                                        INPUT  dupli-apagar.nat-operacao,
                                        INPUT  dupli-apagar.parcela,     
                                        OUTPUT c-parcela-imp).
    CREATE tt-dupli-imp.
    ASSIGN tt-dupli-imp.serie-docto         = dupli-apagar.serie-docto
           tt-dupli-imp.nro-docto           = dupli-apagar.nr-duplic
           tt-dupli-imp.cod-emitente        = dupli-apagar.cod-emitente
           tt-dupli-imp.nat-operacao        = dupli-apagar.nat-operacao
           tt-dupli-imp.parcela             = dupli-apagar.parcela
           tt-dupli-imp.parcela-imp         = c-parcela-imp
           tt-dupli-imp.int-1               = INT(SUBSTRING(param-convrsr-nfe.cod-livre-2,35,8)) /*param-convrsr-nfe.num-impto-retid-inss*/
           tt-dupli-imp.cod-esp             = TRIM(SUBSTRING(param-convrsr-nfe.cod-livre-2,59,2)) /*param-convrsr-nfe.cod-espec-inss*/
           OVERLAY(tt-dupli-imp.char-1,1,5) = dupli-apagar.serie-docto 
           tt-dupli-imp.nro-docto-imp       = dupli-apagar.nro-docto
           tt-dupli-imp.cod-retencao        = INT(SUBSTRING(param-convrsr-nfe.cod-livre-2,96,8)) /*param-convrsr-nfe.num-retenc-inss*/
           tt-dupli-imp.aliquota            = docto-orig-nfse.val-aliq-inss
           tt-dupli-imp.rend-trib           = dupli-apagar.vl-a-pagar 
           tt-dupli-imp.vl-imposto          = IF  docto-orig-nfse.val-retenc-inss = ? THEN 0 ELSE docto-orig-nfse.val-retenc-inss.

    RUN emptyRowObject IN h-boin567.
    RUN emptyRowErrors IN h-boin567.

    RUN setRecord      IN h-boin567 (INPUT TABLE tt-dupli-imp).
    RUN setDtVencImp   IN h-boin567 (NO /* valor 'NO' significa que sugere a data de vencto*/).

    RUN createRecord   IN h-boin567.

    RUN getRowErrors IN h-boin567 (OUTPUT TABLE rowErrors).

    FOR FIRST rowErrors:
        {inbo/boin874.m3 RowErrors.ErrorNumber RowErrors.ErrorDescription}
            
    END.
    
    IF  VALID-HANDLE(h-boin567) THEN DO:
        DELETE PROCEDURE h-boin567.
        ASSIGN h-boin567 = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-impto-retido-ir DBOProgram 
PROCEDURE pi-cria-impto-retido-ir :
IF NOT VALID-HANDLE(h-boin567) THEN 
       RUN inbo/boin567.p PERSISTENT SET h-boin567.

    EMPTY TEMP-TABLE tt-dupli-imp.
    EMPTY TEMP-TABLE RowErrors.

    RUN openQueryStatic   IN h-boin567 (INPUT "Main":U).
    RUN getParcelaImposto IN h-boin567 (INPUT  dupli-apagar.cod-emitente,
                                        INPUT  dupli-apagar.serie-docto,
                                        INPUT  dupli-apagar.nr-duplic,  
                                        INPUT  dupli-apagar.nat-operacao,
                                        INPUT  dupli-apagar.parcela,     
                                        OUTPUT c-parcela-imp).
    CREATE tt-dupli-imp.
    ASSIGN tt-dupli-imp.serie-docto         = dupli-apagar.serie-docto
           tt-dupli-imp.nro-docto           = dupli-apagar.nr-duplic
           tt-dupli-imp.cod-emitente        = dupli-apagar.cod-emitente
           tt-dupli-imp.nat-operacao        = dupli-apagar.nat-operacao
           tt-dupli-imp.parcela             = dupli-apagar.parcela
           tt-dupli-imp.parcela-imp         = c-parcela-imp
           tt-dupli-imp.int-1               = INT(SUBSTRING(param-convrsr-nfe.cod-livre-2,19,8)) /*param-convrsr-nfe.num-impto-retid-irrf*/
           tt-dupli-imp.cod-esp             = TRIM(SUBSTRING(param-convrsr-nfe.cod-livre-2,55,2)) /*param-convrsr-nfe.cod-espec-irrf*/
           OVERLAY(tt-dupli-imp.char-1,1,5) = dupli-apagar.serie-docto 
           tt-dupli-imp.nro-docto-imp       = dupli-apagar.nro-docto
           tt-dupli-imp.cod-retencao        = INT(SUBSTRING(param-convrsr-nfe.cod-livre-2,80,8)) /*param-convrsr-nfe.num-retenc-irrf*/
           tt-dupli-imp.aliquota            = docto-orig-nfse.val-aliq-ir
           tt-dupli-imp.rend-trib           = dupli-apagar.vl-a-pagar 
           tt-dupli-imp.vl-imposto          = IF  docto-orig-nfse.val-retenc-ir = ? THEN 0 ELSE docto-orig-nfse.val-retenc-ir.
  
    RUN emptyRowObject IN h-boin567.
    RUN emptyRowErrors IN h-boin567.

    RUN setRecord      IN h-boin567 (INPUT TABLE tt-dupli-imp).
    RUN setDtVencImp   IN h-boin567 (NO /* valor 'NO' significa que sugere a data de vencto*/).

    RUN createRecord   IN h-boin567.

    RUN getRowErrors IN h-boin567 (OUTPUT TABLE rowErrors).

    FOR FIRST rowErrors:
        {inbo/boin874.m3 RowErrors.ErrorNumber RowErrors.ErrorDescription}
    END.

    IF  VALID-HANDLE(h-boin567) THEN DO:
        DELETE PROCEDURE h-boin567.
        ASSIGN h-boin567 = ?.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-impto-retido-iss-retido DBOProgram 
PROCEDURE pi-cria-impto-retido-iss-retido :
IF NOT VALID-HANDLE(h-boin567) THEN 
       RUN inbo/boin567.p PERSISTENT SET h-boin567.

    EMPTY TEMP-TABLE tt-dupli-imp.
    EMPTY TEMP-TABLE RowErrors.

    RUN openQueryStatic   IN h-boin567 (INPUT "Main":U).
    RUN getParcelaImposto IN h-boin567 (INPUT  dupli-apagar.cod-emitente,
                                        INPUT  dupli-apagar.serie-docto,
                                        INPUT  dupli-apagar.nr-duplic,  
                                        INPUT  dupli-apagar.nat-operacao,
                                        INPUT  dupli-apagar.parcela,     
                                        OUTPUT c-parcela-imp).
    CREATE tt-dupli-imp.
    ASSIGN tt-dupli-imp.serie-docto         = dupli-apagar.serie-docto
           tt-dupli-imp.nro-docto           = dupli-apagar.nr-duplic
           tt-dupli-imp.cod-emitente        = dupli-apagar.cod-emitente
           tt-dupli-imp.nat-operacao        = dupli-apagar.nat-operacao
           tt-dupli-imp.parcela             = dupli-apagar.parcela
           tt-dupli-imp.parcela-imp         = c-parcela-imp
           tt-dupli-imp.int-1               = INT(SUBSTRING(param-convrsr-nfe.cod-livre-2,43,8)) /*param-convrsr-nfe.num-impto-retid-iss*/
           tt-dupli-imp.cod-esp             = TRIM(SUBSTRING(param-convrsr-nfe.cod-livre-2,61,3)) /*param-convrsr-nfe.cod-espec-iss*/
           OVERLAY(tt-dupli-imp.char-1,1,5) = dupli-apagar.serie-docto 
           tt-dupli-imp.nro-docto-imp       = dupli-apagar.nro-docto
           tt-dupli-imp.cod-retencao        = INT(SUBSTRING(param-convrsr-nfe.cod-livre-2,104,8)) /*param-convrsr-nfe.num-retenc-iss*/
           tt-dupli-imp.aliquota            = docto-orig-nfse.val-aliq-iss     
           tt-dupli-imp.rend-trib           = dupli-apagar.vl-a-pagar   
           tt-dupli-imp.vl-imposto          = IF  docto-orig-nfse.val-iss-retid = ? THEN 0 ELSE docto-orig-nfse.val-iss-retid.
  
    RUN emptyRowObject IN h-boin567.
    RUN emptyRowErrors IN h-boin567.

    RUN setRecord      IN h-boin567 (INPUT TABLE tt-dupli-imp).
    RUN setDtVencImp   IN h-boin567 (NO /* valor 'NO' significa que sugere a data de vencto*/).

    RUN createRecord   IN h-boin567.

    RUN getRowErrors IN h-boin567 (OUTPUT TABLE rowErrors).

    FOR FIRST rowErrors:
        {inbo/boin874.m3 RowErrors.ErrorNumber RowErrors.ErrorDescription}
    END.

    IF  VALID-HANDLE(h-boin567) THEN DO:
        DELETE PROCEDURE h-boin567.
        ASSIGN h-boin567 = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-impto-retido-pis DBOProgram 
PROCEDURE pi-cria-impto-retido-pis :
IF NOT VALID-HANDLE(h-boin567) THEN 
       RUN inbo/boin567.p PERSISTENT SET h-boin567.

    EMPTY TEMP-TABLE tt-dupli-imp.
    EMPTY TEMP-TABLE RowErrors.

    RUN openQueryStatic   IN h-boin567 (INPUT "Main":U).
    RUN getParcelaImposto IN h-boin567 (INPUT  dupli-apagar.cod-emitente,
                                        INPUT  dupli-apagar.serie-docto,
                                        INPUT  dupli-apagar.nr-duplic,  
                                        INPUT  dupli-apagar.nat-operacao,
                                        INPUT  dupli-apagar.parcela,     
                                        OUTPUT c-parcela-imp).
    CREATE tt-dupli-imp.
    ASSIGN tt-dupli-imp.serie-docto         = dupli-apagar.serie-docto
           tt-dupli-imp.nro-docto           = dupli-apagar.nr-duplic
           tt-dupli-imp.cod-emitente        = dupli-apagar.cod-emitente
           tt-dupli-imp.nat-operacao        = dupli-apagar.nat-operacao
           tt-dupli-imp.parcela             = dupli-apagar.parcela
           tt-dupli-imp.parcela-imp         = c-parcela-imp
           tt-dupli-imp.int-1               = INT(SUBSTRING(param-convrsr-nfe.cod-livre-2,3,8)) /*param-convrsr-nfe.num-impto-retid-pis*/
           tt-dupli-imp.cod-esp             = TRIM(SUBSTRING(param-convrsr-nfe.cod-livre-2,51,2)) /*param-convrsr-nfe.cod-espec-pis*/
           OVERLAY(tt-dupli-imp.char-1,1,5) = dupli-apagar.serie-docto 
           tt-dupli-imp.nro-docto-imp       = dupli-apagar.nro-docto
           tt-dupli-imp.cod-retencao        = INT(SUBSTRING(param-convrsr-nfe.cod-livre-2,64,8)) /*param-convrsr-nfe.num-retenc-pis*/
           tt-dupli-imp.aliquota            = docto-orig-nfse.val-aliq-pis
           tt-dupli-imp.rend-trib           = dupli-apagar.vl-a-pagar
           tt-dupli-imp.vl-imposto          = IF  docto-orig-nfse.val-retenc-pis = ? THEN 0 ELSE docto-orig-nfse.val-retenc-pis.
  
    RUN emptyRowObject IN h-boin567.
    RUN emptyRowErrors IN h-boin567.

    RUN setRecord      IN h-boin567 (INPUT TABLE tt-dupli-imp).
    RUN setDtVencImp   IN h-boin567 (NO /* valor 'NO' significa que sugere a data de vencto*/).

    RUN createRecord   IN h-boin567.

    RUN getRowErrors IN h-boin567 (OUTPUT TABLE rowErrors).

    FOR FIRST rowErrors:
        {inbo/boin874.m3 RowErrors.ErrorNumber RowErrors.ErrorDescription}
    END.
    
    IF  VALID-HANDLE(h-boin567) THEN DO:
        DELETE PROCEDURE h-boin567.
        ASSIGN h-boin567 = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-impostos-retidos DBOProgram 
PROCEDURE pi-gera-impostos-retidos :
    DEF BUFFER bf-docum-est FOR docum-est.
    
    DEF VAR h-reapi405    AS HANDLE NO-UNDO.
    DEF VAR h-reapi415    AS HANDLE NO-UNDO.
    DEF VAR l-habilita    AS LOG    NO-UNDO.
    DEF VAR l-reinf       AS LOG    NO-UNDO.
    DEF VAR l-habilita40  AS LOG    NO-UNDO.
    DEF VAR l-reinf40     AS LOG    NO-UNDO.
              
    FOR FIRST param-convrsr-nfe FIELDS (cod-livre-2) NO-LOCK:
    END.
    
     IF NOT VALID-HANDLE(h-reapi405) THEN    //REINF serviáos tomados
        RUN rep/reapi405.p PERSISTENT SET h-reapi405.
        
     IF NOT VALID-HANDLE(h-reapi415) THEN    //REINF retená‰es na fonte
        RUN rep/reapi415.p PERSISTENT SET h-reapi415. 
        
    /*--- IMPOSTOS RETIDOS ---*/

    /* SE parametro gera duplicata automaticamente estiver marcado ENTAO */                     
    FOR FIRST tt-docum-est FIELDS (nat-operacao cod-emitente nro-docto serie-docto):       
                  
         FOR FIRST natur-oper FIELDS (emite-duplic) 
             WHERE natur-oper.nat-operacao = tt-docum-est.nat-operacao
             AND natur-oper.emite-duplic 
             AND TRIM(SUBSTRING(param-convrsr-nfe.cod-livre-2,1,1)) = "1" /* Gera Duplicata automaticamente */
             NO-LOCK:
             
             /*--- geracao de duplicatas ---*/
             find first bf-docum-est
                  where bf-docum-est.cod-emitente = tt-docum-est.cod-emitente
                    and bf-docum-est.nat-operacao = tt-docum-est.nat-operacao
                    and bf-docum-est.nro-docto    = tt-docum-est.nro-docto   
                    and bf-docum-est.serie-docto  = tt-docum-est.serie-docto no-lock no-error.
             if  avail bf-docum-est
             and not can-find(first dupli-apagar
                              where dupli-apagar.cod-emitente = tt-docum-est.cod-emitente
                                and dupli-apagar.nat-operacao = tt-docum-est.nat-operacao
                                and dupli-apagar.nro-docto    = tt-docum-est.nro-docto   
                                and dupli-apagar.serie-docto  = tt-docum-est.serie-docto) then do:

                 run rep/re9341.p (rowid(bf-docum-est),no).

             end.
         END.
    end.

    /* verifica se foi gerada duplicata para a nota */
    IF  CAN-FIND(FIRST dupli-apagar
                 WHERE dupli-apagar.cod-emitente = tt-docum-est.cod-emitente
                   AND dupli-apagar.nat-operacao = tt-docum-est.nat-operacao
                   AND dupli-apagar.nro-docto    = tt-docum-est.nro-docto   
                   AND dupli-apagar.serie-docto  = tt-docum-est.serie-docto) THEN DO:
                   
        /**********************REINF serviáos tomados**********************************/
        RUN sugerereinf IN h-reapi405 (INPUT tt-docum-est.cod-estabel,
                                       INPUT tt-docum-est.cod-emitente,
                                       INPUT tt-docum-est.dt-trans,
                                       INPUT tt-docum-est.dt-emissao,
                                       INPUT tt-docum-est.nat-operacao,
                                       INPUT tt-docum-est.cod-observa,
                                       OUTPUT l-habilita,
                                       INPUT-OUTPUT l-reinf).   


        /**********************REINF retená‰es na fonte**********************************/   
        RUN sugerereinf40 IN h-reapi415 (INPUT  tt-docum-est.cod-estabel,
                                         INPUT  tt-docum-est.cod-emitente,
                                         INPUT  tt-docum-est.dt-trans,
                                         INPUT  tt-docum-est.dt-emissao,
                                         INPUT  tt-docum-est.nat-operacao,
                                         INPUT  tt-docum-est.cod-observa ,
                                         OUTPUT l-habilita40,
                                         INPUT-OUTPUT l-reinf40).   
                                         
        FIND FIRST bf-docum-est EXCLUSIVE-LOCK
             WHERE bf-docum-est.cod-emitente = tt-docum-est.cod-emitente
               AND bf-docum-est.nat-operacao = tt-docum-est.nat-operacao
               AND bf-docum-est.nro-docto    = tt-docum-est.nro-docto   
               AND bf-docum-est.serie-docto  = tt-docum-est.serie-docto NO-ERROR.
        IF  AVAIL bf-docum-est THEN DO:       
         ASSIGN OVERLAY(bf-docum-est.char-2,256,1) = IF l-reinf   THEN 'S' ELSE 'N'
                OVERLAY(bf-docum-est.char-2,269,1) = IF l-reinf40 THEN 'S' ELSE 'N'.  
        END.  
        FIND CURRENT bf-docum-est NO-LOCK NO-ERROR.

        /*param-convrsr-nfe.idi-gera-impto-nfse*/ 
        IF  TRIM(SUBSTRING(param-convrsr-nfe.cod-livre-2,2,1)) = "2" /*gera imptos conforme recebimento*/ THEN DO:

            FOR EACH  dupli-apagar
                WHERE dupli-apagar.cod-emitente = tt-docum-est.cod-emitente
                  AND dupli-apagar.nat-operacao = tt-docum-est.nat-operacao
                  AND dupli-apagar.nro-docto    = tt-docum-est.nro-docto   
                  AND dupli-apagar.serie-docto  = tt-docum-est.serie-docto NO-LOCK:
                CREATE tt-dupli-apagar.
                BUFFER-COPY dupli-apagar TO tt-dupli-apagar
                    ASSIGN tt-dupli-apagar.r-rowid = ROWID(dupli-apagar).
            END. 

            /*--- gera impostos automaticamente conforme regras do recebimento / contas a pagar ---*/
            IF  CAN-FIND(FIRST tt-dupli-apagar) THEN 
                RUN rep/re9343.p (INPUT TABLE tt-dupli-apagar, OUTPUT TABLE RowErrors).

            FOR FIRST rowErrors:
                {inbo/boin874.m3 RowErrors.ErrorNumber RowErrors.ErrorDescription}
            END.
        END.                                                             

        ELSE IF TRIM(SUBSTRING(param-convrsr-nfe.cod-livre-2,2,1)) = "1" /*gera imptos conforme arquvo XML*/ THEN DO:

            FOR FIRST dupli-apagar FIELDS(cod-emitente serie-docto nr-duplic nat-operacao parcela nro-docto vl-a-pagar)
                WHERE dupli-apagar.cod-emitente = tt-docum-est.cod-emitente
                AND dupli-apagar.nat-operacao = tt-docum-est.nat-operacao
                AND dupli-apagar.nro-docto    = tt-docum-est.nro-docto   
                AND dupli-apagar.serie-docto  = tt-docum-est.serie-docto NO-LOCK:

                IF  docto-orig-nfse.val-aliq-pis <> ? AND docto-orig-nfse.val-aliq-pis > 0 THEN
                    RUN pi-cria-impto-retido-pis.

                IF  docto-orig-nfse.val-aliq-cofins <> ? AND docto-orig-nfse.val-aliq-cofins > 0 THEN
                    RUN pi-cria-impto-retido-cofins.

                IF  docto-orig-nfse.val-aliq-csll <> ? AND docto-orig-nfse.val-aliq-csll > 0 THEN
                    RUN pi-cria-impto-retido-csll.

                IF  docto-orig-nfse.val-aliq-inss <> ? AND docto-orig-nfse.val-aliq-inss > 0 THEN
                    RUN pi-cria-impto-retido-inss.

                IF  docto-orig-nfse.val-aliq-ir <> ? AND docto-orig-nfse.val-aliq-ir > 0 THEN
                    RUN pi-cria-impto-retido-ir.

                IF  docto-orig-nfse.val-aliq-iss <> ? AND docto-orig-nfse.val-aliq-iss > 0 THEN
                    RUN pi-cria-impto-retido-iss-retido.

            END.                            
        END.
    END.
   
    RETURN "OK":U.
    FINALLY:
        IF VALID-HANDLE(h-reapi405) THEN DO:
           DELETE PROCEDURE(h-reapi405).
           ASSIGN h-reapi405 = ?.
        END.
        IF VALID-HANDLE(h-reapi415) THEN DO:
           DELETE PROCEDURE(h-reapi415).
           ASSIGN h-reapi415 = ?.
        END.
    END FINALLY.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDocumento DBOProgram 
PROCEDURE retornaDocumento :
/*------------------------------------------------------------------------------
  Purpose: Retorna o Rowid da docum-est com base na chave     
  Parameters: pserie-docto : SÇrie do documento
              pnro-docto   : N£mero do documento
              pcod-emitente: C¢digo do emitente
              pr-docto     : Rowid do documento
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM pserie-docto  LIKE docum-est.serie-docto  NO-UNDO.
    DEF INPUT  PARAM pnro-docto    LIKE docum-est.nro-docto    NO-UNDO.
    DEF INPUT  PARAM pcod-emitente LIKE docum-est.cod-emitente NO-UNDO.
    DEF OUTPUT PARAM pr-docto      AS ROWID                    NO-UNDO.

    FOR FIRST docum-est NO-LOCK
        WHERE docum-est.serie-docto  = pserie-docto
          AND docum-est.nro-docto    = pnro-docto
          AND docum-est.cod-emitente = pcod-emitente: END.

    IF  AVAIL docum-est THEN
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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAMETER p-cod-emitente LIKE emitente.cod-emitente NO-UNDO.
    DEF OUTPUT PARAMETER p-nome-abrev   LIKE emitente.nome-abrev   NO-UNDO.

    FOR FIRST emitente FIELDS (nome-abrev pais estado)
        WHERE emitente.cod-emitente = p-cod-emitente NO-LOCK:
    END.
    IF  AVAIL emitente THEN
        ASSIGN p-nome-abrev = emitente.nome-abrev.
    ELSE 
        ASSIGN p-nome-abrev = "".

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveOrdemOld DBOProgram 
PROCEDURE saveOrdemOld :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    ASSIGN i-num-ordem-old = RowObject.numero-ordem
           i-num-parcela-old = RowObject.num-parcela.

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
    DEF INPUT PARAM p-chave-acesso LIKE docto-orig-nfse.cod-chave-aces-nfse NO-UNDO.
    DEF INPUT PARAM p-idi-origem   LIKE docto-orig-nfse.idi-orig-trad NO-UNDO.

    ASSIGN c-chave-acesso = p-chave-acesso
           i-idi-origem   = p-idi-origem.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMonitorNFSE DBOProgram 
PROCEDURE setConstraintMonitorNFSE :
/*------------------------------------------------------------------------------
  Purpose: Setar variˇveis utilizadas na abertura da query utilizada pelo monitor   
  Parameters: p-tg-digitada: mostra os conhecimentos digitadas no recebimento fiscal      
              p-tg-erro-neg: mostra os conhecimentos com erro de neg¢cio 
              p-tg-atualizada: mostra os conhecimentos atualizados no recebimento fiscal    
              p-tg-eliminada: mostra os conhecimentos eliminados no recebimento fiscal     
              p-tg-cancelada: mostra os conhecimentos cancelados    
              p-tg-inutilizada: mostra os conhecimentos inutilizados
              p-tg-validacao: mostra os conhecimentos em validaá∆o     
              p-tg-todos: mostra os conhecimentos em qualquer situaá∆o         
              p-cod-emitente-ini: c¢digo do fornecedor inicial 
              p-cod-emitente-fim: c¢digo do fornecedor final 
              p-cod-estabel-ini: c¢digo do estabelecimento inicial  
              p-cod-estabel-fim: c¢digo do estabelecimento fiscal  
              p-serie-ini: sÇrie inicial        
              p-serie-fim: sÇrie final        
              p-nro-docto-ini: n£mero do conhecimento inicial    
              p-nro-docto-fim: n£mero do conhecimento final    
              p-dt-emissao-ini: data de emiss∆o inicial   
              p-dt-emissao-fim: data de emiss∆o final   
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-tg-digitada            AS LOG                          NO-UNDO.
    DEF INPUT PARAM p-tg-erro-neg            AS LOG                          NO-UNDO.
    DEF INPUT PARAM p-tg-atualizada          AS LOG                          NO-UNDO.
    DEF INPUT PARAM p-tg-eliminada           AS LOG                          NO-UNDO.
    DEF INPUT PARAM p-tg-cancelada           AS LOG                          NO-UNDO.
    DEF INPUT param p-tg-inutilizada         AS log                          NO-UNDO.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSituacao DBOProgram 
PROCEDURE setConstraintSituacao :
/*------------------------------------------------------------------------------
  Purpose:    Setar restriá∆o da query para o campo idi-situacao (situaá∆o da NFS-e).
  
  Parameters: p-i-idi-situacao-ini -> Situaá∆o da NFS-e inicial (faixa de pesquisa).
              p-i-idi-situacao-fin -> Situaá∆o da NFS-e final (faixa de pesquisa).
              
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-i-idi-situacao-ini LIKE docto-orig-nfse.idi-situacao NO-UNDO.
    DEF INPUT PARAM p-i-idi-situacao-fin LIKE docto-orig-nfse.idi-situacao NO-UNDO.

    ASSIGN i-idi-situacao-ini = p-i-idi-situacao-ini
           i-idi-situacao-fin = p-i-idi-situacao-fin.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaNFSe DBOProgram 
PROCEDURE eliminaNFSe :
/*------------------------------------------------------------------------------
  Purpose:     Eliminar os registros da NFS-e.
  Parameters:  c-chave-nfe -> Chave única de acesso a NFS-e no SEFAZ.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER c-chave-nfse AS CHARACTER NO-UNDO.
 
    /*--- In≠cio - Elimina tabelas NFS-e ---*/    
    FOR EACH item-docto-orig-nfse WHERE item-docto-orig-nfse.cod-chave-aces-nfse = c-chave-nfse EXCLUSIVE-LOCK:
        DELETE item-docto-orig-nfse.
    END.

    FOR EACH msg-ret-nfe WHERE msg-ret-nfe.ch-acesso-comp-nfe = c-chave-nfse EXCLUSIVE-LOCK:
        DELETE msg-ret-nfe.
    END.

    FOR EACH log-config-regra WHERE log-config-regra.cod-chave = c-chave-nfse EXCLUSIVE-LOCK:
        DELETE log-config-regra.
    END.   
    
    /* Verifica se existe o registro com a chave passada por par≥metro. */
    IF  NOT CAN-FIND(FIRST docto-orig-nfse WHERE docto-orig-nfse.cod-chave-aces-nfse = c-chave-nfse) THEN
        RETURN "NOK":U.

    FOR EACH docto-orig-nfse WHERE docto-orig-nfse.cod-chave-aces-nfse = c-chave-nfse EXCLUSIVE-LOCK:
        IF docto-orig-nfse.numero-ordem <> 0 THEN DO:
            RUN validaContratoOrdem (INPUT docto-orig-nfse.numero-ordem).
            IF RETURN-VALUE = "OK":U THEN DO:
                /* BO prazo-compra */
                RUN inbo/boin356.p PERSISTENT SET h-boin356.
                RUN pi-desaloca-ordem-cc IN h-boin356 (INPUT docto-orig-nfse.numero-ordem,
                                                       INPUT docto-orig-nfse.num-parcela,
                                                       INPUT 1).

                DELETE PROCEDURE h-boin356.
                ASSIGN h-boin356 = ?.
            END.
        END.

        DELETE docto-orig-nfse.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaContratoOrdem DBOProgram 
PROCEDURE validaContratoOrdem :
/*------------------------------------------------------------------------------
  Purpose: Valida?ío de contrato de ordem de compra se deve desalocar OC
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter   i-num-ordem   like ordem-compra.numero-ordem  no-undo.
    
    def var  l-contrato    as logical      no-undo.
    def var  i-total       as int          no-undo.
    
    assign l-contrato = no
           i-total    = 0.

    run findOrdemCompra  (INPUT i-num-ordem).
    if avail ordem-compra and ordem-compra.nr-contrato = 0 then
        return "OK":U.

    if avail ordem-compra then
        find contrato-for no-lock
        where contrato-for.nr-contrato = ordem-compra.nr-contrato no-error.
    
    if  not avail contrato-for then
        assign l-contrato = no.
    else do:
        if  contrato-for.ind-control-rec = 2 then
            find item-contrat no-lock 
            where item-contrat.num-seq-item = ordem-compra.num-seq-item  
            and   item-contrat.nr-contrato  = ordem-compra.nr-contrato no-error.
        
        assign i-total = 0.
              
        if (avail item-contrat and item-contrat.ind-tipo-control = 1)
        or (avail contrato-for and contrato-for.ind-control-rec  = 1) then do: 
            
            assign l-contrato = yes.
        
            if contrato-for.ind-control-rec = 1 then 
                assign i-total = 1.
        
            if avail item-contrat then do:
                if  item-contrat.ind-tipo-control     =  1
                and item-contrat.ind-tipo-control-val <> 3 then
                    assign i-total = 2.   
                else
                    assign i-total = 1.
            end.
        end.
        else do: 
            if  avail item-contrat 
            and item-contrat.log-control-event then
                assign l-contrato = yes.
        end.   
    end.

    if i-total = 0 then
        return "OK":U.
    else
        return "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableEncerraPa DBOProgram 
PROCEDURE enableEncerraPa :
/*------------------------------------------------------------------------------
  Purpose: Retorna se deve habilitar o campo encerra parcela
  Parameters: pi-numero-ordem: numero da ordem de compra
              pi-num-seq-event: numero do evento
              pl-enable : Indica se habilita ou nío
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAM pi-numero-ordem  LIKE docto-orig-nfse.numero-ordem  NO-UNDO.
    DEFINE INPUT  PARAM pi-num-seq-event LIKE docto-orig-nfse.num-evento    NO-UNDO.
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
                              INPUT-OUTPUT TABLE tt-erro-aux).
        END.
        

        IF  AVAIL param-re
        AND param-re.encerra-cc
        AND param-global.modulo-cc
        AND NOT l-contrato THEN
            ASSIGN pl-enable = YES.
        ELSE 
            ASSIGN pl-enable = NO.
    END.
    ELSE 
        ASSIGN pl-enable = NO.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sugereCampos DBOProgram 
PROCEDURE sugereCampos:
    DEFINE INPUT        PARAM pCodChaveAcesNfse LIKE {&TableName}.cod-chave-aces-nfse NO-UNDO.
    DEFINE INPUT-OUTPUT PARAM pItCodigo      AS CHAR     NO-UNDO.
    DEFINE INPUT-OUTPUT PARAM pNumPedido     AS INT      NO-UNDO.
    DEFINE INPUT-OUTPUT PARAM pNumeroOrdem   AS INT      NO-UNDO.

    FOR FIRST  bf{&TableName} 
        FIELDS (numero-ordem)
        WHERE  bf{&TableName}.cod-chave-aces-nfse = pCodChaveAcesNfse
        AND  bf{&TableName}.idi-orig-trad = 2 NO-LOCK:
    END.
    IF NOT AVAIL  bf{&TableName}  THEN
        RETURN "NOK":U.
    
    IF  pNumeroOrdem  > 0 THEN DO:
        
        FOR FIRST ordem-compra fields(it-codigo numero-ordem num-pedido) 
            WHERE ordem-compra.numero-ordem = pNumeroOrdem 
            AND   ordem-compra.situacao     = 2 NO-LOCK: END.
        IF NOT AVAIL ordem-compra THEN
            RETURN "NOK":U.

        ASSIGN pItCodigo    = ordem-compra.it-codigo
               pNumPedido   = ordem-compra.num-pedido
               pNumeroOrdem = ordem-compra.numero-ordem.
    END.
   
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findEmpresa DBOProgram 
PROCEDURE findEmpresa :
/*------------------------------------------------------------------------------
  Purpose: Buscar a empresa do documento   
  Parameters: pCodChaveAcesNfse: Chave de acesso do documento 
              pEmpresa: C¢digo da empresa        
    
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM pCodChaveAcesNfse LIKE docto-orig-nfse.cod-chave-aces-nfse NO-UNDO.
    DEFINE OUTPUT PARAM pEmpresa          LIKE empresa.ep-codigo                   NO-UNDO.
   
    ASSIGN pEmpresa = i-ep-codigo-usuario.
    
    FIND FIRST bfdocto-orig-nfse NO-LOCK  
         WHERE bfdocto-orig-nfse.cod-chave-aces-nfse= pCodChaveAcesNfse
         AND   bfdocto-orig-nfse.idi-orig-trad      = 2 NO-ERROR.
    IF AVAIL bfdocto-orig-nfse THEN DO:
    
        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel = TRIM(SUBSTRING(bfdocto-orig-nfse.cod-livre-2,1,5)) NO-ERROR.
        IF AVAIL estabelec THEN DO:
            run cdp/cd9970.p (input rowid(estabelec),
                              output pEmpresa).
        END.
        
    END.
    
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaContaCCusto DBOProgram 
PROCEDURE validaContaCCusto:
    IF NOT VALID-HANDLE(h_api_cta_ctbl) 
    OR h_api_cta_ctbl:TYPE      <> "PROCEDURE":U 
    OR h_api_cta_ctbl:FILE-NAME <> "prgint/utb/utb743za.py":U THEN
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.

    IF NOT VALID-HANDLE(h_api_ccusto) 
    OR h_api_ccusto:type      <> "PROCEDURE":U 
    OR h_api_ccusto:file-name <> "prgint/utb/utb742za.py":U THEN  
        run prgint/utb/utb742za.py persistent set h_api_ccusto.

    RUN findEmpresa (INPUT RowObject.cod-chave-aces-nfse,
                     OUTPUT i-empresa).    
    /* Busca dados da conta contˇbil */
    ASSIGN v_cod_cta_ctbl = RowObject.ct-codigo.
           
    RUN pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,                   /* EMPRESA EMS2 */
                                                  input        "",                           /* PLANO DE CONTAS */
                                                  input-output v_cod_cta_ctbl,               /* CONTA */
                                                  input        RowObject.dt-transacao, /* DATA TRANSACAO */   
                                                  output       v_titulo_cta_ctbl,            /* DESCRICAO CONTA */
                                                  output       v_num_tip_cta_ctbl,           /* TIPO DA CONTA */
                                                  output       v_num_sit_cta_ctbl,           /* SITUA∞ÄO DA CONTA */
                                                  output       v_ind_finalid_cta,            /* FINALIDADES DA CONTA */
                                                  output table tt_log_erro).                 /* ERROS */ 

    FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
    IF AVAIL tt_log_erro THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + '~~~~' + tt_log_erro.ttv_des_msg_ajuda"}  
    END.
    ELSE DO:
       /* Verifica se a conta utiliza centro de custo */
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-empresa,                                         /* EMPRESA EMS 2 */
                                                           input  TRIM(SUBSTRING(RowObject.cod-livre-2,1,5)),  /* ESTABELECIMENTO EMS2 */
                                                           input  "",                                                /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,                                    /* CONTA */
                                                           input  RowObject.dt-transacao,                      /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,                                  /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro).                                /* ERROS */        
        IF v_log_utz_ccusto THEN DO:
            /* Busca dados do centro de custo */
            ASSIGN v_cod_ccusto = RowObject.sc-codigo.
            run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,                      /* EMPRESA EMS2 */
                                                       input  "",                             /* CODIGO DO PLANO CCUSTO */
                                                       input  v_cod_ccusto,                   /* CCUSTO */
                                                       input  RowObject.dt-transacao,   /* DATA DE TRANSACAO */
                                                       output v_titulo_ccusto,                /* DESCRICAO DO CCUSTO */
                                                       output table tt_log_erro).             /* ERROS */
             
            find first tt_log_erro no-lock no-error.
            if avail tt_log_erro then do: 
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + '~~~~' + tt_log_erro.ttv_des_msg_ajuda"}
            end. 
        end.
    END.

    
   
   
    RETURN "OK":U.
    FINALLY:
        IF  VALID-HANDLE(h_api_cta_ctbl)        AND
           h_api_cta_ctbl:TYPE = "PROCEDURE":U AND
           h_api_cta_ctbl:FILE-NAME = "prgint/utb/utb743za.p":U THEN DO:
           DELETE PROCEDURE h_api_cta_ctbl.
           ASSIGN h_api_cta_ctbl = ?.
        END.

        IF  VALID-HANDLE(h_api_ccusto)        AND
            h_api_ccusto:TYPE = "PROCEDURE":U AND
            h_api_ccusto:FILE-NAME = "prgint/utb/utb742za.p":U THEN DO:
            DELETE PROCEDURE h_api_ccusto.
            ASSIGN h_api_ccusto = ?.
        END. 
    END FINALLY.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaUnidNegoc DBOProgram 
PROCEDURE validaUnidNegoc:

    def var seq-erro    as int no-undo.
    def var i-tipo-msg  as int no-undo.

    if  l-mat-unid-negoc then do:
        if not valid-handle(h-cdapi024) 
            or h-cdapi024:type <> "PROCEDURE"
            or h-cdapi024:file-name <> "cdp/cdapi024.p" then do:
            run cdp/cdapi024.p persistent set h-cdapi024.
        end.
                
        if  RowObject.cod-unid-negoc <> "" then do:
            find unid-negoc no-lock 
                where unid-negoc.cod-unid-negoc = RowObject.cod-unid-negoc no-error.
            if  not avail unid-negoc then do:
                {utp/ut-liter.i "Unidade_de_Neg¢cio" *}
                {method/svc/errors/inserr.i &ErrorNumber="2"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="RETURN-VALUE"}
            end.
                       
            if  valid-handle(h-cdapi024) then do:
                run ValidaUnidadeNegocioEstabel in h-cdapi024 (input  TRIM(SUBSTRING(RowObject.cod-livre-2,1,5)),
                                                               input  RowObject.dt-transacao,
                                                               input  RowObject.cod-unid-negoc,
                                                               output table tt-erro-aux).
                
                run ValidaUnidadeNegocioUsuario in h-cdapi024 (input c-seg-usuario,
                                                               input RowObject.cod-unid-negoc,
                                                               output table tt-erro-aux append).

                for each tt-erro-aux:
                    for last RowErrors:
                        assign seq-erro = RowErrors.ErrorSequence + 1.
                    end.
                    for first cadast_msg fields(idi_tip_msg) no-lock
                        where cadast_msg.cdn_msg = tt-erro-aux.cd-erro:
                        assign i-tipo-msg = cadast_msg.idi_tip_msg.
                    end.
                    create RowErrors.
                    assign RowErrors.ErrorSequence      = seq-erro
                           RowErrors.ErrorNumber        = tt-erro-aux.cd-erro
                           RowErrors.ErrorDescription   = tt-erro-aux.mensagem
                           RowErrors.ErrorType          = "EMS"
                           RowErrors.ErrorHelp          = ""
                           RowErrors.ErrorSubType       = if i-tipo-msg = 1 then "ERROR":U 
                                                          else "WARNING":U.
                end.
            end.
        end.
    end.

    RETURN "OK":U.
    FINALLY:
        IF  VALID-HANDLE(h-cdapi024) THEN DO:
            DELETE PROCEDURE h-cdapi024.
            ASSIGN h-cdapi024 = ?.
        END. 
    END FINALLY.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findOrdemCompra DBOProgram 
PROCEDURE findOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters: pi-numero-ordem: numero da ordem de compra
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAM pNumeroOrdem  LIKE docto-orig-nfse.numero-ordem  NO-UNDO.
    
    FIND FIRST ordem-compra NO-LOCK 
         WHERE ordem-compra.numero-ordem = pNumeroOrdem NO-ERROR.
    RETURN "OK":U.         
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sugereContaECentroCusto DBOProgram 
PROCEDURE sugereContaECentroCusto :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters: 
  
  Notes:   
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM pNumeroOrdem  LIKE docto-orig-nfse.numero-ordem  NO-UNDO.
    DEF INPUT  PARAM pItCodigo     AS CHAR NO-UNDO.
    DEF OUTPUT PARAM pCtCodigo     AS CHAR NO-UNDO.
    DEF OUTPUT PARAM pScCodigo     AS CHAR NO-UNDO.
    
    IF pNumeroOrdem <> 0 THEN DO:
        RUN findOrdemCompra  (INPUT pNumeroOrdem).
        IF AVAIL ordem-compra THEN
            ASSIGN pCtCodigo = ordem-compra.ct-codigo
                   pScCodigo = ordem-compra.sc-codigo.
    END.

    IF pCtCodigo = " " THEN DO:
        FIND FIRST ITEM
             WHERE ITEM.it-codigo = pItCodigo NO-LOCK NO-ERROR.
        IF AVAIL ITEM THEN
          ASSIGN pCtCodigo = ITEM.ct-codigo
                 pScCodigo = ITEM.sc-codigo.
    END.              
    
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME    

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sugereUnidNegoc DBOProgram 
PROCEDURE sugereUnidNegoc :
/*------------------------------------------------------------------------------
  Purpose: Sugere a unidade de negocio    
  Parameters:  Retorna a unidade de negocio sugerida
  Dependencias:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM pCodEstabel       AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM pNumeroOrdem      LIKE docto-orig-nfse.numero-ordem   NO-UNDO.
    DEFINE INPUT  PARAM pCtCodigo         LIKE docto-orig-nfse.ct-codigo      NO-UNDO.
    DEFINE INPUT  PARAM pCodItemServ      LIKE docto-orig-nfse.cod-item-serv  NO-UNDO.
    DEFINE OUTPUT PARAM pCodUnidNegoc     LIKE docto-orig-nfse.cod-unid-negoc NO-UNDO.

    if l-mat-unid-negoc then do:
         /* API sugestao unidade de negocio do item. */
        IF NOT VALID-HANDLE(h-cdapi024) THEN
            RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.

        FOR FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = pCodItemServ:
        END.
        
        IF pCtCodigo <> "" THEN DO:
            IF pNumeroOrdem <> 0 THEN DO:
                RUN findOrdemCompra  (INPUT pNumeroOrdem).
                /*for first ordem-compra no-lock
                    where ordem-compra.numero-ordem = int(pNumeroOrdem):*/
                    assign pCodUnidNegoc = ordem-compra.cod-unid-negoc.
                //end.
            END.
            ELSE DO: 
                if valid-handle(h-cdapi024) then
                    run RetornaUnidadeNegocioExternaliz in h-cdapi024 (INPUT pCodEstabel,
                                                                       INPUT pCodItemServ,
                                                                       INPUT ITEM.deposito-pad,
                                                                       OUTPUT pCodUnidNegoc).

            END.
        END.
        ELSE
            RUN RetornaUnidadeNegocioExternaliz in h-cdapi024 (INPUT pCodEstabel,
                                                               INPUT pCodItemServ,
                                                               INPUT ITEM.deposito-pad,
                                                               OUTPUT pCodUnidNegoc).
        
    END.
    
    RETURN "OK":U.
    FINALLY:
        IF  VALID-HANDLE(h-cdapi024) THEN DO:
            DELETE PROCEDURE h-cdapi024.
            ASSIGN h-cdapi024 = ?.
        END. 
    END FINALLY.
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
    DEFINE BUFFER bf-docto-orig-nfse-orig FOR docto-orig-nfse.
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-char-aux AS CHARACTER FORMAT "x(200)" NO-UNDO.
    DEFINE VARIABLE l-pendente AS LOGICAL     NO-UNDO.
    
    DEF VAR de-val-aux  AS DECIMAL NO-UNDO.     
    DEF VAR l-erro-co   AS LOGICAL NO-UNDO. 
    DEF VAR l-contrato  AS LOGICAL NO-UNDO. 
    DEF VAR i-total     AS INTEGER NO-UNDO. 

	DEFINE VARIABLE h-re1008         AS HANDLE    NO-UNDO.
	
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /* Validaá∆o de registro j† existente... */
    IF pType = "Create":U THEN
        IF CAN-FIND (docto-orig-nfse WHERE 
                     docto-orig-nfse.cod-chave-aces-nfse = RowObject.cod-chave-aces-nfse AND
                     docto-orig-nfse.idi-orig-trad = RowObject.idi-orig-trad) THEN DO:
            {utp/ut-table.i mgind docto-orig-nfse 1} /* Busca label da tabela docto-orig-nfse */
            {method/svc/errors/inserr.i 
                          &ErrorNumber="1" /* Erro de registro j† existente... */
                          &ErrorType="EMS":U
                          &ErrorSubType="ERROR":U
                          &ErrorParameters="RETURN-VALUE"}
        END.
    
    IF  pType = "Update":U AND RowObject.idi-orig-trad = 2 THEN DO: /* Alteraá‰es feitas no registro "traduzido" da NFS-e */

        FOR FIRST bf-docto-orig-nfse-orig /* Busca o registro original para efetuar as comparaá‰es... */
            FIELDS (cod-cnpj-prestdor)
            WHERE bf-docto-orig-nfse-orig.cod-chave-aces-nfse = RowObject.cod-chave-aces-nfse
            AND bf-docto-orig-nfse-orig.idi-orig-trad = 1 NO-LOCK:
        END.

        IF  NOT AVAIL bf-docto-orig-nfse-orig THEN DO:
            {method/svc/errors/inserr.i 
                    &ErrorNumber="52925"
                    &ErrorType="EMS":U
                    &ErrorSubType="ERROR":U
                    &ErrorParameters="RETURN-VALUE"}
            RETURN "NOK":U.
        END.

        /** Validaá‰es do Emitente **/
        IF  RowObject.cod-emitente > 0 THEN DO:
            FOR FIRST emitente FIELDS (cgc)
                WHERE emitente.cod-emitente = RowObject.cod-emitente NO-LOCK:
            END.

            IF  AVAIL emitente THEN DO:
                IF  emitente.cgc <> bf-docto-orig-nfse-orig.cod-cnpj-prestdor THEN DO:
                    {method/svc/errors/inserr.i 
                        &ErrorNumber="52926"
                        &ErrorType="EMS":U
                        &ErrorSubType="ERROR":U}
                END.            
            END.
            ELSE DO:
                {method/svc/errors/inserr.i 
                    &ErrorNumber="3486" /* Emitente &1 n∆o esta cadastrado */
                    &ErrorType="EMS":U
                    &ErrorSubType="ERROR":U
                    &ErrorParameters="RowObject.cod-emitente"}
            END.
        END.
        /****************************/
        /*****Validaá‰es estabelecimento*********/
        IF TRIM(SUBSTRING(RowObject.cod-livre-2,1,5)) <> '' THEN DO:
           FIND FIRST estabelec NO-LOCK
                WHERE estabelec.cod-estabel = TRIM(SUBSTRING(RowObject.cod-livre-2,1,5)) NO-ERROR.
           IF AVAIL estabelec THEN DO:                   
               FOR FIRST bf{&TableName} NO-LOCK
                   WHERE bf{&TableName}.cod-chave-aces-nfse = RowObject.cod-chave-aces-nfse
                     AND bf{&TableName}.idi-orig-trad      = 1:  
        
                   IF  bf{&TableName}.cod-cpf-tomador  <> estabelec.cgc 
                   AND bf{&TableName}.cod-cnpj-tomador <> estabelec.cgc  THEN DO:                    
         
                      {utp/ut-liter.i "tomador" *}
                      {method/svc/errors/inserr.i &ErrorNumber="54356"
                                                  &ErrorType="EMS":U
                                                  &ErrorSubType="ERROR":U 
                                                  &ErrorParameters="TRIM(RETURN-VALUE)"}
                   END.              
               END. 
           END.  
        END.
        /****************************************/

        /** Validaá‰es da SÇrie da NFS-e **/
        IF  RowObject.serie-docto <> "" THEN DO:
            IF NOT CAN-FIND(FIRST serie WHERE serie.serie = RowObject.serie-docto) THEN DO:
                {method/svc/errors/inserr.i
                    &ErrorNumber="8922" /* SÇrie &1 n∆o cadastrada */
                    &ErrorType="EMS":U
                    &ErrorSubType="ERROR":U
                    &ErrorParameters="RowObject.serie-docto"}
            END.
        END.
        /**********************************/

        /** Validaá‰es da Data de Transaá∆o **/
        IF  RowObject.dt-transacao < RowObject.dt-emissao THEN DO:
             DEFINE VARIABLE c-lbl-liter-transacao AS CHARACTER NO-UNDO.
             DEFINE VARIABLE c-lbl-liter-emissao AS CHARACTER NO-UNDO.

             {utp/ut-liter.i "transaá∆o" *}
             ASSIGN c-lbl-liter-transacao = TRIM(RETURN-VALUE).
             {utp/ut-liter.i "emiss∆o" *}
             ASSIGN c-lbl-liter-emissao = TRIM(RETURN-VALUE).
             {method/svc/errors/inserr.i &ErrorNumber="89"
                                         &ErrorType="EMS":U
                                         &ErrorSubType="ERROR":U
                                         &ErrorParameters="c-lbl-liter-transacao + '~~~~' + c-lbl-liter-emissao"  }
        END.
        /*************************************/

        /** Validaá‰es da Natureza de Operaá∆o */
        IF  RowObject.nat-operacao <> "" THEN DO:
            FOR FIRST natur-oper FIELDS (tipo terceiros ind-entfut ind-est-qtd char-1 tipo-compra) 
                WHERE natur-oper.nat-operacao = RowObject.nat-operacao NO-LOCK:
            END.

            IF  AVAIL natur-oper THEN DO:
                IF  natur-oper.tipo = 2 OR natur-oper.tipo = 3 THEN DO: /* Natureza de sa°da/Serviáo */
                    {method/svc/errors/inserr.i
                        &ErrorNumber="15026" /* Tipo de natureza deve ser Entrada */
                        &ErrorType="EMS":U
                        &ErrorSubType="ERROR":U}
                END.
                IF  natur-oper.terceiros = TRUE THEN DO: /* Operaá∆o com terceiros */
                    {utp/ut-liter.i de_operaá∆o_com_terceiros *}
                    {method/svc/errors/inserr.i 
                        &ErrorNumber="52403"  /* Natureza de operaá∆o n∆o pode ser &1 */
                        &ErrorType="EMS":U
                        &ErrorSubType="ERROR":U
                        &ErrorParameters="RETURN-VALUE"}
                END.
    
                {cdp/cd9700.i1 natur-oper} /* Verifica se natureza Ç fat. antecipado / entrega fut. */
                IF  l-fatura-fat-antecip OR l-remessa-fat-antecip OR
                    l-fatura-ent-futura  OR l-remessa-ent-futura THEN DO:
                    {utp/ut-liter.i Natureza_de_Operaá∆o *}
                    ASSIGN c-char-aux = RETURN-VALUE.
                    {utp/ut-liter.i Faturamento_Antecipado,_Remessa_de_Faturamento_Antecipado,_Faturamento_com_Entrega_Futura_e_Remessa_de_Entrega_Futura *}
                    {method/svc/errors/inserr.i 
                        &ErrorNumber="41667"  /* &1 inv†lida! */
                        &ErrorType="EMS":U    /* help: &1 deve ser diferente de &2 */
                        &ErrorSubType="ERROR":U
                        &ErrorParameters="c-char-aux + '~~~~' + RETURN-VALUE"}
                END.
                IF  natur-oper.tipo-compra <> 1 AND natur-oper.tipo-compra <> 4 THEN DO: /* tipo compra n∆o Ç "Normal" ou "Material agregado" */
                    {method/svc/errors/inserr.i 
                        &ErrorNumber="52928"
                        &ErrorType="EMS":U
                        &ErrorSubType="ERROR":U}
                END.
            END.
            ELSE DO:
                {method/svc/errors/inserr.i 
                    &ErrorNumber="33405"  /* Natureza de operaá∆o &1 n∆o cadastrada! */
                    &ErrorType="EMS":U 
                    &ErrorSubType="ERROR":U
                    &ErrorParameters="RowObject.nat-operacao"}
            END.    
        END.
        /****************************************/

        /** Validaá‰es do Item Serviáo **/
        IF  RowObject.cod-item-serv <> "" THEN DO:
            FOR FIRST item FIELDS(tipo-contr)
                WHERE item.it-codigo = RowObject.cod-item-serv NO-LOCK:
            END.

            IF AVAIL item THEN DO:
                IF  item.tipo-contr <> 4 THEN DO: /* N∆o Ç controle dÇbito direto */
                    {utp/ut-liter.i Item_informado *}
                    ASSIGN c-char-aux = RETURN-VALUE.
                    {utp/ut-liter.i de_controle_cont†bil_igual_a_DÇbito_Direto *}
                    {method/svc/errors/inserr.i 
                        &ErrorNumber="17167"  /* &1 deve ser &2 */
                        &ErrorType="EMS":U 
                        &ErrorSubType="ERROR":U
                        &ErrorParameters="c-char-aux + '~~~~' + RETURN-VALUE"}
                END.
            END.
            ELSE DO:
                {method/svc/errors/inserr.i 
                    &ErrorNumber="90"  /* Item &1 n∆o cadastrado */
                    &ErrorType="EMS":U 
                    &ErrorSubType="ERROR":U
                    &ErrorParameters="RowObject.cod-item-serv"}
            END.    
        END.
        /********************************/
    
        FOR FIRST param-re FIELDS (rec-out-for variacao) 
            WHERE param-re.usuario = v_cod_usuar_corren NO-LOCK:
        END.

        /** Validaá‰es do N£mero do Pedido **/
        IF  RowObject.num-pedido > 0 THEN DO:
            FOR FIRST pedido-compr FIELDS (situacao end-entrega cod-emitente)
                WHERE pedido-compr.num-pedido = RowObject.num-pedido NO-LOCK:
            END.

            IF  AVAIL pedido-compr THEN DO:
    
                IF  pedido-compr.situacao = 3 THEN DO: /*  pedido de compra com situaá∆o "Eliminado" */
                    {method/svc/errors/inserr.i
                        &ErrorNumber="7169"  /*Pedido eliminado*/
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"}
                END.

				/*
				Valida bloqueio quando estabelecimento de entrega do pedido for diferente do estabelecimento do CT-e
				Nao havera sequencia na mensagem pois na importacao do ct-e ha apenas um item
				*/
				run rep/re1008.p persistent set h-re1008.
				run pi-execute in h-re1008 (input RowObject.num-pedido,
											input TRIM(SUBSTRING(RowObject.cod-livre-2,1,5)),
											input "",
											OUTPUT TABLE RowErrors APPEND).
				delete procedure h-re1008.
				h-re1008 = ?.				
				if not can-find(first RowErrors where RowErrors.ErrorNumber = 57853) then
					IF  pedido-compr.end-entrega <> TRIM(SUBSTRING(RowObject.cod-livre-2,1,5)) THEN DO: /* Estabelecimento de entrega Ç diferente do estabelecimento da NFS-e */
						{method/svc/errors/inserr.i
							&ErrorNumber="18800" /* O estabelecimento de entrega do pedido de compra difere do estabelecimento do documento.*/
							&ErrorType="EMS"
							&ErrorSubType="WARNING"}
					END. 
					
                run rep/re1007.p (input pedido-compr.cod-emitente,
                                  input RowObject.cod-emitente,
                                  input-output table RowErrors). /* Testa se estabelecimento do pedido de compra difere do estabelecimento do documento.*/
            END.
            ELSE DO:
                {utp/ut-liter.i Pedido_de_Compra *}
                {method/svc/errors/inserr.i 
                    &ErrorNumber="7815"
                    &ErrorType="EMS":U 
                    &ErrorSubType="ERROR":U
                    &ErrorParameters="RETURN-VALUE"}
            END.
        END.
        /************************************/

        /** Validaá‰es do N£mero da Ordem de Compra **/
        IF  RowObject.numero-ordem > 0 THEN DO:
            FOR FIRST ordem-compra FIELDS (ct-codigo sc-codigo num-pedido it-codigo situacao nr-contrato numero-ordem int-1 num-seq-item qt-solic cod-estabel)
                WHERE ordem-compra.numero-ordem = RowObject.numero-ordem NO-LOCK:
            END.

            IF  AVAIL ordem-compra THEN DO:
    
                FOR FIRST param-compra  FIELDS(log-1)     NO-LOCK:
                END.
                FOR FIRST param-global  FIELDS(modulo-cn) NO-LOCK:
                END.
                FOR FIRST param-contrat FIELDS(log-1)     NO-LOCK:
                END.
    
                IF  RowObject.num-pedido > 0 AND RowObject.num-pedido <> ordem-compra.num-pedido THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="7342"  /* Ordem de compra n∆o pertence ao pedido informado. */
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"}
                END.
                IF  RowObject.cod-item-serv <> ordem-compra.it-codigo THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="15187"  /* Item da ordem n∆o confere com item da nota fiscal */
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"}
                END.
                IF  ordem-compra.situacao <> 2 THEN DO: /* A ordem de compra deve estar na situaá∆o "Confirmada" */
                    {method/svc/errors/inserr.i
                        &ErrorNumber="15188"  /* Situaá∆o da ordem n∆o permite movimentaá∆o */
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"}
                END.
                IF  param-compra.log-1 THEN DO: /* Se tem aprovaá∆o eletrìnica implantada, verifica se o pedido/cotaá∆o est† pendente de aprovaá∆o */
                    RUN cdp/cdapi172.p (INPUT 4, INPUT ROWID(ordem-compra), OUTPUT l-pendente).
                    IF  NOT l-pendente THEN
                        RUN cdp/cdapi172.p (INPUT 6, INPUT ROWID(ordem-compra), OUTPUT l-pendente).

                    IF  l-pendente THEN DO:
                        {method/svc/errors/inserr.i
                            &ErrorNumber="17022"  /* Documento esta pendente de aprovaá∆o. */
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"}
                    END.
                END.

                FOR FIRST prazo-compra FIELDS(situacao data-entrega) 
                    WHERE prazo-compra.numero-ordem = RowObject.numero-ordem 
                      AND prazo-compra.parcela      = RowObject.num-parcela NO-LOCK:
                END.
                IF AVAIL prazo-compra AND prazo-compra.situacao <> 2 THEN DO:
                    {method/svc/errors/inserr.i
                        &ErrorNumber="6897"  /* Situaá∆o da parcela n∆o permite movimentaá∆o. */
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"}
                END.
                
                IF  ordem-compra.nr-contrato <> 0 AND param-global.modulo-cn THEN DO:
                    RUN cnp/cn9174.p (ordem-compra.numero-ordem,
                                      2,  
                                      ordem-compra.int-1,
                                      0,
                                      RowObject.dt-emissao,
                                      OUTPUT de-val-aux,
                                      OUTPUT l-erro-co,
                                      OUTPUT l-contrato,
                                      OUTPUT i-total,
                                      INPUT-OUTPUT TABLE tt-erro-aux).
                                      
                    IF  l-erro-co THEN DO:
                        {method/svc/errors/inserr.i
                            &ErrorNumber="15212"  /*N∆ h† saldo liberado para o contrato*/
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"}
                    END.              
                    
                    /**** Verifica se contrato est† pendente de aprovaá∆o ****/
                    IF  param-compra.log-1 = YES AND param-contrat.log-1 = YES THEN DO:
                        ASSIGN l-pendente = NO.
                        
                        IF  ordem-compra.num-seq-item <> 0 THEN DO:                        
                            FOR FIRST contrato-for FIELDS ( nr-contrato dec-2 ) 
                                WHERE contrato-for.nr-contrato = ordem-compra.nr-contrato NO-LOCK: 
                            END.
                            
                            FOR FIRST item-contrat FIELDS ( val-total )
                                WHERE item-contrat.nr-contrato  = ordem-compra.nr-contrato
                                AND   item-contrat.num-seq-item = ordem-compra.num-seq-item NO-LOCK:
                            END.
                                
                            IF  AVAIL contrato-for AND contrato-for.dec-2 = 0 AND AVAIL item-contrat AND item-contrat.val-total = 0 THEN DO:
                                RUN cdp/cdapi172.p (8, ROWID(ordem-compra), OUTPUT l-pendente).
                            END.
                            ELSE DO:
                                RUN cdp/cdapi172.p (8, ROWID(item-contrat), OUTPUT l-pendente).
                            END.
                        END.
                        ELSE DO:  
                            FOR EACH item-contrat WHERE item-contrat.nr-contrato = ordem-compra.nr-contrato NO-LOCK:
                                RUN cdp/cdapi172.p (8, ROWID(item-contrat), OUTPUT l-pendente).
                                IF  l-pendente = YES THEN
                                    LEAVE.
                            END.
                        END.
                            
                        IF  l-pendente = YES THEN DO:
                            {method/svc/errors/inserr.i
                                &ErrorNumber="16326"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="STRING(ordem-compra.numero-ordem) + '~~~~' +
                                                  STRING(ordem-compra.it-codigo)    + '~~~~' + 
                                                  TRIM(STRING(ordem-compra.qt-solic,'>>>,>>>,>>>,>>>,>>9.9999')) + '~~~~' + 
                                                  STRING(ordem-compra.nr-contrato)  + '~~~~' + 
                                                  STRING(ordem-compra.cod-estabel)"}
                        END.
                    END.
                END.
                
                IF  NOT l-contrato THEN DO:
                    IF  AVAIL prazo-compra AND (prazo-compra.data-entrega > RowObject.dt-emissao + param-re.variacao
                                                OR prazo-compra.data-entrega < RowObject.dt-emissao - param-re.variacao) THEN DO:
                        {method/svc/errors/inserr.i
                            &ErrorNumber="18802"  /* Data de entrega da parcela est† fora da variaá∆o permitida. */
                            &ErrorType="EMS"
                            &ErrorSubType="WARNING"}
                    END.
                END. 

                IF  ordem-compra.it-codigo <> RowObject.cod-item-serv THEN DO:
                    {method/svc/errors/inserr.i
                            &ErrorNumber="52930"
                            &ErrorType="EMS"
                            &ErrorSubType="WARNING"}
                END.

            END.
            ELSE DO:
                {method/svc/errors/inserr.i 
                    &ErrorNumber="123"  /* Ordem de Compra &1 Inexistente */
                    &ErrorType="EMS":U 
                    &ErrorSubType="ERROR":U
                    &ErrorParameters="RowObject.numero-ordem"}
            END.
        END.
        /*********************************************/

        /** Validaá‰es do N£mero do Evento **/
        /*RowObject.num-evento*/
        /************************************/

        /** Validaá‰es da Discriminaá∆o do Serviáo **/
        IF  RowObject.des-narrat = "" THEN DO:
            {utp/ut-liter.i Discriminaá∆o_do_serviáo *}
            {method/svc/errors/inserr.i 
                &ErrorNumber="17677"
                &ErrorType="EMS":U 
                &ErrorSubType="ERROR":U
                &ErrorParameters="RETURN-VALUE"}
        END.
        /********************************************/
        
        /** VALIDAÄ«O CONTA CONTABIL, CENTRO DE CUSTO E UNIDADE DE NEG‡CIO**/
        IF c-origem-save = "APIREST":U 
        AND RowObject.ct-codigo <> "":U THEN DO:
            RUN validaContaCCusto.
            RUN ValidaUnidNegoc.
        END.

        
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-create-msg-ret-nfe DBOProgram 
PROCEDURE pi-create-msg-ret-nfe PRIVATE:
/*------------------------------------------------------------------------------
 Purpose: Cria uma mensagem na tabela de mensagens da NFS-e
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pchave-acesso        LIKE docto-orig-nfse.cod-chave-aces-nfse NO-UNDO.
    DEFINE INPUT PARAM pcd-erro             AS INT                                   NO-UNDO.
    DEFINE INPUT PARAM pdesc-erro           AS CHAR                                  NO-UNDO.
    DEFINE INPUT PARAM ptipo                AS INT                                   NO-UNDO.

    CREATE msg-ret-nfe.
    ASSIGN msg-ret-nfe.ch-acesso-comp-nfe = pchave-acesso
           msg-ret-nfe.idi-orig-trad      = 2
           msg-ret-nfe.dt-msg             = TODAY
           msg-ret-nfe.hr-msg             = string(TIME, "HH:MM:SS")
           msg-ret-nfe.log-ativo          = YES
           msg-ret-nfe.cd-msg             = pcd-erro
           msg-ret-nfe.texto-msg          = pdesc-erro
           msg-ret-nfe.seq-msg            = NEXT-VALUE(seq-msg-ret-nfe)
           msg-ret-nfe.tipo-msg           = ptipo
           msg-ret-nfe.usuario            = c-seg-usuario.
    release msg-ret-nfe.

    RETURN "OK":U.
END PROCEDURE .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
