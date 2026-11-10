/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI011 2.00.00.026}  /*** "010026" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bcapi011 MBC}
&ENDIF


/*******************************************************************
** Programa: API011
** Objetivo: Esta api calcula com base na quantidade e fatores do item a 
**           quantidade de etiquetas a serem impressas.
*******************************************************************/
{bcp/bcapi011.i}    /* defini‡Æo  temp-table tt-etq-item */
{bcp/bcproxy.i2}    /* Defini‡äes das procedures para integra‡Æo com o Magnus i.00 */

DEF INPUT-OUTPUT PARAM TABLE FOR tt-etq-item.

DEF VAR l-erro  AS LOGICAL NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE gcod-programa AS CHARACTER NO-UNDO.

/* Zerar valor do Return-Value */
RUN pi-return.

FIND FIRST tt-etq-item NO-LOCK NO-ERROR.
IF NOT AVAIL tt-etq-item THEN DO:
   RETURN "NOK":U.
END.

IF tt-etq-item.cod-versao-integracao <> 1 THEN DO:
   RETURN "NOK":U.
END.

FIND FIRST param-bc NO-LOCK NO-ERROR.
IF NOT AVAIL param-bc THEN
   RETURN "NOK":U.

FIND FIRST bc-tipo-trans
     WHERE bc-tipo-trans.cd-trans = tt-etq-item.cd-trans NO-LOCK NO-ERROR.
IF AVAIL bc-tipo-trans THEN DO:
   /* deternimante do tipo de etiqueta Item (1) */
   IF bc-tipo-trans.int-2 = 1 THEN DO:
      FIND FIRST bc-ext-item
           WHERE bc-ext-item.it-codigo = tt-etq-item.it-codigo NO-LOCK NO-ERROR.
      IF AVAIL bc-ext-item THEN DO:
         IF bc-ext-item.imprime-etiq THEN DO:
            ASSIGN tt-etq-item.qt-etiq-item    = bc-ext-item.qt-etiq-item
                   tt-etq-item.qt-etiq-total   = bc-ext-item.qt-etiq-total
                   tt-etq-item.tipo-etiq       = bc-ext-item.tipo-etiq
                   tt-etq-item.tipo-etiq-total = bc-ext-item.tipo-etiq-total
                   tt-etq-item.it-codigo-ext-1 = bc-ext-item.it-codigo-ext-1
                   tt-etq-item.it-codigo-ext-2 = bc-ext-item.it-codigo-ext-2
                   tt-etq-item.it-codigo-ext-3 = bc-ext-item.it-codigo-ext-3
                   tt-etq-item.it-codigo-ext-4 = bc-ext-item.it-codigo-ext-4.

            IF (tt-etq-item.tipo-etiq = 0 OR tt-etq-item.tipo-etiq-total = 0) THEN
               RUN pi-ext-familia (INPUT AVAIL bc-ext-item).
         END.
         ELSE
            RETURN "NOK":U.
      END.
      ELSE 
         RUN pi-ext-familia (INPUT AVAIL bc-ext-item).
   END.
   
   /* determinante do tipo de etiqueta Item x Cliente (2) */
   IF bc-tipo-trans.int-2 = 2 THEN DO:
      FIND FIRST bc-ext-item-emit
           WHERE bc-ext-item-emit.it-codigo   = tt-etq-item.it-codigo
             AND bc-ext-item-emit.nome-abrev  = tt-etq-item.nome-abrev NO-LOCK NO-ERROR.
      IF AVAIL bc-ext-item-emit THEN DO:
         IF bc-ext-item-emit.imprime-etiq THEN
            ASSIGN tt-etq-item.qt-etiq-item    = bc-ext-item-emit.qt-etiq-item
                   tt-etq-item.qt-etiq-total   = bc-ext-item-emit.qt-etiq-total
                   tt-etq-item.tipo-etiq       = bc-ext-item-emit.tipo-etiq
                   tt-etq-item.tipo-etiq-total = bc-ext-item-emit.tipo-etiq-total
                   tt-etq-item.it-codigo-ext-1 = bc-ext-item-emit.it-codigo-ext-1
                   tt-etq-item.it-codigo-ext-2 = bc-ext-item-emit.it-codigo-ext-2
                   tt-etq-item.it-codigo-ext-3 = bc-ext-item-emit.it-codigo-ext-3
                   tt-etq-item.it-codigo-ext-4 = bc-ext-item-emit.it-codigo-ext-4.
         ELSE
            RETURN "NOK":U.
      END.
      ELSE
         RETURN "NOK":U.
   END.
   
   /*Determinante do tipo de etiqueta Unit rio (3) NÆo sofre fatora‡Æo*/
END.

IF RETURN-VALUE = "NOK":U THEN
   RETURN "NOK":U.

/*** Valor dos tipos de etiqueta = zero buscar do tipo de transa‡Æo ***/
IF tt-etq-item.tipo-etiq = 0 THEN
   ASSIGN tt-etq-item.tipo-etiq = IF AVAIL bc-tipo-trans THEN bc-tipo-trans.tipo-etiq ELSE 0.

IF tt-etq-item.tipo-etiq-total = 0 THEN
   ASSIGN tt-etq-item.tipo-etiq-total = IF AVAIL bc-tipo-trans THEN bc-tipo-trans.tipo-etiq-total ELSE 0.


