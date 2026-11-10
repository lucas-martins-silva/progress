/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSEP023 2.00.00.014 } /*** "010014" 31/08/2026 15:54:05 ***/

{include/i-license-manager.i axsep023 MUT}

{cdp/cdcfgdis.i}

/*-------------------------------------------------
                  axsep023.p
                  
           PROGRAMA DE GERAÄ«O DA NFS-e TPF
-------------------------------------------------*/

{dibo/bodi135nfse.i9} /* Definiá∆o das Tabelas de NFSE - TFS */
{adapters/xml/ep2/axsep022extradeclarations.i} /* Outras Definiá‰es Tabelas / tt_log_erro */

DEFINE VARIABLE hXMLNFSe     AS HANDLE      NO-UNDO.
DEFINE VARIABLE hGenXml      AS HANDLE      NO-UNDO.
DEFINE VARIABLE cReturnValue AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iId          AS INTEGER     NO-UNDO.
DEFINE VARIABLE cValue       AS CHARACTER   NO-UNDO.

/* VERIFICA SE APIXML ESTA NA MEMORIA */
{xmlinc/xmlloadgenxml.i &GenXml="hGenXml" &GXReturnValue="cReturnValue"}

IF cReturnValue <> "OK":U
THEN DO:
     CREATE TT_LOG_ERRO.
          ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 0.
          ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO = "Erro ao carregar a API XML: "+ cReturnValue.
     RETURN cReturnValue.
END.

