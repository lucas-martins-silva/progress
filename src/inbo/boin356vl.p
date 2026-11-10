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
{include/i-prgvrs.i BOIN356VL 2.00.01.022 } /*** "010122" 17/06/2025 16:40:48 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin356vl MUT}
&ENDIF


/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName prazo-compra
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName prazo-compra
&GLOBAL-DEFINE TableLabel prazo-compra
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (boin356.p) est† com as funá‰es de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque S‡ nela foram implementadas as triggers do dicion†rio.
**  Para desabilitar as procedures foram usados os prÇ-processadores abaixo.
**  A procedure validateRecord dessa DBO n∆o deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0


/*--- Include com definiá∆o da temptable RowObject ---*/
{inbo/boin356.i RowObject}
{inbo/boin356.i tt-parcelas-aux}
{inbo/boin356.i tt-buffer-parcelas}

DEFINE TEMP-TABLE tt-embarque NO-UNDO
    FIELD embarque AS CHAR FORMAT "x(16)":U.

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName}  FOR {&TableName}.
DEFINE BUFFER bf-prazo-compra FOR {&TableName}.
DEFINE BUFFER b-ordem         FOR ordem-compra.
DEFINE BUFFER b-prazo-compra  FOR prazo-compra.
DEFINE BUFFER b-prazo         FOR prazo-compra.
DEFINE BUFFER b-parcela       FOR prazo-compra.
DEFINE BUFFER b-usuar-mater   FOR usuar-mater.

/* Local Variable Definitions ---                                            */
DEFINE VARIABLE c-seg-usuario           AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE cParamManutOrd          AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE cParamModo              AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE cParamType              AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-lbl-trad              AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE cUnFornec               AS CHARACTER FORMAT "X(25)":U   NO-UNDO.
DEFINE VARIABLE nova-dt                 AS DATE                         NO-UNDO.
DEFINE VARIABLE de-indice               as DECIMAL                      NO-UNDO.
DEFINE VARIABLE de-qtd-parc             AS DECIMAL  INITIAL 0           NO-UNDO.
DEFINE VARIABLE de-tot-parcela          AS DECIMAL  INITIAL 0           NO-UNDO.
DEFINE VARIABLE de-tot-quant-parc       AS DECIMAL                      NO-UNDO.
DEFINE VARIABLE h-boin082ca             AS HANDLE                       NO-UNDO.
DEFINE VARIABLE h-boin295               AS HANDLE                       NO-UNDO.
DEFINE VARIABLE h-boin356ca             AS HANDLE                       NO-UNDO.
DEFINE VARIABLE h-boin356               AS HANDLE                       NO-UNDO.
DEFINE VARIABLE h-boin274vl             AS HANDLE                       NO-UNDO.
DEFINE VARIABLE h-bocx140               AS HANDLE                       NO-UNDO.
DEFINE VARIABLE h-boiv037               AS HANDLE                       NO-UNDO. /* Integraá∆o Investimentos */
DEFINE VARIABLE h-bocx225               AS HANDLE                       NO-UNDO. /* relacionamento pedido/ordem com o embarque*/
DEFINE VARIABLE h-bocx341               AS HANDLE                       NO-UNDO. /*Despesas do pedido*/
DEFINE VARIABLE dias-ressup             AS INTEGER                      NO-UNDO.
DEFINE VARIABLE i-cont                  AS INTEGER                      NO-UNDO.
DEFINE VARIABLE dt-ressup               AS INTEGER                      NO-UNDO.
DEFINE VARIABLE dt-entrega              AS INTEGER                      NO-UNDO.
DEFINE VARIABLE l-exp-cli-ped           AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-invest                AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-ord-inv               AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-cc0308                AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-parc-quant-lote-min   AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-erro-calend           AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-atualiza-quantidade   AS LOGICAL INITIAL NO           NO-UNDO.
DEFINE VARIABLE l-create                AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-seg-cc0300            AS LOGICAL INITIAL NO           NO-UNDO. /* Indica permiss∆o do usu†rio para manutená∆o de pedidos no programa cc0300 */
DEFINE VARIABLE rChave                  AS ROWID                        NO-UNDO.
DEFINE VARIABLE r-chave                 AS ROWID                        NO-UNDO.

{cdp/cd0669.i}                    /* Definicao tt-erro                          */
{cdp/cdcfgmat.i}                  /* Include com prÇ-processadores de Materiais */
{include/boerrtab.i}              /* Definicao tt-bo-erro                       */
{inbo/boin274.i tt-ordem-compra}  /* Ordem Compra                               */
{inbo/boin082.i tt-cotacao-item}


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

/* ***********************  Control Definitions  ********************** */


/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields
    to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 19.67
         WIDTH              = 41.
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

/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 

{method/svc/autentic/autentic.i &vUserName="c-seg-usuario"}

FIND FIRST param-compra NO-LOCK NO-ERROR.
FIND FIRST param-global NO-LOCK NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaAltPedPrazoCompra DBOProgram 
PROCEDURE atualizaAltPedPrazoCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF AVAIL prazo-compra THEN DO:
        FOR FIRST ordem-compra FIELDS(numero-ordem situacao  cod-emitente data-cotacao it-codigo num-pedido num-ord-inv) 
            WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem NO-LOCK: END.

        IF AVAIL ordem-compra THEN DO:
            FOR FIRST emitente FIELDS(cod-emitente nome-abrev) 
                WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK: END.
            CREATE alt-ped.
            ASSIGN alt-ped.data         = TODAY
                   alt-ped.hora         = STRING(TIME,"HH:MM:SS":U)
                   alt-ped.usuario      = c-seg-usuario
                   alt-ped.num-pedido   = ordem-compra.num-pedido
                   alt-ped.numero-ordem = ordem-compra.numero-ordem
                   alt-ped.parcela      = prazo-compra.parcela
                   alt-ped.observacao   = "# ":U + "Inclus∆o de Parcela"
                   alt-ped.data-entrega = prazo-compra.data-entrega
                   alt-ped.quantidade   = prazo-compra.quantidade.
            IF AVAIL emitente THEN
                ASSIGN alt-ped.nome-abrev   = emitente.nome-abrev.
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaDataHoraUsuarioPrazoCompra DBOProgram 
PROCEDURE atualizaDataHoraUsuarioPrazoCompra :
/*------------------------------------------------------------------------------
  Purpose:     
    Atualiza dados de Data, Hora e usu†rio de criaá∆o/alteraá∆o
  Parameters:  <none>
    ipar1 : p-c-usuar-corren : Usu†rio corrente do sistema
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-c-usuar-corren AS CHARACTER NO-UNDO.

    FIND FIRST ordem-compra 
         WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem EXCLUSIVE-LOCK NO-ERROR.
    
    IF AVAIL ordem-compra THEN
      ASSIGN ordem-compra.usuario      = p-c-usuar-corren
             ordem-compra.data-atualiz = TODAY
             ordem-compra.hora-atualiz = STRING(TIME,"hh:mm:ss":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaQtdeOrdemCompra DBOProgram 
PROCEDURE atualizaQtdeOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     
     Atualiza automaticamente a qtde solicitada da Ordem de Compra quando necess†rio.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE l-qtd-alterada AS LOGICAL NO-UNDO.
    FIND FIRST ordem-compra 
         WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
  
    IF AVAIL ordem-compra THEN DO:
        IF NOT VALID-HANDLE (h-boin356ca) THEN
            RUN inbo/boin356ca.p PERSISTENT SET h-boin356ca.
      
        RUN totalizaQuantidadeParcelasOrdem in h-boin356ca (INPUT ordem-compra.numero-ordem,
                                                            OUTPUT de-tot-quant-parc).
        IF VALID-HANDLE (h-boin356ca) THEN DO:
            DELETE PROCEDURE h-boin356ca.
            ASSIGN h-boin356ca = ?.
        END.
        ASSIGN l-qtd-alterada = ordem-compra.qt-solic <> de-tot-quant-parc
               ordem-compra.qt-solic = de-tot-quant-parc.

        IF l-qtd-alterada AND 
           ordem-compra.num-pedido <> 0 AND 
           AVAIL param-global AND 
           param-global.modulo-07 /*Importaá∆o*/ AND
           CONNECTED("mgcex":U) THEN DO:

            RUN cxbo/bocx341.p PERSISTENT SET h-bocx341.
            RUN atualizaDespesasOrdemQtdAlterada IN h-bocx341 (INPUT ordem-compra.num-pedido).
            RUN getRowErrors IN h-bocx341(OUTPUT TABLE RowErrors APPEND).
            DELETE PROCEDURE h-bocx341.
            ASSIGN h-bocx341 = ?.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaQuantidadeParcela DBOProgram 
PROCEDURE atualizaQuantidadeParcela :
/*------------------------------------------------------------------------------
  Purpose:     
     Soma-se a data da aprovaá∆o da cotaá∆o, o prazo (em dias) de entrega definido
     na cotaá∆o. Se esta nova data comparada com a primeira entrega estabelecida na
     ordem for maior, ser  aberta um tela com as opá‰es de: Atualiza datas ate prazo
     de entrega  -  Atualiza todas as datas  -  N∆o atualiza datas.
     Pela primeira opá∆o, todas as parcelas com entrega atrasada ir∆o assumir a nova
     data estabelecida. 
     Na segunda opá∆o, a primeira parcela assume a nova data estabelecida; as
     demais, verifica-se a diferenáa em dias da nova data de entrega com a data
     original. Esta diferenáa e' somada aos demais prazos de entrega, prevalecendo
     assim o intervalo entre uma entrega e outra.
  Parameters:
     ipar1 : r-cotacao-item   : rowid da cotacao do item corrente
     ipar2 : r-item           : rowid do item corrente
     ipar3 : c-altera-qtde    : indica se o usu rio quer alterar a quantidade da parcela
     ipar4 : c-atualiza-data  : 1 - Atualiza datas ate prazo de entrega  2 - Atualiza todas as datas  
                                3 - N∆o atualiza datas
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER r-cotacao-item   AS ROWID      NO-UNDO.
    DEFINE INPUT PARAMETER r-item           AS ROWID      NO-UNDO.
    DEFINE INPUT PARAMETER c-altera-qtde    AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER c-atualiza-data  AS CHARACTER  NO-UNDO.
    
    DEFINE VARIABLE de-quantidade   AS DECIMAL                      NO-UNDO. 
    DEFINE VARIABLE i-atualiza      AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE i-dias-atualiza AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE l-altera-qtde   AS LOGICAL                      NO-UNDO.
    DEFINE VARIABLE da-atualiza     AS DATE                         NO-UNDO.
    DEFINE VARIABLE de-lote-minimo  LIKE item-fornec.lote-minimo    NO-UNDO.
    DEFINE VARIABLE de-lote-mul-for LIKE item-fornec.lote-mul-for   NO-UNDO.

    FIND FIRST param-compra NO-LOCK NO-ERROR.

    IF c-altera-qtde = "":U THEN
       ASSIGN l-altera-qtde = NO.
    ELSE
       ASSIGN l-altera-qtde = YES.
      
    FIND FIRST cotacao-item 
         WHERE ROWID(cotacao-item) = r-cotacao-item NO-LOCK NO-ERROR.

    IF AVAIL cotacao-item THEN DO:
        BUFFER-COPY cotacao-item TO tt-cotacao-item.
    
        FOR FIRST ordem-compra FIELDS(numero-ordem cod-estabel situacao)  
            WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem NO-LOCK: END.
        
        FOR FIRST item FIELDS(it-codigo tipo-contr) 
            WHERE ROWID(item) = r-item NO-LOCK: END.

        IF AVAIL item THEN DO:
            FOR FIRST item-fornec FIELDS(it-codigo   cod-emitente ativo lote-minimo lote-mul-for) 
                WHERE item-fornec.it-codigo    = item.it-codigo 
                  AND item-fornec.cod-emitente = cotacao-item.cod-emitente 
                  AND item-fornec.ativo NO-LOCK: END.
            
           IF AVAIL ordem-compra THEN
               FOR FIRST item-fornec-estab FIELDS(it-codigo cod-emitente cod-estabel ativo lote-minimo lote-mul-for) 
                   WHERE item-fornec-estab.it-codigo    = item.it-codigo 
                     AND item-fornec-estab.cod-estabel  = ordem-compra.cod-estabel 
                     AND item-fornec-estab.cod-emitente = cotacao-item.cod-emitente 
                     AND item-fornec-estab.ativo NO-LOCK: END.
        END.
        
        ASSIGN i-atualiza  = INT(c-atualiza-data)
               dias-ressup = cotacao-item.prazo-entreg.
    
        /* considera somente dias £teis */
        IF AVAIL param-compra AND substring(param-compra.char-1,136,1) = "1":U THEN DO:
           ASSIGN nova-dt = TODAY.
           {inbo/boin356.i2 "ordem-compra.cod-estabel"}        
        END.
        IF (AVAIL param-compra AND substring(param-compra.char-1,136,1) = " ":U) OR l-erro-calend THEN
            ASSIGN nova-dt = TODAY + dias-ressup.
    
        ASSIGN da-atualiza = nova-dt.
    END.

    IF AVAIL ordem-compra THEN
        FOR EACH prazo-compra EXCLUSIVE-LOCK
           WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem 
        BREAK BY prazo-compra.numero-ordem:

            ASSIGN prazo-compra.situacao = ordem-compra.situacao.
            IF prazo-compra.data-entrega < da-atualiza AND i-atualiza < 3 THEN DO:
                IF i-atualiza = 1 THEN
                    ASSIGN prazo-compra.data-entrega = da-atualiza.
                ELSE
                    IF FIRST-OF(prazo-compra.numero-ordem) THEN
                        ASSIGN i-dias-atualiza           = da-atualiza - prazo-compra.data-entrega
                               prazo-compra.data-entrega = da-atualiza.
                    ELSE
                        ASSIGN prazo-compra.data-entrega = prazo-compra.data-entrega 
                                                         + i-dias-atualiza.
            END.
        END.
            
    IF NOT VALID-HANDLE (h-boin082ca) THEN
        RUN inbo/boin082ca.p PERSISTENT SET h-boin082ca.
    IF AVAIL ITEM THEN
        RUN calcIndiceCotacaoItem IN h-boin082ca (INPUT  TABLE tt-cotacao-item,
                                                  INPUT  item.it-codigo,
                                                  OUTPUT de-indice).
    IF VALID-HANDLE (h-boin082ca) THEN DO:
        DELETE PROCEDURE h-boin082ca.
        ASSIGN h-boin082ca = ?.
    END.

    IF AVAIL item-fornec THEN DO:
        ASSIGN de-lote-minimo   = item-fornec.lote-minimo
               de-lote-mul-for  = item-fornec.lote-mul-for.
        IF AVAIL param-compra 
             AND param-compra.log-multi-unid-medid 
             AND AVAIL cotacao-item 
             AND item-fornec.unid-med-for <> cotacao-item.un THEN DO:
            
            /*Utiliza M£ltiplas Unidades de Medida
              Se unidade da item-fornec <> unidade da cotaá∆o, busca lote m°nimo e m£ltiplo conforme a unidade da cotaá∆o*/
                FOR FIRST item-fornec-umd FIELDS(fator-conver num-casa-dec lote-minimo lote-mul-for)
                    WHERE item-fornec-umd.it-codigo = item-fornec.it-codigo
                      AND item-fornec-umd.cod-emitente = item-fornec.cod-emitente
                      AND item-fornec-umd.unid-med-for = cotacao-item.un
                      AND item-fornec-umd.log-ativo NO-LOCK: END.
                IF AVAIL item-fornec-umd THEN
                    ASSIGN de-lote-minimo   = item-fornec-umd.lote-minimo
                           de-lote-mul-for  = item-fornec-umd.lote-mul-for.
        END.
    END.
    IF AVAIL ordem-compra THEN DO:
        IF l-altera-qtde THEN DO:
            IF AVAIL item AND item.tipo-contr <> 4 THEN DO:
                FOR EACH prazo-compra 
                   WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem EXCLUSIVE-LOCK:

                    ASSIGN de-quantidade = prazo-compra.quantidade * de-indice.
                     
                    IF AVAIL item-fornec-estab THEN DO:
                        IF de-quantidade < item-fornec-estab.lote-minimo THEN
                            ASSIGN de-quantidade = item-fornec-estab.lote-minimo
                                   de-quantidade = de-quantidade / item-fornec-estab.lote-mul-for.
                    END.
                    ELSE 
                        IF AVAIL item-fornec THEN DO:
                            IF de-quantidade < de-lote-minimo THEN DO:
                                ASSIGN de-quantidade = de-lote-minimo
                                       de-quantidade = de-quantidade / de-lote-mul-for.
                            END.
                        END.

                    IF de-quantidade - INTEGER(de-quantidade) < 0 THEN
                        ASSIGN de-quantidade = INTEGER(de-quantidade).
                    ELSE
                        IF de-quantidade - INTEGER(de-quantidade) > 0 THEN
                            ASSIGN de-quantidade = INTEGER(de-quantidade) + 1.
    
                    IF AVAIL item-fornec-estab THEN DO:
                        ASSIGN de-quantidade = de-quantidade * (item-fornec-estab.lote-mul-for).
                        IF de-quantidade = 0 THEN
                            ASSIGN de-quantidade = item-fornec-estab.lote-mul-for.
                    END.
                    ELSE 
                        IF AVAIL item-fornec THEN DO:
                            ASSIGN de-quantidade = de-quantidade * (de-lote-mul-for).
                            IF de-quantidade = 0 THEN
                                ASSIGN de-quantidade = de-lote-mul-for.
                        END.
                    
                    IF AVAIL item-fornec AND de-quantidade = 0 THEN
                        ASSIGN de-quantidade = de-lote-mul-for.
    
                    ASSIGN prazo-compra.qtd-do-forn  = prazo-compra.quantidade * de-indice
                           prazo-compra.quantidade   = de-quantidade / de-indice
                           prazo-compra.quant-saldo  = prazo-compra.quantidade
                           prazo-compra.qtd-do-forn  = de-quantidade
                           prazo-compra.qtd-sal-forn = prazo-compra.qtd-do-forn.
                END.
            END.
            ELSE DO:
                FOR EACH prazo-compra 
                   WHERE prazo-compra.numero-ordem   = ordem-compra.numero-ordem EXCLUSIVE-LOCK:

                    ASSIGN de-quantidade             = prazo-compra.quantidade
                           prazo-compra.qtd-do-forn  = prazo-compra.quantidade
                           prazo-compra.quant-saldo  = de-quantidade
                           prazo-compra.qtd-do-forn  = de-quantidade * de-indice
                           prazo-compra.qtd-sal-forn = de-quantidade * de-indice
                           prazo-compra.quantidade   = de-quantidade.
                END.
            END.
        END. /* l-altera-qtde */
        ELSE DO:
            FOR EACH prazo-compra 
               WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem EXCLUSIVE-LOCK:
                ASSIGN prazo-compra.quant-saldo  = prazo-compra.quantidade
                       prazo-compra.qtd-do-forn  = prazo-compra.quantidade * de-indice
                       prazo-compra.qtd-sal-forn = prazo-compra.qtd-do-forn.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaSituacaoOrdemCompra DBOProgram 
