/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
USING Progress.Json.ObjectModel.*.
{include/i-prgvrs.i axsep029IMPRIMEXML 2.00.00.002 } /*** "010002" 11/03/2026 09:40:03 ***/
{include/i-epc200.i axsep029IMPRIMEXML}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i axsep029IMPRIMEXML MUT}
&ENDIF


/*-------------------------------------------------
             axsep029IMPRIMEXML.p
-------------------------------------------------*/

{adapters/xml/ep2/axsep029.i}                  /* Defini‡äes Tabelas Tempor rias */
{adapters/xml/ep2/axsep029extradeclarations.i} /* Outras Declara‡äes             */

{cdp/cdcfgdis.i}

DEFINE INPUT PARAM PhGenXml AS HANDLE NO-UNDO .
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttStack   .
DEFINE INPUT PARAM TABLE FOR ttDCe          .
DEFINE INPUT PARAM TABLE FOR ttIdeDCe       .
DEFINE INPUT PARAM TABLE FOR ttEmitDCe      .
DEFINE INPUT PARAM TABLE FOR ttIDEmitDCe    .
DEFINE INPUT PARAM TABLE FOR ttDestDCe      .
DEFINE INPUT PARAM TABLE FOR ttDetDCe       .
DEFINE INPUT PARAM TABLE FOR ttTransp       .
DEFINE INPUT PARAM TABLE FOR ttinfAdic      .
DEFINE INPUT PARAM TABLE FOR ttinfDec       .
DEFINE INPUT PARAM TABLE FOR ttinfDCeSupl   .
DEFINE INPUT PARAM TABLE FOR ttTotalDCe     .

/*-------------------------------------------------
            axsep029IMPRIMEXML.i
-------------------------------------------------*/

RUN pi-imprime-xml.

