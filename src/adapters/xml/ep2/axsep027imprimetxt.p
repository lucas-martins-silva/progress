/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa...
*******************************************************************************/
{include/i-prgvrs.i AXSEP027IMPRIMETXT 2.00.00.022 } /*** "010022" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i axsep027imprimetxt MUT}
&ENDIF

 /*-------------------------------------------------
             axsep027ImprimeTXT.p
-------------------------------------------------*/

{include/i-epc200.i AXSEP027IMPRIMETXT}

{adapters/xml/ep2/axsep027.i}                  /* Definiá‰es Tabelas Tempor†rias */
{adapters/xml/ep2/axsep027extradeclarations.i} /* Outras Declaraá‰es             */

{cdp/cdcfgdis.i}

DEFINE INPUT  PARAM pcArquivoNFeTXT  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAM pcArquivoEmitTXT AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAM TABLE FOR ttAdi.                
DEFINE INPUT  PARAM TABLE FOR ttArma.               
DEFINE INPUT  PARAM TABLE FOR ttAutXML.             
DEFINE INPUT  PARAM TABLE FOR ttAvulsa.             
DEFINE INPUT  PARAM TABLE FOR ttCobr.               
DEFINE INPUT  PARAM TABLE FOR ttCOFINSAliq.         
DEFINE INPUT  PARAM TABLE FOR ttCOFINSNT.           
DEFINE INPUT  PARAM TABLE FOR ttCOFINSOutr.         
DEFINE INPUT  PARAM TABLE FOR ttCOFINSQtde.         
DEFINE INPUT  PARAM TABLE FOR ttCOFINSST.           
DEFINE INPUT  PARAM TABLE FOR ttICMSUFDest.           
DEFINE INPUT  PARAM TABLE FOR ttComb.               
DEFINE INPUT  PARAM TABLE FOR ttCompra.             
DEFINE INPUT  PARAM TABLE FOR ttDest.               
DEFINE INPUT  PARAM TABLE FOR ttDet.                
DEFINE INPUT  PARAM TABLE FOR ttDetExport.          
DEFINE INPUT  PARAM TABLE FOR ttDI.                 
DEFINE INPUT  PARAM TABLE FOR ttDup.                
DEFINE INPUT  PARAM TABLE FOR ttEmit.               
DEFINE INPUT  PARAM TABLE FOR ttEntrega.            
DEFINE INPUT  PARAM TABLE FOR ttExporta.            
DEFINE INPUT  PARAM TABLE FOR ttICMS00.             
DEFINE INPUT  PARAM TABLE FOR ttICMS10.             
DEFINE INPUT  PARAM TABLE FOR ttICMS20.             
DEFINE INPUT  PARAM TABLE FOR ttICMS30.             
DEFINE INPUT  PARAM TABLE FOR ttICMS40.             
DEFINE INPUT  PARAM TABLE FOR ttICMS51.             
DEFINE INPUT  PARAM TABLE FOR ttICMS60.             
DEFINE INPUT  PARAM TABLE FOR ttICMS70.             
DEFINE INPUT  PARAM TABLE FOR ttICMS90.             
DEFINE INPUT  PARAM TABLE FOR ttICMSTot.            
DEFINE INPUT  PARAM TABLE FOR ttIde.                
DEFINE INPUT  PARAM TABLE FOR ttII.                 
DEFINE INPUT  PARAM TABLE FOR ttImpostoDevol.       
DEFINE INPUT  PARAM TABLE FOR ttInfAdic.            
DEFINE INPUT  PARAM TABLE FOR ttIPI.                
DEFINE INPUT  PARAM TABLE FOR ttISSQN.              
DEFINE INPUT  PARAM TABLE FOR ttISSQNtot.           
DEFINE INPUT  PARAM TABLE FOR ttLacres.             
DEFINE INPUT  PARAM TABLE FOR ttMed.                
DEFINE INPUT  PARAM TABLE FOR ttNFe.                
DEFINE INPUT  PARAM TABLE FOR ttrefNF.              
DEFINE INPUT  PARAM TABLE FOR ttObsCont.            
DEFINE INPUT  PARAM TABLE FOR ttObsFisco.           
DEFINE INPUT  PARAM TABLE FOR ttPISAliq.            
DEFINE INPUT  PARAM TABLE FOR ttPISNT.              
DEFINE INPUT  PARAM TABLE FOR ttPISOutr.            
DEFINE INPUT  PARAM TABLE FOR ttPISQtde.            
DEFINE INPUT  PARAM TABLE FOR ttPISST.              
DEFINE INPUT  PARAM TABLE FOR ttProcRef.            
DEFINE INPUT  PARAM TABLE FOR ttReboque.            
DEFINE INPUT  PARAM TABLE FOR ttRetirada.           
DEFINE INPUT  PARAM TABLE FOR ttRetTrib.            
DEFINE INPUT  PARAM TABLE FOR ttTransp.             
DEFINE INPUT  PARAM TABLE FOR ttVeic.               
DEFINE INPUT  PARAM TABLE FOR ttVol.                
DEFINE INPUT  PARAM TABLE FOR ttrefNFP.             
DEFINE INPUT  PARAM TABLE FOR ttrefCTe.             
DEFINE INPUT  PARAM TABLE FOR ttrefECF.             
DEFINE INPUT  PARAM TABLE FOR ttICMSPart.           
DEFINE INPUT  PARAM TABLE FOR ttICMSST.             
DEFINE INPUT  PARAM TABLE FOR ttICMSSN101.          
DEFINE INPUT  PARAM TABLE FOR ttICMSSN102.          
DEFINE INPUT  PARAM TABLE FOR ttICMSSN201.          
DEFINE INPUT  PARAM TABLE FOR ttICMSSN202.          
DEFINE INPUT  PARAM TABLE FOR ttICMSSN500.          
DEFINE INPUT  PARAM TABLE FOR ttICMSSN900.          
DEFINE INPUT  PARAM TABLE FOR ttCana.               
DEFINE INPUT  PARAM TABLE FOR ttForDia.             
DEFINE INPUT  PARAM TABLE FOR ttDeduc.              

ASSIGN lLayoutTXT = YES. /* Layout TXT -> para controle no AddNode */

ASSIGN iContNota = 0.

/*Conta Numero de Notas*/
FOR EACH ttNfe NO-LOCK:
    ASSIGN iContNota = iContNota + 1.
END.

IF  pcArquivoNFeTXT  <> ? THEN
    RUN pi-imprime-TXT-NFe.

IF  pcArquivoEmitTXT <> ? THEN
    RUN pi-imprime-TXT-Emit.


RETURN "OK":U.

/*-----------------------------------------------------------------------------------------------*/

PROCEDURE pi-imprime-TXT-NFe:
    /******** Inicio ponto epc ***************************************/  
    IF  c-nom-prog-dpc-mg97  <> "" OR  
        c-nom-prog-appc-mg97 <> "" OR  
        c-nom-prog-upc-mg97  <> "" THEN DO:
        FOR EACH tt-epc 
            WHERE tt-epc.cod-event = "AlteraArquivoNFeTXT":U :
            DELETE tt-epc.
        END.

        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "AlteraArquivoNFeTXT":U
               tt-epc.cod-parameter = "ArquivoNFeTXT":U
               tt-epc.val-parameter = STRING(pcArquivoNFeTXT).
        
        {include/i-epc201.i "AlteraArquivoNFeTXT"}

        FOR FIRST tt-epc
            WHERE tt-epc.cod-event = "AlteraArquivoNFeTXT":U 
            AND   tt-epc.cod-parameter = "ArquivoNFeTXTAlterado":

            ASSIGN pcArquivoNFeTXT = tt-epc.val-parameter.
        END.
    END. /* IF  c-nom-prog-dpc-mg97  <> "" OR */
    /******** Fim ponto epc ******************************************/  

    /* Imprime TXT Nota Fiscal Eletrìnica */
    OUTPUT TO VALUE(pcArquivoNFeTXT) convert target "utf-8":U. 

        /*NOTA FISCAL|qtd notas fiscais no arquivo|*/

        PUT "NOTA FISCAL" "|".
        {adapters/xml/ep2/axsep027nodechar.i "iContNota" STRING(iContNota) "YES"}
        PUT SKIP.

        FOR EACH ttNFe NO-LOCK:

            /*A|vers∆o do schema|id|*/
            PUT "A" "|" ttNFe.VersaoLayout "|" "NFe" "|" SKIP.

            RUN pi-imprime-Ide-txt.

            RUN pi-imprime-Emit-txt.

            RUN pi-imprime-Avulsa-txt.

            RUN pi-imprime-Dest-txt.

            RUN pi-imprime-Retirada-txt.

            RUN pi-imprime-Entrega-txt.

            RUN pi-imprime-AutXML-txt.
            
            ASSIGN iContItem = 1.
        
            FOR EACH ttDet
               WHERE ttDet.CodEstabelNF = ttNFe.CodEstabelNF
                 AND ttDet.SerieNF      = ttNFe.SerieNF     
                 AND ttDet.NrNotaFisNF  = ttNFe.NrNotaFisNF :
        
                /*----------------------*/
                /*H|nItem|infAdProd|*/
                PUT "H" "|".
                {adapters/xml/ep2/axsep027nodechar.i  "iContItem" STRING(iContItem) "YES"}
        
                {adapters/xml/ep2/axsep027nodechar2.i "infAdProd" ttDet.infAdProd   "YES"}
        
                PUT SKIP.
                /*fim "H"*/
                /*----------------------*/
        
                RUN pi-imprime-Prod-txt.

                RUN pi-imprime-DI-e-Adi-txt.
                
                RUN pi-imprime-DetExport-txt.
                
                RUN pi-imprime-Veic-txt.
                
                RUN pi-imprime-Med-txt.
                
                RUN pi-imprime-Arma-txt.
                
                RUN pi-imprime-Comb-txt.
                
                RUN pi-imprime-RECOPI-txt.
                
                /*----------------------*/
                PUT "M|".
                
                /*NT2013.003*/
                {adapters/xml/ep2/axsep027nodedec.i "vTotTrib" ttDet.vTotTrib "NO"  "2" "YES"} /*NT2013.003 - Valor aproximado total de tributos federais, estaduais e municipais - campo NAO obrigatorio*/
                
                PUT SKIP.
                /*fim "M"*/
                /*----------------------*/
                
                /* O grupo ISSQN Ç mutuamente exclusivo com os grupos ICMS */
                /* e II, isto Ç se ISSQN for informado os grupos ICMS e    */
                /* II n∆o ser∆o informados e viceversa (v2.0).             */
                IF  CAN-FIND (FIRST ttISSQN
                              WHERE ttISSQN.CodEstabelNF = ttDet.CodEstabelNF
                                AND ttISSQN.SerieNF      = ttDet.SerieNF     
                                AND ttISSQN.NrNotaFisNF  = ttDet.NrNotaFisNF
                                AND ttISSQN.NrSeqFatNF   = ttDet.NrSeqFatNF
                                AND ttISSQN.ItCodigoNF   = ttDet.ItCodigoNF) THEN DO:

                    RUN pi-imprime-IPI-txt. /*NF-e 3.10 - permite IPI e ISSQN no mesmo item*/
                    
                    RUN pi-imprime-ISSQN-txt.
                 
                END.
                ELSE DO:
                   
                    RUN pi-imprime-ICMS-txt.

                    RUN pi-imprime-IPI-txt.

                    RUN pi-imprime-II-txt.

                END.
        
                RUN pi-imprime-PIS-txt.
        
                RUN pi-imprime-COFINS-txt.

                RUN pi-imprime-ICMSUFDest-txt.

                RUN pi-imprime-ImpostoDevol-txt.
        
                ASSIGN iContItem = iContItem + 1.
        
            END. /* fim FOR EACH ttDet */
        
            RUN pi-imprime-Total-txt.
        
            RUN pi-imprime-Transp-txt.
        
            RUN pi-imprime-Cobr-txt.
        
            IF  CAN-FIND(FIRST ttInfAdic
                         WHERE ttInfAdic.CodEstabelNF = ttNFe.CodEstabelNF
                           AND ttInfAdic.SerieNF      = ttNFe.SerieNF     
                           AND ttInfAdic.NrNotaFisNF  = ttNFe.NrNotaFisNF
                           AND (   (ttInfAdic.infAdFisco  <> "" AND ttInfAdic.infAdFisco  <> ?)
                                OR (ttInfAdic.infCpl      <> "" AND ttInfAdic.infCpl      <> ?)))
            OR  CAN-FIND(FIRST ttObsCont
                         WHERE ttObsCont.CodEstabelNF = ttNFe.CodEstabelNF
                           AND ttObsCont.SerieNF      = ttNFe.SerieNF     
                           AND ttObsCont.NrNotaFisNF  = ttNFe.NrNotaFisNF
                           AND (ttObsCont.xTexto      <> ?
                           AND  ttObsCont.xTexto      <> ""))
             OR  CAN-FIND(FIRST ttObsFisco
                          WHERE ttObsFisco.CodEstabelNF = ttNFe.CodEstabelNF 
                            AND ttObsFisco.SerieNF      = ttNFe.SerieNF      
                            AND ttObsFisco.NrNotaFisNF  = ttNFe.NrNotaFisNF
                            AND (ttObsFisco.xTexto     <> ?
                            AND  ttObsFisco.xTexto     <> ""))
             OR  CAN-FIND(FIRST ttProcRef
                          WHERE ttProcRef.CodEstabelNF = ttNFe.CodEstabelNF
                            AND ttProcRef.SerieNF      = ttNFe.SerieNF     
                            AND ttProcRef.NrNotaFisNF  = ttNFe.NrNotaFisNF
                            AND (ttProcRef.nProc   <> ? AND ttProcRef.nProc   <> "")
                            AND (ttProcRef.indProc <> ? AND ttProcRef.indProc <> "")) THEN
                RUN pi-imprime-InfAdic-txt.
        
            RUN pi-imprime-Exporta-txt.
        
            RUN pi-imprime-Compra-txt.

            RUN pi-imprime-Cana-txt.
    
        END. /*fim FOR EACH ttNFe*/

    OUTPUT CLOSE. /*fecha arquivo*/

END PROCEDURE.


