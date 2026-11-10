/******************************************************************************
** Copyright TOTVS S.A. (2009) 
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0006 2.00.00.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im0006 MIM}
&ENDIF

/* IM0006.p: retorna temp-tables tt-docto e tt-it-docto antes de envi -las para o ft2010.p */ 

{cdp/cd4305.i1} /* TT-DOCTO, TT-IT-DOCTO */
     
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-docto.  
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-it-docto.

DEFINE VARIABLE d-vl-frete-uni AS DECIMAL NO-UNDO.
DEFINE VARIABLE d-vl-seguro    AS DECIMAL NO-UNDO.
DEFINE VARIABLE d-vl-despesa-seguro AS DECIMAL NO-UNDO. 

FOR EACH tt-docto EXCLUSIVE-LOCK
    WHERE tt-docto.vl-frete  <> 0
    OR    tt-docto.vl-seguro <> 0:
     for each tt-it-docto
            where tt-it-docto.cod-estabel = tt-docto.cod-estabel
            and   tt-it-docto.serie       = tt-docto.serie
            and   tt-it-docto.nr-nota     = tt-docto.nr-nota EXCLUSIVE-LOCK:

        FOR EACH  item-doc-est-cex NO-LOCK 
            WHERE item-doc-est-cex.serie-docto  = tt-docto.serie        
            AND   item-doc-est-cex.nro-docto    = tt-docto.nr-nota      
            AND   item-doc-est-cex.cod-emitente = tt-docto.cod-emitente 
            AND   item-doc-est-cex.nat-operacao = tt-docto.nat-operacao 
            AND   item-doc-est-cex.sequencia    = tt-it-docto.nr-sequencia 
            USE-INDEX codigo BREAK BY item-doc-est-cex.cod-desp:

            FOR FIRST desp-imp 
                WHERE desp-imp.cod-desp = item-doc-est-cex.cod-desp NO-LOCK:
            END.
            
            IF NOT AVAIL desp-imp THEN NEXT.

            IF desp-imp.inc-val-frete AND tt-it-docto.vl-frete <> 0 THEN DO:
                ASSIGN d-vl-frete-uni           = tt-it-docto.vl-frete / tt-it-docto.quantidade[1]
                       tt-it-docto.vl-preori    = tt-it-docto.vl-preori + d-vl-frete-uni
                       tt-it-docto.vl-preuni    = tt-it-docto.vl-preuni + d-vl-frete-uni
                       tt-it-docto.vl-pretab    = tt-it-docto.vl-pretab + d-vl-frete-uni
                       tt-it-docto.vl-merc-liq  = tt-it-docto.vl-merc-liq + tt-it-docto.vl-frete
                       tt-it-docto.vl-merc-ori  = tt-it-docto.vl-merc-ori + tt-it-docto.vl-frete
                       tt-it-docto.vl-merc-tab  = tt-it-docto.vl-merc-tab + tt-it-docto.vl-frete
                       tt-it-docto.vl-despes-it = tt-it-docto.vl-despes-it - tt-it-docto.vl-frete
                       tt-it-docto.vl-frete     = 0.
            END.

            IF desp-imp.inc-val-seguro THEN DO:
                ASSIGN d-vl-despesa-seguro = item-doc-est-cex.val-desp
                       d-vl-seguro              = d-vl-despesa-seguro / tt-it-docto.quantidade[1] 
                       tt-it-docto.vl-preori    = tt-it-docto.vl-preori + d-vl-seguro             
                       tt-it-docto.vl-preuni    = tt-it-docto.vl-preuni + d-vl-seguro             
                       tt-it-docto.vl-pretab    = tt-it-docto.vl-pretab + d-vl-seguro             
                       tt-it-docto.vl-merc-liq  = tt-it-docto.vl-merc-liq + d-vl-despesa-seguro   
                       tt-it-docto.vl-merc-ori  = tt-it-docto.vl-merc-ori + d-vl-despesa-seguro   
                       tt-it-docto.vl-merc-tab  = tt-it-docto.vl-merc-tab + d-vl-despesa-seguro   
                       tt-it-docto.vl-despes-it = tt-it-docto.vl-despes-it - d-vl-despesa-seguro  
                       tt-it-docto.vl-embalagem = tt-it-docto.vl-embalagem - d-vl-despesa-seguro. 
            END.
        END.      
    END.
    ASSIGN tt-docto.vl-mercad = tt-docto.vl-mercad + tt-docto.vl-frete + tt-docto.vl-seguro
           tt-docto.vl-frete  = 0
           tt-docto.vl-seguro = 0.
END.

