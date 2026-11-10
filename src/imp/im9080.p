/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9080 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im9080 MIM}
&ENDIF

/******************************************************************************
**
**   Programa : IM9080.p
**
**   Data   : Outubro 2004
**
**   Autor  : Datasul S.A.
**
**   Objetivo : Atualiza situa‡Æo do processo apartir de um contrato(im9080)
**            
******************************************************************************/

{cdp/cdcfgmat.i}
{include/boerrtab.i}


DEF VAR h-bocx140 AS HANDLE NO-UNDO.

DEF INPUT PARAMETER p-num-pedido AS INT NO-UNDO.

FOR FIRST processo-imp fields(nr-proc-imp cod-estabel situacao) WHERE 
          processo-imp.num-pedido = p-num-pedido NO-LOCK:
END.

IF AVAIL processo-imp THEN DO:
    IF processo-imp.situacao = 3 THEN DO:
        RUN cxbo/bocx140.p PERSISTENT SET h-bocx140.
        
        
        RUN atualizasituacaoprocesso IN h-bocx140 (INPUT processo-imp.cod-estabel,
                                                   INPUT processo-imp.nr-proc-imp,
                                                   OUTPUT TABLE tt-bo-erro).
        
        DELETE PROCEDURE h-bocx140.
        
        FIND FIRST tt-bo-erro NO-LOCK NO-ERROR.
        IF AVAIL tt-bo-erro THEN
            RETURN "NOK":U.
        ELSE 
            RETURN "OK":U.
    END.
END.
ELSE 
    RETURN "OK":U.

/*FIM*/
