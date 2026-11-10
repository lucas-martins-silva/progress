/******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/******************************************************************************
* Include : adapters/xml/ep2/axsep001.i 
*  Autor  : DATASUL S.A.
*******************************************************************************/

/***Definiá∆o da Temp-Table Documento Importaá∆o***/
DEFINE TEMP-TABLE ttImportDocument NO-UNDO
     FIELD ImportDocumentSiteID            AS CHARACTER INITIAL ?  /*Codigo Estabelecimento - chave it-nota-fisc */
     FIELD ImportDocumentSeries            AS CHARACTER INITIAL ?  /*SÇrie - chave it-nota-fisc */
     FIELD ImportDocumentInvoiceNumber     AS CHARACTER INITIAL ?  /*Nr Nota Fiscal - chave it-nota-fisc */
     FIELD ImportDocumentItemCode          AS CHARACTER INITIAL ?  /*Codigo Item - chave it-nota-fisc */
     FIELD ImportDocumentItemSequence      AS INTEGER   INITIAL ?  /*Sequencia do Item - chave it-nota-fisc */
     FIELD ImportDocumentNumber            AS CHARACTER INITIAL ?  /*N£mero Documento Importaá∆o*/
     FIELD ImportDocumentDate              AS DATE      INITIAL ?  /*Data de Registro*/
     FIELD ImportDocumentClearanceLocation AS CHARACTER INITIAL ?  /*Local de Desembaraáo Aduaneiro*/
     FIELD ImportDocumentClearanceState    AS CHARACTER INITIAL ?  /*Estado do Desembaraáo Aduaneiro*/
     FIELD ImportDocumentClearanceDate     AS DATE      INITIAL ?  /*Data do Desembaraáo Aduaneiro*/
     FIELD ImportDocumentExporterCode      AS CHARACTER INITIAL ?  /*C¢digo do Exportador*/
     FIELD ImportCustomsValue              AS DECIMAL   INITIAL ?  /*Valor das despesas aduaneiras*/
     FIELD ImportFinancialOperationTax     AS DECIMAL   INITIAL ?. /*Valor do Imposto sobre Operaá‰es Financeiras*/

/*******************************************************************************/

/***Definiá∆o da Temp-Table Adiá‰es Documento Importaá∆o***/
DEFINE TEMP-TABLE ttImportDocumentAdd NO-UNDO
     FIELD ImportDocumentSiteID            AS CHARACTER INITIAL ?  /*Codigo Estabelecimento - chave it-nota-fisc */
     FIELD ImportDocumentSeries            AS CHARACTER INITIAL ?  /*SÇrie - chave it-nota-fisc */
     FIELD ImportDocumentInvoiceNumber     AS CHARACTER INITIAL ?  /*Nr Nota Fiscal - chave it-nota-fisc */
     FIELD ImportDocumentItemCode          AS CHARACTER INITIAL ?  /*Codigo Item - chave it-nota-fisc */
     FIELD ImportDocumentItemSequence      AS INTEGER   INITIAL ?  /*Sequencia do Item - chave it-nota-fisc */
     FIELD ImportDocumentAddNumber         AS INTEGER   INITIAL ?  /*N£mero da Adiá∆o*/
     FIELD ImportDocumentAddSequence       AS INTEGER   INITIAL ?  /*SeqÅància do Item dentro da Adiá∆o*/
     FIELD ImportDocumentManufacturerID    AS CHARACTER INITIAL ?  /*C¢digo do Fabricante Estrangeiro*/
     FIELD ImportDocumentDiscount          AS DECIMAL   INITIAL ?. /*Valor do Desconto do Item da Adiá∆o*/

/*******************************************************************************/

