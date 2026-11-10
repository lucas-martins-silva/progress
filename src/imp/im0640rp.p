/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0640RP 2.00.00.018 } /*** 010018 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0640rp MIM}
&ENDIF

{imp/imapi009.i}     /* temp-tables utilizadas nos retornos da api */
{imp/imapi009.i3}    /* temp-tables utilizadas nos retornos da api */
{imp/im0640.i}       /* tt-param    */
{method/dbotterr.i}  /* temp-table RowErrors */                      
{include/tt-edit.i} /* para impress’o da mensagem de erro */
{include/pi-edit.i} /* para impress’o da mensagem de erro */

{cdp/cd4300.i3}     /* tratamento atributo livre */
{ccp/cc9019.i50}    /* definicoes busca valores cotacao-item.char-1 */
{ocp/oc0201.i50}    /* definicoes busca valores cotacao-item.char-2 */

{include/i-rpvar.i}


/* Parametros do relatorio */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

DEFINE VARIABLE h-acomp                  AS HANDLE               NO-UNDO.
DEFINE VARIABLE h-imapi009               AS HANDLE               NO-UNDO.
DEFINE VARIABLE h-boin356ab              AS HANDLE               NO-UNDO.
DEFINE VARIABLE h-bodi425                AS HANDLE               NO-UNDO.
DEFINE VARIABLE r-processo               AS ROWID                NO-UNDO.
DEFINE VARIABLE r-embarque               AS ROWID                NO-UNDO.
DEFINE VARIABLE dt-embarque-aux          AS DATE                 NO-UNDO.
DEFINE VARIABLE de-nr-dias               LIKE pto-itiner.nr-dias NO-UNDO.
DEFINE VARIABLE c-acompanha              AS CHARACTER FORMAT "x(15)":U  NO-UNDO.
DEFINE VARIABLE c-erro                   AS CHARACTER FORMAT "x(70)":U  NO-UNDO.
DEFINE VARIABLE d-qtd-embal              AS DEC NO-UNDO.
DEFINE VARIABLE d-sim-nao                AS CHARACTER  FORMAT "x(7)" NO-UNDO.
DEFINE BUFFER bf-historico-embarque FOR historico-embarque.


CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

/************************* Defini‡Æo de Frames ******************************/
IF tt-param.classifica = 1 THEN DO:
&IF "{&mguni_version}" >= "2.071" &THEN
    FORM tt-documentos-impressos.cod-estabel format "x(05)"      COLUMN-LABEL "Est"
&ELSE
    FORM tt-documentos-impressos.cod-estabel FORMAT "x(03)"      COLUMN-LABEL "Est"
&ENDIF
         tt-documentos-impressos.nome-abrev  FORMAT "x(12)"      COLUMN-LABEL "Fornecedor"
         tt-documentos-impressos.nr-proc-imp FORMAT "x(12)"      COLUMN-LABEL "Processo"
         tt-documentos-impressos.num-pedido  FORMAT ">>>>>,>>9"  COLUMN-LABEL "Pedido Comp"         
         tt-documentos-impressos.dt-embarque FORMAT "99/99/9999" COLUMN-LABEL "Dt Embarque"         
         tt-documentos-impressos.destino     FORMAT "x(77)"      COLUMN-LABEL "Destino"
    WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-doc-impressos-proc.

&IF "{&mguni_version}" >= "2.071" &THEN
    FORM tt-documentos-erros.cod-estabel     format "x(05)"      COLUMN-LABEL "Est"
&ELSE
    FORM tt-documentos-erros.cod-estabel     FORMAT "x(03)"      COLUMN-LABEL "Est"
&ENDIF
         tt-documentos-erros.nome-abrev      FORMAT "x(12)"      COLUMN-LABEL "Fornecedor"
         tt-documentos-erros.nr-proc-imp     FORMAT "x(12)"      COLUMN-LABEL "Processo "
         tt-documentos-erros.num-pedido      FORMAT ">>>>>,>>9"  COLUMN-LABEL "Pedido Comp"
         tt-documentos-erros.dt-embarque     FORMAT "99/99/9999" COLUMN-LABEL "Dt Embarque"         
         tt-documentos-erros.cod-erro        FORMAT ">>>>9"      COLUMN-LABEL "Nr Msg"
         c-erro                              FORMAT "x(70)"      COLUMN-LABEL "Mensagem"
    WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-doc-erros-proc.    
END.
ELSE DO:
&IF "{&mguni_version}" >= "2.071" &THEN
    FORM tt-documentos-impressos.cod-estabel format "x(05)"      COLUMN-LABEL "Est"
&ELSE
    FORM tt-documentos-impressos.cod-estabel FORMAT "x(03)"      COLUMN-LABEL "Est"
&ENDIF
         tt-documentos-impressos.nome-abrev  FORMAT "x(12)"      COLUMN-LABEL "Fornecedor"
         tt-documentos-impressos.embarque    FORMAT "x(16)"      COLUMN-LABEL "Embarque"
         tt-documentos-impressos.destino     FORMAT "x(77)"      COLUMN-LABEL "Destino"
    WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-doc-impressos-emb.

&IF "{&mguni_version}" >= "2.071" &THEN
    FORM tt-documentos-erros.cod-estabel     format "x(05)"      COLUMN-LABEL "Est"
&ELSE
    FORM tt-documentos-erros.cod-estabel     FORMAT "x(03)"      COLUMN-LABEL "Est"
&ENDIF
         tt-documentos-erros.nome-abrev      FORMAT "x(12)"      COLUMN-LABEL "Fornecedor"
         tt-documentos-erros.embarque        FORMAT "x(16)"      COLUMN-LABEL "Embarque"
         tt-documentos-erros.cod-erro        FORMAT ">>>>9"      COLUMN-LABEL "Nr Msg"
         c-erro                              FORMAT "x(70)"      COLUMN-LABEL "Mensagem"
    WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-doc-erros-emb.    
END.



/*Include com a defini‡Æo da frame de cabe‡alho e rodap‚ */
run utp/ut-trfrrp.p (input frame f-doc-erros-emb:handle).
run utp/ut-trfrrp.p (input frame f-doc-impressos-emb:handle).
run utp/ut-trfrrp.p (input frame f-doc-erros-proc:handle).
run utp/ut-trfrrp.p (input frame f-doc-impressos-proc:handle).
{include/i-rpcab.i}

/*Include padrÆo para output de relat¢rios */
{include/i-rpout.i}


/*find first param-compra no-lock no-error.*/
{utp/ut-liter.i "Sim/NÆo" }.
ASSIGN d-sim-nao = TRIM(RETURN-VALUE).

IF NOT VALID-HANDLE (h-imapi009) THEN
    RUN imp/imapi009.p PERSISTENT SET h-imapi009.

{utp/ut-liter.i Instru‡Æo_Embarque * r}.
ASSIGN c-acompanha = RETURN-VALUE.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp(INPUT c-acompanha).


{utp/ut-liter.i Instru‡Æo_Embarque * r}
ASSIGN c-titulo-relat = trim(return-value).
{utp/ut-liter.i Importa‡Æo * r}
ASSIGN c-sistema = trim(return-value).

FIND FIRST param-global NO-LOCK NO-ERROR.

ASSIGN c-empresa  = (IF AVAIL param-global THEN param-global.grupo ELSE "")
       c-programa = "IM/0660"
       c-versao   = "1.00"
       c-revisao  = "001".


VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

RUN piPrincipal.

/* Procedure interna utilizada para emitir os documentos criados ou erros enontrados */
RUN piImprimirDoctosGerados IN THIS-PROCEDURE.

/* Imprimir p gina de parƒmetros */
IF l-imprime-param THEN
    RUN piImprimirParametros IN THIS-PROCEDURE.

IF VALID-HANDLE (h-imapi009) THEN
    DELETE PROCEDURE h-imapi009.

/* Fechamento do output do relat¢rio */
{include/i-rpclo.i}
RUN pi-finalizar IN h-acomp.
RETURN "OK":U.


PROCEDURE piPrincipal:


    IF  tt-param.classifica = 1 THEN DO:

        FOR EACH processo-imp
            WHERE processo-imp.cod-estabel     >= tt-param.c-cod-estabel-ini
            AND   processo-imp.cod-estabel     <= tt-param.c-cod-estabel-fim
            AND   processo-imp.nr-proc-imp     >= tt-param.c-nr-proc-imp-ini
            AND   processo-imp.nr-proc-imp     <= tt-param.c-nr-proc-imp-fim
            AND   processo-imp.cod-exportador  >= tt-param.i-fornecedor-ini
            AND   processo-imp.cod-exportador  <= tt-param.i-fornecedor-fim NO-LOCK:

            FOR FIRST param-imp
                WHERE param-imp.cod-estabel = processo-imp.cod-estabel NO-LOCK:
            END.

            /* Limpa as tabelas temporarias */
            RUN emptyTempTables.

            ASSIGN r-processo = ROWID(processo-imp).
            RUN setConstraintProcessoImp IN h-imapi009(INPUT ROWID(processo-imp)).
            RUN setDataEmbarqueInicial   IN h-imapi009(INPUT tt-param.dt-prevista-ini).
            RUN setDataEmbarqueFinal     IN h-imapi009(INPUT tt-param.dt-prevista-fim).

            IF  tt-param.l-traducao THEN
                RUN setTraducao IN h-imapi009(INPUT 3).

            RUN getInstEmbarque IN THIS-PROCEDURE (OUTPUT TABLE tt-estabelec-aux,
                                                   OUTPUT TABLE tt-exportador-aux,
                                                   OUTPUT TABLE tt-consignatario-aux,
                                                   OUTPUT TABLE tt-agente-carga-aux,
                                                   OUTPUT TABLE tt-transporte-aux,
                                                   OUTPUT TABLE tt-embarque,
                                                   OUTPUT TABLE tt-processo-aux,
                                                   OUTPUT TABLE tt-pedido,
                                                   OUTPUT TABLE tt-it-inst-emb,
                                                   OUTPUT TABLE tt-docto,
                                                   OUTPUT TABLE tt-inst-emb).


            IF NOT CAN-FIND(FIRST tt-inst-emb) THEN
                NEXT.

            RUN imp/im0640a.p (INPUT TABLE tt-estabelec-aux,
                               INPUT TABLE tt-exportador-aux,
                               INPUT TABLE tt-consignatario-aux,
                               INPUT TABLE tt-agente-carga-aux,
                               INPUT TABLE tt-transporte-aux,
                               INPUT TABLE tt-embarque,
                               INPUT TABLE tt-processo-aux,
                               INPUT TABLE tt-pedido,
                               INPUT TABLE tt-it-inst-emb,
                               INPUT TABLE tt-docto,
                               INPUT TABLE tt-inst-emb,
                               INPUT TABLE tt-param,
                               INPUT h-acomp,
                               INPUT-OUTPUT TABLE tt-documentos-impressos,
                               OUTPUT TABLE tt-documentos-erros append).
        END.
    END.
    ELSE DO:
        FOR EACH embarque-imp
            WHERE embarque-imp.cod-estabel  >= tt-param.c-cod-estabel-ini
            AND   embarque-imp.cod-estabel  <= tt-param.c-cod-estabel-fim
            AND   embarque-imp.embarque     >= tt-param.c-embarque-ini
            AND   embarque-imp.embarque     <= tt-param.c-embarque-fim NO-LOCK:

            /*** Data de embarque esta dentro da faixa ***/
            FIND FIRST historico-embarque
                WHERE  historico-embarque.cod-estabel = embarque-imp.cod-estabel
                AND    historico-embarque.embarque    = embarque-imp.embarque NO-LOCK NO-ERROR.
            if  AVAIL historico-embarque THEN DO:

                FIND FIRST itinerario
                    WHERE  itinerario.cod-itiner   = historico-embarque.cod-itiner NO-LOCK NO-ERROR.

                find first historico-embarque
                    where historico-embarque.cod-estabel   = embarque-imp.cod-estabel
                    and   historico-embarque.embarque      = embarque-imp.embarque
                    and   historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-embarq NO-LOCK NO-ERROR.
                if  avail historico-embarque THEN DO:

                    IF  historico-embarque.dt-efetiva <> ? THEN DO:
                        IF  historico-embarque.dt-efetiva < tt-param.dt-prevista-ini
                        OR  historico-embarque.dt-efetiva > tt-param.dt-prevista-fim THEN
                            NEXT.
                    END.
                    ELSE DO:
                        IF  historico-embarque.dt-ult-previsao < tt-param.dt-prevista-ini
                        OR  historico-embarque.dt-ult-previsao > tt-param.dt-prevista-fim THEN
                            NEXT.
                    END.
                END.
            END.

            /*** Verificar se o fornecedor esta dentro da faixa ***/
            FIND FIRST ordens-embarque
                WHERE  ordens-embarque.cod-estabel = embarque-imp.cod-estabel
                AND    ordens-embarque.embarque    = embarque-imp.embarque NO-LOCK NO-ERROR.
            IF AVAIL ordens-embarque THEN
                IF NOT CAN-FIND (FIRST processo-imp
                                 WHERE processo-imp.cod-estabel     = ordens-embarque.cod-estabel
                                 AND   processo-imp.nr-proc-imp     = ordens-embarque.nr-proc-imp
                                 AND   processo-imp.cod-exportador >= i-fornecedor-ini
                                 AND   processo-imp.cod-exportador <= i-fornecedor-fim) THEN NEXT.

            /*** Verificar se embarque possui ordem de compra ***/
            IF NOT CAN-FIND(FIRST ordens-embarque
                            WHERE ordens-embarque.cod-estabel  = embarque-imp.cod-estabel
                            AND   ordens-embarque.embarque     = embarque-imp.embarque 
                            AND   ordens-embarque.nr-proc-imp >= tt-param.c-nr-proc-imp-ini
                            AND   ordens-embarque.nr-proc-imp <= tt-param.c-nr-proc-imp-fim) THEN NEXT.

            /* Limpa as tabelas temporarias */
            RUN emptyTempTables.

            ASSIGN r-embarque = ROWID(embarque-imp).
            RUN setConstraintEmbarqueImp IN h-imapi009(INPUT ROWID(embarque-imp)).
            IF tt-param.l-traducao THEN
                RUN setTraducao IN h-imapi009(INPUT 3).

            RUN getInstEmbarque IN THIS-PROCEDURE(OUTPUT TABLE tt-estabelec-aux,
                                                  OUTPUT TABLE tt-exportador-aux,
                                                  OUTPUT TABLE tt-consignatario-aux,
                                                  OUTPUT TABLE tt-agente-carga-aux,
                                                  OUTPUT TABLE tt-transporte-aux,
                                                  OUTPUT TABLE tt-embarque,
                                                  OUTPUT TABLE tt-processo-aux,
                                                  OUTPUT TABLE tt-pedido,
                                                  OUTPUT TABLE tt-it-inst-emb,
                                                  OUTPUT TABLE tt-docto,
                                                  OUTPUT TABLE tt-inst-emb).

            RUN imp/im0640a.p (INPUT TABLE tt-estabelec-aux,
                               INPUT TABLE tt-exportador-aux,
                               INPUT TABLE tt-consignatario-aux,
                               INPUT TABLE tt-agente-carga-aux,
                               INPUT TABLE tt-transporte-aux,
                               INPUT TABLE tt-embarque,
                               INPUT TABLE tt-processo-aux,
                               INPUT TABLE tt-pedido,
                               INPUT TABLE tt-it-inst-emb,
                               INPUT TABLE tt-docto,
                               INPUT TABLE tt-inst-emb,
                               INPUT TABLE tt-param,
                               INPUT h-acomp,
                               INPUT-OUTPUT TABLE tt-documentos-impressos,
                               OUTPUT TABLE tt-documentos-erros append).
        END.
    END.

