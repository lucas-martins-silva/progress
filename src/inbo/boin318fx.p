&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOFunction 
/*:T--------------------------------------------------------------------------
    File       : dbofun.p
    Purpose    : O DBO Function (Datasul Business Objects) ‚ um programa 
                 PROGRESS que cont‚m a l¢gica de neg¢cio.


    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName boin318fx
&GLOBAL-DEFINE DBOVersion 1.00.00.000

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
    {include/i-license-manager.i boin318fx MPL}
&ENDIF
{fch/fchman/fchmanproductionplanstringreturn.i ttStringReturn}
{fch/fchman/fchmanproductionplanbooleanreturn.i ttBooleanReturn}
{fch/fchman/fchmanproductionplan.i7 ttGeneratedRequisitionsParamVO} 
{fch/fchman/fchmanproductionplan.i5 ttProductionPlanVO2} 
{fch/fchman/fchmanproductionplan.i2 ttProductionPlanParamVO} 
{fch/fchman/fchmanproductionplan.i ttProductionPlanCalculateVO} 
{fch/fchman/fchmanproductionplan.i10 ttGeneratedRequisitionsItemVO} 
{fch/fchman/fchmanproductionplan.i5 ttProductionPlanVO} 
{fch/fchman/fchmanproductionplan.i3 ttProductionPlanSitesVO} 
{fch/fchman/fchmanproductionplan.i1 ttProductionPlanGenerateVO} 
{fch/fchman/fchmanproductionplan.i4 ttProductionPlanSummaryVO} 
{fch/fchman/fchmanproductionplan.i6 ttGeneratedRequisitionsVO} 
{fch/fchman/fchmanproductionplan.i9 ttItemKeyRecordVO} 
{fch/fchman/fchmanproductionplan.i8 ttKeyRecordsParamVO} 

/*{utp/ut-glob.i}*/


/** Unifica‡Æo de conceito **/
{cdp/cdunif001.i}
DEF VAR i-seq-erros-api-ctb-cc AS INT INITIAL 1 NO-UNDO.


{cdp/cdcfgman.i}
DEFINE VARIABLE h-boin299      as handle  no-undo.
def new global shared var v_cod_usuar_corren as character format "x(12)":U no-undo.
def var raw-param                            as raw no-undo.

DEFINE TEMP-TABLE tt-pl-prod NO-UNDO LIKE pl-prod
    field r-rowid as rowid.

def temp-table tt-raw-digita NO-UNDO
   field raw-digita      as raw.

/*GERAR CALCULO*/
DEF TEMP-TABLE tt-paramCalculate NO-UNDO
    field destino        as integer
    field arquivo        as char format "x(40)"
    field usuario        as char format "x(40)"
    field data-exec      as date
    field hora-exec      as integer
    field classifica     as integer
    field l-rastr        as logical
    field l-itens-mult   as logical
    field rs-tipo-calc   as integer
    field c-tipo-calc    as char format "x(15)"
    field i-cd-plano     as integer.
define temp-table tt-digitaCalculate NO-UNDO
    field selec            as character format "x(1)"
    field cod-estabel      like estabelec.cod-estabel
    field nome             like estabelec.nome
    index id is primary unique
        cod-estabel.
/*FIM GERAR CALCULO*/
/*GERAR ORDENS*/
define temp-table tt-digitaGenerate NO-UNDO
    field c-it-codigo      like item.it-codigo
    field c-descricao      like item.descricao-1 format 'x(36)'
    field c-un             like item.un
    field c-fm-codigo      like item.fm-codigo
    field log-sel          as log format "*/ " init yes
    index id is primary c-it-codigo.

define temp-table tt-paramGenerate NO-UNDO
        field plano            like pl-prod.cd-plano
        field destino          as integer
        field arquivo          as char
        field usuario          as char
        field data-exec        as date
        field hora-exec        as integer
        field classifica       as integer
        field c-estabel-ini    like estabelec.cod-estabel initial ""
        field c-estabel-fim    like estabelec.cod-estabel initial "ZZZZZ"
        field c-fm-codigo-ini  like item.fm-codigo
        field c-fm-codigo-fim  like item.fm-codigo
        field i-ge-codigo-ini  like item.ge-codigo
        field i-ge-codigo-fim  like item.ge-codigo
        field c-it-codigo-ini  like item.it-codigo
        field c-it-codigo-fim  like item.it-codigo
        field c-cd-planejado-ini like item.cd-planejado
        field c-cd-planejado-fim like item.cd-planejado
        field i-nr-linha-ini   like item.nr-linha
        field i-nr-linha-fim   like item.nr-linha
        field c-dt-per         as character
        field l-comp           as logical
        field l-prod           as logical
        field l-ord-mul        as logical
        field l-split          as logical
        field rs-estabel       as integer
        field l-conf-resp      as logical
        field l-imp-item-alt   as logical
        field ord-benef        as logical
        field ord-confirm      as logical       
        FIELD c-cod-unid-negoc-ini AS CHAR FORMAT "x(3)"
        FIELD c-cod-unid-negoc-fim AS CHAR FORMAT "x(3)"
        FIELD l-unid-negoc-fn AS LOG INIT FALSE
        FIELD raw-filtro      AS RAW. /*Permite enviar um campo RAW para o RPW
                                        Utilizar os novos pontos UPC e EPC criados 
                                        para alimentar e resgatar as informacoes 
                                        deste campo*/

DEFINE VARIABLE i-ano-periodo AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-nr-periodo AS INTEGER     NO-UNDO.

/*FIM GERAR ORDENS*/
/*CRIAR TT DIGITA*/
define temp-table tt-digita NO-UNDO
    field c-it-codigo      like item.it-codigo
    field c-descricao      like item.descricao-1 format 'x(36)'
    field c-un             like item.un
    field c-fm-codigo      like item.fm-codigo
    field log-sel          as log format "*/ " init yes
    index id is primary c-it-codigo.

def temp-table tt-periodo NO-UNDO
    field it-codigo   like it-periodo.it-codigo
    field cod-estabel like it-periodo.cod-estabel
    field data        like it-periodo.data /*Dt Disponibilidade*/
    FIELD cod-refer   LIKE it-periodo.cod-refer
    FIELD dt-inicio   LIKE it-periodo.data /* Dt In¡cio */
    FIELD dt-fisica   LIKE it-periodo.data /*Dt F¡sica*/
    field qt-ord-plan like it-periodo.qt-ord-plan
    index codigo is primary unique it-codigo cod-estabel data cod-refer.
DEF TEMP-TABLE tt-item NO-UNDO LIKE ITEM. 
/*VARIAVEL Q TEM O TAMANHO DO PERIODO*/
DEF VAR i-tam-per    AS INT                      NO-UNDO.
DEF VAR i-ressup     AS INT                      NO-UNDO.
DEF VAR i-nr-dias    AS INT                      NO-UNDO.
DEF VAR i-resto      AS INT                      NO-UNDO.
DEF VAR de-vezes     AS DECIMAL                  NO-UNDO.
DEF VAR i-dias-dlt   AS INT                      NO-UNDO.
DEF VAR de-qt-min    AS DECIMAL                  NO-UNDO.
DEF VAR de-qt-dlt    AS DECIMAL                  NO-UNDO.
DEF VAR i-ind        AS INT                      NO-UNDO.

/*FIM DIGITACAO*/

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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOFunction ASSIGN
         HEIGHT             = 19.71
         WIDTH              = 42.29.
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

PROCEDURE getProductionPlanPortletSummary:

    DEF INPUT PARAM planCode AS integer.
    DEF OUTPUT PARAM TABLE FOR ttProductionPlanSummaryVO.
	DEF OUTPUT PARAM TABLE FOR RowErrors.
	
	if not valid-handle (h-boin299) then
		run inbo/boin299.p persistent set h-boin299.
		RUN openQueryStatic IN h-boin299 (INPUT "Main":U).	

	
	for first pl-prod where	pl-prod.cd-plano = planCode no-lock:
			
		    CREATE  ttProductionPlanSummaryVO.
		    ASSIGN  ttProductionPlanSummaryVO.planCode                = pl-prod.cd-plano
					ttProductionPlanSummaryVO.planType                = pl-prod.tipo-plano
					ttProductionPlanSummaryVO.calculationStatus       = pl-prod.calculo
					ttProductionPlanSummaryVO.initialPeriodYear       = pl-prod.ano-per-ini
					ttProductionPlanSummaryVO.finalPeriodYear         = pl-prod.ano-per-fim
					ttProductionPlanSummaryVO.initialPeriod           = pl-prod.nr-per-ini
					ttProductionPlanSummaryVO.finalPeriod             = pl-prod.nr-per-fim
				   
					
					ttProductionPlanSummaryVO.planStatus              = pl-prod.pl-estado
					ttProductionPlanSummaryVO.planDescription         = pl-prod.descricao
					ttProductionPlanSummaryVO.isSelected              = NO
					ttProductionPlanSummaryVO.periodType              = pl-prod.cd-tipo
					ttProductionPlanSummaryVO.percentualCalculation   = pl-prod.num-perc-calc
					ttProductionPlanSummaryVO.isMultiSites            = pl-prod.log-multi-estabel
				   .
				   

					
			run goToKey in h-boin299 (pl-prod.ano-per-ini, 
									  pl-prod.cd-tipo,
									  pl-prod.nr-per-ini).

			if return-value = "OK":U then do:
				run getDateField in h-boin299 (input "dt-inicio":U, output ttProductionPlanSummaryVO.initialPeriodIniDate).	
				run getDateField in h-boin299 (input "dt-termino":U, output ttProductionPlanSummaryVO.initialPeriodEndDate).   
			end.


			run goToKey in h-boin299 (pl-prod.ano-per-fim, 
									  pl-prod.cd-tipo,
									  pl-prod.nr-per-fim).

			if return-value = "OK":U then do:
				run getDateField in h-boin299 (input "dt-inicio":U, output ttProductionPlanSummaryVO.finalPeriodIniDate).	
				run getDateField in h-boin299 (input "dt-termino":U, output ttProductionPlanSummaryVO.finalPeriodEndDate).   
			end.

	end.

	IF VALID-HANDLE(h-boin299) THEN
    DELETE PROCEDURE h-boin299.

END PROCEDURE.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignFields DBOFunction 
PROCEDURE assignFields :
/*------------------------------------------------------------------------------
  Purpose:     Preenche a Temp Table tt-pl-prod, que ‚ uma c¢pia da tabela pl-prod
  Parameters:  <none>
  Notes: 
------------------------------------------------------------------------------*/
    assign tt-pl-prod.char-1 = ""
           tt-pl-prod.char-2 = "".

    ASSIGN tt-pl-prod.cd-plano               = ttProductionPlanVO.planCode
           tt-pl-prod.tipo-plano             = IF ttProductionPlanVO.planType = "2":U then "PP":U else "PV":U
           tt-pl-prod.descricao              = ttProductionPlanVO.planDescription
           tt-pl-prod.cd-tipo                = ttProductionPlanVO.periodType
           tt-pl-prod.nr-per-ini             = INT(ENTRY(1, ttProductionPlanVO.initialPeriodString, '/')) /*ttProductionPlanVO.initialPeriod*/
           tt-pl-prod.ano-per-ini            = INT(ENTRY(2, ttProductionPlanVO.initialPeriodString, '/')) /*ttProductionPlanVO.initialPeriodYear*/
           tt-pl-prod.nr-per-fim             = INT(ENTRY(1, ttProductionPlanVO.finalPeriodString, '/')) /*ttProductionPlanVO.finalPeriod*/
           tt-pl-prod.ano-per-fim            = INT(ENTRY(2, ttProductionPlanVO.finalPeriodString, '/')) /*ttProductionPlanVO.finalPeriodYear*/
           tt-pl-prod.dt-validade            = ttProductionPlanVO.validateDate
           tt-pl-prod.tp-rep-comp            = ttProductionPlanVO.purchasedReprogramming /*{ininc/i06in122.i 06 string(ttProductionPlanVO.purchasedReprogramming)}*/
           tt-pl-prod.tp-seg-comp            = ttProductionPlanVO.considersSafetyStockPurch    
           tt-pl-prod.saldo-comp             = ttProductionPlanVO.considersStockBalancePurch   
           tt-pl-prod.pedidos-comp           = ttProductionPlanVO.considersPurchNeeds
           tt-pl-prod.pedidos-fabr           = ttProductionPlanVO.considersMadeNeeds
           tt-pl-prod.res-comp               = ttProductionPlanVO.considersBacklogPurch        
           tt-pl-prod.tp-rep-fabr            = ttProductionPlanVO.reprogrammingMade /*{ininc/i06in122.i 06 string(ttProductionPlanVO.reprogrammingMade)}*/
           tt-pl-prod.tp-seg-fabr            = ttProductionPlanVO.considersSafetyStockMade     
           tt-pl-prod.saldo-fabr             = ttProductionPlanVO.considersStockBalanceMade    
           tt-pl-prod.ordens-fabr             = ttProductionPlanVO.considersProductionReq
           tt-pl-prod.ordens-comp            = ttProductionPlanVO.considersPurchaseReq
           tt-pl-prod.res-fabr               = ttProductionPlanVO.considersBacklogMade
           tt-pl-prod.rastreamento           = ttProductionPlanVO.generateTracking
           tt-pl-prod.calculo                = ttProductionPlanVO.calculationStatus
           tt-pl-prod.regera-plano           = ttProductionPlanVO.regeneratePlan
           tt-pl-prod.usuario                = "" /*ttProductionPlanVO.userCode*/
           tt-pl-prod.data-inicio            = ttProductionPlanVO.initialDate
           tt-pl-prod.hora-inicio            = "" /*ttProductionPlanVO.initialTime*/                  
           tt-pl-prod.data-termino           = ttProductionPlanVO.finalDate
           tt-pl-prod.hora-termino           = "" /*ttProductionPlanVO.finalTime*/
           tt-pl-prod.it-dem-ind             = ttProductionPlanVO.independentDemandItems
           tt-pl-prod.it-dem-dep             = ttProductionPlanVO.dependentDemandItems
           tt-pl-prod.nr-ord-comp            = ttProductionPlanVO.purchaseReq                  
           tt-pl-prod.nr-ord-fabr            = ttProductionPlanVO.manufacturingReq
           tt-pl-prod.nr-ord-rep             = ttProductionPlanVO.reprogrammingReq
           tt-pl-prod.it-fabr                = ttProductionPlanVO.manufacturingItems
           tt-pl-prod.nr-res-comp            = ttProductionPlanVO.committedNeeds
           tt-pl-prod.nr-item-pedi           = ttProductionPlanVO.itemsOrder
           tt-pl-prod.nr-ord-plan            = ttProductionPlanVO.plannedReq
           tt-pl-prod.nr-res-plan            = ttProductionPlanVO.plannedNeeds
           tt-pl-prod.pl-estado              = ttProductionPlanVO.planStatus
           tt-pl-prod.dt-ini-net             = ttProductionPlanVO.initialDateNetChange
           tt-pl-prod.dt-fim-net             = ttProductionPlanVO.finalDateNetChange
           tt-pl-prod.h-ini-net              = ttProductionPlanVO.initialTimeNetChange
           tt-pl-prod.h-fim-net              = ttProductionPlanVO.finalTimeNetChange
           tt-pl-prod.nr-it-net              = ttProductionPlanVO.itemsNetChange
           tt-pl-prod.horiz-fixo             = ttProductionPlanVO.fixedHorizon
           tt-pl-prod.quant-confirm          = ttProductionPlanVO.considersConfirmQuantity     
           tt-pl-prod.cod-estabel            = "" /*ttProductionPlanVO.defaultSite*/
           tt-pl-prod.aprov-comp             = ttProductionPlanVO.onlyApprovedPurchOrders      
           tt-pl-prod.aprov-fabr             = ttProductionPlanVO.onlyApprovedMadeOrders       
           tt-pl-prod.consig-fabr            = ttProductionPlanVO.considersPayrollBalanceMade  
           tt-pl-prod.consig-comp            = ttProductionPlanVO.considersPayrollBalancePurch 
           tt-pl-prod.tran-comp              = ttProductionPlanVO.considersTransitBalanceMade  
           tt-pl-prod.tran-fabr              = ttProductionPlanVO.considersTransitBalancePurch 
           tt-pl-prod.benef-fabr             = ttProductionPlanVO.thirdpartyBalanceMade        
           tt-pl-prod.benef-comp             = ttProductionPlanVO.thirdpartyBalancePurch       
           tt-pl-prod.tp-res-comp            = ttProductionPlanVO.considersResupplyPurch       
           tt-pl-prod.tp-res-fabr            = ttProductionPlanVO.considersResupplyMade        
           tt-pl-prod.nr-dias-seg            = ttProductionPlanVO.safetyDaysNumber             
           tt-pl-prod.calculo-plano          = ttProductionPlanVO.planCalculation              
           tt-pl-prod.check-sum              = ttProductionPlanVO.checkSum                     
           tt-pl-prod.num-id-pl-prod                 = ttProductionPlanVO.numIdPlan                    
           tt-pl-prod.ind-lista-compon       = ttProductionPlanVO.needByComponentList          
           tt-pl-prod.log-pv-config          = ttProductionPlanVO.configuredPVSales            
           tt-pl-prod.log-rb-compr           = ttProductionPlanVO.deliveryPurchProcessing      
           tt-pl-prod.log-eb-compr           = ttProductionPlanVO.entryPurchProcessing         
           tt-pl-prod.log-rc-compr           = ttProductionPlanVO.deliveryPurchPayroll         
           tt-pl-prod.log-ec-compr           = ttProductionPlanVO.entryPurchPayroll            
           tt-pl-prod.log-ec-fabric          = ttProductionPlanVO.entryMadePayroll             
           tt-pl-prod.log-rc-fabric          = ttProductionPlanVO.deliveryMadePayroll          
           tt-pl-prod.log-rb-fabric          = ttProductionPlanVO.deliveryMadeProcessing       
           tt-pl-prod.log-eb-fabric          = ttProductionPlanVO.entryMadeProcessing          
           tt-pl-prod.num-calc-plano         = ttProductionPlanVO.numPlanCalculation           
           tt-pl-prod.log-multi-estabel      = ttProductionPlanVO.isMultiSites               
           tt-pl-prod.log-nec-bruta          = ttProductionPlanVO.grossRequirements
           overlay(tt-pl-prod.char-1,11,1)    = string(ttProductionPlanVO.planInHorizon)
           overlay(tt-pl-prod.char-1,12,1)    = string(ttProductionPlanVO.repressionDemandPurch)
           overlay(tt-pl-prod.char-1,13,1)    = string(ttProductionPlanVO.repressionDemandMade)


           tt-pl-prod.int-1 = if ttProductionPlanVO.reprogramInProgressReqPurch
                                    then int(("1" + substr(string(tt-pl-prod.int-1),2,1))) 
                                    else int(("2" + substr(string(tt-pl-prod.int-1),2,1)))

           tt-pl-prod.int-1 = if ttProductionPlanVO.reprogramInProgressReqMade
                                    then int((substr(string(tt-pl-prod.int-1),1,1) + "1")) 
                                    else int((substr(string(tt-pl-prod.int-1),1,1) + "2"))

           overlay(tt-pl-prod.char-1,2,1) = if ttProductionPlanVO.deliveryPurchProcessing = true then "1" else "2"
           overlay(tt-pl-prod.char-1,6,1) = if ttProductionPlanVO.deliveryMadeProcessing = true then "1" else "2"

           overlay(tt-pl-prod.char-1,3,1) = if ttProductionPlanVO.entryPurchProcessing = true then "1" else "2"
           overlay(tt-pl-prod.char-1,7,1) = if ttProductionPlanVO.entryMadeProcessing = true then "1" else "2"
           
           overlay(tt-pl-prod.char-1,4,1) = if ttProductionPlanVO.deliveryPurchPayroll = true then "1" else "2"
           overlay(tt-pl-prod.char-1,8,1) = if ttProductionPlanVO.deliveryMadePayroll = true then "1" else "2"
           
           overlay(tt-pl-prod.char-1,5,1) = if ttProductionPlanVO.entryPurchPayroll = true then "1" else "2"
           overlay(tt-pl-prod.char-1,9,1) = if ttProductionPlanVO.entryMadePayroll = true then "1" else "2"
           
           tt-pl-prod.log-dispon-aloc-saldo = ttProductionPlanVO.providesAlocations
           overlay(tt-pl-prod.char-1,14,1)  = if ttProductionPlanVO.thirdBalanceSummaryPurch = true then "1" else "2"
           overlay(tt-pl-prod.char-1,15,1)  = if ttProductionPlanVO.thirdBalanceSummaryMade = true then "1" else "2"
           
           tt-pl-prod.idi-recalc-obten   = ttProductionPlanVO.calculationOfHowToObtain.

           if  tt-pl-prod.tipo-plano <> "PP":U  
               and tt-pl-prod.quant-confirm then do:
               assign tt-pl-prod.quant-confirm = no.
           end.
           
           return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculatePlan DBOFunction 
