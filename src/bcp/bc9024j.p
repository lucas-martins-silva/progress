/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9024J 2.00.00.017 } /*** 010017 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9024j MBC}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/********************************************************************************
** Copyright DATASUL S.A. (2002)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
&if '{&mgscm_version}' >= '2.04' &then
/********************************************************************************************
**   Programa..: bc9024j.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - novembro/2002 - karla Klemke                                **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Picking WMS - Fun‡äes            **
**                                                                                         **
********************************************************************************************/
{cdp/cd0666.i}      /* Definicao da temp-table de erros         */
{bcp/bcapi001.i}    /* Definicao da temp-table de transacoes    */
{bcp/bc1000.i}      /* Procedure geraTTErro */
{include/i_dbtype.i}
{include/i_dbvers.i}
{bcp/bc9024.i }
DEFINE  TEMP-TABLE tt-erro-aux   NO-UNDO LIKE tt-erro.
DEF TEMP-TABLE ttWm-Etiqueta     NO-UNDO LIKE wm-etiqueta.
DEF TEMP-TABLE ttWm-Etiqueta-aux NO-UNDO LIKE wm-etiqueta
        FIELD RowNum AS INTEGER INIT 1
        FIELD r-Rowid AS ROWID.
    
/****************************************/
PROCEDURE pi-popula-temp-table-inventario:
/****************************************/

DEFINE INPUT  PARAMETER pcod-usuario    LIKE tt-inventario-wms.cod-usuario.
DEFINE INPUT  PARAMETER pcod-estabel    LIKE tt-inventario-wms.cod-estabel.
DEFINE INPUT  PARAMETER pcod-local      LIKE tt-inventario-wms.cod-local.
DEFINE INPUT  PARAMETER pdat-inventario LIKE tt-inventario-wms.dat-inventario.
DEFINE INPUT  PARAMETER pnum-contagem   LIKE tt-inventario-wms.num-contagem.
DEFINE INPUT  PARAMETER pnum-box        LIKE tt-inventario-wms.num-box.
DEFINE OUTPUT PARAMETER TABLE FOR tt-inventario-wms-bkp.

