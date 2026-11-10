/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0005 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im0005 MIM}
&ENDIF


/* IM0005.p: Retorna observa‡Æo para nota fiscal (ft2010) */ 
     
def input  param p-serie            like nota-fiscal.serie        no-undo.
def input  param p-nota             like nota-fiscal.nr-nota-fis  no-undo.
def input  param p-emitente         like nota-fiscal.cod-emitente no-undo.
def input  param p-nat-operacao     like nota-fiscal.nat-operacao no-undo.
def input-output param p-observacao as char                       no-undo.

{cdp/cdcfgcex.i}

  for each docum-est-cex
    where docum-est-cex.serie        = p-serie
    &if defined(bf-mat-comex) &then
      and docum-est-cex.nro-docto    = string(p-nota)
    &else              
      and docum-est-cex.nro-docto    = p-nota
    &endif        
      and docum-est-cex.cod-emitente = p-emitente
      and docum-est-cex.nat-operacao = p-nat-operacao
      no-lock:
    find desp-imp
        where desp-imp.cod-desp = docum-est-cex.cod-desp
        no-lock no-error.
    /* Imprime Nota Fiscal */                
    if desp-imp.log-1 then 
       assign p-observacao = p-observacao + " | "
                                          + string(desp-imp.cod-desp) + "-"
                                          + desp-imp.descricao + " / "
                                          + trim(string(docum-est-cex.val-desp,">>>>>,>>>,>>9.99999")).
  end.     

return "OK":U.
