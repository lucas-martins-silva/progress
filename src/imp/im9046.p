/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9046 2.00.00.030 } /*** "010030" 04/07/2024 10:42:27 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im9046 MIM}
&ENDIF

/*****************************************************************************
**
** Programa: IM9046
** Autor...: Datasul S.A.
** Objetivo: Gerar os movimentos de entrada ou de baixa para o Ato 
**           Concessorio, tendo como base os itens do documento no recebimento                    
**
******************************************************************************/
    /** Temp-table tt-erro **/
    {cdp/cd0666.i}
    /** Pre-processadores **/
    {cdp/cdcfgdis.i}
    {cdp/cdcfgmat.i}            /* Preprocessadores Materiais */
    {include/tt-edit.i}
    /** Variaveis Globais **/
    {utp/ut-glob.i}
    {cxbo/bocx332.i tt-movto-ato}
    {cxbo/bocx315.i tt-pedido-drb-item}

    define input        parameter rItemDocEst    as rowid     no-undo.
    DEFINE INPUT        PARAMETER l-mostra-cabec AS LOGICAL   NO-UNDO.
    define input-output parameter table for tt-erro.
    define input-output parameter l-erro         AS LOGICAL   NO-UNDO.

    define variable cPeriodo              as character                            no-undo.
    define variable iSequenciaMovto       as integer initial 1                    no-undo.
    define variable deTotQuant            as decimal format   ">>>>>,>>9.9999":U  no-undo.
    define variable deTotQuantEntrada     as decimal format   ">>>>>,>>9.9999":U  no-undo.
    define variable deTotQuantBaixa       as decimal format   ">>>>>,>>9.9999":U  no-undo.
    define variable deValMovtoAtoMeConv   as decimal format ">,>>>,>>>,>>9.99":U  no-undo.
    define variable deValBaixa            as decimal format ">,>>>,>>>,>>9.99":U  no-undo.
    define variable deValorConv           as decimal format ">,>>>,>>>,>>9.99":U  no-undo.
	DEFINE VARIABLE deValorConvNac        AS DECIMAL INITIAL 0 FORMAT ">,>>>,>>>,>>9.99":U  NO-UNDO.
    DEFINE VARIABLE deTotValor            AS DECIMAL FORMAT  ">,>>>,>>>,>>9.99":U NO-UNDO.
    DEFINE VARIABLE deValMovtoNovaImp     AS DECIMAL FORMAT ">,>>>,>>>,>>9.99":U  NO-UNDO.
    define variable de-quant-saldo        as decimal                              no-undo.
    define variable de-valor-saldo        as decimal                              no-undo.
    DEFINE VARIABLE de-tot-quant-ent      AS DECIMAL                              NO-UNDO.
    DEFINE VARIABLE de-tot-valor-ent      AS DECIMAL                              NO-UNDO.
    DEFINE VARIABLE l-drawback-integrado  AS LOGICAL INITIAL NO                   NO-UNDO.
    DEFINE VARIABLE c-priorid-bxa         AS CHARACTER   NO-UNDO.

    /*Nota Fiscal Simples Remessa*/
    define variable i-num-ord-import  as integer    format 'zzzzz9,99' no-undo.
    define variable i-num-parc-import as integer    format '>>>>9'     no-undo.

    define variable iSequenciaErro    as integer initial 1             no-undo.
    DEFINE VARIABLE c-mensagem        AS CHARACTER                     NO-UNDO.
    DEFINE VARIABLE c-parametros      AS CHARACTER                     NO-UNDO.
    DEFINE VARIABLE l-erro-valor      AS LOGICAL                       NO-UNDO.

    DEF VAR d-novo-saldo-proporcional AS DECIMAL NO-UNDO.
    DEF VAR d-qtd-saldo-aux   AS DECIMAL FORMAT ">>>>>,>>9.9999":U NO-UNDO.
    DEF VAR d-val-saldo-aux   AS DECIMAL FORMAT ">>>>>,>>9.9999":U NO-UNDO.
    DEF VAR d-tot-qtd-ent-aux AS DECIMAL FORMAT ">>>>>,>>9.9999":U NO-UNDO.
    DEF VAR d-tot-qtd-sai-aux AS DECIMAL FORMAT ">>>>>,>>9.9999":U NO-UNDO.
    DEF VAR de-novo-valor     AS DECIMAL FORMAT ">>>>>,>>9.9999":U NO-UNDO.
    DEF VAR i-tip-item-movto  AS INTEGER                           NO-UNDO. /* 1 - internacional; 2 - nacional */
    DEFINE VARIABLE de-qtde-tot-movto     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-valor-tot-movto    AS DECIMAL     NO-UNDO.
    DEF VAR h-bocx332 AS HANDLE NO-UNDO.
    DEF VAR h-bocx315 AS HANDLE NO-UNDO.

    DEF VAR i-moeda-movto AS INTEGER NO-UNDO.

    DEF VAR l-transf-drb     AS LOG NO-UNDO.
    DEF VAR d-qtd-transf-drb LIKE item-doc-est.quantidade NO-UNDO.

    {include/i-epc200.i "im9046"}
    {rep/re1005.i01}
    IF c-nom-prog-upc-mg97  <> "" OR
       c-nom-prog-appc-mg97 <> "" OR
       c-nom-prog-dpc-mg97  <> "" THEN DO:

       FOR EACH tt-epc WHERE tt-epc.cod-event = "Before-create-movto-ato":
           DELETE tt-epc.
       END.

       CREATE tt-epc.
       ASSIGN tt-epc.cod-event = "Before-create-movto-ato"
              tt-epc.cod-parameter = "rowid-item-doc-est"
              tt-epc.val-parameter = string(rItemDocEst).

       CREATE tt-epc.
       ASSIGN tt-epc.cod-event = "Before-create-movto-ato"
              tt-epc.cod-parameter = "Handle-tt-erro"
              tt-epc.val-parameter = string(temp-table tt-erro:handle).

       {include/i-epc201.i "Before-Create-Movto-ato"}

       IF CAN-FIND(FIRST tt-epc WHERE
                         tt-epc.cod-event = "Before-create-movto-ato" AND
                         tt-epc.cod-parameter = "Error-Return-movto-ato" AND
                         tt-epc.val-parameter = "Error") THEN DO:
           assign l-erro = yes.
           return "Nok":u.
       END.
       ELSE DO:
           IF CAN-FIND(FIRST tt-epc WHERE
                             tt-epc.cod-event = "Before-create-movto-ato" AND
                             tt-epc.cod-parameter = "Valid-Return-movto-ato") THEN 
               RETURN "Ok":u.
       END.
    END.

    bloco:
    do transaction on error undo bloco, return "NOK":U:       

        find item-doc-est 
            where rowid(item-doc-est) = rItemDocEst no-lock no-error.

        ASSIGN l-erro-valor = NO.
        find docum-est of item-doc-est exclusive-lock no-error.

        IF i-pais-impto-usuario <> 1 AND
           CAN-FIND (FIRST param-global
                     WHERE param-global.log-modul-draw) AND            
           CAN-FIND(FIRST natur-operac-internac 
                    WHERE natur-operac-internac.cod-natur-operac = docum-est.nat-operacao 
                      AND natur-operac-internac.log-transf-draw) AND
           CAN-FIND (FIRST embarq-import-docto
                     WHERE embarq-import-docto.cod-estab        = docum-est.cod-estabel
                       and embarq-import-docto.cod-embarq       = SUBSTRING(docum-est.char-1,1,20)
                       and embarq-import-docto.cod-ser-docto    = docum-est.serie-docto
                       and embarq-import-docto.cod-docto        = docum-est.nro-docto
                       and embarq-import-docto.cdn-emitente     = docum-est.cod-emitente
                       and embarq-import-docto.cod-natur-operac = docum-est.nat-operacao
                       and embarq-import-docto.log-transf-draw) THEN DO:

            ASSIGN l-transf-drb = YES.

             ASSIGN d-qtd-transf-drb = 0.
             for first ordens-embarque
                 where ordens-embarque.numero-ordem = item-doc-est.numero-ordem
                   and ordens-embarque.parcela      = item-doc-est.parcela
                   and trim(substring(ordens-embarque.char-1,1,20)) = item-doc-est.nr-ato-concessorio:
                   assign d-qtd-transf-drb = ordens-embarque.quantidade.
             end.           
        END.
        ELSE
            ASSIGN l-transf-drb = NO.        


        FIND estabelec WHERE estabelec.cod-estabel = docum-est.cod-estabel NO-LOCK NO-ERROR.
        FIND emitente  WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.

        /*Nota Fiscal Simples Remessa*/ 
        &if '{&bf_mat_versao_ems}':U >= '2.06':U &then
        IF docum-est.idi-nf-simples-remes = 1 THEN DO: 
        &else
        IF substr(docum-est.char-2,101,1) = "1" THEN DO:
        &endif     
            if avail item-doc-est then do:
               &if '{&bf_mat_versao_ems}' >= '2.06' &then
                 assign i-num-ord-import  = item-doc-est.num-ord-import 
                        i-num-parc-import = item-doc-est.num-parc-import.
               &else
                 assign i-num-ord-import  = INT(substring(item-doc-est.char-2,145,8)) 
                        i-num-parc-import = INT(substring(item-doc-est.char-2,154,5)).                 
               &endif
            end.
        END.
        ELSE
            ASSIGN i-num-ord-import  = item-doc-est.numero-ordem
                   i-num-parc-import = item-doc-est.parcela.

        find embarque-imp 
            where embarque-imp.cod-estabel = docum-est.cod-estabel
            and   embarque-imp.embarque    = substr(docum-est.char-1,1,20) no-lock no-error.
        if  avail embarque-imp then 
            
            assign cPeriodo = string(year(embarque-imp.data-1),"9999":U) 
                            + string(month(embarque-imp.data-1),"99":U).
        else do:
            assign cPeriodo = string(year(docum-est.dt-emissao),"9999":U) 
                            + string(month(docum-est.dt-emissao),"99":U).

            IF NOT CAN-FIND(FIRST  pedido-drb 
                            WHERE  pedido-drb.cod-estabel        = docum-est.cod-estabel
                            AND    pedido-drb.nr-ato-concessorio = item-doc-est.nr-ato-concessorio
                            AND    pedido-drb.log-draw-integrad
                            ) THEN DO:
                
                run utp/ut-msgs.p (input "msg":U,
                                   input 28996,
                                   input "":U).
                create tt-erro.
                assign tt-erro.i-sequen = iSequenciaErro
                       tt-erro.cd-erro  = 28996
                       tt-erro.mensagem = return-value
                       iSequenciaErro   = iSequenciaErro + 1
                       l-erro-valor     = YES.
    
                run pi-consiste-nota (yes,      /** Cria Consist-nota **/
                                      28996,    /** Codigo Mensagem   **/
                                      "":U,     /** Param. Mensagem   **/
                                      0,0,0,2). /** Advertencias      **/
            END.
        END.

        find ordem-compra where ordem-compra.numero-ordem =             
            &if '{&bf_mat_versao_ems}' >= '2.04' &then 
              i-num-ord-import
            &else
              item-doc-est.numero-ordem 
            &endif
            no-lock no-error.
        if  avail ordem-compra then do:
            IF ordem-compra.mo-codigo <> 0 THEN
                run cdp/cd0812.p (input  0,
                                  input  ordem-compra.mo-codigo,
                                  input  item-doc-est.preco-total[1],
                                  input  if  avail embarque-imp then embarque-imp.data-1
                                         else docum-est.dt-emissao,
                                  output deValorConv).                

            ELSE
                ASSIGN deValorConv = item-doc-est.preco-total[1].

        end.
        ELSE
            ASSIGN deValorConv = item-doc-est.preco-total[1].            

        find item
            where item.it-codigo = item-doc-est.it-codigo no-lock no-error.
    
        find first pedido-drb 
            where  pedido-drb.cod-estabel        = docum-est.cod-estabel
            and    pedido-drb.nr-ato-concessorio = item-doc-est.nr-ato-concessorio no-lock no-error.
        if  avail  pedido-drb then

            find pedido-drb-item
                where pedido-drb-item.cod-estabel   = pedido-drb.cod-estabel
                and   pedido-drb-item.nr-pedido-drb = pedido-drb.nr-pedido-drb
                and   pedido-drb-item.it-codigo     = item-doc-est.it-codigo NO-LOCK no-error.
        
        IF AVAIL ordem-compra THEN
            IF ordem-compra.mo-codigo <> 0 THEN DO:
                find cotacao 
                    where cotacao.mo-codigo   = ordem-compra.mo-codigo
                    and   cotacao.ano-periodo = cPeriodo no-lock no-error.
                IF NOT AVAIL cotacao THEN
                    LEAVE.
            END.
        
        if  avail item           
        and avail pedido-drb     
        and avail pedido-drb-item then do:

            IF NOT VALID-HANDLE(h-bocx315) THEN
                RUN cxbo/bocx315.p PERSISTENT SET h-bocx315.

                   
            /*Tratamento para Drawback Integrado*/
            ASSIGN l-drawback-integrado = pedido-drb.log-draw-integrad
                   c-priorid-bxa        = SUBSTRING(pedido-drb.char-1,1,1).
            
            find last movto-ato 
                where movto-ato.cod-estabel   = docum-est.cod-estabel 
                and   movto-ato.nr-pedido-drb = pedido-drb-item.nr-pedido-drb
                and   movto-ato.it-codigo     = item-doc-est.it-codigo no-lock no-error.
            if  avail movto-ato then
                assign iSequenciaMovto = movto-ato.sequencia.
            else 
                assign iSequenciaMovto = 1.
            
            IF NOT AVAIL param-re THEN
                FIND FIRST param-re NO-LOCK NO-ERROR.

            if  pedido-drb.modalidade = 1 then do:      /** Suspensao **/
                
				IF  emitente.natureza > 2 
				and emitente.pais <> estabelec.pais THEN DO:
					for each movto-ato
						where movto-ato.cod-estabel        = pedido-drb-item.cod-estabel
						and   movto-ato.nr-pedido-drb      = pedido-drb-item.nr-pedido-drb
						and   movto-ato.it-codigo          = pedido-drb-item.it-codigo
						and   movto-ato.idi-tip-item-movto = 1 /** Internacional **/
						and   movto-ato.idi-tip-movto      = 1 no-lock: /** Entrada **/
						assign deTotQuant = deTotQuant + movto-ato.val-quant-movto-ato
							   deTotValor = deTotValor + movto-ato.val-movto-ato-me.  
					end. 
				END.
				ELSE DO:
					for each movto-ato
						where movto-ato.cod-estabel        = pedido-drb-item.cod-estabel
						and   movto-ato.nr-pedido-drb      = pedido-drb-item.nr-pedido-drb
						and   movto-ato.it-codigo          = pedido-drb-item.it-codigo
						and   movto-ato.idi-tip-item-movto = 2 /** Nacional **/
						and   movto-ato.idi-tip-movto      = 1 no-lock: /** Entrada **/
						assign deTotQuant = deTotQuant + movto-ato.val-quant-movto-ato
							   deTotValor = deTotValor + movto-ato.val-movto-ato-me.  
					end.     
				END.
                 
                ASSIGN i-moeda-movto = 0.
                IF AVAIL ordem-compra THEN
                    ASSIGN i-moeda-movto = ordem-compra.mo-codigo.
                ELSE IF AVAIL docum-est THEN
                    ASSIGN i-moeda-movto = docum-est.mo-codigo.
                

                &if  "{&bf_dis_versao_ems}":U >= "2.06":U &then               
                    IF l-drawback-integrado THEN DO:
                        /*Compra Internacional*/
                        IF emitente.natureza > 2
                           and emitente.pais <> estabelec.pais THEN  DO:
                            IF  i-moeda-movto <> pedido-drb-item.moeda THEN DO:
                                run cdp/cd0812.p (input  i-moeda-movto, /*movto-ato.mo-codigo*/
                                                  input  pedido-drb-item.moeda,
                                                  input  round(deValorConv,2),
                                                  input  if  avail embarque-imp then embarque-imp.data-1 
                                                         else docum-est.dt-emissao, /*movto-ato.dat-cotac*/                       
                                                  output deValMovtoAtoMeConv).
                            END.
                            ELSE
                                ASSIGN deValMovtoAtoMeConv = round(deValorConv,2).

                            assign de-quant-saldo = pedido-drb-item.qtd-sdo-item + item-doc-est.quantidade
                                   de-valor-saldo = pedido-drb-item.val-sdo-item + round(deValMovtoAtoMeConv,2).
                            END.
                        ELSE DO:
                            IF i-moeda-movto <> pedido-drb-item.cdn-moed-nac THEN DO:
                                run cdp/cd0812.p (input  i-moeda-movto, /*movto-ato.mo-codigo*/
                                                  input  pedido-drb-item.cdn-moed-nac,
                                                  input  round(deValorConv,2),
                                                  input  if  avail embarque-imp then embarque-imp.data-1 
                                                         else docum-est.dt-emissao, /*movto-ato.dat-cotac*/                       
                                                  output deValMovtoAtoMeConv).
                            END.
                            ELSE
                                ASSIGN deValMovtoAtoMeConv = round(deValorConv,2).
                            
                            ASSIGN de-quant-saldo = pedido-drb-item.qtd-sdo-item-nac + item-doc-est.quantidade
                                   de-valor-saldo = pedido-drb-item.val-sdo-item-nac + round(deValMovtoAtoMeConv,2).     
                        END.
                    END.
                    ELSE DO:                         
                        IF i-moeda-movto <> 0 
                            AND i-moeda-movto <> pedido-drb-item.moeda THEN DO:
                            run cdp/cd0812.p (input  i-moeda-movto, /*movto-ato.mo-codigo*/
                                              input  pedido-drb-item.moeda,
                                              input  round(deValorConv,2),
                                              input  if  avail embarque-imp then embarque-imp.data-1 
                                                     else docum-est.dt-emissao, /*movto-ato.dat-cotac*/                       
                                              output deValMovtoAtoMeConv).
                        END.
                        ELSE
                            ASSIGN deValMovtoAtoMeConv = round(deValorConv,2).

                        IF l-transf-drb THEN
                            assign de-quant-saldo = pedido-drb-item.qtd-sdo-item - d-qtd-transf-drb
                                   de-valor-saldo = pedido-drb-item.val-sdo-item - round(deValMovtoAtoMeConv,2).
                        ELSE
                            assign de-quant-saldo = pedido-drb-item.qtd-sdo-item + item-doc-est.quantidade
                                   de-valor-saldo = pedido-drb-item.val-sdo-item + round(deValMovtoAtoMeConv,2).
                    END.
                &else             
                    assign de-quant-saldo = dec(SUBSTR(pedido-drb-item.char-1,1,15)) + item-doc-est.quantidade
                           de-valor-saldo = pedido-drb-item.dec-2 + deValMovtoAtoMeConv.
                &endif
            
                IF l-transf-drb THEN DO:
                    
                    IF pedido-drb-item.val-sdo-item < deValMovtoAtoMeConv THEN DO:
                        create tt-erro.
                        assign tt-erro.i-sequen = tt-erro.i-sequen + 1
                               tt-erro.cd-erro  = 34092
                               tt-erro.mensagem = TRIM(RETURN-VALUE)
                               c-parametros     = pedido-drb-item.it-codigo + "~~" + pedido-drb.nr-ato-concessorio
                               l-erro-valor     = YES.
        
                        run utp/ut-msgs.p ( input "help":U,
                                            input 34092,
                                            input c-parametros).  
        
                        run pi-consiste-nota-hlp (yes,      /** Cria Consist-nota **/
                                                  34092,    /** Codigo Mensagem   **/
                                                  c-parametros,     /** Param. Mensagem   **/
                                                  item-doc-est.sequencia,0,0,2). /** Advertencias      **/
        
                    END.

                    /* Valido que a qtd do item seja menor que o saldo dispon°vel no DK2000 */                    
                    IF  pedido-drb-item.qtd-sdo-item < d-qtd-transf-drb THEN DO:
        
                        run utp/ut-msgs.p (input "msg":U,
                                           input 29060,
                                           input "":U).
                        create tt-erro.
                        assign tt-erro.i-sequen = iSequenciaErro
                               tt-erro.cd-erro  = 29060
                               tt-erro.mensagem = return-value
                               iSequenciaErro   = iSequenciaErro + 1
                               l-erro-valor     = YES.
        
                        run pi-consiste-nota (yes,      /** Cria Consist-nota **/
                                              29060,    /** Codigo Mensagem   **/
                                              "":U,     /** Param. Mensagem   **/
                                              0,0,0,2). /** Advertencias      **/
                
                    END.

                END.
                ELSE DO:
                    IF l-drawback-integrado THEN DO:
                        /*Compra Internacional*/
                        IF emitente.natureza > 2
                           AND emitente.pais <> estabelec.pais THEN DO:
                            /*A mesma validacao abaixo, referente ao valor, esta replicada na bocx312*/
                            IF pedido-drb-item.preco-fob - deTotValor < deValMovtoAtoMeConv THEN DO:
                                create tt-erro.
                                assign tt-erro.i-sequen = tt-erro.i-sequen + 1
                                       tt-erro.cd-erro  = 34092
                                       tt-erro.mensagem = TRIM(RETURN-VALUE)
                                       c-parametros     = pedido-drb-item.it-codigo + "~~" + pedido-drb.nr-ato-concessorio
                                       l-erro-valor     = YES.
            
                                run utp/ut-msgs.p ( input "help":U,
                                                    input 34092,
                                                    input c-parametros).  
            
                                run pi-consiste-nota-hlp (yes,      /** Cria Consist-nota **/
                                                          34092,    /** Codigo Mensagem   **/
                                                          c-parametros,     /** Param. Mensagem   **/
                                                          item-doc-est.sequencia,0,0,2). /** Advertencias      **/
            
                            END.
            
                            IF  pedido-drb-item.quantidade - deTotQuant < item-doc-est.quantidade THEN DO:
            
                                run utp/ut-msgs.p (input "msg":U,
                                                   input 29060,
                                                   input "":U).
                                create tt-erro.
                                assign tt-erro.i-sequen = iSequenciaErro
                                       tt-erro.cd-erro  = 29060
                                       tt-erro.mensagem = return-value
                                       iSequenciaErro   = iSequenciaErro + 1
                                       l-erro-valor     = YES.
            
                                run pi-consiste-nota (yes,      /** Cria Consist-nota **/
                                                      29060,    /** Codigo Mensagem   **/
                                                      "":U,     /** Param. Mensagem   **/
                                                      0,0,0,2). /** Advertencias      **/
                    
                            END.
                        END.
                        ELSE DO:
                            /*A mesma validacao abaixo, referente ao valor, esta replicada na bocx312*/
                            IF pedido-drb-item.val-fob-nac - deTotValor < deValMovtoAtoMeConv THEN DO:
    
                                create tt-erro.
                                assign tt-erro.i-sequen = tt-erro.i-sequen + 1
                                       tt-erro.cd-erro  = 34092
                                       tt-erro.mensagem = TRIM(RETURN-VALUE)
                                       c-parametros     = pedido-drb-item.it-codigo + "~~" + pedido-drb.nr-ato-concessorio
                                       l-erro-valor     = YES.
            
                                run utp/ut-msgs.p ( input "help":U,
                                                    input 34092,
                                                    input c-parametros).  
            
                                run pi-consiste-nota-hlp (yes,      /** Cria Consist-nota **/
                                                          34092,    /** Codigo Mensagem   **/
                                                          c-parametros,     /** Param. Mensagem   **/
                                                          item-doc-est.sequencia,0,0,2). /** Advertencias      **/
            
                            END.
            
                            IF  pedido-drb-item.qtd-item-nac - deTotQuant < item-doc-est.quantidade THEN DO:
            
                                run utp/ut-msgs.p (input "msg":U,
                                                   input 29060,
                                                   input "":U).
                                create tt-erro.
                                assign tt-erro.i-sequen = iSequenciaErro
                                       tt-erro.cd-erro  = 29060
                                       tt-erro.mensagem = return-value
                                       iSequenciaErro   = iSequenciaErro + 1
                                       l-erro-valor     = YES.
            
                                run pi-consiste-nota (yes,      /** Cria Consist-nota **/
                                                      29060,    /** Codigo Mensagem   **/
                                                      "":U,     /** Param. Mensagem   **/
                                                      0,0,0,2). /** Advertencias      **/
                    
                            END.
                        END.
                    END.
                    ELSE DO:        
                        /*A mesma validacao abaixo, referente ao valor, esta replicada na bocx312*/
                        IF pedido-drb-item.preco-fob - deTotValor < deValMovtoAtoMeConv THEN DO:
                            create tt-erro.
                            assign tt-erro.i-sequen = tt-erro.i-sequen + 1
                                   tt-erro.cd-erro  = 34092
                                   tt-erro.mensagem = TRIM(RETURN-VALUE)
                                   c-parametros     = pedido-drb-item.it-codigo + "~~" + pedido-drb.nr-ato-concessorio
                                   l-erro-valor     = YES.
        
                            run utp/ut-msgs.p ( input "help":U,
                                                input 34092,
                                                input c-parametros).  
        
                            run pi-consiste-nota-hlp (yes,      /** Cria Consist-nota **/
                                                      34092,    /** Codigo Mensagem   **/
                                                      c-parametros,     /** Param. Mensagem   **/
                                                      item-doc-est.sequencia,0,0,2). /** Advertencias      **/
        
                        END.
        
                        IF  pedido-drb-item.quantidade - deTotQuant < item-doc-est.quantidade THEN DO:
        
                            run utp/ut-msgs.p (input "msg":U,
                                               input 29060,
                                               input "":U).
                            create tt-erro.
                            assign tt-erro.i-sequen = iSequenciaErro
                                   tt-erro.cd-erro  = 29060
                                   tt-erro.mensagem = return-value
                                   iSequenciaErro   = iSequenciaErro + 1
                                   l-erro-valor     = YES.
        
                            run pi-consiste-nota (yes,      /** Cria Consist-nota **/
                                                  29060,    /** Codigo Mensagem   **/
                                                  "":U,     /** Param. Mensagem   **/
                                                  0,0,0,2). /** Advertencias      **/
                
                        END.
                    END.
                END.
            end.
            else if pedido-drb.modalidade = 2 then do:  /** Isencao   **/

                ASSIGN de-tot-quant-ent = 0
                       de-tot-valor-ent = 0.
                RUN cdp/cd0812.p (INPUT if avail ordem-compra then ordem-compra.mo-codigo
                                  else  docum-est.mo-codigo, 
                                  input pedido-drb-item.moeda,
                                  input ROUND(deValorConv,2),
                                  input IF AVAIL embarque-imp THEN embarque-imp.data-1 
                                        ELSE docum-est.dt-emissao,
                                  OUTPUT deValMovtoNovaImp).
                for each  movto-ato 
                    where movto-ato.cod-estabel   = pedido-drb-item.cod-estabel
                    and   movto-ato.nr-pedido-drb = pedido-drb-item.nr-pedido-drb
                    and   movto-ato.it-codigo     = pedido-drb-item.it-codigo no-lock:
                      
                   if  movto-ato.idi-tip-movto = 2 THEN DO:  /**Baixa **/
                       RUN cdp/cd0812.p (INPUT movto-ato.mo-codigo,
                                         INPUT pedido-drb-item.moeda , 
                                         INPUT movto-ato.val-movto-ato-me, 
                                         INPUT movto-ato.dat-cotac, 
                                         OUTPUT deTotValor).
                        

                     
                       ASSIGN deValMovtoAtoMeConv = deValMovtoAtoMeConv + deTotValor
                              deTotQuantBaixa     = deTotQuantBaixa + movto-ato.val-quant-movto-ato.
                   END.

                end.

                IF NOT VALID-HANDLE(h-bocx332) THEN
                    RUN cxbo/bocx332.p PERSISTENT SET h-bocx332.
                    
                IF emitente.natureza > 2
                   and emitente.pais <> estabelec.pais THEN
                   ASSIGN i-tip-item-movto = 1. /* internacional */
                ELSE
                   ASSIGN i-tip-item-movto = 2. /* nacional */

                   IF l-drawback-integrado THEN
                        RUN calculo-saldo-itens-unif IN h-bocx332(INPUT  pedido-drb-item.cod-estabel, /*c-cod-estabel     */
                                                                  INPUT  pedido-drb-item.nr-pedido-drb, /*nr-pedido-drb     */
                                                                  INPUT  pedido-drb-item.it-codigo, /*c-it-codigo       */
                                                                  OUTPUT d-qtd-saldo-aux, /*de-quant-saldo    */
                                                                  OUTPUT d-val-saldo-aux, /*de-valor-saldo    */
                                                                  OUTPUT d-tot-qtd-ent-aux, /*de-tot-quant-ent  */
                                                                  OUTPUT d-tot-qtd-sai-aux). /*de-tot-quant-baixa*/
                   ELSE
                       RUN calculo-saldo-itens IN h-bocx332(INPUT  pedido-drb-item.cod-estabel, /*c-cod-estabel     */
                                                            INPUT  pedido-drb-item.nr-pedido-drb, /*nr-pedido-drb     */
                                                            INPUT  pedido-drb-item.it-codigo, /*c-it-codigo       */
                                                            INPUT  i-tip-item-movto, /*Tipo do movto item*/
                                                            OUTPUT d-qtd-saldo-aux, /*de-quant-saldo    */
                                                            OUTPUT d-val-saldo-aux, /*de-valor-saldo    */
                                                            OUTPUT d-tot-qtd-ent-aux, /*de-tot-quant-ent  */
                                                            OUTPUT d-tot-qtd-sai-aux). /*de-tot-quant-baixa*/

                IF VALID-HANDLE(h-bocx332) THEN DO:
                    DELETE PROCEDURE h-bocx332.
                    ASSIGN h-bocx332 = ?.
                END.
                &if  "{&bf_dis_versao_ems}":U >= "2.06":U &then               
                    IF l-drawback-integrado THEN DO:
                            assign de-quant-saldo = d-qtd-saldo-aux /*(pedido-drb-item.qtd-sdo-item + pedido-drb-item.qtd-sdo-item-nac) - item-doc-est.quantidade*/
                                   d-novo-saldo-proporcional = d-val-saldo-aux - ((de-quant-saldo * d-val-saldo-aux) / d-tot-qtd-ent-aux)
                                   de-valor-saldo = (pedido-drb-item.val-sdo-item + pedido-drb-item.val-sdo-item-nac) - d-novo-saldo-proporcional.                        
                    END.
                    ELSE
                        assign de-quant-saldo = pedido-drb-item.qtd-sdo-item - item-doc-est.quantidade
                               d-novo-saldo-proporcional = d-val-saldo-aux - ((de-quant-saldo * d-val-saldo-aux) / d-tot-qtd-ent-aux)
                               de-valor-saldo = pedido-drb-item.val-sdo-item - d-novo-saldo-proporcional. /*round(deValMovtoNovaImp,2).*/
                &else             
                    assign de-quant-saldo = dec(SUBSTR(pedido-drb-item.char-1,1,15)) - item-doc-est.quantidade
                           d-novo-saldo-proporcional = d-val-saldo-aux - ((de-quant-saldo * d-val-saldo-aux) / d-tot-qtd-ent-aux)
                           de-valor-saldo = pedido-drb-item.dec-2 + d-novo-saldo-proporcional. /*deValMovtoNovaImp.*/
                &endif
                
                IF l-drawback-integrado THEN DO:                    
                        IF (pedido-drb-item.preco-fob + pedido-drb-item.val-fob-nac) - deValMovtoAtoMeConv < deValMovtoNovaImp THEN DO:
                            create tt-erro.
                            assign tt-erro.i-sequen = tt-erro.i-sequen + 1
                                   tt-erro.cd-erro  = 34092
                                   tt-erro.mensagem = TRIM(RETURN-VALUE)
                                   c-parametros     = pedido-drb-item.it-codigo + "~~" + pedido-drb.nr-ato-concessorio
                                   l-erro-valor     = YES.
        
                            run utp/ut-msgs.p ( input "help":U,
                                                input 34092,
                                                input c-parametros).  
        
                            run pi-consiste-nota-hlp (yes,      /** Cria Consist-nota **/
                                                      34092,    /** Codigo Mensagem   **/
                                                      c-parametros,     /** Param. Mensagem   **/
                                                      item-doc-est.sequencia,0,0,2). /** Advertencias      **/
        
                        END.
        
        
                        if  (pedido-drb-item.quantidade + pedido-drb-item.qtd-item-nac) - deTotQuantBaixa < item-doc-est.quantidade then do:
        
                            run utp/ut-msgs.p (input "msg":U,
                                               input 29085,
                                               input "":U).
                            create tt-erro.
                            assign tt-erro.i-sequen = iSequenciaErro
                                   tt-erro.cd-erro  = 29085
                                   tt-erro.mensagem = return-value
                                   iSequenciaErro   = iSequenciaErro + 1
                                   l-erro-valor     = YES.
        
                            run pi-consiste-nota (yes,      /** Cria Consist-nota **/
                                                  29085,    /** Codigo Mensagem   **/
                                                  "":U,     /** Param. Mensagem   **/
                                                  0,0,0,2). /** Advertencias      **/
        
                        end.                   
                END.
                ELSE DO:
                    IF pedido-drb-item.preco-fob - deValMovtoAtoMeConv < deValMovtoNovaImp THEN DO:
                        create tt-erro.
                        assign tt-erro.i-sequen = tt-erro.i-sequen + 1
                               tt-erro.cd-erro  = 34092
                               tt-erro.mensagem = TRIM(RETURN-VALUE)
                               c-parametros     = pedido-drb-item.it-codigo + "~~" + pedido-drb.nr-ato-concessorio
                               l-erro-valor     = YES.
    
                        run utp/ut-msgs.p ( input "help":U,
                                            input 34092,
                                            input c-parametros).  
    
                        run pi-consiste-nota-hlp (yes,      /** Cria Consist-nota **/
                                                  34092,    /** Codigo Mensagem   **/
                                                  c-parametros,     /** Param. Mensagem   **/
                                                  item-doc-est.sequencia,0,0,2). /** Advertencias      **/
    
                    END.
    
    
                    if  pedido-drb-item.quantidade - deTotQuantBaixa < item-doc-est.quantidade then do:
    
                        run utp/ut-msgs.p (input "msg":U,
                                           input 29085,
                                           input "":U).
                        create tt-erro.
                        assign tt-erro.i-sequen = iSequenciaErro
                               tt-erro.cd-erro  = 29085
                               tt-erro.mensagem = return-value
                               iSequenciaErro   = iSequenciaErro + 1
                               l-erro-valor     = YES.
    
                        run pi-consiste-nota (yes,      /** Cria Consist-nota **/
                                              29085,    /** Codigo Mensagem   **/
                                              "":U,     /** Param. Mensagem   **/
                                              0,0,0,2). /** Advertencias      **/
    
                    end.
                END.
            end.
            
            /** Valida se a situacao do pedido de drawback nao for aprovado **/
            if  pedido-drb.nr-ato-concessorio = "" then do:

                run utp/ut-msgs.p (input "msg":U,
                                   input 29200,
                                   input "":U).
                create tt-erro.
                assign tt-erro.i-sequen = iSequenciaErro
                       tt-erro.cd-erro  = 29200
                       tt-erro.mensagem = return-value
                       iSequenciaErro   = iSequenciaErro + 1
                       l-erro-valor     = YES.

                run pi-consiste-nota (yes,      /** Cria Consist-nota **/
                                      29200,    /** Codigo Mensagem   **/
                                      "":U,     /** Param. Mensagem   **/
                                      0,0,0,2). /** Advertencias      **/  

            end.
            
            IF CAN-FIND (FIRST tt-erro) AND NOT param-re.atu-advert THEN DO:
                ASSIGN l-erro = YES.
                LEAVE.
            END.
            ELSE
                ASSIGN l-erro = NO.

            /* Geracao dos movimentos do ato concessorio */
            IF NOT CAN-FIND (FIRST tt-erro ) OR NOT l-erro-valor THEN DO:
                /*atualiza o saldo do item de drawback*/
                &if  "{&bf_dis_versao_ems}":U >= "2.06":U &then                                
                
                    CREATE tt-pedido-drb-item.
                    BUFFER-COPY pedido-drb-item TO tt-pedido-drb-item.
                    ASSIGN tt-pedido-drb-item.r-rowid = ROWID(pedido-drb-item).

                    IF l-drawback-integrado THEN DO:
                        /*Compra Internacional*/
                        IF pedido-drb.modalidade = 1 THEN DO:
                            IF emitente.natureza > 2 
                               and emitente.pais <> estabelec.pais THEN DO:                            
                                assign tt-pedido-drb-item.qtd-sdo-item       = de-quant-saldo
                                       tt-pedido-drb-item.val-sdo-item       = de-valor-saldo.
                                 IF tt-pedido-drb-item.qtd-alocada-import >= item-doc-est.quantidade THEN
                                    ASSIGN  tt-pedido-drb-item.qtd-alocada-import = tt-pedido-drb-item.qtd-alocada-import - item-doc-est.quantidade.
                                 ELSE 
                                    ASSIGN  tt-pedido-drb-item.qtd-alocada-import = 0.
                            END.
                            ELSE DO:
                                assign tt-pedido-drb-item.qtd-sdo-item-nac = de-quant-saldo
                                       tt-pedido-drb-item.val-sdo-item-nac = de-valor-saldo.
                                IF tt-pedido-drb-item.qtd-alocada-nac >= item-doc-est.quantidade THEN
                                    ASSIGN  tt-pedido-drb-item.qtd-alocada-nac = tt-pedido-drb-item.qtd-alocada-nac - item-doc-est.quantidade.
                                ELSE
                                    ASSIGN  tt-pedido-drb-item.qtd-alocada-nac = 0.
                            END.
                        END.
                    END.
                    ELSE DO:                        

                        assign tt-pedido-drb-item.qtd-sdo-item = de-quant-saldo
                               tt-pedido-drb-item.val-sdo-item = de-valor-saldo.

                        IF NOT l-transf-drb THEN
                            IF tt-pedido-drb-item.qtd-alocada-import >= item-doc-est.quantidade THEN
                                ASSIGN tt-pedido-drb-item.qtd-alocada-import = tt-pedido-drb-item.qtd-alocada-import - item-doc-est.quantidade.
                            ELSE 
                                ASSIGN tt-pedido-drb-item.qtd-alocada-import = 0.
                    END.

                &else
                    assign overlay(tt-pedido-drb-item.char-1,1,15) = string(de-quant-saldo)
                           tt-pedido-drb-item.dec-2                = de-valor-saldo.
                &endif
                
                ASSIGN i-moeda-movto = if avail ordem-compra then ordem-compra.mo-codigo else docum-est.mo-codigo.
                
                IF i-moeda-movto <> 0 THEN DO:
                    ASSIGN deValorConvNac = 0.
                    /* Como o RE1001 somente trabalha com valores em reais, caso o cliente estiver utilizando          */
                    /* uma moeda diferente de real para o saldo internacional o valor vir√° convertido em reais e ser√°  */
                    /* necess√°rio converte-lo novamente para a moeda que est√° sendo utilizada no ato concess√≥rio.      */
                    run cdp/cd0812.p (input  0, /* marcelo passar moeda da ordem ou docum est if avail ordem-compra then ordem-compra.mo-codigo else docum-est.mo-codigo */
                                      input  i-moeda-movto,
                                      input  item-doc-est.preco-total[1],
                                      input  if  avail embarque-imp then embarque-imp.data-1
                                             else docum-est.dt-emissao,
                                      output deValorConvNac).  
                END.
                IF NOT VALID-HANDLE(h-bocx332) THEN
                   RUN cxbo/bocx332.p PERSISTENT SET h-bocx332.
                
                /*Indica para a bo da movto-ato que a criaá∆o Ç autom†tica*/
                RUN pi-seta-cria-automatico in h-bocx332(INPUT TRUE).

                IF l-drawback-integrado AND pedido-drb.modalidade <> 1 THEN DO:
                    DEFINE VARIABLE dcTotal AS DECIMAL        NO-UNDO.
                        ASSIGN dcTotal = de-quant-saldo.
                    

                    DO WHILE de-quant-saldo > 0:
                		CREATE tt-movto-ato.
                		/*Se a Prioridade for para baixar primeiro o saldo nacional*/
                		IF SUBSTRING(pedido-drb.char-1,1,1) = "3" THEN DO: /*Prioridade de Baixa Ç pelo mercado NACIONAL*/
                			IF tt-pedido-drb-item.qtd-sdo-item-nac > 0 THEN DO:
                				/*NACIONAL*/
                				/*Verifica se ainda existe saldo nacional para baixar*/
                				ASSIGN de-qtde-tot-movto    = 0
                					   de-valor-tot-movto   = 0.
                				/*Busca o valor total e a quantidade total do Ato para fazer um regra de 3*/
                				RUN FormaValoresTotais IN h-bocx332(INPUT  tt-pedido-drb-item.cod-estabel, /*c-cod-estabel     */
                													INPUT  tt-pedido-drb-item.nr-pedido-drb, /*nr-pedido-drb     */
                													INPUT  tt-pedido-drb-item.it-codigo, /*c-it-codigo       */
                													INPUT  2, /*i-tip-item-movto  */
                													OUTPUT de-qtde-tot-movto, /*de-tot-quant-ent  */
                													OUTPUT de-valor-tot-movto). /*de-tot-quant-baixa*/		
                				/*Se ainda tem saldo nacional para baixar, verifica se a quantidade para baixa Ç maior que o saldo*/
                				IF de-quant-saldo - tt-pedido-drb-item.qtd-sdo-item-nac >= 0 THEN DO:
                					/*Se a quantidade para baixar for maior que a que o saldo nacional, ent∆o diminui o saldo da quantidade a baixar,
                						zera o saldo nacional e o valor*/
                					ASSIGN de-quant-saldo                      = de-quant-saldo - tt-pedido-drb-item.qtd-sdo-item-nac
                						   tt-movto-ato.val-quant-movto-ato    = tt-pedido-drb-item.qtd-sdo-item-nac						   
                						   tt-movto-ato.val-quant-movto-ato-re =  dcTotal * (((tt-pedido-drb-item.qtd-sdo-item-nac * 100) / dcTotal) / 100)
                						   d-novo-saldo-proporcional           = (de-valor-tot-movto * tt-pedido-drb-item.qtd-sdo-item-nac) / de-qtde-tot-movto						   
                						   tt-pedido-drb-item.val-sdo-item-nac = 0						   
                						   tt-pedido-drb-item.qtd-sdo-item-nac = 0
                						   tt-movto-ato.idi-tip-item-movto     = 2.
                				END.
                				ELSE DO:
                					/*Se a quantidade a baixar for menor que o saldo nacional, ent∆o diminui a quantidade a baixar do saldo
                						e faz a regra de 3 para baixar o valor.*/
                						
                					ASSIGN tt-pedido-drb-item.qtd-sdo-item-nac = tt-pedido-drb-item.qtd-sdo-item-nac - de-quant-saldo
                						   tt-movto-ato.val-quant-movto-ato    = de-quant-saldo
                						   tt-movto-ato.val-quant-movto-ato-re =  dcTotal * (((de-quant-saldo * 100) / dcTotal) / 100)
                						   d-novo-saldo-proporcional           = (de-valor-tot-movto * de-quant-saldo) / de-qtde-tot-movto
                						   tt-pedido-drb-item.val-sdo-item-nac = tt-pedido-drb-item.val-sdo-item-nac - d-novo-saldo-proporcional
                						   de-quant-saldo                      = 0
                						   tt-movto-ato.idi-tip-item-movto     = 2.
                			   END.
                			END.
                			ELSE DO:
                				/*INTERNACIONAL*/
                				ASSIGN de-qtde-tot-movto    = 0
                					   de-valor-tot-movto   = 0.
                				RUN FormaValoresTotais IN h-bocx332(INPUT  tt-pedido-drb-item.cod-estabel, /*c-cod-estabel     */
                													INPUT  tt-pedido-drb-item.nr-pedido-drb, /*nr-pedido-drb     */
                													INPUT  tt-pedido-drb-item.it-codigo, /*c-it-codigo       */
                													INPUT  1, /*i-tip-item-movto  */
                													OUTPUT de-qtde-tot-movto, /*de-tot-quant-ent  */
                													OUTPUT de-valor-tot-movto). /*de-tot-quant-baixa*/
                				
                				/*Se a prioridade for nacional e j† baixou todo o saldo nacional, baixa o que resta do saldo internacional*/				
                				ASSIGN tt-movto-ato.val-quant-movto-ato    = de-quant-saldo
                					   tt-movto-ato.val-quant-movto-ato-re = dcTotal * (((de-quant-saldo * 100) / dcTotal) / 100)
                					   tt-pedido-drb-item.qtd-sdo-item     = tt-pedido-drb-item.qtd-sdo-item - de-quant-saldo
                					   d-novo-saldo-proporcional           = (de-valor-tot-movto * de-quant-saldo) / de-qtde-tot-movto
                					   tt-pedido-drb-item.val-sdo-item     = tt-pedido-drb-item.val-sdo-item - d-novo-saldo-proporcional					   					   
                					   de-quant-saldo                      = 0
                					   tt-movto-ato.idi-tip-item-movto     = 1.
                			END.
                		END.
                		ELSE DO: /*Prioridade de Baixa Ç pelo mercado INTERNACIONAL OU AMBOS*/
                			IF tt-pedido-drb-item.qtd-sdo-item > 0 THEN DO:
                				/*Quando a prioridade for por baixa Internacional ou Ambos, segue a mesma regra da baixa com prioridade nacional,
                					mas primeiro baixa do Saldo Internacional, e se sobrar quantidade para baixar ent∆o baixa do saldo nacional.
                				*/
                				/*INTERNACIONAL*/
                				ASSIGN de-qtde-tot-movto    = 0
                					   de-valor-tot-movto   = 0.
                				RUN FormaValoresTotais IN h-bocx332(INPUT  tt-pedido-drb-item.cod-estabel, /*c-cod-estabel     */
                													INPUT  tt-pedido-drb-item.nr-pedido-drb, /*nr-pedido-drb     */
                													INPUT  tt-pedido-drb-item.it-codigo, /*c-it-codigo       */
                													INPUT  1, /*i-tip-item-movto  */
                													OUTPUT de-qtde-tot-movto, /*de-tot-quant-ent  */
                													OUTPUT de-valor-tot-movto). /*de-tot-quant-baixa*/
                													
                				IF de-quant-saldo - tt-pedido-drb-item.qtd-sdo-item >= 0 THEN
                					ASSIGN de-quant-saldo                      = de-quant-saldo - tt-pedido-drb-item.qtd-sdo-item
                						   tt-movto-ato.val-quant-movto-ato    = tt-pedido-drb-item.qtd-sdo-item
                						   tt-movto-ato.val-quant-movto-ato-re =  dcTotal * (((tt-pedido-drb-item.qtd-sdo-item * 100) / dcTotal) / 100)						   
                						   d-novo-saldo-proporcional           = (de-valor-tot-movto * tt-pedido-drb-item.qtd-sdo-item) / de-qtde-tot-movto
                						   tt-pedido-drb-item.val-sdo-item     = 0						   
                						   tt-pedido-drb-item.qtd-sdo-item     = 0
                						   tt-movto-ato.idi-tip-item-movto     = 1.
                				ELSE
                					ASSIGN tt-pedido-drb-item.qtd-sdo-item     = tt-pedido-drb-item.qtd-sdo-item - de-quant-saldo
                						   tt-movto-ato.val-quant-movto-ato    = de-quant-saldo
                						   tt-movto-ato.val-quant-movto-ato-re =  dcTotal * (((de-quant-saldo * 100) / dcTotal) / 100)
                						   d-novo-saldo-proporcional           = (de-valor-tot-movto * de-quant-saldo) / de-qtde-tot-movto
                						   tt-pedido-drb-item.val-sdo-item     = tt-pedido-drb-item.val-sdo-item - d-novo-saldo-proporcional						   						   
                						   de-quant-saldo                      = 0
                						   tt-movto-ato.idi-tip-item-movto     = 1.
                			END.
                			ELSE DO:
                				/*NACIONAL*/ 
                				ASSIGN de-qtde-tot-movto    = 0
                					   de-valor-tot-movto   = 0.
                				 RUN FormaValoresTotais IN h-bocx332(INPUT  tt-pedido-drb-item.cod-estabel, /*c-cod-estabel     */
                													 INPUT  tt-pedido-drb-item.nr-pedido-drb, /*nr-pedido-drb     */
                													 INPUT  tt-pedido-drb-item.it-codigo, /*c-it-codigo       */
                													 INPUT  2, /*i-tip-item-movto  */
                													 OUTPUT de-qtde-tot-movto, /*de-tot-quant-ent  */
                													 OUTPUT de-valor-tot-movto). /*de-tot-quant-baixa*/
                													
                				ASSIGN tt-movto-ato.val-quant-movto-ato    = de-quant-saldo
                					   tt-pedido-drb-item.qtd-sdo-item-nac = tt-pedido-drb-item.qtd-sdo-item-nac - de-quant-saldo                                          
                					   tt-movto-ato.val-quant-movto-ato-re = dcTotal * (((de-quant-saldo * 100) / dcTotal) / 100)
                					   d-novo-saldo-proporcional           = (de-valor-tot-movto * de-quant-saldo) / de-qtde-tot-movto
                					   tt-pedido-drb-item.val-sdo-item-nac = tt-pedido-drb-item.val-sdo-item-nac - d-novo-saldo-proporcional
                					   de-quant-saldo                      = 0
                					   tt-movto-ato.idi-tip-item-movto     = 2.
                			END.
                		END.

            
                
                		ASSIGN iSequenciaMovto                  = iSequenciaMovto + 1
                			   tt-movto-ato.idi-tip-movto       = pedido-drb.modalidade 
                			   tt-movto-ato.dat-movto           = today
                			   tt-movto-ato.cod-estab-docto     = docum-est.cod-estabel
                			   tt-movto-ato.nro-docto           = docum-est.nro-docto
                			   tt-movto-ato.serie               = docum-est.serie
                			   tt-movto-ato.nat-operacao        = docum-est.nat-operacao
                			   tt-movto-ato.cod-emitente        = docum-est.cod-emitente
                			   tt-movto-ato.declaracao-import   = if  avail embarque-imp then embarque-imp.declaracao-import
                											   else "":U
                			   tt-movto-ato.dat-decla-import    = if  avail embarque-imp then embarque-imp.data-di
                											   else ?
                			   tt-movto-ato.dat-nf              = docum-est.dt-emissao
                			   tt-movto-ato.cdd-ncm             = item-doc-est.class-fiscal
                			   tt-movto-ato.val-peso            = item-doc-est.peso-liquido
                			   tt-movto-ato.un                  = item.un
                			   tt-movto-ato.mo-codigo           = i-moeda-movto /*if avail ordem-compra then ordem-compra.mo-codigo else docum-est.mo-codigo*/
                			   tt-movto-ato.cod-estabel         = docum-est.cod-estabel 
                			   tt-movto-ato.nr-pedido-drb       = pedido-drb-item.nr-pedido-drb
                			   tt-movto-ato.it-codigo           = item-doc-est.it-codigo
                			   tt-movto-ato.seq-docto           = item-doc-est.sequencia                               
                			   tt-movto-ato.val-movto-ato-orig  = if deValorConvNac <> 0 THEN deValorConvNac ELSE item-doc-est.preco-total[1]
                			   /*tt-movto-ato.val-movto-ato-me    = round(deValorConv,2)*/
                			   tt-movto-ato.val-movto-ato-me    = d-novo-saldo-proporcional
                			   tt-movto-ato.dat-cotac           = if  avail embarque-imp then embarque-imp.data-1
                											   else docum-est.dt-emissao
                			   tt-movto-ato.cotacao             = IF avail ordem-compra and ordem-compra.mo-codigo <> 0 THEN
                													IF  AVAIL embarque-imp THEN cotacao.cotacao[DAY(embarque-imp.data-1)]
                													ELSE cotacao.cotacao[DAY(docum-est.dt-emissao)]
                											   ELSE 1
                			   tt-movto-ato.sequencia           = iSequenciaMovto.
                        
                        RUN pi-efetiva-criacao-movto-ato.
                	END.
                END.
                ELSE DO:                       
                    CREATE tt-movto-ato.
                    assign tt-movto-ato.dat-movto           = today
                           tt-movto-ato.cod-estab-docto     = docum-est.cod-estabel
                           tt-movto-ato.nro-docto           = docum-est.nro-docto
                           tt-movto-ato.serie               = docum-est.serie
                           tt-movto-ato.nat-operacao        = docum-est.nat-operacao
                           tt-movto-ato.cod-emitente        = docum-est.cod-emitente
                           tt-movto-ato.declaracao-import   = if  avail embarque-imp then embarque-imp.declaracao-import
                                                           else "":U
                           tt-movto-ato.dat-decla-import    = if  avail embarque-imp then embarque-imp.data-di
                                                           else ?
                           tt-movto-ato.dat-nf              = docum-est.dt-emissao
                           tt-movto-ato.cdd-ncm             = item-doc-est.class-fiscal
                           tt-movto-ato.val-peso            = item-doc-est.peso-liquido
                           tt-movto-ato.un                  = item.un
                           tt-movto-ato.mo-codigo           = i-moeda-movto /*if avail ordem-compra then ordem-compra.mo-codigo else docum-est.mo-codigo*/
                           tt-movto-ato.cod-estabel         = docum-est.cod-estabel 
                           tt-movto-ato.nr-pedido-drb       = pedido-drb-item.nr-pedido-drb
                           tt-movto-ato.it-codigo           = item-doc-est.it-codigo
                           tt-movto-ato.seq-docto           = item-doc-est.sequencia

                           tt-movto-ato.val-movto-ato-orig  = if deValorConvNac <> 0 THEN deValorConvNac ELSE item-doc-est.preco-total[1]
                           tt-movto-ato.val-movto-ato-me    = round(deValorConv,2)
                           tt-movto-ato.dat-cotac           = if  avail embarque-imp then embarque-imp.data-1
                                                           else docum-est.dt-emissao
                           tt-movto-ato.cotacao             = IF avail ordem-compra and ordem-compra.mo-codigo <> 0 THEN
                                                                IF  AVAIL embarque-imp THEN cotacao.cotacao[DAY(embarque-imp.data-1)]
                                                                ELSE cotacao.cotacao[DAY(docum-est.dt-emissao)]
                                                           ELSE 1
                           tt-movto-ato.sequencia           = iSequenciaMovto + 1.

                        IF l-transf-drb THEN
                            ASSIGN tt-movto-ato.idi-tip-movto       = 3 /* Movimento de Transferància */
                                   tt-movto-ato.val-quant-movto-ato = d-qtd-transf-drb. /* qtd ordens-embarque */
                        ELSE
                            ASSIGN tt-movto-ato.idi-tip-movto       = pedido-drb.modalidade
                                   tt-movto-ato.val-quant-movto-ato = item-doc-est.quantidade.
    
                        IF l-drawback-integrado THEN DO:
                            /*O movimento deve ser gerado conforme o tipo de documento*/
                            IF emitente.natureza > 2
                               and emitente.pais <> estabelec.pais THEN
                               ASSIGN tt-movto-ato.idi-tip-item-movto = 1.
                            ELSE
                               ASSIGN tt-movto-ato.idi-tip-item-movto = 2.
                        END.
                        ELSE
                           ASSIGN tt-movto-ato.idi-tip-item-movto = 1.

                        RUN pi-efetiva-criacao-movto-ato.
                END.
                IF VALID-HANDLE(h-bocx332) THEN DO:
                    RUN destroy IN h-bocx332.

                    DELETE PROCEDURE h-bocx332 NO-ERROR.
                    ASSIGN h-bocx332 = ?.
                END.
            END.

            RUN piEfetivaPedidoDrbItem (INPUT h-bocx315).

            IF VALID-HANDLE(h-bocx315) THEN DO:
                RUN destroy IN h-bocx315.

                DELETE PROCEDURE h-bocx315 NO-ERROR.
                ASSIGN h-bocx315 = ?.
            END.
        end.
    end.

    

    procedure pi-consiste-nota-hlp:

    def input parameter l-opcao         as logical format "Cria/Elimina" no-undo.
    def input parameter cod-mensag      as integer                      no-undo.
    def input parameter c-complem       as char                         no-undo.
    def input parameter i-seq-item      as integer                      no-undo.
    def input parameter de-calculado    as decimal                      no-undo.
    def input parameter de-informado    as decimal                      no-undo.
    def input parameter i-tipo-msg      as integer                      no-undo. 

    def var c-mensagem                  as char                         no-undo.

    /* CRIACAO DE CONSISTENCIAS DA NOTA */
        if  l-opcao then do: 
    
            find first consist-nota {cdp/cd8900.i consist-nota docum-est}
                   and consist-nota.int-1    = i-seq-item
                   and consist-nota.mensagem = cod-mensag
                 exclusive-lock no-error.
    
            if  not avail consist-nota then do:
                create consist-nota.
                assign consist-nota.nro-docto    = docum-est.nro-docto
                       consist-nota.serie-docto  = docum-est.serie-docto
                       consist-nota.cod-emitente = docum-est.cod-emitente
                       consist-nota.nat-operacao = docum-est.nat-operacao
                       consist-nota.int-1        = i-seq-item
                       consist-nota.mensagem     = cod-mensag
                       consist-nota.tipo         = i-tipo-msg.
            end.
            assign consist-nota.calculado = de-calculado
                   consist-nota.informado = de-informado.
    
            run utp/ut-msgs.p ( input "help":U,
                                input cod-mensag,
                                input c-complem  ).  
    
            assign c-mensagem = return-value.
    
            if not l-erro-nota  then do:
                if  line-counter <= 5 then do:
                    put c-cabec1 at 0 skip.
                    put c-cabec2 at 0 skip.
                end.
            
                if line-counter > 62 then
                   page.
        
                put docum-est.serie-docto at 1.
                put docum-est.nro-docto   at 7.
                put string(docum-est.cod-emitente) at 24 format "x(9)".
                put docum-est.nat-operacao at 35.
                put string(cod-mensag,">>>>>9") at 43.
                
                run pi-print-editor (input c-mensagem, input 78).
                for each tt-editor:
                    put tt-editor.conteudo at 53 format "X(78)" skip.
                end.
            end.
        end.
        /* ELIMINACAO DE CONSISTENCIAS DA NOTA */
        else  do:
            for each consist-nota {cdp/cd8900.i consist-nota docum-est}
                 and consist-nota.int-1     = i-seq-item
                 and consist-nota.mensagem  = cod-mensag exclusive-lock:
    
                delete consist-nota.
            end.
        end.        
    end.
    
    {rep/re1005.i} /*pi-consiste-nota */

    {include/pi-edit.i}

