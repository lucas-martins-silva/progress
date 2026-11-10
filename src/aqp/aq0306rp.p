/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0306RP 2.00.00.022 } /*** 010022 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AQ0306RP MAQ}
&ENDIF

/******************************************************************************
**
**       Programa: AQ0306RP.P
**
**       Data....: 14/01/2016.
**
**       Objetivo: Atualiza‡Æo/Desatualiza‡Æo Estoque 
**                 M¢dulo Aquisi‡Æo de Produtos Rurais.
** 
******************************************************************************/
def new shared var h-acomp          as handle                 no-undo.
run utp/ut-acomp.p persistent set h-acomp. 

{cdp/cd9590.i}      /* Variaveis de uso de Unidade de Negocio */
{cdp/cd0666.i}      /* TT-ERRO */
{rep/re1005b.i new} /* Definicao TT-MOVTO      */
{utp/ut-glob.i}
{include/tt-edit.i}
{include/i-rpvar.i} 

DEFINE VARIABLE c-cod-unid-negoc AS CHAR    init ""        NO-UNDO.
DEFINE VARIABLE i-seq-movto      AS INT                    NO-UNDO.
DEFINE VARIABLE i-seq-erro       AS INT                    NO-UNDO.

DEFINE VARIABLE h-ceapi001k      AS HANDLE                 NO-UNDO.
DEFINE VARIABLE h-cdapi024       AS HANDLE                 NO-UNDO.
                                                           
DEFINE VARIABLE c-texto          AS CHAR                   NO-UNDO.
DEFINE VARIABLE l-erro           AS LOG                    NO-UNDO.
DEFINE VARIABLE l-find           AS LOG                    NO-UNDO.
DEFINE VARIABLE l-erro-atualiz   AS LOG                    NO-UNDO.
DEFINE VARIABLE l-erro-api       AS LOG                    NO-UNDO.

DEFINE VARIABLE de-val-quant     LIKE liber-carg.val-quant NO-UNDO.
DEFINE VARIABLE de-quant         LIKE liber-carg.val-quant NO-UNDO. 

DEFINE VARIABLE c-desc-nat-oper  as char format "x(20)"    NO-UNDO.
DEFINE VARIABLE c-desc-nat-ope   as char format "x(13)" initial "Nat Opera‡Æo:" NO-UNDO. 

DEF STREAM s-imp.

DEFINE VARIABLE c-destino-impressao as char format "x(15)" no-undo.

def temp-table tt-print-erro no-undo
    field i-sequen  as int
    FIELD num-carga LIKE liber-carg.num-carg
    field cd-erro   as int
    field mensagem  AS char format "x(255)"
    FIELD tp-msg    AS INT. /*1 Erro - 2 Info*/

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    FIELD num-carga-ini    LIKE liber-carg.num-carg
    FIELD num-carga-fim    LIKE liber-carg.num-carg
    FIELD tp-movimento     AS INTEGER
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG.
    /*Fim alteracao 15/02/2005*/

def temp-table tt-erro-aux NO-UNDO
    LIKE tt-print-erro.

def temp-table tt-raw-digita NO-UNDO                  
    field raw-digita as RAW.

DEFINE BUFFER bfliber-carg FOR liber-carg.
DEFINE BUFFER bftt-erro FOR tt-print-erro.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.    
        
{include/i-rpcab.i}

run utp/ut-acomp.p persistent set h-acomp.

{utp/ut-liter.i Atualiza‡Æo/Desatualiza‡Æo_Estoque_-_AQR MAQ}
assign c-titulo-relat = return-value.
run pi-inicializar in h-acomp (input return-value).

{utp/ut-liter.i Aquisi‡Æo_de_Produtos_Rurais MAQ}    
assign c-programa     = "AQ0306"
       c-versao       = "I.00"
       c-revisao      = "001"
       c-sistema      = RETURN-VALUE
       c-rodape       = "TOTVS - " + c-programa  +  " - V:" + c-versao.
       c-rodape       = fill("-", 132 - length(c-rodape)) + c-rodape.

