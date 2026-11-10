/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9016 2.00.00.004}  /*** "010004" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
/*{include/i-license-manager.i IM9016 MIM}*/
&ENDIF

/********************************************************************************
** Programa  : imp/im0010n.p
** Data      : 15/03/1999
** Autor     : Rodrigo da Silva 
** Objetivo  : Respons vel pelas integra‡äes do m¢dulo de importa‡Æo (cdapi171.p,cdapi171.i1,cdapi174.p)
**             Adiciona o valor das despesas de importa‡Æo ao valor do material
** Versoes   : 2.00.00.000
********************************************************************************/

{imp/im9029.i}

