{include/i_dbvers.i}
def temp-table tt-docto-cr  no-undo
&IF "{&mguni_version}" >= "2.07A" &THEN
    FIELD ep-codigo      LIKE empresa.ep-codigo   init ""     format "x(03)"
&ELSE
    FIELD ep-codigo      as integer   init 0     format ">>9"
&ENDIF
    FIELD referencia     as character            format "x(10)"
&IF "{&mguni_version}" >= "2.07A" &THEN
    FIELD cod-estabel    as character            format "x(05)"
&ELSE
    FIELD cod-estabel    as character            format "x(3)"
&ENDIF
    FIELD cod-usuario    as character            format "x(12)"
    FIELD total-movto    as decimal              format ">>,>>>,>>>,>>9.99"
    FIELD dt-movto       as date      init today format "99/99/9999".

/* Utilizada para criacao da antecipacao */
def temp-table tt-linha-cr no-undo
&IF "{&mguni_version}" >= "2.07A" &THEN
    FIELD ep-codigo                 LIKE empresa.ep-codigo      init ""     format "x(03)"
&ELSE
    FIELD ep-codigo                 as inte      init 0     format ">>9"
&ENDIF
    FIELD referencia                as char                 format "x(10)"
    FIELD sequencia                 as inte      init 0     format ">>>,>>9"
    FIELD cod-esp                   as char                 format "!!"
&IF "{&mguni_version}" >= "2.07A" &THEN
    FIELD cod-estabel               as char                 format "x(05)"
&ELSE
    FIELD cod-estabel               as char                 format "x(3)"
&ENDIF
    FIELD nr-docto                  as char                 format "x(16)"
    FIELD parcela                   as char                 format "x(2)"
    FIELD cod-emitente              as inte      init 0     format ">>>>>>>>9"
    FIELD cod-rep                   as inte      init 0     format ">>>>9"
    FIELD cod-portador              as inte      init 0     format ">>>>9"
    FIELD modalidade                as inte                 format "9"
    FIELD dt-emissao                as date      init TODAY format "99/99/9999"
    FIELD dt-vencimen               as date      init TODAY format "99/99/9999"
    FIELD vl-bruto                  as DECI      init 0     format ">>>>>>>,>>9.99"
    FIELD vl-liquido                as DECI      init 0     format "->>>,>>>,>>>,>>9.99"
    FIELD dt-desconto               as date      init ?     format "99/99/9999"
    FIELD vl-desconto               as DECI      init 0     format ">>>>>>>,>>9.99"
    FIELD pedido-rep                as char                 format "X(12)"
    FIELD nr-pedcli                 as char                 format "x(12)"
    FIELD ct-conta                  as char                 format "x(8)"
    FIELD sc-conta                  as char                 format "x(8)"
    FIELD tp-codigo                 as inte      init 0     format ">>9"
    FIELD serie                     as char                 format "x(5)"
    FIELD mo-codigo                 as inte      init 0     format ">9"
    FIELD vl-bruto-me               as DECI      init 0     format ">>>>>>>,>>9.99"
    FIELD vl-liquido-me             as DECI      init 0     format "->>>,>>>,>>>,>>9.99"
    FIELD vl-desconto-me            as DECI      init 0     format ">>>>>>>,>>9.99"
    FIELD vl-baixa-me               as DECI      init 0     format "->>>,>>>,>>>,>>9.99"
    FIELD vl-cotacao                as DECI      init 0     format ">>>>,>>9.9999999999"
    FIELD dt-credito                as date      init ?     format "99/99/9999"
    FIELD nr-contrato               as char      init 0     format "x(15)"
    FIELD dt-contrato               as date      init today format "99/99/9999"
    FIELD num-id-contrato-exp       as inte      init 0     format "->>>>>>>>>9"
    FIELD estabel-mec               as char      init ""    format "x(3)"
    FIELD referencia-mec            as char      init ""    format "x(10)"
    FIELD dt-referencia-mec         as date      init today format "99/99/9999"
    FIELD cod-unid-negoc            as char      init ""    format "x(3)"
    FIELD dt-transacao              as date      init TODAY format "99/99/9999".

/*  Utilizada para baixa de t¡tulo                          *
 *  Adicionado dt-baixa para diferenciar da data de cr‚dito */

def temp-table tt-linha-cr1 no-undo
&IF "{&mguni_version}" >= "2.07A" &THEN
    FIELD ep-codigo                 LIKE empresa.ep-codigo      init ""     format "x(03)"
&ELSE
    FIELD ep-codigo                 as inte      init 0     format ">>9"
&ENDIF
    FIELD referencia                as char                 format "x(10)"
    FIELD sequencia                 as inte      init 0     format ">>>,>>9"
    FIELD cod-esp                   as char                 format "!!"
&IF "{&mguni_version}" >= "2.07A" &THEN
    FIELD cod-estabel               as char                 format "x(05)"
&ELSE
    FIELD cod-estabel               as char                 format "x(3)"
&ENDIF
    FIELD nr-docto                  as char                 format "x(16)"
    FIELD parcela                   as char                 format "x(2)"
    FIELD cod-emitente              as inte      init 0     format ">>>>>>>>9"
    FIELD cod-rep                   as inte      init 0     format ">>>>9"
    FIELD cod-portador              as inte      init 0     format ">>>>9"
    FIELD modalidade                as inte                 format "9"
    FIELD dt-emissao                as date      init TODAY format "99/99/9999"
    FIELD dt-vencimen               as date      init TODAY format "99/99/9999"
    FIELD vl-bruto                  as DECI      init 0     format ">>>>>>>,>>9.99"
    FIELD vl-liquido                as DECI      init 0     format "->>>,>>>,>>>,>>9.99"
    FIELD dt-desconto               as date      init ?     format "99/99/9999"
    FIELD vl-desconto               as DECI      init 0     format ">>>>>>>,>>9.99"
    FIELD pedido-rep                as char                 format "X(12)"
    FIELD nr-pedcli                 as char                 format "x(12)"
    FIELD ct-conta                  as char                 format "x(8)"
    FIELD sc-conta                  as char                 format "x(8)"
    FIELD tp-codigo                 as inte      init 0     format ">>9"
    FIELD serie                     as char                 format "x(5)"
    FIELD mo-codigo                 as inte      init 0     format ">9"
    FIELD vl-bruto-me               as DECI      init 0     format ">>>>>>>,>>9.99"
    FIELD vl-liquido-me             as DECI      init 0     format "->>>,>>>,>>>,>>9.99"
    FIELD vl-desconto-me            as DECI      init 0     format ">>>>>>>,>>9.99"
    FIELD vl-baixa-me               as DECI      init 0     format "->>>,>>>,>>>,>>9.99"
    FIELD vl-cotacao                as DECI      init 0     format ">>>>,>>9.9999999999"
    FIELD dt-credito                as date      init ?     format "99/99/9999"
    FIELD nr-contrato               as char      init 0     format "x(15)"
    FIELD dt-contrato               as date      init today format "99/99/9999"
    FIELD num-id-contrato-exp       as inte      init 0     format "->>>>>>>>>9"
    FIELD estabel-mec               as char      init ""    format "x(3)"
    FIELD referencia-mec            as char      init ""    format "x(10)"
    FIELD dt-referencia-mec         as date      init today format "99/99/9999"
    FIELD dt-baixa                  as date      init today format "99/99/9999".
