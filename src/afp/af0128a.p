/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0128A 2.00.00.013 } /*** "010013" 23/01/2026 15:37:36 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i af0128a MAF}
&ENDIF

/******************************************************************************
**
**  Programa : af0128a.p
**  Objetivo.: Atualiza?Æo de Pagamento Aprovado
**
**                Compilado EMS 2
**
******************************************************************************/

{utp/ut-glob.i}
{btb/btb009za.i}

def new global shared var v_cod_dwb_user 
    as character 
    format "x(21)":U 
    no-undo. 
def var v_hdl_prog 
    as Handle 
    format ">>>>>>9":U 
    no-undo. 
def new global shared var v_cod_empres_usuar 
    as character 
    format "x(3)":U 
    no-undo. 
def new global shared var v_cod_idiom_usuar 
    as character 
    format "x(8)":U 
    no-undo. 
def new global shared var v_cod_usuar_corren 
    as character 
    format "x(12)":U 
    no-undo. 
def new global shared var v_cod_usuar_corren_criptog 
    as character 
    format "x(16)":U 
    no-undo. 
def new global shared var v5_cod_usuar_corren 
    as character 
    format 'x(12)' 
    no-undo. 
def new global shared var v5_cod_empres_usuar 
    as character 
    format 'x(3)' 
    no-undo. 
def new global shared var v_cod_estab_usuar 
    as character 
    format 'x(3)' 
    no-undo. 
def new global shared var v5_cod_estab_usuar 
    as character 
    format 'x(3)' 
    no-undo. 
def new global shared var v5_cod_idiom_usuar 
    as character 
    format 'x(8)' 
    no-undo. 
def new global shared var v5_cod_pais_empres_usuar 
    as character 
    format 'x(3)' 
    no-undo. 
def new global shared var v5_cod_usuar_corren_criptog 
    as character 
    format 'x(16)' 
    no-undo. 
def new global shared var v5_cod_grp_usuar_lst  
    as character  
    no-undo. 
def new global shared var v_cod_pais_empres_usuar 
    as character 
    format "x(3)":U 
    no-undo. 
DEF STREAM s_1.
DEF VAR ep-codigo-local LIKE empresa.ep-codigo NO-UNDO.
DEF VAR c-error         AS CHAR INITIAL "" NO-UNDO.
def var c-chave-refer   as char            no-undo.
def VAR v-posicao-ini   as int extent 10 no-undo.
def VAR v-posicao-fim   as int extent 10 no-undo.

OUTPUT STREAM s_1 TO value(SESSION:TEMP-DIRECTORY + "AF0128A" + "-" + v_cod_usuar_corren + "-" + STRING(today,"99999999") + ".txt") CONVERT TARGET 'iso8859-1' append.

DEFINE VARIABLE c-lbl-liter-pendenc-pendent-com AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lbl-liter-finaliz-proc-atuali AS CHARACTER NO-UNDO.
/* Para n?o pedir senha novamente quando o programa for chamado pelo EMS2 */ 
assign v5_cod_usuar_corren         = v_cod_usuar_corren 
       v5_cod_empres_usuar         = v_cod_empres_usuar 
       /*v5_cod_estab_usuar          = '999' */
       v5_cod_idiom_usuar          = v_cod_idiom_usuar 
       v5_cod_pais_empres_usuar    = v_cod_pais_empres_usuar 
       v5_cod_usuar_corren_criptog = v_cod_usuar_corren_criptog 
       v5_cod_grp_usuar_lst        = v_cod_grp_usuar_lst. 

def var h-btb009za as handle no-undo.

/*** Defini‡Æo da tt-log-erros-atualiz ***/
{afp/af0024.i}

def input parameter p-rowid-aed-doc-pend-aprov as rowid no-undo.
def input parameter p-cod-usuar-aprov          as char  no-undo.
def input parameter p-gera-proxima-pend        as logic no-undo.
DEF INPUT-OUTPUT PARAMETER TABLE FOR tt-log-erros-atualiz.

