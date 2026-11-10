/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0118WMS 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0118WMS MBC}
&ENDIF


/***
RETORN DOS ENDERE€OS WMS 
***/

{include/i_dbvers.i}

DEF TEMP-TABLE ttWm-box-bc NO-UNDO
    FIELD  cod-local   AS CHAR 
    FIELD  cod-estabel AS CHAR 
    FIELD  bloco       AS CHAR 
    FIELD  rua         AS CHAR 
    FIELD  nivel       AS CHAR 
    FIELD  coluna      AS CHAR 
    FIELD  id-box      AS INT 
    INDEX id IS PRIMARY id-box.

DEF INPUT PARAM pCod-EstabelIni AS CHAR NO-UNDO.
DEF INPUT PARAM pCod-EstabelFim AS CHAR NO-UNDO.
DEF INPUT PARAM pCod-LocalIni   AS CHAR NO-UNDO.
DEF INPUT PARAM pCod-LocalFim   AS CHAR NO-UNDO.
DEF INPUT PARAM pBlocoIni       AS CHAR NO-UNDO.
DEF INPUT PARAM pBlocoFim       AS CHAR NO-UNDO.
DEF INPUT PARAM pRuaIni         AS CHAR NO-UNDO.
DEF INPUT PARAM pRuaFim         AS CHAR NO-UNDO.
DEF INPUT PARAM pColunaIni      AS CHAR NO-UNDO.
DEF INPUT PARAM pColunaFim      AS CHAR NO-UNDO.
DEF INPUT PARAM pNivelIni       AS CHAR NO-UNDO.
DEF INPUT PARAM pNivelFim       AS CHAR NO-UNDO.

DEF OUTPUT PARAM TABLE FOR ttWm-box-bc.

&IF "{&mgcld_version}" >= "2.04" &THEN

{scbo/bosc030.i ttwm-box-wms}

DEF VAR h_bosc030 AS HANDLE NO-UNDO.
DEF VAR iTotRegistro AS INT NO-UNDO.
DEF VAR h_acomp  AS HANDLE NO-UNDO.

RUN utp/ut-acomp.p PERSISTENT SET h_acomp.

RUN pi-inicializar IN h_acomp (INPUT "Processando").

/* Inicio -- Projeto Internacional */
{utp/ut-liter.i "Lendo_Endere‡os_WMS" *}
RUN pi-acompanhar IN h_acomp (INPUT RETURN-VALUE).

RUN scbo/bosc030.p PERSISTENT SET h_bosc030.

RUN setConstraintEstabelLocal IN h_bosc030 (INPUT pCod-EstabelIni,
                                            INPUT pCod-EstabelFim,

                                            INPUT pCod-LocalIni,
                                            INPUT pCod-LocalFim,

                                            INPUT pBlocoIni,
                                            INPUT pBlocoFim,
  
                                            INPUT pRuaIni,
                                            INPUT pRuaFim,

                                            INPUT pNivelIni,
                                            INPUT pNivelFim,

                                            INPUT pColunaIni,
                                            INPUT pColunaFim).

/*
RUN setConstraintEstabelLocalIdBox2 (INPUT pCodEstabel,
                                     INPUT pCodLocal,
                                     INPUT 0,
                                     INPUT 999999999).
*/

RUN openQueryEstabelLocal IN h_bosc030.

run getbatchrecords in h_bosc030 (input  ?, 
                                  input  YES,
                                  input  0,
                                  output iTotRegistro,
                                  output table ttwm-box-wms).

FOR EACH ttwm-box-wms:

    CREATE ttWm-box-bc.
    ASSIGN ttWm-box-bc.bloco  = ttwm-box-wms.cod-bloco
           ttWm-box-bc.rua    = ttwm-box-wms.cod-rua
           ttWm-box-bc.nivel  = ttwm-box-wms.cod-nivel
           ttWm-box-bc.coluna = ttwm-box-wms.cod-coluna
           ttWm-box-bc.id-box = ttwm-box-wms.id-box
           ttWm-box-bc.cod-estabel = ttWm-box-wms.cod-estabel 
           ttWm-box-bc.cod-local   = ttWm-box-wms.cod-local. 

END.

RUN pi-finalizar IN h_acomp.
DELETE OBJECT h_bosc030.

&ENDIF
