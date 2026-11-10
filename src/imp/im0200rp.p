/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0200RP 2.00.00.036 } /*** 010036 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0200RP MIM}
&ENDIF

{include/i_fnctrad.i}
/*****************************************************************************
**
**  IM0200rp.p - Relatorio Importacao
**
**  Objetivo: Emissao de Declaracoes/Comunicacoes.
**
******************************************************************************/

/* defini‡Æo de vari veis e tt-var utilizadas para a conversÆo das vari veis do texto das declara‡äes*/
{cdp/cd2550.i3}

{include/tt-edit.i} /* Def. Temp-table para impressao de campos editores */
{imp/im0200.i5}     /* Defini‡Æo tt-param   */
{utp/utapi009.i}    /* Temp-table para envio de e-mail */
{imp/im0200.i6}     /* Defini‡Æo frames     */
{cdp/cdcfgmat.i}    /* Defini‡Æo pre-processador do magnus*/  
{cdp/cdcfgdis.i}
{cdp/cdcfgcex.i}
{cdp/cd4300.i3}     /* Include para desmembrar atributos livres */
{rep/re1001c.i50}   /* variÿveis e informa»„es utilizadas pelo re1001c.i51 */
{include/boerrtab.i}
{utp/ut-glob.i}

def var l-imprime     as logical                no-undo.
def var l-continua    as logical                no-undo.
def var l-param       like param-global.exp-cep no-undo.
def var c-remetente   as char format "x(120)"   no-undo.
def var i-arq         as integer init 0         no-undo.
def var h-acomp       as handle                 no-undo.
def var c-acompanha   as char                   no-undo.
def var i-seq-erro    as integer                no-undo.
def var c-comprador   as char                   no-undo.
def var i-dt-ult-prev as integer                no-undo.
DEF VAR l-decl-proc   AS LOG INIT "yes"         NO-UNDO.
DEF VAR l-decl-emb    AS LOG INIT "yes"         NO-UNDO.

/*------------ Envio e-mail -------------*/

def var c-arq             as char    no-undo.
def var c-arq-anexo       as char    no-undo.   
def var c-assunto-e-mail  as char    no-undo.
def var c-mensagem-e-mail as char format "x(38)" no-undo.
{cdp/cdapi523.i "h-prg523"}
/*---------------------------------------*/

def temp-table tt-raw-digita
    field raw-digita as raw.

/* Parametros */ 
def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

{utp/ut-liter.i Acompanha_EmissÆo_Declara‡äes * r}.
assign c-acompanha = return-value.
{utp/ut-liter.i "comprador"}
assign c-comprador = return-value.

create tt-param.
raw-transfer raw-param to tt-param.

{include/i-rpvar.i}

DEF BUFFER decl-hist-proc-impb   FOR decl-hist-proc-imp.
DEF BUFFER decl-hist-embarq-impb FOR decl-hist-embarq-imp.
DEF BUFFER bf-historico-embarque FOR historico-embarque.
assign c-programa     = "im0200"
       c-versao       = "1.00"
       c-revisao      = "000"
       c-titulo-relat = "Declara‡äes/Comunica‡äes"
       c-sistema      = "Com‚rcio Exterior".

{include/i-rpcb80.i}

if tt-param.l-envia = no then do:
   {cdp/cd-rpout.i}   /* include customizada Comex */
   view frame f-cabec-80.
   view frame f-rodape-80.
end.

find first empresa where empresa.ep-codigo = i-ep-codigo-usuario 
    no-lock no-error.
if avail empresa then 
    assign c-empresa = empresa.razao-social.
else 
    assign c-empresa = "".
    
find first param-imp no-lock no-error.
find first param-global no-lock no-error.