&IF  "{&mginv_version}" >= "2.06B" &THEN

def buffer b-mla-doc-pend-aprov for mla-doc-pend-aprov.

{afp/af0124a.i}

/* Inicio -- Projeto Internacional */
{utp/ut-liter.i "Iniciando_Processo_Atualiza‡Æo" *}
PUT STREAM s_1 UNFORMATTED RETURN-VALUE + " - " string(TODAY,"99/99/9999") " " STRING(TIME,"HH:MM:SS") SKIP.

run afp/af0701.p (input 28,
                  output v-posicao-ini,
                  output v-posicao-fim).

find first mla-doc-pend-aprov NO-LOCK
    WHERE rowid(mla-doc-pend-aprov) = p-rowid-aed-doc-pend-aprov no-error.
IF  AVAIL mla-doc-pend-aprov THEN DO:

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Docto_em_aprova?Æo" *}
    PUT STREAM s_1 UNFORMATTED 
        RETURN-VALUE + ":   " mla-doc-pend-aprov.cod-tip-doc " | " mla-doc-pend-aprov.chave-doc " | " mla-doc-pend-aprov.ind-situacao " | " mla-doc-pend-aprov.historico SKIP.

    assign c-chave-refer = string(substring(mla-doc-pend-aprov.chave-doc, v-posicao-ini[1], v-posicao-fim[1] - v-posicao-ini[1] + 1))
                         + string(substring(mla-doc-pend-aprov.chave-doc, v-posicao-ini[2], v-posicao-fim[2] - v-posicao-ini[2] + 1))
                         + string(substring(mla-doc-pend-aprov.chave-doc, v-posicao-ini[3], v-posicao-fim[3] - v-posicao-ini[3] + 1)).
    
    /*Inclu¡do este for each porque o sistema por algum motivo nÆo encontrava o ***
      Documento pendente no find first abaixo. */

	/*DMANAPB1-6579 - Alteração de performance, apenas dar for each na tabela caso o find falhe*/
	/*for each b-mla-doc-pend-aprov no-lock
		WHERE b-mla-doc-pend-aprov.ep-codigo  = mla-doc-pend-aprov.ep-codigo
		AND b-mla-doc-pend-aprov.cod-estabel  = mla-doc-pend-aprov.cod-estabel
		AND b-mla-doc-pend-aprov.cod-tip-doc  = 28
		AND b-mla-doc-pend-aprov.chave-doc    begins c-chave-refer:
	end.*/
	
	/* Verifica se todas as apropriacoes para o documento foram aprovadas\reaprovadas */
    find first b-mla-doc-pend-aprov no-lock
         where b-mla-doc-pend-aprov.ep-codigo    = mla-doc-pend-aprov.ep-codigo
           and b-mla-doc-pend-aprov.cod-estabel  = mla-doc-pend-aprov.cod-estabel
           and b-mla-doc-pend-aprov.cod-tip-doc  = 28
           and b-mla-doc-pend-aprov.chave-doc    begins c-chave-refer
           and (b-mla-doc-pend-aprov.ind-situacao = 1 
             OR b-mla-doc-pend-aprov.ind-situacao = 3) /* diferente de Aprovado (2) e Reaprovado(4) */
           and b-mla-doc-pend-aprov.historico    = no 
		   and b-mla-doc-pend-aprov.nr-trans     <> mla-doc-pend-aprov.nr-trans
           /*and rowid(b-mla-doc-pend-aprov)     <> p-rowid-aed-doc-pend-aprov*/ no-error.
    IF AVAIL b-mla-doc-pend-aprov THEN DO:
        /* Inicio -- Projeto Internacional */
        
        {utp/ut-liter.i "Pendˆncia_pendente_com" *}
        ASSIGN c-lbl-liter-pendenc-pendent-com = TRIM(RETURN-VALUE).
        {utp/ut-liter.i "Finalizando_Processo_Atualiza‡Æo" *}
        ASSIGN c-lbl-liter-finaliz-proc-atuali = TRIM(RETURN-VALUE).

        PUT STREAM s_1  UNFORMATTED 
            c-lbl-liter-pendenc-pendent-com + " " b-mla-doc-pend-aprov.cod-usuar " | " STRING(mla-doc-pend-aprov.chave-doc) SKIP
            c-lbl-liter-finaliz-proc-atuali skip(2).

        OUTPUT STREAM s_1 CLOSE.
        RETURN.
    END.
    else /* Inicio -- Projeto Internacional */
    DO:
     {utp/ut-liter.i "éltima_pendˆncia_da_referˆncia_|" *}
     PUT STREAM s_1  UNFORMATTED RETURN-VALUE + " " STRING(mla-doc-pend-aprov.chave-doc) SKIP.
    END. 

    ASSIGN ep-codigo-local = mla-doc-pend-aprov.ep-codigo.
    
    create tt-aed-chave-aprov.
    assign tt-aed-chave-aprov.valor[1] = trim(string(substring(mla-doc-pend-aprov.chave-doc, v-posicao-ini[1], v-posicao-fim[1] - v-posicao-ini[1] + 1)))
           tt-aed-chave-aprov.valor[2] = trim(string(substring(mla-doc-pend-aprov.chave-doc, v-posicao-ini[2], v-posicao-fim[2] - v-posicao-ini[2] + 1)))
           tt-aed-chave-aprov.valor[3] = trim(string(substring(mla-doc-pend-aprov.chave-doc, v-posicao-ini[3], v-posicao-fim[3] - v-posicao-ini[3] + 1)))
           tt-aed-chave-aprov.valor[4] = if mla-doc-pend-aprov.ind-situacao = 2 then 
                                            string(mla-doc-pend-aprov.dt-aprova) 
                                         else 
                                            string(mla-doc-pend-aprov.dt-reaprova)
           tt-aed-chave-aprov.valor[5] = if mla-doc-pend-aprov.cod-usuar-altern <> '' then string(mla-doc-pend-aprov.cod-usuar-altern) else string(mla-doc-pend-aprov.cod-usuar).

    RUN pi-limpa-return.

    RUN pi-conectar-bco.
    IF  RETURN-VALUE = "NOK" THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Erro_ConexÆo_dos_Bancos" *}
        PUT STREAM s_1  UNFORMATTED RETURN-VALUE  SKIP(2).
        OUTPUT STREAM s_1 CLOSE.
        RETURN "NOK".
    END.
        
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Iniciando_atualiza‡Æo_do_processo_de_pagamento" *}
    PUT STREAM s_1  UNFORMATTED 
        RETURN-VALUE + "." SKIP.
    RUN prgfin/apf/apf720za.py (input table tt-aed-chave-aprov,
                                INPUT-OUTPUT TABLE tt-log-erros-atualiz).
    
    ASSIGN c-error = RETURN-VALUE.
    IF c-error = "NOK" THEN 
        /* Inicio -- Projeto Internacional */
        DO:
        {utp/ut-liter.i "Erro_atualiza‡Æo_do_processo_de_pagamento" *}
        PUT STREAM s_1  UNFORMATTED RETURN-VALUE + "."  SKIP.
        END. 

    RUN pi-tratar-desconexao-bancos IN THIS-PROCEDURE (INPUT h-btb009za).
    
    ASSIGN v_cod_empres_usuar = v5_cod_empres_usuar
           v5_cod_estab_usuar = v_cod_estab_usuar.

    IF  RETURN-VALUE = "NOK" OR
        c-error      = "NOK" THEN DO:
        IF RETURN-VALUE = "NOK" THEN
            /* Inicio -- Projeto Internacional */
            DO:
            {utp/ut-liter.i "Erro_Desconexao_Bancos" *}
            PUT STREAM s_1  UNFORMATTED RETURN-VALUE + " "  SKIP(2).
            END. 
        OUTPUT STREAM s_1 CLOSE.
        RETURN "NOK".
    END.

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Finalizando_Processo_Atualiza‡Æo" *}
    PUT STREAM s_1 UNFORMATTED RETURN-VALUE + " - " string(TODAY,"99/99/9999") " " STRING(TIME,"HH:MM:SS") SKIP(2).
    OUTPUT STREAM s_1 CLOSE.
