/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9015F 2.00.00.004 } /*** "010004" 09/10/2025 11:26:31 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9015F MBC}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/


/* VERSAO DE INTEGRACAO */

&SCOPED-DEFINE Versao-Integracao 1
{cdp/cd0666.i}      /* Definicao da temp-table de erros         */
{bcp/bc1000.i}      /* Procedure geraTTErro */
{bcp/bcapi001.i}    /* Definicao da temp-table de transacoes    */
{bcp/bc9015.i}    

{include/i_dbtype.i}
{include/i_dbvers.i}

DEF VAR i-cont-erro AS INT.
def var l-erro      as logical init no.
def var i-cont      as integer no-undo.
def var i-cod-erro  as int.
DEF VAR v-seq-erro  AS INTEGER NO-UNDO.

def temp-table tt-erro-aux no-undo  like tt-erro.

&IF "{&mgcld_version}":U >= "2.02":U &THEN

PROCEDURE elimina_reg_wms:
    DEF VAR vcontreg AS INTEGER.

    DEF INPUT-OUTPUT PARAM TABLE FOR tt-trans.
    DEF INPUT-OUTPUT PARAM TABLE FOR tt-trans-filho.
    DEF INPUT-OUTPUT PARAM TABLE FOR tt-monta-cargas-bkp.
    DEF OUTPUT       PARAM vcont AS INTEGER.
    DEF INPUT-OUTPUT PARAM TABLE FOR tt-erro.

    DEF BUFFER b-bc-trans-filho FOR bc-trans-filho.

    FOR EACH tt-erro:
        DELETE tt-erro.
    END.

    FOR EACH tt-trans:
        ASSIGN vcont = 0.
        if  l-erro = yes then undo, next.

        DO TRANSACTION:
            FIND FIRST bc-trans WHERE bc-trans.nr-trans = tt-trans.nr-trans SHARE-LOCK NO-ERROR.

            IF NOT AVAILABLE bc-trans THEN DO:
                {utp/ut-field.i mgcld bc-trans cd-trans 1}
                run utp/ut-msgs.p (input "msg",
                                   input 56,
                                   input trim(return-value) + "(DC)":U ).
                create tt-erro.
                assign i-cont-erro = i-cont-erro + 1.
                ASSIGN tt-erro.i-sequen = i-cont-erro
                       tt-erro.cd-erro  = 56
                       tt-erro.mensagem =  RETURN-VALUE + "(DC)":U.
                undo, next.
            END.
            ELSE DO:
                ASSIGN vcont = INTEGER(ENTRY(2,bc-trans.des-observacao,';':U))
                       vcontreg = 0.

                FOR EACH tt-trans-filho:

                    FOR EACH bc-trans-filho WHERE 
                         bc-trans-filho.nr-trans = tt-trans.nr-trans NO-LOCK:

                        IF  bc-trans-filho.conteudo-trans <> TT-trans-filho.conteudo-xml THEN
                            NEXT.

                        FIND tt-monta-cargas-bkp WHERE tt-monta-cargas-bkp.num-serial = DECIMAL(entry(2,entry(2,bc-trans-filho.conteudo-trans, ';':U),':':U)) NO-LOCK NO-ERROR.
                        IF  AVAIL tt-monta-cargas-bkp THEN
                            DELETE tt-monta-cargas-bkp.
                        FIND b-bc-trans-filho WHERE ROWID(b-bc-trans-filho) = ROWID(bc-trans-filho) EXCLUSIVE-LOCK NO-ERROR.
                        DELETE b-bc-trans-filho.
                        DELETE tt-trans-filho.

                        ASSIGN vcont = vcont - 1
                               vcontreg = vcontreg + 1.
                    END.
                    /*ELSE DO:
                        create tt-erro.
                        assign i-cont-erro = i-cont-erro + 1.
                        ASSIGN tt-erro.i-sequen = i-cont-erro
                               tt-erro.cd-erro  = 56
                               tt-erro.mensagem = "Serial Inv†lido" + "(DC)":U.
                        undo, next.
                    END.*/
                END.
                
                if NOT can-find(first bc-trans-filho NO-LOCK
                    WHERE bc-trans-filho.nr-trans = bc-trans.nr-trans) then do:
                    DELETE bc-trans.
                    DELETE tt-trans.
                    ASSIGN vcont = 0.
                END.
                ELSE DO:
                    ASSIGN vcont = 0.
                    /* reordena a sequencia dos registros */
                    FOR EACH bc-trans-filho WHERE 
                        bc-trans-filho.nr-trans    = bc-trans.nr-trans AND
                        bc-trans-filho.conteudo-trans BEGINS bc-trans.detalhe EXCLUSIVE-LOCK:
                        ASSIGN vcont = vcont + 1.
                        ASSIGN bc-trans-filho.sequencia   = vcont.
                    END.
                END.
            END.
            IF AVAILABLE bc-trans THEN ASSIGN entry(2,bc-trans.des-observacao,';':U) = STRING(vcont).
        END.
    END.
    RETURN 'OK':U.