PROCEDURE pi-imprime-Ide-txt:

    FOR EACH ttIde
       WHERE ttIde.CodEstabelNF = ttNFe.CodEstabelNF
         AND ttIde.SerieNF      = ttNFe.SerieNF     
         AND ttIde.NrNotaFisNF  = ttNFe.NrNotaFisNF:

        /*B|cUF|cNF|NatOp|indPag|mod|serie|nNF|dhEmi|dhSaiEnt|tpNF|idDest|cMunFG|TpImp|TpEmis|cDV|TpAmb|finNFe|indFinal|indPres|ProcEmi|VerProc|dhCont|xJust|*/
        PUT "B" "|".
        
        {adapters/xml/ep2/axsep027nodechar.i "cUF"      ttIde.cUF      "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "cNF"      ttIde.cNF      "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "natOp"    ttIde.natOp    "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "indPag"   ttIde.indPag   "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "mod"      ttIde.mod      "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "serie"    ttIde.serie    "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "nNF"      ttIde.nNF      "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "dhEmi"    ttIde.dhEmi    "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "dhSaiEnt" ttIde.dhSaiEnt "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "tpNF"     ttIde.tpNF     "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "idDest"   ttIde.idDest   "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "cMunFG"   ttIde.cMunFG   "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "tpImp"    ttIde.tpImp    "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "tpEmis"   ttIde.tpEmis   "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "cDV"      ttIde.cDV      "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "tpAmb"    ttIde.tpAmb    "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "finNFe"   ttIde.finNFe   "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "indFinal" ttIde.indFinal "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "indPres"  ttIde.indPres  "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "procEmi"  ttIde.procEmi  "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "verProc"  ttIde.verProc  "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "dhCont"   ttIde.dhCont   "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "xJust"    ttIde.xJust    "YES"}

        PUT SKIP.
        /*fim "B"*/

        FOR EACH  ttrefNF
           WHERE  ttrefNF.CodEstabelNF = ttIde.CodEstabelNF
             AND  ttrefNF.SerieNF      = (IF ttIde.SerieNF = "" THEN "0" ELSE ttIde.SerieNF)
             AND  ttrefNF.NrNotaFisNF  = ttIde.NrNotaFisNF BREAK BY ttrefNF.refNFe descending:

            IF ttrefNF.refNFe <> "" AND 
               ttrefNF.refNFe <> ?  THEN DO:
            
                PUT "BA" "|" SKIP. /*campo pai*/
                /*BA02|refNFe|*/
                PUT "BA02" "|".
    
                {adapters/xml/ep2/axsep027nodechar.i "refNFe" ttrefNF.refNFe   "YES"}
            END.
            ELSE DO:

                PUT "BA" "|" SKIP. /*campo pai*/
                /*BA03|cUF|AAMM|CNPJ|mod|serie|nNF|*/
                PUT "BA03" "|".
    
                {adapters/xml/ep2/axsep027nodechar.i "cUF"   ttrefNF.cUF   "YES"}
                {adapters/xml/ep2/axsep027nodechar.i "AAMM"  ttrefNF.AAMM  "YES"}
                {adapters/xml/ep2/axsep027nodechar.i "CNPJ"  ttrefNF.CNPJ  "YES"}
                {adapters/xml/ep2/axsep027nodechar.i "mod"   ttrefNF.mod   "YES"}
                {adapters/xml/ep2/axsep027nodechar.i "serie" ttrefNF.serie "YES"}
                {adapters/xml/ep2/axsep027nodechar.i "nNF"   ttrefNF.nNF   "YES"}

            END.

            PUT SKIP.
            /*fim "BA02"/"BA03"*/
        END.

        FOR EACH  ttrefNFP
           WHERE  ttrefNFP.CodEstabelNF = ttIde.CodEstabelNF
             AND  ttrefNFP.SerieNF      = (IF ttIde.SerieNF = "" THEN "0" ELSE ttIde.SerieNF)
             AND  ttrefNFP.NrNotaFisNF  = ttIde.NrNotaFisNF:

            PUT "BA" "|" SKIP. /*campo pai*/
            /*BA10|cUF|AAMM|IE|mod|serie|nNF|*/
            PUT "BA10" "|".

            {adapters/xml/ep2/axsep027nodechar.i "cUF"   ttrefNFP.cUF   "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "AAMM"  ttrefNFP.AAMM  "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "IE"    ttrefNFP.IE    "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "mod"   ttrefNFP.mod   "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "serie" ttrefNFP.serie "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "nNF"   ttrefNFP.nNF   "YES"}

            PUT SKIP.
            /*fim "BA10"*/

            IF  ttrefNFP.CPF <> "":U THEN DO:
				/*BA14|CPF|*/
                PUT "BA14" "|".

                {adapters/xml/ep2/axsep027nodechar.i "CPF"  ttrefNFP.CPF  "YES"}

                PUT SKIP.
                /*fim "BA14"*/
            END.
            ELSE DO:            
				/*BA13|CNPJ|*/
                PUT "BA13" "|".

                {adapters/xml/ep2/axsep027nodechar.i "CNPJ" ttrefNFP.CNPJ "YES"}

                PUT SKIP.
                /*fim "BA13"*/			                                
            END.
        END.

        FOR EACH  ttrefCTe
           WHERE  ttrefCTe.CodEstabelNF = ttIde.CodEstabelNF
             AND  ttrefCTe.SerieNF      = (IF ttIde.SerieNF = "" THEN "0" ELSE ttIde.SerieNF)
             AND  ttrefCTe.NrNotaFisNF  = ttIde.NrNotaFisNF:

            PUT "BA" "|" SKIP. /*campo pai*/
            /*BA19|refCTe|*/
            PUT "BA19" "|".

            {adapters/xml/ep2/axsep027nodechar.i "refCTe"  ttrefCTe.refCTe  "YES"}

            PUT SKIP.
            /*fim "BA19"*/
            
        END.

        FOR EACH  ttrefECF
           WHERE  ttrefECF.CodEstabelNF = ttIde.CodEstabelNF
             AND  ttrefECF.SerieNF      = (IF ttIde.SerieNF = "" THEN "0" ELSE ttIde.SerieNF)
             AND  ttrefECF.NrNotaFisNF  = ttIde.NrNotaFisNF:

            PUT "BA" "|" SKIP. /*campo pai*/
            /*BA20|mod|nECF|nCOO|*/
            PUT "BA20" "|".

            {adapters/xml/ep2/axsep027nodechar.i "mod"   ttrefECF.mod   "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "nECF"  ttrefECF.nECF  "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "nCOO"  ttrefECF.nCOO  "YES"}

            PUT SKIP.
            /*fim "BA20"*/
            
        END.

    END.

END PROCEDURE.

PROCEDURE pi-imprime-Emit-txt:

    FOR EACH ttEmit
       WHERE ttEmit.CodEstabelNF = ttNFe.CodEstabelNF
         AND ttEmit.SerieNF      = ttNFe.SerieNF     
         AND ttEmit.NrNotaFisNF  = ttNFe.NrNotaFisNF:
        
        /*C|xNome|xFant|IE|IEST|IM|CNAE|CRT|*/
        PUT "C" "|".

        {adapters/xml/ep2/axsep027nodechar.i "xNome" ttEmit.xNome "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "xFant" ttEmit.xFant "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "IE"    ttEmit.IE    "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "IEST"  ttEmit.IEST  "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "IM"    ttEmit.IM    "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "CNAE"  ttEmit.CNAE  "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "CRT"   ttEmit.CRT   "YES"}

        PUT SKIP.
        /*fim "C"*/

        IF  ttEmit.CPF <> "" THEN DO:
            /*C02a|CPF|*/
            PUT "C02a" "|".

            {adapters/xml/ep2/axsep027nodechar.i "CPF"  ttEmit.CPF  "YES"}

            PUT SKIP.
            /*fim "C20a"*/
        END.
        ELSE DO:
            /*C02|CNPJ|*/
            PUT "C02" "|".
    
            {adapters/xml/ep2/axsep027nodechar.i "CNPJ" ttEmit.CNPJ "YES"}

            PUT SKIP.
            /*fim "C02"*/
        END.

        /*C05|xLgr|nro|xCPL|xBairro|cMun|xMun|UF|CEP|cPais|xPais|fone|*/
        PUT "C05" "|" .

        {adapters/xml/ep2/axsep027nodechar.i  "xLgr"    ttEmit.xLgr    "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "nro"     ttEmit.nro     "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "xCpl"    ttEmit.xCpl    "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "xBairro" ttEmit.xBairro "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "cMun"    ttEmit.cMun    "YES"}

        IF ttEmit.xMun = "Exterior" THEN DO:
        {adapters/xml/ep2/axsep027nodechar2.i "xMun"    ttEmit.xMun    "YES"}
        END.
        ELSE DO:
        {adapters/xml/ep2/axsep027nodechar.i  "xMun"    ttEmit.xMun    "YES"}
        END.

        {adapters/xml/ep2/axsep027nodechar.i  "UF"      ttEmit.UF      "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "CEP"     ttEmit.CEP     "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "cPais"   ttEmit.cPais   "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "xPais"   ttEmit.xPais   "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "fone"    ttEmit.fone    "YES"}
        
        PUT SKIP.
        /*fim "C05"*/
    END.

END PROCEDURE.

PROCEDURE pi-imprime-Avulsa-txt:

    FOR EACH  ttAvulsa
       WHERE  ttAvulsa.CodEstabelNF = ttNFe.CodEstabelNF
         AND  ttAvulsa.SerieNF      = ttNFe.SerieNF     
         AND  ttAvulsa.NrNotaFisNF  = ttNFe.NrNotaFisNF
         AND (ttAvulsa.CNPJ    <> "" AND ttAvulsa.CNPJ    <> ?)
         AND (ttAvulsa.xOrgao  <> "" AND ttAvulsa.xOrgao  <> ?)
         AND (ttAvulsa.matr    <> "" AND ttAvulsa.matr    <> ?)
         AND (ttAvulsa.xAgente <> "" AND ttAvulsa.xAgente <> ?)
         AND (ttAvulsa.fone    <> "" AND ttAvulsa.fone    <> ?)
         AND (ttAvulsa.UF      <> "" AND ttAvulsa.UF      <> ?)
         AND (ttAvulsa.nDAR    <> "" AND ttAvulsa.nDAR    <> ?)
         AND (ttAvulsa.vDAR    <> 0  AND ttAvulsa.vDAR    <> ?)
         AND (ttAvulsa.repEmi  <> "" AND ttAvulsa.repEmi  <> ?)
         AND (ttAvulsa.dEmi    <> ?                           ) :
        
        
        /*D|CNPJ|xOrgao|matr|xAgente|fone|UF|nDAR|dEmi|vDAR|repEmi|dPag|*/
        PUT "D" "|".

        {adapters/xml/ep2/axsep027nodechar.i "CNPJ"    ttAvulsa.CNPJ    "YES"    }
        {adapters/xml/ep2/axsep027nodechar.i "xOrgao"  ttAvulsa.xOrgao  "YES"    }
        {adapters/xml/ep2/axsep027nodechar.i "matr"    ttAvulsa.matr    "YES"    }
        {adapters/xml/ep2/axsep027nodechar.i "xAgente" ttAvulsa.xAgente "YES"    }
        {adapters/xml/ep2/axsep027nodechar.i "fone"    ttAvulsa.fone    "YES"    }
        {adapters/xml/ep2/axsep027nodechar.i "UF"      ttAvulsa.UF      "YES"    }
        {adapters/xml/ep2/axsep027nodechar.i "nDAR"    ttAvulsa.nDAR    "YES"    }
        {adapters/xml/ep2/axsep027nodedate.i "dEmi"    ttAvulsa.dEmi    "YES"    }
        {adapters/xml/ep2/axsep027nodedec.i  "vDAR"    ttAvulsa.vDAR    "YES" "2" "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "repEmi"  ttAvulsa.repEmi  "YES"    }
        {adapters/xml/ep2/axsep027nodedate.i "dPag"    ttAvulsa.dPag    "YES"    }

        PUT SKIP.
        /*fim "D"*/
    END.

END PROCEDURE.

PROCEDURE pi-imprime-Dest-txt:

    FOR EACH ttDest
       WHERE ttDest.CodEstabelNF = ttNFe.CodEstabelNF
         AND ttDest.SerieNF      = ttNFe.SerieNF     
         AND ttDest.NrNotaFisNF  = ttNFe.NrNotaFisNF:

        /*E|xNome|indIEDest|IE|ISUF|IM|email|*/
        PUT "E" "|".

        {adapters/xml/ep2/axsep027nodechar.i  "xNome"     ttDest.xNome     "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "indIEDest" ttDest.indIEDest "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "IE"        ttDest.IE        "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "ISUF"      ttDest.ISUF      "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "IM"        ttDest.IM        "YES"}
        {adapters/xml/ep2/axsep027nodechar2.i "email"     ttDest.email     "YES"}

        PUT SKIP.
        /*fim "E"*/

        IF  ttDest.i-natureza = 3 THEN DO: /*Estrangeiro*/

            /*E03a|idEstrangeiro|*/
            PUT "E03a" "|".

            {adapters/xml/ep2/axsep027nodechar.i "idEstrangeiro" ttDest.idEstrangeiro "YES"}

            PUT SKIP.
            /*fim "E03a"*/
        END.
        ELSE DO:
        
            IF  ttDest.i-natureza = 1 THEN DO: /* Pessoa Fisica */

                /*E03|CPF|*/
                PUT "E03" "|".
                
                {adapters/xml/ep2/axsep027nodechar.i "CPF"        ttDest.CPF   "YES"}

                PUT SKIP.
                /*fim "E03"*/
            END.
            ELSE DO:

                /*E02|CNPJ|*/
                PUT "E02" "|".

                {adapters/xml/ep2/axsep027nodechar.i "CNPJ"       ttDest.CNPJ  "YES"} 

                PUT SKIP.
                /*fim "E02"*/
            END.
        END.

        /*E05|xLgr|nro|xCpl|xBairro|cMun|xMun|UF|CEP|cPais|xPais|fone|*/
        PUT "E05" "|".

        {adapters/xml/ep2/axsep027nodechar.i  "xLgr"    ttDest.xLgr    "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "nro"     ttDest.nro     "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "xCpl"    ttDest.xCpl    "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "xBairro" ttDest.xBairro "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "cMun"    ttDest.cMun    "YES"}

        IF ttDest.xMun = "Exterior" THEN DO:
        {adapters/xml/ep2/axsep027nodechar2.i "xMun"    ttDest.xMun    "YES"}
        END.
        ELSE DO:
        {adapters/xml/ep2/axsep027nodechar.i  "xMun"    ttDest.xMun    "YES"}
        END.
        
        {adapters/xml/ep2/axsep027nodechar.i  "UF"      ttDest.UF      "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "CEP"     ttDest.CEP     "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "cPais"   ttDest.cPais   "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "xPais"   ttDest.xPais   "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "fone"    ttDest.fone    "YES"}
        
        PUT SKIP.
        /*fim "E05"*/
    END.

END PROCEDURE.

PROCEDURE pi-imprime-Retirada-txt:

    FOR EACH  ttRetirada
       WHERE  ttRetirada.CodEstabelNF = ttNFe.CodEstabelNF
         AND  ttRetirada.SerieNF      = ttNFe.SerieNF     
         AND  ttRetirada.NrNotaFisNF  = ttNFe.NrNotaFisNF
         AND ( (ttRetirada.CNPJ    <> "" AND ttRetirada.CNPJ    <> ?) OR
               (ttRetirada.CPF     <> "" AND ttRetirada.CPF     <> ?) )
         AND (ttRetirada.xLgr    <> "" AND ttRetirada.xLgr    <> ?)
         AND (ttRetirada.nro     <> "" AND ttRetirada.nro     <> ?)
         AND (ttRetirada.xBairro <> "" AND ttRetirada.xBairro <> ?)
         AND (ttRetirada.cMun    <> "" AND ttRetirada.cMun    <> ?)
         AND (ttRetirada.xMun    <> "" AND ttRetirada.xMun    <> ?)
         AND (ttRetirada.UF      <> "" AND ttRetirada.UF      <> ?) :

        /*F|xLgr|nro|xCpl|xBairro|cMun|xMun|UF|*/
        PUT "F" "|".

        {adapters/xml/ep2/axsep027nodechar.i "xLgr"    ttRetirada.xLgr    "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "nro"     ttRetirada.nro     "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "xCpl"    ttRetirada.xCpl    "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "xBairro" ttRetirada.xBairro "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "cMun"    ttRetirada.cMun    "YES"}
        
        IF ttRetirada.xMun = "Exterior" THEN DO:
        {adapters/xml/ep2/axsep027nodechar2.i "xMun"   ttRetirada.xMun    "YES"}
        END.
        ELSE DO:
        {adapters/xml/ep2/axsep027nodechar.i  "xMun"   ttRetirada.xMun    "YES"}
        END.

        {adapters/xml/ep2/axsep027nodechar.i "UF"      ttRetirada.UF      "YES"}

        PUT SKIP.
        /*fim "F"*/

        IF  ttRetirada.CPF <> "" THEN DO:

            /*F02a|CPF|*/
            PUT "F02a" "|".

            {adapters/xml/ep2/axsep027nodechar.i "CPF"     ttRetirada.CPF     "YES"}

            PUT SKIP.
            /*fim "F02a"*/
        END.
	    ELSE DO:

            /*F02|CNPJ|*/
            PUT "F02" "|".
            
            {adapters/xml/ep2/axsep027nodechar.i "CNPJ"    ttRetirada.CNPJ    "YES"}

            PUT SKIP.
            /*fim "F02"*/
	    END.

    END.

END PROCEDURE.

PROCEDURE pi-imprime-Entrega-txt:

    FOR EACH  ttEntrega
       WHERE  ttEntrega.CodEstabelNF = ttNFe.CodEstabelNF
         AND  ttEntrega.SerieNF      = ttNFe.SerieNF     
         AND  ttEntrega.NrNotaFisNF  = ttNFe.NrNotaFisNF
         AND (ttEntrega.CNPJ    <> ? OR
              ttEntrega.CPF     <> ?)
         AND (ttEntrega.xLgr    <> "" AND ttEntrega.xLgr    <> ?)
         AND (ttEntrega.nro     <> "" AND ttEntrega.nro     <> ?)
         AND (ttEntrega.xBairro <> "" AND ttEntrega.xBairro <> ?)
         AND (ttEntrega.cMun    <> "" AND ttEntrega.cMun    <> ?)
         AND (ttEntrega.xMun    <> "" AND ttEntrega.xMun    <> ?)
         AND (ttEntrega.UF      <> "" AND ttEntrega.UF      <> ?) :

        /*G|xLgr|nro|xCpl|xBairro|cMun|xMun|UF|*/
        PUT "G" "|".

        {adapters/xml/ep2/axsep027nodechar.i  "xLgr"    ttEntrega.xLgr    "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "nro"     ttEntrega.nro     "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "xCpl"    ttEntrega.xCpl    "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "xBairro" ttEntrega.xBairro "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "cMun"    ttEntrega.cMun    "YES"}
        
        IF ttEntrega.xMun = "Exterior" THEN DO:
        {adapters/xml/ep2/axsep027nodechar2.i "xMun"    ttEntrega.xMun    "YES"}
        END.
        ELSE DO:
        {adapters/xml/ep2/axsep027nodechar.i  "xMun"    ttEntrega.xMun    "YES"}
        END.
        
        {adapters/xml/ep2/axsep027nodechar.i  "UF"      ttEntrega.UF      "YES"}

        PUT SKIP.
        /*fim "G"*/

        IF  ttEntrega.CPF <> "" THEN DO:

            /*G02a|CPF|*/
            PUT "G02a" "|".

            {adapters/xml/ep2/axsep027nodechar.i "CPF"     ttEntrega.CPF     "YES"}

            PUT SKIP.
            /*fim "G02a"*/
        END.
        ELSE DO:

            /*G02|CNPJ|*/
            PUT "G02" "|".

            {adapters/xml/ep2/axsep027nodechar.i "CNPJ"    ttEntrega.CNPJ    "YES"}

            PUT SKIP.
            /*fim "G02"*/
        END.

    END.

END PROCEDURE.

PROCEDURE pi-imprime-AutXML-txt:

    FOR EACH  ttAutXML
       WHERE  ttAutXML.CodEstabelNF = ttNFe.CodEstabelNF
         AND  ttAutXML.SerieNF      = ttNFe.SerieNF     
         AND  ttAutXML.NrNotaFisNF  = ttNFe.NrNotaFisNF
         AND (ttAutXML.CNPJ    <> ? OR
              ttAutXML.CPF     <> ?) :

        /*
        GA|
        [seleá∆o entre GA02 ou GA03]{
        GA02|CNPJ|
        [ou]
        GA03|CPF|
        */

        PUT "GA" "|" SKIP.
    
        IF  ttAutXML.CPF <> "":U THEN DO:

            /*GA03|CPF|*/
            PUT "GA03" "|".

            {adapters/xml/ep2/axsep027nodechar.i "CPF"     ttAutXML.CPF     "YES"}

            PUT SKIP.
            /*fim "GA03"*/
        END.
        ELSE DO:

            /*GA02|CNPJ|*/
            PUT "GA02" "|".

            {adapters/xml/ep2/axsep027nodechar.i "CNPJ"    ttAutXML.CNPJ    "YES"}

            PUT SKIP.
            /*fim "GA02"*/
        END. 
    END.

END PROCEDURE.

PROCEDURE pi-imprime-Prod-txt:

        /*I|cProd|cEAN|xProd|NCM|EXTIPI|CFOP|uCom|qCom|vUnCom|vProd|cEANTrib|uTrib|qTrib|vUnTrib|vFrete|vSeg|vDesc|vOutro|indTot|xPed|nItemPed|nFCI|*/
        PUT "I" "|".
        
        {adapters/xml/ep2/axsep027nodechar2.i "cProd"    ttDet.cProd    "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "cEAN"     ttDet.cEAN     "YES"}
        {adapters/xml/ep2/axsep027nodechar2.i "xProd"    ttDet.xProd    "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "NCM"      ttDet.NCM      "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "EXTIPI"   ttDet.EXTIPI   "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "CFOP"     ttDet.CFOP     "YES"}
        {adapters/xml/ep2/axsep027nodechar2.i "uCom"     ttDet.uCom     "YES"}
        {adapters/xml/ep2/axsep027nodedec.i   "qCom"     ttDet.qCom     "YES" "4"  "NO" }
        {adapters/xml/ep2/axsep027nodedec.i   "vUnCom"   ttDet.vUnCom   "YES" fn-retorna-nro-decimais-nfe-FT0301() "NO" } /*n∆o enviar sempre 10 decimais, e sim o que estiver parametrizado no FT0301*/
        {adapters/xml/ep2/axsep027nodedec.i   "vProd"    ttDet.vProd    "YES" "2"  "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "cEANTrib" ttDet.cEANTrib "YES"}
        {adapters/xml/ep2/axsep027nodechar2.i "uTrib"    ttDet.uTrib    "YES"}
        {adapters/xml/ep2/axsep027nodedec.i   "qTrib"    ttDet.qTrib    "YES" "4"  "NO" } 
        {adapters/xml/ep2/axsep027nodedec.i   "vUnTrib"  ttDet.vUnTrib  "YES" fn-retorna-nro-decimais-nfe-FT0301() "NO" } /*n∆o enviar sempre 10 decimais, e sim o que estiver parametrizado no FT0301*/
        {adapters/xml/ep2/axsep027nodedec.i   "vFrete"   ttDet.vFrete   "YES" "2"  "YES"}
        {adapters/xml/ep2/axsep027nodedec.i   "vSeg"     ttDet.vSeg     "YES" "2"  "YES"}
        {adapters/xml/ep2/axsep027nodedec.i   "vDesc"    ttDet.vDesc    "YES" "2"  "YES"}
        {adapters/xml/ep2/axsep027nodedec.i   "vOutro"   ttDet.vOutro   "YES" "2"  "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "indTot"   ttDet.indTot   "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "xPed"     ttDet.xPed     "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "nItemPed" ttDet.nItemPed "YES"}
        {adapters/xml/ep2/axsep027nodechar.i  "nFCI"     ttDet.nFCI     "YES"}

        PUT SKIP.
        /*fim "I"*/

        DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.

        DO i-cont = 1 TO 8: /* NVE tipo extent de 8 */

            IF  ttDet.NVE[i-cont] <> "":U
            AND ttDet.NVE[i-cont] <> ? THEN DO:
    
                /*I05a|NVE|*/
                PUT "I05a" "|".
    
                {adapters/xml/ep2/axsep027nodechar.i  "NVE"      ttDet.NVE[i-cont]   "NO" }
    
                PUT SKIP.
                /*fim "I05a"*/
            END.
        END.

        /*C¢digo CEST*/
        IF  ttDet.CEST <> "":U THEN DO:
        
            /*I05c|CEST|*/
            PUT "I05c" "|".
    
            {adapters/xml/ep2/axsep027nodechar.i  "CEST"     ttDet.CEST     "NO" }
    
            PUT SKIP.
            /*fim "I05c"*/
        END.
        
END PROCEDURE.

PROCEDURE pi-imprime-DI-e-Adi-txt:

        DEF VAR c-vDescDI AS CHAR NO-UNDO.

        FOR EACH  ttDI NO-LOCK /*Apenas 1 ttDI para nota, e v†rios ttAdi para os itens*/
           WHERE  ttDI.CodEstabelNF = ttDet.CodEstabelNF
             AND  ttDI.SerieNF      = ttDet.SerieNF     
             AND  ttDI.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND (ttDI.nDI         <> "" AND ttDI.nDI         <> ?)
             AND (ttDI.dDI         <> ?                           )
             AND (ttDI.xLocDesemb  <> "" AND ttDI.xLocDesemb  <> ?)
             AND (ttDI.UFDesemb    <> "" AND ttDI.UFDesemb    <> ?)
             AND (ttDI.dDesemb     <> ?                           )
             AND (ttDI.cExportador <> "" AND ttDI.cExportador <> ?) :

            /*I18|nDI|dDI|xLocDesemb|UFDesemb|dDesemb|tpViaTransp|vAFRMM|tpIntermedio|CNPJ|UFTerceiro|cExportador|*/
            PUT "I18" "|".

            {adapters/xml/ep2/axsep027nodechar.i "nDI"          ttDI.nDI          "YES"}
            {adapters/xml/ep2/axsep027nodedate.i "dDI"          ttDI.dDI          "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "xLocDesemb"   ttDI.xLocDesemb   "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "UFDesemb"     ttDI.UFDesemb     "YES"}
            {adapters/xml/ep2/axsep027nodedate.i "dDesemb"      ttDI.dDesemb      "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "tpViaTransp"  ttDI.tpViaTransp  "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vAFRMM"       ttDI.vAFRMM       "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "tpIntermedio" ttDI.tpIntermedio "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "CNPJ"         ttDI.CNPJ         "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "UFTerceiro"   ttDI.UFTerceiro   "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "cExportador"  ttDI.cExportador  "YES"}

            PUT SKIP.
            /*fim "I18"*/

            FOR EACH ttAdi NO-LOCK
               WHERE ttAdi.CodEstabelNF = ttDet.CodEstabelNF
                 AND ttAdi.SerieNF      = ttDet.SerieNF     
                 AND ttAdi.NrNotaFisNF  = ttDet.NrNotaFisNF 
                 AND ttAdi.NrSeqFatNF   = ttDet.NrSeqFatNF  
                 AND ttAdi.ItCodigoNF   = ttDet.ItCodigoNF  
                 AND ttAdi.nDI          = ttDI.nDI:

                /*I25|nAdicao|nSeqAdic|cFabricante|vDescDI|nDraw|*/
                PUT "I25" "|".

                {adapters/xml/ep2/axsep027nodechar.i "nAdicao"     ttAdi.nAdicao     "YES"    }
                {adapters/xml/ep2/axsep027nodechar.i "nSeqAdic"    ttAdi.nSeqAdic    "YES"    }
                {adapters/xml/ep2/axsep027nodechar.i "cFabricante" ttAdi.cFabricante "YES"    }
                IF ttAdi.vDescDI <> 0 THEN DO:
                   {adapters/xml/ep2/axsep027nodedec.i   "vDescDI"     ttAdi.vDescDI     "YES" "2" "YES"}
                END.
                IF ttAdi.vDescDI = 0 THEN DO:
                   {adapters/xml/ep2/axsep027nodechar.i  "vDescDI"     c-vDescDI     "YES" }
                END.

                {adapters/xml/ep2/axsep027nodechar.i  "nDraw"     nDraw     "YES" }

                PUT SKIP.
                /*fim "I25"*/
            END.
        END.

END PROCEDURE.

PROCEDURE pi-imprime-DetExport-txt:

    FOR EACH ttDetExport NO-LOCK
       WHERE ttDetExport.CodEstabelNF = ttDet.CodEstabelNF
         AND ttDetExport.SerieNF      = ttDet.SerieNF     
         AND ttDetExport.NrNotaFisNF  = ttDet.NrNotaFisNF 
         AND ttDetExport.NrSeqFatNF   = ttDet.NrSeqFatNF
         AND ttDetExport.ItCodigoNF   = ttDet.ItCodigoNF:

        /*
        I50|nDraw|
        I52|nRE|chNFe|qExport|
        */
    
        /*I50|*/
        PUT "I50" "|".
    
        IF (ttDetExport.nDraw <> "":U AND ttDetExport.nDraw <> ?) THEN DO:

            /* nDraw| */
            {adapters/xml/ep2/axsep027nodechar.i "nDraw"     ttDetExport.nDraw     "YES" }
            
            /*fim "I50"*/
        END.
        PUT SKIP.
        

        /*Grupo "exportInd" nao obrigatorio, mas se for gerado, os 3 campos "nRE, chNFe e qExport" s∆o obrigatorios*/
        IF  (ttDetExport.nRE     <> ? AND ttDetExport.nRE     <> "")
        AND (ttDetExport.chNFe   <> ? AND ttDetExport.chNFe   <> "")
        AND (ttDetExport.qExport <> ? AND ttDetExport.qExport <> 0 ) THEN DO:

            /*I52|nRE|chNFe|qExport|*/
            PUT "I52" "|".
    
            {adapters/xml/ep2/axsep027nodechar.i "nRE"     ttDetExport.nRE              "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "chNFe"   ttDetExport.chNFe            "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "qExport" ttDetExport.qExport "NO" "4" "YES"}

            PUT SKIP.
            /*fim "I52"*/
        END.
    END.

END PROCEDURE.

PROCEDURE pi-imprime-Veic-txt:

        FOR EACH ttVeic
           WHERE ttVeic.CodEstabelNF = ttDet.CodEstabelNF
             AND ttVeic.SerieNF      = ttDet.SerieNF     
             AND ttVeic.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttVeic.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttVeic.ItCodigoNF   = ttDet.ItCodigoNF :

            /*J|tpOp|chassi|cCor|xCor|pot|cilin|pesoL|pesoB|nSerie|tpComb|nMotor|CMT|dist|anoMod|anoFab|tpPint|tpVeic|espVeic|VIN|condVeic|cMod|cCorDENATRAN|lota|tpRest|*/
            PUT "J" "|".

            {adapters/xml/ep2/axsep027nodechar.i "tpOp"          ttVeic.tpOp          "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "chassi"        ttVeic.chassi        "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "cCor"          ttVeic.cCor          "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "xCor"          ttVeic.xCor          "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "pot"           ttVeic.pot           "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "cilin"         ttVeic.cilin         "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "pesoL"         ttVeic.pesoL         "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "pesoB"         ttVeic.pesoB         "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "nSerie"        ttVeic.nSerie        "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "tpComb"        ttVeic.tpComb        "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "nMotor"        ttVeic.nMotor        "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "CMT"           ttVeic.CMT           "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "dist"          ttVeic.dist          "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "anoMod"        ttVeic.anoMod        "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "anoFab"        ttVeic.anoFab        "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "tpPint"        ttVeic.tpPint        "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "tpVeic"        ttVeic.tpVeic        "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "espVeic"       ttVeic.espVeic       "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "VIN"           ttVeic.VIN           "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "condVeic"      ttVeic.condVeic      "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "cMod"          ttVeic.cMod          "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "cCorDENATRAN"  ttVeic.cCorDENATRAN  "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "lota"          ttVeic.lota          "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "tpRest"        ttVeic.tpRest        "YES"}

            PUT SKIP.
            /*fim "J"*/
        END.

END PROCEDURE.

PROCEDURE pi-imprime-Med-txt:

        FOR EACH  ttMed
           WHERE  ttMed.CodEstabelNF = ttDet.CodEstabelNF
             AND  ttMed.SerieNF      = ttDet.SerieNF     
             AND  ttMed.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND  ttMed.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND  ttMed.ItCodigoNF   = ttDet.ItCodigoNF 
             AND (ttMed.nLote <> ?
             AND  ttMed.qLote <> ?
             AND  ttMed.dFab  <> ?
             AND  ttMed.dVal  <> ?
             AND  ttMed.vPMC  <> ?) :

            /*K|nLote|qLote|dFab|dVal|vPMC|*/
            PUT "K" "|".

            {adapters/xml/ep2/axsep027nodechar.i "nLote" ttMed.nLote "YES"    }
            {adapters/xml/ep2/axsep027nodedec.i  "qLote" ttMed.qLote "YES" "3" "YES"}
            {adapters/xml/ep2/axsep027nodedate.i "dFab"  ttMed.dFab  "YES"    }
            {adapters/xml/ep2/axsep027nodedate.i "dVal"  ttMed.dVal  "YES"    }
            {adapters/xml/ep2/axsep027nodedec.i  "vPMC"  ttMed.vPMC  "YES" "2" "YES"}

            PUT SKIP.
            /*fim "K"*/
        END.

END PROCEDURE.

PROCEDURE pi-imprime-Arma-txt:

        FOR EACH  ttArma
           WHERE  ttArma.CodEstabelNF = ttDet.CodEstabelNF
             AND  ttArma.SerieNF      = ttDet.SerieNF     
             AND  ttArma.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND  ttArma.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND  ttArma.ItCodigoNF   = ttDet.ItCodigoNF 
             AND (ttArma.tpArma <> ?
             AND  ttArma.nSerie <> ?
             AND  ttArma.nCano  <> ?
             AND  ttArma.descr  <> ?) :

            /*L|tpArma|nSerie|nCano|descr|*/
            PUT "L" "|".

            {adapters/xml/ep2/axsep027nodechar.i "tpArma" ttArma.tpArma "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "nSerie" ttArma.nSerie "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "nCano"  ttArma.nCano  "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "descr"  ttArma.descr  "YES"}

            PUT SKIP.
            /*fim "L"*/
        END.

END PROCEDURE.

PROCEDURE pi-imprime-Comb-txt:

        FOR EACH ttComb
           WHERE ttComb.CodEstabelNF = ttDet.CodEstabelNF
             AND ttComb.SerieNF      = ttDet.SerieNF     
             AND ttComb.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttComb.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttComb.ItCodigoNF   = ttDet.ItCodigoNF :

            /*LA|cProdANP|pMixGN|CODIF|qTemp|UFCons|*/
            PUT "LA" "|".

            {adapters/xml/ep2/axsep027nodechar.i "cProdANP" ttComb.cProdANP "YES"    }
            {adapters/xml/ep2/axsep027nodedec.i  "pMixGN"   ttComb.pMixGN   "YES" "4" "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "CODIF"    ttComb.CODIF    "YES"    }
            {adapters/xml/ep2/axsep027nodedec.i  "qTemp"    ttComb.qTemp    "YES" "4" "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "UFCons"   ttComb.UFCons   "YES"    }
            
            PUT SKIP.
            /*fim "LA"*/

            IF  ttComb.qBCProd   <> ?
            AND ttComb.vAliqProd <> ?
            AND ttComb.vCIDE     <> ? THEN DO:

                /*LA07|qBCProd|vAliqProd|vCIDE|*/
                PUT "LA07" "|".

                {adapters/xml/ep2/axsep027nodedec.i "qBCProd"   ttComb.qBCProd   "YES" "4" "YES"}
                {adapters/xml/ep2/axsep027nodedec.i "vAliqProd" ttComb.vAliqProd "YES" "4" "YES"}
                {adapters/xml/ep2/axsep027nodedec.i "vCIDE"     ttComb.vCIDE     "YES" "2" "YES"}

                PUT SKIP.
                /*fim "LA07"*/
            END.

            /*  ++++ SOFTWARE EMISSOR AINDA N«O ALTERADO PARA CONTEMPLAR NOVOS CAMPOS ++++
            IF (ttComb.nBico   <> ?
            OR  ttComb.nBomba  <> ?
            OR  ttComb.nTanque <> ?
            OR  ttComb.vEncIni <> ?
            OR  ttComb.vEncFin <> ?) THEN DO:

                
    
                {adapters/xml/ep2/axsep027nodechar.i "nBico  "   ttComb.nBico     "YES"}
                {adapters/xml/ep2/axsep027nodechar.i "nBomba "   ttComb.nBomba    "NO" }
                {adapters/xml/ep2/axsep027nodechar.i "nTanque"   ttComb.nTanque   "YES"}
                {adapters/xml/ep2/axsep027nodedec.i  "vEncIni"   ttComb.vEncIni   "YES" "3" "YES"}
                {adapters/xml/ep2/axsep027nodedec.i  "vEncFin"   ttComb.vEncFin   "YES" "3" "YES"}

                
            END.
            */
            
        END.

END PROCEDURE.

PROCEDURE pi-imprime-RECOPI-txt:

        IF (ttDet.nRECOPI <> "":U AND ttDet.nRECOPI <> ?) THEN DO:

            /*LB|nRECOPI|*/
            PUT "LB" "|".
        
            {adapters/xml/ep2/axsep027nodechar.i  "nRECOPI"  ttDet.nRECOPI  "YES"     }
        
            PUT SKIP.
            /*fim "LB"*/
        END.

END PROCEDURE.

PROCEDURE pi-imprime-ICMS-txt:

        PUT "N|" SKIP.

        FOR EACH ttICMS00
           WHERE ttICMS00.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMS00.SerieNF      = ttDet.SerieNF
             AND ttICMS00.NrNotaFisNF  = ttDet.NrNotaFisNF
             AND ttICMS00.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMS00.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N02|orig|CST|modBC|vBC|pICMS|vICMS|*/
            PUT "N02" "|".

            {adapters/xml/ep2/axsep027nodechar.i "orig"  ttICMS00.orig  "YES"    }
            {adapters/xml/ep2/axsep027nodechar.i "CST"   ttICMS00.CST   "YES"    }
            {adapters/xml/ep2/axsep027nodechar.i "modBC" ttICMS00.modBC "YES"    }
            {adapters/xml/ep2/axsep027nodedec.i  "vBC"   ttICMS00.vBC   "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pICMS" ttICMS00.pICMS "YES" "4" "NO "}
            {adapters/xml/ep2/axsep027nodedec.i  "vICMS" ttICMS00.vICMS "YES" "2" "YES"}

            PUT SKIP.
            /*fim "N02"*/
        END.

        FOR EACH ttICMS10
           WHERE ttICMS10.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMS10.SerieNF      = ttDet.SerieNF     
             AND ttICMS10.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMS10.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMS10.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N03|orig|CST|modBC|vBC|pICMS|vICMS|modBCST|pMVAST|pRedBCST|vBCST|pICMSST|vICMSST|*/
            PUT "N03" "|".

            {adapters/xml/ep2/axsep027nodechar.i "orig"     ttICMS10.orig     "YES"    }
            {adapters/xml/ep2/axsep027nodechar.i "CST"      ttICMS10.CST      "YES"    }
            {adapters/xml/ep2/axsep027nodechar.i "modBC"    ttICMS10.modBC    "YES"    }
            {adapters/xml/ep2/axsep027nodedec.i  "vBC"      ttICMS10.vBC      "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pICMS"    ttICMS10.pICMS    "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vICMS"    ttICMS10.vICMS    "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "modBCST"  ttICMS10.modBCST  "YES"    }
            {adapters/xml/ep2/axsep027nodedec.i  "pMVAST"   ttICMS10.pMVAST   "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "pRedBCST" ttICMS10.pRedBCST "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vBCST"    ttICMS10.vBCST    "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pICMSST"  ttICMS10.pICMSST  "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vICMSST"  ttICMS10.vICMSST  "YES" "2" "YES"}

            PUT SKIP.
            /*fim "N03"*/
        END.

        FOR EACH ttICMS20
           WHERE ttICMS20.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMS20.SerieNF      = ttDet.SerieNF     
             AND ttICMS20.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMS20.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMS20.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N04|orig|CST|modBC|pRedBC|vBC|pICMS|vICMS|vICMSDeson|motDesICMS| */
            PUT "N04" "|".

            {adapters/xml/ep2/axsep027nodechar.i "orig"       ttICMS20.orig        "YES"    }
            {adapters/xml/ep2/axsep027nodechar.i "CST"        ttICMS20.CST         "YES"    }
            {adapters/xml/ep2/axsep027nodechar.i "modBC"      ttICMS20.modBC       "YES"    }
            {adapters/xml/ep2/axsep027nodedec.i  "pRedBC"     ttICMS20.pRedBC      "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vBC"        ttICMS20.vBC         "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pICMS"      ttICMS20.pICMS       "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vICMS"      ttICMS20.vICMS       "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vICMSDeson" ttICMS20.vICMSDeson  "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "motDesICMS" ttICMS20.motDesICMS  "YES"}
            
            PUT SKIP.
            /*fim "N04"*/
        END.

        FOR EACH ttICMS30
           WHERE ttICMS30.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMS30.SerieNF      = ttDet.SerieNF     
             AND ttICMS30.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMS30.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMS30.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N05|orig|CST|modBCST|pMVAST|pRedBCST|vBCST|pICMSST|vICMSST|vICMSDeson|motDesICMS|*/
            PUT "N05" "|".

            {adapters/xml/ep2/axsep027nodechar.i "orig"       ttICMS30.orig       "YES"    }
            {adapters/xml/ep2/axsep027nodechar.i "CST"        ttICMS30.CST        "YES"    }
            {adapters/xml/ep2/axsep027nodechar.i "modBCST"    ttICMS30.modBCST    "YES"    }
            {adapters/xml/ep2/axsep027nodedec.i  "pMVAST"     ttICMS30.pMVAST     "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "pRedBCST"   ttICMS30.pRedBCST   "YES" "4" "NO" } 
            {adapters/xml/ep2/axsep027nodedec.i  "vBCST"      ttICMS30.vBCST      "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pICMSST"    ttICMS30.pICMSST    "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vICMSST"    ttICMS30.vICMSST    "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vICMSDeson" ttICMS30.vICMSDeson "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "motDesICMS" ttICMS30.motDesICMS "YES"}

            PUT SKIP.
            /*fim "N05"*/
        END.

        FOR EACH ttICMS40
           WHERE ttICMS40.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMS40.SerieNF      = ttDet.SerieNF     
             AND ttICMS40.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMS40.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMS40.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N06|orig|CST|vICMSDeson|motDesICMS|*/
            PUT "N06" "|".

            {adapters/xml/ep2/axsep027nodechar.i "orig"        ttICMS40.orig        "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "CST"         ttICMS40.CST         "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vICMSDeson"  ttICMS40.vICMSDeson  "YES"  "2" "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "motDesICMS"  ttICMS40.motDesICMS  "YES" }

            PUT SKIP.
            /*fim "N06"*/
        END.

        FOR EACH ttICMS51
           WHERE ttICMS51.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMS51.SerieNF      = ttDet.SerieNF     
             AND ttICMS51.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMS51.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMS51.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N07|orig|CST|modBC|pRedBC|vBC|pICMS|vICMSOp|pDif|vICMSDif|vICMS|*/
            PUT "N07" "|".

            {adapters/xml/ep2/axsep027nodechar.i "orig"     ttICMS51.orig     "YES"    }
            {adapters/xml/ep2/axsep027nodechar.i "CST"      ttICMS51.CST      "YES"    }
            {adapters/xml/ep2/axsep027nodechar.i "modBC"    ttICMS51.modBC    "YES"    }
            {adapters/xml/ep2/axsep027nodedec.i  "pRedBC"   ttICMS51.pRedBC   "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vBC"      ttICMS51.vBC      "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pICMS"    ttICMS51.pICMS    "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vICMSOp"  ttICMS51.vICMSOp  "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pDif"     ttICMS51.pDif     "YES" "4" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vICMSDif" ttICMS51.vICMSDif "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vICMS"    ttICMS51.vICMS    "YES" "2" "YES"}

            PUT SKIP.
            /*fim "N07"*/
        END.

        FOR EACH ttICMS60
           WHERE ttICMS60.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMS60.SerieNF      = ttDet.SerieNF     
             AND ttICMS60.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMS60.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMS60.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N08|orig|CST|vBCSTRet|vICMSSTRet|*/
            PUT "N08" "|".
    
            {adapters/xml/ep2/axsep027nodechar.i "orig"       ttICMS60.orig       "YES"    }
            {adapters/xml/ep2/axsep027nodechar.i "CST"        ttICMS60.CST        "YES"    }
            {adapters/xml/ep2/axsep027nodedec.i  "vBCSTRet"   ttICMS60.vBCSTRet   "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vICMSSTRet" ttICMS60.vICMSSTRet "YES" "2" "YES"}
        
            PUT SKIP.
            /*fim "N08"*/
        END.

        FOR EACH ttICMS70
           WHERE ttICMS70.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMS70.SerieNF      = ttDet.SerieNF     
             AND ttICMS70.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMS70.NrSeqFatNF   = ttDet.NrSeqFatNF 
             AND ttICMS70.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N09|orig|CST|modBC|pRedBC|vBC|pICMS|vICMS|modBCST|pMVAST|pRedBCST|vBCST|pICMSST|vICMSST|vICMSDeson|motDesICMS| */
            PUT "N09" "|".

            {adapters/xml/ep2/axsep027nodechar.i "orig"       ttICMS70.orig       "YES"    }
            {adapters/xml/ep2/axsep027nodechar.i "CST"        ttICMS70.CST        "YES"    }
            {adapters/xml/ep2/axsep027nodechar.i "modBC"      ttICMS70.modBC      "YES"    }
            {adapters/xml/ep2/axsep027nodedec.i  "pRedBC"     ttICMS70.pRedBC     "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vBC"        ttICMS70.vBC        "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pICMS"      ttICMS70.pICMS      "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vICMS"      ttICMS70.vICMS      "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "modBCST"    ttICMS70.modBCST    "YES"    }
            {adapters/xml/ep2/axsep027nodedec.i  "pMVAST"     ttICMS70.pMVAST     "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "pRedBCST"   ttICMS70.pRedBCST   "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vBCST"      ttICMS70.vBCST      "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pICMSST"    ttICMS70.pICMSST    "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vICMSST"    ttICMS70.vICMSST    "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vICMSDeson" ttICMS70.vICMSDeson "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "motDesICMS" ttICMS70.motDesICMS "YES"}

            PUT SKIP.
            /*fim "N09"*/
        END.

        FOR EACH ttICMS90
           WHERE ttICMS90.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMS90.SerieNF      = ttDet.SerieNF     
             AND ttICMS90.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMS90.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMS90.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N10|orig|CST|modBC|vBC|pRedBC|pICMS|vICMS|modBCST|pMVAST|pRedBCST|vBCST|pICMSST|vICMSST|vICMSDeson|motDesICMS| */
            PUT "N10" "|".

            {adapters/xml/ep2/axsep027nodechar.i "orig"       ttICMS90.orig       "YES"    }
            {adapters/xml/ep2/axsep027nodechar.i "CST"        ttICMS90.CST        "YES"    }
            {adapters/xml/ep2/axsep027nodechar.i "modBC"      ttICMS90.modBC      "YES"    }
            {adapters/xml/ep2/axsep027nodedec.i  "vBC"        ttICMS90.vBC        "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pRedBC"     ttICMS90.pRedBC     "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "pICMS"      ttICMS90.pICMS      "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vICMS"      ttICMS90.vICMS      "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "modBCST"    ttICMS90.modBCST    "YES"    }
            {adapters/xml/ep2/axsep027nodedec.i  "pMVAST"     ttICMS90.pMVAST     "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "pRedBCST"   ttICMS90.pRedBCST   "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vBCST"      ttICMS90.vBCST      "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pICMSST"    ttICMS90.pICMSST    "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vICMSST"    ttICMS90.vICMSST    "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vICMSDeson" ttICMS90.vICMSDeson "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "motDesICMS" ttICMS90.motDesICMS "YES"}

            PUT SKIP.
            /*fim "N10"*/
        END.

        FOR EACH ttICMSPart
           WHERE ttICMSPart.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMSPart.SerieNF      = ttDet.SerieNF     
             AND ttICMSPart.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMSPart.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMSPart.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N10a|orig|CST|modBC|vBC|pRedBC|pICMS|vICMS|modBCST|pMVAST|pRedBCST|vBCST|pICMSST|vICMSST|pBCOp|UFST|*/
            PUT "N10a" "|".

            {adapters/xml/ep2/axsep027nodechar.i "orig"     ttICMSPart.orig     "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "CST"      ttICMSPart.CST      "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "modBC"    ttICMSPart.modBC    "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vBC"      ttICMSPart.vBC      "YES"  "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pRedBC"   ttICMSPart.pRedBC   "YES"  "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "pICMS"    ttICMSPart.pICMS    "YES"  "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vICMS"    ttICMSPart.vICMS    "YES"  "2" "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "modBCST"  ttICMSPart.modBCST  "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pMVAST"   ttICMSPart.pMVAST   "YES"  "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "pRedBCST" ttICMSPart.pRedBCST "YES"  "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vBCST"    ttICMSPart.vBCST    "YES"  "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pICMSST"  ttICMSPart.pICMSST  "YES"  "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vICMSST"  ttICMSPart.vICMSST  "YES"  "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pBCOp"    ttICMSPart.pBCOp    "YES"  "4" "NO" }
            {adapters/xml/ep2/axsep027nodechar.i "UFST"     ttICMSPart.UFST     "YES"}
            
            PUT SKIP.
            /*fim "N10a"*/
        END.

        FOR EACH ttICMSST
           WHERE ttICMSST.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMSST.SerieNF      = ttDet.SerieNF     
             AND ttICMSST.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMSST.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMSST.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N10b|orig|CST|vBCSTRet|vICMSSTRet|vBCSTDest|vICMSSTDest|*/
            PUT "N10b" "|".

            {adapters/xml/ep2/axsep027nodechar.i "orig"         ttICMSST.orig        "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "CST"          ttICMSST.CST         "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vBCSTRet"     ttICMSST.vBCSTRet    "YES"  "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vICMSSTRet"   ttICMSST.vICMSSTRet  "YES"  "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vBCSTDest"    ttICMSST.vBCSTDest   "YES"  "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vICMSSTDest"  ttICMSST.vICMSSTDest "YES"  "2" "YES"}

            PUT SKIP.
            /*fim "N10b"*/
        END.

        FOR EACH ttICMSSN101
           WHERE ttICMSSN101.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMSSN101.SerieNF      = ttDet.SerieNF     
             AND ttICMSSN101.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMSSN101.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMSSN101.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N10c|orig|CSOSN|pCredSN|vCredICMSSN|*/
            PUT "N10c" "|".

            {adapters/xml/ep2/axsep027nodechar.i "orig"         ttICMSSN101.orig        "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "CSOSN"        ttICMSSN101.CSOSN       "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pCredSN"      ttICMSSN101.pCredSN     "YES"  "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vCredICMSSN"  ttICMSSN101.vCredICMSSN "YES"  "2" "YES"}

            PUT SKIP.
            /*fim "N10c"*/
        END.

        FOR EACH ttICMSSN102
           WHERE ttICMSSN102.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMSSN102.SerieNF      = ttDet.SerieNF     
             AND ttICMSSN102.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMSSN102.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMSSN102.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N10d|orig|CSOSN|*/
            PUT "N10d" "|".

            {adapters/xml/ep2/axsep027nodechar.i "orig"         ttICMSSN102.orig        "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "CSOSN"        ttICMSSN102.CSOSN       "YES"}

            PUT SKIP.
            /*fim "N10d"*/
        END.

        FOR EACH ttICMSSN201
           WHERE ttICMSSN201.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMSSN201.SerieNF      = ttDet.SerieNF     
             AND ttICMSSN201.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMSSN201.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMSSN201.ItCodigoNF   = ttDet.ItCodigoNF :
            
            /*N10e|orig|CSOSN|modBCST|pMVAST|pRedBCST|vBCST|pICMSST|vICMSST|pCredSN|vCredICMSSN|*/
            PUT "N10e" "|".

            {adapters/xml/ep2/axsep027nodechar.i "orig"         ttICMSSN201.orig         "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "CSOSN"        ttICMSSN201.CSOSN        "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "modBCST"      ttICMSSN201.modBCST      "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pMVAST"       ttICMSSN201.pMVAST       "YES"  "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "pRedBCST"     ttICMSSN201.pRedBCST     "YES"  "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vBCST"        ttICMSSN201.vBCST        "YES"  "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pICMSST"      ttICMSSN201.pICMSST      "YES"  "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vICMSST"      ttICMSSN201.vICMSST      "YES"  "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pCredSN"      ttICMSSN201.pCredSN      "YES"  "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vCredICMSSN"  ttICMSSN201.vCredICMSSN  "YES"  "2" "YES"}
            
            PUT SKIP.
            /*fim "N10e"*/
        END.

        FOR EACH ttICMSSN202
           WHERE ttICMSSN202.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMSSN202.SerieNF      = ttDet.SerieNF     
             AND ttICMSSN202.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMSSN202.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMSSN202.ItCodigoNF   = ttDet.ItCodigoNF :
            
            /*N10f|orig|CSOSN|modBCST|pMVAST|pRedBCST|vBCST|pICMSST|vICMSST|*/
            PUT "N10f" "|".

            {adapters/xml/ep2/axsep027nodechar.i "orig"         ttICMSSN202.orig         "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "CSOSN"        ttICMSSN202.CSOSN        "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "modBCST"      ttICMSSN202.modBCST      "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pMVAST"       ttICMSSN202.pMVAST       "YES"  "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "pRedBCST"     ttICMSSN202.pRedBCST     "YES"  "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vBCST"        ttICMSSN202.vBCST        "YES"  "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pICMSST"      ttICMSSN202.pICMSST      "YES"  "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vICMSST"      ttICMSSN202.vICMSST      "YES"  "2" "YES"}
            
            PUT SKIP.
            /*fim "N10f"*/
        END.

        FOR EACH ttICMSSN500
           WHERE ttICMSSN500.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMSSN500.SerieNF      = ttDet.SerieNF     
             AND ttICMSSN500.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMSSN500.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMSSN500.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N10g|orig|CSOSN|vBCSTRet|vICMSSTRet|*/
            PUT "N10g" "|".

            {adapters/xml/ep2/axsep027nodechar.i "orig"           ttICMSSN500.orig        "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "CSOSN"          ttICMSSN500.CSOSN       "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vBCSTRet"       ttICMSSN500.vBCSTRet    "YES"   "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vICMSSTRet"     ttICMSSN500.vICMSSTRet  "YES"   "2" "YES"}
            
            PUT SKIP.
            /*fim "N10g"*/
        END.

        FOR EACH ttICMSSN900
           WHERE ttICMSSN900.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMSSN900.SerieNF      = ttDet.SerieNF     
             AND ttICMSSN900.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMSSN900.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMSSN900.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N10h|orig|CSOSN|modBC|vBC|pRedBC|pICMS|vICMS|modBCST|pMVAST|pRedBCST|vBCST|pICMSST|vICMSST|pCredSN|vCredICMSSN| */
            PUT "N10h" "|".

            {adapters/xml/ep2/axsep027nodechar.i "orig"         ttICMSSN900.orig         "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "CSOSN"        ttICMSSN900.CSOSN        "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "modBC"        ttICMSSN900.modBC        "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vBC"          ttICMSSN900.vBC          "YES"  "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pRedBC"       ttICMSSN900.pRedBC       "YES"  "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "pICMS"        ttICMSSN900.pICMS        "YES"  "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vICMS"        ttICMSSN900.vICMS        "YES"  "2" "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "modBCST"      ttICMSSN900.modBCST      "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pMVAST"       ttICMSSN900.pMVAST       "YES"  "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "pRedBCST"     ttICMSSN900.pRedBCST     "YES"  "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vBCST"        ttICMSSN900.vBCST        "YES"  "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pICMSST"      ttICMSSN900.pICMSST      "YES"  "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vICMSST"      ttICMSSN900.vICMSST      "YES"  "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pCredSN"      ttICMSSN900.pCredSN      "YES"  "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vCredICMSSN"  ttICMSSN900.vCredICMSSN  "YES"  "2" "YES"}

            PUT SKIP.
            /*fim "N10h"*/
        END.

END PROCEDURE.

PROCEDURE pi-imprime-IPI-txt:

        FOR EACH ttIPI
           WHERE ttIPI.CodEstabelNF = ttDet.CodEstabelNF
             AND ttIPI.SerieNF      = ttDet.SerieNF     
             AND ttIPI.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttIPI.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttIPI.ItCodigoNF   = ttDet.ItCodigoNF
             AND ttIPI.l-ipi-trib  <> ?: /* quando l-ipi-trib = ? indica nota serviªo e nío deve imprimir IPI (v2.0) */

            /*O|clEnq|CNPJProd|cSelo|qSelo|cEnq|*/
            PUT "O" "|".

            {adapters/xml/ep2/axsep027nodechar.i "clEnq"    ttIPI.clEnq    "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "CNPJProd" ttIPI.CNPJProd "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "cSelo"    ttIPI.cSelo    "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "qSelo"    ttIPI.qSelo    "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "cEnq"     ttIPI.cEnq     "YES"}

            PUT SKIP.
            /*fim "O"*/

            IF  NOT ttIPI.l-ipi-trib THEN DO:

                /*O08|CST|*/
                PUT "O08" "|".

                {adapters/xml/ep2/axsep027nodechar.i "CST"   ttIPI.CSTIPINT "YES"}

                PUT SKIP.
                /*fim "O08"*/
            END.
            ELSE DO:

                /*O07|CST|vIPI|*/
                PUT "O07" "|".
            
                {adapters/xml/ep2/axsep027nodechar.i "CST"   ttIPI.CSTIPITrib "YES"    }
                {adapters/xml/ep2/axsep027nodedec.i  "vIPI"  ttIPI.vIPI       "YES" "2" "YES"}

                PUT SKIP.
                /*fim "O07"*/

                IF  ttIPI.qUnid > 0 AND 
                    ttIPI.vUnid > 0 THEN DO: /* IPI Unidade */
                
                    /*O11|qUnid|vUnid|*/
                    PUT "O11" "|".
    
                    {adapters/xml/ep2/axsep027nodedec.i  "qUnid" ttIPI.qUnid      "YES" "4" "YES"}
                    {adapters/xml/ep2/axsep027nodedec.i  "vUnid" ttIPI.vUnid      "YES" "4" "YES"}
    
                    PUT SKIP.
                    /*fim "O11"*/
                END.
                ELSE DO:
                    
                    /*O10|vBC|pIPI|*/
                    PUT "O10" "|".
    
                    {adapters/xml/ep2/axsep027nodedec.i  "vBC"   ttIPI.vBC        "YES" "2" "YES"}
                    {adapters/xml/ep2/axsep027nodedec.i  "pIPI"  ttIPI.pIPI       "YES" "4" "NO" }
    
                    PUT SKIP.
                    /*fim "O10"*/
                END.
                
            END.
        END.

END PROCEDURE.

PROCEDURE pi-imprime-II-txt:

        FOR EACH ttII
           WHERE ttII.CodEstabelNF = ttDet.CodEstabelNF
             AND ttII.SerieNF      = ttDet.SerieNF     
             AND ttII.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttII.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttII.ItCodigoNF   = ttDet.ItCodigoNF 
             AND ttII.vBC      <> ?
             AND ttII.vDespAdu <> ?
             AND ttII.vII      <> ?
             AND ttII.vIOF     <> ?:

            /*P|vBC|vDespAdu|vII|vIOF|*/
            PUT "P" "|".
    
            {adapters/xml/ep2/axsep027nodedec.i "vBC"      ttII.vBC      "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i "vDespAdu" ttII.vDespAdu "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i "vII"      ttII.vII      "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i "vIOF"     ttII.vIOF     "YES" "2" "YES"}

            PUT SKIP.
            /*fim "P"*/
        END.

END PROCEDURE.

PROCEDURE pi-imprime-PIS-txt:

        IF CAN-FIND(FIRST ttPISAliq) OR
           CAN-FIND(FIRST ttPISQtde) OR
           CAN-FIND(FIRST ttPISNT)   OR
           CAN-FIND(FIRST ttPISOutr) THEN
            PUT "Q|" SKIP.

        FOR EACH ttPISAliq
           WHERE ttPISAliq.CodEstabelNF = ttDet.CodEstabelNF
             AND ttPISAliq.SerieNF      = ttDet.SerieNF     
             AND ttPISAliq.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttPISAliq.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttPISAliq.ItCodigoNF   = ttDet.ItCodigoNF :

            /*Q02|CST|vBC|pPIS|vPIS|*/
            PUT "Q02" "|".

            {adapters/xml/ep2/axsep027nodechar.i "CST"  ttPISAliq.CST  "YES"    }
            {adapters/xml/ep2/axsep027nodedec.i  "vBC"  ttPISAliq.vBC  "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pPIS" ttPISAliq.pPIS "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vPIS" ttPISAliq.vPIS "YES" "2" "YES"}

            PUT SKIP.
            /*fim "Q02"*/
        END.

        FOR EACH ttPISQtde
           WHERE ttPISQtde.CodEstabelNF = ttDet.CodEstabelNF
             AND ttPISQtde.SerieNF      = ttDet.SerieNF     
             AND ttPISQtde.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttPISQtde.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttPISQtde.ItCodigoNF   = ttDet.ItCodigoNF :

            /*Q03|CST|qBCProd|vAliqProd|vPIS|*/
            PUT "Q03" "|".

            {adapters/xml/ep2/axsep027nodechar.i "CST"       ttPISQtde.CST       "YES"    }
            {adapters/xml/ep2/axsep027nodedec.i  "qBCProd"   ttPISQtde.qBCProd   "YES" "4" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vAliqProd" ttPISQtde.vAliqProd "YES" "4" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vPIS"      ttPISQtde.vPIS      "YES" "2" "YES"}

            PUT SKIP.
            /*fim "Q03"*/
        END.

        FOR EACH ttPISNT
           WHERE ttPISNT.CodEstabelNF = ttDet.CodEstabelNF
             AND ttPISNT.SerieNF      = ttDet.SerieNF     
             AND ttPISNT.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttPISNT.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttPISNT.ItCodigoNF   = ttDet.ItCodigoNF :

            /*Q04|CST|*/
            PUT "Q04" "|".

            {adapters/xml/ep2/axsep027nodechar.i "CST" ttPISNT.CST "YES"}

            PUT SKIP.
            /*fim "Q04"*/
        END.
        
        FOR EACH ttPISOutr
           WHERE ttPISOutr.CodEstabelNF = ttDet.CodEstabelNF
             AND ttPISOutr.SerieNF      = ttDet.SerieNF     
             AND ttPISOutr.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttPISOutr.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttPISOutr.ItCodigoNF   = ttDet.ItCodigoNF :

            /*Q05|CST|vPIS|*/
            PUT "Q05" "|".

            {adapters/xml/ep2/axsep027nodechar.i "CST"       ttPISOutr.CST  "YES"    }
            {adapters/xml/ep2/axsep027nodedec.i  "vPIS"      ttPISOutr.vPIS "YES" "2" "YES"}

            PUT SKIP.
            /*fim "Q05"*/

            IF  ttPISOutr.vAliqProd <> 0
            AND ttPISOutr.vAliqProd <> ? THEN DO:

                /*Q10|qBCProd|vAliqProd|*/
                PUT "Q10" "|".

                {adapters/xml/ep2/axsep027nodedec.i "qBCProd"   ttPISOutr.qBCProd   "YES" "4" "YES"}
                {adapters/xml/ep2/axsep027nodedec.i "vAliqProd" ttPISOutr.vAliqProd "YES" "4" "YES"}

                PUT SKIP.
                /*fim "Q10"*/
            END.
            ELSE DO:

                /*Q07|vBC|pPIS|*/
                PUT "Q07" "|".

                {adapters/xml/ep2/axsep027nodedec.i "vBC"       ttPISOutr.vBC  "YES" "2" "YES"}
                {adapters/xml/ep2/axsep027nodedec.i "pPIS"      ttPISOutr.pPIS "YES" "4" "NO" }

                PUT SKIP.
                /*fim "Q07"*/
            END.
        END.

        FOR EACH ttPISST
           WHERE ttPISST.CodEstabelNF = ttDet.CodEstabelNF
             AND ttPISST.SerieNF      = ttDet.SerieNF     
             AND ttPISST.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttPISST.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttPISST.ItCodigoNF   = ttDet.ItCodigoNF :

            /*R|vPIS|*/
            PUT "R" "|".
            
            {adapters/xml/ep2/axsep027nodedec.i "vPIS"      ttPISST.vPIS      "YES" "2" "YES"}

            PUT SKIP.
            /*fim "R"*/

            IF  ttPISST.vAliqProd <> 0
            AND ttPISST.vAliqProd <> ? THEN DO:

                /*R04|qBCProd|vAliqProd|*/
                PUT "R04" "|". 

                {adapters/xml/ep2/axsep027nodedec.i "qBCProd"   ttPISST.qBCProd   "YES" "4" "YES"}
                {adapters/xml/ep2/axsep027nodedec.i "vAliqProd" ttPISST.vAliqProd "YES" "4" "YES"}

                PUT SKIP.
                /*fim "R04"*/
            END.
            ELSE DO:

                /*R02|vBC|pPIS|*/
                PUT "R02" "|".

                {adapters/xml/ep2/axsep027nodedec.i "vBC"       ttPISST.vBC       "YES" "2" "YES"}
                {adapters/xml/ep2/axsep027nodedec.i "pPIS"      ttPISST.pPIS      "YES" "4" "NO" }

                PUT SKIP.
                /*fim "R02"*/
            END.
        END.

END PROCEDURE.

PROCEDURE pi-imprime-COFINS-txt:

        IF CAN-FIND(FIRST ttCOFINSAliq) OR
           CAN-FIND(FIRST ttCOFINSQtde) OR
           CAN-FIND(FIRST ttCOFINSNT)   OR
           CAN-FIND(FIRST ttCOFINSOutr) THEN
            PUT "S|" SKIP.

        FOR EACH ttCOFINSAliq
           WHERE ttCOFINSAliq.CodEstabelNF = ttDet.CodEstabelNF
             AND ttCOFINSAliq.SerieNF      = ttDet.SerieNF     
             AND ttCOFINSAliq.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttCOFINSAliq.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttCOFINSAliq.ItCodigoNF   = ttDet.ItCodigoNF:

            /*S02|CST|vBC|pCOFINS|vCOFINS|*/
            PUT "S02" "|".

            {adapters/xml/ep2/axsep027nodechar.i "CST"     ttCOFINSAliq.CST     "YES"    }
            {adapters/xml/ep2/axsep027nodedec.i  "vBC"     ttCOFINSAliq.vBC     "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pCOFINS" ttCOFINSAliq.pCOFINS "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vCOFINS" ttCOFINSAliq.vCOFINS "YES" "2" "YES"}

            PUT SKIP.
            /*fim "S02"*/
        END.
        
        FOR EACH ttCOFINSQtde
           WHERE ttCOFINSQtde.CodEstabelNF = ttDet.CodEstabelNF
             AND ttCOFINSQtde.SerieNF      = ttDet.SerieNF     
             AND ttCOFINSQtde.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttCOFINSQtde.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttCOFINSQtde.ItCodigoNF   = ttDet.ItCodigoNF:

            /*S03|CST|qBCProd|vAliqProd|vCOFINS|*/
            PUT "S03" "|".

            {adapters/xml/ep2/axsep027nodechar.i "CST"       ttCOFINSQtde.CST       "YES"    }
            {adapters/xml/ep2/axsep027nodedec.i  "qBCProd"   ttCOFINSQtde.qBCProd   "YES" "4" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vAliqProd" ttCOFINSQtde.vAliqProd "YES" "4" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vCOFINS"   ttCOFINSQtde.vCOFINS   "YES" "2" "YES"}

            PUT SKIP.
            /*fim "S03"*/
        END.
        
        FOR EACH ttCOFINSNT
           WHERE ttCOFINSNT.CodEstabelNF = ttDet.CodEstabelNF
             AND ttCOFINSNT.SerieNF      = ttDet.SerieNF     
             AND ttCOFINSNT.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttCOFINSNT.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttCOFINSNT.ItCodigoNF   = ttDet.ItCodigoNF:

            /*S04|CST|*/
            PUT "S04" "|".

            {adapters/xml/ep2/axsep027nodechar.i "CST" ttCOFINSNT.CST "YES"}

            PUT SKIP.
            /*fim "S04"*/
        END.

        FOR EACH ttCOFINSOutr
           WHERE ttCOFINSOutr.CodEstabelNF = ttDet.CodEstabelNF
             AND ttCOFINSOutr.SerieNF      = ttDet.SerieNF     
             AND ttCOFINSOutr.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttCOFINSOutr.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttCOFINSOutr.ItCodigoNF   = ttDet.ItCodigoNF:

            /*S05|CST|vCOFINS|*/
            PUT "S05" "|".

            {adapters/xml/ep2/axsep027nodechar.i "CST"       ttCOFINSOutr.CST     "YES"    }
            {adapters/xml/ep2/axsep027nodedec.i  "vCOFINS"   ttCOFINSOutr.vCOFINS "YES" "2" "YES"}

            PUT SKIP.
            /*fim "S05"*/

            IF  ttCOFINSOutr.vAliqProd <> 0
            AND ttCOFINSOutr.vAliqProd <> ? THEN DO:

                /*S09|qBCProd|vAliqProd|*/
                PUT "S09" "|".

                {adapters/xml/ep2/axsep027nodedec.i "qBCProd"   ttCOFINSOutr.qBCProd   "YES" "4" "YES"}
                {adapters/xml/ep2/axsep027nodedec.i "vAliqProd" ttCOFINSOutr.vAliqProd "YES" "4" "YES"}

                PUT SKIP.
                /*fim "S09"*/
            END.
            ELSE DO:

                /*S07|vBC|pCOFINS|*/
                PUT "S07" "|".

                {adapters/xml/ep2/axsep027nodedec.i "vBC"       ttCOFINSOutr.vBC       "YES" "2" "YES"}
                {adapters/xml/ep2/axsep027nodedec.i "pCOFINS"   ttCOFINSOutr.pCOFINS   "YES" "4" "NO" }

                PUT SKIP.
                /*fim "S07"*/
            END.
        END.

        FOR EACH ttCOFINSST
           WHERE ttCOFINSST.CodEstabelNF = ttDet.CodEstabelNF
             AND ttCOFINSST.SerieNF      = ttDet.SerieNF     
             AND ttCOFINSST.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttCOFINSST.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttCOFINSST.ItCodigoNF   = ttDet.ItCodigoNF:

            /*T|vCOFINS|*/
            PUT "T" "|".

            {adapters/xml/ep2/axsep027nodedec.i "vCOFINS"   ttCOFINSST.vCOFINS   "YES" "2" "YES"}

            PUT SKIP.
            /*fim "T"*/

            IF  ttCOFINSST.vAliqProd <> 0
            AND ttCOFINSST.vAliqProd <> ? THEN DO:

                /*T04|qBCProd|vAliqProd|*/
                PUT "T04" "|".

                {adapters/xml/ep2/axsep027nodedec.i "qBCProd"   ttCOFINSST.qBCProd   "YES" "4" "YES"}
                {adapters/xml/ep2/axsep027nodedec.i "vAliqProd" ttCOFINSST.vAliqProd "YES" "4" "YES"}

                PUT SKIP.
                /*fim "T04"*/
            END.
            ELSE DO:

                /*T02|vBC|pCOFINS|*/
                PUT "T02" "|".

                {adapters/xml/ep2/axsep027nodedec.i "vBC"       ttCOFINSST.vBC       "YES" "2" "YES"}
                {adapters/xml/ep2/axsep027nodedec.i "pCOFINS"   ttCOFINSST.pCOFINS   "YES" "4" "NO" }   

                PUT SKIP.
                /*fim "T02"*/
            END.
        END.

END PROCEDURE.

PROCEDURE pi-imprime-ICMSUFDest-txt:

        FOR EACH ttICMSUFDest
           WHERE ttICMSUFDest.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMSUFDest.SerieNF      = ttDet.SerieNF     
             AND ttICMSUFDest.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMSUFDest.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMSUFDest.ItCodigoNF   = ttDet.ItCodigoNF
             AND (ttICMSUFDest.vBCUFDest      > 0 OR
                  ttICMSUFDest.pFCPUFDest     > 0 OR
                  ttICMSUFDest.pICMSUFDest    > 0 OR
                  ttICMSUFDest.pICMSInter     > 0 OR
                  ttICMSUFDest.pICMSInterPart > 0 OR
                  ttICMSUFDest.vFCPUFDest     > 0 OR
                  ttICMSUFDest.vICMSUFDest    > 0 OR
                  ttICMSUFDest.vICMSUFRemet   > 0 ):

            /*NA|vBCUFDest|pFCPUFDest|pICMSUFDest|pICMSInter|pICMSInterPart|vFCPUFDest|vICMSUFDest|vICMSFRemet|*/

            PUT "NA" "|". 

            {adapters/xml/ep2/axsep027nodedec.i "vBCUFDest"      ttICMSUFDest.vBCUFDest      "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i "pFCPUFDest"     ttICMSUFDest.pFCPUFDest     "YES" "4" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i "pICMSUFDest"    ttICMSUFDest.pICMSUFDest    "YES" "4" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i "pICMSInter"     ttICMSUFDest.pICMSInter     "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i "pICMSInterPart" ttICMSUFDest.pICMSInterPart "YES" "4" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i "vFCPUFDest"     ttICMSUFDest.vFCPUFDest     "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i "vICMSUFDest"    ttICMSUFDest.vICMSUFDest    "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i "vICMSUFRemet"   ttICMSUFDest.vICMSUFRemet   "YES" "2" "YES"}

            PUT SKIP.
            /*fim "NA"*/

        END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-ImpostoDevol-txt.

        FOR EACH ttImpostoDevol
           WHERE ttImpostoDevol.CodEstabelNF = ttDet.CodEstabelNF
             AND ttImpostoDevol.SerieNF      = ttDet.SerieNF     
             AND ttImpostoDevol.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttImpostoDevol.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttImpostoDevol.ItCodigoNF   = ttDet.ItCodigoNF
             AND (ttImpostoDevol.pDevol    <> ?
             AND  ttImpostoDevol.vIPIDevol <> ?):

            /*UA|pDevol|*/
            PUT "UA" "|".

            {adapters/xml/ep2/axsep027nodedec.i "pDevol"    ttImpostoDevol.pDevol   "YES" "2" "YES"}

            PUT SKIP.
            /*fim "UA"*/
    
            /*UA03|vIPIDevol|*/
            PUT "UA03" "|".
            
            {adapters/xml/ep2/axsep027nodedec.i "vIPIDevol" ttImpostoDevol.vIPIDevol "YES" "2" "YES"}

            PUT SKIP.
            /*fim "UA03"*/
    
        END.

END PROCEDURE.

PROCEDURE pi-imprime-ISSQN-txt:

        FOR EACH ttISSQN
           WHERE ttISSQN.CodEstabelNF = ttDet.CodEstabelNF
             AND ttISSQN.SerieNF      = ttDet.SerieNF     
             AND ttISSQN.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttISSQN.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttISSQN.ItCodigoNF   = ttDet.ItCodigoNF
             AND ttISSQN.vBC       <> ?
             AND ttISSQN.vAliq     <> ?
             AND ttISSQN.vISSQN    <> ?
             AND ttISSQN.cMunFG    <> ?
             AND ttISSQN.cListServ <> ?:

            /*U|vBC|vAliq|vISSQN|cMunFG|cListServ|vDeducao|vOutro|vDescIncond|vDescCond|vISSRet|indISS|cServico|cMun|cPais|nProcesso|indIncentivo|*/
            PUT "U" "|".

            {adapters/xml/ep2/axsep027nodedec.i  "vBC"          ttISSQN.vBC          "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vAliq"        ttISSQN.vAliq        "YES" "4" "NO "}
            {adapters/xml/ep2/axsep027nodedec.i  "vISSQN"       ttISSQN.vISSQN       "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "cMunFG"       ttISSQN.cMunFG       "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "cListServ"    ttISSQN.cListServ    "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vDeducao"     ttISSQN.vDeducao     "YES"  "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vOutro"       ttISSQN.vOutro       "YES"  "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vDescIncond"  ttISSQN.vDescIncond  "YES"  "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vDescCond"    ttISSQN.vDescCond    "YES"  "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vISSRet"      ttISSQN.vISSRet      "YES"  "2" "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "indISS"       ttISSQN.indISS       "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "cServico"     ttISSQN.cServico     "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "cMun"         ttISSQN.cMun         "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "cPais"        ttISSQN.cPais        "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "nProcesso"    ttISSQN.nProcesso    "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "indIncentivo" ttISSQN.indIncentivo "YES"}

            PUT SKIP.
            /*fim "U"*/
        END.

END PROCEDURE.

PROCEDURE pi-imprime-Total-txt:

    PUT "W|" SKIP.

    FOR EACH ttICMSTot
       WHERE ttICMSTot.CodEstabelNF = ttNFe.CodEstabelNF
         AND ttICMSTot.SerieNF      = ttNFe.SerieNF     
         AND ttICMSTot.NrNotaFisNF  = ttNFe.NrNotaFisNF :

        /*W02|vBC|vICMS|vICMSDeson|vBCST|vST|vProd|vFrete|vSeg|vDesc|vII|vIPI|vPIS|vCOFINS|vOutro|vNF|vTotTrib| */

        PUT "W02" "|".

        {adapters/xml/ep2/axsep027nodedec.i "vBC"          ttICMSTot.vBC          "YES" "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i "vICMS"        ttICMSTot.vICMS        "YES" "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i "vICMSDeson"   ttICMSTot.vICMSDeson   "YES" "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i "vBCST"        ttICMSTot.vBCST        "YES" "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i "vST"          ttICMSTot.vST          "YES" "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i "vProd"        ttICMSTot.vProd        "YES" "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i "vFrete"       ttICMSTot.vFrete       "YES" "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i "vSeg"         ttICMSTot.vSeg         "YES" "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i "vDesc"        ttICMSTot.vDesc        "YES" "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i "vII"          ttICMSTot.vII          "YES" "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i "vIPI"         ttICMSTot.vIPI         "YES" "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i "vPIS"         ttICMSTot.vPIS         "YES" "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i "vCOFINS"      ttICMSTot.vCOFINS      "YES" "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i "vOutro"       ttICMSTot.vOutro       "YES" "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i "vNF"          ttICMSTot.vNF          "YES" "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i "vTotTrib"     ttICMSTot.vTotTrib     "NO"  "2" "YES"} /*NT2013.003 - Valor aproximado total de tributos federais, estaduais e municipais - campo NAO obrigatorio*/

        PUT SKIP.
        /*fim "W02"*/

        /*--- TOTAIS PARTILHA ICMS EC 87/2015 - NT 2015.003 ---*/
        PUT "W04c" "|".
        {adapters/xml/ep2/axsep027nodedec.i "vFCPUFDest"   ttICMSTot.vFCPUFDest   "YES"  "2" "YES"}
        PUT SKIP.
        /*fim "W04c"*/
        
        PUT "W04e" "|".
        {adapters/xml/ep2/axsep027nodedec.i "vICMSUFDest"  ttICMSTot.vICMSUFDest  "YES"  "2" "YES"}
        PUT SKIP.
        /*fim "W04e"*/
        
        PUT "W04g" "|".
        {adapters/xml/ep2/axsep027nodedec.i "vICMSUFRemet" ttICMSTot.vICMSUFRemet "YES"  "2" "YES"}
        PUT SKIP.
        /*fim "W04g"*/
        /*---*/
    END.

    FOR EACH ttISSQNtot
       WHERE ttISSQNtot.CodEstabelNF = ttNFe.CodEstabelNF
         AND ttISSQNtot.SerieNF      = ttNFe.SerieNF     
         AND ttISSQNtot.NrNotaFisNF  = ttNFe.NrNotaFisNF :

        /*W17|vServ|vBC|vISS|vPIS|vCOFINS|dCompet|vDeducao|vOutro|vDescIncond|vDescCond|vISSRet|cRegTrib|*/
        PUT "W17" "|".

        {adapters/xml/ep2/axsep027nodedec.i  "vServ"       ttISSQNtot.vServ       "YES"  "2" "YES"} 
        {adapters/xml/ep2/axsep027nodedec.i  "vBC"         ttISSQNtot.vBC         "YES"  "2" "YES"}  
        {adapters/xml/ep2/axsep027nodedec.i  "vISS"        ttISSQNtot.vISS        "YES"  "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i  "vPIS"        ttISSQNtot.vPIS        "YES"  "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i  "vCOFINS"     ttISSQNtot.vCOFINS     "YES"  "2" "YES"} 
        {adapters/xml/ep2/axsep027nodedate.i "dCompet"     ttISSQNTot.dCompet     "YES"}
        {adapters/xml/ep2/axsep027nodedec.i  "vDeducao"    ttISSQNtot.vDeducao    "YES"  "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i  "vOutro"      ttISSQNtot.vOutro      "YES"  "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i  "vDescIncond" ttISSQNtot.vDescIncond "YES"  "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i  "vDescCond"   ttISSQNtot.vDescCond   "YES"  "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i  "vISSRet"     ttISSQNtot.vISSRet     "YES"  "2" "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "cRegTrib"    ttISSQNtot.cRegTrib    "YES"}

        PUT SKIP.
        /*fim "W17"*/
    END.

    FOR EACH ttRetTrib
       WHERE ttRetTrib.CodEstabelNF = ttNFe.CodEstabelNF 
         AND ttRetTrib.SerieNF      = ttNFe.SerieNF      
         AND ttRetTrib.NrNotaFisNF  = ttNFe.NrNotaFisNF :

        /*W23|vRetPIS|vRetCOFINS|vRetCSLL|vBCIRRF|vIRRF|vBCRetPrev|vRetPrev|*/
        PUT "W23" "|".

        {adapters/xml/ep2/axsep027nodedec.i "vRetPIS"     ttRetTrib.vRetPIS     "YES"  "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i "vRetCOFINS"  ttRetTrib.vRetCOFINS  "YES"  "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i "vRetCSLL"    ttRetTrib.vRetCSLL    "YES"  "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i "vBCIRRF"     ttRetTrib.vBCIRRF     "YES"  "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i "vIRRF"       ttRetTrib.vIRRF       "YES"  "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i "vBCRetPrev"  ttRetTrib.vBCRetPrev  "YES"  "2" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i "vRetPrev"    ttRetTrib.vRetPrev    "YES"  "2" "YES"}

        PUT SKIP.
        /*fim "W23"*/
    END.

END PROCEDURE.

PROCEDURE pi-imprime-Transp-txt:

    FOR EACH ttTransp
       WHERE ttTransp.CodEstabelNF = ttNFe.CodEstabelNF 
         AND ttTransp.SerieNF      = ttNFe.SerieNF      
         AND ttTransp.NrNotaFisNF  = ttNFe.NrNotaFisNF :

        /*X|ModFrete|*/
        PUT "X" "|".

        {adapters/xml/ep2/axsep027nodechar.i "modFrete" ttTransp.modFrete "YES"}
        
        PUT SKIP.
        /*fim "X"*/

        /*X03|xNome|IE|xEnder|xMun|UF|*/
        PUT "X03" "|".

        {adapters/xml/ep2/axsep027nodechar.i "xNome"  ttTransp.xNome  "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "IE"     ttTransp.IE     "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "xEnder" ttTransp.xEnder "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "xMun"   ttTransp.xMun   "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "UF"     ttTransp.UF     "YES"}

        PUT SKIP.
        /*fim "X03"*/

        IF  ttTransp.i-natureza = 1 THEN DO: /*Pessoa F°sica*/

            /*X05|CPF|*/
            PUT "X05" "|".

            {adapters/xml/ep2/axsep027nodechar.i "CPF"    ttTransp.CPF    "YES"}

            PUT SKIP.
            /*fim "X05"*/
        END.
        ELSE DO: /*Pessoa Jur°dica*/

            /*X04|CNPJ|*/
            PUT "X04" "|".

            {adapters/xml/ep2/axsep027nodechar.i "CNPJ"   ttTransp.CNPJ   "YES"}

            PUT SKIP.
            /*fim "X04"*/
        END.

        IF  (/* ttTransp.vServ    <> 0  AND */ ttTransp.vServ    <> ?)
        AND (/* ttTransp.vBCRet   <> 0  AND */ ttTransp.vBCRet   <> ?)
        AND (/* ttTransp.pICMSRet <> 0  AND */ ttTransp.pICMSRet <> ?)
        AND (/* ttTransp.vICMSRet <> 0  AND */ ttTransp.vICMSRet <> ?)
        AND (/* ttTransp.CFOP     <> "" AND */ ttTransp.CFOP     <> ?)
        AND (/* ttTransp.cMunFG   <> "" AND */ ttTransp.cMunFG   <> ?)
        THEN DO:

            /*X11|vServ|vBCRet|pICMSRet|vICMSRet|CFOP|cMunFG|*/
            PUT "X11" "|".

            {adapters/xml/ep2/axsep027nodedec.i  "vServ"    ttTransp.vServ    "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vBCRet"   ttTransp.vBCRet   "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pICMSRet" ttTransp.pICMSRet "YES" "4" "NO" }
            {adapters/xml/ep2/axsep027nodedec.i  "vICMSRet" ttTransp.vICMSRet "YES" "2" "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "CFOP"     ttTransp.CFOP     "YES"    }
            {adapters/xml/ep2/axsep027nodechar.i "cMunFG"   ttTransp.cMunFG   "YES"    }
            
            PUT SKIP.
            /*fim "X11"*/
        END.

        IF  (ttTransp.placa   <> "" AND ttTransp.placa   <> ?)
        AND (ttTransp.UFplaca <> "" AND ttTransp.UFplaca <> ?)
        THEN DO:

            /*X18|placa|UF|RNTC|*/
            PUT "X18" "|".
        
            {adapters/xml/ep2/axsep027nodechar.i "placa" ttTransp.placa   "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "UF"    ttTransp.UFplaca "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "RNTC"  ttTransp.RNTC    "YES"}
            
            PUT SKIP.
            /*fim "X18"*/
        END.

        FOR EACH  ttReboque
           WHERE  ttReboque.CodEstabelNF = ttTransp.CodEstabelNF
             AND  ttReboque.SerieNF      = ttTransp.SerieNF     
             AND  ttReboque.NrNotaFisNF  = ttTransp.NrNotaFisNF
             AND (ttReboque.placa       <> "" AND ttReboque.placa       <> ?)
             AND (ttReboque.UF          <> "" AND ttReboque.UF          <> ?) :

            /*X22|placa|UF|RNTC|*/
            PUT "X22" "|".
            
            {adapters/xml/ep2/axsep027nodechar.i "placa"  ttReboque.placa  "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "UF"     ttReboque.UF     "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "RNTC"   ttReboque.RNTC   "YES"}
            
            PUT SKIP.
            /*fim "X22"*/

        END.

        IF  ttTransp.vagao <> "" AND ttTransp.vagao <> ? THEN DO:
        
            /*X25a|vagao|*/
            PUT "X25a" "|".

            {adapters/xml/ep2/axsep027nodechar.i "vagao"    ttTransp.vagao    "YES" }

            PUT SKIP.
            /*fim "X25a"*/
        END.

        IF  ttTransp.balsa <> "" AND ttTransp.balsa <> ? THEN DO:

            /*X25b|balsa|*/
            PUT "X25b" "|".

            {adapters/xml/ep2/axsep027nodechar.i "balsa"    ttTransp.balsa    "YES" }

            PUT SKIP.
            /*fim "X25b"*/
        END.
        
        
        FOR EACH  ttVol
           WHERE  ttVol.CodEstabelNF = ttTransp.CodEstabelNF
             AND  ttVol.SerieNF      = ttTransp.SerieNF
             AND  ttVol.NrNotaFisNF  = ttTransp.NrNotaFisNF
             AND ( (ttVol.esp   <> "" AND ttVol.esp   <> ?) /* Valida se existe ao menos uma informacao valida */
			 OR    (ttVol.marca <> "" AND ttVol.marca <> ?)
			 OR    (ttVol.nVol  <> "" AND ttVol.nVol  <> ?)
			 OR    (ttVol.pesoB <> 0  AND ttVol.pesoB <> ?)
			 OR    (ttVol.pesoL <> 0  AND ttVol.pesoL <> ?)
             /*OR    (ttVol.qVol  <> "" AND ttVol.qVol  <> ?)*/ ) : /*NT2012.003 - tag qVol obrigatoria*/

            /*X26|qVol|esp|marca|nVol|pesoL|pesoB|*/
            PUT "X26" "|".

            {adapters/xml/ep2/axsep027nodechar.i "qVol"  ttVol.qVol  "YES"    }
            {adapters/xml/ep2/axsep027nodechar.i "esp"   ttVol.esp   "YES"    }
            {adapters/xml/ep2/axsep027nodechar.i "marca" ttVol.marca "YES"    }
            {adapters/xml/ep2/axsep027nodechar.i "nVol"  ttVol.nVol  "YES"    }
            {adapters/xml/ep2/axsep027nodedec.i  "pesoL" ttVol.pesoL "YES" "3" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "pesoB" ttVol.pesoB "YES" "3" "YES"}

            PUT SKIP.
            /*fim "X26"*/

            FOR EACH  ttLacres 
               WHERE  ttLacres.CodEstabelNF = ttVol.CodEstabelNF
                 AND  ttLacres.SerieNF      = ttVol.SerieNF     
                 AND  ttLacres.NrNotaFisNF  = ttVol.NrNotaFisNF 
                 AND  ttLacres.nVol         = ttVol.nVol
                 AND (ttLacres.nLacre      <> "" AND ttLacres.nLacre <> ?):

                /*X33|nLacre|*/
                PUT "X33" "|".

                {adapters/xml/ep2/axsep027nodechar.i "nLacre" ttLacres.nLacre "YES"}
                
                PUT SKIP.
                /*fim "X33"*/
            END.
        END.
    END.

END PROCEDURE.

PROCEDURE pi-imprime-Cobr-txt:

    IF CAN-FIND(FIRST ttCobr
                WHERE ttCobr.CodEstabelNF = ttNFe.CodEstabelNF
                  AND ttCobr.SerieNF      = ttNFe.SerieNF     
                  AND ttCobr.NrNotaFisNF  = ttNFe.NrNotaFisNF) THEN
       PUT "Y|" SKIP.

    FOR EACH ttCobr
       WHERE ttCobr.CodEstabelNF = ttNFe.CodEstabelNF
         AND ttCobr.SerieNF      = ttNFe.SerieNF     
         AND ttCobr.NrNotaFisNF  = ttNFe.NrNotaFisNF :

        IF  ttCobr.nFat <> "" AND ttCobr.nFat <> ? THEN DO:

            /*Y02|nFat|vOrig|vDesc|vLiq|*/
            PUT "Y02" "|".

            {adapters/xml/ep2/axsep027nodechar.i "nFat"  ttCobr.nFat  "YES"     }
            {adapters/xml/ep2/axsep027nodedec.i  "vOrig" ttCobr.vOrig "YES"  "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vDesc" ttCobr.vDesc "YES"  "2" "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vLiq"  ttCobr.vLiq  "YES"  "2" "YES"}

            PUT SKIP.
            /*fim "Y02"*/
        END.
    END.
    
    FOR EACH ttDup
       WHERE ttDup.CodEstabelNF = ttNFe.CodEstabelNF
         AND ttDup.SerieNF      = ttNFe.SerieNF
         AND ttDup.NrNotaFisNF  = ttNFe.NrNotaFisNF:

        /*Y07|nDup|dVenc|vDup|*/
        PUT "Y07" "|".
        
        {adapters/xml/ep2/axsep027nodechar.i "nDup"  ttDup.nDup  "YES"    }
        {adapters/xml/ep2/axsep027nodedate.i "dVenc" ttDup.dVenc "YES"    }
        {adapters/xml/ep2/axsep027nodedec.i  "vDup"  ttDup.vDup  "YES" "2" "YES"}
        
        PUT SKIP.
        /*fim "Y07"*/
    END.
    

END PROCEDURE.

PROCEDURE pi-imprime-InfAdic-txt:

    FOR EACH ttInfAdic
       WHERE ttInfAdic.CodEstabelNF = ttNFe.CodEstabelNF
         AND ttInfAdic.SerieNF      = ttNFe.SerieNF     
         AND ttInfAdic.NrNotaFisNF  = ttNFe.NrNotaFisNF :

        /*Z|infAdFisco|infCpl|*/
        PUT "Z" "|".
        
        {adapters/xml/ep2/axsep027nodechar.i  "infAdFisco" ttInfAdic.infAdFisco "YES"}
        {adapters/xml/ep2/axsep027nodechar2.i "infCpl"     ttInfAdic.infCpl     "YES"}

        PUT SKIP.
        /*fim "Z"*/

        FOR EACH ttObsCont
           WHERE ttObsCont.CodEstabelNF = ttNFe.CodEstabelNF
             AND ttObsCont.SerieNF      = ttNFe.SerieNF     
             AND ttObsCont.NrNotaFisNF  = ttNFe.NrNotaFisNF
             AND (ttObsCont.xTexto      <> ?
             AND  ttObsCont.xTexto      <> ""):

            /*Z04|xCampo|xTexto|*/
            PUT "Z04" "|".

            {adapters/xml/ep2/axsep027nodechar2.i "xCampo" ttObsCont.xCampo "YES"}
            {adapters/xml/ep2/axsep027nodechar2.i "xTexto" ttObsCont.xTexto "YES"}

            PUT SKIP.
            /*fim "Z04"*/
        END.

        FOR EACH ttObsFisco
           WHERE ttObsFisco.CodEstabelNF = ttNFe.CodEstabelNF 
             AND ttObsFisco.SerieNF      = ttNFe.SerieNF      
             AND ttObsFisco.NrNotaFisNF  = ttNFe.NrNotaFisNF
             AND (ttObsFisco.xTexto     <> ?
             AND  ttObsFisco.xTexto     <> ""):

            /*Z04|xCampo|xTexto|*/
            PUT "Z04" "|".

            {adapters/xml/ep2/axsep027nodechar2.i "xCampo" ttObsFisco.xCampo "YES"}
            {adapters/xml/ep2/axsep027nodechar2.i "xTexto" ttObsFisco.xTexto "YES"}
             
            PUT SKIP.
            /*fim "Z04"*/
        END.

        FOR EACH ttProcRef
           WHERE ttProcRef.CodEstabelNF = ttNFe.CodEstabelNF
             AND ttProcRef.SerieNF      = ttNFe.SerieNF     
             AND ttProcRef.NrNotaFisNF  = ttNFe.NrNotaFisNF
             AND (ttProcRef.nProc   <> ? AND ttProcRef.nProc   <> "")
             AND (ttProcRef.indProc <> ? AND ttProcRef.indProc <> "") :

            /*Z10|nProc|indProc|*/
            PUT "Z10" "|".
            
            {adapters/xml/ep2/axsep027nodechar.i "nProc"   ttProcRef.nProc   "YES"}
            {adapters/xml/ep2/axsep027nodechar.i "indProc" ttProcRef.indProc "YES"}
            
            PUT SKIP.
            /*fim "Z10"*/
        END.
    END.

END PROCEDURE.

PROCEDURE pi-imprime-Exporta-txt:

    FOR EACH  ttExporta
       WHERE  ttExporta.CodEstabelNF = ttNFe.CodEstabelNF
         AND  ttExporta.SerieNF      = ttNFe.SerieNF     
         AND  ttExporta.NrNotaFisNF  = ttNFe.NrNotaFisNF
         AND (ttExporta.UFSaidaPais <> ? AND ttExporta.UFSaidaPais <> "")
         AND (ttExporta.xLocExporta <> ? AND ttExporta.xLocExporta <> ""):

        /*ZA|UFSaidaPais|xLocExporta|xLocDespacho|*/
        PUT "ZA" "|".

        {adapters/xml/ep2/axsep027nodechar.i "UFSaidaPais"  ttExporta.UFSaidaPais  "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "xLocExporta"  ttExporta.xLocExporta  "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "xLocDespacho" ttExporta.xLocDespacho "NO" }
        
        PUT SKIP.
        /*fim "ZA"*/
    END.

END PROCEDURE.

PROCEDURE pi-imprime-Compra-txt:

    FOR EACH  ttCompra
       WHERE  ttCompra.CodEstabelNF = ttNFe.CodEstabelNF
         AND  ttCompra.SerieNF      = ttNFe.SerieNF     
         AND  ttCompra.NrNotaFisNF  = ttNFe.NrNotaFisNF
         AND ((ttCompra.xNEmp <> ? /* AND ttCompra.xNEmp <> "" */)
         OR   (ttCompra.xPed  <> ? /* AND ttCompra.xPed  <> "" */)
         OR   (ttCompra.xCont <> ? /* AND ttCompra.xCont <> "" */)) :

        /*ZB|xNEmp|xPed|xCont|*/
        PUT "ZB" "|".

        {adapters/xml/ep2/axsep027nodechar.i "xNEmp" ttCompra.xNEmp "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "xPed"  ttCompra.xPed  "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "xCont" ttCompra.xCont "YES"}
        
        PUT SKIP.
        /*fim "ZB"*/
    END.

END PROCEDURE.

PROCEDURE pi-imprime-Cana-txt:

    FOR EACH ttCana
       WHERE ttCana.CodEstabelNF = ttNFe.CodEstabelNF
         AND ttCana.SerieNF      = ttNFe.SerieNF
         AND ttCana.NrNotaFisNF  = ttNFe.NrNotaFisNF :

        /*ZC01|safra|ref|qTotMes|qTotAnt|qTotGer|vFor|vTotDed|vLiqFor|*/
        PUT "ZC01" "|".

        {adapters/xml/ep2/axsep027nodechar.i "safra"    ttCana.safra    "YES"}
        {adapters/xml/ep2/axsep027nodechar.i "ref"      ttCana.ref      "YES"}
        {adapters/xml/ep2/axsep027nodedec.i  "qTotMes"  ttCana.qTotMes  "YES" "10" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i  "qTotAnt"  ttCana.qTotAnt  "YES" "10" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i  "qTotGer"  ttCana.qTotGer  "YES" "10" "YES"}
        {adapters/xml/ep2/axsep027nodedec.i  "vFor"     ttCana.vFor     "YES" "2"  "YES"}
        {adapters/xml/ep2/axsep027nodedec.i  "vTotDed"  ttCana.vTotDed  "YES" "2"  "YES"}
        {adapters/xml/ep2/axsep027nodedec.i  "vLiqFor"  ttCana.vLiqFor  "YES" "2"  "YES"}

        PUT SKIP.
        /*fim "ZC01"*/

        FOR EACH ttForDia
           WHERE ttForDia.CodEstabelNF = ttCana.CodEstabelNF
             AND ttForDia.SerieNF      = ttCana.SerieNF
             AND ttForDia.NrNotaFisNF  = ttCana.NrNotaFisNF:

            /*ZC04|dia|qtde|*/
            PUT "ZC04" "|".

            {adapters/xml/ep2/axsep027nodechar.i "dia"   ttForDia.dia   "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "qtde"  ttForDia.qtde  "YES" "10" "YES"}

            PUT SKIP.
            /*fim "ZC04"*/

        END.

        FOR EACH ttDeduc
           WHERE ttDeduc.CodEstabelNF = ttCana.CodEstabelNF
             AND ttDeduc.SerieNF      = ttCana.SerieNF
             AND ttDeduc.NrNotaFisNF  = ttCana.NrNotaFisNF:

            /*ZC10|xDed|vDed|*/
            PUT "ZC10" "|".

            {adapters/xml/ep2/axsep027nodechar.i "xDed"  ttDeduc.xDed  "YES"}
            {adapters/xml/ep2/axsep027nodedec.i  "vDed"  ttDeduc.vDed  "YES" "2" "YES"}

            PUT SKIP.
            /*fim "ZC10"*/

        END.

    END.

END PROCEDURE.

/*------------------------------- ESTABELEC (Emitente da NF-e) --------------------------------*/

PROCEDURE pi-imprime-TXT-Emit:

    /*--- Exporta para o Software Emissor NF-e Estabelecimentos parametrizados para NF-e (Homologaá∆o e/ou Produá∆o) ---*/

    /* Imprime TXT Emissor */
    OUTPUT TO VALUE(pcArquivoEmitTXT) convert target "utf-8":U.

        /*
        EMITENTE|quantidade de registros de emitente no arquivo|
        C|tpDoc|numDoc|xNome|xFant|IE|IEST|IM|CNAE|CRT|xLgr|nro|xCpl|xBairro|cMun|xMun|UF|CEP|cPais|xPais|fone|
        */
    
        FOR FIRST ttEmit NO-LOCK:

            PUT "EMITENTE|1|" SKIP. /* 1 -> sempre ser† exportado apenas 1, pois s¢ se pode gerar notas de 1 estabelecimento */
            PUT "A" "|" ttEmit.VersaoLayout "|" SKIP.
            PUT "C" "|".
    
            /*tpDoc  -> Preencher com o tipo de documento: inserir a palavra "CPF" caso pessoa f°sica ou "CNPJ" caso pessoa jur°dica*/
            PUT "CNPJ" "|".
    
            /*numDoc -> N£mero do CPF com 11 d°gitos (caso o tpDoc for preenchido com …CPF ) ou o n£mero do CNPJ com 14 d°gitos (caso tpDoc for preenchido com …CNPJ )*/
            {adapters/xml/ep2/axsep027nodechar.i "CNPJ"    ttEmit.CNPJ    "YES"}
    
            /*xNome|xFant|IE|IEST|IM|CNAE|CRT|xLgr|nro|xCpl|xBairro|cMun|xMun|UF|CEP|cPais|xPais|fone|*/
    
            {adapters/xml/ep2/axsep027nodechar.i  "xNome"   ttEmit.xNome   "YES"}
            {adapters/xml/ep2/axsep027nodechar.i  "xFant"   ttEmit.xFant   "YES"}
            {adapters/xml/ep2/axsep027nodechar.i  "IE"      ttEmit.IE      "YES"}
            {adapters/xml/ep2/axsep027nodechar.i  "IEST"    ttEmit.IEST    "YES"}
            {adapters/xml/ep2/axsep027nodechar.i  "IM"      ttEmit.IM      "YES"}
            {adapters/xml/ep2/axsep027nodechar.i  "CNAE"    ttEmit.CNAE    "YES"}
            {adapters/xml/ep2/axsep027nodechar.i  "CRT"     ttEmit.CRT     "YES"}
            {adapters/xml/ep2/axsep027nodechar.i  "xLgr"    ttEmit.xLgr    "YES"}
            {adapters/xml/ep2/axsep027nodechar.i  "nro"     ttEmit.nro     "YES"}
            {adapters/xml/ep2/axsep027nodechar.i  "xCpl"    ttEmit.xCpl    "YES"}
            {adapters/xml/ep2/axsep027nodechar.i  "xBairro" ttEmit.xBairro "YES"}
            {adapters/xml/ep2/axsep027nodechar.i  "cMun"    ttEmit.cMun    "YES"}
            
            IF ttEmit.xMun = "Exterior" THEN DO:
            {adapters/xml/ep2/axsep027nodechar2.i "xMun"    ttEmit.xMun    "YES"}
            END.
            ELSE DO:
            {adapters/xml/ep2/axsep027nodechar.i  "xMun"    ttEmit.xMun    "YES"}
            END.
            
            {adapters/xml/ep2/axsep027nodechar.i  "UF"      ttEmit.UF      "YES"}
            {adapters/xml/ep2/axsep027nodechar.i  "CEP"     ttEmit.CEP     "YES"}
            {adapters/xml/ep2/axsep027nodechar.i  "cPais"   ttEmit.cPais   "YES"} 
            {adapters/xml/ep2/axsep027nodechar.i  "xPais"   ttEmit.xPais   "YES"}
            {adapters/xml/ep2/axsep027nodechar.i  "fone"    ttEmit.fone    "YES"}
            
            PUT SKIP.
            /*fim "C"*/
        END.

    OUTPUT CLOSE. /*fecha arquivo*/

END PROCEDURE.

/*--------------------------------------------------------------------------*/

