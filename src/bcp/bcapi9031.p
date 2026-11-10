/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI9031 2.00.00.002}  /*** 010002 ***/

/**********************************************************************************
**     Programa...: bcapi9031.p
**
**     Finalidade.: Pr²-api Envia Ordem de Produ»’o
**
**     Criado em..: Maio/2006
**
**     Versao.....: 1.00.00.000
**********************************************************************************/

/*********************************************************************************/
{bcp/bc0706.i}   /* Defini»’o da temp-table de transferencia do coleta de dados  */
{cdp/cd0666.i}   /* Definicao da temp-table de erros                             */
{bcp/bcapi001.i} /* Definicao da temp-table de transacoes                        */
/*********************************************************************************/

/*********************************************************************************/
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-var-equip.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.
/*********************************************************************************/

/*********************************************************************************/
DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHAR FORMAT "x(12)" NO-UNDO.
/*********************************************************************************/

/*********************************************************************************/
DEFINE VARIABLE h-bcapi001        AS HANDLE NO-UNDO.
DEFINE VARIABLE c-usuario         AS CHARACTER NO-UNDO.
DEFINE VARIABLE rw-conteudo-trans AS RAW NO-UNDO.
/*********************************************************************************/

/*********************************************************************************/
DEFINE TEMP-TABLE tt-conteudo-trans NO-UNDO
    FIELD conteudo-trans AS CHARACTER    FORMAT 'x(1500)':U .
/*********************************************************************************/

/* Main-Block */
IF THIS-PROCEDURE:PERSISTENT THEN
    RETURN.

RUN CriaTransacaoEquipamento IN THIS-PROCEDURE.

PROCEDURE CriaTransacaoEquipamento :

    DEFINE VARIABLE i-seq-filho AS INTEGER    NO-UNDO
        INITIAL 1.

    RUN validateVariables IN THIS-PROCEDURE.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    FOR EACH tt-var-equip BREAK BY tt-var-equip.cod-eqpto:

/*        RUN validateVariables IN THIS-PROCEDURE.*/

        CREATE tt-trans-filho.
        ASSIGN tt-trans-filho.cod-versao-integracao = 1
               tt-trans-filho.i-sequen-pai          = 1
               tt-trans-filho.i-sequen              = i-seq-filho
               tt-trans-filho.num-versao            = 1
               tt-trans-filho.conteudo-xml          = tt-var-equip.cod-eqpto + CHR(30) + tt-var-equip.cod-var-dtsul + CHR(30) + tt-var-equip.valor
               i-seq-filho                          = i-seq-filho + 1 .

        IF LAST-OF(tt-var-equip.cod-eqpto) THEN DO:
            RUN bcp/bcapi001.p PERSISTENT SET h-bcapi001 (INPUT-OUTPUT TABLE tt-trans,
                                                          INPUT-OUTPUT TABLE tt-erro).
            CREATE tt-conteudo-trans.
                   tt-conteudo-trans.conteudo-trans = tt-var-equip.cod-eqpto + CHR(30) + tt-var-equip.cod-var-dtsul + CHR(30) + tt-var-equip.valor.

            RAW-TRANSFER tt-conteudo-trans To rw-conteudo-trans.

            RUN RetornaUsuario(OUTPUT c-usuario).

            CREATE tt-trans.
            ASSIGN tt-trans.cod-versao-integracao  = 1
                   tt-trans.i-sequen               = 1
                   tt-trans.cd-trans               = tt-var-equip.cd-trans
                   tt-trans.conteudo-trans         = rw-conteudo-trans
                   tt-trans.detalhe                = 'EQUIPAMENTO: ' + tt-var-equip.cod-eqpto +
                                                     ' COD TRANS: '  + tt-var-equip.cd-trans +
                                                     ' DATA: '       + (IF tt-var-equip.dt-geracao <> ? THEN STRING(tt-var-equip.dt-geracao) ELSE "":U) +
                                                     ' HORA: '       + (IF tt-var-equip.hr-geracao <> ? THEN tt-var-equip.hr-geracao ELSE "":U)
                   tt-trans.nr-trans               = 0
                   tt-trans.usuario                = c-usuario
                   tt-trans.atualizada             = NO
                   tt-trans.etiqueta               = NO.

            RUN SetEstadoTrans IN h-bcapi001(INPUT 4).

            RUN atualizaTransacao IN h-bcapi001 (INPUT-OUTPUT TABLE tt-trans,
                                                 INPUT-OUTPUT TABLE tt-trans-ext,
                                                 INPUT-OUTPUT TABLE tt-trans-filho,
                                                 INPUT-OUTPUT TABLE tt-erro).
            FIND FIRST tt-trans NO-LOCK NO-ERROR.

            RUN FinalizaTransacaoEquipamento IN h-bcapi001 (INPUT tt-trans.nr-trans).

            FIND FIRST tt-erro NO-LOCK NO-ERROR.

            IF AVAIL tt-erro THEN
                RETURN "NOK":U.

            IF VALID-HANDLE(h-bcapi001) THEN
                DELETE OBJECT h-bcapi001.
        END.
    END.

