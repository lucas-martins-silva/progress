/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0664RP 2.00.00.012 } /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0664rp MIM}
&ENDIF

/*****************************************************************************
**
**       PROGRAMA: im0664rp.p
**
**       DATA....: Dezembro de 2001
**
**       Objetivo: Demonstrativo EADI
**
**       VERSAO..: 2.00.00.000 - Anderson Dranka
**
******************************************************************************/
{cdp/cdcfgmat.i}
{utp/ut-glob.i}
{include/i-rpvar.i}

/*vari veis locais*/
def var c-return as char no-undo.
def var d-dt-efetiva    like historico-embarque.dt-efetiva no-undo.
def var c-fatura        like invoice-emb-imp.nr-invoice    no-undo.
def var d-dt-vencim     like invoice-emb-imp.dt-vencim     no-undo.
def var d-dt-nacionaliz like historico-embarque.dt-efetiva no-undo.
def var c-observacao    like historico-embarque.observacao no-undo.
def var c-item-un       like item.un                       no-undo.
def var c-desc-pto      as char format "x(30)"             no-undo.
def var d-quantidade    like ordens-embarque.quantidade    no-undo.
def var d-quant-a-nac   like ordens-embarque.quantidade    no-undo.
def var i-pto-eadi      like itinerario.int-1              no-undo.         

/*vari veis para os labels*/
def var c-lb-eadi          as char format "x(05)" no-undo.
def var c-lb-item          as char format "x(05)" no-undo.
def var c-lb-processo      as char format "x(08)" no-undo.
def var c-lb-embarque      as char format "x(08)" no-undo.
def var c-lb-est           as char format "x(03)" no-undo.
def var c-lb-fatura        as char format "x(10)" no-undo.
def var c-lb-dt-vencto     as char format "x(16)" no-undo.
def var c-lb-dt-eadi       as char format "x(12)" no-undo.
def var c-lb-quantidade    as char format "x(04)" no-undo.
def var c-lb-dt-nacionaliz as char format "x(15)" no-undo.
def var c-lb-observacao    as char format "x(10)" no-undo.
def var c-lb-tit-sel       as char format "x(08)" no-undo.
def var c-lb-tit-cla       as char format "x(13)" no-undo.
def var c-lb-tit-imp       as char format "x(15)" no-undo.
def var c-lb-destino       as char format "x(10)" no-undo.
def var c-lb-tit-par       as char format "x(10)" no-undo.
def var c-lb-usuario       as char format "x(10)" no-undo.
def var c-lb-nac           as char format "x(25)" no-undo.
def var c-lb-a-nac         as char format "x(24)" no-undo.
def var c-lb-todos         as char format "x(05)" no-undo.
def var c-considera        as char format "x(25)" no-undo.
def var c-lb-dt-ent-eadi   as char format "x(30)" no-undo.
def var c-lb-vencto-fatura as char format "x(35)" no-undo.
def var c-classificacao    as char format "x(35)" no-undo.
def var c-lb-un            as char format "x(03)" no-undo.
def var c-lb-quant         as char format "x(06)" no-undo.
def var c-lb-saldo         as char format "x(21)" no-undo.
def var c-lb-opcao         as char format "x(45)" no-undo.
def var c-lb-interno       as char format "x(10)" no-undo.
def var c-lb-fornecedor    as char format "x(10)" no-undo.
DEF VAR c-desc-item        AS CHAR FORMAT "x(60)" NO-UNDO.

{imp/im0664.i}  /** Defini‡Æo de temp table  */
{imp/im0664.i2} /** Defini‡Æo de frames *****/

/***************************Defini‡Æo de Parƒmetros *****************************/

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

/****************************** L i t e r a i s **********************************/

{utp/ut-liter.i EADI: * R}
assign c-lb-eadi = trim(return-value).

{utp/ut-liter.i Item: * R}
assign c-lb-item = trim(return-value).

{utp/ut-liter.i Processo * R}
assign c-lb-processo = trim(return-value).