PROCEDURE calculatePlan :
/*------------------------------------------------------------------------------
  Purpose:     Efetuar Calculo do planejamento via RPW
  Parameters:  <none>
  Notes:       
  Autor: Fernando Lu¡s da Silva. felix@templartec.com 
------------------------------------------------------------------------------*/
DEF INPUT PARAM TABLE FOR ttProductionPlanCalculateVO.
DEF OUTPUT PARAM TABLE FOR ttStringReturn.
DEF OUTPUT PARAM TABLE FOR RowErrors.

DEF VAR cPedidoNum AS CHAR.

empty temp-table tt-paramCalculate.
empty temp-table tt-digitaCalculate.
  
FIND FIRST ttProductionPlanCalculateVO NO-LOCK NO-ERROR.

IF AVAIL ttProductionPlanCalculateVO THEN DO:

    /* Valida‡Æo de Parƒmetros */
    find first pl-prod
       where pl-prod.cd-plano = ttProductionPlanCalculateVO.productionPlanCode
       no-lock no-error.

    if  not avail pl-prod then do:
      {utp/ut-table.i mgind pl-prod 1}
      {method/svc/errors/inserr.i
          &ErrorNumber="2"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters=return-value}

       return "NOK":U.
    end.

    if ttProductionPlanCalculateVO.calculationType = 2 and 
       pl-prod.pl-estado = 2 then do:

      {method/svc/errors/inserr.i
          &ErrorNumber="1544"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}

       return "NOK":U.
    end.

    if ttProductionPlanCalculateVO.calculationType = 2 and 
       pl-prod.regera-plano = yes then do:

      {method/svc/errors/inserr.i
          &ErrorNumber="1545"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}
               
        return "NOK":U.
    end.

    if ttProductionPlanCalculateVO.calculationType = 2 and 
       pl-prod.rastreamento = no then do:

      {method/svc/errors/inserr.i
          &ErrorNumber="1546"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}

       return "NOK":U.
    end.
    
    /** Cria‡Æo da tt-param **/
    CREATE tt-paramCalculate.
    ASSIGN tt-paramCalculate.destino      = 2
           tt-paramCalculate.arquivo      = "PL0501FX.LST"
           tt-paramCalculate.usuario      = v_cod_usuar_corren
           tt-paramCalculate.data-exec    = TODAY
           tt-paramCalculate.hora-exec    = TIME
           tt-paramCalculate.classifica   = 1
           tt-paramCalculate.l-rastr      = ttProductionPlanCalculateVO.generateTrace
           tt-paramCalculate.l-itens-mult = ttProductionPlanCalculateVO.printLot
           tt-paramCalculate.rs-tipo-calc = ttProductionPlanCalculateVO.calculationType
           tt-paramCalculate.i-cd-plano   = ttProductionPlanCalculateVO.productionPlanCode.

    RAW-TRANSFER tt-paramCalculate TO raw-param.
    
    /** Cria‡Æo tt-digita **/
    for each pl-prod-estab
        where pl-prod-estab.cd-plano = ttProductionPlanCalculateVO.productionPlanCode no-lock:

        for first estabelec 
            where estabelec.cod-estabel = pl-prod-estab.cod-estabel no-lock:
            create tt-digitaCalculate.
            assign tt-digitaCalculate.cod-estabel = pl-prod-estab.cod-estabel
                   tt-digitaCalculate.nome = estabelec.nome
                   tt-digitaCalculate.selec = "*".
        end.
    end.

    for each tt-digitaCalculate no-lock:
        create tt-raw-digita.
        raw-transfer tt-digitaCalculate to tt-raw-digita.raw-digita.
    end.    
    
    run inbo/boin157fxrpw.p (input raw-param,
                             input table tt-raw-digita,
                             input "PL0501FX.LST",
                             input 'PL0501':U,
                             input 0501,
                             input 'plp/pl0501rp.p':U,
                             output cPedidoNum,
                             output table RowErrors).


    if (cPedidoNum <> "":U) then do:
        for first pl-prod
            where pl-prod.cd-plano = ttProductionPlanCalculateVO.productionPlanCode exclusive-lock:
            ASSIGN pl-prod.num-perc-calc = 0.
        end.
    end.

    create ttStringReturn.
    assign ttStringReturn.stringValue = cPedidoNum.

    END.

IF NOT AVAIL ttProductionPlanCalculateVO THEN DO:
    CREATE RowErrors.
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Problema_ao_Receber_os_Parametros" *}
    ASSIGN RowErrors.ErrorSequence = 1
           RowErrors.ErrorNumber = 17006
           RowErrors.ErrorDescription = RETURN-VALUE + "."
           RowErrors.ErrorType = "ERROR":U
           RowErrors.ErrorSubType = "ERROR".
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportData DBOFunction 
PROCEDURE exportData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM TABLE FOR ttGeneratedRequisitionsParamVO.
DEF OUTPUT PARAM TABLE FOR ttGeneratedRequisitionsVO.
DEF OUTPUT PARAM TABLE FOR RowErrors.

    DEFINE VARIABLE hquery  AS HANDLE NO-UNDO.
DEFINE VARIABLE hbuffer AS HANDLE NO-UNDO.
DEFINE VARIABLE squery AS CHARACTER NO-UNDO.
DEFINE VARIABLE defaultWhere AS CHARACTER   NO-UNDO.
DEFINE VARIABLE TABLENAME AS CHARACTER   NO-UNDO.

FOR FIRST ttGeneratedRequisitionsParamVO NO-LOCK:
END.

ASSIGN defaultWhere = "".

