/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX155A 2.00.00.012}  /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX155A MUT}
&ENDIF

/*******************************************************************************
**
**  BOCX155A.P
**
**  emitente-cex - Emitente Comercio Exterior - Clientes
*********************************************************************************/

{cdp/cdcfgcex.i}

{cxbo/bocx155a.i1} /* Fonte da BOCX155A */
