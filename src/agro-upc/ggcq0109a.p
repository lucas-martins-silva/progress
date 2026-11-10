/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGCQ0109A 2.00.00.003 } /*** 010003 ***/


/*******************************************************************************
 * Nome.....: agcq0109a.p
 * Data.....: Agosto/2003
 * Objetivo.: Programa para efetuar o Leave no campo seq-comp da upc agcq0109.p.
 *            Somente pq havia uma validaá∆o de dicionario q n∆o permitia q esse ]
 *            campo recebesse valor s¢ na hora da gravaá∆o.
 * Vers∆o...: 2.01.00.001
 ******************************************************************************/

define new global shared variable wh-descricao-cq0109     as widget-handle no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE gr-tab-result           AS ROWID         NO-UNDO.


FIND FIRST tab-result NO-LOCK                                                      
     WHERE rowid(tab-result) = gr-tab-result NO-ERROR.                             
IF AVAIL tab-result THEN DO:                                                       
   FIND FIRST gg-ext-tab-result NO-LOCK                                            
        WHERE gg-ext-tab-result.nr-tabela = tab-result.nr-tabela NO-ERROR.         
   IF AVAIL gg-ext-tab-result AND gg-ext-tab-result.log-faixa = YES THEN
      ASSIGN wh-descricao-cq0109:SCREEN-VALUE = ".":U.
END.

   
