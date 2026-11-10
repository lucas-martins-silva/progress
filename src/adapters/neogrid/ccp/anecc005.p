/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANECC005 2.00.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i anecc005 MAN}
&ENDIF

/********************************************************************************
** Programa : anecc005.p
** Funcao   : Receiver da Inclusao do Pedido de Compra
** Data     : 07/2000
** Autor    : Anderson Elton Kruger
********************************************************************************/
FUNCTION foundErrors RETURNS LOGICAL FORWARD.
FUNCTION getNextParcel RETURNS INTEGER FORWARD.

/* Funcoes para ler a mensagem XML */
/*{adapters/neogrid/include/anein005.i}*/

/* Funcoes para envio dos erros para NeoGrid */
{adapters/neogrid/ftp/aneft002.i}
{adapters/neogrid/include/anein004.i}

/* Temp-Table and Buffer definitions */
{inbo/boin057.i "tt-cond-especif"}
{inbo/boin082.i "tt-cotacao-item"}
{inbo/boin274.i "tt-ordem-compra"}
{inbo/boin295.i "tt-pedido-compr"}
{inbo/boin356.i "tt-prazo-compra"}

DEF TEMP-TABLE tt-cotacao-item-defaults LIKE tt-cotacao-item.
DEF TEMP-TABLE tt-ordem-compra-unique   LIKE tt-ordem-compra.
DEF TEMP-TABLE tt-cotacao-item-unique   LIKE tt-cotacao-item.
DEF TEMP-TABLE tt-prazo-compra-unique   LIKE tt-prazo-compra.

/* Tem-table RowErros usada pelas BOs. Os erros encontrados sÆo gravados nesta temp-table */
{method/dbotterr.i}
{utp/ut-glob.i}

/* Temp-tables como parametro de entrada */
DEF INPUT PARAM TABLE FOR tt-pedido-compr.
DEF INPUT PARAM TABLE FOR tt-ordem-compra.
DEF INPUT PARAM TABLE FOR tt-prazo-compra.
DEF INPUT PARAM TABLE FOR tt-cotacao-item.
DEF INPUT PARAM TABLE FOR tt-cond-especif.

DEF VAR h-boin295   AS HANDLE NO-UNDO.
DEF VAR h-boin274sd AS HANDLE NO-UNDO.
DEF VAR h-boin274   AS HANDLE NO-UNDO.
DEF VAR h-boin274vl AS HANDLE NO-UNDO.
DEF VAR h-boin356   AS HANDLE NO-UNDO.
DEF VAR h-boin082vl AS HANDLE NO-UNDO.
DEF VAR h-boin082sd AS HANDLE NO-UNDO.
DEF VAR c-seg-usuario-active   AS CHAR NO-UNDO.
DEF VAR c-cod-estabel          AS CHAR NO-UNDO.
DEF VAR i-num-pedido-ng        AS INT NO-UNDO.
DEF SHARED VAR c-docidentifier AS CHAR NO-UNDO.

c-seg-usuario-active = c-seg-usuario.
RUN LoadBOs.
RUN ValidateAndCreatePurchaseOrder.
RUN ReleaseBOs.
IF foundErrors() THEN RUN adapters/neogrid/ftp/aneft002.p (INPUT TABLE tt-erro-neogrid).
ELSE RUN buildPurchaseOrderAcknowledgement.

c-seg-usuario = c-seg-usuario-active.

