/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
USING Progress.Json.ObjectModel.*.
{include/i-prgvrs.i AXSEP028IMPRIMEXML 2.00.00.094 } /*** "010094" 16/10/2026 15:40:54 ***/
{include/i-epc200.i AXSEP028IMPRIMEXML}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i AXSEP028IMPRIMEXML MUT}
&ENDIF

/*-------------------------------------------------
             AXSEP028IMPRIMEXML.p
-------------------------------------------------*/

{adapters/xml/ep2/axsep028.i}                  /* Defini‡äes Tabelas Tempor rias */
{adapters/xml/ep2/axsep028extradeclarations.i} /* Outras Declara‡äes             */

{cdp/cdcfgdis.i}

DEFINE INPUT PARAM PhGenXml AS HANDLE NO-UNDO .
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttStack   .
DEFINE INPUT PARAM TABLE FOR ttAssinante      .
DEFINE INPUT PARAM TABLE FOR ttDestNFCom      .
DEFINE INPUT PARAM TABLE FOR ttDetNFCom       .
DEFINE INPUT PARAM TABLE FOR ttEmitNFCom      .
DEFINE INPUT PARAM TABLE FOR ttICMSTotNFCom   .
DEFINE INPUT PARAM TABLE FOR ttIdeNFCom       .
DEFINE INPUT PARAM TABLE FOR ttNFCom          .
DEFINE INPUT PARAM TABLE FOR ttRetTribTotNFCom.
DEFINE INPUT PARAM TABLE FOR ttFUST           .
DEFINE INPUT PARAM TABLE FOR ttFUNTTEL        .
DEFINE INPUT PARAM TABLE FOR ttICMSSN         .
DEFINE INPUT PARAM TABLE FOR ttPISNFCom       .
DEFINE INPUT PARAM TABLE FOR ttCOFINSNFCom    .
DEFINE INPUT PARAM TABLE FOR ttTotal          .
DEFINE INPUT PARAM TABLE FOR ttICMSUFDestNFCom.
DEFINE INPUT PARAM TABLE FOR ttICMS00         .
DEFINE INPUT PARAM TABLE FOR ttICMS20         .
DEFINE INPUT PARAM TABLE FOR ttICMS40         .
DEFINE INPUT PARAM TABLE FOR ttICMS51         .
DEFINE INPUT PARAM TABLE FOR ttICMS90         .
DEFINE INPUT PARAM TABLE FOR ttgFatNFCom      .
DEFINE INPUT PARAM TABLE FOR ttRetTrib        .
DEFINE INPUT PARAM TABLE FOR ttInfAdicNFCom   .
DEFINE INPUT PARAM TABLE FOR ttgCompraGov     .
DEFINE INPUT PARAM TABLE FOR ttgPagAntecipado .
DEFINE INPUT PARAM TABLE FOR ttIBSCBS         .
DEFINE INPUT PARAM TABLE FOR ttTribRT         .
DEFINE INPUT PARAM TABLE FOR ttgTribRegular   .
DEFINE INPUT PARAM TABLE FOR ttgCredPresOper  .
DEFINE INPUT PARAM TABLE FOR ttgIBSCBSCredPres.
DEFINE INPUT PARAM TABLE FOR ttgTribCompraGov .
DEFINE INPUT PARAM TABLE FOR ttgIBSCBSMono    .
DEFINE INPUT PARAM TABLE FOR ttgTransfCred    .
DEFINE INPUT PARAM TABLE FOR ttgAjusteCompet  .
DEFINE INPUT PARAM TABLE FOR ttgEstornoCred   .
DEFINE INPUT PARAM TABLE FOR ttgCredPresIBSZFM.
DEFINE INPUT PARAM TABLE FOR ttVB             .
DEFINE INPUT PARAM TABLE FOR ttDFeReferenciado.
DEFINE INPUT PARAM TABLE FOR ttTotIBSCBSIS    .
DEFINE INPUT PARAM TABLE FOR ttgSub           .
DEFINE INPUT PARAM TABLE FOR ttgALCZFMCBS     .

/*-------------------------------------------------
            AXSEP028IMPRIMEXML.i
-------------------------------------------------*/


RUN pi-imprime-xml.

PROCEDURE pi-imprime-xml:

    FOR FIRST ttstack: END.

    ASSIGN iId        = ?
           lLayoutXML = YES
           hGenXml    = PhGenXml.
             
    FOR EACH ttNFCom:
        RUN cdp/cd0360b.p (INPUT ttNFCom.NrNotaFisNFCom,
                           INPUT "NFCom":U,
                           OUTPUT cTpTrans).
                           
         FOR FIRST estabelec
             WHERE estabelec.cod-estabel = ttNFCom.NrNotaFisNFCom NO-LOCK:
         END.                     

         RUN addNode      IN hGenXml (getStack(), "NFCom", "", OUTPUT iId).
         RUN setAttribute IN hGenXml (INPUT iId,  "xmlns",   "http://www.portalfiscal.inf.br/nfcom").

         addStack(iId).

              RUN addNode IN hGenXml (getStack(), "infNFCom" , "", OUTPUT iId).
              addStack(iId).

                   RUN setAttribute IN hGenXml (INPUT iId, "versao", ttNFCom.VersaoLayoutNFCom).
                   RUN setAttribute IN hGenXml (INPUT iId, "Id",     ("NFCom" + TRIM(ttNFCom.ChaveAcessoNFCom))).
                   
                   RUN pi-imprime-Ide-NFCom.

                   RUN pi-imprime-Emit-NFCom.
                   
                   RUN pi-imprime-Dest-NFCom.
                   
                   RUN pi-imprime-Assinante.
                   
                   RUN pi-imprime-gSub.

                   ASSIGN iContItem = 1.

                   FOR EACH ttDetNFCom
                      WHERE ttDetNFCom.CodEstabelNFCom = ttNFCom.CodEstabelNFCom
                        AND ttDetNFCom.SerieNFCom      = ttNFCom.SerieNFCom     
                        AND ttDetNFCom.NrNotaFisNFCom  = ttNFCom.NrNotaFisNFCom :

                        ASSIGN l-gEstornoCred = can-find(first it-nota-fisc-trib where
														       it-nota-fisc-trib.cod-estabel   = ttDetNFCom.CodEstabelNF and
														       it-nota-fisc-trib.serie         = ttDetNFCom.SerieNF      and
														       it-nota-fisc-trib.nr-nota-fis   = ttDetNFCom.NrNotaFisNF  and
														       it-nota-fisc-trib.nr-seq-fat    = ttDetNFCom.NrSeqFatNF   and
														       it-nota-fisc-trib.it-codigo     = ttDetNFCom.ItCodigoNF   and 
														       it-nota-fisc-trib.estorno-cred  = YES no-lock) .      
                        
                         RUN pi-grava-seq-item-xml.
                        
                         RUN addNode IN hGenXml (getStack(), "det", "", OUTPUT iId).
                         addStack(iId).
                
                              RUN setAttribute IN hGenXml(INPUT iId, "nItem", STRING(iContItem)).
                
                              RUN addNode IN hGenXml (getStack(), "prod", "", OUTPUT iId).
                              addStack(iId).
                
                                   RUN pi-imprime-Prod-NFCom.                
                
                              delStack().
                
                              RUN addNode IN hGenXml (getStack(), "imposto", "", OUTPUT iId).
                              addStack(iId).                              
                                                                                                                          
                                    IF ttDetNFCom.indSemCST = "1" THEN DO:
                                        {adapters/xml/ep2/axsep028nodechar.i "indSemCST" ttDetNFCom.indSemCST "NO"}                                                                            
                                    END.
                                    ELSE DO:                                                    
                                        RUN pi-imprime-ICMS.                                                    
                                        /* Simples Nacional */
                                        RUN pi-imprime-ICMSSN. 
                                        RUN pi-imprime-ICMSUFDest-NFCom.
                                    END.                                                    
                                    
                                    RUN pi-imprime-PIS-NFCom.                                 
                                    RUN pi-imprime-COFINS-NFCom.                                    
                                    RUN pi-imprime-fust.
                                    RUN pi-imprime-funttel.                             
                              
			            RUN pi-imprime-ReTrib.
				    
                                    IF l-NT2024002 THEN
                                       RUN pi-imprime-reforma-tributaria.

                              delStack(). 
                         
                              {adapters/xml/ep2/axsep028nodechar2.i "infAdProd" ttDetNFCom.infAdProd "NO"}
                               
                         delStack().
                                        
                         ASSIGN iContItem = iContItem + 1.                       
                   END.
                   
                   RUN pi-imprime-Total-NFCom.                   
                   
                   RUN pi-imprime-gFat-NFCom.

                   RUN pi-imprime-InfAdicNFCom.
                   
                   RUN pi-imprime-InfRespTec-NFCom.

              delStack().
              
              RUN pi-imprime-qrCode.

         delStack().
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-InfAdicNFCom:

    FOR EACH ttInfAdicNFCom
       WHERE ttInfAdicNFCom.CodEstabelNFCom = ttNFCom.CodEstabelNFCom
         AND ttInfAdicNFCom.SerieNFCom      = ttNFCom.SerieNFCom      
         AND ttInfAdicNFCom.NrNotaFisNFCom  = ttNFCom.NrNotaFisNFCom 
         AND (   (ttInfAdicNFCom.infAdFisco  <> "" AND ttInfAdicNFCom.infAdFisco  <> ?)
              OR (ttInfAdicNFCom.infCpl      <> "" AND ttInfAdicNFCom.infCpl      <> ?)):
                                  
         RUN addNode IN hGenXml (getStack(), "infAdic", "", OUTPUT iId).
         addStack(iId).

         {adapters/xml/ep2/axsep037nodechar.i  "infAdFisco" ttInfAdicNFCom.infAdFisco "NO" }
         {adapters/xml/ep2/axsep037nodechar2.i "infCpl"     ttInfAdicNFCom.infCpl     "NO" }
         
         delStack().            
    END.         
         
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-Ide-NFCom:

    FOR EACH ttIdeNFCom
       WHERE ttIdeNFCom.NrNotaFisNFCom   = ttNFCom.NrNotaFisNFCom
         AND ttIdeNFCom.SerieNFCom       = ttNFCom.SerieNFCom     
         AND ttIdeNFCom.NrNotaFisNFCom   = ttNFCom.NrNotaFisNFCom:

        RUN addNode IN hGenXml (getStack(), "ide", "", OUTPUT iId).
        addStack(iId).

            {adapters/xml/ep2/axsep028nodechar.i "cUF"                    ttIdeNFCom.cUF            "YES"}
            {adapters/xml/ep2/axsep028nodechar.i "tpAmb"                  ttIdeNFCom.tpAmb          "YES"}
            {adapters/xml/ep2/axsep028nodechar.i "mod"                    ttIdeNFCom.mod            "YES"}
            {adapters/xml/ep2/axsep028nodechar.i "serie"                  ttIdeNFCom.serie          "YES"}
            {adapters/xml/ep2/axsep028nodechar.i "nNF"                    ttIdeNFCom.nNF            "YES"}
            {adapters/xml/ep2/axsep028nodechar.i "cNF"                    ttIdeNFCom.cNF            "YES"}
            {adapters/xml/ep2/axsep028nodechar.i "cDV"                    ttIdeNFCom.cDV            "YES"}
            {adapters/xml/ep2/axsep028nodechar.i "dhEmi"                  ttIdeNFCom.dhEmi          "YES"}
            {adapters/xml/ep2/axsep028nodechar.i "tpEmis"                 ttIdeNFCom.tpEmis         "YES"}
            {adapters/xml/ep2/axsep028nodechar.i "nSiteAutoriz"           ttIdeNFCom.nSiteAutoriz   "YES"}
            {adapters/xml/ep2/axsep028nodechar.i "cMunFG"                 ttIdeNFCom.cMunFG         "YES"}
            {adapters/xml/ep2/axsep028nodechar.i "finNFCom"               ttIdeNFCom.finNFCom       "YES"}
            {adapters/xml/ep2/axsep028nodechar.i "tpFat"                  ttIdeNFCom.tpFat          "YES"}
            {adapters/xml/ep2/axsep028nodechar.i "verProc"                ttIdeNFCom.verProc        "YES"}
            IF ttIdeNFCom.indPrePago = "1" THEN
                {adapters/xml/ep2/axsep028nodechar.i "indPrePago"         ttIdeNFCom.indPrePago "YES"}
            IF ttIdeNFCom.indPrePago = "1" THEN
                {adapters/xml/ep2/axsep028nodechar.i "indCessaoMeiosRede" ttIdeNFCom.indPrePago "YES"}
            {adapters/xml/ep2/axsep028nodechar.i "dhCont"                 ttIdeNFCom.dhCont     "NO" }
            {adapters/xml/ep2/axsep028nodechar.i "xJust"                  ttIdeNFCom.xJust      "NO" }
            IF ttIdeNFCom.tpPagAnt <> "0"  THEN
                {adapters/xml/ep2/axsep028nodechar.i "tpPagAnt"           ttIdeNFCom.tpPagAnt   "NO" }

            /* Compra Governamental */
            IF CAN-FIND(FIRST ttgCompraGov) THEN
                RUN pi-imprime-gCompraGov-NFCom.

        delStack().
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-gCompraGov-NFCom:
    
    FOR EACH ttgCompraGov
        WHERE ttgCompraGov.CodEstabelNF = ttNFCom.CodEstabelNFCom
        AND   ttgCompraGov.SerieNF      = ttNFCom.SerieNFCom
        AND   ttgCompraGov.NrNotaFisNF  = ttNFCom.NrNotaFisNFCom:
        
        RUN addNode IN hGenXml (getStack(), "gCompraGov", "", OUTPUT iId).
        addStack(iId).
            {adapters/xml/ep2/axsep028nodechar.i "tpEnteGov" ttgCompraGov.tpEnteGov "YES"}
            {adapters/xml/ep2/axsep028nodedec.i  "pRedutor"  ttgCompraGov.pRedutor  "YES" "4" "NO"}
            {adapters/xml/ep2/axsep028nodechar.i "tpOperGov" ttgCompraGov.tpOperGov "YES"}

            /* Chave de acesso do documento fiscal anterior. - Dever  ser informado apenas para tpOperGov 2 e 3*/
            IF ttgCompraGov.tpOperGov = "2":U
            OR ttgCompraGov.tpOperGov = "3":U THEN DO:

                FOR EACH ttDFeReferenciado
                    WHERE ttDFeReferenciado.CodEstabelNF = ttNFCom.CodEstabelNFCom
                    AND   ttDFeReferenciado.SerieNF      = ttNFCom.SerieNFCom
                    AND   ttDFeReferenciado.NrNotaFisNF  = ttNFCom.NrNotaFisNFCom:
                    
                    {adapters/xml/ep2/axsep028nodechar.i "refDFeAnt" ttDFeReferenciado.ChaveAcesso "NO"}
                END.
            END.

        delStack().
    END.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-gPagAntecipado-NFCom:
    
    FOR EACH ttgPagAntecipado
        WHERE ttgPagAntecipado.CodEstabelNF = ttDetNFCom.CodEstabelNFCom
        AND   ttgPagAntecipado.SerieNF      = (IF ttDetNFCom.SerieNFCom = "" THEN "0" ELSE ttDetNFCom.SerieNFCom)
        AND   ttgPagAntecipado.NrNotaFisNF  = ttDetNFCom.NrNotaFisNFCom
        AND   ttgPagAntecipado.ItCodigoNF   = ttDetNFCom.ItCodigoNFCom
        AND   ttgPagAntecipado.NrSeqFatNF   = ttDetNFCom.NrSeqFatNFCom:
        
        RUN addNode IN hGenXml (getStack(), "gPagAntecipado", "", OUTPUT iId).
        addStack(iId).
            {adapters/xml/ep2/axsep028nodechar.i "chDFePagAnt" ttgPagAntecipado.refNFe "YES"}
        delStack().
    END.
    
    RETURN "OK":U.
