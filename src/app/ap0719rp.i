/********************************************************************
***
***  app/ap0719rp.i - Defini‡Æo Form's ...
***
********************************************************************/
/* y2kready */

def buffer b-emitente for emitente.

/*------- Estas variaveis serÆo atualizadas conforme tt-param --------*/
def var i-empresa         like empresa.ep-codigo                  no-undo.
def var i-ano-base        as integer format "9999"                no-undo.
def var i-tipo            as integer                              no-undo.
def var i-ddd-func        as integer format "9999"                no-undo.
def var i-tel-func        as integer format "99999999"            no-undo.
def var i-ramal-func      as integer format "999999"              no-undo.
def var i-fax-func        as integer format "99999999"            no-undo.
def var i-cep             as integer format "99999999"            no-undo.
def var i-caixa-postal    as integer format "99999"               no-undo.

def var l-estrangeiro     as logical                              no-undo.
def var l-natureza        as logical init yes                     no-undo.
def var l-cgc             as logical init no                      no-undo.
def var c-estabel         like tit-ap.cod-estabel                 no-undo.
def var c-arquivo         as character format "x(15)"             no-undo.
def var c-outro-equip     as character format "x(30)"             no-undo.
def var c-sis-oper        as character format "x(10)"             no-undo.
def var c-funcionario     as character format "x(50)"             no-undo.
def var c-cpf-func        as character format "999.999.999-99"    no-undo.
def var c-mail-func       as character format "x(50)"             no-undo.
def var c-emp-emit        as character format "x(60)"             no-undo. 
def var c-func-aux        as character format "x(50)"             no-undo.
def var c-cpf-responsavel as character format "999.999.999-99"   no-undo.

/*------------ DECLARANTE -----------*/
def var i-ind-depos     as int format "9"                    no-undo init 0.
def var c-ind-evento    as char format "x"                   no-undo init "".
def var da-evento       as date format "99/99/9999"          no-undo init &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF.

/*--------------------------------------------------------------------*/


def var l-parametros      as logical init no                      no-undo.
def var l-densidade       as logical format "Dupla/1.600 Bpi"     no-undo.
def var l-imprime-1       as logical                              no-undo.
def var l-passou          as logical                              no-undo.

def var da-ta-conv        as date                                 no-undo.
def var da-ta-ini         as date                                 no-undo.
def var da-ta-fim         as date                                 no-undo.
def var da-cotacao        as date                                 no-undo.
def var da-today          as date init today format "99/99/9999"  no-undo.

def var i-tot-reg-1       as integer format ">>>,>>9"             no-undo.
def var i-tot-reg-2       as integer format ">>>,>>9"             no-undo.
def var i-tot-reg-3       as integer format ">>>,>>9"             no-undo.
def var i-reg-1           as integer format ">>>,>>9"             no-undo.
def var i-dia-mes         as integer                              no-undo.
def var i-nr-registro     as integer init 0                       no-undo.
def var i-cont            as integer                              no-undo.
def var i-cont2           as integer                              no-undo.
def var i-cont3           as integer                              no-undo.
def var i-mes             as integer                              no-undo.
def var i-tot-reg         as integer                              no-undo.
def var i                 as integer                              no-undo.
def var i-cod-ret         like dirf-apf.cod-retencao              no-undo.

