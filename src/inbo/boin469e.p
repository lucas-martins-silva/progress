&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOFunction 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN469E 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN469E MUT}
&ENDIF

/*:T--------------------------------------------------------------------------
    File       : dbofun.p
    Purpose    : O DBO Function (Datasul Business Objects) Ç um programa 
                 PROGRESS que contÇm a l¢gica de neg¢cio.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName 
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName 
&GLOBAL-DEFINE TableLabel 

{sfc/sf9002.i}

/*Temp-table Paradas Programadas e Reais*/
DEF TEMP-TABLE tt-man-progda-ctrab-boin469e NO-UNDO
    FIELD cod-ctrab     LIKE man-progda-ctrab.cod-ctrab
    FIELD num-om-progda LIKE man-progda-ctrab.num-om-progda
    INDEX ch-principal IS PRIMARY UNIQUE cod-ctrab num-om-progda.

DEF TEMP-TABLE tt-rep-parada-ctrab-boin469e NO-UNDO
    FIELD cod-ctrab             LIKE man-progda-ctrab.cod-ctrab
    FIELD val-refer-inic-parada LIKE rep-parada-ctrab.val-refer-inic-parada 
    INDEX ch-parincipal IS PRIMARY UNIQUE cod-ctrab val-refer-inic-parada.


/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
/* {xxxxxxxx/boxxxxxx.i RowObject} */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOFunction
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOFunction
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOFunction ASSIGN
         HEIGHT             = 13.25
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOFunction 
/* ************************* Included-Libraries *********************** */

