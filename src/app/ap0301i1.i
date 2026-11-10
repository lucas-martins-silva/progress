/*Definicao da temp-table tt-param-ap-mg*/

def temp-table tt-param-ap-mg
    &IF "{&mguni_version}" >= "2.071" &THEN
    field ep-codigo     LIKE empresa.ep-codigo
    &ELSE
    field ep-codigo     as  integer   format ">>9"
    &ENDIF
    field prim-pg-diar  as  integer   format ">>,>>9"
    field ult-pg-diar   as  integer   format ">>>,>>9"
    field prox-pg-diar  as  integer   format ">>>,>>9"
    field mo-codigo     as  integer   format ">9"
    field te-aber-diar  as  integer   format ">>9"
    field te-ence-diar  as  integer   format ">>9"
    field msg-bordero   as  integer   format ">>9"
    field ct-despesa    as  integer   format "99999999"
    field sc-despesa    as  integer   format "99999"
    field emite-cheque  as  logical   format "Sim/Nao"
    field dt-ult-fec    as  date      format "99/99/9999"
    field char-1        as  char      format "x(02)"
    field contabiliza   as  logical   format "Integra/Exporta"
    field dt-conversao  as  logical   format "Fluxo/Emissao"
    field codigo-cgc    as  logical   format "Codigo/CGC"
    field mo-correcao   as  integer   format "9"
    field ut-pag-escr   as  logical   format "Sim/Nao"
    field dt-elimina    as  date      format "99/99/9999"
    field varias-contas as  logical   format "Sim/Nao"
    field cont-baixa    as  logical   format "Sim/Nao"
    field fornec-receita as integer   format ">>>>>9"
    field acum-ir       as  integer   format "9"
    &IF "{&mguni_version}" >= "2.071" &THEN
    field estab-ir      LIKE estabelec.cod-estabel
    &ELSE
    field estab-ir      as  char      format "x(3)"
    &ENDIF
    field limp-cont     as  integer   format ">>>9"
    field ind-tipo-movto as int format "9" /*1-Inclui 2-Modifica 3-Elimina*/
    field l-atualiza as  log.