PROCEDURE pi-imprime-xml:

    FOR FIRST ttstack: END.

    ASSIGN iId        = ?
           lLayoutXML = YES
           hGenXml    = PhGenXml.
             
    FOR EACH ttDCe:
         RUN cdp/cd0360b.p (INPUT ttDCe.NrDCe,
                            INPUT "DCe":U,
                            OUTPUT cTpTrans).
                           
         FOR FIRST estabelec
             WHERE estabelec.cod-estabel = ttDCe.NrDCe NO-LOCK:
         END.                     

         RUN addNode      IN hGenXml (getStack(), "DCe", "", OUTPUT iId).
         RUN setAttribute IN hGenXml (INPUT iId,  "xmlns",   "http://www.portalfiscal.inf.br/dce").

         addStack(iId).

              RUN addNode IN hGenXml (getStack(), "infDCe" , "", OUTPUT iId).
              addStack(iId).

                   RUN setAttribute IN hGenXml (INPUT iId, "versao", ttDCe.VersaoLayoutDCe).
                   RUN setAttribute IN hGenXml (INPUT iId, "Id",     ("DCe" + TRIM(ttDCe.ChaveAcessoDCe))).
                   
                   RUN pi-imprime-Ide-DCe.

                   RUN pi-imprime-Emit-DCe.
                   
                   RUN pi-imprime-Id-Emit-DCe.
                   
                   RUN pi-imprime-Dest-DCe.
                   
                   ASSIGN iContItem = 1.

                   FOR EACH ttDetDCe
                      WHERE ttDetDCe.CodEstabelDCe  = ttDCe.CodEstabelDCe
                        AND ttDetDCe.SerieDCe       = ttDCe.SerieDCe      
                        AND ttDetDCe.NrDCe          = ttDCe.NrDCe:        
                        
                         RUN addNode IN hGenXml (getStack(), "det", "", OUTPUT iId).
                         addStack(iId).
                
                              RUN setAttribute IN hGenXml(INPUT iId, "nItem", STRING(iContItem)).
                
                              RUN addNode IN hGenXml (getStack(), "prod", "", OUTPUT iId).
                              addStack(iId).
                
                                   RUN pi-imprime-Prod-DCe.                
                
                              delStack().
                
                         delStack().
                         
                         {adapters/xml/ep2/axsep029nodechar2.i "infAdProd" ttDetDCe.infAdProd "NO"}
                                        
                         ASSIGN iContItem = iContItem + 1.                        
                         
                   END.
                   
                   RUN pi-imprime-Total-DCe.                   

                   RUN pi-imprime-Transp-DCe.
                   
                   RUN pi-imprime-InfAdic-DCe.                   
                    
                   RUN pi-imprime-InfDec-DCe.
                   
              delStack().

              RUN pi-imprime-infSolicDCe-DCe.
              RUN pi-imprime-InfDCeSupl-DCe.

         delStack().
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-imprime-Ide-DCe:

    FOR EACH ttIdeDCe
       WHERE ttIdeDCe.CodEstabelDCe   = ttDCe.CodEstabelDCe
         AND ttIdeDCe.SerieDCe        = ttDCe.SerieDCe        
         AND ttIdeDCe.NrDCe           = ttDCe.NrDCe:        

        RUN addNode IN hGenXml (getStack(), "ide", "", OUTPUT iId).
        addStack(iId).

            {adapters/xml/ep2/axsep029nodechar.i "cUF"                    ttIdeDCe.cUF            "YES"}
            {adapters/xml/ep2/axsep029nodechar.i "cDC"                    ttIdeDCe.cDC            "YES"}
            {adapters/xml/ep2/axsep029nodechar.i "mod"                    ttIdeDCe.mod            "YES"}
            {adapters/xml/ep2/axsep029nodechar.i "serie"                  ttIdeDCe.serie          "YES"}
            {adapters/xml/ep2/axsep029nodechar.i "nDC"                    ttIdeDCe.nDC            "YES"}
            {adapters/xml/ep2/axsep029nodechar.i "dhEmi"                  ttIdeDCe.dhEmi          "YES"}
            {adapters/xml/ep2/axsep029nodechar.i "tpEmis"                 ttIdeDCe.tpEmis         "YES"}
            {adapters/xml/ep2/axsep029nodechar.i "tpEmit"                 ttIdeDCe.tpEmit         "YES"}
            {adapters/xml/ep2/axsep029nodechar.i "nSiteAutoriz"           ttIdeDCe.nSiteAutoriz   "YES"}
            {adapters/xml/ep2/axsep029nodechar.i "cDV"                    ttIdeDCe.cDV            "YES"}
            {adapters/xml/ep2/axsep029nodechar.i "tpAmb"                  ttIdeDCe.tpAmb          "YES"}
            {adapters/xml/ep2/axsep029nodechar.i "verProc"                ttIdeDCe.verProc        "YES"}
            
        delStack().
    END.

    RETURN "OK":U.
