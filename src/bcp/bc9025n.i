/********************************************************************************************
**   Include...: bc9025f.i                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000                                                               **
**                                                                                         **
**   Objetivo..: Tabelas para integracao com as funcoes do bc9025f.p                       **
**                                                                                         **
********************************************************************************************/
{scbo/bosc030.i "ttWm-box"}

DEFINE TEMP-TABLE tt-tarefasES NO-UNDO
            FIELD cod-estabel       LIKE wm-box-movto.cod-estabel
            FIELD cod-local         LIKE wm-box-movto.cod-local
            FIELD id-movto          As Decimal
            FIELD num-docto         LIKE wm-docto.num-docto
            FIELD id-docto          LIKE wm-box-movto.id-docto
            FIELD ind-tipo-movto    As Integer
            FIELD num-seq-item      LIKE wm-box-movto.num-seq-item
            FIELD cod-item          As Character
            FIELD cod-refer         As Character
            FIELD qtd-item          LIKE wm-box-movto.qtd-item
            FIELD id-box            Like wm-box-movto.id-box
            FIELD num-seq           AS INTEGER
            FIELD des-local         AS CHARACTER FORMAT 'X(19)':U
            FIELD cod-bloco         AS CHARACTER 
            FIELD cod-rua           AS CHARACTER 
            FIELD cod-nivel         AS CHARACTER 
            FIELD cod-coluna        AS CHARACTER 
            FIELD rowid-box-movto AS ROWID
            INDEX ID num-seq.

Define Temp-table tt-TransfEntrada NO-UNDO Like tt-tarefasES.
Define Temp-table tt-TransfSaida   NO-UNDO Like tt-tarefasES.

Define Temp-table ttWm-box-movto-idx No-undo Like wm-box-movto
            Field val-prioridade    As Integer
            Field r-rowid           As Rowid
            Index idx-prioridade val-prioridade Desc
            Index idx-movto      id-movto       Asc.

/* TEMP-TABLE Usada para armazenar os registros da transa‡Æo                  */
DEFINE TEMP-TABLE ttSerial NO-UNDO
    Field   id-box          As Integer
    Field   num-serial      As Decimal
    Field   cod-item        As Character
    Field   cod-estabel     As Character
    Field   cod-local       As Character
    Field   id-movto        As Integer
    Field   ind-tipo-movto  As Integer
    Field   qtd-item        As Decimal
    Field   cod-coletor     As Character
    Field   cod-eqpto       As Character
    Field   data            As Date
    Field   hora            As Character.


/* TEMP-TABLE Usada para armazenar os agrupadores da transa‡Æo                */
DEFINE TEMP-TABLE tt-agrupadores NO-UNDO
            FIELD cod-eqpto      AS CHARACTER
            FIELD Cod-Tipo-Equip AS CHARACTER
            FIELD cod-usuario    AS CHARACTER
            FIELD cod-coletor    AS CHARACTER
            FIELD cod-estabel    AS CHARACTER
            FIELD cod-local      AS CHARACTER
            FIELD id-docto       AS DECIMAL
            FIELD por-Tarefa     AS LOGICAL.

/* TEMP-TABLE Usada no OUTPUT da bosc096 - Deveria estar na include desta DBO */
Define Temp-table ttWm-info-etiqueta NO-UNDO Like wm-etiqueta.

DEF TEMP-TABLE tt-etiqueta NO-UNDO
    FIELD id-etiqueta LIKE wm-etiqueta.id-etiqueta
    FIELD qtd-item    LIKE wm-etiqueta.qtd-item
    INDEX codigo IS UNIQUE id-etiqueta.

DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.


/*
DEFINE TEMP-TABLE tt-transferencia  NO-UNDO
            FIELD id-box-orig       LIKE wm-box-saldo.id-box
            FIELD id-box-destino    LIKE wm-box-saldo.id-box
            FIELD id-docto          LIKE wm-box-movto.id-docto
            FIELD id-movto          LIKE wm-box-movto.id-movto
            FIELD cod-item          LIKE wm-box-saldo.cod-item
            FIELD qtd-item          LIKE wm-box-saldo.qtd-item
            FIELD qtd-item-bloq     LIKE wm-box-saldo.qtd-item-bloq
            FIELD cod-lote          LIKE wm-box-saldo.cod-lote
            FIELD cod-refer         LIKE wm-box-saldo.cod-refer
            FIELD qtd-item-retirado LIKE wm-box-saldo.qtd-item
            FIELD cod-embalagem     LIKE wm-box-saldo.cod-embalagem
            FIELD cod-cliente       LIKE wm-box-saldo.cod-cliente
            FIELD ind-tip-movto     AS INTEGER
            FIELD dat-transacao     AS DATE
            FIELD num-serial        AS DECIMAL
            FIELD NumRow            AS INTEGER.

*/

/**********************
DEFINE TEMP-TABLE tt-Saldo        NO-UNDO
            FIELD id-box-origem   LIKE wm-box-saldo.id-box
            FIELD cod-item        LIKE wm-box-saldo.cod-item
            FIELD cod-refer       LIKE wm-box-saldo.cod-refer
            FIELD cod-lote        LIKE wm-box-saldo.cod-lote
            FIELD qtd-item        LIKE wm-box-saldo.qtd-item
            FIELD qtd-item-bloq   LIKE wm-box-saldo.qtd-item-bloq
            FIELD qtd-retirada    LIKE wm-box-saldo.qtd-item
            FIELD qtd-embalagem   LIKE wm-box-movto.qti-embalagem
            FIELD cod-cliente     LIKE wm-box-saldo.cod-cliente
            FIELD cod-embalagem   LIKE wm-box-saldo.cod-embalagem
            FIELD disp-item       AS CHARACTER
            FIELD RowNum          AS INTEGER
            FIELD r-RowId         AS ROWID
            INDEX ID RowNum.

DEFINE TEMP-TABLE tt-mostra-itens NO-UNDO
            FIELD id-box          LIKE wm-box-saldo.id-box
            FIELD endereco        AS CHARACTER FORMAT 'x(15)':U
            FIELD cod-item        AS CHARACTER FORMAT 'x(16)':U INIT ''
            FIELD cod-refer       AS CHARACTER FORMAT 'x(10)':U
            FIELD qtd-retirar     AS INTEGER   FORMAT  '9999':U
            FIELD qtd-pendente    AS INTEGER   FORMAT  '9999':U
            FIELD num-serial      AS CHARACTER FORMAT 'x(16)':U INIT 0.

**********************/

