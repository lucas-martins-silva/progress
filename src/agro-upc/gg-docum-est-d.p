/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-DOCUM-EST-D 2.00.00.008 } /*** 010008 ***/


/***********************************************************************
**  Programa...: agro-upc/gg-docum-est-d.p
**  Descricao..: Upc utilizada na Exclus∆o da tabela docum-est
**  data.......: Setembro/2003
************************************************************************/
define param buffer b-docum-est     for docum-est.
/************* PROGRAMA SEM EFEITO, VALIDAÄ«OES FORAM PARA GGBOIN090.P *********/


FIND FIRST gg-ext-docum-est NO-LOCK
     where gg-ext-docum-est.serie-docto  = b-docum-est.serie-docto 
      AND  gg-ext-docum-est.nro-docto    = b-docum-est.nro-docto   
      AND  gg-ext-docum-est.cod-emitente = b-docum-est.cod-emitente
      AND  gg-ext-docum-est.nat-operacao = b-docum-est.nat-operacao 
      AND  gg-ext-docum-est.cod-estabel  = b-docum-est.cod-estabel NO-ERROR.

IF AVAIL gg-ext-docum-est THEN DO:
   FIND CURRENT gg-ext-docum-est EXCLUSIVE-LOCK NO-ERROR.
   delete gg-ext-docum-est. 
END.
return "OK" .             
/*****************************************************************************/      

     
