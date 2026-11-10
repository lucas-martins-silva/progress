/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC8117 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc8117 MBC}
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
**   Programa..: BC8117.p
**
**   Vers∆o....: 02.00.00 - Datasul
**
**   Objetivo..: Proxy de Acesso a tabela Embalagem para o BC
**
**   Autor.....: Marcio Roberto Andrade - FEV/2001
*********************************************************************************/


/****************************  Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE Table          Embalag
&GLOBAL-DEFINE datasul-EMS2BO bcbo1017.p
&GLOBAL-DEFINE Magnus-IBO     bcbo2017.p
/****************************  Preprocessor Definitions End  ********************/

/********************************  Includes Beg  ********************************/
{bcp/bc8117.i}   /* Temporary Tables Definition */
{bcp/bcproxy.i1} /* Standard Tables Definition  */
/********************************  Includes End  ********************************/

/******************************  Proxy Program Beg  *****************************/
{bcp/bcproxy.i}
/******************************  Proxy Program End  *****************************/

/* bc8117.p */

