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
&GLOBAL-DEFINE DBOName boin311fx
&GLOBAL-DEFINE DBOVersion 1.00.00.010
/*
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName pl-prod
&GLOBAL-DEFINE TableLabel pl-prod
*/

{fch/fchman/fchmanproductionplanitem.i2 ttProductionPlanItemParamVO} 
{fch/fchman/fchmanproductionplan.i3 ttProductionPlanSitesVO} 
{fch/fchman/fchmanproductionplan.i1 ttProductionPlanGenerateVO} 
{fch/fchman/fchmanproductionplan.i5 ttProductionPlanVO2} 
{fch/fchman/fchmanproductionplan.i4 ttProductionPlanSummaryVO} 
{fch/fchman/fchmanproductionplan.i2 ttProductionPlanParamVO} 
{fch/fchman/fchmanproductionplan.i ttProductionPlanCalculateVO}
{fch/fchman/fchmanproductionplan.i5 ttProductionPlanVO} 
{fch/fchman/fchmanproductionplanitem.i ttProductionPlanItemVO} 
{fch/fchman/fchmanproductionplanitem.i1 ttPeriodDateReturnVO} 
{fch/fchman/fchmanproductionplanbooleanreturn.i ttBooleanReturn}

{fch/fchman/fchmanproductionplanstringreturn.i ttStringReturn} 
{fch/fchman/fchmanproductionplandatereturn.i ttDateReturn} 


/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
{inbo/boin311.i tt-pl-it-prod}

/*DEFINE TEMP-TABLE tt-pl-it-prod NO-UNDO LIKE pl-it-prod
	FIELD r-rowid AS ROWID.*/

DEFINE STREAM s-entrada.

DEFINE VARIABLE h-boin311      AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-boin299      as handle  no-undo.
DEFINE VARIABLE somaQuantity AS DECIMAL     NO-UNDO.
DEF TEMP-TABLE RowErrors-aux NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

DEFINE TEMP-TABLE tt-mpl-item NO-UNDO LIKE ttProductionPlanItemVO 
    FIELD familyCode LIKE ITEM.fm-codigo
    FIELD stockGroupCode LIKE ITEM.ge-codigo.

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
         HEIGHT             = 11.08
         WIDTH              = 40.43.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addProductionPlanItem DBOFunction 
PROCEDURE addProductionPlanItem :
/*------------------------------------------------------------------------------
  Purpose: Adiciona Item no Plano de Produ‡Æo 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM TABLE FOR ttProductionPlanItemVO.
DEF OUTPUT PARAM TABLE FOR RowErrors.

DEF VARIABLE i-ano AS INTEGER     NO-UNDO.
DEF VARIABLE i-periodo AS INTEGER     NO-UNDO.

RUN inbo/boin311.p PERSISTENT SET h-boin311.
RUN emptyRowErrors IN h-boin311.

FOR FIRST ttProductionPlanItemVO NO-LOCK:
	ASSIGN i-ano = ?.
	ASSIGN i-periodo = ?.

    ASSIGN i-ano = INT(ENTRY(2, ttProductionPlanItemVO.periodString, '/')) NO-ERROR.
    ASSIGN i-periodo = INT(ENTRY(1, ttProductionPlanItemVO.periodString, '/')) NO-ERROR.
	
	IF i-ano = ? OR i-periodo = ? THEN DO:
		{utp/ut-field.i mgmfg pl-it-prod periodo 1}
        {method/svc/errors/inserr.i
               &ErrorNumber="28250"
               &ErrorType="EMS"
               &ErrorParameters=RETURN-VALUE
               &ErrorSubType="WARNING"}
	END.
		
	IF ttProductionPlanItemVO.quantity <= 0 THEN DO:
		{utp/ut-field.i mgmfg pl-it-prod quantidade 1}
        {method/svc/errors/inserr.i
               &ErrorNumber="1368"
               &ErrorType="EMS"
               &ErrorParameters=RETURN-VALUE
               &ErrorSubType="WARNING"}
	END.
	
    FIND FIRST ITEM WHERE ITEM.it-codigo = ttProductionPlanItemVO.itemCode NO-LOCK NO-ERROR.

	/*  */
		IF NOT CAN-FIND(FIRST RowErrors NO-LOCK) THEN DO:
		CREATE tt-pl-it-prod.
		ASSIGN tt-pl-it-prod.ano                 =  i-ano
			   tt-pl-it-prod.cd-plano            =  ttProductionPlanItemVO.planCode
			   tt-pl-it-prod.cod-estabel         =  IF ttProductionPlanItemVO.siteCode = ? THEN "" ELSE ttProductionPlanItemVO.siteCode
			   tt-pl-it-prod.cod-gr-cli          =  IF ttProductionPlanItemVO.customerGroup = ? THEN 0 ELSE INT(ttProductionPlanItemVO.customerGroup)
			   tt-pl-it-prod.cod-lista-compon    =  ttProductionPlanItemVO.componentListCode
			   tt-pl-it-prod.cod-refer           =  IF ttProductionPlanItemVO.reference = ? THEN "" ELSE ttProductionPlanItemVO.reference
			   tt-pl-it-prod.dt-termino          =  date(ttProductionPlanItemVO.date)
			   tt-pl-it-prod.it-codigo           =  ttProductionPlanItemVO.itemCode
			   tt-pl-it-prod.nome-abrev          =  IF ttProductionPlanItemVO.shortName = ? THEN "" ELSE ttProductionPlanItemVO.shortName
			   tt-pl-it-prod.nr-entrega          =  ttProductionPlanItemVO.deliveryNumber
			   tt-pl-it-prod.nr-estrut           =  ttProductionPlanItemVO.structureNumber
			   tt-pl-it-prod.nr-pedcli           =  IF ttProductionPlanItemVO.customerRequest = ? THEN "" ELSE ttProductionPlanItemVO.customerRequest
			   tt-pl-it-prod.nr-sequencia        =  ttProductionPlanItemVO.sequence
			   tt-pl-it-prod.origem              =  ttProductionPlanItemVO.source
			   tt-pl-it-prod.periodo             =  i-periodo
			   tt-pl-it-prod.qt-confirm          =  ttProductionPlanItemVO.confirmQuantity
			   tt-pl-it-prod.quantidade          =  ttProductionPlanItemVO.quantity.

		RUN openQueryStatic IN h-boin311 (INPUT "Main").
		RUN setRecord IN h-boin311 (INPUT TABLE tt-pl-it-prod).
		RUN createRecord IN h-boin311.
		
		RUN getRowErrors IN h-boin311 (OUTPUT TABLE RowErrors).
	END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateOfPeriod DBOFunction 
