/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0513RP 2.00.00.003 } /*** "010003" 03/03/2025 09:11:43  ***/

/*&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AQ0513RP MAQ}
&ENDIF
*/
/******************************************************************************
**
**  Programa: AQ0513RP
**
**  Data....: Julho de 2017
**
**  Objetivo: Relat¢rio Informa‡äes para Minist‚rio Agricultura
**
**  Versao..: 
**         
******************************************************************************/

/* pr?-processador para setar o tamanho da p gina */
&SCOPED-DEFINE pagesize 67 

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino              AS INTEGER
    FIELD execucao             AS INTEGER
    FIELD arquivo              AS CHAR format "x(35)":U
    FIELD usuario              AS CHAR format "x(12)":U
    FIELD data-exec            AS DATE
    FIELD hora-exec            AS INTEGER
    FIELD cod-rota-ini         AS CHARACTER
    FIELD cod-rota-fim         AS CHARACTER
    FIELD cdn-grp-produt-ini   AS INTEGER 
    FIELD cdn-grp-produt-fim   AS INTEGER 
    FIELD cdn-produt-rural-ini AS INTEGER 
    FIELD cdn-produt-rural-fim AS INTEGER 
    FIELD cod-estabel          AS CHARACTER
    FIELD period               AS CHARACTER FORMAT "99/9999"
    FIELD it-codigo            AS CHARACTER.
    
DEFINE TEMP-TABLE tt_produtor NO-UNDO
    FIELD cdn_produt_rural     AS INTEGER
    FIELD nome_produt          AS CHARACTER
    FIELD desc_rota            AS CHARACTER
    FIELD cod_estabel          AS CHARACTER
    FIELD cod_propried         AS CHAR
    FIELD cod_inscr_imob_rural AS CHARACTER /*propried-rural.cod-inscr-imob-rural*/
    FIELD cod_rota_princ       AS CHARACTER /*propried-rural.cod-rota-princ*/
    FIELD dat_coleta           AS DATE  
    FIELD coleta               AS INTEGER EXTENT 31
    FIELD total_coleta         AS INTEGER.
    
DEFINE TEMP-TABLE tt-produt-carg NO-UNDO 
    FIELD cdn-produt-rural     LIKE produt-carg.cdn-produt-rural 
    FIELD cod-estabel          LIKE produt-carg.cod-estabel      
    FIELD cod-propried         LIKE produt-carg.cod-propried     
    FIELD dat-coleta           LIKE produt-carg.dat-coleta       
    FIELD qtd-coleta           LIKE produt-carg.qtd-coleta 
    FIELD num-carg             LIKE produt-carg.num-carg
    FIELD cod-rota             LIKE rota-coleta.cod-rota
    FIELD des-rota             LIKE rota-coleta.des-rota
    FIELD nome-produt          LIKE emitente.nome-emit
    FIELD cod-inscr-imob-rural LIKE propried-rural.cod-inscr-imob-rural      
    FIELD dia                  AS INTEGER.    

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD id         AS INTEGER.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.    

DEFINE VARIABLE h-acomp           AS HANDLE  NO-UNDO.    
DEFINE VARIABLE iDia              AS INTEGER NO-UNDO.
DEFINE VARIABLE dt-dat-trans-ini  AS DATE    NO-UNDO.
DEFINE VARIABLE dt-dat-trans-fim  AS DATE    NO-UNDO.
DEFINE VARIABLE i-tot-quinzena    AS INTEGER NO-UNDO.

{utp/ut-glob.i}
{utp/ut-report-api.i}

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

FIND FIRST tt-param NO-ERROR.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.

/* executando de forma persistente o utilit rio de acompanhamento */
IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    
{include/i-rpvar.i}
{include/i-rpcab.i}

{include/i-rpout.i}

{utp/ut-liter.i Imprimindo *}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).   
 
{utp/ut-liter.i Preparando_dados.. *}
RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE).    

ASSIGN dt-dat-trans-ini = DATE("01/":U + substr(tt-param.period, 1,2) + "/" + substr(tt-param.period, 3,4) )           
       dt-dat-trans-fim = IF int(substr(tt-param.period, 1,2)) < 12 THEN
                              DATE("01/":U + string(int(substr(tt-param.period, 1,2)) + 1) + "/" + substr(tt-param.period, 3,4) ) - 1
                          ELSE 
                              DATE("31/12/" + substr(tt-param.period, 3,4)).

