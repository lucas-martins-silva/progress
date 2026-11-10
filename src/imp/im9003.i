/*****************************************************************************
**
** IM9003.I - Integracao entre Importacao e Obrigacoes Fiscais (EMS)
**
** Objetivo: Ajustar valores em OF conforme uma nota de Importacao
**
******************************************************************************/

{include/i_fncrowid.i}
{cdp/cdcfgmat.i} /* Definicao de pre-processadores */

DEFINE VARIABLE l-icms-diferido AS LOGICAL     NO-UNDO.

def input parameter p-de-valor-icm like it-doc-fisc.vl-icms-it no-undo.

&if defined(bf-mat-comex) &then
    def input parameter rw-item as &IF {&ROWID_READY} = YES &THEN 
                                    ROWID
                                   &ELSE 
                                    RECID
                                   &ENDIF.
    
    for first it-doc-fisc fields(vl-tot-item cod-estabel cod-emitente nat-operacao)
        where &IF {&ROWID_READY} = YES &THEN 
                ROWID(it-doc-fisc)
              &ELSE 
                recid(it-doc-fisc)
              &ENDIF
              = rw-item exclusive-lock:
    end.        
        
&else
    def input parameter rw-item as rowid.
DEF VAR l-icms-deson  AS LOGICAL INITIAL NO NO-UNDO.
DEF VAR de-icms-deson LIKE ct-trib-item-doc-est.val-trib NO-UNDO.
    
    for first it-doc-fisc fields(vl-tot-item cod-estabel cod-emitente nat-operacao)
        where rowid(it-doc-fisc) = rw-item exclusive-lock:
    end.
    
&endif

// Verifica se o ICMS ‚ Diferido, e se o estabelecimento ‚ do Cear  (somente no CE dever  mudar o valor total da nota)
ASSIGN l-icms-diferido = NO.
FIND FIRST natur-oper NO-LOCK
    WHERE  natur-oper.nat-operacao = it-doc-fisc.nat-operacao NO-ERROR.
IF  AVAIL  natur-oper AND natur-oper.ind-it-sub-dif = ? THEN DO:
    FIND FIRST estabelec NO-LOCK
        WHERE  estabelec.cod-estabel = it-doc-fisc.cod-estabel NO-ERROR.
    IF  AVAIL  estabelec AND estabelec.estado = "CE" THEN
        ASSIGN l-icms-diferido = YES.
END.
    
for first param-imp fields(inc-icms-tot-nf)
    where param-imp.cod-estabel = it-doc-fisc.cod-estabel no-lock:
end.

/* ICMS Desonerado nÆo soma no total da nota */
ASSIGN de-icms-deson = 0.
FOR EACH ct-trib-item-doc-est NO-LOCK
    WHERE ct-trib-item-doc-est.cdn-emitente     = it-doc-fisc.cod-emitente   
      AND ct-trib-item-doc-est.cod-ser-docto    = it-doc-fisc.serie       
      AND ct-trib-item-doc-est.cod-docto        = it-doc-fisc.nr-doc-fis 
      AND ct-trib-item-doc-est.cod-natur-operac = it-doc-fisc.nat-operacao
      AND ct-trib-item-doc-est.num-seq          = it-doc-fisc.nr-seq-doc
      AND ct-trib-item-doc-est.cod-item         = it-doc-fisc.it-codigo:
    IF ct-trib-item-doc-est.cod-tip-trib  = "icms desonerado":U THEN
       ASSIGN l-icms-deson  = YES
              de-icms-deson = de-icms-deson + ct-trib-item-doc-est.val-trib.
END.

if avail param-imp THEN DO:
   IF NOT param-imp.inc-icms-tot-nf OR l-icms-diferido THEN  // Quando o ICMS ‚ diferido, nÆo deve ir para o total da nota
      assign it-doc-fisc.vl-tot-item = it-doc-fisc.vl-tot-item
                                     - p-de-valor-icm.
   ELSE 
      IF l-icms-deson AND de-icms-deson > 0 THEN
         assign it-doc-fisc.vl-tot-item = it-doc-fisc.vl-tot-item
                                        - de-icms-deson.
END.

/* IM9003.I */
