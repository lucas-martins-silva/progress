/*** Materia Prima requisitada de uma localiza»’o para uma ordem definida ***/
{cdp/cdcfgman.i}
define temp-table tt-op-consumo
   field cod-estabel      like movto-estoq.cod-estabel
   field cod-deposito     like movto-estoq.cod-depos
   field cod-localiz      like movto-estoq.cod-localiz
   field es-codigo        like estrutura.es-codigo
   field es-lote          like movto-estoq.lote
   field cod-ref-es       like movto-estoq.cod-refer
   field nr-ord-produ     like movto-estoq.nr-ord-produ
   field it-codigo        like movto-estoq.it-codigo
   field cod-ref-it       like movto-estoq.cod-refer
   &IF DEFINED(bf_man_206b) &THEN
        /* InclusÆo da Unidade de Neg¢cio na release 2.06b com 
        fun‡Æo "ems2-unidade-negocio" ativo */
        FIELD cod-unid-negoc    LIKE movto-estoq.cod-unid-negoc
   &ENDIF
   field cod-lista        as char format "x(16)"
   field cod-roteiro      as char format "x(16)"
   field dat-i-corte      as date
   field dat-f-corte      as date
   field dat-ult-aca      as date
   field qtd-item         as decimal format "->>>>,>>>,>>9.99"
   field qtd-recicl       as decimal format "->>>>,>>>,>>9.99"
   field qtd-refgda       as decimal format "->>>>,>>>,>>9.99"
   field qtd-consumida    as decimal format "->>>>,>>>,>>9.99" 
   field qtd-teorica      as decimal format "->>>>,>>>,>>9.99"
   field qtd-ajuste       like movto-estoq.quantidade
   field Perc-Distrib     as decimal format "->>,>>9.99" 
   field fator-item-un-al as decimal format ">>>>9.9<<<<"
   field fator-comp-un-al as decimal format ">>>>9.9<<<<"
   FIELD r-rowid          AS ROWID
   index id cod-estabel cod-deposito cod-localiz es-codigo cod-ref-es es-lote nr-ord-produ
   INDEX id2 it-codigo es-codigo cod-ref-it cod-ref-es cod-lista cod-roteiro
   index op nr-ord-produ dat-i-corte dat-f-corte
   index item it-codigo dat-i-corte dat-f-corte.