FOR EACH produt-carg FIELDS(dat-trans cod-estabel cdn-produt-rural num-carg cod-propried dat-coleta qtd-coleta) NO-LOCK
   WHERE produt-carg.cdn-produt-rural >= tt-param.cdn-produt-rural-ini
     AND produt-carg.cdn-produt-rural <= tt-param.cdn-produt-rural-fim
     AND produt-carg.cod-estabel       = tt-param.cod-estabel
     AND produt-carg.dat-trans        >= dt-dat-trans-ini
     AND produt-carg.dat-trans        <= dt-dat-trans-fim,
   FIRST produt-rural FIELDS (cdn-grp-produt) NO-LOCK 
   WHERE produt-rural.cdn-produt-rural = produt-carg.cdn-produt-rural,
   FIRST grp-produt FIELDS() NO-LOCK
   WHERE grp-produt.cdn-grp-produt     = produt-rural.cdn-grp-produt
     AND grp-produt.cdn-grp-produt    >= tt-param.cdn-grp-produt-ini
     AND grp-produt.cdn-grp-produt    <= tt-param.cdn-grp-produt-fim
    BREAK BY produt-carg.cdn-produt-rural :

    IF produt-carg.qtd-coleta = 0 THEN NEXT.

    FOR FIRST carg-rural FIELDS(cod-rota dat-trans) NO-LOCK
        WHERE carg-rural.num-carg  = produt-carg.num-carg
          AND carg-rural.it-codigo = tt-param.it-codigo
          AND carg-rural.cod-rota >= tt-param.cod-rota-ini
          AND carg-rural.cod-rota <= tt-param.cod-rota-fim: END.
    IF NOT AVAIL carg-rural THEN NEXT.

    CREATE tt-produt-carg.
    ASSIGN tt-produt-carg.cdn-produt-rural = produt-carg.cdn-produt-rural
           tt-produt-carg.cod-estabel      = produt-carg.cod-estabel
           tt-produt-carg.cod-propried     = produt-carg.cod-propried
           tt-produt-carg.dat-coleta       = carg-rural.dat-trans
           tt-produt-carg.qtd-coleta       = produt-carg.qtd-coleta
           tt-produt-carg.dia              = day(carg-rural.dat-trans)
           tt-produt-carg.cod-rota         = carg-rural.cod-rota.

    FOR FIRST rota-coleta FIELDS(des-rota) NO-LOCK
        WHERE rota-coleta.cod-rota   = carg-rural.cod-rota:
        ASSIGN tt-produt-carg.des-rota = rota-coleta.des-rota.
    END.

    FOR FIRST propried-rural FIELDS(cod-inscr-imob-rural cod-rota-princ) NO-LOCK
        WHERE propried-rural.cod-propried = produt-carg.cod-propried:
        ASSIGN tt-produt-carg.cod-inscr-imob-rural = propried-rural.cod-inscr-imob-rural.
    END.

    FOR FIRST emitente FIELDS(nome-emit) NO-LOCK
        WHERE emitente.cod-emitente = produt-carg.cdn-produt-rural:
        ASSIGN tt-produt-carg.nome-produt = emitente.nome-emit.
    END.
END. /*FOR EACH produt-carg*/   

RUN pi-desabilita-cancela IN h-acomp. 
 {utp/ut-liter.i Imprimindo *}
RUN pi-acompanhar IN h-acomp(INPUT RETURN-VALUE).

FOR EACH tt-produt-carg:        
    FIND FIRST tt_produtor NO-LOCK
         WHERE tt_produtor.cdn_produt_rural = tt-produt-carg.cdn-produt-rural 
           AND tt_produtor.cod_propried     = tt-produt-carg.cod-propried NO-ERROR.

    IF NOT AVAIL tt_produtor THEN DO:
          CREATE tt_produtor.
          ASSIGN tt_produtor.cdn_produt_rural     = tt-produt-carg.cdn-produt-rural
                 tt_produtor.nome_produt          = tt-produt-carg.nome-produt
                 tt_produtor.cod_estabel          = tt-produt-carg.cod-estabel
                 tt_produtor.cod_propried         = tt-produt-carg.cod-propried
                 tt_produtor.dat_coleta           = tt-produt-carg.dat-coleta
                 tt_produtor.cod_rota_princ             = tt-produt-carg.cod-rota
                 tt_produtor.desc_rota            = tt-produt-carg.des-rota
                 tt_produtor.cod_inscr_imob_rural = tt-produt-carg.cod-inscr-imob-rural.

         DO iDia = 1 TO 31:
             IF tt-produt-carg.dia = iDia THEN
                ASSIGN tt_produtor.coleta[iDia] = tt-produt-carg.qtd-coleta
                       tt_produtor.total_coleta = tt-produt-carg.qtd-coleta.
         END.
    END.
    ELSE
        DO iDia = 1 TO 31:
            IF tt-produt-carg.dia = iDia THEN DO:
                ASSIGN tt_produtor.coleta[iDia] = tt_produtor.coleta[iDia] + tt-produt-carg.qtd-coleta
                       tt_produtor.total_coleta = tt_produtor.total_coleta + tt-produt-carg.qtd-coleta.
            END.
        END.
