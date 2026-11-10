/**************************************************************************
***
*** app/ap0501ed.i - Defini‡Æo da temp-table tt-antecipado 
***                   vinculadas as titulo.
**************************************************************************/

def temp-table tt-antecipado no-undo
    field i-cod-retencao   as integer                  /* Codigo de Retencao da Antecipacao   */
    field de-antec-trib    as decimal                  /* Total dos Valores antecipados       */
    field c-cod-estab      as char format "x(03)"      /* Cod do Estabelimento do IR          */     
    field i-cod-fornec     as int  format ">>>>>>>>9"  /* Cod do Fornecedor                   */
    field c-cod-esp        as character                /* Cod da Especie do Ir                */
    field c-serie          as character                /* Serie da Especie                    */
    field c-nr-docto       as character                /* Numero do Documento do IR           */
    field c-parcela        as character                /* Parcela do IR                       */
    
    INDEX codigo IS PRIMARY 
                 IS UNIQUE i-cod-retencao ASCENDING.


/*--- Total  do valor antecipado sem IR ---*/
def var de-total-antecipado as decimal init 0 no-undo.

/*--- Codigo de Retencao da antecipacao ---*/
def var i-cod-retencao-ant as integer no-undo.


/*--- Fim include ap0501ed.i ---*/
