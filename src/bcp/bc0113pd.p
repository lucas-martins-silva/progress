/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0113PD 2.00.00.005 } /*** "010005" 14/08/2023 08:00:47  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc0113pd MBC}
&ENDIF

/*******************************************************************************
**
**   Programa..: bc0113pd.p
**
**   Vers∆o....: 01.00.00 - Datasul
**
**   Objetivo..: Programa de atualizaá∆o do c¢digo do item do cliente **
*********************************************************************************/

DEFINE INPUT PARAMETER c-novo-item  AS CHARACTER FORMAT "x(20)" NO-UNDO.
DEFINE INPUT PARAMETER c-nome-abrev AS CHARACTER FORMAT "x(12)" NO-UNDO.
DEFINE INPUT PARAMETER c-it-codigo  AS CHARACTER FORMAT "x(16)" NO-UNDO.
DEFINE INPUT PARAMETER i-operacao   AS INTEGER                  NO-UNDO. /* 1 - modificar | 2 - deletar */

DEFINE BUFFER b-bc-ext-item-emit FOR bc-ext-item-emit.

DEF VAR r-reg AS ROWID NO-UNDO.

FOR EACH b-bc-ext-item-emit
   WHERE b-bc-ext-item-emit.nome-abrev = c-nome-abrev
     AND b-bc-ext-item-emit.it-codigo  = c-it-codigo NO-LOCK:
    
   ASSIGN r-reg = ROWID(b-bc-ext-item-emit).
   FIND bc-ext-item-emit WHERE ROWID(bc-ext-item-emit) = r-reg EXCLUSIVE-LOCK NO-ERROR.
    
   IF i-operacao = 1 THEN
      ASSIGN bc-ext-item-emit.it-codigo-ext-1 = c-novo-item.
   ELSE IF i-operacao = 2 THEN
      DELETE bc-ext-item-emit.

   RELEASE bc-ext-item-emit.
END.