END PROCEDURE.

PROCEDURE fechamento_carga_wms:

    DEF VAR vcontreg AS INTEGER.
    DEF VAR vcont    AS INTEGER.

    DEF INPUT-OUTPUT PARAM TABLE FOR tt-trans.
    DEF INPUT-OUTPUT PARAM TABLE FOR tt-erro.

    FOR EACH tt-erro:
        DELETE tt-erro.
    END.
    FOR EACH tt-trans:
         ASSIGN l-erro = NO.
         
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
                    AND bc-trans.cd-trans     = tt-trans.cd-trans
                    AND bc-trans.usuario      = tt-trans.usuario EXCLUSIVE-LOCK NO-ERROR. 
             
            /* pode existir a situacao de um ponto ja ter sido fechado, neste caso pode-se utilizar o ponto em nova carga */
            IF NOT AVAILABLE bc-trans  THEN DO:
                FIND FIRST bc-trans USE-INDEX bctrans-06
                     WHERE bc-trans.estado-trans <> 4 
                       AND bc-trans.detalhe      = tt-trans.detalhe 
                       AND bc-trans.cd-trans     = tt-trans.cd-trans
                       AND bc-trans.usuario      = tt-trans.usuario EXCLUSIVE-LOCK NO-ERROR.
            END.
            
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
                                        input 27812,
                                        input trim(return-value)).
                     create tt-erro.
                     assign i-cont-erro = i-cont-erro + 1.
                     ASSIGN tt-erro.i-sequen = i-cont-erro
                            tt-erro.cd-erro  = 27812
                            tt-erro.mensagem = RETURN-VALUE + "(DC)":U.
                     ASSIGN l-erro = yes.
                END.
            END.
        END.
        if  l-erro = yes then undo, next.
    END.
    RETURN 'OK':U.
END PROCEDURE.
  
