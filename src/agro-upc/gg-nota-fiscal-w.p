/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-NOTA-FISCAL-W 2.00.00.029 } /*** "010029" ***/



/***********************************************************************
**  Programa...: agro-upc/gg-nota-fiscal-w.p
**  Descricao..: Upc utilizada na atualizar a tabela gg-mov-contr
**  data.......: Agosto/2003
************************************************************************/

DEFINE PARAM BUFFER b-nota-fiscal     FOR nota-fiscal.
DEFINE PARAM BUFFER b-old-nota-fiscal FOR nota-fiscal.


DEF VAR l-mov       AS LOGICAL NO-UNDO.
DEF VAR i-nivel     AS INTEGER NO-UNDO.
DEF VAR c-programas AS CHAR    NO-UNDO.

{cdp/cdcfgmat.i}
{utp/ut-glob.i}
{ggp/tt-erro.i}

IF NOT can-find( FIRST param-global WHERE param-global.log-modul-gg = yes) then
    return "OK":U. 


RUN agro-upc/gg-cria-ext-nota-fiscal.p (INPUT b-nota-fiscal.cod-estabel,
                                        INPUT b-nota-fiscal.serie,
                                        INPUT b-nota-fiscal.nr-nota-fis,
                                        INPUT b-nota-fiscal.nat-operacao).

FIND FIRST gg-ext-nota-fiscal NO-LOCK
     WHERE gg-ext-nota-fiscal.cod-estabel = b-nota-fiscal.cod-estabel 
       AND gg-ext-nota-fiscal.serie       = b-nota-fiscal.serie 
       AND gg-ext-nota-fiscal.nr-nota-fis = b-nota-fiscal.nr-nota-fis NO-ERROR.

IF  gg-ext-nota-fiscal.qtd-peso-bruto = 0 THEN DO:
    FOR FIRST it-nota-fisc OF b-nota-fiscal NO-LOCK:
        FOR EACH gg-mov-contr NO-LOCK
           WHERE gg-mov-contr.cod-estabel  = it-nota-fisc.cod-estabel 
           AND   gg-mov-contr.num-romaneio = int(SUBSTRING(it-nota-fisc.char-2,232,9))
           AND   gg-mov-contr.num-seq      = int(SUBSTRING(it-nota-fisc.char-2,241,6)):
                                             
           FOR FIRST gg-ext-nota-fiscal EXCLUSIVE-LOCK
               WHERE gg-ext-nota-fiscal.cod-estabel = b-nota-fiscal.cod-estabel 
                 AND gg-ext-nota-fiscal.serie       = b-nota-fiscal.serie 
                 AND gg-ext-nota-fiscal.nr-nota-fis = b-nota-fiscal.nr-nota-fis:
               FIND FIRST gg-mov NO-LOCK 
                     WHERE gg-mov.cod-estabel         = gg-mov-contr.cod-estabel 
                     AND   gg-mov.num-romaneio        = gg-mov-contr.num-romaneio NO-ERROR.
    
                /**** cria historico do movimento ****/
                {utp/ut-liter.i "Atualiza‡Æo Nota Fiscal Faturamento: " * R}
                RUN ggp/ggapi001.p(INPUT rowid(gg-mov),
                                   INPUT RETURN-VALUE 
                                         + b-nota-fiscal.cod-estabel + " " + b-nota-fiscal.serie + " " + b-nota-fiscal.nr-nota-fis
                                         + " " + b-nota-fiscal.nat-operacao 
                                         + " " + string(b-nota-fiscal.cod-emitente)
                                         + " " + gg-mov-contr.cod-contrato, 
                                   INPUT YES).
        
                ASSIGN gg-ext-nota-fiscal.ep-codigo      = gg-mov-contr.ep-codigo
                       gg-ext-nota-fiscal.qtd-peso-bruto = gg-mov.qtd-peso-bruto
                       gg-ext-nota-fiscal.qtd-peso-liq   = gg-mov.qtd-peso-liq 
                       gg-ext-nota-fiscal.qtd-peso-tara  = gg-mov.qtd-peso-tara
                       gg-ext-nota-fiscal.cod_unid_negoc = "".

        
                ASSIGN l-mov = YES.
           END.

           FIND CURRENT gg-ext-nota-fiscal NO-LOCK NO-ERROR.
        END.

        /* para notas de arm gerais e notas feitas via ft4003 */
        IF it-nota-fisc.nr-pedcli = "" AND gg-ext-nota-fiscal.cod-contrato = "" AND b-nota-fiscal.ind-tip-nota <> 8 THEN DO: 
           FOR FIRST gg-ext-nota-fiscal EXCLUSIVE-LOCK
               WHERE gg-ext-nota-fiscal.cod-estabel = b-nota-fiscal.cod-estabel 
                 AND gg-ext-nota-fiscal.serie       = b-nota-fiscal.serie 
                 AND gg-ext-nota-fiscal.nr-nota-fis = b-nota-fiscal.nr-nota-fis:
               &IF '{&bf_mat_versao_ems}' >= '2.09' &THEN
                   ASSIGN gg-ext-nota-fiscal.cod-contrato = it-nota-fisc.cod-contrat-comerc. 
               &ELSE
                   ASSIGN gg-ext-nota-fiscal.cod-contrato  = TRIM(substr(it-nota-fisc.char-2,247,20)).
               &ENDIF
           END.
           FIND CURRENT gg-ext-nota-fiscal NO-LOCK NO-ERROR.
        END.

    END. /* for each */

    IF b-nota-fiscal.ind-tip-nota = 8 /* Recebimento */ THEN DO: /* notas de entrada */

       FIND FIRST gg-ext-docum-est NO-LOCK
            WHERE gg-ext-docum-est.serie-docto  = b-nota-fiscal.serie
            AND   gg-ext-docum-est.nro-docto    = b-nota-fiscal.nr-nota-fis
            AND   gg-ext-docum-est.cod-emitente = b-nota-fiscal.cod-emitente
            AND   gg-ext-docum-est.nat-operacao = b-nota-fiscal.nat-operacao
            AND   gg-ext-docum-est.cod-estabel  = b-nota-fiscal.cod-estabel NO-ERROR.

       IF AVAIL gg-ext-docum-est THEN DO:
           FOR FIRST gg-ext-nota-fiscal EXCLUSIVE-LOCK
               WHERE gg-ext-nota-fiscal.cod-estabel = b-nota-fiscal.cod-estabel 
                 AND gg-ext-nota-fiscal.serie       = b-nota-fiscal.serie 
                 AND gg-ext-nota-fiscal.nr-nota-fis = b-nota-fiscal.nr-nota-fis:

               IF l-mov = NO THEN 
                  ASSIGN gg-ext-nota-fiscal.ep-codigo      = gg-ext-docum-est.ep-codigo   
                         gg-ext-nota-fiscal.qtd-peso-bruto = gg-ext-docum-est.qtd-peso-bruto    
                         gg-ext-nota-fiscal.qtd-peso-liq   = gg-ext-docum-est.qtd-peso-liq      
                         gg-ext-nota-fiscal.qtd-peso-tara  = gg-ext-docum-est.qtd-peso-tara.  

               ASSIGN gg-ext-nota-fiscal.log-transito   = gg-ext-docum-est.log-transito
                      gg-ext-nota-fiscal.cod_unid_negoc = "".

           END.
           FIND CURRENT gg-ext-nota-fiscal NO-LOCK NO-ERROR.
       END. 
    END.