END PROCEDURE.
           
PROCEDURE pi-imprime-Emit-NFCom:

    FOR EACH ttEmitNFCom
       WHERE ttEmitNFCom.NrNotaFisNFCom  = ttNFCom.NrNotaFisNFCom
         AND ttEmitNFCom.SerieNFCom      = ttNFCom.SerieNFCom     
         AND ttEmitNFCom.NrNotaFisNFCom  = ttNFCom.NrNotaFisNFCom:

        IF  NOT AVAIL ttIdeNFCom THEN
            FIND FIRST ttIdeNFCom NO-ERROR.
        
        RUN addNode IN hGenXml (getStack(), "emit", "", OUTPUT iId).
        addStack(iId).
         
            {adapters/xml/ep2/axsep028nodechar.i "CNPJ"     ttEmitNFCom.CNPJ     "YES"}
            {adapters/xml/ep2/axsep028nodechar.i "IE"       ttEmitNFCom.IE       "YES"}
            {adapters/xml/ep2/axsep028nodechar.i "IEUFDest" ttEmitNFCom.IEUFDest "NO" }
            {adapters/xml/ep2/axsep028nodechar.i "CRT"      ttEmitNFCom.CRT      "YES"}
            {adapters/xml/ep2/axsep028nodechar.i "xNome"    ttEmitNFCom.xNome    "YES"}
            {adapters/xml/ep2/axsep028nodechar.i "xFant"    ttEmitNFCom.xFant    "NO" }

            RUN addNode IN hGenXml (getStack(), "enderEmit", "",           OUTPUT iId).
            addStack(iId).
                {adapters/xml/ep2/axsep028nodechar.i  "xLgr"    ttEmitNFCom.xLgr    "YES"}
                {adapters/xml/ep2/axsep028nodechar.i  "nro"     ttEmitNFCom.nro     "YES"}
                {adapters/xml/ep2/axsep028nodechar.i  "xCpl"    ttEmitNFCom.xCpl    "NO" }
                {adapters/xml/ep2/axsep028nodechar.i  "xBairro" ttEmitNFCom.xBairro "YES"}
                {adapters/xml/ep2/axsep028nodechar.i  "cMun"    ttEmitNFCom.cMun    "YES"}
                {adapters/xml/ep2/axsep028nodechar.i  "xMun"    ttEmitNFCom.xMun    "YES"}
                {adapters/xml/ep2/axsep028nodechar.i  "CEP"     ttEmitNFCom.CEP     "NO" }
                {adapters/xml/ep2/axsep028nodechar.i  "UF"      ttEmitNFCom.UF      "YES"}
                {adapters/xml/ep2/axsep028nodechar.i  "fone"    ttEmitNFCom.fone    "NO" }
				
			    IF l-NT2024002
				AND CAN-FIND(FIRST ttgALCZFMCBS
				             WHERE ttgALCZFMCBS.CodEstabelNF = ttDetNFCom.CodEstabelNF
							   AND ttgALCZFMCBS.SerieNF      = ttDetNFCom.SerieNF  
							   AND ttgALCZFMCBS.NrNotaFisNF  = ttDetNFCom.NrNotaFisNF ) THEN								 
					     	   {adapters/xml/ep2/axsep037nodechar.i "ISUFEmit" ttEmitNFCom.ISUFEmit  "NO"}	
            delStack().
        delStack().
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-imprime-Dest-NFCom:

    FOR EACH ttDestNFCom
       WHERE ttDestNFCom.NrNotaFisNFCom = ttNFCom.NrNotaFisNFCom
         AND ttDestNFCom.SerieNFCom      = ttNFCom.SerieNFCom     
         AND ttDestNFCom.NrNotaFisNFCom  = ttNFCom.NrNotaFisNFCom:
                                  
        RUN addNode IN hGenXml (getStack(), "dest", "", OUTPUT iId).
        addStack(iId).
        
            {adapters/xml/ep2/axsep028nodechar.i "xNome"      ttDestNFCom.xNome      "YES"}
                        
            IF  ttDestNFCom.CPF <> "" THEN          
                {adapters/xml/ep2/axsep028nodechar.i "CPF"        ttDestNFCom.CPF        "YES"}
                
            IF ttDestNFCom.CNPJ <> ""  THEN
                {adapters/xml/ep2/axsep028nodechar.i "CNPJ"       ttDestNFCom.CNPJ       "YES"}                                               
                
            IF ttDestNFCom.CPF = "" AND ttDestNFCom.CNPJ = "" THEN
                {adapters/xml/ep2/axsep028nodechar.i "idOutros"   ttDestNFCom.idOutros   "YES"}
            
            {adapters/xml/ep2/axsep028nodechar.i "indIEDest"  ttDestNFCom.indIEDest  "YES"} 
            {adapters/xml/ep2/axsep028nodechar.i "IE"         ttDestNFCom.IE         "NO" }
            {adapters/xml/ep2/axsep028nodechar.i "IM"         ttDestNFCom.IM         "NO" }

            RUN addNode IN hGenXml (getStack(), "enderDest", "",           OUTPUT iId).
            addStack(iId).

                {adapters/xml/ep2/axsep028nodechar.i  "xLgr"    ttDestNFCom.xLgr    "YES"}
                {adapters/xml/ep2/axsep028nodechar.i  "nro"     ttDestNFCom.nro     "YES"}
                {adapters/xml/ep2/axsep028nodechar.i  "xCpl"    ttDestNFCom.xCpl    "NO" }
                {adapters/xml/ep2/axsep028nodechar.i  "xBairro" ttDestNFCom.xBairro "YES"}
                {adapters/xml/ep2/axsep028nodechar.i  "cMun"    ttDestNFCom.cMun    "YES"}
                {adapters/xml/ep2/axsep028nodechar.i  "xMun"    ttDestNFCom.xMun    "YES"}
                {adapters/xml/ep2/axsep028nodechar.i  "CEP"     ttDestNFCom.CEP     "NO" }
                {adapters/xml/ep2/axsep028nodechar.i  "UF"      ttDestNFCom.UF      "YES"}
                {adapters/xml/ep2/axsep028nodechar.i  "cPais"   ttDestNFCom.cPais   "NO" }
                {adapters/xml/ep2/axsep028nodechar.i  "xPais"   ttDestNFCom.xPais   "NO" }
                {adapters/xml/ep2/axsep028nodechar.i  "fone"    ttDestNFCom.fone    "NO" }
                {adapters/xml/ep2/axsep028nodechar2.i "email"   ttDestNFCom.email   "NO" }
            delStack().
        delStack().
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-imprime-Assinante:
    
    FOR EACH ttAssinante 
       WHERE ttAssinante.NrNotaFisNFCom     = ttNFCom.NrNotaFisNFCom
         AND ttAssinante.SerieNFCom         = ttNFCom.SerieNFCom     
         AND ttAssinante.NrNotaFisNFCom     = ttNFCom.NrNotaFisNFCom:
    
        RUN addNode IN hGenXml (getStack(), "assinante", "", OUTPUT iId).
        addStack(iId).
        
            {adapters/xml/ep2/axsep028nodechar.i  "iCodAssinante" ttAssinante.iCodAssinante "YES"}
            {adapters/xml/ep2/axsep028nodechar.i  "tpAssinante"   ttAssinante.tpAssinante   "YES"}
            {adapters/xml/ep2/axsep028nodechar.i  "tpServUtil"    ttAssinante.tpServUtil    "YES"}
            {adapters/xml/ep2/axsep028nodechar.i  "nContrato"     ttAssinante.nContrato     "NO" }
            {adapters/xml/ep2/axsep028nodedate.i  "dContratoIni"  ttAssinante.dContratoIni  "NO" }
            {adapters/xml/ep2/axsep028nodedate.i  "dContratoFim"  ttAssinante.dContratoFim  "NO" }
    
        delStack().       
       
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-imprime-Prod-NFCom:

    
    {adapters/xml/ep2/axsep028nodechar2.i "cProd"         ttDetNFCom.cProd        "YES"}
    {adapters/xml/ep2/axsep028nodechar2.i "xProd"         ttDetNFCom.xProd        "YES"}
    {adapters/xml/ep2/axsep028nodechar.i  "cClass"        ttDetNFCom.cClass       "YES"}  
    
    IF ttDetNFCom.indSemCST <> "1" THEN
        {adapters/xml/ep2/axsep028nodechar.i  "CFOP"      ttDetNFCom.CFOP         "YES" } //Depende
        
    {adapters/xml/ep2/axsep028nodechar.i  "CNPJLD"        ttDetNFCom.CNPJLD       "NO" } //Depende
    {adapters/xml/ep2/axsep028nodechar.i  "uMed"          ttDetNFCom.uMed         "YES"}
    {adapters/xml/ep2/axsep028nodedec.i   "qFaturada"     ttDetNFCom.qFaturada    "YES" "4" "NO"}
    {adapters/xml/ep2/axsep028nodedec.i   "vItem"         ttDetNFCom.vItem        "YES" "8" "NO"}
    {adapters/xml/ep2/axsep028nodedec.i   "vDesc"         ttDetNFCom.vDesc        "NO"  "2" "YES"}
    {adapters/xml/ep2/axsep028nodedec.i   "vOutro"        ttDetNFCom.vOutro       "NO"  "2" "YES"}
    {adapters/xml/ep2/axsep028nodedec.i   "vProd"         ttDetNFCom.vProd        "YES" "8" "NO"}
    {adapters/xml/ep2/axsep028nodedate.i  "dExpiracao"    ttDetNFCom.dExpiracao   "NO" }
    {adapters/xml/ep2/axsep028nodechar.i  "indDevolucao"  ttDetNFCom.indDevolucao "NO" }     
    
    IF ttDetNFCom.CNPJCobrTerc <> "" THEN 
        {adapters/xml/ep2/axsep028nodechar.i  "CNPJCobrTerc"  ttDetNFCom.CNPJCobrTerc "NO" }

    IF  NOT AVAIL ttIdeNFCom THEN
        FIND FIRST ttIdeNFCom NO-ERROR.
    IF CAN-FIND(FIRST ttgPagAntecipado) AND ttIdeNFCom.tpPagAnt = "3" THEN
        RUN pi-imprime-gPagAntecipado-NFCom. 


    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-imprime-Total-NFCom:

    RUN addNode IN hGenXml (getStack(), "total", "", OUTPUT iId).
    addStack(iId).
    
        FOR FIRST ttTotal 
            WHERE ttTotal.NrNotaFisNFCom  = ttNFCom.NrNotaFisNFCom
              AND ttTotal.SerieNFCom      = ttNFCom.SerieNFCom
              AND ttTotal.NrNotaFisNFCom  = ttNFCom.NrNotaFisNFCom:

            {adapters/xml/ep2/axsep028nodedec.i "vProd" ttTotal.vProd "YES" "2" "YES"}
        
            FOR EACH ttICMSTotNFCom
               WHERE ttICMSTotNFCom.NrNotaFisNFCom   = ttNFCom.NrNotaFisNFCom
                 AND ttICMSTotNFCom.SerieNFCom       = ttNFCom.SerieNFCom     
                 AND ttICMSTotNFCom.NrNotaFisNFCom   = ttNFCom.NrNotaFisNFCom :               
            
                RUN addNode IN hGenXml (getStack(), "ICMSTot", "", OUTPUT iId).
                addStack(iId).
                
                    {adapters/xml/ep2/axsep028nodedec.i "vBC"            ttICMSTotNFCom.vBC            "YES" "2" "YES"}
                    {adapters/xml/ep2/axsep028nodedec.i "vICMS"          ttICMSTotNFCom.vICMS          "YES" "2" "YES"}
                    {adapters/xml/ep2/axsep028nodedec.i "vICMSDeson"     ttICMSTotNFCom.vICMSDeson     "YES" "2" "YES"}                                       
                    {adapters/xml/ep2/axsep028nodedec.i "vFCP"           ttICMSTotNFCom.vFCP           "YES" "2" "YES"}
                                    
                delStack().
            END.
            
            {adapters/xml/ep2/axsep028nodedec.i "vCOFINS"        ttTotal.vCOFINS        "YES" "2" "YES"}
            {adapters/xml/ep2/axsep028nodedec.i "vPIS"           ttTotal.vPIS           "YES" "2" "YES"}
            {adapters/xml/ep2/axsep028nodedec.i "vFUNTTEL"       ttTotal.vFUNTTEL       "YES" "2" "YES"}
            {adapters/xml/ep2/axsep028nodedec.i "vFUST"          ttTotal.vFUST          "YES" "2" "YES"}
                

            FOR EACH ttRetTribTotNFCom
               WHERE ttRetTribTotNFCom.NrNotaFisNFCom  = ttNFCom.NrNotaFisNFCom 
                 AND ttRetTribTotNFCom.SerieNFCom      = ttNFCom.SerieNFCom      
                 AND ttRetTribTotNFCom.NrNotaFisNFCom  = ttNFCom.NrNotaFisNFCom :
            
                RUN addNode IN hGenXml (getStack(), "vRetTribTot", "", OUTPUT iId).
                addStack(iId).
                
                    {adapters/xml/ep2/axsep028nodedec.i "vRetPIS"     ttRetTribTotNFCom.vRetPIS     "YES"  "2" "YES"}
                    {adapters/xml/ep2/axsep028nodedec.i "vRetCofins"  ttRetTribTotNFCom.vRetCofins  "YES"  "2" "YES"}
                    {adapters/xml/ep2/axsep028nodedec.i "vRetCSLL"    ttRetTribTotNFCom.vRetCSLL    "YES"  "2" "YES"}
                    {adapters/xml/ep2/axsep028nodedec.i "vIRRF"       ttRetTribTotNFCom.vIRRF       "YES"  "2" "YES"}                
                delStack().
            END.
            
            {adapters/xml/ep2/axsep028nodedec.i "vDesc"          ttTotal.vDesc          "YES" "2" "YES"}
            {adapters/xml/ep2/axsep028nodedec.i "vOutro"         ttTotal.vOutro         "YES" "2" "YES"}
            {adapters/xml/ep2/axsep028nodedec.i "vNF"            ttTotal.vNF            "YES" "2" "YES"}

            IF l-NT2024002 THEN DO:

               //vTotDFe = total/vNF + IBSCBSTot/gIBS/vIBS + IBSCBSTot/gCBS/vCBS (Exce‡Æo: Em 2026 nÆo somar IBS e CBS)
               ASSIGN d-total-dfe = ttTotal.vNF.

               FOR EACH ttTotIBSCBSIS
                   WHERE ttTotIBSCBSIS.CodEstabelNF = ttNFCom.CodEstabelNFCom 
                    AND ttTotIBSCBSIS.SerieNF       = ttNFCom.SerieNFCom      
                    AND ttTotIBSCBSIS.NrNotaFisNF   = ttNFCom.NrNotaFisNFCom:

                   IF ttTotIBSCBSIS.vIS > 0 THEN DO:
                      RUN addNode IN hGenXml (getStack(), "ISTot", "", OUTPUT iId).
                      addStack(iId).
                           {adapters/xml/ep2/axsep037nodedec.i "vIS"    ttTotIBSCBSIS.vIS "YES"  "2" "YES"}
                      delStack().
                   END.

                   RUN addNode IN hGenXml (getStack(), "IBSCBSTot", "", OUTPUT iId).
                   addStack(iId).
                        {adapters/xml/ep2/axsep037nodedec.i "vBCIBSCBS"    ttTotIBSCBSIS.vBCIBSCBS "YES"  "2" "YES"}

                      /*IF ttTotIBSCBSIS.vDifIBSUF  > 0 OR ttTotIBSCBSIS.vDevTribIBSUF  > 0 OR ttTotIBSCBSIS.vIBSUF              > 0 OR
                           ttTotIBSCBSIS.vDifIBSMun > 0 OR ttTotIBSCBSIS.vDevTribIBSMun > 0 OR ttTotIBSCBSIS.vIBSMun             > 0 OR 
                           ttTotIBSCBSIS.vIBS       > 0 OR l-imunidade THEN DO:*/
                                              
                           RUN addNode IN hGenXml (getStack(), "gIBS", "", OUTPUT iId).
                           addStack(iId).
                                                   
                                RUN addNode IN hGenXml (getStack(), "gIBSUF", "", OUTPUT iId).
                                addStack(iId).
                                     {adapters/xml/ep2/axsep037nodedec.i "vDif"     ttTotIBSCBSIS.vDifIBSUF     "YES"  "2" "YES"}
                                     {adapters/xml/ep2/axsep037nodedec.i "vDevTrib" ttTotIBSCBSIS.vDevTribIBSUF "YES"  "2" "YES"}
                                     {adapters/xml/ep2/axsep037nodedec.i "vIBSUF"   ttTotIBSCBSIS.vIBSUF        "YES"  "2" "YES"}
                                delStack().
                                                                                                                      
                                RUN addNode IN hGenXml (getStack(), "gIBSMun", "", OUTPUT iId).
                                addStack(iId).
                                     {adapters/xml/ep2/axsep037nodedec.i "vDif"     ttTotIBSCBSIS.vDifIBSMun     "YES"  "2" "YES"}
                                     {adapters/xml/ep2/axsep037nodedec.i "vDevTrib" ttTotIBSCBSIS.vDevTribIBSMun "YES"  "2" "YES"}
                                     {adapters/xml/ep2/axsep037nodedec.i "vIBSMun"  ttTotIBSCBSIS.vIBSMun        "YES"  "2" "YES"}
                                delStack().
                                                           
                                {adapters/xml/ep2/axsep037nodedec.i "vIBS"              ttTotIBSCBSIS.vIBS                 "YES"  "2" "YES"}
                                
                           delStack().
                      //END.
                                                   
                      /*IF ttTotIBSCBSIS.vDifCBS > 0 OR ttTotIBSCBSIS.vDevTribCBS  > 0 OR 
                           ttTotIBSCBSIS.vCBS    > 0 OR l-imunidade THEN DO: */
                                              
                           RUN addNode IN hGenXml (getStack(), "gCBS", "", OUTPUT iId).
                           addStack(iId).
                                {adapters/xml/ep2/axsep037nodedec.i "vDif"              ttTotIBSCBSIS.vDifCBS              "YES"  "2" "YES"}
                                {adapters/xml/ep2/axsep037nodedec.i "vDevTrib"          ttTotIBSCBSIS.vDevTribCBS          "YES"  "2" "YES"}
                                {adapters/xml/ep2/axsep037nodedec.i "vCBS"              ttTotIBSCBSIS.vCBS                 "YES"  "2" "YES"}
                           delStack().
                      //END.
                       IF ttTotIBSCBSIS.vIBSEstCred > 0 
                       OR ttTotIBSCBSIS.vCBSEstCred > 0 THEN DO:
                                              
                        RUN addNode IN hGenXml (getStack(), "gEstornoCred", "", OUTPUT iId).
                        addStack(iId).
                             {adapters/xml/ep2/axsep037nodedec.i "vIBSEstCred"      ttTotIBSCBSIS.vIBSEstCred       "YES"  "2" "YES"}
                             {adapters/xml/ep2/axsep037nodedec.i "vCBSEstCred"      ttTotIBSCBSIS.vCBSEstCred       "YES"  "2" "YES"}
                        delStack().
                      END.   
                        
                   delStack().
               END.
               
               {adapters/xml/ep2/axsep037nodedec.i "vTotDFe"  d-total-dfe  "YES"  "2" "YES"}
            END.
        END.
    delStack().

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-imprime-InfRespTec-NFCom:

    DEFINE VARIABLE v_hdl_get_csrt AS HANDLE     NO-UNDO.
    DEFINE VARIABLE oJson          AS JsonObject NO-UNDO.
    DEFINE VARIABLE CNPJ     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE xContato AS CHARACTER NO-UNDO.
    DEFINE VARIABLE email    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE fone     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE idCSRT   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE hashCSRT AS CHARACTER NO-UNDO.    

    FOR EACH ttIdeNFCom
       WHERE ttIdeNFCom.NrNotaFisNFCom  = ttNFCom.NrNotaFisNFCom
         AND ttIdeNFCom.SerieNFCom      = ttNFCom.SerieNFCom     
         AND ttIdeNFCom.NrNotaFisNFCom  = ttNFCom.NrNotaFisNFCom:
         
        ASSIGN CNPJ     = "53113791001790"
               xContato = "Angela Maria Gheller Telles"
               email    = "resp_tecnico_dfe_datasul@totvs.com.br"
               fone     = "40030015"
               hashCSRT = ?
               idCSRT   = ?.
        
        IF l-CSRT = YES THEN DO:
            IF NOT VALID-HANDLE(v_hdl_get_csrt) THEN
                RUN fwk/utils/csrtData.p PERSISTENT SET v_hdl_get_csrt.   
              
            /* hasCSRT */         
            RUN piGetCSRT IN v_hdl_get_csrt (INPUT ttNFCom.ChaveAcessoNFCom,  /* Nï¿½mero da chave de acesso da NF, obrigatï¿½rio */
                                             INPUT ttIdeNFCom.cUFCSRT,        /* Sigla do estado da NF, obrigatï¿½rio */  
                                             INPUT ttIdeNFCom.tpAmb,          /* Indica se o CSRT ï¿½ de Produï¿½ï¿½o(1) ou Homologaï¿½ï¿½o(2), caso nï¿½o for informado 1 ou 2, serï¿½ considerado sempre 1 (Produï¿½ï¿½o) */
                                             OUTPUT oJson).                   /* JSON retornado na estrutura contida no OUTPUT */             
            IF NOT oJson:has('error':U) THEN 
                ASSIGN hashCSRT = oJson:getCharacter('hashCSRT':U)
                       idCSRT   = STRING(int(oJson:getCharacter('idCSRT')),"99":U).                 
        END.
        RUN addNode IN hGenXml (getStack(), "gRespTec", "", OUTPUT iId).
        addStack(iId).
        
            {adapters/xml/ep2/axsep028nodechar.i "CNPJ"      CNPJ     "YES"}
            {adapters/xml/ep2/axsep028nodechar.i "xContato"  xContato "YES"}
            {adapters/xml/ep2/axsep028nodechar.i "email"     email    "YES"}
            {adapters/xml/ep2/axsep028nodechar.i "fone"      fone     "YES"}
            {adapters/xml/ep2/axsep028nodechar.i "idCSRT"    idCSRT   "NO" }
            {adapters/xml/ep2/axsep028nodechar.i "hashCSRT"  hashCSRT "NO" }

        delStack().    
    END.
    
    IF VALID-HANDLE(v_hdl_get_csrt) THEN 
        DELETE PROCEDURE v_hdl_get_csrt NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-imprime-qrCode:
    
    DEFINE VARIABLE c-qrCode AS CHARACTER NO-UNDO.
    
    FOR EACH ttIdeNFCom
       WHERE ttIdeNFCom.NrNotaFisNFCom   = ttNFCom.NrNotaFisNFCom
         AND ttIdeNFCom.SerieNFCom       = ttNFCom.SerieNFCom     
         AND ttIdeNFCom.NrNotaFisNFCom   = ttNFCom.NrNotaFisNFCom:
    
        ASSIGN c-qrCode = "https://dfe-portal.svrs.rs.gov.br/Nfcom/QRCode?chNFCom=" + TRIM(ttNFCom.ChaveAcessoNFCom) + "&tpAmb=" + ttIdeNFCom.tpAmb.
        
        RUN addNode IN hGenXml (getStack(), "infNFComSupl", "", OUTPUT iId).
        addStack(iId).
       
            RUN addNode     IN hGenXml (getStack(), "qrCodNFCom", c-qrCode, OUTPUT iId).                                       
                       
        delStack().
    END.

END PROCEDURE.

PROCEDURE pi-imprime-fust: 

    FOR EACH ttFUST
       WHERE ttFUST.CodEstabelNFCom = ttDetNFCom.CodEstabelNFCom
         AND ttFUST.SerieNFCom      = ttDetNFCom.SerieNFCom    
         AND ttFUST.NrNotaFisNFCom  = ttDetNFCom.NrNotaFisNFCom
         AND ttFUST.ItCodigoNFCom   = ttDetNFCom.ItCodigoNF 
         AND ttFUST.NrSeqFatNFCom   = ttDetNFCom.NrSeqFatNF:         
        
         RUN addNode IN hGenXml (getStack(), "FUST", "", OUTPUT iId).
         addStack(iId).
         
         IF  ttFUST.vBC   <> ? AND ttFUST.vBC   > 0
         AND ttFUST.pFUST <> ? AND ttFUST.pFUST > 0
         AND ttFUST.vFUST <> ? AND ttFUST.vFUST > 0 THEN DO:                  
             
             {adapters/xml/ep2/axsep028nodedec.i "vBC"     ttFUST.vBC    "YES"  "2" "YES"}
             {adapters/xml/ep2/axsep028nodedec.i "pFUST"   ttFUST.pFUST  "YES"  "2" "YES"}
             {adapters/xml/ep2/axsep028nodedec.i "vFUST"   ttFUST.vFUST  "YES"  "2" "YES"}
         
         END.
         delStack().
         
    END.

END PROCEDURE.
                 
PROCEDURE pi-imprime-funttel: 

    FOR EACH ttFUNTTEL
       WHERE ttFUNTTEL.CodEstabelNFCom = ttDetNFCom.CodEstabelNFCom
         AND ttFUNTTEL.SerieNFCom      = ttDetNFCom.SerieNFCom    
         AND ttFUNTTEL.NrNotaFisNFCom  = ttDetNFCom.NrNotaFisNFCom
         AND ttFUNTTEL.ItCodigoNFCom   = ttDetNFCom.ItCodigoNF 
         AND ttFUNTTEL.NrSeqFatNFCom   = ttDetNFCom.NrSeqFatNF :
         
         RUN addNode IN hGenXml (getStack(), "FUNTTEL", "", OUTPUT iId).
         addStack(iId).
         
         IF  ttFUNTTEL.vBC      <> ? AND ttFUNTTEL.vBC      > 0
         AND ttFUNTTEL.pFUNTTEL <> ? AND ttFUNTTEL.pFUNTTEL > 0
         AND ttFUNTTEL.vFUNTTEL <> ? AND ttFUNTTEL.vFUNTTEL > 0 THEN DO:                  
             
             {adapters/xml/ep2/axsep028nodedec.i "vBC"        ttFUNTTEL.vBC       "YES"  "2" "YES"}
             {adapters/xml/ep2/axsep028nodedec.i "pFUNTTEL"   ttFUNTTEL.pFUNTTEL  "YES"  "2" "YES"}
             {adapters/xml/ep2/axsep028nodedec.i "vFUNTTEL"   ttFUNTTEL.vFUNTTEL  "YES"  "2" "YES"}
         
         END.
         delStack().          
    END.

END PROCEDURE.

PROCEDURE pi-imprime-ICMSSN: 

    FOR EACH ttICMSSN
       WHERE ttICMSSN.CodEstabelNFCom = ttDetNFCom.CodEstabelNFCom
       AND   ttICMSSN.SerieNFCom      = ttDetNFCom.SerieNFCom 
       AND   ttICMSSN.NrNotaFisNFCom  = ttDetNFCom.NrNotaFisNFCom NO-LOCK:
    
       RUN addNode IN hGenXml (getStack(), "ICMSSN", "", OUTPUT iId).
       addStack(iId). 
           {adapters/xml/ep2/axsep028nodechar.i "CST"        ttICMSSN.CST       "YES"}
           {adapters/xml/ep2/axsep028nodechar.i "indSN"      ttICMSSN.indSN     "YES"}
       delStack().
   END.
END PROCEDURE.

PROCEDURE pi-imprime-PIS-NFCom:

    FOR EACH ttPISNFCom
       WHERE ttPISNFCom.CodEstabelNF = ttDetNFCom.CodEstabelNF
         AND ttPISNFCom.SerieNF      = ttDetNFCom.SerieNF     
         AND ttPISNFCom.NrNotaFisNF  = ttDetNFCom.NrNotaFisNF 
         AND ttPISNFCom.NrSeqFatNF   = ttDetNFCom.NrSeqFatNF
         AND ttPISNFCom.ItCodigoNF   = ttDetNFCom.ItCodigoNF :

        RUN addNode IN hGenXml (getStack(), "PIS", "", OUTPUT iId).
        addStack(iId).        
            {adapters/xml/ep2/axsep028nodechar.i "CST"  ttPISNFCom.CST  "YES"}
            {adapters/xml/ep2/axsep028nodedec.i  "vBC"  ttPISNFCom.vBC  "YES" "2" "YES"}
            {adapters/xml/ep2/axsep028nodedec.i  "pPIS" ttPISNFCom.pPIS "YES" "2" "YES"}
            {adapters/xml/ep2/axsep028nodedec.i  "vPIS" ttPISNFCom.vPIS "YES" "2" "YES"}
         delStack().

    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-COFINS-NFCom:

    FOR EACH ttCOFINSNFCom
       WHERE ttCOFINSNFCom.CodEstabelNF = ttDetNFCom.CodEstabelNF
         AND ttCOFINSNFCom.SerieNF      = ttDetNFCom.SerieNF     
         AND ttCOFINSNFCom.NrNotaFisNF  = ttDetNFCom.NrNotaFisNF 
         AND ttCOFINSNFCom.NrSeqFatNF   = ttDetNFCom.NrSeqFatNF
         AND ttCOFINSNFCom.ItCodigoNF   = ttDetNFCom.ItCodigoNF:
        
        RUN addNode IN hGenXml (getStack(), "COFINS", "", OUTPUT iId).
        addStack(iId).
            {adapters/xml/ep2/axsep028nodechar.i "CST"     ttCOFINSNFCom.CST     "YES"}
            {adapters/xml/ep2/axsep028nodedec.i  "vBC"     ttCOFINSNFCom.vBC     "YES" "2" "YES"}
            {adapters/xml/ep2/axsep028nodedec.i  "pCOFINS" ttCOFINSNFCom.pCOFINS "YES" "2" "YES"}
            {adapters/xml/ep2/axsep028nodedec.i  "vCOFINS" ttCOFINSNFCom.vCOFINS "YES" "2" "YES"}
        delStack().

    END.
    
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-grava-seq-item-xml:

    FOR FIRST it-nota-fisc 
        WHERE it-nota-fisc.cod-estabel = ttDetNFCom.CodEstabelNFCom
          AND it-nota-fisc.serie       = ttDetNFCom.SerieNFCom
          AND it-nota-fisc.nr-nota-fis = ttDetNFCom.NrNotaFisNFCom
          AND it-nota-fisc.it-codigo   = ttDetNFCom.ItCodigoNF 
          AND it-nota-fisc.nr-seq-fat  = ttDetNFCom.NrSeqFatNF EXCLUSIVE-LOCK:
                                      
       OVERLAY(it-nota-fisc.char-2,370,5) = STRING(iContItem).
    END. 

  /*  IF NOT AVAIL ttIdeNFCom THEN
       FIND FIRST ttIdeNFCom NO-ERROR.

    IF ttIdeNFCom.tpNF = "0" THEN DO: /*Nota de entrada*/
       FOR FIRST nota-fiscal NO-LOCK
           WHERE nota-fiscal.cod-estabel = ttDetNFCom.NrNotaFisNFCom
             AND nota-fiscal.serie       = ttDetNFCom.SerieNFCom
             AND nota-fiscal.nr-nota-fis = ttDetNFCom.NrNotaFisNFCom:
           
           FOR FIRST it-nota-fisc OF nota-fiscal NO-LOCK
               WHERE it-nota-fisc.it-codigo   = ttDetNFCom.ItCodigoNF 
                 AND it-nota-fisc.nr-seq-fat  = ttDetNFCom.NrSeqFatNF:
                
               FOR FIRST item-doc-est EXCLUSIVE-LOCK  
                   WHERE item-doc-est.serie-docto  = it-nota-fisc.serie
                     AND item-doc-est.nro-docto    = nota-fiscal.nr-nota-ant 
                     AND item-doc-est.cod-emitente = nota-fiscal.cod-emitente
                     AND item-doc-est.nat-operacao = nota-fiscal.nat-operacao
                     AND item-doc-est.sequencia    = it-nota-fisc.nr-seq-ped:
                   
                  OVERLAY(item-doc-est.char-2,832,5) = STRING(iContItem).
               
                  IF NOT CAN-FIND (FIRST ext-item-doc-est NO-LOCK
                                   WHERE ext-item-doc-est.serie-docto  = item-doc-est.serie-docto
                                     AND ext-item-doc-est.nro-docto    = item-doc-est.nro-docto
                                     AND ext-item-doc-est.cod-emitente = item-doc-est.cod-emitente
                                     AND ext-item-doc-est.nat-operacao = item-doc-est.nat-operacao
                                     AND ext-item-doc-est.sequencia    = item-doc-est.sequencia
                                     AND ext-item-doc-est.cod-param    = "infoXML":U) THEN DO:

                            CREATE ext-item-doc-est.
                            ASSIGN ext-item-doc-est.serie-docto  = item-doc-est.serie-docto
                                   ext-item-doc-est.nro-docto    = item-doc-est.nro-docto
                                   ext-item-doc-est.cod-emitente = item-doc-est.cod-emitente
                                   ext-item-doc-est.nat-operacao = item-doc-est.nat-operacao
                                   ext-item-doc-est.sequencia    = item-doc-est.sequencia
                                   ext-item-doc-est.cod-param    = "infoXML":U.

                            ASSIGN OVERLAY(ext-item-doc-est.cod-livre-1,1,120) = ttDetNFCom.xProd
                                   OVERLAY(ext-item-doc-est.cod-livre-2,1,6)   = ttDetNFCom.uCom.               
                  END.
                  ELSE DO:
                  
                     FOR FIRST ext-item-doc-est EXCLUSIVE-LOCK
                         WHERE ext-item-doc-est.serie-docto  = item-doc-est.serie-docto
                           AND ext-item-doc-est.nro-docto    = item-doc-est.nro-docto
                           AND ext-item-doc-est.cod-emitente = item-doc-est.cod-emitente
                           AND ext-item-doc-est.sequencia    = item-doc-est.sequencia
                           AND ext-item-doc-est.cod-param    = "infoXML":U:
                           
                        ASSIGN OVERLAY(ext-item-doc-est.cod-livre-1,1,120) = ttDetNFCom.xProd
                               OVERLAY(ext-item-doc-est.cod-livre-2,1,6) = ttDetNFCom.uCom.
                     END.
                  END.
               END.
           END.
        END.
    END.     */                                                           

   RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-ICMSUFDest-NFCom:    

    FOR EACH ttICMSUFDestNFCom
        WHERE ttICMSUFDestNFCom.CodEstabelNFCom = ttDetNFCom.CodEstabelNFCom 
          AND ttICMSUFDestNFCom.SerieNFCom      = ttDetNFCom.SerieNFCom 
          AND ttICMSUFDestNFCom.NrNotaFisNFCom  = ttDetNFCom.NrNotaFisNFCom 
          AND ttICMSUFDestNFCom.NrSeqFatNFCom   = ttDetNFCom.NrSeqFatNFCom 
          AND ttICMSUFDestNFCom.ItCodigoNFCom   = ttDetNFCom.ItCodigoNFCom 
          AND (ttICMSUFDestNFCom.vBCUFDest      > 0 OR
               ttICMSUFDestNFCom.pFCPUFDest     > 0 OR
               ttICMSUFDestNFCom.pICMSUFDest    > 0 OR               
               ttICMSUFDestNFCom.vFCPUFDest     > 0 OR
               ttICMSUFDestNFCom.vICMSUFDest    > 0 OR
               ttICMSUFDestNFCom.vICMSUFEmi   > 0 ) :             

        RUN addNode IN hGenXml (getStack(), "ICMSUFDest", "", OUTPUT iId).
        addStack(iId).        
           
           RUN setAttribute IN hGenXml (INPUT iId, "cUFDest", STRING(ttICMSUFDestNFCom.cUFDest)).             
          
           {adapters/xml/ep2/axsep028nodedec.i  "vBCUFDest"      ttICMSUFDestNFCom.vBCUFDest      "YES" "2" "YES"}           
           {adapters/xml/ep2/axsep028nodedec.i  "pFCPUFDest"     ttICMSUFDestNFCom.pFCPUFDest     "YES"  "2" "YES"}
           {adapters/xml/ep2/axsep028nodedec.i  "pICMSUFDest"    ttICMSUFDestNFCom.pICMSUFDest    "YES" "2" "YES"}           
           {adapters/xml/ep2/axsep028nodedec.i  "vFCPUFDest"     ttICMSUFDestNFCom.vFCPUFDest     "YES"  "2" "YES"}
           {adapters/xml/ep2/axsep028nodedec.i  "vICMSUFDest"    ttICMSUFDestNFCom.vICMSUFDest    "YES" "2" "YES"}
           {adapters/xml/ep2/axsep028nodedec.i  "vICMSUFEmi"     ttICMSUFDestNFCom.vICMSUFEmi     "YES" "2" "YES"}
           {adapters/xml/ep2/axsep028nodechar.i "cBenecUFDest"   ttICMSUFDestNFCom.cBenecUFDest   "NO"} 

        delStack().
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-ICMS:

          FOR EACH ttICMS00
             WHERE ttICMS00.CodEstabelNF = ttDetNFCom.CodEstabelNF
               AND ttICMS00.SerieNF      = ttDetNFCom.SerieNF     
               AND ttICMS00.NrNotaFisNF  = ttDetNFCom.NrNotaFisNF 
               AND ttICMS00.NrSeqFatNF   = ttDetNFCom.NrSeqFatNF
               AND ttICMS00.ItCodigoNF   = ttDetNFCom.ItCodigoNF :
              
               RUN addNode IN hGenXml (getStack(), "ICMS00", "", OUTPUT iId).
               addStack(iId).
                    {adapters/xml/ep2/axsep037nodechar.i "CST"   ttICMS00.CST   "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i  "vBC"   ttICMS00.vBC   "YES" "2" "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i  "pICMS" ttICMS00.pICMS "YES" "2" "yes"}
                    {adapters/xml/ep2/axsep037nodedec.i  "vICMS" ttICMS00.vICMS "YES" "2" "YES"}

                    /* FCP */
                    IF ((ttICMS00.pFCP <> ? AND ttICMS00.pFCP > 0)
                    AND (ttICMS00.vFCP <> ? AND ttICMS00.vFCP > 0)) THEN DO:
                        {adapters/xml/ep2/axsep037nodedec.i  "pFCP" ttICMS00.pFCP "YES" "2" "yes"}
                        {adapters/xml/ep2/axsep037nodedec.i  "vFCP" ttICMS00.vFCP "YES" "2" "YES"}
                    END.
               delStack().
          END.
          
          FOR EACH ttICMS20
             WHERE ttICMS20.CodEstabelNF = ttDetNFCom.CodEstabelNF
               AND ttICMS20.SerieNF      = ttDetNFCom.SerieNF     
               AND ttICMS20.NrNotaFisNF  = ttDetNFCom.NrNotaFisNF 
               AND ttICMS20.NrSeqFatNF   = ttDetNFCom.NrSeqFatNF
               AND ttICMS20.ItCodigoNF   = ttDetNFCom.ItCodigoNF :
              
               RUN addNode IN hGenXml (getStack(), "ICMS20", "", OUTPUT iId).
               addStack(iId).
                    {adapters/xml/ep2/axsep037nodechar.i "CST"   ttICMS20.CST   "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i  "pRedBC" ttICMS20.pRedBC "YES" "2" "yes "}
                    {adapters/xml/ep2/axsep037nodedec.i  "vBC"   ttICMS20.vBC   "YES" "2" "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i  "pICMS" ttICMS20.pICMS "YES" "2" "yes "}
                    {adapters/xml/ep2/axsep037nodedec.i  "vICMS" ttICMS20.vICMS "YES" "2" "YES"}

                    /* FCP */
                    IF ((ttICMS20.pFCP <> ? AND ttICMS20.pFCP > 0)
                    AND (ttICMS20.vFCP <> ? AND ttICMS20.vFCP > 0)) THEN DO:
                        {adapters/xml/ep2/axsep037nodedec.i  "pFCP" ttICMS20.pFCP "YES" "2" "YES"}
                        {adapters/xml/ep2/axsep037nodedec.i  "vFCP" ttICMS20.vFCP "YES" "2" "YES"}
                    END.
                    
                    IF ttICMS20.vICMSDeson <> ? AND ttICMS20.vICMSDeson  > 0 THEN DO:
                        {adapters/xml/ep2/axsep037nodedec.i  "vICMSDeson"  ttICMS20.vICMSDeson  "YES" "2" "YES"}
                    END.      
                    
                    IF ttICMS20.cBenef <> ? AND ttICMS20.cBenef <> "" THEN DO:
                        {adapters/xml/ep2/axsep037nodechar.i "cBenef"   ttICMS20.cBenef   "YES"}    
                    END.
               delStack().
          END.          

          FOR EACH ttICMS40
             WHERE ttICMS40.CodEstabelNF = ttDetNFCom.CodEstabelNF
               AND ttICMS40.SerieNF      = ttDetNFCom.SerieNF     
               AND ttICMS40.NrNotaFisNF  = ttDetNFCom.NrNotaFisNF 
               AND ttICMS40.NrSeqFatNF   = ttDetNFCom.NrSeqFatNF
               AND ttICMS40.ItCodigoNF   = ttDetNFCom.ItCodigoNF :
              
               RUN addNode IN hGenXml (getStack(), "ICMS40", "", OUTPUT iId).
               addStack(iId).

                    {adapters/xml/ep2/axsep037nodechar.i "CST"         ttICMS40.CST         "YES"}                    
                    {adapters/xml/ep2/axsep037nodedec.i  "vICMSDeson"  ttICMS40.vICMSDeson  "YES" "2" "YES"}                    
                    
                    IF ttICMS40.cBenef <> ? AND ttICMS40.cBenef <> "" THEN DO:
                        {adapters/xml/ep2/axsep037nodechar.i "cBenef"   ttICMS40.cBenef   "YES"}    
                    END.
               delStack().
          END. 
          
          FOR EACH ttICMS51
             WHERE ttICMS51.CodEstabelNF = ttDetNFCom.CodEstabelNF
               AND ttICMS51.SerieNF      = ttDetNFCom.SerieNF     
               AND ttICMS51.NrNotaFisNF  = ttDetNFCom.NrNotaFisNF 
               AND ttICMS51.NrSeqFatNF   = ttDetNFCom.NrSeqFatNF
               AND ttICMS51.ItCodigoNF   = ttDetNFCom.ItCodigoNF :
              
               RUN addNode IN hGenXml (getStack(), "ICMS51", "", OUTPUT iId).
               addStack(iId).

                    {adapters/xml/ep2/axsep037nodechar.i "CST"   ttICMS51.CST   "YES"}
                    
                    IF ttICMS51.vICMSDeson <> ? AND ttICMS51.vICMSDeson  > 0 THEN DO:
                        {adapters/xml/ep2/axsep037nodedec.i  "vICMSDeson"  ttICMS51.vICMSDeson  "YES" "2" "YES"}
                    END.      
                    
                    IF ttICMS51.cBenef <> ? AND ttICMS51.cBenef <> "" THEN DO:
                        {adapters/xml/ep2/axsep037nodechar.i "cBenef"   ttICMS51.cBenef   "YES"}    
                    END.
               delStack().
          END.                    
          
          FOR EACH ttICMS90
             WHERE ttICMS90.CodEstabelNF = ttDetNFCom.CodEstabelNF
               AND ttICMS90.SerieNF      = ttDetNFCom.SerieNF     
               AND ttICMS90.NrNotaFisNF  = ttDetNFCom.NrNotaFisNF 
               AND ttICMS90.NrSeqFatNF   = ttDetNFCom.NrSeqFatNF
               AND ttICMS90.ItCodigoNF   = ttDetNFCom.ItCodigoNF :
              
               RUN addNode IN hGenXml (getStack(), "ICMS90", "", OUTPUT iId).
               addStack(iId).
                    {adapters/xml/ep2/axsep037nodechar.i "CST"   ttICMS90.CST   "YES"}
		    IF  ttICMS90.vBC   <> ? AND ttICMS90.vBC   > 0
                    AND ttICMS90.pICMS <> ? AND ttICMS90.pICMS > 0 
                    AND ttICMS90.vICMS <> ? AND ttICMS90.vICMS > 0 THEN DO:
                        {adapters/xml/ep2/axsep037nodedec.i  "vBC"   ttICMS90.vBC   "YES" "2" "YES"}
                        {adapters/xml/ep2/axsep037nodedec.i  "pICMS" ttICMS90.pICMS "YES" "2" "YES"}
                        {adapters/xml/ep2/axsep037nodedec.i  "vICMS" ttICMS90.vICMS "YES" "2" "YES"}
	            END.
               delStack().
          END.          
     //delStack().
          
END PROCEDURE.

PROCEDURE pi-imprime-gFat-NFCom:

    FOR EACH  ttgFatNFCom
        WHERE ttgFatNFCom.CodEstabel  = ttNFCom.CodEstabelNFCom
         AND  ttgFatNFCom.SerieNFCom  = ttNFCom.SerieNFCom
         AND  ttgFatNFCom.NrNotaFis   = ttNFCom.NrNotaFisNFCom NO-LOCK:           
                 
         RUN addNode IN hGenXml (getStack(), "gFat", "", OUTPUT iId).
         addStack(iId). 
         
              {adapters/xml/ep2/axsep037nodechar.i "CompetFat"  ttgFatNFCom.CompetFat  "YES"}
              {adapters/xml/ep2/axsep028nodedate.i "dVencFat "  ttgFatNFCom.dVencFat   "YES"}       
              {adapters/xml/ep2/axsep037nodechar.i "codBarras"  ttgFatNFCom.codBarras  "YES"}
         
         delStack().
         
    END.

END PROCEDURE.

PROCEDURE pi-imprime-ReTrib:

    FOR EACH  ttRetTrib
        WHERE ttRetTrib.CodEstabelNFCom = ttDetNFCom.CodEstabelNFCom
        AND   ttRetTrib.SerieNFCom      = ttDetNFCom.SerieNFCom
        AND   ttRetTrib.NrNotaFisNFCom  = ttDetNFCom.NrNotaFisNFCom
        AND   ttRetTrib.ItCodigoNFCom   = ttDetNFCom.ItCodigoNFCom
        AND   ttRetTrib.NrSeqFatNFCom   = ttDetNFCom.NrSeqFatNFCom NO-LOCK:
        
        RUN addNode IN hGenXml (getStack(), "retTrib", "", OUTPUT iId).
         addStack(iId). 
         
          {adapters/xml/ep2/axsep028nodedec.i "vRetPIS"     ttRetTrib.vRetPIS     "YES"  "8" "NO"}
          {adapters/xml/ep2/axsep028nodedec.i "vRetCofins"  ttRetTrib.vRetCofins  "YES"  "8" "NO"}
          {adapters/xml/ep2/axsep028nodedec.i "vRetCSLL"    ttRetTrib.vRetCSLL    "YES"  "8" "NO"}                            
          {adapters/xml/ep2/axsep028nodedec.i "vBCIRRF"     ttRetTrib.vBCIRRF     "YES"  "8" "NO"}          
	  {adapters/xml/ep2/axsep028nodedec.i "vIRRF"       ttRetTrib.vIRRF       "YES"  "8" "NO"}                                    
          
        delStack().   
    END.

END PROCEDURE.

PROCEDURE pi-imprime-reforma-tributaria:

          FOR FIRST ttIBSCBS
              WHERE ttIBSCBS.CodEstabelNF =  ttDetNFCom.CodEstabelNF
                AND ttIBSCBS.SerieNF      =  ttDetNFCom.SerieNF     
                AND ttIBSCBS.NrNotaFisNF  =  ttDetNFCom.NrNotaFisNF 
                AND ttIBSCBS.NrSeqFatNF   =  ttDetNFCom.NrSeqFatNF
                AND ttIBSCBS.ItCodigoNF   =  ttDetNFCom.ItCodigoNF
                AND ttIBSCBS.TipTributo   < 4 /** Nesse grupo nÆo imprime IS **/
                AND ttIBSCBS.CST          <> ""
                AND ttIBSCBS.cClassTrib   <> "": 

                ASSIGN l-imunidade = NO.
                
                RUN addNode IN hGenXml (getStack(), "IBSCBS", "", OUTPUT iId).
                addStack(iId).
                                                          
                     {adapters/xml/ep2/axsep037nodechar.i "CST"        ttIBSCBS.CST        "YES"}
                     {adapters/xml/ep2/axsep037nodechar.i "cClassTrib" ttIBSCBS.cClassTrib "YES"}
                     {adapters/xml/ep2/axsep037nodechar.i "indDoacao"  ttIBSCBS.indDoacao  "NO" }
                     
                     IF l-gEstornoCred  THEN DO:              
                                                         
                        IF CAN-FIND (FIRST ttgEstornoCred 
                                    WHERE ttgEstornoCred.CodEstabelNF = ttDetNFCom.CodEstabelNF
                                        AND ttgEstornoCred.SerieNF      = ttDetNFCom.SerieNF
                                        AND ttgEstornoCred.NrNotaFisNF  = ttDetNFCom.NrNotaFisNF
                                        AND ttgEstornoCred.ItCodigoNF   = ttDetNFCom.ItCodigoNF
                                        AND ttgEstornoCred.NrSeqFatNF   = ttDetNFCom.NrSeqFatNF) THEN DO:
                            RUN pi-imprime-ttgEstornoCred.   
                        END.  
                     END.
                                                          
                     IF ttIBSCBS.CST <> "410" AND ttIBSCBS.CST <> "820" THEN DO: /* NÆo deve mostrar gIBSCBS para opera‡äes de Imunidade e nÆo incidˆncia */
                        RUN addNode IN hGenXml (getStack(), "gIBSCBS", "", OUTPUT iId).
                        addStack(iId).
                                              
                             {adapters/xml/ep2/axsep037nodedec.i  "vBC"   ttIBSCBS.vBC   "YES" "2" "YES"}
                             
                             RUN pi-imprime-IBSCBS (INPUT 2). /* IBS UF */
                             
                             RUN pi-imprime-IBSCBS (INPUT 3). /* IBS Mun */
                             
                             {adapters/xml/ep2/axsep037nodedec.i  "vIBS"   ttIBSCBS.vIBS   "YES" "2" "YES"}
                            
                             RUN pi-imprime-IBSCBS (INPUT 1). /* CBS */

                             IF CAN-FIND(FIRST ttgTribRegular 
                                         WHERE ttgTribRegular.CodEstabelNF = ttDetNFCom.CodEstabelNF
                                           AND ttgTribRegular.SerieNF      = ttDetNFCom.SerieNF     
                                           AND ttgTribRegular.NrNotaFisNF  = ttDetNFCom.NrNotaFisNF 
                                           AND ttgTribRegular.NrSeqFatNF   = ttDetNFCom.NrSeqFatNF
                                           AND ttgTribRegular.ItCodigoNF   = ttDetNFCom.ItCodigoNF) THEN DO:
                                RUN pi-imprime-gTribRegular.
                             END.       
                             
                             IF CAN-FIND (FIRST ttgTribCompraGov 
                                          WHERE ttgTribCompraGov.CodEstabelNF = ttDetNFCom.CodEstabelNF
                                          AND   ttgTribCompraGov.SerieNF      = ttDetNFCom.SerieNF
                                          AND   ttgTribCompraGov.NrNotaFisNF  = ttDetNFCom.NrNotaFisNF
                                          AND   ttgTribCompraGov.ItCodigoNF   = ttDetNFCom.ItCodigoNF
                                          AND   ttgTribCompraGov.NrSeqFatNF   = ttDetNFCom.NrSeqFatNF) THEN DO:
                                 RUN pi-imprime-gTribCompraGov.
                             END.

                        delStack().
                     END.
                     ELSE
                        ASSIGN l-imunidade = YES.
                delStack().
          END.                         

END PROCEDURE.

PROCEDURE pi-imprime-IBSCBS:
                                          
    DEF INPUT PARAM pTipTributo AS INT NO-UNDO.
 
    FOR FIRST ttIBSCBS
        WHERE ttIBSCBS.CodEstabelNF =  ttDetNFCom.CodEstabelNF
          AND ttIBSCBS.SerieNF      =  ttDetNFCom.SerieNF     
          AND ttIBSCBS.NrNotaFisNF  =  ttDetNFCom.NrNotaFisNF 
          AND ttIBSCBS.NrSeqFatNF   =  ttDetNFCom.NrSeqFatNF
          AND ttIBSCBS.ItCodigoNF   =  ttDetNFCom.ItCodigoNF
          AND ttIBSCBS.TipTributo   < 4 /** Nesse grupo nÆo imprime IS, porque a vigˆncia ser  a partri de 2027 **/
          AND ttIBSCBS.CST          <> "": 
          
          FOR FIRST ttTribRT
              WHERE ttTribRT.CodEstabelNF = ttDetNFCom.CodEstabelNF
              AND   ttTribRT.SerieNF      = ttDetNFCom.SerieNF     
              AND   ttTribRT.NrNotaFisNF  = ttDetNFCom.NrNotaFisNF 
              AND   ttTribRT.NrSeqFatNF   = ttDetNFCom.NrSeqFatNF
              AND   ttTribRT.ItCodigoNF   = ttDetNFCom.ItCodigoNF
              AND   ttTribRT.TipTributo   = pTipTributo: /*IBS UF */

              CASE pTipTributo:
                   WHEN 1 THEN RUN addNode IN hGenXml (getStack(), "gCBS",    "", OUTPUT iId).
                   WHEN 2 THEN RUN addNode IN hGenXml (getStack(), "gIBSUF",  "", OUTPUT iId).
                   WHEN 3 THEN RUN addNode IN hGenXml (getStack(), "gIBSMun", "", OUTPUT iId).
              END CASE.
                                                                    
              addStack(iId).
                                               
                   CASE pTipTributo:
                        WHEN 1 THEN {adapters/xml/ep2/axsep037nodedec.i  "pCBS"     ttTribRT.pAliq  "YES" "4" "YES"}
                        WHEN 2 THEN DO: 
                            {adapters/xml/ep2/axsep037nodedec.i  "pIBSUF"   ttTribRT.pAliq  "YES" "4" "YES"} 
                            IF ttTribRT.pRedAliq > 0 THEN 
                                ASSIGN d-perc-red-aliq = ttTribRT.pRedAliq.
                        END.
                        WHEN 3 THEN {adapters/xml/ep2/axsep037nodedec.i  "pIBSMun"  ttTribRT.pAliq  "YES" "4" "YES"}
                   END CASE.
                                                                    
                   IF ttTribRT.pDif > 0 OR (pTipTributo = 3 /*IBSMun*/ AND ttTribRT.pDif = 0 AND ttIBSCBS.CST = "510") THEN DO:
           
                      RUN addNode IN hGenXml (getStack(), "gDif", "", OUTPUT iId).
                      addStack(iId).

                           {adapters/xml/ep2/axsep037nodedec.i "pDif"  ttTribRT.pDif "YES" "4" "YES"}
                           {adapters/xml/ep2/axsep037nodedec.i "vDif"  ttTribRT.vDif "YES" "2" "YES"}
                                                                     
                      delStack().
                   END.
                                                                         
                   IF ttTribRT.vDevTrib > 0 THEN DO:
           
                      RUN addNode IN hGenXml (getStack(), "gDevTrib", "", OUTPUT iId).
                      addStack(iId).

                           {adapters/xml/ep2/axsep037nodedec.i "vDevTrib"  ttTribRT.vDevTrib "YES"  "2" "YES"}

                      delStack().
                   END.
                   
                   IF ttTribRT.pRedAliq > 0
                   OR (pTipTributo = 3 AND ttTribRT.pRedAliq = 0 AND (ttIBSCBS.CST = "200" OR ttIBSCBS.CST = "515"))
                   OR CAN-FIND(FIRST ttgCompraGov 
                               WHERE ttgCompraGov.CodEstabelNF = ttDetNFCom.CodEstabelNF
                               AND   ttgCompraGov.SerieNF      = ttDetNFCom.SerieNF
                               AND   ttgCompraGov.NrNotaFisNF  = ttDetNFCom.NrNotaFisNF) THEN DO:
                               
                       RUN addNode IN hGenXml (getStack(), "gRed", "", OUTPUT iId).
                       addStack(iId).                                                                
                           
                           IF pTipTributo = 3 AND ttTribRT.pRedAliq = 0 AND (ttIBSCBS.CST = "515" OR ttIBSCBS.CST = "200") AND d-perc-red-aliq > 0 THEN
                               ASSIGN ttTribRT.pRedAliq = d-perc-red-aliq
                                      d-perc-red-aliq   = 0. 
                                      
                           {adapters/xml/ep2/axsep037nodedec.i "pRedAliq"   ttTribRT.pRedAliq  "YES" "4" "YES"}
                           {adapters/xml/ep2/axsep037nodedec.i "pAliqEfet"  ttTribRT.pAliqEfet "YES" "4" "YES"}

                       delStack().
                   END.
                                                                         
                   CASE pTipTributo:
                        WHEN 1 THEN DO:
                            // Grupo gALCZFMCBS ‚ somente para CBS
                            FOR FIRST ttgALCZFMCBS
                                WHERE ttgALCZFMCBS.CodEstabelNF = ttDetNFCom.CodEstabelNF
                                AND ttgALCZFMCBS.SerieNF      = ttDetNFCom.SerieNF     
                                AND ttgALCZFMCBS.NrNotaFisNF  = ttDetNFCom.NrNotaFisNF 
                                AND ttgALCZFMCBS.ItCodigoNF   = ttDetNFCom.ItCodigoNF
                                AND ttgALCZFMCBS.NrSeqFatNF   = ttDetNFCom.NrSeqFatNF:
                            
                                RUN addNode IN hGenXml (getStack(), "gALCZFMCBS", "", OUTPUT iId).
                                addStack(iId).                                    
                                    {adapters/xml/ep2/axsep037nodedec.i  "pAliqEfetRegCBS" ttgALCZFMCBS.pAliqEfetRegCBS "YES" "4" "YES"}
                                    {adapters/xml/ep2/axsep037nodedec.i  "vTribRegCBS"     ttgALCZFMCBS.vTribRegCBS     "YES" "2" "YES"}
                                delStack(). 
                            END.                                                        
                            
                            {adapters/xml/ep2/axsep037nodedec.i "vCBS"     ttTribRT.vTrib "YES"  "2" "YES"}
                        END.    
                        WHEN 2 THEN {adapters/xml/ep2/axsep037nodedec.i "vIBSUF"   ttTribRT.vTrib "YES"  "2" "YES"}
                        WHEN 3 THEN {adapters/xml/ep2/axsep037nodedec.i "vIBSMun"  ttTribRT.vTrib "YES"  "2" "YES"}
                   END CASE.
                                                                         
              delStack().
          END.
    END. 
                 
    RETURN "OK":U.
    
END PROCEDURE.

PROCEDURE pi-imprime-gSub:

    FOR EACH ttgSub 
       WHERE ttgSub.NrNotaFisNFCom     = ttNFCom.NrNotaFisNFCom
         AND ttgSub.SerieNFCom         = ttNFCom.SerieNFCom     
         AND ttgSub.NrNotaFisNFCom     = ttNFCom.NrNotaFisNFCom:
        
        RUN addNode IN hGenXml (getStack(), "gSub", "", OUTPUT iId).
        addStack(iId).
            
            {adapters/xml/ep2/axsep028nodechar.i  "chNFCom" ttgSub.chNFCom "YES"}                           
            {adapters/xml/ep2/axsep028nodechar.i  "motSub"  ttgSub.motSub  "YES"} 
         
        delStack().    
    END. 
     
    RETURN "OK":U.
    
END PROCEDURE.

PROCEDURE pi-imprime-gTribCompraGov:

   FOR FIRST ttgTribCompraGov 
       WHERE ttgTribCompraGov.CodEstabelNF  = ttDetNFCom.CodEstabelNF
       AND   ttgTribCompraGov.SerieNF       = ttDetNFCom.SerieNF
       AND   ttgTribCompraGov.NrNotaFisNF   = ttDetNFCom.NrNotaFisNF
       AND   ttgTribCompraGov.ItCodigoNF    = ttDetNFCom.ItCodigoNF
       AND   ttgTribCompraGov.NrSeqFatNF    = ttDetNFCom.NrSeqFatNF:
       
       RUN addNode IN hGenXml (getStack(), "gTribCompraGov", "", OUTPUT iId).
       addStack(iId).
           {adapters/xml/ep2/axsep037nodedec.i "pAliqIBSUF"  ttgTribCompraGov.pAliqIBSUF    "YES" "4" "YES"}
           {adapters/xml/ep2/axsep037nodedec.i "vTribIBSUF"  ttgTribCompraGov.vTribIBSUF    "YES" "2" "YES"}
           {adapters/xml/ep2/axsep037nodedec.i "pAliqIBSMun" ttgTribCompraGov.pAliqIBSMun   "YES" "4" "YES"}
           {adapters/xml/ep2/axsep037nodedec.i "vTribIBSMun" ttgTribCompraGov.vTribIBSMun   "YES" "2" "YES"}
           {adapters/xml/ep2/axsep037nodedec.i "pAliqCBS"    ttgTribCompraGov.pAliqCBS      "YES" "4" "YES"}
           {adapters/xml/ep2/axsep037nodedec.i "vTribCBS"    ttgTribCompraGov.vTribCBS      "YES" "2" "YES"}
       delStack().
   END.
   
   RETURN "OK":U.
    
END PROCEDURE.

PROCEDURE pi-imprime-gTribRegular:
                     
    FOR FIRST ttgTribRegular
        WHERE ttgTribRegular.CodEstabelNF   =  ttDetNFCom.CodEstabelNF
          AND ttgTribRegular.SerieNF        =  ttDetNFCom.SerieNF     
          AND ttgTribRegular.NrNotaFisNF    =  ttDetNFCom.NrNotaFisNF 
          AND ttgTribRegular.NrSeqFatNF     =  ttDetNFCom.NrSeqFatNF
          AND ttgTribRegular.ItCodigoNF     =  ttDetNFCom.ItCodigoNF
          AND ttgTribRegular.CSTReg         <> ""
          AND ttgTribRegular.cClassTribReg  <> "": 
   
        RUN addNode IN hGenXml (getStack(), "gTribRegular", "", OUTPUT iId).
        addStack(iId).
        
            {adapters/xml/ep2/axsep037nodechar.i "CSTReg"              ttgTribRegular.CSTReg              "YES"          }
            {adapters/xml/ep2/axsep037nodechar.i "cClassTribReg"       ttgTribRegular.cClassTribReg       "YES"          }            
            {adapters/xml/ep2/axsep037nodedec.i  "pAliqEfetRegIBSUF"   ttgTribRegular.pAliqEfetRegIBSUF   "YES" "4" "YES"}
            {adapters/xml/ep2/axsep037nodedec.i  "vTribRegIBSUF"       ttgTribRegular.vTribRegIBSUF       "YES" "2" "YES"}
            {adapters/xml/ep2/axsep037nodedec.i  "pAliqEfetRegIBSMun"  ttgTribRegular.pAliqEfetRegIBSMun  "YES" "4" "YES"}
            {adapters/xml/ep2/axsep037nodedec.i  "vTribRegIBSMun"      ttgTribRegular.vTribRegIBSMun      "YES" "2" "YES"}
            {adapters/xml/ep2/axsep037nodedec.i  "pAliqEfetRegCBS"     ttgTribRegular.pAliqEfetRegCBS     "YES" "4" "YES"}
            {adapters/xml/ep2/axsep037nodedec.i  "vTribRegCBS"         ttgTribRegular.vTribRegCBS         "YES" "2" "YES"}
            
        delStack().
  
    END.
               
    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-imprime-ttgEstornoCred:

    FOR  FIRST ttgEstornoCred 
         WHERE ttgEstornoCred.CodEstabelNF  = ttDetNFCom.CodEstabelNF
         AND   ttgEstornoCred.SerieNF       = ttDetNFCom.SerieNF
         AND   ttgEstornoCred.NrNotaFisNF   = ttDetNFCom.NrNotaFisNF
         AND   ttgEstornoCred.ItCodigoNF    = ttDetNFCom.ItCodigoNF
         AND   ttgEstornoCred.NrSeqFatNF    = ttDetNFCom.NrSeqFatNF:

         RUN addNode IN hGenXml (getStack(), "gEstornoCred", "", OUTPUT iId).
         addStack(iId).                                                             
             {adapters/xml/ep2/axsep037nodedec.i  "vIBSEstCred"       ttgEstornoCred.vIBSEstCred        "YES" "2" "YES"}
             {adapters/xml/ep2/axsep037nodedec.i  "vCBSEstCred"       ttgEstornoCred.vCBSEstCred        "YES" "2" "YES"}
         delStack().
    END.
    
    RETURN "OK":U.
    
END PROCEDURE.
