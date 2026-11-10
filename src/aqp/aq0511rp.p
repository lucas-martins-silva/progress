/********************************************************************************
** Copyright TOTVS S.A. (2016)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0511RP 2.00.00.007 } /*** 010007 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0511RP MAQ}
&ENDIF

{aqp/aq0511.i} /*Defini‡Æo da tt-param*/

/* recebimento de parƒmetros */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

DEFINE TEMP-TABLE tt-produt-carg NO-UNDO 
    FIELD cdn-produt-rural     LIKE produt-carg.cdn-produt-rural 
    FIELD cod-estabel          LIKE produt-carg.cod-estabel      
    FIELD cod-propried         LIKE produt-carg.cod-propried
    FIELD cod-pto-coleta       LIKE produt-carg.cod-pto-coleta
    FIELD dat-coleta           LIKE produt-carg.dat-coleta       
    FIELD qtd-coleta           LIKE produt-carg.qtd-coleta 
    FIELD num-carg             LIKE produt-carg.num-carg
    FIELD cod-rota             LIKE rota-coleta.cod-rota
    FIELD des-rota             LIKE rota-coleta.des-rota
    FIELD nome-produt          LIKE emitente.nome-emit
    FIELD cod-inscr-imob-rural LIKE propried-rural.cod-inscr-imob-rural      
    FIELD dia                  AS INTEGER
    FIELD cdn-grp-produt       AS INTEGER
    FIELD des-grp-produt       AS CHARACTER
    FIELD des-propried         AS CHAR.
 
DEFINE VARIABLE dt-dat-trans-ini  AS DATE    NO-UNDO.
DEFINE VARIABLE dt-dat-trans-fim  AS DATE    NO-UNDO.
DEFINE VARIABLE iDia              AS INTEGER NO-UNDO.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

RUN pi-range-data-periodo IN THIS-PROCEDURE(INPUT tt-param.period, OUTPUT dt-dat-trans-ini, OUTPUT dt-dat-trans-fim).


FOR EACH produt-carg FIELDS(dat-trans cod-estabel  cdn-produt-rural cod-pto-coleta
                            num-carg  cod-propried dat-coleta qtd-coleta) NO-LOCK
   WHERE produt-carg.cdn-produt-rural  >= tt-param.cdn-produt-rural-ini
      AND produt-carg.cdn-produt-rural <= tt-param.cdn-produt-rural-fim
      AND produt-carg.cod-pto-coleta   >= tt-param.cod-pto-coleta-ini
      AND produt-carg.cod-pto-coleta   <= tt-param.cod-pto-coleta-fim
      AND produt-carg.cod-estabel       = tt-param.cod-estabel
      AND produt-carg.dat-trans        >= dt-dat-trans-ini
      AND produt-carg.dat-trans        <= dt-dat-trans-fim,
    FIRST produt-rural FIELDS (cdn-grp-produt) NO-LOCK 
    WHERE produt-rural.cdn-produt-rural = produt-carg.cdn-produt-rural,
        FIRST grp-produt FIELDS(cdn-grp-produt des-grp-produt) NO-LOCK
            WHERE grp-produt.cdn-grp-produt  = produt-rural.cdn-grp-produt
              AND grp-produt.cdn-grp-produt >= tt-param.cdn-grp-produt-ini
              AND grp-produt.cdn-grp-produt <= tt-param.cdn-grp-produt-fim
            BREAK BY produt-carg.cdn-produt-rural:

    IF NOT tt-param.list-qtd-zerada AND produt-carg.qtd-coleta <= 0 THEN
        NEXT.

    FOR FIRST carg-rural FIELDS(cod-rota dat-trans) NO-LOCK
        WHERE carg-rural.num-carg   = produt-carg.num-carg
          AND carg-rural.it-codigo  = tt-param.it-codigo
          AND carg-rural.cod-rota  >= tt-param.cod-rota-ini
          AND carg-rural.cod-rota  <= tt-param.cod-rota-fim:
    END.

    IF NOT AVAIL carg-rural THEN NEXT.

    CREATE tt-produt-carg.
    ASSIGN tt-produt-carg.cdn-produt-rural = produt-carg.cdn-produt-rural
           tt-produt-carg.cod-estabel      = produt-carg.cod-estabel
           tt-produt-carg.cod-propried     = produt-carg.cod-propried
           tt-produt-carg.cod-pto-coleta   = produt-carg.cod-pto-coleta 
           tt-produt-carg.dat-coleta       = carg-rural.dat-trans
           tt-produt-carg.qtd-coleta       = produt-carg.qtd-coleta
           tt-produt-carg.dia              = DAY(carg-rural.dat-trans)
           tt-produt-carg.cod-rota         = carg-rural.cod-rota
           tt-produt-carg.cdn-grp-produt   = grp-produt.cdn-grp-produt
           tt-produt-carg.des-grp-produt   = grp-produt.des-grp-produt.

    FOR FIRST rota-coleta FIELDS(des-rota) NO-LOCK
        WHERE rota-coleta.cod-rota     = carg-rural.cod-rota:
        ASSIGN tt-produt-carg.des-rota = rota-coleta.des-rota.
    END.

    FOR FIRST propried-rural FIELDS(cod-inscr-imob-rural cod-rota-princ cod-propried des-propried) NO-LOCK
        WHERE propried-rural.cod-propried = produt-carg.cod-propried:

        ASSIGN tt-produt-carg.cod-inscr-imob-rural = propried-rural.cod-inscr-imob-rural
               tt-produt-carg.cod-propried         = propried-rural.cod-propried
               tt-produt-carg.des-propried         = propried-rural.des-propried.
    END.

    FOR FIRST emitente FIELDS(nome-emit) NO-LOCK
        WHERE emitente.cod-emitente = produt-carg.cdn-produt-rural:
        ASSIGN tt-produt-carg.nome-produt = emitente.nome-emit.
    END.

