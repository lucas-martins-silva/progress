/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX095C 2.00.00.011 } /*** "010011" 17/08/2026 14:36:02 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx095c MUT}
&ENDIF

/* BOCX095C - C lculo de Despesas */

DEFINE VARIABLE numero-ordem        LIKE cotacao-item.numero-ordem      NO-UNDO.
DEFINE VARIABLE cod-emitente        LIKE emitente.cod-emitente          NO-UNDO.
DEFINE VARIABLE it-codigo           LIKE ITEM.it-codigo                 NO-UNDO.
DEFINE VARIABLE seq-cotac           LIKE cotacao-item.seq-cotac         NO-UNDO.
DEFINE VARIABLE mapa-cotacao        LIKE cotacao-item-cex.mapa-cotacao  NO-UNDO.
DEFINE VARIABLE cod-itiner          LIKE itinerario.cod-itiner          NO-UNDO.
DEFINE VARIABLE cod-incoterm        LIKE inco-cx.cod-incoterm           NO-UNDO.
DEFINE VARIABLE cod-emitente-desp   LIKE emitente.cod-emitente          NO-UNDO.
DEFINE VARIABLE cod-desp            LIKE desp-imp.cod-desp              NO-UNDO.
DEFINE VARIABLE nr-tab              LIKE tb-pr-cex.nr-tab               NO-UNDO.
DEFINE VARIABLE mo-codigo           LIKE moeda.mo-codigo                NO-UNDO.
DEFINE VARIABLE cod-agrup           LIKE cot-ordem.cod-agrup            NO-UNDO.
DEFINE VARIABLE i-calculo           AS   INTEGER    FORMAT "->9"        NO-UNDO.
DEFINE VARIABLE da-data-cotacao     AS   DATE                           NO-UNDO.
DEFINE VARIABLE cod-estabel         LIKE estabelec.cod-estabel          NO-UNDO.
DEFINE VARIABLE nr-proc-exp         LIKE processo-exp.nr-proc-exp       NO-UNDO.
DEFINE VARIABLE i-tipo-comex        AS INTEGER                          NO-UNDO.
DEFINE VARIABLE r-cot-it-cex        AS ROWID                            NO-UNDO.
DEFINE VARIABLE cod-cond-pag        LIKE desp-tb-pr-cex.cod-cond-pag    NO-UNDO.

DEFINE VARIABLE h-bocx095           AS HANDLE                           NO-UNDO.
DEFINE VARIABLE h-im0091            AS HANDLE                           NO-UNDO.
DEFINE VARIABLE d-converte          AS DECIMAL                          NO-UNDO.
DEFINE VARIABLE l-tem-val-tabela    AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE l-nt2024002         AS LOGICAL                          NO-UNDO.

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002" AND funcao.ativo).

{method/dbotterr.i}             /* RowErrors */
{cdp/cdapi020.i}
{include/boini.i}               /* tt-bo-erro */
{imp/im0091.i}                  /* tt-desp-rateio */
{cxbo/bocx095a.i}
{include/i-epc200.i "bocx095c"}

/**/

PROCEDURE setCotacaoDespesaImportacao:

    DEFINE INPUT PARAMETER p-numero-ordem        LIKE cotacao-item.numero-ordem      NO-UNDO.           
    DEFINE INPUT PARAMETER p-cod-emitente        LIKE emitente.cod-emitente          NO-UNDO.           
    DEFINE INPUT PARAMETER p-it-codigo           LIKE ITEM.it-codigo                 NO-UNDO.           
    DEFINE INPUT PARAMETER p-seq-cotac           LIKE cotacao-item.seq-cotac         NO-UNDO.           
    DEFINE INPUT PARAMETER p-mapa-cotacao        LIKE cotacao-item-cex.mapa-cotacao  NO-UNDO.           
    DEFINE INPUT PARAMETER p-cod-itiner          LIKE itinerario.cod-itiner          NO-UNDO.           
    DEFINE INPUT PARAMETER p-cod-incoterm        LIKE inco-cx.cod-incoterm           NO-UNDO.           
    DEFINE INPUT PARAMETER p-cod-emitente-desp   LIKE emitente.cod-emitente          NO-UNDO.           
    DEFINE INPUT PARAMETER p-cod-desp            LIKE desp-imp.cod-desp              NO-UNDO.           
    DEFINE INPUT PARAMETER p-nr-tab              LIKE tb-pr-cex.nr-tab               NO-UNDO.           
    DEFINE INPUT PARAMETER p-mo-codigo           LIKE moeda.mo-codigo                NO-UNDO.           
    DEFINE INPUT PARAMETER p-da-data-cotacao     AS   DATE                           NO-UNDO.           
    DEFINE INPUT PARAMETER p-tipo-comex          AS   INTEGER                        NO-UNDO. /* 1 - importa‡Æo, 2 - exporta‡Æo */
    DEFINE INPUT PARAMETER p-r-cot-it-cex        AS   ROWID                          NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-cond-pag        like desp-tb-pr-cex.cod-cond-pag    NO-UNDO.

    ASSIGN numero-ordem      = p-numero-ordem      
           cod-emitente      = p-cod-emitente      
           it-codigo         = p-it-codigo         
           seq-cotac         = p-seq-cotac
           mapa-cotacao      = p-mapa-cotacao      
           cod-itiner        = p-cod-itiner        
           cod-incoterm      = p-cod-incoterm      
           cod-emitente-desp = p-cod-emitente-desp 
           cod-desp          = p-cod-desp          
           nr-tab            = p-nr-tab            
           mo-codigo         = p-mo-codigo         
           i-calculo         = 1
           da-data-cotacao   = p-da-data-cotacao
           i-tipo-comex      = p-tipo-comex
           r-cot-it-cex      = p-r-cot-it-cex
           cod-cond-pag      = p-cod-cond-pag.

END PROCEDURE.

/**/

PROCEDURE setCotacaoGrupoDespesaImportacao:
    
    DEFINE INPUT PARAMETER p-cod-agrup           LIKE cot-ordem.cod-agrup            NO-UNDO.           
    DEFINE INPUT PARAMETER p-mapa-cotacao        LIKE cotacao-item-cex.mapa-cotacao  NO-UNDO.           
    DEFINE INPUT PARAMETER p-cod-itiner          LIKE itinerario.cod-itiner          NO-UNDO.           
    DEFINE INPUT PARAMETER p-cod-incoterm        LIKE inco-cx.cod-incoterm           NO-UNDO.           
    DEFINE INPUT PARAMETER p-cod-emitente-desp   LIKE emitente.cod-emitente          NO-UNDO.           
    DEFINE INPUT PARAMETER p-cod-desp            LIKE desp-imp.cod-desp              NO-UNDO.           
    DEFINE INPUT PARAMETER p-nr-tab              LIKE tb-pr-cex.nr-tab               NO-UNDO.           
    DEFINE INPUT PARAMETER p-mo-codigo           LIKE moeda.mo-codigo                NO-UNDO.           
    DEFINE INPUT PARAMETER p-da-data-cotacao     AS   DATE                           NO-UNDO.           
    DEFINE INPUT PARAMETER p-tipo-comex          AS   INTEGER                        NO-UNDO. /* 1 - importa‡Æo, 2 - exporta‡Æo */
    DEFINE INPUT PARAMETER p-r-cot-it-cex        AS   ROWID                          NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-cond-pag        like desp-tb-pr-cex.cod-cond-pag    NO-UNDO.

    ASSIGN cod-agrup         = p-cod-agrup
           mapa-cotacao      = p-mapa-cotacao      
           cod-itiner        = p-cod-itiner        
           cod-incoterm      = p-cod-incoterm      
           cod-emitente-desp = p-cod-emitente-desp 
           cod-desp          = p-cod-desp          
           nr-tab            = p-nr-tab            
           mo-codigo         = p-mo-codigo         
           i-calculo         = 2
           da-data-cotacao   = p-da-data-cotacao
           i-tipo-comex      = p-tipo-comex
           r-cot-it-cex      = p-r-cot-it-cex
           cod-cond-pag      = p-cod-cond-pag.

END PROCEDURE.

/**/

PROCEDURE setDespesaExportacao:

    DEFINE INPUT PARAMETER p-cod-estabel         LIKE estabelec.cod-estabel          NO-UNDO.           
    DEFINE INPUT PARAMETER p-nr-proc-exp         LIKE processo-exp.nr-proc-exp       NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-itiner          LIKE itinerario.cod-itiner          NO-UNDO.           
    DEFINE INPUT PARAMETER p-cod-incoterm        LIKE inco-cx.cod-incoterm           NO-UNDO.           
    DEFINE INPUT PARAMETER p-cod-emitente-desp   LIKE emitente.cod-emitente          NO-UNDO.           
    DEFINE INPUT PARAMETER p-cod-desp            LIKE desp-imp.cod-desp              NO-UNDO.           
    DEFINE INPUT PARAMETER p-nr-tab              LIKE tb-pr-cex.nr-tab               NO-UNDO.           
    DEFINE INPUT PARAMETER p-mo-codigo           LIKE moeda.mo-codigo                NO-UNDO.           
    DEFINE INPUT PARAMETER p-da-data-cotacao     AS   DATE                           NO-UNDO.    
    DEFINE INPUT PARAMETER p-tipo-comex          AS   INTEGER                        NO-UNDO. /* 1 - importa‡Æo, 2 - exporta‡Æo */
    DEFINE INPUT PARAMETER p-cod-cond-pag        like desp-tb-pr-cex.cod-cond-pag    NO-UNDO.

    ASSIGN cod-estabel       = p-cod-estabel
           nr-proc-exp       = p-nr-proc-exp
           cod-itiner        = p-cod-itiner        
           cod-incoterm      = p-cod-incoterm      
           cod-emitente-desp = p-cod-emitente-desp 
           cod-desp          = p-cod-desp          
           nr-tab            = p-nr-tab            
           mo-codigo         = p-mo-codigo         
           i-calculo         = 3
           da-data-cotacao   = p-da-data-cotacao
           i-tipo-comex      = p-tipo-comex
           cod-cond-pag    = p-cod-cond-pag.

