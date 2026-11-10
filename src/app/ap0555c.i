/****************************************************************
*
* {app/ap0555c.i} - Verifica fun‡Æo Vincula‡Æo Antecipa‡Æo com IR
*
****************************************************************/
DEF VAR l-funcao-vincul-an-ir AS LOGICAL NO-UNDO.

ASSIGN l-funcao-vincul-an-ir = NO.
&IF DEFINED(BF_FIN_VINCUL_AN_IR) &THEN
    assign l-funcao-vincul-an-ir = yes.
&ELSE
    IF CAN-FIND(FIRST funcao 
                WHERE funcao.cd-funcao = "SPP-vincul-an-ir":U
                AND   funcao.ativo = YES) THEN
       ASSIGN l-funcao-vincul-an-ir = YES.
&ENDIF 
/* Fim app/ap0555c.i */