find first param-global no-lock no-error.
if avail param-global then do:
   assign c-empresa  = param-global.grupo.
end.

FOR FIRST param-estoq FIELDS(log-1 tp-fech mensal-ate) NO-LOCK: END.

{include/i-rpout.i}
view frame f-cabec.
view frame f-rodape.

FIND FIRST tt-param NO-LOCK NO-ERROR.

assign c-destino-impressao = {varinc/var00002.i 04 tt-param.destino}.
/*Atualiza*/
IF tt-param.tp-movimento = 1 THEN DO:

    IF NOT VALID-HANDLE(h-cdapi024) THEN 
        RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.
    
    FOR EACH carg-rural EXCLUSIVE-LOCK
       WHERE carg-rural.num-carg >= tt-param.num-carga-ini
         AND carg-rural.num-carg <= tt-param.num-carga-fim:
        
        /*Somente atualizar estoque com situa‡Æo 3 - Descarga Concluida*/
        IF carg-rural.cdn-sit <> 3 THEN DO:
            {utp/ut-liter.i atualizar *}
            run pi-cria-tt-erro ( 54722, INPUT RETURN-VALUE, INPUT 2). 
            
            /*imprime erro e passa para a proxima carga*/
            FOR EACH tt-print-erro:
                run pi-erro (INPUT tt-print-erro.num-carg,
                             INPUT tt-print-erro.cd-erro,  
                             INPUT tt-print-erro.mensagem, 
                             INPUT NO).
            END.

            EMPTY TEMP-TABLE tt-erro.
            EMPTY TEMP-TABLE tt-print-erro.

            NEXT. 
        END.
        
        bloco:
        DO TRANS ON ERROR UNDO, LEAVE:
            FOR EACH liber-carg FIELDS(num-carg cod-depos num-carg cdn-liber lote dt-vali-lote val-quant val-peso-liq 
                                        &IF "{&product_version}" >= "12.1.C":U &THEN /* 12.1.13 */ 
                                        nr-ficha
                                        &ELSE
                                        num-livre-1
                                        &ENDIF) 
                                        NO-LOCK
               WHERE liber-carg.num-carg = carg-rural.num-carg:

                /*nÆo cria movimento para quantidade zerada*/
                IF liber-carg.val-quant = 0 THEN
                    NEXT.

                IF l-unidade-negocio THEN
                    RUN RetornaUnidadeNegocioExternaliz IN h-cdapi024 (INPUT carg-rural.cod-estabel,
                                                                       INPUT carg-rural.it-codigo,
                                                                       INPUT liber-carg.cod-depos,
                                                                       OUTPUT c-cod-unid-negoc).
        
                FOR FIRST estabelec FIELDS(cod-emitente)
                    WHERE estabelec.cod-estabel = carg-rural.cod-estabel NO-LOCK: 
                END.
        
                FOR FIRST ITEM FIELDS(un)
                    WHERE ITEM.it-codigo = carg-rural.it-codigo NO-LOCK:
                END.
        
                FOR FIRST param-aquis-rural FIELDS(cod-cta-aquis-rural cod-ccusto-aquis-rural)
                    WHERE param-aquis-rural.cod-estabel = carg-rural.cod-estabel NO-LOCK:
                END.

                FOR FIRST item-uni-estab FIELDS(cod-localiz)
                    where item-uni-estab.it-codigo   = carg-rural.it-codigo
                      and item-uni-estab.cod-estabel = carg-rural.cod-estabel no-lock:
                END.

                create tt-movto.
                assign tt-movto.cod-versao-integracao = 1
                       tt-movto.cod-prog-orig   = "AQ0306"
                       tt-movto.cod-emitente    = IF AVAIL estabelec THEN estabelec.cod-emitente ELSE 0
                       tt-movto.nro-docto       = string(liber-carg.num-carg)
                       tt-movto.serie-docto     = ""
                       tt-movto.cod-estabel     = carg-rural.cod-estabel
                       tt-movto.dt-trans        = carg-rural.dat-trans
                       tt-movto.usuario         = c-seg-usuario
                       tt-movto.referencia      = "RFAQ"
                       tt-movto.sequen-nf       = liber-carg.cdn-liber
                       tt-movto.tipo-trans      = 1
                       i-seq-movto              = i-seq-movto + 1
                       tt-movto.i-sequen        = i-seq-movto /* contador */
                       tt-movto.it-codigo       = carg-rural.it-codigo
                       tt-movto.cod-refer       = carg-rural.cod-refer
                       tt-movto.un              = item.un
                       tt-movto.numero-ordem    = 0
                       tt-movto.cod-depos       = liber-carg.cod-depos
                       tt-movto.cod-localiz     = IF AVAIL item-uni-estab THEN item-uni-estab.cod-localiz ELSE ""
                       tt-movto.lote            = liber-carg.lote
                       tt-movto.dt-vali-lote    = liber-carg.dt-vali-lote
                       tt-movto.quantidade      = liber-carg.val-quant
                       tt-movto.ct-codigo       = IF AVAIL param-aquis-rural THEN param-aquis-rural.cod-cta-aquis-rural ELSE ""
                       tt-movto.sc-codigo       = IF AVAIL param-aquis-rural THEN param-aquis-rural.cod-ccusto-aquis-rural ELSE ""
                       tt-movto.esp-docto       = 11 /* EPR - Entrada Produ‡Æo Rural */
                       tt-movto.peso-liquido    = liber-carg.val-peso-liq
                       tt-movto.descricao-db    = ""       
                       tt-movto.cod-unid-negoc  = c-cod-unid-negoc.

                /*Atualiza a quantidade do roteiro de inspe‡Æo*/
                ASSIGN de-val-quant = 0.
                FOR EACH bfliber-carg FIELDS(val-quant) NO-LOCK
                   &IF "{&product_version}" >= "12.1.C":U &THEN /* 12.1.13 */
                   WHERE bfliber-carg.nr-ficha = liber-carg.nr-ficha:
                   &ELSE
                   WHERE bfliber-carg.num-livre-1 = liber-carg.num-livre-1:
                   &ENDIF        
                    ASSIGN de-val-quant = de-val-quant + bfliber-carg.val-quant.
            
                END.
            
                FOR FIRST ficha-cq EXCLUSIVE-LOCK
                   &IF "{&product_version}" >= "12.1.C":U &THEN /* 12.1.13 */                       
                    WHERE ficha-cq.nr-ficha = liber-carg.nr-ficha:
                   &ELSE 
                    WHERE ficha-cq.nr-ficha = liber-carg.num-livre-1:
                   &ENDIF        
                    ASSIGN ficha-cq.qt-original = de-val-quant.
            
                END.
               
            END.

            /*Cria‡Æo do movimento do estoque*/
            IF NOT VALID-HANDLE(h-ceapi001k) THEN
              RUN cep/ceapi001k.p PERSISTENT SET h-ceapi001k.

            IF CAN-FIND(FIRST movto-estoq NO-LOCK /* Verificar se movimento ficar  duplicado */
                        WHERE movto-estoq.serie-docto  = tt-movto.serie-docto
                          AND movto-estoq.nro-docto    = tt-movto.nro-docto
                          AND movto-estoq.cod-emitente = tt-movto.cod-emitente
                          AND movto-estoq.nat-operacao = tt-movto.nat-operacao /* At‚ aqui campos do ¡ndice documento */
                          AND movto-estoq.esp-docto    = tt-movto.esp-docto
                          AND movto-estoq.it-codigo    = tt-movto.it-codigo) THEN DO:

                FOR FIRST movto-estoq NO-LOCK
                    WHERE movto-estoq.serie-docto  = tt-movto.serie-docto 
                      AND movto-estoq.nro-docto    = tt-movto.nro-docto   
                      AND movto-estoq.cod-emitente = tt-movto.cod-emitente
                      AND movto-estoq.nat-operacao = tt-movto.nat-operacao
                      AND movto-estoq.it-codigo    = tt-movto.it-codigo   
                      AND movto-estoq.esp-docto    = tt-movto.esp-docto:
                   
                   OUTPUT STREAM s-imp TO VALUE(SESSION:TEMP-DIRECTORY + "movto-estoq.d":U) APPEND.
                   EXPORT STREAM s-imp movto-estoq.
                   OUTPUT STREAM s-imp CLOSE.
                   
                END.

                FIND LAST tt-erro NO-ERROR.
                IF AVAIL tt-erro THEN
                  ASSIGN i-seq-erro = tt-erro.i-sequen + 1.
                ELSE
                  ASSIGN i-seq-erro = 1.
                
                CREATE tt-erro.
                ASSIGN tt-erro.mensagem    = "Movimento de estoque duplicado. Contate a  rea de Inform tica"
                       tt-erro.cd-erro     = 17006
                       tt-erro.i-sequen    = i-seq-erro.

                /*grava carga e compartimento na tt-erro*/
                FOR EACH tt-erro:
                    CREATE tt-print-erro.
                    ASSIGN tt-print-erro.cd-erro   = tt-erro.cd-erro 
                           tt-print-erro.mensagem  = tt-erro.mensagem
                           tt-print-erro.tp-msg    = 1
                           tt-print-erro.num-carg  = carg-rural.num-carg.
            
                END.
            
                /*Imprime mensagem de erro (1) */
                FOR EACH tt-print-erro WHERE tt-print-erro.tp-msg = 1:

                     run pi-erro (INPUT tt-print-erro.num-carg,
                                  INPUT tt-print-erro.cd-erro,  
                                  INPUT tt-print-erro.mensagem, 
                                  INPUT NO).
                     ASSIGN l-erro-atualiz = YES.
                END.

                UNDO bloco, NEXT.

                                                                                             
            END. /* IF CAN-FIND(FIRST movto-estoq */


            RUN pi-execute IN h-ceapi001k (INPUT-OUTPUT TABLE tt-movto,
                                           INPUT-OUTPUT TABLE tt-erro,
                                           YES).

            IF VALID-HANDLE(h-ceapi001k) THEN
              DELETE PROCEDURE h-ceapi001k.

            /* Caso o processo seja cancelado pelo usu rio, necess rio retornar uma mensagem */
            IF RETURN-VALUE = "NOK":U THEN DO:
              ASSIGN l-erro-atualiz = YES.

              RUN utp/ut-msgs.p (INPUT "help":U,
                                 INPUT 55374,
                                 INPUT "":U).
              
              FIND LAST tt-erro NO-ERROR.
              IF AVAIL tt-erro THEN
                ASSIGN i-seq-erro = tt-erro.i-sequen + 1.
              ELSE
                ASSIGN i-seq-erro = 1.

              CREATE tt-erro.
              ASSIGN tt-erro.mensagem    = RETURN-VALUE
                     tt-erro.cd-erro     = 55374
                     tt-erro.i-sequen    = i-seq-erro.
            END.
            
            /*grava carga e compartimento na tt-erro*/
            FOR EACH tt-erro:
            
                CREATE tt-print-erro.
                ASSIGN tt-print-erro.cd-erro   = tt-erro.cd-erro 
                       tt-print-erro.mensagem  = tt-erro.mensagem
                       tt-print-erro.tp-msg    = 1
                       tt-print-erro.num-carg  = carg-rural.num-carg.
            
            END.
            
            /*Imprime mensagem de erro (1) */
            FOR EACH tt-print-erro WHERE tt-print-erro.tp-msg = 1:
                 run pi-erro (INPUT tt-print-erro.num-carg,
                              INPUT tt-print-erro.cd-erro,  
                              INPUT tt-print-erro.mensagem, 
                              INPUT NO).
                 
                 ASSIGN l-erro-atualiz = YES.
            
            END.
            
            EMPTY TEMP-TABLE tt-erro.
            EMPTY TEMP-TABLE tt-print-erro.
            EMPTY TEMP-TABLE tt-movto.

            /*caso ocorra erro desfaz toda a transa‡Æo*/
            IF l-erro-atualiz = YES THEN 
               UNDO bloco, LEAVE.
    
        END.

        IF NOT l-erro-atualiz THEN DO:
            /* PASSA O STATUS DA CARGA PARA ESTOQUE ATUALIZADO MESMO SEM QUANTIDADE AFERIDA */
            ASSIGN de-quant = 0.
            FOR EACH liber-carg FIELDS(val-quant) NO-LOCK
               WHERE liber-carg.num-carg = carg-rural.num-carg:
                ASSIGN de-quant = de-quant + liber-carg.val-quant.
            END.
    
            IF de-quant = 0 THEN
                run pi-cria-tt-erro (INPUT 54999, INPUT "", INPUT 2). /* Carga com quantidade igual a ZERO! Liberada p/ encerramento. */       
            ELSE
                run pi-cria-tt-erro (INPUT 388, INPUT "", INPUT 2). /*Estoque atualizado com sucesso*/
                
            /* Passa o status para Estoque atualizado */ 
            ASSIGN carg-rural.cdn-sit = 4. /*Atualizado*/
        END.
        
        /*exibe s¢ msg de efetiva‡Æo (2)*/
        FOR EACH tt-print-erro WHERE tt-print-erro.tp-msg = 2:
           
           run pi-erro (INPUT tt-print-erro.num-carg,
                        INPUT tt-print-erro.cd-erro,  
                        INPUT tt-print-erro.mensagem, 
                        INPUT NO).
        END.

        EMPTY TEMP-TABLE tt-print-erro.
        
    END.
    
    IF VALID-HANDLE(h-cdapi024) THEN
        DELETE PROCEDURE h-cdapi024.