END PROCEDURE.


PROCEDURE validateVariables:

    DEFINE BUFFER bfTtVarEquip FOR tt-var-equip.

    DEFINE VARIABLE cLiter AS CHARACTER  NO-UNDO.

    FOR EACH tt-var-equip NO-LOCK
        BREAK BY tt-var-equip.cod-eqpto
              BY tt-var-equip.cd-trans:

        IF FIRST-OF(tt-var-equip.cod-eqpto) THEN DO:
            /*Verifica se equipamento esta cadastrado, se nao estiver mostra erro*/
            FIND FIRST bc-eqpto NO-LOCK
                 WHERE bc-eqpto.cod-eqpto = tt-var-equip.cod-eqpto NO-ERROR.

            IF NOT AVAIL bc-eqpto THEN DO:
                {utp/ut-liter.i Equipamento *}

                ASSIGN cLiter = RETURN-VALUE.

                RUN insertError IN THIS-PROCEDURE (INPUT 31768,
                                                   INPUT RETURN-VALUE + ' "':U + tt-var-equip.cod-eqpto + '"':U).
                RETURN "NOK":U.
            END.
        END.

        IF FIRST-OF(tt-var-equip.cd-trans) THEN DO:
            /*Verifica se transacao do equipamento esta cadastrada, senao mostra erro*/
            FIND FIRST bc-tip-trans-eqpto NO-LOCK
                 WHERE bc-tip-trans-eqpto.cd-trans  = tt-var-equip.cd-trans
                 AND   bc-tip-trans-eqpto.cod-eqpto = tt-var-equip.cod-eqpto NO-ERROR.

            IF NOT AVAIL bc-tip-trans-eqpto THEN DO:
                {utp/ut-liter.i Transa‡Æo *}

                ASSIGN cLiter = RETURN-VALUE.

                RUN insertError IN THIS-PROCEDURE (INPUT 31768,
                                                   INPUT RETURN-VALUE + ' "':U + tt-var-equip.cd-trans + '"':U).
                RETURN "NOK":U.
            END.
        END.

        /*Verifica se variavel ja existe, se nao existir cria*/
        FIND FIRST bc-tip-trans-eqpto-var NO-LOCK
             WHERE bc-tip-trans-eqpto-var.cod-eqpto     = tt-var-equip.cod-eqpto
             AND   bc-tip-trans-eqpto-var.cd-trans      = tt-var-equip.cd-trans
             AND   bc-tip-trans-eqpto-var.cod-var-dtsul = tt-var-equip.cod-var-dtsul NO-ERROR.

        IF NOT AVAIL bc-tip-trans-eqpto-var THEN
            RUN CriaVariavel IN THIS-PROCEDURE (INPUT TABLE tt-var-equip).

        IF LAST-OF(tt-var-equip.cd-trans) THEN DO:
            /*Verifica se faltam variaveis na bfTtVarEquip, se faltar mostra erro*/
            FOR EACH  bc-tip-trans-eqpto-var NO-LOCK
                WHERE bc-tip-trans-eqpto-var.cod-eqpto = tt-var-equip.cod-eqpto
                AND   bc-tip-trans-eqpto-var.cd-trans  = tt-var-equip.cd-trans:

                FIND FIRST bfTtVarEquip NO-LOCK
                     WHERE bfTtVarEquip.cod-eqpto     = bc-tip-trans-eqpto-var.cod-eqpto
                     AND   bfTtVarEquip.cd-trans      = bc-tip-trans-eqpto-var.cd-trans
                     AND   bfTtVarEquip.cod-var-dtsul = bc-tip-trans-eqpto-var.cod-var-dtsul NO-ERROR.

                IF NOT AVAIL bfTtVarEquip THEN DO:
                    /*Variavel n’o encontrada*/
                    {utp/ut-liter.i Vari vel *}

                    ASSIGN cLiter = RETURN-VALUE + ' "':U + bc-tip-trans-eqpto-var.cod-var-dtsul + '" ':U.

                    {utp/ut-liter.i da_Transa‡Æo *}

                    ASSIGN cLiter = cLiter + RETURN-VALUE + ' "':U + bc-tip-trans-eqpto-var.cd-trans + '"':U.

                    RUN insertError IN THIS-PROCEDURE (INPUT 54,
                                                       INPUT cLiter).
                    RETURN "NOK":U.
                END.
            END.
        END.
    END.

