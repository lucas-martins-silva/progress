/*************************************************************************
***
***  acp/ac9900.i - Verifica se o m¢dulo est  implantado.
***
**************************************************************************/

/**************************************************************************/

find first param-global no-lock no-error.
if avail param-global then do:
   if param-global.modulo-08 = no then do:
      {utp/ut-table.i mgdis cotas 1}
      run utp/ut-msgs.p (input "show",
                         input 2082,
                         input return-value).
      apply "close" to this-procedure.
   end.
end.

/************************* Fim da Include ******************************/  