DEFINE        VARIABLE vdetalhe AS CHAR NO-UNDO.
DEFINE        VARIABLE vnum-sequencia AS INTEGER NO-UNDO.
    

    FOR EACH tt-inventario-wms-bkp:
        DELETE tt-inventario-wms-bkp.
    END.
    ASSIGN vdetalhe = 'Usr:':U  + pcod-usuario                 + ';':U +
                      'Est:':U  + pcod-estabel                 + ';':U +
                      'Loc:':U  + pcod-local                   + ';':U +
                      'DtI:':U  + string(pdat-inventario)      + ';':U +
                      'Con:':U  + string(pnum-contagem,'>9':U) + ';':U +
                      'Box:':U  + string(pnum-box,'>>>>>>>>>9':U).

    ASSIGN vnum-sequencia = 0.
    FOR FIRST bc-trans fields(bc-trans.nr-trans) USE-INDEX bctrans-06
        WHERE bc-trans.detalhe      = vdetalhe    
          AND bc-trans.estado-trans = 4 /* em processo */ 
          and bc-trans.cd-trans     = 'WMOut003':U 
          AND bc-trans.usuario      = pcod-usuario  NO-LOCK:
             FOR EACH bc-trans-filho WHERE
                 bc-trans-filho.nr-trans = bc-trans.nr-trans NO-LOCK:
                 CREATE tt-inventario-wms-bkp.
                 ASSIGN vnum-sequencia = vnum-sequencia + 1.    
                 ASSIGN
                       tt-inventario-wms-bkp.cod-usuario    =         entry(2,entry(1,vdetalhe,';':U),':':U)
                       tt-inventario-wms-bkp.cod-estabel    =         entry(2,entry(2,vdetalhe,';':U),':':U)
                       tt-inventario-wms-bkp.cod-local      =         ENTRY(2,ENTRY(3,vdetalhe,';':U),':':U)
                       tt-inventario-wms-bkp.dat-inventario = date(   ENTRY(2,ENTRY(4,vdetalhe,';':U),':':U))
                       tt-inventario-wms-bkp.num-contagem   = INTEGER(ENTRY(2,ENTRY(5,vdetalhe,';':U),':':U))
                       tt-inventario-wms-bkp.num-seq-invent = integer(entry(2,entry(1,bc-trans-filho.conteudo-trans,';':U),':':U))
                       tt-inventario-wms-bkp.num-box        = integer(entry(2,entry(2,bc-trans-filho.conteudo-trans,';':U),':':U)).
                 IF entry(2,entry(3,bc-trans-filho.conteudo-trans,';':U),':':U) =  'yes':U THEN ASSIGN tt-inventario-wms-bkp.log-existe-end = YES.
                 IF entry(2,entry(3,bc-trans-filho.conteudo-trans,';':U),':':U) =  'no':U THEN ASSIGN tt-inventario-wms-bkp.log-existe-end = NO. 

                 ASSIGN tt-inventario-wms-bkp.num-serial    = DECIMAL(entry(2,entry(4, bc-trans-filho.conteudo-trans,';':U),':':U))
                        tt-inventario-wms-bkp.qtd-item      = DECIMAL(entry(2,entry(5, bc-trans-filho.conteudo-trans,';':U),':':U))
                        tt-inventario-wms-bkp.cod-item      =         entry(2,entry(6, bc-trans-filho.conteudo-trans,';':U),':':U)
                        tt-inventario-wms-bkp.cod-lote      =         entry(2,entry(7, bc-trans-filho.conteudo-trans,';':U),':':U)
                        tt-inventario-wms-bkp.cod-refer     =         entry(2,entry(8, bc-trans-filho.conteudo-trans,';':U),':':U)
                        tt-inventario-wms-bkp.cod-embalagem =         ENTRY(2,ENTRY(9, bc-trans-filho.conteudo-trans,';':U),':':U)
                        tt-inventario-wms-bkp.dat-validade  =    DATE(entry(2,entry(10,bc-trans-filho.conteudo-trans,';':U),':':U))
                        tt-inventario-wms-bkp.qtd-peso      = DECIMAL(entry(2,entry(11,bc-trans-filho.conteudo-trans,';':U),':':U))
                        tt-inventario-wms-bkp.qtd-caixas    = DECIMAL(entry(2,entry(12,bc-trans-filho.conteudo-trans,';':U),':':U))
                        tt-inventario-wms-bkp.ind-transacao = INTEGER(entry(2,entry(13,bc-trans-filho.conteudo-trans,';':U),':':U))
                        tt-inventario-wms-bkp.num-sequencia = vnum-sequencia
                        tt-inventario-wms-bkp.nr-trans      = bc-trans.nr-trans.
             END.
    END.                
RETURN 'OK':U.

END PROCEDURE.

/**************************/
PROCEDURE pi-valida-serial:
/*************************/
DEFINE INPUT        PARAMETER pnum-box    LIKE tt-inventario-wms-bkp.num-box.
DEFINE INPUT        PARAMETER pnum-serial LIKE tt-inventario-wms-bkp.num-serial.
DEFINE INPUT        PARAMETER pcod-item   LIKE tt-inventario-wms-bkp.cod-item.
DEFINE INPUT        PARAMETER pcod-refer  LIKE tt-inventario-wms-bkp.cod-refer.
DEFINE INPUT        PARAMETER pcod-lote   LIKE tt-inventario-wms-bkp.cod-lote.
DEFINE INPUT        PARAMETER pcod-embalagem    LIKE tt-inventario-wms-bkp.cod-embalagem.
DEFINE INPUT        PARAMETER TABLE FOR tt-inventario-wms-bkp.

