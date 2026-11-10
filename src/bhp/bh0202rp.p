/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BH0202RP 2.00.00.008 } /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i Bh0202rp MBH}
&ENDIF


/*******************************************************************************
**
**  Programa: BH0202RP.P - Transferˆncia de Banco Hist¢rico - Distribui‡Æo
**
*******************************************************************************/

{cdp/cdcfgdis.i}
{include/i_dbvers.i} 
{include/i_prdvers.i} 

&IF "{&bf_dis_versao_ems}" >= "2.08" &THEN

    DEFINE TEMP-TABLE ttErrosConexao NO-UNDO
        FIELD i-sequen  AS INTEGER
        FIELD cd-erro   AS INTEGER
        FIELD mensagem  AS CHARACTER FORMAT "x(255)".

&ENDIF

/* ========================= Temp-Table Definitions ========================= */
define temp-table tt-raw-digita 
    field raw-digita as raw.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char    format "x(35)"
    field usuario          as char    format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field da-per-corte     as date    format 99/99/9999
    field ano-of           as integer format 9999
    field l-pedfat         as logical
    field l-estat          as logical
    field l-of             as logical
    field l-cotacao        as logical. 

{bhp/bh9800.i1} 


/* ============================ Input Parameters ============================ */
define input parameter raw-param as raw no-undo.
define input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.


/* ========================== Variable Definitions ========================== */
define new shared variable h-acomp as handle no-undo.

{include/i-rpvar.i}


/* =============================== Main Block =============================== */

/* ------------------------ Inicializa Acompanhamento ----------------------- */
run utp/ut-acomp.p persistent set h-acomp.

{utp/ut-liter.i Bancos_Hist¢ricos *}
run pi-inicializar in h-acomp (input Return-value).
run pi-seta-tipo   in h-acomp (input 1).


FOR FIRST param-global NO-LOCK:
END.


/* ---------------- Conecta Base de Dados - Bancos Hist¢ricos --------------- */
{utp/ut-liter.i Conectando_Banco_Hist¢rico_-_Distribui‡Æo}.
run pi-acompanhar in h-acomp (input trim(return-value)).

&IF "{&bf_dis_versao_ems}" < "2.08" &THEN

    for each tt-param-bh: delete tt-param-bh. end.
    
    create tt-param-bh.
    assign tt-param-bh.banco                 = "hisdis"
           tt-param-bh.tp-banco              = 2
           tt-param-bh.cod-versao-integracao = 1.
    
    run bhp/bh9800.p ( input table tt-param-bh,
                      output table tt-erro).
    
    if  return-value = "NOK" then do:
        find first tt-erro no-error.
        if  avail tt-erro then do:
            {include/i-rpout.i}
            disp tt-erro.mensagem format "x(60)" no-label with stream-io.
            {include/i-rpclo.i}
        end.
        run pi-finalizar in h-acomp.
        return "NOK".
    end.

    /*----- Conecta Banco Hist¢rico HISADM -----*/
    if tt-param.l-pedfat then do:

        {utp/ut-liter.i Conectando_Banco_Hist¢rico_-_Administra‡Æo}.
        run pi-acompanhar in h-acomp (input trim(return-value)).

        for each tt-param-bh: delete tt-param-bh. end.

        create tt-param-bh.
        assign tt-param-bh.banco                 = "hisadm"
               tt-param-bh.cod-versao-integracao = 1.

        run bhp/bh9800.p (input table tt-param-bh,
                          output table tt-erro).

        if return-value = "NOK" then do:
            find first tt-erro no-error.
            if avail tt-erro then do:
                {include/i-rpout.i}
                disp tt-erro.mensagem format "x(60)" no-label with stream-io.
                {include/i-rpclo.i}
            end.
            run pi-finalizar in h-acomp.
            return "NOK".
        end.
    end.

&ELSE

    RUN btb/btb962za.p (INPUT param-global.empresa-prin,
                        INPUT param-global.empresa-prin,
                        INPUT 3,  /* 1-Login, 2-Consultar, 3-Transferir */
                        INPUT 1,  /* Se a op‡Æo for Transferir, ‚ poss¡vel: 1-Conectar ou 2-Desconectar */
                        INPUT "",
                        OUTPUT TABLE ttErrosConexao).
    
    IF CAN-FIND(FIRST ttErrosConexao) THEN DO:
    
        {include/i-rpout.i}
    
        FOR EACH ttErrosConexao:
            disp ttErrosConexao.mensagem format "x(60)" no-label with stream-io.
        END.
    
        {include/i-rpclo.i}
    
        run pi-finalizar in h-acomp.
        return "NOK".
    
    END.

&ENDIF


/* ------------------------ Finaliza Acompanhamento ------------------------- */
run pi-finalizar in h-acomp.


/* ------------------ Importa Dados do HisDis para o MovDis ----------------- */
run bhp/bh0202a.p (input raw-param).


/* ------------------------ Inicializa Acompanhamento ----------------------- */
run utp/ut-acomp.p persistent set h-acomp.

{utp/ut-liter.i Bancos_Hist¢ricos *}
run pi-inicializar in h-acomp (input Return-value).
run pi-seta-tipo   in h-acomp (input 1).


/* --------------- Desconecta Base de Dados - Bancos Hist¢ricos ------------- */
{utp/ut-liter.i Desconectando_Banco_Hist¢rico_-_Distribui‡Æo}.
run pi-acompanhar in h-acomp (input trim(return-value)).

&IF "{&bf_dis_versao_ems}" < "2.08" &THEN

    run bhp/bh9810.p (input "hisdis").

    if tt-param.l-pedfat then do:
        {utp/ut-liter.i Desconectando_Banco_Hist¢rico_-_Administra‡Æo}.
        run pi-acompanhar in h-acomp (input trim(return-value)).

        run bhp/bh9810.p (input "hisadm").
    end.

&ELSE

    RUN btb/btb962za.p (INPUT param-global.empresa-prin,
                        INPUT param-global.empresa-prin,
                        INPUT 3,  /* 1-Login, 2-Consultar, 3-Transferir */
                        INPUT 2,  /* Se a op‡Æo for Transferir, ‚ poss¡vel: 1-Conectar ou 2-Desconectar */
                        INPUT "",
                        OUTPUT TABLE ttErrosConexao).
    

&ENDIF


/* ------------------------ Finaliza Acompanhamento ------------------------- */
run pi-finalizar in h-acomp.