{method/dbofun.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOFunction 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCalculaDataHoraTempo DBOFunction 
PROCEDURE piCalculaDataHoraTempo :
/*------------------------------------------------------------------------------
  Purpose:     Calcula Data e Hora In°cio / Data e Hora Termino
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT        PARAMETER c-cod-area         LIKE area-produc.cod-area     NO-UNDO.
    DEF INPUT        PARAMETER c-gm-codigo        LIKE grup-maquina.gm-codigo   NO-UNDO.
    DEF INPUT        PARAMETER c-cod-ctrab        LIKE split-operac.cod-ctrab   NO-UNDO.
    DEF INPUT        PARAMETER c-cod-calend       LIKE area-produc.cd-calen     NO-UNDO.
    DEF INPUT-OUTPUT PARAMETER d-dat-termino      AS DATE FORMAT "99/99/9999":U NO-UNDO.
    DEF INPUT-OUTPUT PARAMETER i-qtd-segs-termino AS DECIMAL DECIMALS 0         NO-UNDO.
    DEF INPUT-OUTPUT PARAMETER d-dat-inicio       AS DATE FORMAT "99/99/9999":U NO-UNDO.
    DEF INPUT-OUTPUT PARAMETER i-qtd-segs-inicio  AS DECIMAL DECIMALS 0         NO-UNDO.
    DEF INPUT-OUTPUT PARAMETER de-tempo           AS DECIMAL DECIMALS 4         NO-UNDO.
    DEF INPUT        PARAMETER l-cons-parad-prog  AS LOG                        NO-UNDO.
    DEF INPUT        PARAMETER l-cons-parad-real  AS LOG                        NO-UNDO.
    DEF INPUT        PARAMETER d-dat-corte        AS DATE FORMAT "99/99/9999":U NO-UNDO.
    DEF INPUT        PARAMETER i-qtd-segs-corte   AS DECIMAL DECIMALS 0         NO-UNDO.
    
    DEF VAR i-acao                    AS INTEGER                  NO-UNDO.
    DEF VAR de-tempo-parada           AS DECIMAL DECIMALS 4       NO-UNDO.

    IF de-tempo      = ? THEN ASSIGN i-acao = 1.
    IF d-dat-inicio  = ? THEN ASSIGN i-acao = 2.
    IF d-dat-termino = ? THEN ASSIGN i-acao = 3.
    
    run inbo/boin469d.p (input-output c-cod-area,
                         input-output c-gm-codigo,
                         input        c-cod-ctrab,
                         input-output c-cod-calend,
                         Input-output d-dat-termino,
                         Input-output i-qtd-segs-termino,
                         Input-output d-dat-inicio,
                         Input-output i-qtd-segs-inicio,
                         Input-output de-tempo).
    
    /*Calculo de Paradas Programadas*/
    IF l-cons-parad-prog = YES AND c-cod-ctrab <> "" THEN DO:
        EMPTY TEMP-TABLE tt-man-progda-ctrab-boin469e.
        ASSIGN de-tempo-parada = 0.

        b-parada-progda:
        REPEAT:
            RUN piCalculaParadaProgramada(INPUT        c-cod-area,        
                                          input        c-gm-codigo,       
                                          input        c-cod-ctrab,       
                                          INPUT        c-cod-calend,      
                                          Input-output d-dat-termino,     
                                          Input-output i-qtd-segs-termino,
                                          Input-output d-dat-inicio,      
                                          Input-output i-qtd-segs-inicio, 
                                          Input-output de-tempo-parada,
                                          INPUT        d-dat-corte,
                                          INPUT        i-qtd-segs-corte).    

            IF de-tempo-parada = 0 THEN LEAVE b-parada-progda.

            IF i-acao = 1 THEN DO: /*Somente ir† descontar o tempo de parada do tempo disponivel*/
                ASSIGN de-tempo = de-tempo - de-tempo-parada.
                LEAVE b-parada-progda.
            END.
            ELSE DO:
                IF i-acao = 2 THEN /*Estaremos aumentando o tempo de execuá∆o pois o mesmo n∆o considera a hora parada*/
                    ASSIGN de-tempo-parada   = de-tempo-parada + de-tempo
                           d-dat-inicio      = ?
                           i-qtd-segs-inicio = ?.
                IF i-acao = 3 THEN /*Estaremos aumentando o tempo de execuá∆o pois o mesmo n∆o considera a hora parada*/
                    ASSIGN de-tempo-parada    = de-tempo-parada + de-tempo
                           d-dat-termino      = ?
                           i-qtd-segs-termino = ?.

                run inbo/boin469d.p (input-output c-cod-area,
                                     input-output c-gm-codigo,
                                     input        c-cod-ctrab,
                                     input-output c-cod-calend,
                                     Input-output d-dat-termino,
                                     Input-output i-qtd-segs-termino,
                                     Input-output d-dat-inicio,
                                     Input-output i-qtd-segs-inicio,
                                     Input-output de-tempo-parada).
            END.
        END.
    END.
    /*Calculo de Paradas Reais*/
    IF l-cons-parad-prog = YES AND c-cod-ctrab <> "" THEN DO:
        EMPTY TEMP-TABLE tt-rep-parada-ctrab-boin469e.
        ASSIGN de-tempo-parada = 0.

        b-parada-real:
        REPEAT:
            RUN piCalculaParadaReal(INPUT        c-cod-area,        
                                    input        c-gm-codigo,       
                                    input        c-cod-ctrab,       
                                    INPUT        c-cod-calend,      
                                    Input-output d-dat-termino,     
                                    Input-output i-qtd-segs-termino,
                                    Input-output d-dat-inicio,      
                                    Input-output i-qtd-segs-inicio, 
                                    Input-output de-tempo-parada,
                                    INPUT        d-dat-corte,
                                    INPUT        i-qtd-segs-corte).    

            IF de-tempo-parada = 0 THEN LEAVE b-parada-real.

            IF i-acao = 1 THEN DO: /*Somente ir† descontar o tempo de parada do tempo disponivel*/
                ASSIGN de-tempo = de-tempo - de-tempo-parada.
                LEAVE b-parada-real.
            END.
            ELSE DO:
                IF i-acao = 2 THEN /*Estaremos aumentando o tempo de execuá∆o pois o mesmo n∆o considera a hora parada*/
                    ASSIGN de-tempo-parada   = de-tempo-parada + de-tempo
                           d-dat-inicio      = ?
                           i-qtd-segs-inicio = ?.
                IF i-acao = 3 THEN /*Estaremos aumentando o tempo de execuá∆o pois o mesmo n∆o considera a hora parada*/
                    ASSIGN de-tempo-parada    = de-tempo-parada + de-tempo
                           d-dat-termino      = ?
                           i-qtd-segs-termino = ?.

                run inbo/boin469d.p (input-output c-cod-area,
                                     input-output c-gm-codigo,
                                     input        c-cod-ctrab,
                                     input-output c-cod-calend,
                                     Input-output d-dat-termino,
                                     Input-output i-qtd-segs-termino,
                                     Input-output d-dat-inicio,
                                     Input-output i-qtd-segs-inicio,
                                     Input-output de-tempo-parada).
            END.
        END.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCalculaParadaProgramada DBOFunction 
PROCEDURE piCalculaParadaProgramada :
/*------------------------------------------------------------------------------
  Purpose:     Calcula Data e Hora In°cio / Data e Hora Termino
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT        PARAMETER c-cod-area         LIKE area-produc.cod-area     NO-UNDO.
    DEF INPUT        PARAMETER c-gm-codigo        LIKE grup-maquina.gm-codigo   NO-UNDO.
    DEF INPUT        PARAMETER c-cod-ctrab        LIKE split-operac.cod-ctrab   NO-UNDO.
    DEF INPUT        PARAMETER c-cod-calend       LIKE area-produc.cd-calen     NO-UNDO.
    DEF INPUT-OUTPUT PARAMETER d-dat-termino      AS DATE FORMAT "99/99/9999":U NO-UNDO.
    DEF INPUT-OUTPUT PARAMETER i-qtd-segs-termino AS DECIMAL DECIMALS 0         NO-UNDO.
    DEF INPUT-OUTPUT PARAMETER d-dat-inicio       AS DATE FORMAT "99/99/9999":U NO-UNDO.
    DEF INPUT-OUTPUT PARAMETER i-qtd-segs-inicio  AS DECIMAL DECIMALS 0         NO-UNDO.
    DEF INPUT-OUTPUT PARAMETER de-tempo           AS DECIMAL DECIMALS 4         NO-UNDO.
    DEF INPUT        PARAMETER d-dat-corte        AS DATE FORMAT "99/99/9999":U NO-UNDO.
    DEF INPUT        PARAMETER i-qtd-segs-corte   AS DECIMAL DECIMALS 0         NO-UNDO.
    
    DEF VAR de-tempo-aux1 AS DECIMAL DECIMALS 4       NO-UNDO.
    
    DEF VAR d-dat-termino-parada      AS DATE FORMAT "99/99/9999":U NO-UNDO.
    DEF VAR i-qtd-segs-termino-parada AS DECIMAL DECIMALS 0         NO-UNDO.
    DEF VAR d-dat-inicio-parada       AS DATE FORMAT "99/99/9999":U NO-UNDO.
    DEF VAR i-qtd-segs-inicio-parada  AS DECIMAL DECIMALS 0         NO-UNDO.

    ASSIGN de-tempo = 0.

    FOR EACH man-progda-ctrab NO-LOCK USE-INDEX inicio
        WHERE man-progda-ctrab.cod-ctrab              = c-cod-ctrab
          AND man-progda-ctrab.log-man-ativa          = YES:
        IF (man-progda-ctrab.dat-progda-inic >= d-dat-inicio    AND
            man-progda-ctrab.dat-progda-inic <= d-dat-termino)  OR
           (man-progda-ctrab.dat-progda-inic <= d-dat-inicio    AND
            man-progda-ctrab.dat-progda-fim  >= d-dat-termino ) OR
           (man-progda-ctrab.dat-progda-inic >= d-dat-inicio    AND
            man-progda-ctrab.dat-progda-fim  <= d-dat-termino ) OR
           (man-progda-ctrab.dat-progda-inic <= d-dat-inicio    AND
            man-progda-ctrab.dat-progda-fim  >= d-dat-termino) THEN DO:

            IF CAN-FIND(FIRST tt-man-progda-ctrab-boin469e 
                        WHERE tt-man-progda-ctrab-boin469e.cod-ctrab     = man-progda-ctrab.cod-ctrab
                          AND tt-man-progda-ctrab-boin469e.num-om-progda = man-progda-ctrab.num-om-progda) THEN NEXT.

            CREATE tt-man-progda-ctrab-boin469e.
            ASSIGN tt-man-progda-ctrab-boin469e.cod-ctrab     = man-progda-ctrab.cod-ctrab    
                   tt-man-progda-ctrab-boin469e.num-om-progda = man-progda-ctrab.num-om-progda.

            ASSIGN d-dat-inicio-parada       = man-progda-ctrab.dat-progda-inic      
                   i-qtd-segs-inicio-parada  = man-progda-ctrab.qtd-segs-progda-inic 
                   d-dat-termino-parada      = man-progda-ctrab.dat-progda-fim       
                   i-qtd-segs-termino-parada = man-progda-ctrab.qtd-segs-progda-fim.

            ASSIGN d-dat-inicio-parada = MAX(d-dat-inicio-parada,d-dat-inicio).
            IF d-dat-inicio-parada = d-dat-inicio THEN
                ASSIGN i-qtd-segs-inicio-parada = MAX(i-qtd-segs-inicio-parada,i-qtd-segs-inicio).
            
            /*Calcula a Data e Hora Minima da Parada considerando o corte de datas*/
            ASSIGN d-dat-inicio-parada = MAX(d-dat-inicio-parada,d-dat-corte).
            IF d-dat-inicio-parada = d-dat-corte THEN
                ASSIGN i-qtd-segs-inicio-parada = MAX(i-qtd-segs-inicio-parada,i-qtd-segs-corte).


            ASSIGN d-dat-termino-parada = MIN(d-dat-termino-parada,d-dat-termino).
            IF d-dat-termino-parada = d-dat-termino THEN
                ASSIGN i-qtd-segs-termino-parada = MIN(i-qtd-segs-termino-parada,i-qtd-segs-termino).


            ASSIGN de-tempo-aux1 = ?.

            IF (d-dat-inicio-parada = d-dat-termino-parada  AND i-qtd-segs-inicio-parada > i-qtd-segs-termino-parada) OR 
               (d-dat-inicio-parada > d-dat-termino-parada) THEN
                ASSIGN de-tempo-aux1 =  0.
            ELSE
                run inbo/boin469d.p (input-output c-cod-area,
                                     input-output c-gm-codigo,
                                     input        c-cod-ctrab,
                                     input-output c-cod-calend,
                                     Input-output d-dat-termino-parada,
                                     Input-output i-qtd-segs-termino-parada,
                                     Input-output d-dat-inicio-parada,
                                     Input-output i-qtd-segs-inicio-parada,
                                     Input-output de-tempo-aux1).
            IF de-tempo-aux1 <> ? THEN
                ASSIGN de-tempo = de-tempo + de-tempo-aux1.
        END.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCalculaParadaReal DBOFunction 
PROCEDURE piCalculaParadaReal :
/*------------------------------------------------------------------------------
  Purpose:     Calcula Data e Hora In°cio / Data e Hora Termino
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT        PARAMETER c-cod-area         LIKE area-produc.cod-area     NO-UNDO.
    DEF INPUT        PARAMETER c-gm-codigo        LIKE grup-maquina.gm-codigo   NO-UNDO.
    DEF INPUT        PARAMETER c-cod-ctrab        LIKE split-operac.cod-ctrab   NO-UNDO.
    DEF INPUT        PARAMETER c-cod-calend       LIKE area-produc.cd-calen     NO-UNDO.
    DEF INPUT-OUTPUT PARAMETER d-dat-termino      AS DATE FORMAT "99/99/9999":U NO-UNDO.
    DEF INPUT-OUTPUT PARAMETER i-qtd-segs-termino AS DECIMAL DECIMALS 0         NO-UNDO.
    DEF INPUT-OUTPUT PARAMETER d-dat-inicio       AS DATE FORMAT "99/99/9999":U NO-UNDO.
    DEF INPUT-OUTPUT PARAMETER i-qtd-segs-inicio  AS DECIMAL DECIMALS 0         NO-UNDO.
    DEF INPUT-OUTPUT PARAMETER de-tempo           AS DECIMAL DECIMALS 4         NO-UNDO.
    DEF INPUT        PARAMETER d-dat-corte        AS DATE FORMAT "99/99/9999":U NO-UNDO.
    DEF INPUT        PARAMETER i-qtd-segs-corte   AS DECIMAL DECIMALS 0         NO-UNDO.
    
    DEF VAR de-tempo-aux1 AS DECIMAL DECIMALS 4       NO-UNDO.
    
    DEF VAR d-dat-termino-parada      AS DATE FORMAT "99/99/9999":U NO-UNDO.
    DEF VAR i-qtd-segs-termino-parada AS DECIMAL DECIMALS 0         NO-UNDO.
    DEF VAR d-dat-inicio-parada       AS DATE FORMAT "99/99/9999":U NO-UNDO.
    DEF VAR i-qtd-segs-inicio-parada  AS DECIMAL DECIMALS 0         NO-UNDO.

    DEF VAR v-val-refer-inic          LIKE rep-parada-ctrab.val-refer-inic-parada NO-UNDO.

    ASSIGN de-tempo = 0.

    run pi-converte-data-segs-valor (input d-dat-inicio - 180,
                                     input 0,
                                     output v-val-refer-inic).

    FOR EACH rep-parada-ctrab NO-LOCK USE-INDEX id
        WHERE rep-parada-ctrab.cod-ctrab               = c-cod-ctrab
          AND rep-parada-ctrab.val-refer-inic-parada  >= v-val-refer-inic:
        IF (rep-parada-ctrab.dat-inic-parada >= d-dat-inicio    AND
            rep-parada-ctrab.dat-inic-parada <= d-dat-termino)  OR
           (rep-parada-ctrab.dat-inic-parada <= d-dat-inicio    AND
            rep-parada-ctrab.dat-fim-parada  >= d-dat-termino ) OR
           (rep-parada-ctrab.dat-inic-parada >= d-dat-inicio    AND
            rep-parada-ctrab.dat-fim-parada  <= d-dat-termino ) OR
           (rep-parada-ctrab.dat-inic-parada <= d-dat-inicio    AND
            rep-parada-ctrab.dat-fim-parada  >= d-dat-termino) THEN DO:

            IF CAN-FIND(FIRST tt-rep-parada-ctrab-boin469e
                        WHERE tt-rep-parada-ctrab-boin469e.cod-ctrab             = rep-parada-ctrab.cod-ctrab
                          AND tt-rep-parada-ctrab-boin469e.val-refer-inic-parada = rep-parada-ctrab.val-refer-inic-parada) THEN NEXT.


            CREATE tt-rep-parada-ctrab-boin469e.
            ASSIGN tt-rep-parada-ctrab-boin469e.cod-ctrab             = rep-parada-ctrab.cod-ctrab            
                   tt-rep-parada-ctrab-boin469e.val-refer-inic-parada = rep-parada-ctrab.val-refer-inic-parada.

            ASSIGN d-dat-inicio-parada       = rep-parada-ctrab.dat-inic-parada      
                   i-qtd-segs-inicio-parada  = rep-parada-ctrab.qtd-segs-inic 
                   d-dat-termino-parada      = rep-parada-ctrab.dat-fim-parada       
                   i-qtd-segs-termino-parada = rep-parada-ctrab.qtd-segs-fim.

            ASSIGN d-dat-inicio-parada = MAX(d-dat-inicio-parada,d-dat-inicio).
            IF d-dat-inicio-parada = d-dat-inicio THEN
                ASSIGN i-qtd-segs-inicio-parada = MAX(i-qtd-segs-inicio-parada,i-qtd-segs-inicio).
            
            ASSIGN d-dat-termino-parada = MIN(d-dat-termino-parada,d-dat-termino).
            IF d-dat-termino-parada = d-dat-termino THEN
                ASSIGN i-qtd-segs-termino-parada = MIN(i-qtd-segs-termino-parada,i-qtd-segs-termino).

            /*Calcula a Data e Hora Minima da Parada considerando o corte de datas*/
            ASSIGN d-dat-termino-parada = MIN(d-dat-termino-parada,d-dat-corte).
            IF d-dat-termino-parada = d-dat-corte THEN
                ASSIGN i-qtd-segs-termino-parada = MIN(i-qtd-segs-termino-parada,i-qtd-segs-corte).

            ASSIGN de-tempo-aux1 = ?.

            IF (d-dat-inicio-parada = d-dat-termino-parada  AND i-qtd-segs-inicio-parada > i-qtd-segs-termino-parada) OR 
               (d-dat-inicio-parada > d-dat-termino-parada) THEN
                ASSIGN de-tempo-aux1 =  0.
            ELSE
                run inbo/boin469d.p (input-output c-cod-area,
                                     input-output c-gm-codigo,
                                     input        c-cod-ctrab,
                                     input-output c-cod-calend,
                                     Input-output d-dat-termino-parada,
                                     Input-output i-qtd-segs-termino-parada,
                                     Input-output d-dat-inicio-parada,
                                     Input-output i-qtd-segs-inicio-parada,
                                     Input-output de-tempo-aux1).
            IF de-tempo-aux1 <> ? THEN
                ASSIGN de-tempo = de-tempo + de-tempo-aux1.
        END.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

