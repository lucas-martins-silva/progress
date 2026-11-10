USING rep.imp.*.
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN857 2.00.00.160 } /*** "010060" 29/10/2026 09:21:34 ***/
{include/i-license-manager.i boin857 MUT}
{include/i-epc200.i boin857}

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
&GLOBAL-DEFINE DBOName BOIN857
&GLOBAL-DEFINE DBOVersion
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName item-doc-orig-nfe
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
{inbo/boin857.i RowObject}
{utp/ut-glob.i}
{cdp/cdcfgmat.i}
{cdp/cd0666.i}
{cdp/cd9590.i}
{cep/ceapi030.i}
{cdp/cd9701.i} /* Definicao/atribuicao da variavel l-mult-natur-receb -> Usa multiplas naturezas no recebimento */
{rep/reapi401.i} /* Definicao de tt do FIFO OC tt-manut-docto e tt-rat-ordem-orig-nfe */
{rep/reapi418.i} /*Defini‡Æo temp-table tt-de-para-item*/
{inbo/boin045.i tt-item-doc-imp-nfe}
{rep/rules/impostosXmlV1.i ImpostosXmlNfe}
{rep/imp/utilizaImpostosMonitor.i}

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}

DEFINE TEMP-TABLE tt-item-doc-orig-nfe-param NO-UNDO LIKE item-doc-orig-nfe
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE tt-item-fornec NO-UNDO LIKE item-fornec
       FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-rat-lote-medic-nfe-param NO-UNDO LIKE rat-lote-medic-nfe
       FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-rat-lote-medic-nfe NO-UNDO LIKE rat-lote-medic-nfe
       FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-rat-lote-medic-nfe-valid NO-UNDO LIKE rat-lote-medic-nfe
       FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-cfop NO-UNDO
       FIELD cod-cfop AS CHAR
       FIELD nat-oper AS CHAR.

DEFINE TEMP-TABLE tt-tribut-item-doc NO-UNDO LIKE item-doc-est-tribut.
DEFINE TEMP-TABLE tt-ct-trib-item-doc NO-UNDO LIKE ct-trib-item-doc-est.

DEFINE TEMP-TABLE tt-erro-contrato NO-UNDO
        FIELD i-sequen AS INTEGER
        FIELD cd-erro  AS INTEGER
        FIELD mensagem AS CHARACTER FORMAT "x(255)".

/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bf2{&TableName} FOR {&TableName}.

DEFINE BUFFER bf-natur-oper-tipo-operac FOR natur-oper.
DEFINE BUFFER bf-rat-lote-medic-nfe     FOR rat-lote-medic-nfe.
DEFINE BUFFER bf2-rat-lote-medic-nfe    FOR rat-lote-medic-nfe.
DEFINE BUFFER bf-doc-orig-nfe           FOR doc-orig-nfe.
DEFINE BUFFER bfImpostosXmlNfe          FOR ImpostosXmlNfe.

DEFINE VARIABLE c-chave-acesso    LIKE item-doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
DEFINE VARIABLE i-idi-origem      LIKE item-doc-orig-nfe.idi-orig-trad      NO-UNDO.
DEFINE VARIABLE l-pendente          AS LOGICAL                              NO-UNDO.
DEFINE VARIABLE l-receb-unid-negoc  AS LOGICAL                              NO-UNDO.
DEFINE VARIABLE de-qtd-fornec-receb AS DECIMAL                              NO-UNDO.
DEFINE VARIABLE h-cdapi024          AS HANDLE                               NO-UNDO.
DEFINE VARIABLE h-boin858           AS HANDLE                               NO-UNDO.
DEFINE VARIABLE h-boin862           AS HANDLE                               NO-UNDO.
DEFINE VARIABLE c-unid-neg-aux      AS CHARACTER                            NO-UNDO.
define variable c-item-anterior     as character                            no-undo.
define variable i-ordem-anterior    as integer                              no-undo.
DEFINE VARIABLE i-indice-cq         AS INTEGER                              NO-UNDO.
define variable i-empresa           LIKE empresa.ep-codigo                  no-undo.
DEFINE VARIABLE i-tipo-operac-enable-fields AS INTEGER                      NO-UNDO.
DEFINE VARIABLE c-fator-conversao   AS CHAR                                 NO-UNDO.
DEFINE VARIABLE str-aux             AS CHAR                                 NO-UNDO.
DEFINE VARIABLE de-relac-fat        AS DECIMAL                              NO-UNDO.
DEFINE VARIABLE c-un-comercial      AS CHAR                                 NO-UNDO.
DEFINE VARIABLE i-num-casa-dec      AS INTEGER                              NO-UNDO.
DEFINE VARIABLE h-boin178           AS HANDLE                               NO-UNDO.
DEFINE VARIABLE cChaveCompleta      AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE cNatOperacao        AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE cCtCodigo           AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE iNrOrdProdu         AS INTEGER                              NO-UNDO.
DEFINE VARIABLE iNumeroOrdem        AS INTEGER                              NO-UNDO.
DEFINE VARIABLE iParcela            AS INTEGER                              NO-UNDO.
DEFINE VARIABLE lContrat            AS LOG                                  NO-UNDO.
DEFINE VARIABLE iTotal              AS INTEGER                              NO-UNDO.
DEFINE VARIABLE cItCodigo           AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE cCodDepos           AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE lHiddenUnidNeg      AS LOGICAL                              NO-UNDO.
DEFINE VARIABLE atributoImpostoUtil AS AtributoImpostoUtil                  NO-UNDO.

DEFINE VARIABLE c-origem-save       AS CHARACTER    INIT "RE0118A":U        NO-UNDO. /* Se a origem for APIREST salva lotes tbm */

DEFINE VARIABLE l-tipoOperPermitidoImpMonitor AS LOG INIT NO NO-UNDO.
DEFINE VARIABLE lFuncaoImpostosAtivada AS LOG INIT NO NO-UNDO. // re-impto-xml-nfe

ASSIGN lFuncaoImpostosAtivada = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-re-impto-xml-nfe":U
                                                        AND funcao.ativo).

def var h_api_cta_ctbl       as handle no-undo.
def var h_api_ccusto         as handle no-undo.

def temp-table tt_log_erro no-undo
         field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Numero" column-label "Numero"
         field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
         field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistencia".

/* Vari veis conta ctbl */
def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.
/* Vari veis centro de custo */
def var v_cod_ccusto         as char   no-undo.
def var v_titulo_ccusto      as char   no-undo.
def var v_log_utz_ccusto     as log    no-undo.
DEF VAR d-qtd-lote-fabrican  AS DECIMAL NO-UNDO.

FUNCTION fnValidaQtdLotes RETURNS LOGICAL
  (INPUT p-chave AS CHAR, p-seq-item AS INTEGER, p-qtd-item AS DECIMAL) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

    ASSIGN d-qtd-lote-fabrican = 0.

    FOR EACH bf2-rat-lote-medic-nfe NO-LOCK
        WHERE bf2-rat-lote-medic-nfe.ch-acesso-comp-nfe = p-chave
          AND bf2-rat-lote-medic-nfe.idi-orig-trad      = 2
          AND bf2-rat-lote-medic-nfe.seq-item           = p-seq-item:
        ASSIGN d-qtd-lote-fabrican = d-qtd-lote-fabrican + bf2-rat-lote-medic-nfe.qtd-lote-fabrican.
    END.

    RETURN d-qtd-lote-fabrican = p-qtd-item.   /* Function return value. */

END FUNCTION.


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
         HEIGHT             = 9.96
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
DEFINE TEMP-TABLE RowErrorsSonRecord NO-UNDO LIKE RowErrors.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME





&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE alteraItemAnterior DBOProgram
PROCEDURE alteraItemAnterior :
/*------------------------------------------------------------------------------
  Purpose: Atualização de variável para controle de alteração de item
  Parameters:  pc-it-codigo: Código do item
  Notes:
------------------------------------------------------------------------------*/

    def input param pc-it-codigo like item.it-codigo no-undo.

    if c-item-anterior <> pc-it-codigo then
        assign c-item-anterior = pc-it-codigo.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaSugestaoNaturezaPelaCFOP DBOProgram
PROCEDURE validaSugestaoNaturezaPelaCFOP :
    DEFINE INPUT PARAMETER p-ch-acesso     AS CHARACTER                         NO-UNDO.
    DEFINE INPUT PARAMETER pc-cfop         AS CHARACTER                         NO-UNDO.
    DEFINE INPUT PARAMETER pc-nat-operacao AS CHARACTER                         NO-UNDO.

    DEFINE VARIABLE pNewTipoOperac AS INTEGER     NO-UNDO.

    RUN ValidaNatOperac (INPUT pc-cfop,
                         INPUT pc-nat-operacao).

    IF RETURN-VALUE <> "NOK":U THEN DO:
        RUN carregaTTcfop (INPUT p-ch-acesso,
                           OUTPUT TABLE tt-cfop).

        IF NOT CAN-FIND(FIRST tt-cfop
                        WHERE tt-cfop.nat-oper = pc-nat-operacao
                          AND tt-cfop.cod-cfop = pc-cfop) THEN DO:
            IF  tt-cfop.nat-oper <> pc-nat-operacao
            AND CAN-FIND(FIRST item-ref-nfe
                         WHERE item-ref-nfe.ch-acesso-comp-nfe  = p-ch-acesso) THEN DO:
                FOR EACH item-doc-orig-nfe NO-LOCK
                   WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = p-ch-acesso
                     AND item-doc-orig-nfe.idi-orig-trad      = 2
                     AND item-doc-orig-nfe.cod-cfop           = pc-cfop:

                    EMPTY TEMP-TABLE tt-item-doc-orig-nfe-param.
                    CREATE tt-item-doc-orig-nfe-param.
                    BUFFER-COPY item-doc-orig-nfe TO tt-item-doc-orig-nfe-param.
                    RUN setNatOperacao (INPUT pc-nat-operacao).
                    RUN atualizaTipoOperacao (INPUT TABLE tt-item-doc-orig-nfe-param,
                                              OUTPUT pNewTipoOperac).

                    RUN ValidaNaturezadeTerceiro (INPUT p-ch-acesso,
                                                  INPUT item-doc-orig-nfe.seq-item,
                                                  INPUT tt-cfop.nat-oper,
                                                  INPUT pc-nat-operacao,
                                                  INPUT item-doc-orig-nfe.int-2,
                                                  INPUT pNewTipoOperac).

                    IF CAN-FIND(FIRST RowErrors) THEN
                        RETURN "NOK":U.

                END.
            END.
            ELSE DO:

                IF tt-cfop.nat-oper <> pc-nat-operacao  THEN DO:
                   FOR EACH item-doc-orig-nfe NO-LOCK
                      WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = p-ch-acesso
                        AND item-doc-orig-nfe.idi-orig-trad      = 2
                        AND item-doc-orig-nfe.cod-cfop           = pc-cfop:

                       EMPTY TEMP-TABLE tt-item-doc-orig-nfe-param.
                       CREATE tt-item-doc-orig-nfe-param.
                       BUFFER-COPY item-doc-orig-nfe TO tt-item-doc-orig-nfe-param.
                       RUN setNatOperacao (INPUT pc-nat-operacao).
                       RUN atualizaTipoOperacao (INPUT TABLE tt-item-doc-orig-nfe-param,
                                                 OUTPUT pNewTipoOperac).

                       RUN ValidaNfCreditoDebito (INPUT p-ch-acesso,
                                                  INPUT pc-nat-operacao,                /* p-nat-oper-new */
                                                  INPUT item-doc-orig-nfe.int-2,     /* p-tp-oper-old  */
                                                  INPUT pNewTipoOperac).                /* p-tp-oper-new  */
                       IF CAN-FIND(FIRST RowErrors) THEN
                          RETURN "NOK":U.
                   END.
                END.
            END.
        END.
    END.
    .

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaNaturezaPelaCFOP DBOProgram
PROCEDURE atualizaNaturezaPelaCFOP :
/*------------------------------------------------------------------------------
  Purpose: Atualiza a natureza de opera‡Æo de todos os itens do documento que possu¡em
  CFOP igual a informada

  Parameters:
  p-ch-acesso     : Chave de acesso
  pc-cfop         : CFOP
  pc-nat-operacao : Natureza de operacao

  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-ch-acesso     LIKE doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAMETER pc-cfop         AS CHARACTER                         NO-UNDO.
    DEFINE INPUT PARAMETER pc-nat-operacao AS CHARACTER                         NO-UNDO.
    DEFINE INPUT PARAMETER pl-atualiza-dados-considerados AS LOGICAL            NO-UNDO.

    DEFINE VARIABLE oTipoOperacaoUtil      AS rep.utils.TipoOperacaoUtil        NO-UNDO.
    DEFINE VARIABLE i-tipo-operacao        AS INTEGER                           NO-UNDO.
    DEFINE VARIABLE l-contrato             AS LOGICAL                           NO-UNDO.
    DEFINE VARIABLE i-total                AS INTEGER                           NO-UNDO.
    DEFINE VARIABLE h-boin045              AS HANDLE                            NO-UNDO.

    ASSIGN oTipoOperacaoUtil = new rep.utils.TipoOperacaoUtil().
    ASSIGN i-tipo-operacao = oTipoOperacaoUtil:defaultTipoOper(input pc-nat-operacao).
    DELETE OBJECT oTipoOperacaoUtil NO-ERROR.

    FOR FIRST bf-natur-oper-tipo-operac FIELDS(tp-oper-terc tipo-compra transf terceiros nota-rateio idi-tip-devol-consig)
        WHERE bf-natur-oper-tipo-operac.nat-operacao = pc-nat-operacao NO-LOCK:
    END.
    for each item-doc-orig-nfe exclusive-lock
       where item-doc-orig-nfe.ch-acesso-comp-nfe = p-ch-acesso
         and item-doc-orig-nfe.idi-orig-trad      = 2
         and item-doc-orig-nfe.cod-cfop           = pc-cfop:
        ASSIGN item-doc-orig-nfe.nat-operacao = pc-nat-operacao
               item-doc-orig-nfe.int-2        = i-tipo-operacao. /* Tipo operacao (item-doc-orig-nfe.int-2) */

        /*** L¢gica para evitar que os campos de pedido e ordem de compra fiquem preenchidos em notas de devolu‡Æo de cliente ***/
        IF  (   item-doc-orig-nfe.int-2 = 2  /*Devolu‡Æo de Cliente*/
            OR item-doc-orig-nfe.int-2 = 23) /*Nota cr‚dito/d‚bito*/
        AND item-doc-orig-nfe.numero-ordem <> 0 THEN DO:

           RUN findOrdemCompra (INPUT item-doc-orig-nfe.numero-ordem).
           RUN validaContratoOrdem (OUTPUT l-contrato, OUTPUT i-total).

           /* Desalocar o saldo das ordens de compra. */
           IF i-total = 0 THEN
               RUN pi-aloca-ordem-cc (INPUT NO, /* Desaloca. */
                                      INPUT item-doc-orig-nfe.numero-ordem,
                                      INPUT item-doc-orig-nfe.parcela,
                                      INPUT item-doc-orig-nfe.qtd-interna).

           ASSIGN item-doc-orig-nfe.numero-ordem = 0
                  item-doc-orig-nfe.num-pedido   = 0
                  item-doc-orig-nfe.parcela      = 0
                  item-doc-orig-nfe.encerra-pa   = NO.
        END.

    end.


    IF c-origem-save = "APIREST":U THEN DO:
        RUN atualizaTipoOperNaturDocto (INPUT p-ch-acesso).

        IF lFuncaoImpostosAtivada THEN DO:
            RUN inbo/boin045.p PERSISTENT SET h-boin045.

            for each item-doc-orig-nfe no-lock
               where item-doc-orig-nfe.ch-acesso-comp-nfe = p-ch-acesso
                 and item-doc-orig-nfe.idi-orig-trad      = 2:

                RUN utilizaImpostosMonitorTipoOperacao (INPUT item-doc-orig-nfe.int-2,
                                                        OUTPUT l-tipoOperPermitidoImpMonitor).

                if l-tipoOperPermitidoImpMonitor AND
                   item-doc-orig-nfe.cod-cfop = pc-cfop THEN DO:
                    EMPTY TEMP-TABLE RowObject.
                    CREATE RowObject.
                    BUFFER-COPY item-doc-orig-nfe TO RowObject.

                    RUN updateCalculoSistema (INPUT h-boin045).

                    if pl-atualiza-dados-considerados then
                        RUN updateDadosConsiderados (INPUT h-boin045).
                end.
            end.
        END.
    END.

    IF NOT CAN-FIND(FIRST RowErrors) THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="57079"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="INFORMATION":U}
    END.

    return "OK":U.

    FINALLY:
        DELETE PROCEDURE h-boin045 NO-ERROR.
        ASSIGN h-boin045 = ?.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaTipoOperNaturDocto DBOProgram
PROCEDURE atualizaTipoOperNaturDocto  :
    DEFINE INPUT  PARAMETER p-chave-acesso LIKE item-doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.

    FOR FIRST bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.ch-acesso-comp-nfe = p-chave-acesso
          AND bf{&TableName}.idi-orig-trad      = 2:

        FIND FIRST doc-orig-nfe EXCLUSIVE-LOCK
             WHERE doc-orig-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
               AND doc-orig-nfe.idi-orig-trad      = bf{&TableName}.idi-orig-trad   NO-ERROR.
        IF AVAIL doc-orig-nfe THEN
            ASSIGN doc-orig-nfe.cod-natur-operac = bf{&TableName}.nat-operacao
                   doc-orig-nfe.idi-tip-operac   = bf{&TableName}.int-2.
        FIND FIRST doc-orig-nfe NO-LOCK
             WHERE doc-orig-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
               AND doc-orig-nfe.idi-orig-trad      = bf{&TableName}.idi-orig-trad NO-ERROR.
    END.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaTipoOperPelaNatur DBOProgram
PROCEDURE atualizaTipoOperPelaNatur  :
/*------------------------------------------------------------------------------
  Purpose: Atualiza o tipo operacao pela natureza informada
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-chave-acesso LIKE item-doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE VARIABLE oTipoOperacaoUtil      AS rep.utils.TipoOperacaoUtil             NO-UNDO.

    ASSIGN oTipoOperacaoUtil = new rep.utils.TipoOperacaoUtil().

    FOR EACH item-doc-orig-nfe
       WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = p-chave-acesso
         AND item-doc-orig-nfe.idi-orig-trad      = 2 EXCLUSIVE-LOCK:
        /* Caso tenha natureza, mas nao tenha sido traduzido o tipo operacao(notas antigas)*/
        IF  item-doc-orig-nfe.nat-operacao <> "":U
        AND item-doc-orig-nfe.int-2 = 0 THEN DO:
            ASSIGN item-doc-orig-nfe.int-2 = oTipoOperacaoUtil:defaultTipoOper(input item-doc-orig-nfe.nat-operacao).
        END.
    END.

    DELETE OBJECT oTipoOperacaoUtil NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaNatureza DBOProgram
PROCEDURE atualizaNatureza  :
/*------------------------------------------------------------------------------
  Purpose: Atualiza natureza de operacao do item da nota de devolucao
           com a natureza complementar da nota de saida.
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-chave-acesso LIKE item-doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT  PARAMETER p-seq-item     LIKE item-doc-orig-nfe.seq-item NO-UNDO.
    DEFINE INPUT  PARAMETER pcNatOperacao  LIKE item-doc-orig-nfe.nat-operacao NO-UNDO.

    FOR FIRST bf{&TableName}
        WHERE bf{&TableName}.ch-acesso-comp-nfe = p-chave-acesso
          AND bf{&TableName}.seq-item           = p-seq-item
          AND bf{&TableName}.idi-orig-trad      = 2 EXCLUSIVE-LOCK:
        ASSIGN bf{&TableName}.nat-operacao = pcNatOperacao.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE alteraItens DBOProgram
PROCEDURE alteraItens :
/*------------------------------------------------------------------------------
  Purpose: Altera‡Æo de itens do documento
  Parameters:  pch-acesso-comp-nfe: Chave de acesso do documento
               tt-erro: Temp-table com erros ocorridos durante a altera‡Æo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pch-acesso-comp-nfe LIKE item-doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE de-indice              AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE l-sugere-depos-localiz AS LOGICAL     NO-UNDO.
    define variable i-total-aux     as int      no-undo.
    define variable l-contrato-aux  as log      no-undo.
    DEFINE VARIABLE h-reapi418      AS HANDLE      NO-UNDO.

    EMPTY TEMP-TABLE RowErrors.
    assign i-total-aux = 0.

    if not valid-handle(h-boin862)
    or h-boin862:type      <> "PROCEDURE":U
    or h-boin862:file-name <> "inbo/boin862.p":U then
        run inbo/boin862.p persistent set h-boin862.

    RUN openQueryStatic IN h-boin862 (INPUT "Main":U) NO-ERROR.
    RUN getFirst IN h-boin862.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    ELSE DO:
        RUN getLogField IN h-boin862 (INPUT "log-suger-depos-localiz":U, OUTPUT l-sugere-depos-localiz).
    END.

    RUN rep/reapi418.p PERSISTENT SET h-reapi418.


    FOR FIRST doc-orig-nfe FIELDS (cod-emitente cod-estabel)
        WHERE doc-orig-nfe.ch-acesso-comp-nfe = pch-acesso-comp-nfe
          AND doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK:
    END.

    /** DE-PARA DO CàDIGO DO ITEM **/
    FOR EACH {&TableName} FIELDS (it-codigo ch-acesso-comp-nfe seq-item qtd-interna)
        WHERE {&TableName}.ch-acesso-comp-nfe = pch-acesso-comp-nfe
          AND {&TableName}.idi-orig-trad      = 1 NO-LOCK:  /* Registro Original (XML) */

        FOR FIRST bf{&TableName} EXCLUSIVE-LOCK
            WHERE bf{&TableName}.ch-acesso-comp-nfe = {&TableName}.ch-acesso-comp-nfe
              AND bf{&TableName}.idi-orig-trad      = 2  /* Registro Traduzido */
              AND bf{&TableName}.seq-item           = {&TableName}.seq-item:

            RUN pi-inicializa-tt IN h-reapi418.
            RUN setCodEstabel     IN  h-reapi418 (INPUT doc-orig-nfe.cod-estabel ).
            RUN setCodEmitente    IN  h-reapi418 (INPUT doc-orig-nfe.cod-emitente).
            RUN setItCodigo       IN  h-reapi418 (INPUT bf{&TableName}.it-codigo).  /* Registro traduzido*/
            RUN setItCodigoDoForn IN  h-reapi418 (INPUT {&TableName}.it-codigo).    /* Registro Original (XML) */
            RUN setUnidCOmercial  IN  h-reapi418 (INPUT bf{&TableName}.un-comercial).
            RUN pDeparaItem       IN  h-reapi418.
            RUN getTtDeParaItem   IN  h-reapi418 (OUTPUT TABLE tt-de-para-item).

            /* NÆo necessita validar a parcela pois a mesma ‚ buscada       **
            ** durante a pr¢pria aloca‡Æo do saldo pela pi-aloca-ordem-cc.  */
            if  bf{&TableName}.numero-ordem <> 0 then do:
                run findOrdemCompra     (input bf{&TableName}.numero-ordem).
                run validaContratoOrdem (output l-contrato-aux,
                                         output i-total-aux    ).
            end.

            FIND FIRST tt-de-para-item NO-LOCK NO-ERROR.
            IF AVAIL tt-de-para-item  THEN DO:

                /* Inicializa a variavel com o item que estava informado antes da conversao. **
                ** A ordem nao e alterada no De-Para, entao deve ser inicializada com o      **
                ** mesmo valor da ordem disponivel para que nao influencie na validacao.     */
                assign c-item-anterior  = bf{&TableName}.it-codigo
                       i-ordem-anterior = if avail ordem-compra then
                                              bf{&TableName}.numero-ordem
                                          else
                                              i-ordem-anterior. /* Mantem o valor inicial da variavel. */
                FIND FIRST ITEM WHERE ITEM.it-codigo = tt-de-para-item.it-codigo NO-LOCK NO-ERROR.
                IF AVAIL ITEM THEN DO:
                    /* FO TDLBCK - Desaloca a quantidade anterior do saldo da OC.   */
                    if i-total-aux = 0 then
                        run pi-desaloca-ordem-compra.

                    ASSIGN bf{&TableName}.it-codigo    = tt-de-para-item.it-codigo
                           bf{&TableName}.un-comercial = tt-de-para-item.unid-med-for
                           bf{&TableName}.qtd-interna  = IF item.fraciona
                                                         THEN (bf{&TableName}.qtd-comercial / tt-de-para-item.indice)
                                                         ELSE TRUNCATE((bf{&TableName}.qtd-comercial / tt-de-para-item.indice),0)
                           bf{&TableName}.un-interna   = item.un. /* Efetiva a sugestao da unidade do item traduzido. */


                    /* FO TDLBCK - Aloca a quantidade convertida no saldo da OC.    */
                    /* Se o documento tiver ordem informada para outro item que     **
                    ** nao o traduzido pela item-fornec, o saldo vai ser realocado  **
                    ** naquela ordem. Entretanto, qualquer movimentacao que o       **
                    ** usuario tente fazer com essa ordem sera ou bloqueada pelo    **
                    ** erro "Item da ordem invalido" ou corrigida pela propria      **
                    ** logica de alocacao/desalocadao de saldo do conversor.        */
                    if i-total-aux = 0 then
                        run pi-aloca-ordem-compra.

                    /*Atualiza a quantidade do lote igual a nossa quantidade - TUTATW*/
                    FOR EACH rat-lote-medic-nfe NO-LOCK
                       WHERE rat-lote-medic-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
                         AND rat-lote-medic-nfe.idi-orig-trad      = 1
                         AND rat-lote-medic-nfe.seq-item           = bf{&TableName}.seq-item:

                        FOR FIRST bf-rat-lote-medic-nfe EXCLUSIVE-LOCK
                            WHERE bf-rat-lote-medic-nfe.ch-acesso-comp-nfe = rat-lote-medic-nfe.ch-acesso-comp-nfe
                              AND bf-rat-lote-medic-nfe.idi-orig-trad      = 2
                              AND bf-rat-lote-medic-nfe.seq-item           = rat-lote-medic-nfe.seq-item
                              AND bf-rat-lote-medic-nfe.num-seq-rat        = rat-lote-medic-nfe.num-seq-rat:
                            ASSIGN bf-rat-lote-medic-nfe.qtd-lote-fabrican = IF item.fraciona
                                                                             THEN (rat-lote-medic-nfe.qtd-lote-fabrican / tt-de-para-item.indice)
                                                                             ELSE TRUNCATE((rat-lote-medic-nfe.qtd-lote-fabrican / tt-de-para-item.indice),0).
                        END.
                        RELEASE bf-rat-lote-medic-nfe.
                    END.
                END.
                if l-sugere-depos-localiz
                and ( AVAIL tt-de-para-item AND  tt-de-para-item.it-codigo  <> "") THEN DO:
                    /* Posiciona ordem de compra para sugestao do deposito. */
                    if not avail ordem-compra then
                        run findOrdemCompra (input bf{&TableName}.numero-ordem).

                    RUN setConstraintTipoOperEnableFields (INPUT  bf{&TableName}.int-2). // idi-tipo-operac
                    run retornaDeposLocaliz (input bf{&TableName}.ch-acesso-comp-nfe,
                                             INPUT tt-de-para-item.it-codigo,
                                             input bf{&TableName}.nat-operacao,
                                             input-output bf{&TableName}.cod-depos,
                                             input-output bf{&TableName}.cod-localiz).

                END.
                /* Sugere a classifica‡Æo fiscal caso esta esteja vazia. */
                if trim(replace(bf{&TableName}.class-fiscal, ".", "")) = "" then
                    run retornaClassFisc(input bf{&TableName}.it-codigo,
                                         output bf{&TableName}.class-fiscal).
            end.
            ELSE DO:
                /* CD0902 - Fatores Conversao */
                FIND tab-conv-un  WHERE tab-conv-un.un           = bf{&TableName}.un-interna
                                    AND tab-conv-un.unid-med-for = bf{&TableName}.un-comercial NO-LOCK NO-ERROR.
                IF AVAIL tab-conv-un then do:
                    if trim(bf{&TableName}.it-codigo) = "" then
                        assign de-indice = 1.
                    else
                        assign de-indice = tab-conv-un.fator-conver /
                               if tab-conv-un.num-casa-dec = 0 then 1
                               else exp(10,tab-conv-un.num-casa-dec).

                    /* FO TDLBCK - Desaloca a quantidade anterior do saldo da OC.   */
                    if i-total-aux = 0 then
                        run pi-desaloca-ordem-compra.

                    assign bf{&TableName}.qtd-interna  = bf{&TableName}.qtd-comercial / de-indice.

                    /* FO TDLBCK - Aloca a quantidade convertida no saldo da OC.    */
                    if i-total-aux = 0 then
                        run pi-aloca-ordem-compra.
                end.
                ELSE DO:

                    IF bf{&TableName}.int-2 <> 3 THEN DO: /* Tipo Operacao diferente de transferencia */
                        {method/svc/errors/inserr.i &ErrorNumber="57058"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U
                                                    &ErrorParameters="{&TableName}.it-codigo + '~~~~' + bf{&TableName}.un-comercial  + '~~~~' + STRING({&TableName}.seq-item)"}
                    END.
                END.

            END. /* else do: */

            Assign bf{&TableName}.preco-unit = (bf{&TableName}.preco-total / bf{&TableName}.qtd-comercial).

            /* Verifica se soma das quantidades dos lotes igual … quantidade do item depois da conversÆo */
            IF ITEM.tipo-con-est = 2 OR ITEM.tipo-con-est = 3 THEN DO: /* N£mero de s‚rie ou lote */

                ASSIGN d-qtd-lote-fabrican = 0.

                FOR EACH bf2-rat-lote-medic-nfe NO-LOCK
                   WHERE bf2-rat-lote-medic-nfe.ch-acesso-comp-nfe = pch-acesso-comp-nfe
                     AND bf2-rat-lote-medic-nfe.idi-orig-trad      = 2
                     AND bf2-rat-lote-medic-nfe.seq-item           = bf{&TableName}.seq-item:
                   ASSIGN d-qtd-lote-fabrican = d-qtd-lote-fabrican + bf2-rat-lote-medic-nfe.qtd-lote-fabrican.
                END.

                IF NOT fnValidaQtdLotes( pch-acesso-comp-nfe, bf{&TableName}.seq-item, bf{&TableName}.qtd-interna) THEN DO:

                    {method/svc/errors/inserr.i &ErrorNumber="55780"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="bf{&TableName}.seq-item"}
                END.
            END.

            RELEASE bf{&TableName}.
        END. /* FOR FIRST bf{&TableName} */

    END. /* FOR EACH {&TableName} */

    IF NOT CAN-FIND(FIRST RowErrors) THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="52007"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="INFORMATION":U}
    END.

    IF  VALID-HANDLE(h-boin862)        AND
        h-boin862:TYPE = "PROCEDURE":U AND
        h-boin862:FILE-NAME = "inbo/boin862.p":U THEN DO:
        DELETE PROCEDURE h-boin862.
        ASSIGN h-boin862 = ?.
    END.
    IF VALID-HANDLE(h-reapi418) THEN DO:
        DELETE PROCEDURE  h-reapi418.
        ASSIGN h-reapi418 = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE alteraOrdemAnterior DBOProgram
PROCEDURE alteraOrdemAnterior :
/*------------------------------------------------------------------------------
  Purpose: Controle de ordem de compra alterada no conversor
  Parameters:  pi-numero-ordem: Número da ordem de compra
  Notes:
------------------------------------------------------------------------------*/

    def input param pi-numero-ordem like ordem-compra.numero-ordem no-undo.

    if i-ordem-anterior <> pi-numero-ordem then
        assign i-ordem-anterior = pi-numero-ordem.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaDataEntrega DBOProgram