END PROCEDURE.

/**/

PROCEDURE calculaDespesa:

    DEFINE OUTPUT PARAMETER d-resultado AS DECIMAL  FORMAT ">>>,>>>,>>>,>>9.99999".
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.

    CASE i-calculo:

        WHEN 1 THEN 
            RUN calculaDespesaCotacaoImportacao (OUTPUT d-resultado).
        WHEN 2 THEN
            RUN calculaDespesaGrupoCotacaoImportacao (OUTPUT d-resultado).
        WHEN 3 THEN
            RUN calculaDespesaExportacao (OUTPUT d-resultado).

    END CASE.

    IF d-resultado = ? THEN
        ASSIGN d-resultado = 0.

    find desp-imp where desp-imp.cod-desp = cod-desp no-lock no-error.
    if avail desp-imp then
        ASSIGN d-resultado = d-resultado * desp-imp.fat-ponder.

END PROCEDURE.

/**/

PROCEDURE calculaDespesaCotacaoImportacao:

    DEFINE OUTPUT PARAMETER d-resultado AS DECIMAL  FORMAT ">>>,>>>,>>>,>>9.99999".

    DEFINE VARIABLE d-quantidade-acum   AS DECIMAL  FORMAT  ">>>,>>>,>>>,>>9.99999" NO-UNDO.

    RUN calculaDespesaAux (OUTPUT d-resultado).

    find ordem-compra where ordem-compra.numero-ordem = numero-ordem no-lock no-error.

    if avail ordem-compra then do:
        find desp-imp where desp-imp.cod-desp = cod-desp no-lock no-error.
        if avail desp-imp then do:
            if desp-imp.tipo <> 1 then do:
                for each prazo-compra
                    where prazo-compra.numero-ordem  = ordem-compra.numero-ordem
                    and   prazo-compra.situacao     <> 4 no-lock:
    
                    assign d-quantidade-acum = d-quantidade-acum + prazo-compra.quantidade.
                end.
            end.
            else
                assign d-quantidade-acum = 1.
        end.
        ELSE
            assign d-quantidade-acum = 1.
    
        assign d-resultado = d-resultado * d-quantidade-acum.
    END.

    find first desp-tb-pr-cex 
         where desp-tb-pr-cex.cod-emitente = cod-emitente-desp
           and desp-tb-pr-cex.cod-itiner   = cod-itiner
           and desp-tb-pr-cex.cod-incoterm = cod-incoterm
           and desp-tb-pr-cex.nr-tab       = nr-tab
           and desp-tb-pr-cex.cod-desp     = cod-desp 
           and desp-tb-pr-cex.cod-cond-pag = cod-cond-pag 
           and desp-tb-pr-cex.situacao     = 1 no-lock no-error.

    if not avail desp-tb-pr-cex then do:
        find first desp-tb-pr-cex 
            where desp-tb-pr-cex.cod-emitente   = cod-emitente-desp
              and desp-tb-pr-cex.cod-itiner     = cod-itiner
              and desp-tb-pr-cex.cod-incoterm   = ""
              and desp-tb-pr-cex.nr-tab         = nr-tab 
              and desp-tb-pr-cex.cod-desp       = cod-desp
              and desp-tb-pr-cex.cod-cond-pag   = cod-cond-pag 
              and desp-tb-pr-cex.situacao       = 1 no-lock no-error.
        if not avail desp-tb-pr-cex then do:
            find first desp-tb-pr-cex 
                where desp-tb-pr-cex.cod-emitente   = cod-emitente-desp
                  and desp-tb-pr-cex.cod-itiner     = 0
                  and desp-tb-pr-cex.cod-incoterm   = cod-incoterm
                  and desp-tb-pr-cex.nr-tab         = nr-tab 
                  and desp-tb-pr-cex.cod-desp       = cod-desp
                  and desp-tb-pr-cex.cod-cond-pag   = cod-cond-pag 
                  and desp-tb-pr-cex.situacao       = 1 no-lock no-error.
            if not avail desp-tb-pr-cex then do:
                find first desp-tb-pr-cex 
                    where desp-tb-pr-cex.cod-emitente   = cod-emitente-desp
                      and desp-tb-pr-cex.cod-itiner     = 0
                      and desp-tb-pr-cex.cod-incoterm   = ""
                      and desp-tb-pr-cex.nr-tab         = nr-tab 
                      and desp-tb-pr-cex.cod-desp       = cod-desp
                      and desp-tb-pr-cex.cod-cond-pag   = cod-cond-pag 
                      and desp-tb-pr-cex.situacao       = 1 no-lock no-error.
            end.
        end.
    end.

    if avail desp-tb-pr-cex then do:

        find tb-pr-cex 
            where tb-pr-cex.cod-emitente    = desp-tb-pr-cex.cod-emitente
            and   tb-pr-cex.cod-itiner      = desp-tb-pr-cex.cod-itiner
            and   tb-pr-cex.cod-incoterm    = desp-tb-pr-cex.cod-incoterm
            and   tb-pr-cex.nr-tab          = desp-tb-pr-cex.nr-tab no-lock no-error.

        if avail tb-pr-cex then do:
    
            if tb-pr-cex.mo-codigo <> mo-codigo then do:
                run cdp/cd0812.p (input  tb-pr-cex.mo-codigo,
                                  input  mo-codigo,
                                  input  d-resultado,
                                  input  da-data-cotacao,
                                  output d-resultado).
            end.
    
            if desp-tb-pr-cex.val-min-desp <> 0 and
               d-resultado < desp-tb-pr-cex.val-min-desp then do:
    
                run cdp/cd0812.p (input  tb-pr-cex.mo-codigo,
                                  input  mo-codigo,
                                  input  desp-tb-pr-cex.val-min-desp,
                                  input  da-data-cotacao,
                                  output d-resultado).
            end.
    
            if desp-tb-pr-cex.val-max-desp <> 0 and
               d-resultado > desp-tb-pr-cex.val-max-desp then do:
    
                run cdp/cd0812.p (input  tb-pr-cex.mo-codigo,
                                  input  mo-codigo,
                                  input  desp-tb-pr-cex.val-max-desp,
                                  input  da-data-cotacao,
                                  output d-resultado).
            end.
        end.
    END.

    ASSIGN d-resultado = d-resultado / d-quantidade-acum.

END PROCEDURE.

/**/

PROCEDURE calculaDespesaGrupoCotacaoImportacao:

    DEFINE OUTPUT PARAMETER d-resultado AS DECIMAL  FORMAT ">>>,>>>,>>>,>>9.99999".

    DEFINE VARIABLE d-resultado-ordem   AS DECIMAL  FORMAT  ">>>,>>>,>>>,>>9.99999" NO-UNDO.
    DEFINE VARIABLE d-quantidade-acum   AS DECIMAL  FORMAT  ">>>,>>>,>>>,>>9.99999" NO-UNDO.

    assign d-resultado = 0.

    FOR EACH cot-ordem NO-LOCK
        WHERE cot-ordem.cod-agrup   = cod-agrup
        AND   cot-ordem.mapa-ordem  = mapa-cotacao:

        find ordem-compra where ordem-compra.numero-ordem = cot-ordem.numero-ordem no-lock no-error.

        if avail ordem-compra then do:

            RUN setCotacaoDespesaImportacao (INPUT cot-ordem.numero-ordem,
                                             INPUT cot-ordem.cod-emitente,
                                             INPUT ordem-compra.it-codigo,
                                             INPUT cot-ordem.seq-cotac,
                                             INPUT cot-ordem.mapa-ordem,
                                             INPUT cod-itiner,
                                             INPUT cod-incoterm,
                                             INPUT cod-emitente-desp,
                                             INPUT cod-desp,
                                             INPUT nr-tab,
                                             INPUT mo-codigo,
                                             INPUT da-data-cotacao,
                                             INPUT i-tipo-comex,
                                             INPUT r-cot-it-cex,
                                             INPUT cod-cond-pag).
    
            ASSIGN i-calculo = 2.
    
            RUN calculaDespesaAux (OUTPUT d-resultado-ordem).

            find desp-imp where desp-imp.cod-desp = cod-desp no-lock no-error.
            if avail desp-imp then do:

                assign d-quantidade-acum = 0.

                if desp-imp.tipo <> 1 then do:

                    for each prazo-compra
                        where prazo-compra.numero-ordem  = ordem-compra.numero-ordem
                        and   prazo-compra.situacao     <> 4 no-lock:

                        assign d-quantidade-acum = d-quantidade-acum + prazo-compra.quantidade.
                    end.
                end.
                ELSE DO:

                    ASSIGN l-tem-val-tabela = NO.

                    FIND first desp-tb-pr-cex 
                        WHERE desp-tb-pr-cex.cod-emitente   = cod-emitente-desp
                        and   desp-tb-pr-cex.cod-itiner     = cod-itiner
                        and   desp-tb-pr-cex.cod-incoterm   = cod-incoterm
                        and   desp-tb-pr-cex.nr-tab         = nr-tab 
                        and   desp-tb-pr-cex.cod-desp       = cod-desp
                        and   desp-tb-pr-cex.cod-cond-pag   = cod-cond-pag 
                        and   desp-tb-pr-cex.situacao       = 1 no-lock no-error.

                    IF AVAIL desp-tb-pr-cex THEN
                        IF desp-tb-pr-cex.val-desp > 0 THEN
                            ASSIGN l-tem-val-tabela = YES.
                            
                    assign d-quantidade-acum = 1.
                END.
            end.
            ELSE
                assign d-quantidade-acum = 1.

            assign d-resultado = d-resultado + (d-resultado-ordem * d-quantidade-acum).

            /* se i tipo da despesa ‚ valor calculado e existe valor informado na tabela de pre‡o,
               calcula o valor apenas uma vez para todo o grupo */
            IF l-tem-val-tabela THEN 
                LEAVE.
        end.
    END.

    find first desp-tb-pr-cex 
        where desp-tb-pr-cex.cod-emitente = cod-emitente-desp
        and   desp-tb-pr-cex.cod-itiner   = cod-itiner
        and   desp-tb-pr-cex.cod-incoterm = cod-incoterm
        and   desp-tb-pr-cex.nr-tab       = nr-tab
        and   desp-tb-pr-cex.cod-desp     = cod-desp
        and   desp-tb-pr-cex.cod-cond-pag = cod-cond-pag 
        and   desp-tb-pr-cex.situacao     = 1 no-lock no-error.

    if avail desp-tb-pr-cex then do:

        find tb-pr-cex 
            where tb-pr-cex.cod-emitente    = desp-tb-pr-cex.cod-emitente
            and   tb-pr-cex.cod-itiner      = desp-tb-pr-cex.cod-itiner
            and   tb-pr-cex.cod-incoterm    = desp-tb-pr-cex.cod-incoterm
            and   tb-pr-cex.nr-tab          = desp-tb-pr-cex.nr-tab no-lock no-error.

        if avail tb-pr-cex then do:
    
            if tb-pr-cex.mo-codigo <> mo-codigo then do:
                run cdp/cd0812.p (input  tb-pr-cex.mo-codigo,
                                  input  mo-codigo,
                                  input  d-resultado,
                                  input  da-data-cotacao,
                                  output d-resultado).
            end.
    
            if desp-tb-pr-cex.val-min-desp <> 0 and
               d-resultado < desp-tb-pr-cex.val-min-desp then do:
    
                run cdp/cd0812.p (input  tb-pr-cex.mo-codigo,
                                  input  mo-codigo,
                                  input  desp-tb-pr-cex.val-min-desp,
                                  input  da-data-cotacao,
                                  output d-resultado).
            end.
    
            if desp-tb-pr-cex.val-max-desp <> 0 and
               d-resultado > desp-tb-pr-cex.val-max-desp then do:
    
                run cdp/cd0812.p (input  tb-pr-cex.mo-codigo,
                                  input  mo-codigo,
                                  input  desp-tb-pr-cex.val-max-desp,
                                  input  da-data-cotacao,
                                  output d-resultado).
            end.
        end.
    END.

