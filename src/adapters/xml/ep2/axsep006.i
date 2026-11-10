/*----------------------------------------------------------------------------------

    DEFINI€åES TEMP-TABLE

----------------------------------------------------------------------------------*/

DEFINE TEMP-TABLE ttAdi NO-UNDO
     FIELD cFabricante    AS CHARACTER INITIAL ?                                         /*C¢digo do fabricante estrangeiro (usado nos sistemas internos de informa‡Æo do emitente da NF-e)*/
     FIELD nAdicao        AS CHARACTER INITIAL ?                                         /*N£mero da Adi‡Æo*/
     FIELD nSeqAdic       AS CHARACTER INITIAL ?                                         /*N£mero seqencial do item dentro da Adi‡Æo*/
     FIELD vDescDI        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do desconto do item da DI - adi‡Æo*/ 
     FIELD nDI            AS CHARACTER INITIAL ?                                         /*campo para liga‡Æo com a ttDI*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttDI CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF nDI
.


DEFINE TEMP-TABLE ttArma NO-UNDO
     FIELD descr          AS CHARACTER INITIAL ?                                         /*Descri‡Æo completa da arma, compreendendo: calibre, marca, capacidade, tipo de funcionamento, comprimento e demais elementos que permitam a sua perfeita identifica‡Æo.*/
     FIELD nCano          AS CHARACTER INITIAL ?                                         /*N£mero de s‚rie do cano*/
     FIELD nSerie         AS CHARACTER INITIAL ?                                         /*N£mero de s‚rie da arma*/
     FIELD tpArma         AS CHARACTER INITIAL ?                                         /*Indicador do tipo de arma de fogo (0 - Uso permitido; 1 - Uso restrito)*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttArma CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttAvulsa NO-UNDO
     FIELD CNPJ           AS CHARACTER INITIAL ?                                         /*CNPJ do ¢rgÆo emissor*/
     FIELD dEmi           AS DATE      INITIAL ?                                         /*Data de emissÆo do DAR (AAAA-MM-DD)*/
     FIELD dPag           AS DATE      INITIAL ?                                         /*Data de pagamento do DAR (AAAA-MM-DD)*/
     FIELD fone           AS CHARACTER INITIAL ?                                         /*Telefone*/
     FIELD matr           AS CHARACTER INITIAL ?                                         /*Matr¡cula do agente*/
     FIELD nDAR           AS CHARACTER INITIAL ?                                         /*N£mero do Documento de Arrecada‡Æo de Receita*/
     FIELD repEmi         AS CHARACTER INITIAL ?                                         /*Reparti‡Æo Fiscal emitente*/
     FIELD UF             AS CHARACTER INITIAL ?                                         /*Sigla da Unidade da Federa‡Æo*/
     FIELD vDAR           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total constante no DAR*/ 
     FIELD xAgente        AS CHARACTER INITIAL ?                                         /*Nome do agente*/
     FIELD xOrgao         AS CHARACTER INITIAL ?                                         /*¢rgÆo emitente*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttAvulsa CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttCobr NO-UNDO
     FIELD nFat           AS CHARACTER INITIAL ?                                         /*N£mero da fatura*/
     FIELD vDesc          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do desconto da fatura*/ 
     FIELD vLiq           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor l¡quido da fatura*/     
     FIELD vOrig          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor original da fatura*/    
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttCobr CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttCOFINSAliq NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situa‡Æo Tribut ria do COFINS. 01 Opera‡Æo Tribut vel - Base de C lculo = Valor da Opera‡Æo Al¡quota Normal (Cumulativo/NÆo Cumulativo); 02 - Opera‡Æo Tribut vel - Base de Calculo = Valor da Opera‡Æo (Al¡quota Diferenciada) */
     FIELD pCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al¡quota do COFINS (em percentual)*/ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do COFINS*/              
     FIELD vCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do COFINS*/                    
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttCOFINSAliq CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttCOFINSNT NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situa‡Æo Tribut ria do COFINS: 04 - Opera‡Æo Tribut vel - Tributa‡Æo Monof sica - (Al¡quota Zero); 06 - Opera‡Æo Tribut vel - Al¡quota Zero; 07 - Opera‡Æo Isenta da contribui‡Æo; 08 - Opera‡Æo Sem Incidˆncia da contribui‡Æo; 09 - Opera‡Æo com suspensÆo da contribui‡Æo */
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttCOFINSNT CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttCOFINSOutr NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situa‡Æo Tribut ria do COFINS: 99 - Outras Opera‡äes.*/
     FIELD pCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>9.99"            DECIMALS 2  /*Al¡quota do COFINS (em percentual)*/ 
     FIELD qBCProd        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.9999" DECIMALS 4  /*Quantidade Vendida */                
     FIELD vAliqProd      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>9.9999"  DECIMALS 4  /*Al¡quota do COFINS (em reais)*/      
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor da BC do COFINS*/              
     FIELD vCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor do COFINS*/                    
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttCOFINSOutr CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttCOFINSQtde NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situa‡Æo Tribut ria do COFINS. 03 - Opera‡Æo Tribut vel - Base de Calculo = Quantidade Vendida x Al¡quota por Unidade de Produto */
     FIELD qBCProd        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.9999" DECIMALS 4  /*Quantidade Vendida */           
     FIELD vAliqProd      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>9.9999"  DECIMALS 4  /*Al¡quota do COFINS (em reais)*/ 
     FIELD vCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor do COFINS*/               
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttCOFINSQtde CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttCOFINSST NO-UNDO
     FIELD pCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>9.99"            DECIMALS 2  /*Al¡quota do COFINS ST(em percentual)*/ 
     FIELD qBCProd        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.9999" DECIMALS 4  /*Quantidade Vendida */                  
     FIELD vAliqProd      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>9.9999"  DECIMALS 4  /*Al¡quota do COFINS ST(em reais)*/      
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor da BC do COFINS ST*/             
     FIELD vCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor do COFINS ST*/                   
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttCOFINSST CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttComb NO-UNDO
     FIELD CODIF          AS CHARACTER INITIAL ?                                         /*C¢digo de autoriza‡Æo / registro do CODIF. Informar apenas quando a UF utilizar o CODIF (Sistema de Controle do Diferimento do Imposto nas Opera‡äes com AEAC - µlcool Et¡lico Anidro Combust¡vel).*/
     FIELD cProdANP       AS CHARACTER INITIAL ?                                         /*C¢digo de produto da ANP Informar apenas quando se tratar de produtos regulados pela ANP - Agˆncia Nacional do Petr¢leo. Utilizar a codifica‡Æo de produtos do Sistema de Informa‡äes de Movimenta‡Æo de produtos - SIMP (http://www.anp.gov.br/simp/index.htm)*/
     FIELD qBCProd        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.9999"  DECIMALS 4 /*BC do CIDE ( Quantidade comercializada) */  
     FIELD qTemp          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.9999"  DECIMALS 4 /*Quantidade de combust¡vel faturada - temperatura ambiente. Informar quando a quantidade faturada informada no campo qCom (I10) tiver sido ajustada para uma temperatura diferente da ambiente.*/ 
     FIELD UFCons         AS CHARACTER INITIAL ?                                         /*Sigla da UF Dest*/
     FIELD vAliqProd      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>9.9999"   DECIMALS 4 /*Al¡quota do CIDE  (em reais)*/ 
     FIELD vBCICMS        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"   DECIMALS 2 /*BC do ICMS pr¢prio*/ 
     FIELD vBCICMSST      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"   DECIMALS 2 /*BC do ICMS ST*/ 
     FIELD vBCICMSSTCons  AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"   DECIMALS 2 /*BC do ICMS ST da UF de consumo*/ 
     FIELD vBCICMSSTDest  AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"   DECIMALS 2 /*BC do ICMS ST da UF de destino*/ 
     FIELD vCIDE          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.9999" DECIMALS 4 /*Valor do CIDE*/ 
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"   DECIMALS 2 /*Valor do ICMS pr¢prio*/ 
     FIELD vICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"   DECIMALS 2 /*Valor do ICMS ST*/ 
     FIELD vICMSSTCons    AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"   DECIMALS 2 /*Valor do ICMSST da UF de consumo*/ 
     FIELD vICMSSTDest    AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"   DECIMALS 2 /*Valor do ICMS da UF de destino.*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttComb CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttCompra NO-UNDO
     FIELD xCont          AS CHARACTER INITIAL ?                                         /*Informa‡Æo do contrato*/
     FIELD xNEmp          AS CHARACTER INITIAL ?                                         /*Informa‡Æo da Nota de Empenho de compras p£blicas*/
     FIELD xPed           AS CHARACTER INITIAL ?                                         /*Informa‡Æo do pedido*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttCompra IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttDest NO-UNDO
     FIELD CEP            AS CHARACTER INITIAL ?                                         /*CEP*/
     FIELD cMun           AS CHARACTER INITIAL ?                                         /*C¢digo do munic¡pio (utilizar a tabela do IBGE), informar 9999999 para opera‡äes com o exterior.*/
     FIELD CNPJ           AS CHARACTER INITIAL ?                                         /*N£mero do CNPJ*/
     FIELD cPais          AS CHARACTER INITIAL ?                                         /*C¢digo do pa¡s*/
     FIELD CPF            AS CHARACTER INITIAL ?                                         /*N£mero do CPF*/
     FIELD fone           AS CHARACTER INITIAL ?                                         /*Telefone*/
     FIELD IE             AS CHARACTER INITIAL ?                                         /*Inscri‡Æo Estadual (obrigat¢rio nas opera‡äes com contribuintes do ICMS)*/
     FIELD ISUF           AS CHARACTER INITIAL ?                                         /*Inscri‡Æo na SUFRAMA (Obrigat¢rio nas opera‡äes com as  reas com benef¡cios de incentivos fiscais sob controle da SUFRAMA)*/
     FIELD nro            AS CHARACTER INITIAL ?                                         /*N£mero*/
     FIELD UF             AS CHARACTER INITIAL ?                                         /*Sigla da UF, , informar EX para opera‡äes com o exterior.*/
     FIELD xBairro        AS CHARACTER INITIAL ?                                         /*Bairro*/
     FIELD xCpl           AS CHARACTER INITIAL ?                                         /*Complemento*/
     FIELD xLgr           AS CHARACTER INITIAL ?                                         /*Logradouro*/
     FIELD xMun           AS CHARACTER INITIAL ?                                         /*Nome do munic¡pio, , informar EXTERIOR para opera‡äes com o exterior.*/
     FIELD xNome          AS CHARACTER INITIAL ?                                         /*RazÆo Social ou nome do destinat rio*/
     FIELD xPais          AS CHARACTER INITIAL ?                                         /*Nome do pa¡s*/
     FIELD i-natureza     AS INTEGER                                                     /* Campo do EMS, para identificar se pessoa F¡sica ou Jur¡dica [Campo: emitente.natureza] */
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttDest IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttDet NO-UNDO
     FIELD cEAN           AS CHARACTER INITIAL ?                                          /*GTIN (Global Trade Item Number) do produto, antigo c¢digo EAN ou c¢digo de barras*/
     FIELD cEANTrib       AS CHARACTER INITIAL ?                                          /*GTIN (Global Trade Item Number) da unidade tribut vel, antigo c¢digo EAN ou c¢digo de barras*/
     FIELD CFOP           AS CHARACTER INITIAL ?                                          /*C¢digo Fiscal de Opera‡äes e Presta‡äes*/
     FIELD cProd          AS CHARACTER INITIAL ?                                          /*C¢digo do produto ou servi‡o. Preencher com CFOP caso se trate de itens nÆo relacionados com mercadorias/produto e que o contribuinte nÆo possua codifica‡Æo pr¢pria Formato ”CFOP9999”.*/
     FIELD EXTIPI         AS CHARACTER INITIAL ?                                          /*C¢digo EX TIPI (3 posi‡äes)*/
     FIELD genero         AS CHARACTER INITIAL ?                                          /*Gˆnero do produto ou servi‡o. Preencher de acordo com a Tabela de Cap¡tulos da NCM. Em caso de servi‡o, nÆo incluir a TAG.*/
     FIELD infAdProd      AS CHARACTER INITIAL ?                                          /*Informa‡äes adicionais do produto (norma referenciada, informa‡äes complementares, etc)*/
     FIELD NCM            AS CHARACTER INITIAL ?                                          /*C¢digo NCM (8 posi‡äes)*/
     FIELD qCom           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>9.9999"      DECIMALS 4  /*Quantidade Comercial*/  
     FIELD qTrib          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>9.9999"      DECIMALS 4  /*Quantidade Tribut vel*/ 
     FIELD uCom           AS CHARACTER INITIAL ?                                          /*Unidade comercial*/
     FIELD uTrib          AS CHARACTER INITIAL ?                                          /*Unidade Tribut vel*/
     FIELD vDesc          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"   DECIMALS 2  /*Valor do Desconto*/ 
     FIELD vFrete         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"   DECIMALS 2  /*Valor Total do Frete*/ 
     FIELD vProd          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"   DECIMALS 2  /*Valor bruto do produto ou servi‡o*/ 
     FIELD vSeg           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"   DECIMALS 2  /*Valor Total do Seguro*/ 
     FIELD vUnCom         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.99999" DECIMALS 5  /*Valor unit rio de comercializa‡Æo*/ 
     FIELD vUnTrib        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.99999" DECIMALS 5  /*Valor unit rio de tributa‡Æo*/ 
     FIELD xProd          AS CHARACTER INITIAL ?                                          /*Descri‡Æo do produto ou servi‡o*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttDet CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttDI NO-UNDO
     FIELD cExportador    AS CHARACTER INITIAL ?                                         /*C¢digo do exportador (usado nos sistemas internos de informa‡Æo do emitente da NF-e)*/
     FIELD dDesemb        AS DATE      INITIAL ?                                         /*Data do desembara‡o aduaneiro (AAAA-MM-DD)*/
     FIELD dDI            AS DATE      INITIAL ?                                         /*Data de registro da DI/DSI/DA (AAAA-MM-DD)*/
     FIELD nDI            AS CHARACTER INITIAL ?                                         /*Numero do Documento de Importa‡Æo DI/DSI/DA (DI/DSI/DA)*/
     FIELD UFDesemb       AS CHARACTER INITIAL ?                                         /*UF onde ocorreu o desembara‡o aduaneiro*/
     FIELD xLocDesemb     AS CHARACTER INITIAL ?                                         /*Local do desembara‡o aduaneiro*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttDI CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttDup NO-UNDO
     FIELD dVenc          AS DATE      INITIAL ?                                         /*Data de vencimento da duplicata (AAAA-MM-DD)*/
     FIELD nDup           AS CHARACTER INITIAL ?                                         /*N£mero da duplicata*/
     FIELD vDup           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da duplicata*/ 
     FIELD nFat           AS CHARACTER INITIAL ?                                         /*Campo para liga‡Æo com a ttCobr*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttDup CodEstabelNF SerieNF NrNotaFisNF nFat
.


DEFINE TEMP-TABLE ttEmit NO-UNDO
     FIELD CEP            AS CHARACTER INITIAL ?                                         /*CEP*/
     FIELD cMun           AS CHARACTER INITIAL ?                                         /*C¢digo do munic¡pio (utilizar a tabela do IBGE), informar 9999999 para opera‡äes com o exterior.*/
     FIELD CNAE           AS CHARACTER INITIAL ?                                         /*CNAE Fiscal*/
     FIELD CNPJ           AS CHARACTER INITIAL ?                                         /*N£mero do CNPJ do emitente*/
     FIELD cPais          AS CHARACTER INITIAL ?                                         /*C¢digo do pa¡s*/
     FIELD CPF            AS CHARACTER INITIAL ?                                         /*N£mero do CPF do emitente*/
     FIELD fone           AS CHARACTER INITIAL ?                                         /*Telefone*/
     FIELD IE             AS CHARACTER INITIAL ?                                         /*Inscri‡Æo Estadual*/
     FIELD IEST           AS CHARACTER INITIAL ?                                         /*Inscricao Estadual do Substituto Tribut rio*/
     FIELD IM             AS CHARACTER INITIAL ?                                         /*Inscri‡Æo Municipal*/
     FIELD nro            AS CHARACTER INITIAL ?                                         /*N£mero*/
     FIELD UF             AS CHARACTER INITIAL ?                                         /*Sigla da UF, , informar EX para opera‡äes com o exterior.*/
     FIELD xBairro        AS CHARACTER INITIAL ?                                         /*Bairro*/
     FIELD xCpl           AS CHARACTER INITIAL ?                                         /*Complemento*/
     FIELD xFant          AS CHARACTER INITIAL ?                                         /*Nome fantasia*/
     FIELD xLgr           AS CHARACTER INITIAL ?                                         /*Logradouro*/
     FIELD xMun           AS CHARACTER INITIAL ?                                         /*Nome do munic¡pio, , informar EXTERIOR para opera‡äes com o exterior.*/
     FIELD xNome          AS CHARACTER INITIAL ?                                         /*RazÆo Social ou Nome do emitente*/
     FIELD xPais          AS CHARACTER INITIAL ?                                         /*Nome do pa¡s*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD VersaoLayout   AS CHARACTER INITIAL ?
     INDEX ch-ttEmit IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttEntrega NO-UNDO
     FIELD cMun           AS CHARACTER INITIAL ?                                         /*C¢digo do munic¡pio (utilizar a tabela do IBGE)*/
     FIELD CNPJ           AS CHARACTER INITIAL ?                                         /*CNPJ*/
     FIELD nro            AS CHARACTER INITIAL ?                                         /*N£mero*/
     FIELD UF             AS CHARACTER INITIAL ?                                         /*Sigla da UF*/
     FIELD xBairro        AS CHARACTER INITIAL ?                                         /*Bairro*/
     FIELD xCpl           AS CHARACTER INITIAL ?                                         /*Complemento*/
     FIELD xLgr           AS CHARACTER INITIAL ?                                         /*Logradouro*/
     FIELD xMun           AS CHARACTER INITIAL ?                                         /*Nome do munic¡pio*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttEntrega IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttExporta NO-UNDO
     FIELD UFEmbarq       AS CHARACTER INITIAL ?                                         /*Sigla da UF onde ocorrer  o embarque dos produtos*/
     FIELD xLocEmbarq     AS CHARACTER INITIAL ?                                         /*Local onde ocorrer  o embarque dos produtos*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttExporta IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttICMS00 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tribut‡Æo pelo ICMS 00 - Tributada integralmente*/
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determina‡Æo da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Pre‡o Tabelado M ximo (valor); 3 - Valor da Opera‡Æo.*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importa‡Æo direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al¡quota do ICMS*/    
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS*/ 
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS*/       
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS00 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttICMS10 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*10 - Tributada e com cobran‡a do ICMS por substitui‡Æo tribut ria */
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determina‡Æo da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Pre‡o Tabelado M ximo (valor); 3 - Valor da Opera‡Æo */
     FIELD modBCST        AS CHARACTER INITIAL ?                                         /*Modalidade de determina‡Æo da BC do ICMS ST: 0 - Pre‡o tabelado ou m ximo  sugerido; 1 - Lista Negativa (valor); 2 - Lista Positiva (valor); 3 - Lista Neutra (valor); 4 - Margem Valor Agregado (%); 5 - Pauta (valor) */
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importa‡Æo direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al¡quota do ICMS*/ 
     FIELD pICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al¡quota do ICMS ST*/ 
     FIELD pMVAST         AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Percentual da Margem de Valor Adicionado ICMS ST*/ 
     FIELD pRedBCST       AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Percentual de redu‡Æo da BC ICMS ST */ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS*/ 
     FIELD vBCST          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS ST*/ 
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS*/ 
     FIELD vICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS ST*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS10 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttICMS20 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tribut‡Æo pelo ICMS 20 - Com redu‡Æo de base de c lculo*/
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determina‡Æo da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Pre‡o Tabelado M ximo (valor); 3 - Valor da Opera‡Æo.*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importa‡Æo direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al¡quota do ICMS*/ 
     FIELD pRedBC         AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Percentual de redu‡Æo da BC*/ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS*/ 
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?   
     INDEX ch-ttICMS20 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttICMS30 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tribut‡Æo pelo ICMS 30 - Isenta ou nÆo tributada e com cobran‡a do ICMS por substitui‡Æo tribut ria */
     FIELD modBCST        AS CHARACTER INITIAL ?                                         /*Modalidade de determina‡Æo da BC do ICMS ST: 0 - Pre‡o tabelado ou m ximo  sugerido; 1 - Lista Negativa (valor); 2 - Lista Positiva (valor); 3 - Lista Neutra (valor); 4 - Margem Valor Agregado (%); 5 - Pauta (valor).*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importa‡Æo direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al¡quota do ICMS ST*/ 
     FIELD pMVAST         AS DECIMAL   INITIAL ?                                         /*Percentual da Margem de Valor Adicionado ICMS ST*/
     FIELD pRedBCST       AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Percentual de redu‡Æo da BC ICMS ST */ 
     FIELD vBCST          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS ST*/ 
     FIELD vICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS ST*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS30 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttICMS40 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tributa‡Æo pelo ICMS 40 - Isenta 41 - NÆo tributada 50 - SuspensÆo 51 - Diferimento */
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importa‡Æo direta 2 - Estrangeira - Adquirida no mercado interno */
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS40 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttICMS51 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tribut‡Æo pelo ICMS 20 - Com redu‡Æo de base de c lculo*/
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determina‡Æo da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Pre‡o Tabelado M ximo (valor); 3 - Valor da Opera‡Æo.*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importa‡Æo direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al¡quota do ICMS*/ 
     FIELD pRedBC         AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Percentual de redu‡Æo da BC*/ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS*/ 
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS51 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttICMS60 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tributa‡Æo pelo ICMS 60 - ICMS cobrado anteriormente por substitui‡Æo tribut ria */
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importa‡Æo direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD vBCST          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS ST retido anteriormente*/ 
     FIELD vICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS ST retido anteriormente*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS60 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttICMS70 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tribut‡Æo pelo ICMS 70 - Com redu‡Æo de base de c lculo e cobran‡a do ICMS por substitui‡Æo tribut ria */
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determina‡Æo da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Pre‡o Tabelado M ximo (valor); 3 - Valor da Opera‡Æo.*/
     FIELD modBCST        AS CHARACTER INITIAL ?                                         /*Modalidade de determina‡Æo da BC do ICMS ST: 0 - Pre‡o tabelado ou m ximo  sugerido; 1 - Lista Negativa (valor); 2 - Lista Positiva (valor); 3 - Lista Neutra (valor); 4 - Margem Valor Agregado (%); 5 - Pauta (valor).*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importa‡Æo direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al¡quota do ICMS*/ 
     FIELD pICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al¡quota do ICMS ST*/ 
     FIELD pMVAST         AS DECIMAL   INITIAL ?                                         /*Percentual da Margem de Valor Adicionado ICMS ST*/
     FIELD pRedBC         AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Percentual de redu‡Æo da BC*/ 
     FIELD pRedBCST       AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Percentual de redu‡Æo da BC ICMS ST */ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS*/ 
     FIELD vBCST          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS ST*/ 
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS*/ 
     FIELD vICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS ST*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS70 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttICMS90 NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*Tribut‡Æo pelo ICMS 90 - Outras*/
     FIELD modBC          AS CHARACTER INITIAL ?                                         /*Modalidade de determina‡Æo da BC do ICMS:  0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Pre‡o Tabelado M ximo (valor); 3 - Valor da Opera‡Æo.*/
     FIELD modBCST        AS CHARACTER INITIAL ?                                         /*Modalidade de determina‡Æo da BC do ICMS ST: 0 - Pre‡o tabelado ou m ximo  sugerido;  1 - Lista Negativa (valor); 2 - Lista Positiva (valor); 3 - Lista Neutra (valor); 4 - Margem Valor Agregado (%);  5 - Pauta (valor).*/
     FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importa‡Æo direta 2 - Estrangeira - Adquirida no mercado interno */
     FIELD pICMS          AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al¡quota do ICMS*/ 
     FIELD pICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al¡quota do ICMS ST*/ 
     FIELD pMVAST         AS DECIMAL   INITIAL ?                                         /*Percentual da Margem de Valor Adicionado ICMS ST*/
     FIELD pRedBC         AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Percentual de redu‡Æo da BC*/ 
     FIELD pRedBCST       AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Percentual de redu‡Æo da BC ICMS ST */ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS*/ 
     FIELD vBCST          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS ST*/ 
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS*/ 
     FIELD vICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS ST*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttICMS90 CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttICMSTot NO-UNDO
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*BC do ICMS*/                 
     FIELD vBCST          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*BC do ICMS ST*/              
     FIELD vCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do COFINS*/            
     FIELD vDesc          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total do Desconto*/    
     FIELD vFrete         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total do Frete*/       
     FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total do ICMS*/        
     FIELD vII            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total do II*/          
     FIELD vIPI           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total do IPI*/          
     FIELD vNF            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total da NF-e*/        
     FIELD vOutro         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Outras Despesas acess¢rias*/ 
     FIELD vPIS           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do PIS*/               
     FIELD vProd          AS DECIMAL   INITIAL ?                                         /*Valor Total dos produtos e servi‡os*/
     FIELD vSeg           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total do Seguro*/      
     FIELD vST            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total do ICMS ST*/     
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttICMSTot IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttIde NO-UNDO
     FIELD cDV            AS CHARACTER INITIAL ?                                         /*Digito Verificador da Chave de Acesso da NF-e*/
     FIELD cMunFG         AS CHARACTER INITIAL ?                                         /*C¢digo do Munic¡pio de Ocorrˆncia do Fato Gerador (utilizar a tabela do IBGE)*/
     FIELD cNF            AS CHARACTER INITIAL ?                                         /*C¢digo num‚rico que compäe a Chave de Acesso. N£mero aleat¢rio gerado pelo emitente para cada NF-e.*/
     FIELD cUF            AS CHARACTER INITIAL ?                                         /*C¢digo da UF do emitente do Documento Fiscal. Utilizar a Tabela do IBGE.*/
     FIELD dEmi           AS DATE      INITIAL ?                                         /*Data de emissÆo do Documento Fiscal (AAAA-MM-DD)*/
     FIELD dSaiEnt        AS DATE      INITIAL ?                                         /*Data de sa¡da ou de entrada da mercadoria / produto (AAAA-MM-DD)*/
     FIELD finNFe         AS CHARACTER INITIAL ?                                         /*Finalidade da emissÆo da NF-e: 1 - NFe normal 2 - NFe complementar 3 - NFe de ajuste*/
     FIELD indPag         AS CHARACTER INITIAL ?                                         /*Indicador da forma de pagamento: 0 - pagamento … vista; 1 - pagamento à prazo; 2 - outros.*/
     FIELD mod            AS CHARACTER INITIAL ?                                         /*C¢digo do modelo do Documento Fiscal. Utilizar 55 para identifica‡Æo da NF-e, emitida em substitui‡Æo ao modelo 1 e 1A.*/
     FIELD natOp          AS CHARACTER INITIAL ?                                         /*Descri‡Æo da Natureza da Opera‡Æo*/
     FIELD nNF            AS CHARACTER INITIAL ?                                         /*N£mero do Documento Fiscal*/
     FIELD procEmi        AS CHARACTER INITIAL ?                                         /*Processo de emissÆo utilizado com a seguinte codifica‡Æo: 0 - emissÆo de NF-e com aplicativo do contribuinte; 1 - emissÆo de NF-e avulsa pelo Fisco; 2 - emissÆo de NF-e avulsa, pelo contribuinte com seu certificado digital, através do site do Fisco; 3- emissÆo de NF-e pelo contribuinte com aplicativo fornecido pelo Fisco.*/
     FIELD serie          AS CHARACTER INITIAL ?                                         /*S‚rie do Documento Fiscal*/
     FIELD tpAmb          AS CHARACTER INITIAL ?                                         /*Identifica‡Æo do Ambiente: 1 - Produ‡Æo 2 - Homologa‡Æo*/
     FIELD tpEmis         AS CHARACTER INITIAL ?                                         /*Forma de emissÆo da NF-e (1 - Normal; 2 - Contingˆncia)*/
     FIELD tpImp          AS CHARACTER INITIAL ?                                         /*Formato de impressÆo do DANFE (1 - Retrato; 2 - Paisagem)*/
     FIELD tpNF           AS CHARACTER INITIAL ?                                         /*Tipo do Documento Fiscal (0 - entrada; 1 - sa¡da)*/
     FIELD verProc        AS CHARACTER INITIAL ?                                         /*versÆo do aplicativo utilizado no processo de emissÆo*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttIde IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttII NO-UNDO
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Base da BC do Imposto de Importa‡Æo*/          
     FIELD vDespAdu       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor das despesas aduaneiras*/                
     FIELD vII            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do Imposto de Importa‡Æo*/               
     FIELD vIOF           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do Imposto sobre Opera‡äes Financeiras*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttII CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttInfAdic NO-UNDO
     FIELD infAdFisco     AS CHARACTER INITIAL ?                                         /*Informa‡äes adicionais de interesse do Fisco*/
     FIELD infCpl         AS CHARACTER INITIAL ?                                         /*Informa‡äes complementares de interesse do Contribuinte*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttInfAdic IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttIPI NO-UNDO
     FIELD cEnq           AS CHARACTER INITIAL ?                                         /*C¢digo de Enquadramento Legal do IPI (tabela a ser criada pela RFB)*/
     FIELD clEnq          AS CHARACTER INITIAL ?                                         /*Classe de Enquadramento do IPI para Cigarros e Bebidas*/
     FIELD CNPJProd       AS CHARACTER INITIAL ?                                         /*CNPJ do produtor da mercadoria, quando diferente do emitente. Somente para os casos de exporta‡Æo direta ou indireta.*/
     FIELD cSelo          AS CHARACTER INITIAL ?                                         /*C¢digo do selo de controle do IPI */
     FIELD CSTIPINT       AS CHARACTER INITIAL ?                                         /*C¢digo da Situa‡Æo Tribut ria do IPI: 01-Entrada tributada com al¡quota zero 02-Entrada isenta 03-Entrada nÆo-tributada 04-Entrada imune 05-Entrada com suspensÆo 51-Sa¡da tributada com al¡quota zero 52-Sa¡da isenta 53-Sa¡da nÆo-tributada 54-Sa¡da imune 55-Sa¡da com suspensÆo*/
     FIELD CSTIPITrib     AS CHARACTER INITIAL ?                                         /*C¢digo da Situa‡Æo Tribut ria do IPI: 00-Entrada com recupera‡Æo de crédito 49 - Outras entradas 50-Sa¡da tributada 99-Outras sa¡das*/ 
     FIELD pIPI           AS DECIMAL   INITIAL ?  FORMAT ">>9.99"            DECIMALS 2  /*Al¡quota do IPI*/ 
     FIELD qSelo          AS CHARACTER INITIAL ?                                         /*Quantidade de selo de controle do IPI*/
     FIELD qUnid          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.9999" DECIMALS 4  /*Quantidade total na unidade padrÆo para tributa‡Æo */ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor da BC do IPI*/ 
     FIELD vIPI           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor do IPI*/ 
     FIELD vUnid          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>9.9999"  DECIMALS 4  /*Valor por Unidade Tribut vel. Informar o valor do imposto Pauta por unidade de medida.*/ 
     FIELD l-ipi-trib     AS LOGICAL   INITIAL ?
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttIPI CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttISSQN NO-UNDO
     FIELD cListServ      AS CHARACTER INITIAL ?                                         /*C¢digo da lista de servi‡os da LC 116/03 em que se classifica o seriv‡o, campo de interesse da Prefeitura, devendo ser informado nas NFe conjugadas, onde h  a presta‡Æo de servi‡os sujeitos ao ISSQN e fornecimento de pe‡as sujeitas ao ICMS*/
     FIELD cMunFG         AS CHARACTER INITIAL ?                                         /*C¢digo do Munic¡pio de Ocorrˆncia do Fato Gerador (utilizar a tabela do IBGE)*/
     FIELD vAliq          AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al¡quota do ISSQN*/    
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ISSQN*/ 
     FIELD vISSQN         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da do ISSQN*/    
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttISSQN CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttISSQNtot NO-UNDO
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Base de C lculo do ISS*/         
     FIELD vCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do COFINS sobre servi‡os*/ 
     FIELD vISS           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total do ISS*/             
     FIELD vPIS           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do PIS sobre servi‡os*/    
     FIELD vServ          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total dos Servi‡os sob nÆo-incidˆncia ou nÆo tributados pelo ICMS */ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttISSQNtot IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttLacres NO-UNDO
     FIELD nLacre         AS CHARACTER INITIAL ?                                         /*N£mero dos Lacres*/
     FIELD nVol           AS CHARACTER INITIAL ?                                         /*campo para liga‡Æo com a ttVol*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttLacres IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF nVol
.


DEFINE TEMP-TABLE ttMed NO-UNDO
     FIELD dFab           AS DATE      INITIAL ?                                         /*Data de Fabrica‡Æo do medicamento (AAAA-MM-DD)*/
     FIELD dVal           AS DATE      INITIAL ?                                         /*Data de validade do medicamento (AAAA-MM-DD)*/
     FIELD nLote          AS CHARACTER INITIAL ?                                         /*N£mero do lote do medicamento*/
     FIELD qLote          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>9.999"     DECIMALS 4   /*Quantidade de produtos no lote*/ 
     FIELD vPMC           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Pre‡o M ximo ao Consumidor*/     
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttMed CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttNFe NO-UNDO
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ChaveAcessoNFe AS CHARACTER INITIAL ?
     FIELD VersaoLayout   AS CHARACTER INITIAL ?
     INDEX ch-ttNFe IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttNFRef NO-UNDO
     FIELD AAMM           AS CHARACTER INITIAL ?                                         /*AAMM da emissÆo*/
     FIELD CNPJ           AS CHARACTER INITIAL ?                                         /*CNPJ do emitente do documento fiscal referenciado*/
     FIELD cUF            AS CHARACTER INITIAL ?                                         /*C¢digo da UF do emitente do Documento Fiscal. Utilizar a Tabela do IBGE.*/
     FIELD mod            AS CHARACTER INITIAL ?                                         /*C¢digo do modelo do Documento Fiscal. Utilizar 01 para NF modelo 1/1A*/
     FIELD nNF            AS CHARACTER INITIAL ?                                         /*N£mero do Documento Fiscal*/
     FIELD refNFe         AS CHARACTER INITIAL ?                                         /*Chave de acesso das NF-e referenciadas. Chave de acesso compostas por C¢digo da UF (tabela do IBGE) + AAMM da emissÆo + CNPJ do Emitente + modelo, série e n£mero da NF-e Referenciada + C¢digo Numérico + DV.*/
     FIELD serie          AS CHARACTER INITIAL ?                                         /*S‚rie do Documento Fiscal, informar zero se inexistente*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttNFRef     CodEstabelNF SerieNF NrNotaFisNF nNF
     INDEX ch-ttNFRef2    refNFe
.


DEFINE TEMP-TABLE ttObsCont NO-UNDO
     FIELD xCampo         AS CHARACTER INITIAL ? /*Atributo*/
     FIELD xTexto         AS CHARACTER INITIAL ? /*Valor*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttObsCont IS PRIMARY CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttObsFisco NO-UNDO
     FIELD xCampo         AS CHARACTER INITIAL ? /*Atributo*/
     FIELD xTexto         AS CHARACTER INITIAL ? /*Valor*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttObsFisco IS PRIMARY CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttPISAliq NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situa‡Æo Tribut ria do PIS. 01 - Opera‡Æo Tribut vel - Base de C lculo = Valor da Opera‡Æo Al¡quota Normal (Cumulativo/NÆo Cumulativo); 02 - Opera‡Æo Tribut vel - Base de Calculo = Valor da Opera‡Æo (Al¡quota Diferenciada) */
     FIELD pPIS           AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al¡quota do PIS (em percentual)*/ 
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do PIS*/              
     FIELD vPIS           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do PIS*/                    
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttPISAliq CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttPISNT NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situa‡Æo Tribut ria do PIS. 04 - Opera‡Æo Tribut vel - Tributa‡Æo Monof sica - (Al¡quota Zero); 06 - Opera‡Æo Tribut vel - Al¡quota Zero; 07 - Opera‡Æo Isenta da contribui‡Æo; 08 - Opera‡Æo Sem Incidˆncia da contribui‡Æo; 09 - Opera‡Æo com suspensÆo da contribui‡Æo */
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttPISNT CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttPISOutr NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situa‡Æo Tribut ria do PIS. 99 - Outras Opera‡äes.*/
     FIELD pPIS           AS DECIMAL   INITIAL ?  FORMAT ">>9.99"            DECIMALS 2  /*Al¡quota do PIS (em percentual)*/ 
     FIELD qBCProd        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.9999" DECIMALS 4  /*Quantidade Vendida */             
     FIELD vAliqProd      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>9.9999"  DECIMALS 4  /*Al¡quota do PIS (em reais)*/      
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor da BC do PIS*/              
     FIELD vPIS           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor do PIS*/                    
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttPISOutr CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttPISQtde NO-UNDO
     FIELD CST            AS CHARACTER INITIAL ?                                         /*C¢digo de Situa‡Æo Tribut ria do PIS. 03 - Opera‡Æo Tribut vel - Base de Calculo = Quantidade Vendida x Al¡quota por Unidade de Produto */
     FIELD qBCProd        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.9999" DECIMALS 4  /*Quantidade Vendida */ 
     FIELD vAliqProd      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>9.9999"  DECIMALS 4  /*Al¡quota do PIS (em reais)*/ 
     FIELD vPIS           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor do PIS*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttPISQtde CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttPISST NO-UNDO
     FIELD pPIS           AS DECIMAL   INITIAL ?  FORMAT ">>9.99"            DECIMALS 2  /*Al¡quota do PIS ST (em percentual)*/ 
     FIELD qBCProd        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>9.9999" DECIMALS 4  /*Quantidade Vendida */                
     FIELD vAliqProd      AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>9.9999"  DECIMALS 4  /*Al¡quota do PIS ST (em reais)*/      
     FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor da BC do PIS ST*/              
     FIELD vPIS           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99"  DECIMALS 2  /*Valor do PIS ST*/                    
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttPISST CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttProcRef NO-UNDO
     FIELD indProc        AS CHARACTER INITIAL ?                                         /*Origem do processo, informar com: 0 - SEFAZ; 1 - Justi‡a Federal; 2 - Justi‡a Estadual; 3 - Secex/RFB; 9 - Outros*/
     FIELD nProc          AS CHARACTER INITIAL ?                                         /*Indentificador do processo ou ato concess¢rio*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttProcRef IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttReboque NO-UNDO
     FIELD placa          AS CHARACTER INITIAL ?                                         /*Placa do ve¡culo*/
     FIELD RNTC           AS CHARACTER INITIAL ?                                         /*Registro Nacional de Transportador de Carga (ANTT)*/
     FIELD UF             AS CHARACTER INITIAL ?                                         /*Sigla da UF*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttReboque CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttRetirada NO-UNDO
     FIELD cMun           AS CHARACTER INITIAL ?                                         /*C¢digo do munic¡pio (utilizar a tabela do IBGE)*/
     FIELD CNPJ           AS CHARACTER INITIAL ?                                         /*CNPJ*/
     FIELD nro            AS CHARACTER INITIAL ?                                         /*N£mero*/
     FIELD UF             AS CHARACTER INITIAL ?                                         /*Sigla da UF*/
     FIELD xBairro        AS CHARACTER INITIAL ?                                         /*Bairro*/
     FIELD xCpl           AS CHARACTER INITIAL ?                                         /*Complemento*/
     FIELD xLgr           AS CHARACTER INITIAL ?                                         /*Logradouro*/
     FIELD xMun           AS CHARACTER INITIAL ?                                         /*Nome do munic¡pio*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttRetirada IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttRetTrib NO-UNDO
     FIELD vBCIRRF        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Base de C lculo do IRRF*/ 
     FIELD vBCRetPrev     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Base de C lculo da Reten‡Æo da Previdˆncica Social*/ 
     FIELD vIRRF          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Retido de IRRF*/    
     FIELD vRetCOFINS     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Retido de COFINS*/  
     FIELD vRetCSLL       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Retido de CSLL*/    
     FIELD vRetPIS        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Retido de PIS*/     
     FIELD vRetPrev       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da Reten‡Æo da Previdˆncica Social*/ 
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttRetTrib IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttTransp NO-UNDO
     FIELD CFOP           AS CHARACTER INITIAL ?                                         /*C¢digo Fiscal de Opera‡äes e Presta‡äes*/
     FIELD cMunFG         AS CHARACTER INITIAL ?                                         /*C¢digo do Munic¡pio de Ocorrˆncia do Fato Gerador (utilizar a tabela do IBGE)*/
     FIELD CNPJ           AS CHARACTER INITIAL ?                                         /*CNPJ do transportador*/
     FIELD CPF            AS CHARACTER INITIAL ?                                         /*CPF do transportador*/
     FIELD IE             AS CHARACTER INITIAL ?                                         /*Inscri‡Æo Estadual*/
     FIELD modFrete       AS CHARACTER INITIAL ?                                         /*Modalidade do frete (0 - por conta do emitente; 1 - por conta do destinat rio)*/
     FIELD pICMSRet       AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al¡quota da Reten‡Æo*/ 
     FIELD placa          AS CHARACTER INITIAL ?                                         /*Placa do ve¡culo*/
     FIELD RNTC           AS CHARACTER INITIAL ?                                         /*Registro Nacional de Transportador de Carga (ANTT)*/
     FIELD UF             AS CHARACTER INITIAL ?                                         /*Sigla da UF*/
     FIELD UFplaca        AS CHARACTER INITIAL ?                                         /*Sigla da UF do Ve¡culo*/
     FIELD vBCRet         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*BC da Reten‡Æo do ICMS*/ 
     FIELD vICMSRet       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS Retido*/ 
     FIELD vServ          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do Servi‡o*/     
     FIELD xEnder         AS CHARACTER INITIAL ?                                         /*Endere‡o completo*/
     FIELD xMun           AS CHARACTER INITIAL ?                                         /*Nome do mun¡cipio*/
     FIELD xNome          AS CHARACTER INITIAL ?                                         /*RazÆo Social ou nome*/
     FIELD i-natureza     AS INTEGER                                                     /*Campo do EMS, para identificar se pessoa F¡sica ou Jur¡dica [Campo: transporte.natureza] */
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     INDEX ch-ttTransp IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF
.


DEFINE TEMP-TABLE ttVeic NO-UNDO
     FIELD anoFab         AS CHARACTER INITIAL ?                                         /*Ano de Fabrica‡Æo*/
     FIELD anoMod         AS CHARACTER INITIAL ?                                         /*Ano Modelo de Fabrica‡Æo*/
     FIELD cCor           AS CHARACTER INITIAL ?                                         /*Cor do ve¡culo (c¢digo de cada montadora)*/
     FIELD chassi         AS CHARACTER INITIAL ?                                         /*Chassi do ve¡culo*/
     FIELD CM3            AS CHARACTER INITIAL ?                                         /*CM3 (potˆncia)*/
     FIELD CMKG           AS CHARACTER INITIAL ?                                         /*CMKG*/
     FIELD cMod           AS CHARACTER INITIAL ?                                         /*C¢digo Marca Modelo (utilizar tabela RENAVAM)*/
     FIELD condVeic       AS CHARACTER INITIAL ?                                         /*Condi‡Æo do ve¡culo (1 - acabado; 2 - inacabado; 3 - semi-acabado)*/
     FIELD dist           AS CHARACTER INITIAL ?                                         /*Distƒncia entre eixos*/
     FIELD espVeic        AS CHARACTER INITIAL ?                                         /*Esp‚cie de ve¡culo (utilizar tabela RENAVAM)*/
     FIELD nMotor         AS CHARACTER INITIAL ?                                         /*N£mero do motor*/
     FIELD nSerie         AS CHARACTER INITIAL ?                                         /*Serial (s‚rie)*/
     FIELD pesoB          AS CHARACTER INITIAL ?                                         /*Peso bruto*/
     FIELD pesoL          AS CHARACTER INITIAL ?                                         /*Peso l¡quido*/
     FIELD pot            AS CHARACTER INITIAL ?                                         /*Potˆncia do motor*/
     FIELD RENAVAM        AS CHARACTER INITIAL ?                                         /*RENAVAM, informar apenas quando existente*/
     FIELD tpComb         AS CHARACTER INITIAL ?                                         /*Tipo de combust¡vel*/
     FIELD tpOp           AS CHARACTER INITIAL ?                                         /*Tipo da Opera‡Æo (1 - Venda concession ria; 2 - Faturamento direto; 3 - Venda direta; 0 - Outros)*/
     FIELD tpPint         AS CHARACTER INITIAL ?                                         /*Tipo de pintura*/
     FIELD tpVeic         AS CHARACTER INITIAL ?                                         /*Tipo de ve¡culo (utilizar tabela RENAVAM)*/
     FIELD VIN            AS CHARACTER INITIAL ?                                         /*C¢digo do VIN (Vehicle Identification Number)*/
     FIELD xCor           AS CHARACTER INITIAL ?                                         /*Descri‡Æo da cor*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD ItCodigoNF     AS CHARACTER INITIAL ?
     FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
     INDEX ch-ttVeic CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF
.


DEFINE TEMP-TABLE ttVol NO-UNDO
     FIELD esp            AS CHARACTER INITIAL ?                                         /*Esp‚cie dos volumes transportados*/
     FIELD marca          AS CHARACTER INITIAL ?                                         /*Marca dos volumes transportados*/
     FIELD nVol           AS CHARACTER INITIAL ?                                         /*Numera‡Æo dos volumes transportados*/
     FIELD pesoB          AS DECIMAL   INITIAL ?                                         /*Peso bruto (em kg)*/
     FIELD pesoL          AS DECIMAL   INITIAL ?                                         /*Peso l¡quido (em kg)*/
     FIELD qVol           AS CHARACTER INITIAL ?                                         /*Quantidade de volumes transportados*/
     /*Chave EMS*/
     FIELD CodEstabelNF   AS CHARACTER INITIAL ?
     FIELD SerieNF        AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
     FIELD SiglaEmb       AS CHARACTER INITIAL ?
     INDEX ch-ttVol IS PRIMARY UNIQUE CodEstabelNF SerieNF NrNotaFisNF SiglaEmb
.


/*---------------------------------------------------------------------------------*/
