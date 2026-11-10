/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0028 2.00.00.007 } /*** "010007" 27/11/2023 11:14:00  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i af0028 MAF}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (2004)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{utp/ut-glob.i}
{btb/btb009za.i}
{include/i_dbvers.i}
{cdp/cdcfgfin.i}
{include/i_fncrowid.i}
/**  Programa padr’o para detalhe da pend?ncia de aprova?’o
***
***  REQUISICAO
**/

def input parameter p-rowid-aed-doc-pend-aprov as rowid no-undo.

&IF  "{&mginv_version}" >= "2.06B" &THEN

def new global shared var v_rec_tit_ap as
    &IF {&ROWID_READY} = YES &THEN
        ROWID
    &ELSE
        RECID format ">>>>>>9":U initial ?
    &ENDIF
    no-undo.

def var h-btb009za as handle no-undo.

DEF VAR ep-codigo-local LIKE empresa.ep-codigo NO-UNDO.

find first mla-doc-pend-aprov where
    rowid(mla-doc-pend-aprov) = p-rowid-aed-doc-pend-aprov
    no-lock no-error.

&if defined(bf_aed_ambiente_magnus) &then
&else                

    /*****  EMS
    *****/

    /**  Posicionamento no registro
    **/

    if available mla-doc-pend-aprov then do:
    
        ASSIGN ep-codigo-local = mla-doc-pend-aprov.ep-codigo.

        RUN pi-conectar-bco.
            RUN prgfin/apf/apf727za.py (INPUT  mla-doc-pend-aprov.cod-estabel, 
                                        INPUT  mla-doc-pend-aprov.chave-doc ).
        RUN pi-tratar-desconexao-bancos IN THIS-PROCEDURE (INPUT h-btb009za).
    end.                   
    
&endif
           
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

        RUN pi-limpa-return.

        RUN pi-conecta-bco IN h-btb009za (  INPUT 1,
                                            INPUT 1, /* Conecta o DB */
                                            INPUT ep-codigo-local, /* empresa */
                                            INPUT "all",
                                            OUTPUT TABLE tt_erros_conexao).

        IF  RETURN-VALUE <> "OK" THEN DO:
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
        RUN pi-desconeta-base IN THIS-PROCEDURE (INPUT h-btb009za).
        DELETE PROCEDURE h-btb009za.
    end.


END PROCEDURE.

PROCEDURE pi-retorna-aprovacao-automatica-mla:
    
    DEFINE INPUT PARAMETER v_cod_usuar_docto AS CHARACTER.
    DEFINE OUTPUT PARAMETER v_log_aprova_automatico AS LOGICAL.

    FIND FIRST mla-usuar-aprov
	    WHERE mla-usuar-aprov.cod-usuar = v_cod_usuar_docto
    	  AND mla-usuar-aprov.aprova-auto = YES NO-LOCK NO-ERROR.
    IF AVAIL mla-usuar-aprov THEN
        ASSIGN v_log_aprova_automatico = YES.
    ELSE
        ASSIGN v_log_aprova_automatico = NO.

END PROCEDURE.

PROCEDURE pi-limpa-return:
    RETURN "OK".
END.

&endif
