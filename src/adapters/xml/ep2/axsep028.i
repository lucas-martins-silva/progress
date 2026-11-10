/*----------------------------------------------------------------------------------

    DEFINI€åES TEMP-TABLE

----------------------------------------------------------------------------------*/

DEFINE TEMP-TABLE ttDestNFCom NO-UNDO
     FIELD xNome              AS CHARACTER INITIAL ?
     FIELD CNPJ               AS CHARACTER INITIAL ?
     FIELD CPF                AS CHARACTER INITIAL ?
     FIELD idOutros           AS CHARACTER INITIAL ?
     FIELD indIEDest          AS CHARACTER INITIAL ?
     FIELD IE                 AS CHARACTER INITIAL ?
     FIELD IM                 AS CHARACTER INITIAL ?
     FIELD xLgr               AS CHARACTER INITIAL ?
     FIELD nro                AS CHARACTER INITIAL ?
     FIELD xCpl               AS CHARACTER INITIAL ?
     FIELD xBairro            AS CHARACTER INITIAL ?
     FIELD cMun               AS CHARACTER INITIAL ?
     FIELD xMun               AS CHARACTER INITIAL ?
     FIELD CEP                AS CHARACTER INITIAL ?
     FIELD UF                 AS CHARACTER INITIAL ?
     FIELD cPais              AS CHARACTER INITIAL ?
     FIELD xPais              AS CHARACTER INITIAL ?
     FIELD fone               AS CHARACTER INITIAL ?
     FIELD email              AS CHARACTER INITIAL ?
     FIELD i-natureza         AS INTEGER   INITIAL ?
     /*Chave EMS*/
     FIELD CodEstabelNFCom    AS CHARACTER INITIAL ?
     FIELD SerieNFCom         AS CHARACTER INITIAL ?
     FIELD NrNotaFisNFCom     AS CHARACTER INITIAL ?
     INDEX ch-ttDestNFCom IS PRIMARY UNIQUE CodEstabelNFCom SerieNFCom NrNotaFisNFCom.


DEFINE TEMP-TABLE ttAssinante NO-UNDO
     FIELD iCodAssinante   AS CHARACTER INITIAL ?
     FIELD tpAssinante     AS CHARACTER INITIAL ?
     FIELD tpServUtil      AS CHARACTER INITIAL ?
     FIELD nContrato       AS CHARACTER INITIAL ?
     FIELD dContratoIni    AS DATE      INITIAL ?
     FIELD dContratoFim    AS DATE      INITIAL ?
     
     /*Chave EMS*/
     FIELD CodEstabelNFCom    AS CHARACTER INITIAL ?
     FIELD SerieNFCom         AS CHARACTER INITIAL ?
     FIELD NrNotaFisNFCom     AS CHARACTER INITIAL ?
     INDEX ch-ttAssinanteNFCom IS PRIMARY UNIQUE CodEstabelNFCom SerieNFCom NrNotaFisNFCom.

DEFINE TEMP-TABLE ttgSub NO-UNDO
     FIELD chNFCom AS CHARACTER INITIAL ?
     FIELD motSub  AS CHARACTER INITIAL ?
      /*Chave EMS*/
     FIELD CodEstabelNFCom    AS CHARACTER INITIAL ?
     FIELD SerieNFCom         AS CHARACTER INITIAL ?
     FIELD NrNotaFisNFCom     AS CHARACTER INITIAL ?
     INDEX ch-ttgSubNFCom IS PRIMARY UNIQUE CodEstabelNFCom SerieNFCom NrNotaFisNFCom.
     
DEFINE TEMP-TABLE ttDetNFCom NO-UNDO
     FIELD cProd          AS CHARACTER INITIAL ?                                                
     FIELD xProd          AS CHARACTER INITIAL ?                                                
     FIELD cClass         AS CHARACTER INITIAL ?
     FIELD CFOP           AS CHARACTER INITIAL ?
     FIELD CNPJLD         AS CHARACTER INITIAL ?
     FIELD uMed           AS CHARACTER INITIAL ?
     FIELD qFaturada      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>9.99"    DECIMALS 4
     FIELD vItem          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 8
     FIELD vDesc          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2
     FIELD vOutro         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2
     FIELD vProd          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 8
     FIELD dExpiracao     AS DATE      INITIAL ?
     FIELD indDevolucao   AS CHAR      INITIAL ?
     FIELD indSemCST      AS CHAR      INITIAL ?
     FIELD infAdProd      AS CHARACTER INITIAL ? 
     FIELD CNPJCobrTerc   AS CHARACTER INITIAL ?
     /*Chave EMS*/
     FIELD CodEstabelNFCom   AS CHARACTER INITIAL ?
     FIELD SerieNFCom        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNFCom    AS CHARACTER INITIAL ?
     FIELD ItCodigoNFCom     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNFCom     AS INTEGER   INITIAL ?
     INDEX ch-ttDetNFCom CodEstabelNFCom SerieNFCom NrNotaFisNFCom NrSeqFatNFCom ItCodigoNFCom.


