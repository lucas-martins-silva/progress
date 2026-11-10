/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9051D 2.00.00.003 } /*** "010003" 09/10/2025 11:26:34 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i bc9051D MBC}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/********************************************************************************************
**   Programa..: bc9051d.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000                                                               **
**                                                                                         **
**   Finalidade: Adapter da transacao de Transferencia e Requisicao de alocados            **
**                                                                                         **
********************************************************************************************/
{cdp/cdcfgman.i}   /* Defini‡Æo preprocessador bf_man_sfc_lc      */
{bcp/bc9051.i}   /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9102.i}   /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9107.i}   /* Campos de comunicacao com o adapter                          */
/*********************************************************************************/

{cpp/cpapi012.i19} /* definicao da ttReqOrd     */
{cpp/cpapi012.i}   /* definicao da tt-requis    */


{cpp/cpapi014.i}
{cpp/cpapi014.i1}


/*********************************************************************************/
Define Input        Parameter pNumTrans    as integer No-undo.
Define Input        Parameter Table For ttIntegracao.
Define Input-Output Parameter Table For tt-erro.
/*********************************************************************************/
Define Variable vRaw                As Raw                  No-undo.
DEFINE VARIABLE vsequencia          AS INTEGER              NO-UNDO.
/*********************************************************************************/

def var hCpapi012       as handle               no-undo.
def var h-handle        as handle               no-undo.

Do:
    Find First ttIntegracao No-lock No-error.
    
    If  Not Avail ttIntegracao Then Do:
        Run utp/ut-msgs.p ( input "msg":U,
                            input 25346,
                            input "bc9005d":U).
        Create  tt-erro.
  
        Assign  tt-erro.cd-erro  = 25346
                tt-erro.i-sequen = vsequencia
                tt-erro.mensagem = trim(return-value).
        Return 'NOK':U.
    End.
    
    Find First tt-erro No-lock No-error.
    If  Avail tt-erro
    Then
        Return "NOK":U.
    ASSIGN error-status:ERROR = NO.
    
    
    bc9051:
    DO on error  undo bc9051, leave bc9051
       on quit   undo bc9051, leave bc9051
       on stop   undo bc9051, leave bc9051
       on endkey undo bc9051, leave bc9051:
       
       
        CREATE tt-transfere-prod-bc.
        ASSIGN tt-transfere-prod-bc.nr-ord-produ            = _RetornaValInte('nr-ord-produ':U)
               tt-transfere-prod-bc.nr-req-sum              = _RetornaValInte('nr-req-sum':U)
               tt-transfere-prod-bc.cod-depos-ent           = _RetornaValChar('cod-depos-ent':U)
               tt-transfere-prod-bc.cod-localiz-ent         = _RetornaValChar('cod-localiz-ent':U)
               tt-transfere-prod-bc.cod-depos-sai           = _RetornaValChar('cod-depos-sai':U)
               tt-transfere-prod-bc.cod-localiz-sai         = _RetornaValChar('cod-localiz-sai':U)
               tt-transfere-prod-bc.it-codigo               = _RetornaValChar('it-codigo':U)
               tt-transfere-prod-bc.cod-refer               = _RetornaValChar('cod-refer':U)
               tt-transfere-prod-bc.lote-serie              = _RetornaValChar('lote-serie':U)
               tt-transfere-prod-bc.quantidade              = _RetornaValDeci('quantidade':U)
               tt-transfere-prod-bc.data-transacao          = _RetornaValData('data-transacao':U)
               tt-transfere-prod-bc.num-documento           = _RetornaValChar('num-documento':U)
               tt-transfere-prod-bc.cod-serie-documento     = _RetornaValChar('cod-serie-documento':U)
               tt-transfere-prod-bc.cod-usuario             = _RetornaValChar('cod-usuario':U)
               .
       
       
        FOR FIRST ord-prod
            WHERE ord-prod.nr-ord-produ = tt-transfere-prod-bc.nr-ord-produ NO-LOCK:
            
            FOR FIRST lin-prod
                WHERE lin-prod.nr-linha = ord-prod.nr-linha NO-LOCK:
                
                IF lin-prod.sum-requis = 1 /* Processo */ THEN DO:
                    run transfereMaterial in this-procedure.
                END.
                ELSE DO: /* Servi‡o */
                    RUN requisitaMaterial IN this-procedure.
                END.
            END.
       END.
       
    END.
    
    if error-status:error = YES OR CAN-FIND (FIRST tt-erro) then do:
        ASSIGN vsequencia =  vsequencia + 1.
        FIND LAST tt-erro NO-LOCK NO-ERROR.
        IF AVAILABLE tt-erro THEN ASSIGN vsequencia = tt-erro.i-sequen + 1.
        create tt-erro.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Problemas_no_processo_PRE-API(bcapi9018)" *}
        assign tt-erro.i-sequen = vsequencia
               tt-erro.cd-erro  = 999
               tt-erro.mensagem = RETURN-VALUE + " " + error-status:get-message(1).
    END.
    
End. /* Do: Main */


PROCEDURE requisitaMaterial: /* Serviï¿½o */
/*******************************************************************************
**
**
**
*******************************************************************************/
    
    DEFINE VARIABLE quantidade-total   AS DECIMAL NO-UNDO.
    DEFINE VARIABLE quantidade-requis  AS DECIMAL NO-UNDO.
    
    ASSIGN quantidade-total = tt-transfere-prod-bc.quantidade.
    
    EMPTY TEMP-TABLE tt-requis.
    EMPTY TEMP-TABLE tt-erro.
    EMPTY TEMP-TABLE ttReqOrd.
    EMPTY TEMP-TABLE ttReqAltern.
    EMPTY TEMP-TABLE ttParam.
    
    /** Requisitar componente **/
    run cpp/cpapi012.p persistent set hcpapi012(input table tt-requis,
                                                input-output table tt-erro,
                                                input yes).
                                                
    RUN pi-recebe-tp-requis IN hCpApi012 (INPUT 2). /*Requisicao Manual */
    
    bloco_aloca:
    FOR EACH aloca-reserva
        WHERE aloca-reserva.nr-ord-produ = tt-transfere-prod-bc.nr-ord-produ
        AND   aloca-reserva.it-codigo    = tt-transfere-prod-bc.it-codigo
        AND   aloca-reserva.cod-refer    = tt-transfere-prod-bc.cod-refer
        AND   aloca-reserva.cod-estabel  = ord-prod.cod-estabel
        AND   aloca-reserva.lote-serie   = tt-transfere-prod-bc.lote-serie
        AND   aloca-reserva.nr-req-sum   = tt-transfere-prod-bc.nr-req-sum
        AND   aloca-reserva.cod-depos    = tt-transfere-prod-bc.cod-depos-sai
        AND   aloca-reserva.cod-localiz  = tt-transfere-prod-bc.cod-localiz-sai NO-LOCK:
        
        ASSIGN quantidade-requis = IF quantidade-total > aloca-reserva.quant-aloc 
                                        THEN aloca-reserva.quant-aloc 
                                        ELSE quantidade-total.
       
            
        FIND FIRST saldo-estoq
            WHERE saldo-estoq.num-id-saldo-estoq = aloca-reserva.num-id-saldo-estoq NO-LOCK NO-ERROR.
        
        create ttReqOrd.
        assign ttReqOrd.dt-saida           = tt-transfere-prod-bc.data-transacao
               ttReqOrd.it-codigo          = aloca-reserva.it-codigo
               ttReqOrd.cod-depos          = aloca-reserva.cod-depos
               ttReqOrd.op-codigo          = aloca-reserva.op-codigo
               ttReqOrd.cod-roteiro        = aloca-reserva.cod-roteiro
               ttReqOrd.lote-serie         = aloca-reserva.lote-serie
               ttReqOrd.dt-vali-lote       = IF AVAILABLE saldo-estoq THEN saldo-estoq.dt-vali-lote ELSE ?
               ttReqOrd.cod-localiz        = aloca-reserva.cod-localiz
               ttReqOrd.tipo-trans         = 1
               ttReqOrd.nr-ord-produ       = aloca-reserva.nr-ord-produ
               ttReqOrd.item-pai           = aloca-reserva.item-pai
               ttReqOrd.cod-estabel        = aloca-reserva.cod-estabel
               ttReqOrd.log-requisitado    = ?
               ttReqOrd.alternativo-de     = "":U
               ttReqOrd.cod-refer          = aloca-reserva.cod-refer
               ttReqOrd.qtd-requisitd-lote = quantidade-requis
               ttReqOrd.qt-requis          = quantidade-requis
               TTReqOrd.qt-aloc            = quantidade-requis
               TTReqOrd.qt-aloc-lote       = quantidade-requis.

        ASSIGN quantidade-total = quantidade-total - quantidade-requis.

        IF quantidade-total <= 0 THEN 
            LEAVE bloco_aloca.
    END.
    
    /** Somente efetiva a transacao se a quantidade separada ficar de acordo com os valores alocados **/
    if quantidade-total > 0 then do:
        {utp/ut-liter.i NÆo_foram_encontradas_aloca‡äes_suficientes_para_atendar_essa_separa‡Æo}
        create tt-erro.
        assign tt-erro.cd-erro = 0
               tt-erro.mensagem = RETURN-VALUE.
        return "NOK":U.
    end.


    create ttParam.
    assign ttParam.nr-ord-produ = ttReqOrd.nr-ord-produ
           ttParam.data-requis  = ttReqOrd.dt-saida
           ttParam.deleta-erros = yes
           ttParam.ver-dt-saida = no
           ttParam.prog-orig    = ?
           ttParam.proc-msg     = 'bc9051d':U.
    
    run pi-requisita-manual in hcpapi012 (input table ttParam,
                                          input table ttReqOrd,
                                          input table ttReqAltern,
                                          input-output table tt-erro).
    
    if not can-find(first tt-erro) then do:
        
        create tt-requis.
        assign tt-requis.cod-versao-integracao  = 001
               tt-requis.tipo-trans             = ttReqOrd.tipo-trans
               tt-requis.nr-ord-produ            = ttReqOrd.nr-ord-produ
               tt-requis.procura-saldos         = yes
               tt-requis.carrega-reservas       = yes
               tt-requis.prog-seg               = 'bc9051d':U
               tt-requis.nro-docto              = string(ttReqOrd.nr-ord-produ) 
               tt-requis.serie-docto            = "":U.

        run pi-processa-requis in hcpapi012 (input table tt-requis,
                                              input-output table tt-erro,
                                              input yes).
        
        if can-find(first tt-erro) then
            RETURN "NOK":U.
    END.
    ELSE 
        RETURN "NOK":U.
        
        
    RETURN "OK":U.
    
END PROCEDURE.


PROCEDURE transfereMaterial: /* Processo */
/*******************************************************************************
**
**
**
*******************************************************************************/
    define variable quantidade-total  as decimal no-undo.
    define variable quantidade-requis as decimal no-undo.
    

    empty temp-table tt-transf.
    empty temp-table tt-req-sum.
    empty temp-table tt-aloca.
    empty temp-table tt-erro.

    assign quantidade-total = tt-transfere-prod-bc.quantidade.


    RUN cpp/cpapi014.p PERSISTENT SET h-handle (input table  tt-transf,
                                                input-output table tt-erro,
                                                input        yes).

    FIND FIRST param-cp NO-LOCK NO-ERROR.



    create tt-transf.
    assign tt-transf.cod-versao-integracao = 001
           tt-transf.nr-req-sum            = ord-prod.nr-req-sum
           tt-transf.tipo-trans            = 1
           tt-transf.cod-estabel           = ord-prod.cod-estabel
           tt-transf.ct-codigo             = param-cp.ct-trans
           tt-transf.sc-codigo             = param-cp.sc-trans
           tt-transf.data                  = tt-transfere-prod-bc.data-transacao
           tt-transf.percentual            = 100
           tt-transf.cod-depos-dest        = tt-transfere-prod-bc.cod-depos-ent
           tt-transf.cod-localiz-dest      = tt-transfere-prod-bc.cod-localiz-ent
           tt-transf.deposito-ini          = ""
           tt-transf.deposito-fim          = "ZZZ"
           tt-transf.item-ini              = ""
           tt-transf.item-fim              = "ZZZZZZZZZZZZZZZZ"
           tt-transf.carrega-req-sum       = FALSE
           tt-transf.loc-ent-unica         = FALSE
           tt-transf.procura-saldos        = FALSE.



    run pi-recebe-tt-transf in h-handle (input table tt-transf).
    run pi-carrega-tt-req-sum in h-handle.

    run pi-retorna-tt-req-sum in h-handle (output table tt-req-sum).
    run pi-retorna-tt-aloca in h-handle (OUTPUT table tt-aloca).


    FOR EACH tt-req-sum EXCLUSIVE-LOCK:
       ASSIGN tt-req-sum.selec = FALSE.
    END.

    FOR EACH tt-aloca EXCLUSIVE-LOCK:
        assign tt-aloca.selec = false.
    END.

    bloco_transfere:
    FOR EACH tt-aloca 
        where tt-aloca.it-codigo    = tt-transfere-prod-bc.it-codigo
        AND   tt-aloca.cod-refer    = tt-transfere-prod-bc.cod-refer
        AND   tt-aloca.lote-serie   = tt-transfere-prod-bc.lote-serie
        AND   tt-aloca.cod-depos    = tt-transfere-prod-bc.cod-depos-sai
        AND   tt-aloca.cod-localiz  = tt-transfere-prod-bc.cod-localiz-sai EXCLUSIVE-LOCK:

        ASSIGN quantidade-requis = IF quantidade-total > tt-aloca.quant-aloc 
                                        THEN tt-aloca.quant-aloc
                                        ELSE quantidade-total.

        assign tt-aloca.selec     = true
               tt-aloca.qt-transf = quantidade-requis.


        ASSIGN quantidade-total = quantidade-total - quantidade-requis.
        
        IF quantidade-total <= 0 THEN
            LEAVE bloco_transfere.

    end.
    
    /** Somente efetiva a transacao se a quantidade separada ficar de acordo com os valores alocados **/
    if quantidade-total > 0 then do:
        {utp/ut-liter.i NÆo_foram_encontradas_aloca‡äes_suficientes_para_atendar_essa_separa‡Æo}
        create tt-erro.
        assign tt-erro.cd-erro = 0
               tt-erro.mensagem = RETURN-VALUE.
        return "NOK":U.
    end.


    run pi-recebe-tt-req-sum in h-handle (INPUT table tt-req-sum).
    run pi-recebe-tt-aloca in h-handle (input table tt-aloca).
    
    run pi-processa-transf in h-handle (input table  tt-transf,
                                       input-output table tt-erro,
                                       input        yes).


    if can-find(first tt-erro) then
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.