END PROCEDURE.

PROCEDURE getInstEmbarque:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-estabelec-aux.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-exportador-aux.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-consignatario-aux.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-agente-carga-aux.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-transporte-aux.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-embarque.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-processo-aux.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-pedido.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-it-inst-emb.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-docto.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-inst-emb.

    RUN getImportador         IN h-imapi009(OUTPUT TABLE tt-estabelec).
    find first tt-estabelec no-error.
    if  avail tt-estabelec THEN DO:
        CREATE tt-estabelec-aux.
        BUFFER-COPY tt-estabelec TO tt-estabelec-aux.
        assign tt-estabelec-aux.nome-import          = tt-estabelec.nome                
               tt-estabelec-aux.endereco-import      = tt-estabelec.endereco            
               tt-estabelec-aux.bairro-import        = tt-estabelec.bairro              
               tt-estabelec-aux.cidade-import        = tt-estabelec.cidade              
               tt-estabelec-aux.pais-import          = tt-estabelec.pais                
               tt-estabelec-aux.cep-import           = tt-estabelec.cep                 
               tt-estabelec-aux.cgc-import           = tt-estabelec.cgc                 
               tt-estabelec-aux.estado-import        = tt-estabelec.estado              
               tt-estabelec-aux.ins-estadual-import  = tt-estabelec.ins-estadual        
               tt-estabelec-aux.ins-municipal-import = tt-estabelec.ins-municipal       
               tt-estabelec-aux.cod-suframa-import   = tt-estabelec.cod-suframa
               tt-estabelec-aux.cod-emit-import      = tt-estabelec.cod-emitente.
    END.

    run getEmitenteImportador in h-imapi009 (output table tt-emitente).
    find first tt-emitente no-error.
    if  avail tt-emitente then
        assign tt-estabelec-aux.nome-emit-import          = tt-emitente.nome-emit    
               tt-estabelec-aux.endereco-emit-import      = tt-emitente.endereco     
               tt-estabelec-aux.bairro-emit-import        = tt-emitente.bairro       
               tt-estabelec-aux.cidade-emit-import        = tt-emitente.cidade       
               tt-estabelec-aux.pais-emit-import          = tt-emitente.pais         
               tt-estabelec-aux.cep-emit-import           = tt-emitente.cep          
               tt-estabelec-aux.cgc-emit-import           = tt-emitente.cgc          
               tt-estabelec-aux.estado-emit-import        = tt-emitente.estado       
               tt-estabelec-aux.ins-estadual-emit-import  = tt-emitente.ins-estadual 
               tt-estabelec-aux.ins-municipal-emit-import = tt-emitente.ins-municipal
               tt-estabelec-aux.caixa-postal-emit-import  = tt-emitente.caixa-postal 
               tt-estabelec-aux.e-mail-emit-import        = tt-emitente.e-mail       
               tt-estabelec-aux.cod-aba-emit-import       = tt-emitente.cod-aba      
               tt-estabelec-aux.telefone-emit-import      = tt-emitente.telefone[1]  
               tt-estabelec-aux.telefone2-emit-import     = tt-emitente.telefone[2]  
               tt-estabelec-aux.ramal-emit-import         = tt-emitente.ramal[1]     
               tt-estabelec-aux.ramal2-emit-import        = tt-emitente.ramal[2]     
               tt-estabelec-aux.home-page-emit-import     = tt-emitente.home-page    
               tt-estabelec-aux.telefax-emit-import       = tt-emitente.telefax      
               tt-estabelec-aux.ramal-fax-emit-import     = tt-emitente.ramal-fax    
               tt-estabelec-aux.telef-fac-emit-import     = tt-emitente.telef-fac    
               tt-estabelec-aux.ramal-fac-emit-import     = tt-emitente.ramal-fac    
               tt-estabelec-aux.telef-modem-emit-import   = tt-emitente.telef-modem  
               tt-estabelec-aux.ramal-modem-emit-import   = tt-emitente.ramal-modem.  

    RUN getExportador         IN h-imapi009(OUTPUT TABLE tt-exportador).
    find first tt-exportador no-error.
    if  avail  tt-exportador THEN DO:
       CREATE tt-exportador-aux.
       BUFFER-COPY tt-exportador TO tt-exportador-aux.
       assign tt-exportador-aux.cod-exportador            = tt-exportador.cod-emitente
              tt-exportador-aux.nome-emit-export          = tt-exportador.nome-emit    
              tt-exportador-aux.endereco-emit-export      = tt-exportador.endereco     
              tt-exportador-aux.bairro-emit-export        = tt-exportador.bairro       
              tt-exportador-aux.cidade-emit-export        = tt-exportador.cidade       
              tt-exportador-aux.pais-emit-export          = tt-exportador.pais         
              tt-exportador-aux.cep-emit-export           = tt-exportador.cep          
              tt-exportador-aux.cgc-emit-export           = tt-exportador.cgc          
              tt-exportador-aux.estado-emit-export        = tt-exportador.estado       
              tt-exportador-aux.ins-estadual-emit-export  = tt-exportador.ins-estadual 
              tt-exportador-aux.ins-municipal-emit-export = tt-exportador.ins-municipal
              tt-exportador-aux.caixa-postal-emit-export  = tt-exportador.caixa-postal 
              tt-exportador-aux.e-mail-emit-export        = tt-exportador.e-mail       
              tt-exportador-aux.cod-aba-emit-export       = tt-exportador.cod-aba      
              tt-exportador-aux.telefone-emit-export      = tt-exportador.telefone[1]
              tt-exportador-aux.telefone2-emit-export     = tt-exportador.telefone[2]  
              tt-exportador-aux.ramal-emit-export         = tt-exportador.ramal[1]     
              tt-exportador-aux.ramal2-emit-export        = tt-exportador.ramal[2]     
              tt-exportador-aux.home-page-emit-export     = tt-exportador.home-page    
              tt-exportador-aux.telefax-emit-export       = tt-exportador.telefax      
              tt-exportador-aux.ramal-fax-emit-export     = tt-exportador.ramal-fax    
              tt-exportador-aux.telef-fac-emit-export     = tt-exportador.telef-fac    
              tt-exportador-aux.ramal-fac-emit-export     = tt-exportador.ramal-fac    
              tt-exportador-aux.telef-modem-emit-export   = tt-exportador.telef-modem  
              tt-exportador-aux.ramal-modem-emit-export   = tt-exportador.ramal-modem.  
    END.

    RUN getConsignatario      IN h-imapi009(OUTPUT TABLE tt-consignatario).
    find first tt-consignatario no-error.
    if  avail  tt-consignatario THEN DO:
        CREATE tt-consignatario-aux.
        BUFFER-COPY tt-consignatario TO tt-consignatario-aux.

        assign tt-consignatario-aux.cod-consignatario    = tt-consignatario.cod-emitente
               tt-consignatario-aux.nome-consig          = tt-consignatario.nome-emit    
               tt-consignatario-aux.endereco-consig      = tt-consignatario.endereco   
               tt-consignatario-aux.bairro-consig        = tt-consignatario.bairro       
               tt-consignatario-aux.cidade-consig        = tt-consignatario.cidade       
               tt-consignatario-aux.pais-consig          = tt-consignatario.pais         
               tt-consignatario-aux.cep-consig           = tt-consignatario.cep          
               tt-consignatario-aux.cgc-consig           = tt-consignatario.cgc          
               tt-consignatario-aux.estado-consig        = tt-consignatario.estado       
               tt-consignatario-aux.Ins-estadual-consig  = tt-consignatario.ins-estadual 
               tt-consignatario-aux.Ins-municipal-consig = tt-consignatario.ins-municipal
               tt-consignatario-aux.caixa-postal-consig  = tt-consignatario.caixa-postal 
               tt-consignatario-aux.e-mail-consig        = tt-consignatario.e-mail       
               tt-consignatario-aux.cod-aba-consig       = tt-consignatario.cod-aba      
               tt-consignatario-aux.telefone-consig      = tt-consignatario.telefone[1]
               tt-consignatario-aux.telefone2-consig     = tt-consignatario.telefone[2]  
               tt-consignatario-aux.ramal-consig         = tt-consignatario.ramal[1]     
               tt-consignatario-aux.ramal2-consig        = tt-consignatario.ramal[2]     
               tt-consignatario-aux.home-page-consig     = tt-consignatario.home-page    
               tt-consignatario-aux.telefax-consig       = tt-consignatario.telefax      
               tt-consignatario-aux.ramal-fax-consig     = tt-consignatario.ramal-fax    
               tt-consignatario-aux.telef-fac-consig     = tt-consignatario.telef-fac    
               tt-consignatario-aux.ramal-fac-consig     = tt-consignatario.ramal-fac    
               tt-consignatario-aux.telef-modem-consig   = tt-consignatario.telef-modem  
               tt-consignatario-aux.ramal-modem-consig   = tt-consignatario.ramal-modem.
    END.

    RUN getAgenteCargas       IN h-imapi009(OUTPUT TABLE tt-agente-carga).
    find first tt-agente-carga no-error.
    if  avail  tt-agente-carga THEN DO:
        CREATE tt-agente-carga-aux.
        BUFFER-COPY tt-agente-carga TO tt-agente-carga-aux.
        assign tt-agente-carga-aux.cod-agente           = tt-agente-carga.cod-emitente
               tt-agente-carga-aux.nome-agente          = tt-agente-carga.nome-emit    
               tt-agente-carga-aux.endereco-agente      = tt-agente-carga.endereco     
               tt-agente-carga-aux.bairro-agente        = tt-agente-carga.bairro       
               tt-agente-carga-aux.cidade-agente        = tt-agente-carga.cidade       
               tt-agente-carga-aux.pais-agente          = tt-agente-carga.pais         
               tt-agente-carga-aux.cep-agente           = tt-agente-carga.cep          
               tt-agente-carga-aux.cgc-agente           = tt-emitente.cgc          
               tt-agente-carga-aux.estado-agente        = tt-agente-carga.estado       
               tt-agente-carga-aux.ins-estadual-agente  = tt-agente-carga.ins-estadual 
               tt-agente-carga-aux.ins-municipal-agente = tt-agente-carga.ins-municipal
               tt-agente-carga-aux.caixa-postal-agente  = tt-agente-carga.caixa-postal 
               tt-agente-carga-aux.e-mail-agente        = tt-agente-carga.e-mail       
               tt-agente-carga-aux.cod-aba-agente       = tt-agente-carga.cod-aba      
               tt-agente-carga-aux.telefone-agente      = tt-agente-carga.telefone[1]
               tt-agente-carga-aux.telefone2-agente     = tt-agente-carga.telefone[2]  
               tt-agente-carga-aux.ramal-agente         = tt-agente-carga.ramal[1]     
               tt-agente-carga-aux.ramal2-agente        = tt-agente-carga.ramal[2]     
               tt-agente-carga-aux.home-page-agente     = tt-agente-carga.home-page    
               tt-agente-carga-aux.telefax-agente       = tt-agente-carga.telefax      
               tt-agente-carga-aux.ramal-fax-agente     = tt-agente-carga.ramal-fax    
               tt-agente-carga-aux.telef-fac-agente     = tt-agente-carga.telef-fac    
               tt-agente-carga-aux.ramal-fac-agente     = tt-agente-carga.ramal-fac    
               tt-agente-carga-aux.telef-modem-agente   = tt-agente-carga.telef-modem  
               tt-agente-carga-aux.ramal-modem-agente   = tt-agente-carga.ramal-modem.  
    END.

    RUN getTransportador      IN h-imapi009(OUTPUT TABLE tt-transporte).

    find first tt-transporte no-error.
    if  avail  tt-transporte then do:
        CREATE tt-transporte-aux.
        BUFFER-COPY tt-transporte TO tt-transporte-aux.
        assign tt-transporte-aux.cod-transportador    = tt-transporte.cod-emitente
               tt-transporte-aux.nome-transp          = tt-transporte.nome         
               tt-transporte-aux.nome-abrev-transp    = tt-transporte.nome-abrev   
               tt-transporte-aux.endereco-transp      = tt-transporte.endereco     
               tt-transporte-aux.bairro-transp        = tt-transporte.bairro       
               tt-transporte-aux.cidade-transp        = tt-transporte.cidade       
               tt-transporte-aux.pais-transp          = tt-transporte.pais         
               tt-transporte-aux.cep-transp           = tt-transporte.cep          
               tt-transporte-aux.cgc-transp           = tt-transporte.cgc          
               tt-transporte-aux.estado-transp        = tt-transporte.estado       
               tt-transporte-aux.ins-estadual-transp  = tt-transporte.ins-estadual 
               tt-transporte-aux.caixa-postal-transp  = tt-transporte.cx-postal    
               tt-transporte-aux.contato-transp       = tt-transporte.contato      
               tt-transporte-aux.telefone-transp      = tt-transporte.telefone
               tt-transporte-aux.ramal-transp         = tt-transporte.ramal        
               tt-transporte-aux.telefax-transp       = tt-transporte.telefax      
               tt-transporte-aux.telex-transp         = tt-transporte.telex        
               tt-transporte-aux.ins-municipal-transp = tt-transporte.ins-municipal
               tt-transporte-aux.zip-code-transp      = tt-transporte.zip-code     
               tt-transporte-aux.e-mail-transp        = tt-transporte.e-mail       
               tt-transporte-aux.telef-modem-transp   = tt-transporte.telef-modem  
               tt-transporte-aux.home-page-transp     = tt-transporte.home-page    
               tt-transporte-aux.ramal-modem-transp   = tt-transporte.ramal-modem  
               tt-transporte-aux.ramal-fax-transp     = tt-transporte.ramal-fax.    
           
        if  tt-transporte-aux.cod-transp = 0 then
            assign tt-transporte-aux.pais-transp = "".
    END.

    RUN getEmbarqueImportacao IN h-imapi009(OUTPUT TABLE tt-embarque).
    
    RUN getProcessoImportacao IN h-imapi009(OUTPUT TABLE tt-processo).
    FIND FIRST tt-processo NO-ERROR.
    IF AVAIL tt-processo THEN DO:
        CREATE tt-processo-aux.
        BUFFER-COPY tt-processo TO tt-processo-aux.
        ASSIGN tt-processo-aux.id-meio-transp           = tt-processo.via-transp   
               tt-processo-aux.desc-via-transp          = {adinc/i01ad268.i 04 tt-processo.via-transp}    
               tt-processo-aux.desc-situacao            = {cxinc/i01cx140.i 04 tt-processo.situacao}.

        RUN getBanco IN h-imapi009(OUTPUT TABLE tt-banco).
        FIND FIRST tt-banco NO-ERROR.
        IF AVAIL tt-banco THEN
            ASSIGN tt-processo-aux.desc-banco = tt-banco.nome-banco
                   tt-processo-aux.ag-banco   = tt-banco.ag-padrao.

        RUN getAgenciaBanco IN h-imapi009(OUTPUT TABLE tt-agencia).
        FIND FIRST tt-agencia NO-ERROR.
        IF AVAIL tt-agencia THEN
            ASSIGN  tt-processo-aux.desc-agencia = tt-agencia.nome.

        IF  AVAIL param-imp
        AND param-imp.hist-processo THEN DO:
            FIND FIRST itinerario 
                 WHERE itinerario.cod-itiner = tt-processo.cod-itiner NO-LOCK NO-ERROR.
            IF AVAIL itinerario THEN DO:
                ASSIGN tt-processo-aux.desc-itner = itinerario.descricao.
       
                FIND FIRST historico-proc-imp
                     WHERE historico-proc-imp.cod-estabel = tt-processo.cod-estabel
                       AND historico-proc-imp.nr-proc-imp = tt-processo.nr-proc-imp
                       AND historico-proc-imp.cod-itiner  = itinerario.cod-itiner NO-LOCK NO-ERROR.
                IF AVAIL historico-proc-imp THEN DO:
                    IF historico-proc-imp.cod-pto-contr = itinerario.pto-despacho THEN DO:
                       ASSIGN tt-processo-aux.data-efet-despacho       = historico-proc-imp.dt-efetiva
                              tt-processo-aux.data-ult-prev-despacho   = historico-proc-imp.dt-ult-previsao.
                
                       FOR FIRST pto-contr
                           WHERE pto-contr.cod-pto-contr = historico-proc-imp.cod-pto-contr NO-LOCK:
                           ASSIGN tt-processo-aux.desc-pto-despacho = pto-contr.descricao.
                       END.
                    END.

                    IF historico-proc-imp.cod-pto-contr = itinerario.pto-embarque THEN DO:
                       ASSIGN tt-processo-aux.data-efet-embarque       = historico-proc-imp.dt-efetiva
                              tt-processo-aux.data-ult-prev-embarque   = historico-proc-imp.dt-ult-previsao.
     
                       FOR FIRST pto-contr
                           WHERE pto-contr.cod-pto-contr = historico-proc-imp.cod-pto-contr NO-LOCK:
                           ASSIGN tt-processo-aux.desc-pto-embarque = pto-contr.descricao.
                       END.
                    END.

                    IF historico-proc-imp.cod-pto-contr = itinerario.pto-desembarque THEN DO:
                       ASSIGN tt-processo-aux.data-efet-nacionaliz       = historico-proc-imp.dt-efetiva
                              tt-processo-aux.data-ult-prev-nacionaliz   = historico-proc-imp.dt-ult-previsao.
              
                       FOR FIRST pto-contr
                           WHERE pto-contr.cod-pto-contr = historico-proc-imp.cod-pto-contr NO-LOCK:
                           ASSIGN tt-processo-aux.desc-pto-nacionaliz = pto-contr.descricao.
                       END.
                    END.

                    IF historico-proc-imp.cod-pto-contr = itinerario.pto-chegada THEN DO:
                       ASSIGN tt-processo-aux.data-efet-chegada       = historico-proc-imp.dt-efetiva
                              tt-processo-aux.data-ult-prev-chegada   = historico-proc-imp.dt-ult-previsao.
    
                       FOR FIRST pto-contr
                           WHERE pto-contr.cod-pto-contr = historico-proc-imp.cod-pto-contr NO-LOCK:
                           ASSIGN tt-processo-aux.desc-pto-chegada = pto-contr.descricao.
                       END.
                    END.
                END.
            END.
        END. 
    END.

    RUN getPedidoCompra       IN h-imapi009(OUTPUT TABLE tt-pedido).
    RUN getItensInsEmbarque   IN THIS-PROCEDURE(OUTPUT TABLE tt-it-inst-emb).

    FIND FIRST tt-exportador-aux NO-ERROR.

    FOR EACH tt-it-inst-emb:

        find first tt-processo-aux
            where tt-processo-aux.nr-proc-imp = tt-it-inst-emb.nr-proc-imp no-error.

        RUN getDoctosItem IN THIS-PROCEDURE(INPUT tt-it-inst-emb.it-codigo,
                                            INPUT tt-exportador-aux.cod-emitente,
                                            INPUT tt-it-inst-emb.cdn-pais-orig,
                                            INPUT-OUTPUT TABLE tt-docto).
    END.

    IF r-embarque <> ? THEN DO:    

        FIND FIRST tt-embarque NO-ERROR.

        CREATE  tt-inst-emb.
        ASSIGN  tt-inst-emb.embarque                 = tt-embarque.embarque
                tt-inst-emb.dt-atual                 = TODAY.

        FOR EACH tt-it-inst-emb:
            ASSIGN tt-inst-emb.peso-liquido-tot      = tt-inst-emb.peso-liquido-tot + tt-it-inst-emb.peso-liquido-tot
                   tt-inst-emb.peso-bruto-tot        = tt-inst-emb.peso-bruto-tot   + tt-it-inst-emb.peso-bruto-tot
                   tt-inst-emb.valor-total-merc      = tt-inst-emb.valor-total-merc + tt-it-inst-emb.vl-liq-tot.
        END.

        RUN pi-cria-tt-inst-emb.

    END.
    ELSE DO:
        IF r-processo <> ? THEN DO:
            FIND FIRST tt-processo-aux NO-ERROR.
            FOR EACH tt-it-inst-emb
                BREAK BY tt-it-inst-emb.dt-embarque:

                IF FIRST-OF(tt-it-inst-emb.dt-embarque) THEN DO:
                    CREATE  tt-inst-emb.
                    ASSIGN  tt-inst-emb.nr-proc-imp          = tt-processo-aux.nr-proc-imp
                            tt-inst-emb.num-pedido           = tt-processo-aux.num-pedido
                            tt-inst-emb.dt-atual             = TODAY.                  
                    RUN pi-cria-tt-inst-emb.

                    ASSIGN  tt-inst-emb.dt-embarque = tt-it-inst-emb.dt-embarque.
                END.       
                ASSIGN tt-inst-emb.peso-liquido-tot      = tt-inst-emb.peso-liquido-tot + tt-it-inst-emb.peso-liquido-tot
                       tt-inst-emb.peso-bruto-tot        = tt-inst-emb.peso-bruto-tot   + tt-it-inst-emb.peso-bruto-tot
                       tt-inst-emb.valor-total-merc      = tt-inst-emb.valor-total-merc + tt-it-inst-emb.vl-liq-tot.
            END.
        END.
    END.

    FOR EACH tt-pedido:
        IF tt-param.l-traducao THEN DO:
            FIND trad-cond-pagto NO-LOCK WHERE
                trad-cond-pagto.cod-cond-pag = tt-pedido.cod-cond-pag AND
                trad-cond-pagto.cod-idioma   = tt-exportador.cod-idioma NO-ERROR.
            IF AVAILABLE trad-cond-pagto THEN
                ASSIGN tt-pedido.desc-cond-pagto = trad-cond-pagto.tr-descricao.
        END.
    END.

