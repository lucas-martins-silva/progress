&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXRMA005 2.00.00.027 } /*** 010027 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i axrma005 MUT}
&ENDIF





/*------------------------------------------------------------------------
    File        : axrma005.p
    Purpose     : Recebimento de Item
    Syntax      :
    Description :
    Author(s)   :
    Created     : 26/11/2007
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* DEFINE PRE-PROCESSADORES */
&GLOBAL-DEFINE XmlApp            MA2
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlMod            MCE
&GLOBAL-DEFINE XmlProdVersion    204
&GLOBAL-DEFINE XmlTranName       Item
&GLOBAL-DEFINE XmlMinTranVersion 204.000
&GLOBAL-DEFINE XmlMaxTranVersion 299.999
&GLOBAL-DEFINE XmlListOfAction   add,upd,del

{xmlinc/xmlloadmessagehandlerrecdef.i}
{xmlinc/xmlloadgenxmlrecdef.i}
{utp/ut-glob.i} /* Vari†veis Globais          */
{cdp/cd0666.i}  /* Temp-table de erros padr∆o */

{method/dbotterr.i}
{cdp/cdcfgmat.i}
{cdp/cdcfgman.i}
{inbo/boin172.i tt-item}
{mfbo/bomf172.i tt-item-man}
{inbo/boin375.i tt-ref-item}
{inbo/boin172j.i}
{dibo/bodi259.i tt-item-cota}        /* Logistica */ 
{dibo/bodi300.i tt-item-dist}        /* Logistica */ 
{inbo/boin667.i tt-item-mat-aux}     /* Logistica */ 
{inbo/boin684.i tt-item-uni-estab}   /* Logistica */ 


def var iErro                       as int no-undo.
def var hDBOItem                    as handle no-undo.
def var hDBOItem-man                as handle no-undo.
def var hDBOItem-cota               as handle no-undo. /* Logistica */
def var hDBOItem-dist               as handle no-undo. /* Logistica */
def var hDBOItem-mat                as handle no-undo. /* Logistica */
def var hDBOItem-uni-estab          as handle no-undo. /* Logistica */
def var h-boin172log                as handle no-undo. /* Logistica */
def var hDBORef-item                as handle no-undo.

def var iMaterialFamilyId           as int    no-undo.
def var iInventoryGroupId           as int    no-undo.
def var iUnitOfMeasureId            as int    no-undo.
def var iDefaultSiteId              as int    no-undo.
def var iCommercialInventoryId      as int    no-undo.
                                              
/* Include Manufatura */
def var iManufactureId              as int    no-undo.
def var iWareHouseId                as int    no-undo.
def var iTechnicalInformationId     as int    no-undo.
def var iSpecificationSheetId       as int    no-undo.
def var iTargetListId               as int    no-undo.
def var iApprovalLevelId            as int    no-undo.
def var iProductionId               as int    no-undo.
def var iProductionLineId           as int    no-undo.
def var iReportsId                  as int    no-undo.
def var iAllocationId               as int    no-undo.
def var iLocationId                 as int    no-undo.
def var iRepositionId               as int    no-undo.
def var iStandardCurrId             as int    no-undo.
def var iCapacityResourcePlanningId as int    no-undo.
def var iScrapItemId                as int    no-undo.
def var iMfgResourcePlanningId      as int    no-undo.
def var iPlannerId                  as int    no-undo.
def var iUserId                     as int    no-undo.
def var iAdvancedPlanningScheduleId as int    no-undo.
def var iListOfReferenceId          as int    no-undo.
def var iReferenceId                as int    no-undo.
def var iShopFloorControl           as int    no-undo.
def var iUpsert                     as int    no-undo.
def var c-classificacao             as char   no-undo.   
def var i-origem                    as int    no-undo.
def var i-tp-lote-economico         as int    no-undo.
def var i-tp-contr-estoq            as int    no-undo.
def var i-emissao-ord               as int    no-undo.
def var i-geracao-ordem             as int    no-undo.
def var de-qtde-fixa                as dec    no-undo.
def var de-qtde-max                 as dec    no-undo.
def var de-unid-peso                as dec    no-undo.
def var i-politica                  as int    no-undo.
def var l-demanda                   as log    no-undo.
def var i-periodo-fixo              as int    no-undo.
def var de-ressuprimento            as dec    no-undo.
def var l-cons-previsao             as log    no-undo.
def var i-cd-origem                 as int    no-undo.
def var i-classe-repro              as int    no-undo.
def var c-horiz-lib                 as char   no-undo.
def var i-politica-aps              as int    no-undo.
def var l-multi-malha               as log    no-undo.
def var c-cod-malha                 as char   no-undo.
def var c-cod-pulmao                as char   no-undo.
def var c-cod-refer                 as char   no-undo.
def var i-sequencia                 as int    no-undo.
def var l-considera-aloc-ativ       as log    no-undo.
def var de-overlap                  as dec    no-undo.
def var l-program-sfc               as log    no-undo.
def var dt-implant                  as date   no-undo.
def var dt-liberac                  as date   no-undo.
def var i-status                    as int    no-undo.
def var l-baixa-estoq               as log    no-undo.
def var i-ind-imp-desc              as int    no-undo.  
def var de-peso-bruto               as dec    no-undo.    
def var de-peso-liquido             as dec    no-undo.    
def var de-peso                     as dec    no-undo.
def var de-altura                   as dec    no-undo.
def var de-largura                  as dec    no-undo.
def var de-comprim                  as dec    no-undo.
def var i-nivel-apr-requis          as int    no-undo.
def var i-nivel-apr-solic           as int    no-undo.
def var i-nivel-apr-manut           as int    no-undo.
def var i-nivel-apr-compra          as int    no-undo.
def var i-tipo-requis               as int    no-undo.
def var i-ind-refugo                as int    no-undo.
def var de-fator-refugo             as dec    no-undo.
def var i-tp-adm-lote               as int    no-undo.
def var de-lote-economi             as dec    no-undo.
def var de-lote-multipl             as dec    no-undo.
def var de-lote-minimo              as dec    no-undo.
def var i-div-ordem                 as int    no-undo.
def var l-ind-backorder             as log    no-undo.
def var l-mp-restrit                as log    no-undo.
def var de-qtd-batch-padrao         as dec    no-undo.
def var i-compr-fabric              as int    no-undo.  
def var de-fator-conver             as dec    no-undo.  
def var l-log-necessita-li          as log    no-undo.   
def var l-log-atualiz-via-mmp       as log    no-undo. 
def var l-log-carac-tec             as log    no-undo.  
def var de-qt-max-ordem             as dec    no-undo.
def var de-tp-cons-prev             as dec    no-undo.
def var i-nr-linha                  as int    no-undo.
def var i-reporte-mob               as int    no-undo.
def var i-reporte-ggf               as int    no-undo.
def var i-rep-prod                  as int    no-undo.
def var de-var-mob-maior            as dec    no-undo.
def var de-var-mob-menor            as dec    no-undo.
def var de-var-rep                  as dec    no-undo.
def var de-var-req-menor            as dec    no-undo.
def var de-var-req-maior            as dec    no-undo.
def var de-var-transf               as dec    no-undo.
def var i-sit-aloc                  as int    no-undo.
def var l-loc-unica                 as log    no-undo.
def var de-pto-repos                as dec    no-undo.
def var de-lote-repos               as dec    no-undo.
def var i-ind-prev-demanda          as int    no-undo.
def var de-ponto-encomenda          as dec    no-undo.
def var l-cons-produto              as log    no-undo.
def var l-cons-saldo                as log    no-undo.
def var i-classif-abc               as int    no-undo.
def var i-moeda-padrao              as int    no-undo.
def var i-ind-calc-meta             as int    no-undo.
def var i-prioridade                as int    no-undo.
def var de-val-fator-custo-dis      as dec    no-undo.
def var l-atu-conf                  as log    no-undo.
def var i-tipo-sched                as int    no-undo.
def var i-calc-lead-time            as int    no-undo.
def var i-tipo-formula              as int    no-undo.
def var i-cd-formula                as int    no-undo.
def var de-per-ppm                  as dec    no-undo.
def var l-log-control-estoq-refugo  as log    no-undo.
def var de-val-relac-refugo-item    as dec    no-undo.
def var l-log-refugo-preco-fisc     as log    no-undo.
def var de-cap-est-fabr             as dec    no-undo.
def var i-contr-plan                as int    no-undo.
def var i-ind-lista-mrp             as int    no-undo.
def var de-qt-min-res-fabr          as dec    no-undo.
def var de-var-qtd-res-fabr         as dec    no-undo.
def var i-ind-lista-csp             as int    no-undo.
def var l-log-ad-consumo            as log    no-undo.
def var l-log-aprov-estrut          as log    no-undo.
def var l-log-aprov-rot             as log    no-undo.
def var l-log-finaliz-op            as log    no-undo.
def var i-horiz-fixo                as int    no-undo.

