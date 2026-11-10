/* 
** Include pra melhor leitura da tabela docum-est quando os documentos
** j· possuirem a tabela embarq-import-docto
*/

FIND FIRST natur-oper
     WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR.
IF NOT AVAIL natur-oper
OR (AVAIL natur-oper AND natur-oper.nota-rateio) THEN 
    NEXT bloco.

/* Busca impostos do internacional */
IF  i-pais-impto-usuario <> 1 THEN DO:

    IF tt-param.moeda = docum-est.mo-codigo AND tt-param.l-considera-cot-docto THEN
        ASSIGN tt-embarque-cabec.mo-taxa = docum-est.cotacao-dia.

    FOR EACH b-item-doc-est-aux2 OF docum-est 
       WHERE b-item-doc-est-aux2.it-codigo   >= tt-param.c-it-codigo-ini
        AND  b-item-doc-est-aux2.it-codigo   <= tt-param.c-it-codigo-fim NO-LOCK:       

        FOR EACH impto-item-docto NO-LOCK
           WHERE impto-item-docto.serie-docto  = b-item-doc-est-aux2.serie-docto 
             AND impto-item-docto.nro-docto    = b-item-doc-est-aux2.nro-docto    
             AND impto-item-docto.cod-emitente = b-item-doc-est-aux2.cod-emitente 
             AND impto-item-docto.nat-operacao = b-item-doc-est-aux2.nat-operacao 
             AND impto-item-docto.num-seq      = b-item-doc-est-aux2.sequencia:

            FIND FIRST tipo-tax NO-LOCK WHERE tipo-tax.cod-tax = impto-item-docto.cdn-imposto NO-ERROR.
            IF NOT AVAIL tipo-tax THEN NEXT.

            FIND FIRST tt-impto-internac EXCLUSIVE-LOCK 
                 WHERE tt-impto-internac.embarque    = embarque-imp.embarque           
                   AND tt-impto-internac.cod-estabel = embarque-imp.cod-estabel        
                   AND tt-impto-internac.cdn-imposto = impto-item-docto.cdn-imposto NO-ERROR.

            IF NOT AVAIL tt-impto-internac THEN DO:            
                CREATE tt-impto-internac.
                ASSIGN tt-impto-internac.embarque    = embarque-imp.embarque
                       tt-impto-internac.cod-estabel = embarque-imp.cod-estabel
                       tt-impto-internac.num-seq     = impto-item-docto.num-seq
                       tt-impto-internac.cdn-imposto = impto-item-docto.cdn-imposto
                       tt-impto-internac.descricao   = tipo-tax.descricao.
            END.
                    
            ASSIGN tt-impto-internac.val-impto-moeda-relat-mo = tt-impto-internac.val-impto-moeda-relat-mo + impto-item-docto.val-impto-merc-ext.
                   tt-impto-internac.mo-impto-moeda-relat     = docum-est.mo-codigo.
          
            IF tt-param.l-considera-cot-docto THEN DO:
                IF tt-param.moeda = docum-est.mo-codigo THEN
                    ASSIGN tt-impto-internac.val-impto-moeda-relat = tt-impto-internac.val-impto-moeda-relat + impto-item-docto.val-impto-merc-ext.
                ELSE DO:
                    ASSIGN tt-impto-internac.val-impto-moeda-relat = tt-impto-internac.val-impto-moeda-relat + impto-item-docto.val-impto.
                             
                    IF tt-param.moeda <> 0 THEN
                        RUN converte-moeda-data (INPUT-OUTPUT tt-impto-internac.val-impto-moeda-relat,
                                                 INPUT 0, /* moeda origem */
                                                 INPUT embarque-imp.data-1). 
          
                END.
            END.
            ELSE DO:

                IF tt-param.moeda = 0 THEN
                    ASSIGN tt-impto-internac.val-impto-moeda-relat = tt-impto-internac.val-impto-moeda-relat + impto-item-docto.val-impto.
                ELSE DO:

                    ASSIGN tt-impto-internac.val-impto-moeda-relat = tt-impto-internac.val-impto-moeda-relat + impto-item-docto.val-impto-merc-ext.
              
                    IF  tt-param.moeda <> docum-est.mo-codigo THEN                                                     
                         RUN converte-moeda (INPUT-OUTPUT tt-impto-internac.val-impto-moeda-relat,
                                             INPUT docum-est.mo-codigo). /* moeda origem */
                END.
            END.

        END.


    END.
END.

