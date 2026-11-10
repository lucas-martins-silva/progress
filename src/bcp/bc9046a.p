/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9046A 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BC9046A MBC}
&ENDIF

&GLOBAL-DEFINE ProgramName BC9046
&GLOBAL-DEFINE TempTable tt-confirma
&GLOBAL-DEFINE FrameSize 20 By 8
&GLOBAL-DEFINE ErrorDisplaySeconds 3

{bcp/bc9046.i}

define temp-table ttWork NO-UNDO like tt-confirma.
DEFINE VARIABLE de-qtd-item LIKE ttWork.qtd-item.
def input-output param table for ttWork.

&GLOBAL-DEFINE Frame01Name   Frame01
&GLOBAL-DEFINE Frame01Defs   'Conf. Transf. WMS '            At Row 01 Col 01                                         ~
                             '------------------'            at row 02 col 01                                         ~
                             'Qtd: '                         at row 03 col 01                                         ~
                              ttWork.qtd-item                at row 03 col 06 no-label view-as fill-in size 12 by .88 ~
                             'Item: '                        at row 04 col 01                                         ~
                              ttWork.cod-item                at row 04 col 07 no-label view-as fill-in size 12 by .88 ~
                             'Lt: '                          at row 05 col 01                                         ~
                              ttWork.cod-lote                at row 05 col 04 NO-LABEL FORMAT "x(40)" view-as fill-in size 12 by .88 ~
                             'Refer: '                       at row 06 col 01                                         ~
                              ttWork.cod-refer               at row 06 col 08 no-label view-as fill-in size 12 by .88 
&GLOBAL-DEFINE Frame01repeat NO
&GLOBAL-DEFINE Update01Fields ttWork.qtd-item
&GLOBAL-DEFINE TriggerBeforeFrame01 RUN InicializaCamposFrame01.
&GLOBAL-DEFINE TriggerAfterFrame01  RUN GravaCamposFrame01. IF vLogSai THEN LEAVE _frame01.

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* procedure de atualizacao da transacao            */

PROCEDURE InicializaCamposFrame01:
    FIND FIRST ttWork NO-LOCK NO-ERROR.
    DISP ttWork.cod-item
         ttWork.cod-lote
         ttWork.cod-refer
         WITH FRAME Frame01.
    ASSIGN de-qtd-item = ttWork.qtd-item.
    RETURN "OK".
END PROCEDURE.

PROCEDURE gravaCamposFrame01:
    
    FIND FIRST ttWork EXCLUSIVE-LOCK NO-ERROR.

    IF de-qtd-item < DECIMAL(ttWork.qtd-item:SCREEN-VALUE IN FRAME frame01) THEN DO:
        {bcp/bc9105.i "56" "Quantidade inv lida (WMS)"}
        ASSIGN vLogErro = YES.
        RETURN ERROR.
    END.
    ELSE DO:
        ASSIGN INPUT FRAME frame01 ttWork.qtd-item.
        RUN GravaTransacao IN THIS-PROCEDURE.
        RETURN "OK".
    END.

END PROCEDURE.

PROCEDURE GravaTransacao:
    
    RUN _RetornaUsuario (OUTPUT vNomeUsuario).
    ASSIGN ttWork.cod-usuario = vNomeUsuario.
    RAW-TRANSFER ttWork TO vConteudoRaw.

    ASSIGN vTransDetail =  'EST:':U  + STRING(ttWork.cod-estabel)  +
                          ';LOC:':U  + STRING(ttWork.cod-local)    +
                          ';DEP:':U  + STRING(ttWork.cod-depos)    +
                          ';IDD:':U  + STRING(ttWork.id-docto)     +
                          ';DOC:':U  + STRING(num-documento)       +
                          ';SEQ:':U  + STRING(ttWork.num-seq-item) +
                          ';REF:':U  + STRING(ttWork.cod-refer)    +
                          ';LOT:':U  + STRING(ttWork.cod-lote)     +
                          ';QTD:':U  + STRING(ttWork.qtd-item).

    RUN _GenerateDCTransaction (INPUT vTransaction,  /* Codigo da Transacao                   */
                                INPUT vConteudoRaw,  /* Conteudo da temp-table ttWork         */
                                INPUT vTransDetail,  /* Cabecalho de detalhes da transacao    */
                                INPUT vNomeUsuario). /* Usuario responsavel pela transacao    */
    
    FIND FIRST tt-erro-after-GenerateDC NO-LOCK NO-ERROR.
    
    IF  NOT AVAIL tt-erro-after-GenerateDC AND RETURN-VALUE = "OK" THEN DO:
        ASSIGN vLogSai      = YES
               vLogFinaliza = YES.
        RUN bcp/bc9115.p (0,"Confirma‡Æo de transferˆncia realizada com sucesso.",8,20,3).
        HIDE ALL.
        RETURN "OK".
    END.
    ELSE DO:
        ASSIGN vLogErro = YES.
        RETURN "NOK".
    END.

    RETURN "OK".
END PROCEDURE.
