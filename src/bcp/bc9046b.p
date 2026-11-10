/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9046B 2.00.00.007 } /*** "010007" ***/
/********************************************************************************
** Copyright DATASUL S.A. (2010)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BC9046B MBC}
&ENDIF

{include/i_dbinst.i}

&IF '{&mgscm_version}' >= '2.062' &THEN

{wmp/wm0552.i   ttMovto}

&GLOBAL-DEFINE ProgramName BC9046
&GLOBAL-DEFINE TempTable tt-confirma
&GLOBAL-DEFINE FrameSize 20 BY 8
&GLOBAL-DEFINE ErrorDisplaySeconds 3

{bcp/bc9046.i}

DEFINE TEMP-TABLE ttWork NO-UNDO LIKE tt-confirma.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttWork.
FIND FIRST ttWork NO-LOCK NO-ERROR.

&GLOBAL-DEFINE Frame01Name   Frame01
&GLOBAL-DEFINE Frame01Defs   'Conf. Transf. WMS'    AT ROW 01 COLUMN 01          ~
                             '------------------'   AT ROW 02 COLUMN 01          ~
                             'Etiqueta:'            AT ROW 03 COLUMN 01          ~
                              ttWork.num-serial     AT ROW 04 COLUMN 01 NO-LABEL ~
                             'Itens: 888888'        AT ROW 08 COLUMN 01
&GLOBAL-DEFINE Frame01repeat        NO
&GLOBAL-DEFINE Update01Fields       ttWork.num-serial
&GLOBAL-DEFINE TriggerBeforeFrame01 RUN InicializaCamposFrame01.
&GLOBAL-DEFINE TriggerAfterFrame01  RUN GravaCamposFrame01. IF vLogSai THEN DO: LEAVE _frame01. RETURN 'OK':U. END.

&GLOBAL-DEFINE ActiveObject1 h-bosc172

{bcp/bc9100.i}
{bcp/bc9101.i}

PROCEDURE InicializaCamposFrame01:

    FIND FIRST ttWork NO-ERROR.
    ASSIGN ttWork.num-serial = 0
           ttWork.num-serial:SCREEN-VALUE IN FRAME Frame01 = '0'.

    RETURN 'OK':U.

END PROCEDURE.

PROCEDURE GravaCamposFrame01:

    DEFINE VARIABLE l-fechar AS LOGICAL     NO-UNDO.

    ASSIGN vLogErro     = NO
           vLogSai      = NO
           vLogFinaliza = NO
           vLogErro     = NO.

    FIND FIRST ttWork NO-ERROR.
    ASSIGN INPUT FRAME frame01 ttWork.num-serial
           ttWork.cod-item = "".

    IF  ttWork.num-serial = 888888 THEN DO:
        EMPTY TEMP-TABLE tt-itens.
        RUN bcp/bc9046z1.p(INPUT-OUTPUT TABLE ttWork,
                                 OUTPUT TABLE tt-itens).
        FIND FIRST ttWork NO-LOCK NO-ERROR.
        DISP ttWork.num-serial WITH FRAME frame01.
        IF  ttWork.cod-item = '*F3-TODOS*':U THEN DO:
            ASSIGN  l-fechar = YES
                    vLogSai = YES
                    vLogFinaliza = YES.
            /*FOR EACH tt-itens:
                RUN pi-criar-tt-movto IN THIS-PROCEDURE (INPUT ttWork.cod-estabel,
                                                         INPUT ttWork.cod-local,
                                                         INPUT ttWork.id-docto,
                                                         INPUT tt-itens.num-seq,
                                                         INPUT tt-itens.cod-refer,
                                                         INPUT tt-itens.cod-lote,
                                                         INPUT tt-itens.qtd-item).
            END.
            RUN pi-efetiva-transferencia IN THIS-PROCEDURE.*/
        END.
    END.
    ELSE DO:
        IF NOT VALID-HANDLE(h-bosc172) THEN DO:
            RUN scbo/bosc172.p PERSISTENT SET h-bosc172.
            RUN openQueryStatic IN h-bosc172 (INPUT 'Main':U).
        END.

        IF  VALID-HANDLE(h-bosc172) THEN DO:
            RUN getItem IN h-bosc172 (INPUT  ttWork.cod-estabel, 
                                      INPUT  ttWork.cod-local,   
                                      INPUT  ttWork.id-docto,    
                                      INPUT  ttWork.num-serial,
                                      OUTPUT ttWork.num-seq-item,
                                      OUTPUT ttWork.id-movto,
                                      OUTPUT ttWork.cod-item,
                                      OUTPUT ttWork.qtd-item,
                                      OUTPUT ttWork.cod-lote,
                                      OUTPUT ttWork.cod-refer).

            IF  RETURN-VALUE = 'NOK':U THEN DO:
                {bcp/bc9105.i "56" "Etiqueta Inv lida (WMS)"}
                ASSIGN vLogErro = YES.
            END.
            ELSE DO:
                RUN bcp/bc9046a.p (INPUT-OUTPUT TABLE ttWork).
            END.
        END.
        IF VALID-HANDLE(h-bosc172) THEN RUN destroy IN h-bosc172.
    END.

    IF vLogErro THEN
        RETURN ERROR.

    IF l-fechar THEN
        ASSIGN  vLogSai = YES
                vLogFinaliza = YES.

    RETURN 'OK':U.