/*Tratamento realizado para a situaá∆o em que o mesmo embarque possuir nota simples remessa m∆e e nota simples remessa filha. 
Neste caso a nota m∆e ser† gravada na tt-embarque-nota-mae para ser apresentada em tela.*/
IF docum-est.idi-nf-simples-remes = 1 THEN DO:
    CREATE tt-embarque-nota-mae.
    ASSIGN tt-embarque-nota-mae.embarque     = embarque-imp.embarque   
           tt-embarque-nota-mae.cod-estabel  = embarque-imp.cod-estabel
           tt-embarque-nota-mae.nr-nota-fis  = docum-est.nro-docto             
           tt-embarque-nota-mae.dt-emissao   = docum-est.dt-emissao            
           tt-embarque-nota-mae.nr-di        = embarque-imp.declaracao-import  
           tt-embarque-nota-mae.dt-di        = embarque-imp.data-di.          
    ASSIGN l-nota-mae = YES. 

    IF i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
        for each rat-docum no-lock
           where rat-docum.nf-serie    = docum-est.serie-docto
             and rat-docum.nf-nro      = docum-est.nro-docto
             and rat-docum.nf-emitente = docum-est.cod-emitente
             and rat-docum.nf-nat-oper = docum-est.nat-operacao
            use-index nf-docto:

            for FIRST b-docum-est fields( nro-docto  serie-docto  dt-emissao
                                         cod-emitente  nat-operacao cod-estabel tot-valor-me tot-valor mo-codigo idi-nf-simples-remes)
                where b-docum-est.serie-docto  = rat-docum.serie-docto
                  and b-docum-est.nro-docto    = rat-docum.nro-docto
                  and b-docum-est.cod-emitente = rat-docum.cod-emitente
                  and b-docum-est.nat-operacao = rat-docum.nat-operacao NO-LOCK
                use-index documento:

                IF NOT CAN-FIND(FIRST tt-embarque-nota-mae
                                WHERE tt-embarque-nota-mae.embarque     = embarque-imp.embarque   
                                  AND tt-embarque-nota-mae.cod-estabel  = embarque-imp.cod-estabel
                                  AND tt-embarque-nota-mae.nr-nota-fis  = b-docum-est.nro-docto
                                  AND tt-embarque-nota-mae.dt-emissao   = b-docum-est.dt-emissao) THEN DO:
                    CREATE tt-embarque-nota-mae.
                    ASSIGN tt-embarque-nota-mae.embarque     = embarque-imp.embarque   
                           tt-embarque-nota-mae.cod-estabel  = embarque-imp.cod-estabel
                           tt-embarque-nota-mae.nr-nota-fis  = b-docum-est.nro-docto             
                           tt-embarque-nota-mae.dt-emissao   = b-docum-est.dt-emissao.

                    IF tt-param.excel THEN DO:
                        for first emitente fields( cod-emitente  nome-abrev)
                            where emitente.cod-emitente = b-docum-est.cod-emitente no-lock:
                        end.
                    
                        CREATE tt-documentos.                  
                        {utp/ut-liter.i "Nota m∆e complementar" *}
                        ASSIGN tt-documentos.cod-estabel       = tt-embarque-cabec.cod-estabel 
                               tt-documentos.embarque          = tt-embarque-cabec.embarque
                               tt-documentos.cod-exportador    = tt-embarque-cabec.cod-emitente     
                               tt-documentos.desc-exportador   = tt-embarque-cabec.desc-emit   
                               tt-documentos.nro-docto         = b-docum-est.nro-docto      
                               tt-documentos.serie-docto       = b-docum-est.serie-docto
                               tt-documentos.nat-operacao      = b-docum-est.nat-operacao      
                               tt-documentos.cod-emitente      = b-docum-est.cod-emitente
                               tt-documentos.desc-emit         = if avail emitente then emitente.nome-abrev else "":U
                               tt-documentos.dt-emissao        = b-docum-est.dt-emissao
                               tt-documentos.des-tipo-nota-imp = TRIM(RETURN-VALUE).
                    END.
                END.
            END.
        END.
    END.

END.
ELSE
    ASSIGN l-nota-mae = NO.

/****** NOTA PRINCIPAL ******/
if  docum-est.idi-nf-simples-remes = 1 and tt-param.l-desemb-parc = no then
    assign tt-param.l-desemb-parc = yes
           l-desemb-parc-modif    = yes.

IF NOT l-nota-mae THEN
    RUN gera-valores (INPUT docum-est.serie-docto,
                      INPUT docum-est.nro-docto,     
                      INPUT docum-est.cod-emitente,
                      INPUT docum-est.nat-operacao,
                      INPUT embarque-imp.embarque,
                      INPUT docum-est.cod-estabel,
                      INPUT 1). /*Nota Principal*/

/****************************/

/*Folder NF's excel*/
IF tt-param.excel THEN DO:
    for first emitente fields( cod-emitente  nome-abrev)
        where emitente.cod-emitente = docum-est.cod-emitente no-lock:
    end.

    CREATE tt-documentos. 
    ASSIGN tt-documentos.cod-estabel          = tt-embarque-cabec.cod-estabel 
           tt-documentos.embarque             = tt-embarque-cabec.embarque
           tt-documentos.cod-exportador       = tt-embarque-cabec.cod-emitente     
           tt-documentos.desc-exportador      = tt-embarque-cabec.desc-emit   
           tt-documentos.nro-docto            = docum-est.nro-docto      
           tt-documentos.serie-docto          = docum-est.serie-docto
           tt-documentos.nat-operacao         = docum-est.nat-operacao      
           tt-documentos.cod-emitente         = docum-est.cod-emitente
           tt-documentos.desc-emit            = if avail emitente then emitente.nome-abrev else "":U
           tt-documentos.dt-emissao           = docum-est.dt-emissao.

    IF docum-est.idi-nf-simples-remes = 1 THEN DO: /* "nota m∆e" */
        {utp/ut-liter.i "Nota_M∆e"}
    END.
    ELSE
        IF docum-est.idi-nf-simples-remes = 2 THEN DO: /* nota filha */
            {utp/ut-liter.i "Nota_Filha"}
        END.
        ELSE 
            IF CAN-FIND(FIRST natur-oper
                        WHERE natur-oper.nat-operacao = docum-est.nat-operacao
                          AND natur-oper.nota-rateio) THEN DO:
                {utp/ut-liter.i "Nota_Complementar"}
            END.
            ELSE DO: 
                IF CAN-FIND(FIRST item-doc-est 
                             WHERE item-doc-est.serie-docto     = docum-est.serie-docto
                               AND item-doc-est.nro-docto       = docum-est.nro-docto    
                               AND item-doc-est.cod-emitente    = docum-est.cod-emitente 
                               AND item-doc-est.nat-operacao    = docum-est.nat-operacao 
                               AND item-doc-est.log-nota-ajust-import) THEN DO:
                    {utp/ut-liter.i "Nota_Ajuste"}
                END.
                ELSE DO:
                    {utp/ut-liter.i "Nota_Normal"}
                END.
             END.

    ASSIGN tt-documentos.des-tipo-nota-imp = TRIM(RETURN-VALUE).

END.
/**/

/****** EMBARQUES RELACIONADOS ******/
IF  tt-param.l-desemb-parc AND docum-est.idi-nf-simples-remes <> 2 THEN 
    RUN geraEmbarquesRelacionados (embarque-imp.embarque).
/****** ********* ******/

/*os pr¢ximos embarques que poder∆o n∆o ser de simples de remessa, ser∆o mostrados corretamente*/
if l-desemb-parc-modif then
    assign tt-param.l-desemb-parc = no.

/****** NOTAS COMPLEMENTARES ******/

IF  tt-param.l-nf-compl THEN DO:
    for each b-docum-est fields( nro-docto  serie-docto  cod-emitente  nat-operacao char-1)
        WHERE b-docum-est.serie-docto  = docum-est.serie-docto
          AND b-docum-est.nro-docto    = docum-est.nro-docto
          AND b-docum-est.cod-emitente = docum-est.cod-emitente
          AND b-docum-est.nat-operacao = docum-est.nat-operacao NO-LOCK:

      for first b-item-doc-est
          where b-item-doc-est.serie-docto     = b-docum-est.serie-docto
            and b-item-doc-est.nro-docto       = b-docum-est.nro-docto    
            and b-item-doc-est.cod-emitente    = b-docum-est.cod-emitente 
            and b-item-doc-est.nat-operacao    = b-docum-est.nat-operacao 
            and b-item-doc-est.baixa-ce = yes no-lock:         
            run busca-nf-complementar (input b-item-doc-est.serie-docto,
                                       input b-item-doc-est.nro-docto,
                                       input b-item-doc-est.cod-emitente,
                                       input b-item-doc-est.nat-operacao,
                                       input embarque-imp.embarque,
                                       input embarque-imp.cod-estabel).
        end.
    end.
    
    for each b-embarque-imp fields(embarque-ori cod-estabel embarque declaracao-import data-di)
       where b-embarque-imp.embarque-ori = embarque-imp.embarque no-lock:
        
        find first b-embarq-import-docto
             where b-embarq-import-docto.cod-estab  = b-embarque-imp.cod-estabel
               and b-embarq-import-docto.cod-embarq = b-embarque-imp.embarque no-lock no-error.

        if avail embarq-import-docto then
            for first b-docum-est fields(nro-docto serie-docto cod-emitente nat-operacao)
                where b-docum-est.serie-docto  = b-embarq-import-docto.cod-ser-docto   
                  and b-docum-est.nro-docto    = b-embarq-import-docto.cod-docto       
                  and b-docum-est.cod-emitente = b-embarq-import-docto.cdn-emitente    
                  and b-docum-est.nat-operacao = b-embarq-import-docto.cod-natur-operac no-lock:

                run busca-nf-complementar (input b-docum-est.serie-docto,
                                           input b-docum-est.nro-docto,
                                           input b-docum-est.cod-emitente,
                                           input b-docum-est.nat-operacao,
                                           input b-embarque-imp.embarque,
                                           input b-embarque-imp.cod-estabel).
            end.
        else
            for first b-docum-est fields(nro-docto serie-docto cod-emitente nat-operacao)
                where trim(substring(b-docum-est.char-1,1,20)) = b-embarque-imp.embarque no-lock:
                run busca-nf-complementar (input b-docum-est.serie-docto,
                                           input b-docum-est.nro-docto,
                                           input b-docum-est.cod-emitente,
                                           input b-docum-est.nat-operacao,
                                           input b-embarque-imp.embarque,
                                           input b-embarque-imp.cod-estabel).
            end.
    end.
END. /*fim tt-param.l-nf-com*/
/****** ********* ******/
