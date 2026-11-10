/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-PED-VENDA-W 2.00.00.012 } /*** "010012" ***/



/***********************************************************************
**  Programa...: agro-upc/gg-ped-venda-w
**  Descricao..: Upc utilizada na atualizar a tabela gg-ext-ped-venda-w
**  data.......: Agosto/2003
************************************************************************/
DEFINE PARAM BUFFER b-ped-venda       FOR ped-venda.
DEFINE PARAM BUFFER b-ped-venda-old   FOR ped-venda.

FIND FIRST para-ped NO-LOCK NO-ERROR.

{utp/ut-glob.i}

IF b-ped-venda-old.nome-abrev <> "" AND b-ped-venda-old.nr-pedcli <> ""  THEN DO:
   FIND FIRST gg-ext-ped-venda EXCLUSIVE-LOCK
        WHERE gg-ext-ped-venda.nome-abrev  = b-ped-venda-old.nome-abrev
          AND gg-ext-ped-venda.nr-pedcli   = b-ped-venda-old.nr-pedcli  NO-ERROR. 
END.
ELSE DO:
   FIND FIRST gg-ext-ped-venda EXCLUSIVE-LOCK
        WHERE gg-ext-ped-venda.nome-abrev  = b-ped-venda.nome-abrev
          AND gg-ext-ped-venda.nr-pedcli   = b-ped-venda.nr-pedcli  NO-ERROR.  
END.




IF  NOT AVAIL gg-ext-ped-venda THEN DO:
    CREATE gg-ext-ped-venda.
    ASSIGN gg-ext-ped-venda.nome-abrev   = b-ped-venda.nome-abrev
           gg-ext-ped-venda.nr-pedcli    = b-ped-venda.nr-pedcli
           gg-ext-ped-venda.nr-pedido    = b-ped-venda.nr-pedido. 

    FOR FIRST estabelec FIELDS (ep-codigo) NO-LOCK 
        WHERE estabelec.cod-estabel = b-ped-venda.cod-estabel:
        ASSIGN gg-ext-ped-venda.ep-codigo    = estabelec.ep-codigo.
    END.
END.


IF b-ped-venda.nome-abrev   <> b-ped-venda-old.nome-abrev THEN DO:
   IF gg-ext-ped-venda.cod-contrato <> "" THEN DO:

       /*atualizar os contratos*/
       FOR EACH gg-contrato-prod EXCLUSIVE-LOCK
          WHERE gg-contrato-prod.ep-codigo    = gg-ext-ped-venda.ep-codigo 
            AND gg-contrato-prod.cod-contrato = gg-ext-ped-venda.cod-contrato:
           
           IF gg-ext-ped-venda.nome-abrev <> gg-contrato-prod.nome-abrev 
            OR gg-ext-ped-venda.nr-pedcli <> gg-contrato-prod.nr-pedcli THEN NEXT. /*s¢ os pedidos do gg-ext*/
            
           ASSIGN gg-contrato-prod.nome-abrev = b-ped-venda.nome-abrev.

       END.
   END.
   /*atualizar o ext-pedvenda*/
   ASSIGN gg-ext-ped-venda.nome-abrev = b-ped-venda.nome-abrev.
END.

/* Item 068 - Integridade */
If gg-ext-ped-venda.cod-contrato <> "" then
    Assign gg-ext-ped-venda.ind-origem = 2. /*  SGG */
Else
    Assign gg-ext-ped-venda.ind-origem = 1. /*  Manual */

/* verifica se n∆o foi liberado pelo workflow */
DEFINE VARIABLE l-libera AS LOGICAL INIT YES NO-UNDO.
IF para-ped.log-usa-aprovac-workflow = YES AND b-ped-venda.log-aprov-workflow = NO THEN ASSIGN l-libera = NO.

/* se mudou de qualquer situaá∆o para credito aprovado e liberado pelo workflow */
IF NOT b-ped-venda-old.cod-sit-aval = 3 AND
       b-ped-venda.cod-sit-aval     = 3 AND
       l-libera
    THEN DO:
    FIND FIRST gg-contrato-ant EXCLUSIVE-LOCK
        WHERE gg-contrato-ant.ep-codigo    = gg-ext-ped-venda.ep-codigo
          AND gg-contrato-ant.cod-contrato = gg-ext-ped-venda.cod-contrato
          AND gg-contrato-ant.num-seq      = gg-ext-ped-venda.num-seq      NO-ERROR.
    IF AVAIL gg-contrato-ant THEN
        ASSIGN gg-contrato-ant.log-liberado = YES.
END.
    
/* verifica se mudou de workflow n∆o aprovado para workflow aprovado e se est† avaliaá∆o de credito aprovada */
IF     para-ped.log-usa-aprovac-workflow  = YES 
   AND b-ped-venda.log-aprov-workflow     = YES
   AND b-ped-venda-old.log-aprov-workflow = NO
   AND b-ped-venda.cod-sit-aval           = 3 
THEN DO:
    FIND FIRST gg-contrato-ant EXCLUSIVE-LOCK
        WHERE gg-contrato-ant.ep-codigo    = gg-ext-ped-venda.ep-codigo
          AND gg-contrato-ant.cod-contrato = gg-ext-ped-venda.cod-contrato
          AND gg-contrato-ant.num-seq      = gg-ext-ped-venda.num-seq      NO-ERROR.
    IF AVAIL gg-contrato-ant THEN
        ASSIGN gg-contrato-ant.log-liberado = YES.
END.



/** buscar Un de Neg¢cio **/
IF  gg-ext-ped-venda.cod_unid_negoc = "" THEN DO: 
    IF  gg-ext-ped-venda.cod-contrato <> "" THEN DO: 
        FIND FIRST gg-contrato NO-LOCK 
             WHERE gg-contrato.ep-codigo     = gg-ext-ped-venda.ep-codigo
                AND gg-contrato.cod-contrato = gg-ext-ped-venda.cod-contrato NO-ERROR. 
        IF  AVAIL gg-contrato THEN DO:
            ASSIGN gg-ext-ped-venda.cod_unid_negoc = gg-contrato.cod_unid_negoc.
        END.
    END.
END.

/********************************************************/
FIND CURRENT gg-ext-ped-venda NO-LOCK NO-ERROR.

RETURN "OK".