PROCEDURE ValidateAndCreatePurchaseOrder:
/*    DEF VAR i-tp-despesa as integer no-undo.*/
    DEF VAR r-cotacao-item AS ROWID NO-UNDO.
    DEF VAR l-inclui-item-fornec AS LOGICAL NO-UNDO.
    DEF VAR c-un AS CHAR NO-UNDO.
    DEF VAR da-dataentrega AS DATE NO-UNDO.
    DEF VAR l-none AS LOGICAL NO-UNDO.
    DEF VAR i-none AS INTEGER NO-UNDO.

    bloco:
    FOR FIRST tt-pedido-compr:
        /* Removido por Giovane/Developer em 13/05/2004 */
        /*
        FOR FIRST emitente FIELDS (tp-desp-padrao) NO-LOCK
            WHERE emitente.cod-emitente = tt-pedido-compr.cod-emitente:
            i-tp-despesa = emitente.tp-desp-padrao.
        END.
        */

        tt-pedido-compr.frete = 1.
        i-num-pedido-ng = tt-pedido-compr.num-pedido.
        RUN geraNumeroPedidoCompra IN h-boin295 (OUTPUT tt-pedido-compr.num-pedido).
        RUN openQuery IN h-boin295 (INPUT 1).
        RUN setRecord IN h-boin295 (INPUT TABLE tt-pedido-compr).
        RUN validateCreatePedEmerg IN h-boin295 (INPUT TABLE tt-pedido-compr, OUTPUT i-none).
        RUN SendErrorsToNeogrid (INPUT h-boin295).
        IF RETURN-VALUE = "OK":U THEN DO:

            /* Criando o pedido de compra */
            RUN createRecord IN h-boin295.
            RUN SendErrorsToNeogrid (INPUT h-boin295).
            IF NOT foundErrors() THEN DO:
                FOR EACH tt-ordem-compra EXCLUSIVE-LOCK:
                    ASSIGN /*tt-ordem-compra.tp-despesa = i-tp-despesa*/ 
                           da-dataentrega             = ?
                           c-cod-estabel              = tt-ordem-compra.cod-estabel.
                    
                    FIND FIRST ordem-compra NO-LOCK 
                         WHERE ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem NO-ERROR.
                    IF NOT AVAIL ordem-compra THEN DO:

                        RUN geraNumeroOrdemPedEmerg IN h-boin274sd (OUTPUT tt-ordem-compra.numero-ordem,
                                                                    OUTPUT TABLE rowErrors).
                        RUN SendErrorsToNeogrid (INPUT h-boin274sd).
                        IF NOT foundErrors() THEN DO:
    
                            FOR EACH tt-prazo-compra EXCLUSIVE-LOCK
                                WHERE tt-prazo-compra.char-1 = tt-ordem-compra.char-1:
                                ASSIGN tt-prazo-compra.numero-ordem = tt-ordem-compra.numero-ordem
                                       tt-prazo-compra.char-1       = ""
                                       c-un                         = tt-prazo-compra.un.
                                IF tt-prazo-compra.parcela = 0 THEN 
                                    tt-prazo-compra.parcela = getNextParcel().
                                IF da-dataentrega = ? THEN 
                                   da-dataentrega = tt-prazo-compra.data-entrega.
                            END.
                            FOR EACH tt-cotacao-item EXCLUSIVE-LOCK
                                WHERE tt-cotacao-item.char-1 = tt-ordem-compra.char-1:
                                ASSIGN tt-cotacao-item.numero-ordem = tt-ordem-compra.numero-ordem
                                       tt-cotacao-item.preco-fornec = tt-cotacao-item.preco-unit
                                       tt-cotacao-item.un           = c-un
                                       tt-cotacao-item.cod-transp   = tt-pedido-compr.cod-transp
                                       tt-cotacao-item.char-1       = "".
                            END.
                            tt-ordem-compra.char-1       = "".
                            CREATE tt-ordem-compra-unique.
                            BUFFER-COPY tt-ordem-compra TO tt-ordem-compra-unique.
                            /* Criando a ordem de compra */
                            RUN openQuery IN h-boin274 (INPUT 1).
                            RUN setRecord IN h-boin274 (INPUT TABLE tt-ordem-compra-unique).
                            RUN validateCreatePedEmerg IN h-boin274vl (INPUT TABLE tt-ordem-compra-unique,
                                                                       INPUT YES,
                                                                       OUTPUT l-none, /* retorna se ir  chamar tela de manut */
                                                                       OUTPUT TABLE RowErrors,
                                                                       OUTPUT i-none).
                            RUN SendErrorsToNeogrid (INPUT h-boin274vl).
                            IF NOT foundErrors() THEN DO:
                                RUN createRecord IN h-boin274.
                                RUN SendErrorsToNeogrid (INPUT h-boin274).
                            END.
    
                            DELETE tt-ordem-compra-unique.
    
                            IF NOT foundErrors() THEN DO:
                                /* Criando as parcelas da ordem de compra */
                                FOR EACH tt-prazo-compra EXCLUSIVE-LOCK OF tt-ordem-compra:
                                    RUN openQuery IN h-boin356 (INPUT 1).
                                    CREATE tt-prazo-compra-unique.
                                    BUFFER-COPY tt-prazo-compra TO tt-prazo-compra-unique.
                                    RUN setRecord IN h-boin356 (INPUT TABLE tt-prazo-compra-unique).
                                    DELETE tt-prazo-compra-unique.
                                    RUN createRecord IN h-boin356.
                                    RUN SendErrorsToNeogrid (INPUT h-boin356).
                                    DELETE tt-prazo-compra.
                                END.
                                IF NOT foundErrors() THEN DO:
                                   FOR EACH tt-cotacao-item NO-LOCK OF tt-ordem-compra:
                                       RUN preparaCotacaoOrdemCompraPedEmerg IN h-boin082sd (INPUT tt-ordem-compra.numero-ordem,
                                                                                             INPUT tt-pedido-compr.num-pedido,
                                                                                             INPUT tt-pedido-compr.cod-emitente,
                                                                                             INPUT tt-ordem-compra.it-codigo,
                                                                                             INPUT tt-ordem-compra.cod-estabel,
                                                                                             INPUT tt-ordem-compra.qt-solic,
                                                                                             INPUT da-dataentrega,
                                                                                             INPUT-OUTPUT tt-ordem-compra.cod-comprado,
                                                                                             OUTPUT l-none,
                                                                                             OUTPUT l-none,
                                                                                             OUTPUT l-none,
                                                                                             OUTPUT l-none,
                                                                                             OUTPUT l-none,
                                                                                             OUTPUT l-none,
                                                                                             OUTPUT TABLE tt-cotacao-item-defaults).
                                       FIND FIRST tt-cotacao-item-defaults NO-ERROR.
                                       BUFFER-COPY tt-cotacao-item-defaults EXCEPT perc-descto
                                                                                   valor-descto
                                                                                   valor-frete
                                                                                   mo-codigo
                                                                                   preco-fornec
                                                                                   preco-unit 
                                                                                   un
                                                                                   cod-transp
                                                                                   numero-ordem
                                                                                   valor-taxa
                                                                                   aliquota-icm
                                                                                   aliquota-ipi
                                                                                   aliquota-iss
                                                                                   to tt-cotacao-item.
                                       DELETE tt-cotacao-item-defaults.
    
                                       CREATE tt-cotacao-item-unique.
                                       BUFFER-COPY tt-cotacao-item TO tt-cotacao-item-unique.
                                       
                                       RUN createUpdateCotacaoItem IN h-boin082vl (INPUT TABLE tt-cotacao-item-unique,
                                                                                   INPUT tt-ordem-compra.it-codigo,
                                                                                   INPUT yes,
                                                                                   INPUT "neogrid",
                                                                                   INPUT yes,
                                                                                   INPUT no,
                                                                                   INPUT-OUTPUT r-cotacao-item,
                                                                                   OUTPUT l-inclui-item-fornec,
                                                                                   OUTPUT TABLE rowErrors).
                                       DELETE tt-cotacao-item-unique.
                                       RUN SendErrorsToNeogrid (INPUT h-boin082vl).
                                       IF NOT foundErrors() THEN DO:
                                           FOR FIRST ordem-compra EXCLUSIVE-LOCK 
                                               WHERE ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem:
                                               ordem-compra.num-pedido = tt-pedido-compr.num-pedido.
                                               RELEASE ordem-compra.
                                           END.
                                           RUN atualizaDadosCotacaoItemPedEmerg IN h-boin082vl (INPUT "Add":U,
                                                                                                INPUT "neogrid",
                                                                                                INPUT r-cotacao-item,
                                                                                                INPUT l-inclui-item-fornec).
    
                                       END.
                                       DELETE tt-cotacao-item.
                                   END.
                                   IF NOT foundErrors() THEN DO:
                                      FOR FIRST ordem-compra FIELDS() NO-LOCK 
                                          WHERE ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem:
                                          RUN relacionaOrdemCompraPedido IN h-boin295 (INPUT ROWID(ordem-compra)).
                                      END.
                                   END.
                                END.
                            END.
                        END.
                    END.
                    ELSE DO:
                        FOR EACH tt-prazo-compra NO-LOCK
                            WHERE tt-prazo-compra.numero-ordem = tt-ordem-compra.numero-ordem:
                            ASSIGN c-un =  tt-prazo-compra.un.
                            IF da-dataentrega = ? THEN 
                               da-dataentrega = tt-prazo-compra.data-entrega.
                        END.

                        FOR EACH tt-cotacao-item EXCLUSIVE-LOCK
                            WHERE tt-cotacao-item.char-1 = tt-ordem-compra.char-1:

                            ASSIGN tt-cotacao-item.numero-ordem = tt-ordem-compra.numero-ordem
                                   tt-cotacao-item.preco-fornec = tt-cotacao-item.preco-unit
                                   tt-cotacao-item.un           = c-un
                                   tt-cotacao-item.cod-transp   = tt-pedido-compr.cod-transp
                                   tt-cotacao-item.char-1       = ""
                                   tt-ordem-compra.preco-fornec  = tt-cotacao-item.preco-unit.
                        END.

                        CREATE tt-ordem-compra-unique.
                        BUFFER-COPY tt-ordem-compra TO tt-ordem-compra-unique.

                        ASSIGN tt-ordem-compra-unique.it-codigo    = tt-ordem-compra.it-codigo
                               tt-ordem-compra-unique.cod-refer    = tt-ordem-compra.cod-refer
                               tt-ordem-compra-unique.preco-fornec = tt-ordem-compra.preco-fornec
                               tt-ordem-compra-unique.narrativa    = tt-ordem-compra.narrativa.
                            
                        RUN openQueryStatic  IN h-boin274 (INPUT "main").
                        RUN repositionrecord IN h-boin274 (INPUT ROWID(ordem-compra)).
                        RUN emptyRowErrors   IN h-boin274.
                        RUN setRecord        IN h-boin274 (INPUT TABLE tt-ordem-compra-unique).
                        RUN updateRecord     IN h-boin274.
                        RUN getRowErrors     IN h-boin274 (OUTPUT TABLE RowErrors).
                        RUN SendErrorsToNeogrid (INPUT h-boin274).
                        DELETE tt-ordem-compra-unique.

                        IF NOT foundErrors() THEN DO:
                            /* Alterando as parcelas da ordem de compra */
    
                            FOR EACH tt-prazo-compra NO-LOCK OF tt-ordem-compra:
                                FIND FIRST prazo-compra NO-LOCK 
                                     WHERE prazo-compra.numero-ordem = tt-prazo-compra.numero-ordem
                                       AND prazo-compra.parcela = tt-prazo-compra.parcela NO-ERROR.
                                IF NOT AVAIL prazo-compra THEN NEXT.

                                CREATE tt-prazo-compra-unique.
                                BUFFER-COPY tt-prazo-compra TO tt-prazo-compra-unique.
                                RUN openQuery IN h-boin356 (INPUT 1).
                                RUN repositionrecord IN h-boin356 (INPUT ROWID(prazo-compra)).
                                RUN emptyRowErrors IN h-boin356.
                                RUN setRecord IN h-boin356 (INPUT TABLE tt-prazo-compra-unique).
                                RUN updateRecord IN h-boin356.
                                RUN SendErrorsToNeogrid (INPUT h-boin356).
                                DELETE tt-prazo-compra-unique.
                                DELETE tt-prazo-compra.
                            END.
    
                            FIND FIRST cotacao-item NO-LOCK 
                                 WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                                   AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                                   AND cotacao-item.it-codigo    = ordem-compra.it-codigo NO-ERROR.
                            IF NOT AVAIL cotacao-item THEN DO:

                               FOR EACH tt-cotacao-item EXCLUSIVE-LOCK OF tt-ordem-compra:
                                 ASSIGN tt-cotacao-item.un = c-un
                                        tt-cotacao-item.cod-transp = tt-pedido-compr.cod-transp.
    
                                 RUN preparaCotacaoOrdemCompraPedEmerg IN h-boin082sd (INPUT tt-ordem-compra.numero-ordem,
                                                                                       INPUT tt-pedido-compr.num-pedido,
                                                                                       INPUT tt-pedido-compr.cod-emitente,
                                                                                       INPUT tt-ordem-compra.it-codigo,
                                                                                       INPUT tt-ordem-compra.cod-estabel,
                                                                                       INPUT tt-ordem-compra.qt-solic,
                                                                                       INPUT da-dataentrega,
                                                                                       INPUT-OUTPUT tt-ordem-compra.cod-comprado,
                                                                                       OUTPUT l-none,
                                                                                       OUTPUT l-none,
                                                                                       OUTPUT l-none,
                                                                                       OUTPUT l-none,
                                                                                       OUTPUT l-none,
                                                                                       OUTPUT l-none,
                                                                                       OUTPUT TABLE tt-cotacao-item-defaults).
                                 FIND FIRST tt-cotacao-item-defaults EXCLUSIVE-LOCK NO-ERROR.
                                 BUFFER-COPY tt-cotacao-item-defaults EXCEPT perc-descto
                                                                             valor-descto
                                                                             valor-frete
                                                                             mo-codigo
                                                                             preco-fornec
                                                                             preco-unit 
                                                                             un
                                                                             cod-transp
                                                                             numero-ordem
                                                                             valor-taxa
                                                                             aliquota-icm
                                                                             aliquota-ipi
                                                                             aliquota-iss
                                                                             codigo-ipi   
                                                                             TO tt-cotacao-item.
                                 DELETE tt-cotacao-item-defaults.
                                 CREATE tt-cotacao-item-unique.
    
                                 BUFFER-COPY tt-cotacao-item TO tt-cotacao-item-unique. 
    
                                 RUN createUpdateCotacaoItem IN h-boin082vl (INPUT TABLE tt-cotacao-item-unique,
                                                                             INPUT tt-ordem-compra.it-codigo,
                                                                             INPUT yes,
                                                                             INPUT "neogrid",
                                                                             INPUT yes,
                                                                             INPUT no,
                                                                             INPUT-OUTPUT r-cotacao-item,
                                                                             OUTPUT l-inclui-item-fornec,
                                                                             OUTPUT TABLE rowErrors).
                                 DELETE tt-cotacao-item-unique.
                                 RUN SendErrorsToNeogrid (INPUT h-boin082vl).
                                 IF NOT foundErrors() THEN DO:
                                    FOR FIRST ordem-compra EXCLUSIVE-LOCK 
                                        WHERE ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem:
                                        ASSIGN ordem-compra.data-pedido =  TODAY
                                               ordem-compra.num-pedido  = tt-pedido-compr.num-pedido.
                                        RELEASE ordem-compra.
                                    END.
                                    RUN atualizaDadosCotacaoItemPedEmerg IN h-boin082vl (INPUT "Add":U,
                                                                                         INPUT "neogrid",
                                                                                         INPUT r-cotacao-item,
                                                                                         INPUT l-inclui-item-fornec).
                                    FIND cotacao-item 
                                        WHERE ROWID(cotacao-item ) =  r-cotacao-item NO-LOCK NO-ERROR.
                                    RUN relacionaOrdemCompraPedido IN h-boin295 (INPUT ROWID(ordem-compra)).
                                 END.                                 
                                 DELETE tt-cotacao-item.
                               END.
                            END.
                            ELSE DO:
                                FIND FIRST cotacao-item EXCLUSIVE-LOCK
                                     WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                                       AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                                       AND cotacao-item.it-codigo    = ordem-compra.it-codigo    NO-ERROR.
                                IF AVAIL cotacao-item THEN DO:
                                   ASSIGN cotacao-item.cod-transp    = tt-pedido-compr.cod-transp
                                          cotacao-item.perc-descto   = tt-ordem-compra.perc-descto  
                                          cotacao-item.valor-descto  = tt-ordem-compra.valor-descto 
                                          cotacao-item.valor-frete   = tt-ordem-compra.valor-frete  
                                          cotacao-item.valor-taxa    = tt-ordem-compra.valor-taxa   
                                          cotacao-item.aliquota-icm  = tt-ordem-compra.aliquota-icm 
                                          cotacao-item.aliquota-ipi  = tt-ordem-compra.aliquota-ipi 
                                          cotacao-item.aliquota-iss  = tt-ordem-compra.aliquota-iss 
                                          cotacao-item.preco-unit    = tt-ordem-compra.preco-unit
                                          cotacao-item.preco-fornec  = tt-ordem-compra.preco-unit
                                          cotacao-item.cot-aprovada  = YES
                                          cotacao-item.un            = c-un.

                                   RELEASE cotacao-item.
                                END.

                                FOR FIRST ordem-compra EXCLUSIVE-LOCK 
                                    WHERE ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem:

                                    ASSIGN ordem-compra.data-pedido =  TODAY
                                           ordem-compra.num-pedido  = tt-pedido-compr.num-pedido.
                                    RELEASE ordem-compra.
                                END.

                                FIND FIRST cotacao-item EXCLUSIVE-LOCK
                                     WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                                       AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                                       AND cotacao-item.it-codigo    = ordem-compra.it-codigo    NO-ERROR.
                                IF AVAIL cotacao-item THEN DO:
                                    RUN atualizaDadosCotacaoItemPedEmerg IN h-boin082vl (INPUT "Add":U,
                                                                                         INPUT "neogrid",
                                                                                         INPUT ROWID(cotacao-item),
                                                                                         INPUT l-inclui-item-fornec).
                                    RELEASE cotacao-item.
                                END.

                                RUN relacionaOrdemCompraPedido IN h-boin295 (INPUT ROWID(ordem-compra)).
                            END.
                        END.
                    END.
                    FIND FIRST ordem-compra EXCLUSIVE-LOCK 
                         WHERE ordem-compra.numero-ordem = tt-ordem-compra.numero-ordem NO-ERROR.
                    IF AVAIL ordem-compra  THEN DO:
                       ASSIGN ordem-compra.situacao     = 2
                              ordem-compra.data-pedido  = TODAY
                              ordem-compra.requisitante = tt-ordem-compra.requisitante
                              ordem-compra.cod-comprado = tt-ordem-compra.cod-comprado.
                       FOR EACH prazo-compra EXCLUSIVE-LOCK OF ordem-compra:
                           ASSIGN prazo-compra.situacao = 2.
                       END.
                    END.
                    DELETE tt-ordem-compra.
                END.
            END.
        END.
        IF foundErrors() THEN 
            UNDO bloco, LEAVE bloco.
    END.
