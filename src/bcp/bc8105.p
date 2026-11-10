/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC8105 2.00.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc8105 MBC}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*******************************************************************************
**   Programa..: BC8105.p
**
**   Vers∆o....: 02.00.00 - Datasul
**
**   Objetivo..: Proxy de Acesso a tabela Cod-Rejeicao para o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/


/****************************  Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE Table          Cod-Rejeicao
&GLOBAL-DEFINE datasul-EMS2BO bcbo1005.p
&GLOBAL-DEFINE Magnus-IBO     bcbo2005.p
/****************************  Preprocessor Definitions End  ********************/


/********************************  Includes Beg  ********************************/
{bcp/bc8105.i}   /* Temporary Tables Definition */
{bcp/bcproxy.i1} /* Standard Tables Definition  */
/********************************  Includes End  ********************************/


/******************************  Proxy Program Beg  *****************************/
{bcp/bcproxy.i}
/******************************  Proxy Program End  *****************************/

/* bc8105.p */

