/***************************************************************************
**  IM9037.i - Altera‡Æo do n£mero da nota fiscal nas tabelas de Importa‡Æo.
****************************************************************************/

{include/i_fncrowid.i}
{cdp/cdcfgmat.i} /* Definicao de pre-processadores */

&if defined(bf-mat-comex) &then   
  def input parameter r-docto as &IF {&ROWID_READY} = YES &THEN 
                                    ROWID
                                 &ELSE 
                                    RECID
                                 &ENDIF.
  def input parameter i-novo-nro like docum-est.nro-docto.
  &IF '{&BF_MAT_VERSAO_EMS}' >= '2.04' &THEN
    def input parameter c-serie-nova like docum-est.serie-docto.
  &ENDIF

  FOR FIRST docum-est 
      where &IF {&ROWID_READY} = YES &THEN 
                ROWID(docum-est)
            &ELSE 
                recid(docum-est)
            &ENDIF
            = r-docto NO-LOCK: 
  END.
&else
  def input parameter r-docto as rowid.
  def input parameter i-novo-nro like docum-est.nro-docto.
  &IF '{&BF_MAT_VERSAO_EMS}' >= '2.04' &THEN
    def input parameter c-serie-nova like docum-est.serie-docto.
  &ENDIF
     
  FOR FIRST docum-est 
      where rowid(docum-est) = r-docto NO-LOCK: END.
&endif
    
for each docum-est-cex exclusive-lock where
    docum-est-cex.serie-docto   = docum-est.serie-docto and
    &if defined(bf-mat-comex) &then
        docum-est-cex.nro-docto = string(docum-est.nro-docto) and
    &else
        docum-est-cex.nro-docto = docum-est.nro-docto and
    &endif
    docum-est-cex.cod-emitente  = docum-est.cod-emitente and
    docum-est-cex.nat-operacao  = docum-est.nat-operacao :
    &if defined(bf-mat-comex) &then
        assign docum-est-cex.nro-docto = string(i-novo-nro).
    &else
        assign docum-est-cex.nro-docto = i-novo-nro.
    &endif    
    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.04' &THEN
        assign docum-est-cex.serie-docto = c-serie-nova.
    &ENDIF
end.
    
for each item-doc-est-cex exclusive-lock where
    item-doc-est-cex.serie-docto   = docum-est.serie-docto and
    &if defined(bf-mat-comex) &then
        item-doc-est-cex.nro-docto = string(docum-est.nro-docto) and
    &else    
        item-doc-est-cex.nro-docto = docum-est.nro-docto and
    &endif
    item-doc-est-cex.cod-emitente  = docum-est.cod-emitente and
    item-doc-est-cex.nat-operacao  = docum-est.nat-operacao :
    &if defined(bf-mat-comex) &then
        assign item-doc-est-cex.nro-docto = string(i-novo-nro).
    &else    
        assign item-doc-est-cex.nro-docto = i-novo-nro.
    &endif    
    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.04' &THEN
        assign item-doc-est-cex.serie-docto = c-serie-nova.
    &ENDIF
end.   
     
for each dupli-apagar-cex exclusive-lock where
    dupli-apagar-cex.serie-docto   = docum-est.serie-docto and
    &if defined(bf-mat-comex) &then
        dupli-apagar-cex.nro-docto = string(docum-est.nro-docto) and
    &else    
        dupli-apagar-cex.nro-docto = docum-est.nro-docto and
    &endif    
    dupli-apagar-cex.cod-emitente  = docum-est.cod-emitente and
    dupli-apagar-cex.nat-operacao  = docum-est.nat-operacao :
    &if defined(bf-mat-comex) &then
        assign dupli-apagar-cex.nro-docto = string(i-novo-nro).
    &else    
        assign dupli-apagar-cex.nro-docto = i-novo-nro.
    &endif    
    
    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.04' &THEN
        assign dupli-apagar-cex.serie-docto = c-serie-nova.
    &ENDIF
    
    if not docum-est.ap-atual and
       &if defined(bf-mat-comex) &then
           dupli-apagar-cex.nr-duplic = string(docum-est.nro-docto) then 
           assign dupli-apagar-cex.nr-duplic = string(i-novo-nro).   
       &else
           dupli-apagar-cex.nr-duplic = docum-est.nro-docto then
           assign dupli-apagar-cex.nr-duplic = i-novo-nro.
       &endif    
end.
 
&IF '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN
 FOR EACH  embarq-import-docto EXCLUSIVE-LOCK
     WHERE embarq-import-docto.cdn-emitente     = docum-est.cod-emitente
       AND embarq-import-docto.cod-docto        = docum-est.nro-docto
       AND embarq-import-docto.cod-ser-docto    = docum-est.serie-docto
       AND embarq-import-docto.cod-natur-operac = docum-est.nat-operacao:
     ASSIGN embarq-import-docto.cod-docto     = i-novo-nro
            embarq-import-docto.cod-ser-docto = c-serie-nova.
 END.
&ENDIF

FIND FIRST duimp-item WHERE duimp-item.serie-docto  = docum-est.serie-docto
                        AND duimp-item.nro-docto    = docum-est.nro-docto
                        AND duimp-item.cod-emitente = docum-est.cod-emitente
                        AND duimp-item.nat-operacao = docum-est.nat-operacao EXCLUSIVE-LOCK NO-ERROR.
    
IF AVAIL duimp-item THEN DO:
    ASSIGN duimp-item.serie-docto  = c-serie-nova
           duimp-item.nro-docto    = i-novo-nro.
END.

IF CAN-FIND(FIRST funcao WHERE 
   funcao.cd-funcao = "spp-ifric22":U AND funcao.ativo = YES) THEN DO:
   FOR EACH antecip-import EXCLUSIVE-LOCK
       WHERE antecip-import.cdn-emitente = docum-est.cod-emitente   
         AND antecip-import.nro-docto    = docum-est.nro-docto      
         AND antecip-import.serie-docto  = docum-est.serie-docto    
         AND antecip-import.nat-operacao = docum-est.nat-operacao:  
       ASSIGN antecip-import.nro-docto   = i-novo-nro 
              antecip-import.serie-docto = c-serie-nova.
   END. 
END.

/*im9037.p*/              
