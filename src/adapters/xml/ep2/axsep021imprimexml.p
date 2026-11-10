/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSEP021IMPRIMEXML 2.00.00.018 } /*** "010018" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i axsep021imprimexml MUT}
&ENDIF

{adapters/xml/ep2/axsep021.i}
{adapters/xml/ep2/axsep021ExtraDeclarations.i}
{adapters/xml/ep2/axsep006extradeclarations.i}

{cdp/cdcfgdis.i}

DEFINE INPUT PARAM PhGenXml AS HANDLE NO-UNDO.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttStack  .
DEFINE INPUT PARAM TABLE FOR ttcondutor.
DEFINE INPUT PARAM TABLE FOR ttdisp.
DEFINE INPUT PARAM TABLE FOR ttinfCT.
DEFINE INPUT PARAM TABLE FOR ttinfCTe.
DEFINE INPUT PARAM TABLE FOR ttinfEmbComb.
DEFINE INPUT PARAM TABLE FOR ttinfMunCarrega.
DEFINE INPUT PARAM TABLE FOR ttinfMunDescarga.
DEFINE INPUT PARAM TABLE FOR ttinfNF.
DEFINE INPUT PARAM TABLE FOR ttinfNFe.
DEFINE INPUT PARAM TABLE FOR ttinfPercurso.
DEFINE INPUT PARAM TABLE FOR ttinfTermCarreg.
DEFINE INPUT PARAM TABLE FOR ttinfTermDescarreg.
DEFINE INPUT PARAM TABLE FOR ttinfUnidCarga.
DEFINE INPUT PARAM TABLE FOR ttinfUnidCarga_00.
DEFINE INPUT PARAM TABLE FOR ttinfUnidCarga_01.
DEFINE INPUT PARAM TABLE FOR ttinfUnidCarga_02.
DEFINE INPUT PARAM TABLE FOR ttinfUnidTransp.
DEFINE INPUT PARAM TABLE FOR ttinfUnidTransp_00.
DEFINE INPUT PARAM TABLE FOR ttinfUnidTransp_01.
DEFINE INPUT PARAM TABLE FOR ttinfUnidTransp_02.
DEFINE INPUT PARAM TABLE FOR ttlacres.
DEFINE INPUT PARAM TABLE FOR ttlacUnidCarga.
DEFINE INPUT PARAM TABLE FOR ttlacUnidCarga_00.
DEFINE INPUT PARAM TABLE FOR ttlacUnidCarga_01.
DEFINE INPUT PARAM TABLE FOR ttlacUnidCarga_02.
DEFINE INPUT PARAM TABLE FOR ttlacUnidTransp.
DEFINE INPUT PARAM TABLE FOR ttlacUnidTransp_00.
DEFINE INPUT PARAM TABLE FOR ttlacUnidTransp_01.
DEFINE INPUT PARAM TABLE FOR ttlacUnidTransp_02.
DEFINE INPUT PARAM TABLE FOR ttMDFe.
DEFINE INPUT PARAM TABLE FOR ttvag.
DEFINE INPUT PARAM TABLE FOR ttveicReboque.
DEFINE INPUT PARAM TABLE FOR ttCGCAutoriza. /*Novas TAGS*/

DEFINE VARIABLE c-id-mdfe     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-vers-layout AS CHARACTER NO-UNDO.

FOR FIRST ttstack: END.

ASSIGN c-id-mdfe = ""
       c-vers-layout = "1.00"
       iId        = ?
       lLayoutXML = YES
       hGenXml    = PhGenXml.