PROCEDURE calculaDataEntrega :
/*------------------------------------------------------------------------------
  Purpose: Calcula data de entrega
  Parameters: pinumero-ordem: N£mero da ordem de compra
              piDtEntrega: Data de entrega.
  Notes:
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pinumero-ordem  LIKE ordem-compra.numero-ordem NO-UNDO.
    DEF OUTPUT PARAM piDtEntrega     AS CHAR                        NO-UNDO.

    DEF VAR i-cont                   AS INT   NO-UNDO.

    ASSIGN i-cont = 0.
    for each prazo-compra
        where prazo-compra.situacao     = 2
        and   prazo-compra.numero-ordem = pinumero-ordem no-lock:

        ASSIGN i-cont = i-cont + 1.

        if  i-cont = 1 then
            assign piDtEntrega = string(prazo-compra.data-entrega,"99/99/9999").
        else do:
            assign piDtEntrega = "PARCELADA".
            leave.
        end.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaPrecoOC DBOProgram
PROCEDURE calculaPrecoOC :
/*------------------------------------------------------------------------------
  Purpose: Retorna o pre‡o unit rio do item atrav‚s de sua ordem compra.
  Parameters:  r-ordem-compra: Rowid da ordem de compra
               r-item:         Rowid do item
               p-dt-emissao:   Data de emissÆo
               de-preco-ordem: Pre‡o da ordem
  Notes:
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM r-ordem-compra AS ROWID   NO-UNDO.
    DEF INPUT  PARAM r-item         AS ROWID   NO-UNDO.
    DEF INPUT  PARAM p-dt-emissao   AS DATE    NO-UNDO.
    DEF OUTPUT PARAM de-preco-ordem AS DECIMAL NO-UNDO.

    def var de-val-contrato         as decimal no-undo.
    def var de-val-formula          as decimal no-undo.
    def var de-taxa                 as decimal no-undo.
    def var de-preco-cc             as decimal no-undo.
    def var de-desconto-cc          as decimal no-undo.
    def var de-val-aux              as decimal no-undo.
    DEF VAR da-dt-emis              AS DATE    NO-UNDO.

    FOR FIRST ordem-compra
        WHERE ROWID(ordem-compra) = r-ordem-compra NO-LOCK:
    END.

    FOR FIRST bf{&TableName}
        WHERE ROWID(bf{&TableName}) = r-item NO-LOCK:
    END.

    if  not avail item-doc-orig-nfe
    or  not avail ordem-compra then
        return "NOK":U.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    IF da-dt-emis = ? THEN
        assign da-dt-emis = p-dt-emissao.

    /*  C lculo Pre‡o Unit rio */
    run rep/re1908.p (rowid(ordem-compra),
                      da-dt-emis,
                      output de-preco-cc,
                      output de-desconto-cc,
                      output de-taxa).


    if  param-global.modulo-cn
    and ordem-compra.nr-contrato <> 0
    and avail RowObject then do:
        run cnp/cn9060.p (INPUT bf{&TableName}.int-1,
                          ?,
                          ordem-compra.numero-ordem,
                          0,
                          no,
                          bf{&TableName}.qtd-interna,
                          p-dt-emissao,
                          output de-val-contrato,
                          output de-val-aux,
                          output de-val-formula,
                          output de-val-aux).
        if  de-val-formula > 0 then
            assign de-preco-cc = de-val-formula.
        else
            if  de-val-contrato > 0 then
                assign de-preco-cc = de-val-contrato.
    end.

    assign de-preco-ordem = de-preco-cc - de-desconto-cc.

    if  de-qtd-fornec-receb > 0 then
        assign de-preco-ordem = ( de-preco-ordem + de-desconto-cc ) * de-qtd-fornec-receb.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaQtdSaldo DBOProgram
PROCEDURE calculaQtdSaldo :
/*------------------------------------------------------------------------------
  Purpose: Calcula quantidade de saldo da ordem de compra
  Parameters: l-cons-dt-entrega:   Consulta com data na data de entrega
              l-calcula-qtd-saldo: Consulta da quantidade de saldo
              r-rowid-ordem:       Rowid da ordem de compra
              de-qtd-rec-forn:     Quantidade a receber UM (Fornecedor)
              de-qtd-receber:      Quantidade a receber (UM interna)
  Notes:
------------------------------------------------------------------------------*/
    def input  param l-cons-dt-entrega      as logical no-undo.
    def input  param l-calcula-qtd-saldo    as logical no-undo.
    def input  param p-numero-ordem         as INT     no-undo.
    def output param de-qtd-rec-forn        as decimal no-undo.
    def output param de-qtd-receber         as decimal no-undo.

    def var de-indice-aux                   as decimal no-undo.


    for each prazo-compra
       where prazo-compra.numero-ordem = p-numero-ordem
         and prazo-compra.situacao     =  2                 /* CONFIRMADA */
         and ( prazo-compra.quant-saldo - prazo-compra.dec-1 ) > 0 no-lock
       break by parcela:


        if  first(parcela) then
            assign de-indice-aux = prazo-compra.qtd-sal-forn
                                 / prazo-compra.quant-saldo
                   de-indice-aux = if  de-indice-aux = 0 or de-indice-aux = ? then 1
                                   else de-indice-aux.


        if  l-cons-dt-entrega
        and not l-calcula-qtd-saldo
        and ( prazo-compra.data-entrega > docum-est.dt-trans + param-re.variacao) then
            next.

        /* DIMINUI QUANTIDADE ALOCADA PARA CALCULAR A QUANTIDADE A RETORNAR.*/
        assign de-qtd-receber = de-qtd-receber
                                    + ( prazo-compra.quant-saldo - prazo-compra.dec-1 ).
    end.

    /* Calcula Quantidade a Receber na Unidade Medida do Fornecedor */
    assign de-qtd-rec-forn = de-qtd-receber * de-indice-aux.

    /* Atualiza Quantidade para Calculo Preco Total */
    if  not l-calcula-qtd-saldo then
        assign de-qtd-fornec-receb = de-qtd-rec-forn.


    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields DBOProgram
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     retornar se campo deve ou nÆo ser habilitado
  Parameters:  pFieldName   -> atributo da tabela item-doc-orig-nfe
               pFieldEnable -> habilita ou nÆo o atributo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldEnable AS LOGICAL   NO-UNDO.

    DEFINE VARIABLE l-habilita-item AS LOGICAL     NO-UNDO.
	DEFINE VARIABLE l-tipo-operac-terc AS LOGICAL NO-UNDO.

    IF NOT AVAIL doc-orig-nfe THEN
        RETURN "NOK":U.

    /* Retorna se tipo operacao ‚ terceiros */
    RUN verificaTipoOperacaoTerceiros(INPUT i-tipo-operac-enable-fields,
                                      OUTPUT l-tipo-operac-terc).

    /*Inicio Ponto UPC - Nissin - Chamado TVNA57*/

    for each tt-epc exclusive-lock
        WHERE tt-epc.cod-event = "after-habilita-campos" :
        delete tt-epc.
    end.

    create tt-epc.
    assign tt-epc.cod-event     = "after-habilita-campos"
           tt-epc.cod-parameter = "pFieldName"
           tt-epc.val-parameter = string(pFieldName).

    {include/i-epc201.i "after-habilita-campos"}

    find first tt-epc no-lock
         WHERE tt-epc.cod-event     = "after-habilita-campos"
           AND tt-epc.cod-parameter = "Retorno-upc"
           AND tt-epc.val-parameter = "NOK" no-error.
    IF AVAIL tt-epc THEN
        RETURN "NOK":U.

    /*Fim Ponto UPC - Nissin - Chamado TVNA57*/

    CASE pFieldName:
        WHEN "it-codigo":U THEN DO:

            if not valid-handle(h-boin862)
                or h-boin862:type      <> "PROCEDURE":U
                or h-boin862:file-name <> "inbo/boin862.p":U then
                    run inbo/boin862.p persistent set h-boin862.

            RUN openQueryStatic IN h-boin862 (INPUT "Main":U) NO-ERROR.
            RUN getFirst IN h-boin862.

            IF RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.
            ELSE DO:
                RUN getLogField IN h-boin862 (INPUT "log-habilita-item":U, OUTPUT l-habilita-item).
            END.

            ASSIGN pFieldEnable = l-habilita-item.

            IF  VALID-HANDLE(h-boin862)        AND
                h-boin862:TYPE = "PROCEDURE":U AND
                h-boin862:FILE-NAME = "inbo/boin862.p":U THEN DO:
                DELETE PROCEDURE h-boin862.
                ASSIGN h-boin862 = ?.
            END.
        END.

        WHEN "numero-ordem":U OR
        WHEN "num-pedido":U OR
        WHEN "int-1":U  /* evento */  THEN DO:
            IF pFieldName = "int-1":U AND NOT param-global.modulo-cn THEN DO:
                ASSIGN pFieldEnable = NO.
                RETURN "OK":U.
            END.
            ASSIGN pFieldEnable = i-tipo-operac-enable-fields = 0  /* Nao definido */
                                  OR  (i-tipo-operac-enable-fields <> 3 /* tranferencia */
                                  AND ((i-tipo-operac-enable-fields  = 6 OR NOT l-tipo-operac-terc)     /* i-tipo-operac-enable-fields => Entrada Consignada */
                                  OR (i-tipo-operac-enable-fields = 4 AND l-tipo-operac-terc)) /* Remessa e Retorno de beneficiamento e Opera‡Æo com terceiros CLS - 211220*/
                                  AND (i-tipo-operac-enable-fields <> 18 AND i-tipo-operac-enable-fields <> 19  /*NÆo informa ordem/pedido p/ Dep. Fechado*/
                                  AND  i-tipo-operac-enable-fields <> 20 AND i-tipo-operac-enable-fields <> 21) /*NÆo informa ordem/pedido p/ Armaz. Geral*/
                                  AND  i-tipo-operac-enable-fields <> 2 /* NÆo informa ordem/pedido para devolu‡Æo de cliente. */
                                  AND  i-tipo-operac-enable-fields <> 23 //nota cr‚dito/d‚bito
                                  AND  param-global.modulo-cc).
        END.
        WHEN "encerra-pa":U THEN DO:
            ASSIGN pFieldEnable = AVAIL param-re
                                  AND param-re.encerra-cc
                                  AND (i-tipo-operac-enable-fields  =  0  /* Nao definido */
                                  OR  (i-tipo-operac-enable-fields  <> 3 /* tranferencia */
                                  AND ((i-tipo-operac-enable-fields =  6  OR NOT l-tipo-operac-terc) /* i-tipo-operac-enable-fields => Entrada Consignada */
                                  OR  (i-tipo-operac-enable-fields  =  4  AND l-tipo-operac-terc)) /* Remessa e Retorno de beneficiamento e Opera‡Æo com terceiros CLS - 211220*/
                                  AND (i-tipo-operac-enable-fields  <> 18 AND i-tipo-operac-enable-fields <> 19  /*NÆo informa ordem/pedido p/ Dep. Fechado*/
                                  AND  i-tipo-operac-enable-fields  <> 20 AND i-tipo-operac-enable-fields <> 21) /*NÆo informa ordem/pedido p/ Armaz. Geral*/
                                  AND  i-tipo-operac-enable-fields  <> 2 /* NÆo informa ordem/pedido para devolu‡Æo de cliente. */
                                  AND  i-tipo-operac-enable-fields  <> 23 ) //nota cr‚dito/d‚bito
                                  AND  param-global.modulo-cc).
        END.
        WHEN "log-fifo-oc":U THEN DO:
            IF i-tipo-operac-enable-fields = 0 THEN /* Nao definido */
                RETURN "NOK":U.

            ASSIGN pFieldEnable = AVAIL param-re
                                  AND param-re.log-1  /*Fifo*/
                                  AND i-tipo-operac-enable-fields <> 3 /* tranferencia */
                                  AND i-tipo-operac-enable-fields <> 10 /* rateio */
                                  AND (i-tipo-operac-enable-fields = 6 OR NOT l-tipo-operac-terc) /* i-tipo-operac-enable-fields => Entrada Consignada */
                                  AND (i-tipo-operac-enable-fields <> 18 AND i-tipo-operac-enable-fields <> 19  /*NÆo informa ordem/pedido p/ Dep. Fechado*/
                                  AND  i-tipo-operac-enable-fields <> 20 AND i-tipo-operac-enable-fields <> 21) /*NÆo informa ordem/pedido p/ Armaz. Geral*/
                                  AND i-tipo-operac-enable-fields <> 2 /* nÆo informa FIFO para devolu‡Æo de cliente. */
                                  AND  i-tipo-operac-enable-fields <> 23 //nota cr‚dito/d‚bito
                                  AND param-global.modulo-cc.
        END.
        WHEN "qtd-interna":U THEN DO:
            IF i-tipo-operac-enable-fields = 0 THEN /* Nao definido */
                RETURN "NOK":U.

            ASSIGN pFieldEnable = i-tipo-operac-enable-fields <> 3 /* tranferencia */
                                  AND (NOT l-tipo-operac-terc OR i-tipo-operac-enable-fields <> 12 /*reajuste preco*/).
        END.
        WHEN "preco-unit":U THEN DO:
            IF i-tipo-operac-enable-fields = 0 THEN /* Nao definido */
                RETURN "NOK":U.
            ASSIGN pFieldEnable = i-tipo-operac-enable-fields <> 3  /* Transferˆncia */
                                  AND( NOT l-tipo-operac-terc OR
                                      (AVAIL natur-oper AND INT(SUBSTR(natur-oper.char-2,36,5)) = 1) OR /* Altera Valor Itens Terceiros */
                                       NOT CAN-DO("5,7,8,9", STRING(i-tipo-operac-enable-fields)) )  /* Retorno Benef, Fatura Consig, Devolu‡Æo Consig, Devolu‡Æo Consig Simbol */
                                  AND AVAIL param-re
                                  AND param-re.preco-unit.
        END.
        WHEN "preco-total":U THEN DO:
            IF i-tipo-operac-enable-fields = 0 THEN /* Nao definido */
                RETURN "NOK":U.

            ASSIGN pFieldEnable = i-tipo-operac-enable-fields <> 3  /* Transferˆncia */
                                  AND( NOT l-tipo-operac-terc OR
                                      (AVAIL natur-oper AND INT(SUBSTR(natur-oper.char-2,36,5)) = 1) OR /* Altera Valor Itens Terceiros */
                                       NOT CAN-DO("5,7,8,9", STRING(i-tipo-operac-enable-fields)) ).  /* Retorno Benef, Fatura Consig, Devolu‡Æo Consig, Devolu‡Æo Consig Simbol */
        END.
        WHEN "class-fiscal":U THEN
            ASSIGN pFieldEnable =      AVAIL param-re
                                  AND (   param-re.pd-cf-item
                                       OR (AVAIL ITEM AND ITEM.tipo-contr = 4)).
        WHEN "nr-ord-produ":U THEN DO:
            IF i-tipo-operac-enable-fields = 0 THEN /* Nao definido */
                RETURN "NOK":U.

            ASSIGN pFieldEnable =     ( param-global.modulo-cp   OR param-global.modulo-mi )AND
                                      ( NOT l-tipo-operac-terc OR NOT CAN-DO("7,12", STRING(i-tipo-operac-enable-fields))) AND /* 7 - Fat. Consig.  12- Reaj. Preco, 23 - Nota de cr‚dito e d‚bito*/
                                        i-tipo-operac-enable-fields <> 23 /*nota cr‚dito/d‚bito*/ .
        END.
        /* Habilita natureza complementar para as notas de transferencia. */
        when "c-nat-oper-comp":U then
            assign pFieldEnable = IF AVAIL natur-oper THEN natur-oper.transf ELSE NO.

        WHEN "cod-unid-negoc":U THEN
            ASSIGN pFieldEnable =  no.
    END CASE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hiddenFields DBOProgram
PROCEDURE hiddenFields :
/*------------------------------------------------------------------------------
  Purpose:     retornar se campo deve ou nÆo aparecer em tela
  Parameters:  pFieldName   -> atributo da tabela item-doc-orig-nfe
               pFieldHidden -> esconde ou nÆo o atributo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldHidden AS LOGICAL   NO-UNDO.

    CASE pFieldName:
        WHEN "nat-oper-comp":U THEN DO:
            ASSIGN pFieldHidden = l-mult-natur-receb. /* Se usa multiplas naturezas no recebimento esconde a natureza complementar */
        END.
    END CASE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaTipoOperacaoTerceiros DBOProgram
PROCEDURE verificaTipoOperacaoTerceiros:
/*------------------------------------------------------------------------------
  Purpose: Retorna se o tipo operacao ‚ de terceiros
  Parameters:  l-terceiros : Indica se ‚ terceiros
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM pi-tipo-operac AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAM l-terceiros    AS LOGICAL NO-UNDO.

    ASSIGN l-terceiros = pi-tipo-operac = 4   /*Entrada Beneficiamento    */
                      OR pi-tipo-operac = 5   /*Retorno Beneficiamento    */
                      OR pi-tipo-operac = 6   /*Entrada Consignada        */
                      OR pi-tipo-operac = 7   /*Fatura Consignada         */
                      OR pi-tipo-operac = 8   /*Devolucao Consignada      */
                      OR pi-tipo-operac = 9   /*Devolucao Consignada Simb */
                      OR pi-tipo-operac = 12. /*Reajuste Preco            */

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableEncerraPa DBOProgram
PROCEDURE enableEncerraPa :
/*------------------------------------------------------------------------------
  Purpose: Retorna se deve habilitar o campo encerra parcela
  Parameters: pi-numero-ordem: numero da ordem de compra
              pi-num-seq-event: numero do evento
              pl-enable : Indica se habilita ou nÆo
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
                              INPUT-OUTPUT TABLE tt-erro).
        END.

        RUN enableFields (INPUT "encerra-pa":U, OUTPUT pl-enable).

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFieldsContrEstItem DBOProgram
PROCEDURE enableFieldsContrEstItem :
/*------------------------------------------------------------------------------
  Purpose: Controle para habilitar/desabilitar campos com base na situa‡Æo do item
  Parameters: pc-it-codigo:         C¢digo do item
              pl-habilita-refer:    Indica se a referˆncia deve ser habilitada
              pl-habilita-depos:    Indica se o dep¢sito deve ser habilitado
              pl-habilita-localiz:  Indica se a localiza‡Æo deve ser habilitada
              pl-habilita-lote:     Indica se o lote deve ser habilitado
              pl-habilita-validade: Indica se a validade deve ser habilitada


  Notes:
------------------------------------------------------------------------------*/
    define input  param pc-it-codigo         like item-doc-orig-nfe.it-codigo   no-undo.
    define output param pl-habilita-refer    as log                             no-undo.
    DEFINE OUTPUT PARAM pl-habilita-depos    AS LOG                             NO-UNDO.
    DEFINE OUTPUT PARAM pl-habilita-localiz  AS LOG                             NO-UNDO.
    define output param pl-habilita-lote     as log                             no-undo.
    define output param pl-habilita-validade as log                             no-undo.

    def var c-cod-localiz as char no-undo.

    find first item no-lock
        where item.it-codigo = pc-it-codigo no-error.
    if avail item then do:
        IF i-tipo-operac-enable-fields = 23 /*nota cr‚dito/debito*/  THEN DO:
           assign pl-habilita-refer    = NO
                  pl-habilita-lote     = NO
                  pl-habilita-validade = NO
                  pl-habilita-depos    = NO
                  pl-habilita-localiz  = NO.
        END.
        ELSE DO:

            assign pl-habilita-refer    = item.tipo-con-est =  4
                   pl-habilita-lote     = item.tipo-con-est <> 1
                   pl-habilita-validade = can-do("3,4",string(item.tipo-con-est))
                   pl-habilita-depos    = YES
                   pl-habilita-localiz  = YES.


            RUN sugereLocalizUnica (INPUT pc-it-codigo,
                                    OUTPUT c-cod-localiz).
            ASSIGN pl-habilita-localiz = RETURN-VALUE <> "YES":U. /* Retorno YES quer dizer que é localizacao unica, se localizacao unica deve ficar desabilitado */
        END.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableUnidNeg DBOProgram
PROCEDURE enableUnidNeg :
/*------------------------------------------------------------------------------
  Purpose: Habilitar/Desabilitar Unidade de neg¢cio
  Parameters: pi-nr-ord-produ: N£mero da ordem de produ‡Æo
              pi-tipo-nota: Tipo de nota
              pc-conta-contabil: Conta cont bil
              l-habilita: Indica se o campo de unidade de neg¢cio deve ou nÆo ser habilitado

  Notes:
------------------------------------------------------------------------------*/

    def input  param pi-nr-ord-produ    as int          no-undo.
    def input  param pi-tipo-nota       as int          no-undo.
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

    case pi-tipo-nota:

        /* Tratamento para recebimento de notas de compra  */
        when 1 /* Compra */ then do:

            /*** Se nÆo utiliza unidade de neg¢cio, ou o usuario do recebimento nÆo permite atualiza‡Æo,
                 nÆo habilita o campo ***/
            if  not l-mat-unid-negoc
            or  not l-receb-unid-negoc then do:
                assign l-habilita = no.
            end.
            else do:

                /* Se foi informada ordem de produ‡Æo, ir  habilitar o campo apenas se
                   a fun‡Æo EMS2-UNIDADE-NEGOCIO NÇO estiver ativa.
                   Se a fun‡Æo estiver ativa, a UNeg vir  da ordem e nÆo poder  ser alterada */
                if  pi-nr-ord-produ <> 0 then do:
                    assign l-habilita = not l-unidade-negocio.
                end.
                else do:
                    /* NÆo foi informada ordem de produ‡Æo, verifica se foi informada conta cont bil */

                    /* Material permanecer  no estoque, nÆo foi informada a conta -> UNeg nÆo habilitada.
                       Se foi informada a conta, somente habilita se o usuario do receb. permite informar UNeg. */
                    if  pc-conta-contabil = "" then do:
                        assign l-habilita = no.
                    end.
                    else do:
                        assign l-habilita = l-receb-unid-negoc.
                    end.
                end.
            end.
        end. /* tipo de nota: Compra */

        when 3 /* Transferˆncia */ then do:

            /* Se foi informada ordem de produ‡Æo, nÆo habilita a UNeg. */
            if  pi-nr-ord-produ <> 0 then
                assign l-habilita = no.
            else do:
                /* NÆo foi informada ordem de produ‡Æo, verifica se foi informada conta cont bil */

                /* Material permanecer  no estoque, nÆo foi informada a conta -> UNeg nÆo habilitada.
                   Se foi informada a conta, somente habilita se o usuario do receb. permite informar UNeg. */
                if  pc-conta-contabil = "" then
                    assign l-habilita = no.
                else
                    assign l-habilita = l-receb-unid-negoc
                                        and l-unidade-negocio. /* Somente habilita se o usuario permite alterar
                                                                                     e a fun‡Æo est  ativa */
            end.
        end.

        /* Na engenharia nÆo menciona nenhum tratamento espec¡fico para habilitar ou nÆo o campo unidade de negocio qdo
           a nota ‚ de rateio. Ser  assumido que nÆo habilita, uma vez que ‚ feito um tratamento atrav‚s do prog. re2904. */
        when 9 /* Rateio */ then
            assign l-habilita = no.

        otherwise
            l-habilita = no.

    end case.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findEmpresa DBOProgram
PROCEDURE findEmpresa :
/*------------------------------------------------------------------------------
  Purpose: Buscar a empresa do documento
  Parameters: pc-ch-acesso-comp-nfe: Chave de acesso do documento
              pi-ep-codigo: C¢digo da empresa

  Notes:
------------------------------------------------------------------------------*/

    def input  param pc-ch-acesso-comp-nfe  as char no-undo.
    def output param pi-ep-codigo           LIKE empresa.ep-codigo  no-undo.

    for first doc-orig-nfe no-lock
        where doc-orig-nfe.ch-acesso-comp-nfe = pc-ch-acesso-comp-nfe
        and   doc-orig-nfe.idi-orig-trad      = 2:

        find first estabelec no-lock
            where estabelec.cod-estabel = doc-orig-nfe.cod-estabel no-error.
        if avail estabelec then
            run cdp/cd9970.p (input rowid(estabelec),
                              output pi-ep-codigo).
        else pi-ep-codigo = i-ep-codigo-usuario.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findOrdemCompra DBOProgram
PROCEDURE findOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose: Buscar a ordem de compra
  Parameters: pi-numero-ordem: N£mero da ordem de compra
  Notes:
------------------------------------------------------------------------------*/

    def input param pi-numero-ordem as int no-undo.

    for first ordem-compra no-lock
        where ordem-compra.numero-ordem = pi-numero-ordem:
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintTipoOperEnableFields DBOProgram
PROCEDURE setConstraintTipoOperEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     Recebe tipo opera‡Æo da tela re0118a
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-tipo-oper AS INTEGER NO-UNDO.

    ASSIGN i-tipo-operac-enable-fields = pi-tipo-oper.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findTabelasByChaveAcesso DBOProgram
PROCEDURE findTabelasByChaveAcesso :
    DEFINE INPUT PARAMETER pChaveAcesso AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER pNatOper     AS CHAR  NO-UNDO.
    DEFINE INPUT PARAMETER pItem        AS CHAR  NO-UNDO.

    FOR FIRST doc-orig-nfe WHERE doc-orig-nfe.ch-acesso-comp-nfe = pChaveAcesso
                             AND doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK:
        RUN findTabelas (INPUT ROWID(doc-orig-nfe),
                         INPUT pNatOper,
                         INPUT pItem).
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findTabelas DBOProgram
PROCEDURE findTabelas :
/*------------------------------------------------------------------------------
  Purpose:     Inicializar tabelas para procedure enableFields
  Parameters:  prParent -> rowid tabela doc-orig-nfe (PAI)
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prParent AS ROWID NO-UNDO.
    DEFINE INPUT PARAMETER pNatOper AS CHAR  NO-UNDO.
    DEFINE INPUT PARAMETER pItem    AS CHAR  NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    FOR FIRST doc-orig-nfe NO-LOCK
        WHERE ROWID(doc-orig-nfe) = prParent:
    END.

    FOR FIRST natur-oper FIELDS (nota-rateio transf tp-oper-terc terceiros char-2 tipo-compra)
        WHERE natur-oper.nat-operacao = pNatOper NO-LOCK:
    END.

    FOR FIRST param-re FIELDS (preco-unit pd-cf-item log-1 rec-out-for aceita-var
                               log-pedir-unid-negoc encerra-cc)
        WHERE param-re.usuario = c-seg-usuario NO-LOCK :
    END.

    FOR FIRST ITEM
        WHERE ITEM.it-codigo = pItem NO-LOCK:
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
        WHEN "aliq-cofins-cst":U THEN ASSIGN pFieldValue = RowObject.aliq-cofins-cst.
        WHEN "aliq-pis-cst":U THEN ASSIGN pFieldValue = RowObject.aliq-pis-cst.
        WHEN "ano-fab":U THEN ASSIGN pFieldValue = RowObject.ano-fab.
        WHEN "ano-mod":U THEN ASSIGN pFieldValue = RowObject.ano-mod.
        WHEN "ano-mes-apuracao":U THEN ASSIGN pFieldValue = RowObject.ano-mes-apuracao.
        WHEN "ch-acesso-comp-nfe":U THEN ASSIGN pFieldValue = RowObject.ch-acesso-comp-nfe.
        WHEN "class-ipi":U THEN ASSIGN pFieldValue = RowObject.class-ipi.
        WHEN "cmkg":U THEN ASSIGN pFieldValue = RowObject.cmkg.
        WHEN "cnpj-produtor":U THEN ASSIGN pFieldValue = RowObject.cnpj-produtor.
        WHEN "cod-cfop":U THEN ASSIGN pFieldValue = RowObject.cod-cfop.
        WHEN "cod-chassi":U THEN ASSIGN pFieldValue = RowObject.cod-chassi.
        WHEN "cod-codif":U THEN ASSIGN pFieldValue = RowObject.cod-codif.
        WHEN "cod-cond-veic":U THEN ASSIGN pFieldValue = RowObject.cod-cond-veic.
        WHEN "cod-cor-veic":U THEN ASSIGN pFieldValue = RowObject.cod-cor-veic.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-ean":U THEN ASSIGN pFieldValue = RowObject.cod-ean.
        WHEN "cod-ean-trib":U THEN ASSIGN pFieldValue = RowObject.cod-ean-trib.
        WHEN "cod-enq-ipi":U THEN ASSIGN pFieldValue = RowObject.cod-enq-ipi.
        WHEN "cod-ext-ipi":U THEN ASSIGN pFieldValue = RowObject.cod-ext-ipi.
        WHEN "cod-genero":U THEN ASSIGN pFieldValue = RowObject.cod-genero.
        WHEN "cod-lista-serv-iss":U THEN ASSIGN pFieldValue = RowObject.cod-lista-serv-iss.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-marca-mod":U THEN ASSIGN pFieldValue = RowObject.cod-marca-mod.
        WHEN "cod-ncm":U THEN ASSIGN pFieldValue = RowObject.cod-ncm.
        WHEN "cod-prod-anp":U THEN ASSIGN pFieldValue = RowObject.cod-prod-anp.
        WHEN "cod-selo-ipi":U THEN ASSIGN pFieldValue = RowObject.cod-selo-ipi.
        WHEN "cod-sit-trib-ipi":U THEN ASSIGN pFieldValue = RowObject.cod-sit-trib-ipi.
        WHEN "cod-sit-trib-ipi-int":U THEN ASSIGN pFieldValue = RowObject.cod-sit-trib-ipi-int.
        WHEN "cod-unid-negoc":U THEN ASSIGN pFieldValue = RowObject.cod-unid-negoc.
        WHEN "cod-vin":U THEN ASSIGN pFieldValue = RowObject.cod-vin.
        WHEN "cod-cest":U THEN ASSIGN pFieldValue = SUBSTRING(RowObject.char-1,10,20).
        WHEN "cofins-int-cst":U THEN ASSIGN pFieldValue = RowObject.cofins-int-cst.
        WHEN "cofins-outros-cst":U THEN ASSIGN pFieldValue = RowObject.cofins-outros-cst.
        WHEN "cofins-qtd-cst":U THEN ASSIGN pFieldValue = RowObject.cofins-qtd-cst.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "desc-cor-veic":U THEN ASSIGN pFieldValue = RowObject.desc-cor-veic.
        WHEN "desc-item":U THEN ASSIGN pFieldValue = RowObject.desc-item.
        WHEN "dist-eixos":U THEN ASSIGN pFieldValue = RowObject.dist-eixos.
        WHEN "esp-veiculo":U THEN ASSIGN pFieldValue = RowObject.esp-veiculo.
        WHEN "icms-cst[1]":U THEN ASSIGN pFieldValue = RowObject.icms-cst[1].
        WHEN "icms-cst[2]":U THEN ASSIGN pFieldValue = RowObject.icms-cst[2].
        WHEN "icms-cst[3]":U THEN ASSIGN pFieldValue = RowObject.icms-cst[3].
        WHEN "icms-cst[4]":U THEN ASSIGN pFieldValue = RowObject.icms-cst[4].
        WHEN "icms-cst[5]":U THEN ASSIGN pFieldValue = RowObject.icms-cst[5].
        WHEN "icms-cst[6]":U THEN ASSIGN pFieldValue = RowObject.icms-cst[6].
        WHEN "icms-cst[7]":U THEN ASSIGN pFieldValue = RowObject.icms-cst[7].
        WHEN "icms-cst[8]":U THEN ASSIGN pFieldValue = RowObject.icms-cst[8].
        WHEN "icms-cst[9]":U THEN ASSIGN pFieldValue = RowObject.icms-cst[9].
        WHEN "icms-mod-bc[1]":U THEN ASSIGN pFieldValue = RowObject.icms-mod-bc[1].
        WHEN "icms-mod-bc[2]":U THEN ASSIGN pFieldValue = RowObject.icms-mod-bc[2].
        WHEN "icms-mod-bc[3]":U THEN ASSIGN pFieldValue = RowObject.icms-mod-bc[3].
        WHEN "icms-mod-bc[4]":U THEN ASSIGN pFieldValue = RowObject.icms-mod-bc[4].
        WHEN "icms-mod-bc[5]":U THEN ASSIGN pFieldValue = RowObject.icms-mod-bc[5].
        WHEN "icms-mod-bc[6]":U THEN ASSIGN pFieldValue = RowObject.icms-mod-bc[6].
        WHEN "icms-orig[1]":U THEN ASSIGN pFieldValue = RowObject.icms-orig[1].
        WHEN "icms-orig[2]":U THEN ASSIGN pFieldValue = RowObject.icms-orig[2].
        WHEN "icms-orig[3]":U THEN ASSIGN pFieldValue = RowObject.icms-orig[3].
        WHEN "icms-orig[4]":U THEN ASSIGN pFieldValue = RowObject.icms-orig[4].
        WHEN "icms-orig[5]":U THEN ASSIGN pFieldValue = RowObject.icms-orig[5].
        WHEN "icms-orig[6]":U THEN ASSIGN pFieldValue = RowObject.icms-orig[6].
        WHEN "icms-orig[7]":U THEN ASSIGN pFieldValue = RowObject.icms-orig[7].
        WHEN "icms-orig[8]":U THEN ASSIGN pFieldValue = RowObject.icms-orig[8].
        WHEN "icms-orig[9]":U THEN ASSIGN pFieldValue = RowObject.icms-orig[9].
        WHEN "icms10-mod-bc-st":U THEN ASSIGN pFieldValue = RowObject.icms10-mod-bc-st.
        WHEN "icms30-mod-bc-st":U THEN ASSIGN pFieldValue = RowObject.icms30-mod-bc-st.
        WHEN "icms70-mod-bc-st":U THEN ASSIGN pFieldValue = RowObject.icms70-mod-bc-st.
        WHEN "icms70-mod-bc-st-1":U THEN ASSIGN pFieldValue = RowObject.icms70-mod-bc-st-1.
        WHEN "icms90-mod-bc-st":U THEN ASSIGN pFieldValue = RowObject.icms90-mod-bc-st.
        WHEN "inf-complementar":U THEN ASSIGN pFieldValue = RowObject.inf-complementar.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "num-motor":U THEN ASSIGN pFieldValue = RowObject.num-motor.
        WHEN "num-serie":U THEN ASSIGN pFieldValue = RowObject.num-serie.
        WHEN "peso-bruto":U THEN ASSIGN pFieldValue = RowObject.peso-bruto.
        WHEN "peso-liq":U THEN ASSIGN pFieldValue = RowObject.peso-liq.
        WHEN "pis-int-cst":U THEN ASSIGN pFieldValue = RowObject.pis-int-cst.
        WHEN "pis-outros-cst":U THEN ASSIGN pFieldValue = RowObject.pis-outros-cst.
        WHEN "pis-qtd-cst":U THEN ASSIGN pFieldValue = RowObject.pis-qtd-cst.
        WHEN "pot-cm3":U THEN ASSIGN pFieldValue = RowObject.pot-cm3.
        WHEN "pot-motor":U THEN ASSIGN pFieldValue = RowObject.pot-motor.
        WHEN "qtd-selo-ipi":U THEN ASSIGN pFieldValue = RowObject.qtd-selo-ipi.
        WHEN "renavam":U THEN ASSIGN pFieldValue = RowObject.renavam.
        WHEN "tp-combustivel":U THEN ASSIGN pFieldValue = RowObject.tp-combustivel.
        WHEN "tp-oper-veic":U THEN ASSIGN pFieldValue = RowObject.tp-oper-veic.
        WHEN "tp-pintura":U THEN ASSIGN pFieldValue = RowObject.tp-pintura.
        WHEN "tp-veiculo":U THEN ASSIGN pFieldValue = RowObject.tp-veiculo.
        WHEN "uf-cons":U THEN ASSIGN pFieldValue = RowObject.uf-cons.
        WHEN "un-comercial":U THEN ASSIGN pFieldValue = RowObject.un-comercial.
        WHEN "un-trib":U THEN ASSIGN pFieldValue = RowObject.un-trib.
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
        WHEN "aliq-cofins":U THEN ASSIGN pFieldValue = RowObject.aliq-cofins.
        WHEN "aliq-cofins-outros":U THEN ASSIGN pFieldValue = RowObject.aliq-cofins-outros.
        WHEN "aliq-cofins-st":U THEN ASSIGN pFieldValue = RowObject.aliq-cofins-st.
        WHEN "aliq-ipi":U THEN ASSIGN pFieldValue = RowObject.aliq-ipi.
        WHEN "aliq-iss":U THEN ASSIGN pFieldValue = RowObject.aliq-iss.
        WHEN "aliq-pis":U THEN ASSIGN pFieldValue = RowObject.aliq-pis.
        WHEN "aliq-pis-outros":U THEN ASSIGN pFieldValue = RowObject.aliq-pis-outros.
        WHEN "aliq-pis-st":U THEN ASSIGN pFieldValue = RowObject.aliq-pis-st.
        WHEN "icms-aliq[1]":U THEN ASSIGN pFieldValue = RowObject.icms-aliq[1].
        WHEN "icms-aliq[2]":U THEN ASSIGN pFieldValue = RowObject.icms-aliq[2].
        WHEN "icms-aliq[3]":U THEN ASSIGN pFieldValue = RowObject.icms-aliq[3].
        WHEN "icms-aliq[4]":U THEN ASSIGN pFieldValue = RowObject.icms-aliq[4].
        WHEN "icms-aliq[5]":U THEN ASSIGN pFieldValue = RowObject.icms-aliq[5].
        WHEN "icms-aliq[6]":U THEN ASSIGN pFieldValue = RowObject.icms-aliq[6].
        WHEN "icms-base[1]":U THEN ASSIGN pFieldValue = RowObject.icms-base[1].
        WHEN "icms-base[2]":U THEN ASSIGN pFieldValue = RowObject.icms-base[2].
        WHEN "icms-base[3]":U THEN ASSIGN pFieldValue = RowObject.icms-base[3].
        WHEN "icms-base[4]":U THEN ASSIGN pFieldValue = RowObject.icms-base[4].
        WHEN "icms-base[5]":U THEN ASSIGN pFieldValue = RowObject.icms-base[5].
        WHEN "icms-base[6]":U THEN ASSIGN pFieldValue = RowObject.icms-base[6].
        WHEN "icms-valor[1]":U THEN ASSIGN pFieldValue = RowObject.icms-valor[1].
        WHEN "icms-valor[2]":U THEN ASSIGN pFieldValue = RowObject.icms-valor[2].
        WHEN "icms-valor[3]":U THEN ASSIGN pFieldValue = RowObject.icms-valor[3].
        WHEN "icms-valor[4]":U THEN ASSIGN pFieldValue = RowObject.icms-valor[4].
        WHEN "icms-valor[5]":U THEN ASSIGN pFieldValue = RowObject.icms-valor[5].
        WHEN "icms-valor[6]":U THEN ASSIGN pFieldValue = RowObject.icms-valor[6].
        WHEN "icms10-aliq-icms-st":U THEN ASSIGN pFieldValue = RowObject.icms10-aliq-icms-st.
        WHEN "icms10-perc-red-bc-icms-st":U THEN ASSIGN pFieldValue = RowObject.icms10-perc-red-bc-icms-st.
        WHEN "icms10-perc-vl-adic-icms":U THEN ASSIGN pFieldValue = RowObject.icms10-perc-vl-adic-icms.
        WHEN "icms10-vl-bc-st":U THEN ASSIGN pFieldValue = RowObject.icms10-vl-bc-st.
        WHEN "icms10-vl-st":U THEN ASSIGN pFieldValue = RowObject.icms10-vl-st.
        WHEN "icms20-reduc-bc":U THEN ASSIGN pFieldValue = RowObject.icms20-reduc-bc.
        WHEN "icms30-aliq-icms-st":U THEN ASSIGN pFieldValue = RowObject.icms30-aliq-icms-st.
        WHEN "icms30-perc-vl-adic-icms":U THEN ASSIGN pFieldValue = RowObject.icms30-perc-vl-adic-icms.
        WHEN "icms30-red-bc-icms-st":U THEN ASSIGN pFieldValue = RowObject.icms30-red-bc-icms-st.
        WHEN "icms30-vl-bc-icms-st":U THEN ASSIGN pFieldValue = RowObject.icms30-vl-bc-icms-st.
        WHEN "icms30-vl-icms-st":U THEN ASSIGN pFieldValue = RowObject.icms30-vl-icms-st.
        WHEN "icms51-reduc-bc":U THEN ASSIGN pFieldValue = RowObject.icms51-reduc-bc.
        WHEN "icms60-vl-bc-st":U THEN ASSIGN pFieldValue = RowObject.icms60-vl-bc-st.
        WHEN "icms60-vl-st":U THEN ASSIGN pFieldValue = RowObject.icms60-vl-st.
        WHEN "icms70-aliq-st":U THEN ASSIGN pFieldValue = RowObject.icms70-aliq-st.
        WHEN "icms70-perc-margem-vl-adic":U THEN ASSIGN pFieldValue = RowObject.icms70-perc-margem-vl-adic.
        WHEN "icms70-perc-red-bc-icms-st":U THEN ASSIGN pFieldValue = RowObject.icms70-perc-red-bc-icms-st.
        WHEN "icms70-perc-reduc-bc":U THEN ASSIGN pFieldValue = RowObject.icms70-perc-reduc-bc.
        WHEN "icms70-vl-bc-st":U THEN ASSIGN pFieldValue = RowObject.icms70-vl-bc-st.
        WHEN "icms70-vl-st":U THEN ASSIGN pFieldValue = RowObject.icms70-vl-st.
        WHEN "icms90-aliq-st":U THEN ASSIGN pFieldValue = RowObject.icms90-aliq-st.
        WHEN "icms90-perc-margem-vl-adic":U THEN ASSIGN pFieldValue = RowObject.icms90-perc-margem-vl-adic.
        WHEN "icms90-perc-red-bc-icms-st":U THEN ASSIGN pFieldValue = RowObject.icms90-perc-red-bc-icms-st.
        WHEN "icms90-reduc-bc":U THEN ASSIGN pFieldValue = RowObject.icms90-reduc-bc.
        WHEN "icms90-vl-bc-st":U THEN ASSIGN pFieldValue = RowObject.icms90-vl-bc-st.
        WHEN "icms90-vl-st":U THEN ASSIGN pFieldValue = RowObject.icms90-vl-st.
        WHEN "preco-total":U THEN ASSIGN pFieldValue = RowObject.preco-total.
        WHEN "preco-unit":U THEN ASSIGN pFieldValue = RowObject.preco-unit.
        WHEN "preco-total-bruto":U THEN ASSIGN pFieldValue = RowObject.preco-total-bruto.
        WHEN "preco-unit-bruto":U THEN ASSIGN pFieldValue = RowObject.preco-unit-bruto.
        WHEN "preco-total-liquido":U THEN ASSIGN pFieldValue = RowObject.preco-total-liquido.
        WHEN "preco-unit-liquido":U THEN ASSIGN pFieldValue = RowObject.preco-unit-liquido.
        WHEN "qtd-cofins-outros":U THEN ASSIGN pFieldValue = RowObject.qtd-cofins-outros.
        WHEN "qtd-cofins-prod":U THEN ASSIGN pFieldValue = RowObject.qtd-cofins-prod.
        WHEN "qtd-cofins-st":U THEN ASSIGN pFieldValue = RowObject.qtd-cofins-st.
        WHEN "qtd-combustivel":U THEN ASSIGN pFieldValue = RowObject.qtd-combustivel.
        WHEN "qtd-comercial":U THEN ASSIGN pFieldValue = RowObject.qtd-comercial.
        WHEN "qtd-interna":U THEN ASSIGN pFieldValue = RowObject.qtd-interna.
        WHEN "qtd-pis-outros-vend":U THEN ASSIGN pFieldValue = RowObject.qtd-pis-outros-vend.
        WHEN "qtd-pis-prod-vend":U THEN ASSIGN pFieldValue = RowObject.qtd-pis-prod-vend.
        WHEN "qtd-pis-st-vend":U THEN ASSIGN pFieldValue = RowObject.qtd-pis-st-vend.
        WHEN "qtd-tot-ipi":U THEN ASSIGN pFieldValue = RowObject.qtd-tot-ipi.
        WHEN "qtd-trib":U THEN ASSIGN pFieldValue = RowObject.qtd-trib.
        WHEN "qtde-bc-prod":U THEN ASSIGN pFieldValue = RowObject.qtde-bc-prod.
        WHEN "vl-aliq-cide":U THEN ASSIGN pFieldValue = RowObject.vl-aliq-cide.
        WHEN "vl-aliq-cofins-outros":U THEN ASSIGN pFieldValue = RowObject.vl-aliq-cofins-outros.
        WHEN "vl-aliq-cofins-qtd":U THEN ASSIGN pFieldValue = RowObject.vl-aliq-cofins-qtd.
        WHEN "vl-aliq-cofins-st":U THEN ASSIGN pFieldValue = RowObject.vl-aliq-cofins-st.
        WHEN "vl-aliq-pis-outros":U THEN ASSIGN pFieldValue = RowObject.vl-aliq-pis-outros.
        WHEN "vl-aliq-pis-qtd":U THEN ASSIGN pFieldValue = RowObject.vl-aliq-pis-qtd.
        WHEN "vl-aliq-pis-st-prod":U THEN ASSIGN pFieldValue = RowObject.vl-aliq-pis-st-prod.
        WHEN "vl-bc-cofins":U THEN ASSIGN pFieldValue = RowObject.vl-bc-cofins.
        WHEN "vl-bc-cofins-outros":U THEN ASSIGN pFieldValue = RowObject.vl-bc-cofins-outros.
        WHEN "vl-bc-cofins-st":U THEN ASSIGN pFieldValue = RowObject.vl-bc-cofins-st.
        WHEN "vl-bc-icms-prop":U THEN ASSIGN pFieldValue = RowObject.vl-bc-icms-prop.
        WHEN "vl-bc-icms-st-cons":U THEN ASSIGN pFieldValue = RowObject.vl-bc-icms-st-cons.
        WHEN "vl-bc-icms-st-dest":U THEN ASSIGN pFieldValue = RowObject.vl-bc-icms-st-dest.
        WHEN "vl-bc-icms-st-prop":U THEN ASSIGN pFieldValue = RowObject.vl-bc-icms-st-prop.
        WHEN "vl-bc-ii":U THEN ASSIGN pFieldValue = RowObject.vl-bc-ii.
        WHEN "vl-bc-ipi":U THEN ASSIGN pFieldValue = RowObject.vl-bc-ipi.
        WHEN "vl-bc-iss":U THEN ASSIGN pFieldValue = RowObject.vl-bc-iss.
        WHEN "vl-bc-pis":U THEN ASSIGN pFieldValue = RowObject.vl-bc-pis.
        WHEN "vl-bc-pis-outros":U THEN ASSIGN pFieldValue = RowObject.vl-bc-pis-outros.
        WHEN "vl-bc-pis-st":U THEN ASSIGN pFieldValue = RowObject.vl-bc-pis-st.
        WHEN "vl-bruto-item":U THEN ASSIGN pFieldValue = RowObject.vl-bruto-item.
        WHEN "vl-cide":U THEN ASSIGN pFieldValue = RowObject.vl-cide.
        WHEN "vl-cofins-aliq":U THEN ASSIGN pFieldValue = RowObject.vl-cofins-aliq.
        WHEN "vl-cofins-outros":U THEN ASSIGN pFieldValue = RowObject.vl-cofins-outros.
        WHEN "vl-cofins-qtd":U THEN ASSIGN pFieldValue = RowObject.vl-cofins-qtd.
        WHEN "vl-cofins-st":U THEN ASSIGN pFieldValue = RowObject.vl-cofins-st.
        WHEN "vl-desconto":U THEN ASSIGN pFieldValue = RowObject.vl-desconto.
        WHEN "vl-desp-aduaneira":U THEN ASSIGN pFieldValue = RowObject.vl-desp-aduaneira.
        WHEN "vl-frete":U THEN ASSIGN pFieldValue = RowObject.vl-frete.
        WHEN "vl-icms-prop":U THEN ASSIGN pFieldValue = RowObject.vl-icms-prop.
        WHEN "vl-icms-st-cons":U THEN ASSIGN pFieldValue = RowObject.vl-icms-st-cons.
        WHEN "vl-icms-st-dest":U THEN ASSIGN pFieldValue = RowObject.vl-icms-st-dest.
        WHEN "vl-icms-st-prop":U THEN ASSIGN pFieldValue = RowObject.vl-icms-st-prop.
        WHEN "vl-ii":U THEN ASSIGN pFieldValue = RowObject.vl-ii.
        WHEN "vl-iof":U THEN ASSIGN pFieldValue = RowObject.vl-iof.
        WHEN "vl-ipi":U THEN ASSIGN pFieldValue = RowObject.vl-ipi.
        WHEN "vl-iss":U THEN ASSIGN pFieldValue = RowObject.vl-iss.
        WHEN "vl-pis":U THEN ASSIGN pFieldValue = RowObject.vl-pis.
        WHEN "vl-pis-outros":U THEN ASSIGN pFieldValue = RowObject.vl-pis-outros.
        WHEN "vl-pis-qtd":U THEN ASSIGN pFieldValue = RowObject.vl-pis-qtd.
        WHEN "vl-pis-st":U THEN ASSIGN pFieldValue = RowObject.vl-pis-st.
        WHEN "vl-seguro":U THEN ASSIGN pFieldValue = RowObject.vl-seguro.
        WHEN "vl-unid-ipi":U THEN ASSIGN pFieldValue = RowObject.vl-unid-ipi.
        WHEN "vl-unit-comercial":U THEN ASSIGN pFieldValue = RowObject.vl-unit-comercial.
        WHEN "vl-unit-trib":U THEN ASSIGN pFieldValue = RowObject.vl-unit-trib.
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
        WHEN "cod-municipio-iss":U THEN ASSIGN pFieldValue = RowObject.cod-municipio-iss.
        WHEN "idi-orig-trad":U THEN ASSIGN pFieldValue = RowObject.idi-orig-trad.
        WHEN "num-pedido":U THEN ASSIGN pFieldValue = RowObject.num-pedido.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        WHEN "seq-item":U THEN ASSIGN pFieldValue = RowObject.seq-item.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice unico
  Parameters:
               retorna valor do campo ch-acesso-comp-nfe
               retorna valor do campo idi-orig-trad
               retorna valor do campo seq-item
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pch-acesso-comp-nfe LIKE item-doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-orig-trad LIKE item-doc-orig-nfe.idi-orig-trad NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-item LIKE item-doc-orig-nfe.seq-item NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
           pidi-orig-trad = RowObject.idi-orig-trad
           pseq-item = RowObject.seq-item.

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
        WHEN "ind-bem-movel-usado":U THEN ASSIGN pFieldValue = RowObject.ind-bem-movel-usado.
        WHEN "log-doacao":U          THEN ASSIGN pFieldValue = RowObject.log-doacao.
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
  Purpose:     Reposiciona registro com base no ¡ndice unico
  Parameters:
               recebe valor do campo ch-acesso-comp-nfe
               recebe valor do campo idi-orig-trad
               recebe valor do campo seq-item
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pch-acesso-comp-nfe LIKE item-doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAMETER pidi-orig-trad LIKE item-doc-orig-nfe.idi-orig-trad NO-UNDO.
    DEFINE INPUT PARAMETER pseq-item LIKE item-doc-orig-nfe.seq-item NO-UNDO.

    FIND FIRST bfitem-doc-orig-nfe WHERE
        bfitem-doc-orig-nfe.ch-acesso-comp-nfe = pch-acesso-comp-nfe AND
        bfitem-doc-orig-nfe.idi-orig-trad = pidi-orig-trad AND
        bfitem-doc-orig-nfe.seq-item = pseq-item NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-doc-orig-nfe THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-doc-orig-nfe)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose: Abertura da query principal do DBO
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMonitor DBOProgram
PROCEDURE openQueryMonitor :
/*------------------------------------------------------------------------------
  Purpose: Abertura da query para utiliza‡Æo no monitor do conversor
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName}
        FOR EACH {&TableName} NO-LOCK
            WHERE {&TableName}.ch-acesso-comp-nfe = c-chave-acesso
              AND {&TableName}.idi-orig-trad      = i-idi-origem  .

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-aloca-ordem-compra DBOProgram
PROCEDURE pi-aloca-ordem-compra private :
/*------------------------------------------------------------------------------
  Purpose: Aloca‡Æo de ordem de compra
------------------------------------------------------------------------------*/

    IF NOT AVAIL bf{&TableName} THEN
        RETURN "NOK":U.

    run pi-aloca-ordem-cc (input yes, /* Aloca. */
                           input bf{&TableName}.numero-ordem,
                           input bf{&TableName}.parcela,
                           input bf{&TableName}.qtd-interna).

    RETURN RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desaloca-ordem-compra DBOProgram
PROCEDURE pi-desaloca-ordem-compra private :
/*------------------------------------------------------------------------------
  Purpose: Aloca‡Æo de ordem de compra
------------------------------------------------------------------------------*/

    IF NOT AVAIL bf{&TableName} THEN
        RETURN "NOK":U.

    run pi-aloca-ordem-cc (input no, /* Desaloca. */
                           input bf{&TableName}.numero-ordem,
                           input bf{&TableName}.parcela,
                           input bf{&TableName}.qtd-interna).

    RETURN RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-aloca-ordem-cc DBOProgram
PROCEDURE pi-aloca-ordem-cc :
/*------------------------------------------------------------------------------
  Purpose: Aloca‡Æo / Desaloca‡Æo de ordem de compra
  Parameters: pl-aloca: Alocar/Desalocar ordem de compra
              pi-ordem-compra: N£mero da ordem de compra
              pi-parcela: Parcela
              pd-quant-cc: Quantidade a ser alocada/desalocada

  Notes:
------------------------------------------------------------------------------*/

    def input param pl-aloca        as logical  no-undo. /* Aloca/Desaloca  */
    def input param pi-ordem-compra as integer  no-undo.
    def input param pi-parcela      as integer  no-undo.
    def input param pd-quant-cc     as decimal  no-undo.

    define variable de-saldo-atual  as decimal no-undo.

    for first prazo-compra exclusive-lock
            where prazo-compra.numero-ordem = pi-ordem-compra
            and   prazo-compra.parcela      = pi-parcela
            and   prazo-compra.situacao     = 2:
    end.
    if not avail prazo-compra then do:
        /* Aloca na primeira parcela em aberto que ainda tenha saldo. */
        for first prazo-compra use-index ordem-sit exclusive-lock
            where prazo-compra.numero-ordem = pi-ordem-compra
            and   prazo-compra.situacao     = 2
            and   (prazo-compra.quant-saldo - prazo-compra.dec-1) > 0
            by prazo-compra.data-entrega
            by prazo-compra.numero-ordem:
        end.
        if not avail prazo-compra then
            /* Aloca na primeira parcela em aberto. */
            for first  prazo-compra use-index ordem-sit exclusive-lock
                where prazo-compra.numero-ordem = pi-ordem-compra
                and   prazo-compra.situacao     = 2:
            end.
    end.
    if  avail prazo-compra then do:

        if  pl-aloca then
            assign prazo-compra.dec-1 = prazo-compra.dec-1 + pd-quant-cc.
        else do:
            assign de-saldo-atual     = prazo-compra.dec-1
                   prazo-compra.dec-1 = prazo-compra.dec-1 - pd-quant-cc.

            if  prazo-compra.dec-1 < 0 then
                assign prazo-compra.dec-1 = 0.

        end.
    end.

    release prazo-compra.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCalculaIndice DBOProgram
PROCEDURE piCalculaIndice :
/*------------------------------------------------------------------------------
  Purpose: Calcula ¡ndice para inspe‡Æo e verifica se ela dever  ou nÆo ser realizada
  Parameters: piDepositoCQ: Retorna se o item deve ser inspesionado e dep¢sito de CQ sugerido

  Notes: Sempre retorna "yes" para tipo de controle de estoque por roteiro.
------------------------------------------------------------------------------*/
    def output param piDepositoCQ   as log  initial yes   no-undo.

    DEFINE VARIABLE i-ind              AS INTEGER                NO-UNDO.
    DEFINE VARIABLE i-tp-skip-lote-aux AS INTEGER                NO-UNDO.

    FIND FIRST item-fornec-estab
        WHERE item-fornec-estab.it-codigo    = item.it-codigo
        and   item-fornec-estab.cod-emitente = doc-orig-nfe.cod-emitente
        AND   item-fornec-estab.cod-estabel  = doc-orig-nfe.cod-estabel exclusive-lock NO-ERROR.

    if  avail param-cq
    and param-cq.tipo-cq = 3 then do:

        /* Valida se o tipo de inspecao ‚ "preferencialmente bom/¢timo/excelente. */
        if  AVAIL item-fornec-estab
        AND item-fornec-estab.tp-inspecao > 3 then do:

            ASSIGN i-ind = item-fornec-estab.tp-inspecao - 3.

            IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "lote-avancado":U AND funcao.ativo) THEN DO:
                FIND fda-param-inspec-fornec WHERE fda-param-inspec-fornec.cdn-emit = docum-est.cod-emitente NO-LOCK NO-ERROR .
                IF AVAIL fda-param-inspec-fornec THEN DO:
                    CASE item.criticidade:
                        WHEN 1 THEN do:
                            CASE i-ind:
                                WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-1.
                                WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-2.
                                WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-3.
                            END CASE.

                        END.
                        WHEN 2 THEN do:
                            CASE i-ind:
                                WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-1.
                                WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-2.
                                WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-3.
                            END CASE.
                        end.
                        WHEN 3 THEN DO:
                            CASE i-ind:
                                WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-1.
                                WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-2.
                                WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-3.
                            END CASE.
                        END.
                        OTHERWISE   assign i-indice-cq = 0.
                    END CASE.
                    ASSIGN i-tp-skip-lote-aux = fda-param-inspec-fornec.idi-tip-skip-lote.
                END.
                ELSE DO:
                    FIND emitente WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.
                    FIND fda-param-inspec WHERE fda-param-inspec.cdn-grp-emit = emitente.cod-gr-forn NO-LOCK NO-ERROR.
                    IF AVAIL fda-param-inspec THEN DO:
                        CASE item.criticidade:
                            WHEN 1 THEN do:
                                CASE i-ind:
                                    WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-1.
                                    WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-2.
                                    WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-3.
                                END CASE.
                            END.
                            WHEN 2 THEN do:
                                CASE i-ind:
                                    WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-1.
                                    WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-2.
                                    WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-3.
                                END CASE.
                            end.
                            WHEN 3 THEN DO:
                                CASE i-ind:
                                    WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-1.
                                    WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-2.
                                    WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-3.
                                END CASE.
                            END.
                            OTHERWISE   assign i-indice-cq = 0.
                        END CASE.
                        ASSIGN i-tp-skip-lote-aux = fda-param-inspec.idi-tip-skip-lote.
                    END.
                    ELSE DO:
                        CASE item.criticidade:
                            WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec-estab.tp-inspecao - 3].
                            WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec-estab.tp-inspecao - 3].
                            WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec-estab.tp-inspecao - 3].
                            OTHERWISE   assign i-indice-cq = 0.
                        END CASE.
                        ASSIGN i-tp-skip-lote-aux = param-cq.tp-skip-lot.
                    END.
                END.
            END.
            ELSE DO:
                CASE item.criticidade:
                    WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec-estab.tp-inspecao - 3].
                    WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec-estab.tp-inspecao - 3].
                    WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec-estab.tp-inspecao - 3].
                    OTHERWISE   assign i-indice-cq = 0.
                END CASE.
                ASSIGN i-tp-skip-lote-aux = param-cq.tp-skip-lot.
            END.

            if  i-tp-skip-lote-aux = 1 then
                assign piDepositoCQ = ( random(0,100) <= i-indice-cq ).
            else do:
                 assign piDepositoCQ = no.

                 if  i-indice-cq <= item-fornec-estab.niv-inspecao then
                     assign piDepositoCQ             = yes
                            item-fornec-estab.niv-inspecao = 0.
            end.
            if  not piDepositoCQ then
                assign item-fornec-estab.niv-inspecao = item-fornec-estab.niv-inspecao + 1.
        END.
    end.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaClassFisc DBOProgram
PROCEDURE retornaClassFisc :
/*------------------------------------------------------------------------------
  Purpose: Retorna classifica‡Æo fiscal do item
  Parameters: pc-it-codigo: C¢digo do item
              pc-class-fiscal: Classifica‡Æo fiscal do item
  Notes:
------------------------------------------------------------------------------*/

    define input  param pc-it-codigo    as char no-undo.
    define output param pc-class-fiscal as char no-undo.

    find first item no-lock
        where item.it-codigo = pc-it-codigo no-error.
    if avail item
    and pc-it-codigo <> "" then
        assign pc-class-fiscal = item.class-fiscal.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaContaAplicItem DBOProgram
PROCEDURE retornaContaAplicItem :
/*------------------------------------------------------------------------------
  Purpose: Retorna conta de aplica‡Æo do item
  Parameters: pc-it-codigo: C¢digo do item
              pc-ct-codigo: Conta de aplica‡Æo do item
              pc-sc-codigo: Subconta
  Notes:
------------------------------------------------------------------------------*/

    define input  param pc-it-codigo    as char no-undo.
    define output param pc-ct-codigo    as char no-undo.
    define output param pc-sc-codigo    as char no-undo.


    find first item no-lock
        where item.it-codigo = pc-it-codigo no-error.
    if avail item then
        assign pc-ct-codigo = item.ct-codigo
               pc-sc-codigo = ITEM.sc-codigo.
    else
        assign pc-ct-codigo = "":U
               pc-sc-codigo = "":U.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaContaOrdProd DBOProgram
PROCEDURE retornaContaOrdProd :
/*------------------------------------------------------------------------------
  Purpose: Retorna a conta cont bil da ordem de produ‡Æo
  Parameters: pc-numero-ordem: N£mero da ordem de compra
              pc-nr-ord-produ: N£mero da ordem de produ‡Æo
              pc-ct-codigo: Conta cont bil
              pc-sc-codigo: Sub-Conta

  Notes:
------------------------------------------------------------------------------*/

    def input        param pc-numero-ordem      as char no-undo.
    def input-output param pc-nr-ord-produ      as char no-undo.
    def input-output param pc-ct-codigo         as char no-undo.
    DEF INPUT-OUTPUT PARAM pc-sc-codigo         AS CHAR NO-UNDO.

    for first ordem-compra
        where ordem-compra.numero-ordem = int(pc-numero-ordem) no-lock:

        /* 10/05/11 - Sempre sobrepoe a OP e Conta-contabil. */
        assign pc-nr-ord-produ   = string(ordem-compra.ordem-servic)
               pc-ct-codigo = ordem-compra.ct-codigo
               pc-sc-codigo = ordem-compra.sc-codigo.

        if ordem-compra.ordem-servic <> 0 then do:
            find first ord-prod no-lock
                where ord-prod.nr-ord-produ = ordem-compra.ordem-servic no-error.
            if avail ord-prod then
                assign pc-ct-codigo = ord-prod.ct-codigo
                       pc-sc-codigo = ord-prod.sc-codigo.
        end.
    end.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDeposLocaliz DBOProgram
PROCEDURE retornaDeposLocaliz :
/*------------------------------------------------------------------------------
  Purpose: Retorna sugestÆo de dep¢sito e localiza‡Æo
  Parameters: p-ch-acesso-comp: Chave de acesso do documento
              p-it-codigo:      C¢digo do item
              p-nat-operacao:   Natureza de opera‡Æo
              p-cod-depos:      C¢digo do dep¢sito
              p-cod-localiz:    C¢digo da localiza‡Æo

  Notes:
------------------------------------------------------------------------------*/
    define input        param   p-ch-acesso-comp like   item-doc-orig-nfe.ch-acesso-comp-nfe no-undo.
    define input        param   p-it-codigo      like   item-doc-orig-nfe.it-codigo          no-undo.
    define input        param   p-nat-operacao   like   item-doc-orig-nfe.nat-operacao       no-undo.
    define input-output param   p-cod-depos      like   item-doc-orig-nfe.cod-depos          no-undo.
    define input-output param   p-cod-localiz    like   item-doc-orig-nfe.cod-localiz        no-undo.

    DEFINE VARIABLE piDepositoCQ       AS LOGICAL INITIAL NO     NO-UNDO.
    DEFINE VARIABLE i-ind              AS INTEGER                NO-UNDO.
    DEFINE VARIABLE i-tp-skip-lote-aux AS INTEGER                NO-UNDO.
    DEFINE VARIABLE h-ceapi030         AS HANDLE                 NO-UNDO.
    DEFINE VARIABLE l-sugere-lote      AS LOGICAL                NO-UNDO.
    DEFINE VARIABLE showSample         AS LOGICAL                NO-UNDO.
    DEFINE VARIABLE sampleType         AS LOGICAL                NO-UNDO.

    IF NOT (i-tipo-operac-enable-fields = 1  OR        /*Compra*/
            i-tipo-operac-enable-fields = 4  OR        /*Entrada Benef*/
            i-tipo-operac-enable-fields = 6  OR        /*Entrada Consig*/
            i-tipo-operac-enable-fields = 10 OR        /*Nota Rateio*/
            i-tipo-operac-enable-fields = 11) THEN     /*Material Agregado*/
        RETURN "NOK":U.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    for first param-cq
        fields ( tipo-cq tp-skip-lot ins-pref-x
                 ins-pref-y ins-pref-z ) NO-LOCK:
    end.

    /* So executa a sugestao de deposito se alguma informacao foi alterada ou se o deposito esta em branco. */
    if p-it-codigo <> c-item-anterior
    OR p-cod-depos = ""
    or (avail ordem-compra
        and   ordem-compra.numero-ordem <> i-ordem-anterior) then do:

        FOR FIRST item-doc-orig-nfe
            WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = p-ch-acesso-comp
            AND   idi-orig-trad = 2 NO-LOCK:
        END.

        FOR FIRST ITEM
            WHERE ITEM.it-codigo = p-it-codigo NO-LOCK:
        END.

        FOR FIRST doc-orig-nfe FIELDS (cod-emitente cod-estabel)
            WHERE doc-orig-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
            AND   doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK:
        END.

        FOR FIRST estabelec
            WHERE estabelec.cod-estabel = doc-orig-nfe.cod-estabel NO-LOCK:
        END.

        FIND first item-fornec-estab
            where  item-fornec-estab.it-codigo    = item-doc-orig-nfe.it-codigo
            and    item-fornec-estab.cod-emitente = doc-orig-nfe.cod-emitente
            and    item-fornec-estab.cod-estabel  = doc-orig-nfe.cod-estabel NO-LOCK NO-ERROR.

        FIND FIRST natur-oper
             WHERE natur-oper.nat-operacao = p-nat-operacao NO-LOCK NO-ERROR.

        IF AVAIL natur-oper
        OR i-tipo-operac-enable-fields > 0 THEN DO:

            FIND FIRST item-uni-estab
                WHERE  item-uni-estab.it-codigo = p-it-codigo
                AND    item-uni-estab.cod-estabel = doc-orig-nfe.cod-estabel NO-LOCK NO-ERROR.
            /***********************************************************************
            ****************** ORDEM DE PRIORIDADE DOS DEPOSITOS: ******************
            ************************************************************************
            ** DEPOSITO INFORMADO MANUALMENTE > DEPOSITO CQ > DEPOSITO DA ORDEM   **
            ** DE COMPRA > DEPOSITO PADRAO DO CD0140 > DEPOSITO PADRAO DO CD0138. **
            ***********************************************************************/

            /* A validacao de deposito informado manualmente foi **
            ** realizada nos pontos de chamada a essa procedure. */

            assign p-cod-depos   = if avail ordem-compra then
                                       ordem-compra.dep-almoxar /* deposito da OC. */
                                   else
                                       if avail item-uni-estab then
                                           item-uni-estab.deposito-pad
                                       else
                                           IF AVAIL ITEM THEN
                                               item.deposito-pad
                                           ELSE
                                               p-cod-depos.


            assign p-cod-localiz = if  avail item-uni-estab then
                                       item-uni-estab.cod-localiz
                                   else
                                       IF AVAIL ITEM THEN
                                           item.cod-localiz
                                       ELSE
                                           p-cod-localiz.


            if  param-global.modulo-cq                        /* Possui modulo CQ */
            and param-cq.tipo-cq > 1                          /* S¢ Gera Roteiro ou CQ Total */
            and ((AVAIL natur-oper AND NOT natur-oper.transf) OR
                 i-tipo-operac-enable-fields <> 3)            /* Nao e Transferencia */
            and avail item-uni-estab
            and item-uni-estab.contr-qualid                   /* Item possui CQ */
            and trim(item.it-codigo) <> "" then do:           /* Item deve ser codificado */


                RUN piCalculaIndice (output piDepositoCQ).

                for first item-fornec fields ( it-codigo   cod-emitente
                                              tp-inspecao niv-inspecao )
                    where item-fornec.it-codigo = item.it-codigo
                    and   item-fornec.cod-emitente = doc-orig-nfe.cod-emitente exclusive-lock.
                end.

                if not avail item-fornec-estab and avail item-fornec
                and item-fornec.tp-inspecao > 3 then

                    assign i-indice-cq = if  item.criticidade = 1
                                        then param-cq.ins-pref-x[item-fornec.tp-inspecao - 3]
                                        else
                                            if  item.criticidade = 2
                                            then param-cq.ins-pref-y[item-fornec.tp-inspecao - 3]
                                            else
                                                if  item.criticidade = 3
                                                then param-cq.ins-pref-z[item-fornec.tp-inspecao - 3]
                                                else 0.
                if not avail item-fornec-estab and avail item-fornec
                and item-fornec.tp-inspecao > 3 then do:
                    ASSIGN i-ind = item-fornec.tp-inspecao - 3.

                    IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "lote-avancado":U AND funcao.ativo) THEN DO:
                        FIND fda-param-inspec-fornec WHERE fda-param-inspec-fornec.cdn-emit = docum-est.cod-emitente NO-LOCK NO-ERROR .
                        IF AVAIL fda-param-inspec-fornec THEN DO:
                            CASE item.criticidade:
                                WHEN 1 THEN do:
                                    CASE i-ind:
                                        WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-1.
                                        WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-2.
                                        WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-3.
                                    END CASE.

                                END.
                                WHEN 2 THEN do:
                                    CASE i-ind:
                                        WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-1.
                                        WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-2.
                                        WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-3.
                                    END CASE.
                                end.
                                WHEN 3 THEN DO:
                                    CASE i-ind:
                                        WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-1.
                                        WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-2.
                                        WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-3.
                                    END CASE.
                                END.
                                OTHERWISE   assign i-indice-cq = 0.
                            END CASE.
                            ASSIGN i-tp-skip-lote-aux = fda-param-inspec-fornec.idi-tip-skip-lote.
                        END.
                        ELSE DO:
                            FIND emitente WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.
                            FIND fda-param-inspec WHERE fda-param-inspec.cdn-grp-emit = emitente.cod-gr-forn NO-LOCK NO-ERROR.
                            IF AVAIL fda-param-inspec THEN DO:
                                CASE item.criticidade:
                                    WHEN 1 THEN do:
                                        CASE i-ind:
                                            WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-1.
                                            WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-2.
                                            WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-3.
                                        END CASE.
                                    END.
                                    WHEN 2 THEN do:
                                        CASE i-ind:
                                            WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-1.
                                            WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-2.
                                            WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-3.
                                        END CASE.
                                    end.
                                    WHEN 3 THEN DO:
                                        CASE i-ind:
                                            WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-1.
                                            WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-2.
                                            WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-3.
                                        END CASE.
                                    END.
                                    OTHERWISE   assign i-indice-cq = 0.
                                END CASE.
                                ASSIGN i-tp-skip-lote-aux = fda-param-inspec.idi-tip-skip-lote.
                            END.
                            ELSE DO:
                                CASE item.criticidade:
                                    WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec.tp-inspecao - 3].
                                    WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec.tp-inspecao - 3].
                                    WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec.tp-inspecao - 3].
                                    OTHERWISE   assign i-indice-cq = 0.
                                END CASE.
                                ASSIGN i-tp-skip-lote-aux = param-cq.tp-skip-lot.
                            END.
                        END.
                    END.
                    ELSE DO:
                        CASE item.criticidade:
                            WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec.tp-inspecao - 3].
                            WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec.tp-inspecao - 3].
                            WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec.tp-inspecao - 3].
                            OTHERWISE   assign i-indice-cq = 0.
                        END CASE.
                        ASSIGN i-tp-skip-lote-aux = param-cq.tp-skip-lot.
                    END.

                    if  i-tp-skip-lote-aux = 1 then
                        assign piDepositoCQ = ( random(0,100) <= i-indice-cq ).
                    else do:
                        assign piDepositoCQ = no.

                        if  i-indice-cq <= item-fornec.niv-inspecao then
                            assign piDepositoCQ             = yes
                                   item-fornec.niv-inspecao = 0.
                    end.

                    if not piDepositoCQ then
                        assign item-fornec.niv-inspecao = item-fornec.niv-inspecao + 1.
                END.

                if avail item-fornec-estab then do:
                    if item-fornec-estab.tp-inspecao <= 3 then
                        assign piDepositoCQ = yes.
                end.
                else
                if avail item-fornec then do:
                    if item-fornec.tp-inspecao <= 3 then
                        assign piDepositoCQ = yes.
                end.
                else assign piDepositoCQ = yes.

                if avail item-fornec then
                    release item-fornec.
            END.
        END.

        IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "lote-avancado":U AND funcao.ativo) THEN DO:

            if not valid-handle(h-ceapi030) then
                run cep/ceapi030.p persistent set h-ceapi030 (input table tt-dados-fda,
                                                              output table tt-valores,
                                                              output table tt-erro).

            run pi-param-esp in h-ceapi030 (input item-doc-orig-nfe.it-codigo,
                                            input "",
                                            input doc-orig-nfe.cod-estabel,
                                            output l-sugere-lote,
                                            output showSample,
                                            output sampleType).

            if showSample then do:

                find first item-uni-estab
                    where item-uni-estab.it-codigo   = item-doc-orig-nfe.it-codigo
                    and   item-uni-estab.cod-estabel = doc-orig-nfe.cod-estabel no-lock no-error.

                if  item-doc-orig-nfe.numero-ordem <> 0 THEN DO:
                   for first ordem-compra fields ( numero-ordem dep-almoxar )
                       where ordem-compra.numero-ordem = item-doc-orig-nfe.numero-ordem no-lock.
                   end.
                END.

                assign p-cod-depos   = if avail ordem-compra then
                                           ordem-compra.dep-almoxar
                                       ELSE if  avail item-uni-estab then
                                           item-uni-estab.deposito-pad
                                       else
                                           item.deposito-pad
                       p-cod-localiz = IF NOT AVAIL ordem-compra AND NOT AVAIL item-uni-estab THEN
                                           ITEM.cod-localiz
                                       ELSE "".
            end.
            else do:

                if piDepositoCQ then
                    run buscaDepositoCQ (output p-cod-depos).
                ELSE DO:
                    find first item-uni-estab
                        where item-uni-estab.it-codigo   = item-doc-orig-nfe.it-codigo
                        and   item-uni-estab.cod-estabel = doc-orig-nfe.cod-estabel no-lock no-error.

                    if  item-doc-orig-nfe.numero-ordem <> 0 THEN DO:
                       for first ordem-compra fields ( numero-ordem dep-almoxar )
                           where ordem-compra.numero-ordem = item-doc-orig-nfe.numero-ordem no-lock.
                       end.
                    END.

                    assign p-cod-depos   = if avail ordem-compra then
                                               ordem-compra.dep-almoxar
                                           ELSE if  avail item-uni-estab then
                                               item-uni-estab.deposito-pad
                                           else
                                               item.deposito-pad
                           p-cod-localiz = IF NOT AVAIL ordem-compra AND NOT AVAIL item-uni-estab THEN
                                               ITEM.cod-localiz
                                           ELSE "".
               END.

            end.

            if valid-handle(h-ceapi030) then
                delete procedure h-ceapi030.

        END.
        ELSE DO:
            if piDepositoCQ = YES then do: /*Deve ser sugerido dep¢sito CQ*/

                RUN buscaDepositoCQ (OUTPUT p-cod-depos).
            end.
        END.

        FIND FIRST localizacao
             WHERE localizacao.cod-estab   = doc-orig-nfe.cod-estabel
               AND localizacao.cod-depos   = p-cod-depos
               AND localizacao.cod-localiz = p-cod-localiz NO-LOCK NO-ERROR.
        IF NOT AVAIL localizacao THEN DO:

            ASSIGN p-cod-localiz = ''.
        END.

        /* Atualiza as informacoes anteriores. */
        assign c-item-anterior  = item-doc-orig-nfe.it-codigo
               i-ordem-anterior = if avail ordem-compra then
                                           ordem-compra.numero-ordem
                                     else
                                           i-ordem-anterior.
    END.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaDepositoCQ DBOProgram
PROCEDURE buscaDepositoCQ :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:

  Notes:
------------------------------------------------------------------------------*/
    def output param c-cod-depos-cq like rat-lote.cod-depos no-undo.

    if not valid-handle(h-cdapi024)
        or h-cdapi024:type <> "PROCEDURE"
        or h-cdapi024:file-name <> "cdp/cdapi024.p" then do:
        run cdp/cdapi024.p persistent set h-cdapi024.
    end.

    /*Se a UN nÆo foi informada no item do documento,
      buscar  unidade de neg¢cio do relacionamento ITEM X ESTABELECIMENTO X DEPàSITO,
      se nÆo existir, retornar  UN do relacionamento ITEM X ESTABELECIMENTO. */
    if item-doc-orig-nfe.cod-unid-negoc = "" then do:

        if valid-handle(h-cdapi024) then
            run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input doc-orig-nfe.cod-estabel,
                                                               input item-doc-orig-nfe.it-codigo,
                                                               input item-doc-orig-nfe.cod-depos,
                                                               output c-unid-neg-aux).
    end.
    ELSE
        assign c-unid-neg-aux = item-doc-orig-nfe.cod-unid-negoc.

    /*Relacionamento entre UN e Estabel, para determina‡Æo dos dep¢sitos,
    se nÆo encontrar, utilizar  o dep¢sito informado para o estabelecimento*/
    find first unid-negoc-cq
        where unid-negoc-cq.cod-estabel    = doc-orig-nfe.cod-estabel
        and   unid-negoc-cq.cod-unid-negoc = c-unid-neg-aux no-lock no-error.
    if avail unid-negoc-cq then
        assign c-cod-depos-cq = unid-negoc-cq.cod-depos-cq.
    else
        assign c-cod-depos-cq = estabelec.deposito-cq.

    IF  VALID-HANDLE(h-cdapi024)        AND
        h-cdapi024:TYPE = "PROCEDURE":U AND
        h-cdapi024:FILE-NAME = "cdp/cdapi024.p":U THEN DO:
        DELETE PROCEDURE h-cdapi024.
        ASSIGN h-cdapi024 = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDescItem DBOProgram
PROCEDURE retornaDescItem :
/*------------------------------------------------------------------------------
  Purpose: Retorna a descri‡Æo do item
  Parameters: p-it-codigo: C¢digo do item
              p-desc-item: Descri‡Æo do item

  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM p-it-codigo LIKE ITEM.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAM p-desc-item LIKE ITEM.desc-item NO-UNDO.

    FOR FIRST ITEM
        WHERE ITEM.it-codigo = p-it-codigo NO-LOCK:
    END.
    IF AVAIL ITEM THEN
        ASSIGN p-desc-item = ITEM.desc-item.
    ELSE
        ASSIGN p-desc-item = "":U.

    RETURN "OK":U.

END PROCEDURE.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaNatComp DBOProgram
PROCEDURE retornaNatComp :
/*------------------------------------------------------------------------------
  Purpose: Retorna natureza complementar para notas de transferˆncia
  Parameters: p-ch-acesso-comp: Chave completa de acesso da NF-e
              p-nat-operacao:   Natureza de opera‡Æo
              p-nat-comp:       Natureza complementar da nota

  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM   p-ch-acesso-comp LIKE item-doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAM   p-nat-operacao   LIKE item-doc-orig-nfe.nat-operacao       NO-UNDO.
    DEFINE OUTPUT PARAM  p-nat-comp       LIKE natur-oper.nat-operacao              NO-UNDO.

    FOR EACH bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.ch-acesso-comp-nfe = p-ch-acesso-comp
          AND bf{&TableName}.idi-orig-trad      = 2
          AND bf{&TableName}.nat-operacao       = p-nat-operacao:

        if substr(bf{&TableName}.char-1, 1, 6) <> "" then DO:
            ASSIGN p-nat-comp = substr(bf{&TableName}.char-1, 1, 6).
            LEAVE.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaNomeEmit DBOProgram
PROCEDURE retornaNomeEmit :
/*------------------------------------------------------------------------------
  Purpose: Retorna nome do emitente
  Parameters: p-cod-emitente: C¢digo do emitente
              p-nome-emit:    Nome do emitente

  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM p-cod-emitente LIKE emitente.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAM p-nome-emit    LIKE emitente.nome-emit    NO-UNDO.

    FOR FIRST emitente FIELDS (nome-emit)
        WHERE emitente.cod-emitente = p-cod-emitente NO-LOCK:
    END.
    IF AVAIL emitente THEN
        ASSIGN p-nome-emit = emitente.nome-emit.
    ELSE
        ASSIGN p-nome-emit = "":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaUnItem DBOProgram
PROCEDURE retornaUnItem :
/*------------------------------------------------------------------------------
  Purpose: Retorna unidade de medida do item
  Parameters: p-it-codigo: C¢digo do item
              p-un: Unidade de medida do item
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM p-it-codigo LIKE ITEM.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAM p-un LIKE ITEM.un NO-UNDO.

    FOR FIRST ITEM
        WHERE ITEM.it-codigo = p-it-codigo NO-LOCK:
    END.
    IF AVAIL ITEM THEN
        ASSIGN p-un = ITEM.un.
    ELSE
        ASSIGN p-un = "":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaValidadeLoteRefer DBOProgram
PROCEDURE retornaValidadeLoteRefer :
/*------------------------------------------------------------------------------
  Purpose: Busca a data de validade do lote do documento referenciado.
  Parameters:  pc-serie-docto:        S‚rie do documento
               pc-nro-docto:          N£mero do documento
               pc-nat-operacao:       Natureza de opera‡Æo
               pc-it-codigo:          C¢digo do item
               pc-cod-refer:          C¢digo da referˆncia
               pc-ch-acesso-comp-nfe: Chave de acesso do documento
               pi-seq-item:           Sequˆncia do item
               pi-seq-saldo-terc:     Sequˆncia do saldo em poder de terceiros
               pi-cod-emitente:       C¢digo do emitente


  Notes:
------------------------------------------------------------------------------*/

    define input param pc-serie-docto           as char no-undo.
    define input param pc-nro-docto             as char no-undo.
    define input param pc-nat-operacao          as char no-undo.
    define input param pc-it-codigo             as char no-undo.
    define input param pc-cod-refer             as char no-undo.
    define input param pc-ch-acesso-comp-nfe    as char no-undo.
    define input param pi-seq-item              as int  no-undo.
    define input param pi-seq-saldo-terc        as int  no-undo.
    define input param pi-cod-emitente          as int  no-undo.

    define var lDevSimbConsig                   as log  no-undo.
    define var l-configurado                    as log  no-undo.
    define var c-cod-depos                      as char no-undo.
    define var c-cod-localiz                    as char no-undo.

    for first saldo-terc no-lock
        where saldo-terc.serie-docto  = pc-serie-docto
        and   saldo-terc.nro-docto    = pc-nro-docto
        and   saldo-terc.cod-emitente = pi-cod-emitente
        and   saldo-terc.nat-operacao = pc-nat-operacao
        and   saldo-terc.it-codigo    = pc-it-codigo
        and   saldo-terc.sequencia    = pi-seq-saldo-terc:

        find first componente of saldo-terc no-lock no-error.

        find first doc-orig-nfe no-lock
            where doc-orig-nfe.ch-acesso-comp-nfe = pc-ch-acesso-comp-nfe
            and   doc-orig-nfe.idi-orig-trad      = 2 no-error.

        if avail doc-orig-nfe then do:
            for first item-doc-orig-nfe exclusive-lock
                where item-doc-orig-nfe.ch-acesso-comp-nfe  = doc-orig-nfe.ch-acesso-comp-nfe
                and   item-doc-orig-nfe.idi-orig-trad       = 2
                and   item-doc-orig-nfe.seq-item            = pi-seq-item:

                ASSIGN item-doc-orig-nfe.cod-refer  = IF pc-cod-refer = "" THEN saldo-terc.cod-refer ELSE pc-cod-refer /* conteudo da tela */
                       item-doc-orig-nfe.lote-serie = saldo-terc.lote.

                FOR FIRST rat-saldo-terc NO-LOCK
                    WHERE rat-saldo-terc.serie-docto    = saldo-terc.serie-docto
                      AND rat-saldo-terc.nro-docto      = saldo-terc.nro-docto
                      AND rat-saldo-terc.nat-operacao   = saldo-terc.nat-operacao
                      AND rat-saldo-terc.cod-emitente   = saldo-terc.cod-emitente
                      AND rat-saldo-terc.it-codigo      = saldo-terc.it-codigo
                      AND rat-saldo-terc.sequencia      = saldo-terc.sequencia:
                    ASSIGN item-doc-orig-nfe.lote-serie = rat-saldo-terc.lote.

                    /* Saldo implantado direto pelo RE0407 */
                    IF rat-saldo-terc.dt-vali-lote <> ? THEN
                       ASSIGN item-doc-orig-nfe.dt-vali-lote = rat-saldo-terc.dt-vali-lote.
                END.

                IF item-doc-orig-nfe.lote-serie <> "":U
                AND item-doc-orig-nfe.dt-vali-lote = ? THEN DO:
                    FOR FIRST saldo-estoq FIELDS (it-codigo lote dt-vali-lote) NO-LOCK
                        WHERE saldo-estoq.it-codigo = saldo-terc.it-codigo
                          AND saldo-estoq.lote      = item-doc-orig-nfe.lote-serie:
                        ASSIGN item-doc-orig-nfe.dt-vali-lote = saldo-estoq.dt-vali-lote.
                    END.
                    IF item-doc-orig-nfe.dt-vali-lote = ? AND AVAIL componente THEN
                        ASSIGN item-doc-orig-nfe.dt-vali-lote = componente.dt-vali-lote.
                END.

            end.

            for first natur-oper no-lock
                where natur-oper.nat-operacao = item-doc-orig-nfe.nat-operacao:

                /* Valida se ‚ devolu‡Æo simb¢lica. */
                assign lDevSimbConsig = {cdp/cd0066.i doc-orig-nfe.cod-estabel natur-oper}

                if not (lDevSimbConsig
                        or  natur-oper.tp-oper-terc = 4
                        or  natur-oper.tp-oper-terc = 6)
                and (natur-oper.transf
                or (avail componente
                    and componente.baixa-ce)) then do:

                        for first item no-lock
                            where item.it-codigo = pc-it-codigo:
                            if  (   item.politica = 5         /* Item Configurado */
                                 or item.politica = 6 )       /* Item Composto */
                            and not componente.baixa-ce  then /* NÆo Baixa Estoque */
                                assign l-configurado = yes.
                            if not l-configurado then do:

                                find first fat-ser-lote no-lock
                                    where fat-ser-lote.cod-estabel  = doc-orig-nfe.cod-estabel
                                    and   fat-ser-lote.serie        = pc-serie-docto
                                    and   fat-ser-lote.nr-nota-fis  = pc-nro-docto
                                    and   fat-ser-lote.nr-seq-fat   = pi-seq-saldo-terc
                                    and   fat-ser-lote.it-codigo    = pc-it-codigo no-error.

                                if avail fat-ser-lote then do:
                                    assign c-cod-depos   =  if  (item-doc-orig-nfe.cod-depos <> ""
                                                                and not natur-oper.transf) then
                                                                item-doc-orig-nfe.cod-depos
                                                            else
                                                                fat-ser-lote.cod-depos
                                           c-cod-localiz = fat-ser-lote.cod-localiz. /* Localiza‡Æo informada na NFS */

                                    if  item.tipo-con-est = 2 then do:
                                        for first saldo-estoq fields (it-codigo lote qtidade-atu)
                                            where saldo-estoq.it-codigo = fat-ser-lote.it-codigo
                                            and   saldo-estoq.lote      = fat-ser-lote.nr-serlote
                                            and   saldo-estoq.qtidade-atu > 0 no-lock:
                                        end.
                                        if avail saldo-estoq then /* item controlado por nro de serie */
                                            next.
                                    end.
                                    else
                                        for first saldo-estoq fields (it-codigo lote dt-vali-lote)
                                            where saldo-estoq.it-codigo = fat-ser-lote.it-codigo
                                            and   saldo-estoq.lote      = fat-ser-lote.nr-serlote no-lock:
                                                ASSIGN item-doc-orig-nfe.dt-vali-lote = saldo-estoq.dt-vali-lote.
                                        end.
                                end.
                                else do:
                                    find first rat-lote no-lock
                                        where rat-lote.cod-emitente = doc-orig-nfe.cod-emitente
                                        and   rat-lote.serie-docto  = pc-serie-docto
                                        and   rat-lote.nat-operacao = pc-nat-operacao
                                        and   rat-lote.nro-docto    = pc-nro-docto
                                        and   rat-lote.sequencia    = pi-seq-saldo-terc no-error.

                                    if avail rat-lote then
                                        assign item-doc-orig-nfe.dt-vali-lote = rat-lote.dt-vali-lote.
                                    else do:
                                        if  avail saldo-terc then do:
                                            find first saldo-estoq no-lock
                                                where saldo-estoq.it-codigo = saldo-terc.it-codigo
                                                and   saldo-estoq.lote      = saldo-terc.lote no-error.

                                            assign c-cod-depos = if  item-doc-orig-nfe.cod-depos <> ""
                                                                 then item-doc-orig-nfe.cod-depos /* Deposito para devolucao */
                                                                 else componente.cod-depos.

                                            if not can-find(first rat-lote use-index documento no-lock
                                                where rat-lote.serie-docto  = pc-serie-docto
                                                and   rat-lote.nro-docto    = pc-nro-docto
                                                and   rat-lote.cod-emitente = pi-cod-emitente
                                                and   rat-lote.nat-operacao = pc-nat-operacao
                                                and   rat-lote.sequencia    = pi-seq-saldo-terc
                                                and   rat-lote.it-codigo    = pc-it-codigo
                                                and   rat-lote.cod-depos    = c-cod-depos
                                                and   rat-lote.cod-localiz  = saldo-terc.cod-localiz
                                                and   rat-lote.lote         = saldo-terc.lote) then do:

                                                /* Saldo implantado direto pelo RE0407: preserva a validade do lote j  obtida da rat-saldo-terc */
                                                if item-doc-orig-nfe.dt-vali-lote = ? then do:
                                                    if  avail saldo-estoq
                                                    and saldo-estoq.dt-vali-lote <> ? then
                                                        assign item-doc-orig-nfe.dt-vali-lote = saldo-estoq.dt-vali-lote.
                                                    else if avail componente then
                                                        assign item-doc-orig-nfe.dt-vali-lote = componente.dt-vali-lote.
                                                end.
                                            end.
                                        end.
                                    end.
                                end.
                            end.
                    end.
                end.
            end.
        end.
    end.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaValidLote DBOProgram
PROCEDURE retornaValidLote :
/*------------------------------------------------------------------------------
  Purpose: Retorna data de validade do lote
  Parameters: p-it-codigo:  C¢digo do item
              p-lote:       Lote
              p-cod-refer:  C¢digo da referˆncia
              p-valid-lote: Data de validade do lote

  Notes:
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-it-codigo  LIKE item-doc-orig-nfe.it-codigo    NO-UNDO.
    DEF INPUT  PARAM p-lote       LIKE item-doc-orig-nfe.lote-serie   NO-UNDO.
    DEF INPUT  PARAM p-cod-refer  LIKE item-doc-orig-nfe.cod-refer    NO-UNDO.
    DEF OUTPUT PARAM p-valid-lote LIKE item-doc-orig-nfe.dt-vali-lote NO-UNDO.

    IF AVAIL doc-orig-nfe THEN DO:
        FOR FIRST ITEM
            WHERE ITEM.it-codigo = p-it-codigo NO-LOCK:
        END.

        IF  AVAIL ITEM
        AND (ITEM.tipo-con-est = 3 OR ITEM.tipo-con-est = 4) THEN DO:
            FIND LAST saldo-estoq USE-INDEX item-lote
                WHERE saldo-estoq.it-codigo   = p-it-codigo
                  AND saldo-estoq.cod-estabel = doc-orig-nfe.cod-estabel
                  AND saldo-estoq.lote        = p-lote
                  AND saldo-estoq.cod-refer   = p-cod-refer NO-LOCK NO-ERROR.
            IF AVAIL saldo-estoq THEN
                ASSIGN p-valid-lote = saldo-estoq.dt-vali-lote.
            ELSE
                ASSIGN p-valid-lote = ?.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMonitor DBOProgram
PROCEDURE setConstraintMonitor :
/*------------------------------------------------------------------------------
  Purpose:     Recebe parametros para realizar abertura da query
  Parameters:  Chave acesso Completa NF-e
               Origem NF-e (1 - Original e 2 - Traduzida)
  Notes:
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER p-chave-acesso LIKE item-doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEF INPUT PARAMETER p-idi-origem   LIKE item-doc-orig-nfe.idi-orig-trad      NO-UNDO.

    ASSIGN c-chave-acesso = p-chave-acesso
           i-idi-origem   = p-idi-origem  .

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sugereCampos DBOProgram
PROCEDURE sugereCampos :
/*------------------------------------------------------------------------------
  Purpose: Sugerir pedido, ordem, item da ordem e referˆncia do item.
  Parameters: pi-sugestao:     Para quem deve ser gerado a sugestÆo (1 - Pedido 2 - Ordem)
              pc-it-codigo:    C¢digo do item
              pc-num-pedido:   N£mero do pedido de compra
              pc-numero-ordem: N£mero da ordem de compra
              pc-cod-refer:    C¢digo da referˆncia

  Notes:
------------------------------------------------------------------------------*/

    define input        param pi-sugestao       as int      no-undo.
    define input-output param pc-it-codigo      as char     no-undo.
    define input-output param pc-num-pedido     as char     no-undo.
    define input-output param pc-numero-ordem   as char     no-undo.
    define output       param pc-cod-refer      as char     no-undo.

    case pi-sugestao.
        when 1 then do: /* Pedido */

            for first ordem-compra no-lock
                where ordem-compra.numero-ordem = int(pc-numero-ordem)
                and   ordem-compra.situacao     = 2,
                first pedido-compr no-lock
                    where pedido-compr.num-pedido = ordem-compra.num-pedido:
                    assign pc-num-pedido = string(pedido-compr.num-pedido)
                           pc-it-codigo  = ordem-compra.it-codigo.
            end.
        end.

        when 2 then do: /* Ordem */
            if not can-find(first ordem-compra
                            where ordem-compra.num-pedido   = int(pc-num-pedido)
                            and   ordem-compra.numero-ordem = int(pc-numero-ordem)
                            and   ordem-compra.situacao     = 2)
                then do:

                FIND first ordem-compra no-lock
                    where ordem-compra.it-codigo    = pc-it-codigo
                    and   ordem-compra.num-pedido   = int(pc-num-pedido)
                    and   ordem-compra.situacao     = 2
                    AND CAN-FIND (FIRST prazo-compra NO-LOCK
                        where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                        and   prazo-compra.situacao     = 2
                        and   prazo-compra.dec-1        < prazo-compra.quant-saldo) NO-ERROR.
                IF AVAIL ordem-compra THEN DO:

                    assign pc-numero-ordem  = string(ordem-compra.numero-ordem).
                END.

            end.
        end.

        otherwise /* Op‡Æo inv lida */
            return "OK":U.
    end case.

    /*  Sugere a referˆncia do item quando vazia.*/
    if pc-cod-refer = "" then
        for first item no-lock
            where item.it-codigo = pc-it-codigo
              and   item.tipo-con-est = 4, /* Referˆncia */
            first prazo-compra no-lock
                where prazo-compra.it-codigo    = pc-it-codigo
                  and   prazo-compra.numero-ordem = int(pc-numero-ordem):
                assign pc-cod-refer = prazo-compra.cod-refer.
        end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sugereOrdProdOrdemCompra DBOProgram