/* Include Logistica */
def var iDistributionId                      as int                  no-undo.
DEF VAR iIsItemAllowedToBeInvoiced           as int                  no-undo. 
def var iMaterialId                          as int                  no-undo.
def var iFiscalInformationId                 as int init ?           no-undo. /* devido as validacoes da BO */ 
def var iFiscalClassificationId              as int                  no-undo.
def var iBrazilianTaxesId                    as int init ?           no-undo. /* devido as validacoes da BO */
def var iServiceTypeId                       as int init ?           no-undo. /* devido as validacoes da BO */
def var iTaxId                               as int init ?           no-undo. /* devido as validacoes da BO */
def var iInvestmentAccountId                 as int                  no-undo.
def var iExpenseNatureId                     as int                  no-undo.
def var iExpenseTypeId                       as int                  no-undo.
def var iBuyerId                             as int                  no-undo.
def var iManagerSiteId                       as int                  no-undo.
def var iPurchaseGroupId                     as int                  no-undo.
def var iInventoryInformationId              as int                  no-undo.
def var iReplenishmentId                     as int                  no-undo.
def var iSupplyFrequencyId                   as int                  no-undo.
def var iWeightingFormulasId                 as int                  no-undo.
def var iInventoryCountingId                 as int                  no-undo.
def var iListOfWeightFactorsId               as int                  no-undo.
def var iWeightFactorId                      as int                  no-undo.
def var iQualityControlInformationId         as int                  no-undo.
def var v-cod-ean                            as char                 no-undo.
def var iSafetyId                            as int                  no-undo.
def var iPurchaseControlInformationId        as int                  no-undo.
def var iReceivingControlInformationId       as int                  no-undo.
def var iServicesProdCircTaxId               as int                  no-undo. 
def var iServiceTaxId                        as int                  no-undo. 
def var iIndustrializedProductTaxId          as int                  no-undo. 
def var l-IndustrializedProductTax           as LOG                  no-undo. 
def var iSocialIntegrationProgramTaxId       as int                  no-undo. 
def var i-IntegrationTaxSource               as int                  no-undo. 
def var d-IntegrationTaxPercentage           as DEC                  no-undo. 
def var d-IntegrationTaxReduction            as DEC                  no-undo. 
def var i-SecurityTaxSource                  as int                  no-undo. 
def var d-SecurityTaxPercentage              as DEC                  no-undo. 
def var d-SecurityTaxReduction               as DEC                  no-undo. 
def var l-SocialIntegrationProgram           as LOG                  no-undo. 
def var i-ImportTaxTaxationCode              as int                  no-undo. 
def var d-ImportTaxPercentage                as DEC                  no-undo. 
def var iBeverageInvoicingInformationId      as int                  no-undo. 
def var iQuotaManagementInformationId        as int                  no-undo. 
def var d-IntegrationTaxSource               as DEC                  no-undo. 
def var iSocialSecurityContributionTaxId     as int                  no-undo. 
def var d-SecurityTaxSource                  as DEC                  no-undo. 
def var c-cod-erro                           as char FORMAT "x(500)" no-undo.

def var hGenXml             as handle no-undo.
def var cReturnValue        as char   no-undo.
def var hBusinessContent    as handle no-undo.
def var lSuccessProcess     as log    no-undo.
def var cValue              as char   no-undo.
def var cNodeName           as char   no-undo.
def var iIdList             as int    no-undo.
def var iIdLine             as int    no-undo.
def var iIdNext             as int    no-undo.
def var cTranEvent          as char   no-undo.
def var cTranVersion        as char   no-undo.
def var cErrorText          as char   no-undo.
def var iCount              as int    no-undo.
def var cListRootSon        as char   no-undo.
def var iContRootSon        as int    no-undo.
def var hMessageHandler     as handle no-undo.
def var cTranAction         as char   no-undo.

DEFINE BUFFER bfitem FOR ITEM.
 
FIND FIRST param-global NO-LOCK NO-ERROR.

def temp-table tt-estabel no-undo
        field cod-estabel as char
        field log-exporta as log format "*/ "
        index codigo is primary unique cod-estabel
        index exporta log-exporta.  