END PROCEDURE.

           
PROCEDURE pi-imprime-Emit-DCe:

    FOR EACH ttEmitDCe
       WHERE ttEmitDCe.CodEstabelDCe   = ttDCe.CodEstabelDCe
         AND ttEmitDCe.SerieDCe        = ttDCe.SerieDCe          
         AND ttEmitDCe.NrDCe           = ttDCe.NrDCe:        

        IF  NOT AVAIL ttIdeDCe THEN
            FIND FIRST ttIdeDCe NO-ERROR.
        
        RUN addNode IN hGenXml (getStack(), "emit", "", OUTPUT iId).
        addStack(iId).

            IF  ttEmitDCe.CPF <> "" THEN          
                {adapters/xml/ep2/axsep029nodechar.i "CPF"        ttEmitDCe.CPF        "YES"}
            
            IF ttEmitDCe.CPF = "" AND ttEmitDCe.CNPJ <> ""  THEN
                {adapters/xml/ep2/axsep029nodechar.i "CNPJ"       ttEmitDCe.CNPJ       "YES"}
                
            IF ttEmitDCe.CPF = "" AND ttEmitDCe.CNPJ = "" THEN
                {adapters/xml/ep2/axsep029nodechar.i "idOutros"   ttEmitDCe.idOutros   "YES"}

            {adapters/xml/ep2/axsep029nodechar.i "xNome"  ttEmitDCe.xNome "YES"}

            RUN addNode IN hGenXml (getStack(), "enderEmit", "",           OUTPUT iId).
            addStack(iId).
                {adapters/xml/ep2/axsep029nodechar.i  "xLgr"    ttEmitDCe.xLgr    "YES"}
                {adapters/xml/ep2/axsep029nodechar.i  "nro"     ttEmitDCe.nro     "YES"}
                {adapters/xml/ep2/axsep029nodechar.i  "xCpl"    ttEmitDCe.xCpl    "NO" }
                {adapters/xml/ep2/axsep029nodechar.i  "xBairro" ttEmitDCe.xBairro "YES"}
                {adapters/xml/ep2/axsep029nodechar.i  "cMun"    ttEmitDCe.cMun    "YES"}
                {adapters/xml/ep2/axsep029nodechar.i  "xMun"    ttEmitDCe.xMun    "YES"}
                {adapters/xml/ep2/axsep029nodechar.i  "UF"      ttEmitDCe.UF      "YES"}
                {adapters/xml/ep2/axsep029nodechar.i  "CEP"     ttEmitDCe.CEP     "YES"}
                {adapters/xml/ep2/axsep029nodechar.i  "cPais"   ttEmitDCe.cPais   "YES"}
                {adapters/xml/ep2/axsep029nodechar.i  "xPais"   ttEmitDCe.xPais   "YES"}
                {adapters/xml/ep2/axsep029nodechar.i  "fone"    ttEmitDCe.fone    "NO" }
            delStack().
        delStack().
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-Id-Emit-DCe:

    FOR EACH ttIDEmitDCe
       WHERE ttIDEmitDCe.CodEstabelDCe   = ttDCe.CodEstabelDCe
         AND ttIDEmitDCe.SerieDCe        = ttDCe.SerieDCe          
         AND ttIDEmitDCe.NrDCe           = ttDCe.NrDCe:        

        IF  NOT AVAIL ttIdeDCe THEN
            FIND FIRST ttIdeDCe NO-ERROR.
            
        IF  ttIdeDCe.tpEmit = "3" THEN DO: // 2=Emissor pr¢prio 3=Transportadora
                 
            RUN addNode IN hGenXml (getStack(), "Transportadora", "", OUTPUT iId).
            addStack(iId).
            
                {adapters/xml/ep2/axsep029nodechar.i "CNPJ"   ttIDEmitDCe.CNPJ  "YES"}
                {adapters/xml/ep2/axsep029nodechar.i "xNome"  ttIDEmitDCe.xNome "YES"}
            delStack().
        END.    

    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-imprime-Dest-DCe:

    FOR EACH ttDestDCe
       WHERE ttDestDCe.CodEstabelDCe   = ttDCe.CodEstabelDCe
         AND ttDestDCe.SerieDCe        = ttDCe.SerieDCe            
         AND ttDestDCe.NrDCe           = ttDCe.NrDCe:        
                                  
        RUN addNode IN hGenXml (getStack(), "dest", "", OUTPUT iId).
        addStack(iId).
        
            IF  ttDestDCe.CPF <> "" THEN          
                {adapters/xml/ep2/axsep029nodechar.i "CPF"        ttDestDCe.CPF        "YES"}
            
            IF ttDestDCe.CPF = "" AND ttDestDCe.CNPJ <> ""  THEN
                {adapters/xml/ep2/axsep029nodechar.i "CNPJ"       ttDestDCe.CNPJ       "YES"}
                
            IF ttDestDCe.CPF = "" AND ttDestDCe.CNPJ = "" THEN
                {adapters/xml/ep2/axsep029nodechar.i "idOutros"   ttDestDCe.idOutros   "YES"}
            
            {adapters/xml/ep2/axsep029nodechar.i "xNome"      ttDestDCe.xNome      "YES"}
            
            RUN addNode IN hGenXml (getStack(), "enderDest", "",           OUTPUT iId).
            addStack(iId).

                {adapters/xml/ep2/axsep029nodechar.i  "xLgr"    ttDestDCe.xLgr    "YES"}
                {adapters/xml/ep2/axsep029nodechar.i  "nro"     ttDestDCe.nro     "YES"}
                {adapters/xml/ep2/axsep029nodechar.i  "xCpl"    ttDestDCe.xCpl    "NO" }
                {adapters/xml/ep2/axsep029nodechar.i  "xBairro" ttDestDCe.xBairro "YES"}
                {adapters/xml/ep2/axsep029nodechar.i  "cMun"    ttDestDCe.cMun    "YES"}
                {adapters/xml/ep2/axsep029nodechar.i  "xMun"    ttDestDCe.xMun    "YES"}
                {adapters/xml/ep2/axsep029nodechar.i  "UF"      ttDestDCe.UF      "YES"}
                {adapters/xml/ep2/axsep029nodechar.i  "CEP"     ttDestDCe.CEP     "NO" }
                {adapters/xml/ep2/axsep029nodechar.i  "cPais"   ttDestDCe.cPais   "YES"}
                {adapters/xml/ep2/axsep029nodechar.i  "xPais"   ttDestDCe.xPais   "YES"}
                {adapters/xml/ep2/axsep029nodechar.i  "fone"    ttDestDCe.fone    "NO" }
                {adapters/xml/ep2/axsep029nodechar2.i "email"   ttDestDCe.email   "NO" }
            delStack().
        delStack().
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-imprime-Prod-DCe:
    
    {adapters/xml/ep2/axsep029nodechar2.i "xProd"  ttDetDCe.xProd  "YES"}
    {adapters/xml/ep2/axsep029nodechar.i  "NCM"    ttDetDCe.NCM    "NO"}  
    {adapters/xml/ep2/axsep029nodedec.i   "qCom"   ttDetDCe.qCom   "YES" "4" "YES"}
    {adapters/xml/ep2/axsep029nodedec.i   "vUnCom" ttDetDCe.vUnCom "YES" "8" "YES"}
    {adapters/xml/ep2/axsep029nodedec.i   "vProd"  ttDetDCe.vProd  "YES" "8" "YES"}

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-imprime-Total-DCe:

    RUN addNode IN hGenXml (getStack(), "total", "", OUTPUT iId).
    addStack(iId).
    
        FOR EACH  ttTotalDCe 
            WHERE ttTotalDCe.CodEstabelDCe   = ttDCe.CodEstabelDCe
              AND ttTotalDCe.SerieDCe        = ttDCe.SerieDCe            
              AND ttTotalDCe.NrDCe           = ttDCe.NrDCe:        

            {adapters/xml/ep2/axsep029nodedec.i "vDC" ttTotalDCe.vDC "YES" "2" "YES"}
            
        END.
    delStack().

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-imprime-Transp-DCe:

    FOR EACH ttTransp
       WHERE ttTransp.CodEstabelDCe   = ttDCe.CodEstabelDCe
         AND ttTransp.SerieDCe        = ttDCe.SerieDCe            
         AND ttTransp.NrDCe           = ttDCe.NrDCe:        
        
         RUN addNode IN hGenXml (getStack(), "transp", "", OUTPUT iId).
         addStack(iId).
             
            {adapters/xml/ep2/axsep029nodechar.i "modTrans"   ttTransp.modTrans   "YES"}
            {adapters/xml/ep2/axsep029nodechar.i "CNPJTransp" ttTransp.CNPJTransp "NO"}
         delStack().
    END.    
    
    RETURN "OK":U.
