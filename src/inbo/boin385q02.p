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
{include/i-prgvrs.i BOIN385Q02 2.00.00.023 } /*** "010023" 24/11/2023 13:25:23  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin385q02 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ² um programa PROGRESS
                 que cont²m a l1/2gica de neg1/2cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini»'o ---*/
&GLOBAL-DEFINE DBOName tt-requisicao
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&scoped-define FIRST-TABLE-IN-QUERY tt-requisicao
&GLOBAL-DEFINE TableName tt-requisicao
&GLOBAL-DEFINE TableLabel tt-requisicao
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (boin385.p) est  com as fun‡äes de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque Sà nela foram implementadas as triggers do dicion rio.
**  Para desabilitar as procedures foram usados os pr‚-processadores abaixo.
**  A procedure validateRecord dessa DBO nÆo deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0
&GLOBAL-DEFINE EXCLUDE-getRowid

/* Testa a versÆo do Progress */
&IF INT (SUBSTRING (PROVERSION, 1, INDEX (PROVERSION, ".") - 1)) >= 9 &THEN
    &GLOBAL-DEFINE v9Ind-Rep INDEXED-REPOSITION
&ELSE
    &GLOBAL-DEFINE v9Ind-Rep
&ENDIF

/*--- Include com defini»'o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret1/2rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id1/4ntico ao nome do DBO mas com
      extens'o .i ---*/
{include/boini.i}
{inbo/boin385q02.i tt-requisicao}
{inbo/boin385q02.i RowObject}
{cdp/cdcfgren.i}


/*--- Include com defini»'o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»'o da defini»'o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»'o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER b-requisicao   FOR requisicao.
/*---------- CarregaTabelaTemp1, 2 e 3 -------------*/
def var  c-nome-abrev   as char    no-undo.
def var  l-aberto       as logical no-undo.
def var  l-aprovado     as logical no-undo.
def var  l-nao-aprovado as logical no-undo.
def var  l-fechado      as logical no-undo.
def var  l-pendente     as logical no-undo.
def var  l-ordem        as logical no-undo.

def var  de-total       as dec     no-undo.
def var linha-aux as int no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram



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
         HEIGHT             = 2.01
         WIDTH              = 44.29.
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



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTtOfRequisitantePorNrRequisicao DBOProgram 
PROCEDURE carregaTtOfRequisitantePorNrRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     carregaTabelaTemp3
    Gera temp-table tt-requisi‡Æo para a consulta das requisi‡äes do comprador do m¢dulo de compras, 
    com base na cota‡Æo dos itens da requisi‡Æo e no pedido de compra.
  Parameters:
    ipar1  : p-nome-abrev    : Nome Abrev
    ipar2  : p-aprovado      : Situa‡Æo Aprovado
    ipar3  : p-nao-aprovado  : Situa‡Æo NÆo Aprovado
    ipar4  : p-aberto        : Situa‡Æo Aberto
    ipar5  : p-fechado       : Situa‡Æo Fechado
    ipar6  : p-pendente      : Situa‡Æo pendente
    ipar7  : p-ordem         : Ordem
    ipar8  : p-requisitante  : Requisitante
    ipar9  : p-da-solic-ini  : Data Solicita‡Æo inicial
    ipar10 : p-da-solic-fim  : Data Solicita‡Æo final
    ipar11 : p-apresentacao  : Apresenta‡Æo
  Notes:     
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-nome-abrev       AS CHAR.
    DEF INPUT PARAM p-aprovado         AS LOG.
    DEF INPUT PARAM p-nao-aprovado     AS LOG.
    DEF INPUT PARAM p-aberto           AS LOG.
    DEF INPUT PARAM p-fechado          AS LOG.
    DEF INPUT PARAM p-pendente         AS LOG.
    DEF INPUT PARAM p-ordem            AS LOG.
    DEF INPUT PARAMETER p-requisitante AS ROWID NO-UNDO.
    DEF INPUT PARAMETER p-da-solic-ini AS DATE  NO-UNDO FORMAT "99/99/9999".
    DEF INPUT PARAMETER p-da-solic-fim AS DATE  NO-UNDO FORMAT "99/99/9999".
    DEF INPUT PARAMETER p-apresentacao AS INT   NO-UNDO.

    DEF VAR l-ok          AS LOGICAL NO-UNDO.

    ASSIGN c-nome-abrev   = p-nome-abrev
           l-aberto       = p-aberto
           l-aprovado     = p-aprovado
           l-nao-aprovado = p-nao-aprovado
           l-fechado      = p-fechado
           l-pendente     = p-pendente
           l-ordem        = p-ordem.

    /* O pr‚-processador abaixa testa a versÆo do PROGRESS */
    &IF INT (SUBSTRING (PROVERSION, 1, INDEX (PROVERSION, ".") - 1)) >= 9 &THEN          
        EMPTY TEMP-TABLE tt-requisicao.
    &ELSE
        FOR EACH tt-requisicao:
            DELETE tt-requisicao.
        END.
    &ENDIF
    
    FOR EACH  requisicao FIELDS(nr-requisicao situacao
                                estado dt-requisicao)
        WHERE requisicao.nome-abrev = TRIM(c-nome-abrev) 
          AND requisicao.tp-requis = 2 
          AND requisicao.dt-requisicao >= p-da-solic-ini 
          AND requisicao.dt-requisicao <= p-da-solic-fim 
          AND (   (requisicao.situacao = 1 AND l-aberto) 
               OR (requisicao.situacao = 2 AND l-fechado) 
               OR (requisicao.situacao = 3 AND l-pendente) 
               OR (requisicao.situacao = 4 AND l-ordem) ) 
          AND (   (requisicao.estado   = 1 AND l-aprovado) 
               OR (requisicao.estado   = 2 AND l-nao-aprovado)) NO-LOCK:
        
        ASSIGN l-ok = NO.         
 
        FOR EACH  it-requisicao FIELDS(numero-ordem)
            WHERE it-requisicao.nr-requisicao = requisicao.nr-requisicao NO-LOCK:
            IF  p-apresentacao = 1 THEN DO:
                ASSIGN l-ok = YES.
                LEAVE.
            END.
            IF  it-requisicao.numero-ordem > 0 THEN DO:
                FOR FIRST ordem-compra FIELDS(numero-ordem num-pedido)
                    WHERE ordem-compra.numero-ordem = it-requisicao.numero-ordem NO-LOCK: END.
                IF  AVAILABLE ordem-compra THEN DO:
                    IF  p-apresentacao = 2 THEN DO:
                        ASSIGN l-ok = YES.
                        LEAVE.
                    END.
                    FOR  FIRST cotacao-item FIELDS()
                         WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                           AND cotacao-item.cot-aprovada = YES NO-LOCK: END.
                    IF  AVAILABLE cotacao-item THEN DO:
                        IF  p-apresentacao = 3 THEN DO:
                            ASSIGN l-ok = YES.
                            LEAVE.
                        END.
                        FOR FIRST pedido-compr FIELDS(num-pedido)
                            WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK: END.
                        IF  AVAILABLE pedido-compr THEN DO:
                            IF  p-apresentacao = 4 THEN DO:
                                ASSIGN l-ok = YES.
                                LEAVE.
                            END.
                            ASSIGN de-total = 0.
                            FOR EACH  recebimento FIELDS(qtd-rec)
                                WHERE recebimento.num-pedido   = pedido-compr.num-pedido 
                                  AND recebimento.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
                                ASSIGN de-total = de-total + recebimento.qtd-rec.
                            END.
                            IF  de-total > 0 
                            AND p-apresentacao = 5 THEN DO:
                                ASSIGN l-ok = YES.
                                LEAVE.
                            END.
                        END.                                   
                    END.
                END.
            END.                   
        END.            
 
        IF  l-ok = YES THEN DO:
            CREATE tt-requisicao.
            ASSIGN tt-requisicao.nr-requisicao = requisicao.nr-requisicao       
                   tt-requisicao.situacao      = requisicao.situacao
                   tt-requisicao.estado        = requisicao.estado
                   tt-requisicao.dt-requisicao = requisicao.dt-requisicao
                   tt-requisicao.r-rowid       = ROWID(requisicao).

        END.
    END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTtOfRequisitantePorNrRequisicao1 DBOProgram 
