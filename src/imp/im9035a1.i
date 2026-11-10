/********************************************************************************
**
**  IM9035A1.I - Defini‡äes c lculo despesas Importacao x Compras (CC0406/CC0407)
**
*********************************************************************************/

DEF TEMP-TABLE tt-desp NO-UNDO
    FIELD cod-desp  LIKE desp-imp.cod-desp
    FIELD descricao LIKE desp-imp.descricao
    FIELD val-desp  LIKE cotacao-item-cex.val-desp
    INDEX codigo IS UNIQUE PRIMARY
        cod-desp.

DEF VAR c-lb-despesas-imp AS CHAR FORMAT "x(19)" NO-UNDO.
DEF VAR c-lb-cod-desp     AS CHAR FORMAT "x(6)"  NO-UNDO.
DEF VAR c-lb-descricao    AS CHAR FORMAT "x(10)" NO-UNDO.
DEF VAR c-lb-val-desp     AS CHAR FORMAT "x(15)" NO-UNDO.

{utp/ut-liter.i C¢digo * L}
ASSIGN c-lb-cod-desp     = TRIM(RETURN-VALUE).
{utp/ut-liter.i Descri‡Æo * L}
ASSIGN c-lb-descricao    = TRIM(RETURN-VALUE).
{utp/ut-liter.i Valor_Despesa * L}
ASSIGN c-lb-val-desp     = TRIM(RETURN-VALUE).
{utp/ut-liter.i Despesas_Importa‡Æo * L}
ASSIGN c-lb-despesas-imp = TRIM(RETURN-VALUE).

FORM tt-desp.cod-desp  AT 10
     tt-desp.descricao AT 17
     tt-desp.val-desp  AT 47
    WITH STREAM-IO NO-BOX NO-LABEL WIDTH 132 FRAME f-despesas.

FORM c-lb-cod-desp  AT 10
     c-lb-descricao AT 17
     c-lb-val-desp  AT 53 SKIP
     "------" AT 10
     "------------------------------" AT 17
     "------------------" AT 48
    WITH STREAM-IO NO-BOX NO-LABEL WIDTH 132 FRAME f-despesas-cab.