END PROCEDURE.

PROCEDURE pi-cria-tt-inst-emb:

    RUN getPontosControleItiner IN h-imapi009(OUTPUT TABLE tt-emb-pto-contr).

    FOR EACH tt-emb-pto-contr:

        IF tt-emb-pto-contr.tp-pto-contr = 1 THEN 
            ASSIGN tt-inst-emb.pto-despacho           = tt-emb-pto-contr.pto-contr
                   tt-inst-emb.desc-pto-despacho      = tt-emb-pto-contr.desc-pto-contr
                   tt-inst-emb.data-prev-despacho     = tt-emb-pto-contr.data-prev-pto-contr
                   tt-inst-emb.data-efet-despacho     = tt-emb-pto-contr.data-efet-pto-contr
                   tt-inst-emb.data-ult-prev-despacho = tt-emb-pto-contr.data-ult-prev-pto-contr.
        ELSE DO:
            IF tt-emb-pto-contr.tp-pto-contr = 2 THEN 
                ASSIGN tt-inst-emb.pto-embarque           = tt-emb-pto-contr.pto-contr
                       tt-inst-emb.desc-pto-embarque      = tt-emb-pto-contr.desc-pto-contr
                       tt-inst-emb.data-prev-embarque     = tt-emb-pto-contr.data-prev-pto-contr
                       tt-inst-emb.data-efet-embarque     = tt-emb-pto-contr.data-efet-pto-contr
                       tt-inst-emb.data-ult-prev-embarque = tt-emb-pto-contr.data-ult-prev-pto-contr.
            ELSE DO:
                IF tt-emb-pto-contr.tp-pto-contr = 3 THEN 
                    ASSIGN tt-inst-emb.pto-nacionaliz           = tt-emb-pto-contr.pto-contr
                           tt-inst-emb.desc-pto-nacionaliz      = tt-emb-pto-contr.desc-pto-contr
                           tt-inst-emb.data-prev-nacionaliz     = tt-emb-pto-contr.data-prev-pto-contr
                           tt-inst-emb.data-efet-nacionaliz     = tt-emb-pto-contr.data-efet-pto-contr
                           tt-inst-emb.data-ult-prev-nacionaliz = tt-emb-pto-contr.data-ult-prev-pto-contr.
                ELSE DO:
                    IF tt-emb-pto-contr.tp-pto-contr = 4 THEN 
                        ASSIGN tt-inst-emb.pto-eadi           = tt-emb-pto-contr.pto-contr
                               tt-inst-emb.desc-pto-eadi      = tt-emb-pto-contr.desc-pto-contr
                               tt-inst-emb.data-prev-eadi     = tt-emb-pto-contr.data-prev-pto-contr
                               tt-inst-emb.data-efet-eadi     = tt-emb-pto-contr.data-efet-pto-contr
                               tt-inst-emb.data-ult-prev-eadi = tt-emb-pto-contr.data-ult-prev-pto-contr.
                    ELSE DO:
                        IF tt-emb-pto-contr.tp-pto-contr = 5 THEN 
                            ASSIGN tt-inst-emb.pto-chegada           = tt-emb-pto-contr.pto-contr
                                   tt-inst-emb.desc-pto-chegada      = tt-emb-pto-contr.desc-pto-contr
                                   tt-inst-emb.data-prev-chegada     = tt-emb-pto-contr.data-prev-pto-contr
                                   tt-inst-emb.data-efet-chegada     = tt-emb-pto-contr.data-efet-pto-contr
                                   tt-inst-emb.data-ult-prev-chegada = tt-emb-pto-contr.data-ult-prev-pto-contr.
                    END.                                                                                    
                END.                                                                                        
            END.
        END.
    END.

    IF tt-inst-emb.data-efet-nacionaliz <> ? THEN DO:
        ASSIGN  tt-inst-emb.dt-nacionaliz  = tt-inst-emb.data-efet-nacionaliz.

        IF AVAIL historico-embarque THEN DO:
            FOR FIRST bf-historico-embarque FIELDS(descricao)
                WHERE bf-historico-embarque.cod-estabel = historico-embarque.cod-estabel
                  AND bf-historico-embarque.embarque    = historico-embarque.embarque
                  AND bf-historico-embarque.cod-itiner  = historico-embarque.cod-itiner
                  AND bf-historico-embarque.cod-pto-contr = tt-inst-emb.pto-nacionaliz:
                ASSIGN tt-inst-emb.loc-destino = bf-historico-embarque.descricao.
            END.
        END.
        
        IF tt-inst-emb.loc-destino = "":U THEN DO:
            FOR FIRST pto-contr FIELDS(descricao)
                WHERE  pto-contr.cod-pto-contr = tt-inst-emb.pto-nacionaliz NO-LOCK:
                ASSIGN tt-inst-emb.loc-destino = pto-contr.descricao.
            END.
        END.
    END.

    IF tt-inst-emb.data-ult-prev-nacionaliz <> ? THEN DO:
        ASSIGN  tt-inst-emb.dt-nacionaliz  = tt-inst-emb.data-ult-prev-nacionaliz.

        IF AVAIL historico-embarque THEN DO:
            FOR FIRST bf-historico-embarque FIELDS(descricao)
                WHERE bf-historico-embarque.cod-estabel = historico-embarque.cod-estabel
                  AND bf-historico-embarque.embarque    = historico-embarque.embarque
                  AND bf-historico-embarque.cod-itiner  = historico-embarque.cod-itiner
                  AND bf-historico-embarque.cod-pto-contr = tt-inst-emb.pto-nacionaliz:
                ASSIGN tt-inst-emb.loc-destino = bf-historico-embarque.descricao.
            END.
        END.
        
        IF tt-inst-emb.loc-destino = "":U THEN DO:
            FOR FIRST pto-contr FIELDS(descricao)
                WHERE  pto-contr.cod-pto-contr = tt-inst-emb.pto-nacionaliz NO-LOCK:
                ASSIGN tt-inst-emb.loc-destino = pto-contr.descricao.
            END.
        END.
    END.

    if  tt-inst-emb.data-efet-embarque <> ? THEN DO:
        ASSIGN  tt-inst-emb.dt-embarque    = tt-inst-emb.data-efet-embarque.

        IF AVAIL historico-embarque THEN DO:
            FOR FIRST bf-historico-embarque FIELDS(descricao)
                WHERE bf-historico-embarque.cod-estabel = historico-embarque.cod-estabel
                  AND bf-historico-embarque.embarque    = historico-embarque.embarque
                  AND bf-historico-embarque.cod-itiner  = historico-embarque.cod-itiner
                  AND bf-historico-embarque.cod-pto-contr = tt-inst-emb.pto-embarque:
                ASSIGN tt-inst-emb.loc-destino = bf-historico-embarque.descricao.
            END.
        END.

        IF tt-inst-emb.loc-destino = "":U THEN DO:
            FOR FIRST pto-contr
                WHERE pto-contr.cod-pto-contr = tt-inst-emb.pto-embarque NO-LOCK:
                ASSIGN tt-inst-emb.loc-destino = pto-contr.descricao.
            END.
        END.
    END.
    ELSE
        IF  tt-inst-emb.data-ult-prev-embarque <> ? THEN DO:
            ASSIGN  tt-inst-emb.dt-embarque    = tt-inst-emb.data-ult-prev-embarque.
            IF AVAIL historico-embarque THEN DO:
                FOR FIRST bf-historico-embarque FIELDS(descricao)
                    WHERE bf-historico-embarque.cod-estabel = historico-embarque.cod-estabel
                      AND bf-historico-embarque.embarque    = historico-embarque.embarque
                      AND bf-historico-embarque.cod-itiner  = historico-embarque.cod-itiner
                      AND bf-historico-embarque.cod-pto-contr = tt-inst-emb.pto-embarque:
                    ASSIGN tt-inst-emb.loc-destino = bf-historico-embarque.descricao.
                END.
            END.
    
            IF tt-inst-emb.loc-destino = "":U THEN DO:
                FOR FIRST pto-contr
                    WHERE pto-contr.cod-pto-contr = tt-inst-emb.pto-embarque NO-LOCK:
                    ASSIGN tt-inst-emb.loc-destino = pto-contr.descricao.
                END.
            END.
        END.

    RUN getBanco IN h-imapi009(OUTPUT TABLE tt-banco).
    FIND FIRST tt-banco NO-ERROR.
    IF AVAIL tt-banco THEN
        ASSIGN tt-inst-emb.desc-banco = tt-banco.nome-banco
               tt-inst-emb.ag-banco   = tt-banco.ag-padrao.

    RUN getAgenciaBanco IN h-imapi009(OUTPUT TABLE tt-agencia).
    FIND FIRST tt-agencia NO-ERROR.
    IF AVAIL tt-agencia THEN
        ASSIGN  tt-inst-emb.desc-agencia = tt-agencia.nome.