DEFINE TEMP-TABLE ttEmitNFCom NO-UNDO
     FIELD CNPJ               AS CHARACTER INITIAL ?
     FIELD IE                 AS CHARACTER INITIAL ?
     FIELD IEUFDest           AS CHARACTER INITIAL ?
     FIELD CRT                AS CHARACTER INITIAL ?
     FIELD xNome              AS CHARACTER INITIAL ?
     FIELD xFant              AS CHARACTER INITIAL ?
     FIELD xLgr               AS CHARACTER INITIAL ?
     FIELD nro                AS CHARACTER INITIAL ?
     FIELD xCpl               AS CHARACTER INITIAL ?
     FIELD xBairro            AS CHARACTER INITIAL ?
     FIELD cMun               AS CHARACTER INITIAL ?
     FIELD xMun               AS CHARACTER INITIAL ?
     FIELD CEP                AS CHARACTER INITIAL ?
     FIELD UF                 AS CHARACTER INITIAL ?
     FIELD fone               AS CHARACTER INITIAL ?
     FIELD email              AS CHARACTER INITIAL ?
	 FIELD ISUFemit           AS CHARACTER INITIAL ?
     /*Chave EMS*/
     FIELD CodEstabelNFCom    AS CHARACTER INITIAL ?
     FIELD SerieNFCom         AS CHARACTER INITIAL ?
     FIELD NrNotaFisNFCom     AS CHARACTER INITIAL ?
     FIELD VersaoLayout       AS CHARACTER INITIAL ?
     INDEX ch-ttEmitNFCom IS PRIMARY UNIQUE CodEstabelNFCom SerieNFCom NrNotaFisNFCom.


DEFINE TEMP-TABLE ttICMSTotNFCom NO-UNDO
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2
     FIELD vICMSDeson     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2
     FIELD vFCP           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2
     /*Chave EMS*/
     FIELD CodEstabelNFCom   AS CHARACTER INITIAL ?
     FIELD SerieNFCom        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNFCom    AS CHARACTER INITIAL ?
     INDEX ch-ttICMSTotNFCom IS PRIMARY UNIQUE CodEstabelNFCom SerieNFCom NrNotaFisNFCom.

     
DEFINE TEMP-TABLE ttIdeNFCom NO-UNDO
     FIELD cUF                AS CHARACTER INITIAL ?
     FIELD tpAmb              AS CHARACTER INITIAL ?
     FIELD mod                AS CHARACTER INITIAL ?
     FIELD serie              AS CHARACTER INITIAL ?
     FIELD nNF                AS CHARACTER INITIAL ?
     FIELD cNF                AS CHARACTER INITIAL ?
     FIELD cDV                AS CHARACTER INITIAL ?
     FIELD dhEmi              AS CHARACTER INITIAL ?
     FIELD tpEmis             AS CHARACTER INITIAL ?
     FIELD nSiteAutoriz       AS CHARACTER INITIAL ?
     FIELD cMunFG             AS CHARACTER INITIAL ?
     FIELD finNFCom           AS CHARACTER INITIAL ?
     FIELD tpFat              AS CHARACTER INITIAL ?
     FIELD verProc            AS CHARACTER INITIAL ?
     FIELD indPrePago         AS CHARACTER INITIAL ?
     FIELD indCessaoMeiosRede AS CHARACTER INITIAL ?
     FIELD dhCont             AS CHARACTER INITIAL ?
     FIELD xJust              AS CHARACTER INITIAL ?
     FIELD cUFCSRT            AS CHARACTER INITIAL ?
     FIELD siteQRCode         AS CHARACTER INITIAL ?
     FIELD tpPagAnt           AS CHARACTER INITIAL ?
     /*Chave EMS*/
     FIELD CodEstabelNFCom    AS CHARACTER INITIAL ?
     FIELD SerieNFCom         AS CHARACTER INITIAL ?
     FIELD NrNotaFisNFCom     AS CHARACTER INITIAL ?
     INDEX ch-ttIdeNFCom IS PRIMARY UNIQUE CodEstabelNFCom SerieNFCom NrNotaFisNFCom.

DEFINE TEMP-TABLE ttNFCom NO-UNDO
     /*Chave EMS*/
     FIELD CodEstabelNFCom    AS CHARACTER INITIAL ?
     FIELD SerieNFCom         AS CHARACTER INITIAL ?
     FIELD NrNotaFisNFCom     AS CHARACTER INITIAL ?
     FIELD ChaveAcessoNFCom   AS CHARACTER INITIAL ?
     FIELD VersaoLayoutNFCom  AS CHARACTER INITIAL ?
     INDEX ch-ttNFCom IS PRIMARY UNIQUE CodEstabelNFCom SerieNFCom NrNotaFisNFCom.
     
DEFINE TEMP-TABLE ttInfAdicNFCom NO-UNDO
     FIELD infAdFisco      AS CHARACTER INITIAL ?    /*Informa»„es adicionais de interesse do Fisco*/
     FIELD infCpl          AS CHARACTER INITIAL ?    /*Informa»„es complementares de interesse do Contribuinte*/
     /*Chave EMS*/
     FIELD CodEstabelNFCom AS CHARACTER INITIAL ?
     FIELD SerieNFCom      AS CHARACTER INITIAL ?
     FIELD NrNotaFisNFCom  AS CHARACTER INITIAL ?
     INDEX ch-ttInfAdicNFCom IS PRIMARY UNIQUE CodEstabelNFCom SerieNFCom NrNotaFisNFCom.     

DEFINE TEMP-TABLE ttgFatNFCom NO-UNDO   
     FIELD CompetFat          AS CHARACTER INITIAL ?
     FIELD dVencFat           AS DATE      INITIAL ?   
     FIELD codBarras          AS CHARACTER INITIAL ?
     /*Chave EMS*/
     FIELD CodEstabelNFCom    AS CHARACTER INITIAL ?
     FIELD SerieNFCom         AS CHARACTER INITIAL ?
     FIELD NrNotaFisNFCom     AS CHARACTER INITIAL ?     
INDEX ch-ttgFatNFCom IS PRIMARY UNIQUE CodEstabelNFCom SerieNFCom NrNotaFisNFCom.

DEFINE TEMP-TABLE ttTotal NO-UNDO
     FIELD vProd          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   
     FIELD vCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   
     FIELD vPIS           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   
     FIELD vFUNTTEL       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   
     FIELD vFUST          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 
     FIELD vDesc          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 
     FIELD vOutro         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 
     FIELD vNF            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 
     /*Chave EMS*/
     FIELD CodEstabelNFCom        AS CHARACTER INITIAL ?
     FIELD SerieNFCom             AS CHARACTER INITIAL ?
     FIELD NrNotaFisNFCom         AS CHARACTER INITIAL ?
     INDEX ch-ttTotalNFCom CodEstabelNFCom SerieNFCom NrNotaFisNFCom.      
     
DEFINE TEMP-TABLE ttRetTribTotNFCom NO-UNDO
     FIELD vIRRF          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Retido de IRRF*/    
     FIELD vRetCOFINS     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Retido de COFINS*/  
     FIELD vRetPIS        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Retido de PIS*/    
     FIELD vRetCSLL       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 
     /*Chave EMS*/
     FIELD CodEstabelNFCom   AS CHARACTER INITIAL ?
     FIELD SerieNFCom        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNFCom    AS CHARACTER INITIAL ?
     INDEX ch-ttRetTribTotNFCom IS PRIMARY UNIQUE CodEstabelNFCom SerieNFCom NrNotaFisNFCom.    
     
DEFINE TEMP-TABLE ttFust NO-UNDO  
     FIELD vBC           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do FUST */ 
     FIELD pFUST         AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Aliquota FUST */ 
     FIELD vFUST         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do FUST */ 
     /*Chave EMS*/
     FIELD CodEstabelNFCom   AS CHARACTER INITIAL ?
     FIELD SerieNFCom        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNFCom    AS CHARACTER INITIAL ?
     FIELD ItCodigoNFCom     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNFCom     AS INTEGER   INITIAL ? 
     INDEX ch-ttFust CodEstabelNFCom SerieNFCom NrNotaFisNFCom NrSeqFatNFCom ItCodigoNFCom.
     
DEFINE TEMP-TABLE ttFunttel NO-UNDO  
     FIELD vBC           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do FUNTTEL */ 
     FIELD pFUNTTEL      AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Aliquota FUNTTEL */ 
     FIELD vFUNTTEL      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do FUNTTEL */ 
     /*Chave EMS*/
     FIELD CodEstabelNFCom   AS CHARACTER INITIAL ?
     FIELD SerieNFCom        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNFCom    AS CHARACTER INITIAL ?
     FIELD ItCodigoNFCom     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNFCom     AS INTEGER   INITIAL ? 
     INDEX ch-ttFust CodEstabelNFCom SerieNFCom NrNotaFisNFCom NrSeqFatNFCom ItCodigoNFCom.  


DEFINE TEMP-TABLE ttICMSSN NO-UNDO  
     FIELD CST                AS CHARACTER INITIAL ?
     FIELD indSN              AS CHARACTER INITIAL ?
     /*Chave EMS*/
     FIELD CodEstabelNFCom    AS CHARACTER INITIAL ?
     FIELD SerieNFCom         AS CHARACTER INITIAL ?
     FIELD NrNotaFisNFCom     AS CHARACTER INITIAL ?
     INDEX ch-ttICMSSN IS PRIMARY UNIQUE CodEstabelNFCom SerieNFCom NrNotaFisNFCom.

DEFINE TEMP-TABLE ttPISNFCom NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situa‡Æo Tribut ria do PIS. 01 - Opera‡Æo Tribut vel - Base de C lculo = Valor da Opera‡Æo Al¡quota Normal (Cumulativo/NÆo Cumulativo); 02 - Opera‡Æo Tribut vel - Base de Calculo = Valor da Opera‡Æo (Al¡quota Diferenciada) */
     FIELD pPIS           AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al¡quota do PIS (em percentual)*/ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do PIS*/              
     FIELD vPIS           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do PIS*/                    
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttPISAliq CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttCOFINSNFCom NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situa‡Æo Tribut ria do COFINS. 01 Opera‡Æo Tribut vel - Base de C lculo = Valor da Opera‡Æo Al¡quota Normal (Cumulativo/NÆo Cumulativo); 02 - Opera‡Æo Tribut vel - Base de Calculo = Valor da Opera‡Æo (Al¡quota Diferenciada) */
     FIELD pCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al¡quota do COFINS (em percentual)*/ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do COFINS*/              
     FIELD vCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do COFINS*/                    
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttCOFINSAliq CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.

DEFINE TEMP-TABLE ttICMSUFDestNFCom NO-UNDO
     FIELD cUFDest        AS CHARACTER INITIAL ? 
     FIELD vBCUFDest      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor da Base de C lculo do ICMS na UF do destinat rio*/
     FIELD pFCPUFDest     AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"          DECIMALS 4  /*Percentual adicional inserido na al¡quota interna da UF de destino, relativo ao Fundo de Combate … Pobreza (FCP) naquela UF*/
     FIELD pICMSUFDest    AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"          DECIMALS 4  /*Al¡quota adotada nas opera‡äes internas na UF do destinat rio para o produto / mercadoria*/          
     FIELD vFCPUFDest     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor do ICMS relativo ao Fundo de Combate … Pobreza (FCP) da UF de destino*/
     FIELD vICMSUFDest    AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor do ICMS de partilha para a UF do destinat rio*/
     FIELD vICMSUFEmi     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor do ICMS de partilha para a UF do remetente*/
     FIELD cBenecUFDest   AS CHARACTER INITIAL ?  FORMAT "x(10)"                         /*Codigo do Beneficio Fiscal na UF destino aplicado ao item */
     /*Chave EMS*/
     FIELD CodEstabelNFCom   AS CHARACTER INITIAL ?
     FIELD SerieNFCom        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNFCom    AS CHARACTER INITIAL ?
     FIELD ItCodigoNFCom     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNFCom     AS INTEGER   INITIAL ?
     INDEX ch-ICMSUFDest CodEstabelNFCom SerieNFCom NrNotaFisNFCom NrSeqFatNFCom ItCodigoNFCom.     

DEFINE TEMP-TABLE ttICMS00 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tribut»’o pelo ICMS 00 - Tributada integralmente*/
     FIELD pICMS          AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al­quota do ICMS*/    
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS*/ 
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS*/   
     FIELD pFCP           AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Aliquota do FCP*/      
     FIELD vFCP           AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Valor do FCP*/      
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS00 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.
     

DEFINE TEMP-TABLE ttICMS20 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tribut»’o pelo ICMS 20 - Com redu»’o de base de cÿlculo*/
     FIELD pICMS          AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al­quota do ICMS*/ 
     FIELD pRedBC         AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Percentual de redu»’o da BC*/ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS*/ 
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS*/ 
     FIELD vICMSDeson     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS de desonera»’o*/ 
     FIELD cBenef         AS CHARACTER INITIAL ?                                         /*Benef*/
     FIELD pFCP           AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Aliquota do FCP*/      
     FIELD vFCP           AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Valor do FCP*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?   
     INDEX ch-ttICMS20 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.

DEFINE TEMP-TABLE ttICMS40 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tributa»’o pelo ICMS 40 - Isenta 41 - N’o tributada 50 - Suspens’o 51 - Diferimento */
     FIELD vICMSDeson     AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2    /*Valor do ICMS de desonera»’o*/ 
     FIELD cBenef         AS CHARACTER INITIAL ?                                         /*Benef*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS40 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttICMS51 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tributa»’o pelo ICMS 40 - Isenta 41 - N’o tributada 50 - Suspens’o 51 - Diferimento */
     FIELD vICMSDeson     AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2    /*Valor do ICMS de desonera»’o*/ 
     FIELD cBenef         AS CHARACTER INITIAL ? 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS51 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.

DEFINE TEMP-TABLE ttICMS90 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tribut»’o pelo ICMS 90 - Outras*/
     FIELD pICMS          AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al­quota do ICMS*/ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS*/
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS90 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.  
             
DEFINE TEMP-TABLE ttRetTrib NO-UNDO  
     FIELD vRetPIS        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99999999" DECIMALS 8   /*Valor Retido de PIS*/    
     FIELD vRetCOFINS     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99999999" DECIMALS 8   /*Valor Retido de COFINS*/  
     FIELD vRetCSLL       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99999999" DECIMALS 8 
     FIELD vBCIRRF        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99999999" DECIMALS 8   /*Base Retido de IRRF*/            
     FIELD vIRRF          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99999999" DECIMALS 8   /*Valor Retido de IRRF*/                   
     /*Chave EMS*/
     FIELD CodEstabelNFCom   AS CHARACTER INITIAL ?
     FIELD SerieNFCom        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNFCom    AS CHARACTER INITIAL ?
     FIELD ItCodigoNFCom     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNFCom     AS INTEGER   INITIAL ? 
     INDEX ch-ttRetTrib CodEstabelNFCom SerieNFCom NrNotaFisNFCom NrSeqFatNFCom ItCodigoNFCom.     


    
DEFINE TEMP-TABLE ttgCompraGov NO-UNDO
     FIELD tpEnteGov      AS CHARACTER INITIAL ?                                         /*Tipo de compra governamenta: 1=UniÆo; 2=Estado; 3=Distrito Federal; 4=Munic¡pio*/
     FIELD pRedutor       AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Percentual de redu‡Æo de al¡quota em compra governamental. Conforme o art. 473 da LC 214/2024. */
     FIELD tpOperGov      AS CHARACTER INITIAL ?                                         /* Tipo de opera‡Æo com o ente governamental. 1=Fornecimento. 2=Recebimento do pagamento, conforme fato gerador do IBS/CBS definido no Art. 10 õ 2§. */
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttgCompraGov IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF.    


DEFINE TEMP-TABLE ttgPagAntecipado NO-UNDO
     FIELD refNFe         AS CHARACTER INITIAL ?                                         /*Referˆncia uma NF-e (modelo 62) emitida anteriormente, referente a pagamento antecipado, para um ou mais itens */ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttgPagAntecipado CodEstabelNF SerieNF NrNotaFisNF.    


DEFINE TEMP-TABLE ttIBSCBS NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situa‡Æo Tribut ria do IBS e CBS*/
     FIELD cClassTrib     AS CHARACTER INITIAL ?                                         /*C¢digo de Classifica‡Æo Tribut ria do IBS e CBS*/
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Base de c lculo do IBS e CBS*/
     FIELD vIBS           AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do IBS (soma de vIBSUF e vIBSMun). Quando houver cr‚dito presumido com indicador ËIndDeduzCredPres=1Ì, o vCredPres deve ser abatido desse valor.*/
     FIELD indDoacao      AS CHARACTER INITIAL ?                                         /* Indica a natureza da operação de doação, orientando a apuração e a geração de débitos ou estornos conforme o cenário */
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     FIELD TipTributo     AS INTEGER   INITIAL ?
     INDEX ch-ttIBSCBS CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF TipTributo.
     
DEFINE TEMP-TABLE ttTransfCred NO-UNDO
     FIELD vIBS           AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor IBS UF e IBS Mun*/
     FIELD vCBS           AS DECIMAL   INITIAL ? FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2 /*Valor CBS*/   
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     FIELD TipTributo     AS INTEGER   INITIAL ?
     INDEX ch-ttTransfCred CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF TipTributo.

DEFINE TEMP-TABLE ttTribRT NO-UNDO  // Grupos gIBSUF, gIBSMun e gCBS
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situa‡Æo Tribut ria do IS*/
     FIELD cClassTribIS   AS CHARACTER INITIAL ?                                         /*C¢digo de Classifica‡Æo Tribut ria do IS*/
     FIELD vBCIS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Base de c lculo do IS*/
     FIELD pAliq          AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al¡quota do do Tributo IBS UF, IBS Mun ou CBS*/
     FIELD pDif           AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Percentual do diferimento*/
     FIELD vDif           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do Diferimento*/
     FIELD pDevTrib       AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Percentual de devolu‡Æo de IBS UF, IBS Mun ou CBS */
     FIELD vDevTrib       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do tributo devolvido*/
     FIELD pRedAliq       AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Percentual da redu‡Æo de al¡quota*/
     FIELD pAliqEfet      AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al¡quota Efetiva do Tributo (IBS UF, IBS Mun ou CBS) que ser  aplicada a Base de C lculo*/
     FIELD vTrib          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do Tributo IBS UF, IBS Mun ou CBS*/
     FIELD adRemIS        AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al¡quota espec¡fica por unidade de medida apropriada- IS */
     FIELD uTrib          AS CHARACTER INITIAL ?                                         /*Unidade de Medida Tribut vel*/
     FIELD qTrib          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>9.99"   DECIMALS 2   /*Quantidade Tribut vel*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     FIELD TipTributo     AS INTEGER   INITIAL ?
     INDEX ch-ttTribRT CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF TipTributo.

DEFINE TEMP-TABLE ttgTribRegular NO-UNDO
     FIELD CSTReg              AS CHARACTER INITIAL ?                                         /*C¢digo de Situa‡Æo Tribut ria do IBS e CBS*/
     FIELD cClassTribReg       AS CHARACTER INITIAL ?                                         /*C¢digo de Classifica‡Æo Tribut ria do IBS e CBS*/
     FIELD pAliqEfetRegIBSUF   AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*valor da al¡quota do IBS da UF*/
     FIELD vTribRegIBSUF       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do Tributo do IBS da UF*/
     FIELD pAliqEfetRegIBSMun  AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Valor da al¡quota do IBS do Munic¡pio*/
     FIELD vTribRegIBSMun      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*VValor do Tributo do IBS do Munic¡pio*/
     FIELD pAliqEfetRegCBS     AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Valor da al¡quota da CBS */
     FIELD vTribRegCBS         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do Tributo da CBS */
     /*Chave EMS*/
     FIELD CodEstabelNF        AS CHARACTER INITIAL ?
     FIELD SerieNF             AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF         AS CHARACTER INITIAL ?
     FIELD ItCodigoNF          AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF          AS INTEGER   INITIAL ?
     INDEX ch-ttgTribRegular CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.

DEFINE TEMP-TABLE ttgCredPresOper NO-UNDO
     FIELD vBCCredPres         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Base de c lculo do IBS e CBS*/
     FIELD cCredPres           AS CHARACTER INITIAL ?                                         /*C¢digo de Classifica‡Æo do Cr‚dito Presumido*/
     /*Chave EMS*/
     FIELD CodEstabelNF        AS CHARACTER INITIAL ?
     FIELD SerieNF             AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF         AS CHARACTER INITIAL ?
     FIELD ItCodigoNF          AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF          AS INTEGER   INITIAL ?
     INDEX ch-ttgCredPresOper CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.
     
DEFINE TEMP-TABLE ttgIBSCBSCredPres NO-UNDO
     FIELD pCredPres           AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Percentual do Cr‚dito Presumido*/
     FIELD vCredPres           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do Cr‚dito Presumido*/
     FIELD vCredPresCondSus    AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do Cr‚dito Presumido em condi‡Æo suspensiva*/
     /*Chave EMS*/
     FIELD CodEstabelNF        AS CHARACTER INITIAL ?
     FIELD SerieNF             AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF         AS CHARACTER INITIAL ?
     FIELD ItCodigoNF          AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF          AS INTEGER   INITIAL ?
     FIELD TipTributo          AS INTEGER   INITIAL ?
     INDEX ch-ttgCredPres CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF TipTributo.

DEFINE TEMP-TABLE ttgCredPresIBSZFM NO-UNDO
     FIELD competApur          AS CHARACTER INITIAL ?                                         /*Ano e mês referência do período de apuração (AAAA-MM)*/
     FIELD tpCredPresIBSZFM    AS CHARACTER INITIAL ?                                         /*Tipo de classificação de acordo com o art. 450, § 1º, da LC 214/25 para o cálculo do crédito presumido na ZFM*/
     FIELD vCredPresIBSZFM     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do crédito presumido calculado sobre o saldo devedor apurado*/
     /*Chave EMS*/
     FIELD CodEstabelNF        AS CHARACTER INITIAL ?
     FIELD SerieNF             AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF         AS CHARACTER INITIAL ?
     FIELD ItCodigoNF          AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF          AS INTEGER   INITIAL ?
     INDEX ch-ttgCredPres CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.
     
DEFINE TEMP-TABLE ttgTribCompraGov NO-UNDO
     FIELD pAliqIBSUF           AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al¡quota do IBS de competˆncia do Estado*/
     FIELD vTribIBSUF           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor que seria devido a UF, sem aplica‡Æo do Art. 473. da LC 214/2025*/
     FIELD pAliqIBSMun          AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al¡quota do IBS de competˆncia do Estado*/
     FIELD vTribIBSMun          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor que seria devido a UF, sem aplica‡Æo do Art. 473. da LC 214/2025*/     
     FIELD pAliqCBS             AS DECIMAL   INITIAL ?  FORMAT ">>9.9999"         DECIMALS 4   /*Al¡quota do IBS de competˆncia do Estado*/
     FIELD vTribCBS             AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor que seria devido a UF, sem aplica‡Æo do Art. 473. da LC 214/2025*/
     /*Chave EMS*/
     FIELD CodEstabelNF        AS CHARACTER INITIAL ?
     FIELD SerieNF             AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF         AS CHARACTER INITIAL ?
     FIELD ItCodigoNF          AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF          AS INTEGER   INITIAL ?
     FIELD TipTributo          AS INTEGER   INITIAL ?
     INDEX ch-ttTribCompraGov CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.


DEFINE TEMP-TABLE ttgIBSCBSMono NO-UNDO
     FIELD qBCMono             AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>>9.9999" DECIMALS 4   /*Quantidade tributada sujeita … reten‡Æo na monofasia. Informar a BC quantidade conforme unidade de medida estabelecida na legisla‡Æo para o produto.*/
     FIELD adRemIBS            AS DECIMAL   INITIAL 0  FORMAT ">>9.9999"         DECIMALS 4   /*Al¡quota ad rem do IBS*/
     FIELD adRemCBS            AS DECIMAL   INITIAL 0  FORMAT ">>9.9999"         DECIMALS 4   /*Al¡quota ad rem da CBS*/
     FIELD vIBSMono            AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do IBS monof sico*/
     FIELD vCBSMono            AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da CBS monof sica*/
     FIELD qBCMonoReten        AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>>9.9999" DECIMALS 4   /*Quantidade tributada sujeita … reten‡Æo na monofasia. Informar a BC quantidade conforme unidade de medida estabelecida na legisla‡Æo para o produto.*/
     FIELD vBCMono             AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>>>9.99" DECIMALS 2   /*Base de c lculo em valor monet rio (Ad Valorem)*/
     FIELD vBCMonoReten        AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>>>9.99" DECIMALS 2   /*BC reten‡Æo monet ria (Ad Valorem)*/
     FIELD qBCBioComb          AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>9.9999" DECIMALS 4   /*Qtde de Biocombust¡vel (LAC) a recolher/ressarcir*/
     FIELD adRemIBSReten       AS DECIMAL   INITIAL 0  FORMAT ">>9.9999"         DECIMALS 4   /*Al¡quota ad rem do IBS sujeito a reten‡Æo*/
     FIELD vIBSMonoReten       AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do IBS monof sico sujeito a reten‡Æo */
     FIELD adRemCBSReten       AS DECIMAL   INITIAL 0  FORMAT ">>9.9999"         DECIMALS 4   /*Al¡quota ad rem da CBS sujeito a reten‡Æo*/
     FIELD vCBSMonoReten       AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da CBS monof sica sujeita a reten‡Æo. Valor da CBS com reten‡Æo, a ser somado ao valor de CBS a ser recolhido.*/
     FIELD qBCMonoRet          AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>>9.9999" DECIMALS 4   /*Quantidade tributada retida anteriormente*/
     FIELD adRemIBSRet         AS DECIMAL   INITIAL 0  FORMAT ">>9.9999"         DECIMALS 4   /*Al¡quota ad rem do IBS retido anteriormente*/
     FIELD vIBSMonoRet         AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do IBS retido anteriormente*/
     FIELD adRemCBSRet         AS DECIMAL   INITIAL 0  FORMAT ">>9.9999"         DECIMALS 4   /*Al¡quota ad rem da CBS retida anteriormente*/
     FIELD vCBSMonoRet         AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da CBS retida anteriormente*/
     FIELD pAliqMonoUF         AS DECIMAL   INITIAL 0  FORMAT ">>9.9999"         DECIMALS 4   /*Al¡quota ad valorem do IBS Estadual*/
     FIELD vIBSMonoUF          AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do IBS monof sico da UF*/
     FIELD pAliqMonoMun        AS DECIMAL   INITIAL 0  FORMAT ">>9.9999"         DECIMALS 4   /*Al¡quota ad valorem do IBS Municipal*/
     FIELD vIBSMonoMun         AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do IBS monof sico do Munic¡pio*/
     FIELD vIBSMonoUFMun       AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Total do IBS monof sico da UF + Munic¡pio*/
     FIELD pAliqMonoCBS        AS DECIMAL   INITIAL 0  FORMAT ">>9.9999"         DECIMALS 4   /*Al¡quota ad valorem da CBS*/
     FIELD pAliqMonoRetenCBS   AS DECIMAL   INITIAL 0  FORMAT ">>9.9999"         DECIMALS 4   /*Al¡quota ad valorem da CBS sujeita … reten‡Æo*/
     FIELD vCBSDiferenca       AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da CBS correspondente … diferen‡a*/
     FIELD pAliqMonoRetenIBS   AS DECIMAL   INITIAL 0  FORMAT ">>9.9999"         DECIMALS 4   /*Al¡quota ad valorem do IBS sujeita … reten‡Æo*/
     FIELD vIBSDiferenca       AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do IBS correspondente … diferen‡a*/
     FIELD pDifIBS             AS DECIMAL   INITIAL 0  FORMAT ">>9.9999"         DECIMALS 4   /*Percentual do diferimento do imposto monof sico.*A ser aplicado em vIBSMono.*/
     FIELD vIBSMonoDif         AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do IBS monof sico diferido. A ser deduzido do valor do IBS*/
     FIELD pDifCBS             AS DECIMAL   INITIAL 0  FORMAT ">>9.9999"         DECIMALS 4   /*Percentual do diferimento do imposto monof sico. A ser aplicado em vCBSMono*/
     FIELD vCBSMonoDif         AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da CBS Monof sica diferida.  A ser deduzido do valor da CBS.*/
     FIELD vTotIBSMonoItem     AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Total de IBS Monof sico.*/
     FIELD vTotCBSMonoItem     AS DECIMAL   INITIAL 0  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Total da CBS Monof sica*/
     /*Chave EMS*/
     FIELD CodEstabelNF        AS CHARACTER INITIAL ?
     FIELD SerieNF             AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF         AS CHARACTER INITIAL ?
     FIELD ItCodigoNF          AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF          AS INTEGER   INITIAL ?
     INDEX ch-ttgIBSCBSMono CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.

DEFINE TEMP-TABLE ttgTransfCred NO-UNDO
     FIELD vIBS                AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do IBS a ser transferido*/
     FIELD vCBS                AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da CBS a ser transferida*/
     /*Chave EMS*/
     FIELD CodEstabelNF        AS CHARACTER INITIAL ?
     FIELD SerieNF             AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF         AS CHARACTER INITIAL ?
     FIELD ItCodigoNF          AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF          AS INTEGER   INITIAL ?
     INDEX ch-ttgTransfCred CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.

DEFINE TEMP-TABLE ttgAjusteCompet NO-UNDO     
     FIELD competApur          AS CHARACTER INITIAL ?                                         /*Ano e mês referência do período de apuração (AAAA-MM)*/
     FIELD vIBS                AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do IBS*/
     FIELD vCBS                AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da CBS*/     
     /*Chave EMS*/
     FIELD CodEstabelNF        AS CHARACTER INITIAL ?
     FIELD SerieNF             AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF         AS CHARACTER INITIAL ?
     FIELD ItCodigoNF          AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF          AS INTEGER   INITIAL ?
     INDEX ch-ttgAjusteCompet CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.
     
