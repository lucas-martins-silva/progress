/********************************************************************************
***
*** app/ap0501d.i - Cria TempTable de Erros da Consistˆncia.
***
********************************************************************************/
               
create tt-retorno-lin-i-ap.
assign tt-retorno-lin-i-ap.desc-erro  = trim(return-value)
       tt-retorno-lin-i-ap.cod-erro   = string({1})
       tt-retorno-lin-i-ap.situacao   = l-situacao
       tt-retorno-lin-i-ap.cod-chave  = lin-i-ap.referencia  + "," +
                                 string(lin-i-ap.sequencia)  + "," +
                                 string(lin-i-ap.ep-codigo)  + "," + 
                                        lin-i-ap.cod-estabel + "," +                       
                                        lin-i-ap.cod-esp     + "," +
                                        lin-i-ap.serie       + "," +
                                        lin-i-ap.nr-docto    + "," +
                                        lin-i-ap.parcela     + "," +
                                 string(lin-i-ap.cod-fornec).                                                                                                 
                                                   
/* Fim de Include */
