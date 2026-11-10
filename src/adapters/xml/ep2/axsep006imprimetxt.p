/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSEP006IMPRIMETXT 2.00.00.026 } /*** "010026" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i axsep006imprimetxt MUT}
&ENDIF

/*-------------------------------------------------
             AXSEP006ImprimeTXT.p
-------------------------------------------------*/

{adapters/xml/ep2/axsep006.i}                  /* Definiá‰es Tabelas Tempor†rias */
{adapters/xml/ep2/axsep006extradeclarations.i} /* Outras Declaraá‰es             */

DEFINE INPUT  PARAM pcArquivoNFeTXT  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAM pcArquivoEmitTXT AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAM TABLE FOR ttAdi.
DEFINE INPUT  PARAM TABLE FOR ttArma.
DEFINE INPUT  PARAM TABLE FOR ttAvulsa.
DEFINE INPUT  PARAM TABLE FOR ttCobr.
DEFINE INPUT  PARAM TABLE FOR ttCOFINSAliq.
DEFINE INPUT  PARAM TABLE FOR ttCOFINSNT.
DEFINE INPUT  PARAM TABLE FOR ttCOFINSOutr.
DEFINE INPUT  PARAM TABLE FOR ttCOFINSQtde.
DEFINE INPUT  PARAM TABLE FOR ttCOFINSST.
DEFINE INPUT  PARAM TABLE FOR ttComb.
DEFINE INPUT  PARAM TABLE FOR ttCompra.
DEFINE INPUT  PARAM TABLE FOR ttDest.
DEFINE INPUT  PARAM TABLE FOR ttDet.
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
DEFINE INPUT  PARAM TABLE FOR ttInfAdic.
DEFINE INPUT  PARAM TABLE FOR ttIPI.
DEFINE INPUT  PARAM TABLE FOR ttISSQN.
DEFINE INPUT  PARAM TABLE FOR ttISSQNtot.
DEFINE INPUT  PARAM TABLE FOR ttLacres.
DEFINE INPUT  PARAM TABLE FOR ttMed.
DEFINE INPUT  PARAM TABLE FOR ttNFe.
DEFINE INPUT  PARAM TABLE FOR ttNFRef.
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

    /* Imprime TXT Nota Fiscal Eletrìnica */
    OUTPUT TO VALUE(pcArquivoNFeTXT).

        /*NOTA FISCAL|qtd notas fiscais no arquivo|*/

        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-nota-fiscal AS CHARACTER FORMAT "X(13)" NO-UNDO.
        {utp/ut-liter.i "NOTA_FISCAL" *}
        ASSIGN c-lbl-liter-nota-fiscal = TRIM(RETURN-VALUE).
        PUT c-lbl-liter-nota-fiscal "|".
        {adapters/xml/ep2/axsep006nodechar.i "iContNota" STRING(iContNota) "YES"}
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
        
            ASSIGN iContItem = 1.
        
            FOR EACH ttDet
               WHERE ttDet.CodEstabelNF = ttNFe.CodEstabelNF
                 AND ttDet.SerieNF      = ttNFe.SerieNF     
                 AND ttDet.NrNotaFisNF  = ttNFe.NrNotaFisNF :
        
                /*H|NItem|InfAdProd|*/
                PUT "H" "|".
                {adapters/xml/ep2/axsep006nodechar.i  "iContItem" STRING(iContItem) "YES"}
        
                {adapters/xml/ep2/axsep006nodechar2.i "infAdProd" ttDet.infAdProd   "YES"}
        
                PUT SKIP.
                /*fim "H"*/
        
                RUN pi-imprime-Prod-txt.
        
                RUN pi-imprime-DI-e-Adi-txt.
        
                RUN pi-imprime-Veic-txt.
        
                RUN pi-imprime-Med-txt.
        
                RUN pi-imprime-Arma-txt.
        
                RUN pi-imprime-Comb-txt.
        
                RUN pi-imprime-ICMS-txt.
        
                RUN pi-imprime-IPI-txt.
        
                RUN pi-imprime-II-txt.
        
                RUN pi-imprime-PIS-txt.
        
                RUN pi-imprime-COFINS-txt.
        
                RUN pi-imprime-ISSQN-txt.
        
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
    
        END. /*fim FOR EACH ttNFe*/

    OUTPUT CLOSE. /*fecha arquivo*/

END PROCEDURE.