PROCEDURE pi-efetiva-criacao-movto-ato :
/*------------------------------------------------------------------------------
  Purpose: Efetiva a criaá∆o da movto-ato atravÇs da BO    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF CAN-FIND (FIRST tt-movto-ato) THEN DO:
        run openQueryStatic in h-bocx332 (input "Main":U) no-error.
        run emptyRowErrors in h-bocx332.
        RUN emptyRowObject IN h-bocx332.
        run setRecord in h-bocx332 (input table tt-movto-ato).
        run createRecord in h-bocx332.
        EMPTY TEMP-TABLE tt-movto-ato.        
    END.
    RETURN "OK":U.
    
END PROCEDURE.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEfetivaPedidoDrbItem DBOProgram
PROCEDURE piEfetivaPedidoDrbItem :
/*------------------------------------------------------------------------------
  Purpose:     Realizar a efetivaá∆o da tabela pedido-drb-item
  Parameters:  Entrada: handle j† instanciado da bocx315.p atravÇs da procedure
               ValidateAtoConcessorio
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER ph-bocx315 AS HANDLE NO-UNDO.

    IF  CAN-FIND(FIRST tt-pedido-drb-item) THEN DO:
        RUN openQueryStatic IN ph-bocx315 (INPUT "Main":U).
        RUN goToKey         IN ph-bocx315 (INPUT tt-pedido-drb-item.cod-estabel,
                                           INPUT tt-pedido-drb-item.nr-pedido-drb,
                                           INPUT tt-pedido-drb-item.it-codigo).
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN emptyRowErrors  IN ph-bocx315.
            RUN emptyRowObject  IN ph-bocx315.
            RUN setRecord       IN ph-bocx315 (INPUT TABLE tt-pedido-drb-item).
            RUN updateRecord    IN ph-bocx315.
        END.
        DELETE tt-pedido-drb-item.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
