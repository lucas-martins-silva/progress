/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0402RP 2.00.00.003 } /*** "010003" 14/11/2025 16:15:33 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0402RP MIM}
&ENDIF

{imp/im0402.i} /* tt-param */

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

/* Variables */
DEFINE VARIABLE de-saldo-embarque  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-situacao-parcela AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-di-siscomex      AS CHARACTER   FORMAT "x(15)" NO-UNDO.
DEFINE VARIABLE c-di-ems           AS CHARACTER   FORMAT "x(15)" NO-UNDO.
DEFINE VARIABLE c-tipo-impressao   AS CHARACTER   FORMAT "x(50)" NO-UNDO.
DEFINE VARIABLE c-execucao         AS CHARACTER   FORMAT "x(15)" NO-UNDO.
DEFINE VARIABLE c-destino          AS CHARACTER   FORMAT "x(15)" NO-UNDO.


DEFINE BUFFER b-prazo-compra FOR prazo-compra.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

{include/i-rpvar.i}
{include/i-rpcab.i}
{include/i-rpout.i}

{imp/im0402.i2}

{utp/ut-liter.i "Relat¢rio dos Saldos de Importa‡Æo"}
ASSIGN c-titulo-relat = RETURN-VALUE.

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

RUN pi-processa-relatorio.
{include/i-rpclo.i}

PROCEDURE pi-processa-relatorio:

    IF tt-param.iTipoRelat = 1 /* embarque */ THEN
        RUN pi-processa-embarque.
    ELSE
        RUN pi-processa-di.

    IF tt-param.lImprimeParametros THEN
        RUN pi-imprime-parametros.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-processa-embarque:

    FOR EACH ordens-embarque NO-LOCK
       WHERE ordens-embarque.cod-estabel >= tt-param.cCodEstabIni
         AND ordens-embarque.cod-estabel <= tt-param.cCodEstabFim
         AND ordens-embarque.embarque >= tt-param.cCodEmbarqIni
         AND ordens-embarque.embarque <= tt-param.cCodEmbarqFim,
       FIRST prazo-compra NO-LOCK
       WHERE prazo-compra.numero-ordem = ordens-embarque.numero-ordem
         AND prazo-compra.parcela = ordens-embarque.parcela,
       FIRST item FIELDS(it-codigo desc-item) NO-LOCK
       WHERE item.it-codigo = prazo-compra.it-codigo:
        ASSIGN de-saldo-embarque = 0.

        FOR EACH b-prazo-compra FIELDS(numero-ordem situacao quant-saldo) NO-LOCK
           WHERE b-prazo-compra.numero-ordem = ordens-embarque.numero-ordem
             AND b-prazo-compra.situacao <> 4:
            ASSIGN de-saldo-embarque = de-saldo-embarque + b-prazo-compra.quant-saldo.
        END.
        RUN pi-impressao-embarque.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-impressao-embarque:

    ASSIGN c-situacao-parcela = {ininc/i02in274.i 04 prazo-compra.situacao}.

    DISPLAY ordens-embarque.cod-estabel
            ordens-embarque.embarque
            ordens-embarque.numero-ordem
            prazo-compra.un
            prazo-compra.parcela
            prazo-compra.data-entrega
            ordens-embarque.quantidade
            prazo-compra.quant-receb
            prazo-compra.quant-rejeit
            de-saldo-embarque
            prazo-compra.dec-1 
            prazo-compra.it-codigo
            item.desc-item
            c-situacao-parcela
        WITH FRAME f-embarque.
        DOWN WITH FRAME f-embarque.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-processa-di:
    