PROCEDURE getDateOfPeriod :
/*------------------------------------------------------------------------------
  Purpose: Retorna a Data de T‚rmino do Per¡odo 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM periodValue AS INTEGER.
    DEF INPUT PARAM yearValue AS INTEGER.
    DEF INPUT PARAM periodType AS INTEGER.
    DEF OUTPUT PARAM TABLE FOR ttPeriodDateReturnVO.
    DEF OUTPUT PARAM TABLE FOR RowErrors.

    DEFINE VARIABLE da-dt-termino     AS DATE        NO-UNDO.

    empty temp-table ttPeriodDateReturnVO.

    if not valid-handle (h-boin299) then
        run inbo/boin299.p persistent set h-boin299.
        RUN openQueryStatic IN h-boin299 (INPUT "Main":U).
    
    run goToKey in h-boin299 (input INT(yearValue),
                              input INT(periodType),
                              input INT(periodValue)).

    if return-value = "OK":U then do:
        run getDateField in h-boin299 (input "dt-termino":U, output da-dt-termino).   
   
        CREATE ttPeriodDateReturnVO.
        ASSIGN ttPeriodDateReturnVO.dateValue   = da-dt-termino
               ttPeriodDateReturnVO.yearValue   = yearValue
               ttPeriodDateReturnVO.periodValue = periodValue.
    end.
    else do:
        CREATE ttPeriodDateReturnVO.
        ASSIGN ttPeriodDateReturnVO.dateValue   = ?
               ttPeriodDateReturnVO.yearValue   = -1
               ttPeriodDateReturnVO.periodValue = -1.
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getInitialDateOfPeriod DBOFunction 
PROCEDURE getInitialDateOfPeriod :
/*------------------------------------------------------------------------------
  Purpose: Retorna a Data de T‚rmino do Per¡odo 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM periodValue AS INTEGER.
    DEF INPUT PARAM yearValue AS INTEGER.
    DEF INPUT PARAM periodType AS INTEGER.
    DEF OUTPUT PARAM TABLE FOR ttPeriodDateReturnVO.
    DEF OUTPUT PARAM TABLE FOR RowErrors.

    DEFINE VARIABLE da-dt-inicio     AS DATE        NO-UNDO.

    if not valid-handle (h-boin299) then
        run inbo/boin299.p persistent set h-boin299.
        RUN openQueryStatic IN h-boin299 (INPUT "Main":U).

    run goToKey in h-boin299 (yearValue, 
                              periodType,
                              periodValue).

    if return-value = "OK":U then do:
        run getDateField in h-boin299 (input "dt-inicio":U, output da-dt-inicio).
    
        CREATE ttPeriodDateReturnVO.
        ASSIGN ttPeriodDateReturnVO.dateValue = da-dt-inicio
             ttPeriodDateReturnVO.yearValue = yearValue
             ttPeriodDateReturnVO.periodValue = periodValue.
    end.
    else do:
        CREATE ttPeriodDateReturnVO.
        ASSIGN ttPeriodDateReturnVO.dateValue   = ?
               ttPeriodDateReturnVO.yearValue   = -1
               ttPeriodDateReturnVO.periodValue = -1.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNextPlan DBOFunction 
PROCEDURE getNextPlan :
/*------------------------------------------------------------------------------
  Purpose: Retorna pr¢ximo plano    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM planCode AS integer.
DEF OUTPUT PARAM TABLE FOR ttProductionPlanSummaryVO.
DEF OUTPUT PARAM TABLE FOR RowErrors.


FIND FIRST pl-prod WHERE pl-prod.cd-plano = planCode NO-LOCK NO-ERROR.
IF AVAIL pl-prod THEN DO:
    FIND NEXT pl-prod NO-LOCK NO-ERROR.
    IF AVAIL pl-prod THEN DO:
         CREATE ttProductionPlanSummaryVO.
         ASSIGN ttProductionPlanSummaryVO.planCode                    = pl-prod.cd-plano
               ttProductionPlanSummaryVO.planType                     = pl-prod.tipo-plano
               ttProductionPlanSummaryVO.initialPeriodYear            = pl-prod.ano-per-ini
               ttProductionPlanSummaryVO.finalPeriodYear              = pl-prod.ano-per-fim
               ttProductionPlanSummaryVO.initialPeriod                = pl-prod.nr-per-ini
               ttProductionPlanSummaryVO.finalPeriod                  = pl-prod.nr-per-fim
               ttProductionPlanSummaryVO.calculationStatus            = pl-prod.calculo
               ttProductionPlanSummaryVO.initialPeriodIniDate         = pl-prod.data-inicio
               ttProductionPlanSummaryVO.finalPeriodEndDate           = pl-prod.data-termino
               ttProductionPlanSummaryVO.isMultiSites                 = pl-prod.log-multi-estabel
               ttProductionPlanSummaryVO.periodType                   = pl-prod.cd-tipo
               ttProductionPlanSummaryVO.planStatus                   = pl-prod.pl-estado
               ttProductionPlanSummaryVO.planType                     = pl-prod.tipo-plano.
    END. ELSE DO:
        {utp/ut-table.i mgmfg pl-prod 1}
        {method/svc/errors/inserr.i
               &ErrorNumber="56"
               &ErrorType="EMS"
               &ErrorParameters=RETURN-VALUE
               &ErrorSubType="WARNING"}
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPeriodOfDate DBOFunction 
PROCEDURE getPeriodOfDate :
/*------------------------------------------------------------------------------
  Purpose: Retorna per¡odo da data    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM dateValue AS date.
    DEF INPUT PARAM periodType AS integer.
    DEF OUTPUT PARAM TABLE FOR ttPeriodDateReturnVO.
    DEF OUTPUT PARAM TABLE FOR RowErrors.

    DEFINE VARIABLE i-periodo         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-ano             AS INTEGER     NO-UNDO.
    DEFINE VARIABLE da-dt-inicio      AS DATE        NO-UNDO.
    DEFINE VARIABLE da-dt-termino     AS DATE        NO-UNDO.

    if not valid-handle (h-boin299) then
        run inbo/boin299.p persistent set h-boin299.
        RUN openQueryStatic IN h-boin299 (INPUT "Main":U).

        run goToTermino in h-boin299 (INPUT periodType,
                                      input dateValue).

    if return-value = "OK":U then do:
        run getIntField in h-boin299  (input "nr-periodo":U, output i-periodo).
        run getIntField in h-boin299  (input "ano":U, output i-ano).
        run getDateField in h-boin299 (input "dt-inicio":U, output da-dt-inicio). 
        run getDateField in h-boin299 (input "dt-termino":U, output da-dt-termino). 

        CREATE ttPeriodDateReturnVO.
        ASSIGN ttPeriodDateReturnVO.periodValue = i-periodo
               ttPeriodDateReturnVO.yearValue = i-ano
               ttPeriodDateReturnVO.dateValue = da-dt-inicio
               ttPeriodDateReturnVO.finalDateValue = da-dt-termino.
    END.
    else do:
        CREATE ttPeriodDateReturnVO.
        ASSIGN ttPeriodDateReturnVO.periodValue = -1
               ttPeriodDateReturnVO.yearValue = -1
               ttPeriodDateReturnVO.dateValue = dateValue
               ttPeriodDateReturnVO.finalDateValue = dateValue.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPrevPlan DBOFunction 
PROCEDURE getPrevPlan :
/*------------------------------------------------------------------------------
  Purpose: Retorna plano anterior    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM planCode AS integer.
DEF OUTPUT PARAM TABLE FOR ttProductionPlanSummaryVO.
DEF OUTPUT PARAM TABLE FOR RowErrors.


    FIND FIRST pl-prod WHERE pl-prod.cd-plano = planCode NO-LOCK NO-ERROR.
    IF AVAIL pl-prod THEN DO:
        
        FIND PREV pl-prod NO-LOCK NO-ERROR.
        IF AVAIL pl-prod THEN DO:
             CREATE ttProductionPlanSummaryVO.
             ASSIGN ttProductionPlanSummaryVO.planCode                    = pl-prod.cd-plano
                   ttProductionPlanSummaryVO.planType                     = pl-prod.tipo-plano
                   ttProductionPlanSummaryVO.initialPeriodYear            = pl-prod.ano-per-ini
                   ttProductionPlanSummaryVO.finalPeriodYear              = pl-prod.ano-per-fim
                   ttProductionPlanSummaryVO.initialPeriod                = pl-prod.nr-per-ini
                   ttProductionPlanSummaryVO.finalPeriod                  = pl-prod.nr-per-fim
                   ttProductionPlanSummaryVO.calculationStatus            = pl-prod.calculo
                   ttProductionPlanSummaryVO.initialPeriodIniDate         = pl-prod.data-inicio
                   ttProductionPlanSummaryVO.finalPeriodEndDate           = pl-prod.data-termino
                   ttProductionPlanSummaryVO.isMultiSites                 = pl-prod.log-multi-estabel
                   ttProductionPlanSummaryVO.periodType                   = pl-prod.cd-tipo
                   ttProductionPlanSummaryVO.planStatus                   = pl-prod.pl-estado
                   ttProductionPlanSummaryVO.planType                     = pl-prod.tipo-plano.
    END. ELSE DO:
        {utp/ut-table.i mgmfg pl-prod 1}
        {method/svc/errors/inserr.i
               &ErrorNumber="56"
               &ErrorType="EMS"
               &ErrorParameters=RETURN-VALUE
               &ErrorSubType="WARNING"}
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getProductionPlanItemNeeds DBOFunction 
PROCEDURE getProductionPlanItemNeeds :
/*------------------------------------------------------------------------------
  Purpose: Retorna as necessidades do item do plano de produ‡Æo    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM productionPlanCode AS integer.
DEF INPUT PARAM itemCode AS character.
DEF OUTPUT PARAM TABLE FOR ttProductionPlanItemVO.
DEF OUTPUT PARAM TABLE FOR RowErrors.

FOR EACH pl-it-prod WHERE pl-it-prod.cd-plano = productionPlanCode AND pl-it-prod.it-codigo = itemCode NO-LOCK:
   FIND FIRST pl-prod WHERE pl-prod.cd-plano = productionPlanCode NO-LOCK NO-ERROR.

   CREATE ttProductionPlanItemVO.  
   ASSIGN 
     ttProductionPlanItemVO.itemCode                  = pl-it-prod.it-codigo             
     ttProductionPlanItemVO.itemDescription           = string(pl-it-prod.qt-confirm)            
     ttProductionPlanItemVO.periodType                = pl-prod.cd-tipo             
     ttProductionPlanItemVO.siteCode                  = pl-it-prod.cod-estabel            
     ttProductionPlanItemVO.planCode                  = pl-it-prod.cd-plano               
     ttProductionPlanItemVO.unitOfMeasure             = IF AVAIL ITEM THEN item.un ELSE ""
     ttProductionPlanItemVO.date                      = string(pl-it-prod.dt-termino,"99/99/9999")           
     ttProductionPlanItemVO.quantity                  = pl-it-prod.quantidade             
     ttProductionPlanItemVO.reference                 = pl-it-prod.cod-refer            
     ttProductionPlanItemVO.shortName                 = pl-it-prod.nome-abrev             
     ttProductionPlanItemVO.customerGroup             = string(pl-it-prod.cod-gr-cli)     
     ttProductionPlanItemVO.customerRequest           = pl-it-prod.nr-pedcli              
     ttProductionPlanItemVO.sequence                  = pl-it-prod.nr-sequencia           
     ttProductionPlanItemVO.confirmQuantity           = pl-it-prod.qt-confirm             
     ttProductionPlanItemVO.period                    = pl-it-prod.periodo                
     ttProductionPlanItemVO.source                    = pl-it-prod.origem               
     ttProductionPlanItemVO.structureNumber           = pl-it-prod.nr-estrut              
     ttProductionPlanItemVO.deliveryNumber            = pl-it-prod.nr-entrega                       
     ttProductionPlanItemVO.componentListCode         = pl-it-prod.cod-lista-compon       
     ttProductionPlanItemVO.hasReference              = IF AVAIL ITEM THEN IF ITEM.tipo-con-est = 4 THEN TRUE ELSE FALSE ELSE FALSE
     ttProductionPlanItemVO.year                      = pl-it-prod.ano
     ttProductionPlanItemVO.periodString              = string(pl-it-prod.periodo) + "/" + string(pl-it-prod.ano)
         
     .
   FIND FIRST pl-prod WHERE pl-prod.cd-plano = productionPlanCode NO-LOCK NO-ERROR.
   IF AVAIL pl-prod THEN
       ASSIGN ttProductionPlanItemVO.periodType = pl-prod.cd-tipo.



END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getProductionPlanItems DBOFunction 
PROCEDURE getProductionPlanItems :
/*------------------------------------------------------------------------------
  Purpose: Retorna os itens do plano de produ‡Æo    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM productionPlanCode AS integer.
DEF INPUT PARAM TABLE FOR ttProductionPlanItemParamVO.
DEF OUTPUT PARAM TABLE FOR ttProductionPlanItemVO.
DEF OUTPUT PARAM TABLE FOR RowErrors.

DEFINE VARIABLE hquery  AS HANDLE NO-UNDO.
DEFINE VARIABLE hbuffer AS HANDLE NO-UNDO.
DEFINE VARIABLE hbuffer-item AS HANDLE NO-UNDO.
DEFINE VARIABLE squery AS CHARACTER NO-UNDO.
DEFINE VARIABLE pwhere AS CHARACTER   NO-UNDO.
DEFINE VARIABLE tableName AS CHARACTER   NO-UNDO.

DEFINE VARIABLE cAux   AS CHARACTER NO-UNDO.
DEFINE VARIABLE iCount AS INTEGER   NO-UNDO.

DEFINE VARIABLE defaultCriteria AS CHARACTER   NO-UNDO.
DEFINE VARIABLE itemCriteria AS CHARACTER NO-UNDO.
DEFINE VARIABLE siteCriteria AS CHARACTER NO-UNDO.
DEFINE VARIABLE familyCriteria AS CHARACTER NO-UNDO.
DEFINE VARIABLE stockGroupCriteria AS CHARACTER NO-UNDO.
DEFINE VARIABLE defaultWhere AS CHARACTER   NO-UNDO.

DEFINE VARIABLE itemString AS CHARACTER   NO-UNDO.
DEFINE VARIABLE siteString AS CHARACTER   NO-UNDO.
DEFINE VARIABLE familyString AS CHARACTER   NO-UNDO.
DEFINE VARIABLE stockGroupString AS CHARACTER   NO-UNDO.

ASSIGN tableName = "pl-it-prod".
ASSIGN defaultWhere = "pl-it-prod.cd-plano = " + string(productionPlanCode).

FIND FIRST ttProductionPlanItemParamVO NO-LOCK NO-ERROR.

/** Utilizado trema para caso os c¢digos possuam outros caracteres especiais. */
ASSIGN itemString = replace(ttProductionPlanItemParamVO.itemString, " - ", "ù")
       siteString = replace(ttProductionPlanItemParamVO.siteString, " - ", "ù")
       familyString = replace(ttProductionPlanItemParamVO.familyString, " - ", "ù")
       stockGroupString = replace(ttProductionPlanItemParamVO.stockGroupString, " - ", "ù").
       

