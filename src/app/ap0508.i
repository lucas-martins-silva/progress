/*************************************************************************
**
** Include: AP0508.I - Verifica‡Æo de contas cont beis informadas
**
*************************************************************************/
if  not avail conta-contab 
or  conta-contab.ep-codigo      <> i-ep-codigo-usuario
or  conta-contab.conta-contabil <> input frame {&frame-name} mov-pef-pend.conta-contabil then
    find conta-contab
        where conta-contab.ep-codigo      = i-ep-codigo-usuario
          and conta-contab.conta-contabil = input frame {&frame-name} mov-pef-pend.conta-contabil
          no-lock no-error.
if  not avail conta-contab then do:
    {utp/ut-table.i mgadm conta-contab 1}
    run utp/ut-msgs.p (input "show",
                       input 56,
                       input return-value).
    apply 'entry':U to mov-pef-pend.conta-contabil in frame {&frame-name}.
    return 'ADM-ERROR':U.
end.

if  conta-contab.tipo = 6 then do:
    run utp/ut-msgs.p (input "show",
                       input 636,
                       input conta-contab.conta-contabil).
    apply 'entry':U to mov-pef-pend.conta-contabil in frame {&frame-name}.
    return 'ADM-ERROR':U.
end.

if  conta-contab.estado <> 3 then do:
    run utp/ut-msgs.p (input "show",
                       input 638,
                       input conta-contab.conta-contabil).
    apply 'entry':U to mov-pef-pend.conta-contabil in frame {&frame-name}.
    return 'ADM-ERROR':U.
end.

if  conta-contab.contas-pagar = 1 then do:
    run utp/ut-msgs.p (input "show",
                       input 637,
                       input conta-contab.conta-contabil).
    apply 'entry':U to mov-pef-pend.conta-contabil in frame {&frame-name}.
    return 'ADM-ERROR':U.
end.

if  conta-contab.caixa-bancos = 3 then do:
    run utp/ut-msgs.p (input "show",
                       input 639,
                       input conta-contab.conta-contabil).
    apply 'entry':U to mov-pef-pend.conta-contabil in frame {&frame-name}.
    return 'ADM-ERROR':U.
end.

/* AP0508.I */
