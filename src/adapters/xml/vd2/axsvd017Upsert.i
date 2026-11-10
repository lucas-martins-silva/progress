PROCEDURE PITransUpsert:

    /*PARAMETERS - BEGIN*/
    DEFINE INPUT PARAMETER pTranAction    AS CHAR  NO-UNDO.
    DEFINE INPUT PARAMETER pEmbarqueRowID AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
    /*PARAMETERS - END*/
    
    
    /*LOCAL VARIABLES - BEGIN*/
    DEFINE VAR c-carrier-id AS CHARACTER NO-UNDO.
    /*LOCAL VARIABLES - END*/
    
    
    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */
    
    EMPTY TEMP-TABLE tt_log_erro NO-ERROR.
    
    FIND FIRST bfembarque
         WHERE rowid(bfembarque) = pEmbarqueRowID NO-LOCK NO-ERROR.
    IF AVAIL bfembarque THEN DO:

	    FIND FIRST transporte WHERE transporte.nome-abrev = bfembarque.nome-transp NO-LOCK NO-ERROR.

	    IF AVAIL(transporte) THEN DO:
	            IF transporte.cgc <> "" AND transporte.cgc <> FILL("0", LENGTH(transporte.cgc)) THEN DO:
			        FIND FIRST emitente WHERE emitente.cgc = transporte.cgc NO-LOCK NO-ERROR.
			        ASSIGN c-carrier-id = IF AVAIL emitente THEN STRING(emitente.cod-emitente)
	                                      ELSE STRING(transporte.cod-transp).
	            END.
	            ELSE DO:
	                FIND FIRST emitente WHERE emitente.nome-abrev = transporte.nome-abrev NO-LOCK NO-ERROR.
	                ASSIGN c-carrier-id = IF AVAIL emitente THEN STRING(emitente.cod-emitente)
	                                      ELSE STRING(transporte.cod-transp).
	            END.
            END.
	
		RUN PIUpsert(INPUT pTranAction,
					 INPUT bfembarque.nome-transp,     /* CarrierName */
					 INPUT bfembarque.cod-dep-ext,     /* DepositCode */
					 INPUT bfembarque.ind-dimen,  	   /* Dimensioned,               */	
					 INPUT bfembarque.cod-canal-venda, /* DistribuitionChannelCode   */
					 INPUT bfembarque.motorista,       /* DriverName,                */
					 INPUT bfembarque.nat-operacao,    /* FiscalOperationCode,       */
					 INPUT c-carrier-id,               /* CarrierId,                    */
					 INPUT bfembarque.cod-tipo,        /* LoadType,                  */
					 INPUT bfembarque.placa,           /* Plate,                     */
					 INPUT bfembarque.identific,       /* PreparerCode,              */
					 INPUT bfembarque.cod-rota,        /* Route,                     */
					 INPUT bfembarque.dt-embarque,     /* ShipmentDate,              */
					 INPUT bfembarque.cdd-embarq,      /* ShipmentNumber,            */
					 INPUT bfembarque.usuario,         /* ShipmentUser,              */
					 INPUT bfembarque.cod-estabel,     /* SiteID,                    */
					 INPUT bfembarque.situacao,        /* Status,                    */
					 INPUT bfembarque.peso-bru-tot,    /* TotalGrossWeight,          */
					 INPUT bfembarque.peso-liq-tot,    /* TotalNetweight,            */
					 INPUT bfembarque.volume,          /* Volume               		*/
					 OUTPUT TABLE tt_log_erro).
    END.
	
    
    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

END PROCEDURE.