if avail param-imp then
    ASSIGN c-arq = session:temp-directory.

    run utp/ut-acomp.p persistent set h-acomp.
    run pi-inicializar in h-acomp(input c-acompanha).
    
    IF  tt-param.c-emb-ini   <> "" OR              
        tt-param.c-emb-fim   <> "ZZZZZZZZZZZZZZZZ" THEN DO:

        IF CAN-FIND (FIRST ordens-embarque WHERE
               ordens-embarque.nr-proc-imp >= tt-param.c-proc-ini AND
               ordens-embarque.nr-proc-imp <= tt-param.c-proc-fim AND
               ordens-embarque.embarque    >= tt-param.c-emb-ini  AND
               ordens-embarque.embarque    <= tt-param.c-emb-fim) THEN DO:

            ASSIGN l-decl-proc = NO.
        END.
        ELSE
            ASSIGN l-decl-proc = NO
                   l-decl-emb  = NO.

    END.
   
    IF l-decl-proc THEN DO:
        for each decl-hist-proc-imp where 
            decl-hist-proc-imp.nr-proc-imp  >= tt-param.c-proc-ini    and
            decl-hist-proc-imp.nr-proc-imp  <= tt-param.c-proc-fim    and 
            decl-hist-proc-imp.cod-itiner   >= tt-param.i-itiner-ini  and
            decl-hist-proc-imp.cod-itiner   <= tt-param.i-itiner-fim  and
            decl-hist-proc-imp.de-codigo    >= tt-param.i-decl-ini    and
            decl-hist-proc-imp.de-codigo    <= tt-param.i-decl-fim exclusive-lock:
            if (decl-hist-proc-imp.decl-emitida = yes) and 
               (not tt-param.l-reemite) then next.
            find historico-proc-imp where
                 historico-proc-imp.cod-estabel   = decl-hist-proc-imp.cod-estabel and
                 historico-proc-imp.nr-proc-imp   = decl-hist-proc-imp.nr-proc-imp and
                 historico-proc-imp.cod-itiner    = decl-hist-proc-imp.cod-itiner  and
                 historico-proc-imp.sequencia     = decl-hist-proc-imp.sequencia   no-lock no-error.             
    
            if not avail historico-proc-imp then next.
            IF historico-proc-imp.cod-pto-contr < tt-param.i-pto-con-ini OR
               historico-proc-imp.cod-pto-contr > tt-param.i-pto-con-fim THEN
               NEXT.
            if historico-proc-im.dt-efetiva = ? then do:
                if historico-proc-imp.dt-ult-prev < tt-param.da-data-ini or
                   historico-proc-imp.dt-ult-prev > tt-param.da-data-fim then
                   next.
            end.
            else do:
                if historico-proc-imp.dt-efetiva < tt-param.da-data-ini or
                   historico-proc-imp.dt-efetiva > tt-param.da-data-fim then
                   next.
            end.
    
            FOR FIRST processo-imp fields(num-pedido nr-proc-imp cod-exportador cod-banco cod-transportador 
                                          cod-despachante via-transp narrativa declaracao-import) where
                      processo-imp.cod-estabel = historico-proc-imp.cod-estabel and
                      processo-imp.nr-proc-imp = historico-proc-imp.nr-proc-imp no-lock:
    
            END.
            if  avail processo-imp then do:
                if  tt-param.l-envia then do:
    
                    FOR FIRST pedido-compr fields(num-pedido responsavel) WHERE 
                              pedido-compr.num-pedido = processo-imp.num-pedido no-lock:
                    END.
                    if   avail pedido-compr then do:
                         &if defined(bf-mat-comex) &then
                             assign c-remetente = tt-param.c-endmail.
                         &else
                             FOR first comprador fields(cod-comprado e-mail) where 
                                  comprador.cod-comprado = pedido-compr.responsavel no-lock :
                             END.
                             if   avail comprador then
                                 if comprador.e-mail = " " then do:
                                    find first tt-bo-erro no-error.
                                    if not avail tt-bo-erro then do:
                                        assign i-seq-erro = i-seq-erro + 1.
                                        create tt-bo-erro.
                                        assign tt-bo-erro.i-sequen     = i-seq-erro
                                               tt-bo-erro.cd-erro      = 26337
                                               tt-bo-erro.mensagem     = return-value.
                                        run utp/ut-msgs.p (input "show",
                                                           input 26337,
                                                           input string(c-comprador) + "~~" + string(comprador.cod-comprado)).
                                        leave.           
                                    end.                       
                                 end.
                             else assign c-remetente = comprador.e-mail.
                         &endif         
                    end.
                end.
    
                find emitente where 
                     emitente.cod-emitente = processo-imp.cod-exportador no-lock no-error.
    
                if not avail emitente then next.
                
                find itinerario where 
                     itinerario.cod-itiner = historico-proc-imp.cod-itiner no-lock no-error.
                if   not avail itinerario then next.    
                run pi-acompanhar in h-acomp(input historico-proc-imp.nr-proc-imp).
                
                find pto-contr where
                     pto-contr.cod-pto-contr = itinerario.pto-embarque no-lock no-error.
                IF AVAIL pto-contr THEN
                    assign c-desc-embarq = pto-contr.descricao.
                
                find pto-contr where
                     pto-contr.cod-pto-contr = itinerario.pto-desembarque no-lock no-error.
    
                if   avail pto-contr then
                     assign c-desc-desemb = pto-contr.descricao.        
    
                if tt-param.l-envia then do: /* op‡Æo envio de e-mail */
                    /* Verifica e imprime declaracoes */
                    run pi-mail-processo.
                end.
                else do:
                     run pi-imprime-processo.
                end.
           end.
        END.
    END.
    IF l-decl-emb THEN DO:
        for each decl-hist-embarq-imp where 
                 decl-hist-embarq-imp.embarque    >= tt-param.c-emb-ini    and
                 decl-hist-embarq-imp.embarque    <= tt-param.c-emb-fim    and 
                 decl-hist-embarq-imp.cod-itiner  >= tt-param.i-itiner-ini and
                 decl-hist-embarq-imp.cod-itiner  <= tt-param.i-itiner-fim and
                 decl-hist-embarq-imp.de-codigo   >= tt-param.i-decl-ini   and
                 decl-hist-embarq-imp.de-codigo   <= tt-param.i-decl-fim exclusive-lock:
        
            
            if (decl-hist-embarq-imp.decl-emitida = yes) and 
               (not tt-param.l-reemite) then next.
        
            find first historico-embarque where
                       historico-embarque.cod-estabel   = decl-hist-embarq-imp.cod-estabel and
                       historico-embarque.embarque      = decl-hist-embarq-imp.embarque    and
                       historico-embarque.cod-itiner    = decl-hist-embarq-imp.cod-itiner  and
                       historico-embarque.sequencia     = decl-hist-embarq-imp.sequencia   no-lock no-error.             
               
            if not avail historico-embarque then next.
        
            IF historico-embarque.cod-pto-contr < tt-param.i-pto-con-ini OR
               historico-embarque.cod-pto-contr > tt-param.i-pto-con-fim THEN
               NEXT.
            
            if historico-embarque.dt-efetiva = ? then do:
                if historico-embarque.dt-ult-prev < tt-param.da-data-ini or
                   historico-embarque.dt-ult-prev > tt-param.da-data-fim then do:
                   next.
                end.
            end.
            else do:
                if historico-embarque.dt-efetiva < tt-param.da-data-ini or
                   historico-embarque.dt-efetiva > tt-param.da-data-fim then do:
                   next.
                end.
            end.
        
            FOR FIRST embarque-imp fields(cod-estabel embarque cod-via-transp declaracao-import cod-banco cod-transportador cdn-pto-desembar cdn-pto-embarq
                                          cod-despachante cod-via-transp narrativa cod-incoterm) where
                      embarque-imp.cod-estabel = historico-embarque.cod-estabel and
                      embarque-imp.embarque    = historico-embarque.embarque    no-lock:
            END.
            
            FIND FIRST ordens-embarque WHERE
                       ordens-embarque.cod-estabel  = embarque-imp.cod-estabel AND
                       ordens-embarque.embarque     = embarque-imp.embarque    AND
                       ordens-embarque.nr-proc-imp >= tt-param.c-proc-ini      AND
                       ordens-embarque.nr-proc-imp <= tt-param.c-proc-fim NO-LOCK NO-ERROR.
        
            IF NOT AVAIL ordens-embarque THEN NEXT.
            
            for each processo-imp where
                     processo-imp.cod-estabel = embarque-imp.cod-estabel AND
                     processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp no-lock:
                    
                    FOR FIRST pedido-compr fields(num-pedido responsavel) where 
                              pedido-compr.num-pedido = processo-imp.num-pedido no-lock:
        
                        IF tt-param.l-traduz THEN DO:
                            {imp/im9998.i c-titulo-relat c-titulo-relat processo-imp}
                            {imp/im9998.i c-sistema c-sistema processo-imp}
                            ASSIGN c-rodape = "DATASUL - ":U + c-sistema + " - " + c-prg-obj + " - V:":U + c-prg-vrs.
                                   c-rodape = fill("-", 80 - length(c-rodape)) + c-rodape.
                        END.
                    END.
        
                    run pi-acompanhar in h-acomp(input pedido-compr.num-pedido).    
        
                    &if defined(bf-mat-comex) &then
                         assign c-remetente = tt-param.c-endmail.
                    &else
                         if tt-param.l-envia then do:     
                            if  avail pedido-compr then do:
                                FIND comprador where 
                                     comprador.cod-comprado = pedido-compr.responsavel no-lock no-error.
        
                                 if avail comprador then
                                     if comprador.e-mail = " " then do:
                                        if not avail tt-bo-erro then do:
                                            assign i-seq-erro = i-seq-erro + 1.
                                            create tt-bo-erro.
                                            assign tt-bo-erro.i-sequen     = i-seq-erro
                                                   tt-bo-erro.cd-erro      = 26337
                                                   tt-bo-erro.mensagem     = comprador.cod-comprado.
                                            run utp/ut-msgs.p (input "show",
                                                               input 26337,
                                                               input string(c-comprador) + "~~" + string(comprador.cod-comprado)).
                                            leave.           
                                        end.
                                        leave.                                  
                                     end.
                                 else assign c-remetente = comprador.e-mail.
                            end.     
                         end.
                    &endif                                
                     
                    FOR first  ordens-embarque fields(embarque)where
                               ordens-embarque.cod-estabel  = embarque-imp.cod-estabel AND 
                               ordens-embarque.nr-proc-imp  = processo-imp.nr-proc-imp and
                               ordens-embarque.embarque     = embarque-imp.embarque    no-lock:
                    END.
        
                    if not avail ordens-embarque then
                         next.
        
                    find emitente where emitente.cod-emitente = processo-imp.cod-exportador 
                         no-lock no-error.
                    if not avail emitente then next.
        
                    find itinerario where 
                         itinerario.cod-itiner = historico-embarque.cod-itiner no-lock no-error.
                    if   not avail itinerario then next.     
                     
                    FOR FIRST bf-historico-embarque FIELDS(descricao)
                        WHERE bf-historico-embarque.cod-estabel   = decl-hist-embarq-imp.cod-estabel
                          AND bf-historico-embarque.embarque      = decl-hist-embarq-imp.embarque
                          AND bf-historico-embarque.cod-itiner    = decl-hist-embarq-imp.cod-itiner
                          AND bf-historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-embarq:
                        ASSIGN c-desc-embarq = bf-historico-embarque.descricao.
                    END.

                    IF c-desc-embarq = "":U THEN DO:
                        FOR FIRST pto-contr FIELDS(descricao) NO-LOCK
                             WHERE pto-contr.cod-pto-contr = embarque-imp.cdn-pto-embarq:
                            assign c-desc-embarq = pto-contr.descricao.
                        END.
                    END.
                     
                    FOR FIRST bf-historico-embarque FIELDS(descricao)
                        WHERE bf-historico-embarque.cod-estabel   = decl-hist-embarq-imp.cod-estabel
                          AND bf-historico-embarque.embarque      = decl-hist-embarq-imp.embarque
                          AND bf-historico-embarque.cod-itiner    = decl-hist-embarq-imp.cod-itiner
                          AND bf-historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar:
                        ASSIGN c-desc-desemb = bf-historico-embarque.descricao.
                    END.
                    
                    IF c-desc-desemb = "":U THEN DO:
                        FOR FIRST pto-contr FIELDS(descricao) NO-LOCK
                            WHERE pto-contr.cod-pto-contr = embarque-imp.cdn-pto-desembar:
                            ASSIGN c-desc-desemb = pto-contr.descricao.
                        END.
                    END.
                    
                    create tt-processo-imp.
                    assign tt-processo-imp.c-nr-proc-imp  = processo-imp.nr-proc-imp.
            end.
        
            FOR  first ordens-embarque fields(cod-estabel embarque nr-proc-imp) where
                       ordens-embarque.cod-estabel = decl-hist-embarq-imp.cod-estabel and
                       ordens-embarque.embarque    = decl-hist-embarq-imp.embarque
                       no-lock :
            END.
        
            if avail ordens-embarque then
        
               find  processo-imp where
                     processo-imp.cod-estabel = ordens-embarque.cod-estabel and
                     processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp no-lock no-error.
            if avail processo-imp then
        
               find  emitente where
                     emitente.cod-emitente = processo-imp.cod-exportador no-lock no-error.
            if tt-param.l-envia then do: /*Op‡Æo de envio de e-mail */
               run pi-mail-embarque.
            end.
        
            if not tt-param.l-envia then do:
               run pi-imprime-embarque.
            end.
        end.
    END.

    page.

    if tt-param.l-envia   = no and 
       tt-param.l-imprime = yes then do:
        disp c-lb-tit-sel
             tt-param.c-proc-ini
             tt-param.c-proc-fim
             tt-param.c-emb-ini
             tt-param.c-emb-fim
             tt-param.i-decl-ini
             tt-param.i-decl-fim
             tt-param.i-itiner-ini
             tt-param.i-itiner-fim
             tt-param.da-data-ini
             tt-param.da-data-fim
             tt-param.i-pto-con-ini
             tt-param.i-pto-con-fim
             c-lb-tit-imp
             c-lb-destino
             tt-param.destino
             tt-param.arquivo
             c-lb-usuario 
             tt-param.usuario
             with frame f-param.
    end.           

