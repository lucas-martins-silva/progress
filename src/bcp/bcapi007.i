/**************************************************************************
**
**   Include: BCAPI007.I - Definicao das temp-table 
**                                       tt-etiqueta
**                                       tt-etiqueta-aux do coleta de dados
**
***************************************************************************/

def temp-table tt-etiqueta NO-UNDO
    field cod-versao-integracao as inte
    field i-sequen              as inte
    field nr-trans              as deci format "zzzzzzzzz9"
    field nr-trans-ant          as deci format "zzzzzzzzz9"
    field cd-trans              as char format "x(8)"
    field usuario               as char format "x(12)"
    field arquivo               as char format "x(100)"
    field cod-unico             as char format "x(16)"
    field it-codigo             as char format "x(16)"
    field dt-impressao          as date format "99/99/9999"
    field dt-val-lote           as date format "99/99/9999"
    field cod-depos             as char format "x(3)"
    field desc-item             as char format "x(36)"
    field cod-estabel           LIKE estabelec.cod-estabel
    field hora-Impressao        as char format "x(8)"
    field cod-localiz           as char format "x(20)"
    field lote                  as char format "x(40)"
    field nr-docto              as char format "x(16)"
    field quantidade            as deci format "->>>>,>>>,>>9.9999"
    field qt-etiqueta           as inte
    field cod-referencia        as char format "x(8)"
    field tipo-etiq             as inte format "9999"
    field desc-etiqueta         as char format "x(050)"
    field observacao            as char format "x(100)"
    field serie-docto           as char format "x(5)"
    field cod-emitente          as inte format ">>>>>9"
    field nat-operacao          as char format "9.99-XXX"
    field auxiliar-01           as char format "x(001)"
    field auxiliar-02           as char format "x(001)"
    field auxiliar-03           as char format "x(001)"
    field auxiliar-04           as char format "x(001)"
    field auxiliar-05           as char format "x(001)"
    field auxiliar-06           as char format "x(001)"
    field auxiliar-07           as char format "x(001)"
    field auxiliar-08           as char format "x(001)"
    field auxiliar-09           as char format "x(001)"
    field auxiliar-10           as char format "x(001)"
    index ch-seq is unique primary i-sequen.
