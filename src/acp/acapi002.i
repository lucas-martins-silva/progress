/********************************************************************************
** Programa : acp/acapi002.i
**
** Data : 27/08/98
**
** Autor : Datasul S.A.
**
** Objetivo  : Include de Definicao, utilizada pela acp/acapi002.p.
**
** Ultima Alt: Eder Carlos Querino - Planner - Cria‡Æo - 27/08/1998
**
********************************************************************************/


def temp-table tt-configuracao
    field cod-versao-integracao as   integer format "999"
    field tipo-atu              as   integer format "9".

def temp-table tt-dados
    field nome-abrev           like ped-venda.nome-abrev /*o cliente original*/
    field nome-abrev-cotas     like ped-venda.nome-abrev /*cliente cfme tratado em cotas*/
    field nr-docto             like ped-venda.nr-pedcli
    field nr-sequencia         like ped-item.nr-sequencia
    field cod-estabel          like cotas.cod-estabel
    field cod-canal-venda      like cotas.cod-canal-venda
    field cod-gr-cli           like cotas.cod-gr-cli
    field nome-ab-reg          like cotas.nome-ab-reg
    field nome-mic-reg         like cotas.nome-mic-reg
    field cod-rep              like repres.cod-rep
    field it-codigo            like item.it-codigo
    field it-original          like item.it-codigo
    field dt-emissao           like ped-venda.dt-emissao
    field dt-entrega           like ped-item.dt-entrega
    field quantidade           like ped-item.qt-pedida
    field valor-unit-liq       like ped-item.vl-preuni
    field valor-unit-bru       like ped-item.vl-preuni
    field cod-sit-com          like ped-item.cod-sit-com 
    field tipo-pedido          like ped-item.esp-ped
    field nivel                as char
    field log-erro             as log
    field log-docto            as log format "Pedido/Nota Fiscal" init yes
    field log-tipo-oper        as int /*veja legenda no ac0923.p*/
    field cod-sit-ped          as int 
    field log-reprov-vend      as log /*usado na upc grendene para reprov vendedor*/
   
    &if defined (bf_dis_adm_cotas) &then
        index pedido is primary unique
                                        nr-docto
                                        nome-abrev
                                        it-original
                                        nr-sequencia
                                        cod-canal-venda
                                        cod-gr-cli
                                        nome-abrev-cotas
                                        nome-ab-reg 
                                        nome-mic-reg 
                                        cod-rep.
    &else
        index pedido is primary unique nome-abrev nr-docto it-original nr-sequencia.
    &endif  
   
   
    
def temp-table tt-erros
    field codigo-erro         as int
    field parametros          as char 
    field descricao           as char format "x(100)".
    
