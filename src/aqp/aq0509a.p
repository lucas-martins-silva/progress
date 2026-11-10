 {utp/ut-report-api.i}
 
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
 
DEFINE VARIABLE iDia AS INTEGER NO-UNDO.

DEFINE TEMP-TABLE tt_estabelec NO-UNDO
    FIELD cod_estabel   AS CHARACTER
    FIELD nome          AS CHARACTER
    FIELD endereco      AS CHARACTER
    FIELD cidade        AS CHARACTER 
    FIELD estado        AS CHARACTER
    FIELD cgc           AS CHARACTER
    FIELD ins_estadual  AS CHARACTER
    FIELD periodo       AS CHARACTER
    FIELD telefone      AS CHARACTER
    FIELD nr_mapa       AS CHARACTER. 
     
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
    
    
DEFINE DATASET DSrelatorio
    FOR tt_estabelec, tt_produtor    
    DATA-RELATION produtores FOR tt_estabelec, tt_produtor            
        RELATION-FIELDS (cod_estabel, cod_estabel) NESTED .

DEFINE VARIABLE lc_data AS LONGCHAR     NO-UNDO.   

PROCEDURE getReportData:

    DEFINE INPUT PARAMETER TABLE FOR ttReport.
    DEFINE INPUT PARAMETER TABLE FOR tt-param.
    
    DEFINE OUTPUT PARAM DATASET  FOR DSrelatorio.
    DEFINE OUTPUT PARAM TABLE    FOR RowErrors.
    
    DEFINE VARIABLE dt-dat-trans-ini  AS DATE  NO-UNDO.
    DEFINE VARIABLE dt-dat-trans-fim  AS DATE  NO-UNDO.

    FIND FIRST tt-param NO-ERROR.
    IF NOT AVAIL tt-param THEN RETURN "NOK":U.
    
    RUN pi-range-data-periodo IN THIS-PROCEDURE(INPUT tt-param.period, OUTPUT dt-dat-trans-ini, OUTPUT dt-dat-trans-fim).    
    
    FOR FIRST estabelec FIELDS (cod-estabel nome endereco cidade estado cgc ins-estadual) NO-LOCK
        WHERE estabelec.cod-estabel = tt-param.cod-estabel:
            
        CREATE tt_estabelec.
        ASSIGN tt_estabelec.cod_estabel  = estabelec.cod-estabel
               tt_estabelec.nome         = estabelec.nome
               tt_estabelec.endereco     = estabelec.endereco
               tt_estabelec.cidade       = estabelec.cidade
               tt_estabelec.estado       = estabelec.estado
               tt_estabelec.cgc          = STRING(estabelec.cgc, '99.999.999/9999-99')
               tt_estabelec.ins_estadual = estabelec.ins-estadual
               tt_estabelec.periodo      = SUBSTR(tt-param.period, 1, 2) + "/" + SUBSTR(tt-param.period, 3, 4)
               tt_estabelec.nr_mapa      = tt-param.period.

        FOR FIRST estab-mat FIELDS(cod-emitente) NO-LOCK
            WHERE estab-mat.cod-estabel = estabelec.cod-estabel:            
            FOR FIRST cont-emit FIELDS(telefone) NO-LOCK
                WHERE cont-emit.cod-emitente  = estab-mat.cod-emitente
                  AND cont-emit.telefone     <> "":
                ASSIGN tt_estabelec.telefone = cont-emit.telefone.              
            END.            
        END.

        FOR EACH produt-carg FIELDS(dat-trans cod-estabel  cdn-produt-rural 
                                    num-carg  cod-propried dat-coleta qtd-coleta) NO-LOCK
           WHERE produt-carg.cdn-produt-rural  >= tt-param.cdn-produt-rural-ini
              AND produt-carg.cdn-produt-rural <= tt-param.cdn-produt-rural-fim
              AND produt-carg.cod-estabel       = tt-param.cod-estabel
              AND produt-carg.dat-trans        >= dt-dat-trans-ini
              AND produt-carg.dat-trans        <= dt-dat-trans-fim,
            FIRST produt-rural FIELDS (cdn-grp-produt) NO-LOCK 
            WHERE produt-rural.cdn-produt-rural = produt-carg.cdn-produt-rural,
            FIRST grp-produt FIELDS() NO-LOCK
            WHERE grp-produt.cdn-grp-produt  = produt-rural.cdn-grp-produt
              AND grp-produt.cdn-grp-produt >= tt-param.cdn-grp-produt-ini
              AND grp-produt.cdn-grp-produt <= tt-param.cdn-grp-produt-fim
              BREAK BY produt-carg.cdn-produt-rural :
              
            IF produt-carg.qtd-coleta = 0 THEN NEXT.
         

            FOR FIRST carg-rural FIELDS(cod-rota dat-trans) NO-LOCK
                WHERE carg-rural.num-carg = produt-carg.num-carg
                  AND carg-rural.it-codigo = tt-param.it-codigo
                  AND carg-rural.cod-rota >= tt-param.cod-rota-ini
                  AND carg-rural.cod-rota <= tt-param.cod-rota-fim:
            END.

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
        END.    

        FOR EACH tt-produt-carg:        
            FIND FIRST tt_produtor NO-LOCK
                 WHERE tt_produtor.cdn_produt_rural = tt-produt-carg.cdn-produt-rural 
                   AND tt_produtor.cod_propried     = tt-produt-carg.cod-propried NO-ERROR.

            IF NOT AVAIL(tt_produtor) THEN DO:
            
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
                     IF tt-produt-carg.dia = iDia THEN DO:
                        ASSIGN tt_produtor.coleta[iDia] = tt-produt-carg.qtd-coleta
                               tt_produtor.total_coleta = tt-produt-carg.qtd-coleta.
                     END.
                 END.
            END.
            ELSE DO:
                DO iDia = 1 TO 31:
                    IF tt-produt-carg.dia = iDia THEN DO:
                        ASSIGN tt_produtor.coleta[iDia] = tt_produtor.coleta[iDia] + tt-produt-carg.qtd-coleta
                               tt_produtor.total_coleta = tt_produtor.total_coleta + tt-produt-carg.qtd-coleta.
                    END.
                END.
            END.
        END.        
    END.
    
    RETURN "OK":U.
    
