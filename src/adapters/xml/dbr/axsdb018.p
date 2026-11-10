/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSDB018 2.00.01.003}  /*** 010103 ***/
/* DEFINICAO DE PRE-PROCESSADORES */
&GLOBAL-DEFINE XmlApp            MA2
&GLOBAL-DEFINE XmlMod            CDP
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    204
&GLOBAL-DEFINE XmlTranName       ItemDBR
&GLOBAL-DEFINE XmlTranVersion    204.200

/* LOCAL VARIABLES */
DEFINE VAR cReturnValue    AS CHARACTER INITIAL ?     NO-UNDO.
DEFINE VAR hMessageHandler AS HANDLE                  NO-UNDO.
DEFINE VAR lCreateMsg      AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE VAR pSendSuccess    AS LOGICAL   INITIAL YES   NO-UNDO.
DEFINE VAR pTotalErrors    AS INTEGER   INITIAL ?     NO-UNDO.

DEFINE TEMP-TABLE ttItem NO-UNDO
    FIELD ItemCode                       AS CHARACTER INITIAL ?  /*Código do Item (Uso interno: campo=item.it-codigo)*/
    FIELD ItemDescription                AS CHARACTER INITIAL ?  /*Descrição do Item(Uso interno: campo=item.desc-item)*/
    FIELD MaterialFamilyCode             AS CHARACTER INITIAL ?  /*Codigo da Familia de Materiais (Uso interno: campo=mgind.item.fm-codigo)*/
    FIELD InventoryGroupCode             AS INTEGER   INITIAL ?  /*Grupo de Estoque do Item (Uso interno: campo=item.ge-codigo)*/
    FIELD UnitOfMeasureCode              AS CHARACTER INITIAL ?  /*Código da Unidade de Medida. (Uso interno:campo=mgind.item.un)*/
    FIELD DefaultSiteCode                AS CHARACTER INITIAL ?  /*Estabelecimento Padrão do Item (Uso interno: campo= item.cod-estabel)*/
    FIELD ItemStatus                     AS INTEGER   INITIAL ?  /*Situação do item. Valores: 1-Ativo, 2- Obsoleto Ordens Automaticas, 3-Obsoleto Todas as Ordens, 4- Totalmente Obsoleto. (Uso interno:campo=item.cod-obsoleto. Include ininc~\i17in172.i)*/
    FIELD CommercialFamilyCode           AS CHARACTER INITIAL ?  /*Família Comercial do Item. (Uso interno: campo=item.fm-cod-com)*/
    FIELD BougthOrManufacturedItem       AS INTEGER   INITIAL ?  /*Forma de Obtenção do Item. Valores: 1- Comprado, 2- Fabricado.(Uso interno:campo=item.compr-fabric. Include ininc~\i01in172.i)*/
    FIELD ScrapFactor                    AS DECIMAL   INITIAL ?  /*Percentual de Refugo Padrão para os itens da família. (Uso interno:campo=item.fator-refugo)*/
    FIELD OrderDivision                  AS INTEGER   INITIAL ?  /*Divisão de Ordens. Valores: 1-Não divide, 2-Lote múltiplo, 3-Lote econômico (Uso interno: campo=item.div-ordem Include ininc~\i12in122.i) */
    FIELD EconomicLot                    AS DECIMAL   INITIAL ?  /*Lote econômico padrão para os itens da família. (Uso interno:  campo=item.lote-economi)*/
    FIELD MultipleBatch                  AS DECIMAL   INITIAL ?  /*Lote Multiplo para Itens da Familia. (Uso interno: campo=item.lote-multipl)*/
    FIELD MinimumLot                     AS DECIMAL   INITIAL ?  /*Lote mínimo. (Uso interno: campo=item.lote-minimo)*/
    FIELD InventoryControlType           AS INTEGER   INITIAL ?  /*Tipo de Controle de Estoque do Item. Valores: 1 Serial, 2 Número Série, 3 Lote, 4 Referência (Uso interno: campo = item.tipo-con-est Include ininc~\i01in122.i)*/
    FIELD FixedPeriod                    AS INTEGER   INITIAL ?  /*Período fixo padrão para os itens da família (item.periodo-fixo)*/
    FIELD QualityControlLeadTime         AS INTEGER   INITIAL ?  /*Prazo, em dias corridos, necessário para que o setor de CQ libere os materiais para o estoque, a contar da data do recebimento do material, para fins de inspeção. (Uso interno: Campo = mgind.item.res-cq-comp)*/
    FIELD ManufactureLeadTime            AS INTEGER   INITIAL ?  /*Prazo, em dias úteis, do ressuprimento de fabricação. (Uso interno: Campo = mgind.item.ressup-fabric)*/
    FIELD ManufactureAndQualityControlL_00 AS INTEGER INITIAL ?  /*Tempo, em dias úteis, decorrido entre a data de termino da ordem de produção e a de aprovação pelo setor de controle de qualidade, relativo ao item atual. (Uso interno: Campo = mgind.item.res-cq-fabri)*/
    FIELD VendorLeadTime                 AS INTEGER   INITIAL ?  /*Prazo médio, em dias corridos, necessário para que o fornecedor efetue a entrega dos materiais programados, a contar da data do pedido, até a data do efetivo recebimento na empresa. (Uso interno: Campo = mgind.item.res-for-comp)*/
    FIELD PurchasingLeadTime             AS INTEGER   INITIAL ?  /*Prazo, em dias corridos, necessário a que o departamento de compras efetive o ressuprimento do item. (Uso interno: Campo = mgind.item.res-int-comp)*/
    FIELD SafetyStockControlType         AS INTEGER   INITIAL ?  /*Tipo de controle do estoque de segurança. Valores: 1 - Quantidade, 2 - Tempo. (Uso interno: Campo = mgind.item.tipo-est-seg -  Include = ininc/i05in122.i )*/
    FIELD SafetyTime                     AS INTEGER   INITIAL ?  /*Tempo de segurança (em número de dias corridos). (Uso interno: Campo = mgind.item.tempo-segur)*/
    FIELD SafetyStock                    AS DECIMAL   INITIAL ?  /*Quantidade de segurança necessária para absorver flutuações de demanda ou de atrasos na entrega pelo Fornecedor. (Uso interno: Campo = mgind.item.quant-segur)*/
    FIELD WasteQuantity                  AS DECIMAL   INITIAL ?  /*Quantidade de perda do item por ordem de compra emitida. (Uso interno: Campo = mgind.item.quant-perda)*/
    FIELD FixedHorizon                   AS INTEGER   INITIAL ?  /*Horizonte Fixo de Planejamento (Uso interno: campo=item.horiz-fixo)*/
    FIELD PlannerCode                    AS CHARACTER INITIAL ?  /*Código do Planejador. (Uso interno: campo=item.cd-planejado)*/
    FIELD IsFractionizedQuantityItem     AS LOGICAL   INITIAL ?  /*Indica se a quantidade do item é fracionada ou não (Uso interno: campo=mgind.item.fraciona)*/
    FIELD Policy                         AS INTEGER   INITIAL ?  /*Política. Valores: 1-Período Fixo, 2- Lote Econômico, 3- Ordem, 4- Nível Superior, 4- Configurado, 6- Composto (Uso interno: campo=item.politica. Include ininc~\i04in122.i) */
    FIELD Priority                       AS INTEGER   INITIAL ?  /*Prioridade (Uso interno: campo=item.prioridade)*/
    FIELD LowerLevel                     AS INTEGER   INITIAL ?  /*Nível mais baixo do item  na estrutura (Uso interno: campo=mgind.item.niv-mais-bai)*/
    FIELD BuyerCode                      AS CHARACTER INITIAL ?  /*Código do comprador do item. (Uso interno: Campo = mgind.item.cod-comprado)*/
    FIELD ttItemID                       AS INTEGER   INITIAL ?
    INDEX ixttItemID                     IS PRIMARY UNIQUE 
          ttItemID                       ASCENDING.

DEFINE TEMP-TABLE ttComponentReferences NO-UNDO
    FIELD ComponentReferenceCode        AS CHARACTER INITIAL ?  /*Codigo da referencia do componente a ser relacionado (Uso interno: campo=mgind.ref-estrut.cod-ref-es)*/
    FIELD ItemReferenceCode             AS CHARACTER INITIAL ?  /*Codigo da referencia do componente a ser relacionado (Uso interno: campo=mgind.ref-estrut.cod-ref-it)*/
    FIELD ttComponentReferencesID       AS INTEGER   INITIAL ?
    FIELD ttStructureID                 AS INTEGER   INITIAL ?.

DEFINE TEMP-TABLE ttItemRouting NO-UNDO
    FIELD EndDateRouting                AS DATE      INITIAL ?  /*Data em que o roteiro de fabricacao do item se torna invalido. (Uso interno: Campo = mgind.rot-item.data-termino)*/
    FIELD ItemRoutingCode               AS CHARACTER INITIAL ?  /*Codigo do roteiro de fabricacao do item.                       (Uso interno: Campo = mgind.rot-item.cod-roteiro)*/
    FIELD RoutingSequence               AS INTEGER   INITIAL ?  /*Inserir a sequencia de cadastramento do item.                  (Uso interno: Campo = mgind.rot-item.sequencia)*/
    FIELD StartDateRouting              AS DATE      INITIAL ?  /*Data em que o roteiro de fabricacao do item se torna valido.   (Uso interno: Campo = mgind.rot-item.data-inicio)*/
    FIELD ttItemRoutingID               AS INTEGER   INITIAL ?
    INDEX ixttItemRoutingID             IS PRIMARY UNIQUE 
          ttItemRoutingID               ASCENDING.

DEFINE TEMP-TABLE ttOperationInformation NO-UNDO
    FIELD FinishlDate                   AS DATE      INITIAL ?  /*Data em que a operação deixou de ser efetiva. (mgind.operacao.data-termino, date (99/99/9999))*/
    FIELD InitialDate                   AS DATE      INITIAL ?  /*Data em que a operação passa a ser efetiva na ficha de produção. (mgind.operacao.data-inicio, date (99/99/9999))*/
    FIELD IsSignificantTime             AS LOGICAL   INITIAL ?  /*Tempo significativo. substring(mgind.operacao.char-1,41,1) - Release 204. mgind.operacao.tempo-sig, logical (Yes/No)*/
    FIELD MachineHours                  AS DECIMAL   INITIAL ?  /*Tempo máquina. (mgind.operacao.tempo-maquina, dec (>>>9.999))*/
    FIELD ManHours                      AS DECIMAL   INITIAL ?  /*Tempo homem. (mgind.operacao.tempo-homem, dec (>>>9.999))*/
    FIELD OperationCode                 AS INTEGER   INITIAL ?  /*Codigo da Operação. (mgind.operacao.op-codigo, int(>>>>9))*/
    FIELD OperationDescription          AS CHARACTER INITIAL ?  /*Descrição da Operação. (mgind.operacao.descricao, char x(34)*/
    FIELD OperationId                   AS INTEGER   INITIAL ?  /*ID da operação. (mgind.operacao.num-id-operacao, int(>>,>>>,>>9))*/
    FIELD OperationType                 AS INTEGER   INITIAL ?  /*Tipo de operação. (mgind.operacao.tipo-oper, int(>9)) - include: ininc/i01in263.i 1 - Interna 2 - Externa*/
    FIELD SetupTime                     AS DECIMAL   INITIAL ?  /*Tempo de preparação para um lote econômico de produção. (mgind.operacao.tempo-prepar, dec (>>>9.999))*/
    FIELD SetupReductionCode            AS CHARACTER INITIAL ?
    FIELD StandardOperationCode         AS INTEGER   INITIAL ?  /*Código da operação padrão. (mgind.operacao.nr-oper-pad int (>>>>>9). */
    FIELD ttOperationInformationID      AS INTEGER   INITIAL ?
    FIELD ttItemRoutingID               AS INTEGER   INITIAL ?
    FIELD Units                         AS INTEGER   INITIAL ?  /*Número de unidades produzidas por unidade de tempo. (mging.operacao.nr-unidades, int(>>>>>9)).*/
    FIELD WorkCenterCode                AS CHARACTER INITIAL ?  /*Código do grupo de máquina. (mgind.operacao.gm-codigo, char x(9))*/
    INDEX ixttOperationInformationID    IS PRIMARY UNIQUE 
          ttOperationInformationID      ASCENDING.

