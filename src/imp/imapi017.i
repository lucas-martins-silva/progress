/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*
**
** IMAPI017 - Definicao Temp-tables
**
*/

DEFINE TEMP-TABLE tt-tributo-import NO-UNDO
    FIELD nom-trib      AS CHARACTER
    FIELD cod-campo     AS CHARACTER
    FIELD cod-conteudo  AS CHARACTER.

{dibo/bodi317im2bra.i1}  /*Defini‡ao de temp-table para c lculo dos impostos - configurador de tributos*/
    
{dibo/bodi613calc.i3}  //defini‡Æo da tb-wt-it-impostoCBSIBS
    
   
/* IMAPI017.I */        

