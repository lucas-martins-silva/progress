/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9016F 2.00.00.003 } /*** "010003" 09/10/2025 11:26:31 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9016F MBC}
&ENDIF




/* VERSAO DE INTEGRACAO */

&SCOPED-DEFINE Versao-Integracao 1
{cdp/cd0666.i}      /* Definicao da temp-table de erros         */
{bcp/bc1000.i}      /* Procedure geraTTErro */
 def temp-table tt-erro-aux no-undo  like tt-erro.
{bcp/bcapi001.i}    /* Definicao da temp-table de transacoes    */

{include/i_dbtype.i}
{include/i_dbvers.i}

DEF VAR i-cont-erro AS INT.
def var l-erro      as logical init no.
def var i-cont      as integer no-undo.
def var i-cod-erro  as int.
DEF VAR v-seq-erro  AS INTEGER NO-UNDO.

&IF "{&mgcld_version}":U >= "2.02":U &THEN

PROCEDURE verif_qtd_lida_reg:
    DEF INPUT  PARAM TABLE FOR tt-trans.
    DEF OUTPUT       PARAM vcont AS INTEGER.
    ASSIGN vcont = 0.
    FIND FIRST tt-trans NO-LOCK NO-ERROR.
    IF AVAILABLE tt-trans THEN DO:
        FOR FIRST bc-trans FIELDS(nr-trans) USE-INDEX bctrans-06 
            WHERE bc-trans.detalhe      = tt-trans.detalhe 
              AND bc-trans.estado-trans = 4                
              AND bc-trans.cd-trans     = 'WMEnt002':U NO-LOCK:
            FOR EACH bc-trans-filho FIELDS(nr-trans) WHERE bc-trans-filho.nr-trans = bc-trans.nr-trans NO-LOCK:
                ASSIGN vcont = vcont + 1.
            END.
        END.
    END.
END PROCEDURE.   

PROCEDURE verif_serial:
    DEF INPUT  PARAM TABLE FOR tt-trans.
    DEF INPUT  PARAM TABLE FOR tt-trans-filho. /* sempre ser  enviado um serial por vez */
    
    FIND FIRST tt-trans NO-LOCK NO-ERROR.
    FIND FIRST tt-trans-filho NO-LOCK NO-ERROR.
    
    IF AVAILABLE tt-trans and
       AVAILABLE tt-trans-filho THEN DO:
       FOR FIRST bc-trans  FIELDS(nr-trans) USE-INDEX bctrans-06
           WHERE bc-trans.detalhe      = tt-trans.detalhe 
             AND bc-trans.estado-trans = 4                
             AND bc-trans.cd-trans     = 'WMEnt002':U     NO-LOCK:
          if  can-find(first bc-trans-filho NO-LOCK WHERE
              bc-trans-filho.nr-trans = bc-trans.nr-trans AND
              entry(5,bc-trans-filho.conteudo-trans,';':U) = entry(5,tt-trans-filho.conteudo-xml,';':U)) THEN DO:
              RETURN 'NOK':U.
          END.
          ELSE DO:
              RETURN 'OK':U.
          END.
        END.
    END.
    RETURN 'OK':U . /* achou registro */
END PROCEDURE. 

PROCEDURE finaliza_conferencia:

