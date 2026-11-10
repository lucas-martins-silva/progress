/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9012 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im9012 MIM}
&ENDIF

/*****************************************************************************
**
** IM9012 - Integra‡Æo entre Importa‡Æo e Recebimento (EMS)
**
** Objetivo: Consistir se existem t¡tulos no AP das despesas do documento.
**
******************************************************************************/

{utp/ut-glob.i}
{cdp/cdcfgmat.i} /* include preprocessadores magnus */

&if defined(bf-mat-comex) &then
&else
def input        parameter rw-docto   as rowid.  
def input        parameter l-ems50    as logical no-undo.
def input-output parameter l-ap       as logical no-undo.

def var l-erro as logical init no.

{cdp/cd0666.i} /* Definicao TT-ERRO */

{cdp/cd4300.i3} /* vari veis utilizadas pelo cd4300.i4 */

find docum-est 
    where rowid(docum-est) = rw-docto no-lock no-error.
    
{rep/re1001a.i50} /* vari veis e informa‡äes utilizadas pelo re1001a.i51 */    
    
{cdp/cd4300.i4  "yes" docum-est.char-1} 

{rep/re1001a.i51 "yes"}    

find first param-global no-lock no-error.    

for each dupli-apagar-cex 
    where dupli-apagar-cex.serie-docto  = docum-est.serie-docto 
      and dupli-apagar-cex.nro-docto    = docum-est.nro-docto 
      and dupli-apagar-cex.cod-emitente = docum-est.cod-emitente 
      and dupli-apagar-cex.nat-operacao = docum-est.nat-operacao no-lock:
    
    if not l-ems50 then do:
        
       find lin-i-ap
           where lin-i-ap.ep-codigo   = param-global.empresa-prin
             and lin-i-ap.cod-estabel = docum-est.cod-estabel
             and lin-i-ap.cod-esp     = dupli-apagar-cex.cod-esp
             and lin-i-ap.serie       = dupli-apagar-cex.serie-docto
             and lin-i-ap.nr-docto    = c-embarque
             and lin-i-ap.parcela     = dupli-apagar-cex.parcela
             and lin-i-ap.cod-fornec  = dupli-apagar-cex.cod-emitente-desp
           no-lock no-error.
           
        if not available lin-i-ap then do:
           find tit-ap use-index codigo
              where tit-ap.ep-codigo   = param-global.empresa-prin
                and tit-ap.cod-fornec  = dupli-apagar-cex.cod-emitente-desp
                and tit-ap.cod-estabel = docum-est.cod-estabel
                and tit-ap.cod-esp     = dupli-apagar-cex.cod-esp
                and tit-ap.serie       = dupli-apagar-cex.serie-docto
                and tit-ap.nr-docto    = c-embarque
                and tit-ap.parcela     = dupli-apagar-cex.parcela
              no-lock no-error.
           if not avail tit-ap then do:
              assign l-ap = no.
              leave.
           end.              
        end.
    end.    
    else do:
        &IF "{&bf_mat_versao_ems}":U >= "2.062":U &THEN
         IF i-pais-impto-usuario <> 1 THEN
            ASSIGN c-embarque = dupli-apagar-cex.nro-docto.
        &ENDIF
        
        RUN Pi-verifica-EMS50 (input docum-est.cod-estabel,
                               input dupli-apagar-cex.cod-emitente-desp,
                               input dupli-apagar-cex.cod-esp,
                               input dupli-apagar-cex.serie-docto,
                               input c-embarque,
                               input dupli-apagar-cex.parcela,
                               output l-ap,
                               output l-erro).

        if not l-ap or l-erro then 
           leave.
    end.
end.

/* procedure Pi-verifica-EMS50 */
{rep/re1005a.i}

&endif


