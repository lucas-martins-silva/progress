/*----------------------------------------------------------------------------------

    DEFINIÄÂES TEMP-TABLE

----------------------------------------------------------------------------------*/
DEFINE TEMP-TABLE ttHeader NO-UNDO
     FIELD numbernf         AS CHARACTER INITIAL ?  /*  numbernf         AS CHARACTER INITIAL ?  Identifica no documento o n£mero da nota fiscal */                                                                                                                                                                                                                                                                                                                         
     FIELD seriesnf         AS CHARACTER INITIAL ?  /*  seriesnf         AS CHARACTER INITIAL ?  Identifica no documento a sÇrie da nota fiscal  */                                                                                                                                                                                                                                                                                                                         
     FIELD datetimeoutput   AS DATE      INITIAL ?  /*  datetimeoutput   AS DATE      INITIAL ?  Data e hora na qual as mercadorias discriminadas na nota fiscal ser∆o despachadas ou embarcadas. O formato utilizado Ç: AAAAMMDDTHHMM */                                                                                                                                                                                                                                   
     FIELD datetimedelivery AS DATE      INITIAL ?  /*  datetimedelivery AS DATE      INITIAL ?  Data e hora em que as mercadorias discriminadas na nota fiscal est∆o previstas para serem entregues no destino.O formato utilizado Ç: AAAAMMDDTHHMM */                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     FIELD pricelist        AS CHARACTER INITIAL ?  /*  pricelist        AS CHARACTER INITIAL ?  N£mero da Lista de Preáos referente as mercadorias discriminadas na nota fiscal, quando esta for informada pelo fornecedor.  N£mero de referància assinalado para uma Lista de Preáo.  Nota EANCOM:  Este c¢digo deve ser utilizado para identificar uma mensagem Cat†logo de Produtos/Lista de Preáos (PRICAT). */                                                        
     FIELD cfop             AS CHARACTER INITIAL ?  /*  cfop             AS CHARACTER INITIAL ?  C¢digo fiscal de Operaá‰es e Prestaá‰es. Identifica, atravÇs de um c¢digo, qual a Natureza de Operaá∆o Fiscal da Nota. Ex.: 5101 (5.101) corresponde a venda de produá∆o do estabelecimento. */                                                                                                                                                                            
     FIELD numpucharseorder AS CHARACTER INITIAL ?  /*  numpucharseorder AS CHARACTER INITIAL ?  N£mero do contrato de compra que est† sendo faturado na respectiva nota fiscal, quando esta nota estiver faturando um £nico pedido de compra. Quando a nota estiver faturando itens de diversos pedidos, a informaá∆o dever† ser enviada somente nos itens da nota. */                                                                                                     
     FIELD eanbyer          AS CHARACTER INITIAL ?  /*  eanbyer          AS CHARACTER INITIAL ?  EAN DO COMPRADOR (3035: BY - EANCOM) Identificaá∆o atravÇs do C¢digo EAN-13 (c¢digos de barras aplicados a locais que Ç a indicaá∆o da EAN Brasil) do comprador das mercadorias discriminadas no Pedido de Compra. */                                                                                                                                                      
     FIELD eancollection    AS CHARACTER INITIAL ?  /*  eancollection    AS CHARACTER INITIAL ?  EAN DO LOCAL DE COBRANÄA DA FATURA (3035: IV - EANCOM) Identificaá∆o atravÇs de C¢digo EAN-13 (c¢digos de barras aplicados a  locais que Ç a indicaá∆o da EAN Brasil) do local de cobranáa da fatura.  Tipicamente, o local de fatura corresponde ao local indicado pelo comprador para onde deve ser dirigida a cobranáa, ou que mantÇm a administraá∆o de pagamentos. */ 
     FIELD eandelivery      AS CHARACTER INITIAL ?  /*  eandelivery      AS CHARACTER INITIAL ?  EAN DO LOCAL DE ENTREGA (3035:DP -EANCOM) Identificaá∆o atravÇs de c¢digo EAN-13 (c¢digos de barras aplicados a locais que Ç a indicaá∆o da EAN Brasil) do Local de Entrega das mercadorias discriminadas na Nota Fiscal. */                                                                                                                                               
     FIELD eanprovider      AS CHARACTER INITIAL ?  /*  eanprovider      AS CHARACTER INITIAL ?  EAN DO FORNECEDOR (3035: SU - EANCOM) Identificaá∆o atravÇs de c¢digo EAN-13 (c¢digos de barras aplicados a locais que Ç a indicaá∆o da EAN Brasil) do fornecedor das mercadorias. */                                                                   
     FIELD eaninssuernf     AS CHARACTER INITIAL ?  /*  eaninssuernf     AS CHARACTER INITIAL ?  EAN DO FORNECEDOR (3035: SU - EANCOM) Identificaá∆o atravÇs de c¢digo EAN-13 (c¢digos de barras aplicados a locais que Ç a indicaá∆o da EAN Brasil) do fornecedor das mercadorias. */                                                                 
     FIELD cnpjcollection   AS CHARACTER INITIAL ?  /*  cnpjcollection   AS CHARACTER INITIAL ?  CNPJ DO LOCAL DE COBRANÄA DA FATURA n£mero do CNPJ do local de cobranáa da fatura. Tipicamente, o local de fatura corresponde ao local indicado pelo comprador para onde deve ser dirigida a cobranáa, ou que mantÇm a administraá∆o de pagamentos. */
     FIELD codplaceDelivery AS CHARACTER INITIAL ?  /*  codplaceDelivery AS CHARACTER INITIAL ?  CODIGO DO LOCAL DE ENTREGA C¢digo da f†brica de destino do item. Este c¢digo pode, por exemplo, diferenciar diversas plantas/unidades de neg¢cio da empresa, pertencentes a um mesmo CNPJ.1. */                                                       
     /* CHAVE EMS */                                                                                                                                                     
     FIELD CodEstabelNF     AS CHARACTER INITIAL ?                                                                                                                       
     FIELD SerieNF          AS CHARACTER INITIAL ?                                                                                                                       
     FIELD NrNotaFisNF      AS CHARACTER INITIAL ?                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
     INDEX ixttHEADERID CodEstabelNF SerieNF NrNotaFisNF.

