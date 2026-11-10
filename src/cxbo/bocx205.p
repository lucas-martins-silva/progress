/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX205 2.00.00.056 } /*** "010056" 07/10/2024 16:59:55 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx205 MUT}
&ENDIF

/*
**  BOCX205.P
**
**  proc-desp-itiner - Despesas do Ponto de Itinerario, no Processo de Exportacao
**
*/

{cxbo/bocx205.i1} /* Include com fonte do programa para utilizacao no magnus */

/* BOCX205.P */

