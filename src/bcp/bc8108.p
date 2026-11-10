/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC8108 2.00.00.008 } /*** 010008 ***/


/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*******************************************************************************
**   Programa..: BC8108.p
**
**   Vers∆o....: 02.00.00 - Datasul
**
**   Objetivo..: Proxy de Acesso a tabela Item para o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/


/****************************  Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE Table          Item
&GLOBAL-DEFINE datasul-EMS2BO bcbo1008.p
&GLOBAL-DEFINE Magnus-IBO     bcbo2008.p
/****************************  Preprocessor Definitions End  ********************/


/********************************  Includes Beg  ********************************/
{bcp/bc8108.i}   /* Temporary Tables Definition */
{bcp/bcproxy.i1} /* Standard Tables Definition  */
/********************************  Includes End  ********************************/


/******************************  Proxy Program Beg  *****************************/
{bcp/bcproxy.i}
/******************************  Proxy Program End  *****************************/

/* bc8108.p */

