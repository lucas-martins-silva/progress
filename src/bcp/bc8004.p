/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC8004 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" 
&THEN
{include/i-license-manager.i BC8004 MBC}
&ENDIF



/*******************************************************************************
**
**   Programa..: bc8004.p
**
**   VersÆo....: 01.00.00 - Datasul
**
**   Objetivo..: Programa de conversÆo de temp-table
*********************************************************************************/
{include/i_dbvers.i}
{bcp/bcapi002.i} /* Defini‡Æo atual da temp-table tt-etiqueta */

def temp-table tt-etiqueta-001 NO-UNDO
    field cod-versao-integracao as inte                             /* Obrigatorio     */
    field i-sequen              as inte                             /* Obrigatorio     */
    field nr-trans              like bc-trans.nr-trans              /* Nao Obrigatorio */
    field nr-trans-ant          like bc-trans.nr-trans              /* Nao Obrigatorio */
    field cd-trans              like bc-trans.cd-trans              /* Obrigatorio     */
    field usuario               as char format "x(12)"              /* Nao Obrigatorio */
    field arquivo               as char format "X(100)"             /* Nao Obrigatorio */
    field cod-unico             like bc-ext-saldo-estoq.cod-unico   /* Reservado       */
    field it-codigo             as char format "x(16)"              /* Obrigatorio     */
    field dt-impressao          as date format "99/99/9999"         /* Nao Obrigatorio */
    field dt-val-lote           as date format "99/99/9999"         /* Nao Obrigatorio */
    field cod-depos             as char format "x(03)"              /* Obrigatorio     */
    field desc-item             as char format "X(36)"              /* Nao Obrigatorio */
&IF "{&mguni_version}" >= "2.071" &THEN
    field cod-estabel           as char format "x(05)"              /* Obrigatorio     */
&ELSE
    field cod-estabel           as char format "x(03)"              /* Obrigatorio     */
&ENDIF
    field hora-Impressao        as char format "x(08)"              /* Nao Obrigatorio */
    field cod-localiz           as char format "x(20)"              /* Obrigatorio     */
    field lote                  as char format "x(40)"              /* Obrigatorio     */
    field nr-docto              as char format "x(16)"              /* Obrigatorio     */
    field quantidade            as deci format "->>>>,>>>,>>9.9999" /* Obrigatorio     */
    field qt-etiqueta           as inte                             /* Nao Obrigatorio */
    field cod-referencia        as char format "x(08)"              /* Nao Obrigatorio */
    field tipo-etiq             like tipo-etiqueta.tipo-etiq        /* Reservado       */
    field desc-etiqueta         as char format "X(050)"             /* Nao Obrigatorio */
    field observacao            as char format "X(100)"             /* Nao Obrigatorio */
    field serie-docto           as char format "x(05)"              /* Nao Obrigatorio */
    field cod-emitente          as inte format ">>>>>>>>9"          /* Nao Obrigatorio */
    field nat-operacao          as char format "9.99-XXX"           /* Nao Obrigatorio */
    field auxiliar-01           as char format "X(001)"             /* Nao Obrigatorio */
    field auxiliar-02           as char format "X(001)"             /* Nao Obrigatorio */
    field auxiliar-03           as char format "X(001)"             /* Nao Obrigatorio */
    field auxiliar-04           as char format "X(001)"             /* Nao Obrigatorio */
    field auxiliar-05           as char format "X(001)"             /* Nao Obrigatorio */
    field auxiliar-06           as char format "X(001)"             /* Nao Obrigatorio */
    field auxiliar-07           as char format "X(001)"             /* Nao Obrigatorio */
    field auxiliar-08           as char format "X(001)"             /* Nao Obrigatorio */
    field auxiliar-09           as char format "X(001)"             /* Nao Obrigatorio */
    field auxiliar-10           as char format "X(001)"             /* Nao Obrigatorio */
    index ch-seq is unique primary i-sequen.

def temp-table tt-etiqueta-002 NO-UNDO
    field cod-versao-integracao as inte                             /* Obrigatorio     */
    field i-sequen              as inte                             /* Obrigatorio     */
    field nr-trans              like bc-trans.nr-trans              /* Nao Obrigatorio */
    field nr-trans-ant          like bc-trans.nr-trans              /* Nao Obrigatorio */
    field cd-trans              like bc-trans.cd-trans              /* Obrigatorio     */
    field usuario               as char format "x(12)"              /* Nao Obrigatorio */
    field arquivo               as char format "X(100)"             /* Nao Obrigatorio */
    field cod-unico             like bc-ext-saldo-estoq.cod-unico   /* Reservado       */
    field it-codigo             as char format "x(16)"              /* Obrigatorio     */
    field dt-impressao          as date format "99/99/9999"         /* Nao Obrigatorio */
    field dt-val-lote           as date format "99/99/9999"         /* Nao Obrigatorio */
    field cod-depos             as char format "x(03)"              /* Obrigatorio     */
    field desc-item             as char format "X(36)"              /* Nao Obrigatorio */