DEFINE TEMP-TABLE ttOperationOrderInformation NO-UNDO
    FIELD IsSignificantTime             AS LOGICAL   INITIAL ?  /*Indica se Tempo é Significativo. (Uso interno: campo:movind.oper-ord.tempo-sig Release 204=oper-ord.char-1,41,1)*/
    FIELD ItemCode                      AS CHARACTER INITIAL ?  
    FIELD MachineHours                  AS DECIMAL   INITIAL ?  /*Tempo Máquina. (Uso interno:campo:movind.oper-ord.tempo-maquina)*/
    FIELD ManHours                      AS DECIMAL   INITIAL ?  /*Tempo Homem. (Uso interno:campo:movind.oper-ord.tempo-homem)*/
    FIELD OperationID                   AS INTEGER   INITIAL ?  /*Número de Identificação da Operação. (Uso interno: campo:movind.oper-ord.num-id-operacao)*/
    FIELD OperationOrderCode            AS INTEGER   INITIAL ?  /*Código da Operação. (Uso interno:campo:movind.oper-ord.op-codigo)*/
    FIELD OperationOrderDescription     AS CHARACTER INITIAL ?  /*Descrição da Operação da Ordem de Produção. (Uso interno:campo:movind.oper-ord.descricao)*/
    FIELD OperationType                 AS INTEGER   INITIAL ?  /*Tipo da Operação. Valores: 1 Interna 2 Externa (Uso interno:campo:movind.oper-ord.tipo-oper include i01in261.i)*/
    FIELD RemainQuantity                AS DECIMAL   INITIAL ?  /*Quantidade restante a produzir. Refere-se ao cálculo dos campos movind.ord-prod.qt-ordem - movind.ord-prod.qt-produzida. (Uso interno:campo calculado)*/
    FIELD WorkCenterCode                AS CHARACTER INITIAL ?  /*Código do Recurso. (Uso interno: campo= movind.oper-ord.cod-recurso Release 204 = char-1,60,16)*/
    FIELD RoutingCode                   AS CHARACTER INITIAL ?  /*Código do Roteiro. (Uso interno: campo:movind.oper-ord.cod-roteiro)*/
    FIELD Sequence                      AS INTEGER   INITIAL ?  /*Número Sequencial da Operação . (Uso interno: campo:movind.oper-ord.sequencia)*/
    FIELD SetupTime                     AS DECIMAL   INITIAL ?  /*Tempo de Preparação para um lote econômico de produção. (Uso interno:campo:movind.oper-ord.tempo-prepar)*/
    FIELD Tool                          AS CHARACTER INITIAL ?  /*Ferramenta ou conjunto de ferramentas que é usado na operação. (Uso interno: campo:movind.oper-ord.ferramenta)*/
    FIELD ttOperationOrderInformationID AS INTEGER   INITIAL ?
    FIELD ttProductionOrderID           AS INTEGER   INITIAL ?
    FIELD MachineGroupCode              AS CHARACTER INITIAL ?.  /*Código do Grupo de Máquina.  (Uso interno:campo:movind.oper-ord.gm-codigo)*/

DEFINE TEMP-TABLE ttProductionOrder NO-UNDO
    FIELD BalanceQuantity               AS DECIMAL   INITIAL ?  /*Saldo (Uso interno: campo=movind.prazo-compra.quant-saldo)*/
    FIELD CustomerName                  AS CHARACTER INITIAL ?  /*Nome abreviado do cliente (Uso interno:campo =movind.ord-prod.nome-abrev)*/
    FIELD CustomerOrder                 AS CHARACTER INITIAL ?  /*Número do cliente (Uso interno: campo= movind.ord-prod.nr-pedido) */
    FIELD CustomerOrderSequence         AS INTEGER   INITIAL ?  /*Número da sequência do pedido do cliente (Uso interno: campo= movind.ord-prod.nr-sequencia)*/
    FIELD DeliveryDate                  AS DATE      INITIAL ?  /*Data da entrega do pedido (Uso interno: campo=movind.prazo-compra.dat-entrega)*/
    FIELD OrderItemDelivery             AS INTEGER   INITIAL ?  /*Número do pedido de entrega (Uso interno: campo=movind.ord-prod.nr-pedido) */
    FIELD OrderType                     AS INTEGER   INITIAL ?  /*Tipo da Ordem. Valores: 1-Ordem de Compra Firme, 2- Ordem de produção firme (Uso interno: campo= movdbr. ord-dbr.idi-tip-ord-dbr)*/
    FIELD Parcel                        AS INTEGER   INITIAL ?  /*Parcela da Ordem (Uso interno: campo= movind. prazo-compra.parcela) */
    FIELD PriorityProductionOrder       AS INTEGER   INITIAL ?  /*Nível de prioridade para a execução da Ordem de Produção, sendo 000 o mais prioritário e 999 o menos prioritário (Uso interno: campo= mgind.item.prioridade)*/
    FIELD ProductionOrderNumber         AS INTEGER   INITIAL ?  /*Número da Ordem de Produção (Uso interno: campo= movind.ord-prod.nr-ord-produ)*/
    FIELD ReferenceCode                 AS CHARACTER INITIAL ?  /*Código da referência do item. (Uso interno: campo=movind.ord-prod.cod-refer) */
    FIELD SiteCode                      AS CHARACTER INITIAL ?  /*Código do Estabelecimento  (Uso interno: campo= movind.ord-prod.cod-estabel)*/
    FIELD StartDate                     AS DATE      INITIAL ?  /*Data de início da Ordem (Uso interno: campo=movind.ord-prod.dt-inicio)*/
    FIELD ProductionOrderType           AS INTEGER   INITIAL ? /* tipo da ordem de produ‡Æo */
    FIELD OrderQuantity                 AS DECIMAL   INITIAL ? /* quantidade da ordem de produ‡Æo, serve para o calculo dos item com politica Ordem*/
    FIELD ttProductionOrderID           AS INTEGER   INITIAL ?
    INDEX ixttProductionOrderID         IS PRIMARY UNIQUE
          ttProductionOrderID           ASCENDING.

DEFINE TEMP-TABLE ttReference NO-UNDO
    FIELD ReferenceCode                 AS CHARACTER INITIAL ?  /*Codigo da referencia do item. (Uso interno: campo=ref-item.codigo-refer) */
    FIELD ttReferenceID                 AS INTEGER   INITIAL ?
    INDEX ixttReferenceID               IS PRIMARY UNIQUE 
          ttReferenceID                 ASCENDING.

DEFINE TEMP-TABLE ttReservesInformations NO-UNDO
    FIELD FatherItemCode                AS CHARACTER INITIAL ?  /*Código do Item Pai (Uso interno: campo=movind.reservas.item-pai)*/
    FIELD ItemCode                      AS CHARACTER INITIAL ?  /*Código do Item Reserva (Uso interno: campo=movind.reservas.it-codigo)*/
    FIELD BalanceQuantity               AS DECIMAL   INITIAL ?  /*Saldo - campo calculado (Uso interno: campo=movind.reservas.quant-orig - movind.reservas.quant-atend)*/
    FIELD OperationCode                 AS INTEGER   INITIAL ?  /*Código da operação. (Uso interno:campo:movind.reservas.op-codigo)*/
    FIELD ReferenceCode                 AS CHARACTER INITIAL ?  /*Código da referência da reserva. (Uso interno: campo=movind.reserva.cod-refer) */
    FIELD ReserveDate                   AS DATE      INITIAL ?  /*Data da Reserva (Uso interno: campo = movind.reservas.dt-reserva)*/
    FIELD RoutingCode                   AS CHARACTER INITIAL ?  /*Código do roteiro da reserva. (Uso interno: campo=movind.reservas.cod-roteiro)*/
    FIELD SurplusType                   AS INTEGER   INITIAL ?  /*Tipo de sobra para a reserva. Valores 1 Retorno de Requisição,2 Sobra, 3 Co-produto, 4 Normal. (Uso interno:campo=movind.reservas.tipo-sobra, include i01in068.i)*/
    FIELD AtendedByOtherOrder           AS LOGICAL   INITIAL ? /* indica se a reserva est  sendo atendida por outra ordem de produ‡Æo*/
    FIELD QuantityBeingAtended          AS DECIMAL   INITIAL ? /* se est  sendo atendida, em quando*/
    FIELD ttProductionOrderID           AS INTEGER   INITIAL ?
    FIELD ttReservesInformationsID      AS INTEGER   INITIAL ?.

DEFINE TEMP-TABLE ttSalesOrder NO-UNDO
    FIELD CreditApprovalCurrentStatus   AS INTEGER   INITIAL ?  /*Descrição: Situação de avaliação de crédito. Valores: 1- Nao Avaliado, 2- Avaliado, 3- Aprovado, 4- Não Aprovado 5- Pendente Informação (Uso interno: campo= ped-venda.cod-sit-aval  Include: diinc/i03di159.i)*/
    FIELD CustomerOrderNumber           AS CHARACTER INITIAL ?  /*Campo: ped-venda.nr-pedcli - Descrição: Número do pedido do cliente*/
    FIELD CustomerShortName             AS CHARACTER INITIAL ?  /*Nome abreviado do cliente (Uso interno: campo= ped-venda.nome-abrev)  */
    FIELD DeliveryDate                  AS DATE      INITIAL ?  /*Campo: ped-venda.dt-entrega - Descrição: Data prevista para entrega do Pedido*/
    FIELD DeliverySequence              AS INTEGER   INITIAL ?  /* Número de seqüência da entrega do item do pedido. (Uso interno: campo= ped-ent.nr-entrega).  */
    FIELD ItemReferenceCode             AS CHARACTER INITIAL ?  /*Código de referência do item. (Uso interno: campo= ped-item.cod-refer)  */
    FIELD MainSiteCode                  AS CHARACTER INITIAL ?  /*Código do estabelecimento (Uso interno: campo= ped-venda.cod-estabel)  */
    FIELD OrderLine                     AS INTEGER   INITIAL ?  /*Número sequencial do item para o pedido. (Uso interno: campo= ped-item. nr-sequencia.  */
    FIELD Priority                      AS INTEGER   INITIAL ?  /*Indica a prioridade de fornecimento dos pedidos para uma mesma data (Uso interno: campo= ped-venda.cod-priori) */
    FIELD QuantityBalance               AS DECIMAL   INITIAL ?  /*Saldo (Uso interno: campo calculado = (ped-ent.qt-pedida - ped-ent.qt-atendida) -  (ped-ent.qt-alocada - (ped-ent.qt-pendente + ped-ent.qt-atendida))*/
    FIELD ttSalesOrderID                AS INTEGER   INITIAL ?
    INDEX ixttSalesOrderID              IS PRIMARY UNIQUE
          ttSalesOrderID                ASCENDING.


