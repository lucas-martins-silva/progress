/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-NOTA-FISCAL-D 2.00.00.019 } /*** 010019 ***/



/***********************************************************************
**  Programa...: agro-upc/gg-nota-fiscal-d.p
**  Descricao..: Upc utilizada na exclusÆo da tabela gg-ext-nota-fiscal
**  data.......: Agosto/2003
************************************************************************/
DEFINE PARAM BUFFER b-nota-fiscal FOR nota-fiscal.

{utp/ut-glob.i}

/**************** CONTROLE DE TRANSITO *******************************/
{lgp/lgapi002.i}
{cdp/cd0666.i}

if not connected ('emsgra':U) then
	return "OK":U.
else IF NOT can-find( FIRST param-global WHERE param-global.log-modul-gg = yes) then
    return "OK":U. 

FOR EACH tt-par-trans:
    DELETE tt-par-trans.
END.
        
CREATE tt-par-trans.
ASSIGN tt-par-trans.p-tipo-doc = "NF"
       tt-par-trans.p-row-doc  = rowid(b-nota-fiscal)
       tt-par-trans.p-operacao = 17 /* ELIMINA transito nota fiscal */.

RUN lgp/lgapi002.p (INPUT TABLE tt-par-trans,
                    INPUT TABLE tt-par-clas,
                    INPUT-OUTPUT TABLE tt-erro).
/*********************************************************************/

FIND FIRST gg-ext-nota-fiscal EXCLUSIVE-LOCK
     WHERE gg-ext-nota-fiscal.cod-estabel = b-nota-fiscal.cod-estabel 
       AND gg-ext-nota-fiscal.serie       = b-nota-fiscal.serie
       AND gg-ext-nota-fiscal.nr-nota-fis = b-nota-fiscal.nr-nota-fis  NO-ERROR.
IF AVAIL gg-ext-nota-fiscal THEN DO:
    DELETE gg-ext-nota-fiscal.
END.

/****************** acertar romaneio origina‡Æo gg2003 ****************/
FOR EACH gg-mov-contr EXCLUSIVE-LOCK
   WHERE gg-mov-contr.cod-estabel  = b-nota-fiscal.cod-estabel                 
     AND gg-mov-contr.serie-docto  = b-nota-fiscal.serie                       
     AND gg-mov-contr.nro-docto    = b-nota-fiscal.nr-nota-fis
     AND gg-mov-contr.nat-operacao = b-nota-fiscal.nat-operacao 
     AND gg-mov-contr.cod-emitente = b-nota-fiscal.cod-emitente
     AND gg-mov-contr.ind-situacao = 3 /*Confirmado*/:
    
    IF b-nota-fiscal.nat-operacao > "5" THEN /* so para saida */
       ASSIGN gg-mov-contr.nro-docto    = ""
              gg-mov-contr.serie-docto  = ""
              gg-mov-contr.cdd-embarq   = 0
              gg-mov-contr.ind-situacao = 2.
   
    FIND FIRST gg-mov EXCLUSIVE-LOCK OF gg-mov-contr NO-ERROR.
    IF  AVAIL gg-mov THEN DO:
        IF b-nota-fiscal.nat-operacao > "5" THEN /* so para saida */
           ASSIGN gg-mov.ind-situacao       = 2.
       
        /**** cria historico do movimento ****/
        {utp/ut-liter.i "Elimina‡Æo de Nota " * R}
        RUN ggp/ggapi001.p (INPUT rowid(gg-mov),
                            INPUT RETURN-VALUE + b-nota-fiscal.cod-estabel + " " + b-nota-fiscal.serie + " " + b-nota-fiscal.nr-nota-fis
                                               + " " + b-nota-fiscal.nat-operacao 
                                               + " " + string(b-nota-fiscal.cod-emitente) 
                                               + " " + gg-mov-contr.cod-contrato, 
                            INPUT YES).
   END.
   FIND CURRENT gg-mov no-LOCK NO-ERROR.
END.

FOR EACH gg-classifica exclusive-lock
   WHERE gg-classifica.des-tipo-docto = "nota-fiscal"
     AND gg-classifica.cod-estabel    = b-nota-fiscal.cod-estabel
     AND gg-classifica.num-docto      = b-nota-fiscal.nr-nota-fis      
     AND gg-classifica.serie          = b-nota-fiscal.serie :     
   DELETE gg-classifica.
END.

RETURN "OK".
/*****************************************************************************/

