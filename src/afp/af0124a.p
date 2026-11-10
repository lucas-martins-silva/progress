/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0124A 2.00.00.023 } /*** "010023" 03/11/2026 17:57:13 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i af0124a MAF}
&ENDIF

/******************************************************************************
**
**  Programa : af0124a.p
**  Objetivo.: Atualiza‡Æo Documento Normal - APROVADO - Tipo Docto 24
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
DEF VAR c-error         AS CHAR INITIAL "" NO-UNDO.
def var c-chave-refer   as char            no-undo.
DEF VAR ep-codigo-local LIKE empresa.ep-codigo NO-UNDO.
DEF VAR c-cod-estabel   LIKE estabelec.cod-estabel NO-UNDO.
def VAR v-posicao-ini   as int extent 10 no-undo.
def VAR v-posicao-fim   as int extent 10 no-undo.
DEFINE VARIABLE c-lbl-liter-pendenc-pendent-com AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lbl-liter-finaliz-proc-atuali AS CHARACTER NO-UNDO.

{afp/af0124a.i}
/*** Defini‡Æo da tt-log-erros-atualiz ***/
{afp/af0024.i}

DEF VAR i-empresa       like empresa.ep-codigo. 
OUTPUT STREAM s_1 TO value(SESSION:TEMP-DIRECTORY + "AF0124A" + "-" + v_cod_usuar_corren + "-" + STRING(today,"99999999") + ".txt") CONVERT TARGET 'iso8859-1' append.
/* Para n?o pedir senha novamente quando o programa for chamado pelo EMS2 */ 
/*assign v5_cod_usuar_corren         = v_cod_usuar_corren 
       v5_cod_empres_usuar         = v_cod_empres_usuar 
       v5_cod_estab_usuar          = '999' 
       v5_cod_idiom_usuar          = v_cod_idiom_usuar 
       v5_cod_pais_empres_usuar    = v_cod_pais_empres_usuar 
       v5_cod_usuar_corren_criptog = v_cod_usuar_corren_criptog 
       v5_cod_grp_usuar_lst        = v_cod_grp_usuar_lst. */

def var h-btb009za as handle no-undo.

def input parameter p-rowid-aed-doc-pend-aprov as rowid no-undo.
def input parameter p-cod-usuar-aprov          as char  no-undo.
def input parameter p-gera-proxima-pend        as logic no-undo.
DEF INPUT-OUTPUT PARAMETER TABLE FOR tt-log-erros-atualiz.

&IF  "{&mginv_version}" >= "2.06B" &THEN

def buffer b-mla-doc-pend-aprov for mla-doc-pend-aprov.

run afp/af0701.p (input 24,
                  output v-posicao-ini,
                  output v-posicao-fim).

/* Inicio -- Projeto Internacional */
{utp/ut-liter.i "Iniciando_Processo_Atualiza‡Æo" *}
PUT STREAM s_1 UNFORMATTED RETURN-VALUE + " - " string(TODAY,"99/99/9999") " " STRING(TIME,"HH:MM:SS")  SKIP.

find first mla-doc-pend-aprov NO-LOCK
    WHERE rowid(mla-doc-pend-aprov) = p-rowid-aed-doc-pend-aprov no-error.
