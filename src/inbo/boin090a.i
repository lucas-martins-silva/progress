/**********************************************************************************
**
**  BOIN090A.I - Cria tt-docum-est-rateio, apartir do embarque e estabelecimento, 
**              e se o docum-est.ce-atual = yes, relaciona tambem as notas de 
**              rateio. 
**
**********************************************************************************/

    FIND FIRST natur-oper
        WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR.
    IF NOT AVAIL natur-oper
    OR ( AVAIL natur-oper AND natur-oper.nota-rateio) THEN NEXT.

    IF TRIM(SUBSTRING(docum-est.char-1,1,20)) = "" THEN NEXT.
    
    &if defined(bf-mat-comex) &then                   
       IF substring(docum-est.char-1,2,12)  <> p-embarque THEN NEXT.
    &else
        {cdp/cd4300.i4   "yes" docum-est.char-1}
        {rep/re1001a.i51 "yes"}
        IF c-embarque <> p-embarque THEN NEXT.
    &endif
    
    IF i-documento = 1 THEN
       ASSIGN l-emitente = YES.
    ELSE
       IF i-documento = 2 THEN
          ASSIGN l-estabel  = YES
                 l-emitente = NO.
       ELSE /*entra aqui caso a variavel i-documento nao tenha sido atualizada i-documento = 0*/
          ASSIGN l-emitente = NO
                 l-estabel  = NO.
    
    if docum-est.ce-atual = yes then do:

       for each rat-docum where
                rat-docum.nf-serie    = docum-est.serie-docto and
                rat-docum.nf-nro      = docum-est.nro-docto   and
                rat-docum.nf-emitente = docum-est.cod-emitente and
                rat-docum.nf-nat-oper = docum-est.nat-operacao no-lock
           USE-INDEX nf-docto:
    
            FOR FIRST b-docum-est FIELDS(cod-estabel dt-emissao ce-atual char-1 idi-nf-simples-remes serie-docto nro-docto cod-emitente nat-operacao usuario)where
                      b-docum-est.serie-docto  = rat-docum.serie-docto  and
                      b-docum-est.nro-docto    = rat-docum.nro-docto    and
                      b-docum-est.cod-emitente = rat-docum.cod-emitente and
                      b-docum-est.nat-operacao = rat-docum.nat-operacao NO-LOCK
                USE-INDEX documento:
            END.
            FOR FIRST emitente FIELD(nome-abrev) WHERE
                      emitente.cod-emitente = rat-docum.cod-emitente NO-LOCK
                USE-INDEX codigo:
            END.
            ASSIGN c-nome-abrev = IF AVAIL emitente THEN emitente.nome-abrev ELSE "".
    
            IF NOT CAN-FIND(FIRST tt-docum-est-rateio 
                            WHERE tt-docum-est-rateio.serie-docto = rat-docum.serie-docto 
                              AND tt-docum-est-rateio.nro-docto   = rat-docum.nro-docto   
                              AND tt-docum-est-rateio.cod-emitente = rat-docum.cod-emitente 
                              AND tt-docum-est-rateio.nat-operacao = rat-docum.nat-operacao NO-LOCK) THEN DO:
    
                create tt-docum-est-rateio.
                assign tt-docum-est-rateio.cod-emitente = rat-docum.cod-emitente
                       tt-docum-est-rateio.nome-abrev   = c-nome-abrev
                       tt-docum-est-rateio.serie-docto  = rat-docum.serie-docto
                       tt-docum-est-rateio.nro-docto    = rat-docum.nro-docto
                       tt-docum-est-rateio.nat-operacao = rat-docum.nat-operacao
                       tt-docum-est-rateio.cod-estabel  = b-docum-est.cod-estabel
                       tt-docum-est-rateio.dt-emissao   = b-docum-est.dt-emissao
                       tt-docum-est-rateio.ce-atual     = b-docum-est.ce-atual
                       tt-docum-est-rateio.r-rowid      = rowid(b-docum-est)
                       tt-docum-est-rateio.char-1       = b-docum-est.char-1
                       tt-docum-est-rateio.usuario      = b-docum-est.usuario
                       tt-docum-est-rateio.idi-nf-simples-remes = b-docum-est.idi-nf-simples-remes
                       c-nome-abrev = "".
            END.
       end.
    end.
    
    FOR FIRST emitente FIELD(nome-abrev) WHERE
              emitente.cod-emitente = docum-est.cod-emitente NO-LOCK
        USE-INDEX codigo:
    END.
    ASSIGN c-nome-abrev = IF AVAIL emitente THEN emitente.nome-abrev ELSE "".
    
    IF NOT CAN-FIND(FIRST tt-docum-est-rateio 
                    WHERE tt-docum-est-rateio.serie-docto  = docum-est.serie-docto 
                      AND tt-docum-est-rateio.nro-docto    = docum-est.nro-docto   
                      AND tt-docum-est-rateio.cod-emitente = docum-est.cod-emitente 
                      AND tt-docum-est-rateio.nat-operacao = docum-est.nat-operacao NO-LOCK) THEN DO:
        create tt-docum-est-rateio.        
        assign tt-docum-est-rateio.cod-emitente = docum-est.cod-emitente
               tt-docum-est-rateio.nome-abrev   = c-nome-abrev
               tt-docum-est-rateio.serie-docto  = docum-est.serie-docto
               tt-docum-est-rateio.nro-docto    = docum-est.nro-docto
               tt-docum-est-rateio.nat-operacao = docum-est.nat-operacao
               tt-docum-est-rateio.cod-estabel  = docum-est.cod-estabel
               tt-docum-est-rateio.dt-emissao   = docum-est.dt-emissao
               tt-docum-est-rateio.ce-atual     = docum-est.ce-atual
               tt-docum-est-rateio.r-rowid      = rowid(docum-est)
               tt-docum-est-rateio.char-1       = docum-est.char-1
               tt-docum-est-rateio.usuario      = docum-est.usuario
               tt-docum-est-rateio.idi-nf-simples-remes = docum-est.idi-nf-simples-remes
               c-nome-abrev = "".
    END.
