/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-IT-EXAME-D 2.00.00.005 } /*** 010005 ***/


/***********************************************************************
**  Programa...: agro-upc/gg-it-exame-d.p
**  Descricao..: Upc utilizada na exclus∆o da tabela gg-ext-titulo
**  data.......: Novembro/2007
************************************************************************/
DEFINE PARAM BUFFER b-it-exame FOR it-exame.
        
    FOR FIRST gg-ext-it-exame EXCLUSIVE-LOCK
        WHERE gg-ext-it-exame.it-codigo = b-it-exame.it-codigo
        AND gg-ext-it-exame.cod-exame = b-it-exame.cod-exame:
    
        DELETE gg-ext-it-exame.

    END.

RETURN "OK".
/*****************************************************************************/