END.

PROCEDURE pi-conectar-bco:
    /****************************************************************************************************
    BEG - Tecnologia:
    Executa o programa de conex?o de bancos externos somente se o mesmo n?o estiver na mem«ria,
    ou seja, se o mesmo ainda n?o foi executado. E tambým se os bancos do EMS 5 ainda n?o estiverem
    conectado.
    ****************************************************************************************************/
    IF  (       NOT VALID-HANDLE(h-btb009za)
                OR  h-btb009za:TYPE <> "procedure":U
                OR  h-btb009za:FILE-NAME <> "btb/btb009za.p")
    AND (       NOT CONNECTED('emsbas':U)
                OR  NOT CONNECTED('emsuni':U)
                OR  NOT CONNECTED('emsfin':U))  THEN DO:

        PUT STREAM s_1  UNFORMATTED "pi-conecta-bco"  SKIP.

        RUN btb/btb009za.p PERSISTENT SET h-btb009za.

        RUN pi-limpa-return.

        RUN pi-conecta-bco IN h-btb009za (  INPUT 1,
                                            INPUT 1, /* Conecta o DB */
                                            INPUT ep-codigo-local, /* empresa */
                                            INPUT "all",
                                            OUTPUT TABLE tt_erros_conexao).

        IF  RETURN-VALUE <> "OK" THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "PI_conexÆo_retorno_NOK" *}
            PUT STREAM s_1  UNFORMATTED RETURN-VALUE  SKIP.
            run utp/ut0666.w (input table tt_erros_conexao).
            RUN pi-tratar-desconexao-bancos IN THIS-PROCEDURE (INPUT h-btb009za).
            return "NOK".
        end.
    END.
    /****************************************************************************************************
    END - Tecnologia:
    ****************************************************************************************************/