END PROCEDURE.

PROCEDURE pi-criar-tt-movto:

    DEFINE INPUT PARAM p-cod-estabel  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM p-cod-local    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM p-id-docto     AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAM p-num-seq-item AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAM pcod-refer     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM p-cod-lote     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM p-qtd-item     AS DECIMAL   NO-UNDO.

    CREATE ttMovto.
    ASSIGN ttMovto.cod-estabel  = p-cod-estabel 
           ttMovto.cod-local    = p-cod-local   
           ttMovto.id-docto     = p-id-docto    
           ttMovto.num-seq-item = p-num-seq-item
           ttMovto.cod-refer    = pcod-refer    
           ttMovto.cod-lote     = p-cod-lote    
           ttMovto.qtd-item     = p-qtd-item.

    RETURN 'OK':U.

END PROCEDURE.

PROCEDURE pi-efetiva-transferencia:

    EMPTY TEMP-TABLE RowErrors.
    RUN wmp/wm0552.p (INPUT  TODAY,
                      INPUT  TABLE ttMovto,
                      OUTPUT TABLE RowErrors).
    IF  CAN-FIND(FIRST RowErrors) THEN DO:
        FOR EACH RowErrors:
            {bcp/bc9015.i2 STRING(ErrorNumber) "ErrorDescription + '(WMS)'"}
        END.
        ASSIGN vLogErro = YES.
        RETURN 'NOK':U.
    END.
    ELSE DO:
        RUN GravaTransacao IN THIS-PROCEDURE.
        RETURN RETURN-VALUE.
    END.

    RETURN 'OK':U.

END PROCEDURE.

PROCEDURE GravaTransacao:

    RUN _RetornaUsuario (OUTPUT vNomeUsuario).
    ASSIGN ttWork.cod-usuario = vNomeUsuario.
    RAW-TRANSFER ttWork TO vConteudoRaw.

    ASSIGN vTransDetail =  'EST:':U  + STRING(ttWork.cod-estabel) +
                          ';LOC:':U  + STRING(ttWork.cod-local) +
                          ';DEP:':U  + STRING(ttWork.cod-depos) +
                          ';IDD:':U  + STRING(ttWork.id-docto) +
                          ';DOC:':U  + STRING(num-documento) +
                          ';SEQ:':U  + STRING(ttWork.num-seq-item) +
                          ';MOV:':U  + STRING(ttWork.id-movto) +
                          ';REF:':U  + STRING(ttWork.cod-refer) +
                          ';LOT:':U  + STRING(ttWork.cod-lote) +
                          ';QTD:':U  + STRING(ttWork.qtd-item).

    RUN _GenerateDCTransaction (INPUT vTransaction,  /* Codigo da Transacao                */
                                INPUT vConteudoRaw,  /* ConteuDO da temp-TABLE ttWork      */
                                INPUT vTransDetail,  /* Cabecalho de detalhes da transacao */
                                INPUT vNomeUsuario). /* Usuario responsavel pela transacao */

    FIND FIRST tt-erro-after-GenerateDC NO-LOCK NO-ERROR.

    IF  NOT AVAIL tt-erro-after-GenerateDC AND RETURN-VALUE = 'OK':U THEN DO:
        ASSIGN vLogSai      = YES
               vLogFinaliza = YES.
        RUN bcp/bc9115.p (0, "Confirma‡Æo de transferˆncia realizada com sucesso.", 8, 20, 3).
        HIDE ALL.
        RETURN 'OK':U.
    END.
    ELSE DO:
        ASSIGN vLogErro = YES.
        RETURN 'NOK':U.
    END.

    RETURN 'OK':U.
END PROCEDURE.

&ELSE 
    RUN utp/ut-msgs.p ( INPUT 'show':U,
                        INPUT 28036,
                        INPUT '').
&ENDIF