END PROCEDURE.

/**/

PROCEDURE calculaDespesaExportacao:

    DEFINE OUTPUT PARAMETER d-resultado AS DECIMAL  FORMAT ">>>,>>>,>>>,>>9.99999".

    RUN calculaDespesaAux (OUTPUT d-resultado).

END PROCEDURE.

/**/

PROCEDURE calculaDespesaAux:

    DEFINE OUTPUT PARAMETER d-resultado AS DECIMAL  FORMAT ">>>,>>>,>>>,>>9.99999".

    DEFINE VARIABLE c-formula           AS CHARACTER    FORMAT "X(2000)"                NO-UNDO.
    DEFINE VARIABLE d-resultado-conv    AS DECIMAL      FORMAT ">>>,>>>,>>>,>>9.99999"  NO-UNDO.

    FIND desp-imp WHERE desp-imp.cod-desp = cod-desp NO-LOCK NO-ERROR.
    IF AVAIL desp-imp THEN DO:

        IF desp-imp.tipo = 2 THEN DO:

            IF NOT AVAIL ordem-compra THEN
                FIND ordem-compra WHERE ordem-compra.numero-ordem = numero-ordem NO-LOCK NO-ERROR.

            IF l-nt2024002 THEN
                FIND FIRST param-imp-trib WHERE param-imp-trib.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
                
            FIND param-imp WHERE param-imp.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
            IF AVAIL param-imp THEN DO:

                IF desp-imp.cod-desp = int(substr(param-imp.char-1,21,20)) OR
                   desp-imp.cod-desp = param-imp.cdn-despes-impto-ipi      OR
                   desp-imp.cod-desp = param-imp.cdn-despes-impto-pis      OR
                   desp-imp.cod-desp = param-imp.cdn-despes-impto-cofins   OR
                   desp-imp.cod-desp = param-imp.cdn-despes-impto-icms     OR 
                   (l-nt2024002 AND AVAIL param-imp-trib AND desp-imp.cod-desp = param-imp-trib.cdn-despes-impto-IBSUF)  OR
                   (l-nt2024002 AND AVAIL param-imp-trib AND desp-imp.cod-desp = param-imp-trib.cdn-despes-impto-IBSMun) OR
                   (l-nt2024002 AND AVAIL param-imp-trib AND desp-imp.cod-desp = param-imp-trib.cdn-despes-impto-CBS)    OR
                   (l-nt2024002 AND AVAIL param-imp-trib AND desp-imp.cod-desp = param-imp-trib.cdn-despes-impto-IS) THEN DO:
                    /* Mesma l¢gica de Calculo dos Impostos dos programas bocx095a e bocx095b */
                    RUN pi-bocx095ab (OUTPUT d-resultado).
                    LEAVE.
                END.
            end.
        END.
        ELSE DO:
            ASSIGN c-formula = desp-imp.dsl-formul-despes.
        END.

        IF nr-tab <> "" THEN DO:

            find first desp-tb-pr-cex 
                 where desp-tb-pr-cex.cod-emitente   = cod-emitente-desp
                   and desp-tb-pr-cex.cod-itiner     = cod-itiner
                   and desp-tb-pr-cex.cod-incoterm   = cod-incoterm
                   and desp-tb-pr-cex.nr-tab         = nr-tab 
                   and desp-tb-pr-cex.cod-desp       = cod-desp
                   and desp-tb-pr-cex.cod-cond-pag   = cod-cond-pag 
                   and desp-tb-pr-cex.situacao       = 1 no-lock no-error.

            if not avail desp-tb-pr-cex then do:
                find first desp-tb-pr-cex 
                    where desp-tb-pr-cex.cod-emitente   = cod-emitente-desp
                      and desp-tb-pr-cex.cod-itiner     = cod-itiner
                      and desp-tb-pr-cex.cod-incoterm   = ""
                      and desp-tb-pr-cex.nr-tab         = nr-tab 
                      and desp-tb-pr-cex.cod-desp       = cod-desp
                      and desp-tb-pr-cex.cod-cond-pag   = cod-cond-pag 
                      and desp-tb-pr-cex.situacao       = 1 no-lock no-error.
                if not avail desp-tb-pr-cex then do:
                    find first desp-tb-pr-cex 
                        where desp-tb-pr-cex.cod-emitente   = cod-emitente-desp
                          and desp-tb-pr-cex.cod-itiner     = 0
                          and desp-tb-pr-cex.cod-incoterm   = cod-incoterm
                          and desp-tb-pr-cex.nr-tab         = nr-tab 
                          and desp-tb-pr-cex.cod-desp       = cod-desp
                          and desp-tb-pr-cex.cod-cond-pag   = cod-cond-pag 
                          and desp-tb-pr-cex.situacao       = 1 no-lock no-error.
                    if not avail desp-tb-pr-cex then do:
                        find first desp-tb-pr-cex 
                            where desp-tb-pr-cex.cod-emitente   = cod-emitente-desp
                              and desp-tb-pr-cex.cod-itiner     = 0
                              and desp-tb-pr-cex.cod-incoterm   = ""
                              and desp-tb-pr-cex.nr-tab         = nr-tab 
                              and desp-tb-pr-cex.cod-desp       = cod-desp
                              and desp-tb-pr-cex.cod-cond-pag   = cod-cond-pag 
                              and desp-tb-pr-cex.situacao       = 1 no-lock no-error.
                    end.
                end.
            end.

            IF AVAIL desp-tb-pr-cex THEN DO:

                IF desp-tb-pr-cex.val-desp > 0 THEN DO:

                    find first tb-pr-cex 
                         where tb-pr-cex.cod-emitente = desp-tb-pr-cex.cod-emitente
                           and tb-pr-cex.cod-itiner   = desp-tb-pr-cex.cod-itiner
                           and tb-pr-cex.cod-incoterm = desp-tb-pr-cex.cod-incoterm
                           and tb-pr-cex.nr-tab       = desp-tb-pr-cex.nr-tab no-lock no-error.

                    if avail tb-pr-cex then do:
                        run cdp/cd0812.p (input  tb-pr-cex.mo-codigo,
                                          input  mo-codigo,
                                          input  desp-tb-pr-cex.val-desp,
                                          input  da-data-cotacao,
                                          output d-resultado).
                    end.
                END.
                ELSE IF desp-tb-pr-cex.dsl-formul-despes <> "" THEN DO:
                    ASSIGN c-formula = desp-tb-pr-cex.dsl-formul-despes.
                END.
            END.
        END.
        
        if desp-imp.tipo  = 3 and
           d-resultado   <> 0 then do:

            if i-calculo = 1 or
               i-calculo = 2 then do:

                find item where item.it-codigo = it-codigo no-lock no-error.
                if avail item then do:

                    find first item-fornec 
                        where item-fornec.it-codigo    = item.it-codigo 
                        and   item-fornec.cod-emitente = cod-emitente no-lock no-error.

                    if avail item-fornec then do:

                        if item-fornec.cod-embal <> "" then do:

                            find embalag where embalag.embalagem = item-fornec.cod-embal no-lock no-error.
                            if avail embalag then
                                assign d-resultado = d-resultado * (item.peso-liquido + embalag.peso-embal).
                            else
                                assign d-resultado = d-resultado * item.peso-bruto.
                        end.
                        else
                            assign d-resultado = d-resultado * item.peso-bruto.
                    end.
                    else
                        assign d-resultado = d-resultado * item.peso-bruto.
                end.
            end.

            if i-calculo = 3 then do:

                find item where item.it-codigo = it-codigo no-lock no-error.
                if avail item then
                    assign d-resultado = d-resultado * (item.peso-bruto).
            end.
        end.

        if desp-imp.tipo = 9 and
           d-resultado <> 0 then do:

            if i-calculo = 1 or
               i-calculo = 2 then do:

                find item where item.it-codigo = it-codigo no-lock no-error.
                if avail item then do:

                    find first item-fornec 
                        where item-fornec.it-codigo    = item.it-codigo 
                        and   item-fornec.cod-emitente = cod-emitente no-lock no-error.

                    if avail item-fornec then do:

                        if item-fornec.cod-embal <> "" then do:

                            find embalag where embalag.embalagem = item-fornec.cod-embal no-lock no-error.
                            if avail embalag then
                                assign d-resultado = d-resultado * embalag.volume.
                            else
                                d-resultado = d-resultado * (item.altura * item.largura * item.comprim).
                        end.
                        else
                            d-resultado = d-resultado * (item.altura * item.largura * item.comprim).
                    end.
                    else
                        d-resultado = d-resultado * (item.altura * item.largura * item.comprim).
                end.
            end.

            if i-calculo = 3 then do:

                find item where item.it-codigo = it-codigo no-lock no-error.
                if avail item then
                    assign d-resultado = d-resultado * (item.altura * item.largura * item.comprim).
            end.
        end.

        if d-resultado = 0 and 
           c-formula <> "" then do:

            run cxbo~/bocx095.p persistent set h-bocx095.
            run geraTTvar in h-bocx095 (input c-formula,
                                        output table tt-var).
            run setTT-var (input-output table tt-var).

            run calculaFormula in h-bocx095 (input c-formula,
                                             input table tt-var,
                                             output d-resultado,
                                             OUTPUT TABLE RowErrors).
            delete procedure h-bocx095.
        end.

        /*
        if (desp-imp.tipo  = 1 or desp-imp.tipo = 7 ) and
            d-resultado   <> 0 THEN
            RETURN.
        */

        IF i-calculo = 3 THEN DO:
        
            find first desp-tb-pr-cex 
                where desp-tb-pr-cex.cod-emitente = cod-emitente-desp
                and   desp-tb-pr-cex.cod-itiner   = cod-itiner
                and   desp-tb-pr-cex.cod-incoterm = cod-incoterm
                and   desp-tb-pr-cex.nr-tab       = nr-tab
                and   desp-tb-pr-cex.cod-desp     = cod-desp
                and   desp-tb-pr-cex.cod-cond-pag = cod-cond-pag 
                and   desp-tb-pr-cex.situacao     = 1 no-lock no-error.

            if not avail desp-tb-pr-cex then do:
                find first desp-tb-pr-cex 
                    where desp-tb-pr-cex.cod-emitente   = cod-emitente-desp
                      and desp-tb-pr-cex.cod-itiner     = cod-itiner
                      and desp-tb-pr-cex.cod-incoterm   = ""
                      and desp-tb-pr-cex.nr-tab         = nr-tab 
                      and desp-tb-pr-cex.cod-desp       = cod-desp
                      and desp-tb-pr-cex.cod-cond-pag   = cod-cond-pag 
                      and desp-tb-pr-cex.situacao       = 1 no-lock no-error.
                if not avail desp-tb-pr-cex then do:
                    find first desp-tb-pr-cex 
                        where desp-tb-pr-cex.cod-emitente   = cod-emitente-desp
                          and desp-tb-pr-cex.cod-itiner     = 0
                          and desp-tb-pr-cex.cod-incoterm   = cod-incoterm
                          and desp-tb-pr-cex.nr-tab         = nr-tab 
                          and desp-tb-pr-cex.cod-desp       = cod-desp
                          and desp-tb-pr-cex.cod-cond-pag   = cod-cond-pag 
                          and desp-tb-pr-cex.situacao       = 1 no-lock no-error.
                    if not avail desp-tb-pr-cex then do:
                        find first desp-tb-pr-cex 
                            where desp-tb-pr-cex.cod-emitente   = cod-emitente-desp
                              and desp-tb-pr-cex.cod-itiner     = 0
                              and desp-tb-pr-cex.cod-incoterm   = ""
                              and desp-tb-pr-cex.nr-tab         = nr-tab 
                              and desp-tb-pr-cex.cod-desp       = cod-desp
                              and desp-tb-pr-cex.cod-cond-pag   = cod-cond-pag 
                              and desp-tb-pr-cex.situacao       = 1 no-lock no-error.
                    end.
                end.
            end.
    
            if avail desp-tb-pr-cex then do:
    
                find tb-pr-cex 
                    where tb-pr-cex.cod-emitente    = desp-tb-pr-cex.cod-emitente
                    and   tb-pr-cex.cod-itiner      = desp-tb-pr-cex.cod-itiner
                    and   tb-pr-cex.cod-incoterm    = desp-tb-pr-cex.cod-incoterm
                    and   tb-pr-cex.nr-tab          = desp-tb-pr-cex.nr-tab no-lock no-error.
    
                if avail tb-pr-cex then do:
    
                    if tb-pr-cex.mo-codigo <> mo-codigo then do:
                        run cdp/cd0812.p (input  tb-pr-cex.mo-codigo,
                                          input  mo-codigo,
                                          input  d-resultado,
                                          input  da-data-cotacao,
                                          output d-resultado-conv).
                    end.
                    ELSE ASSIGN d-resultado-conv = d-resultado.
    
                    if desp-tb-pr-cex.val-min-desp <> 0 and
                       d-resultado-conv < desp-tb-pr-cex.val-min-desp then do:
    
                        run cdp/cd0812.p (input  tb-pr-cex.mo-codigo,
                                          input  mo-codigo,
                                          input  desp-tb-pr-cex.val-min-desp,
                                          input  da-data-cotacao,
                                          output d-resultado-conv).
                    end.
    
                    if desp-tb-pr-cex.val-max-desp <> 0 and
                       d-resultado-conv > desp-tb-pr-cex.val-max-desp then do:
    
                        run cdp/cd0812.p (input  tb-pr-cex.mo-codigo,
                                          input  mo-codigo,
                                          input  desp-tb-pr-cex.val-max-desp,
                                          input  da-data-cotacao,
                                          output d-resultado-conv).
                    end.

                    ASSIGN d-resultado = d-resultado-conv.
                end.
            end.
        END.
    END.
