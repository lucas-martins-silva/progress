if iBancoIni = iBancoFim then
   open query {&QUERY-NAME} for each {&TABLE-NAME}
        WHERE movto-aplic-empr.ep-codigo     = i-ep-codigo-usuario 
        AND   movto-aplic-empr.banco         = iBancoIni
        AND   movto-aplic-empr.agencia      >= cAgenciaIni
        AND   movto-aplic-empr.agencia      <= cAgenciaFim
        AND   movto-aplic-empr.cta-corrente >= cCtaCorrenteIni
        AND   movto-aplic-empr.cta-corrente <= cCtaCorrenteFim
        AND   movto-aplic-empr.dt-movto     >= dDtMovtoIni
        AND   movto-aplic-empr.dt-movto     <= dDtMovtoFim        
        AND   movto-aplic-empr.transacao     = 2
        NO-LOCK,
        each  tipo-modalidade
        where tipo-modalidade.codigo    = movto-aplic-empr.cod-mod
        and   tipo-modalidade.transacao = 2 no-lock
        by {1}.
else
   if dDtMovtoIni = dDtMovtoFim then
      open query {&QUERY-NAME} for each {&TABLE-NAME}
           WHERE movto-aplic-empr.ep-codigo     = i-ep-codigo-usuario 
           AND   movto-aplic-empr.dt-movto      = dDtMovtoIni
           AND   movto-aplic-empr.banco        >= iBancoIni
           AND   movto-aplic-empr.banco        <= iBancoFim                    
           AND   movto-aplic-empr.agencia      >= cAgenciaIni
           AND   movto-aplic-empr.agencia      <= cAgenciaFim
           AND   movto-aplic-empr.cta-corrente >= cCtaCorrenteIni
           AND   movto-aplic-empr.cta-corrente <= cCtaCorrenteFim
           AND   movto-aplic-empr.transacao     = 2
           NO-LOCK,
           each  tipo-modalidade
           where tipo-modalidade.codigo    = movto-aplic-empr.cod-mod
           and   tipo-modalidade.transacao = 2 no-lock
           by {1}.

   else
      open query {&QUERY-NAME} for each {&TABLE-NAME}
           WHERE movto-aplic-empr.ep-codigo     = i-ep-codigo-usuario 
           AND   movto-aplic-empr.banco        >= iBancoIni
           AND   movto-aplic-empr.banco        <= iBancoFim                    
           AND   movto-aplic-empr.agencia      >= cAgenciaIni
           AND   movto-aplic-empr.agencia      <= cAgenciaFim
           AND   movto-aplic-empr.cta-corrente >= cCtaCorrenteIni
           AND   movto-aplic-empr.cta-corrente <= cCtaCorrenteFim
           AND   movto-aplic-empr.dt-movto     >= dDtMovtoIni
           AND   movto-aplic-empr.dt-movto     <= dDtMovtoFim        
           AND   movto-aplic-empr.transacao     = 2
           NO-LOCK,
           each  tipo-modalidade
           where tipo-modalidade.codigo    = movto-aplic-empr.cod-mod
           and   tipo-modalidade.transacao = 2 no-lock
           by {1}.
