/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0088RP 2.00.00.017 } /*** 010017 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0088rp MIM}
&ENDIF

{include/i_fnctrad.i}
/******************************************************************************
**
**       PROGRAMA:  IM0088RP.P
**
**       DATA....:  DEZEMBRO DE 2015
**
**       OBJETIVO:  Material em Transito de Importaá∆o
**
**
******************************************************************************/
{imp/im0088.i}       /* Definiá∆o de Temp-tables */
{imp/im0088.i1}      /* Definiá∆o de Forms */
{imp/im0088.i2}      /* Definiá∆o de Forms API Finanáas */

{method/dbotterr.i}  /* temp-table RowErrors */                      
{include/tt-edit.i} /* para impressío da mensagem de erro */
{include/pi-edit.i} /* para impressío da mensagem de erro */

/* Parametros do relatorio */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

DEFINE VARIABLE i-empresa-prin           like param-global.empresa-prin NO-UNDO.
DEFINE VARIABLE h-acomp                  AS HANDLE                      NO-UNDO.
DEFINE VARIABLE c-acompanha              AS CHARACTER FORMAT "x(15)":U  NO-UNDO.
DEFINE VARIABLE c-erro                   AS CHARACTER FORMAT "x(70)":U  NO-UNDO.
DEFINE VARIABLE h-acr933zb               AS HANDLE                      NO-UNDO.

IF NOT VALID-HANDLE(h-acr933zb) THEN
    RUN prgfin/acr/acr933zb.py PERSISTENT SET h-acr933zb.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

FIND FIRST tt-param NO-ERROR.
FIND FIRST param-global NO-LOCK NO-ERROR.

