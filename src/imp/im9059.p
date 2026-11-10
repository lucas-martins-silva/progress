/******************************************************************************
** Copyright TOTVS S.A. (2009) 
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9059 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im9059 MIM}
&ENDIF

/*****************************************************************************
**
** IM9059.P - Integracao entre Importacao e Obrigacoes Fiscais (EMS)
**
** Objetivo: CAT 6
**
******************************************************************************/
def input parameter rw-item as rowid.
def input parameter i-sequencia like item-doc-est-cex.sequencia.
    
FOR FIRST it-doc-fisc 
    WHERE ROWID(it-doc-fisc) = rw-item EXCLUSIVE-LOCK:
END.

FOR EACH item-doc-est-cex 
    WHERE item-doc-est-cex.serie-docto  = it-doc-fisc.serie       
    AND   item-doc-est-cex.nro-docto    = it-doc-fisc.nr-doc-fis  
    AND   item-doc-est-cex.cod-emitente = it-doc-fisc.cod-emitente
    AND   item-doc-est-cex.nat-operacao = it-doc-fisc.nat-operacao
    AND   item-doc-est-cex.sequencia    = i-sequencia   
    NO-LOCK USE-INDEX codigo 
    BREAK BY item-doc-est-cex.cod-desp:

    FOR FIRST desp-imp 
        WHERE desp-imp.cod-desp = item-doc-est-cex.cod-desp no-lock:
    end.

    IF NOT AVAIL desp-imp THEN NEXT.

    IF desp-imp.inc-val-frete OR desp-imp.inc-val-seguro THEN DO:
        ASSIGN it-doc-fisc.vl-merc-liq  = it-doc-fisc.vl-merc-liq + item-doc-est-cex.val-desp
               it-doc-fisc.vl-despes-it = it-doc-fisc.vl-despes-it - item-doc-est-cex.val-desp.
        IF SUBSTRING(it-doc-fisc.char-2,138,17) <> "" THEN
           ASSIGN overlay(it-doc-fisc.char-2,138,17) = string(it-doc-fisc.vl-merc-liq).
    END.              
END.






