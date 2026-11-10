/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGPD4000D 2.00.00.004 } /*** "010004" 19/06/2024 15:24:45  ***/



/*****************************************************************************
* Programa: Agpd4000c.p
* Objetivo: No "ENTRY" do qt-pedida atualizar o pre‡o original   
* OBS     : Chamado pela Agpd4000.p
*****************************************************************************/
{utp/ut-glob.i}
DEF NEW GLOBAL SHARED VAR c-nr-pedcli-pd4000      AS CHAR FORMAT "x(15)". 
DEF NEW GLOBAL SHARED VAR c-nome-abrev-pd4000     AS CHAR FORMAT "x(12)". 
DEF NEW GLOBAL SHARED VAR wh-qt-pedida-pd4000     AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-vl-preori-pd4000     AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-it-codigo-pd4000     AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-nr-tabpre-pd4000     AS HANDLE NO-UNDO.


/****************************************************************************/

IF  wh-nr-tabpre-pd4000:SCREEN-VALUE = "":U THEN 
    APPLY "leave":U TO wh-qt-pedida-pd4000.








     