IF trim(itemString) <> "" THEN DO:
    IF NUM-ENTRIES(itemString, ";") > 1 THEN DO:
         DO iCount = 1 TO NUM-ENTRIES(itemString, ";"):
             ASSIGN cAux = ENTRY(iCount, itemString, ";").
             IF NUM-ENTRIES(cAux, "ù") > 1 THEN DO:
                 IF iCount = 1 THEN
                     ASSIGN itemCriteria = itemCriteria + " (pl-it-prod.it-codigo >= " + CHR(39) + trim(ENTRY(1, cAux, "ù")) + CHR(39) + " AND " +
                                  " pl-it-prod.it-codigo <= " + CHR(39) + trim(ENTRY(2, cAux, "ù")) + CHR(39) + " ) ".
                 ELSE ASSIGN itemCriteria = itemCriteria + " OR (pl-it-prod.it-codigo >= " + CHR(39) + trim(ENTRY(1, cAux, "ù")) + CHR(39) + " AND " +
                                               " pl-it-prod.it-codigo <= " + CHR(39) + trim(ENTRY(2, cAux, "ù")) + CHR(39) + " ) ".
             END.
             ELSE DO:
                 IF iCount = 1 THEN
                   ASSIGN itemCriteria = itemCriteria + " pl-it-prod.it-codigo = " + CHR(39) + trim(cAux) + CHR(39) .
                 ELSE ASSIGN itemCriteria = itemCriteria + " OR pl-it-prod.it-codigo = " + CHR(39) + trim(cAux) + CHR(39).
             END.
         END.
     END.
     ELSE IF NUM-ENTRIES(itemString, "ù") > 1 THEN DO:
             IF iCount = 1 THEN
                  ASSIGN itemCriteria = itemCriteria + " (pl-it-prod.it-codigo >= ~"" + trim(ENTRY(1, itemString, "ù"))  + "~" AND " +
                                   " pl-it-prod.it-codigo <= ~""  + trim(ENTRY(2, itemString, "ù"))  + "~" ) ".
             ELSE ASSIGN itemCriteria = itemCriteria + "(pl-it-prod.it-codigo >= ~"" + trim(ENTRY(1, itemString, "ù")) + "~" AND " +
                                           " pl-it-prod.it-codigo <= ~"" + trim(ENTRY(2, itemString, "ù")) + "~" ) ".
     END.
     ELSE DO:
         ASSIGN itemCriteria = itemCriteria + "pl-it-prod.it-codigo = " + CHR(39) + itemString + CHR(39).
     END.
 END.





 IF trim(siteString) <> "" THEN DO:
    IF NUM-ENTRIES(siteString, ";") > 1 THEN DO:
         DO iCount = 1 TO NUM-ENTRIES(siteString, ";"):
             ASSIGN cAux = ENTRY(iCount, siteString, ";").
             IF NUM-ENTRIES(cAux, "ù") > 1 THEN DO:
                 IF iCount = 1 THEN
                     ASSIGN siteCriteria = siteCriteria + " (pl-it-prod.cod-estabel >= " + CHR(39) + trim(ENTRY(1, cAux, "ù")) + CHR(39) + " AND " +
                                  " pl-it-prod.cod-estabel <= " + CHR(39) + trim(ENTRY(2, cAux, "ù")) + CHR(39) + " ) ".
                 ELSE ASSIGN siteCriteria = siteCriteria + " OR (pl-it-prod.cod-estabel >= " + CHR(39) + trim(ENTRY(1, cAux, "ù")) + CHR(39) + " AND " +
                                               " pl-it-prod.cod-estabel <= " + CHR(39) + trim(ENTRY(2, cAux, "ù")) + CHR(39) + " ) ".
             END.
             ELSE DO: 
                 IF iCount = 1 THEN
                   ASSIGN siteCriteria = siteCriteria + " pl-it-prod.cod-estabel = " + CHR(39) + trim(cAux) + CHR(39) .
                 ELSE ASSIGN siteCriteria = siteCriteria + " OR pl-it-prod.cod-estabel = " + CHR(39) + trim(cAux) + CHR(39).
             END.
         END.
     END.
     ELSE IF NUM-ENTRIES(siteString, "ù") > 1 THEN DO:
             IF iCount = 1 THEN
                  ASSIGN siteCriteria = siteCriteria + " (pl-it-prod.cod-estabel >= ~"" + trim(ENTRY(1, siteString, "ù"))  + "~" AND " +
                                   " pl-it-prod.cod-estabel <= ~""  + trim(ENTRY(2, siteString, "ù"))  + "~" ) ".
             ELSE ASSIGN siteCriteria = siteCriteria + "(pl-it-prod.cod-estabel >= ~"" + trim(ENTRY(1, siteString, "ù")) + "~" AND " +
                                           " pl-it-prod.cod-estabel <= ~"" + trim(ENTRY(2, siteString, "ù")) + "~" ) ".
     END.
     ELSE DO:
         ASSIGN siteCriteria = siteCriteria + "pl-it-prod.cod-estabel = " + CHR(39) + siteString + CHR(39).
     END.
 END.






 IF trim(familyString) <> "" THEN DO:
    IF NUM-ENTRIES(familyString, ";") > 1 THEN DO:
         DO iCount = 1 TO NUM-ENTRIES(familyString, ";"):
             ASSIGN cAux = ENTRY(iCount, familyString, ";").
             IF NUM-ENTRIES(cAux, "ù") > 1 THEN DO:
                 IF iCount = 1 THEN
                     ASSIGN familyCriteria = familyCriteria + " (item.fm-codigo >= " + CHR(39) + trim(ENTRY(1, cAux, "ù")) + CHR(39) + " AND " +
                                  " item.fm-codigo <= " + CHR(39) + trim(ENTRY(2, cAux, "ù")) + CHR(39) + " ) ".
                 ELSE ASSIGN familyCriteria = familyCriteria + " OR (item.fm-codigo >= " + CHR(39) + trim(ENTRY(1, cAux, "ù")) + CHR(39) + " AND " +
                                               " item.fm-codigo <= " + CHR(39) + trim(ENTRY(2, cAux, "ù")) + CHR(39) + " ) ".
             END.
             ELSE DO: 
                 IF iCount = 1 THEN
                   ASSIGN familyCriteria = familyCriteria + " item.fm-codigo = " + CHR(39) + trim(cAux) + CHR(39) .
                 ELSE ASSIGN familyCriteria = familyCriteria + " OR item.fm-codigo = " + CHR(39) + trim(cAux) + CHR(39).
             END.
         END.
     END.
     ELSE IF NUM-ENTRIES(familyString, "ù") > 1 THEN DO:
             IF iCount = 1 THEN
                  ASSIGN familyCriteria = familyCriteria + " (item.fm-codigo >= ~"" + trim(ENTRY(1, familyString, "ù"))  + "~" AND " +
                                   " item.fm-codigo <= ~""  + trim(ENTRY(2, familyString, "ù"))  + "~" ) ".
             ELSE ASSIGN familyCriteria = familyCriteria + "(item.fm-codigo >= ~"" + trim(ENTRY(1, familyString, "ù")) + "~" AND " +
                                           " item.fm-codigo <= ~"" + trim(ENTRY(2, familyString, "ù")) + "~" ) ".
     END.
     ELSE DO:
         ASSIGN familyCriteria = familyCriteria + "item.fm-codigo = " + CHR(39) + familyString + CHR(39).
     END.
 END.




 IF trim(stockGroupString) <> "" THEN DO:
    IF NUM-ENTRIES(stockGroupString, ";") > 1 THEN DO:
         DO iCount = 1 TO NUM-ENTRIES(stockGroupString, ";"):
             ASSIGN cAux = ENTRY(iCount, stockGroupString, ";").
             IF NUM-ENTRIES(cAux, "ù") > 1 THEN DO:
                 IF iCount = 1 THEN
                     ASSIGN stockGroupCriteria = stockGroupCriteria + " (item.ge-codigo >= " + CHR(39) + trim(ENTRY(1, cAux, "ù")) + CHR(39) + " AND " +
                                  " item.ge-codigo <= " + CHR(39) + trim(ENTRY(2, cAux, "ù")) + CHR(39) + " ) ".
                 ELSE ASSIGN stockGroupCriteria = stockGroupCriteria + " OR (item.ge-codigo >= " + CHR(39) + trim(ENTRY(1, cAux, "ù")) + CHR(39) + " AND " +
                                               " item.ge-codigo <= " + CHR(39) + trim(ENTRY(2, cAux, "ù")) + CHR(39) + " ) ".
             END.
             ELSE DO: 
                 IF iCount = 1 THEN
                   ASSIGN stockGroupCriteria = stockGroupCriteria + " item.ge-codigo = " + CHR(39) + trim(cAux) + CHR(39) .
                 ELSE ASSIGN stockGroupCriteria = stockGroupCriteria + " OR item.ge-codigo = " + CHR(39) + trim(cAux) + CHR(39).
             END.
         END.
     END.
     ELSE IF NUM-ENTRIES(stockGroupString, "ù") > 1 THEN DO:
             IF iCount = 1 THEN
                  ASSIGN stockGroupCriteria = stockGroupCriteria + " (item.ge-codigo >= ~"" + trim(ENTRY(1, stockGroupString, "ù"))  + "~" AND " +
                                   " item.ge-codigo <= ~""  + trim(ENTRY(2, stockGroupString, "ù"))  + "~" ) ".
             ELSE ASSIGN stockGroupCriteria = stockGroupCriteria + "(item.ge-codigo >= ~"" + trim(ENTRY(1, stockGroupString, "ù")) + "~" AND " +
                                           " item.ge-codigo <= ~"" + trim(ENTRY(2, stockGroupString, "ù")) + "~" ) ".
     END.
     ELSE DO:
         ASSIGN stockGroupCriteria = stockGroupCriteria + "item.ge-codigo = " + CHR(39) + stockGroupString + CHR(39).
     END.
 END.



