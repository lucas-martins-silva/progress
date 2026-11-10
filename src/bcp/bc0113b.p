/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0113B 2.00.00.005 } /*** "010005" 14/08/2023 08:00:47  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc0113b MBC}
&ENDIF

/*******************************************************************************
**
**   Programa..: bc0113b.p
**
**   Vers∆o....: 01.00.00 - Datasul
**
**   Objetivo..: Programa de atualizaá∆o do nome abreviado do cliente **
*********************************************************************************/

DEFINE INPUT PARAMETER c-velho-nome AS CHARACTER FORMAT "x(12)" NO-UNDO.
DEFINE INPUT PARAMETER c-novo-nome  AS CHARACTER FORMAT "x(12)" NO-UNDO.

DEFINE BUFFER b-bc-ext-item-emit FOR bc-ext-item-emit.

DEF VAR r-reg AS ROWID NO-UNDO.

FOR EACH b-bc-ext-item-emit
   WHERE b-bc-ext-item-emit.nome-abrev = c-velho-nome NO-LOCK:
    
   ASSIGN r-reg = ROWID(b-bc-ext-item-emit).
   FIND bc-ext-item-emit WHERE ROWID(bc-ext-item-emit) = r-reg EXCLUSIVE-LOCK NO-ERROR.
   ASSIGN bc-ext-item-emit.nome-abrev = c-novo-nome.

   RELEASE bc-ext-item-emit.
END.