/***Definiá∆o da Temp-Table Ve°culos***/
DEFINE TEMP-TABLE ttDocumentItemVehicle NO-UNDO
     FIELD VehicleSiteID               AS CHARACTER INITIAL ?  /*Codigo Estabelecimento - chave it-nota-fisc */
     FIELD VehicleDocumentSeries       AS CHARACTER INITIAL ?  /*SÇrie - chave it-nota-fisc */
     FIELD VehicleDocumentNumber       AS CHARACTER INITIAL ?  /*Nr Nota Fiscal - chave it-nota-fisc */
     FIELD VehicleItemCode             AS CHARACTER INITIAL ?  /*Codigo Item - chave it-nota-fisc */
     FIELD VehicleItemSequence         AS INTEGER   INITIAL ?  /*Sequencia do Item - chave it-nota-fisc */
     FIELD VehicleTypeOperation        AS INTEGER   INITIAL ?  /*Tipo da Operaá∆o*/
     FIELD VehicleID                   AS CHARACTER INITIAL ?  /*Chassi do Ve°culo*/
     FIELD VehicleColorID              AS CHARACTER INITIAL ?  /*C¢digo da Cor do Ve°culo*/
     FIELD VehicleColorName            AS CHARACTER INITIAL ?  /*Descriá∆o da Cor*/
     FIELD VehicleMotorPower           AS CHARACTER INITIAL ?  /*Potància do Motor*/
     FIELD VehiclePower                AS CHARACTER INITIAL ?  /*CM3 Potància*/
     FIELD VehicleNetWeight            AS CHARACTER INITIAL ?  /*Peso L°quido*/
     FIELD VehicleGrossWeight          AS CHARACTER INITIAL ?  /*Peso Bruto*/
     FIELD VehicleSerialNumber         AS CHARACTER INITIAL ?  /*SÇrie*/
     FIELD VehicleFuel                 AS CHARACTER INITIAL ?  /*Tipo de Combust°vel*/
     FIELD VehicleMotorNumber          AS CHARACTER INITIAL ?  /*N£mero do Motor*/
     FIELD VehicleCMKG                 AS CHARACTER INITIAL ?  /*CMKG*/
     FIELD VehicleDistance             AS CHARACTER INITIAL ?  /*DistÉncia Entre Eixos*/                                       
     FIELD VehicleRENAVAN              AS CHARACTER INITIAL ?  /*RENAVAN*/
     FIELD VehicleModelYear            AS INTEGER   INITIAL ?  /*Ano Modelo Fabricaá∆o*/                                            
     FIELD VehicleFabricatedYear       AS INTEGER   INITIAL ?  /*Ano de Fabricaá∆o*/ 
     FIELD VehiclePaintID              AS CHARACTER INITIAL ?  /*Tipo de Pintura*/                                                       
     FIELD VehicleType                 AS INTEGER   INITIAL ?  /*Tipo de Ve°culo*/                                                    
     FIELD VehicleEspecie              AS INTEGER   INITIAL ?  /*EspÇcie de Ve°culo*/                  
     FIELD VehicleIdentificationNumber AS CHARACTER INITIAL ?  /*VIN (Vehicle Identification Number)*/                                    
     FIELD VehicleCondition            AS INTEGER   INITIAL ?  /*Condiá∆o do Ve°culo (1 - Acabado, 2 - Inacabado, 3 - Semi-acabado)*/                            
     FIELD VehicleModel                AS INTEGER   INITIAL ?. /*C¢digo Marca Modelo*/  

/*******************************************************************************/

/***Definiá∆o da Temp-Table Medicamentos***/
DEFINE TEMP-TABLE ttDocumentItemMedicine  NO-UNDO
    FIELD MedicineSiteID           AS CHARACTER INITIAL ?  /*Codigo Estabelecimento - chave it-nota-fisc */
    FIELD MedicineDocumentSeries   AS CHARACTER INITIAL ?  /*SÇrie - chave it-nota-fisc */
    FIELD MedicineDocumentNumber   AS CHARACTER INITIAL ?  /*Nr Nota Fiscal - chave it-nota-fisc */
    FIELD MedicineItemCode         AS CHARACTER INITIAL ?  /*Codigo Item - chave it-nota-fisc */
    FIELD MedicineItemSequence     AS INTEGER   INITIAL ?  /*Sequencia do Item - chave it-nota-fisc */
    FIELD MedicineLotNumber        AS CHARACTER INITIAL ?  /*N£mero do Lote do Medicamento*/
    FIELD MedicineQuantity         AS DECIMAL   INITIAL ?  /*Quantidade de produto no lote do medicamento */
    FIELD MedicineFabricatedDate   AS DATE      INITIAL ?  /*Data de fabricaá∆o*/
    FIELD MedicineValidityDate     AS DATE      INITIAL ?  /*Data de validade  */
    FIELD MedicineMaxConsumerPrice AS DECIMAL   INITIAL ?. /*Preáo m†ximo consumidor*/
      
/*******************************************************************************/

