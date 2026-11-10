
DEFINE TEMP-TABLE ttcondutor NO-UNDO
     FIELD CPF                  AS CHARACTER INITIAL ?  /*CPF do Condutor*/
     FIELD ttcondutorID         AS INTEGER INITIAL ?
     FIELD ttMDFeID             AS INTEGER INITIAL ?
     FIELD xNome                AS CHARACTER INITIAL ?  /*Nome do Condutor*/
.


DEFINE TEMP-TABLE ttdisp NO-UNDO
     FIELD CNPJForn             AS CHARACTER INITIAL ?  /*CNPJ da empresa fornecedora do Vale-Pedágio*/
     FIELD CNPJPg               AS CHARACTER INITIAL ?  /*CNPJ do responsável pelo pagamento do Vale-Pedágio*/
     FIELD nCompra              AS CHARACTER INITIAL ?  /*Número do comprovante de compra*/
     FIELD ttdispID             AS INTEGER   INITIAL ?
     FIELD ttMDFeID             AS INTEGER   INITIAL ?
.


DEFINE TEMP-TABLE ttinfCT NO-UNDO
     FIELD dEmi                 AS DATE      INITIAL ?  /*Data de Emissão*/
     FIELD nCT                  AS CHARACTER INITIAL ?  /*Número do CT*/
     FIELD serie                AS CHARACTER INITIAL ?  /*Série do CT*/
     FIELD subser               AS CHARACTER INITIAL ?  /*Subserie do CT*/
     FIELD ttinfCTID            AS INTEGER   INITIAL ?
     FIELD ttinfMunDescargaID   AS INTEGER   INITIAL ?
     FIELD vCarga               AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2     /*Valor total da carga*/
     INDEX ixttinfCTID IS PRIMARY UNIQUE ttinfCTID ASCENDING
.


DEFINE TEMP-TABLE ttinfCTe NO-UNDO
     FIELD chCTe                AS CHARACTER INITIAL ?  /*Conhecimento Eletrônico - Chave de Acesso*/
     FIELD SegCodBarra          AS CHARACTER INITIAL ?  /*Segundo código de barras*/
     FIELD ttinfCTeID           AS INTEGER   INITIAL ?
     FIELD ttinfMunDescargaID   AS INTEGER   INITIAL ?
     INDEX ixttinfCTeID IS PRIMARY UNIQUE ttinfCTeID ASCENDING
.


DEFINE TEMP-TABLE ttinfEmbComb NO-UNDO
     FIELD cEmbComb             AS CHARACTER INITIAL ?  /*Código da embarcação do comboio*/
     FIELD ttinfEmbCombID       AS INTEGER   INITIAL ?
     FIELD ttMDFeID             AS INTEGER   INITIAL ?
.


DEFINE TEMP-TABLE ttinfMunCarrega NO-UNDO
     FIELD cMunCarrega          AS CHARACTER INITIAL ?  /*Código do Município de Carregamento*/
     FIELD ttinfMunCarregaID    AS INTEGER   INITIAL ?
     FIELD ttMDFeID             AS INTEGER   INITIAL ?
     FIELD xMunCarrega          AS CHARACTER INITIAL ?  /*Nome do Município de Carregamento*/
.


DEFINE TEMP-TABLE ttinfMunDescarga NO-UNDO
     FIELD cMunDescarga         AS CHARACTER INITIAL ?  /*Código do Município de Descarregamento*/
     FIELD ttinfMunDescargaID   AS INTEGER   INITIAL ?
     FIELD ttMDFeID             AS INTEGER   INITIAL ?
     FIELD xMunDescarga         AS CHARACTER INITIAL ?  /*Nome do Município de Descarregamento*/
     INDEX ixttinfMunDescargaID IS PRIMARY UNIQUE ttinfMunDescargaID ASCENDING
.