PROCEDURE carregaTtOfRequisitantePorNrRequisicao1 :
/*------------------------------------------------------------------------------
  Purpose:     carregaTabelaTemp3
    Gera temp-table tt-requisi‡Æo para a consulta das requisi‡äes do comprador do m¢dulo de compras, 
    com base na cota‡Æo dos itens da requisi‡Æo e no pedido de compra.
  Parameters:
    ipar1  : p-nome-abrev      : Nome Abrev do requisitante
    ipar2  : p-aprovado        : Mosta solicita‡äes com Situa‡Æo Aprovado
    ipar3  : p-nao-aprovado    : Mosta solicita‡äes com Situa‡Æo NÆo Aprovado
    ipar4  : p-aberto          : Mosta solicita‡äes com Situa‡Æo Aberto
    ipar5  : p-fechado         : Mosta solicita‡äes com Situa‡Æo Fechado
    ipar6  : p-pendente        : Mosta solicita‡äes com Situa‡Æo pendente
    ipar7  : p-ordem           : Mosta solicita‡äes com Ordem de Compra
    ipar8  : p-da-solic-ini    : Data Solicita‡Æo inicial
    ipar9  : p-da-solic-fim    : Data Solicita‡Æo final
    ipar10 : p-apresentacao    : N¡vel da Apresenta‡Æo das informa‡äes
    ipar11 : p-navigation      : Recebe o tipo da navega‡Æo do browse ("Next" ou "Prev")
    ipar12 : p-max-return      : Cont‚m o nr m ximo de registros que devem ser retornados
    ipar13 : l-change-father   : Indica se mudou o registro da tabela Pai
    ipar14 : p-last-displayed  : Recebe/Retorna o rowid do £ltimo registro do browse
    ipar15 : p-first-displayed : Recebe/Retorna o rowid do primeiro registro do browse
    ipar16 : p-first-base      : Recebe/Retorna o rowid do primeiro registro da base
    ipar17 : p-last-base       : Recebe/Retorna o rowid do £ltimo registro da base
  Notes:     
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-nome-abrev        AS CHAR.
    DEF INPUT PARAM p-aprovado          AS LOG.
    DEF INPUT PARAM p-nao-aprovado      AS LOG.
    DEF INPUT PARAM p-aberto            AS LOG.
    DEF INPUT PARAM p-fechado           AS LOG.
    DEF INPUT PARAM p-pendente          AS LOG.
    DEF INPUT PARAM p-ordem             AS LOG.
    DEF INPUT PARAMETER p-da-solic-ini  AS DATE  NO-UNDO FORMAT "99/99/9999".
    DEF INPUT PARAMETER p-da-solic-fim  AS DATE  NO-UNDO FORMAT "99/99/9999".
    DEF INPUT PARAMETER p-apresentacao  AS INT   NO-UNDO.
    DEF INPUT PARAMETER p-navigation    AS CHAR  NO-UNDO.
    DEF INPUT PARAMETER p-max-return    AS INT   NO-UNDO.
    DEF INPUT PARAMETER l-change-father AS LOG   NO-UNDO.
    DEF INPUT-OUTPUT PARAM p-last-displayed  AS ROWID NO-UNDO.
    DEF INPUT-OUTPUT PARAM p-first-displayed AS ROWID NO-UNDO.
    DEF INPUT-OUTPUT PARAM p-first-base      AS ROWID NO-UNDO.
    DEF INPUT-OUTPUT PARAM p-last-base       AS ROWID NO-UNDO.
    DEF INPUT-OUTPUT PARAM p-first-mantem-dados AS ROWID NO-UNDO.

    DEF VAR i-count-records AS INT NO-UNDO.
    DEF VAR l-ok            AS LOG NO-UNDO.

    ASSIGN c-nome-abrev   = p-nome-abrev
           l-aberto       = p-aberto
           l-aprovado     = p-aprovado
           l-nao-aprovado = p-nao-aprovado
           l-fechado      = p-fechado
           l-pendente     = p-pendente
           l-ordem        = p-ordem.

    /* O pr‚-processador abaixa testa a versÆo do PROGRESS */
    &IF INT (SUBSTRING (PROVERSION, 1, INDEX (PROVERSION, ".") - 1)) >= 9 &THEN          
        EMPTY TEMP-TABLE tt-requisicao.
    &ELSE
        FOR EACH tt-requisicao:
            DELETE tt-requisicao.
        END.
    &ENDIF
    
    /* Caso nÆo exista nenhum registro com a parametriza‡Æo feita em tela,
       retorna sem criar nenhum registro na temp-table */
    IF  NOT CAN-FIND(FIRST requisicao
                     WHERE requisicao.nome-abrev = TRIM(c-nome-abrev) 
                       AND requisicao.tp-requis = 2 
                       AND requisicao.dt-requisicao >= p-da-solic-ini 
                       AND requisicao.dt-requisicao <= p-da-solic-fim 
                       AND (   (requisicao.situacao = 1 AND l-aberto) 
                            OR (requisicao.situacao = 2 AND l-fechado) 
                            OR (requisicao.situacao = 3 AND l-pendente) 
                            OR (requisicao.situacao = 4 AND l-ordem) ) 
                       AND (   (requisicao.estado   = 1 AND l-aprovado) 
                            OR (requisicao.estado   = 2 AND l-nao-aprovado))) 
        THEN RETURN "NOK":U.

    /* Quando o primeiro e o £ltimo registro do browse forem desconhecidos, come‡a
       a pesquisa pelo primeiro registro que se encaixar na sele‡Æo */
    IF  p-last-displayed = ? 
    AND p-first-displayed = ? THEN DO:
        ASSIGN p-navigation = "Next":U.
        FIND FIRST requisicao &IF DEFINED(CUSTOM_GRENDENE) &THEN 
                                  USE-INDEX nome-abrev
                              &ELSE
                                  USE-INDEX requisicao
                              &ENDIF
             WHERE requisicao.nome-abrev = TRIM(c-nome-abrev) 
               AND requisicao.tp-requis = 2 
               AND requisicao.dt-requisicao >= p-da-solic-ini 
               AND requisicao.dt-requisicao <= p-da-solic-fim 
               AND (   (requisicao.situacao = 1 AND l-aberto) 
                    OR (requisicao.situacao = 2 AND l-fechado) 
                    OR (requisicao.situacao = 3 AND l-pendente) 
                    OR (requisicao.situacao = 4 AND l-ordem) ) 
               AND (   (requisicao.estado   = 1 AND l-aprovado) 
                    OR (requisicao.estado   = 2 AND l-nao-aprovado)) NO-LOCK NO-ERROR.
    END.
    ELSE DO:
        /* SenÆo come‡a a pesquisa a partir do registro que contenha o rowid
           recebido como parƒmetro */
        IF  p-navigation = "Prev":U THEN DO:
            FIND requisicao WHERE 
                ROWID(requisicao) = p-first-displayed NO-LOCK NO-ERROR.
            /* Quando a navega‡Æo for "Prev" posiciona no registro anterior ao
               primeiro mostrado no browse */ 
            IF  AVAIL requisicao THEN
                FIND PREV  requisicao &IF DEFINED(CUSTOM_GRENDENE) &THEN 
                                          USE-INDEX nome-abrev
                                      &ELSE
                                          USE-INDEX requisicao
                                      &ENDIF
                     WHERE requisicao.nome-abrev = TRIM(c-nome-abrev) 
                       AND requisicao.tp-requis = 2 
                       AND requisicao.dt-requisicao >= p-da-solic-ini 
                       AND requisicao.dt-requisicao <= p-da-solic-fim 
                       AND (   (requisicao.situacao = 1 AND l-aberto) 
                            OR (requisicao.situacao = 2 AND l-fechado) 
                            OR (requisicao.situacao = 3 AND l-pendente) 
                            OR (requisicao.situacao = 4 AND l-ordem) ) 
                       AND (   (requisicao.estado   = 1 AND l-aprovado) 
                            OR (requisicao.estado   = 2 AND l-nao-aprovado)) NO-LOCK NO-ERROR.
        END.
        ELSE IF p-navigation = "Next":U THEN DO:
            IF  p-first-mantem-dados <> ? THEN DO:
                FIND requisicao WHERE 
                    ROWID(requisicao) = p-first-mantem-dados NO-LOCK NO-ERROR.
            END.
            ELSE DO:
                FIND requisicao WHERE 
                    ROWID(requisicao) = p-last-displayed NO-LOCK NO-ERROR.
                /* Quando a navega‡Æo for "Next" posiciona no pr¢ximo registro baseado
                   no £ltimo mostrado no browse */
                IF  AVAIL requisicao THEN
                    FIND NEXT requisicao &IF DEFINED(CUSTOM_GRENDENE) &THEN 
                                             USE-INDEX nome-abrev
                                         &ELSE
                                             USE-INDEX requisicao
                                         &ENDIF
                         WHERE requisicao.nome-abrev = TRIM(c-nome-abrev) 
                           AND requisicao.tp-requis = 2 
                           AND requisicao.dt-requisicao >= p-da-solic-ini 
                           AND requisicao.dt-requisicao <= p-da-solic-fim 
                           AND (   (requisicao.situacao = 1 AND l-aberto) 
                                OR (requisicao.situacao = 2 AND l-fechado) 
                                OR (requisicao.situacao = 3 AND l-pendente) 
                                OR (requisicao.situacao = 4 AND l-ordem) ) 
                           AND (   (requisicao.estado   = 1 AND l-aprovado) 
                                OR (requisicao.estado   = 2 AND l-nao-aprovado)) NO-LOCK NO-ERROR.
            END.
        END.
    END.
        
    /* Se existir pelo menos um registro dispon¡vel, entra no bloco de repeti‡Æo que
       efetivamente criar  a temp-table que ser  retornada para ser mostrada no browse */
    IF AVAIL requisicao THEN REPEAT ON ERROR UNDO, RETURN "NOK":U:
        ASSIGN l-ok = NO.         
 
        /* L¢gica para verificar se a solicita‡Æo dever  ser mostrada com base 
           no tipo da apresenta‡Æo */
        FOR EACH  it-requisicao FIELDS(numero-ordem)
            WHERE it-requisicao.nr-requisicao = requisicao.nr-requisicao NO-LOCK:
            IF  p-apresentacao = 1 THEN DO:
                ASSIGN l-ok = YES.
                LEAVE.
            END.
            IF  it-requisicao.numero-ordem > 0 THEN DO:
                FOR FIRST ordem-compra FIELDS(numero-ordem num-pedido)
                    WHERE ordem-compra.numero-ordem = it-requisicao.numero-ordem NO-LOCK: END.
                IF  AVAILABLE ordem-compra THEN DO:
                    IF  p-apresentacao = 2 THEN DO:
                        ASSIGN l-ok = YES.
                        LEAVE.
                    END.
                    FOR  FIRST cotacao-item FIELDS()
                         WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                           AND cotacao-item.cot-aprovada = YES NO-LOCK: END.
                    IF  AVAILABLE cotacao-item THEN DO:
                        IF  p-apresentacao = 3 THEN DO:
                            ASSIGN l-ok = YES.
                            LEAVE.
                        END.
                        FOR FIRST pedido-compr FIELDS(num-pedido)
                            WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK: END.
                        IF  AVAILABLE pedido-compr THEN DO:
                            IF  p-apresentacao = 4 THEN DO:
                                ASSIGN l-ok = YES.
                                LEAVE.
                            END.

                            FOR FIRST recebimento FIELDS(qtd-rec)
                                WHERE recebimento.num-pedido   = pedido-compr.num-pedido 
                                  AND recebimento.numero-ordem = ordem-compra.numero-ordem 
                                  AND recebimento.qtd-rec      > 0 NO-LOCK: END.

                            IF  AVAIL recebimento 
                            AND p-apresentacao = 5 THEN DO:
                                ASSIGN l-ok = YES.
                                LEAVE.
                            END.
                        END.                                   
                    END.
                END.
            END.                   
        END.            
 
        /* Quando a solicita‡Æo deve ser mostrada cria a temp-table */ 
        IF  l-ok = YES THEN DO:
            CREATE tt-requisicao.
            ASSIGN tt-requisicao.nr-requisicao = requisicao.nr-requisicao       
                   tt-requisicao.situacao      = requisicao.situacao
                   tt-requisicao.estado        = requisicao.estado
                   tt-requisicao.dt-requisicao = requisicao.dt-requisicao
                   tt-requisicao.r-rowid       = ROWID(requisicao).

            /* Conta os registros criados */
            ASSIGN i-count-records  = i-count-records + 1.

        END.

        /* Verifica se o nr de registros criados na temp-table ‚ maior ou igual ao 
           nr m ximo que deve ser retornado  */
        IF  i-count-records >= p-max-return THEN DO:
            
            /* Abre a query principal da temp-table */
            RUN openQueryStatic ("Main":U).

            /* Posiciona no primeiro registro da temp-table */
            GET FIRST {&queryName}.
            IF  AVAIL tt-requisicao THEN DO:
                 /* Quando o rowid do primeiro da base for desconhecido armazena
                    o primeiro da temp-table como sendo o primeiro da base. */
                IF  p-first-base = ? THEN
                    ASSIGN p-first-base = tt-requisicao.r-rowid.
                
                /* Se o primeiro registro do browse for igual ao primeiro da base 
                   zera a vari vel para nÆo mostrar botÆo de anterior em tela */
                IF  tt-requisicao.r-rowid = p-first-base THEN
                    ASSIGN p-first-displayed = ?.
                ELSE
                    ASSIGN p-first-displayed = tt-requisicao.r-rowid.
                
                /* Atualiza vari vel que servir  de base para mostrar os mesmos
                   registros correntes em tela, quando necess rio */
                IF  p-navigation = "Next":U THEN
                    ASSIGN p-first-mantem-dados = tt-requisicao.r-rowid.

            END.

            /* Posiciona no £ltimo registro da temp-table */
            GET LAST {&queryName}.
            IF  AVAIL tt-requisicao THEN DO:

                /* Se o rowid do £ltimo registro for desconhecido, entÆo 
                   busca o £ltimo registro da base para armazenar o rowid */
                IF  p-last-base = ? THEN DO:        
                    FOR LAST  b-requisicao FIELDS() 
                              &IF DEFINED(CUSTOM_GRENDENE) &THEN 
                                  USE-INDEX nome-abrev
                              &ELSE
                                  USE-INDEX requisicao
                              &ENDIF 
                        WHERE b-requisicao.nome-abrev = TRIM(c-nome-abrev)
                          AND b-requisicao.tp-requis = 2
                          AND b-requisicao.dt-requisicao >= p-da-solic-ini
                          AND b-requisicao.dt-requisicao <= p-da-solic-fim
                          AND (   (b-requisicao.situacao = 1 AND l-aberto)
                               OR (b-requisicao.situacao = 2 AND l-fechado)
                               OR (b-requisicao.situacao = 3 AND l-pendente)
                               OR (b-requisicao.situacao = 4 AND l-ordem) )
                          AND (   (b-requisicao.estado   = 1 AND l-aprovado)
                               OR (b-requisicao.estado   = 2 AND l-nao-aprovado)) NO-LOCK
                        BREAK BY b-requisicao.nr-requisicao: END.
                    IF  AVAIL b-requisicao THEN
                        ASSIGN p-last-base = ROWID(b-requisicao).
                END.

                /* Se o £ltimo registro do browse for igual ao £ltimo da base 
                   zera a vari vel para nÆo mostrar botÆo de pr¢ximo em tela */
                IF  tt-requisicao.r-rowid = p-last-base THEN
                    ASSIGN p-last-displayed = ?.
                ELSE
                    ASSIGN p-last-displayed = tt-requisicao.r-rowid.


            END.

            /* Atualiza vari vel que servir  de base para mostrar os mesmos
               registros correntes em tela, quando necess rio */
            GET FIRST {&queryName}.
            ASSIGN p-first-mantem-dados = tt-requisicao.r-rowid.

            /* Sai do bloco de repeticao */
            LEAVE.
        END.

        /* Posiciona no anterior/pr¢ximo registro, conforme o tipo da navega‡Æo do browse */
        IF  p-navigation = "Prev":U THEN
            FIND PREV  requisicao &IF DEFINED(CUSTOM_GRENDENE) &THEN 
                                      USE-INDEX nome-abrev
                                  &ELSE
                                      USE-INDEX requisicao
                                  &ENDIF 
                 WHERE requisicao.nome-abrev = TRIM(c-nome-abrev) 
                   AND requisicao.tp-requis = 2 
                   AND requisicao.dt-requisicao >= p-da-solic-ini 
                   AND requisicao.dt-requisicao <= p-da-solic-fim 
                   AND (   (requisicao.situacao = 1 AND l-aberto) 
                        OR (requisicao.situacao = 2 AND l-fechado) 
                        OR (requisicao.situacao = 3 AND l-pendente) 
                        OR (requisicao.situacao = 4 AND l-ordem) ) 
                   AND (   (requisicao.estado   = 1 AND l-aprovado) 
                        OR (requisicao.estado   = 2 AND l-nao-aprovado)) NO-LOCK NO-ERROR.
        ELSE
            FIND NEXT  requisicao &IF DEFINED(CUSTOM_GRENDENE) &THEN 
                                      USE-INDEX nome-abrev
                                  &ELSE
                                      USE-INDEX requisicao
                                  &ENDIF 
                 WHERE requisicao.nome-abrev = TRIM(c-nome-abrev) 
                   AND requisicao.tp-requis = 2 
                   AND requisicao.dt-requisicao >= p-da-solic-ini 
                   AND requisicao.dt-requisicao <= p-da-solic-fim 
                   AND (   (requisicao.situacao = 1 AND l-aberto) 
                        OR (requisicao.situacao = 2 AND l-fechado) 
                        OR (requisicao.situacao = 3 AND l-pendente) 
                        OR (requisicao.situacao = 4 AND l-ordem) ) 
                   AND (   (requisicao.estado   = 1 AND l-aprovado) 
                        OR (requisicao.estado   = 2 AND l-nao-aprovado)) NO-LOCK NO-ERROR.

        /* Se nÆo encontrar mais registros para a sele‡Æo,
           ser  finalizado o bloco de repeti‡Æo */
        IF  NOT AVAIL requisicao THEN DO:

            /* Abre a query principal do programa */
            RUN openQueryStatic ("Main":U).

            IF  p-navigation = "Next":U THEN DO:
                /* Quando a navega‡Æo for "next", zera a vari vel que cont‚m o rowid do £ltimo
                   registro mostrado no browse para que nÆo mostre o botÆo de pr¢ximo na tela */
                ASSIGN p-last-displayed  = ?.
                
                /* Busca o £ltimo registro da query */
                GET LAST {&queryName}.
                IF  AVAIL tt-requisicao THEN
                    /* Armazena o rowid do £ltimo registro da temp-table como sendo
                       o £ltimo da base */ 
                    ASSIGN p-last-base = tt-requisicao.r-rowid.
                
                /* Quando mudar o registro da tabela pai zera a vari vel que cont‚m o primeiro 
                   registro do browse, para nÆo mostrar o botÆo de anterior na tela*/    
                IF  l-change-father OR (i-count-records < p-max-return AND p-first-base = ?) THEN
                    ASSIGN p-first-displayed = ?.
                ELSE DO:
                    /* SenÆo, armazena o rowid do primeiro registro do browse */
                    GET FIRST {&queryName}.
                    IF  AVAIL tt-requisicao THEN
                        ASSIGN p-first-displayed = tt-requisicao.r-rowid.
                END.
            END.
            ELSE 
            IF  p-navigation = "Prev":U THEN DO:
                /* Quando a navega‡Æo for "prev", zera a vari vel que cont‚m o rowid do primeiro
                   registro mostrado no browse para que nÆo mostre o botÆo de anterior na tela */
                ASSIGN p-first-displayed = ?.
                
                /* Busca o primeiro registro da query */
                GET FIRST {&queryName}.
                IF  AVAIL tt-requisicao THEN
                    /* Armazena o rowid do £ltimo registro da temp-table como sendo
                       o £ltimo da base */                 
                    ASSIGN p-first-base = tt-requisicao.r-rowid.
                    
                /* Quando mudar o registro da tabela pai zera a vari vel que cont‚m o £ltimo
                   registro do browse, para nÆo mostrar o botÆo de pr¢ximo na tela*/    
                IF  l-change-father THEN
                    ASSIGN p-last-displayed = ?.
                ELSE DO:
                    /* SenÆo, armazena o rowid do primeiro registro do browse */
                    GET LAST {&queryName}.
                    IF  AVAIL tt-requisicao THEN
                        ASSIGN p-last-displayed = tt-requisicao.r-rowid.
                END.
            END.

            /* Atualiza vari vel que servir  de base para mostrar os mesmos
               registros correntes em tela, quando necess rio */
            GET FIRST {&queryName}.
            if avail tt-requisicao then
            ASSIGN p-first-mantem-dados = tt-requisicao.r-rowid.

            /* Sai do bloco de repeti‡Æo */
            LEAVE.        
        END.
    END.

    IF  NOT CAN-FIND(FIRST tt-requisicao) THEN
        ASSIGN p-first-displayed = ?
               p-last-displayed  = ?
               p-first-mantem-dados = ?.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFirstLastTT DBOProgram 
