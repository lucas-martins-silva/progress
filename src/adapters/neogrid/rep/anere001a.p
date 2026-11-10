/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANERE001A 2.00.00.004} /*** "010004" 18/08/2025 18:23:22 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i anere001a MAN}
&ENDIF

/********************************************************************************
** Programa : anere001a.p
** Fun‡Æo   : Efetiva cria‡Æo de docum-est (Receiver de Nota Fiscal) 
** Data     : 05/2001
** Autor    : Sven Siegfried Imfeld 
********************************************************************************/

{inbo/boin090.i tt-docum-est}       /* Defini»’o TT-DOCUM-EST       */
{inbo/boin366.i tt-rat-docum}       /* Defini»’o TT-RAT-DOCUM       */
{inbo/boin366.i tt2-rat-docum}      /* Defini»’o TT-RAT-DOCUM       */
{inbo/boin176.i tt-item-doc-est}    /* Defini»’o TT-ITEM-DOC-EST    */
{inbo/boin176.i tt2-item-doc-est}   /* Defini»’o TT-ITEM-DOC-EST    */
{inbo/boin092.i tt-dupli-apagar}    /* Defini»’o TT-DUPLI-APAGAR    */
{inbo/boin092.i tt2-dupli-apagar}   /* Defini»’o TT-DUPLI-APAGAR    */
{inbo/boin567.i tt-dupli-imp}       /* Defini»’o TT-DUPLI-IMP       */
{inbo/boin567.i tt2-dupli-imp}      /* Defini»’o TT-DUPLI-IMP       */
{inbo/boin366.i1 tt-imposto}        /* Defini»’o TT-IMPOSTO         */
{method/dbotterr.i }                /* Defini»’o RowErrors          */

DEF TEMP-TABLE tt-erro NO-UNDO 
    FIELD identif-segment AS CHAR 
    FIELD cd-erro         AS INTEGER 
    FIELD desc-erro       AS CHAR FORMAT "x(80)".

DEF INPUT PARAM TABLE FOR tt-docum-est.
DEF INPUT PARAM TABLE FOR tt-rat-docum.
DEF INPUT PARAM TABLE FOR tt-item-doc-est.
DEF INPUT PARAM TABLE FOR tt-dupli-apagar.
DEF INPUT PARAM TABLE FOR tt-dupli-imp.
DEF OUTPUT PARAM TABLE FOR tt-erro.

DEF VAR h-boin090           AS HANDLE  NO-UNDO.
DEF VAR h-boin366           AS HANDLE  NO-UNDO.
DEF VAR h-boin176           AS HANDLE  NO-UNDO.
DEF VAR h-boin092           AS HANDLE  NO-UNDO.
DEF VAR h-boin567           AS HANDLE  NO-UNDO.
DEF VAR h-boin404           AS HANDLE  NO-UNDO.
DEF VAR h-boin223           AS HANDLE  NO-UNDO.
DEF VAR l-erro-create       AS LOGICAL NO-UNDO.
DEF VAR l-terceiros         AS LOGICAL NO-UNDO.
DEF VAR c_id_reg_bloco      AS CHAR    NO-UNDO.

ASSIGN l-erro-create = no.