/*** Valor dos tipos de etiqueta = zero buscar dos parametros BC ***/
IF tt-etq-item.tipo-etiq = 0 THEN
   ASSIGN tt-etq-item.tipo-etiq = param-bc.tp-etiq-padrao.

IF tt-etq-item.tipo-etiq-total = 0 THEN
   ASSIGN tt-etq-item.tipo-etiq-total = param-bc.tipo-etiq-total.

IF tt-etq-item.tipo-etiq = 0 AND tt-etq-item.tipo-etiq-total = 0 THEN
   RETURN "NOK":U.


/*** Valor do fator/quantidade da etiqueta = zero inicializar com 1 ***/
IF tt-etq-item.qt-etiq-item = 0 THEN
   ASSIGN tt-etq-item.qt-etiq-item = 1.

IF tt-etq-item.qt-etiq-total = 0 THEN
   ASSIGN tt-etq-item.qt-etiq-total = 1.


ASSIGN tt-etq-item.qt-etiqueta       = IF tt-etq-item.qt-item >= tt-etq-item.qt-etiq-item THEN
                                          TRUNCATE (tt-etq-item.qt-item / tt-etq-item.qt-etiq-item,0)
                                       ELSE 1
       tt-etq-item.qt-ult-etiqueta   = IF tt-etq-item.qt-item >= tt-etq-item.qt-etiq-item THEN 
                                          (tt-etq-item.qt-item - (tt-etq-item.qt-etiqueta * tt-etq-item.qt-etiq-item))
                                       ELSE 0
       tt-etq-item.qt-etiqueta       = IF tt-etq-item.qt-ult-etiqueta > 0 THEN
                                          tt-etq-item.qt-etiqueta + 1
                                       ELSE tt-etq-item.qt-etiqueta
       tt-etq-item.qt-etiq-item      = IF tt-etq-item.qt-item >= tt-etq-item.qt-etiq-item THEN
                                          tt-etq-item.qt-etiq-item
                                       ELSE tt-etq-item.qt-item.

/*******  Etiqueta Total *******/
ASSIGN tt-etq-item.qt-etiqueta-total = IF tt-etq-item.qt-item >= tt-etq-item.qt-etiq-total THEN
                                          TRUNCATE(tt-etq-item.qt-item / tt-etq-item.qt-etiq-total,0)
                                       ELSE 1
       tt-etq-item.qt-ult-etiq-total = IF tt-etq-item.qt-item >= tt-etq-item.qt-etiq-total THEN
                                          (tt-etq-item.qt-item - (tt-etq-item.qt-etiqueta-total * tt-etq-item.qt-etiq-total))
                                       ELSE 0
       tt-etq-item.qt-etiqueta-total = IF tt-etq-item.qt-ult-etiq-total > 0 THEN
                                          tt-etq-item.qt-etiqueta-total + 1
                                       ELSE tt-etq-item.qt-etiqueta-total
       tt-etq-item.qt-etiq-total     = IF tt-etq-item.qt-item >= tt-etq-item.qt-etiq-total THEN
                                          tt-etq-item.qt-etiq-total
                                       ELSE tt-etq-item.qt-item.

RETURN "OK":U.

/***********************************************************************************************************/
PROCEDURE Pi-Ext-Familia:
   DEF INPUT PARAM l-item    AS LOGICAL NO-UNDO.
    
   DEF VAR l-val-ext-familia AS LOGICAL NO-UNDO.

   ASSIGN l-val-ext-familia = IF gcod-programa = "wm9300" THEN NO ELSE YES.
   
   RUN pi-verifica-item(INPUT tt-etq-item.it-codigo,
                        INPUT tt-etq-item.it-codigo,
                        INPUT 0,   /* Tipo de Acesso 0=Currente .... */
                        INPUT 1).
   IF AVAIL ttReturnMessages THEN
      RETURN "NOK":U.
   ELSE DO:
      FIND FIRST bc-ext-familia
           WHERE bc-ext-familia.fm-codigo = ttItem.fm-codigo NO-LOCK NO-ERROR.
      IF (NOT AVAIL bc-ext-familia) AND (NOT l-item) THEN DO:
         IF NOT l-val-ext-familia THEN
            RETURN "OK":U.
         ELSE
            RETURN "NOK":U.
		END.
		
      IF AVAIL bc-ext-familia THEN DO:
         IF (NOT l-item) THEN DO:
            IF bc-ext-familia.imprime-etiq THEN
               ASSIGN tt-etq-item.qt-etiq-item    = bc-ext-familia.qt-etiq-item
                      tt-etq-item.qt-etiq-total   = bc-ext-familia.qt-etiq-total.
            ELSE
               RETURN "NOK":U.
         END.
         
         IF tt-etq-item.tipo-etiq = 0 THEN
            ASSIGN tt-etq-item.tipo-etiq = bc-ext-familia.tipo-etiq.
 
         IF tt-etq-item.tipo-etiq-total = 0 THEN
            ASSIGN tt-etq-item.tipo-etiq-total = bc-ext-familia.tipo-etiq-total.
      END.
   END.
END PROCEDURE.

/***********************************************************************************************************/
PROCEDURE Pi-Return:
   RETURN.
END PROCEDURE.
