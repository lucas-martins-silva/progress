/*******************************************************************************
*
*     IM0302.I - Definicao de variaveis.
*
*******************************************************************************/

{include/tt-edit.i} /* definicoes temp-table tt-editor */

define temp-table tt-param NO-UNDO
    field destino   as integer
    field arquivo   as char
    field usuario   as char
    field data-exec as date
    field hora-exec as integer
    field c-item-i  as char
    field c-item-f  as char
    field c-estab-i as char
    field c-estab-f as char
    field c-compr-i as char
    field c-compr-f as char
    field i-ordem-i as integer
    field i-ordem-f as integer
    field d-data-i  as date format 99/99/9999
    field d-data-f  as date format 99/99/9999
    field c-fami-i  as char
    field c-fami-f  as char
    field i-forn-i  as integer format "999999999"
    field i-forn-f  as integer format "999999999"
    field l-envia   as logical 
    field l-traduz  as logical 
    field c-destino as char 
    field diretorio as char
    field l-impre   as logical
    field dest-inc  as char
    FIELD l-narrativa AS LOGICAL
    field l-bus-to-bus as logical.

def buffer b-cotacao-item for cotacao-item.
def buffer b-contato      for cont-emit.
def buffer b-ordem        for ordem-compra.
def buffer b-ord          for ordem-compra.
def buffer b-ordem-f      for ordem-compra.
def buffer b-emitente     for emitente.

def temp-table tt-ficha NO-UNDO
  field numero-ordem like ordem-compra.numero-ordem
  field fornecedor   like emitente.nome-emit format "x(38)"
  field tel1         as char format "x(15)"
  field fax1         like emitente.telefax
  field comprador    like comprador.nome
  field tel2         as char format "x(15)"
  field fax2         like emitente.telefax
  field item         like item-fornec.item-do-forn
  field descricao    as   char format "x(30)"
  field quant        like prazo-compra.quantidade
  field chegada      like prazo-compra.data-entrega
  field cod-estabel  like ordem-compra.cod-estabel
  field int-1        as integer 
  field un           like item-fornec.unid-med-for
  &if defined(bf-mat-comex) &then 
  &else
      field e-mail       like emitente.e-mail
  &endif
  field cod-forn     like emitente.cod-emitente
  field cod-idioma   like emitente-cex.cod-idioma
  FIELD narrativa    like ordem-compra.narrativa
    index forn-ordem is primary 
        cod-forn numero-ordem.


def temp-table tt-inconsist NO-UNDO
  field num-ordem     like ordem-compra.numero-ordem
  field requisitante  like ordem-compra.requisitante
  field nome-abrev    as   char format "x(32)" 
  field it-codigo     like item.it-codigo.

def var c-destino     as char format "x(07)" no-undo.
def var c-ordem       as char format "x(11)" no-undo.
def var c-imp         as char format "x(09)" no-undo.
def var c-envia       as char format "x(12)" no-undo.
def var c-traco1      as char format "x(80)" no-undo.
def var c-item-forn   as char format "x(11)" no-undo.
def var c-quant       as char format "x(11)" no-undo.
def var c-cheg        as char format "x(09)" no-undo.
def var c-preco       as char format "x(15)" no-undo.
def var c-incoterm    as char format "x(08)" no-undo.
def var c-cond        as char format "x(13)" no-undo.
def var c-desc        as char format "x(15)" no-undo.
def var c-qtde        as char format "x(13)" no-undo.
def var c-data        as char format "x(11)" no-undo.
def var c-moeda       as char format "x(10)" no-undo.
def var c-sel         as char format "x(07)" no-undo.
def var c-de          as char format "x(10)" no-undo.
def var c-para        as char format "x(10)" no-undo.
def var c-tel         as char format "x(10)" no-undo.
def var c-fax         as char format "x(05)" no-undo.
def var c-tel-c       as char format "x(10)" no-undo.
def var c-fax-c       as char format "x(05)" no-undo.
def var c-un          as char format "x(02)" no-undo.

def var c-inconsist   as char format "x(32)" no-undo.
def var c-requis      as char format "x(12)" no-undo.
def var c-nome        as char format "x(32)" no-undo.
def var c-item        as char format "x(16)" no-undo.
def var c-dest-inc    as char format "x(21)" no-undo.
def var l-ok          as logical             no-undo.

