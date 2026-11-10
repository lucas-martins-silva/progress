/************************************************************************
**
** IM3100a.I - Include de defini‡Æo da tabela tempor ria.
**
************************************************************************/

DEF TEMP-TABLE tt-dupli   NO-UNDO
    FIELD dt-vencim    AS DATE
    FIELD tp-despesa   AS INTEGER
    FIELD vl-apagar    AS DECIMAL
    FIELD vl-apagar-mo AS DECIMAL
    FIELD mo-codigo    AS INT
    INDEX data
          mo-codigo
          dt-vencim.

DEF TEMP-TABLE tt-dupli-apagar-cex NO-UNDO
    FIELD cod-emitente      LIKE dupli-apagar-cex.cod-emitente
    FIELD nat-operacao      LIKE dupli-apagar-cex.nat-operacao
    FIELD serie-docto       LIKE dupli-apagar-cex.serie-docto
    FIELD nro-docto         LIKE dupli-apagar-cex.nro-docto
    FIELD cod-emitente-desp LIKE dupli-apagar-cex.cod-emitente-desp
    FIELD cod-desp          LIKE docum-est-cex.cod-desp /* nao existe cod-desp no dupli-apagar-cex no EMS 2.03 */
    FIELD mo-codigo         LIKE dupli-apagar-cex.mo-codigo
    FIELD dt-vencim         LIKE dupli-apagar-cex.dt-vencim
    FIELD tp-despesa        LIKE dupli-apagar-cex.tp-despesa
    FIELD vl-a-pagar        LIKE dupli-apagar-cex.vl-a-pagar
    FIELD vl-a-pagar-mo     LIKE dupli-apagar-cex.vl-a-pagar-mo
    FIELD cod-esp           LIKE dupli-apagar-cex.cod-esp
    INDEX codigo
        serie-docto
        nro-docto
        cod-emitente
        nat-operacao
        cod-desp
        cod-emitente-desp
    INDEX data
        cod-emitente-desp
        dt-vencim.

DEF TEMP-TABLE tt-docum-est-cex    NO-UNDO LIKE docum-est-cex.

DEF TEMP-TABLE tt-item-doc-est-cex NO-UNDO LIKE item-doc-est-cex.
