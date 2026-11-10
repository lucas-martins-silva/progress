/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
USING Progress.Json.ObjectModel.*.


{include/i-prgvrs.i AXSEP037IMPRIMEXML 2.00.00.101 } /*** "010001" 30/10/2026 12:55:28 ***/

{include/i-epc200.i AXSEP037IMPRIMEXML}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i axsep037imprimexml MUT}
&ENDIF
 

/*-------------------------------------------------
             axsep037ImprimeXML.p
-------------------------------------------------*/

{adapters/xml/ep2/axsep037.i}                  /* Definiá‰es Tabelas Tempor†rias */
{adapters/xml/ep2/axsep037extradeclarations.i} /* Outras Declaraá‰es             */

{cdp/cdcfgdis.i}

DEFINE INPUT PARAM PhGenXml AS HANDLE NO-UNDO .
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttStack   .
DEFINE INPUT PARAM TABLE FOR ttAdi            .
DEFINE INPUT PARAM TABLE FOR ttArma           .
DEFINE INPUT PARAM TABLE FOR ttAutXML         .
DEFINE INPUT PARAM TABLE FOR ttAvulsa         .
DEFINE INPUT PARAM TABLE FOR ttCobr           .
DEFINE INPUT PARAM TABLE FOR ttCOFINSAliq     .
DEFINE INPUT PARAM TABLE FOR ttCOFINSNT       .
DEFINE INPUT PARAM TABLE FOR ttCOFINSOutr     .
DEFINE INPUT PARAM TABLE FOR ttCOFINSQtde     .
DEFINE INPUT PARAM TABLE FOR ttCOFINSST       .
DEFINE INPUT PARAM TABLE FOR ttICMSUFDest     .
DEFINE INPUT PARAM TABLE FOR ttComb           .
DEFINE INPUT PARAM TABLE FOR ttOrigComb       .
DEFINE INPUT PARAM TABLE FOR ttCompra         .
DEFINE INPUT PARAM TABLE FOR ttDest           .
DEFINE INPUT PARAM TABLE FOR ttDet            .
DEFINE INPUT PARAM TABLE FOR ttDetObsCont     .
DEFINE INPUT PARAM TABLE FOR ttDetObsFisco    .
DEFINE INPUT PARAM TABLE FOR ttDetExport      .
DEFINE INPUT PARAM TABLE FOR ttDI             .
DEFINE INPUT PARAM TABLE FOR ttDup            .
DEFINE INPUT PARAM TABLE FOR ttEmit           .
DEFINE INPUT PARAM TABLE FOR ttEntrega        .
DEFINE INPUT PARAM TABLE FOR ttExporta        .
DEFINE INPUT PARAM TABLE FOR ttICMS00         .
DEFINE INPUT PARAM TABLE FOR ttICMS02         .
DEFINE INPUT PARAM TABLE FOR ttICMS10         .
DEFINE INPUT PARAM TABLE FOR ttICMS15         .
DEFINE INPUT PARAM TABLE FOR ttICMS20         .
DEFINE INPUT PARAM TABLE FOR ttICMS30         .
DEFINE INPUT PARAM TABLE FOR ttICMS40         .
DEFINE INPUT PARAM TABLE FOR ttICMS51         .
DEFINE INPUT PARAM TABLE FOR ttICMS53         .
DEFINE INPUT PARAM TABLE FOR ttICMS60         .
DEFINE INPUT PARAM TABLE FOR ttICMS61         .
DEFINE INPUT PARAM TABLE FOR ttICMS70         .
DEFINE INPUT PARAM TABLE FOR ttICMS90         .
DEFINE INPUT PARAM TABLE FOR ttICMSTot        .
DEFINE INPUT PARAM TABLE FOR ttIde            .
DEFINE INPUT PARAM TABLE FOR ttII             .
DEFINE INPUT PARAM TABLE FOR ttImpostoDevol   .
DEFINE INPUT PARAM TABLE FOR ttInfAdic        .
DEFINE INPUT PARAM TABLE FOR ttIPI            .
DEFINE INPUT PARAM TABLE FOR ttISSQN          .
DEFINE INPUT PARAM TABLE FOR ttISSQNtot       .
DEFINE INPUT PARAM TABLE FOR ttLacres         .
DEFINE INPUT PARAM TABLE FOR ttMed            .
DEFINE INPUT PARAM TABLE FOR ttNFe            .
DEFINE INPUT PARAM TABLE FOR ttrefNF          .
DEFINE INPUT PARAM TABLE FOR ttObsCont        .
DEFINE INPUT PARAM TABLE FOR ttObsFisco       .
DEFINE INPUT PARAM TABLE FOR ttPISAliq        .
DEFINE INPUT PARAM TABLE FOR ttPISNT          .
DEFINE INPUT PARAM TABLE FOR ttPISOutr        .
DEFINE INPUT PARAM TABLE FOR ttPISQtde        .
DEFINE INPUT PARAM TABLE FOR ttPISST          .
DEFINE INPUT PARAM TABLE FOR ttProcRef        .
DEFINE INPUT PARAM TABLE FOR ttReboque        .
DEFINE INPUT PARAM TABLE FOR ttRetirada       .
DEFINE INPUT PARAM TABLE FOR ttRetTrib        .
DEFINE INPUT PARAM TABLE FOR ttTransp         .
DEFINE INPUT PARAM TABLE FOR ttVeic           .
DEFINE INPUT PARAM TABLE FOR ttVol            .
DEFINE INPUT PARAM TABLE FOR ttrefNFP         .
DEFINE INPUT PARAM TABLE FOR ttrefCTe         .
DEFINE INPUT PARAM TABLE FOR ttrefECF         .
DEFINE INPUT PARAM TABLE FOR ttICMSPart       .
DEFINE INPUT PARAM TABLE FOR ttICMSST         .
DEFINE INPUT PARAM TABLE FOR ttICMSSN101      .
DEFINE INPUT PARAM TABLE FOR ttICMSSN102      .
DEFINE INPUT PARAM TABLE FOR ttICMSSN201      .
DEFINE INPUT PARAM TABLE FOR ttICMSSN202      .
DEFINE INPUT PARAM TABLE FOR ttICMSSN500      .
DEFINE INPUT PARAM TABLE FOR ttICMSSN900      .
DEFINE INPUT PARAM TABLE FOR ttCana           .
DEFINE INPUT PARAM TABLE FOR ttForDia         .
DEFINE INPUT PARAM TABLE FOR ttDeduc          .
DEFINE INPUT PARAM TABLE FOR ttRastro         .
DEFINE INPUT PARAM TABLE FOR ttPag            .
DEFINE INPUT PARAM TABLE FOR ttInfIntermed    .
DEFINE INPUT PARAM TABLE FOR ttDetPag         .
DEFINE INPUT PARAM TABLE FOR ttDetPresumido   .
DEFINE INPUT PARAM TABLE FOR ttAgropecuario   .
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
DEFINE INPUT PARAM TABLE for ttgALCZFMCBS     .

/*-------------------------------------------------
            axsep037ImprimeXML.i
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
                           
         FOR FIRST estabelec
             WHERE estabelec.cod-estabel = ttNFe.CodEstabelNF NO-LOCK:
         END.                     
                           
         {ftp/ft0114.i1 ttNFe.CodEstabelNF ttNFe.SerieNF l-simplificadoTipo2}

         /* Funá∆o para gerar as tags do FCP diferido CT 51 com base no estado do estabelecimento */       
         ASSIGN l-FCP-Diferido = CAN-FIND(FIRST funcao NO-LOCK
                                    WHERE funcao.cd-funcao = ("spp-fcp-diferido-" + estabelec.estado)
                                    AND   funcao.ativo     = YES).             
         
         /* Funá∆o para gerar do hash do CSRT com base no estado do estabelecimento */       
         ASSIGN l-CSRT = CAN-FIND(FIRST funcao NO-LOCK
                                  WHERE funcao.cd-funcao = ("spp-csrt-" + estabelec.estado)
                                  AND   funcao.ativo     = YES).   
                                  
         //Contribuinte Exclusivo IBS/CTBS - CD0403                          
         ASSIGN l-contrib-exc-ibsctbs = CAN-FIND(FIRST param-nf-estab NO-LOCK
                                                 WHERE param-nf-estab.cod-estab = estabelec.cod-estabel
                                                 AND   SUBSTRING(param-nf-estab.cod-livre-4,388,1) = "S").                                   
         
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

                   ASSIGN iContItem      = 1
                          l-primeiroitem = YES.

                   FOR EACH ttDet
                      WHERE ttDet.CodEstabelNF = ttNFe.CodEstabelNF
                        AND ttDet.SerieNF      = ttNFe.SerieNF     
                        AND ttDet.NrNotaFisNF  = ttNFe.NrNotaFisNF :
						
						 ASSIGN l-gEstornoCred = can-find(first it-nota-fisc-trib where
														  it-nota-fisc-trib.cod-estabel   = ttDet.CodEstabelNF and
														  it-nota-fisc-trib.serie         = ttDet.SerieNF      and
														  it-nota-fisc-trib.nr-nota-fis   = ttDet.NrNotaFisNF  and
														  it-nota-fisc-trib.nr-seq-fat    = ttDet.NrSeqFatNF   and
														  it-nota-fisc-trib.it-codigo     = ttDet.ItCodigoNF   and 
														  it-nota-fisc-trib.estorno-cred  = YES no-lock) .    			
                        
                         RUN pi-grava-seq-item-xml.
                        
                         RUN addNode IN hGenXml (getStack(), "det", "", OUTPUT iId).
                         addStack(iId).
                
                              RUN setAttribute IN hGenXml (INPUT iId, "nItem", STRING(iContItem)).
                
                              RUN addNode IN hGenXml (getStack(), "prod", "", OUTPUT iId).
                              addStack(iId).
                                   
                                   /* Danfe Simplificado Tipo 2 */
                                   IF  l-primeiroitem = YES 
                                   AND ttIde.tpAmb = "2"           //Homologaá∆o
                                   AND ttIde.tpImp = "6" THEN DO:  //Tipo 2                                        
                                       ASSIGN ttDet.xProd = "NOTA FISCAL EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL".         
                                       ASSIGN l-primeiroitem = NO.     
                                   END. 
 
                                   RUN pi-imprime-Prod.
                
                                   RUN pi-imprime-DI-e-Adi.

                                   RUN pi-imprime-DetExport.

                                   {adapters/xml/ep2/axsep037nodechar.i  "xPed"     ttDet.xPed     "NO"      }
                                   {adapters/xml/ep2/axsep037nodechar.i  "nItemPed" ttDet.nItemPed "NO"      }
                                   {adapters/xml/ep2/axsep037nodechar.i  "nFCI"     ttDet.nFCI     "NO"      }

                                   RUN pi-imprime-Rastro.
                
                                   RUN pi-imprime-Veic.
                
                                   /* Finalidade Nota de DÇbito  */
                                   IF ttIde.finNFe = "6" THEN DO:
                                       FOR FIRST ttRastro
                                           WHERE  ttRastro.CodEstabelNF = ttDet.CodEstabelNF
                                             AND  ttRastro.SerieNF      = ttDet.SerieNF     
                                             AND  ttRastro.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                             AND  ttRastro.NrSeqFatNF   = ttDet.NrSeqFatNF
                                             AND  ttRastro.ItCodigoNF   = ttDet.ItCodigoNF 
                                             AND  ttRastro.nLote        <> ? 
                                             AND  ttRastro.nLote        <> ""
                                             AND  ttRastro.qLote        <> ?
                                             AND  ttRastro.dFab         <> ? 
                                             AND  ttRastro.dVal         <> ?:
                                             
                                          RUN pi-imprime-Med.
                                       END.
                                   END.
                                   ELSE 
                                      RUN pi-imprime-Med.
                
                                   RUN pi-imprime-Arma.
                
                                   RUN pi-imprime-Comb.

                                   {adapters/xml/ep2/axsep037nodechar.i  "nRECOPI"  ttDet.nRECOPI  "NO"     }
                
                              delStack().
                
                              RUN addNode IN hGenXml (getStack(), "imposto", "", OUTPUT iId).
                              addStack(iId).
                                   
                                   /*NT2013.003*/
                                   {adapters/xml/ep2/axsep037nodedec.i "vTotTrib" ttDet.vTotTrib "NO"  "2" "YES"} /*NT2013.003 - Valor aproximado total de tributos federais, estaduais e municipais - campo NAO obrigatorio*/
                                   
                                   
                                   IF ((ttIde.finNFe <> "5" AND ttIde.finNFe <> "6" AND c-tpOperGov <> "2") OR 
                                       (ttIde.finNFe = "5" AND (ttIde.tpNFCredito = "03" OR ttIde.tpNFCredito = "04" OR ttIde.tpNFCredito = "06") AND ttIde.tpNF = "0") OR
                                       (ttIde.finNFe = "6" AND (ttIde.tpNFDebito = "06" OR ttIde.tpNFDebito = "07"))) THEN DO: /* Validaá∆o referente rejeiá‰es 1001 e 1002 da NT 2025.002 */

                                       ASSIGN l-notaDebPagAntecip     = NO
                                              l-notaDebPagAntecip2026 = NO.

                                       //Trata-se de uma 'Nota de DÇbito' do tipo 'Pagamento Antecipado'?
                                       IF ttIde.finNFe = "6" AND ttIde.tpNFDebito = "06" THEN DO:

                                           ASSIGN l-notaDebPagAntecip = YES.
                                           
                                           //A 'Nota de DÇbito' do tipo 'Pagamento Antecipado' foi emitida no ano de 2026?
                                           IF SUBSTRING(ttIde.dhEmi,1,4) = "2026" THEN
                                               ASSIGN l-notaDebPagAntecip2026 = YES.
                                       END.

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

                                          // IF NOT l-notaDebPagAntecip THEN
                                               RUN pi-imprime-ISSQN.
                                       END.
                                       ELSE DO:

                                           IF NOT l-notaDebPagAntecip THEN
                                               RUN pi-imprime-ICMS.

                                           RUN pi-imprime-IPI.

                                           IF NOT l-notaDebPagAntecip THEN
                                               RUN pi-imprime-II.
                                       END.
                                     
                                       IF NOT l-notaDebPagAntecip
                                       OR l-notaDebPagAntecip2026 THEN DO:
                                           RUN pi-imprime-PIS.
                                           RUN pi-imprime-COFINS.
                                        END.

                                       IF NOT l-notaDebPagAntecip THEN
                                           RUN pi-imprime-ICMSUFDest.
                                   
                                   END.
                                    
                                   IF l-NT2024002 THEN DO:
                                        
                                      IF CAN-FIND (FIRST ttTribRT
                                                         WHERE ttTribRT.CodEstabelNF = ttDet.CodEstabelNF
                                                         AND   ttTribRT.SerieNF      = ttDet.SerieNF     
                                                         AND   ttTribRT.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                         AND   ttTribRT.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                         AND   ttTribRT.ItCodigoNF   = ttDet.ItCodigoNF
                                                         AND   ttTribRT.TipTributo   = 4
                                                         AND   ttTribRT.vTrib        > 0 ) THEN DO:
                                                     
                                                     RUN pi-imprime-is.  // Imposto Seletivo
                                      END.
                                      IF CAN-FIND (FIRST ttTribRT
                                                   WHERE ttTribRT.CodEstabelNF = ttDet.CodEstabelNF
                                                     AND ttTribRT.SerieNF      = ttDet.SerieNF     
                                                     AND ttTribRT.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                     AND ttTribRT.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                     AND ttTribRT.ItCodigoNF   = ttDet.ItCodigoNF
                                                     AND ttTribRT.TipTributo   < 4) OR 
                                         CAN-FIND (FIRST ttgIBSCBSMono 
                                                   WHERE ttgIBSCBSMono.CodEstabelNF = ttDet.CodEstabelNF
                                                     AND ttgIBSCBSMono.SerieNF      = ttDet.SerieNF
                                                     AND ttgIBSCBSMono.NrNotaFisNF  = ttDet.NrNotaFisNF
                                                     AND ttgIBSCBSMono.ItCodigoNF   = ttDet.ItCodigoNF
                                                     AND ttgIBSCBSMono.NrSeqFatNF   = ttDet.NrSeqFatNF) OR
                                         CAN-FIND (FIRST ttgTransfCred 
                                                   WHERE ttgTransfCred.CodEstabelNF = ttDet.CodEstabelNF
                                                     AND ttgTransfCred.SerieNF      = ttDet.SerieNF
                                                     AND ttgTransfCred.NrNotaFisNF  = ttDet.NrNotaFisNF
                                                     AND ttgTransfCred.ItCodigoNF   = ttDet.ItCodigoNF
                                                     AND ttgTransfCred.NrSeqFatNF   = ttDet.NrSeqFatNF) OR 
                                         CAN-FIND (FIRST ttgAjusteCompet 
                                                   WHERE ttgAjusteCompet.CodEstabelNF = ttDet.CodEstabelNF
                                                     AND ttgAjusteCompet.SerieNF      = ttDet.SerieNF
                                                     AND ttgAjusteCompet.NrNotaFisNF  = ttDet.NrNotaFisNF
                                                     AND ttgAjusteCompet.ItCodigoNF   = ttDet.ItCodigoNF
                                                     AND ttgAjusteCompet.NrSeqFatNF   = ttDet.NrSeqFatNF) OR 
                                         CAN-FIND (FIRST ttgEstornoCred 
                                                   WHERE ttgEstornoCred.CodEstabelNF = ttDet.CodEstabelNF
                                                     AND ttgEstornoCred.SerieNF      = ttDet.SerieNF
                                                     AND ttgEstornoCred.NrNotaFisNF  = ttDet.NrNotaFisNF
                                                     AND ttgEstornoCred.ItCodigoNF   = ttDet.ItCodigoNF
                                                     AND ttgEstornoCred.NrSeqFatNF   = ttDet.NrSeqFatNF) THEN DO:

                                               FOR FIRST ttIBSCBS
                                                   WHERE ttIBSCBS.CodEstabelNF =  ttDet.CodEstabelNF
                                                     AND ttIBSCBS.SerieNF      =  ttDet.SerieNF     
                                                     AND ttIBSCBS.NrNotaFisNF  =  ttDet.NrNotaFisNF 
                                                     AND ttIBSCBS.NrSeqFatNF   =  ttDet.NrSeqFatNF
                                                     AND ttIBSCBS.ItCodigoNF   =  ttDet.ItCodigoNF
                                                     AND ttIBSCBS.TipTributo   < 4 /** Nesse grupo n∆o imprime IS **/
                                                     AND ttIBSCBS.CST          <> ""
                                                     AND ttIBSCBS.cClassTrib   <> "": 
                                                     RUN addNode IN hGenXml (getStack(), "IBSCBS", "", OUTPUT iId).
                                                     addStack(iId).
                                                          
                                                          {adapters/xml/ep2/axsep037nodechar.i "CST"        ttIBSCBS.CST        "YES"}
                                                          {adapters/xml/ep2/axsep037nodechar.i "cClassTrib" ttIBSCBS.cClassTrib "YES"}
                                                          {adapters/xml/ep2/axsep037nodechar.i "indDoacao"  ttIBSCBS.indDoacao  "NO"}
                                                          
                                                          IF l-gEstornoCred OR
														     (ttIde.finNFe = "6" AND tpNFDebito <> "06" AND tpNFDebito <> "04") OR 
                                                             (ttIde.tpNF   = "0" AND ttIde.finNFe = "5" AND tpNFCredito = "05") /*Nota de entrada e finalidade NF-e Nota de crÇdito*/ THEN DO:              
                                                             IF CAN-FIND (FIRST ttgTransfCred 
                                                                    WHERE ttgTransfCred.CodEstabelNF = ttDet.CodEstabelNF
                                                                      AND ttgTransfCred.SerieNF      = ttDet.SerieNF
                                                                      AND ttgTransfCred.NrNotaFisNF  = ttDet.NrNotaFisNF
                                                                      AND ttgTransfCred.ItCodigoNF   = ttDet.ItCodigoNF
                                                                      AND ttgTransfCred.NrSeqFatNF   = ttDet.NrSeqFatNF) THEN DO:
                                                                 RUN pi-imprime-gTransfCred.     
                                                             END. 
                                                             ELSE DO:
                                                                IF CAN-FIND (FIRST ttgAjusteCompet 
                                                                       WHERE ttgAjusteCompet.CodEstabelNF = ttDet.CodEstabelNF
                                                                         AND ttgAjusteCompet.SerieNF      = ttDet.SerieNF
                                                                         AND ttgAjusteCompet.NrNotaFisNF  = ttDet.NrNotaFisNF
                                                                         AND ttgAjusteCompet.ItCodigoNF   = ttDet.ItCodigoNF
                                                                         AND ttgAjusteCompet.NrSeqFatNF   = ttDet.NrSeqFatNF) THEN DO:
                                                                   RUN pi-imprime-ttgAjusteCompet.     
                                                                END.
                                                                ELSE DO:
                                                                   IF CAN-FIND (FIRST ttgEstornoCred 
                                                                          WHERE ttgEstornoCred.CodEstabelNF = ttDet.CodEstabelNF
                                                                            AND ttgEstornoCred.SerieNF      = ttDet.SerieNF
                                                                            AND ttgEstornoCred.NrNotaFisNF  = ttDet.NrNotaFisNF
                                                                            AND ttgEstornoCred.ItCodigoNF   = ttDet.ItCodigoNF
                                                                            AND ttgEstornoCred.NrSeqFatNF   = ttDet.NrSeqFatNF) THEN DO:
                                                                   RUN pi-imprime-ttgEstornoCred.     
                                                                END.
                                                                END.
                                                             END.
                                                          END.
                                                          ELSE DO:
                                                             IF CAN-FIND (FIRST ttgIBSCBSMono 
                                                                          WHERE ttgIBSCBSMono.CodEstabelNF = ttDet.CodEstabelNF
                                                                            AND ttgIBSCBSMono.SerieNF      = ttDet.SerieNF
                                                                            AND ttgIBSCBSMono.NrNotaFisNF  = ttDet.NrNotaFisNF
                                                                            AND ttgIBSCBSMono.ItCodigoNF   = ttDet.ItCodigoNF
                                                                            AND ttgIBSCBSMono.NrSeqFatNF   = ttDet.NrSeqFatNF) THEN
                                                                RUN pi-imprime-gIBSCBSMono.
                                                             
                                                             ELSE DO:                                                                
                                                                IF ttIBSCBS.CST <> "410" AND ttIBSCBS.CST <> "620" THEN DO: /* N∆o deve mostrar gIBSCBS para operaá‰es de Imunidade e n∆o incidància */

                                                                   RUN addNode IN hGenXml (getStack(), "gIBSCBS", "", OUTPUT iId).
                                                                   addStack(iId).

                                                                       {adapters/xml/ep2/axsep037nodedec.i  "vBC"   ttIBSCBS.vBC   "YES" "2" "YES"}

                                                                        RUN pi-imprime-IBSCBS (INPUT 2). /* IBS UF */

                                                                        RUN pi-imprime-IBSCBS (INPUT 3). /* IBS Mun */

                                                                     {adapters/xml/ep2/axsep037nodedec.i  "vIBS"   ttIBSCBS.vIBS   "YES" "2" "YES"}
                                                                     
                                                                        RUN pi-imprime-IBSCBS (INPUT 1). /* CBS */

                                                                        IF CAN-FIND(FIRST ttgTribRegular 
                                                                                    WHERE ttgTribRegular.CodEstabelNF = ttDet.CodEstabelNF
                                                                                      AND ttgTribRegular.SerieNF      = ttDet.SerieNF     
                                                                                      AND ttgTribRegular.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                                                      AND ttgTribRegular.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                                                      AND ttgTribRegular.ItCodigoNF   = ttDet.ItCodigoNF) THEN DO:
                                                                           RUN pi-imprime-gTribRegular.
                                                                        END.                                                                        

                                                                        IF CAN-FIND (FIRST ttgTribCompraGov 
                                                                                     WHERE ttgTribCompraGov.CodEstabelNF = ttDet.CodEstabelNF
                                                                                       AND ttgTribCompraGov.SerieNF      = ttDet.SerieNF
                                                                                       AND ttgTribCompraGov.NrNotaFisNF  = ttDet.NrNotaFisNF
                                                                                       AND ttgTribCompraGov.ItCodigoNF   = ttDet.ItCodigoNF
                                                                                       AND ttgTribCompraGov.NrSeqFatNF   = ttDet.NrSeqFatNF) THEN DO:
                                                                             RUN pi-imprime-gTribCompraGov.
                                                                        END.
                                                                        
                                                                   delStack().
                                                                   
                                                                 END.
                                                             END.
                                                          END.

                                                          RUN pi-imprime-cred-presum.                                                     

                                                          FOR FIRST ttgCredPresIBSZFM 
                                                              WHERE ttgCredPresIBSZFM.CodEstabelNF  = ttDet.CodEstabelNF
                                                              AND   ttgCredPresIBSZFM.SerieNF       = ttDet.SerieNF
                                                              AND   ttgCredPresIBSZFM.NrNotaFisNF   = ttDet.NrNotaFisNF
                                                              AND   ttgCredPresIBSZFM.ItCodigoNF    = ttDet.ItCodigoNF
                                                              AND   ttgCredPresIBSZFM.NrSeqFatNF    = ttDet.NrSeqFatNF:

                                                              RUN addNode IN hGenXml (getStack(), "gCredPresIBSZFM", "", OUTPUT iId).
                                                              addStack(iId).
                                                                   {adapters/xml/ep2/axsep037nodechar.i "competApur"         ttgCredPresIBSZFM.tpCredPresIBSZFM  "YES"         }
                                                                   {adapters/xml/ep2/axsep037nodechar.i "tpCredPresIBSZFM"   ttgCredPresIBSZFM.tpCredPresIBSZFM  "YES"         }
                                                                   {adapters/xml/ep2/axsep037nodedec.i  "vCredPresIBSZFM"    ttgCredPresIBSZFM.vCredPresIBSZFM   "YES" "2" "YES"}
                                                              delStack().
                                                          END.                                                                                
                                                     delStack().                                                     
                                                                                    
                                               END.
                                      END.
                                   END.
                              
                              delStack().

                              RUN pi-imprime-ImpostoDevol.
                
                              {adapters/xml/ep2/axsep037nodechar2.i "infAdProd" ttDet.infAdProd "NO"}
                                  
                              IF l-NT2021004 THEN DO:
                                  
                                  IF CAN-FIND(FIRST ttDetObsCont
                                              WHERE ttDetObsCont.CodEstabelNF         = ttDet.CodEstabelNF
                                                AND ttDetObsCont.SerieNF              = ttDet.SerieNF     
                                                AND ttDetObsCont.NrNotaFisNF          = ttDet.NrNotaFisNF
                                                AND ttDetObsCont.NrSeqFatNF           = ttDet.NrSeqFatNF  
                                                AND ttDetObsCont.ItCodigoNF           = ttDet.ItCodigoNF       
                                                AND (ttDetObsCont.xTexto              <> ?
                                                AND  ttDetObsCont.xTexto              <> ""))
                                      OR  CAN-FIND(FIRST ttDetObsFisco
                                                   WHERE ttDetObsFisco.CodEstabelNF   = ttDet.CodEstabelNF
                                                     AND ttDetObsFisco.SerieNF        = ttDet.SerieNF
                                                     AND ttDetObsFisco.NrNotaFisNF    = ttDet.NrNotaFisNF
                                                     AND ttDetObsFisco.NrSeqFatNF     = ttDet.NrSeqFatNF
                                                     AND ttDetObsFisco.ItCodigoNF     = ttDet.ItCodigoNF
                                                     AND (ttDetObsFisco.xTexto        <> ?
                                                     AND  ttDetObsFisco.xTexto        <> "")) THEN
                                      
                                      RUN pi-imprime-obs-item. 

                              END.
                              
                              IF l-NT2024002 THEN DO:

                                 RUN pi-imprime-vItem.
                                                                  
                                 RUN pi-imprime-DFeReferenciado.                              
                              END.

                         delStack().
                                        
                         ASSIGN iContItem = iContItem + 1.
                   END.
                   
                   RUN pi-imprime-Total.

                   RUN pi-imprime-Transp.

                   RUN pi-imprime-Cobr.

                   RUN pi-imprime-Pag.
                                
                   IF l-NT2020006 THEN
                      RUN pi-imprime-InfIntermed.

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

                   IF l-NT2018005 AND (cTpTrans = "TSS":U OR cTpTrans = "TPF":U) THEN 
                       RUN pi-imprime-InfRespTec.
                                     
                   RUN pi-imprime-agropecuario.    

              delStack().

              IF l-simplificadoTipo2 = "YES" then 
                  RUN pi-imprime-qrCode.

         delStack().

    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-qrCode:    
       
    FOR EACH ttIde
       WHERE ttIde.CodEstabelNF = ttNFe.CodEstabelNF
         AND ttIde.SerieNF      = ttNFe.SerieNF    
         AND ttIde.NrNotaFisNF  = ttNFe.NrNotaFisNF:

        ASSIGN ttIde.qrCode = TRIM(substring(estabelec.char-1,401,150)) + "?p=" + TRIM(ttNFe.ChaveAcessoNFe) + '|3|' + ttIde.tpAmb.
        
        ASSIGN ttIde.urlChave = TRIM(substring(estabelec.char-1,401,150)).

        RUN addNode IN hGenXml (getStack(), "infNFeSupl", "", OUTPUT iId). 
        addStack(iId).
       
            RUN addNode     IN hGenXml (getStack(), "qrCode",   ttIde.qrCode,   OUTPUT iId).                                       
            RUN addNode     IN hGenXml (getStack(), "urlChave", ttIde.urlChave, OUTPUT iId).

        delStack().
    END.

