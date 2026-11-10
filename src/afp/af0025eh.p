/*********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/
{include/i-prgvrs.i AF0025EH 2.00.00.031 } /*** "010031" 27/11/2023 11:14:00  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i af0025eh MAF}
&ENDIF

{utp/ut-glob.i}
{btb/btb009za.i}
{include/i_fncrowid.i}

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

DEF VAR ep-codigo-local LIKE empresa.ep-codigo NO-UNDO.
DEF VAR c-error         AS CHAR INITIAL "" NO-UNDO.

DEF VAR c-cod-estabel   AS CHAR NO-UNDO.
DEF VAR i-cont-aprov2    AS INTEGER NO-UNDO.

{include/i-epc200.i "AF0025EH"} /*valido para a include, nÆo retirar*/

DEFINE VARIABLE c-usuar-mestre AS CHARACTER NO-UNDO.



/*  Login Integrado */
def var v_hdl_login_integr          as handle  no-undo.
def var v_log_habilita_login_integr as logical no-undo.

/* Para n?o pedir senha novamente quando o programa for chamado pelo EMS2 */ 
assign v5_cod_usuar_corren         = v_cod_usuar_corren 
       v5_cod_empres_usuar         = v_cod_empres_usuar 
       /*v5_cod_estab_usuar          = '999' */
       v5_cod_idiom_usuar          = v_cod_idiom_usuar 
       v5_cod_pais_empres_usuar    = v_cod_pais_empres_usuar 
       v5_cod_usuar_corren_criptog = v_cod_usuar_corren_criptog 
       v5_cod_grp_usuar_lst        = v_cod_grp_usuar_lst. 

/*** Defini?’o da tt-aed-chave ***/
{afp/af0001.i}
/*** Defini?’o da tt-html ***/
{afp/af0030eh.i}
/*** Defini?’o da tt_antecip_pef_pend, tt_item_lote_impl_ap, tt_aprop_ctbl_pend_ap ***/
{afp/af0045eh.i}   

/*** Outras includes necessÿrias ***/
{cdp/cdcfgdis.i}

/* Inicio - Colocar este c½digo em comentÿrio para Teste */

DEF INPUT PARAMETER p-cod-tip-doc   as integer no-undo.
DEF INPUT PARAMETER p-cod-aprovador as char    no-undo.
DEF INPUT PARAMETER table for tt-aed-chave.
DEF OUTPUT PARAMETER TABLE FOR tt-html.

/* Fim - Colocar este c½digo em comentÿrio para Teste */
DEF VAR h-btb009za        AS HANDLE  NO-UNDO.
DEF VAR c-class           AS CHAR    NO-UNDO.
DEF VAR i-cont            AS INTEGER NO-UNDO.
DEF VAR c-chave           AS CHAR    NO-UNDO.
DEF VAR i-chave           AS INTEGER NO-UNDO.
def var i-empresa         like empresa.ep-codigo. 
DEF VARIABLE v_rec_aprop AS
    &IF {&ROWID_READY} = YES &THEN 
        ROWID
    &ELSE 
        RECID
    &ENDIF
    NO-UNDO.
def var v_log_alternativo as logical INITIAL NO no-undo.
def var v_nom_aprov       as char no-undo.
DEF VAR v_seq             AS INTEGER NO-UNDO.

assign c-chave = "".
find first tt-aed-chave
    no-lock no-error.

/**   Monta chave do documento
**/
ASSIGN v_log_alternativo = NO
       v_nom_aprov       = "".


FOR EACH  mla-chave-doc-aprov 
    WHERE mla-chave-doc-aprov.cod-tip-doc = p-cod-tip-doc 
    NO-LOCK:
    assign i-chave = i-chave + 1
           c-chave = c-chave + tt-aed-chave.valor[i-chave] + substring("                    ",1,  
                                        (((mla-chave-doc-aprov.posicao-fim - mla-chave-doc-aprov.posicao-ini) + 1) - length(tt-aed-chave.valor[i-chave]))). 
end.