FIND FIRST tt-inventario-wms-bkp WHERE
           tt-inventario-wms-bkp.num-box    = pnum-box    AND
           tt-inventario-wms-bkp.num-serial = pnum-serial AND
           tt-inventario-wms-bkp.cod-item   = pcod-item   AND
           tt-inventario-wms-bkp.cod-refer  = pcod-refer  AND
           tt-inventario-wms-bkp.cod-lote   = pcod-lote   AND
           tt-inventario-wms-bkp.cod-embalagem = pcod-embalagem NO-LOCK NO-ERROR.
IF  AVAILABLE tt-inventario-wms-bkp THEN RETURN 'NOK':U.
IF NOT VALID-HANDLE(wgbosc074)  THEN DO:
    Run scbo/bosc074.p Persistent SET wgbosc074.
    Run openQueryStatic In wgbosc074 (Input "Main":U) No-error.
END.
Run emptyRowErrors In wgbosc074.
/* valida se o tipo serial, neste ponto o serial j  foi validado pela BOSC120 */
RUN getInfoEtiqueta IN wgbosc074 (INPUT pnum-serial,
                                  OUTPUT TABLE  ttwm-etiqueta).
FIND FIRST ttwm-etiqueta NO-LOCK NO-ERROR.
Run emptyRowErrors In wgbosc074.
IF AVAILABLE ttwm-etiqueta THEN DO:
    RUN getInfoAgrupador IN wgbosc074 (INPUT pnum-serial,
                                       OUTPUT TABLE  ttwm-etiqueta-aux).
    FOR EACH ttwm-etiqueta-aux:
         FIND FIRST tt-inventario-wms-bkp WHERE
                    tt-inventario-wms-bkp.num-serial = ttwm-etiqueta-aux.id-etiqueta AND
                    tt-inventario-wms-bkp.cod-item   = ttWm-etiqueta-aux.cod-item    AND
                    tt-inventario-wms-bkp.cod-refer  = ttWm-etiqueta-aux.cod-refer   AND
                    tt-inventario-wms-bkp.cod-lote   = ttWm-etiqueta-aux.cod-lote    AND
                    tt-inventario-wms-bkp.cod-embalagem = ttWm-etiqueta-aux.cod-embalagem NO-LOCK NO-ERROR.
         /* indica que algum serial do agrupador j  foi lido */
         IF  AVAILABLE tt-inventario-wms-bkp THEN RETURN 'NOK':U.
     end. 
END.

IF VALID-HANDLE(wgbosc074) THEN RUN destroy IN wgbosc074.

RETURN 'OK':U.
    
END PROCEDURE.

PROCEDURE finaliza-inventario:
    DEF INPUT  PARAM TABLE FOR tt-trans.
    DEF OUTPUT PARAM TABLE FOR tt-erro.

    DEF VAR vcontreg    AS INTEGER.
    DEF VAR vcont       AS INTEGER.
    DEF VAR i-cont-erro AS INTEGER.
    DEF VAR l-erro      AS LOGICAL.


        FOR EACH tt-erro:
            DELETE tt-erro.
        END.
        FOR EACH tt-trans:

             if  tt-trans.cod-versao-integracao <> 1 then do:
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
                     WHERE bc-trans.detalhe      = tt-trans.detalhe 
                       AND bc-trans.cd-trans     = 'WMOut003':U    
                       AND bc-trans.estado-trans = 4 EXCLUSIVE-LOCK NO-ERROR. 

                IF NOT AVAILABLE bc-trans THEN DO:
                    create tt-erro.
                    assign i-cont-erro = i-cont-erro + 1.
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-detalhe AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Detalhe" *}
                    ASSIGN c-lbl-liter-detalhe = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-inexistente AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Inexistente" *}
                    ASSIGN c-lbl-liter-inexistente = TRIM(RETURN-VALUE).
                    ASSIGN tt-erro.i-sequen = i-cont-erro
                           tt-erro.cd-erro  = 56
                           tt-erro.mensagem = c-lbl-liter-detalhe + ": " +  tt-trans.detalhe + " " + c-lbl-liter-inexistente + "(DC)".
                END.
                ELSE DO:
                    ASSIGN tt-trans.nr-trans = bc-trans.nr-trans.
                    
                    IF bc-trans.estado-trans  = 4 THEN DO:
                        ASSIGN bc-trans.estado-trans = 1. /** 1-Nova, 2-Atualizada, 3-Com Erro */ 
                        RELEASE BC-TRANS.
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
        RETURN 'ok':U.