DEF VAR c-lb-narra    AS CHAR FORMAT "x(10)" NO-UNDO.
{utp/ut-liter.i Narrativa * r}
assign c-lb-narra = trim(return-value).

form tt-editor.conteudo at 4
     with no-box no-label width 132 stream-io frame f-narrativa.

form
   c-para at 1 ":" at 11 space(1) 
   tt-ficha.cod-forn 
   " - " 
   tt-ficha.fornecedor no-label skip
   c-tel at 1 ":"      at 11 space(1)
   tt-ficha.tel1    
   c-fax  at 29 ":"    at 35 space(1) 
   tt-ficha.fax1                skip(1)
   c-de at 1 ":"       at 11 space(1)      
   tt-ficha.comprador           skip
   c-tel-c at 1 ":"    at 11 space(1)
   tt-ficha.tel2  
   c-fax-c at 29 ":"   at 35 space(1)
   tt-ficha.fax2 
   skip(3)     
   with no-labels down width 80 no-box stream-io frame f-ficha1.
   
form 
     c-ordem     at 1
     c-item-forn at 12
     c-quant     at 54
     c-un        at 68
     c-cheg      at 71 skip
     c-desc      at 12 skip
     c-traco1    at 1  skip
     with no-labels down width 80 no-box stream-io frame f-ficha2.
     
form      
     tt-ficha.numero-ordem at 1 
     tt-ficha.item         at 12
     tt-ficha.quant        at 54
     tt-ficha.un           at 68
     tt-ficha.chegada      at 71 skip 
     tt-ficha.descricao    at 12
     with no-labels down width 80 no-box stream-io frame f-ficha3.
  
form     
     c-preco    at 1   
     c-moeda    at 17
     c-incoterm at 28
     c-cond     at 37
     c-qtde     at 51
     c-un       at 65
     c-data     at 68 skip
     "---------------" at 1
     "----------"      at 17 
     "--------"        at 28
     "-------------"   at 37
     "-------------"   at 51
     "--"              at 65
     "-------------"   at 68 
     skip(3)
     with no-labels down width 80 no-box stream-io frame f-ficha4. 

form 
/*Seleá∆o*/
     skip(1)                                   
     c-sel                                     no-label 
     skip(1)
     tt-param.c-item-i                         colon 20
     "|< >|"                                      at 40
     tt-param.c-item-f                         no-label
     tt-param.c-estab-i                        colon 20
     "|< >|"                                      at 40
     tt-param.c-estab-f                        no-label
     tt-param.c-compr-i                        colon 20
     "|< >|"                                      at 40
     tt-param.c-compr-f                        no-label
     tt-param.i-ordem-i                        colon 20
     "|< >|"                                      at 40
     tt-param.i-ordem-f                        no-label 
     tt-param.d-data-i                         colon 20
     "|< >|"                                      at 40
     tt-param.d-data-f                         no-label
     tt-param.c-fami-i                         colon 20
     "|< >|"                                      at 40
     tt-param.c-fami-f                         no-label
     tt-param.i-forn-i                         colon 20
     "|< >|"                                      at 40
     tt-param.i-forn-f                         no-label
/*impress∆o*/
     skip(1)
     c-imp                                     no-label
     skip(1)
     c-destino                                 colon 20 
     tt-param.usuario                          colon 20 
     skip(1)
     c-dest-inc                                at 02
     ":"                                       at 23
     tt-param.dest-inc                         at 25
     with width 80 side-labels frame f-param stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-param:HANDLE).



     
form     
     c-ordem    at 1   
     c-requis   at 14
     c-nome     at 29
     c-item     at 62   skip
     "------------"                     at 1
     "------------"                     at 14 
     "--------------------------------" at 27
     "----------------"                 at 62 
     skip
     with no-labels down width 80 no-box stream-io frame f-inc-cab.

form
  tt-inconsist.num-ordem    at 1
  tt-inconsist.requisitante at 14
  "-"                       at 27
  tt-inconsist.nome-abrev   at 29
  tt-inconsist.it-codigo    at 62 
  SKIP
  with no-labels down width 80 no-box stream-io frame f-inc.

/* IM0302.I  */

{utp/ut-liter.i Destino * r}

assign c-destino:label = trim(return-value).
