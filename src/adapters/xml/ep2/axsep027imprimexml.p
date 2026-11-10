/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSEP027IMPRIMEXML 2.00.00.028 } /*** "010028" ***/
{include/i-epc200.i AXSEP027IMPRIMEXML}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i axsep027imprimexml MUT}
&ENDIF

/*-------------------------------------------------
             axsep027ImprimeXML.p
-------------------------------------------------*/

{adapters/xml/ep2/axsep027.i}                  /* Definiá‰es Tabelas Tempor†rias */
{adapters/xml/ep2/axsep027extradeclarations.i} /* Outras Declaraá‰es             */

{cdp/cdcfgdis.i}

DEFINE INPUT PARAM PhGenXml AS HANDLE NO-UNDO.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttStack  .
DEFINE INPUT PARAM TABLE FOR ttAdi           .
DEFINE INPUT PARAM TABLE FOR ttArma          .
DEFINE INPUT PARAM TABLE FOR ttAutXML        .
DEFINE INPUT PARAM TABLE FOR ttAvulsa        .
DEFINE INPUT PARAM TABLE FOR ttCobr          .
DEFINE INPUT PARAM TABLE FOR ttCOFINSAliq    .
DEFINE INPUT PARAM TABLE FOR ttCOFINSNT      .
DEFINE INPUT PARAM TABLE FOR ttCOFINSOutr    .
DEFINE INPUT PARAM TABLE FOR ttCOFINSQtde    .
DEFINE INPUT PARAM TABLE FOR ttCOFINSST      .
DEFINE INPUT PARAM TABLE FOR ttICMSUFDest    .
DEFINE INPUT PARAM TABLE FOR ttComb          .
DEFINE INPUT PARAM TABLE FOR ttCompra        .
DEFINE INPUT PARAM TABLE FOR ttDest          .
DEFINE INPUT PARAM TABLE FOR ttDet           .
DEFINE INPUT PARAM TABLE FOR ttDetExport     .
DEFINE INPUT PARAM TABLE FOR ttDI            .
DEFINE INPUT PARAM TABLE FOR ttDup           .
DEFINE INPUT PARAM TABLE FOR ttEmit          .
DEFINE INPUT PARAM TABLE FOR ttEntrega       .
DEFINE INPUT PARAM TABLE FOR ttExporta       .
DEFINE INPUT PARAM TABLE FOR ttICMS00        .
DEFINE INPUT PARAM TABLE FOR ttICMS10        .
DEFINE INPUT PARAM TABLE FOR ttICMS20        .
DEFINE INPUT PARAM TABLE FOR ttICMS30        .
DEFINE INPUT PARAM TABLE FOR ttICMS40        .
DEFINE INPUT PARAM TABLE FOR ttICMS51        .
DEFINE INPUT PARAM TABLE FOR ttICMS60        .
DEFINE INPUT PARAM TABLE FOR ttICMS70        .
DEFINE INPUT PARAM TABLE FOR ttICMS90        .
DEFINE INPUT PARAM TABLE FOR ttICMSTot       .
DEFINE INPUT PARAM TABLE FOR ttIde           .
DEFINE INPUT PARAM TABLE FOR ttII            .
DEFINE INPUT PARAM TABLE FOR ttImpostoDevol  .
DEFINE INPUT PARAM TABLE FOR ttInfAdic       .
DEFINE INPUT PARAM TABLE FOR ttIPI           .
DEFINE INPUT PARAM TABLE FOR ttISSQN         .
DEFINE INPUT PARAM TABLE FOR ttISSQNtot      .
DEFINE INPUT PARAM TABLE FOR ttLacres        .
DEFINE INPUT PARAM TABLE FOR ttMed           .
DEFINE INPUT PARAM TABLE FOR ttNFe           .
DEFINE INPUT PARAM TABLE FOR ttrefNF         .
DEFINE INPUT PARAM TABLE FOR ttObsCont       .
DEFINE INPUT PARAM TABLE FOR ttObsFisco      .
DEFINE INPUT PARAM TABLE FOR ttPISAliq       .
DEFINE INPUT PARAM TABLE FOR ttPISNT         .
DEFINE INPUT PARAM TABLE FOR ttPISOutr       .
DEFINE INPUT PARAM TABLE FOR ttPISQtde       .
DEFINE INPUT PARAM TABLE FOR ttPISST         .
DEFINE INPUT PARAM TABLE FOR ttProcRef       .
DEFINE INPUT PARAM TABLE FOR ttReboque       .
DEFINE INPUT PARAM TABLE FOR ttRetirada      .
DEFINE INPUT PARAM TABLE FOR ttRetTrib       .
DEFINE INPUT PARAM TABLE FOR ttTransp        .
DEFINE INPUT PARAM TABLE FOR ttVeic          .
DEFINE INPUT PARAM TABLE FOR ttVol           .
DEFINE INPUT PARAM TABLE FOR ttrefNFP        .
DEFINE INPUT PARAM TABLE FOR ttrefCTe        .
DEFINE INPUT PARAM TABLE FOR ttrefECF        .
DEFINE INPUT PARAM TABLE FOR ttICMSPart      .
DEFINE INPUT PARAM TABLE FOR ttICMSST        .
DEFINE INPUT PARAM TABLE FOR ttICMSSN101     .
DEFINE INPUT PARAM TABLE FOR ttICMSSN102     .
DEFINE INPUT PARAM TABLE FOR ttICMSSN201     .
DEFINE INPUT PARAM TABLE FOR ttICMSSN202     .
DEFINE INPUT PARAM TABLE FOR ttICMSSN500     .
DEFINE INPUT PARAM TABLE FOR ttICMSSN900     .
DEFINE INPUT PARAM TABLE FOR ttCana          .
DEFINE INPUT PARAM TABLE FOR ttForDia        .
DEFINE INPUT PARAM TABLE FOR ttDeduc         .


/*-------------------------------------------------
            axsep027ImprimeXML.i
-------------------------------------------------*/

RUN pi-imprime-xml.