PROCEDURE pi-imprime-Ide-txt:

    FOR EACH ttIde
       WHERE ttIde.CodEstabelNF = ttNFe.CodEstabelNF
         AND ttIde.SerieNF      = ttNFe.SerieNF     
         AND ttIde.NrNotaFisNF  = ttNFe.NrNotaFisNF:

        /*B|cUF|cNF|NatOp|intPag|mod|serie|nNF|dEmi|dSaiEnt|tpNF|cMunFG|TpImp|TpEmis|CDV|TpAmb|FinNFe|ProcEmi|VerProc|*/
        PUT "B" "|".
        
        {adapters/xml/ep2/axsep006nodechar.i "cUF"      ttIde.cUF     "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "cNF"      ttIde.cNF     "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "natOp"    ttIde.natOp   "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "indPag"   ttIde.indPag  "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "mod"      ttIde.mod     "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "serie"    ttIde.serie   "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "nNF"      ttIde.nNF     "YES"}
        {adapters/xml/ep2/axsep006nodedate.i "dEmi"     ttIde.dEmi    "YES"}
        {adapters/xml/ep2/axsep006nodedate.i "dSaiEnt"  ttIde.dSaiEnt "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "tpNF"     ttIde.tpNF    "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "cMunFG"   ttIde.cMunFG  "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "tpImp"    ttIde.tpImp   "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "tpEmis"   ttIde.tpEmis  "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "cDV"      ttIde.cDV     "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "tpAmb"    ttIde.tpAmb   "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "finNFe"   ttIde.finNFe  "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "procEmi"  ttIde.procEmi "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "verProc"  ttIde.verProc "YES"}

        PUT SKIP.
        /*fim "B"*/

        FOR EACH  ttNFref
           WHERE  ttNFref.CodEstabelNF = ttIde.CodEstabelNF
             AND  ttNFref.SerieNF      = ttIde.SerieNF     
             AND  ttNFref.NrNotaFisNF  = ttIde.NrNotaFisNF:

            IF ttNFRef.refNFe <> "" AND 
               ttNFRef.refNFe <> ?  THEN DO:
            
                /*B13|refNFe|*/
                PUT "B13" "|".
    
                {adapters/xml/ep2/axsep006nodechar.i "refNFe" ttNFRef.refNFe   "YES"}
            END.
            ELSE DO:
                 /*B14|cUF|AAMM(ano màs)|CNPJ|Mod|serie|nNF|*/
                PUT "B14" "|".
    
                {adapters/xml/ep2/axsep006nodechar.i "cUF"   ttNFRef.cUF   "YES"}
                {adapters/xml/ep2/axsep006nodechar.i "AAMM"  ttNFRef.AAMM  "YES"}
                {adapters/xml/ep2/axsep006nodechar.i "CNPJ"  ttNFRef.CNPJ  "YES"}
                {adapters/xml/ep2/axsep006nodechar.i "mod"   ttNFRef.mod   "YES"}
                {adapters/xml/ep2/axsep006nodechar.i "serie" ttNFRef.serie "YES"}
                {adapters/xml/ep2/axsep006nodechar.i "nNF"   ttNFRef.nNF   "YES"}

            END.

            PUT SKIP.
            /*fim "B14"*/
        END.
    END.

END PROCEDURE.

PROCEDURE pi-imprime-Emit-txt:

    FOR EACH ttEmit
       WHERE ttEmit.CodEstabelNF = ttNFe.CodEstabelNF
         AND ttEmit.SerieNF      = ttNFe.SerieNF     
         AND ttEmit.NrNotaFisNF  = ttNFe.NrNotaFisNF:
        
        /*C|XNome|XFant|IE|IEST|IM|CNAE|*/
        PUT "C" "|".

        {adapters/xml/ep2/axsep006nodechar.i "xNome" ttEmit.xNome "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "xFant" ttEmit.xFant "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "IE"    ttEmit.IE    "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "IEST"  ttEmit.IEST  "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "IM"    ttEmit.IM    "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "CNAE"  ttEmit.CNAE  "YES"}

        PUT SKIP.
        /*fim "C"*/

        /*C02|CNPJ|*/
        PUT "C02" "|".

        {adapters/xml/ep2/axsep006nodechar.i "CNPJ"  ttEmit.CNPJ  "YES"}

        PUT SKIP.
        /*fim "C02"*/
        
        /*C05|XLgr|Nro|Cpl|Bairro|CMun|XMun|UF|CEP|CPais|XPais|Fone|*/
        PUT "C05" "|" .

        {adapters/xml/ep2/axsep006nodechar.i  "xLgr"    ttEmit.xLgr    "YES"}
        {adapters/xml/ep2/axsep006nodechar.i  "nro"     ttEmit.nro     "YES"}
        {adapters/xml/ep2/axsep006nodechar.i  "xCpl"    ttEmit.xCpl    "YES"}
        {adapters/xml/ep2/axsep006nodechar.i  "xBairro" ttEmit.xBairro "YES"}
        {adapters/xml/ep2/axsep006nodechar.i  "cMun"    ttEmit.cMun    "YES"}

        IF ttEmit.xMun = "Exterior" THEN DO:
        {adapters/xml/ep2/axsep006nodechar2.i "xMun"    ttEmit.xMun    "YES"}
        END.
        ELSE DO:
        {adapters/xml/ep2/axsep006nodechar.i  "xMun"    ttEmit.xMun    "YES"}
        END.

        {adapters/xml/ep2/axsep006nodechar.i  "UF"      ttEmit.UF      "YES"}
        {adapters/xml/ep2/axsep006nodechar.i  "CEP"     ttEmit.CEP     "YES"}
        {adapters/xml/ep2/axsep006nodechar.i  "cPais"   ttEmit.cPais   "YES"}
        {adapters/xml/ep2/axsep006nodechar.i  "xPais"   ttEmit.xPais   "YES"}
        {adapters/xml/ep2/axsep006nodechar.i  "fone"    ttEmit.fone    "YES"}

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
        
        
        /*D|CNPJ|XOrgao|Matr|XAgente|Fone|UF|NDAR|DEmi|VDAR|RepEmi|DPag|*/
        PUT "D" "|".

        {adapters/xml/ep2/axsep006nodechar.i "CNPJ"    ttAvulsa.CNPJ    "YES"    }
        {adapters/xml/ep2/axsep006nodechar.i "xOrgao"  ttAvulsa.xOrgao  "YES"    }
        {adapters/xml/ep2/axsep006nodechar.i "matr"    ttAvulsa.matr    "YES"    }
        {adapters/xml/ep2/axsep006nodechar.i "xAgente" ttAvulsa.xAgente "YES"    }
        {adapters/xml/ep2/axsep006nodechar.i "fone"    ttAvulsa.fone    "YES"    }
        {adapters/xml/ep2/axsep006nodechar.i "UF"      ttAvulsa.UF      "YES"    }
        {adapters/xml/ep2/axsep006nodechar.i "nDAR"    ttAvulsa.nDAR    "YES"    }
        {adapters/xml/ep2/axsep006nodedate.i "dEmi"    ttAvulsa.dEmi    "YES"    }
        {adapters/xml/ep2/axsep006nodedec.i  "vDAR"    ttAvulsa.vDAR    "YES" "2"}
        {adapters/xml/ep2/axsep006nodechar.i "repEmi"  ttAvulsa.repEmi  "YES"    }
        {adapters/xml/ep2/axsep006nodedate.i "dPag"    ttAvulsa.dPag    "YES"    }

        PUT SKIP.
        /*fim "D"*/
    END.

END PROCEDURE.

PROCEDURE pi-imprime-Dest-txt:

    FOR EACH ttDest
       WHERE ttDest.CodEstabelNF = ttNFe.CodEstabelNF
         AND ttDest.SerieNF      = ttNFe.SerieNF     
         AND ttDest.NrNotaFisNF  = ttNFe.NrNotaFisNF:

        /*E|XNome|IE|ISUF|*/
        PUT "E" "|".

        {adapters/xml/ep2/axsep006nodechar.i "xNome"   ttDest.xNome "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "IE"      ttDest.IE    "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "ISUF"    ttDest.ISUF  "YES"}

        PUT SKIP.
        /*fim "E"*/

        IF  ttDest.i-natureza = 1 THEN DO: /* Pessoa F°sica */

            /*E03|CPF|*/
            PUT "E03" "|".

            {adapters/xml/ep2/axsep006nodechar.i "CPF"        ttDest.CPF   "YES"}

            PUT SKIP.
            /*fim "E03"*/
        END.
        ELSE DO:

            /*E02|CNPJ|*/
            PUT "E02" "|".

            {adapters/xml/ep2/axsep006nodechar.i "CNPJ"       ttDest.CNPJ  "YES"}

            PUT SKIP.
            /*fim "E02"*/
        END.
              
        /*E05|XLgr|Nro|XCpl|XBairro|CMun|XMun|UF|CEP|CPais|XPais|Fone|*/
        PUT "E05" "|".

        {adapters/xml/ep2/axsep006nodechar.i  "xLgr"    ttDest.xLgr    "YES"}
        {adapters/xml/ep2/axsep006nodechar.i  "nro"     ttDest.nro     "YES"}
        {adapters/xml/ep2/axsep006nodechar.i  "xCpl"    ttDest.xCpl    "YES"}
        {adapters/xml/ep2/axsep006nodechar.i  "xBairro" ttDest.xBairro "YES"}
        {adapters/xml/ep2/axsep006nodechar.i  "cMun"    ttDest.cMun    "YES"}

        IF ttDest.xMun = "Exterior" THEN DO:
        {adapters/xml/ep2/axsep006nodechar2.i "xMun"    ttDest.xMun    "YES"}
        END.
        ELSE DO:
        {adapters/xml/ep2/axsep006nodechar.i  "xMun"    ttDest.xMun    "YES"}
        END.
        
        {adapters/xml/ep2/axsep006nodechar.i  "UF"      ttDest.UF      "YES"}
        {adapters/xml/ep2/axsep006nodechar.i  "CEP"     ttDest.CEP     "YES"}
        {adapters/xml/ep2/axsep006nodechar.i  "cPais"   ttDest.cPais   "YES"}
        {adapters/xml/ep2/axsep006nodechar.i  "xPais"   ttDest.xPais   "YES"}
        {adapters/xml/ep2/axsep006nodechar.i  "fone"    ttDest.fone    "YES"}

        PUT SKIP.
        /*fim "E05"*/
    END.

END PROCEDURE.

PROCEDURE pi-imprime-Retirada-txt:

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

        /*F|CNPJ|XLgr|Nro|XCpl|XBairro|CMun|XMun|UF|*/
        PUT "F" "|".

        {adapters/xml/ep2/axsep006nodechar.i "CNPJ"    ttRetirada.CNPJ    "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "xLgr"    ttRetirada.xLgr    "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "nro"     ttRetirada.nro     "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "xCpl"    ttRetirada.xCpl    "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "xBairro" ttRetirada.xBairro "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "cMun"    ttRetirada.cMun    "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "xMun"    ttRetirada.xMun    "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "UF"      ttRetirada.UF      "YES"}

        PUT SKIP.
        /*fim "F"*/
    END.

END PROCEDURE.

PROCEDURE pi-imprime-Entrega-txt:

    FOR EACH  ttEntrega
       WHERE  ttEntrega.CodEstabelNF = ttNFe.CodEstabelNF
         AND  ttEntrega.SerieNF      = ttNFe.SerieNF     
         AND  ttEntrega.NrNotaFisNF  = ttNFe.NrNotaFisNF
         AND  ttEntrega.CNPJ    <> ?
         AND (ttEntrega.xLgr    <> "" AND ttEntrega.xLgr    <> ?)
         AND (ttEntrega.nro     <> "" AND ttEntrega.nro     <> ?)
         AND (ttEntrega.xBairro <> "" AND ttEntrega.xBairro <> ?)
         AND (ttEntrega.cMun    <> "" AND ttEntrega.cMun    <> ?)
         AND (ttEntrega.xMun    <> "" AND ttEntrega.xMun    <> ?)
         AND (ttEntrega.UF      <> "" AND ttEntrega.UF      <> ?) :

        /*G|CNPJ|XLgr|Nro|XCpl|XBairro|CMun|XMun|UF|*/
        PUT "G" "|".

        {adapters/xml/ep2/axsep006nodechar.i  "CNPJ"    ttEntrega.CNPJ    "YES"}
        {adapters/xml/ep2/axsep006nodechar.i  "xLgr"    ttEntrega.xLgr    "YES"}
        {adapters/xml/ep2/axsep006nodechar.i  "nro"     ttEntrega.nro     "YES"}
        {adapters/xml/ep2/axsep006nodechar.i  "xCpl"    ttEntrega.xCpl    "YES"}
        {adapters/xml/ep2/axsep006nodechar.i  "xBairro" ttEntrega.xBairro "YES"}
        {adapters/xml/ep2/axsep006nodechar.i  "cMun"    ttEntrega.cMun    "YES"}
        
        IF ttEntrega.xMun = "Exterior" THEN DO:
        {adapters/xml/ep2/axsep006nodechar2.i "xMun"    ttEntrega.xMun    "YES"}
        END.
        ELSE DO:
        {adapters/xml/ep2/axsep006nodechar.i  "xMun"    ttEntrega.xMun    "YES"}
        END.
        
        {adapters/xml/ep2/axsep006nodechar.i  "UF"      ttEntrega.UF      "YES"}

        PUT SKIP.
        /*fim "G"*/
    END.

END PROCEDURE.

PROCEDURE pi-imprime-Prod-txt:

        /*I|CProd|CEAN|XProd|NCM|EXTIPI|Gànero|CFOP|UCom|QCom|VUnCom|VProd|CEANTrib|UTrib|QTrib|VUnTrib|VFrete|VSeg|VDesc|*/
        PUT "I" "|".

        {adapters/xml/ep2/axsep006nodechar2.i "cProd"    ttDet.cProd    "YES"    }
        {adapters/xml/ep2/axsep006nodechar.i  "cEAN"     ttDet.cEAN     "YES"    }
        {adapters/xml/ep2/axsep006nodechar2.i "xProd"    ttDet.xProd    "YES"    }
        {adapters/xml/ep2/axsep006nodechar.i  "NCM"      ttDet.NCM      "YES"    }
        {adapters/xml/ep2/axsep006nodechar.i  "EXTIPI"   ttDet.EXTIPI   "YES"    }
        {adapters/xml/ep2/axsep006nodechar.i  "genero"   ttDet.genero   "YES"    }
        {adapters/xml/ep2/axsep006nodechar.i  "CFOP"     ttDet.CFOP     "YES"    }
        {adapters/xml/ep2/axsep006nodechar2.i "uCom"     ttDet.uCom     "YES"    }
        {adapters/xml/ep2/axsep006nodedec.i   "qCom"     ttDet.qCom     "YES" "4"}
        {adapters/xml/ep2/axsep006nodedec.i   "vUnCom"   ttDet.vUnCom   "YES" "4"}
        {adapters/xml/ep2/axsep006nodedec.i   "vProd"    ttDet.vProd    "YES" "2"}
        {adapters/xml/ep2/axsep006nodechar.i  "cEANTrib" ttDet.cEANTrib "YES"    }
        {adapters/xml/ep2/axsep006nodechar2.i "uTrib"    ttDet.uTrib    "YES"    }
        {adapters/xml/ep2/axsep006nodedec.i   "qTrib"    ttDet.qTrib    "YES" "4"} 
        {adapters/xml/ep2/axsep006nodedec.i   "vUnTrib"  ttDet.vUnTrib  "YES" "4"}
        {adapters/xml/ep2/axsep006nodedec.i   "vFrete"   ttDet.vFrete   "YES" "2"}
        {adapters/xml/ep2/axsep006nodedec.i   "vSeg"     ttDet.vSeg     "YES" "2"}
        {adapters/xml/ep2/axsep006nodedec.i   "vDesc"    ttDet.vDesc    "YES" "2"}

        PUT SKIP.
        /*fim "I"*/

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

            /*I18|NDI|DDI|XLocDesemb|UFDesemb|DDesemb|CExportador|*/
            PUT "I18" "|".

            {adapters/xml/ep2/axsep006nodechar.i "nDI"         ttDI.nDI         "YES"}
            {adapters/xml/ep2/axsep006nodedate.i "dDI"         ttDI.dDI         "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "xLocDesemb"  ttDI.xLocDesemb  "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "UFDesemb"    ttDI.UFDesemb    "YES"}
            {adapters/xml/ep2/axsep006nodedate.i "dDesemb"     ttDI.dDesemb     "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "cExportador" ttDI.cExportador "YES"}

            PUT SKIP.
            /*fim "I18"*/

            FOR EACH ttAdi NO-LOCK
               WHERE ttAdi.CodEstabelNF = ttDet.CodEstabelNF
                 AND ttAdi.SerieNF      = ttDet.SerieNF     
                 AND ttAdi.NrNotaFisNF  = ttDet.NrNotaFisNF 
                 AND ttAdi.NrSeqFatNF   = ttDet.NrSeqFatNF  
                 AND ttAdi.ItCodigoNF   = ttDet.ItCodigoNF  
                 AND ttAdi.nDI          = ttDI.nDI:

                /*I25|NAdicao|NSeqAdic|CFabricante|VDescDI|*/
                PUT "I25" "|".

                {adapters/xml/ep2/axsep006nodechar.i "nAdicao"     ttAdi.nAdicao     "YES"    }
                {adapters/xml/ep2/axsep006nodechar.i "nSeqAdic"    ttAdi.nSeqAdic    "YES"    }
                {adapters/xml/ep2/axsep006nodechar.i "cFabricante" ttAdi.cFabricante "YES"    }
                /*{adapters/xml/ep2/axsep006nodedec.i  "vDescDI"     ttAdi.vDescDI     "YES" "2"}*/
                IF ttAdi.vDescDI <> 0 THEN
                   {adapters/xml/ep2/axsep006nodedec.i   "vDescDI"     ttAdi.vDescDI     "YES" "2"}
                IF ttAdi.vDescDI = 0 THEN
                   {adapters/xml/ep2/axsep006nodechar.i  "vDescDI"     c-vDescDI     "YES" }



                PUT SKIP.
                /*fim "I25"*/
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

            /*J|TpOp|Chassi|CCor|XCor|Pot|CM3|PesoL|PesoB|NSerie|TpComb|NMotor|CMKG|Dist|RENAVAM|AnoMod|AnoFab|TpPint|TpVeic|EspVeic|VIN|CondVeic|CMod|*/
            PUT "J" "|".

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
            {adapters/xml/ep2/axsep006nodechar.i "RENAVAM"  ttVeic.RENAVAM  "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "anoMod"   ttVeic.anoMod   "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "anoFab"   ttVeic.anoFab   "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "tpPint"   ttVeic.tpPint   "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "tpVeic"   ttVeic.tpVeic   "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "espVeic"  ttVeic.espVeic  "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "VIN"      ttVeic.VIN      "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "condVeic" ttVeic.condVeic "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "cMod"     ttVeic.cMod     "YES"}

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

            /*K|NLote|QLote|DFab|DVal|VPMC|*/
            PUT "K" "|".

            {adapters/xml/ep2/axsep006nodechar.i "nLote" ttMed.nLote "YES"    }
            {adapters/xml/ep2/axsep006nodedec.i  "qLote" ttMed.qLote "YES" "3"}
            {adapters/xml/ep2/axsep006nodedate.i "dFab"  ttMed.dFab  "YES"    }
            {adapters/xml/ep2/axsep006nodedate.i "dVal"  ttMed.dVal  "YES"    }
            {adapters/xml/ep2/axsep006nodedec.i  "vPMC"  ttMed.vPMC  "YES" "2"}

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

            /*L|TpArma|NSerie|NCano|Descr|*/
            PUT "L" "|".

            {adapters/xml/ep2/axsep006nodechar.i "tpArma" ttArma.tpArma "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "nSerie" ttArma.nSerie "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "nCano"  ttArma.nCano  "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "descr"  ttArma.descr  "YES"}

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

            /*L01| CProdANP|CODIF|QTemp|*/
            PUT "L01" "|".

            {adapters/xml/ep2/axsep006nodechar.i "cProdANP" ttComb.cProdANP "YES"    }
            {adapters/xml/ep2/axsep006nodechar.i "CODIF"    ttComb.CODIF    "YES"    }
            {adapters/xml/ep2/axsep006nodedec.i  "qTemp"    ttComb.qTemp    "YES" "4"}

            PUT SKIP.
            /*fim "L01"*/

            IF  ttComb.qBCProd   <> ?
            AND ttComb.vAliqProd <> ?
            AND ttComb.vCIDE     <> ? THEN DO:

                /*L105|QBCProd|VAliqProd|VCIDE|*/
                PUT "L105" "|".

                {adapters/xml/ep2/axsep006nodedec.i "qBCProd"   ttComb.qBCProd   "YES" "4"}
                {adapters/xml/ep2/axsep006nodedec.i "vAliqProd" ttComb.vAliqProd "YES" "4"}
                {adapters/xml/ep2/axsep006nodedec.i "vCIDE"     ttComb.vCIDE     "YES" "4"}

                PUT SKIP.
                /*fim "L105"*/
            END.

            IF  ttComb.vBCICMS   <> ?
            AND ttComb.vICMS     <> ?
            AND ttComb.vBCICMSST <> ?
            AND ttComb.vICMSST   <> ? THEN DO:

                /*L109|VBCICMS|VICMS|VBCICMSST|VICMSST|*/
                PUT "L109" "|".

                {adapters/xml/ep2/axsep006nodedec.i "vBCICMS"   ttComb.vBCICMS   "YES" "2"}
                {adapters/xml/ep2/axsep006nodedec.i "vICMS"     ttComb.vICMS     "YES" "2"}
                {adapters/xml/ep2/axsep006nodedec.i "vBCICMSST" ttComb.vBCICMSST "YES" "2"}
                {adapters/xml/ep2/axsep006nodedec.i "vICMSST"   ttComb.vICMSST   "YES" "2"}

                PUT SKIP.
                /*fim "L109"*/
            END.

            IF  ttComb.vBCICMSSTDest <> ?
            AND ttComb.vICMSSTDest   <> ? THEN DO:

                /*L114|VBCICMSST|VICMSST|*/
                PUT "L114" "|".

                {adapters/xml/ep2/axsep006nodedec.i "vBCICMSSTDest" ttComb.vBCICMSSTDest "YES" "2"}
                {adapters/xml/ep2/axsep006nodedec.i "vICMSSTDest"   ttComb.vICMSSTDest   "YES" "2"}

                PUT SKIP.
                /*fim "L114"*/
            END.

            IF  ttComb.vBCICMSSTCons <> ?
            AND ttComb.vICMSSTCons   <> ?
            AND ttComb.UFCons        <> ? THEN DO:

                /*L117|VBCICMSST|VICMSST|UFCons|*/
                PUT "L117" "|".

                {adapters/xml/ep2/axsep006nodedec.i  "vBCICMSSTCons" ttComb.vBCICMSSTCons "YES" "2"} 
                {adapters/xml/ep2/axsep006nodedec.i  "vICMSSTCons"   ttComb.vICMSSTCons   "YES" "2"}
                {adapters/xml/ep2/axsep006nodechar.i "UFCons"        ttComb.UFCons        "YES"    }

                PUT SKIP.
                /*fim "L117"*/
            END.
        END.

END PROCEDURE.

PROCEDURE pi-imprime-ICMS-txt:

        PUT "M|" SKIP.

        PUT "N|" SKIP.

        FOR EACH ttICMS00
           WHERE ttICMS00.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMS00.SerieNF      = ttDet.SerieNF     
             AND ttICMS00.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMS00.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMS00.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N02|Orig|CST|ModBC|VBC|PICMS|VICMS|*/
            PUT "N02" "|".

            {adapters/xml/ep2/axsep006nodechar.i "orig"  ttICMS00.orig  "YES"    }
            {adapters/xml/ep2/axsep006nodechar.i "CST"   ttICMS00.CST   "YES"    }
            {adapters/xml/ep2/axsep006nodechar.i "modBC" ttICMS00.modBC "YES"    }
            {adapters/xml/ep2/axsep006nodedec.i  "vBC"   ttICMS00.vBC   "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "pICMS" ttICMS00.pICMS "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vICMS" ttICMS00.vICMS "YES" "2"}

            PUT SKIP.
            /*fim "N02"*/
        END.

        FOR EACH ttICMS10
           WHERE ttICMS10.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMS10.SerieNF      = ttDet.SerieNF     
             AND ttICMS10.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMS10.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMS10.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N03|Orig|CST|ModBC|VBC|PICMS|VICMS|ModBCST|PMVAST|PRedBCST|VBCST|PICMSST|VICMSST|*/
            PUT "N03" "|".

            {adapters/xml/ep2/axsep006nodechar.i "orig"     ttICMS10.orig     "YES"    }
            {adapters/xml/ep2/axsep006nodechar.i "CST"      ttICMS10.CST      "YES"    }
            {adapters/xml/ep2/axsep006nodechar.i "modBC"    ttICMS10.modBC    "YES"    }
            {adapters/xml/ep2/axsep006nodedec.i  "vBC"      ttICMS10.vBC      "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "pICMS"    ttICMS10.pICMS    "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vICMS"    ttICMS10.vICMS    "YES" "2"}
            {adapters/xml/ep2/axsep006nodechar.i "modBCST"  ttICMS10.modBCST  "YES"    }
            {adapters/xml/ep2/axsep006nodedec.i  "pMVAST"   ttICMS10.pMVAST   "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "pRedBCST" ttICMS10.pRedBCST "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vBCST"    ttICMS10.vBCST    "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "pICMSST"  ttICMS10.pICMSST  "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vICMSST"  ttICMS10.vICMSST  "YES" "2"}

            PUT SKIP.
            /*fim "N03"*/
        END.

        FOR EACH ttICMS20
           WHERE ttICMS20.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMS20.SerieNF      = ttDet.SerieNF     
             AND ttICMS20.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMS20.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMS20.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N04|Orig|CST|ModBC|PRedBC|VBC|PICMS|VICMS|*/
            PUT "N04" "|".

            {adapters/xml/ep2/axsep006nodechar.i "orig"   ttICMS20.orig   "YES"    }
            {adapters/xml/ep2/axsep006nodechar.i "CST"    ttICMS20.CST    "YES"    }
            {adapters/xml/ep2/axsep006nodechar.i "modBC"  ttICMS20.modBC  "YES"    }
            {adapters/xml/ep2/axsep006nodedec.i  "pRedBC" ttICMS20.pRedBC "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vBC"    ttICMS20.vBC    "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "pICMS"  ttICMS20.pICMS  "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vICMS"  ttICMS20.vICMS  "YES" "2"}

            PUT SKIP.
            /*fim "N04"*/
        END.

        FOR EACH ttICMS30
           WHERE ttICMS30.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMS30.SerieNF      = ttDet.SerieNF     
             AND ttICMS30.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMS30.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMS30.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N05|Orig|CST|ModBCST|PMVAST|PRedBCST|VBCST|PICMSST|VICMSST|*/
            PUT "N05" "|".

            {adapters/xml/ep2/axsep006nodechar.i "orig"     ttICMS30.orig     "YES"    }
            {adapters/xml/ep2/axsep006nodechar.i "CST"      ttICMS30.CST      "YES"    }
            {adapters/xml/ep2/axsep006nodechar.i "modBCST"  ttICMS30.modBCST  "YES"    }
            {adapters/xml/ep2/axsep006nodedec.i  "pMVAST"   ttICMS30.pMVAST   "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "pRedBCST" ttICMS30.pRedBCST "YES" "2"} 
            {adapters/xml/ep2/axsep006nodedec.i  "vBCST"    ttICMS30.vBCST    "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "pICMSST"  ttICMS30.pICMSST  "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vICMSST"  ttICMS30.vICMSST  "YES" "2"}

            PUT SKIP.
            /*fim "N05"*/
        END.

        FOR EACH ttICMS40
           WHERE ttICMS40.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMS40.SerieNF      = ttDet.SerieNF     
             AND ttICMS40.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMS40.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMS40.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N06|Orig|CST|*/
            PUT "N06" "|".

            {adapters/xml/ep2/axsep006nodechar.i "orig" ttICMS40.orig "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "CST"  ttICMS40.CST  "YES"}

            PUT SKIP.
            /*fim "N06"*/
        END.

        FOR EACH ttICMS51
           WHERE ttICMS51.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMS51.SerieNF      = ttDet.SerieNF     
             AND ttICMS51.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMS51.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMS51.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N07|Orig|CST|ModBC|PRedBC|VBC|PICMS|VICMS|*/
            PUT "N07" "|".

            {adapters/xml/ep2/axsep006nodechar.i "orig"   ttICMS51.orig   "YES"    }
            {adapters/xml/ep2/axsep006nodechar.i "CST"    ttICMS51.CST    "YES"    }
            {adapters/xml/ep2/axsep006nodechar.i "modBC"  ttICMS51.modBC  "YES"    }
            {adapters/xml/ep2/axsep006nodedec.i  "pRedBC" ttICMS51.pRedBC "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vBC"    ttICMS51.vBC    "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "pICMS"  ttICMS51.pICMS  "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vICMS"  ttICMS51.vICMS  "YES" "2"}

            PUT SKIP.
            /*fim "N07"*/
        END.

        FOR EACH ttICMS60
           WHERE ttICMS60.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMS60.SerieNF      = ttDet.SerieNF     
             AND ttICMS60.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMS60.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMS60.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N08|Orig|CST|VBCST|VICMSST|*/
            PUT "N08" "|".
    
            {adapters/xml/ep2/axsep006nodechar.i "orig"    ttICMS60.orig    "YES"    }
            {adapters/xml/ep2/axsep006nodechar.i "CST"     ttICMS60.CST     "YES"    }
            {adapters/xml/ep2/axsep006nodedec.i  "vBCST"   ttICMS60.vBCST   "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vICMSST" ttICMS60.vICMSST "YES" "2"}
        
            PUT SKIP.
            /*fim "N08"*/
        END.

        FOR EACH ttICMS70
           WHERE ttICMS70.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMS70.SerieNF      = ttDet.SerieNF     
             AND ttICMS70.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMS70.NrSeqFatNF   = ttDet.NrSeqFatNF 
             AND ttICMS70.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N09|Orig|CST|ModBC|PRedBC|VBC|PICMS|VICMS|ModBCST|PMVAST|PRedBCST|VBCST|PICMSST|VICMSST|*/
            PUT "N09" "|".

            {adapters/xml/ep2/axsep006nodechar.i "orig"     ttICMS70.orig     "YES"    }
            {adapters/xml/ep2/axsep006nodechar.i "CST"      ttICMS70.CST      "YES"    }
            {adapters/xml/ep2/axsep006nodechar.i "modBC"    ttICMS70.modBC    "YES"    }
            {adapters/xml/ep2/axsep006nodedec.i  "pRedBC"   ttICMS70.pRedBC   "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vBC"      ttICMS70.vBC      "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "pICMS"    ttICMS70.pICMS    "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vICMS"    ttICMS70.vICMS    "YES" "2"}
            {adapters/xml/ep2/axsep006nodechar.i "modBCST"  ttICMS70.modBCST  "YES"    }
            {adapters/xml/ep2/axsep006nodedec.i  "pMVAST"   ttICMS70.pMVAST   "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "pRedBCST" ttICMS70.pRedBCST "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vBCST"    ttICMS70.vBCST    "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "pICMSST"  ttICMS70.pICMSST  "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vICMSST"  ttICMS70.vICMSST  "YES" "2"}

            PUT SKIP.
            /*fim "N09"*/
        END.

        FOR EACH ttICMS90
           WHERE ttICMS90.CodEstabelNF = ttDet.CodEstabelNF
             AND ttICMS90.SerieNF      = ttDet.SerieNF     
             AND ttICMS90.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttICMS90.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttICMS90.ItCodigoNF   = ttDet.ItCodigoNF :

            /*N10|Orig|CST|ModBC|PRedBC|VBC|PICMS|VICMS|ModBCST|PMVAST|PRedBCST|VBCST|PICMSST|VICMSST|*/
            PUT "N10" "|".

            {adapters/xml/ep2/axsep006nodechar.i "orig"     ttICMS90.orig     "YES"    }
            {adapters/xml/ep2/axsep006nodechar.i "CST"      ttICMS90.CST      "YES"    }
            {adapters/xml/ep2/axsep006nodechar.i "modBC"    ttICMS90.modBC    "YES"    }
            {adapters/xml/ep2/axsep006nodedec.i  "pRedBC"   ttICMS90.pRedBC   "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vBC"      ttICMS90.vBC      "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "pICMS"    ttICMS90.pICMS    "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vICMS"    ttICMS90.vICMS    "YES" "2"}
            {adapters/xml/ep2/axsep006nodechar.i "modBCST"  ttICMS90.modBCST  "YES"    }
            {adapters/xml/ep2/axsep006nodedec.i  "pMVAST"   ttICMS90.pMVAST   "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "pRedBCST" ttICMS90.pRedBCST "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vBCST"    ttICMS90.vBCST    "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "pICMSST"  ttICMS90.pICMSST  "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vICMSST"  ttICMS90.vICMSST  "YES" "2"}

            PUT SKIP.
            /*fim "N10"*/
        END.

END PROCEDURE.

PROCEDURE pi-imprime-IPI-txt:

        FOR EACH ttIPI
           WHERE ttIPI.CodEstabelNF = ttDet.CodEstabelNF
             AND ttIPI.SerieNF      = ttDet.SerieNF     
             AND ttIPI.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttIPI.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttIPI.ItCodigoNF   = ttDet.ItCodigoNF :

            /*O|ClEnq|CNPJProd|CSelo|QSelo|CEnq|*/
            PUT "O" "|".

            {adapters/xml/ep2/axsep006nodechar.i "clEnq"    ttIPI.clEnq    "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "CNPJProd" ttIPI.CNPJProd "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "cSelo"    ttIPI.cSelo    "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "qSelo"    ttIPI.qSelo    "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "cEnq"     ttIPI.cEnq     "YES"}

            PUT SKIP.
            /*fim "O08"*/

            IF  NOT ttIPI.l-ipi-trib THEN DO:

                /*O08|CST|*/
                PUT "O08" "|".

                {adapters/xml/ep2/axsep006nodechar.i "CST"   ttIPI.CSTIPINT "YES"}

                PUT SKIP.
                /*fim "O08"*/
            END.
            ELSE DO:

                /*O07|CST|VIPI|*/
                PUT "O07" "|".
            
                {adapters/xml/ep2/axsep006nodechar.i "CST"   ttIPI.CSTIPITrib "YES"    }
                {adapters/xml/ep2/axsep006nodedec.i  "vIPI"  ttIPI.vIPI       "YES" "2"}

                PUT SKIP.
                /*fim "O07"*/

                IF ttIPI.qUnid <> 0 AND ttIPI.qUnid <> ? AND 
                   ttIPI.vUnid <> 0 AND ttIPI.vUnid <> ? THEN DO: /* IPI por Unidade, CST = 50 */
                
                    /*O11|QUnid|VUnid|*/
                    PUT "O11" "|".
    
                    {adapters/xml/ep2/axsep006nodedec.i  "qUnid" ttIPI.qUnid      "YES" "4"}
                    {adapters/xml/ep2/axsep006nodedec.i  "vUnid" ttIPI.vUnid      "YES" "4"}
    
                    PUT SKIP.
                    /*fim "O11"*/
                END.
                ELSE DO:
                    /*O10|VBC|PIPI|*/
                    PUT "O10" "|".
    
                    {adapters/xml/ep2/axsep006nodedec.i  "vBC"   ttIPI.vBC        "YES" "2"}
                    {adapters/xml/ep2/axsep006nodedec.i  "pIPI"  ttIPI.pIPI       "YES" "2"}
    
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

            /*P|VBC|VDespAdu|VII|VIOF|*/
            PUT "P" "|".
    
            {adapters/xml/ep2/axsep006nodedec.i "vBC"      ttII.vBC      "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i "vDespAdu" ttII.vDespAdu "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i "vII"      ttII.vII      "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i "vIOF"     ttII.vIOF     "YES" "2"}

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

            /*Q02|CST|VBC|PPIS|VPIS|*/
            PUT "Q02" "|".

            {adapters/xml/ep2/axsep006nodechar.i "CST"  ttPISAliq.CST  "YES"    }
            {adapters/xml/ep2/axsep006nodedec.i  "vBC"  ttPISAliq.vBC  "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "pPIS" ttPISAliq.pPIS "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vPIS" ttPISAliq.vPIS "YES" "2"}

            PUT SKIP.
            /*fim "Q02"*/
        END.

        FOR EACH ttPISQtde
           WHERE ttPISQtde.CodEstabelNF = ttDet.CodEstabelNF
             AND ttPISQtde.SerieNF      = ttDet.SerieNF     
             AND ttPISQtde.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttPISQtde.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttPISQtde.ItCodigoNF   = ttDet.ItCodigoNF :

            /*Q03|CST|QBCProd|VAliqProd|VPIS|*/
            PUT "Q03" "|".

            {adapters/xml/ep2/axsep006nodechar.i "CST"       ttPISQtde.CST       "YES"    }
            {adapters/xml/ep2/axsep006nodedec.i  "qBCProd"   ttPISQtde.qBCProd   "YES" "4"}
            {adapters/xml/ep2/axsep006nodedec.i  "vAliqProd" ttPISQtde.vAliqProd "YES" "4"}
            {adapters/xml/ep2/axsep006nodedec.i  "vPIS"      ttPISQtde.vPIS      "YES" "2"}

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

            {adapters/xml/ep2/axsep006nodechar.i "CST" ttPISNT.CST "YES"}

            PUT SKIP.
            /*fim "Q04"*/
        END.
        
        FOR EACH ttPISOutr
           WHERE ttPISOutr.CodEstabelNF = ttDet.CodEstabelNF
             AND ttPISOutr.SerieNF      = ttDet.SerieNF     
             AND ttPISOutr.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttPISOutr.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttPISOutr.ItCodigoNF   = ttDet.ItCodigoNF :

            /*Q05|CST|VPIS|*/
            PUT "Q05" "|".

            {adapters/xml/ep2/axsep006nodechar.i "CST"       ttPISOutr.CST  "YES"    }
            {adapters/xml/ep2/axsep006nodedec.i  "vPIS"      ttPISOutr.vPIS "YES" "2"}

            PUT SKIP.
            /*fim "Q05"*/

            IF  ttPISOutr.vAliqProd <> 0
            AND ttPISOutr.vAliqProd <> ? THEN DO:

                /*Q10|QBCProd|VAliqProd|*/
                PUT "Q10" "|".

                {adapters/xml/ep2/axsep006nodedec.i "qBCProd"   ttPISOutr.qBCProd   "YES" "4"}
                {adapters/xml/ep2/axsep006nodedec.i "vAliqProd" ttPISOutr.vAliqProd "YES" "4"}

                PUT SKIP.
                /*fim "Q10"*/
            END.
            ELSE DO:

                /*Q07|VBC|PPIS|*/
                PUT "Q07" "|".

                {adapters/xml/ep2/axsep006nodedec.i "vBC"       ttPISOutr.vBC  "YES" "2"}
                {adapters/xml/ep2/axsep006nodedec.i "pPIS"      ttPISOutr.pPIS "YES" "2"}

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

            /*R|VPIS|*/
            PUT "R" "|".
            
            {adapters/xml/ep2/axsep006nodedec.i "vPIS"      ttPISST.vPIS      "YES" "2"}

            PUT SKIP.
            /*fim "R"*/

            IF  ttPISST.vAliqProd <> 0
            AND ttPISST.vAliqProd <> ? THEN DO:

                /*R04|QBCProd|VAliqProd|*/
                PUT "R04" "|". 

                {adapters/xml/ep2/axsep006nodedec.i "qBCProd"   ttPISST.qBCProd   "YES" "4"}
                {adapters/xml/ep2/axsep006nodedec.i "vAliqProd" ttPISST.vAliqProd "YES" "4"}

                PUT SKIP.
                /*fim "R04"*/
            END.
            ELSE DO:

                /*R02|VBC|PPIS|*/
                PUT "R02" "|".

                {adapters/xml/ep2/axsep006nodedec.i "vBC"       ttPISST.vBC       "YES" "2"}
                {adapters/xml/ep2/axsep006nodedec.i "pPIS"      ttPISST.pPIS      "YES" "2"}

                PUT SKIP.
                /*fim "R02"*/
            END.
        END.

END PROCEDURE.

PROCEDURE pi-imprime-COFINS-txt:

        PUT "S|" SKIP.

        FOR EACH ttCOFINSAliq
           WHERE ttCOFINSAliq.CodEstabelNF = ttDet.CodEstabelNF
             AND ttCOFINSAliq.SerieNF      = ttDet.SerieNF     
             AND ttCOFINSAliq.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttCOFINSAliq.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttCOFINSAliq.ItCodigoNF   = ttDet.ItCodigoNF:

            /*S02|CST|VBC|PCOFINS|VCOFINS|*/
            PUT "S02" "|".

            {adapters/xml/ep2/axsep006nodechar.i "CST"     ttCOFINSAliq.CST     "YES"    }
            {adapters/xml/ep2/axsep006nodedec.i  "vBC"     ttCOFINSAliq.vBC     "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "pCOFINS" ttCOFINSAliq.pCOFINS "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vCOFINS" ttCOFINSAliq.vCOFINS "YES" "2"}

            PUT SKIP.
            /*fim "S02"*/
        END.
        
        FOR EACH ttCOFINSQtde
           WHERE ttCOFINSQtde.CodEstabelNF = ttDet.CodEstabelNF
             AND ttCOFINSQtde.SerieNF      = ttDet.SerieNF     
             AND ttCOFINSQtde.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttCOFINSQtde.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttCOFINSQtde.ItCodigoNF   = ttDet.ItCodigoNF:

            /*S03|CST|QBCProd|VAliqProd|VCOFINS|*/
            PUT "S03" "|".

            {adapters/xml/ep2/axsep006nodechar.i "CST"       ttCOFINSQtde.CST       "YES"    }
            {adapters/xml/ep2/axsep006nodedec.i  "qBCProd"   ttCOFINSQtde.qBCProd   "YES" "4"}
            {adapters/xml/ep2/axsep006nodedec.i  "vAliqProd" ttCOFINSQtde.vAliqProd "YES" "4"}
            {adapters/xml/ep2/axsep006nodedec.i  "vCOFINS"   ttCOFINSQtde.vCOFINS   "YES" "2"}

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

            {adapters/xml/ep2/axsep006nodechar.i "CST" ttCOFINSNT.CST "YES"}

            PUT SKIP.
            /*fim "S04"*/
        END.

        FOR EACH ttCOFINSOutr
           WHERE ttCOFINSOutr.CodEstabelNF = ttDet.CodEstabelNF
             AND ttCOFINSOutr.SerieNF      = ttDet.SerieNF     
             AND ttCOFINSOutr.NrNotaFisNF  = ttDet.NrNotaFisNF 
             AND ttCOFINSOutr.NrSeqFatNF   = ttDet.NrSeqFatNF
             AND ttCOFINSOutr.ItCodigoNF   = ttDet.ItCodigoNF:

            /*S05|CST|VCOFINS|*/
            PUT "S05" "|".

            {adapters/xml/ep2/axsep006nodechar.i "CST"       ttCOFINSOutr.CST     "YES"    }
            {adapters/xml/ep2/axsep006nodedec.i  "vCOFINS"   ttCOFINSOutr.vCOFINS "YES" "2"}

            PUT SKIP.
            /*fim "S05"*/

            IF  ttCOFINSOutr.vAliqProd <> 0
            AND ttCOFINSOutr.vAliqProd <> ? THEN DO:

                /*S09|QBCProd|VAliqProd|*/
                PUT "S09" "|".

                {adapters/xml/ep2/axsep006nodedec.i "qBCProd"   ttCOFINSOutr.qBCProd   "YES" "4"}
                {adapters/xml/ep2/axsep006nodedec.i "vAliqProd" ttCOFINSOutr.vAliqProd "YES" "4"}

                PUT SKIP.
                /*fim "S09"*/
            END.
            ELSE DO:

                /*S07|VBC|PCOFINS|*/
                PUT "S07" "|".

                {adapters/xml/ep2/axsep006nodedec.i "vBC"       ttCOFINSOutr.vBC       "YES" "2"}
                {adapters/xml/ep2/axsep006nodedec.i "pCOFINS"   ttCOFINSOutr.pCOFINS   "YES" "2"}

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

            /*T|VCOFINS|*/
            PUT "T" "|".

            {adapters/xml/ep2/axsep006nodedec.i "vCOFINS"   ttCOFINSST.vCOFINS   "YES" "2"}

            PUT SKIP.
            /*fim "T"*/

            IF  ttCOFINSST.vAliqProd <> 0
            AND ttCOFINSST.vAliqProd <> ? THEN DO:

                /*T04|QBCProd|VAliqProd|*/
                PUT "T04" "|".

                {adapters/xml/ep2/axsep006nodedec.i "qBCProd"   ttCOFINSST.qBCProd   "YES" "4"}
                {adapters/xml/ep2/axsep006nodedec.i "vAliqProd" ttCOFINSST.vAliqProd "YES" "4"}

                PUT SKIP.
                /*fim "T04"*/
            END.
            ELSE DO:

                /*T02|VBC|PCOFINS|*/
                PUT "T02" "|".

                {adapters/xml/ep2/axsep006nodedec.i "vBC"       ttCOFINSST.vBC       "YES" "2"}
                {adapters/xml/ep2/axsep006nodedec.i "pCOFINS"   ttCOFINSST.pCOFINS   "YES" "2"}   

                PUT SKIP.
                /*fim "T02"*/
            END.
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

            /*U|VBC|VAliq|VISSQN|CMunFG|CListServ|*/
            PUT "U" "|".

            {adapters/xml/ep2/axsep006nodedec.i  "vBC"       ttISSQN.vBC       "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vAliq"     ttISSQN.vAliq     "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vISSQN"    ttISSQN.vISSQN    "YES" "2"}
            {adapters/xml/ep2/axsep006nodechar.i "cMunFG"    ttISSQN.cMunFG    "YES"    }
            {adapters/xml/ep2/axsep006nodechar.i "cListServ" ttISSQN.cListServ "YES"    }

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

        /*W02|VBC|VICMS|VBCST|VST|VProd|VFrete|VSeg|VDesc|VII|VIPI|VPIS|VCOFINS|VOutro|VNF|*/
        PUT "W02" "|".

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
        /*ASSIGN ttICMSTot.vNF = ttICMSTot.vNF + ttICMSTot.vST.*/
        {adapters/xml/ep2/axsep006nodedec.i "vNF"     ttICMSTot.vNF     "YES" "2"}

        PUT SKIP.
        /*fim "W02"*/
    END.

    FOR EACH ttISSQNtot
       WHERE ttISSQNtot.CodEstabelNF = ttNFe.CodEstabelNF
         AND ttISSQNtot.SerieNF      = ttNFe.SerieNF     
         AND ttISSQNtot.NrNotaFisNF  = ttNFe.NrNotaFisNF :

        /*W17|VServ|VBC|VISS|VPIS|VCOFINS|*/
        PUT "W17" "|".

        {adapters/xml/ep2/axsep006nodedec.i "vServ"   ttISSQNtot.vServ   "YES"  "2"} 
        {adapters/xml/ep2/axsep006nodedec.i "vBC"     ttISSQNtot.vBC     "YES"  "2"}  
        {adapters/xml/ep2/axsep006nodedec.i "vISS"    ttISSQNtot.vISS    "YES"  "2"}
        {adapters/xml/ep2/axsep006nodedec.i "vPIS"    ttISSQNtot.vPIS    "YES"  "2"}
        {adapters/xml/ep2/axsep006nodedec.i "vCOFINS" ttISSQNtot.vCOFINS "YES"  "2"} 

        PUT SKIP.
        /*fim "W17"*/
    END.

    FOR EACH ttRetTrib
       WHERE ttRetTrib.CodEstabelNF = ttNFe.CodEstabelNF 
         AND ttRetTrib.SerieNF      = ttNFe.SerieNF      
         AND ttRetTrib.NrNotaFisNF  = ttNFe.NrNotaFisNF :

        /*W23|VRetPIS|VRetCOFINS|VRetCSLL|VBCIRRF|VIRRF|VBCRetPrev|VRetPrev|*/
        PUT "W23" "|".

        {adapters/xml/ep2/axsep006nodedec.i "vRetPIS"     ttRetTrib.vRetPIS     "YES"  "2"}
        {adapters/xml/ep2/axsep006nodedec.i "vRetCOFINS"  ttRetTrib.vRetCOFINS  "YES"  "2"}
        {adapters/xml/ep2/axsep006nodedec.i "vRetCSLL"    ttRetTrib.vRetCSLL    "YES"  "2"}
        {adapters/xml/ep2/axsep006nodedec.i "vBCIRRF"     ttRetTrib.vBCIRRF     "YES"  "2"}
        {adapters/xml/ep2/axsep006nodedec.i "vIRRF"       ttRetTrib.vIRRF       "YES"  "2"}
        {adapters/xml/ep2/axsep006nodedec.i "vBCRetPrev"  ttRetTrib.vBCRetPrev  "YES"  "2"}
        {adapters/xml/ep2/axsep006nodedec.i "vRetPrev"    ttRetTrib.vRetPrev    "YES"  "2"}

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

        {adapters/xml/ep2/axsep006nodechar.i "modFrete" ttTransp.modFrete "YES"}

        PUT SKIP.
        /*fim "X"*/

        /*X03|XNome|IE|XEnder|UF|XMun|*/
        PUT "X03" "|".

        {adapters/xml/ep2/axsep006nodechar.i "xNome"  ttTransp.xNome  "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "IE"     ttTransp.IE     "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "xEnder" ttTransp.xEnder "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "UF"     ttTransp.UF     "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "xMun"   ttTransp.xMun   "YES"}

        PUT SKIP.
        /*fim "X03"*/

        IF  ttTransp.i-natureza = 1 THEN DO: /*Pessoa F°sica*/

            /*X05|CPF|*/
            PUT "X05" "|".

            {adapters/xml/ep2/axsep006nodechar.i "CPF"    ttTransp.CPF    "YES"}

            PUT SKIP.
            /*fim "X05"*/
        END.
        ELSE DO: /*Pessoa Jur°dica*/

            /*X04|CNPJ|*/
            PUT "X04" "|".

            {adapters/xml/ep2/axsep006nodechar.i "CNPJ"   ttTransp.CNPJ   "YES"}

            PUT SKIP.
            /*fim "X04"*/
        END.

        IF  (ttTransp.vServ    <> 0  AND ttTransp.vServ    <> ?)
        AND (ttTransp.vBCRet   <> 0  AND ttTransp.vBCRet   <> ?)
        AND (ttTransp.pICMSRet <> 0  AND ttTransp.pICMSRet <> ?)
        AND (ttTransp.vICMSRet <> 0  AND ttTransp.vICMSRet <> ?)
        AND (ttTransp.CFOP     <> "" AND ttTransp.CFOP     <> ?)
        AND (ttTransp.cMunFG   <> "" AND ttTransp.cMunFG   <> ?)
        THEN DO:

            /*X11|VServ|VBCRet|PICMSRet|VICMSRet|CFOP|CMunFG|*/
            PUT "X11" "|".

            {adapters/xml/ep2/axsep006nodedec.i  "vServ"    ttTransp.vServ    "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vBCRet"   ttTransp.vBCRet   "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "pICMSRet" ttTransp.pICMSRet "YES" "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vICMSRet" ttTransp.vICMSRet "YES" "2"}
            {adapters/xml/ep2/axsep006nodechar.i "CFOP"     ttTransp.CFOP     "YES"    }
            {adapters/xml/ep2/axsep006nodechar.i "cMunFG"   ttTransp.cMunFG   "YES"    }
            
            PUT SKIP.
            /*fim "X11"*/
        END.

        IF  (ttTransp.placa   <> "" AND ttTransp.placa   <> ?)
        AND (ttTransp.UFplaca <> "" AND ttTransp.UFplaca <> ?)
        THEN DO:

            /*X18|Placa|UF|RNTC|*/
            PUT "X18" "|".
        
            {adapters/xml/ep2/axsep006nodechar.i "placa" ttTransp.placa   "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "UF"    ttTransp.UFplaca "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "RNTC"  ttTransp.RNTC    "YES"}
            
            PUT SKIP.
            /*fim "X18"*/
        END.

        FOR EACH  ttReboque
           WHERE  ttReboque.CodEstabelNF = ttTransp.CodEstabelNF
             AND  ttReboque.SerieNF      = ttTransp.SerieNF     
             AND  ttReboque.NrNotaFisNF  = ttTransp.NrNotaFisNF
             AND (ttReboque.placa       <> "" AND ttReboque.placa       <> ?)
             AND (ttReboque.UF          <> "" AND ttReboque.UF          <> ?) :

            /*X22|Placa|UF|RNTC|*/
            PUT "X22" "|".
            
            {adapters/xml/ep2/axsep006nodechar.i "placa" ttReboque.placa "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "UF"    ttReboque.UF    "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "RNTC"  ttReboque.RNTC  "YES"}
            
            PUT SKIP.
            /*fim "X22"*/

        END.
        FOR EACH ttVol
           WHERE ttVol.CodEstabelNF = ttTransp.CodEstabelNF
             AND ttVol.SerieNF      = ttTransp.SerieNF     
             AND ttVol.NrNotaFisNF  = ttTransp.NrNotaFisNF :

            /*X26|QVol|Esp|Marca|NVol|PesoL|PesoB|*/
            PUT "X26" "|".

            {adapters/xml/ep2/axsep006nodechar.i "qVol"  ttVol.qVol  "YES"    }
            {adapters/xml/ep2/axsep006nodechar.i "esp"   ttVol.esp   "YES"    }
            {adapters/xml/ep2/axsep006nodechar.i "marca" ttVol.marca "YES"    }
            {adapters/xml/ep2/axsep006nodechar.i "nVol"  ttVol.nVol  "YES"    }
            {adapters/xml/ep2/axsep006nodedec.i  "pesoL" ttVol.pesoL "YES" "3"}
            {adapters/xml/ep2/axsep006nodedec.i  "pesoB" ttVol.pesoB "YES" "3"}

            PUT SKIP.
            /*fim "X26"*/

            FOR EACH  ttLacres 
               WHERE  ttLacres.CodEstabelNF = ttVol.CodEstabelNF
                 AND  ttLacres.SerieNF      = ttVol.SerieNF     
                 AND  ttLacres.NrNotaFisNF  = ttVol.NrNotaFisNF 
                 AND  ttLacres.nVol         = ttVol.nVol
                 AND (ttLacres.nLacre      <> "" AND ttLacres.nLacre <> ?):

                /*X33|NLacre|*/
                PUT "X33" "|".

                {adapters/xml/ep2/axsep006nodechar.i "nLacre" ttLacres.nLacre "YES"}
                
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

            /*Y02|NFat|VOrig|VDesc|VLiq|*/
            PUT "Y02" "|".

            {adapters/xml/ep2/axsep006nodechar.i "nFat"  ttCobr.nFat  "YES"     }
            {adapters/xml/ep2/axsep006nodedec.i  "vOrig" ttCobr.vOrig "YES"  "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vDesc" ttCobr.vDesc "YES"  "2"}
            {adapters/xml/ep2/axsep006nodedec.i  "vLiq"  ttCobr.vLiq  "YES"  "2"}

            PUT SKIP.
            /*fim "Y02"*/
        END.
    END.
    
    FOR EACH ttDup
       WHERE ttDup.CodEstabelNF = ttNFe.CodEstabelNF
         AND ttDup.SerieNF      = ttNFe.SerieNF
         AND ttDup.NrNotaFisNF  = ttNFe.NrNotaFisNF:

        /*Y07|NDup|DVenc|VDup|*/
        PUT "Y07" "|".
        
        {adapters/xml/ep2/axsep006nodechar.i "nDup"  ttDup.nDup  "YES"    }
        {adapters/xml/ep2/axsep006nodedate.i "dVenc" ttDup.dVenc "YES"    }
        {adapters/xml/ep2/axsep006nodedec.i  "vDup"  ttDup.vDup  "YES" "2"}
        
        PUT SKIP.
        /*fim "Y07"*/
    END.
    

END PROCEDURE.

PROCEDURE pi-imprime-InfAdic-txt:

    FOR EACH ttInfAdic
       WHERE ttInfAdic.CodEstabelNF = ttNFe.CodEstabelNF
         AND ttInfAdic.SerieNF      = ttNFe.SerieNF     
         AND ttInfAdic.NrNotaFisNF  = ttNFe.NrNotaFisNF :

        /*Z|InfAdFisco|InfCpl|*/
        PUT "Z" "|".
        
        {adapters/xml/ep2/axsep006nodechar.i  "infAdFisco" ttInfAdic.infAdFisco "YES"}
        {adapters/xml/ep2/axsep006nodechar2.i "infCpl"     ttInfAdic.infCpl     "YES"}

        PUT SKIP.
        /*fim "Z"*/

        FOR EACH ttObsCont
           WHERE ttObsCont.CodEstabelNF = ttNFe.CodEstabelNF
             AND ttObsCont.SerieNF      = ttNFe.SerieNF     
             AND ttObsCont.NrNotaFisNF  = ttNFe.NrNotaFisNF
             AND (ttObsCont.xTexto      <> ?
             AND  ttObsCont.xTexto      <> ""):

            /*Z04|XCampo|XTexto|*/
            PUT "Z04" "|".

            {adapters/xml/ep2/axsep006nodechar2.i "xCampo" ttObsCont.xCampo "YES"}
            {adapters/xml/ep2/axsep006nodechar2.i "xTexto" ttObsCont.xTexto "YES"}

            PUT SKIP.
            /*fim "Z04"*/
        END.

        FOR EACH ttObsFisco
           WHERE ttObsFisco.CodEstabelNF = ttNFe.CodEstabelNF 
             AND ttObsFisco.SerieNF      = ttNFe.SerieNF      
             AND ttObsFisco.NrNotaFisNF  = ttNFe.NrNotaFisNF
             AND (ttObsFisco.xTexto     <> ?
             AND  ttObsFisco.xTexto     <> ""):

            /*Z04|XCampo|XTexto|*/
            PUT "Z04" "|".

            {adapters/xml/ep2/axsep006nodechar2.i "xCampo" ttObsFisco.xCampo "YES"}
            {adapters/xml/ep2/axsep006nodechar2.i "xTexto" ttObsFisco.xTexto "YES"}
             
            PUT SKIP.
            /*fim "Z04"*/
        END.

        FOR EACH ttProcRef
           WHERE ttProcRef.CodEstabelNF = ttNFe.CodEstabelNF
             AND ttProcRef.SerieNF      = ttNFe.SerieNF     
             AND ttProcRef.NrNotaFisNF  = ttNFe.NrNotaFisNF
             AND (ttProcRef.nProc   <> ? AND ttProcRef.nProc   <> "")
             AND (ttProcRef.indProc <> ? AND ttProcRef.indProc <> "") :

            /*Z10|NProc|IndProc|*/
            PUT "Z10" "|".
            
            {adapters/xml/ep2/axsep006nodechar.i "nProc"   ttProcRef.nProc   "YES"}
            {adapters/xml/ep2/axsep006nodechar.i "indProc" ttProcRef.indProc "YES"}
            
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
         AND (ttExporta.UFEmbarq   <> ? AND ttExporta.UFEmbarq   <> "")
         AND (ttExporta.xLocEmbarq <> ? AND ttExporta.xLocEmbarq <> ""):

        /*ZA|UFEmbarq|XLocEmbarq|*/
        PUT "ZA" "|".

        {adapters/xml/ep2/axsep006nodechar.i "UFEmbarq"   ttExporta.UFEmbarq   "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "xLocEmbarq" ttExporta.xLocEmbarq "YES"}
        
        PUT SKIP.
        /*fim "ZA"*/
    END.

END PROCEDURE.

PROCEDURE pi-imprime-Compra-txt:

    FOR EACH  ttCompra
       WHERE  ttCompra.CodEstabelNF = ttNFe.CodEstabelNF
         AND  ttCompra.SerieNF      = ttNFe.SerieNF     
         AND  ttCompra.NrNotaFisNF  = ttNFe.NrNotaFisNF
         AND (ttCompra.xNEmp <> ? AND ttCompra.xNEmp <> "")
         AND (ttCompra.xPed  <> ? AND ttCompra.xPed  <> "")
         AND (ttCompra.xCont <> ? AND ttCompra.xCont <> "") :

        /*ZB|XNEmp|XPed|XCont|*/
        PUT "ZB" "|".

        {adapters/xml/ep2/axsep006nodechar.i "xNEmp" ttCompra.xNEmp "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "xPed"  ttCompra.xPed  "YES"}
        {adapters/xml/ep2/axsep006nodechar.i "xCont" ttCompra.xCont "YES"}
        
        PUT SKIP.
        /*fim "ZB"*/
    END.

END PROCEDURE.


/*------------------------------- ESTABELEC (Emitente da NF-e) --------------------------------*/

PROCEDURE pi-imprime-TXT-Emit:

    /*--- Exporta para o Software Emissor NF-e Estabelecimentos parametrizados para NF-e (Homologaá∆o e/ou Produá∆o) ---*/

    /* Imprime TXT Emissor */
    OUTPUT TO VALUE(pcArquivoEmitTXT).

        /*
        EMITENTE|quantidade de registros de emitente no arquivo|
        C|tpDoc|numDoc|XNome|XFant|IE|IEST|IM|CNAE|XLgr|Nro|Cpl|Bairro|CMun|XMun|UF|CEP|CPais|XPais|Fone|
        */
    
        FOR FIRST ttEmit NO-LOCK:

            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-emitente1 AS CHARACTER FORMAT "X(13)" NO-UNDO.
            {utp/ut-liter.i "EMITENTE|1|" *}
            ASSIGN c-lbl-liter-emitente1 = TRIM(RETURN-VALUE).
            PUT c-lbl-liter-emitente1 SKIP. /* 1 -> sempre ser† exportado apenas 1, pois s¢ se pode gerar notas de 1 estabelecimento */
            PUT "A" "|" ttEmit.VersaoLayout "|" SKIP.
            PUT "C" "|".
    
            /*tpDoc  -> Preencher com o tipo de documento: inserir a palavra "CPF" caso pessoa f°sica ou "CNPJ" caso pessoa jur°dica*/
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-cnpj AS CHARACTER FORMAT "X(6)" NO-UNDO.
            {utp/ut-liter.i "CNPJ" *}
            ASSIGN c-lbl-liter-cnpj = TRIM(RETURN-VALUE).
            PUT c-lbl-liter-cnpj "|".
    
            /*numDoc -> N£mero do CPF com 11 d°gitos (caso o tpDoc for preenchido com …CPF ) ou o n£mero do CNPJ com 14 d°gitos (caso tpDoc for preenchido com …CNPJ )*/
            {adapters/xml/ep2/axsep006nodechar.i "CNPJ"    ttEmit.CNPJ    "YES"}
    
            /*XNome|XFant|IE|IEST|IM|CNAE|XLgr|Nro|Cpl|Bairro|CMun|XMun|UF|CEP|CPais|XPais|Fone*/
    
            {adapters/xml/ep2/axsep006nodechar.i  "xNome"   ttEmit.xNome   "YES"}
            {adapters/xml/ep2/axsep006nodechar.i  "xFant"   ttEmit.xFant   "YES"}
            {adapters/xml/ep2/axsep006nodechar.i  "IE"      ttEmit.IE      "YES"}
            {adapters/xml/ep2/axsep006nodechar.i  "IEST"    ttEmit.IEST    "YES"}
            {adapters/xml/ep2/axsep006nodechar.i  "IM"      ttEmit.IM      "YES"}
            {adapters/xml/ep2/axsep006nodechar.i  "CNAE"    ttEmit.CNAE    "YES"}
            {adapters/xml/ep2/axsep006nodechar.i  "xLgr"    ttEmit.xLgr    "YES"}
            {adapters/xml/ep2/axsep006nodechar.i  "nro"     ttEmit.nro     "YES"}
            {adapters/xml/ep2/axsep006nodechar.i  "xCpl"    ttEmit.xCpl    "YES"}
            {adapters/xml/ep2/axsep006nodechar.i  "xBairro" ttEmit.xBairro "YES"}
            {adapters/xml/ep2/axsep006nodechar.i  "cMun"    ttEmit.cMun    "YES"}
            
            IF ttEmit.xMun = "Exterior" THEN DO:
            {adapters/xml/ep2/axsep006nodechar2.i "xMun"    ttEmit.xMun    "YES"}
            END.
            ELSE DO:
            {adapters/xml/ep2/axsep006nodechar.i  "xMun"    ttEmit.xMun    "YES"}
            END.
            
            {adapters/xml/ep2/axsep006nodechar.i  "UF"      ttEmit.UF      "YES"}
            {adapters/xml/ep2/axsep006nodechar.i  "CEP"     ttEmit.CEP     "YES"}
            {adapters/xml/ep2/axsep006nodechar.i  "cPais"   ttEmit.cPais   "YES"} 
            {adapters/xml/ep2/axsep006nodechar.i  "xPais"   ttEmit.xPais   "YES"}
            {adapters/xml/ep2/axsep006nodechar.i  "fone"    ttEmit.fone    "YES"}
    
            PUT SKIP.
            /*fim "C"*/
        END.

    OUTPUT CLOSE. /*fecha arquivo*/

END PROCEDURE.

/*--------------------------------------------------------------------------*/



