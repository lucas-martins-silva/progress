/********************************************************************************
** Programa : acp/acapi100.i
**
** Data : 15/02/2002
**
** Autor : Datasul S.A.
**
** Objetivo  : Include de Definicao, utilizada pela acapi100.p e bodi261.p
**
********************************************************************************/

DEF TEMP-TABLE tt-dados
    FIELD  cod-versao-integracao AS INT 
    FIELD  nome-abrev            LIKE ped-venda.nome-abrev /*o cliente original*/
    FIELD  nome-abrev-cotas      LIKE ped-venda.nome-abrev /*cliente cfme tratado em cotas*/
    FIELD  nr-docto              LIKE ped-venda.nr-pedcli
    FIELD  nr-sequencia          LIKE ped-item.nr-sequencia
    FIELD  cod-estabel           LIKE cotas.cod-estabel
    FIELD  cod-canal-venda       LIKE cotas.cod-canal-venda
    FIELD  cod-gr-cli            LIKE cotas.cod-gr-cli
    FIELD  nome-ab-reg           LIKE cotas.nome-ab-reg
    FIELD  nome-mic-reg          LIKE cotas.nome-mic-reg
    FIELD  cod-rep               LIKE repres.cod-rep
    FIELD  it-codigo             LIKE item.it-codigo
    FIELD  it-original           LIKE item.it-codigo
    FIELD  dt-emissao            LIKE ped-venda.dt-emissao
    FIELD  dt-entrega            LIKE ped-item.dt-entrega
    FIELD  quantidade            LIKE ped-item.qt-pedida
    FIELD  valor-unit-liq        LIKE ped-item.vl-preuni
    FIELD  valor-unit-bru        LIKE ped-item.vl-preuni
    FIELD  cod-sit-com           LIKE ped-item.cod-sit-com 
    FIELD  nivel                 AS char
    FIELD  log-erro              AS log
    FIELD  tp-docto              AS INT /* 1 = pedido , 2 = nota fiscal */
    FIELD  log-tipo-oper         AS INT /*veja legenda no acapi100.p*/
    FIELD  log-reprov-vend       AS LOG /*usado na upc grendene para reprov vendedor*/
    FIELD  quantidade-can        LIKE ped-item.qt-pedida
    FIELD  quantidade-sus        LIKE ped-item.qt-pedida
   
    INDEX pedido IS PRIMARY UNIQUE      nr-docto
                                        nome-abrev
                                        it-codigo
                                        nr-sequencia
                                        cod-canal-venda
                                        cod-gr-cli
                                        nome-abrev-cotas
                                        nome-ab-reg 
                                        nome-mic-reg 
                                        cod-rep.
       
    
DEF TEMP-TABLE tt-erros
    FIELD  cod-erro              AS INT
    FIELD  parametros            AS CHAR 
    FIELD  desc-erro             AS CHAR FORMAT "x(100)".
    