END PROCEDURE.

PROCEDURE LoadBOs:
    RUN inbo/boin295.p PERSISTENT SET h-boin295.
    RUN inbo/boin274.p PERSISTENT SET h-boin274.
    RUN inbo/boin274vl.p PERSISTENT SET h-boin274vl.
    RUN inbo/boin274sd.p PERSISTENT SET h-boin274sd.
    RUN inbo/boin356.p PERSISTENT SET h-boin356.
    RUN inbo/boin082vl.p PERSISTENT SET h-boin082vl.
    RUN inbo/boin082sd.p PERSISTENT SET h-boin082sd.
END PROCEDURE.

PROCEDURE ReleaseBOs:
    DELETE PROCEDURE h-boin295.
    DELETE PROCEDURE h-boin274.
    DELETE PROCEDURE h-boin274vl.
    DELETE PROCEDURE h-boin274sd.
    DELETE PROCEDURE h-boin356.
    DELETE PROCEDURE h-boin082vl.
    DELETE PROCEDURE h-boin082sd.
    ASSIGN h-boin295   = ?
           h-boin274   = ?
           h-boin274vl = ?
           h-boin274sd = ?
           h-boin356   = ?
           h-boin082vl = ?
           h-boin082sd = ?.
END PROCEDURE.

PROCEDURE SendErrorsToNeogrid:

    DEF INPUT PARAM p-handle AS HANDLE NO-UNDO.
    
    RUN getRowErrors IN p-handle ( OUTPUT TABLE RowErrors ).
    
    FOR EACH RowErrors NO-LOCK:
        CREATE tt-erro-neogrid.
        ASSIGN tt-erro-neogrid.c-doc-origem  = c-docidentifier
               tt-erro-neogrid.c-cod-estabel = c-cod-estabel
               tt-erro-neogrid.i-cod-erro    = RowErrors.ErrorNumber
               tt-erro-neogrid.c-desc-erro   = RowErrors.ErrorDescription.
    END.
    RUN emptyRowErrors IN p-handle.
