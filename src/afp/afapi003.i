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
** Include: afapi003.i - Defini‡äes das Temp table's para comparar as altera‡äes
**  entre registros.                       
**
*******************************************************************************/

/******************************Defini‡Æo de Temp Table ****************************/
DEFINE TEMP-TABLE tt-param-af-old NO-UNDO LIKE param-af.
DEFINE TEMP-TABLE tt-param-af-new NO-UNDO LIKE param-af.
DEFINE TEMP-TABLE tt-af-periodo-aval-old  NO-UNDO LIKE af-periodo-aval.
DEFINE TEMP-TABLE tt-af-periodo-aval-new  NO-UNDO LIKE af-periodo-aval.
DEFINE TEMP-TABLE tt-af-versao-avaliacao-old NO-UNDO LIKE af-versao-avaliacao.
DEFINE TEMP-TABLE tt-af-versao-avaliacao-new NO-UNDO LIKE af-versao-avaliacao.
{afbo/boaf024.i tt-af-historico-alteracao}
           
/* Fim da include */