END PROCEDURE.

PROCEDURE getDoctosItem:
    DEFINE INPUT  PARAMETER pItCodigo    LIKE tt-it-inst-emb.it-codigo     NO-UNDO.
    DEFINE INPUT  PARAMETER pCodEmitente LIKE tt-exportador.cod-emitente   NO-UNDO. 
    DEFINE INPUT  PARAMETER pCdnPaisOrig LIKE tt-it-inst-emb.cdn-pais-orig NO-UNDO. 
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-docto.

    define variable cTraducao as character format "x(16)":U no-undo.


    FOR EACH  item-docto-import
        WHERE item-docto-import.it-codigo    = pItCodigo   
        AND   item-docto-import.cod-emitente = pCodEmitente
        AND   item-docto-import.cod-pais     = pCdnPaisOrig NO-LOCK:

        FIND FIRST tt-docto
            WHERE  tt-docto.cod-docto = item-docto-import.cod-docto NO-ERROR.
        IF NOT AVAIL tt-docto THEN DO:
            FIND FIRST docto-import
                WHERE  docto-import.cod-docto = item-docto-import.cod-docto NO-LOCK NO-ERROR.
            IF AVAIL docto-import THEN DO:
                CREATE tt-docto.
                ASSIGN tt-docto.cod-docto             = docto-import.cod-docto
                       tt-docto.des-docto             = docto-import.des-docto
                       tt-docto.qti-docto-origin      = docto-import.qti-docto-origin
                       tt-docto.qti-docto-cop-bco     = docto-import.qti-docto-cop-bco
                       tt-docto.qti-docto-cop-imptdor = docto-import.qti-docto-cop-imptdor.

                if  tt-param.l-traducao then do:

                    run piTraducaoItemDocto (input item-docto-import.it-codigo,
                                             input item-docto-import.cod-emitente,
                                             output cTraducao).
                    RUN piTraducaoDescDocto (INPUT tt-docto.cod-docto,
                                             OUTPUT tt-docto.des-docto).
                    assign tt-docto.tr-cod-itens-docto = cTraducao.
                end.
                else
                    assign tt-docto.tr-cod-itens-docto = item-docto-import.it-codigo.

                assign tt-docto.cod-itens-docto = item-docto-import.it-codigo.
            END.
        END.
        ELSE do:
            if  lookup(item-docto-import.it-codigo, tt-docto.cod-itens-docto) = 0 then do:

                 if  tt-param.l-traducao then do:

                    run piTraducaoItemDocto (input item-docto-import.it-codigo,
                                             input item-docto-import.cod-emitente,
                                             output cTraducao).
                    RUN piTraducaoDescDocto (INPUT tt-docto.cod-docto,
                                             OUTPUT tt-docto.des-docto).
                    assign tt-docto.tr-cod-itens-docto = tt-docto.tr-cod-itens-docto + "," + cTraducao.
                end.
                else
                    assign tt-docto.tr-cod-itens-docto = tt-docto.tr-cod-itens-docto + "," + item-docto-import.it-codigo.

                assign tt-docto.cod-itens-docto = tt-docto.cod-itens-docto + "," + item-docto-import.it-codigo.
            end.
        end.
    END.

    FOR EACH  item-docto-import
        WHERE item-docto-import.it-codigo    = pItCodigo   
        AND   item-docto-import.cod-emitente = ?
        AND   item-docto-import.cod-pais     = pCdnPaisOrig NO-LOCK:

        FIND FIRST tt-docto
            WHERE  tt-docto.cod-docto = item-docto-import.cod-docto NO-ERROR.
        IF NOT AVAIL tt-docto THEN DO:
            FIND FIRST docto-import
                WHERE  docto-import.cod-docto = item-docto-import.cod-docto NO-LOCK NO-ERROR.
            IF AVAIL docto-import THEN DO:
                CREATE tt-docto.
                ASSIGN tt-docto.cod-docto             = docto-import.cod-docto
                       tt-docto.des-docto             = docto-import.des-docto
                       tt-docto.qti-docto-origin      = docto-import.qti-docto-origin
                       tt-docto.qti-docto-cop-bco     = docto-import.qti-docto-cop-bco
                       tt-docto.qti-docto-cop-imptdor = docto-import.qti-docto-cop-imptdor.

                if  tt-param.l-traducao then do:

                    run piTraducaoItemDocto (input item-docto-import.it-codigo,
                                             input pCodEmitente,
                                             output cTraducao).
                    RUN piTraducaoDescDocto (INPUT tt-docto.cod-docto,
                                             OUTPUT tt-docto.des-docto).
                    assign tt-docto.tr-cod-itens-docto = cTraducao.
                end.
                else
                    assign tt-docto.tr-cod-itens-docto = item-docto-import.it-codigo.

                assign tt-docto.cod-itens-docto = item-docto-import.it-codigo.
            END.
        END.
        ELSE do:
            if  lookup(item-docto-import.it-codigo, tt-docto.cod-itens-docto) = 0 then do:

                 if  tt-param.l-traducao then do:

                    run piTraducaoItemDocto (input item-docto-import.it-codigo,
                                             input pCodEmitente,
                                             output cTraducao).
                    RUN piTraducaoDescDocto (INPUT tt-docto.cod-docto,
                                             OUTPUT tt-docto.des-docto).
                    assign tt-docto.tr-cod-itens-docto = tt-docto.tr-cod-itens-docto + "," + cTraducao.
                end.
                else
                    assign tt-docto.tr-cod-itens-docto = tt-docto.tr-cod-itens-docto + "," + item-docto-import.it-codigo.

                assign tt-docto.cod-itens-docto = tt-docto.cod-itens-docto + "," + item-docto-import.it-codigo.
            end.
        end.
    END.

    FOR EACH  item-docto-import
        WHERE item-docto-import.it-codigo    = pItCodigo   
        AND   item-docto-import.cod-emitente = pCodEmitente
        AND   item-docto-import.cod-pais     = ? NO-LOCK:

        FIND FIRST tt-docto
            WHERE  tt-docto.cod-docto = item-docto-import.cod-docto NO-ERROR.
        IF NOT AVAIL tt-docto THEN DO:
            FIND FIRST docto-import
                WHERE  docto-import.cod-docto = item-docto-import.cod-docto NO-LOCK NO-ERROR.
            IF AVAIL docto-import THEN DO:
                CREATE tt-docto.
                ASSIGN tt-docto.cod-docto             = docto-import.cod-docto
                       tt-docto.des-docto             = docto-import.des-docto
                       tt-docto.qti-docto-origin      = docto-import.qti-docto-origin
                       tt-docto.qti-docto-cop-bco     = docto-import.qti-docto-cop-bco
                       tt-docto.qti-docto-cop-imptdor = docto-import.qti-docto-cop-imptdor.

                if  tt-param.l-traducao then do:

                    run piTraducaoItemDocto (input item-docto-import.it-codigo,
                                             input pCodEmitente,
                                             output cTraducao).
                    RUN piTraducaoDescDocto (INPUT tt-docto.cod-docto,
                                             OUTPUT tt-docto.des-docto).
                    assign tt-docto.tr-cod-itens-docto = cTraducao.
                end.
                else
                    assign tt-docto.tr-cod-itens-docto = item-docto-import.it-codigo.

                assign tt-docto.cod-itens-docto = item-docto-import.it-codigo.
            END.
        END.
        ELSE do:
            if  lookup(item-docto-import.it-codigo, tt-docto.cod-itens-docto) = 0 then do:

                 if  tt-param.l-traducao then do:

                    run piTraducaoItemDocto (input item-docto-import.it-codigo,
                                             input pCodEmitente,
                                             output cTraducao).
                    RUN piTraducaoDescDocto (INPUT tt-docto.cod-docto,
                                             OUTPUT tt-docto.des-docto).
                    assign tt-docto.tr-cod-itens-docto = tt-docto.tr-cod-itens-docto + "," + cTraducao.
                end.
                else
                    assign tt-docto.tr-cod-itens-docto = tt-docto.tr-cod-itens-docto + "," + item-docto-import.it-codigo.

                assign tt-docto.cod-itens-docto = tt-docto.cod-itens-docto + "," + item-docto-import.it-codigo.
            end.
        end.
    END.

    FOR EACH  item-docto-import
        WHERE item-docto-import.it-codigo    = pItCodigo   
        AND   item-docto-import.cod-emitente = ?
        AND   item-docto-import.cod-pais     = ? NO-LOCK:

        FIND FIRST tt-docto
            WHERE  tt-docto.cod-docto = item-docto-import.cod-docto NO-ERROR.
        IF NOT AVAIL tt-docto THEN DO:
            FIND FIRST docto-import
                WHERE  docto-import.cod-docto = item-docto-import.cod-docto NO-LOCK NO-ERROR.
            IF AVAIL docto-import THEN DO:
                CREATE tt-docto.
                ASSIGN tt-docto.cod-docto             = docto-import.cod-docto
                       tt-docto.des-docto             = docto-import.des-docto
                       tt-docto.qti-docto-origin      = docto-import.qti-docto-origin
                       tt-docto.qti-docto-cop-bco     = docto-import.qti-docto-cop-bco
                       tt-docto.qti-docto-cop-imptdor = docto-import.qti-docto-cop-imptdor.

                if  tt-param.l-traducao then do:

                    run piTraducaoItemDocto (input item-docto-import.it-codigo,
                                             input pCodEmitente,
                                             output cTraducao).
                    RUN piTraducaoDescDocto (INPUT tt-docto.cod-docto,
                                             OUTPUT tt-docto.des-docto).
                    assign tt-docto.tr-cod-itens-docto = cTraducao.
                end.
                else
                    assign tt-docto.tr-cod-itens-docto = item-docto-import.it-codigo.

                assign tt-docto.cod-itens-docto = item-docto-import.it-codigo.
            END.
        END.
        ELSE do:
            if  lookup(item-docto-import.it-codigo, tt-docto.cod-itens-docto) = 0 then do:

                 if  tt-param.l-traducao then do:

                    run piTraducaoItemDocto (input item-docto-import.it-codigo,
                                             input pCodEmitente,
                                             output cTraducao).
                    RUN piTraducaoDescDocto (INPUT tt-docto.cod-docto,
                                             OUTPUT tt-docto.des-docto).
                    assign tt-docto.tr-cod-itens-docto = tt-docto.tr-cod-itens-docto + "," + cTraducao.
                end.
                else
                    assign tt-docto.tr-cod-itens-docto = tt-docto.tr-cod-itens-docto + "," + item-docto-import.it-codigo.

                assign tt-docto.cod-itens-docto = tt-docto.cod-itens-docto + "," + item-docto-import.it-codigo.
            end.
        end.
    END.

