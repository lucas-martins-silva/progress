/*****************************************************************************
**
** IM9001 - Integra‡Æo entre Importa‡Æo e Recebimento (EMS)
**
** Objetivo: Duplicata das despesas.
**
******************************************************************************/

{include/i_fncrowid.i}
{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */

&if defined(bf-mat-comex) &then
    def input parameter rw-docum-est as &IF {&ROWID_READY} = YES &THEN 
                                            ROWID
                                        &ELSE 
                                            RECID
                                        &ENDIF.
    def input parameter rw-param-ap  as &IF {&ROWID_READY} = YES &THEN 
                                            ROWID
                                        &ELSE 
                                            RECID
                                        &ENDIF.
&else    
    def input parameter rw-docum-est as rowid.
    def input parameter rw-param-ap  as rowid.
&endif
def input-output parameter da-dt-aux    as date format 99/99/9999 no-undo.
def input-output parameter l-erro-ap    as logical no-undo.

def var de-fator1 as decimal no-undo.

&if defined(bf-mat-comex) &then
    find first docum-est
        where &IF {&ROWID_READY} = YES &THEN 
                ROWID(docum-est)
              &ELSE 
                recid(docum-est)
              &ENDIF
              = rw-docum-est no-lock no-error.        
    find first param-ap 
        where &IF {&ROWID_READY} = YES &THEN 
                ROWID(param-ap)
              &ELSE 
                recid(param-ap)
              &ENDIF        
              = rw-param-ap no-lock no-error.    
    {rep/re9340.i7 "-cex" "string"}   /* Atualiza Estat¡stica */        
&else
    find first docum-est
        where rowid(docum-est) = rw-docum-est no-lock no-error.        
    find first param-ap 
        where rowid(param-ap) = rw-param-ap no-lock no-error.    
    {rep/re9340.i7 "-cex"}   /* Atualiza Estatistica */
&endif        
        

     