END PROCEDURE.

/**/

procedure setTT-var:

    define INPUT-OUTPUT parameter table for tt-var.

    DEFINE VARIABLE d-val-desp-aux AS DECIMAL    NO-UNDO.

    for each tt-var:

        IF tt-var.nome = "incoterm" then do:
            if i-calculo = 1 or 
               i-calculo = 2 then
                assign tt-var.texto = cod-incoterm.
        end.
        ELSE IF tt-var.nome = "via-transporte" then do:

            if i-calculo = 1 or
               i-calculo = 2 then do:

                IF NOT AVAIL ordem-compra THEN
                    FIND ordem-compra WHERE ordem-compra.numero-ordem = numero-ordem NO-LOCK NO-ERROR.

                if avail ordem-compra then do:

                    find pedido-compr where pedido-compr.num-pedido = ordem-compra.num-pedido no-lock no-error.

                    IF AVAIL pedido-compr THEN DO:

                        find first processo-imp 
                            where processo-imp.num-pedido = pedido-compr.num-pedido no-lock no-error.
    
                        if avail processo-imp then do:
                            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                                DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
                                ASSIGN cAuxTraducao001 = {adinc/i01ad268.i 04 processo-imp.via-transp}.
                                run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                                                    INPUT "",
                                                    INPUT "").
                                ASSIGN  tt-var.texto = RETURN-VALUE.
                            &else
                                ASSIGN tt-var.texto = {adinc/i01ad268.i 04 processo-imp.via-transp}.
                            &endif
                        end.
                        else do:
                            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                                DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
                                ASSIGN cAuxTraducao002 = {adinc/i01ad268.i 04 pedido-compr.via-transp}.
                                run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                                                    INPUT "",
                                                    INPUT "").
                                ASSIGN  tt-var.texto = RETURN-VALUE.
                            &else
                                ASSIGN tt-var.texto = {adinc/i01ad268.i 04 pedido-compr.via-transp}.
                            &endif
                        end.
                    END.
                end.
            end.
        end.
        ELSE IF tt-var.nome = "val-merc-liq" then do:

            if i-calculo = 1 or
               i-calculo = 2 then do:

                FIND cotacao-item
                    WHERE cotacao-item.numero-ordem = numero-ordem
                    AND   cotacao-item.cod-emitente = cod-emitente
                    AND   cotacao-item.it-codigo    = it-codigo
                    AND   cotacao-item.seq-cotac    = seq-cotac NO-LOCK NO-ERROR.

                IF AVAIL cotacao-item THEN DO:
                    assign tt-var.valor = (cotacao-item.preco-unit * 100) / (cotacao-item.aliquota-ipi + 100).
                    if cotacao-item.mo-codigo <> mo-codigo then do:
                        run cdp/cd0812.p (input cotacao-item.mo-codigo,
                                          input mo-codigo,
                                          input tt-var.valor,
                                          input da-data-cotacao,
                                          output tt-var.valor).
                    end.
                END.
            end.
        end.
        ELSE IF tt-var.nome = "val-merc-bruto" then do:

            if i-calculo = 1 or
               i-calculo = 2 then do:

                FIND cotacao-item
                    WHERE cotacao-item.numero-ordem = numero-ordem
                    AND   cotacao-item.cod-emitente = cod-emitente
                    AND   cotacao-item.it-codigo    = it-codigo
                    AND   cotacao-item.seq-cotac    = seq-cotac NO-LOCK NO-ERROR.

                IF AVAIL cotacao-item THEN DO:
                    assign tt-var.valor = ((cotacao-item.preco-unit * 100) / (cotacao-item.aliquota-ipi + 100))
                           tt-var.valor = tt-var.valor / (1 - (cotacao-item.perc-descto / 100)).
                    if cotacao-item.mo-codigo <> mo-codigo then do:
                        run cdp/cd0812.p (input cotacao-item.mo-codigo,
                                          input mo-codigo,
                                          input tt-var.valor,
                                          input da-data-cotacao,
                                          output tt-var.valor).
                    end.
                END.
            end.

        end.
        ELSE IF tt-var.nome = "val-negoc-liq" then do:

            if i-calculo = 1 or
               i-calculo = 2 then do:

                FIND cotacao-item
                    WHERE cotacao-item.numero-ordem = numero-ordem
                    AND   cotacao-item.cod-emitente = cod-emitente
                    AND   cotacao-item.it-codigo    = it-codigo
                    AND   cotacao-item.seq-cotac    = seq-cotac NO-LOCK NO-ERROR.

                IF AVAIL cotacao-item THEN DO:
                    assign tt-var.valor = (cotacao-item.preco-unit * 100) / (cotacao-item.aliquota-ipi + 100).
                    if cotacao-item.mo-codigo <> mo-codigo then do:
                        run cdp/cd0812.p (input cotacao-item.mo-codigo,
                                          input mo-codigo,
                                          input tt-var.valor,
                                          input da-data-cotacao,
                                          output tt-var.valor).
                    end.
                END.
            end.

            if i-calculo = 1 then do:

                for each desp-incoterm where desp-incoterm.cod-incoterm = cod-incoterm no-lock:

                    find FIRST cotacao-item-cex
                        where cotacao-item-cex.numero-ordem = numero-ordem
                        and   cotacao-item-cex.cod-emitente = cod-emitente
                        and   cotacao-item-cex.it-codigo    = it-codigo
                        and   cotacao-item-cex.seq-cotac    = seq-cotac
                        and   cotacao-item-cex.data-cotacao = da-data-cotacao
                        and   cotacao-item-cex.mapa-cotacao = mapa-cotacao
                        and   cotacao-item-cex.cod-desp     = desp-incoterm.cod-desp no-lock no-error.

                    if avail cotacao-item-cex then do:
                        assign d-val-desp-aux = cotacao-item-cex.val-desp.

                        if cotacao-item-cex.mo-codigo <> mo-codigo then do:

                            run cdp/cd0812.p (input cotacao-item-cex.mo-codigo,
                                              input mo-codigo,
                                              input d-val-desp-aux,
                                              input da-data-cotacao,
                                              output d-val-desp-aux).
                        end.

                        assign tt-var.valor = tt-var.valor + d-val-desp-aux.
                    end.
                end.
            end.
            else if i-calculo = 2 then do:

                IF NOT AVAIL ordem-compra THEN
                    find ordem-compra where ordem-compra.numero-ordem = numero-ordem no-lock no-error.

                /* Cria tt-cotacao-item-cex para cria‡Æo das despesas */
                run imp/im0091.p persistent set h-im0091.
                run setaValorinicial in h-im0091 (input today,
                                                  input ordem-compra.cod-estabel).
            
                run rateioGrupoordens in h-im0091 (input cod-agrup,
                                                   input mapa-cotacao,
                                                   INPUT cod-desp,
                                                   output table tt-desp-rateio).
            
                run getTTbo-erro in h-im0091 (output table tt-bo-erro).
                delete procedure h-im0091.
            
                find first tt-bo-erro no-error.
                if avail tt-bo-erro then
                    leave.    

                for each desp-incoterm where desp-incoterm.cod-incoterm = cod-incoterm no-lock:

                    find first tt-desp-rateio no-lock where
                        tt-desp-rateio.cod-desp = desp-incoterm.cod-desp NO-ERROR.
                    IF AVAILABLE tt-desp-rateio THEN DO:

                        assign d-val-desp-aux = tt-desp-rateio.val-desp-unit.

                        if mo-codigo <> 0 then do:
                            run cdp/cd0812.p (input ordem-compra.mo-codigo,
                                              input mo-codigo,
                                              input d-val-desp-aux,
                                              input da-data-cotacao,
                                              output d-val-desp-aux).
                        end.

                        ASSIGN tt-var.valor = tt-var.valor + d-val-desp-aux.
                    END.
                end.
            end.
        end.
        ELSE IF tt-var.nome = "val-negoc-bruto" then do:

            if i-calculo = 1 or
               i-calculo = 2 then do:

                FIND cotacao-item
                    WHERE cotacao-item.numero-ordem = numero-ordem
                    AND   cotacao-item.cod-emitente = cod-emitente
                    AND   cotacao-item.it-codigo    = it-codigo
                    AND   cotacao-item.seq-cotac    = seq-cotac NO-LOCK NO-ERROR.

                IF AVAIL cotacao-item THEN DO:
                    assign tt-var.valor = ((cotacao-item.preco-unit * 100) / (cotacao-item.aliquota-ipi + 100))
                           tt-var.valor = tt-var.valor / (1 - (cotacao-item.perc-descto / 100)).
                    if cotacao-item.mo-codigo <> mo-codigo then do:
                        run cdp/cd0812.p (input cotacao-item.mo-codigo,
                                          input mo-codigo,
                                          input tt-var.valor,
                                          input da-data-cotacao,
                                          output tt-var.valor).
                    end.
                END.
            end.

            if i-calculo = 1 then do:

                for each desp-incoterm where desp-incoterm.cod-incoterm = cod-incoterm no-lock:

                    find FIRST cotacao-item-cex
                        where cotacao-item-cex.numero-ordem = numero-ordem
                        and   cotacao-item-cex.cod-emitente = cod-emitente
                        and   cotacao-item-cex.it-codigo    = it-codigo
                        and   cotacao-item-cex.seq-cotac    = seq-cotac
                        and   cotacao-item-cex.data-cotacao = da-data-cotacao
                        and   cotacao-item-cex.mapa-cotacao = mapa-cotacao
                        and   cotacao-item-cex.cod-desp     = desp-incoterm.cod-desp no-lock no-error.

                    if avail cotacao-item-cex then do:

                        assign d-val-desp-aux = cotacao-item-cex.val-desp.

                        if cotacao-item-cex.mo-codigo <> mo-codigo then do:

                            run cdp/cd0812.p (input cotacao-item-cex.mo-codigo,
                                              input mo-codigo,
                                              input d-val-desp-aux,
                                              input da-data-cotacao,
                                              output d-val-desp-aux).
                        end.

                        assign tt-var.valor = tt-var.valor + d-val-desp-aux.
                    end.
                end.
            end.
            else if i-calculo = 2 then do:

                IF NOT AVAIL ordem-compra THEN
                    find ordem-compra where ordem-compra.numero-ordem = numero-ordem no-lock no-error.

                /* Cria tt-cotacao-item-cex para cria‡Æo das despesas */
                run imp/im0091.p persistent set h-im0091.
                run setaValorinicial in h-im0091 (input today,
                                                  input ordem-compra.cod-estabel).
            
                run rateioGrupoordens in h-im0091 (input cod-agrup,
                                                   input mapa-cotacao,
                                                   INPUT cod-desp,
                                                   output table tt-desp-rateio).
            
                run getTTbo-erro in h-im0091 (output table tt-bo-erro).
                delete procedure h-im0091.
            
                find first tt-bo-erro no-error.
                if avail tt-bo-erro then
                    leave.    

                for each desp-incoterm where desp-incoterm.cod-incoterm = cod-incoterm no-lock:

                    find first tt-desp-rateio NO-LOCK where
                        tt-desp-rateio.cod-desp = desp-incoterm.cod-desp NO-ERROR.
                    IF AVAILABLE tt-desp-rateio THEN DO:

                        assign d-val-desp-aux = tt-desp-rateio.val-desp-unit.

                        if mo-codigo <> 0 then do:
                            run cdp/cd0812.p (input ordem-compra.mo-codigo,
                                              input mo-codigo,
                                              input d-val-desp-aux,
                                              input da-data-cotacao,
                                              output d-val-desp-aux).
                        end.

                        ASSIGN tt-var.valor = tt-var.valor + d-val-desp-aux.
                    end.
                end.
            end.
        end.
        ELSE IF tt-var.nome = "peso-liq" then do:

            if i-calculo = 1 or
               i-calculo = 2 then do:

                find item where item.it-codigo = it-codigo no-lock no-error.
                if avail item then 
                    assign tt-var.valor = item.peso-liquido.

            end.

        end.
        ELSE IF tt-var.nome = "peso-bruto" then do:

            if i-calculo = 1 or
               i-calculo = 2 then do:

                find item where item.it-codigo = it-codigo no-lock no-error.
                if avail item then do:

                    find first item-fornec where item-fornec.it-codigo = item.it-codigo no-lock no-error.
                    if avail item-fornec then do:

                        if item-fornec.cod-embal <> "" then do:

                            find embalag where embalag.embalagem = item-fornec.cod-embal no-lock no-error.
                            if avail embalag then
                                assign tt-var.valor = item.peso-liquido + embalag.peso-embal.
                            else
                                assign tt-var.valor = item.peso-bruto.

                        end.
                        else
                            assign tt-var.valor = item.peso-bruto.

                    end.
                    else
                        assign tt-var.valor = item.peso-bruto.
                end.
            end.
        end.
        ELSE IF tt-var.nome = "dist-itiner" then do:

            find itinerario where itinerario.cod-itiner = cod-itiner no-lock no-error.
            if avail itinerario then
                assign tt-var.valor = itinerario.distancia.

        end.
        ELSE IF tt-var.nome = "dias-itiner" then do:

            find itinerario where itinerario.cod-itiner = cod-itiner no-lock no-error.
            if avail itinerario then
                assign tt-var.valor = itinerario.nr-dias.

        end.
        ELSE IF tt-var.nome = "dias-despacho" then do:

            if i-calculo = 1 or
               i-calculo = 2 then do:

                find itinerario where itinerario.cod-itiner = cod-itiner no-lock no-error.
                if avail itinerario then do:

                    find pto-itiner 
                        where pto-itiner.cod-itiner    = itinerario.cod-itiner 
                        and   pto-itiner.cod-pto-contr = itinerario.pto-despacho no-lock no-error.

                    if avail pto-itiner then
                        assign tt-var.valor = pto-itiner.nr-dias.
                end.
            end.
        end.
        ELSE IF tt-var.nome = "dias-embarque" then do:

            if i-calculo = 1 or
               i-calculo = 2 then do:

                find itinerario where itinerario.cod-itiner = cod-itiner no-lock no-error.
                if avail itinerario then do:

                    find pto-itiner 
                        where pto-itiner.cod-itiner    = itinerario.cod-itiner 
                        and   pto-itiner.cod-pto-contr = itinerario.pto-embarque no-lock no-error.

                    if avail pto-itiner then
                        assign tt-var.valor = pto-itiner.nr-dias.
                end.
            end.
        end.
        ELSE IF tt-var.nome = "dias-eadi" then do:

            if i-calculo = 1 or
               i-calculo = 2 then do:

                find itinerario where itinerario.cod-itiner = cod-itiner no-lock no-error.
                if avail itinerario then do:

                    find pto-itiner 
                        where pto-itiner.cod-itiner    = itinerario.cod-itiner 
                        and   pto-itiner.cod-pto-contr = itinerario.int-1 no-lock no-error.

                    if avail pto-itiner then
                        assign tt-var.valor = pto-itiner.nr-dias.
                end.
            end.
        end.
        ELSE IF tt-var.nome = "dias-nacionaliz" then do:

            if i-calculo = 1 or
               i-calculo = 2 then do:

                find itinerario where itinerario.cod-itiner = cod-itiner no-lock no-error.
                if avail itinerario then do:

                    find pto-itiner 
                        where pto-itiner.cod-itiner    = itinerario.cod-itiner 
                        and   pto-itiner.cod-pto-contr = itinerario.pto-desembarque no-lock no-error.

                    if avail pto-itiner then
                        assign tt-var.valor = pto-itiner.nr-dias.
                end.
            end.
        end.
        ELSE IF tt-var.nome = "dias-chegada" then do:

            if i-calculo = 1 or
               i-calculo = 2 then do:

                find itinerario where itinerario.cod-itiner = cod-itiner no-lock no-error.
                if avail itinerario then do:

                    find pto-itiner 
                        where pto-itiner.cod-itiner    = itinerario.cod-itiner 
                        and   pto-itiner.cod-pto-contr = itinerario.pto-chegada no-lock no-error.

                    if avail pto-itiner then
                        assign tt-var.valor = pto-itiner.nr-dias.
                end.
            end.
        end.
        ELSE IF tt-var.nome = "cubagem" then do:

            if i-calculo = 1 or
               i-calculo = 2 then do:

                find item where item.it-codigo = it-codigo no-lock no-error.
                if avail item then do:

                    find first item-fornec where item-fornec.it-codigo = item.it-codigo no-lock no-error.
                    if avail item-fornec then do:

                        if item-fornec.cod-embal <> "" then do:

                            find embalag where embalag.embalagem = item-fornec.cod-embal no-lock no-error.
                            if avail embalag then
                                assign tt-var.valor = embalag.volume.
                            else
                                assign tt-var.valor = item.altura * item.comprim * item.largura.

                        end.
                        else
                            assign tt-var.valor = item.altura * item.comprim * item.largura.

                    end.
                    else
                        assign tt-var.valor = item.altura * item.comprim * item.largura.

                end.

            end.

        end.
        ELSE IF tt-var.nome = "tax-bas-seguro" then do:

            if i-calculo = 1 or
               i-calculo = 2 then do:

                find item where item.it-codigo = it-codigo no-lock no-error.
                if avail item then do:

                    find item-mat where item-mat.it-codigo = item.it-codigo no-lock no-error.
                    if avail item-mat then
                        assign tt-var.valor = item-mat.val-tax-basic-seguro.

                end.

            end.

        end.
        ELSE IF tt-var.nome = "tax-imp-seguro" then do:

            if i-calculo = 1 or
               i-calculo = 2 then do:

                find item where item.it-codigo = it-codigo no-lock no-error.
                if avail item then do:

                    find item-mat where item-mat.it-codigo = item.it-codigo no-lock no-error.
                    if avail item-mat then
                        assign tt-var.valor = item-mat.val-tax-impto-seguro.

                end.

            end.

        end.
        ELSE IF tt-var.nome BEGINS "val-inco-" then do:

            if i-calculo = 1 or
               i-calculo = 2 then do:

                FIND cotacao-item
                    WHERE cotacao-item.numero-ordem = numero-ordem
                    AND   cotacao-item.cod-emitente = cod-emitente
                    AND   cotacao-item.it-codigo    = it-codigo
                    AND   cotacao-item.seq-cotac    = seq-cotac NO-LOCK NO-ERROR.

                IF AVAIL cotacao-item THEN DO:
                    assign tt-var.valor = (cotacao-item.preco-unit * 100) / (cotacao-item.aliquota-ipi + 100).

                    if cotacao-item.mo-codigo <> mo-codigo then do:
                        run cdp/cd0812.p (input cotacao-item.mo-codigo,
                                          input mo-codigo,
                                          input tt-var.valor,
                                          input da-data-cotacao,
                                          output tt-var.valor).
                    end.
                END.
            end.

            if can-find (first inco-cx where inco-cx.cod-incoterm = cod-incoterm) then do:

                if i-calculo = 1 then do:

                    for each desp-incoterm 
                        where desp-incoterm.cod-incoterm = cod-incoterm no-lock:

                        find desp-imp where desp-imp.cod-desp = desp-incoterm.cod-desp no-lock no-error.
                        if avail desp-imp then do:

                            find cotacao-item-cex
                                where cotacao-item-cex.numero-ordem = numero-ordem
                                and   cotacao-item-cex.cod-emitente = cod-emitente
                                and   cotacao-item-cex.it-codigo    = it-codigo
                                and   cotacao-item-cex.seq-cotac    = seq-cotac
                                and   cotacao-item-cex.data-cotacao = da-data-cotacao
                                and   cotacao-item-cex.cod-desp     = desp-imp.cod-desp no-lock no-error.

                            if avail cotacao-item-cex THEN DO:

                                ASSIGN d-val-desp-aux = cotacao-item-cex.val-desp.

                                if cotacao-item-cex.mo-codigo <> mo-codigo then do:
                                
                                    run cdp/cd0812.p (input cotacao-item-cex.mo-codigo,
                                                      input mo-codigo,
                                                      input d-val-desp-aux,
                                                      input da-data-cotacao,
                                                      output d-val-desp-aux).
                                end.

                                ASSIGN tt-var.valor = tt-var.valor + d-val-desp-aux.
                            END.
                        end.
                    end.
                end.
                else if i-calculo = 2 then do:

                    IF NOT AVAIL ordem-compra THEN
                        find ordem-compra where ordem-compra.numero-ordem = numero-ordem no-lock no-error.
                
                    /* Cria tt-cotacao-item-cex para cria‡Æo das despesas */
                    run imp/im0091.p persistent set h-im0091.
                    run setaValorinicial in h-im0091 (input today,
                                                      input ordem-compra.cod-estabel).
                
                    run rateioGrupoordens in h-im0091 (input cod-agrup,
                                                       input mapa-cotacao,
                                                       INPUT cod-desp,
                                                       output table tt-desp-rateio).
                
                    run getTTbo-erro in h-im0091 (output table tt-bo-erro).
                    delete procedure h-im0091.
                
                    find first tt-bo-erro no-error.
                    if avail tt-bo-erro then
                        leave.    

                    for each desp-incoterm where desp-incoterm.cod-incoterm = cod-incoterm no-lock:
                        find first tt-desp-rateio NO-LOCK where
                            tt-desp-rateio.cod-desp = desp-incoterm.cod-desp NO-ERROR.
                        IF AVAILABLE tt-desp-rateio THEN DO:
                            assign d-val-desp-aux = tt-desp-rateio.val-desp-unit.

                            if mo-codigo <> 0 then do:
                                run cdp/cd0812.p (input ordem-compra.mo-codigo,
                                                  input mo-codigo,
                                                  input d-val-desp-aux,
                                                  input da-data-cotacao,
                                                  output d-val-desp-aux).
                            end.

                            ASSIGN tt-var.valor = tt-var.valor + d-val-desp-aux.
                        END.
                    end.
                end.
            end.
        end.
        ELSE IF tt-var.nome BEGINS "val-desp-" then do:

            find desp-imp where desp-imp.cod-desp = cod-desp no-lock no-error.
            if avail desp-imp then do:

                if i-calculo = 1 then do:

                    find FIRST cotacao-item-cex
                        where cotacao-item-cex.numero-ordem = numero-ordem
                        and   cotacao-item-cex.cod-emitente = cod-emitente
                        and   cotacao-item-cex.it-codigo    = it-codigo
                        and   cotacao-item-cex.seq-cotac    = seq-cotac
                        and   cotacao-item-cex.data-cotacao = da-data-cotacao
                        AND   cotacao-item-cex.mapa-cotacao = mapa-cotacao
                        and   cotacao-item-cex.cod-desp     = INTEGER(SUBSTRING(STRING(tt-var.nome),10)) no-lock no-error.

                    if avail cotacao-item-cex then do:
                        assign tt-var.valor = cotacao-item-cex.val-desp.

                        if cotacao-item-cex.mo-codigo <> mo-codigo then do:
                            run cdp/cd0812.p (input cotacao-item-cex.mo-codigo,
                                              input mo-codigo,
                                              input tt-var.valor,
                                              input da-data-cotacao,
                                              output tt-var.valor).
                        end.
                    end.
                end.
                else if i-calculo = 2 then do:

                    IF NOT AVAIL ordem-compra THEN
                        find ordem-compra where ordem-compra.numero-ordem = numero-ordem no-lock no-error.
                
                    /* Cria tt-cotacao-item-cex para cria‡Æo das despesas */
                    run imp/im0091.p persistent set h-im0091.
                    run setaValorinicial in h-im0091 (input today,
                                                      input ordem-compra.cod-estabel).
                
                    run rateioGrupoordens in h-im0091 (input cod-agrup,
                                                       input mapa-cotacao,
                                                       INPUT INTEGER(SUBSTRING(STRING(tt-var.nome),10)),
                                                       output table tt-desp-rateio).

                    run getTTbo-erro in h-im0091 (output table tt-bo-erro).
                    delete procedure h-im0091.
                
                    find first tt-bo-erro no-error.
                    if avail tt-bo-erro then
                        leave.    

                    find first tt-desp-rateio NO-LOCK where
                        tt-desp-rateio.cod-desp = INTEGER(SUBSTRING(STRING(tt-var.nome),10)) NO-ERROR.
                    IF AVAILABLE tt-desp-rateio THEN
                        assign tt-var.valor = tt-desp-rateio.val-desp-unit.

                    if mo-codigo <> 0 then do:
                        run cdp/cd0812.p (input ordem-compra.mo-codigo,
                                          input mo-codigo,
                                          input tt-var.valor,
                                          input da-data-cotacao,
                                          output tt-var.valor).
                    end.

                end.
                else if i-calculo = 3 then do:

                    FIND FIRST proc-desp-itiner 
                        where proc-desp-itiner.cod-estabel       = cod-estabel
                        AND   proc-desp-itiner.nr-proc-exp       = nr-proc-exp
                        AND   proc-desp-itiner.cod-itiner        = cod-itiner
                        AND   proc-desp-itiner.cod-desp          = INTEGER(SUBSTRING(STRING(tt-var.nome),10))
                        AND   proc-desp-itiner.cod-emitente-desp = cod-emitente-desp NO-LOCK NO-ERROR.

                    if avail proc-desp-itiner then do:
                        assign tt-var.valor = proc-desp-itiner.val-desp.

                        if proc-desp-itiner.mo-codigo <> mo-codigo then do:

                            run cdp/cd0812.p (input proc-desp-itiner.mo-codigo,
                                              input mo-codigo,
                                              input tt-var.valor,
                                              input da-data-cotacao,
                                              output tt-var.valor).
                        end.
                    end.
                end.
            END.
        end.
        ELSE IF tt-var.nome BEGINS "cod-desp-" then do:
            assign tt-var.texto = SUBSTRING(STRING(tt-var.nome),10).
        end.

        /* Ponto de Chamada EPC */

        for each tt-epc where tt-epc.cod-event = "setVariavelEspecifica":
            delete tt-epc.
        end.

        create tt-epc.
        assign tt-epc.cod-event     = "setVariavelEspecifica"
               tt-epc.cod-parameter = tt-var.nome.

        if tt-var.tipo-res = 1 then
            assign tt-epc.val-parameter = string(tt-var.valor).
        else if tt-var.tipo-res = 2 then
            assign tt-epc.val-parameter = tt-var.texto.

        create tt-epc.
        assign tt-epc.cod-event     = "setVariavelEspecifica"
               tt-epc.cod-parameter = string(tt-var.tipo-res).

        {include/i-epc201.i "setVariavelEspecifica"}.

        find first tt-epc
            where tt-epc.cod-event     = "setVariavelEspecifica"
            and   tt-epc.cod-parameter = string(tt-var.tipo-res) no-lock no-error.

        if avail tt-epc then do:

            if tt-epc.val-parameter = "1" then do:

                find first tt-epc
                    where tt-epc.cod-event     = "setVariavelEspecifica"
                    and   tt-epc.cod-parameter = tt-var.nome no-lock no-error.

                if avail tt-epc then
                    assign tt-var.valor = dec(tt-epc.val-parameter).

            end.
            else if tt-epc.val-parameter = "2" then do:

                find first tt-epc
                    where tt-epc.cod-event     = "setVariavelEspecifica"
                    and   tt-epc.cod-parameter = tt-var.nome no-lock no-error.

                if avail tt-epc then
                    assign tt-var.texto = tt-epc.val-parameter.

            end.

        end.

        for each tt-epc where tt-epc.cod-event = "setVariavelEspecifica":
            delete tt-epc.
        end.

    end.

