/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0002 2.00.00.006}  /*** "010006" ***/
/*****************************************************************************
**
**       Programa: IM0002
**
**       Objetivo: C lculo NF Complementar Importa‡Æo
**
*****************************************************************************/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0002 MIM}
&ENDIF

{cdp/cdcfgmat.i}

{cdp/cd4305.i1}             /* Definicao TT-DOCTO       */

DEFINE INPUT        PARAMETER rw-docto        AS ROWID   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-docto.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-it-docto.

&GLOBAL-DEFINE dePis    item-doc-est.valor-pis
&GLOBAL-DEFINE deCofins item-doc-est.val-cofins

DEFINE VARIABLE totICMS        AS DECIMAL  INIT 0      NO-UNDO.
DEFINE VARIABLE totPIS         AS DECIMAL  INIT 0      NO-UNDO.
DEFINE VARIABLE totCOFINS      AS DECIMAL  INIT 0      NO-UNDO.
DEFINE VARIABLE lQuebraLinha   AS LOGICAL  INIT NO     NO-UNDO.
DEFINE VARIABLE valFCPitem     AS DECIMAL  INIT 0      NO-UNDO.

FOR FIRST docum-est 
    FIELDS(cod-emitente nro-docto serie-docto nat-operacao) NO-LOCK
     WHERE ROWID(docum-est) = rw-docto:
END.

FIND FIRST natur-oper NO-LOCK
     WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-ERROR.

IF NOT AVAIL natur-oper THEN
    RETURN "OK":U.

IF  natur-oper.log-icms-despes-import
AND natur-oper.log-pis-despes-import
AND natur-oper.log-cofins-despes-import THEN
    RETURN "OK":U.

FIND FIRST tt-docto NO-ERROR.

FOR EACH item-doc-est FIELDS (valor-icm sequencia valor-pis val-cofins 
                              serie-docto nro-docto cod-emitente nat-operacao) NO-LOCK
   WHERE item-doc-est.serie-docto  = tt-docto.serie
     AND item-doc-est.nro-docto    = tt-docto.nr-nota
     AND item-doc-est.cod-emitente = tt-docto.cod-emitente
     AND item-doc-est.nat-operacao = tt-docto.nat-operacao:
    
    FIND FIRST tt-it-docto
        WHERE tt-it-docto.serie        = tt-docto.serie
          AND tt-it-docto.nr-nota      = tt-docto.nr-nota
          AND tt-it-docto.cod-emitente = tt-docto.cod-emitente
          AND tt-it-docto.nat-operacao = tt-docto.nat-operacao
          AND tt-it-docto.nr-sequencia = item-doc-est.sequencia NO-LOCK NO-ERROR.

    IF NOT AVAIL tt-it-docto THEN
        FIND FIRST tt-it-docto
            WHERE tt-it-docto.serie        = tt-docto.serie
              AND tt-it-docto.nr-nota      = tt-docto.nr-nota
              AND tt-it-docto.cod-emitente = tt-docto.cod-emitente
              AND tt-it-docto.nat-operacao = tt-docto.nat-operacao NO-LOCK NO-ERROR.
        
    IF AVAIL tt-it-docto THEN DO:    
        /* ICMS */
        IF natur-oper.log-icms-despes-import = NO THEN DO:
            
            ASSIGN valFCPitem = 0.
            /* Verifica se calculou FCP para compor o valor do ICMS */ 
            FOR FIRST ext-item-doc-est NO-LOCK
                WHERE ext-item-doc-est.serie-docto  = item-doc-est.serie-docto 
                  AND ext-item-doc-est.nro-docto    = item-doc-est.nro-docto   
                  AND ext-item-doc-est.cod-emitente = item-doc-est.cod-emitente
                  AND ext-item-doc-est.nat-operacao = item-doc-est.nat-operacao
                  AND ext-item-doc-est.sequencia    = item-doc-est.sequencia
                  AND ext-item-doc-est.cod-param    = "FCP":U:

                ASSIGN valFCPitem = ext-item-doc-est.val-livre-3.
            END.
    
            ASSIGN tt-it-docto.vl-embalagem = tt-it-docto.vl-embalagem - (item-doc-est.valor-icm[1] + valFCPitem)
                   totICMS                  = totICMS                  + item-doc-est.valor-icm[1].
        END.
    
        /* PIS */
        IF natur-oper.log-pis-despes-import = NO THEN DO:
            
            ASSIGN tt-it-docto.vl-embalagem = tt-it-docto.vl-embalagem - {&dePis}
                   totPIS                   = totPIS + {&dePis}.
        END.
        
        /* COFINS */
        IF natur-oper.log-cofins-despes-import = NO THEN DO:
            
            ASSIGN tt-it-docto.vl-embalagem = tt-it-docto.vl-embalagem - {&deCofins}
                   totCOFINS                = totCOFINS + {&deCofins}.
        END.

    END.
END.

ASSIGN lQuebraLinha = NO.

/* PIS */
IF natur-oper.log-pis-despes-import = NO THEN DO:
    
    ASSIGN lQuebraLinha = YES
           tt-docto.obs = tt-docto.obs + CHR(10) + "Valor Pis: ":U + TRIM(STRING(totPIS,">>>,>>>,>>9.99":U)).
END.

/* COFINS */
IF natur-oper.log-cofins-despes-import = NO THEN DO:

    ASSIGN lQuebraLinha = YES
           tt-docto.obs = tt-docto.obs + CHR(10) + "Valor Cofins: ":U + TRIM(STRING(totCOFINS,">>>,>>>,>>9.99":U)).
END.

IF lQuebraLinha = YES THEN
    ASSIGN tt-docto.obs = tt-docto.obs + CHR(10).

RETURN "OK":U.