PROCEDURE getFirstLastTT :
    DEF OUTPUT PARAM i-first-tt AS INT NO-UNDO.
    DEF OUTPUT PARAM i-last-tt  AS INT NO-UNDO.

    FOR FIRST tt-requisicao BREAK BY tt-requisicao.nr-requisicao: 
        ASSIGN i-first-tt = tt-requisicao.nr-requisicao.
    END.

    FOR LAST tt-requisicao BREAK BY tt-requisicao.nr-requisicao: 
        ASSIGN i-last-tt = tt-requisicao.nr-requisicao.
    END.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTPorNrRequisicaoQuery DBOProgram 
PROCEDURE carregaTTPorNrRequisicaoQuery:

  DEF INPUT PARAM p-nome-abrev         AS CHAR  NO-UNDO.
  DEF INPUT PARAM p-aprovado           AS LOG   NO-UNDO.
  DEF INPUT PARAM p-nao-aprovado       AS LOG   NO-UNDO.
  DEF INPUT PARAM p-aberto             AS LOG   NO-UNDO.
  DEF INPUT PARAM p-fechado            AS LOG   NO-UNDO.
  DEF INPUT PARAM p-pendente           AS LOG   NO-UNDO.
  DEF INPUT PARAM p-ordem              AS LOG   NO-UNDO.
  DEF INPUT PARAM p-max-rows           AS INT   NO-UNDO.
  DEF INPUT PARAM p-navigation         AS CHAR  NO-UNDO.
  DEF INPUT PARAM p-folder             AS CHAR  NO-UNDO.
  DEF INPUT PARAM p-nr-requisicao-ini          AS INT  NO-UNDO.
  DEF INPUT PARAM p-nr-requisicao-fim          AS INT  NO-UNDO.
  DEF INPUT PARAM p-dt-requisicao-ini          AS DATE NO-UNDO.
  DEF INPUT PARAM p-dt-requisicao-fim          AS DATE NO-UNDO.
  DEF INPUT PARAM p-cod-estabel-ini            AS CHAR NO-UNDO.
  DEF INPUT PARAM p-cod-estabel-fim            AS CHAR NO-UNDO. 
  DEF INPUT-OUTPUT PARAM p-last-rowid  AS ROWID NO-UNDO.
  DEF INPUT-OUTPUT PARAM p-first-rowid AS ROWID NO-UNDO.
  DEF INPUT-OUTPUT PARAM p-last-it-requisicao  AS ROWID NO-UNDO.
  DEF INPUT-OUTPUT PARAM p-first-it-requisicao AS ROWID NO-UNDO.
  DEF INPUT-OUTPUT PARAM p-first-mantem-dados-req     AS ROWID NO-UNDO.
  DEF INPUT-OUTPUT PARAM p-first-mantem-dados-it-req  AS ROWID NO-UNDO.

/* Testa a versÆo do Progress */
&IF INT (SUBSTRING (PROVERSION, 1, INDEX (PROVERSION, ".") - 1)) >= 9 &THEN

  DEF VAR i-cont AS INT NO-UNDO.

  /* Defini‡Æo da query */
  DEF QUERY q-requis FOR requisicao FIELDS(nome-abrev nr-requisicao dt-requisicao dt-atend dt-devol cod-estabel situacao estado), 
                         it-requisicao FIELDS(nr-requisicao it-codigo situacao estado qt-requisitada qt-atendida sequencia cod-estabel),
                         ITEM FIELDS(it-codigo desc-item) SCROLLING.
    
  IF  p-folder = "2" THEN DO:
      /* Abertura da query para requisicao, it-requisicao e item por data */
      OPEN QUERY q-requis
      FOR EACH requisicao NO-LOCK 
       WHERE requisicao.nr-requisicao >= p-nr-requisicao-ini  
          AND requisicao.nr-requisicao <= p-nr-requisicao-fim    
          AND requisicao.cod-estabel >= p-cod-estabel-ini
          AND requisicao.cod-estabel <= p-cod-estabel-fim
          AND requisicao.dt-requisicao >= p-dt-requisicao-ini
          AND requisicao.dt-requisicao <= p-dt-requisicao-fim
          AND requisicao.nome-abrev = p-nome-abrev
         AND (   p-aprovado     AND requisicao.estado    = 1          
              OR p-nao-aprovado AND requisicao.estado    = 2) 
         AND (   p-aberto       AND requisicao.situacao  = 1          
              OR p-fechado      AND requisicao.situacao  = 2          
              OR p-pendente     AND requisicao.situacao  = 3          
              OR p-ordem        AND requisicao.situacao  = 4),
      EACH it-requisicao NO-LOCK 
       WHERE it-requisicao.cod-estabel = requisicao.cod-estabel 
         AND it-requisicao.nr-requisicao = requisicao.nr-requisicao,
      FIRST item
       WHERE item.it-codigo = it-requisicao.it-codigo NO-LOCK
       BY requisicao.nome-abrev
       BY requisicao.dt-requisicao
       {&v9Ind-Rep}.
  END.
  ELSE DO:
      /* Abertura da query para requisicao, it-requisicao e item por nr-requisicao */
      OPEN QUERY q-requis
      FOR EACH requisicao
        &IF DEFINED(CUSTOM_GRENDENE) &THEN 
            USE-INDEX nome-abrev
        &ENDIF
       NO-LOCK 
       WHERE  requisicao.nr-requisicao >= p-nr-requisicao-ini  
          AND requisicao.nr-requisicao <= p-nr-requisicao-fim    
          AND requisicao.cod-estabel >= p-cod-estabel-ini
          AND requisicao.cod-estabel <= p-cod-estabel-fim
          AND requisicao.dt-requisicao >= p-dt-requisicao-ini
          AND requisicao.dt-requisicao <= p-dt-requisicao-fim
          AND requisicao.nome-abrev = p-nome-abrev
         AND (   p-aprovado     AND requisicao.estado    = 1          
              OR p-nao-aprovado AND requisicao.estado    = 2) 
         AND (   p-aberto       AND requisicao.situacao  = 1          
              OR p-fechado      AND requisicao.situacao  = 2          
              OR p-pendente     AND requisicao.situacao  = 3          
              OR p-ordem        AND requisicao.situacao  = 4),
       EACH it-requisicao WHERE it-requisicao.cod-estabel = requisicao.cod-estabel 
                            AND it-requisicao.nr-requisicao = requisicao.nr-requisicao NO-LOCK,
       FIRST item
       WHERE item.it-codigo = it-requisicao.it-codigo NO-LOCK
       BY requisicao.nome-abrev
       &IF DEFINED(CUSTOM_GRENDENE) &THEN 
           BY requisicao.nr-requisicao
       &ENDIF
       {&v9Ind-Rep}.
  END.

   /* Se o primeiro e o £ltimo rowid da temp-table do browse forem desconhecidos
      parte come‡a a criar a temp-table do primeiro registro */
   IF  p-last-rowid = ?
   AND p-first-rowid = ? THEN
       GET FIRST q-requis.
   ELSE DO:
       IF  p-navigation = "Prev":U THEN DO:
           /* se o rowid do it-requisicao for desconhecido reposiciona somente a requisicao */
           IF  p-first-it-requisicao = ? THEN
               REPOSITION q-requis TO ROWID p-first-rowid NO-ERROR.
           ELSE 
               /* SenÆo reposiciona o it-requisicao tamb‚m */
               REPOSITION q-requis TO ROWID p-first-rowid, p-first-it-requisicao NO-ERROR.
       END.
       ELSE DO:

           IF  p-first-mantem-dados-req <> ?
           AND p-first-mantem-dados-it-req <> ? THEN 
               REPOSITION q-requis TO ROWID p-first-mantem-dados-req, p-first-mantem-dados-it-req NO-ERROR.
           
           ELSE DO:
               /* se o rowid do it-requisicao for desconhecido reposiciona somente a requisicao */
               IF  p-last-it-requisicao = ? THEN
                   REPOSITION q-requis TO ROWID p-last-rowid NO-ERROR.
               ELSE
                   /* SenÆo reposiciona o it-requisicao tamb‚m */
                   REPOSITION q-requis TO ROWID p-last-rowid, p-last-it-requisicao NO-ERROR.
           END.
       END.

       /* Ap¢s o comando reposition deve ser executado o  comando get next(bug da Progress) */

       GET NEXT q-requis.

   END.
   
   /* Se encontrar alguma requisicao na abertura da query cria a temp-table at‚ o nr
      m ximo de linhas que o browse pode mostrar */
   
   IF AVAIL requisicao THEN
   DO  i-cont = 1 TO p-max-rows:

       CREATE tt-requisicao.
       ASSIGN tt-requisicao.nr-requisicao = requisicao.nr-requisicao   
              tt-requisicao.it-codigo     = it-requisicao.it-codigo
              tt-requisicao.des-item      = ITEM.desc-item
              tt-requisicao.qt-requisit   = it-requisicao.qt-requisitada
              tt-requisicao.dt-requisicao = requisicao.dt-requisicao
              tt-requisicao.qt-atendida   = it-requisicao.qt-atendida
              tt-requisicao.situacao      = requisicao.situacao
              tt-requisicao.estado        = requisicao.estado
              tt-requisicao.dt-atend      = requisicao.dt-atend
              tt-requisicao.dt-devol      = requisicao.dt-devol
              tt-requisicao.sequencia     = it-requisicao.sequencia
              tt-requisicao.r-rowid       = ROWID(it-requisicao)
              tt-requisicao.r-rowid2      = ROWID(requisicao).

       IF  p-navigation = "Prev":U THEN
           GET PREV q-requis.
       ELSE
           GET NEXT q-requis.

       /* Quando a busca se der ap¢s o fim da tabela ou
          antes do in¡cio da tabela sai do repeat */
       IF  NOT AVAIL requisicao THEN
           LEAVE.

   END.

   /* Se existir algum registro na temp-table, carrega as vari veis que servirÆo de
      base para reposicionamento da query na pr¢xima navega‡Æo */
   IF  CAN-FIND(FIRST tt-requisicao) THEN DO:
       IF  p-navigation = "Prev":U THEN DO:
    
           FIND LAST tt-requisicao NO-ERROR.
           GET FIRST q-requis.
           IF  AVAIL tt-requisicao
           AND AVAIL requisicao
           AND tt-requisicao.r-rowid2 = ROWID(requisicao) THEN 
               ASSIGN p-first-rowid = ?
                      p-first-it-requisicao = ?.
           ELSE DO:
               IF AVAIL tt-requisicao THEN
                   ASSIGN p-first-rowid = tt-requisicao.r-rowid2
                          p-first-it-requisicao = tt-requisicao.r-rowid.
           END.

           FIND FIRST tt-requisicao NO-ERROR.
           GET LAST q-requis.
           IF  AVAIL tt-requisicao
           AND AVAIL requisicao
           AND tt-requisicao.r-rowid2 = ROWID(requisicao) THEN
               ASSIGN p-last-rowid = ?
                      p-last-it-requisicao = ?.
           ELSE DO:
               IF AVAIL tt-requisicao THEN
                   ASSIGN p-last-rowid = tt-requisicao.r-rowid2
                          p-last-it-requisicao = tt-requisicao.r-rowid.
           END.
       END.
       ELSE DO:
           FIND FIRST tt-requisicao NO-ERROR.
           GET FIRST q-requis.
           IF  AVAIL tt-requisicao
           AND AVAIL requisicao
           AND tt-requisicao.r-rowid2 = ROWID(requisicao) THEN
               ASSIGN p-first-rowid = ?
                      p-first-it-requisicao = ?.
           ELSE DO:
               IF AVAIL tt-requisicao THEN
                   ASSIGN p-first-rowid = tt-requisicao.r-rowid2
                          p-first-it-requisicao = tt-requisicao.r-rowid.
           END.
               
           FIND LAST tt-requisicao NO-ERROR.
           GET LAST q-requis.
           IF  AVAIL tt-requisicao
           AND AVAIL requisicao
           AND tt-requisicao.r-rowid2 = ROWID(requisicao) THEN
               ASSIGN p-last-rowid = ?
                      p-last-it-requisicao = ?.
           ELSE DO:
               IF AVAIL tt-requisicao THEN
                   ASSIGN p-last-rowid = tt-requisicao.r-rowid2
                          p-last-it-requisicao = tt-requisicao.r-rowid.
           END.
       END.
   END.
   ELSE
       /* Quando nÆo existir nenhum registro na temp-table zera as vari veis base
          do pr¢ximo reposicionamento da query */
       ASSIGN p-first-rowid = ?
              p-last-rowid  = ?
              p-last-it-requisicao  = ?
              p-first-it-requisicao = ?.
   
   IF  p-navigation = "Prev":U THEN
       FIND LAST tt-requisicao NO-ERROR.
   ELSE
       FIND FIRST tt-requisicao NO-ERROR.
   
   IF  AVAIL tt-requisicao THEN
       ASSIGN p-first-mantem-dados-req = tt-requisicao.r-rowid2
              p-first-mantem-dados-it-req = tt-requisicao.r-rowid.

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTPorNrRequisicao DBOProgram 
PROCEDURE carregaTTPorNrRequisicao:
/*------------------------------------------------------------------------------
  Purpose:     carregaTabelaTemp1
    Gera temp-table tt-requisi‡Æo para a consulta das requisi‡äes do comprador do m¢dulo de compras, 
    ordenando pelo estabelecimento e pelo n£mero da requisi‡Æo.
  Parameters:
    ipar1  : p-nome-abrev    : Nome Abrev
    ipar2  : p-aprovado      : Situa‡Æo Aprovado
    ipar3  : p-nao-aprovado  : Situa‡Æo NÆo Aprovado
    ipar4  : p-aberto        : Situa‡Æo Aberto
    ipar5  : p-fechado       : Situa‡Æo Fechado
    ipar6  : p-pendente      : Situa‡Æo pendente
    ipar7  : p-ordem         : Ordem
  Notes:
------------------------------------------------------------------------------*/

    def input param p-nome-abrev       as char.
    def input param p-aprovado         as log.
    def input param p-nao-aprovado     as log.
    def input param p-aberto           as log.
    def input param p-fechado          as log.
    def input param p-pendente         as log.
    def input param p-ordem            as log.
    
    FOR EACH requisicao fields(nr-requisicao dt-requisicao dt-atend dt-devol)
        &IF DEFINED(CUSTOM_GRENDENE) &THEN 
            USE-INDEX nome-abrev
        &ENDIF
       NO-LOCK 
       WHERE requisicao.nome-abrev = p-nome-abrev,
       EACH  it-requisicao fields(it-codigo situacao estado qt-requisitada qt-atendida sequencia) no-lock 
       WHERE it-requisicao.nr-requisicao = requisicao.nr-requisicao 
         AND (p-aprovado         and it-requisicao.estado    = 1          or
              p-nao-aprovado     and it-requisicao.estado    = 2) 
         AND (p-aberto           and it-requisicao.situacao  = 1          or
              p-fechado          and it-requisicao.situacao  = 2          or 
              p-pendente         and it-requisicao.situacao  = 3          or
              p-ordem            and it-requisicao.situacao  = 4):              
        
       FOR FIRST item fields(desc-item) 
           WHERE item.it-codigo = it-requisicao.it-codigo no-lock. end.         
       
       if not avail item then next.      
     
        CREATE  tt-requisicao.
        ASSIGN  tt-requisicao.nr-requisicao = requisicao.nr-requisicao   
                tt-requisicao.it-codigo     = it-requisicao.it-codigo
                tt-requisicao.des-item      = ITEM.desc-item
                tt-requisicao.qt-requisit   = it-requisicao.qt-requisitada
                tt-requisicao.dt-requisicao = requisicao.dt-requisicao
                tt-requisicao.qt-atendida   = it-requisicao.qt-atendida
                tt-requisicao.situacao      = it-requisicao.situacao
                tt-requisicao.estado        = it-requisicao.estado
                tt-requisicao.dt-atend      = requisicao.dt-atend
                tt-requisicao.dt-devol      = requisicao.dt-devol
                tt-requisicao.sequencia     = it-requisicao.sequencia
                tt-requisicao.r-rowid       = ROWID(it-requisicao)
                tt-requisicao.r-rowid2      = ROWID(requisicao).

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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n'o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "des-item":U THEN ASSIGN pFieldValue = RowObject.des-item.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n'o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dt-atend":U THEN ASSIGN pFieldValue = RowObject.dt-atend.
        WHEN "dt-devol":U THEN ASSIGN pFieldValue = RowObject.dt-devol.
        WHEN "dt-requisicao":U THEN ASSIGN pFieldValue = RowObject.dt-requisicao.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n'o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "qt-requisit":U THEN ASSIGN pFieldValue = RowObject.qt-requisit.
        WHEN "qt-atendida":U THEN ASSIGN pFieldValue = RowObject.qt-atendida.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n'o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "nr-requisicao":U THEN ASSIGN pFieldValue = RowObject.nr-requisicao.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ­ndice ESTAB-REQ
  Parameters:
               retorna valor dos campos do ­ndice ESTAB-REQ
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-requisicao LIKE requisicao.nr-requisicao NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n'o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnr-requisicao = RowObject.nr-requisicao.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowidField DBOProgram 
PROCEDURE getRowidField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo rowid
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS ROWID NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n'o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "r-rowid2":U THEN
            ASSIGN pFieldValue = RowObject.r-rowid2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ­ndice ESTAB-REQ
  Parameters:
               recebe valor dos campos do ­ndice ESTAB-REQ
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-requisicao LIKE requisicao.nr-requisicao NO-UNDO.

    FIND FIRST bftt-requisicao WHERE
        bftt-requisicao.nr-requisicao = pnr-requisicao
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bftt-requisicao THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr1/4ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bftt-requisicao)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

 define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
           RUN openQueryStatic (input "Main":U).       
        when 2 then
           RUN openQueryStatic (input "ByDtRequisicao":U).       
        when 3 then
           RUN openQueryStatic (input "ByNrRequisicao":U).                  
    end case.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} 
       FOR EACH tt-requisicao by tt-requisicao.nr-requisicao.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNrRequisicao DBOProgram 