PROCEDURE atualizaSituacaoOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER i-ordem-compra AS INTEGER NO-UNDO.

    DEFINE VARIABLE l-tem-confirmada AS LOGICAL INITIAL NO NO-UNDO.
    DEFINE VARIABLE l-tem-recebida   AS LOGICAL INITIAL NO NO-UNDO.

    FOR EACH prazo-compra WHERE prazo-compra.numero-ordem = i-ordem-compra NO-LOCK:
        /* alteracao realizada quando eh chamada pela boiv028 - prazo-compra.situacao = 3 */
        IF prazo-compra.situacao = 2 OR prazo-compra.situacao = 3 THEN ASSIGN l-tem-confirmada = YES.
        IF prazo-compra.situacao = 6 THEN ASSIGN l-tem-recebida = YES.
    END.

    FIND FIRST ordem-compra 
         WHERE ordem-compra.numero-ordem = i-ordem-compra EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL ordem-compra THEN DO:
         ASSIGN ordem-compra.situacao = 6.                        /* recebida   */
         IF l-tem-confirmada THEN DO:                             /* confirmada */
            ASSIGN ordem-compra.situacao = 2.
         END.
         IF NOT l-tem-confirmada AND NOT l-tem-recebida THEN DO:  /* eliminadas */
            ASSIGN ordem-compra.situacao = 4.
         END.
         FIND FIRST pedido-compr 
              WHERE pedido-compr.num-pedido = ordem-compra.num-pedido EXCLUSIVE-LOCK NO-ERROR.
         IF  AVAIL pedido-compr 
         AND pedido-compr.situacao = 3 
         AND ordem-compra.situacao <> 4 THEN
             ASSIGN pedido-compr.situacao = 1.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaSituacaoProcessoImportacao DBOProgram 
PROCEDURE atualizaSituacaoProcessoImportacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    {cxbo/bocx140a.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE executeCreateManutOrdCompra DBOProgram 
PROCEDURE executeCreateManutOrdCompra :
/*------------------------------------------------------------------------------
  Purpose:
     Cria registro na tabela, atualiza m¢dulo de investimentos e quantidade da Ordem. 
  Parameters:  
     ipar1 : p-c-usuar-corren : Usu†rio atual do sistema
     opar2 : r-chave          : Rowid do registro criado
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-c-usuar-corren AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-r-chave        AS ROWID       NO-UNDO.

    DEFINE VARIABLE h-bocx150        AS HANDLE             NO-UNDO.
    DEFINE VARIABLE l-acesso-bocx150 AS LOGICAL INITIAL NO NO-UNDO.
    DEFINE VARIABLE l-acompanhamento AS LOGICAL INITIAL NO NO-UNDO.

    IF NOT VALID-HANDLE (h-boin356) THEN
        RUN inbo/boin356.p PERSISTENT SET h-boin356.
    
    RUN setDefaultsPrazoCompra IN THIS-PROCEDURE.
	
    RUN setConstraintNumOrdem IN h-boin356 (INPUT tt-ordem-compra.numero-ordem).
    RUN openQueryStatic IN h-boin356 (INPUT "byOrdem":U).
    RUN validateCreate  IN h-boin356 (INPUT  TABLE rowObject, OUTPUT TABLE RowErrors, OUTPUT r-chave).

    IF VALID-HANDLE (h-boin356) THEN DO:
        DELETE PROCEDURE h-boin356.
        ASSIGN h-boin356 = ?.
    END.

    IF r-chave <> ? THEN
        FIND FIRST prazo-compra 
             WHERE ROWID(prazo-compra) = r-chave EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL prazo-compra THEN DO:
       ASSIGN prazo-compra.situacao     = tt-ordem-compra.situacao
              prazo-compra.it-codigo    = tt-ordem-compra.it-codigo
              prazo-compra.data-alter   = ?
              prazo-compra.cod-alter    = NO
              prazo-compra.dec-1        = 0.

       RUN atualizaQtdeOrdemCompra. /* Atualiza Qtde da Ordem de compra automaticamente */
       RUN atualizaDataHoraUsuarioPrazoCompra (INPUT STRING(IF p-c-usuar-corren <> "":U THEN p-c-usuar-corren
                                                                                        ELSE c-seg-usuario)).
       ASSIGN prazo-compra.quantid-orig = prazo-compra.quantidade
              prazo-compra.data-orig    = prazo-compra.data-entrega
              prazo-compra.quant-saldo  = prazo-compra.quantidade.

       /* Inclus∆o de Parcelas - cc0301b chamado pelo cc0308 */
       FOR FIRST ordem-compra FIELDS(numero-ordem num-pedido num-ord-inv) 
           WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem NO-LOCK: END.
       
       IF AVAIL ordem-compra THEN
           FOR FIRST pedido-compr FIELDS(num-pedido situacao) 
               WHERE pedido-compr.num-pedido   = ordem-compra.num-pedido NO-LOCK: END.

           IF AVAIL pedido-compr AND pedido-compr.situacao = 1 /* Impresso */ THEN 
               ASSIGN l-cc0308 = YES.
           ELSE
               ASSIGN l-cc0308 = NO.

       IF l-cc0308 THEN
           RUN atualizaAltPedPrazoCompra.

       /****************************************************************
       ** Integracao Compras - Importacao x MRP                       **
       ** Verifica se a ordem de compra esta vinculada a um processo  **
       ** de importacao com acompanhamento. Caso estiver, a parcela   **
       ** em questao sera setada para nao ser reprogramada pelo MRP   **
       ****************************************************************/
       IF NOT AVAIL param-global THEN
           FIND FIRST param-global NO-LOCK NO-ERROR.
       IF CONNECTED("mgcex":U) AND (AVAIL param-global AND param-global.modulo-07) THEN DO:
           {inbo/boin356vl.i01}
       END.
       
       /* ---------- Moduto Investimento -----------*/
       IF param-global.modulo-in
       AND AVAIL ordem-compra 
       AND ordem-compra.num-ord-inv <> 0 THEN DO:
           IF NOT VALID-HANDLE (h-boiv037) THEN
               RUN ivbo/boiv037.p PERSISTENT SET h-boiv037.
     
           RUN CreateProgEntr IN h-boiv037 (INPUT ROWID(prazo-compra), INPUT-OUTPUT TABLE RowErrors).

           IF VALID-HANDLE (h-boiv037) THEN DO:
               DELETE PROCEDURE h-boiv037.
               ASSIGN h-boiv037 = ?.
           END.
       END.
    END.

    ASSIGN p-r-chave = r-chave.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE executeUpdateManutOrdCompra DBOProgram 
PROCEDURE executeUpdateManutOrdCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prChave AS ROWID NO-UNDO.
    
    DEFINE VARIABLE l-alteracao-qtd AS LOGICAL                      NO-UNDO.
    DEFINE VARIABLE i-cont          AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE c-mensagem      AS CHARACTER FORMAT "x(200)":U  NO-UNDO.
     
    IF prChave <> ? THEN
        ASSIGN rChave = prChave.

    FIND FIRST {&TABLENAME} 
         WHERE ROWID({&TABLENAME}) = rChave NO-LOCK NO-WAIT NO-ERROR.
          
    IF NOT VALID-HANDLE (h-boin356) THEN
        RUN inbo/boin356.p PERSISTENT SET h-boin356.
    
    RUN setConstraintNumOrdem IN h-boin356 (INPUT RowObject.numero-ordem).
    RUN openQueryStatic       IN h-boin356 (INPUT "byOrdem":U).

    ASSIGN l-alteracao-qtd = rowobject.quantidade <> {&TABLENAME}.quantidade.

    RUN setDefaultsPrazoCompra IN THIS-PROCEDURE.
	  
    RUN validateUpdate IN h-boin356 (INPUT  TABLE rowObject,
                                     INPUT  rChave,
                                     OUTPUT TABLE RowErrors).

    IF VALID-HANDLE (h-boin356) THEN DO:
        DELETE PROCEDURE h-boin356.
        ASSIGN h-boin356 = ?.
    END.

    FIND FIRST {&TABLENAME} 
         WHERE ROWID({&TABLENAME}) = rChave EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
    
    FIND FIRST ordem-compra 
         WHERE ordem-compra.numero-ordem = rowobject.numero-ordem NO-LOCK NO-ERROR.
    FIND FIRST emitente 
         WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.
    
    IF l-alteracao-qtd THEN DO:
        
        IF  param-global.modulo-07 AND emitente.natureza > 2 THEN DO:
            
            RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.
            RUN procuraEmbarqueCompras IN h-bocx225 (INPUT  pedido-compr.num-pedido,
                                                     INPUT  ordem-compra.numero-ordem,
                                                     INPUT  {&TABLENAME}.parcela,
                                                     OUTPUT TABLE tt-embarque).
            DELETE PROCEDURE h-bocx225.

            FOR EACH tt-embarque NO-LOCK:
                ASSIGN i-cont = i-cont + 1.
                IF i-cont = 1 THEN
                    ASSIGN c-mensagem = tt-embarque.embarque.
                ELSE
                    ASSIGN c-mensagem = c-mensagem + ', ':U + tt-embarque.embarque.
            END.
            IF i-cont >= 1 THEN DO:
                {utp/ut-liter.i "Material_em_TrÉnsito" *}
                ASSIGN c-lbl-trad = c-mensagem + '~~~~':U + TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="28558"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="INFORMATION":U
                                            &ErrorParameters= "c-lbl-trad"}  
            END.
        END.
    END.

    ASSIGN prazo-compra.data-alter   = TODAY
           prazo-compra.cod-alter    = YES.

    RUN atualizaQtdeOrdemCompra. /* Atualiza Qtde da Ordem de compra automaticamente */
    RUN atualizaDataHoraUsuarioPrazoCompra (INPUT c-seg-usuario).
    RUN validateUpdateBusinessLogic (INPUT YES).

    /* O ALT-PED da Modificaá∆o da Parcela Ç gerado s¢ AO SALVAR A TRANSAÄ«O */
    IF param-global.modulo-in AND ordem-compra.num-ord-inv <> 0 THEN DO:

        IF NOT VALID-HANDLE (h-boiv037) THEN
            RUN ivbo/boiv037.p PERSISTENT SET h-boiv037.
    
        RUN UpdateProgEntr IN h-boiv037 (INPUT ROWID(prazo-compra), 
                                         INPUT-OUTPUT TABLE RowErrors).
        IF VALID-HANDLE (h-boiv037) THEN DO:
            DELETE PROCEDURE h-boiv037.
            ASSIGN h-boiv037 = ?.
        END.
    END.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportaAltCliPed DBOProgram 
PROCEDURE exportaAltCliPed :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAMETER p-ordem   LIKE tt-buffer-parcelas.numero-ordem.
    DEFINE INPUT        PARAMETER p-parcela LIKE tt-buffer-parcelas.parcela.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-buffer-parcelas.
    DEFINE INPUT        PARAMETER TABLE FOR tt-parcelas-aux.
    
    DEFINE BUFFER b-buffer-parcelas FOR tt-buffer-parcelas.
    
    FIND FIRST tt-buffer-parcelas 
         WHERE tt-buffer-parcelas.numero-ordem = p-ordem 
           AND tt-buffer-parcelas.parcela      = p-parcela NO-ERROR.
       
    FIND FIRST tt-parcelas-aux
         WHERE tt-parcelas-aux.numero-ordem = p-ordem 
           AND tt-parcelas-aux.parcela = p-parcela  NO-ERROR.
    
    IF AVAIL tt-parcelas-aux AND AVAIL tt-buffer-parcelas THEN DO:
        IF ((tt-parcelas-aux.nome-abrev   <> tt-buffer-parcelas.nome-abrev) 
          OR(tt-parcelas-aux.pedido-clien <> tt-buffer-parcelas.pedido-clien) 
          OR(tt-parcelas-aux.nr-sequencia <> tt-buffer-parcelas.nr-sequencia)) THEN DO:
            
            FOR EACH b-buffer-parcelas
               WHERE b-buffer-parcelas.numero-ordem = tt-buffer-parcelas.numero-ordem 
                 AND b-buffer-parcelas.parcela     <> tt-buffer-parcelas.parcela  EXCLUSIVE-LOCK:
               
               IF  b-buffer-parcelas.nome-abrev   = tt-parcelas-aux.nome-abrev 
               AND b-buffer-parcelas.pedido-clien = tt-parcelas-aux.pedido-clien 
               AND b-buffer-parcelas.nr-sequencia = tt-parcelas-aux.nr-sequencia THEN DO:
                   
                   ASSIGN b-buffer-parcelas.nome-abrev   = tt-buffer-parcelas.nome-abrev
                          b-buffer-parcelas.pedido-clien = tt-buffer-parcelas.pedido-clien
                          b-buffer-parcelas.nr-sequencia = tt-buffer-parcelas.nr-sequencia.          
               END.
            END.
            FIND FIRST tt-buffer-parcelas 
                 WHERE tt-buffer-parcelas.numero-ordem = p-ordem 
                   AND tt-buffer-parcelas.parcela = p-parcela NO-ERROR.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportaAltCliPedOrdem DBOProgram 
PROCEDURE exportaAltCliPedOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAMETER p-ordem   LIKE tt-buffer-parcelas.numero-ordem.
    DEFINE INPUT        PARAMETER p-parcela LIKE tt-buffer-parcelas.parcela.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-buffer-parcelas.
    DEFINE INPUT        PARAMETER TABLE FOR tt-parcelas-aux.
    
    DEFINE BUFFER b-buffer-parcelas FOR tt-buffer-parcelas.
    
    FIND FIRST tt-buffer-parcelas 
         WHERE tt-buffer-parcelas.numero-ordem = p-ordem 
           AND tt-buffer-parcelas.parcela      = p-parcela NO-ERROR.
       
    FIND FIRST tt-parcelas-aux
         WHERE tt-parcelas-aux.numero-ordem = p-ordem 
           AND tt-parcelas-aux.parcela      = p-parcela  NO-ERROR.
    
    IF AVAIL tt-parcelas-aux AND AVAIL tt-buffer-parcelas THEN DO:
        
        IF ((tt-parcelas-aux.nome-abrev   <> tt-buffer-parcelas.nome-abrev) 
          OR(tt-parcelas-aux.pedido-clien <> tt-buffer-parcelas.pedido-clien) 
          OR(tt-parcelas-aux.nr-sequencia <> tt-buffer-parcelas.nr-sequencia)) THEN DO:

            FOR EACH prazo-compra
               WHERE prazo-compra.numero-ordem = tt-buffer-parcelas.numero-ordem 
                 AND prazo-compra.parcela     <> tt-buffer-parcelas.parcela  EXCLUSIVE-LOCK:

          
               IF prazo-compra.nome-abrev   <> tt-parcelas-aux.nome-abrev   
               OR prazo-compra.pedido-clien <> tt-parcelas-aux.pedido-clien 
               OR prazo-compra.nr-sequencia <> tt-parcelas-aux.nr-sequencia THEN DO:
                   
                   ASSIGN prazo-compra.nome-abrev   = tt-parcelas-aux.nome-abrev
                          prazo-compra.pedido-clien = tt-parcelas-aux.pedido-clien
                          prazo-compra.nr-sequencia = tt-parcelas-aux.nr-sequencia.          
               END.
            END.
            FIND FIRST tt-buffer-parcelas 
                 WHERE tt-buffer-parcelas.numero-ordem = p-ordem 
                   AND tt-buffer-parcelas.parcela      = p-parcela NO-ERROR.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportaAltCliPedWeb DBOProgram 
PROCEDURE exportaAltCliPedWeb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAMETER p-ordem   LIKE tt-buffer-parcelas.numero-ordem.
    DEFINE INPUT        PARAMETER p-parcela LIKE tt-buffer-parcelas.parcela.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-buffer-parcelas.
    DEFINE INPUT        PARAMETER TABLE FOR tt-parcelas-aux.
    
    DEFINE BUFFER b-buffer-parcelas FOR tt-buffer-parcelas.
    
    FIND FIRST tt-buffer-parcelas 
         WHERE tt-buffer-parcelas.numero-ordem = p-ordem 
           AND tt-buffer-parcelas.parcela      = p-parcela NO-ERROR.
       
    FIND FIRST tt-parcelas-aux
         WHERE tt-parcelas-aux.numero-ordem = p-ordem 
           AND tt-parcelas-aux.parcela      = p-parcela  NO-ERROR.
    
    IF AVAIL tt-parcelas-aux AND AVAIL tt-buffer-parcelas THEN DO:

        IF ((tt-parcelas-aux.nome-abrev   <> tt-buffer-parcelas.nome-abrev) 
          OR(tt-parcelas-aux.pedido-clien <> tt-buffer-parcelas.pedido-clien) 
          OR(tt-parcelas-aux.nr-sequencia <> tt-buffer-parcelas.nr-sequencia)) THEN DO:
            
            FOR EACH b-prazo-compra
               WHERE b-prazo-compra.numero-ordem = tt-buffer-parcelas.numero-ordem 
                 AND b-prazo-compra.parcela     <> tt-buffer-parcelas.parcela  EXCLUSIVE-LOCK:
               
               IF  b-prazo-compra.nome-abrev   = tt-parcelas-aux.nome-abrev 
               AND b-prazo-compra.pedido-clien = tt-parcelas-aux.pedido-clien 
               AND b-prazo-compra.nr-sequencia = tt-parcelas-aux.nr-sequencia THEN DO:
                  
                  ASSIGN b-prazo-compra.nome-abrev   = tt-buffer-parcelas.nome-abrev
                         b-prazo-compra.pedido-clien = tt-buffer-parcelas.pedido-clien
                         b-prazo-compra.nr-sequencia = tt-buffer-parcelas.nr-sequencia.          
               END.
            END.
            FIND FIRST tt-buffer-parcelas 
                 WHERE tt-buffer-parcelas.numero-ordem = p-ordem 
                   AND tt-buffer-parcelas.parcela      = p-parcela NO-ERROR.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getUnDefault DBOProgram 