def new shared temp-table tt-old-item no-undo like item
    use-index codigo.       

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 33.67
         WIDTH              = 164.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* DEFINE A PROCEDURE getTransSubsInfo  */
{xmlinc/xmlgettranssubsinfo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-cria-pi-valida) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cria-pi-valida Procedure 
PROCEDURE cria-pi-valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
   if not valid-handle(h-boin172log) or
       h-boin172log:type <> "PROCEDURE":U or
       h-boin172log:file-name <> "inbo/boin172log.p":U then do:
       run inbo/boin172log.p persistent set h-boin172log.
   end.

   RUN pi-seta-defaut IN h-boin172log(INPUT-OUTPUT TABLE tt-item).

   FIND FIRST tt-item NO-LOCK NO-ERROR.
   IF AVAIL tt-item THEN DO:
       create tt-pi-valida.
       assign tt-pi-valida.it-codigo     = tt-item.it-codigo   
              tt-pi-valida.desc-item     = tt-item.desc-item   
              tt-pi-valida.fm-codigo     = tt-item.fm-codigo   
              tt-pi-valida.un            = tt-item.un          
              tt-pi-valida.tipo-contr    = tt-item.tipo-contr  
              tt-pi-valida.lote-economi  = tt-item.lote-economi 
              tt-pi-valida.cap-est-fabr  = tt-item.cap-est-fabr 
              tt-pi-valida.cd-planejado  = tt-item.cd-planejado 
              tt-pi-valida.classe-repro  = tt-item.classe-repro 
              tt-pi-valida.cod-comprado  = tt-item.cod-comprado 
              tt-pi-valida.cod-localiz   = tt-item.cod-localiz  
              tt-pi-valida.demanda       = tt-item.demanda      
              tt-pi-valida.deposito-pad  = tt-item.deposito-pad 
              tt-pi-valida.div-ordem     = tt-item.div-ordem    
              tt-pi-valida.emissao-ord   = tt-item.emissao-ord  
              tt-pi-valida.fator-refugo  = tt-item.fator-refugo
              tt-pi-valida.lote-minimo   = tt-item.lote-minimo 
              tt-pi-valida.lote-multipl  = tt-item.lote-multipl
              tt-pi-valida.nr-linha      = tt-item.nr-linha    
              tt-pi-valida.periodo-fixo  = tt-item.periodo-fixo
              tt-pi-valida.politica      = tt-item.politica    
              tt-pi-valida.quant-perda   = tt-item.quant-perda 
              tt-pi-valida.quant-segur   = tt-item.quant-segur 
              tt-pi-valida.reporte-mob   = tt-item.reporte-mob 
              tt-pi-valida.res-cq-comp   = tt-item.res-cq-comp 
              tt-pi-valida.res-cq-fabri  = tt-item.res-cq-fabri
              tt-pi-valida.res-for-comp  = tt-item.res-for-comp
              tt-pi-valida.res-int-comp  = tt-item.res-int-comp
              tt-pi-valida.ressup-fabri  = tt-item.ressup-fabri
              tt-pi-valida.tempo-segur   = tt-item.tempo-segur 
              tt-pi-valida.tipo-con-est  = tt-item.tipo-con-est
              tt-pi-valida.tipo-est-seg  = tt-item.tipo-est-seg
              tt-pi-valida.tipo-lote-ec  = tt-item.tipo-lote-ec
              tt-pi-valida.tipo-requis   = tt-item.tipo-requis 
              tt-pi-valida.data-implant  = tt-item.data-implant
              tt-pi-valida.data-liberac  = tt-item.data-liberac
              tt-pi-valida.ge-codigo     = tt-item.ge-codigo   
              tt-pi-valida.fraciona      = tt-item.fraciona    
              tt-pi-valida.contr-plan    = tt-item.contr-plan  
              tt-pi-valida.rep-prod      = tt-item.rep-prod    
              tt-pi-valida.cd-folh-item  = tt-item.cd-folh-item
              tt-pi-valida.cod-imagem    = tt-item.cod-imagem
              tt-pi-valida.fm-cod-com    = tt-item.fm-cod-com  
              tt-pi-valida.cod-estabel   = tt-item.cod-estabel 
              tt-pi-valida.ind-serv-mat  = tt-item.ind-serv-mat
              tt-pi-valida.cod-obsoleto  = tt-item.cod-obsoleto
           &IF defined(bf_man_205) &THEN
              tt-pi-valida.tipo-formula  = tt-item.tipo-formula
              tt-pi-valida.per-ppm       = tt-item.per-ppm     
           &ENDIF
      .

     
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piAlteraItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAlteraItem Procedure 
PROCEDURE piAlteraItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var h-boin172j as handle no-undo.

    do transaction:

        /* Cria Item */
        if not valid-handle(hDBOItem) or
            hDBOItem:type <> "PROCEDURE":U or
            hDBOItem:file-name <> "inbo/boin172.p":U then do:
            run inbo/boin172.p persistent set hDBOItem.
        end.
    
        if not valid-handle(h-boin172j) then
            run inbo/boin172j.p persistent set h-boin172j.
    
        run openQueryStatic in hDBOItem (input "Main":U) no-error.
    
        run goToKey in hDBOItem(input tt-item.it-codigo).
        if return-value <> "ok" then do:
    
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-o-item AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "O_Item" *}
            ASSIGN c-lbl-liter-o-item = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-que-esta-sendo-alterado AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "que_est†_sendo_alterado" *}
            ASSIGN c-lbl-liter-que-esta-sendo-alterado = TRIM(RETURN-VALUE).
            run utp/ut-msgs.p (input "msg",
                               input 31653,
                               INPUT  c-lbl-liter-o-item + " " + tt-item.it-codigo + " " + c-lbl-liter-que-esta-sendo-alterado).
            
            create tt-erro.
            assign tt-erro.i-sequen = i-sequencia + 1
                   tt-erro.cd-erro  = 31653
                   tt-erro.mensagem = return-value
                   i-sequencia      = i-sequencia + 1.

            undo, return "nok":u.
        end.
        else do:
            assign c-cod-erro = "".
            run pi-valida-alteracao-item in hDBOItem (input table tt-pi-valida, 
                                                      output c-cod-erro).
            if c-cod-erro <> "" then do:
                do iErro = 1 to num-entries(c-cod-erro):
           
                     create tt-erro.
                     assign tt-erro.i-sequen = i-sequencia + 1
                            tt-erro.cd-erro  = int(entry(iErro, c-cod-erro, ","))
                            i-sequencia      = i-sequencia + 1.
           
                end.
            end.
            assign c-cod-erro = "".
    
            run pi-valida-inclusao-alteracao in h-boin172j (input "upd",
                                                            input table tt-item,
                                                            output c-cod-erro).
            if c-cod-erro <> "" then do:
                do iErro = 1 to num-entries(c-cod-erro):
    
                     create tt-erro.
                     assign tt-erro.i-sequen = i-sequencia + 1
                            tt-erro.cd-erro  = int(entry(iErro, c-cod-erro, ","))
                            i-sequencia      = i-sequencia + 1.
        
                end.
            end.
    
            assign c-cod-erro = "".
    
            run pi-valida-alteracao-eai in h-boin172j (input table tt-item,
                                                       input table tt-ref-item,
                                                       output c-cod-erro).
    
            if c-cod-erro <> "" then do:
                do iErro = 1 to num-entries(c-cod-erro):
        
                     create tt-erro.
                     assign tt-erro.i-sequen = i-sequencia + 1
                            tt-erro.cd-erro  = int(entry(iErro, c-cod-erro, ","))
                            i-sequencia      = i-sequencia + 1.
        
                end.
            end.
    
        end.
    
        if not can-find (first tt-erro) then do:
            run emptyRowErrors in hDBOItem.

            run setRecord in hDBOItem (input table tt-item).
            run updateRecord in hDBOItem.

            if return-value <> "ok" then do:    
                run getRowErrors in hDBOItem(output table RowErrors).
                if can-find(first RowErrors
                            where RowErrors.ErrorType <> "INTERNAL":U no-lock) then do:
        
                    for each RowErrors:
        
                        create tt-erro.
                        assign tt-erro.i-sequen = i-sequencia + 1
                               tt-erro.cd-erro  = RowErrors.ErrorNumber
                               tt-erro.mensagem = RowErrors.ErrorDescription
                               i-sequencia      = i-sequencia + 1.
        
                    end.
        
                    undo, return "NOK":U.
                end.
            end.
            else do:
    
                /* 1- altera Item-man */
                if not valid-handle(hDBOItem-man) or
                    hDBOItem-man:type <> "PROCEDURE":U or
                    hDBOItem-man:file-name <> "mfbo/bomf172.p":U then do:
                    run mfbo/bomf172.p persistent set hDBOItem-man.
                end.
            
                run openQueryStatic in hDBOItem-man (input "Main":U) no-error.
            
                run goToKey in hDBOItem-man(input tt-item-man.it-codigo).
                run emptyRowErrors in hDBOItem-man.
                run setRecord in hDBOItem-man (input table tt-item-man).
                run updateRecord in hDBOItem-man.
                if return-value <> "ok" then do:    
                    run getRowErrors in hDBOItem-man(output table RowErrors).
                    if can-find(first RowErrors
                                where RowErrors.ErrorType <> "INTERNAL":U no-lock) then do:
        
                        for each RowErrors:
        
                            create tt-erro.
                            assign tt-erro.i-sequen = i-sequencia + 1
                                   tt-erro.cd-erro  = RowErrors.ErrorNumber
                                   tt-erro.mensagem = RowErrors.ErrorDescription
                                   i-sequencia      = i-sequencia + 1.
            
                        end.
            
                        undo, return "NOK":U.
                    end.
                end.
    
                IF param-global.modulo-08 THEN DO: /*modulo de cotas ligado*/
                
                    /* 2- altera Item-Cota - Logistica */
                    if not valid-handle(hDBOItem-cota) or
                        hDBOItem-cota:type <> "PROCEDURE":U or
                        hDBOItem-cota:file-name <> "dibo/bodi259.p":U then do:
                        run dibo/bodi259.p persistent set hDBOItem-cota.
                    end.
                
                    run openQueryStatic in hDBOItem-cota (input "Main":U) no-error.
                
                    run goToKey in hDBOItem-cota(input tt-item-cota.it-codigo).
                    run emptyRowErrors in hDBOItem-cota.
                    run setRecord in hDBOItem-cota (input table tt-item-cota).
                    run updateRecord in hDBOItem-cota.
                    if return-value <> "ok" then do:    
                        run getRowErrors in hDBOItem-cota(output table RowErrors).
                        if can-find(first RowErrors
                                    where RowErrors.ErrorType <> "INTERNAL":U no-lock) then do:
            
                            for each RowErrors:
            
                                create tt-erro.
                                assign tt-erro.i-sequen = i-sequencia + 1
                                       tt-erro.cd-erro  = RowErrors.ErrorNumber
                                       tt-erro.mensagem = RowErrors.ErrorDescription
                                       i-sequencia      = i-sequencia + 1.
                
                            end.
                
                            undo, return "NOK":U.
                        end.
                    end.
                END.

                /* 3- altera Item-Dist - Logistica */
                if not valid-handle(hDBOItem-dist) or
                    hDBOItem-dist:type <> "PROCEDURE":U or
                    hDBOItem-dist:file-name <> "dibo/bodi300.p":U then do:
                    run dibo/bodi300.p persistent set hDBOItem-dist.
                end.
            
                run openQueryStatic in hDBOItem-dist (input "default":U) no-error.
            
                run goToKey in hDBOItem-dist(input tt-item-dist.it-codigo).
                run emptyRowErrors in hDBOItem-dist.
                run setRecord in hDBOItem-dist (input table tt-item-dist).
                run updateRecord in hDBOItem-dist.
                if return-value <> "ok" then do:    
                    run getRowErrors in hDBOItem-dist(output table RowErrors).
                    if can-find(first RowErrors
                                where RowErrors.ErrorType <> "INTERNAL":U no-lock) then do:
        
                        for each RowErrors:
        
                            create tt-erro.
                            assign tt-erro.i-sequen = i-sequencia + 1
                                   tt-erro.cd-erro  = RowErrors.ErrorNumber
                                   tt-erro.mensagem = RowErrors.ErrorDescription
                                   i-sequencia      = i-sequencia + 1.
            
                        end.
            
                        undo, return "NOK":U.
                    end.
                end.
                
                /* 4- altera Item-Mat - Logistica */
                if not valid-handle(hDBOItem-mat) or
                    hDBOItem-mat:type <> "PROCEDURE":U or
                    hDBOItem-mat:file-name <> "inbo/boin667.p":U then do:
                    run inbo/boin667.p persistent set hDBOItem-mat.
                end.

                run openQueryStatic in hDBOItem-mat (input "Main":U) no-error.
            
                run goToKey in hDBOItem-mat(input tt-item-mat-aux.it-codigo).
                run emptyRowErrors in hDBOItem-mat.
                run setRecord in hDBOItem-mat (input table tt-item-mat-aux).
                run updateRecord in hDBOItem-mat.
                if return-value <> "ok" then do:    
                    run getRowErrors in hDBOItem-mat(output table RowErrors).
                    if can-find(first RowErrors
                                where RowErrors.ErrorType <> "INTERNAL":U no-lock) then do:
        
                        for each RowErrors:
        
                            create tt-erro.
                            assign tt-erro.i-sequen = i-sequencia + 1
                                   tt-erro.cd-erro  = RowErrors.ErrorNumber
                                   tt-erro.mensagem = RowErrors.ErrorDescription
                                   i-sequencia      = i-sequencia + 1.
            
                        end.
            
                        undo, return "NOK":U.
                    end.
                end.
    
                /* 5- altera Item-Uni-Estab - Logistica */
                if not valid-handle(hDBOItem-uni-estab) or
                    hDBOItem-uni-estab:type <> "PROCEDURE":U or
                    hDBOItem-uni-estab:file-name <> "inbo/boin684va.p":U then do:
                    run inbo/boin684va.p persistent set hDBOItem-uni-estab.
                end.
            
                run openQueryStatic in hDBOItem-uni-estab (input "Main":U) no-error.
            
                run goToKey in hDBOItem-uni-estab(input tt-item-uni-estab.it-codigo,
                                                  input tt-item-uni-estab.cod-estabel).

                run emptyRowErrors in hDBOItem-uni-estab.
                run setRecord in hDBOItem-uni-estab (input table tt-item-uni-estab).
                run updateRecord in hDBOItem-uni-estab.
                if return-value <> "ok" then do:    
                    run getRowErrors in hDBOItem-uni-estab(output table RowErrors).
                    if can-find(first RowErrors
                                where RowErrors.ErrorType <> "INTERNAL":U no-lock) then do:
        
                        for each RowErrors:
        
                            create tt-erro.
                            assign tt-erro.i-sequen = i-sequencia + 1
                                   tt-erro.cd-erro  = RowErrors.ErrorNumber
                                   tt-erro.mensagem = RowErrors.ErrorDescription
                                   i-sequencia      = i-sequencia + 1.
            
                        end.
            
                        undo, return "NOK":U.
                    end.
                end.
    
                if avail tt-ref-item then do:
                    /* altera Ref-Item */
                    if not valid-handle(hDBORef-item) or
                        hDBORef-item:type <> "PROCEDURE":U or
                        hDBORef-item:file-name <> "inbo/boin375.p":U then do:
                        run inbo/boin375.p persistent set hDBORef-item.
                    end.
                
                    run openQueryStatic in hDBORef-item (input "Main":U) no-error.
                
                    run goToKey in hDBORef-item(input tt-ref-item.it-codigo,
                                                input tt-ref-item.cod-refer).
                    if return-value = "ok" then do:
                        run emptyRowErrors in hDBORef-item.
                        run setRecord in hDBORef-item (input table tt-ref-item).
                        run updateRecord in hDBORef-item.
                        if return-value <> "ok" then do:    
                            run getRowErrors in hDBORef-item(output table RowErrors).
                            if can-find(first RowErrors
                                        where RowErrors.ErrorType <> "INTERNAL":U no-lock) then do:
                    
                                for each RowErrors:
                
                                    create tt-erro.
                                    assign tt-erro.i-sequen = i-sequencia + 1
                                           tt-erro.cd-erro  = RowErrors.ErrorNumber
                                           tt-erro.mensagem = RowErrors.ErrorDescription
                                           i-sequencia      = i-sequencia + 1.
                    
                                end.
                    
                                undo, return "NOK":U.
                            end.
                        end.
                    end.

                end.

                RUN pi-atualiza-item-cd0204k.
            end.
        end.
    end.
       
    if valid-handle(hDBOItem) THEN DO:
       run destroy in hDBOItem.
    END.
   
    if valid-handle(hDBORef-item) THEN DO:
        run destroy in hDBORef-item.
    END.

    if valid-handle(h-boin172j) then
        delete procedure h-boin172j.

    if valid-handle(hDBOItem-man) THEN DO:
        run destroy in hDBOItem-man.
    END.

    if valid-handle(hDBOItem-cota) THEN DO:         /* Logistica */
        run destroy in hDBOItem-cota.
    END.

    if valid-handle(hDBOItem-dist) THEN DO:         /* Logistica */
        run destroy in hDBOItem-dist.
    END.
    if valid-handle(hDBOItem-mat) then DO:         /* Logistica */
        run destroy in hDBOItem-mat.
    END.

    if valid-handle(hDBOItem-uni-estab) THEN DO:    /* Logistica */
        run destroy in hDBOItem-uni-estab.
    END.