ASSIGN squery = "FOR EACH " + tableName + " where " + defaultWhere.

IF itemCriteria <> "" THEN DO:
    ASSIGN squery = squery + " AND " + itemCriteria.
END.

IF siteCriteria <> "" THEN DO:    
    ASSIGN squery = squery + " AND " + siteCriteria.
END.

ASSIGN squery = squery + ", FIRST item where item.it-codigo = pl-it-prod.it-codigo".

IF familyCriteria <> "" THEN DO:
    ASSIGN squery = squery + " AND " + familyCriteria.
END.

IF stockGroupCriteria <> "" THEN DO:    
    ASSIGN squery = squery + " AND " + stockGroupCriteria.
END.


CREATE BUFFER hbuffer FOR TABLE tableName.
CREATE BUFFER hbuffer-item FOR TABLE "item".
CREATE QUERY hquery.
hquery:SET-BUFFERS(hbuffer, hbuffer-item).
hquery:QUERY-PREPARE(squery).
hquery:FORWARD-ONLY.
hquery:QUERY-OPEN.

hquery:GET-FIRST( NO-LOCK ).

REPEAT WHILE NOT hquery:QUERY-OFF-END:
    IF NOT CAN-FIND(FIRST ttProductionPlanItemVO WHERE ttProductionPlanItemVO.itemCode = hBuffer:BUFFER-FIELD("it-codigo"):BUFFER-VALUE) THEN DO:
        FIND FIRST pl-prod WHERE pl-prod.cd-plano = hBuffer:BUFFER-FIELD("cd-plano"):BUFFER-VALUE NO-LOCK NO-ERROR.
        ASSIGN somaQuantity = 0.
        FOR EACH pl-it-prod WHERE pl-it-prod.cd-plano = hBuffer:BUFFER-FIELD("cd-plano"):BUFFER-VALUE AND (NOT pl-prod.log-multi-estabel OR pl-it-prod.cod-estabel = hBuffer:BUFFER-FIELD("cod-estabel"):buffer-value) AND pl-it-prod.it-codigo = hBuffer:BUFFER-FIELD("it-codigo"):buffer-value NO-LOCK:
            ASSIGN somaQuantity = somaQuantity + pl-it-prod.qt-confirm.
        END.
        
        CREATE ttProductionPlanItemVO.
        ASSIGN ttProductionPlanItemVO.itemCode          = hBuffer:BUFFER-FIELD("it-codigo"):BUFFER-VALUE
              ttProductionPlanItemVO.siteCode           = hBuffer:BUFFER-FIELD("cod-estabel"):buffer-value           
              ttProductionPlanItemVO.planCode           = hBuffer:BUFFER-FIELD("cd-plano"):BUFFER-VALUE
              ttProductionPlanItemVO.itemDescription    = hBuffer-item:BUFFER-FIELD("desc-item"):BUFFER-VALUE
              ttProductionPlanItemVO.hasReference       = IF hBuffer-item:BUFFER-FIELD("tipo-con-est"):BUFFER-VALUE = 4 THEN TRUE ELSE FALSE
              ttProductionPlanItemVO.unitOfMeasure      = hBuffer-item:BUFFER-FIELD("un"):buffer-value
              ttProductionPlanItemVO.quantity           = somaQuantity
                  .
    END.

    hquery:GET-NEXT( NO-LOCK ).