PROCEDURE pi-imprime-xml:



    FOR FIRST ttstack: END.

    ASSIGN iId        = ?
           lLayoutXML = YES
           hGenXml    = PhGenXml.

    FOR EACH ttNFe:

        RUN cdp/cd0360b.p (INPUT ttNFe.CodEstabelNF,
                           INPUT "NF-e":U,
                           OUTPUT cTpTrans).

        ASSIGN l-integ-tss-sincrono = LOOKUP(cTpTrans, "TSS,TC":U) > 0.

         RUN addNode      IN hGenXml (getStack(), "NFe", "", OUTPUT iId).
         RUN setAttribute IN hGenXml (INPUT iId,  "xmlns",   "http://www.portalfiscal.inf.br/nfe").

         addStack(iId).

              RUN addNode IN hGenXml (getStack(), "infNFe" , "", OUTPUT iId).
              addStack(iId).

                   RUN setAttribute IN hGenXml (INPUT iId, "versao", ttNFe.VersaoLayout).
                   RUN setAttribute IN hGenXml (INPUT iId, "Id",     ("NFe" + ttNFe.ChaveAcessoNFe)).
                   
                   RUN pi-imprime-Ide.

                   RUN pi-imprime-Emit.

                   RUN pi-imprime-Avulsa.

                   RUN pi-imprime-Dest.
                   
                   RUN pi-imprime-Retirada.

                   RUN pi-imprime-Entrega.

                   RUN pi-imprime-AutXML.

                   ASSIGN iContItem = 1.

                   FOR EACH ttDet
                       WHERE ttDet.CodEstabelNF = ttNFe.CodEstabelNF
                         AND ttDet.SerieNF      = ttNFe.SerieNF     
                         AND ttDet.NrNotaFisNF  = ttNFe.NrNotaFisNF :
                        
                         RUN addNode IN hGenXml (getStack(), "det", "", OUTPUT iId).
                         addStack(iId).
                
                              RUN setAttribute IN hGenXml (INPUT iId, "nItem", STRING(iContItem)).
                
                              RUN addNode IN hGenXml (getStack(), "prod", "", OUTPUT iId).
                              addStack(iId).
                
                                   RUN pi-imprime-Prod.
                
                                   RUN pi-imprime-DI-e-Adi.

                                   RUN pi-imprime-DetExport.

                                   {adapters/xml/ep2/axsep027nodechar.i  "xPed"     ttDet.xPed     "NO"      }
                                   {adapters/xml/ep2/axsep027nodechar.i  "nItemPed" ttDet.nItemPed "NO"      }
                                   {adapters/xml/ep2/axsep027nodechar.i  "nFCI"     ttDet.nFCI     "NO"      }
                
                                   RUN pi-imprime-Veic.
                
                                   RUN pi-imprime-Med.
                
                                   RUN pi-imprime-Arma.
                
                                   RUN pi-imprime-Comb.

                                   {adapters/xml/ep2/axsep027nodechar.i  "nRECOPI"  ttDet.nRECOPI  "NO"     }
                
                              delStack().
                
                              RUN addNode IN hGenXml (getStack(), "imposto", "", OUTPUT iId).
                              addStack(iId).
                                   
                                   /*NT2013.003*/
                                   {adapters/xml/ep2/axsep027nodedec.i "vTotTrib" ttDet.vTotTrib "NO"  "2" "YES"} /*NT2013.003 - Valor aproximado total de tributos federais, estaduais e municipais - campo NAO obrigatorio*/
                                   
                                   /* O grupo ISSQN Ç mutuamente exclusivo com os grupos ICMS */
                                   /* e II, isto Ç se ISSQN for informado os grupos ICMS e    */
                                   /* II n∆o ser∆o informados e viceversa (v2.0).             */
                                   IF  CAN-FIND (FIRST ttISSQN
                                                 WHERE ttISSQN.CodEstabelNF = ttDet.CodEstabelNF
                                                   AND ttISSQN.SerieNF      = ttDet.SerieNF     
                                                   AND ttISSQN.NrNotaFisNF  = ttDet.NrNotaFisNF
                                                   AND ttISSQN.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                   AND ttISSQN.ItCodigoNF   = ttDet.ItCodigoNF) THEN DO:

                                       RUN pi-imprime-IPI. /*NF-e 3.10 - permite IPI e ISSQN no mesmo item*/
                                       
                                       RUN pi-imprime-ISSQN.

                                   END.
                                   ELSE DO:

                                       RUN pi-imprime-ICMS.

                                       RUN pi-imprime-IPI.

                                       RUN pi-imprime-II.

                                   END.

                                   RUN pi-imprime-PIS.
                
                                   RUN pi-imprime-COFINS.

                                   RUN pi-imprime-ICMSUFDest.

                              delStack().

                              RUN pi-imprime-ImpostoDevol.
                
                              {adapters/xml/ep2/axsep027nodechar2.i "infAdProd" ttDet.infAdProd "NO"}
                
                         delStack().
                
                         ASSIGN iContItem = iContItem + 1.
                   END.
                   
                   RUN pi-imprime-Total.

                   RUN pi-imprime-Transp.

                   RUN pi-imprime-Cobr.

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
                       RUN pi-imprime-InfAdic.

                   RUN pi-imprime-Exporta.

                   RUN pi-imprime-Compra.

                   RUN pi-imprime-Cana.

              delStack().

         delStack().

    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-Ide:

                              FOR EACH ttIde
                                 WHERE ttIde.CodEstabelNF = ttNFe.CodEstabelNF
                                   AND ttIde.SerieNF      = ttNFe.SerieNF     
                                   AND ttIde.NrNotaFisNF  = ttNFe.NrNotaFisNF:

                                   RUN addNode IN hGenXml (getStack(), "ide", "", OUTPUT iId).
                                   addStack(iId).

                                        {adapters/xml/ep2/axsep027nodechar.i "cUF"      ttIde.cUF      "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "cNF"      ttIde.cNF      "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "natOp"    ttIde.natOp    "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "indPag"   ttIde.indPag   "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "mod"      ttIde.mod      "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "serie"    ttIde.serie    "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "nNF"      ttIde.nNF      "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "dhEmi"    ttIde.dhEmi    "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "dhSaiEnt" ttIde.dhSaiEnt "NO" }
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
                                        {adapters/xml/ep2/axsep027nodechar.i "dhCont"   ttIde.dhCont   "NO" }
                                        {adapters/xml/ep2/axsep027nodechar.i "xJust"    ttIde.xJust    "NO" }


                                        FOR EACH  ttrefNF
                                           WHERE  ttrefNF.CodEstabelNF = ttIde.CodEstabelNF
                                             AND  ttrefNF.SerieNF      = (IF ttIde.SerieNF = "" THEN "0" ELSE ttIde.SerieNF)
                                             AND  ttrefNF.NrNotaFisNF  = ttIde.NrNotaFisNF :

                                             RUN addNode IN hGenXml (getStack(), "NFref", "", OUTPUT iId).
                                             addStack(iId).

                                                  /* Nota Eletronica, envia somente tag <refNFe> */
                                                  IF  ttrefNF.refNFe <> "" THEN DO:
                                                      {adapters/xml/ep2/axsep027nodechar.i "refNFe"   ttrefNF.refNFe  "YES"}
                                                  END.
                                                  /* Nao e' Nota Eletronica, enviar colecao <refNF> */
                                                  ELSE DO:
                                                  
                                                      RUN addNode IN hGenXml (getStack(), "refNF",  "",             OUTPUT iId).
                                                      addStack(iId).
    
                                                           {adapters/xml/ep2/axsep027nodechar.i "cUF"   ttrefNF.cUF   "YES"}
                                                           {adapters/xml/ep2/axsep027nodechar.i "AAMM"  ttrefNF.AAMM  "YES"}
                                                           {adapters/xml/ep2/axsep027nodechar.i "CNPJ"  ttrefNF.CNPJ  "YES"}
                                                           {adapters/xml/ep2/axsep027nodechar.i "mod"   ttrefNF.mod   "YES"}
                                                           {adapters/xml/ep2/axsep027nodechar.i "serie" ttrefNF.serie "YES"}
                                                           {adapters/xml/ep2/axsep027nodechar.i "nNF"   ttrefNF.nNF   "YES"}
                                                           
                                                      delStack().
                                                  END.

                                             delStack().

                                        END.

                                        FOR EACH  ttrefNFP
                                           WHERE  ttrefNFP.CodEstabelNF = ttIde.CodEstabelNF
                                             AND  ttrefNFP.SerieNF      = (IF ttIde.SerieNF = "" THEN "0" ELSE ttIde.SerieNF)
                                             AND  ttrefNFP.NrNotaFisNF  = ttIde.NrNotaFisNF :

                                             RUN addNode IN hGenXml (getStack(), "NFref", "", OUTPUT iId).
                                             addStack(iId).
                                                  
                                                 RUN addNode IN hGenXml (getStack(), "refNFP",  "",             OUTPUT iId).
                                                 addStack(iId).

                                                      {adapters/xml/ep2/axsep027nodechar.i "cUF"   ttrefNFP.cUF   "YES"}
                                                      {adapters/xml/ep2/axsep027nodechar.i "AAMM"  ttrefNFP.AAMM  "YES"}

                                                      IF  ttrefNFP.CPF <> "" THEN DO:
                                                          {adapters/xml/ep2/axsep027nodechar.i "CPF"  ttrefNFP.CPF  "YES"}
                                                      END.
                                                      ELSE DO:
                                                          {adapters/xml/ep2/axsep027nodechar.i "CNPJ" ttrefNFP.CNPJ "YES"}
                                                      END.

                                                      {adapters/xml/ep2/axsep027nodechar.i "IE"    ttrefNFP.IE    "YES"}
                                                      {adapters/xml/ep2/axsep027nodechar.i "mod"   ttrefNFP.mod   "YES"}
                                                      {adapters/xml/ep2/axsep027nodechar.i "serie" ttrefNFP.serie "YES"}
                                                      {adapters/xml/ep2/axsep027nodechar.i "nNF"   ttrefNFP.nNF   "YES"}
                                                      
                                                 delStack().

                                             delStack().
                                        END.

                                        FOR EACH  ttrefCTe
                                           WHERE  ttrefCTe.CodEstabelNF = ttIde.CodEstabelNF
                                             AND  ttrefCTe.SerieNF      = (IF ttIde.SerieNF = "" THEN "0" ELSE ttIde.SerieNF)
                                             AND  ttrefCTe.NrNotaFisNF  = ttIde.NrNotaFisNF :

                                             RUN addNode IN hGenXml (getStack(), "NFref", "", OUTPUT iId).
                                             addStack(iId).
                                                  
                                                 {adapters/xml/ep2/axsep027nodechar.i "refCTe"   ttrefCTe.refCTe  "YES"}

                                             delStack().
                                        END.

                                        FOR EACH  ttrefECF 
                                           WHERE  ttrefECF.CodEstabelNF = ttIde.CodEstabelNF
                                             AND  ttrefECF.SerieNF      = (IF ttIde.SerieNF = "" THEN "0" ELSE ttIde.SerieNF)
                                             AND  ttrefECF.NrNotaFisNF  = ttIde.NrNotaFisNF :

                                             RUN addNode IN hGenXml (getStack(), "NFref", "", OUTPUT iId).
                                             addStack(iId).
                                                  
                                                 RUN addNode IN hGenXml (getStack(), "refECF",  "",             OUTPUT iId).
                                                 addStack(iId).
    
                                                      {adapters/xml/ep2/axsep027nodechar.i "mod"    ttrefECF.mod    "YES"}
                                                      {adapters/xml/ep2/axsep027nodechar.i "nECF"   ttrefECF.nECF   "YES"}
                                                      {adapters/xml/ep2/axsep027nodechar.i "nCOO"   ttrefECF.nCOO   "YES"}
                                                      
                                                 delStack().

                                             delStack().
                                        END.

                                   delStack().

                              END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-Emit:

                              FOR EACH ttEmit
                                 WHERE ttEmit.CodEstabelNF = ttNFe.CodEstabelNF
                                   AND ttEmit.SerieNF      = ttNFe.SerieNF     
                                   AND ttEmit.NrNotaFisNF  = ttNFe.NrNotaFisNF:
                                  
                                   RUN addNode IN hGenXml (getStack(), "emit", "", OUTPUT iId).
                                   addStack(iId).

                                        
                                        IF  ttEmit.CPF <> "" THEN DO:
                                            {adapters/xml/ep2/axsep027nodechar.i "CPF"  ttEmit.CPF  "YES"}
                                        END.
                                        ELSE DO:
                                            {adapters/xml/ep2/axsep027nodechar.i "CNPJ" ttEmit.CNPJ "YES"}
                                        END.

                                        {adapters/xml/ep2/axsep027nodechar.i "xNome" ttEmit.xNome "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "xFant" ttEmit.xFant "NO" }

                                        RUN addNode IN hGenXml (getStack(), "enderEmit", "",           OUTPUT iId).
                                        addStack(iId).
                                             {adapters/xml/ep2/axsep027nodechar.i  "xLgr"    ttEmit.xLgr    "YES"}
                                             {adapters/xml/ep2/axsep027nodechar.i  "nro"     ttEmit.nro     "YES"}
                                             {adapters/xml/ep2/axsep027nodechar.i  "xCpl"    ttEmit.xCpl    "NO" }
                                             {adapters/xml/ep2/axsep027nodechar.i  "xBairro" ttEmit.xBairro "YES"}
                                             {adapters/xml/ep2/axsep027nodechar.i  "cMun"    ttEmit.cMun    "YES"}

                                             IF ttEmit.xMun = "Exterior" THEN DO:
                                             {adapters/xml/ep2/axsep027nodechar2.i "xMun"    ttEmit.xMun    "YES"}
                                             END.
                                             ELSE DO:
                                             {adapters/xml/ep2/axsep027nodechar.i  "xMun"    ttEmit.xMun    "YES"}
                                             END.
                                             
                                             {adapters/xml/ep2/axsep027nodechar.i  "UF"      ttEmit.UF      "YES"}
                                             {adapters/xml/ep2/axsep027nodechar.i  "CEP"     ttEmit.CEP     "NO" }
                                             {adapters/xml/ep2/axsep027nodechar.i  "cPais"   ttEmit.cPais   "NO" }
                                             {adapters/xml/ep2/axsep027nodechar.i  "xPais"   ttEmit.xPais   "NO" }
                                             {adapters/xml/ep2/axsep027nodechar.i  "fone"    ttEmit.fone    "NO" }
                                        delStack().

                                        {adapters/xml/ep2/axsep027nodechar.i "IE"   ttEmit.IE   "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "IEST" ttEmit.IEST "NO" }
                                        {adapters/xml/ep2/axsep027nodechar.i "IM"   ttEmit.IM   "NO" }
                                        {adapters/xml/ep2/axsep027nodechar.i "CNAE" ttEmit.CNAE "NO" }
                                        {adapters/xml/ep2/axsep027nodechar.i "CRT"  ttEmit.CRT  "YES"}
                                   delStack().

                              END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-Avulsa:

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
                                  
                                  
                                   RUN addNode IN hGenXml (getStack(), "avulsa", "", OUTPUT iId).
                                   addStack(iId).

                                        {adapters/xml/ep2/axsep027nodechar.i "CNPJ"    ttAvulsa.CNPJ    "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "xOrgao"  ttAvulsa.xOrgao  "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "matr"    ttAvulsa.matr    "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "xAgente" ttAvulsa.xAgente "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "fone"    ttAvulsa.fone    "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "UF"      ttAvulsa.UF      "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "nDAR"    ttAvulsa.nDAR    "YES"}
                                        {adapters/xml/ep2/axsep027nodedate.i "dEmi"    ttAvulsa.dEmi    "YES"}
                                        {adapters/xml/ep2/axsep027nodedec.i  "vDAR"    ttAvulsa.vDAR    "YES" "2" "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "repEmi"  ttAvulsa.repEmi  "YES"}
                                        {adapters/xml/ep2/axsep027nodedate.i "dPag"    ttAvulsa.dPag    "NO" }
                                   delStack().

                              END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-Dest:

                              FOR EACH ttDest
                                 WHERE ttDest.CodEstabelNF = ttNFe.CodEstabelNF
                                   AND ttDest.SerieNF      = ttNFe.SerieNF     
                                   AND ttDest.NrNotaFisNF  = ttNFe.NrNotaFisNF:
                                  
                                   RUN addNode IN hGenXml (getStack(), "dest", "", OUTPUT iId).
                                   addStack(iId).

                                        IF  ttDest.i-natureza = 3 THEN DO: /*Estrangeiro*/
                                            {adapters/xml/ep2/axsep027nodechar.i "idEstrangeiro" ttDest.idEstrangeiro "YES"}
                                        END.
                                        ELSE DO:
                                        
                                            IF  ttDest.i-natureza = 1 THEN DO: /* Pessoa F°sica */
                                            {adapters/xml/ep2/axsep027nodechar.i "CPF"        ttDest.CPF   "YES"}
                                            END.
                                            ELSE DO:
                                            {adapters/xml/ep2/axsep027nodechar.i "CNPJ"       ttDest.CNPJ  "YES"} 
                                            END.
                                        END.
                                        
                                        {adapters/xml/ep2/axsep027nodechar.i "xNome"         ttDest.xNome         "YES"}
                                        

                                        RUN addNode IN hGenXml (getStack(), "enderDest", "",           OUTPUT iId).
                                        addStack(iId).

                                             {adapters/xml/ep2/axsep027nodechar.i  "xLgr"    ttDest.xLgr    "YES"}
                                             {adapters/xml/ep2/axsep027nodechar.i  "nro"     ttDest.nro     "YES"}
                                             {adapters/xml/ep2/axsep027nodechar.i  "xCpl"    ttDest.xCpl    "NO" }
                                             {adapters/xml/ep2/axsep027nodechar.i  "xBairro" ttDest.xBairro "YES"}
                                             {adapters/xml/ep2/axsep027nodechar.i  "cMun"    ttDest.cMun    "YES"}

                                             IF ttDest.xMun = "Exterior" THEN DO:
                                             {adapters/xml/ep2/axsep027nodechar2.i "xMun"    ttDest.xMun    "YES"}
                                             END.
                                             ELSE DO:
                                             {adapters/xml/ep2/axsep027nodechar.i  "xMun"    ttDest.xMun    "YES"}
                                             END.

                                             {adapters/xml/ep2/axsep027nodechar.i  "UF"      ttDest.UF      "YES"}
                                             {adapters/xml/ep2/axsep027nodechar.i  "CEP"     ttDest.CEP     "NO" }
                                             {adapters/xml/ep2/axsep027nodechar.i  "cPais"   ttDest.cPais   "NO" }
                                             {adapters/xml/ep2/axsep027nodechar.i  "xPais"   ttDest.xPais   "NO" }
                                             {adapters/xml/ep2/axsep027nodechar.i  "fone"    ttDest.fone    "NO" }
                                        delStack().

                                        {adapters/xml/ep2/axsep027nodechar.i  "indIEDest" ttDest.indIEDest    "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i  "IE"        ttDest.IE           "NO" }
                                        {adapters/xml/ep2/axsep027nodechar.i  "ISUF"      ttDest.ISUF         "NO" }
                                        {adapters/xml/ep2/axsep027nodechar.i  "IM"        ttDest.IM           "NO" }
                                        {adapters/xml/ep2/axsep027nodechar2.i "email"     ttDest.email        "NO" }
                                   delStack().

                              END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-Retirada:

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

                                   RUN addNode IN hGenXml (getStack(), "retirada", "", OUTPUT iId).
                                   addStack(iId).
                                        
                                        IF  ttRetirada.CPF <> "" THEN DO:
                                            {adapters/xml/ep2/axsep027nodechar.i "CPF"     ttRetirada.CPF     "YES"}
                                        END.
                                        ELSE DO:
                                            {adapters/xml/ep2/axsep027nodechar.i "CNPJ"    ttRetirada.CNPJ    "YES"}
                                        END. 
                                        
                                        {adapters/xml/ep2/axsep027nodechar.i "xLgr"    ttRetirada.xLgr    "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "nro"     ttRetirada.nro     "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "xCpl"    ttRetirada.xCpl    "NO" }
                                        {adapters/xml/ep2/axsep027nodechar.i "xBairro" ttRetirada.xBairro "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "cMun"    ttRetirada.cMun    "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "xMun"    ttRetirada.xMun    "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "UF"      ttRetirada.UF      "YES"}
                                   delStack().

                              END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-Entrega:

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


                                   RUN addNode IN hGenXml (getStack(), "entrega", "", OUTPUT iId).
                                   addStack(iId).

                                        IF  ttEntrega.CPF <> "" THEN DO:
                                            {adapters/xml/ep2/axsep027nodechar.i "CPF"     ttEntrega.CPF     "YES"}
                                        END.
                                        ELSE DO:
                                            {adapters/xml/ep2/axsep027nodechar.i "CNPJ"    ttEntrega.CNPJ    "YES"}
                                        END. 
                                        {adapters/xml/ep2/axsep027nodechar.i  "xLgr"    ttEntrega.xLgr    "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i  "nro"     ttEntrega.nro     "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i  "xCpl"    ttEntrega.xCpl    "NO" }
                                        {adapters/xml/ep2/axsep027nodechar.i  "xBairro" ttEntrega.xBairro "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i  "cMun"    ttEntrega.cMun    "YES"}

                                        IF ttEntrega.xMun = "Exterior" THEN DO:
                                        {adapters/xml/ep2/axsep027nodechar2.i "xMun"    ttEntrega.xMun    "YES"}
                                        END.
                                        ELSE DO:
                                        {adapters/xml/ep2/axsep027nodechar.i  "xMun"    ttEntrega.xMun    "YES"}
                                        END.

                                        {adapters/xml/ep2/axsep027nodechar.i  "UF"      ttEntrega.UF      "YES"}
                                   delStack().

                              END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-AutXML:

                              FOR EACH  ttAutXML
                                 WHERE  ttAutXML.CodEstabelNF = ttNFe.CodEstabelNF
                                   AND  ttAutXML.SerieNF      = ttNFe.SerieNF     
                                   AND  ttAutXML.NrNotaFisNF  = ttNFe.NrNotaFisNF
                                   AND (ttAutXML.CNPJ    <> ? OR
                                        ttAutXML.CPF     <> ?) :


                                   RUN addNode IN hGenXml (getStack(), "autXML", "", OUTPUT iId).
                                   addStack(iId).

                                        IF  ttAutXML.CPF <> "":U THEN DO:
                                            {adapters/xml/ep2/axsep027nodechar.i "CPF"     ttAutXML.CPF     "YES"}
                                        END.
                                        ELSE DO:
                                            {adapters/xml/ep2/axsep027nodechar.i "CNPJ"    ttAutXML.CNPJ    "YES"}
                                        END. 

                                   delStack().

                              END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-Prod:

                                             {adapters/xml/ep2/axsep027nodechar2.i "cProd"    ttDet.cProd    "YES"}
                                             {adapters/xml/ep2/axsep027nodechar.i  "cEAN"     ttDet.cEAN     "YES"}
                                             {adapters/xml/ep2/axsep027nodechar2.i "xProd"    ttDet.xProd    "YES"}
                                             {adapters/xml/ep2/axsep027nodechar.i  "NCM"      ttDet.NCM      "NO" }
                                             {adapters/xml/ep2/axsep027nodechar.i  "NVE"      ttDet.NVE[1]   "NO" }
                                             {adapters/xml/ep2/axsep027nodechar.i  "NVE"      ttDet.NVE[2]   "NO" }
                                             {adapters/xml/ep2/axsep027nodechar.i  "NVE"      ttDet.NVE[3]   "NO" }
                                             {adapters/xml/ep2/axsep027nodechar.i  "NVE"      ttDet.NVE[4]   "NO" }
                                             {adapters/xml/ep2/axsep027nodechar.i  "NVE"      ttDet.NVE[5]   "NO" }
                                             {adapters/xml/ep2/axsep027nodechar.i  "NVE"      ttDet.NVE[6]   "NO" }
                                             {adapters/xml/ep2/axsep027nodechar.i  "NVE"      ttDet.NVE[7]   "NO" }
                                             {adapters/xml/ep2/axsep027nodechar.i  "NVE"      ttDet.NVE[8]   "NO" }
                                             {adapters/xml/ep2/axsep027nodechar.i  "CEST"     ttDet.CEST     "NO" }
                                             {adapters/xml/ep2/axsep027nodechar.i  "EXTIPI"   ttDet.EXTIPI   "NO" }
                                             {adapters/xml/ep2/axsep027nodechar.i  "CFOP"     ttDet.CFOP     "YES"}
                                             {adapters/xml/ep2/axsep027nodechar2.i "uCom"     ttDet.uCom     "YES"}
                                             {adapters/xml/ep2/axsep027nodedec.i   "qCom"     ttDet.qCom     "YES" "4"  "NO" }
                                             {adapters/xml/ep2/axsep027nodedec.i   "vUnCom"   ttDet.vUnCom   "YES" fn-retorna-nro-decimais-nfe-FT0301() "NO" } /*n∆o enviar sempre 10 decimais, e sim o que estiver parametrizado no FT0301*/
                                             {adapters/xml/ep2/axsep027nodedec.i   "vProd"    ttDet.vProd    "YES" "2"  "YES"}
                                             {adapters/xml/ep2/axsep027nodechar.i  "cEANTrib" ttDet.cEANTrib "YES"}
                                             {adapters/xml/ep2/axsep027nodechar2.i "uTrib"    ttDet.uTrib    "YES"}
                                             {adapters/xml/ep2/axsep027nodedec.i   "qTrib"    ttDet.qTrib    "YES" "4"  "NO" }
                                             {adapters/xml/ep2/axsep027nodedec.i   "vUnTrib"  ttDet.vUnTrib  "YES" fn-retorna-nro-decimais-nfe-FT0301() "NO" } /*n∆o enviar sempre 10 decimais, e sim o que estiver parametrizado no FT0301*/
                                             {adapters/xml/ep2/axsep027nodedec.i   "vFrete"   ttDet.vFrete   "NO"  "2"  "YES"}
                                             {adapters/xml/ep2/axsep027nodedec.i   "vSeg"     ttDet.vSeg     "NO"  "2"  "YES"}
                                             {adapters/xml/ep2/axsep027nodedec.i   "vDesc"    ttDet.vDesc    "NO"  "2"  "YES"}
                                             {adapters/xml/ep2/axsep027nodedec.i   "vOutro"   ttDet.vOutro   "NO"  "2"  "YES"}
                                             {adapters/xml/ep2/axsep027nodechar.i  "indTot"   ttDet.indTot   "YES"     }
                                             /*{adapters/xml/ep2/axsep027nodechar.i  "xPed"     ttDet.xPed     "NO"      }*/
                                             /*{adapters/xml/ep2/axsep027nodechar.i  "nItemPed" ttDet.nItemPed "NO"      }*/

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-DI-e-Adi:

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

                                                  RUN addNode IN hGenXml (getStack(), "DI", "", OUTPUT iId).
                                                  addStack(iId).

                                                       {adapters/xml/ep2/axsep027nodechar.i "nDI"          ttDI.nDI          "YES"}
                                                       {adapters/xml/ep2/axsep027nodedate.i "dDI"          ttDI.dDI          "YES"}
                                                       {adapters/xml/ep2/axsep027nodechar.i "xLocDesemb"   ttDI.xLocDesemb   "YES"}
                                                       {adapters/xml/ep2/axsep027nodechar.i "UFDesemb"     ttDI.UFDesemb     "YES"}
                                                       {adapters/xml/ep2/axsep027nodedate.i "dDesemb"      ttDI.dDesemb      "YES"}
                                                       {adapters/xml/ep2/axsep027nodechar.i "tpViaTransp"  ttDI.tpViaTransp  "YES"}
                                                       IF  ttDI.tpViaTransp = "1" THEN DO: /*Valor vAFRMM obrigatorio para Via de Transporte Maritimo*/
                                                       {adapters/xml/ep2/axsep027nodedec.i  "vAFRMM"       ttDI.vAFRMM       "YES" "2" "YES"}
                                                       END.
                                                       ELSE DO:
                                                       {adapters/xml/ep2/axsep027nodedec.i  "vAFRMM"       ttDI.vAFRMM       "NO" "2" "YES"}
                                                       END.
                                                       {adapters/xml/ep2/axsep027nodechar.i "tpIntermedio" ttDI.tpIntermedio "YES"}
                                                       {adapters/xml/ep2/axsep027nodechar.i "CNPJ"         ttDI.CNPJ         "NO" }
                                                       {adapters/xml/ep2/axsep027nodechar.i "UFTerceiro"   ttDI.UFTerceiro   "NO" }
                                                       {adapters/xml/ep2/axsep027nodechar.i "cExportador"  ttDI.cExportador  "YES"}

                                                       FOR EACH ttAdi NO-LOCK
                                                          WHERE ttAdi.CodEstabelNF = ttDet.CodEstabelNF
                                                            AND ttAdi.SerieNF      = ttDet.SerieNF     
                                                            AND ttAdi.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                            AND ttAdi.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                            AND ttAdi.ItCodigoNF   = ttDet.ItCodigoNF
                                                            AND ttAdi.nDI          = ttDI.nDI:
                                                    
                                                            RUN addNode IN hGenXml (getStack(), "adi", "", OUTPUT iId).
                                                            addStack(iId).
                                                    
                                                                 {adapters/xml/ep2/axsep027nodechar.i "nAdicao"     ttAdi.nAdicao     "YES"}
                                                                 {adapters/xml/ep2/axsep027nodechar.i "nSeqAdic"    ttAdi.nSeqAdic    "YES"}
                                                                 {adapters/xml/ep2/axsep027nodechar.i "cFabricante" ttAdi.cFabricante "YES"}
                                                                 {adapters/xml/ep2/axsep027nodedec.i  "vDescDI"     ttAdi.vDescDI     "NO" "2" "YES"}
                                                                 {adapters/xml/ep2/axsep027nodechar.i "nDraw"       ttAdi.nDraw       "NO" }
                                                            delStack().
                                                    
                                                       END.
                                                  delStack().
                                             END.

END PROCEDURE.

PROCEDURE pi-imprime-DetExport:

                                             FOR EACH ttDetExport NO-LOCK
                                                WHERE ttDetExport.CodEstabelNF = ttDet.CodEstabelNF
                                                  AND ttDetExport.SerieNF      = ttDet.SerieNF     
                                                  AND ttDetExport.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                  AND ttDetExport.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                  AND ttDetExport.ItCodigoNF   = ttDet.ItCodigoNF:
                                            
                                                  RUN addNode IN hGenXml (getStack(), "detExport", "", OUTPUT iId).
                                                  addStack(iId).

                                                      {adapters/xml/ep2/axsep027nodechar.i "nDraw"     ttDetExport.nDraw     "NO" }

                                                      /*Grupo "exportInd" nao obrigatorio, mas se for gerado, os 3 campos "nRE, chNFe e qExport" s∆o obrigatorios*/
                                                      IF  (ttDetExport.nRE     <> ? AND ttDetExport.nRE     <> "" )
                                                      AND (ttDetExport.chNFe   <> ? AND ttDetExport.chNFe   <> "" )
                                                      AND (ttDetExport.qExport <> ? AND ttDetExport.qExport <> 0  ) THEN DO:
                                                      
                                                          RUN addNode IN hGenXml (getStack(), "exportInd", "", OUTPUT iId).
                                                          addStack(iId).
    
                                                              {adapters/xml/ep2/axsep027nodechar.i "nRE"     ttDetExport.nRE              "YES"}
                                                              {adapters/xml/ep2/axsep027nodechar.i "chNFe"   ttDetExport.chNFe            "YES"}
                                                              {adapters/xml/ep2/axsep027nodedec.i  "qExport" ttDetExport.qExport "NO" "4" "YES"}
                                                          
                                                          delStack().
                                                      END.
                                                  delStack().
                                             END.

END PROCEDURE.

PROCEDURE pi-imprime-Veic:

                                             FOR EACH ttVeic
                                                WHERE ttVeic.CodEstabelNF = ttDet.CodEstabelNF
                                                  AND ttVeic.SerieNF      = ttDet.SerieNF     
                                                  AND ttVeic.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                  AND ttVeic.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                  AND ttVeic.ItCodigoNF   = ttDet.ItCodigoNF :
                                                 
                                                  RUN addNode IN hGenXml (getStack(), "veicProd", "", OUTPUT iId).
                                                  addStack(iId).

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

                                                  delStack().

                                             END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-Med:

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
                                                 
                                                  RUN addNode IN hGenXml (getStack(), "med", "", OUTPUT iId).
                                                  addStack(iId).

                                                       {adapters/xml/ep2/axsep027nodechar.i "nLote" ttMed.nLote "YES"}
                                                       {adapters/xml/ep2/axsep027nodedec.i  "qLote" ttMed.qLote "YES" "3" "YES"}
                                                       {adapters/xml/ep2/axsep027nodedate.i "dFab"  ttMed.dFab  "YES"}
                                                       {adapters/xml/ep2/axsep027nodedate.i "dVal"  ttMed.dVal  "YES"}
                                                       {adapters/xml/ep2/axsep027nodedec.i  "vPMC"  ttMed.vPMC  "YES" "2" "YES"}
                                                  delStack().

                                             END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-Arma:

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

                                                  RUN addNode IN hGenXml (getStack(), "arma", "", OUTPUT iId).
                                                  addStack(iId).

                                                       {adapters/xml/ep2/axsep027nodechar.i "tpArma" ttArma.tpArma "YES"}
                                                       {adapters/xml/ep2/axsep027nodechar.i "nSerie" ttArma.nSerie "YES"}
                                                       {adapters/xml/ep2/axsep027nodechar.i "nCano"  ttArma.nCano  "YES"}
                                                       {adapters/xml/ep2/axsep027nodechar.i "descr"  ttArma.descr  "YES"}
                                                  delStack().

                                             END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-Comb:

                                             FOR EACH ttComb
                                                WHERE ttComb.CodEstabelNF = ttDet.CodEstabelNF
                                                  AND ttComb.SerieNF      = ttDet.SerieNF     
                                                  AND ttComb.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                  AND ttComb.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                  AND ttComb.ItCodigoNF   = ttDet.ItCodigoNF :
                                                 
                                                  RUN addNode IN hGenXml (getStack(), "comb", "", OUTPUT iId).
                                                  addStack(iId).

                                                       {adapters/xml/ep2/axsep027nodechar.i "cProdANP" ttComb.cProdANP "YES"}
                                                       {adapters/xml/ep2/axsep027nodedec.i  "pMixGN"   ttComb.pMixGN   "NO" "4" "NO" }
                                                       {adapters/xml/ep2/axsep027nodechar.i "CODIF"    ttComb.CODIF    "NO" }
                                                       {adapters/xml/ep2/axsep027nodedec.i  "qTemp"    ttComb.qTemp    "NO" "4" "YES"}
                                                       {adapters/xml/ep2/axsep027nodechar.i "UFCons"   ttComb.UFCons   "YES"}

                                                       IF  ttComb.qBCProd   <> ?
                                                       AND ttComb.vAliqProd <> ?
                                                       AND ttComb.vCIDE     <> ? THEN DO:
                                                       
                                                           RUN addNode IN hGenXml (getStack(), "CIDE", "", OUTPUT iId).
                                                           addStack(iId).
    
                                                                {adapters/xml/ep2/axsep027nodedec.i "qBCProd"   ttComb.qBCProd   "YES" "4" "YES"}
                                                                {adapters/xml/ep2/axsep027nodedec.i "vAliqProd" ttComb.vAliqProd "YES" "4" "YES"}
                                                                {adapters/xml/ep2/axsep027nodedec.i "vCIDE"     ttComb.vCIDE     "YES" "2" "YES"}
                                                           delStack().
                                                       END.

                                                       IF (ttComb.nBico   <> ?
                                                       OR  ttComb.nBomba  <> ?
                                                       OR  ttComb.nTanque <> ?
                                                       OR  ttComb.vEncIni <> ?
                                                       OR  ttComb.vEncFin <> ?) THEN DO:

                                                           RUN addNode IN hGenXml (getStack(), "encerrante", "", OUTPUT iId).
                                                           addStack(iId).
    
                                                                {adapters/xml/ep2/axsep027nodechar.i "nBico  "   ttComb.nBico     "YES"}
                                                                {adapters/xml/ep2/axsep027nodechar.i "nBomba "   ttComb.nBomba    "NO" }
                                                                {adapters/xml/ep2/axsep027nodechar.i "nTanque"   ttComb.nTanque   "YES"}
                                                                {adapters/xml/ep2/axsep027nodedec.i  "vEncIni"   ttComb.vEncIni   "YES" "3" "YES"}
                                                                {adapters/xml/ep2/axsep027nodedec.i  "vEncFin"   ttComb.vEncFin   "YES" "3" "YES"}

                                                           delStack().
                                                       END.

                                                  delStack().

                                             END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-ICMS:

                                             RUN addNode IN hGenXml (getStack(), "ICMS", "", OUTPUT iId).
                                             addStack(iId).

                                                  FOR EACH ttICMS00
                                                     WHERE ttICMS00.CodEstabelNF = ttDet.CodEstabelNF
                                                       AND ttICMS00.SerieNF      = ttDet.SerieNF     
                                                       AND ttICMS00.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                       AND ttICMS00.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                       AND ttICMS00.ItCodigoNF   = ttDet.ItCodigoNF :
                                                      
                                                       RUN addNode IN hGenXml (getStack(), "ICMS00", "", OUTPUT iId).
                                                       addStack(iId).

                                                            {adapters/xml/ep2/axsep027nodechar.i "orig"  ttICMS00.orig  "YES"}
                                                            {adapters/xml/ep2/axsep027nodechar.i "CST"   ttICMS00.CST   "YES"}
                                                            {adapters/xml/ep2/axsep027nodechar.i "modBC" ttICMS00.modBC "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vBC"   ttICMS00.vBC   "YES" "2" "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pICMS" ttICMS00.pICMS "YES" "4" "NO "}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vICMS" ttICMS00.vICMS "YES" "2" "YES"}
                                                       delStack().
                                                  END.
                                                  FOR EACH ttICMS10
                                                     WHERE ttICMS10.CodEstabelNF = ttDet.CodEstabelNF
                                                       AND ttICMS10.SerieNF      = ttDet.SerieNF     
                                                       AND ttICMS10.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                       AND ttICMS10.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                       AND ttICMS10.ItCodigoNF   = ttDet.ItCodigoNF :

                                                       RUN addNode IN hGenXml (getStack(), "ICMS10", "", OUTPUT iId).
                                                       addStack(iId).

                                                            {adapters/xml/ep2/axsep027nodechar.i "orig"     ttICMS10.orig     "YES"}
                                                            {adapters/xml/ep2/axsep027nodechar.i "CST"      ttICMS10.CST      "YES"}
                                                            {adapters/xml/ep2/axsep027nodechar.i "modBC"    ttICMS10.modBC    "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vBC"      ttICMS10.vBC      "YES" "2" "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pICMS"    ttICMS10.pICMS    "YES" "4" "NO "}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vICMS"    ttICMS10.vICMS    "YES" "2" "YES"}
                                                            {adapters/xml/ep2/axsep027nodechar.i "modBCST"  ttICMS10.modBCST  "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pMVAST"   ttICMS10.pMVAST   "NO"  "4" "NO "}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pRedBCST" ttICMS10.pRedBCST "NO"  "4" "NO "}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vBCST"    ttICMS10.vBCST    "YES" "2" "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pICMSST"  ttICMS10.pICMSST  "YES" "4" "NO "}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vICMSST"  ttICMS10.vICMSST  "YES" "2" "YES"}
                                                       delStack().

                                                  END.
                                                  FOR EACH ttICMS20
                                                     WHERE ttICMS20.CodEstabelNF = ttDet.CodEstabelNF
                                                       AND ttICMS20.SerieNF      = ttDet.SerieNF     
                                                       AND ttICMS20.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                       AND ttICMS20.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                       AND ttICMS20.ItCodigoNF   = ttDet.ItCodigoNF :

                                                       RUN addNode IN hGenXml (getStack(), "ICMS20", "", OUTPUT iId).
                                                       addStack(iId).
                                                            {adapters/xml/ep2/axsep027nodechar.i "orig"   ttICMS20.orig   "YES"}
                                                            {adapters/xml/ep2/axsep027nodechar.i "CST"    ttICMS20.CST    "YES"}
                                                            {adapters/xml/ep2/axsep027nodechar.i "modBC"  ttICMS20.modBC  "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pRedBC" ttICMS20.pRedBC "YES" "4" "NO "}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vBC"    ttICMS20.vBC    "YES" "2" "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pICMS"  ttICMS20.pICMS  "YES" "4" "NO "}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vICMS"  ttICMS20.vICMS  "YES" "2" "YES"}

                                                            IF  (ttICMS20.vICMSDeson <> ? AND ttICMS20.vICMSDeson  > 0 )
                                                            AND (ttICMS20.motDesICMS <> ? AND ttICMS20.motDesICMS <> "" AND ttICMS20.motDesICMS <> "0") THEN DO:
                                                                {adapters/xml/ep2/axsep027nodedec.i  "vICMSDeson"  ttICMS20.vICMSDeson  "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep027nodechar.i "motDesICMS"  ttICMS20.motDesICMS  "YES"}
                                                            END.
                                                       delStack().
                                                  END.
                                                  FOR EACH ttICMS30
                                                     WHERE ttICMS30.CodEstabelNF = ttDet.CodEstabelNF
                                                       AND ttICMS30.SerieNF      = ttDet.SerieNF     
                                                       AND ttICMS30.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                       AND ttICMS30.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                       AND ttICMS30.ItCodigoNF   = ttDet.ItCodigoNF :

                                                       RUN addNode IN hGenXml (getStack(), "ICMS30", "", OUTPUT iId).
                                                       addStack(iId).
                                                            {adapters/xml/ep2/axsep027nodechar.i "orig"     ttICMS30.orig     "YES"}
                                                            {adapters/xml/ep2/axsep027nodechar.i "CST"      ttICMS30.CST      "YES"}
                                                            {adapters/xml/ep2/axsep027nodechar.i "modBCST"  ttICMS30.modBCST  "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pMVAST"   ttICMS30.pMVAST   "NO"  "4" "NO "}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pRedBCST" ttICMS30.pRedBCST "NO"  "4" "NO "} 
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vBCST"    ttICMS30.vBCST    "YES" "2" "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pICMSST"  ttICMS30.pICMSST  "YES" "4" "NO "}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vICMSST"  ttICMS30.vICMSST  "YES" "2" "YES"}

                                                            IF  (ttICMS30.vICMSDeson <> ? AND ttICMS30.vICMSDeson  > 0 )
                                                            AND (ttICMS30.motDesICMS <> ? AND ttICMS30.motDesICMS <> "" AND ttICMS30.motDesICMS <> "0") THEN DO:
                                                                {adapters/xml/ep2/axsep027nodedec.i  "vICMSDeson"  ttICMS30.vICMSDeson  "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep027nodechar.i "motDesICMS"  ttICMS30.motDesICMS  "YES"}
                                                            END.
                                                       delStack().
                                                  END.
                                                  FOR EACH ttICMS40
                                                     WHERE ttICMS40.CodEstabelNF = ttDet.CodEstabelNF
                                                       AND ttICMS40.SerieNF      = ttDet.SerieNF     
                                                       AND ttICMS40.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                       AND ttICMS40.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                       AND ttICMS40.ItCodigoNF   = ttDet.ItCodigoNF :

                                                       RUN addNode IN hGenXml (getStack(), "ICMS40", "", OUTPUT iId).
                                                       addStack(iId).
                                                            {adapters/xml/ep2/axsep027nodechar.i "orig"        ttICMS40.orig        "YES"}
                                                            {adapters/xml/ep2/axsep027nodechar.i "CST"         ttICMS40.CST         "YES"}

                                                            IF  (ttICMS40.vICMSDeson <> ? AND ttICMS40.vICMSDeson  > 0 )
                                                            AND (ttICMS40.motDesICMS <> ? AND ttICMS40.motDesICMS <> "" AND ttICMS40.motDesICMS <> "0") THEN DO:
                                                                {adapters/xml/ep2/axsep027nodedec.i  "vICMSDeson"  ttICMS40.vICMSDeson  "NO"  "2" "YES"}
                                                                {adapters/xml/ep2/axsep027nodechar.i "motDesICMS"  ttICMS40.motDesICMS  "NO" }
                                                            END.
                                                       delStack().
                                                  END.
                                                  FOR EACH ttICMS51
                                                     WHERE ttICMS51.CodEstabelNF = ttDet.CodEstabelNF
                                                       AND ttICMS51.SerieNF      = ttDet.SerieNF     
                                                       AND ttICMS51.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                       AND ttICMS51.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                       AND ttICMS51.ItCodigoNF   = ttDet.ItCodigoNF :

                                                       RUN addNode IN hGenXml (getStack(), "ICMS51", "", OUTPUT iId).
                                                       addStack(iId).
                                                            {adapters/xml/ep2/axsep027nodechar.i "orig"     ttICMS51.orig     "YES"}
                                                            {adapters/xml/ep2/axsep027nodechar.i "CST"      ttICMS51.CST      "YES"}
                                                            {adapters/xml/ep2/axsep027nodechar.i "modBC"    ttICMS51.modBC    "NO" }
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pRedBC"   ttICMS51.pRedBC   "NO"  "4" "NO "}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vBC"      ttICMS51.vBC      "NO"  "2" "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pICMS"    ttICMS51.pICMS    "NO"  "4" "NO "}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vICMSOp"  ttICMS51.vICMSOp  "NO"  "2" "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pDif"     ttICMS51.pDif     "NO"  "4" "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vICMSDif" ttICMS51.vICMSDif "NO"  "2" "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vICMS"    ttICMS51.vICMS    "NO"  "2" "YES"}
                                                       delStack().
                                                  END.
                                                  FOR EACH ttICMS60
                                                     WHERE ttICMS60.CodEstabelNF = ttDet.CodEstabelNF
                                                       AND ttICMS60.SerieNF      = ttDet.SerieNF     
                                                       AND ttICMS60.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                       AND ttICMS60.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                       AND ttICMS60.ItCodigoNF   = ttDet.ItCodigoNF :

                                                       RUN addNode IN hGenXml (getStack(), "ICMS60", "", OUTPUT iId).
                                                       addStack(iId).
                                                            {adapters/xml/ep2/axsep027nodechar.i "orig"       ttICMS60.orig       "YES"}
                                                            {adapters/xml/ep2/axsep027nodechar.i "CST"        ttICMS60.CST        "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vBCSTRet"   ttICMS60.vBCSTRet   "YES" "2" "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vICMSSTRet" ttICMS60.vICMSSTRet "YES" "2" "YES"}
                                                       delStack().
                                                  END.
                                                  FOR EACH ttICMS70
                                                     WHERE ttICMS70.CodEstabelNF = ttDet.CodEstabelNF
                                                       AND ttICMS70.SerieNF      = ttDet.SerieNF
                                                       AND ttICMS70.NrNotaFisNF  = ttDet.NrNotaFisNF
                                                       AND ttICMS70.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                       AND ttICMS70.ItCodigoNF   = ttDet.ItCodigoNF :

                                                       RUN addNode IN hGenXml (getStack(), "ICMS70", "", OUTPUT iId).
                                                       addStack(iId).
                                                            {adapters/xml/ep2/axsep027nodechar.i "orig"     ttICMS70.orig     "YES"}
                                                            {adapters/xml/ep2/axsep027nodechar.i "CST"      ttICMS70.CST      "YES"}
                                                            {adapters/xml/ep2/axsep027nodechar.i "modBC"    ttICMS70.modBC    "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pRedBC"   ttICMS70.pRedBC   "YES" "4" "NO "}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vBC"      ttICMS70.vBC      "YES" "2" "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pICMS"    ttICMS70.pICMS    "YES" "4" "NO "}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vICMS"    ttICMS70.vICMS    "YES" "2" "YES"}
                                                            {adapters/xml/ep2/axsep027nodechar.i "modBCST"  ttICMS70.modBCST  "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pMVAST"   ttICMS70.pMVAST   "NO"  "4" "NO "}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pRedBCST" ttICMS70.pRedBCST "NO"  "4" "NO "}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vBCST"    ttICMS70.vBCST    "YES" "2" "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pICMSST"  ttICMS70.pICMSST  "YES" "4" "NO "}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vICMSST"  ttICMS70.vICMSST  "YES" "2" "YES"}

                                                            IF  (ttICMS70.vICMSDeson <> ? AND ttICMS70.vICMSDeson  > 0 )
                                                            AND (ttICMS70.motDesICMS <> ? AND ttICMS70.motDesICMS <> "" AND ttICMS70.motDesICMS <> "0") THEN DO:
                                                                {adapters/xml/ep2/axsep027nodedec.i  "vICMSDeson"  ttICMS70.vICMSDeson  "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep027nodechar.i "motDesICMS"  ttICMS70.motDesICMS  "YES"}
                                                            END.
                                                       delStack().
                                                  END.
                                                  FOR EACH ttICMS90
                                                     WHERE ttICMS90.CodEstabelNF = ttDet.CodEstabelNF
                                                       AND ttICMS90.SerieNF      = ttDet.SerieNF
                                                       AND ttICMS90.NrNotaFisNF  = ttDet.NrNotaFisNF
                                                       AND ttICMS90.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                       AND ttICMS90.ItCodigoNF   = ttDet.ItCodigoNF :

                                                       RUN addNode IN hGenXml (getStack(), "ICMS90", "", OUTPUT iId).
                                                       addStack(iId).
                                                            {adapters/xml/ep2/axsep027nodechar.i "orig"     ttICMS90.orig     "YES"}
                                                            {adapters/xml/ep2/axsep027nodechar.i "CST"      ttICMS90.CST      "YES"}

                                                            IF ((ttICMS90.modBC  <> ? AND ttICMS90.modBC  <> "")
                                                            AND ((ttICMS90.vBC    <> ? AND ttICMS90.vBC    <> 0 )
                                                            OR   (ttICMS90.pICMS  <> ? AND ttICMS90.pICMS  <> 0 )
                                                            OR   (ttICMS90.vICMS  <> ? AND ttICMS90.vICMS  <> 0 )))
                                                            THEN DO:
                                                            
                                                                {adapters/xml/ep2/axsep027nodechar.i "modBC"    ttICMS90.modBC    "YES"}
                                                                {adapters/xml/ep2/axsep027nodedec.i  "vBC"      ttICMS90.vBC      "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep027nodedec.i  "pRedBC"   ttICMS90.pRedBC   "NO"  "4" "NO "}
                                                                {adapters/xml/ep2/axsep027nodedec.i  "pICMS"    ttICMS90.pICMS    "YES" "4" "NO "}
                                                                {adapters/xml/ep2/axsep027nodedec.i  "vICMS"    ttICMS90.vICMS    "YES" "2" "YES"}

                                                            END.

                                                            IF ((ttICMS90.modBCST  <> ? AND ttICMS90.modBCST  <> "")
                                                            AND ((ttICMS90.vBCST    <> ? AND ttICMS90.vBCST    <> 0 )
                                                            OR   (ttICMS90.pICMSST  <> ? AND ttICMS90.pICMSST  <> 0 )
                                                            OR   (ttICMS90.vICMSST  <> ? AND ttICMS90.vICMSST  <> 0 )))
                                                            THEN DO:
                                                            
                                                                {adapters/xml/ep2/axsep027nodechar.i "modBCST"  ttICMS90.modBCST  "YES"}
                                                                {adapters/xml/ep2/axsep027nodedec.i  "pMVAST"   ttICMS90.pMVAST   "NO"  "4" "NO "}
                                                                {adapters/xml/ep2/axsep027nodedec.i  "pRedBCST" ttICMS90.pRedBCST "NO"  "4" "NO "}
                                                                {adapters/xml/ep2/axsep027nodedec.i  "vBCST"    ttICMS90.vBCST    "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep027nodedec.i  "pICMSST"  ttICMS90.pICMSST  "YES" "4" "NO "}
                                                                {adapters/xml/ep2/axsep027nodedec.i  "vICMSST"  ttICMS90.vICMSST  "YES" "2" "YES"}

                                                            END.

                                                            IF  (ttICMS90.vICMSDeson <> ? AND ttICMS90.vICMSDeson  > 0 )
                                                            AND (ttICMS90.motDesICMS <> ? AND ttICMS90.motDesICMS <> "" AND ttICMS90.motDesICMS <> "0") THEN DO:
                                                                {adapters/xml/ep2/axsep027nodedec.i  "vICMSDeson"  ttICMS90.vICMSDeson  "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep027nodechar.i "motDesICMS"  ttICMS90.motDesICMS  "YES"}
                                                            END.
                                                       delStack().
                                                  END.
                                                  FOR EACH ttICMSPart
                                                     WHERE ttICMSPart.CodEstabelNF = ttDet.CodEstabelNF
                                                       AND ttICMSPart.SerieNF      = ttDet.SerieNF     
                                                       AND ttICMSPart.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                       AND ttICMSPart.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                       AND ttICMSPart.ItCodigoNF   = ttDet.ItCodigoNF :

                                                       RUN addNode IN hGenXml (getStack(), "ICMSPart", "", OUTPUT iId).
                                                       addStack(iId).
                                                            {adapters/xml/ep2/axsep027nodechar.i "orig"     ttICMSPart.orig     "YES"}
                                                            {adapters/xml/ep2/axsep027nodechar.i "CST"      ttICMSPart.CST      "YES"}
                                                            {adapters/xml/ep2/axsep027nodechar.i "modBC"    ttICMSPart.modBC    "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vBC"      ttICMSPart.vBC      "YES"  "2" "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pRedBC"   ttICMSPart.pRedBC   "NO"   "4" "NO "}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pICMS"    ttICMSPart.pICMS    "YES"  "4" "NO "}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vICMS"    ttICMSPart.vICMS    "YES"  "2" "YES"}
                                                            {adapters/xml/ep2/axsep027nodechar.i "modBCST"  ttICMSPart.modBCST  "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pMVAST"   ttICMSPart.pMVAST   "NO"   "4" "NO "}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pRedBCST" ttICMSPart.pRedBCST "NO"   "4" "NO "}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vBCST"    ttICMSPart.vBCST    "YES"  "2" "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pICMSST"  ttICMSPart.pICMSST  "YES"  "4" "NO "}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "vICMSST"  ttICMSPart.vICMSST  "YES"  "2" "YES"}
                                                            {adapters/xml/ep2/axsep027nodedec.i  "pBCOp"    ttICMSPart.pBCOp    "YES"  "4" "NO "}
                                                            {adapters/xml/ep2/axsep027nodechar.i "UFST"     ttICMSPart.UFST     "YES"}
                                                       delStack().
                                                  END.
                                                  FOR EACH ttICMSST
                                                      WHERE ttICMSST.CodEstabelNF = ttDet.CodEstabelNF
                                                        AND ttICMSST.SerieNF      = ttDet.SerieNF     
                                                        AND ttICMSST.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                        AND ttICMSST.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                        AND ttICMSST.ItCodigoNF   = ttDet.ItCodigoNF :

                                                        RUN addNode IN hGenXml (getStack(), "ICMSST", "", OUTPUT iId).
                                                        addStack(iId).
                                                             {adapters/xml/ep2/axsep027nodechar.i "orig"         ttICMSST.orig        "YES"}
                                                             {adapters/xml/ep2/axsep027nodechar.i "CST"          ttICMSST.CST         "YES"}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "vBCSTRet"     ttICMSST.vBCSTRet    "YES"  "2" "YES"}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "vICMSSTRet"   ttICMSST.vICMSSTRet  "YES"  "2" "YES"}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "vBCSTDest"    ttICMSST.vBCSTDest   "YES"  "2" "YES"}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "vICMSSTDest"  ttICMSST.vICMSSTDest "YES"  "2" "YES"}
                                                        delStack().
                                                  END.
                                                  FOR EACH ttICMSSN101
                                                      WHERE ttICMSSN101.CodEstabelNF = ttDet.CodEstabelNF
                                                        AND ttICMSSN101.SerieNF      = ttDet.SerieNF     
                                                        AND ttICMSSN101.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                        AND ttICMSSN101.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                        AND ttICMSSN101.ItCodigoNF   = ttDet.ItCodigoNF :
                                                        RUN addNode IN hGenXml (getStack(), "ICMSSN101", "", OUTPUT iId).
                                                        addStack(iId).
                                                             {adapters/xml/ep2/axsep027nodechar.i "orig"         ttICMSSN101.orig         "YES"}
                                                             {adapters/xml/ep2/axsep027nodechar.i "CSOSN"        ttICMSSN101.CSOSN        "YES"}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "pCredSN"      ttICMSSN101.pCredSN      "YES"  "4" "NO "}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "vCredICMSSN"  ttICMSSN101.vCredICMSSN  "YES"  "2" "YES"}
                                                        delStack().
                                                  END.
                                                  FOR EACH ttICMSSN102
                                                      WHERE ttICMSSN102.CodEstabelNF = ttDet.CodEstabelNF
                                                        AND ttICMSSN102.SerieNF      = ttDet.SerieNF     
                                                        AND ttICMSSN102.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                        AND ttICMSSN102.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                        AND ttICMSSN102.ItCodigoNF   = ttDet.ItCodigoNF :
                                                        RUN addNode IN hGenXml (getStack(), "ICMSSN102", "", OUTPUT iId).
                                                        addStack(iId).
                                                             {adapters/xml/ep2/axsep027nodechar.i "orig"         ttICMSSN102.orig        "YES"}
                                                             {adapters/xml/ep2/axsep027nodechar.i "CSOSN"        ttICMSSN102.CSOSN       "YES"}
                                                        delStack().
                                                  END.
                                                  FOR EACH ttICMSSN201
                                                      WHERE ttICMSSN201.CodEstabelNF = ttDet.CodEstabelNF
                                                        AND ttICMSSN201.SerieNF      = ttDet.SerieNF     
                                                        AND ttICMSSN201.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                        AND ttICMSSN201.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                        AND ttICMSSN201.ItCodigoNF   = ttDet.ItCodigoNF :
                                                        RUN addNode IN hGenXml (getStack(), "ICMSSN201", "", OUTPUT iId).
                                                        addStack(iId).
                                                             {adapters/xml/ep2/axsep027nodechar.i "orig"         ttICMSSN201.orig         "YES"}
                                                             {adapters/xml/ep2/axsep027nodechar.i "CSOSN"        ttICMSSN201.CSOSN        "YES"}
                                                             {adapters/xml/ep2/axsep027nodechar.i "modBCST"      ttICMSSN201.modBCST      "YES"}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "pMVAST"       ttICMSSN201.pMVAST       "NO"   "4" "NO "}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "pRedBCST"     ttICMSSN201.pRedBCST     "NO"   "4" "NO "}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "vBCST"        ttICMSSN201.vBCST        "YES"  "2" "YES"}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "pICMSST"      ttICMSSN201.pICMSST      "YES"  "4" "NO "}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "vICMSST"      ttICMSSN201.vICMSST      "YES"  "2" "YES"}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "pCredSN"      ttICMSSN201.pCredSN      "YES"  "4" "NO "}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "vCredICMSSN"  ttICMSSN201.vCredICMSSN  "YES"  "2" "YES"}                                                            
                                                        delStack().
                                                  END.
                                                  FOR EACH ttICMSSN202
                                                      WHERE ttICMSSN202.CodEstabelNF = ttDet.CodEstabelNF
                                                        AND ttICMSSN202.SerieNF      = ttDet.SerieNF     
                                                        AND ttICMSSN202.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                        AND ttICMSSN202.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                        AND ttICMSSN202.ItCodigoNF   = ttDet.ItCodigoNF :
                                                        RUN addNode IN hGenXml (getStack(), "ICMSSN202", "", OUTPUT iId).
                                                        addStack(iId).
                                                             {adapters/xml/ep2/axsep027nodechar.i "orig"         ttICMSSN202.orig         "YES"}
                                                             {adapters/xml/ep2/axsep027nodechar.i "CSOSN"        ttICMSSN202.CSOSN        "YES"}
                                                             {adapters/xml/ep2/axsep027nodechar.i "modBCST"      ttICMSSN202.modBCST      "YES"}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "pMVAST"       ttICMSSN202.pMVAST       "NO"   "4" "NO "}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "pRedBCST"     ttICMSSN202.pRedBCST     "NO"   "4" "NO "}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "vBCST"        ttICMSSN202.vBCST        "YES"  "2" "YES"}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "pICMSST"      ttICMSSN202.pICMSST      "YES"  "4" "NO "}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "vICMSST"      ttICMSSN202.vICMSST      "YES"  "2" "YES"}                                                           
                                                        delStack().
                                                  END.
                                                  FOR EACH ttICMSSN500
                                                      WHERE ttICMSSN500.CodEstabelNF = ttDet.CodEstabelNF
                                                        AND ttICMSSN500.SerieNF      = ttDet.SerieNF     
                                                        AND ttICMSSN500.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                        AND ttICMSSN500.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                        AND ttICMSSN500.ItCodigoNF   = ttDet.ItCodigoNF :
                                                        RUN addNode IN hGenXml (getStack(), "ICMSSN500", "", OUTPUT iId).
                                                        addStack(iId).
                                                             {adapters/xml/ep2/axsep027nodechar.i "orig"           ttICMSSN500.orig        "YES"}
                                                             {adapters/xml/ep2/axsep027nodechar.i "CSOSN"          ttICMSSN500.CSOSN       "YES"}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "vBCSTRet"       ttICMSSN500.vBCSTRet    "YES"   "2" "YES"}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "vICMSSTRet"     ttICMSSN500.vICMSSTRet  "YES"   "2" "YES"}
                                                        delStack().
                                                  END.
                                                  FOR EACH ttICMSSN900
                                                      WHERE ttICMSSN900.CodEstabelNF = ttDet.CodEstabelNF
                                                        AND ttICMSSN900.SerieNF      = ttDet.SerieNF     
                                                        AND ttICMSSN900.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                        AND ttICMSSN900.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                        AND ttICMSSN900.ItCodigoNF   = ttDet.ItCodigoNF :
                                                        RUN addNode IN hGenXml (getStack(), "ICMSSN900", "", OUTPUT iId).
                                                        addStack(iId).
                                                             {adapters/xml/ep2/axsep027nodechar.i "orig"         ttICMSSN900.orig         "YES"}
                                                             {adapters/xml/ep2/axsep027nodechar.i "CSOSN"        ttICMSSN900.CSOSN        "YES"}
                                                             {adapters/xml/ep2/axsep027nodechar.i "modBC"        ttICMSSN900.modBC        "YES"}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "vBC"          ttICMSSN900.vBC          "YES"  "2" "YES"}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "pRedBC"       ttICMSSN900.pRedBC       "NO"   "4" "NO "}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "pICMS"        ttICMSSN900.pICMS        "YES"  "4" "NO "}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "vICMS"        ttICMSSN900.vICMS        "YES"  "2" "YES"}
                                                             {adapters/xml/ep2/axsep027nodechar.i "modBCST"      ttICMSSN900.modBCST      "YES"}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "pMVAST"       ttICMSSN900.pMVAST       "NO"   "4" "NO "}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "pRedBCST"     ttICMSSN900.pRedBCST     "NO"   "4" "NO "}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "vBCST"        ttICMSSN900.vBCST        "YES"  "2" "YES"}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "pICMSST"      ttICMSSN900.pICMSST      "YES"  "4" "NO "}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "vICMSST"      ttICMSSN900.vICMSST      "YES"  "2" "YES"}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "pCredSN"      ttICMSSN900.pCredSN      "YES"  "4" "NO "}
                                                             {adapters/xml/ep2/axsep027nodedec.i  "vCredICMSSN"  ttICMSSN900.vCredICMSSN  "YES"  "2" "YES"}
                                                        delStack().
                                                  END.

                                             delStack().

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-IPI:

                                             FOR EACH ttIPI
                                                WHERE ttIPI.CodEstabelNF = ttDet.CodEstabelNF
                                                  AND ttIPI.SerieNF      = ttDet.SerieNF     
                                                  AND ttIPI.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                  AND ttIPI.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                  AND ttIPI.ItCodigoNF   = ttDet.ItCodigoNF 
                                                  AND ttIPI.l-ipi-trib  <> ?: /* quando l-ipi-trib = ? indica nota serviáo e n∆o deve imprimir IPI (v2.0) */
                                                 
                                                  RUN addNode IN hGenXml (getStack(), "IPI", "", OUTPUT iId).
                                                  addStack(iId).

                                                       {adapters/xml/ep2/axsep027nodechar.i "clEnq"    ttIPI.clEnq    "NO" }
                                                       {adapters/xml/ep2/axsep027nodechar.i "CNPJProd" ttIPI.CNPJProd "NO" }
                                                       {adapters/xml/ep2/axsep027nodechar.i "cSelo"    ttIPI.cSelo    "NO" }
                                                       {adapters/xml/ep2/axsep027nodechar.i "qSelo"    ttIPI.qSelo    "NO" }
                                                       {adapters/xml/ep2/axsep027nodechar.i "cEnq"     ttIPI.cEnq     "YES"}

                                                       IF  NOT ttIPI.l-ipi-trib THEN DO:

                                                           RUN addNode IN hGenXml (getStack(), "IPINT", "", OUTPUT iId).
                                                           addStack(iId).
    
                                                                {adapters/xml/ep2/axsep027nodechar.i "CST"   ttIPI.CSTIPINT "YES"}
                                                           delStack().
                                                       
                                                       END.
                                                       ELSE DO:
                                                       
                                                           RUN addNode IN hGenXml (getStack(), "IPITrib",  "",             OUTPUT iId).
                                                           addStack(iId).
    
                                                                {adapters/xml/ep2/axsep027nodechar.i "CST"   ttIPI.CSTIPITrib "YES"}
                                                                
                                                                IF  ttIPI.qUnid > 0 AND 
                                                                    ttIPI.vUnid > 0 THEN DO: /* IPI Unidade */
                                                                    {adapters/xml/ep2/axsep027nodedec.i  "qUnid" ttIPI.qUnid      "YES" "4" "YES"}
                                                                    {adapters/xml/ep2/axsep027nodedec.i  "vUnid" ttIPI.vUnid      "YES" "4" "YES"}
                                                                END.
                                                                ELSE DO: 
                                                                    {adapters/xml/ep2/axsep027nodedec.i  "vBC"   ttIPI.vBC        "YES" "2" "YES"}
                                                                    {adapters/xml/ep2/axsep027nodedec.i  "pIPI"  ttIPI.pIPI       "YES" "4" "NO "}
                                                                END.

                                                                {adapters/xml/ep2/axsep027nodedec.i  "vIPI"  ttIPI.vIPI       "YES" "2" "YES"}
                                                           delStack().

                                                       END.

                                                  delStack().

                                             END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-II:

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
                                                 
                                                  RUN addNode IN hGenXml (getStack(), "II", "", OUTPUT iId).
                                                  addStack(iId).

                                                       {adapters/xml/ep2/axsep027nodedec.i "vBC"      ttII.vBC      "YES" "2" "YES"}
                                                       {adapters/xml/ep2/axsep027nodedec.i "vDespAdu" ttII.vDespAdu "YES" "2" "YES"}
                                                       {adapters/xml/ep2/axsep027nodedec.i "vII"      ttII.vII      "YES" "2" "YES"}
                                                       {adapters/xml/ep2/axsep027nodedec.i "vIOF"     ttII.vIOF     "YES" "2" "YES"}
                                                  delStack().

                                             END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-PIS:

                                                  FOR EACH ttPISAliq
                                                     WHERE ttPISAliq.CodEstabelNF = ttDet.CodEstabelNF
                                                       AND ttPISAliq.SerieNF      = ttDet.SerieNF     
                                                       AND ttPISAliq.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                       AND ttPISAliq.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                       AND ttPISAliq.ItCodigoNF   = ttDet.ItCodigoNF :

                                                      RUN addNode IN hGenXml (getStack(), "PIS", "", OUTPUT iId).
                                                      addStack(iId).

                                                      
                                                           RUN addNode IN hGenXml (getStack(), "PISAliq", "", OUTPUT iId).
                                                           addStack(iId).
    
                                                                {adapters/xml/ep2/axsep027nodechar.i "CST"  ttPISAliq.CST  "YES"}
                                                                {adapters/xml/ep2/axsep027nodedec.i  "vBC"  ttPISAliq.vBC  "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep027nodedec.i  "pPIS" ttPISAliq.pPIS "YES" "4" "NO "}
                                                                {adapters/xml/ep2/axsep027nodedec.i  "vPIS" ttPISAliq.vPIS "YES" "2" "YES"}
                                                           delStack().

                                                       delStack().

                                                  END.

                                                  FOR EACH ttPISQtde
                                                     WHERE ttPISQtde.CodEstabelNF = ttDet.CodEstabelNF
                                                       AND ttPISQtde.SerieNF      = ttDet.SerieNF     
                                                       AND ttPISQtde.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                       AND ttPISQtde.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                       AND ttPISQtde.ItCodigoNF   = ttDet.ItCodigoNF :

                                                      RUN addNode IN hGenXml (getStack(), "PIS", "", OUTPUT iId).
                                                      addStack(iId).

                                                           RUN addNode IN hGenXml (getStack(), "PISQtde", "", OUTPUT iId).
                                                           addStack(iId).
    
                                                                {adapters/xml/ep2/axsep027nodechar.i "CST"       ttPISQtde.CST       "YES"}
                                                                {adapters/xml/ep2/axsep027nodedec.i  "qBCProd"   ttPISQtde.qBCProd   "YES" "4" "YES"}
                                                                {adapters/xml/ep2/axsep027nodedec.i  "vAliqProd" ttPISQtde.vAliqProd "YES" "4" "YES"}
                                                                {adapters/xml/ep2/axsep027nodedec.i  "vPIS"      ttPISQtde.vPIS      "YES" "2" "YES"}
                                                           delStack().
                                                      delStack().

                                                  END.

                                                  FOR EACH ttPISNT
                                                     WHERE ttPISNT.CodEstabelNF = ttDet.CodEstabelNF
                                                       AND ttPISNT.SerieNF      = ttDet.SerieNF     
                                                       AND ttPISNT.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                       AND ttPISNT.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                       AND ttPISNT.ItCodigoNF   = ttDet.ItCodigoNF :

                                                      RUN addNode IN hGenXml (getStack(), "PIS", "", OUTPUT iId).
                                                      addStack(iId).

                                                           RUN addNode IN hGenXml (getStack(), "PISNT", "", OUTPUT iId).
                                                           addStack(iId).
    
                                                                {adapters/xml/ep2/axsep027nodechar.i "CST" ttPISNT.CST "YES"}
                                                           delStack().
                                                      delStack().

                                                  END.
                                                  
                                                  FOR EACH ttPISOutr
                                                     WHERE ttPISOutr.CodEstabelNF = ttDet.CodEstabelNF
                                                       AND ttPISOutr.SerieNF      = ttDet.SerieNF     
                                                       AND ttPISOutr.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                       AND ttPISOutr.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                       AND ttPISOutr.ItCodigoNF   = ttDet.ItCodigoNF :

                                                      RUN addNode IN hGenXml (getStack(), "PIS", "", OUTPUT iId).
                                                      addStack(iId).
                                                       
                                                          RUN addNode IN hGenXml (getStack(), "PISOutr", "", OUTPUT iId).
                                                           addStack(iId).
    
                                                                {adapters/xml/ep2/axsep027nodechar.i "CST"       ttPISOutr.CST "YES"}
    
                                                                IF  ttPISOutr.vAliqProd <> 0
                                                                AND ttPISOutr.vAliqProd <> ? THEN DO:
                                                                    {adapters/xml/ep2/axsep027nodedec.i "qBCProd"   ttPISOutr.qBCProd   "YES" "4" "YES"}
                                                                    {adapters/xml/ep2/axsep027nodedec.i "vAliqProd" ttPISOutr.vAliqProd "YES" "4" "YES"}
                                                                END.
                                                                ELSE DO:
                                                                    {adapters/xml/ep2/axsep027nodedec.i "vBC"       ttPISOutr.vBC  "YES" "2" "YES"}
                                                                    {adapters/xml/ep2/axsep027nodedec.i "pPIS"      ttPISOutr.pPIS "YES" "4" "NO "}
                                                                END.
    
                                                                {adapters/xml/ep2/axsep027nodedec.i  "vPIS"      ttPISOutr.vPIS "YES" "2" "YES"}
                                                           delStack().
                                                      delStack().

                                                  END.
                                             

                                             FOR EACH ttPISST
                                                WHERE ttPISST.CodEstabelNF = ttDet.CodEstabelNF
                                                  AND ttPISST.SerieNF      = ttDet.SerieNF     
                                                  AND ttPISST.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                  AND ttPISST.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                  AND ttPISST.ItCodigoNF   = ttDet.ItCodigoNF :

                                                  RUN addNode IN hGenXml (getStack(), "PISST", "", OUTPUT iId).
                                                  addStack(iId).

                                                       IF  ttPISST.vAliqProd <> 0
                                                       AND ttPISST.vAliqProd <> ? THEN DO:

                                                           {adapters/xml/ep2/axsep027nodedec.i "qBCProd"   ttPISST.qBCProd   "YES" "4" "YES"}
                                                           {adapters/xml/ep2/axsep027nodedec.i "vAliqProd" ttPISST.vAliqProd "YES" "4" "YES"}
                                                       END.
                                                       ELSE DO:
                                                           {adapters/xml/ep2/axsep027nodedec.i "vBC"       ttPISST.vBC       "YES" "2" "YES"}
                                                           {adapters/xml/ep2/axsep027nodedec.i "pPIS"      ttPISST.pPIS      "YES" "4" "NO "}
                                                       END.

                                                       {adapters/xml/ep2/axsep027nodedec.i "vPIS"      ttPISST.vPIS      "YES" "2" "YES"}
                                                  delStack().

                                             END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-COFINS:

                                                  FOR EACH ttCOFINSAliq
                                                     WHERE ttCOFINSAliq.CodEstabelNF = ttDet.CodEstabelNF
                                                       AND ttCOFINSAliq.SerieNF      = ttDet.SerieNF     
                                                       AND ttCOFINSAliq.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                       AND ttCOFINSAliq.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                       AND ttCOFINSAliq.ItCodigoNF   = ttDet.ItCodigoNF:
                                                      
                                                      RUN addNode IN hGenXml (getStack(), "COFINS", "", OUTPUT iId).
                                                      addStack(iId).

                                                           RUN addNode IN hGenXml (getStack(), "COFINSAliq", "", OUTPUT iId).
                                                           addStack(iId).
    
                                                                {adapters/xml/ep2/axsep027nodechar.i "CST"     ttCOFINSAliq.CST     "YES"}
                                                                {adapters/xml/ep2/axsep027nodedec.i  "vBC"     ttCOFINSAliq.vBC     "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep027nodedec.i  "pCOFINS" ttCOFINSAliq.pCOFINS "YES" "4" "NO "}
                                                                {adapters/xml/ep2/axsep027nodedec.i  "vCOFINS" ttCOFINSAliq.vCOFINS "YES" "2" "YES"}
                                                           delStack().
                                                      delStack().

                                                  END.
                                                  
                                                  FOR EACH ttCOFINSQtde
                                                     WHERE ttCOFINSQtde.CodEstabelNF = ttDet.CodEstabelNF
                                                       AND ttCOFINSQtde.SerieNF      = ttDet.SerieNF     
                                                       AND ttCOFINSQtde.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                       AND ttCOFINSQtde.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                       AND ttCOFINSQtde.ItCodigoNF   = ttDet.ItCodigoNF:

                                                      RUN addNode IN hGenXml (getStack(), "COFINS", "", OUTPUT iId).
                                                      addStack(iId).

                                                           RUN addNode IN hGenXml (getStack(), "COFINSQtde", "", OUTPUT iId).
                                                           addStack(iId).
    
                                                                {adapters/xml/ep2/axsep027nodechar.i "CST"       ttCOFINSQtde.CST       "YES"}
                                                                {adapters/xml/ep2/axsep027nodedec.i  "qBCProd"   ttCOFINSQtde.qBCProd   "YES" "4" "YES"}
                                                                {adapters/xml/ep2/axsep027nodedec.i  "vAliqProd" ttCOFINSQtde.vAliqProd "YES" "4" "YES"}
                                                                {adapters/xml/ep2/axsep027nodedec.i  "vCOFINS"   ttCOFINSQtde.vCOFINS   "YES" "2" "YES"}
                                                           delStack().
                                                      delStack().

                                                  END.
                                                  
                                                  FOR EACH ttCOFINSNT
                                                     WHERE ttCOFINSNT.CodEstabelNF = ttDet.CodEstabelNF
                                                       AND ttCOFINSNT.SerieNF      = ttDet.SerieNF     
                                                       AND ttCOFINSNT.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                       AND ttCOFINSNT.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                       AND ttCOFINSNT.ItCodigoNF   = ttDet.ItCodigoNF:

                                                      RUN addNode IN hGenXml (getStack(), "COFINS", "", OUTPUT iId).
                                                      addStack(iId).

                                                           RUN addNode IN hGenXml (getStack(), "COFINSNT", "", OUTPUT iId).
                                                           addStack(iId).
    
                                                                {adapters/xml/ep2/axsep027nodechar.i "CST" ttCOFINSNT.CST "YES"}
                                                           delStack().
                                                      delStack().

                                                  END.

                                                  FOR EACH ttCOFINSOutr
                                                     WHERE ttCOFINSOutr.CodEstabelNF = ttDet.CodEstabelNF
                                                       AND ttCOFINSOutr.SerieNF      = ttDet.SerieNF     
                                                       AND ttCOFINSOutr.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                       AND ttCOFINSOutr.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                       AND ttCOFINSOutr.ItCodigoNF   = ttDet.ItCodigoNF:

                                                      RUN addNode IN hGenXml (getStack(), "COFINS", "", OUTPUT iId).
                                                      addStack(iId).

                                                           RUN addNode IN hGenXml (getStack(), "COFINSOutr", "", OUTPUT iId).
                                                           addStack(iId).
    
                                                                {adapters/xml/ep2/axsep027nodechar.i "CST"       ttCOFINSOutr.CST "YES"}
    
                                                                IF  ttCOFINSOutr.vAliqProd <> 0
                                                                AND ttCOFINSOutr.vAliqProd <> ? THEN DO:
                                                                    {adapters/xml/ep2/axsep027nodedec.i "qBCProd"   ttCOFINSOutr.qBCProd   "YES" "4" "YES"}
                                                                    {adapters/xml/ep2/axsep027nodedec.i "vAliqProd" ttCOFINSOutr.vAliqProd "YES" "4" "YES"}
                                                                END.
                                                                ELSE DO:
                                                                    {adapters/xml/ep2/axsep027nodedec.i "vBC"       ttCOFINSOutr.vBC     "YES" "2" "YES"}
                                                                    {adapters/xml/ep2/axsep027nodedec.i "pCOFINS"   ttCOFINSOutr.pCOFINS "YES" "4" "NO "}
                                                                END.
                                                                
                                                                {adapters/xml/ep2/axsep027nodedec.i  "vCOFINS"   ttCOFINSOutr.vCOFINS "YES" "2" "YES"}
                                                           delStack().
                                                      delStack().
                                                  END.
                                             

                                             FOR EACH ttCOFINSST
                                                WHERE ttCOFINSST.CodEstabelNF = ttDet.CodEstabelNF
                                                  AND ttCOFINSST.SerieNF      = ttDet.SerieNF     
                                                  AND ttCOFINSST.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                  AND ttCOFINSST.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                  AND ttCOFINSST.ItCodigoNF   = ttDet.ItCodigoNF:

                                                  RUN addNode IN hGenXml (getStack(), "COFINSST", "", OUTPUT iId).
                                                  addStack(iId).

                                                       IF  ttCOFINSST.vAliqProd <> 0
                                                       AND ttCOFINSST.vAliqProd <> ? THEN DO:
                                                           {adapters/xml/ep2/axsep027nodedec.i "qBCProd"   ttCOFINSST.qBCProd   "YES" "4" "YES"}
                                                           {adapters/xml/ep2/axsep027nodedec.i "vAliqProd" ttCOFINSST.vAliqProd "YES" "4" "YES"}
                                                       END.
                                                       ELSE DO:
                                                           {adapters/xml/ep2/axsep027nodedec.i "vBC"       ttCOFINSST.vBC       "YES" "2" "YES"}
                                                           {adapters/xml/ep2/axsep027nodedec.i "pCOFINS"   ttCOFINSST.pCOFINS   "YES" "4" "NO "}
                                                       END.

                                                       {adapters/xml/ep2/axsep027nodedec.i "vCOFINS"   ttCOFINSST.vCOFINS   "YES" "2" "YES"}
                                                  delStack().
                                             END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-ICMSUFDest:

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

                                                  RUN addNode IN hGenXml (getStack(), "ICMSUFDest", "", OUTPUT iId).
                                                  addStack(iId).

                                                       {adapters/xml/ep2/axsep027nodedec.i "vBCUFDest"      ttICMSUFDest.vBCUFDest      "YES" "2" "YES"}
                                                       {adapters/xml/ep2/axsep027nodedec.i "pFCPUFDest"     ttICMSUFDest.pFCPUFDest     "YES" "4" "YES"}
                                                       {adapters/xml/ep2/axsep027nodedec.i "pICMSUFDest"    ttICMSUFDest.pICMSUFDest    "YES" "4" "YES"}
                                                       {adapters/xml/ep2/axsep027nodedec.i "pICMSInter"     ttICMSUFDest.pICMSInter     "YES" "4" "NO" }
                                                       {adapters/xml/ep2/axsep027nodedec.i "pICMSInterPart" ttICMSUFDest.pICMSInterPart "YES" "4" "YES"}
                                                       {adapters/xml/ep2/axsep027nodedec.i "vFCPUFDest"     ttICMSUFDest.vFCPUFDest     "YES" "2" "YES"}
                                                       {adapters/xml/ep2/axsep027nodedec.i "vICMSUFDest"    ttICMSUFDest.vICMSUFDest    "YES" "2" "YES"}
                                                       {adapters/xml/ep2/axsep027nodedec.i "vICMSUFRemet"   ttICMSUFDest.vICMSUFRemet   "YES" "2" "YES"}

                                                  delStack().
                                             END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-ImpostoDevol:

                                             FOR EACH ttImpostoDevol
                                                WHERE ttImpostoDevol.CodEstabelNF = ttDet.CodEstabelNF
                                                  AND ttImpostoDevol.SerieNF      = ttDet.SerieNF     
                                                  AND ttImpostoDevol.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                  AND ttImpostoDevol.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                  AND ttImpostoDevol.ItCodigoNF   = ttDet.ItCodigoNF
                                                  AND (ttImpostoDevol.pDevol    <> ?
                                                  AND  ttImpostoDevol.vIPIDevol <> ?):
                                            
                                                  RUN addNode IN hGenXml (getStack(), "impostoDevol", "", OUTPUT iId).
                                                  addStack(iId).
                                            
                                                       {adapters/xml/ep2/axsep027nodedec.i "pDevol"   ttImpostoDevol.pDevol   "YES" "2" "YES"}

                                                       RUN addNode IN hGenXml (getStack(), "IPI", "", OUTPUT iId).
                                                       addStack(iId).

                                                           {adapters/xml/ep2/axsep027nodedec.i "vIPIDevol" ttImpostoDevol.vIPIDevol "YES" "2" "YES"}

                                                       delStack().
                                                       
                                                  delStack().
                                             END.


    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-ISSQN:

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
                                                 
                                                  RUN addNode IN hGenXml (getStack(), "ISSQN", "", OUTPUT iId).
                                                  addStack(iId).

                                                       {adapters/xml/ep2/axsep027nodedec.i  "vBC"          ttISSQN.vBC          "YES" "2" "YES"}
                                                       {adapters/xml/ep2/axsep027nodedec.i  "vAliq"        ttISSQN.vAliq        "YES" "4" "NO "}
                                                       {adapters/xml/ep2/axsep027nodedec.i  "vISSQN"       ttISSQN.vISSQN       "YES" "2" "YES"}
                                                       {adapters/xml/ep2/axsep027nodechar.i "cMunFG"       ttISSQN.cMunFG       "YES"}
                                                       {adapters/xml/ep2/axsep027nodechar.i "cListServ"    ttISSQN.cListServ    "YES"}
                                                       {adapters/xml/ep2/axsep027nodedec.i  "vDeducao"     ttISSQN.vDeducao     "NO"  "2" "YES"}
                                                       {adapters/xml/ep2/axsep027nodedec.i  "vOutro"       ttISSQN.vOutro       "NO"  "2" "YES"}
                                                       {adapters/xml/ep2/axsep027nodedec.i  "vDescIncond"  ttISSQN.vDescIncond  "NO"  "2" "YES"}
                                                       {adapters/xml/ep2/axsep027nodedec.i  "vDescCond"    ttISSQN.vDescCond    "NO"  "2" "YES"}
                                                       {adapters/xml/ep2/axsep027nodedec.i  "vISSRet"      ttISSQN.vISSRet      "NO"  "2" "YES"}
                                                       {adapters/xml/ep2/axsep027nodechar.i "indISS"       ttISSQN.indISS       "YES"}
                                                       {adapters/xml/ep2/axsep027nodechar.i "cServico"     ttISSQN.cServico     "NO" }
                                                       {adapters/xml/ep2/axsep027nodechar.i "cMun"         ttISSQN.cMun         "NO" }
                                                       {adapters/xml/ep2/axsep027nodechar.i "cPais"        ttISSQN.cPais        "NO" }
                                                       {adapters/xml/ep2/axsep027nodechar.i "nProcesso"    ttISSQN.nProcesso    "NO" }
                                                       {adapters/xml/ep2/axsep027nodechar.i "indIncentivo" ttISSQN.indIncentivo "YES"}

                                                  delStack().

                                             END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-Total:

                              RUN addNode IN hGenXml (getStack(), "total", "", OUTPUT iId).
                              addStack(iId).

                                   FOR EACH ttICMSTot
                                      WHERE ttICMSTot.CodEstabelNF = ttNFe.CodEstabelNF
                                        AND ttICMSTot.SerieNF      = ttNFe.SerieNF     
                                        AND ttICMSTot.NrNotaFisNF  = ttNFe.NrNotaFisNF :
                                       
                                        RUN addNode IN hGenXml (getStack(), "ICMSTot", "", OUTPUT iId).
                                        addStack(iId).

                                             {adapters/xml/ep2/axsep027nodedec.i "vBC"          ttICMSTot.vBC          "YES" "2" "YES"}
                                             {adapters/xml/ep2/axsep027nodedec.i "vICMS"        ttICMSTot.vICMS        "YES" "2" "YES"}
                                             {adapters/xml/ep2/axsep027nodedec.i "vICMSDeson"   ttICMSTot.vICMSDeson   "YES" "2" "YES"}
                                             {adapters/xml/ep2/axsep027nodedec.i "vFCPUFDest"   ttICMSTot.vFCPUFDest   "NO"  "2" "YES"} /*NT2015.003*/
                                             {adapters/xml/ep2/axsep027nodedec.i "vICMSUFDest"  ttICMSTot.vICMSUFDest  "NO"  "2" "YES"} /*NT2015.003*/
                                             {adapters/xml/ep2/axsep027nodedec.i "vICMSUFRemet" ttICMSTot.vICMSUFRemet "NO"  "2" "YES"} /*NT2015.003*/
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
                                        delStack().

                                   END.
                                   FOR EACH ttISSQNtot
                                      WHERE ttISSQNtot.CodEstabelNF = ttNFe.CodEstabelNF
                                        AND ttISSQNtot.SerieNF      = ttNFe.SerieNF     
                                        AND ttISSQNtot.NrNotaFisNF  = ttNFe.NrNotaFisNF :
                                       
                                        RUN addNode IN hGenXml (getStack(), "ISSQNtot", "", OUTPUT iId).
                                        addStack(iId).

                                             {adapters/xml/ep2/axsep027nodedec.i  "vServ"       ttISSQNtot.vServ       "NO"  "2" "YES"} 
                                             {adapters/xml/ep2/axsep027nodedec.i  "vBC"         ttISSQNtot.vBC         "NO"  "2" "YES"}  
                                             {adapters/xml/ep2/axsep027nodedec.i  "vISS"        ttISSQNtot.vISS        "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep027nodedec.i  "vPIS"        ttISSQNtot.vPIS        "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep027nodedec.i  "vCOFINS"     ttISSQNtot.vCOFINS     "NO"  "2" "YES"} 
                                             {adapters/xml/ep2/axsep027nodedate.i "dCompet"     ttISSQNTot.dCompet     "YES"}
                                             {adapters/xml/ep2/axsep027nodedec.i  "vDeducao"    ttISSQNtot.vDeducao    "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep027nodedec.i  "vOutro"      ttISSQNtot.vOutro      "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep027nodedec.i  "vDescIncond" ttISSQNtot.vDescIncond "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep027nodedec.i  "vDescCond"   ttISSQNtot.vDescCond   "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep027nodedec.i  "vISSRet"     ttISSQNtot.vISSRet     "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep027nodechar.i "cRegTrib"    ttISSQNtot.cRegTrib "NO"}
                                        
                                        delStack().

                                   END.
                                   FOR EACH ttRetTrib
                                      WHERE ttRetTrib.CodEstabelNF = ttNFe.CodEstabelNF 
                                        AND ttRetTrib.SerieNF      = ttNFe.SerieNF      
                                        AND ttRetTrib.NrNotaFisNF  = ttNFe.NrNotaFisNF :
                                       
                                        RUN addNode IN hGenXml (getStack(), "retTrib", "", OUTPUT iId).
                                        addStack(iId).

                                             {adapters/xml/ep2/axsep027nodedec.i "vRetPIS"     ttRetTrib.vRetPIS     "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep027nodedec.i "vRetCOFINS"  ttRetTrib.vRetCOFINS  "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep027nodedec.i "vRetCSLL"    ttRetTrib.vRetCSLL    "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep027nodedec.i "vBCIRRF"     ttRetTrib.vBCIRRF     "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep027nodedec.i "vIRRF"       ttRetTrib.vIRRF       "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep027nodedec.i "vBCRetPrev"  ttRetTrib.vBCRetPrev  "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep027nodedec.i "vRetPrev"    ttRetTrib.vRetPrev    "NO"  "2" "YES"}
                                        delStack().

                                   END.
                              delStack().

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-Transp:

                              FOR EACH ttTransp
                                 WHERE ttTransp.CodEstabelNF = ttNFe.CodEstabelNF 
                                   AND ttTransp.SerieNF      = ttNFe.SerieNF      
                                   AND ttTransp.NrNotaFisNF  = ttNFe.NrNotaFisNF :
                                  
                                   RUN addNode IN hGenXml (getStack(), "transp", "", OUTPUT iId).
                                   addStack(iId).

                                        {adapters/xml/ep2/axsep027nodechar.i "modFrete" ttTransp.modFrete "YES"}
                                        IF TRIM(ttTransp.xNome)  <> "" OR
                                           TRIM(ttTransp.CNPJ)   <> "" OR   
                                           TRIM(ttTransp.CPF)    <> "" OR
                                           TRIM(ttTransp.IE)     <> "" OR
                                           TRIM(ttTransp.xEnder) <> "" OR
                                           TRIM(ttTransp.xMun)   <> "" OR
                                           TRIM(ttTransp.UF)     <> "" THEN DO: 

                                            RUN addNode IN hGenXml (getStack(), "transporta", "",                OUTPUT iId).
                                            addStack(iId).
                                        

                                            IF  ttTransp.i-natureza = 1 THEN DO: /*Pessoa F°sica*/
                                                {adapters/xml/ep2/axsep027nodechar.i "CPF"    ttTransp.CPF    "NO" }
                                            END.
                                            ELSE DO: /*Pessoa Jur°dica*/
                                                {adapters/xml/ep2/axsep027nodechar.i "CNPJ"   ttTransp.CNPJ   "NO" }
                                            END.
                                             
                                            {adapters/xml/ep2/axsep027nodechar.i "xNome"  ttTransp.xNome  "NO" }
                                            {adapters/xml/ep2/axsep027nodechar.i "IE"     ttTransp.IE     "NO" }
                                            {adapters/xml/ep2/axsep027nodechar.i "xEnder" ttTransp.xEnder "NO" }
                                            {adapters/xml/ep2/axsep027nodechar.i "xMun"   ttTransp.xMun   "NO" }
                                            {adapters/xml/ep2/axsep027nodechar.i "UF"     ttTransp.UF     "NO" }
                                            delStack().
                                        END.


                                        IF  (/* ttTransp.vServ    <> 0  AND */ ttTransp.vServ    <> ?)
                                        AND (/* ttTransp.vBCRet   <> 0  AND */ ttTransp.vBCRet   <> ?)
                                        AND (/* ttTransp.pICMSRet <> 0  AND */ ttTransp.pICMSRet <> ?)
                                        AND (/* ttTransp.vICMSRet <> 0  AND */ ttTransp.vICMSRet <> ?)
                                        AND (/* ttTransp.CFOP     <> "" AND */ ttTransp.CFOP     <> ?)
                                        AND (/* ttTransp.cMunFG   <> "" AND */ ttTransp.cMunFG   <> ?)
                                        THEN DO:
                                        
                                            RUN addNode IN hGenXml (getStack(), "retTransp", "", OUTPUT iId).
                                            addStack(iId).
    
                                                 {adapters/xml/ep2/axsep027nodedec.i  "vServ"    ttTransp.vServ    "YES" "2" "YES"}
                                                 {adapters/xml/ep2/axsep027nodedec.i  "vBCRet"   ttTransp.vBCRet   "YES" "2" "YES"}
                                                 {adapters/xml/ep2/axsep027nodedec.i  "pICMSRet" ttTransp.pICMSRet "YES" "4" "NO "}
                                                 {adapters/xml/ep2/axsep027nodedec.i  "vICMSRet" ttTransp.vICMSRet "YES" "2" "YES"}
                                                 {adapters/xml/ep2/axsep027nodechar.i "CFOP"     ttTransp.CFOP     "YES"}
                                                 {adapters/xml/ep2/axsep027nodechar.i "cMunFG"   ttTransp.cMunFG   "YES"}
                                            delStack().
                                        END.

                                        IF  (ttTransp.placa   <> "" AND ttTransp.placa   <> ?)
                                        AND (ttTransp.UFplaca <> "" AND ttTransp.UFplaca <> ?)
                                        THEN DO:
                                        
                                            RUN addNode IN hGenXml (getStack(), "veicTransp", "", OUTPUT iId).
                                            addStack(iId).
    
                                                 {adapters/xml/ep2/axsep027nodechar.i "placa" ttTransp.placa   "YES"}
                                                 {adapters/xml/ep2/axsep027nodechar.i "UF"    ttTransp.UFplaca "YES"}
                                                 {adapters/xml/ep2/axsep027nodechar.i "RNTC"  ttTransp.RNTC    "NO" }
                                            delStack().
                                        END.

                                        FOR EACH  ttReboque
                                           WHERE  ttReboque.CodEstabelNF = ttTransp.CodEstabelNF
                                             AND  ttReboque.SerieNF      = ttTransp.SerieNF     
                                             AND  ttReboque.NrNotaFisNF  = ttTransp.NrNotaFisNF
                                             AND (ttReboque.placa       <> "" AND ttReboque.placa       <> ?)
                                             AND (ttReboque.UF          <> "" AND ttReboque.UF          <> ?) :
                                            
                                             RUN addNode IN hGenXml (getStack(), "reboque", "", OUTPUT iId).
                                             addStack(iId).

                                                  {adapters/xml/ep2/axsep027nodechar.i "placa"  ttReboque.placa  "YES"}
                                                  {adapters/xml/ep2/axsep027nodechar.i "UF"     ttReboque.UF     "YES"}
                                                  {adapters/xml/ep2/axsep027nodechar.i "RNTC"   ttReboque.RNTC   "NO" }
                                                  
                                             delStack().

                                        END.

                                        /*Informaá‰es de Vag∆o e Balsa*/
                                        {adapters/xml/ep2/axsep027nodechar.i "vagao"  ttTransp.vagao  "NO" }
                                        {adapters/xml/ep2/axsep027nodechar.i "balsa"  ttTransp.balsa  "NO" }

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
                                            
                                             RUN addNode IN hGenXml (getStack(), "vol", "", OUTPUT iId).
                                             addStack(iId).

                                                  {adapters/xml/ep2/axsep027nodechar.i "qVol"  ttVol.qVol  "YES"} /*NT2012.003 - tag obrigatoria*/
                                                  {adapters/xml/ep2/axsep027nodechar.i "esp"   ttVol.esp   "NO" }
                                                  {adapters/xml/ep2/axsep027nodechar.i "marca" ttVol.marca "NO" }
                                                  {adapters/xml/ep2/axsep027nodechar.i "nVol"  ttVol.nVol  "NO" }
                                                  {adapters/xml/ep2/axsep027nodedec.i  "pesoL" ttVol.pesoL "NO"  "3" "YES"}
                                                  {adapters/xml/ep2/axsep027nodedec.i  "pesoB" ttVol.pesoB "NO"  "3" "YES"}

                                                  FOR EACH  ttLacres 
                                                     WHERE  ttLacres.CodEstabelNF = ttVol.CodEstabelNF
                                                       AND  ttLacres.SerieNF      = ttVol.SerieNF     
                                                       AND  ttLacres.NrNotaFisNF  = ttVol.NrNotaFisNF 
                                                       AND  ttLacres.nVol         = ttVol.nVol
                                                       AND (ttLacres.nLacre      <> "" AND ttLacres.nLacre <> ?):

                                                       RUN addNode IN hGenXml (getStack(), "lacres", "", OUTPUT iId).
                                                       addStack(iId).

                                                            {adapters/xml/ep2/axsep027nodechar.i "nLacre" ttLacres.nLacre "YES"}
                                                       delStack().

                                                  END.
                                             delStack().

                                        END.
                                   delStack().

                              END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-Cobr:

                              FOR FIRST ttCobr
                                  WHERE ttCobr.CodEstabelNF = ttNFe.CodEstabelNF
                                    AND ttCobr.SerieNF      = ttNFe.SerieNF     
                                    AND ttCobr.NrNotaFisNF  = ttNFe.NrNotaFisNF :
                                  
                                   RUN addNode IN hGenXml (getStack(), "cobr", "", OUTPUT iId).
                                   addStack(iId).

                                        IF  ttCobr.nFat <> "" AND ttCobr.nFat <> ? THEN DO:

                                            RUN addNode IN hGenXml (getStack(), "fat", "", OUTPUT iId).
                                            addStack(iId).
    
                                                 {adapters/xml/ep2/axsep027nodechar.i "nFat"  ttCobr.nFat  "NO" }
                                                 {adapters/xml/ep2/axsep027nodedec.i  "vOrig" ttCobr.vOrig "NO"  "2" "YES"}
                                                 {adapters/xml/ep2/axsep027nodedec.i  "vDesc" ttCobr.vDesc "NO"  "2" "YES"}
                                                 {adapters/xml/ep2/axsep027nodedec.i  "vLiq"  ttCobr.vLiq  "NO"  "2" "YES"}
                                            delStack().
                                        END.

                                        FOR EACH ttDup
                                           WHERE ttDup.CodEstabelNF = ttCobr.CodEstabelNF
                                             AND ttDup.SerieNF      = ttCobr.SerieNF
                                             AND ttDup.NrNotaFisNF  = ttCobr.NrNotaFisNF:
                                            
                                             RUN addNode IN hGenXml (getStack(), "dup", "", OUTPUT iId).
                                             addStack(iId).

                                                  {adapters/xml/ep2/axsep027nodechar.i "nDup"  ttDup.nDup  "NO" }
                                                  {adapters/xml/ep2/axsep027nodedate.i "dVenc" ttDup.dVenc "NO" }
                                                  {adapters/xml/ep2/axsep027nodedec.i  "vDup"  ttDup.vDup  "YES"  "2" "YES"} /*NT2012.003 - tag obrigatoria*/
                                             delStack().

                                        END.
                                   delStack().
                              END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-InfAdic:

                              FOR EACH ttInfAdic
                                 WHERE ttInfAdic.CodEstabelNF = ttNFe.CodEstabelNF
                                   AND ttInfAdic.SerieNF      = ttNFe.SerieNF     
                                   AND ttInfAdic.NrNotaFisNF  = ttNFe.NrNotaFisNF :
                                  
                                   RUN addNode IN hGenXml (getStack(), "infAdic", "", OUTPUT iId).
                                   addStack(iId).

                                        {adapters/xml/ep2/axsep027nodechar.i  "infAdFisco" ttInfAdic.infAdFisco "NO" }
                                        {adapters/xml/ep2/axsep027nodechar2.i "infCpl"     ttInfAdic.infCpl     "NO" }

                                        FOR EACH ttObsCont
                                           WHERE ttObsCont.CodEstabelNF = ttNFe.CodEstabelNF
                                             AND ttObsCont.SerieNF      = ttNFe.SerieNF     
                                             AND ttObsCont.NrNotaFisNF  = ttNFe.NrNotaFisNF
                                             AND (ttObsCont.xTexto      <> ?
                                             AND  ttObsCont.xTexto      <> ""):
                                            
                                             RUN addNode IN hGenXml (getStack(), "obsCont", "", OUTPUT iId).
                                             addStack(iId).

                                                  RUN setAttribute IN hGenXml (INPUT iId,  "xCampo", ttObsCont.xCampo).
                                                  {adapters/xml/ep2/axsep027nodechar2.i "xTexto" ttObsCont.xTexto "YES"}
                                             delStack().

                                        END.

                                        FOR EACH ttObsFisco
                                           WHERE ttObsFisco.CodEstabelNF = ttNFe.CodEstabelNF 
                                             AND ttObsFisco.SerieNF      = ttNFe.SerieNF      
                                             AND ttObsFisco.NrNotaFisNF  = ttNFe.NrNotaFisNF
                                             AND (ttObsFisco.xTexto     <> ?
                                             AND  ttObsFisco.xTexto     <> ""):
                                             
                                             RUN addNode IN hGenXml (getStack(), "obsFisco", "", OUTPUT iId).
                                             addStack(iId).

                                                  RUN setAttribute IN hGenXml (INPUT iId,  "xCampo", ttObsFisco.xCampo).
                                                  {adapters/xml/ep2/axsep027nodechar2.i "xTexto" ttObsFisco.xTexto "YES"}
                                             delStack().

                                        END.
                                        FOR EACH ttProcRef
                                           WHERE ttProcRef.CodEstabelNF = ttNFe.CodEstabelNF
                                             AND ttProcRef.SerieNF      = ttNFe.SerieNF     
                                             AND ttProcRef.NrNotaFisNF  = ttNFe.NrNotaFisNF
                                             AND (ttProcRef.nProc   <> ? AND ttProcRef.nProc   <> "")
                                             AND (ttProcRef.indProc <> ? AND ttProcRef.indProc <> "") :
                                            
                                             RUN addNode IN hGenXml (getStack(), "procRef", "", OUTPUT iId).
                                             addStack(iId).

                                                  {adapters/xml/ep2/axsep027nodechar.i "nProc"   ttProcRef.nProc   "YES"}
                                                  {adapters/xml/ep2/axsep027nodechar.i "indProc" ttProcRef.indProc "YES"}
                                             delStack().

                                        END.
                                   delStack().

                              END.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-Exporta:

                              FOR EACH  ttExporta
                                 WHERE  ttExporta.CodEstabelNF = ttNFe.CodEstabelNF
                                   AND  ttExporta.SerieNF      = ttNFe.SerieNF     
                                   AND  ttExporta.NrNotaFisNF  = ttNFe.NrNotaFisNF
                                   AND (ttExporta.UFSaidaPais <> ? AND ttExporta.UFSaidaPais <> "")
                                   AND (ttExporta.xLocExporta <> ? AND ttExporta.xLocExporta <> ""):
                                  
                                   RUN addNode IN hGenXml (getStack(), "exporta", "", OUTPUT iId).
                                   addStack(iId).

                                        {adapters/xml/ep2/axsep027nodechar.i "UFSaidaPais"  ttExporta.UFSaidaPais  "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "xLocExporta"  ttExporta.xLocExporta  "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "xLocDespacho" ttExporta.xLocDespacho "NO" }
                                   delStack().

                              END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-Compra:

                              FOR EACH  ttCompra
                                 WHERE  ttCompra.CodEstabelNF = ttNFe.CodEstabelNF
                                   AND  ttCompra.SerieNF      = ttNFe.SerieNF     
                                   AND  ttCompra.NrNotaFisNF  = ttNFe.NrNotaFisNF
                                   AND ((ttCompra.xNEmp <> ? /* AND ttCompra.xNEmp <> "" */)
                                   OR   (ttCompra.xPed  <> ? /* AND ttCompra.xPed  <> "" */)
                                   OR   (ttCompra.xCont <> ? /* AND ttCompra.xCont <> "" */)) :

                                   RUN addNode IN hGenXml (getStack(), "compra", "", OUTPUT iId).
                                   addStack(iId).

                                        {adapters/xml/ep2/axsep027nodechar.i "xNEmp" ttCompra.xNEmp "NO" }
                                        {adapters/xml/ep2/axsep027nodechar.i "xPed"  ttCompra.xPed  "NO" }
                                        {adapters/xml/ep2/axsep027nodechar.i "xCont" ttCompra.xCont "NO" }
                                   delStack().

                              END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-Cana:

                              FOR EACH ttCana
                                 WHERE ttCana.CodEstabelNF = ttNFe.CodEstabelNF 
                                   AND ttCana.SerieNF      = ttNFe.SerieNF      
                                   AND ttCana.NrNotaFisNF  = ttNFe.NrNotaFisNF :
                                  
                                   RUN addNode IN hGenXml (getStack(), "cana", "", OUTPUT iId).
                                   addStack(iId).
                              
                                        {adapters/xml/ep2/axsep027nodechar.i "safra"  ttCana.safra  "YES"}
                                        {adapters/xml/ep2/axsep027nodechar.i "ref"    ttCana.ref    "YES"}
                              
                                        FOR EACH ttForDia
                                           WHERE ttForDia.CodEstabelNF = ttCana.CodEstabelNF
                                             AND ttForDia.SerieNF      = ttCana.SerieNF     
                                             AND ttForDia.NrNotaFisNF  = ttCana.NrNotaFisNF:

                                            RUN addNode IN hGenXml (getStack(), "forDia", "",  OUTPUT iId).
                                            addStack(iId).
                              
                                                RUN setAttribute IN hGenXml (INPUT iId, "dia", ttForDia.dia).
                                                {adapters/xml/ep2/axsep027nodedec.i  "qtde"  ttForDia.qtde  "YES" "10" "YES"}
    
                                            delStack().
                              
                                        END.
                              
                                        {adapters/xml/ep2/axsep027nodedec.i  "qTotMes"  ttCana.qTotMes  "YES" "10" "YES"}
                                        {adapters/xml/ep2/axsep027nodedec.i  "qTotAnt"  ttCana.qTotAnt  "YES" "10" "YES"}
                                        {adapters/xml/ep2/axsep027nodedec.i  "qTotGer"  ttCana.qTotGer  "YES" "10" "YES"}
                                  
                                        FOR EACH ttDeduc
                                           WHERE ttDeduc.CodEstabelNF = ttCana.CodEstabelNF
                                             AND ttDeduc.SerieNF      = ttCana.SerieNF     
                                             AND ttDeduc.NrNotaFisNF  = ttCana.NrNotaFisNF:
                              
                                            RUN addNode IN hGenXml (getStack(), "deduc", "",  OUTPUT iId).
                                            addStack(iId).
                                            
                                                {adapters/xml/ep2/axsep027nodechar.i "xDed"  ttDeduc.xDed  "YES"}
                                                {adapters/xml/ep2/axsep027nodedec.i  "vDed"  ttDeduc.vDed  "YES" "2" "YES"}

                                            delStack().
                                  
                                        END.

                                        {adapters/xml/ep2/axsep027nodedec.i  "vFor"     ttCana.vFor     "YES" "2" "YES"}
                                        {adapters/xml/ep2/axsep027nodedec.i  "vTotDed"  ttCana.vTotDed  "YES" "2" "YES"}
                                        {adapters/xml/ep2/axsep027nodedec.i  "vLiqFor"  ttCana.vLiqFor  "YES" "2" "YES"}
                              
                                   delStack().
                              
                              END.

    RETURN "OK":U.
END PROCEDURE.


