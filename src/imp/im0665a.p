/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**  
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0665A 2.00.00.052 } /*** "010052" 17/08/2026 02:49:40 ***/
 
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0665a MIM}
&ENDIF

/******************************************************************************
**
**       PROGRAMA:  IM0665A.P
**
**       DATA....:  FEVEREIRO DE 2003
**
**       OBJETIVO:  Custo Real de Importaá∆o / Por Embarque - Detalhado
**
**       VERSAO..:  1.00.000 - Ivonei Vock
**
******************************************************************************/


{cdp/cdcfgmat.i}
{imp/im0665.i} /* Definiá∆o tt-param          **
               ** Definiá∆o tt-detalha-item   **
               ** Definiá∆o tt-embarque-cabec **
               ** Definiá∆o tt-embarque-corpo */
{imp/im0665.i1} /* Definiá∆o das Frames */

DEF INPUT  PARAM TABLE FOR tt-param.
DEF INPUT  PARAM TABLE FOR tt-detalha-item.
DEF INPUT  PARAM TABLE FOR tt-embarque-cabec.
DEF INPUT  PARAM TABLE FOR tt-embarque-corpo.
DEF INPUT  PARAM TABLE FOR tt-embarque-fatura.
DEF INPUT  PARAM TABLE FOR tt-detalha-despesa.
DEF INPUT  PARAM TABLE FOR tt-detalha-despesa-aux.
DEF INPUT  PARAM TABLE FOR tt-embarque-rel.
DEF INPUT  PARAM TABLE FOR tt-nf-comp.
DEF INPUT  PARAM TABLE FOR tt-embarque-nota-mae.
DEF INPUT  PARAM TABLE FOR tt-embarque-nf.
DEF INPUT  PARAM TABLE FOR tt-impto-internac.
DEF OUTPUT PARAM bh-dados-excel         AS HANDLE NO-UNDO.
DEF OUTPUT PARAM bh-dados-excel-detail  AS HANDLE NO-UNDO.

/*Variaveis para manipular as handles*/
DEFINE VARIABLE bufferTableExcel       AS HANDLE      NO-UNDO.
DEFINE VARIABLE tth-dados-excel        AS HANDLE      NO-UNDO.
DEFINE VARIABLE hQuery                 AS HANDLE      NO-UNDO.
DEFINE VARIABLE hfield-desp            AS HANDLE      NO-UNDO.
DEFINE VARIABLE bufferTableExcelDetail AS HANDLE      NO-UNDO.
DEFINE VARIABLE tth-dados-excel-detail AS HANDLE      NO-UNDO.
DEFINE VARIABLE hQueryDetail           AS HANDLE      NO-UNDO.
DEFINE VARIABLE hfield-despDetail      AS HANDLE      NO-UNDO.

DEFINE VARIABLE h-acomp-a       AS   HANDLE                            NO-UNDO.
DEFINE VARIABLE var-despesa-orc LIKE tt-detalha-despesa.vl-des-orc     NO-UNDO.
DEFINE VARIABLE per-despesa-orc LIKE tt-detalha-despesa.per-des-orc    NO-UNDO.
DEFINE VARIABLE var-despesa-rea LIKE tt-detalha-despesa.vl-des-rea     NO-UNDO.
DEFINE VARIABLE per-despesa-rea LIKE tt-detalha-despesa.per-des-rea    NO-UNDO.
DEFINE VARIABLE l-imprime       AS   LOGICAL                           NO-UNDO.
DEFINE VARIABLE de-tot-desp     LIKE tt-detalha-despesa.vl-des-rea     NO-UNDO.
DEFINE VARIABLE l-nota-mae      AS   LOGICAL                           NO-UNDO.
DEFINE VARIABLE i-cod-desp-ii   LIKE docum-est-cex.cod-desp  INITIAL 0 NO-UNDO.

DEFINE VARIABLE vl-impto-int      LIKE tt-impto-internac.val-impto-moeda-relat    NO-UNDO.
DEFINE VARIABLE vl-impto-int-mo   LIKE tt-impto-internac.val-impto-moeda-relat-mo NO-UNDO.
DEFINE VARIABLE vl-tot-impto-int  LIKE tt-impto-internac.val-impto-moeda-relat    NO-UNDO.
DEFINE VARIABLE i-valor-iva-compl AS   DECIMAL                                    NO-UNDO.



FIND FIRST tt-param.

run utp/ut-acomp.p persistent set h-acomp-a.


bufferTableExcel = BUFFER tt-dados-excel:HANDLE. /*passa a tt para a handle*/
CREATE TEMP-TABLE tth-dados-excel. /*cria a temp-table da handle*/
tth-dados-excel:CREATE-LIKE(bufferTableExcel). /*pega os atributos da tt-dados-excel*/

IF tt-param.l-itens OR tt-param.l-orc-real THEN DO:
    bufferTableExcelDetail = BUFFER tt-dados-excel-detail:HANDLE. /*passa a tt para a handle*/
    CREATE TEMP-TABLE tth-dados-excel-detail. /*cria a temp-table da handle*/
    tth-dados-excel-detail:CREATE-LIKE(bufferTableExcelDetail). /*pega os atributos da tt-dados-excel*/
END.
{utp/ut-liter.i Detalhes_do_Embarque}

run pi-inicializar in h-acomp-a (input RETURN-VALUE).
run pi-desabilita-cancela in h-acomp-a.