&IF "{&mguni_version}" >= "2.071" &THEN
    field cod-estabel           as char format "x(05)"              /* Obrigatorio     */
&ELSE
    field cod-estabel           as char format "x(03)"              /* Obrigatorio     */
&ENDIF
    field hora-Impressao        as char format "x(08)"              /* Nao Obrigatorio */
    field cod-localiz           as char format "x(20)"              /* Obrigatorio     */
    field lote                  as char format "x(40)"              /* Obrigatorio     */
    field nr-docto              as char format "x(16)"              /* Obrigatorio     */
    field quantidade            as deci format "->>>>,>>>,>>9.9999" /* Obrigatorio     */
    field qt-etiqueta           as inte                             /* Nao Obrigatorio */
    field cod-referencia        as char format "x(08)"              /* Nao Obrigatorio */
    field tipo-etiq             like tipo-etiqueta.tipo-etiq        /* Reservado       */
    field desc-etiqueta         as char format "X(050)"             /* Nao Obrigatorio */
    field observacao            as char format "X(100)"             /* Nao Obrigatorio */
    field serie-docto           as char format "x(05)"              /* Nao Obrigatorio */
    field cod-emitente          as inte format ">>>>>>>>9"          /* Nao Obrigatorio */
    field nat-operacao          as char format "9.99-XXX"           /* Nao Obrigatorio */
    field auxiliar-01           as char format "X(001)"             /* Nao Obrigatorio */
    field auxiliar-02           as char format "X(001)"             /* Nao Obrigatorio */
    field auxiliar-03           as char format "X(001)"             /* Nao Obrigatorio */
    field auxiliar-04           as char format "X(001)"             /* Nao Obrigatorio */
    field auxiliar-05           as char format "X(001)"             /* Nao Obrigatorio */
    field auxiliar-06           as char format "X(001)"             /* Nao Obrigatorio */
    field auxiliar-07           as char format "X(001)"             /* Nao Obrigatorio */
    field auxiliar-08           as char format "X(001)"             /* Nao Obrigatorio */
    field auxiliar-09           as char format "X(001)"             /* Nao Obrigatorio */
    field auxiliar-10           as char format "X(001)"             /* Nao Obrigatorio */
    field data-movimento        as date format "99/99/9999"         /* Nao Obrigatorio */
    field nr-sequencia          as inte format ">>9"                /* Nao Obrigatorio */
    index ch-seq is unique primary i-sequen.

def temp-table tt-etiqueta-003 NO-UNDO
    field cod-versao-integracao as inte                             /* Obrigatorio     */
    field i-sequen              as inte                             /* Obrigatorio     */
    field nr-trans              as deci format "zzzzzzzzz9"         /* Nao Obrigatorio */
    field nr-trans-ant          as deci format "zzzzzzzzz9"         /* Nao Obrigatorio */
    field cd-trans              as char format "x(8)"               /* Obrigatorio     */
    field usuario               as char format "x(12)"              /* Nao Obrigatorio */
    field arquivo               as char format "x(100)"             /* Nao Obrigatorio */
    field cod-unico             as char format "x(16)"              /* Reservado       */
    field it-codigo             as char format "x(16)"              /* Obrigatorio     */
    field dt-impressao          as date format "99/99/9999"         /* Nao Obrigatorio */
    field dt-val-lote           as date format "99/99/9999"         /* Nao Obrigatorio */
    field cod-depos             as char format "x(3)"               /* Obrigatorio     */
    field desc-item             as char format "x(36)"              /* Nao Obrigatorio */
&IF "{&mguni_version}" >= "2.071" &THEN
    field cod-estabel           as char format "x(05)"               /* Obrigatorio     */
&ELSE
    field cod-estabel           as char format "x(3)"               /* Obrigatorio     */