END PROCEDURE.

PROCEDURE getItensInsEmbarque:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-it-inst-emb.

    IF  r-processo <> ? THEN DO:

        FIND FIRST tt-processo-aux NO-ERROR.
        IF  AVAIL tt-processo-aux THEN DO:

            FOR EACH  ordem-compra
                WHERE ordem-compra.num-pedido = tt-processo-aux.num-pedido NO-LOCK:

                FOR EACH prazo-compra
                    WHERE  prazo-compra.numero-ordem = ordem-compra.numero-ordem 
                    AND    prazo-compra.situacao    <> 4 NO-LOCK:

                    RUN pi-data-embarque.

                    IF  dt-embarque-aux < tt-param.dt-prevista-ini 
                    or  dt-embarque-aux > tt-param.dt-prevista-fim THEN
                        NEXT.

                    RUN pi-cria-tt-it-inst-emb IN THIS-PROCEDURE(INPUT "Processo").

                END. /* prazo-compra */
            END. /* ordem-compra */
        END. /* tt-processo-aux */
    END.
    ELSE 
        IF  r-embarque <> ? THEN DO:    

            RUN getOrdensEmbarque IN h-imapi009(OUTPUT TABLE tt-ordens-embarque).

            FOR EACH tt-ordens-embarque:
                RUN pi-cria-tt-it-inst-emb IN THIS-PROCEDURE (INPUT "Embarque").
            END.
        END.            

END PROCEDURE.


