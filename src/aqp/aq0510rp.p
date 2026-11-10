/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0510RP 2.00.00.010 } /*** 010010 ***/ 

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AQ0510RP MAQ}
&ENDIF

/******************************************************************************
**
**       Programa: AQ0510RP.P
**
**       Data....: 23/06/2016.
**
**       Objetivo: Relatorio de Cargas
**                 M¢dulo Aquisi‡Æo de Produtos Rurais.
** 
******************************************************************************/

{utp/ut-glob.i}
{include/tt-edit.i}
{include/i-rpvar.i}
{aqp/aq0510.i}   /* tt-param, tt-digita, tt-raw-digita */ 
{aqp/aq0510rp.i} /* Variaveis, Forms */
{cdp/cd0031.i}   /* Seguranca por Estabelecimento */

FUNCTION fn-logical RETURNS CHARACTER
  ( l-value as LOG )  FORWARD.
  
 FUNCTION fn-situacao-param RETURNS CHARACTER
  ( i-cdn-sit as INT ) FORWARD.


IF NOT VALID-HANDLE(h-acomp) THEN 
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

/* PARAMETERS  */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.    

{include/i-rpcab.i}

{utp/ut-liter.i Relat¢rio_de_Carga}
ASSIGN c-titulo-relat = RETURN-VALUE.
RUN pi-inicializar in h-acomp (INPUT c-titulo-relat).

{utp/ut-liter.i Aquisi‡Æo_de_Produtos_Rurais MAQ}    
ASSIGN c-programa     = "AQ0510":U
       c-versao       = "I.00":U
       c-revisao      = "001":U
       c-sistema      = RETURN-VALUE
       c-rodape       = "TOTVS - " + c-programa  +  " - V:":U + c-versao.
       c-rodape       = FILL("-", 132 - LENGTH(c-rodape)) + c-rodape.

FOR FIRST empresa FIELDS(razao-social) NO-LOCK 
    WHERE empresa.ep-codigo = i-ep-codigo-usuario:
    ASSIGN c-empresa  = empresa.razao-social.
END.

RUN utp/ut-trfrrp.p (INPUT FRAME f-carga         :HANDLE).
RUN utp/ut-trfrrp.p (INPUT FRAME f-tit-pesagem   :HANDLE).
RUN utp/ut-trfrrp.p (INPUT FRAME f-pesagem       :HANDLE).
RUN utp/ut-trfrrp.p (INPUT FRAME f-tit-liber-carg:HANDLE).
RUN utp/ut-trfrrp.p (INPUT FRAME f-liber-carg    :HANDLE).
RUN utp/ut-trfrrp.p (INPUT FRAME f-produt        :HANDLE).
RUN utp/ut-trfrrp.p (INPUT FRAME f-tot-produt    :HANDLE).
RUN utp/ut-trfrrp.p (INPUT FRAME f-tit-nc        :HANDLE).
RUN utp/ut-trfrrp.p (INPUT FRAME f-nc            :HANDLE).
RUN utp/ut-trfrrp.p (INPUT FRAME f-param         :HANDLE). 

{include/i-rpout.i}
VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

IF NOT VALID-HANDLE(h-boin00982) THEN
    RUN inbo/boin00982.p PERSISTENT SET h-boin00982.

DEFINE VARIABLE l-first-page AS LOGICAL INITIAL YES NO-UNDO.    
    