find first mla-chave-doc-aprov WHERE mla-chave-doc-aprov.cod-tip-doc = p-cod-tip-doc no-lock no-error.
if avail mla-chave-doc-aprov then
    ASSIGN ep-codigo-local = mla-chave-doc-aprov.ep-codigo.
else
    ASSIGN ep-codigo-local = "1".

RUN pi-conectar-bco.

IF (tt-aed-chave.valor[10]) = "" THEN DO:
    RUN prgfin/apf/apf735za.py (INPUT  tt-aed-chave.valor[1],   /* Estab ems2*/
                               OUTPUT i-empresa). /* Empresa ems2 traduzida pela matriz de tradu?’oo do EMS5 */
    assign tt-aed-chave.valor[10] = string(i-empresa).
    IF  RETURN-VALUE = "nok" THEN
        RETURN "NOK".
END.

ASSIGN c-cod-estabel = tt-aed-chave.valor[1]
       i-empresa     = tt-aed-chave.valor[10].

FIND FIRST mla-param-aprov 
     WHERE mla-param-aprov.ep-codigo = &IF "{&mguni_version}" >= "2.071" &THEN STRING(tt-aed-chave.valor[10]) &ELSE int(tt-aed-chave.valor[10]) &ENDIF
     AND mla-param-aprov.cod-estabel = tt-aed-chave.valor[1] NO-LOCK NO-ERROR.


FIND FIRST mla-tipo-doc-aprov
     WHERE mla-tipo-doc-aprov.ep-codigo   = &IF "{&mguni_version}" >= "2.071" &THEN STRING(tt-aed-chave.valor[10]) &ELSE integer(tt-aed-chave.valor[10]) &ENDIF
       AND mla-tipo-doc-aprov.cod-estabel = tt-aed-chave.valor[1]
       AND mla-tipo-doc-aprov.cod-tip-doc = p-cod-tip-doc NO-LOCK NO-ERROR.


for each mla-doc-pend-aprov no-lock
    WHERE mla-doc-pend-aprov.ep-codigo  = &IF "{&mguni_version}" >= "2.071" &THEN STRING(tt-aed-chave.valor[10]) &ELSE integer(tt-aed-chave.valor[10]) &ENDIF
    AND mla-doc-pend-aprov.cod-estabel  = tt-aed-chave.valor[1]
    AND mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc 
    AND mla-doc-pend-aprov.chave-doc    = c-chave:
end.

FIND FIRST mla-doc-pend-aprov 
     WHERE mla-doc-pend-aprov.ep-codigo    = &IF "{&mguni_version}" >= "2.071" &THEN STRING(tt-aed-chave.valor[10]) &ELSE integer(tt-aed-chave.valor[10]) &ENDIF 
       AND mla-doc-pend-aprov.cod-estabel  = tt-aed-chave.valor[1]
       AND mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc 
       AND mla-doc-pend-aprov.chave-doc    = c-chave  
       AND mla-doc-pend-aprov.ind-situacao = 1
       AND mla-doc-pend-aprov.historico    = NO NO-LOCK NO-ERROR. /* pend?ncia atual */

IF NOT AVAIL mla-doc-pend-aprov THEN
    FIND FIRST mla-doc-pend-aprov 
         WHERE mla-doc-pend-aprov.ep-codigo    = &IF "{&mguni_version}" >= "2.071" &THEN STRING(tt-aed-chave.valor[10]) &ELSE integer(tt-aed-chave.valor[10]) &ENDIF 
           AND mla-doc-pend-aprov.cod-estabel  = tt-aed-chave.valor[1]
           AND mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc 
           AND mla-doc-pend-aprov.chave-doc    = c-chave  
           AND mla-doc-pend-aprov.ind-situacao = 2
           AND mla-doc-pend-aprov.historico    = NO NO-LOCK NO-ERROR. /* pend?ncia atual */

