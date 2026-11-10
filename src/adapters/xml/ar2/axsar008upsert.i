PROCEDURE PITransUpsert:


DEFINE INPUT PARAMETER i-action       AS INTEGER    NO-UNDO.
DEFINE INPUT PARAMETER c-cod-estabel  AS char       NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.


RUN cep/ceapi017.p (input c-cod-estabel,
                    OUTPUT TABLE tt-estab).


find first param-estoq no-lock no-error.

IF ( c-cod-estabel = ? OR c-cod-estabel = '' ) THEN
   ASSIGN c-estabel = param-estoq.estabel-pad.
ELSE DO:
     if can-find(first item-uni-estab 
                 where item-uni-estab.cod-estabel = c-cod-estabel) then do:
         
         if  not avail estabelec
         or  estabelec.cod-estabel <> c-cod-estabel then
             for first estabelec fields (nome) no-lock
                where estabelec.cod-estabel = c-cod-estabel:
             end.
         
         assign c-estabel = estabelec.nome.
     end.
     else
         assign c-estabel = "".
END.

for each tt-estab:

    IF param-estoq.tp-fech = 1  THEN DO: /*fechamento unico*/
       RUN PIUpsert ( INPUT i-action,
                      INPUT tt-estab.mensal-ate,
                      INPUT "Upd",
                      INPUT tt-estab.ult-fech-dia,
                      INPUT tt-estab.contab-ate,
                      INPUT "SituationClosingProcess",
                      INPUT tt-estab.dt-fim-per,
                      INPUT tt-estab.dt-ini-per,
                      INPUT c-cod-estabel,
                      INPUT c-estabel,         
                      INPUT tt-estab.dat-sumar-ate,
                      INPUT TODAY,
                      OUTPUT TABLE tt_log_erro ).
    end.
    else do:
         RUN PIUpsert ( INPUT i-action,
                        INPUT tt-estab.mensal-ate,
                        INPUT "Upd",
                        INPUT tt-estab.ult-fech-dia,
                        INPUT tt-estab.contab-ate,
                        INPUT "SituationClosingProcess",
                        INPUT tt-estab.dt-fim-per,
                        INPUT tt-estab.dt-ini-per,
                        INPUT c-estabel,
                        INPUT tt-estab.cod-estabel,         
                        INPUT tt-estab.dat-sumar-ate,
                        INPUT TODAY,
                        OUTPUT TABLE tt_log_erro ).
        
    end.
end.

END PROCEDURE.



