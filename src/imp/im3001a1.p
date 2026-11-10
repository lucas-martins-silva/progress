/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM3001A1 2.00.00.001 } /*** 010001 ***/

{cdp/cd4300.i3} 
{inbo/boin092.i tt-dupli-apagar}
{inbo/boin092.i tt2-dupli-apagar}
{method/dbotterr.i }

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im3001a1 MIM}
&ENDIF

/***** DEFINI€ÇO DE PARAMETROS *****/
DEF INPUT PARAM p-cod-emitente AS INT  NO-UNDO.
DEF INPUT PARAM p-nat-operacao AS CHAR NO-UNDO.
DEF INPUT PARAM p-serie-docto  AS CHAR NO-UNDO.
DEF INPUT PARAM p-nro-docto    AS CHAR NO-UNDO.
/***********************************/

/***** DEFINI€ÇO DE VARIAVEIS *****/
DEF VAR h-boin092            AS HANDLE                        NO-UNDO.
DEF VAR hShowMsg             AS HANDLE                        NO-UNDO.
DEF VAR de-valor-duplic-me LIKE dupli-apagar.valor-a-pagar-me NO-UNDO.
DEF VAR c-cod-esp          LIKE dupli-apagar.cod-esp          NO-UNDO.
DEF VAR da-data              AS DATE   extent 12              NO-UNDO.
DEF VAR da-partida           AS DATE                          NO-UNDO.
DEF VAR dt-vencim            AS DATE   format "99/99/9999"    NO-UNDO.
DEF VAR i-ind                AS INTEGER                       NO-UNDO.
DEF VAR de-vl-apagar       LIKE dupli-apagar.vl-a-pagar       NO-UNDO.
DEF VAR de-vl-apagar-mo    LIKE dupli-apagar.vl-a-pagar       NO-UNDO.
/***********************************/

def var dat-tipo-dia   like calen-coml.tipo-dia no-undo. /*CD9020.i7*/

/***** EXECU€ÇO DO PROGRAMA *****/
DO TRANSACTION ON ERROR UNDO, LEAVE:
    bloco_dupli:
    FOR FIRST docum-est FIELDS (cod-emitente nat-operacao serie-docto nro-docto tot-valor
                                dt-emissao   cod-estabel  nff         usuario   dt-trans)
        WHERE docum-est.cod-emitente = p-cod-emitente
          AND docum-est.nat-operacao = p-nat-operacao
          AND docum-est.serie-docto  = p-serie-docto 
          AND docum-est.nro-docto    = p-nro-docto   NO-LOCK:
     
        FOR FIRST item-doc-est-cex FIELDS (cod-estabel embarque  cod-emitente-desp 
                                           cod-desp    mo-codigo dat-cotac)
            WHERE item-doc-est-cex.cod-emitente = docum-est.cod-emitente
              AND item-doc-est-cex.nat-operacao = docum-est.nat-operacao
              AND item-doc-est-cex.serie-docto  = docum-est.serie-docto 
              AND item-doc-est-cex.nro-docto    = docum-est.nro-docto NO-LOCK
            BY item-doc-est-cex.sequencia:
            
            FOR FIRST desp-imp FIELDS (cod-desp cod-espec-padr tp-despesa)
                WHERE desp-imp.cod-desp = item-doc-est-cex.cod-desp NO-LOCK:
    
                FOR FIRST desp-embarque FIELDS (cod-cond-pag)
                    WHERE desp-embarque.cod-estabel       = item-doc-est-cex.cod-estabel 
                      AND desp-embarque.embarque          = item-doc-est-cex.embarque
                      AND desp-embarque.cod-desp          = desp-imp.cod-desp
                      AND desp-embarque.cod-emitente-desp = item-doc-est-cex.cod-emitente-desp NO-LOCK:
                END.
                IF NOT AVAIL desp-embarque THEN
                    LEAVE bloco_dupli.
            END.
            IF NOT AVAIL desp-imp THEN
                LEAVE bloco_dupli.
        END.
        IF NOT AVAIL item-doc-est-cex THEN
            LEAVE bloco_dupli.
        
        /** CRIA TT-DUPLI-APAGAR **/
        RUN generateTT-dupli-apagar.
        
        RUN inbo/boin092.p PERSISTENT SET h-boin092.

        /** CRIA DUPLI-APAGAR **/
        RUN efetivaTT-dupli-apagar.
        
        DELETE PROCEDURE h-boin092.
        ASSIGN h-boin092 = ?.

        IF RETURN-VALUE = "NOK":U THEN
            UNDO, LEAVE.
    END.