&ENDIF
    field hora-Impressao        as char format "x(8)"               /* Nao Obrigatorio */
    field cod-localiz           as char format "x(20)"              /* Obrigatorio     */
    field lote                  as char format "x(40)"              /* Obrigatorio     */
    field nr-docto              as char format "x(16)"              /* Obrigatorio     */
    field quantidade            as deci format "->>>>,>>>,>>9.9999" /* Obrigatorio     */
    field qt-etiqueta           as inte                             /* Nao Obrigatorio */
    field cod-referencia        as char format "x(8)"               /* Nao Obrigatorio */
    field tipo-etiq             as inte format "99"                 /* Reservado       */
    field desc-etiqueta         as char format "x(050)"             /* Nao Obrigatorio */
    field observacao            as char format "x(100)"             /* Nao Obrigatorio */
    field serie-docto           as char format "x(5)"               /* Nao Obrigatorio */
    field cod-emitente          as inte format ">>>>>>>>9"          /* Nao Obrigatorio */
    field nat-operacao          as char format "9.99-XXX"           /* Nao Obrigatorio */
    field auxiliar-01           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-02           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-03           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-04           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-05           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-06           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-07           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-08           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-09           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-10           as char format "x(001)"             /* Nao Obrigatorio */
    field data-movimento        as date format "99/99/9999"         /* Nao Obrigatorio */
    field nr-sequencia          as inte format ">>9"                /* Nao Obrigatorio */
    index ch-seq is unique primary i-sequen.

def var l-erro as log.

&if "{&mgcld_version}" < "2.04" &then
    for each bc-trans exclusive-lock 
       where bc-trans.log-1 = yes:
&else
    for each bc-trans exclusive-lock 
       where bc-trans.ind-tipo-trans = 1:
&endif

    for each tt-etiqueta:
        delete tt-etiqueta.
    end.

    for each tt-etiqueta-001:
        delete tt-etiqueta-001.
    end.

    for each tt-etiqueta-002:
        delete tt-etiqueta-002.
    end.

    for each tt-etiqueta-003:
        delete tt-etiqueta-003.
    end.

    create tt-etiqueta.
    run pi-raw(input  "tt-etiqueta",
               input  1,
               input  bc-trans.conteudo-trans,
               output l-erro).

/******** Etiqueta 1 ********/
    if l-erro then do:
        create tt-etiqueta-001.
        run pi-raw(input "tt-etiqueta-001",
                   input 1,
                   input bc-trans.conteudo-trans,
                   output l-erro).

/******** Etiqueta 2 ********/
        if l-erro then do: 
            create tt-etiqueta-002.
            run pi-raw(input "tt-etiqueta-002",
                       input 1,
                       input bc-trans.conteudo-trans,
                       output l-erro).

/******** Etiqueta 3 ********/
            if l-erro then do:
                create tt-etiqueta-003.
                run pi-raw(input "tt-etiqueta-003",
                           input 1,
                           input bc-trans.conteudo-trans,
                           output l-erro).

                buffer-copy tt-etiqueta-003 to tt-etiqueta.
                if  tt-etiqueta.cd-trans = "etiq-fat" then
                    assign tt-etiqueta.peso-liquido    = decimal(tt-etiqueta.auxiliar-02)
                           tt-etiqueta.peso-bruto      = decimal(tt-etiqueta.auxiliar-03)
                           tt-etiqueta.nr-embalagem    = decimal(tt-etiqueta.auxiliar-04)
                           tt-etiqueta.it-codigo-ext-1 = tt-etiqueta.auxiliar-05
                           tt-etiqueta.auxiliar-02     = ""
                           tt-etiqueta.auxiliar-03     = ""
                           tt-etiqueta.auxiliar-04     = ""
                           tt-etiqueta.auxiliar-05     = "".

                run pi-raw(input "tt-etiqueta",
                           input 2,
                           input bc-trans.conteudo-trans,
                           output l-erro).
            end.
            else do:
                buffer-copy tt-etiqueta-002 except tt-etiqueta-002.nr-trans tt-etiqueta-002.nr-trans-ant to tt-etiqueta
                            assign tt-etiqueta.nr-trans     = tt-etiqueta-002.nr-trans
                                   tt-etiqueta.nr-trans-ant = tt-etiqueta-002.nr-trans-ant.
                if  tt-etiqueta.cd-trans = "etiq-fat" then
                    assign tt-etiqueta.peso-liquido    = decimal(tt-etiqueta.auxiliar-02)
                           tt-etiqueta.peso-bruto      = decimal(tt-etiqueta.auxiliar-03)
                           tt-etiqueta.nr-embalagem    = decimal(tt-etiqueta.auxiliar-04)
                           tt-etiqueta.it-codigo-ext-1 = tt-etiqueta.auxiliar-05
                           tt-etiqueta.auxiliar-02     = ""
                           tt-etiqueta.auxiliar-03     = ""
                           tt-etiqueta.auxiliar-04     = ""
                           tt-etiqueta.auxiliar-05     = "".

                run pi-raw(input "tt-etiqueta",
                           input 2,
                           input bc-trans.conteudo-trans,
                           output l-erro).
            end.
        end.
        else do:
            buffer-copy tt-etiqueta-001 except tt-etiqueta-001.nr-trans tt-etiqueta-001.nr-trans-ant to tt-etiqueta
                        assign tt-etiqueta.nr-trans     = tt-etiqueta-001.nr-trans
                               tt-etiqueta.nr-trans-ant = tt-etiqueta-001.nr-trans-ant.
            if  tt-etiqueta.cd-trans = "etiq-fat" then
                assign tt-etiqueta.peso-liquido    = decimal(tt-etiqueta.auxiliar-02)
                       tt-etiqueta.peso-bruto      = decimal(tt-etiqueta.auxiliar-03)
                       tt-etiqueta.nr-embalagem    = decimal(tt-etiqueta.auxiliar-04)
                       tt-etiqueta.it-codigo-ext-1 = tt-etiqueta.auxiliar-05
                       tt-etiqueta.auxiliar-02     = ""
                       tt-etiqueta.auxiliar-03     = ""
                       tt-etiqueta.auxiliar-04     = ""
                       tt-etiqueta.auxiliar-05     = "".

            run pi-raw(input "tt-etiqueta",
                       input 2,
                       input bc-trans.conteudo-trans,
                       output l-erro).
        end.
    end.