END. /*FOR EACH tt-produt-carg*/       

PUT SKIP(5).

FOR EACH tt_produtor NO-LOCK
      BY tt_produtor.nome_produt:

    PUT tt_produtor.nome_produt          FORMAT "x(50)"         AT 10
        tt_produtor.cod_inscr_imob_rural FORMAT "9999999999999" AT 60
        tt-param.period                                         AT 80 SKIP(1).

    ASSIGN i-tot-quinzena = tt_produtor.coleta[1]  + tt_produtor.coleta[2]  + tt_produtor.coleta[3]  + tt_produtor.coleta[4]  + tt_produtor.coleta[5]  +
                            tt_produtor.coleta[6]  + tt_produtor.coleta[7]  + tt_produtor.coleta[8]  + tt_produtor.coleta[9]  + tt_produtor.coleta[10] +
                            tt_produtor.coleta[11] + tt_produtor.coleta[12] + tt_produtor.coleta[13] + tt_produtor.coleta[14] + tt_produtor.coleta[15].

    PUT tt_produtor.coleta[1]    FORMAT ">>>9"  AT 01 
        tt_produtor.coleta[2]    FORMAT ">>>9"  AT 06 
        tt_produtor.coleta[3]    FORMAT ">>>9"  AT 11 
        tt_produtor.coleta[4]    FORMAT ">>>9"  AT 16 
        tt_produtor.coleta[5]    FORMAT ">>>9"  AT 21 
        tt_produtor.coleta[6]    FORMAT ">>>9"  AT 26 
        tt_produtor.coleta[7]    FORMAT ">>>9"  AT 31 
        tt_produtor.coleta[8]    FORMAT ">>>9"  AT 36 
        tt_produtor.coleta[9]    FORMAT ">>>9"  AT 41 
        tt_produtor.coleta[10]   FORMAT ">>>9"  AT 46 
        tt_produtor.coleta[11]   FORMAT ">>>9"  AT 51 
        tt_produtor.coleta[12]   FORMAT ">>>9"  AT 56 
        tt_produtor.coleta[13]   FORMAT ">>>9"  AT 61 
        tt_produtor.coleta[14]   FORMAT ">>>9"  AT 66 
        tt_produtor.coleta[15]   FORMAT ">>>9"  AT 71 
        i-tot-quinzena           FORMAT ">>>>9" AT 81 SKIP(1).

    ASSIGN i-tot-quinzena = tt_produtor.coleta[16] + tt_produtor.coleta[17] + tt_produtor.coleta[18] + tt_produtor.coleta[19] + tt_produtor.coleta[20] +
                            tt_produtor.coleta[21] + tt_produtor.coleta[22] + tt_produtor.coleta[23] + tt_produtor.coleta[24] + tt_produtor.coleta[25] +
                            tt_produtor.coleta[26] + tt_produtor.coleta[27] + tt_produtor.coleta[28] + tt_produtor.coleta[29] + tt_produtor.coleta[30] +
                            tt_produtor.coleta[31].

    PUT tt_produtor.coleta[16]   FORMAT ">>>9"  AT 01 
        tt_produtor.coleta[17]   FORMAT ">>>9"  AT 06 
        tt_produtor.coleta[18]   FORMAT ">>>9"  AT 11 
        tt_produtor.coleta[19]   FORMAT ">>>9"  AT 16 
        tt_produtor.coleta[20]   FORMAT ">>>9"  AT 21 
        tt_produtor.coleta[21]   FORMAT ">>>9"  AT 26 
        tt_produtor.coleta[22]   FORMAT ">>>9"  AT 31 
        tt_produtor.coleta[23]   FORMAT ">>>9"  AT 36 
        tt_produtor.coleta[24]   FORMAT ">>>9"  AT 41 
        tt_produtor.coleta[25]   FORMAT ">>>9"  AT 46 
        tt_produtor.coleta[26]   FORMAT ">>>9"  AT 51 
        tt_produtor.coleta[27]   FORMAT ">>>9"  AT 56 
        tt_produtor.coleta[28]   FORMAT ">>>9"  AT 61 
        tt_produtor.coleta[29]   FORMAT ">>>9"  AT 66 
        tt_produtor.coleta[30]   FORMAT ">>>9"  AT 71 
        tt_produtor.coleta[31]   FORMAT ">>>9"  AT 76 
        i-tot-quinzena           FORMAT ">>>>9" AT 81
        tt_produtor.total_coleta FORMAT ">>>>9" AT 87 SKIP(2).

    IF LINE-COUNTER >= (PAGE-SIZE - 5) THEN DO:
        PAGE.
        PUT " " SKIP(5).
    END.
END.

RUN pi-finalizar IN h-acomp.

{include/i-rpclo.i}

RETURN "OK".
