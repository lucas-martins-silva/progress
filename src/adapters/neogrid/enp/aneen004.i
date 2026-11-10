/***************************************************************************
** Integra‡Æo com NeoGrid e-CS 
** Autor: Anderson Elton Kruger
** Data: junho/2001
** Objetivo: Criar item na temp-table para enviar as 
** informa‡äes dos itens para o NeoGrid e-CS usando os adapters.
***************************************************************************/

CREATE tt-item.
FIND narrativa OF item NO-LOCK NO-ERROR.
IF AVAILABLE(narrativa) THEN DO:
  ASSIGN tt-item.narrativa = narrativa.descricao.
END.
FIND FIRST item-fornec NO-LOCK OF item NO-ERROR.
IF AVAILABLE(item-fornec) THEN DO:
  ASSIGN tt-item.manufacturer = item-fornec.cod-emitente.
END.
IF item.tipo-con-est = 4 THEN DO:
   FIND FIRST ref-item NO-LOCK 
       WHERE item.it-codigo = ref-item.it-codigo NO-ERROR.
   IF AVAILABLE(ref-item) THEN DO:
      ASSIGN tt-item.reference = ref-item.cod-refer.
   END.
END.
BUFFER-COPY item TO tt-item.