FOR EACH tt-docum-est:
    DO TRANSACTION ON ERROR UNDO, LEAVE:
  
        ASSIGN c_id_reg_bloco = tt-docum-est.serie-docto          + CHR(24) +
                                tt-docum-est.nro-docto            + CHR(24) +
                                STRING(tt-docum-est.cod-emitente) + CHR(24) +
                                tt-docum-est.nat-operacao.

        RUN inbo/boin090.p PERSISTENT SET h-boin090.
    
        FOR FIRST natur-oper
            FIELDS (nat-operacao tp-oper-terc terceiros nota-rateio tipo-compra)
             WHERE natur-oper.nat-operacao = tt-docum-est.nat-operacao NO-LOCK: 
        END.        
    
        IF AVAIL natur-oper
        AND natur-oper.tipo-compra = 4 THEN /* Material Agregado */
            ASSIGN tt-docum-est.mod-atual = 1.
    
        /* Documento Importado */
        ASSIGN tt-docum-est.origem = "i". 

        RUN pi-atualiza-docum-est.
       
        IF NOT l-erro-create THEN DO:
            
            /* ---------- NOTA DE RATEIO ---------- */
            IF AVAIL natur-oper
            AND natur-oper.nota-rateio THEN DO:    
                FOR EACH tt-rat-docum OF tt-docum-est :
                    /* Estancia BO Rat-Docum, caso o mesma n’o esteja dispon­vel */
                    IF NOT VALID-HANDLE(h-boin366) THEN DO:
                        RUN inbo/boin366.p PERSISTENT SET h-boin366.
                        RUN openQueryStatic IN h-boin366 ( "Main":U ).
                    END.
                    RUN pi-atualiza-rat-docum.
                END.
                
                /* Gera»’o dos itens da nota de rateio */
                RUN pi-atualiza-item-rateio.
                
                /* Elimina Handle BO Rat-Docum */
                IF VALID-HANDLE(h-boin366) THEN  
                    RUN destroy IN h-boin366.
            END.       
            
            /* ---------- ITENS DA NOTA FISCAL ---------- */
            FOR EACH tt-item-doc-est OF tt-docum-est :
                /* Estancia BO Item-Doc-Est, caso o mesma n’o esteja dispon­vel */
            
                IF NOT VALID-HANDLE(h-boin176) THEN DO:
                    RUN inbo/boin176.p PERSISTENT SET h-boin176.
                    RUN openQueryStatic IN h-boin176 ( "Main":U ).
                END.
              
                IF AVAIL natur-oper
                AND natur-oper.terceiros
                AND natur-oper.tp-oper-terc = 2 
                AND tt-item-doc-est.nro-comp = "" THEN  
                    RUN pi-atualiza-terceiros.
                ELSE  
                    RUN pi-atualiza-item-doc-est.
            END.
            
            IF VALID-HANDLE(h-boin176) THEN DO:
    
                IF l-terceiros THEN  
                    RUN pi-seleciona-saldo-terc.
                ELSE DO: 
                    RUN setHandleDocumEst       IN h-boin176 ( INPUT h-boin090 ).
                    
                    RUN transferTotalItensNota  IN h-boin176 ( INPUT tt-docum-est.cod-emitente,
                                                               INPUT tt-docum-est.serie-docto,
                                                               INPUT tt-docum-est.nro-docto,
                                                               INPUT tt-docum-est.nat-operacao ).
                END.
            
                /* -------------- ACABADO ------------- */
                IF AVAIL natur-oper
                AND natur-oper.tipo-compra = 4 THEN DO:
                    /* Estancia BO Rat-Docum, caso o mesma n’o esteja dispon­vel */
                    IF NOT VALID-HANDLE(h-boin223) THEN DO:
                        RUN inbo/boin223.p PERSISTENT SET h-boin223.
                        RUN openQueryStatic IN h-boin223 ( "Main":U ).
                    END.
                    
                    RUN pi-atualiza-acabado.
                END.
    
                /* Elimina Handle BO Item-Doc-Est, BO Saldo-Terc e BO Movto-Pend */                                                           
                IF VALID-HANDLE(h-boin176) THEN  
                    RUN destroy IN h-boin176.
                
                IF VALID-HANDLE(h-boin404) THEN  
                    RUN destroy IN h-boin404.
    
                IF VALID-HANDLE(h-boin223) THEN  
                    RUN destroy IN h-boin223.
            END.            
    
            /* ---------- DUPLICATAS DA NOTA FISCAL ---------- */
            FOR EACH tt-dupli-apagar OF tt-docum-est :
                
                /* Estancia BO Dupli-Apagar, caso o mesma n’o esteja dispon­vel */
                IF NOT VALID-HANDLE(h-boin092) THEN DO:
                    RUN inbo/boin092.p PERSISTENT SET h-boin092.
                    RUN openQueryStatic IN h-boin092 ( "Main":U ).
                END.
    
                RUN pi-atualiza-dupli-apagar.
                
                FOR EACH tt-dupli-imp OF tt-dupli-apagar : 
                    
                    /* Estancia BO Dupli-Imp, caso o mesma n’o esteja dispon­vel */
                    IF NOT VALID-HANDLE(h-boin567) THEN DO:
                        RUN inbo/boin567.p PERSISTENT SET h-boin567.
                        RUN openQueryStatic in h-boin567 ( "Main":U ).
                    END.
    
                    RUN pi-atualiza-dupli-imp.
                END.             
            END.

            /* Elimina Handle BO Dupli-Apagar */
            IF VALID-HANDLE(h-boin092) THEN  
                RUN destroy IN h-boin092.
        
            /* Elimina Handle BO Dupli-Imp */
            IF VALID-HANDLE(h-boin567) THEN  
                RUN destroy IN h-boin567.
        END.
    
        IF VALID-HANDLE(h-boin090) THEN  
            RUN destroy IN h-boin090.

        IF l-erro-create THEN  
            UNDO, LEAVE.
    END.  
END.

/* ----------------------------- PROCEDURES INTERNAS ----------------------------- */