END PROCEDURE.

PROCEDURE inventario-pre-api-wms:
    Define Input-output Parameter Table For tt-trans.
    Define INPUT-OUTPUT Parameter Table For tt-erro.

                            
DEF VARIABLE i-cont-erro AS INTEGER.
DEF VARIABLE i-cont      AS INTEGER.
DEF VARIABLE i-cod-erro  AS INTEGER.

    FOR EACH tt-trans:
        find first bc-tipo-trans
             where bc-tipo-trans.cd-trans = tt-trans.cd-trans
            no-lock no-error.                                
        
        DO TRANSACTION:

        FIND FIRST bc-trans USE-INDEX bctrans-06
             WHERE bc-trans.detalhe      = tt-trans.detalhe  
               AND bc-trans.cd-trans     = 'WMOut003':U      
               and bc-trans.estado-trans = 1 EXCLUSIVE-LOCK NO-ERROR. 

        IF AVAILABLE bc-trans THEN ASSIGN tt-trans.nr-trans = bc-trans.nr-trans.
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
                        run utp/ut-msgs.p ( input "msg",
                                            input 4,
                                            input return-value).
                        
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

                    {utp/ut-liter.i Transa‡Æo * L}       
                    assign tt-erro.mensagem     = tt-erro.mensagem      
                                                        + " " + trim(return-value)       
                                                        + " (" 
                                                        + bc-trans.cd-trans
                                                        + ")" + "(DC)":U.
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
                           tt-erro.mensagem = tt-erro-aux.mensagem.
                    create bc-trans-erro.
                    assign i-cont-erro             = i-cont-erro + 1
                           bc-trans-erro.nr-trans  = tt-trans.nr-trans
                           bc-trans-erro.cd-msg    = tt-erro-aux.cd-erro
                           bc-trans-erro.texto-msg = tt-erro-aux.mensagem + "(DC)":U
                           bc-trans-erro.num-sequencia = i-cont-erro.
                end.

                    assign bc-trans.estado-trans     = 3
                           bc-trans.data-atualizacao = ?
                           bc-trans.hora-atualizacao = "".

            end.
        END.
        ELSE DO:
            IF bc-trans.estado-trans   = 4 THEN DO:
                create tt-erro.
                assign i-cont-erro      = i-cont-erro + 1.
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Verifique_estado_desta_transa‡Æo_no_M¢dulo_DataCollection" *}
                assign tt-erro.i-sequen = i-cont-erro
                       tt-erro.cd-erro  = i-cont-erro
                       tt-erro.mensagem = RETURN-VALUE.
            END.
            IF bc-trans.estado-trans   = 1 
            and (   bc-tipo-trans.atualiza-on-line  = NO
            or bc-tipo-trans.imp-apos-trans    = NO) THEN DO:
                create tt-erro.
                assign i-cont-erro      = i-cont-erro + 1.
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Atualiza‡Æo_do_Invent rio_de_forma_BATCH" *}
                assign tt-erro.i-sequen = i-cont-erro
                       tt-erro.cd-erro  = i-cont-erro
                       tt-erro.mensagem = RETURN-VALUE.
            END.
        END.
        RELEASE bc-trans.
        END. /* transaction */
    END. /* for each */
    RETURN 'ok':U.
END PROCEDURE.

&else 
    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif
