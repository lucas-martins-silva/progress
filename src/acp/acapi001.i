/********************************************************************************
** Programa : acp/acapi001.i
**
** Data : 29/07/98
**
** Autor : Datasul S.A.
**
** Objetivo  : Include de Definicao, utilizada pela API utp/utapi006.p.
**
** Ultima Alt: Eder Carlos Querino - Planner - Cria‡Æo - 29/07/1998
**
********************************************************************************/

define temp-table tt-configuracao
    field versao-integracao   as integer format ">>9"
    field arquivo             as char    format "x(255)" initial "c:\tmp\utapi003.xls"
    field planilha            as integer format ">>"     initial 01 column-label "Planilha"
    field linha-inicio        as integer format ">9"     initial 01
    field coluna-inicio       as integer format ">9"     initial 01
    field coluna-final        as integer format ">9"     initial 01
    index tt-configuracao-pri is unique primary  versao-integracao.

def temp-table tt-dados
    field planilha            as int  format ">>"    column-label "Planilha"
    field celula-linha        as int  format ">>>"   column-label "Linha"
    field celula-coluna       as int  format ">>>"   column-label "Coluna"
    field valor               as char format "x(20)" column-label "Valor"
    index dados is primary unique planilha celula-linha celula-coluna.
    
def temp-table tt-erros
    field codigo-erro         as int
    field descricao           as char.