DEFINE TEMP-TABLE ttinfNF NO-UNDO
     FIELD CNPJ                 AS CHARACTER INITIAL ?  /*CNPJ do emitente*/
     FIELD dEmi                 AS DATE      INITIAL ?  /*Data de Emissão*/
     FIELD nNF                  AS CHARACTER INITIAL ?  /*Número */
     FIELD PIN                  AS CHARACTER INITIAL ?  /*PIN SUFRAMA*/
     FIELD serie                AS CHARACTER INITIAL ?  /*Série*/
     FIELD ttinfMunDescargaID   AS INTEGER   INITIAL ?
     FIELD ttinfNFID            AS INTEGER   INITIAL ?
     FIELD UF                   AS CHARACTER INITIAL ?  /*UF do Destinatário*/
     FIELD vNF                  AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2     /*Valor Total da NF*/
     INDEX ixttinfNFID IS PRIMARY UNIQUE ttinfNFID ASCENDING
.


DEFINE TEMP-TABLE ttinfNFe NO-UNDO
     FIELD chNFe                AS CHARACTER INITIAL ?  /*Nota Fiscal Eletrônica*/
     FIELD SegCodBarra          AS CHARACTER INITIAL ?  /*Segundo código de barras*/
     FIELD ttinfMunDescargaID   AS INTEGER   INITIAL ?
     FIELD ttinfNFeID           AS INTEGER   INITIAL ?
     INDEX ixttinfNFeID IS PRIMARY UNIQUE ttinfNFeID ASCENDING
.


DEFINE TEMP-TABLE ttinfPercurso NO-UNDO
     FIELD ttinfPercursoID      AS INTEGER   INITIAL ?
     FIELD ttMDFeID             AS INTEGER   INITIAL ?
     FIELD UFPer                AS CHARACTER INITIAL ?  /*Sigla das Unidades da Federação do percurso do veículo.*/
.


DEFINE TEMP-TABLE ttinfTermCarreg NO-UNDO
     FIELD cTermCarreg          AS CHARACTER INITIAL ?  /*Código do Terminal de Carregamento*/
     FIELD ttinfTermCarregID    AS INTEGER   INITIAL ?
     FIELD ttMDFeID             AS INTEGER   INITIAL ?
.


DEFINE TEMP-TABLE ttinfTermDescarreg NO-UNDO
     FIELD cTermDescarreg       AS CHARACTER INITIAL ?  /*Código do Terminal de Descarregamento*/
     FIELD ttinfTermDescarregID AS INTEGER   INITIAL ?
     FIELD ttMDFeID             AS INTEGER   INITIAL ?
.


DEFINE TEMP-TABLE ttinfUnidCarga NO-UNDO
     FIELD idUnidCarga          AS CHARACTER INITIAL ?  /*Identificação da Unidade de Carga*/
     FIELD qtdRat               AS DECIMAL   INITIAL ?  FORMAT ">>9.99" DECIMALS 2     /*Quantidade rateada (Peso,Volume)*/
     FIELD tpUnidCarga          AS CHARACTER INITIAL ?  /*Tipo da Unidade de Carga*/
     FIELD ttinfUnidCargaID     AS INTEGER   INITIAL ?
     FIELD ttinfUnidTranspID    AS INTEGER   INITIAL ?
     INDEX ixttinfUnidCargaID IS PRIMARY UNIQUE ttinfUnidCargaID ASCENDING
.


DEFINE TEMP-TABLE ttinfUnidCarga_00 NO-UNDO
     FIELD idUnidCarga          AS CHARACTER INITIAL ?  /*Identificação da Unidade de Carga*/
     FIELD qtdRat               AS DECIMAL   INITIAL ?  FORMAT ">>9.99" DECIMALS 2     /*Quantidade rateada (Peso,Volume)*/
     FIELD tpUnidCarga          AS CHARACTER INITIAL ?  /*Tipo da Unidade de Carga*/
     FIELD ttinfUnidCarga_00ID  AS INTEGER   INITIAL ?
     FIELD ttinfUnidTransp_00ID AS INTEGER   INITIAL ?
     INDEX ixttinfUnidCarga_00ID IS PRIMARY UNIQUE ttinfUnidCarga_00ID ASCENDING
