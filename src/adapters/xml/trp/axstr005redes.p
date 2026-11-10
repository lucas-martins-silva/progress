/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSTR005REDES 2.00.00.010 } /*** 010010 ***/
{cdp/cdcfgdis.i}   
    
DEFINE TEMP-TABLE ttRedispatchCarrier NO-UNDO
     FIELD DocumentNumber AS CHARACTER INITIAL ?  /*N£mero do documento de nota fiscal. (Uso interno: Campo = movdis.nota-fisc-redesp.cod-nota-fisc)*/
     FIELD DocumentSeries AS CHARACTER INITIAL ?  /*N£mero de S‚rie do documento de Nota Fiscal. (Uso interno: Campo = movdis.nota-fisc-redesp.cod-ser-nf)*/
     FIELD RedispatchCarrierCity AS INTEGER EXTENT 6 INITIAL ?  /*N£mero da cidade do redespachante. (Uso interno: Campo = movdis.nota-fiscal-redesp.cdn-redesp)*/
     FIELD RedispatchCarrierCode AS INTEGER EXTENT 6 INITIAL ?  /*Redespachante. (Uso interno: Campo = movdis.nota-fiscal-redesp.cdn-redesp)*/
     FIELD SiteID AS CHARACTER INITIAL ?  /*C¢digo do estabelecimento. (Uso interno: Campo = movdis.nota-fisc-redesp.cod-estabel)*/
     FIELD ttRedispatchCarrierID AS INTEGER INITIAL ?
     INDEX ixttRedispatchCarrierID IS PRIMARY UNIQUE ttRedispatchCarrierID ASCENDING
.

DEFINE TEMP-TABLE ttFreightInformations NO-UNDO
     FIELD ProductCode AS CHARACTER INITIAL ?  /*C¢digo do Produto/Classifica‡Æo de Frete. (Uso interno: Campo = mgdis.tab-generica.char-2)*/
     FIELD VehicleType AS CHARACTER INITIAL ?  /*Tipo do Ve¡culo. (Uso interno: Campo = mgdis.tab-generica.char-2)*/
     FIELD OperationType AS CHARACTER INITIAL ?  /*Tipo da Opera‡Æo. (Uso interno: Campo = mgdis.tab-generica.char-2)*/
.

DEFINE TEMP-TABLE ttFreightSimulation NO-UNDO
     FIELD SiteID             AS CHARACTER INITIAL ?   /* Estabelecimento. (Uso interno: Campo = movtrp.simul-nota-fisc.cod-estab)*/         
     FIELD DocumentSeries     AS CHARACTER INITIAL ?   /* S‚rie. (Uso interno: Campo = movtrp.simul-nota-fisc.cod-ser-nf)*/        
     FIELD DocumentNumber     AS CHARACTER INITIAL ?  /* N£mero do documento de nota fiscal. (Uso interno: Campo = movtrp.simul-nota-fisc.cod-nota-fisc)*/     
     FIELD CargoRouteNumber   AS INTEGER   INITIAL ?   /* N£mero do Percurso. (Uso interno: Campo = movtrp.simul-nota-fisc.num-percur)*/        
     FIELD CustomerTaxID      AS CHARACTER INITIAL ?   /* N£mero do Percurso. (Uso interno: Campo = movtrp.simul-nota-fisc.cod-cgc-clien)*/     
     FIELD FreightTableNumber AS INTEGER   INITIAL ?   /* N£mero da Tabela de Frete. (Uso interno: Campo = movtrp.simul-nota-fisc.num-tab-frete)*/     
     FIELD Product            AS INTEGER   INITIAL ?   /* Produto. (Uso interno: Campo = movtrp.simul-nota-fisc.cdn-produto)*/       
     FIELD ValidityDate       AS DATE      INITIAL ?   /* Data de Validade. (Uso interno: Campo = movtrp.simul-nota-fisc.dat-valid)*/         
     FIELD RouteNumber        AS INTEGER   INITIAL ?   /* Numero da Rota. (Uso interno: Campo = movtrp.simul-nota-fisc.num-rota)*/          
     FIELD TermNumber         AS INTEGER   INITIAL ?   /* Prazo. (Uso interno: Campo = movtrp.simul-nota-fisc.num-prazo)*/         
     FIELD AgreedValue        AS DECIMAL   INITIAL ?   /* Valor Combinado com o Cliente. (Uso interno: Campo = movtrp.simul-nota-fisc.val-combin-clien)*/  
     FIELD FreightUnitValue   AS DECIMAL   INITIAL ?   /* Valor Unitario do Frete. (Uso interno: Campo = movtrp.simul-nota-fisc.val-frete-unid)*/    
     FIELD FreightValue       AS DECIMAL   INITIAL ?   /* Valor do frete por valor. (Uso interno: Campo = movtrp.simul-nota-fisc.val-frete-val)*/     
     FIELD DaryValue          AS DECIMAL   INITIAL ?   /* Valor da Di ria. (Uso interno: Campo = movtrp.simul-nota-fisc.val-diaria)*/        
     FIELD ADEMEValue         AS DECIMAL   INITIAL ?   /* Valor de ADEME do conhecimento. (Uso interno: Campo = movtrp.simul-nota-fisc.val-ademe)*/         
     FIELD DispatchValue      AS DECIMAL   INITIAL ?   /* movtrp.simul-nota-fisc.val-despch. (Uso interno: Campo = movtrp.simul-nota-fisc.val-despch)*/        
     FIELD ITRValue           AS DECIMAL   INITIAL ?   /* Valor do ITR. (Uso interno: Campo = movtrp.simul-nota-fisc.val-itr)*/           
     FIELD OthersValue        AS DECIMAL   INITIAL ?   /* Valor Outros. (Uso interno: Campo = movtrp.simul-nota-fisc.val-outros)*/        
     FIELD TollValue          AS DECIMAL   INITIAL ?   /* Valor do Ped gio. (Uso interno: Campo = movtrp.simul-nota-fisc.val-pedagio)*/       
     FIELD InsuranceValue     AS DECIMAL   INITIAL ?   /* Valor do Seguro. (Uso interno: Campo = movtrp.simul-nota-fisc.val-seguro)*/        
     FIELD SUFRAMAValue       AS DECIMAL   INITIAL ?   /* Valor Suframa. (Uso interno: Campo = movtrp.simul-nota-fisc.val-suframa)*/       
     FIELD CollectionRate     AS DECIMAL   INITIAL ?   /* Taxa de Entrega. (Uso interno: Campo = movtrp.simul-nota-fisc.val-tax-coleta)*/    
     FIELD DispatchRateValue  AS DECIMAL   INITIAL ?   /* Taxa de Conhecimento. (Uso interno: Campo = movtrp.simul-nota-fisc.val-tax-conhecto)*/  
     FIELD Comments           AS CHARACTER INITIAL ?   /* Informa‡äes Adicionais. (Uso interno: Campo = movtrp.simul-nota-fisc.des-obs)*/
     FIELD ttFreightSimulationID AS INTEGER INITIAL ?
     INDEX ixttFreightSimulation IS PRIMARY UNIQUE ttFreightSimulationID ASCENDING     
