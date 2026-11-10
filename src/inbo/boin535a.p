/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN535A 2.00.00.015 } /*** "010015" 17/06/2025 16:40:50 ***/


&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN535A MUT}
&ENDIF


{include/boini.i}


{inbo/boin535.i4} /*** Unir Dividir Split ***/
{inbo/boin535.i2} /*** CalcularTempoPadrao ***/