IF  AVAIL mla-doc-pend-aprov THEN DO:

    ASSIGN c-cod-estabel = trim(string(substring(mla-doc-pend-aprov.chave-doc, v-posicao-ini[1], v-posicao-fim[1] - v-posicao-ini[1] + 1))).
    
    FIND estabelec WHERE
         estabelec.cod-estabel = c-cod-estabel
         NO-LOCK NO-ERROR.

    IF AVAIL estabelec THEN
       run cdp/cd9970.p (input  ROWID(estabelec),
                         output i-empresa).

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Docto_em_aprova‡Æo" *}
    PUT STREAM s_1 UNFORMATTED 
    RETURN-VALUE + ":   " mla-doc-pend-aprov.cod-tip-doc " | " mla-doc-pend-aprov.chave-doc " | " mla-doc-pend-aprov.ind-situacao " | " mla-doc-pend-aprov.historico SKIP.
    
    assign c-chave-refer = string(substring(mla-doc-pend-aprov.chave-doc, v-posicao-ini[1], v-posicao-fim[1] - v-posicao-ini[1] + 1))
                         + string(substring(mla-doc-pend-aprov.chave-doc, v-posicao-ini[2], v-posicao-fim[2] - v-posicao-ini[2] + 1))
                         + string(substring(mla-doc-pend-aprov.chave-doc, v-posicao-ini[3], v-posicao-fim[3] - v-posicao-ini[3] + 1)).

    /* retirado devido a performance 
    /*Inclu¡do este for each porque o sistema por algum motivo nÆo encontrava o ***
      Documento pendente no find first abaixo. */
    for each b-mla-doc-pend-aprov exclusive-lock
       where b-mla-doc-pend-aprov.ep-codigo    = mla-doc-pend-aprov.ep-codigo   
         and b-mla-doc-pend-aprov.cod-estabel  = mla-doc-pend-aprov.cod-estabel 
         and b-mla-doc-pend-aprov.cod-tip-doc  = mla-doc-pend-aprov.cod-tip-doc
         and b-mla-doc-pend-aprov.chave-doc    = mla-doc-pend-aprov.chave-doc:
    end.*/

	/* Verifica se todas as apropriacoes para o documento foram aprovadas\reaprovadas */
    RELEASE b-mla-doc-pend-aprov.
    
    find first b-mla-doc-pend-aprov no-lock
         where b-mla-doc-pend-aprov.ep-codigo    = mla-doc-pend-aprov.ep-codigo   
           and b-mla-doc-pend-aprov.cod-estabel  = mla-doc-pend-aprov.cod-estabel 
           and b-mla-doc-pend-aprov.cod-tip-doc  = mla-doc-pend-aprov.cod-tip-doc 
           and b-mla-doc-pend-aprov.chave-doc    = mla-doc-pend-aprov.chave-doc   
           and (b-mla-doc-pend-aprov.ind-situacao = 1 
            or b-mla-doc-pend-aprov.ind-situacao = 3)
           and b-mla-doc-pend-aprov.historico    = no no-error.

    if avail b-mla-doc-pend-aprov then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Pendˆncia_pendente_com" *}
        assign c-lbl-liter-pendenc-pendent-com = trim(return-value).
        {utp/ut-liter.i "Finalizando_Processo_Atualiza‡Æo" *}
        assign c-lbl-liter-finaliz-proc-atuali = trim(return-value).
        put stream s_1 unformatted 
            c-lbl-liter-pendenc-pendent-com + " " b-mla-doc-pend-aprov.cod-usuar " | " string(mla-doc-pend-aprov.chave-doc) skip
            c-lbl-liter-finaliz-proc-atuali skip(2).
        output stream s_1 close.
        return.
    end.
    else do:

        /*  Verifica se existe alguma outra pendˆncia relacionada ao lote de implanta‡Æo no EMS5 (originador da pendˆncia) a ser aprovada.
            Caso haja, bloquear integra‡Æo at‚ que todas as pendˆncias sejam aprovadas. */
        find first b-mla-doc-pend-aprov use-index pend-2 no-lock
            where b-mla-doc-pend-aprov.ep-codigo      = mla-doc-pend-aprov.ep-codigo
              and b-mla-doc-pend-aprov.cod-estabel    = mla-doc-pend-aprov.cod-estabel
              and b-mla-doc-pend-aprov.cod-tip-doc    = mla-doc-pend-aprov.cod-tip-doc
              and b-mla-doc-pend-aprov.chave-doc      begins c-chave-refer
              and (b-mla-doc-pend-aprov.ind-situacao = 1 or  
                   b-mla-doc-pend-aprov.ind-situacao = 3) 
              and  b-mla-doc-pend-aprov.historico    = NO no-error. /* encontrava o registro anterior que havia sido rejeitado sem esta cl usula; quando ‚ alterado o item do lote de implanta‡Æo ‚ criada nova pendˆncia */
              
        if avail b-mla-doc-pend-aprov then do:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Pendˆncia_pendente_com" *}
            assign c-lbl-liter-pendenc-pendent-com = trim(return-value).
            {utp/ut-liter.i "Finalizando_Processo_Atualiza‡Æo" *}
            assign c-lbl-liter-finaliz-proc-atuali = trim(return-value).
            put stream s_1 unformatted 
                c-lbl-liter-pendenc-pendent-com + " " b-mla-doc-pend-aprov.cod-usuar " | " string(mla-doc-pend-aprov.chave-doc) skip
                c-lbl-liter-finaliz-proc-atuali skip(2).
            output stream s_1 close.
            return.
        end.
        else do:
            {utp/ut-liter.i "éltima_pendˆncia_da_referˆncia_|" *}
            put stream s_1  unformatted return-value + " " string(mla-doc-pend-aprov.chave-doc) skip(2).
        end.
    end. 

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
        RETURN-VALUE SKIP.
    RUN prgfin/apf/apf706za.py (input table tt-aed-chave-aprov,
                                INPUT-OUTPUT TABLE tt-log-erros-atualiz).
    
    ASSIGN c-error = RETURN-VALUE.
    IF c-error = "NOK" THEN 
        /* Inicio -- Projeto Internacional */
        DO:
        {utp/ut-liter.i "Erro_atualiza‡Æo_do_processo_de_pagamento" *}
        PUT STREAM s_1  UNFORMATTED RETURN-VALUE + "."  SKIP.
        END. 

    RUN pi-tratar-desconexao-bancos IN THIS-PROCEDURE (INPUT h-btb009za).
    
    IF  RETURN-VALUE = "NOK" OR
        c-error      = "NOK" THEN DO:
        IF RETURN-VALUE = "NOK" THEN
            /* Inicio -- Projeto Internacional */
            DO:
            {utp/ut-liter.i "Erro_DesconexÆo_Bancos" *}
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
