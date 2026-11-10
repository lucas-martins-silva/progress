/*****************************************************************************
**
** IM9002 - Integra‡Æo entre Importa‡Æo e Recebimento (EMS)
**
** Objetivo: Eliminar as despesas de importa‡Æo relacionada a nota do 
**           recebimento e suas respectivas duplicatas.
**           
******************************************************************************/

{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */
{utp/ut-glob.i}

def input parameter rw-docum-est as rowid.

find docum-est where rowid(docum-est) = rw-docum-est no-lock no-error.
     
for each dupli-apagar-cex   
    where dupli-apagar-cex.cod-emitente  = docum-est.cod-emitente
      and dupli-apagar-cex.nat-operacao  = docum-est.nat-operacao      
      &if defined(bf-mat-comex) &then      
          and dupli-apagar-cex.nro-docto = string(docum-est.nro-docto)
      &else
          and dupli-apagar-cex.nro-docto = docum-est.nro-docto
      &endif
      and dupli-apagar-cex.serie-docto   = docum-est.serie-docto exclusive-lock:      
    delete dupli-apagar-cex.
end.      
 
for each docum-est-cex 
    where docum-est-cex.cod-emitente  = docum-est.cod-emitente
      and docum-est-cex.nat-operacao  = docum-est.nat-operacao
      &if defined(bf-mat-comex) &then            
          and docum-est-cex.nro-docto = string(docum-est.nro-docto)
      &else
          and docum-est-cex.nro-docto = docum-est.nro-docto
      &endif
      and docum-est-cex.serie-docto   = docum-est.serie-docto exclusive-lock:
    for each item-doc-est-cex 
        where item-doc-est-cex.serie-docto  = docum-est-cex.serie-docto
          and item-doc-est-cex.nro-docto    = docum-est-cex.nro-docto
          and item-doc-est-cex.cod-emitente = docum-est-cex.cod-emitente
          and item-doc-est-cex.nat-operacao = docum-est-cex.nat-operacao exclusive-lock:

        for each desp-embarque 
           &if "{&bf_mat_versao_ems}" >= "2.06" &then
           where desp-embarque.cod-estabel = item-doc-est-cex.cod-estabel
             and desp-embarque.embarque    = item-doc-est-cex.embarque
             and desp-embarque.cod-desp    = item-doc-est-cex.cod-desp
           &else
           where desp-embarque.cod-estabel = substring(item-doc-est-cex.char-1,13,3)
             and desp-embarque.embarque    = substring(item-doc-est-cex.char-1,1,12)
             and desp-embarque.cod-desp    = item-doc-est-cex.cod-desp
           &endif
           exclusive-lock:
           &if "{&bf_mat_versao_ems}" >= "2.06" &then
               assign desp-embarque.log-despes-ja-recbda = no.
           &else
               assign desp-embarque.log-1 = no.
           &endif
        end.

        IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:
            FIND FIRST item-doc-est-cex-internac OF item-doc-est-cex EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL item-doc-est-cex-internac THEN
                DELETE item-doc-est-cex-internac.
        END.

        delete item-doc-est-cex.
    end.
    delete docum-est-cex.
end.