END.
    
    DELETE OBJECT hquery.
    DELETE OBJECT hbuffer.
    DELETE OBJECT hbuffer-item.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importItemsFile DBOFunction 
PROCEDURE importItemsFile :
/*------------------------------------------------------------------------------
  Purpose: Importa‡Æo de Itens     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM fileName AS character.
DEF INPUT PARAM planCode AS integer.
DEF INPUT PARAM importType AS integer.
DEF INPUT PARAM overrideItems AS logical.
DEF OUTPUT PARAM TABLE FOR RowErrors.

DEFINE VARIABLE c-linha AS CHAR FORMAT "x(2000)" NO-UNDO.
DEFINE VARIABLE i-linha AS INTEGER     NO-UNDO.

INPUT  STREAM s-entrada FROM value(FILENAME).

FOR EACH ttProductionPlanItemVO:
    DELETE ttProductionPlanItemVO.
END.

FOR EACH RowErrors-aux:
    DELETE RowErrors-aux.
END.

/* Inicio -- Projeto Internacional */
DEFINE VARIABLE c-msg AS CHARACTER FORMAT "X(37)" NO-UNDO.
{utp/ut-liter.i "Item / Periodo / Data e/ou Quantidade" *}
ASSIGN c-msg = TRIM(RETURN-VALUE).