END PROCEDURE.   

PROCEDURE pi-imprime-Ide:

                              FOR EACH ttIde
                                 WHERE ttIde.CodEstabelNF = ttNFe.CodEstabelNF
                                   AND ttIde.SerieNF      = ttNFe.SerieNF     
                                   AND ttIde.NrNotaFisNF  = ttNFe.NrNotaFisNF:

                                   RUN addNode IN hGenXml (getStack(), "ide", "", OUTPUT iId).
                                   addStack(iId).

                                        {adapters/xml/ep2/axsep037nodechar.i "cUF"        ttIde.cUF        "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "cNF"        ttIde.cNF        "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "natOp"      ttIde.natOp      "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "mod"        ttIde.mod        "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "serie"      ttIde.serie      "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "nNF"        ttIde.nNF        "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "dhEmi"      ttIde.dhEmi      "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "dhSaiEnt"   ttIde.dhSaiEnt   "NO" }
                                        IF  l-nt2024002 THEN
                                            {adapters/xml/ep2/axsep037nodechar.i "dPrevEntrega" ttIde.dPrevEntrega "NO"}                                        
                                        {adapters/xml/ep2/axsep037nodechar.i "tpNF"       ttIde.tpNF       "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "idDest"     ttIde.idDest     "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "cMunFG"     ttIde.cMunFG     "YES"}
                                        if l-NT2024002 then do:
                                           {adapters/xml/ep2/axsep037nodechar.i "cMunFGIBS"  ttIde.cMunFGIBS  "NO" }
                                        end.
                                        {adapters/xml/ep2/axsep037nodechar.i "tpImp"      ttIde.tpImp      "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "tpEmis"     ttIde.tpEmis     "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "cDV"        ttIde.cDV        "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "tpAmb"      ttIde.tpAmb      "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "finNFe"     ttIde.finNFe     "YES"}
                                        if l-NT2024002 then do:
                                           IF ttIde.finNFe = "6" THEN
                                              {adapters/xml/ep2/axsep037nodechar.i "tpNFDebito"  ttIde.tpNFDebito  "NO" }
                                              
                                           IF ttIde.finNFe = "5" THEN   
                                              {adapters/xml/ep2/axsep037nodechar.i "tpNFCredito" ttIde.tpNFCredito "NO" }
                                        end.
                                        {adapters/xml/ep2/axsep037nodechar.i "indFinal"   ttIde.indFinal   "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "indPres"    ttIde.indPres    "YES"}
                                        IF l-NT2020006 THEN DO:
                                            IF ttIde.indPres = "1" 
                                            OR ttIde.indPres = "2" 
                                            OR ttIde.indPres = "3" 
                                            OR ttIde.indPres = "4" 
                                            OR ttIde.indPres = "9" THEN DO:
                                                {adapters/xml/ep2/axsep037nodechar.i "indIntermed"  ttIde.indIntermed  "YES"}
                                            END.
                                        END.
                                        
                                        IF l-NT2024002 THEN
                                           {adapters/xml/ep2/axsep037nodechar.i "cIndOp"  ttIde.cIndOp  "NO"}
                                                                                
                                        {adapters/xml/ep2/axsep037nodechar.i "procEmi"  ttIde.procEmi  "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "verProc"  ttIde.verProc  "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "dhCont"   ttIde.dhCont   "NO" }
                                        {adapters/xml/ep2/axsep037nodechar.i "xJust"    ttIde.xJust    "NO" }
                                                                                    
                                        FOR EACH  ttrefNF
                                           WHERE  ttrefNF.CodEstabelNF = ttIde.CodEstabelNF
                                             AND  ttrefNF.SerieNF      = (IF ttIde.SerieNF = "" THEN "0" ELSE ttIde.SerieNF)
                                             AND  ttrefNF.NrNotaFisNF  = ttIde.NrNotaFisNF :

                                             RUN addNode IN hGenXml (getStack(), "NFref", "", OUTPUT iId).
                                             addStack(iId).
                                                  /* Nota Eletronica, envia somente tag <refNFe> */
                                                  IF  ttrefNF.refNFe <> "" THEN 
                                                      IF ttrefNF.refNFeSig <> "" THEN DO:
                                                          /* C¢digo aleatorio zerado */
                                                          {adapters/xml/ep2/axsep037nodechar.i "refNFeSig"   ttrefNF.refNFeSig  "YES"}
                                                      END.
                                                      ELSE DO:
                                                          {adapters/xml/ep2/axsep037nodechar.i "refNFe"   ttrefNF.refNFe  "YES"}
                                                      END.
                                                  /* Nao e' Nota Eletronica, enviar colecao <refNF> */
                                                  ELSE DO:
                                                      RUN addNode IN hGenXml (getStack(), "refNF",  "",             OUTPUT iId).
                                                      addStack(iId).
                                                           {adapters/xml/ep2/axsep037nodechar.i "cUF"   ttrefNF.cUF   "YES"}
                                                           {adapters/xml/ep2/axsep037nodechar.i "AAMM"  ttrefNF.AAMM  "YES"}
                                                           {adapters/xml/ep2/axsep037nodechar.i "CNPJ"  ttrefNF.CNPJ  "YES"}
                                                           {adapters/xml/ep2/axsep037nodechar.i "mod"   ttrefNF.mod   "YES"}
                                                           {adapters/xml/ep2/axsep037nodechar.i "serie" ttrefNF.serie "YES"}
                                                           {adapters/xml/ep2/axsep037nodechar.i "nNF"   ttrefNF.nNF   "YES"}
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

                                                      {adapters/xml/ep2/axsep037nodechar.i "cUF"   ttrefNFP.cUF   "YES"}
                                                      {adapters/xml/ep2/axsep037nodechar.i "AAMM"  ttrefNFP.AAMM  "YES"}

                                                      IF  ttrefNFP.CPF <> "" THEN DO:
                                                          {adapters/xml/ep2/axsep037nodechar.i "CPF"  ttrefNFP.CPF  "YES"}
                                                      END.
                                                      ELSE DO:
                                                          {adapters/xml/ep2/axsep037nodechar.i "CNPJ" ttrefNFP.CNPJ "YES"}
                                                      END.

                                                      {adapters/xml/ep2/axsep037nodechar.i "IE"    ttrefNFP.IE    "YES"}
                                                      {adapters/xml/ep2/axsep037nodechar.i "mod"   ttrefNFP.mod   "YES"}
                                                      {adapters/xml/ep2/axsep037nodechar.i "serie" ttrefNFP.serie "YES"}
                                                      {adapters/xml/ep2/axsep037nodechar.i "nNF"   ttrefNFP.nNF   "YES"}
                                                      
                                                 delStack().

                                             delStack().
                                        END.

                                        FOR EACH  ttrefCTe
                                           WHERE  ttrefCTe.CodEstabelNF = ttIde.CodEstabelNF
                                             AND  ttrefCTe.SerieNF      = (IF ttIde.SerieNF = "" THEN "0" ELSE ttIde.SerieNF)
                                             AND  ttrefCTe.NrNotaFisNF  = ttIde.NrNotaFisNF :

                                             RUN addNode IN hGenXml (getStack(), "NFref", "", OUTPUT iId).
                                             addStack(iId).
                                                  
                                                 {adapters/xml/ep2/axsep037nodechar.i "refCTe"   ttrefCTe.refCTe  "YES"}

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
    
                                                      {adapters/xml/ep2/axsep037nodechar.i "mod"    ttrefECF.mod    "YES"}
                                                      {adapters/xml/ep2/axsep037nodechar.i "nECF"   ttrefECF.nECF   "YES"}
                                                      {adapters/xml/ep2/axsep037nodechar.i "nCOO"   ttrefECF.nCOO   "YES"}
                                                      
                                                 delStack().

                                             delStack().
                                        END.
                                        
                                        IF l-nt2024002 THEN DO:
                                                                                      
                                           FOR FIRST  ttgCompraGov
                                               WHERE ttgCompraGov.CodEstabelNF = ttIde.CodEstabelNF
                                               AND   ttgCompraGov.SerieNF      = (IF ttIde.SerieNF = "" THEN "0" ELSE ttIde.SerieNF)
                                               AND   ttgCompraGov.NrNotaFisNF  = ttIde.NrNotaFisNF:

                                               ASSIGN c-tpOperGov = ttgCompraGov.tpOperGov. 
                                               
                                               RUN addNode IN hGenXml (getStack(), "gCompraGov", "", OUTPUT iId).
                                               addStack(iId).
                                                    {adapters/xml/ep2/axsep037nodechar.i "tpEnteGov" ttgCompraGov.tpEnteGov   "YES"          }
                                                    {adapters/xml/ep2/axsep037nodedec.i  "pRedutor"  ttgCompraGov.pRedutor    "YES" "4" "YES"}
                                                    {adapters/xml/ep2/axsep037nodechar.i "tpOperGov" ttgCompraGov.tpOperGov   "YES"          }

                                                FOR EACH  ttrefNF
                                                    WHERE  ttrefNF.CodEstabelNF = ttIde.CodEstabelNF
                                                      AND  ttrefNF.SerieNF      = (IF ttIde.SerieNF = "" THEN "0" ELSE ttIde.SerieNF)
                                                      AND  ttrefNF.NrNotaFisNF  = ttIde.NrNotaFisNF :
                                                    
                                                    IF  ttrefNF.refNFe <> "" and ttrefNF.refNFe <> ? THEN
                                                        {adapters/xml/ep2/axsep037nodechar.i "refDFeAnt" ttrefNF.refNFe   "YES"      }
                                                END.        
                                               delStack().
                                           END.
                                           
                                           IF CAN-FIND (FIRST ttgPagAntecipado
                                                        WHERE ttgPagAntecipado.CodEstabelNF = ttIde.CodEstabelNF
                                                        AND   ttgPagAntecipado.SerieNF      = (IF ttIde.SerieNF = "" THEN "0" ELSE ttIde.SerieNF)
                                                        AND   ttgPagAntecipado.NrNotaFisNF  = ttIde.NrNotaFisNF) THEN DO:
                                               
                                              RUN addNode IN hGenXml (getStack(), "gPagAntecipado", "", OUTPUT iId).
                                              addStack(iId).
                                                   FOR EACH  ttgPagAntecipado
                                                       WHERE ttgPagAntecipado.CodEstabelNF = ttIde.CodEstabelNF
                                                       AND   ttgPagAntecipado.SerieNF      = (IF ttIde.SerieNF = "" THEN "0" ELSE ttIde.SerieNF)
                                                       AND   ttgPagAntecipado.NrNotaFisNF  = ttIde.NrNotaFisNF:
                                           
                                                       {adapters/xml/ep2/axsep037nodechar.i "refNFe"   ttgPagAntecipado.refNFe   "YES"}
                                                   END.
                                              delStack().
                                           END.
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

         IF  NOT AVAIL ttIde THEN
             FIND FIRST ttIde NO-ERROR.
        
         RUN addNode IN hGenXml (getStack(), "emit", "", OUTPUT iId).
         addStack(iId).

              IF  ttEmit.CPF <> "" THEN DO:
                  {adapters/xml/ep2/axsep037nodechar.i "CPF"  ttEmit.CPF  "YES"}
              END.
              ELSE DO:
                  {adapters/xml/ep2/axsep037nodechar.i "CNPJ" ttEmit.CNPJ "YES"}
              END.

              {adapters/xml/ep2/axsep037nodechar.i "xNome" ttEmit.xNome "YES"}
              {adapters/xml/ep2/axsep037nodechar.i "xFant" ttEmit.xFant "NO" }

              RUN addNode IN hGenXml (getStack(), "enderEmit", "",           OUTPUT iId).
              addStack(iId).
                   {adapters/xml/ep2/axsep037nodechar.i  "xLgr"    ttEmit.xLgr    "YES"}
                   {adapters/xml/ep2/axsep037nodechar.i  "nro"     ttEmit.nro     "YES"}
                   {adapters/xml/ep2/axsep037nodechar.i  "xCpl"    ttEmit.xCpl    "NO" }
                   {adapters/xml/ep2/axsep037nodechar.i  "xBairro" ttEmit.xBairro "YES"}
                   {adapters/xml/ep2/axsep037nodechar.i  "cMun"    ttEmit.cMun    "YES"}

                   IF ttEmit.xMun = "Exterior" THEN DO:
                   {adapters/xml/ep2/axsep037nodechar2.i "xMun"    ttEmit.xMun    "YES"}
                   END.
                   ELSE DO:
                   {adapters/xml/ep2/axsep037nodechar.i  "xMun"    ttEmit.xMun    "YES"}
                   END.
                   
                   {adapters/xml/ep2/axsep037nodechar.i  "UF"      ttEmit.UF      "YES"}
                   {adapters/xml/ep2/axsep037nodechar.i  "CEP"     ttEmit.CEP     "NO" }
                   {adapters/xml/ep2/axsep037nodechar.i  "cPais"   ttEmit.cPais   "NO" }
                   {adapters/xml/ep2/axsep037nodechar.i  "xPais"   ttEmit.xPais   "NO" }
                   {adapters/xml/ep2/axsep037nodechar.i  "fone"    ttEmit.fone    "NO" }
              delStack().

              if not l-contrib-exc-ibsctbs then do:
                  {adapters/xml/ep2/axsep037nodechar.i "IE"   ttEmit.IE   "YES"}
                  IF ttIde.idDest <> "1" /*1 = Operaªío Interna*/ THEN 
                      {adapters/xml/ep2/axsep037nodechar.i "IEST" ttEmit.IEST "NO" }
              end.
              {adapters/xml/ep2/axsep037nodechar.i "IM"   ttEmit.IM   "NO" }
              {adapters/xml/ep2/axsep037nodechar.i "CNAE" ttEmit.CNAE "NO" }
              {adapters/xml/ep2/axsep037nodechar.i "CRT"  ttEmit.CRT  "YES"}

              IF l-NT2024002
              AND CAN-FIND(FIRST ttgALCZFMCBS
                           WHERE ttgALCZFMCBS.CodEstabelNF = ttNFe.CodEstabelNF
                             AND ttgALCZFMCBS.SerieNF      = ttNFe.SerieNF
                             AND ttgALCZFMCBS.NrNotaFisNF  = ttNFe.NrNotaFisNF) THEN
                             
                             {adapters/xml/ep2/axsep037nodechar.i "ISUFEmit" ttEmit.ISUFEmit  "NO"}
                 
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

                                        {adapters/xml/ep2/axsep037nodechar.i "CNPJ"    ttAvulsa.CNPJ    "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "xOrgao"  ttAvulsa.xOrgao  "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "matr"    ttAvulsa.matr    "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "xAgente" ttAvulsa.xAgente "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "fone"    ttAvulsa.fone    "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "UF"      ttAvulsa.UF      "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "nDAR"    ttAvulsa.nDAR    "YES"}
                                        {adapters/xml/ep2/axsep037nodedate.i "dEmi"    ttAvulsa.dEmi    "YES"}
                                        {adapters/xml/ep2/axsep037nodedec.i  "vDAR"    ttAvulsa.vDAR    "YES" "2" "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "repEmi"  ttAvulsa.repEmi  "YES"}
                                        {adapters/xml/ep2/axsep037nodedate.i "dPag"    ttAvulsa.dPag    "NO" }
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
                                            {adapters/xml/ep2/axsep037nodechar.i "idEstrangeiro" ttDest.idEstrangeiro "YES"}
                                        END.
                                        ELSE DO:
                                        
                                            IF  ttDest.i-natureza = 1 THEN DO: /* Pessoa F°sica */
                                            {adapters/xml/ep2/axsep037nodechar.i "CPF"        ttDest.CPF   "YES"}
                                            END.
                                            ELSE DO:
                                            {adapters/xml/ep2/axsep037nodechar.i "CNPJ"       ttDest.CNPJ  "YES"} 
                                            END.
                                        END.
                                        
                                        {adapters/xml/ep2/axsep037nodechar.i "xNome"         ttDest.xNome         "YES"}
                                        

                                        RUN addNode IN hGenXml (getStack(), "enderDest", "",           OUTPUT iId).
                                        addStack(iId).

                                             {adapters/xml/ep2/axsep037nodechar.i  "xLgr"    ttDest.xLgr    "YES"}
                                             {adapters/xml/ep2/axsep037nodechar.i  "nro"     ttDest.nro     "YES"}
                                             {adapters/xml/ep2/axsep037nodechar.i  "xCpl"    ttDest.xCpl    "NO" }
                                             {adapters/xml/ep2/axsep037nodechar.i  "xBairro" ttDest.xBairro "YES"}
                                             {adapters/xml/ep2/axsep037nodechar.i  "cMun"    ttDest.cMun    "YES"}

                                             IF ttDest.xMun = "Exterior" THEN DO:
                                             {adapters/xml/ep2/axsep037nodechar2.i "xMun"    ttDest.xMun    "YES"}
                                             END.
                                             ELSE DO:
                                             {adapters/xml/ep2/axsep037nodechar.i  "xMun"    ttDest.xMun    "YES"}
                                             END.

                                             {adapters/xml/ep2/axsep037nodechar.i  "UF"      ttDest.UF      "YES"}
                                             {adapters/xml/ep2/axsep037nodechar.i  "CEP"     ttDest.CEP     "NO" }
                                             {adapters/xml/ep2/axsep037nodechar.i  "cPais"   ttDest.cPais   "NO" }
                                             {adapters/xml/ep2/axsep037nodechar.i  "xPais"   ttDest.xPais   "NO" }
                                             {adapters/xml/ep2/axsep037nodechar.i  "fone"    ttDest.fone    "NO" }
                                        delStack().

                                        {adapters/xml/ep2/axsep037nodechar.i  "indIEDest" ttDest.indIEDest    "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i  "IE"        ttDest.IE           "NO" }
                                        {adapters/xml/ep2/axsep037nodechar.i  "ISUF"      ttDest.ISUF         "NO" }
                                        {adapters/xml/ep2/axsep037nodechar.i  "IM"        ttDest.IM           "NO" }
                                        {adapters/xml/ep2/axsep037nodechar2.i "email"     ttDest.email        "NO" }
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
                                            {adapters/xml/ep2/axsep037nodechar.i "CPF"     ttRetirada.CPF     "YES"}
                                        END.
                                        ELSE DO:
                                            {adapters/xml/ep2/axsep037nodechar.i "CNPJ"    ttRetirada.CNPJ    "YES"}
                                        END. 

                                        {adapters/xml/ep2/axsep037nodechar.i "xNome"   ttRetirada.xNome   "NO" }
                                        {adapters/xml/ep2/axsep037nodechar.i "xLgr"    ttRetirada.xLgr    "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "nro"     ttRetirada.nro     "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "xCpl"    ttRetirada.xCpl    "NO" }
                                        {adapters/xml/ep2/axsep037nodechar.i "xBairro" ttRetirada.xBairro "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "cMun"    ttRetirada.cMun    "YES"}

                                        IF ttRetirada.xMun = "Exterior" THEN DO:
                                        {adapters/xml/ep2/axsep037nodechar2.i "xMun"    ttRetirada.xMun    "YES"}
                                        END.
                                        ELSE DO:
                                        {adapters/xml/ep2/axsep037nodechar.i  "xMun"    ttRetirada.xMun    "YES"}
                                        END.
                                        
                                        {adapters/xml/ep2/axsep037nodechar.i "UF"      ttRetirada.UF      "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "CEP  "   ttRetirada.CEP     "NO" }
                                        {adapters/xml/ep2/axsep037nodechar.i "cPais"   ttRetirada.cPais   "NO" }
                                        {adapters/xml/ep2/axsep037nodechar.i "xPais"   ttRetirada.xPais   "NO" }
                                        {adapters/xml/ep2/axsep037nodechar.i "fone "   ttRetirada.fone    "NO" }
                                        {adapters/xml/ep2/axsep037nodechar.i "email"   ttRetirada.email   "NO" }
                                        if not l-contrib-exc-ibsctbs then
                                            {adapters/xml/ep2/axsep037nodechar.i "IE   "   ttRetirada.IE      "NO" }
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
                                            {adapters/xml/ep2/axsep037nodechar.i "CPF"     ttEntrega.CPF     "YES"}
                                        END.
                                        ELSE DO:
                                            {adapters/xml/ep2/axsep037nodechar.i "CNPJ"    ttEntrega.CNPJ    "YES"}
                                        END. 

                                        IF l-NT2018005 THEN
                                            {adapters/xml/ep2/axsep037nodechar.i  "xNome"    ttEntrega.xNome    "NO"}

                                        {adapters/xml/ep2/axsep037nodechar.i  "xLgr"    ttEntrega.xLgr    "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i  "nro"     ttEntrega.nro     "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i  "xCpl"    ttEntrega.xCpl    "NO" }
                                        {adapters/xml/ep2/axsep037nodechar.i  "xBairro" ttEntrega.xBairro "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i  "cMun"    ttEntrega.cMun    "YES"}

                                        IF ttEntrega.xMun = "Exterior" THEN DO:
                                        {adapters/xml/ep2/axsep037nodechar2.i "xMun"    ttEntrega.xMun    "YES"}
                                        END.
                                        ELSE DO:
                                        {adapters/xml/ep2/axsep037nodechar.i  "xMun"    ttEntrega.xMun    "YES"}
                                        END.

                                        {adapters/xml/ep2/axsep037nodechar.i  "UF"      ttEntrega.UF      "YES"}

                                        IF l-NT2018005 THEN DO:
                                            {adapters/xml/ep2/axsep037nodechar.i  "CEP  "   ttEntrega.CEP     "NO" }
                                            {adapters/xml/ep2/axsep037nodechar.i  "cPais"   ttEntrega.cPais   "NO" }
                                            {adapters/xml/ep2/axsep037nodechar.i  "xPais"   ttEntrega.xPais   "NO" }
                                            {adapters/xml/ep2/axsep037nodechar.i  "fone "   ttEntrega.fone    "NO" }
                                            {adapters/xml/ep2/axsep037nodechar.i  "email"   ttEntrega.email   "NO" }
                                            {adapters/xml/ep2/axsep037nodechar.i  "IE   "   ttEntrega.IE      "NO" }
                                        END.

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
                                            {adapters/xml/ep2/axsep037nodechar.i "CPF"     ttAutXML.CPF     "YES"}
                                        END.
                                        ELSE DO:
                                            {adapters/xml/ep2/axsep037nodechar.i "CNPJ"    ttAutXML.CNPJ    "YES"}
                                        END. 

                                   delStack().

                              END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-Prod:

                                             {adapters/xml/ep2/axsep037nodechar2.i "cProd"     ttDet.cProd     "YES"}
                                             {adapters/xml/ep2/axsep037nodechar.i  "cEAN"      ttDet.cEAN      "YES"}
                                             IF  l-nt2020005 THEN
                                                {adapters/xml/ep2/axsep037nodechar.i  "cBarra"    ttDet.cBarra    "NO" }
                                             {adapters/xml/ep2/axsep037nodechar2.i "xProd"     ttDet.xProd     "YES"}
                                             {adapters/xml/ep2/axsep037nodechar.i  "NCM"       ttDet.NCM       "NO" }
                                             {adapters/xml/ep2/axsep037nodechar.i  "NVE"       ttDet.NVE[1]    "NO" }
                                             {adapters/xml/ep2/axsep037nodechar.i  "NVE"       ttDet.NVE[2]    "NO" }
                                             {adapters/xml/ep2/axsep037nodechar.i  "NVE"       ttDet.NVE[3]    "NO" }
                                             {adapters/xml/ep2/axsep037nodechar.i  "NVE"       ttDet.NVE[4]    "NO" }
                                             {adapters/xml/ep2/axsep037nodechar.i  "NVE"       ttDet.NVE[5]    "NO" }
                                             {adapters/xml/ep2/axsep037nodechar.i  "NVE"       ttDet.NVE[6]    "NO" }
                                             {adapters/xml/ep2/axsep037nodechar.i  "NVE"       ttDet.NVE[7]    "NO" }
                                             {adapters/xml/ep2/axsep037nodechar.i  "NVE"       ttDet.NVE[8]    "NO" }

                                             IF ((ttDet.CEST      <> ? AND ttDet.CEST      <> "":U)
                                             OR  (ttDet.indEscala <> ? AND ttDet.indEscala <> "":U)
                                             OR  (ttDet.CNPJFab   <> ? AND ttDet.CNPJFab   <> "":U)) THEN DO:
                                                 {adapters/xml/ep2/axsep037nodechar.i  "CEST"      ttDet.CEST      "YES"}
                                                 {adapters/xml/ep2/axsep037nodechar.i  "indEscala" ttDet.indEscala "NO" }
                                                 {adapters/xml/ep2/axsep037nodechar.i  "CNPJFab"   ttDet.CNPJFab   "NO" }
                                             END.

                                             IF (TRIM(ttDet.cBenef) <> "":U AND TRIM(ttDet.cBenef) <> ?) THEN DO:                                             
                                                 /*RUN addNode     IN hGenXml (getStack(), "cBenef", ttDet.cBenef, OUTPUT iId). /* cBenef exige tamanho fixo de 10, e o include addnodechar utiliza TRIM, por isso foi feita esta chamada */ */
                                                 {adapters/xml/ep2/axsep037nodechar.i  "cBenef"    ttDet.cBenef    "NO" } /* Alterado v 1.60 */
                                             END.
                                             
                                             FOR EACH  ttDetPresumido
                                                 WHERE ttDetPresumido.CodEstabelNF   = ttDet.CodEstabelNF
                                                 AND   ttDetPresumido.SerieNF        = ttDet.SerieNF
                                                 AND   ttDetPresumido.NrNotaFisNF    = ttDet.NrNotaFisNF 
                                                 AND   ttDetPresumido.ItCodigoNF     = ttDet.ItCodigoNF
                                                 AND   ttDetPresumido.NrSeqFatNF     = ttDet.NrSeqFatNF:                              

                                                 IF ((ttDetPresumido.cCredPresumido <> ? AND ttDetPresumido.cCredPresumido <> "":U)
                                                 AND (ttDetPresumido.pCredPresumido <> ? ) 
                                                 AND (ttDetPresumido.vCredPresumido <> ? )) THEN DO:                                                
                                                     RUN addNode IN hGenXml (getStack(), "gCred", "", OUTPUT iId).
                                                     addStack(iId).                                        
                                                     {adapters/xml/ep2/axsep037nodechar.i  "cCredPresumido"  ttDetPresumido.cCredPresumido "YES" }
                                                     {adapters/xml/ep2/axsep037nodedec.i   "pCredPresumido"  ttDetPresumido.pCredPresumido "YES" "4"  "NO" }
                                                     {adapters/xml/ep2/axsep037nodedec.i   "vCredPresumido"  ttDetPresumido.vCredPresumido "YES" "2"  "YES" }
                                                     delStack().
                                                 END.
                                             END.
                                             
                                             IF l-NT2024002 THEN
                                                {adapters/xml/ep2/axsep037nodechar.i  "tpCredPresIBSZFM"   ttDet.tpCredPresIBSZFM   "NO"}                                             

                                             {adapters/xml/ep2/axsep037nodechar.i  "EXTIPI"    ttDet.EXTIPI     "NO" }
                                             {adapters/xml/ep2/axsep037nodechar.i  "CFOP"      ttDet.CFOP       "YES"}
                                             {adapters/xml/ep2/axsep037nodechar2.i "uCom"      ttDet.uCom       "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i   "qCom"      ttDet.qCom       "YES" "4"  "NO" }
                                             {adapters/xml/ep2/axsep037nodedec.i   "vUnCom"    ttDet.vUnCom     "YES" fn-retorna-nro-decimais-nfe-FT0301() "NO" } /*n∆o enviar sempre 10 decimais, e sim o que estiver parametrizado no FT0301*/
                                             {adapters/xml/ep2/axsep037nodedec.i   "vProd"     ttDet.vProd      "YES" "2"  "YES"}
                                             {adapters/xml/ep2/axsep037nodechar.i  "cEANTrib"  ttDet.cEANTrib   "YES"}
                                             IF  l-nt2020005 THEN
                                                 {adapters/xml/ep2/axsep037nodechar.i  "cBarraTrib"    ttDet.cBarraTrib "NO" }
                                             {adapters/xml/ep2/axsep037nodechar2.i "uTrib"     ttDet.uTrib      "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i   "qTrib"     ttDet.qTrib      "YES" "4"  "NO" }
                                             {adapters/xml/ep2/axsep037nodedec.i   "vUnTrib"   ttDet.vUnTrib    "YES" fn-retorna-nro-decimais-nfe-FT0301() "NO" } /*n∆o enviar sempre 10 decimais, e sim o que estiver parametrizado no FT0301*/
                                             {adapters/xml/ep2/axsep037nodedec.i   "vFrete"    ttDet.vFrete     "NO"  "2"  "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i   "vSeg"      ttDet.vSeg       "NO"  "2"  "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i   "vDesc"     ttDet.vDesc      "NO"  "2"  "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i   "vOutro"    ttDet.vOutro     "NO"  "2"  "YES"}
                                             {adapters/xml/ep2/axsep037nodechar.i  "indTot"    ttDet.indTot     "YES"}
                                             IF l-NT2024002 THEN
                                                {adapters/xml/ep2/axsep037nodechar.i  "indBemMovelUsado"   ttDet.indBemMovelUsado   "NO"}                                             
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

               {adapters/xml/ep2/axsep037nodechar.i "nDI"          ttDI.nDI          "YES"}
               {adapters/xml/ep2/axsep037nodedate.i "dDI"          ttDI.dDI          "YES"}
               {adapters/xml/ep2/axsep037nodechar.i "xLocDesemb"   ttDI.xLocDesemb   "YES"}
               {adapters/xml/ep2/axsep037nodechar.i "UFDesemb"     ttDI.UFDesemb     "YES"}
               {adapters/xml/ep2/axsep037nodedate.i "dDesemb"      ttDI.dDesemb      "YES"}
               {adapters/xml/ep2/axsep037nodechar.i "tpViaTransp"  ttDI.tpViaTransp  "YES"}
               IF  ttDI.tpViaTransp = "1" THEN DO: /*Valor vAFRMM obrigatorio para Via de Transporte Maritimo*/
               {adapters/xml/ep2/axsep037nodedec.i  "vAFRMM"       ttDI.vAFRMM       "YES" "2" "YES"}
               END.
               ELSE DO:
               {adapters/xml/ep2/axsep037nodedec.i  "vAFRMM"       ttDI.vAFRMM       "NO" "2" "YES"}
               END.
               {adapters/xml/ep2/axsep037nodechar.i "tpIntermedio" ttDI.tpIntermedio "YES"}

               IF ttDI.CNPJ <> "" THEN DO:
                   {adapters/xml/ep2/axsep037nodechar.i "CNPJ"     ttDI.CNPJ         "NO"}
               END.
               IF ttDI.CPF <> "" THEN DO:
                   {adapters/xml/ep2/axsep037nodechar.i "CPF"      ttDI.CPF          "NO"}
               END.

               {adapters/xml/ep2/axsep037nodechar.i "UFTerceiro"   ttDI.UFTerceiro   "NO" }
               {adapters/xml/ep2/axsep037nodechar.i "cExportador"  ttDI.cExportador  "YES"}

               FOR EACH ttAdi NO-LOCK
                  WHERE ttAdi.CodEstabelNF = ttDet.CodEstabelNF
                    AND ttAdi.SerieNF      = ttDet.SerieNF     
                    AND ttAdi.NrNotaFisNF  = ttDet.NrNotaFisNF 
                    AND ttAdi.NrSeqFatNF   = ttDet.NrSeqFatNF
                    AND ttAdi.ItCodigoNF   = ttDet.ItCodigoNF
                    AND ttAdi.nDI          = ttDI.nDI:
            
                    RUN addNode IN hGenXml (getStack(), "adi", "", OUTPUT iId).
                    addStack(iId).
            
                         IF length(ttDI.nDI) < 15 THEN DO: /*S¢ gera adiá∆o para DI*/
                            {adapters/xml/ep2/axsep037nodechar.i "nAdicao"     ttAdi.nAdicao     "YES"}    
                         END.
                         
                         {adapters/xml/ep2/axsep037nodechar.i "nSeqAdic"    ttAdi.nSeqAdic    "YES"}
                         {adapters/xml/ep2/axsep037nodechar.i "cFabricante" ttAdi.cFabricante "YES"}
                         {adapters/xml/ep2/axsep037nodedec.i  "vDescDI"     ttAdi.vDescDI     "NO" "2" "YES"}
                         {adapters/xml/ep2/axsep037nodechar.i "nDraw"       ttAdi.nDraw       "NO" }
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

                                                      {adapters/xml/ep2/axsep037nodechar.i "nDraw"     ttDetExport.nDraw     "NO" }

                                                      /*Grupo "exportInd" nao obrigatorio, mas se for gerado, os 3 campos "nRE, chNFe e qExport" s∆o obrigatorios*/
                                                      IF  (ttDetExport.nRE     <> ? AND ttDetExport.nRE     <> "" )
                                                      AND (ttDetExport.chNFe   <> ? AND ttDetExport.chNFe   <> "" )
                                                      AND (ttDetExport.qExport <> ? AND ttDetExport.qExport <> 0  ) THEN DO:
                                                      
                                                          RUN addNode IN hGenXml (getStack(), "exportInd", "", OUTPUT iId).
                                                          addStack(iId).
    
                                                              {adapters/xml/ep2/axsep037nodechar.i "nRE"     ttDetExport.nRE              "YES"}
                                                              {adapters/xml/ep2/axsep037nodechar.i "chNFe"   ttDetExport.chNFe            "YES"}
                                                              {adapters/xml/ep2/axsep037nodedec.i  "qExport" ttDetExport.qExport "NO" "4" "YES"}
                                                          
                                                          delStack().
                                                      END.
                                                  delStack().
                                             END.

END PROCEDURE.

PROCEDURE pi-imprime-Rastro:

                                             FOR EACH  ttRastro
                                                WHERE  ttRastro.CodEstabelNF = ttDet.CodEstabelNF
                                                  AND  ttRastro.SerieNF      = ttDet.SerieNF     
                                                  AND  ttRastro.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                  AND  ttRastro.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                  AND  ttRastro.ItCodigoNF   = ttDet.ItCodigoNF 
                                                  AND  ttRastro.nLote        <> ? 
                                                  AND  ttRastro.nLote        <> ""
                                                  AND  ttRastro.qLote        <> ?
                                                  AND  ttRastro.dFab         <> ? 
                                                  AND  ttRastro.dVal         <> ?:
                                                 
                                                  RUN addNode IN hGenXml (getStack(), "rastro", "", OUTPUT iId).
                                                  addStack(iId).

                                                       {adapters/xml/ep2/axsep037nodechar.i "nLote"  ttRastro.nLote  "YES"}
                                                       {adapters/xml/ep2/axsep037nodedec.i  "qLote"  ttRastro.qLote  "YES" "3" "YES"}
                                                       {adapters/xml/ep2/axsep037nodedate.i "dFab"   ttRastro.dFab   "YES"}
                                                       {adapters/xml/ep2/axsep037nodedate.i "dVal"   ttRastro.dVal   "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "cAgreg" ttRastro.cAgreg "NO" }

                                                  delStack().

                                             END.

    RETURN "OK":U.
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

                                                       {adapters/xml/ep2/axsep037nodechar.i "tpOp"          ttVeic.tpOp          "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "chassi"        ttVeic.chassi        "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "cCor"          ttVeic.cCor          "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "xCor"          ttVeic.xCor          "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "pot"           ttVeic.pot           "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "cilin"         ttVeic.cilin         "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "pesoL"         ttVeic.pesoL         "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "pesoB"         ttVeic.pesoB         "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "nSerie"        ttVeic.nSerie        "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "tpComb"        ttVeic.tpComb        "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "nMotor"        ttVeic.nMotor        "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "CMT"           ttVeic.CMT           "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "dist"          ttVeic.dist          "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "anoMod"        ttVeic.anoMod        "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "anoFab"        ttVeic.anoFab        "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "tpPint"        ttVeic.tpPint        "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "tpVeic"        ttVeic.tpVeic        "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "espVeic"       ttVeic.espVeic       "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "VIN"           ttVeic.VIN           "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "condVeic"      ttVeic.condVeic      "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "cMod"          ttVeic.cMod          "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "cCorDENATRAN"  ttVeic.cCorDENATRAN  "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "lota"          ttVeic.lota          "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "tpRest"        ttVeic.tpRest        "YES"}

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
                                                  AND (ttMed.cProdANVISA <> ?
                                                  AND  ttMed.vPMC        <> ?) :
                                                 
                                                  RUN addNode IN hGenXml (getStack(), "med", "", OUTPUT iId).
                                                  addStack(iId).

                                                       {adapters/xml/ep2/axsep037nodechar.i "cProdANVISA"    ttMed.cProdANVISA     "YES"}
                                                       IF  l-NT2018005 THEN DO:
                                                           {adapters/xml/ep2/axsep037nodechar.i "xMotivoIsencao" ttMed.xMotivoIsencao  "NO"}
                                                       END.
                                                       {adapters/xml/ep2/axsep037nodedec.i  "vPMC"           ttMed.vPMC  "YES" "2" "YES"}
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

                                                       {adapters/xml/ep2/axsep037nodechar.i "tpArma" ttArma.tpArma "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "nSerie" ttArma.nSerie "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "nCano"  ttArma.nCano  "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "descr"  ttArma.descr  "YES"}
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
                                                  AND ttComb.ItCodigoNF   = ttDet.ItCodigoNF
                                                  AND (ttComb.cProdANP <> ?
                                                  OR   ttComb.descANP  <> ?):
                                                 
                                                  RUN addNode IN hGenXml (getStack(), "comb", "", OUTPUT iId).
                                                  addStack(iId).

                                                       {adapters/xml/ep2/axsep037nodechar.i "cProdANP" ttComb.cProdANP "YES"    }
                                                       {adapters/xml/ep2/axsep037nodechar.i "descANP"  ttComb.descANP  "YES"    }

                                                       IF ((ttComb.pGLP <> ? AND ttComb.pGLP > 0)
                                                       OR  (ttComb.pGNn <> ? AND ttComb.pGNn > 0)
                                                       OR  (ttComb.pGNi <> ? AND ttComb.pGNi > 0)) THEN DO:
                                                           {adapters/xml/ep2/axsep037nodedec.i  "pGLP"     ttComb.pGLP     "YES" "4" "NO"}
                                                           {adapters/xml/ep2/axsep037nodedec.i  "pGNn"     ttComb.pGNn     "YES" "4" "NO"}
                                                           {adapters/xml/ep2/axsep037nodedec.i  "pGNi"     ttComb.pGNi     "YES" "4" "NO"}
                                                       END.
                                                       {adapters/xml/ep2/axsep037nodedec.i  "vPart"    ttComb.vPart    "NO" "2" "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "CODIF"    ttComb.CODIF    "NO"     }
                                                       {adapters/xml/ep2/axsep037nodedec.i  "qTemp"    ttComb.qTemp    "NO" "4" "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "UFCons"   ttComb.UFCons   "YES"    }

                                                       IF (ttComb.qBCProd   <> ?
                                                       AND ttComb.vAliqProd <> ?
                                                       AND ttComb.vCIDE     <> ?) THEN DO:
                                                       
                                                           RUN addNode IN hGenXml (getStack(), "CIDE", "", OUTPUT iId).
                                                           addStack(iId).
    
                                                                {adapters/xml/ep2/axsep037nodedec.i "qBCProd"   ttComb.qBCProd   "YES" "4" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i "vAliqProd" ttComb.vAliqProd "YES" "4" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i "vCIDE"     ttComb.vCIDE     "YES" "2" "YES"}
                                                           delStack().
                                                       END.

                                                       IF (ttComb.nBico   <> ?
                                                       OR  ttComb.nBomba  <> ?
                                                       OR  ttComb.nTanque <> ?
                                                       OR  ttComb.vEncIni <> ?
                                                       OR  ttComb.vEncFin <> ?) THEN DO:

                                                           RUN addNode IN hGenXml (getStack(), "encerrante", "", OUTPUT iId).
                                                           addStack(iId).
    
                                                                {adapters/xml/ep2/axsep037nodechar.i "nBico  "   ttComb.nBico     "YES"}
                                                                {adapters/xml/ep2/axsep037nodechar.i "nBomba "   ttComb.nBomba    "NO" }
                                                                {adapters/xml/ep2/axsep037nodechar.i "nTanque"   ttComb.nTanque   "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vEncIni"   ttComb.vEncIni   "YES" "3" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vEncFin"   ttComb.vEncFin   "YES" "3" "YES"}


                                                           delStack().
                                                       END.

                                                       IF ttComb.pBio <> ? THEN
                                                           {adapters/xml/ep2/axsep037nodedec.i  "pBio"      ttComb.pBio      "NO" "4" "YES"}

                                                       FOR EACH ttOrigComb
                                                          WHERE ttOrigComb.CodEstabelNF  = ttComb.CodEstabelNF
                                                            AND ttOrigComb.SerieNF       = ttComb.SerieNF     
                                                            AND ttOrigComb.NrNotaFisNF   = ttComb.NrNotaFisNF 
                                                            AND ttOrigComb.ItCodigoNF    = ttComb.ItCodigoNF  
                                                            AND ttOrigComb.NrSeqFatNF    = ttComb.NrSeqFatNF: 

                                                            RUN addNode IN hGenXml (getStack(), "origComb", "", OUTPUT iId).   
                                                            addStack(iId).                                                                                                                 

                                                                {adapters/xml/ep2/axsep037nodechar.i "indImport" ttOrigComb.indImport    "YES" }
                                                                {adapters/xml/ep2/axsep037nodechar.i "cUFOrig"   ttOrigComb.cUFOrig      "YES"}
                                                                IF ttOrigComb.pOrig = 100 THEN DO:
                                                                    {adapters/xml/ep2/axsep037nodechar.i "pOrig" STRING(ttOrigComb.pOrig) "YES"}
                                                                END.
                                                                ELSE DO:
                                                                    {adapters/xml/ep2/axsep037nodedec.i  "pOrig" ttOrigComb.pOrig         "YES" "4" "NO"}
                                                                END.
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

                                                            {adapters/xml/ep2/axsep037nodechar.i "orig"  ttICMS00.orig  "YES"}
                                                            {adapters/xml/ep2/axsep037nodechar.i "CST"   ttICMS00.CST   "YES"}
                                                            {adapters/xml/ep2/axsep037nodechar.i "modBC" ttICMS00.modBC "YES"}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "vBC"   ttICMS00.vBC   "YES" "2" "YES"}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "pICMS" ttICMS00.pICMS "YES" "4" "NO "}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "vICMS" ttICMS00.vICMS "YES" "2" "YES"}

                                                            /* FCP */
                                                            IF ((ttICMS00.pFCP <> ? AND ttICMS00.pFCP > 0)
                                                            AND (ttICMS00.vFCP <> ? AND ttICMS00.vFCP > 0)) THEN DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pFCP" ttICMS00.pFCP "YES" "4" "NO "}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vFCP" ttICMS00.vFCP "YES" "2" "YES"}
                                                            END.
                                                       delStack().
                                                  END.

                                                  FOR EACH ttICMS02
                                                     WHERE ttICMS02.CodEstabelNF = ttDet.CodEstabelNF    
                                                       AND ttICMS02.SerieNF      = ttDet.SerieNF         
                                                       AND ttICMS02.NrNotaFisNF  = ttDet.NrNotaFisNF     
                                                       AND ttICMS02.NrSeqFatNF   = ttDet.NrSeqFatNF      
                                                       AND ttICMS02.ItCodigoNF   = ttDet.ItCodigoNF :

                                                       RUN addNode IN hGenXml (getStack(), "ICMS02", "", OUTPUT iId).
                                                       addStack(iId).

                                                            {adapters/xml/ep2/axsep037nodechar.i "orig"         ttICMS02.orig       "YES"}          
                                                            {adapters/xml/ep2/axsep037nodechar.i "CST"          ttICMS02.CST        "YES"}          
                                                            {adapters/xml/ep2/axsep037nodedec.i  "qBCMono"      ttICMS02.qBCMono    "YES" "4" "YES"}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "adRemICMS"    ttICMS02.adRemICMS  "YES" "4" "YES"}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "vICMSMono"    ttICMS02.vICMSMono  "YES" "2" "NO"}

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

                                                            {adapters/xml/ep2/axsep037nodechar.i "orig"     ttICMS10.orig     "YES"}
                                                            {adapters/xml/ep2/axsep037nodechar.i "CST"      ttICMS10.CST      "YES"}
                                                            {adapters/xml/ep2/axsep037nodechar.i "modBC"    ttICMS10.modBC    "YES"}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "vBC"      ttICMS10.vBC      "YES" "2" "YES"}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "pICMS"    ttICMS10.pICMS    "YES" "4" "NO "}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "vICMS"    ttICMS10.vICMS    "YES" "2" "YES"}

                                                            /* FCP */
                                                            IF ((ttICMS10.vBCFCP <> ? AND ttICMS10.vBCFCP > 0)
                                                            AND (ttICMS10.pFCP   <> ? AND ttICMS10.pFCP   > 0)
                                                            AND (ttICMS10.vFCP   <> ? AND ttICMS10.vFCP   > 0)) THEN DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vBCFCP" ttICMS10.vBCFCP "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pFCP"   ttICMS10.pFCP   "YES" "4" "NO "}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vFCP"   ttICMS10.vFCP   "YES" "2" "YES"}
                                                            END.

                                                            {adapters/xml/ep2/axsep037nodechar.i "modBCST"  ttICMS10.modBCST  "YES"}

                                                            IF l-NT2019001 THEN DO:
                                                               IF ttICMS10.modBCST = "4" THEN DO:
                                                                  {adapters/xml/ep2/axsep037nodedec.i  "pMVAST"   ttICMS10.pMVAST   "YES"  "4" "NO "}
                                                               end.
                                                            END.
                                                            ELSE DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pMVAST"   ttICMS10.pMVAST   "NO"  "4" "NO "}
                                                            END.
                                                               
                                                            {adapters/xml/ep2/axsep037nodedec.i  "pRedBCST" ttICMS10.pRedBCST "NO"  "4" "NO "}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "vBCST"    ttICMS10.vBCST    "YES" "2" "YES"}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "pICMSST"  ttICMS10.pICMSST  "YES" "4" "NO "}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "vICMSST"  ttICMS10.vICMSST  "YES" "2" "YES"}

                                                            /* FCP ST */
                                                            IF ((ttICMS10.vBCFCPST <> ? AND ttICMS10.vBCFCPST > 0)
                                                            AND (ttICMS10.pFCPST   <> ? AND ttICMS10.pFCPST   > 0)
                                                            AND (ttICMS10.vFCPST   <> ? AND ttICMS10.vFCPST   > 0)) THEN DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vBCFCPST" ttICMS10.vBCFCPST "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pFCPST"   ttICMS10.pFCPST   "YES" "4" "NO "}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vFCPST"   ttICMS10.vFCPST   "YES" "2" "YES"}
                                                            END.

                                                            IF  l-nt2020005 
                                                            AND (ttICMS10.vICMSSTDeson <> ? AND ttICMS10.vICMSSTDeson > 0 )
                                                            AND (ttICMS10.motDesICMSST <> ? AND ttICMS10.motDesICMSST <> "" AND ttICMS10.motDesICMSST <> "0") THEN DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vICMSSTDeson" ttICMS10.vICMSSTDeson "NO" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodechar.i "motDesICMSST" ttICMS10.motDesICMSST "NO" }
                                                            END.

                                                       delStack().

                                                  END.
                                                    
                                                  FOR EACH ttICMS15                                    
                                                     WHERE ttICMS15.CodEstabelNF = ttDet.CodEstabelNF  
                                                       AND ttICMS15.SerieNF      = ttDet.SerieNF       
                                                       AND ttICMS15.NrNotaFisNF  = ttDet.NrNotaFisNF   
                                                       AND ttICMS15.NrSeqFatNF   = ttDet.NrSeqFatNF    
                                                       AND ttICMS15.ItCodigoNF   = ttDet.ItCodigoNF :  

                                                       RUN addNode IN hGenXml (getStack(), "ICMS15", "", OUTPUT iId).
                                                       addStack(iId).

                                                            {adapters/xml/ep2/axsep037nodechar.i "orig          "   ttICMS15.orig           "YES"}         
                                                            {adapters/xml/ep2/axsep037nodechar.i "CST           "   ttICMS15.CST            "YES"}           
                                                            {adapters/xml/ep2/axsep037nodedec.i  "qBCMono       "   ttICMS15.qBCMono        "YES" "4" "NO" }      
                                                            {adapters/xml/ep2/axsep037nodedec.i  "adRemICMS     "   ttICMS15.adRemICMS      "YES" "4" "NO" }   
                                                            {adapters/xml/ep2/axsep037nodedec.i  "vICMSMono     "   ttICMS15.vICMSMono      "YES" "2" "YES"}     
                                                            {adapters/xml/ep2/axsep037nodedec.i  "qBCMonoReten  "   ttICMS15.qBCMonoReten   "YES" "4" "NO" } 
                                                            {adapters/xml/ep2/axsep037nodedec.i  "adRemICMSReten"   ttICMS15.adRemICMSReten "YES" "4" "NO" }
                                                            {adapters/xml/ep2/axsep037nodedec.i  "vICMSMonoReten"   ttICMS15.vICMSMonoReten "YES" "4" "NO"}


                                                            IF  (ttICMS15.pRedAdRem   <> ? AND ttICMS15.pRedAdRem > 0 )                                           
                                                            AND (ttICMS15.motRedAdRem <> ? AND ttICMS15.motRedAdRem <> "" AND ttICMS15.motRedAdRem <> "0") THEN DO:

                                                                {adapters/xml/ep2/axsep037nodedec.i  "pRedAdRem"   ttICMS15.pRedAdRem   "NO" "2" "YES"}             
                                                                {adapters/xml/ep2/axsep037nodechar.i "motRedAdRem" ttICMS15.motRedAdRem "NO"}                      
                                                            END.                                                                                                      
                                                      
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
                                                            {adapters/xml/ep2/axsep037nodechar.i "orig"   ttICMS20.orig   "YES"}
                                                            {adapters/xml/ep2/axsep037nodechar.i "CST"    ttICMS20.CST    "YES"}
                                                            {adapters/xml/ep2/axsep037nodechar.i "modBC"  ttICMS20.modBC  "YES"}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "pRedBC" ttICMS20.pRedBC "YES" "4" "NO "}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "vBC"    ttICMS20.vBC    "YES" "2" "YES"}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "pICMS"  ttICMS20.pICMS  "YES" "4" "NO "}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "vICMS"  ttICMS20.vICMS  "YES" "2" "YES"}

                                                            /* FCP */
                                                            IF ((ttICMS20.vBCFCP <> ? AND ttICMS20.vBCFCP > 0)
                                                            AND (ttICMS20.pFCP   <> ? AND ttICMS20.pFCP   > 0)
                                                            AND (ttICMS20.vFCP   <> ? AND ttICMS20.vFCP   > 0)) THEN DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vBCFCP" ttICMS20.vBCFCP "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pFCP"   ttICMS20.pFCP   "YES" "4" "NO "}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vFCP"   ttICMS20.vFCP   "YES" "2" "YES"}
                                                            END.
                                                            
                                                            IF  (ttICMS20.vICMSDeson <> ? AND ttICMS20.vICMSDeson  > 0 )
                                                            AND (ttICMS20.motDesICMS <> ? AND ttICMS20.motDesICMS <> "" AND ttICMS20.motDesICMS <> "0") THEN DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vICMSDeson"  ttICMS20.vICMSDeson  "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodechar.i "motDesICMS"  ttICMS20.motDesICMS  "YES"}
                                                                
                                                                IF l-NT2023004 THEN DO:                                                                                                                         
                                                                   IF ttICMS20.indDeduzDeson <> ? AND ttICMS20.indDeduzDeson <> "" THEN
                                                                       {adapters/xml/ep2/axsep037nodechar.i "indDeduzDeson" ttICMS20.indDeduzDeson  "YES"}   
                                                                END.
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
                                                            {adapters/xml/ep2/axsep037nodechar.i "orig"     ttICMS30.orig     "YES"}
                                                            {adapters/xml/ep2/axsep037nodechar.i "CST"      ttICMS30.CST      "YES"}
                                                            {adapters/xml/ep2/axsep037nodechar.i "modBCST"  ttICMS30.modBCST  "YES"}

                                                            IF l-NT2019001 THEN DO: 
                                                               IF ttICMS30.modBCST = "4" THEN DO:
                                                                  {adapters/xml/ep2/axsep037nodedec.i  "pMVAST"   ttICMS30.pMVAST   "YES"  "4" "NO "}
                                                               END.
                                                            END.
                                                            ELSE DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pMVAST"   ttICMS30.pMVAST   "NO"  "4" "NO "}
                                                            END.

                                                            {adapters/xml/ep2/axsep037nodedec.i  "pRedBCST" ttICMS30.pRedBCST "NO"  "4" "NO "} 
                                                            {adapters/xml/ep2/axsep037nodedec.i  "vBCST"    ttICMS30.vBCST    "YES" "2" "YES"}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "pICMSST"  ttICMS30.pICMSST  "YES" "4" "NO "}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "vICMSST"  ttICMS30.vICMSST  "YES" "2" "YES"}

                                                            /* FCP ST */
                                                            IF ((ttICMS30.vBCFCPST <> ? AND ttICMS30.vBCFCPST > 0)
                                                            AND (ttICMS30.pFCPST   <> ? AND ttICMS30.pFCPST   > 0)
                                                            AND (ttICMS30.vFCPST   <> ? AND ttICMS30.vFCPST   > 0)) THEN DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vBCFCPST" ttICMS30.vBCFCPST "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pFCPST"   ttICMS30.pFCPST   "YES" "4" "NO "}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vFCPST"   ttICMS30.vFCPST   "YES" "2" "YES"}
                                                            END.

                                                            IF  (ttICMS30.vICMSDeson <> ? AND ttICMS30.vICMSDeson  > 0 )
                                                            AND (ttICMS30.motDesICMS <> ? AND ttICMS30.motDesICMS <> "" AND ttICMS30.motDesICMS <> "0") THEN DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vICMSDeson"  ttICMS30.vICMSDeson  "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodechar.i "motDesICMS"  ttICMS30.motDesICMS  "YES"}
                                                                
                                                                IF l-NT2023004 THEN DO:                                                                                                                         
                                                                   IF ttICMS30.indDeduzDeson <> ? AND ttICMS30.indDeduzDeson <> "" THEN
                                                                       {adapters/xml/ep2/axsep037nodechar.i "indDeduzDeson" ttICMS30.indDeduzDeson  "YES"}   
                                                                END.
                                                                
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
                                                            {adapters/xml/ep2/axsep037nodechar.i "orig"        ttICMS40.orig        "YES"}
                                                            {adapters/xml/ep2/axsep037nodechar.i "CST"         ttICMS40.CST         "YES"}

                                                            IF  (ttICMS40.vICMSDeson <> ? AND ttICMS40.vICMSDeson  > 0 )
                                                            AND (ttICMS40.motDesICMS <> ? AND ttICMS40.motDesICMS <> "" AND ttICMS40.motDesICMS <> "0") THEN DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vICMSDeson"  ttICMS40.vICMSDeson  "NO"  "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodechar.i "motDesICMS"  ttICMS40.motDesICMS  "NO" }                                                                        
                                                                
                                                                IF l-NT2023004 THEN DO:                                                                                                                         
                                                                   IF ttICMS40.indDeduzDeson <> ? AND ttICMS40.indDeduzDeson <> "" THEN
                                                                       {adapters/xml/ep2/axsep037nodechar.i "indDeduzDeson" ttICMS40.indDeduzDeson  "YES"}   
                                                                END.                                                                
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
                                                            {adapters/xml/ep2/axsep037nodechar.i "orig"     ttICMS51.orig     "YES"}
                                                            {adapters/xml/ep2/axsep037nodechar.i "CST"      ttICMS51.CST      "YES"}
                                                            {adapters/xml/ep2/axsep037nodechar.i "modBC"    ttICMS51.modBC    "NO" }
                                                            
                                                            IF  l-NT2019001
                                                            AND ttICMS51.pDif  > 0
                                                            AND ttICMS51.pDif <> ? THEN DO:    
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pRedBC"    ttICMS51.pRedBC   "yes"  "4" "NO "}
                                                                {adapters/xml/ep2/axsep037nodechar.i "cBenefRBC" ttICMS51.cBenefRBC           "NO" }  
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vBC"      ttICMS51.vBC      "yes"  "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pICMS"    ttICMS51.pICMS    "yes"  "4" "NO "}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vICMSOp"  ttICMS51.vICMSOp  "yes"  "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pDif"     ttICMS51.pDif     "yes"  "4" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vICMSDif" ttICMS51.vICMSDif "yes"  "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vICMS"    ttICMS51.vICMS    "yes"  "2" "YES"}
                                                            END.
                                                            ELSE DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i   "pRedBC"    ttICMS51.pRedBC   "NO"  "4" "NO "}
                                                                {adapters/xml/ep2/axsep037nodechar.i  "cBenefRBC" ttICMS51.cBenefRBC          "NO" }  
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vBC"      ttICMS51.vBC      "NO"  "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pICMS"    ttICMS51.pICMS    "NO"  "4" "NO "}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vICMSOp"  ttICMS51.vICMSOp  "NO"  "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pDif"     ttICMS51.pDif     "NO"  "4" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vICMSDif" ttICMS51.vICMSDif "NO"  "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vICMS"    ttICMS51.vICMS    "NO"  "2" "YES"}
                                                            END.
                                                            /* FCP */
                                                            /* Diferinmento Total RJ */  
                                                            IF  l-FCP-diferido = YES
                                                            AND ((ttICMS51.vBCFCP <> ? AND ttICMS51.vBCFCP > 0)
                                                            AND  (ttICMS51.pFCP   <> ? AND ttICMS51.pFCP   > 0)) THEN DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vBCFCP" ttICMS51.vBCFCP "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pFCP"   ttICMS51.pFCP   "YES" "4" "NO "}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vFCP"   ttICMS51.vFCP   "YES" "2" "YES"}
                                                            END.
                                                            ELSE                                                            
                                                                IF ((ttICMS51.vBCFCP <> ? AND ttICMS51.vBCFCP > 0)
                                                                AND (ttICMS51.pFCP   <> ? AND ttICMS51.pFCP   > 0)
                                                                AND (ttICMS51.vFCP   <> ? AND ttICMS51.vFCP   > 0)) THEN DO:
                                                                    {adapters/xml/ep2/axsep037nodedec.i  "vBCFCP" ttICMS51.vBCFCP "YES" "2" "YES"}
                                                                    {adapters/xml/ep2/axsep037nodedec.i  "pFCP"   ttICMS51.pFCP   "YES" "4" "NO "}
                                                                    {adapters/xml/ep2/axsep037nodedec.i  "vFCP"   ttICMS51.vFCP   "YES" "2" "YES"}
                                                                END.
                                                            /* FCP Diferido */
                                                            IF  l-nt2020005
                                                            AND ((ttICMS51.pFCPDif <> ? AND ttICMS51.pFCPDif > 0)
                                                            AND ( ttICMS51.vFCPDif <> ? AND ttICMS51.vFCPDif > 0)) THEN DO:                                                               
                                                                {adapters/xml/ep2/axsep037nodedec.i "pFCPDif"  ttICMS51.pFCPDif   "YES" "4" "NO "}
                                                                {adapters/xml/ep2/axsep037nodedec.i "vFCPDif"  ttICMS51.vFCPDif   "YES" "2" "YES"}
                                                                
                                                                IF l-FCP-diferido = YES THEN 
                                                                    {adapters/xml/ep2/axsep037nodedec.i "vFCPEfet" ttICMS51.vFCPEfet  "YES" "2" "YES"}
                                                                ELSE
                                                                    {adapters/xml/ep2/axsep037nodedec.i "vFCPEfet" ttICMS51.vFCPEfet  "NO" "2" "YES"}
                                                            END.
                                                       delStack().
                                                  END.

                                                  FOR EACH ttICMS53                                     
                                                     WHERE ttICMS53.CodEstabelNF = ttDet.CodEstabelNF   
                                                       AND ttICMS53.SerieNF      = ttDet.SerieNF        
                                                       AND ttICMS53.NrNotaFisNF  = ttDet.NrNotaFisNF    
                                                       AND ttICMS53.NrSeqFatNF   = ttDet.NrSeqFatNF     
                                                       AND ttICMS53.ItCodigoNF   = ttDet.ItCodigoNF : 

                                                       RUN addNode IN hGenXml (getStack(), "ICMS53", "", OUTPUT iId).
                                                       addStack(iId).

                                                       {adapters/xml/ep2/axsep037nodechar.i "orig        "     ttICMS53.orig  "YES"}      
                                                       {adapters/xml/ep2/axsep037nodechar.i "CST         "     ttICMS53.CST   "YES"}      
                                                       
                                                       IF ttICMS53.pDif > 0 AND 
                                                       ttICMS53.pDif <> ? THEN DO:
                                                           {adapters/xml/ep2/axsep037nodedec.i  "qBCMono     "     ttICMS53.qBCMono         "YES" "4" "NO" } 
                                                           {adapters/xml/ep2/axsep037nodedec.i  "adRemICMS   "     ttICMS53.adRemICMS       "YES" "4" "NO" } 
                                                           {adapters/xml/ep2/axsep037nodedec.i  "vICMSMonoOp "     ttICMS53.vICMSMonoOp     "YES" "2" "YES"} 
                                                           {adapters/xml/ep2/axsep037nodedec.i  "pDif        "     ttICMS53.pDif            "YES"  "4" "YES"}
                                                           {adapters/xml/ep2/axsep037nodedec.i  "vICMSMonoDif"     ttICMS53.vICMSMonoDif    "YES" "2" "YES"} 
                                                           {adapters/xml/ep2/axsep037nodedec.i  "vICMSMono   "     ttICMS53.vICMSMono       "YES"  "2" "YES"}
                                                       END.

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
                                                            {adapters/xml/ep2/axsep037nodechar.i "orig"       ttICMS60.orig       "YES"}
                                                            {adapters/xml/ep2/axsep037nodechar.i "CST"        ttICMS60.CST        "YES"}
                                                            
                                                            /*IF ((ttICMS60.vBCSTRet        <> ? AND ttICMS60.vBCSTRet > 0)
                                                            OR  (ttICMS60.pST             <> ? AND ttICMS60.pST > 0)
                                                            OR  (ttICMS60.vICMSSubstituto <> ? AND ttICMS60.vICMSSubstituto > 0)
                                                            OR  (ttICMS60.vICMSSTRet      <> ? AND ttICMS60.vICMSSTRet > 0)) THEN DO:*/
                                                            
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vBCSTRet"        ttICMS60.vBCSTRet        "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pST"             ttICMS60.pST             "YES" "4" "NO "}
                                                                
                                                                IF l-NT2018005 THEN DO:
                                                                    {adapters/xml/ep2/axsep037nodedec.i  "vICMSSubstituto" ttICMS60.vICMSSubstituto "YES" "2" "YES"}                                                                
                                                                END.

                                                                {adapters/xml/ep2/axsep037nodedec.i  "vICMSSTRet"      ttICMS60.vICMSSTRet      "YES" "2" "YES"}
                                                            //END.

                                                            /* FCP ST Ret */
                                                            IF ((ttICMS60.vBCFCPSTRet <> ? AND ttICMS60.vBCFCPSTRet > 0)
                                                            AND (ttICMS60.pFCPSTRet   <> ? AND ttICMS60.pFCPSTRet   > 0)
                                                            AND (ttICMS60.vFCPSTRet   <> ? AND ttICMS60.vFCPSTRet   > 0)) THEN DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vBCFCPSTRet" ttICMS60.vBCFCPSTRet "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pFCPSTRet"   ttICMS60.pFCPSTRet   "YES" "4" "NO "}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vFCPSTRet"   ttICMS60.vFCPSTRet   "YES" "2" "YES"}
                                                            END.
                                                            
                                                            IF  ttICMS60.vICMSEfet <> ? THEN DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pRedBCEfet" ttICMS60.pRedBCEfet "YES" "4" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vBCEfet"    ttICMS60.vBCEfet    "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pICMSEfet"  ttICMS60.pICMSEfet  "YES" "4" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vICMSEfet"  ttICMS60.vICMSEfet  "YES" "2" "YES"}    
                                                            END.

                                                       delStack().
                                                  END.
                                                    
                                                  FOR EACH ttICMS61                                                                                           
                                                     WHERE ttICMS61.CodEstabelNF = ttDet.CodEstabelNF                                                         
                                                       AND ttICMS61.SerieNF      = ttDet.SerieNF                                                              
                                                       AND ttICMS61.NrNotaFisNF  = ttDet.NrNotaFisNF                                                          
                                                       AND ttICMS61.NrSeqFatNF   = ttDet.NrSeqFatNF                                                           
                                                       AND ttICMS61.ItCodigoNF   = ttDet.ItCodigoNF :                                                         
                                                                                                                                                              
                                                       RUN addNode IN hGenXml (getStack(), "ICMS61", "", OUTPUT iId).                                         
                                                       addStack(iId).                                                                                         
                                                                                                                                                              
                                                       {adapters/xml/ep2/axsep037nodechar.i "orig        "     ttICMS61.orig  "YES"}                          
                                                       {adapters/xml/ep2/axsep037nodechar.i "CST         "     ttICMS61.CST   "YES"}                          
                                                       {adapters/xml/ep2/axsep037nodedec.i  "qBCMonoRet  "     ttICMS61.qBCMonoRet     "YES" "4" "NO" }      
                                                       {adapters/xml/ep2/axsep037nodedec.i  "adRemICMSRet"     ttICMS61.adRemICMSRet   "YES" "4" "NO" }      
                                                       {adapters/xml/ep2/axsep037nodedec.i  "vICMSMonoRet"     ttICMS61.vICMSMonoRet   "YES" "2" "YES"}      
                                                                                                                                                              
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
                                                            {adapters/xml/ep2/axsep037nodechar.i "orig"     ttICMS70.orig     "YES"}
                                                            {adapters/xml/ep2/axsep037nodechar.i "CST"      ttICMS70.CST      "YES"}
                                                            {adapters/xml/ep2/axsep037nodechar.i "modBC"    ttICMS70.modBC    "YES"}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "pRedBC"   ttICMS70.pRedBC   "YES" "4" "NO "}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "vBC"      ttICMS70.vBC      "YES" "2" "YES"}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "pICMS"    ttICMS70.pICMS    "YES" "4" "NO "}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "vICMS"    ttICMS70.vICMS    "YES" "2" "YES"}

                                                            /* FCP */
                                                            IF ((ttICMS70.vBCFCP <> ? AND ttICMS70.vBCFCP > 0)
                                                            AND (ttICMS70.pFCP   <> ? AND ttICMS70.pFCP   > 0)
                                                            AND (ttICMS70.vFCP   <> ? AND ttICMS70.vFCP   > 0)) THEN DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vBCFCP" ttICMS70.vBCFCP "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pFCP"   ttICMS70.pFCP   "YES" "4" "NO "}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vFCP"   ttICMS70.vFCP   "YES" "2" "YES"}
                                                            END.

                                                            {adapters/xml/ep2/axsep037nodechar.i "modBCST"  ttICMS70.modBCST  "YES"}

                                                           IF l-NT2019001 THEN DO: 
                                                              IF ttICMS70.modBCST = "4" THEN DO:
                                                                 {adapters/xml/ep2/axsep037nodedec.i  "pMVAST"   ttICMS70.pMVAST   "YES"  "4" "NO "}
                                                              END.
                                                           END.
                                                           ELSE DO:
                                                               {adapters/xml/ep2/axsep037nodedec.i  "pMVAST"   ttICMS70.pMVAST   "NO"  "4" "NO "}
                                                           END.
                                                                
                                                            {adapters/xml/ep2/axsep037nodedec.i  "pRedBCST" ttICMS70.pRedBCST "NO"  "4" "NO "}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "vBCST"    ttICMS70.vBCST    "YES" "2" "YES"}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "pICMSST"  ttICMS70.pICMSST  "YES" "4" "NO "}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "vICMSST"  ttICMS70.vICMSST  "YES" "2" "YES"}

                                                            /* FCP ST */
                                                            IF ((ttICMS70.vBCFCPST <> ? AND ttICMS70.vBCFCPST > 0)
                                                            AND (ttICMS70.pFCPST   <> ? AND ttICMS70.pFCPST   > 0)
                                                            AND (ttICMS70.vFCPST   <> ? AND ttICMS70.vFCPST   > 0)) THEN DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vBCFCPST" ttICMS70.vBCFCPST "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pFCPST"   ttICMS70.pFCPST   "YES" "4" "NO "}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vFCPST"   ttICMS70.vFCPST   "YES" "2" "YES"}
                                                            END.

                                                            IF  (ttICMS70.vICMSDeson <> ? AND ttICMS70.vICMSDeson  > 0 )
                                                            AND (ttICMS70.motDesICMS <> ? AND ttICMS70.motDesICMS <> "" AND ttICMS70.motDesICMS <> "0") THEN DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vICMSDeson"  ttICMS70.vICMSDeson  "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodechar.i "motDesICMS"  ttICMS70.motDesICMS  "YES"}
                                                                
                                                                IF l-NT2023004 THEN DO:                                                                                                                         
                                                                   IF ttICMS70.indDeduzDeson <> ? AND ttICMS70.indDeduzDeson <> "" THEN
                                                                       {adapters/xml/ep2/axsep037nodechar.i "indDeduzDeson" ttICMS70.indDeduzDeson  "YES"}   
                                                                END.
                                                            END.

                                                            IF  l-nt2020005 
                                                            AND (ttICMS70.vICMSSTDeson <> ? AND ttICMS70.vICMSSTDeson > 0 )
                                                            AND (ttICMS70.motDesICMSST <> ? AND ttICMS70.motDesICMSST <> "" AND ttICMS70.motDesICMSST <> "0") THEN DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vICMSSTDeson" ttICMS70.vICMSSTDeson "NO" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodechar.i "motDesICMSST" ttICMS70.motDesICMSST "NO" }
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
                                                            {adapters/xml/ep2/axsep037nodechar.i "orig"     ttICMS90.orig     "YES"}
                                                            {adapters/xml/ep2/axsep037nodechar.i "CST"      ttICMS90.CST      "YES"}

                                                            IF  ((ttICMS90.modBC  <> ? AND ttICMS90.modBC  <> "")
                                                            AND ((ttICMS90.vBC    <> ? AND ttICMS90.vBC    <> 0 )
                                                            OR   (ttICMS90.pICMS  <> ? AND ttICMS90.pICMS  <> 0 )
                                                            OR   (ttICMS90.vICMS  <> ? AND ttICMS90.vICMS  <> 0 ))
                                                              
                                                            OR  ((ttICMS90.vBCFCP <> ? AND ttICMS90.vBCFCP > 0)
                                                            OR   (ttICMS90.pFCP   <> ? AND ttICMS90.pFCP   > 0)
                                                            OR   (ttICMS90.vFCP   <> ? AND ttICMS90.vFCP   > 0)))
                                                            THEN DO:
                                                            
                                                                {adapters/xml/ep2/axsep037nodechar.i "modBC"    ttICMS90.modBC    "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vBC"      ttICMS90.vBC      "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pRedBC"   ttICMS90.pRedBC   "NO"  "4" "NO "}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pICMS"    ttICMS90.pICMS    "YES" "4" "NO "}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vICMS"    ttICMS90.vICMS    "YES" "2" "YES"}

                                                                /* FCP */
                                                                IF  ((ttICMS90.vBCFCP <> ? AND ttICMS90.vBCFCP > 0)
                                                                OR   (ttICMS90.pFCP   <> ? AND ttICMS90.pFCP   > 0)
                                                                OR   (ttICMS90.vFCP   <> ? AND ttICMS90.vFCP   > 0)) THEN DO: 
                                                                    {adapters/xml/ep2/axsep037nodedec.i  "vBCFCP" ttICMS90.vBCFCP "YES" "2" "YES"}
                                                                    {adapters/xml/ep2/axsep037nodedec.i  "pFCP"   ttICMS90.pFCP   "YES" "4" "NO "}
                                                                    {adapters/xml/ep2/axsep037nodedec.i  "vFCP"   ttICMS90.vFCP   "YES" "2" "YES"}

                                                                END.
                                                            END.

                                                            IF  ((ttICMS90.modBCST  <> ? AND ttICMS90.modBCST  <> "")
                                                            AND ((ttICMS90.vBCST    <> ? AND ttICMS90.vBCST    <> 0 )
                                                            OR   (ttICMS90.pICMSST  <> ? AND ttICMS90.pICMSST  <> 0 )
                                                            OR   (ttICMS90.vICMSST  <> ? AND ttICMS90.vICMSST  <> 0 ))
                                                              
                                                            OR  ((ttICMS90.vBCFCPST <> ? AND ttICMS90.vBCFCPST > 0)
                                                            OR   (ttICMS90.pFCPST   <> ? AND ttICMS90.pFCPST   > 0)
                                                            OR   (ttICMS90.vFCPST   <> ? AND ttICMS90.vFCPST   > 0)))
                                                            THEN DO:
                                                            
                                                                {adapters/xml/ep2/axsep037nodechar.i "modBCST"  ttICMS90.modBCST  "YES"}

                                                                IF  l-NT2019001 THEN DO: 
                                                                    IF ttICMS90.modBCST = "4" THEN DO:
                                                                       {adapters/xml/ep2/axsep037nodedec.i  "pMVAST"   ttICMS90.pMVAST   "YES"  "4" "NO "}
                                                                    end.
                                                                END.
                                                                ELSE DO:
                                                                     {adapters/xml/ep2/axsep037nodedec.i  "pMVAST"   ttICMS90.pMVAST   "NO"  "4" "NO "}
                                                                END.

                                                                {adapters/xml/ep2/axsep037nodedec.i  "pRedBCST" ttICMS90.pRedBCST "NO"  "4" "NO "}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vBCST"    ttICMS90.vBCST    "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pICMSST"  ttICMS90.pICMSST  "YES" "4" "NO "}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vICMSST"  ttICMS90.vICMSST  "YES" "2" "YES"}

                                                                /* FCP ST */
                                                                IF  ((ttICMS90.vBCFCPST <> ? AND ttICMS90.vBCFCPST > 0)
                                                                OR   (ttICMS90.pFCPST   <> ? AND ttICMS90.pFCPST   > 0)
                                                                OR   (ttICMS90.vFCPST   <> ? AND ttICMS90.vFCPST   > 0)) THEN DO:
                                                                    
                                                                    {adapters/xml/ep2/axsep037nodedec.i  "vBCFCPST" ttICMS90.vBCFCPST "YES" "2" "YES"}
                                                                    {adapters/xml/ep2/axsep037nodedec.i  "pFCPST"   ttICMS90.pFCPST   "YES" "4" "NO "}
                                                                    {adapters/xml/ep2/axsep037nodedec.i  "vFCPST"   ttICMS90.vFCPST   "YES" "2" "YES"}

                                                                END.
                                                            END.

                                                            IF  (ttICMS90.vICMSDeson <> ? AND ttICMS90.vICMSDeson  > 0 )
                                                            AND (ttICMS90.motDesICMS <> ? AND ttICMS90.motDesICMS <> "" AND ttICMS90.motDesICMS <> "0") THEN DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vICMSDeson"  ttICMS90.vICMSDeson  "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodechar.i "motDesICMS"  ttICMS90.motDesICMS  "YES"}
                                                                
                                                                IF l-NT2023004 THEN DO:                                                                                                                         
                                                                   IF ttICMS90.indDeduzDeson <> ? AND ttICMS90.indDeduzDeson <> "" THEN
                                                                       {adapters/xml/ep2/axsep037nodechar.i "indDeduzDeson" ttICMS90.indDeduzDeson  "YES"}   
                                                                END.
                                                                
                                                            END.

                                                            IF  l-nt2020005 
                                                            AND (ttICMS90.vICMSSTDeson <> ? AND ttICMS90.vICMSSTDeson > 0 )
                                                            AND (ttICMS90.motDesICMSST <> ? AND ttICMS90.motDesICMSST <> "" AND ttICMS90.motDesICMSST <> "0") THEN DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vICMSSTDeson" ttICMS90.vICMSSTDeson "NO" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodechar.i "motDesICMSST" ttICMS90.motDesICMSST "NO" }
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
                                                            {adapters/xml/ep2/axsep037nodechar.i "orig"     ttICMSPart.orig     "YES"}
                                                            {adapters/xml/ep2/axsep037nodechar.i "CST"      ttICMSPart.CST      "YES"}
                                                            {adapters/xml/ep2/axsep037nodechar.i "modBC"    ttICMSPart.modBC    "YES"}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "vBC"      ttICMSPart.vBC      "YES"  "2" "YES"}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "pRedBC"   ttICMSPart.pRedBC   "NO"   "4" "NO "}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "pICMS"    ttICMSPart.pICMS    "YES"  "4" "NO "}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "vICMS"    ttICMSPart.vICMS    "YES"  "2" "YES"}
                                                            {adapters/xml/ep2/axsep037nodechar.i "modBCST"  ttICMSPart.modBCST  "YES"}

                                                            IF l-NT2019001 THEN DO: 
                                                               IF ttICMSPart.modBCST = "4" THEN DO:
                                                                  {adapters/xml/ep2/axsep037nodedec.i  "pMVAST"   ttICMSPart.pMVAST   "YES"   "4" "NO "}
                                                               end.
                                                            END.
                                                            ELSE DO:
                                                               {adapters/xml/ep2/axsep037nodedec.i  "pMVAST"   ttICMSPart.pMVAST   "NO"   "4" "NO "}
                                                            END.

                                                            {adapters/xml/ep2/axsep037nodedec.i  "pRedBCST" ttICMSPart.pRedBCST "NO"   "4" "NO "}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "vBCST"    ttICMSPart.vBCST    "YES"  "2" "YES"}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "pICMSST"  ttICMSPart.pICMSST  "YES"  "4" "NO "}
                                                            {adapters/xml/ep2/axsep037nodedec.i  "vICMSST"  ttICMSPart.vICMSST  "YES"  "2" "YES"}

                                                            IF l-NT2021004 THEN DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vBCFCPST"  ttICMSPart.vBCFCPST "YES"  "4" "NO" }
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pFCPST"    ttICMSPart.pFCPST   "YES"  "4" "NO" }
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vFCPST"    ttICMSPart.vFCPST   "YES"  "4" "NO" }                                                                
                                                            END.

                                                            {adapters/xml/ep2/axsep037nodedec.i  "pBCOp"    ttICMSPart.pBCOp    "YES"  "4" "NO "}
                                                            {adapters/xml/ep2/axsep037nodechar.i "UFST"     ttICMSPart.UFST     "YES"}
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
                                                             {adapters/xml/ep2/axsep037nodechar.i "orig"            ttICMSST.orig            "YES"}
                                                             {adapters/xml/ep2/axsep037nodechar.i "CST"             ttICMSST.CST             "YES"}
                                                             {adapters/xml/ep2/axsep037nodedec.i  "vBCSTRet"        ttICMSST.vBCSTRet        "YES" "2" "YES"}
                                                             
                                                             IF l-NT2018005 THEN DO:
                                                                 {adapters/xml/ep2/axsep037nodedec.i  "pST"             ttICMSST.pST             "YES" "4" "NO "}
                                                                 {adapters/xml/ep2/axsep037nodedec.i  "vICMSSubstituto" ttICMSST.vICMSSubstituto "YES" "2" "YES"}                                                                                                                             
                                                             END.

                                                             {adapters/xml/ep2/axsep037nodedec.i  "vICMSSTRet"      ttICMSST.vICMSSTRet      "YES" "2" "YES"}

                                                             IF l-NT2018005 THEN DO:

                                                                 IF ((ttICMSST.vBCFCPSTRet <> 0 AND ttICMSST.vBCFCPSTRet > 0)   
                                                                 OR (ttICMSST.pFCPSTRet   <> 0 AND ttICMSST.pFCPSTRet   > 0)   
                                                                 OR (ttICMSST.vFCPSTRet   <> 0 AND ttICMSST.vFCPSTRet   > 0)) THEN DO:
                                                                    {adapters/xml/ep2/axsep037nodedec.i  "vBCFCPSTRet"  ttICMSST.vBCFCPSTRet "YES"  "2" "YES"}
                                                                    {adapters/xml/ep2/axsep037nodedec.i  "pFCPSTRet"    ttICMSST.pFCPSTRet   "YES"  "4" "YES"}
                                                                    {adapters/xml/ep2/axsep037nodedec.i  "vFCPSTRet"    ttICMSST.vFCPSTRet   "YES"  "2" "YES"}
                                                                 END.

                                                             END.

                                                             {adapters/xml/ep2/axsep037nodedec.i  "vBCSTDest"    ttICMSST.vBCSTDest   "YES"  "2" "YES"}
                                                             {adapters/xml/ep2/axsep037nodedec.i  "vICMSSTDest"  ttICMSST.vICMSSTDest "YES"  "2" "YES"}

                                                             IF l-NT2018005 THEN DO:
                                                                 IF  ttICMSST.vICMSEfet <> ? THEN DO:
                                                                      {adapters/xml/ep2/axsep037nodedec.i  "pRedBCEfet" ttICMSST.pRedBCEfet "YES" "4" "YES"}
                                                                      {adapters/xml/ep2/axsep037nodedec.i  "vBCEfet"    ttICMSST.vBCEfet    "YES" "2" "YES"}
                                                                      {adapters/xml/ep2/axsep037nodedec.i  "pICMSEfet"  ttICMSST.pICMSEfet  "YES" "4" "YES"}
                                                                      {adapters/xml/ep2/axsep037nodedec.i  "vICMSEfet"  ttICMSST.vICMSEfet  "YES" "2" "YES"}    
                                                                 END.
                                                             END.

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
                                                             {adapters/xml/ep2/axsep037nodechar.i "orig"         ttICMSSN101.orig         "YES"}
                                                             {adapters/xml/ep2/axsep037nodechar.i "CSOSN"        ttICMSSN101.CSOSN        "YES"}
                                                             {adapters/xml/ep2/axsep037nodedec.i  "pCredSN"      ttICMSSN101.pCredSN      "YES"  "4" "NO "}
                                                             {adapters/xml/ep2/axsep037nodedec.i  "vCredICMSSN"  ttICMSSN101.vCredICMSSN  "YES"  "2" "YES"}
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
                                                             {adapters/xml/ep2/axsep037nodechar.i "orig"         ttICMSSN102.orig        "YES"}
                                                             {adapters/xml/ep2/axsep037nodechar.i "CSOSN"        ttICMSSN102.CSOSN       "YES"}
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
                                                             {adapters/xml/ep2/axsep037nodechar.i "orig"         ttICMSSN201.orig         "YES"}
                                                             {adapters/xml/ep2/axsep037nodechar.i "CSOSN"        ttICMSSN201.CSOSN        "YES"}
                                                             {adapters/xml/ep2/axsep037nodechar.i "modBCST"      ttICMSSN201.modBCST      "YES"}

                                                             IF l-NT2019001 THEN DO: 
                                                                IF ttICMSSN201.modBCST = "4" THEN DO:
                                                                   {adapters/xml/ep2/axsep037nodedec.i  "pMVAST"       ttICMSSN201.pMVAST       "YES"   "4" "NO "}
                                                                end.
                                                             END.
                                                             ELSE DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pMVAST"       ttICMSSN201.pMVAST       "NO"   "4" "NO "}
                                                             END.

                                                             {adapters/xml/ep2/axsep037nodedec.i  "pRedBCST"     ttICMSSN201.pRedBCST     "NO"   "4" "NO "}
                                                             {adapters/xml/ep2/axsep037nodedec.i  "vBCST"        ttICMSSN201.vBCST        "YES"  "2" "YES"}
                                                             {adapters/xml/ep2/axsep037nodedec.i  "pICMSST"      ttICMSSN201.pICMSST      "YES"  "4" "NO "}
                                                             {adapters/xml/ep2/axsep037nodedec.i  "vICMSST"      ttICMSSN201.vICMSST      "YES"  "2" "YES"}

                                                             /* FCP ST */
                                                             IF ((ttICMSSN201.vBCFCPST <> ? AND ttICMSSN201.vBCFCPST > 0)
                                                             AND (ttICMSSN201.pFCPST   <> ? AND ttICMSSN201.pFCPST   > 0)
                                                             AND (ttICMSSN201.vFCPST   <> ? AND ttICMSSN201.vFCPST   > 0)) THEN DO:
                                                                 {adapters/xml/ep2/axsep037nodedec.i  "vBCFCPST" ttICMSSN201.vBCFCPST "YES" "2" "YES"}
                                                                 {adapters/xml/ep2/axsep037nodedec.i  "pFCPST"   ttICMSSN201.pFCPST   "YES" "4" "NO "}
                                                                 {adapters/xml/ep2/axsep037nodedec.i  "vFCPST"   ttICMSSN201.vFCPST   "YES" "2" "YES"}
                                                             END.

                                                             {adapters/xml/ep2/axsep037nodedec.i  "pCredSN"      ttICMSSN201.pCredSN      "YES"  "4" "NO "}
                                                             {adapters/xml/ep2/axsep037nodedec.i  "vCredICMSSN"  ttICMSSN201.vCredICMSSN  "YES"  "2" "YES"}                                                            
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
                                                             {adapters/xml/ep2/axsep037nodechar.i "orig"         ttICMSSN202.orig         "YES"}
                                                             {adapters/xml/ep2/axsep037nodechar.i "CSOSN"        ttICMSSN202.CSOSN        "YES"}
                                                             {adapters/xml/ep2/axsep037nodechar.i "modBCST"      ttICMSSN202.modBCST      "YES"}

                                                             IF l-NT2019001 THEN DO: 
                                                                IF ttICMSSN202.modBCST = "4" THEN DO:
                                                                   {adapters/xml/ep2/axsep037nodedec.i  "pMVAST"       ttICMSSN202.pMVAST       "YES"   "4" "NO "}
                                                                 end.
                                                             END.
                                                             ELSE DO:
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pMVAST"       ttICMSSN202.pMVAST       "NO"   "4" "NO "}
                                                             END.

                                                             {adapters/xml/ep2/axsep037nodedec.i  "pRedBCST"     ttICMSSN202.pRedBCST     "NO"   "4" "NO "}
                                                             {adapters/xml/ep2/axsep037nodedec.i  "vBCST"        ttICMSSN202.vBCST        "YES"  "2" "YES"}
                                                             {adapters/xml/ep2/axsep037nodedec.i  "pICMSST"      ttICMSSN202.pICMSST      "YES"  "4" "NO "}
                                                             {adapters/xml/ep2/axsep037nodedec.i  "vICMSST"      ttICMSSN202.vICMSST      "YES"  "2" "YES"}                                                           

                                                             /* FCP ST */
                                                             IF ((ttICMSSN202.vBCFCPST <> ? AND ttICMSSN202.vBCFCPST > 0)
                                                             AND (ttICMSSN202.pFCPST   <> ? AND ttICMSSN202.pFCPST   > 0)
                                                             AND (ttICMSSN202.vFCPST   <> ? AND ttICMSSN202.vFCPST   > 0)) THEN DO:
                                                                 {adapters/xml/ep2/axsep037nodedec.i  "vBCFCPST" ttICMSSN202.vBCFCPST "YES" "2" "YES"}
                                                                 {adapters/xml/ep2/axsep037nodedec.i  "pFCPST"   ttICMSSN202.pFCPST   "YES" "4" "NO "}
                                                                 {adapters/xml/ep2/axsep037nodedec.i  "vFCPST"   ttICMSSN202.vFCPST   "YES" "2" "YES"}
                                                             END.
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
                                                             {adapters/xml/ep2/axsep037nodechar.i "orig"           ttICMSSN500.orig        "YES"}
                                                             {adapters/xml/ep2/axsep037nodechar.i "CSOSN"          ttICMSSN500.CSOSN       "YES"}

                                                             IF ((ttICMSSN500.vBCSTRet        <> ? AND ttICMSSN500.vBCSTRet        > 0)
                                                             OR  (ttICMSSN500.pST             <> ? AND ttICMSSN500.pST             > 0)
                                                             OR  (ttICMSSN500.vICMSSubstituto <> ? AND ttICMSSN500.vICMSSubstituto > 0)                                                             
                                                             OR  (ttICMSSN500.vICMSSTRet      <> ? AND ttICMSSN500.vICMSSTRet      > 0)) THEN DO:
                                                             
                                                                 {adapters/xml/ep2/axsep037nodedec.i  "vBCSTRet"        ttICMSSN500.vBCSTRet        "YES" "2" "YES"}
                                                                 {adapters/xml/ep2/axsep037nodedec.i  "pST"             ttICMSSN500.pST             "YES" "4" "NO "}
                                                                 IF l-NT2018005 THEN DO:
                                                                      {adapters/xml/ep2/axsep037nodedec.i  "vICMSSubstituto" ttICMSSN500.vICMSSubstituto "YES" "2" "YES"}                                                                
                                                                 END.
                                                                 {adapters/xml/ep2/axsep037nodedec.i  "vICMSSTRet"      ttICMSSN500.vICMSSTRet      "YES" "2" "YES"}
                                                             END.

                                                             /* FCP ST Ret */
                                                             IF ((ttICMSSN500.vBCFCPSTRet <> ? AND ttICMSSN500.vBCFCPSTRet > 0)
                                                             AND (ttICMSSN500.pFCPSTRet   <> ? AND ttICMSSN500.pFCPSTRet   > 0)
                                                             AND (ttICMSSN500.vFCPSTRet   <> ? AND ttICMSSN500.vFCPSTRet   > 0)) THEN DO:
                                                                 {adapters/xml/ep2/axsep037nodedec.i  "vBCFCPSTRet" ttICMSSN500.vBCFCPSTRet "YES" "2" "YES"}
                                                                 {adapters/xml/ep2/axsep037nodedec.i  "pFCPSTRet"   ttICMSSN500.pFCPSTRet   "YES" "4" "NO "}
                                                                 {adapters/xml/ep2/axsep037nodedec.i  "vFCPSTRet"   ttICMSSN500.vFCPSTRet   "YES" "2" "YES"}
                                                             END.

                                                             /*--- Implementaá∆o Provis¢ria para n∆o ocorrer rejeiá∆o atÇ que se saiba quais valores devem ir nestas tag's [04/07/2018] ---*/
                                                            IF  CAN-FIND (FIRST ttIde
                                                                          WHERE ttIde.indFinal = "1":U) THEN DO: /* Rejeiá∆o 906 - Se Informado CST = 60 ou CSOSN=500 e indFinal=1 (id:B25a), preenchimento obrigat¢rio dos campos do grupo opcional para informaá‰es do ICMS Efetivo (N33) Observaá∆o: Implementaá∆o opcional a critÇrio da UF. */

                                                                {adapters/xml/ep2/axsep037nodedec.i  "pRedBCEfet" 0 "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vBCEfet"    0 "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pICMSEfet"  0 "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vICMSEfet"  0 "YES" "2" "YES"}    
                                                            END.
                                                            /*---*/
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
                                                             {adapters/xml/ep2/axsep037nodechar.i "orig"         ttICMSSN900.orig         "YES"}
                                                             {adapters/xml/ep2/axsep037nodechar.i "CSOSN"        ttICMSSN900.CSOSN        "YES"}

                                                             IF  ((ttICMSSN900.modBC  <> ? AND ttICMSSN900.modBC  <> "")
                                                             AND ((ttICMSSN900.vBC    <> ? AND ttICMSSN900.vBC    <> 0 )
                                                             OR   (ttICMSSN900.pICMS  <> ? AND ttICMSSN900.pICMS  <> 0 )
                                                             OR   (ttICMSSN900.vICMS  <> ? AND ttICMSSN900.vICMS  <> 0 ))
                                                             
                                                             OR  ((ttICMSSN900.vBCFCP <> ? AND ttICMSSN900.vBCFCP > 0)
                                                             OR   (ttICMSSN900.pFCP   <> ? AND ttICMSSN900.pFCP   > 0)
                                                             OR   (ttICMSSN900.vFCP   <> ? AND ttICMSSN900.vFCP   > 0)))
                                                             THEN DO:

                                                                 {adapters/xml/ep2/axsep037nodechar.i "modBC"        ttICMSSN900.modBC        "YES"}
                                                                 {adapters/xml/ep2/axsep037nodedec.i  "vBC"          ttICMSSN900.vBC          "YES"  "2" "YES"}
                                                                 {adapters/xml/ep2/axsep037nodedec.i  "pRedBC"       ttICMSSN900.pRedBC       "NO"   "4" "NO "}
                                                                 {adapters/xml/ep2/axsep037nodedec.i  "pICMS"        ttICMSSN900.pICMS        "YES"  "4" "NO "}
                                                                 {adapters/xml/ep2/axsep037nodedec.i  "vICMS"        ttICMSSN900.vICMS        "YES"  "2" "YES"}

                                                                 /* FCP */
                                                                 IF  ((ttICMSSN900.vBCFCP <> ? AND ttICMSSN900.vBCFCP > 0)
                                                                 OR   (ttICMSSN900.pFCP   <> ? AND ttICMSSN900.pFCP   > 0)
                                                                 OR   (ttICMSSN900.vFCP   <> ? AND ttICMSSN900.vFCP   > 0)) THEN DO:
                                                                 
                                                                     {adapters/xml/ep2/axsep037nodedec.i  "vBCFCP" ttICMSSN900.vBCFCP "YES" "2" "YES"}
                                                                     {adapters/xml/ep2/axsep037nodedec.i  "pFCP"   ttICMSSN900.pFCP   "YES" "4" "NO "}
                                                                     {adapters/xml/ep2/axsep037nodedec.i  "vFCP"   ttICMSSN900.vFCP   "YES" "2" "YES"}

                                                                 END.
                                                             END.

                                                             IF  ((ttICMSSN900.modBCST  <> ? AND ttICMSSN900.modBCST  <> "")
                                                             AND ((ttICMSSN900.vBCST    <> ? AND ttICMSSN900.vBCST    <> 0 )
                                                             OR   (ttICMSSN900.pICMSST  <> ? AND ttICMSSN900.pICMSST  <> 0 )
                                                             OR   (ttICMSSN900.vICMSST  <> ? AND ttICMSSN900.vICMSST  <> 0 ))
                                                             
                                                             OR  ((ttICMSSN900.vBCFCPST <> ? AND ttICMSSN900.vBCFCPST > 0)
                                                             OR   (ttICMSSN900.pFCPST   <> ? AND ttICMSSN900.pFCPST   > 0)
                                                             OR   (ttICMSSN900.vFCPST   <> ? AND ttICMSSN900.vFCPST   > 0)))
                                                             THEN DO:

                                                                 {adapters/xml/ep2/axsep037nodechar.i "modBCST"      ttICMSSN900.modBCST      "YES"}

                                                                 IF l-NT2019001 THEN DO: 
                                                                    IF ttICMSSN900.modBCST = "4" THEN DO:
                                                                       {adapters/xml/ep2/axsep037nodedec.i  "pMVAST"       ttICMSSN900.pMVAST       "YES"   "4" "NO "}
                                                                     end.
                                                                 END.
                                                                 ELSE DO:
                                                                    {adapters/xml/ep2/axsep037nodedec.i  "pMVAST"       ttICMSSN900.pMVAST       "NO"   "4" "NO "}
                                                                 END.

                                                                 {adapters/xml/ep2/axsep037nodedec.i  "pRedBCST"     ttICMSSN900.pRedBCST     "NO"   "4" "NO "}
                                                                 {adapters/xml/ep2/axsep037nodedec.i  "vBCST"        ttICMSSN900.vBCST        "YES"  "2" "YES"}
                                                                 {adapters/xml/ep2/axsep037nodedec.i  "pICMSST"      ttICMSSN900.pICMSST      "YES"  "4" "NO "}
                                                                 {adapters/xml/ep2/axsep037nodedec.i  "vICMSST"      ttICMSSN900.vICMSST      "YES"  "2" "YES"}

                                                                 /* FCP ST */
                                                                 IF  ((ttICMSSN900.vBCFCPST <> ? AND ttICMSSN900.vBCFCPST > 0)
                                                                 OR   (ttICMSSN900.pFCPST   <> ? AND ttICMSSN900.pFCPST   > 0)
                                                                 OR   (ttICMSSN900.vFCPST   <> ? AND ttICMSSN900.vFCPST   > 0)) THEN DO:
                                                                 
                                                                     {adapters/xml/ep2/axsep037nodedec.i  "vBCFCPST" ttICMSSN900.vBCFCPST "YES" "2" "YES"}
                                                                     {adapters/xml/ep2/axsep037nodedec.i  "pFCPST"   ttICMSSN900.pFCPST   "YES" "4" "NO "}
                                                                     {adapters/xml/ep2/axsep037nodedec.i  "vFCPST"   ttICMSSN900.vFCPST   "YES" "2" "YES"}

                                                                 END.
                                                             END.

                                                             {adapters/xml/ep2/axsep037nodedec.i  "pCredSN"      ttICMSSN900.pCredSN      "YES"  "4" "NO "}
                                                             {adapters/xml/ep2/axsep037nodedec.i  "vCredICMSSN"  ttICMSSN900.vCredICMSSN  "YES"  "2" "YES"}
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

                                                  //Gera se n∆o Ç nota de dÇbito ou se Ç nota de dÇbito que tenha valor base e valor IPI > 0
                                                  IF NOT l-notaDebPagAntecip
                                                  OR (l-notaDebPagAntecip AND ttIPI.vBC > 0 AND ttIPI.vIPI > 0) THEN DO:
                                                      
                                                      RUN addNode IN hGenXml (getStack(), "IPI", "", OUTPUT iId).
                                                      addStack(iId).

                                                           {adapters/xml/ep2/axsep037nodechar.i "clEnq"    ttIPI.clEnq    "NO" }
                                                           {adapters/xml/ep2/axsep037nodechar.i "CNPJProd" ttIPI.CNPJProd "NO" }
                                                           {adapters/xml/ep2/axsep037nodechar.i "cSelo"    ttIPI.cSelo    "NO" }
                                                           {adapters/xml/ep2/axsep037nodechar.i "qSelo"    ttIPI.qSelo    "NO" }
                                                           {adapters/xml/ep2/axsep037nodechar.i "cEnq"     ttIPI.cEnq     "YES"}

                                                           IF  NOT ttIPI.l-ipi-trib THEN DO:

                                                               RUN addNode IN hGenXml (getStack(), "IPINT", "", OUTPUT iId).
                                                               addStack(iId).
        
                                                                    {adapters/xml/ep2/axsep037nodechar.i "CST"   ttIPI.CSTIPINT "YES"}
                                                               delStack().
                                                           
                                                           END.
                                                           ELSE DO:
                                                           
                                                               RUN addNode IN hGenXml (getStack(), "IPITrib",  "",             OUTPUT iId).
                                                               addStack(iId).
        
                                                                    {adapters/xml/ep2/axsep037nodechar.i "CST"   ttIPI.CSTIPITrib "YES"}
                                                                    
                                                                    IF  ttIPI.qUnid > 0 AND 
                                                                        ttIPI.vUnid > 0 THEN DO: /* IPI Unidade */
                                                                        {adapters/xml/ep2/axsep037nodedec.i  "qUnid" ttIPI.qUnid      "YES" "4" "YES"}
                                                                        {adapters/xml/ep2/axsep037nodedec.i  "vUnid" ttIPI.vUnid      "YES" "4" "YES"}
                                                                    END.
                                                                    ELSE DO: 
                                                                        {adapters/xml/ep2/axsep037nodedec.i  "vBC"   ttIPI.vBC        "YES" "2" "YES"}
                                                                        {adapters/xml/ep2/axsep037nodedec.i  "pIPI"  ttIPI.pIPI       "YES" "4" "NO "}
                                                                    END.

                                                                    {adapters/xml/ep2/axsep037nodedec.i  "vIPI"  ttIPI.vIPI       "YES" "2" "YES"}
                                                               delStack().

                                                           END.

                                                      delStack().
                                                  END.

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

                                                       {adapters/xml/ep2/axsep037nodedec.i "vBC"      ttII.vBC      "YES" "2" "YES"}
                                                       {adapters/xml/ep2/axsep037nodedec.i "vDespAdu" ttII.vDespAdu "YES" "2" "YES"}
                                                       {adapters/xml/ep2/axsep037nodedec.i "vII"      ttII.vII      "YES" "2" "YES"}
                                                       {adapters/xml/ep2/axsep037nodedec.i "vIOF"     ttII.vIOF     "YES" "2" "YES"}
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
    
                                                                {adapters/xml/ep2/axsep037nodechar.i "CST"  ttPISAliq.CST  "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vBC"  ttPISAliq.vBC  "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pPIS" ttPISAliq.pPIS "YES" "4" "NO "}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vPIS" ttPISAliq.vPIS "YES" "2" "YES"}
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
    
                                                                {adapters/xml/ep2/axsep037nodechar.i "CST"       ttPISQtde.CST       "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "qBCProd"   ttPISQtde.qBCProd   "YES" "4" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vAliqProd" ttPISQtde.vAliqProd "YES" "4" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vPIS"      ttPISQtde.vPIS      "YES" "2" "YES"}
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
    
                                                                {adapters/xml/ep2/axsep037nodechar.i "CST" ttPISNT.CST "YES"}
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
    
                                                                {adapters/xml/ep2/axsep037nodechar.i "CST"       ttPISOutr.CST "YES"}
    
                                                                IF  ttPISOutr.vAliqProd <> 0
                                                                AND ttPISOutr.vAliqProd <> ? THEN DO:
                                                                    {adapters/xml/ep2/axsep037nodedec.i "qBCProd"   ttPISOutr.qBCProd   "YES" "4" "YES"}
                                                                    {adapters/xml/ep2/axsep037nodedec.i "vAliqProd" ttPISOutr.vAliqProd "YES" "4" "YES"}
                                                                END.
                                                                ELSE DO:
                                                                    {adapters/xml/ep2/axsep037nodedec.i "vBC"       ttPISOutr.vBC  "YES" "2" "YES"}
                                                                    {adapters/xml/ep2/axsep037nodedec.i "pPIS"      ttPISOutr.pPIS "YES" "4" "NO "}
                                                                END.
    
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vPIS"      ttPISOutr.vPIS "YES" "2" "YES"}
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

                                                           {adapters/xml/ep2/axsep037nodedec.i "qBCProd"   ttPISST.qBCProd   "YES" "4" "YES"}
                                                           {adapters/xml/ep2/axsep037nodedec.i "vAliqProd" ttPISST.vAliqProd "YES" "4" "YES"}
                                                       END.
                                                       ELSE DO:
                                                           {adapters/xml/ep2/axsep037nodedec.i "vBC"       ttPISST.vBC       "YES" "2" "YES"}
                                                           {adapters/xml/ep2/axsep037nodedec.i "pPIS"      ttPISST.pPIS      "YES" "4" "NO "}
                                                       END.

                                                       {adapters/xml/ep2/axsep037nodedec.i "vPIS"      ttPISST.vPIS      "YES" "2" "YES"}

                                                       IF  l-nt2020005
                                                       AND ttPISST.indSomaPISST <> ? THEN
                                                           {adapters/xml/ep2/axsep037nodechar.i "indSomaPISST" ttPISST.indSomaPISST "NO" }
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
    
                                                                {adapters/xml/ep2/axsep037nodechar.i "CST"     ttCOFINSAliq.CST     "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vBC"     ttCOFINSAliq.vBC     "YES" "2" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "pCOFINS" ttCOFINSAliq.pCOFINS "YES" "4" "NO "}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vCOFINS" ttCOFINSAliq.vCOFINS "YES" "2" "YES"}
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
    
                                                                {adapters/xml/ep2/axsep037nodechar.i "CST"       ttCOFINSQtde.CST       "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "qBCProd"   ttCOFINSQtde.qBCProd   "YES" "4" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vAliqProd" ttCOFINSQtde.vAliqProd "YES" "4" "YES"}
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vCOFINS"   ttCOFINSQtde.vCOFINS   "YES" "2" "YES"}
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
    
                                                                {adapters/xml/ep2/axsep037nodechar.i "CST" ttCOFINSNT.CST "YES"}
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
    
                                                                {adapters/xml/ep2/axsep037nodechar.i "CST"       ttCOFINSOutr.CST "YES"}
    
                                                                IF  ttCOFINSOutr.vAliqProd <> 0
                                                                AND ttCOFINSOutr.vAliqProd <> ? THEN DO:
                                                                    {adapters/xml/ep2/axsep037nodedec.i "qBCProd"   ttCOFINSOutr.qBCProd   "YES" "4" "YES"}
                                                                    {adapters/xml/ep2/axsep037nodedec.i "vAliqProd" ttCOFINSOutr.vAliqProd "YES" "4" "YES"}
                                                                END.
                                                                ELSE DO:
                                                                    {adapters/xml/ep2/axsep037nodedec.i "vBC"       ttCOFINSOutr.vBC     "YES" "2" "YES"}
                                                                    {adapters/xml/ep2/axsep037nodedec.i "pCOFINS"   ttCOFINSOutr.pCOFINS "YES" "4" "NO "}
                                                                END.
                                                                
                                                                {adapters/xml/ep2/axsep037nodedec.i  "vCOFINS"   ttCOFINSOutr.vCOFINS "YES" "2" "YES"}
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
                                                           {adapters/xml/ep2/axsep037nodedec.i "qBCProd"   ttCOFINSST.qBCProd   "YES" "4" "YES"}
                                                           {adapters/xml/ep2/axsep037nodedec.i "vAliqProd" ttCOFINSST.vAliqProd "YES" "4" "YES"}
                                                       END.
                                                       ELSE DO:
                                                           {adapters/xml/ep2/axsep037nodedec.i "vBC"       ttCOFINSST.vBC       "YES" "2" "YES"}
                                                           {adapters/xml/ep2/axsep037nodedec.i "pCOFINS"   ttCOFINSST.pCOFINS   "YES" "4" "NO "}
                                                       END.

                                                       {adapters/xml/ep2/axsep037nodedec.i "vCOFINS"   ttCOFINSST.vCOFINS   "YES" "2" "YES"}
                                                       IF  l-nt2020005
                                                       AND ttCOFINSST.indSomaCOFINSST <> ? THEN
                                                           {adapters/xml/ep2/axsep037nodechar.i "indSomaCOFINSST" ttCOFINSST.indSomaCOFINSST "NO" }
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

                                                       {adapters/xml/ep2/axsep037nodedec.i "vBCUFDest"      ttICMSUFDest.vBCUFDest      "YES" "2" "YES"}
                                                       {adapters/xml/ep2/axsep037nodedec.i "vBCFCPUFDest"   ttICMSUFDest.vBCFCPUFDest   "NO"  "2" "YES"}
                                                       {adapters/xml/ep2/axsep037nodedec.i "pFCPUFDest"     ttICMSUFDest.pFCPUFDest     "NO"  "4" "YES"}
                                                       {adapters/xml/ep2/axsep037nodedec.i "pICMSUFDest"    ttICMSUFDest.pICMSUFDest    "YES" "4" "YES"}
                                                       {adapters/xml/ep2/axsep037nodedec.i "pICMSInter"     ttICMSUFDest.pICMSInter     "YES" "4" "NO" }
                                                       {adapters/xml/ep2/axsep037nodedec.i "pICMSInterPart" ttICMSUFDest.pICMSInterPart "YES" "4" "YES"}
                                                       {adapters/xml/ep2/axsep037nodedec.i "vFCPUFDest"     ttICMSUFDest.vFCPUFDest     "NO"  "2" "YES"}
                                                       {adapters/xml/ep2/axsep037nodedec.i "vICMSUFDest"    ttICMSUFDest.vICMSUFDest    "YES" "2" "YES"}
                                                       {adapters/xml/ep2/axsep037nodedec.i "vICMSUFRemet"   ttICMSUFDest.vICMSUFRemet   "YES" "2" "YES"}

                                                  delStack().
                                             END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-IBSCBS:
                                          
    DEFINE INPUT PARAM pTipTributo AS INTEGER NO-UNDO.

    FOR FIRST ttIBSCBS
        WHERE ttIBSCBS.CodEstabelNF = ttDet.CodEstabelNF
          AND ttIBSCBS.SerieNF      = ttDet.SerieNF     
          AND ttIBSCBS.NrNotaFisNF  = ttDet.NrNotaFisNF 
          AND ttIBSCBS.NrSeqFatNF   = ttDet.NrSeqFatNF
          AND ttIBSCBS.ItCodigoNF   = ttDet.ItCodigoNF
          AND ttIBSCBS.TipTributo   < 4 /** Nesse grupo n∆o imprime IS, porque a vigància ser† a partri de 2027 **/
          AND ttIBSCBS.CST          <> "": 
                                                    
        FOR FIRST ttTribRT
            WHERE ttTribRT.CodEstabelNF = ttDet.CodEstabelNF
              AND ttTribRT.SerieNF      = ttDet.SerieNF     
              AND ttTribRT.NrNotaFisNF  = ttDet.NrNotaFisNF 
              AND ttTribRT.NrSeqFatNF   = ttDet.NrSeqFatNF
              AND ttTribRT.ItCodigoNF   = ttDet.ItCodigoNF
              AND ttTribRT.TipTributo   = pTipTributo: /*IBS UF */

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
                  IF ttTribRT.pRedAliq > 0 THEN ASSIGN d-perc-red-aliq = ttTribRT.pRedAliq.  
               END.
               WHEN 3 THEN {adapters/xml/ep2/axsep037nodedec.i  "pIBSMun"  ttTribRT.pAliq  "YES" "4" "YES"}
            END CASE.
                                                                     
            IF ttTribRT.pDif > 0 OR (pTipTributo = 3 /*IBSMun*/ AND ttTribRT.pDif = 0 AND (ttIBSCBS.CST = "510" OR ttIBSCBS.CST = "515")) THEN DO:
           
               RUN addNode IN hGenXml (getStack(), "gDif", "", OUTPUT iId).
               addStack(iId).

                    {adapters/xml/ep2/axsep037nodedec.i "pDif"  ttTribRT.pDif "YES" "4" "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i "vDif"  ttTribRT.vDif "YES" "2" "YES"}
                                                                     
               delStack().
            END.
                                                                         
            IF ttTribRT.vDevTrib > 0 THEN DO:
           
               RUN addNode IN hGenXml (getStack(), "gDevTrib", "", OUTPUT iId).
               addStack(iId).
                    {adapters/xml/ep2/axsep037nodedec.i "pDevTrib"  ttTribRT.pDevTrib "YES" "4" "NO" }
                    {adapters/xml/ep2/axsep037nodedec.i "vDevTrib"  ttTribRT.vDevTrib "YES"  "2" "YES"}

               delStack().
            END.

            IF ttTribRT.pRedAliq > 0 OR (pTipTributo = 3 AND ttTribRT.pRedAliq = 0 AND (ttIBSCBS.CST = "200" OR ttIBSCBS.CST = "515"))
            OR CAN-FIND(FIRST ttgCompraGov WHERE ttgCompraGov.CodEstabelNF = ttDet.CodEstabelNF
                                             AND ttgCompraGov.SerieNF      = ttDet.SerieNF
                                             AND ttgCompraGov.NrNotaFisNF  = ttDet.NrNotaFisNF) THEN DO:
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
                    // Grupo gALCZFMCBS Ç somente para CBS
                    FOR FIRST ttgALCZFMCBS
                        WHERE ttgALCZFMCBS.CodEstabelNF = ttDet.CodEstabelNF
                          AND ttgALCZFMCBS.SerieNF      = ttDet.SerieNF     
                          AND ttgALCZFMCBS.NrNotaFisNF  = ttDet.NrNotaFisNF 
                          AND ttgALCZFMCBS.ItCodigoNF   = ttDet.ItCodigoNF
                          AND ttgALCZFMCBS.NrSeqFatNF   = ttDet.NrSeqFatNF:
                    
                        RUN addNode IN hGenXml (getStack(), "gALCZFMCBS", "", OUTPUT iId).
                        addStack(iId).
                             {adapters/xml/ep2/axsep037nodechar.i "tpALCZFMCBS"     ttgALCZFMCBS.tpALCZFMCBS     "YES"          }
                             {adapters/xml/ep2/axsep037nodechar.i "nProcSuframa"    ttgALCZFMCBS.nProcSuframa    "NO"           }
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

PROCEDURE pi-imprime-gTransfCred:
     
    FOR FIRST ttgTransfCred 
        WHERE ttgTransfCred.CodEstabelNF = ttDet.CodEstabelNF
          AND ttgTransfCred.SerieNF      = ttDet.SerieNF
          AND ttgTransfCred.NrNotaFisNF  = ttDet.NrNotaFisNF
          AND ttgTransfCred.ItCodigoNF   = ttDet.ItCodigoNF
          AND ttgTransfCred.NrSeqFatNF   = ttDet.NrSeqFatNF:
                                                                                 
          RUN addNode IN hGenXml (getStack(), "gTransfCred", "", OUTPUT iId).
          
          addStack(iId).
                                   
               {adapters/xml/ep2/axsep037nodedec.i  "vIBS"   ttgTransfCred.vIBS   "YES" "2" "YES"}
               {adapters/xml/ep2/axsep037nodedec.i  "vCBS"   ttgTransfCred.vCBS   "YES" "2" "YES"}
                                   
          delStack().
    END.
   
    RETURN "OK":U.
   
END PROCEDURE. 

PROCEDURE pi-imprime-ttgAjusteCompet:
     
    FOR FIRST ttgAjusteCompet 
        WHERE ttgAjusteCompet.CodEstabelNF  = ttDet.CodEstabelNF
        AND   ttgAjusteCompet.SerieNF       = ttDet.SerieNF
        AND   ttgAjusteCompet.NrNotaFisNF   = ttDet.NrNotaFisNF
        AND   ttgAjusteCompet.ItCodigoNF    = ttDet.ItCodigoNF
        AND   ttgAjusteCompet.NrSeqFatNF    = ttDet.NrSeqFatNF:

        RUN addNode IN hGenXml (getStack(), "gAjusteCompet", "", OUTPUT iId).
        addStack(iId).
            {adapters/xml/ep2/axsep037nodechar.i "competApur" ttgAjusteCompet.competApur  "YES"         }
            {adapters/xml/ep2/axsep037nodedec.i  "vIBS"       ttgAjusteCompet.vIBS        "YES" "2" "YES"}
            {adapters/xml/ep2/axsep037nodedec.i  "vCBS"       ttgAjusteCompet.vCBS        "YES" "2" "YES"}
        delStack().
    END.
   
    RETURN "OK":U.
   
END PROCEDURE. 

PROCEDURE pi-imprime-ttgEstornoCred:

    FOR  FIRST ttgEstornoCred 
         WHERE ttgEstornoCred.CodEstabelNF  = ttDet.CodEstabelNF
         AND   ttgEstornoCred.SerieNF       = ttDet.SerieNF
         AND   ttgEstornoCred.NrNotaFisNF   = ttDet.NrNotaFisNF
         AND   ttgEstornoCred.ItCodigoNF    = ttDet.ItCodigoNF
         AND   ttgEstornoCred.NrSeqFatNF    = ttDet.NrSeqFatNF:

         RUN addNode IN hGenXml (getStack(), "gEstornoCred", "", OUTPUT iId).
         addStack(iId).                                                             
             {adapters/xml/ep2/axsep037nodedec.i  "vIBSEstCred"       ttgEstornoCred.vIBSEstCred        "YES" "2" "YES"}
             {adapters/xml/ep2/axsep037nodedec.i  "vCBSEstCred"       ttgEstornoCred.vCBSEstCred        "YES" "2" "YES"}
         delStack().
    END.
    
    RETURN "OK":U.
    
END PROCEDURE.

PROCEDURE pi-imprime-gIBSCBSMono:
    
    DEFINE VARIABLE iAnoEmi AS INTEGER NO-UNDO.
    
    /* Extrai o ano da data de emiss∆o. 
       Assumindo que ttIde.dhEmi seja um campo caractere no formato AAAA-MM-DD... */
    ASSIGN iAnoEmi = INTEGER(SUBSTRING(ttIde.dhEmi, 1, 4)).
                        
    FOR FIRST ttgIBSCBSMono 
        WHERE ttgIBSCBSMono.CodEstabelNF  = ttDet.CodEstabelNF
          AND ttgIBSCBSMono.SerieNF       = ttDet.SerieNF
          AND ttgIBSCBSMono.NrNotaFisNF   = ttDet.NrNotaFisNF
          AND ttgIBSCBSMono.ItCodigoNF    = ttDet.ItCodigoNF
          AND ttgIBSCBSMono.NrSeqFatNF    = ttDet.NrSeqFatNF:
        
        IF l-mono-rt THEN DO:    
            RUN addNode IN hGenXml (getStack(), "gIBSCBSMono", "", OUTPUT iId).
            addStack(iId).

            /* ====================================================================
               IBS MONOFµSICO AD REM (gIBSMonoAdRem) ok
               Vigància: Apenas a partir de 2029
               ==================================================================== */
            IF iAnoEmi >= 2029 AND 
               (  ttgIBSCBSMono.vIBSMono      > 0 
               OR ttgIBSCBSMono.vIBSMonoReten > 0 
               OR ttgIBSCBSMono.vIBSMonoRet   > 0
               OR ttgIBSCBSMono.vIBSDiferenca > 0) THEN DO:
            
                RUN addNode IN hGenXml (getStack(), "gIBSMonoAdRem", "", OUTPUT iId).
                addStack(iId).

                IF ttgIBSCBSMono.vIBSMono > 0 THEN DO:
                    RUN addNode IN hGenXml (getStack(), "gMonoPadrao", "", OUTPUT iId).
                    addStack(iId).
                    {adapters/xml/ep2/axsep037nodedec.i "qBCMono"  ttgIBSCBSMono.qBCMono  "YES" "4" "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i "adRemIBS" ttgIBSCBSMono.adRemIBS "YES" "4" "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i "vIBSMono" ttgIBSCBSMono.vIBSMono "YES" "2" "YES"}
                    delStack().
                END.
                
                IF ttgIBSCBSMono.vIBSMonoReten > 0 THEN DO:
                    RUN addNode IN hGenXml (getStack(), "gMonoReten", "", OUTPUT iId).
                    addStack(iId).
                    {adapters/xml/ep2/axsep037nodedec.i "qBCMonoReten"  ttgIBSCBSMono.qBCMonoReten  "YES" "4" "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i "adRemIBSReten" ttgIBSCBSMono.adRemIBSReten "YES" "4" "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i "vIBSMonoReten" ttgIBSCBSMono.vIBSMonoReten "YES" "2" "YES"}
                    delStack().
                END.
                
                IF ttgIBSCBSMono.vIBSMonoRet > 0 THEN DO:
                    RUN addNode IN hGenXml (getStack(), "gMonoRet", "", OUTPUT iId).
                    addStack(iId).
                    {adapters/xml/ep2/axsep037nodedec.i "vIBSMonoRet" ttgIBSCBSMono.vIBSMonoRet "YES" "2" "YES"}
                    delStack().
                END.
                
                IF ttgIBSCBSMono.vIBSDiferenca > 0 THEN DO:
                    RUN addNode IN hGenXml (getStack(), "gpBioDiferenca", "", OUTPUT iId).
                    addStack(iId).
                    {adapters/xml/ep2/axsep037nodedec.i "qBCBioComb"    ttgIBSCBSMono.qBCBioComb    "YES" "4" "YES"} 
                    {adapters/xml/ep2/axsep037nodedec.i "vIBSDiferenca" ttgIBSCBSMono.vIBSDiferenca "YES" "2" "YES"}
                    delStack().
                END.
                
                delStack().
            END.
                
            /* ====================================================================
               IBS MONOFµSICO AD VALOREM (gIBSMonoAdValorem) ok
               Vigància: De 2026 atÇ 2028
               ==================================================================== */
            ELSE IF (iAnoEmi >= 2026 AND iAnoEmi <= 2028) AND 
                    (   ttgIBSCBSMono.vIBSMono      > 0 
                     OR ttgIBSCBSMono.vIBSMonoReten > 0 
                     OR ttgIBSCBSMono.vIBSMonoRet   > 0
                     OR ttgIBSCBSMono.vIBSDiferenca > 0) THEN DO:
                    
                RUN addNode IN hGenXml (getStack(), "gIBSMonoAdValorem", "", OUTPUT iId).
                addStack(iId).
                    
                IF ttgIBSCBSMono.vIBSMono > 0 THEN DO:
                    RUN addNode IN hGenXml (getStack(), "gMonoPadrao", "", OUTPUT iId).
                    addStack(iId).
                    {adapters/xml/ep2/axsep037nodedec.i "vBCMono"      ttgIBSCBSMono.vBCMono       "YES" "2" "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i "pAliqMonoUF"  ttgIBSCBSMono.pAliqMonoUF   "YES" "4" "YES"} 
                    {adapters/xml/ep2/axsep037nodedec.i "vIBSMonoUF"   ttgIBSCBSMono.vIBSMonoUF    "YES" "2" "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i "pAliqMonoMun" ttgIBSCBSMono.pAliqMonoMun  "YES" "4" "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i "vIBSMonoMun"  ttgIBSCBSMono.vIBSMonoMun   "YES" "2" "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i "vIBSMono"     ttgIBSCBSMono.vIBSMonoUFMun "YES" "2" "YES"}
                    delStack().
                END.
                
                IF ttgIBSCBSMono.vIBSMonoReten > 0 THEN DO:
                    RUN addNode IN hGenXml (getStack(), "gMonoReten", "", OUTPUT iId).
                    addStack(iId).
                    {adapters/xml/ep2/axsep037nodedec.i "vBCMonoReten"   ttgIBSCBSMono.vBCMonoReten      "YES" "2" "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i "pAliqMonoReten" ttgIBSCBSMono.pAliqMonoRetenIBS "YES" "4" "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i "vIBSMonoReten"  ttgIBSCBSMono.vIBSMonoReten     "YES" "2" "YES"}
                    delStack().
                END.
                
                IF ttgIBSCBSMono.vIBSMonoRet > 0 THEN DO:
                    RUN addNode IN hGenXml (getStack(), "gMonoRet", "", OUTPUT iId).
                    addStack(iId).
                    {adapters/xml/ep2/axsep037nodedec.i "vIBSMonoRet" ttgIBSCBSMono.vIBSMonoRet "YES" "2" "YES"}
                    delStack().
                END.
                
                IF ttgIBSCBSMono.vIBSDiferenca > 0 THEN DO:
                    RUN addNode IN hGenXml (getStack(), "gpBioDiferenca", "", OUTPUT iId).
                    addStack(iId).
                    {adapters/xml/ep2/axsep037nodedec.i "qBCBioComb"    ttgIBSCBSMono.qBCBioComb    "YES" "4" "YES"} 
                    {adapters/xml/ep2/axsep037nodedec.i "vIBSDiferenca" ttgIBSCBSMono.vIBSDiferenca "YES" "2" "YES"}
                    delStack().
                END.
                
                delStack().
            END.
                
            /* ====================================================================
               CBS MONOFµSICA AD REM (gCBSMonoAdRem)ok
               Vigància: A partir de 2027
               ==================================================================== */
            IF iAnoEmi >= 2027 AND 
               (  ttgIBSCBSMono.vCBSMono      > 0 
               OR ttgIBSCBSMono.vCBSMonoReten > 0 
               OR ttgIBSCBSMono.vCBSMonoRet   > 0
               OR ttgIBSCBSMono.vCBSDiferenca > 0 ) THEN DO:
            
                RUN addNode IN hGenXml (getStack(), "gCBSMonoAdRem", "", OUTPUT iId).
                addStack(iId).

                IF ttgIBSCBSMono.vCBSMono > 0 THEN DO:
                    RUN addNode IN hGenXml (getStack(), "gMonoPadrao", "", OUTPUT iId).
                    addStack(iId).
                    {adapters/xml/ep2/axsep037nodedec.i "qBCMono"  ttgIBSCBSMono.qBCMono  "YES" "4" "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i "adRemCBS" ttgIBSCBSMono.adRemCBS "YES" "4" "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i "vCBSMono" ttgIBSCBSMono.vCBSMono "YES" "2" "YES"}
                    delStack().
                END.
                
                IF ttgIBSCBSMono.vCBSMonoReten > 0 THEN DO:
                    RUN addNode IN hGenXml (getStack(), "gMonoReten", "", OUTPUT iId).
                    addStack(iId).
                    {adapters/xml/ep2/axsep037nodedec.i "qBCMonoReten"  ttgIBSCBSMono.qBCMonoReten  "YES" "4" "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i "adRemCBSReten" ttgIBSCBSMono.adRemCBSReten "YES" "4" "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i "vCBSMonoReten" ttgIBSCBSMono.vCBSMonoReten "YES" "2" "YES"}
                    delStack().
                END.
                
                IF ttgIBSCBSMono.vCBSMonoRet > 0 THEN DO:
                    RUN addNode IN hGenXml (getStack(), "gMonoRet", "", OUTPUT iId).
                    addStack(iId).
                    {adapters/xml/ep2/axsep037nodedec.i "vCBSMonoRet" ttgIBSCBSMono.vCBSMonoRet "YES" "2" "YES"}
                    delStack().
                END.
                
                IF ttgIBSCBSMono.vCBSDiferenca > 0 THEN DO:
                    RUN addNode IN hGenXml (getStack(), "gpBioDiferenca", "", OUTPUT iId).
                    addStack(iId).
                    {adapters/xml/ep2/axsep037nodedec.i "qBCBioComb"    ttgIBSCBSMono.qBCBioComb    "YES" "4" "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i "vCBSDiferenca" ttgIBSCBSMono.vCBSDiferenca "YES" "2" "YES"}
                    delStack().
                END.
                
                delStack().
            END.

            /* ====================================================================
               CBS MONOFµSICA AD VALOREM (gCBSMonoAdValorem)ok
               Vigància: Somente em 2026
               ==================================================================== */
            ELSE IF iAnoEmi = 2026 AND 
                    (  ttgIBSCBSMono.vCBSMono      > 0 
                    OR ttgIBSCBSMono.vCBSMonoReten > 0
                    OR ttgIBSCBSMono.vCBSMonoRet   > 0
                    OR ttgIBSCBSMono.vCBSDiferenca > 0) THEN DO:
                    
                RUN addNode IN hGenXml (getStack(), "gCBSMonoAdValorem", "", OUTPUT iId).
                addStack(iId).
                    
                IF ttgIBSCBSMono.vCBSMono > 0 THEN DO:
                    RUN addNode IN hGenXml (getStack(), "gMonoPadrao", "", OUTPUT iId).
                    addStack(iId).
                    {adapters/xml/ep2/axsep037nodedec.i "vBCMono"      ttgIBSCBSMono.vBCMono      "YES" "2" "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i "pAliqMonoCBS" ttgIBSCBSMono.pAliqMonoCBS "YES" "4" "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i "vCBSMono"     ttgIBSCBSMono.vCBSMono     "YES" "2" "YES"}
                    delStack().
                END.
                
                IF ttgIBSCBSMono.vCBSMonoReten > 0 THEN DO:
                    RUN addNode IN hGenXml (getStack(), "gMonoReten", "", OUTPUT iId).
                    addStack(iId).
                    {adapters/xml/ep2/axsep037nodedec.i "vBCMonoReten"   ttgIBSCBSMono.vBCMonoReten      "YES" "2" "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i "pAliqMonoReten" ttgIBSCBSMono.pAliqMonoRetenCBS "YES" "4" "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i "vCBSMonoReten"  ttgIBSCBSMono.vCBSMonoReten     "YES" "2" "YES"}
                    delStack().
                END.
                
                IF ttgIBSCBSMono.vCBSMonoRet > 0 THEN DO:
                    RUN addNode IN hGenXml (getStack(), "gMonoRet", "", OUTPUT iId).
                    addStack(iId).
                    {adapters/xml/ep2/axsep037nodedec.i "vCBSMonoRet" ttgIBSCBSMono.vCBSMonoRet "YES" "2" "YES"}
                    delStack().
                END.
                
                IF ttgIBSCBSMono.vCBSDiferenca > 0 THEN DO:
                    RUN addNode IN hGenXml (getStack(), "gpBioDiferenca", "", OUTPUT iId).
                    addStack(iId).
                    {adapters/xml/ep2/axsep037nodedec.i "qBCBioComb"    ttgIBSCBSMono.qBCBioComb    "YES" "4" "YES"}
                    {adapters/xml/ep2/axsep037nodedec.i "vCBSDiferenca" ttgIBSCBSMono.vCBSDiferenca "YES" "2" "YES"}
                    delStack().
                END.
                
                delStack().
            END.

            /* ====================================================================
               TOTAIS DO ITEM MONOFµSICO
               ==================================================================== */
            {adapters/xml/ep2/axsep037nodedec.i "vTotIBSMonoItem" ttgIBSCBSMono.vTotIBSMonoItem "YES" "2" "YES"}
            {adapters/xml/ep2/axsep037nodedec.i "vTotCBSMonoItem" ttgIBSCBSMono.vTotCBSMonoItem "YES" "2" "YES"}
                
            delStack(). /* Fecha gIBSCBSMono */
        END. //fim l-mono-rt
        ELSE DO:
            RUN addNode IN hGenXml (getStack(), "gIBSCBSMono", "", OUTPUT iId).
            addStack(iId).

                 RUN addNode IN hGenXml (getStack(), "gMonoPadrao", "", OUTPUT iId).
                 addStack(iId).
                      {adapters/xml/ep2/axsep037nodedec.i "qBCMono"          ttgIBSCBSMono.qBCMono          "YES" "4" "YES"}
                      {adapters/xml/ep2/axsep037nodedec.i "adRemIBS"         ttgIBSCBSMono.adRemIBS         "YES" "4" "YES"}
                      {adapters/xml/ep2/axsep037nodedec.i "adRemCBS"         ttgIBSCBSMono.adRemCBS         "YES" "4" "YES"}
                      {adapters/xml/ep2/axsep037nodedec.i "vIBSMono"         ttgIBSCBSMono.vIBSMono         "YES" "2" "YES"}
                      {adapters/xml/ep2/axsep037nodedec.i "vCBSMono"         ttgIBSCBSMono.vCBSMono         "YES" "2" "YES"}
                 delStack().

                 IF ttgIBSCBSMono.vIBSMonoReten > 0 OR vCBSMonoReten > 0 THEN DO:
                    RUN addNode IN hGenXml (getStack(), "gMonoReten", "", OUTPUT iId).
                    addStack(iId).
                         {adapters/xml/ep2/axsep037nodedec.i "qBCMonoReten"     ttgIBSCBSMono.qBCMonoReten     "YES"  "4" "YES"}
                         {adapters/xml/ep2/axsep037nodedec.i "adRemIBSReten"    ttgIBSCBSMono.adRemIBSReten    "YES"  "4" "YES"}
                         {adapters/xml/ep2/axsep037nodedec.i "vIBSMonoReten"    ttgIBSCBSMono.vIBSMonoReten    "YES"  "2" "YES"}
                         {adapters/xml/ep2/axsep037nodedec.i "adRemCBSReten"    ttgIBSCBSMono.adRemCBSReten    "YES"  "4" "YES"}
                         {adapters/xml/ep2/axsep037nodedec.i "vCBSMonoReten"    ttgIBSCBSMono.vCBSMonoReten    "YES"  "2" "YES"}
                    delStack().
                 END.

                 IF ttgIBSCBSMono.vIBSMonoRet > 0 OR vCBSMonoRet > 0 THEN DO:
                    RUN addNode IN hGenXml (getStack(), "gMonoRet", "", OUTPUT iId).
                    addStack(iId).
                         {adapters/xml/ep2/axsep037nodedec.i "qBCMonoRet"       ttgIBSCBSMono.qBCMonoRet       "YES"  "4" "YES"}
                         {adapters/xml/ep2/axsep037nodedec.i "adRemIBSRet"      ttgIBSCBSMono.adRemIBSRet      "YES"  "4" "YES"}
                         {adapters/xml/ep2/axsep037nodedec.i "vIBSMonoRet"      ttgIBSCBSMono.vIBSMonoRet      "YES"  "2" "YES"}
                         {adapters/xml/ep2/axsep037nodedec.i "adRemCBSRet"      ttgIBSCBSMono.adRemCBSRet      "YES"  "4" "YES"}
                         {adapters/xml/ep2/axsep037nodedec.i "vCBSMonoRet"      ttgIBSCBSMono.vCBSMonoRet      "YES"  "2" "YES"}
                    delStack().
                 END.

                 IF ttgIBSCBSMono.vIBSMonoDif > 0 OR ttgIBSCBSMono.vCBSMonoDif > 0 THEN DO:
                    RUN addNode IN hGenXml (getStack(), "gMonoDif", "", OUTPUT iId).
                    addStack(iId).
                        {adapters/xml/ep2/axsep037nodedec.i "pDifIBS"          ttgIBSCBSMono.pDifIBS          "YES"  "4" "YES"}
                        {adapters/xml/ep2/axsep037nodedec.i "vIBSMonoDif"      ttgIBSCBSMono.vIBSMonoDif      "YES"  "2" "YES"}
                        {adapters/xml/ep2/axsep037nodedec.i "pDifCBS"          ttgIBSCBSMono.pDifCBS          "YES"  "4" "YES"}
                        {adapters/xml/ep2/axsep037nodedec.i "vCBSMonoDif"      ttgIBSCBSMono.vCBSMonoDif      "YES"  "2" "YES"}
                    delStack().
                 END.

                 {adapters/xml/ep2/axsep037nodedec.i "vTotIBSMonoItem"  ttgIBSCBSMono.vTotIBSMonoItem  "YES" "2" "YES"}
                 {adapters/xml/ep2/axsep037nodedec.i "vTotCBSMonoItem"  ttgIBSCBSMono.vTotCBSMonoItem  "YES" "2" "YES"}

            delStack().            
        END.

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
                                            
                                                       {adapters/xml/ep2/axsep037nodedec.i "pDevol"   ttImpostoDevol.pDevol   "YES" "2" "YES"}

                                                       RUN addNode IN hGenXml (getStack(), "IPI", "", OUTPUT iId).
                                                       addStack(iId).

                                                           {adapters/xml/ep2/axsep037nodedec.i "vIPIDevol" ttImpostoDevol.vIPIDevol "YES" "2" "YES"}

                                                       delStack().
                                                       
                                                  delStack().
                                             END.


    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-imprime-obs-item:
    
    RUN addNode IN hGenXml (getStack(), "obsItem", "", OUTPUT iId).       
    addStack(iId).
        
        FOR FIRST ttDetObsCont
            WHERE ttDetObsCont.CodEstabelNF         = ttDet.CodEstabelNF 
              AND ttDetObsCont.SerieNF              = ttDet.SerieNF      
              AND ttDetObsCont.NrNotaFisNF          = ttDet.NrNotaFisNF
              AND ttDetObsCont.NrSeqFatNF           = ttDet.NrSeqFatNF  
              AND ttDetObsCont.ItCodigoNF           = ttDet.ItCodigoNF       
              AND (ttDetObsCont.xTexto              <> ?
              AND  ttDetObsCont.xTexto              <> ""):
            
            RUN addNode IN hGenXml (getStack(), "obsCont", "", OUTPUT iId).
                
            addStack(iId).
                
                RUN setAttribute IN hGenXml (INPUT iId,  "xCampo", ttDetObsCont.xCampo).
                    
                {adapters/xml/ep2/axsep037nodechar2.i "xTexto" ttDetObsCont.xTexto "YES"}
                
            delStack().
        
        END.

        FOR FIRST ttDetObsFisco
             WHERE ttDetObsFisco.CodEstabelNF       = ttDet.CodEstabelNF 
               AND ttDetObsFisco.SerieNF            = ttDet.SerieNF      
               AND ttDetObsFisco.NrNotaFisNF        = ttDet.NrNotaFisNF
               AND ttDetObsFisco.NrSeqFatNF         = ttDet.NrSeqFatNF  
               AND ttDetObsFisco.ItCodigoNF         = ttDet.ItCodigoNF       
               AND (ttDetObsFisco.xTexto            <> ?
               AND  ttDetObsFisco.xTexto            <> ""):
             
             RUN addNode IN hGenXml (getStack(), "obsFisco", "", OUTPUT iId).
                 
             addStack(iId).
                 
                RUN setAttribute IN hGenXml (INPUT iId,  "xCampo", ttDetObsFisco.xCampo).
        
                {adapters/xml/ep2/axsep037nodechar2.i "xTexto" ttDetObsFisco.xTexto "YES"}
                    
            delStack().
        END.

    delStack().

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

                                                       {adapters/xml/ep2/axsep037nodedec.i  "vBC"          ttISSQN.vBC          "YES" "2" "YES"}
                                                       {adapters/xml/ep2/axsep037nodedec.i  "vAliq"        ttISSQN.vAliq        "YES" "4" "NO "}
                                                       {adapters/xml/ep2/axsep037nodedec.i  "vISSQN"       ttISSQN.vISSQN       "YES" "2" "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "cMunFG"       ttISSQN.cMunFG       "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "cListServ"    ttISSQN.cListServ    "YES"}
                                                       {adapters/xml/ep2/axsep037nodedec.i  "vDeducao"     ttISSQN.vDeducao     "NO"  "2" "YES"}
                                                       {adapters/xml/ep2/axsep037nodedec.i  "vOutro"       ttISSQN.vOutro       "NO"  "2" "YES"}
                                                       {adapters/xml/ep2/axsep037nodedec.i  "vDescIncond"  ttISSQN.vDescIncond  "NO"  "2" "YES"}
                                                       {adapters/xml/ep2/axsep037nodedec.i  "vDescCond"    ttISSQN.vDescCond    "NO"  "2" "YES"}
                                                       {adapters/xml/ep2/axsep037nodedec.i  "vISSRet"      ttISSQN.vISSRet      "NO"  "2" "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "indISS"       ttISSQN.indISS       "YES"}
                                                       {adapters/xml/ep2/axsep037nodechar.i "cServico"     ttISSQN.cServico     "NO" }
                                                       {adapters/xml/ep2/axsep037nodechar.i "cMun"         ttISSQN.cMun         "NO" }
                                                       {adapters/xml/ep2/axsep037nodechar.i "cPais"        ttISSQN.cPais        "NO" }
                                                       {adapters/xml/ep2/axsep037nodechar.i "nProcesso"    ttISSQN.nProcesso    "NO" }
                                                       {adapters/xml/ep2/axsep037nodechar.i "indIncentivo" ttISSQN.indIncentivo "YES"}

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

                                             {adapters/xml/ep2/axsep037nodedec.i "vBC"            ttICMSTot.vBC            "YES" "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vICMS"          ttICMSTot.vICMS          "YES" "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vICMSDeson"     ttICMSTot.vICMSDeson     "YES" "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vFCPUFDest"     ttICMSTot.vFCPUFDest     "NO"  "2" "YES"} /*NT2015.003*/
                                             {adapters/xml/ep2/axsep037nodedec.i "vICMSUFDest"    ttICMSTot.vICMSUFDest    "NO"  "2" "YES"} /*NT2015.003*/
                                             {adapters/xml/ep2/axsep037nodedec.i "vICMSUFRemet"   ttICMSTot.vICMSUFRemet   "NO"  "2" "YES"} /*NT2015.003*/
                                             {adapters/xml/ep2/axsep037nodedec.i "vFCP"           ttICMSTot.vFCP           "YES" "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vBCST"          ttICMSTot.vBCST          "YES" "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vST"            ttICMSTot.vST            "YES" "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vFCPST"         ttICMSTot.vFCPST         "YES" "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vFCPSTRet"      ttICMSTot.vFCPSTRet      "YES" "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "qBCMono"        ttICMSTot.qBCMono        "NO" "2" "YES"} //NT2023.001
                                             {adapters/xml/ep2/axsep037nodedec.i "vICMSMono"      ttICMSTot.vICMSMono      "NO" "2" "YES"} //NT2023.001
                                             {adapters/xml/ep2/axsep037nodedec.i "qBCMonoReten"   ttICMSTot.qBCMonoReten   "NO" "2" "YES"} //NT2023.001
                                             {adapters/xml/ep2/axsep037nodedec.i "vICMSMonoReten" ttICMSTot.vICMSMonoReten "NO" "2" "YES"} //NT2023.001
                                             {adapters/xml/ep2/axsep037nodedec.i "qBCMonoRet"     ttICMSTot.qBCMonoRet     "NO" "2" "YES"} //NT2023.001
                                             {adapters/xml/ep2/axsep037nodedec.i "vICMSMonoRet"   ttICMSTot.vICMSMonoRet   "NO" "2" "YES"} //NT2023.001
                                             {adapters/xml/ep2/axsep037nodedec.i "vProd"          ttICMSTot.vProd          "YES" "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vFrete"         ttICMSTot.vFrete         "YES" "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vSeg"           ttICMSTot.vSeg           "YES" "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vDesc"          ttICMSTot.vDesc          "YES" "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vII"            ttICMSTot.vII            "YES" "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vIPI"           ttICMSTot.vIPI           "YES" "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vIPIDevol"      ttICMSTot.vIPIDevol      "YES" "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vPIS"           ttICMSTot.vPIS           "YES" "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vCOFINS"        ttICMSTot.vCOFINS        "YES" "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vOutro"         ttICMSTot.vOutro         "YES" "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vNF"            ttICMSTot.vNF            "YES" "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vTotTrib"       ttICMSTot.vTotTrib       "NO"  "2" "YES"} /*NT2013.003 - Valor aproximado total de tributos federais, estaduais e municipais - campo NAO obrigatorio*/
                                        delStack().

                                   END.
                                   FOR EACH ttISSQNtot
                                      WHERE ttISSQNtot.CodEstabelNF = ttNFe.CodEstabelNF
                                        AND ttISSQNtot.SerieNF      = ttNFe.SerieNF     
                                        AND ttISSQNtot.NrNotaFisNF  = ttNFe.NrNotaFisNF :
                                       
                                        RUN addNode IN hGenXml (getStack(), "ISSQNtot", "", OUTPUT iId).
                                        addStack(iId).

                                             {adapters/xml/ep2/axsep037nodedec.i  "vServ"       ttISSQNtot.vServ       "NO"  "2" "YES"} 
                                             {adapters/xml/ep2/axsep037nodedec.i  "vBC"         ttISSQNtot.vBC         "NO"  "2" "YES"}  
                                             {adapters/xml/ep2/axsep037nodedec.i  "vISS"        ttISSQNtot.vISS        "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i  "vPIS"        ttISSQNtot.vPIS        "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i  "vCOFINS"     ttISSQNtot.vCOFINS     "NO"  "2" "YES"} 
                                             {adapters/xml/ep2/axsep037nodedate.i "dCompet"     ttISSQNTot.dCompet     "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i  "vDeducao"    ttISSQNtot.vDeducao    "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i  "vOutro"      ttISSQNtot.vOutro      "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i  "vDescIncond" ttISSQNtot.vDescIncond "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i  "vDescCond"   ttISSQNtot.vDescCond   "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i  "vISSRet"     ttISSQNtot.vISSRet     "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodechar.i "cRegTrib"    ttISSQNtot.cRegTrib "NO"}
                                        
                                        delStack().

                                   END.
                                   FOR EACH ttRetTrib
                                      WHERE ttRetTrib.CodEstabelNF = ttNFe.CodEstabelNF 
                                        AND ttRetTrib.SerieNF      = ttNFe.SerieNF      
                                        AND ttRetTrib.NrNotaFisNF  = ttNFe.NrNotaFisNF :
                                       
                                        RUN addNode IN hGenXml (getStack(), "retTrib", "", OUTPUT iId).
                                        addStack(iId).

                                             {adapters/xml/ep2/axsep037nodedec.i "vRetPIS"     ttRetTrib.vRetPIS     "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vRetCOFINS"  ttRetTrib.vRetCOFINS  "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vRetCSLL"    ttRetTrib.vRetCSLL    "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vBCIRRF"     ttRetTrib.vBCIRRF     "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vIRRF"       ttRetTrib.vIRRF       "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vBCRetPrev"  ttRetTrib.vBCRetPrev  "NO"  "2" "YES"}
                                             {adapters/xml/ep2/axsep037nodedec.i "vRetPrev"    ttRetTrib.vRetPrev    "NO"  "2" "YES"}
                                        delStack().

                                   END.
                                   
                                   IF l-NT2024002 THEN DO:
                                   
                                      FOR EACH ttTotIBSCBSIS
                                         WHERE ttTotIBSCBSIS.CodEstabelNF = ttNFe.CodEstabelNF 
                                           AND ttTotIBSCBSIS.SerieNF      = ttNFe.SerieNF      
                                           AND ttTotIBSCBSIS.NrNotaFisNF  = ttNFe.NrNotaFisNF :
                                           
                                           IF ttTotIBSCBSIS.vIS > 0 THEN DO:
                                              RUN addNode IN hGenXml (getStack(), "ISTot", "", OUTPUT iId).
                                              addStack(iId).
                                                   {adapters/xml/ep2/axsep037nodedec.i "vIS"    ttTotIBSCBSIS.vIS "YES"  "2" "YES"}
                                              delStack().
                                           END.

                                     
                                           RUN addNode IN hGenXml (getStack(), "IBSCBSTot", "", OUTPUT iId).
                                           addStack(iId).
                                                   {adapters/xml/ep2/axsep037nodedec.i "vBCIBSCBS"    ttTotIBSCBSIS.vBCIBSCBS "YES"  "2" "YES"}
                                           
                                                   IF (ttTotIBSCBSIS.vDifIBSUF  > 0 OR ttTotIBSCBSIS.vDevTribIBSUF  > 0 OR ttTotIBSCBSIS.vIBSUF              > 0 OR
                                                       ttTotIBSCBSIS.vDifIBSMun > 0 OR ttTotIBSCBSIS.vDevTribIBSMun > 0 OR ttTotIBSCBSIS.vIBSMun             > 0 OR 
                                                       ttTotIBSCBSIS.vIBS       > 0 OR ttTotIBSCBSIS.vCredPresIBS   > 0 OR ttTotIBSCBSIS.vCredPresCondSusIBS > 0) AND 
                                                       l-ajust-compet = NO  THEN DO:
                                              
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
                                                           {adapters/xml/ep2/axsep037nodedec.i "vCredPres"         ttTotIBSCBSIS.vCredPresIBS         "YES"  "2" "YES"}
                                                           {adapters/xml/ep2/axsep037nodedec.i "vCredPresCondSus"  ttTotIBSCBSIS.vCredPresCondSusIBS  "YES"  "2" "YES"}
                                                      delStack().
                                                   END.
                                                   
                                                   IF ttTotIBSCBSIS.vDifCBS       > 0 OR ttTotIBSCBSIS.vDevTribCBS         > 0 OR ttTotIBSCBSIS.vCBS > 0 OR
                                                      ttTotIBSCBSIS.vCredPresCBS  > 0 OR ttTotIBSCBSIS.vCredPresCondSusCBS > 0 THEN DO:
                                              
                                                      RUN addNode IN hGenXml (getStack(), "gCBS", "", OUTPUT iId).
                                                      addStack(iId).
                                                           {adapters/xml/ep2/axsep037nodedec.i "vDif"              ttTotIBSCBSIS.vDifCBS              "YES"  "2" "YES"}
                                                           {adapters/xml/ep2/axsep037nodedec.i "vDevTrib"          ttTotIBSCBSIS.vDevTribCBS          "YES"  "2" "YES"}
                                                           {adapters/xml/ep2/axsep037nodedec.i "vCBS"              ttTotIBSCBSIS.vCBS                 "YES"  "2" "YES"}
                                                           {adapters/xml/ep2/axsep037nodedec.i "vCredPres"         ttTotIBSCBSIS.vCredPresCBS         "YES"  "2" "YES"}
                                                           {adapters/xml/ep2/axsep037nodedec.i "vCredPresCondSus"  ttTotIBSCBSIS.vCredPresCondSusCBS  "YES"  "2" "YES"}
                                                      delStack().
                                                   END.
                                               
                                                   IF ttTotIBSCBSIS.vIBSMono      > 0 OR ttTotIBSCBSIS.vCBSMono      > 0 OR 
                                                      ttTotIBSCBSIS.vIBSMonoReten > 0 OR ttTotIBSCBSIS.vCBSMonoReten > 0 OR
                                                      ttTotIBSCBSIS.vIBSMonoRet   > 0 OR ttTotIBSCBSIS.vCBSMonoRet   > 0 THEN DO:
                                              
                                                      RUN addNode IN hGenXml (getStack(), "gMono", "", OUTPUT iId).
                                                      addStack(iId).
                                                           {adapters/xml/ep2/axsep037nodedec.i "vIBSMono"      ttTotIBSCBSIS.vIBSMono       "YES"  "2" "YES"}
                                                           {adapters/xml/ep2/axsep037nodedec.i "vCBSMono"      ttTotIBSCBSIS.vCBSMono       "YES"  "2" "YES"}
                                                           {adapters/xml/ep2/axsep037nodedec.i "vIBSMonoReten" ttTotIBSCBSIS.vIBSMonoReten  "YES"  "2" "YES"}
                                                           {adapters/xml/ep2/axsep037nodedec.i "vCBSMonoReten" ttTotIBSCBSIS.vCBSMonoReten  "YES"  "2" "YES"}
                                                           {adapters/xml/ep2/axsep037nodedec.i "vIBSMonoRet"   ttTotIBSCBSIS.vIBSMonoRet    "YES"  "2" "YES"}
                                                           {adapters/xml/ep2/axsep037nodedec.i "vCBSMonoRet"   ttTotIBSCBSIS.vCBSMonoRet    "YES"  "2" "YES"}
                                                      delStack().
                                                   END.
                                                   
                                                   IF ttTotIBSCBSIS.vIBSEstCred > 0 
                                                   OR ttTotIBSCBSIS.vCBSEstCred > 0 THEN DO:
                                              
                                                      RUN addNode IN hGenXml (getStack(), "gEstornoCred", "", OUTPUT iId).
                                                      addStack(iId).
                                                           {adapters/xml/ep2/axsep037nodedec.i "vIBSEstCred"      ttTotIBSCBSIS.vIBSEstCred       "YES"  "2" "YES"}
                                                           {adapters/xml/ep2/axsep037nodedec.i "vCBSEstCred"      ttTotIBSCBSIS.vCBSEstCred       "YES"  "2" "YES"}
                                                      delStack().
                                                   END.                                                   
                                                   
                                           delStack().
                                              
                                           {adapters/xml/ep2/axsep037nodedec.i "vNFTot"  ttTotIBSCBSIS.vNFTot  "NO"  "2" "YES"}
                                      END.
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

                                        {adapters/xml/ep2/axsep037nodechar.i "modFrete" ttTransp.modFrete "YES"}

                                        IF l-NT2021004 THEN DO:

                                            IF ttTransp.modFrete <> "9" THEN DO:
                                                IF ((TRIM(ttTransp.xNome)  <> ? AND TRIM(ttTransp.xNome)  <> "":U) OR
                                                    (TRIM(ttTransp.CNPJ)   <> ? AND TRIM(ttTransp.CNPJ)   <> "":U) OR   
                                                    (TRIM(ttTransp.CPF)    <> ? AND TRIM(ttTransp.CPF)    <> "":U) OR
                                                    (TRIM(ttTransp.IE)     <> ? AND TRIM(ttTransp.IE)     <> "":U) OR
                                                    (TRIM(ttTransp.xEnder) <> ? AND TRIM(ttTransp.xEnder) <> "":U) OR
                                                    (TRIM(ttTransp.xMun)   <> ? AND TRIM(ttTransp.xMun)   <> "":U) OR
                                                    (TRIM(ttTransp.UF)     <> ? AND TRIM(ttTransp.UF)     <> "":U)) THEN DO: 
                                                
                                                    RUN addNode IN hGenXml (getStack(), "transporta", "",                OUTPUT iId).
                                                    addStack(iId).
                                                
                                                
                                                    IF  ttTransp.i-natureza = 1 THEN DO: /*Pessoa F°sica*/
                                                        {adapters/xml/ep2/axsep037nodechar.i "CPF"    ttTransp.CPF    "NO" }
                                                    END.
                                                    ELSE DO: /*Pessoa Jur°dica*/
                                                        {adapters/xml/ep2/axsep037nodechar.i "CNPJ"   ttTransp.CNPJ   "NO" }
                                                    END.
                                                     
                                                    {adapters/xml/ep2/axsep037nodechar.i "xNome"  ttTransp.xNome  "NO" }
                                                    {adapters/xml/ep2/axsep037nodechar.i "IE"     ttTransp.IE     "NO" }
                                                    {adapters/xml/ep2/axsep037nodechar.i "xEnder" ttTransp.xEnder "NO" }
                                                    {adapters/xml/ep2/axsep037nodechar.i "xMun"   ttTransp.xMun   "NO" }
                                                    {adapters/xml/ep2/axsep037nodechar.i "UF"     ttTransp.UF     "NO" }
                                                    delStack().
                                                END.
                                            END.

                                        END.
                                        
                                        ELSE DO:

                                            IF ((TRIM(ttTransp.xNome)  <> ? AND TRIM(ttTransp.xNome)  <> "":U) OR                  
                                                (TRIM(ttTransp.CNPJ)   <> ? AND TRIM(ttTransp.CNPJ)   <> "":U) OR                  
                                                (TRIM(ttTransp.CPF)    <> ? AND TRIM(ttTransp.CPF)    <> "":U) OR                  
                                                (TRIM(ttTransp.IE)     <> ? AND TRIM(ttTransp.IE)     <> "":U) OR                  
                                                (TRIM(ttTransp.xEnder) <> ? AND TRIM(ttTransp.xEnder) <> "":U) OR                  
                                                (TRIM(ttTransp.xMun)   <> ? AND TRIM(ttTransp.xMun)   <> "":U) OR                  
                                                (TRIM(ttTransp.UF)     <> ? AND TRIM(ttTransp.UF)     <> "":U)) THEN DO:           
                                                                                                                                   
                                                RUN addNode IN hGenXml (getStack(), "transporta", "",                OUTPUT iId).  
                                                addStack(iId).                                                                     
                                                                                                                                   
                                                                                                                                   
                                                IF  ttTransp.i-natureza = 1 THEN DO: /*Pessoa F°sica*/                             
                                                    {adapters/xml/ep2/axsep037nodechar.i "CPF"    ttTransp.CPF    "NO" }           
                                                END.                                                                               
                                                ELSE DO: /*Pessoa Jur°dica*/                                                       
                                                    {adapters/xml/ep2/axsep037nodechar.i "CNPJ"   ttTransp.CNPJ   "NO" }           
                                                END.                                                                               
                                                                                                                                   
                                                {adapters/xml/ep2/axsep037nodechar.i "xNome"  ttTransp.xNome  "NO" }               
                                                {adapters/xml/ep2/axsep037nodechar.i "IE"     ttTransp.IE     "NO" }               
                                                {adapters/xml/ep2/axsep037nodechar.i "xEnder" ttTransp.xEnder "NO" }               
                                                {adapters/xml/ep2/axsep037nodechar.i "xMun"   ttTransp.xMun   "NO" }               
                                                {adapters/xml/ep2/axsep037nodechar.i "UF"     ttTransp.UF     "NO" }               
                                                delStack().                                                                        
                                            END.                                                                                       
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
    
                                                 {adapters/xml/ep2/axsep037nodedec.i  "vServ"    ttTransp.vServ    "YES" "2" "YES"}
                                                 {adapters/xml/ep2/axsep037nodedec.i  "vBCRet"   ttTransp.vBCRet   "YES" "2" "YES"}
                                                 {adapters/xml/ep2/axsep037nodedec.i  "pICMSRet" ttTransp.pICMSRet "YES" "4" "NO "}
                                                 {adapters/xml/ep2/axsep037nodedec.i  "vICMSRet" ttTransp.vICMSRet "YES" "2" "YES"}
                                                 {adapters/xml/ep2/axsep037nodechar.i "CFOP"     ttTransp.CFOP     "YES"}
                                                 {adapters/xml/ep2/axsep037nodechar.i "cMunFG"   ttTransp.cMunFG   "YES"}
                                            delStack().
                                        END.

                                        IF  (ttTransp.placa    <> "" AND ttTransp.placa   <> ?)
                                        AND ((ttTransp.UFplaca <> "" AND ttTransp.UFplaca <> ?) OR l-nt2020005)
                                        THEN DO:
                                        
                                            RUN addNode IN hGenXml (getStack(), "veicTransp", "", OUTPUT iId).
                                            addStack(iId).
    
                                                 {adapters/xml/ep2/axsep037nodechar.i "placa" ttTransp.placa   "YES"}
                                                 IF  (ttTransp.UFplaca <> "" AND ttTransp.UFplaca <> ?) THEN
                                                     {adapters/xml/ep2/axsep037nodechar.i "UF"    ttTransp.UFplaca "YES"}
                                                 {adapters/xml/ep2/axsep037nodechar.i "RNTC"  ttTransp.RNTC    "NO" }
                                            delStack().
                                        END.

                                        FOR EACH  ttReboque
                                           WHERE  ttReboque.CodEstabelNF = ttTransp.CodEstabelNF
                                             AND  ttReboque.SerieNF      = ttTransp.SerieNF     
                                             AND  ttReboque.NrNotaFisNF  = ttTransp.NrNotaFisNF
                                             AND (ttReboque.placa       <> "" AND ttReboque.placa       <> ?)
                                             AND ( (ttReboque.UF        <> "" AND ttReboque.UF          <> ?) OR l-nt2020005) :
                                            
                                             RUN addNode IN hGenXml (getStack(), "reboque", "", OUTPUT iId).
                                             addStack(iId).

                                                  {adapters/xml/ep2/axsep037nodechar.i "placa"  ttReboque.placa  "YES"}
                                                  IF  (ttReboque.UF <> "" AND ttReboque.UF <> ?) THEN
                                                      {adapters/xml/ep2/axsep037nodechar.i "UF" ttReboque.UF     "YES"}
                                                  {adapters/xml/ep2/axsep037nodechar.i "RNTC"   ttReboque.RNTC   "NO" }
                                                  
                                             delStack().

                                        END.

                                        /*Informaá‰es de Vag∆o e Balsa*/
                                        {adapters/xml/ep2/axsep037nodechar.i "vagao"  ttTransp.vagao  "NO" }
                                        {adapters/xml/ep2/axsep037nodechar.i "balsa"  ttTransp.balsa  "NO" }

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

                                                  {adapters/xml/ep2/axsep037nodechar.i "qVol"  ttVol.qVol  "YES"} /*NT2012.003 - tag obrigatoria*/
                                                  {adapters/xml/ep2/axsep037nodechar.i "esp"   ttVol.esp   "NO" }
                                                  {adapters/xml/ep2/axsep037nodechar.i "marca" ttVol.marca "NO" }
                                                  {adapters/xml/ep2/axsep037nodechar.i "nVol"  ttVol.nVol  "NO" }
                                                  {adapters/xml/ep2/axsep037nodedec.i  "pesoL" ttVol.pesoL "NO"  "3" "YES"}
                                                  {adapters/xml/ep2/axsep037nodedec.i  "pesoB" ttVol.pesoB "NO"  "3" "YES"}

                                                  FOR EACH  ttLacres 
                                                     WHERE  ttLacres.CodEstabelNF = ttVol.CodEstabelNF
                                                       AND  ttLacres.SerieNF      = ttVol.SerieNF     
                                                       AND  ttLacres.NrNotaFisNF  = ttVol.NrNotaFisNF 
                                                       AND  ttLacres.nVol         = ttVol.nVol
                                                       AND (ttLacres.nLacre      <> "" AND ttLacres.nLacre <> ?):

                                                       RUN addNode IN hGenXml (getStack(), "lacres", "", OUTPUT iId).
                                                       addStack(iId).

                                                            {adapters/xml/ep2/axsep037nodechar.i "nLacre" ttLacres.nLacre "YES"}
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
    
                                                 {adapters/xml/ep2/axsep037nodechar.i "nFat"  ttCobr.nFat  "YES" }
                                                 {adapters/xml/ep2/axsep037nodedec.i  "vOrig" ttCobr.vOrig "YES"  "2" "YES"}
                                                 {adapters/xml/ep2/axsep037nodedec.i  "vDesc" ttCobr.vDesc "YES"  "2" "YES"}
                                                 {adapters/xml/ep2/axsep037nodedec.i  "vLiq"  ttCobr.vLiq  "YES"  "2" "YES"}
                                            delStack().
                                        END.

                                        FOR EACH ttDup
                                           WHERE ttDup.CodEstabelNF = ttCobr.CodEstabelNF
                                             AND ttDup.SerieNF      = ttCobr.SerieNF
                                             AND ttDup.NrNotaFisNF  = ttCobr.NrNotaFisNF:
                                            
                                             RUN addNode IN hGenXml (getStack(), "dup", "", OUTPUT iId).
                                             addStack(iId).

                                                  {adapters/xml/ep2/axsep037nodechar.i "nDup"  ttDup.nDup  "YES"}
                                                  {adapters/xml/ep2/axsep037nodedate.i "dVenc" ttDup.dVenc "YES"}
                                                  {adapters/xml/ep2/axsep037nodedec.i  "vDup"  ttDup.vDup  "YES"  "2" "YES"} /*NT2012.003 - tag obrigatoria*/
                                             delStack().

                                        END.
                                   delStack().
                              END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-Pag:
    
    FOR EACH ttPag
       WHERE ttPag.CodEstabelNF = ttNFe.CodEstabelNF
         AND ttPag.SerieNF      = ttNFe.SerieNF     
         AND ttPag.NrNotaFisNF  = ttNFe.NrNotaFisNF :

         RUN addNode IN hGenXml (getStack(), "pag", "", OUTPUT iId).
         addStack(iId).

              FOR EACH ttDetPag
                 WHERE ttDetPag.CodEstabelNF = ttPag.CodEstabelNF
                   AND ttDetPag.SerieNF      = ttPag.SerieNF
                   AND ttDetPag.NrNotaFisNF  = ttPag.NrNotaFisNF:

                   RUN addNode IN hGenXml (getStack(), "detPag", "", OUTPUT iId).
                   addStack(iId).

                        {adapters/xml/ep2/axsep037nodechar.i "indPag" ttDetPag.indPag "NO"  }
                        {adapters/xml/ep2/axsep037nodechar.i "tPag"   ttDetPag.tPag   "YES" }

                        IF  l-NT2020006V120
                        AND ttDetPag.tPag = "99" THEN DO:
                            {adapters/xml/ep2/axsep037nodechar.i "xPag"   ttDetPag.xPag   "NO" }
                        END.

                        {adapters/xml/ep2/axsep037nodedec.i  "vPag"   ttDetPag.vPag   "YES"  "2" "YES"}
                        {adapters/xml/ep2/axsep037nodedate.i "dPag"   ttDetPag.dPag    "NO" }   

                        {adapters/xml/ep2/axsep037nodechar.i "CNPJPag"   ttPag.CNPJPag   "NO" }
                        {adapters/xml/ep2/axsep037nodechar.i "UFPag"     ttPag.UFPag     "NO" }
                        IF ((ttDetPag.tpIntegra <> ? AND ttDetPag.tpIntegra <> "":U)
                        OR  (ttDetPag.CNPJ      <> ? AND ttDetPag.CNPJ      <> "":U)
                        OR  (ttDetPag.tBand     <> ? AND ttDetPag.tBand     <> "":U)
                        OR  (ttDetPag.cAut      <> ? AND ttDetPag.cAut      <> "":U)
                        OR  (ttDetPag.CNPJReceb <> ?  AND ttDetPag.CNPJReceb <> "":U)
                        OR  (ttDetPag.idTermPag <> ?  AND ttDetPag.idTermPag <> "":U)) THEN DO:
                        
                            RUN addNode IN hGenXml (getStack(), "card", "", OUTPUT iId).
                            addStack(iId).
    
                                {adapters/xml/ep2/axsep037nodechar.i "tpIntegra"  ttDetPag.tpIntegra  "YES" }
                                {adapters/xml/ep2/axsep037nodechar.i "CNPJ"       ttDetPag.CNPJ       "NO"  }
                                {adapters/xml/ep2/axsep037nodechar.i "tBand"      ttDetPag.tBand      "NO"  }
                                {adapters/xml/ep2/axsep037nodechar.i "cAut"       ttDetPag.cAut       "NO"  }
                                {adapters/xml/ep2/axsep037nodechar.i "CNPJReceb"  ttDetPag.CNPJReceb  "NO"  }
                                {adapters/xml/ep2/axsep037nodechar.i "idTermPag"  ttDetPag.idTermPag  "NO"  }
                                                                
                            delStack().
                        END.
                   delStack().
              END.

              IF  (ttPag.vTroco <> ? AND ttPag.vTroco > 0) THEN DO:
                  {adapters/xml/ep2/axsep037nodedec.i  "vTroco"  ttPag.vTroco  "NO"  "2" "YES"}
              END.

         delStack().
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-InfIntermed:

                            IF CAN-FIND(FIRST ttIde WHERE ttIde.CodEstabelNF = ttNFe.CodEstabelNF
                                                      AND ttIde.SerieNF      = ttNFe.SerieNF     
                                                      AND ttIde.NrNotaFisNF  = ttNFe.NrNotaFisNF
                                                      AND ttIde.indIntermed  = "1" ) THEN DO:
                                                          FOR EACH ttInfIntermed
                                                             WHERE ttInfIntermed.CodEstabelNF = ttNFe.CodEstabelNF
                                                               AND ttInfIntermed.SerieNF      = ttNFe.SerieNF     
                                                               AND ttInfIntermed.NrNotaFisNF  = ttNFe.NrNotaFisNF :
                                                                   RUN addNode IN hGenXml (getStack(), "infIntermed", "", OUTPUT iId).
                                                                   addStack(iId).
                                                                       {adapters/xml/ep2/axsep037nodechar.i "CNPJ"         ttInfIntermed.cnpjIntermed  "YES"}
                                                                       {adapters/xml/ep2/axsep037nodechar.i "idCadIntTran" ttInfIntermed.idCadIntTran  "YES"}
                                                                   delStack().
                                                          END.
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

                                        {adapters/xml/ep2/axsep037nodechar.i  "infAdFisco" ttInfAdic.infAdFisco "NO" }
                                        {adapters/xml/ep2/axsep037nodechar2.i "infCpl"     ttInfAdic.infCpl     "NO" }

                                        FOR EACH ttObsCont
                                           WHERE ttObsCont.CodEstabelNF = ttNFe.CodEstabelNF
                                             AND ttObsCont.SerieNF      = ttNFe.SerieNF     
                                             AND ttObsCont.NrNotaFisNF  = ttNFe.NrNotaFisNF
                                             AND (ttObsCont.xTexto      <> ?
                                             AND  ttObsCont.xTexto      <> ""):
                                            
                                             RUN addNode IN hGenXml (getStack(), "obsCont", "", OUTPUT iId).
                                             addStack(iId).

                                                  RUN setAttribute IN hGenXml (INPUT iId,  "xCampo", ttObsCont.xCampo).
                                                  {adapters/xml/ep2/axsep037nodechar2.i "xTexto" ttObsCont.xTexto "YES"}
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
                                                  {adapters/xml/ep2/axsep037nodechar2.i "xTexto" ttObsFisco.xTexto "YES"}
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

                                                {adapters/xml/ep2/axsep037nodechar.i "nProc"   ttProcRef.nProc   "YES"}
                                                {adapters/xml/ep2/axsep037nodechar.i "indProc" ttProcRef.indProc "YES"}

                                                IF l-NT2021004 AND ttProcRef.indProc = "0" THEN /*Sefaz*/
                                                    {adapters/xml/ep2/axsep037nodechar.i "tpAto" ttProcRef.tpAto "NO"}

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

                                        {adapters/xml/ep2/axsep037nodechar.i "UFSaidaPais"  ttExporta.UFSaidaPais  "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "xLocExporta"  ttExporta.xLocExporta  "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "xLocDespacho" ttExporta.xLocDespacho "NO" }
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

                                        {adapters/xml/ep2/axsep037nodechar.i "xNEmp" ttCompra.xNEmp "NO" }
                                        {adapters/xml/ep2/axsep037nodechar.i "xPed"  ttCompra.xPed  "NO" }
                                        {adapters/xml/ep2/axsep037nodechar.i "xCont" ttCompra.xCont "NO" }
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
                              
                                        {adapters/xml/ep2/axsep037nodechar.i "safra"  ttCana.safra  "YES"}
                                        {adapters/xml/ep2/axsep037nodechar.i "ref"    ttCana.ref    "YES"}
                              
                                        FOR EACH ttForDia
                                           WHERE ttForDia.CodEstabelNF = ttCana.CodEstabelNF
                                             AND ttForDia.SerieNF      = ttCana.SerieNF     
                                             AND ttForDia.NrNotaFisNF  = ttCana.NrNotaFisNF:

                                            RUN addNode IN hGenXml (getStack(), "forDia", "",  OUTPUT iId).
                                            addStack(iId).
                              
                                                RUN setAttribute IN hGenXml (INPUT iId, "dia", ttForDia.dia).
                                                {adapters/xml/ep2/axsep037nodedec.i  "qtde"  ttForDia.qtde  "YES" "10" "YES"}
    
                                            delStack().
                              
                                        END.
                              
                                        {adapters/xml/ep2/axsep037nodedec.i  "qTotMes"  ttCana.qTotMes  "YES" "10" "YES"}
                                        {adapters/xml/ep2/axsep037nodedec.i  "qTotAnt"  ttCana.qTotAnt  "YES" "10" "YES"}
                                        {adapters/xml/ep2/axsep037nodedec.i  "qTotGer"  ttCana.qTotGer  "YES" "10" "YES"}
                                  
                                        FOR EACH ttDeduc
                                           WHERE ttDeduc.CodEstabelNF = ttCana.CodEstabelNF
                                             AND ttDeduc.SerieNF      = ttCana.SerieNF     
                                             AND ttDeduc.NrNotaFisNF  = ttCana.NrNotaFisNF:
                              
                                            RUN addNode IN hGenXml (getStack(), "deduc", "",  OUTPUT iId).
                                            addStack(iId).
                                            
                                                {adapters/xml/ep2/axsep037nodechar.i "xDed"  ttDeduc.xDed  "YES"}
                                                {adapters/xml/ep2/axsep037nodedec.i  "vDed"  ttDeduc.vDed  "YES" "2" "YES"}

                                            delStack().
                                  
                                        END.

                                        {adapters/xml/ep2/axsep037nodedec.i  "vFor"     ttCana.vFor     "YES" "2" "YES"}
                                        {adapters/xml/ep2/axsep037nodedec.i  "vTotDed"  ttCana.vTotDed  "YES" "2" "YES"}
                                        {adapters/xml/ep2/axsep037nodedec.i  "vLiqFor"  ttCana.vLiqFor  "YES" "2" "YES"}
                              
                                   delStack().
                              
                              END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-InfRespTec:

    DEFINE VARIABLE v_hdl_get_csrt AS HANDLE     NO-UNDO.
    DEFINE VARIABLE oJson          AS JsonObject NO-UNDO.
    DEFINE VARIABLE CNPJ     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE xContato AS CHARACTER NO-UNDO.
    DEFINE VARIABLE email    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE fone     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE idCSRT   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE hashCSRT AS CHARACTER NO-UNDO.

    FOR EACH ttIde
       WHERE ttIde.CodEstabelNF = ttNFe.CodEstabelNF
         AND ttIde.SerieNF      = ttNFe.SerieNF     
         AND ttIde.NrNotaFisNF  = ttNFe.NrNotaFisNF:
         
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
            RUN piGetCSRT IN v_hdl_get_csrt (INPUT ttNFe.ChaveAcessoNFe, /* N£mero da chave de acesso da NF, obrigat¢rio */
                                             INPUT ttIde.cUFCSRT,        /* Sigla do estado da NF, obrigat¢rio */  
                                             INPUT ttIde.tpAmb,          /* Indica se o CSRT Ç de Produá∆o(1) ou Homologaá∆o(2), caso n∆o for informado 1 ou 2, ser† considerado sempre 1 (Produá∆o) */
                                             OUTPUT oJson).              /* JSON retornado na estrutura contida no OUTPUT */             
            IF NOT oJson:has('error':U) THEN 
                ASSIGN hashCSRT = oJson:getCharacter('hashCSRT':U)
                       idCSRT   = STRING(int(oJson:getCharacter('idCSRT')),"99":U).                 
        END.
       RUN addNode IN hGenXml (getStack(), "infRespTec", "", OUTPUT iId).
       addStack(iId).
           {adapters/xml/ep2/axsep037nodechar.i "CNPJ"      CNPJ     "YES"}
           {adapters/xml/ep2/axsep037nodechar.i "xContato"  xContato "YES"}
           {adapters/xml/ep2/axsep037nodechar.i "email"     email    "YES"}
           {adapters/xml/ep2/axsep037nodechar.i "fone"      fone     "YES"}
           {adapters/xml/ep2/axsep037nodechar.i "idCSRT"    idCSRT   "NO"}
           {adapters/xml/ep2/axsep037nodechar2.i "hashCSRT"  hashCSRT "NO"}

       delStack().    
    END.
    IF VALID-HANDLE(v_hdl_get_csrt) THEN 
        DELETE PROCEDURE v_hdl_get_csrt NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-imprime-agropecuario: 
             
    FOR EACH  ttAgropecuario
        WHERE ttAgropecuario.CodEstabelNF = ttNFe.CodEstabelNF 
        AND   ttAgropecuario.SerieNF      = ttNFe.SerieNF
        AND   ttAgropecuario.NrNotaFisNF  = ttNFe.NrNotaFisNF
        BREAK BY ttAgropecuario.nGuia :        
        
        IF FIRST(ttAgropecuario.nGuia) THEN DO:
           RUN addNode IN hGenXml (getStack(), "agropecuario", "", OUTPUT iId).
           addStack(iId).
        END.
        
        IF  ttAgropecuario.nReceituario <> "" AND ttAgropecuario.nReceituario <> ?
        AND ttAgropecuario.cpfRespTec   <> "" AND ttAgropecuario.cpfRespTec   <> ? THEN DO:
            RUN addNode IN hGenXml (getStack(), "defensivo", "", OUTPUT iId).
            addStack(iId).   
            
            {adapters/xml/ep2/axsep037nodechar.i "nReceituario" ttAgropecuario.nReceituario  "YES" }
            {adapters/xml/ep2/axsep037nodechar.i "CPFRespTec"   ttAgropecuario.cpfRespTec    "YES" }
            
            delStack().
        END.                   
        
        IF LAST(ttAgropecuario.nGuia) THEN DO:               
           IF  ttAgropecuario.tpGuia <> '0' AND ttAgropecuario.tpGuia <> "" AND ttAgropecuario.tpGuia <> ? 
           AND ttAgropecuario.nGuia  <> '0' AND ttAgropecuario.nGuia  <> "" AND ttAgropecuario.nGuia  <> ? THEN DO:
               RUN addNode IN hGenXml (getStack(), "guiaTransito", "", OUTPUT iId).
               addStack(iId). 
                
               {adapters/xml/ep2/axsep037nodechar.i "tpGuia"    ttAgropecuario.tpGuia    "YES" }
               {adapters/xml/ep2/axsep037nodechar.i "UFGuia"    ttAgropecuario.UFGuia    "YES" }
               {adapters/xml/ep2/axsep037nodechar.i "serieGuia" ttAgropecuario.serieGuia "NO" }
               {adapters/xml/ep2/axsep037nodechar.i "nGuia"     ttAgropecuario.nGuia     "YES" }
                
               delStack().
           END.
           delStack().
        END.
    END.
               
    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-imprime-gTribRegular:
                     
    FOR FIRST ttgTribRegular
        WHERE ttgTribRegular.CodEstabelNF   =  ttDet.CodEstabelNF
          AND ttgTribRegular.SerieNF        =  ttDet.SerieNF     
          AND ttgTribRegular.NrNotaFisNF    =  ttDet.NrNotaFisNF 
          AND ttgTribRegular.NrSeqFatNF     =  ttDet.NrSeqFatNF
          AND ttgTribRegular.ItCodigoNF     =  ttDet.ItCodigoNF
          AND ttgTribRegular.CSTReg         <> ""
          AND ttgTribRegular.cClassTribReg  <> "": 
   
        RUN addNode IN hGenXml (getStack(), "gTribRegular", "", OUTPUT iId).
        addStack(iId).
        
            {adapters/xml/ep2/axsep037nodechar.i "CSTReg"             ttgTribRegular.CSTReg              "YES"          }
            {adapters/xml/ep2/axsep037nodechar.i "cClassTribReg"      ttgTribRegular.cClassTribReg       "YES"          }            
            {adapters/xml/ep2/axsep037nodedec.i "pAliqEfetRegIBSUF"   ttgTribRegular.pAliqEfetRegIBSUF   "YES" "4" "YES"}
            {adapters/xml/ep2/axsep037nodedec.i "vTribRegIBSUF"       ttgTribRegular.vTribRegIBSUF       "YES" "2" "YES"}
            {adapters/xml/ep2/axsep037nodedec.i "pAliqEfetRegIBSMun"  ttgTribRegular.pAliqEfetRegIBSMun  "YES" "4" "YES"}
            {adapters/xml/ep2/axsep037nodedec.i "vTribRegIBSMun"      ttgTribRegular.vTribRegIBSMun      "YES" "2" "YES"}
            {adapters/xml/ep2/axsep037nodedec.i "pAliqEfetRegCBS"     ttgTribRegular.pAliqEfetRegCBS     "YES" "4" "YES"}
            {adapters/xml/ep2/axsep037nodedec.i "vTribRegCBS"         ttgTribRegular.vTribRegCBS         "YES" "2" "YES"}
            
        delStack().
  
    END.
               
    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-imprime-cred-presum:                     
     
    /* Primeiro imprime CrÇdito Presumido IBS
       Depois imprime CrÇdito Presumido CBS*/    
   FOR FIRST ttgCredPresOper 
       WHERE ttgCredPresOper.CodEstabelNF  = ttDet.CodEstabelNF
       AND   ttgCredPresOper.SerieNF       = ttDet.SerieNF
       AND   ttgCredPresOper.NrNotaFisNF   = ttDet.NrNotaFisNF
       AND   ttgCredPresOper.ItCodigoNF    = ttDet.ItCodigoNF
       AND   ttgCredPresOper.NrSeqFatNF    = ttDet.NrSeqFatNF:
     
      RUN addNode IN hGenXml (getStack(), "gCredPresOper", "", OUTPUT iId).
      addStack(iId).                                                             
           {adapters/xml/ep2/axsep037nodedec.i   "vBCCredPres"    ttgCredPresOper.vBCCredPres        "YES" "2" "YES"}
           {adapters/xml/ep2/axsep037nodechar.i  "cCredPres"      ttgCredPresOper.cCredPres          "YES" "0" "YES"}
           
            FOR EACH  ttgIBSCBSCredPres     
                WHERE ttgIBSCBSCredPres.CodEstabelNF = ttgCredPresOper.CodEstabelNF
                AND   ttgIBSCBSCredPres.SerieNF      = ttgCredPresOper.SerieNF     
                AND   ttgIBSCBSCredPres.NrNotaFisNF  = ttgCredPresOper.NrNotaFisNF 
                AND   ttgIBSCBSCredPres.ItCodigoNF   = ttgCredPresOper.ItCodigoNF  
                AND   ttgIBSCBSCredPres.NrSeqFatNF   = ttgCredPresOper.NrSeqFatNF 
                BY ttgIBSCBSCredPres.TipTributo DESC:
                
                IF  ttgIBSCBSCredPres.TipTributo = 1 THEN
                    RUN addNode IN hGenXml (getStack(), "gCBSCredPres", "", OUTPUT iId).
                ELSE
                    RUN addNode IN hGenXml (getStack(), "gIBSCredPres", "", OUTPUT iId).
                
                addStack(iId). 
                     {adapters/xml/ep2/axsep037nodedec.i  "pCredPres"         ttgIBSCBSCredPres.pCredPres         "YES" "4" "YES"}
                     {adapters/xml/ep2/axsep037nodedec.i  "vCredPres"         ttgIBSCBSCredPres.vCredPres         "YES" "2" "YES"} 
                     IF  vCredPresCondSus > 0 THEN
                         {adapters/xml/ep2/axsep037nodedec.i  "vCredPresCondSus"  ttgIBSCBSCredPres.vCredPresCondSus  "YES" "2" "YES"}                                                                   
                delStack().                                                                  
                
            END.
            
      delStack().
   END.       
       
    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-imprime-vItem:

   FOR FIRST ttVB 
       WHERE ttVB.CodEstabelNF = ttDet.CodEstabelNF
       AND   ttVB.SerieNF      = ttDet.SerieNF
       AND   ttVB.NrNotaFisNF  = ttDet.NrNotaFisNF
       AND   ttVB.ItCodigoNF   = ttDet.ItCodigoNF
       AND   ttVB.NrSeqFatNF   = ttDet.NrSeqFatNF:

      {adapters/xml/ep2/axsep037nodedec.i  "vItem"   ttVB.vItem   "NO" "2" "YES"}

   END.

   RETURN "OK":U.
   
END PROCEDURE.

PROCEDURE pi-imprime-DFeReferenciado:

   FOR FIRST ttDFeReferenciado 
       WHERE ttDFeReferenciado.CodEstabelNF = ttDet.CodEstabelNF
       AND   ttDFeReferenciado.SerieNF      = ttDet.SerieNF
       AND   ttDFeReferenciado.NrNotaFisNF  = ttDet.NrNotaFisNF
       AND   ttDFeReferenciado.ItCodigoNF   = ttDet.ItCodigoNF
       AND   ttDFeReferenciado.NrSeqFatNF   = ttDet.NrSeqFatNF:

       RUN addNode IN hGenXml (getStack(), "DFeReferenciado", "", OUTPUT iId).
       addStack(iId).
            {adapters/xml/ep2/axsep037nodechar.i "chaveAcesso"  ttDFeReferenciado.chaveAcesso   "YES"}             
              
            IF ttDFeReferenciado.nItem = "0" THEN 
                ASSIGN ttDFeReferenciado.nItem = STRING(iContItem).  
            
            IF ttIde.tpNFDebito <> "03" THEN                
              {adapters/xml/ep2/axsep037nodechar.i "nItem"      ttDFeReferenciado.nItem       "NO" }
       delStack().
   END.

   RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-imprime-is:

   FOR FIRST ttTribRT
       WHERE ttTribRT.CodEstabelNF =  ttDet.CodEstabelNF
         AND ttTribRT.SerieNF      =  ttDet.SerieNF     
         AND ttTribRT.NrNotaFisNF  =  ttDet.NrNotaFisNF 
         AND ttTribRT.NrSeqFatNF   =  ttDet.NrSeqFatNF
         AND ttTribRT.ItCodigoNF   =  ttDet.ItCodigoNF
         AND ttTribRT.TipTributo   = 4: /** Esse grupo imprime o IS **/
             
         RUN addNode IN hGenXml (getStack(), "IS", "", OUTPUT iId).
         addStack(iId).
              // CSTIS - Definida variavel e mostrada em branco porque ainda n∆o foi publicada a tabela cd cClass do IS e para n∆o ocorrer erro de compilaá∆o
              {adapters/xml/ep2/axsep037nodechar.i "CSTIS"        ttTribRT.CST                      "YES"          }
              // cClassTribIS - Definida variavel e mostrada em branco porque ainda n∆o foi publicada a tabela cd cClass do IS e para n∆o ocorrer erro de compilaá∆o
              {adapters/xml/ep2/axsep037nodechar.i "cClassTribIS" ttTribRT.cClassTribIS               "YES"          }
              //vBCIS - Mostrado zerado porque n∆o foi criado registro do CST e cClass conforme informado acima. A base de c†lculo fica na mesma tt do CST e cClass
              {adapters/xml/ep2/axsep037nodedec.i  "vBCIS"        ttTribRT.vBCIS                            "YES" "2" "YES"}
              {adapters/xml/ep2/axsep037nodedec.i  "pIS"          ttTribRT.pAliqEfet           "YES" "4" "YES"}
              {adapters/xml/ep2/axsep037nodedec.i  "adRemIS"      ttTribRT.adRemIS             "NO"  "4" "YES"}

            IF ttTribRT.qTrib > 0 THEN DO: 
              {adapters/xml/ep2/axsep037nodechar.i "uTrib"        ttTribRT.uTrib               "YES"          }
              {adapters/xml/ep2/axsep037nodedec.i  "qTrib"        ttTribRT.qTrib               "YES" "4" "YES"}
            END.

              {adapters/xml/ep2/axsep037nodedec.i  "vIS"          ttTribRT.vTrib               "YES" "2" "YES"}
         delStack().  
   END.
          
   RETURN "OK":U.
   
END PROCEDURE.

PROCEDURE pi-imprime-gTribCompraGov:

   FOR FIRST ttgTribCompraGov 
       WHERE ttgTribCompraGov.CodEstabelNF  = ttDet.CodEstabelNF
       AND   ttgTribCompraGov.SerieNF       = ttDet.SerieNF
       AND   ttgTribCompraGov.NrNotaFisNF   = ttDet.NrNotaFisNF
       AND   ttgTribCompraGov.ItCodigoNF    = ttDet.ItCodigoNF
       AND   ttgTribCompraGov.NrSeqFatNF    = ttDet.NrSeqFatNF:
       
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

PROCEDURE pi-grava-seq-item-xml:

    FOR FIRST it-nota-fisc 
        WHERE it-nota-fisc.cod-estabel = ttDet.CodEstabelNF
          AND it-nota-fisc.serie       = ttDet.SerieNF
          AND it-nota-fisc.nr-nota-fis = ttDet.NrNotaFisNF
          AND it-nota-fisc.it-codigo   = ttDet.ItCodigoNF 
          AND it-nota-fisc.nr-seq-fat  = ttDet.NrSeqFatNF EXCLUSIVE-LOCK:
                                      
       OVERLAY(it-nota-fisc.char-2,370,5) = STRING(iContItem).
    END. 

    IF NOT AVAIL ttIde THEN
       FIND FIRST ttIde NO-ERROR.

    IF ttIde.tpNF = "0" THEN DO: /*Nota de entrada*/
       FOR FIRST nota-fiscal NO-LOCK
           WHERE nota-fiscal.cod-estabel = ttDet.CodEstabelNF
             AND nota-fiscal.serie       = ttDet.SerieNF
             AND nota-fiscal.nr-nota-fis = ttDet.NrNotaFisNF:
           
           FOR FIRST it-nota-fisc OF nota-fiscal NO-LOCK
               WHERE it-nota-fisc.it-codigo   = ttDet.ItCodigoNF 
                 AND it-nota-fisc.nr-seq-fat  = ttDet.NrSeqFatNF:
                
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

                            ASSIGN OVERLAY(ext-item-doc-est.cod-livre-1,1,120) = ttDet.xProd
                                   OVERLAY(ext-item-doc-est.cod-livre-2,1,6)   = ttDet.uCom.               
                  END.
                  ELSE DO:
                  
                     FOR FIRST ext-item-doc-est EXCLUSIVE-LOCK
                         WHERE ext-item-doc-est.serie-docto  = item-doc-est.serie-docto
                           AND ext-item-doc-est.nro-docto    = item-doc-est.nro-docto
                           AND ext-item-doc-est.cod-emitente = item-doc-est.cod-emitente
                           AND ext-item-doc-est.sequencia    = item-doc-est.sequencia
                           AND ext-item-doc-est.cod-param    = "infoXML":U:
                           
                        ASSIGN OVERLAY(ext-item-doc-est.cod-livre-1,1,120) = ttDet.xProd
                               OVERLAY(ext-item-doc-est.cod-livre-2,1,6) = ttDet.uCom.
                     END.
                  END.
               END.
           END.
        END.
    END.

   RETURN "OK":U.
END PROCEDURE.