END.    

FOR EACH tt-produt-carg:        
    FIND FIRST tt-produtor NO-LOCK
         WHERE tt-produtor.cdn-produt-rural = tt-produt-carg.cdn-produt-rural 
           AND tt-produtor.cod-propried     = tt-produt-carg.cod-propried NO-ERROR.

    IF NOT AVAIL(tt-produtor) THEN DO:
    
          CREATE tt-produtor.
          ASSIGN tt-produtor.cdn-produt-rural     = tt-produt-carg.cdn-produt-rural
                 tt-produtor.nome-produt          = tt-produt-carg.nome-produt
                 tt-produtor.cod-estabel          = tt-produt-carg.cod-estabel
                 tt-produtor.cod-propried         = tt-produt-carg.cod-propried
                 tt-produtor.cod-pto-coleta       = tt-produt-carg.cod-pto-coleta
                 tt-produtor.dat-coleta           = tt-produt-carg.dat-coleta
                 tt-produtor.cod-rota             = tt-produt-carg.cod-rota
                 tt-produtor.desc-rota            = tt-produt-carg.des-rota
                 tt-produtor.cod-inscr-imob-rural = tt-produt-carg.cod-inscr-imob-rural
                 tt-produtor.cdn-grp-produt       = tt-produt-carg.cdn-grp-produt
                 tt-produtor.des-grp-produt       = tt-produt-carg.des-grp-produt
                 tt-produtor.cod-propried         = tt-produt-carg.cod-propried 
                 tt-produtor.des-propried         = tt-produt-carg.des-propried. 

         DO iDia = 1 TO 31:
             IF tt-produt-carg.dia = iDia THEN DO:
                ASSIGN tt-produtor.coleta[iDia] = tt-produt-carg.qtd-coleta
                       tt-produtor.total-coleta = tt-produt-carg.qtd-coleta.
             END.
         END.
    END.
    ELSE DO:
        DO iDia = 1 TO 31:
            IF tt-produt-carg.dia = iDia THEN DO:
                ASSIGN tt-produtor.coleta[iDia] = tt-produtor.coleta[iDia] + tt-produt-carg.qtd-coleta
                       tt-produtor.total-coleta = tt-produtor.total-coleta + tt-produt-carg.qtd-coleta.
            END.
        END.
    END.
END.

IF  tt-param.destino = 2  THEN DO:
    RUN aqp/aq0511a.p (INPUT TABLE tt-produtor, 
                       INPUT TABLE tt-param).
END.






/*PROCEDURES INTERNAS*/

PROCEDURE pi-range-data-periodo:
/* ---------------------------------------------------------------------------
  Purpose: Alimenta variaveis do range de data de transa‡Æo por per¡odo
               
  Parameters:  
  Notes:
---------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-period         AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-dat-trans-ini AS DATE      NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-dat-trans-fim AS DATE      NO-UNDO.
    
    DEFINE VARIABLE c-period AS CHARACTER NO-UNDO.     

    assign c-period  = pc-period 
           pdt-dat-trans-ini = DATE("01/":U + substr(c-period, 1,2) + "/" + substr(c-period, 4,4) )           
           pdt-dat-trans-fim = IF int(substr(c-period, 1,2)) < 12 THEN
                                   DATE("01/":U + string(int(substr(c-period, 1,2)) + 1) + "/" + substr(c-period, 4,4) ) - 1
                               ELSE 
                                   DATE("31/12/" + substr(c-period, 4,4)).


    RETURN "OK":U.
END PROCEDURE.

/*********************/