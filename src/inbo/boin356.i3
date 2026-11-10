

/*****************************************************************************
  Include para Considerar apenas Dias Uteis na data da entrega

  BOIN356.I3

******************************************************************************/
                                             
assign i-cont = 1
       l-erro-calend = no.

/* s½ executa se o novo parametro estiver marcado no param-compra  */

REPEAT WHILE i-cont <= dias-ressup.

    FIND FIRST calen-data no-lock WHERE 
               calen-data.cd-calen = {1} AND 
               calen-data.data  = pDtEntrega + 1 no-error.
               
    IF AVAIL calen-data THEN DO:
       IF calen-data.tipo-dia = 1 THEN do: /* dia œtil */ 
          ASSIGN i-cont = i-cont + 1.
        end.
    END. 
    ELSE DO:
       ASSIGN l-erro-calend = yes.
       LEAVE. /* erro: n’o tem calen-prod cadastrado */ 
    END.
    
    ASSIGN pDtEntrega = pDtEntrega + 1. 
END.