PROCEDURE sugereOrdProdOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     Deriva e sugere a Ordem de Producao (nr-ord-produ) a partir da
               Ordem de Compra informada (ordem-compra.ordem-servic, inclusive 0)
               e devolve o Item Pai correspondente a OP resultante.
  Parameters:  p-numero-ordem: Numero da Ordem de Compra informada/sugerida
               p-nr-ord-produ: Ordem de Producao (entrada: valor atual / saida: valor sugerido)
               p-item-pai:     Item Pai (ord-prod.it-codigo) da OP resultante;
                               vazio se a OP for 0 ou nao existir
  Notes:       Regra centralizada na BO para ser compartilhada entre o Monitor
               NF-e (itemDocumentoXmlNfeRules.p) e a tela RE0118a (re0118a.w).
               - Com p-numero-ordem = 0 a OP nao e alterada (pode ter sido
                 informada manualmente pelo usuario).
               - Se a ordem de compra nao existir, a OP tambem nao e alterada,
                 igual ao RE1001; a validacao da ordem ja trata o erro.
------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAM p-numero-ordem     LIKE ordem-compra.numero-ordem      NO-UNDO.
    DEFINE INPUT-OUTPUT PARAM p-nr-ord-produ     LIKE item-doc-orig-nfe.nr-ord-produ NO-UNDO.
    DEFINE OUTPUT       PARAM p-item-pai         LIKE ord-prod.it-codigo             NO-UNDO.

    IF p-numero-ordem > 0 THEN DO:
        FIND FIRST ordem-compra NO-LOCK
             WHERE ordem-compra.numero-ordem = p-numero-ordem NO-ERROR.
        /* Atribui inclusive 0 quando a ordem de compra nao tem OP (reset da OP antiga) */
        IF AVAIL ordem-compra THEN
            ASSIGN p-nr-ord-produ = ordem-compra.ordem-servic.
    END.

    ASSIGN p-item-pai = "":U.
    IF p-nr-ord-produ > 0 THEN DO:
        FIND FIRST ord-prod NO-LOCK
             WHERE ord-prod.nr-ord-produ = p-nr-ord-produ NO-ERROR.
        IF AVAIL ord-prod THEN
            ASSIGN p-item-pai = ord-prod.it-codigo.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sugereLocalizUnica DBOProgram
PROCEDURE sugereLocalizUnica :
/*------------------------------------------------------------------------------
  Purpose: sugere a localizacao unica do item.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    def input   param pc-it-codigo      as  char    no-undo.
    def output  param pc-cod-localiz    as  char    no-undo.

    if avail doc-orig-nfe then do:
        for first item-uni-estab no-lock
            where item-uni-estab.it-codigo   = pc-it-codigo
            and   item-uni-estab.cod-estabel = doc-orig-nfe.cod-estabel:
            if item-uni-estab.loc-unica then do:
                assign pc-cod-localiz = item-uni-estab.cod-localiz.
                return "YES":U. /* eh localizcao unica */
            end.
        end.
        return "NO":U.
    end.

    return "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaContratoOrdem DBOProgram
PROCEDURE validaContratoOrdem :
/*------------------------------------------------------------------------------
  Purpose: Valida‡Æo de contrato de ordem de compra
  Parameters: l-contrato: Indica que a ordem de compra possui
              i-total: Tipo de controle de contrato
  Notes:
------------------------------------------------------------------------------*/

    def output parameter  l-contrato    as logical                      no-undo.
    def output parameter  i-total       as int                          no-undo.

    assign l-contrato = no
           i-total    = 0.

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

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaTipoOperacao DBOProgram
PROCEDURE atualizaTipoOperacao :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes: logica tomada com base no procedure validaTipoNota da boin847.p
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM TABLE FOR tt-item-doc-orig-nfe-param.
    DEFINE OUTPUT PARAM ptipo-operac AS INT  NO-UNDO.

    DEFINE VARIABLE h-boin245na            AS HANDLE               NO-UNDO.  /*BO natur-oper */
    DEFINE VARIABLE h-bodi001              AS HANDLE               NO-UNDO. /* BO cfop-natur */

    DEFINE VARIABLE l-transf               AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE l-terceiros            AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE l-nota-rateio          AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE i-tp-oper-terc         AS INTEGER              NO-UNDO.
    DEFINE VARIABLE i-tipo-compra          AS INTEGER              NO-UNDO.
    DEFINE VARIABLE i-idi-tip-devol-consig AS INTEGER              NO-UNDO.
    DEFINE VARIABLE i-num-livre-1          AS INTEGER              NO-UNDO.
    DEFINE VARIABLE i-cb-tipo-oper-aux     AS INTEGER   INITIAL ?  NO-UNDO.

    IF NOT VALID-HANDLE(h-boin245na) THEN
        RUN inbo/boin245na.p PERSISTENT SET h-boin245na.

    RUN openQueryStatic IN h-boin245na (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE( h-bodi001)  THEN
       RUN dibo/bodi001.p PERSISTENT SET h-bodi001.

    RUN openQueryStatic IN h-bodi001 (INPUT "Main":U) NO-ERROR.
    FOR FIRST tt-item-doc-orig-nfe-param:
    END.
    IF cNatOperacao <> "" then do:

        ASSIGN ptipo-operac = 1.
        RUN goToKey IN h-boin245na(INPUT cNatOperacao).

        IF RETURN-VALUE = "OK" THEN DO:
            RUN getIntField IN h-boin245na(INPUT "tp-oper-terc":U, OUTPUT i-tp-oper-terc).
            RUN getIntField IN h-boin245na(INPUT "tipo-compra":U , OUTPUT i-tipo-compra ).
            RUN getLogField IN h-boin245na(INPUT "transf":U,       OUTPUT l-transf      ).
            RUN getLogField IN h-boin245na(INPUT "terceiros":U ,   OUTPUT l-terceiros   ).
            RUN getLogField IN h-boin245na(INPUT "nota-rateio":U,  OUTPUT l-nota-rateio ).
            RUN getIntField IN h-boin245na(INPUT "idi-tip-devol-consig":U,  OUTPUT i-idi-tip-devol-consig ).

            IF l-transf THEN DO:
                ASSIGN ptipo-operac = 3. /* Transferencia */
            END.
            ELSE DO:
                /* O valor do tipo operacao deve sempre serÿ o valor do campo             **
                ** tp-oper-terc + 3, a n’o ser que tp-oper-terc seja maior que 5          **
                ** (Drawback n’o s’o utilizados):                                         **
                ** Segue tabela:
                **   _______________________________________________________________________
                **  |Valor de tp-oper-terc |Valor  de tipo-nota |     Tipo da nota          |
                    |=======================================================================|
                    |          1           |          4         | Entrada Beneficiamento    |
                    |          2           |          5         | Retorno Beneficiamento    |
                    |          3           |          6         | Entrada Consignada        |
                    |          4           |          7         | Fatura Consignada         |
                    |          5           |          8   2     | Devolucao Consignada      |
                    |          5           |          9   1     | Devolucao Consignada Simb |
                    |          6           |         12         | Reajuste Preco            |
                    |          8           |         18         | Ent Dep Fechado           |
                    |          9           |         19         | Ret Dep Fechado           |
                    |         10           |         20         | Ent Armaz Geral           |
                    |         11           |         21         | Ret Armaz Geral           |
                    ----------------------------------------------------------------------  */

                IF l-terceiros AND i-tp-oper-terc <= 6 THEN DO:
                    IF i-tp-oper-terc = 5 AND i-idi-tip-devol-consig = 2 THEN DO: /*Devolu»’o Consig*/
                        ASSIGN ptipo-operac = 8.
                    END.
                    ELSE IF i-tp-oper-terc = 5 AND i-idi-tip-devol-consig = 1 THEN DO: /*Devolu»’o Consig Simbol*/
                        ASSIGN ptipo-operac = 9.
                    END.
                    ELSE IF i-tp-oper-terc = 6 THEN DO:
                        ASSIGN ptipo-operac = 12.
                    END.
                    ELSE DO:
                        ASSIGN ptipo-operac = i-tp-oper-terc + 3.
                    END.
                END.
                ELSE DO:
                    IF l-terceiros AND i-tp-oper-terc >= 8 THEN DO:
                        IF i-tp-oper-terc = 8 THEN
                            ASSIGN ptipo-operac = 18.
                        ELSE IF i-tp-oper-terc = 9 THEN
                            ASSIGN ptipo-operac = 19.
                        ELSE IF i-tp-oper-terc = 10 THEN
                            ASSIGN ptipo-operac = 20.
                        ELSE IF i-tp-oper-terc = 11 THEN
                            ASSIGN ptipo-operac = 21.
                    END.
                    ELSE IF l-nota-rateio THEN DO:
                            ASSIGN ptipo-operac = 10. /* Nota de Rateio */
                    END.
                    ELSE DO:
                        IF i-tipo-compra = 3 THEN DO: /* Verifica se o tipo de compra ² Devolucao Cliente */
                            ASSIGN ptipo-operac = 2.
                        END.
                        ELSE IF i-tipo-compra = 4 THEN DO: /* Material Agregado */
                            ASSIGN ptipo-operac = 11.
                        END.
                        ELSE IF i-tipo-compra = 9 THEN DO: /*Nota de cr‚dito e d‚bito*/
                             ASSIGN ptipo-operac = 23.
                        END.
                    END.
                END.
            END.
           /* /*Atualiza combo */
            ASSIGN cb-tipo-oper:SCREEN-VALUE IN FRAME fPage1 =  STRING(ptipo-operac).*/

        END.
        ELSE DO:
            /* Se nao encontrar natureza, tenta buscar o tipo de operacao do CFOP */
            RUN goToKey IN h-bodi001(INPUT tt-item-doc-orig-nfe-param.cod-cfop).
            IF RETURN-VALUE = "OK" THEN DO:
                RUN getIntField IN h-bodi001(INPUT "num-livre-1":U, OUTPUT i-num-livre-1).

                IF i-cb-tipo-oper-aux = ? THEN DO: /* Valor do combo nÆo foi alterado */

                     IF tt-item-doc-orig-nfe-param.int-2 = i-num-livre-1 THEN DO:  /* tipo operacao item igual o tipo operacao do cfop*/
                        ASSIGN //cb-tipo-oper:SCREEN-VALUE IN FRAME fPage1  = STRING(i-num-livre-1)
                               ptipo-operac =  i-num-livre-1.
                     END.
                     ELSE DO: /* Assume o tipo operacao do item */
                        ASSIGN ptipo-operac = tt-item-doc-orig-nfe-param.int-2
                               /*cb-tipo-oper:SCREEN-VALUE IN FRAME fPage1 = string(ptipo-operac)*/ .
                     END.
                END.
                ELSE DO: /* tipo operacao do compo foi alterado */
                    IF i-num-livre-1 <> i-cb-tipo-oper-aux THEN DO: /* se o valor do combo for diferente do cfop do item */
                        ASSIGN ptipo-operac = i-cb-tipo-oper-aux. /* Assume o valor do tipo operacao do combo*/
                    END.
                END.
            END.
            ELSE DO: /* se nao tiver tipo operacao cadastrado para o cfop */
                IF i-cb-tipo-oper-aux = ? THEN DO: /* se nÆo alterou o valor do combo assume o valor do campo tipo operacao do item*/
                    ASSIGN ptipo-operac = tt-item-doc-orig-nfe-param.int-2.
                END.
                ELSE DO: /* Se aletrou o combo assume o tipo de opera‡Æo alterado*/
                    ASSIGN ptipo-operac = i-cb-tipo-oper-aux.
                END.
            END.
        END.
    END.
    IF VALID-HANDLE(h-boin245na) THEN DO:
       DELETE PROCEDURE h-boin245na.
       ASSIGN h-boin245na = ?.
    END.
    IF VALID-HANDLE(h-bodi001) THEN DO:
       DELETE PROCEDURE h-bodi001.
       ASSIGN h-bodi001 = ?.
    END.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setChaveCompleta DBOProgram
PROCEDURE setChaveCompleta:
    DEFINE INPUT  PARAM pChaveCompleta      LIKE item-doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.

    ASSIGN cChaveCompleta = pChaveCompleta.

    RETURN "OK":U.
END PROCEDURE .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setNatOperacao DBOProgram
PROCEDURE setNatOperacao:
    DEFINE INPUT  PARAM pNatOperacao      LIKE item-doc-orig-nfe.nat-operacao NO-UNDO.

    ASSIGN cNatOperacao = pNatOperacao.

    RETURN "OK":U.
END PROCEDURE .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setCtCodigo DBOProgram
PROCEDURE setCtCodigo:
    DEFINE INPUT  PARAM pCtCodigo     LIKE item-doc-orig-nfe.ct-codigo NO-UNDO.

    ASSIGN cCtCodigo = pCtCodigo.
    RETURN "OK":U.
END PROCEDURE .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setNrOrdProdu DBOProgram
PROCEDURE setNrOrdProdu:
    DEFINE INPUT  PARAM pNrOrdProdu      LIKE item-doc-orig-nfe.nr-ord-produ NO-UNDO.

    ASSIGN iNrOrdProdu = pNrOrdProdu.

    RETURN "OK":U.
END PROCEDURE .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setNumeroOrdem DBOProgram
PROCEDURE setNumeroOrdem:
    DEFINE INPUT  PARAM pNumeroOrdem    LIKE item-doc-orig-nfe.numero-ordem NO-UNDO.

    ASSIGN iNumeroOrdem = pNumeroOrdem.

    RETURN "OK":U.
END PROCEDURE .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setItCodigo DBOProgram
PROCEDURE setItCodigo:
    DEFINE INPUT  PARAM pItCodigo    LIKE item-doc-orig-nfe.it-codigo NO-UNDO.

    ASSIGN cItCodigo = pItCodigo.

    RETURN "OK":U.
END PROCEDURE .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setCodDepos DBOProgram
PROCEDURE setCodDepos:
    DEFINE INPUT  PARAM pCodDepos   LIKE item-doc-orig-nfe.cod-depos NO-UNDO.

    ASSIGN cCodDepos = pCodDepos.

    RETURN "OK":U.

END PROCEDURE .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setParcela DBOProgram
PROCEDURE setParcela:
     DEFINE INPUT  PARAM pParcela    AS INTEGER NO-UNDO.

    ASSIGN iParcela = pParcela.

    RETURN "OK":U.
END PROCEDURE .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getParcela DBOProgram
PROCEDURE getParcela:
    DEFINE OUTPUT  PARAM pParcela    AS INTEGER NO-UNDO.

    ASSIGN pParcela = iParcela.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTTRatLoteMedicNfe DBOProgram
PROCEDURE setTTRatLoteMedicNfe:
    DEFINE INPUT PARAM TABLE FOR tt-rat-lote-medic-nfe-param.

    IF RowObject.int-2 <> 23 THEN DO: /* Nota cr‚dito/d‚bito */
        EMPTY TEMP-TABLE tt-rat-lote-medic-nfe.
        FOR EACH tt-rat-lote-medic-nfe-param:
            CREATE tt-rat-lote-medic-nfe.
            BUFFER-COPY tt-rat-lote-medic-nfe-param TO tt-rat-lote-medic-nfe.
        END.
    END.
    EMPTY TEMP-TABLE tt-rat-lote-medic-nfe-param.

    RETURN "OK":U.
END PROCEDURE .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sugestaoParcelaOC DBOProgram
PROCEDURE sugestaoParcelaOC:
    DEFINE VARIABLE l-achou-parc AS LOGICAL     NO-UNDO.

    FOR FIRST bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
        AND   bf{&TableName}.seq-item           = RowObject.seq-item
        AND   bf{&TableName}.idi-orig-trad      = RowObject.idi-orig-trad:

        IF NOT RowObject.log-fifo-oc
		OR NOT CAN-FIND(FIRST tt-manut-docto WHERE tt-manut-docto.mark = "*") THEN DO:

            ASSIGN l-achou-parc = NO.
            IF  RowObject.numero-ordem = bf{&TableName}.numero-ordem
            AND bf{&TableName}.numero-ordem  > 0 THEN DO:

                /* Ao desalocar, o item j  tem parcela informada. */
                FOR FIRST prazo-compra fields (quant-saldo dec-1 parcela) NO-LOCK
                    WHERE prazo-compra.numero-ordem = bf{&TableName}.numero-ordem
                    AND   prazo-compra.parcela      = bf{&TableName}.parcela
                    AND   prazo-compra.situacao     = 2 :
                    ASSIGN RowObject.parcela     = prazo-compra.parcela
                           l-achou-parc = YES.
                END.
            END.
            ELSE DO:
                /* Aloca na parcela mais antiga em aberto que tenha saldo. */
                FOR FIRST prazo-compra FIELDS (quant-saldo dec-1 parcela data-entrega numero-ordem situacao) NO-LOCK USE-INDEX ordem-sit
                    WHERE prazo-compra.numero-ordem =  RowObject.numero-ordem
                    AND   prazo-compra.situacao     = 2
                    AND   (prazo-compra.quant-saldo - prazo-compra.dec-1) > 0
                    BY prazo-compra.data-entrega
                    BY prazo-compra.numero-ordem
                    BY prazo-compra.parcela:

                    ASSIGN RowObject.parcela  = prazo-compra.parcela
                           l-achou-parc  = YES.
                END.
                IF NOT l-achou-parc THEN DO:
                    /* Aloca na primeira parcela em aberto. */
                    FOR FIRST  prazo-compra FIELDS (quant-saldo dec-1 parcela numero-ordem data-entrega situacao) NO-LOCK USE-INDEX ordem-sit
                        WHERE prazo-compra.numero-ordem = RowObject.numero-ordem
                        AND   prazo-compra.situacao     = 2
                        BY prazo-compra.parcela:

                        ASSIGN RowObject.parcela  = prazo-compra.parcela
                               l-achou-parc = YES.
                    END.
                END.
            END.
            /* Zera a parcela. */
            IF NOT l-achou-parc THEN
                ASSIGN RowObject.parcela  = 0.
        END.

    END.
    RETURN "ok":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE determinaUnidNeg DBOProgram
PROCEDURE determinaUnidNeg :
/*------------------------------------------------------------------------------
  Purpose: Determina a unidade de negocio
  Parameters:  Retorna a unidade de negocio sugerida
  Dependencias:
  setConstraintTipoOperEnableFields, setChaveCompleta, setNatOperacao, setCtCodigo,
  setNrOrdProdu, setNumeroOrdem, setItCodigo, setCodDepos, setHiddenUnidNeg
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM pCodUnidNegoc LIKE item-doc-orig-nfe.cod-unid-negoc NO-UNDO.

    DEF VAR c-conta         AS CHAR NO-UNDO.
    DEF VAR c-ord-prod      AS CHAR NO-UNDO.
    DEF VAR c-numero-ordem  AS CHAR NO-UNDO.
    DEF VAR i-tipo-nota     AS INT  NO-UNDO.
    DEF VAR h-boin847       AS HANDLE NO-UNDO.
    DEF VAR h-bofr134       AS HANDLE NO-UNDO.
    DEF VAR l-usa-unid-negoc  AS LOG NO-UNDO.
    DEF VAR l-unidade-negocio AS LOG NO-UNDO.
    DEF VAR l-frotas          AS LOG NO-UNDO.

    /* Funcao unidade de negocio. */
    find first funcao no-lock
        where funcao.cd-funcao = "ems2-unidade-negocio":U
        and   funcao.ativo no-error.
    assign l-usa-unid-negoc  = avail funcao
           l-unidade-negocio = avail funcao.

     /* API sugestao unidade de negocio do item. */
    if not valid-handle(h-cdapi024) then
        run cdp/cdapi024.p persistent set h-cdapi024.

    FOR FIRST bf-doc-orig-nfe FIELDS (uf-destino)
        WHERE bf-doc-orig-nfe.ch-acesso-comp-nfe = cChaveCompleta
          AND bf-doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK:
    END.
    IF NOT VALID-HANDLE(h-boin847) THEN
        RUN inbo/boin847.p PERSISTENT SET h-boin847.

    RUN setConstraintDocumento IN h-boin847 (INPUT cChaveCompleta,
                                             INPUT 2).
    RUN openQueryStatic        IN h-boin847 (INPUT "Documento":U) NO-ERROR.

    /* Determina tipo da nota. */
    if cNatOperacao <> "" then do:
        run findNaturOper   in h-boin847 (input  cNatOperacao).
        run validaTipoNota  in h-boin847 (output i-tipo-nota).
    end.
    else do:
        assign i-tipo-nota = i-tipo-operac-enable-fields. /* caso a natureza esteja em branco usa como base o tipo operacao setado pela tela (progress ou HTML) */
    end.

    /* Para naturezas que nao forem destes tipos, a Unidade de Negocio sera buscada no Gera Fisico/Fiscal.  */
    if  i-tipo-nota <> 1
    and i-tipo-nota <> 3
    and i-tipo-nota <> 9 then do:
        assign pCodUnidNegoc = "".
    end.
    else do:
        assign c-conta        = cCtCodigo
               c-ord-prod     = string(iNrOrdProdu)
               c-numero-ordem = string(iNumeroOrdem)
               c-conta        = replace(c-conta, ".", "")
               c-ord-prod     = replace(c-ord-prod, ".", "")
               c-numero-ordem = replace(c-numero-ordem, ".", "").

        if lHiddenUnidNeg = no then do:
            if l-mat-unid-negoc then do:

                if  int(c-ord-prod) <> 0
                and (   l-unidade-negocio
                     or (   i-tipo-nota = 1
                         or i-tipo-nota = 3
                         or i-tipo-nota = 9)
                    ) then do:

                    for first ord-prod fields (nr-ord-produ cod-unid-negoc)
                        where ord-prod.nr-ord-produ = int(c-ord-prod) no-lock:
                        assign pCodUnidNegoc = ord-prod.cod-unid-negoc.
                    end.
                end.
                else do:
                    if c-conta <> "" then do:
                        if int(c-numero-ordem) <> 0 then do:
                            for first ordem-compra no-lock
                                where ordem-compra.numero-ordem = int(c-numero-ordem):
                                assign pCodUnidNegoc = ordem-compra.cod-unid-negoc.
                            end.
                        end.
                        else do:
                            if valid-handle(h-cdapi024) then
                                run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input bf-doc-orig-nfe.cod-estabel,
                                                                                   input cItCodigo,
                                                                                   input cCodDepos,
                                                                                   output pCodUnidNegoc).

                        end.
                    end.
                    else
                        run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input bf-doc-orig-nfe.cod-estabel,
                                                                           input cItCodigo,
                                                                           input cCodDepos,
                                                                           output pCodUnidNegoc).
                end.
            end.

            if  int(c-ord-prod) <> 0
            and l-usa-unid-negoc then do:

                assign l-frotas = no.

                find first funcao no-lock
                    where funcao.cd-funcao = "spp-mmv-impl"
                    and   funcao.ativo no-error.
                if avail funcao then do:

                    /* Esta DBO pertence ao modulo de Frotas, porem nao    **
                    ** existe pre-processador para este modulo, portanto   **
                    ** deve se rmantida dentro da validacao da funcao e    **
                    ** nunca instanciada no initializeDBOs, como o padrao. */
                    if  not valid-handle(h-bofr134)
                    and connected("movfro") then
                        run frbo/bofr134.p persistent set h-bofr134.

                    if valid-handle(h-bofr134) then do:
                        run canFindMatrizMMV in h-bofr134 (input int(c-ord-prod)).

                        if  valid-handle(h-bofr134)
                        and return-value = "OK":U
                        and (   l-unidade-negocio
                             or (   i-tipo-nota = 1
                                 or i-tipo-nota = 3
                                 or i-tipo-nota = 9)
                            ) then
                            assign pCodUnidNegoc   = ""
                                   l-frotas     = yes.
                        else
                            assign l-frotas =  no.
                    end.
                    /* Destroi o handle. */
                    if valid-handle(h-bofr134) then
                        run destroy in h-bofr134.
                    assign h-bofr134 = ?.
                end.

                if not l-frotas then do:

                    find first unid-negoc-om no-lock
                        where unid-negoc-om.num-ord-manut = int(c-ord-prod) no-error.
                    if avail unid-negoc-om
                    and (   l-unidade-negocio
                         or (   i-tipo-nota = 1
                             or i-tipo-nota = 3
                             or i-tipo-nota = 9)
                        ) then
                        assign pCodUnidNegoc = "".

                end.
            end.
        end.
    end.

    IF VALID-HANDLE(h-boin847) THEN DO:
        DELETE PROCEDURE h-boin847.
        ASSIGN h-boin847 = ?.
    END.
    IF VALID-HANDLE(h-cdapi024) THEN DO:
        DELETE PROCEDURE h-cdapi024.
        ASSIGN h-cdapi024 = ?.
    END.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE relacionaItemFornec DBOProgram
