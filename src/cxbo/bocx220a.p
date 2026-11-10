/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/
{include/i-prgvrs.i BOCX220A 2.00.00.114 } /*** "010014" 09/07/2026 16:01:58 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx220a MUT}
&ENDIF
 
/*******************************************************************************
**
**  BOCX220A.P - Desembarque      
**
*******************************************************************************/
{cdp/cdcfgmat.i}    /* Preprocessadores */
    
{cdp/cd2508.i}      /* Fun»’o - ems2-comex-mexico */

{cxbo/bocx220a.i1}  /* Procedures de negocio */

/* BOCX220A.P  */