return "ok":u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCriaItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaItem Procedure 
PROCEDURE piCriaItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var h-boin172j as handle no-undo.

    do transaction:

        /* Cria Item */
        if not valid-handle(hDBOItem) or
            hDBOItem:type <> "PROCEDURE":U or
            hDBOItem:file-name <> "inbo/boin172.p":U then do:
            run inbo/boin172.p persistent set hDBOItem.
        end.
    
        if not valid-handle(h-boin172j) then
            run inbo/boin172j.p persistent set h-boin172j.
    
        run openQueryStatic in hDBOItem (input "Main":U) no-error.
    
        run goToKey in hDBOItem(input tt-item.it-codigo).
        assign c-cod-erro = "".

        run pi-valida-inclusao-item in hDBOItem (input table tt-pi-valida, 
                                                 output c-cod-erro).
        if c-cod-erro <> "" then do:
            do iErro = 1 to num-entries(c-cod-erro):
    
                 create tt-erro.
                 assign tt-erro.i-sequen = i-sequencia + 1
                        tt-erro.cd-erro  = int(entry(iErro, c-cod-erro, ","))
                        i-sequencia      = i-sequencia + 1.
    
            end.
        end.
    
        assign c-cod-erro = "".
                 
        run pi-valida-inclusao-alteracao in h-boin172j (input "add",
                                                        input table tt-item,
                                                        output c-cod-erro).
        if c-cod-erro <> "" then do:
            do iErro = 1 to num-entries(c-cod-erro):
    
                 create tt-erro.
                 assign tt-erro.i-sequen = i-sequencia + 1
                        tt-erro.cd-erro  = int(entry(iErro, c-cod-erro, ","))
                        i-sequencia      = i-sequencia + 1.
    
            end.
        end.
    
        assign c-cod-erro = "".
                     
        run pi-valida-criacao-eai in h-boin172j (input table tt-item,
                                                 input table tt-ref-item,
                                                 output c-cod-erro).
    
        if c-cod-erro <> "" then do:
            do iErro = 1 to num-entries(c-cod-erro):
    
                create tt-erro.
                assign tt-erro.i-sequen = i-sequencia + 1
                       tt-erro.cd-erro  = int(entry(iErro, c-cod-erro, ","))
                       i-sequencia      = i-sequencia + 1.
    
            end.
        end.
    
        /* --------------------------------- */

        if not can-find(first tt-erro) then do:
            
            IF AVAIL tt-item AND 
               tt-item.cod-unid-negoc = "" OR
               tt-item.cod-unid-negoc = ?
            THEN DO:
                FIND familia 
                    WHERE familia.fm-codigo = tt-item.fm-codigo NO-LOCK NO-ERROR.
                IF AVAIL familia THEN DO: 
                    FIND FIRST fam-uni-estab 
                         WHERE fam-uni-estab.fm-codigo = familia.fm-codigo
                         NO-LOCK NO-ERROR. 
                    IF AVAIL fam-uni-estab THEN DO:
                        ASSIGN tt-item.cod-unid-negoc = fam-uni-estab.cod-unid-negoc.
                        
                        IF tt-item.cod-unid-negoc = "" OR 
                           tt-item.cod-unid-negoc = ? THEN DO:

                            FIND FIRST familia-mat
                                 WHERE familia-mat.fm-codigo = familia.fm-codigo NO-LOCK NO-ERROR. 

                            IF AVAIL familia-mat THEN DO:
                                ASSIGN tt-item.cod-unid-negoc = familia-mat.cod-unid-negoc.
                            END.
                        END.
                    END.
                 END.
              END.

            IF AVAIL tt-item 
                AND tt-item.nat-despesa =  0 
                 OR tt-item.nat-despesa =  ? THEN DO:

                FIND familia 
                    WHERE familia.fm-codigo = tt-item.fm-codigo NO-LOCK NO-ERROR.
                IF AVAIL familia THEN DO:
                    FIND FIRST fam-uni-estab 
                         WHERE fam-uni-estab.fm-codigo = familia.fm-codigo
                         NO-LOCK NO-ERROR. 

                    IF AVAIL fam-uni-estab THEN DO:
                        ASSIGN tt-item.nat-despesa = fam-uni-estab.nat-despesa.

                        IF tt-item.nat-despesa = 0 OR tt-item.nat-despesa = ? THEN DO:

                            FIND FIRST familia-mat
                                 WHERE familia-mat.fm-codigo = familia.fm-codigo NO-LOCK NO-ERROR. 

                            IF AVAIL familia-mat THEN DO:
                                ASSIGN tt-item.nat-despesa = familia-mat.nat-despesa.
                            END.
                        END.
                    END.
                END.
            END.
            
            IF AVAIL tt-item 
                 AND tt-item.tp-desp-padrao = 0 
                  OR tt-item.tp-desp-padrao = ? THEN DO: 

                  FIND familia                                                                                                         
                      WHERE familia.fm-codigo = tt-item.fm-codigo NO-LOCK NO-ERROR.                                                    
                  IF AVAIL familia THEN DO:                                                                                            
                                                                                                                                       
                      FIND FIRST fam-uni-estab                                                                                         
                           WHERE fam-uni-estab.fm-codigo = familia.fm-codigo NO-LOCK NO-ERROR. 

                      IF AVAIL fam-uni-estab THEN DO:                                                                                  
                          ASSIGN tt-item.tp-desp-padrao = fam-uni-estab.tp-desp-padrao.                                                      
                                                                                                                                       
                          IF tt-item.tp-desp-padrao = 0 OR tt-item.tp-desp-padrao = ? THEN DO:                                                                                                          
                              FIND FIRST familia-mat                                                                                   
                                   WHERE familia-mat.fm-codigo = familia.fm-codigo NO-LOCK NO-ERROR.                                   
                                                                                                                                       
                              IF AVAIL familia-mat THEN DO:                                                                            
                                  ASSIGN tt-item.tp-desp-padrao = familia-mat.int-1. /* int1 = tipo despesa */                                                
                              END.                                                                                                     
                          END.                                                                                                         
                      END.                                                                                                             
                  END.                                                                                                                 
            END.                                                                                                                     

            run emptyRowErrors in hDBOItem.
            run setRecord in hDBOItem (input table tt-item).
            run createRecord in hDBOItem.
            
            if return-value <> "ok" then do:    
                run getRowErrors in hDBOItem(output table RowErrors).
                if can-find(first RowErrors
                            where RowErrors.ErrorType <> "INTERNAL":U no-lock) then do:
        
                    for each RowErrors:
        
                        create tt-erro.
                        assign tt-erro.i-sequen = i-sequencia + 1
                               tt-erro.cd-erro  = RowErrors.ErrorNumber
                               tt-erro.mensagem = RowErrors.ErrorDescription
                               i-sequencia      = i-sequencia + 1.
        
                    end.        
                    undo, return "NOK":U.
                end.
            end.
            else do:
        
                /* 1- Altera Item-man, pois a trigger de item j† cria a item-man, ent∆o os campos
                      que foram trazidos devem ser apenas atualizados na tabela */
                if not valid-handle(hDBOItem-man) or
                    hDBOItem-man:type <> "PROCEDURE":U or
                    hDBOItem-man:file-name <> "mfbo/bomf172.p":U then do:
                    run mfbo/bomf172.p persistent set hDBOItem-man.
                end.
            
                run openQueryStatic in hDBOItem-man (input "Main":U) no-error.
                run goToKey in hDBOItem-man(input tt-item-man.it-codigo).
                run emptyRowErrors in hDBOItem-man.
                run setRecord in hDBOItem-man (input table tt-item-man).
                run updateRecord in hDBOItem-man.

                if return-value <> "ok" then do:    
                    run getRowErrors in hDBOItem-man(output table RowErrors).
                    if can-find(first RowErrors
                                where RowErrors.ErrorType <> "INTERNAL":U no-lock) then do:
        
                        for each RowErrors:
        
                            create tt-erro.
                            assign tt-erro.i-sequen = i-sequencia + 1
                                   tt-erro.cd-erro  = RowErrors.ErrorNumber
                                   tt-erro.mensagem = RowErrors.ErrorDescription
                                   i-sequencia      = i-sequencia + 1.
            
                        end.
            
                        undo, return "NOK":U.
                    end.
                end.
    
                IF param-global.modulo-08 THEN DO: /*modulo de cotas ligado*/
                    /* 2- Cria Item-Cota - Logistica */
                    if not valid-handle(hDBOItem-cota) or
                        hDBOItem-cota:type <> "PROCEDURE":U or
                        hDBOItem-cota:file-name <> "dibo/bodi259.p":U then do:
                        run dibo/bodi259.p persistent set hDBOItem-cota.
                    end.
                
                    run openQueryStatic in hDBOItem-cota (input "Main":U) no-error.
                    run goToKey in hDBOItem-cota(input tt-item-cota.it-codigo).
                    run emptyRowErrors in hDBOItem-cota.
                    run setRecord in hDBOItem-cota (input table tt-item-cota).
                    run createRecord in hDBOItem-cota.
                    if return-value <> "ok" then do:    
                        run getRowErrors in hDBOItem-cota(output table RowErrors).
                        if can-find(first RowErrors
                                    where RowErrors.ErrorType <> "INTERNAL":U no-lock) then do:
            
                            for each RowErrors:
            
                                create tt-erro.
                                assign tt-erro.i-sequen = i-sequencia + 1
                                       tt-erro.cd-erro  = RowErrors.ErrorNumber
                                       tt-erro.mensagem = RowErrors.ErrorDescription
                                       i-sequencia      = i-sequencia + 1.
                
                            end.
                
                            undo, return "NOK":U.
                        end.
                    end.
                END.

                /* 3- Cria Item-Dist - Logistica */
                if not valid-handle(hDBOItem-dist) or
                    hDBOItem-dist:type <> "PROCEDURE":U or
                    hDBOItem-dist:file-name <> "dibo/bodi300.p":U then do:
                    run dibo/bodi300.p persistent set hDBOItem-dist.
                end.
            
                run openQueryStatic in hDBOItem-dist (input "default":U) no-error.
            
                run goToKey in hDBOItem-dist(input tt-item-dist.it-codigo).
                run emptyRowErrors in hDBOItem-dist.
                run setRecord in hDBOItem-dist (input table tt-item-dist).
                run createRecord in hDBOItem-dist.
                if return-value <> "ok" then do:    
                    run getRowErrors in hDBOItem-dist(output table RowErrors).
                    if can-find(first RowErrors
                                where RowErrors.ErrorType <> "INTERNAL":U no-lock) then do:
        
                        for each RowErrors:
        
                            create tt-erro.
                            assign tt-erro.i-sequen = i-sequencia + 1
                                   tt-erro.cd-erro  = RowErrors.ErrorNumber
                                   tt-erro.mensagem = RowErrors.ErrorDescription
                                   i-sequencia      = i-sequencia + 1.
            
                        end.
            
                        undo, return "NOK":U.
                    end.
                end.
                
                /* 4- Cria Item-Mat - Logistica */
                if not valid-handle(hDBOItem-mat) or
                    hDBOItem-mat:type <> "PROCEDURE":U or
                    hDBOItem-mat:file-name <> "inbo/boin667.p":U then do:
                    run inbo/boin667.p persistent set hDBOItem-mat.
                end.
            
                run openQueryStatic in hDBOItem-mat (input "Main":U) no-error.
            
                &if defined(bf_mat_fech_estab) &then
                   find familia-mat where
                        familia-mat.fm-codigo = tt-item.fm-codigo no-lock no-error.
                   if avail familia-mat then do: 
                      if avail tt-item-mat-aux then do:
                         buffer-copy familia-mat 
                               using cod-estab-gestor 
                                     cod-grp-compra 
                                     tp-ressup
                                     lote-per-max
                                  to tt-item-mat-aux.
                     
                         ASSIGN tt-item-mat-aux.variacao-perm    = 0
                                tt-item-mat-aux.prioridade-aprov = 1.   

                         &if "{&bf_mat_versao_ems}":U >= "2.062":U &then    
                             if i-pais-impto-usuario = 1 then
                                assign tt-item-mat-aux.cod-familia-impto = familia-mat.cod-familia-impto.
                             assign tt-item-mat-aux.val-lim-absor = familia-mat.val-lim-absor.              
                         &else
                             assign overlay(tt-item-mat-aux.char-1,1,10) = string(familia-mat.dec-2).
                         &endif
                      end.
                   end.
                &endif

                run goToKey in hDBOItem-mat(input tt-item-mat-aux.it-codigo).
                run emptyRowErrors in hDBOItem-mat.
                run setRecord in hDBOItem-mat (input table tt-item-mat-aux).
                run createRecord in hDBOItem-mat.
                if return-value <> "ok" then do:    
                    run getRowErrors in hDBOItem-mat(output table RowErrors).
                    if can-find(first RowErrors
                                where RowErrors.ErrorType <> "INTERNAL":U no-lock) then do:
        
                        for each RowErrors:
        
                            create tt-erro.
                            assign tt-erro.i-sequen = i-sequencia + 1
                                   tt-erro.cd-erro  = RowErrors.ErrorNumber
                                   tt-erro.mensagem = RowErrors.ErrorDescription
                                   i-sequencia      = i-sequencia + 1.
            
                        end.
            
                        undo, return "NOK":U.
                    end.
                end.
    
                if avail tt-ref-item then do:
                /* Cria Ref-Item */
                    if not valid-handle(hDBORef-item) or
                        hDBORef-item:type <> "PROCEDURE":U or
                        hDBORef-item:file-name <> "inbo/boin375.p":U then do:
                        run inbo/boin375.p persistent set hDBORef-item.
                    end.
                
                    run openQueryStatic in hDBORef-item (input "Main":U) no-error.
                
                    run goToKey in hDBORef-item(input tt-ref-item.it-codigo,
                                                input tt-ref-item.cod-refer).
                    run emptyRowErrors in hDBORef-item.
                    run setRecord in hDBORef-item (input table tt-ref-item).
                    run createRecord in hDBORef-item.
                    if return-value <> "ok" then do:    
                        run getRowErrors in hDBORef-item(output table RowErrors).
                        if can-find(first RowErrors
                                    where RowErrors.ErrorType <> "INTERNAL":U no-lock) then do:
                
                            for each RowErrors:
            
                                create tt-erro.
                                assign tt-erro.i-sequen = i-sequencia + 1
                                       tt-erro.cd-erro  = RowErrors.ErrorNumber
                                       tt-erro.mensagem = RowErrors.ErrorDescription
                                       i-sequencia      = i-sequencia + 1.
                
                            end.
                
                            undo, return "NOK":U.
                        end.
                    end.
                end.
        
            end.
        end.
    end.

    if valid-handle(hDBOItem) THEN DO:
       run destroy in hDBOItem.
    END.
   
    if valid-handle(hDBORef-item) THEN DO:
        run destroy in hDBORef-item.

    END.

    if valid-handle(h-boin172j) then
        delete procedure h-boin172j.

    if valid-handle(h-boin172log) then
        delete procedure h-boin172log.


    if valid-handle(hDBOItem-man) THEN DO:
        run destroy in hDBOItem-man.

    END.

    if valid-handle(hDBOItem-cota) THEN DO:         /* Logistica */
        run destroy in hDBOItem-cota.

    END.

    if valid-handle(hDBOItem-dist) THEN DO:         /* Logistica */
        run destroy in hDBOItem-dist.

    END.
    if valid-handle(hDBOItem-mat) then DO:         /* Logistica */
        run destroy in hDBOItem-mat.

    END.

    if valid-handle(hDBOItem-uni-estab) THEN DO:    /* Logistica */
        run destroy in hDBOItem-uni-estab.

    END.