PROCEDURE pi-cria-tt-it-inst-emb:

    DEFINE INPUT PARAMETER pTipo AS CHARACTER NO-UNDO.

    CREATE tt-it-inst-emb.

    IF  pTipo = "Embarque" THEN DO:
        ASSIGN tt-it-inst-emb.embarque         = tt-ordens-embarque.embarque
               tt-it-inst-emb.nr-proc-imp      = tt-ordens-embarque.nr-proc-imp
               tt-it-inst-emb.cod-estabel      = tt-ordens-embarque.cod-estabel
               tt-it-inst-emb.numero-ordem     = tt-ordens-embarque.numero-ordem
               tt-it-inst-emb.parcela          = tt-ordens-embarque.parcela
               tt-it-inst-emb.quantidade       = tt-ordens-embarque.quantidade
               tt-it-inst-emb.qt-do-forn       = tt-ordens-embarque.qt-do-forn
               tt-it-inst-emb.peso-liquido-uni = tt-ordens-embarque.peso-liquido
               tt-it-inst-emb.peso-liquido-tot = tt-ordens-embarque.peso-liquido
               tt-it-inst-emb.peso-bruto-uni   = tt-ordens-embarque.peso-bruto
               tt-it-inst-emb.peso-bruto-tot   = tt-ordens-embarque.peso-bruto * tt-ordens-embarque.quantidade
               tt-it-inst-emb.vl-cub-uni       = tt-ordens-embarque.val-cub-uni
               tt-it-inst-emb.vl-cub-tot       = tt-ordens-embarque.val-cub-uni * tt-ordens-embarque.quantidade.
    END.
    ELSE DO:
        IF  pTipo = "Processo":U THEN DO:
            FIND FIRST ordens-embarque
                 WHERE ordens-embarque.numero-ordem = prazo-compra.numero-ordem AND
                       ordens-embarque.parcela      = prazo-compra.parcela      NO-LOCK NO-ERROR.

            IF  AVAIL ordens-embarque THEN
                ASSIGN tt-it-inst-emb.embarque = ordens-embarque.embarque.
            ELSE
                ASSIGN tt-it-inst-emb.embarque = "0":U.

            FIND FIRST item
                 WHERE item.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

            IF  AVAIL item THEN
                ASSIGN tt-it-inst-emb.peso-liquido-uni = item.peso-liquido.

            ASSIGN tt-it-inst-emb.dt-embarque      = dt-embarque-aux
                   tt-it-inst-emb.it-codigo        = prazo-compra.it-codigo
                   tt-it-inst-emb.nr-proc-imp      = tt-processo-aux.nr-proc-imp
                   tt-it-inst-emb.cod-estabel      = tt-processo-aux.cod-estabel
                   tt-it-inst-emb.numero-ordem     = prazo-compra.numero-ordem
                   tt-it-inst-emb.parcela          = prazo-compra.parcela
                   tt-it-inst-emb.quantidade       = prazo-compra.quant-saldo
                   tt-it-inst-emb.qt-do-forn       = prazo-compra.qtd-sal-forn
                   tt-it-inst-emb.peso-liquido-tot = tt-it-inst-emb.peso-liquido-uni * prazo-compra.quant-saldo.

            IF  NOT VALID-HANDLE(h-boin356ab) THEN
                RUN inbo/boin356ab.p PERSISTENT SET h-boin356ab.

            RUN retornaPesoUnitario IN h-boin356ab (INPUT  ROWID(prazo-compra),
                                                    OUTPUT tt-it-inst-emb.peso-bruto-uni).

            IF  NOT VALID-HANDLE(h-bodi425) THEN
                RUN dibo/bodi425.p PERSISTENT SET h-bodi425.

            IF  VALID-HANDLE(h-bodi425) AND
                AVAIL ordem-compra      THEN
                RUN piRetornaQtdeEmbalagem IN h-bodi425 (INPUT  prazo-compra.quant-saldo,
                                                         INPUT  prazo-compra.it-codigo,
                                                         INPUT  ordem-compra.cod-emitente,
                                                         OUTPUT d-qtd-embal).

            RUN retornaPesoTotal      IN h-boin356ab (INPUT  ROWID(prazo-compra),
                                                      INPUT  prazo-compra.quant-saldo,
                                                      INPUT  d-qtd-embal,
                                                      OUTPUT tt-it-inst-emb.peso-bruto-tot).

            RUN retornaVolumeUnitario IN h-boin356ab (INPUT  ROWID(prazo-compra),
                                                      OUTPUT tt-it-inst-emb.vl-cub-uni).

            RUN retornaVolumeTotal    IN h-boin356ab (INPUT  ROWID(prazo-compra),
                                                      INPUT  prazo-compra.quant-saldo,
                                                      OUTPUT tt-it-inst-emb.vl-cub-tot).

            IF VALID-HANDLE(h-boin356ab) THEN DO:
                DELETE PROCEDURE h-boin356ab.
                ASSIGN h-boin356ab = ?.
            END.
        END.
    END.

    IF  pTipo = "Embarque":U THEN
        FIND FIRST ordem-compra
             WHERE ordem-compra.numero-ordem = tt-ordens-embarque.numero-ordem NO-LOCK NO-ERROR.

    IF  AVAIL ordem-compra THEN DO:
        ASSIGN tt-it-inst-emb.it-codigo      = ordem-compra.it-codigo
               tt-it-inst-emb.data-emissao   = ordem-compra.data-emissao
               tt-it-inst-emb.narrativa      = ordem-compra.narrativa
               tt-it-inst-emb.data-cotacao   = ordem-compra.data-cotacao
               tt-it-inst-emb.preco-orig     = ordem-compra.preco-orig
               tt-it-inst-emb.preco-unit     = ordem-compra.preco-unit
               tt-it-inst-emb.pre-unit-for   = ordem-compra.pre-unit-for
               tt-it-inst-emb.preco-fornec   = ordem-compra.preco-fornec
               tt-it-inst-emb.mo-codigo      = ordem-compra.mo-codigo
               tt-it-inst-emb.aliquota-ipi   = ordem-compra.aliquota-ipi
               tt-it-inst-emb.aliquota-icm   = ordem-compra.aliquota-icm
               tt-it-inst-emb.aliquota-iss   = ordem-compra.aliquota-iss
               tt-it-inst-emb.taxa-financ    = ordem-compra.taxa-financ
               tt-it-inst-emb.valor-taxa     = ordem-compra.valor-taxa
               tt-it-inst-emb.perc-descto    = ordem-compra.perc-descto
               tt-it-inst-emb.prazo-entreg   = ordem-compra.prazo-entreg
               tt-it-inst-emb.contato        = ordem-compra.contato
               tt-it-inst-emb.comentarios    = ordem-compra.comentarios
               tt-it-inst-emb.data-atualiz   = ordem-compra.data-atualiz
               tt-it-inst-emb.hora-atualiz   = ordem-compra.hora-atualiz
               tt-it-inst-emb.cod-refer      = ordem-compra.cod-refer
               tt-it-inst-emb.valor-descto   = ordem-compra.valor-descto
               tt-it-inst-emb.nr-dias-taxa   = ordem-compra.nr-dias-taxa
               tt-it-inst-emb.licenca-import = ordem-compra.licenca-import
               tt-it-inst-emb.loc-entrega    = ordem-compra.loc-entrega
               tt-it-inst-emb.cod-emitente   = ordem-compra.cod-emitente.

        FIND FIRST cotacao-item
            WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
            AND   cotacao-item.it-codigo    = ordem-compra.it-codigo
            AND   cotacao-item.cod-emitente = ordem-compra.cod-emitente
            AND   cotacao-item.cot-aprovada = YES NO-LOCK NO-ERROR.
        IF AVAIL cotacao-item THEN DO:
            {cdp/cd4300.i4  "yes" cotacao-item.char-1}
            {ccp/cc9019.i51 "yes"}
            {cdp/cd4300.i4  "yes" cotacao-item.char-2}
            {ocp/oc0201.i51 "yes"}

            ASSIGN tt-it-inst-emb.vl-liq-uni          = (cotacao-item.pre-unit-for * 100) / (100 + cotacao-item.aliquota-ipi)
                   tt-it-inst-emb.vl-bruto-uni        = (tt-it-inst-emb.vl-liq-uni * 100) / (100 - cotacao-item.perc-descto)
                   tt-it-inst-emb.vl-liq-tot          = tt-it-inst-emb.vl-liq-uni   * tt-it-inst-emb.qt-do-forn
                   tt-it-inst-emb.vl-bruto-tot        = tt-it-inst-emb.vl-bruto-uni * tt-it-inst-emb.qt-do-forn
                   tt-it-inst-emb.cod-pto-contro-base = i-cod-pto-contr-i50
                   tt-it-inst-emb.aliquota-ii         = de-aliq-ii-i50
                   tt-it-inst-emb.regime-import       = i-regime-import-i50
                   tt-it-inst-emb.cdn-pais-orig       = cotacao-item.cdn-pais-orig
                   tt-it-inst-emb.cod-fabric          = i-cod-fabricante-i50.

            FIND FIRST pto-contr
                WHERE pto-contr.cod-pto-contr = tt-it-inst-emb.cod-pto-contro-base NO-LOCK NO-ERROR.
            IF AVAIL pto-contr THEN
                ASSIGN tt-it-inst-emb.desc-pto-contro-base = pto-contr.descricao.
        END.           

        FIND FIRST moeda
            WHERE moeda.mo-codigo = ordem-compra.mo-codigo NO-LOCK NO-ERROR.
        IF AVAIL moeda THEN
            ASSIGN tt-it-inst-emb.desc-moeda  = moeda.descricao
                   tt-it-inst-emb.sigla-moeda = moeda.sigla.

        IF pTipo = "Embarque" THEN
            FIND FIRST ITEM
                WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL ITEM THEN DO:
            ASSIGN tt-it-inst-emb.altura          = item.altura
                   tt-it-inst-emb.comprim         = item.comprim   
                   tt-it-inst-emb.largura         = item.largura   
                   tt-it-inst-emb.ge-codigo       = item.ge-codigo 
                   tt-it-inst-emb.fm-codigo       = item.fm-codigo 
                   tt-it-inst-emb.fm-cod-com      = item.fm-cod-com
                   tt-it-inst-emb.un              = item.un.

            FIND FIRST grup-estoque
                WHERE grup-estoque.ge-codigo = item.ge-codigo NO-LOCK NO-ERROR.
            IF AVAIL grup-estoque THEN
                ASSIGN tt-it-inst-emb.desc-grup-estoq = grup-estoq.descricao.

            FIND FIRST familia
                WHERE familia.fm-codigo = ITEM.fm-codigo NO-LOCK NO-ERROR.
            IF AVAIL familia THEN
                ASSIGN tt-it-inst-emb.desc-familia = familia.descricao.

            FIND FIRST fam-comerc
                WHERE fam-comerc.fm-cod-com = ITEM.fm-cod-com NO-LOCK NO-ERROR.
            IF AVAIL fam-comerc THEN
                ASSIGN tt-it-inst-emb.desc-fam-comerc = fam-comerc.descricao.

            FIND FIRST item-fornec
                WHERE item-fornec.it-codigo    = ITEM.it-codigo 
                AND   item-fornec.cod-emitente = ordem-compra.cod-emitente NO-LOCK  NO-ERROR.
            IF AVAIL item-fornec THEN
                ASSIGN tt-it-inst-emb.item-fornec  = item-fornec.item-do-forn
                       tt-it-inst-emb.cod-embal    = item-fornec.cod-embal
                       tt-it-inst-emb.unid-for     = item-fornec.unid-med-for
                       tt-it-inst-emb.fator-conver = item-fornec.fator-conver
                       tt-it-inst-emb.num-casa-dec = item-fornec.num-casa-dec.

            IF tt-param.l-traducao THEN DO:
                IF pTipo = "Embarque" THEN
                    FIND FIRST tt-processo-aux
                         WHERE tt-processo-aux.nr-proc-imp = tt-ordens-embarque.nr-proc-imp NO-LOCK NO-ERROR.
                IF  AVAIL tt-processo-aux THEN DO:

                    find trad-tab-unidade
                        where trad-tab-unidade.un         = item.un
                        and   trad-tab-unidade.cod-idioma = tt-processo-aux.cod-idioma no-lock no-error.
                    if  avail trad-tab-unidade then 
                        assign tt-it-inst-emb.un = trad-tab-unidade.tr-un.

                    find trad-tab-unidade
                        where trad-tab-unidade.un         = item-fornec.unid-med-for
                        and   trad-tab-unidade.cod-idioma = tt-processo-aux.cod-idioma no-lock no-error.
                    if  avail trad-tab-unidade then 
                        assign tt-it-inst-emb.unid-for = trad-tab-unidade.tr-un.
                    ELSE
                        assign tt-it-inst-emb.unid-for = item-fornec.unid-med-for WHEN AVAILABLE item-fornec.

                    FIND FIRST traduc-item
                        WHERE  traduc-item.it-codigo    = item-fornec.item-do-forn
                        AND    traduc-item.cod-idioma   = tt-processo-aux.cod-idioma
                        AND    traduc-item.cod-emitente = tt-it-inst-emb.cod-fabric NO-LOCK NO-ERROR.
                    IF  AVAIL  traduc-item THEN 
                        ASSIGN tt-it-inst-emb.desc-item       = traduc-item.tr-desc-item
                               tt-it-inst-emb.tr-it-codigo    = traduc-item.tr-it-codigo
                               tt-it-inst-emb.tr-it-narrativa = traduc-item.tr-narrativa.
                    ELSE DO:
                        FIND FIRST traduc-item
                            WHERE  traduc-item.it-codigo    = item-fornec.item-do-forn
                            AND    traduc-item.cod-idioma   = tt-processo-aux.cod-idioma
                            AND    traduc-item.cod-emitente = tt-processo-aux.cod-exportador NO-LOCK NO-ERROR.
                        IF  AVAIL  traduc-item THEN
                            ASSIGN tt-it-inst-emb.desc-item       = traduc-item.tr-desc-item
                                   tt-it-inst-emb.tr-it-codigo    = traduc-item.tr-it-codigo
                                   tt-it-inst-emb.tr-it-narrativa = traduc-item.tr-narrativa.
                        ELSE DO:
                            FIND FIRST traduc-item
                                WHERE  traduc-item.it-codigo    = item-fornec.item-do-forn
                                AND    traduc-item.cod-idioma   = tt-processo-aux.cod-idioma
                                AND    traduc-item.cod-emitente = 0 NO-LOCK NO-ERROR.
                            IF  AVAIL  traduc-item THEN
                                ASSIGN tt-it-inst-emb.desc-item       = traduc-item.tr-desc-item
                                       tt-it-inst-emb.tr-it-codigo    = traduc-item.tr-it-codigo
                                       tt-it-inst-emb.tr-it-narrativa = traduc-item.tr-narrativa.
                            ELSE DO:
                                FIND FIRST traduc-item
                                    WHERE traduc-item.it-codigo    = tt-it-inst-emb.it-codigo
                                    AND   traduc-item.cod-idioma   = tt-processo-aux.cod-idioma
                                    AND   traduc-item.cod-emitente = tt-it-inst-emb.cod-fabric NO-LOCK NO-ERROR.
                                IF  AVAIL traduc-item THEN
                                    ASSIGN tt-it-inst-emb.desc-item       = traduc-item.tr-desc-item
                                           tt-it-inst-emb.tr-it-codigo    = traduc-item.tr-it-codigo
                                           tt-it-inst-emb.tr-it-narrativa = traduc-item.tr-narrativa.
                                ELSE DO:
                                    FIND FIRST traduc-item
                                        WHERE traduc-item.it-codigo    = tt-it-inst-emb.it-codigo
                                        AND   traduc-item.cod-idioma   = tt-processo-aux.cod-idioma
                                        AND   traduc-item.cod-emitente = tt-processo-aux.cod-exportador NO-LOCK NO-ERROR.
                                    IF  AVAIL traduc-item THEN
                                        ASSIGN tt-it-inst-emb.desc-item       = traduc-item.tr-desc-item
                                               tt-it-inst-emb.tr-it-codigo    = traduc-item.tr-it-codigo
                                               tt-it-inst-emb.tr-it-narrativa = traduc-item.tr-narrativa.
                                    ELSE DO:
                                        FIND FIRST traduc-item
                                            WHERE traduc-item.it-codigo    = tt-it-inst-emb.it-codigo
                                            AND   traduc-item.cod-idioma   = tt-processo-aux.cod-idioma
                                            AND   traduc-item.cod-emitente = 0 NO-LOCK NO-ERROR.
                                        IF  AVAIL traduc-item THEN
                                            ASSIGN tt-it-inst-emb.desc-item       = traduc-item.tr-desc-item
                                                   tt-it-inst-emb.tr-it-codigo    = traduc-item.tr-it-codigo
                                                   tt-it-inst-emb.tr-it-narrativa = traduc-item.tr-narrativa.
                                        ELSE
                                            ASSIGN tt-it-inst-emb.desc-item       = item.desc-item
                                                   tt-it-inst-emb.tr-it-codigo    = item.it-codigo
                                                   tt-it-inst-emb.tr-it-narrativa = item.narrativa.
                                    END.
                                END.
                            END.
                        END.
                    END.
                END.
            END.    
            ELSE
                ASSIGN tt-it-inst-emb.desc-item       = item.desc-item
                       tt-it-inst-emb.tr-it-codigo    = item.it-codigo
                       tt-it-inst-emb.tr-it-narrativa = item.narrativa
                       tt-it-inst-emb.unid-for        = item-fornec.unid-med-for WHEN AVAILABLE item-fornec
                       tt-it-inst-emb.un              = item.un.

        END. /* item */
    END. /* ordem-compra */

    if  valid-handle (h-bodi425) then do:
        delete procedure h-bodi425.
        assign h-bodi425 = ?.
    end.

    ASSIGN d-qtd-embal = 0.
    
