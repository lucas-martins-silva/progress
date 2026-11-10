/*
**
** IM9036.I - Include - Retorna aliquota do imposto de importacao e ipi
**
*/

{cdp/cdcfgmat.i}     /* include preprocessadores magnus */
{include/boerrtab.i} /* include definicao temp-table de erros */

def input  parameter p-numero-ordem   like ordem-compra.numero-ordem no-undo.
def input  parameter p-it-codigo      like item.it-codigo            no-undo.
def input  parameter p-cod-fabricante like emitente.cod-emitente     no-undo.
def input  parameter p-regime-import  as   integer format "99"       no-undo.
def input  parameter p-class-fiscal   like classif-fisc.class-fiscal no-undo.
def output parameter p-de-aliq-ii     as   decimal format ">>9.9999" no-undo.
def output parameter p-de-aliq-ipi    as   decimal format ">>9.99"   no-undo.
def output parameter p-regime         as   logical initial no        no-undo.
def output parameter table for tt-bo-erro.

def var i-orig-aliq-ii as integer no-undo.
def var de-aliq-ii     as decimal no-undo format ">>9.9999".

{cdp/cd4300.i3}  /* include tratamento atributo livre */
{cdp/cd0603.i50} /* include tratamento atributo livre - classif-fisc.char-1 */

/*
** Valida Item
*/
if p-it-codigo <> ? then
    find item
        where item.it-codigo = p-it-codigo no-lock no-error.
else do:
    find ordem-compra
        where ordem-compra.numero-ordem = p-numero-ordem no-lock no-error.
    find item
        where item.it-codigo = ordem-compra.it-codigo no-lock no-error.
end.
if not avail item 
    then leave.
/*
** Busca al¡quota do item/classifica‡Æo fiscal
*/
&if defined(bf-mat-comex) &then
  if item.tipo-contr = "D" then do:
&else
  if item.tipo-contr = 4   then do:
&endif
    assign p-de-aliq-ii = 0.    
    find classif-fisc
        where classif-fisc.class-fiscal = p-class-fiscal no-lock no-error.        
    if avail classif-fisc then do:    
      &if defined(bf-mat-comex) &then
        assign p-de-aliq-ii = decimal(substring(classif-fisc.char-1,10,6)).
      &else
        {cdp/cd4300.i4 "yes" classif-fisc.char-1}
        {cdp/cd0603.i51 "yes"}
        assign p-de-aliq-ii = de-aliq-ii-i50.
      &endif
    end.
  end.
  else 
    assign p-de-aliq-ii = decimal(substring(item.char-2,22,6)).    

/*
** Procura cadastro pa¡s x regime importa‡Æo 
*/
find emitente
    where emitente.cod-emitente = p-cod-fabricante no-lock no-error.
if avail emitente then
    find pais
        where pais.nome-pais = emitente.pais no-lock no-error.
if avail pais then
    find pais-aliquota
        where pais-aliquota.cod-pais      = pais.cod-pais
          and pais-aliquota.regime-import = p-regime-import
          and pais-aliquota.class-fiscal  = p-class-fiscal no-lock no-error.
if avail pais-aliquota then do:
    assign p-de-aliq-ii  = pais-aliquota.aliquota-ii
           p-de-aliq-ipi = pais-aliquota.dec-1
           p-regime      = yes.
end.
    
/*
** Verifica se item ‚ isento de imposto de importa‡Æo
*/     
&if defined(bf-mat-comex) &then
    if substring(item.char-2,20,2) = "I" then
        assign p-de-aliq-ii = 0.
&else
    if integer(substring(item.char-2,20,2)) = 2 then
        assign p-de-aliq-ii = 0.
&endif

/* IM9036.I */