ASSIGN i-linha = 0.

REPEAT:     
    IMPORT STREAM s-entrada UNFORMATTED c-linha.

    ASSIGN i-linha = i-linha + 1.
    IF c-linha MATCHES "#*" THEN NEXT.

    IF trim(entry(1, c-linha, ";")) = "" OR 
        (trim(entry(3, c-linha, ";")) = "" 
         AND trim(entry(4, c-linha, ";")) = ""
         AND trim(entry(5, c-linha, ";")) = "")  THEN DO:
         

        RUN utp/ut-msgs.p (INPUT "MSG", INPUT 32053, INPUT c-msg).
        
        CREATE RowErrors-aux.
        ASSIGN RowErrors-aux.ErrorSequence    = i-linha
               RowErrors-aux.ErrorNumber      = 32053
               RowErrors-aux.ErrorDescription = RETURN-VALUE
               RowErrors-aux.ErrorType        = "EMS":U
               RowErrors-aux.ErrorHelp        = RETURN-VALUE
               RowErrors-aux.ErrorSubType     = "ERROR":U.

        NEXT.
    END.

    FIND FIRST pl-prod WHERE pl-prod.cd-plano = planCode NO-LOCK NO-ERROR.
    FIND FIRST ITEM WHERE item.it-codigo = trim(ENTRY(1, c-linha, ";")) NO-LOCK NO-ERROR.


    CREATE ttProductionPlanItemVO.
    ASSIGN ttProductionPlanItemVO.planCode           = planCode                                  
           ttProductionPlanItemVO.periodType         = pl-prod.cd-tipo                                  
           ttProductionPlanItemVO.itemCode           = trim(ENTRY(1, c-linha, ";"))              
           ttProductionPlanItemVO.period             = int(trim(entry(1, trim(entry(3, c-linha, ";")), "/")))         
           ttProductionPlanItemVO.year               = int(trim(entry(2, trim(entry(3, c-linha, ";")), "/")))          
           ttProductionPlanItemVO.date               = trim(entry(4, c-linha, ";"))       
           ttProductionPlanItemVO.quantity           = int(trim(entry(5, c-linha, ";")))         
           ttProductionPlanItemVO.reference          = trim(entry(6, c-linha, ";"))              
           ttProductionPlanItemVO.shortName          = trim(entry(7, c-linha, ";"))              
           ttProductionPlanItemVO.customerGroup      = trim(entry(8, c-linha, ";"))              
           ttProductionPlanItemVO.customerRequest    = trim(entry(9, c-linha, ";"))              
           ttProductionPlanItemVO.sequence           = decimal(trim(entry(10, c-linha, ";"))) NO-ERROR.  

   IF pl-prod.log-multi-estabel THEN DO:
       ASSIGN ttProductionPlanItemVO.siteCode           = trim(ENTRY(2, c-linha, ";")).
   END.

   IF AVAILABLE ITEM AND ITEM.tipo-con-est <> 4 THEN 
       ASSIGN ttProductionPlanItemVO.reference = "".

   IF NOT pl-prod.log-multi-estabel THEN
       ASSIGN ttProductionPlanItemVO.siteCode = "".

   EMPTY TEMP-TABLE ttPeriodDateReturnVO.
   IF (importType = 1) THEN DO:
        RUN getDateOfPeriod (INPUT ttProductionPlanItemVO.period, INPUT ttProductionPlanItemVO.year, INPUT ttProductionPlanItemVO.periodType, OUTPUT TABLE ttPeriodDateReturnVO, OUTPUT TABLE RowErrors).
   END. ELSE DO:
        RUN getPeriodOfDate (INPUT ttProductionPlanItemVO.date, INPUT ttProductionPlanItemVO.planCode, OUTPUT TABLE ttPeriodDateReturnVO, OUTPUT TABLE RowErrors).
    END.
    FOR FIRST ttPeriodDateReturnVO NO-LOCK:
        ASSIGN ttProductionPlanItemVO.period = ttPeriodDateReturnVO.periodValue
            ttProductionPlanItemVO.YEAR      = ttPeriodDateReturnVO.yearValue
            ttProductionPlanItemVO.DATE      = string(ttPeriodDateReturnVO.DATEValue).
    END.

    ASSIGN ttProductionPlanItemVO.periodString       = STRING(ttProductionPlanItemVO.period) + "/" + STRING(ttProductionPlanItemVO.YEAR).
