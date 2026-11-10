/***************************************************************************
**     i01af014.i - Campo: ind-tipo-doc - af-excecao
***************************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Pedido Compra
&glob val2 Nota Fiscal Entrada
&glob val3 Ficha Inspeção
&glob val4 Nota Fiscal Devolução
&ENDIF

{include/ind01-10.i {1} {2}}

/* Fim */