PROCEDURE PIGeraXMLNFSe:

    DEFINE INPUT  PARAM p-tp-integ AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR tt-layout.
    DEFINE INPUT  PARAM TABLE FOR tt-layout-inf.
    DEFINE INPUT  PARAM TABLE FOR tt-layout-subst.
    DEFINE INPUT  PARAM TABLE FOR tt-layout-cancelamento.
    DEFINE INPUT  PARAM TABLE FOR tt-layout-atividade.
    DEFINE INPUT  PARAM TABLE FOR tt-layout-prest.
    DEFINE INPUT  PARAM TABLE FOR tt-layout-locPrest.
    DEFINE INPUT  PARAM TABLE FOR tt-layout-toma.
    DEFINE INPUT  PARAM TABLE FOR tt-layout-cserv.
    DEFINE INPUT  PARAM TABLE FOR tt-layout-refnfse.
    DEFINE INPUT  PARAM TABLE FOR tt-layout-piscofins.
    DEFINE INPUT  PARAM TABLE FOR tt-layout-IBSCBS.
    DEFINE INPUT  PARAM TABLE FOR tt-layout-IBSCBS-dest.
    DEFINE INPUT  PARAM TABLE FOR tt-layout-valores.
    DEFINE INPUT  PARAM TABLE FOR tt-layout-fatura.
    DEFINE INPUT  PARAM TABLE FOR tt-layout-pagamento.
    DEFINE INPUT  PARAM TABLE FOR tt-layout-deducoes.
    DEFINE INPUT  PARAM TABLE FOR tt-layout-deducao.
    DEFINE INPUT  PARAM TABLE FOR tt-layout-infocompl.
    DEFINE INPUT  PARAM TABLE FOR tt-layout-imovel.

    DEFINE OUTPUT PARAM plcXMLNFSe AS LONGCHAR NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.

    CREATE X-DOCUMENT hXMLNFSe.
    
    /* RESETA OS VALORES */
    RUN reset IN hGenXml.

    /* SETA VALOR DE ENCODING */
    RUN setEncoding IN hGenXml ("UTF-8").

    /* LAYOUT DE CANCELAMENTO NO TPF INTEGRA APENAS COM OS CAMPOS DE CANCELAMENTO. PARA O TSS ê INTEGRADO O LAYOUT INTEIRO */
    IF  LOOKUP(p-tp-integ, "TPF":U) > 0
    AND CAN-FIND (FIRST tt-layout-cancelamento) THEN DO:

        FOR EACH tt-layout-inf NO-LOCK:
    
             RUN addNode      IN hGenXml (getStack(), "rps", "", OUTPUT iId).
             /*RUN setAttribute IN hGenXml (INPUT iId, "id",     (tt-rps.Id#)).*/
    
             addStack(iId).

             RUN pi-cancelamento.

             delStack().
        END.
        
    END.
    ELSE DO:
        FOR FIRST tt-layout NO-LOCK:
             RUN addNode      IN hGenXml (getStack(), "rps", "", OUTPUT iId).
             RUN setAttribute IN hGenXml (INPUT iId, "id",     (tt-layout.Id#)).
    
             addStack(iId).
    
                  RUN addNode IN hGenXml (getStack(), "assinatura", tt-layout.assinatura, OUTPUT iId).
    
                    FOR EACH tt-layout-inf NO-LOCK:
            
                        RUN addNode IN hGenXml (getStack(), "identificacao", "", OUTPUT iId).
                        addStack(iId).
              
                            RUN addNode IN hGenXml (getStack(), "dthremissao",          tt-layout-inf.dhemi,         OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "serierps",             tt-layout-inf.serie,         OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "numerorps",            tt-layout-inf.numerorps,     OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tipo",                 tt-layout-inf.tipo,          OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "situacaorps",          tt-layout-inf.situacaorps,   OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tiporecolhe",          tt-layout-inf.tiporecolhe,   OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tipotrib",             tt-layout-inf.tipotrib,      OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "regimeesptrib",        tt-layout-inf.regimeesptrib, OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "formpagto",            tt-layout-inf.formpagto,     OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "natop",                tt-layout-inf.natop,         OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "dtcompetencia",        tt-layout-inf.dhemi,         OUTPUT iId).
                            
                            FOR FIRST tt-layout-cserv NO-LOCK:
                                RUN addNode IN hGenXml (getStack(), "issret",         tt-layout-cserv.issretido,  OUTPUT iId).
                                RUN addNode IN hGenXml (getStack(), "itemlistaserv",  tt-layout-cserv.cTribNac,   OUTPUT iId).
                                RUN addNode IN hGenXml (getStack(), "ctributmun",     tt-layout-cserv.cTribMun,   OUTPUT iId).
                            END.
                              
                            RUN addNode IN hGenXml (getStack(), "cexiss",                tt-layout-inf.cexiss,                 OUTPUT iId).
                            // cresponsavelretencao comentado porque como a nota n∆o tem intermedi†rio, essa tag n∆o pode ir no XML - Verificar com Silvia
                            //RUN addNode IN hGenXml (getStack(), "cresponsavelretencao",  tt-layout-inf.cresponsavelretencao,   OUTPUT iId). 
                            RUN addNode IN hGenXml (getStack(), "localPrestacaoServico", tt-layout-inf.localServ,              OUTPUT iId).
                            //RUN addNode IN hGenXml (getStack(), "tipoBeneficio",         tt-layout-inf.tipoBeneficio,          OUTPUT iId). 
                            
                            FOR FIRST tt-layout-valores NO-LOCK:
                                IF  tt-layout-valores.nBM <> ""
                                AND tt-layout-valores.nBM <> ? THEN
                                    RUN addNode IN hGenXml (getStack(), "numeroBeneficio", tt-layout-valores.nBM, OUTPUT iId).                            
                            END.
                            
                            IF tt-layout-inf.regimeTribSN <> ? THEN                            
                               RUN addNode IN hGenXml (getStack(), "regimeTribSN",          tt-layout-inf.regimeTribSN, OUTPUT iId).
                               
                            RUN addNode IN hGenXml (getStack(), "tipoImunidade",         tt-layout-inf.tipoImunidade, OUTPUT iId).
                            
                            IF tt-layout-inf.tipoSuspensao <> "" AND tt-layout-inf.tipoSuspensao <> ? THEN
                                RUN addNode IN hGenXml (getStack(), "tipoSuspensao",         tt-layout-inf.tipoSuspensao, OUTPUT iId). //Tipo Suspens„o
                               
                            RUN addNode IN hGenXml (getStack(), "finalidadeNfse",        tt-layout-inf.finalidadeNfse,         OUTPUT iId).
                            IF  tt-layout-inf.indicadorFinal <> "" AND tt-layout-inf.indicadorFinal <> ? THEN
                                RUN addNode IN hGenXml (getStack(), "indicadorFinal",        tt-layout-inf.indicadorFinal,         OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cIndicadorOperacao",    tt-layout-inf.cIndicadorOperacao,     OUTPUT iId).
                            
                            IF tt-layout-inf.tipoEnteGovernamental <> "" AND tt-layout-inf.tipoEnteGovernamental <> ? THEN
                                RUN addNode IN hGenXml (getStack(), "tipoEnteGovernamental", tt-layout-inf.tipoEnteGovernamental, OUTPUT iId).
                                
                            RUN addNode IN hGenXml (getStack(), "indicadorDestinatario", tt-layout-inf.indicadorDestinatario, OUTPUT iId).
                
                        delStack().
            
                    END.
    
                    FOR FIRST tt-layout-subst NO-LOCK:

                        RUN addNode IN hGenXml (getStack(), "substituicao", "", OUTPUT iId).
                        addStack(iId).
                    
                            RUN addNode IN hGenXml (getStack(), "serierps",        tt-layout-subst.serierps,        OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "numerorps",       tt-layout-subst.numerorps,       OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "numeronfse",      tt-layout-subst.numeronfse,      OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "idnfse",          tt-layout-subst.idnfse,          OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tipo",            tt-layout-subst.tipo,            OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "dtemissaonfse",   tt-layout-subst.dtemissaonfse,   OUTPUT iId).
                            IF  tt-layout-subst.chSubstda <> "" AND tt-layout-subst.chSubstda <> ? THEN
                                RUN addNode IN hGenXml (getStack(), "chave",           tt-layout-subst.chSubstda,       OUTPUT iId).
                            IF  tt-layout-subst.cMotivo <> "" AND tt-layout-subst.cMotivo <> ? THEN    
                                RUN addNode IN hGenXml (getStack(), "codigoMotivo",    tt-layout-subst.cMotivo,         OUTPUT iId).
                            IF  tt-layout-subst.xMotivo <> "" AND tt-layout-subst.xMotivo <> ? THEN
                                RUN addNode IN hGenXml (getStack(), "descricaoMotivo", tt-layout-subst.xMotivo,         OUTPUT iId).
                    
                        delStack().
                  END.
                  
                  FOR FIRST tt-layout-atividade NO-LOCK:
    
                       RUN addNode IN hGenXml (getStack(), "atividade", "", OUTPUT iId).
                       addStack(iId).
    
                            RUN addNode IN hGenXml (getStack(), "codigo",  tt-layout-atividade.codigo,  OUTPUT iId).
    
                       delStack().
    
                  END.
    
                  FOR FIRST tt-layout-prest NO-LOCK:

                      RUN addNode IN hGenXml (getStack(), "prestador", "", OUTPUT iId).
                      addStack(iId).
                  
                          RUN addNode IN hGenXml (getStack(), "inscmun",     tt-layout-prest.IM,          OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "cpfcnpj",     tt-layout-prest.CNPJ,        OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "razao",       tt-layout-prest.razao,       OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "fantasia",    tt-layout-prest.fantasia,    OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "codmunibge",  tt-layout-prest.cMun,        OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "cidade",      tt-layout-prest.cidade,      OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "uf",          tt-layout-prest.uf,          OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "ddd",         tt-layout-prest.ddd,         OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "telefone",    tt-layout-prest.fone,        OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "simpnac",     tt-layout-prest.opSimpnac,   OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "incentcult",  tt-layout-prest.incentcult,  OUTPUT iId).                          
                            
                          FOR FIRST tt-layout-inf NO-LOCK:
                              IF tt-layout-inf.tipoSuspensao <> "" AND tt-layout-inf.tipoSuspensao <> ? THEN
                                  RUN addNode IN hGenXml (getStack(), "numproc",     tt-layout-prest.numproc,     OUTPUT iId). //N˙mero do Processo        
                          END.
                                                                                                   
                          RUN addNode IN hGenXml (getStack(), "logradouro",  tt-layout-prest.xLgr,        OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "numend",      tt-layout-prest.nro,         OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "bairro",      tt-layout-prest.xbairro,     OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "cep",         tt-layout-prest.cep,         OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "cie",         tt-layout-prest.IM,          OUTPUT iId).
                          
                          IF tt-layout-prest.email <> "" AND tt-layout-prest.email <> ? THEN
                              RUN addNode IN hGenXml (getStack(), "email",       tt-layout-prest.email,       OUTPUT iId).

                      delStack().
                  END.
    
                  FOR FIRST tt-layout-locPrest NO-LOCK:

                      RUN addNode IN hGenXml (getStack(), "prestacao", "", OUTPUT iId).
                      addStack(iId).
                  
                          RUN addNode IN hGenXml (getStack(), "logradouro",             tt-layout-locPrest.logradouro,             OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "numend",                 tt-layout-locPrest.numend,                 OUTPUT iId).
                          
                          IF tt-layout-locPrest.complend <> "" AND tt-layout-locPrest.complend <> ? THEN
                              RUN addNode IN hGenXml (getStack(), "complend",               tt-layout-locPrest.complend,               OUTPUT iId).
                              
                          RUN addNode IN hGenXml (getStack(), "codmunibge",             tt-layout-locPrest.codmunibge,             OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "codmunincidenciaibge",   tt-layout-locPrest.codmunibgeinc,          OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "municipio",              tt-layout-locPrest.municipio,              OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "bairro",                 tt-layout-locPrest.bairro,                 OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "uf",                     tt-layout-locPrest.uf,                     OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "cep",                    tt-layout-locPrest.cep,                    OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "pais",                   tt-layout-locPrest.codpais,                OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "tipoLogradouro",         tt-layout-locPrest.tipologr,               OUTPUT iId).
                  
                      delStack().
                  END.
    
                  FOR FIRST tt-layout-toma NO-LOCK:

                      RUN addNode IN hGenXml (getStack(), "tomador", "", OUTPUT iId).
                      addStack(iId).
                
                          RUN addNode IN hGenXml (getStack(), "inscmun",             tt-layout-toma.IM,                  OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "cpfcnpj",             tt-layout-toma.CNPJ,                OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "razao",               tt-layout-toma.xNome,               OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "tipologr",            tt-layout-toma.tipologr,            OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "logradouro",          tt-layout-toma.xLgr,                OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "numend",              tt-layout-toma.nro,                 OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "complend",            tt-layout-toma.xcpl,                OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "bairro",              tt-layout-toma.xbairro,             OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "codmunibge",          tt-layout-toma.cmun,                OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "cidade",              tt-layout-toma.cidade,              OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "uf",                  tt-layout-toma.uf,                  OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "cep",                 tt-layout-toma.cep,                 OUTPUT iId).
                          
                          IF tt-layout-toma.email <> "" AND tt-layout-toma.email <> ? THEN
                              RUN addNode IN hGenXml (getStack(), "email",               tt-layout-toma.email,               OUTPUT iId).
                              
                          RUN addNode IN hGenXml (getStack(), "telefone",            tt-layout-toma.fone,                OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "codpais",             tt-layout-toma.codpais,             OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "nomepais",            tt-layout-toma.nomepais,            OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "estrangeiro",         tt-layout-toma.estrangeiro,         OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "notificatomador",     tt-layout-toma.notificatomador,     OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "csituacaoesptom",     tt-layout-toma.csituacaoesptom,     OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "ctomnaoidentificado", tt-layout-toma.ctomnaoidentificado, OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "inscricaoEstadual",   tt-layout-toma.inscest,             OUTPUT iId).
                
                      delStack().
                  END.
    
                  RUN addNode IN hGenXml (getStack(), "servicos", "", OUTPUT iId).
                  addStack(iId).
    
                       FOR EACH tt-layout-cserv NO-LOCK:
    
                            RUN addNode IN hGenXml (getStack(), "servico", "", OUTPUT iId). 
                            addStack(iId).
    
                                RUN addNode IN hGenXml (getStack(), "codigo",       tt-layout-cserv.cTribNac,   OUTPUT iId).
                                {adapters/xml/ep2/axsep022nodedec.i "aliquota"        tt-layout-cserv.aliquota  "YES" "4" "YES"}
                                RUN addNode IN hGenXml (getStack(), "cnae",         tt-layout-cserv.cnae,       OUTPUT iId).
                                RUN addNode IN hGenXml (getStack(), "codtrib",      tt-layout-cserv.cTribMun,   OUTPUT iId).
                                RUN addNode IN hGenXml (getStack(), "discr",        tt-layout-cserv.discr,      OUTPUT iId).
        
                                IF tt-layout-cserv.quant = INT(tt-layout-cserv.quant) THEN /* INTEIRO - PARA EVITAR VALORES COMO  1.00 */
                                    RUN addNode IN hGenXml (getStack(), "quant", string(tt-layout-cserv.quant),     OUTPUT iId).
                                ELSE /* DECIMAL */
                                    {adapters/xml/ep2/axsep022nodedec.i "quant"   tt-layout-cserv.quant       "YES" "2" "NO"}
        
                                {adapters/xml/ep2/axsep022nodedec.i "valunit"       tt-layout-cserv.valunit     "YES" "2" "NO"}
                                {adapters/xml/ep2/axsep022nodedec.i "valtotal"      tt-layout-cserv.valtotal    "YES" "2" "NO"}
                                {adapters/xml/ep2/axsep022nodedec.i "basecalc"      tt-layout-cserv.basecalc    "YES" "2" "NO"}
                                RUN addNode IN hGenXml (getStack(), "issretido",    tt-layout-cserv.issretido,  OUTPUT iId).
                                {adapters/xml/ep2/axsep022nodedec.i "valdedu"       tt-layout-cserv.valdedu     "YES" "2" "NO"}
                                {adapters/xml/ep2/axsep022nodedec.i "valpis"        tt-layout-cserv.valpis      "YES" "2" "NO"}
                                {adapters/xml/ep2/axsep022nodedec.i "valcof"        tt-layout-cserv.valcof      "YES" "2" "NO"}
                                {adapters/xml/ep2/axsep022nodedec.i "valinss"       tt-layout-cserv.valinss     "YES" "2" "NO"}
                                {adapters/xml/ep2/axsep022nodedec.i "valir"         tt-layout-cserv.valir       "YES" "2" "NO"}
                                {adapters/xml/ep2/axsep022nodedec.i "valcsll"       tt-layout-cserv.valcsll     "YES" "2" "NO"}
                                {adapters/xml/ep2/axsep022nodedec.i "valiss"        tt-layout-cserv.valiss      "YES" "2" "NO"}

                                FIND FIRST tt-layout-piscofins NO-LOCK NO-ERROR.
                                IF AVAIL tt-layout-piscofins THEN DO:
                                    {adapters/xml/ep2/axsep022nodedec.i "alPIS"               tt-layout-piscofins.pAliqpis            "NO" "2" "NO"}
                                    {adapters/xml/ep2/axsep022nodedec.i "alCOFINS"            tt-layout-piscofins.pAliqcofins         "NO" "2" "NO"}
                                    RUN addNode IN hGenXml (getStack(), "situacaoTributaria", tt-layout-piscofins.CST,                OUTPUT iId).
                                    RUN addNode IN hGenXml (getStack(), "itemCSTPisCofins",   tt-layout-piscofins.CST,                OUTPUT iId).
                                    RUN addNode IN hGenXml (getStack(), "itemTpRetPisCofins", tt-layout-piscofins.itemTpRetPisCofins, OUTPUT iId).  //ADICIONADO
                                END.
                                RUN addNode IN hGenXml (getStack(),    "itemNBS",               tt-layout-cserv.cNBS,                OUTPUT iId).
                                RUN addNode IN hGenXml (getStack(),    "codigoNbs",             tt-layout-cserv.cNBS,                OUTPUT iId).

                                FIND FIRST tt-layout-valores NO-LOCK NO-ERROR.
                                IF AVAIL tt-layout-valores THEN DO:
                                    {adapters/xml/ep2/axsep022nodedec.i "alINSS"        tt-layout-valores.aliqinss     "NO" "2" "NO"}
                                    {adapters/xml/ep2/axsep022nodedec.i "alIR"          tt-layout-valores.aliqir       "NO" "2" "NO"}
                                    {adapters/xml/ep2/axsep022nodedec.i "alCSLL"        tt-layout-valores.aliqcsll     "NO" "2" "NO"}
                                END.

                                {adapters/xml/ep2/axsep022nodedec.i "valissret"           tt-layout-cserv.valissret           "YES" "2" "NO"}
                                {adapters/xml/ep2/axsep022nodedec.i "outrasRetencoes"     tt-layout-cserv.outrasret           "YES" "2" "NO"}
                                {adapters/xml/ep2/axsep022nodedec.i "valliq"              tt-layout-cserv.valliq              "YES" "2" "NO"}
                                {adapters/xml/ep2/axsep022nodedec.i "desccond"            tt-layout-cserv.desccond            "YES" "2" "NO"}
                                {adapters/xml/ep2/axsep022nodedec.i "descinc"             tt-layout-cserv.descinc             "YES" "2" "NO"}
                                RUN addNode IN hGenXml (getStack(), "unidmed",            tt-layout-cserv.unidmed,            OUTPUT iId).
                                RUN addNode IN hGenXml (getStack(), "tributavel",         tt-layout-cserv.tributavel,         OUTPUT iId).
                                RUN addNode IN hGenXml (getStack(), "cfps",               tt-layout-cserv.cfps,               OUTPUT iId).
                                {adapters/xml/ep2/axsep022nodedec.i "aliqIssRetido"       tt-layout-cserv.aliqISSRetido       "YES" "2" "NO"}
                                RUN addNode IN hGenXml (getStack(), "codigoTribNacional", tt-layout-cserv.cTribNac,           OUTPUT iId).
                                
                                FIND FIRST tt-layout-refnfse NO-LOCK NO-ERROR.
                                IF AVAIL tt-layout-refnfse THEN 
                                    RUN addNode IN hGenXml (getStack(), "documentoRef", tt-layout-refnfse.refNFSe,     OUTPUT iId).
                                    
                                {adapters/xml/ep2/axsep022nodedec.i "baseCalculoInss"            tt-layout-cserv.vlbasinss              "YES" "2" "NO"}
                                {adapters/xml/ep2/axsep022nodedec.i "baseCalculoIrrf"            tt-layout-cserv.vlbasir                "YES" "2" "NO"}
                                {adapters/xml/ep2/axsep022nodedec.i "baseCalculoCofins"          tt-layout-cserv.vlbascfins             "YES" "2" "NO"}
                                {adapters/xml/ep2/axsep022nodedec.i "baseCalculoCsll"            tt-layout-cserv.vlbascsll              "YES" "2" "NO"}
                                {adapters/xml/ep2/axsep022nodedec.i "baseCalculoPis"             tt-layout-cserv.vlbaspis               "YES" "2" "NO"}
                                {adapters/xml/ep2/axsep022nodedec.i "baseCalculoRetido"          tt-layout-cserv.basecalc                   "YES" "2" "NO"}
                                RUN addNode IN hGenXml (getStack(), "itemTpRetPisCofins",        tt-layout-piscofins.itemTpRetPisCofins,        OUTPUT iId).

                                FOR FIRST tt-layout-IBSCBS WHERE tt-layout-IBSCBS.CodEstabelNF = tt-layout-cserv.CodEstabelNF
                                                            AND tt-layout-IBSCBS.SerieNF      = tt-layout-cserv.SerieNF
                                                            AND tt-layout-IBSCBS.NrNotaFisNF  = tt-layout-cserv.NrNotaFisNF
                                                            AND tt-layout-IBSCBS.cTribNac     = tt-layout-cserv.cTribNac:

                                    RUN addNode IN hGenXml (getStack(), "ibscbs", "", OUTPUT iId).
                                    
                                    addStack(iId).

                                        IF tt-layout-IBSCBS.tpEnteGov <> ? THEN // 1 - Sim ou 2 - n∆o 
                                            RUN addNode IN hGenXml (getStack(), "indCompGov",  "1",  OUTPUT iId).
                                        ELSE 
                                            RUN addNode IN hGenXml (getStack(), "indCompGov",  "2",  OUTPUT iId).

                                        RUN addNode IN hGenXml (getStack(), "codigoLocalIncidencia", tt-layout-IBSCBS.codigoLocalIncidencia,    OUTPUT iId).
                                        RUN addNode IN hGenXml (getStack(), "nomeLocalIncidencia",   tt-layout-IBSCBS.nomeLocalIncidencia,      OUTPUT iId).
                                        RUN addNode IN hGenXml (getStack(), "cTributacaoIbsCbs",     tt-layout-IBSCBS.cod-cst,                  OUTPUT iId).
                                        RUN addNode IN hGenXml (getStack(), "cClassTributaria",      tt-layout-IBSCBS.cod-class-trib,           OUTPUT iId).
                                        RUN addNode IN hGenXml (getStack(), "cCredPresumido",        tt-layout-IBSCBS.cod-clas-cred-presum-cbs, OUTPUT iId).
                                        
                                        FIND FIRST tt-layout-piscofins NO-LOCK NO-ERROR.
                                        IF AVAIL tt-layout-piscofins THEN DO:
                                            RUN addNode IN hGenXml (getStack(), "TpRetPisCofins", tt-layout-piscofins.TpRetPisCofins, OUTPUT iId).  //NT007
                                        END.
                                        
                                        IF tt-layout-IBSCBS.cod-class-trib-regul <> "" AND tt-layout-IBSCBS.cod-class-trib-regul <> ? THEN DO:
                                        
                                            RUN addNode IN hGenXml (getStack(), "tributacaoregular", "", OUTPUT iId).
                                            addStack(iId).
                                                RUN addNode IN hGenXml (getStack(), "cSitTributariaRegular", tt-layout-IBSCBS.cod-cst-regul,        OUTPUT iId).
                                                RUN addNode IN hGenXml (getStack(), "cClassTributariaReg",   tt-layout-IBSCBS.cod-class-trib-regul, OUTPUT iId).
                                            delStack(). /* fim tributacaoregular */
                                            
                                        END.
                                    delStack(). /* fim ibscbs */
                                END.
                                
                                //Caso n∆o tenha o FT4003F gerar apenas o TpRetPisCofins no grupo do ibscbs
                                //FIND FIRST tt-layout-IBSCBS NO-LOCK NO-ERROR.
                                IF NOT AVAIL tt-layout-IBSCBS THEN DO:
                                    FIND FIRST tt-layout-piscofins NO-LOCK NO-ERROR.
                                        IF AVAIL tt-layout-piscofins THEN DO:
                                        
                                            RUN addNode IN hGenXml (getStack(), "ibscbs", "", OUTPUT iId).
                                            addStack(iId).
                                            
                                            RUN addNode IN hGenXml (getStack(), "TpRetPisCofins", tt-layout-piscofins.TpRetPisCofins, OUTPUT iId).  //NT007
                                            delStack(). /* fim ibscbs */
                                        END.
                                END.
                       END.
                       
                       delStack(). /* fim servico */
                       
                  delStack(). /* fim servicos */
    
                  FOR FIRST tt-layout-valores NO-LOCK:
    
                       RUN addNode IN hGenXml (getStack(), "valores", "", OUTPUT iId).
                       addStack(iId).
    
                            {adapters/xml/ep2/axsep022nodedec.i    "iss"           tt-layout-valores.iss           "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "issret"        tt-layout-valores.issret        "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "outrret"       tt-layout-valores.outrret       "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "pis"           tt-layout-valores.pis           "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "cofins"        tt-layout-valores.cofins        "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "inss"          tt-layout-valores.vRetCP        "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "ir"            tt-layout-valores.vRetIRRF      "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "csll"          tt-layout-valores.vRetCSLL      "YES" "2" "NO"}

                            {adapters/xml/ep2/axsep022nodedec.i    "aliqiss"       tt-layout-valores.aliqiss       "YES" "4" "YES"}
                            {adapters/xml/ep2/axsep022nodedec.i    "aliqpis"       tt-layout-valores.aliqpis       "YES" "4" "YES"}
                            {adapters/xml/ep2/axsep022nodedec.i    "aliqcof"       tt-layout-valores.aliqcof       "YES" "4" "YES"}
                            {adapters/xml/ep2/axsep022nodedec.i    "aliqinss"      tt-layout-valores.aliqinss      "YES" "4" "YES"}
                            {adapters/xml/ep2/axsep022nodedec.i    "aliqir"        tt-layout-valores.aliqir        "YES" "4" "YES"}
                            {adapters/xml/ep2/axsep022nodedec.i    "aliqcsll"      tt-layout-valores.aliqcsll      "YES" "4" "YES"}
                            {adapters/xml/ep2/axsep022nodedec.i    "valtotdoc"     tt-layout-valores.valtotdoc      "YES" "4" "NO"}
                            
                            FIND FIRST tt-layout-fatura NO-LOCK NO-ERROR.
                            IF AVAIL tt-layout-fatura THEN
                                {adapters/xml/ep2/axsep022nodedec.i    "vlTotalFaturas" tt-layout-fatura.valor       "YES" "2" "NO"}
                                
                            {adapters/xml/ep2/axsep022nodedec.i    "basecalculo"    tt-layout-valores.basecalculo    "YES" "4" "NO"}
                            
                            FIND FIRST tt-layout-cserv NO-LOCK NO-ERROR.
                            IF AVAIL tt-layout-cserv THEN DO:
                                {adapters/xml/ep2/axsep022nodedec.i    "vliquinfse"        tt-layout-cserv.valliq     "YES" "2" "NO"}                                
                                RUN addNode IN hGenXml (getStack(),    "codigonbs",        tt-layout-cserv.cNBS,       OUTPUT iId).
                                {adapters/xml/ep2/axsep022nodedec.i    "basecalculopis"    tt-layout-valores.baspis    "YES" "2" "NO"}  
                                {adapters/xml/ep2/axsep022nodedec.i    "basecalculocofins" tt-layout-valores.bascfis   "YES" "2" "NO"}  
                                {adapters/xml/ep2/axsep022nodedec.i    "basecalculocsll"   tt-layout-valores.bascsll   "YES" "2" "NO"}  
                                {adapters/xml/ep2/axsep022nodedec.i    "basecalculoirrf"   tt-layout-valores.basir     "YES" "2" "NO"}  
                                {adapters/xml/ep2/axsep022nodedec.i    "basecalculoinss"   tt-layout-valores.basinss   "YES" "2" "NO"}  
                                
                                RUN addNode IN hGenXml (getStack(),    "codigoTribNacional",   tt-layout-cserv.cTribNac,    OUTPUT iId).
                            END.
  
                            FOR FIRST tt-layout-comext NO-LOCK:
                                  
                                    RUN addNode IN hGenXml (getStack(), "operacoesEspeciais", "", OUTPUT iId).
                                    addStack(iId).                                                                                          
                                        RUN addNode IN hGenXml (getStack(), "modoprestacao",               tt-layout-comext.mdPrestacao      ,  OUTPUT iId).                   
                                        RUN addNode IN hGenXml (getStack(), "vinculoprestacao",            tt-layout-comext.vincPrest        ,  OUTPUT iId).               
                                        RUN addNode IN hGenXml (getStack(), "tipomoeda",                   tt-layout-comext.tpMoeda          ,  OUTPUT iId).                
                                        {adapters/xml/ep2/axsep022nodedec.i "valorServicoEst"              tt-layout-comext.vServMoeda     "YES" "2" "NO"}
                                        RUN addNode IN hGenXml (getStack(), "mecanismoComExtPrest",        STRING(tt-layout-comext.mecAFComexP,"99"),  OUTPUT iId).               
                                        RUN addNode IN hGenXml (getStack(), "mecanismoComExtTom",          STRING(tt-layout-comext.mecAFComexT,"99"),  OUTPUT iId).              
                                        RUN addNode IN hGenXml (getStack(), "movTempBens",                 tt-layout-comext.movTempBens      ,  OUTPUT iId).  
                                        RUN addNode IN hGenXml (getStack(), "mdic",                        tt-layout-comext.mdic             ,  OUTPUT iId).                
                                                                                                                                                       
                                    delStack().
                            END. 
                            
                            RUN addNode IN hGenXml (getStack(), "ibscbs", "", OUTPUT iId).

                            addStack(iId).

                                FOR FIRST tt-layout-IBSCBS NO-LOCK:
                                
                                    {adapters/xml/ep2/axsep022nodedec.i "valorTotalNotaFiscal" tt-layout-IBSCBS.valorTotalNotaFiscal "YES" "2" "NO"}
                                    {adapters/xml/ep2/axsep022nodedec.i "baseCalculo"          tt-layout-IBSCBS.vl-base-ibscbs       "YES" "2" "NO"}
                                    {adapters/xml/ep2/axsep022nodedec.i "valorRepRes"          tt-layout-IBSCBS.valorTotalNotaFiscal "YES" "2" "NO"} /* ? */
                                    {adapters/xml/ep2/axsep022nodedec.i "percentualRedutor"    tt-layout-IBSCBS.perc-redutor             "YES" "2" "NO"}

                                    IF tt-layout-IBSCBS.cod-class-trib-regul <> "" AND tt-layout-IBSCBS.cod-class-trib-regul <> ? THEN DO:
                                    
                                        RUN addNode IN hGenXml (getStack(), "tributacaoregular", "", OUTPUT iId).

                                        addStack(iId).
                                        
                                            {adapters/xml/ep2/axsep022nodedec.i "aliqEfetivaRegIbsUf"     tt-layout-IBSCBS.aliq-efetiva-reg-ibs-uf  "YES" "2" "NO"}
                                            {adapters/xml/ep2/axsep022nodedec.i "tributacaoIbsUf"         tt-layout-IBSCBS.vl-ibs-uf-reg            "YES" "2" "NO"}
                                            {adapters/xml/ep2/axsep022nodedec.i "aliqEfetivaIbsMunicipio" tt-layout-IBSCBS.aliq-efetiva-reg-ibs-mun "YES" "2" "NO"}
                                            {adapters/xml/ep2/axsep022nodedec.i "tributacaoIbsMunicipio"  tt-layout-IBSCBS.vl-ibs-mun-reg           "YES" "2" "NO"}
                                            {adapters/xml/ep2/axsep022nodedec.i "aliqEfetivaCbs"          tt-layout-IBSCBS.aliq-efetiva-reg-cbs     "YES" "2" "NO"}
                                            {adapters/xml/ep2/axsep022nodedec.i "valTribRegCBS"           tt-layout-IBSCBS.vl-cbs-reg               "YES" "2" "NO"}

                                        delStack().
                                    
                                    END.
                                    
                                    /* ainda n∆o finalizado
                                     RUN addNode IN hGenXml (getStack(), "tributcompragov", "", OUTPUT iId).

                                        addStack(iId).
                                    
                                    */
                                    
                                    RUN addNode IN hGenXml (getStack(), "ibs", "", OUTPUT iId).

                                    addStack(iId).

                                        /* campos que estao zerado sao campos sem informacao no erp, no momento */
                                        {adapters/xml/ep2/axsep022nodedec.i "valorTotal"                   tt-layout-IBSCBS.vl-ibs                "YES" "2" "NO"}
                                        {adapters/xml/ep2/axsep022nodedec.i "valorCreditoPresumido"        tt-layout-IBSCBS.vl-credpres-ibs       "YES" "2" "NO"} 
                                        {adapters/xml/ep2/axsep022nodedec.i "percentualCreditoPresumido"   tt-layout-IBSCBS.perc-credpres-ibs         "YES" "2" "NO"}
                                        {adapters/xml/ep2/axsep022nodedec.i "valorTotalUf"                 tt-layout-IBSCBS.vl-ibs-uf             "YES" "2" "NO"}
                                        //{adapters/xml/ep2/axsep022nodedec.i "valorTotalDesUf"              "0"                                        "YES" "2" "NO"}
                                        //{adapters/xml/ep2/axsep022nodedec.i "valorTotalDiferimentoUf"      "0"                                        "YES" "2" "NO"}
                                        {adapters/xml/ep2/axsep022nodedec.i "percentualDiferimentoUF"      tt-layout-IBSCBS.perc-difer-ibs-uf         "YES" "2" "NO"}
                                        //{adapters/xml/ep2/axsep022nodedec.i "valorTributacaoOperacaoUf"    "0"                                        "YES" "2" "NO"}
                                        {adapters/xml/ep2/axsep022nodedec.i "percentualRedAliqUF"          tt-layout-IBSCBS.perc-red-aliq-ibs-uf      "YES" "2" "NO"}
                                        {adapters/xml/ep2/axsep022nodedec.i "aliquotaEfetivaUf"            tt-layout-IBSCBS.aliq-efetiva-ibs-uf       "YES" "2" "NO"}
                                        {adapters/xml/ep2/axsep022nodedec.i "aliquotaIBSMunicipio"         tt-layout-IBSCBS.aliq-ibs-mun              "YES" "2" "NO"}
                                        {adapters/xml/ep2/axsep022nodedec.i "valorIbsMunicipio"            tt-layout-IBSCBS.vl-ibs-mun            "YES" "2" "NO"}
                                        //{adapters/xml/ep2/axsep022nodedec.i "valorDifMunicipal"            "0"                                        "YES" "2" "NO"}
                                        {adapters/xml/ep2/axsep022nodedec.i "percDifMunicipio"             tt-layout-IBSCBS.perc-difer-ibs-mun        "YES" "2" "NO"}
                                        //{adapters/xml/ep2/axsep022nodedec.i "devTribMun"                   "0"                                        "YES" "2" "NO"}
                                        {adapters/xml/ep2/axsep022nodedec.i "percAliqEfetMun"              tt-layout-IBSCBS.aliq-efetiva-ibs-mun      "YES" "2" "NO"}
                                        {adapters/xml/ep2/axsep022nodedec.i "percRedAliqMun"               tt-layout-IBSCBS.perc-red-aliq-ibs-mun     "YES" "2" "NO"}

                                    delStack(). /* Fim ibs */

                                    RUN addNode IN hGenXml (getStack(), "cbs", "", OUTPUT iId).
                                    addStack(iId).

                                        /* campos que estao zerado sao campos sem informacao no erp, no momento */
                                        {adapters/xml/ep2/axsep022nodedec.i "valorTotal"                 tt-layout-IBSCBS.vl-cbs                     "YES" "2" "NO"}
                                        {adapters/xml/ep2/axsep022nodedec.i "valorCreditoPresumido"      tt-layout-IBSCBS.vl-CredPres-cbs            "YES" "2" "NO"}
                                        {adapters/xml/ep2/axsep022nodedec.i "aliquotaCreditoPresumido"   tt-layout-IBSCBS.perc-credpres-cbs              "YES" "2" "NO"}
                                        //{adapters/xml/ep2/axsep022nodedec.i "valorDesonerado"            "0"                                             "YES" "2" "NO"}
                                        //{adapters/xml/ep2/axsep022nodedec.i "aliqDes"                    "0"                                             "YES" "2" "NO"}
                                        //{adapters/xml/ep2/axsep022nodedec.i "valorDiferimento"           "0"                                             "YES" "2" "NO"}
                                        {adapters/xml/ep2/axsep022nodedec.i "percentualDiferimento"      tt-layout-IBSCBS.perc-difer-cbs                 "YES" "2" "NO"}
                                        //{adapters/xml/ep2/axsep022nodedec.i "valorTributacaoOperacao"    "0"                                             "YES" "2" "NO"}
                                        //{adapters/xml/ep2/axsep022nodedec.i "percentualAliquotaEfetiva"  tt-layout-IBSCBS.aliq-efetiva-cbs               "YES" "2" "NO"}
                                        {adapters/xml/ep2/axsep022nodedec.i "percRedAliq"                tt-layout-IBSCBS.perc-red-aliq-cbs              "YES" "2" "NO"}
                                        //{adapters/xml/ep2/axsep022nodedec.i "devolucaoTributo"           "0"                                             "YES" "2" "NO"}
                                        {adapters/xml/ep2/axsep022nodedec.i "valorPercentual"            tt-layout-IBSCBS.aliq-cbs                       "YES" "2" "NO"}

                                    delStack(). /* Fim cbs */

                                END.

                                delStack(). /* Fim ibscbs */

                       delStack(). /* fim valores */
    
                  END.
    
                  RUN addNode IN hGenXml (getStack(), "faturas", "", OUTPUT iId).
                  addStack(iId).
    
                       FOR FIRST tt-layout-fatura NO-LOCK:
    
                            RUN addNode IN hGenXml (getStack(), "fatura", "", OUTPUT iId).
                            addStack(iId).
    
                                 RUN addNode IN hGenXml (getStack(), "numero", tt-layout-fatura.numero, OUTPUT iId).
                                 {adapters/xml/ep2/axsep022nodedec.i "valor"   tt-layout-fatura.valor   "YES" "2" "NO"}
                                 
                       END.
                       
                       delStack(). /* fim fatura */
    
                  delStack(). /* fim faturas */
    
                  RUN addNode IN hGenXml (getStack(), "pagamentos", "", OUTPUT iId).
                  addStack(iId).
    
                       FOR EACH tt-layout-pagamento NO-LOCK:
    
                            RUN addNode IN hGenXml (getStack(), "pagamento", "", OUTPUT iId).
                            addStack(iId).

                                RUN addNode IN hGenXml (getStack(), "parcela", tt-layout-pagamento.parcela, OUTPUT iId).
                                RUN addNode IN hGenXml (getStack(), "dtvenc",  tt-layout-pagamento.dtvenc,  OUTPUT iId).
                                {adapters/xml/ep2/axsep022nodedec.i "valor"    tt-layout-pagamento.valor    "YES" "2" "NO"}

                                IF tt-layout-pagamento.meiopagto <> ? THEN
                                    RUN addNode IN hGenXml (getStack(), "meiopagto", tt-layout-pagamento.meiopagto, OUTPUT iId).
                                    
                            delStack(). /* fim pagamento */
                       END.
                       
                  delStack(). /* fim pagamentos */

                  FOR FIRST tt-layout-deducoes NO-LOCK:
                  
                      RUN addNode IN hGenXml (getStack(), "deducoes", "", OUTPUT iId).
                      addStack(iId).
        
                          {adapters/xml/ep2/axsep022nodedec.i  "desccond"    tt-layout-deducoes.desccond    "YES" "2" "NO"}
                          {adapters/xml/ep2/axsep022nodedec.i  "descincond"  tt-layout-deducoes.descincond  "YES" "2" "NO"}
      
                          FOR EACH tt-layout-deducao NO-LOCK:
      
                              RUN addNode IN hGenXml (getStack(), "deducao", "", OUTPUT iId).
                              addStack(iId).
      
                                    {adapters/xml/ep2/axsep022nodedec.i "totalnf"  tt-layout-deducao.totalnf  "YES" "2" "NO"}
                                    
                              delStack(). /* fim deducao */
                          END.
                          
                      delStack().  /* fim deducoes */
                  END.
    
                  FOR FIRST tt-layout-infocompl NO-LOCK:

                      RUN addNode IN hGenXml (getStack(), "infcompl", "", OUTPUT iId).
                      addStack(iId).
        
                          RUN addNode IN hGenXml (getStack(), "descricao",  tt-layout-infocompl.descricao,  OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "observacao", tt-layout-infocompl.xInfComp,   OUTPUT iId).
        
                      delStack().
                  END.
                  
                  FOR FIRST tt-layout-IBSCBS-dest NO-LOCK:
    
                       RUN addNode IN hGenXml (getStack(), "destinatario", "", OUTPUT iId).
                       addStack(iId).
    
                           IF  tt-layout-IBSCBS-dest.NIF <> ?
                           AND tt-layout-IBSCBS-dest.NIF <> "" THEN
                               RUN addNode IN hGenXml (getStack(), "nif", tt-layout-IBSCBS-dest.NIF, OUTPUT iId).
                           ELSE                           
                               RUN addNode IN hGenXml (getStack(), "cpfcnpj", tt-layout-IBSCBS-dest.cnpj, OUTPUT iId).
                            
                            IF  tt-layout-IBSCBS-dest.xNome <> ? THEN
                                RUN addNode IN hGenXml (getStack(), "nome", tt-layout-IBSCBS-dest.xNome, OUTPUT iId).
                                
                            RUN addNode IN hGenXml (getStack(), "endereco", "", OUTPUT iId).
                            addStack(iId).     
                            
                                RUN addNode IN hGenXml (getStack(), "logradouro",      tt-layout-IBSCBS-dest.xLgr,   OUTPUT iId).
                                RUN addNode IN hGenXml (getStack(), "numero",          tt-layout-IBSCBS-dest.nro,    OUTPUT iId).
                                RUN addNode IN hGenXml (getStack(), "codigoMunicipio", tt-layout-IBSCBS-dest.cMun,   OUTPUT iId).
                                RUN addNode IN hGenXml (getStack(), "nomeMunicipio",   tt-layout-IBSCBS-dest.xCidade,OUTPUT iId).
                                IF  tt-layout-IBSCBS-dest.xCpl <> ? THEN
                                    RUN addNode IN hGenXml (getStack(), "complemento", tt-layout-IBSCBS-dest.xCpl, OUTPUT iId).
                                RUN addNode IN hGenXml (getStack(), "bairro", tt-layout-IBSCBS-dest.xBairro, OUTPUT iId).
                                RUN addNode IN hGenXml (getStack(), "cep",    tt-layout-IBSCBS-dest.cep,     OUTPUT iId).
                                RUN addNode IN hGenXml (getStack(), "pais",   tt-layout-IBSCBS-dest.cPais,   OUTPUT iId).
                                IF  tt-layout-IBSCBS-dest.xEstProvReg <> ?
                                AND tt-layout-IBSCBS-dest.cEndPost    <> ? THEN
                                    RUN addNode IN hGenXml (getStack(), "estadoProvinciaExterior", tt-layout-IBSCBS-dest.xEstProvReg,         OUTPUT iId).
    
                            delStack(). 
                            
                            IF  (    tt-layout-IBSCBS-dest.fone <> ""
                                 AND tt-layout-IBSCBS-dest.fone <> ?)
                            OR  (    tt-layout-IBSCBS-dest.email <> ""
                                 AND tt-layout-IBSCBS-dest.email <> ?) THEN DO:
                                RUN addNode IN hGenXml (getStack(), "contato", "", OUTPUT iId).                                
                                addStack(iId).                              
                                
                                IF  tt-layout-IBSCBS-dest.fone <> ""
                                AND tt-layout-IBSCBS-dest.fone <> ? THEN 
                                    RUN addNode IN hGenXml (getStack(), "fone",  tt-layout-IBSCBS-dest.fone, OUTPUT iId).

                                IF  tt-layout-IBSCBS-dest.email <> ""
                                AND tt-layout-IBSCBS-dest.email <> ? THEN 
                                    RUN addNode IN hGenXml (getStack(), "email",  tt-layout-IBSCBS-dest.email, OUTPUT iId).

                                delStack(). 
                            END.          
                       delStack().        
                  END.
                  
                  FOR EACH tt-layout-imovel NO-LOCK:
    
                       RUN addNode IN hGenXml (getStack(), "imovel", "", OUTPUT iId).
                       addStack(iId).
    
                            RUN addNode IN hGenXml (getStack(), "inscImobFisc", tt-layout-imovel.inscImobFisc, OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cCIB",         tt-layout-imovel.cCIB,         OUTPUT iId).
                            
                                RUN addNode IN hGenXml (getStack(), "endereco", "", OUTPUT iId).
                                addStack(iId).
                                
                                   RUN addNode IN hGenXml (getStack(), "cep",                     tt-layout-imovel.cep,         OUTPUT iId).
                                   RUN addNode IN hGenXml (getStack(), "endereco",                tt-layout-imovel.logradouro,  OUTPUT iId).
                                   RUN addNode IN hGenXml (getStack(), "numero",                  tt-layout-imovel.numend,      OUTPUT iId).
                                   RUN addNode IN hGenXml (getStack(), "complemento",             tt-layout-imovel.complend,    OUTPUT iId).
                                   RUN addNode IN hGenXml (getStack(), "bairro",                  tt-layout-imovel.bairro,      OUTPUT iId).
                                   RUN addNode IN hGenXml (getStack(), "nomeMunicipio",           tt-layout-imovel.xCidade,     OUTPUT iId).
                                   RUN addNode IN hGenXml (getStack(), "estadoProvinciaExterior", tt-layout-imovel.xEstProvReg, OUTPUT iId).

                                delStack().

                       delStack().                                                                 
                                                                                                   
                 END.
    
            delStack(). /* fim do RPS */
    
        END.
    END.

    /* OBTEM O XML NUMA HANDLE */
    RUN generateXML IN hGenXml (OUTPUT hXMLNFSe).

    /*SALVAR XML A SER ENVIADO AO TSS OU NEOGRID*/
    ASSIGN plcXMLNFSe = "":U.
    hXMLNFSe:SAVE("LONGCHAR",plcXMLNFSe).

    IF plcXMLNFSe = "" THEN DO:
        CREATE tt_log_erro.
        ASSIGN tt_log_erro.ttv_num_cod_erro = 0.
        ASSIGN tt_log_erro.ttv_des_msg_erro = "Erro na geraá∆o do arquivo XML".
    END.

    /* LIBERA MEM‡RIA ALOCADA PARA O OBJETO */
    DELETE OBJECT hXMLNFSe NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-cancelamento:

    FOR EACH tt-layout-cancelamento NO-LOCK:
    
         RUN addNode IN hGenXml (getStack(), "cancelamento", "", OUTPUT iId).
         addStack(iId).
    
              RUN addNode IN hGenXml (getStack(), "cpfcnpj",             tt-layout-cancelamento.cpfcnpj,              OUTPUT iId).
              RUN addNode IN hGenXml (getStack(), "numeronfse",          tt-layout-cancelamento.numeronfse,           OUTPUT iId).
              RUN addNode IN hGenXml (getStack(), "codmunibge",          tt-layout-cancelamento.codmunibge,           OUTPUT iId).
              RUN addNode IN hGenXml (getStack(), "motcanc",             tt-layout-cancelamento.motcanc,              OUTPUT iId).
              RUN addNode IN hGenXml (getStack(), "codmotcanc",          tt-layout-cancelamento.codmotcanc,           OUTPUT iId).
              RUN addNode IN hGenXml (getStack(), "inmunprest",          tt-layout-cancelamento.inmunprest,           OUTPUT iId).
    
         delStack().
    
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE piDestroy:

END PROCEDURE.