PROCEDURE openQueryByNrRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} 
       FOR EACH tt-requisicao
           by tt-requisicao.nr-requisicao
           by tt-requisicao.it-codigo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDtRequisicao DBOProgram 
PROCEDURE openQueryByDtRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} 
       FOR EACH tt-requisicao
           by tt-requisicao.dt-requisicao
           by tt-requisicao.nr-requisicao
           by tt-requisicao.it-codigo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterRepositionRecord DBOProgram 
PROCEDURE afterRepositionRecord:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param prChave as rowid no-undo.
    
    find {&TABLENAME} where
         {&TABLENAME}.r-rowid = prChave no-lock no-error.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowidFirstLast DBOProgram 
PROCEDURE getRowidFirstLast :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param r-chave-inform as rowid no-undo.
    def input  param c-nav          as char  no-undo.
    def input  param i-linhas       as int   no-undo.
    def output param r-first        as rowid no-undo.
    def output param r-last         as rowid no-undo.
    def var iAuxCont as int no-undo.

    if r-chave-inform <> ? then do:
       find bf{&TABLENAME} where 
            bf{&TABLENAME}.r-rowid = r-chave-inform
             no-lock no-error.

       if c-nav = "ant" then do:
            assign r-last = bf{&TABLENAME}.r-rowid.
            assign linha-aux = i-linhas - 1.
            DO iAuxCont = 1 TO linha-aux:
              find prev bf{&TABLENAME} no-lock no-error.
              IF not avail bf{&TABLENAME} THEN DO:
                find first bf{&TABLENAME} no-lock no-error.
                ASSIGN iAuxCont = linha-aux + 1.
              END.
              if iAuxCont = linha-aux then do:
                 assign r-first = bf{&TABLENAME}.r-rowid.
              end.
            END.
       end.

       if c-nav = "pro" or r-first = ? then do:  /* se no "ant" r-first = ? preciso achar r-last */
            if c-nav = "pro" then assign r-first = bf{&TABLENAME}.r-rowid.
            assign linha-aux = i-linhas - 1.
            DO iAuxCont = 1 TO linha-aux:
              find next bf{&TABLENAME} no-lock no-error.
              IF not avail bf{&TABLENAME} THEN DO:
                find last bf{&TABLENAME} no-lock no-error.
                ASSIGN iAuxCont = i-linhas + 1.
              END.
              if iAuxCont = linha-aux then do:
                 assign r-last = bf{&TABLENAME}.r-rowid.
              end.
            END.
       end.
    end.

    find first bf{&TABLENAME} no-lock no-error.
    if bf{&TABLENAME}.r-rowid = r-first then assign r-first = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowid DBOProgram 