.


DEFINE TEMP-TABLE ttinfUnidCarga_01 NO-UNDO
     FIELD idUnidCarga          AS CHARACTER INITIAL ?  /*Identificação da Unidade de Carga*/
     FIELD qtdRat               AS DECIMAL   INITIAL ?  FORMAT ">>9.99" DECIMALS 2     /*Quantidade rateada (Peso,Volume)*/
     FIELD tpUnidCarga          AS CHARACTER INITIAL ?  /*Tipo da Unidade de Carga*/
     FIELD ttinfUnidCarga_01ID  AS INTEGER   INITIAL ?
     FIELD ttinfUnidTransp_01ID AS INTEGER   INITIAL ?
     INDEX ixttinfUnidCarga_01ID IS PRIMARY UNIQUE ttinfUnidCarga_01ID ASCENDING
.


DEFINE TEMP-TABLE ttinfUnidCarga_02 NO-UNDO
     FIELD idUnidCarga          AS CHARACTER INITIAL ?  /*Identificação da Unidade de Carga*/
     FIELD qtdRat               AS DECIMAL   INITIAL ?  FORMAT ">>9.99" DECIMALS 2     /*Quantidade rateada (Peso,Volume)*/
     FIELD tpUnidCarga          AS CHARACTER INITIAL ?  /*Tipo da Unidade de Carga*/
     FIELD ttinfUnidCarga_02ID  AS INTEGER   INITIAL ?
     FIELD ttinfUnidTransp_02ID AS INTEGER   INITIAL ?
     INDEX ixttinfUnidCarga_02ID IS PRIMARY UNIQUE ttinfUnidCarga_02ID ASCENDING
.


DEFINE TEMP-TABLE ttinfUnidTransp NO-UNDO
     FIELD idUnidTransp         AS CHARACTER INITIAL ?  /*Identificação da Unidade de Transporte*/
     FIELD qtdRat               AS DECIMAL   INITIAL ?  FORMAT ">>9.99" DECIMALS 2     /*Quantidade rateada (Peso,Volume)*/
     FIELD tpUnidTransp         AS CHARACTER INITIAL ?  /*Tipo da Unidade de Transporte*/
     FIELD ttinfCTeID           AS INTEGER   INITIAL ?
     FIELD ttinfUnidTranspID    AS INTEGER   INITIAL ?
     INDEX ixttinfUnidTranspID IS PRIMARY UNIQUE ttinfUnidTranspID ASCENDING
.


DEFINE TEMP-TABLE ttinfUnidTransp_00 NO-UNDO
     FIELD idUnidTransp         AS CHARACTER INITIAL ?  /*Identificação da Unidade de Transporte*/
     FIELD qtdRat               AS DECIMAL   INITIAL ?  FORMAT ">>9.99" DECIMALS 2     /*Quantidade rateada (Peso,Volume)*/
     FIELD tpUnidTransp         AS CHARACTER INITIAL ?  /*Tipo da Unidade de Transporte*/
     FIELD ttinfCTID            AS INTEGER   INITIAL ?
     FIELD ttinfUnidTransp_00ID AS INTEGER   INITIAL ?
     INDEX ixttinfUnidTransp_00ID IS PRIMARY UNIQUE ttinfUnidTransp_00ID ASCENDING
.


