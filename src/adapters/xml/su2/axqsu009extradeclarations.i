{utp/ut-glob.i}
{method/dbotterr.i}

DEFINE TEMP-TABLE tt-variavel
   FIELD cod-var-oper   AS CHAR FORMAT "x(16)"
   FIELD valor-variavel AS CHAR FORMAT "x(60)".

DEFINE TEMP-TABLE tt-retorno
   FIELD valor-retorno AS CHAR FORMAT "x(60)" 
   FIELD campo-retorno AS CHAR FORMAT "x(60)" 
   FIELD perc-rateio   AS DEC FORMAT ">>9,99".


DEFINE VARIABLE c-estabel LIKE estabelec.cod-estabel.
DEFINE VARIABLE c-regra-utilizada AS INT FORMAT ">>>,>>>,>>9".