END PROCEDURE.    

PROCEDURE pi-imprime-InfAdic-DCe:

    FOR EACH ttInfAdic
       WHERE ttInfAdic.CodEstabelDCe   = ttDCe.CodEstabelDCe
         AND ttInfAdic.SerieDCe        = ttDCe.SerieDCe            
         AND ttInfAdic.NrDCe           = ttDCe.NrDCe
         AND (   (ttInfAdic.infAdFisco  <> "" AND ttInfAdic.infAdFisco  <> ?)
              OR (ttInfAdic.infCpl      <> "" AND ttInfAdic.infCpl      <> ?)
              OR (ttInfAdic.infAdTransp <> "" AND ttInfAdic.infAdTransp <> ?)):        
        
         RUN addNode IN hGenXml (getStack(), "infAdic", "", OUTPUT iId).
         addStack(iId).
             
            {adapters/xml/ep2/axsep029nodechar2.i "infAdFisco"  ttInfAdic.infAdFisco  "NO"}
            {adapters/xml/ep2/axsep029nodechar2.i "infCpl"      ttInfAdic.infCpl      "NO"}
            {adapters/xml/ep2/axsep029nodechar2.i "infAdTransp" ttInfAdic.infAdTransp "NO"}
         delStack().
    END.    
    
    RETURN "OK":U.