END.       

RUN setProductionPlanItemNeeds (INPUT planCode, INPUT TABLE ttProductionPlanItemVO, INPUT YES, INPUT overrideItems, INPUT importType, OUTPUT TABLE RowErrors ).


FOR EACH RowErrors-aux:

    CREATE RowErrors.
    BUFFER-COPY RowErrors-aux TO rowErrors.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeProductionPlanItem DBOFunction 
PROCEDURE removeProductionPlanItem :
/*------------------------------------------------------------------------------
  Purpose: Remover Item do Plano de Produ‡Æo    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM productionPlanCode AS integer.
DEF INPUT PARAM itemCode AS character.
DEF OUTPUT PARAM TABLE FOR RowErrors.

DEF VARIABLE i-ano AS INTEGER     NO-UNDO.
DEF VARIABLE i-periodo AS INTEGER     NO-UNDO.

RUN inbo/boin311.p PERSISTENT SET h-boin311.
RUN emptyRowErrors IN h-boin311.

UserCodeBlock:
DO TRANSACTION ON ERROR UNDO, LEAVE UserCodeBlock
    ON STOP  UNDO, LEAVE UserCodeBlock
    ON QUIT  UNDO, LEAVE UserCodeBlock:

        FOR EACH pl-it-prod
            WHERE pl-it-prod.it-codigo = itemCode
            /*AND pl-it-prod.cod-estabel = siteCode*/
            AND pl-it-prod.cd-plano = productionPlanCode EXCLUSIVE-LOCK:
                DELETE pl-it-prod.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setProductionPlanItemNeeds DBOFunction 
