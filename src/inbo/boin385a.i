/*
**  BOIN385.i
**
**  requisicao - Requisicao de Material de Estoque
**
**  Ultima altera‡Æo : 02/04/99 - GeraBO
*/
 
DEFINE TEMP-TABLE {1}
    field nr-requisicao  like it-requisicao.nr-requisicao
    field cod-estabel    like requisicao.cod-estabel
    field it-codigo      like it-requisicao.it-codigo
    field desc-item      like item.desc-item
    field loc-entrega    like requisicao.loc-entrega
    field qt-requisitada like it-requisicao.qt-requisitada
    field qt-atendida    like it-requisicao.qt-atendida
    field qt-devolvida   like it-requisicao.qt-devolvida
    field dt-requisicao  like requisicao.dt-requisicao
    field dt-atend       like it-requisicao.dt-atend
    field dt-devol       like requisicao.dt-devol
    field narrativa      like it-requisicao.narrativa
    field it-narrativa   like item.narrativa
    field r-rowid   as rowid.