END. /*Desatualiza*/
ELSE DO:

    /* DESATUALIZA MàDULO DE ESTOQUE */
    {utp/ut-liter.i Desatualizando_Estoque  MRE R}
    assign c-texto = return-value.
    run pi-acompanhar in h-acomp (input c-texto ).

    FOR EACH carg-rural EXCLUSIVE-LOCK
       WHERE carg-rural.num-carg >= tt-param.num-carga-ini
         AND carg-rural.num-carg <= tt-param.num-carga-fim:
        
        IF carg-rural.cdn-sit <> 4 AND carg-rural.cdn-sit <> 6 THEN DO:
            ASSIGN l-erro-atualiz = YES.
            {utp/ut-liter.i desatualizar *}
            run pi-cria-tt-erro ( 54722, input RETURN-VALUE, INPUT 2).
        END.
        ELSE DO:

            FOR first estab-mat FIELDS(mensal-ate usa-on-line)
                where estab-mat.cod-estabel = carg-rural.cod-estabel no-lock: END.

            /*Verificar se a data de transa‡Æo da carga est  dentro do per¡odo aberto*/
            if  param-estoq.tp-fech = 2 then do:
                if  avail estab-mat and 
                    carg-rural.dat-trans <= estab-mat.mensal-ate then  DO:
                    ASSIGN l-erro-atualiz = YES.
                    run pi-cria-tt-erro ( 1586, input "", INPUT 1).
                END.
            END.
            else DO:
                if  param-estoq.log-1 and carg-rural.dat-trans <= param-estoq.mensal-ate then DO:
                   ASSIGN l-erro-atualiz = YES.
                   run pi-cria-tt-erro ( 1586, input "", INPUT 1). /* Data nao pode ser Inferior ao Ultimo Medio */
                END.
            END.
            
            IF NOT CAN-FIND(FIRST tt-print-erro) THEN DO:
            
                /* MUDA O STATUS DA CARGA PARA DESCARGA CONCLUÍDA, MESMO SEM QUANTIDADE MOVIMENTADA EM ESTOQUE */
                ASSIGN de-quant = 0.
                FOR EACH liber-carg FIELDS(val-quant) NO-LOCK
                   WHERE liber-carg.num-carg = carg-rural.num-carg:
                    ASSIGN de-quant = de-quant + liber-carg.val-quant.
                END.            
                IF de-quant = 0 THEN DO:            
                    {utp/ut-liter.i Desatualiza‡Æo *}
                    run pi-cria-tt-erro ( 28181, input RETURN-VALUE, INPUT 2).                
                END.
                /* MUDA O STATUS....*/   
            
            
                ASSIGN l-erro-atualiz = NO.
                bloco-del:
                DO TRANS ON ERROR UNDO, LEAVE:
                    FOR EACH liber-carg NO-LOCK
                       WHERE liber-carg.num-carg = carg-rural.num-carg:
    
                        {utp/ut-liter.i Carga: *}
                        assign c-texto = return-value.
                        run pi-acompanhar in h-acomp (input c-texto + " " + string(carg-rural.num-carg)).
            
                        FOR FIRST estabelec FIELDS(cod-emitente)
                            WHERE estabelec.cod-estabel = carg-rural.cod-estabel NO-LOCK: 
                        END.

                        for each movto-estoq EXCLUSIVE-LOCK
                           where movto-estoq.cod-emitente   = estabelec.cod-emitente
                             and movto-estoq.serie-docto    = " "
                             and movto-estoq.nro-docto      = string(liber-carg.num-carg)
                             and movto-estoq.nat-operacao   = " "
                             and movto-estoq.sequen-nf      = liber-carg.cdn-liber:
            
                            IF movto-estoq.referencia <> "RFAQ" THEN
                                NEXT.
            
                            FOR first item-uni-estab FIELDS(perm-saldo-neg)
                                where item-uni-estab.it-codigo   = movto-estoq.it-codigo
                                  and item-uni-estab.cod-estabel = movto-estoq.cod-estabel no-lock:
                            END.
            
                            FOR FIRST item FIELDS(perm-saldo-neg)
                                where item.it-codigo = movto-estoq.it-codigo no-lock:
                            END.
            
                            /* Desatualiza saldos em estoque */
                            if  movto-estoq.quantidade <> 0 then do:
                                FOR FIRST saldo-estoq EXCLUSIVE-LOCK
                                    where saldo-estoq.it-codigo   = movto-estoq.it-codigo
                                    and   saldo-estoq.cod-estabel = movto-estoq.cod-estabel
                                    and   saldo-estoq.cod-depos   = movto-estoq.cod-depos
                                    and   saldo-estoq.cod-localiz = movto-estoq.cod-localiz
                                    and   saldo-estoq.lote        = movto-estoq.lote
                                    and   saldo-estoq.cod-refer   = movto-estoq.cod-refer:
            
                                    if  movto-estoq.tipo-trans = 1 then
                                        assign saldo-estoq.qtidade-atu = saldo-estoq.qtidade-atu
                                                                       - movto-estoq.quantidade.
                                    else
                                        assign saldo-estoq.qtidade-atu = saldo-estoq.qtidade-atu
                                                                       + movto-estoq.quantidade.
                
                                    if  (saldo-estoq.qtidade-atu  -
                                         saldo-estoq.qt-alocada   -
                                         saldo-estoq.qt-aloc-prod -
                                         saldo-estoq.qt-aloc-ped   ) < 0 then do:
                                        if avail item-uni-estab then do:
                                           if  item-uni-estab.perm-saldo-neg = 1 then do:
                                               ASSIGN l-erro-atualiz = YES.
                                               run pi-cria-tt-erro ( 8715, input saldo-estoq.it-codigo, INPUT 1).
                                           end.
                                        end.
                                        else do:
                                            if AVAIL ITEM THEN DO: 
                                                IF item.perm-saldo-neg = 1 then DO:
                                                    ASSIGN l-erro-atualiz = YES.
                                                    run pi-cria-tt-erro ( 8715, input saldo-estoq.it-codigo, INPUT 1).
                                                END.
                                            END.
                                        end.
                                    end.
            
                                END.
                            end.
            
                            if AVAIL estab-mat AND estab-mat.usa-on-line then do:
                                FOR FIRST item-estab EXCLUSIVE-LOCK
                                    where item-estab.cod-estabel = movto-estoq.cod-estabel 
                                      and item-estab.it-codigo   = movto-estoq.it-codigo:     
            
                                    if movto-estoq.tipo-trans = 1 then
                                        assign item-estab.qtidade-atu  = item-estab.qtidade-atu
                                                                         - movto-estoq.quantidade.
                                    else
                                        assign item-estab.qtidade-atu  = item-estab.qtidade-atu
                                                                         + movto-estoq.quantidade.
                                
                                END.
                            end.
            
                            /*Desatualiza a quantidade do roteiro de inspe‡Æo*/
                            FOR FIRST ficha-cq EXCLUSIVE-LOCK
                                &IF "{&product_version}" >= "12.1.C":U &THEN /* 12.1.13 */
                                WHERE ficha-cq.nr-ficha = liber-carg.nr-ficha:
                                &ELSE
                                WHERE ficha-cq.nr-ficha = liber-carg.num-livre-1:
                                &ENDIF                              
                                ASSIGN ficha-cq.qt-original = 1
                                       ficha-cq.qt-aprovada = 0.
                            END.
            
                            DELETE movto-estoq.
                            
                            
                        END.

                    END.

                    /*caso ocorra erro desfaz toda a transa‡Æo*/
                    IF l-erro-atualiz = YES THEN DO:
    
                        FOR EACH tt-print-erro WHERE tt-print-erro.tp-msg = 1:
                             run pi-erro (INPUT tt-print-erro.num-carg,
                                          INPUT tt-print-erro.cd-erro,  
                                          INPUT tt-print-erro.mensagem, 
                                          INPUT NO).
                             
                        END.
    
                        EMPTY TEMP-TABLE tt-erro.
                        EMPTY TEMP-TABLE tt-print-erro.
    
                        UNDO bloco-del, LEAVE.
    
                    END.
                    ELSE DO:

                        {utp/ut-liter.i Desatualiza‡Æo *}
                        run pi-cria-tt-erro ( 28181, input RETURN-VALUE, INPUT 2).

                    END.

                END. /*bloco-del*/
                
            END.   

        END.

        FOR EACH tt-print-erro WHERE tt-print-erro.tp-msg = 2:
            run pi-erro (INPUT tt-print-erro.num-carg,
                         INPUT tt-print-erro.cd-erro,  
                         INPUT tt-print-erro.mensagem, 
                         INPUT NO).                           
        END.
        
        EMPTY TEMP-TABLE tt-erro.
        EMPTY TEMP-TABLE tt-print-erro.

        /*caso ocorra erro desfaz toda a transa‡Æo*/
        IF l-erro-atualiz = NO THEN 
           ASSIGN carg-rural.cdn-sit = 3. /*Descarga Completa*/

    END.

    
    /* procedure pi-erro */   

END.

{include/pi-edit.i}
{aqp/aq0306.i}

run pi-finalizar in h-acomp.

{include/i-rpclo.i} /* Include padrao de relatorio */

return "OK".
