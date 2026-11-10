/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX095 2.00.00.032 } /*** "010032" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bocx095 MUT}
&ENDIF

/*
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bocx095 MUT}
&ENDIF
*/

/**
**  BOCX095.P
**
**  desp-imp - Esta tabela mant‚m os registros do cadastro de despsas/impostos que serÆo utilizados nos processos de importa‡Æo.
**
**  Ultima altera‡Æo : 04/05/99 - GeraBO - Brv9587
*******************************************************************************/
{utp/ut-glob.i}
{cxbo/bocx095.i1} /* C¢digo Fonte CXBO095 */

