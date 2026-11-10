/*-------------------------------------------------
            AXSEP006ImprimeXML.i
-------------------------------------------------*/


PROCEDURE pi-imprime-xml:

    ASSIGN iId = ?.

    FOR EACH ttNFe:

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
                
                                   RUN pi-imprime-DI.
                
                                   RUN pi-imprime-Veic.
                
                                   RUN pi-imprime-Med.
                
                                   RUN pi-imprime-Arma.
                
                                   RUN pi-imprime-Comb.
                
                              delStack().
                
                              RUN addNode IN hGenXml (getStack(), "imposto", "", OUTPUT iId).
                              addStack(iId).

                                   RUN pi-imprime-ICMS.
                                   
                                   RUN pi-imprime-IPI.
                
                                   RUN pi-imprime-II.
                
                                   RUN pi-imprime-PIS.
                
                                   RUN pi-imprime-COFINS.
                
                                   RUN pi-imprime-ISSQN.
                              delStack().
                
                              {adapters/xml/ep2/axsep006nodechar.i "infAdProd" ttDet.infAdProd "NO"}
                
                         delStack().
                
                         ASSIGN iContItem = iContItem + 1.
                   END.
                   
                   RUN pi-imprime-Total.

                   RUN pi-imprime-Transp.

                   RUN pi-imprime-Cobr.

                   RUN pi-imprime-InfAdic.

                   RUN pi-imprime-Exporta.

                   RUN pi-imprime-Compra.

              delStack().

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

                                        {adapters/xml/ep2/axsep006nodechar.i "cUF"      ttIde.cUF     "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "cNF"      ttIde.cNF     "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "natOp"    ttIde.natOp   "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "indPag"   ttIde.indPag  "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "mod"      ttIde.mod     "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "serie"    ttIde.serie   "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "nNF"      ttIde.nNF     "YES"} 
                                        {adapters/xml/ep2/axsep006nodedate.i "dEmi"     ttIde.dEmi    "YES"}
                                        {adapters/xml/ep2/axsep006nodedate.i "dSaiEnt"  ttIde.dSaiEnt "NO" }
                                        {adapters/xml/ep2/axsep006nodechar.i "tpNF"     ttIde.tpNF    "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "cMunFG"   ttIde.cMunFG  "YES"}

                                        FOR EACH  ttNFRef
                                           WHERE  ttNFRef.CodEstabelNF = ttIde.CodEstabelNF
                                             AND  ttNFRef.SerieNF      = ttIde.SerieNF     
                                             AND  ttNFRef.NrNotaFisNF  = ttIde.NrNotaFisNF :

                                             RUN addNode IN hGenXml (getStack(), "NFref", "", OUTPUT iId).
                                             addStack(iId).

                                                  /* Nota Eletronica, envia somente tag <refNFe> */
                                                  IF  ttNFRef.refNFe <> "" THEN DO:
                                                      {adapters/xml/ep2/axsep006nodechar.i "refNFe"   ttNFRef.refNFe  "YES"}
                                                  END.
                                                  /* Nao e' Nota Eletronica, enviar colecao <refNF> */
                                                  ELSE DO:
                                                  
                                                      RUN addNode IN hGenXml (getStack(), "refNF",  "",             OUTPUT iId).
                                                      addStack(iId).
    
                                                           {adapters/xml/ep2/axsep006nodechar.i "cUF"   ttNFRef.cUF   "YES"}
                                                           {adapters/xml/ep2/axsep006nodechar.i "AAMM"  ttNFRef.AAMM  "YES"}
                                                           {adapters/xml/ep2/axsep006nodechar.i "CNPJ"  ttNFRef.CNPJ  "YES"}
                                                           {adapters/xml/ep2/axsep006nodechar.i "mod"   ttNFRef.mod   "YES"}
                                                           {adapters/xml/ep2/axsep006nodechar.i "serie" ttNFRef.serie "YES"}
                                                           {adapters/xml/ep2/axsep006nodechar.i "nNF"   ttNFRef.nNF   "YES"}
                                                           
                                                      delStack().
                                                  END.

                                             delStack().

                                        END.
                                        {adapters/xml/ep2/axsep006nodechar.i "tpImp"   ttIde.tpImp   "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "tpEmis"  ttIde.tpEmis  "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "cDV"     ttIde.cDV     "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "tpAmb"   ttIde.tpAmb   "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "finNFe"  ttIde.finNFe  "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "procEmi" ttIde.procEmi "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "verProc" ttIde.verProc "YES"}
                                   delStack().

                              END.

END PROCEDURE.

PROCEDURE pi-imprime-Emit:

                              FOR EACH ttEmit
                                 WHERE ttEmit.CodEstabelNF = ttNFe.CodEstabelNF
                                   AND ttEmit.SerieNF      = ttNFe.SerieNF     
                                   AND ttEmit.NrNotaFisNF  = ttNFe.NrNotaFisNF:
                                  
                                   RUN addNode IN hGenXml (getStack(), "emit", "", OUTPUT iId).
                                   addStack(iId).

                                        {adapters/xml/ep2/axsep006nodechar.i "CNPJ"  ttEmit.CNPJ  "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "xNome" ttEmit.xNome "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "xFant" ttEmit.xFant "NO" }

                                        RUN addNode IN hGenXml (getStack(), "enderEmit", "",           OUTPUT iId).
                                        addStack(iId).
                                             {adapters/xml/ep2/axsep006nodechar.i "xLgr"    ttEmit.xLgr    "YES"}
                                             {adapters/xml/ep2/axsep006nodechar.i "nro"     ttEmit.nro     "YES"}
                                             {adapters/xml/ep2/axsep006nodechar.i "xCpl"    ttEmit.xCpl    "NO" }
                                             {adapters/xml/ep2/axsep006nodechar.i "xBairro" ttEmit.xBairro "YES"}
                                             {adapters/xml/ep2/axsep006nodechar.i "cMun"    ttEmit.cMun    "YES"}
                                             IF ttEmit.xMun = "Exterior" THEN DO:
                                                ASSIGN c-string-sem-acento = fn-free-accent(ttEmit.xMun)                                   
                                                       c-string-sem-acento = fn-trata-caracteres(c-string-sem-acento)
                                                       c-string-sem-acento = REPLACE(TRIM(c-string-sem-acento),CHR(10),"").        
                                                END.
                                             ELSE DO:
                                                ASSIGN c-string-sem-acento = fn-free-accent(ttEmit.xMun)                                   
                                                       c-string-sem-acento = fn-trata-caracteres(c-string-sem-acento)
                                                       c-string-sem-acento = REPLACE(TRIM(CAPS(c-string-sem-acento)),CHR(10),"").  
                                             END.
                                             IF  lLayoutXML THEN
                                                 RUN addNode IN hGenXml (getStack(), "xMun", c-string-sem-acento, OUTPUT iId).
                                             ELSE IF  lLayoutTXT THEN DO:
                                                 ASSIGN c-string-sem-acento = (IF c-string-sem-acento = ?
                                                                               THEN " "
                                                                               ELSE c-string-sem-acento).
                                                 
                                                 PUT UNFORMATTED c-string-sem-acento "|".
                                             END.
                                             {adapters/xml/ep2/axsep006nodechar.i "UF"      ttEmit.UF      "YES"}
                                             {adapters/xml/ep2/axsep006nodechar.i "CEP"     ttEmit.CEP     "NO" }
                                             {adapters/xml/ep2/axsep006nodechar.i "cPais"   ttEmit.cPais   "NO" }
                                             {adapters/xml/ep2/axsep006nodechar.i "xPais"   ttEmit.xPais   "NO" }
                                             {adapters/xml/ep2/axsep006nodechar.i "fone"    ttEmit.fone    "NO" }
                                        delStack().

                                        {adapters/xml/ep2/axsep006nodechar.i "IE"   ttEmit.IE   "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "IEST" ttEmit.IEST "NO" }
                                        {adapters/xml/ep2/axsep006nodechar.i "IM"   ttEmit.IM   "NO" }
                                        {adapters/xml/ep2/axsep006nodechar.i "CNAE" ttEmit.CNAE "NO" }
                                   delStack().

                              END.

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

                                        {adapters/xml/ep2/axsep006nodechar.i "CNPJ"    ttAvulsa.CNPJ    "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "xOrgao"  ttAvulsa.xOrgao  "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "matr"    ttAvulsa.matr    "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "xAgente" ttAvulsa.xAgente "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "fone"    ttAvulsa.fone    "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "UF"      ttAvulsa.UF      "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "nDAR"    ttAvulsa.nDAR    "YES"}
                                        {adapters/xml/ep2/axsep006nodedate.i "dEmi"    ttAvulsa.dEmi    "YES"}
                                        {adapters/xml/ep2/axsep006nodedec.i  "vDAR"    ttAvulsa.vDAR    "YES" "2"}
                                        {adapters/xml/ep2/axsep006nodechar.i "repEmi"  ttAvulsa.repEmi  "YES"}
                                        {adapters/xml/ep2/axsep006nodedate.i "dPag"    ttAvulsa.dPag    "NO" }
                                   delStack().

                              END.

END PROCEDURE.

PROCEDURE pi-imprime-Dest:

                              FOR EACH ttDest
                                 WHERE ttDest.CodEstabelNF = ttNFe.CodEstabelNF
                                   AND ttDest.SerieNF      = ttNFe.SerieNF     
                                   AND ttDest.NrNotaFisNF  = ttNFe.NrNotaFisNF:
                                  
                                   RUN addNode IN hGenXml (getStack(), "dest", "", OUTPUT iId).
                                   addStack(iId).

                                        IF  ttDest.i-natureza = 1 THEN DO: /* Pessoa F°sica */
                                        {adapters/xml/ep2/axsep006nodechar.i "CPF"        ttDest.CPF   "YES"}
                                        END.
                                        ELSE DO:
                                        {adapters/xml/ep2/axsep006nodechar.i "CNPJ"       ttDest.CNPJ  "YES"} 
                                        END.
                                        
                                        {adapters/xml/ep2/axsep006nodechar.i "xNome"      ttDest.xNome "YES"}

                                        RUN addNode IN hGenXml (getStack(), "enderDest", "",           OUTPUT iId).
                                        addStack(iId).

                                             {adapters/xml/ep2/axsep006nodechar.i "xLgr"    ttDest.xLgr    "YES"}
                                             {adapters/xml/ep2/axsep006nodechar.i "nro"     ttDest.nro     "YES"}
                                             {adapters/xml/ep2/axsep006nodechar.i "xCpl"    ttDest.xCpl    "NO" }
                                             {adapters/xml/ep2/axsep006nodechar.i "xBairro" ttDest.xBairro "YES"}
                                             {adapters/xml/ep2/axsep006nodechar.i "cMun"    ttDest.cMun    "YES"}
                                             IF ttDest.xMun = "Exterior" THEN DO:
                                                ASSIGN c-string-sem-acento = fn-free-accent(ttDest.xMun)                                   
                                                       c-string-sem-acento = fn-trata-caracteres(c-string-sem-acento)
                                                       c-string-sem-acento = REPLACE(TRIM(c-string-sem-acento),CHR(10),"").        
                                                END.
                                             ELSE DO:
                                                ASSIGN c-string-sem-acento = fn-free-accent(ttDest.xMun)                                   
                                                       c-string-sem-acento = fn-trata-caracteres(c-string-sem-acento)
                                                       c-string-sem-acento = REPLACE(TRIM(CAPS(c-string-sem-acento)),CHR(10),"").  
                                             END.
                                             IF  lLayoutXML THEN
                                                 RUN addNode IN hGenXml (getStack(), "xMun", c-string-sem-acento, OUTPUT iId).
                                             ELSE IF  lLayoutTXT THEN DO:
                                                 ASSIGN c-string-sem-acento = (IF c-string-sem-acento = ?
                                                                               THEN " "
                                                                               ELSE c-string-sem-acento).
                                                 
                                                 PUT UNFORMATTED c-string-sem-acento "|".
                                             END.
                                             {adapters/xml/ep2/axsep006nodechar.i "UF"      ttDest.UF      "YES"}
                                             {adapters/xml/ep2/axsep006nodechar.i "CEP"     ttDest.CEP     "NO" }
                                             {adapters/xml/ep2/axsep006nodechar.i "cPais"   ttDest.cPais   "NO" }
                                             {adapters/xml/ep2/axsep006nodechar.i "xPais"   ttDest.xPais   "NO" }
                                             {adapters/xml/ep2/axsep006nodechar.i "fone"    ttDest.fone    "NO" }
                                        delStack().

                                        {adapters/xml/ep2/axsep006nodechar.i "IE"   ttDest.IE   "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "ISUF" ttDest.ISUF "NO" }
                                   delStack().

                              END.

END PROCEDURE.

PROCEDURE pi-imprime-Retirada:

                              FOR EACH  ttRetirada
                                 WHERE  ttRetirada.CodEstabelNF = ttNFe.CodEstabelNF
                                   AND  ttRetirada.SerieNF      = ttNFe.SerieNF     
                                   AND  ttRetirada.NrNotaFisNF  = ttNFe.NrNotaFisNF
                                   AND (ttRetirada.CNPJ    <> "" AND ttRetirada.CNPJ    <> ?)
                                   AND (ttRetirada.xLgr    <> "" AND ttRetirada.xLgr    <> ?)
                                   AND (ttRetirada.nro     <> "" AND ttRetirada.nro     <> ?)
                                   AND (ttRetirada.xBairro <> "" AND ttRetirada.xBairro <> ?)
                                   AND (ttRetirada.cMun    <> "" AND ttRetirada.cMun    <> ?)
                                   AND (ttRetirada.xMun    <> "" AND ttRetirada.xMun    <> ?)
                                   AND (ttRetirada.UF      <> "" AND ttRetirada.UF      <> ?) :

                                   RUN addNode IN hGenXml (getStack(), "retirada", "", OUTPUT iId).
                                   addStack(iId).

                                        {adapters/xml/ep2/axsep006nodechar.i "CNPJ"    ttRetirada.CNPJ    "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "xLgr"    ttRetirada.xLgr    "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "nro"     ttRetirada.nro     "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "xCpl"    ttRetirada.xCpl    "NO" }
                                        {adapters/xml/ep2/axsep006nodechar.i "xBairro" ttRetirada.xBairro "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "cMun"    ttRetirada.cMun    "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "xMun"    ttRetirada.xMun    "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "UF"      ttRetirada.UF      "YES"}
                                   delStack().

                              END.

END PROCEDURE.

PROCEDURE pi-imprime-Entrega:

                              FOR EACH  ttEntrega
                                 WHERE  ttEntrega.CodEstabelNF = ttNFe.CodEstabelNF
                                   AND  ttEntrega.SerieNF      = ttNFe.SerieNF     
                                   AND  ttEntrega.NrNotaFisNF  = ttNFe.NrNotaFisNF
                                   AND (ttEntrega.CNPJ    <> "" AND ttEntrega.CNPJ    <> ?)
                                   AND (ttEntrega.xLgr    <> "" AND ttEntrega.xLgr    <> ?)
                                   AND (ttEntrega.nro     <> "" AND ttEntrega.nro     <> ?)
                                   AND (ttEntrega.xBairro <> "" AND ttEntrega.xBairro <> ?)
                                   AND (ttEntrega.cMun    <> "" AND ttEntrega.cMun    <> ?)
                                   AND (ttEntrega.xMun    <> "" AND ttEntrega.xMun    <> ?)
                                   AND (ttEntrega.UF      <> "" AND ttEntrega.UF      <> ?) ,
                                 /* S¢ imprimir <entrega> quando for diferente do destinat†rio */
                                 FIRST  ttDest NO-LOCK
                                 WHERE  ttDest.CodEstabelNF = ttNFe.CodEstabelNF
                                   AND  ttDest.SerieNF      = ttNFe.SerieNF     
                                   AND  ttDest.NrNotaFisNF  = ttNFe.NrNotaFisNF
                                   AND (ttDest.CNPJ        <> ttEntrega.CNPJ
                                    OR  ttDest.xLgr        <> ttEntrega.xLgr
                                    OR  ttDest.nro         <> ttEntrega.nro
                                    OR  ttDest.xCpl        <> ttEntrega.xCpl
                                    OR  ttDest.xBairro     <> ttEntrega.xBairro
                                    OR  ttDest.xMun        <> ttEntrega.xMun
                                    OR  ttDest.UF          <> ttEntrega.UF) :


                                   RUN addNode IN hGenXml (getStack(), "entrega", "", OUTPUT iId).
                                   addStack(iId).

                                        {adapters/xml/ep2/axsep006nodechar.i "CNPJ"    ttEntrega.CNPJ    "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "xLgr"    ttEntrega.xLgr    "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "nro"     ttEntrega.nro     "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "xCpl"    ttEntrega.xCpl    "NO" }
                                        {adapters/xml/ep2/axsep006nodechar.i "xBairro" ttEntrega.xBairro "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "cMun"    ttEntrega.cMun    "YES"}
                                        IF ttEntrega.xMun = "Exterior" THEN DO:
                                           ASSIGN c-string-sem-acento = fn-free-accent(ttEntrega.xMun)                                   
                                                  c-string-sem-acento = fn-trata-caracteres(c-string-sem-acento)
                                                  c-string-sem-acento = REPLACE(TRIM(c-string-sem-acento),CHR(10),"").        
                                           END.
                                        ELSE DO:
                                           ASSIGN c-string-sem-acento = fn-free-accent(ttEntrega.xMun)                                   
                                                  c-string-sem-acento = fn-trata-caracteres(c-string-sem-acento)
                                                  c-string-sem-acento = REPLACE(TRIM(CAPS(c-string-sem-acento)),CHR(10),"").  
                                        END.
                                        IF  lLayoutXML THEN
                                            RUN addNode IN hGenXml (getStack(), "xMun", c-string-sem-acento, OUTPUT iId).
                                        ELSE IF  lLayoutTXT THEN DO:
                                            ASSIGN c-string-sem-acento = (IF c-string-sem-acento = ?
                                                                          THEN " "
                                                                          ELSE c-string-sem-acento).
                                            
                                            PUT UNFORMATTED c-string-sem-acento "|".
                                        END.
                                        {adapters/xml/ep2/axsep006nodechar.i "UF"      ttEntrega.UF      "YES"}
                                   delStack().

                              END.

END PROCEDURE.

PROCEDURE pi-imprime-Prod:

                                             {adapters/xml/ep2/axsep006nodechar.i "cProd"    ttDet.cProd    "YES"}
                                             {adapters/xml/ep2/axsep006nodechar.i "cEAN"     ttDet.cEAN     "YES"}
                                             {adapters/xml/ep2/axsep006nodechar.i "xProd"    ttDet.xProd    "YES"}
                                             {adapters/xml/ep2/axsep006nodechar.i "NCM"      ttDet.NCM      "NO" }
                                             {adapters/xml/ep2/axsep006nodechar.i "EXTIPI"   ttDet.EXTIPI   "NO" }
                                             {adapters/xml/ep2/axsep006nodechar.i "genero"   ttDet.genero   "NO" }
                                             {adapters/xml/ep2/axsep006nodechar.i "CFOP"     ttDet.CFOP     "YES"}
                                             {adapters/xml/ep2/axsep006nodechar.i "uCom"     ttDet.uCom     "YES"}
                                             {adapters/xml/ep2/axsep006nodedec.i  "qCom"     ttDet.qCom     "YES" "4"}
                                             {adapters/xml/ep2/axsep006nodedec.i  "vUnCom"   ttDet.vUnCom   "YES" "4"}
                                             {adapters/xml/ep2/axsep006nodedec.i  "vProd"    ttDet.vProd    "YES" "2"}
                                             {adapters/xml/ep2/axsep006nodechar.i "cEANTrib" ttDet.cEANTrib "YES"}
                                             {adapters/xml/ep2/axsep006nodechar.i "uTrib"    ttDet.uTrib    "YES"}
                                             {adapters/xml/ep2/axsep006nodedec.i  "qTrib"    ttDet.qTrib    "YES" "4"} 
                                             {adapters/xml/ep2/axsep006nodedec.i  "vUnTrib"  ttDet.vUnTrib  "YES" "4"}
                                             {adapters/xml/ep2/axsep006nodedec.i  "vFrete"   ttDet.vFrete   "NO" "2"}
                                             {adapters/xml/ep2/axsep006nodedec.i  "vSeg"     ttDet.vSeg     "NO" "2"}
                                             {adapters/xml/ep2/axsep006nodedec.i  "vDesc"    ttDet.vDesc    "NO" "2"}

END PROCEDURE.

PROCEDURE pi-imprime-DI:

                                             FOR EACH  ttDI NO-LOCK
                                                WHERE  ttDI.CodEstabelNF = ttDet.CodEstabelNF
                                                  AND  ttDI.SerieNF      = ttDet.SerieNF     
                                                  AND  ttDI.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                  AND  ttDI.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                  AND  ttDI.ItCodigoNF   = ttDet.ItCodigoNF
                                                  AND (ttDI.nDI         <> "" AND ttDI.nDI         <> ?)
                                                  AND (ttDI.dDI         <> ?                           )
                                                  AND (ttDI.xLocDesemb  <> "" AND ttDI.xLocDesemb  <> ?)
                                                  AND (ttDI.UFDesemb    <> "" AND ttDI.UFDesemb    <> ?)
                                                  AND (ttDI.dDesemb     <> ?                           )
                                                  AND (ttDI.cExportador <> "" AND ttDI.cExportador <> ?) :

                                                  RUN addNode IN hGenXml (getStack(), "DI", "", OUTPUT iId).
                                                  addStack(iId).

                                                       {adapters/xml/ep2/axsep006nodechar.i "nDI"         ttDI.nDI         "YES"}
                                                       {adapters/xml/ep2/axsep006nodedate.i "dDI"         ttDI.dDI         "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "xLocDesemb"  ttDI.xLocDesemb  "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "UFDesemb"    ttDI.UFDesemb    "YES"}
                                                       {adapters/xml/ep2/axsep006nodedate.i "dDesemb"     ttDI.dDesemb     "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "cExportador" ttDI.cExportador "YES"}

                RUN pi-imprime-DI2. 
                    
               delStack().

          END.

END PROCEDURE.

PROCEDURE pi-imprime-DI2:

    FOR EACH ttAdi NO-LOCK
       WHERE ttAdi.CodEstabelNF = ttDI.CodEstabelNF
         AND ttAdi.SerieNF      = ttDI.SerieNF     
         AND ttAdi.NrNotaFisNF  = ttDI.NrNotaFisNF 
         AND ttAdi.NrSeqFatNF   = ttDI.NrSeqFatNF
         AND ttAdi.ItCodigoNF   = ttDI.ItCodigoNF
         AND ttAdi.nDI          = ttDI.nDI:

         RUN addNode IN hGenXml (getStack(), "adi", "", OUTPUT iId).
         addStack(iId).

              {adapters/xml/ep2/axsep006nodechar.i "nAdicao"     ttAdi.nAdicao     "YES"}
              {adapters/xml/ep2/axsep006nodechar.i "nSeqAdic"    ttAdi.nSeqAdic    "YES"}
              {adapters/xml/ep2/axsep006nodechar.i "cFabricante" ttAdi.cFabricante "YES"}
              {adapters/xml/ep2/axsep006nodedec.i  "vDescDI"     ttAdi.vDescDI     "NO" "2"}
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

                                                       {adapters/xml/ep2/axsep006nodechar.i "tpOp"     ttVeic.tpOp     "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "chassi"   ttVeic.chassi   "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "cCor"     ttVeic.cCor     "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "xCor"     ttVeic.xCor     "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "pot"      ttVeic.pot      "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "CM3"      ttVeic.CM3      "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "pesoL"    ttVeic.pesoL    "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "pesoB"    ttVeic.pesoB    "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "nSerie"   ttVeic.nSerie   "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "tpComb"   ttVeic.tpComb   "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "nMotor"   ttVeic.nMotor   "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "CMKG"     ttVeic.CMKG     "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "dist"     ttVeic.dist     "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "RENAVAM"  ttVeic.RENAVAM  "NO" }
                                                       {adapters/xml/ep2/axsep006nodechar.i "anoMod"   ttVeic.anoMod   "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "anoFab"   ttVeic.anoFab   "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "tpPint"   ttVeic.tpPint   "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "tpVeic"   ttVeic.tpVeic   "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "espVeic"  ttVeic.espVeic  "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "VIN"      ttVeic.VIN      "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "condVeic" ttVeic.condVeic "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "cMod"     ttVeic.cMod     "YES"}
                                                  delStack().

                                             END.

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

                                                       {adapters/xml/ep2/axsep006nodechar.i "nLote" ttMed.nLote "YES"}
                                                       {adapters/xml/ep2/axsep006nodedec.i  "qLote" ttMed.qLote "YES" "3"}
                                                       {adapters/xml/ep2/axsep006nodedate.i "dFab"  ttMed.dFab  "YES"}
                                                       {adapters/xml/ep2/axsep006nodedate.i "dVal"  ttMed.dVal  "YES"}
                                                       {adapters/xml/ep2/axsep006nodedec.i  "vPMC"  ttMed.vPMC  "YES" "2"}
                                                  delStack().

                                             END.

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

                                                       {adapters/xml/ep2/axsep006nodechar.i "tpArma" ttArma.tpArma "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "nSerie" ttArma.nSerie "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "nCano"  ttArma.nCano  "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "descr"  ttArma.descr  "YES"}
                                                  delStack().

                                             END.

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

                                                       {adapters/xml/ep2/axsep006nodechar.i "cProdANP" ttComb.cProdANP "NO" }
                                                       {adapters/xml/ep2/axsep006nodechar.i "CODIF"    ttComb.CODIF    "NO" }
                                                       {adapters/xml/ep2/axsep006nodedec.i  "qTemp"    ttComb.qTemp    "NO" "4"}

                                                       IF  ttComb.qBCProd   <> ?
                                                       AND ttComb.vAliqProd <> ?
                                                       AND ttComb.vCIDE     <> ? THEN DO:
                                                       
                                                           RUN addNode IN hGenXml (getStack(), "CIDE", "", OUTPUT iId).
                                                           addStack(iId).
    
                                                                {adapters/xml/ep2/axsep006nodedec.i "qBCProd"   ttComb.qBCProd   "YES" "4"}
                                                                {adapters/xml/ep2/axsep006nodedec.i "vAliqProd" ttComb.vAliqProd "YES" "4"}
                                                                {adapters/xml/ep2/axsep006nodedec.i "vCIDE"     ttComb.vCIDE     "YES" "4"}
                                                           delStack().
                                                       END.

                                                       IF  ttComb.vBCICMS   <> ?
                                                       AND ttComb.vICMS     <> ?
                                                       AND ttComb.vBCICMSST <> ?
                                                       AND ttComb.vICMSST   <> ? THEN DO:
                                                       
                                                           RUN addNode IN hGenXml (getStack(), "ICMSComb", "", OUTPUT iId).
                                                           addStack(iId).
    
                                                                {adapters/xml/ep2/axsep006nodedec.i "vBCICMS"   ttComb.vBCICMS   "YES" "2"}
                                                                {adapters/xml/ep2/axsep006nodedec.i "vICMS"     ttComb.vICMS     "YES" "2"}
                                                                {adapters/xml/ep2/axsep006nodedec.i "vBCICMSST" ttComb.vBCICMSST "YES" "2"}
                                                                {adapters/xml/ep2/axsep006nodedec.i "vICMSST"   ttComb.vICMSST   "YES" "2"}
                                                           delStack().
                                                       END.

                                                       IF  ttComb.vBCICMSSTDest <> ?
                                                       AND ttComb.vICMSSTDest   <> ? THEN DO:
                                                       
                                                           RUN addNode IN hGenXml (getStack(), "ICMSInter", "", OUTPUT iId).
                                                           addStack(iId).
    
                                                                {adapters/xml/ep2/axsep006nodedec.i "vBCICMSSTDest" ttComb.vBCICMSSTDest "YES" "2"}
                                                                {adapters/xml/ep2/axsep006nodedec.i "vICMSSTDest"   ttComb.vICMSSTDest   "YES" "2"}
                                                           delStack().
                                                       END.

                                                       IF  ttComb.vBCICMSSTCons <> ?
                                                       AND ttComb.vICMSSTCons   <> ?
                                                       AND ttComb.UFCons        <> ? THEN DO:
                                                       
                                                           RUN addNode IN hGenXml (getStack(), "ICMSCons", "", OUTPUT iId).
                                                           addStack(iId).
    
                                                                {adapters/xml/ep2/axsep006nodedec.i  "vBCICMSSTCons" ttComb.vBCICMSSTCons "YES" "2"} 
                                                                {adapters/xml/ep2/axsep006nodedec.i  "vICMSSTCons"   ttComb.vICMSSTCons   "YES" "2"}
                                                                {adapters/xml/ep2/axsep006nodechar.i "UFCons"        ttComb.UFCons        "YES"}
                                                           delStack().
                                                       END.

                                                  delStack().

                                             END.

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

                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "orig"  ttICMS00.orig  "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "CST"   ttICMS00.CST   "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "modBC" ttICMS00.modBC "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "vBC"   ttICMS00.vBC   "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "pICMS" ttICMS00.pICMS "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "vICMS" ttICMS00.vICMS "YES" "2"}
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

                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "orig"     ttICMS10.orig     "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "CST"      ttICMS10.CST      "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "modBC"    ttICMS10.modBC    "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "vBC"      ttICMS10.vBC      "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "pICMS"    ttICMS10.pICMS    "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "vICMS"    ttICMS10.vICMS    "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "modBCST"  ttICMS10.modBCST  "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "pMVAST"   ttICMS10.pMVAST   "NO"  "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "pRedBCST" ttICMS10.pRedBCST "NO"  "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "vBCST"    ttICMS10.vBCST    "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "pICMSST"  ttICMS10.pICMSST  "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "vICMSST"  ttICMS10.vICMSST  "YES" "2"}
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
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "orig"   ttICMS20.orig   "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "CST"    ttICMS20.CST    "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "modBC"  ttICMS20.modBC  "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "pRedBC" ttICMS20.pRedBC "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "vBC"    ttICMS20.vBC    "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "pICMS"  ttICMS20.pICMS  "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "vICMS"  ttICMS20.vICMS  "YES" "2"}
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
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "orig"     ttICMS30.orig     "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "CST"      ttICMS30.CST      "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "modBCST"  ttICMS30.modBCST  "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "pMVAST"   ttICMS30.pMVAST   "NO"  "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "pRedBCST" ttICMS30.pRedBCST "NO"  "2"} 
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "vBCST"    ttICMS30.vBCST    "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "pICMSST"  ttICMS30.pICMSST  "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "vICMSST"  ttICMS30.vICMSST  "YES" "2"}
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
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "orig" ttICMS40.orig "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "CST"  ttICMS40.CST  "YES"}
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
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "orig"   ttICMS51.orig   "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "CST"    ttICMS51.CST    "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "modBC"  ttICMS51.modBC  "NO" }
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "pRedBC" ttICMS51.pRedBC "NO"  "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "vBC"    ttICMS51.vBC    "NO"  "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "pICMS"  ttICMS51.pICMS  "NO"  "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "vICMS"  ttICMS51.vICMS  "NO"  "2"}
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
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "orig"    ttICMS60.orig    "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "CST"     ttICMS60.CST     "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "vBCST"   ttICMS60.vBCST   "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "vICMSST" ttICMS60.vICMSST "YES" "2"}
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
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "orig"     ttICMS70.orig     "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "CST"      ttICMS70.CST      "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "modBC"    ttICMS70.modBC    "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "pRedBC"   ttICMS70.pRedBC   "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "vBC"      ttICMS70.vBC      "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "pICMS"    ttICMS70.pICMS    "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "vICMS"    ttICMS70.vICMS    "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "modBCST"  ttICMS70.modBCST  "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "pMVAST"   ttICMS70.pMVAST   "NO"  "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "pRedBCST" ttICMS70.pRedBCST "NO"  "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "vBCST"    ttICMS70.vBCST    "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "pICMSST"  ttICMS70.pICMSST  "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "vICMSST"  ttICMS70.vICMSST  "YES" "2"}
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
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "orig"     ttICMS90.orig     "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "CST"      ttICMS90.CST      "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "modBC"    ttICMS90.modBC    "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "vBC"      ttICMS90.vBC      "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "pRedBC"   ttICMS90.pRedBC   "NO"  "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "pICMS"    ttICMS90.pICMS    "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "vICMS"    ttICMS90.vICMS    "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodechar.i "modBCST"  ttICMS90.modBCST  "YES"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "pMVAST"   ttICMS90.pMVAST   "NO"  "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "pRedBCST" ttICMS90.pRedBCST "NO"  "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "vBCST"    ttICMS90.vBCST    "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "pICMSST"  ttICMS90.pICMSST  "YES" "2"}
                                                            {adapters~/xml~/ep2~/axsep006nodedec.i  "vICMSST"  ttICMS90.vICMSST  "YES" "2"}
                                                       delStack().
                                                  END.
                                             delStack().

END PROCEDURE.

PROCEDURE pi-imprime-IPI:

                                             FOR EACH ttIPI
                                                WHERE ttIPI.CodEstabelNF = ttDet.CodEstabelNF
                                                  AND ttIPI.SerieNF      = ttDet.SerieNF     
                                                  AND ttIPI.NrNotaFisNF  = ttDet.NrNotaFisNF 
                                                  AND ttIPI.NrSeqFatNF   = ttDet.NrSeqFatNF
                                                  AND ttIPI.ItCodigoNF   = ttDet.ItCodigoNF :
                                                 
                                                  RUN addNode IN hGenXml (getStack(), "IPI", "", OUTPUT iId).
                                                  addStack(iId).

                                                       {adapters/xml/ep2/axsep006nodechar.i "clEnq"    ttIPI.clEnq    "NO" }
                                                       {adapters/xml/ep2/axsep006nodechar.i "CNPJProd" ttIPI.CNPJProd "NO" }
                                                       {adapters/xml/ep2/axsep006nodechar.i "cSelo"    ttIPI.cSelo    "NO" }
                                                       {adapters/xml/ep2/axsep006nodechar.i "qSelo"    ttIPI.qSelo    "NO" }
                                                       {adapters/xml/ep2/axsep006nodechar.i "cEnq"     ttIPI.cEnq     "YES"}

                                                       IF  NOT ttIPI.l-ipi-trib THEN DO:

                                                           RUN addNode IN hGenXml (getStack(), "IPINT", "", OUTPUT iId).
                                                           addStack(iId).
    
                                                                {adapters/xml/ep2/axsep006nodechar.i "CST"   ttIPI.CSTIPINT "YES"}
                                                           delStack().
                                                       
                                                       END.
                                                       ELSE DO:
                                                       
                                                           RUN addNode IN hGenXml (getStack(), "IPITrib",  "",             OUTPUT iId).
                                                           addStack(iId).
    
                                                                {adapters/xml/ep2/axsep006nodechar.i "CST"   ttIPI.CSTIPITrib "YES"}
                                                                {adapters/xml/ep2/axsep006nodedec.i  "vBC"   ttIPI.vBC        "YES" "2"}
                                                                {adapters/xml/ep2/axsep006nodedec.i  "pIPI"  ttIPI.pIPI       "YES" "2"}
                                                                /*{adapters/xml/ep2/axsep006nodedec.i  "qUnid" ttIPI.qUnid      "YES" "4"}*/  /*----  IPI por Unidade (n∆o tratado pelo mapa Neogrid) ---*/
                                                                /*{adapters/xml/ep2/axsep006nodedec.i  "vUnid" ttIPI.vUnid      "YES" "4"}*/
                                                                {adapters/xml/ep2/axsep006nodedec.i  "vIPI"  ttIPI.vIPI       "YES" "2"}
                                                           delStack().

                                                       END.

                                                  delStack().

                                             END.

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

                                                       {adapters/xml/ep2/axsep006nodedec.i "vBC"      ttII.vBC      "YES" "2"}
                                                       {adapters/xml/ep2/axsep006nodedec.i "vDespAdu" ttII.vDespAdu "YES" "2"}
                                                       {adapters/xml/ep2/axsep006nodedec.i "vII"      ttII.vII      "YES" "2"}
                                                       {adapters/xml/ep2/axsep006nodedec.i "vIOF"     ttII.vIOF     "YES" "2"}
                                                  delStack().

                                             END.

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
    
                                                                {adapters/xml/ep2/axsep006nodechar.i "CST"  ttPISAliq.CST  "YES"}
                                                                {adapters/xml/ep2/axsep006nodedec.i  "vBC"  ttPISAliq.vBC  "YES" "2"}
                                                                {adapters/xml/ep2/axsep006nodedec.i  "pPIS" ttPISAliq.pPIS "YES" "2"}
                                                                {adapters/xml/ep2/axsep006nodedec.i  "vPIS" ttPISAliq.vPIS "YES" "2"}
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
    
                                                                {adapters/xml/ep2/axsep006nodechar.i "CST"       ttPISQtde.CST       "YES"}
                                                                {adapters/xml/ep2/axsep006nodedec.i  "qBCProd"   ttPISQtde.qBCProd   "YES" "4"}
                                                                {adapters/xml/ep2/axsep006nodedec.i  "vAliqProd" ttPISQtde.vAliqProd "YES" "4"}
                                                                {adapters/xml/ep2/axsep006nodedec.i  "vPIS"      ttPISQtde.vPIS      "YES" "2"}
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
    
                                                                {adapters/xml/ep2/axsep006nodechar.i "CST" ttPISNT.CST "YES"}
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
    
                                                                {adapters/xml/ep2/axsep006nodechar.i "CST"       ttPISOutr.CST "YES"}
    
                                                                IF  ttPISOutr.vAliqProd <> 0
                                                                AND ttPISOutr.vAliqProd <> ? THEN DO:
                                                                    {adapters/xml/ep2/axsep006nodedec.i "qBCProd"   ttPISOutr.qBCProd   "YES" "4"}
                                                                    {adapters/xml/ep2/axsep006nodedec.i "vAliqProd" ttPISOutr.vAliqProd "YES" "4"}
                                                                END.
                                                                ELSE DO:
                                                                    {adapters/xml/ep2/axsep006nodedec.i "vBC"       ttPISOutr.vBC  "YES" "2"}
                                                                    {adapters/xml/ep2/axsep006nodedec.i "pPIS"      ttPISOutr.pPIS "YES" "2"}
                                                                END.
    
                                                                {adapters/xml/ep2/axsep006nodedec.i  "vPIS"      ttPISOutr.vPIS "YES" "2"}
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

                                                           {adapters/xml/ep2/axsep006nodedec.i "qBCProd"   ttPISST.qBCProd   "YES" "4"}
                                                           {adapters/xml/ep2/axsep006nodedec.i "vAliqProd" ttPISST.vAliqProd "YES" "4"}
                                                       END.
                                                       ELSE DO:
                                                           {adapters/xml/ep2/axsep006nodedec.i "vBC"       ttPISST.vBC       "YES" "2"}
                                                           {adapters/xml/ep2/axsep006nodedec.i "pPIS"      ttPISST.pPIS      "YES" "2"}
                                                       END.

                                                       {adapters/xml/ep2/axsep006nodedec.i "vPIS"      ttPISST.vPIS      "YES" "2"}
                                                  delStack().

                                             END.

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
    
                                                                {adapters/xml/ep2/axsep006nodechar.i "CST"     ttCOFINSAliq.CST     "YES"}
                                                                {adapters/xml/ep2/axsep006nodedec.i  "vBC"     ttCOFINSAliq.vBC     "YES" "2"}
                                                                {adapters/xml/ep2/axsep006nodedec.i  "pCOFINS" ttCOFINSAliq.pCOFINS "YES" "2"}
                                                                {adapters/xml/ep2/axsep006nodedec.i  "vCOFINS" ttCOFINSAliq.vCOFINS "YES" "2"}
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
    
                                                                {adapters/xml/ep2/axsep006nodechar.i "CST"       ttCOFINSQtde.CST       "YES"}
                                                                {adapters/xml/ep2/axsep006nodedec.i  "qBCProd"   ttCOFINSQtde.qBCProd   "YES" "4"}
                                                                {adapters/xml/ep2/axsep006nodedec.i  "vAliqProd" ttCOFINSQtde.vAliqProd "YES" "4"}
                                                                {adapters/xml/ep2/axsep006nodedec.i  "vCOFINS"   ttCOFINSQtde.vCOFINS   "YES" "2"}
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
    
                                                                {adapters/xml/ep2/axsep006nodechar.i "CST" ttCOFINSNT.CST "YES"}
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
    
                                                                {adapters/xml/ep2/axsep006nodechar.i "CST"       ttCOFINSOutr.CST "YES"}
    
                                                                IF  ttCOFINSOutr.vAliqProd <> 0
                                                                AND ttCOFINSOutr.vAliqProd <> ? THEN DO:
                                                                    {adapters/xml/ep2/axsep006nodedec.i "qBCProd"   ttCOFINSOutr.qBCProd   "YES" "4"}
                                                                    {adapters/xml/ep2/axsep006nodedec.i "vAliqProd" ttCOFINSOutr.vAliqProd "YES" "4"}
                                                                END.
                                                                ELSE DO:
                                                                    {adapters/xml/ep2/axsep006nodedec.i "vBC"       ttCOFINSOutr.vBC     "YES" "2"}
                                                                    {adapters/xml/ep2/axsep006nodedec.i "pCOFINS"   ttCOFINSOutr.pCOFINS "YES" "2"}
                                                                END.
                                                                
                                                                {adapters/xml/ep2/axsep006nodedec.i  "vCOFINS"   ttCOFINSOutr.vCOFINS "YES" "2"}
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
                                                           {adapters/xml/ep2/axsep006nodedec.i "qBCProd"   ttCOFINSST.qBCProd   "YES" "4"}
                                                           {adapters/xml/ep2/axsep006nodedec.i "vAliqProd" ttCOFINSST.vAliqProd "YES" "4"}
                                                       END.
                                                       ELSE DO:
                                                           {adapters/xml/ep2/axsep006nodedec.i "vBC"       ttCOFINSST.vBC       "YES" "2"}
                                                           {adapters/xml/ep2/axsep006nodedec.i "pCOFINS"   ttCOFINSST.pCOFINS   "YES" "2"}   
                                                       END.

                                                       {adapters/xml/ep2/axsep006nodedec.i "vCOFINS"   ttCOFINSST.vCOFINS   "YES" "2"}
                                                  delStack().
                                             END.

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

                                                       {adapters/xml/ep2/axsep006nodedec.i  "vBC"       ttISSQN.vBC       "YES" "2"}
                                                       {adapters/xml/ep2/axsep006nodedec.i  "vAliq"     ttISSQN.vAliq     "YES" "2"}
                                                       {adapters/xml/ep2/axsep006nodedec.i  "vISSQN"    ttISSQN.vISSQN    "YES" "2"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "cMunFG"    ttISSQN.cMunFG    "YES"}
                                                       {adapters/xml/ep2/axsep006nodechar.i "cListServ" ttISSQN.cListServ "YES"}
                                                  delStack().

                                             END.

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

                                             {adapters/xml/ep2/axsep006nodedec.i "vBC"     ttICMSTot.vBC     "YES" "2"}
                                             {adapters/xml/ep2/axsep006nodedec.i "vICMS"   ttICMSTot.vICMS   "YES" "2"}
                                             {adapters/xml/ep2/axsep006nodedec.i "vBCST"   ttICMSTot.vBCST   "YES" "2"}
                                             {adapters/xml/ep2/axsep006nodedec.i "vST"     ttICMSTot.vST     "YES" "2"}
                                             {adapters/xml/ep2/axsep006nodedec.i "vProd"   ttICMSTot.vProd   "YES" "2"}
                                             {adapters/xml/ep2/axsep006nodedec.i "vFrete"  ttICMSTot.vFrete  "YES" "2"}
                                             {adapters/xml/ep2/axsep006nodedec.i "vSeg"    ttICMSTot.vSeg    "YES" "2"}
                                             {adapters/xml/ep2/axsep006nodedec.i "vDesc"   ttICMSTot.vDesc   "YES" "2"}
                                             {adapters/xml/ep2/axsep006nodedec.i "vII"     ttICMSTot.vII     "YES" "2"}
                                             {adapters/xml/ep2/axsep006nodedec.i "vIPI"    ttICMSTot.vIPI    "YES" "2"}
                                             {adapters/xml/ep2/axsep006nodedec.i "vPIS"    ttICMSTot.vPIS    "YES" "2"}
                                             {adapters/xml/ep2/axsep006nodedec.i "vCOFINS" ttICMSTot.vCOFINS "YES" "2"}
                                             {adapters/xml/ep2/axsep006nodedec.i "vOutro"  ttICMSTot.vOutro  "YES" "2"}
                                             {adapters/xml/ep2/axsep006nodedec.i "vNF"     ttICMSTot.vNF     "YES" "2"}
                                        delStack().

                                   END.
                                   FOR EACH ttISSQNtot
                                      WHERE ttISSQNtot.CodEstabelNF = ttNFe.CodEstabelNF
                                        AND ttISSQNtot.SerieNF      = ttNFe.SerieNF     
                                        AND ttISSQNtot.NrNotaFisNF  = ttNFe.NrNotaFisNF :
                                       
                                        RUN addNode IN hGenXml (getStack(), "ISSQNtot", "", OUTPUT iId).
                                        addStack(iId).

                                             {adapters/xml/ep2/axsep006nodedec.i "vServ"   ttISSQNtot.vServ   "NO"  "2"} 
                                             {adapters/xml/ep2/axsep006nodedec.i "vBC"     ttISSQNtot.vBC     "NO"  "2"}  
                                             {adapters/xml/ep2/axsep006nodedec.i "vISS"    ttISSQNtot.vISS    "NO"  "2"}
                                             {adapters/xml/ep2/axsep006nodedec.i "vPIS"    ttISSQNtot.vPIS    "NO"  "2"}
                                             {adapters/xml/ep2/axsep006nodedec.i "vCOFINS" ttISSQNtot.vCOFINS "NO"  "2"} 
                                        delStack().

                                   END.
                                   FOR EACH ttRetTrib
                                      WHERE ttRetTrib.CodEstabelNF = ttNFe.CodEstabelNF 
                                        AND ttRetTrib.SerieNF      = ttNFe.SerieNF      
                                        AND ttRetTrib.NrNotaFisNF  = ttNFe.NrNotaFisNF :
                                       
                                        RUN addNode IN hGenXml (getStack(), "retTrib", "", OUTPUT iId).
                                        addStack(iId).

                                             {adapters/xml/ep2/axsep006nodedec.i "vRetPIS"     ttRetTrib.vRetPIS     "NO"  "2"}
                                             {adapters/xml/ep2/axsep006nodedec.i "vRetCOFINS"  ttRetTrib.vRetCOFINS  "NO"  "2"}
                                             {adapters/xml/ep2/axsep006nodedec.i "vRetCSLL"    ttRetTrib.vRetCSLL    "NO"  "2"}
                                             {adapters/xml/ep2/axsep006nodedec.i "vBCIRRF"     ttRetTrib.vBCIRRF     "NO"  "2"}
                                             {adapters/xml/ep2/axsep006nodedec.i "vIRRF"       ttRetTrib.vIRRF       "NO"  "2"}
                                             {adapters/xml/ep2/axsep006nodedec.i "vBCRetPrev"  ttRetTrib.vBCRetPrev  "NO"  "2"}
                                             {adapters/xml/ep2/axsep006nodedec.i "vRetPrev"    ttRetTrib.vRetPrev    "NO"  "2"}
                                        delStack().

                                   END.
                              delStack().

END PROCEDURE.

PROCEDURE pi-imprime-Transp:

                              FOR EACH ttTransp
                                 WHERE ttTransp.CodEstabelNF = ttNFe.CodEstabelNF 
                                   AND ttTransp.SerieNF      = ttNFe.SerieNF      
                                   AND ttTransp.NrNotaFisNF  = ttNFe.NrNotaFisNF :
                                  
                                   RUN addNode IN hGenXml (getStack(), "transp", "", OUTPUT iId).
                                   addStack(iId).

                                        {adapters/xml/ep2/axsep006nodechar.i "modFrete" ttTransp.modFrete "YES"}

                                        RUN addNode IN hGenXml (getStack(), "transporta", "",                OUTPUT iId).
                                        addStack(iId).

                                             IF  ttTransp.i-natureza = 1 THEN DO: /*Pessoa F°sica*/
                                             {adapters/xml/ep2/axsep006nodechar.i "CPF"    ttTransp.CPF    "NO" }
                                             END.
                                             ELSE DO: /*Pessoa Jur°dica*/
                                             {adapters/xml/ep2/axsep006nodechar.i "CNPJ"   ttTransp.CNPJ   "NO" }
                                             END.

                                             {adapters/xml/ep2/axsep006nodechar.i "xNome"  ttTransp.xNome  "NO" }
                                             {adapters/xml/ep2/axsep006nodechar.i "IE"     ttTransp.IE     "NO" }
                                             {adapters/xml/ep2/axsep006nodechar.i "xEnder" ttTransp.xEnder "NO" }
                                             {adapters/xml/ep2/axsep006nodechar.i "xMun"   ttTransp.xMun   "NO" }
                                             {adapters/xml/ep2/axsep006nodechar.i "UF"     ttTransp.UF     "NO" }
                                        delStack().


                                        IF  (ttTransp.vServ    <> 0  AND ttTransp.vServ    <> ?)
                                        AND (ttTransp.vBCRet   <> 0  AND ttTransp.vBCRet   <> ?)
                                        AND (ttTransp.pICMSRet <> 0  AND ttTransp.pICMSRet <> ?)
                                        AND (ttTransp.vICMSRet <> 0  AND ttTransp.vICMSRet <> ?)
                                        AND (ttTransp.CFOP     <> "" AND ttTransp.CFOP     <> ?)
                                        AND (ttTransp.cMunFG   <> "" AND ttTransp.cMunFG   <> ?)
                                        THEN DO:
                                        
                                            RUN addNode IN hGenXml (getStack(), "retTransp", "", OUTPUT iId).
                                            addStack(iId).
    
                                                 {adapters/xml/ep2/axsep006nodedec.i  "vServ"    ttTransp.vServ    "YES" "2"}
                                                 {adapters/xml/ep2/axsep006nodedec.i  "vBCRet"   ttTransp.vBCRet   "YES" "2"}
                                                 {adapters/xml/ep2/axsep006nodedec.i  "pICMSRet" ttTransp.pICMSRet "YES" "2"}
                                                 {adapters/xml/ep2/axsep006nodedec.i  "vICMSRet" ttTransp.vICMSRet "YES" "2"}
                                                 {adapters/xml/ep2/axsep006nodechar.i "CFOP"     ttTransp.CFOP     "YES"}
                                                 {adapters/xml/ep2/axsep006nodechar.i "cMunFG"   ttTransp.cMunFG   "YES"}
                                            delStack().
                                        END.

                                        IF  (ttTransp.placa   <> "" AND ttTransp.placa   <> ?)
                                        AND (ttTransp.UFplaca <> "" AND ttTransp.UFplaca <> ?)
                                        THEN DO:
                                        
                                            RUN addNode IN hGenXml (getStack(), "veicTransp", "", OUTPUT iId).
                                            addStack(iId).
    
                                                 {adapters/xml/ep2/axsep006nodechar.i "placa" ttTransp.placa   "YES"}
                                                 {adapters/xml/ep2/axsep006nodechar.i "UF"    ttTransp.UFplaca "YES"}
                                                 {adapters/xml/ep2/axsep006nodechar.i "RNTC"  ttTransp.RNTC    "NO" }
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

                                                  {adapters/xml/ep2/axsep006nodechar.i "placa" ttReboque.placa "YES"}
                                                  {adapters/xml/ep2/axsep006nodechar.i "UF"    ttReboque.UF    "YES"}
                                                  {adapters/xml/ep2/axsep006nodechar.i "RNTC"  ttReboque.RNTC  "NO" }
                                             delStack().

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
                                             OR    (ttVol.qVol  <> "" AND ttVol.qVol  <> ?) ) :
                                            
                                             RUN addNode IN hGenXml (getStack(), "vol", "", OUTPUT iId).
                                             addStack(iId).

                                                  {adapters/xml/ep2/axsep006nodechar.i "qVol"  ttVol.qVol  "NO" }
                                                  {adapters/xml/ep2/axsep006nodechar.i "esp"   ttVol.esp   "NO" }
                                                  {adapters/xml/ep2/axsep006nodechar.i "marca" ttVol.marca "NO" }
                                                  {adapters/xml/ep2/axsep006nodechar.i "nVol"  ttVol.nVol  "NO" }
                                                  {adapters/xml/ep2/axsep006nodedec.i  "pesoL" ttVol.pesoL "NO"  "3"}
                                                  {adapters/xml/ep2/axsep006nodedec.i  "pesoB" ttVol.pesoB "NO"  "3"}

                                                  FOR EACH  ttLacres 
                                                     WHERE  ttLacres.CodEstabelNF = ttVol.CodEstabelNF
                                                       AND  ttLacres.SerieNF      = ttVol.SerieNF     
                                                       AND  ttLacres.NrNotaFisNF  = ttVol.NrNotaFisNF 
                                                       AND  ttLacres.nVol         = ttVol.nVol
                                                       AND (ttLacres.nLacre      <> "" AND ttLacres.nLacre <> ?):

                                                       RUN addNode IN hGenXml (getStack(), "lacres", "", OUTPUT iId).
                                                       addStack(iId).

                                                            {adapters/xml/ep2/axsep006nodechar.i "nLacre" ttLacres.nLacre "YES"}
                                                       delStack().

                                                  END.
                                             delStack().

                                        END.
                                   delStack().

                              END.

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
    
                                                 {adapters/xml/ep2/axsep006nodechar.i "nFat"  ttCobr.nFat  "NO" }
                                                 {adapters/xml/ep2/axsep006nodedec.i  "vOrig" ttCobr.vOrig "NO"  "2"}
                                                 {adapters/xml/ep2/axsep006nodedec.i  "vDesc" ttCobr.vDesc "NO"  "2"}
                                                 {adapters/xml/ep2/axsep006nodedec.i  "vLiq"  ttCobr.vLiq  "NO"  "2"}
                                            delStack().
                                        END.

                                        FOR EACH ttDup
                                           WHERE ttDup.CodEstabelNF = ttCobr.CodEstabelNF
                                             AND ttDup.SerieNF      = ttCobr.SerieNF
                                             AND ttDup.NrNotaFisNF  = ttCobr.NrNotaFisNF:
                                            
                                             RUN addNode IN hGenXml (getStack(), "dup", "", OUTPUT iId).
                                             addStack(iId).

                                                  {adapters/xml/ep2/axsep006nodechar.i "nDup"  ttDup.nDup  "NO" }
                                                  {adapters/xml/ep2/axsep006nodedate.i "dVenc" ttDup.dVenc "NO" }
                                                  {adapters/xml/ep2/axsep006nodedec.i  "vDup"  ttDup.vDup  "NO"  "2"}
                                             delStack().

                                        END.
                                   delStack().
                              END.

END PROCEDURE.

PROCEDURE pi-imprime-InfAdic:

                              FOR EACH ttInfAdic
                                 WHERE ttInfAdic.CodEstabelNF = ttNFe.CodEstabelNF
                                   AND ttInfAdic.SerieNF      = ttNFe.SerieNF     
                                   AND ttInfAdic.NrNotaFisNF  = ttNFe.NrNotaFisNF :
                                  
                                   RUN addNode IN hGenXml (getStack(), "infAdic", "", OUTPUT iId).
                                   addStack(iId).

                                        {adapters/xml/ep2/axsep006nodechar.i "infAdFisco" ttInfAdic.infAdFisco "NO" }
                                        {adapters/xml/ep2/axsep006nodechar.i "infCpl"     ttInfAdic.infCpl     "NO" }

                                        FOR EACH ttObsCont
                                           WHERE ttObsCont.CodEstabelNF = ttNFe.CodEstabelNF
                                             AND ttObsCont.SerieNF      = ttNFe.SerieNF     
                                             AND ttObsCont.NrNotaFisNF  = ttNFe.NrNotaFisNF
                                             AND (ttObsCont.xTexto      <> ?
                                             AND  ttObsCont.xTexto      <> ""):
                                            
                                             RUN addNode IN hGenXml (getStack(), "obsCont", "", OUTPUT iId).
                                             addStack(iId).

                                                  {adapters/xml/ep2/axsep006nodechar.i "xTexto" ttObsCont.xTexto "YES"}
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

                                                  {adapters/xml/ep2/axsep006nodechar.i "xTexto" ttObsFisco.xTexto "YES"}
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

                                                  {adapters/xml/ep2/axsep006nodechar.i "nProc"   ttProcRef.nProc   "YES"}
                                                  {adapters/xml/ep2/axsep006nodechar.i "indProc" ttProcRef.indProc "YES"}
                                             delStack().

                                        END.
                                   delStack().

                              END.
END PROCEDURE.

PROCEDURE pi-imprime-Exporta:

                              FOR EACH  ttExporta
                                 WHERE  ttExporta.CodEstabelNF = ttNFe.CodEstabelNF
                                   AND  ttExporta.SerieNF      = ttNFe.SerieNF     
                                   AND  ttExporta.NrNotaFisNF  = ttNFe.NrNotaFisNF
                                   AND (ttExporta.UFEmbarq   <> ? AND ttExporta.UFEmbarq   <> "")
                                   AND (ttExporta.xLocEmbarq <> ? AND ttExporta.xLocEmbarq <> ""):
                                  
                                   RUN addNode IN hGenXml (getStack(), "exporta", "", OUTPUT iId).
                                   addStack(iId).

                                        {adapters/xml/ep2/axsep006nodechar.i "UFEmbarq"   ttExporta.UFEmbarq   "YES"}
                                        {adapters/xml/ep2/axsep006nodechar.i "xLocEmbarq" ttExporta.xLocEmbarq "YES"}
                                   delStack().

                              END.

END PROCEDURE.

PROCEDURE pi-imprime-Compra:

                              FOR EACH  ttCompra
                                 WHERE  ttCompra.CodEstabelNF = ttNFe.CodEstabelNF
                                   AND  ttCompra.SerieNF      = ttNFe.SerieNF     
                                   AND  ttCompra.NrNotaFisNF  = ttNFe.NrNotaFisNF
                                   /*AND (ttCompra.xNEmp <> ? AND ttCompra.xNEmp <> "")*/
                                   AND (ttCompra.xPed  <> ? AND ttCompra.xPed  <> "")
                                   /*AND (ttCompra.xCont <> ? AND ttCompra.xCont <> "")*/ :

                                   RUN addNode IN hGenXml (getStack(), "compra", "", OUTPUT iId).
                                   addStack(iId).

                                        {adapters/xml/ep2/axsep006nodechar.i "xNEmp" ttCompra.xNEmp "NO" }
                                        {adapters/xml/ep2/axsep006nodechar.i "xPed"  ttCompra.xPed  "NO" }
                                        {adapters/xml/ep2/axsep006nodechar.i "xCont" ttCompra.xCont "NO" }
                                   delStack().

                              END.

END PROCEDURE.

