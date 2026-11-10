/*********** Definições  ************/
DEFINE VARIABLE iContErro  AS INTEGER INIT 0 NO-UNDO.
DEFINE VARIABLE iCont01  AS INTEGER INIT 0 NO-UNDO.
DEFINE VARIABLE iCont02  AS INTEGER INIT 0 NO-UNDO.
DEFINE VARIABLE iCont03  AS INTEGER INIT 0 NO-UNDO.

{cdg/cdg0666.i}   /* tt-erro */
{utp/ut-glob.i}

DEFINE TEMP-TABLE tt-recur-sec-dbr NO-UNDO
    FIELD cod-recurso           AS CHARACTER
    FIELD des-recurso           AS CHARACTER
    FIELD log-ativo             AS LOGICAL INITIAL YES
    FIELD idi-aplic             AS INTEGER INITIAL 1
    FIELD idi-tipo              AS INTEGER INITIAL 3
    INDEX rcrscdbr-id IS PRIMARY UNIQUE
          cod-recurso.

DEFINE TEMP-TABLE tt-recur-sec-dispon-dbr NO-UNDO
    FIELD cod-recurso     AS CHARACTER
    FIELD dat-inic-period AS DATE INITIAL TODAY
    FIELD qtd-segs-inic   AS DECIMAL
    FIELD dat-fim-period  AS DATE INITIAL TODAY
    FIELD qtd-segs-fim    AS DECIMAL
    FIELD qtd-dispon      AS DECIMAL
    INDEX rcrscdsa-id IS PRIMARY UNIQUE
          cod-recurso dat-inic-period qtd-segs-inic
    INDEX rcrscdsa-ter
          cod-recurso dat-fim-period qtd-segs-fim.

DEFINE TEMP-TABLE tt-recur-sec-ctrab-dbr NO-UNDO
    FIELD cod-ctrab    AS CHARACTER
    FIELD cod-recurso  AS CHARACTER
    FIELD log-ativo    AS LOGICAL INITIAL YES
    FIELD qtd-consum   AS DECIMAL
    FIELD idi-aloc-ord AS INTEGER INITIAL 1
    INDEX rcrsccta-id IS PRIMARY UNIQUE
          cod-ctrab cod-recurso
    INDEX rcrsccta-rec
          cod-recurso.