def var c-matriz          like emitente.nome-matriz               no-undo.
def var c-tel-func        as character format "x(15)"             no-undo.
def var c-analista        as character format "x(50)"             no-undo.
def var c-tel-analis      as character format "x(15)"             no-undo.
def var c-moeda           as character format "x(14)" extent 10   no-undo.
def var c-nome-moeda      as character format "x(14)"             no-undo.
def var c-cpf-aux         as character format "x(11)"             no-undo.
def var c-cpf             as character format "x"                 no-undo.
def var c-opcao           as character                            no-undo.
def var c-pos-cgc         as character format "x" extent 19       no-undo.
def var c-cgc-format      as character format "x" extent 19       no-undo.
def var c-cgc             as character format "x(08)"             no-undo.
def var c-cgc-est         as character format "x(08)"             no-undo.
def var c-cgc-emp         as character format "x(14)"             no-undo.
def var c-cgc-arq         as character format "x(14)"             no-undo.
def var c-cgc-arq-est     as character format "x(14)"             no-undo.
def var c-rend-trib       as character format "x(16)"             no-undo.
def var c-rend-trib2      as character format "x(15)" extent 12   no-undo.
def var c-ir-ret          as character format "x(16)"             no-undo.
def var c-ir-ret2         as character format "x(15)" extent 12   no-undo.
def var c-deducoes        as character format "x(15)" extent 12   no-undo.
def var c-ded-prev        as character format "x(15)" extent 12   no-undo.
def var c-ded-depend      as character format "x(15)" extent 12   no-undo.
def var c-ded-pensao      as character format "x(15)" extent 12   no-undo.
def var c-x               as character format "x" extent 6 init
        ["X","X","X","X","X","X"] no-undo.


def var de-rend-trib      as decimal decimals 2 extent 12         no-undo.
def var de-ir-ret         as decimal decimals 2 extent 12         no-undo.
def var de-deducoes       as decimal decimals 2 extent 12         no-undo.
def var de-tot-rend       as decimal extent 12                    no-undo.
def var de-tot-ir         as decimal extent 12                    no-undo.
def var de-tot-ded        as decimal extent 12                    no-undo.
def var de-cot-dest       as decimal                              no-undo.
def var de-rend-geral     as decimal format ">>>,>>>,>>>,>>9.99"  no-undo.
def var de-ded-geral      as decimal format ">>>,>>>,>>>,>>9.99"  no-undo.
def var de-ir-geral       as decimal format ">>>,>>>,>>>,>>9.99"  no-undo.
def var de-rendimento     as decimal                              no-undo.
def var c-registro        as char    format "9"                   no-undo.
DEF VAR de-rend-fornec    AS DEC                           INIT 0 NO-UNDO. /*gera o valor do rendimento conforme 
                                                                             percentual informado no fornecedor*/
def var h-acomp           as handle                               no-undo.
def var c-espaco          as char    format "x(241)"              no-undo.    

def temp-table t-dirf NO-UNDO
    field cgc-decl    as char format "x(14)"
    field cod-ret     as inte format "9999"
    field esp-ben     as inte format "9"
    field cgc-cpf-ben as char format "x(14)"
    field nome-ben    as char format "x(60)"
    field rend-trib   as deci format "->>>,>>>,>>>,>>9.99" extent 12
    field deducoes    as deci format "->>,>>>,>>9.99"      extent 12
    field imp-ret     as deci format "->>,>>>,>>>,>>9.99"  extent 12
    index codigo is primary
          cgc-decl 
          cod-ret 
          esp-ben 
          cgc-cpf-ben.

def temp-table t-dirf-deduc NO-UNDO
    field cgc-decl    as char format "x(14)"
    field cod-ret     as inte format "9999"
    field esp-ben     as inte format "9"
    field cgc-cpf-ben as char format "x(14)"
    field nome-ben    as char format "x(60)"
    field ded-prev    as deci format "->>>,>>>,>>>,>>9.99" extent 12
    field ded-depend  as deci format "->>>,>>>,>>>,>>9.99" extent 12
    field ded-pensao  as deci format "->>>,>>>,>>>,>>9.99" extent 12
    index codigo is primary
          cgc-decl 
          cod-ret 
          esp-ben 
          cgc-cpf-ben.

def buffer b-t-dirf for t-dirf.

def temp-table wf-empresas
    field wf-i-empresa like empresa.ep-codigo
    field wf-c-cgc     as character format "x(14)".

/*--- Fim da Include AP0719RP.I ---*/