END PROCEDURE.

PROCEDURE CriaVariavel:

    DEFINE INPUT  PARAMETER TABLE FOR tt-var-equip.

    DEFINE BUFFER bfBCTipoTransEquipVar FOR bc-tip-trans-eqpto-var.

    DEFINE VARIABLE iNumSeq AS INTEGER    NO-UNDO.

    FOR LAST  bfBCTipoTransEquipVar NO-LOCK
        WHERE bfBCTipoTransEquipVar.cod-var-dtsul = tt-var-equip.cod-var-dtsul
        AND   bfBCTipoTransEquipVar.cod-eqpto     = tt-var-equip.cod-eqpto
        AND   bfBCTipoTransEquipVar.cd-trans      = tt-var-equip.cd-trans
        BY bfBCTipoTransEquipVar.num-seq:

        ASSIGN iNumSeq = bfBCTipoTransEquipVar.num-seq.
    END.

    ASSIGN iNumSeq = iNumSeq + 1.

    CREATE bfBCTipoTransEquipVar.
    ASSIGN bfBCTipoTransEquipVar.cod-var-dtsul       = tt-var-equip.cod-var-dtsul
           bfBCTipoTransEquipVar.cod-eqpto           = tt-var-equip.cod-eqpto
           bfBCTipoTransEquipVar.cd-trans            = tt-var-equip.cd-trans
           bfBCTipoTransEquipVar.num-seq             = iNumSeq
           bfBCTipoTransEquipVar.cod-var-eqpto       = tt-var-equip.cod-var-eqpto
           bfBCTipoTransEquipVar.ind-val-gerac-trans = tt-var-equip.valor.

END PROCEDURE.

PROCEDURE RetornaUsuario:

    DEFINE OUTPUT PARAMETER c-usuario AS CHARACTER  NO-UNDO.

    FIND FIRST Param-Bc NO-LOCK NO-ERROR.

    IF AVAIL Param-Bc And Param-Bc.Int-2 <> 1 THEN DO:
        IF c-seg-usuario = "" THEN
            ASSIGN c-usuario = USERID("mgadm").
        ELSE
            ASSIGN c-usuario = c-seg-usuario.
    END.
    ELSE
        ASSIGN c-usuario = c-seg-usuario.

END PROCEDURE.

PROCEDURE getErrors:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.

END PROCEDURE.

PROCEDURE insertError:
    DEFINE INPUT  PARAMETER ipiErrorNumber AS INTEGER    NO-UNDO.
    DEFINE INPUT  PARAMETER ipcErrorParams AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE iErrorSeq AS INTEGER    NO-UNDO.

    FOR LAST tt-erro NO-LOCK
        BY tt-erro.i-sequen:

        ASSIGN iErrorSeq = tt-erro.i-sequen.
    END.

    ASSIGN iErrorSeq = iErrorSeq + 1.

    RUN utp/ut-msgs.p (INPUT "help",
                       INPUT ipiErrorNumber,
                       INPUT ipcErrorParams).
    CREATE tt-erro.
    ASSIGN tt-erro.i-sequen = iErrorSeq
           tt-erro.cd-erro  = ipiErrorNumber
           tt-erro.mensagem = RETURN-VALUE.

END PROCEDURE.