END PROCEDURE.    
    
PROCEDURE pi-imprime-InfDec-DCe:

    FOR EACH ttInfDec
       WHERE ttInfDec.CodEstabelDCe   = ttDCe.CodEstabelDCe
         AND ttInfDec.SerieDCe        = ttDCe.SerieDCe            
         AND ttInfDec.NrDCe           = ttDCe.NrDCe:        
        
         RUN addNode IN hGenXml (getStack(), "infDec", "", OUTPUT iId).
         addStack(iId).
             
            {adapters/xml/ep2/axsep029nodechar2.i "xObs1" ttInfDec.xObs1 "YES"}
            {adapters/xml/ep2/axsep029nodechar2.i "xObs2" ttInfDec.xObs2 "YES"}
         delStack().
    END.    
    
    RETURN "OK":U.
END PROCEDURE.    
    
    
PROCEDURE pi-imprime-infSolicDCe-DCe:

    FOR EACH ttIDEmitDCe
       WHERE ttIDEmitDCe.CodEstabelDCe   = ttDCe.CodEstabelDCe
         AND ttIDEmitDCe.SerieDCe        = ttDCe.SerieDCe          
         AND ttIDEmitDCe.NrDCe           = ttDCe.NrDCe:        

        IF  NOT AVAIL ttIdeDCe THEN
            FIND FIRST ttIdeDCe NO-ERROR.
            
        IF  ttIdeDCe.tpEmit = "2" 
        OR  ttIdeDCe.tpEmit = "3" THEN DO: // 2=Emissor pr¢prio 3=Transportadora
                 
            RUN addNode IN hGenXml (getStack(), "infSolicDCe", "", OUTPUT iId).
            addStack(iId).
            
                {adapters/xml/ep2/axsep029nodechar.i "xSolic"  ttIDEmitDCe.xNome "YES"}
            delStack().
        END.

    END.
        
END PROCEDURE.
    

PROCEDURE pi-imprime-InfDCeSupl-DCe:
    
    DEFINE VARIABLE c-qrCode AS CHARACTER NO-UNDO.
    
    FOR EACH ttInfDCeSupl
       WHERE ttInfDCeSupl.CodEstabelDCe   = ttDCe.CodEstabelDCe
         AND ttInfDCeSupl.SerieDCe        = ttDCe.SerieDCe               
         AND ttInfDCeSupl.NrDCe           = ttDCe.NrDCe:  
         
        IF  NOT AVAIL ttIdeDCe THEN
            FIND FIRST ttIdeDCe NO-ERROR.
            
        IF ttInfDCeSupl.qrCode = "" THEN
            ASSIGN ttInfDCeSupl.qrCode = "https://www.fazenda.pr.gov.br/dce/qrcode?chDCe=" + TRIM(ttDCe.ChaveAcessoDCe) + "&tpAmb=" + ttIdeDCe.tpAmb.

        IF ttInfDCeSupl.urlChave = "" THEN
            ASSIGN ttInfDCeSupl.urlChave = "http://dce.fazenda.gov.br/consultadce/" + TRIM(ttDCe.ChaveAcessoDCe).

        RUN addNode IN hGenXml (getStack(), "infDCeSupl", "", OUTPUT iId).
        addStack(iId).
       
            RUN addNode     IN hGenXml (getStack(), "qrCodDCe", ttInfDCeSupl.qrCode, OUTPUT iId).       
            {adapters/xml/ep2/axsep029nodechar2.i "urlChave" ttInfDCeSupl.urlChave "YES"}
            
        delStack().

    END.

END PROCEDURE.