END.

/* se tem pedido, o que vale ‚ o que est  no pedido */
IF (gg-ext-nota-fiscal.cod-contrato = "" OR gg-ext-nota-fiscal.num-seq = 0) AND b-nota-fiscal.nr-pedcli <> "" THEN DO: 
    FOR FIRST gg-ext-ped-venda NO-LOCK 
        WHERE gg-ext-ped-venda.nome-abrev = b-nota-fiscal.nome-ab-cli 
        AND   gg-ext-ped-venda.nr-pedcli  = b-nota-fiscal.nr-pedcli:

        IF gg-ext-ped-venda.cod-contrato <> "" THEN DO:
           FOR FIRST gg-ext-nota-fiscal EXCLUSIVE-LOCK
               WHERE gg-ext-nota-fiscal.cod-estabel = b-nota-fiscal.cod-estabel 
                 AND gg-ext-nota-fiscal.serie       = b-nota-fiscal.serie 
                 AND gg-ext-nota-fiscal.nr-nota-fis = b-nota-fiscal.nr-nota-fis:
              ASSIGN gg-ext-nota-fiscal.cod-contrato = gg-ext-ped-venda.cod-contrato
                     gg-ext-nota-fiscal.ep-codigo    = gg-ext-ped-venda.ep-codigo
                     gg-ext-nota-fiscal.num-seq      = gg-ext-ped-venda.num-seq
                     gg-ext-nota-fiscal.cod_unid_negoc = "". 
           END.
           FIND CURRENT gg-ext-nota-fiscal NO-LOCK NO-ERROR.
        END.
    END.
END.

/**************** CONTROLE DE TRANSITO *******************************/

IF b-nota-fiscal.ind-tip-nota <> 8 THEN DO: /* notas de sa¡da */
        
    /* entregas X fixa‡Æo de componente */
    IF  b-nota-fiscal.esp-docto       = 20
    AND b-old-nota-fiscal.dt-cancela  = ?
    AND b-nota-fiscal.dt-cancela     <> ? THEN DO:

        RUN ggp/ggapi076.p (INPUT "nota-fiscal",
                            INPUT ROWID(b-nota-fiscal),
                            INPUT 7, /* cancela devolucao */
                            INPUT YES, /* vai associar a uma fixa‡Æo */
                            INPUT-OUTPUT TABLE tt-erro). 

        FIND FIRST gg-pendencia EXCLUSIVE-LOCK
             WHERE gg-pendencia.cod-emitente-rec = b-nota-fiscal.cod-emitente
               AND gg-pendencia.serie-docto-rec  = b-nota-fiscal.serie
               AND gg-pendencia.nr-docto-rec     = b-nota-fiscal.nr-nota-fis
               AND gg-pendencia.nat-operacao-rec = b-nota-fiscal.nat-operacao
               AND gg-pendencia.cod-estabel      = b-nota-fiscal.cod-estabel
               AND gg-pendencia.idi-tip-soluc    = 2 NO-ERROR. /* Vinculada */
        IF AVAIL gg-pendencia THEN
            ASSIGN gg-pendencia.log-pendente     = YES
                   gg-pendencia.idi-tip-soluc    = 0
                   gg-pendencia.cod-emitente-rec = 0
                   gg-pendencia.serie-docto-rec  = ""
                   gg-pendencia.nr-docto-rec     = ""
                   gg-pendencia.nat-operacao-rec = ""
                   gg-pendencia.nat-operacao     = "".

    END.
END.

IF AVAIL gg-ext-nota-fiscal THEN
    FIND CURRENT gg-ext-nota-fiscal NO-LOCK NO-ERROR.

ASSIGN ERROR-STATUS:ERROR = NO.

RETURN "OK":U.
/* fim upc */
