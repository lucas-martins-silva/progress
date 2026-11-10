/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN500 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN500 MUT}
&ENDIF

/*
**  BOIN500.P
**
**  dim-man - Dimens∆o Manufatura
**
**  Ultima alteraá∆o : 17/08/99 - GeraBO
*/


{include/boini.i}

{inbo/boin500.i1}
{inbo/boin500.i2}