return "ok":u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piExcluiItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExcluiItem Procedure 
PROCEDURE piExcluiItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    do transaction:
        
        /* Cria Item */
        if not valid-handle(hDBOItem) or
            hDBOItem:type <> "PROCEDURE":U or
            hDBOItem:file-name <> "inbo/boin172.p":U then do:
            run inbo/boin172.p persistent set hDBOItem.
        end.
    
        run openQueryStatic in hDBOItem (input "Main":U) no-error.
    
        run goToKey in hDBOItem(input tt-item.it-codigo).
        if return-value <> "ok" then do:
    
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-o-item-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "O_Item" *}
            ASSIGN c-lbl-liter-o-item-2 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-que-esta-sendo-excluido AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "que_est†_sendo_exclu°do" *}
            ASSIGN c-lbl-liter-que-esta-sendo-excluido = TRIM(RETURN-VALUE).
            run utp/ut-msgs.p (input "msg",
                               input 31653,
                               INPUT  c-lbl-liter-o-item-2 + " " + tt-item.it-codigo + " " + c-lbl-liter-que-esta-sendo-excluido).
            
            create tt-erro.
            assign tt-erro.i-sequen = i-sequencia + 1
                   tt-erro.cd-erro  = 31653
                   tt-erro.mensagem = return-value
                   i-sequencia      = i-sequencia + 1.
    
        end.
        else do:
            assign c-cod-erro = "".
            run pi-valida-exclusao-item in hDBOItem (input table tt-pi-valida, 
                                                     output c-cod-erro).
            if c-cod-erro <> "" then do:
                do iErro = 1 to num-entries(c-cod-erro):
        
                     create tt-erro.
                     assign tt-erro.i-sequen = i-sequencia + 1
                            tt-erro.cd-erro  = int(entry(iErro, c-cod-erro, ","))
                            i-sequencia      = i-sequencia + 1.
        
                end.
            end.
            else do:
                
                run emptyRowErrors in hDBOItem.
                run setRecord in hDBOItem (input table tt-item).
                run deleteRecord in hDBOItem.
                if return-value <> "ok" then do:    
                    run getRowErrors in hDBOItem(output table RowErrors).
                    if can-find(first RowErrors
                                where RowErrors.ErrorType <> "INTERNAL":U no-lock) then do:
            
                        for each RowErrors:
            
                            create tt-erro.
                            assign tt-erro.i-sequen = i-sequencia + 1
                                   tt-erro.cd-erro  = RowErrors.ErrorNumber
                                   tt-erro.mensagem = RowErrors.ErrorDescription
                                   i-sequencia      = i-sequencia + 1.
            
                        end.
            
                        undo, return "NOK":U.
                    end.
                end.
                else do:
                    
                    /* 1- Deleta Item-man */
                    if not valid-handle(hDBOItem-man) or
                        hDBOItem-man:type <> "PROCEDURE":U or
                        hDBOItem-man:file-name <> "mfbo/bomf172.p":U then do:
                        run mfbo/bomf172.p persistent set hDBOItem-man.
                    end.
                
                    run openQueryStatic in hDBOItem-man (input "Main":U) no-error.
                
                    run goToKey in hDBOItem-man(input tt-item-man.it-codigo).
                    run emptyRowErrors in hDBOItem-man.
                    run setRecord in hDBOItem-man (input table tt-item-man).
                    run deleteRecord in hDBOItem-man.
                    if return-value <> "ok" then do:    
                        run getRowErrors in hDBOItem-man(output table RowErrors).
                        if can-find(first RowErrors
                                    where RowErrors.ErrorType <> "INTERNAL":U no-lock) then do:
            
                            for each RowErrors:
            
                                create tt-erro.
                                assign tt-erro.i-sequen = i-sequencia + 1
                                       tt-erro.cd-erro  = RowErrors.ErrorNumber
                                       tt-erro.mensagem = RowErrors.ErrorDescription
                                       i-sequencia      = i-sequencia + 1.
                
                            end.
                
                            undo, return "NOK":U.
                        end.
                    end.
                    
    
                    IF param-global.modulo-08 THEN DO: /*modulo de cotas ligado*/
                        /* 2- Deleta Item-Cota - Logistica */
                        if not valid-handle(hDBOItem-cota) or
                            hDBOItem-cota:type <> "PROCEDURE":U or
                            hDBOItem-cota:file-name <> "dibo/bodi259.p":U then do:
                            run dibo/bodi259.p persistent set hDBOItem-cota.
                        end.
                    
                        run openQueryStatic in hDBOItem-cota (input "Main":U) no-error.
                    
                        run goToKey in hDBOItem-cota(input tt-item-cota.it-codigo).
                        run emptyRowErrors in hDBOItem-cota.
                        run setRecord in hDBOItem-cota (input table tt-item-cota).
                        run deleteRecord in hDBOItem-cota.
                        if return-value <> "ok" then do:    
                            run getRowErrors in hDBOItem-cota(output table RowErrors).
                            if can-find(first RowErrors
                                        where RowErrors.ErrorType <> "INTERNAL":U no-lock) then do:
                
                                for each RowErrors:
                
                                    create tt-erro.
                                    assign tt-erro.i-sequen = i-sequencia + 1
                                           tt-erro.cd-erro  = RowErrors.ErrorNumber
                                           tt-erro.mensagem = RowErrors.ErrorDescription
                                           i-sequencia      = i-sequencia + 1.
                    
                                end.
                    
                                undo, return "NOK":U.
                            end.
                        end.
                    END.

                    /* 3- Deleta Item-Dist - Logistica */
                    if not valid-handle(hDBOItem-dist) or
                        hDBOItem-dist:type <> "PROCEDURE":U or
                        hDBOItem-dist:file-name <> "dibo/bodi300.p":U then do:
                        run dibo/bodi300.p persistent set hDBOItem-dist.
                    end.
                
                    run openQueryStatic in hDBOItem-dist (input "default":U) no-error.
                
                    run goToKey in hDBOItem-dist(input tt-item-dist.it-codigo).
                    run emptyRowErrors in hDBOItem-dist.
                    run setRecord in hDBOItem-dist (input table tt-item-dist).
                    run deleteRecord in hDBOItem-dist.
                    if return-value <> "ok" then do:    
                        run getRowErrors in hDBOItem-dist(output table RowErrors).
                        if can-find(first RowErrors
                                    where RowErrors.ErrorType <> "INTERNAL":U no-lock) then do:
            
                            for each RowErrors:
            
                                create tt-erro.
                                assign tt-erro.i-sequen = i-sequencia + 1
                                       tt-erro.cd-erro  = RowErrors.ErrorNumber
                                       tt-erro.mensagem = RowErrors.ErrorDescription
                                       i-sequencia      = i-sequencia + 1.
                
                            end.
                
                            undo, return "NOK":U.
                        end.
                    end.
                    
                    /* 4- Deleta Item-Mat - Logistica */
                    if not valid-handle(hDBOItem-mat) or
                        hDBOItem-mat:type <> "PROCEDURE":U or
                        hDBOItem-mat:file-name <> "inbo/boin667.p":U then do:
                        run inbo/boin667.p persistent set hDBOItem-mat.
                    end.
                
                    run openQueryStatic in hDBOItem-mat (input "Main":U) no-error.
                
                    run goToKey in hDBOItem-mat(input tt-item-mat-aux.it-codigo).
                    run emptyRowErrors in hDBOItem-mat.
                    run setRecord in hDBOItem-mat (input table tt-item-mat-aux).
                    run deleteRecord in hDBOItem-mat.
                    if return-value <> "ok" then do:    
                        run getRowErrors in hDBOItem-mat(output table RowErrors).
                        if can-find(first RowErrors
                                    where RowErrors.ErrorType <> "INTERNAL":U no-lock) then do:
            
                            for each RowErrors:
            
                                create tt-erro.
                                assign tt-erro.i-sequen = i-sequencia + 1
                                       tt-erro.cd-erro  = RowErrors.ErrorNumber
                                       tt-erro.mensagem = RowErrors.ErrorDescription
                                       i-sequencia      = i-sequencia + 1.
                
                            end.
                
                            undo, return "NOK":U.
                        end.
                    end.
       
                    /* Cria Ref-Item */
                    if avail tt-ref-item then do:
                        if not valid-handle(hDBORef-item) or
                            hDBORef-item:type <> "PROCEDURE":U or
                            hDBORef-item:file-name <> "inbo/boin375.p":U then do:
                            run inbo/boin375.p persistent set hDBORef-item.
                        end.
                    
                        run openQueryStatic in hDBORef-item (input "Main":U) no-error.
                    
                        run goToKey in hDBORef-item(input tt-ref-item.it-codigo,
                                                    input tt-ref-item.cod-refer).
                        run emptyRowErrors in hDBORef-item.
                        run setRecord in hDBORef-item (input table tt-ref-item).
                        run deleteRecord in hDBORef-item.
                        if return-value <> "ok" then do:    
                            run getRowErrors in hDBORef-item(output table RowErrors).
                            if can-find(first RowErrors
                                        where RowErrors.ErrorType <> "INTERNAL":U no-lock) then do:
                    
                                for each RowErrors:
                
                                    create tt-erro.
                                    assign tt-erro.i-sequen = i-sequencia + 1
                                           tt-erro.cd-erro  = RowErrors.ErrorNumber
                                           tt-erro.mensagem = RowErrors.ErrorDescription
                                           i-sequencia      = i-sequencia + 1.
                    
                                end.
                    
                                undo, return "NOK":U.
                            end.
                        end.
                    end.
            
                end.
            end.
        end.
    end.    
    
    if valid-handle(hDBOItem) THEN DO:
       run destroy in hDBOItem.

    END.
   
    if valid-handle(hDBORef-item) THEN DO:
        run destroy in hDBORef-item.

    END.

    if valid-handle(hDBOItem-man) THEN DO:
        run destroy in hDBOItem-man.

    END.

    if valid-handle(hDBOItem-cota) THEN DO:         /* Logistica */
        run destroy in hDBOItem-cota.

    END.

    if valid-handle(hDBOItem-dist) THEN DO:         /* Logistica */
        run destroy in hDBOItem-dist.

    END.
    if valid-handle(hDBOItem-mat) then DO:         /* Logistica */
        run destroy in hDBOItem-mat.

    END.

    if valid-handle(hDBOItem-uni-estab) THEN DO:    /* Logistica */
        run destroy in hDBOItem-uni-estab.

    END.

