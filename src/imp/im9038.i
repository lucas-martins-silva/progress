/*******************************************************************************
**   Programa: IM9038.i
**   Objetivo: Integra‡Æo entre os m¢dulos de Importa‡Æo e Recebimento.
**             Retorna a data de cota‡Æo do embarque. 
****************************************************************************/

define input  param r-docto as rowid.
define output param da-dt-emis as date.

{cdp/cdcfgmat.i} /* Definicao de pre-processadores */
{cdp/cd4300.i3}   /* variavel tratamento char-1 */
{rep/re1001a.i50} /* variaveis char-1 docum-est */
    
find docum-est where rowid(docum-est) = r-docto no-lock no-error.    

{cdp/cd4300.i4  "yes" docum-est.char-1}
{rep/re1001a.i51 "yes"}    
                           
find embarque-imp 
    where embarque-imp.cod-estabel = docum-est.cod-estabel 
      and embarque-imp.embarque    = c-embarque no-lock no-error.   
if avail embarque-imp then   
   assign da-dt-emis = embarque-imp.data-1.    

/* im9038 */