.


DEFINE INPUT PARAM c-cod-estab   AS CHAR NO-UNDO.
DEFINE INPUT PARAM c-serie       AS CHAR NO-UNDO.
DEFINE INPUT PARAM c-nr-nota-fis AS CHAR FORMAT ">>>>>>9" NO-UNDO.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttRedispatchCarrier.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttFreightSimulation.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttFreightInformations.

DEF VAR h-bodi582 AS HANDLE.
DEF VAR c-char-2 AS CHAR.
DEF VAR cdn-dest LIKE cidade.cdn-munpio-ibge.
DEFINE BUFFER tr-nota-fiscal FOR nota-fiscal.
DEFINE BUFFER tr-transporte FOR transporte.
DEFINE BUFFER tr-emitente FOR emitente.

    /* Gravar o primeiro trecho que ‚ o proprio transportador */
    FIND FIRST tr-nota-fiscal
        WHERE tr-nota-fiscal.cod-estabel = c-cod-estab
          AND tr-nota-fiscal.serie = c-serie
          AND tr-nota-fiscal.nr-nota-fis = c-nr-nota-fis NO-LOCK NO-ERROR.
    IF AVAIL tr-nota-fiscal THEN DO:
    
         FOR FIRST tr-transporte FIELDS (cod-transp cgc nome-abrev) NO-LOCK 
            WHERE tr-transporte.nome-abrev = tr-nota-fiscal.nome-transp: END.
    
         FIND FIRST cidade NO-LOCK
             WHERE cidade.cidade  = tr-nota-fiscal.cidade
               AND cidade.estado  = tr-nota-fiscal.estado
               AND cidade.pais    = tr-nota-fiscal.pais NO-ERROR.
         ASSIGN cdn-dest = IF AVAIL cidade THEN cidade.cdn-munpio-ibge ELSE 0.
    
         /* A cidade ser  o destino da nota, qdo tiver somente 1 trecho. Caso tenha mais, ser  sobreposta com a cidade do pr¢ximo Redespacho */
         CREATE ttRedispatchCarrier.
         ASSIGN ttRedispatchCarrier.DocumentNumber           = tr-nota-fiscal.nr-nota-fis
                ttRedispatchCarrier.DocumentSeries           = tr-nota-fiscal.serie    
                ttRedispatchCarrier.SiteID                   = tr-nota-fiscal.cod-estabel
                ttRedispatchCarrier.RedispatchCarrierCity[1] = cdn-dest.

         IF tr-transporte.cgc <> "" OR tr-transporte.cgc <> FILL("0", LENGTH(tr-transporte.cgc)) THEN DO:
            FIND FIRST tr-emitente WHERE tr-emitente.cgc = tr-transporte.cgc NO-LOCK NO-ERROR.
                ASSIGN ttRedispatchCarrier.RedispatchCarrierCode[1] = IF AVAIL tr-emitente THEN tr-emitente.cod-emitente
                                                                      ELSE tr-transporte.cod-transp.
         END.
         ELSE DO:
            FIND FIRST tr-emitente WHERE tr-emitente.nome-abrev = tr-transporte.nome-abrev NO-LOCK NO-ERROR.
                ASSIGN ttRedispatchCarrier.RedispatchCarrierCode[1] = IF AVAIL tr-emitente THEN tr-emitente.cod-emitente
                                                                      ELSE tr-transporte.cod-transp.
         END.

         ASSIGN ttRedispatchCarrier.RedispatchCarrierCode[2] = 0
                ttRedispatchCarrier.RedispatchCarrierCity[2] = 0
                ttRedispatchCarrier.RedispatchCarrierCode[3] = 0
                ttRedispatchCarrier.RedispatchCarrierCity[3] = 0
                ttRedispatchCarrier.RedispatchCarrierCode[4] = 0
                ttRedispatchCarrier.RedispatchCarrierCity[4] = 0
                ttRedispatchCarrier.RedispatchCarrierCode[5] = 0
                ttRedispatchCarrier.RedispatchCarrierCity[5] = 0
                ttRedispatchCarrier.RedispatchCarrierCode[6] = 0
                ttRedispatchCarrier.RedispatchCarrierCity[6] = 0.

         IF tr-nota-fiscal.nome-tr-red <> "" THEN DO:
             IF NOT CAN-FIND (FIRST nota-fisc-redesp NO-LOCK
               WHERE nota-fisc-redesp.cod-nota-fisc = c-nr-nota-fis
               AND   nota-fisc-redesp.cod-ser-nf    = c-serie      
               AND   nota-fisc-redesp.cod-estab     = c-cod-estab) THEN DO:

                  FOR FIRST tr-transporte NO-LOCK 
                    WHERE tr-transporte.nome-abrev = tr-nota-fiscal.nome-tr-red: END.

                  FIND FIRST cidade NO-LOCK
                    WHERE cidade.cidade  = tr-transporte.cidade
                      AND cidade.estado  = tr-transporte.estado
                      AND cidade.pais    = tr-transporte.pais NO-ERROR.

                 find first tr-emitente where tr-emitente.cgc = tr-transporte.cgc no-lock no-error.
                 
                 ASSIGN ttRedispatchCarrier.RedispatchCarrierCity[1] = IF AVAIL cidade THEN cidade.cdn-munpio-ibge ELSE 0
                        ttRedispatchCarrier.RedispatchCarrierCode[2] =  IF AVAIL tr-emitente THEN tr-emitente.cod-emitente
                                                                        ELSE tr-transporte.cod-transp.
                        ttRedispatchCarrier.RedispatchCarrierCity[2] = cdn-dest.

               END.
         END.
    END.

    IF CAN-FIND (FIRST nota-fisc-redesp) THEN DO:
        FOR EACH nota-fisc-redesp NO-LOCK
           WHERE nota-fisc-redesp.cod-nota-fisc = c-nr-nota-fis
           AND   nota-fisc-redesp.cod-ser-nf    = c-serie      
           AND   nota-fisc-redesp.cod-estab     = c-cod-estab: 

            ASSIGN ttRedispatchCarrier.RedispatchCarrierCity[1] = IF nota-fisc-redesp.num-cidad-redesp[1] <> 0 THEN nota-fisc-redesp.num-cidad-redesp[1]
                                                                  ELSE cdn-dest
                   ttRedispatchCarrier.RedispatchCarrierCode[2] = nota-fisc-redesp.cdn-redesp[1]
                   ttRedispatchCarrier.RedispatchCarrierCity[2] = IF nota-fisc-redesp.num-cidad-redesp[2] <> 0 THEN nota-fisc-redesp.num-cidad-redesp[2]
                                                                  ELSE cdn-dest

                   ttRedispatchCarrier.RedispatchCarrierCode[3] = nota-fisc-redesp.cdn-redesp[2]
                   ttRedispatchCarrier.RedispatchCarrierCity[3] = IF nota-fisc-redesp.num-cidad-redesp[3] <> 0 THEN nota-fisc-redesp.num-cidad-redesp[3]
                                                                  ELSE cdn-dest
                   
                   ttRedispatchCarrier.RedispatchCarrierCode[4] = nota-fisc-redesp.cdn-redesp[3]
                   ttRedispatchCarrier.RedispatchCarrierCity[4] = IF nota-fisc-redesp.num-cidad-redesp[4] <> 0 THEN nota-fisc-redesp.num-cidad-redesp[4]
                                                                  ELSE cdn-dest
                   
                   ttRedispatchCarrier.RedispatchCarrierCode[5] = nota-fisc-redesp.cdn-redesp[4]
                   ttRedispatchCarrier.RedispatchCarrierCity[5] = IF nota-fisc-redesp.num-cidad-redesp[5] <> 0 THEN nota-fisc-redesp.num-cidad-redesp[5]
                                                                  ELSE cdn-dest
                   
                   ttRedispatchCarrier.RedispatchCarrierCode[6] = nota-fisc-redesp.cdn-redesp[5]
                   ttRedispatchCarrier.RedispatchCarrierCity[6] = cdn-dest.
                   
                             
        END.
    END.

    IF CAN-FIND (FIRST simul-nota-fisc) THEN DO:
        FOR EACH simul-nota-fisc NO-LOCK
           WHERE simul-nota-fisc.cod-nota-fisc = STRING(INT(c-nr-nota-fis))
           AND   simul-nota-fisc.cod-ser-nf    = c-serie      
           AND   simul-nota-fisc.cod-estab     = c-cod-estab: 

            CREATE ttFreightSimulation.
            ASSIGN ttFreightSimulation.SiteID             = simul-nota-fisc.cod-estab
                   ttFreightSimulation.DocumentSeries     = simul-nota-fisc.cod-ser-nf      
                   ttFreightSimulation.DocumentNumber     = STRING(INT(simul-nota-fisc.cod-nota-fisc),"9999999")
                   ttFreightSimulation.CargoRouteNumber   = simul-nota-fisc.num-percur      
                   ttFreightSimulation.CustomerTaxID      = simul-nota-fisc.cod-cgc-clien   
                   ttFreightSimulation.FreightTableNumber = simul-nota-fisc.num-tab-frete   
                   ttFreightSimulation.Product            = simul-nota-fisc.cdn-produto     
                   ttFreightSimulation.ValidityDate       = simul-nota-fisc.dat-valid       
                   ttFreightSimulation.RouteNumber        = simul-nota-fisc.num-rota        
                   ttFreightSimulation.TermNumber         = simul-nota-fisc.num-prazo       
                   ttFreightSimulation.AgreedValue        = simul-nota-fisc.val-combin-clien
                   ttFreightSimulation.FreightUnitValue   = simul-nota-fisc.val-frete-unid  
                   ttFreightSimulation.FreightValue       = simul-nota-fisc.val-frete-val   
                   ttFreightSimulation.DaryValue          = simul-nota-fisc.val-diaria      
                   ttFreightSimulation.ADEMEValue         = simul-nota-fisc.val-ademe       
                   ttFreightSimulation.DispatchValue      = simul-nota-fisc.val-despch      
                   ttFreightSimulation.ITRValue           = simul-nota-fisc.val-itr         
                   ttFreightSimulation.OthersValue        = simul-nota-fisc.val-outros      
                   ttFreightSimulation.TollValue          = simul-nota-fisc.val-pedagio     
                   ttFreightSimulation.InsuranceValue     = simul-nota-fisc.val-seguro      
                   ttFreightSimulation.SUFRAMAValue       = simul-nota-fisc.val-suframa     
                   ttFreightSimulation.CollectionRate     = simul-nota-fisc.val-tax-coleta  
                   ttFreightSimulation.DispatchRateValue  = simul-nota-fisc.val-tax-conhecto
                   ttFreightSimulation.Comments           = simul-nota-fisc.des-obs.
        END.
    END.

    IF CAN-FIND (FIRST tab-generica WHERE tab-generica.utilizacao = "NFSaida") THEN DO:

        IF NOT VALID-HANDLE(h-bodi582) THEN
            RUN dibo/bodi582.p PERSISTENT SET h-bodi582.

        RUN setConstraintUtilizacao IN h-bodi582(INPUT "NFSaida").
        RUN openQueryStatic IN h-bodi582 (INPUT "MAIN":U) NO-ERROR.
            
        RUN goToKeyNFSaida  IN h-bodi582 (INPUT c-cod-estab, INPUT c-serie,
                                          INPUT c-nr-nota-fis ).
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN getCharField IN h-bodi582 (INPUT "char-2":U, OUTPUT c-char-2).

            CREATE ttFreightInformations.
            ASSIGN ttFreightInformations.ProductCode   = ENTRY(1,c-char-2,";":U)   
                   ttFreightInformations.VehicleType   = ENTRY(2,c-char-2,";":U) 
                   ttFreightInformations.OperationType = ENTRY(3,c-char-2,";":U).
        END.
    END.

        
  


   