return "ok":u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-receiveMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveMessage Procedure 
PROCEDURE receiveMessage :
/*------------------------------------------------------------------------------
  Purpose: RECEBE A MENSAGEM DO CONTROL BROKER E PROCESSA A MESMA PARA ENTREGAR AO DESTinO
  Parameters: pinputXml, poutputXml
  Notes:       
------------------------------------------------------------------------------*/

    /* ParÉmetros de entrada e de sa°da */
    def input  param hinputXML  as handle no-undo.
    def output param houtputXML as handle no-undo.

    /* Vari†veis locais */      
    /* def var hGenXml             as handle no-undo.
    def var cReturnValue        as char   no-undo.
    def var hBusinessContent    as handle no-undo.
    def var lSuccessProcess     as log    no-undo.
    def var cValue              as char   no-undo.
    def var cNodeName           as char   no-undo.
    def var iIdList             as int    no-undo.
    def var iIdLine             as int    no-undo.
    def var iIdNext             as int    no-undo.
    def var cTranEvent          as char   no-undo.
    def var cTranVersion        as char   no-undo.
    def var cErrorText          as char   no-undo.
    def var iCount              as int    no-undo.
    def var cListRootSon        as char   no-undo.
    def var iContRootSon        as int    no-undo.
    def var hMessageHandler     as handle no-undo.
    def var cTranAction         as char   no-undo.*/

    /* Verifica se MessageHandler.p est† na mem¢ria */
    {xmlinc/xmlloadmessagehandlerrec.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue" &MHReturnError="houtputXML"}

    /* Verifica se o MessageHandler foi executado corretamente */
    if cReturnValue <> "OK":U then  
        if cReturnValue <> ? and  
           cReturnValue <> "" then  
            run setError in hMessageHandler (input 0,
                                             input "enviroment_error":U,
                                             input cReturnValue).

    /* Faz a interpretaá∆o e alguns processos na mensagem que recebe */
    run parseMessage in hMessageHandler (input  hinputXml,
                                         input "{&XmlTranName}",
                                         input "{&XmlMaxTranVersion}",
                                         input "{&XmlMinTranVersion}",
                                         input 
                                         &if defined (XmlListOfEvents) <> 0 &then
                                             "{&XmlListOfEvents}",
                                         &else
                                             "",
                                         &endif
                                         output lSuccessProcess,
                                         output cTranAction,
                                         output cTranEvent,
                                         output cTranVersion,
                                         output houtputXML ).

    /* Se n∆o processou corretamente, retorna erro */
    if not lSuccessProcess or 
        return-value <> "OK" then do:

        if cReturnValue <> ? and 
           cReturnValue <> " " then do:
            run setError in hMessageHandler (input 0,
                                             input "enviroment_error":U,
                                             input cReturnValue).
        end.

    end.
    else do:
        /* Obtem a parte da mensagem que est† abaixo do elemento BusinessContent */
        run getBusinessContent in hMessageHandler (output hBusinessContent).

        /* Verifica se XMLAPI est† na mem¢ria */
        {xmlinc/xmlloadgenxmlrec.i &GenXml="hGenXml" &GXReturnValue="cReturnValue" &GXReturnError="houtputXML"}
       
        /* Verifica se o ut-genxml foi iniciado corretamente */
        if cReturnValue <> "OK":U then  
            if cReturnValue <> ? and  
               cReturnValue <> "" then do:
                delete object hBusinessContent no-error.
                run setError in hMessageHandler (input 0,
                                                 input "enviroment_error":U,
                                                 input cReturnValue).
            end.

        /* Limpa as temp-tables internas da API XML */
        run reset in hGenXml.

        /* Carrega a estrutura filha de BusinessContent */
        run loadXml in hGenXml (hBusinessContent).    

        /* Elimina a mensagem obtida no mÇtodo getBusinessContent */
        delete object hBusinessContent no-error.

        /* Cria um registro para receber os valores dos filhos do elemento raiz (Upsert ou Delete) */
        empty temp-table tt-erro.

        create tt-item.
        assign tt-item.char-1 = ""
               tt-item.log-1  = YES.
        assign i-sequencia = 0.

        /* informaá‰es existentes na tag Item */
        run getSonVal in hGenXml (input 1, input "ItemCode":U, output tt-item.it-codigo).
        /* para as tabelas de logistica - Numa alteraá∆o o XML n∆o envia todos os dados. E os que nao estiverem preenchidos
           s∆o alterados para branco. Por isso, numa alteracao, esta sendo feita a busca das informacoes da tabela que esta na 
           base de dados. Em seguida sao sobrepostas as informacoes que vieram no XML */
 
        if cTranAction = "upd":u OR cTranAction = "del" THEN DO:
           
           FIND FIRST ITEM WHERE ITEM.it-codigo = tt-item.it-codigo NO-LOCK NO-ERROR.
           IF AVAIL ITEM THEN
              BUFFER-COPY ITEM TO tt-item
                  ASSIGN tt-item.r-rowid = ROWID(ITEM).
           
           FIND FIRST item-cota WHERE item-cota.it-codigo = tt-item.it-codigo NO-LOCK NO-ERROR.
           IF AVAIL item-cota THEN DO:
              CREATE tt-item-cota.
              BUFFER-COPY item-cota TO tt-item-cota
                  ASSIGN tt-item-cota.r-rowid = ROWID(item-cota).
           END.

           FIND FIRST item-mat WHERE item-mat.it-codigo = tt-item.it-codigo NO-LOCK NO-ERROR.
           IF AVAIL item-mat THEN DO:
              CREATE tt-item-mat-aux.
              BUFFER-COPY item-mat TO tt-item-mat-aux
                  ASSIGN tt-item-mat-aux.r-rowid = ROWID(item-mat).
           END.

           FIND FIRST item-dist WHERE item-dist.it-codigo = tt-item.it-codigo NO-LOCK NO-ERROR.
           IF AVAIL item-dist THEN DO:
              CREATE tt-item-dist.
              BUFFER-COPY item-dist TO tt-item-dist
                  ASSIGN tt-item-dist.r-rowid = ROWID(item-dist).
           END.

           FIND FIRST item-uni-estab
                WHERE item-uni-estab.it-codigo = tt-item.it-codigo NO-LOCK NO-ERROR.
           IF AVAIL item-uni-estab THEN DO:
              CREATE tt-item-uni-estab.
              BUFFER-COPY item-uni-estab TO tt-item-uni-estab
                  ASSIGN tt-item-uni-estab.r-rowid = ROWID(item-uni-estab).
           END.

        END.
        run getSonVal in hGenXml (input 1, input "ItemDescription":U, output tt-item.desc-item).
        run getSonVal in hGenXml (input 1, input "ItemClassification":U, output c-classificacao).

        run searchTag in hGenXml ("MaterialFamily":U, 1, output iMaterialFamilyId).
        if iMaterialFamilyId <> ? THEN DO:
            run getSonVal  in hGenXml (input iMaterialFamilyId, input "MaterialFamilyCode":U, output tt-item.fm-codigo).
        END.
        ELSE
            ASSIGN tt-item.fm-codigo = "".

        if cTranAction = "add":u THEN DO:
            FIND FIRST familia NO-LOCK
                 WHERE familia.fm-codigo = tt-item.fm-codigo NO-ERROR.
            IF AVAIL familia THEN DO:
               BUFFER-COPY familia EXCEPT log-1 TO tt-item.
            END.

            FIND FIRST familia-mat NO-LOCK
                 WHERE familia-mat.fm-codigo = familia.fm-codigo NO-ERROR.
        END.
               
        IF c-classificacao <> ? THEN
        &if defined(bf_man_206) &then
            assign tt-item.idi-classif-item = int(c-classificacao).
        &else
            assign substring(tt-item.char-1,19,1) = c-classificacao.
        &endif

        run searchTag in hGenXml ("inventoryGroup":U, 1, output iInventoryGroupId).
        if iinventoryGroupId <> ? then
            run getSonVal  in hGenXml (input iInventoryGroupId, input "inventoryGroupCode":U, output tt-item.ge-codigo).
        
        run searchTag in hGenXml ("UnitOfMeasure":U, 1, output iUnitOfMeasureId).
        if iUnitOfMeasureId <> ? then
            run getSonVal  in hGenXml (input iUnitOfMeasureId, input "UnitOfMeasureCode":U, output tt-item.un).
        
        run searchTag in hGenXml ("DefaultSite":U, 1, output iDefaultSiteId).
        if iDefaultSiteId <> ? then
            run getSonVal  in hGenXml (input iDefaultSiteId, input "DefaultSiteCode":U, output tt-item.cod-estabel).
        
        run getSonDate in hGenXml (input 1, input "DateAddition":U, output dt-implant).
        if dt-implant = ? then
            assign tt-item.data-implant = today.
        else
            assign tt-item.data-implant = dt-implant.

        run getSonDate in hGenXml (input 1, input "ReleaseDate":U, output dt-liberac).
        if dt-liberac = ? then
            assign tt-item.data-liberac = today.
        else
            assign tt-item.data-liberac = dt-liberac.

        run getSonDec  in hGenXml (input 1, input "ItemStatus":U, output i-status).
        if i-status >= 1 and
           i-status <= 4 then
            assign tt-item.cod-obsoleto = i-status.
        else
            assign tt-item.cod-obsoleto = 1.

        run getSonLog  in hGenXml (input 1, input "IsIssueinventory":U, output l-baixa-estoq).
        if l-baixa-estoq = ? then
            assign tt-item.baixa-estoq = yes.
        else
            assign tt-item.baixa-estoq = l-baixa-estoq.

        run searchTag in hGenXml ("Commercialinventory":U, 1, output iCommercialinventoryId).
        if iCommercialinventoryId <> ? then
            run getSonVal  in hGenXml (input iCommercialinventoryId, input "CommercialinventoryCode":U, output tt-item.fm-cod-com).

        {adapters/xml/ma2/axrma005.i02} /*include Manufatura   */           

        /*{adapters/xml/ma2/axrma005.i01} /*include Logistica  1 */*/

        RUN pi-xml-log.

        run cria-pi-valida.
       
        IF cTranAction <> "del":u THEN DO: /*valida apenas na inclusao e modificacao*/

            /* -----   Validacoes Tables Logistica   ----- */
            if not valid-handle(h-boin172log) or
                h-boin172log:type <> "PROCEDURE":U or
                h-boin172log:file-name <> "inbo/boin172log.p":U then do:
                run inbo/boin172log.p persistent set h-boin172log.
            end.
            
            RUN pi-valida-item  IN h-boin172log (input  table tt-item,
                                                 input  iInvestmentAccountId         ,
                                                 input  iExpenseNatureId             ,
                                                 input  iExpenseTypeId               ,
                                                 input  iQualityControlInformationId ,
                                                 input  iPurchaseControlInformationId,
                                                 input  iBuyerId                     ,
                                                 input  iFiscalInformationId         ,
                                                 input  iFiscalClassificationId      ,
                                                 input  iBrazilianTaxesId            ,
                                                 input  iServiceTypeId               ,
                                                 output TABLE rowErrors).
            FOR EACH rowErrors:
                create tt-erro.
                assign tt-erro.i-sequen = i-sequencia + 1
                       tt-erro.cd-erro  = RowErrors.ErrorNumber
                       tt-erro.mensagem = RowErrors.ErrorDescription
                       i-sequencia      = i-sequencia + 1.
            END.
            
            
            RUN pi-valida-item-mat-aux IN h-boin172log (input  table tt-item-mat-aux,
                                                        input  iPurchaseControlInformationId ,
                                                        input  iManagerSiteId                ,
                                                        input  iPurchaseGroupId              ,
                                                        input  iInventoryInformationId       ,
                                                        input  iReplenishmentId              ,
                                                        input  iSupplyFrequencyId            ,
                                                        input  iWeightingFormulasId          ,
                                                        input  iInventoryCountingId          ,
                                                        input  iListOfWeightFactorsId        ,
                                                        input  iWeightFactorId               ,
                                                        input  iFiscalInformationId          ,
                                                        input  iTaxId                        ,
                                                        output TABLE rowErrors).
            FOR EACH rowErrors:
                create tt-erro.
                assign tt-erro.i-sequen = i-sequencia + 1
                       tt-erro.cd-erro  = RowErrors.ErrorNumber
                       tt-erro.mensagem = RowErrors.ErrorDescription
                       i-sequencia      = i-sequencia + 1.
            END.
    
            if valid-handle(h-boin172log) then
                delete procedure h-boin172log.
            /* --- Final das Validacoes Tables Logistica --- */
        END.
    end.

    
    if cTranAction = "add":u then
        run piCriaItem.
    else do:
        if cTranAction = "upd":u then
            run piAlteraItem.
        else
            run piExcluiItem.
    end.

    for each tt-erro where tt-erro.mensagem = "" no-lock:
        CASE tt-erro.cd-erro:
            WHEN 8 THEN DO:
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Item" *}
                run utp/ut-msgs.p (input "msg",
                                   input tt-erro.cd-erro,
                                   INPUT RETURN-VALUE).
                assign tt-erro.mensagem = return-value.
            END. 
            WHEN 36488 THEN DO:
                FIND FIRST bfitem 
                     WHERE bfitem.it-codigo = tt-item.it-codigo NO-LOCK NO-ERROR.
                run utp/ut-msgs.p (input "msg",
                                   input tt-erro.cd-erro,
                                   INPUT bfItem.un + "~~" + tt-item.un).
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-unidade-de-medida AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Unidade_de_medida" *}
                ASSIGN c-lbl-liter-unidade-de-medida = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-nao-pode-ser-alterada-para AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "n∆o_pode_ser_alterada_para" *}
                ASSIGN c-lbl-liter-nao-pode-ser-alterada-para = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-pois-item-possui-movimentacaoo AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "pois_item_possui_movimentaá∆oo_de_estoque" *}
                ASSIGN c-lbl-liter-pois-item-possui-movimentacaoo = TRIM(RETURN-VALUE).
                assign tt-erro.mensagem = c-lbl-liter-unidade-de-medida + " " + bfItem.un + " " + c-lbl-liter-nao-pode-ser-alterada-para + " " + tt-item.un + ", " + c-lbl-liter-pois-item-possui-movimentacaoo + ".".
            END. 
            WHEN 7972 THEN DO:
                FIND FIRST bfitem 
                     WHERE bfitem.it-codigo = tt-item.it-codigo NO-LOCK NO-ERROR.
                IF AVAIL bfitem THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-o-grupo-de-estoque AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "O_Grupo_de_Estoque" *}
                    ASSIGN c-lbl-liter-o-grupo-de-estoque = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-do-item AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "do_Item" *}
                    ASSIGN c-lbl-liter-do-item = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-alterado-para-o-grupo-de-estoq AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "alterado_para_o_Grupo_de_Estoque" *}
                    ASSIGN c-lbl-liter-alterado-para-o-grupo-de-estoq = TRIM(RETURN-VALUE).
                    run utp/ut-msgs.p (input "msg",
                                       input tt-erro.cd-erro,
                                       INPUT c-lbl-liter-o-grupo-de-estoque + " " + string(bfitem.ge-codigo) + " " + c-lbl-liter-do-item + " " + tt-item.it-codigo + "~~" + c-lbl-liter-alterado-para-o-grupo-de-estoq + " " + STRING(tt-item.ge-codigo)).
                    assign tt-erro.mensagem = return-value.
                END.
            END.
            WHEN 17006 THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-familia-comercial-nao-cadastra AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Fam°lia_comercial_n∆o_cadastrada" *}
                ASSIGN c-lbl-liter-familia-comercial-nao-cadastra = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-familia-comercial AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Fam°lia_comercial" *}
                ASSIGN c-lbl-liter-familia-comercial = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-do-item-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "do_Item" *}
                ASSIGN c-lbl-liter-do-item-2 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-nao-cadastrada AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "n∆o_cadastrada" *}
                ASSIGN c-lbl-liter-nao-cadastrada = TRIM(RETURN-VALUE).
                run utp/ut-msgs.p (input "msg",
                                   input tt-erro.cd-erro,
                                   INPUT c-lbl-liter-familia-comercial-nao-cadastra + "!" + "~~"
                                         + c-lbl-liter-familia-comercial + "  " + string(tt-item.fm-cod-com) + " " + c-lbl-liter-do-item-2 + " " + tt-item.it-codigo + " " + c-lbl-liter-nao-cadastrada + ".").
                assign tt-erro.mensagem = return-value.
            END.
            WHEN 34583 THEN DO:
                run utp/ut-msgs.p (input "msg",
                                   input tt-erro.cd-erro,
                                   INPUT tt-item.it-codigo).
                assign tt-erro.mensagem = return-value.
            END.
            WHEN 34584 THEN DO:
                run utp/ut-msgs.p (input "msg",
                                   input tt-erro.cd-erro,
                                   INPUT tt-item.fm-codigo + "~~" + tt-item.it-codigo).
                assign tt-erro.mensagem = return-value.

            END.
            WHEN 2802 THEN DO:
                run utp/ut-msgs.p (input "msg",
                                   input tt-erro.cd-erro,
                                   INPUT tt-item.it-codigo).
                assign tt-erro.mensagem = return-value.
            END.
            WHEN 2227 THEN DO:
                run utp/ut-msgs.p (input "msg",
                                   input tt-erro.cd-erro,
                                   INPUT tt-item.it-codigo).
                assign tt-erro.mensagem = return-value.
            END.
            WHEN 18026 THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-a-unidade-de-medida AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "A_Unidade_de_Medida" *}
                ASSIGN c-lbl-liter-a-unidade-de-medida = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-do-item-3 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "do_Item" *}
                ASSIGN c-lbl-liter-do-item-3 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-unidade-de-medida-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Unidade_de_Medida" *}
                ASSIGN c-lbl-liter-unidade-de-medida-2 = TRIM(RETURN-VALUE).
                run utp/ut-msgs.p (input "msg",
                                           input tt-erro.cd-erro,
                                           INPUT c-lbl-liter-a-unidade-de-medida + " " + item.un + " " + c-lbl-liter-do-item-3 + " " + tt-item.it-codigo + "~~" + c-lbl-liter-unidade-de-medida-2 + " " + tt-item.un).
                assign tt-erro.mensagem = return-value.
            END.
            WHEN 2763 THEN DO:
                run utp/ut-msgs.p (input "msg",
                                   input tt-erro.cd-erro,
                                   INPUT tt-item.it-codigo).
                assign tt-erro.mensagem = return-value.
            END.
            WHEN 28627 THEN DO:
                run utp/ut-msgs.p (input "msg",
                                   input tt-erro.cd-erro,
                                   INPUT tt-item.fm-codigo + "~~" + tt-item.it-codigo).
                assign tt-erro.mensagem = return-value.
            END.
            WHEN 47 THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-unidade-de-medida-3 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Unidade_de_Medida" *}
                ASSIGN c-lbl-liter-unidade-de-medida-3 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-do-item-4 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "do_Item" *}
                ASSIGN c-lbl-liter-do-item-4 = TRIM(RETURN-VALUE).
                run utp/ut-msgs.p (input "msg",
                                   input tt-erro.cd-erro,
                                   INPUT c-lbl-liter-unidade-de-medida-3 + " " + tt-item.un + " " + c-lbl-liter-do-item-4 + " " + tt-item.it-codigo).
                assign tt-erro.mensagem = return-value.
                
            END.
            WHEN 26435 THEN DO:
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "do_Item" *}
                run utp/ut-msgs.p (input "msg",
                                   input tt-erro.cd-erro,
                                   INPUT tt-item.fm-codigo + " " + RETURN-VALUE + " " + tt-item.it-codigo).
                assign tt-erro.mensagem = return-value.
            END.
            OTHERWISE DO:
                run utp/ut-msgs.p (input "msg",
                                   input tt-erro.cd-erro,
                                   input "").
                assign tt-erro.mensagem = return-value.
            END.
        END CASE.

    end.

    for each tt-erro no-lock:

        {utp/ut-liter.i "Erro de integraá∆o. Durante sua execuá∆o ocorreu o(s) seguinte(s) erro(s) de Progress:"}
        run setError in hMessageHandler (input tt-erro.cd-erro,
                                         input "business_error":U,  /* Erro de neg¢cio */
                                         input return-value + tt-erro.mensagem).
    end.

    /* Obtem mensagem de retorno (erro ou confirmacao) */
    run getReturnMessage in hMessageHandler (output houtputXML). 

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
{adapters/xml/ma2/axrma005.i01} /*include Logistica  1 */


&IF DEFINED(EXCLUDE-receiveMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-item-cd0204k Procedure 
PROCEDURE pi-atualiza-item-cd0204k:

    FOR EACH tt-old-item:
        DELETE tt-old-item.
    END.

    CREATE tt-old-item.
    BUFFER-COPY tt-item TO tt-old-item.

    FOR EACH tt-estabel:
        DELETE tt-estabel.
    END.

    FOR EACH item-uni-estab  NO-LOCK
       WHERE item-uni-estab.it-codigo = tt-item.it-codigo:
        IF NOT CAN-FIND(FIRST tt-estabel 
                        WHERE tt-estabel.cod-estabel = item-uni-estab.cod-estabel) THEN DO:
           CREATE tt-estabel.
           ASSIGN tt-estabel.cod-estabel = item-uni-estab.cod-estabel
                  tt-estabel.log-exporta = YES.
        END.
    END.
    
    run cdp/cd0204k.p (input tt-item.it-codigo,
                       input "M", /* Modificacao */
                       input NO,
                       input NO,
                       input YES,
                       input table tt-estabel,
                       input table tt-old-item).

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