END PROCEDURE.  


/* Implementa‡Æo da fun‡Æo getReportDataRPW conforme sugestÆo. */
PROCEDURE getReportDataRPW:
    
    DEFINE INPUT PARAMETER TABLE FOR ttReport.
    DEFINE INPUT PARAMETER TABLE FOR tt-param.
    
    DEFINE OUTPUT PARAM lc_data  AS LONGCHAR NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR RowErrors.

    RUN getReportData IN THIS-PROCEDURE (INPUT TABLE ttReport, INPUT TABLE tt-param, OUTPUT DATASET DSrelatorio, OUTPUT TABLE RowErrors).
    IF RETURN-VALUE = "NOK" THEN 
        RETURN "NOK":U.

    DATASET DSrelatorio:WRITE-JSON('LONGCHAR':U, lc_data).
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-range-data-periodo:
/* ---------------------------------------------------------------------------
  Purpose: Alimenta variaveis do range de data de transação por período
               
  Parameters:  
  Notes:
---------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-period         AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-dat-trans-ini AS DATE      NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-dat-trans-fim AS DATE      NO-UNDO.
    
    DEFINE VARIABLE c-period AS CHARACTER NO-UNDO.     
    
    assign c-period  = pc-period 
           pdt-dat-trans-ini = DATE("01/":U + substr(c-period, 1,2) + "/" + substr(c-period, 3,4) )           
           pdt-dat-trans-fim = DATE("01/":U + string(int(substr(c-period, 1,2)) + 1) + "/" + substr(c-period, 3,4) ) - 1.
           
    RETURN "OK":U.
END PROCEDURE.