FOR EACH decla-import NO-LOCK
       WHERE decla-import.num-di-ems >=  tt-param.iNumDiEmsIni
         AND decla-import.num-di-ems <=  tt-param.iNumDiEmsFim
         AND decla-import.cod-di-siscomex >= tt-param.cCodDiSiscomexIni
         AND decla-import.cod-di-siscomex <= tt-param.cCodDiSiscomexFim:
        RUN pi-impressao-cabecalho-di.

        FOR EACH decla-import-ord NO-LOCK
           WHERE decla-import-ord.num-di-ems = decla-import.num-di-ems
             AND decla-import-ord.cdd-siscomex-dts = decla-import.cdd-siscomex-dts,
           FIRST prazo-compra NO-LOCK
           WHERE prazo-compra.numero-ordem = decla-import-ord.num-ordem
             AND prazo-compra.parcela = decla-import-ord.num-parcela,
           FIRST item FIELDS(it-codigo desc-item) NO-LOCK
           WHERE item.it-codigo = prazo-compra.it-codigo:
            
            ASSIGN de-saldo-embarque = 0.
            FOR EACH b-prazo-compra FIELDS(numero-ordem situacao quant-saldo) NO-LOCK
               WHERE b-prazo-compra.numero-ordem = decla-import-ord.num-ordem
                 AND b-prazo-compra.situacao <> 4:
                ASSIGN de-saldo-embarque = de-saldo-embarque + b-prazo-compra.quant-saldo.
            END.

            RUN pi-impressao-embarques-di.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-impressao-cabecalho-di:
    DEFINE VARIABLE i-tam-campo  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-ano-digito AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-num-seq    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-dig-verif  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-num-orig   AS CHARACTER   NO-UNDO.

    /* formatar o campo DI Siscomex */
    IF decla-import.cod-di-siscomex <> "":U THEN DO:
        ASSIGN c-num-orig = decla-import.cod-di-siscomex.  
        IF LENGTH(decla-import.cod-di-siscomex) >= 4 AND LENGTH(decla-import.cod-di-siscomex) <= 12 THEN DO:
            ASSIGN i-tam-campo  = LENGTH(decla-import.cod-di-siscomex)
                   c-ano-digito = SUBSTRING(decla-import.cod-di-siscomex,1,2)
                   i-num-seq    = INT(SUBSTRING(decla-import.cod-di-siscomex,3,i-tam-campo - 3))
                   c-dig-verif  = SUBSTRING(decla-import.cod-di-siscomex,i-tam-campo,1).
        END.
    END.

    ASSIGN c-di-siscomex = IF i-num-seq <> 0 
                           THEN (c-ano-digito + "/" + STRING(i-num-seq, "999999999") + "-" + c-dig-verif)
                           ELSE decla-import.cod-di-siscomex
           c-di-ems = STRING(decla-import.num-di-ems).

    DISPLAY c-lbl-decalaracao-importacao
            c-di-siscomex               
            c-lbl-data-di               
            decla-import.dat-di         
            c-lbl-di-ems                
            c-di-ems
    WITH FRAME f-cabecalho-di.
    DOWN WITH FRAME f-cabecalho-di.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-impressao-embarques-di:
    ASSIGN c-situacao-parcela = {ininc/i02in274.i 04 prazo-compra.situacao}.

    DISPLAY decla-import-ord.cod-estab    
            decla-import-ord.cod-embarq  
            decla-import-ord.num-ordem   
            prazo-compra.un              
            prazo-compra.parcela         
            prazo-compra.data-entrega    
            decla-import-ord.qtd-item
            prazo-compra.quant-receb     
            prazo-compra.quant-rejeit    
            de-saldo-embarque            
            prazo-compra.dec-1           
            prazo-compra.it-codigo       
            item.desc-item               
            c-situacao-parcela
    WITH FRAME f-embarque-di.
    DOWN WITH FRAME f-embarque-di.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-parametros:

    PAGE.

    DISPLAY c-lbl-selecao
            c-lbl-estabelecimento          
            tt-param.cCodEstabIni
            tt-param.cCodEstabFim
            c-lbl-embarque  
            tt-param.cCodEmbarqIni
            tt-param.cCodEmbarqFim
            c-lbl-declaracao-importacao-ems
            tt-param.iNumDiEmsIni
            tt-param.iNumDiEmsFim
            c-lbl-di-siscomex              
            tt-param.cCodDiSiscomexIni
            tt-param.cCodDiSiscomexFim WITH FRAME f-selecao.

    IF tt-param.iTipoRelat = 1 THEN DO:
        {utp/ut-liter.i "Por embarque"}
    END.
    ELSE DO:
        {utp/ut-liter.i "Por Declara‡Æo de Importa‡Æo"}
    END.
    ASSIGN c-tipo-impressao = RETURN-VALUE.

    DISPLAY c-lbl-parametros
            c-tipo-impressao
    WITH FRAME f-parametros.

    ASSIGN c-execucao = IF tt-param.execucao = 1 THEN c-lbl-online ELSE c-lbl-batch
           c-destino  = IF tt-param.destino = 1 THEN c-lbl-impressora ELSE IF tt-param.destino = 2 THEN c-lbl-arquivo ELSE c-lbl-terminal.

    DISPLAY c-lbl-impressao
            c-lbl-destino
            c-destino
            tt-param.arquivo
            c-lbl-execucao
            c-execucao
            c-lbl-usuario   
            tt-param.usuario WITH FRAME f-impressao.

    RETURN "OK":U.
END PROCEDURE.