IF tt-param.destino = 4 /*excel*/ THEN DO:
    IF SUBSTRING(tt-param.arquivo,LENGTH(tt-param.arquivo) - 3) <> ".xml":U THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 26426, INPUT ".xml":U). 
        RETURN "ERROR":U.
    END.
    ASSIGN tt-param.arquivo = REPLACE(tt-param.arquivo,".xml",".tmp")
           tt-param.arquivo = REPLACE(tt-param.arquivo, "/", "~\").
END.

if tt-param.i-sit-proc <> 5 then do:
   ASSIGN c-sit-proc = {cxinc/i01cx140.i 04 tt-param.i-sit-proc}.
end.
else do:
     {utp/ut-liter.i Todos * r}
     assign c-sit-proc = trim(return-value).
end.

if  tt-param.i-sit-emb <> 3 then do:
    ASSIGN c-sit-emb = {cxinc/i01cx220.i 04 tt-param.i-sit-emb}.    
end.
else do:
    {utp/ut-liter.i Todos * r}
    assign c-sit-emb = trim(return-value).
end.           

{include/i-rpvar.i}
{include/i-rpcab.i}
{include/i-rpout.i}

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

{utp/ut-liter.i Imprimindo_embarques * r}.
ASSIGN c-acompanha = RETURN-VALUE.
RUN pi-inicializar IN h-acomp(INPUT c-acompanha).

/* Limpa tabela temporaria */
EMPTY TEMP-TABLE tt-embarque-contab. 

RUN piPrincipal.
RUN BuscaTituloAp.

IF VALID-HANDLE(h-acr933zb) THEN DO:
    DELETE PROCEDURE h-acr933zb.
    ASSIGN h-acr933zb = ?.
END.

{utp/ut-liter.i Material_em_TrÉnsito_Importaá∆o * r}
ASSIGN c-titulo-relat = trim(return-value).
{utp/ut-liter.i Importaá∆o * r}
ASSIGN c-sistema = trim(return-value).

ASSIGN c-empresa  = (IF AVAIL param-global THEN param-global.grupo ELSE "")
       c-programa = "IM0088"
       c-versao   = "1.00"
       c-revisao  = "001".

main-block:
do  on error  undo main-block, leave main-block
    on endkey undo main-block, leave main-block
    on stop   undo main-block, leave main-block:
    
    /* Procedure interna utilizada para listar os embarques */
    RUN piImprimirEmbarques IN THIS-PROCEDURE.
END.

if  page-number > 0 then page.
hide frame f-cabec-colum.
RUN pi-imprime-parametros IN THIS-PROCEDURE.

RUN pi-finalizar IN h-acomp.
/* Fechamento do output do relat¢rio */
{include/i-rpclo.i}

PROCEDURE piPrincipal:
     bloco: 
     FOR EACH historico-embarque 
         WHERE historico-embarque.cod-estabel  >= tt-param.c-cod-estabel-ini  
           AND historico-embarque.cod-estabel  <= tt-param.c-cod-estabel-fim 
           AND historico-embarque.embarque     >= tt-param.c-embarque-ini    
           AND historico-embarque.embarque     <= tt-param.c-embarque-fim NO-LOCK:    

         IF CAN-FIND(FIRST tt-embarque-contab WHERE
            tt-embarque-contab.cod-estabel = historico-embarque.cod-estabel AND     
            tt-embarque-contab.embarque    = historico-embarque.embarque)   THEN NEXT.

         FOR FIRST embarque-imp 
             WHERE embarque-imp.cod-estabel = historico-embarque.cod-estabel
               AND embarque-imp.embarque    = historico-embarque.embarque NO-LOCK:
         END.
         IF NOT AVAIL embarque-imp THEN NEXT.

         /* Verificar se considera somente embarques contabilizados */ 
         IF tt-param.contabiliza AND NOT embarque-imp.contabilizado THEN NEXT. 

         /* Situaá∆o do Embarque */
         IF tt-param.i-sit-emb <> 3 THEN                                   
            IF embarque-imp.situacao <> tt-param.i-sit-emb THEN NEXT. 
         
         /*** Verificar ponto de controle que ser† contabilizado em transito ***/
         FOR FIRST incoterm-itiner                                          
             WHERE incoterm-itiner.cod-itiner    = historico-embarque.cod-itiner       
               AND incoterm-itiner.cod-pto-contr = historico-embarque.cod-pto-contr    
               AND incoterm-itiner.cod-incoterm  = embarque-imp.cod-incoterm NO-LOCK:  
         END.                                                                            
         IF NOT AVAIL incoterm-itiner THEN NEXT.    
         
         /*** Verificar se esta dentro da faixa de data do ponto de contabilizaá∆o ***/
         IF  historico-embarque.dt-efetiva <> ? THEN DO:                      
             IF  historico-embarque.dt-efetiva < tt-param.dt-prevista-ini            
             OR  historico-embarque.dt-efetiva > tt-param.dt-prevista-fim THEN NEXT.                                                        
         END.                                                                 
         ELSE DO:                                                             
             IF  historico-embarque.dt-ult-previsao < tt-param.dt-prevista-ini       
             OR  historico-embarque.dt-ult-previsao > tt-param.dt-prevista-fim THEN NEXT.                                                        
         END.

         FOR FIRST itinerario FIELDS(cod-itiner pto-embarque pto-desembarque)
             WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK:
         END.

         /*** Verificar se o fornecedor esta dentro da faixa ***/
         FIND FIRST ordens-embarque 
              WHERE  ordens-embarque.cod-estabel = embarque-imp.cod-estabel
                AND  ordens-embarque.embarque    = embarque-imp.embarque NO-LOCK NO-ERROR.
         IF AVAIL ordens-embarque THEN DO:            
            IF NOT CAN-FIND (FIRST processo-imp
                             WHERE processo-imp.cod-estabel     = ordens-embarque.cod-estabel
                             AND   processo-imp.nr-proc-imp     = ordens-embarque.nr-proc-imp
                             AND   processo-imp.cod-exportador >= i-fornecedor-ini
                             AND   processo-imp.cod-exportador <= i-fornecedor-fim) THEN NEXT.

            FOR FIRST processo-imp
                 WHERE processo-imp.cod-estabel = ordens-embarque.cod-estabel
                   AND processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp NO-LOCK:  
            END.
            IF NOT AVAIL processo-imp THEN NEXT.

            FOR FIRST estabelec 
                 WHERE estabelec.cod-estabel = processo-imp.cod-estabel NO-LOCK:
    
                ASSIGN i-empresa-prin = param-global.empresa-prin.
                RUN cdp/cd9970.p (INPUT ROWID(estabelec),
                                  OUTPUT i-empresa-prin).
            END.

            /* Situaá∆o do Processo */
            IF tt-param.i-sit-proc <> 5 THEN 
               IF processo-imp.situacao <> tt-param.i-sit-proc THEN NEXT. 
         END.

         /*** Verificar se j† foi nacionalizado e se tem NF atualizada no AP ***/
         FOR FIRST b-historico-embarque 
             WHERE b-historico-embarque.cod-estabel   = historico-embarque.cod-estabel
               AND b-historico-embarque.embarque      = historico-embarque.embarque
               AND b-historico-embarque.cod-itiner    = itinerario.cod-itiner 
               AND b-historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar no-lock:
         END.
         IF AVAIL b-historico-embarque THEN DO:            
            IF  b-historico-embarque.dt-efetiva <> ? THEN DO:
                FIND FIRST docum-est WHERE
                     docum-est.cod-estabel = historico-embarque.cod-estabel AND
                     &if defined(bf-mat-comex) &then
                         TRIM(SUBSTRING((docum-est.char-1,2,12)) = b-historico-embarque.embarque AND
                     &else
                         TRIM(substring(docum-est.char-1,1,20)) = b-historico-embarque.embarque  AND
                     &endif
                     docum-est.ap-atual = YES NO-LOCK NO-ERROR.                      
                IF AVAIL docum-est THEN NEXT.
            END.
         END.
         
         FIND param-imp 
              WHERE param-imp.cod-estabel = historico-embarque.cod-estabel NO-LOCK NO-ERROR.

         /* Grava ponto de embarque e data efetiva */
         FOR FIRST b-historico-embarque 
             WHERE b-historico-embarque.cod-estabel   = historico-embarque.cod-estabel
               AND b-historico-embarque.embarque      = historico-embarque.embarque
               AND b-historico-embarque.cod-itiner    = itinerario.cod-itiner 
               AND b-historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-embarq no-lock:
         END.
         IF AVAIL b-historico-embarque THEN
            ASSIGN i-pto-contr = b-historico-embarque.cod-pto-contr
                   d-data-emb  = b-historico-embarque.dt-efetiva. 

         FOR FIRST emitente fields( cod-emitente  nome-abrev )
             WHERE emitente.cod-emitente = processo-imp.cod-exportador NO-LOCK:
         END.     

         /* Cria temp-table do embarque */
         FIND FIRST tt-embarque-contab WHERE
              tt-embarque-contab.cod-estabel =  embarque-imp.cod-estabel    AND       
              tt-embarque-contab.cod-fornec  =  processo-imp.cod-exportador AND
              tt-embarque-contab.cod-esp     =  param-imp.esp-tit-transit   AND           
              tt-embarque-contab.serie       =  ""                          AND             
              tt-embarque-contab.nr-docto    =  embarque-imp.embarque       NO-LOCK NO-ERROR.          
         IF NOT AVAIL tt-embarque-contab THEN DO:
             CREATE tt-embarque-contab.
             ASSIGN tt-embarque-contab.cod-estabel    = embarque-imp.cod-estabel
                    tt-embarque-contab.embarque       = embarque-imp.embarque
                    tt-embarque-contab.ep-codigo      = i-empresa-prin
                    tt-embarque-contab.cod-esp        = param-imp.esp-tit-transit
                    tt-embarque-contab.serie          = ""
                    tt-embarque-contab.parcela        = ""
                    tt-embarque-contab.nr-docto       = embarque-imp.embarque
                    tt-embarque-contab.cod-fornec     = processo-imp.cod-exportador
                    tt-embarque-contab.desc-emit      = if avail emitente then emitente.nome-abrev else "":U
                    tt-embarque-contab.pto-incoterm   = historico-embarque.cod-pto-contr
                    tt-embarque-contab.data-incoterm  = historico-embarque.dt-efetiva
                    tt-embarque-contab.pto-embarque   = i-pto-contr
                    tt-embarque-contab.data-embarque  = d-data-emb
                    tt-embarque-contab.contabilizado  = embarque-imp.contabilizado
                    tt-embarque-contab.situacao       = {cxinc/i01cx140.i 04 processo-imp.situacao}.    
         END.
     END.

END PROCEDURE.

PROCEDURE BuscaTituloAp:

    FOR EACH b-tt-embarque-contab
        BREAK BY b-tt-embarque-contab.cod-estabel
              BY b-tt-embarque-contab.embarque:
                    
        /* T°tulos do Contas a Pagar - inicio */
        EMPTY TEMP-TABLE tt_consult_tit_ap.
        EMPTY TEMP-TABLE tt_retorno_tit_ap.
        
        CREATE tt_consult_tit_ap.
        ASSIGN tt_consult_tit_ap.ttv_num_tip_leitura      = 6 /* chave sem parcela */
               tt_consult_tit_ap.tta_cod_estab            = b-tt-embarque-contab.cod-estabel
               tt_consult_tit_ap.tta_cdn_fornecedor       = INTEGER(b-tt-embarque-contab.cod-fornec)
               tt_consult_tit_ap.tta_cod_espec_docto      = b-tt-embarque-contab.cod-esp
               tt_consult_tit_ap.tta_cod_ser_docto        = b-tt-embarque-contab.serie
               tt_consult_tit_ap.tta_cod_tit_ap           = b-tt-embarque-contab.nr-docto.

        RUN pi_consult_tit_ap IN h-acr933zb (INPUT TABLE  tt_consult_tit_ap,
                                             OUTPUT TABLE tt_retorno_tit_ap,
                                             OUTPUT TABLE tt_retorno_val_tit_ap,
                                             OUTPUT TABLE tt_retorno_movto_tit_ap,
                                             OUTPUT TABLE tt_retorno_val_movto_tit_ap,
                                             OUTPUT TABLE tt_log_erro).           

        FIND FIRST tt_retorno_tit_ap NO-LOCK NO-ERROR.
        /* Complementa informaá‰es para primeira parcela do embarque */
        IF AVAIL tt_retorno_tit_ap THEN DO:
           ASSIGN b-tt-embarque-contab.parcela        = tt_retorno_tit_ap.cod_parcela
                  b-tt-embarque-contab.desc-moeda     = tt_retorno_tit_ap.cod_indic_econ    
                  b-tt-embarque-contab.data-emissao   = tt_retorno_tit_ap.dat_emis_docto    
                  b-tt-embarque-contab.data-prev-pag  = tt_retorno_tit_ap.dat_prev_pagto    
                  b-tt-embarque-contab.de-vl-orig     = tt_retorno_tit_ap.val_origin_tit_ap 
                  b-tt-embarque-contab.de-vl-saldo    = tt_retorno_tit_ap.val_sdo_tit_ap. 
        END.            

        /* Cria um registro na tabela tempor†ria para as demais parcelas do embarque */
        FOR EACH tt_retorno_tit_ap NO-LOCK: 
            IF b-tt-embarque-contab.parcela <> tt_retorno_tit_ap.cod_parcela THEN DO:
               CREATE tt-embarque-contab.
               ASSIGN tt-embarque-contab.cod-estabel    = tt_retorno_tit_ap.cod_estab
                      tt-embarque-contab.embarque       = tt_consult_tit_ap.tta_cod_tit_ap                                                          
                      tt-embarque-contab.ep-codigo      = i-empresa-prin
                      tt-embarque-contab.cod-esp        = tt_retorno_tit_ap.cod_espec_docto                                                      
                      tt-embarque-contab.serie          = tt_retorno_tit_ap.cod_ser_docto                                                                             
                      tt-embarque-contab.parcela        = tt_retorno_tit_ap.cod_parcela
                      tt-embarque-contab.nr-docto       = tt_consult_tit_ap.tta_cod_tit_ap                                                          
                      tt-embarque-contab.cod-fornec     = tt_retorno_tit_ap.cdn_fornecedor 
                      tt-embarque-contab.desc-emit      = b-tt-embarque-contab.desc-emit      
                      tt-embarque-contab.pto-incoterm   = b-tt-embarque-contab.pto-incoterm 
                      tt-embarque-contab.data-incoterm  = b-tt-embarque-contab.data-incoterm
                      tt-embarque-contab.pto-embarque   = b-tt-embarque-contab.pto-embarque 
                      tt-embarque-contab.data-embarque  = b-tt-embarque-contab.data-embarque                                              
                      tt-embarque-contab.contabilizado  = b-tt-embarque-contab.contabilizado 
                      tt-embarque-contab.situacao       = b-tt-embarque-contab.situacao
                      tt-embarque-contab.desc-moeda     = tt_retorno_tit_ap.cod_indic_econ    
                      tt-embarque-contab.data-emissao   = tt_retorno_tit_ap.dat_emis_docto    
                      tt-embarque-contab.data-prev-pag  = tt_retorno_tit_ap.dat_prev_pagto    
                      tt-embarque-contab.de-vl-orig     = tt_retorno_tit_ap.val_origin_tit_ap 
                      tt-embarque-contab.de-vl-saldo    = tt_retorno_tit_ap.val_sdo_tit_ap.   
            END.
        END.
    END.
            
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE piImprimirEmbarques:

    IF tt-param.destino = 4 /* excel */ THEN DO:
        OUTPUT CLOSE.
        RUN imp/im0088rp1.p  (INPUT TABLE tt-param,
                              INPUT TABLE tt-embarque-contab).
    END.
    ELSE DO:
        IF tt-param.classifica = 1 THEN DO:
           /* Embarques contabilizados */
           IF CAN-FIND(FIRST tt-embarque-contab WHERE
               tt-embarque-contab.contabilizado AND
               tt-embarque-contab.parcela <> "") then do:       
               disp c-titulo-contab with frame f-tit1.
    
               for each tt-embarque-contab
                   where tt-embarque-contab.contabilizado 
                   and   tt-embarque-contab.parcela <> ""
                   break by tt-embarque-contab.cod-estabel
                         by tt-embarque-contab.embarque
                         by tt-embarque-contab.cod-fornec:
                   {imp/im0088.i3 "1"}
               END.
           END.
           
           /* Embarques contabilizados sem t°tulos no AP */
           IF CAN-FIND(FIRST tt-embarque-contab WHERE
               tt-embarque-contab.contabilizado AND  
               tt-embarque-contab.parcela = "") then do:       
               disp c-titulo-erro with frame f-tit3.
               disp c-lb-estab   
                    c-lb-emb     
                    c-lb-fornec  
                    c-lb-nome    
                    c-lb-contab  
                    c-lb-pto-inc 
                    c-lb-dt-inc  
                    c-lb-pto-emb 
                    c-lb-dt-emb  
                         
                    with stream-io frame f-cab-corpo2.
    
               for each tt-embarque-contab
                   where tt-embarque-contab.contabilizado   
                   and   tt-embarque-contab.parcela = ""
                   break by tt-embarque-contab.cod-estabel
                         by tt-embarque-contab.embarque
                         by tt-embarque-contab.cod-fornec:
                   {imp/im0088.i3 "2"}
               END.
           END.
    
           /* Embarques n∆o contabilizados */
           IF CAN-FIND(FIRST tt-embarque-contab WHERE
               NOT tt-embarque-contab.contabilizado) then do:
               disp c-titulo-n-contab with frame f-tit2.
               disp c-lb-estab   
                    c-lb-emb     
                    c-lb-fornec  
                    c-lb-nome    
                    c-lb-contab  
                    c-lb-pto-inc 
                    c-lb-dt-inc  
                    c-lb-pto-emb 
                    c-lb-dt-emb  
                         
                    with stream-io frame f-cab-corpo2.
               for each tt-embarque-contab
                   where NOT tt-embarque-contab.contabilizado   
                   break by tt-embarque-contab.cod-estabel
                         by tt-embarque-contab.embarque
                         by tt-embarque-contab.cod-fornec:
                   {imp/im0088.i3 "3"}
               END.
           END.
    
        END.
        ELSE DO: /* Classifica por Fornecedor */
            /* Embarques contabilizados */
            IF CAN-FIND(FIRST tt-embarque-contab WHERE
                tt-embarque-contab.contabilizado AND
                tt-embarque-contab.parcela <> "") then do:       
                disp c-titulo-contab with frame f-tit1.
                for each tt-embarque-contab
                    where tt-embarque-contab.contabilizado   
                    and   tt-embarque-contab.parcela <> ""
                    break by tt-embarque-contab.cod-fornec
                          by tt-embarque-contab.cod-estabel
                          by tt-embarque-contab.embarque:
                    {imp/im0088.i3 "1"}
                END. 
            END.
    
            /* Embarques contabilizados sem t°tulos no AP */
           IF CAN-FIND(FIRST tt-embarque-contab WHERE
               tt-embarque-contab.contabilizado AND  
               tt-embarque-contab.parcela = "") then do:       
               disp c-titulo-erro with frame f-tit3.
               disp c-lb-estab   
                    c-lb-emb     
                    c-lb-fornec  
                    c-lb-nome    
                    c-lb-contab  
                    c-lb-pto-inc 
                    c-lb-dt-inc  
                    c-lb-pto-emb 
                    c-lb-dt-emb  
                         
                    with stream-io frame f-cab-corpo2.
    
               for each tt-embarque-contab
                   where tt-embarque-contab.contabilizado  
                   and   tt-embarque-contab.parcela = ""
                   break by tt-embarque-contab.cod-fornec 
                         by tt-embarque-contab.cod-estabel
                         by tt-embarque-contab.embarque:  
                   {imp/im0088.i3 "2"}
               END.
           END.
    
           /* Embarques n∆o contabilizados */
           IF CAN-FIND(FIRST tt-embarque-contab WHERE
               NOT tt-embarque-contab.contabilizado) then do:
               disp c-titulo-n-contab with frame f-tit2.
               disp c-lb-estab   
                    c-lb-emb     
                    c-lb-fornec  
                    c-lb-nome    
                    c-lb-contab  
                    c-lb-pto-inc 
                    c-lb-dt-inc  
                    c-lb-pto-emb 
                    c-lb-dt-emb  
                         
                    with stream-io frame f-cab-corpo2.
               for each tt-embarque-contab
                   where NOT tt-embarque-contab.contabilizado   
                   break by tt-embarque-contab.cod-fornec 
                         by tt-embarque-contab.cod-estabel
                         by tt-embarque-contab.embarque:  
                   {imp/im0088.i3 "3"}
               END.
           END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-parametros:
    if tt-param.l-imprime-param = yes then do:
      disp c-sel
           tt-param.c-cod-estabel-ini
           tt-param.c-cod-estabel-fim
           tt-param.c-embarque-ini   
           tt-param.c-embarque-fim   
           tt-param.i-fornecedor-ini 
           tt-param.i-fornecedor-fim 
           tt-param.dt-prevista-ini  
           tt-param.dt-prevista-fim  
           c-cla
           tt-param.desc-classifica
           c-sit-emb
           c-sit-proc
           c-par
           tt-param.contabiliza
           c-imp
           c-lb-destino
           tt-param.arquivo
           c-lb-usuario
           tt-param.usuario
           with frame f-parametros.
      down with frame f-parametros.
    end.

    RETURN "OK":U.
END PROCEDURE.

RETURN "OK":U.