DEFINE TEMP-TABLE ttConditionPay NO-UNDO
     FIELD conditionpay       AS CHARACTER INITIAL ? /* CONDIÄ«O DE PAGAMENTO (4279 - EANCOM) Campo para identificaá∆o do tipo de condiá∆o de pagamento que est† sendo aplicada. Vide item 5.8 os conte£dos v†lidos. */
     FIELD datareference      AS CHARACTER INITIAL ? /* REFER“NCIA DA DATA (2475 - EANCOM) Campo para identificaá∆o da data de referància a partir da qual ser† contado o prazo de pagamento. Vide Item 5.9 os conte£dos v†lidos */
     FIELD timereference      AS CHARACTER INITIAL ? /* REFER“NCIA DA DATA (2475 - EANCOM) Campo para identificaá∆o da data de referància a partir da qual ser† contado o prazo de pagamento. Vide Item 5.9 os conte£dos v†lidos REFER“NCIA DE TEMPO (2009 - EANCOM) C¢digo relacionado a um per°odo anterior, durante ou posterior Ö data de referància. Vide Item 5.10 os conte£dos v†lidos. */
     FIELD typeperiod         AS CHARACTER INITIAL ? /* Campo que identifica o c¢digo do tipo de per°odo acordado ou especificado para pagamento. Vide Item 5.11 os conte£dos v†lidos. */
     FIELD periodnum          AS CHARACTER INITIAL ? /* Campo para informaá∆o do n£mero de per°odos acordado para pagamento de acordo com a codificaá∆o escolhida no campo Tipo de Per°odo. */
     FIELD termduedate        AS DATE      INITIAL ? /* Campo para informaá∆o do n£mero de per°odos acordado para pagamento de acordo com a codificaá∆o escolhida no campo Tipo de Per°odo. Campo para informar a data de vencimento da fatura. O formato utilizado Ç: AAAA-MM */
     FIELD billingdatebase    AS DATE      INITIAL ? /* DATA BASE DE FATURAMENTO - Data a partir da qual Ç contado o prazo de pagamento das mercadorias. O formato utilizado Ç: AAAA-MM-DD. */
     FIELD percenttypecondpay AS CHARACTER INITIAL ? /* TIPO DE PERCENTUAL DA CONDIÄ«O DE PAGAMENTO (5245 - EANCOM) Campo utilizado para especificar a porcentagem da parcela de pagamento ou porcentagens que ser∆o acrescidas ou abatidas se o pagamento n∆o for efetuado de acordo com as condiá‰es de pagamento. Vide item 5.12 os conte£dos v†lidos. */
     FIELD percentcondpay     AS DECIMAL   INITIAL ? /* PERCENTUAL DA CONDIÄ«O DE PAGAMENTO (5482 - EANCOM) Campo para informaá∆o do percentual relativo ao campo anterior */                                       
     FIELD typevalcondpay     AS CHARACTER INITIAL ? /* TIPO DE VALOR DA CONDIÄ«O DE PAGAMENTO (5025 - EANCOM) Campo utilizado para especificar o valor das parcelas de pagamento ou valores monet†rios que ser∆o acrescidos ou abatidos se o pagamento n∆o for efetuado de acordo com as condiá‰es de pagamento.Vide Item 5.13 os conte£dos v†lidos. */
     FIELD termamount         AS DECIMAL   INITIAL ? /* Campo para informaá∆o do valor a pagar da condiá∆o de pagamento. */
     FIELD duplicatenum       AS CHARACTER INITIAL ? /* N£mero da duplicata gerada para pagamento das mercadorias faturadas. */
     FIELD codconditionpay    AS CHARACTER INITIAL ? /* C¢digo da condiá∆o de pagamento do cliente no sistema do fornecedor para a respectiva nota fiscal. */
     /* CHAVE EMS */                                  
     FIELD CodEstabelNF       AS CHARACTER INITIAL ?    
     FIELD SerieNF            AS CHARACTER INITIAL ?    
     FIELD NrNotaFisNF        AS CHARACTER INITIAL ?    
     INDEX ixttCONDITIONPAYID CodEstabelNF SerieNF NrNotaFisNF.