PROCEDURE setProductionPlanItemNeeds :
/*------------------------------------------------------------------------------
  Purpose: Seta os itens do plano    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM productionPlanCode AS integer.
DEF INPUT PARAM TABLE FOR ttProductionPlanItemVO.
DEF INPUT PARAM isImport AS logical.
DEF INPUT PARAM isOverride AS logical.
DEF INPUT PARAM importType AS integer.
DEF OUTPUT PARAM TABLE FOR RowErrors-aux.

FOR EACH RowErrors-aux:
   DELETE RowErrors-aux.
END.

DEF VARIABLE i-counter AS INTEGER     NO-UNDO.
DEF VARIABLE i-ano     AS INTEGER     NO-UNDO.
DEF VARIABLE i-periodo AS INTEGER     NO-UNDO.

RUN inbo/boin311.p PERSISTENT SET h-boin311.
RUN emptyRowErrors IN h-boin311.


UserCodeBlock:
DO TRANSACTION ON ERROR UNDO, LEAVE UserCodeBlock
    ON STOP  UNDO, LEAVE UserCodeBlock
    ON QUIT  UNDO, LEAVE UserCodeBlock:


    IF NOT isImport THEN DO:
        FOR EACH ttProductionPlanItemVO EXCLUSIVE-LOCK BREAK BY ttProductionPlanItemVO.itemCode:
            IF FIRST-OF(ttProductionPlanItemVO.itemCode) THEN DO:
            
                FOR EACH pl-it-prod
                    WHERE pl-it-prod.it-codigo = ttProductionPlanItemVO.itemCode
                    AND pl-it-prod.cod-estabel = ttProductionPlanItemVO.siteCode
                    AND pl-it-prod.cd-plano = productionPlanCode EXCLUSIVE-LOCK:
                   /* IF ITEM.tipo-con-est = 4 THEN DO:
                      IF pl-it-prod.cod-refer = ttProductionPlanItemVO.reference THEN
                          DELETE pl-it-prod.
                    END. ELSE */
                        DELETE pl-it-prod.
                END.
            END.
        END.
    END.

    FOR EACH ttProductionPlanItemVO:
        /*FIND FIRST ITEM WHERE ITEM.it-codigo = ttProductionPlanItemVO.itemCode NO-LOCK NO-ERROR.*/
    
        ASSIGN i-ano = INT(ENTRY(2, ttProductionPlanItemVO.periodString, '/')).
        ASSIGN i-periodo = INT(ENTRY(1, ttProductionPlanItemVO.periodString, '/')).
    
        FIND FIRST pl-it-prod 
                WHERE pl-it-prod.cd-plano = planCode
                AND pl-it-prod.it-codigo = ttProductionPlanItemVO.itemCode
                AND pl-it-prod.cod-estabel = ttProductionPlanItemVO.siteCode
                AND pl-it-prod.cod-refer = ttProductionPlanItemVO.reference
                AND pl-it-prod.periodo = ttProductionPlanItemVO.period 
                AND pl-it-prod.nome-abrev = ttProductionPlanItemVO.shortName
                AND pl-it-prod.nr-sequencia = ttProductionPlanItemVO.sequence
                AND pl-it-prod.nr-pedcli = ttProductionPlanItemVO.customerRequest
                AND pl-it-prod.cod-gr-cli = INT(ttProductionPlanItemVO.customerGroup)
                AND pl-it-prod.ano = ttProductionPlanItemVO.YEAR EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL pl-it-prod THEN DO:
            IF isOverride THEN DO:
                DELETE pl-it-prod.
    		END. ELSE NEXT.
    	END.
        
        /*Quando marcado para substituir e a quantidade for 0, 
        far  a fun‡Æo de eliminar o item do plano de produ‡Æo*/
        IF isOverride = YES AND ttProductionPlanItemVO.quantity <= 0 THEN NEXT.

        ASSIGN i-counter = i-counter + 1.
        CREATE tt-pl-it-prod.
        ASSIGN tt-pl-it-prod.ano                 =  i-ano
               tt-pl-it-prod.cd-plano            =  ttProductionPlanItemVO.planCode
               tt-pl-it-prod.cod-estabel         =  IF ttProductionPlanItemVO.siteCode = ? THEN "" ELSE ttProductionPlanItemVO.siteCode
               tt-pl-it-prod.cod-gr-cli          =  INT(ttProductionPlanItemVO.customerGroup)
               tt-pl-it-prod.cod-lista-compon    =  ttProductionPlanItemVO.componentListCode
               tt-pl-it-prod.cod-refer           =  ttProductionPlanItemVO.reference
               tt-pl-it-prod.dt-termino          =  date(ttProductionPlanItemVO.date)
               tt-pl-it-prod.it-codigo           =  ttProductionPlanItemVO.itemCode
               tt-pl-it-prod.nome-abrev          =  ttProductionPlanItemVO.shortName
               tt-pl-it-prod.nr-entrega          =  ttProductionPlanItemVO.deliveryNumber
               tt-pl-it-prod.nr-estrut           =  ttProductionPlanItemVO.structureNumber
               tt-pl-it-prod.nr-pedcli           =  ttProductionPlanItemVO.customerRequest
               tt-pl-it-prod.nr-sequencia        =  ttProductionPlanItemVO.sequence
               tt-pl-it-prod.origem              =  ttProductionPlanItemVO.source
               tt-pl-it-prod.periodo             =  i-periodo
               tt-pl-it-prod.qt-confirm          =  ttProductionPlanItemVO.confirmQuantity
               tt-pl-it-prod.quantidade          =  ttProductionPlanItemVO.quantity
              .                                                                                                           
    
       
        RUN openQueryStatic IN h-boin311 (INPUT "Main").
        RUN setRecord IN h-boin311 (INPUT TABLE tt-pl-it-prod).
        RUN createRecord IN h-boin311.
    
        RUN getRowErrors IN h-boin311 (OUTPUT TABLE RowErrors).
    
        FOR EACH rowerrors:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-periodo AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Per¡odo" *}
            ASSIGN c-lbl-liter-periodo = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-linha AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "linha" *}
            ASSIGN c-lbl-liter-linha = TRIM(RETURN-VALUE).
            ASSIGN RowErrors.errorHelp = RowErrors.errorHelp + " (" + c-lbl-liter-periodo + " " + ttProductionPlanItemVO.periodString + " - " + c-lbl-liter-linha + " " + string(ttProductionPlanItemVO.fileLine) + ")".
            
            CREATE RowErrors-aux.
            BUFFER-COPY RowErrors TO RowErrors-aux.
        END.
    
        DELETE tt-pl-it-prod.
        
         
        IF CAN-FIND(FIRST RowErrors-aux WHERE RowErrors-aux.ErrorSubType = "ERROR") THEN DO:
            UNDO UserCodeBlock.                                     
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