DEFINE TEMP-TABLE ttinfUnidTransp_01 NO-UNDO
     FIELD idUnidTransp         AS CHARACTER INITIAL ?  /*Identificação da Unidade de Transporte*/
     FIELD qtdRat               AS DECIMAL   INITIAL ?  FORMAT ">>9.99" DECIMALS 2     /*Quantidade rateada (Peso,Volume)*/
     FIELD tpUnidTransp         AS CHARACTER INITIAL ?  /*Tipo da Unidade de Transporte*/
     FIELD ttinfNFeID           AS INTEGER   INITIAL ?
     FIELD ttinfUnidTransp_01ID AS INTEGER   INITIAL ?
     INDEX ixttinfUnidTransp_01ID IS PRIMARY UNIQUE ttinfUnidTransp_01ID ASCENDING
.


DEFINE TEMP-TABLE ttinfUnidTransp_02 NO-UNDO
     FIELD idUnidTransp         AS CHARACTER INITIAL ?  /*Identificação da Unidade de Transporte*/
     FIELD qtdRat               AS DECIMAL   INITIAL ?  FORMAT ">>9.99" DECIMALS 2     /*Quantidade rateada (Peso,Volume)*/
     FIELD tpUnidTransp         AS CHARACTER INITIAL ?  /*Tipo da Unidade de Transporte*/
     FIELD ttinfNFID            AS INTEGER   INITIAL ?
     FIELD ttinfUnidTransp_02ID AS INTEGER   INITIAL ?
     INDEX ixttinfUnidTransp_02ID IS PRIMARY UNIQUE ttinfUnidTransp_02ID ASCENDING
.


DEFINE TEMP-TABLE ttlacres NO-UNDO
     FIELD nLacre               AS CHARACTER INITIAL ?  /*número do lacre*/
     FIELD ttlacresID           AS INTEGER   INITIAL ?
     FIELD ttMDFeID             AS INTEGER   INITIAL ?
.


DEFINE TEMP-TABLE ttlacUnidCarga NO-UNDO
     FIELD nLacre               AS CHARACTER INITIAL ?  /*Número do lacre*/
     FIELD ttinfUnidCargaID     AS INTEGER   INITIAL ?
     FIELD ttlacUnidCargaID     AS INTEGER   INITIAL ?
.


DEFINE TEMP-TABLE ttlacUnidCarga_00 NO-UNDO
     FIELD nLacre               AS CHARACTER INITIAL ?  /*Número do lacre*/
     FIELD ttinfUnidCarga_00ID  AS INTEGER   INITIAL ?
     FIELD ttlacUnidCarga_00ID  AS INTEGER   INITIAL ?
.


DEFINE TEMP-TABLE ttlacUnidCarga_01 NO-UNDO
     FIELD nLacre               AS CHARACTER INITIAL ?  /*Número do lacre*/
     FIELD ttinfUnidCarga_01ID  AS INTEGER   INITIAL ?
     FIELD ttlacUnidCarga_01ID  AS INTEGER   INITIAL ?
.


DEFINE TEMP-TABLE ttlacUnidCarga_02 NO-UNDO
     FIELD nLacre               AS CHARACTER INITIAL ?  /*Número do lacre*/
     FIELD ttinfUnidCarga_02ID  AS INTEGER   INITIAL ?
     FIELD ttlacUnidCarga_02ID  AS INTEGER   INITIAL ?
.


DEFINE TEMP-TABLE ttlacUnidTransp NO-UNDO
     FIELD nLacre               AS CHARACTER INITIAL ?  /*Número do lacre*/
     FIELD ttinfUnidTranspID    AS INTEGER   INITIAL ?
     FIELD ttlacUnidTranspID    AS INTEGER   INITIAL ?
.


DEFINE TEMP-TABLE ttlacUnidTransp_00 NO-UNDO
     FIELD nLacre               AS CHARACTER INITIAL ?  /*Número do lacre*/
     FIELD ttinfUnidTransp_00ID AS INTEGER   INITIAL ?
     FIELD ttlacUnidTransp_00ID AS INTEGER   INITIAL ?
.


DEFINE TEMP-TABLE ttlacUnidTransp_01 NO-UNDO
     FIELD nLacre               AS CHARACTER INITIAL ?  /*Número do lacre*/
     FIELD ttinfUnidTransp_01ID AS INTEGER   INITIAL ?
     FIELD ttlacUnidTransp_01ID AS INTEGER   INITIAL ?