end procedure.

/**/

PROCEDURE pi-bocx095ab:

    DEFINE OUTPUT PARAMETER d-resultado AS DECIMAL  FORMAT ">>>,>>>,>>>,>>9.99999".


    DEFINE VARIABLE de-tot-pa           AS DECIMAL    NO-UNDO.

    DEFINE VARIABLE param-qt-solic      AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE param-quantidade    AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE param-valor         AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE param-pre-unit-for  AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE param-valor-taxa    AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE param-nr-dias-taxa  AS INTEGER    NO-UNDO.
    DEFINE VARIABLE param-peso          AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE param-volume        AS DECIMAL    NO-UNDO.

    DEFINE VARIABLE de-preco-unit       AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE de-pre-unit-for     AS DECIMAL    NO-UNDO.

    IF i-tipo-comex = 1 THEN DO:
    
        if not avail ordem-compra then
            find ordem-compra no-lock where ordem-compra.numero-ordem = numero-ordem  no-error.
    
        if avail ordem-compra then do:
    
            for each prazo-compra no-lock where prazo-compra.numero-ordem = ordem-compra.numero-ordem:
                assign de-tot-pa = de-tot-pa + prazo-compra.quantidade.
            end.
            &if defined(bf-mat-comex) &then           
                assign param-qt-solic = de-tot-pa.   
            &else
                assign param-qt-solic = ordem-compra.qt-solic.     
            &endif
            assign param-quantidade = de-tot-pa.
        end.
    
        find cotacao-item no-lock
            where cotacao-item.numero-ordem = numero-ordem
            and   cotacao-item.cod-emitente = cod-emitente
            and   cotacao-item.it-codigo    = it-codigo
            &if defined(bf-mat-comex) &then
            and   cotacao-item.data-cotacao = da-data-cotacao
            &else
            and   cotacao-item.seq-cotac    = seq-cotac
            &endif
            no-error.
    
        if avail cotacao-item then do:
    
            assign de-preco-unit   = cotacao-item.preco-unit
                   de-pre-unit-for = cotacao-item.pre-unit-for.
    
            if cotacao-item.mo-codigo <> mo-codigo then do:     
    
                run cdp/cd0812.p (input cotacao-item.mo-codigo,
                                  input mo-codigo,
                                  input cotacao-item.preco-unit,
                                  input da-data-cotacao,
                                  output de-preco-unit).
                
                if de-preco-unit = 0 or
                   de-preco-unit = ? then
                    assign de-preco-unit = cotacao-item.preco-unit.               
    
                run cdp/cd0812.p (input cotacao-item.mo-codigo,
                                  input mo-codigo,
                                  input cotacao-item.pre-unit-for,
                                  input da-data-cotacao,
                                  output de-pre-unit-for).
    
                if de-pre-unit-for = 0 or
                   de-pre-unit-for = ? then
                    assign de-pre-unit-for = cotacao-item.pre-unit-for.
    
            end.
    
            assign de-preco-unit   = (de-preco-unit * 100) / (100 + cotacao-item.aliquota-ipi)
                   de-pre-unit-for = (de-pre-unit-for * 100) / (100 + cotacao-item.aliquota-ipi).        
    
            assign param-valor        = de-preco-unit
                   param-pre-unit-for = de-pre-unit-for
                   param-valor-taxa   = cotacao-item.valor-taxa
                   param-nr-dias-taxa = cotacao-item.nr-dias-taxa.
    
        end.
    
        find item where item.it-codigo = it-codigo no-lock no-error.
        if avail item then
            assign param-peso   = item.peso-bruto
                   param-volume = item.altura * item.comprim * item.largura.

        /*bocx095b.p*/
    
        {cdp/cd4300.i3}     /* include tratamento atributo livre */
        {cxbo/bocx250.i50}  /* include tratamento atributo livre */
    
        find param-imp where param-imp.cod-estabel = ordem-compra.cod-estabel no-lock no-error.

        IF l-nt2024002 THEN
            FIND FIRST param-imp-trib WHERE param-imp-trib.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
    
        if avail param-imp then do:
            {cdp/cd4300.i4 "yes" param-imp.char-1}
            {cxbo/bocx250.i51 "yes"}
            if cod-desp = i-desp-ii-i50 then do:
                find cotacao-item
                    where cotacao-item.numero-ordem = numero-ordem 
                      and cotacao-item.cod-emitente = cod-emitente
                      and cotacao-item.it-codigo    = it-codigo
                    &if defined(bf-mat-comex) &then
                      and cotacao-item.data-cotacao = da-data-cotacao no-lock no-error.
                    &else
                      and cotacao-item.seq-cotac    = seq-cotac no-lock no-error.
                    &endif
                /*
                ** C lculo Imposto Importa‡Æo Unit rio
                */
                run imp/im0090.p (input cod-desp,
                                  input rowid(cotacao-item),
                                  input mapa-cotacao,
                                  output d-resultado,
                                  output table tt-bo-erro).
                run cdp/cd0812.p (input 0,
                                  input mo-codigo,
                                  input d-resultado,
                                  input da-data-cotacao,
                                  output d-resultado).
            end.
            /*--- Eng geracao Impto Padrao
                  calcula valor do IPI ou ICMS ---*/
            else DO:
    
                if  cod-desp = param-imp.cdn-despes-impto-ipi
                or  cod-desp = param-imp.cdn-despes-impto-icms then do:
    
                    if  r-cot-it-cex <> ? then do:
                        find cotacao-item-cex 
                            where rowid(cotacao-item-cex) = r-cot-it-cex no-lock no-error.
                        if  avail cotacao-item-cex THEN DO:
                            /*--- calcula valor do IPI ou ICMS ---*/
                            run imp/imapi007.p (input buffer cotacao-item-cex:handle,
                                                input cod-desp,
                                                INPUT 0,
                                                INPUT 0,
                                                output d-resultado).
                            run cdp/cd0812.p (input 0,
                                              input mo-codigo,
                                              input d-resultado,
                                              input da-data-cotacao,
                                              output d-resultado).
                        END.
                    end.
                    ELSE DO:
                        create tt-parametros-imp.
                        assign tt-parametros-imp.numero-ordem   = numero-ordem
                               tt-parametros-imp.it-codigo      = it-codigo
                               &if defined(bf-mat-comex) &then
                               tt-parametros-imp.data           = da-data-cotacao
                               &else
                               tt-parametros-imp.seq-cotac      = seq-cotac
                               &endif
                               tt-parametros-imp.mapa-cotacao   = mapa-cotacao
                               tt-parametros-imp.cod-emitente   = cod-emitente.
    
                        run imp/imapi007.p (input buffer tt-parametros-imp:handle,
                                            input cod-desp,
                                            INPUT 0,
                                            INPUT 0,
                                            output d-resultado).
                        run cdp/cd0812.p (input 0,
                                          input mo-codigo,
                                          input d-resultado,
                                          input da-data-cotacao,
                                          output d-resultado).
                        DELETE tt-parametros-imp.
                    END.
    
                    return.
                end.
                /*--- calcula PIS ou COFINS ---*/
                else 
                    if  cod-desp = param-imp.cdn-despes-impto-pis 
                    or  cod-desp = param-imp.cdn-despes-impto-cofins then do:
    
                        if  r-cot-it-cex <> ? then do:
                            find cotacao-item-cex 
                                where rowid(cotacao-item-cex) = r-cot-it-cex no-lock no-error.
                            if  avail cotacao-item-cex THEN DO:
                                /*--- calcula valores das despesas dos
                                      impostos PIS ou COFINS. ---*/
                                run imp/imapi008.p (input buffer cotacao-item-cex:handle,
                                                    input cod-desp,
                                                    INPUT cod-emitente,
                                                    input 0,
                                                    input 0,
                                                    output d-resultado).
                                run cdp/cd0812.p (input 0,
                                                  input mo-codigo,
                                                  input d-resultado,
                                                  input da-data-cotacao,
                                                  output d-resultado).
                            END.
                        end.
                        ELSE DO:
                            create tt-parametros-imp.
                            assign tt-parametros-imp.numero-ordem   = numero-ordem
                                   tt-parametros-imp.it-codigo      = it-codigo
                                   &if defined(bf-mat-comex) &then
                                   tt-parametros-imp.data           = da-data-cotacao
                                   &else
                                   tt-parametros-imp.seq-cotac      = seq-cotac
                                   &endif
                                   tt-parametros-imp.mapa-cotacao   = mapa-cotacao
                                   tt-parametros-imp.cod-emitente   = cod-emitente.
    
                             run imp/imapi008.p (input buffer tt-parametros-imp:handle,
                                                 input cod-desp,
                                                 INPUT cod-emitente,
                                                 input 0,
                                                 input 0,
                                                 output d-resultado).
                             run cdp/cd0812.p (input 0,
                                               input mo-codigo,
                                               input d-resultado,
                                               input da-data-cotacao,
                                               output d-resultado).
                             DELETE tt-parametros-imp.
                        END.
    
                        return.
                    end.
                    /* Calcula IBS UF, IBS Mun, CBS e IS */ 
                    ELSE 
                        IF l-nt2024002 AND AVAIL param-imp-trib
                        AND (   cod-desp = param-imp-trib.cdn-despes-impto-IBSUF 
                             OR cod-desp = param-imp-trib.cdn-despes-impto-IBSMun
                             OR cod-desp = param-imp-trib.cdn-despes-impto-CBS
                             OR cod-desp = param-imp-trib.cdn-despes-impto-IS) THEN DO:
                             
                            IF  r-cot-it-cex <> ? THEN DO:
                                FIND cotacao-item-cex 
                                    WHERE ROWID(cotacao-item-cex) = r-cot-it-cex NO-LOCK NO-ERROR.
                                IF  AVAIL cotacao-item-cex THEN DO:
                                
                                    IF cod-desp = param-imp-trib.cdn-despes-impto-IBSUF THEN
                                        RUN imp/imapi014.p (INPUT BUFFER cotacao-item-cex:HANDLE,
                                                            INPUT cod-desp,
                                                            INPUT 0,
                                                            INPUT 0,
                                                            OUTPUT d-resultado).

                                    IF cod-desp = param-imp-trib.cdn-despes-impto-CBS THEN
                                        RUN imp/imapi015.p (INPUT BUFFER cotacao-item-cex:HANDLE,
                                                            INPUT cod-desp,
                                                            INPUT cod-emitente,
                                                            INPUT 0,
                                                            INPUT 0,
                                                            OUTPUT d-resultado).

                                    IF cod-desp = param-imp-trib.cdn-despes-impto-IBSMun THEN
                                        RUN imp/imapi016.p (INPUT BUFFER cotacao-item-cex:HANDLE,
                                                            INPUT cod-desp,
                                                            INPUT 0,
                                                            INPUT 0,
                                                            OUTPUT d-resultado).
                                    IF cod-desp = param-imp-trib.cdn-despes-impto-IS THEN
                                        RUN imp/imapi021.p (INPUT BUFFER cotacao-item-cex:HANDLE,
                                                            INPUT cod-desp,
                                                            INPUT 0,
                                                            INPUT 0,
                                                            OUTPUT d-resultado).
                                    RUN cdp/cd0812.p (INPUT 0,
                                                      INPUT mo-codigo,
                                                      INPUT d-resultado,
                                                      INPUT da-data-cotacao,
                                                      OUTPUT d-resultado).
                                END.
                            END.
                            ELSE DO:
                                CREATE tt-parametros-imp.
                                ASSIGN tt-parametros-imp.numero-ordem   = numero-ordem
                                       tt-parametros-imp.it-codigo      = it-codigo
                                       &if defined(bf-mat-comex) &then
                                       tt-parametros-imp.data           = da-data-cotacao
                                       &else
                                       tt-parametros-imp.seq-cotac      = seq-cotac
                                       &endif
                                       tt-parametros-imp.mapa-cotacao   = mapa-cotacao
                                       tt-parametros-imp.cod-emitente   = cod-emitente.
            
                                IF cod-desp = param-imp-trib.cdn-despes-impto-IBSUF THEN
                                    RUN imp/imapi014.p (INPUT BUFFER tt-parametros-imp:HANDLE,
                                                        INPUT cod-desp,
                                                        INPUT 0,
                                                        INPUT 0,
                                                        OUTPUT d-resultado).

                                IF cod-desp = param-imp-trib.cdn-despes-impto-CBS THEN
                                    RUN imp/imapi015.p (INPUT BUFFER tt-parametros-imp:HANDLE,
                                                        INPUT cod-desp,
                                                        INPUT cod-emitente,
                                                        INPUT 0,
                                                        INPUT 0,
                                                        OUTPUT d-resultado).

                                IF cod-desp = param-imp-trib.cdn-despes-impto-IBSMun THEN
                                    RUN imp/imapi016.p (INPUT BUFFER tt-parametros-imp:HANDLE,
                                                        INPUT cod-desp,
                                                        INPUT 0,
                                                        INPUT 0,
                                                        OUTPUT d-resultado).
                                IF cod-desp = param-imp-trib.cdn-despes-impto-IS THEN
                                    RUN imp/imapi021.p (INPUT BUFFER tt-parametros-imp:HANDLE,
                                                        INPUT cod-desp,
                                                        INPUT 0,
                                                        INPUT 0,
                                                        OUTPUT d-resultado).
                                RUN cdp/cd0812.p (INPUT 0,
                                                  INPUT mo-codigo,
                                                  INPUT d-resultado,
                                                  INPUT da-data-cotacao,
                                                  OUTPUT d-resultado).
                                DELETE tt-parametros-imp.
                            END.
                            RETURN.
                        END.
            END.
        end.
    END.

END PROCEDURE.
