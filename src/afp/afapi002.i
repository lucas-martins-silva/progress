/******************************************************************************** 
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/******************************************************************************
**
** Include: afapi002.i - Defini‡äes das Temp table para gera‡Æo dos
**    per¡odos de avalia‡Æo dos forncedores.
                       
**
*******************************************************************************/

/******************************Defini‡Æo de Temp Table ****************************/

    DEF TEMP-TABLE tt-periodos NO-UNDO
        FIELD sequencia            AS INTEGER
        FIELD date-ini             AS DATE
        FIELD date-fim             AS DATE
        FIELD periodo              AS CHAR FORMAT "x(25)":U.
           
/* Fim da include */