.


DEFINE TEMP-TABLE ttlacUnidTransp_02 NO-UNDO
     FIELD nLacre               AS CHARACTER INITIAL ?  /*Número do lacre*/
     FIELD ttinfUnidTransp_02ID AS INTEGER   INITIAL ?
     FIELD ttlacUnidTransp_02ID AS INTEGER   INITIAL ?
.


DEFINE TEMP-TABLE ttMDFe NO-UNDO
     FIELD cAerDes              AS CHARACTER INITIAL ?  /*Aeródromo de Destino*/
     FIELD cAerEmb              AS CHARACTER INITIAL ?  /*Aeródromo de Embarque*/
     FIELD capKG                AS CHARACTER INITIAL ?  /*Capacidade em KG*/
     FIELD capM3                AS CHARACTER INITIAL ?  /*Capacidade em M3*/
     FIELD cDV                  AS CHARACTER INITIAL ?  /*Digito verificador da chave de acesso do Manifesto*/
     FIELD cEmbar               AS CHARACTER INITIAL ?  /*Código da embarcação*/
     FIELD CEP                  AS CHARACTER INITIAL ?  /*CEP*/
     FIELD cInt                 AS CHARACTER INITIAL ?  /*Código interno do veículo */
     FIELD CIOT                 AS CHARACTER INITIAL ?  /*Código Identificador da Operação de Transporte*/
     FIELD cMDF                 AS CHARACTER INITIAL ?  /*Código numérico que compõe a Chave de Acesso. */
     FIELD cMun                 AS CHARACTER INITIAL ?  /*Código do município (utilizar a tabela do IBGE), informar 9999999 para operações com o exterior.*/
     FIELD CNPJ                 AS CHARACTER INITIAL ?  /*CNPJ do emitente*/
     FIELD CNPJAgeNav           AS CHARACTER INITIAL ?  /*CNPJ da Agência de Navegação*/
     FIELD cPrtDest             AS CHARACTER INITIAL ?  /*Código do Porto de Destino*/
     FIELD cPrtEmb              AS CHARACTER INITIAL ?  /*Código do Porto de Embarque*/
     FIELD cUF                  AS CHARACTER INITIAL ?  /*Código da UF do emitente do MDF-e*/
     FIELD cUnid                AS CHARACTER INITIAL ?  /*Codigo da unidade de medida do Peso Bruto da Carga / Mercadorias transportadas*/
     FIELD dhEmi                AS CHARACTER INITIAL ?  /*Data e hora de emissão do Manifesto*/
     FIELD dhTrem               AS CHARACTER INITIAL ?  /*Data e hora de liberação do trem na origem*/
     FIELD dVoo                 AS DATE      INITIAL ?  /*Data do Voo*/
     FIELD email                AS CHARACTER INITIAL ?  /*Endereço de E-mail*/
     FIELD fone                 AS CHARACTER INITIAL ?  /*Telefone*/
     FIELD IE                   AS CHARACTER INITIAL ?  /*Inscrição Estadual do emitemte*/
     FIELD infAdFisco           AS CHARACTER INITIAL ?  /*Informações adicionais de interesse do Fisco*/
     FIELD infCpl               AS CHARACTER INITIAL ?  /*Informações complementares de interesse do Contribuinte*/
     FIELD matr                 AS CHARACTER INITIAL ?  /*Marca de Matrícula da aeronave*/
     FIELD mod                  AS CHARACTER INITIAL ?  /*Modelo do Manifesto Eletrônico*/
     FIELD modal                AS CHARACTER INITIAL ?  /*Modalidade de transporte*/
     FIELD nac                  AS CHARACTER INITIAL ?  /*Marca da Nacionalidade da aeronave*/
     FIELD nMDF                 AS CHARACTER INITIAL ?  /*Número do Manifesto*/
     FIELD nro                  AS CHARACTER INITIAL ?  /*Número*/
     FIELD xEmbar               AS CHARACTER INITIAL ?  /*Nome da Embarca‡Æo*/
     FIELD nViag                AS CHARACTER INITIAL ?  /*Número da Viagem*/
     FIELD nVoo                 AS CHARACTER INITIAL ?  /*Número do Voo*/
     FIELD placa                AS CHARACTER INITIAL ?  /*Placa do veículo */
     FIELD procEmi              AS CHARACTER INITIAL ?  /*Identificação do processo de emissão do Manifesto*/
     FIELD qCarga               AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>9.9999" DECIMALS 4     /*Peso Bruto Total da Carga / Mercadorias transportadas*/
     FIELD qCT                  AS CHARACTER INITIAL ?  /*Quantidade total de Conhecimentos Papel relacionados no Manifesto*/
     FIELD qCTe                 AS CHARACTER INITIAL ?  /*Quantidade total de CT-e relacionados no Manifesto*/
     FIELD qNF                  AS CHARACTER INITIAL ?  /*Quantidade total de Nota Fiscal mod 1/1A relacionadas no Manifesto*/
     FIELD qNFe                 AS CHARACTER INITIAL ?  /*Quantidade total de NF-e relacionadas no Manifesto*/
     FIELD qVag                 AS CHARACTER INITIAL ?  /*Quantidade de vagões carregados*/
     FIELD RNTRC                AS CHARACTER INITIAL ?  /*Registro Nacional de Transportadores Rodoviários de Carga*/
     /*NOVAS TAGS*/
     FIELD cgcProp              AS CHARACTER INITIAL ?  /*CPF/CNPJ Proprietario*/
     FIELD nomeProp             AS CHARACTER INITIAL ?  /*Nome Proprietario*/
     FIELD ieProp               AS CHARACTER INITIAL ?  /*IE Proprietario*/
     FIELD ufProp               AS CHARACTER INITIAL ?  /*UF Proprietario*/
     FIELD tpProp               AS CHARACTER INITIAL ?  /*Tipo Proprietario*/
     FIELD tpRod                AS CHARACTER INITIAL ?  /*Tipo Rodado*/
     FIELD tpCar                AS CHARACTER INITIAL ?  /*Tipo Carroceria*/
     FIELD ufVeicLicenc         AS CHARACTER INITIAL ?  /*UF Veiculo Licenciado*/
     /*NOVAS TAGS*/
     FIELD RNTRC_00             AS CHARACTER INITIAL ?  /*Registro Nacional dos Transportadores Rodoviários de Carga*/
     FIELD serie                AS CHARACTER INITIAL ?  /*Série do Manifesto*/
     FIELD tara                 AS CHARACTER INITIAL ?  /*Tara em KG*/
     FIELD tpAmb                AS CHARACTER INITIAL ?  /*Tipo do Ambiente*/
     FIELD tpEmb                AS CHARACTER INITIAL ?  /*Código do tipo de embarcação*/
     FIELD tpEmis               AS CHARACTER INITIAL ?  /*Forma de emissão do Manifesto (Normal ou Contingência)*/
     FIELD tpEmit               AS CHARACTER INITIAL ?  /*Tipo do Emitente */
     FIELD ttMDFeID             AS INTEGER   INITIAL ?
     FIELD UF                   AS CHARACTER INITIAL ?  /*Sigla da UF, , informar EX para operações com o exterior.*/
     FIELD UFFim                AS CHARACTER INITIAL ?  /*Sigla da UF do Descarregamento*/
     FIELD UFIni                AS CHARACTER INITIAL ?  /*Sigla da UF do Carregamento*/
     FIELD vCarga               AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2     /*Valor total da carga / mercadorias transportadas*/
     FIELD verProc              AS CHARACTER INITIAL ?  /*Versão do processo de emissão*/
     FIELD xBairro              AS CHARACTER INITIAL ?  /*Bairro*/
     FIELD xCpl                 AS CHARACTER INITIAL ?  /*Complemento*/
     FIELD xDest                AS CHARACTER INITIAL ?  /*Destino do Trem*/
     FIELD xFant                AS CHARACTER INITIAL ?  /*Nome fantasia do emitente*/
     FIELD xLgr                 AS CHARACTER INITIAL ?  /*Logradouro*/
     FIELD xMun                 AS CHARACTER INITIAL ?  /*Nome do município, , informar EXTERIOR para operações com o exterior.*/
     FIELD xNome                AS CHARACTER INITIAL ?  /*Razão social ou Nome do emitente*/
     FIELD xOri                 AS CHARACTER INITIAL ?  /*Origem do Trem*/
     FIELD xPref                AS CHARACTER INITIAL ?  /*Prefixo do Trem*/
     FIELD cMDFE                AS CHARACTER INITIAL ?  /*C¢digo aleat¢rio do mdfe*/
     INDEX ixttMDFeID IS PRIMARY UNIQUE ttMDFeID ASCENDING