PROCEDURE fechamento_pre_api_wms:

    DEF INPUT-OUTPUT PARAM TABLE FOR tt-trans.
    DEF INPUT-OUTPUT PARAM TABLE FOR tt-erro.

    FOR EACH tt-trans:
        find first bc-tipo-trans
             where bc-tipo-trans.cd-trans = tt-trans.cd-trans no-lock no-error.                                
        DO TRANSACTION:

        IF tt-trans.nr-trans <> 0  THEN do:
            FIND FIRST bc-trans USE-INDEX bctrans-06
                 WHERE bc-trans.estado-trans = 4 
                   AND bc-trans.detalhe      = tt-trans.detalhe 
                   AND bc-trans.cd-trans     = tt-trans.cd-trans
                   AND bc-trans.usuario      = tt-trans.usuario EXCLUSIVE-LOCK NO-ERROR.
        END.
        ELSE DO:
            FIND FIRST bc-trans USE-INDEX bctrans-06
                 WHERE bc-trans.estado-trans <> 4 
                   AND bc-trans.detalhe      = tt-trans.detalhe 
                   AND bc-trans.cd-trans     = tt-trans.cd-trans
                   AND bc-trans.usuario      = tt-trans.usuario EXCLUSIVE-LOCK NO-ERROR.
        END.
        IF NOT AVAILABLE bc-trans THEN do:
            create tt-erro.
            assign i-cont-erro = i-cont-erro + 1.
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Inexistente" *}
            ASSIGN tt-erro.i-sequen = i-cont-erro
                   tt-erro.cd-erro  = 56
                   tt-erro.mensagem = tt-trans.detalhe + " " + RETURN-VALUE + "(DC)":U.
            UNDO, NEXT.
        END.
        IF tt-trans.nr-trans = 0 THEN ASSIGN tt-trans.nr-trans = bc-trans.nr-trans.
        if      bc-trans.estado-trans   = 1             /* estado da transaá∆o = 1-Nova  log-1 = yes (atualiza-on-line) */
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

                
                if  not tt-trans.etiqueta           /* tt-trans.etiqueta = <NO> - Gera Transaá∆o Movimento */
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
                                    bc-trans.hora-atualizacao = string(time,"HH:MM:SS").
                        
                    end.
                    else do:
                        run utp/ut-msgs.p ( input "msg",
                                            input 4,
                                            input return-value).

                        create tt-erro.
                        assign i-cont-erro = i-cont-erro + 1.
                        assign tt-erro.i-sequen = i-cont-erro
                               tt-erro.cd-erro  = 4
                               tt-erro.mensagem = RETURN-VALUE + "(DC)":U.
                    end.
                end.
            
                if  tt-trans.etiqueta               /* tt-trans.etiqueta = <YES> - Gera Transaá∆o Etiqueta */
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
                                    bc-trans.hora-atualizacao = string(time,"HH:MM:SS").
                        
                    end.
                    else do:
                        run utp/ut-msgs.p ( input "msg",
                                            input 4,
                                            input return-value).
                        create tt-erro.
                        assign i-cont-erro      = i-cont-erro + 1.
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
                
                    run utp/ut-msgs.p (input "msg",
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
                           tt-erro.mensagem = trim(return-value). 
                       
                    {utp/ut-liter.i Transaá∆o * L}       
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
                                                        + ")".
                end.
            end.

            find first tt-erro-aux NO-LOCK no-error.
            if  available(tt-erro-aux) then do:
                for each tt-erro-aux:
                    create tt-erro.
                    assign i-cont-erro      = i-cont-erro + 1.
                    assign tt-erro.i-sequen = i-cont-erro
                           tt-erro.cd-erro  = tt-erro-aux.cd-erro
                           tt-erro.mensagem = tt-erro-aux.mensagem.
                    
                    create bc-trans-erros.
                    assign i-cont-erro             = i-cont-erro + 1
                           bc-trans-erros.nr-trans  = tt-trans.nr-trans
                           bc-trans-erros.cd-msg    = tt-erro-aux.cd-erro
                           bc-trans-erros.texto-msg = tt-erro-aux.mensagem
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


PROCEDURE valida_serial_wms:

    DEF VARIABLE vnumserial-aux AS CHARACTER.

    DEF INPUT PARAM vnumserial AS CHAR.
    DEF INPUT PARAM TABLE FOR tt-trans.
    DEF INPUT-OUTPUT PARAM TABLE FOR tt-erro.

    FIND FIRST tt-trans NO-LOCK NO-ERROR.
    
    FOR EACH bc-trans WHERE
        bc-trans.estado-trans = 4 /* em processo */  AND
        bc-trans.cd-trans     = 'WMEnt001':U NO-LOCK:

        ASSIGN vnumserial-aux = 'Ser:':U + vnumserial.

        if can-find(first bc-trans-filho NO-LOCK
                   WHERE  bc-trans-filho.nr-trans = bc-trans.nr-trans AND
                          entry(2,bc-trans-filho.conteudo-trans, ';':U) = trim(vnumserial-aux)) then do:
                   /* via compile xref o indice acima a ser utilizado ser† ch-bc-trans-filho */
            create tt-erro.
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Serial_j†_esta_em_uma_carga" *}
            ASSIGN tt-erro.i-sequen = 1
                   tt-erro.cd-erro  = 999
                   tt-erro.mensagem = RETURN-VALUE + '(DC)':U
                   l-erro = yes.
          RETURN 'NOK':U.
        END.

        RETURN 'OK':U.
    END.
    RETURN 'OK':U.
END PROCEDURE.              

PROCEDURE popula-temp-table-serial:
/* procedure respons†vel em popular tem-table para validaá‰es e apresentar a qtd de itens lidos  */  
DEFINE input        PARAM p-tipo-trans AS INTEGER FORMAT '9' NO-UNDO.
DEFINE INPUT        PARAM p-ponto As Integer Format '9' NO-UNDO. 
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-monta-cargas-bkp.
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-erro. 
DEFINE OUTPUT       PARAM vcarganova AS LOGICAL NO-UNDO.
DEFINE OUTPUT       PARAM vnumitens AS Integer Format '999' NO-UNDO. 
                                                                                                                          
    FOR EACH tt-monta-cargas-bkp:
        DELETE tt-monta-cargas-bkp.
    END.
    FOR EACH tt-erro:
        DELETE tt-erro.
    END.
    find FIRST bc-trans USE-INDEX bctrans-06
         WHERE bc-trans.estado-trans = 4
           AND bc-trans.detalhe = ('Pto:':U + string(p-ponto,'9':U)) 
           AND bc-trans.cd-trans = 'WMEnt001':U       no-lock no-error.
    IF AVAILABLE bc-trans THEN  do:
       ASSIGN vcarganova = NO.
       ASSIGN vnumitens = INTEGER(ENTRY(2,bc-trans.des-observacao,";")). 
       IF p-tipo-trans <> 3 THEN DO:
          FOR EACH bc-trans-filho WHERE
              bc-trans-filho.nr-trans = bc-trans.nr-trans NO-LOCK:
              FIND FIRST tt-monta-cargas-bkp
                  WHERE tt-monta-cargas-bkp.num-serial = DECIMAL(entry(2,entry(2,bc-trans-filho.conteudo-trans, ';':U),':':U)) NO-LOCK NO-ERROR.
              IF  NOT AVAIL tt-monta-cargas-bkp THEN DO:
                CREATE tt-monta-cargas-bkp.
                ASSIGN tt-monta-cargas-bkp.num-ponto   = p-ponto
                         tt-monta-cargas-bkp.num-serial  = DECIMAL(entry(2,entry(2,bc-trans-filho.conteudo-trans, ';':U),':':U))
                         tt-monta-cargas-bkp.nr-trans    = bc-trans-filho.nr-trans.
              END.
           END.
        END.
        ELSE DO:
             FIND FIRST tt-monta-cargas-bkp
                WHERE tt-monta-cargas-bkp.num-serial  = 999999 /* indicativo de termino */ NO-LOCK NO-ERROR.
            IF  NOT AVAIL tt-monta-cargas-bkp THEN DO:
                CREATE tt-monta-cargas-bkp.
                ASSIGN tt-monta-cargas-bkp.num-ponto   = p-ponto
                       tt-monta-cargas-bkp.num-serial  = 999999 /* indicativo de termino */
                       tt-monta-cargas-bkp.nr-trans    = bc-trans.nr-trans.
            END.
        END.
    END.
    ELSE DO:
        ASSIGN vcarganova = YES. /* n∆o achou nenhuma carga aberta */
    END.

END PROCEDURE.


&endif.
/* FIM */