PROCEDURE PI-ATUALIZA-DOCUM-EST :

    /* Abertura de Query */
    RUN openQueryStatic IN h-boin090 ( "Main":U ).
    
    /* Transfere TT-DOCUM-EST para BO */
    RUN setRecord IN h-boin090 ( INPUT TABLE tt-docum-est ).

    /* Determina Defaults da Nota Fiscal */
    RUN setDefaultsNota IN h-boin090.

    /* Cria DOCUM-EST */    
    RUN createRecord IN h-boin090.

    IF RETURN-VALUE = "NOK":U THEN  
        RUN pi-gera-erros ( INPUT h-boin090 ).

END PROCEDURE.

/* --------------------------------- */

PROCEDURE PI-ATUALIZA-RAT-DOCUM :

    /* Limpa Temp-Table de Itens */
    RUN emptyRowObject IN h-boin366.
           
    FOR EACH tt2-rat-docum.
        DELETE tt2-rat-docum.
    END.               

    /* Como a BO somente trabalha com 1 registro, o conteœdo da temp-table 
       ² transferido para outra temp-table id¼ntica */

    CREATE tt2-rat-docum.
    BUFFER-COPY tt-rat-docum TO tt2-rat-docum.
    
    /* Transfere TT-RAT-DOCUM para BO */
    RUN setRecord IN h-boin366 ( INPUT TABLE tt2-rat-docum ).

    /* Cria RAT-DOCUM */    
    RUN createRecord IN h-boin366.

    IF RETURN-VALUE = "NOK":U THEN 
        RUN pi-gera-erros ( INPUT h-boin366 ).

END PROCEDURE.           

/* --------------------------------- */

PROCEDURE PI-ATUALIZA-ITEM-DOC-EST :

    /* Atualiza Fun»’o FIFO nas Ordens de Compra */
    IF (tt-item-doc-est.num-pedido <> 0 
    OR  tt-item-doc-est.numero-ordem <> 0 )
    AND tt-item-doc-est.parcela = 0 THEN  
        ASSIGN tt-item-doc-est.log-1 = YES.

    /* Acessa Chave do Documento */
    RUN linktoDocumEst IN h-boin176 ( INPUT h-boin090 ).
    
    /* Limpa Temp-Table de Itens */
    RUN emptyRowObject IN h-boin176.
           
    FOR EACH tt2-item-doc-est.
        DELETE tt2-item-doc-est.
    END.               

    /* Como a BO somente trabalha com 1 registro, o conteœdo da temp-table 
       ² transferido para outra temp-table id¼ntica */
       
    CREATE tt2-item-doc-est.
    BUFFER-COPY tt-item-doc-est TO tt2-item-doc-est.
    
    /* Transfere TT-ITEM-DOC-EST para BO */
    RUN setRecord IN h-boin176 ( INPUT TABLE tt2-item-doc-est ).
    
    /* Cria ITEM-DOC-EST */
    RUN createRecord IN h-boin176.

    IF RETURN-VALUE = "NOK":U THEN 
        RUN pi-gera-erros ( INPUT h-boin176 ).

END PROCEDURE.

/* --------------------------------- */

PROCEDURE PI-ATUALIZA-DUPLI-APAGAR :

    /* Posiciona Documento/Usuario */
    RUN findDocumEst IN h-boin092 (INPUT tt-docum-est.cod-emitente,
                                   INPUT tt-docum-est.serie-docto,
                                   INPUT tt-docum-est.nro-docto,
                                   INPUT tt-docum-est.nat-operacao).

    RUN findUsuario IN h-boin092 (INPUT tt-docum-est.usuario).

    /* Limpa Temp-Table de Itens */
    RUN emptyRowObject IN h-boin092.
           
    FOR EACH tt2-dupli-apagar.
        DELETE tt2-dupli-apagar.
    END.               

    /* Como a BO somente trabalha com 1 registro, o conteœdo da temp-table 
       ² transferido para outra temp-table id¼ntica */

    CREATE tt2-dupli-apagar.
    BUFFER-COPY tt-dupli-apagar TO tt2-dupli-apagar.
    
    /* Transfere TT-DUPLI-APAGAR para BO */
    RUN setRecord IN h-boin092 (INPUT TABLE tt2-dupli-apagar ).

    /* Seta Default Tipo Despesa */
    RUN setDefaultTpDespesa IN h-boin092.
    
    /* Seta Default Esp²cie */
    RUN setDefaultCodEsp IN h-boin092.
    
    /* Cria DUPLI-APAGAR */    
    RUN createRecord IN h-boin092.

    IF RETURN-VALUE = "NOK":U THEN 
        RUN pi-gera-erros (INPUT h-boin092).

END PROCEDURE.

/* --------------------------------- */