DEFINE TEMP-TABLE ttSite NO-UNDO
    FIELD EconomicLot                       AS DECIMAL   INITIAL ?  /*Lote econômico padrão para os itens. (Uso interno:  campo=item-uni-estab.lote-economi)*/
    FIELD FixedHorizon                      AS INTEGER   INITIAL ?  /*Horizonte Fixo de Planejamento (Uso interno: campo=item-uni-estab.horiz-fixo)*/
    FIELD FixedPeriod                       AS INTEGER   INITIAL ?  /*Período fixo padrão para os itens do estabelecimento (item-uni-estab.periodo-fixo)*/
    FIELD ItemStatus                        AS INTEGER   INITIAL ?  /*Situação do item. Valores: 1-Ativo, 2- Obsoleto Ordens Automaticas, 3-Obsoleto Todas as Ordens, 4- Totalmente Obsoleto. (Uso interno:campo=item-uni-estab.cod-obsoleto. Include ininc~\i17in172.i)*/
    FIELD ManufactureAndQualityControlL_00  AS INTEGER   INITIAL ?  /*Tempo, em dias úteis, decorrido entre a data de termino da ordem de produção e a de aprovação pelo setor de controle de qualidade, relativo ao item atual. (Uso interno: Campo = mgind.item-uni-estab.res-cq-fabri)*/
    FIELD ManufactureLeadTime               AS INTEGER   INITIAL ?  /*Prazo, em dias úteis, do ressuprimento de fabricação. (Uso interno: Campo = mgind.item-uni-estab.ressup-fabric)*/
    FIELD MinimumLot                        AS DECIMAL   INITIAL ?  /*Lote mínimo. (Uso interno: campo=item-uni-estab.lote-minimo)*/
    FIELD MultipleBatch                     AS DECIMAL   INITIAL ?  /*Lote Multiplo para Itens  (Uso interno: campo=item-uni-estab.lote-multipl)*/
    FIELD OrderDivision                     AS INTEGER   INITIAL ?  /*Divisão de Ordens. Valores: 1-Não divide, 2-Lote múltiplo, 3-Lote econômico (Uso interno: campo=item-uni-estab.div-ordem Include ininc~\i12in122.i) */
    FIELD PlannerCode                       AS CHARACTER INITIAL ?  /*Código do Planejador. (Uso interno: campo=item-uni-estab.cd-planejado)*/
    FIELD Policy                            AS INTEGER   INITIAL ?  /*Política. Valores: 1-Período Fixo, 2- Lote Econômico, 3- Ordem, 4- Nível Superior, 4- Configurado, 6- Composto (Uso interno: campo=item-uni-estab.politica. Include ininc~\i04in122.i) */
    FIELD ProductionLineCode                AS INTEGER   INITIAL ?  /*Código da Linha de Produção. (Uso interno:campo=item-uni-estab.nr-linha)*/
    FIELD QualityControlLeadTime            AS INTEGER   INITIAL ?  /*Prazo, em dias corridos, necessário para que o setor de CQ libere os materiais para o estoque, a contar da data do recebimento do material, para fins de inspeção. (Uso interno: Campo = mgind.item-uni-estab.res-cq-comp)*/
    FIELD SafetyStock                       AS DECIMAL   INITIAL ?  /*Quantidade de segurança necessária para absorver flutuações de demanda ou de atrasos na entrega pelo Fornecedor. (Uso interno: Campo = mgind.item-uni-estab.quant-segur)*/
    FIELD SafetyTime                        AS INTEGER   INITIAL ?  /*Tempo de segurança (em número de dias corridos). (Uso interno: Campo = mgind.item-uni-estab.tempo-segur)*/
    FIELD ScrapFactor                       AS DECIMAL   INITIAL ?  /*Percentual de Refugo Padrão para os itens . (Uso interno:campo=item-uni-estab.fator-refugo)*/
    FIELD SiteCode                          AS CHARACTER INITIAL ?  /*Código do Estabelecimento do Item (Uso interno: campo= item-uni-estab.cod-estabel)*/
    FIELD ttSiteID                          AS INTEGER   INITIAL ?
    FIELD TypeAllot                         AS INTEGER   INITIAL ?  /*Tipo de alocação.Valores: 1 Total, 2 Parcial, 3 Proporcional. (Uso interno: campo=item-uni-estab.sit-aloc Include ininc~\i18in172.i)*/
    FIELD VendorLeadTime                    AS INTEGER   INITIAL ?  /*Prazo médio, em dias corridos, necessário para que o fornecedor efetue a entrega dos materiais programados, a contar da data do pedido, até a data do efetivo recebimento na empresa. (Uso interno: Campo = mgind.item-uni-estab.res-for-comp)*/
    FIELD WareHouseCode                     AS CHARACTER INITIAL ?  /*Código do Depósito do Item no Estabelecimento. (Uso interno:campo=mgind.item-uni-estab.deposito-pad)*/
    FIELD WasteQuantity                     AS DECIMAL   INITIAL ?  /*Quantidade de perda do item por ordem de compra emitida. (Uso interno: Campo = mgind.item-uni-estab.quant-perda)*/
    FIELD BuyerCode                         AS CHARACTER INITIAL ? /* codigo do comprador do item x estabelecimento */
    FIELD SafetyStockControlType            AS INTEGER INITIAL   ? /* tipo do estoque de seguran‡a */
    FIELD PurchasingLeadTime                AS INTEGER INITIAL ? /* ressuprimento interno de compras */
    FIELD Priority                          AS INTEGER INITIAL ? /* prioridade do item x estabelecimento */
    INDEX ixttSiteID                        IS PRIMARY UNIQUE
          ttSiteID ASCENDING.

DEFINE TEMP-TABLE ttStructure NO-UNDO
    FIELD ComponentCode                     AS CHARACTER INITIAL ?  /*Código do componente que faz parte da estrutura do produto (Uso interno: campo=estrutura.es-codigo)*/
    FIELD ComponentProportion               AS DECIMAL   INITIAL ?  /*Exibe o percentual para ratear a quantidade de componente dentro de uma programação de produção (Uso interno: campo=mgind.estrutura.proporcao)*/
    FIELD ComponentQuantity                 AS DECIMAL   INITIAL ?  /*Quantidade necessária do componente para atender à quantidade referência do item pai (Uso interno: campo=mgind.estrutura.qtd-compon)*/
    FIELD EndDate                           AS DATE      INITIAL ?  /*Data de fim da validade do componente na estrutura, mou seja, data em que o componente deixa de ser  efetivo na estrutura de produto (Uso interno: campo=mgind.estrutura.data-termino)*/
    FIELD ExcessiveMaterialType             AS INTEGER   INITIAL ?  /*Informação utilizada quando a quantidade da reserva do item é negativa. O sistema interpreta que uma reserva com quantidade negativa promove uma entrada no estoque. Valores: 1- Retorno de Requisição, 2- Sobra, 3- Co-produto, 4- Normal (Uso interno: campo=mgind.estrutura.tipo-sobra Include ininc~\i01in068.i)*/
    FIELD IsPhantom                         AS LOGICAL   INITIAL ?  /*Indica se a o item é um relacionamento fantasma ou não. É criado apenas para documentar uma fase de montagem de outro item (Uso interno: campo=estrutura.fantasma)*/
    FIELD ItemQuantity                      AS DECIMAL   INITIAL ?  /*Quantidade bruta que será usada para a geração das reservas e conseqüente movimentação nos estoques (Uso interno: campo=mgind.estrutura.qtd-item)*/
    FIELD OperationCode                     AS INTEGER   INITIAL ?  /*Código da operação informada no cadastro da estrutura do produto. Esta informação identifica em qual operação o componente é utilizado na montagem do produto acabado (Uso interno=campo:mgind.estrutura.op-codigo)*/
    FIELD RoutingCode                       AS CHARACTER INITIAL ?  /*Código do roteiro de fabricação ao qual o item possa estar vinculado. (Uso interno: campo=mgind.estrutura.cod-roteiro)*/
    FIELD SequenceNumber                    AS INTEGER   INITIAL ?  /*Indica a seqüência do componente na estrutura (Uso interno: campo=estrutura.sequencia)*/
    FIELD StartDate                         AS DATE      INITIAL ?  /*Data de início da validade do componente na estrutura, mou seja, data em que o componente passa a ser efetivo (Uso interno: campo=mgind.estrutura.data-inicio)*/
    FIELD ComponentListCode                 AS CHARACTER INITIAL ?  /*codigo da lista de componentes */
    FIELD ttStructureID                     AS INTEGER   INITIAL ?
    INDEX ixttStructureID                   IS PRIMARY UNIQUE
          ttStructureID ASCENDING.

DEFINE TEMP-TABLE ttToolsPerOperationInform_00 NO-UNDO
    FIELD AlternativeOperationCode          AS INTEGER   INITIAL ?  /*Codigo da Operação Alternativa. (Uso interno: campo=  (mgind.op-ferram.op-altern, int(>>>>9))*/
    FIELD OperationId                       AS INTEGER   INITIAL ?  /*ID da operação. (Uso interno: campo= mgind.operacao.num-id-operacao, int(>>,>>>,>>9))*/
    FIELD SequenceCode                      AS INTEGER   INITIAL ?  /*Prioridade de Sequência (Uso interno: campo = mgind.op-ferram.sequencia)*/
    FIELD ToolCode                          AS CHARACTER INITIAL ?  /*Código da Ferramenta da Operação (Uso interno: campo = mgind.op-ferram.ferramenta)*/
    FIELD ttOperationInformationID          AS INTEGER   INITIAL ?
    FIELD ttToolsPerOperationInform_00ID    AS INTEGER   INITIAL ?.

DEFINE TEMP-TABLE ttInventoryInformations NO-UNDO
    FIELD SiteID                            AS CHARACTER INITIAL ? /*Código do estabelecimento. (Uso interno: Campo = movind.movto-estoq.cod-estabel)*/
    FIELD ReferenceCode                     AS CHARACTER INITIAL ? /*Código da referência do item. (Uso interno: Campo = movind.movto-estoq.cod-refer)*/
    FIELD LotCode                           AS CHARACTER INITIAL ? /*Código do Lote (Uso interno campo=:movind.saldo-estoq.lote)*/
    FIELD LotValidityDate                   AS DATE      INITIAL ? /*Data de validade do lote informado. (Uso interno: Campo = movind.saldo-estoq.dt-vali-lote*/
    FIELD ImprovementRemittance             AS DECIMAL   INITIAL ?  /*Remessa para beneficiamento (Uso interno: tt-sdo-estoq-dbr.qtd-remes-benef)*/
    FIELD EntranceForImprovement            AS DECIMAL   INITIAL ? /*Entrada para beneficiamento (Uso interno: tt-sdo-estoq-dbr.qtd-entr-benef)*/
    FIELD ConsignmentContractEntrance       AS DECIMAL   INITIAL ? /*Entrada para consignação (Uso interno: tt-sdo-estoq-dbr.qtd-entr-consig)*/
    FIELD ConsigmentImprovement             AS DECIMAL   INITIAL ? /*Remessa para consignação (Uso interno: tt-sdo-estoq-dbr.qtd-remes-consig)*/
    FIELD Off-SiteTransference              AS DECIMAL   INITIAL ? /*Transferência para terceiros (Uso interno: tt-sdo-estoq-dbr.qtd-sdo-transi)*/
    FIELD On-HandBalance                    AS DECIMAL   INITIAL ? /*Quantidade em estoque. Campo calculado mediante alocação de pedidos e de ordens (Uso interno: movind.saldo-estoq.qtidade-atu)*/
    FIELD ttInventoryInformationsID         AS INTEGER   INITIAL ?.