END PROCEDURE.

FUNCTION foundErrors RETURNS LOGICAL:
    RETURN CAN-FIND(FIRST tt-erro-neogrid).
END FUNCTION.

FUNCTION getNextParcel RETURNS INTEGER:
    DEF VAR v-parcel AS INTEGER NO-UNDO.

    FOR LAST tt-prazo-compra OF tt-ordem-compra USE-INDEX ordem
        WHERE tt-prazo-compra.parcela > 0:
        v-parcel = tt-prazo-compra.parcela.
    END.
    RETURN v-parcel.

END FUNCTION.

/***************************************************************************
*********/

PROCEDURE buildPurchaseOrderAcknowledgement:

      DEF VAR c-fromrole                    AS CHAR NO-UNDO.
      DEF VAR c-contactinformation-fromrole AS CHAR NO-UNDO.
      DEF VAR c-address-fromrole            AS CHAR NO-UNDO.
      DEF VAR c-torole                      AS CHAR NO-UNDO.
      DEF VAR c-contactinformation-torole   AS CHAR NO-UNDO.
      DEF VAR c-address-torole              AS CHAR NO-UNDO.
      DEF VAR c-root                        AS CHAR NO-UNDO. 
      DEF VAR c-message                     AS CHAR NO-UNDO.
      DEF VAR c-campo                       AS CHAR NO-UNDO.
      DEFINE VARIABLE c-acknow              AS CHAR NO-UNDO.
      DEFINE VARIABLE c-order               AS CHAR NO-UNDO.
      DEFINE VARIABLE c-lineitem            AS CHAR NO-UNDO.
      DEFINE VARIABLE c-lineitemcol         AS CHAR NO-UNDO.
      DEFINE VARIABLE c-it-codigo           AS CHAR NO-UNDO.
      DEFINE VARIABLE c-productship         AS CHAR NO-UNDO.
      DEFINE VARIABLE c-oc                  AS CHAR NO-UNDO.
      DEF VAR c-contactinformation-from     AS CHAR NO-UNDO.
      DEF VAR c-contactname-from            AS CHAR NO-UNDO.
      DEF VAR c-telephonenumber-from        AS CHAR NO-UNDO.
      DEF VAR c-emailaddress-from           AS CHAR NO-UNDO.
      DEF VAR c-contactinformation-to       AS CHAR NO-UNDO.
      DEF VAR c-contactname-to              AS CHAR NO-UNDO.
      DEF VAR c-telephonenumber-to          AS CHAR NO-UNDO.
      DEF VAR c-emailaddress-to             AS CHAR NO-UNDO.
      DEF VAR c-aux                         AS CHAR NO-UNDO.
      DEF VAR c-address                     AS CHAR NO-UNDO.
      DEF VAR i-fornec                      AS INTE NO-UNDO.
      
      FIND FIRST tt-pedido-compr NO-LOCK NO-ERROR.

      ASSIGN c-root = CreateNeoGridDoc("PurchaseOrderAcknowledgement","1.01.001",c-cod-estabel)
             c-message = AddElement(c-root,"Message")
             c-acknow = AddElement(c-message,"PurchaseOrderAcknowledgement")
             c-order = AddElement(c-Acknow,"Order")
             c-campo = AddEleInt(c-order,"POIdentifier",tt-pedido-compr.num-pedido)
             c-campo = AddEleInt(c-order,"POIdentifierNG",i-num-pedido-ng)
             c-campo = AddEleChar(c-order,"LegacyOrderStatusCode","8").

      ASSIGN c-lineitemcol = AddElement(c-order,"ProductLineItemCollection").
              
      FOR EACH ordem-compra NO-LOCK 
          WHERE ordem-compra.num-pedido = tt-pedido-compr.num-pedido:
        ASSIGN c-lineitem = AddElement(c-lineitemcol,"ProductLineItem")
               c-campo    = addeleint(c-lineitem,"OCIdentifier",ordem-compra.numero-ordem)
               c-campo    = addelechar(c-lineitem,"LegacyProductIdentifier",ordem-compra.it-codigo) .

        ASSIGN c-campo    = addelement(c-lineitem,"ProductShipCollection")
               c-productship = addelement(c-campo,"ProductShip").
        ASSIGN c-campo     = addelement(c-ProductShip,"OCCollection")
               c-oc        = addelement(c-campo,"OC")
               c-campo     = addeleint(c-oc,"OCIdentifier",ordem-compra.Numero-ordem).

        FOR FIRST prazo-compra NO-LOCK 
            WHERE prazo-compra.numero-ordem =  ordem-compra.numero-ordem :
            ASSIGN c-campo     = addeleint(c-oc,"OCParcel",prazo-compra.parcela).
        END. 
      END. 

    FIND estabelec NO-LOCK
        WHERE estabelec.cod-estabel = tt-pedido-compr.cod-estabel NO-ERROR.
    ASSIGN c-fromrole                = AddElement(c-acknow,"FromRole")
           c-campo                   = AddEleChar(c-fromrole,"LegacyLocationIdentifier",c-cod-estabel)
           c-campo                   = AddEleChar(c-fromrole,"GlobalPartnerRoleClassificationCode","BUYER")
