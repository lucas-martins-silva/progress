/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEFT007 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aneft007 MAN}
&ENDIF

/******************************************************************************
**  Programa: aneft007.p
**  Funcao  : Executor de adapters para carga de dados 
**  Data    : 09/2002
**  Autor   : 
******************************************************************************/


{cdp/cdcfgdis.i}

DEF INPUT PARAM p-rowid       AS ROWID NO-UNDO.
DEF INPUT PARAM pDestinoDados AS INT   NO-UNDO. /* 1 - Neogrid / 2 - CRM     */
DEF INPUT PARAM pNomePrograma AS CHAR  NO-UNDO.

IF  pDestinoDados = 1 THEN DO:
/*********************/
    &IF '{&BF_DIS_VERSAO_EMS}' < '2.05' &THEN
    FOR EACH estabelec FIELDS (cod-emitente cod-estabel) NO-LOCK,
        FIRST emitente FIELDS (cod-emitente)
        WHERE emitente.cod-emitente        = estabelec.cod-emitente
        AND   SUBSTR(emitente.char-1,11,1) = "1" NO-LOCK:
    &ELSE
    FOR EACH estabelec FIELDS (cod-emitente cod-estabel) NO-LOCK,
        FIRST dist-emitente FIELDS (cod-emitente)
        WHERE dist-emitente.cod-emitente = estabelec.cod-emitente
        AND   dist-emitente.parceiro-b2b = YES NO-LOCK:
    &ENDIF
        IF pNomePrograma = "adapters/neogrid/enp/aneen005.p" THEN DO:
            RUN VALUE(pNomePrograma) (INPUT p-rowid,
                                      INPUT estabelec.cod-estabel,
                                      INPUT estabelec.cod-emitente,
                                      INPUT "").
        END.
        ELSE DO: 
            IF pNomePrograma = "adapters/neogrid/pdp/anepd095.p" THEN
                RUN VALUE(pNomePrograma) (INPUT p-rowid,
                                          INPUT NO).
            ELSE
                RUN VALUE(pNomePrograma) (INPUT p-rowid, 
                                          INPUT estabelec.cod-estabel,
                                          INPUT estabelec.cod-estabel).
        END.
    END.
END.
ELSE DO:  /* CRM */
    FOR FIRST para-ped FIELDS (estab-padrao) NO-LOCK:
    END.

    IF  AVAIL para-ped THEN
        FOR FIRST estabelec FIELDS (cod-estabel cod-emitente)
            WHERE estabelec.cod-estabel = para-ped.estab-padrao NO-LOCK:
        END.
    ELSE
        FOR FIRST estabelec FIELDS (cod-estabel cod-emitente) NO-LOCK:
        END.

    IF pNomePrograma = "adapters/neogrid/enp/aneen055.p" THEN
        RUN VALUE(pNomePrograma) (INPUT p-rowid,
                                  INPUT estabelec.cod-estabel,
                                  INPUT estabelec.cod-emitente,
                                  INPUT "").
    ELSE
        RUN VALUE(pNomePrograma) (INPUT p-rowid,  
                                  INPUT (IF  AVAIL estabelec
                                         THEN estabelec.cod-estabel
                                         ELSE ""),
                                  INPUT 0).
END.