PROCEDURE PI-ATUALIZA-DUPLI-IMP :
    
    /* Limpa Temp-Table de Itens */
    RUN emptyRowObject IN h-boin567.
           
    FOR EACH tt2-dupli-imp.
        DELETE tt2-dupli-imp.
    END.               

    /* Como a BO somente trabalha com 1 registro, o conteœdo da temp-table 
       ² transferido para outra temp-table id¼ntica */

    CREATE tt2-dupli-imp.
    BUFFER-COPY tt-dupli-imp TO tt2-dupli-imp.
    
    /* Transfere TT-DUPLI-IMP para BO */
    RUN setRecord IN h-boin567 (INPUT TABLE tt2-dupli-imp).

    /* Cria DUPLI-IMP */    
    RUN createRecord IN h-boin567.

    IF RETURN-VALUE = "NOK":U THEN 
        RUN pi-gera-erros (INPUT h-boin567).

END PROCEDURE.

/* --------------------------------- */

PROCEDURE PI-ATUALIZA-ITEM-RATEIO :

    /* Acessa Chave do Documento */
    RUN linktoDocumEst IN h-boin366 (INPUT h-boin090).
    
    /* Acessa natureza de operacao */
    RUN findNaturOper IN h-boin366 (tt-docum-est.nat-operacao).
    
    /* Cria tt-imposto */
    RUN getTTImposto IN h-boin366 (OUTPUT TABLE tt-imposto).

    IF VALID-HANDLE(h-boin176) THEN
       RUN setHandleItemDocumEst in h-boin366 (input h-boin176 ).   

    /* Cria itens da nota */
    RUN createRateio IN h-boin366.

    IF RETURN-VALUE = "NOK":U THEN 
        RUN pi-gera-erros (INPUT h-boin366 ).

END PROCEDURE.

/* --------------------------------- */

PROCEDURE PI-ATUALIZA-ACABADO :

    RUN findDocumento IN h-boin223 (tt-docum-est.cod-emitente,
                                    tt-docum-est.serie-docto,
                                    tt-docum-est.nro-docto,
                                    tt-docum-est.nat-operacao).

    RUN createAcabadoByOP IN h-boin223.                        

    IF RETURN-VALUE = "NOK":U THEN 
        RUN pi-gera-erros (INPUT h-boin223 ).

END PROCEDURE.

/* --------------------------------- */

PROCEDURE PI-ATUALIZA-TERCEIROS :

    /* Estancia BO Saldo-terc, caso o mesma n’o esteja dispon­vel */
    IF NOT VALID-HANDLE(h-boin404) THEN DO:
        RUN inbo/boin404re.p PERSISTENT SET h-boin404.
    END.
       
    RUN createItemEstrutbyItem IN h-boin404 (tt-item-doc-est.it-codigo,  
                                             tt-item-doc-est.quantidade,
                                             tt-item-doc-est.preco-unit[1],
                                             tt-item-doc-est.preco-total[1],
                                             tt-item-doc-est.nr-ord-prod).
    ASSIGN l-terceiros = YES.

    IF RETURN-VALUE = "NOK":U THEN 
        RUN pi-gera-erros (INPUT h-boin366).

END PROCEDURE.

/* --------------------------------- */

PROCEDURE PI-SELECIONA-SALDO-TERC:

    RUN selectSaldoTercbyFIFO IN h-boin404 (h-boin090,
                                            h-boin176,
                                            tt-docum-est.cod-emitente,
                                            tt-docum-est.cod-estabel,
                                            tt-docum-est.nat-operacao,
                                            1, /* Tipo de operacao - Rec. Fisico */
                                            tt-docum-est.dt-trans).                                            

    IF RETURN-VALUE = "NOK":U THEN 
        RUN pi-gera-erros ( INPUT h-boin366 ).

END PROCEDURE.

/* --------------------------------- */

PROCEDURE PI-GERA-ERROS :
        
    DEF INPUT PARAM piHandle AS HANDLE NO-UNDO.
            
    RUN getRowErrors IN piHandle (OUTPUT TABLE RowErrors).
    
    FOR EACH RowErrors 
        WHERE RowErrors.ErrorSubType = "ERROR":U:
        
        FIND FIRST tt-erro
             WHERE tt-erro.identif-segment  = c_id_reg_bloco 
               AND tt-erro.cd-erro          = RowErrors.ErrorNumber
               AND tt-erro.desc-erro        = RowErrors.ErrorDescription NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-erro THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.identif-segment  = c_id_reg_bloco 
                   tt-erro.cd-erro          = RowErrors.ErrorNumber
                   tt-erro.desc-erro        = RowErrors.ErrorDescription .
        END.
    END.        

    IF CAN-FIND(FIRST RowErrors 
                WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
       ASSIGN l-erro-create = YES.

END PROCEDURE.

/* fim do programa */