/***Definiá∆o da Temp-Table Combust°veis***/
DEFINE TEMP-TABLE ttDocumentItemFuel NO-UNDO 
     FIELD FuelSiteID                      AS CHARACTER INITIAL ?  /*Codigo Estabelecimento - chave it-nota-fisc */
     FIELD FuelDocumentSeries              AS CHARACTER INITIAL ?  /*SÇrie - chave it-nota-fisc */
     FIELD FuelDocumentNumber              AS CHARACTER INITIAL ?  /*Nr Nota Fiscal - chave it-nota-fisc */
     FIELD FuelItemCode                    AS CHARACTER INITIAL ?  /*Codigo Item - chave it-nota-fisc */
     FIELD FuelItemSequence                AS INTEGER   INITIAL ?  /*Sequencia do Item - chave it-nota-fisc */
     FIELD FuelID                          AS INTEGER   INITIAL ?  /*C¢digo de produto da ANP*/
     FIELD FuelCODIF                       AS INTEGER   INITIAL ?  /*C¢digo autorizaá∆o/registro do CODIF*/
     FIELD FuelQuantity                    AS DECIMAL   INITIAL ?  /*Quantidade de combust°vel faturada Ö temperatura ambiente*/
     FIELD FuelCIDECalculationBasis        AS DECIMAL   INITIAL ?  /*Base de c†lculo da CIDE*/
     FIELD FuelCIDEPercentage              AS DECIMAL   INITIAL ?  /*Valor da al°quota da CIDE*/
     FIELD FuelCIDEValue                   AS DECIMAL   INITIAL ?  /*Valor da CIDE*/
     FIELD FuelICMSCalculationBasis        AS DECIMAL   INITIAL ?  /*Base de c†lculo do ICMS*/
     FIELD FuelICMSValue                   AS DECIMAL   INITIAL ?  /*Valor do ICMS*/
     FIELD FuelICMSSubstitutionBasis       AS DECIMAL   INITIAL ?  /*Base de c†lculo do ICMS ST retido*/
     FIELD FuelICMSSubstitutionValue       AS DECIMAL   INITIAL ?  /*Valor do ICMS ST retido*/
     FIELD FuelICMSFateSubstitutionBasis   AS DECIMAL   INITIAL ?  /*Base de c†lculo do ICMS ST da UF de destino*/
     FIELD FuelICMSFateSubstitutionValue   AS DECIMAL   INITIAL ?  /*Valor do ICMS ST da UF de destino*/                                       
     FIELD FuelICMSConsumSubstitutionBasis AS DECIMAL   INITIAL ?  /*Base de c†lculo do ICMS ST da UF de consumo*/
     FIELD FuelICMSConsumSubstitutionValue AS DECIMAL   INITIAL ?  /*Valor do ICMS ST da UF de consumo*/
     FIELD FuelConsumptionStateID          AS CHARACTER INITIAL ?. /*Sigla da UF de consumo*/
     
/*******************************************************************************/

/***Definiá∆o da Temp-Table Adicionais***/
DEFINE TEMP-TABLE ttInvoiceDocumentAddInformation NO-UNDO
     FIELD AdditionalInformation AS CHARACTER INITIAL ?  /*Informaá‰es Adicionais de Interesse do Fisco*/
     FIELD SupplementInformation AS CHARACTER INITIAL ?. /*Informaá‰es Complementares de Interesse do Contribuinte*/
     
/*******************************************************************************/

/***Definiá∆o da Temp-Table Uso Livre Contribuinte***/
DEFINE TEMP-TABLE ttAddInformationTaxPayer NO-UNDO
     FIELD TaxPayerCommentID      AS CHARACTER INITIAL ?  /*Identificaá∆o do Campo*/
     FIELD TaxPayerCommentContent AS CHARACTER INITIAL ?. /*Conte£do do Campo*/
     
/*******************************************************************************/

/***Definiá∆o da Temp-Table Uso Livre Fisco***/
DEFINE TEMP-TABLE ttAddInformationTaxComment NO-UNDO
     FIELD TaxCommentID      AS CHARACTER INITIAL ?  /*Identificaá∆o do Campo*/
     FIELD TaxCommentContent AS CHARACTER INITIAL ?. /*Conte£do do Campo*/
     
/*******************************************************************************/

/***Definiá∆o da Temp-Table Processo Referenciado***/
DEFINE TEMP-TABLE ttReferencedProcess NO-UNDO
     FIELD ProcessID       AS CHARACTER INITIAL ?  /*Identificaá∆o do processo*/
     FIELD ProcessOriginID AS INTEGER   INITIAL ?. /*Indicador da origem do processo (0 - SEFAZ, 1 - Justiáa Federal, 2 - Justiáa Estadual, 3 - Secex/RFB, 9 - Outros)*/
     
/*******************************************************************************/
/* Fim include axsep001.i */


















































