END PROCEDURE.

PROCEDURE pi-data-embarque:

    ASSIGN dt-embarque-aux = ?.

    FIND FIRST ordens-embarque
        WHERE  ordens-embarque.numero-ordem = prazo-compra.numero-ordem
        AND    ordens-embarque.parcela      = prazo-compra.parcela NO-LOCK NO-ERROR.
    IF  AVAIL ordens-embarque THEN DO:
        FIND FIRST historico-embarque
            WHERE  historico-embarque.cod-estabel = ordens-embarque.cod-estabel
            AND    historico-embarque.embarque    = ordens-embarque.embarque     NO-LOCK NO-ERROR.
        IF  AVAIL historico-embarque THEN DO:

            FOR FIRST embarque-imp FIELDS(cdn-pto-embarq) NO-LOCK
                WHERE embarque-imp.cod-estab = ordens-embarque.cod-estabel
                  AND embarque-imp.embarque = ordens-embarque.embarque: END.

            find first historico-embarque
                 where historico-embarque.cod-estabel   = ordens-embarque.cod-estabel
                   and historico-embarque.embarque      = ordens-embarque.embarque
                   and historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-embarq no-lock no-error.
            if  avail historico-embarque then do:

                IF  historico-embarque.dt-efetiva <> ? THEN
                    ASSIGN dt-embarque-aux = historico-embarque.dt-efetiva.
                ELSE
                    ASSIGN dt-embarque-aux = historico-embarque.dt-ult-previsao.
            END.
        END.
    END.
    else do:

        FIND FIRST historico-proc-imp
            WHERE  historico-proc-imp.cod-estabel = tt-processo-aux.cod-estabel
            AND    historico-proc-imp.nr-proc-imp = tt-processo-aux.nr-proc-imp NO-LOCK NO-ERROR.
        IF  AVAIL historico-proc-imp THEN DO:

            find first itinerario 
                WHERE itinerario.cod-itiner   = historico-proc-imp.cod-itiner no-lock no-error.
            if  avail itinerario then do:

                FIND FIRST historico-proc-imp
                    WHERE historico-proc-imp.cod-estabel   = tt-processo-aux.cod-estabel
                    AND   historico-proc-imp.nr-proc-imp   = tt-processo-aux.nr-proc-imp 
                    AND   historico-proc-imp.cod-pto-contr = itinerario.pto-embarque NO-LOCK NO-ERROR.
                if  avail historico-proc-imp then do:

                    IF  historico-proc-imp.dt-efetiva <> ? THEN
                        ASSIGN dt-embarque-aux = historico-proc-imp.dt-efetiva.
                    ELSE
                        ASSIGN dt-embarque-aux = historico-proc-imp.dt-ult-previsao.
                end.
            END.
        END.    
        else do:
            IF  dt-embarque-aux = ? THEN DO:

                FIND FIRST itinerario
                    WHERE itinerario.cod-itiner = tt-processo-aux.cod-itiner NO-LOCK NO-ERROR.
                IF  AVAIL itinerario THEN DO:

                    ASSIGN de-nr-dias = 0.
                    FOR EACH pto-itiner
                        WHERE  pto-itiner.cod-itiner     = itinerario.cod-itiner
                        AND    pto-itiner.cod-pto-contr >= itinerario.pto-embarque
                        AND    pto-itiner.cod-pto-contr <= itinerario.pto-chegada NO-LOCK:
                        ASSIGN de-nr-dias = de-nr-dias + pto-itiner.nr-dias.
                    END.
                END.
                ASSIGN dt-embarque-aux = prazo-compra.data-entrega - de-nr-dias.
            END.
        end.
    end.

END PROCEDURE.

PROCEDURE emptyTempTables:
    EMPTY TEMP-TABLE tt-estabelec.
    EMPTY TEMP-TABLE tt-estabelec-aux.
    EMPTY TEMP-TABLE tt-exportador.
    EMPTY TEMP-TABLE tt-exportador-aux.
    EMPTY TEMP-TABLE tt-consignatario.
    EMPTY TEMP-TABLE tt-consignatario-aux.
    EMPTY TEMP-TABLE tt-agente-carga.
    EMPTY TEMP-TABLE tt-agente-carga-aux.
    EMPTY TEMP-TABLE tt-transporte.
    EMPTY TEMP-TABLE tt-transporte-aux.
    EMPTY TEMP-TABLE tt-embarque.
    EMPTY TEMP-TABLE tt-processo.
    EMPTY TEMP-TABLE tt-processo-aux.
    EMPTY TEMP-TABLE tt-pedido.
    EMPTY TEMP-TABLE tt-it-inst-emb.
    EMPTY TEMP-TABLE tt-docto.
    EMPTY TEMP-TABLE tt-inst-emb.
END PROCEDURE.



PROCEDURE piImprimirDoctosGerados:

    IF  CAN-FIND(FIRST tt-documentos-erros) THEN DO:
        {utp/ut-liter.i ERROS * L}
        PUT RETURN-VALUE FORMAT "x(10)".
        PUT UNFORMATTED SKIP(1).
        FOR EACH tt-documentos-erros
            BY tt-documentos-erros.cod-estabel:

            IF tt-documentos-erros.mensagem <> '' THEN
                RUN pi-imprime-narrativa-erro (INPUT 1).
            ELSE
                ASSIGN c-erro = ''.

            IF tt-param.classifica = 1 THEN DO:
                DISP tt-documentos-erros.cod-estabel     
                     tt-documentos-erros.nome-abrev      
                     tt-documentos-erros.nr-proc-imp     
                     tt-documentos-erros.num-pedido      
                     tt-documentos-erros.dt-embarque          
                     tt-documentos-erros.cod-erro        
                     c-erro        
                     WITH FRAME f-doc-erros-proc.      
                DOWN WITH FRAME f-doc-erros-proc.      
            END.
            ELSE DO:
                DISP tt-documentos-erros.cod-estabel
                     tt-documentos-erros.nome-abrev 
                     tt-documentos-erros.embarque   
                     tt-documentos-erros.cod-erro   
                     c-erro   
                     WITH FRAME f-doc-erros-emb.    
                DOWN WITH FRAME f-doc-erros-emb.    
            END.  
            RUN pi-imprime-narrativa-erro (INPUT 2).
        END.
    END.
    IF  CAN-FIND(FIRST tt-documentos-impressos) THEN DO:

        PUT UNFORMATTED SKIP(1).
        {utp/ut-liter.i DOCUMENTOS_IMPRESSOS * L}
        PUT RETURN-VALUE FORMAT "x(30)".
        PUT UNFORMATTED SKIP(1).

        FOR EACH tt-documentos-impressos:
            IF  tt-param.classifica = 1 THEN DO:
                DISP tt-documentos-impressos.cod-estabel 
                     tt-documentos-impressos.nome-abrev  
                     tt-documentos-impressos.nr-proc-imp 
                     tt-documentos-impressos.num-pedido      
                     tt-documentos-impressos.dt-embarque          
                     tt-documentos-impressos.destino     
                    WITH FRAME f-doc-impressos-proc.
                DOWN WITH FRAME f-doc-impressos-proc.
            END.
            ELSE DO:
                DISP tt-documentos-impressos.cod-estabel 
                     tt-documentos-impressos.nome-abrev  
                     tt-documentos-impressos.embarque    
                     tt-documentos-impressos.destino     
                    WITH FRAME f-doc-impressos-emb.
                DOWN WITH FRAME f-doc-impressos-emb.     
            END.
        END.                             
    END.    
END PROCEDURE.

