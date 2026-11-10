/*****************************************************************************
**
** IM9000.i - Integra‡Æo entre Importa‡Æo e Recebimento (EMS)
**
** Objetivo : Valor do ICMS no total do nota.
**
******************************************************************************/

{include/i_fncrowid.i}
{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */

DEFINE VARIABLE l-icms-diferido AS LOGICAL     NO-UNDO.

&if defined(bf-mat-comex) &then
    def input parameter rw-docum-est as &IF {&ROWID_READY} = YES &THEN 
                                            ROWID
                                        &ELSE 
                                            RECID
                                        &ENDIF.
    
    for first docum-est fields(tot-valor icm-deb-cre cod-estabel cod-emitente nat-operacao)
        where &IF {&ROWID_READY} = YES &THEN 
                ROWID(docum-est)
              &ELSE 
                recid(docum-est)
              &ENDIF        
              = rw-docum-est exclusive-lock:
    end.
&else
    def input parameter rw-docum-est as rowid.
DEF VAR l-icms-deson   AS LOGICAL INITIAL NO NO-UNDO.
DEF VAR de-icms-deson  LIKE ct-trib-item-doc-est.val-trib NO-UNDO.
    
    for first docum-est fields(tot-valor icm-deb-cre cod-estabel cod-emitente nat-operacao)
        where rowid(docum-est) = rw-docum-est exclusive-lock:
    end.
&endif

// Verifica se o ICMS ‚ Diferido, e se o estabelecimento ‚ do Cear  (somente no CE dever  mudar o valor total da nota)
ASSIGN l-icms-diferido = NO.
FIND FIRST natur-oper NO-LOCK
    WHERE  natur-oper.nat-operacao = docum-est.nat-operacao NO-ERROR.
IF  AVAIL  natur-oper AND natur-oper.ind-it-sub-dif = ? THEN DO:
    FIND FIRST estabelec NO-LOCK
        WHERE  estabelec.cod-estabel = docum-est.cod-estabel NO-ERROR.
    IF  AVAIL  estabelec AND estabelec.estado = "CE" THEN
        ASSIGN l-icms-diferido = YES.
END.
    
for first param-imp fields(inc-icms-tot-nf)
    where param-imp.cod-estabel = docum-est.cod-estabel no-lock:
end.

/* ICMS Desonerado nÆo soma no total da nota */
ASSIGN de-icms-deson = 0.
FOR EACH ct-trib-item-doc-est NO-LOCK
    WHERE ct-trib-item-doc-est.cdn-emitente     = docum-est.cod-emitente   
      AND ct-trib-item-doc-est.cod-ser-docto    = docum-est.serie-docto       
      AND ct-trib-item-doc-est.cod-docto        = docum-est.nro-docto 
      AND ct-trib-item-doc-est.cod-natur-operac = docum-est.nat-operacao:
      IF ct-trib-item-doc-est.cod-tip-trib  = "icms desonerado":U THEN
         ASSIGN l-icms-deson  = YES
                de-icms-deson = de-icms-deson + ct-trib-item-doc-est.val-trib.
END.
if avail param-imp THEN DO:
   IF NOT param-imp.inc-icms-tot-nf OR l-icms-diferido THEN  // Quando o ICMS ‚ diferido, nÆo deve ir para o total da nota
      assign docum-est.tot-valor = docum-est.tot-valor
                                 - docum-est.icm-deb-cre.
   ELSE 
      IF l-icms-deson AND de-icms-deson > 0 THEN
         assign docum-est.tot-valor = docum-est.tot-valor
                                    - de-icms-deson.
END.
/* IM9000.I */
