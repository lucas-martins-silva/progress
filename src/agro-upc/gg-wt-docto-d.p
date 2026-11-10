/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-WT-DOCTO-D 2.00.00.004 } /*** 010004 ***/



/***********************************************************************
**  Programa...: agro-upc/gg-wt-docto-d.p
**  Descricao..: Upc utilizada na exclus∆o da tabela gg-ext-wt-docto
**  data.......: novembro/2003
************************************************************************/
DEFINE PARAM BUFFER b-wt-docto FOR wt-docto.

{utp/ut-glob.i}
FIND FIRST gg-ext-wt-docto EXCLUSIVE-LOCK
     WHERE gg-ext-wt-docto.seq-wt-docto = b-wt-docto.seq-wt-docto NO-ERROR.
IF AVAIL gg-ext-wt-docto THEN
   DELETE gg-ext-wt-docto.

FOR EACH gg-classifica EXCLUSIVE-LOCK
    WHERE gg-classifica.num-docto      = STRING(b-wt-docto.seq-wt-docto)
      AND gg-classifica.des-tipo-docto = "wt-docto" :

    delete gg-classifica.
END.
    
RETURN "OK".



/*****************************************************************************/