PROCEDURE pi-imprime-narrativa-erro:
    DEFINE INPUT PARAMETER pLinha AS INTEGER NO-UNDO.
    RUN pi-print-editor (tt-documentos-erros.mensagem, 70).
    FOR EACH tt-editor: 
        IF pLinha = 1 THEN DO:
            ASSIGN c-erro = tt-editor.conteudo.
            LEAVE.
        END.
        ELSE 
            IF pLinha > 2  THEN DO:
                IF tt-param.classifica = 1 THEN
                    PUT tt-editor.conteudo  AT 62  FORMAT "x(70)":U .
                ELSE
                    PUT tt-editor.conteudo  AT 38  FORMAT "x(70)":U .
            END.
        ASSIGN pLinha = pLinha + 1.                              
    END.
END.


PROCEDURE piImprimirParametros:

    DEFINE VARIABLE c-traduz AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cValor   AS CHARACTER  NO-UNDO.

    PAGE.
    /*** FOLDER SELE€ÇO ***/
    {utp/ut-liter.i "SELE€ÇO" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz AT 0 SKIP(1).

    /* Faixa Estabelecimento */
    {utp/ut-liter.i "Estabelecimento:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz                   AT 029 FORMAT "x(16)"
&IF "{&mguni_version}" >= "2.071" &THEN
        tt-param.c-cod-estabel-ini AT 046 format "x(05)"
&ELSE
        tt-param.c-cod-estabel-ini AT 046 FORMAT "X(03)"
&ENDIF
        "|<   >|"                  AT 053
&IF "{&mguni_version}" >= "2.071" &THEN
        tt-param.c-cod-estabel-fim AT 071 format "x(05)".
&ELSE
        tt-param.c-cod-estabel-fim AT 071 FORMAT "X(03)".
&ENDIF
    PUT UNFORMATTED SKIP.
    /* Faixa Processo Importacao */
    {utp/ut-liter.i "Processo_Importa‡Æo:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz                   AT 025 FORMAT "x(20)"
        tt-param.c-nr-proc-imp-ini AT 046 FORMAT "X(12)"
        "|<   >|"                  AT 059
        tt-param.c-nr-proc-imp-fim AT 067 FORMAT "X(12)".
    PUT UNFORMATTED SKIP.
    /* Faixa Processo Embarque */
    {utp/ut-liter.i "Embarque:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz                   AT 036 FORMAT "x(09)"
        tt-param.c-embarque-ini    AT 046 FORMAT "X(16)"
        "|<   >|"                  AT 063
        tt-param.c-embarque-fim    AT 071 FORMAT "X(16)".
    PUT UNFORMATTED SKIP.
    /* Faixa Processo Embarque */
    {utp/ut-liter.i "Fornecedor:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz                   AT 034 FORMAT "x(11)"
        tt-param.i-fornecedor-ini  AT 046 FORMAT ">>>>>>>9"
        "|<   >|"                  AT 063
        tt-param.i-fornecedor-fim  AT 071 FORMAT ">>>>>>>9".
    PUT UNFORMATTED SKIP.
    /* Faixa Processo Embarque */
    {utp/ut-liter.i "Data_Prevista_Embarque:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz                   AT 022 FORMAT "x(23)"
        tt-param.dt-prevista-ini   AT 046 FORMAT "99/99/9999"
        "|<   >|"                  AT 063
        tt-param.dt-prevista-fim   AT 071 FORMAT "99/99/9999".
    PUT UNFORMATTED SKIP(1).

    /*** FOLDER CLASSIFICA€ÇO ***/
    {utp/ut-liter.i "CLASSIFICA€ÇO" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz AT 0 FORMAT "x(15)" SKIP(1).
    {utp/ut-liter.i "Classifica‡Æo:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    IF tt-param.classifica = 1 THEN DO:
        {utp/ut-liter.i "Processo" * r}.
        ASSIGN c-classif = RETURN-VALUE.
    END.
    ELSE DO:
        {utp/ut-liter.i "Embarque" * r}.
        ASSIGN c-classif = RETURN-VALUE.
    END.

    PUT c-traduz                   AT 031 FORMAT "x(14)"
        c-classif                  AT 046 FORMAT "x(08)".
    PUT UNFORMATTED SKIP(1).

    /*** FOLDER PAR¶METROS ***/
    {utp/ut-liter.i "PAR¶METROS" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz AT 0 FORMAT "x(15)" SKIP(1).

    {utp/ut-liter.i "Envia_docto_para_fornecedor:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.    
    PUT c-traduz                          AT 017 FORMAT "x(28)"
        tt-param.l-envia-docto-fornec     AT 046 FORMAT d-sim-nao.
    PUT UNFORMATTED SKIP.

    {utp/ut-liter.i "Envia_C¢pia_para:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz                 AT 028 FORMAT "x(17)"
        tt-param.c-arquivo-copia AT 046 FORMAT "x(50)".
       PUT UNFORMATTED SKIP.

    {utp/ut-liter.i "Utiliza_Layout_PadrÆo_do_Fornecedor:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz                          AT 009 FORMAT "x(36)"
        tt-param.l-layout-pad-fornec      AT 046 FORMAT d-sim-nao.
    PUT UNFORMATTED SKIP.

    IF NOT tt-param.l-layout-pad-fornec THEN DO:
       {utp/ut-liter.i "Layout_PadrÆo:" * r}.
       ASSIGN c-traduz = RETURN-VALUE.
       PUT c-traduz                     AT 031 FORMAT "x(15)"
           tt-param.c-layout-pad-fornec AT 046 FORMAT "x(50)".
       PUT UNFORMATTED SKIP.
    END.
    {utp/ut-liter.i Sobrepor_arquivos_j _existentes?: *}.
    ASSIGN c-traduz = TRIM(RETURN-VALUE).
    PUT c-traduz                AT 012 FORMAT "x(33)"
        tt-param.l-sobrepor     AT 046 FORMAT d-sim-nao.
    PUT UNFORMATTED SKIP.

    {utp/ut-liter.i "Diret¢rio:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz                AT 035 FORMAT "x(10)"
        tt-param.c-dir-destino  AT 046 FORMAT "x(50)".    

    IF tt-param.i-orientacao = 0 THEN DO:
       {utp/ut-liter.i "Retrato" * r}.
       ASSIGN cValor = RETURN-VALUE.
    END.
    ELSE DO:
       {utp/ut-liter.i "Paisagem" * r}.
       ASSIGN cValor = RETURN-VALUE.
    END.

    {utp/ut-liter.i "Orienta‡Æo:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz       AT 034 FORMAT "x(11)"
        cValor         AT 046.
    PUT UNFORMATTED SKIP.   

    {utp/ut-liter.i "Traduzir:" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz                    AT 036 FORMAT "x(09)"
        tt-param.l-traducao         AT 046 FORMAT d-sim-nao.
    PUT UNFORMATTED SKIP(1).

    /*** FOLDER IMPRESSÇO ***/
    {utp/ut-liter.i "IMPRESSÇO" * r}.
    ASSIGN c-traduz = RETURN-VALUE.
    PUT c-traduz AT 0 FORMAT "x(15)" SKIP(1).

    {utp/ut-liter.i "Destino:" * r}
    ASSIGN c-traduz = RETURN-VALUE.

    IF tt-param.destino = 1 THEN DO:
        {utp/ut-liter.i "Impressora" * r}.
        ASSIGN c-destino = RETURN-VALUE.
    END.
    ELSE DO:
        IF tt-param.destino = 2 THEN DO:
            {utp/ut-liter.i "Arquivo" * r}.
            ASSIGN c-destino = RETURN-VALUE.
        END.
        ELSE DO:
            {utp/ut-liter.i "Terminal" * r}.
            ASSIGN c-destino = RETURN-VALUE.
        END.
    END.

    PUT c-traduz         AT 037 FORMAT "x(08)"
        c-destino        AT 046 FORMAT "x(40)".
    PUT UNFORMATTED SKIP.

    IF tt-param.destino = 2 THEN DO:
        {utp/ut-liter.i "Arquivo:" * r}
        ASSIGN c-traduz = RETURN-VALUE.
        PUT c-traduz         AT 037 FORMAT "x(08)"
            tt-param.arquivo AT 046 FORMAT "x(40)".
        PUT UNFORMATTED SKIP.
    END.

END PROCEDURE.


procedure piTraducaoItemDocto:
    define input  parameter cItCodigo    as character format "x(16)":U     no-undo.
    define input  parameter iCodEmitente as integer   format ">>>>>>>>9":U no-undo.
    define output parameter cTraducao    as character format "x(16)":U     no-undo.

    FIND FIRST item-fornec
        WHERE item-fornec.it-codigo    = cItCodigo
        AND   item-fornec.cod-emitente = iCodEmitente NO-LOCK NO-ERROR.

    find first item 
        where item.it-codigo = cItCodigo no-lock no-error.

    IF AVAILABLE item-fornec THEN DO:
        FIND FIRST traduc-item
            WHERE  traduc-item.it-codigo    = item-fornec.item-do-forn
            AND    traduc-item.cod-idioma   = tt-processo-aux.cod-idioma
            AND    traduc-item.cod-emitente = tt-it-inst-emb.cod-fabric NO-LOCK NO-ERROR.
        IF  AVAIL  traduc-item THEN 
            assign cTraducao = traduc-item.tr-it-codigo.
        ELSE DO:
            FIND FIRST traduc-item
                WHERE  traduc-item.it-codigo    = item-fornec.item-do-forn
                AND    traduc-item.cod-idioma   = tt-processo-aux.cod-idioma
                AND    traduc-item.cod-emitente = tt-processo-aux.cod-exportador NO-LOCK NO-ERROR.
            IF  AVAIL  traduc-item THEN
                assign cTraducao = traduc-item.tr-it-codigo.
            ELSE DO:
                FIND FIRST traduc-item
                    WHERE  traduc-item.it-codigo    = item-fornec.item-do-forn
                    AND    traduc-item.cod-idioma   = tt-processo-aux.cod-idioma
                    AND    traduc-item.cod-emitente = 0 NO-LOCK NO-ERROR.
                IF  AVAIL  traduc-item THEN
                    assign cTraducao = traduc-item.tr-it-codigo.
            END.
        end.
    END.
    IF cTraducao = "" THEN DO:
        FIND FIRST traduc-item
            WHERE traduc-item.it-codigo    = item.it-codigo
            AND   traduc-item.cod-idioma   = tt-processo-aux.cod-idioma
            AND   traduc-item.cod-emitente = tt-it-inst-emb.cod-fabric NO-LOCK NO-ERROR.
        IF  AVAIL traduc-item THEN
            assign cTraducao = traduc-item.tr-it-codigo.
        ELSE DO:
            FIND FIRST traduc-item
                WHERE traduc-item.it-codigo    = item.it-codigo
                AND   traduc-item.cod-idioma   = tt-processo-aux.cod-idioma
                AND   traduc-item.cod-emitente = tt-processo-aux.cod-exportador NO-LOCK NO-ERROR.
            IF  AVAIL traduc-item THEN
                assign cTraducao = traduc-item.tr-it-codigo.
            ELSE DO:
                FIND FIRST traduc-item
                    WHERE traduc-item.it-codigo    = item.it-codigo
                    AND   traduc-item.cod-idioma   = tt-processo-aux.cod-idioma
                    AND   traduc-item.cod-emitente = 0 NO-LOCK NO-ERROR.
                IF  AVAIL traduc-item THEN
                    assign cTraducao = traduc-item.tr-it-codigo. 
                else
                     assign cTraducao = item.it-codigo.
            END.
        END.
    END.
end procedure.


PROCEDURE piTraducaoDescDocto:

    DEFINE INPUT  PARAMETER pcod-docto LIKE tt-docto.cod-docto.
    DEFINE OUTPUT PARAMETER pdes-docto LIKE tt-docto.des-docto.

    FIND trad-docto-import NO-LOCK WHERE
        trad-docto-import.cod-docto  = pcod-docto AND
        trad-docto-import.cod-idioma = tt-processo-aux.cod-idioma NO-ERROR.

    IF AVAILABLE trad-docto-import THEN
        ASSIGN pdes-docto = trad-docto-import.des-trad.
    ELSE
        ASSIGN pdes-docto = tt-docto.des-docto.

END PROCEDURE.