/*            c-contactinformation-from = AddElement(c-fromrole,"ContactInformation")                                    */
/*            c-campo                   = AddEleChar(c-contactinformation-from,"ContactName",c-contactname-from)         */
/*            c-campo                   = AddEleChar(c-contactinformation-from,"TelephoneNumber",c-telephonenumber-from) */
/*            c-campo                   = AddEleChar(c-contactinformation-from,"EmailAddress",c-emailaddress-from)       */
           c-address                 = AddElement(c-fromrole,"Address")
           c-campo                   = AddEleChar(c-address,"AddressLine1",estabelec.endereco)
           c-campo                   = AddEleChar(c-address,"CityName",estabelec.cidade)
           c-campo                   = AddEleChar(c-address,"DistrictName",estabelec.bairro)
           c-campo                   = AddEleChar(c-address,"StateCode",estabelec.estado)
           c-campo                   = AddEleChar(c-address,"LegacyCountryCode",estabelec.pais)
           c-campo                   = AddEleInt(c-address,"NationalPostalCode",estabelec.cep)
           c-campo                   = AddEleChar(c-address,"AddressCode","Padrao").
    
    FIND emitente NO-LOCK
        WHERE emitente.cod-emitente = tt-pedido-compr.cod-emitente NO-ERROR.

    ASSIGN c-torole                = AddElement(c-acknow,"ToRole")
           c-campo                 = AddEleInt(c-torole,"LegacyLocationIdentifier",tt-pedido-compr.cod-emitente)
           c-campo                 = AddEleChar(c-torole,"GlobalPartnerRoleClassificationCode","SELLER")
/*            c-contactinformation-to = AddElement(c-torole,"ContactInformation")                                  */
/*            c-campo                 = AddEleChar(c-contactinformation-to,"ContactName",c-contactname-to)         */
/*            c-campo                 = AddEleChar(c-contactinformation-to,"TelephoneNumber",c-telephonenumber-to) */
/*            c-campo                 = AddEleChar(c-contactinformation-to,"EmailAddress",c-emailaddress-to)       */
           c-address               = AddElement(c-torole,"Address")
           c-campo                 = AddEleChar(c-address,"AddressLine1",emitente.endereco)
           c-campo                 = AddEleChar(c-address,"CityName",emitente.cidade)
           c-campo                 = AddEleChar(c-address,"DistrictName",emitente.bairro)
           c-campo                 = AddEleChar(c-address,"StateCode",emitente.estado)
           c-campo                 = AddEleChar(c-address,"LegacyCountryCode",emitente.pais)
           c-campo                 = AddEleChar(c-address,"NationalPostalCode",emitente.cep)
           c-campo                 = AddEleChar(c-address,"AddressCode","Padrao").
      
      WriteXML().

END.

/***************************************************************************
*********************************/ 