DEFINE TEMP-TABLE ttWorkCenterOperation NO-UNDO
    FIELD idOperation             AS INTEGER        INITIAL ?
    FIELD operationAlternative    AS INTEGER        INITIAL ?
    FIELD jobCenter               AS CHARACTER      INITIAL ?
    FIELD Priority                AS INTEGER        INITIAL ?
    FIELD valuePerformance        AS DECIMAL        INITIAL ?
    FIELD ttWorkCenterOperationID AS INTEGER        INITIAL ?
    INDEX prior IS PRIMARY UNIQUE
          idOperation operationAlternative Priority.

DEFINE TEMP-TABLE ttProcessItem NO-UNDO
    FIELD ItemCode              AS CHARACTER   
    FIELD Sequence              AS INTEGER     
    FIELD Roadmap               AS CHARACTER   
    FIELD reference             AS CHARACTER   
    FIELD MinimumItemQuantity   AS DECIMAL     
    FIELD MaximumItemQuantity   AS DECIMAL     
    FIELD DefaultSiteCode       AS CHARACTER   
    FIELD NumberLine            AS INTEGER     
    FIELD StartDate             AS DATE        
    FIELD EndDate               AS DATE        
    FIELD ProcedureRule         AS CHARACTER   
    FIELD ComponentCodeList     AS CHARACTER   
    FIELD ValueRatio            AS DECIMAL     
    FIELD ttProcessItemID       AS INTEGER.

DEFINE TEMP-TABLE ttBalanceThird NO-UNDO
    field ItemCode                AS CHARACTER    
    field QuantityBalance         AS DECIMAL     
    field ProductionEstablishment AS CHARACTER   
    field RequestingEstablishment AS CHARACTER   
    field TypeBalance             AS INTEGER     
    field reference               AS CHARACTER   
    field Issue                   AS DATE
    FIELD ttBalanceThirdID        AS INTEGER.

DEFINE TEMP-TABLE ttVariableProcess NO-UNDO
    FIELD   SequenceNumber      AS INTEGER INITIAL ? /* sequencia */
    FIELD   RoutingCode         AS CHARACTER INITIAL ? /* codigo do roteiro */
    FIELD   ReferenceCode       AS CHARACTER INITIAL ? /* codigo da referencia */
    FIELD   SiteCode            AS CHARACTER INITIAL ? /* codigo do estabelecimento */
    FIELD   ProductionLineCode  AS INTEGER INITIAL ? /* codigo da linha de produ‡Æo */
    FIELD   InitialDate         AS DATE INITIAL ? /* data de inicio validade */
    FIELD   FinishDate          AS DATE INITIAL ? /* data de fim da validade */
    FIELD   MinimumItemQuantity AS DECIMAL INITIAL ? /* quantidade minima de fabrica‡Æo*/
    FIELD   MaximumItemQuantity AS DECIMAL INITIAL ? /* quantidade maxima de fabrica‡Æo*/
    FIELD   ProcessDescription  AS CHARACTER INITIAL ? /* descri‡Æo da regra do processo*/
    FIELD   ComponentListCode   AS CHARACTER INITIAL ?  /*codigo da lista de componentes */
    FIELD   ttVariableProcessID AS INTEGER INITIAL ?.
   
DEFINE TEMP-TABLE ttOperationWorkCenterInform NO-UNDO
    FIELD ttOperationInformationID AS INTEGER INITIAL ?
    FIELD AlternativeOperationCode AS INTEGER INITIAL ?
    FIELD WorkCenterCode AS CHARACTER INITIAL ?
    FIELD Priority AS INTEGER INITIAL ?
    FIELD Performance AS DECIMAL INITIAL ?
.

{adapters/xml/dbr/axsdb018extradeclarations.i}

/* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
{xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

IF  cReturnValue <> "OK":U THEN DO:
    {utp/ut-liter.i Erro_ao_executar_MessageHandle:_ *}
    RUN utp/ut-msgs.p(INPUT "msg":U,
                      INPUT 17006,
                      RETURN-VALUE + cReturnValue + "~~":U +
                      RETURN-VALUE + cReturnValue).
    CREATE tt-erro.
    ASSIGN tt-erro.i-sequen = iSeqErro
           tt-erro.cd-erro  = 17006
           tt-erro.mensagem = RETURN-VALUE
           iSeqErro         = iSeqErro + 1.
           
    RETURN "NOK":U.
END.


/* Handle do BusinessContent */
DEFINE VAR hBusinessContent AS HANDLE NO-UNDO.
CREATE X-DOCUMENT hBusinessContent.


/* VARIABEL PARA ARMAZENAR OS VALORES OBTIDOS NA INICIALIZACAO DO loalGenXml */
DEFINE VAR hGenXml          AS HANDLE NO-UNDO.

/* VERIFICA SE APIXML ESTA NA MEMORIA */
{xmlinc/xmlloadgenxml.i &GenXml="hGenXml" &GXReturnValue="cReturnValue"}

IF  cReturnValue <> "OK":U THEN DO:
    {utp/ut-liter.i Erro_ao_carregar_a_API_XML:_ *}
    CREATE tt-erro.
    ASSIGN tt-erro.i-sequen = iSeqErro
           tt-erro.cd-erro  = 17006
           tt-erro.mensagem = RETURN-VALUE + cReturnValue
           iSeqErro         = iSeqErro + 1.
    RETURN "NOK":U.
END.
    
DEFINE TEMP-TABLE ttStack NO-UNDO
    FIELD ttID AS INTEGER
    FIELD ttPos AS INTEGER
    INDEX tt_id IS PRIMARY UNIQUE
          ttID  ASCENDING.

FUNCTION addStack RETURN INTEGER (INPUT val AS INTEGER).
    DEFINE VAR id AS INTEGER INITIAL 1 NO-UNDO.

    FIND LAST ttStack NO-ERROR.
    IF  AVAIL(ttStack) THEN
        id = ttStack.ttID + 1.

    CREATE ttStack.
    ASSIGN ttStack.ttID  = id
           ttStack.ttPos = val.
END FUNCTION.

FUNCTION delStack RETURN INTEGER.
    FIND LAST ttStack NO-ERROR.
    IF  AVAIL(ttStack) THEN
        DELETE ttStack.

    FIND LAST ttStack NO-ERROR.

END FUNCTION.

FUNCTION getStack RETURN INTEGER.
    IF  AVAIL(ttStack) THEN
        RETURN ttStack.ttPos.
    ELSE
        RETURN 0.
END FUNCTION.