DEFINE TEMP-TABLE ttItem NO-UNDO
     FIELD orderline         AS CHARACTER INITIAL ? /* Campo que contÇm o n£mero seqÅencial da linha de item. N£mero serial designando cada item individual em uma sÇrie de produtos. */
     FIELD numitemrequest    AS CHARACTER INITIAL ? /* alterado pra teste */
     FIELD typecodprod       AS CHARACTER INITIAL ? /* Campo utilizado como qualificador do c¢digo do produto. Vide Item 5.14 os conte£dos v†lidos. */
     FIELD itemcode          AS CHARACTER INITIAL ? /* Campo utilizado para discriminaá∆o do c¢digo do produto. Recomenda-se que sejam utilizados os c¢digos padr∆o EAN. */  
     FIELD prodcodsuppli     AS CHARACTER INITIAL ? /* Campo utilizado para discriminaá∆o do c¢digo do produto do fornecedor. */   
     FIELD itemreferencecode AS CHARACTER INITIAL ? /* Campo que contÇm a referància do produto. */
     FIELD itemunitofmeasure AS CHARACTER INITIAL ? /* Unidade de medida referente Ö quantidade pedida.  Em que peso (massa), capacidade, comprimento, †rea, volume a quantidade Ç expressa. Utilizada principalmente em produtos de gramatura n∆o definida na embalagem de consumo (produtos pes†veis). */
     FIELD descunitmensure   AS CHARACTER INITIAL ?
     FIELD orderedquantity   AS DECIMAL   INITIAL ? /* Campo utilizado para informaá∆o da quantidade solicitada pelo comprador da mercadoria. */
     FIELD ponumber          AS CHARACTER INITIAL ? /* N£mero do Pedido de Compra do sistema do comprador. */
     FIELD providernumber    AS CHARACTER INITIAL ? /* NÈMERO DO PEDIDO COMPRADOR (1153:ON - EANCOM).  N£mero do Pedido de Compra do sistema do fornecedor. Este campo ser† preenchido quando a nota fiscal se referir a mais de um pedido. Nestes casos, o campo NÈMERO DO PEDIDO COMPRADOR do registro CABEÄALHO dever† ser gerado em branco e no registro de itens dever† fazer referància ao pedido respectivo. */
     FIELD numorderbuy       AS CHARACTER INITIAL ? /* N£mero da Ordem de Compra */
     FIELD grossweight       AS DECIMAL   INITIAL ? /* PESO BRUTO DO ITEM (6313:G - EANCOM) Peso (massa) das mercadorias incluindo a embalagem, mas excluindo o equipamento do transportador. */
     FIELD grossvolume       AS DECIMAL   INITIAL ?
     FIELD cubagem           AS DECIMAL   INITIAL ?
     FIELD valtotserviceitem AS DECIMAL   INITIAL ?
     FIELD netunitaryprice   AS DECIMAL   INITIAL ?
     /* CHAVE EMS */
     FIELD CodEstabelNF      AS CHARACTER INITIAL ?
     FIELD SerieNF           AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF       AS CHARACTER INITIAL ?
     INDEX ixttITEMID        CodEstabelNF SerieNF NrNotaFisNF.

DEFINE TEMP-TABLE ttEtiqueta NO-UNDO
     FIELD conditionunit         AS CHARACTER INITIAL ? /* Unidade de condicionamento. */
     FIELD qtdpartsconditionunit AS CHARACTER INITIAL ? /* Quantidade de peáas na unidade de condicionamento. */
     FIELD numinvoicepackage	 AS CHARACTER INITIAL ? /* N£mero da Nota da Embalagem */
     FIELD serieinvoicepackage   AS CHARACTER INITIAL ? /* SÇrie da Nota da Embalagem */
     FIELD qtdpackage            AS CHARACTER INITIAL ? /* Quantidade de peáas de condicionamento. */
     /* CHAVE EMS */
     FIELD CodEstabelNF          AS CHARACTER INITIAL ?
     FIELD SerieNF               AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF           AS CHARACTER INITIAL ?
     INDEX ixttETIQUETAID        CodEstabelNF SerieNF NrNotaFisNF.

