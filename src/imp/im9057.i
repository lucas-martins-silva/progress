{include/i_dbvers.i}
/*******************************************************************************
**
**     IM9057.I - Definicao de variaveis e temp-tables.
**
*******************************************************************************/

DEFINE BUFFER b-embarque FOR embarque-imp.

DEFINE TEMP-TABLE tt-embarque no-undo
    field embarque          like embarque-imp.embarque
    field cod-estabel       like lin-i-ap.cod-estabel
    field desc-estab        like estabelec.nome
    field ep-codigo         like lin-i-ap.ep-codigo
    field cod-esp           like lin-i-ap.cod-esp
    field serie             like lin-i-ap.serie
    field nr-docto          as character format "x(16)" label "T¡tulo" column-label "T¡tulo"
    field parcela           like lin-i-ap.parcela
    field cod-fornec        like lin-i-ap.cod-fornec
    field desc-emit         like emitente.nome-abrev 
    field cod-itiner        like itinerario.cod-itiner
    field cod-incoterm      like incoterm-itiner.cod-incoterm
    field pto-incoterm      AS INTEGER label "Pto Incoterm" column-label "Pto Incoterm"
    field data-incoterm     AS DATE FORMAT "99/99/9999" LABEL "Dt Efetiva" column-label "Dt Efetiva"
    field pto-embarque      AS INTEGER label "Pto Embarque" column-label "Pto Embarque"
    field data-embarque     AS DATE FORMAT "99/99/9999" LABEL "Dt Efetiva" column-label "Dt Efetiva"
    field situacao          as char format "X(17)" LABEL "Situa‡Æo" column-label "Situa‡Æo"
    field desc-moeda        as character   format "x(8)" label "Moeda" column-label "Moeda"
    field data-emissao      like docum-est.dt-emissao
    field data-prev-pag     like tit-ap.dt-prev-pag
    field de-vl-orig        as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Original" column-label "Valor Original"    
    field de-vl-saldo       as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Saldo" column-label "Valor Saldo"       
    field de-vl-apres       as decimal format "->>>,>>>,>>>,>>9.99" initial 0
    field contabilizado     AS LOGICAL FORMAT "Sim/NÆo" label "Contabilizado" column-label "Contabilizado"
    INDEX codigo IS PRIMARY embarque
                            cod-estabel
                            ep-codigo   
                            cod-esp     
                            serie       
                            nr-docto    
                            parcela     
                            cod-fornec.

def var d-data-emb                    as   date                         no-undo.
def var i-pto-contr                   like pto-contr.cod-pto-contr      no-undo.
def var c-sit-proc                    as   char format "x(20)"          no-undo.               
def var c-sit-emb                     as   char format "x(15)"          no-undo. 
def var i-aux                         as   integer                      no-undo.

/* IM0088.I  */