.


DEFINE TEMP-TABLE ttvag NO-UNDO
     FIELD nSeq                 AS CHARACTER INITIAL ?  /*Sequencia do vagão na composição*/
     FIELD nVag                 AS CHARACTER INITIAL ?  /*Número de Identificação do vagão*/
     FIELD serie                AS CHARACTER INITIAL ?  /*Serie de Identificação do vagão*/
     FIELD ttMDFeID             AS INTEGER   INITIAL ?
     FIELD ttvagID              AS INTEGER   INITIAL ?
     FIELD TU                   AS DECIMAL   INITIAL ?  FORMAT ">>9.999" DECIMALS 3     /*Tonelada Útil*/
.


DEFINE TEMP-TABLE ttveicReboque NO-UNDO
     FIELD capKG                AS CHARACTER INITIAL ?  /*Capacidade em KG*/
     FIELD capM3                AS CHARACTER INITIAL ?  /*Capacidade em M3*/
     FIELD cInt                 AS CHARACTER INITIAL ?  /*Código interno do veículo */
     FIELD placa                AS CHARACTER INITIAL ?  /*Placa do veículo */
     FIELD RNTRC                AS CHARACTER INITIAL ?  /*Registro Nacional dos Transportadores Rodoviários de Carga*/
     /*NOVAS TAGS*/
     FIELD cgcProp              AS CHARACTER INITIAL ?  /*CPF/CNPJ Proprietario*/
     FIELD nomeProp             AS CHARACTER INITIAL ?  /*Nome Proprietario*/
     FIELD ieProp               AS CHARACTER INITIAL ?  /*IE Proprietario*/
     FIELD ufProp               AS CHARACTER INITIAL ?  /*UF Proprietario*/
     FIELD tpProp               AS CHARACTER INITIAL ?  /*Tipo Proprietario*/
     FIELD tpCar                AS CHARACTER INITIAL ?  /*Tipo Carroceria*/
     FIELD ufVeicLicenc         AS CHARACTER INITIAL ?  /*UF Veiculo Licenciado*/
     /*NOVAS TAGS*/
     FIELD tara                 AS CHARACTER INITIAL ?  /*Tara em KG*/
     FIELD ttMDFeID             AS INTEGER   INITIAL ?
     FIELD ttveicReboqueID      AS INTEGER   INITIAL ?
.


DEFINE TEMP-TABLE ttCGCAutoriza NO-UNDO
     FIELD cgcAutoriza          AS CHARACTER INITIAL ?  /*CGC Autorizado*/
     FIELD ttMDFeID             AS INTEGER   INITIAL ?
     FIELD ttCGCAutorizaID      AS INTEGER   INITIAL ?
.

/*LOCAL VARIABLES - END*/