for each tt-embarque-corpo
    break by tt-embarque-corpo.embarque:
    
    IF LAST-OF(tt-embarque-corpo.embarque) THEN DO: 

        {utp/ut-liter.i Listando_Embarques}
        run pi-acompanhar in h-acomp-a (input RETURN-VALUE + ": " + STRING(tt-embarque-corpo.cod-estabel) + string(tt-embarque-corpo.embarque)).

        run display-cabecalho. /*Apresenta o Cabeáalho*/
    
        for each  tt-embarque-fatura
            where tt-embarque-fatura.embarque    = tt-embarque-corpo.embarque
              and tt-embarque-fatura.cod-estabel = tt-embarque-corpo.cod-estabel:
            IF NOT tt-param.excel THEN DO:
                disp tt-embarque-fatura.nr-fatura  
                     tt-embarque-fatura.parcela    
                     tt-embarque-fatura.dt-venc-fat
                     WITH FRAME f-fatura.
                down with frame f-fatura.
            END.
        end.
        IF NOT tt-param.excel THEN
            PUT SKIP(1).

        ASSIGN l-nota-mae = NO.
        FOR EACH tt-embarque-nota-mae 
           WHERE tt-embarque-nota-mae.embarque    = tt-embarque-corpo.embarque
             AND tt-embarque-nota-mae.cod-estabel = tt-embarque-corpo.cod-estabel:
            ASSIGN l-nota-mae = YES.
            IF tt-param.excel THEN 
                ASSIGN tt-dados-excel.nr-di = tt-embarque-nota-mae.nr-di  
                       tt-dados-excel.dt-di = tt-embarque-nota-mae.dt-di .
            ELSE 
                disp tt-embarque-nota-mae.nr-nota-fis
                     tt-embarque-nota-mae.dt-emissao
                     tt-embarque-nota-mae.nr-di
                     tt-embarque-nota-mae.dt-di
                     WITH FRAME f-nota-fiscal-2.
        END.

        FOR EACH tt-embarque-nf 
           WHERE tt-embarque-nf.embarque    = tt-embarque-corpo.embarque
             AND tt-embarque-nf.cod-estabel = tt-embarque-corpo.cod-estabel:     
            IF l-nota-mae THEN DO:
                IF tt-param.excel THEN 
                    ASSIGN tt-dados-excel.nr-di = tt-embarque-nf.nr-di  
                           tt-dados-excel.dt-di = tt-embarque-nf.dt-di .
                ELSE 
                    disp tt-embarque-nf.nr-nota-fis
                         tt-embarque-nf.dt-emissao 
                         tt-embarque-nf.nr-di      
                         tt-embarque-nf.dt-di      
                         WITH FRAME f-nota-fiscal-3.
                         DOWN WITH FRAME f-nota-fiscal-3.
            END.
            ELSE DO:
                IF tt-param.excel THEN 
                    ASSIGN tt-dados-excel.nr-di = tt-embarque-nf.nr-di 
                           tt-dados-excel.dt-di = tt-embarque-nf.dt-di.
                ELSE 
                    disp tt-embarque-nf.nr-nota-fis
                         tt-embarque-nf.dt-emissao
                         tt-embarque-nf.nr-di
                         tt-embarque-nf.dt-di
                         WITH FRAME f-nota-fiscal.
                         DOWN WITH FRAME f-nota-fiscal.
            END.
        END.       
        IF NOT tt-param.excel THEN
            PUT SKIP(1).

        IF  tt-param.l-nf-compl THEN DO: /*Considera Nota Complementar*/
            ASSIGN l-imprime      = NO
                   de-tot-nf-comp = 0
                   de-tot-imp-nf-comp = 0.
            FOR EACH  tt-nf-comp
                WHERE tt-nf-comp.embarque    = tt-embarque-corpo.embarque
                  AND tt-nf-comp.cod-estabel = tt-embarque-corpo.cod-estabel
                BREAK BY tt-nf-comp.nr-nf-comp:
                
                ASSIGN l-imprime = YES
                       de-tot-nf-comp = de-tot-nf-comp + tt-nf-comp.tot-valor
                       de-tot-imp-nf-comp = de-tot-imp-nf-comp + tt-nf-comp.tot-imposto.

                IF NOT tt-param.excel THEN DO:
                    if i-pais-impto-usuario <> 1 then do:
                        DISP tt-nf-comp.nr-nf-comp
                             tt-nf-comp.dt-emis-comp
                             tt-nf-comp.tot-valor
                             tt-nf-comp.tot-imposto
                             tt-nf-comp.moeda-mo
                             tt-nf-comp.tot-valor-mo
                             tt-nf-comp.tot-imposto-mo
                            WITH FRAME f-nf-compl-int.
                        DOWN WITH FRAME f-nf-compl-int.
                    end.
                    else do: 
                        DISP tt-nf-comp.nr-nf-comp
                             tt-nf-comp.dt-emis-comp
                             tt-nf-comp.tot-valor
                            WITH FRAME f-nf-compl.
                        DOWN WITH FRAME f-nf-compl.
                    end.
                END.
            END.
            IF  l-imprime = YES THEN DO:
                IF NOT tt-param.excel THEN DO:
                    if i-pais-impto-usuario <> 1 then do:
                        DISP de-tot-nf-comp 
                             de-tot-imp-nf-comp WITH FRAME f-tot-nf-comp-int. 
                        PUT SKIP(1).
                    end.
                    else do:
                        DISP de-tot-nf-comp no-label WITH FRAME f-tot-nf-comp. 
                        PUT SKIP(1).
                    end.
                END.
            END.
        END.
        
        ASSIGN l-imprime = NO.
        for each  tt-embarque-rel
            where tt-embarque-rel.embarque    = tt-embarque-corpo.embarque
              and tt-embarque-rel.cod-estabel = tt-embarque-corpo.cod-estabel:
            ASSIGN l-imprime = YES.
            IF NOT tt-param.excel THEN DO:
                disp tt-embarque-rel.embarque-rel
                     tt-embarque-rel.nr-nota-rel
                     tt-embarque-rel.dt-emis-rel
                     tt-embarque-rel.nr-di-rel
                     tt-embarque-rel.dt-di-rel
                     WITH FRAME f-embarq-rel.
                down with frame f-embarq-rel.
            END.
        end.
        IF  l-imprime = YES AND NOT tt-param.excel THEN 
            PUT SKIP(1).

        /* Equador */
    IF i-pais-impto-usuario = 21 AND tt-param.l-desp-imp and not tt-param.excel THEN DO:

        /* Zera as vari†veis */
        ASSIGN tt-embarque-corpo.vl-ger-tot-imp-rea               = 0
               tt-embarque-corpo.vl-ger-tot-imp-des-rea           = 0
               tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea = 0
               tt-embarque-corpo.vl-ger-tot-sem-ipi-icms-merc-rea = 0
               tt-embarque-corpo.vl-ger-ii-orc                    = 0
               tt-embarque-corpo.vl-ger-tot-imp-orc               = 0
               i-valor-iva-compl                                  = 0. 

        /*O II deve ser impresso juntamente com as despesas que s∆o impostos quando localizaá∆o Equador*/
        for first param-imp 
            where param-imp.cod-estabel = tt-embarque-corpo.cod-estabel no-lock:
        end.
        if avail param-imp then
            assign i-cod-desp-ii   = int(substring(param-imp.char-1,21,20)).  

        FIND FIRST tt-detalha-despesa-aux
             WHERE tt-detalha-despesa-aux.embarque      = tt-embarque-corpo.embarque
             AND   tt-detalha-despesa-aux.cod-estabel   = tt-embarque-corpo.cod-estabel NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-detalha-despesa-aux THEN DO:
            FOR EACH desp-embarque
               WHERE desp-embarque.cod-estabel = tt-embarque-corpo.cod-estabel
               AND   desp-embarque.embarque    = tt-embarque-corpo.embarque NO-LOCK:
               IF desp-embarque.cod-desp = param-imp.cdn-despes-iva THEN
                   NEXT.
               CREATE tt-detalha-despesa-aux.
               ASSIGN tt-detalha-despesa-aux.embarque    = desp-embarque.embarque
                      tt-detalha-despesa-aux.cod-estabel = desp-embarque.cod-estabel
                      tt-detalha-despesa-aux.cod-despesa = desp-embarque.cod-desp
                      tt-detalha-despesa-aux.vl-des-rea  = desp-embarque.val-desp  
                      tt-detalha-despesa-aux.sequencia   = tt-detalha-despesa-aux.sequencia + 10.
            END.
        END.        

        /*Gera ii e as NFs Complementares*/
        FOR EACH desp-embarque NO-LOCK
            WHERE desp-embarque.cod-estabel = tt-embarque-corpo.cod-estabel
            AND   desp-embarque.embarque    = tt-embarque-corpo.embarque,
            FIRST desp-imp NO-LOCK
            WHERE desp-imp.cod-desp = desp-embarque.cod-desp:
            
            IF desp-embarque.cod-desp    = i-cod-desp-ii  
                AND NOT CAN-FIND(FIRST tt-detalha-despesa-aux
                                 WHERE tt-detalha-despesa-aux.embarque    = desp-embarque.embarque     
                                 AND   tt-detalha-despesa-aux.cod-estabel = desp-embarque.cod-estabel  
                                 AND   tt-detalha-despesa-aux.cod-despesa = desp-embarque.cod-desp     
                                 ) THEN DO:
                CREATE tt-detalha-despesa-aux.
                ASSIGN tt-detalha-despesa-aux.embarque    = desp-embarque.embarque
                       tt-detalha-despesa-aux.cod-estabel = desp-embarque.cod-estabel
                       tt-detalha-despesa-aux.cod-despesa = desp-embarque.cod-desp
                       tt-detalha-despesa-aux.sequencia   = tt-detalha-despesa-aux.sequencia + 10
                       tt-detalha-despesa-aux.vl-des-rea  = desp-embarque.val-desp.
            
                IF tt-param.moeda <> desp-embarque.mo-codigo THEN DO:
                    run cdp/cd0812.p (input  desp-embarque.mo-codigo, /*moeda origem*/
                                      input  tt-param.moeda,          /*moeda destino*/
                                      input  desp-embarque.val-desp,  /*valor origem*/
                                      input  tt-embarque-cabec.data-convercao,     /*data conversao*/
                                      output tt-detalha-despesa-aux.vl-des-rea). /*valor destino*/              
                END.
            END.
            ELSE DO:
                /*Cria Despesas complementares*/
                IF desp-embarque.log-despes-ja-recbda 
                    AND (AVAIL desp-imp AND desp-imp.log-imposto = NO) 
                    AND NOT CAN-FIND(FIRST tt-detalha-despesas-comp-equador
                                     WHERE tt-detalha-despesas-comp-equador.embarque    = desp-embarque.embarque     
                                     AND   tt-detalha-despesas-comp-equador.cod-estabel = desp-embarque.cod-estabel  
                                     AND   tt-detalha-despesas-comp-equador.cod-despesa = desp-embarque.cod-desp)
                    THEN DO:
                    CREATE tt-detalha-despesas-comp-equador.
                    ASSIGN tt-detalha-despesas-comp-equador.embarque    = desp-embarque.embarque
                           tt-detalha-despesas-comp-equador.cod-estabel = desp-embarque.cod-estabel
                           tt-detalha-despesas-comp-equador.cod-despesa = desp-embarque.cod-desp
                           tt-detalha-despesas-comp-equador.sequencia   = tt-detalha-despesas-comp-equador.sequencia + 10
                           tt-detalha-despesas-comp-equador.desc-despesa = desp-imp.descricao
                           tt-detalha-despesas-comp-equador.vl-des-rea   = desp-embarque.val-desp.

                    IF tt-param.moeda <> desp-embarque.mo-codigo THEN DO:
                        run cdp/cd0812.p (input  desp-embarque.mo-codigo, /*moeda origem*/
                                          input  tt-param.moeda,          /*moeda destino*/
                                          input  desp-embarque.val-desp,  /*valor origem*/
                                          input  tt-embarque-cabec.data-convercao,     /*data conversao*/
                                          output tt-detalha-despesas-comp-equador.vl-des-rea). /*valor destino*/                    
                    END.
                END.                                             
            END.
        END.
        
        /* Imprime o valor da Mercadoria */
        DISP tt-embarque-corpo.vl-ger-mercado-rea
             WITH FRAME f-cab-realiz-ecu.       

        /* Imprime a nota Complementar */
        IF  tt-param.l-nf-compl THEN DO: /*Considera Nota Complementar*/
        
            DISP tt-embarque-corpo.vl-ger-ii-orc
                WITH FRAME f-impto-nf-compl.
                DOWN WITH FRAME f-impto-nf-compl.
            ASSIGN i-valor-iva-compl = i-valor-iva-compl + tt-embarque-corpo.vl-ger-ii-orc.

            FOR EACH tt-detalha-despesas-comp-equador
               WHERE tt-detalha-despesas-comp-equador.embarque      = tt-embarque-corpo.embarque
               AND   tt-detalha-despesas-comp-equador.cod-estabel   = tt-embarque-corpo.cod-estabel
               BREAK BY tt-detalha-despesas-comp-equador.cod-despesa:
    
               /* imprime as despesas que ser∆o impostos na nota complementar */
               FOR FIRST desp-embarque
                   WHERE desp-embarque.cod-estabel = tt-embarque-corpo.cod-estabel
                   AND   desp-embarque.embarque    = tt-embarque-corpo.embarque
                   AND   desp-embarque.cod-desp    = tt-detalha-despesas-comp-equador.cod-despesa NO-LOCK:
                   
                   FIND FIRST desp-imp
                        WHERE desp-imp.cod-desp = desp-embarque.cod-desp NO-LOCK NO-ERROR. 
                   IF AVAIL desp-imp AND desp-imp.log-imposto = YES THEN DO:

                       IF NOT CAN-FIND(FIRST tt-detalha-despesa
                                       WHERE tt-detalha-despesa.cod-estabel = desp-embarque.cod-estabel
                                       AND   tt-detalha-despesa.embarque    = desp-embarque.embarque   
                                       AND   tt-detalha-despesa.cod-desp    = desp-embarque.cod-desp) THEN                          
                           CREATE tt-detalha-despesa.
                       ELSE
                           FOR FIRST tt-detalha-despesa
                               WHERE tt-detalha-despesa.cod-estabel = desp-embarque.cod-estabel
                               AND   tt-detalha-despesa.embarque    = desp-embarque.embarque   
                               AND   tt-detalha-despesa.cod-desp    = desp-embarque.cod-desp        : END.

                       ASSIGN tt-detalha-despesa.cod-estabel = desp-embarque.cod-estabel 
                              tt-detalha-despesa.embarque    = desp-embarque.embarque    
                              tt-detalha-despesa.cod-desp    = desp-embarque.cod-desp    
                              tt-detalha-despesa.desc-despesa = desp-imp.descricao
                              tt-detalha-despesa.vl-des-rea   = desp-embarque.val-desp.

                       IF tt-param.moeda <> desp-embarque.mo-codigo THEN DO:
                           run cdp/cd0812.p (input  desp-embarque.mo-codigo, /*moeda origem*/
                                             input  tt-param.moeda,          /*moeda destino*/
                                             input  desp-embarque.val-desp,  /*valor origem*/
                                             input  tt-embarque-cabec.data-convercao,     /*data conversao*/
                                             output tt-detalha-despesa.vl-des-rea). /*valor destino*/                    
                       END.

                       ASSIGN  tt-embarque-corpo.vl-ger-tot-des-orc-aux = tt-embarque-corpo.vl-ger-tot-des-orc-aux + tt-detalha-despesa.vl-des-rea
                               tt-embarque-corpo.vl-ger-tot-imp-rea     = tt-detalha-despesa.vl-des-rea + tt-embarque-corpo.vl-ger-tot-imp-rea.

                       IF LAST-OF(tt-detalha-despesas-comp-equador.cod-despesa) THEN DO:
                           DISP tt-detalha-despesa.desc-despesa
                                tt-detalha-despesa.vl-des-rea
                               WITH FRAME f-det-desp-imp-comp-ecu.
                               DOWN WITH FRAME f-det-desp-imp-comp-ecu. 
                       END.
                                      
                   END.
               END.
            END.            
        END. /* fim do complementar */

        /* imprimir os impostos que ser∆o despesas */       
        FOR EACH  tt-detalha-despesa-aux
            WHERE tt-detalha-despesa-aux.embarque      = tt-embarque-corpo.embarque
            AND   tt-detalha-despesa-aux.cod-estabel   = tt-embarque-corpo.cod-estabel
            BREAK BY tt-detalha-despesa-aux.cod-despesa:
            FIND FIRST desp-imp
                 WHERE desp-imp.cod-desp = tt-detalha-despesa-aux.cod-despesa NO-LOCK NO-ERROR.
            IF AVAIL desp-imp AND desp-imp.log-imposto = YES
                OR   desp-imp.cod-desp = i-cod-desp-ii 
                AND  desp-imp.cod-desp <> param-imp.cdn-despes-iva THEN DO:     

                ASSIGN tt-detalha-despesa-aux.desc-despesa = desp-imp.descricao
                       tt-embarque-corpo.vl-ger-tot-imp-rea = tt-embarque-corpo.vl-ger-tot-imp-rea + ROUND(tt-detalha-despesa-aux.vl-des-rea,2).           


                IF LAST-OF(tt-detalha-despesa-aux.cod-despesa) THEN DO:

                    ASSIGN tt-embarque-corpo.vl-ger-tot-imp-rea = tt-embarque-corpo.vl-ger-tot-imp-rea + i-valor-iva-compl +  tt-embarque-corpo.vl-ger-tot-des-orc-aux.
                    DISP tt-detalha-despesa-aux.desc-despesa
                         tt-detalha-despesa-aux.vl-des-rea
                         WITH FRAME f-det-desp-impost-ecu.
                    DOWN WITH FRAME f-det-desp-impost-ecu.
                END.
            
                /*Elimina despesa-aux referente ao II pois s¢ Ç necess†rio mostrar nessa frame do relat¢rio*/
                IF tt-detalha-despesa-aux.cod-despesa = i-cod-desp-ii THEN
                   DELETE tt-detalha-despesa-aux.
            END.
        END. /* fim da impress∆o dos impostos que ser∆o despesas */

        DISP tt-embarque-corpo.vl-ger-tot-imp-rea
          WITH FRAME f-tot-imposto-ecu.

        /* imprimir as despesas */
        ASSIGN tt-embarque-corpo.vl-ger-tot-des-rea = 0.

        FOR EACH  tt-detalha-despesa-aux
            WHERE tt-detalha-despesa-aux.embarque      = tt-embarque-corpo.embarque
            AND   tt-detalha-despesa-aux.cod-estabel   = tt-embarque-corpo.cod-estabel 
            BREAK BY tt-detalha-despesa-aux.cod-despesa:
            FOR EACH desp-embarque NO-LOCK
                WHERE desp-embarque.cod-estabel = tt-embarque-corpo.cod-estabel
                AND   desp-embarque.embarque    = tt-embarque-corpo.embarque
                AND   desp-embarque.cod-desp   = tt-detalha-despesa-aux.cod-despesa:
                FIND FIRST itinerario
                    WHERE itinerario.cod-itiner = desp-embarque.cod-itiner NO-LOCK NO-ERROR.
                IF AVAIL itinerario THEN DO:
                    IF itinerario.pto-desembarque = desp-embarque.cod-pto-contr THEN DO:
                        FIND FIRST desp-imp
                             WHERE desp-imp.cod-desp = tt-detalha-despesa-aux.cod-despesa NO-LOCK NO-ERROR.
                        IF AVAIL desp-imp AND desp-imp.log-imposto = NO AND desp-imp.inc-val-duplic THEN DO:
                            ASSIGN tt-embarque-corpo.vl-ger-tot-des-rea = tt-embarque-corpo.vl-ger-tot-des-rea + tt-detalha-despesa-aux.vl-des-rea.
                            IF LAST-OF(tt-detalha-despesa-aux.cod-despesa) THEN DO:
                                   DISP  tt-detalha-despesa-aux.desc-despesa
                                         tt-detalha-despesa-aux.vl-des-rea
                                         WITH FRAME f-det-desp-ecu.
                                    DOWN WITH FRAME f-det-desp-ecu.
                            END.
                        END.
                    END.
                END.              
            END.
        END. /* fim da impress∆o das despesas */

        DISP tt-embarque-corpo.vl-ger-tot-des-rea
             WITH FRAME f-tot-desp-ecu.

        IF  tt-param.l-nf-compl THEN DO: /*Considera Nota Complementar*/
            FOR EACH  tt-detalha-despesas-comp-equador EXCLUSIVE-LOCK
                WHERE tt-detalha-despesas-comp-equador.embarque      = tt-embarque-corpo.embarque
                AND   tt-detalha-despesas-comp-equador.cod-estabel   = tt-embarque-corpo.cod-estabel
                BREAK BY tt-detalha-despesas-comp-equador.cod-despesa:
                /*despesa complementar */
                ASSIGN tt-embarque-corpo.vl-ger-tot-imp-orc = tt-embarque-corpo.vl-ger-tot-imp-orc + tt-detalha-despesas-comp-equador.vl-des-rea.
                IF LAST-OF(tt-detalha-despesas-comp-equador.cod-despesa) THEN DO:
                    DISP tt-detalha-despesas-comp-equador.desc-despesa
                         tt-detalha-despesas-comp-equador.vl-des-rea
                         WITH FRAME f-det-desp-comp-ecu.
                         DOWN WITH FRAME f-det-desp-comp-ecu. 
                END.
            END.
        

            DISP tt-embarque-corpo.vl-ger-tot-imp-orc
                 WITH FRAME f-det-tot-desp-comp-ecu.
                 DOWN WITH FRAME f-det-tot-desp-comp-ecu. 
    
            ASSIGN tt-embarque-corpo.vl-ger-tot-imp-des-rea  = ROUND(tt-embarque-corpo.vl-ger-tot-imp-rea,2) + ROUND(tt-embarque-corpo.vl-ger-tot-des-rea,2) + ROUND(tt-embarque-corpo.vl-ger-tot-imp-orc,2)
                   tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea = ROUND(tt-embarque-corpo.vl-ger-tot-imp-des-rea,2) + ROUND(tt-embarque-corpo.vl-ger-mercado-rea,2)
                   tt-embarque-corpo.vl-ger-tot-sem-ipi-icms-merc-rea = ROUND(tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea,2) - ROUND(tt-embarque-corpo.vl-ger-tot-imp-rea,2).
            
            
            disp tt-embarque-corpo.vl-ger-tot-imp-des-rea
                 tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea
                 tt-embarque-corpo.vl-ger-tot-sem-ipi-icms-merc-rea
                 WITH FRAME f-totais-ecu. /* Imprime os totais */
            
        
        END.
        ELSE DO:
			ASSIGN tt-embarque-corpo.vl-ger-tot-imp-des-rea           = ROUND(tt-embarque-corpo.vl-ger-tot-imp-rea              ,2) + ROUND(tt-embarque-corpo.vl-ger-tot-des-rea,2)
				   tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea = ROUND(tt-embarque-corpo.vl-ger-tot-imp-des-rea          ,2) + ROUND(tt-embarque-corpo.vl-ger-mercado-rea,2)
				   tt-embarque-corpo.vl-ger-tot-sem-ipi-icms-merc-rea = ROUND(tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea,2) - ROUND(tt-embarque-corpo.vl-ger-tot-imp-rea,2).


			DISP tt-embarque-corpo.vl-ger-tot-imp-des-rea
				 tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea
				 tt-embarque-corpo.vl-ger-tot-sem-ipi-icms-merc-rea
				 WITH FRAME f-totais-ecu. /* Imprime os totais */
        END.
    END. /* fim do Equador */
    ELSE DO:    
        IF  tt-param.l-desp-imp    AND
            NOT tt-param.l-orc-real THEN DO:
            /* Impress∆o do cabeáalho */

            IF  tt-param.excel THEN DO:
                tth-dados-excel:ADD-NEW-FIELD("vl-ger-mercado-rea","dec",0,">>>,>>>,>>9.99999",?,"Valor Merc").       
                tth-dados-excel:ADD-NEW-FIELD("per-ger-mercado-rea","dec",0,?,?,"% Vl Merc").

            END.
            ELSE DO:
                IF i-pais-impto-usuario = 1 /* Brasil */ THEN DO:
                    DISP tt-embarque-corpo.vl-ger-mercado-rea
                         tt-embarque-corpo.per-ger-mercado-rea
                         WITH FRAME f-cab-realizado.
                END.
                ELSE DO:
                    DISP tt-embarque-corpo.vl-ger-mercado-rea
                         tt-embarque-corpo.per-ger-mercado-rea
                         tt-embarque-corpo.mo-ger-mercado-rea   
                         tt-embarque-corpo.vl-ger-mercado-rea-mo
                         WITH FRAME f-cab-realizado-int.
                END.
            END.
            
            IF  i-pais-impto-usuario = 1 /* Brasil */ THEN DO:
                IF tt-param.i-desp-imposto = 1 THEN DO: /* Despesa */
                    IF  tt-param.excel THEN DO: 
                        /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-895) */
                        // Se a funá∆o estiver ativa, e foi selecionado em tela para considerar os novos tributos, ent∆o imprime eles no lugar dos antigos.
                        IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-ipi-rea","dec",0,">>>,>>>,>>9.99",?,"IPI").     
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-ipi-rea","dec",0,?,?,"% IPI").
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-cbs-rea","dec",0,">>>,>>>,>>9.99",?,"CBS").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-cbs-rea","dec",0,?,?,"% CBS").
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-ibs-uf-rea","dec",0,">>>,>>>,>>9.99",?,"IBS UF").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-ibs-uf-rea","dec",0,?,?,"% IBS UF").
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-ibs-mun-rea","dec",0,">>>,>>>,>>9.99",?,"IBS Mun").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-ibs-mun-rea","dec",0,?,?,"% IBS Mun").
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-is-rea","dec",0,">>>,>>>,>>9.99",?,"IS").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-is-rea","dec",0,?,?,"% IS").
                        END.
                        /* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-895) */
                        ELSE DO:
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-ipi-rea","dec",0,">>>,>>>,>>9.99",?,"IPI").     
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-ipi-rea","dec",0,?,?,"% IPI").
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-pis-rea","dec",0,">>>,>>>,>>9.99",?,"PIS").       
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-pis-rea","dec",0,?,?,"% PIS").
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-cofins-rea","dec",0,">>>,>>>,>>9.99",?,"COFINS").       
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-cofins-rea","dec",0,?,?,"% COFINS").       
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-icms-rea","dec",0,">>>,>>>,>>9.99",?,"ICMS").       
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-icms-rea","dec",0,?,?,"% ICMS").       
                        END.
                    END.
                    ELSE DO: 
                        /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-820) */
                        // Se a funá∆o estiver ativa, e foi selecionado em tela para considerar os novos tributos, ent∆o imprime eles no lugar dos antigos.
                        IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                            DISP tt-embarque-corpo.vl-ger-ipi-rea
                                 tt-embarque-corpo.per-ger-ipi-rea
                                 tt-embarque-corpo.vl-ger-cbs-rea
                                 tt-embarque-corpo.per-ger-cbs-rea 
                                 tt-embarque-corpo.vl-ger-ibs-uf-rea
                                 tt-embarque-corpo.per-ger-ibs-uf-rea
                                 tt-embarque-corpo.vl-ger-ibs-mun-rea
                                 tt-embarque-corpo.per-ger-ibs-mun-rea
                                 tt-embarque-corpo.vl-ger-is-rea
                                 tt-embarque-corpo.per-ger-is-rea
                                 WITH FRAME f-ipi-cbs-ibs-realizado.
                        END.
                        /* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-820) */
                        ELSE DO:
                            // Caso contr†rio continua imprimindo como era anteriormente
                            DISP tt-embarque-corpo.vl-ger-ipi-rea
                                 tt-embarque-corpo.per-ger-ipi-rea
                                 tt-embarque-corpo.vl-ger-pis-rea
                                 tt-embarque-corpo.per-ger-pis-rea 
                                 tt-embarque-corpo.vl-ger-cofins-rea  
                                 tt-embarque-corpo.per-ger-cofins-rea 
                                 tt-embarque-corpo.vl-ger-icms-rea
                                 tt-embarque-corpo.per-ger-icms-rea
                                 WITH FRAME f-ipi-icms-realizado.
                        END.
                    END.
                END.
                ELSE DO: /* Imposto */
                    IF  tt-param.excel THEN DO:
                        /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-895) */
                        // Se a funá∆o estiver ativa, e foi selecionado em tela para considerar os novos tributos, ent∆o imprime eles no lugar dos antigos.
                        IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-ii-rea","dec",0,">>>,>>>,>>9.99",?,"II").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-ii-rea","dec",0,?,?,"% II").
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-ipi-rea","dec",0,">>>,>>>,>>9.99",?,"IPI").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-ipi-rea","dec",0,?,?,"% IPI"). 
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-cbs-rea","dec",0,">>>,>>>,>>9.99",?,"CBS").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-cbs-rea","dec",0,?,?,"% CBS").
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-ibs-uf-rea","dec",0,">>>,>>>,>>9.99",?,"IBS UF").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-ibs-uf-rea","dec",0,?,?,"% IBS UF").
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-ibs-mun-rea","dec",0,">>>,>>>,>>9.99",?,"IBS Mun").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-ibs-mun-rea","dec",0,?,?,"% IBS Mun").
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-is-rea","dec",0,">>>,>>>,>>9.99",?,"IS").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-is-rea","dec",0,?,?,"% IS").
                        END.
                        /* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-895) */
                        ELSE DO:
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-ii-rea","dec",0,">>>,>>>,>>9.99",?,"II").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-ii-rea","dec",0,?,?,"% II").   
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-ipi-rea","dec",0,">>>,>>>,>>9.99",?,"IPI").       
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-ipi-rea","dec",0,?,?,"% IPI").
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-pis-rea","dec",0,">>>,>>>,>>9.99",?,"PIS").       
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-pis-rea","dec",0,?,?,"% PIS").
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-cofins-rea","dec",0,">>>,>>>,>>9.99",?,"COFINS").       
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-cofins-rea","dec",0,?,?,"% COFINS").       
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-icms-rea","dec",0,">>>,>>>,>>9.99",?,"ICMS").       
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-icms-rea","dec",0,?,?,"% ICMS").                        
                        END.
                    END.
                    ELSE DO:
                        /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-820) */
                        // Se a funá∆o estiver ativa, e foi selecionado em tela para considerar os novos tributos, ent∆o imprime eles no lugar dos antigos.
                        IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                            DISP tt-embarque-corpo.vl-ger-ii-rea
                                 tt-embarque-corpo.per-ger-ii-rea
                                 tt-embarque-corpo.vl-ger-ipi-rea
                                 tt-embarque-corpo.per-ger-ipi-rea
                                 tt-embarque-corpo.vl-ger-cbs-rea
                                 tt-embarque-corpo.per-ger-cbs-rea 
                                 tt-embarque-corpo.vl-ger-ibs-uf-rea
                                 tt-embarque-corpo.per-ger-ibs-uf-rea
                                 tt-embarque-corpo.vl-ger-ibs-mun-rea
                                 tt-embarque-corpo.per-ger-ibs-mun-rea
                                 tt-embarque-corpo.vl-ger-is-rea
                                 tt-embarque-corpo.per-ger-is-rea
                                 WITH FRAME f-ipi-cbs-ibs-realizado2.
                        END.
                        /* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-820) */
                        ELSE DO:
                            // Caso contr†rio continua imprimindo como era anteriormente
                            DISP tt-embarque-corpo.vl-ger-ii-rea            
                                 tt-embarque-corpo.per-ger-ii-rea           
                                 tt-embarque-corpo.vl-ger-ipi-rea           
                                 tt-embarque-corpo.per-ger-ipi-rea          
                                 tt-embarque-corpo.vl-ger-pis-rea           
                                 tt-embarque-corpo.per-ger-pis-rea          
                                 tt-embarque-corpo.vl-ger-cofins-rea        
                                 tt-embarque-corpo.per-ger-cofins-rea       
                                 tt-embarque-corpo.vl-ger-icms-rea          
                                 tt-embarque-corpo.per-ger-icms-rea         
                                 WITH FRAME f-ipi-icms-realizado2.
                        END.
                    END.    
                END.
            END.
            ELSE DO:
			
				assign vl-impto-int    = 0
				       vl-impto-int-mo = 0.
					   
                FOR EACH tt-impto-internac
                    WHERE tt-impto-internac.embarque    = tt-embarque-corpo.embarque
                      AND tt-impto-internac.cod-estabel = tt-embarque-corpo.cod-estabel
					  break by tt-impto-internac.cdn-imposto:
					  
					assign vl-impto-int    = vl-impto-int    + tt-impto-internac.val-impto-moeda-relat
					       vl-impto-int-mo = vl-impto-int-mo + tt-impto-internac.val-impto-moeda-relat-mo.

                    if last-of(tt-impto-internac.cdn-imposto) then do:
						IF tt-param.excel THEN DO:
							tth-dados-excel:ADD-NEW-FIELD("c-" + replace(tt-impto-internac.descricao,chr(32),"-corpo-rea"),"dec",0,?,?,tt-impto-internac.descricao).
							tth-dados-excel:ADD-NEW-FIELD("c-perc-" + replace(tt-impto-internac.descricao,chr(32),"-corpo-rea"),"dec",0,?,?,"% " + tt-impto-internac.descricao).      

						END.
						ELSE DO:
							DISP tt-impto-internac.descricao
								 vl-impto-int @ tt-impto-internac.val-impto-moeda-relat
								 (vl-impto-int / tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea) * 100 @ tt-impto-internac.perc-impto                             
								 tt-impto-internac.mo-impto-moeda-relat    
								 vl-impto-int-mo @ tt-impto-internac.val-impto-moeda-relat-mo
								 WITH FRAME f-impto-internac.
							DOWN WITH FRAME f-impto-internac.
						END.
						
						assign vl-impto-int    = 0
							   vl-impto-int-mo = 0.
					end.
                    if last(tt-impto-internac.cdn-imposto) then do:
						IF tt-param.excel THEN DO:
						    {utp/ut-liter.i "Total Impostos" *} 
							tth-dados-excel:ADD-NEW-FIELD("c-total-imposto-internac-corpo-rea","dec",0,">>>,>>>,>>9.99",?,return-value).
						    {utp/ut-liter.i "% Total Impostos" *} 
							tth-dados-excel:ADD-NEW-FIELD("c-perc-total-imposto-internac-corpo-rea","dec",0,?,?,return-value).      
					    END.
					end.
                END.
            END.

            /* Total de Impostos */ 
            IF NOT tt-param.excel THEN do:
				/* duas frame iguais, mas necessarias devido a diferenca de format no campo de valor */
				IF  i-pais-impto-usuario <> 1 /* Brasil */ then
					disp tt-embarque-corpo.vl-ger-tot-imp-rea 
						 tt-embarque-corpo.per-ger-tot-imp-rea
						WITH FRAME f-tot-imp-realizado-int.
				else
					disp tt-embarque-corpo.vl-ger-tot-imp-rea
						 tt-embarque-corpo.per-ger-tot-imp-rea
						WITH FRAME f-tot-imp-realizado.
			END.
                               
            if tt-param.i-desp-imposto = 1 then /*Despesa*/
                IF tt-param.excel THEN DO:
                    IF i-pais-impto-usuario = 1 /* Brasil */ THEN DO:
                        tth-dados-excel:ADD-NEW-FIELD("vl-ger-ii2-rea","dec",0,">>>,>>>,>>9.99",?,"II").
                        tth-dados-excel:ADD-NEW-FIELD("per-ger-ii2-rea","dec",0,?,?,"% II").
                    END.
                    ELSE DO:
                        tth-dados-excel:ADD-NEW-FIELD("vl-ger-ii2-rea","dec",0,">>>,>>>,>>9.99",?,tt-embarque-corpo.desc-ger-ii2-rea).
                        tth-dados-excel:ADD-NEW-FIELD("per-ger-ii2-rea","dec",0,?,?,"% " + tt-embarque-corpo.desc-ger-ii2-rea).
                    END.

                END.
                ELSE DO:

                    IF i-pais-impto-usuario = 1 /* Brasil */ THEN DO:
                        disp tt-embarque-corpo.vl-ger-ii2-rea
                             tt-embarque-corpo.per-ger-ii2-rea
                             with frame f-despesa-realizado.
                    END.
                    ELSE DO:                        
                        {utp/ut-liter.i "NF Nacionalizaá∆o" *} 
                        ASSIGN c-origem = TRIM(RETURN-VALUE).

                        disp tt-embarque-corpo.desc-ger-ii2-rea
                             tt-embarque-corpo.vl-ger-ii2-rea
                             tt-embarque-corpo.per-ger-ii2-rea
                             tt-embarque-corpo.mo-ii2-rea
                             tt-embarque-corpo.vl-ger-ii2-rea-mo
                             c-origem
                             with frame f-despesa-realizado-int.
                    END.
                END.
            
            /* Impress∆o das despesas */
            for each tt-detalha-despesa-aux
               where tt-detalha-despesa-aux.embarque      = tt-embarque-corpo.embarque
                 and tt-detalha-despesa-aux.cod-estabel   = tt-embarque-corpo.cod-estabel
               break by tt-detalha-despesa-aux.cod-despesa:

                IF LAST-OF(tt-detalha-despesa-aux.cod-despesa) THEN DO:

                   IF i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
                       IF tt-detalha-despesa-aux.situacao = 3 /* Complementar */ THEN
                           {utp/ut-liter.i "NF Complementar" *}
                       ELSE 
                           {utp/ut-liter.i "NF Nacionalizaá∆o" *} 

                       ASSIGN c-origem = TRIM(RETURN-VALUE).
                   END.


                   IF tt-param.excel THEN DO:  
                       tth-dados-excel:ADD-NEW-FIELD("c-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-corpo-rea"),"dec",0,?,?,tt-detalha-despesa-aux.desc-despesa).   
                       tth-dados-excel:ADD-NEW-FIELD("c-perc-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-corpo-rea"),"dec",0,?,?,"% " + tt-detalha-despesa-aux.desc-despesa).   
                       
                       IF  i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
                           {utp/ut-liter.i "Origem" *}
                           tth-dados-excel:ADD-NEW-FIELD("c-origem-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-corpo-rea"),"CHAR",0,?,?,TRIM(RETURN-VALUE)).  
                       END.

                   END.
                   ELSE DO:

                       IF i-pais-impto-usuario = 1 /* Brasil */ THEN DO:
                           disp  tt-detalha-despesa-aux.desc-despesa
                                 tt-detalha-despesa-aux.vl-des-rea
                                 tt-detalha-despesa-aux.per-des-rea
                                 with frame f-det-desp-imp.
                            down with frame f-det-desp-imp.
                       END.
                       ELSE DO:                           
                           disp  tt-detalha-despesa-aux.desc-despesa
                                 tt-detalha-despesa-aux.vl-des-rea
                                 tt-detalha-despesa-aux.per-des-rea
                                 tt-detalha-despesa-aux.moeda-mo
                                 tt-detalha-despesa-aux.vl-des-rea-mo                                 
                                 c-origem
                                 with frame f-det-desp-imp-int.
                            down with frame f-det-desp-imp-int.
                       END.

                   END.
                   ASSIGN de-tot-desp = 0.
               END.
            end.
            
            /* Total */ 
            IF NOT tt-param.excel THEN
                disp tt-embarque-corpo.vl-ger-tot-des-rea
                     tt-embarque-corpo.per-ger-tot-des-rea
                     tt-embarque-corpo.vl-ger-tot-imp-des-rea
                     tt-embarque-corpo.per-ger-tot-imp-des-rea
                     tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea
                     tt-embarque-corpo.per-ger-tot-com-ipi-icms-rea
                     tt-embarque-corpo.vl-ger-tot-sem-ipi-icms-merc-rea
                     tt-embarque-corpo.per-ger-tot-sem-ipi-icms-rea
                     WITH FRAME f-tot-realizado.
        END.
        
        
    
        if  tt-param.l-orc-real then do: /*Oráado x Realizado*/
            IF tt-param.excel THEN DO:
                tth-dados-excel:ADD-NEW-FIELD("vl-ger-mercado-orc","dec",0,?,?,"Valor Merc (Oráado)").
                tth-dados-excel:ADD-NEW-FIELD("vl-ger-mercado-rea","dec",0,?,?,"Valor Merc (Realizado)").     
                tth-dados-excel:ADD-NEW-FIELD("per-ger-mercado-orc","dec",0,?,?,"% Vl Merc (Oráado)").
                tth-dados-excel:ADD-NEW-FIELD("per-ger-mercado-rea","dec",0,?,?,"% Vl Merc (Realizado)").
            END.
            ELSE DO:
                disp tt-embarque-corpo.vl-ger-mercado-orc
                     tt-embarque-corpo.per-ger-mercado-orc
                     tt-embarque-corpo.vl-ger-mercado-rea
                     tt-embarque-corpo.per-ger-mercado-rea
                     WITH FRAME f-cab-orc-real.
            END.
            /*IMPOSTOS*/
            if  tt-param.l-desp-imposto then do: /*Detalha Despesa-Imposto*/
                IF  tt-param.excel THEN DO: 
                    IF  tt-param.i-desp-imposto = 2 THEN DO: /*Imposto*/
                        tth-dados-excel:ADD-NEW-FIELD("vl-ger-ii-orc","dec",0,?,?,"II (Oráado)").
                        tth-dados-excel:ADD-NEW-FIELD("vl-ger-ii-rea","dec",0,?,?,"II (Realizado)").
                        tth-dados-excel:ADD-NEW-FIELD("per-ger-ii-orc","dec",0,?,?,"% II (Oráado)").   
                        tth-dados-excel:ADD-NEW-FIELD("per-ger-ii-rea","dec",0,?,?,"% II (Realizado)").
                    END.
                    IF  i-pais-impto-usuario = 1 /* Brasil */ THEN DO:
                        /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-895) */
                        IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-ipi-orc","dec",0,?,?,"IPI (Oráado)").       
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-ipi-rea","dec",0,?,?,"IPI (Realizado)").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-ipi-orc","dec",0,?,?,"% IPI (Oráado)").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-ipi-rea","dec",0,?,?,"% IPI (Realizado)"). 
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-cbs-orc","dec",0,?,?,"CBS (Oráado)").       
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-cbs-rea","dec",0,?,?,"CBS (Realizado)").  
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-cbs-orc","dec",0,?,?,"% CBS (Oráado)").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-cbs-rea","dec",0,?,?,"% CBS (Realizado)").
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-ibs-uf-orc","dec",0,?,?,"IBS UF (Oráado)").       
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-ibs-uf-rea","dec",0,?,?,"IBS UF (Realizado)").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-ibs-uf-orc","dec",0,?,?,"% IBS UF (Oráado)").       
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-ibs-uf-rea","dec",0,?,?,"% IBS UF (Realizado)").
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-ibs-mun-orc","dec",0,?,?,"IBS Mun (Oráado)").
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-ibs-mun-rea","dec",0,?,?,"IBS Mun (Realizado)").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-ibs-mun-orc","dec",0,?,?,"% IBS Mun (Oráado)").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-ibs-mun-rea","dec",0,?,?,"% IBS Mun (Realizado)").
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-is-orc","dec",0,?,?,"IS (Oráado)").
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-is-rea","dec",0,?,?,"IS (Realizado)").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-is-orc","dec",0,?,?,"% IS (Oráado)").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-is-rea","dec",0,?,?,"% IS (Realizado)").
                        END.
                        /* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-895) */
                        ELSE DO:
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-ipi-orc","dec",0,?,?,"IPI (Oráado)").       
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-ipi-rea","dec",0,?,?,"IPI (Realizado)").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-ipi-orc","dec",0,?,?,"% IPI (Oráado)").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-ipi-rea","dec",0,?,?,"% IPI (Realizado)"). 
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-pis-orc","dec",0,?,?,"PIS (Oráado)").       
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-pis-rea","dec",0,?,?,"PIS (Realizado)").  
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-pis-orc","dec",0,?,?,"% PIS (Oráado)").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-pis-rea","dec",0,?,?,"% PIS (Realizado)").
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-cofins-orc","dec",0,?,?,"COFINS (Oráado)").       
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-cofins-rea","dec",0,?,?,"COFINS (Realizado)").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-cofins-orc","dec",0,?,?,"% COFINS (Oráado)").       
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-cofins-rea","dec",0,?,?,"% COFINS (Realizado)").
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-icms-orc","dec",0,?,?,"ICMS (Oráado)").
                            tth-dados-excel:ADD-NEW-FIELD("vl-ger-icms-rea","dec",0,?,?,"ICMS (Realizado)").
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-icms-orc","dec",0,?,?,"% ICMS (Oráado)").       
                            tth-dados-excel:ADD-NEW-FIELD("per-ger-icms-rea","dec",0,?,?,"% ICMS (Realizado)").
                        END.    
                    END.
                END.
                ELSE DO: 
                    disp tt-embarque-corpo.vl-ger-ii-orc
                         tt-embarque-corpo.per-ger-ii-orc
                         tt-embarque-corpo.vl-ger-ii-rea
                         tt-embarque-corpo.per-ger-ii-rea
                         WITH FRAME f-imposto.
                
                    /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-820) */
                    // Se a funá∆o estiver ativa, e foi selecionado em tela para considerar os novos tributos, ent∆o imprime eles no lugar dos antigos.
                    IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                        DISP tt-embarque-corpo.vl-ger-ipi-orc
                             tt-embarque-corpo.per-ger-ipi-orc
                             tt-embarque-corpo.vl-ger-ipi-rea
                             tt-embarque-corpo.per-ger-ipi-rea
                             tt-embarque-corpo.vl-ger-cbs-orc
                             tt-embarque-corpo.per-ger-cbs-orc
                             tt-embarque-corpo.vl-ger-cbs-rea
                             tt-embarque-corpo.per-ger-cbs-rea
                             tt-embarque-corpo.vl-ger-ibs-uf-orc
                             tt-embarque-corpo.per-ger-ibs-uf-orc
                             tt-embarque-corpo.vl-ger-ibs-uf-rea
                             tt-embarque-corpo.per-ger-ibs-uf-rea
                             tt-embarque-corpo.vl-ger-ibs-mun-orc
                             tt-embarque-corpo.per-ger-ibs-mun-orc
                             tt-embarque-corpo.vl-ger-ibs-mun-rea
                             tt-embarque-corpo.per-ger-ibs-mun-rea
                             tt-embarque-corpo.vl-ger-is-orc
                             tt-embarque-corpo.per-ger-is-orc
                             tt-embarque-corpo.vl-ger-is-rea
                             tt-embarque-corpo.per-ger-is-rea
                             WITH FRAME f-ipi-cbs-ibs.
                    END.
                    /* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-820) */
                    ELSE DO:
                        DISP tt-embarque-corpo.vl-ger-ipi-orc
                             tt-embarque-corpo.per-ger-ipi-orc
                             tt-embarque-corpo.vl-ger-ipi-rea
                             tt-embarque-corpo.per-ger-ipi-rea
                             tt-embarque-corpo.vl-ger-pis-orc
                             tt-embarque-corpo.per-ger-pis-orc
                             tt-embarque-corpo.vl-ger-pis-rea
                             tt-embarque-corpo.per-ger-pis-rea
                             tt-embarque-corpo.vl-ger-cofins-orc
                             tt-embarque-corpo.per-ger-cofins-orc
                             tt-embarque-corpo.vl-ger-cofins-rea
                             tt-embarque-corpo.per-ger-cofins-rea
                             tt-embarque-corpo.vl-ger-icms-orc
                             tt-embarque-corpo.per-ger-icms-orc
                             tt-embarque-corpo.vl-ger-icms-rea
                             tt-embarque-corpo.per-ger-icms-rea
                             WITH FRAME f-ipi-icms.
                    END.
                END.
            end.
            IF NOT tt-param.excel THEN 
                disp tt-embarque-corpo.vl-ger-tot-imp-orc
                     tt-embarque-corpo.per-ger-tot-imp-orc
                     tt-embarque-corpo.vl-ger-tot-imp-rea
                     tt-embarque-corpo.per-ger-tot-imp-rea
                     WITH FRAME f-tot-imp.
              
            /*DESPESAS*/
            if  tt-param.l-desp-imposto then do: /*Detalha Despesa-Imposto*/
                if  tt-param.i-desp-imposto = 1 then do: /*Despesa*/ 

                    IF tt-param.excel THEN DO:
                        tth-dados-excel:ADD-NEW-FIELD("vl-ger-ii2-orc","dec",0,?,?,"II (Oráado)").
                        tth-dados-excel:ADD-NEW-FIELD("vl-ger-ii2-rea","dec",0,?,?,"II (Realizado)").
                        tth-dados-excel:ADD-NEW-FIELD("per-ger-ii2-orc","dec",0,?,?,"% II (Oráado)").   
                        tth-dados-excel:ADD-NEW-FIELD("per-ger-ii2-rea","dec",0,?,?,"% II (Realizado)").   
                    END.
                    ELSE
                        disp tt-embarque-corpo.vl-ger-ii2-orc
                             tt-embarque-corpo.per-ger-ii2-orc
                             tt-embarque-corpo.vl-ger-ii2-rea
                             tt-embarque-corpo.per-ger-ii2-rea
                             with frame f-despesa.
    
                    for each tt-detalha-despesa-aux
                       where tt-detalha-despesa-aux.embarque      = tt-embarque-corpo.embarque
                         and tt-detalha-despesa-aux.cod-estabel   = tt-embarque-corpo.cod-estabel
                       break by tt-detalha-despesa-aux.cod-despesa:
    
                       ASSIGN de-tot-desp = de-tot-desp + tt-detalha-despesa-aux.vl-des-rea .
    
                       IF LAST-OF(tt-detalha-despesa-aux.cod-despesa) THEN DO:
                           IF tt-param.excel THEN DO:  
                               tth-dados-excel:ADD-NEW-FIELD("co-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-orc-corpo"),"dec",0,?,?,tt-detalha-despesa-aux.desc-despesa + " (Oráado)").   
                               tth-dados-excel:ADD-NEW-FIELD("c-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-rea-corpo"),"dec",0,?,?,tt-detalha-despesa-aux.desc-despesa + " (Realizado)").   
                               tth-dados-excel:ADD-NEW-FIELD("co-perc-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-orc-corpo"),"dec",0,?,?,"% " + tt-detalha-despesa-aux.desc-despesa + " (Oráado)").   
                               tth-dados-excel:ADD-NEW-FIELD("c-perc-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-rea-corpo"),"dec",0,?,?,"% " + tt-detalha-despesa-aux.desc-despesa + " (Realizado)").   
                           END.
                           ELSE DO:
                                disp tt-detalha-despesa-aux.desc-despesa
                                     tt-detalha-despesa-aux.vl-des-orc
                                     tt-detalha-despesa-aux.per-des-orc
                                     de-tot-desp @ tt-detalha-despesa-aux.vl-des-rea 
                                     tt-detalha-despesa-aux.per-des-rea
                                     with frame f-det-desp-i2.
                                down with frame f-det-desp-i2.
                           END.
                           ASSIGN de-tot-desp = 0.
                       END.
                    end.
                END.
                ELSE DO: /*Imposto*/
                    for each tt-detalha-despesa-aux
                       where tt-detalha-despesa-aux.embarque      = tt-embarque-corpo.embarque
                         and tt-detalha-despesa-aux.cod-estabel   = tt-embarque-corpo.cod-estabel
                         AND tt-detalha-despesa-aux.vl-des-rea    <> tt-embarque-corpo.vl-ger-ii-rea
                       break by tt-detalha-despesa-aux.cod-despesa:
        
                       IF LAST-OF(tt-detalha-despesa-aux.cod-desp) THEN DO:
                           IF tt-param.excel THEN DO:  

                               tth-dados-excel:ADD-NEW-FIELD("co-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-orc-corpo"),"dec",0,?,?,tt-detalha-despesa-aux.desc-despesa + " (Oráado)").   
                               tth-dados-excel:ADD-NEW-FIELD("c-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-rea-corpo"),"dec",0,?,?,tt-detalha-despesa-aux.desc-despesa + " (Realizado)").   
                               tth-dados-excel:ADD-NEW-FIELD("co-perc-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-orc-corpo"),"dec",0,?,?,"% " + tt-detalha-despesa-aux.desc-despesa + " (Oráado)").   
                               tth-dados-excel:ADD-NEW-FIELD("c-perc-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-rea-corpo"),"dec",0,?,?,"% " + tt-detalha-despesa-aux.desc-despesa + " (Realizado)").   
                           END.
                           ELSE DO:
                               disp tt-detalha-despesa-aux.desc-despesa
                                    tt-detalha-despesa-aux.vl-des-orc
                                    tt-detalha-despesa-aux.per-des-orc
                                    tt-detalha-despesa-aux.vl-des-rea 
                                    tt-detalha-despesa-aux.per-des-rea
                                    with frame f-det-desp-i2.
                               down with frame f-det-desp-i2.
                               ASSIGN de-tot-desp = 0.
                           END.
                       END.
                    end.
                END.
            end.
            IF NOT tt-param.excel THEN
                disp tt-embarque-corpo.vl-ger-tot-des-orc
                     tt-embarque-corpo.per-ger-tot-des-orc
                     tt-embarque-corpo.vl-ger-tot-des-rea
                     tt-embarque-corpo.per-ger-tot-des-rea
                     tt-embarque-corpo.vl-ger-tot-imp-des-orc
                     tt-embarque-corpo.per-ger-tot-imp-des-orc
                     tt-embarque-corpo.vl-ger-tot-imp-des-rea
                     tt-embarque-corpo.per-ger-tot-imp-des-rea
                     tt-embarque-corpo.vl-ger-tot-com-ipi-icms-orc
                     tt-embarque-corpo.per-ger-tot-com-ipi-icms-orc
                     tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea
                     tt-embarque-corpo.per-ger-tot-com-ipi-icms-rea
                     tt-embarque-corpo.vl-ger-tot-sem-ipi-icms-orc
                     tt-embarque-corpo.per-ger-tot-sem-ipi-icms-orc
                     tt-embarque-corpo.vl-ger-tot-sem-ipi-icms-merc-rea
                     tt-embarque-corpo.per-ger-tot-sem-ipi-icms-rea
                     WITH FRAME f-tot-orc-real.
        end.
    
        if  tt-param.l-itens then do: /*Detalha Item*/
            for each  tt-detalha-item
                where tt-detalha-item.embarque     = tt-embarque-corpo.embarque
                  and tt-detalha-item.cod-estabel  = tt-embarque-corpo.cod-estabel
                use-index ch-codigo:
                
                IF tt-param.excel THEN DO: 

                    CREATE tt-dados-excel-detail.
                    BUFFER-COPY tt-dados-excel TO tt-dados-excel-detail.
                    ASSIGN tt-dados-excel-detail.des-emit            = tt-embarque-cabec.desc-emit
                           tt-dados-excel-detail.des-via-transp      = {adinc/i01ad268.i 04 tt-embarque-cabec.cod-via-transp}
                           tt-dados-excel-detail.nr-di               = tt-embarque-corpo.nr-di
                           tt-dados-excel-detail.dt-di               = tt-embarque-corpo.dt-di
                           tt-dados-excel-detail.sequencia           = tt-detalha-item.sequencia
                           tt-dados-excel-detail.it-codigo           = tt-detalha-item.it-codigo  
                           tt-dados-excel-detail.descricao           = tt-detalha-item.descricao
                           tt-dados-excel-detail.quantidade          = tt-detalha-item.quantidade 
                           tt-dados-excel-detail.un                  = tt-detalha-item.un.
                    
                    IF  tt-param.l-orc-real then do: /*Oráado x Realizado*/
                        tth-dados-excel-detail:ADD-NEW-FIELD("vl-mercado-orc","dec",0,">>>,>>>,>>9.99999",?,"Valor Merc (Oráado)").       
                        tth-dados-excel-detail:ADD-NEW-FIELD("vl-mercado-rea","dec",0,">>>,>>>,>>9.99999",?,"Valor Merc (Realizado)").       
                        tth-dados-excel-detail:ADD-NEW-FIELD("per-mercado-orc","dec",0,?,?,"% Vl Merc (Oráado)").
                        tth-dados-excel-detail:ADD-NEW-FIELD("per-mercado-rea","dec",0,?,?,"% Vl Merc (Realizado)").

                        IF tt-param.l-desp-imposto THEN DO:
                            if  tt-param.i-desp-imposto = 2 THEN DO: /*Imposto*/
                                tth-dados-excel-detail:ADD-NEW-FIELD("vl-ii-orc","dec",0,">>>,>>>,>>9.99999",?,"II (Oráado)").       
                                tth-dados-excel-detail:ADD-NEW-FIELD("vl-ii-rea","dec",0,">>>,>>>,>>9.99999",?,"II (Realizado)").          
                                tth-dados-excel-detail:ADD-NEW-FIELD("per-ii-orc","dec",0,?,?,"% II (Oráado)").
                                tth-dados-excel-detail:ADD-NEW-FIELD("per-ii-rea","dec",0,?,?,"% II (realizado)").
                            END.

                            IF  i-pais-impto-usuario = 1 /* Brasil */ THEN DO:
                                /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-895) */
                                IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-ipi-orc","dec",0,">>>,>>>,>>9.99999",?,"IPI (Oráado)").       
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-ipi-rea","dec",0,">>>,>>>,>>9.99999",?,"IPI (Realizado)").
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-ipi-orc","dec",0,?,?,"% IPI (Oráado)").
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-ipi-rea","dec",0,?,?,"% IPI (Realizado)"). 
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-cbs-orc","dec",0,">>>,>>>,>>9.99999",?,"CBS (Oráado)").       
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-cbs-rea","dec",0,">>>,>>>,>>9.99999",?,"CBS (Realizado)").  
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-cbs-orc","dec",0,?,?,"% CBS (Oráado)").
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-cbs-rea","dec",0,?,?,"% CBS (Realizado)").
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-ibs-uf-orc","dec",0,">>>,>>>,>>9.99999",?,"IBS UF (Oráado)").       
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-ibs-uf-rea","dec",0,">>>,>>>,>>9.99999",?,"IBS UF (Realizado)").
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-ibs-uf-orc","dec",0,?,?,"% IBS UF (Oráado)").       
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-ibs-uf-rea","dec",0,?,?,"% IBS UF (Realizado)").
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-ibs-mun-orc","dec",0,">>>,>>>,>>9.99999",?,"IBS Mun (Oráado)").
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-ibs-mun-rea","dec",0,">>>,>>>,>>9.99999",?,"IBS Mun (Realizado)").
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-ibs-mun-orc","dec",0,?,?,"% IBS Mun (Oráado)").
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-ibs-mun-rea","dec",0,?,?,"% IBS Mun (Realizado)").  
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-is-orc","dec",0,">>>,>>>,>>9.99999",?,"IS (Oráado)").
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-is-rea","dec",0,">>>,>>>,>>9.99999",?,"IS (Realizado)").
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-is-orc","dec",0,?,?,"% IS (Oráado)").
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-is-rea","dec",0,?,?,"% IS (Realizado)").
                                END.
                                /* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-895) */
                                ELSE DO:
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-ipi-orc","dec",0,">>>,>>>,>>9.99999",?,"IPI (Oráado)").  
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-ipi-rea","dec",0,">>>,>>>,>>9.99999",?,"IPI (Realizado)").       
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-ipi-orc","dec",0,?,?,"% IPI (Oráado)").                     
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-ipi-rea","dec",0,?,?,"% IPI (Realizado)").                     
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-pis-orc","dec",0,">>>,>>>,>>9.99999",?,"PIS (Oráado)").      
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-pis-rea","dec",0,">>>,>>>,>>9.99999",?,"PIS (Realizado)").      
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-pis-orc","dec",0,?,?,"% PIS (Oráado)").                     
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-pis-rea","dec",0,?,?,"% PIS (Realizado)").                     
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-cofins-orc","dec",0,">>>,>>>,>>9.99999",?,"COFINS (Oráado)").
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-cofins-rea","dec",0,">>>,>>>,>>9.99999",?,"COFINS (Realizado)").
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-cofins-orc","dec",0,?,?,"% COFINS (Oráado)").               
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-cofins-rea","dec",0,?,?,"% COFINS (Realizado)").               
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-icms-orc","dec",0,">>>,>>>,>>9.99999",?,"ICMS (Oráado)").    
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-icms-rea","dec",0,">>>,>>>,>>9.99999",?,"ICMS (Realizado)").    
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-icms-orc","dec",0,?,?,"% ICMS (Oráado)").                   
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-icms-rea","dec",0,?,?,"% ICMS (Realizado)").  
                                END.
                            END.
    
                            if  tt-param.i-desp-imposto = 1 THEN DO: /*Despesa*/
                                tth-dados-excel-detail:ADD-NEW-FIELD("vl-ii2-orc","dec",0,">>>,>>>,>>9.99999",?,"II (Oráado)").       
                                tth-dados-excel-detail:ADD-NEW-FIELD("vl-ii2-rea","dec",0,">>>,>>>,>>9.99999",?,"II (Realizado)").       
                                tth-dados-excel-detail:ADD-NEW-FIELD("per-ii2-orc","dec",0,?,?,"% II (Oráado)").
                                tth-dados-excel-detail:ADD-NEW-FIELD("per-ii2-rea","dec",0,?,?,"% II (realizado)").
                            END.
                        
                            FOR EACH  tt-detalha-despesa
                                where tt-detalha-despesa.numero-ordem = tt-detalha-item.numero-ordem
                                  and tt-detalha-despesa.embarque     = tt-detalha-item.embarque
                                  and tt-detalha-despesa.cod-estabel  = tt-detalha-item.cod-estabel
                                  and tt-detalha-despesa.it-codigo    = tt-detalha-item.it-codigo
                                  and tt-detalha-despesa.sequencia    = tt-detalha-item.sequencia
                                break by tt-detalha-despesa.cod-despesa:                                                                

                                IF LAST-OF(tt-detalha-despesa.cod-despesa) THEN DO:
                                    tth-dados-excel-detail:ADD-NEW-FIELD("co-" + REPLACE(tt-detalha-despesa.desc-despesa,CHR(32),"-item-orc"),"dec",0,">>>,>>>,>>9.99999",?,tt-detalha-despesa.desc-despesa + " (Oráado)").   
                                    tth-dados-excel-detail:ADD-NEW-FIELD("c-" + REPLACE(tt-detalha-despesa.desc-despesa,CHR(32),"-item-rea"),"dec",0,">>>,>>>,>>9.99999",?,tt-detalha-despesa.desc-despesa + " (Realizado)").   
                                    tth-dados-excel-detail:ADD-NEW-FIELD("co-perc-" + REPLACE(tt-detalha-despesa.desc-despesa,CHR(32),"-item-orc"),"dec",0,?,?,"% " + tt-detalha-despesa.desc-despesa + " (Oráado)").   
                                    tth-dados-excel-detail:ADD-NEW-FIELD("c-perc-" + REPLACE(tt-detalha-despesa.desc-despesa,CHR(32),"-item-rea"),"dec",0,?,?,"% " + tt-detalha-despesa.desc-despesa + " (Realizado)").   
                                END.
                            END.
                        END.
                    END.
                    ELSE DO:
                        IF tt-param.l-desp-imposto THEN DO:

                            tth-dados-excel-detail:ADD-NEW-FIELD("vl-mercado-rea","dec",0,">>>,>>>,>>9.99999",?,"Valor Merc").       
                            tth-dados-excel-detail:ADD-NEW-FIELD("per-mercado-rea","dec",0,?,?,"% Vl Merc").

                            IF  tt-param.i-desp-imposto = 2 THEN DO: /*Imposto*/
                                IF  i-pais-impto-usuario = 1 /* Brasil */ THEN DO:
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-ii-rea","dec",0,">>>,>>>,>>9.99999",?,"II").       
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-ii-rea","dec",0,?,?,"% II").
                                END.
                            END.

                            IF  i-pais-impto-usuario = 1 /* Brasil */ THEN DO:
                                /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-895) */
                                IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-ipi-rea","dec",0,">>>,>>>,>>9.99999",?,"IPI").
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-ipi-rea","dec",0,?,?,"% IPI"). 
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-cbs-rea","dec",0,">>>,>>>,>>9.99999",?,"CBS").  
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-cbs-rea","dec",0,?,?,"% CBS").
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-ibs-uf-rea","dec",0,">>>,>>>,>>9.99999",?,"IBS UF").
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-ibs-uf-rea","dec",0,?,?,"% IBS UF").
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-ibs-mun-rea","dec",0,">>>,>>>,>>9.99999",?,"IBS Mun").
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-ibs-mun-rea","dec",0,?,?,"% IBS Mun").
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-is-rea","dec",0,">>>,>>>,>>9.99999",?,"IS").
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-is-rea","dec",0,?,?,"% IS").                                    
                                END.
                                /* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-895) */
                                ELSE DO:
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-ipi-rea","dec",0,">>>,>>>,>>9.99999",?,"IPI").       
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-ipi-rea","dec",0,?,?,"% IPI").
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-pis-rea","dec",0,">>>,>>>,>>9.99999",?,"PIS").       
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-pis-rea","dec",0,?,?,"% PIS").
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-cofins-rea","dec",0,">>>,>>>,>>9.99999",?,"COFINS").       
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-cofins-rea","dec",0,?,?,"% COFINS").       
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-icms-rea","dec",0,">>>,>>>,>>9.99999",?,"ICMS").       
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-icms-rea","dec",0,?,?,"% ICMS").   
                                END.
                             END.

                            if  tt-param.i-desp-imposto = 1 THEN DO: /*Despesa*/
                                IF i-pais-impto-usuario = 1 /* Brasil */ THEN DO:
                                    tth-dados-excel-detail:ADD-NEW-FIELD("vl-ii2-rea","dec",0,">>>,>>>,>>9.99999",?,"II").       
                                    tth-dados-excel-detail:ADD-NEW-FIELD("per-ii2-rea","dec",0,?,?,"% II").
                                END.
                                ELSE DO:
                                   tth-dados-excel-detail:ADD-NEW-FIELD("vl-ii2-rea","dec",0,">>>,>>>,>>9.99999",?,tt-embarque-corpo.desc-ger-ii2-rea).       
                                   tth-dados-excel-detail:ADD-NEW-FIELD("per-ii2-rea","dec",0,?,?,"% " + tt-embarque-corpo.desc-ger-ii2-rea).
                                END.
                            END.
                        END.    
                    
                        IF tt-param.l-desp-imposto THEN DO:
                            for each  tt-detalha-despesa
                                where tt-detalha-despesa.numero-ordem = tt-detalha-item.numero-ordem
                                and tt-detalha-despesa.embarque     = tt-detalha-item.embarque
                                and tt-detalha-despesa.cod-estabel  = tt-detalha-item.cod-estabel
                                and tt-detalha-despesa.it-codigo    = tt-detalha-item.it-codigo
                                and tt-detalha-despesa.sequencia    = tt-detalha-item.sequencia
                                break by tt-detalha-despesa.cod-despesa:                                                                

                                IF LAST-OF(tt-detalha-despesa.cod-despesa) THEN DO:
                                    tth-dados-excel-detail:ADD-NEW-FIELD("c-" + REPLACE(tt-detalha-despesa.desc-despesa,CHR(32),"-item-rea"),"dec",0,">>>,>>>,>>9.99999",?,tt-detalha-despesa.desc-despesa).   
                                    tth-dados-excel-detail:ADD-NEW-FIELD("c-perc-" + REPLACE(tt-detalha-despesa.desc-despesa,CHR(32),"-item-rea"),"dec",0,?,?,"% " + tt-detalha-despesa.desc-despesa).   
                                 END.
                            END.
                             
                        END.
                    END.
                END.   
                ELSE DO:
    	            IF i-pais-impto-usuario = 21 THEN DO:

	                    ASSIGN tt-detalha-item.vl-mercado-rea       = ROUND(tt-detalha-item.vl-mercado-rea,2)       
	                           tt-detalha-item.vl-mercado-rea-total = ROUND(tt-detalha-item.vl-mercado-rea-total,2). 
                
	                    disp tt-detalha-item.it-codigo
	                         tt-detalha-item.descricao
	                         tt-detalha-item.quantidade
	                         tt-detalha-item.un
	                         tt-detalha-item.vl-mercado-rea
	                         tt-detalha-item.vl-mercado-rea-total
	                         WITH FRAME f-det-item-equador.
	                    down with frame f-det-item-equador.
    	            END.
	                ELSE DO:
						disp tt-detalha-item.it-codigo
							 tt-detalha-item.descricao
							 tt-detalha-item.quantidade
							 tt-detalha-item.un
							 WITH FRAME f-det-item.
						down with frame f-det-item.
		            END.
                END.
               
                IF tt-param.i-custo-item = 2 THEN
                    RUN pi-altera-formato.

                if NOT tt-param.excel AND tt-param.l-orc-real then do: /*Oráado x Realizado*/
                    put skip(1).

                    disp tt-detalha-item.vl-mercado-orc   
                         tt-detalha-item.per-mercado-orc
                         tt-detalha-item.vl-mercado-rea   
                         tt-detalha-item.per-mercado-rea
                         WITH FRAME f-cab-orc-real-i.
            
                    /*IMPOSTOS*/
                    IF tt-param.l-desp-imposto then do: /*Detalha Despesa-Imposto*/
                        if  tt-param.i-desp-imposto = 2 then  /*Imposto*/
                            disp tt-detalha-item.aliquota-ii
                                 tt-detalha-item.vl-ii-orc   
                                 tt-detalha-item.per-ii-orc
                                 tt-detalha-item.vl-ii-rea   
                                 tt-detalha-item.per-ii-rea
                                 WITH FRAME f-imposto-i.        
                        
                        /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-820) */
                        // Se a funá∆o estiver ativa, e foi selecionado em tela para considerar os novos tributos, ent∆o imprime eles no lugar dos antigos.
                        IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                            DISP tt-detalha-item.aliquota-ipi
                                 tt-detalha-item.vl-ipi-orc   
                                 tt-detalha-item.per-ipi-orc
                                 tt-detalha-item.vl-ipi-rea  
                                 tt-detalha-item.per-ipi-rea
                                 tt-detalha-item.aliquota-cbs
                                 tt-detalha-item.vl-cbs-orc
                                 tt-detalha-item.per-cbs-orc
                                 tt-detalha-item.vl-cbs-rea
                                 tt-detalha-item.per-cbs-rea
                                 tt-detalha-item.aliquota-ibs-uf
                                 tt-detalha-item.vl-ibs-uf-orc
                                 tt-detalha-item.per-ibs-uf-orc
                                 tt-detalha-item.vl-ibs-uf-rea
                                 tt-detalha-item.per-ibs-uf-rea
                                 tt-detalha-item.aliquota-ibs-mun
                                 tt-detalha-item.vl-ibs-mun-orc
                                 tt-detalha-item.per-ibs-mun-orc
                                 tt-detalha-item.vl-ibs-mun-rea
                                 tt-detalha-item.per-ibs-mun-rea
                                 tt-detalha-item.aliquota-is
                                 tt-detalha-item.vl-is-orc
                                 tt-detalha-item.per-is-orc
                                 tt-detalha-item.vl-is-rea
                                 tt-detalha-item.per-is-rea
                                 WITH FRAME f-ipi-cbs-ibs-i.
                        END.
                        /* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-820) */
                        ELSE DO:
                            DISP tt-detalha-item.aliquota-ipi
                                 tt-detalha-item.vl-ipi-orc   
                                 tt-detalha-item.per-ipi-orc
                                 tt-detalha-item.vl-ipi-rea  
                                 tt-detalha-item.per-ipi-rea
                                 tt-detalha-item.aliquota-pis 
                                 tt-detalha-item.vl-pis-orc    
                                 tt-detalha-item.per-pis-orc  
                                 tt-detalha-item.vl-pis-rea    
                                 tt-detalha-item.per-pis-rea    
                                 tt-detalha-item.aliquota-COFINS
                                 tt-detalha-item.vl-COFINS-orc  
                                 tt-detalha-item.per-COFINS-orc 
                                 tt-detalha-item.vl-COFINS-rea  
                                 tt-detalha-item.per-COFINS-rea 
                                 tt-detalha-item.aliquota-icms
                                 tt-detalha-item.vl-icms-orc
                                 tt-detalha-item.per-icms-orc
                                 tt-detalha-item.vl-icms-rea
                                 tt-detalha-item.per-icms-rea
                                 WITH FRAME f-ipi-icm-i.
                        END.
                    end.
                    
                    disp tt-detalha-item.vl-tot-imp-orc
                         tt-detalha-item.per-tot-imp-orc
                         tt-detalha-item.vl-tot-imp-rea
                         tt-detalha-item.per-tot-imp-rea
                         WITH FRAME f-tot-imp-i.
            
                    /*DESPESAS*/
                    if  tt-param.l-desp-imposto then do: /*Detalha Despesa-Imposto*/
                        
                        if  tt-param.i-desp-imposto = 1 then /*Despesa*/
                            disp tt-detalha-item.aliquota-ii2
                                 tt-detalha-item.vl-ii2-orc
                                 tt-detalha-item.per-ii2-orc
                                 tt-detalha-item.vl-ii2-rea
                                 tt-detalha-item.per-ii2-rea
                                 WITH FRAME f-despesa-i.
            
                        for each  tt-detalha-despesa
                            where tt-detalha-despesa.numero-ordem = tt-detalha-item.numero-ordem
                              and tt-detalha-despesa.embarque     = tt-detalha-item.embarque
                              and tt-detalha-despesa.cod-estabel  = tt-detalha-item.cod-estabel
                              and tt-detalha-despesa.it-codigo    = tt-detalha-item.it-codigo
                              and tt-detalha-despesa.sequencia    = tt-detalha-item.sequencia
                            break by tt-detalha-despesa.cod-despesa:
                            
                            ASSIGN de-tot-desp = de-tot-desp + tt-detalha-despesa.vl-des-rea.
                            IF LAST-OF(tt-detalha-despesa.cod-despesa) THEN DO:
                                disp tt-detalha-despesa.desc-despesa
                                     tt-detalha-despesa.vl-des-orc
                                     tt-detalha-despesa.per-des-orc
                                     de-tot-desp @ tt-detalha-despesa.vl-des-rea
                                     tt-detalha-despesa.per-des-rea
                                     with frame f-det-desp-i.
                                down with frame f-det-desp-i.
                                ASSIGN de-tot-desp = 0.
                                
                            END.
                        end.
                    end.
                    
                    disp tt-detalha-item.vl-tot-des-orc
                         tt-detalha-item.per-tot-des-orc
                         tt-detalha-item.vl-tot-des-rea
                         tt-detalha-item.per-tot-des-rea
                         tt-detalha-item.vl-tot-imp-des-orc
                         tt-detalha-item.per-tot-imp-des-orc
                         tt-detalha-item.vl-tot-imp-des-rea
                         tt-detalha-item.per-tot-imp-des-rea
                         tt-detalha-item.vl-tot-com-ipi-icms-orc-total
                         tt-detalha-item.per-tot-com-ipi-icms-orc
                         tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea
                         tt-detalha-item.per-tot-com-ipi-icms-rea
                         tt-detalha-item.vl-tot-sem-ipi-icms-orc-total
                         tt-detalha-item.per-tot-sem-ipi-icms-orc
                         tt-detalha-item.vl-tot-sem-ipi-icms-dsp-merc-rea
                         tt-detalha-item.per-tot-sem-ipi-icms-rea
                         WITH FRAME f-tot-orc-real-i.
                end.
    
                if NOT tt-param.excel AND l-itens and l-orc-real then
                    put skip(1).
            END.
            IF NOT tt-param.excel THEN
                put skip(1).
        end.
        PAGE.
    end.
	end.