DEF INPUT  PARAM TABLE FOR tt-trans.
DEF OUTPUT PARAM TABLE FOR tt-erro.

    DEF VAR vcontreg AS INTEGER.
    DEF VAR vcont    AS INTEGER.


    FOR EACH tt-erro:
        DELETE tt-erro.
    END.
    FOR EACH tt-trans:
        
         if  tt-trans.cod-versao-integracao <> {&Versao-Integracao} then do:
            run utp/ut-msgs.p (input "msg",
                               input 3941,
                               input "").
            create tt-erro.
            assign i-cont-erro = i-cont-erro + 1.
            assign tt-erro.i-sequen = i-cont-erro
                   tt-erro.cd-erro  = 3941
                   tt-erro.mensagem = RETURN-VALUE + "(DC)":U
                   l-erro = yes.
        end.

        find first bc-tipo-trans
            where bc-tipo-trans.cd-trans = tt-trans.cd-trans
            no-lock no-error.
        if  not available(bc-tipo-trans) then do:
            {utp/ut-field.i mgcld bc-tipo-trans cd-trans 1}
            run utp/ut-msgs.p (input "msg",
                               input 56,
                               input trim(return-value)).
            create tt-erro.
            assign i-cont-erro = i-cont-erro + 1.
            ASSIGN tt-erro.i-sequen = i-cont-erro
                   tt-erro.cd-erro  = 56
                   tt-erro.mensagem = RETURN-VALUE + "(DC)":U
                   l-erro = yes.
        end.
        if  (   tt-trans.detalhe = ?
             or tt-trans.detalhe = "")
        then do:
            {utp/ut-field.i mgcld bc-trans detalhe 1}
            run utp/ut-msgs.p (input "msg",
                               input 5793,
                               input trim(return-value)).
            create tt-erro.
            assign i-cont-erro = i-cont-erro + 1.
            assign tt-erro.i-sequen = i-cont-erro
                   tt-erro.cd-erro  = 5793
                   tt-erro.mensagem = RETURN-VALUE + "(DC)":U
                   l-erro = yes.
        end.
        if  (   tt-trans.usuario = ?
             or tt-trans.usuario = "")
        then do:
            {utp/ut-field.i mgcld bc-trans usuario 1}
            run utp/ut-msgs.p (input "msg",
                               input 5793,
                               input trim(return-value)).
            create tt-erro.
            assign i-cont-erro = i-cont-erro + 1.
            ASSIGN tt-erro.i-sequen = i-cont-erro
                   tt-erro.cd-erro  = 5793
                   tt-erro.mensagem = RETURN-VALUE + "(DC)":U
                   l-erro = yes.
        end.
        
        if  l-erro = yes then undo, next.
        DO TRANSACTION:
            FIND FIRST bc-trans USE-INDEX bctrans-06 
                 WHERE bc-trans.estado-trans = 4 
                   AND bc-trans.detalhe      = tt-trans.detalhe      
                   and bc-trans.cd-trans     = 'WMEnt002':U     EXCLUSIVE-LOCK NO-ERROR. 
        
            IF NOT AVAILABLE bc-trans THEN DO:
                create tt-erro.
                assign i-cont-erro = i-cont-erro + 1.
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Inexistente" *}
                ASSIGN tt-erro.i-sequen = i-cont-erro
                       tt-erro.cd-erro  = 56
                       tt-erro.mensagem = tt-trans.detalhe + " " + RETURN-VALUE + "(DC)":U.
            END.
            ELSE DO:
                ASSIGN tt-trans.nr-trans = bc-trans.nr-trans.
                
                IF bc-trans.estado-trans  = 4 THEN DO:
                    ASSIGN bc-trans.estado-trans = 1. /** 1-Nova, 2-Atualizada, 3-Com Erro */ 
                END.
                ELSE DO:
                     run utp/ut-msgs.p (input "msg",
                                        input 27845,
                                        input trim(return-value)).
                     create tt-erro.
                     assign i-cont-erro = i-cont-erro + 1.
                     ASSIGN tt-erro.i-sequen = i-cont-erro
                            tt-erro.cd-erro  = 27845
                            tt-erro.mensagem = RETURN-VALUE + "(DC)":U.
                     ASSIGN l-erro = yes.
                END.
            END.
        END.
        if  l-erro = yes then undo, next.
    END.
    RETURN 'OK':U.

END PROCEDURE.


PROCEDURE conferencia_pre_api_wms:

DEF INPUT-OUTPUT  PARAM TABLE FOR tt-trans.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-erro.

    FOR EACH tt-trans:
        find first bc-tipo-trans
             where bc-tipo-trans.cd-trans = tt-trans.cd-trans
            no-lock no-error.                                

        DO TRANSACTION:
        
        FIND FIRST bc-trans WHERE bc-trans.nr-trans = tt-trans.nr-trans EXCLUSIVE-LOCK NO-ERROR. 
        if      bc-trans.estado-trans   = 1             /* estado da transa‡Æo = 1-Nova  log-1 = yes (atualiza-on-line) */
        and (   bc-tipo-trans.atualiza-on-line  = yes
             or bc-tipo-trans.imp-apos-trans    = yes)
        then do:

            for each tt-erro-aux:
                delete tt-erro-aux.
            end.

            /***** execucao da pre-api ***/  
            erro:
            do  on error  undo erro, leave erro
                on quit   undo erro, leave erro
                on stop   undo erro, leave erro
                on endkey undo erro, leave erro:

                
                if  not tt-trans.etiqueta           /* tt-trans.etiqueta = <NO> - Gera Transa‡Æo Movimento */
                and bc-tipo-trans.atualiza-on-line
                then do:
                    if  bc-tipo-trans.api-atualizacao <> ""
                    then do:
                        
                        run value(bc-tipo-trans.api-atualizacao)
                                 (  input tt-trans.nr-trans,
                                    input tt-trans.conteudo-trans,
                                    input-output table tt-erro-aux) no-error.
                            assign  bc-trans.estado-trans     = 2
                                    bc-trans.data-atualizacao = today
                                    bc-trans.hora-atualizacao = string(time,"HH:MM:SS":U).
                        
                    end.
                    else do:
                        run utp/ut-msgs.p ( input "msg":U,
                                            input 4,
                                            input RETURN-VALUE + "(DC)":U) .

                        create tt-erro.
                        assign i-cont-erro = i-cont-erro + 1.
                        assign tt-erro.i-sequen = i-cont-erro
                               tt-erro.cd-erro  = 4
                               tt-erro.mensagem = return-value.
                    end.
                end.
            
                if  tt-trans.etiqueta               /* tt-trans.etiqueta = <YES> - Gera Transa‡Æo Etiqueta */
                and bc-tipo-trans.imp-apos-trans
                then do:
                    if  bc-tipo-trans.prog-etiq <> ""
                    then do:
                        run value(bc-tipo-trans.prog-etiq)
                                 (  input tt-trans.nr-trans,
                                    input tt-trans.conteudo-trans,
                                    input-output table tt-erro-aux) no-error.

                        
                            assign  bc-trans.estado-trans     = 2
                                    bc-trans.data-atualizacao = today
                                    bc-trans.hora-atualizacao = string(time,"HH:MM:SS":U).
                        
                    end.
                    else do:
                        run utp/ut-msgs.p ( input "msg":U,
                                            input 4,
                                            input RETURN-VALUE).
                        create tt-erro.
                        assign i-cont-erro             = i-cont-erro + 1.
                        assign tt-erro.i-sequen = i-cont-erro
                               tt-erro.cd-erro  = 4
                               tt-erro.mensagem = RETURN-VALUE + "(DC)":U.
                    end.
                end.
            end.
        
            if  error-status:error
                or  (    error-status:get-number(1) <> 138
                     and error-status:num-messages <> 0)
            then do:
                do  i-cont = 1 to error-status:num-messages
                       while(error-status:get-message(i-cont) <> ""):
                    
                    assign i-cod-erro = error-status:get-number(i-cont).
                
                    run utp/ut-msgs.p (input "msg":U,
                                       input 15837,
                                       input (if  bc-trans.log-1 = no 
                                              then
                                                  bc-tipo-trans.api-atualizacao
                                              else 
                                                  bc-tipo-trans.prog-etiq) ).

                    create tt-erro.
                    assign i-cont-erro      = i-cont-erro + 1
                           tt-erro.i-sequen = i-cont-erro
                           tt-erro.cd-erro  = 15837
                           tt-erro.mensagem = trim(return-value) + "(DC)":U. 
                       
                    {utp/ut-liter.i Transa‡Æo * L}       
                    assign tt-erro.mensagem     = tt-erro.mensagem      
                                                        + " " + trim(return-value)       
                                                        + " (" 
                                                        + bc-trans.cd-trans
                                                        + ")".
                    {utp/ut-liter.i Erro_Progress * L}                                   
                    assign tt-erro.mensagem =  tt-erro.mensagem      
                                                        + " - " + trim(return-value)       
                                                        + " (" 
                                                        + string(i-cod-erro)
                                                        + ")" + "(DC)":U.
                end.
            end.

            find first tt-erro-aux no-error.
            if  available(tt-erro-aux) then do:
                for each tt-erro-aux:
                    create tt-erro.
                    assign i-cont-erro      = i-cont-erro + 1.
                    assign tt-erro.i-sequen = i-cont-erro
                           tt-erro.cd-erro  = tt-erro-aux.cd-erro
                           tt-erro.mensagem = tt-erro-aux.mensagem + "(DC)":U.
                    
                    create bc-trans-erros.
                    assign i-cont-erro             = i-cont-erro + 1
                           bc-trans-erros.nr-trans  = tt-trans.nr-trans
                           bc-trans-erros.cd-msg    = tt-erro-aux.cd-erro
                           bc-trans-erros.texto-msg = tt-erro-aux.mensagem + "(DC)":U
                           bc-trans-erros.num-sequencial = i-cont-erro.
                end.
                
                    assign bc-trans.estado-trans     = 3
                           bc-trans.data-atualizacao = ?
                           bc-trans.hora-atualizacao = "".
                
            end.
        END.
        END. /* transaction */
    END.
    RETURN 'ok':U.
END PROCEDURE.

PROCEDURE verif_inicio_tarefa:
    DEF INPUT  PARAM TABLE FOR tt-trans.
    DEF INPUT  PARAM TABLE FOR tt-trans-filho. /* sempre ser  enviado um serial por vez */
    
    FIND FIRST tt-trans NO-LOCK NO-ERROR.
    IF AVAILABLE tt-trans THEN DO:
       if NOT can-find(first bc-trans NO-LOCK USE-INDEX bctrans-06
                       WHERE bc-trans.detalhe      = tt-trans.detalhe 
                         AND bc-trans.estado-trans = 4                
                         AND bc-trans.cd-trans     = 'WMEnt002':U)    THEN DO:
           RETURN 'NOK':U.
       END.
       ELSE DO:
           RETURN 'OK':U.
       END.
    END.
    RETURN 'NOK':U . /* NAO achou registro */
END PROCEDURE. 
&endif.
/* FIM */