DEFINE TEMP-TABLE ttCallKanban NO-UNDO
     FIELD numbercall       AS CHARACTER INITIAL ? /* N£mero da chamada */
     FIELD datecall         AS DATE      INITIAL ? /* Data da chamada. O formato utilizado Ç: AAAAMM-DDTHH:MM:SS. */
     FIELD qtdpackagecall   AS INTEGER   INITIAL ? /* Quantidade de Embalagens da chamada */
     FIELD qtditenscall     AS INTEGER   INITIAL ? /* Quantidade de Itens da chamada */
     /* CHAVE EMS */
     FIELD CodEstabelNF     AS CHARACTER INITIAL ?
     FIELD SerieNF          AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF      AS CHARACTER INITIAL ?
     INDEX ixttCALLKANBANID CodEstabelNF SerieNF NrNotaFisNF.

DEFINE TEMP-TABLE ttInvoiceReferenced NO-UNDO
     FIELD numinvoicereferenced       AS CHARACTER INITIAL ? /* N£mero da nota de Remessa referenciada */
     FIELD serieinvoicereferenced     AS CHARACTER INITIAL ? /* SÇrie da nota de Remessa referenciada */
     FIELD inssuanceinvoicereferenced AS CHARACTER INITIAL ? /* Emiss∆o da nota de remessa referenciada */
     FIELD iteminvoicereferenced      AS CHARACTER INITIAL ? /* Item da nota referenciada */
     FIELD valtotservreferenced       AS DECIMAL   INITIAL ? /* Valor total do serviáo referenciado */
     /* CHAVE EMS */
     FIELD CodEstabelNF               AS CHARACTER INITIAL ?
     FIELD SerieNF                    AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF                AS CHARACTER INITIAL ?
     INDEX ixttINVOICEREFERENCEDID CodEstabelNF SerieNF NrNotaFisNF.

DEFINE TEMP-TABLE ttSummary NO-UNDO
     FIELD numunitbilled   AS CHAR /* alterado pra teste */
     FIELD qtdtotpackage   AS DECIMAL INITIAL ? /* QUANTIDADE TOTAL DE EMBALAGENS (6069:11 - EANCOM) N£mero total de embalagens de toda a nota fiscal. */
     FIELD qtdtotpallets   AS DECIMAL INITIAL ? /* QUANTIDADE TOTAL DE PALLETS N£mero total de embalagens de pallets de toda a nota fiscal. */
     FIELD valtotreduction AS DECIMAL INITIAL ? /* VALOR TOTAL DE ABATIMENTOS (5025:260 - EANCOM) Campo para informaá∆o do valor total dos abatimentos das mercadorias. */
     FIELD valbaseicmsred  AS DECIMAL INITIAL ? /* VALOR BASE DE CµLCULO DO ICMS COM REDUÄ«O TRIBUTµRIA (5351:ICT - EANCOM) Campo para informaá∆o do valor da base de c†lculo do ICMS com reduá∆o tribut†ria. */
     FIELD valtoticmsred   AS DECIMAL INITIAL ? /* VALOR TOTAL DE ICMS COM REDUÄ«O TRIBUTµRIA (5351:ICT - EANCOM) Campo para informaá∆o do valor total do ICMS com reduá∆o tribut†ria. */
     FIELD valbaseipi      AS DECIMAL INITIAL ? /* VALOR BASE DE CµLCULO DO IPI (5351:IPI - EANCOM) Campo para informaá∆o do valor da base de c†lculo do IPI */
     FIELD valtotipi       AS DECIMAL INITIAL ? /* VALOR TOTAL DE IPI (5351:IPI - EANCOM) Campo para informaá∆o do valor total de IPI */
     /* CHAVE EMS */
     FIELD CodEstabelNF    AS CHARACTER INITIAL ?
     FIELD SerieNF         AS CHARACTER INITIAL ?
     FIELD NrNotaFisNF     AS CHARACTER INITIAL ?
     INDEX ixttSUMMARYID   CodEstabelNF SerieNF NrNotaFisNF.

DEFINE TEMP-TABLE ttRemessaColab NO-UNDO
     FIELD IDERP     AS CHAR
     FIELD IDTSS     AS CHAR
     FIELD MODELO    AS CHAR
     FIELD XMLDOC    AS HANDLE.