END.

IF tt-param.excel THEN DO:
    {utp/ut-liter.i Total_Impostos/Despesas_(Oráado)}
    tth-dados-excel:ADD-NEW-FIELD("vl-ger-tot-imp-des-orc","dec",0,">>>,>>>,>>9.99",?,RETURN-VALUE).
    {utp/ut-liter.i Total_Impostos/Despesas_(Realizado)}
    tth-dados-excel:ADD-NEW-FIELD("vl-ger-tot-imp-des-rea","dec",0,">>>,>>>,>>9.99",?,RETURN-VALUE).

    {utp/ut-liter.i %_Total_Impostos/Despesas_(Oráado)}
    tth-dados-excel:ADD-NEW-FIELD("per-ger-tot-imp-des-orc","dec",0,?,?,RETURN-VALUE).
    {utp/ut-liter.i %_Total_Impostos/Despesas_(Realizado)}
    tth-dados-excel:ADD-NEW-FIELD("per-ger-tot-imp-des-rea","dec",0,?,?,RETURN-VALUE).

    {utp/ut-liter.i Total_Geral_(Oráado)}
    tth-dados-excel:ADD-NEW-FIELD("vl-ger-tot-com-ipi-icms-orc","dec",0,">>>,>>>,>>9.99",?,RETURN-VALUE).
    {utp/ut-liter.i Total_Geral_(Realizado)}
    tth-dados-excel:ADD-NEW-FIELD("vl-ger-tot-com-ipi-icms-merc-rea","dec",0,">>>,>>>,>>9.99",?,RETURN-VALUE).

    {utp/ut-liter.i %_Total_Geral_(Oráado)}
    tth-dados-excel:ADD-NEW-FIELD("per-ger-tot-com-ipi-icms-orc","dec",0,?,?,RETURN-VALUE).
    {utp/ut-liter.i %_Total_Geral_(Realizado)}
    tth-dados-excel:ADD-NEW-FIELD("per-ger-tot-com-ipi-icms-rea","dec",0,?,?,RETURN-VALUE).

    {utp/ut-liter.i Total_Geral_sem_Impostos_(Oráado)}
    tth-dados-excel:ADD-NEW-FIELD("vl-ger-tot-sem-ipi-icms-orc","dec",0,">>>,>>>,>>9.99",?,RETURN-VALUE).
    {utp/ut-liter.i Total_Geral_sem_Impostos_(Realizado)}
    tth-dados-excel:ADD-NEW-FIELD("vl-ger-tot-sem-ipi-icms-merc-rea","dec",0,">>>,>>>,>>9.99",?,RETURN-VALUE).
    
    {utp/ut-liter.i %_Total_Geral_sem_Impostos_(Oráado)}
    tth-dados-excel:ADD-NEW-FIELD("per-ger-tot-sem-ipi-icms-orc","dec",0,?,?,RETURN-VALUE).
    {utp/ut-liter.i %_Total_Geral_sem_Impostos_(Realizado)}
    tth-dados-excel:ADD-NEW-FIELD("per-ger-tot-sem-ipi-icms-rea","dec",0,?,?,RETURN-VALUE).

    IF tt-param.l-desp-imposto THEN DO:        
        {utp/ut-liter.i Total_Impostos/Despesas}
        tth-dados-excel:ADD-NEW-FIELD("vl-ger-tot-imp-des-rea","dec",0,">>>,>>>,>>9.99",?,RETURN-VALUE).
        
        {utp/ut-liter.i Total_Geral}
        tth-dados-excel:ADD-NEW-FIELD("vl-ger-tot-com-ipi-icms-merc-rea","dec",0,">>>,>>>,>>9.99",?,RETURN-VALUE).
        
        {utp/ut-liter.i Total_Geral_sem_Impostos}
        tth-dados-excel:ADD-NEW-FIELD("vl-ger-tot-sem-ipi-icms-merc-rea","dec",0,">>>,>>>,>>9.99",?,RETURN-VALUE).
    END.
    
    tth-dados-excel:TEMP-TABLE-PREPARE("dadosExcel"). /*Significa que todas as definiá‰es de campo e °ndice para uma tabela tempor†ria foram fornecidas.*/
    bh-dados-excel = tth-dados-excel:DEFAULT-BUFFER-HANDLE. /*Como as tabelas tempor†rias est†ticas, toda tabela tempor†ria dinÉmica Ç criada com pelo menos um buffer. O identificador de objeto desse buffer Ç retornado por esse atributo. DEFAULT-BUFFER-HANDLE n∆o pode ser chamado atÇ que o mÇtodo TEMP-TABLE-PREPARE () tenha sido chamado, j† que o buffer padr∆o n∆o Ç criado atÇ ent∆o.*/

    FOR EACH tt-dados-excel NO-LOCK:
        bh-dados-excel:BUFFER-CREATE. /*Cria um registro, define campos para seus valores padr∆o e move uma c¢pia do registro para o buffer.*/
        bh-dados-excel:BUFFER-COPY(bufferTableExcel). /*este mÇtodo copia quaisquer campos comuns, determinados por nome, tipo de dados e correspondància de extens∆o, do buffer de origem para o buffer de recebimento. Se houver campos em um buffer que n∆o existem no outro, eles ser∆o ignorados. Esse mÇtodo Ç usado para acomodar tabelas tempor†rias de juná‰es.*/
    END.
    
    CREATE QUERY hQuery.
    hQuery:SET-BUFFERS(bh-dados-excel).
    hQuery:QUERY-PREPARE("FOR EACH dadosExcel"). 
    hQuery:QUERY-OPEN(). 
    
    DO TRANSACTION:
        REPEAT WHILE NOT hQuery:QUERY-OFF-END:
            IF  bh-dados-excel:AVAIL THEN DO:

                FOR FIRST tt-embarque-corpo NO-LOCK
                    WHERE tt-embarque-corpo.embarque      = bh-dados-excel:BUFFER-FIELD("embarque"):BUFFER-VALUE      
                      AND tt-embarque-corpo.cod-estabel   = bh-dados-excel:BUFFER-FIELD("cod-estabel"):BUFFER-VALUE
                      AND tt-embarque-corpo.cod-emitente  = bh-dados-excel:BUFFER-FIELD("cod-emitente"):BUFFER-VALUE:

                    {utp/ut-liter.i "CÇlulas_-_Embarque_" *}
                    run pi-acompanhar in h-acomp-a (input RETURN-VALUE + ": " + string(tt-embarque-corpo.embarque)).

                    IF  tt-param.l-desp-imposto THEN DO:
                        IF  tt-param.l-orc-real THEN DO:
                            IF  tt-param.i-desp-imposto = 2 THEN /*Imposto*/
                                ASSIGN bh-dados-excel:BUFFER-FIELD("vl-ger-ii-rea"):BUFFER-VALUE      = tt-embarque-corpo.vl-ger-ii-rea  
                                       bh-dados-excel:BUFFER-FIELD("per-ger-ii-rea"):BUFFER-VALUE     = tt-embarque-corpo.per-ger-ii-rea
                                       bh-dados-excel:BUFFER-FIELD("vl-ger-ii-orc"):BUFFER-VALUE      = tt-embarque-corpo.vl-ger-ii-orc
                                       bh-dados-excel:BUFFER-FIELD("per-ger-ii-orc"):BUFFER-VALUE     = tt-embarque-corpo.per-ger-ii-orc.

                            IF  i-pais-impto-usuario = 1 /* Brasil */ THEN DO:
                                /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-895) */
                                IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                                    ASSIGN bh-dados-excel:BUFFER-FIELD("vl-ger-ipi-orc"):BUFFER-VALUE      = tt-embarque-corpo.vl-ger-ipi-orc    
                                           bh-dados-excel:BUFFER-FIELD("per-ger-ipi-orc"):BUFFER-VALUE     = tt-embarque-corpo.per-ger-ipi-orc   
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-cbs-orc"):BUFFER-VALUE      = tt-embarque-corpo.vl-ger-cbs-orc    
                                           bh-dados-excel:BUFFER-FIELD("per-ger-cbs-orc"):BUFFER-VALUE     = tt-embarque-corpo.per-ger-cbs-orc   
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-ibs-uf-orc"):BUFFER-VALUE   = tt-embarque-corpo.vl-ger-ibs-uf-orc 
                                           bh-dados-excel:BUFFER-FIELD("per-ger-ibs-uf-orc"):BUFFER-VALUE  = tt-embarque-corpo.per-ger-ibs-uf-orc
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-ipi-rea"):BUFFER-VALUE      = tt-embarque-corpo.vl-ger-ipi-rea    
                                           bh-dados-excel:BUFFER-FIELD("per-ger-ipi-rea"):BUFFER-VALUE     = tt-embarque-corpo.per-ger-ipi-rea   
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-cbs-rea"):BUFFER-VALUE      = tt-embarque-corpo.vl-ger-cbs-rea    
                                           bh-dados-excel:BUFFER-FIELD("per-ger-cbs-rea"):BUFFER-VALUE     = tt-embarque-corpo.per-ger-cbs-rea   
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-ibs-uf-rea"):BUFFER-VALUE   = tt-embarque-corpo.vl-ger-ibs-uf-rea 
                                           bh-dados-excel:BUFFER-FIELD("per-ger-ibs-uf-rea"):BUFFER-VALUE  = tt-embarque-corpo.per-ger-ibs-uf-rea
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-ibs-mun-orc"):BUFFER-VALUE  = tt-embarque-corpo.vl-ger-ibs-mun-orc
                                           bh-dados-excel:BUFFER-FIELD("per-ger-ibs-mun-orc"):BUFFER-VALUE = tt-embarque-corpo.per-ger-ibs-mun-orc
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-ibs-mun-rea"):BUFFER-VALUE  = tt-embarque-corpo.vl-ger-ibs-mun-rea
                                           bh-dados-excel:BUFFER-FIELD("per-ger-ibs-mun-rea"):BUFFER-VALUE = tt-embarque-corpo.per-ger-ibs-mun-rea
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-is-orc"):BUFFER-VALUE  = tt-embarque-corpo.vl-ger-is-orc
                                           bh-dados-excel:BUFFER-FIELD("per-ger-is-orc"):BUFFER-VALUE = tt-embarque-corpo.per-ger-is-orc
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-is-rea"):BUFFER-VALUE  = tt-embarque-corpo.vl-ger-is-rea
                                           bh-dados-excel:BUFFER-FIELD("per-ger-is-rea"):BUFFER-VALUE = tt-embarque-corpo.per-ger-is-rea.
                                END.
                                /* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-895) */
                                ELSE DO:
                                    ASSIGN bh-dados-excel:BUFFER-FIELD("vl-ger-ipi-orc"):BUFFER-VALUE      = tt-embarque-corpo.vl-ger-ipi-orc    
                                           bh-dados-excel:BUFFER-FIELD("per-ger-ipi-orc"):BUFFER-VALUE     = tt-embarque-corpo.per-ger-ipi-orc   
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-pis-orc"):BUFFER-VALUE      = tt-embarque-corpo.vl-ger-pis-orc    
                                           bh-dados-excel:BUFFER-FIELD("per-ger-pis-orc"):BUFFER-VALUE     = tt-embarque-corpo.per-ger-pis-orc   
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-cofins-orc"):BUFFER-VALUE   = tt-embarque-corpo.vl-ger-cofins-orc 
                                           bh-dados-excel:BUFFER-FIELD("per-ger-cofins-orc"):BUFFER-VALUE  = tt-embarque-corpo.per-ger-cofins-orc
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-icms-orc"):BUFFER-VALUE     = tt-embarque-corpo.vl-ger-icms-orc   
                                           bh-dados-excel:BUFFER-FIELD("per-ger-icms-orc"):BUFFER-VALUE    = tt-embarque-corpo.per-ger-icms-orc
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-ipi-rea"):BUFFER-VALUE      = tt-embarque-corpo.vl-ger-ipi-rea    
                                           bh-dados-excel:BUFFER-FIELD("per-ger-ipi-rea"):BUFFER-VALUE     = tt-embarque-corpo.per-ger-ipi-rea   
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-pis-rea"):BUFFER-VALUE      = tt-embarque-corpo.vl-ger-pis-rea    
                                           bh-dados-excel:BUFFER-FIELD("per-ger-pis-rea"):BUFFER-VALUE     = tt-embarque-corpo.per-ger-pis-rea   
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-cofins-rea"):BUFFER-VALUE   = tt-embarque-corpo.vl-ger-cofins-rea 
                                           bh-dados-excel:BUFFER-FIELD("per-ger-cofins-rea"):BUFFER-VALUE  = tt-embarque-corpo.per-ger-cofins-rea
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-icms-rea"):BUFFER-VALUE     = tt-embarque-corpo.vl-ger-icms-rea   
                                           bh-dados-excel:BUFFER-FIELD("per-ger-icms-rea"):BUFFER-VALUE    = tt-embarque-corpo.per-ger-icms-rea. 
                                END.
							END.
    
    
                            ELSE /*Despesa*/
                                IF tt-param.l-desp-imposto THEN
                                    ASSIGN bh-dados-excel:BUFFER-FIELD("vl-ger-ii2-orc"):BUFFER-VALUE  = tt-embarque-corpo.vl-ger-ii2-orc
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-ii2-rea"):BUFFER-VALUE  = tt-embarque-corpo.vl-ger-ii2-rea
                                           bh-dados-excel:BUFFER-FIELD("per-ger-ii2-orc"):BUFFER-VALUE = tt-embarque-corpo.per-ger-ii2-orc
                                           bh-dados-excel:BUFFER-FIELD("per-ger-ii2-rea"):BUFFER-VALUE = tt-embarque-corpo.per-ger-ii2-rea.
    
                        END.
                        ELSE DO:
                            IF  i-pais-impto-usuario = 1 /* Brasil */ THEN DO:
                                /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-895) */
                                IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                                    ASSIGN bh-dados-excel:BUFFER-FIELD("vl-ger-ipi-rea"):BUFFER-VALUE      = tt-embarque-corpo.vl-ger-ipi-rea    
                                           bh-dados-excel:BUFFER-FIELD("per-ger-ipi-rea"):BUFFER-VALUE     = tt-embarque-corpo.per-ger-ipi-rea   
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-cbs-rea"):BUFFER-VALUE      = tt-embarque-corpo.vl-ger-cbs-rea    
                                           bh-dados-excel:BUFFER-FIELD("per-ger-cbs-rea"):BUFFER-VALUE     = tt-embarque-corpo.per-ger-cbs-rea   
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-ibs-uf-rea"):BUFFER-VALUE   = tt-embarque-corpo.vl-ger-ibs-uf-rea 
                                           bh-dados-excel:BUFFER-FIELD("per-ger-ibs-uf-rea"):BUFFER-VALUE  = tt-embarque-corpo.per-ger-ibs-uf-rea
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-ibs-mun-rea"):BUFFER-VALUE  = tt-embarque-corpo.vl-ger-ibs-mun-rea 
                                           bh-dados-excel:BUFFER-FIELD("per-ger-ibs-mun-rea"):BUFFER-VALUE = tt-embarque-corpo.per-ger-ibs-mun-rea
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-is-rea"):BUFFER-VALUE       = tt-embarque-corpo.vl-ger-is-rea 
                                           bh-dados-excel:BUFFER-FIELD("per-ger-is-rea"):BUFFER-VALUE      = tt-embarque-corpo.per-ger-is-rea.
                                END.
                                /* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-895) */
                                ELSE DO:
                                    ASSIGN bh-dados-excel:BUFFER-FIELD("vl-ger-ipi-rea"):BUFFER-VALUE      = tt-embarque-corpo.vl-ger-ipi-rea    
                                           bh-dados-excel:BUFFER-FIELD("per-ger-ipi-rea"):BUFFER-VALUE     = tt-embarque-corpo.per-ger-ipi-rea   
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-pis-rea"):BUFFER-VALUE      = tt-embarque-corpo.vl-ger-pis-rea    
                                           bh-dados-excel:BUFFER-FIELD("per-ger-pis-rea"):BUFFER-VALUE     = tt-embarque-corpo.per-ger-pis-rea   
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-cofins-rea"):BUFFER-VALUE   = tt-embarque-corpo.vl-ger-cofins-rea 
                                           bh-dados-excel:BUFFER-FIELD("per-ger-cofins-rea"):BUFFER-VALUE  = tt-embarque-corpo.per-ger-cofins-rea
                                           bh-dados-excel:BUFFER-FIELD("vl-ger-icms-rea"):BUFFER-VALUE     = tt-embarque-corpo.vl-ger-icms-rea   
                                           bh-dados-excel:BUFFER-FIELD("per-ger-icms-rea"):BUFFER-VALUE    = tt-embarque-corpo.per-ger-icms-rea. 
                                END.
                                
                                IF  tt-param.i-desp-imposto = 2 THEN /*Imposto*/
                                    ASSIGN bh-dados-excel:BUFFER-FIELD("vl-ger-ii-rea"):BUFFER-VALUE   = tt-embarque-corpo.vl-ger-ii-rea  
                                           bh-dados-excel:BUFFER-FIELD("per-ger-ii-rea"):BUFFER-VALUE  = tt-embarque-corpo.per-ger-ii-rea.
                                ELSE /*Despesa*/
                                    ASSIGN bh-dados-excel:BUFFER-FIELD("vl-ger-ii2-rea"):BUFFER-VALUE  = tt-embarque-corpo.vl-ger-ii2-rea
                                           bh-dados-excel:BUFFER-FIELD("per-ger-ii2-rea"):BUFFER-VALUE = tt-embarque-corpo.per-ger-ii2-rea.

                            END.
                            ELSE DO:                            
                                IF tt-param.i-desp-imposto = 1 THEN /*Despesa*/
                                    ASSIGN bh-dados-excel:BUFFER-FIELD("vl-ger-ii2-rea"):BUFFER-VALUE  = tt-embarque-corpo.vl-ger-ii2-rea
                                           bh-dados-excel:BUFFER-FIELD("per-ger-ii2-rea"):BUFFER-VALUE = tt-embarque-corpo.per-ger-ii2-rea.
                            END.
                            
                        END.
                    END.

                    IF tt-param.l-desp-imposto OR tt-param.l-orc-real THEN
                        ASSIGN bh-dados-excel:BUFFER-FIELD("vl-ger-mercado-rea"):BUFFER-VALUE               = tt-embarque-corpo.vl-ger-mercado-rea   
                               bh-dados-excel:BUFFER-FIELD("per-ger-mercado-rea"):BUFFER-VALUE              = tt-embarque-corpo.per-ger-mercado-rea
                               bh-dados-excel:BUFFER-FIELD("vl-ger-tot-imp-des-rea"):BUFFER-VALUE           = tt-embarque-corpo.vl-ger-tot-imp-des-rea
                               bh-dados-excel:BUFFER-FIELD("vl-ger-tot-com-ipi-icms-merc-rea"):BUFFER-VALUE = tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea
                               bh-dados-excel:BUFFER-FIELD("vl-ger-tot-sem-ipi-icms-merc-rea"):BUFFER-VALUE = tt-embarque-corpo.vl-ger-tot-sem-ipi-icms-merc-rea.

                    IF tt-param.l-orc-real THEN 
                        ASSIGN bh-dados-excel:BUFFER-FIELD("vl-ger-mercado-orc"):BUFFER-VALUE           = tt-embarque-corpo.vl-ger-mercado-orc
                               bh-dados-excel:BUFFER-FIELD("per-ger-mercado-orc"):BUFFER-VALUE          = tt-embarque-corpo.per-ger-mercado-orc
                               bh-dados-excel:BUFFER-FIELD("vl-ger-tot-imp-des-orc"):BUFFER-VALUE       = tt-embarque-corpo.vl-ger-tot-imp-des-orc.
                               
                    IF  i-pais-impto-usuario = 1 /* Brasil */ THEN DO:
                          ASSIGN  bh-dados-excel:BUFFER-FIELD("vl-ger-tot-com-ipi-icms-orc"):BUFFER-VALUE  = tt-embarque-corpo.vl-ger-tot-com-ipi-icms-orc
                                  bh-dados-excel:BUFFER-FIELD("vl-ger-tot-sem-ipi-icms-orc"):BUFFER-VALUE  = tt-embarque-corpo.vl-ger-tot-sem-ipi-icms-orc
                                  bh-dados-excel:BUFFER-FIELD("per-ger-tot-imp-des-orc"):BUFFER-VALUE      = tt-embarque-corpo.per-ger-tot-imp-des-orc
                                  bh-dados-excel:BUFFER-FIELD("per-ger-tot-imp-des-rea"):BUFFER-VALUE      = tt-embarque-corpo.per-ger-tot-imp-des-rea
                                  bh-dados-excel:BUFFER-FIELD("per-ger-tot-com-ipi-icms-orc"):BUFFER-VALUE = tt-embarque-corpo.per-ger-tot-com-ipi-icms-orc
                                  bh-dados-excel:BUFFER-FIELD("per-ger-tot-com-ipi-icms-rea"):BUFFER-VALUE = tt-embarque-corpo.per-ger-tot-com-ipi-icms-rea
                                  bh-dados-excel:BUFFER-FIELD("per-ger-tot-sem-ipi-icms-orc"):BUFFER-VALUE = tt-embarque-corpo.per-ger-tot-sem-ipi-icms-orc
                                  bh-dados-excel:BUFFER-FIELD("per-ger-tot-sem-ipi-icms-rea"):BUFFER-VALUE = tt-embarque-corpo.per-ger-tot-sem-ipi-icms-rea.
                    END.
                    
                    IF tt-param.l-desp-imposto THEN DO:
                        FOR EACH tt-detalha-despesa-aux NO-LOCK
                           WHERE tt-detalha-despesa-aux.embarque      = tt-embarque-corpo.embarque   
                             AND tt-detalha-despesa-aux.cod-estabel   = tt-embarque-corpo.cod-estabel
                           break by tt-detalha-despesa-aux.cod-despesa:
    
                            IF tt-param.l-orc-real THEN DO:
                                ASSIGN bh-dados-excel:BUFFER-FIELD("co-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-orc-corpo")):BUFFER-VALUE = tt-detalha-despesa-aux.vl-des-orc
                                       bh-dados-excel:BUFFER-FIELD("c-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-rea-corpo")):BUFFER-VALUE = tt-detalha-despesa-aux.vl-des-rea
                                       bh-dados-excel:BUFFER-FIELD("co-perc-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-orc-corpo")):BUFFER-VALUE  = tt-detalha-despesa-aux.per-des-orc
                                       bh-dados-excel:BUFFER-FIELD("c-perc-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-rea-corpo")):BUFFER-VALUE  = tt-detalha-despesa-aux.per-des-rea.
                            END.
                            ELSE 
                                ASSIGN bh-dados-excel:BUFFER-FIELD("c-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-corpo-rea")):BUFFER-VALUE = tt-detalha-despesa-aux.vl-des-rea
                                       bh-dados-excel:BUFFER-FIELD("c-perc-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-corpo-rea")):BUFFER-VALUE  = tt-detalha-despesa-aux.per-des-rea.
                            
                            IF  i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:

                               IF tt-detalha-despesa-aux.situacao = 3 /* Complementar */ THEN DO:
                                   {utp/ut-liter.i "NF Complementar" *}
                               END.    
                               ELSE 
                                   {utp/ut-liter.i "NF Nacionalizaá∆o" *} 
                               ASSIGN c-origem = TRIM(RETURN-VALUE).
                               bh-dados-excel:BUFFER-FIELD("c-origem-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-corpo-rea")):BUFFER-VALUE = c-origem.  

                            END.


                        END.
                     
                        IF  i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:

						    assign vl-impto-int     = 0
						           vl-tot-impto-int = 0.
                            FOR EACH tt-impto-internac
                                WHERE tt-impto-internac.embarque    = tt-embarque-corpo.embarque
                                  AND tt-impto-internac.cod-estabel = tt-embarque-corpo.cod-estabel
								  break by tt-impto-internac.cdn-imposto:
								 
							    assign vl-impto-int     = vl-impto-int     + tt-impto-internac.val-impto-moeda-relat
							           vl-tot-impto-int = vl-tot-impto-int + tt-impto-internac.val-impto-moeda-relat.

								if last-of(tt-impto-internac.cdn-imposto) then do:
                                    ASSIGN bh-dados-excel:BUFFER-FIELD("c-" + REPLACE(tt-impto-internac.descricao,CHR(32),"-corpo-rea")):BUFFER-VALUE = vl-impto-int
                                           bh-dados-excel:BUFFER-FIELD("c-" + REPLACE(tt-impto-internac.descricao,CHR(32),"-corpo-rea")):FORMAT       = ">>>,>>>,>>9.9999"
                                           bh-dados-excel:BUFFER-FIELD("c-perc-" + REPLACE(tt-impto-internac.descricao,CHR(32),"-corpo-rea")):BUFFER-VALUE  = (vl-impto-int / tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea) * 100.
										   
								    assign vl-impto-int = 0.		   
							    end.
								if last(tt-impto-internac.cdn-imposto) then do:
									ASSIGN bh-dados-excel:BUFFER-FIELD("c-total-imposto-internac-corpo-rea"):BUFFER-VALUE = vl-tot-impto-int
										   bh-dados-excel:BUFFER-FIELD("c-total-imposto-internac-corpo-rea"):FORMAT       = ">>>,>>>,>>9.9999"
										   bh-dados-excel:BUFFER-FIELD("c-perc-total-imposto-internac-corpo-rea"):BUFFER-VALUE  = (vl-tot-impto-int / tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea) * 100.
										   
									assign vl-tot-impto-int = 0.		   
								end.
                            END.
                        END.
                    END.
                END.
                
                IF tt-param.l-desp-imposto then do:
                     IF tt-param.l-orc-real THEN DO:
                         FOR EACH tt-detalha-despesa-aux
                                 WHERE tt-detalha-despesa-aux.embarque      = tt-embarque-corpo.embarque
                                  and tt-detalha-despesa-aux.cod-estabel   = tt-embarque-corpo.cod-estabel
                                  break by tt-detalha-despesa-aux.cod-despesa:
                              IF LAST-OF(tt-detalha-despesa-aux.cod-despesa) THEN DO: 
                                    ASSIGN bh-dados-excel:BUFFER-FIELD("co-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-orc-corpo")):BUFFER-VALUE = tt-detalha-despesa-aux.vl-des-orc
                                           bh-dados-excel:BUFFER-FIELD("c-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-rea-corpo")):BUFFER-VALUE = tt-detalha-despesa-aux.vl-des-rea
                                           bh-dados-excel:BUFFER-FIELD("co-perc-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-orc-corpo")):BUFFER-VALUE  = tt-detalha-despesa-aux.per-des-orc
                                           bh-dados-excel:BUFFER-FIELD("c-perc-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-rea-corpo")):BUFFER-VALUE  = tt-detalha-despesa-aux.per-des-rea.
                              END.
                         END.     
                     END.
                
                     ELSE DO:
                          FOR EACH tt-detalha-despesa-aux
                             WHERE tt-detalha-despesa-aux.embarque      = tt-embarque-corpo.embarque
                               and tt-detalha-despesa-aux.cod-estabel   = tt-embarque-corpo.cod-estabel
                              break by tt-detalha-despesa-aux.cod-despesa:
                              IF LAST-OF(tt-detalha-despesa-aux.cod-despesa) THEN DO:
                                  ASSIGN bh-dados-excel:BUFFER-FIELD("c-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-corpo-rea")):BUFFER-VALUE      = tt-detalha-despesa-aux.vl-des-rea
                                         bh-dados-excel:BUFFER-FIELD("c-perc-" + REPLACE(tt-detalha-despesa-aux.desc-despesa,CHR(32),"-corpo-rea")):BUFFER-VALUE = tt-detalha-despesa-aux.per-des-rea.
                              END.
                          END.     
                     END.
                       
                END.
            END.    
            hQuery:GET-NEXT (NO-LOCK) NO-ERROR.    
        END.
        bh-dados-excel:BUFFER-RELEASE().
    END.
    hQuery:QUERY-CLOSE().
    DELETE OBJECT hQuery.   
    
    IF tt-param.l-itens OR tt-param.l-orc-real THEN DO: 
        
        IF tt-param.l-orc-real THEN DO:

            {utp/ut-liter.i Total_Impostos/Despesas_(Oráado)}
            tth-dados-excel-detail:ADD-NEW-FIELD("vl-tot-imp-des-orc","dec",0,">>>,>>>,>>9.99999",?,RETURN-VALUE).
            {utp/ut-liter.i Total_Impostos/Despesas_(Realizado)}
            tth-dados-excel-detail:ADD-NEW-FIELD("vl-tot-imp-des-rea","dec",0,">>>,>>>,>>9.99999",?,RETURN-VALUE).

            {utp/ut-liter.i %_Total_Impostos/Despesas_(Oráado)}
            tth-dados-excel-detail:ADD-NEW-FIELD("per-tot-imp-des-orc","dec",0,">>>,>>>,>>9.99999",?,RETURN-VALUE).
            {utp/ut-liter.i %_Total_Impostos/Despesas_(Realizado)}
            tth-dados-excel-detail:ADD-NEW-FIELD("per-tot-imp-des-rea","dec",0,?,?,RETURN-VALUE).
        
            {utp/ut-liter.i Total_Geral_(Oráado)}
            tth-dados-excel-detail:ADD-NEW-FIELD("vl-tot-com-ipi-icms-orc-total","dec",0,">>>,>>>,>>9.99999",?,RETURN-VALUE).
            {utp/ut-liter.i Total_Geral_(Realizado)}
            tth-dados-excel-detail:ADD-NEW-FIELD("vl-tot-com-ipi-icms-dsp-merc-rea","dec",0,">>>,>>>,>>9.99999",?,RETURN-VALUE).

            {utp/ut-liter.i %_Total_Geral_(Oráado)}
            tth-dados-excel-detail:ADD-NEW-FIELD("per-tot-com-ipi-icms-orc","dec",0,">>>,>>>,>>9.99999",?,RETURN-VALUE).
            {utp/ut-liter.i %_Total_Geral_(Realizado)}
            tth-dados-excel-detail:ADD-NEW-FIELD("per-tot-com-ipi-icms-rea","dec",0,?,?,RETURN-VALUE).
        
            {utp/ut-liter.i Total_Geral_sem_Impostos_(Oráado)}
            tth-dados-excel-detail:ADD-NEW-FIELD("vl-tot-sem-ipi-icms-orc-total","dec",0,">>>,>>>,>>9.99999",?,RETURN-VALUE).
            {utp/ut-liter.i Total_Geral_sem_Impostos_(Realizado)}
            tth-dados-excel-detail:ADD-NEW-FIELD("vl-tot-sem-ipi-icms-dsp-merc-rea","dec",0,">>>,>>>,>>9.99",?,RETURN-VALUE).

            {utp/ut-liter.i %_Total_Geral_sem_Impostos_(Oráado)}
            tth-dados-excel-detail:ADD-NEW-FIELD("per-tot-sem-ipi-icms-orc","dec",0,">>>,>>>,>>9.99999",?,RETURN-VALUE).
            {utp/ut-liter.i %_Total_Geral_sem_Impostos_(Realizado)}
            tth-dados-excel-detail:ADD-NEW-FIELD("per-tot-sem-ipi-icms-rea","dec",0,?,?,RETURN-VALUE).

        END.
        ELSE DO:
            IF tt-param.l-desp-imposto THEN DO:

                {utp/ut-liter.i Total_Impostos/Despesas}
                tth-dados-excel-detail:ADD-NEW-FIELD("vl-tot-imp-des-rea","dec",0,">>>,>>>,>>9.99999",?,RETURN-VALUE).
                
                {utp/ut-liter.i Total_Geral}
                tth-dados-excel-detail:ADD-NEW-FIELD("vl-tot-com-ipi-icms-dsp-merc-rea","dec",0,">>>,>>>,>>9.99999",?,RETURN-VALUE).
                
                {utp/ut-liter.i Total_Geral_sem_Impostos}
                tth-dados-excel-detail:ADD-NEW-FIELD("vl-tot-sem-ipi-icms-dsp-merc-rea","dec",0,">>>,>>>,>>9.99999",?,RETURN-VALUE).
            END.
        END.
        
        tth-dados-excel-detail:TEMP-TABLE-PREPARE("dadosExcelDetail"). /*Significa que todas as definiá‰es de campo e °ndice para uma tabela tempor†ria foram fornecidas.*/
        bh-dados-excel-detail = tth-dados-excel-detail:DEFAULT-BUFFER-HANDLE. /*Como as tabelas tempor†rias est†ticas, toda tabela tempor†ria dinÉmica Ç criada com pelo menos um buffer. O identificador de objeto desse buffer Ç retornado por esse atributo. DEFAULT-BUFFER-HANDLE n∆o pode ser chamado atÇ que o mÇtodo TEMP-TABLE-PREPARE () tenha sido chamado, j† que o buffer padr∆o n∆o Ç criado atÇ ent∆o.*/

        FOR EACH tt-dados-excel-detail NO-LOCK
            BREAK BY tt-dados-excel-detail.embarque
                  BY tt-dados-excel-detail.sequencia:
            bh-dados-excel-detail:BUFFER-CREATE. /*Cria um registro, define campos para seus valores padr∆o e move uma c¢pia do registro para o buffer.*/
            bh-dados-excel-detail:BUFFER-COPY(bufferTableExcelDetail). /*este mÇtodo copia quaisquer campos comuns, determinados por nome, tipo de dados e correspondància de extens∆o, do buffer de origem para o buffer de recebimento. Se houver campos em um buffer que n∆o existem no outro, eles ser∆o ignorados. Esse mÇtodo Ç usado para acomodar tabelas tempor†rias de juná‰es.*/
        END.

        CREATE QUERY hQuery.
        hQuery:SET-BUFFERS(bh-dados-excel-detail).
        hQuery:QUERY-PREPARE("FOR EACH dadosExcelDetail"). 
        hQuery:QUERY-OPEN().

        DO TRANSACTION:
            REPEAT WHILE NOT hQuery:QUERY-OFF-END:
                IF bh-dados-excel-detail:AVAIL THEN DO:
                                 
                    FOR FIRST tt-detalha-item NO-LOCK
                        where tt-detalha-item.embarque    = bh-dados-excel-detail:BUFFER-FIELD("embarque"):BUFFER-VALUE   
                          and tt-detalha-item.cod-estabel = bh-dados-excel-detail:BUFFER-FIELD("cod-estabel"):BUFFER-VALUE
                          AND tt-detalha-item.it-codigo   = bh-dados-excel-detail:BUFFER-FIELD("it-codigo"):BUFFER-VALUE 
                          AND tt-detalha-item.sequencia   = bh-dados-excel-detail:BUFFER-FIELD("sequencia"):BUFFER-VALUE:

                        {utp/ut-liter.i "CÇlulas_-_Itens" *}
                        run pi-acompanhar in h-acomp-a (input RETURN-VALUE + ": " + string(tt-detalha-item.it-codigo) + " - " + STRING(tt-detalha-item.numero-ordem)).
                        
                        IF tt-param.l-orc-real THEN DO:

                            ASSIGN bh-dados-excel-detail:BUFFER-FIELD("vl-mercado-orc"):BUFFER-VALUE   = tt-detalha-item.vl-mercado-orc
                                   bh-dados-excel-detail:BUFFER-FIELD("per-mercado-orc"):BUFFER-VALUE  = tt-detalha-item.per-mercado-orc
                                   bh-dados-excel-detail:BUFFER-FIELD("vl-mercado-rea"):BUFFER-VALUE   = tt-detalha-item.vl-mercado-rea
                                   bh-dados-excel-detail:BUFFER-FIELD("per-mercado-rea"):BUFFER-VALUE  = tt-detalha-item.per-mercado-rea.

                            IF tt-param.l-desp-imposto THEN DO:
                                IF  i-pais-impto-usuario = 1 /* Brasil */ THEN DO:
                                    /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-895) */
                                    IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                                        ASSIGN bh-dados-excel-detail:BUFFER-FIELD("vl-ipi-orc"):BUFFER-VALUE       = tt-detalha-item.vl-ipi-orc
                                               bh-dados-excel-detail:BUFFER-FIELD("per-ipi-orc"):BUFFER-VALUE      = tt-detalha-item.per-ipi-orc
                                               bh-dados-excel-detail:BUFFER-FIELD("vl-cbs-orc"):BUFFER-VALUE       = tt-detalha-item.vl-cbs-orc
                                               bh-dados-excel-detail:BUFFER-FIELD("per-cbs-orc"):BUFFER-VALUE      = tt-detalha-item.per-cbs-orc
                                               bh-dados-excel-detail:BUFFER-FIELD("vl-ibs-uf-orc"):BUFFER-VALUE    = tt-detalha-item.vl-ibs-uf-orc
                                               bh-dados-excel-detail:BUFFER-FIELD("per-ibs-uf-orc"):BUFFER-VALUE   = tt-detalha-item.per-ibs-uf-orc
                                               bh-dados-excel-detail:BUFFER-FIELD("vl-ipi-rea"):BUFFER-VALUE       = tt-detalha-item.vl-ipi-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("per-ipi-rea"):BUFFER-VALUE      = tt-detalha-item.per-ipi-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("vl-cbs-rea"):BUFFER-VALUE       = tt-detalha-item.vl-cbs-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("per-cbs-rea"):BUFFER-VALUE      = tt-detalha-item.per-cbs-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("vl-ibs-uf-rea"):BUFFER-VALUE    = tt-detalha-item.vl-ibs-uf-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("per-ibs-uf-rea"):BUFFER-VALUE   = tt-detalha-item.per-ibs-uf-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("vl-ibs-mun-orc"):BUFFER-VALUE   = tt-detalha-item.vl-ibs-mun-orc
                                               bh-dados-excel-detail:BUFFER-FIELD("per-ibs-mun-orc"):BUFFER-VALUE  = tt-detalha-item.per-ibs-mun-orc
                                               bh-dados-excel-detail:BUFFER-FIELD("vl-ibs-mun-rea"):BUFFER-VALUE   = tt-detalha-item.vl-ibs-mun-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("per-ibs-mun-rea"):BUFFER-VALUE  = tt-detalha-item.per-ibs-mun-rea 
                                               bh-dados-excel-detail:BUFFER-FIELD("vl-is-orc"):BUFFER-VALUE        = tt-detalha-item.vl-is-orc
                                               bh-dados-excel-detail:BUFFER-FIELD("per-is-orc"):BUFFER-VALUE       = tt-detalha-item.per-is-orc
                                               bh-dados-excel-detail:BUFFER-FIELD("vl-is-rea"):BUFFER-VALUE        = tt-detalha-item.vl-is-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("per-is-rea"):BUFFER-VALUE       = tt-detalha-item.per-is-rea.
                                    END.
                                    /* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-895) */
                                    ELSE DO:
                                        ASSIGN bh-dados-excel-detail:BUFFER-FIELD("vl-ipi-orc"):BUFFER-VALUE       = tt-detalha-item.vl-ipi-orc
                                               bh-dados-excel-detail:BUFFER-FIELD("per-ipi-orc"):BUFFER-VALUE      = tt-detalha-item.per-ipi-orc
                                               bh-dados-excel-detail:BUFFER-FIELD("vl-pis-orc"):BUFFER-VALUE       = tt-detalha-item.vl-pis-orc
                                               bh-dados-excel-detail:BUFFER-FIELD("per-pis-orc"):BUFFER-VALUE      = tt-detalha-item.per-pis-orc
                                               bh-dados-excel-detail:BUFFER-FIELD("vl-cofins-orc"):BUFFER-VALUE    = tt-detalha-item.vl-cofins-orc
                                               bh-dados-excel-detail:BUFFER-FIELD("per-cofins-orc"):BUFFER-VALUE   = tt-detalha-item.per-cofins-orc
                                               bh-dados-excel-detail:BUFFER-FIELD("vl-icms-orc"):BUFFER-VALUE      = tt-detalha-item.vl-icms-orc
                                               bh-dados-excel-detail:BUFFER-FIELD("per-icms-orc"):BUFFER-VALUE     = tt-detalha-item.per-icms-orc
                                               bh-dados-excel-detail:BUFFER-FIELD("vl-ipi-rea"):BUFFER-VALUE       = tt-detalha-item.vl-ipi-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("per-ipi-rea"):BUFFER-VALUE      = tt-detalha-item.per-ipi-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("vl-pis-rea"):BUFFER-VALUE       = tt-detalha-item.vl-pis-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("per-pis-rea"):BUFFER-VALUE      = tt-detalha-item.per-pis-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("vl-cofins-rea"):BUFFER-VALUE    = tt-detalha-item.vl-cofins-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("per-cofins-rea"):BUFFER-VALUE   = tt-detalha-item.per-cofins-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("vl-icms-rea"):BUFFER-VALUE      = tt-detalha-item.vl-icms-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("per-icms-rea"):BUFFER-VALUE     = tt-detalha-item.per-icms-rea.
                                    END.
                                END.

                                for each  tt-detalha-despesa NO-LOCK
                                    where tt-detalha-despesa.numero-ordem = tt-detalha-item.numero-ordem
                                      and tt-detalha-despesa.embarque     = tt-detalha-item.embarque
                                      and tt-detalha-despesa.cod-estabel  = tt-detalha-item.cod-estabel
                                      and tt-detalha-despesa.it-codigo    = tt-detalha-item.it-codigo
                                      and tt-detalha-despesa.sequencia    = tt-detalha-item.sequencia
                                    break by tt-detalha-despesa.cod-despesa:
        
                                    IF LAST-OF(tt-detalha-despesa.cod-despesa) THEN DO:
        
                                            {utp/ut-liter.i "CÇlulas_-_Despesas" *}
                                            run pi-acompanhar in h-acomp-a (input RETURN-VALUE + ": " + string(tt-detalha-despesa.cod-despesa) + " - " + string(tt-detalha-item.numero-ordem)).
        
                                            ASSIGN bh-dados-excel-detail:BUFFER-FIELD("co-" + REPLACE(tt-detalha-despesa.desc-despesa,CHR(32),"-item-orc")):BUFFER-VALUE      = tt-detalha-despesa.vl-des-orc
                                                   bh-dados-excel-detail:BUFFER-FIELD("c-" + REPLACE(tt-detalha-despesa.desc-despesa,CHR(32),"-item-rea")):BUFFER-VALUE      = tt-detalha-despesa.vl-des-rea
                                                   bh-dados-excel-detail:BUFFER-FIELD("co-perc-" + REPLACE(tt-detalha-despesa.desc-despesa,CHR(32),"-item-orc")):BUFFER-VALUE = tt-detalha-despesa.per-des-orc
                                                   bh-dados-excel-detail:BUFFER-FIELD("c-perc-" + REPLACE(tt-detalha-despesa.desc-despesa,CHR(32),"-item-rea")):BUFFER-VALUE = tt-detalha-despesa.per-des-rea.
                                    END.
                                END.      

                                if tt-param.i-desp-imposto = 1 THEN /*Despesa*/
                                    ASSIGN bh-dados-excel-detail:BUFFER-FIELD("vl-ii2-orc"):BUFFER-VALUE  = tt-detalha-item.vl-ii2-orc
                                           bh-dados-excel-detail:BUFFER-FIELD("vl-ii2-rea"):BUFFER-VALUE  = tt-detalha-item.vl-ii2-rea
                                           bh-dados-excel-detail:BUFFER-FIELD("per-ii2-orc"):BUFFER-VALUE = tt-detalha-item.per-ii2-orc
                                           bh-dados-excel-detail:BUFFER-FIELD("per-ii2-rea"):BUFFER-VALUE = tt-detalha-item.per-ii2-rea.
                                ELSE /*Imposto*/
                                    ASSIGN bh-dados-excel-detail:BUFFER-FIELD("vl-ii-orc"):BUFFER-VALUE  = tt-detalha-item.vl-ii-orc
                                           bh-dados-excel-detail:BUFFER-FIELD("vl-ii-rea"):BUFFER-VALUE  = tt-detalha-item.vl-ii-rea
                                           bh-dados-excel-detail:BUFFER-FIELD("per-ii-orc"):BUFFER-VALUE = tt-detalha-item.per-ii-orc
                                           bh-dados-excel-detail:BUFFER-FIELD("per-ii-rea"):BUFFER-VALUE = tt-detalha-item.per-ii-rea.
                            END.
    
                            ASSIGN bh-dados-excel-detail:BUFFER-FIELD("vl-tot-imp-des-orc"):BUFFER-VALUE               = tt-detalha-item.vl-tot-imp-des-orc            
                                   bh-dados-excel-detail:BUFFER-FIELD("vl-tot-com-ipi-icms-orc-total"):BUFFER-VALUE    = tt-detalha-item.vl-tot-com-ipi-icms-orc-total 
                                   bh-dados-excel-detail:BUFFER-FIELD("vl-tot-sem-ipi-icms-orc-total"):BUFFER-VALUE    = tt-detalha-item.vl-tot-sem-ipi-icms-orc-total
                                   bh-dados-excel-detail:BUFFER-FIELD("vl-tot-imp-des-rea"):BUFFER-VALUE               = tt-detalha-item.vl-tot-imp-des-rea
                                   bh-dados-excel-detail:BUFFER-FIELD("vl-tot-com-ipi-icms-dsp-merc-rea"):BUFFER-VALUE = tt-detalha-item.vl-tot-com-ipi-icms-rea
                                   bh-dados-excel-detail:BUFFER-FIELD("vl-tot-sem-ipi-icms-dsp-merc-rea"):BUFFER-VALUE = tt-detalha-item.vl-tot-sem-ipi-icms-dsp-merc-rea
                                   bh-dados-excel-detail:BUFFER-FIELD("per-tot-imp-des-orc"):BUFFER-VALUE              = tt-detalha-item.per-tot-imp-des-orc
                                   bh-dados-excel-detail:BUFFER-FIELD("per-tot-imp-des-rea"):BUFFER-VALUE              = tt-detalha-item.per-tot-imp-des-rea
                                   bh-dados-excel-detail:BUFFER-FIELD("per-tot-com-ipi-icms-orc"):BUFFER-VALUE         = tt-detalha-item.per-tot-com-ipi-icms-orc
                                   bh-dados-excel-detail:BUFFER-FIELD("per-tot-com-ipi-icms-rea"):BUFFER-VALUE         = tt-detalha-item.per-tot-com-ipi-icms-rea
                                   bh-dados-excel-detail:BUFFER-FIELD("per-tot-sem-ipi-icms-orc"):BUFFER-VALUE         = tt-detalha-item.per-tot-sem-ipi-icms-orc
                                   bh-dados-excel-detail:BUFFER-FIELD("per-tot-sem-ipi-icms-rea"):BUFFER-VALUE         = tt-detalha-item.per-tot-sem-ipi-icms-rea.
                            
                        END.
                        ELSE DO:

                            IF tt-param.l-desp-imposto THEN DO:
                                IF tt-param.i-desp-imposto = 1 THEN
                                    ASSIGN bh-dados-excel-detail:BUFFER-FIELD("vl-ii2-rea"):BUFFER-VALUE  = tt-detalha-item.vl-ii2-rea
                                           bh-dados-excel-detail:BUFFER-FIELD("per-ii2-rea"):BUFFER-VALUE = tt-detalha-item.per-ii2-rea.
                                ELSE DO:
                                    IF i-pais-impto-usuario = 1 /* Brasil */ THEN
                                        ASSIGN bh-dados-excel-detail:BUFFER-FIELD("vl-ii-rea"):BUFFER-VALUE  = tt-detalha-item.vl-ii-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("per-ii-rea"):BUFFER-VALUE = tt-detalha-item.per-ii-rea.
                                END.

                                ASSIGN bh-dados-excel-detail:BUFFER-FIELD("vl-mercado-rea"):BUFFER-VALUE    = tt-detalha-item.vl-mercado-rea
                                       bh-dados-excel-detail:BUFFER-FIELD("per-mercado-rea"):BUFFER-VALUE   = tt-detalha-item.per-mercado-rea.

                                IF  i-pais-impto-usuario = 1 /* Brasil */ THEN DO:
                                    /* Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-895) */
                                    IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                                        ASSIGN bh-dados-excel-detail:BUFFER-FIELD("vl-ipi-rea"):BUFFER-VALUE        = tt-detalha-item.vl-ipi-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("per-ipi-rea"):BUFFER-VALUE       = tt-detalha-item.per-ipi-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("vl-cbs-rea"):BUFFER-VALUE        = tt-detalha-item.vl-cbs-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("per-cbs-rea"):BUFFER-VALUE       = tt-detalha-item.per-cbs-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("vl-ibs-uf-rea"):BUFFER-VALUE     = tt-detalha-item.vl-ibs-uf-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("per-ibs-uf-rea"):BUFFER-VALUE    = tt-detalha-item.per-ibs-uf-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("vl-ibs-mun-rea"):BUFFER-VALUE    = tt-detalha-item.vl-ibs-mun-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("per-ibs-mun-rea"):BUFFER-VALUE   = tt-detalha-item.per-ibs-mun-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("vl-is-rea"):BUFFER-VALUE         = tt-detalha-item.vl-is-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("per-is-rea"):BUFFER-VALUE        = tt-detalha-item.per-is-rea.
                                    END.
                                    /* FIM -- Reforma Tribut†ria - Novos Tributos (DBACKRTDTS-895) */
                                    ELSE DO:
                                        ASSIGN bh-dados-excel-detail:BUFFER-FIELD("vl-ipi-rea"):BUFFER-VALUE        = tt-detalha-item.vl-ipi-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("per-ipi-rea"):BUFFER-VALUE       = tt-detalha-item.per-ipi-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("vl-pis-rea"):BUFFER-VALUE        = tt-detalha-item.vl-pis-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("per-pis-rea"):BUFFER-VALUE       = tt-detalha-item.per-pis-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("vl-cofins-rea"):BUFFER-VALUE     = tt-detalha-item.vl-cofins-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("per-cofins-rea"):BUFFER-VALUE    = tt-detalha-item.per-cofins-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("vl-icms-rea"):BUFFER-VALUE       = tt-detalha-item.vl-icms-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("per-icms-rea"):BUFFER-VALUE      = tt-detalha-item.per-icms-rea.
                                    END.
                                END.

                                for each  tt-detalha-despesa NO-LOCK
                                    where tt-detalha-despesa.numero-ordem = tt-detalha-item.numero-ordem
                                      and tt-detalha-despesa.embarque     = tt-detalha-item.embarque
                                      and tt-detalha-despesa.cod-estabel  = tt-detalha-item.cod-estabel
                                      and tt-detalha-despesa.it-codigo    = tt-detalha-item.it-codigo
                                      and tt-detalha-despesa.sequencia    = tt-detalha-item.sequencia
                                    break by tt-detalha-despesa.cod-despesa:

                                    {utp/ut-liter.i "CÇlulas_-_Despesas" *}
                                    run pi-acompanhar in h-acomp-a (input RETURN-VALUE + ": " + string(tt-detalha-despesa.cod-despesa) + " - " + string(tt-detalha-item.numero-ordem)).
                                
                                    IF LAST-OF(tt-detalha-despesa.cod-despesa) THEN 
                                        ASSIGN bh-dados-excel-detail:BUFFER-FIELD("c-" + REPLACE(tt-detalha-despesa.desc-despesa,CHR(32),"-item-rea")):BUFFER-VALUE      = tt-detalha-despesa.vl-des-rea
                                               bh-dados-excel-detail:BUFFER-FIELD("c-perc-" + REPLACE(tt-detalha-despesa.desc-despesa,CHR(32),"-item-rea")):BUFFER-VALUE = tt-detalha-despesa.per-des-rea.
                                END.    
                                       
                               ASSIGN bh-dados-excel-detail:BUFFER-FIELD("vl-tot-imp-des-rea"):BUFFER-VALUE               = tt-detalha-item.vl-tot-imp-des-rea
                                       bh-dados-excel-detail:BUFFER-FIELD("vl-tot-com-ipi-icms-dsp-merc-rea"):BUFFER-VALUE = tt-detalha-item.vl-tot-com-ipi-icms-rea
                                       bh-dados-excel-detail:BUFFER-FIELD("vl-tot-sem-ipi-icms-dsp-merc-rea"):BUFFER-VALUE = tt-detalha-item.vl-tot-sem-ipi-icms-dsp-merc-rea.
                              
                            END.
                        END.           
                        DELETE tt-detalha-item.
                    END.
                END.
                hQuery:GET-NEXT (NO-LOCK) NO-ERROR.    
            END.
            bh-dados-excel-detail:BUFFER-RELEASE().
        END.
        hQuery:QUERY-CLOSE().
        DELETE OBJECT hQuery.    
        
    END.
