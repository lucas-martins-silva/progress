/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-EMITENTE-D 2.00.00.008 } /*** 010008 ***/

/***********************************************************************
**  Programa...: agro-upc/gg-emitente-d.p
**  Descricao..: Upc utilizada na ExclusÆo da tabela mgadm.emitente
**  data.......: Agosto/2003
************************************************************************/
{utp/ut-glob.i}

define param buffer b-emitente     for mgadm.emitente.

/**** REALIZA VALIDACAO mgadm.emitente PARA TABELAS ESPECIFICAS ****/

IF CAN-FIND(FIRST gg-contrato WHERE
                  gg-contrato.cod-emitente = b-emitente.cod-emitente NO-LOCK) THEN DO:
    /*RUN utp/message.p ("O mgadm.emitente nÆo pode ser exclu¡do",
                   "O mgadm.emitente nÆo pode ser exclu¡do pois o mesmo possui contrato cadastrado").*/
    RETURN "NOK".

END.

/*************************************************************/
FIND FIRST gg-ext-emitente exclusive-lock
     where gg-ext-emitente.cod-emitente = b-emitente.cod-emitente NO-ERROR.
IF AVAIL gg-ext-emitente THEN DO:
    
    /*Verifica se existe inscri‡Æo padrÆo*/
    FIND FIRST gg-inscricao-padrao EXCLUSIVE-LOCK 
         WHERE gg-inscricao-padrao.cod-propriet  = string(b-emitente.cod-emitente)
           AND gg-inscricao-padrao.cod-inscricao = gg-ext-emitente.num-livre-3  NO-ERROR.
          
    IF AVAIL gg-inscricao-padrao AND gg-ext-emitente.num-livre-3  > 0  THEN DO:
        delete gg-inscricao-padrao.
    END.

    delete gg-ext-emitente.

END.
     

FIND FIRST fat-ext-emitente exclusive-lock
     where fat-ext-emitente.cod-emitente = b-emitente.cod-emitente NO-ERROR.
IF AVAIL fat-ext-emitente THEN
     delete fat-ext-emitente.

FOR EACH gg-inscricao EXCLUSIVE-LOCK
    WHERE gg-inscricao.cod-emitente = b-emitente.cod-emitente:
   delete gg-inscricao.
END.


return "OK"              
/*****************************************************************************/                  