{utp/ut-liter.i Embarque * R}
assign c-lb-embarque = trim(return-value).

{utp/ut-liter.i Est * R}
assign c-lb-est = trim(return-value).

{utp/ut-liter.i Fatura_Com. * R}
assign c-lb-fatura = trim(return-value).

{utp/ut-liter.i Dt_Vencto_Fatura * R}
assign c-lb-dt-vencto = trim(return-value).

{utp/ut-liter.i Dt_Ent._EADI * R}
assign c-lb-dt-eadi = trim(return-value).

{utp/ut-liter.i Qtde * R}
assign c-lb-quantidade = trim(return-value).

{utp/ut-liter.i Data_Nacionaliz * R}
assign c-lb-dt-nacionaliz = trim(return-value).

{utp/ut-liter.i Observa‡Æo * R}
assign c-lb-observacao = trim(return-value).

{utp/ut-liter.i Sele‡Æo * L}
assign c-lb-tit-sel = trim(return-value).

{utp/ut-liter.i Classifica‡Æo * L}
assign c-lb-tit-cla = trim(return-value).

{utp/ut-liter.i ImpressÆo * L}
assign c-lb-tit-imp = trim(return-value).

{utp/ut-liter.i Parƒmetros * L}
assign c-lb-tit-par = trim(return-value).

{utp/ut-liter.i Destino * L}
assign c-lb-destino = trim(return-value).

{utp/ut-liter.i Usu rio * L}
assign c-lb-usuario = trim(return-value).

{utp/ut-liter.i Com_Saldo_a_Nacionalizar * L}
assign c-lb-a-nac = trim(return-value).

{utp/ut-liter.i Totalmente_Nacionalizados * L}
assign c-lb-nac = trim(return-value).

{utp/ut-liter.i Todos * L}
assign c-lb-todos = trim(return-value).

{utp/ut-liter.i Por_Item/Processo/Dt_Ent._EADI * L}
assign c-lb-dt-ent-eadi = trim(return-value).

{utp/ut-liter.i Por_Item/Processo/Dt_Vencto_Fatura * L}
assign c-lb-vencto-fatura = trim(return-value).

{utp/ut-liter.i Un: * L}
assign c-lb-un = trim(return-value).

{utp/ut-liter.i Total: * L}
assign c-lb-quant = trim(return-value).

{utp/ut-liter.i Saldo_a_Nacionalizar: * L}
assign c-lb-saldo = trim(return-value).

{utp/ut-liter.i Estabelecimento * L}
assign tt-param.cod-estabel-ini:label in frame f-param = trim(return-value).

{utp/ut-liter.i Embarque * L}
assign tt-param.embarque-ini:label in frame f-param = trim(return-value).

{utp/ut-liter.i Processo * L}
assign tt-param.processo-ini:label in frame f-param = trim(return-value).

{utp/ut-liter.i Ponto_EADI * L}
assign tt-param.cod-pto-ini:label in frame f-param = trim(return-value).

{utp/ut-liter.i Item * L}
assign tt-param.it-codigo-ini:label in frame f-param = trim(return-value).

{utp/ut-liter.i Dt_efetiva_EADI * L}
assign tt-param.dt-efetiva-eadi-ini:label in frame f-param = trim(return-value).

{utp/ut-liter.i Fatura * L}
assign tt-param.fatura-ini:label in frame f-param = trim(return-value).

{utp/ut-liter.i Interno * L}
assign c-lb-interno = trim(return-value).

{utp/ut-liter.i Fornecedor * L}
assign c-lb-fornecedor = trim(return-value).

{utp/ut-liter.i Ordena_por * L}
assign c-classificacao:label in frame f-param = trim(return-value).

{utp/ut-liter.i Considera_Processos * L}
assign c-considera:label in frame f-param = trim(return-value).
 
