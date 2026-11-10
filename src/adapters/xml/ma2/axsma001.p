/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSMA001 2.00.00.009 } /*** 010009 ***/



/******************************************************************************/
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : AXSMA001.p
    Purpose     : Adapter de envio de mensagem contendo a transacao de
                  Gastos por Centro de Custo Produtivo
    Syntax      :
    Description : Este adapter utiliza os metodos da API XML implementada pela Tech
    Created     : 16/09/2003 17:10
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Pr‚-Processadores*/
&GLOBAL-DEFINE XmlTranName CostCenterExtension
&GLOBAL-DEFINE XmlTranVersion 204.000
&GLOBAL-DEFINE XmlProdName EMS2
&GLOBAL-DEFINE XmlProdVersion 204
&GLOBAL-DEFINE XmlApp MA2 
&GLOBAL-DEFINE XmlMod CSP

DEFINE TEMP-TABLE tt-centro-custo NO-UNDO LIKE centro-custo.
DEFINE TEMP-TABLE tt-eai-periodo NO-UNDO
       FIELD periodo LIKE ext-per-custo.periodo. 

DEFINE BUFFER b-estabelec FOR estabelec.

/* Defini‡Æo temp-table RowErrors */
{cdp/cd9043.i}
{cdp/cd9043.i1}

/* Centro de Custo X Estabelecimento */
{cdp/cd0110.i}

/*Parƒmetros de entrada*/

DEF INPUT PARAM pTranAction  AS CHAR     NO-UNDO.
DEF INPUT PARAM pProgName    AS CHAR     NO-UNDO.
DEF INPUT PARAM pProgVersion AS CHAR     NO-UNDO.
DEF INPUT PARAM pEvento      AS CHAR     NO-UNDO.
DEF INPUT PARAM TABLE FOR tt-eai-periodo.
DEF INPUT PARAM TABLE FOR tt-centro-custo.
DEF OUTPUT PARAM TABLE FOR RowErrors.

DEF VAR pSendSuccess AS LOG INITIAL YES NO-UNDO.
DEF VAR lCreateMsg AS LOG NO-UNDO.
DEF VAR pTotalErrors AS INT NO-UNDO.
DEF VAR pErrorId AS INT  NO-UNDO.
DEF VAR pErrorType AS CHAR NO-UNDO.
DEF VAR pErrorDesc AS CHAR NO-UNDO.
DEF VAR pErrorNumber  AS INT NO-UNDO.
DEF VAR iCount  AS INT NO-UNDO.

/* Handle do BusinessContent */
DEF VAR hBusinessContent AS HANDLE NO-UNDO.
CREATE X-DOCUMENT hBusinessContent.

/* Variaveis da construção do BusinessContent Utilizando APIXML */
DEF VAR iId      AS INT NO-UNDO.
DEF VAR iFirstId AS INT NO-UNDO.
DEF VAR iIdSite  AS INT NO-UNDO.
DEF VAR iIdLabor AS INT NO-UNDO.
DEF VAR iIdHours AS INT NO-UNDO.
DEF VAR iIdGGF   AS INT NO-UNDO.
DEF VAR iIdCompany   AS INT NO-UNDO.
DEF VAR iIdAcct AS INT NO-UNDO.
DEF VAR iIdSubAcct AS INT NO-UNDO.
DEF VAR iIdVarAcct AS INT NO-UNDO.
DEF VAR iIdCurr    AS INT NO-UNDO.
DEF VAR iIdCost AS INT NO-UNDO.
DEF VAR iIdCostSon AS INT NO-UNDO.
DEF VAR iIdUnitValue AS INT NO-UNDO.
DEF VAR iIdAT AS INT NO-UNDO.
DEF VAR iIdAccount AS INT NO-UNDO.

DEF VAR iIdCostSonAvg  AS INT NO-UNDO.
DEF VAR iIdCostSonFore AS INT NO-UNDO.
DEF VAR iIdCostSonTotal  AS INT NO-UNDO.
DEF VAR iIdCostSonStd  AS INT NO-UNDO.

/* VARIABEL PARA ARMAZENAR OS VALORES OBTIDOS NA INICIALIZACAO DO loalMessageHandler */
DEF VAR hMessageHandler AS HANDLE NO-UNDO.
DEF VAR cReturnValue    AS CHAR   NO-UNDO.