end.


/********************************************************************************/

procedure pi-raw:

    def input  param c-tt as char.
    def input  param i-tipo as int. /* 1 - Transferˆncia do bc-trans.conteudo-trans para a temp-table
                                       2 - Transferˆncia da temp-table para o bc-trans.conteudo-trans */
    def input  param r-raw as raw.
    def output param l-erro as logical.

    def var raw-temp   as raw.
    def var c-mensagem as char.
    def var i-erro     as int.
    def var i-cont     as int.

    {include/i_dbtype.i}

    if i-tipo = 1 then do:

        &IF "{&mgcld_dbtype}" = "PROGRESS" &THEN
            if c-tt = "tt-etiqueta" then
                raw-transfer bc-trans.conteudo-trans to tt-etiqueta no-error.
            else if c-tt = "tt-etiqueta-001" then
                raw-transfer bc-trans.conteudo-trans to tt-etiqueta-001 no-error.
            else if c-tt = "tt-etiqueta-002" then
                raw-transfer bc-trans.conteudo-trans to tt-etiqueta-002 no-error.
            else if c-tt = "tt-etiqueta-003" then
                raw-transfer bc-trans.conteudo-trans to tt-etiqueta-003 no-error.

        &ELSE
            run btb/btb928za.p(input  bc-trans.conteudo-trans,
                               output raw-temp).

            if ((    error-status:error
                  or error-status:get-number(1) <> 0)
                 and error-status:get-number(1) <> 138)
            or return-value = "NOK" then do:

                assign i-erro     = error-status:get-number(1)
                       c-mensagem = error-status:get-message(1).

                if return-value = "NOK" then do:
                    {utp/ut-liter.i "PermissÆo do Diret¢rio Tempor rio" * L}.
                    assign c-mensagem = trim(return-value)
                           i-erro     = os-error.
                end.

                {utp/ut-liter.i "de ConversÆo do Campo RAW" * L}
                run utp/ut-msgs.p (input "show",
                                   input 15837,
                                   input trim(return-value) + " - (" + c-mensagem + " : " + string(i-erro) + ")").

                return "error".

            end.

            else do:

                if c-tt = "tt-etiqueta" then
                    raw-transfer raw-temp to tt-etiqueta no-error.
                else if c-tt = "tt-etiqueta-001" then
                    raw-transfer raw-temp to tt-etiqueta-001 no-error.
                else if c-tt = "tt-etiqueta-002" then
                    raw-transfer raw-temp to tt-etiqueta-002 no-error.
                else if c-tt = "tt-etiqueta-003" then
                    raw-transfer raw-temp to tt-etiqueta-003 no-error.

            end.

        &ENDIF

        if  error-status:error
        and error-status:num-messages > 0 then do:

            do i-cont = 1 to error-status:num-messages:

                if error-status:get-number(i-cont) = 4955 then
                    assign l-erro = yes.
                else
                    assign l-erro = no.
            end.
        end.
        else
            assign l-erro = no.


    end.

    if i-tipo = 2 then do:

        &IF "{&mgcld_dbtype}" = "PROGRESS" &THEN
            if avail tt-etiqueta then
                raw-transfer tt-etiqueta to bc-trans.conteudo-trans.

        &ELSE
            if avail tt-etiqueta then do:
                raw-transfer tt-etiqueta to raw-temp.
                assign bc-trans.conteudo-trans = string(raw-temp).
            end.

        &ENDIF

    end.

end procedure.