DEFINE TEMP-TABLE ttgEstornoCred NO-UNDO     
     FIELD vIBSEstCred         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do IBS a ser estornado*/
     FIELD vCBSEstCred         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da CBS a ser estornado*/
     /*Chave EMS*/
     FIELD CodEstabelNF        AS CHARACTER INITIAL ?
     FIELD SerieNF             AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF         AS CHARACTER INITIAL ?
     FIELD ItCodigoNF          AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF          AS INTEGER   INITIAL ?
     INDEX ch-ttgEstornoCred CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.     
     

DEFINE TEMP-TABLE ttVB NO-UNDO
     FIELD vItem               AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total do Item da NF-e*/
     /*Chave EMS*/
     FIELD CodEstabelNF        AS CHARACTER INITIAL ?
     FIELD SerieNF             AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF         AS CHARACTER INITIAL ?
     FIELD ItCodigoNF          AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF          AS INTEGER   INITIAL ?
     INDEX ch-ttVB CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.
     
     
DEFINE TEMP-TABLE ttDFeReferenciado NO-UNDO
     FIELD ChaveAcesso         AS CHARACTER INITIAL ?        /*Chave de acesso do DF-e referenciado*/
     FIELD nItem               AS CHARACTER INITIAL ?        /*N£mero do item do documento referenciado. - Corresponde ao atributo ËnItemÌ do elemento ËdetÌ do documento original*/
     /*Chave EMS*/
     FIELD CodEstabelNF        AS CHARACTER INITIAL ?
     FIELD SerieNF             AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF         AS CHARACTER INITIAL ?
     FIELD ItCodigoNF          AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF          AS INTEGER   INITIAL ?
     INDEX ch-ttDFeReferenciado CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.     
 
DEFINE TEMP-TABLE ttgALCZFMCBS NO-UNDO
     FIELD tpALCZFMCBS         AS CHARACTER INITIAL ?                                        /* Tipo de aplica‡Æo da al¡quota zero da CBS */
     FIELD nProcSuframa        AS CHARACTER INITIAL ?                                        /* N£mero do processo na Suframa para o item comercializado */
     FIELD pAliqEfetRegCBS     AS DECIMAL   INITIAL 0  FORMAT ">>9.9999"         DECIMALS 4  /* Percentual efetivo sem a redu‡Æo */ 
     FIELD vTribRegCBS         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2  /* Valor efetivo sem a redu‡Æo */
     /*Chave EMS*/
     FIELD CodEstabelNF        AS CHARACTER INITIAL ?
     FIELD SerieNF             AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF         AS CHARACTER INITIAL ?
     FIELD ItCodigoNF          AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF          AS INTEGER   INITIAL ?
     INDEX ch-ttgALCZFMCBS CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.     
         
     
DEFINE TEMP-TABLE ttTotIBSCBSIS NO-UNDO
     FIELD vIS                   AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Total do imposto seletivo*/ 
     FIELD vBCIBSCBS             AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total da BC do IBS e da CBS*/
     FIELD vDifIBSUF             AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total do diferimento do IBS da UF*/
     FIELD vDevTribIBSUF         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total de devolu‡Æo de tributos do IBS da UF*/
     FIELD vIBSUF                AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total do IBS da UF*/
     FIELD vDifIBSMun            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total do diferimento do IBS Mun*/
     FIELD vDevTribIBSMun        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total de devolu‡Æo de tributos do IBS Mun*/
     FIELD vIBSMun               AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total do IBS do Mun*/
     FIELD vIBS                  AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total do IBS*/
     FIELD vCredPresIBS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total do cr‚dito presumido do IBS*/
     FIELD vCredPresCondSusIBS   AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total do cr‚dito presumido em condi‡Æo suspensiva do IBS*/
     FIELD vCredPresCBS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total do cr‚dito presumido da CBS*/
     FIELD vCredPresCondSusCBS   AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total do cr‚dito presumido em condi‡Æo suspensiva da CBS*/
     FIELD vDifCBS               AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total do diferimento da CBS*/
     FIELD vDevTribCBS           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total de devolu‡Æo de tributos da CBS*/
     FIELD vCBS                  AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total da CBS*/
     FIELD vIBSMono              AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Total do IBS monof sico*/
     FIELD vCBSMono              AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Total da CBS monof sica*/
     FIELD vIBSMonoReten         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Total do IBS monof sico sujeito a reten‡Æo*/
     FIELD vCBSMonoReten         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Total da CBS monof sica sujeita a reten‡Æo*/
     FIELD vIBSMonoRet           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Total do IBS monof sico retido anteriormente*/
     FIELD vCBSMonoRet           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Total da CBS monof sica retida anteriormente*/
     FIELD vIBSEstCred           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total do IBS estornado*/
     FIELD vCBSEstCred           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total do CBS estornado*/
     FIELD vNFTot                AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor total da NF-e com IBS / CBS / IS*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttTotIBSCBSIS IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF.

DEFINE TEMP-TABLE ttNFe NO-UNDO
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ChaveAcessoNFe AS CHARACTER INITIAL ?
     FIELD VersaoLayout   AS CHARACTER INITIAL ?
     INDEX ch-ttNFe IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF.
     
// Temp-table ttDet ser  usada pelas procedures NF-e da Reforma Tribut ria
DEFINE TEMP-TABLE ttDet LIKE ttDetNFCom.