END.

/*****************************************************************************************************************************************/
PROCEDURE pi-desconeta-base:
    DEFINE INPUT PARAMETER h-btb009za  AS HANDLE.

    RUN pi-limpa-return.

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Desconectando" *}
    PUT STREAM s_1  UNFORMATTED RETURN-VALUE  SKIP.
    run pi-conecta-bco in h-btb009za (INPUT 1,
                                      INPUT 2, /* Desconecta o DB */
                                      INPUT ep-codigo-local, /* empresa */ 
                                      INPUT "all",
                                      OUTPUT Table tt_erros_conexao).

END PROCEDURE.

/*****************************************************************************************************************************************/
PROCEDURE pi-tratar-desconexao-bancos:
    DEFINE INPUT PARAMETER h-btb009za  AS HANDLE. 

    IF  VALID-HANDLE(h-btb009za)
    AND h-btb009za:TYPE = "procedure":U
    AND h-btb009za:FILE-NAME = "btb/btb009za.p"
    THEN do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Trata_DesconexÆo" *}
        PUT STREAM s_1  UNFORMATTED RETURN-VALUE  SKIP.
        RUN pi-desconeta-base IN THIS-PROCEDURE (INPUT h-btb009za).
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "apagando_handle" *}
        PUT STREAM s_1  UNFORMATTED RETURN-VALUE  SKIP.
        DELETE PROCEDURE h-btb009za.
    end.


END PROCEDURE.

PROCEDURE pi-limpa-return:
    RETURN "OK".
END.
&endif