{utp/ut-liter.i Unidade * R}
assign c-lb-opcao = c-lb-opcao + " " + trim(return-value).
{utp/ut-liter.i de * R}
assign c-lb-opcao = c-lb-opcao + " " + trim(return-value).
{utp/ut-liter.i Medida * R}
assign c-lb-opcao = c-lb-opcao + " " + trim(return-value).
{utp/ut-liter.i Quantidade * R}
assign c-lb-opcao = c-lb-opcao + ", " + trim(return-value) + ".:".

/****************************** E X E C U € Ç O **********************************/
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.

find first param-global no-lock no-error.
assign c-empresa  = (if avail param-global then param-global.grupo else "")
       c-programa     = "im0664"
       c-versao       = "1.00"
       c-revisao      = "000"
       c-titulo-relat = "Demonstrativo EADI"
       c-sistema      = "Com‚rcio Exterior".      

&if defined(bf-mat-comex) &then
    {cdp/cd-rpout.i} /* include customizada Magnus */
&else    
    {include/i-rpout.i}
&endif

view frame f-cabec.
view frame f-rodape.

/******** LOGICA  DO PROGRAMA ***********************************/

    for each embarque-imp fields(cod-estabel embarque cdn-pto-desembar char-1)
        where embarque-imp.cod-estabel >= tt-param.cod-estabel-ini 
          and embarque-imp.cod-estabel <= tt-param.cod-estabel-fim 
          and embarque-imp.embarque >= tt-param.embarque-ini       
          and embarque-imp.embarque <= tt-param.embarque-fim no-lock:
         assign c-return = "OK".               
         for each ordens-embarque fields(numero-ordem nr-proc-imp quantidade qt-do-forn)
            where ordens-embarque.cod-estabel = embarque-imp.cod-estabel 
              and ordens-embarque.embarque    = embarque-imp.embarque    no-lock:
             
                FOR FIRST ordem-compra no-lock 
                    WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem 
                      and ordem-compra.it-codigo >= tt-param.it-codigo-ini         
                      and ordem-compra.it-codigo <= tt-param.it-codigo-fim.
                END.
                IF AVAIL ordem-compra THEN DO:
                    /*valida processo importa‡Æo*/
                    for first processo-imp fields(nr-proc-imp)
                        where processo-imp.num-pedido   = ordem-compra.num-pedido 
                          and processo-imp.nr-proc-imp >= tt-param.processo-ini   
                          and processo-imp.nr-proc-imp <= tt-param.processo-fim   no-lock:
                    end.
                    IF NOT AVAIL processo-imp THEN NEXT.
                    
                    /*valida faturas do embarque*/
                    if tt-param.fatura-ini <> " " or tt-param.fatura-fim <> "ZZZZZZZZZZZZ" then do:
                        for first invoice-emb-imp fields(nr-invoice)
                              where invoice-emb-imp.cod-estabel = embarque-imp.cod-estabel 
                                and invoice-emb-imp.embarque    = embarque-imp.embarque    
                                and invoice-emb-imp.nr-invoice >= tt-param.fatura-ini 
                                and invoice-emb-imp.nr-invoice <= tt-param.fatura-fim no-lock:
                        end.
                        if not avail invoice-emb-imp then next.
                    end.
             
                    /*valida historico embarque*/
                    for first historico-embarque fields(cod-estabel embarque cod-itiner)
                           where historico-embarque.cod-estabel = embarque-imp.cod-estabel 
                             and historico-embarque.embarque    = embarque-imp.embarque no-lock:
                    end.
                    if not avail historico-embarque then next.

                    /*valida ponto eadi*/
                    for first itinerario fields(cod-itiner int-1 pto-chegada pto-desembarque)
                         where itinerario.cod-itiner = historico-embarque.cod-itiner no-lock:
                    end.
                    if not avail itinerario then next.

                    /* pto-eadi */
                    ASSIGN i-pto-eadi = INTEGER(TRIM(SUBSTRING(embarque-imp.char-1,81,5))).
                    if i-pto-eadi = 0 OR (i-pto-eadi < tt-param.cod-pto-ini OR i-pto-eadi > tt-param.cod-pto-fim) then next.

                    /*valida data efetiva ponto eadi*/                  
                    for first historico-embarque fields(cod-estabel embarque dt-efetiva observacao)
                         where historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
                           and historico-embarque.embarque      = embarque-imp.embarque    
                           and historico-embarque.cod-pto-contr = i-pto-eadi no-lock: /* ponto EADI */
                    end.
                    if avail historico-embarque then do:
                       if (historico-embarque.dt-efetiva < tt-param.dt-efetiva-eadi-ini) or 
                          (historico-embarque.dt-efetiva > tt-param.dt-efetiva-eadi-fim) or
                          (historico-embarque.dt-efetiva = ?) then next.
                       else
                          if (historico-embarque.dt-efetiva = ?) then 
                              assign c-observacao = historico-embarque.observacao. /*colocar como data da ultima previsao*/
                          else            
                              assign d-dt-efetiva = historico-embarque.dt-efetiva
                                     c-observacao = historico-embarque.observacao.
                    end.
                    else next.         
          
                    /*busca data efetiva ponto nacionaliza‡Æo*/  
                    for first historico-embarque fields(dt-efetiva)
                         where historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
                           and historico-embarque.embarque      = embarque-imp.embarque    
                           and historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar no-lock:
                    end.
                    if avail historico-embarque then do:

                       if tt-param.i-sit-processo = 1 and historico-embarque.dt-efetiva <> ? then next.

                       if tt-param.i-sit-processo = 2 then
                           if historico-embarque.dt-efetiva = ? then next.

                       if tt-param.i-sit-processo = 1 or tt-param.i-sit-processo = 3 then do:
                           if historico-embarque.dt-efetiva = ? then do:
                              
                              find first tt-embarque-imp-aux 
                                   where tt-embarque-imp-aux.pto-eadi  = i-pto-eadi
                                     and tt-embarque-imp-aux.it-codigo = ordem-compra.it-codigo no-error.
                              if not avail tt-embarque-imp-aux then do:
                                 create tt-embarque-imp-aux.
                                 assign tt-embarque-imp-aux.cod-estabel = embarque-imp.cod-estabel
                                        tt-embarque-imp-aux.embarque    = embarque-imp.embarque
                                        tt-embarque-imp-aux.pto-eadi    = i-pto-eadi
                                        tt-embarque-imp-aux.it-codigo   = ordem-compra.it-codigo
                                        tt-embarque-imp-aux.quant-a-nac = if tt-param.i-opcao = 1 then ordens-embarque.quantidade else ordens-embarque.qt-do-forn.
                              end.
                              else do:
                                 assign tt-embarque-imp-aux.quant-a-nac = tt-embarque-imp-aux.quant-a-nac + if tt-param.i-opcao = 1 then ordens-embarque.quantidade else ordens-embarque.qt-do-forn.
                              end.
                           end.
                       end.
                       assign d-dt-nacionaliz = historico-embarque.dt-efetiva.             
                    end.
                    
                    /*busca numero e data de vencimento da primeira fatura*/
                    for first invoice-emb-imp fields(nr-invoice dt-vencim)
                         where invoice-emb-imp.cod-estabel = embarque-imp.cod-estabel 
                           and invoice-emb-imp.embarque    = embarque-imp.embarque no-lock:
                    end.
                    if avail invoice-emb-imp then 
                       assign c-fatura    = invoice-emb-imp.nr-invoice
                              d-dt-vencim = invoice-emb-imp.dt-vencim.
                    else 
                       assign c-fatura    = ""
                              d-dt-vencim = ?.

                    for first historico-embarque fields(descricao)
                        where historico-embarque.cod-estabel   = embarque-imp.cod-estabel 
                          and historico-embarque.embarque      = embarque-imp.embarque  
                          and historico-embarque.cod-itiner    = itinerario.cod-itiner
                          and historico-embarque.cod-pto-contr = i-pto-eadi no-lock: /* ponto EADI */
                        assign c-desc-pto = historico-embarque.descricao.
                    end.

                    IF c-desc-pto = "":U THEN DO:
                        /*busca descricao do ponto de controle eadi*/
                        for first pto-contr FIELDS (descricao) NO-LOCK
                           where pto-contr.cod-pto-contr = i-pto-eadi:
                            assign c-desc-pto = pto-contr.descricao.
                        end.
                    END.
                    
                    find item where 
                         item.it-codigo = ordem-compra.it-codigo no-lock no-error.
                    if avail item then
                       assign c-item-un = item.un.

                     /*Dados do Formecedor*/
                     if tt-param.i-opcao = 2 then do:
                         find cotacao-item where 
                              cotacao-item.numero-ordem = ordens-embarque.numero-ordem and
                              cotacao-item.cot-aprovada no-lock no-error.
                         assign c-item-un = if avail cotacao-item then cotacao-item.un else "".
                     end.
                     else
                         assign c-item-un = item.un.

                    FOR FIRST tt-embarque-imp
                        WHERE tt-embarque-imp.cod-estabel  = embarque-imp.cod-estabel and
                              tt-embarque-imp.embarque     = embarque-imp.embarque    and
                              tt-embarque-imp.it-codigo    = ordem-compra.it-codigo   and
                              tt-embarque-imp.nr-proc-imp  = processo-imp.nr-proc-imp no-lock:
                    END.
                    IF NOT AVAIL tt-embarque-imp THEN DO:
                        CREATE tt-embarque-imp.
                        ASSIGN tt-embarque-imp.cod-estabel   = embarque-imp.cod-estabel
                               tt-embarque-imp.embarque      = embarque-imp.embarque
                               tt-embarque-imp.nr-proc-imp   = ordens-embarque.nr-proc-imp
                               tt-embarque-imp.num-pedido    = ordem-compra.num-pedido
                               tt-embarque-imp.it-codigo     = ordem-compra.it-codigo
                               tt-embarque-imp.un            = c-item-un
                               tt-embarque-imp.numero-ordem  = ordem-compra.numero-ordem
                               tt-embarque-imp.pto-eadi      = i-pto-eadi
                               tt-embarque-imp.desc-eadi     = c-desc-pto
                               tt-embarque-imp.fatura        = c-fatura
                               tt-embarque-imp.dt-efetiva    = d-dt-efetiva
                               tt-embarque-imp.dt-nacionaliz = d-dt-nacionaliz
                               tt-embarque-imp.dt-vencim     = d-dt-vencim
                               tt-embarque-imp.observacao    = c-observacao
                               tt-embarque-imp.quantidade    = if tt-param.i-opcao = 1 then ordens-embarque.quantidade else ordens-embarque.qt-do-forn.

                        assign d-dt-efetiva = ?
                               c-fatura     = ""
                               d-dt-vencim  = ?
                               c-item-un    = "".
                    END.
                    ELSE DO:
                        assign tt-embarque-imp.quantidade = tt-embarque-imp.quantidade + if tt-param.i-opcao = 1 then ordens-embarque.quantidade else ordens-embarque.qt-do-forn.
                    END.
                END.
         END.
    END.
    
    if tt-param.i-classificacao = 1 then do:
        for each tt-embarque-imp 
            break by tt-embarque-imp.pto-eadi
                  by tt-embarque-imp.it-codigo
                  by tt-embarque-imp.nr-proc-imp
                  by tt-embarque-imp.dt-efetiva-eadi:
    
            assign d-quantidade = d-quantidade + tt-embarque-imp.quantidade.
    
            if first-of (tt-embarque-imp.pto-eadi) then do:
                   if (line-counter >= 58) then page.
                   disp c-lb-eadi
                        tt-embarque-imp.desc-eadi
                        with frame f-pto-eadi.
                   down with frame f-pto-eadi.                            
            end.

            if first-of(tt-embarque-imp.it-codigo) then do:    
                &if defined(bf-mat-comex) &then
                    FOR FIRST ITEM fields(descricao-1 descricao-2) WHERE
                              ITEM.it-codigo = tt-embarque-imp.it-codigo NO-LOCK:
                    END.
                    IF AVAIL ITEM THEN
                        ASSIGN c-desc-item = ITEM.descricao-1 + ITEM.descricao-2.
                    ELSE c-desc-item = "".
                &else
                    FOR FIRST ITEM fields(desc-item) WHERE
                              ITEM.it-codigo = tt-embarque-imp.it-codigo NO-LOCK:
                    END.
                    IF AVAIL ITEM THEN
                        ASSIGN c-desc-item = ITEM.desc-item.
                    ELSE c-desc-item = "".
                &endif
                if (line-counter >= 58) then page.
                disp c-lb-item
                     tt-embarque-imp.it-codigo
                     c-desc-item
                     c-lb-un
                     tt-embarque-imp.un
                     with frame f-it-codigo.
                down with frame f-it-codigo.
                
                disp c-lb-processo
                     c-lb-embarque
                     c-lb-est    
                     c-lb-fatura       
                     c-lb-dt-vencto    
                     c-lb-dt-eadi      
                     c-lb-quantidade   
                     c-lb-dt-nacionaliz
                     c-lb-observacao         
                     with frame f-lab-cabecalho.                         
                down with frame f-lab-cabecalho.                         
            end.

           
            disp tt-embarque-imp.nr-proc-imp  
                 tt-embarque-imp.embarque     
                 tt-embarque-imp.cod-estabel  
                 tt-embarque-imp.fatura       
                 tt-embarque-imp.dt-vencim
                 tt-embarque-imp.dt-efetiva-eadi      
                 tt-embarque-imp.quantidade   
                 tt-embarque-imp.dt-nacionaliz
                 tt-embarque-imp.observacao 
                 with frame f-embarque-imp.
            down with frame f-embarque-imp.

            
            if last-of (tt-embarque-imp.it-codigo) then do:
                put skip(1).
                if (line-counter >= 58) then page.
                disp c-lb-quant
                     d-quantidade
                     with frame f-quant.
                down with frame f-quant.
                                    
                assign d-quantidade = 0.
                
                for each tt-embarque-imp-aux
                   where tt-embarque-imp-aux.pto-eadi = tt-embarque-imp.pto-eadi 
                     and tt-embarque-imp-aux.it-codigo = tt-embarque-imp.it-codigo:
                    
                    assign d-quant-a-nac = d-quant-a-nac + tt-embarque-imp-aux.quant-a-nac.
                    delete tt-embarque-imp-aux.
                end.
                
                disp c-lb-saldo
                     d-quant-a-nac
                     with frame f-saldo.
                down with frame f-saldo.     

                assign d-quant-a-nac = 0.
            end.
        end.
    end.
    
    if tt-param.i-classificacao = 2 then do:
        for each tt-embarque-imp 
            break by tt-embarque-imp.pto-eadi
                  by tt-embarque-imp.it-codigo
                  by tt-embarque-imp.nr-proc-imp
                  by tt-embarque-imp.dt-vencim:
            
            assign d-quantidade = d-quantidade + tt-embarque-imp.quantidade.
    
            if first-of (tt-embarque-imp.pto-eadi) then do:
                   if (line-counter >= 58) then page.
                   disp c-lb-eadi
                        tt-embarque-imp.desc-eadi
                        with frame f-pto-eadi.
                   down with frame f-pto-eadi.                            
            end.

            if first-of(tt-embarque-imp.it-codigo) then do:    
                if (line-counter >= 58) then page.

                &if defined(bf-mat-comex) &then
                    FOR FIRST ITEM fields(descricao-1 descricao-2) WHERE
                              ITEM.it-codigo = tt-embarque-imp.it-codigo NO-LOCK:
                    END.
                    IF AVAIL ITEM THEN
                        ASSIGN c-desc-item = ITEM.descricao-1 + ITEM.descricao-2.
                    ELSE c-desc-item = "".
                &else
                    FOR FIRST ITEM fields(desc-item) WHERE
                              ITEM.it-codigo = tt-embarque-imp.it-codigo NO-LOCK:
                    END.
                    IF AVAIL ITEM THEN
                        ASSIGN c-desc-item = ITEM.desc-item.
                    ELSE c-desc-item = "".
                &endif

                disp c-lb-item
                     tt-embarque-imp.it-codigo
                     c-desc-item
                     c-lb-un
                     tt-embarque-imp.un
                     with frame f-it-codigo.
                down with frame f-it-codigo.
                
                disp c-lb-processo
                     c-lb-embarque
                     c-lb-est    
                     c-lb-fatura       
                     c-lb-dt-vencto    
                     c-lb-dt-eadi      
                     c-lb-quantidade   
                     c-lb-dt-nacionaliz
                     c-lb-observacao         
                     with frame f-lab-cabecalho.
                down with frame f-lab-cabecalho.                         
            end.
            
            disp tt-embarque-imp.nr-proc-imp  
                 tt-embarque-imp.embarque     
                 tt-embarque-imp.cod-estabel  
                 tt-embarque-imp.fatura       
                 tt-embarque-imp.dt-vencim
                 tt-embarque-imp.dt-efetiva-eadi      
                 tt-embarque-imp.quantidade   
                 tt-embarque-imp.dt-nacionaliz
                 tt-embarque-imp.observacao 
                 with frame f-embarque-imp.
            down with frame f-embarque-imp.

            
            if last-of (tt-embarque-imp.it-codigo) then do:    
                put skip(1).
                if (line-counter >= 58) then page.
                disp c-lb-quant
                     d-quantidade
                     with frame f-quant.
                down with frame f-quant.
                                    
                assign d-quantidade = 0.
                
                for each tt-embarque-imp-aux
                   where tt-embarque-imp-aux.pto-eadi  = tt-embarque-imp.pto-eadi 
                     and tt-embarque-imp-aux.it-codigo = tt-embarque-imp.it-codigo:
                    
                    assign d-quant-a-nac = d-quant-a-nac + tt-embarque-imp-aux.quant-a-nac.
                    delete tt-embarque-imp-aux.
                end.
                
                disp c-lb-saldo
                     d-quant-a-nac
                     with frame f-saldo.
                down with frame f-saldo.                         

                assign d-quant-a-nac = 0.
            end.
        end.
    end.    
    
