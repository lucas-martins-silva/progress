PROCEDURE PITransUpsert:

    /*PARAMETERS - BEGIN*/
    DEF INPUT  PARAM r-rowid  AS ROWID.
    DEF INPUT  PARAM pcAction AS CHAR.  
    DEF OUTPUT PARAM TABLE FOR tt_log_erro.
    /*PARAMETERS - END*/
    
    
    /*LOCAL VARIABLES - BEGIN*/
	def var cSiteCode as char no-undo.
    /*LOCAL VARIABLES - END*/
    
    EMPTY TEMP-TABLE ttMaterialUser.
    EMPTY TEMP-TABLE tt_log_erro.
    
    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */

    FIND FIRST usuar-mater NO-LOCK
         WHERE ROWID(usuar-mater) = r-rowid NO-ERROR.
    
    IF AVAIL usuar-mater THEN DO:
	
		Find first param-global no-lock no-error.
		
		Find first empresa no-lock
			 where empresa.ep-codigo = param-global.empresa-prin no-error.
		
		Find first estabelec no-lock
			 where estabelec.cgc = empresa.cgc no-error.
	
		IF not avail estabelec then do:
			Find first estabelec no-lock
				 where estabelec.ep-codigo = empresa.ep-codigo no-error.
		End.

		Assign cSiteCode = estabelec.cod-estabel.

        CREATE ttMaterialUser.
        ASSIGN ttMaterialUser.Account                       = usuar-mater.ct-codigo
               ttMaterialUser.ApproverUser                  = usuar-mater.usuar-aprovador
               ttMaterialUser.BuyerUser                     = usuar-mater.usuar-comprador
               ttMaterialUser.ControlContractPermitions     = usuar-mater.log-control-permis
               ttMaterialUser.ControlCostCenter             = usuar-mater.cont-acesso-cc
               ttMaterialUser.ControlRequisition            = usuar-mater.classif-solic
               ttMaterialUser.ControlUpdateContract         = usuar-mater.perm-alt-cont
               ttMaterialUser.ControlVendorWithRestrictions = usuar-mater.log-movto-fornec-restric
               ttMaterialUser.Corporate                     = usuar-mater.corporativo
               ttMaterialUser.CostCenter                    = usuar-mater.sc-codigo
               ttMaterialUser.DeliveryPlace                 = usuar-mater.loc-entrega
               ttMaterialUser.Email                         = usuar-mater.e-mail
               ttMaterialUser.Fax                           = usuar-mater.telefax
               ttMaterialUser.FaxExt                        = usuar-mater.ramal-fax
               ttMaterialUser.HomePage                      = usuar-mater.home-page
               ttMaterialUser.MaintenanceRequesterUser      = usuar-mater.usuar-requis-manut
               ttMaterialUser.ModemRamal             = usuar-mater.ramal-modem
               ttMaterialUser.ModemTelephone         = usuar-mater.telef-modem
               ttMaterialUser.OrderUser              = usuar-mater.usuar-pedido
               /*ttMaterialUser.PhoneExt               = usuar-mater.ramal*/
               ttMaterialUser.PurchaseGroup          = usuar-mater.cod-grp-compra
               ttMaterialUser.ReceiveEmail           = usuar-mater.recebe-e-mail
               ttMaterialUser.RequesterUser          = usuar-mater.usuar-requis
               ttMaterialUser.RequitionerUser        = usuar-mater.usuar-solic
               ttMaterialUser.SendEmail              = usuar-mater.envia-e-mail
               ttMaterialUser.SiteCode               = cSiteCode /*C¢digo do Estabelecimento do usu rio (Integra‡Æo Paradigma)*/
               /*ttMaterialUser.SuggestionForBlankItem =*/ /*Sugerir Pre‡o Item D‚bito Direto (Campo: usuar-mater.log-suger-preco-item-db-diret)*/
               /*ttMaterialUser.Tefephone              = usuar-mater.telefone*/
               /*ttMaterialUser.ttMaterialUserID     = */
               ttMaterialUser.UserCode               = usuar-mater.cod-usuario
               ttMaterialUser.UserName               = usuar-mater.nome-usuar.
    
    END.
	
	FIND FIRST ttMaterialUser no-error.

    IF AVAIL ttMaterialUser THEN
        RUN PIUpsert (INPUT  "",
                      INPUT  pcAction,
                      OUTPUT TABLE tt_log_erro,
                      INPUT  TABLE ttMaterialUser).

    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

END PROCEDURE.