{include/pi-edit.i}

/* Problemas gerados no envio de e-mail */                
find first tt-erros no-error.
if avail tt-erros then do:
    assign tt-erros.desc-erro = c-erros + string(tt-erros.cod-erro) + 
                                " - " + tt-erros.desc-erro. 
    run utp/ut-msgs.p (input "show",
                       input 17567,
                       input tt-erros.desc-erro).                  
end.
                   
OUTPUT CLOSE.

run pi-finalizar in h-acomp.

return 'OK'.


procedure pi-mail-processo:
/*
** Chama include de impressÆo op‡Æo envio de e-mail das declara‡äes dos processos.
*/
if not avail tt-processo-imp THEN DO:
    FIND decl-hist-proc-impb WHERE
         decl-hist-proc-impb.cod-estabel = decl-hist-proc-imp.cod-estabel AND
         decl-hist-proc-impb.nr-proc-imp = decl-hist-proc-imp.nr-proc-imp AND
         decl-hist-proc-impb.cod-itiner  = decl-hist-proc-imp.cod-itiner  AND
         decl-hist-proc-impb.sequencia   = decl-hist-proc-imp.sequencia  AND
         decl-hist-proc-impb.de-codigo   = decl-hist-proc-imp.de-codigo  EXCLUSIVE-LOCK NO-ERROR.
    {imp/im0200.i11 historico-proc-imp nr-proc-imp proc-impb}
