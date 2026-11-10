/*********** Definições  ************/
DEFINE VARIABLE iContErro  AS INTEGER INIT 0 NO-UNDO.
DEFINE VARIABLE iContTool  AS INTEGER INIT 0 NO-UNDO.
DEFINE VARIABLE iContTool2  AS INTEGER INIT 0 NO-UNDO.

{cdg/cdg0666.i}   /* tt-erro */
{utp/ut-glob.i}

DEFINE TEMP-TABLE tt-gm-altern-dbr NO-UNDO
   FIELD gm-codigo         AS CHARACTER
   FIELD gm-altern         AS CHARACTER
   FIELD log-reciproco     AS LOGICAL INITIAL YES
   FIELD val-perc-eficien  AS DECIMAL INITIAL 100
   FIELD num-sequencia     AS INTEGER
   INDEX gmltrndb-id IS PRIMARY UNIQUE
         gm-codigo gm-altern
   INDEX gmltrndb-seq
         gm-codigo num-sequencia
   INDEX onde-se-usa
         gm-altern gm-codigo.