IF  AVAIL mla-doc-pend-aprov THEN DO:
    if  substring(mla-param-aprov.char-2,2,1) = "Y"
    and mla-doc-pend-aprov.cod-usuar <> p-cod-aprovador then do:
        if can-find(first mla-usuar-aprov-altern no-lock
                    where mla-usuar-aprov-altern.cod-usuar = mla-doc-pend-aprov.cod-usuar
                    and   mla-usuar-aprov-altern.validade-ini <= today
                    and   mla-usuar-aprov-altern.validade-fim >= today
                    and   mla-usuar-aprov-altern.cod-usuar-altern = p-cod-aprovador) then do:
                    assign v_log_alternativo = yes.
                    find first usuar_mestre no-lock 
                        where usuar_mestre.cod_usuario = mla-doc-pend-aprov.cod-usuar no-error.
                    if avail usuar_mestre THEN 
                        assign v_nom_aprov = usuar_mestre.nom_usuario.
        end.            
    end.
END.

RUN prgfin/apf/apf732za.py (INPUT  p-cod-tip-doc,
                           INPUT  c-chave,                      
                           INPUT  v_rec_aprop,
                           OUTPUT TABLE tt_antecip_pef_pend,
                           OUTPUT TABLE tt_item_lote_impl_ap,
                           OUTPUT TABLE tt_aprop_ctbl_pend_ap,
                           OUTPUT TABLE tt_tit_ap,
                           OUTPUT TABLE tt_aprop_ctbl_ap).

/*
** Desconecta as bases do EMS5
*/
RUN pi-tratar-desconexao-bancos IN THIS-PROCEDURE (INPUT h-btb009za).
ASSIGN v_cod_empres_usuar = v5_cod_empres_usuar.


IF AVAIL mla-doc-pend-aprov THEN DO:
    IF ENTRY(1,mla-doc-pend-aprov.motivo-doc,';':U) = 'MEC' THEN DO:
        RUN afp/af0025ei.p (INPUT p-cod-tip-doc,
                            INPUT p-cod-aprovador, 
                            INPUT table tt-aed-chave,
                            OUTPUT TABLE  tt-html).
    END.
    ELSE DO:
        {afp/af0025eh.i} 
    END.
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

        RUN btb/btb009za.p PERSISTENT SET h-btb009za.

        RUN pi-conecta-bco IN h-btb009za (  INPUT 1,
                                            INPUT 1, /* Conecta o DB */
                                            INPUT ep-codigo-local,
                                            INPUT "all",
                                            OUTPUT TABLE tt_erros_conexao).

        IF  RETURN-VALUE <> "OK" THEN DO:
            run utp/ut0666.w (input table tt_erros_conexao).
            RUN pi-tratar-desconexao-bancos IN THIS-PROCEDURE (INPUT h-btb009za).
            return 'adm-error'.
        end.
    END.
    /****************************************************************************************************
    END - Tecnologia:
    ****************************************************************************************************/
END.

PROCEDURE pi-desconeta-base:
    DEFINE INPUT PARAMETER h-btb009za  AS HANDLE.

    run pi-conecta-bco in h-btb009za (INPUT 1,
                                      INPUT 2, /* Desconecta o DB */
                                      INPUT ep-codigo-local,
                                      INPUT "all",
                                      OUTPUT Table tt_erros_conexao).

END PROCEDURE.

PROCEDURE pi-tratar-desconexao-bancos:
    DEFINE INPUT PARAMETER h-btb009za  AS HANDLE. 

    IF  VALID-HANDLE(h-btb009za)
    AND h-btb009za:TYPE = "procedure":U
    AND h-btb009za:FILE-NAME = "btb/btb009za.p"
    THEN do:
        RUN pi-desconeta-base IN THIS-PROCEDURE (INPUT h-btb009za).
        DELETE PROCEDURE h-btb009za.
    end.

END PROCEDURE.
/*****************************************************************************
** Procedure.: pi_login_integr_habilitado
** Fun‡Æo....: Retorna se a funcionalidade do login integrado est  habilitada
*****************************************************************************/
procedure pi_login_integr_habilitado:

    def output param ploginintegrhabilit as logical initial no.
    
    &if  "{&mginv_version}" = "2.06b" &then
        find first login-integr-so no-lock no-error.
        assign ploginintegrhabilit = (avail login-integr-so 
                                      and login-integr-so.log-habtdo-login-integr).
    &endif
   
end procedure. /* --- pi_login_integr_habilitado - */