END.
end procedure.


procedure pi-imprime-processo:
/*
** Chama include de impressÆo op‡äes arquivo/terminal/impressora das declara‡äes dos processos.
*/
if not avail tt-processo-imp THEN DO:
    FIND decl-hist-proc-impb WHERE
         decl-hist-proc-impb.cod-estabel = decl-hist-proc-imp.cod-estabel AND
         decl-hist-proc-impb.nr-proc-imp = decl-hist-proc-imp.nr-proc-imp AND
         decl-hist-proc-impb.cod-itiner  = decl-hist-proc-imp.cod-itiner  AND
         decl-hist-proc-impb.sequencia   = decl-hist-proc-imp.sequencia  AND
         decl-hist-proc-impb.de-codigo   = decl-hist-proc-imp.de-codigo  EXCLUSIVE-LOCK NO-ERROR.

    {imp/im0200.i12 historico-proc-imp nr-proc-imp proc-impb}
END.
end procedure.


procedure pi-mail-embarque:
/*
** Chama include de impressÆo op‡Æo envio de e-mail das declara‡äes dos embarques.
*/
if avail tt-processo-imp THEN DO:
    FIND decl-hist-embarq-impb WHERE
         decl-hist-embarq-impb.cod-estabel = decl-hist-embarq-imp.cod-estabel AND
         decl-hist-embarq-impb.embarque    = decl-hist-embarq-imp.embarque    AND
         decl-hist-embarq-impb.cod-itiner  = decl-hist-embarq-imp.cod-itiner  AND
         decl-hist-embarq-impb.sequencia   = decl-hist-embarq-imp.sequencia   AND
         decl-hist-embarq-impb.de-codigo   = decl-hist-embarq-imp.de-codigo   EXCLUSIVE-LOCK NO-ERROR.

    {imp/im0200.i1 historico-embarque embarque embarq-impb}
END.
end procedure.


procedure pi-imprime-embarque:
/*
** Chama include de impressÆo op‡äes arquivo/terminal/impressora das declara‡äes dos embarques.
*/
if avail tt-processo-imp THEN DO:
    FIND decl-hist-embarq-impb WHERE
         decl-hist-embarq-impb.cod-estabel = decl-hist-embarq-imp.cod-estabel AND
         decl-hist-embarq-impb.embarque    = decl-hist-embarq-imp.embarque    AND
         decl-hist-embarq-impb.cod-itiner  = decl-hist-embarq-imp.cod-itiner  AND
         decl-hist-embarq-impb.sequencia   = decl-hist-embarq-imp.sequencia   AND
         decl-hist-embarq-impb.de-codigo   = decl-hist-embarq-imp.de-codigo   EXCLUSIVE-LOCK NO-ERROR.

    {imp/im0200.i historico-embarque embarque embarq-impb}
END.
end procedure.