END.
/***********************************/

/** generateTT-dupli-apagar **/
PROCEDURE generateTT-dupli-apagar:

    RUN cdp/cd0812.p (INPUT  0,
                      INPUT  item-doc-est-cex.mo-codigo,
                      INPUT  docum-est.tot-valor,
                      INPUT  item-doc-est-cex.dat-cotac,
                      OUTPUT de-valor-duplic-me).
    
    IF  de-valor-duplic-me = ? THEN
        ASSIGN de-valor-duplic-me = 0.
        
    FOR FIRST emitente FIELDS(ven-domingo ven-sabado ven-feriado)
        WHERE emitente.cod-emitente = item-doc-est-cex.cod-emitente-desp NO-LOCK: 
    END.

    FOR FIRST cond-pagto
        WHERE cond-pagto.cod-cond-pag = desp-embarque.cod-cond-pag NO-LOCK:
    END.
    IF NOT AVAIL cond-pagto THEN NEXT.
    
    ASSIGN da-data    = TODAY
           da-partida = docum-est.dt-emissao.
   
    {cdp/cd9020.i7 docum-est.cod-estabel} /* calculo data de vencimento */    

    IF docum-est.nff THEN
        ASSIGN c-cod-esp = desp-imp.cod-espec-padr.
    ELSE
        FOR FIRST param-re FIELDS (esp-def-dup)
            WHERE param-re.usuario = docum-est.usuario NO-LOCK:
            ASSIGN c-cod-esp = param-re.esp-def-dup.
        END.
        
    DO  i-ind = 1 TO cond-pagto.num-parcelas:    
    
        IF  da-data[i-ind] < TODAY THEN
            ASSIGN dt-vencim = TODAY.
        ELSE
            ASSIGN dt-vencim = da-data[i-ind].
            
        CREATE tt-dupli-apagar.
        ASSIGN tt-dupli-apagar.cod-emitente  = item-doc-est-cex.cod-emitente-desp
               tt-dupli-apagar.dt-vencim     = dt-vencim
               tt-dupli-apagar.dt-emissao    = docum-est.dt-emissao
               tt-dupli-apagar.dt-trans      = docum-est.dt-trans
               tt-dupli-apagar.nat-operacao  = docum-est.nat-operacao
               tt-dupli-apagar.nro-docto     = docum-est.nro-docto
               tt-dupli-apagar.parcela       = string(i-ind)
               tt-dupli-apagar.serie-docto   = docum-est.serie-docto
               tt-dupli-apagar.nr-duplic     = docum-est.nro-docto
               tt-dupli-apagar.tp-despesa    = desp-imp.tp-despesa
               tt-dupli-apagar.cod-esp       = c-cod-esp
               tt-dupli-apagar.mo-codigo     = item-doc-est-cex.mo-codigo
               tt-dupli-apagar.vl-a-pagar    = docum-est.tot-valor
                                             * cond-pagto.per-pg-dup[i-ind] / 100
               tt-dupli-apagar.vl-a-pagar-mo = de-valor-duplic-me
                                             * cond-pagto.per-pg-dup[i-ind] / 100.
    END.
    
    FOR EACH tt-dupli-apagar:
        ASSIGN de-vl-apagar    = de-vl-apagar    + tt-dupli-apagar.vl-a-pagar
               de-vl-apagar-mo = de-vl-apagar-mo + tt-dupli-apagar.vl-a-pagar-mo.
    END.
    
    IF  de-vl-apagar <> docum-est.tot-valor THEN DO:
        FIND LAST tt-dupli-apagar NO-ERROR.
        ASSIGN tt-dupli-apagar.vl-a-pagar = tt-dupli-apagar.vl-a-pagar 
                                          + (docum-est.tot-valor - de-vl-apagar).
    END.
    
    IF  de-vl-apagar-mo <> de-valor-duplic-me THEN DO:
        FIND LAST tt-dupli-apagar NO-ERROR.
        ASSIGN tt-dupli-apagar.vl-a-pagar-mo = tt-dupli-apagar.vl-a-pagar-mo 
                                             + (de-valor-duplic-me - de-vl-apagar-mo).
    END.

    FOR EACH tt-dupli-apagar:
        {rep/re1001c.i50}  /* vari veis e informa‡äes utilizadas pelo re1001c.i51 */        

        assign i-mo-codigo      = tt-dupli-apagar.mo-codigo  
               de-vl-a-pagar-mo = tt-dupli-apagar.vl-a-pagar-mo
               de-vl-descto-mo  = 0.           
        
        {rep/re1001c.i51 "no"}                    
        {cdp/cd4300.i4  "no" tt-dupli-apagar.char-1}   
    END.
    
    RETURN "OK":U.
