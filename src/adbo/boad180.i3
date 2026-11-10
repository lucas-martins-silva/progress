if i-cod-fornec-ini = i-cod-fornec-fim then
    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
               where {&TABLE-NAME}.ep-codigo     = i-empresa          and
                     {&TABLE-NAME}.cod-fornec    = i-cod-fornec-ini   AND 
                     {&TABLE-NAME}.dt-transacao >= d-dt-transacao-ini AND
                     {&TABLE-NAME}.dt-transacao <= d-dt-transacao-fim 
                     by {&TABLE-NAME}.{1} INDEXED-REPOSITION.
else do:
    if d-dt-transacao-ini = d-dt-transacao-fim then 
        open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                   where {&TABLE-NAME}.ep-codigo     = i-empresa          and
                         {&TABLE-NAME}.dt-transacao  = d-dt-transacao-ini and
                         {&TABLE-NAME}.cod-fornec   >= i-cod-fornec-ini   AND 
                         {&TABLE-NAME}.cod-fornec   <= i-cod-fornec-fim   
                         by {&TABLE-NAME}.{1} INDEXED-REPOSITION.    
    else
        open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                   where {&TABLE-NAME}.ep-codigo     = i-empresa          and
                         {&TABLE-NAME}.cod-fornec   >= i-cod-fornec-ini   AND 
                         {&TABLE-NAME}.cod-fornec   <= i-cod-fornec-fim   AND
                         {&TABLE-NAME}.dt-transacao >= d-dt-transacao-ini AND
                         {&TABLE-NAME}.dt-transacao <= d-dt-transacao-fim 
                         by {&TABLE-NAME}.{1} INDEXED-REPOSITION.
end.