/* INTERNAL PROCEDURES */
PROCEDURE PIUpsert:

    /*PARAMETERS*/
    DEFINE INPUT  PARAM cTranAction           AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM cProgName             AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM cProgVersion          AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR ttItem.                      
    DEFINE INPUT  PARAM TABLE FOR ttSite.                      
    DEFINE INPUT  PARAM TABLE FOR ttReference.                 
    DEFINE INPUT  PARAM TABLE FOR ttStructure.                 
    DEFINE INPUT  PARAM TABLE FOR ttComponentReferences.       
    DEFINE INPUT  PARAM TABLE FOR ttItemRouting.               
    DEFINE INPUT  PARAM TABLE FOR ttOperationInformation.      
    DEFINE INPUT  PARAM TABLE FOR ttToolsPerOperationInform_00.
    DEFINE INPUT  PARAM TABLE FOR ttProductionOrder.           
    DEFINE INPUT  PARAM TABLE FOR ttOperationOrderInformation. 
    DEFINE INPUT  PARAM TABLE FOR ttReservesInformations.      
    DEFINE INPUT  PARAM TABLE FOR ttInventoryInformations.     
    DEFINE INPUT  PARAM TABLE FOR ttSalesOrder. 
    DEFINE INPUT  PARAM TABLE FOR ttVariableProcess.
    DEFINE INPUT  PARAM TABLE FOR ttOperationWorkCenterInform.
    DEFINE INPUT  PARAM de-val-refer-atualiz  AS DECIMAL   INITIAL ? NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.     


    /*LOCAL VARIABLES*/
    DEFINE VAR iCount       AS INTEGER INITIAL ? NO-UNDO.
    DEFINE VAR iId          AS INTEGER INITIAL ? NO-UNDO.
    DEFINE VAR pErrorId     AS INTEGER INITIAL ? NO-UNDO.
    DEFINE VAR pErrorType   AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE VAR pTotalErrors AS INTEGER INITIAL ? NO-UNDO.


    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */
    
    /* VERIFICA SE MessageHandler.p ESTA NA MEMORIA */
    {xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

    IF  cReturnValue <> "OK":U THEN DO:                      
        {utp/ut-liter.i Erro_ao_executar_MessageHandle:_ *}  
        CREATE tt-erro.                                      
        ASSIGN tt-erro.i-sequen = iSeqErro                   
               tt-erro.cd-erro  = 17006                      
               tt-erro.mensagem = RETURN-VALUE + cReturnValue
               iSeqErro         = iSeqErro + 1.              
        RETURN "NOK":U.                                 
    END.                                                     

    RUN isSubscribed IN hMessageHandler ("{&XmlProdName}", 
                                         "{&XmlApp}", 
                                         "{&XmlTranName}", 
                                         "{&XmlTranVersion}", 
                                         "":U, 
                                         cTranAction, 
                                         OUTPUT lCreateMsg).
    
    IF  RETURN-VALUE <> "OK":U THEN DO:
        ASSIGN cReturnValue = RETURN-VALUE.
        {utp/ut-liter.i Erro_ao_executar_isSubscribed_no_MessageHandle:_ *}
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = iSeqErro
               tt-erro.cd-erro  = 17006
               tt-erro.mensagem = RETURN-VALUE + cReturnValue
               iSeqErro         = iSeqErro + 1.
        RETURN "NOK":U.
    END.

    IF  NOT lCreateMsg THEN
        RETURN "OK":U.

    /* PREENCHE O VALOR DO ELEM. Comment DE TransactionId */
    RUN setTransInfoComment IN hMessageHandler ("Programa: " + cProgName + " - " + "VersÆo: " + cProgVersion).
    
    /* SETA SystemId */
    RUN setSystemId IN hMessageHandler ("{&XmlMod}",  "{&XmlProdVersion}").

    FIND FIRST ttItem NO-LOCK NO-ERROR.
    IF  AVAIL ttItem THEN DO:
    
        IF  ttItem.ItemCode = "" THEN
            RUN setKeyFields IN hMessageHandler ("tt-item.it-codigo":U, "*").
        ELSE
            RUN setKeyFields IN hMessageHandler ("tt-item.it-codigo":U, ttItem.ItemCode).
    END.

    /* INFORMA A EMPRESA E O ESTABELECIMENTO */
    RUN setCompanyId IN hMessageHandler (STRING(v_cdn_empres_usuar), "":U).

    /* RESETA OS VALORES */
    RUN reset IN hGenXml.

    /* SETA VALOR DE ENCODING */
    RUN setEncoding IN hGenXml ("UTF-8":U).

    RUN addNode IN hGenXml (getStack(), "Upsert":U, "":U, OUTPUT iId).
    addStack(iId).
    FIND FIRST ttItem NO-ERROR.
    IF AVAIL ttItem THEN DO:
       
        RUN addNode IN hGenXml (getStack(), "ItemCode":U, ttItem.ItemCode, OUTPUT iId).
        RUN addNode IN hGenXml (getStack(), "ItemDescription":U, ttItem.ItemDescription, OUTPUT iId).
        RUN addNode IN hGenXml (getStack(), "MaterialFamilyCode":U, ttItem.MaterialFamilyCode, OUTPUT iId).
        RUN addNodeDec IN hGenXml (getStack(), "InventoryGroupCode":U, ttItem.InventoryGroupCode, OUTPUT iId).
        RUN addNode IN hGenXml (getStack(), "UnitOfMeasureCode":U, ttItem.UnitOfMeasureCode, OUTPUT iId).
        IF  ttItem.DefaultSiteCode <> ? THEN
            RUN addNode IN hGenXml (getStack(), "DefaultSiteCode":U, ttItem.DefaultSiteCode, OUTPUT iId).
        IF  ttItem.ItemStatus <> ? THEN
            RUN addNodeDec IN hGenXml (getStack(), "ItemStatus":U, ttItem.ItemStatus, OUTPUT iId).
        IF  ttItem.CommercialFamilyCode <> ? THEN
            RUN addNode IN hGenXml (getStack(), "CommercialFamilyCode":U, ttItem.CommercialFamilyCode, OUTPUT iId).
        IF  ttItem.BougthOrManufacturedItem <> ? THEN 
            RUN addNodeDec IN hGenXml (getStack(), "BougthOrManufacturedItem":U, ttItem.BougthOrManufacturedItem, OUTPUT iId).
        IF  ttItem.ScrapFactor <> ? THEN
            RUN addNodeDec IN hGenXml (getStack(), "ScrapFactor":U, ttItem.ScrapFactor, OUTPUT iId).
        IF  ttItem.OrderDivision <> ? THEN 
            RUN addNodeDec IN hGenXml (getStack(), "OrderDivision":U, ttItem.OrderDivision, OUTPUT iId).
        IF  ttItem.EconomicLot <> ? THEN 
            RUN addNodeDec IN hGenXml (getStack(), "EconomicLot":U, ttItem.EconomicLot, OUTPUT iId).
        IF  ttItem.MultipleBatch <> ? THEN 
            RUN addNodeDec IN hGenXml (getStack(), "MultipleBatch":U, ttItem.MultipleBatch, OUTPUT iId).
        IF  ttItem.MinimumLot <> ? THEN 
            RUN addNodeDec IN hGenXml (getStack(), "MinimumLot":U, ttItem.MinimumLot, OUTPUT iId).
        IF  ttItem.InventoryControlType <> ? THEN
            RUN addNodeDec IN hGenXml (getStack(), "InventoryControlType":U, ttItem.InventoryControlType, OUTPUT iId).
        IF  ttItem.FixedPeriod <> ? THEN  
            RUN addNodeDec IN hGenXml (getStack(), "FixedPeriod":U, ttItem.FixedPeriod, OUTPUT iId).
        IF  ttItem.QualityControlLeadTime <> ? THEN
            RUN addNodeDec IN hGenXml (getStack(), "QualityControlLeadTime":U, ttItem.QualityControlLeadTime, OUTPUT iId).
        IF  ttItem.ManufactureLeadTime <> ? THEN
            RUN addNodeDec IN hGenXml (getStack(), "ManufactureLeadTime":U, ttItem.ManufactureLeadTime, OUTPUT iId).
        IF  ttItem.ManufactureAndQualityControlL_00 <> ? THEN
            RUN addNodeDec IN hGenXml (getStack(), "ManufactureAndQualityControlLeadTime":U, ttItem.ManufactureAndQualityControlL_00, OUTPUT iId).
        IF  ttItem.VendorLeadTime <> ? THEN
            RUN addNodeDec IN hGenXml (getStack(), "VendorLeadTime":U, ttItem.VendorLeadTime, OUTPUT iId).
        IF  ttItem.PurchasingLeadTime <> ? THEN
            RUN addNodeDec IN hGenXml (getStack(), "PurchasingLeadTime":U, ttItem.PurchasingLeadTime, OUTPUT iId).
        IF  ttItem.SafetyStockControlType <> ? THEN
            RUN addNodeDec IN hGenXml (getStack(), "SafetyStockControlType":U, ttItem.SafetyStockControlType, OUTPUT iId).
        IF  ttItem.SafetyTime <> ? THEN
            RUN addNodeDec IN hGenXml (getStack(), "SafetyTime":U, ttItem.SafetyTime, OUTPUT iId).
        IF  ttItem.SafetyStock <> ? THEN 
            RUN addNodeDec IN hGenXml (getStack(), "SafetyStock":U, ttItem.SafetyStock, OUTPUT iId).
        IF  ttItem.WasteQuantity <> ? THEN 
            RUN addNodeDec IN hGenXml (getStack(), "WasteQuantity":U, ttItem.WasteQuantity, OUTPUT iId).
        IF  ttItem.FixedHorizon <> ? THEN
            RUN addNodeDec IN hGenXml (getStack(), "FixedHorizon":U, ttItem.FixedHorizon, OUTPUT iId).
        IF  ttItem.PlannerCode <> ? THEN
            RUN addNode IN hGenXml (getStack(), "PlannerCode":U, ttItem.PlannerCode, OUTPUT iId).
        IF  ttItem.IsFractionizedQuantityItem <> ? THEN
            RUN addNodeLog IN hGenXml (getStack(), "IsFractionizedQuantityItem":U, ttItem.IsFractionizedQuantityItem, OUTPUT iId).
        IF  ttItem.Policy <> ? THEN
            RUN addNodeDec IN hGenXml (getStack(), "Policy":U, ttItem.Policy, OUTPUT iId).
        IF  ttItem.Priority <> ? THEN
            RUN addNodeDec IN hGenXml (getStack(), "Priority":U, ttItem.Priority, OUTPUT iId).
        IF  ttItem.LowerLevel <> ? THEN
            RUN addNodeDec IN hGenXml (getStack(), "LowerLevel":U, ttItem.LowerLevel, OUTPUT iId).
        IF  ttItem.BuyerCode <> ? THEN
            RUN addNode IN hGenXml (getStack(), "BuyerCode":U, ttItem.BuyerCode, OUTPUT iId).

        FIND FIRST ttReference NO-ERROR.
        IF AVAIL ttReference THEN do:
        
            RUN addNode IN hGenXml (getStack(), "ListOfReference":U, "":U, OUTPUT iId).
            addStack(iId).

                FOR EACH ttReference:

                    RUN addNode IN hGenXml (getStack(), "Reference":U, "":U, OUTPUT iId).
                    addStack(iId).

                        RUN addNode IN hGenXml (getStack(), "ReferenceCode":U, ttReference.ReferenceCode, OUTPUT iId).
                    delStack().
                END.
            delStack().
        END.

        FIND FIRST ttSite NO-ERROR .
        IF AVAIL ttSite THEN DO:

            RUN addNode IN hGenXml (getStack(), "LisfOfSite":U, "":U, OUTPUT iId).
            addStack(iId).

                FOR EACH ttSite:

                    RUN addNode IN hGenXml (getStack(), "Site":U, "":U, OUTPUT iId).
                    addStack(iId).

                        RUN addNode IN hGenXml (getStack(), "SiteCode":U, ttSite.SiteCode, OUTPUT iId).
                        IF  ttSite.PlannerCode <> ? THEN 
                            RUN addNode IN hGenXml (getStack(), "PlannerCode":U, ttSite.PlannerCode, OUTPUT iId).
                        IF  ttSite.ScrapFactor <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "ScrapFactor":U, ttSite.ScrapFactor, OUTPUT iId).
                        IF  ttSite.WareHouseCode <> ? THEN
                            RUN addNode IN hGenXml (getStack(), "WareHouseCode":U, ttSite.WareHouseCode, OUTPUT iId).
                        IF  ttSite.TypeAllot <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "TypeAllot":U, ttSite.TypeAllot, OUTPUT iId).
                        IF  ttSite.FixedHorizon <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "FixedHorizon":U, ttSite.FixedHorizon, OUTPUT iId).
                        IF  ttSite.FixedPeriod <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "FixedPeriod":U, ttSite.FixedPeriod, OUTPUT iId).
                        IF  ttSite.Policy <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "Policy":U, ttSite.Policy, OUTPUT iId).
                        IF  ttSite.ProductionLineCode <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "ProductionLineCode":U, ttSite.ProductionLineCode, OUTPUT iId).
                        IF  ttSite.EconomicLot <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "EconomicLot":U, ttSite.EconomicLot, OUTPUT iId).
                        IF  ttSite.MinimumLot <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "MinimumLot":U, ttSite.MinimumLot, OUTPUT iId).
                        IF  ttSite.MultipleBatch <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "MultipleBatch":U, ttSite.MultipleBatch, OUTPUT iId).
                        IF  ttSite.WasteQuantity <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "WasteQuantity":U, ttSite.WasteQuantity, OUTPUT iId).
                        IF  ttSite.OrderDivision <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "OrderDivision":U, ttSite.OrderDivision, OUTPUT iId).
                        IF  ttSite.SafetyStock <> ? THEN 
                            RUN addNodeDec IN hGenXml (getStack(), "SafetyStock":U, ttSite.SafetyStock, OUTPUT iId).
                        IF  ttSite.SafetyTime <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "SafetyTime":U, ttSite.SafetyTime, OUTPUT iId).
                        IF  ttSite.QualityControlLeadTime <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "QualityControlLeadTime":U, ttSite.QualityControlLeadTime, OUTPUT iId).
                        IF  ttSite.ManufactureAndQualityControlL_00 <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "ManufactureAndQualityControlLeadTime":U, ttSite.ManufactureAndQualityControlL_00, OUTPUT iId).
                        IF  ttSite.ManufactureLeadTime <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "ManufactureLeadTime":U, ttSite.ManufactureLeadTime, OUTPUT iId).
                        IF  ttSite.VendorLeadTime <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "VendorLeadTime":U, ttSite.VendorLeadTime, OUTPUT iId).
                        IF  ttSite.ItemStatus <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "ItemStatus":U, ttSite.ItemStatus, OUTPUT iId).
                        IF  ttSite.BuyerCode <> ? THEN
                            RUN addNode IN hGenXml (getStack(), "BuyerCode":U, ttSite.BuyerCode , OUTPUT iId).
                        IF  ttSite.SafetyStockControlType <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "SafetyStockControlType":U, ttSite.SafetyStockControlType , OUTPUT iId).
                        IF  ttSite.PurchasingLeadTime <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "PurchasingLeadTime":U, ttSite.PurchasingLeadTime , OUTPUT iId).
                        IF  ttSite.Priority <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "Priority":U, ttSite.Priority , OUTPUT iId).

                    delStack().
                END.
            delStack().
        END.

        FIND FIRST ttItemRouting NO-ERROR.
        IF AVAIL ttItemRouting THEN DO: 

            RUN addNode IN hGenXml (getStack(), "ListOfItemRouting", "", OUTPUT iId).
            addStack(iId).

                FOR EACH ttItemRouting:
                    RUN addNode IN hGenXml (getStack(), "ItemRouting", "", OUTPUT iId).
                    addStack(iId).

                         RUN addNodeDec IN hGenXml (getStack(), "RoutingSequence", ttItemRouting.RoutingSequence, OUTPUT iId).
                         RUN addNode IN hGenXml (getStack(), "ItemRoutingCode", ttItemRouting.ItemRoutingCode, OUTPUT iId).

                         IF  ttItemRouting.StartDateRouting <> ? THEN
                         RUN addNodeDate IN hGenXml (getStack(), "StartDateRouting", ttItemRouting.StartDateRouting, OUTPUT iId).

                         IF  ttItemRouting.EndDateRouting <> ? THEN
                         RUN addNodeDate IN hGenXml (getStack(), "EndDateRouting", ttItemRouting.EndDateRouting, OUTPUT iId).
                    delStack().

                END.
            delStack().
        END.
        FIND FIRST ttOperationInformation NO-ERROR.

        IF  AVAIL ttOperationInformation THEN DO:
    
            RUN addNode IN hGenXml (getStack(), "ListOfOperation":U, "":U, OUTPUT iId).
            addStack(iId).
    
                FOR EACH ttOperationInformation:
    
                    RUN addNode IN hGenXml (getStack(), "OperationInformation":U, "":U, OUTPUT iId).
                    addStack(iId).
    
                        RUN addNode IN hGenXml (getStack(), "Operation":U, "":U, OUTPUT iId).
                        addStack(iId).
    
                             RUN addNodeDec IN hGenXml (getStack(), "OperationCode":U, ttOperationInformation.OperationCode, OUTPUT iId).
                             RUN addNode IN hGenXml (getStack(), "OperationDescription":U, ttOperationInformation.OperationDescription, OUTPUT iId).
                             IF  ttOperationInformation.OperationId <> ? THEN
                                 RUN addNodeDec IN hGenXml (getStack(), "OperationId":U, ttOperationInformation.OperationId, OUTPUT iId).
                             IF  ttOperationInformation.OperationType <> ? THEN
                                 RUN addNodeDec IN hGenXml (getStack(), "OperationType":U, ttOperationInformation.OperationType, OUTPUT iId).
                        delStack().
    
                        IF  ttOperationInformation.Units <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "Units":U, ttOperationInformation.Units, OUTPUT iId).
                        IF  ttOperationInformation.WorkCenterCode <> ? THEN
                            RUN addNode IN hGenXml (getStack(), "WorkCenterCode":U, ttOperationInformation.WorkCenterCode, OUTPUT iId).
    
                        RUN addNode IN hGenXml (getStack(), "TimeOperInformation":U, "":U, OUTPUT iId).
                        addStack(iId).
    
                            IF  ttOperationInformation.SetupTime <> ? THEN 
                                RUN addNodeDec IN hGenXml (getStack(), "SetupTime":U, ttOperationInformation.SetupTime, OUTPUT iId).
                            IF  ttOperationInformation.ManHours <> ? THEN
                                RUN addNodeDec IN hGenXml (getStack(), "ManHours":U, ttOperationInformation.ManHours, OUTPUT iId).
                            IF  ttOperationInformation.MachineHours <> ? THEN
                                RUN addNodeDec IN hGenXml (getStack(), "MachineHours":U, ttOperationInformation.MachineHours, OUTPUT iId).
                        delStack().
    
                        RUN addNode IN hGenXml (getStack(), "DateOperInformation":U, "":U, OUTPUT iId).
                        addStack(iId).
    
                            IF  ttOperationInformation.InitialDate <> ? THEN
                                RUN addNodeDate IN hGenXml (getStack(), "InitialDate":U, ttOperationInformation.InitialDate, OUTPUT iId).
                            IF  ttOperationInformation.FinishlDate <> ? THEN
                                RUN addNodeDate IN hGenXml (getStack(), "FinishDate":U, ttOperationInformation.FinishlDate, OUTPUT iId).
                        delStack().
    
                        IF  ttOperationInformation.IsSignificantTime <> ? THEN
                            RUN addNodeLog IN hGenXml (getStack(), "IsSignificantTime":U, ttOperationInformation.IsSignificantTime, OUTPUT iId).
                        IF  ttOperationInformation.StandardOperationCode <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "StandardOperationCode":U, ttOperationInformation.StandardOperationCode, OUTPUT iId).

                        RUN addNode IN hGenXml (getStack(), "SetupReductionCode":U, ttOperationInformation.SetupReductionCode, OUTPUT iId).
                        
                        IF  CAN-FIND (FIRST  ttToolsPerOperationInform_00 
                                       WHERE ttToolsPerOperationInform_00.ttOperationInformationID = ttOperationInformation.ttOperationInformationID) THEN DO:
    
                            RUN addNode IN hGenXml (getStack(), "ListOfToolsPerOperation":U, "":U, OUTPUT iId).
                            addStack(iId).
    
                                FOR EACH ttToolsPerOperationInform_00 OF ttOperationInformation:
    
                                    RUN addNode IN hGenXml (getStack(), "ToolsPerOperationInformation":U, "":U, OUTPUT iId).
                                    addStack(iId).
    
                                        RUN addNode IN hGenXml (getStack(), "ToolCode":U, ttToolsPerOperationInform_00.ToolCode, OUTPUT iId).
                                        RUN addNode IN hGenXml (getStack(), "Operation":U, "":U, OUTPUT iId).
                                        addStack(iId).
    
                                            IF  ttToolsPerOperationInform_00.OperationId <> ? THEN
                                                RUN addNodeDec IN hGenXml (getStack(), "OperationId":U, ttToolsPerOperationInform_00.OperationId, OUTPUT iId).
                                            IF  ttToolsPerOperationInform_00.AlternativeOperationCode <> ? THEN
                                                RUN addNodeDec IN hGenXml (getStack(), "AlternativeOperationCode":U, ttToolsPerOperationInform_00.AlternativeOperationCode, OUTPUT iId).
                                        delStack().
    
                                        IF  ttToolsPerOperationInform_00.SequenceCode <> ? THEN 
                                            RUN addNodeDec IN hGenXml (getStack(), "SequenceCode":U, ttToolsPerOperationInform_00.SequenceCode, OUTPUT iId).
                                    delStack().
                                END.
                            delStack().
                        END. 

                        /* AQUI */

                    delStack().
                END.
            delStack().
        END.
        FIND FIRST ttStructure NO-ERROR.

        IF  AVAIL ttStructure THEN DO:

            RUN addNode IN hGenXml (getStack(), "ListOfEstructure":U, "":U, OUTPUT iId).
            addStack(iId).

                FOR EACH ttStructure:

                    RUN addNode IN hGenXml (getStack(), "Structure":U, "":U, OUTPUT iId).
                    addStack(iId).

                        RUN addNode IN hGenXml (getStack(), "SequenceNumber":U, ttStructure.SequenceNumber, OUTPUT iId).
                        RUN addNode IN hGenXml (getStack(), "ComponentCode":U, ttStructure.ComponentCode, OUTPUT iId).
                        IF  ttStructure.IsPhantom <> ? THEN
                            RUN addNodeLog IN hGenXml (getStack(), "IsPhantom":U, ttStructure.IsPhantom, OUTPUT iId).
                        IF  ttStructure.OperationCode <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "OperationCode":U, ttStructure.OperationCode, OUTPUT iId).
                        IF  ttStructure.RoutingCode <> ? THEN
                            RUN addNode IN hGenXml (getStack(), "RoutingCode":U, ttStructure.RoutingCode, OUTPUT iId).
                        IF  ttStructure.ComponentProportion <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "ComponentProportion":U, ttStructure.ComponentProportion, OUTPUT iId).
                        IF  ttStructure.StartDate <> ? THEN
                            RUN addNodeDate IN hGenXml (getStack(), "StartDate":U, ttStructure.StartDate, OUTPUT iId).
                        IF  ttStructure.EndDate <> ? THEN
                            RUN addNodeDate IN hGenXml (getStack(), "EndDate":U, ttStructure.EndDate, OUTPUT iId).
                        RUN addNodeDec IN hGenXml (getStack(), "ItemQuantity":U, ttStructure.ItemQuantity, OUTPUT iId).
                        RUN addNodeDec IN hGenXml (getStack(), "ComponentQuantity":U, ttStructure.ComponentQuantity, OUTPUT iId).
                        IF  ttStructure.ExcessiveMaterialType <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "ExcessiveMaterialType":U, ttStructure.ExcessiveMaterialType, OUTPUT iId).
                        IF  ttStructure.ComponentListCode <> ? THEN
                            RUN addNode IN hGenXml (getStack(), "ComponentListCode":U, ttStructure.ComponentListCode, OUTPUT iId).


                        IF  CAN-FIND (FIRST  ttComponentReferences 
                                       WHERE ttComponentReferences.ttStructureID = ttStructure.ttStructureID) THEN DO:

                            RUN addNode IN hGenXml (getStack(), "ListOfComponentReferences":U, "":U, OUTPUT iId).
                            addStack(iId).

                                FOR EACH ttComponentReferences OF ttStructure:

                                    RUN addNode IN hGenXml (getStack(), "ComponentReferences":U, "":U, OUTPUT iId).
                                    addStack(iId).

                                         RUN addNode IN hGenXml (getStack(), "ItemReferenceCode":U, ttComponentReferences.ItemReferenceCode, OUTPUT iId).
                                         RUN addNode IN hGenXml (getStack(), "ComponentReferenceCode":U, ttComponentReferences.ComponentReferenceCode, OUTPUT iId).
                                    delStack().
                                END.
                            delStack().
                        END.
                    delStack().
                END.
            delStack().
        END. 
        FIND FIRST ttProductionOrder NO-ERROR.
        IF  AVAIL ttProductionOrder THEN DO:

            RUN addNode IN hGenXml (getStack(), "ListOfProductionOrder":U, "":U, OUTPUT iId).
            addStack(iId).

                FOR EACH ttProductionOrder:

                    RUN addNode IN hGenXml (getStack(), "ProductionOrder":U, "":U, OUTPUT iId).
                    addStack(iId).

                        RUN addNodeDec IN hGenXml (getStack(), "ProductionOrderNumber":U, ttProductionOrder.ProductionOrderNumber, OUTPUT iId).
                        IF  ttProductionOrder.SiteCode <> ? THEN
                            RUN addNode IN hGenXml (getStack(), "SiteCode":U, ttProductionOrder.SiteCode, OUTPUT iId).
                        IF  ttProductionOrder.ReferenceCode <> ? THEN 
                            RUN addNode IN hGenXml (getStack(), "ReferenceCode":U, ttProductionOrder.ReferenceCode, OUTPUT iId).
                        IF  ttProductionOrder.DeliveryDate <> ? THEN
                            RUN addNodeDate IN hGenXml (getStack(), "DeliveryDate":U, ttProductionOrder.DeliveryDate, OUTPUT iId).
                        IF  ttProductionOrder.OrderItemDelivery <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "OrderItemDelivery":U, ttProductionOrder.OrderItemDelivery, OUTPUT iId).

                        RUN addNode IN hGenXml (getStack(), "CustomerInformations":U, "":U, OUTPUT iId).
                        addStack(iId).

                            IF  ttProductionOrder.CustomerName <> ? THEN
                                RUN addNode IN hGenXml (getStack(), "CustomerName":U, ttProductionOrder.CustomerName, OUTPUT iId).
                            IF  ttProductionOrder.CustomerOrder <> ? THEN
                                RUN addNode IN hGenXml (getStack(), "CustomerOrder":U, ttProductionOrder.CustomerOrder, OUTPUT iId).
                            IF  ttProductionOrder.CustomerOrderSequence <> ? THEN
                                RUN addNodeDec IN hGenXml (getStack(), "CustomerOrderSequence":U, ttProductionOrder.CustomerOrderSequence, OUTPUT iId).
                        delStack().

                        IF  ttProductionOrder.Parcel <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "Parcel":U, ttProductionOrder.Parcel, OUTPUT iId).
                        IF  ttProductionOrder.PriorityProductionOrder <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "PriorityProductionOrder":U, ttProductionOrder.PriorityProductionOrder, OUTPUT iId).
                        IF  ttProductionOrder.PriorityProductionOrder <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "OrderType":U, ttProductionOrder.OrderType, OUTPUT iId).
                        IF ttProductionOrder.StartDate <> ? THEN
                        RUN addNodeDate IN hGenXml (getStack(), "StartDate":U, ttProductionOrder.StartDate, OUTPUT iId).
                        RUN addNodeDec IN hGenXml (getStack(), "BalanceQuantity":U, ttProductionOrder.BalanceQuantity, OUTPUT iId).
                        RUN addNodeDec IN hGenXml (getStack(), "ProductionOrderType":U, ttProductionOrder.ProductionOrderType, OUTPUT iId).
                        RUN addNodeDec IN hGenXml (getStack(), "OrderQuantity":U, ttProductionOrder.OrderQuantity, OUTPUT iId).

                        IF  CAN-FIND (FIRST  ttOperationOrderInformation
                                       WHERE ttOperationOrderInformation.ttProductionOrderID = ttProductionOrder.ttProductionOrderID) THEN DO:

                            RUN addNode IN hGenXml (getStack(), "ListOfOperationOrderInformation":U, "":U, OUTPUT iId).
                            addStack(iId).

                                FOR EACH ttOperationOrderInformation OF ttProductionOrder:

                                    RUN addNode IN hGenXml (getStack(), "OperationOrderInformation":U, "":U, OUTPUT iId).
                                    addStack(iId).

                                        RUN addNodeDec IN hGenXml (getStack(), "OperationOrderCode":U, ttOperationOrderInformation.OperationOrderCode, OUTPUT iId).
                                        IF  ttOperationOrderInformation.OperationOrderDescription <> ? THEN
                                            RUN addNode IN hGenXml (getStack(), "OperationOrderDescription":U, ttOperationOrderInformation.OperationOrderDescription, OUTPUT iId).
                                        RUN addNodeDec IN hGenXml (getStack(), "Sequence":U, ttOperationOrderInformation.Sequence, OUTPUT iId).

                                        IF  ttOperationOrderInformation.ItemCode <> ? THEN
                                            RUN addNode IN hGenXml (getStack(), "ItemCode":U, ttOperationOrderInformation.ItemCode, OUTPUT iId).

                                        IF  ttOperationOrderInformation.OperationType <> ? THEN
                                            RUN addNodeDec IN hGenXml (getStack(), "OperationType":U, ttOperationOrderInformation.OperationType, OUTPUT iId).
                                        IF  ttOperationOrderInformation.RoutingCode <> ? THEN
                                            RUN addNode IN hGenXml (getStack(), "RoutingCode":U, ttOperationOrderInformation.RoutingCode, OUTPUT iId).
                                        IF  ttOperationOrderInformation.MachineGroupCode <> ? THEN
                                            RUN addNode IN hGenXml (getStack(), "MachineGroupCode":U, ttOperationOrderInformation.MachineGroupCode, OUTPUT iId).
                                        IF  ttOperationOrderInformation.SetupTime <> ? THEN
                                            RUN addNodeDec IN hGenXml (getStack(), "SetupTime":U, ttOperationOrderInformation.SetupTime, OUTPUT iId).
                                        IF  ttOperationOrderInformation.ManHours <> ? THEN
                                            RUN addNodeDec IN hGenXml (getStack(), "ManHours":U, ttOperationOrderInformation.ManHours, OUTPUT iId).
                                        IF  ttOperationOrderInformation.MachineHours <> ? THEN
                                            RUN addNodeDec IN hGenXml (getStack(), "MachineHours":U, ttOperationOrderInformation.MachineHours, OUTPUT iId).
                                        IF  ttOperationOrderInformation.IsSignificantTime <> ? THEN
                                            RUN addNodeLog IN hGenXml (getStack(), "IsSignificantTime":U, ttOperationOrderInformation.IsSignificantTime, OUTPUT iId).
                                        IF  ttOperationOrderInformation.RemainQuantity <> ? THEN
                                            RUN addNodeDec IN hGenXml (getStack(), "RemainQuantity":U, ttOperationOrderInformation.RemainQuantity, OUTPUT iId).
                                        IF  ttOperationOrderInformation.WorkCenterCode <> ? THEN
                                            RUN addNode IN hGenXml (getStack(), "WorkCenterCode":U, ttOperationOrderInformation.WorkCenterCode, OUTPUT iId).
                                        IF  ttOperationOrderInformation.OperationID <> ? THEN
                                            RUN addNodeDec IN hGenXml (getStack(), "OperationID":U, ttOperationOrderInformation.OperationID, OUTPUT iId).
                                        IF  ttOperationOrderInformation.Tool <> ? THEN
                                            RUN addNode IN hGenXml (getStack(), "Tool":U, ttOperationOrderInformation.Tool, OUTPUT iId).
                                    delStack().
                                END.
                            delStack().
                        END.
                        FIND FIRST ttReservesInformations WHERE 
                                   ttReservesInformations.ttProductionOrderID = ttProductionOrder.ttProductionOrderID NO-ERROR.
                        IF AVAIL ttReservesInformations THEN DO:

                            RUN addNode IN hGenXml (getStack(), "ListOfReservesInformation":U, "":U, OUTPUT iId).
                            addStack(iId).

                                FOR EACH ttReservesInformations OF ttProductionOrder:

                                    RUN addNode IN hGenXml (getStack(), "ReservesInformations":U, "":U, OUTPUT iId).
                                    addStack(iId).

                                        RUN addNode IN hGenXml (getStack(), "FatherItemCode", ttReservesInformations.FatherItemCode, OUTPUT iId).
                                        RUN addNode IN hGenXml (getStack(), "ItemCode", ttReservesInformations.ItemCode, OUTPUT iId).
                                        IF  ttReservesInformations.RoutingCode <> ? THEN
                                            RUN addNode IN hGenXml (getStack(), "RoutingCode":U, ttReservesInformations.RoutingCode, OUTPUT iId).
                                        IF  ttReservesInformations.SurplusType <> ? THEN
                                            RUN addNodeDec IN hGenXml (getStack(), "SurplusType":U, ttReservesInformations.SurplusType, OUTPUT iId).
                                        IF  ttReservesInformations.ReserveDate <> ? THEN
                                            RUN addNodeDate IN hGenXml (getStack(), "ReserveDate", ttReservesInformations.ReserveDate, OUTPUT iId).
                                        IF  ttReservesInformations.ReferenceCode <> ? THEN
                                            RUN addNode IN hGenXml (getStack(), "ReferenceCode":U, ttReservesInformations.ReferenceCode, OUTPUT iId).
                                        IF  ttReservesInformations.OperationCode <> ? THEN
                                            RUN addNodeDec IN hGenXml (getStack(), "OperationCode":U, ttReservesInformations.OperationCode, OUTPUT iId).
                                        RUN addNodeDec IN hGenXml (getStack(), "BalanceQuantity":U, ttReservesInformations.BalanceQuantity, OUTPUT iId).
                                        RUN addNodeLog IN hGenXml (getStack(), "AtendedByOtherOrder":U, ttReservesInformations.AtendedByOtherOrder, OUTPUT iId).
                                        RUN addNodeDec IN hGenXml (getStack(), "QuantityBeingAtended":U, ttReservesInformations.QuantityBeingAtended, OUTPUT iId).
                                    delStack().
                                END.
                            delStack().
                        END.
                    delStack().
                END.
            delStack().
        END. 

        FIND FIRST ttInventoryInformations NO-ERROR.
        IF  AVAIL ttInventoryInformations THEN DO:
            RUN addNode IN hGenXml (getStack(), "ListOfInventoryInformations":U, "":U, OUTPUT iId).
            addStack(iId).

                FOR EACH ttInventoryInformations:

                    RUN addNode IN hGenXml (getStack(), "InventoryInformations":U, "":U, OUTPUT iId).
                    addStack(iId).
            
                        IF  ttInventoryInformations.SiteID <> ? THEN
                            RUN addNode IN hGenXml (getStack(), "SiteID":U, ttInventoryInformations.SiteID, OUTPUT iId).                                

                        IF  ttInventoryInformations.ReferenceCode <> ? THEN                                                                             
                            RUN addNode IN hGenXml (getStack(), "ReferenceCode":U, ttInventoryInformations.ReferenceCode, OUTPUT iId).                  
                        IF  ttInventoryInformations.LotCode <> ? THEN                                                                                   
                            RUN addNode IN hGenXml (getStack(), "LotCode":U, ttInventoryInformations.LotCode, OUTPUT iId).                           
                        IF  ttInventoryInformations.LotValidityDate <> ? THEN                                                                           
                            RUN addNodeDate IN hGenXml (getStack(), "LotValidityDate":U, ttInventoryInformations.LotValidityDate, OUTPUT iId).          
                        IF  ttInventoryInformations.ImprovementRemittance <> ? THEN                                                                     
                            RUN addNodeDec IN hGenXml (getStack(), "ImprovementRemittance":U, ttInventoryInformations.ImprovementRemittance, OUTPUT iId).
                        IF  ttInventoryInformations.EntranceForImprovement <> ? THEN                                                                    
                            RUN addNodeDec IN hGenXml (getStack(), "EntranceForImprovement":U, ttInventoryInformations.EntranceForImprovement, OUTPUT iId).
                        IF  ttInventoryInformations.ConsignmentContractEntrance <> ? THEN                                                               
                            RUN addNodeDec IN hGenXml (getStack(), "ConsignmentContractEntrance":U, ttInventoryInformations.ConsignmentContractEntrance, OUTPUT iId).
                        IF  ttInventoryInformations.ConsigmentImprovement <> ? THEN                                                                     
                            RUN addNodeDec IN hGenXml (getStack(), "ConsigmentImprovement":U, ttInventoryInformations.ConsigmentImprovement, OUTPUT iId).
                        IF  ttInventoryInformations.Off-SiteTransference <> ? THEN                                                                      
                            RUN addNodeDec IN hGenXml (getStack(), "Off-SiteTransference":U, ttInventoryInformations.Off-SiteTransference, OUTPUT iId). 
                        RUN addNodeDec IN hGenXml (getStack(), "On-HandBalance", ttInventoryInformations.On-HandBalance, OUTPUT iId).                   
                    delStack().
                END.
            delStack().
        END.
        FIND FIRST ttSalesOrder NO-ERROR.

        IF  AVAIL ttSalesOrder THEN DO:

            RUN addNode IN hGenXml (getStack(), "ListOfSalesOrder":U, "":U, OUTPUT iId).
            addStack(iId).

                FOR EACH ttSalesOrder:

                    RUN addNode IN hGenXml (getStack(), "SalesOrder":U, "":U, OUTPUT iId).
                    addStack(iId).

                        RUN addNode IN hGenXml (getStack(), "CustomerOrderNumber":U, ttSalesOrder.CustomerOrderNumber, OUTPUT iId).
                        IF  ttSalesOrder.CustomerShortName <> ? THEN
                            RUN addNode IN hGenXml (getStack(), "CustomerShortName":U, ttSalesOrder.CustomerShortName, OUTPUT iId).
                        IF  ttSalesOrder.OrderLine <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "OrderLine":U, ttSalesOrder.OrderLine, OUTPUT iId).
                        IF  ttSalesOrder.ItemReferenceCode <> ? THEN
                            RUN addNode IN hGenXml (getStack(), "ItemReferenceCode":U, ttSalesOrder.ItemReferenceCode, OUTPUT iId).
                        IF  ttSalesOrder.MainSiteCode <> ? THEN
                            RUN addNode IN hGenXml (getStack(), "MainSiteCode":U, ttSalesOrder.MainSiteCode, OUTPUT iId).
                        IF  ttSalesOrder.DeliveryDate <> ? THEN
                            RUN addNodeDate IN hGenXml (getStack(), "DeliveryDate":U, ttSalesOrder.DeliveryDate, OUTPUT iId).
                        IF  ttSalesOrder.DeliverySequence <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "DeliverySequence":U, ttSalesOrder.DeliverySequence, OUTPUT iId).
                        RUN addNodeDec IN hGenXml (getStack(), "QuantityBalance":U, ttSalesOrder.QuantityBalance, OUTPUT iId).
                        IF  ttSalesOrder.CreditApprovalCurrentStatus <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "CreditApprovalCurrentStatus":U, ttSalesOrder.CreditApprovalCurrentStatus, OUTPUT iId).
                        IF  ttSalesOrder.Priority <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "Priority":U, ttSalesOrder.Priority, OUTPUT iId).
                    delStack().
                END.
            delStack().
        END.

        FIND FIRST ttVariableProcess NO-ERROR.

        IF  AVAIL ttVariableProcess THEN DO:
        
            RUN addNode IN hGenXml (getStack(), "ListOfVariableProcess":U, "":U, OUTPUT iId).
            addStack(iId).
        
                FOR EACH ttVariableProcess:
        
                    RUN addNode IN hGenXml (getStack(), "VariableProcess":U, "":U, OUTPUT iId).
                    addStack(iId).
        
                        RUN addNode IN hGenXml (getStack(), "SequenceNumber":U, ttVariableProcess.SequenceNumber, OUTPUT iId).

                        RUN addNode IN hGenXml (getStack(), "RoutingCode":U, ttVariableProcess.RoutingCode, OUTPUT iId).

                        IF  ttVariableProcess.ReferenceCode <> ? THEN
                            RUN addNode IN hGenXml (getStack(), "ReferenceCode":U, ttVariableProcess.ReferenceCode, OUTPUT iId).

                        IF  ttVariableProcess.SiteCode <> ? THEN
                            RUN addNode IN hGenXml (getStack(), "SiteCode":U, ttVariableProcess.SiteCode, OUTPUT iId).

                        IF  ttVariableProcess.ProductionLineCode <> ? THEN
                            RUN addNodeDec IN hGenXml (getStack(), "ProductionLineCode":U, ttVariableProcess.ProductionLineCode, OUTPUT iId).

                        RUN addNodeDate IN hGenXml (getStack(), "InitialDate":U, ttVariableProcess.InitialDate, OUTPUT iId).
                        RUN addNodeDate IN hGenXml (getStack(), "FinishDate":U, ttVariableProcess.FinishDate, OUTPUT iId).

                        RUN addNodeDec IN hGenXml (getStack(), "MinimumItemQuantity":U, ttVariableProcess.MinimumItemQuantity, OUTPUT iId).
                        RUN addNodeDec IN hGenXml (getStack(), "MaximumItemQuantity":U, ttVariableProcess.MaximumItemQuantity, OUTPUT iId).

                        IF  ttVariableProcess.ProcessDescription <> ? THEN
                            RUN addNode IN hGenXml (getStack(), "ProcessDescription":U, ttVariableProcess.ProcessDescription, OUTPUT iId).

                        IF  ttVariableProcess.ComponentListCode <> ? THEN
                            RUN addNode IN hGenXml (getStack(), "ComponentListCode":U, ttVariableProcess.ComponentListCode, OUTPUT iId).

                    delStack().
                END.
            delStack().
        END.

        FIND FIRST ttOperationWorkCenterInform NO-ERROR.
        IF  AVAIL ttOperationWorkCenterInform THEN DO:

            RUN addNode IN hGenXml (getStack(), "ListOfOperationWorkCenterInform":U, "":U, OUTPUT iId).
            addStack(iId).
                
                FOR EACH ttOperationWorkCenterInform:

                    RUN addNode IN hGenXml (getStack(), "OperationWorkCenterInform":U, "":U, OUTPUT iId).
                    addStack(iId).

                        RUN addNodeDec IN hGenXml (getStack(), "ttOperationInformationID":U, ttOperationWorkCenterInform.ttOperationInformationID, OUTPUT iId).
                        RUN addNodeDec IN hGenXml (getStack(), "AlternativeOperationCode":U, ttOperationWorkCenterInform.AlternativeOperationCode, OUTPUT iId).
                        RUN addNode IN hGenXml (getStack(), "WorkCenterCode":U, ttOperationWorkCenterInform.WorkCenterCode, OUTPUT iId).
                        RUN addNodeDec IN hGenXml (getStack(), "Priority":U, ttOperationWorkCenterInform.Priority, OUTPUT iId).
                        RUN addNodeDec IN hGenXml (getStack(), "Performance":U, ttOperationWorkCenterInform.Performance, OUTPUT iId).

                    delStack().
                END.
            delStack().
        END.

        FIND FIRST ttWorkCenterOperation NO-ERROR.
        IF  AVAIL ttWorkCenterOperation THEN DO:                                                                                                
            RUN addNode IN hGenXml (getStack(), "ListOfWorkCenterOperation":U, "":U, OUTPUT iId).                                      
            addStack(iId).                                                                                                                        
                                                                                                                                                   
                FOR EACH ttWorkCenterOperation:                                                                                            

                    RUN addNode IN hGenXml (getStack(), "WorkCenterOperation":U, "":U, OUTPUT iId).
                    addStack(iId).
            
                        IF  ttWorkCenterOperation.idOperation <> ? THEN
                            RUN addNode IN hGenXml (getStack(), "IdOperation":U, ttWorkCenterOperation.idOperation, OUTPUT iId).                                
                        IF  ttWorkCenterOperation.OperationAlternative <> ? THEN                                                                             
                            RUN addNode IN hGenXml (getStack(), "OperationAlternative":U, ttWorkCenterOperation.OperationAlternative, OUTPUT iId).                  
                        IF  ttWorkCenterOperation.jobCenter <> ? THEN                                                                                   
                            RUN addNode IN hGenXml (getStack(), "jobCenter":U, ttWorkCenterOperation.jobCenter, OUTPUT iId).                           
                        IF  ttWorkCenterOperation.Priority <> ? THEN                                                                           
                            RUN addNodeDate IN hGenXml (getStack(), "Priority":U, ttWorkCenterOperation.Priority, OUTPUT iId).          
                        IF  ttWorkCenterOperation.valuePerformance <> ? THEN                                                                     
                            RUN addNodeDec IN hGenXml (getStack(), "valuePerformance":U, ttWorkCenterOperation.valuePerformance, OUTPUT iId).
                    delStack().
                END.
            delStack().
        END.  
                                                                                                                                      
        FIND FIRST ttProcessItem NO-ERROR.                                                                                                
        IF  AVAIL ttProcessItem THEN DO:                                                                                                       
            RUN addNode IN hGenXml (getStack(), "ListOfWorkCenterOperation":U, "":U, OUTPUT iId).                                               
            addStack(iId).                                                                                                                        
                                                                                                                                            
                FOR EACH ttProcessItem:                                                                                                 
                                                                                                                                               
                    RUN addNode IN hGenXml (getStack(), "WorkCenterOperation":U, "":U, OUTPUT iId).                                       
                    addStack(iId).
            
                        IF  ttProcessItem.ItemCode <> ? THEN
                            RUN addNode IN hGenXml (getStack(), "ItemCode":U, ttProcessItem.ItemCode, OUTPUT iId).              
                        IF  ttProcessItem.Sequence <> ? THEN                                                                             
                            RUN addNode IN hGenXml (getStack(), "Sequence":U, ttProcessItem.Sequence, OUTPUT iId).                  
                        IF  ttProcessItem.Roadmap <> ? THEN                                                                                   
                            RUN addNode IN hGenXml (getStack(), "Roadmap":U, ttProcessItem.Roadmap, OUTPUT iId).                           
                        IF  ttProcessItem.reference <> ? THEN                                                                           
                            RUN addNodeDate IN hGenXml (getStack(), "reference":U, ttProcessItem.reference, OUTPUT iId).          
                        IF  ttProcessItem.MinimumItemQuantity <> ? THEN                                                                     
                            RUN addNodeDec IN hGenXml (getStack(), "MinimumItemQuantity":U, ttProcessItem.MinimumItemQuantity, OUTPUT iId).
                        IF  ttProcessItem.MaximumItemQuantity <> ? THEN                                                                     
                            RUN addNodeDec IN hGenXml (getStack(), "MaximumItemQuantity":U, ttProcessItem.MaximumItemQuantity, OUTPUT iId).
                        IF  ttProcessItem.DefaultSiteCode <> ? THEN                                                                     
                            RUN addNode IN hGenXml (getStack(), "DefaultSiteCode":U, ttProcessItem.DefaultSiteCode, OUTPUT iId).
                        IF  ttProcessItem.StartDate <> ? THEN                                                                     
                            RUN addNodeDate IN hGenXml (getStack(), "StartDate":U, ttProcessItem.StartDate, OUTPUT iId).
                        IF  ttProcessItem.EndDate <> ? THEN                                                                     
                            RUN addNodeDate IN hGenXml (getStack(), "EndDate":U, ttProcessItem.EndDate, OUTPUT iId).
                        IF  ttProcessItem.ProcedureRule <> ? THEN                                                                     
                            RUN addNode IN hGenXml (getStack(), "ProcedureRule":U, ttProcessItem.ProcedureRule, OUTPUT iId).
                        IF  ttProcessItem.ComponentCodeList <> ? THEN                                                                     
                            RUN addNode IN hGenXml (getStack(), "ComponentCodeList":U, ttProcessItem.ComponentCodeList, OUTPUT iId).
                        IF  ttProcessItem.ValueRatio <> ? THEN                                                                     
                            RUN addNode IN hGenXml (getStack(), "ValueRatio":U, ttProcessItem.ValueRatio, OUTPUT iId).
                    delStack().
                END.
            delStack().
        END.

        RUN addNodeDec IN hGenXml (getStack(), "ReferenceValue":U, de-val-refer-atualiz, OUTPUT iId).

    END.
    delStack().

    /* OBTEM O XML NUMA HANDLE */
    RUN generateXML IN hGenXml (OUTPUT hBusinessContent).

    /* DEFINE O CONTEÚDO DO ELEMENTO BusinessContent */
    RUN setBusinessContent IN hMessageHandler (INPUT hBusinessContent).

    /* LIBERA MEMÓRIA ALOCADA PARA O OBJETO */
    DELETE OBJECT hBusinessContent NO-ERROR.

    /*CONTRÓI A MENSAGEM XML E ENVIA PARA O ControlBroker */
    RUN sendMessage IN hMessageHandler (INPUT "dbr/ItemDBR_204_200.xsd"). 

    /* VERIFICA SE OCORREU ALGUM ERRO */
    IF  RETURN-VALUE <> "OK":U THEN DO:
        ASSIGN cReturnValue = RETURN-VALUE.
        {utp/ut-liter.i Erro_no_envio_da_Mensagem:_ *}
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = iSeqErro
               tt-erro.cd-erro  = 17006
               tt-erro.mensagem = RETURN-VALUE + cReturnValue
               iSeqErro         = iSeqErro + 1.
        RETURN "NOK":U.
    END.

    /* VERIFICA SE A MENSAGEM FOI PROCESSADA COM SUCESSO */
    RUN getReturnStatus IN hMessageHandler (OUTPUT pSendSuccess, OUTPUT pTotalErrors).

    /* SE NAO ENVIO COM SUCESSO */
    IF  NOT pSendSuccess THEN DO:
        REPEAT iCount = 1 TO pTotalErrors:
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = iSeqErro
                   iSeqErro         = iSeqErro + 1.
            RUN getError IN hMessageHandler (INPUT  iCount,
                                             OUTPUT tt-erro.cd-erro,
                                             OUTPUT pErrorType,
                                             OUTPUT tt-erro.mensagem).
        END.
        RETURN "NOK":U.
    END.
    ELSE
        RETURN "OK":U.

    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

END PROCEDURE.

{adapters/xml/dbr/axsdb018upsert.i}


