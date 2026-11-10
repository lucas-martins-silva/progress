/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0004 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0004 MIM}
&ENDIF


/*Temp-table tamb‚m utilizada no programa axssu004*/
DEFINE TEMP-TABLE ttImportProcess NO-UNDO
     FIELD SiteId_03 AS CHARACTER INITIAL ?
     FIELD CheckSum_00 AS CHARACTER INITIAL ?
     FIELD PONumber_01 AS integer INITIAL ?
     FIELD LetterOfCredit AS CHARACTER INITIAL ?
     FIELD ImportStockBrokerExchange AS integer INITIAL ?
     FIELD ImportStockBroker AS integer INITIAL ?
     FIELD ImportForwardingAgentExtern AS integer INITIAL ?
     FIELD ImportInsuranceCode AS integer INITIAL ?
     FIELD CheckSum AS CHARACTER INITIAL ?
     FIELD Agent AS integer INITIAL ?
     FIELD BankCode AS integer INITIAL ?
     FIELD ShippedCode AS integer INITIAL ?
     FIELD ForwardingAgent AS integer INITIAL ?
     FIELD SiteId AS CHARACTER INITIAL ?
     FIELD SiteName AS CHARACTER INITIAL ?
     FIELD ExportCode AS integer INITIAL ?
     FIELD ManufacturingCode AS integer INITIAL ?
     FIELD LanguageCode AS CHARACTER INITIAL ?
     FIELD Incoterm AS CHARACTER INITIAL ?
     FIELD ItineraryCode AS integer INITIAL ?
     FIELD MessageCode AS integer INITIAL ?
     FIELD ProductShippingCode AS integer INITIAL ?
     FIELD ExchangeContract AS CHARACTER INITIAL ?
     FIELD ImportDeclaration AS CHARACTER INITIAL ?
     FIELD DocumentationTarget AS CHARACTER INITIAL ?
     FIELD LibertyDate AS date INITIAL ? 
     FIELD PrintDate AS date INITIAL ?
     FIELD IntroduceDate AS date INITIAL ?
     FIELD FiscalSiteId AS CHARACTER INITIAL ?
     FIELD FiscalSiteName AS CHARACTER INITIAL ?
     FIELD ImportLicense AS CHARACTER INITIAL ?
     FIELD OriginalMarket AS CHARACTER INITIAL ?
     FIELD Comments AS CHARACTER INITIAL ? 
     FIELD AcquirementsNumber AS CHARACTER INITIAL ?
     FIELD ImportProcessNumber AS CHARACTER INITIAL ?
     FIELD RofNumber AS CHARACTER INITIAL ?
     FIELD PONumber AS integer INITIAL ?
     FIELD ModeImport AS integer INITIAL ? 
     FIELD iStatus AS integer INITIAL ?
     FIELD MessageDescription AS CHARACTER INITIAL ?
     FIELD ProductShipShippingMethodCode AS integer INITIAL ? 
.


DEFINE BUFFER bf-estab-fisc  FOR estabelec.

DEFINE INPUT  PARAMETER pi-num-pedido LIKE pedido-compr.num-pedido NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttImportProcess.

FIND FIRST processo-imp NO-LOCK 
     WHERE processo-imp.num-pedido = pi-num-pedido NO-ERROR.

IF AVAIL processo-imp THEN DO:

    FIND FIRST estabelec WHERE estabelec.cod-estabel = processo-imp.cod-estabel NO-LOCK NO-ERROR.

    FIND FIRST bf-estab-fisc WHERE bf-estab-fisc.cod-estabel = processo-imp.estab-fisc NO-LOCK NO-ERROR.

    CREATE ttImportProcess.
    ASSIGN ttImportProcess.LetterOfCredit                = processo-imp.carta-credito
           ttImportProcess.CheckSum	                     = processo-imp.check-sum
           ttImportProcess.Agent                         = processo-imp.cod-agente
           ttImportProcess.BankCode	                     = processo-imp.cod-banco
           ttImportProcess.ShippedCode	                 = processo-imp.cod-consignatario
           ttImportProcess.ForwardingAgent	             = processo-imp.cod-despachante
           ttImportProcess.SiteId	                     = processo-imp.cod-estabel
           ttImportProcess.SiteName	                     = IF AVAIL estabelec THEN estabelec.nome ELSE ""
           ttImportProcess.ExportCode                    = processo-imp.cod-exportador
           ttImportProcess.ManufacturingCode	         = processo-imp.cod-fabricante
           ttImportProcess.LanguageCode	                 = processo-imp.cod-idioma
           ttImportProcess.Incoterm	                     = processo-imp.cod-incoterm
           ttImportProcess.ItineraryCode	             = processo-imp.cod-itiner
           ttImportProcess.MessageCode	                 = processo-imp.cod-mensagem
           ttImportProcess.ProductShippingCode	         = processo-imp.cod-transportador
           ttImportProcess.ExchangeContract	             = processo-imp.contrato-cambio
           ttImportProcess.ImportDeclaration	         = processo-imp.declaracao-import
           ttImportProcess.DocumentationTarget	         = processo-imp.destino-documentacao
           ttImportProcess.LibertyDate	                 = processo-imp.dt-autorizacao
           ttImportProcess.PrintDate	                 = processo-imp.dt-emissao
           ttImportProcess.IntroduceDate	             = processo-imp.dt-implantacao
           ttImportProcess.FiscalSiteId	                 = processo-imp.estab-fisc
           ttImportProcess.FiscalSiteName	             = IF AVAIL bf-estab-fisc THEN bf-estab-fisc.nome ELSE ""
           ttImportProcess.ImportLicense	             = processo-imp.licenca-import
           ttImportProcess.OriginalMarket	             = processo-imp.merc-orig
           ttImportProcess.Comments	                     = processo-imp.narrativa
           ttImportProcess.AcquirementsNumber	         = processo-imp.nr-conhecimento
           ttImportProcess.ImportProcessNumber	         = processo-imp.nr-proc-imp
           ttImportProcess.RofNumber	                 = processo-imp.nr-rof
           ttImportProcess.PONumber_01                   = processo-imp.num-pedido
           ttImportProcess.ModeImport	                 = processo-imp.regime-import
           ttImportProcess.iStatus	                     = processo-imp.situacao
           ttImportProcess.MessageDescription	         = processo-imp.texto-mensag
           ttImportProcess.ProductShipShippingMethodCode = processo-imp.via-transp.

        &if "{&bf_mat_versao_ems}" >= "2.062" &then
            ASSIGN ttImportProcess.ImportStockBrokerExchange     = processo-imp.cdn-corretor-cambio-import
                   ttImportProcess.ImportStockBroker             = processo-imp.cdn-corretor-import
                   ttImportProcess.ImportForwardingAgentExtern   = processo-imp.cdn-despa-exter-import
                   ttImportProcess.ImportInsuranceCode	         = processo-imp.cdn-segurad-import.
        &endif
END.