FOR FIRST tt-param:
    ASSIGN c-destino-impressao = {varinc/var00002.i 04 tt-param.destino}.
    
    FOR EACH carg-rural FIELDS(cod-estabel num-carg   cod-carga cod-placa 
                               cod-transp  dat-trans  val-densidade     
                               dat-entr    cdn-sit    val-hodom-inicial
                               qtd-coleta  qtd-aferid val-hodom-final
                               it-codigo   cod-refer  cod-usuario 
                               hra-entr    cod-uf     cod-inter-veic
                               val-frete   cod-rota   qti-comptmento) NO-LOCK
       WHERE carg-rural.cod-estabel >= tt-param.cod-estabel-ini
         AND carg-rural.cod-estabel <= tt-param.cod-estabel-fim
         AND carg-rural.num-carg    >= tt-param.num-carg-ini
         AND carg-rural.num-carg    <= tt-param.num-carg-fim
         AND carg-rural.cod-carga   >= tt-param.cod-carga-ini
         AND carg-rural.cod-carga   <= tt-param.cod-carga-fim
         AND carg-rural.cod-placa   >= tt-param.cod-placa-ini
         AND carg-rural.cod-placa   <= tt-param.cod-placa-fim
         AND carg-rural.cod-rota    >= tt-param.cod-rota-ini
         AND carg-rural.cod-rota    <= tt-param.cod-rota-fim
         AND carg-rural.cod-transp  >= tt-param.cod-transp-ini
         AND carg-rural.cod-transp  <= tt-param.cod-transp-fim
         AND carg-rural.dat-trans   >= tt-param.dat-trans-ini
         AND carg-rural.dat-trans   <= tt-param.dat-trans-fim
         AND carg-rural.dat-entr    >= tt-param.dat-entr-ini
         AND carg-rural.dat-entr    <= tt-param.dat-entr-fim
         AND ((tt-param.rs-situacao = 1 AND carg-rural.cdn-sit <> 5) OR  /* Pendentes  */
              (tt-param.rs-situacao = 2 AND carg-rural.cdn-sit = 5)  OR  /* Encerradas */
               tt-param.rs-situacao = 0): /* Todas */
    
        {cdp/cd0031a.i carg-rural.cod-estabel} /* seguranca por estabelecimento */        
        
        IF NOT l-first-page THEN
            PAGE.
        
        ASSIGN l-first-page = NO.       
    
        IF VALID-HANDLE (h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT c-lbl-carga + " - ":U + STRING(carg-rural.num-carg)).
    
        ASSIGN c-estabelec = carg-rural.cod-estabel.
        FOR FIRST estabelec FIELDS(nome) NO-LOCK
            WHERE estabelec.cod-estabel = carg-rural.cod-estabel:
            ASSIGN c-estabelec = c-estabelec + " - " + estabelec.nome.
        END.
        
        ASSIGN c-rota = carg-rural.cod-rota.
        FOR FIRST rota-coleta FIELDS(des-rota) NO-LOCK
            WHERE rota-coleta.cod-rota = carg-rural.cod-rota:
            ASSIGN c-rota = c-rota + " - " + rota-coleta.des-rota.
        END.
    
        ASSIGN c-transportadora = STRING(carg-rural.cod-transp).
        FOR FIRST transporte FIELDS(nome) NO-LOCK
            WHERE transporte.cod-transp = carg-rural.cod-transp:
            ASSIGN c-transportadora = c-transportadora + " - " + transporte.nome.
        END.
        
        ASSIGN c-situacao   = {ininc/i01in00961.i 04 carg-rural.cdn-sit}
               d-km-rodados = carg-rural.val-hodom-final - carg-rural.val-hodom-inicial.
               d-diferenca  = carg-rural.qtd-aferid - carg-rural.qtd-coleta.
    
        ASSIGN c-item = carg-rural.it-codigo.
        FOR FIRST item FIELDS(desc-item) NO-LOCK
            WHERE item.it-codigo = carg-rural.it-codigo:
            ASSIGN c-item = c-item + " - " + item.desc-item.
        END.
    
        ASSIGN c-referencia = carg-rural.cod-refer.
        FOR FIRST referencia FIELDS(descricao) NO-LOCK
            WHERE referencia.cod-refer = carg-rural.cod-refer:
            ASSIGN c-referencia = c-referencia + " - " + referencia.descricao.
        END.
        
        ASSIGN c-usuario = carg-rural.cod-usuario.
        FOR LAST usuar_mestre FIELDS(nom_usuario) NO-LOCK
           WHERE usuar_mestre.cod_usuario = carg-rural.cod-usuario:
            ASSIGN c-usuario = c-usuario + " - " + usuar_mestre.nom_usuario.
        END.
        
        DISP carg-rural.num-carg   
             carg-rural.cod-carga  
             carg-rural.dat-entr   
             carg-rural.dat-trans 
             c-estabelec
             c-rota
             carg-rural.hra-entr   
             c-situacao
             c-usuario 
             c-transportadora
             carg-rural.cod-placa
             carg-rural.cod-inter-veic
             carg-rural.cod-uf
             carg-rural.qti-comptmento
             carg-rural.val-hodom-inicial
             carg-rural.val-hodom-final
             d-km-rodados
             c-item
             c-referencia
             carg-rural.qtd-coleta
             carg-rural.qtd-aferid
             d-diferenca
             carg-rural.val-densidade
             carg-rural.val-frete
             WITH FRAME f-carga.
        DOWN WITH FRAME f-carga.

        ASSIGN i-idi-tip-aferic = 1.
        FOR FIRST item-estab-rural FIELDS(idi-tip-aferic)
            WHERE item-estab-rural.cod-estabel = carg-rural.cod-estabel
              AND item-estab-rural.it-codigo   = carg-rural.it-codigo:
            ASSIGN i-idi-tip-aferic = item-estab-rural.idi-tip-aferic.
        END.

        /** PRODUTORES DA CARGA **/
        IF tt-param.l-produtores THEN DO:
            
            ASSIGN i-cont-prod   = 0
                   de-total-prod = 0
                   de-total-afer = 0.
            EMPTY TEMP-TABLE tt-produt-carg-aux NO-ERROR.
    
            FOR EACH produt-carg FIELDS(cdn-produt-rural cdn-produt-respons   cod-pto-coleta 
                                        val-temperat     cdn-repos            cdn-compart 
                                        qtd-coleta       qtd-medid-regua      dat-coleta  
                                        hra-coleta       cod-propried         cod-amostra 
                                        cod-lacre        cdn-motiv-nao-coleta num-carg
                                        qtd-aferid) NO-LOCK
                     WHERE produt-carg.num-carg = carg-rural.num-carg
                  BREAK BY produt-carg.cdn-produt-rural:

                    ASSIGN de-total-prod = de-total-prod + produt-carg.qtd-coleta
                           de-total-afer = de-total-afer + produt-carg.qtd-aferid.

                    ASSIGN c-nome-emit = "".
                    FOR FIRST emitente FIELDS(nome-emit) NO-LOCK
                        WHERE emitente.cod-emitente = produt-carg.cdn-produt-rural:
                        ASSIGN c-nome-emit = emitente.nome-emit.
                    END.

                    ASSIGN c-rota-padrao = "".
                    FOR FIRST pto-rota-coleta FIELDS(cod-rota) NO-LOCK
                        WHERE pto-rota-coleta.cod-pto-coleta = produt-carg.cod-pto-coleta:
                        ASSIGN c-rota-padrao = pto-rota-coleta.cod-rota.
                    END.

                    ASSIGN c-grupo-prod = "".
                    FOR FIRST produt-rural FIELDS(cdn-grp-produt) NO-LOCK
                        WHERE produt-rural.cdn-produt-rural = produt-carg.cdn-produt-rural:
                        FOR FIRST grp-produt FIELDS(des-grp-produt) NO-LOCK
                            WHERE grp-produt.cdn-grp-produt = produt-rural.cdn-grp-produt:
                            ASSIGN c-grupo-prod = grp-produt.des-grp-produt.
                        END.
                    END.
                    
                    ASSIGN c-respons = fn-logical(produt-carg.cdn-produt-respons = produt-carg.cdn-produt-rural) 
                           d-total   = d-total + produt-carg.qtd-coleta
                           c-repos   = string(produt-carg.cdn-repos).

                IF LAST-OF(produt-carg.cdn-produt-rural) THEN
                    ASSIGN i-cont-prod = i-cont-prod + 1.

                CREATE tt-produt-carg-aux.
                ASSIGN tt-produt-carg-aux.cdn-produt-rural = produt-carg.cdn-produt-rural
                       tt-produt-carg-aux.c-respons        = c-respons
                       tt-produt-carg-aux.c-nome-emit      = c-nome-emit      
                       tt-produt-carg-aux.qtd-coleta       = produt-carg.qtd-coleta
                       tt-produt-carg-aux.cdn-compart      = produt-carg.cdn-compart
                       tt-produt-carg-aux.c-repos          = c-repos
                       tt-produt-carg-aux.val-temperat     = produt-carg.val-temperat
                       tt-produt-carg-aux.c-rota-padrao    = c-rota-padrao
                       tt-produt-carg-aux.cod-pto-coleta   = produt-carg.cod-pto-coleta
                       tt-produt-carg-aux.c-grupo-prod     = c-grupo-prod.

            END.

            FOR EACH tt-produt-carg-aux
                BREAK BY tt-produt-carg-aux.c-grupo-prod
                      BY tt-produt-carg-aux.cdn-produt-rural:

                    DISP tt-produt-carg-aux.cdn-produt-rural
                         tt-produt-carg-aux.c-respons
                         tt-produt-carg-aux.c-nome-emit       
                         tt-produt-carg-aux.qtd-coleta
                         tt-produt-carg-aux.cdn-compart
                         tt-produt-carg-aux.c-repos
                         tt-produt-carg-aux.val-temperat
                         tt-produt-carg-aux.c-rota-padrao
                         tt-produt-carg-aux.cod-pto-coleta
                         tt-produt-carg-aux.c-grupo-prod
                         WITH FRAME f-produt.
                    DOWN WITH FRAME f-produt.

            END.

            ASSIGN de-atesto = de-total-afer - de-total-prod.

            IF i-cont-prod > 0 THEN DO:

                DISP c-traco-total-prod
                     c-lbl-cont-prod
                     i-cont-prod      
                     c-lbl-total-prod
                     de-total-prod   
                     c-lbl-total-afer
                     de-total-afer   
                     c-lbl-total-atesto
                     de-atesto        
                     WITH FRAME f-total-prod.
                 DOWN WITH FRAME f-total-prod.

            END.
            
        END.

        /* PESAGEM */
        IF tt-param.l-pesagem AND i-idi-tip-aferic = 1 THEN DO:        
            
            PUT SKIP(1).

            DISP c-tit-pesagem
                 c-lbl-seq    
                 c-lbl-pesagem
                 c-lbl-peso   
                 c-lbl-qtde   
                 c-lbl-situcao
                 c-traco-pesagem-2
                 WITH FRAME f-tit-pesagem.
            DOWN WITH FRAME f-tit-pesagem.
             
            FOR EACH pesagem FIELDS(num-carg  cdn-pesagem val-peso-balan 
                                    val-quant val-peso-aferid) NO-LOCK
               WHERE pesagem.num-carg = carg-rural.num-carg:
               
                ASSIGN c-situacao-pesagem = "".
                IF VALID-HANDLE(h-boin00982) THEN DO:
                    RUN buscaSituacaoPesagem IN h-boin00982(INPUT pesagem.num-carg, 
                                                            INPUT pesagem.cdn-pesagem, 
                                                            OUTPUT i-idi-aprova).
                    IF i-idi-aprova > 0 THEN
                        ASSIGN c-situacao-pesagem = {ininc/i01in00982.i 04 i-idi-aprova}.
                     
                     
                    DISP pesagem.cdn-pesagem
                         pesagem.val-peso-balan
                         pesagem.val-peso-aferid
                         pesagem.val-quant
                         c-situacao-pesagem
                         WITH FRAME f-pesagem.
                    DOWN WITH FRAME f-pesagem.
                END.
            END. 
        END. 
               
        /** LIBERACAO DE CARGA **/
        IF tt-param.l-liber-carg THEN DO:

            PUT SKIP(1).
            
            DISP c-tit-liber
                 c-lbl-liber
                 c-lbl-analise
                 c-lbl-compart
                 c-lbl-lote
                 c-lbl-dt-valid-lote
                 c-lbl-dep
                 c-lbl-roteiro
                 c-lbl-qtde
                 c-lbl-peso
                 c-lbl-rejei
                 c-lbl-obs
                 c-traco-liber-2
                 WITH FRAME f-tit-liber-carg.
            DOWN WITH FRAME f-tit-liber-carg.
            
            FOR EACH liber-carg FIELDS( idi-aprova   num-carg     cdn-compart                                            
                                        dt-vali-lote cod-depos    nr-ficha
                                        val-quant    val-peso-liq codigo-rejei 
                                        cod-obs      lote         idi-autoriz-descarga ) NO-LOCK
               WHERE liber-carg.num-carg = carg-rural.num-carg:
               
                ASSIGN c-liberacao  = "".
                IF liber-carg.idi-autoriz-descarga > 0 THEN
                    ASSIGN c-liberacao = {ininc/i02in00982.i 04 liber-carg.idi-autoriz-descarga}.
                    
                ASSIGN c-analise = {ininc/i01in00982.i 04 liber-carg.idi-aprova}.
                       
                DISP c-liberacao 
                     c-analise
                     liber-carg.cdn-compart 
                     liber-carg.lote        
                     liber-carg.dt-vali-lote
                     liber-carg.cod-depos   
                     liber-carg.nr-ficha    
                     liber-carg.val-quant   
                     liber-carg.val-peso-liq
                     liber-carg.codigo-rejei
                     liber-carg.cod-obs
                     WITH FRAME f-liber-carg.
                DOWN WITH FRAME f-liber-carg.
            END.
        END.
                
        /** NAO CONFORMIDADES CARGA **/
        IF tt-param.l-nc THEN DO:

            PUT SKIP(1).

            DISP c-tit-nc
                 c-lbl-nc
                 c-lbl-tipo
                 c-lbl-pto-coleta
                 c-lbl-compart
                 c-lbl-data
                 c-lbl-qtde
                 c-lbl-situcao
                 c-traco-nc-2
            WITH FRAME f-tit-nc.
            DOWN WITH FRAME f-tit-nc.
            
            FOR EACH naocfedade-carg FIELDS(idi-tip-naocfedade cdn-naocfedade cdn-sit
                                            cod-pto-coleta     cdn-compart    dat-trans 
                                            val-quant) NO-LOCK
               WHERE naocfedade-carg.num-carg = carg-rural.num-carg:
               
               ASSIGN c-tipo        = {ininc/i01in01009.i 04 naocfedade-carg.idi-tip-naocfedade}
                      c-situacao-nc = {ininc/i02in01009.i 04 naocfedade-carg.cdn-sit}.
            
                DISP naocfedade-carg.cdn-naocfedade
                     c-tipo
                     naocfedade-carg.cod-pto-coleta
                     naocfedade-carg.cdn-compart
                     naocfedade-carg.dat-trans
                     naocfedade-carg.val-quant
                     c-situacao-nc
                     WITH FRAME f-nc.
                DOWN WITH FRAME f-nc.
            END.
        END.
    END.
    
    IF tt-param.l-imp-param THEN DO:
        PAGE.
        
        ASSIGN c-pesagem    = fn-logical(tt-param.l-pesagem)
               c-liber-carg = fn-logical(tt-param.l-liber-carg)
               c-produtores = fn-logical(tt-param.l-produtores)
               c-nc         = fn-logical(tt-param.l-nc)
               c-sit-param  = fn-situacao-param(tt-param.rs-situacao)
               c-imp-param  = fn-logical(tt-param.l-imp-param).
        
        DISP tt-param.cod-estabel-ini
             tt-param.cod-estabel-fim
             tt-param.num-carg-ini   
             tt-param.num-carg-fim   
             tt-param.cod-carga-ini  
             tt-param.cod-carga-fim  
             tt-param.cod-placa-fim  
             tt-param.cod-placa-ini  
             tt-param.cod-rota-ini   
             tt-param.cod-rota-fim   
             tt-param.cod-transp-ini 
             tt-param.cod-transp-fim 
             tt-param.dat-trans-ini  
             tt-param.dat-trans-fim  
             tt-param.dat-entr-ini   
             tt-param.dat-entr-fim
             c-pesagem   
             c-liber-carg
             c-produtores
             c-nc        
             c-sit-param
             tt-param.destino
             tt-param.arquivo 
             tt-param.usuario 
             WITH FRAME f-param.
    END.    
END.

{include/pi-edit.i}

IF VALID-HANDLE(h-boin00982) THEN DO:
    DELETE PROCEDURE h-boin00982.
    ASSIGN h-boin00982 = ?.
END.    

RUN pi-finalizar in h-acomp.

{include/i-rpclo.i} /* Include padrao de relatorio */

RETURN "OK".

FUNCTION fn-logical RETURNS CHARACTER
  ( l-value as LOG ) :    
    RETURN IF l-value THEN c-sim ELSE c-nao.
END FUNCTION.

FUNCTION fn-situacao-param RETURNS CHARACTER
  ( i-cdn-sit as INT ) :
   CASE i-cdn-sit:
     WHEN 0 THEN DO:
         {utp/ut-liter.i Todos * }
     END.
     WHEN 1 THEN DO:
         {utp/ut-liter.i Pendente * }
     END.
     WHEN 2 THEN DO:
         {utp/ut-liter.i Encerrada * }
     END.
   END CASE.
   RETURN RETURN-VALUE.   
END FUNCTION.