PROCEDURE getRowid :
/*------------------------------------------------------------------------------
  Purpose:     Envia rowid do registro corrente da table {&Tablename}
  Parameters:  retorna rowid
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pRowid  AS ROWID NO-UNDO.
    
    IF NOT AVAILABLE {&TableName} THEN DO:
        /*--- Erro 3: Tabela {&TableLabel} n'o dispon­vel ---*/
        {method/svc/errors/inserr.i &ErrorNumber="3"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        RETURN "NOK":U.
    END.
    
    ASSIGN pRowid = {&TableName}.r-rowid.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCopyBuffer2TT DBOProgram 
PROCEDURE afterCopyBuffer2TT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN RowObject.r-rowid = {&TableName}.r-rowid.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterGetRowid DBOProgram 
PROCEDURE afterGetRowid :
/*------------------------------------------------------------------------------
  Purpose:     Envia rowid do registro corrente da table {&Tablename}
  Parameters:  retorna rowid
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE input-output PARAMETER pRowid  AS ROWID NO-UNDO.

    ASSIGN pRowid = {&TableName}.r-rowid.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeRepositionRecord DBOProgram 
PROCEDURE beforeRepositionRecord :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona query
  Parameters:  recebe rowid da tabela {&TableName}
  Notes:       Atualiza temptable RowObject (_copyBuffer2TT)
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowid  AS ROWID NO-UNDO.
    
    FIND {&TableName} WHERE {&TableName}.r-rowid = pRowid NO-LOCK NO-ERROR.
    
    ASSIGN pRowid = ROWID({&TableName}).
    
    /*--- Reposiciona query ---*/
    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        /*--- Erro 11: N'o foi poss­vel reposicionar a query ---*/
        {method/svc/errors/inserr.i &ErrorNumber="11"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        RETURN "NOK":U.
    END.
    
    /*--- È necessÿrio para o correto funcionamento do reposicionamento ---*/
    GET NEXT {&QueryName} NO-LOCK.
    
    
    /*--- Seta flag indicando que o registro atual foi reposicionado ---*/
    &if "{&DBType}" = "ORACLE":U &then
        ASSIGN lRepositioned = YES.
    &endif
    
    if avail {&TableName} then
        /*--- Atualiza temptable RowObject ---*/
        RUN _copyBuffer2TT IN THIS-PROCEDURE.
    
        RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnDataDevol DBOProgram 
PROCEDURE returnDataDevol :

 DEF INPUT PARAMETER  pNrRequisicao AS INT NO-UNDO.
 DEF OUTPUT PARAMETER cData         AS DATE NO-UNDO.

    FIND requisicao
        WHERE requisicao.nr-requisicao = pNrRequisicao
        NO-LOCK NO-ERROR.
    IF AVAIL requisicao THEN 
        ASSIGN cData = requisicao.dt-devol.
    ELSE
        ASSIGN cData = ?.

     RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnDataAtend DBOProgram 
PROCEDURE returnDataAtend :

 DEF INPUT PARAMETER  pNrRequisicao AS INT NO-UNDO.
 DEF OUTPUT PARAMETER cData         AS DATE NO-UNDO.

    FIND requisicao
        WHERE requisicao.nr-requisicao = pNrRequisicao
        NO-LOCK NO-ERROR.
    IF AVAIL requisicao THEN 
        ASSIGN cData = requisicao.dt-atend.
    ELSE
        ASSIGN cData = ?.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