PROCEDURE getUnDefault :
/*------------------------------------------------------------------------------
  Purpose:     
    L¢gica implementada a pedido da Grendene - FO 763.370 
    Para ordens/parcelas em que a unidade n∆o foi informada em tela:
    - Se ParÉmetros de Estoque com UN Default Item: Dever† gravar internamente a unidade do item.
    - Se ParÉmetros de Estoque sem UN Default Item: Dever† consistir n∆o permitindo a gravaá∆o.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT-OUTPUT PARAMETER pc-undefault AS CHARACTER NO-UNDO.

    IF TRIM(pc-undefault) = "":U THEN DO:
        FIND FIRST param-mat NO-LOCK NO-ERROR.

        IF  AVAIL param-mat AND param-mat.ind-sit-un = 2 /* Default Item */ THEN DO:
            IF  NOT AVAIL item THEN DO:
                FOR FIRST  item  FIELDS (un)
                    WHERE  item.it-codigo = tt-ordem-compra.it-codigo NO-LOCK:
                    ASSIGN pc-undefault = item.un.
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getUnFornecedorOrdem DBOProgram 
PROCEDURE getUnFornecedorOrdem :
/*------------------------------------------------------------------------------
  Purpose:     Calcula o n£mero da pr¢xima parcela a ser inclu°da
  Parameters:  
               ipar1 : piNumeroOrdem : N£mero da Ordem
               opar4 : pcUnForn      : Unidade de Medida do Fornecedor (cotaá∆o ou item-fornec)
  Notes:       
------------------------------------------------------------------------------*/
    /* DEVE SER EXECUTADO ANTES O MêTODO SETRECORD */
    DEFINE INPUT  PARAMETER piNumeroOrdem AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcUnForn      AS CHARACTER NO-UNDO.

    FOR FIRST ordem-compra FIELDS(numero-ordem cod-emitente it-codigo) 
        WHERE ordem-compra.numero-ordem = piNumeroOrdem NO-LOCK: 
        
        FOR FIRST cotacao-item FIELDS(numero-ordem cod-emitente it-codigo cot-aprovada un) 
            WHERE cotacao-item.numero-ordem = piNumeroOrdem             
              AND cotacao-item.cod-emitente = ordem-compra.cod-emitente 
              AND cotacao-item.it-codigo    = ordem-compra.it-codigo    
              AND cotacao-item.cot-aprovada = YES NO-LOCK: END.

        IF AVAIL cotacao-item THEN 
            ASSIGN pcUnForn = cotacao-item.un.
        ELSE DO:
            FOR FIRST item-fornec FIELDS(it-codigo cod-emitente ativo unid-med-for)  
                WHERE item-fornec.it-codigo    = ordem-compra.it-codigo    
                  AND item-fornec.cod-emitente = ordem-compra.cod-emitente 
                  AND item-fornec.ativo          NO-LOCK: END.
           IF AVAIL item-fornec THEN 
               ASSIGN pcUnForn = item-fornec.unid-med-for.
           ELSE
               ASSIGN pcUnForn = ?.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inputTable DBOProgram 
PROCEDURE inputTable :
/*------------------------------------------------------------------------------
  Purpose:
     Permite o recebimento da tabela de dados (Prazo-Compra)  
  Parameters:
     ipar1 : table for rowObject : Tabela de Dados
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM TABLE FOR rowObject.
    
    FIND FIRST rowObject NO-ERROR. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inputTableOrdemCompra DBOProgram 
PROCEDURE inputTableOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose
     Permite o recebimento da tabela de dados (Ordem-Compra)
  Parameters:
    ipar1 : table for tt-ordem-compra : Tabela de dados contendo uma ordem de compra
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-ordem-compra.
    
    FIND FIRST tt-ordem-compra NO-ERROR.
  
    RETURN "OK":U.
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
    OPEN QUERY {&QueryName} FOR EACH prazo-compra NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE passaUnFornec DBOProgram 
PROCEDURE passaUnFornec :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters: 
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-un AS CHARACTER FORMAT "X(25)":U NO-UNDO.

    ASSIGN cUnFornec = p-un.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-indice DBOProgram 
PROCEDURE pi-indice :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  precisa que a ordem de compra esteja posicionada.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-it-codigo AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-emit  AS INTEGER      NO-UNDO.
    DEFINE INPUT  PARAMETER p-num-ordem AS INTEGER      NO-UNDO.  /* usado quando a procedure Ç chamada por outra BO */
    DEFINE OUTPUT PARAMETER pde-indice  AS DECIMAL      NO-UNDO.  /* usado quando a procedure Ç chamada por outra BO */
    
    DEFINE VARIABLE c-un          AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-unid-fornec AS CHARACTER NO-UNDO.

    FOR FIRST item 
        WHERE item.it-codigo = p-it-codigo NO-LOCK: END.
    
    ASSIGN de-indice     = 1
           c-un          = ?
           c-unid-fornec = ?.

    FOR FIRST ordem-compra FIELDS(numero-ordem data-cotacao) 
        WHERE ordem-compra.numero-ordem = p-num-ordem NO-LOCK: END.
    
    /* Se encontrar cotacao-item busca fator convers∆o pela boin082ca, sen∆o procura no 
       relacionamento item X fornec, ou retorna 1. Neste caso a convers∆o Ç apenas para 
       voltar valores para a tela,  pois a convers∆o real ser† feita depois.  */

    IF AVAIL ordem-compra THEN
       FOR FIRST cotacao-item 
           WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
             AND cotacao-item.cod-emitente = p-cod-emit
             AND cotacao-item.data-cotacao = ordem-compra.data-cotacao NO-LOCK: END.
        /* Segunda busca, pois a data de cotaá∆o da ordem estava sendo gravada errada */         
        IF NOT AVAIL cotacao-item THEN
           FOR FIRST cotacao-item
               WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                 AND cotacao-item.cod-emitente = p-cod-emit
                 AND cotacao-item.cot-aprovada = YES NO-LOCK: END.
             
    IF CAN-FIND(FIRST prazo-compra WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem) 
    AND AVAIL ordem-compra 
    AND AVAIL cotacao-item THEN DO:
        
        EMPTY TEMP-TABLE tt-cotacao-item.
        
        CREATE tt-cotacao-item.
        BUFFER-COPY cotacao-item TO tt-cotacao-item.

        IF NOT VALID-HANDLE (h-boin082ca) THEN
            RUN inbo/boin082ca.p PERSISTENT SET h-boin082ca.

        IF  AVAIL item THEN DO:
            RUN calcIndiceCotacaoItem IN h-boin082ca (INPUT  TABLE tt-cotacao-item,
                                                      INPUT  item.it-codigo,
                                                      OUTPUT de-indice).
        END.

        IF VALID-HANDLE (h-boin082ca) THEN DO:
            DELETE PROCEDURE h-boin082ca.
            ASSIGN h-boin082ca = ?.
        END.
    END.
    ELSE DO:

        IF AVAIL cotacao-item THEN
            ASSIGN c-unid-fornec = cotacao-item.un.
        ELSE 
            IF cUnFornec <> "":U THEN
                ASSIGN c-unid-fornec = cUnFornec.

        IF AVAIL ordem-compra THEN
            FOR FIRST RowObject FIELDS(numero-ordem un) 
                WHERE RowObject.numero-ordem = ordem-compra.numero-ordem NO-LOCK: 

                ASSIGN c-un = RowObject.un.
            END.
        IF AVAIL item THEN DO:
            FIND CURRENT item-fornec NO-LOCK NO-ERROR.
            {cdp/cd9950.i c-un c-unid-fornec p-cod-emit}
        END.
    END.

    ASSIGN pde-indice = de-indice.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-lote-minimo-multiplo DBOProgram 