END.

run pi-finalizar in h-acomp-a.

procedure display-cabecalho:

    find first tt-embarque-cabec
         where tt-embarque-cabec.embarque     = tt-embarque-corpo.embarque
           and tt-embarque-cabec.cod-estabel  = tt-embarque-corpo.cod-estabel
           and tt-embarque-cabec.cod-emitente = tt-embarque-corpo.cod-emitente
         no-lock no-error.
    IF tt-param.excel THEN DO:
        CREATE tt-dados-excel.
        BUFFER-COPY tt-embarque-cabec EXCEPT tt-embarque-cabec.desc-estab TO tt-dados-excel.
        ASSIGN tt-dados-excel.des-emit       = tt-embarque-cabec.desc-emit
               tt-dados-excel.des-via-transp = {adinc/i01ad268.i 04 tt-embarque-cabec.cod-via-transp}.
    END.
    ELSE
        disp tt-embarque-cabec.cod-estabel
             tt-embarque-cabec.desc-estab
             tt-embarque-cabec.embarque
             tt-embarque-cabec.cod-emitente
             tt-embarque-cabec.desc-emit
             tt-embarque-cabec.pais
             tt-embarque-cabec.cod-incoterm
             tt-embarque-cabec.cod-via-transp
             tt-embarque-cabec.pto-despacho   
             tt-embarque-cabec.data-despacho 
             tt-embarque-cabec.pto-embarque
             tt-embarque-cabec.data-embarque
             tt-embarque-cabec.pto-nacional
             tt-embarque-cabec.pto-chegada   
             tt-embarque-cabec.data-nacional
             tt-embarque-cabec.data-chegada
             tt-embarque-cabec.data-cotacao
             tt-embarque-cabec.desc-moeda
             tt-embarque-cabec.mo-taxa
             tt-embarque-cabec.data-convercao with frame f-cabec-embarque.

end procedure.