FOR EACH ttMDFe:

    ASSIGN c-id-mdfe = "MDFe" + ttMDFe.cMDF.

    RUN addNode IN hGenXml (getStack(), "MDFe", "", OUTPUT iId).
    RUN setAttribute IN hGenXml (INPUT iId,  "xmlns",   "http://www.portalfiscal.inf.br/mdfe").

    addStack(iId).
        RUN addNode IN hGenXml (getStack(), "infMDFe", "", OUTPUT iId).
        addStack(iId).
            RUN setAttribute IN hGenXml (INPUT iId, "versao", c-vers-layout).
            RUN setAttribute IN hGenXml (INPUT iId, "Id",     c-id-mdfe).

            RUN addNode IN hGenXml (getStack(), "ide", "", OUTPUT iId).
            addStack(iId).
                {adapters/xml/ep2/axsep017nodechar.i "cUF"     ttMDFe.cUF     "YES"}
                {adapters/xml/ep2/axsep017nodechar.i "tpAmb"   ttMDFe.tpAmb   "YES"}
                {adapters/xml/ep2/axsep017nodechar.i "tpEmit"  ttMDFe.tpEmit  "YES"}
                {adapters/xml/ep2/axsep017nodechar.i "mod"     ttMDFe.mod     "YES"}
                {adapters/xml/ep2/axsep017nodechar.i "serie"   ttMDFe.serie   "YES"}
                {adapters/xml/ep2/axsep017nodechar.i "nMDF"    ttMDFe.nMDF    "YES"}
                {adapters/xml/ep2/axsep017nodechar.i "cMDF"    ttMDFe.cMDFE   "YES"}
                {adapters/xml/ep2/axsep017nodechar.i "cDV"     ttMDFe.cDV     "YES"}
                {adapters/xml/ep2/axsep017nodechar.i "modal"   ttMDFe.modal   "YES"}
                {adapters/xml/ep2/axsep017nodechar.i "dhEmi"   ttMDFe.dhEmi   "YES"}
                {adapters/xml/ep2/axsep017nodechar.i "tpEmis"  ttMDFe.tpEmis  "YES"}
                {adapters/xml/ep2/axsep017nodechar.i "procEmi" ttMDFe.procEmi "YES"}
                {adapters/xml/ep2/axsep017nodechar.i "verProc" ttMDFe.verProc "YES"}
                {adapters/xml/ep2/axsep017nodechar.i "UFIni"   ttMDFe.UFIni   "YES"}
                {adapters/xml/ep2/axsep017nodechar.i "UFFim"   ttMDFe.UFFim   "YES"}
                           /*infMunCarrega*/
                FOR EACH ttinfMunCarrega OF ttMDFe:
                    RUN addNode IN hGenXml (getStack(), "infMunCarrega", "", OUTPUT iId).
                    addStack(iId).
                        {adapters/xml/ep2/axsep017nodechar.i  "cMunCarrega"    ttinfMunCarrega.cMunCarrega    "YES"}
                        IF ttinfMunCarrega.xMunCarrega = "Exterior" THEN DO:
                            {adapters/xml/ep2/axsep017nodechar.i  "xMunCarrega"    ttinfMunCarrega.xMunCarrega    "YES"}
                        END.
                        ELSE DO:
                            {adapters/xml/ep2/axsep017nodechar.i  "xMunCarrega"    ttinfMunCarrega.xMunCarrega    "YES"}
                        END.
                    delStack().
                END.
                FOR EACH ttinfPercurso OF ttMDFe:
                    RUN addNode IN hGenXml (getStack(), "infPercurso", "", OUTPUT iId).
                    addStack(iId).
                        {adapters/xml/ep2/axsep017nodechar.i "UFPer" ttinfPercurso.UFPer "YES"}
                    delStack().
                END.
            delStack().

            RUN addNode IN hGenXml (getStack(), "emit", "", OUTPUT iId).
            addStack(iId).

            {adapters/xml/ep2/axsep017nodechar.i "CNPJ"  ttMDFe.CNPJ   "YES"}
            {adapters/xml/ep2/axsep017nodechar.i "IE"    ttMDFe.IE     "YES"}
            {adapters/xml/ep2/axsep017nodechar.i "xNome" ttMDFe.xNome  "YES"}
            {adapters/xml/ep2/axsep017nodechar.i "xFant" ttMDFe.xFant  "NO" }

                RUN addNode IN hGenXml (getStack(), "enderEmit", "", OUTPUT iId).
                addStack(iId).

                    {adapters/xml/ep2/axsep017nodechar.i  "xLgr"    ttMDFe.xLgr    "YES"}
                    {adapters/xml/ep2/axsep017nodechar.i  "nro"     ttMDFe.nro     "YES"}
                    {adapters/xml/ep2/axsep017nodechar.i  "xCpl"    ttMDFe.xCpl    "NO" }
                    {adapters/xml/ep2/axsep017nodechar.i  "xBairro" ttMDFe.xBairro "YES"}
                    {adapters/xml/ep2/axsep017nodechar.i  "cMun"    ttMDFe.cMun    "YES"}

                    IF ttMDFe.xMun = "Exterior" THEN DO:
                        {adapters/xml/ep2/axsep017nodechar2.i "xMun"    ttMDFe.xMun    "YES"}
                    END.
                    ELSE DO:
                        {adapters/xml/ep2/axsep017nodechar.i  "xMun"    ttMDFe.xMun    "YES"}
                    END.

                    {adapters/xml/ep2/axsep017nodechar.i  "CEP"     ttMDFe.CEP     "NO" }
                    {adapters/xml/ep2/axsep017nodechar.i  "UF"      ttMDFe.UF      "YES"}
                    {adapters/xml/ep2/axsep017nodechar.i  "fone"    ttMDFe.fone    "NO" }
                    {adapters/xml/ep2/axsep017nodechar2.i "email"   ttMDFe.email   "NO" }
                delStack().
            delStack().

            RUN addNode IN hGenXml (getStack(), "infModal", "", OUTPUT iId).
            addStack(iId).

                RUN setAttribute IN hGenXml (INPUT iId, "versaoModal", c-vers-layout).

                CASE ttMdfe.modal:
                    WHEN "1" THEN DO:
                        RUN addNode IN hGenXml (getStack(), "rodo", "", OUTPUT iId).
                        addStack(iId).

                            /*RUN addNode IN hGenXml (getStack(), "RNTRC", ttMDFe.RNTRC, OUTPUT iId).*/
                            /*RUN addNode IN hGenXml (getStack(), "CIOT",  ttMDFe.CIOT, OUTPUT iId).*/

                            IF ttMDFe.cgcProp = "" OR ttMDFe.cgcProp = ? THEN DO:  
                                {adapters/xml/ep2/axsep017nodechar.i  "RNTRC" ttMDFe.RNTRC "YES"}
                            END.

                            RUN addNode IN hGenXml (getStack(), "veicTracao", "", OUTPUT iId).
                            addStack(iId).

                                {adapters/xml/ep2/axsep017nodechar.i  "cInt"    ttMDFe.cInt    "NO" }
                                {adapters/xml/ep2/axsep017nodechar.i  "placa"   ttMDFe.placa   "YES"}

                                {adapters/xml/ep2/axsep017nodechar.i  "tara"    ttMDFe.tara  "YES"}
                                {adapters/xml/ep2/axsep017nodechar.i  "capKG"   ttMDFe.capKG "NO"}
                                {adapters/xml/ep2/axsep017nodechar.i  "capM3"   ttMDFe.capM3 "NO"}
                                
                                /*Valida só o cpf/cnpj pq se for informado, todos os outros campos precisam ser informados*/
                                IF ttMDFe.cgcProp <> "" AND ttMDFe.cgcProp <> ? THEN DO:  
                                    RUN addNode IN hGenXml (getStack(), "prop", "", OUTPUT iId).
                                    addStack(iId).
                                        /*Novas TAGS*/
                                        IF LENGTH(REPLACE(REPLACE(TRIM(ttMDFe.cgcProp), "-", ""), ".", "")) = 11 THEN DO:
                                            {adapters/xml/ep2/axsep017nodechar.i  "CPF" ttMDFe.cgcProp "YES"}
                                        END.
                                        ELSE DO:
                                            {adapters/xml/ep2/axsep017nodechar.i  "CNPJ" ttMDFe.cgcProp "YES"}
                                        END.
                                        
                                        {adapters/xml/ep2/axsep017nodechar.i  "RNTRC" ttMDFe.RNTRC "YES"}
                                        
                                        {adapters/xml/ep2/axsep017nodechar.i  "xNome" ttMDFe.nomeProp "YES"}
                                        {adapters/xml/ep2/axsep017nodechar.i  "IE" ttMDFe.ieProp "YES"}
                                        {adapters/xml/ep2/axsep017nodechar.i  "UF" ttMDFe.ufProp "YES"}
                                        {adapters/xml/ep2/axsep017nodechar.i  "tpProp" ttMDFe.tpProp "YES"}
                                         
                                    delStack().
                                END.
                                
                                FOR EACH ttcondutor OF ttMDFe:
                                    RUN addNode IN hGenXml (getStack(), "condutor", "", OUTPUT iId).
                                    addStack(iId).
                                
                                        {adapters/xml/ep2/axsep017nodechar.i  "xNome" ttcondutor.xNome "YES"}
                                        {adapters/xml/ep2/axsep017nodechar.i  "CPF"   ttcondutor.CPF   "YES"}
                                
                                    delStack().
                                END.
                                /*Novas TAGS*/
                                {adapters/xml/ep2/axsep017nodechar.i  "tpRod"   ttMDFe.tpRod "YES"}
                                {adapters/xml/ep2/axsep017nodechar.i  "tpCar"   ttMDFe.tpCar "YES"}
                                {adapters/xml/ep2/axsep017nodechar.i  "UF"      ttMDFe.ufVeicLicenc "YES"}
                                
                            delStack().

                            FOR EACH ttveicReboque OF ttMDFe:
                                RUN addNode IN hGenXml (getStack(), "veicReboque", "", OUTPUT iId).
                                addStack(iId).
                                
                                    {adapters/xml/ep2/axsep017nodechar.i  "cInt"    ttveicReboque.cInt    "NO" }
                                    {adapters/xml/ep2/axsep017nodechar.i  "placa"   ttveicReboque.placa   "YES"}
                                    
                                    {adapters/xml/ep2/axsep017nodechar.i  "tara"    ttveicReboque.tara    "YES"}
                                    {adapters/xml/ep2/axsep017nodechar.i  "capKG"   ttveicReboque.capKG   "NO"}
                                    {adapters/xml/ep2/axsep017nodechar.i  "capM3"   ttveicReboque.capM3   "NO"}
                                    
                                    /*Valida só o cpf/cnpj pq se for informado, todos os outros campos precisam ser informados*/
                                    IF ttveicReboque.cgcProp <> "" AND ttveicReboque.cgcProp <> ? THEN DO:
                                        RUN addNode IN hGenXml (getStack(), "prop", "", OUTPUT iId).
                                        addStack(iId).
                                            /*Novas TAGS*/
                                            IF LENGTH(REPLACE(REPLACE(TRIM(ttveicReboque.cgcProp), "-", ""), ".", "")) = 11 THEN DO:
                                                {adapters/xml/ep2/axsep017nodechar.i  "CPF" ttveicReboque.cgcProp "YES"}
                                            END.
                                            ELSE DO:
                                                {adapters/xml/ep2/axsep017nodechar.i  "CNPJ" ttveicReboque.cgcProp "YES"}
                                            END.
                                            
                                            {adapters/xml/ep2/axsep017nodechar.i  "RNTRC"  ttveicReboque.RNTRC  "YES"}
                                            
                                            {adapters/xml/ep2/axsep017nodechar.i  "xNome" ttveicReboque.nomeProp "YES"}
                                            {adapters/xml/ep2/axsep017nodechar.i  "IE" ttveicReboque.ieProp "YES"}
                                            {adapters/xml/ep2/axsep017nodechar.i  "UF" ttveicReboque.ufProp "YES"}
                                            {adapters/xml/ep2/axsep017nodechar.i  "tpProp" ttveicReboque.tpProp "YES"}
                                        delStack().
                                    END.
                                    
                                    /*Novas TAGS*/
                                    {adapters/xml/ep2/axsep017nodechar.i  "tpCar"   ttveicReboque.tpCar "YES"}
                                    {adapters/xml/ep2/axsep017nodechar.i  "UF"      ttveicReboque.ufVeicLicenc "YES"}
                                
                                delStack().
                            END.

                            IF CAN-FIND(FIRST ttdisp OF ttMdfe) THEN DO:
                                RUN addNode IN hGenXml (getStack(), "valePed", "", OUTPUT iId).
                                addStack(iId).
                                    FOR EACH ttdisp OF ttMDFe:
                                        RUN addNode IN hGenXml (getStack(), "disp", "", OUTPUT iId).
                                        addStack(iId).
                                            {adapters/xml/ep2/axsep017nodechar.i  "CNPJForn"  ttdisp.CNPJForn  "YES"}
                                           /* {adapters/xml/ep2/axsep017nodechar.i  "CNPJPg"    ttdisp.CNPJPg    "NO"}*/
                                            {adapters/xml/ep2/axsep017nodechar.i  "nCompra"   ttdisp.nCompra   "YES"}
                                             /*RUN addNode IN hGenXml (getStack(), "CNPJForn", ttdisp.CNPJForn, OUTPUT iId).
                                             RUN addNode IN hGenXml (getStack(), "CNPJPg", ttdisp.CNPJPg, OUTPUT iId).
                                             RUN addNode IN hGenXml (getStack(), "nCompra", ttdisp.nCompra, OUTPUT iId).*/
                                        delStack().
                                    END.
                                delStack().
                            END.
                        delStack(). /*fim rodo*/
                    END.
                    WHEN "4" THEN DO:

                        RUN addNode IN hGenXml (getStack(), "ferrov", "", OUTPUT iId).
                        addStack(iId).

                            RUN addNode IN hGenXml (getStack(), "trem", "", OUTPUT iId).
                            addStack(iId).
                                {adapters/xml/ep2/axsep017nodechar.i   "xPref"   ttMDFe.xPref    "YES"}
                                {adapters/xml/ep2/axsep017nodechar.i   "dhTrem"  ttMDFe.dhTrem   "NO"}
                                {adapters/xml/ep2/axsep017nodechar.i   "xOri"    ttMDFe.xOri     "YES"}
                                {adapters/xml/ep2/axsep017nodechar.i   "xDest"   ttMDFe.xDest    "YES"}
                                {adapters/xml/ep2/axsep017nodechar.i   "qVag"    ttMDFe.qVag     "YES"}
                            delStack().
                            
                            FOR EACH ttvag OF ttMDFe:
                                 RUN addNode IN hGenXml (getStack(), "vag", "", OUTPUT iId).
                                addStack(iId).
                                
                                    {adapters/xml/ep2/axsep017nodechar.i   "serie"  ttvag.serie    "YES"}
                                    {adapters/xml/ep2/axsep017nodechar.i   "nVag"   ttvag.nVag     "YES"}
                                    {adapters/xml/ep2/axsep017nodechar.i   "nSeq"   ttvag.nSeq     "NO"}
                                    {adapters/xml/ep2/axsep017nodedec.i    "TU"     ttvag.TU       "YES"  "3"  "YES"}
                                
                                delStack().
                            
                            END.
                        delStack(). /*fim ferrov*/
                    END.
                    WHEN "2" THEN DO:

                        RUN addNode IN hGenXml (getStack(), "aereo", "", OUTPUT iId).
                        addStack(iId).
                            {adapters/xml/ep2/axsep017nodechar.i   "nac"      ttMDFe.nac         "YES"}
                            {adapters/xml/ep2/axsep017nodechar.i   "matr"     ttMDFe.matr        "YES"}
                            {adapters/xml/ep2/axsep017nodechar.i   "nVoo"     ttMDFe.nVoo        "YES"}
                            {adapters/xml/ep2/axsep017nodechar.i   "cAerEmb"  ttMDFe.cAerEmb     "YES"}
                            {adapters/xml/ep2/axsep017nodechar.i   "cAerDes"  ttMDFe.cAerDes     "YES"}
                            {adapters/xml/ep2/axsep017nodedate.i   "dVoo"     ttMDFe.dVoo        "YES"}
                        delStack(). /*fim aereo*/
                    END.
                    WHEN "3" THEN DO:

                        RUN addNode IN hGenXml (getStack(), "aquav", "", OUTPUT iId).
                        addStack(iId).

                            {adapters/xml/ep2/axsep017nodechar.i   "CNPJAgeNav"  ttMDFe.CNPJAgeNav  "YES"}
                            {adapters/xml/ep2/axsep017nodechar.i   "tpEmb"       ttMDFe.tpEmb       "YES"}
                            {adapters/xml/ep2/axsep017nodechar.i   "cEmbar"      ttMDFe.cEmbar      "YES"}
                            {adapters/xml/ep2/axsep017nodechar.i   "xEmbar"      ttMDFe.xEmbar      "YES"}
                            {adapters/xml/ep2/axsep017nodechar.i   "nViag"       ttMDFe.nViag       "YES"}
                            {adapters/xml/ep2/axsep017nodechar.i   "cPrtEmb"     ttMDFe.cPrtEmb     "YES"}
                            {adapters/xml/ep2/axsep017nodechar.i   "cPrtDest"    ttMDFe.cPrtDest    "YES"}
                            FOR EACH ttinfTermCarreg OF ttMDFe:
                                RUN addNode IN hGenXml (getStack(), "infTermCarreg", "", OUTPUT iId).
                                addStack(iId).
                                    {adapters/xml/ep2/axsep017nodechar.i   "cTermCarreg"  ttinfTermCarreg.cTermCarreg   "YES"}
                                    {adapters/xml/ep2/axsep017nodechar.i   "xTermCarreg"  ttinfTermCarreg.cTermCarreg   "YES"}
                                delStack().
                            END.
                            FOR EACH ttinfTermDescarreg OF ttMDFe:
                                RUN addNode IN hGenXml (getStack(), "infTermDescarreg", "", OUTPUT iId).
                                addStack(iId).
                                    {adapters/xml/ep2/axsep017nodechar.i   "cTermDescarreg"  ttinfTermDescarreg.cTermDescarreg   "YES"}
                                    {adapters/xml/ep2/axsep017nodechar.i   "xTermDescarreg"  ttinfTermDescarreg.cTermDescarreg   "YES"}
                                delStack().
                            END.
                            FOR EACH ttinfEmbComb OF ttMDFe:
                                RUN addNode IN hGenXml (getStack(), "infEmbComb", "", OUTPUT iId).
                                addStack(iId).
                                    {adapters/xml/ep2/axsep017nodechar.i   "cEmbComb"   ttinfEmbComb.cEmbComb   "YES"}
                                delStack().
                            END.
                        delStack(). /*fim aquav*/
                    END.
                END CASE.
            delStack().

            RUN addNode IN hGenXml (getStack(), "infDoc", "", OUTPUT iId).
            addStack(iId).

                FOR EACH ttinfMunDescarga OF ttMDFe:
                    RUN addNode IN hGenXml (getStack(), "infMunDescarga", "", OUTPUT iId).
                    addStack(iId).
                        RUN addNode IN hGenXml (getStack(), "cMunDescarga", ttinfMunDescarga.cMunDescarga, OUTPUT iId).
                        IF ttinfMunDescarga.xMunDescarga = "Exterior" THEN DO:
                            {adapters/xml/ep2/axsep017nodechar2.i "xMunDescarga"    ttinfMunDescarga.xMunDescarga    "YES"}
                        END.
                        ELSE DO:
                            {adapters/xml/ep2/axsep017nodechar.i  "xMunDescarga"    ttinfMunDescarga.xMunDescarga    "YES"}
                        END.

                        /*CT-e*/
                        FOR EACH ttinfCTe OF ttinfMunDescarga:
                            RUN addNode IN hGenXml (getStack(), "infCTe", "", OUTPUT iId).
                            addStack(iId).
                                {adapters/xml/ep2/axsep017nodechar2.i   "chCTe"        ttinfCTe.chCTe       "YES"}
                                {adapters/xml/ep2/axsep017nodechar2.i   "SegCodBarra"  ttinfCTe.SegCodBarra "NO"}
                                FOR EACH ttinfUnidTransp OF ttinfCTe:
                                    RUN addNode IN hGenXml (getStack(), "infUnidTransp", "", OUTPUT iId).
                                    addStack(iId).
                                    
                                        {adapters/xml/ep2/axsep017nodechar.i   "tpUnidTransp"  ttinfUnidTransp.tpUnidTransp "YES"}
                                        {adapters/xml/ep2/axsep017nodechar.i   "idUnidTransp"  ttinfUnidTransp.idUnidTransp "YES"}
                                        FOR EACH ttlacUnidTransp OF ttinfUnidTransp:
                                            RUN addNode IN hGenXml (getStack(), "lacUnidTransp", "", OUTPUT iId).
                                            addStack(iId).
                                            
                                                {adapters/xml/ep2/axsep017nodechar.i   "nLacre"  ttlacUnidTransp.nLacre  "YES"}
                                            delStack().
                                        END.
                                        FOR EACH ttinfUnidCarga OF ttinfUnidTransp:
                                            RUN addNode IN hGenXml (getStack(), "infUnidCarga", "", OUTPUT iId).
                                            addStack(iId).
                                                {adapters/xml/ep2/axsep017nodechar.i   "tpUnidCarga"  ttinfUnidCarga.tpUnidCarga "YES"}
                                                {adapters/xml/ep2/axsep017nodechar.i   "idUnidCarga"  ttinfUnidCarga.idUnidCarga "YES"}
                                            
                                                FOR EACH ttlacUnidCarga OF ttinfUnidCarga:
                                                    RUN addNode IN hGenXml (getStack(), "lacUnidCarga", "", OUTPUT iId).
                                                    addStack(iId).
                                                        {adapters/xml/ep2/axsep017nodechar.i   "nLacre"  ttlacUnidCarga.nLacre  "YES"}
                                                    delStack().
                                                END.
                                                {adapters/xml/ep2/axsep017nodedec.i   "qtdRat"   ttinfUnidCarga.qtdRat   "NO"  "2"  "YES"}
                                            delStack().
                                        END.
                                        {adapters/xml/ep2/axsep017nodedec.i   "qtdRat"   ttinfUnidTransp.qtdRat   "NO"  "2"  "YES"}
                                    delStack().
                                END.
                            delStack().
                        
                        END.
                    
                        /*CT*/
                        FOR EACH ttinfCT OF ttinfMunDescarga:
                            RUN addNode IN hGenXml (getStack(), "infCT", "", OUTPUT iId).
                            addStack(iId).
                    
                                {adapters/xml/ep2/axsep017nodechar.i "nCT"      ttinfCT.nCT       "YES"}
                                {adapters/xml/ep2/axsep017nodechar.i "serie"    ttinfCT.serie     "YES"}
                                {adapters/xml/ep2/axsep017nodechar.i "subser"   ttinfCT.subser    "NO"}
                                {adapters/xml/ep2/axsep017nodedate.i "dEmi"     ttinfCT.dEmi      "YES"}
                                {adapters/xml/ep2/axsep017nodedec.i  "vCarga"   ttinfCT.vCarga    "YES"  "2"  "YES"}
                    
                                FOR EACH ttinfUnidTransp_00 OF ttinfCT:
                                    RUN addNode IN hGenXml (getStack(), "infUnidTransp", "", OUTPUT iId).
                                    addStack(iId).
                                        {adapters/xml/ep2/axsep017nodechar.i   "tpUnidTransp"  ttinfUnidTransp_00.tpUnidTransp "YES"}
                                        {adapters/xml/ep2/axsep017nodechar.i   "idUnidTransp"  ttinfUnidTransp_00.idUnidTransp "YES"}
                                        FOR EACH ttlacUnidTransp_00 OF ttinfUnidTransp_00:
                                            RUN addNode IN hGenXml (getStack(), "lacUnidTransp", "", OUTPUT iId).
                                            addStack(iId).
                                                {adapters/xml/ep2/axsep017nodechar.i   "nLacre"  ttlacUnidTransp_00.nLacre   "YES"}
                                            delStack().
                                        END.
                                        FOR EACH ttinfUnidCarga_00 OF ttinfUnidTransp_00:
                                            RUN addNode IN hGenXml (getStack(), "infUnidCarga", "", OUTPUT iId).
                                            addStack(iId).
                    
                                                {adapters/xml/ep2/axsep017nodechar.i   "tpUnidCarga"   ttinfUnidCarga_00.tpUnidCarga  "YES"}
                                                {adapters/xml/ep2/axsep017nodechar.i   "idUnidCarga"   ttinfUnidCarga_00.idUnidCarga  "YES"}
                                                FOR EACH ttlacUnidCarga_00 OF ttinfUnidCarga_00:
                                                    RUN addNode IN hGenXml (getStack(), "lacUnidCarga", "", OUTPUT iId).
                                                    addStack(iId).
                                                        {adapters/xml/ep2/axsep017nodechar.i   "nLacre"  ttlacUnidCarga_00.nLacre  "YES"}
                                                    delStack().
                                                END.
                                                {adapters/xml/ep2/axsep017nodedec.i   "qtdRat"   ttinfUnidCarga_00.qtdRat   "NO"  "2"  "YES"}
                                            delStack().
                                        END.
                                        {adapters/xml/ep2/axsep017nodedec.i   "qtdRat"   ttinfUnidTransp_00.qtdRat   "NO"  "2"  "YES"}
                                    delStack().
                                END.
                            delStack().
                        END.
                    
                        /*NF-e*/
                        FOR EACH ttinfNFe OF ttinfMunDescarga:
                            RUN addNode IN hGenXml (getStack(), "infNFe", "", OUTPUT iId).
                            addStack(iId).
                                {adapters/xml/ep2/axsep017nodechar2.i "chNFe"          ttinfNFe.chNFe          "YES"}
                                {adapters/xml/ep2/axsep017nodechar2.i "SegCodBarra"    ttinfNFe.SegCodBarra    "NO"}
                                
                                FOR EACH ttinfUnidTransp_01 OF ttinfNFe:
                                    RUN addNode IN hGenXml (getStack(), "infUnidTransp", "", OUTPUT iId).
                                    addStack(iId).
                                        {adapters/xml/ep2/axsep017nodechar.i   "tpUnidTransp"  ttinfUnidTransp_01.tpUnidTransp   "YES"}
                                        {adapters/xml/ep2/axsep017nodechar.i   "idUnidTransp"  ttinfUnidTransp_01.idUnidTransp   "YES"}
                                        FOR EACH ttlacUnidTransp_01 OF ttinfUnidTransp_01:
                                            RUN addNode IN hGenXml (getStack(), "lacUnidTransp", "", OUTPUT iId).
                                            addStack(iId).
                                                {adapters/xml/ep2/axsep017nodechar.i   "nLacre"  ttlacUnidTransp_01.nLacre  "YES"}
                                            delStack().
                                        END.
                                        FOR EACH ttinfUnidCarga_01 OF ttinfUnidTransp_01:
                                            RUN addNode IN hGenXml (getStack(), "infUnidCarga", "", OUTPUT iId).
                                            addStack(iId).
                                                {adapters/xml/ep2/axsep017nodechar.i   "tpUnidCarga"  ttinfUnidCarga_01.tpUnidCarga   "YES"}
                                                {adapters/xml/ep2/axsep017nodechar.i   "idUnidCarga"  ttinfUnidCarga_01.idUnidCarga   "YES"}
                                                FOR EACH ttlacUnidCarga_01 OF ttinfUnidCarga_01:
                                                    RUN addNode IN hGenXml (getStack(), "lacUnidCarga", "", OUTPUT iId).
                                                    addStack(iId).
                                                        {adapters/xml/ep2/axsep017nodechar.i   "nLacre"  ttlacUnidCarga_01.nLacre  "YES"}
                                                    delStack().
                                                END.
                                                {adapters/xml/ep2/axsep017nodedec.i   "qtdRat"   ttinfUnidCarga_01.qtdRat   "NO"  "2"  "YES"}
                                            delStack().
                                        END.
                                        {adapters/xml/ep2/axsep017nodedec.i   "qtdRat"   ttinfUnidTransp_01.qtdRat   "NO"  "2"  "YES"}
                                    delStack().
                                END.
                            delStack().
                        END.
                    
                        /*NF*/
                        FOR EACH ttinfNF OF ttinfMunDescarga:
                            RUN addNode IN hGenXml (getStack(), "infNF", "", OUTPUT iId).
                            addStack(iId).
                            
                                {adapters/xml/ep2/axsep017nodechar.i "CNPJ"  ttinfNF.CNPJ   "YES"}
                                {adapters/xml/ep2/axsep017nodechar.i "UF"    ttinfNF.UF     "YES"}
                                {adapters/xml/ep2/axsep017nodechar.i "nNF"   ttinfNF.nNF    "YES"}
                                {adapters/xml/ep2/axsep017nodechar.i "serie" ttinfNF.serie  "YES"}
                                {adapters/xml/ep2/axsep017nodedate.i "dEmi"  ttinfNF.dEmi   "YES"}
                                {adapters/xml/ep2/axsep017nodedec.i  "vNF"   ttinfNF.vNF    "YES" "2" "YES"}
                                {adapters/xml/ep2/axsep017nodechar.i "PIN"   ttinfNF.PIN    "NO"}
                                
                                FOR EACH ttinfUnidTransp_02 OF ttinfNF:
                                    RUN addNode IN hGenXml (getStack(), "infUnidTransp", "", OUTPUT iId).
                                    addStack(iId).
                                    
                                        {adapters/xml/ep2/axsep017nodechar.i "tpUnidTransp"  ttinfUnidTransp_02.tpUnidTransp     "YES"}
                                        {adapters/xml/ep2/axsep017nodechar.i "idUnidTransp"  ttinfUnidTransp_02.idUnidTransp     "YES"}
                                        FOR EACH ttlacUnidTransp_02 OF ttinfUnidTransp_02:
                                            RUN addNode IN hGenXml (getStack(), "lacUnidTransp", "", OUTPUT iId).
                                            addStack(iId).
                                                {adapters/xml/ep2/axsep017nodechar.i "nLacre"  ttlacUnidTransp_02.nLacre  "YES"}
                                            delStack().
                                        END.
                                        FOR EACH ttinfUnidCarga_02 OF ttinfUnidTransp_02:
                                            RUN addNode IN hGenXml (getStack(), "infUnidCarga", "", OUTPUT iId).
                                            addStack(iId).
                                                {adapters/xml/ep2/axsep017nodechar.i  "tpUnidCarga"  ttinfUnidCarga_02.tpUnidCarga   "YES"}
                                                {adapters/xml/ep2/axsep017nodechar.i  "idUnidCarga"  ttinfUnidCarga_02.idUnidCarga   "YES"}
                                                FOR EACH ttlacUnidCarga_02 OF ttinfUnidCarga_02:
                                                    RUN addNode IN hGenXml (getStack(), "lacUnidCarga", "", OUTPUT iId).
                                                    addStack(iId).
                                                        {adapters/xml/ep2/axsep017nodechar.i "nLacre"  ttlacUnidCarga_02.nLacre "YES"}
                                                    delStack().
                                                END.
                                                {adapters/xml/ep2/axsep017nodedec.i   "qtdRat"   ttinfUnidCarga_02.qtdRat   "NO"  "2"  "YES"}
                                            delStack().
                                        END.
                                        {adapters/xml/ep2/axsep017nodedec.i   "qtdRat"   ttinfUnidTransp_02.qtdRat   "NO"  "2"  "YES"}
                                    delStack().
                                END.
                            delStack().
                        END.
                    delStack().
                END.
            delStack().

            /*tot*/
            RUN addNode IN hGenXml (getStack(), "tot", "", OUTPUT iId).
            addStack(iId).
                IF int(ttMDFe.qCTe) > 0 THEN {adapters/xml/ep2/axsep017nodechar.i  "qCTe"  ttMDFe.qCTe  "NO"}
                IF int(ttMDFe.qCT)  > 0 THEN {adapters/xml/ep2/axsep017nodechar.i  "qCT"   ttMDFe.qCT   "NO"}
                IF int(ttMDFe.qNFe) > 0 THEN {adapters/xml/ep2/axsep017nodechar.i  "qNFe"  ttMDFe.qNFe  "NO"}
                IF int(ttMDFe.qNF)  > 0 THEN {adapters/xml/ep2/axsep017nodechar.i  "qNF"   ttMDFe.qNF   "NO"}

                {adapters/xml/ep2/axsep017nodedec.i   "vCarga"  ttMDFe.vCarga "YES" 2 "YES"}
                {adapters/xml/ep2/axsep017nodechar.i  "cUnid"   ttMDFe.cUnid  "YES"}
                {adapters/xml/ep2/axsep017nodedec.i   "qCarga"  ttMDFe.qCarga "YES" 4 "YES"}
            delStack().

            FOR EACH ttlacres OF ttMDFe:
                 RUN addNode IN hGenXml (getStack(), "lacres", "", OUTPUT iId).
                 addStack(iId).
                      {adapters/xml/ep2/axsep017nodechar.i  "nLacre"  ttlacres.nLacre  "YES"}
                 delStack().
            END.
            
            /*Novas TAGS*/
            IF CAN-FIND(FIRST ttCGCAutoriza) THEN DO:
                FOR EACH ttCGCAutoriza OF ttMDFE:
                    RUN addNode IN hGenXml (getStack(), "autXML", "", OUTPUT iId).
                    addStack(iId).
                        IF LENGTH(REPLACE(REPLACE(TRIM(ttCGCAutoriza.cgcAutoriza), "-", ""), ".", "")) = 11 THEN DO:
                            {adapters/xml/ep2/axsep017nodechar.i "CPF"  ttCGCAutoriza.cgcAutoriza "YES"}
                        END.
                        ELSE DO:
                            {adapters/xml/ep2/axsep017nodechar.i "CNPJ" ttCGCAutoriza.cgcAutoriza "YES"}
                        END.
                    delStack().
                END.
            END.
            
            RUN addNode IN hGenXml (getStack(), "infAdic", "", OUTPUT iId).
            addStack(iId).
                {adapters/xml/ep2/axsep017nodechar2.i "infAdFisco"  ttMDFe.infAdFisco "NO"}
                {adapters/xml/ep2/axsep017nodechar2.i "infCpl"      ttMDFe.infCpl     "NO"}
            delStack().

        delStack().
    delStack().
END.