END PROCEDURE.
/*****************************************/

/** efetivaTT-dupli-apagar **/
PROCEDURE efetivaTT-dupli-apagar:

    RUN openQueryStatic IN h-boin092 ( "Main":U ).

    /** ELIMINA DUPLICATAS EXISTENTES **/
    FOR EACH dupli-apagar FIELDS (parcela) 
        WHERE dupli-apagar.serie-docto  = docum-est.serie-docto 
          AND dupli-apagar.nro-docto    = docum-est.nro-docto   
          AND dupli-apagar.cod-emitente = docum-est.cod-emitente
          AND dupli-apagar.nat-operacao = docum-est.nat-operacao NO-LOCK:

        RUN goToKey IN h-boin092 (INPUT docum-est.serie-docto ,
                                  INPUT docum-est.nro-docto   ,
                                  INPUT docum-est.cod-emitente,
                                  INPUT docum-est.nat-operacao,
                                  INPUT dupli-apagar.parcela).

        RUN deleteRecord IN h-boin092.

        IF  RETURN-VALUE = "NOK":U THEN DO:
            RUN getRowErrors IN h-boin092 (OUTPUT TABLE RowErrors).

            IF  CAN-FIND(FIRST RowErrors) THEN DO:
                {method/showmessage.i1}
                {method/showmessage.i2 &Modal="yes"}
                RETURN "NOK":U.
            END.
        END.
    END.

    /** CRIA NOVAS DUPLICATAS **/
    FOR EACH tt-dupli-apagar
        WHERE tt-dupli-apagar.serie-docto  = docum-est.serie-docto 
          AND tt-dupli-apagar.nro-docto    = docum-est.nro-docto   
          AND tt-dupli-apagar.cod-emitente = docum-est.cod-emitente
          AND tt-dupli-apagar.nat-operacao = docum-est.nat-operacao:

        /* Posiciona Documento/Usuario */
        RUN findDocumEst IN h-boin092 (INPUT docum-est.cod-emitente,
                                       INPUT docum-est.serie-docto,
                                       INPUT docum-est.nro-docto,
                                       INPUT docum-est.nat-operacao).
    
        RUN findUsuario  IN h-boin092 (INPUT docum-est.usuario).
    
        /* Limpa Temp-Table de Itens */
        RUN emptyRowObject IN h-boin092.
    
        EMPTY TEMP-TABLE tt2-dupli-apagar.
        
        CREATE tt2-dupli-apagar.
        BUFFER-COPY tt-dupli-apagar TO tt2-dupli-apagar.

        RUN setRecord    IN h-boin092 (INPUT TABLE tt2-dupli-apagar ).
        RUN createRecord IN h-boin092.
    
        IF  RETURN-VALUE = "NOK":U THEN DO:
            RUN getRowErrors IN h-boin092 (OUTPUT TABLE RowErrors).

            IF  CAN-FIND(FIRST RowErrors) THEN DO:
                {method/showmessage.i1}
                {method/showmessage.i2 &Modal="yes"}
                RETURN "NOK":U.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.
