/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-CONT-EMIT-D 2.00.00.003 } /*** 010003 ***/

/********************************************************************************
**  Programa.: gg-cont-emit-d.p 
**  Descricao: Elimina registros da extensao da tabela CONT-EMIT
**  Data.....: Outubro de 2006
********************************************************************************/
DEFINE PARAM BUFFER b-cont-emit     FOR cont-emit.
.DEFINE PARAM BUFFER b-old-cont-emit FOR cont-emit.

FOR FIRST gg-ext-cont-emit FIELDS(cod-emitente sequencia) EXCLUSIVE-LOCK
    WHERE gg-ext-cont-emit.cod-emitente = b-cont-emit.cod-emitente
      AND gg-ext-cont-emit.sequencia    = b-cont-emit.sequencia:
   DELETE gg-ext-cont-emit.
END.
RETURN "OK".
/* FIM - gg-cont-emit-d.p */
