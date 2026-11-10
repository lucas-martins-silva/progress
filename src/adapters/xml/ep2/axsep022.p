/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSEP022 2.00.00.036 } /*** "010036" 22/09/2026 12:12:28 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i axsep022 MUT}
&ENDIF

{cdp/cdcfgdis.i}

/*-------------------------------------------------
                  axsep022.p
                  
           PROGRAMA DE GERAÄ«O DA NFS-e                  
-------------------------------------------------*/


{dibo/bodi135nfse.i6}                          /* Definiá‰es Tabelas Tempor†rias tt-rps tt-identificacao tt-substituicao tt-cancelamento tt-atividade tt-prestador tt-prestacao tt-intermediario tt-tomador tt-servico tt-valores tt-fatura tt-pagamento tt-deducao tt-constrciv tt-ativport tt-construcao */
{dibo/bodi135nfse.i8}                           //tempor†rias LNacional
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
    DEFINE INPUT  PARAM TABLE FOR tt-rps.
    DEFINE INPUT  PARAM TABLE FOR tt-identificacao.
    DEFINE INPUT  PARAM TABLE FOR tt-substituicao.
    DEFINE INPUT  PARAM TABLE FOR tt-cancelamento.
    DEFINE INPUT  PARAM TABLE FOR tt-atividade.
    DEFINE INPUT  PARAM TABLE FOR tt-prestador.
    DEFINE INPUT  PARAM TABLE FOR tt-prestacao.
    DEFINE INPUT  PARAM TABLE FOR tt-intermediario.
    DEFINE INPUT  PARAM TABLE FOR tt-tomador.
    DEFINE INPUT  PARAM TABLE FOR tt-servico.
    DEFINE INPUT  PARAM TABLE FOR tt-valores.
    DEFINE INPUT  PARAM TABLE FOR tt-fatura.
    DEFINE INPUT  PARAM TABLE FOR tt-pagamento.
    DEFINE INPUT  PARAM TABLE FOR tt-deducao.
    DEFINE INPUT  PARAM TABLE FOR tt-constrciv.
    DEFINE INPUT  PARAM TABLE FOR tt-ativport.
    DEFINE INPUT  PARAM TABLE FOR tt-construcao.
    DEFINE INPUT  PARAM TABLE FOR tt-ln-comext.

    DEFINE OUTPUT PARAM plcXMLNFSe AS LONGCHAR NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.

    CREATE X-DOCUMENT hXMLNFSe.
    
    /* RESETA OS VALORES */
    RUN reset IN hGenXml.

    /* SETA VALOR DE ENCODING */
    RUN setEncoding IN hGenXml ("UTF-8").

    /* LAYOUT DE CANCELAMENTO NO TC2 INTEGRA APENAS COM OS CAMPOS DE CANCELAMENTO. PARA O TSS ê INTEGRADO O LAYOUT INTEIRO */
    IF  LOOKUP(p-tp-integ, "TC2,TPF":U) > 0
    AND CAN-FIND (FIRST tt-cancelamento) THEN DO:

        FOR EACH tt-rps NO-LOCK:
    
             RUN addNode      IN hGenXml (getStack(), "rps", "", OUTPUT iId).
             /*RUN setAttribute IN hGenXml (INPUT iId, "id",     (tt-rps.Id#)).*/
    
             addStack(iId).

             RUN pi-cancelamento.

             delStack().
        END.
        
    END.
    ELSE DO:
        FOR EACH tt-rps NO-LOCK:
             RUN addNode      IN hGenXml (getStack(), "rps", "", OUTPUT iId).
             RUN setAttribute IN hGenXml (INPUT iId, "id",     (tt-rps.Id#)).
    
             addStack(iId).
    
                  RUN addNode IN hGenXml (getStack(), "assinatura", tt-rps.assinatura, OUTPUT iId).
    
                  FOR EACH tt-identificacao NO-LOCK:
    
                       RUN addNode IN hGenXml (getStack(), "identificacao", "", OUTPUT iId).
                       addStack(iId).
    
                            RUN addNode IN hGenXml (getStack(), "dthremissao",         tt-identificacao.dthremissao,         OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "serierps",            tt-identificacao.serierps,            OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "numerorps",           int(tt-identificacao.numerorps),           OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tipo",                tt-identificacao.tipo,                   OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "situacaorps",         tt-identificacao.situacaorps,            OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tiporecolhe",         tt-identificacao.tiporecolhe,            OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tipooper",            tt-identificacao.tipooper,               OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tipotrib",            tt-identificacao.tipotrib,               OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "regimeesptrib",       tt-identificacao.regimeesptrib,          OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "formpagto",           tt-identificacao.formpagto,              OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "natop",               tt-identificacao.natop,                  OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "dtcompetencia",       tt-identificacao.dtcompetencia,          OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "incentfiscal",        tt-identificacao.incentfiscal,           OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "issret",              tt-identificacao.issret,                 OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "itemlistaserv",       tt-identificacao.itemlistaserv,          OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cnae",                tt-identificacao.cnae,                   OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "ctributmun",          tt-identificacao.ctributmun,             OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "codigocfps",          tt-identificacao.codigocfps,             OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "ctipolancamento",     tt-identificacao.ctipolancamento,        OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cexiss",              tt-identificacao.cexiss,                 OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cresponsavelretencao", tt-identificacao.cresponsavelretencao,  OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "deveissmunprestador",  tt-identificacao.deveissmunprestador,   OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "codverificacao",       tt-identificacao.codverificacao,        OUTPUT iId).
    
                       delStack().
    
                  END.
    
                  FOR EACH tt-substituicao NO-LOCK:
    
                       RUN addNode IN hGenXml (getStack(), "substituicao", "", OUTPUT iId).
                       addStack(iId).
    
                            RUN addNode IN hGenXml (getStack(), "serierps",            tt-substituicao.serierps,             OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "numerorps",           tt-substituicao.numerorps,            OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "numeronfse",          tt-substituicao.numeronfse,           OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "idnfse",              tt-substituicao.idnfse,               OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tipo",                tt-substituicao.tipo,                 OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "dtemissaonfse",       tt-substituicao.dtemissaonfse,        OUTPUT iId).
    
                       delStack().
    
                  END.
    
                  RUN pi-cancelamento.
    
                  FOR EACH tt-atividade NO-LOCK:
    
                       RUN addNode IN hGenXml (getStack(), "atividade", "", OUTPUT iId).
                       addStack(iId).
    
                            RUN addNode IN hGenXml (getStack(), "codigo",              tt-atividade.codigo,                  OUTPUT iId).
                            {adapters/xml/ep2/axsep022nodedec.i "aliquota"             tt-atividade.aliquota                 "YES" "2" "NO"}
    
                       delStack().
    
                  END.
    
                  FOR EACH tt-prestador NO-LOCK:
    
                       RUN addNode IN hGenXml (getStack(), "prestador", "", OUTPUT iId).
                       addStack(iId).
    
                            RUN addNode IN hGenXml (getStack(), "inscmun",              tt-prestador.inscmun,                 OUTPUT iId). 
                            RUN addNode IN hGenXml (getStack(), "cpfcnpj",              tt-prestador.cpfcnpj,                 OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "razao",                tt-prestador.razao,                   OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "fantasia",             tt-prestador.fantasia,                OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "codmunibge",           tt-prestador.codmunibge,              OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "codmunsiafi",          tt-prestador.codmunsiafi,             OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cidade",               tt-prestador.cidade,                  OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "uf",                   tt-prestador.uf,                      OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "email",                tt-prestador.email,                   OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "ddd",                  tt-prestador.ddd,                     OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "telefone",             tt-prestador.telefone,                OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "simpnac",              tt-prestador.simpnac,                 OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "incentcult",           tt-prestador.incentcult,              OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "numproc",              tt-prestador.numproc,                 OUTPUT iId). //N˙mero do Processo
                            RUN addNode IN hGenXml (getStack(), "logradouro",           tt-prestador.logradouro,              OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "numend",               tt-prestador.numend,                  OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "compleend",            tt-prestador.compleend,               OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "bairro",               tt-prestador.bairro,                  OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tplogradouro",         tt-prestador.tplogradouro,            OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tpbairro",             tt-prestador.tpbairro,                OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cep",                  tt-prestador.cep,                     OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cie",                  tt-prestador.cie,                     OUTPUT iId).
    
                       delStack().
    
                  END.
    
                  FOR EACH tt-prestacao NO-LOCK:
    
                       RUN addNode IN hGenXml (getStack(), "prestacao", "", OUTPUT iId).
                       addStack(iId).
    
                            RUN addNode IN hGenXml (getStack(), "serieprest",           tt-prestacao.serieprest,              OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "logradouro",           tt-prestacao.logradouro,              OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "numend",               tt-prestacao.numend,                  OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "complend",             tt-prestacao.complend,                OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "codmunibge",           tt-prestacao.codmunibge,              OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "codmunincidenciaibge", tt-prestacao.codmunincidenciaibge,    OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "codmunsiafi",          tt-prestacao.codmunsiafi,             OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "municipio",            tt-prestacao.municipio,               OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "bairro",               tt-prestacao.bairro,                  OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "uf",                   tt-prestacao.uf,                      OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cep",                  tt-prestacao.cep,                     OUTPUT iId).
    
                       delStack().
    
                  END.
    
                  FOR EACH tt-intermediario NO-LOCK:
    
                       RUN addNode IN hGenXml (getStack(), "intermediario", "", OUTPUT iId).
                       addStack(iId).
    
                            RUN addNode IN hGenXml (getStack(), "razao",               tt-intermediario.razao,               OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cpfcnpj",             tt-intermediario.cpfcnpj,             OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "inscmun",             tt-intermediario.inscmun,             OUTPUT iId).
    
                       delStack().
    
                  END.
    
                  FOR EACH tt-tomador NO-LOCK:
    
                       RUN addNode IN hGenXml (getStack(), "tomador", "", OUTPUT iId).
                       addStack(iId).
    
                            RUN addNode IN hGenXml (getStack(), "inscmun",             tt-tomador.inscmun,                   OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cpfcnpj",             tt-tomador.cpfcnpj,                   OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "razao",               tt-tomador.razao,                     OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tipologr",            tt-tomador.tipologr,                  OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "logradouro",          tt-tomador.logradouro,                OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "numend",              tt-tomador.numend,                    OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "complend",            tt-tomador.complend,                  OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tipobairro",          tt-tomador.tipobairro,                OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "bairro",              tt-tomador.bairro,                    OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "codmunibge",          tt-tomador.codmunibge,                OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "codmunsiafi",         tt-tomador.codmunsiafi,               OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cidade",              tt-tomador.cidade,                    OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "uf",                  tt-tomador.uf,                        OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cep",                 tt-tomador.cep,                       OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "email",               tt-tomador.email,                     OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "ddd",                 tt-tomador.ddd,                       OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "telefone",            tt-tomador.telefone,                  OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "codpais",             tt-tomador.codpais,                   OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "nomepais",            tt-tomador.nomepais,                  OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "estrangeiro",         tt-tomador.estrangeiro,               OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "notificatomador",     tt-tomador.notificatomador,           OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "csituacaoesptom",     tt-tomador.csituacaoesptom,           OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "ctomnaoidentificado", tt-tomador.ctomnaoidentificado,       OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cietom",              tt-tomador.cietom,                    OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "niftomador",          tt-tomador.niftomador,                OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "passaporte",          tt-tomador.passaporte,                OUTPUT iId).

                            IF tt-tomador.nomepais <> "Brasil" THEN DO:
                                  
                                RUN addNode IN hGenXml (getStack(), "endExt", "", OUTPUT iId).
                                addStack(iId).                                                                                          
                                RUN addNode IN hGenXml (getStack(), "cPais",      tt-tomador.cPais           ,  OUTPUT iId).
                                RUN addNode IN hGenXml (getStack(), "cEndPost",   tt-tomador.cEndPost        ,  OUTPUT iId).
                                RUN addNode IN hGenXml (getStack(), "xCidade",    tt-tomador.xCidade         ,  OUTPUT iId).
                                RUN addNode IN hGenXml (getStack(), "xEstProvReg",tt-tomador.xEstProvReg     ,  OUTPUT iId).
                                                                                                                                              
                                delStack().
                            END.
                            
                       delStack().
    
                  END.
    
                  RUN addNode IN hGenXml (getStack(), "servicos", "", OUTPUT iId).
                  addStack(iId).
    
                       FOR EACH tt-servico NO-LOCK:
    
                            RUN addNode IN hGenXml (getStack(), "servico", "", OUTPUT iId).
                            addStack(iId).
    
                                 RUN addNode IN hGenXml (getStack(), "codigo",       tt-servico.codigo,     OUTPUT iId).
    
                                 {adapters/xml/ep2/axsep022nodedec.i "aliquota"        tt-servico.aliquota    "YES" "4" "YES"}
    
                                 RUN addNode IN hGenXml (getStack(), "idcnae",       tt-servico.idcnae,     OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "cnae",         tt-servico.cnae,       OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "codtrib",      tt-servico.codtrib,    OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "discr",        tt-servico.discr,      OUTPUT iId).
				 
                                 IF tt-servico.quant = INT(tt-servico.quant) THEN /* INTEIRO - PARA EVITAR VALORES COMO  1.00 */
                                 	RUN addNode IN hGenXml (getStack(), "quant", string(tt-servico.quant),     OUTPUT iId).
                                 ELSE /* DECIMAL */
                                        {adapters/xml/ep2/axsep022nodedec.i "quant"         tt-servico.quant       "YES" "2" "NO"}
					
                                 {adapters/xml/ep2/axsep022nodedec.i "valunit"       tt-servico.valunit     "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "valtotal"      tt-servico.valtotal    "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "basecalc"      tt-servico.basecalc    "YES" "2" "NO"}
                                 RUN addNode IN hGenXml (getStack(), "issretido",    tt-servico.issretido,  OUTPUT iId).
                                 {adapters/xml/ep2/axsep022nodedec.i "valdedu"       tt-servico.valdedu     "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "descdedu"      tt-servico.descdedu    "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "valpis"        tt-servico.valpis      "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "valcof"        tt-servico.valcof      "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "valinss"       tt-servico.valinss     "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "valir"         tt-servico.valir       "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "valcsll"       tt-servico.valcsll     "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "valiss"        tt-servico.valiss      "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "valissret"     tt-servico.valissret   "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "outrasret"     tt-servico.outrasret   "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "valliq"        tt-servico.valliq      "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "desccond"      tt-servico.desccond    "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "descinc"       tt-servico.descinc     "YES" "2" "NO"}
                                 RUN addNode IN hGenXml (getStack(), "unidmed",      tt-servico.unidmed,    OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "tributavel",   tt-servico.tributavel, OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "cfps",         tt-servico.cfps,       OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "cst",          tt-servico.cst,        OUTPUT iId).
                                 {adapters/xml/ep2/axsep022nodedec.i "valrepasse"    tt-servico.valrepasse  "YES" "2" "NO"}
    				IF p-tp-integ = "TC2" THEN
                                 FOR FIRST tt-ln-comext NO-LOCK:
                                  
                                    RUN addNode IN hGenXml (getStack(), "importacaoexportacao", "", OUTPUT iId).
                                    addStack(iId).                                                                                          
                                    RUN addNode IN hGenXml (getStack(), "mdic",                        tt-ln-comext.mdic             ,  OUTPUT iId).                
                                    RUN addNode IN hGenXml (getStack(), "modoprestacao",               tt-ln-comext.mdPrestacao      ,  OUTPUT iId).                   
                                    RUN addNode IN hGenXml (getStack(), "mecadcomexp",          STRING(tt-ln-comext.mecAFComexP,"99"),  OUTPUT iId).               
                                    RUN addNode IN hGenXml (getStack(), "mecafcomext",          STRING(tt-ln-comext.mecAFComexT,"99"),  OUTPUT iId).              
                                    RUN addNode IN hGenXml (getStack(), "movimentacaotemporariabens",  tt-ln-comext.movTempBens      ,  OUTPUT iId).               
                                    RUN addNode IN hGenXml (getStack(), "tipomoeda",                   tt-ln-comext.tpMoeda          ,  OUTPUT iId).                
                                    RUN addNode IN hGenXml (getStack(), "vinculoprestacao",            tt-ln-comext.vincPrest        ,  OUTPUT iId).               
                                    {adapters/xml/ep2/axsep022nodedec.i "valorservicomoeda"            tt-ln-comext.vServMoeda     "YES" "2" "NO"}
                                                                                                                                                   
                                    delStack().
                                 END. 
                            delStack().
    
                       END.
                  delStack().
    
                  FOR EACH tt-valores NO-LOCK:
    
                       RUN addNode IN hGenXml (getStack(), "valores", "", OUTPUT iId).
                       addStack(iId).
    
                            {adapters/xml/ep2/axsep022nodedec.i    "iss"           tt-valores.iss           "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "issret"        tt-valores.issret        "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "outrret"       tt-valores.outrret       "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "pis"           tt-valores.pis           "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "cofins"        tt-valores.cofins        "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "inss"          tt-valores.inss          "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "ir"            tt-valores.ir            "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "csll"          tt-valores.csll          "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "aliqiss"       tt-valores.aliqiss       "YES" "4" "YES"}
                            {adapters/xml/ep2/axsep022nodedec.i    "aliqpis"       tt-valores.aliqpis       "YES" "4" "YES"}
                            {adapters/xml/ep2/axsep022nodedec.i    "aliqcof"       tt-valores.aliqcof       "YES" "4" "YES"}
                            {adapters/xml/ep2/axsep022nodedec.i    "aliqinss"      tt-valores.aliqinss      "YES" "4" "YES"}
                            {adapters/xml/ep2/axsep022nodedec.i    "aliqir"        tt-valores.aliqir        "YES" "4" "YES"}
                            {adapters/xml/ep2/axsep022nodedec.i    "aliqcsll"      tt-valores.aliqcsll      "YES" "4" "YES"}
                            {adapters/xml/ep2/axsep022nodedec.i    "valtotdoc"     tt-valores.valtotdoc     "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "basecalculo"   tt-valores.basecalculo   "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "vliquinfse"    tt-valores.vliquinfse    "YES" "2" "NO"}

                            {adapters/xml/ep2/axsep022nodedec.i    "basecalculopis"    tt-valores.basecalculopis    "YES" "2" "NO"}  
                            {adapters/xml/ep2/axsep022nodedec.i    "basecalculocofins" tt-valores.basecalculocofins "YES" "2" "NO"}  
                            {adapters/xml/ep2/axsep022nodedec.i    "basecalculocsll"   tt-valores.basecalculocsll   "YES" "2" "NO"}  
                            {adapters/xml/ep2/axsep022nodedec.i    "basecalculoirrf"   tt-valores.basecalculoirrf   "YES" "2" "NO"}  
                            {adapters/xml/ep2/axsep022nodedec.i    "basecalculoinss"   tt-valores.basecalculoinss   "YES" "2" "NO"}  
                            RUN addNode IN hGenXml (getStack(),    "codigonbs",        tt-valores.cNBS,      OUTPUT iId).

    
                       delStack().
    
                  END.
    
                  RUN addNode IN hGenXml (getStack(), "faturas", "", OUTPUT iId).
                  addStack(iId).
    
                       FOR EACH tt-fatura NO-LOCK:
    
                            RUN addNode IN hGenXml (getStack(), "fatura", "", OUTPUT iId).
                            addStack(iId).
    
                                 RUN addNode IN hGenXml (getStack(), "numero", tt-fatura.numero, OUTPUT iId).
                                 {adapters/xml/ep2/axsep022nodedec.i "valor"   tt-fatura.valor   "YES" "2" "NO"}
                            delStack().
    
                       END.
    
                  delStack().
    
                  RUN addNode IN hGenXml (getStack(), "pagamentos", "", OUTPUT iId).
                  addStack(iId).
    
                       FOR EACH tt-pagamento NO-LOCK:
    
                            RUN addNode IN hGenXml (getStack(), "pagamento", "", OUTPUT iId).
                            addStack(iId).
    
                                 IF tt-pagamento.meiopagto <> ? THEN
                                    RUN addNode IN hGenXml (getStack(), "meiopagto", tt-pagamento.meiopagto, OUTPUT iId). 
                                 
                                 RUN addNode IN hGenXml (getStack(), "parcela", tt-pagamento.parcela, OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "dtvenc",  tt-pagamento.dtvenc,  OUTPUT iId).
                                 {adapters/xml/ep2/axsep022nodedec.i "valor"    tt-pagamento.valor    "YES" "2" "NO"}
                            delStack().
    
                       END.
    
                  delStack().

                  IF (tt-rps.desccond   > 0
                  OR  tt-rps.descincond > 0
                  OR  CAN-FIND (FIRST tt-deducao)) THEN DO:
                  
                      RUN addNode IN hGenXml (getStack(), "deducoes", "", OUTPUT iId).
                      addStack(iId).
        
                           {adapters/xml/ep2/axsep022nodedec.i  "desccond"    tt-rps.desccond    "YES" "2" "NO"}
                           {adapters/xml/ep2/axsep022nodedec.i  "descincond"  tt-rps.descincond  "YES" "2" "NO"}
        
                           FOR EACH tt-deducao NO-LOCK:
        
                                RUN addNode IN hGenXml (getStack(), "deducao", "", OUTPUT iId).
                                addStack(iId).
        
                                     RUN addNode IN hGenXml (getStack(), "tipo",                 tt-deducao.tipo,                 OUTPUT iId).
                                     RUN addNode IN hGenXml (getStack(), "modal",                tt-deducao.modal,                OUTPUT iId).
                                     RUN addNode IN hGenXml (getStack(), "codobra",              tt-deducao.codobra,              OUTPUT iId).
                                     RUN addNode IN hGenXml (getStack(), "codart",               tt-deducao.codart,               OUTPUT iId).
                                     RUN addNode IN hGenXml (getStack(), "cpfcnpj",              tt-deducao.cpfcnpj,              OUTPUT iId).
                                     RUN addNode IN hGenXml (getStack(), "numeronf",             tt-deducao.numeronf,             OUTPUT iId).
                                     {adapters/xml/ep2/axsep022nodedec.i "totalnf"               tt-deducao.totalnf               "YES" "2" "NO"}
                                     {adapters/xml/ep2/axsep022nodedec.i "percentual"            tt-deducao.percentual            "YES" "2" "NO"}
                                     {adapters/xml/ep2/axsep022nodedec.i "valor"                 tt-deducao.valor                 "YES" "2" "NO"}
                                     RUN addNode IN hGenXml (getStack(), "descricaomaterial",    tt-deducao.descricaomaterial,    OUTPUT iId).
                                     {adapters/xml/ep2/axsep022nodedec.i "valorunitariomaterial" tt-deducao.valorunitariomaterial "YES" "2" "NO"}
                                     RUN addNode IN hGenXml (getStack(), "quantidadematerial",   tt-deducao.quantidadematerial,   OUTPUT iId).

                                delStack().
        
                           END.
                      delStack().
                  END.
    
                  RUN addNode IN hGenXml (getStack(), "infcompl", "", OUTPUT iId).
                  addStack(iId).
    
                       RUN addNode IN hGenXml (getStack(), "descricao",  tt-rps.descricao,  OUTPUT iId).
                       RUN addNode IN hGenXml (getStack(), "observacao", tt-rps.observacao, OUTPUT iId).
    
                       FOR EACH tt-constrciv NO-LOCK:
    
                            RUN addNode IN hGenXml (getStack(), "constrciv", "", OUTPUT iId).
                            addStack(iId).
    
                                 RUN addNode IN hGenXml (getStack(), "nomeobra",            tt-constrciv.nomeobra,            OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "endereco",            tt-constrciv.endereco,            OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "numero",              tt-constrciv.numero,              OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "compl",               tt-constrciv.compl,               OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "bairro",              tt-constrciv.bairro,              OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "codmunibge",          tt-constrciv.codmunibge,          OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "uf",                  tt-constrciv.uf,                  OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "cep",                 tt-constrciv.cep,                 OUTPUT iId).
                                 {adapters/xml/ep2/axsep022nodedec.i "dedmat"               tt-constrciv.dedmat               "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "dedsubemp"            tt-constrciv.dedsubemp            "YES" "2" "NO"}
                                 RUN addNode IN hGenXml (getStack(), "servprestviapublica", tt-constrciv.servprestviapublica, OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "tpempreitada",        tt-constrciv.tpempreitada,        OUTPUT iId).
    
                            delStack().
    
                       END.
    
                       FOR EACH tt-ativport NO-LOCK:
    
                            RUN addNode IN hGenXml (getStack(), "ativport", "", OUTPUT iId).
                            addStack(iId).
    
                                 RUN addNode IN hGenXml (getStack(), "nomraz",     tt-ativport.nomraz,     OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "cpfcnpj",    tt-ativport.cpfcnpj,    OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "endereco",   tt-ativport.endereco,   OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "numero",     tt-ativport.numero,     OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "compl",      tt-ativport.compl,      OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "bairro",     tt-ativport.bairro,     OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "codmunibge", tt-ativport.codmunibge, OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "uf",         tt-ativport.uf,         OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "cep",        tt-ativport.cep,        OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "stpropr",    tt-ativport.stpropr,    OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "nomeemb",    tt-ativport.nomeemb,    OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "bandemb",    tt-ativport.bandemb,    OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "nomeport",   tt-ativport.nomeport,   OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "dthrent",    tt-ativport.dthrent,    OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "dthrsai",    tt-ativport.dthrsai,    OUTPUT iId).
                            delStack().
    
                       END.
    
                  delStack().
    
                  FOR EACH tt-construcao NO-LOCK:
    
                       RUN addNode IN hGenXml (getStack(), "construcao", "", OUTPUT iId).
                       addStack(iId).
    
                            RUN addNode IN hGenXml (getStack(), "codigoobra", tt-construcao.codigoobra, OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "art",        tt-construcao.art,        OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tipoobra",   tt-construcao.tipoobra,   OUTPUT iId).
    
                       delStack().
    
                  END.
             delStack().
    
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

PROCEDURE PIGeraXMLNFSe-RT:
    
    DEFINE INPUT  PARAM TABLE FOR tt-layout                  . 
    DEFINE INPUT  PARAM TABLE FOR tt-layout-inf              .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-subst            .      
    DEFINE INPUT  PARAM TABLE FOR tt-layout-cancelamento     .          
    DEFINE INPUT  PARAM TABLE FOR tt-layout-atividade        .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-prest            .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-toma             .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-interm           .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-locPrest         .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-cserv            .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-infocompl        .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-obra             .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-imovel           .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-valores          .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-pagamento        .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-fatura           .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-deducoes         .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-deducao          .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-piscofins        .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-cancelamento     .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-atvEvento        .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-dedred           .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-comext           .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-lsadppu          .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-explRod          .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-documentos       .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-fornec           .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-refnfse          .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-IBSCBS           .
    DEFINE INPUT  PARAM TABLE FOR tt-layout-IBSCBS-dest      .
    
    DEFINE OUTPUT PARAM plcXMLNFSe AS LONGCHAR NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.                                                          
    
 
    CREATE X-DOCUMENT hXMLNFSe.
    
    /* RESETA OS VALORES */
    RUN reset IN hGenXml.

    /* SETA VALOR DE ENCODING */
    RUN setEncoding IN hGenXml ("UTF-8").

    /* LAYOUT DE CANCELAMENTO NO TC2 INTEGRA APENAS COM OS CAMPOS DE CANCELAMENTO. PARA O TSS ê INTEGRADO O LAYOUT INTEIRO */
    IF CAN-FIND (FIRST tt-layout-cancelamento ) THEN DO:

        FOR FIRST tt-layout NO-LOCK:
    
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
    
                  FOR FIRST tt-layout-inf NO-LOCK:
    
                       RUN addNode IN hGenXml (getStack(), "identificacao", "", OUTPUT iId).
                       addStack(iId).
    
                            RUN addNode IN hGenXml (getStack(), "dthremissao",         tt-layout-inf.dhEmi,               OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "serierps",            tt-layout-inf.serie,               OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "numerorps",           int(tt-layout-inf.numerorps),      OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tipo",                tt-layout-inf.tipo,                OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "situacaorps",         tt-layout-inf.situacaorps,         OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tiporecolhe",         tt-layout-inf.tiporecolhe,         OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tipooper",            tt-layout-inf.tipooper,            OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tipotrib",            tt-layout-inf.tipotrib,            OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "regimeesptrib",       tt-layout-inf.regimeesptrib,       OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "formpagto",           tt-layout-inf.formpagto,           OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "natop",               tt-layout-inf.natop,               OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "dtcompetencia",       tt-layout-inf.dhemi,               OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "issret",              tt-layout-inf.issret,              OUTPUT iId).        
                            
                            FOR FIRST tt-layout-cserv NO-LOCK:
                            //  RUN addNode IN hGenXml (getStack(), "incentfiscal",        tt-layout-inf.incentfiscal,        OUTPUT iId).
                              RUN addNode IN hGenXml (getStack(), "itemlistaserv",       tt-layout-cserv.cTribNac,       OUTPUT iId).
                              RUN addNode IN hGenXml (getStack(), "cnae",                tt-layout-cserv.cnae,           OUTPUT iId).         
                              IF tt-layout-cserv.cTribMun <> "" THEN
                                 RUN addNode IN hGenXml (getStack(), "ctributmun",          tt-layout-cserv.cTribMun,       OUTPUT iId).
                            END.
                            
                            RUN addNode IN hGenXml (getStack(), "codigocfps",          tt-layout-inf.codigocfps,          OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "ctipolancamento",     tt-layout-inf.ctipolancamento,     OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cexiss",              tt-layout-inf.cexiss,              OUTPUT iId).
                             
                            RUN addNode IN hGenXml (getStack(), "cresponsavelretencao",  tt-layout-inf.cresponsavelretencao, OUTPUT iId).

                            IF tt-layout-inf.regimeTribSN <> ? THEN                             
                               RUN addNode IN hGenXml (getStack(), "regimeapuracaotributos",tt-layout-inf.regimeTribSN,OUTPUT iId).

                            RUN addNode IN hGenXml (getStack(), "deveissmunprestador",   tt-layout-inf.deveissmunprestador,  OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "codverificacao",        tt-layout-inf.codverificacao,       OUTPUT iId).    
                       delStack().
    
                  END.
    
                  FOR FIRST tt-layout-subst NO-LOCK:
    
                       RUN addNode IN hGenXml (getStack(), "substituicao", "", OUTPUT iId).
                       addStack(iId).
    
                            RUN addNode IN hGenXml (getStack(), "serierps",            tt-layout-subst.serierps,             OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "numerorps",           tt-layout-subst.numerorps,            OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "numeronfse",          tt-layout-subst.numeronfse,           OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "idnfse",              tt-layout-subst.idnfse,               OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tipo",                tt-layout-subst.tipo,                 OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "dtemissaonfse",       tt-layout-subst.dtemissaonfse,        OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "chaveAcesso",         tt-layout-subst.chSubstda,            OUTPUT iId).
    
                       delStack().
                       
                       // Lizi - Layout alterado pelo Neogrid, atendimento conforme issue DMANFATMANUT-18395
                       if  trim(tt-layout-subst.chSubstda) <> "" then do:
                       
                           RUN addNode IN hGenXml (getStack(), "nfsesubstituida", "", OUTPUT iId).
                           addStack(iId).
                           
                               RUN addNode IN hGenXml (getStack(), "chaveacessonfse",          trim(tt-layout-subst.chSubstda),      OUTPUT iId).
                               
                               // novos campos exigidos para substituiá∆o
                               if trim(tt-layout-subst.cMotivo) <> "" then
                               RUN addNode IN hGenXml (getStack(), "codigomotivosubstituicao", trim(tt-layout-subst.cMotivo),        OUTPUT iId).
                               if trim(tt-layout-subst.xMotivo) <> "" then
                               RUN addNode IN hGenXml (getStack(), "motivosubstituicao",       trim(tt-layout-subst.xMotivo),        OUTPUT iId).
                           
                           delStack().
                       end.
    
                  END.
    
                  RUN pi-cancelamento.
    
                  FOR EACH tt-layout-atividade NO-LOCK:
    
                       RUN addNode IN hGenXml (getStack(), "atividade", "", OUTPUT iId).
                       addStack(iId).
    
                            RUN addNode IN hGenXml (getStack(), "codigo",              tt-layout-atividade.codigo,                  OUTPUT iId).
                            {adapters/xml/ep2/axsep022nodedec.i "aliquota"             tt-layout-atividade.aliquota                 "YES" "2" "NO"}
    
                       delStack().
    
                  END.
    
                  FOR FIRST tt-layout-prest NO-LOCK:
    
                       RUN addNode IN hGenXml (getStack(), "prestador", "", OUTPUT iId).
                       addStack(iId).
    
                            RUN addNode IN hGenXml (getStack(), "inscmun",              tt-layout-prest.IM,                      OUTPUT iId). 
                            IF tt-layout-prest.cpf <> ?  THEN                                                                   
                               RUN addNode IN hGenXml (getStack(), "cpfcnpj",           tt-layout-prest.cpf,                     OUTPUT iId).
                            ELSE                                                                                                
                            IF tt-layout-prest.CNPJ <> ? THEN                                                                   
                               RUN addNode IN hGenXml (getStack(), "cpfcnpj",           tt-layout-prest.cnpj,                    OUTPUT iId). 
                            
                            RUN addNode IN hGenXml (getStack(), "razao",                tt-layout-prest.razao,                   OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "fantasia",             tt-layout-prest.fantasia,                OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "codmunibge",           tt-layout-prest.cMun,                    OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "codmunsiafi",          tt-layout-prest.codmunsiafi,             OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cidade",               tt-layout-prest.cidade,                  OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "uf",                   tt-layout-prest.uf,                      OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "email",                tt-layout-prest.email,                   OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "ddd",                  tt-layout-prest.ddd,                     OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "telefone",             tt-layout-prest.telefone,                OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "simpnac",              tt-layout-prest.opsimpnac,               OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "incentcult",           tt-layout-prest.incentcult,              OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "numproc",              tt-layout-prest.numproc,                 OUTPUT iId). //N˙mero do Processo
                            RUN addNode IN hGenXml (getStack(), "logradouro",           tt-layout-prest.xLgr,                    OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "numend",               tt-layout-prest.nro,                     OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "compleend",            tt-layout-prest.xCpl,                    OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "bairro",               tt-layout-prest.xBairro,                 OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tplogradouro",         tt-layout-prest.tplogradouro,            OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tpbairro",             tt-layout-prest.tpbairro,                OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cep",                  tt-layout-prest.cep,                     OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cie",                  tt-layout-prest.cie,                     OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "exigsus",              tt-layout-prest.exigsus,                 OUTPUT iId). //Exigibilidade Suspens„o
    
                       delStack().
    
                  END.
    
                  FOR FIRST tt-layout-locPrest NO-LOCK:
    
                       RUN addNode IN hGenXml (getStack(), "prestacao", "", OUTPUT iId).
                       addStack(iId).
    
                            RUN addNode IN hGenXml (getStack(), "serieprest",           tt-layout-locPrest.serieprest,              OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "logradouro",           tt-layout-locPrest.logradouro,              OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "numend",               tt-layout-locPrest.numend,                  OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "complend",             tt-layout-locPrest.complend,                OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "codmunibge",           tt-layout-locPrest.codmunibge,              OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "codmunincidenciaibge", tt-layout-locPrest.codmunibge,              OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "codmunsiafi",          tt-layout-locPrest.codmunsiafi,             OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "municipio",            tt-layout-locPrest.municipio,               OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "bairro",               tt-layout-locPrest.bairro,                  OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "uf",                   tt-layout-locPrest.uf,                      OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cep",                  tt-layout-locPrest.cep,                     OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "pais",                 tt-layout-locPrest.codpais,                 OUTPUT iId).
                                                                                        
                       delStack().
    
                  END.
    
                  FOR FIRST tt-layout-interm NO-LOCK:
    
                       RUN addNode IN hGenXml (getStack(), "intermediario", "", OUTPUT iId).
                       addStack(iId).
    
                            RUN addNode IN hGenXml (getStack(), "razao",               tt-layout-interm.xNome,                 OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cpfcnpj",             tt-layout-interm.CNPJ ,                 OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "inscmun",             tt-layout-interm.IM,                    OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cnaonif",      STRING(tt-layout-interm.cNaoNIF),               OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "codigomunicipio",     tt-layout-interm.cMun,                  OUTPUT iId).
    
                       delStack().
    
                  END.
    
                  FOR FIRST tt-layout-toma NO-LOCK:
    
                       RUN addNode IN hGenXml (getStack(), "tomador", "", OUTPUT iId).
                       addStack(iId).
    
                            RUN addNode IN hGenXml (getStack(), "inscmun",             tt-layout-toma.im,                        OUTPUT iId).
                            
                            IF tt-layout-toma.cnpj <> ?  THEN 
                               RUN addNode IN hGenXml (getStack(), "cpfcnpj",             tt-layout-toma.cnpj,                   OUTPUT iId).
                               
                            RUN addNode IN hGenXml (getStack(), "razao",               tt-layout-toma.xNome ,                    OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tipologr",            tt-layout-toma.tipologr,                  OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "logradouro",          tt-layout-toma.xLgr  ,                    OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "numend",              tt-layout-toma.nro,                       OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "complend",            tt-layout-toma.xCpl ,                     OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tipobairro",          tt-layout-toma.tipobairro,                OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "bairro",              tt-layout-toma.xBairro,                    OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "codmunibge",          tt-layout-toma.cMun,                      OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "codmunsiafi",         tt-layout-toma.codmunsiafi,               OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cidade",              tt-layout-toma.cidade,                    OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "uf",                  tt-layout-toma.uf,                        OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cep",                 tt-layout-toma.cep,                       OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "email",               tt-layout-toma.email,                     OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "ddd",                 tt-layout-toma.ddd,                       OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "telefone",            tt-layout-toma.telefone,                  OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "codpais",             tt-layout-toma.codpais,                   OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "nomepais",            tt-layout-toma.nomepais,                  OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "estrangeiro",         tt-layout-toma.estrangeiro,               OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "notificatomador",     tt-layout-toma.notificatomador,           OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "csituacaoesptom",     tt-layout-toma.csituacaoesptom,           OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "ctomnaoidentificado", tt-layout-toma.ctomnaoidentificado,       OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "cietom",              tt-layout-toma.inscest,                   OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "niftomador",          tt-layout-toma.nif       ,                OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "passaporte",          tt-layout-toma.passaporte,                OUTPUT iId).
                            
                            IF tt-layout-toma.nomepais <> "Brasil" THEN DO:
                                  
                                RUN addNode IN hGenXml (getStack(), "endExt", "", OUTPUT iId).
                                addStack(iId).                                                                                          
                                RUN addNode IN hGenXml (getStack(), "cPais",      tt-layout-toma.cPais           ,  OUTPUT iId).
                                RUN addNode IN hGenXml (getStack(), "cEndPost",   tt-layout-toma.cEndPost        ,  OUTPUT iId).
                                RUN addNode IN hGenXml (getStack(), "xCidade",    tt-layout-toma.xCidade         ,  OUTPUT iId).
                                RUN addNode IN hGenXml (getStack(), "xEstProvReg",tt-layout-toma.xEstProvReg     ,  OUTPUT iId).
                                                                                                                                              
                                delStack().
                            END.
                            
                       delStack().                                                     
    
                  END.
    
                  RUN addNode IN hGenXml (getStack(), "servicos", "", OUTPUT iId).
                  addStack(iId).
    
                       FOR EACH tt-layout-cserv NO-LOCK:
    
                            RUN addNode IN hGenXml (getStack(), "servico", "", OUTPUT iId).
                            addStack(iId).
    
                                 RUN addNode IN hGenXml (getStack(), "codigo",       tt-layout-cserv.cTribNac ,     OUTPUT iId).
    
                                 {adapters/xml/ep2/axsep022nodedec.i "aliquota"      tt-layout-cserv.aliquota    "YES" "4" "YES"}
    
                                 //RUN addNode IN hGenXml (getStack(), "idcnae",       tt-layout-cserv.idcnae,     OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "cnae",         tt-layout-cserv.cnae,       OUTPUT iId).
    
                                 IF tt-layout-cserv.cTribMun <> "" THEN
                                    RUN addNode IN hGenXml (getStack(), "codtrib",      tt-layout-cserv.cTribMun ,  OUTPUT iId).
                                 
                                 RUN addNode IN hGenXml (getStack(), "discr",        tt-layout-cserv.discr,      OUTPUT iId).
				 
                                 IF tt-layout-cserv.quant = INT(tt-layout-cserv.quant) THEN /* INTEIRO - PARA EVITAR VALORES COMO  1.00 */
                                 	RUN addNode IN hGenXml (getStack(), "quant", string(tt-layout-cserv.quant),     OUTPUT iId).
                                 ELSE /* DECIMAL */
                                    {adapters/xml/ep2/axsep022nodedec.i "quant"         tt-layout-cserv.quant       "YES" "2" "NO"}
                                 
                                 {adapters/xml/ep2/axsep022nodedec.i "valunit"       tt-layout-cserv.valunit     "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "valtotal"      tt-layout-cserv.valtotal    "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "basecalc"      tt-layout-cserv.basecalc    "YES" "2" "NO"}
                                 //RUN addNode IN hGenXml (getStack(), "issretido",    tt-layout-cserv.issretido,  OUTPUT iId).
                                 {adapters/xml/ep2/axsep022nodedec.i "valdedu"       tt-layout-cserv.valdedu     "YES" "2" "NO"}
                                 
                                 IF tt-layout-cserv.descdedu <> ? THEN
                                    RUN addNode IN hGenXml (getStack(), "descdedu",     tt-layout-cserv.descdedu ,  OUTPUT iId).
                                 
                                 {adapters/xml/ep2/axsep022nodedec.i "valpis"        tt-layout-cserv.valpis      "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "valcof"        tt-layout-cserv.valcof      "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "valinss"       tt-layout-cserv.valinss     "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "valir"         tt-layout-cserv.valir       "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "valcsll"       tt-layout-cserv.valcsll     "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "valiss"        tt-layout-cserv.valiss      "YES" "2" "NO"}
                                 
                                 {adapters/xml/ep2/axsep022nodedec.i "vlCOFINSRet"   tt-layout-cserv.vlCOFINSRet "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "vlCSLLRet"     tt-layout-cserv.vlCSLLRet   "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "vlPISRet"      tt-layout-cserv.vlPISRet    "YES" "2" "NO"}
                                 
                                 {adapters/xml/ep2/axsep022nodedec.i "valissret"     tt-layout-cserv.valissret   "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "outrasret"     tt-layout-cserv.outrasret   "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "valliq"        tt-layout-cserv.valliq      "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "desccond"      tt-layout-cserv.desccond    "YES" "2" "NO"}
                                 {adapters/xml/ep2/axsep022nodedec.i "descinc"       tt-layout-cserv.descinc     "YES" "2" "NO"}
                                 RUN addNode IN hGenXml (getStack(), "unidmed",      tt-layout-cserv.unidmed,    OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "tributavel",   tt-layout-cserv.tributavel, OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "cfps",         tt-layout-cserv.cfps,       OUTPUT iId).

                                 FOR FIRST tt-layout-valores NO-LOCK:
                                    RUN addNode IN hGenXml (getStack(), "servicotributavel",      tt-layout-valores.tribISSQN,    OUTPUT iId).
                                 END.
                                
                                 FOR FIRST tt-layout-comext NO-LOCK:
                                  
                                    RUN addNode IN hGenXml (getStack(), "importacaoexportacao", "", OUTPUT iId).
                                    addStack(iId).                                                                                          
                                    RUN addNode IN hGenXml (getStack(), "mdic",                        tt-layout-comext.mdic             ,  OUTPUT iId).                
                                    RUN addNode IN hGenXml (getStack(), "modoprestacao",               tt-layout-comext.mdPrestacao      ,  OUTPUT iId).                   
                                    RUN addNode IN hGenXml (getStack(), "mecadcomexp",          STRING(tt-layout-comext.mecAFComexP,"99"),  OUTPUT iId).               
                                    RUN addNode IN hGenXml (getStack(), "mecafcomext",          STRING(tt-layout-comext.mecAFComexT,"99"),  OUTPUT iId).              
                                    RUN addNode IN hGenXml (getStack(), "movimentacaotemporariabens",  tt-layout-comext.movTempBens      ,  OUTPUT iId).               
                                    RUN addNode IN hGenXml (getStack(), "tipomoeda",                   tt-layout-comext.tpMoeda          ,  OUTPUT iId).                
                                    RUN addNode IN hGenXml (getStack(), "vinculoprestacao",            tt-layout-comext.vincPrest        ,  OUTPUT iId).               
                                    {adapters/xml/ep2/axsep022nodedec.i "valorservicomoeda"            tt-layout-comext.vServMoeda     "YES" "2" "NO"}
                                                                                                                                                   
                                    delStack().
                                 END. 
                            delStack().
    
                       END.
                  delStack().
    
                  FOR EACH tt-layout-valores NO-LOCK:
    
                       RUN addNode IN hGenXml (getStack(), "valores", "", OUTPUT iId).
                       addStack(iId).
    
                            {adapters/xml/ep2/axsep022nodedec.i    "iss"           tt-layout-valores.iss           "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "issret"        tt-layout-valores.issret        "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "outrret"       tt-layout-valores.outrret       "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "pis"           tt-layout-valores.pis           "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "cofins"        tt-layout-valores.cofins        "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "inss"          tt-layout-valores.inss          "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "ir"            tt-layout-valores.vRetIRRF      "YES" "2" "NO"}
                            
                            FOR FIRST tt-layout-cserv NO-LOCK:
                                {adapters/xml/ep2/axsep022nodedec.i    "csll"          tt-layout-cserv.vlCSLLRet       "YES" "2" "NO"} //Apenas o valor do Csll 
                            END.   
                            
                            {adapters/xml/ep2/axsep022nodedec.i    "aliqiss"       tt-layout-valores.aliqiss       "YES" "4" "YES"}
                            {adapters/xml/ep2/axsep022nodedec.i    "aliqpis"       tt-layout-valores.aliqpis       "YES" "4" "YES"}
                            {adapters/xml/ep2/axsep022nodedec.i    "aliqcof"       tt-layout-valores.aliqcof       "YES" "4" "YES"}
                            {adapters/xml/ep2/axsep022nodedec.i    "aliqinss"      tt-layout-valores.aliqinss      "YES" "4" "YES"}
                            {adapters/xml/ep2/axsep022nodedec.i    "aliqir"        tt-layout-valores.aliqir        "YES" "4" "YES"}
                            {adapters/xml/ep2/axsep022nodedec.i    "aliqcsll"      tt-layout-valores.aliqcsll      "YES" "4" "YES"}
                            {adapters/xml/ep2/axsep022nodedec.i    "valtotdoc"     tt-layout-valores.valtotdoc     "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "basecalculo"   tt-layout-valores.basecalculo   "YES" "2" "NO"}
                            
                            FOR FIRST tt-layout-cserv NO-LOCK:
                               {adapters/xml/ep2/axsep022nodedec.i    "vliquinfse"    tt-layout-cserv.valliq    "YES" "2" "NO"}
                            END.   

                            FOR FIRST tt-layout-piscofins NO-LOCK:
                                RUN addNode IN hGenXml (getStack(), "retidopiscofins", STRING(tt-layout-piscofins.tpRetPisCofins), OUTPUT iId).
                                RUN addNode IN hGenXml (getStack(), "CST",                    tt-layout-piscofins.CST,            OUTPUT iId). //ajuste realizado conforme solicitado pela Neogrid a Issue DMANFATMANUT-17847
                            END.
                            {adapters/xml/ep2/axsep022nodedec.i    "basecalculopis"    tt-layout-valores.baspis    "YES" "2" "NO"}  
                            {adapters/xml/ep2/axsep022nodedec.i    "basecalculocofins" tt-layout-valores.bascfis   "YES" "2" "NO"}  
                            {adapters/xml/ep2/axsep022nodedec.i    "vbasecalpiscofins" tt-layout-valores.baspis    "YES" "2" "NO"}  
                            {adapters/xml/ep2/axsep022nodedec.i    "basecalculocsll"   tt-layout-valores.bascsll   "YES" "2" "NO"}  
                            {adapters/xml/ep2/axsep022nodedec.i    "basecalculoirrf"   tt-layout-valores.basir     "YES" "2" "NO"}  
                            {adapters/xml/ep2/axsep022nodedec.i    "basecalculoinss"   tt-layout-valores.basinss   "YES" "2" "NO"}  

                            FOR FIRST tt-layout-cserv NO-LOCK:
                                RUN addNode IN hGenXml (getStack(), "codigonbs",       tt-layout-cserv.cNBS,      OUTPUT iId).
                            END. 
                            
                            {adapters/xml/ep2/axsep022nodedec.i    "valpisret"     tt-layout-valores.pisret    "YES" "2" "NO"}  //NT007
                            {adapters/xml/ep2/axsep022nodedec.i    "valcofinsret"  tt-layout-valores.cofinsret "YES" "2" "NO"}  //NT007
                            {adapters/xml/ep2/axsep022nodedec.i    "valcsllret"    tt-layout-valores.vRetCSLL  "YES" "2" "NO"}  //NT007 Somat¢ria PIS/COFINS e CSLL retido
                            
                            IF  tt-layout-valores.nBM <> ""
                            AND tt-layout-valores.nBM <> ? THEN do:                            
                                RUN addNode IN hGenXml (getStack(), "benmunicipal", "", OUTPUT iId).
                                addStack(iId).                            
                                    RUN addNode IN hGenXml (getStack(), "nbenmunicipal", tt-layout-valores.nBM, OUTPUT iId).                            
                                delStack().                                
                            END.
    
                            {adapters/xml/ep2/axsep022nodedec.i    "valtottributos"    tt-layout-valores.pTotTribSN  "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "vtotaltribfed"     tt-layout-valores.vTotTribFed "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "vtotaltribest"     tt-layout-valores.vTotTribEst "YES" "2" "NO"}
                            {adapters/xml/ep2/axsep022nodedec.i    "vtotaltribmun"     tt-layout-valores.vTotTribMun "YES" "2" "NO"}
                            
                            RUN addNode IN hGenXml (getStack(), "timuni", tt-layout-valores.tpImunidade, OUTPUT iId).
                           
                       delStack().
    
                  END.
    
                  RUN addNode IN hGenXml (getStack(), "faturas", "", OUTPUT iId).
                  addStack(iId).
    
                       FOR EACH tt-layout-fatura NO-LOCK:
    
                            RUN addNode IN hGenXml (getStack(), "fatura", "", OUTPUT iId).
                            addStack(iId).
    
                                 RUN addNode IN hGenXml (getStack(), "numero", tt-layout-fatura.numero, OUTPUT iId).
                                 {adapters/xml/ep2/axsep022nodedec.i "valor"   tt-layout-fatura.valor   "YES" "2" "NO"}
                            delStack().
    
                       END.
    
                  delStack().
    
                  RUN addNode IN hGenXml (getStack(), "pagamentos", "", OUTPUT iId).
                  addStack(iId).
    
                       FOR EACH tt-layout-pagamento NO-LOCK:
    
                            RUN addNode IN hGenXml (getStack(), "pagamento", "", OUTPUT iId).
                            addStack(iId).
    
                                 IF tt-layout-pagamento.meiopagto <> ? THEN
                                    RUN addNode IN hGenXml (getStack(), "meiopagto", tt-layout-pagamento.meiopagto, OUTPUT iId). 
                                 
                                 RUN addNode IN hGenXml (getStack(), "parcela", tt-layout-pagamento.parcela, OUTPUT iId).
                                 RUN addNode IN hGenXml (getStack(), "dtvenc",  tt-layout-pagamento.dtvenc,  OUTPUT iId).
                                 {adapters/xml/ep2/axsep022nodedec.i "valor"    tt-layout-pagamento.valor    "YES" "2" "NO"}
                            delStack().
    
                       END.
    
                  delStack().

                  IF CAN-FIND(tt-layout-deducoes )  
                  OR  CAN-FIND (FIRST tt-layout-deducao) THEN DO:
                  
                      FOR EACH tt-layout-deducoes NO-LOCK:
                      
                          RUN addNode IN hGenXml (getStack(), "deducoes", "", OUTPUT iId).
                          addStack(iId).
            
                              {adapters/xml/ep2/axsep022nodedec.i  "desccond"    tt-layout-deducoes.desccond    "YES" "2" "NO"}
                              {adapters/xml/ep2/axsep022nodedec.i  "descincond"  tt-layout-deducoes.descincond  "YES" "2" "NO"}
            
                              FOR EACH tt-layout-deducao NO-LOCK:
            
                                    RUN addNode IN hGenXml (getStack(), "deducao", "", OUTPUT iId).
                                    addStack(iId).
            
                                        RUN addNode IN hGenXml (getStack(), "tipo",                 tt-layout-deducao.tipo,                 OUTPUT iId).
                                        RUN addNode IN hGenXml (getStack(), "modal",                tt-layout-deducao.modal,                OUTPUT iId).
                                        RUN addNode IN hGenXml (getStack(), "codobra",              tt-layout-deducao.codobra,              OUTPUT iId).
                                        RUN addNode IN hGenXml (getStack(), "codart",               tt-layout-deducao.codart,               OUTPUT iId).
                                        RUN addNode IN hGenXml (getStack(), "cpfcnpj",              tt-layout-deducao.cpfcnpj,              OUTPUT iId).
                                        RUN addNode IN hGenXml (getStack(), "numeronf",             tt-layout-deducao.numeronf,             OUTPUT iId).
                                        {adapters/xml/ep2/axsep022nodedec.i "totalnf"               tt-layout-deducao.totalnf               "YES" "2" "NO"}
                                        {adapters/xml/ep2/axsep022nodedec.i "percentual"            tt-layout-deducao.percentual            "YES" "2" "NO"}
                                        {adapters/xml/ep2/axsep022nodedec.i "valor"                 tt-layout-deducao.valor                 "YES" "2" "NO"}
                                        /* RUN addNode IN hGenXml (getStack(), "descricaomaterial",    tt-layout-deducao.descricaomaterial,    OUTPUT iId).
                                        {adapters/xml/ep2/axsep022nodedec.i "valorunitariomaterial" tt-layout-deducao.valorunitariomaterial "YES" "2" "NO"}
                                        RUN addNode IN hGenXml (getStack(), "quantidadematerial",   tt-layout-deducao.quantidadematerial,   OUTPUT iId).*/
    
                                    delStack().
            
                              END.
                          delStack().
                      END.    
                  END.
    
                  FOR EACH tt-layout-infocompl NO-LOCK:  
                
                      RUN addNode IN hGenXml (getStack(), "infcompl", "", OUTPUT iId).
                      addStack(iId).
        
                           RUN addNode IN hGenXml (getStack(), "descricao",  tt-layout-infocompl.descricao,  OUTPUT iId).
                           RUN addNode IN hGenXml (getStack(), "observacao", tt-layout-infocompl.xInfComp, OUTPUT iId).
        
                      delStack().
                  END. 
    
                  FOR EACH tt-layout-obra NO-LOCK:
    
                       RUN addNode IN hGenXml (getStack(), "construcao", "", OUTPUT iId).
                       addStack(iId).
    
                            RUN addNode IN hGenXml (getStack(), "codigoobra", tt-layout-obra.cObra     , OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "art",        tt-layout-obra.art,        OUTPUT iId).
                            RUN addNode IN hGenXml (getStack(), "tipoobra",   tt-layout-obra.tipoobra,   OUTPUT iId).
    
                       delStack().
    
                 END.
                             
                 IF CAN-FIND(FIRST tt-layout-IBSCBS ) THEN DO:
                 
                    RUN addNode IN hGenXml (getStack(), "IBSCBS", "", OUTPUT iId).
                    addStack(iId).
                      RUN addNode IN hGenXml (getStack(), "finNFSe",   tt-layout-inf.finalidadeNfse,         OUTPUT iId).
                          RUN addNode IN hGenXml (getStack(), "indFinal",  tt-layout-inf.indicadorFinal,         OUTPUT iId).
                      RUN addNode IN hGenXml (getStack(), "cIndOp",    tt-layout-inf.cIndicadorOperacao,     OUTPUT iId).
                      
                      IF tt-layout-inf.tpoper <> "" AND tt-layout-inf.tpoper <> ? THEN
                         RUN addNode IN hGenXml (getStack(), "tpOper",    tt-layout-inf.tpoper,                 OUTPUT iId).
                      
                      FOR FIRST tt-layout-refnfse NO-LOCK :
                         RUN addNode IN hGenXml (getStack(), "gRefNFSe", "", OUTPUT iId).
                         addStack(iId).
                            RUN addNode IN hGenXml (getStack(), "refNFSe", tt-layout-refnfse.refNFSe,     OUTPUT iId).
                         delStack().   
                      END.        
                     
                      IF tt-layout-inf.tipoEnteGovernamental <> "" AND tt-layout-inf.tipoEnteGovernamental <> ? THEN
                          RUN addNode IN hGenXml (getStack(), "tpEnteGov", tt-layout-inf.tipoEnteGovernamental, OUTPUT iId).
                            
                      RUN addNode IN hGenXml (getStack(), "indDest", tt-layout-inf.indicadorDestinatario, OUTPUT iId).
                    
                      /* Destinat·rio NFS-e */
                      FOR FIRST tt-layout-IBSCBS-dest NO-LOCK:
        
                          RUN addNode IN hGenXml (getStack(), "dest", "", OUTPUT iId).
                          addStack(iId).
        
                              IF  tt-layout-IBSCBS-dest.NIF <> ?
                              AND tt-layout-IBSCBS-dest.NIF <> "" THEN
                                  RUN addNode IN hGenXml (getStack(), "NIF",  tt-layout-IBSCBS-dest.NIF, OUTPUT iId).
                              ELSE                           
                                 IF  tt-layout-IBSCBS-dest.cpf <> ?
                                 AND tt-layout-IBSCBS-dest.cpf <> "" THEN 
                                     RUN addNode IN hGenXml (getStack(), "CPF", tt-layout-IBSCBS-dest.cpf, OUTPUT iId).
                                 ELSE                                                                                                
                                     IF  tt-layout-IBSCBS-dest.CNPJ <> ? THEN                                                                   
                                         RUN addNode IN hGenXml (getStack(), "CNPJ", tt-layout-IBSCBS-dest.cnpj, OUTPUT iId). 
                               
                               IF  tt-layout-IBSCBS-dest.xNome <> ? THEN
                                   RUN addNode IN hGenXml (getStack(), "xNome", tt-layout-IBSCBS-dest.xNome, OUTPUT iId).
                                   
                               RUN addNode IN hGenXml (getStack(), "end", "", OUTPUT iId).
                               addStack(iId).     
                               
                                   IF  tt-layout-IBSCBS-dest.cEndPost <> ? and tt-layout-IBSCBS-dest.cEndPost <> "" THEN
                                   DO:
                                       RUN addNode IN hGenXml (getStack(), "endExt", "", OUTPUT iId).
                                       addStack(iId).                                                                              
                                         RUN addNode IN hGenXml (getStack(), "cPais",       tt-layout-IBSCBS-dest.cPais,       OUTPUT iId).
                                         RUN addNode IN hGenXml (getStack(), "cEndPost",    tt-layout-IBSCBS-dest.cEndPost,    OUTPUT iId).
                                         RUN addNode IN hGenXml (getStack(), "xCidade",     tt-layout-IBSCBS-dest.xCidade,     OUTPUT iId).
                                         RUN addNode IN hGenXml (getStack(), "xEstProvReg", tt-layout-IBSCBS-dest.xEstProvReg, OUTPUT iId).
                                       delStack().                                           
                                   END.
                                   ELSE DO:
                                       RUN addNode IN hGenXml (getStack(), "endNac", "", OUTPUT iId).
                                       addStack(iId).                                                                                                                 
                                         RUN addNode IN hGenXml (getStack(), "cMun", tt-layout-IBSCBS-dest.cMun, OUTPUT iId).
                                         RUN addNode IN hGenXml (getStack(), "CEP",  tt-layout-IBSCBS-dest.CEP,  OUTPUT iId).
                                       delStack().    
                                   END.          

                                   RUN addNode IN hGenXml (getStack(), "xLgr", tt-layout-IBSCBS-dest.xLgr, OUTPUT iId).
                                   RUN addNode IN hGenXml (getStack(), "nro",  tt-layout-IBSCBS-dest.nro,  OUTPUT iId).
                                
                                   IF  tt-layout-IBSCBS-dest.xCpl <> ? 
                                   AND tt-layout-IBSCBS-dest.xCpl <> "" THEN 
                                       RUN addNode IN hGenXml (getStack(), "xCpl", tt-layout-IBSCBS-dest.xCpl, OUTPUT iId).
                                       
                                   RUN addNode IN hGenXml (getStack(), "xBairro",  tt-layout-IBSCBS-dest.xBairro, OUTPUT iId).                                      
                                   
                               delStack().     
                               IF  tt-layout-IBSCBS-dest.fone <> ? 
                               AND tt-layout-IBSCBS-dest.fone <> "" THEN
                                   RUN addNode IN hGenXml (getStack(), "fone", tt-layout-IBSCBS-dest.fone, OUTPUT iId).

                               IF  tt-layout-IBSCBS-dest.email <> ? 
                               AND tt-layout-IBSCBS-dest.email <> "" THEN
                                   RUN addNode IN hGenXml (getStack(), "email", tt-layout-IBSCBS-dest.email, OUTPUT iId).                              
                               
                          delStack().
        
                      END.    
                      
                      FOR EACH tt-layout-imovel NO-LOCK:
    
                          RUN addNode IN hGenXml (getStack(), "imovel", "", OUTPUT iId).
                          addStack(iId).
        
                               RUN addNode IN hGenXml (getStack(), "inscImobFisc", tt-layout-imovel.inscImobFisc, OUTPUT iId).
                               
                               if  tt-layout-imovel.cCIB <> ? and tt-layout-imovel.cCIB <> "" then do:
                               RUN addNode IN hGenXml (getStack(), "cCIB",         tt-layout-imovel.cCIB,         OUTPUT iId).
                                
                               end.
                               
                               else do:
                                   RUN addNode IN hGenXml (getStack(), "end", "", OUTPUT iId).
                                   addStack(iId).
                                   
                                      IF  tt-layout-imovel.cEndPost <> ? and tt-layout-imovel.cEndPost <> "" THEN DO:
                                          RUN addNode IN hGenXml (getStack(), "endExt", "", OUTPUT iId).
                                          
                                          addStack(iId).  
                                          
                                               RUN addNode IN hGenXml (getStack(), "cEndPost",    tt-layout-imovel.cEndPost,    OUTPUT iId).
                                               RUN addNode IN hGenXml (getStack(), "xCidade",     tt-layout-imovel.xCidade,     OUTPUT iId).
                                               RUN addNode IN hGenXml (getStack(), "xEstProvReg", tt-layout-imovel.xEstProvReg, OUTPUT iId).
                                                
                                           delStack().    
                                         
                                      END.
                                      else do:
                                           RUN addNode IN hGenXml (getStack(), "CEP", tt-layout-imovel.cep, OUTPUT iId).
                                      end.
                                      
                                      RUN addNode IN hGenXml (getStack(), "xLgr",    tt-layout-imovel.logradouro,  OUTPUT iId).
                                      RUN addNode IN hGenXml (getStack(), "nro",     tt-layout-imovel.numend,      OUTPUT iId).
                                      if tt-layout-imovel.complend <> ? and tt-layout-imovel.complend <> "" then RUN addNode IN hGenXml (getStack(), "xCpl",    tt-layout-imovel.complend,    OUTPUT iId).
                                      RUN addNode IN hGenXml (getStack(), "xBairro", tt-layout-imovel.bairro,      OUTPUT iId).                                       
                                       
                                   delStack().
                               end.
                          delStack().                                                                 
                                                                                                       
                      END.
 
                      RUN addNode IN hGenXml (getStack(), "valores", "", OUTPUT iId).
                      addStack(iId).
                         
                          RUN addNode IN hGenXml (getStack(), "trib", "", OUTPUT iId).
                          addStack(iId).

                            FOR EACH tt-layout-ibscbs NO-LOCK 
                               BREAK BY tt-layout-IBSCBS.cTribNac:
                               
                               IF FIRST-OF (tt-layout-IBSCBS.cTribNac) 
                               THEN DO:
 
                                  RUN addNode IN hGenXml (getStack(), "gIBSCBS", "", OUTPUT iId).
                                  addStack(iId). 
            
                                    RUN addNode IN hGenXml (getStack(), "CST"         , tt-layout-ibscbs.cod-cst,        OUTPUT iId).
                                    RUN addNode IN hGenXml (getStack(), "cClassTrib"  , tt-layout-ibscbs.cod-class-trib, OUTPUT iId).
                             
                                    IF tt-layout-ibscbs.cod-clas-cred-presum-ibs <> "" THEN
                                      RUN addNode IN hGenXml (getStack(), "cCredPresIBS", tt-layout-ibscbs.cod-clas-cred-presum-ibs   , OUTPUT iId).
                                    
                                    IF tt-layout-ibscbs.cod-cst-regul <> "" THEN DO:
                                        RUN addNode IN hGenXml (getStack(), "gTribRegular", ""  , OUTPUT iId).
                                        addStack(iId). 
                                               RUN addNode IN hGenXml (getStack(), "CSTReg", tt-layout-ibscbs.cod-cst-regul,               OUTPUT iId).
                                               RUN addNode IN hGenXml (getStack(), "cClassTribReg", tt-layout-ibscbs.cod-class-trib-regul, OUTPUT iId).
                                        delStack().
                                    END.
                                    
                                    IF tt-layout-ibscbs.perc-difer-ibs-uf  > 0 OR 
                                       tt-layout-ibscbs.perc-difer-ibs-mun > 0 OR 
                                       tt-layout-ibscbs.perc-difer-cbs     > 0 THEN
                                    DO:
                                         RUN addNode IN hGenXml (getStack(), "gDif", "" , OUTPUT iId).
                                         addStack(iId). 
                                           {adapters/xml/ep2/axsep022nodedec.i "pDifUF"   tt-layout-ibscbs.perc-difer-ibs-uf          "YES" "2" "NO"}
                                           {adapters/xml/ep2/axsep022nodedec.i "pDifMun"  tt-layout-ibscbs.perc-difer-ibs-mun         "YES" "2" "NO"}
                                           {adapters/xml/ep2/axsep022nodedec.i "pDifCBS"  tt-layout-ibscbs.perc-difer-cbs             "YES" "2" "NO"}
                                         delStack().
                                    END. 
                                  
                                  delStack().   
                               
                               END.     
                           
                            END.  //for each
                               
                          delStack().
                                    
                      delStack().
                      
                   delStack().                 
                                    
                   RUN addNode IN hGenXml (getStack(), "OutrasInformacoesIBSCBS", "", OUTPUT iId).
                   addStack(iId).       
                   
                        FOR LAST tt-layout-IBSCBS NO-LOCK:
                          {adapters/xml/ep2/axsep022nodedec.i "pRedutor"    tt-layout-IBSCBS.perc-redutor             "YES" "2" "NO"}
                            
                            RUN addNode IN hGenXml (getStack(), "valores", "", OUTPUT iId).
                            addStack(iId).
                            
                                {adapters/xml/ep2/axsep022nodedec.i "vBC"          tt-layout-IBSCBS.vl-base-ibscbs       "YES" "2" "NO"}
                                
                                RUN addNode IN hGenXml (getStack(), "uf", "", OUTPUT iId).
                                addStack(iId).
                        
                                    {adapters/xml/ep2/axsep022nodedec.i "pIBSUF"         tt-layout-IBSCBS.aliq-ibs-uf              "YES" "2" "NO"}   
                                    {adapters/xml/ep2/axsep022nodedec.i "pRedAliqUF"     tt-layout-IBSCBS.perc-red-aliq-ibs-uf      "YES" "2" "NO"}
                                    {adapters/xml/ep2/axsep022nodedec.i "pAliqEfetUF"    tt-layout-IBSCBS.aliq-efetiva-ibs-uf       "YES" "2" "NO"}
                                delStack().
                                
                                RUN addNode IN hGenXml (getStack(), "mun", "", OUTPUT iId).
                                addStack(iId).
                        
                                    {adapters/xml/ep2/axsep022nodedec.i "pIBSMun"         tt-layout-IBSCBS.aliq-ibs-mun              "YES" "2" "NO"}   
                                    {adapters/xml/ep2/axsep022nodedec.i "pRedAliqMun"     tt-layout-IBSCBS.perc-red-aliq-ibs-mun      "YES" "2" "NO"}
                                    {adapters/xml/ep2/axsep022nodedec.i "pAliqEfetMun"    tt-layout-IBSCBS.aliq-efetiva-ibs-mun       "YES" "2" "NO"}
                                
                                 delStack().
                                 
                                 RUN addNode IN hGenXml (getStack(), "fed", "", OUTPUT iId).
                                 addStack(iId).
                        
                                    {adapters/xml/ep2/axsep022nodedec.i "pCBS"         tt-layout-IBSCBS.aliq-cbs                     "YES" "2" "NO"}   
                                    {adapters/xml/ep2/axsep022nodedec.i "pRedAliqCBS"     tt-layout-IBSCBS.perc-red-aliq-cbs         "YES" "2" "NO"}
                                    {adapters/xml/ep2/axsep022nodedec.i "pAliqEfetCBS"    tt-layout-IBSCBS.aliq-efetiva-cbs          "YES" "2" "NO"}
                                
                                 delStack(). 
                              
                              delStack().
                              
                              
                              RUN addNode IN hGenXml (getStack(), "totCIBS", "", OUTPUT iId).
                              addStack(iId).
                                 {adapters/xml/ep2/axsep022nodedec.i "vTotNF" tt-layout-IBSCBS.valorTotalNotaFiscal "YES" "2" "NO"}
                                 
                                 IF tt-layout-IBSCBS.cod-class-trib-regul <> "" AND tt-layout-IBSCBS.cod-class-trib-regul <> ? THEN DO:
                                     RUN addNode IN hGenXml (getStack(), "gTribRegular", "", OUTPUT iId).
                                     addStack(iId).
                                        {adapters/xml/ep2/axsep022nodedec.i "pAliqEfeRegIBSUF"      tt-layout-IBSCBS.aliq-efetiva-reg-ibs-uf  "YES" "2" "NO"}
                                        {adapters/xml/ep2/axsep022nodedec.i "vTribRegIBSUF"         tt-layout-IBSCBS.vl-ibs-uf-reg            "YES" "2" "NO"}
                                        {adapters/xml/ep2/axsep022nodedec.i "pAliqEfeRegIBSMun"     tt-layout-IBSCBS.aliq-efetiva-reg-ibs-mun  "YES" "2" "NO"}
                                        {adapters/xml/ep2/axsep022nodedec.i "vTribRegIBSMun"        tt-layout-IBSCBS.vl-ibs-mun-reg            "YES" "2" "NO"}
                                        {adapters/xml/ep2/axsep022nodedec.i "pAliqEfeRegCBS"        tt-layout-IBSCBS.aliq-efetiva-reg-cbs      "YES" "2" "NO"}
                                        {adapters/xml/ep2/axsep022nodedec.i "vTribRegCBS"           tt-layout-IBSCBS.vl-cbs-reg                "YES" "2" "NO"}
                                     delStack().  
                                  END.
                                  
                                  /*   FALTA DESENVOLVER NFE
                                   RUN addNode IN hGenXml (getStack(), "gTribCompraGov", "", OUTPUT iId).
                                     addStack(iId).
                                  
                                  */
                                 
                                  RUN addNode IN hGenXml (getStack(), "gIBS", "", OUTPUT iId).
                                  addStack(iId).
                                       {adapters/xml/ep2/axsep022nodedec.i "vIBSTot"                   tt-layout-IBSCBS.vl-ibs                "YES" "2" "NO"}
                                       
                                       RUN addNode IN hGenXml (getStack(), "gIBSCredPres", "", OUTPUT iId).
                                       addStack(iId).
                                           {adapters/xml/ep2/axsep022nodedec.i "pCredPresIBS"          tt-layout-IBSCBS.perc-credpres-ibs         "YES" "2" "NO"}
                                           {adapters/xml/ep2/axsep022nodedec.i "vCredPresIBS"          tt-layout-IBSCBS.vl-credpres-ibs       "YES" "2" "NO"}
                                       delStack().   
                                       
                                       RUN addNode IN hGenXml (getStack(), "gIBSUFTot", "", OUTPUT iId).
                                       addStack(iId).
                                           {adapters/xml/ep2/axsep022nodedec.i "vDifUF"          tt-layout-IBSCBS.perc-difer-ibs-uf          "YES" "2" "NO"}
                                           {adapters/xml/ep2/axsep022nodedec.i "vIBSUF"          tt-layout-IBSCBS.vl-ibs-uf              "YES" "2" "NO"}
                                       delStack(). 
                                       
                                       RUN addNode IN hGenXml (getStack(), "gIBSMunTot", "", OUTPUT iId).
                                       addStack(iId).
                                           {adapters/xml/ep2/axsep022nodedec.i "vDifCBS"          tt-layout-IBSCBS.perc-difer-ibs-mun          "YES" "2" "NO"}
                                           {adapters/xml/ep2/axsep022nodedec.i "vIBSMun"          tt-layout-IBSCBS.vl-ibs-mun              "YES" "2" "NO"}
                                       delStack(). 
                                       
                                  delStack().   
                                  
                                  RUN addNode IN hGenXml (getStack(), "gCBS", "", OUTPUT iId).
                                  addStack(iId).
                                       {adapters/xml/ep2/axsep022nodedec.i "vDifCBS"          tt-layout-IBSCBS.perc-difer-cbs          "YES" "2" "NO"}
                                       {adapters/xml/ep2/axsep022nodedec.i "vCBS"             tt-layout-IBSCBS.vl-cbs              "YES" "2" "NO"}
                                                                                
                                       RUN addNode IN hGenXml (getStack(), "gCBSCredPres", "", OUTPUT iId).
                                       addStack(iId).
                                           {adapters/xml/ep2/axsep022nodedec.i "pCredPresCBS"          tt-layout-IBSCBS.perc-credpres-cbs         "YES" "2" "NO"}
                                           {adapters/xml/ep2/axsep022nodedec.i "vCredPresCBS"          tt-layout-IBSCBS.vl-credpres-cbs       "YES" "2" "NO"}
                                       delStack().   
                                        
                                  delStack().        
                                  
                              delStack().   
                              
                        END.       
                                
                   delStack(). /* Fim outrasinformacoesIBSCBS */
                     
                 END. //IF CAN-FIND(FIRST tt-layout-IBSCBS ) 
                 
              delStack().    
    
        END.   //FOR EACH TT-LAYOUT 
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

    IF CAN-FIND(FIRST tt-cancelamento) THEN DO:
        FOR EACH tt-cancelamento NO-LOCK:
        
             RUN addNode IN hGenXml (getStack(), "cancelamento", "", OUTPUT iId).
             addStack(iId).
        
                  RUN addNode IN hGenXml (getStack(), "cpfcnpj",             tt-cancelamento.cpfcnpj,              OUTPUT iId).
                  RUN addNode IN hGenXml (getStack(), "numeronfse",          tt-cancelamento.numeronfse,           OUTPUT iId).
                  RUN addNode IN hGenXml (getStack(), "codmunibge",          tt-cancelamento.codmunibge,           OUTPUT iId).
                  RUN addNode IN hGenXml (getStack(), "motcanc",             tt-cancelamento.motcanc,              OUTPUT iId).
                  RUN addNode IN hGenXml (getStack(), "codmotcanc",          tt-cancelamento.codmotcanc,           OUTPUT iId).
                  RUN addNode IN hGenXml (getStack(), "inmunprest",          tt-cancelamento.inmunprest,           OUTPUT iId).
        
             delStack().
        
        END.
        
    END.
    ELSE 
    IF CAN-FIND(FIRST tt-layout-cancelamento) THEN  
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
