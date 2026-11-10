/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB9007 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab9007 MAB}
&ENDIF



/***************************************************************
Programa : ab9007
Fun‡Æo   : receber o codigo do programa e retornar o valor
objetivo : poder verificar de outros modulos os parametros de frotas
data     : 17/10/2006
autor    : Lutz Carlos Gunther
*****************************************************************/

DEFINE INPUT  PARAMETER p-cdn-param AS INTEGER    NO-UNDO.
DEFINE OUTPUT PARAMETER p-valor AS CHARACTER  NO-UNDO.


FIND mab-param NO-LOCK
    WHERE mab-param.cdn-param = p-cdn-param NO-ERROR.

IF AVAIL mab-param  
    THEN ASSIGN p-valor = mab-param.des-valor.
    
