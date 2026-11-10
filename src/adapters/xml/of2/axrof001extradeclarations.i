/* Defini‡äes */
{cdp/cdcfgmat.i}
{method/dbotterr.i}              /*  RowErrors */
{inbo/boin046.i tt-classif-fisc} /*  tt-classif-fisc */

/* Importa‡Æo */
{cdp/cd4300.i3}  /* Tratamento Atributo Livre */
{cdp/cd0603.i50} /* Tratamento Atributo Livre */

DEFINE VAR d-tax-perc            AS DECIMAL FORMAT ">>9.99":U INIT 0 NO-UNDO.

DEFINE VAR iCount                AS INTEGER                          NO-UNDO.

DEFINE VAR pExpItem              AS INTEGER                          NO-UNDO.
DEFINE VAR pExpPedEmAberto       AS LOGICAL                          NO-UNDO.
DEFINE VAR pExpPedAtendParc      AS LOGICAL                          NO-UNDO.

DEFINE VAR d-idi-tip-apurac-ipi  AS DECIMAL                          NO-UNDO.
DEFINE VAR d-val-aliq-ext-pis    AS DECIMAL                          NO-UNDO.
DEFINE VAR d-val-aliq-ext-cofins AS DECIMAL                          NO-UNDO.
DEFINE VAR d-red-cofins          AS DECIMAL                          NO-UNDO.
DEFINE VAR d-red-pis             AS DECIMAL                          NO-UNDO.
DEFINE VAR i-finalidade          AS INTEGER                          NO-UNDO.