PROCEDURE pi-valida-lote-minimo-multiplo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-l-lote AS LOGICAL  NO-UNDO.

    DEFINE VARIABLE i-lote-mult         LIKE item.lote-multipl  NO-UNDO.
    DEFINE VARIABLE i-lote-min          LIKE item.lote-minimo   NO-UNDO.
    DEFINE VARIABLE l-item-fornec-estab AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE l-item-fornec       AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE de-nr-lotes         AS DECIMAL DECIMALS 4   NO-UNDO.

    DEFINE BUFFER b-cotacao-item FOR cotacao-item.

    IF AVAIL ITEM THEN
       ASSIGN i-lote-mult = item.lote-multipl
              i-lote-min  = item.lote-minimo.
    ELSE
       RETURN "OK":U.              
           
    IF AVAIL item-uni-estab THEN
       ASSIGN i-lote-mult = item-uni-estab.lote-multipl
              i-lote-min  = item-uni-estab.lote-minimo.

    FIND FIRST param-compra NO-LOCK NO-ERROR.
         
            /* Confirmada */                /* Eliminada */                  /* Recebida */
    IF (tt-ordem-compra.situacao = 2 OR tt-ordem-compra.situacao = 4 OR tt-ordem-compra.situacao = 6) OR (tt-ordem-compra.num-pedido <> 0) THEN DO:
        
        FOR FIRST item-fornec FIELDS(it-codigo cod-emitente ativo lote-minimo lote-mul-for unid-med-for)  
            WHERE item-fornec.it-codigo    = item.it-codigo 
              AND item-fornec.cod-emitente = tt-ordem-compra.cod-emitente NO-LOCK: END.
        
        IF AVAIL item-fornec THEN DO:
            ASSIGN i-lote-mult   = item-fornec.lote-mul-for
                   i-lote-min    = item-fornec.lote-minimo
                   l-item-fornec = YES.
            
            IF AVAIL param-compra AND param-compra.log-multi-unid-medid THEN DO:
                
                FOR FIRST b-cotacao-item FIELDS (un)
                    WHERE b-cotacao-item.numero-ordem = tt-ordem-compra.numero-ordem
                      AND b-cotacao-item.cod-emitente = item-fornec.cod-emitente
                      AND b-cotacao-item.it-codigo    = item-fornec.it-codigo NO-LOCK: END.
            
                IF AVAIL b-cotacao-item AND item-fornec.unid-med-for <> b-cotacao-item.un THEN DO:
                    /*Utiliza M£ltiplas Unidades de Medida
                    Se unidade da item-fornec <> unidade da cotaá∆o, busca fator de convers∆o conforme a unidade da cotaá∆o*/
                    FOR FIRST item-fornec-umd FIELDS(fator-conver num-casa-dec lote-minimo lote-mul-for)
                        WHERE item-fornec-umd.it-codigo = item-fornec.it-codigo
                          AND item-fornec-umd.cod-emitente = item-fornec.cod-emitente
                          AND item-fornec-umd.unid-med-for = b-cotacao-item.un
                          AND item-fornec-umd.log-ativo NO-LOCK: END.
                    
                    IF AVAIL item-fornec-umd THEN
                         ASSIGN i-lote-min   = item-fornec-umd.lote-minimo
                                i-lote-mult  = item-fornec-umd.lote-mul-for.
                END.
            END.
        END.
        FOR FIRST item-fornec-estab FIELDS(it-codigo cod-emitente cod-estabel ativo lote-minimo lote-mul-for)
            WHERE item-fornec-estab.it-codigo    = item.it-codigo 
              AND item-fornec-estab.cod-estabel  = tt-ordem-compra.cod-estabel 
              AND item-fornec-estab.cod-emitente = tt-ordem-compra.cod-emitente NO-LOCK: 
            
            ASSIGN i-lote-mult         = item-fornec-estab.lote-mul-for
                   i-lote-min          = item-fornec-estab.lote-minimo
                   l-item-fornec-estab = YES.
        END.
    END.
        
    /* Lote M£ltiplo */
    /* Validaá∆o contra item X fornecedor */
    IF l-item-fornec-estab OR l-item-fornec THEN DO:
        
        IF i-lote-mult <> 0 THEN
            ASSIGN de-nr-lotes = (rowObject.quantidade * de-indice) / i-lote-mult.
        
        IF de-nr-lotes - TRUNCATE(de-nr-lotes,0) <> 0 THEN DO:

           IF NOT p-l-lote THEN DO: /* ParÉmetro da tela - cc0300b4 */
              {method/svc/errors/inserr.i &ErrorNumber="27642"
                                          &ErrorType="EMS":U
                                          &ErrorSubType="ERROR":U
                                          &ErrorParameters="trim(string(rowObject.quantidade,'>>>>,>>9.9999')) + '~~~~' +
                                                            TRIM(STRING(i-lote-mult / de-indice,'>>>>,>>9.9999'))"}
           END.
           ELSE DO:
              {method/svc/errors/inserr.i &ErrorNumber="27641"
                                          &ErrorType="EMS":U
                                          &ErrorSubType="ERROR":U
                                          &ErrorParameters="trim(string(rowObject.quantidade,'>>>>,>>9.9999')) + '~~~~' +
                                                            TRIM(STRING(i-lote-mult / de-indice,'>>>>,>>9.9999'))"}
           END.
        END.
    END.
    ELSE DO:
        IF i-lote-mult <> 0 AND ((INTEGER(rowObject.quantidade / i-lote-mult)) * i-lote-mult) <> rowObject.quantidade THEN DO:
            
            IF NOT p-l-lote THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="27644"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="trim(string(rowObject.quantidade,'>>>>,>>9.9999')) + '~~~~' +
                                                              TRIM(STRING(i-lote-mult,'>>>>,>>9.9999'))"}
            END.
            ELSE DO:
               {method/svc/errors/inserr.i &ErrorNumber="27643"
                                           &ErrorType="EMS":U
                                           &ErrorSubType="ERROR":U
                                           &ErrorParameters="trim(string(rowObject.quantidade,'>>>>,>>9.9999')) + '~~~~' +
                                                             TRIM(STRING(i-lote-mult,'>>>>,>>9.9999'))"}
            END.
        END.
    END.
    
    /* Lote m°nimo */   
    /* Validaá∆o contra item X fornecedor */
    IF (NOT AVAIL pedido-compr) OR (AVAIL pedido-compr AND ((pedido-compr.situacao <> 1) OR (pedido-compr.situacao = 1 AND cParamManutOrd = "add":U))) THEN DO:
        
        IF l-item-fornec-estab OR l-item-fornec THEN DO:

            IF (de-tot-quant-parc) < i-lote-min THEN DO:
                
                IF NOT l-parc-quant-lote-min THEN DO: /* ParÉmetro da tela - cc0300b4 */
                    {method/svc/errors/inserr.i &ErrorNumber="27646"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="trim(string(de-tot-quant-parc,'>>>>,>>9.9999')) + '~~~~' +
                                                                  TRIM(STRING(i-lote-min / de-indice,'>>>>,>>9.9999'))"}
               END.
               ELSE DO:
                   {method/svc/errors/inserr.i &ErrorNumber="27645"
                                               &ErrorType="EMS":U
                                               &ErrorSubType="ERROR":U
                                               &ErrorParameters="trim(string(de-tot-quant-parc,'>>>>,>>9.9999')) + '~~~~' +
                                                                 TRIM(STRING(i-lote-min / de-indice,'>>>>,>>9.9999'))"}
               END.
            END.
        END.
        ELSE DO:
            
            IF de-tot-quant-parc < i-lote-min THEN DO:

                IF NOT l-parc-quant-lote-min THEN DO: /* ParÉmetro da tela - cc0300b4 */
                    {method/svc/errors/inserr.i &ErrorNumber="27648"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="trim(string(de-tot-quant-parc,'>>>>,>>9.9999')) + '~~~~' +
                                                                  TRIM(STRING(i-lote-min,'>>>>,>>9.9999'))"}
               END.
               ELSE DO:
                   {method/svc/errors/inserr.i &ErrorNumber="27647"
                                               &ErrorType="EMS":U
                                               &ErrorSubType="ERROR":U
                                               &ErrorParameters="trim(string(de-tot-quant-parc,'>>>>,>>9.9999')) + '~~~~' +
                                                                 TRIM(STRING(i-lote-min,'>>>>,>>9.9999'))"}
               END.
            END.
        END.
    END.
    
    RETURN "OK":U.        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RecalculoPlanejNetchange DBOProgram 
PROCEDURE RecalculoPlanejNetchange :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters: 
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-ordem-compra.
    DEFINE INPUT PARAMETER p-pedidoemerg        AS LOGICAL  NO-UNDO.
    DEFINE INPUT PARAMETER p-qtd-sal-fornec-ant AS DECIMAL  NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-entrega-ant-ant AS DATE     NO-UNDO.
    DEFINE INPUT PARAMETER p-qtd-sal-fornec     AS DECIMAL  NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-entrega         AS DATE     NO-UNDO.

    FIND FIRST tt-ordem-compra NO-ERROR.

    IF  (param-global.modulo-pl OR param-global.modulo-pi) 
    AND AVAIL tt-ordem-compra 
    AND p-pedidoemerg 
    AND (p-qtd-sal-fornec-ant <> p-qtd-sal-fornec OR p-dt-entrega-ant-ant <> p-dt-entrega) THEN DO:
        
        RUN cdp/cd7000.p (INPUT 0, tt-ordem-compra.it-codigo, tt-ordem-compra.cod-estabel). /* usado p/planejamento */
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaParamType DBOProgram 
PROCEDURE setaParamType :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-Type AS CHARACTER NO-UNDO.
    
    ASSIGN cParamType = pc-Type.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsPrazoCompra DBOProgram 
PROCEDURE setDefaultsPrazoCompra :
/*------------------------------------------------------------------------------
  Purpose: Setar os valores default para os campos abaixo. 
  Parameters: 
  Notes: Ser† executada a partir da include AXRSU002UPSERT.I, na parte de 
         atualizaá∆o de parcelas
------------------------------------------------------------------------------*/
    IF RowObject.cod-refer      = ? THEN ASSIGN RowObject.cod-refer      = "":U.

    IF RowObject.concentracao   = ? THEN ASSIGN RowObject.concentracao   = 0.
    
    IF RowObject.qtd-rec-forn   = ? THEN ASSIGN RowObject.qtd-rec-forn   = 0.

    IF RowObject.qtd-rej-forn   = ? THEN ASSIGN RowObject.qtd-rej-forn   = 0.

    IF RowObject.qtd-sal-forn   = ? THEN ASSIGN RowObject.qtd-sal-forn   = 0.

    IF RowObject.qtd-aloc-forn  = ? THEN ASSIGN RowObject.qtd-aloc-forn  = 0.

    IF RowObject.qtd-do-forn    = ? THEN ASSIGN RowObject.qtd-do-forn    = 0.

    IF RowObject.qtd-a-ped-forn = ? THEN ASSIGN RowObject.qtd-a-ped-forn = 0.

    IF RowObject.quant-a-ped    = ? THEN ASSIGN RowObject.quant-a-ped    = 0.

    IF RowObject.quant-alocada  = ? THEN ASSIGN RowObject.quant-alocada  = 0.

    IF RowObject.quant-receb    = ? THEN ASSIGN RowObject.quant-receb    = 0.

    IF RowObject.quant-rejeit   = ? THEN ASSIGN RowObject.quant-rejeit   = 0.

    IF RowObject.quant-saldo    = ? THEN ASSIGN RowObject.quant-saldo    = 0.

    IF RowObject.quantid-orig   = ? THEN ASSIGN RowObject.quantid-orig   = 0.

    IF RowObject.quantidade     = ? THEN ASSIGN RowObject.quantidade     = 0.

    IF RowObject.rendimento    = ?  THEN ASSIGN RowObject.rendimento     = 0.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setLSegcc0300 DBOProgram 
PROCEDURE setLSegcc0300 :
/*------------------------------------------------------------------------------
  Purpose: Modifica o status da vari†vel l-seg-cc0300. Indica se o usu†rio ser† validado
           ou n∆o em relaá∆o a sua permiss∆o para inserir, alterar ou remover pedidos na
           tela cc0300.
  Parameters: 
  Notes: PARA SER EXECUTADA SOMENTE DO PROGRAMA CC0300 OU DAS TELAS FILHO 
         PARA CONTROLAR SEGURANÄA POR USUµRIO PARA AÄÂES(INSERÄ«O, ALTERAÄ«O OU REMOÄ«O) 
         SOBRE PEDIDO DE COMPRA 
------------------------------------------------------------------------------*/
    {cdp/cd9731.i5}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaAtivacaoCamposPrazoCompra DBOProgram 
PROCEDURE validaAtivacaoCamposPrazoCompra :
/*------------------------------------------------------------------------------
  Purpose:
     Valida a ativaá∆o de campos na tela de parcelas (prazo-compra) de acordo com regras de neg¢cio.  
  Parameters:  <none>
     ipar1 : p-c-it-codigo      : C¢digo do item da ordem
     opar2 : p-l-enbl-cod-refer : Ativa COD-REFER?
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-c-it-codigo      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-l-enbl-cod-refer AS LOGICAL   NO-UNDO.

    FOR FIRST item FIELDS(it-codigo tipo-contr tipo-con-est) 
        WHERE item.it-codigo = p-c-it-codigo NO-LOCK: END.
    
    ASSIGN p-l-enbl-cod-refer = IF AVAIL ITEM THEN (item.tipo-con-est = 4) ELSE NO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaAtivacaoCamposPrazoCompraCriacao DBOProgram 
PROCEDURE validaAtivacaoCamposPrazoCompraCriacao :
/*------------------------------------------------------------------------------
  Purpose:     
     Valida a ativaá∆o de campos na tela de criaá∆o de parcelas (prazo-compra) de acordo com regras de neg¢cio.
  Parameters:  <none>
     ipar1 : p-i-numero-ordem : N£mero da ordem
     opar2 : p-l-enbl-un      : Ativa UN?
  Notes:       
------------------------------------------------------------------------------*/
    /* DEVE SER EXECUTADO ANTES O MêTODO SETRECORD */
    DEFINE INPUT  PARAMETER p-i-numero-ordem    as INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-l-enbl-un         as LOGICAL   NO-UNDO.

    FIND LAST rowObject 
        WHERE rowObject.numero-ordem = p-i-numero-ordem NO-LOCK NO-ERROR.
    
    ASSIGN p-l-enbl-un = NOT (AVAIL rowObject AND rowObject.parcela <> 99).
 
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaEliminacaoPrazoCompra DBOProgram 
PROCEDURE validaEliminacaoPrazoCompra :
/*------------------------------------------------------------------------------
  Purpose:     
     Retorna erro ao usu†rio se o pedido possui contrato de fornecimento
     o que impossibilita a sua eliminaá∆o.
     E retorna uma informaá∆o se Pedido de Compra informado possui Ordem de Compra
     recebida ou a Ordem de Compra que est† para ser eliminada possui parcela recebida.
  Parameters:
     ipar1 : r-pedido-compr : rowid corrente da tabela pedido-compr
     ipar2 : r-row-ordem    : rowid corrente da tabela ordem-compra
     ipar3 : r-prazo-compra : rowid corrente da tabela prazo-compra
     opar4 : i-mensagem     : n£mero da mensagem
     opar5 : c-habilita     : habilita quando a situaá∆o Ç diferente de 4
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER r-pedido-compr AS ROWID      NO-UNDO.
    DEFINE INPUT  PARAMETER r-row-ordem    AS ROWID      NO-UNDO.
    DEFINE INPUT  PARAMETER r-prazo-comp   AS ROWID      NO-UNDO.
    DEFINE OUTPUT PARAMETER i-mensagem     AS INTEGER    NO-UNDO.
    DEFINE OUTPUT PARAMETER c-habilita     AS CHARACTER  NO-UNDO.

    FOR FIRST prazo-compra FIELDS(situacao) 
        WHERE ROWID(prazo-compra) = r-prazo-comp NO-LOCK: END.

    FOR FIRST pedido-compr FIELDS(nr-contrato)
        WHERE ROWID(pedido-compr) = r-pedido-compr NO-LOCK: END.

    FOR FIRST ordem-compra FIELDS(int-1) 
        WHERE ROWID(ordem-compra) = r-row-ordem NO-LOCK: END.
        
    IF AVAIL prazo-compra AND prazo-compra.situacao <> 4 THEN 
        ASSIGN c-habilita = "yes":U.
    ELSE 
        ASSIGN c-habilita = "no":U.    

    /* Multiplanta: Verifica se pedido j† est† na central. */
    IF  param-global.modulo-mp AND AVAIL ordem-compra THEN DO:
        
        IF ordem-compra.int-1 =  1 AND param-compra.compra-centr = NO THEN DO:

            IF ordem-compra.num-pedido = 0 
            OR CAN-FIND(FIRST pedido-compr 
                        WHERE pedido-compr.num-pedido = ordem-compra.num-pedido 
                          AND pedido-compr.situacao = 1 /*Impresso*/ ) THEN DO:
                
                {utp/ut-liter.i "Pedido_de_Compra" *}
                {method/svc/errors/inserr.i &ErrorNumber="7193" /* Pedido ja esta cadastrado na central! Imposivel alterar/eliminar */
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="TRIM(RETURN-VALUE)"}
            END.
        END.
    END.
    
    IF AVAIL pedido-compr AND pedido-compr.nr-contrato <> 0 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="1806" &ErrorType="EMS":U &ErrorSubType="ERROR":U} /* Pedido possui contrato de fornecimento */
    END.
        
    IF NOT VALID-HANDLE (h-boin295) THEN
        RUN inbo/boin295.p PERSISTENT SET h-boin295.
    
    RUN validaContratoPedidoCompr IN h-boin295 (INPUT  r-pedido-compr).
    RUN getRowErrors IN h-boin295 (OUTPUT TABLE RowErrors).

    IF VALID-HANDLE (h-boin295) THEN DO:
        DELETE PROCEDURE h-boin295.
        ASSIGN h-boin295 = ?.
    END.

    IF AVAIL prazo-compra AND prazo-compra.situacao = 4 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="3138" &ErrorType="EMS":U &ErrorSubType="ERROR":U} /* Ordem ou Parcela j· eliminada */
    END.

    FIND FIRST RowErrors NO-LOCK NO-ERROR.
    IF AVAIL RowErrors THEN DO:
        ASSIGN i-mensagem = RowErrors.ErrorNumber.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaModificacaoPrazoCompra DBOProgram 
PROCEDURE validaModificacaoPrazoCompra :
/*------------------------------------------------------------------------------
  Purpose:     Valida se a situacao da Parcela permite modificaá∆o
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER rParcela AS ROWID NO-UNDO.
    
    DEFINE VARIABLE c-mensagem AS CHARACTER FORMAT "x(200)":U NO-UNDO.
    
    EMPTY TEMP-TABLE RowErrors.

    FOR FIRST prazo-compra FIELDS(situacao numero-ordem parcela)
        WHERE ROWID(prazo-compra) = rParcela NO-LOCK: END.

    IF AVAIL prazo-compra THEN DO:
        
        FIND FIRST ordem-compra 
             WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem NO-LOCK NO-ERROR.

        IF AVAIL ordem-compra THEN DO:
            FIND FIRST pedido-compr 
                 WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK NO-ERROR.
            
            IF AVAIL pedido-compr THEN DO:

                FIND FIRST emitente 
                     WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.
                IF AVAIL emitente THEN DO:
                    
                    /* Integracao Modulo de Importacao */
                    IF AVAIL param-global AND param-global.modulo-07 AND emitente.natureza > 2 THEN DO:
                        
                        IF cParamType = "DEL":U THEN DO:
                            RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.
                            RUN procuraEmbarqueCompras IN h-bocx225 (INPUT  pedido-compr.num-pedido,
                                                                     INPUT  ordem-compra.numero-ordem,
                                                                     INPUT  {&TABLENAME}.parcela,
                                                                     OUTPUT TABLE tt-embarque).
                            DELETE PROCEDURE h-bocx225.
                            ASSIGN i-cont = 0.
                            FOR EACH tt-embarque NO-LOCK:
                                ASSIGN i-cont = i-cont + 1.
                                IF i-cont = 1 THEN
                                    ASSIGN c-mensagem = tt-embarque.embarque.
                                ELSE
                                    ASSIGN c-mensagem = c-mensagem + ', ':U + tt-embarque.embarque.
                            END.
                            IF i-cont >= 1 THEN DO:
                                {utp/ut-liter.i "Material_em_TrÉnsito" *}
                                ASSIGN c-lbl-trad = c-mensagem + '~~~~':U + TRIM(RETURN-VALUE).
                                {method/svc/errors/inserr.i &ErrorNumber="28558"
                                                            &ErrorType="EMS":U
                                                            &ErrorSubType="INFORMATION":U
                                                            &ErrorParameters= "c-lbl-trad"}
                            END.
                        END. /* if = DEL */
                    END.
                END.
            END.
        END.

        IF prazo-compra.situacao = 4 THEN DO:
           {method/svc/errors/inserr.i &ErrorNumber="3138" &ErrorType="EMS" &ErrorSubType="ERROR"} /* Ordem ou Parcela j· eliminada */
        END.
        
        FIND FIRST proc-compra NO-LOCK
             WHERE proc-compra.nr-processo = ordem-compra.nr-processo NO-ERROR.
        
        IF AVAIL proc-compra AND proc-compra.log-proces-pregao THEN DO:

            FIND FIRST usuar-mater NO-LOCK 
                 WHERE usuar-mater.cod-usuario = c-seg-usuario NO-ERROR.
            
            IF AVAIL usuar-mater THEN DO:
                IF usuar-mater.log-usuar-pregao THEN DO:

                    {utp/ut-liter.i "Ordem_de_Compra" *}
                    {method/svc/errors/inserr.i &ErrorNumber="32715" /* Ordem de Compra relacionado a um pregao eletronico */
                                                &ErrorType="EMS":U
                                                &ErrorSubType="WARNING"
                                                &ErrorParameters="TRIM(RETURN-VALUE)"}
                END.
                ELSE DO:
                    {utp/ut-liter.i "incluir,_alterar_e_eliminar_parcelas_em_ordens_de_compra_de_preg∆o_eletrìnico" *}
                    {method/svc/errors/inserr.i &ErrorNumber="25729" /* Usuario sem permissao */
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="c-seg-usuario + '~~~~' + TRIM(RETURN-VALUE)"}
                END.
           END.
        END.
        FIND FIRST param-global NO-LOCK NO-ERROR.
        IF AVAIL param-global THEN DO:
            IF param-global.log-modul-eq THEN DO:
                IF CAN-FIND (FIRST eq-embarq-praz-compra 
                             WHERE eq-embarq-praz-compra.numero-ordem = prazo-compra.numero-ordem
                               AND eq-embarq-praz-compra.parcela      = prazo-compra.parcela) THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="30884"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"}
                END.
            END.
        END.
    END. /* Avail prazo-compra */

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaModifPrazoCompra DBOProgram 
PROCEDURE validaModifPrazoCompra :
/*------------------------------------------------------------------------------
  Purpose:
     Retorna erro ao usu†rio se o pedido possui contrato de fornecimento
     o que impossibilita a sua modificaá∆o.
     E retorna uma informaá∆o se Pedido de Compra informado possui Ordem de Compra
     recebida ou a Ordem de Compra que est† para ser eliminada possui parcela recebida.
  Parameters:
     ipar1 : r-prazo-compra : rowid corrente da tabela prazo-compra
     ipar2 : r-pedido-compr : rowid corrente da tabela pedido-compr
     ipar3 : rOrdemCompra   : rowid corrente da tabela ordem-compra
     opar4 : rOrdem-return  : rowid corrente da tabela ordem-compra
     opar5 : c-habilita     : habilita quando a situaá∆o Ç diferente de 4
     opar6 : i-mensagem     : n£mero da mensagem
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER r-prazo-compra AS ROWID     NO-UNDO.
    DEFINE INPUT  PARAMETER r-pedido-compr AS ROWID     NO-UNDO.
    DEFINE INPUT  PARAMETER rOrdemCompra   AS ROWID     NO-UNDO.
    DEFINE OUTPUT PARAMETER rOrdem-return  AS ROWID     NO-UNDO.
    DEFINE OUTPUT PARAMETER c-habilita     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER i-mensagem     AS INTEGER   NO-UNDO.

    FOR FIRST prazo-compra FIELDS(situacao)
        WHERE ROWID(prazo-compra) = r-prazo-compra NO-LOCK: END.
    
    FOR FIRST pedido-compr FIELDS(nr-contrato)
        WHERE ROWID(pedido-compr) = r-pedido-compr NO-LOCK: END.

    FOR FIRST ordem-compra FIELDS(int-1)
        WHERE ROWID(ordem-compra) = rOrdemCompra NO-LOCK: END.

    IF AVAIL prazo-compra AND prazo-compra.situacao <> 4 THEN 
        ASSIGN c-habilita = "yes":U.
    ELSE 
        ASSIGN c-habilita = "no":U.  

    /* Multiplanta: Verifica se pedido j† est† na central. */
    IF param-global.modulo-mp AND AVAIL ordem-compra THEN DO:
        
        IF ordem-compra.int-1 = 1 AND param-compra.compra-centr = NO THEN DO:
            IF ordem-compra.num-pedido = 0 
            OR CAN-FIND(FIRST pedido-compr 
                        WHERE pedido-compr.num-pedido = ordem-compra.num-pedido 
                          AND pedido-compr.situacao = 1 /*Impresso*/ )  THEN DO:
                {utp/ut-liter.i "Pedido_de_Compra" *}
                {method/svc/errors/inserr.i &ErrorNumber="7193"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="TRIM(RETURN-VALUE)"}
           END.
       END.
    END.
    
    IF AVAIL pedido-compr AND pedido-compr.nr-contrato <> 0 AND pedido-compr.nr-contrato <> ? THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="1806" &ErrorType="EMS":U &ErrorSubType="ERROR":U}
    END.

    IF NOT VALID-HANDLE(h-boin295) THEN
        RUN inbo/boin295.p PERSISTENT SET h-boin295.

    RUN validaContratoPedidoCompr IN h-boin295 (INPUT  r-pedido-compr).
    RUN getRowErrors in h-boin295 (OUTPUT TABLE RowErrors).

    IF VALID-HANDLE (h-boin295) THEN DO:
        DELETE PROCEDURE h-boin295.
        ASSIGN h-boin295 = ?.
    END.

    IF AVAIL prazo-compra AND prazo-compra.situacao = 4 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="3138" &ErrorType="EMS":U &ErrorSubType="ERROR":U}
    END.

    IF AVAIL ordem-compra THEN
        ASSIGN rOrdem-return = ROWID(ordem-compra).

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
        FIND FIRST RowErrors NO-LOCK NO-ERROR.
        IF AVAIL RowErrors THEN DO:
            ASSIGN i-mensagem = RowErrors.ErrorNumber.
        END.
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaMotivoEliminacaoParcela DBOProgram 
PROCEDURE validaMotivoEliminacaoParcela :
/*------------------------------------------------------------------------------
  Purpose:     
     Verifica ao confirmar a eliminaá∆o da parcela (prazo-compra) se o
     motivo da eliminaá∆o est† em branco quando clicado na pergunta :
     "Confirma Eliminaá∆o ? ".
  Parameters:
     ipar1 : l-confirma           : "Confirma Eliminaá∆o ? " (YES ou NO)
     ipar2 : c-motivo-eliminacao  : texto que diz respeito ao motivo de eliminaá∆o
     opar3 : c-retorna-motivo     : se o texto n∆o for em branco retorna o texto ao programa 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER l-confirma          as LOGICAL   NO-UNDO.
    DEFINE INPUT  PARAMETER c-motivo-eliminacao as CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-retorna-motivo    as CHARACTER NO-UNDO.

    IF l-confirma THEN DO:
        IF c-motivo-eliminacao = "":U THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="1213" &ErrorType="EMS":U &ErrorSubType="ERROR":U}
        END.
        ASSIGN c-retorna-motivo = c-motivo-eliminacao.
    END.
    ELSE
        ASSIGN c-retorna-motivo = "":U. /* limpa o motivo se a eliminaá∆o n∆o foi confirmada */

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaParcelaOrdemCompraPedImp DBOProgram 
PROCEDURE validaParcelaOrdemCompraPedImp :
/*------------------------------------------------------------------------------
  Purpose:  (validaParcelaOrdemCompra)
            Valida existencia de cotaá∆o para a ordem de compra
            Valida a Unidades de Medida.
            Valida Conta Cont†bil
            Valida Data de entrega modificada em Importacao
  Parameters: ipar1  : rPrazoCompra  : Rowid da tabela prazo-compra
              ipar8  : daDataEntrega : Data entrega material
              ipar9  : cCodRefer     : Codigo da referencia
              ipar10 : deQtdSalFor   : Quantidade saldo fornecedor da tabela prazo-compra
              gera RowErrors
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER rPrazoCompra   AS ROWID      NO-UNDO.
    DEFINE INPUT PARAMETER daDataEntrega  AS DATE       NO-UNDO.
    DEFINE INPUT PARAMETER cCodRefer      AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAMETER deQtdSalForn   AS DECIMAL    NO-UNDO.
    
    DEFINE VARIABLE c-mensagem AS CHARACTER FORMAT "x(200)":U NO-UNDO.
    
    FOR FIRST prazo-compra FIELDS(numero-ordem dec-1) 
        WHERE ROWID(prazo-compra) = rPrazoCompra  NO-LOCK: END.

    IF AVAIL prazo-compra THEN
        FOR FIRST ordem-compra FIELDS(numero-ordem int-1 it-codigo cod-emitente data-cotacao natureza op-codigo nr-contrato num-ord-inv ordem-servic data-emissao) 
            WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem NO-LOCK: END.

    IF AVAIL ordem-compra THEN DO:
        FOR FIRST item-fornec FIELDS(it-codigo cod-emitente ativo unid-med-for) 
            WHERE item-fornec.it-codigo    = ordem-compra.it-codigo 
              AND item-fornec.cod-emitente = ordem-compra.cod-emitente 
              AND item-fornec.ativo NO-LOCK: END.
    
        FOR FIRST cotacao-item FIELDS(numero-ordem cod-emitente data-cotacao cot-aprovada un) 
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
              AND cotacao-item.cod-emitente = ordem-compra.cod-emitente 
              AND cotacao-item.data-cotacao = ordem-compra.data-cotacao NO-LOCK: END.

        IF NOT AVAIL cotacao-item THEN
            FOR FIRST cotacao-item FIELDS(numero-ordem cod-emitente data-cotacao cot-aprovada un) 
                WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                  AND cotacao-item.cod-emitente = ordem-compra.cod-emitente 
                  AND cotacao-item.cot-aprovada NO-LOCK: END.
    END.
    
    IF cCodRefer <> "":U and cCodRefer <> ? AND NOT CAN-FIND(referencia WHERE referencia.cod-refer = cCodRefer) THEN DO:
        {utp/ut-liter.i "Referància" *}
        {method/svc/errors/inserr.i
                           &ErrorNumber="47"
                           &ErrorType="EMS":U
                           &ErrorSubType="ERROR":U 
                           &ErrorParameters="TRIM(RETURN-VALUE)"}
    END.

    IF deQtdSalForn < 0 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="526" &ErrorType="EMS":U &ErrorSubType="ERROR":U}
    END.

    /* Quantidade Saldo n∆o pode ser inferior a quantidade alocada no recebimento. */
    IF AVAIL prazo-compra AND deQtdSalForn < prazo-compra.dec-1 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="17945" &ErrorType="EMS":U &ErrorSubType="ERROR":U}
    END.

    IF AVAIL ordem-compra THEN DO:
        FIND FIRST pedido-compr 
             WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK NO-ERROR.
        IF AVAIL pedido-compr THEN DO:
            FIND FIRST emitente 
                 WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.
            IF AVAIL emitente THEN DO:
                IF AVAIL param-global AND param-global.modulo-07 AND emitente.natureza > 2 THEN DO:
                    
                    /* Integracao Modulo de Importacao */
                    IF AVAIL prazo-compra THEN DO:
                        IF prazo-compra.data-entrega <> daDataEntrega THEN DO:
                            IF cParamType = "MOD":U THEN DO:
                                RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.
                                RUN procuraEmbarqueCompras IN h-bocx225 (INPUT  pedido-compr.num-pedido,
                                                                         INPUT  ordem-compra.numero-ordem,
                                                                         INPUT  {&TABLENAME}.parcela,
                                                                         OUTPUT TABLE tt-embarque).
                                DELETE PROCEDURE h-bocx225.
                                ASSIGN i-cont = 0.
                                FOR EACH tt-embarque NO-LOCK:
                                    ASSIGN i-cont = i-cont + 1.
                                    IF i-cont = 1 THEN
                                        ASSIGN c-mensagem = tt-embarque.embarque.
                                    ELSE
                                        ASSIGN c-mensagem = c-mensagem + ', ':U + tt-embarque.embarque.
                                END.
                                IF i-cont >= 1 THEN DO:
                                    {utp/ut-liter.i "Material_em_TrÉnsito" *}
                                    ASSIGN c-lbl-trad = c-mensagem + '~~~~':U + TRIM(RETURN-VALUE).
                                    {method/svc/errors/inserr.i &ErrorNumber="28558"
                                                                &ErrorType="EMS":U
                                                                &ErrorSubType="INFORMATION":U
                                                                &ErrorParameters= "c-lbl-trad"}
                                END.
                            END.
                        END.
                    END.
                END.
            END.
        END.
    END.

    RETURN (IF NOT (CAN-FIND (FIRST rowErrors)) THEN "OK":U ELSE "NOK":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaPedEmergMessage DBOProgram 
PROCEDURE validaPedEmergMessage :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  <none>
  Notes: Validacao inclusa no programa cc0300, procedure pisaveAndOk para evitar
         que o pedido fosse criado sem parcelas.
------------------------------------------------------------------------------*/
    
    {method/svc/errors/inserr.i &ErrorNumber="3520" &ErrorType="EMS":U &ErrorSubType="ERROR":U &ErrorParameters="''"}    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaPregaoEletronico DBOProgram 
PROCEDURE validaPregaoEletronico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST param-compra NO-LOCK NO-ERROR.

    IF AVAIL param-compra THEN DO:

        IF param-compra.log-param-pregao-eletron THEN DO:

            IF AVAIL tt-ordem-compra AND tt-ordem-compra.nr-processo <> 0 THEN DO:

                FIND FIRST proc-compra NO-LOCK
                    WHERE proc-compra.nr-processo = tt-ordem-compra.nr-processo NO-ERROR.

                IF AVAIL proc-compra AND proc-compra.log-proces-pregao THEN DO:

                    FIND FIRST usuar-mater NO-LOCK 
                         WHERE usuar-mater.cod-usuario = c-seg-usuario NO-ERROR.

                    IF AVAIL usuar-mater THEN DO:

                        IF usuar-mater.log-usuar-pregao THEN DO:
                            {utp/ut-liter.i "Ordem_de_Compra" *}
                            {method/svc/errors/inserr.i &ErrorNumber="32715"
                                                        &ErrorType="EMS":U
                                                        &ErrorSubType="WARNING"
                                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
                        END.
                        ELSE DO:
                            {utp/ut-liter.i "incluir,_alterar_e_eliminar_parcelas_em_ordens_de_compra_de_preg∆o_eletrìnico" *}
                            {method/svc/errors/inserr.i &ErrorNumber="25729"
                                                        &ErrorType="EMS":U
                                                        &ErrorSubType="ERROR"
                                                        &ErrorParameters="c-seg-usuario + '~~~~' + TRIM(RETURN-VALUE)"}
                        END.
                    END.
                END.
            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaSegUsuarioPedCompra DBOProgram 
PROCEDURE validaSegUsuarioPedCompra :
/*------------------------------------------------------------------------------
  Purpose: Validar a permiss∆o do usu†rio logado quanto Ö inserá∆o, alteraá∆o e remoá∆o de
           um pedido de compra.
  Parameters: 
  Notes: VALIDAÄ«O PARA SER EXECUTADA DO PROGRAMA CC0300 OU DAS TELAS FILHO 
         PARA CONTROLAR SEGURANÄA POR USUµRIO PARA AÄÂES(INSERÄ«O, ALTERAÄ«O OU REMOÄ«O) 
         SOB PEDIDO DE COMPRA 
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pr-ordem-parcela AS ROWID    NO-UNDO.
    DEFINE INPUT PARAMETER pr-pedido        AS ROWID    NO-UNDO.
    DEFINE INPUT PARAMETER pi-tipo          AS INTEGER  NO-UNDO.
    
    IF pr-ordem-parcela <> ? THEN DO:
        FOR FIRST prazo-compra FIELDS(numero-ordem)
            WHERE ROWID(prazo-compra) = pr-ordem-parcela NO-LOCK:

            FOR FIRST ordem-compra FIELDS(num-pedido)
                WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem NO-LOCK: 

                FOR FIRST pedido-compr fields(emergencial situacao)
                    WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK:
                END.
            END.
        END.
    END.
    ELSE
        IF pr-pedido <> ? THEN DO:
            FOR FIRST pedido-compr FIELDS(emergencial situacao)
                WHERE ROWID(pedido-compr) = pr-pedido NO-LOCK:
            END.
        END.

    IF AVAIL pedido-compr THEN DO:
        
        RUN setLSegcc0300.
        
        IF l-seg-cc0300 = YES THEN
           RUN validateSegCC0300 (INPUT pi-tipo, INPUT pedido-compr.emergencial, INPUT pedido-compr.situacao).
        
        RETURN "OK":U.
    END.

    RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validatebufferprazocompra DBOProgram 
PROCEDURE validatebufferprazocompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-parcela LIKE tt-buffer-parcelas.parcela.
    DEFINE INPUT PARAMETER TABLE FOR tt-buffer-parcelas.
    
    DEFINE BUFFER b-tt-buffer-parcelas FOR tt-buffer-parcelas.
    
    FIND LAST tt-buffer-parcelas USE-INDEX ordem NO-LOCK NO-ERROR.

    IF AVAIL tt-buffer-parcelas AND tt-buffer-parcelas.parcela <> p-parcela THEN DO:
        IF CAN-FIND(FIRST b-tt-buffer-parcelas 
                    WHERE b-tt-buffer-parcelas.parcela = p-parcela 
                      AND ROWID(b-tt-buffer-parcelas) <> ROWID(tt-buffer-parcelas)) THEN DO:
            {utp/ut-liter.i "Prazo_Compra" *}
            {method/svc/errors/inserr.i &ErrorNumber="7"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCreateBusinessLogic DBOProgram 
PROCEDURE validateCreateBusinessLogic :
/*------------------------------------------------------------------------------
  Purpose:     
     Validaá‰es de neg¢cio para criaá∆o de novos registros
  Parameters:  
     ipar1 : p-l-parc-quant-lote-min : Cadastrar parcelas com qtde menor que o lote m°nimo?
  Notes:       
     Esta procedure foi customizada para utilizar uma temp-table
    (tt-ordem-compra) para validaá‰es de parcela que necessitam
    de campos da tabela de ordem de compra (pai).
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-l-parc-quant-lote-min AS LOGICAL NO-UNDO.

    IF CAN-FIND(FIRST tt-parcelas-aux 
                WHERE tt-parcelas-aux.numero-ordem = tt-ordem-compra.numero-ordem 
                  AND tt-parcelas-aux.parcela      = rowObject.parcela) THEN DO:
        {utp/ut-liter.i "Prazo_Compra" *}
        {method/svc/errors/inserr.i &ErrorNumber="7"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
   END.                                                                         

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCreateManutOrdCompra DBOProgram 
PROCEDURE validateCreateManutOrdCompra :
/*------------------------------------------------------------------------------
  Purpose:     
     Valida criaá∆o da tabela/duplicidade de registro.
  Parameters:  <none>
     ipar1  : table for rowObject     : Tabela de dados
     ipar2  : tt-parcelas-aux         : Tabela com todos as parcelas da ordem corrente
     ipar3  : p-cParamManutOrd        : funá∆o geral do programa cc0300b (inclus∆o ou modificaá∆o)
     ipar4  : p-dt-valid-ini          : Data inicial para validaá∆o de data das parcelas
     ipar5  : p-dt-valid-fim          : Data final para validaá∆o de data das parcelas
     ipar6  : p-c-usuar-corren        : Usu†rio corrente
     ipar7  : p-l-parc-quant-lote-min : Cadastrar parcelas com qtde menor que o lote m°nimo?
     ipar8  : p-l-cad-ped-pend        : Cadastra pedidos pendentes?
     ipar9  : p-l-lote                : 
     opar10 : table for tt-erro       : Tabela de erros
  Notes:
    Em virtude da estrutura Web, foi necess†rio separar os mÇtodos de validaá∆o e de criaá∆o de registro 
    (validateCreate e executeCreate).
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE                   FOR RowObject.
    DEFINE INPUT  PARAMETER TABLE                   FOR tt-parcelas-aux.
    DEFINE INPUT  PARAMETER p-cParamManutOrd        AS  CHARACTER       NO-UNDO.
    DEFINE INPUT  PARAMETER p-dt-valid-ini          AS  DATE            NO-UNDO.
    DEFINE INPUT  PARAMETER p-dt-valid-fim          AS  DATE            NO-UNDO.
    DEFINE INPUT  PARAMETER p-c-usuar-corren        AS  CHARACTER       NO-UNDO.
    DEFINE INPUT  PARAMETER p-l-parc-quant-lote-min AS  LOGICAL         NO-UNDO.
    DEFINE INPUT  PARAMETER p-l-cad-ped-pend        AS  LOGICAL         NO-UNDO.
    DEFINE INPUT  PARAMETER p-l-lote                AS  LOGICAL         NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE                   FOR rowerrors.
    
    DEFINE VARIABLE mensagem    AS CHAR NO-UNDO.
    
    ASSIGN l-parc-quant-lote-min = p-l-parc-quant-lote-min.
    ASSIGN cParamManutOrd = p-cParamManutOrd
           l-create       = YES.

    EMPTY TEMP-TABLE rowErrors.

    FIND FIRST rowObject NO-ERROR.
    
    IF AVAIL tt-ordem-compra THEN   /* vem da inputTableOrdemCompra */
        FOR FIRST pedido-compr FIELDS(num-pedido situacao end-entrega data-pedido emergencial) 
            WHERE pedido-compr.num-pedido = tt-ordem-compra.num-pedido NO-LOCK: END.
        
    /**Valida a situacao do fornecedor apenas na modificacao da ordem**/
    IF AVAIL pedido-compr AND p-cParamManutOrd <> "Add":U THEN
        RUN ValidateStatusFornec ( ?, pedido-compr.cod-emitente).
    
    ASSIGN cParamModo = "add":U.
    RUN validateFieldsBusinessLogic (INPUT p-dt-valid-ini,
                                     INPUT p-dt-valid-fim,
                                     INPUT IF p-c-usuar-corren <> "":U THEN p-c-usuar-corren ELSE c-seg-usuario,
                                     INPUT p-l-cad-ped-pend,
                                     INPUT p-l-lote).

    RUN validateCreateBusinessLogic (INPUT p-l-parc-quant-lote-min).
    
    FIND FIRST rowErrors NO-LOCK NO-ERROR.
    IF NOT AVAILABLE rowErrors THEN DO:
        
        IF rowObject.parcela = 0 THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="8449" &ErrorType="EMS":U &ErrorSubType="ERROR":U}
        END.
    
        /* Quantidade deve ser maior que zero */
        IF rowObject.quantidade = 0 OR rowObject.quantidade = ? THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="1368" &ErrorType="EMS":U &ErrorSubType="ERROR":U}
        END.
    
        FOR FIRST tt-parcelas-aux 
            WHERE tt-parcelas-aux.numero-ordem = rowObject.numero-ordem 
              AND tt-parcelas-aux.parcela      = rowObject.parcela NO-LOCK: END.

        IF AVAIL tt-parcelas-aux THEN DO:
            {utp/ut-liter.i "Prazo_Compra" *}
            {method/svc/errors/inserr.i &ErrorNumber="8"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.
    END. 

    IF AVAIL pedido-compr THEN 
        /* VALIDAÄ«O DO PROGRAMA CC0300 PARA CONTROLAR SEGURANÄA POR USUµRIO PARA PEDIDO DE COMPRA */
        IF l-seg-cc0300 = YES THEN
            RUN validateSegCC0300 (INPUT 1, INPUT pedido-compr.emergencial, INPUT pedido-compr.situacao).

    RUN validaPregaoEletronico.

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFieldsBusinessLogic DBOProgram 
PROCEDURE validateFieldsBusinessLogic :
/*------------------------------------------------------------------------------
  Purpose:     
     Validaá‰es de neg¢cio. (Inclus∆o/Modificaá∆o)
  Parameters:  <none>
     ipar1 : p-dt-valid-ini   : Data inicial para validaá∆o das parcelas 
     ipar2 : p-dt-valid-fim   : Data final para validaá∆o das parcelas
     ipar3 : p-c-usuar-corren : Usu†rio corrente
     opar4 : p-l-cad-ped-pend : Cadastra ordens com pedidos pendentes?
  Notes:       
     Esta procedure foi customizada para utilizar uma temp-table
     (tt-ordem-compra) para validaá‰es de parcela que necessitam
     de campos da tabela de ordem de compra (pai).  

------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-dt-valid-ini   AS DATE         NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-valid-fim   AS DATE         NO-UNDO.
    DEFINE INPUT PARAMETER p-c-usuar-corren AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER p-l-cad-ped-pend AS LOGICAL      NO-UNDO.
    DEFINE INPUT PARAMETER p-l-lote         AS LOGICAL      NO-UNDO.

    DEFINE VARIABLE i-cont-parc       AS INTEGER INITIAL 0 NO-UNDO. 
    DEFINE VARIABLE l-ind-aprov       AS LOGICAL           NO-UNDO.    
    DEFINE VARIABLE c-lbl-dias-ressup AS CHARACTER         NO-UNDO.

    FIND FIRST para-ped NO-LOCK NO-ERROR.
    
    FOR FIRST item FIELDS(it-codigo tipo-con-est lote-multipl fraciona lote-minimo un tipo-contr res-cq-comp res-int-comp res-for-comp) 
        WHERE item.it-codigo = tt-ordem-compra.it-codigo NO-LOCK: END.
        
    FIND FIRST prazo-compra 
         WHERE prazo-compra.numero-ordem = rowObject.numero-ordem 
           AND prazo-compra.parcela = rowObject.parcela NO-LOCK NO-ERROR.
    
    IF NOT AVAIL param-compra THEN DO:
        {utp/ut-liter.i "ParÉmetros_de_Compra" *}
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                   &ErrorType="EMS":U
                                   &ErrorSubType="ERROR":U
                                   &ErrorParameters="TRIM(RETURN-VALUE)"}    
    END.
    IF NOT AVAIL param-global THEN DO:
        {utp/ut-liter.i "ParÉmetros_Globais" *}
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                   &ErrorType="EMS":U
                                   &ErrorSubType="ERROR":U
                                   &ErrorParameters="TRIM(RETURN-VALUE)"}    
    END.
    IF NOT AVAIL item THEN DO:
        {utp/ut-liter.i "Item" *}
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                   &ErrorType="EMS":U
                                   &ErrorSubType="ERROR":U
                                   &ErrorParameters="TRIM(RETURN-VALUE)"}    
    END.
    IF RowObject.situacao = 4 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="3138" &ErrorType="EMS":U &ErrorSubType="ERROR":U}
    END.
    
    IF AVAIL item THEN
       FOR FIRST item-uni-estab FIELDS(it-codigo cod-estabel lote-minimo lote-multipl res-cq-comp res-int-comp res-for-comp) 
           WHERE item-uni-estab.cod-estabel = tt-ordem-compra.cod-estabel 
             AND item-uni-estab.it-codigo   = item.it-codigo NO-LOCK: END.
    
    /* Validaá∆o de Data */
    IF rowObject.situacao <> 6 AND AVAIL prazo-compra THEN DO:
        IF  (prazo-compra.data-entrega <> rowObject.data-entrega OR prazo-compra.qtd-sal-forn <> rowObject.qtd-sal-forn) 
        AND (rowObject.data-entrega     < p-dt-valid-ini         OR rowObject.data-entrega     > p-dt-valid-fim) THEN DO:
            
            {method/svc/errors/inserr.i &ErrorNumber="314"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="string(p-dt-valid-ini) + '~~~~' + string(p-dt-valid-fim)"}
        END.
    END.
    
    /* Data entrega: qdo existir pedido validar contra data-pedido, sen∆o validar contra data emiss∆o ordem */
    IF AVAIL pedido-compr THEN DO:
        IF rowObject.data-entrega < pedido-compr.data-pedido THEN DO:
            /* Data deve ser maior ou igual a Data de Implantaá∆o do Pedido - (antes 322) */
            {utp/ut-liter.i "Prazo_Compra" *}
            {method/svc/errors/inserr.i &ErrorNumber="5668"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.
    END.
    ELSE DO:
        /*-- validacao pedido emergencial flex - pedido ainda nao criado na base --*/
        IF tt-ordem-compra.data-pedido <> ? THEN DO:
            
            IF rowObject.data-entrega < tt-ordem-compra.data-pedido THEN DO:
                /* Data deve ser maior ou igual a Data de Implantaá∆o do Pedido - (antes 322) */
                {utp/ut-liter.i "Prazo_Compra" *}
                {method/svc/errors/inserr.i &ErrorNumber="5668"
                                           &ErrorType="EMS":U
                                           &ErrorSubType="ERROR":U
                                           &ErrorParameters="TRIM(RETURN-VALUE)"}
            END.
        END.
        ELSE
            IF rowObject.data-entrega < tt-ordem-compra.data-emissao THEN DO:
                {utp/ut-liter.i "Prazo_Compra" *}
                {method/svc/errors/inserr.i &ErrorNumber="6719"
                                           &ErrorType="EMS":U
                                           &ErrorSubType="ERROR":U
                                           &ErrorParameters="TRIM(RETURN-VALUE)"}
            END.
    END.
    
    IF (AVAIL item AND item.tipo-con-est = 4) THEN DO:
        
        IF NOT CAN-FIND(FIRST referencia 
                        WHERE referencia.cod-refer = rowObject.cod-refer) THEN DO:
            
            {utp/ut-liter.i "Referància" *}
            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.
        ELSE
            IF NOT CAN-FIND(FIRST ref-item 
                            WHERE ref-item.it-codigo = rowObject.it-codigo
                              AND ref-item.cod-refer = rowObject.cod-refer) THEN DO:
                
                {method/svc/errors/inserr.i &ErrorNumber="33928"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="rowObject.cod-refer + '~~~~' + rowObject.it-codigo"}
            END.
    END.
    
    /* C†lculo das demais quantidades */
    RUN pi-indice (INPUT tt-ordem-compra.it-codigo, INPUT tt-ordem-compra.cod-emitente,  INPUT tt-ordem-compra.numero-ordem, OUTPUT de-indice).
    
    IF cParamManutOrd = "add":U THEN DO:
        /*** O usu†rio informou rowObject.quantidade ***/
        ASSIGN rowObject.qtd-do-forn  = (rowObject.quantidade * de-indice)
               rowObject.qtd-sal-forn = (rowObject.qtd-do-forn - rowObject.qtd-rec-forn + rowObject.qtd-rej-forn)
               rowObject.quant-saldo  = IF AVAIL item AND item.fraciona THEN
                                            (rowObject.qtd-sal-forn / de-indice)
                                        ELSE
                                            TRUNCATE((rowObject.qtd-sal-forn / de-indice),0)
               rowObject.qtd-rec-forn = rowObject.quant-receb  * de-indice
               rowObject.qtd-rej-forn = rowObject.quant-rejeit * de-indice.
    END.
    ELSE DO:
        /*** O usu†rio informou rowObject.qtd-sal-forn ***/
        ASSIGN rowObject.qtd-do-forn  = (rowObject.qtd-sal-forn + rowObject.qtd-rec-forn - rowObject.qtd-rej-forn)
               rowObject.quantidade   = IF AVAIL item AND item.fraciona THEN
                                            (rowObject.qtd-do-forn / de-indice)
                                        ELSE
                                            TRUNCATE(rowObject.qtd-do-forn / de-indice,0)
               rowObject.quant-saldo  = IF  AVAIL item AND item.fraciona THEN
                                            (rowObject.qtd-sal-forn / de-indice)
                                        ELSE
                                            TRUNCATE((rowObject.qtd-sal-forn / de-indice),0)
               rowObject.quant-receb  = rowObject.qtd-rec-forn / de-indice
               rowObject.quant-rejeit = rowObject.qtd-rej-forn / de-indice.
    END.
    
    /* Validaá∆o para que a quantidade informada n∆o zere a qtde-forn e vice-versa */
    IF  (ROUND(rowObject.quant-saldo,4) <= 0 OR ROUND(rowObject.qtd-sal-forn,4) <= 0) 
    AND (    (    NOT AVAIL pedido-compr  AND tt-ordem-compra.num-pedido <> 0) /*-- pedido emergencial flex - pedido ainda nao criado na base --*/
         OR  (    AVAIL pedido-compr AND ( pedido-compr.situacao <> 1 OR (pedido-compr.situacao = 1 AND cParamModo = "add":U)))) /*cParamManutOrd*/
    THEN DO:
          /* O fator de conversao provocou o zeramento das quantidades da Ordem */
         {method/svc/errors/inserr.i &ErrorNumber="25928" &ErrorType="EMS":U &ErrorSubType="ERROR":U}
    END.
    
    IF rowObject.quant-saldo < 0 THEN
        ASSIGN rowObject.quant-saldo = 0.
    
    IF rowObject.qtd-sal-forn < 0 THEN
        ASSIGN rowObject.qtd-sal-forn = 0.
    
    IF RowObject.quantidade > 9999999.9999 THEN DO:
       /* Quantidade da parcela &1 maior que 9999999.9999 - unidade medida interna */
       {method/svc/errors/inserr.i &ErrorNumber="27685"
                                   &ErrorType="EMS":U
                                   &ErrorSubType="ERROR":U
                                   &ErrorParameters="trim(string(RowObject.parcela, '>>9':U))"} 
    END.
    
    IF RowObject.qtd-do-forn > 9999999.9999 THEN DO:
        /* Quantidade da parcela &1 maior que 9999999.9999 - unidade medida fornecedor */
       {method/svc/errors/inserr.i &ErrorNumber="27684"
                                   &ErrorType="EMS":U
                                   &ErrorSubType="ERROR":U
                                   &ErrorParameters="trim(string(RowObject.parcela, '>>9':U))"}
    END.
    
    IF  AVAIL item 
    AND NOT item.fraciona 
    AND rowObject.quantidade - truncate(rowObject.quantidade,0) > 0 THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="847" &ErrorType="EMS":U &ErrorSubType="ERROR":U}
    END.
    
    /*-------------- Calcula a quantidade total das parcelas ----------------------*/
    ASSIGN de-qtd-parc = 0.
    FOR EACH tt-parcelas-aux
       WHERE tt-parcelas-aux.numero-ordem = rowObject.numero-ordem 
         AND tt-parcelas-aux.situacao     <> 4 NO-LOCK:
        ASSIGN de-qtd-parc = de-qtd-parc + tt-parcelas-aux.quantidade.
    END.
    
    FIND FIRST tt-parcelas-aux 
         WHERE tt-parcelas-aux.numero-ordem = rowObject.numero-ordem 
           AND tt-parcelas-aux.parcela      = rowObject.parcela NO-LOCK NO-ERROR.
    
    IF AVAIL tt-parcelas-aux THEN DO:
       ASSIGN de-tot-parcela = de-qtd-parc +               /* somat¢rio qtdes de tt-parcelas-aux com mesmo numero-ordem */
                               rowObject.quantidade -      /* quantidade informada pelo usu†rio */
                               tt-parcelas-aux.quantidade. /* subtrai a qtde da pr¢pria parcela quando Ç MOD */
    END.
    ELSE DO:
       ASSIGN de-tot-parcela = de-qtd-parc +               /* somat¢rio qtdes de tt-parcelas-aux com mesmo numero-ordem */
                               rowObject.quantidade.       /* quantidade informada pelo usu†rio */
    END.
    
    ASSIGN de-tot-quant-parc = de-tot-parcela.
    
    IF  rowObject.quantidade = 0 
    AND (    (    NOT AVAIL pedido-compr AND tt-ordem-compra.num-pedido <> 0) /*-- pedido emergencial flex - pedido ainda nao criado na base --*/
         OR  (    AVAIL pedido-compr AND ( (pedido-compr.situacao <> 1) OR (pedido-compr.situacao = 1 AND cParamModo /*cParamManutOrd*/ = "add":U)))) 
    THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="1368" &ErrorType="EMS":U &ErrorSubType="ERROR":U}
    END.
    
    RUN pi-valida-lote-minimo-multiplo (INPUT p-l-lote).
    
    IF AVAIL item THEN DO:
        IF tt-ordem-compra.nr-contrato = 0 THEN DO:
            IF rowObject.un <> item.un 
            AND(   (item.tipo-contr <> 4) 
                OR (CAN-FIND (FIRST item-fornec WHERE item-fornec.it-codigo = tt-ordem-compra.it-codigo AND item-fornec.ativo) 
                    AND tt-ordem-compra.it-codigo <> "":U 
                    AND tt-ordem-compra.it-codigo <> ?))  THEN DO:
                
                IF param-compra.log-multi-unid-medid THEN DO:
                    IF NOT CAN-FIND(FIRST item-fornec-umd
                                    WHERE item-fornec-umd.it-codigo    = item-fornec.it-codigo
                                      AND item-fornec-umd.cod-emitente = item-fornec.cod-emitente
                                      AND item-fornec-umd.unid-med-for = Rowobject.un
                                      AND item-fornec-umd.log-ativo) THEN DO:
                        {method/svc/errors/inserr.i &ErrorNumber="51523"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="item-fornec.it-codigo + '~~~~' + string(item-fornec.cod-emitente) + '~~~~' + Rowobject.un"}
                    END.
                END.
                ELSE DO:
                    {method/svc/errors/inserr.i &ErrorNumber="3359" &ErrorType="EMS":U &ErrorSubType="ERROR":U &ErrorParameters="' '"}
                END.
            END.
                 
            IF NOT CAN-FIND(FIRST tab-unidade WHERE tab-unidade.un = rowObject.un) THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="846" &ErrorType="EMS":U &ErrorSubType="ERROR":U &ErrorParameters="' '"}                               
            END.
          
            IF CAN-FIND(FIRST tt-parcelas-aux  
                        WHERE tt-parcelas-aux.numero-ordem = tt-ordem-compra.numero-ordem 
                          AND tt-parcelas-aux.parcela     <> rowObject.parcela         
                          AND tt-parcelas-aux.un          <> rowObject.un NO-LOCK)
            AND NOT CAN-FIND (FIRST item-fornec
                              WHERE item-fornec.it-codigo = tt-ordem-compra.it-codigo
                                AND item-fornec.ativo)
            AND tt-ordem-compra.it-codigo <> "":U THEN DO:
                
                {method/svc/errors/inserr.i &ErrorNumber="3995" &ErrorType="EMS":U &ErrorSubType="ERROR":U &ErrorParameters="' '"}                               
            END.
        END.
        ELSE DO:
    
            IF tt-ordem-compra.nr-contrato <> 0 THEN DO:
                FOR FIRST item-fornec FIELDS(it-codigo cod-emitente ativo) 
                    WHERE item-fornec.it-codigo = tt-ordem-compra.it-codigo 
                      AND item-fornec.cod-emitente = tt-ordem-compra.cod-emitente 
                      AND item-fornec.ativo  NO-LOCK: END.
    
                IF NOT AVAIL item-fornec THEN DO:
    
                    IF tt-ordem-compra.it-codigo = ?    
                    OR tt-ordem-compra.it-codigo = "":U
                    OR item.tipo-contr = 4 THEN DO:
                        
                        IF NOT CAN-FIND(FIRST tab-unidade 
                                        WHERE tab-unidade.un = rowObject.un) THEN DO:
    
                            {method/svc/errors/inserr.i &ErrorNumber="846" &ErrorType="EMS":U &ErrorSubType="ERROR":U &ErrorParameters="' '"}                                       
                        END.
                                      
                        IF CAN-FIND(FIRST tt-parcelas-aux 
                                    WHERE tt-parcelas-aux.numero-ordem = tt-ordem-compra.numero-ordem 
                                      AND tt-parcelas-aux.un           <> rowObject.un
                                      AND tt-ordem-compra.it-codigo    <> "":U                        
                                      AND item.tipo-contr              <> 4 NO-LOCK) THEN DO:
                            
                            {method/svc/errors/inserr.i &ErrorNumber="3995" &ErrorType="EMS":U &ErrorSubType="ERROR":U &ErrorParameters="' '"}                                                 
                        END.
                    END.
                    ELSE DO:
                        IF rowObject.un <> item.un THEN DO:
                            
                            IF param-compra.log-multi-unid-medid THEN DO:
    
                                IF NOT CAN-FIND(FIRST item-fornec-umd
                                                WHERE item-fornec-umd.it-codigo    = item-fornec.it-codigo
                                                  AND item-fornec-umd.cod-emitente = item-fornec.cod-emitente
                                                  AND item-fornec-umd.unid-med-for = Rowobject.un
                                                  AND item-fornec-umd.log-ativo) THEN DO:
    
                                    {method/svc/errors/inserr.i &ErrorNumber="51523"
                                                                &ErrorType="EMS"
                                                                &ErrorSubType="ERROR"
                                                                &ErrorParameters="item-fornec.it-codigo + '~~~~' + string(item-fornec.cod-emitente) + '~~~~' + Rowobject.un"}
                                END.
                            END.
                            ELSE DO:
                                {method/svc/errors/inserr.i &ErrorNumber="3359" &ErrorType="EMS":U &ErrorSubType="ERROR":U &ErrorParameters="' '"}
                            END.
                        END.
                    END.
                END.
                ELSE DO:
                    IF rowObject.un <> item.un THEN DO:
                        IF param-compra.log-multi-unid-medid THEN DO:
                            IF NOT CAN-FIND(FIRST item-fornec-umd
                                           WHERE item-fornec-umd.it-codigo    = item-fornec.it-codigo
                                             AND item-fornec-umd.cod-emitente = item-fornec.cod-emitente
                                             AND item-fornec-umd.unid-med-for = Rowobject.un
                                             AND item-fornec-umd.log-ativo) THEN DO:
                                
                                {method/svc/errors/inserr.i &ErrorNumber="51523"
                                                            &ErrorType="EMS"
                                                            &ErrorSubType="ERROR"
                                                            &ErrorParameters="item-fornec.it-codigo + '~~~~' + string(item-fornec.cod-emitente) + '~~~~' + Rowobject.un"}
                            END.
                        END.
                        ELSE DO:
                            {method/svc/errors/inserr.i &ErrorNumber="3359" &ErrorType="EMS":U &ErrorSubType="ERROR":U &ErrorParameters="' '"}
                        END.
                    END.
                END.
              
                FOR FIRST contrato-for FIELDS(nr-contrato dt-ini-validade dt-ter-validade)
                    WHERE contrato-for.nr-contrato = tt-ordem-compra.nr-contrato NO-LOCK: 
                    
                    IF rowObject.data-entrega < contrato-for.dt-ini-validade 
                    OR rowObject.data-entrega > contrato-for.dt-ter-validade THEN DO:
                        
                        {method/svc/errors/inserr.i &ErrorNumber="17538" &ErrorType="EMS":U &ErrorSubType="ERROR":U &ErrorParameters="' '"}
                    END. 
                END.
            END.    
        END.  
    END.
    
    IF CAN-FIND(FIRST tt-parcelas-aux 
                WHERE tt-parcelas-aux.numero-ordem  = tt-ordem-compra.numero-ordem 
                  AND tt-parcelas-aux.parcela       < rowObject.parcela 
                  AND tt-parcelas-aux.data-entrega  > rowObject.data-entrega 
                  AND tt-parcelas-aux.situacao     <> 4) THEN DO:
        
        {method/svc/errors/inserr.i &ErrorNumber="3997" &ErrorType="EMS":U &ErrorSubType="WARNING":U &ErrorParameters="' '"}                   
    END.
    IF CAN-FIND(FIRST tt-parcelas-aux 
                WHERE tt-parcelas-aux.numero-ordem  = tt-ordem-compra.numero-ordem 
                  AND tt-parcelas-aux.parcela       > rowObject.parcela 
                  AND tt-parcelas-aux.data-entrega  < rowObject.data-entrega 
                  AND tt-parcelas-aux.situacao     <> 4) THEN DO:
        
        {method/svc/errors/inserr.i &ErrorNumber="3996" &ErrorType="EMS":U &ErrorSubType="WARNING":U &ErrorParameters="' '"} 
    END.
    
    /**************************************************************************************************
    No UIB h† algumas validaá‰es aqui para "do  on error undo, retry:"
    Nessa BO, elas est∆o em outra procedure. Procure por b-evento1
    **************************************************************************************************/
    
    IF tt-ordem-compra.nr-contrato = 0 THEN DO:
        IF rowObject.nome-abrev <> "":U THEN DO:
            FOR FIRST emitente FIELDS(nome-abrev identific) 
                WHERE emitente.nome-abrev = rowObject.nome-abrev 
                  AND emitente.identific <> 2 NO-LOCK: END.
             
            IF NOT AVAIL emitente THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="895" &ErrorType="EMS":U &ErrorSubType="ERROR":U &ErrorParameters="' '"} 
            END.
        END.
    END.
    
    IF rowObject.nome-abrev <> "":U THEN DO:
        IF rowObject.pedido-clien <> "":U AND param-global.modulo-pd THEN DO:
            
            FOR FIRST ped-venda FIELDS(nome-abrev nr-pedcli cod-sit-aval cod-sit-ped) 
                WHERE ped-venda.nome-abrev = rowObject.nome-abrev 
                  AND ped-venda.nr-pedcli  = rowObject.pedido-clien NO-LOCK: END.
             
            IF NOT AVAIL ped-venda THEN DO:
                {utp/ut-liter.i "N∆o_encontrado_pedido_de_venda_informado" *}
                {method/svc/errors/inserr.i &ErrorNumber="6269" &ErrorType="EMS":U &ErrorSubType="ERROR":U &ErrorParameters="TRIM(RETURN-VALUE) + '.'"}
            END.
            ELSE DO:
                IF (ped-venda.cod-sit-aval <> 2 AND ped-venda.cod-sit-aval <> 3) THEN DO:
                    
                    {method/svc/errors/inserr.i &ErrorNumber="6270" &ErrorType="EMS":U &ErrorSubType="ERROR":U &ErrorParameters="' '"} 
               END.
    
               /* Pedido n∆o aprovado no WF de desconto */
               IF  para-ped.log-usa-aprovac-workflow AND ped-venda.log-aprov-workflow = NO THEN DO:
                   
                   {method/svc/errors/inserr.i &ErrorNumber="52327"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters=" ped-venda.nr-pedcli + '~~~~' + ped-venda.nome-abrev"}     
                   RETURN "NOK":U.
               END.
               
               /* N∆o pode ser Atendido Total - 3, Suspenso - 5 e Cancelado - 6 */
               IF  ped-venda.cod-sit-ped = 3 AND l-create THEN DO:
                   
                   {method/svc/errors/inserr.i &ErrorNumber="6271" &ErrorType="EMS":U &ErrorSubType="ERROR":U &ErrorParameters="' '"} 
               END.
     
               IF ped-venda.cod-sit-ped = 5 THEN DO:
                   
                   {method/svc/errors/inserr.i &ErrorNumber="6272" &ErrorType="EMS":U &ErrorSubType="ERROR":U &ErrorParameters="' '"}   
               END.
    
               IF ped-venda.cod-sit-ped = 6 THEN DO:
                   
                   {method/svc/errors/inserr.i &ErrorNumber="6273" &ErrorType="EMS":U &ErrorSubType="ERROR":U &ErrorParameters="' '"} 
               END.
     
               FOR FIRST ped-item FIELD (nome-abrev nr-pedcli nr-sequencia)
                   WHERE ped-item.nome-abrev   = rowObject.nome-abrev 
                     AND ped-item.nr-pedcli    = rowObject.pedido-clien  
                     AND ped-item.nr-sequencia = rowObject.nr-sequencia NO-LOCK: END.
    
               IF NOT AVAIL ped-item THEN DO:
                   
                   {utp/ut-liter.i "N∆o_existe_item_no_pedido_de_venda_para_a_sequància_informada" *}
                   {method/svc/errors/inserr.i &ErrorNumber="6269" &ErrorType="EMS":U &ErrorSubType="ERROR":U &ErrorParameters="TRIM(RETURN-VALUE) + '.'"}
               END.
            END.
        END.
    END.
    
    FOR FIRST item-fornec-estab FIELDS(it-codigo cod-estabel cod-emitente ativo tempo-ressup)
        WHERE item-fornec-estab.it-codigo    = tt-ordem-compra.it-codigo
          AND item-fornec-estab.cod-estabel  = tt-ordem-compra.cod-estabel
          AND item-fornec-estab.cod-emitente = tt-ordem-compra.cod-emitente
          AND item-fornec-estab.ativo NO-LOCK:
    END.
    IF  AVAIL item-fornec-estab THEN DO:
        ASSIGN dt-ressup = item-fornec-estab.tempo-ressup
               nova-dt   = TODAY + dt-ressup.
    
        {utp/ut-liter.i "(Tempo_Ressupr)_informado_na_Manutená∆o_Item_Fornecedor_Estabelecimento" *}
        ASSIGN c-lbl-dias-ressup = TRIM(RETURN-VALUE).
    END.
    ELSE DO:
        FOR FIRST item-fornec FIELDS(it-codigo cod-emitente ativo tempo-ressup)
            WHERE item-fornec.it-codigo    = tt-ordem-compra.it-codigo
              AND item-fornec.cod-emitente = tt-ordem-compra.cod-emitente
              AND item-fornec.ativo NO-LOCK:
        END.
        IF  AVAIL item-fornec THEN DO:
            ASSIGN dt-ressup = item-fornec.tempo-ressup
                   nova-dt   = TODAY + dt-ressup.
    
            {utp/ut-liter.i "(Tempo_Ressupr)_informado_na_Manutená∆o_Itens_Fornecedor" *}
            ASSIGN c-lbl-dias-ressup = TRIM(RETURN-VALUE).
        END.
        ELSE DO:
            {utp/ut-liter.i "(Ressupr_Compras_+_Ressupr_Fornec)" *}
            ASSIGN c-lbl-dias-ressup = TRIM(RETURN-VALUE).
    
            IF AVAIL item-uni-estab THEN 
               ASSIGN dt-ressup = /* item-uni-estab.res-cq-comp + */ item-uni-estab.res-int-comp + item-uni-estab.res-for-comp
                      nova-dt   = TODAY + dt-ressup.
            ELSE DO:
                 IF AVAIL item THEN
                    ASSIGN dt-ressup = /* item.res-cq-comp + */ item.res-int-comp + item.res-for-comp
                           nova-dt   = TODAY + dt-ressup.
            END.
        END.
    END.
    
    ASSIGN dt-entrega = rowObject.data-entrega - TODAY.
    IF dt-ressup > dt-entrega AND rowObject.situacao <> 6  THEN DO:
        /* A mensagem 18883 foi subtituida pela 26505 */
        {method/svc/errors/inserr.i &ErrorNumber="26505" &ErrorType="EMS":U &ErrorSubType="INFORMATION":U &ErrorParameters="c-lbl-dias-ressup"}
    END.   
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateSegcc0300 DBOProgram 
PROCEDURE validateSegcc0300 :
/*------------------------------------------------------------------------------
  Purpose: Configura mensagem de erro a ser mostrada para o usu†rio logado quanto Ö inserá∆o, 
           alteraá∆o e remoá∆o de um pedido de compra caso este n∆o tenha acesso.
  Parameters: 
  Notes: VALIDAÄ«O PARA SER EXECUTADA DO PROGRAMA CC0300 OU DAS TELAS FILHO 
         PARA CONTROLAR SEGURANÄA POR USUµRIO PARA AÄÂES(INSERÄ«O, ALTERAÄ«O OU REMOÄ«O) 
         SOB PEDIDO DE COMPRA 
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-permissao   AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER pl-emergencial AS LOGICAL NO-UNDO.
    DEFINE INPUT PARAMETER pi-situacao    AS INTEGER NO-UNDO.

    DEFINE VARIABLE i-tipo-docum AS INTEGER             NO-UNDO.
    DEFINE VARIABLE l-permissao  AS LOGICAL INITIAL YES NO-UNDO.
    DEFINE VARIABLE c-param1     AS CHARACTER           NO-UNDO.
    DEFINE VARIABLE c-param2     AS CHARACTER           NO-UNDO.

    IF NOT l-seg-cc0300 THEN RETURN "OK":U.

    ASSIGN i-tipo-docum = IF pl-emergencial = NO THEN 
                            (IF pi-situacao = 2  THEN 5  ELSE 6)
                          ELSE 
                              (IF pi-situacao = 2 THEN 7 ELSE 8).

    RUN cdp/cdapi181.p (INPUT c-seg-usuario, INPUT i-tipo-docum, INPUT pi-permissao, OUTPUT l-permissao).

    IF l-permissao = NO THEN DO:

        CASE i-tipo-docum:
            WHEN 5 THEN DO:
                {utp/ut-liter.i Ordens_de_Compra_em_Pedidos_Normais_N∆o_Emitidos mcc R}
                ASSIGN c-param2 = TRIM(RETURN-VALUE).
            END.
            WHEN 6 THEN DO:
                {utp/ut-liter.i Ordens_de_Compra_em_Pedidos_Normais_Emitidos mcc R}
                ASSIGN c-param2 = TRIM(RETURN-VALUE).
            END.
            WHEN 7 THEN DO:
                {utp/ut-liter.i Ordens_de_Compra_em_Pedidos_Emergenciais_N∆o_Emitidos mcc R}
                ASSIGN c-param2 = TRIM(RETURN-VALUE).
            END.
            WHEN 8 THEN DO:
                {utp/ut-liter.i Ordens_de_Compra_em_Pedidos_Emergenciais_Emitidos mcc R}
                ASSIGN c-param2 = TRIM(RETURN-VALUE).
            END.
        END CASE.

        IF pi-permissao = 1 THEN DO:
            {utp/ut-liter.i incluir mcc R}
            ASSIGN c-param1 = TRIM(RETURN-VALUE).
        END.
        ELSE 
            IF pi-permissao = 2 THEN DO:
                {utp/ut-liter.i alterar mcc R}
                ASSIGN c-param1 = TRIM(RETURN-VALUE).
            END.
            ELSE DO:
                {utp/ut-liter.i eliminar mcc R}
                ASSIGN c-param1 = TRIM(RETURN-VALUE).
            END.

        {method/svc/errors/inserr.i &ErrorNumber="18728" &ErrorType="EMS":U &ErrorSubType="ERROR":U &ErrorParameters= "c-param1 + '~~~~'  + c-param2"}
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidateStatusFornec DBOProgram 
PROCEDURE ValidateStatusFornec :
/*------------------------------------------------------------------------------
  Purpose: Verificar a situacao do fonecedor para validar alteracoes na parcela    
  Parameters:  <none>
  Notes:      
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-dt-transacao   AS DATE    FORMAT "99/99/9999":U NO-UNDO.
    DEFINE INPUT PARAMETER p-i-cod-emitente AS INTEGER FORMAT ">>>>>>>>9":U  NO-UNDO.

    DEFINE VARIABLE i-situacao AS INTEGER   NO-UNDO.
    DEFINE VARIABLE dt-vig-ini AS DATE      NO-UNDO.
    DEFINE VARIABLE dt-vig-fim AS DATE      NO-UNDO.
    DEFINE VARIABLE c-return   AS CHARACTER NO-UNDO.

    IF p-dt-transacao = ? THEN
        ASSIGN p-dt-transacao = TODAY.

    /**API que faz validacao dos fornecedores**/
    RUN cdp/cdapi029.p (INPUT  c-seg-usuario,           
                        INPUT  1,                       
                        INPUT  p-dt-transacao,   
                        INPUT  p-i-cod-emitente, 
                        OUTPUT i-situacao,
                        OUTPUT dt-vig-ini,
                        OUTPUT dt-vig-fim,
                        OUTPUT TABLE tt-erro).         

     ASSIGN c-return = RETURN-VALUE.

    /**Se o retorno for "NOK", significa que o fornecedor  Ç Inativo ou possui restricao p/ Compras**/
    FOR EACH tt-erro:
        IF NOT CAN-FIND(FIRST RowErrors
                        WHERE RowErrors.ErrorNumber = tt-erro.cd-erro) THEN DO:
            
            /**Grava na RowErrors a mensagem retornada pela API de validacao dos fornecedores**/
            IF c-return = "NOK":U THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="tt-erro.cd-erro"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U   
                                            &ErrorParameters="tt-erro.c-param"}        
            END.
            ELSE DO:
                {method/svc/errors/inserr.i &ErrorNumber="tt-erro.cd-erro"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="WARNING":U
                                            &ErrorParameters="tt-erro.c-param"}
            END.
        END.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateUpdateBusinessLogic DBOProgram 