PROCEDURE relacionaItemFornec:
    /*------------------------------------------------------------------------------
  Purpose: Valida‡Æo e relacionamento item-fornec
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

    FOR FIRST doc-orig-nfe NO-LOCK
        WHERE doc-orig-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
          AND doc-orig-nfe.idi-orig-trad = 2: /* posicionado para buscar o cod-emitente */

        FOR FIRST bf{&TableName} NO-LOCK
            WHERE bf{&TableName}.ch-acesso-comp-nfe  = RowObject.ch-acesso-comp-nfe
            AND   bf{&TableName}.idi-orig-trad       = 1 /*dados do XML*/
            AND   bf{&TableName}.seq-item            = RowObject.seq-item: END.

        IF RowObject.it-codigo <> "" AND
           CAN-FIND (FIRST item
                     WHERE item.it-codigo  = RowObject.it-codigo
                     AND item.tipo-contr <> 4) THEN DO: /*NÆo seja Debito Direto*/

           ASSIGN c-fator-conversao = "0"
                  i-num-casa-dec    = 0
                  de-relac-fat      = DEC(RowObject.qtd-comercial) / dec(RowObject.qtd-interna).

           IF de-relac-fat < 1 THEN DO:
               ASSIGN str-aux           = substring(ENTRY(2, STRING(de-relac-fat)),1,9)
                      i-num-casa-dec    = length(str-aux)
                      c-fator-conversao = LEFT-TRIM(str-aux, "0").
           END.
           ELSE
               ASSIGN c-fator-conversao = string(INT(de-relac-fat)).

           FIND FIRST tab-unidade NO-LOCK
                WHERE tab-unidade.un = RowObject.un-comercial NO-ERROR.
           IF AVAIL tab-unidade THEN
               ASSIGN c-un-comercial = RowObject.un-comercial.

           IF NOT CAN-FIND (FIRST item-fornec
                            WHERE item-fornec.it-codigo    = RowObject.it-codigo
                              AND item-fornec.cod-emitente = doc-orig-nfe.cod-emitente) THEN DO:

               IF RowObject.int-2 <> 3 THEN DO:  /*Tipo Operacao diferente de transferencia*/
                   IF c-un-comercial <> "":U THEN DO:

                       CREATE item-fornec.
                       ASSIGN item-fornec.cod-emitente = doc-orig-nfe.cod-emitente
                              item-fornec.it-codigo    = RowObject.it-codigo
                              item-fornec.item-do-forn = bf{&TableName}.it-codigo
                              item-fornec.unid-med-for = c-un-comercial
                              item-fornec.fator-conver = DEC(c-fator-conversao)
                              item-fornec.num-casa-dec = i-num-casa-dec.

                       {method/svc/errors/inserr.i &ErrorNumber="57069" /*NÆo encontrado relacionamento para Item x Fornecedor.*/
                                                   &ErrorType="EMS"     /*Efetuado o cadastro deste relacionamento com base nas informa‡äes da tela*/
                                                   &ErrorSubType="WARNING"}
                   END.
               END.
           END. /*IF NOT CAN-FIND (FIRST item-fornec*/
           ELSE DO:
               IF NOT CAN-FIND (FIRST item-fornec
                                WHERE item-fornec.it-codigo    = RowObject.it-codigo
                                  AND item-fornec.cod-emitente = doc-orig-nfe.cod-emitente
                                  AND item-fornec.ativo = YES) THEN DO:
                   {method/svc/errors/inserr.i &ErrorNumber="54459" /*Parƒmetro "ativo" desmarcado no relacionamento item x fornec*/
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"}
                   RETURN "NOK":U.
               END.

               FIND FIRST item-fornec
                   WHERE item-fornec.it-codigo    = RowObject.it-codigo
                     AND item-fornec.cod-emitente = doc-orig-nfe.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
               IF AVAIL item-fornec AND
                        item-fornec.fator-conver = dec(c-fator-conversao) AND
                        item-fornec.num-casa-dec = i-num-casa-dec THEN DO:

                    ASSIGN item-fornec.item-do-forn = bf{&TableName}.it-codigo
                           item-fornec.unid-med-for = if c-un-comercial <> "" then c-un-comercial else item-fornec.unid-med-for.

               END.
           END.
        END. /*IF tt-item-doc-orig-nfe-param.it-codigo <> ""*/
        ELSE DO:
            FIND FIRST item-fornec
                 WHERE item-fornec.it-codigo    = RowObject.it-codigo
                   AND item-fornec.cod-emitente = doc-orig-nfe.cod-emitente EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL item-fornec THEN DO:

                ASSIGN item-fornec.item-do-forn = bf{&TableName}.it-codigo.

            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateTypeMovto DBOProgram
PROCEDURE validateTypeMovto :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pcod-estabel   LIKE doc-orig-nfe.cod-estabel  NO-UNDO.
    DEF INPUT PARAM pcod-emitente  LIKE doc-orig-nfe.cod-emitente NO-UNDO.
    DEF INPUT PARAM pnat-operacao  LIKE {&TableName}.nat-operacao NO-UNDO.

    DEF VAR l-erro AS LOGICAL NO-UNDO.

    FOR FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = pcod-emitente:
    END.
    FOR FIRST natur-oper NO-LOCK
        WHERE natur-oper.nat-operacao = pnat-operacao:
    END.
    IF  NOT AVAIL emitente
    OR  NOT AVAIL natur-oper then
        RETURN "NOK":U.

    IF  i-pais-impto-usuario = 1 THEN  /**** Brasil *****/
        ASSIGN l-erro = YES.
    ELSE
        ASSIGN l-erro = NO.

    FOR FIRST estabelec FIELDS ( estado )
        WHERE estabelec.cod-estabel = pcod-estabel NO-LOCK:

        /* 14387 - Valida‡Æo modificada para consistir corretamento o estado do emitente e estabelecimento*/
        IF emitente.estado = estabelec.estado   AND
           (natur-oper.nat-operacao BEGINS "1"  OR
            natur-oper.nat-operacao BEGINS "5") THEN
             ASSIGN l-erro = NO.
        ELSE IF emitente.estado <> estabelec.estado     AND
                (natur-oper.nat-operacao BEGINS "2"     OR
                 natur-oper.nat-operacao BEGINS "3"     OR
                 natur-oper.nat-operacao BEGINS "6"     OR
                 natur-oper.nat-operacao BEGINS "7")    THEN
                ASSIGN l-erro = NO.

        IF  l-erro THEN DO:
            {method/svc/errors/inserr.i
                                &ErrorNumber="19235"
                                &ErrorType="EMS":U
                                &ErrorSubType="WARNING":U}
        END.
    END.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram
PROCEDURE afterUpdateRecord:
    DEFINE VARIABLE h-boin045     AS HANDLE NO-UNDO.

    IF c-origem-save = "APIREST":U THEN DO:
        RUN updateRatLoteMedicNfe.
        RUN updateFIFO.

        RUN inbo/boin045.p PERSISTENT SET h-boin045.
        // Elimina dados da TT que nÆo sÆo os considerados
        FOR EACH tt-item-doc-imp-nfe:
            IF tt-item-doc-imp-nfe.tipo-reg <> "TRAD":U THEN
                DELETE tt-item-doc-imp-nfe.
        END.

        RUN updateCalculoSistema (INPUT h-boin045).
        RUN salvarDadosConsideradosTela (INPUT h-boin045).
    END.

    IF RowObject.seq-item = 1 THEN DO:
        FIND FIRST doc-orig-nfe EXCLUSIVE-LOCK
             WHERE doc-orig-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
               AND doc-orig-nfe.idi-orig-trad      = RowObject.idi-orig-trad NO-ERROR.
        IF AVAIL doc-orig-nfe THEN
            ASSIGN doc-orig-nfe.cod-natur-operac = RowObject.nat-operacao
                   doc-orig-nfe.idi-tip-operac   = RowObject.int-2.
        FIND FIRST doc-orig-nfe NO-LOCK
             WHERE doc-orig-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
               AND doc-orig-nfe.idi-orig-trad      = RowObject.idi-orig-trad NO-ERROR.
    END.

    RETURN "OK":U.
    FINALLY:
        DELETE PROCEDURE h-boin045 NO-ERROR.
        ASSIGN h-boin045 = ?.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram
PROCEDURE beforeUpdateRecord:

    DEFINE VARIABLE h-boin356 AS HANDLE      NO-UNDO.

    FOR FIRST bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
          AND bf{&TableName}.seq-item           = RowObject.seq-item
          AND bf{&TableName}.idi-orig-trad      = RowObject.idi-orig-trad:

        IF bf{&TableName}.numero-ordem <> 0 THEN
            RUN findOrdemCompra     (INPUT bf{&TableName}.numero-ordem).

        IF NOT VALID-HANDLE(h-boin356) THEN
            RUN inbo/boin356.p PERSISTENT SET h-boin356.

        IF bf{&TableName}.numero-ordem > 0 THEN DO:
            RUN pi-desaloca-ordem-cc IN h-boin356 (INPUT bf{&TableName}.numero-ordem,
                                                   INPUT bf{&TableName}.parcela,
                                                   INPUT bf{&TableName}.qtd-interna).
        END.

        /******* Fim da Modifica‡Æo *******/
        RUN validaContratoOrdem (OUTPUT lContrat,
                                 OUTPUT iTotal).

        IF iTotal = 0 THEN DO:

            IF RowObject.numero-ordem > 0
            AND NOT CAN-FIND(FIRST tt-manut-docto WHERE tt-manut-docto.mark = "*") THEN DO: //ALOCA
                RUN aloca-ordem-cc IN h-boin356 (INPUT RowObject.numero-ordem,
                                                 INPUT-OUTPUT RowObject.parcela,
                                                 INPUT RowObject.qtd-interna).
            END.
        END.
        IF VALID-HANDLE(h-boin356) THEN DO:
            DELETE PROCEDURE h-boin356.
            ASSIGN h-boin356 = ?.
        END.

    END.


    IF CAN-FIND(FIRST tt-manut-docto WHERE tt-manut-docto.mark = "*") THEN DO:
        ASSIGN RowObject.num-pedido     = 0
               RowObject.numero-ordem   = 0
               RowObject.int-1          = 0 /* evento */
               RowObject.encerra-pa     = NO
               RowObject.log-fifo-oc    = YES.
    END.

    IF RowObject.num-pedido = 0 OR RowObject.numero-ordem = 0 THEN DO:
        ASSIGN RowObject.int-1 = 0 /* evento */
               RowObject.parcela = 0
               RowObject.encerra-pa = NO.
    END.

    /*15260 - Alteracao para reduzir o tamanho da narrativa e evitar erros*/
    IF RowObject.narrativa <> "" THEN
        ASSIGN RowObject.narrativa = SUBSTRING(RowObject.narrativa,1,2000).

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

    define variable l-contrato       as logical no-undo.
    define variable l-erro           as logical no-undo.
    define variable i-total          as integer no-undo.
    DEFINE VARIABLE l-hab-item       AS LOGICAL NO-UNDO.
    DEFINE VARIABLE l-ordem-alocada  AS LOGICAL NO-UNDO.
	define variable c-param-msg      AS CHARACTER NO-UNDO.
	DEFINE VARIABLE h-re1008         AS HANDLE    NO-UNDO.

    FIND param-convrsr-nfe NO-LOCK NO-ERROR.
    IF NOT AVAIL param-convrsr-nfe THEN DO:
        {utp/ut-liter.i Parametros_conversor_NF-e *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="RETURN-VALUE"}
        RETURN "NOK":U.
    END.

    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    IF pType = "UPDATE":U THEN DO:

        RUN sugestaoParcelaOC.

        FOR FIRST doc-orig-nfe
            WHERE doc-orig-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
              AND doc-orig-nfe.idi-orig-trad      = RowObject.idi-orig-trad NO-LOCK:
        END.

        IF CAN-DO("1,3,5,6,7,8,9,10", STRING(doc-orig-nfe.idi-situacao)) THEN DO:
            IF (doc-orig-nfe.idi-situacao = 5 /* Cancelada */ AND param-convrsr-nfe.log-bloq-nfe-cancda) OR
                doc-orig-nfe.idi-situacao <> 5 THEN DO:
                DEF VAR c-sit-txt AS CHAR NO-UNDO.
                assign c-sit-txt = {ininc/i01in847.i 04 doc-orig-nfe.idi-situacao}. /* Nao eh permitida alteracao de documento em situacoes dif de erro negoc, elimin e cancelada */
                {method/svc/errors/inserr.i &ErrorNumber="57071"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="c-sit-txt"}
                RETURN "NOK":U.
            END.
        end.

        IF RowObject.qtd-interna > 99999999.9999 THEN DO:
            {utp/ut-liter.i "atributo_Quantidade_interna" *}
            {method/svc/errors/inserr.i &ErrorNumber="18733"  &ErrorType="EMS"  &ErrorSubType="ERROR"  &ErrorParameters="RETURN-VALUE + '~~~~0 <-> 99.999.999,9999'"}
        END.

        FIND FIRST param-compra  NO-LOCK NO-ERROR.
        FIND FIRST param-contrat NO-LOCK NO-ERROR.

        FOR FIRST bf{&TableName} NO-LOCK
            WHERE bf{&TableName}.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
              AND bf{&TableName}.seq-item           = RowObject.seq-item
              AND bf{&TableName}.idi-orig-trad      = 2 :

            IF (bf{&TableName}.nat-operacao <> RowObject.nat-operacao OR
                bf{&TableName}.int-2        <> RowObject.int-2) THEN DO:

                RUN ValidaNfCreditoDebito (INPUT bf{&TableName}.ch-acesso-comp-nfe,
                                           INPUT RowObject.nat-operacao,    /* p-nat-oper-new */
                                           INPUT bf{&TableName}.int-2,       /* p-tp-oper-old  */
                                           INPUT RowObject.int-2).           /* p-tp-oper-new  */


                RUN ValidaNaturezadeTerceiro (INPUT bf{&TableName}.ch-acesso-comp-nfe, /* p-chave-acesso */
                                              INPUT bf{&TableName}.seq-item,         /* p-seq-item     */
                                              INPUT bf{&TableName}.nat-operacao,     /* p-nat-oper-old */
                                              INPUT RowObject.nat-operacao,          /* p-nat-oper-new */
                                              INPUT bf{&TableName}.int-2,            /* p-tp-oper-old  */
                                              INPUT RowObject.int-2).                /* p-tp-oper-new  */
            END.

        END.

        IF NOT CAN-FIND (FIRST tab-unidade
                         WHERE tab-unidade.un = RowObject.un-comercial) THEN DO:
             DEFINE VARIABLE c-lbl-liter-un-trad AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Unidade_Traduzida_nÆo_Cadastrada" *}
             ASSIGN c-lbl-liter-un-trad = TRIM(RETURN-VALUE).
             {method/svc/errors/inserr.i &ErrorNumber="846"
                                             &ErrorType="EMS"
                                             &ErrorSubType="ERROR"
                                             &ErrorParameters="c-lbl-liter-un-trad"}
        END.
        RUN validateTypeMovto (INPUT doc-orig-nfe.cod-estabel,
                               INPUT doc-orig-nfe.cod-emitente,
                               INPUT RowObject.nat-operacao).


        /** VALIDA€åES PEDIDO E ORDEM **/
        IF RowObject.numero-ordem <> 0 THEN DO:
            FOR FIRST ordem-compra
                WHERE ordem-compra.numero-ordem = RowObject.numero-ordem NO-LOCK:
            END.
            IF NOT AVAIL ordem-compra THEN DO:
                 /* Inicio -- Projeto Internacional */
                 DEFINE VARIABLE c-lbl-liter-ordem-de-compra AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "Ordem_de_Compra" *}
                 ASSIGN c-lbl-liter-ordem-de-compra = TRIM(RETURN-VALUE).
                 {method/svc/errors/inserr.i &ErrorNumber="2"
                                             &ErrorType="EMS"
                                             &ErrorSubType="ERROR"
                                             &ErrorParameters="c-lbl-liter-ordem-de-compra"}
            END.
            ELSE DO:
                IF  RowObject.num-pedido <> ordem-compra.num-pedido THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="7342"  /*Ordem de compra nao pertence ao pedido*/
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"}
                END.

                IF  RowObject.it-codigo <> ordem-compra.it-codigo THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="15187"  /*Item da ordem nao confere com item da nota fiscal*/
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"}
                END.

                IF  ordem-compra.situacao <> 2
                /*and not docum-est.rec-fisico*/ THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="15188"  /*Situa¯Êo da ordem nao permite movimentacao*/
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"}
                END.


                IF  param-compra.log-1 THEN DO:
                    ASSIGN l-pendente = NO.

                    RUN cdp/cdapi172.p (INPUT 4,
                                        INPUT ROWID(ordem-compra),
                                        OUTPUT l-pendente).

                    IF  NOT l-pendente THEN
                        RUN cdp/cdapi172.p (INPUT 6,
                                            INPUT ROWID(ordem-compra),
                                            OUTPUT l-pendente).

                    IF  l-pendente THEN DO:
                                            {method/svc/errors/inserr.i &ErrorNumber="17022"  /*Documento estÿ pendente de aprova‡Æo*/
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"}
                    END.
                END.
            END.
        END.

        IF RowObject.num-pedido <> 0 THEN DO:
            FOR FIRST pedido-compr
                WHERE pedido-compr.num-pedido = RowObject.num-pedido NO-LOCK:
            END.
            IF NOT AVAIL pedido-compr THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-pedido-de-compra AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Pedido_de_Compra" *}
                ASSIGN c-lbl-liter-pedido-de-compra = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="2"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-lbl-liter-pedido-de-compra"}
            END.
            ELSE DO:
                IF  pedido-compr.situacao = 3 THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="7169"  /*Pedido de compra eliminado*/
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"}
                END.

				{utp/ut-liter.i "Seq_conv:_" *}
				c-param-msg	= return-value  + string(RowObject.seq-item).
				run rep/re1008.p persistent set h-re1008.
				run pi-execute in h-re1008 (input RowObject.num-pedido,
											input doc-orig-nfe.cod-estabel,
											input c-param-msg,
											OUTPUT TABLE RowErrors APPEND).
				delete procedure h-re1008.
				h-re1008 = ?.

				if not can-find(RowErrors where RowErrors.ErrorNumber = 57853) THEN do:
					IF  pedido-compr.end-entrega <> doc-orig-nfe.cod-estabel THEN DO:
						{method/svc/errors/inserr.i &ErrorNumber="18800"  /*Estabelecimento de entrega do pedido ‚ diferente do estabelecimento do documento.*/
													&ErrorType="EMS"
													&ErrorSubType="WARNING"}
					END.
				end.
                RUN rep/re1007.p (input pedido-compr.cod-emitente,
                                  input doc-orig-nfe.cod-emitente,
                                  input-output table RowErrors). /*Verificação fornecedor da nota difere do pedido e/ou mesma matriz*/
            END.

        END.
        IF  RowObject.qtd-interna <= 0
        AND RowObject.int-2 <> 23    /*Nota de cr‚dito e d‚bito*/ THEN DO:
                 {method/svc/errors/inserr.i &ErrorNumber="1368"  /*Quantidade deve ser maior que zero*/
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"}

        END.
        /*******************************/

        /** VALIDA€ÇO QUANTIDADE **/
        run validaContratoOrdem (output l-contrato,
                                 output i-total   ).

        if not l-contrato
        or i-total = 0 THEN DO:
           RUN validaVariacaoQtd (INPUT RowObject.numero-ordem,
                                  INPUT RowObject.parcela,
                                  INPUT RowObject.qtd-interna,
                                  INPUT RowObject.it-codigo,
                                  OUTPUT l-erro).
        END.
        ELSE DO:
            IF RowObject.numero-ordem > 0 THEN
               RUN pi-valida-contrato.
        END.
        if l-erro then do:
            if  param-re.aceita-var then
                {method/svc/errors/inserr.i
                                    &ErrorNumber="18799" /*mensagem: Quantidade fora da variacao permitida.*/
                                    &ErrorType="EMS"
                                    &ErrorSubType="WARNING" }

            else
                /* Inicio -- Projeto Internacional */
                DO:
                DEFINE VARIABLE c-lbl-liter-quantidade AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "quantidade" *}
                ASSIGN c-lbl-liter-quantidade = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                    &ErrorNumber="28643" /*mensagem: Variacao de quantidade nao permitida.*/
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-liter-quantidade"}
                END.
        end.
        /*******************************/


        if (not can-find(first natur-oper
                         where natur-oper.nat-operacao = RowObject.nat-operacao
                         and   natur-oper.terceiros)
            or (doc-orig-nfe.int-1 = 1)) /* Compra. */
        and RowObject.numero-ordem <> 0 then do:
            /** VALIDA€ÇO VALOR **/
            RUN validaVariacaoValor(INPUT  doc-orig-nfe.cod-estabel,
                                    INPUT  doc-orig-nfe.dt-emissao,
                                    OUTPUT l-erro).

			/* inicio ponto upc */
            IF  c-nom-prog-upc-mg97 <> "" THEN DO:  /* Se existe UPC cadastrada */
    			FOR EACH tt-epc WHERE tt-epc.cod-event = "before-message-value-dif":U :
    				DELETE tt-epc.
    			END.
    			CREATE tt-epc.
    			ASSIGN tt-epc.cod-event     = "before-message-value-dif":U
    				   tt-epc.cod-parameter = "HANDLE item-doc-orig-nfe":U
    				   tt-epc.val-parameter = STRING(TEMP-TABLE rowObject:HANDLE).

    			{include/i-epc201.i  "before-message-value-dif" }

    			if return-value = "OK":U then l-erro = no.
    			else if return-value = "NOK":U then l-erro = yes.
            END.
			/* fim ponto upc */

            IF l-erro THEN DO:
                IF param-re.aceita-var THEN DO:
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="18796"
                                        &ErrorType="EMS"
                                        &ErrorSubType="WARNING"}
                END.
                ELSE DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-valor AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "valor" *}
                    ASSIGN c-lbl-liter-valor = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="28643" /*mensagem: Variacao de valor nÆo permitida*/
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-valor"}
                END.
            END.
        end.
        /*********************/



        /** VALIDA€ÇO NATUREZA **/
        IF RowObject.nat-operacao <> "" THEN DO:
            IF NOT CAN-FIND(FIRST natur-oper
                            WHERE natur-oper.nat-operacao = RowObject.nat-operacao) THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-natureza-de-operacao AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Natureza_de_Opera‡Æo" *}
                ASSIGN c-lbl-liter-natureza-de-operacao = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="2"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-lbl-liter-natureza-de-operacao"}
            END.
        END.



        /** VALIDA€ÇO CLASSIFICA€ÇO FISCAL **/
        IF  RowObject.class-fiscal <> ""
        AND NOT CAN-FIND(FIRST classif-fisc
                        WHERE classif-fisc.class-fiscal = RowObject.class-fiscal) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-classificacao-fiscal AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Classifica‡Æo_Fiscal" *}
            ASSIGN c-lbl-liter-classificacao-fiscal = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-classificacao-fiscal"}
        END.

        run findEmpresa (input RowObject.ch-acesso-comp-nfe,
                         output i-empresa).

        /** VALIDA€ÇO CONTA CONTABIL **/
        IF  RowObject.ct-codigo <> "":U THEN DO:

            if not valid-handle(h_api_cta_ctbl)
            or h_api_cta_ctbl:type      <> "PROCEDURE":U
            or h_api_cta_ctbl:file-name <> "prgint/utb/utb743za.py":U then
                run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

            if not valid-handle(h_api_ccusto)
            or h_api_ccusto:type      <> "PROCEDURE":U
            or h_api_ccusto:file-name <> "prgint/utb/utb742za.py":U then
                run prgint/utb/utb742za.py persistent set h_api_ccusto.

           /* Busca dados da conta cont bil */
           ASSIGN v_cod_cta_ctbl = RowObject.ct-codigo.

           run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,                /* EMPRESA EMS2 */
                                                          input        "",                       /* PLANO DE CONTAS */
                                                          input-output v_cod_cta_ctbl,           /* CONTA */
                                                          input        doc-orig-nfe.dt-transacao,/* DATA TRANSACAO */
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
                                                                   input  doc-orig-nfe.cod-estabel,  /* ESTABELECIMENTO EMS2 */
                                                                   input  "",                        /* PLANO CONTAS */
                                                                   input  v_cod_cta_ctbl,            /* CONTA */
                                                                   input  doc-orig-nfe.dt-transacao, /* DT TRANSACAO */
                                                                   output v_log_utz_ccusto,          /* UTILIZA CCUSTO ? */
                                                                   output table tt_log_erro).        /* ERROS */
                IF v_log_utz_ccusto THEN DO:
                    /* Busca dados do centro de custo */
                    ASSIGN v_cod_ccusto = RowObject.sc-codigo.
                    run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,                /* EMPRESA EMS2 */
                                                               input  "",                       /* CODIGO DO PLANO CCUSTO */
                                                               input  v_cod_ccusto,             /* CCUSTO */
                                                               input  doc-orig-nfe.dt-transacao,/* DATA DE TRANSACAO */
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
        END.

        /** VALIDA€ÇO ORDEM DE PRODUCAO **/
        IF  RowObject.nr-ord-produ <> 0
        AND NOT CAN-FIND(FIRST ord-prod
                         WHERE ord-prod.nr-ord-produ = RowObject.nr-ord-produ) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-ordem-de-producao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Ordem_de_Produ‡Æo" *}
            ASSIGN c-lbl-liter-ordem-de-producao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-ordem-de-producao"}
        END.

        IF CAN-FIND (FIRST item-uni-estab
                     WHERE item-uni-estab.it-codigo    = rowObject.it-codigo
                     AND   item-uni-estab.cod-estabel  = doc-orig-nfe.cod-estabel
                     AND   item-uni-estab.cod-obsoleto = 4) then do:
            {method/svc/errors/inserr.i
                            &ErrorNumber="25983" /*Item esta obsoleto no estabelecimento */
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="rowObject.it-codigo + '~~~~' + doc-orig-nfe.cod-estabel"}
        end.

        /*Valida relacionamento item x estabelecimento*/
        IF NOT CAN-FIND (FIRST item-uni-estab
                         WHERE item-uni-estab.it-codigo    = rowObject.it-codigo
                         AND   item-uni-estab.cod-estabel  = doc-orig-nfe.cod-estabel) THEN DO:
            {method/svc/errors/inserr.i
                           &ErrorNumber="25904"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters="RowObject.it-codigo + '~~~~' + doc-orig-nfe.cod-estabel"}
            RETURN "NOK":U.
        END.

        /*Natureza inativa*/
        IF CAN-FIND (FIRST natur-oper
                     WHERE natur-oper.nat-operacao    = rowObject.nat-operacao
                     AND   natur-oper.nat-ativa = NO) THEN DO:
            {method/svc/errors/inserr.i
                            &ErrorNumber="26759"
                            &ErrorType="EMS":U
                            &ErrorSubType="ERROR":U }
        END.

        /** VALIDA€ÇO REFERENCIA **/
        FOR FIRST ITEM
            WHERE ITEM.it-codigo = RowObject.it-codigo NO-LOCK:
        END.

        RUN enableFields (INPUT "it-codigo":U, OUTPUT l-hab-item).

        IF l-hab-item
        AND NOT AVAIL ITEM THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-item AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item" *}
            ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-item"}
        END.

        IF  AVAIL ITEM
        AND ITEM.tipo-con-est = 4
        AND NOT CAN-FIND(FIRST ref-item
                         WHERE ref-item.it-codigo = RowObject.it-codigo
                           AND ref-item.cod-refer = RowObject.cod-refer) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="33928"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="RowObject.cod-refer + '~~~~' + RowObject.it-codigo"}
        END.

        IF ITEM.tipo-con-est = 4 AND
           RowObject.numero-ordem <> 0 THEN DO:
           FOR FIRST prazo-compra FIELDS (numero-ordem parcela cod-refer)
               WHERE prazo-compra.numero-ordem = RowObject.numero-ordem
                 AND prazo-compra.parcela      = RowObject.parcela
                 AND prazo-compra.cod-refer   <> RowObject.cod-refer NO-LOCK:

               {method/svc/errors/inserr.i
                           &ErrorNumber="56951" /*Referencia da parcela da OC eh diferente do item da nota*/
                           &ErrorType="EMS"
                           &ErrorSubType="WARNING"}
           END.
        END.

        /*Valida‡Æo referente a informa lote ou s‚rie*/
        IF  AVAIL ITEM AND
            RowObject.lote-serie = "" AND
            (((RowObject.int-2 <> 2   AND /*Devol Cliente*/
               RowObject.int-2 <> 3   AND /*Transferencia*/
               RowObject.int-2 <> 5   AND /*Retorno Benef*/
               RowObject.int-2 <> 7   AND /*Fatur Consig*/
               RowObject.int-2 <> 8   AND /*Devol Consig*/
               RowObject.int-2 <> 9   AND /*Devol Consig*/
               RowObject.int-2 <> 12  AND /*Reajuste preco*/
               RowObject.int-2 <> 19  AND /*Ret Dep Fechado*/
               RowObject.int-2 <> 21) AND /*Ret Armaz Geral*/
              NOT CAN-FIND (FIRST tt-rat-lote-medic-nfe
                            WHERE tt-rat-lote-medic-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
                              AND tt-rat-lote-medic-nfe.idi-orig-trad      = 2 /* Traduzido */
                              AND tt-rat-lote-medic-nfe.seq-item           = RowObject.seq-item))
             OR (RowObject.int-2 = 2  and  /* Devolucao de Cliente */
                 NOT CAN-FIND(FIRST item-ref-nfe  /* Sem origem informada */
                              WHERE item-ref-nfe.ch-acesso-comp-nfe  = RowObject.ch-acesso-comp-nfe
                                AND item-ref-nfe.seq-item            = RowObject.seq-item))) THEN DO:

            IF  ITEM.tipo-con-est = 2 THEN DO:
                /*Item controlado por N£mero de S‚rie. Deve ser informada.*/
                 {method/svc/errors/inserr.i &ErrorNumber="8829"
                                             &ErrorType="EMS"
                                             &ErrorSubType="ERROR"}

            END.
            IF  ITEM.tipo-con-est       = 3 THEN DO:

                IF NOT CAN-FIND(FIRST natur-oper
                                WHERE natur-oper.nat-operacao = RowObject.nat-operacao
                                  AND natur-oper.tipo-compra   = 4) /*Material Agregado*/ THEN DO:
                    /*Item controlado por Lote. Lote deve ser informado.*/
                    {method/svc/errors/inserr.i &ErrorNumber="8065"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"}
                END.
            END.
        END.

        /*Valida se possui conta ou ordem de produ‡Æo informada quando for materail agregado*/
        IF CAN-FIND(FIRST natur-oper
                    WHERE natur-oper.nat-operacao = RowObject.nat-operacao
                      AND natur-oper.tipo-compra   = 4) THEN DO:
            IF  AVAIL ITEM
            AND RowObject.ct-codigo     = ""
            AND RowObject.nr-ord-produ  = 0 THEN DO:
                DEFINE VARIABLE c-lbl-liter-sequencia AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Sequˆncia:"}
                ASSIGN c-lbl-liter-sequencia = TRIM(RETURN-VALUE) + " ".
                {method/svc/errors/inserr.i &ErrorNumber="6726" /*Conta contabil deve ser informada*/
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-lbl-liter-sequencia + STRING(RowObject.seq-item)"}
            END.
        END.

        /** VALIDA€ÇO DEPOSITO **/
        IF  RowObject.cod-depos <> ""
        AND NOT CAN-FIND(FIRST deposito
                         WHERE deposito.cod-depos = RowObject.cod-depos) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-deposito AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Dep¢sito" *}
            ASSIGN c-lbl-liter-deposito = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-deposito"}
        END.

        /* Valida se o dep½sito for CQ e o item n’o CQ, n’o deixa prosseguir  */
        IF RowObject.cod-depos <> "" THEN DO:
            IF  CAN-FIND(FIRST item-uni-estab NO-LOCK
                         WHERE item-uni-estab.it-codigo      = RowObject.it-codigo      AND
                               item-uni-estab.cod-estabel    = doc-orig-nfe.cod-estabel AND
                               item-uni-estab.contr-qualid   = NO) AND
                CAN-FIND(FIRST deposito NO-LOCK
                         WHERE deposito.cod-depos = RowObject.cod-depos AND
                               deposito.ind-dep-cq) THEN DO:
                        {method/svc/errors/inserr.i
                                            &ErrorNumber="57097"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"}
            END.
        END.

        /** VALIDA€ÇO LOCALIZA€ÇO **/
        IF  RowObject.cod-localiz <> ""
        AND NOT CAN-FIND(FIRST localizacao
                         WHERE localizacao.cod-estabel = doc-orig-nfe.cod-estabel
                           AND localizacao.cod-depos   = RowObject.cod-depos
                           AND localizacao.cod-localiz = RowObject.cod-localiz) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-localizacao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Localiza‡Æo" *}
            ASSIGN c-lbl-liter-localizacao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-localizacao"}
        END.

       IF  i-pais-impto-usuario = 1 AND
           CAN-FIND( FIRST funcao
                     WHERE funcao.cd-funcao = "WMS-SAAS"
                       AND funcao.ativo     = YES) AND
           CAN-FIND(FIRST deposito NO-LOCK
                    WHERE deposito.cod-depos = RowObject.cod-depos
                      AND deposito.log-wms-externo) AND
           RowObject.cod-localiz <> "" THEN DO:
           {method/svc/errors/inserr.i &ErrorNumber="57560"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"}
       END.

        IF ITEM.tipo-con-est = 1 THEN DO:
            IF RowObject.lote-serie <> "":U AND RowObject.lote-serie <> ? THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="27033" /* Item com tipo controle serial. Lote nao deve ser informado. */
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"}
            END.
            IF RowObject.dt-vali-lote <> ? THEN DO:
                {utp/ut-liter.i Item_com_tipo_controle_serial._Data_validade_lote *}
                {method/svc/errors/inserr.i &ErrorNumber="7446" /* Item com tipo controle serial. Data de validade do lote nao deve ser informada. */
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="RETURN-VALUE"}
            END.
        END.

        if  avail item
        and not item.fraciona
        and integer(RowObject.qtd-interna) <> RowObject.qtd-interna then do:
            {method/svc/errors/inserr.i
                &ErrorNumber="6381" /*Quantidade nao pode ser fracionada*/
                &ErrorType="EMS"
                &ErrorSubType="ERROR"}
        end.

        IF c-origem-save = "APIREST":U THEN DO:
            RUN validateRatLoteMedicNfe.
            RUN validateFIFO.
        END.

        /* Valida‡Æo de unidade de neg¢cio */
        def var seq-erro    as int no-undo.
        def var i-tipo-msg  as int no-undo.

        if not valid-handle(h-cdapi024)
            or h-cdapi024:type <> "PROCEDURE"
            or h-cdapi024:file-name <> "cdp/cdapi024.p" then do:
            run cdp/cdapi024.p persistent set h-cdapi024.
        end.

        if  l-mat-unid-negoc then do:
            /* Para este tipo de nota, deve ser validado somente na geracao do documento. */
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
                    run ValidaUnidadeNegocioEstabel in h-cdapi024 (input  doc-orig-nfe.cod-estabel,
                                                                   input  doc-orig-nfe.dt-transacao,
                                                                   input  RowObject.cod-unid-negoc,
                                                                   output table tt-erro).

                    run ValidaUnidadeNegocioUsuario in h-cdapi024 (input c-seg-usuario,
                                                                   input RowObject.cod-unid-negoc,
                                                                   output table tt-erro append).

                    for each tt-erro:
                        for last RowErrors:
                            assign seq-erro = RowErrors.ErrorSequence + 1.
                        end.
                        for first cadast_msg fields(idi_tip_msg) no-lock
                            where cadast_msg.cdn_msg = tt-erro.cd-erro:
                            assign i-tipo-msg = cadast_msg.idi_tip_msg.
                        end.
                        create RowErrors.
                        assign RowErrors.ErrorSequence      = seq-erro
                               RowErrors.ErrorNumber        = tt-erro.cd-erro
                               RowErrors.ErrorDescription   = tt-erro.mensagem
                               RowErrors.ErrorType          = "EMS"
                               RowErrors.ErrorHelp          = ""
                               RowErrors.ErrorSubType       = if i-tipo-msg = 1 then "ERROR":U
                                                              else "WARNING":U.
                    end.
                end.
            end.
        end.

        IF  VALID-HANDLE(h-cdapi024)        AND
            h-cdapi024:TYPE = "PROCEDURE":U AND
            h-cdapi024:FILE-NAME = "cdp/cdapi024.p":U THEN DO:
            DELETE PROCEDURE h-cdapi024.
            ASSIGN h-cdapi024 = ?.
        END.
        /* FIM - Valida‡Æo de unidade de neg¢cio */

        IF CAN-FIND(FIRST param-convrsr-nfe
                    WHERE param-convrsr-nfe.log-relacdo-item-fornec) AND
           NOT CAN-FIND(RowErrors WHERE RowErrors.ErrorSubType = 'ERROR':U) THEN
            RUN relacionaItemFornec.

    END. /* END IF pType = "UPDATE" */


    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaVariacaoQtd DBOProgram
PROCEDURE validaVariacaoQtd :
/*------------------------------------------------------------------------------
  Purpose: Realiza valida‡Æo de varia‡Æo de quantidade considerando que a OC est  alocada
  Parameters:  pi-numero-ordem: N£mero da ordem de compra
               pi-parcela:      Parcela
               pde-qtd-interna: Quantidade interna
               pc-it-codigo:    C¢digo do item
               l-erro-qtd:      Indica que a quantidade est  fora da varia‡Æo permitida

  Notes:
------------------------------------------------------------------------------*/

    define input    param pi-numero-ordem   as integer      no-undo.
    define input    param pi-parcela        as integer      no-undo.
    define input    param pde-qtd-interna   as decimal      no-undo.
    define input    param pc-it-codigo      as character    no-undo.
    define output   param l-erro-qtd        as logical      no-undo.

    define variable de-limite           as decimal no-undo.
    define variable de-percentual       as decimal no-undo.
    define variable de-qtd-tot-ordem    as decimal no-undo.
    define variable de-qtd-var          as decimal no-undo.
    define variable de-qtd-aux          as decimal no-undo.
    define variable de-saldo-usado      as decimal no-undo.
    define variable de-valor-saldo      as decimal no-undo.
    define variable de-var-max-perc     as decimal no-undo.
    define variable de-var-max-lim      as decimal no-undo.

    if not avail param-re then
        find first param-re
             WHERE param-re.usuario = c-seg-usuario no-lock no-error.

    assign l-erro-qtd = no.

    find first prazo-compra no-lock
        where prazo-compra.numero-ordem = pi-numero-ordem
        and   prazo-compra.parcela      = pi-parcela no-error.
    if avail prazo-compra THEN DO:

        assign de-valor-saldo = prazo-compra.quant-saldo - prazo-compra.dec-1
               de-saldo-usado = prazo-compra.dec-1.
        IF de-valor-saldo < 0 THEN
           ASSIGN de-valor-saldo = 0.

    END.
    ELSE
        RETURN.

    for first ordem-compra no-lock
        where ordem-compra.numero-ordem = pi-numero-ordem:
    end.

    if avail ordem-compra then do:
        FIND FIRST bf{&TableName} NO-LOCK
            WHERE bf{&TableName}.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
              AND bf{&TableName}.idi-orig-trad      = RowObject.idi-orig-trad
              AND bf{&TableName}.num-pedido         = ordem-compra.num-pedido
              AND bf{&TableName}.numero-ordem       = pi-numero-ordem
              AND bf{&TableName}.parcela            = pi-parcela
              AND bf{&TableName}.seq-item           = RowObject.seq-item  NO-ERROR.
        IF AVAIL bf{&TableName} THEN DO:
            ASSIGN de-saldo-usado = de-saldo-usado - bf{&TableName}.qtd-interna.

            FIND FIRST prazo-compra no-lock
                WHERE prazo-compra.numero-ordem = bf{&TableName}.numero-ordem
                  AND prazo-compra.parcela      = bf{&TableName}.parcela no-error.
            IF AVAIL prazo-compra THEN DO:
                ASSIGN  de-valor-saldo = prazo-compra.quant-saldo - de-saldo-usado.
            END.

            IF de-valor-saldo < 0 THEN
                ASSIGN de-valor-saldo = 0.

            IF de-saldo-usado < 0 THEN
                ASSIGN de-saldo-usado = 0.

        END.
    end.

    for first item-uni-estab fields(it-codigo lim-var-valor cod-estabel
                                    var-val-re-maior var-qtd-re lim-var-qtd
                                    deposito-pad cod-localiz loc-unica contr-qualid)
    where item-uni-estab.it-codigo   = pc-it-codigo
      and item-uni-estab.cod-estabel = doc-orig-nfe.cod-estabel no-lock:
    end.

    if  not avail item-uni-estab
    or (     avail item-uni-estab
        and (   item-uni-estab.var-val-re-maior = 0
             or item-uni-estab.lim-var-valor    = 0
             or item-uni-estab.var-qtd-re       = 0
             or item-uni-estab.lim-var-qtd      = 0 ) ) then do:
        for first item-mat
            fields ( it-codigo      var-val-re-maior
                     lim-var-valor  var-qtd-re
                     lim-var-qtd    lim-var-valor     )
            where item-mat.it-codigo = pc-it-codigo no-lock:
        end.
    end.

    if  avail item-uni-estab then do:
        if item-uni-estab.var-qtd-re > 0 then
            assign de-percentual = item-uni-estab.var-qtd-re.
        if item-uni-estab.lim-var-qtd > 0 then
            assign de-limite = item-uni-estab.lim-var-qtd.
    end.
    else do:
        if avail item-mat then
            assign de-percentual = item-mat.var-qtd-re
                   de-limite     = item-mat.lim-var-qtd.
    end.

    for each prazo-compra use-index ordem
        where prazo-compra.numero-ordem = pi-numero-ordem
        no-lock:

        assign de-qtd-tot-ordem = de-qtd-tot-ordem + prazo-compra.quantidade.

        IF (prazo-compra.quant-receb + (prazo-compra.dec-1 - pde-qtd-interna) - prazo-compra.quant-rejeit) > prazo-compra.quantidade THEN DO:
            ASSIGN de-qtd-var = (prazo-compra.quant-receb + (prazo-compra.dec-1 - pde-qtd-interna) - prazo-compra.quant-rejeit) - prazo-compra.quantidade.
        END.

    end.

    assign de-qtd-aux = round((de-qtd-tot-ordem * de-percentual / 100) , 4).
    assign de-qtd-aux = de-qtd-aux - de-qtd-var.
    assign de-qtd-aux = if   de-qtd-aux < 0 then 0
                        else de-qtd-aux.

    if  param-re.aceita-var then
        assign de-var-max-perc = de-valor-saldo + de-qtd-aux
               de-var-max-lim  = de-valor-saldo + de-limite.
    else
        assign de-var-max-perc = de-valor-saldo
               de-var-max-lim  = de-valor-saldo.

    if  de-percentual = 0
    and de-limite     = 0 then do:
        if  pde-qtd-interna > de-var-max-perc
        or  pde-qtd-interna > de-var-max-lim then
            assign l-erro-qtd = yes.
    end.
    else do:
        if  pde-qtd-interna <= de-var-max-perc
        or  de-percentual = 0 then
            if  pde-qtd-interna > de-var-max-lim
            and de-limite <> 0 then
                assign l-erro-qtd = yes.
            else
                assign l-erro-qtd = no.
        else
            assign l-erro-qtd = yes.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaVariacaoValor DBOProgram
PROCEDURE validaVariacaoValor :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAM p-cod-estabel LIKE doc-orig-nfe.cod-estabel.
    DEFINE INPUT  PARAM p-dt-emissao  LIKE doc-orig-nfe.dt-emissao.
    DEFINE OUTPUT PARAM l-erro AS LOG INIT NO NO-UNDO.

    def var de-vl-aux          as decimal                             no-undo.
    DEF VAR de-val-contrato    AS DECIMAL format ">>>>>,>>>,>>9.9999" NO-UNDO.
    DEF VAR de-val-formula     AS DECIMAL format ">>>>>,>>>,>>9.9999" NO-UNDO.
    DEF VAR de-vl-merc-liq     AS DECIMAL                             NO-UNDO.
    DEF VAR de-vl-merc-liq-xml AS DECIMAL                             NO-UNDO.
    def var de-var-max-aux     as decimal                             no-undo.
    def var de-valor-max-perc  as decimal                             no-undo.
    def var de-valor-max-lim   as decimal                             no-undo.
    DEF VAR de-var-perc-vl     LIKE item-uni-estab.var-val-re-maior   NO-UNDO.
    DEF VAR var-lim-vl         LIKE item-uni-estab.lim-var-valor      NO-UNDO.
    DEF VAR l-erro-co          AS LOG                                 no-undo.
    DEF VAR l-contrato         AS LOG                                 no-undo.
    DEF VAR i-total            AS INT                                 no-undo.
    DEF VAR de-preco-cc        AS DEC                                 no-undo.
    DEF VAR de-desconto-cc     AS DEC                                 no-undo.
    DEF VAR de-taxa            AS DEC                                 no-undo.
    DEF VAR de-aux             AS DECIMAL format ">>>>>,>>>,>>9.9999" NO-UNDO.
    DEF VAR de-aux2            as dec format "->>9.99"                no-undo.

    FOR FIRST ordem-compra
        WHERE ordem-compra.numero-ordem = RowObject.numero-ordem NO-LOCK:

        RUN rep/re1908.p(INPUT  ROWID(ordem-compra),
                         INPUT  p-dt-emissao,
                         OUTPUT de-preco-cc,
                         OUTPUT de-desconto-cc,
                         OUTPUT de-taxa).

        FIND FIRST param-global NO-LOCK NO-ERROR.

        IF param-global.modulo-cn THEN DO:
            RUN cnp/cn9060.p(INPUT RowObject.int-1, /* NUM-SEQ-EVENT */
                             INPUT ?,
                             INPUT ordem-compra.numero-ordem,
                             INPUT 0,
                             INPUT NO,
                             INPUT RowObject.qtd-interna,
                             INPUT p-dt-emissao,
                             OUTPUT de-val-contrato,
                             OUTPUT de-aux,
                             OUTPUT de-val-formula,
                             OUTPUT de-aux2).

            IF de-val-formula > 0 THEN
                ASSIGN de-preco-cc = de-val-formula.
            ELSE
                IF de-val-contrato > 0 THEN
                    ASSIGN de-preco-cc = de-val-contrato.
        END.

        ASSIGN de-vl-merc-liq = de-preco-cc - de-desconto-cc.

        ASSIGN de-vl-merc-liq = ROUND(de-vl-merc-liq, 5)
               de-vl-aux      = de-vl-merc-liq * RowObject.qtd-comercial. /*RowObject.qtd-comercial*/

        FOR FIRST item-uni-estab FIELDS(it-codigo lim-var-valor cod-estabel var-val-re-maior var-qtd-re
                                        lim-var-qtd deposito-pad cod-localiz loc-unica contr-qualid)
            WHERE item-uni-estab.it-codigo   = ordem-compra.it-codigo
              AND item-uni-estab.cod-estabel = p-cod-estabel NO-LOCK:
        END.

        IF NOT AVAIL item-uni-estab
        OR (AVAIL item-uni-estab AND
            (item-uni-estab.var-val-re-maior = 0 OR
             item-uni-estab.lim-var-valor    = 0 OR
             item-uni-estab.var-qtd-re       = 0 OR
             item-uni-estab.lim-var-qtd      = 0)) then do:
            for first item-mat fields (it-codigo var-val-re-maior lim-var-valor
                                       var-qtd-re lim-var-qtd    lim-var-valor)
                where item-mat.it-codigo = ordem-compra.it-codigo no-lock:
            end.
        end.

        ASSIGN de-var-perc-vl = IF AVAIL item-uni-estab
                                AND item-uni-estab.var-val-re-maior > 0
                                THEN item-uni-estab.var-val-re-maior
                                ELSE item-mat.var-val-re-maior
               var-lim-vl     = IF AVAIL item-uni-estab
                                AND item-uni-estab.lim-var-valor > 0
                                THEN item-uni-estab.lim-var-valor
                                ELSE item-mat.lim-var-valor.

        FIND FIRST param-re
             WHERE param-re.usuario = c-seg-usuario NO-LOCK NO-ERROR.

        if  param-re.aceita-var then
            assign de-valor-max-perc = round(de-vl-aux +
                                       (de-vl-aux * de-var-perc-vl / 100), 2)
                   de-valor-max-lim  = round(de-vl-aux + var-lim-vl,2).
        else
            assign de-valor-max-perc = round(de-vl-aux, 2)
                   de-valor-max-lim  = round(de-vl-aux, 2).

        assign l-erro = no
               de-vl-merc-liq-xml = RowObject.preco-total - (IF RowObject.vl-desconto <> ? THEN RowObject.vl-desconto ELSE 0).

        if  de-var-perc-vl = 0
        and var-lim-vl = 0 then do:
            if  de-vl-merc-liq-xml > de-valor-max-perc
            or  de-vl-merc-liq-xml > de-valor-max-lim then
                assign l-erro = yes.
        end.
        else
            if  de-vl-merc-liq-xml <= de-valor-max-perc
            or  de-var-perc-vl = 0 then
                if  de-vl-merc-liq-xml > de-valor-max-lim
                and var-lim-vl <> 0 then
                    assign l-erro = yes.
                else
                    assign l-erro = no.
            else
                assign l-erro = yes.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaValidNatTerc DBOProgram
PROCEDURE retornaValidNatTerc :
/*------------------------------------------------------------------------------
  Purpose: Retorna se a natureza ‚ de terceiro
  Parameters: p-nro-docto    - n£mero do documento
              p-serie-docto  - s‚rie do documento
              p-nat-operacao - natureza de opera‡Æo do item

  Notes:
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-nro-docto    LIKE doc-orig-nfe.nro-docto         NO-UNDO.
    DEF INPUT  PARAM p-serie-docto  LIKE doc-orig-nfe.serie-docto       NO-UNDO.
    DEF INPUT  PARAM p-nat-operacao LIKE item-doc-orig-nfe.nat-operacao NO-UNDO.

    FIND FIRST doc-orig-nfe NO-LOCK
         WHERE doc-orig-nfe.nro-docto     = p-nro-docto
           AND doc-orig-nfe.serie-docto   = p-serie-docto
           AND doc-orig-nfe.idi-orig-trad = 2 /* Traduzido */ NO-ERROR.
    IF AVAIL doc-orig-nfe THEN DO:

        FIND FIRST item-doc-orig-nfe NO-LOCK
             WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = doc-orig-nfe.ch-acesso-comp-nfe
               AND item-doc-orig-nfe.idi-orig-trad      = doc-orig-nfe.idi-orig-trad
               AND item-doc-orig-nfe.nat-operacao       = p-nat-operacao NO-ERROR.
        IF AVAIL item-doc-orig-nfe THEN DO:

            FIND FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = item-doc-orig-nfe.nat-operacao
                   AND natur-oper.terceiros    = YES
                   AND natur-oper.tp-oper-terc = 2 NO-ERROR.
            IF NOT AVAIL natur-oper THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-nota-fiscal AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Nota_Fiscal" *}
                ASSIGN c-lbl-liter-nota-fiscal = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-beneficiamento AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "beneficiamento" *}
                ASSIGN c-lbl-liter-beneficiamento = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-merge-nota-fiscal-beneficiamento AS CHARACTER NO-UNDO.
                ASSIGN c-lbl-merge-nota-fiscal-beneficiamento = c-lbl-liter-nota-fiscal + ' ' + "~~" + ' ' + c-lbl-liter-beneficiamento.
                {method/svc/errors/inserr.i &ErrorNumber="52003"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-lbl-merge-nota-fiscal-beneficiamento"}
                RETURN "NOK":U.
            END.
        END.
        ELSE DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-item-documento-nfe AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item_documento_Nfe" *}
            ASSIGN c-lbl-liter-item-documento-nfe = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-item-documento-nfe"}
            RETURN "NOK":U.
        END.
    END.
    ELSE DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-documento-origem-nfe AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Documento_Origem_Nfe" *}
        ASSIGN c-lbl-liter-documento-origem-nfe = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-liter-documento-origem-nfe"}
        RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidaItemOrdProd DBOProgram
PROCEDURE ValidaItemOrdProd :
/*------------------------------------------------------------------------------
  Purpose: Valida se o item tem ordemProducao
  Parameters: p-chave-acesso - chave o item

  Notes:
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-chave-acesso AS CHAR NO-UNDO.

    FOR EACH item-doc-orig-nfe NO-LOCK
       WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = p-chave-acesso
         AND item-doc-orig-nfe.idi-orig-trad      = 2:

        IF item-doc-orig-nfe.nr-ord-produ <> 0 THEN DO:

            FIND FIRST doc-orig-nfe NO-LOCK
                 WHERE doc-orig-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                   AND doc-orig-nfe.idi-orig-trad      = item-doc-orig-nfe.idi-orig-trad NO-ERROR.

            FIND FIRST ord-prod NO-LOCK
                 WHERE ord-prod.nr-ord-produ = item-doc-orig-nfe.nr-ord-produ NO-ERROR.
            IF AVAIL ord-prod THEN DO:

                IF ord-prod.cod-estabel <> doc-orig-nfe.cod-estabel THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-nota-selecionada AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Nota_selecionada" *}
                    ASSIGN c-lbl-liter-nota-selecionada = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-ordem-de-producao-com-estabele AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "ordem_de_produ‡Æo_com_estabelecimento_diferente" *}
                    ASSIGN c-lbl-liter-ordem-de-producao-com-estabele = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-merge-nota-selecionada-ordem-de-pro AS CHARACTER NO-UNDO.
                    ASSIGN c-lbl-merge-nota-selecionada-ordem-de-pro = c-lbl-liter-nota-selecionada + ' ' + "~~" + ' ' + c-lbl-liter-ordem-de-producao-com-estabele + '.'.
                    {method/svc/errors/inserr.i &ErrorNumber="34995"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-merge-nota-selecionada-ordem-de-pro"}
                    RETURN "NOK":U.
                END.

                IF ord-prod.estado = 8 /*terminada*/ THEN DO:

                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-nota-selecionada-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Nota_selecionada" *}
                    ASSIGN c-lbl-liter-nota-selecionada-2 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-ordem-de-producao-terminada AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "ordem_de_produ‡Æo_Terminada" *}
                    ASSIGN c-lbl-liter-ordem-de-producao-terminada = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-merge-nota-selecionada-ordem-de-pro-2 AS CHARACTER NO-UNDO.
                    ASSIGN c-lbl-merge-nota-selecionada-ordem-de-pro-2 = c-lbl-liter-nota-selecionada-2 + ' ' + "~~" + ' ' + c-lbl-liter-ordem-de-producao-terminada.
                    {method/svc/errors/inserr.i &ErrorNumber="34995"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-merge-nota-selecionada-ordem-de-pro-2"}
                    RETURN "NOK":U.
                END.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaValidNatAgrega DBOProgram
PROCEDURE retornaValidTipoOperAgrega :
/*------------------------------------------------------------------------------
  Purpose: Retorna se todos os tipos de operacao do documento sÆo material
           agragado
  Parameters: p-chave-acesso - chave de acesso ao documento

  Notes:
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-chave-acesso AS CHAR NO-UNDO.

    IF CAN-FIND(FIRST item-doc-orig-nfe
                WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = p-chave-acesso
                  AND item-doc-orig-nfe.idi-orig-trad = 2
                  AND item-doc-orig-nfe.int-2 <> 11) /* material agregado */ THEN
        RETURN "NOK":U.
    ELSE
        RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaValidNatTerceiro DBOProgram
PROCEDURE retornaValidNatTerceiro :
/*------------------------------------------------------------------------------
  Purpose: Retorna se a natureza ‚ do tipo terceiro
  Parameters: p-chave-acesso - chave de acesso ao documento

  Notes:   cfop-natur.num-livre-1 => TIPO OPERACAO
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-chave-acesso AS CHAR NO-UNDO.

    DEFINE VARIABLE l-terceiros AS LOGICAL INITIAL NO NO-UNDO.

    FOR EACH item-doc-orig-nfe
       WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = p-chave-acesso
         AND item-doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK:

        ASSIGN l-terceiros =  item-doc-orig-nfe.int-2 = 5   /* Retorno Benef         */
                           OR item-doc-orig-nfe.int-2 = 7   /* Fatura Consig         */
                           OR item-doc-orig-nfe.int-2 = 8   /* Devolucao Consig      */
                           OR item-doc-orig-nfe.int-2 = 9   /* Devolucao Consig      */
                           OR item-doc-orig-nfe.int-2 = 12  /* Reajuste Preco Consig */
                           OR item-doc-orig-nfe.int-2 = 19  /* Retorno Dep Fechado   */
                           OR item-doc-orig-nfe.int-2 = 21. /* Retorno Armaz Geral   */

        IF l-terceiros THEN
            LEAVE.
    END.

    IF l-terceiros THEN
        RETURN "OK":U.
    ELSE
        RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidaNaturezadeTerceiro DBOProgram
PROCEDURE ValidaNaturezadeTerceiro :
/*------------------------------------------------------------------------------
  Purpose: Valida a natureza de opera‡Æo, para nÆo permitir mudar o tipo de
           opera‡Æo quando for de terceiros.
  Parameters:

  Notes:
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-chave-acesso AS CHAR NO-UNDO.
    DEF INPUT  PARAM p-seq-item     AS INT  NO-UNDO.
    DEF INPUT  PARAM p-nat-oper-old AS CHAR NO-UNDO.
    DEF INPUT  PARAM p-nat-oper-new AS CHAR NO-UNDO.
    DEF INPUT  PARAM p-tp-oper-old  AS INT  NO-UNDO.
    DEF INPUT  PARAM p-tp-oper-new  AS INT  NO-UNDO.

    DEFINE BUFFER bf-natur-oper-old FOR natur-oper.
    DEFINE BUFFER bf-natur-oper-new FOR natur-oper.

    DEFINE VARIABLE c-liter-seq AS CHARACTER NO-UNDO.

    IF CAN-FIND(FIRST item-ref-nfe
                WHERE item-ref-nfe.ch-acesso-comp-nfe  = p-chave-acesso
                  AND item-ref-nfe.seq-item            = p-seq-item) THEN DO:

        FIND FIRST bf-natur-oper-old NO-LOCK
             WHERE bf-natur-oper-old.nat-operacao = p-nat-oper-old NO-ERROR.

        FIND FIRST bf-natur-oper-new NO-LOCK
             WHERE bf-natur-oper-new.nat-operacao = p-nat-oper-new NO-ERROR.

        IF AVAIL bf-natur-oper-old AND AVAIL bf-natur-oper-new THEN DO:
            IF (CAN-FIND(FIRST bf-natur-oper-old
                         WHERE bf-natur-oper-old.nat-operacao = p-nat-oper-old
                           AND bf-natur-oper-old.terceiros
                           AND (bf-natur-oper-old.tp-oper-terc = 2 OR
                                bf-natur-oper-old.tp-oper-terc = 4 OR
                                bf-natur-oper-old.tp-oper-terc = 5 OR
                                bf-natur-oper-old.tp-oper-terc = 6 OR
                                bf-natur-oper-old.tp-oper-terc = 9 OR
                                bf-natur-oper-old.tp-oper-terc = 11))) THEN DO:

                IF (CAN-FIND(FIRST bf-natur-oper-new
                             WHERE bf-natur-oper-new.nat-operacao = p-nat-oper-new
                             AND (NOT bf-natur-oper-new.terceiros OR
                                  NOT(bf-natur-oper-new.tp-oper-terc = 2 OR
                                      bf-natur-oper-new.tp-oper-terc = 4 OR
                                      bf-natur-oper-new.tp-oper-terc = 5 OR
                                      bf-natur-oper-new.tp-oper-terc = 6 OR
                                      bf-natur-oper-new.tp-oper-terc = 9 OR
                                      bf-natur-oper-new.tp-oper-terc = 11)))) OR
                    (CAN-FIND(FIRST bf-natur-oper-new
                             WHERE bf-natur-oper-new.nat-operacao = p-nat-oper-new
                             AND ( bf-natur-oper-new.terceiros OR
                                  (bf-natur-oper-new.tp-oper-terc = 2 OR
                                   bf-natur-oper-new.tp-oper-terc = 4 OR
                                   bf-natur-oper-new.tp-oper-terc = 5 OR
                                   bf-natur-oper-new.tp-oper-terc = 6 OR
                                   bf-natur-oper-new.tp-oper-terc = 9 OR
                                   bf-natur-oper-new.tp-oper-terc = 11)))) THEN DO:

                    IF  bf-natur-oper-old.terceiros    <> bf-natur-oper-new.terceiros
                    OR (bf-natur-oper-old.terceiros    =  bf-natur-oper-new.terceiros
                    AND bf-natur-oper-old.tp-oper-terc <> bf-natur-oper-new.tp-oper-terc) THEN DO:

                        {utp/ut-liter.i "Seq" *}
                        ASSIGN c-liter-seq = RETURN-VALUE + ": " + STRING(p-seq-item).

                        /*Tipo opera‡Æo atual ‚ diferente do tipo opera‡Æo anterior*/
                        {method/svc/errors/inserr.i &ErrorNumber="55711"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="c-liter-seq"}

                        RETURN "NOK":U.
                    END.
                END.
            END.
        END.
        ELSE DO:
            IF p-tp-oper-old <> p-tp-oper-new THEN DO:
                {utp/ut-liter.i "Seq" *}
                ASSIGN c-liter-seq = RETURN-VALUE + ": " + STRING(p-seq-item).

                /*Tipo opera‡Æo atual ‚ diferente do tipo opera‡Æo anterior*/
                {method/svc/errors/inserr.i &ErrorNumber="55711"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-liter-seq"}
                RETURN "NOK":U.
            END.
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidaNfCreditoDebito DBOProgram
PROCEDURE ValidaNfCreditoDebito :
/*------------------------------------------------------------------------------
  Purpose: Valida o campo de finalidade relacionado com a natureza de opera‡Æo,
           para nÆo permitir mudar o tipo de opera‡Æo.
  Parameters:

  Notes:
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-chave-acesso AS CHAR NO-UNDO.
    DEF INPUT  PARAM p-nat-oper-new AS CHAR NO-UNDO.
    DEF INPUT  PARAM p-tp-oper-old  AS INT  NO-UNDO.
    DEF INPUT  PARAM p-tp-oper-new  AS INT  NO-UNDO.

    DEFINE BUFFER bf-natur-oper-aux FOR natur-oper.

    DEFINE VARIABLE c-liter-1 AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-liter-2 AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-liter-3 AS CHARACTER   NO-UNDO.

    IF NOT AVAIL doc-orig-nfe THEN DO:
        FOR FIRST doc-orig-nfe
            WHERE doc-orig-nfe.ch-acesso-comp-nfe = p-chave-acesso
              AND doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK:
        END.

    END.

    FIND FIRST bf-natur-oper-aux NO-LOCK
         WHERE bf-natur-oper-aux.nat-operacao = p-nat-oper-new NO-ERROR.
    IF AVAIL bf-natur-oper-aux THEN DO:
        IF (   doc-orig-nfe.cod-finalidade = '5'   //finalidade cr‚dito
            OR doc-orig-nfe.cod-finalidade = '6')  //finalidade d‚bito
        and bf-natur-oper-aux.tipo-compra <> 9 /*nota de credito/debito*/ THEN DO:
                IF doc-orig-nfe.cod-finalidade = '5' THEN DO:
                    {utp/ut-liter.i 5(Cr‚dito) * r }
                END.
                ELSE DO:
                   {utp/ut-liter.i 6(D‚bito) * r }
                END.
                ASSIGN c-liter-1 = TRIM(RETURN-VALUE).
                {utp/ut-liter.i natureza_de_opera‡Æo_com_o_tipo_compra  * r }
                ASSIGN c-liter-2 = TRIM(RETURN-VALUE).
                {utp/ut-liter.i Nota_de_Cr‚dito/D‚bito * r }
                ASSIGN c-liter-3 = TRIM(RETURN-VALUE).

                {method/svc/errors/inserr.i &ErrorNumber="58158"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-liter-1 + '~~~~' + c-liter-2 + '~~~~' + c-liter-3"}

        END.
        IF  doc-orig-nfe.cod-finalidade <> '5'   //finalidade cr‚dito
        AND doc-orig-nfe.cod-finalidade <> '6'  //finalidade d‚bito
        AND bf-natur-oper-aux.tipo-compra = 9 /*nota de credito/debito*/ THEN DO:
              {utp/ut-liter.i Natureza_de_opera‡Æo_com_o_tipo_compra_igual_Nota_cr‚dito/d‚bito * r }
              ASSIGN c-liter-1 = TRIM(RETURN-VALUE).

              {method/svc/errors/inserr.i
                                  &ErrorNumber="58159"
                                  &ErrorType="EMS":U
                                  &ErrorSubType="ERROR":U
                                  &ErrorParameters="doc-orig-nfe.cod-finalidade + '~~~~' + c-liter-1"}

        END.
    END.
    ELSE DO:
        IF p-tp-oper-old <> p-tp-oper-new THEN DO:
            IF (   doc-orig-nfe.cod-finalidade = '5'   //finalidade cr‚dito
                OR doc-orig-nfe.cod-finalidade = '6')  //finalidade d‚bito
            and p-tp-oper-new <> 23 /*nota de credito/debito*/ THEN DO:
                    IF doc-orig-nfe.cod-finalidade = '5' THEN DO:
                        {utp/ut-liter.i 5(Cr‚dito) * r }
                    END.
                    ELSE DO:
                       {utp/ut-liter.i 6(D‚bito) * r }
                    END.
                    ASSIGN c-liter-1 = TRIM(RETURN-VALUE).
                    {utp/ut-liter.i tipo_de_opera‡Æo  * r }
                    ASSIGN c-liter-2 = TRIM(RETURN-VALUE).
                    {utp/ut-liter.i Nota_de_Cr‚dito/D‚bito * r }
                    ASSIGN c-liter-3 = TRIM(RETURN-VALUE).

                    {method/svc/errors/inserr.i &ErrorNumber="58158"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="c-liter-1 + '~~~~' + c-liter-2 + '~~~~' + c-liter-3"}

            END.
            IF  doc-orig-nfe.cod-finalidade <> '5'   //finalidade cr‚dito
            AND doc-orig-nfe.cod-finalidade <> '6'   //finalidade d‚bito
            AND p-tp-oper-new = 23 /*nota de credito/debito*/ THEN DO:
                {utp/ut-liter.i Tipo_de_opera‡Æo_de_Nota_de_cr‚dito/d‚bito * r }
                ASSIGN c-liter-1 = TRIM(RETURN-VALUE).

                {method/svc/errors/inserr.i
                                    &ErrorNumber="58159"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="doc-orig-nfe.cod-finalidade + '~~~~' + c-liter-1"}

            END.
        END.

    END.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SugereContaContabil DBOProgram
PROCEDURE SugereContaContabil :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:

  Notes:
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM p-nr-ord-prod  AS INT  NO-UNDO.
    DEF INPUT  PARAM p-numero-ordem AS INT  NO-UNDO.
    DEF INPUT  PARAM p-it-codigo    AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-ct-codigo    AS CHAR NO-UNDO.
    DEF OUTPUT PARAM p-sc-codigo    AS CHAR NO-UNDO.

    IF p-nr-ord-prod <> 0 THEN DO:
       FIND FIRST ord-prod
            WHERE ord-prod.nr-ord-produ = p-nr-ord-prod NO-LOCK NO-ERROR.
        IF AVAIL ord-prod THEN
          ASSIGN p-ct-codigo = ord-prod.ct-codigo
                 p-sc-codigo = ord-prod.sc-codigo.
    END.

    IF p-numero-ordem <> 0 AND p-ct-codigo = " " THEN DO:
        FIND FIRST ordem-compra
             WHERE ordem-compra.numero-ordem = p-numero-ordem NO-LOCK NO-ERROR.
        IF AVAIL ordem-compra THEN DO:
           FIND FIRST ord-prod
                WHERE ord-prod.nr-ord-produ = ordem-compra.ordem-servic NO-LOCK NO-ERROR.
            IF AVAIL ord-prod THEN
                assign p-ct-codigo = ord-prod.ct-codigo
                       p-sc-codigo = ord-prod.sc-codigo.
            ELSE
                ASSIGN p-ct-codigo = ordem-compra.ct-codigo
                       p-sc-codigo = ordem-compra.sc-codigo.
        END.
    END.

    IF p-ct-codigo = " " THEN DO:
        FIND FIRST ITEM
             WHERE ITEM.it-codigo = p-it-codigo NO-LOCK NO-ERROR.
        IF AVAIL ITEM THEN
          ASSIGN p-ct-codigo = ITEM.ct-codigo
                 p-sc-codigo = ITEM.sc-codigo.
    END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeBringCurrent DBOProgram
procedure beforeBringCurrent:

    DO ON ERROR UNDO, THROW:
        GET CURRENT {&QueryName} NO-LOCK.
    END.
    RETURN "OK":U.

    CATCH eAnyError AS Progress.Lang.ERROR:
        DEF VAR iErr AS INT NO-UNDO.
        DO iErr = 1 TO eAnyError:numMessages:
            /* Listando no clientlog apenas para registro */
            LOG-MANAGER:WRITE-MESSAGE ("BOIN857: " + eAnyError:GetMessage(iErr)).
        END.
        /* Warning tratado - reposicionando o registro */
        RUN goToKeyRowObject.
        RETURN RETURN-VALUE.
    END CATCH.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyRowObject DBOProgram
PROCEDURE goToKeyRowObject:

    IF AVAIL RowObject THEN
        RUN goToKey (RowObject.ch-acesso-comp-nfe, RowObject.idi-orig-trad, RowObject.seq-item).
    ELSE
        RETURN "NOK":U.

    RETURN RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTcfop DBOProgram
PROCEDURE carregaTTcfop :

    DEF INPUT  PARAM p-ch-acesso LIKE item-doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-cfop.

    EMPTY TEMP-TABLE tt-cfop.
    /* Carrega as CFOPs da nota em uma temp-table. */
    FOR EACH item-doc-orig-nfe FIELDS(cod-cfop nat-operacao) NO-LOCK
       WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = p-ch-acesso
         AND item-doc-orig-nfe.idi-orig-trad      = 2
        BREAK BY item-doc-orig-nfe.cod-cfop:
        IF FIRST-OF(item-doc-orig-nfe.cod-cfop) THEN DO:
            CREATE tt-cfop.
            ASSIGN tt-cfop.cod-cfop = item-doc-orig-nfe.cod-cfop
                   tt-cfop.nat-oper = item-doc-orig-nfe.nat-operacao.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidaNatOperac DBOProgram
PROCEDURE ValidaNatOperac :

    DEF INPUT PARAM pc-cfop         AS CHAR NO-UNDO.
    DEF INPUT PARAM pc-nat-operacao AS CHAR NO-UNDO.

    IF NOT CAN-FIND(FIRST natur-oper
                    WHERE natur-oper.nat-operacao = pc-nat-operacao) THEN DO:
        DEFINE VARIABLE c-liter-nat-operac AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Natureza_de_Opera‡Æo" *}
        ASSIGN c-liter-nat-operac = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="7381"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-liter-nat-operac"}

        RETURN "NOK":U.
    END.



    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE contaUtilizaCC DBOProgram
PROCEDURE contaUtilizaCC :
/*------------------------------------------------------------------------------
  Purpose: Retorna se a conta utiliza ou não centro de custo
  Parameters:

  Notes:   RowErrors com os erros do EMS5 caso houver inconsistencia
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-ch-acesso LIKE item-doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEF INPUT  PARAM p-ct-codigo LIKE item-doc-orig-nfe.ct-codigo NO-UNDO.
    DEF OUTPUT PARAM p-l-utiliz  AS LOG INIT NO NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR RowErrors.

    EMPTY TEMP-TABLE tt_log_erro.

    FIND FIRST param-global NO-LOCK NO-ERROR.
    ASSIGN i-empresa = param-global.empresa-prin.
    FIND FIRST doc-orig-nfe WHERE doc-orig-nfe.ch-acesso-comp-nfe = p-ch-acesso
                              AND doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK NO-ERROR.

    IF AVAIL doc-orig-nfe AND doc-orig-nfe.cod-estabel <> "" THEN DO:
        IF NOT VALID-HANDLE(h_api_ccusto)
         OR h_api_ccusto:type      <> "PROCEDURE":U
         OR h_api_ccusto:file-name <> "prgint/utb/utb742za.py":U then
            run prgint/utb/utb742za.py persistent set h_api_ccusto.

        FIND FIRST estabelec WHERE estabelec.cod-estabel = doc-orig-nfe.cod-estabel NO-LOCK NO-ERROR.
        ASSIGN i-empresa = estabelec.ep-codigo WHEN AVAIL estabelec.

        RUN pi_verifica_utilizacao_ccusto IN h_api_ccusto (INPUT  i-empresa,                     /* EMPRESA EMS 2 */
                                                           INPUT  doc-orig-nfe.cod-estabel,      /* ESTABELECIMENTO EMS2 */
                                                           INPUT  "",                            /* PLANO CONTAS */
                                                           INPUT  p-ct-codigo,                   /* CONTA */
                                                           INPUT  doc-orig-nfe.dt-transacao,     /* DT TRANSACAO */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setOrigemSave DBOProgram
PROCEDURE setOrigemSave :
/*------------------------------------------------------------------------------
  Purpose: Seta se a origem do save é APIREST por exemplo para salvar os lotes
  Parameters:
  Por padrao fica o c-origem-save como RE0118A
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-origem-save AS CHAR NO-UNDO.

    ASSIGN c-origem-save = p-origem-save.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRatLoteMedicNfe DBOProgram
PROCEDURE validateRatLoteMedicNfe :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-boin00892          AS HANDLE    NO-UNDO.
    DEFINE VARIABLE soma-qtd-rat-estoq   AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE lb-rat-estoq         AS CHAR      NO-UNDO.

    {utp/ut-liter.i Estoq_seq *}
    ASSIGN lb-rat-estoq = RETURN-VALUE.

    RUN inbo/boin00892.p PERSISTENT SET h-boin00892.
    RUN openQueryStatic IN h-boin00892 (INPUT 'Main':U).

    EMPTY TEMP-TABLE tt-rat-lote-medic-nfe-valid NO-ERROR.

    FOR EACH tt-rat-lote-medic-nfe:
        ASSIGN soma-qtd-rat-estoq = soma-qtd-rat-estoq + tt-rat-lote-medic-nfe.qtd-lote-fabrican.

        EMPTY TEMP-TABLE tt-rat-lote-medic-nfe-param NO-ERROR.
        CREATE tt-rat-lote-medic-nfe-param.
        BUFFER-COPY tt-rat-lote-medic-nfe TO tt-rat-lote-medic-nfe-param.

        IF CAN-FIND(FIRST tt-rat-lote-medic-nfe-valid
                    WHERE tt-rat-lote-medic-nfe-valid.cod-depos          = tt-rat-lote-medic-nfe-param.cod-depos
                      AND tt-rat-lote-medic-nfe-valid.cod-localiz        = tt-rat-lote-medic-nfe-param.cod-localiz
                      AND tt-rat-lote-medic-nfe-valid.cod-lote-fabrican  = tt-rat-lote-medic-nfe-param.cod-lote-fabrican
                      AND tt-rat-lote-medic-nfe-valid.cod-lote-fabrican <> "") THEN DO: /* Lote repetido nos registros de rateio */

            {method/svc/errors/inserr.i &ErrorNumber="57080" /* A chave Deposito: &1 Localiz: &2 e Lote: &3 esta duplicada! */
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="tt-rat-lote-medic-nfe-param.cod-depos + '~~~~' + tt-rat-lote-medic-nfe-param.cod-localiz + '~~~~' + tt-rat-lote-medic-nfe-param.cod-lote-fabrican"}
        END.

        RUN emptyRowObject  IN h-boin00892.
        RUN emptyRowErrors  IN h-boin00892.
        RUN setRecord IN h-boin00892 (INPUT TABLE tt-rat-lote-medic-nfe-param).
        RUN validaCriacao IN h-boin00892.
        RUN getRowErrors IN h-boin00892 (OUTPUT TABLE RowErrorsSonRecord).

        FOR EACH RowErrorsSonRecord:
            CREATE RowErrors.
            BUFFER-COPY RowErrorsSonRecord TO RowErrors.
            /* Para saber que eh referente ao registro de rateio de estoque e a sequencia */
            ASSIGN RowErrors.ErrorDescription = lb-rat-estoq + " " + STRING(tt-rat-lote-medic-nfe-param.num-seq-rat) + " - " + RowErrors.ErrorDescription.
        END.

        CREATE tt-rat-lote-medic-nfe-valid. /* contem as rat-lote-medic ja validadas */
        BUFFER-COPY tt-rat-lote-medic-nfe TO tt-rat-lote-medic-nfe-valid.
    END.

    IF CAN-FIND(FIRST tt-rat-lote-medic-nfe) THEN
        IF RowObject.qtd-interna <> soma-qtd-rat-estoq THEN DO: /* somatorio nao bate com a quantidade interna do docto */
            {method/svc/errors/inserr.i &ErrorNumber="57082"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
        END.

    RETURN "OK":U.

    FINALLY:
        DELETE PROCEDURE h-boin00892 NO-ERROR.
        ASSIGN h-boin00892 = ?.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRatLoteMedicNfe DBOProgram
PROCEDURE updateRatLoteMedicNfe PRIVATE:
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-boin00892     AS HANDLE NO-UNDO.

    IF NOT AVAIL RowObject THEN RETURN "NOK":U.

    RUN inbo/boin00892.p PERSISTENT SET h-boin00892.
    RUN openQueryStatic IN h-boin00892 (INPUT 'Main':U).

    FOR EACH rat-lote-medic-nfe EXCLUSIVE-LOCK
       WHERE rat-lote-medic-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
         AND rat-lote-medic-nfe.seq-item           = RowObject.seq-item
         AND rat-lote-medic-nfe.idi-orig-trad      = 2:

        /* Se for diferente de fatura de consignacao pode eliminar, caso contrario nao pois essa tabela eh usada nos lotes das notas relacionadas */
        IF RowObject.int-2 <> 7 THEN /* Fatura consignacao */
            DELETE rat-lote-medic-nfe.
    END.

    FOR EACH tt-rat-lote-medic-nfe:
        EMPTY TEMP-TABLE tt-rat-lote-medic-nfe-param NO-ERROR.
        CREATE tt-rat-lote-medic-nfe-param.
        BUFFER-COPY tt-rat-lote-medic-nfe TO tt-rat-lote-medic-nfe-param.

        RUN emptyRowObject IN h-boin00892.
        RUN setRecord IN h-boin00892 (INPUT TABLE tt-rat-lote-medic-nfe-param).
        RUN createRecord IN h-boin00892. /* nao tem nada no validate record da BO, por isso nao eh buscada a RowErrors */
    END.

    RETURN "OK":U.

    FINALLY:
        DELETE PROCEDURE h-boin00892 NO-ERROR.
        ASSIGN h-boin00892 = ?.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE habilitaFIFO DBOProgram
PROCEDURE habilitaFIFO :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM  pc-tipo-operacao AS CHARACTER               NO-UNDO.
    DEFINE OUTPUT PARAM pl-habilita      AS LOGICAL  INITIAL YES    NO-UNDO.

    IF pc-tipo-operacao = "2"  OR
       pc-tipo-operacao = "3"  OR
       pc-tipo-operacao = "7"  OR
       pc-tipo-operacao = "8"  OR
       pc-tipo-operacao = "9"  OR
       pc-tipo-operacao = "12" OR
       pc-tipo-operacao = "19" OR
       pc-tipo-operacao = "21" THEN
        ASSIGN pl-habilita = NO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTTFIFO DBOProgram
PROCEDURE setTTFIFO: /* tt-manut-docto da REAPI401 */
    DEFINE INPUT PARAM TABLE FOR tt-manut-docto.

    IF RowObject.int-2 = 23 THEN DO: /* Nota cr‚dito/d‚bito */
       EMPTY TEMP-TABLE tt-manut-docto.
    END.
    RETURN "OK":U.
END PROCEDURE .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFIFO DBOProgram
PROCEDURE validateFIFO PRIVATE:
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-reapi401           AS HANDLE    NO-UNDO.

    IF NOT CAN-FIND(FIRST tt-manut-docto) THEN
        RETURN "OK":U.

    IF NOT AVAIL RowObject THEN
        RETURN "NOK":U.

    RUN rep/reapi401.p PERSISTENT SET h-reapi401.

    RUN piValidaManutDocto IN h-reapi401 (INPUT TABLE tt-manut-docto,
                                          INPUT RowObject.ch-acesso-comp-nfe,
                                          INPUT RowObject.seq-item,
                                          INPUT RowObject.preco-unit,
                                          INPUT RowObject.qtd-comercial,
                                          OUTPUT TABLE RowErrors APPEND).

    RETURN "OK":U.

    FINALLY:
        DELETE PROCEDURE h-reapi401 NO-ERROR.
        ASSIGN h-reapi401 = ?.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateFIFO DBOProgram
PROCEDURE updateFIFO PRIVATE:
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-reapi401           AS HANDLE    NO-UNDO.
    DEFINE VARIABLE h-this-bo            AS HANDLE    NO-UNDO.

    IF NOT AVAIL RowObject THEN
        RETURN "NOK":U.

    RUN rep/reapi401.p PERSISTENT SET h-reapi401.
    ASSIGN h-this-bo = THIS-PROCEDURE:HANDLE.

    EMPTY TEMP-TABLE tt-rat-ordem-orig-nfe.

    FOR EACH tt-manut-docto WHERE tt-manut-docto.mark = "*":U:
        CREATE tt-rat-ordem-orig-nfe.
        ASSIGN tt-rat-ordem-orig-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
               tt-rat-ordem-orig-nfe.seq-item           = RowObject.seq-item
               tt-rat-ordem-orig-nfe.num-seq-rat        = tt-manut-docto.i-linha
               tt-rat-ordem-orig-nfe.encerrada          = tt-manut-docto.encerrada
               tt-rat-ordem-orig-nfe.nr-contrato        = tt-manut-docto.nr-contrato
               tt-rat-ordem-orig-nfe.num-pedido         = tt-manut-docto.num-pedido
               tt-rat-ordem-orig-nfe.numero-ordem       = tt-manut-docto.ordem-compra
               tt-rat-ordem-orig-nfe.parcela            = tt-manut-docto.num-parcela
               tt-rat-ordem-orig-nfe.num-seq-event      = tt-manut-docto.num-seq-eve
               tt-rat-ordem-orig-nfe.num-seq-item       = tt-manut-docto.num-seq-item
               tt-rat-ordem-orig-nfe.num-seq-medicao    = tt-manut-docto.num-seq-med
               tt-rat-ordem-orig-nfe.ct-codigo          = tt-manut-docto.ct-codigo
               tt-rat-ordem-orig-nfe.sc-codigo          = tt-manut-docto.sc-codigo
               tt-rat-ordem-orig-nfe.val-quant-emit     = tt-manut-docto.qtd-sald-forn
               tt-rat-ordem-orig-nfe.cdn-fabrican       = tt-manut-docto.cdn-fabrican
               tt-rat-ordem-orig-nfe.cod-barras         = tt-manut-docto.cod-barras
               tt-rat-ordem-orig-nfe.val-medicao        = tt-manut-docto.val-medicao.

        RUN converteQtdInterna (OUTPUT tt-rat-ordem-orig-nfe.qtd-interna).
    END.

    /* Limpa a selecao anterior antes de criar a nova. */
    RUN piLimpaRatOrdemOrigNfe IN h-reapi401(INPUT RowObject.ch-acesso-comp-nfe,
                                             INPUT RowObject.seq-item,
                                             INPUT-OUTPUT h-this-bo).

    RUN piGeraRatOrdemOrigNFe IN h-reapi401(INPUT TABLE tt-rat-ordem-orig-nfe,
                                            INPUT-OUTPUT h-this-bo).

    RETURN "OK":U.

    FINALLY:
        DELETE PROCEDURE h-reapi401 NO-ERROR.
        ASSIGN h-reapi401 = ?.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE converteQtdInterna DBOProgram
PROCEDURE converteQtdInterna PRIVATE:
    DEF OUTPUT PARAM qtdInterna LIKE rat-ordem-orig-nfe.qtd-interna NO-UNDO.

    DEF VAR de-indice AS DECIMAL NO-UNDO.
    DEFINE VARIABLE h-reapi418           AS HANDLE     NO-UNDO.

    /* Considera o emitente do pedido de compra conforme o RE1001B4. */
    IF  NOT AVAIL pedido-compr
    OR  pedido-compr.num-pedido <> tt-manut-docto.num-pedido THEN
        FOR FIRST pedido-compr NO-LOCK
            WHERE pedido-compr.num-pedido = tt-manut-docto.num-pedido:
        END.

    FOR FIRST bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
          AND bf{&TableName}.idi-orig-trad      = 1  /* Registro Traduzido */
          AND bf{&TableName}.seq-item           = RowObject.seq-item:
    END.

    RUN rep/reapi418.p PERSISTENT SET h-reapi418.
    RUN pi-inicializa-tt  IN  h-reapi418.
    RUN setCodEstabel     IN  h-reapi418 (INPUT tt-manut-docto.cod-estab ).
    RUN setCodEmitente    IN  h-reapi418 (INPUT pedido-compr.cod-emitente).
    RUN setItCodigo       IN  h-reapi418 (INPUT RowObject.it-codigo).
    RUN setItCodigoDoForn IN  h-reapi418 (INPUT bf{&TableName}.it-codigo).
    RUN pDeparaItem       IN  h-reapi418.
    RUN getTtDeParaItem   IN  h-reapi418 (OUTPUT TABLE tt-de-para-item).

    IF VALID-HANDLE(h-reapi418) THEN DO:
        DELETE PROCEDURE  h-reapi418.
        ASSIGN h-reapi418 = ?.
    END.

    FOR FIRST tt-de-para-item
        WHERE tt-de-para-item.it-codigo    = RowObject.it-codigo /*prazo-compra.it-codigo */
          AND tt-de-para-item.cod-emitente = pedido-compr.cod-emitente /*input frame fPage0 fi-cod-emitente*/ /*ordem-compra.cod-emitente */
        NO-LOCK: END.

    ASSIGN de-indice = IF  AVAILABLE tt-de-para-item THEN tt-de-para-item.indice ELSE 1.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = tt-de-para-item.it-codigo NO-ERROR.
    IF AVAIL ITEM THEN DO:
        IF ITEM.fraciona THEN
            ASSIGN qtdInterna = tt-manut-docto.qtd-sald-forn / de-indice.
        ELSE
            ASSIGN qtdInterna = TRUNCATE((tt-manut-docto.qtd-sald-forn / de-indice),0).
    END.
    ELSE
        ASSIGN qtdInterna = tt-manut-docto.qtd-sald-forn.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaVariacaoValorOrdem DBOProgram
PROCEDURE validaVariacaoValorOrdem:

    DEFINE INPUT  PARAM p-cod-estabel   LIKE doc-orig-nfe.cod-estabel   NO-UNDO.
    DEFINE INPUT  PARAM p-dt-emissao    LIKE doc-orig-nfe.dt-emissao    NO-UNDO.
    DEFINE INPUT  PARAM p-numero-ordem  LIKE ordem-compra.numero-ordem  NO-UNDO.
    DEFINE OUTPUT PARAM l-erro AS LOG INIT NO NO-UNDO.

    DEFINE VARIABLE i-numero-ordem-ant  LIKE ordem-compra.numero-ordem  NO-UNDO.

    IF AVAIL RowObject THEN
        ASSIGN i-numero-ordem-ant       = RowObject.numero-ordem
               RowObject.numero-ordem   = p-numero-ordem.

    RUN validaVariacaoValor(INPUT p-cod-estabel,
                            INPUT p-dt-emissao,
                            OUTPUT l-erro).

    IF AVAIL RowObject THEN
        ASSIGN RowObject.numero-ordem   = i-numero-ordem-ant.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateCalculoSistema DBOProgram
PROCEDURE updateCalculoSistema:
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM h-boin045   AS HANDLE NO-UNDO.

    DEFINE VARIABLE    h-reapi419  AS HANDLE NO-UNDO.

    IF NOT AVAIL RowObject OR
       NOT VALID-HANDLE(h-boin045) THEN
        RETURN "NOK":U.

    RUN emptyRowErrors IN h-boin045.
    RUN emptyTempTableProcess IN h-boin045.

    RUN setChaveAcesso IN h-boin045 (INPUT RowObject.ch-acesso-comp-nfe).
    RUN setSeqItem     IN h-boin045 (INPUT RowObject.seq-item).

    RUN eliminarDadosSistema IN h-boin045.

    RUN utilizaImpostosMonitorTipoOperacao (INPUT RowObject.int-2,
                                            OUTPUT l-tipoOperPermitidoImpMonitor).

    IF lFuncaoImpostosAtivada = NO OR l-tipoOperPermitidoImpMonitor = NO THEN DO:
        // NÆo precisa calcular os dados sistema se fun‡Æo nÆo est  ativa ou opera‡Æo nÆo ‚ uma das permitidas
        RUN eliminarDadosTraduzidos IN h-boin045.
        RETURN "OK":U.
    END.

    RUN rep/reapi419.p PERSISTENT SET h-reapi419.

    FOR FIRST doc-orig-nfe NO-LOCK
        WHERE doc-orig-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
          AND doc-orig-nfe.idi-orig-trad      = 2:

        RUN criaTTsAPartirMonitorNFe IN h-reapi419 (INPUT BUFFER doc-orig-nfe:HANDLE,
                                                    INPUT TEMP-TABLE RowObject:DEFAULT-BUFFER-HANDLE).

        RUN setBuscaDescIcms      IN h-reapi419 (INPUT YES). // sempre calcular desonerado
        RUN setRecalcSn           IN h-reapi419 (INPUT YES).
        RUN setSepararOrigemDoCST IN h-reapi419 (INPUT YES).

        RUN piExecutaCalculo IN h-reapi419.

        EMPTY TEMP-TABLE tt-tribut-item-doc.
        RUN getTtImpostoItem IN h-reapi419 (OUTPUT TABLE tt-tribut-item-doc).
        RUN getTtCtTribItemDoc IN h-reapi419 (OUTPUT TABLE tt-ct-trib-item-doc).
        RUN piFinaliza IN h-reapi419.

        FOR EACH tt-tribut-item-doc:
            RUN addRegistroSistemaTT IN h-boin045 (tt-tribut-item-doc.nom-trib, tt-tribut-item-doc.cod-campo, TRIM(tt-tribut-item-doc.cod-conteudo)).
        END.
        RUN efetivarTTProcess IN h-boin045.
        RUN getRowErrors IN h-boin045 (OUTPUT TABLE RowErrors APPEND).
        RUN salvarHistoricoConfigTrib (INPUT RowObject.ch-acesso-comp-nfe,
                                       INPUT RowObject.seq-item,
                                       INPUT TABLE tt-ct-trib-item-doc).
    END.

    RETURN "OK":U.

    FINALLY:
        DELETE PROCEDURE h-reapi419 NO-ERROR.
        ASSIGN h-reapi419 = ?.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateDadosConsiderados DBOProgram
PROCEDURE updateDadosConsiderados:
/*------------------------------------------------------------------------------
  Purpose: Atualiza os dados considerados com base nos dados sistema
           Caso tenha engine de regras parametrizado busca os dados originais do XML
  Parameters:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM h-boin045   AS HANDLE NO-UNDO.

    DEFINE VARIABLE h-reapi334  AS HANDLE NO-UNDO.

    IF NOT AVAIL RowObject OR
       NOT VALID-HANDLE(h-boin045) THEN
        RETURN "NOK":U.

    EMPTY TEMP-TABLE ImpostosXmlNfe.

    RUN emptyRowErrors IN h-boin045.
    RUN emptyTempTableProcess IN h-boin045.

    RUN setChaveAcesso IN h-boin045 (INPUT RowObject.ch-acesso-comp-nfe).
    RUN setSeqItem     IN h-boin045 (INPUT RowObject.seq-item).
    RUN eliminarDadosTraduzidos IN h-boin045.

    RUN utilizaImpostosMonitorTipoOperacao (INPUT RowObject.int-2,
                                            OUTPUT l-tipoOperPermitidoImpMonitor).

    IF lFuncaoImpostosAtivada = NO OR l-tipoOperPermitidoImpMonitor = NO THEN DO:
        // Retorna caso nÆo esteja ativa a fun‡Æo ou nÆo um dos tipos de nota aceitos
        RETURN "OK":U.
    END.

    // Carrega dados originais e de sistema na tt ImpostosXMLNfe
    FOR EACH item-doc-imp-nfe NO-LOCK
       WHERE item-doc-imp-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
         AND item-doc-imp-nfe.seq-item           = RowObject.seq-item:

        IF item-doc-imp-nfe.tipo-reg <> "TRAD" THEN DO:
            CREATE ImpostosXmlNfe.
            BUFFER-COPY item-doc-imp-nfe TO ImpostosXmlNfe.
        END.
    END.

    IF NOT AVAIL doc-orig-nfe then
        FIND FIRST doc-orig-nfe WHERE doc-orig-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
                                  AND doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK NO-ERROR.

    IF atributoImpostoUtil = ? THEN
        ASSIGN atributoImpostoUtil = NEW AtributoImpostoUtil(c-seg-usuario).
    // Faz a c¢pia do c lculo do sistema para dados considerados / traduzidos
    FOR EACH ImpostosXmlNfe:
        ASSIGN ImpostosXmlNfe.actions-txt = atributoImpostoUtil:getActionsTxt(ImpostosXmlNfe.nom-trib,
                                                                              ImpostosXmlNfe.cod-campo,
                                                                              doc-orig-nfe.cod-estabel,
                                                                              doc-orig-nfe.cod-emitente,
                                                                              RowObject.nat-operacao,
                                                                              RowObject.it-codigo).
        ASSIGN ImpostosXmlNfe.msg-validate = atributoImpostoUtil:getLastMsgValidate().

        IF ImpostosXmlNfe.tipo-reg = "SIST":U THEN DO:
            CREATE bfImpostosXmlNfe.
            BUFFER-COPY ImpostosXmlNfe EXCEPT tipo-reg TO bfImpostosXmlNfe.
            ASSIGN bfImpostosXmlNfe.tipo-reg = "TRAD":U.
        END.

    END.


    RUN rep/reapi334.p PERSISTENT SET h-reapi334.

    FIND FIRST natur-oper WHERE natur-oper.nat-operacao = RowObject.nat-operacao NO-LOCK NO-ERROR.
    IF AVAIL natur-oper
    AND natur-oper.tipo-compra = 9 /*Nota cr‚dito/d‚bito*/
    THEN DO:
        RUN copiarDadosOriginaisParaTraduzido IN h-reapi334 (INPUT-OUTPUT TABLE ImpostosXmlNfe).
    END.
    ELSE DO:
        // Rodar o engine para verificar o que deve ser copiado dos dados originais
        RUN engineImpostos IN h-reapi334 (INPUT TEMP-TABLE RowObject:DEFAULT-BUFFER-HANDLE,
                                          INPUT-OUTPUT TABLE ImpostosXmlNfe).
    END.


    EMPTY TEMP-TABLE tt-item-doc-imp-nfe.
    FOR EACH ImpostosXmlNfe WHERE ImpostosXmlNfe.tipo-reg = "TRAD":
        CREATE tt-item-doc-imp-nfe.
        BUFFER-COPY ImpostosXmlNfe TO tt-item-doc-imp-nfe.
    END.
    RUN emptyTempTableProcess IN h-boin045.
    RUN emptyRowErrors        IN h-boin045.
    RUN setTempTableProcess   IN h-boin045 (INPUT TABLE tt-item-doc-imp-nfe).
    RUN efetivarTTProcess     IN h-boin045.
    RUN getRowErrors          IN h-boin045 (OUTPUT TABLE RowErrors APPEND).

    RETURN "OK":U.

    FINALLY:
        DELETE PROCEDURE h-reapi334 NO-ERROR.
        ASSIGN h-reapi334 = ?.
        DELETE OBJECT atributoImpostoUtil NO-ERROR.
    END FINALLY.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE salvarDadosConsideradosTela DBOProgram
PROCEDURE salvarDadosConsideradosTela:
/*------------------------------------------------------------------------------
  Purpose: Atualiza os dados considerados com base na temp-table enviada pela tela
           NÆo roda o engine de regras nesse caso.
  Parameters:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM h-boin045   AS HANDLE NO-UNDO.

    IF NOT AVAIL RowObject OR
       NOT VALID-HANDLE(h-boin045) THEN
        RETURN "NOK":U.

    RUN setChaveAcesso          IN h-boin045 (INPUT RowObject.ch-acesso-comp-nfe).
    RUN setSeqItem              IN h-boin045 (INPUT RowObject.seq-item).
    RUN eliminarDadosTraduzidos IN h-boin045.
    RUN getRowErrors            IN h-boin045 (OUTPUT TABLE RowErrors APPEND).
    RUN emptyRowErrors          IN h-boin045.

    RUN utilizaImpostosMonitorTipoOperacao (INPUT RowObject.int-2,
                                            OUTPUT l-tipoOperPermitidoImpMonitor).

    IF lFuncaoImpostosAtivada AND l-tipoOperPermitidoImpMonitor THEN DO:
        // Salvando dados considerados/traduzidos que vieram da tela
        RUN emptyTempTableProcess   IN h-boin045.
        RUN setTempTableProcess     IN h-boin045 (INPUT TABLE tt-item-doc-imp-nfe).
        RUN efetivarTTProcess       IN h-boin045.
        RUN getRowErrors            IN h-boin045 (OUTPUT TABLE RowErrors APPEND).
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTTImpostos DBOProgram
PROCEDURE setTTImpostos:
    DEFINE INPUT PARAM TABLE FOR tt-item-doc-imp-nfe.

    RETURN "OK":U.
END PROCEDURE .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-contrato DBOProgram
PROCEDURE pi-valida-contrato:
    DEFINE VARIABLE l-conta-matriz      AS LOGICAL      NO-UNDO.
    IF CAN-FIND (FIRST contrato-for
                 WHERE contrato-for.nr-contrato = ordem-compra.nr-contrato
                 AND contrato-for.ind-control-rec = 1) OR
        CAN-FIND (FIRST item-contrat
                  WHERE item-contrat.num-seq-item     = ordem-compra.num-seq-item
                    AND item-contrat.nr-contrato      = ordem-compra.nr-contrato
                    AND item-contrat.ind-tipo-control = 1) THEN DO:
        /*NÆo ‚ permitido informar ordem com contrato por medi‡Æo.
              Ordem informada possui controle de contrato por medi‡Æo , dever  ser recebida via FIFO.*/
            {method/svc/errors/inserr.i &ErrorNumber="57711"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
    END.
    ELSE DO:
        RUN cnp/cn9072.p (INPUT ordem-compra.numero-ordem,
                          INPUT ?,
                          INPUT 12,                    /* Conta-Atual   */
                          OUTPUT l-conta-matriz,
                          INPUT-OUTPUT TABLE tt-erro-contrato).
        EMPTY TEMP-TABLE tt-erro-contrato.
        IF l-conta-matriz THEN DO:
            /*NÆo ‚ permitido informar ordem com contrato por medi‡Æo.
                      Ordem informada possui controle de contrato por medi‡Æo , dever  ser recebida via FIFO.*/
            {method/svc/errors/inserr.i &ErrorNumber="57711"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}

        END.
    END.
    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE salvarHistoricoConfigTrib DBOProgram
PROCEDURE salvarHistoricoConfigTrib:
    DEFINE INPUT PARAM pc-ch-acesso-comp-nfe   AS CHAR NO-UNDO.
    DEFINE INPUT PARAM pi-seq-item             AS INT  NO-UNDO.
    DEFINE INPUT PARAM TABLE FOR tt-ct-trib-item-doc.

    // Elimina hist¢rico anterior
    FOR EACH ct-trib-item-doc-nfe EXCLUSIVE-LOCK
       WHERE ct-trib-item-doc-nfe.ch-acesso-comp-nfe = pc-ch-acesso-comp-nfe
         AND ct-trib-item-doc-nfe.seq-item           = pi-seq-item:
        DELETE ct-trib-item-doc-nfe.
    END.

    // Grava novo hist¢rico
    FOR EACH tt-ct-trib-item-doc:
        CREATE ct-trib-item-doc-nfe.
        ASSIGN ct-trib-item-doc-nfe.ch-acesso-comp-nfe    = pc-ch-acesso-comp-nfe
               ct-trib-item-doc-nfe.seq-item              = pi-seq-item
               ct-trib-item-doc-nfe.seq-ct-trib           = tt-ct-trib-item-doc.num-ct-trib.
        BUFFER-COPY tt-ct-trib-item-doc TO ct-trib-item-doc-nfe.
        ASSIGN ct-trib-item-doc-nfe.dat-ult-atualiz       = TODAY
               ct-trib-item-doc-nfe.hra-ult-atualiz       = STRING(TIME, "HH:MM:SS":U)
               ct-trib-item-doc-nfe.cod-usuar-ult-atualiz = c-seg-usuario
               ct-trib-item-doc-nfe.val-base-calc         = tt-ct-trib-item-doc.val-base
               ct-trib-item-doc-nfe.cod-formul-calc-trib  = tt-ct-trib-item-doc.cod-formul-trib.
    END.
    RELEASE ct-trib-item-doc-nfe.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
