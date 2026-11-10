/********************************************************************************
***
*** app/ap0505g.i - Cria TempTable de Retorno da Consistˆncia.
***
********************************************************************************/
                
create tt-retorno-lin-b-ap.
assign tt-retorno-lin-b-ap.desc-erro  = trim(return-value)
       tt-retorno-lin-b-ap.cod-erro   = "{1}"
       tt-retorno-lin-b-ap.situacao   = no
       tt-retorno-lin-b-ap.cod-chave  = lin-b-ap.referencia  + "," +
                                 string(lin-b-ap.sequencia)  + "," +
                                 string(lin-b-ap.ep-codigo)  + "," +
                                        lin-b-ap.cod-estabel + "," +                       
                                        lin-b-ap.cod-esp     + "," +
                                        lin-b-ap.serie       + "," +
                                        lin-b-ap.nr-docto    + "," +
                                        lin-b-ap.parcela     + "," +
                                 string(lin-b-ap.cod-fornec).
       
                                            
/* Fim de Include */