PROCEDURE validateUpdateBusinessLogic :
/*------------------------------------------------------------------------------
  Purpose:     
   Validaá‰es de neg¢cio para Alteraá‰es.
   ParÉmetros:
   ipar1 : p-l-parc-quant-lote-min : Cadastrar parcelas com qtde menor que o lote m°nimo?   
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-l-parc-quant-lote-min AS LOGICAL NO-UNDO.

    DEFINE VARIABLE l-seq       AS LOGICAL      NO-UNDO.
    DEFINE VARIABLE l-elimina   AS LOGICAL      NO-UNDO.
    DEFINE VARIABLE c-desc-eve1 AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE c-desc-eve2 AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE da-eve-cot  AS DATE         NO-UNDO.
    DEFINE VARIABLE da-eve-ped  AS DATE         NO-UNDO.
    DEFINE VARIABLE i-seq-eve   AS INTEGER      NO-UNDO.
    
    DEFINE BUFFER b-evento1 FOR evento-ped.
    DEFINE BUFFER b-evento2 FOR evento-ped.

    FIND FIRST tt-parcelas-aux 
         WHERE tt-parcelas-aux.numero-ordem = prazo-compra.numero-ordem 
           AND tt-parcelas-aux.parcela      = prazo-compra.parcela NO-LOCK NO-ERROR.

    IF AVAIL tt-parcelas-aux THEN DO:
        IF AVAIL item THEN DO:
            IF tt-parcelas-aux.data-entrega <> prazo-compra.data-entrega THEN DO:
                {utp/ut-liter.i Cotar_Ordem_Numero * C}
                ASSIGN c-desc-eve1 = RETURN-VALUE.
                {utp/ut-liter.i Fechar_Pedido_p/_a_Ordem_num. * C}
                ASSIGN c-desc-eve2 = RETURN-VALUE.

                FOR EACH evento-ped FIELDS(numero-ordem seq-evento des-event) NO-LOCK 
                   WHERE evento-ped.numero-ordem = tt-parcelas-aux.numero-ordem  
                     AND (evento-ped.seq-evento  = 1 OR evento-ped.seq-evento = 2): 
                    
                    ASSIGN l-seq     = NO
                           l-elimina = NO.
                    
                    IF evento-ped.des-event =  c-desc-eve1 + " ":U + STRING(tt-parcelas-aux.numero-ordem,"zzzzz9,99":U) THEN DO:

                        ASSIGN da-eve-cot = (prazo-compra.data-entrega - (item.res-for-comp + item.res-cq-comp + item.res-int-comp)). 

                         CREATE b-evento1.
                         ASSIGN b-evento1.numero-ordem  = tt-parcelas-aux.numero-ordem
                                b-evento1.dt-evento     = da-eve-cot  
                                b-evento1.ind-sit-event = 1
                                b-evento1.des-event     = c-desc-eve1 + " ":U + STRING(tt-parcelas-aux.numero-ordem,"zzzzz9,99":U)
                                b-evento1.cod-comprado  = tt-ordem-compra.cod-comprado. 

                         FOR LAST b-evento2 FIELDS(numero-ordem seq-evento dt-evento) 
                            WHERE b-evento2.numero-ordem = evento-ped.numero-ordem NO-LOCK: END.

                         IF AVAIL b-evento2 THEN
                             ASSIGN i-seq-eve                  = b-evento2.seq-evento + 1
                                    b-evento1.seq-evento       = i-seq-eve
                                    tt-ordem-compra.seq-evento = b-evento1.seq-evento.
                         ELSE 
                             ASSIGN b-evento1.seq-evento = 1.
                         
                         ASSIGN l-seq     = NO.
                                l-elimina = YES.
                    END.
                    IF evento-ped.des-event = c-desc-eve2 + " ":U + STRING(tt-parcelas-aux.numero-ordem,"zzzzz9,99":U) THEN DO:

                        ASSIGN da-eve-ped = prazo-compra.data-entrega - (item.res-for-comp + item.res-cq-comp).

                        CREATE b-evento1.
                        ASSIGN b-evento1.numero-ordem  = tt-parcelas-aux.numero-ordem
                               b-evento1.dt-evento     = da-eve-ped
                               b-evento1.ind-sit-event = 1
                               b-evento1.des-event     = c-desc-eve2 + " ":U + STRING(tt-parcelas-aux.numero-ordem,"zzzzz9,99":U)
                               b-evento1.cod-comprado  = tt-ordem-compra.cod-comprado.
                        
                        FOR LAST b-evento2 FIELDS(numero-ordem seq-evento dt-evento) 
                           WHERE b-evento2.numero-ordem = evento-ped.numero-ordem NO-LOCK: END.

                        IF AVAIL b-evento2 THEN
                            ASSIGN i-seq-eve                  = b-evento2.seq-evento + 1
                                   b-evento1.seq-evento       = i-seq-eve
                                   tt-ordem-compra.seq-evento = b-evento1.seq-evento.
                        ELSE
                            ASSIGN b-evento1.seq-evento = 2.
                    
                         ASSIGN l-seq     = YES
                                l-elimina = YES.
                    END.

                    IF l-elimina THEN DO:
                        FIND FIRST b-evento2 
                             WHERE ROWID(b-evento2) = ROWID(evento-ped) EXCLUSIVE-LOCK NO-ERROR.
                        IF AVAIL b-evento2 THEN
                            DELETE b-evento2.
                        IF l-seq THEN 
                            LEAVE.
                    END.
                END.
            END. /* tt-parcelas-aux.data-entrega <> prazo-compra.data-entrega */
        END. /* Avail Item */

        /* Cria Prog-Emit */ 
        IF  tt-ordem-compra.nr-contrato <> 0 AND tt-ordem-compra.cod-emitente <> 0 
        AND ((tt-parcelas-aux.quantidade  <> prazo-compra.quantidade) OR (tt-parcelas-aux.data-entrega <> prazo-compra.data-entrega)) THEN DO:

            FOR FIRST emitente FIELDS(cod-emitente prog-emit)
                WHERE emitente.cod-emitente = tt-ordem-compra.cod-emitente NO-LOCK: END.

            IF AVAILABLE emitente AND emitente.prog-emit = NO THEN DO:
                FIND CURRENT emitente EXCLUSIVE-LOCK.
                IF AVAIL emitente THEN
                    ASSIGN emitente.prog-emit = YES.
            END.
        END.
    END. /* AVAIL tt-parcelas-aux */
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateUpdateManutOrdCompra DBOProgram 
PROCEDURE validateUpdateManutOrdCompra :
/*------------------------------------------------------------------------------
  Purpose:     
     Validaá‰es para alteraá∆o.
  Parameters:  <none>
     ipar1  : table for rowObject     : Tabela de dados
     ipar2  : tt-parcelas-aux         : Tabela com todos as parcelas da ordem corrente
     ipar3  : p-cParamManutOrd        : funá∆o geral do programa cc0300b (inclus∆o ou modificaá∆o)
     ipar4  : r-chave                 : Rowid do registro que est† sofrendo alteraá∆o
     ipar5  : p-dt-valid-ini          : Data para validaá∆o inicial
     ipar6  : p-dt-valid-fim          : Data para validaá∆o final
     ipar7  : p-c-usuar-corren        : Usu†rio corrente
     ipar8  : p-l-parc-quant-lote-min : Cadastrar parcelas com quantidade menor que o lote m°nimo?
     ipar9  : p-l-exp-cli-ped         : Exportar alteraá∆o de clientes/pedido para outras parcelas?
     ipar10 : p-l-cad-ped-pend        : Cadastrar Pedidos pendentes?
     ipar11 : p-l-lote                : 
     opar12 : table for tt-erro       : Tabela de erros
  Notes:       
     usada pelo wcc0301b.w, wcc0310b5.w, cc0301 (Thin), cc0310 (Thin)
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE                   FOR RowObject.
    DEFINE INPUT  PARAMETER TABLE                   FOR tt-parcelas-aux.
    DEFINE INPUT  PARAMETER p-cParamManutOrd        AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER p-r-chave               AS ROWID        NO-UNDO.
    DEFINE INPUT  PARAMETER p-dt-valid-ini          AS DATE         NO-UNDO.
    DEFINE INPUT  PARAMETER p-dt-valid-fim          AS DATE         NO-UNDO.
    DEFINE INPUT  PARAMETER p-c-usuar-corren        AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER p-l-parc-quant-lote-min AS LOGICAL      NO-UNDO.
    DEFINE INPUT  PARAMETER p-l-exp-cli-ped         AS LOGICAL      NO-UNDO.
    DEFINE INPUT  PARAMETER p-l-cad-ped-pend        AS LOGICAL      NO-UNDO.
    DEFINE INPUT  PARAMETER p-l-lote                AS LOGICAL      NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE                   FOR rowErrors.

    ASSIGN l-exp-cli-ped = p-l-exp-cli-ped.
    
    ASSIGN l-parc-quant-lote-min = p-l-parc-quant-lote-min.
    ASSIGN cParamManutOrd = p-cParamManutOrd
           l-create       = NO.
    ASSIGN c-seg-usuario = IF p-c-usuar-corren <> "":U THEN p-c-usuar-corren
                           ELSE c-seg-usuario.
    ASSIGN r-chave = p-r-chave.

    EMPTY TEMP-TABLE rowErrors.

    FIND FIRST rowObject NO-ERROR.
    
    IF cParamManutOrd = "Update":U THEN DO:

        FOR FIRST prazo-compra FIELDS(numero-ordem un data-entrega cod-refer qtd-sal-forn) 
            WHERE ROWID(prazo-compra) = r-chave NO-LOCK: END.

        IF AVAIL prazo-compra THEN DO:

            FOR FIRST ordem-compra FIELDS(numero-ordem num-pedido) 
                WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem NO-LOCK: END.

            IF AVAIL ordem-compra THEN
                FOR FIRST pedido-compr FIELDS(num-pedido situacao end-entrega data-pedido cod-emitente) 
                    WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK: END.

            IF AVAIL pedido-compr THEN DO:
                
                /**Na modificacao: dependendo da situacao do fornecedor, permite apenas zerar o saldo ou passar a parcela para recebida**/
                IF (    prazo-compra.qtd-sal-forn <> rowObject.qtd-sal-forn
                    AND rowObject.qtd-sal-forn    = 0
                    AND (   prazo-compra.situacao = rowObject.situacao
                         OR rowObject.situacao    = 6)
                    AND prazo-compra.parcela      = rowObject.parcela
                    AND prazo-compra.quantidade   = rowObject.quantidade
                    AND prazo-compra.un           = rowObject.un
                    AND prazo-compra.data-entrega = rowObject.data-entrega
                    AND prazo-compra.nome-abrev   = rowObject.nome-abrev
                    AND prazo-compra.cod-refer    = rowObject.cod-refer
                    AND prazo-compra.pedido-clien = rowObject.pedido-clien
                    AND prazo-compra.nr-sequencia = rowObject.nr-sequencia) THEN.

                ELSE IF (    prazo-compra.situacao <> rowObject.situacao
                         AND rowObject.situacao        = 6
                         AND prazo-compra.parcela      = rowObject.parcela
                         AND prazo-compra.quantidade   = rowObject.quantidade
                         AND prazo-compra.un           = rowObject.un
                         AND prazo-compra.data-entrega = rowObject.data-entrega
                         AND prazo-compra.nome-abrev   = rowObject.nome-abrev
                         AND prazo-compra.cod-refer    = rowObject.cod-refer
                         AND prazo-compra.pedido-clien = rowObject.pedido-clien
                         AND prazo-compra.nr-sequencia = rowObject.nr-sequencia
                         AND (   prazo-compra.qtd-sal-forn = rowObject.qtd-sal-forn
                              OR rowObject.qtd-sal-forn    = 0)) THEN.
                      ELSE 
                          /**Valida a situacao do fornecedor**/
                          RUN ValidateStatusFornec ( ?, pedido-compr.cod-emitente ).
            END.
        END.
    END.
    ELSE DO:
        IF AVAIL tt-ordem-compra THEN   /* vem da inputTableOrdemCompra */
            FOR FIRST pedido-compr FIELDS(num-pedido situacao end-entrega data-pedido emergencial) 
                WHERE pedido-compr.num-pedido = tt-ordem-compra.num-pedido NO-LOCK: END.

        IF AVAIL pedido-compr THEN 
            /* VALIDAÄ«O DO PROGRAMA CC0300 PARA CONTROLAR SEGURANÄA POR USUµRIO PARA PEDIDO DE COMPRA */
            IF l-seg-cc0300 = YES THEN
                RUN validateSegCC0300 (INPUT 2, INPUT pedido-compr.emergencial, INPUT pedido-compr.situacao).
    END.
    
    ASSIGN cParamModo = "mod":U.

    RUN validateFieldsBusinessLogic (INPUT p-dt-valid-ini,
                                     INPUT p-dt-valid-fim,
                                     INPUT c-seg-usuario,
                                     INPUT p-l-cad-ped-pend,
                                     INPUT p-l-lote).

    /* O ALT-PED da Modificaá∆o da Parcela Ç gerado s¢ AO SALVAR A TRANSAÄ«O: abaixo apenas Ç validado */
    FOR FIRST prazo-compra FIELDS(numero-ordem un data-entrega cod-refer qtd-sal-forn) 
        WHERE ROWID(prazo-compra) = r-chave NO-LOCK: END.

    IF AVAIL prazo-compra THEN DO:

        FOR FIRST ordem-compra FIELDS(numero-ordem num-pedido)
            WHERE ordem-compra.numero-ordem = prazo-compra.numero-ordem NO-LOCK: END.

        IF AVAIL ordem-compra THEN DO:

            FOR FIRST cotacao-item FIELDS(numero-ordem cot-aprovada un)
                WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                  AND cotacao-item.cot-aprovada NO-LOCK: END.

            IF AVAIL cotacao-item THEN DO:
                
                FOR FIRST pedido-compr FIELDS(num-pedido situacao)
                    WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK: END.
            
                IF AVAIL pedido-compr AND pedido-compr.situacao = 1 /* Impresso */THEN 
                    ASSIGN l-cc0308 = YES.
                ELSE 
                    ASSIGN l-cc0308 = NO.
            
                IF l-cc0308 THEN DO:
                    RUN validaParcelaOrdemCompraPedImp (INPUT ROWID(prazo-compra),
                                                        INPUT rowObject.data-entrega,
                                                        INPUT rowObject.cod-refer,
                                                        INPUT rowObject.qtd-sal-forn).
                END.
            END.
        END.
    END.
    
    /* CHAMADA EPC - GRENDENE - VALIDADE PARCELA COM QTDE ALOCADA */
    {method/svc/custom/custom.i &Event = "validateUpdateManutOrdCompra"}
    FIND FIRST rowErrors NO-LOCK NO-ERROR.
    IF NOT AVAIL rowErrors THEN DO:
        FIND FIRST {&TABLENAME} 
             WHERE ROWID({&TABLENAME}) = r-chave EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        ASSIGN rChave = r-chave.
    END.

    RUN validaPregaoEletronico. 

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateUpdatePrazoContrat DBOProgram 
PROCEDURE validateUpdatePrazoContrat :
/*------------------------------------------------------------------------------
  Purpose: 
      Realiza validaá‰es de modificaá∆o, quando parcela est† relacionada a um contrato  
  Parameters:
      INPUT - c-usuario (char) - usu†rio que est† realizando a alteraá∆o da parcela
  Notes:  
      Deve-se utilizar o mÇtodo setRecord para passar a parcela que ser† alterada     
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER c-usuario AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE l-permissao     AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-erro          AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-return-nok    AS LOGICAL     NO-UNDO.

    FIND FIRST RowObject NO-ERROR.

    IF NOT AVAIL RowObject THEN DO:
        {utp/ut-liter.i Parcela * r}
        {method/svc/errors/inserr.i &ErrorNumber="2" &ErrorType="EMS":U &ErrorSubType="ERROR":U &ErrorParameters="TRIM(RETURN-VALUE)"}
        RETURN "NOK":U.
    END.

    /* Valida permiss∆o do usu†rio */
    RUN cdp/cdapi181.p (INPUT  IF c-usuario = "":U THEN c-seg-usuario ELSE c-usuario, INPUT  2, INPUT  2, OUTPUT l-permissao).
    IF NOT l-permissao THEN DO:
        {utp/ut-liter.i Modificar * r}
        ASSIGN c-lbl-trad = TRIM(RETURN-VALUE).
        {utp/ut-liter.i Itens_do_Contrato * r}
        ASSIGN c-lbl-trad = c-lbl-trad + '~~':U + TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="18728" &ErrorType="EMS" &ErrorSubType="ERROR" &ErrorParameters="c-lbl-trad"}
        ASSIGN l-return-nok = YES.
    END.

    FOR FIRST ordem-compra FIELDS(numero-ordem nr-contrato it-codigo num-seq-item)
        WHERE ordem-compra.numero-ordem = RowObject.numero-ordem NO-LOCK: END.

    FOR FIRST contrato-for FIELDS(nr-contrato log-libera gestor-tecnico cod-estab-gestor ind-sit-contrat dt-ini-validade dt-ter-validade)
        WHERE contrato-for.nr-contrato = ordem-compra.nr-contrato NO-LOCK: END.

    IF NOT AVAIL contrato-for OR NOT contrato-for.log-libera THEN DO: /* Item inativo do contrato */
        {method/svc/errors/inserr.i &ErrorNumber="7838" &ErrorType="EMS" &ErrorSubType="ERROR"}
        ASSIGN l-return-nok = YES.
    END.

    FOR FIRST usuar-mater FIELDS(cod-usuario cont-acesso-cc sc-codigo perm-alt-cont)
        WHERE usuar-mater.cod-usuario = IF c-usuario = "":U THEN c-seg-usuario ELSE c-usuario NO-LOCK: END.

    FOR FIRST b-usuar-mater FIELDS(sc-codigo cod-usuario)
        WHERE b-usuar-mater.cod-usuario = contrato-for.gestor-tecnico NO-LOCK: END.

    IF usuar-mater.cont-acesso-cc AND usuar-mater.sc-codigo <> b-usuar-mater.sc-codigo THEN DO:
        {utp/ut-liter.i Modificar_Parcelas_de_Contratos * r}
        ASSIGN c-lbl-trad = TRIM(RETURN-VALUE).
        {utp/ut-liter.i de_outro_Centro_de_Custo * r}
        ASSIGN c-lbl-trad = c-lbl-trad + '~~':U + TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="18728" &ErrorType="EMS" &ErrorSubType="ERROR" &ErrorParameters="c-lbl-trad"}
        ASSIGN l-return-nok = YES.
    END.

    IF usuar-mater.perm-alt-cont = NO AND usuar-mater.cod-usuario <> b-usuar-mater.cod-usuario THEN DO:
        {utp/ut-liter.i Modificar_Parcelas_de_Contratos * r}
        ASSIGN c-lbl-trad = TRIM(RETURN-VALUE).
        {utp/ut-liter.i de_outro_Usuˇrio * r}
        ASSIGN c-lbl-trad = c-lbl-trad + '~~':U + TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="18728" &ErrorType="EMS" &ErrorSubType="ERROR" &ErrorParameters="c-lbl-trad"}
        ASSIGN l-return-nok = YES.
    END.

    IF NOT AVAIL param-global THEN FIND FIRST param-global NO-LOCK NO-ERROR.
    IF param-global.modulo-mp AND contrato-for.cod-estab-gestor <> "":U THEN DO:
        RUN ccp/ccapi199.p (INPUT "ordem-contrato":U, INPUT ROWID(ordem-compra), OUTPUT l-erro).
        IF l-erro THEN DO: /*Ordem so pode ser alterado no estabelecimento gestor ou executor.*/
            {utp/ut-liter.i Ordem}
            ASSIGN c-lbl-trad = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Gestor_ou_Executor}
            ASSIGN c-lbl-trad = c-lbl-trad + '~~':U + TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="18200" &ErrorType="EMS" &ErrorSubType="ERROR" &ErrorParameters="c-lbl-trad"}
            ASSIGN l-return-nok = YES.
        END.
    END.

    FOR FIRST item-contrat FIELDS(nr-contrato it-codigo num-seq-item ind-sit-item)
        WHERE item-contrat.nr-contrato  = ordem-compra.nr-contrato
          AND item-contrat.it-codigo    = ordem-compra.it-codigo
          AND item-contrat.num-seq-item = ordem-compra.num-seq-item NO-LOCK: END.
  
    IF contrato-for.ind-sit-contrat <> 2 OR (AVAIL item-contrat AND item-contrat.ind-sit-item <> 2) THEN DO: /* 2 - Emitido */
        {method/svc/errors/inserr.i &ErrorNumber="28329" &ErrorType="EMS" &ErrorSubType="ERROR"}
         ASSIGN l-return-nok = YES.
    END.


    IF RowObject.quant-saldo < RowObject.dec-1 THEN DO: /* Quantidade Saldo n∆o pode ser inferior a quantidade alocada no recebimento. */
       {method/svc/errors/inserr.i &ErrorNumber="17945" &ErrorType="EMS" &ErrorSubType="ERROR"}
       ASSIGN l-return-nok = YES.
    END.

    IF RowObject.data-entrega < contrato-for.dt-ini-validade
    OR RowObject.data-entrega > contrato-for.dt-ter-validade THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="17538" &ErrorType="EMS" &ErrorSubType="ERROR"} /*Data entrega fora do periodo de validade*/ 
        ASSIGN l-return-nok = YES.
    END.

    IF l-return-nok THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

