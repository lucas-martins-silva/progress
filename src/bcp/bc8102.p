/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC8102 2.00.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc8102 MBC}
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
**   Programa..: BC8102.p
**
**   Vers∆o....: 02.00.00 - Datasul
**
**   Objetivo..: Proxy de Acesso a tabela conta-contab para o BC
**
**   Autor.....: Carlos Alberto Soares Pereira - Nov/1999
*********************************************************************************/

/****************************  Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE Table          conta-contab
&GLOBAL-DEFINE datasul-EMS2BO bcbo1002.p
&GLOBAL-DEFINE Magnus-IBO     bcbo2002.p
/****************************  Preprocessor Definitions End  ********************/


/********************************  Includes Beg  ********************************/
{bcp/bc8102.i}   /* Temporary Tables Definition */
{bcp/bcproxy.i1} /* Standard Tables Definition  */
/********************************  Includes End  ********************************/


/******************************  Proxy Program Beg  *****************************/
{bcp/bcproxy.i}
/******************************  Proxy Program End  *****************************/

/* bc8102.p */