/* C¢digo do Plano */
IF trim(string(ttGeneratedRequisitionsParamVO.planCode)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cdn-plano  = " + string(ttGeneratedRequisitionsParamVO.planCode).
/* RPW Request */
IF trim(string(ttGeneratedRequisitionsParamVO.rpwRequest)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.num-ped-exec  = " + string(ttGeneratedRequisitionsParamVO.rpwRequest).

/* Data inicial */
IF trim(string(ttGeneratedRequisitionsParamVO.initialDate)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  (planej-produc-histor.dt-inicio  >= date('" + string(ttGeneratedRequisitionsParamVO.initialDate) + "') or planej-produc-histor.dt-inicio = ?)".

/* Data Final */
IF trim(string(ttGeneratedRequisitionsParamVO.finalDate)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and (planej-produc-histor.dt-termino  <= date('" + string(ttGeneratedRequisitionsParamVO.finalDate) + "') or planej-produc-histor.dt-termino = ?)".

/* Hora Inicial */
IF trim(string(ttGeneratedRequisitionsParamVO.initialTime)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and ((planej-produc-histor.dt-inicio > date('" + string(ttGeneratedRequisitionsParamVO.initialDate) + "') or planej-produc-histor.dt-inicio = ?)"+
        " OR ((planej-produc-histor.dt-inicio  = DATE('" + string(ttGeneratedRequisitionsParamVO.initialDate) + "') or planej-produc-histor.dt-inicio = ?) AND planej-produc-histor.hr-geracao  >= '" + string(ttGeneratedRequisitionsParamVO.initialTime) + "'))".

/* Item Inicial */
IF trim(string(ttGeneratedRequisitionsParamVO.initialItem)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.it-codigo  >= '" + string(ttGeneratedRequisitionsParamVO.initialItem) + "'".
/* Item Final */
IF trim(string(ttGeneratedRequisitionsParamVO.finalItem)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.it-codigo  <= '" + string(ttGeneratedRequisitionsParamVO.finalItem) + "'".
/* Fam¡lia Inicial */
IF trim(string(ttGeneratedRequisitionsParamVO.initialFamily)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-familia  >= '" + string(ttGeneratedRequisitionsParamVO.initialFamily) + "'".
/* Fam¡lia Final */
IF trim(string(ttGeneratedRequisitionsParamVO.finalFamily)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-familia  <= '" + string(ttGeneratedRequisitionsParamVO.finalFamily) + "'".
/* Planejador Inicial */
IF trim(string(ttGeneratedRequisitionsParamVO.initialPlanner)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cd-planejado  >= '" + string(ttGeneratedRequisitionsParamVO.initialPlanner) + "'".
/* Planejador Final */
IF trim(string(ttGeneratedRequisitionsParamVO.finalPlanner)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cd-planejado  <= '" + string(ttGeneratedRequisitionsParamVO.finalPlanner) + "'".
/* Grupo Estoque Inicial */
/*Talvez tenha que ser 'string(planej-produc-histor.ge-codigo)'*/
IF trim(string(ttGeneratedRequisitionsParamVO.initialStockGroup)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.ge-codigo  >= '" + string(ttGeneratedRequisitionsParamVO.initialStockGroup) + "'".
/* Grupo Estoque Final */
IF trim(string(ttGeneratedRequisitionsParamVO.finalStockGroup)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.ge-codigo  <= '" + string(ttGeneratedRequisitionsParamVO.finalStockGroup) + "'".
/* Comprador Inicial */
IF trim(string(ttGeneratedRequisitionsParamVO.initialBuyer)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-comprado  >= '" + string(ttGeneratedRequisitionsParamVO.initialBuyer) + "'".
/* Comprador Final */
IF trim(string(ttGeneratedRequisitionsParamVO.finalBuyer)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-comprado  <= '" + string(ttGeneratedRequisitionsParamVO.finalBuyer) + "'".
/* C¢digo do Usu rio */
IF trim(string(ttGeneratedRequisitionsParamVO.userCode)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-usuar  = '" + string(ttGeneratedRequisitionsParamVO.userCode) + "'".
/* Criada e Reprogramada */
IF ttGeneratedRequisitionsParamVO.createAction AND ttGeneratedRequisitionsParamVO.reprogrammingAction THEN
    ASSIGN defaultWhere = defaultWhere + " and (planej-produc-histor.cod-acao  = '1' or planej-produc-histor.cod-acao  = '2') ".
ELSE DO:
    /* Criada */
    IF ttGeneratedRequisitionsParamVO.createAction THEN
        ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-acao  = '1' ".
    ELSE
        ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-acao  <> '1' ".
    /* Reprogramada */
    IF ttGeneratedRequisitionsParamVO.reprogrammingAction THEN
        ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-acao  = '2' ".
    ELSE
        ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-acao  <> '2' ".
END.

ASSIGN TABLENAME = "planej-produc-histor".

squery = "for each " + TABLENAME + " no-lock where " + substring(defaultWhere,6).

CREATE BUFFER hbuffer FOR TABLE TABLENAME.
CREATE QUERY hquery.
hquery:SET-BUFFERS( hbuffer ).
hquery:QUERY-PREPARE( squery ).
hquery:FORWARD-ONLY.
hquery:QUERY-OPEN.

hquery:GET-FIRST( NO-LOCK ).

REPEAT WHILE NOT hquery:QUERY-OFF-END:

    CREATE ttGeneratedRequisitionsVO.
    ASSIGN ttGeneratedRequisitionsVO.userCode            = hBuffer:BUFFER-FIELD("cod-usuar"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.creationTime        = hBuffer:BUFFER-FIELD("hr-geracao"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.creationDate        = hBuffer:BUFFER-FIELD("dt-geracao"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.businessUnit        = hBuffer:BUFFER-FIELD("cod-unid-negoc"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.productionLine      = string(hBuffer:BUFFER-FIELD("nr-linha"):BUFFER-VALUE)
           ttGeneratedRequisitionsVO.buyer               = hBuffer:BUFFER-FIELD("cod-comprado"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.planner             = hBuffer:BUFFER-FIELD("cd-planejado"):BUFFER-VALUE
           /* VO - Char; Tabela - Int */
           ttGeneratedRequisitionsVO.stockGroup          = string(hBuffer:BUFFER-FIELD("ge-codigo"):BUFFER-VALUE)
           ttGeneratedRequisitionsVO.family              = hBuffer:BUFFER-FIELD("cod-familia"):BUFFER-VALUE
           /* VO - Char; Tabela - Int*/
           ttGeneratedRequisitionsVO.planCode            = string(hBuffer:BUFFER-FIELD("cdn-plano"):BUFFER-VALUE)
           ttGeneratedRequisitionsVO.reprogrammingDate   = hBuffer:BUFFER-FIELD("dt-reprog"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.deliveryDate        = hBuffer:BUFFER-FIELD("dt-entrega"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.balance             = hBuffer:BUFFER-FIELD("num-saldo"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.site                = hBuffer:BUFFER-FIELD("cod-estabel"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.quantity            = hBuffer:BUFFER-FIELD("qt-ordem"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.finalDate           = hBuffer:BUFFER-FIELD("dt-termino"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.initialDate         = hBuffer:BUFFER-FIELD("dt-inicio"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.shortName           = hBuffer:BUFFER-FIELD("nome-abrev"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.customerRequest     = hBuffer:BUFFER-FIELD("nr-pedido"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.reportType          = hBuffer:BUFFER-FIELD("rep-prod"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.parcel              = hBuffer:BUFFER-FIELD("nr-parcela"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.productionReqNumber = hBuffer:BUFFER-FIELD("nr-ord-produ"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.purchaseReqNumber   = hBuffer:BUFFER-FIELD("num-ord-compra"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.unitOfMeasure       = hBuffer:BUFFER-FIELD("des-un"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.lot                 = hBuffer:BUFFER-FIELD("lote-serie"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.itemDescription     = hBuffer:BUFFER-FIELD("desc-item"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.reference           = hBuffer:BUFFER-FIELD("cod-refer"):buffer-value 
           ttGeneratedRequisitionsVO.item                = hBuffer:BUFFER-FIELD("it-codigo"):BUFFER-VALUE
           /* VO - Int; Tabela - Char*/
           ttGeneratedRequisitionsVO.action              = int(hBuffer:BUFFER-FIELD("cod-acao"):BUFFER-VALUE)
           ttGeneratedRequisitionsVO.rpwRequestNumber    = hBuffer:BUFFER-FIELD("num-ped-exec"):buffer-value
           ttGeneratedRequisitionsVO.sequence            = hBuffer:BUFFER-FIELD("num-seq"):BUFFER-VALUE.

    hquery:GET-NEXT( NO-LOCK ).
END.
    
DELETE OBJECT hquery.
DELETE OBJECT hbuffer.


/*
    CREATE ttGeneratedRequisitionsVO.
    ASSIGN ttGeneratedRequisitionsVO.userCode            = planej-produc-hist.cod-usuar        
           ttGeneratedRequisitionsVO.creationTime        = planej-produc-hist.hr-geracao       
           ttGeneratedRequisitionsVO.creationDate        = planej-produc-hist.dt-geracao       
           ttGeneratedRequisitionsVO.businessUnit        = planej-produc-hist.cod-unid-negoc   
           ttGeneratedRequisitionsVO.productionLine      = string(planej-produc-hist.nr-linha) 
           ttGeneratedRequisitionsVO.buyer               = planej-produc-hist.cod-comprado     
           ttGeneratedRequisitionsVO.planner             = planej-produc-hist.cd-planejado     
           /* VO - Char; Tabela - Int */                                                       
           ttGeneratedRequisitionsVO.stockGroup          = string(planej-produc-hist.ge-codigo)
           ttGeneratedRequisitionsVO.family              = planej-produc-hist.cod-familia      
           /* VO - Char; Tabela - Int*/                                                        
           ttGeneratedRequisitionsVO.planCode            = string(planej-produc-hist.cdn-plano)
           ttGeneratedRequisitionsVO.reprogrammingDate   = planej-produc-hist.dt-reprog        
           ttGeneratedRequisitionsVO.deliveryDate        = planej-produc-hist.dt-entrega       
           ttGeneratedRequisitionsVO.balance             = planej-produc-hist.num-saldo        
           ttGeneratedRequisitionsVO.site                = planej-produc-hist.cod-estabel      
           ttGeneratedRequisitionsVO.quantity            = planej-produc-hist.qt-ordem         
           ttGeneratedRequisitionsVO.finalDate           = planej-produc-hist.dt-termino       
           ttGeneratedRequisitionsVO.initialDate         = planej-produc-hist.dt-inicio        
           ttGeneratedRequisitionsVO.shortName           = planej-produc-hist.nome-abrev       
           ttGeneratedRequisitionsVO.customerRequest     = planej-produc-hist.nr-pedido        
           ttGeneratedRequisitionsVO.reportType          = planej-produc-hist.rep-prod         
           ttGeneratedRequisitionsVO.parcel              = planej-produc-hist.nr-parcela       
           ttGeneratedRequisitionsVO.productionReqNumber = planej-produc-hist.nr-ord-produ     
           ttGeneratedRequisitionsVO.purchaseReqNumber   = planej-produc-hist.num-ord-compra   
           ttGeneratedRequisitionsVO.unitOfMeasure       = planej-produc-hist.des-un           
           ttGeneratedRequisitionsVO.lot                 = planej-produc-hist.lote-serie       
           ttGeneratedRequisitionsVO.itemDescription     = planej-produc-hist.desc-item        
           ttGeneratedRequisitionsVO.reference           = planej-produc-hist.cod-refer        
           ttGeneratedRequisitionsVO.item                = planej-produc-hist.it-codigo        
           /* VO - Int; Tabela - Char*/                                                        
           ttGeneratedRequisitionsVO.action              = int(planej-produc-hist.cod-acao)    
           /*ttGeneratedRequisitionsVO.rpwRequest          = planej-produc-hist.num-ped-exec*/ 
           ttGeneratedRequisitionsVO.sequence            = planej-produc-hist.num-seq.

*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generatePlan DBOFunction 
PROCEDURE generatePlan :
/*------------------------------------------------------------------------------
  Purpose:     Gera um novo plano a partir da temp table parƒmetro.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM TABLE FOR ttProductionPlanGenerateVO.
DEF INPUT  PARAM TABLE FOR ttItemKeyRecordVO.
DEF OUTPUT PARAM TABLE FOR ttStringReturn.
DEF OUTPUT PARAM TABLE FOR RowErrors.

DEF VAR cPedidoNum AS CHAR.

empty temp-table tt-paramGenerate.
empty temp-table tt-digitaGenerate.

FIND FIRST ttProductionPlanGenerateVO NO-LOCK NO-ERROR.

if avail ttProductionPlanGenerateVO then do:

    FIND FIRST param-global NO-LOCK NO-ERROR.
    FIND FIRST param-cp NO-LOCK NO-ERROR.

    run pi-erro-plano-confirmacao.
    if return-value = "NOK":U then return "NOK":U.

    run pi-erro-selecao-confirmacao.
    if return-value = "NOK":U then return "NOK":U.

    run pi-erro-parametro-confirmacao.
    if return-value = "NOK":U then return "NOK":U.
  

    create tt-paramGenerate.
    assign tt-paramGenerate.plano                = ttProductionPlanGenerateVO.planCode
           tt-paramGenerate.destino              = 2
           tt-paramGenerate.arquivo              = "PL0901FX.LST"
           tt-paramGenerate.usuario              = v_cod_usuar_corren
           tt-paramGenerate.data-exec            = today
           tt-paramGenerate.hora-exec            = time
           tt-paramGenerate.classifica           = 1
           tt-paramGenerate.c-estabel-ini        = ttProductionPlanGenerateVO.initialSite
           tt-paramGenerate.c-estabel-fim        = ttProductionPlanGenerateVO.finalSite
           tt-paramGenerate.c-fm-codigo-ini      = ttProductionPlanGenerateVO.initialFamily
           tt-paramGenerate.c-fm-codigo-fim      = ttProductionPlanGenerateVO.finalFamily
           tt-paramGenerate.i-ge-codigo-ini      = ttProductionPlanGenerateVO.initialStockGroup
           tt-paramGenerate.i-ge-codigo-fim      = ttProductionPlanGenerateVO.finalStockGroup
           tt-paramGenerate.c-it-codigo-ini      = ttProductionPlanGenerateVO.initialItem
           tt-paramGenerate.c-it-codigo-fim      = ttProductionPlanGenerateVO.finalItem
           tt-paramGenerate.c-cd-planejado-ini   = ttProductionPlanGenerateVO.initialPlanner
           tt-paramGenerate.c-cd-planejado-fim   = ttProductionPlanGenerateVO.finalPlanner
           tt-paramGenerate.i-nr-linha-ini       = ttProductionPlanGenerateVO.initialProductionLine
           tt-paramGenerate.i-nr-linha-fim       = ttProductionPlanGenerateVO.finalProductionLine
           tt-paramGenerate.c-dt-per             = string(int(entry(1, ttProductionPlanGenerateVO.period, "/")), '999') + string(int(entry(2, ttProductionPlanGenerateVO.period, "/")), '9999')
           tt-paramGenerate.l-comp               = ttProductionPlanGenerateVO.isPurchItem
           tt-paramGenerate.l-prod               = ttProductionPlanGenerateVO.isMadeItem
           tt-paramGenerate.l-ord-mul            = ttProductionPlanGenerateVO.isGenerateMultiPurchReq
           tt-paramGenerate.l-split              = ttProductionPlanGenerateVO.isSplitPurchReqByVendors
           tt-paramGenerate.rs-estabel           = ttProductionPlanGenerateVO.siteForGeneration
           tt-paramGenerate.l-conf-resp          = ttProductionPlanGenerateVO.isBlockApprovedItems
           tt-paramGenerate.l-imp-item-alt       = ttProductionPlanGenerateVO.isPrintModifiedItems
           tt-paramGenerate.ord-benef            = ttProductionPlanGenerateVO.isGenerateAutomaticReq
           tt-paramGenerate.ord-confirm          = ttProductionPlanGenerateVO.isPrintConfirmedReq
           tt-paramGenerate.c-cod-unid-negoc-ini = ttProductionPlanGenerateVO.initialBusinessUnit
           tt-paramGenerate.c-cod-unid-negoc-fim = ttProductionPlanGenerateVO.finalBusinessUnit
           tt-paramGenerate.l-unid-negoc-fn      = IF (CAN-FIND(funcao WHERE funcao.cd-funcao = "EMS2-UNIDADE-NEGOCIO" 
                                                                            AND funcao.ativo = YES)) 
                                                        THEN YES 
                                                   ELSE FALSE.

    RAW-TRANSFER tt-paramGenerate TO raw-param.
    
    for each ttItemKeyRecordVO no-lock:
        create tt-digitaGenerate.
        assign tt-digitaGenerate.c-it-codigo = ttItemKeyRecordVO.itemCode
               tt-digitaGenerate.c-descricao = ttItemKeyRecordVO.itemDescription
               tt-digitaGenerate.c-un        = ttItemKeyRecordVO.unitOfMeasure
               tt-digitaGenerate.c-fm-codigo = ttItemKeyRecordVO.family
               tt-digitaGenerate.log-sel     = ttItemKeyRecordVO.isSelected.
        
        create tt-raw-digita.
        raw-transfer tt-digitaGenerate to tt-raw-digita.raw-digita.
    end.
    

    FIND FIRST param-global NO-LOCK NO-ERROR.
    FIND FIRST param-cp NO-LOCK NO-ERROR.

    assign i-nr-periodo  = integer(substr(tt-paramGenerate.c-dt-per,1,3))
           i-ano-periodo = integer(substr(tt-paramGenerate.c-dt-per,4,4)).

    IF NOT CAN-FIND(FIRST RowErrors) THEN DO:
        run inbo/boin157fxrpw.p (input raw-param,
                             input table tt-raw-digita,
                             input "PL0901FX.LST",
                             input 'PL0901':U,
                             input 0901,
                             input 'plp/pl0901fxrp.p':U,
                             output cPedidoNum,
                             output table RowErrors).
    END.
    
    create ttStringReturn.
    assign ttStringReturn.stringValue = cPedidoNum.
    
end.

if not avail ttProductionPlanGenerateVO then do:
    CREATE RowErrors.
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Problema_ao_Receber_os_Parametros" *}
    ASSIGN RowErrors.ErrorSequence = 1
           RowErrors.ErrorNumber = 17006
           RowErrors.ErrorDescription = RETURN-VALUE + "."
           RowErrors.ErrorType = "ERROR":U
           RowErrors.ErrorSubType = "ERROR":U.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getGeneratedItems DBOFunction 
PROCEDURE getGeneratedItems :
/*------------------------------------------------------------------------------
  Purpose:     Retorna os Itens e Estabelecimentos existentes na tabela de hit¢rico de planos gerados
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM TABLE FOR ttGeneratedRequisitionsParamVO.
DEF OUTPUT PARAM TABLE FOR ttGeneratedRequisitionsItemVO.
DEF OUTPUT PARAM TABLE FOR RowErrors.

DEFINE VARIABLE hquery  AS HANDLE NO-UNDO.
DEFINE VARIABLE hbuffer AS HANDLE NO-UNDO.
DEFINE VARIABLE squery AS CHARACTER NO-UNDO.
DEFINE VARIABLE defaultWhere AS CHARACTER   NO-UNDO.
DEFINE VARIABLE TABLENAME AS CHARACTER   NO-UNDO.

FOR FIRST ttGeneratedRequisitionsParamVO NO-LOCK:
END.

ASSIGN defaultWhere = "".

/* C¢digo do Plano */
IF trim(string(ttGeneratedRequisitionsParamVO.planCode)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " planej-produc-histor.cdn-plano  = " + string(ttGeneratedRequisitionsParamVO.planCode).
/* RPW Request */
IF trim(string(ttGeneratedRequisitionsParamVO.rpwRequest)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.num-ped-exec  = " + string(ttGeneratedRequisitionsParamVO.rpwRequest).
/* Data inicial e Hora Inicial */
IF trim(string(ttGeneratedRequisitionsParamVO.initialDate)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  (planej-produc-histor.dt-inicio  >= date('" + string(ttGeneratedRequisitionsParamVO.initialDate) + "') or planej-produc-histor.dt-inicio = ?)".
/* Data Final */
IF trim(string(ttGeneratedRequisitionsParamVO.finalDate)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  (planej-produc-histor.dt-termino  <= date('" + string(ttGeneratedRequisitionsParamVO.finalDate) + "') or planej-produc-histor.dt-termino = ?)".
/* Hora Inicial */
IF trim(string(ttGeneratedRequisitionsParamVO.initialTime)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and ((planej-produc-histor.dt-inicio > date('" + string(ttGeneratedRequisitionsParamVO.initialDate) + "') or planej-produc-histor.dt-inicio = ?)"+
        " OR ((planej-produc-histor.dt-inicio  = DATE('" + string(ttGeneratedRequisitionsParamVO.initialDate) + "') or planej-produc-histor.dt-inicio = ?) AND planej-produc-histor.hr-geracao  >= '" + string(ttGeneratedRequisitionsParamVO.initialTime) + "'))".
/* Item Inicial */
IF trim(string(ttGeneratedRequisitionsParamVO.initialItem)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.it-codigo  >= '" + string(ttGeneratedRequisitionsParamVO.initialItem) + "'".
/* Item Final */
IF trim(string(ttGeneratedRequisitionsParamVO.finalItem)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.it-codigo  <= '" + string(ttGeneratedRequisitionsParamVO.finalItem) + "'".
/* Fam¡lia Inicial */
IF trim(string(ttGeneratedRequisitionsParamVO.initialFamily)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-familia  >= '" + string(ttGeneratedRequisitionsParamVO.initialFamily) + "'".
/* Fam¡lia Final */
IF trim(string(ttGeneratedRequisitionsParamVO.finalFamily)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-familia  <= '" + string(ttGeneratedRequisitionsParamVO.finalFamily) + "'".
/* Planejador Inicial */
IF trim(string(ttGeneratedRequisitionsParamVO.initialPlanner)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cd-planejado  >= '" + string(ttGeneratedRequisitionsParamVO.initialPlanner) + "'".
/* Planejador Final */
IF trim(string(ttGeneratedRequisitionsParamVO.finalPlanner)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cd-planejado  <= '" + string(ttGeneratedRequisitionsParamVO.finalPlanner) + "'".
/* Grupo Estoque Inicial */
/*Talvez tenha que ser 'string(planej-produc-histor.ge-codigo)'*/
IF trim(string(ttGeneratedRequisitionsParamVO.initialStockGroup)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.ge-codigo  >= '" + string(ttGeneratedRequisitionsParamVO.initialStockGroup) + "'".
/* Grupo Estoque Final */
IF trim(string(ttGeneratedRequisitionsParamVO.finalStockGroup)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.ge-codigo  <= '" + string(ttGeneratedRequisitionsParamVO.finalStockGroup) + "'".
/* Comprador Inicial */
IF trim(string(ttGeneratedRequisitionsParamVO.initialBuyer)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-comprado  >= '" + string(ttGeneratedRequisitionsParamVO.initialBuyer) + "'".
/* Comprador Final */
IF trim(string(ttGeneratedRequisitionsParamVO.finalBuyer)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-comprado  <= '" + string(ttGeneratedRequisitionsParamVO.finalBuyer) + "'".
/* C¢digo do Usu rio */
IF trim(string(ttGeneratedRequisitionsParamVO.userCode)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-usuar  = '" + string(ttGeneratedRequisitionsParamVO.userCode) + "'".
/* Criada e Reprogramada */
IF ttGeneratedRequisitionsParamVO.createAction AND ttGeneratedRequisitionsParamVO.reprogrammingAction THEN
    ASSIGN defaultWhere = defaultWhere + " and (planej-produc-histor.cod-acao  = '1' or planej-produc-histor.cod-acao  = '2') ".
ELSE DO:
    /* Criada */
    IF ttGeneratedRequisitionsParamVO.createAction THEN
        ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-acao  = '1' ".
    ELSE
        ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-acao  <> '1' ".
    /* Reprogramada */
    IF ttGeneratedRequisitionsParamVO.reprogrammingAction THEN
        ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-acao  = '2' ".
    ELSE
        ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-acao  <> '2' ".
END.

ASSIGN TABLENAME = "planej-produc-histor".

squery = "for each " + TABLENAME + " no-lock where " + defaultWhere + ".".

CREATE BUFFER hbuffer FOR TABLE TABLENAME.
CREATE QUERY hquery.
hquery:SET-BUFFERS( hbuffer ).
hquery:QUERY-PREPARE( squery ).
hquery:FORWARD-ONLY.
hquery:QUERY-OPEN.

hquery:GET-FIRST( NO-LOCK ).

REPEAT WHILE NOT hquery:QUERY-OFF-END:
    
    FIND FIRST ttGeneratedRequisitionsItemVO 
        WHERE ttGeneratedRequisitionsItemVO.ITEM = hBuffer:BUFFER-FIELD("it-codigo"):BUFFER-VALUE
        AND   ttGeneratedRequisitionsItemVO.site = hBuffer:BUFFER-FIELD("cod-estabel"):BUFFER-VALUE NO-LOCK NO-ERROR.

    IF NOT AVAILABLE ttGeneratedRequisitionsItemVO THEN DO:        

        CREATE ttGeneratedRequisitionsItemVO.
        ASSIGN ttGeneratedRequisitionsItemVO.site       = hBuffer:BUFFER-FIELD("cod-estabel"):BUFFER-VALUE
               ttGeneratedRequisitionsItemVO.ITEM       = hBuffer:BUFFER-FIELD("it-codigo"):BUFFER-VALUE
               ttGeneratedRequisitionsItemVO.family     = hBuffer:BUFFER-FIELD("cod-familia"):BUFFER-VALUE
               ttGeneratedRequisitionsItemVO.stockGroup = hBuffer:BUFFER-FIELD("ge-codigo"):BUFFER-VALUE.

            FIND FIRST ITEM WHERE  ITEM.it-codigo = hBuffer:BUFFER-FIELD("it-codigo"):BUFFER-VALUE NO-LOCK NO-ERROR.
            IF AVAILABLE ITEM THEN DO:                        IF TRIM(ITEM.descricao-1) = "" THEN
                    ttGeneratedRequisitionsItemVO.itemDescription = ITEM.descricao-2.
                ELSE
                    ttGeneratedRequisitionsItemVO.itemDescription = ITEM.descricao-1.
            END.

            FIND FIRST estabelec WHERE estabelec.cod-estabel = hBuffer:BUFFER-FIELD("cod-estabel"):BUFFER-VALUE NO-LOCK NO-ERROR.
            IF AVAILABLE estabelec THEN
                ttGeneratedRequisitionsItemVO.siteDescription = estabelec.nome.
    END.

    hquery:GET-NEXT( NO-LOCK ).
END.
    
DELETE OBJECT hquery.
DELETE OBJECT hbuffer.
                                                       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getGeneratedRequisitions DBOFunction 
PROCEDURE getGeneratedRequisitions :
/*------------------------------------------------------------------------------
  Purpose:     Retorna as ordens geradas, filtrando pelos parƒmetros passados.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM TABLE FOR ttGeneratedRequisitionsParamVO.
DEF INPUT PARAM site AS character.
DEF INPUT PARAM item AS character.
DEF OUTPUT PARAM TABLE FOR ttGeneratedRequisitionsVO.
DEF OUTPUT PARAM TABLE FOR RowErrors.

DEFINE VARIABLE hquery  AS HANDLE NO-UNDO.
DEFINE VARIABLE hbuffer AS HANDLE NO-UNDO.
DEFINE VARIABLE squery AS CHARACTER NO-UNDO.
DEFINE VARIABLE defaultWhere AS CHARACTER   NO-UNDO.
DEFINE VARIABLE TABLENAME AS CHARACTER   NO-UNDO.

FOR FIRST ttGeneratedRequisitionsParamVO NO-LOCK:
END.

ASSIGN defaultWhere = "".

/* C¢digo do Plano */
IF trim(string(ttGeneratedRequisitionsParamVO.planCode)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cdn-plano  = " + string(ttGeneratedRequisitionsParamVO.planCode).
/* RPW Request */
IF trim(string(ttGeneratedRequisitionsParamVO.rpwRequest)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.num-ped-exec  = " + string(ttGeneratedRequisitionsParamVO.rpwRequest).

/* Data inicial */
IF trim(string(ttGeneratedRequisitionsParamVO.initialDate)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  (planej-produc-histor.dt-inicio  >= date('" + string(ttGeneratedRequisitionsParamVO.initialDate) + "') or planej-produc-histor.dt-inicio = ?)".

/* Data Final */
IF trim(string(ttGeneratedRequisitionsParamVO.finalDate)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and (planej-produc-histor.dt-termino  <= date('" + string(ttGeneratedRequisitionsParamVO.finalDate) + "') or planej-produc-histor.dt-termino = ?)".

/* Hora Inicial */
IF trim(string(ttGeneratedRequisitionsParamVO.initialTime)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and ((planej-produc-histor.dt-inicio > date('" + string(ttGeneratedRequisitionsParamVO.initialDate) + "') or planej-produc-histor.dt-inicio = ?)"+
        " OR ((planej-produc-histor.dt-inicio  = DATE('" + string(ttGeneratedRequisitionsParamVO.initialDate) + "') or planej-produc-histor.dt-inicio = ?) AND planej-produc-histor.hr-geracao  >= '" + string(ttGeneratedRequisitionsParamVO.initialTime) + "'))".

/* Item Inicial */
IF trim(string(ttGeneratedRequisitionsParamVO.initialItem)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.it-codigo  >= '" + string(ttGeneratedRequisitionsParamVO.initialItem) + "'".
/* Item Final */
IF trim(string(ttGeneratedRequisitionsParamVO.finalItem)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.it-codigo  <= '" + string(ttGeneratedRequisitionsParamVO.finalItem) + "'".
/* Fam¡lia Inicial */
IF trim(string(ttGeneratedRequisitionsParamVO.initialFamily)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-familia  >= '" + string(ttGeneratedRequisitionsParamVO.initialFamily) + "'".
/* Fam¡lia Final */
IF trim(string(ttGeneratedRequisitionsParamVO.finalFamily)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-familia  <= '" + string(ttGeneratedRequisitionsParamVO.finalFamily) + "'".
/* Planejador Inicial */
IF trim(string(ttGeneratedRequisitionsParamVO.initialPlanner)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cd-planejado  >= '" + string(ttGeneratedRequisitionsParamVO.initialPlanner) + "'".
/* Planejador Final */
IF trim(string(ttGeneratedRequisitionsParamVO.finalPlanner)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cd-planejado  <= '" + string(ttGeneratedRequisitionsParamVO.finalPlanner) + "'".
/* Grupo Estoque Inicial */
/*Talvez tenha que ser 'string(planej-produc-histor.ge-codigo)'*/
IF trim(string(ttGeneratedRequisitionsParamVO.initialStockGroup)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.ge-codigo  >= '" + string(ttGeneratedRequisitionsParamVO.initialStockGroup) + "'".
/* Grupo Estoque Final */
IF trim(string(ttGeneratedRequisitionsParamVO.finalStockGroup)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.ge-codigo  <= '" + string(ttGeneratedRequisitionsParamVO.finalStockGroup) + "'".
/* Comprador Inicial */
IF trim(string(ttGeneratedRequisitionsParamVO.initialBuyer)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-comprado  >= '" + string(ttGeneratedRequisitionsParamVO.initialBuyer) + "'".
/* Comprador Final */
IF trim(string(ttGeneratedRequisitionsParamVO.finalBuyer)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-comprado  <= '" + string(ttGeneratedRequisitionsParamVO.finalBuyer) + "'".
/* C¢digo do Usu rio */
IF trim(string(ttGeneratedRequisitionsParamVO.userCode)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-usuar  = '" + string(ttGeneratedRequisitionsParamVO.userCode) + "'".
/* Criada e Reprogramada */
IF ttGeneratedRequisitionsParamVO.createAction AND ttGeneratedRequisitionsParamVO.reprogrammingAction THEN
    ASSIGN defaultWhere = defaultWhere + " and (planej-produc-histor.cod-acao  = '1' or planej-produc-histor.cod-acao  = '2') ".
ELSE DO:
    /* Criada */
    IF ttGeneratedRequisitionsParamVO.createAction THEN
        ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-acao  = '1' ".
    ELSE
        ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-acao  <> '1' ".
    /* Reprogramada */
    IF ttGeneratedRequisitionsParamVO.reprogrammingAction THEN
        ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-acao  = '2' ".
    ELSE
        ASSIGN defaultWhere = defaultWhere + " and  planej-produc-histor.cod-acao  <> '2' ".
END.

ASSIGN TABLENAME = "planej-produc-histor".

squery = "for each " + TABLENAME + " no-lock where planej-produc-histor.it-codigo  = '" + ITEM +
    "' AND planej-produc-histor.cod-estabel = '" + site + "' " + defaultWhere + ".".


CREATE BUFFER hbuffer FOR TABLE TABLENAME.
CREATE QUERY hquery.
hquery:SET-BUFFERS( hbuffer ).
hquery:QUERY-PREPARE( squery ).
hquery:FORWARD-ONLY.
hquery:QUERY-OPEN.

hquery:GET-FIRST( NO-LOCK ).

REPEAT WHILE NOT hquery:QUERY-OFF-END:
    CREATE ttGeneratedRequisitionsVO.

    ASSIGN ttGeneratedRequisitionsVO.userCode            = hBuffer:BUFFER-FIELD("cod-usuar"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.creationTime        = hBuffer:BUFFER-FIELD("hr-geracao"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.creationDate        = hBuffer:BUFFER-FIELD("dt-geracao"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.businessUnit        = hBuffer:BUFFER-FIELD("cod-unid-negoc"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.productionLine      = hBuffer:BUFFER-FIELD("nr-linha"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.buyer               = hBuffer:BUFFER-FIELD("cod-comprado"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.planner             = hBuffer:BUFFER-FIELD("cd-planejado"):BUFFER-VALUE
           /* VO - Char; Tabela - Int */
           ttGeneratedRequisitionsVO.stockGroup          = string(hBuffer:BUFFER-FIELD("ge-codigo"):BUFFER-VALUE)
           ttGeneratedRequisitionsVO.family              = hBuffer:BUFFER-FIELD("cod-familia"):BUFFER-VALUE
           /* VO - Char; Tabela - Int*/
           ttGeneratedRequisitionsVO.planCode            = string(hBuffer:BUFFER-FIELD("cdn-plano"):BUFFER-VALUE)
           ttGeneratedRequisitionsVO.reprogrammingDate   = hBuffer:BUFFER-FIELD("dt-reprog"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.deliveryDate        = hBuffer:BUFFER-FIELD("dt-entrega"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.balance             = hBuffer:BUFFER-FIELD("num-saldo"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.site                = hBuffer:BUFFER-FIELD("cod-estabel"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.quantity            = hBuffer:BUFFER-FIELD("qt-ordem"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.finalDate           = hBuffer:BUFFER-FIELD("dt-termino"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.initialDate         = hBuffer:BUFFER-FIELD("dt-inicio"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.shortName           = hBuffer:BUFFER-FIELD("nome-abrev"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.customerRequest     = hBuffer:BUFFER-FIELD("nr-pedido"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.reportType          = hBuffer:BUFFER-FIELD("rep-prod"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.parcel              = hBuffer:BUFFER-FIELD("nr-parcela"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.productionReqNumber = hBuffer:BUFFER-FIELD("nr-ord-produ"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.purchaseReqNumber   = hBuffer:BUFFER-FIELD("num-ord-compra"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.unitOfMeasure       = hBuffer:BUFFER-FIELD("des-un"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.lot                 = hBuffer:BUFFER-FIELD("lote-serie"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.itemDescription     = hBuffer:BUFFER-FIELD("desc-item"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.reference           = hBuffer:BUFFER-FIELD("cod-refer"):BUFFER-VALUE
           ttGeneratedRequisitionsVO.item                = hBuffer:BUFFER-FIELD("it-codigo"):BUFFER-VALUE
           /* VO - Int; Tabela - Char*/
           ttGeneratedRequisitionsVO.action              = int(hBuffer:BUFFER-FIELD("cod-acao"):BUFFER-VALUE)
           ttGeneratedRequisitionsVO.rpwRequestNumber    = hBuffer:BUFFER-FIELD("num-ped-exec"):buffer-value
           ttGeneratedRequisitionsVO.sequence            = hBuffer:BUFFER-FIELD("num-seq"):BUFFER-VALUE.

    hquery:GET-NEXT( NO-LOCK ).
END.
    
DELETE OBJECT hquery.
DELETE OBJECT hbuffer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getItemsByKeyRecord DBOFunction 
PROCEDURE getItemsByKeyRecord :
/*------------------------------------------------------------------------------
  Purpose:     Retorna itens, filtrando pelos parƒmetros chave.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM TABLE FOR ttKeyRecordsParamVO.
    DEF OUTPUT PARAM TABLE FOR ttItemKeyRecordVO.
    DEF OUTPUT PARAM TABLE FOR RowErrors.



    DEFINE var i-ano-periodo AS INT.
    DEFINE var i-nr-periodo AS INT.
    DEFINE var c-it-codigo-ini AS CHAR.
    DEFINE var c-it-codigo-fim AS CHAR.
    DEFINE var c-fm-codigo-ini AS CHAR.
    DEFINE var c-fm-codigo-fim AS CHAR.
    DEFINE var l-comp AS LOGICAL. /*ITENS COMPRADOS*/
    DEFINE var l-prod AS LOGICAL. /*ITENS FABRICADOS*/
    DEFINE var i-ge-codigo-ini AS INT.
    DEFINE var i-ge-codigo-fim AS INT.
    DEFINE var c-cd-planejado-ini AS CHAR.
    DEFINE var c-cd-planejado-fim AS CHAR.
    DEFINE var i-nr-linha-ini AS INT.
    DEFINE var i-nr-linha-fim AS INT.
    DEFINE var c-cod-estabel-ini AS CHAR.
    DEFINE var c-cod-estabel-fim AS CHAR.
     DEFINE VAR c-unid-negoc-ini AS CHAR.
     DEFINE VAR c-unid-negoc-fim AS CHAR.
    DEFINE var da-corte  AS DATE.
    DEFINE var planCode AS INT.
        

    find first ttKeyRecordsParamVO no-lock no-error.
    if avail ttKeyRecordsParamVO then do:
        assign i-ano-periodo      = ttKeyRecordsParamVO.periodYear
               i-nr-periodo       = ttKeyRecordsParamVO.periodNumber
               c-it-codigo-ini    = ttKeyRecordsParamVO.initialItem
               c-it-codigo-fim    = ttKeyRecordsParamVO.finalItem
               c-fm-codigo-ini    = ttKeyRecordsParamVO.initialFamily
               c-fm-codigo-fim    = ttKeyRecordsParamVO.finalFamily
               l-comp             = ttKeyRecordsParamVO.isPurchased
               l-prod             = ttKeyRecordsParamVO.isMade
               i-ge-codigo-ini    = ttKeyRecordsParamVO.initialStockGroup
               i-ge-codigo-fim    = ttKeyRecordsParamVO.finalStockGroup
               c-cd-planejado-ini = ttKeyRecordsParamVO.initialPlanned
               c-cd-planejado-fim = ttKeyRecordsParamVO.finalPlanned
               i-nr-linha-ini     = ttKeyRecordsParamVO.initialProductionLine
               i-nr-linha-fim     = ttKeyRecordsParamVO.finalProductionLine
               c-unid-negoc-ini   = ttKeyRecordsParamVO.initialBusinessUnit
               c-unid-negoc-fim   = ttKeyRecordsParamVO.finalBusinessUnit
               c-cod-estabel-ini  = ttKeyRecordsParamVO.initialSite
               c-cod-estabel-fim  = ttKeyRecordsParamVO.finalSite
               da-corte           = ttKeyRecordsParamVO.transactionDate 
               planCode           = ttKeyRecordsParamVO.planCode.
    end.
    if not avail ttKeyRecordsParamVO then do:
        /*CRIA ERRO*/
        leave.
    end.
        
    DEF VAR l-next AS LOG.
    DEF VAR da-ini-ord   AS DATE                     NO-UNDO.
    DEF VAR da-fisica    AS DATE                     NO-UNDO.
    
    empty TEMP-TABLE tt-digita.
                 
    run pi-calcula-tam-per.

    empty temp-table tt-periodo.
    
    find first pl-prod where pl-prod.cd-plano = planCode no-lock no-error.
                
    if  can-find(first tt-digita) THEN
        for each tt-digita:
            
            blk-it-per:

            for each it-periodo
                where it-periodo.num-calc-plano = pl-prod.num-calc-plano
                  and it-periodo.it-codigo      = tt-digita.c-it-codigo no-lock:

                if  it-periodo.ano     > i-ano-periodo
                or (it-periodo.ano     = i-ano-periodo
                and it-periodo.periodo > i-nr-periodo) then
                    leave blk-it-per.

                if  it-periodo.qt-ord-plan <= 0 then
                    next.

                FIND FIRST tt-periodo
                     WHERE tt-periodo.it-codigo   = it-periodo.it-codigo
                       AND tt-periodo.cod-estabel = it-periodo.cod-estabel
                       AND tt-periodo.data        = it-periodo.data 
                       AND tt-periodo.cod-refer   = it-periodo.cod-refer NO-LOCK NO-ERROR.
                IF NOT AVAIL tt-periodo THEN DO:
                    create tt-periodo.
                    buffer-copy it-periodo to tt-periodo.
                END.
            end.
        end.    
        else do:        
            for each pl-it-calc
                where pl-it-calc.cd-plano   = pl-prod.cd-plano
                  and pl-it-calc.it-codigo >= c-it-codigo-ini
                  and pl-it-calc.it-codigo <= c-it-codigo-fim
                  and pl-it-calc.fm-codigo >= c-fm-codigo-ini
                  and pl-it-calc.fm-codigo <= c-fm-codigo-fim no-lock:
    
                if  pl-it-calc.demanda      = 2
                or (pl-it-calc.compr-fabric = 1
                and not l-comp)
                or (pl-it-calc.compr-fabric = 2
                and not l-prod) then
                    next.
    
                if  not avail item
                or  item.it-codigo <> pl-it-calc.it-codigo then do:
    
                    for first item
                        where item.it-codigo = pl-it-calc.it-codigo no-lock:
                    end.
    
                    if  not avail item then next.
    
                    if item.ge-codigo < int(i-ge-codigo-ini) 
                    OR item.ge-codigo > int(i-ge-codigo-fim) then next.
    
                    if pl-prod.log-multi-estabel = yes then do:
                        
                        IF NOT CAN-FIND (FIRST item-uni-estab 
                                         WHERE item-uni-estab.it-codigo     = pl-it-calc.it-codigo
                                         AND   item-uni-estab.cd-planejado >= c-cd-planejado-ini 
                                         AND   item-uni-estab.cd-planejado <= c-cd-planejado-fim
                                         AND   item-uni-estab.nr-linha     >=  i-nr-linha-ini
                                         AND   item-uni-estab.nr-linha     <= i-nr-linha-fim
                                         AND   item-uni-estab.cod-estabel  >= c-cod-estabel-ini 
                                         AND   item-uni-estab.cod-estabel  <= c-cod-estabel-fim) THEN 
                            ASSIGN l-next = YES.
                        ELSE DO:
                            ASSIGN l-next = NO.
                            &IF defined(bf_man_206b) &THEN
                                if CAN-FIND(funcao WHERE funcao.cd-funcao = "EMS2-UNIDADE-NEGOCIO" AND funcao.ativo = YES) then do:
                                    IF NOT CAN-FIND (FIRST item-uni-estab 
                                             WHERE item-uni-estab.it-codigo       = pl-it-calc.it-codigo
                                             AND   item-uni-estab.cd-planejado   >= c-cd-planejado-ini 
                                             AND   item-uni-estab.cd-planejado   <= c-cd-planejado-fim
                                             AND   item-uni-estab.nr-linha       >= int(i-nr-linha-ini)
                                             AND   item-uni-estab.nr-linha       <= int(i-nr-linha-fim)
                                             AND   item-uni-estab.cod-estabel    >= c-cod-estabel-ini 
                                             AND   item-uni-estab.cod-estabel    <= c-cod-estabel-fim
                                             AND   item-uni-estab.cod-unid-negoc >= c-unid-negoc-ini 
                                             AND   item-uni-estab.cod-unid-negoc <= c-unid-negoc-fim) THEN 
                                        ASSIGN l-next = YES.
                                end.
                            &ENDIF
                        END.
    
                        IF l-next = YES THEN NEXT.
                    end. /* IF pl-prod.log-multi-estabel = YES THEN DO: */
                    else do:
                        
                        if    item.cd-planejado < c-cd-planejado-ini
                           or item.cd-planejado > c-cd-planejado-fim
                           or item.nr-linha     < int(i-nr-linha-ini)
                           or item.nr-linha     > int(i-nr-linha-fim)
                           or item.cod-estabel  < c-cod-estabel-ini
                           or item.cod-estabel  > c-cod-estabel-fim THEN next.
                        
                            
    
                        &IF defined(bf_man_206b) &THEN
                            if CAN-FIND(funcao WHERE funcao.cd-funcao = "EMS2-UNIDADE-NEGOCIO" AND funcao.ativo = YES) then do:
                                if item.cod-unid-negoc < c-unid-negoc-ini or
                                   item.cod-unid-negoc > c-unid-negoc-fim then next.
                            end.
                        &ENDIF
                    end. /* Else -- IF pl-prod.log-multi-estabel = YES THEN DO: -- */
                end. /* if  not avail item or item.it-codigo <> pl-it-calc.it-codigo then do: */
    
                blk-it-per:
                for each it-periodo
                    where it-periodo.num-calc-plano = pl-prod.num-calc-plano
                      and it-periodo.it-codigo      = pl-it-calc.it-codigo no-lock:
    
                    RUN pi-carrega-tt-item (INPUT it-periodo.it-codigo, INPUT it-periodo.cod-estabel).
                    FIND FIRST tt-item NO-ERROR.
                    IF AVAIL tt-item THEN DO:
                                        
                                                if  it-periodo.qt-ord-plan <= 0 then
                            next.
        
                        IF tt-item.compr-fabric = 2 THEN
                           RUN pi-busca-data-inicio-termino (INPUT tt-item.it-codigo,
                                                             OUTPUT da-ini-ord,
                                                             OUTPUT da-fisica).
                        ELSE DO:
        
                            find periodo use-index codigo
                                where periodo.cd-tipo    = pl-prod.cd-tipo
                                  and periodo.ano        = it-periodo.ano
                                  and periodo.nr-periodo = it-periodo.periodo no-lock no-error.
        
        
                                assign da-ini-ord = (periodo.dt-inicio - tt-item.res-int-comp
                                                   - tt-item.res-for-comp - tt-item.res-cq-comp)
                                                   - if  tt-item.tipo-est-seg = 2 
                                                     and tt-item.conv-tempo-seg = no  /* converte tempo */
                                                     and pl-prod.tp-seg-comp then
                                                         tt-item.tempo-segur
                                                     else 0.
        
                            if  da-ini-ord > da-corte THEN
                                NEXT blk-it-per. 
        
                            RUN pi-retorna-dt-fisica (INPUT it-periodo.data, INPUT tt-item.tempo-segur, OUTPUT da-fisica).
        
                        END.
        
                        FIND FIRST tt-periodo
                             WHERE tt-periodo.it-codigo   = it-periodo.it-codigo
                               AND tt-periodo.cod-estabel = it-periodo.cod-estabel
                               AND tt-periodo.data        = it-periodo.data 
                               AND tt-periodo.cod-refer   = it-periodo.cod-refer NO-LOCK NO-ERROR.
                        IF NOT AVAIL tt-periodo THEN DO:
                            create tt-periodo.
                            buffer-copy it-periodo to tt-periodo.
                            ASSIGN tt-periodo.dt-inicio = da-ini-ord
                                   tt-periodo.dt-fisica = da-fisica.
                        END.
        
        
                        find first tt-digita
                             where tt-digita.c-it-codigo = it-periodo.it-codigo no-error.
                        if  not avail tt-digita then do:
                            create tt-digita.
                            assign tt-digita.c-it-codigo = it-periodo.it-codigo
                                   tt-digita.c-descricao = tt-item.desc-item
                                   tt-digita.c-un        = tt-item.un
                                   tt-digita.c-fm-codigo = tt-item.fm-codigo. /*Os dados estavam em branco no browser*/
                        END.
                    END.
                END. 
            end.
        end.

       for each tt-digita no-lock:
           create ttItemKeyRecordVO.
           assign ttItemKeyRecordVO.itemCode        = tt-digita.c-it-codigo
                  ttItemKeyRecordVO.itemDescription = tt-digita.c-descricao
                  ttItemKeyRecordVO.unitOfMeasure   = tt-digita.c-un
                  ttItemKeyRecordVO.family          = tt-digita.c-fm-codigo
                  ttItemKeyRecordVO.isSelected      = tt-digita.log-sel.
       end.

       return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getProductionPlanDetail DBOFunction 
PROCEDURE getProductionPlanDetail :
/*------------------------------------------------------------------------------
  Purpose:     Retorna todos os campos de um plano de produ‡Æo.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM planCode AS integer.
DEF output PARAM TABLE FOR ttProductionPlanVO.
DEF OUTPUT PARAM TABLE FOR RowErrors.
DEFINE VARIABLE h-bo AS HANDLE    NO-UNDO.


RUN inbo/boin318.p PERSISTENT SET h-bo.
RUN openQuerystatic IN h-bo (INPUT "main").

EMPTY TEMP-TABLE RowErrors.
RUN emptyRowErrors IN h-bo.

empty temp-table ttProductionPlanVO.
EMPTY TEMP-TABLE tt-pl-prod.


RUN goToKey in h-bo (INPUT planCode).

RUN getRecord IN h-bo(OUTPUT TABLE tt-pl-prod).


FOR FIRST tt-pl-prod no-lock:
END.

if avail tt-pl-prod then do:
    create ttProductionPlanVO.
    assign ttProductionPlanVO.planCode                     =    tt-pl-prod.cd-plano
           ttProductionPlanVO.planDescription              =    tt-pl-prod.descricao
           ttProductionPlanVO.planType                     =    tt-pl-prod.tipo-plano
           ttProductionPlanVO.periodType                   =    tt-pl-prod.cd-tipo
           ttProductionPlanVO.initialPeriodYear            =    tt-pl-prod.ano-per-ini
           ttProductionPlanVO.finalPeriodYear              =    tt-pl-prod.ano-per-fim
           ttProductionPlanVO.initialPeriod                =    tt-pl-prod.nr-per-ini
           ttProductionPlanVO.finalPeriod                  =    tt-pl-prod.nr-per-fim
           ttProductionPlanVO.validateDate                 =    tt-pl-prod.dt-validade
           ttProductionPlanVO.purchasedReprogramming       =    tt-pl-prod.tp-rep-comp
           ttProductionPlanVO.considersSafetyStockPurch    =    tt-pl-prod.tp-seg-comp
           ttProductionPlanVO.considersStockBalancePurch   =    tt-pl-prod.saldo-comp
           ttProductionPlanVO.considersPurchaseReq         =    tt-pl-prod.ordens-comp
           ttProductionPlanVO.considersMadeNeeds           =    tt-pl-prod.pedidos-fabr
           ttProductionPlanVO.considersBacklogPurch        =    tt-pl-prod.res-comp
           ttProductionPlanVO.reprogrammingMade            =    tt-pl-prod.tp-rep-fabr
           ttProductionPlanVO.considersSafetyStockMade     =    tt-pl-prod.tp-seg-fabr
           ttProductionPlanVO.considersStockBalanceMade    =    tt-pl-prod.saldo-fabr
           ttProductionPlanVO.considersProductionReq       =    tt-pl-prod.ordens-fabr
           ttProductionPlanVO.considersPurchNeeds          =    tt-pl-prod.pedidos-comp                                  
           ttProductionPlanVO.considersBacklogMade         =    tt-pl-prod.res-fabr                                
           ttProductionPlanVO.generateTracking             =    tt-pl-prod.rastreamento                            
           ttProductionPlanVO.calculationStatus            =    tt-pl-prod.calculo                                 
           ttProductionPlanVO.regeneratePlan               =    tt-pl-prod.regera-plano                            
           ttProductionPlanVO.userCode                     =    tt-pl-prod.usuario
           ttProductionPlanVO.initialDate                  =    tt-pl-prod.data-inicio
           ttProductionPlanVO.initialTime                  =    tt-pl-prod.hora-inicio
           ttProductionPlanVO.finalDate                    =    tt-pl-prod.data-termino
           ttProductionPlanVO.finalTime                    =    tt-pl-prod.hora-termino
           ttProductionPlanVO.independentDemandItems       =    tt-pl-prod.it-dem-ind
           ttProductionPlanVO.dependentDemandItems         =    tt-pl-prod.it-dem-dep
           ttProductionPlanVO.purchaseReq                  =    tt-pl-prod.nr-ord-comp
           ttProductionPlanVO.manufacturingReq             =    tt-pl-prod.nr-ord-fabr
           ttProductionPlanVO.reprogrammingReq             =    tt-pl-prod.nr-ord-rep
           ttProductionPlanVO.manufacturingItems           =    tt-pl-prod.it-fabr                                 
           ttProductionPlanVO.committedNeeds               =    tt-pl-prod.nr-res-comp                             
           ttProductionPlanVO.itemsOrder                   =    tt-pl-prod.nr-item-pedi                            
           ttProductionPlanVO.plannedReq                   =    tt-pl-prod.nr-ord-plan                             
           ttProductionPlanVO.plannedNeeds                 =    tt-pl-prod.nr-res-plan                             
           ttProductionPlanVO.planStatus                   =    tt-pl-prod.pl-estado                               
           ttProductionPlanVO.initialDateNetChange         =    tt-pl-prod.dt-ini-net                              
           ttProductionPlanVO.finalDateNetChange           =    tt-pl-prod.dt-fim-net                              
           ttProductionPlanVO.initialTimeNetChange         =    tt-pl-prod.h-ini-net                               
           ttProductionPlanVO.finalTimeNetChange           =    tt-pl-prod.h-fim-net                               
           ttProductionPlanVO.itemsNetChange               =    tt-pl-prod.nr-it-net                               
           ttProductionPlanVO.fixedHorizon                 =    tt-pl-prod.horiz-fixo                              
           ttProductionPlanVO.considersConfirmQuantity     =    tt-pl-prod.quant-confirm                           
           ttProductionPlanVO.defaultSite                  =    tt-pl-prod.cod-estabel
           ttProductionPlanVO.onlyApprovedPurchOrders      =    tt-pl-prod.aprov-comp
           ttProductionPlanVO.onlyApprovedMadeOrders       =    tt-pl-prod.aprov-fabr
           ttProductionPlanVO.considersPayrollBalanceMade  =    tt-pl-prod.consig-fabr
           ttProductionPlanVO.considersPayrollBalancePurch =    tt-pl-prod.consig-comp
           ttProductionPlanVO.considersTransitBalanceMade  =    tt-pl-prod.tran-comp
           ttProductionPlanVO.considersTransitBalancePurch =    tt-pl-prod.tran-fabr
           ttProductionPlanVO.thirdpartyBalanceMade        =    tt-pl-prod.benef-fabr
           ttProductionPlanVO.thirdpartyBalancePurch       =    tt-pl-prod.benef-comp
           ttProductionPlanVO.considersResupplyPurch       =    tt-pl-prod.tp-res-comp
           ttProductionPlanVO.considersResupplyMade        =    tt-pl-prod.tp-res-fabr
           ttProductionPlanVO.safetyDaysNumber             =    tt-pl-prod.nr-dias-seg
           ttProductionPlanVO.planCalculation              =    tt-pl-prod.calculo-plano
           ttProductionPlanVO.checkSum                     =    tt-pl-prod.check-sum
           ttProductionPlanVO.numIdPlan                    =    tt-pl-prod.num-id-Pl-prod
           ttProductionPlanVO.needByComponentList          =    tt-pl-prod.ind-lista-compon
           ttProductionPlanVO.configuredPVSales            =    tt-pl-prod.log-pv-config
           ttProductionPlanVO.deliveryPurchProcessing      =    tt-pl-prod.log-rb-compr
           ttProductionPlanVO.entryPurchProcessing         =    tt-pl-prod.log-eb-compr
           ttProductionPlanVO.deliveryPurchPayroll         =    tt-pl-prod.log-rc-compr
           ttProductionPlanVO.entryPurchPayroll            =    tt-pl-prod.log-ec-compr
           ttProductionPlanVO.entryMadePayroll             =    tt-pl-prod.log-ec-fabric
           ttProductionPlanVO.deliveryMadePayroll          =    tt-pl-prod.log-rc-fabric
           ttProductionPlanVO.deliveryMadeProcessing       =    tt-pl-prod.log-rb-fabric
           ttProductionPlanVO.entryMadeProcessing          =    tt-pl-prod.log-eb-fabric
           ttProductionPlanVO.numPlanCalculation           =    tt-pl-prod.num-calc-plano
           ttProductionPlanVO.isMultiSites                 =    tt-pl-prod.log-multi-estabel
           ttProductionPlanVO.grossRequirements            =    tt-pl-prod.log-nec-bruta
           ttProductionPlanVO.planInHorizon                = substr(tt-pl-prod.char-1,11,1)
           ttProductionPlanVO.repressionDemandPurch        = substr(tt-pl-prod.char-1,12,1)
           ttProductionPlanVO.repressionDemandMade         = substr(tt-pl-prod.char-1,13,1)

           ttProductionPlanVO.reprogramInProgressReqPurch = (substr(string(tt-pl-prod.int-1),1,1) = "1")
           ttProductionPlanVO.reprogramInProgressReqMade = (substr(string(tt-pl-prod.int-1),2,1) = "1")

           ttProductionPlanVO.deliveryPurchProcessing = if substr(tt-pl-prod.char-1,2,1) = "1" then true else false
           ttProductionPlanVO.deliveryMadeProcessing = if substr(tt-pl-prod.char-1,6,1) = "1" then true else false

           ttProductionPlanVO.entryPurchProcessing = if substr(tt-pl-prod.char-1,3,1) = "1" then true else false
           ttProductionPlanVO.entryMadeProcessing = if substr(tt-pl-prod.char-1,7,1) = "1" then true else false
           
           ttProductionPlanVO.deliveryPurchPayroll = if substr(tt-pl-prod.char-1,4,1) = "1" then true else false
           ttProductionPlanVO.deliveryMadePayroll = if substr(tt-pl-prod.char-1,8,1) = "1" then true else false
                
           ttProductionPlanVO.entryPurchPayroll = if substr(tt-pl-prod.char-1,5,1) = "1" then true else false
           ttProductionPlanVO.entryMadePayroll = if substr(tt-pl-prod.char-1,9,1) = "1" then true else false
           
           ttProductionPlanVO.providesAlocations       = tt-pl-prod.log-dispon-aloc-saldo
           ttProductionPlanVO.thirdBalanceSummaryPurch = if substring(tt-pl-prod.char-1,14,1) = "1" then true else false
           ttProductionPlanVO.thirdBalanceSummaryMade  = if substring(tt-pl-prod.char-1,15,1) = "1" then true else false
           
           ttProductionPlanVO.calculationOfHowToObtain = tt-pl-prod.idi-recalc-obten.

        assign ttProductionPlanVO.initialPeriodString = string(ttProductionPlanVO.initialPeriod)  + "/"  + string(ttProductionPlanVO.initialPeriodYear)
                   ttProductionPlanVO.finalPeriodString = string(ttProductionPlanVO.finalPeriod) + "/" + string(ttProductionPlanVO.finalPeriodYear).

    IF tt-pl-prod.tipo-plano = "PP" then do:
        ASSIGN ttProductionPlanVO.planType = "2".
    end.
    ELSE do:
        ASSIGN ttProductionPlanVO.planType = "1".
    end.

    return "OK":U.

end.

IF VALID-HANDLE(h-bo) THEN
    DELETE PROCEDURE h-bo.
    
return "OK":U.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getProductionPlanList DBOFunction 
PROCEDURE getProductionPlanList :
/*------------------------------------------------------------------------------
  Purpose:     Retorna os planos de produ‡Æo, filtrando pelos parƒmetros enviados.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM TABLE FOR ttProductionPlanParamVO.
DEF OUTPUT PARAM TABLE FOR ttProductionPlanSummaryVO.
DEF OUTPUT PARAM TABLE FOR RowErrors.


DEFINE VARIABLE hquery  AS HANDLE NO-UNDO.
DEFINE VARIABLE hbuffer AS HANDLE NO-UNDO.
DEFINE VARIABLE squery AS CHARACTER NO-UNDO.
DEFINE VARIABLE PWHERE AS CHARACTER   NO-UNDO.
DEFINE VARIABLE TABLENAME AS CHARACTER   NO-UNDO.

DEFINE VARIABLE cAux   AS CHARACTER NO-UNDO.
DEFINE VARIABLE iCount AS INTEGER   NO-UNDO.


DEFINE VARIABLE defaultWhere AS CHARACTER   NO-UNDO.

ASSIGN TABLENAME = "pl-prod".

FOR FIRST ttProductionPlanParamVO NO-LOCK:
END.

ASSIGN defaultWhere = "".

/*Ativo*/
IF ttProductionPlanParamVO.isActive THEN
    ASSIGN defaultWhere = defaultWhere + " (pl-prod.pl-estado = 1".
ELSE 
    ASSIGN defaultWhere = defaultWhere + " (pl-prod.pl-estado <> 1".

/*Inativo*/
IF ttProductionPlanParamVO.isInactive THEN
    ASSIGN defaultWhere = defaultWhere + " or pl-prod.pl-estado = 2)".
ELSE
    ASSIGN defaultWhere = defaultWhere + " or pl-prod.pl-estado <> 2)".

/*Tipo de Plano*/
/*Plano de Produ‡Æo*/
IF ttProductionPlanParamVO.isProductionPlan THEN
    ASSIGN defaultWhere = defaultWhere + " and (pl-prod.tipo-plano = " +  "~"" + "PP" + "~"".
    
ELSE
    ASSIGN defaultWhere = defaultWhere + " and (pl-prod.tipo-plano <> " +  "~"" + "PP" + "~"".
    
/*Plano de Venda*/
IF ttProductionPlanParamVO.isPlanSale THEN
    ASSIGN defaultWhere = defaultWhere + " or pl-prod.tipo-plano = " +  "~"" + "PV" + "~"" + ")".
ELSE
    ASSIGN defaultWhere = defaultWhere + " or pl-prod.tipo-plano <> " +  "~"" + "PV" + "~"" + ")".

/*Se a data inicial nÆo ‚ vazia*/
IF trim(string(ttProductionPlanParamVO.initialDate)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and (pl-prod.data-inicio >= " + string(ttProductionPlanParamVO.initialDate).

/*Se a data inicial e final nÆo sÆo vazias*/
IF trim(string(ttProductionPlanParamVO.finalDate)) <> "" AND trim(string(ttProductionPlanParamVO.initialDate)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " or pl-prod.data-termino <= " + string(ttProductionPlanParamVO.finalDate) + ")".

/*Per¡odo Inicial*/
/*Se per¡odo inicial ‚ diferente de vazio, compara os dados com o ano maior que o parƒmetro e depois se o n£mero do per¡odo ‚ maior que o parƒmetro */
IF trim(string(ttProductionPlanParamVO.initialPeriod)) <> "" THEN
    ASSIGN defaultWhere = defaultWhere + " and ((pl-prod.ano-per-ini > " + entry(2,string(ttProductionPlanParamVO.initialPeriod),"/") +
                          " or (pl-prod.nr-per-ini >= " + entry(1,string(ttProductionPlanParamVO.initialPeriod),"/") + " and pl-prod.ano-per-ini = " + entry(2,string(ttProductionPlanParamVO.initialPeriod),"/") + "))" .

/*Per¡odo Final*/
/*Se per¡odo final ‚ diferente de vazio, compara os dados com o ano menor que o parƒmetro e depois se o n£mero do per¡odo ‚ menor que o parƒmetro */
IF trim(string(ttProductionPlanParamVO.finalPeriod)) <> "" AND trim(string(ttProductionPlanParamVO.initialPeriod)) <> "" THEN DO:
    ASSIGN defaultWhere = defaultWhere + " or (pl-prod.ano-per-fim < " + entry(2,string(ttProductionPlanParamVO.finalPeriod),"/") +
                          " or (pl-prod.nr-per-fim <= " + entry(1,string(ttProductionPlanParamVO.finalPeriod),"/") + " and pl-prod.ano-per-fim = " + entry(2,string(ttProductionPlanParamVO.finalPeriod),"/") + ")))" .
END.

DEFINE VARIABLE searchCriteria AS CHARACTER NO-UNDO.

ASSIGN searchCriteria = ttProductionPlanParamVO.planCodeString.

IF trim(searchCriteria) <> "" THEN DO:
    IF NUM-ENTRIES(searchCriteria, ";") > 1 THEN DO:
         DO iCount = 1 TO NUM-ENTRIES(searchCriteria, ";"):
             ASSIGN cAux = ENTRY(iCount, searchCriteria, ";").
             IF NUM-ENTRIES(cAux, "-") > 1 THEN DO:
                 IF iCount = 1 THEN
                     ASSIGN pWhere = pWhere + " (pl-prod.cd-plano >= " + CHR(39) + trim(ENTRY(1, cAux, "-")) + CHR(39) + " AND " +
                                  " pl-prod.cd-plano <= " + CHR(39) + trim(ENTRY(2, cAux, "-")) + CHR(39) + " ) ".
                 ELSE ASSIGN pWhere = pWhere + " OR (pl-prod.cd-plano >= " + CHR(39) + trim(ENTRY(1, cAux, "-")) + CHR(39) + " AND " +
                                               " pl-prod.cd-plano <= " + CHR(39) + trim(ENTRY(2, cAux, "-")) + CHR(39) + " ) ".
             END.
             ELSE DO: 
                 IF iCount = 1 THEN
                   ASSIGN pWhere = pWhere + " pl-prod.cd-plano = " + CHR(39) + trim(cAux) + CHR(39) .
                 ELSE ASSIGN pWhere = pWhere + " OR pl-prod.cd-plano = " + CHR(39) + trim(cAux) + CHR(39).
             END.
         END.
     END.
     ELSE IF NUM-ENTRIES(searchCriteria, "-") > 1 THEN DO:
             IF iCount = 1 THEN
                  ASSIGN pWhere = pWhere + " (pl-prod.cd-plano >= ~"" + trim(ENTRY(1, searchCriteria, "-"))  + "~" AND " +
                                   " pl-prod.cd-plano <= ~""  + trim(ENTRY(2, searchCriteria, "-"))  + "~" ) ".
             ELSE ASSIGN pWhere = pWhere + "(pl-prod.cd-plano >= ~"" + trim(ENTRY(1, searchCriteria, "-")) + "~" AND " +
                                           " pl-prod.cd-plano <= ~"" + trim(ENTRY(2, searchCriteria, "-")) + "~" ) ".
     END.
     ELSE DO:
         ASSIGN pWhere = pWhere + "pl-prod.cd-plano = " + CHR(39) + searchCriteria + CHR(39).
     END.
     ASSIGN squery = "for each " + TABLENAME + " no-lock where " + pwhere + " and " + defaultWhere + " .".
 END.
 ELSE DO:
    ASSIGN squery = "for each " + TABLENAME + " no-lock where " + defaultWhere + " .".
 END.

CREATE BUFFER hbuffer FOR TABLE TABLENAME.
CREATE QUERY hquery.
hquery:SET-BUFFERS( hbuffer ).
hquery:QUERY-PREPARE( squery ).
hquery:FORWARD-ONLY.
hquery:QUERY-OPEN.

hquery:GET-FIRST( NO-LOCK ).

/* 
   Payroll == consignado
   Balance == saldo
   Backlog == reserva
   */

REPEAT WHILE NOT hquery:QUERY-OFF-END:
    CREATE ttProductionPlanSummaryVO.
    ASSIGN ttProductionPlanSummaryVO.planCode                = hBuffer:BUFFER-FIELD("cd-plano"):BUFFER-VALUE
           ttProductionPlanSummaryVO.planType                = hBuffer:BUFFER-FIELD("tipo-plano"):BUFFER-VALUE
           ttProductionPlanSummaryVO.calculationStatus       = hBuffer:BUFFER-FIELD("calculo"):BUFFER-VALUE
           ttProductionPlanSummaryVO.initialPeriodYear       = hBuffer:BUFFER-FIELD("ano-per-ini"):BUFFER-VALUE
           ttProductionPlanSummaryVO.finalPeriodYear         = hBuffer:BUFFER-FIELD("ano-per-fim"):BUFFER-VALUE
           ttProductionPlanSummaryVO.initialPeriod           = hBuffer:BUFFER-FIELD("nr-per-ini"):BUFFER-VALUE
           ttProductionPlanSummaryVO.finalPeriod             = hBuffer:BUFFER-FIELD("nr-per-fim"):BUFFER-VALUE
          /* ttProductionPlanSummaryVO.initialDate             = hBuffer:BUFFER-FIELD("data-inicio"):BUFFER-VALUE
           ttProductionPlanSummaryVO.finalDate               = hBuffer:BUFFER-FIELD("data-termino"):BUFFER-VALUE*/
           ttProductionPlanSummaryVO.planStatus              = hBuffer:BUFFER-FIELD("pl-estado"):BUFFER-VALUE
           ttProductionPlanSummaryVO.planDescription         = hBuffer:BUFFER-FIELD("descricao"):BUFFER-VALUE
           ttProductionPlanSummaryVO.isSelected              = NO
           ttProductionPlanSummaryVO.periodType              = hBuffer:BUFFER-FIELD("cd-tipo"):BUFFER-VALUE
           ttProductionPlanSummaryVO.percentualCalculation   = hBuffer:BUFFER-FIELD("num-perc-calc"):BUFFER-VALUE
           ttProductionPlanSummaryVO.isMultiSites            = hBuffer:BUFFER-FIELD("log-multi-estabel"):BUFFER-VALUE

        .
    
    hquery:GET-NEXT( NO-LOCK ).
END.

DELETE OBJECT hquery.
DELETE OBJECT hbuffer.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getProductionPlanSites DBOFunction 
PROCEDURE getProductionPlanSites :
/*------------------------------------------------------------------------------
  Purpose:     Retorna os estabelecimentos, marcando aqueles que estÆo relacionados com o plano de produ‡Æo passado.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM planCode AS integer.
DEF OUTPUT PARAM TABLE FOR ttProductionPlanSitesVO.
DEF OUTPUT PARAM TABLE FOR RowErrors.

FOR EACH estabelec NO-LOCK:

    FIND FIRST ttProductionPlanSitesVO NO-LOCK
         WHERE ttProductionPlanSitesVO.siteCode = estabelec.cod-estabel NO-ERROR.
    IF NOT AVAILABLE ttProductionPlanSitesVO THEN DO:
        CREATE ttProductionPlanSitesVO.
        ASSIGN ttProductionPlanSitesVO.siteCode        = estabelec.cod-estabel
               ttProductionPlanSitesVO.siteDescription = estabelec.nome
               ttProductionPlanSitesVO.isSelectedSite  = NO.
    END.

    FIND FIRST pl-prod-estab
         WHERE pl-prod-estab.cd-plano    = planCode
           AND pl-prod-estab.cod-estabel = estabelec.cod-estabel NO-LOCK NO-ERROR.
    IF AVAILABLE pl-prod-estab THEN
        ASSIGN ttProductionPlanSitesVO.isSelectedSite = YES.


END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE persistProductionPlan DBOFunction 
PROCEDURE persistProductionPlan :
/*------------------------------------------------------------------------------
  Purpose:     Gera um novo Plano ou atualiza um j  existente.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM TABLE FOR ttProductionPlanVO.
DEFINE INPUT PARAMETER actionType AS INT NO-UNDO.
DEF OUTPUT PARAM TABLE FOR RowErrors.
DEFINE VARIABLE h-bo AS HANDLE      NO-UNDO.



RUN inbo/boin318.p PERSISTENT SET h-bo.
RUN openQuerystatic IN h-bo (INPUT "main").

FOR FIRST ttProductionPlanVO  NO-LOCK:

    EMPTY TEMP-TABLE RowErrors.
    RUN emptyRowErrors IN h-bo.
    
    IF actionType = 1 THEN DO:      
        CREATE tt-pl-prod.
        RUN assignFields.
            
        RUN setRecord IN h-bo(INPUT TABLE tt-pl-prod).
    
        RUN createRecord IN h-bo.
    
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN getRowErrors IN h-bo(OUTPUT TABLE RowErrors).
        END.
    
    END.
    ELSE DO:
        empty temp-table tt-pl-prod.

        RUN goToKey IN h-bo(INPUT ttProductionPlanVO.planCode).
    
        RUN getRecord IN h-bo(OUTPUT TABLE tt-pl-prod).
        for first tt-pl-prod exclusive-lock:
            RUN assignFields.
        
            RUN setRecord IN h-bo(INPUT TABLE tt-pl-prod).
            RUN updateRecord IN h-bo.
        
            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN getRowErrors IN h-bo(OUTPUT TABLE RowErrors).
            END.
        end.

    END.
END.

IF VALID-HANDLE(h-bo) THEN
    DELETE PROCEDURE h-bo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-data-inicio-termino DBOFunction 
PROCEDURE pi-busca-data-inicio-termino :
/*------------------------------------------------------------------------------
  Purpose:     Busca data de in¡cio e data de t‚rmino da produ‡Æo de ordem.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM c-it-codigo LIKE ITEM.it-codigo.
DEF OUTPUT PARAM da-inicio AS DATE.
DEF OUTPUT PARAM da-termino AS DATE.

DEF BUFFER b-tt-item FOR tt-item.
DEF BUFFER b-periodo FOR periodo.

FIND b-tt-item WHERE b-tt-item.it-codigo = c-it-codigo.

find b-periodo use-index codigo
     where b-periodo.cd-tipo    = pl-prod.cd-tipo
       and b-periodo.ano        = it-periodo.ano
       and b-periodo.nr-periodo = it-periodo.periodo NO-LOCK NO-ERROR.



&IF DEFINED(bf_man_203) &THEN

assign i-nr-dias = if pl-it-calc.nr-dias-desl <> 999
                      then pl-it-calc.nr-dias-desl
                   else 0

       i-ressup = if tt-item.tipo-est-seg = 2   /* tempo */
                     and tt-item.conv-tempo-seg = no /* converte tempo seguran‡a */
                     and pl-prod.tp-seg-fabr
                     then tt-item.res-cq-fabri
                                  + tt-item.tempo-segur
                                  - i-nr-dias
                     else tt-item.res-cq-fabri - i-nr-dias.
&ELSE

assign i-nr-dias = if pl-it-calc.nr-dias-desl <> 999
                      then pl-it-calc.nr-dias-desl
                   else 0

       i-ressup = if item.tipo-est-seg = 2   /* tempo */
                     and item.conv-tempo-seg = no /* converte tempo seguran‡a */
                     and pl-prod.tp-seg-fabr
                     then if substring(program-name(1),1,3) = "plp"
                             then pl-it-calc.res-cq-fabr
                                  + pl-it-calc.tempo-segur
                                  - i-nr-dias
                             else item.res-cq-fabr
                                  + item.tempo-segur
                                  - i-nr-dias
                  else if substring(program-name(1),1,3) = "plp"
                          then pl-it-calc.res-cq-fabri - i-nr-dias
                          else item.res-cq-fabri - i-nr-dias.

&ENDIF

assign i-ressup = if i-ressup < 0
                     then 0
                  else i-ressup

       i-resto  = if  i-ressup <> 0
                      then i-ressup modulo i-tam-per
                  else 0
       i-ressup = if i-ressup <> 0
                     then truncate(i-ressup / i-tam-per, 0)
                  else 0.
       


do  i-ind = 1 to i-ressup:
    find prev b-periodo use-index codigo
         where b-periodo.cd-tipo = pl-prod.cd-tipo no-lock no-error.
end.
if  not avail b-periodo then
    find first b-periodo use-index codigo
         where b-periodo.cd-tipo = pl-prod.cd-tipo no-lock no-error.
assign da-termino = b-periodo.dt-inicio.


/************************ data de inicio ****************************/

&IF DEFINED(bf_man_203) &THEN


    assign i-ressup = tt-item.ressup-fabri
           de-qt-min = dec(substring(tt-item.char-1,20,12))
           de-qt-dlt = dec(substring(tt-item.char-1,35,12))
           i-dias-dlt = int(substring(tt-item.char-1,15,4)).
    if it-periodo.qt-ord-plan > de-qt-min then
       assign de-vezes = (it-periodo.qt-ord-plan - de-qt-min) / de-qt-dlt
              de-vezes = (if de-vezes = ? then
                             0
                          else
                             de-vezes)
              de-vezes = (if trunc(de-vezes,0) = de-vezes then
                             de-vezes
                          else
                             trunc(de-vezes,0) + 1)
              i-ressup = i-ressup + (de-vezes * i-dias-dlt).             

    assign i-ressup = if tt-item.tipo-est-seg = 2     /* tempo */
                      and tt-item.conv-tempo-seg = no /* converte tempo seguran‡a */
                      and pl-prod.tp-seg-fabr
                      then i-ressup 
                                   + tt-item.res-cq-fabri
                                   + tt-item.tempo-segur - i-nr-dias
                      else i-ressup 
                                + tt-item.res-cq-fabri - i-nr-dias.

&ELSE

assign i-ressup = pl-it-calc.ressup-fabri
       de-qt-min = dec(substring(pl-it-calc.char-1,20,12))
       de-qt-dlt = dec(substring(pl-it-calc.char-1,35,12))
       i-dias-dlt = int(substring(pl-it-calc.char-1,15,4)).
if it-periodo.qt-ord-plan > de-qt-min then
   assign de-vezes = (it-periodo.qt-ord-plan - de-qt-min) / de-qt-dlt
          de-vezes = (if de-vezes = ? then
                         0
                      else
                         de-vezes)
          de-vezes = (if trunc(de-vezes,0) = de-vezes then
                         de-vezes
                      else
                         trunc(de-vezes,0) + 1)
          i-ressup = i-ressup + (de-vezes * i-dias-dlt).             

assign i-ressup = if item.tipo-est-seg = 2     /* tempo */
                  and item.conv-tempo-seg = no /* converte tempo seguran‡a */
                  and pl-prod.tp-seg-fabr
                  then i-ressup 
                               + pl-it-calc.res-cq-fabri
                               + pl-it-calc.tempo-segur - i-nr-dias
                  else i-ressup 
                            + pl-it-calc.res-cq-fabri - i-nr-dias.

&ENDIF

assign i-ressup = if i-ressup < 0
                     then 0
                  else i-ressup
       i-resto  = if  i-ressup <> 0
                      then i-ressup modulo i-tam-per
                  else 0
       i-ressup = if i-ressup <> 0
                     then truncate(i-ressup / i-tam-per, 0)
                  else 0
       i-ressup = if i-resto > 0
                     then i-ressup + 1
                  else i-ressup.

find b-periodo use-index codigo
         where b-periodo.cd-tipo    = pl-prod.cd-tipo
           and b-periodo.ano        = it-periodo.ano
           and b-periodo.nr-periodo = it-periodo.periodo NO-LOCK NO-ERROR.
do  i-ind = 1 to i-ressup:
    find prev b-periodo use-index codigo
         where b-periodo.cd-tipo = pl-prod.cd-tipo no-lock no-error.
end.
if  not avail b-periodo then
    find first b-periodo use-index codigo
         where b-periodo.cd-tipo = pl-prod.cd-tipo no-lock.
assign da-inicio = b-periodo.dt-inicio.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-tam-per DBOFunction 
PROCEDURE pi-calcula-tam-per :
/*------------------------------------------------------------------------------
  Purpose:     Calcula o tamanho de um per¡odo.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    find tipo-per where tipo-per.cd-tipo = pl-prod.cd-tipo no-lock no-error.
    if available tipo-per then do:
        if  tipo-per.nr-dia = 0 then do:
            if  tipo-per.tipo = 3 then    
                assign i-tam-per = 7.
            else if  tipo-per.tipo = 2 then   
                     assign i-tam-per = 15.
                 else if  tipo-per.tipo = 1 then         
                          assign i-tam-per = 30.
        end.
        else
            assign i-tam-per = tipo-per.nr-dia.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-tt-item DBOFunction 
PROCEDURE pi-carrega-tt-item :
/*------------------------------------------------------------------------------
  Purpose:     Carrega a temp table de item, a partir de um item passado por parƒmetro, quando o plano de produ‡Æo nÆo ‚ multi estabelecimento.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-item        LIKE it-periodo.it-codigo NO-UNDO.
DEFINE INPUT PARAMETER p-cod-estabel LIKE ITEM.cod-estabel NO-UNDO.

    FOR EACH tt-item:
        DELETE tt-item.
    END.
    IF AVAIL pl-prod AND NOT pl-prod.log-multi-estabel THEN DO:
        FIND ITEM WHERE ITEM.it-codigo = p-item NO-LOCK NO-ERROR.
        IF AVAIL ITEM THEN
            BUFFER-COPY ITEM TO tt-item.
    END.
    ELSE DO:
        FIND ITEM WHERE ITEM.it-codigo = p-item NO-LOCK NO-ERROR.
        IF AVAIL ITEM THEN DO:
            FIND item-uni-estab WHERE item-uni-estab.it-codigo = p-item 
                                  AND item-uni-estab.cod-estabel = p-cod-estabel NO-LOCK NO-ERROR.
    
            IF AVAIL item-uni-estab THEN DO:
               BUFFER-COPY item-uni-estab TO tt-item.
               ASSIGN tt-item.compr-fabric = ITEM.compr-fabric
                    tt-item.desc-item = ITEM.desc-item
                    tt-item.un = ITEM.un
                    tt-item.fm-codigo = ITEM.fm-codigo.
            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-erro-parametro DBOFunction 
PROCEDURE pi-erro-parametro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM TABLE FOR tt-paramGenerate.
DEFINE INPUT-OUTPUT PARAM TABLE FOR RowErrors.   

    if tt-paramGenerate.l-comp = no and
       tt-paramGenerate.l-prod = no then do:
        {method/svc/errors/inserr.i
          &ErrorNumber="191"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters=RETURN-VALUE}

       return error.
    end.

    if tt-paramGenerate.l-ord-mul = yes and
       tt-paramGenerate.l-split = yes then do:
        {method/svc/errors/inserr.i
          &ErrorNumber="1313"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}

       return error.
    end.

    assign i-nr-periodo  = integer(substr(tt-paramGenerate.c-dt-per,1,3))
           i-ano-periodo = integer(substr(tt-paramGenerate.c-dt-per,4,4)).

   &IF DEFINED(bf_man_203) &THEN DO:
       FIND FIRST pl-prod WHERE
            pl-prod.cd-plano = integer(tt-paramGenerate.plano)
            NO-LOCK NO-ERROR.
   END.
   &ELSE 
       FIND FIRST pl-prod where
            pl-prod.pl-estado = 1
           NO-LOCK NO-error.
   &ENDIF

   find  periodo 
       where periodo.cd-tipo    = pl-prod.cd-tipo
         and periodo.nr-periodo = i-nr-periodo
         and periodo.ano        = i-ano-periodo
       no-lock no-error.
    if  not avail periodo then do:
      {utp/ut-table.i mgind periodo 1} 
        {method/svc/errors/inserr.i
          &ErrorNumber="56"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters=RETURN-VALUE}

       return error.
    end.
    if  i-ano-periodo < pl-prod.ano-per-ini or
       (i-ano-periodo = pl-prod.ano-per-ini and
        i-nr-periodo  < pl-prod.nr-per-ini)
        then do:
        {method/svc/errors/inserr.i
          &ErrorNumber="572"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters=RETURN-VALUE}

       return error.
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-erro-plano DBOFunction 
PROCEDURE pi-erro-plano :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER planCode AS INTEGER.
DEFINE INPUT PARAMETER c-dt-per AS CHARACTER.
DEFINE INPUT-OUTPUT PARAM TABLE FOR RowErrors.    

find first pl-prod where 
            pl-prod.cd-plano  = planCode NO-LOCK no-error.


&IF DEFINED (bf_man_206) &THEN
    IF pl-prod.log-nec-bruta = YES THEN DO:
    {method/svc/errors/inserr.i
      &ErrorNumber="30005"
      &ErrorType="EMS"
      &ErrorSubType="ERROR"
      &ErrorParameters=pl-prod.cd-plano}
       return error.
    END.
&ELSEIF DEFINED (bf_man_204) &THEN
    IF pl-prod.log-1 = YES THEN DO:
    {method/svc/errors/inserr.i
      &ErrorNumber="30005"
      &ErrorType="EMS"
      &ErrorSubType="ERROR"
      &ErrorParameters=pl-prod.cd-plano}
       return error.
    END.
&ENDIF

 /*   if pl-prod.regera-plano then do:
       run utp/ut-msgs.p (input "show",
                          input 1459,
                          input "").
       if  return-value = "no" then do:
             
           return error.
       end.
    end.*/

    if  c-dt-per = "0000000" then do:
        {method/svc/errors/inserr.i
          &ErrorNumber="1454"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}

        return error.
    end.

    assign i-nr-periodo  = integer(substr(c-dt-per,1,3))
           i-ano-periodo = integer(substr(c-dt-per,4,4)).

    find  periodo  where 
          periodo.cd-tipo    = pl-prod.cd-tipo and 
          periodo.nr-periodo = i-nr-periodo    and 
          periodo.ano        = i-ano-periodo  no-lock no-error.

    if  not avail periodo then do:
        {utp/ut-table.i mgind periodo 1} 
        {method/svc/errors/inserr.i
          &ErrorNumber="56"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters=RETURN-VALUE}
                
        return error.  
    end.

    if  i-ano-periodo < pl-prod.ano-per-ini or
       (i-ano-periodo = pl-prod.ano-per-ini and
        i-nr-periodo  < pl-prod.nr-per-ini)
        then do:
           {method/svc/errors/inserr.i
              &ErrorNumber="572"
              &ErrorType="EMS"
              &ErrorSubType="ERROR"
              &ErrorParameters=RETURN-VALUE}
           return no-apply.  
    end.

    if not param-global.modulo-cp  and not param-global.modulo-cc then do:
        {method/svc/errors/inserr.i
          &ErrorNumber="1331"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}                
       return error.
    end.
	
	
	if  param-global.modulo-cp then do:
		/** CONTA EMS5 - UNIFICACAO DE CONCEITO **/
		empty temp-table tt_log_erro.
		if not valid-handle(h_api_cta_ctbl) then 
			run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
			run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (INPUT "",
													  INPUT "",
													  input-output param-cp.ct-ordem,
													  INPUT TODAY,
													  output p_des_titulo,
													  output v_num_tip_cta_ctbl,
													  output v_num_sit_cta_ctbl,
													  output v_ind_finalid_cta,
													  OUTPUT TABLE tt_log_erro).
		
		if can-find (first tt_log_erro) then do:
			/** cria rowerrors **/
			assign i-seq-erros-api-ctb-cc = 1.
			FOR EACH tt_log_erro NO-LOCK:
				CREATE RowErrors.
				ASSIGN RowErrors.errorNumber = tt_log_erro.ttv_num_cod_erro
					   RowErrors.errorHelp   = tt_log_erro.ttv_des_msg_ajuda
					   RowErrors.errorDescription = tt_log_erro.ttv_des_msg_erro
					   RowErrors.errorsequence = i-seq-erros-api-ctb-cc
					   i-seq-erros-api-ctb-cc = i-seq-erros-api-ctb-cc + 1.
			END.
			
			RETURN "adm-error".                           
		END.
		
		if (v_num_tip_cta_ctbl   <> 5 and 
			v_num_tip_cta_ctbl   <> 4 and 
			v_num_tip_cta_ctbl   <> 1) or  
			v_num_sit_cta_ctbl <> 3 then do:
			/* Conta contabil deve ser de ativo ou despesa ou passivo e de sistema */
			{method/svc/errors/inserr.i
				&ErrorNumber="18006"
				&ErrorType="EMS"
				&ErrorSubType="ERROR"
				&ErrorParameters="''"}
		end.
		if  v_num_sit_cta_ctbl <> 3 then do:
			{method/svc/errors/inserr.i
				&ErrorNumber="912"
				&ErrorType="EMS"
				&ErrorSubType="ERROR"
				&ErrorParameters="''"}
			RETURN "adm-error".
		end.
	end.

    if  param-global.modulo-cp then 
       if  param-cp.cd-tipo <> pl-prod.cd-tipo then do:
        {method/svc/errors/inserr.i
          &ErrorNumber="1458"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}
            return error.
       end.


    if  not param-global.modulo-cp  THEN DO:
        {method/svc/errors/inserr.i
          &ErrorNumber="1343"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}
    END.

    if  not param-global.modulo-cc then DO:
        {method/svc/errors/inserr.i
          &ErrorNumber="1344"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}
    END.

    else do:
       find first param-compra no-lock no-error.
       if not available param-compra then do:
        {method/svc/errors/inserr.i
          &ErrorNumber="2587"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}
          return error.
       end.
    end.

    if param-global.modulo-ce then do:
       find first param-estoq no-lock no-error.
       if not available param-estoq then do:
        {method/svc/errors/inserr.i
          &ErrorNumber="5246"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}
          return error.
       end.
    end.

    if  param-global.modulo-cs then do:
        find first param-cs no-lock no-error.
        if not available param-cs then do:
        {method/svc/errors/inserr.i
          &ErrorNumber="2075"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}
           return error.
        end.
    end.


    &IF DEFINED(bf_man_203) &THEN
    find first pl-it-calc
         where pl-it-calc.replaneja 
           and pl-it-calc.cd-plano  = integer(pl-prod.cd-plano)
           and (pl-estoque      = yes
                or pl-itens     = yes
                or pl-ordens    = yes
                or pl-parametro = yes
                or pl-plano     = yes) no-lock no-error.
    &ELSE
    find first pl-it-calc
         where pl-it-calc.replaneja = yes
           and (pl-estoque      = yes
                or pl-itens     = yes
                or pl-ordens    = yes
                or pl-parametro = yes
                or pl-plano     = yes) no-lock no-error.
    &ENDIF

    if  avail pl-it-calc then do:
        {method/svc/errors/inserr.i
          &ErrorNumber="1459"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}
       if  return-value = "no" then return error.
    end.

	IF VALID-HANDLE(h_api_cta_ctbl) THEN
		DELETE PROCEDURE h_api_cta_ctbl.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-erro-selecao DBOFunction 
PROCEDURE pi-erro-selecao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM TABLE FOR tt-paramGenerate.
DEFINE INPUT-OUTPUT PARAM TABLE FOR RowErrors.    

    find first pl-prod where 
               pl-prod.cd-plano  = integer(tt-paramGenerate.plano) NO-LOCK no-error.

    if tt-paramGenerate.c-fm-codigo-ini > tt-paramGenerate.c-fm-codigo-fim then do:
       {method/svc/errors/inserr.i
          &ErrorNumber="27"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters=c-fm-codigo-ini 
                              + "~~"
                              + c-fm-codigo-fim}.
  
       return error.
    end.

    if tt-paramGenerate.i-ge-codigo-ini > tt-paramGenerate.i-ge-codigo-fim then do:
        {method/svc/errors/inserr.i
           &ErrorNumber="23"
           &ErrorType="EMS"
           &ErrorSubType="ERROR"
           &ErrorParameters=string(i-ge-codigo-ini) 
                              + "~~"
                              + string(i-ge-codigo-fim)}.

       return error.
    end.

    if tt-paramGenerate.c-it-codigo-ini > tt-paramGenerate.c-it-codigo-fim then do:
       {method/svc/errors/inserr.i
          &ErrorNumber="290"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters=c-it-codigo-ini
                              + "~~"
                              + c-it-codigo-fim}.

       return error.
    end.

    if tt-paramGenerate.c-cd-planejado-ini > tt-paramGenerate.c-cd-planejado-fim then do:
       {method/svc/errors/inserr.i
          &ErrorNumber="293"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters=c-cd-planejado-ini
                              + "~~"
                              + c-cd-planejado-fim}.

       return error.
    end.

    if tt-paramGenerate.i-nr-linha-ini > tt-paramGenerate.i-nr-linha-fim then do:
       {method/svc/errors/inserr.i
          &ErrorNumber="295"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters=string(i-nr-linha-ini) 
                              + "~~"
                              + string(i-nr-linha-fim)}.

       return error.
    end.

    &IF DEFINED(bf_man_203) &THEN
        if tt-paramGenerate.c-estabel-ini > tt-paramGenerate.c-estabel-fim then do:
           {method/svc/errors/inserr.i
          &ErrorNumber="1404"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters=c-estabel-ini
                                  + "~~"
                                  + c-estabel-fim}.

           return error.
        end.

        if pl-prod.log-multi-estabel = no and 
           (tt-paramGenerate.c-estabel-ini <> "" or
            tt-paramGenerate.c-estabel-fim <> "ZZZZZ") then do:
            {method/svc/errors/inserr.i
               &ErrorNumber="19638"
               &ErrorType="EMS"
               &ErrorSubType="ERROR"
               &ErrorParameters=RETURN-VALUE}

           return error.
        end.
    &ENDIF
    
    /*&IF DEFINED(bf_man_206b) &THEN
        if tt-paramGenerate.c-unid-negoc-ini > tt-paramGenerate.c-unid-negoc-fim then do:
            {method/svc/errors/inserr.i
          &ErrorNumber="1404"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters=c-unid-negoc-ini
                                  + "~~"
                                  + c-unid-negoc-fim}.
        END.
    &ENDIF*/
    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-dt-fisica DBOFunction 
PROCEDURE pi-retorna-dt-fisica :
/*------------------------------------------------------------------------------
  Purpose:     Retorna uma data a partir de uma data dispon¡vel e de um lead time.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  parameter p-dat-dispon  as DATE    NO-UNDO.
    def input  parameter p-lead-time   as INTEGER NO-UNDO.
    def output parameter p-dat-termino as DATE    NO-UNDO.

    def var v-time-out as INTEGER NO-UNDO.

    assign p-dat-termino = p-dat-dispon.

    if  p-lead-time = 0 THEN
        return.


    if  pl-it-calc.compr-fabric  = 1 then
        assign p-dat-termino = p-dat-termino - p-lead-time.

    else repeat:
        assign p-dat-termino = p-dat-termino - 1
               v-time-out    = v-time-out + 1.

        if  can-find (first periodo where
                            periodo.cd-tipo = pl-prod.cd-tipo and
                            periodo.dt-inicio <= p-dat-termino and
                            periodo.dt-termino >= p-dat-termino) then
            assign p-lead-time = p-lead-time - 1.

        if  p-lead-time = 0 or v-time-out > 10000 then 
            leave.
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE productionPlanCompleteCopy DBOFunction 
PROCEDURE productionPlanCompleteCopy :
/*------------------------------------------------------------------------------
  Purpose:     Procedure que copia todas as informa‡äes de um item para outro.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEF INPUT PARAM planCodeDestination AS integer.
DEF INPUT PARAM period              AS character.
DEF INPUT PARAM planCodeSource      AS integer.
DEF OUTPUT PARAM TABLE FOR RowErrors.


DEFINE VARIABLE i-ano-ini   AS INTEGER NO-UNDO.
DEFINE VARIABLE i-per-ini       AS INTEGER NO-UNDO.
DEFINE VARIABLE i-cd-plano-orig AS INTEGER NO-UNDO.
DEFINE VARIABLE i-cd-plano-dest AS INTEGER NO-UNDO.
DEFINE VARIABLE h-boin318       AS HANDLE  NO-UNDO.

DEFINE VARIABLE rw-plano AS ROWID.

ASSIGN i-ano-ini   = int(entry(2,period,"/")).
ASSIGN i-per-ini       = int(entry(1,period,"/")).
ASSIGN i-cd-plano-orig = planCodeSource.
ASSIGN i-cd-plano-dest = planCodeDestination.
    
    if not valid-handle (h-boin318) then
       run inbo/boin318.p persistent set h-boin318.
    RUN openQueryStatic IN h-boin318 (INPUT "Main":U) NO-ERROR.

    run emptyRowErrors in h-boin318.
    
    run goToKey in h-boin318 (input i-cd-plano-orig).
    if return-value = "NOK":U then do:
        {method/svc/errors/inserr.i
          &ErrorNumber="6041"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}
        return "NOK".
    end.     
    if i-cd-plano-dest = 0 or    
       i-cd-plano-dest = i-cd-plano-orig then do:
        {method/svc/errors/inserr.i
          &ErrorNumber="7195"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}
        return "NOK".
    end.
    
    run goToKey in h-boin318 (input i-cd-plano-dest).
      
    if return-value = "OK":U then do:
        {method/svc/errors/inserr.i
          &ErrorNumber="7197"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}
        return "NOK".
   end.

   run copiaEspPlano in h-boin318 (input i-cd-plano-orig,
                                   input i-cd-plano-dest,
                                   input i-ano-ini,
                                   input i-per-ini,
                                   output rw-plano).
   
   RUN getRowErrors IN h-boin318 (OUTPUT TABLE RowErrors).

   if can-find (first RowErrors) then do:
      return "NOK":U.
   end.
   
   FOR EACH estabelec NO-LOCK:
      CREATE pl-prod-estab.

      ASSIGN pl-prod-estab.cd-plano    = i-cd-plano-dest
             pl-prod-estab.cod-estabel = estabelec.cod-estabel.
   END.

	IF VALID-HANDLE(h-boin318) THEN
		DELETE PROCEDURE h-boin318.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE productionPlanCopyQuantities DBOFunction 
PROCEDURE productionPlanCopyQuantities :
/*------------------------------------------------------------------------------
  Purpose:     Efetuar a c¢pia das Quantidades de um plano para outro.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM initialPeriod AS character.
    DEF INPUT PARAM planCodeDestination AS integer.
    DEF INPUT PARAM finalPeriod AS character.
    DEF INPUT PARAM isCopyQuantities AS logical.
    DEF INPUT PARAM planCodeSource AS integer.
    DEF OUTPUT PARAM TABLE FOR RowErrors.

    DEFINE VARIABLE i-cd-plano AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-cd-plano-2 AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-cd-tipo  AS INTEGER NO-UNDO.
    DEFINE VARIABLE l-resposta AS LOGICAL NO-UNDO.
    DEFINE VARIABLE i-ano-ini  AS INTEGER init 0 no-undo.
    DEFINE VARIABLE i-per-ini  AS INTEGER init 0 no-undo.
    DEFINE VARIABLE i-ano-ini2 AS INTEGER init 0 no-undo.
    DEFINE VARIABLE i-per-ini2 AS INTEGER init 0 no-undo.
    DEFINE VARIABLE h-boin318  AS HANDLE  NO-UNDO.
    DEFINE VARIABLE h-boin299  AS HANDLE  NO-UNDO.
    DEFINE VARIABLE h-boin311  AS HANDLE  NO-UNDO.

    ASSIGN i-cd-plano = planCodeDestination.
    ASSIGN i-cd-plano-2 = planCodeSource.
    ASSIGN l-resposta = isCopyQuantities.
    ASSIGN i-ano-ini = int(entry(2,initialPeriod,"/")).
    ASSIGN i-per-ini = int(entry(1,initialPeriod,"/")).
    ASSIGN i-ano-ini2 = int(entry(2,finalPeriod,"/")).
    ASSIGN i-per-ini2 = int(entry(1,finalPeriod,"/")).

    if not valid-handle (h-boin318) then
       run inbo/boin318.p persistent set h-boin318.
    RUN openQueryStatic IN h-boin318 (INPUT "Main":U) NO-ERROR.  
    RUN emptyRowErrors IN h-boin318.

    if not valid-handle (h-boin299) then  
       run inbo/boin299.p persistent set h-boin299.
    RUN openQueryStatic IN h-boin299 (INPUT "Main":U) NO-ERROR.  

    if not valid-handle (h-boin311) then   
       run inbo/boin311.p persistent set h-boin311.
    RUN openQueryStatic IN h-boin311 (INPUT "Main":U) NO-ERROR.  
    
    if i-cd-plano   = 0 OR
       i-cd-plano-2 = 0 then do:
       {method/svc/errors/inserr.i
          &ErrorNumber="7206"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}
      return "NOK".
   end.

   run goToKey in h-boin318 (input i-cd-plano-2).  
   if return-value = "NOK":U then do:
      {method/svc/errors/inserr.i
          &ErrorNumber="6041"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}
      return "NOK".
   end.
   run goToKey in h-boin318 (input i-cd-plano).  
   if return-value = "NOK":U then do:
        {method/svc/errors/inserr.i
          &ErrorNumber="6041"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}
      return "NOK".
   end.                  
   else do:
        run getIntField in h-boin318 (input "cd-tipo", output i-cd-tipo).
   end.   
   
   run goToKey in h-boin299 (input i-ano-ini2,
                             input i-cd-tipo,
                             input i-per-ini2).
   if return-value = "NOK":U then do:
       {method/svc/errors/inserr.i
          &ErrorNumber="7212"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}
      return "NOK".
   end.
   
   run goToKeyCdPlano in h-boin311 (input i-cd-plano-2,
                                    input i-ano-ini,
                                    input i-per-ini).
   if return-value = "NOK":U then do:
       {method/svc/errors/inserr.i
          &ErrorNumber="7222"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}
      return "NOK".
   end.        
   
   find first pl-it-prod where
        pl-it-prod.cd-plano = i-cd-plano and
        pl-it-prod.ano      = i-ano-ini2 and
        pl-it-prod.periodo  = i-per-ini2 EXCLUSIVE-LOCK no-error.

   if avail pl-it-prod then do:
     FOR EACH pl-it-prod EXCLUSIVE-LOCK WHERE 
         pl-it-prod.cd-plano = i-cd-plano
     AND pl-it-prod.ano = i-ano-ini2
     AND pl-it-prod.periodo = i-per-ini2:
         DELETE pl-it-prod.
     END.
   end.
   
   run copiaEspQuantidade in h-boin318 (input i-cd-plano,
                                        input i-cd-plano-2,
                                        input i-ano-ini,
                                        input i-per-ini,
                                        input i-ano-ini2,
                                        input i-per-ini2,
                                        input l-resposta).
   
   RUN getRowErrors IN h-boin318 (OUTPUT TABLE RowErrors).

   if can-find (first RowErrors) then do:
      RETURN "NOK":U.
   end.

	IF VALID-HANDLE(h-boin299) THEN
		DELETE PROCEDURE h-boin299.

	IF VALID-HANDLE(h-boin311) THEN
		DELETE PROCEDURE h-boin311.

	IF VALID-HANDLE(h-boin318) THEN
		DELETE PROCEDURE h-boin318.

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeProductionPlan DBOFunction 
PROCEDURE removeProductionPlan :
/*------------------------------------------------------------------------------
  Purpose:     Remove os planos de produ‡Æo a partir da temp table que indica os itens a serem removidos.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM TABLE FOR ttProductionPlanSummaryVO.
DEF OUTPUT PARAM TABLE FOR RowErrors.
DEFINE VARIABLE h-bo AS HANDLE      NO-UNDO.

RUN inbo/boin318.p PERSISTENT SET h-bo.
RUN openQuerystatic IN h-bo (INPUT "main").
    
FOR EACH ttProductionPlanSummaryVO
    WHERE ttProductionPlanSummaryVO.isSelected = YES NO-LOCK:
    FIND FIRST pl-prod 
        WHERE pl-prod.cd-plano = ttProductionPlanSummaryVO.planCode EXCLUSIVE-LOCK NO-ERROR.
        
    IF AVAIL pl-prod THEN DO:
        RUN goToKey IN h-bo(INPUT pl-prod.cd-plano).
        RUN deleteRecord IN h-bo.
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN getRowErrors IN h-bo(OUTPUT TABLE RowErrors).
            
            FIND FIRST RowErrors NO-LOCK NO-ERROR.
            IF AVAIL RowErrors THEN DO:
                /* Erro 10 ‚ gerado automaticamente pela query padrÆo DDK e pode ser ignorada neste caso*/
                IF RowErrors.ErrorNumber = 10
                THEN DO:
                    FIND CURRENT RowErrors EXCLUSIVE-LOCK NO-ERROR.
                    DELETE RowErrors.
                    RETURN "OK".
                END.
            END.
        END.
    END.
END.

IF VALID-HANDLE(h-bo) THEN
    DELETE PROCEDURE h-bo.
    
RETURN "OK":U.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setProductionPlanSites DBOFunction 
PROCEDURE setProductionPlanSites :
/*------------------------------------------------------------------------------
  Purpose:     Cria novas rela‡äes plano x estabelecimento ou remove as que foram desmarcadas.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM TABLE FOR ttProductionPlanSitesVO.
DEF INPUT PARAM planCode AS integer.
DEF OUTPUT PARAM TABLE FOR RowErrors.

    FOR EACH ttProductionPlanSitesVO NO-LOCK:
        
        FIND FIRST pl-prod-estab 
            WHERE pl-prod-estab.cd-plano    = planCode
            AND   pl-prod-estab.cod-estabel = ttProductionPlanSitesVO.siteCode EXCLUSIVE-LOCK NO-ERROR.
            
        IF AVAIL pl-prod-estab THEN DO:
                
            /* Verifica se o estabelecimento nÆo est  selecionado na grid.
               Neste caso, a rela‡Æo foi removida, portanto ‚ necess rio 
               deletar a rela‡Æo. */
            
            IF ttProductionPlanSitesVO.isSelectedSite = NO THEN DO:
                DELETE pl-prod-estab.
            END.
        END.
        ELSE DO:            
        /* Caso nÆo encontre a rela‡Æo entre Plano e Estabelecimento, cria uma */
            IF ttProductionPlanSitesVO.isSelectedSite = YES THEN DO:
                
                CREATE pl-prod-estab.
    
                ASSIGN pl-prod-estab.cd-plano    = planCode
                       pl-prod-estab.cod-estabel = ttProductionPlanSitesVO.siteCode.
            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCopyQuantities DBOFunction 
PROCEDURE validateCopyQuantities :
/*------------------------------------------------------------------------------
  Purpose:     Valida se j  existem itens no plano.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM initialPeriod AS character.
    DEF INPUT PARAM planCodeDestination AS integer.
    DEF INPUT PARAM finalPeriod AS character.
    DEF INPUT PARAM isCopyQuantities AS logical.
    DEF INPUT PARAM planCodeSource AS integer.
    DEF OUTPUT PARAM TABLE FOR ttBooleanReturn.
    DEF OUTPUT PARAM TABLE FOR RowErrors.

    DEFINE VARIABLE i-cd-plano AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-cd-plano-2 AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-cd-tipo  AS INTEGER NO-UNDO.
    DEFINE VARIABLE l-resposta AS LOGICAL NO-UNDO.
    DEFINE VARIABLE i-ano-ini  AS INTEGER init 0 no-undo.
    DEFINE VARIABLE i-per-ini  AS INTEGER init 0 no-undo.
    DEFINE VARIABLE i-ano-ini2 AS INTEGER init 0 no-undo.
    DEFINE VARIABLE i-per-ini2 AS INTEGER init 0 no-undo.
    DEFINE VARIABLE h-boin318  AS HANDLE  NO-UNDO.
    DEFINE VARIABLE h-boin299  AS HANDLE  NO-UNDO.
    DEFINE VARIABLE h-boin311  AS HANDLE  NO-UNDO.
    
    ASSIGN i-cd-plano = planCodeDestination.
    ASSIGN i-cd-plano-2 = planCodeSource.
    ASSIGN l-resposta = isCopyQuantities.
    ASSIGN i-ano-ini = int(entry(2,initialPeriod,"/")).
    ASSIGN i-per-ini = int(entry(1,initialPeriod,"/")).
    ASSIGN i-ano-ini2 = int(entry(2,finalPeriod,"/")).
    ASSIGN i-per-ini2 = int(entry(1,finalPeriod,"/")).
    
    if not valid-handle (h-boin318) then
       run inbo/boin318.p persistent set h-boin318.
    RUN openQueryStatic IN h-boin318 (INPUT "Main":U) NO-ERROR.  
    RUN emptyRowErrors IN h-boin318.

    if not valid-handle (h-boin299) then  
       run inbo/boin299.p persistent set h-boin299.
    RUN openQueryStatic IN h-boin299 (INPUT "Main":U) NO-ERROR.  

    if not valid-handle (h-boin311) then   
       run inbo/boin311.p persistent set h-boin311.
    RUN openQueryStatic IN h-boin311 (INPUT "Main":U) NO-ERROR.  
    
    if i-cd-plano   = 0 OR
       i-cd-plano-2 = 0 then do:
       {method/svc/errors/inserr.i
          &ErrorNumber="7206"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}
       
      return "NOK".
   end.                      

   
   run goToKey in h-boin318 (input i-cd-plano-2).  
   if return-value = "NOK":U then do:
      {method/svc/errors/inserr.i
          &ErrorNumber="6041"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}
      return "NOK".
   end.
   run goToKey in h-boin318 (input i-cd-plano).  
   if return-value = "NOK":U then do:
        {method/svc/errors/inserr.i
          &ErrorNumber="6041"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}
      return "NOK".
   end.                  
   else do:
        run getIntField in h-boin318 (input "cd-tipo", output i-cd-tipo).
   end.   
   
   run goToKey in h-boin299 (input i-ano-ini2,
                             input i-cd-tipo,
                             input i-per-ini2).
   if return-value = "NOK":U then do:
       {method/svc/errors/inserr.i
          &ErrorNumber="7212"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}
      return "NOK".
   end.
   
   run goToKeyCdPlano in h-boin311 (input i-cd-plano-2,
                                    input i-ano-ini,
                                    input i-per-ini).
   if return-value = "NOK":U then do:
       {method/svc/errors/inserr.i
          &ErrorNumber="7222"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}
      return "NOK".
   end.

   find first pl-it-prod where
        pl-it-prod.cd-plano = i-cd-plano and
        pl-it-prod.ano      = i-ano-ini2 and
        pl-it-prod.periodo  = i-per-ini2 NO-LOCK no-error.

   if avail pl-it-prod THEN DO:
       CREATE ttBooleanReturn.
       ASSIGN ttBooleanReturn.booleanValue = YES.
   END.
   ELSE DO:
       CREATE ttBooleanReturn.
       ASSIGN ttBooleanReturn.booleanValue = NO.
       
        RUN productionPlanCopyQuantities
                (INPUT initialPeriod,
                                 INPUT planCodeDestination,
                                 INPUT finalPeriod,
                                 INPUT isCopyQuantities,
                                 INPUT planCodeSource,
                                 OUTPUT TABLE RowErrors).
   END.

	IF VALID-HANDLE(h-boin299) THEN
		DELETE PROCEDURE h-boin299.

	IF VALID-HANDLE(h-boin311) THEN
		DELETE PROCEDURE h-boin311.

	IF VALID-HANDLE(h-boin318) THEN
		DELETE PROCEDURE h-boin318.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-erro-plano-confirmacao DBOFunction 
PROCEDURE pi-erro-plano-confirmacao :
/*------------------------------------------------------------------------------
  Purpose:     Valida se j  existem itens no plano.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    find first pl-prod where 
               pl-prod.cd-plano  = ttProductionPlanGenerateVO.planCode NO-LOCK no-error.

    if  (not avail pl-prod or 
        pl-prod.pl-estado <> 1) then do:
            {utp/ut-table.i mgind periodo 1} 
            {method/svc/errors/inserr.i
                &ErrorNumber="19591"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="''"}         
        return "NOK":U.
    end.

    if not pl-prod.log-multi-estabel then 
       assign ttProductionPlanGenerateVO.initialSite = ""
              ttProductionPlanGenerateVO.finalSite = "ZZZZZ".
    
    IF pl-prod.log-nec-bruta = YES THEN DO:
        {method/svc/errors/inserr.i
            &ErrorNumber="30005"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters="''"}
        return "NOK":U.
    END.   

    DEFINE VARIABLE periodYear  AS CHARACTER INIT ?  NO-UNDO.
    
    ASSIGN periodYear = string(int(entry(2, ttProductionPlanGenerateVO.period, "/")), '9999') NO-ERROR.

    IF periodYear = ? THEN DO:
        {method/svc/errors/inserr.i
            &ErrorNumber="1454"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters="''"}
        return "NOK":U.
    end.


    if string(int(entry(1, ttProductionPlanGenerateVO.period, "/")), '999') + string(int(entry(2, ttProductionPlanGenerateVO.period, "/")), '9999') = "0000000" then do:
        {method/svc/errors/inserr.i
            &ErrorNumber="1454"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters="''"}
        return "NOK":U.
    end.

    assign i-nr-periodo  = integer(entry(1, ttProductionPlanGenerateVO.period, "/"))
           i-ano-periodo = integer(entry(2, ttProductionPlanGenerateVO.period, "/")).

    find  periodo  where 
          periodo.cd-tipo    = pl-prod.cd-tipo and 
          periodo.nr-periodo = i-nr-periodo    and 
          periodo.ano        = i-ano-periodo  no-lock no-error.

    if  not avail periodo then do:
        {utp/ut-table.i mgind periodo 1} 
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters="''"}
        return "NOK":U.
    end.
    if  i-ano-periodo < pl-prod.ano-per-ini or
       (i-ano-periodo = pl-prod.ano-per-ini and
        i-nr-periodo  < pl-prod.nr-per-ini)
        then do:
        {method/svc/errors/inserr.i
            &ErrorNumber="572"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters="''"}
        return "NOK":U.
    end.

    if not param-global.modulo-cp  and not param-global.modulo-cc then do:
        {method/svc/errors/inserr.i
            &ErrorNumber="1331"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters="''"}
        return "NOK":U.
    end.
	
	
	if  param-global.modulo-cp then do:
		/** CONTA EMS5 - UNIFICACAO DE CONCEITO **/
		empty temp-table tt_log_erro.
		if not valid-handle(h_api_cta_ctbl) then 
			run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
			run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (INPUT "",
													  INPUT "",
													  input-output param-cp.ct-ordem,
													  INPUT TODAY,
													  output p_des_titulo,
													  output v_num_tip_cta_ctbl,
													  output v_num_sit_cta_ctbl,
													  output v_ind_finalid_cta,
													  OUTPUT TABLE tt_log_erro).
		
		if can-find (first tt_log_erro) then do:
			/** cria rowerrors **/
			assign i-seq-erros-api-ctb-cc = 1.
			FOR EACH tt_log_erro NO-LOCK:
				CREATE RowErrors.
				ASSIGN RowErrors.errorNumber = tt_log_erro.ttv_num_cod_erro
					   RowErrors.errorHelp   = tt_log_erro.ttv_des_msg_ajuda
					   RowErrors.errorDescription = tt_log_erro.ttv_des_msg_erro
					   RowErrors.errorsequence = i-seq-erros-api-ctb-cc
					   i-seq-erros-api-ctb-cc = i-seq-erros-api-ctb-cc + 1.
			END.
			
			RETURN "adm-error".                           
		END.
		
		if (v_num_tip_cta_ctbl   <> 5 and 
			v_num_tip_cta_ctbl   <> 4 and 
			v_num_tip_cta_ctbl   <> 1) or  
			v_num_sit_cta_ctbl <> 3 then do:
			/* Conta contabil deve ser de ativo ou despesa ou passivo e de sistema */
			{method/svc/errors/inserr.i
				&ErrorNumber="18006"
				&ErrorType="EMS"
				&ErrorSubType="ERROR"
				&ErrorParameters="''"}
		end.
		if  v_num_sit_cta_ctbl <> 3 then do:
			{method/svc/errors/inserr.i
				&ErrorNumber="912"
				&ErrorType="EMS"
				&ErrorSubType="ERROR"
				&ErrorParameters="''"}
			RETURN "adm-error".
		end.
		
		
		IF param-cp.sc-ordem <> "" THEN DO:
			empty temp-table tt_log_erro.
			if not valid-handle(h_api_ccusto) then run 
				prgint/utb/utb742za.py persistent set h_api_ccusto.
					run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
															   INPUT "",
															   input param-cp.sc-ordem,
															   INPUT TODAY,
															   output p_des_titulo,
															   OUTPUT TABLE tt_log_erro).
			
			if can-find (first tt_log_erro) then do:
				/** Centro de Custo nao cadastrado **/
				/* Inicio -- Projeto Internacional */
				DEFINE VARIABLE c-lbl-liter-centro-de-custo-ordem AS CHARACTER NO-UNDO.
				{utp/ut-liter.i "Centro_de_Custo_/_Ordem" *}
				ASSIGN c-lbl-liter-centro-de-custo-ordem = TRIM(RETURN-VALUE).
				{method/svc/errors/inserr.i
					&ErrorNumber="56"
					&ErrorType="EMS"
					&ErrorSubType="ERROR"
					&ErrorParameters="c-lbl-liter-centro-de-custo-ordem"}
				return 'ADM-ERROR':U.
			end.
		end.
		
	end.
	
    if  param-global.modulo-cp then do:
       if  param-cp.cd-tipo <> pl-prod.cd-tipo then do:
            {method/svc/errors/inserr.i
                &ErrorNumber="1458"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="''"}
            return "NOK":U.
       end.
    end.

    if  not param-global.modulo-cp  then do:
        {method/svc/errors/inserr.i
            &ErrorNumber="1343"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters="''"}
        return "NOK":U.
    end.

    if  not param-global.modulo-cc then do:
        {method/svc/errors/inserr.i
            &ErrorNumber="1344"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters="''"}
        return "NOK":U.
    end.
    else do:
       find first param-compra no-lock no-error.
       if not available param-compra then do:
            {method/svc/errors/inserr.i
                &ErrorNumber="2587"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="''"}
            return "NOK":U.
       end.
    end.

    if param-global.modulo-ce then do:
       find first param-estoq no-lock no-error.
       if not available param-estoq then do:
            {method/svc/errors/inserr.i
                &ErrorNumber="5246"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="''"}
            return "NOK":U.
       end.
    end.

    if  param-global.modulo-cs then do:
        find first param-cs no-lock no-error.
        if not available param-cs then do:
            {method/svc/errors/inserr.i
                &ErrorNumber="2075"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="''"}
            return "NOK":U.
        end.
    end.

	IF VALID-HANDLE(h_api_ccusto) THEN
		DELETE PROCEDURE h_api_ccusto.

	IF VALID-HANDLE(h_api_cta_ctbl) THEN
		DELETE PROCEDURE h_api_cta_ctbl.

    return "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-erro-selecao-confirmacao DBOFunction 
PROCEDURE pi-erro-selecao-confirmacao :
/*------------------------------------------------------------------------------
  Purpose:     Valida se j  existem itens no plano.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE temp AS CHARACTER   NO-UNDO.
    
    find first pl-prod where 
               pl-prod.cd-plano  = ttProductionPlanGenerateVO.planCode NO-LOCK no-error.

    if ttProductionPlanGenerateVO.initialFamily > ttProductionPlanGenerateVO.finalFamily then do:
      assign temp = ttProductionPlanGenerateVO.initialFamily + '~~' + ttProductionPlanGenerateVO.finalFamily.
      {method/svc/errors/inserr.i
          &ErrorNumber="23"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters=temp}
          return "NOK":U.
    end.

    if ttProductionPlanGenerateVO.initialStockGroup > ttProductionPlanGenerateVO.finalStockGroup then do:
      assign temp = string(ttProductionPlanGenerateVO.initialStockGroup) + '~~' + string(ttProductionPlanGenerateVO.finalStockGroup).
      {method/svc/errors/inserr.i
          &ErrorNumber="23"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters=temp}
          return "NOK":U.
    end.

    if ttProductionPlanGenerateVO.initialItem > ttProductionPlanGenerateVO.finalItem then do:
      assign temp = ttProductionPlanGenerateVO.initialItem + '~~' + ttProductionPlanGenerateVO.finalItem.
      {method/svc/errors/inserr.i
          &ErrorNumber="290"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters=temp}
          return "NOK":U.
    end.

    if ttProductionPlanGenerateVO.initialPlanner > ttProductionPlanGenerateVO.finalPlanner then do:
      assign temp = ttProductionPlanGenerateVO.initialPlanner + '~~' + ttProductionPlanGenerateVO.finalPlanner.
      {method/svc/errors/inserr.i
          &ErrorNumber="293"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters=temp}
          return "NOK":U.
    end.

    if ttProductionPlanGenerateVO.initialProductionLine > ttProductionPlanGenerateVO.finalProductionLine then do:
      assign temp = string(ttProductionPlanGenerateVO.initialProductionLine) + '~~' + string(ttProductionPlanGenerateVO.finalProductionLine).
      {method/svc/errors/inserr.i
          &ErrorNumber="295"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters=temp}
          return "NOK":U.
    end.
    
    if ttProductionPlanGenerateVO.initialSite > ttProductionPlanGenerateVO.finalSite then do:
      assign temp = ttProductionPlanGenerateVO.initialSite + '~~' + ttProductionPlanGenerateVO.finalSite.
      {method/svc/errors/inserr.i
          &ErrorNumber="1404"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters=temp}
          return "NOK":U.
    end.

    if pl-prod.log-multi-estabel = no and 
       (ttProductionPlanGenerateVO.initialSite <> "" or
        ttProductionPlanGenerateVO.finalSite <> "ZZZZZ") then do:

      {method/svc/errors/inserr.i
          &ErrorNumber="19638"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters="''"}
      return "NOK":U.
    end.
    
    
    if ttProductionPlanGenerateVO.initialBusinessUnit > ttProductionPlanGenerateVO.finalBusinessUnit then do:
        assign temp = ttProductionPlanGenerateVO.initialBusinessUnit + '~~' + ttProductionPlanGenerateVO.finalBusinessUnit.
      {method/svc/errors/inserr.i
          &ErrorNumber="1404"
          &ErrorType="EMS"
          &ErrorSubType="ERROR"
          &ErrorParameters=temp}
          return "NOK":U.
    END.


    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-erro-selecao-confirmacao DBOFunction 
PROCEDURE pi-erro-parametro-confirmacao :
/*------------------------------------------------------------------------------
  Purpose:     Valida se j  existem itens no plano.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if ttProductionPlanGenerateVO.isPurchItem = no and
       ttProductionPlanGenerateVO.isMadeItem = no then do:
        {method/svc/errors/inserr.i
            &ErrorNumber="191"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters="''"}
        return "NOK":U.
    end.

    if ttProductionPlanGenerateVO.isGenerateMultiPurchReq = yes and
       ttProductionPlanGenerateVO.isSplitPurchReqByVendors = yes then do:
        {method/svc/errors/inserr.i
            &ErrorNumber="1313"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters="''"}
        return "NOK":U.
    end.

    assign i-nr-periodo  = integer(entry(1, ttProductionPlanGenerateVO.period, "/"))
           i-ano-periodo = integer(entry(2, ttProductionPlanGenerateVO.period, "/")).

   FIND FIRST pl-prod WHERE
        pl-prod.cd-plano = ttProductionPlanGenerateVO.planCode
        NO-LOCK NO-ERROR.

   find  periodo 
       where periodo.cd-tipo    = pl-prod.cd-tipo
         and periodo.nr-periodo = i-nr-periodo
         and periodo.ano        = i-ano-periodo
       no-lock no-error.
    if  not avail periodo then do:
      {utp/ut-table.i mgind periodo 1} 
        {method/svc/errors/inserr.i
            &ErrorNumber="56"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters=return-value}
        return "NOK":U.
    end.
    if  i-ano-periodo < pl-prod.ano-per-ini or
       (i-ano-periodo = pl-prod.ano-per-ini and
        i-nr-periodo  < pl-prod.nr-per-ini)
        then do:
        {method/svc/errors/inserr.i
            &ErrorNumber="572"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters=return-value}
        return "NOK":U.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateGeneratePlan DBOFunction 
PROCEDURE validateGeneratePlan :
/*------------------------------------------------------------------------------
  Purpose:     Gera um novo plano a partir da temp table parƒmetro.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM planCode AS integer.
    DEF OUTPUT PARAM TABLE FOR ttBooleanReturn.
    DEF OUTPUT PARAM TABLE FOR RowErrors.
    
    find first pl-it-calc
         where pl-it-calc.replaneja 
           and pl-it-calc.cd-plano  = planCode
           and (pl-it-calc.pl-estoque      = yes
                or pl-it-calc.pl-itens     = yes
                or pl-it-calc.pl-ordens    = yes
                or pl-it-calc.pl-parametro = yes
                or pl-it-calc.pl-plano     = yes) no-lock no-error.
    
    CREATE ttBooleanReturn.
    if  avail pl-it-calc then do:
        ASSIGN ttBooleanReturn.booleanValue = FALSE.
    end. ELSE DO:
        ASSIGN ttBooleanReturn.booleanValue = TRUE.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