/* VARIABEL PARA ARMAZENAR OS VALORES OBTIDOS NA INICIALIZACAO DO loalGenXml */
DEF VAR hGenXml AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 
/* ***************************  Main Block  *************************** */
{utp/ut-glob.i}
{include/i-freeac.i}
{cdp/cdcfgman.i}

    /* Verifica se h  registros na temp-table */
    IF NOT CAN-FIND(FIRST tt-centro-custo) THEN DO:

        {utp/ut-liter.i Gastos_Gerais_Centro_Custo_para_Integracao_EAI * r}
        run piCriaErro (5561,
                        'EMS':U, 
                        TRIM(return-value)).
         RETURN "NOK":U.
    END.


FOR EACH tt-centro-custo WHERE tt-centro-custo.cc-codigo <> "":

    /* Verifica se MessageHandler.p está  na mem¢ria */
    {xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

    /* Verifica se o MessageHandler foi executado corretamente */
    IF cReturnValue <> "OK":U THEN DO:
         IF cReturnValue <> ? AND cReturnValue <> " " THEN DO:
             run piCriaErro (17006,
                             'EMS':U, 
                             cReturnValue).
                 RETURN "NOK":U.
         END.
    END.

    /* Verifica se h  programas inscritos */
    RUN isSubscribed IN hMessageHandler (INPUT "{&XmlProdName}",
                                         INPUT "{&XmlApp}",
                                         INPUT "{&XmlTranName}",
                                         INPUT "{&XmlTranVersion}",
                                         INPUT "CostCenterExtension",
                                         INPUT pTranAction,
                                         OUTPUT lCREATEMsg).

    /*Verifica se a transa‡Æo ‚ assinada*/
      IF NOT lCREATEMsg THEN
         RETURN "OK":U.

    /* Preenche o valor do elemento Comment de TransactionId */
    RUN setTransInfoComment IN hMessageHandler ("Program:" + pProgName + "-" +
                                                "Version:" + pProgVersion). 

    /*Seta SystemID*/
    RUN setSystemId IN hMessageHandler ("{&XmlMod}",          /* Nome do modulo */
                                        "{&XmlProdVersion}"). /* Versao do Programa*/

    /* Indica valor da chave prim ria da transa‡Æo */
    IF l-funcao-ccusto-estab THEN DO:
	    RUN setKeyFields IN hMessageHandler ("centro-custo.cc-codigo", 
	                                          STRING(tt-centro-custo.cc-codigo)). 
        RUN setKeyFields IN hMessageHandler ("centro-custo.cod-estabel", 
                                              STRING(tt-centro-custo.cod-estabel)). 
    END. ELSE DO:
            RUN setKeyFields IN hMessageHandler ("centro-custo.cc-codigo", 
                                                STRING(tt-centro-custo.cc-codigo)). 
    END.
    
    /* Seta a empresa e o estabelecimento */
    RUN setCompanyId IN hMessageHandler (STRING(v_cdn_empres_usuar), ""). 

    /* Verifica se API est  na mem¢ria */
    {xmlinc/xmlloadgenxml.i &GenXml="hGenXml" &GXReturnValue="cReturnValue"}

    /* Verifica se o ut-genxml foi executado corretamente */
    IF cReturnValue <> "OK":U THEN DO:
         IF cReturnValue <> ? AND cReturnValue <> "" THEN DO:
             run piCriaErro (17006,
                             'EMS':U, 
                             cReturnValue).
          RETURN "NOK":U.
         END.
     END.

    /* CRIA MENSAGEM XML DO BUSINESS CONTENT UTILIZANDO APIXML */
    CREATE-BUSINESS-XML:
    DO:
        /* RESETA OS VALORES */
        RUN reset IN hGenXml.

        /* SETA VALOR DE ENCODING */
        RUN setEncoding IN hGenXml ("UTF-8").

        IF pTranAction = "add" OR pTranAction = "upd" THEN DO:        
            RUN addNode IN hGenXml (0, "Upsert":U, "", OUTPUT iFirstId).

            RUN addNode IN hGenXml (iFirstId, "CostCenterCode":U, tt-centro-custo.cc-codigo, OUTPUT iId).
            RUN addNode IN hGenXml (iFirstId, "CostCenterDescription":U, tt-centro-custo.descricao, OUTPUT iId).            

            RUN addNode IN hGenXml (iFirstId, "Site", "", OUTPUT iId).
            /* Adiciona informacoes do Estabelecimento */
            RUN addNode IN hGenXml (iId, "SiteCode":U, tt-centro-custo.cod-estabel, OUTPUT iIdSite).
            FOR FIRST b-estabelec WHERE b-estabelec.cod-estabel = tt-centro-custo.cod-estabel NO-LOCK: END.
            IF AVAIL b-estabelec THEN
                 RUN addNode IN hGenXml (iId, "SiteName":U, b-estabelec.nome, OUTPUT iIdSite).
            ELSE RUN addNode IN hGenXml (iId, "SiteName":U, "Nao identificado", OUTPUT iIdSite).

            IF tt-centro-custo.data-cust-pr <> ? THEN
            RUN addNodeDate IN hGenXml (iFirstId, "ExpectedCostDate":U, tt-centro-custo.data-cust-pr, OUTPUT iId).

            IF tt-centro-custo.data-custo-pad > 01/01/1800 THEN
            RUN addNodeDate IN hGenXml (iFirstId, "DefaultCostDate":U, tt-centro-custo.data-custo-pad, OUTPUT iId).

            RUN addNode IN hGenXml (iFirstId, "LaborAccount":U, "", OUTPUT iId).
            /* Adiciona informacoes da Conta Contabil de Mao de Obra Direta*/
            RUN addNode IN hGenXml (iId, "LaborAcctCode":U, tt-centro-custo.ct-mob, OUTPUT iIdLabor).
            RUN addNode IN hGenXml (iId, "LaborSubAcctCode":U, tt-centro-custo.sc-mob, OUTPUT iIdLabor).
            
            RUN addNode IN hGenXml (iFirstId, "TimeHours":U, "", OUTPUT iId).
            /* Adiciona informacoes Tempo(Horas) */
            RUN addNodeDec IN hGenXml (iId, "ReportedHours":U, tt-centro-custo.horas-report, OUTPUT iIdHours).
            RUN addNodeDec IN hGenXml (iId, "ProducedTime":U, tt-centro-custo.horas-prod,    OUTPUT iIdHours).
            RUN addNodeDec IN hGenXml (iId, "AvaliableTime":U, tt-centro-custo.horas-dispon, OUTPUT iIdHours).
            RUN addNodeDec IN hGenXml (iId, "StandardTime":U, tt-centro-custo.horas-padrao,  OUTPUT iIdHours).
            RUN addNodeDec IN hGenXml (iId, "TotalManHours":U, tt-centro-custo.tot-hora-hom, OUTPUT iIdHours).
            RUN addNodeDec IN hGenXml (iId, "TotalMachineHours":U, tt-centro-custo.tot-hora-maq, OUTPUT iIdHours).
            RUN addNodeDec IN hGenXml (iId, "ReportedManHours":U, tt-centro-custo.horas-homem,   OUTPUT iIdHours).
            RUN addNodeDec IN hGenXml (iId, "ReportedMachineHours":U, tt-centro-custo.horas-maq, OUTPUT iIdHours).

            RUN addNodeDec IN hGenXml (iFirstId, "UnitsOfProductionReported":U, tt-centro-custo.nr-up-report, OUTPUT iId).

            /* Abre lista do Extent Valor Unitario da Unidade de Producao [Campo Opcional no Schema]*/
            Add-ListOfUPUnitValue:
            DO iCount = 1 TO 3:
               IF tt-centro-custo.val-unit-up[iCount] <> 0 THEN DO:
                  RUN addNode IN hGenXml (iFirstId, "ListOfUnitsOfProductionValue":U, "", OUTPUT iId).
                  DO iCount = 1 TO 3:    
                      IF tt-centro-custo.val-unit-up[iCount] <> 0 THEN
                      RUN addNodeDec IN hGenXml (iId, "UnitsOfProductionValue":U, tt-centro-custo.val-unit-up[iCount], OUTPUT iIdUnitValue).
                  END.
                  LEAVE Add-ListOfUPUnitValue.
               END.
            END.

            RUN addNode IN hGenXml (iFirstId, "GeneralExpensesOfManufacture":U, "", OUTPUT iId).

            /* Adiciona informacoes de Gastos Gerais de Fabrica‡Æo */
            
            &IF "{&mguni_version}" >= "2.071" &THEN
            IF v_cdn_empres_usuar <> "" THEN DO:
            &ELSE
            IF v_cdn_empres_usuar <> 0 THEN DO:
            &ENDIF
                RUN addNodeDec IN hGenXml (iId, "Company":U, "", OUTPUT iIdGGF).
                RUN addNodeDec IN hGenXml (iIdGGF, "CompanyCode":U, v_cdn_empres_usuar, OUTPUT iIdCompany).
                FIND FIRST empresa WHERE empresa.ep-codigo = v_cdn_empres_usuar NO-LOCK NO-ERROR.
                IF AVAIL empresa THEN
                   RUN addNode IN hGenXml (iIdGGF, "CompanyName":U, empresa.nome, OUTPUT iIdCompany).

            END.

            /* Verifica se ha conta cadastrada [Campo Opcional no Schema]*/
            Add-ListOfAcct:
            DO iCount = 1 TO 6:
               IF tt-centro-custo.ct-codigo[iCount] <> " " THEN DO:
                  RUN addNode IN hGenXml (iId, "ListOfAcct":U, "", OUTPUT iIdGGF).
                  DO iCount = 1 TO 6:
                     IF tt-centro-custo.ct-codigo[iCount] <> " " THEN
                      RUN addNode IN hGenXml (iIdGGF, "AcctCode":U, tt-centro-custo.ct-codigo[iCount], OUTPUT iIdAcct).
                  END.
                  LEAVE Add-ListOfAcct.
               END.
             END.

            /* Abre lista do Extent SubAcct [Campo Opcional no Schema]*/
            Add-ListOfSubAcct:
            DO iCount = 1 TO 6:
               IF tt-centro-custo.sc-codigo[iCount] <> " " THEN DO:
                  RUN addNode IN hGenXml (iId, "ListOfSubAcct":U, "", OUTPUT iIdGGF).
                  DO iCount = 1 TO 6:
                      IF tt-centro-custo.sc-codigo[iCount] <> " " THEN
                      RUN addNode IN hGenXml (iIdGGF, "SubAcctCode":U, tt-centro-custo.sc-codigo[iCount], OUTPUT iIdSubAcct).
                  END.
                  LEAVE Add-ListOfSubAcct.
               END.
            END.

            RUN addNodeDec IN hGenXml (iId, "TimeForApropriation":U, tt-centro-custo.tempo-ggf, OUTPUT iIdGGF).

            /* Abre lista do Extent Tipo de Absorcao */
            RUN addNode IN hGenXml (iId, "ListOfAbsorptnType":U, "", OUTPUT iIdGGF).
            DO iCount = 1 TO 6:
                IF tt-centro-custo.forma-abs[iCount] < 1 OR tt-centro-custo.forma-abs[iCount] > 3 THEN
                   RUN addNodeDec IN hGenXml (iIdGGF, "AbsorptnType":U, 1, OUTPUT iIdAT).
                ELSE 
                   RUN addNodeDec IN hGenXml (iIdGGF, "AbsorptnType":U, tt-centro-custo.forma-abs[iCount], OUTPUT iIdAT).
            END.

            RUN addNode IN hGenXml (iFirstId, "VariationAccts":U, "", OUTPUT iId).
            RUN addNode IN hGenXml (iId, "EfficiencyVariationAcct":U, tt-centro-custo.ct-var-efic, OUTPUT iIdVarAcct).
            RUN addNode IN hGenXml (iId, "EfficiencyVariationSubAcct":U, tt-centro-custo.sc-var-efic, OUTPUT iIdVarAcct).
            RUN addNode IN hGenXml (iId, "RateVariationAcct":U, tt-centro-custo.ct-var-taxa, OUTPUT iIdVarAcct).         
            RUN addNode IN hGenXml (iId, "RateVariationSubAcct":U, tt-centro-custo.sc-var-taxa, OUTPUT iIdVarAcct).      

            /* Verifica evento. Se nao for "Cadastro" executa o bloco de Gastos Gerais */
            IF pEvento <> "CAD" THEN DO:
                RUN addNode IN hGenXml (iFirstId, "ListOfPeriodCostExtension":U, "", OUTPUT iId).

                FOR EACH tt-eai-periodo NO-LOCK:
		
                    IF l-funcao-ccusto-estab THEN DO:		
                        FOR EACH ext-per-custo-estab WHERE ext-per-custo-estab.cc-codigo = tt-centro-custo.cc-codigo 
                                                 AND ext-per-custo-estab.periodo   = tt-eai-periodo.periodo
                                                 AND ext-per-custo-estab.cod-estabel = tt-centro-custo.cod-estabel USE-INDEX c-custo NO-LOCK:

                           RUN addNode IN hGenXml (iId, "PeriodCostExtension":U, "", OUTPUT iIdCost).

                           RUN addNode IN hGenXml (iIdCost, "Curr":U, "", OUTPUT iIdCostSon).
                           RUN addNode IN hGenXml (iIdCostSon, "CurrCode":U, ext-per-custo-estab.mo-codigo, OUTPUT iIdCurr).
                           FOR FIRST moeda WHERE moeda.mo-codigo = ext-per-custo-estab.mo-codigo NO-LOCK: END.
                           IF AVAIL moeda THEN 
                              RUN addNode IN hGenXml (iIdCostSon, "CurrDescription":U, moeda.descricao, OUTPUT iIdCurr).

                           RUN addNode IN hGenXml (iIdCost, "Period":U, ext-per-custo-estab.periodo, OUTPUT iIdCostSon).           

                           /* Abre lista do Extent Valor Custo Medio */
                           RUN addNode IN hGenXml (iIdCost, "ListOfAverageCostValue":U, "", OUTPUT iIdCostSon).
                           DO iCount = 1 TO 6:
                               RUN addNodeDec IN hGenXml (iIdCostSon, "AverageCostValue":U, ext-per-custo-estab.custo-medio[iCount], OUTPUT iIdCostSonAvg).
                           END.

                           /* Abre lista do Extent Valor Custo Previsto */
                           RUN addNode IN hGenXml (iIdCost, "ListOfForecastCost":U, "", OUTPUT iIdCostSon).
                           DO iCount = 1 TO 6:
                               RUN addNodeDec IN hGenXml (iIdCostSon, "ForecastCost":U, ext-per-custo-estab.custo-prev[iCount], OUTPUT iIdCostSonFore).
                           END.

                           /* Abre lista do Extent Valor Custo Total */
                           RUN addNode IN hGenXml (iIdCost, "ListOfCostCenterTotal":U, "", OUTPUT iIdCostSon).
                           DO iCount = 1 TO 6:
                               RUN addNodeDec IN hGenXml (iIdCostSon, "CostCenterTotal":U, ext-per-custo-estab.custo-total[iCount], OUTPUT iIdCostSonTotal).
                           END.

                           /* Abre lista do Extent Valor Custo Padrao */
                           RUN addNode IN hGenXml (iIdCost, "ListOfStandardCost":U, "", OUTPUT iIdCostSon).
                           DO iCount = 1 TO 6:
                               RUN addNodeDec IN hGenXml (iIdCostSon, "StandardCost":U, ext-per-custo-estab.custo-pad[iCount], OUTPUT iIdCostSonStd).
                           END.

                       END. /* each ext-per-custo-estab */
                    END.
                    ELSE DO:
                        FOR EACH ext-per-custo WHERE ext-per-custo.cc-codigo = tt-centro-custo.cc-codigo 
                                                 AND ext-per-custo.periodo   = tt-eai-periodo.periodo
                                                 USE-INDEX c-custo NO-LOCK:

                           RUN addNode IN hGenXml (iId, "PeriodCostExtension":U, "", OUTPUT iIdCost).

                           RUN addNode IN hGenXml (iIdCost, "Curr":U, "", OUTPUT iIdCostSon).
                           RUN addNode IN hGenXml (iIdCostSon, "CurrCode":U, ext-per-custo.mo-codigo, OUTPUT iIdCurr).
                           FOR FIRST moeda WHERE moeda.mo-codigo = ext-per-custo.mo-codigo NO-LOCK: END.
                           IF AVAIL moeda THEN 
                              RUN addNode IN hGenXml (iIdCostSon, "CurrDescription":U, moeda.descricao, OUTPUT iIdCurr).

                           RUN addNode IN hGenXml (iIdCost, "Period":U, ext-per-custo.periodo, OUTPUT iIdCostSon).           

                           /* Abre lista do Extent Valor Custo Medio */
                           RUN addNode IN hGenXml (iIdCost, "ListOfAverageCostValue":U, "", OUTPUT iIdCostSon).
                           DO iCount = 1 TO 6:
                               RUN addNodeDec IN hGenXml (iIdCostSon, "AverageCostValue":U, ext-per-custo.custo-medio[iCount], OUTPUT iIdCostSonAvg).
                           END.

                           /* Abre lista do Extent Valor Custo Previsto */
                           RUN addNode IN hGenXml (iIdCost, "ListOfForecastCost":U, "", OUTPUT iIdCostSon).
                           DO iCount = 1 TO 6:
                               RUN addNodeDec IN hGenXml (iIdCostSon, "ForecastCost":U, ext-per-custo.custo-prev[iCount], OUTPUT iIdCostSonFore).
                           END.

                           /* Abre lista do Extent Valor Custo Total */
                           RUN addNode IN hGenXml (iIdCost, "ListOfCostCenterTotal":U, "", OUTPUT iIdCostSon).
                           DO iCount = 1 TO 6:
                               RUN addNodeDec IN hGenXml (iIdCostSon, "CostCenterTotal":U, ext-per-custo.custo-total[iCount], OUTPUT iIdCostSonTotal).
                           END.

                           /* Abre lista do Extent Valor Custo Padrao */
                           RUN addNode IN hGenXml (iIdCost, "ListOfStandardCost":U, "", OUTPUT iIdCostSon).
                           DO iCount = 1 TO 6:
                               RUN addNodeDec IN hGenXml (iIdCostSon, "StandardCost":U, ext-per-custo.custo-pad[iCount], OUTPUT iIdCostSonStd).
                           END.

                        END. /* each ext-per-custo */
                    END. 
                END. /* lista de periodo */
            END.  /* if pEvento */
        END.
        ELSE IF pTranAction = "del" THEN DO:

            RUN addNode IN hGenXml (0, "Delete":U, "", OUTPUT iFirstId).
            RUN addNode IN hGenXml (iFirstId, "CostCenterCode":U, tt-centro-custo.cc-codigo, OUTPUT iId).
            RUN addNode IN hGenXml (iFirstId, "CostCenterDescription":U, tt-centro-custo.descricao, OUTPUT iId).

       END.

    END. /* transacao */

    /* Obt‚m XMl na variavel handle */
    RUN generateXML IN hGenXml (OUTPUT hBusinessContent).
    /*hBusinessContent:SAVE("FILE", "C:~\CostCenter.xml").    */

    /* Passa handle do BusinessContent */
    RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).

    /* Elimina handle */
    DELETE OBJECT hBusinessContent NO-ERROR.

    /* Envia XML para ControlBroker */
    &IF "{&mguni_version}" >= "2.071" &THEN
        RUN sendMessage IN hMessageHandler (INPUT "ma2/CostCenterExtension_204_002.xsd").
    &ELSE
        RUN sendMessage IN hMessageHandler (INPUT "ma2/CostCenterExtension_204_000.xsd").
    &ENDIF


    /*Verifica se a mensagem foi enviada com sucesso */
    RUN getReturnStatus IN hMessageHandler (OUTPUT pSendSuccess,
                                            OUTPUT pTotalErrors).

    IF NOT pSendSuccess THEN DO:
      REPEAT iCount = 1 TO pTotalErrors:
          RUN getError IN hMessageHandler (iCount,
                                             OUTPUT pErrorNumber,
                                             OUTPUT pErrorType,
                                             OUTPUT pErrorDesc ).

             run piCriaErro (17006,
                             pErrorType, 
                             SUBSTRING(pErrorDesc,1,800)).
     END.
     RETURN "NOK":U.
   END.

END. 


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