if tt-param.l-parametro then do:
    page.
    if tt-param.i-classificacao = 1 then
       assign c-classificacao = c-lb-dt-ent-eadi.
    else 
       if tt-param.i-classificacao = 2 then
         assign c-classificacao = c-lb-vencto-fatura.
             
    if tt-param.i-sit-processo = 1 then
      assign c-considera = c-lb-a-nac.
    else 
       if tt-param.i-sit-processo = 2 then
          assign c-considera = c-lb-a-nac.
       else assign c-considera = c-lb-todos.  
       
    assign c-lb-opcao = c-lb-opcao + " " + if tt-param.i-opcao = 1 then c-lb-interno else c-lb-fornecedor. 

    disp c-lb-tit-sel
         tt-param.cod-estabel-ini
         tt-param.cod-estabel-fim
         tt-param.embarque-ini
         tt-param.embarque-fim
         tt-param.processo-ini
         tt-param.processo-fim
         tt-param.cod-pto-ini
         tt-param.cod-pto-fim
         tt-param.it-codigo-ini
         tt-param.it-codigo-fim         
         tt-param.dt-efetiva-eadi-ini
         tt-param.dt-efetiva-eadi-fim
         tt-param.fatura-ini
         tt-param.fatura-fim         
         c-lb-tit-cla
         c-classificacao
         c-lb-tit-par
         c-considera
         c-lb-tit-imp
         c-lb-destino
         tt-param.destino
         tt-param.arquivo
         c-lb-usuario
         c-lb-opcao
         tt-param.usuario
         with frame f-param.
         
end.


/******** FIM DA LOGICA **********************************************/


{include/i-rpclo.i}

RETURN "OK":U.

/* FIM  */


