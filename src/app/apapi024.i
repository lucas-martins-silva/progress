/*******************************************
**     Programa: apapi024.i
**     Objetivo: Definicao Temp-Tables
**         Data: Dezembro de 1999
*******************************************/

/* --- Temp-table antiga --- */
define temp-table tt-param-ant
    field cod-versao-integracao  as  int
    field i-ep-codigo           like empresa.ep-codigo
    field cod-fornec            like mov-ap.cod-fornec
    field cod-estabel           like mov-ap.cod-estabel
    field cod-esp               like mov-ap.cod-esp
    field serie                 like mov-ap.serie
    field nr-docto              like mov-ap.nr-docto
    field parcela               like mov-ap.parcela
    field portador              like mov-ap.portador
    field modalidade            like mov-ap.modalidade
    field nr-cheque             like mov-ap.nr-cheque
    field dt-transacao          like mov-ap.dt-transacao
    field valor-mov             like mov-ap.valor-mov
    field esp-ant               like mov-ap.cod-esp
    field serie-ant             like mov-ap.serie-ant
    field docto-ant             like mov-ap.docto-ant
    field parc-ant              like mov-ap.parc-ant
    field fornec-ant            like mov-ap.fornec-ant
    field usa-antec              as  log
    field retorna-portador       as  log
    field l-video                as  log init no
    field l-multiplanta          as  log init no
    field cod-maq-origem         as  int format "9999"
    field num-processo           as  int format ">>>>>>>>9" initial 0
    field num-sequencia          as  int format ">>>>>9"    initial 0
    field ind-tipo-movto         as  int format "99"        initial 1    
    field data-exec              as  date
    field hora-exec              as  integer
    field destino                as  integer
    field arquivo                as  char
    field usuario                as  char.

define temp-table tt-param
    field cod-versao-integracao  as  int
    field i-ep-codigo           like empresa.ep-codigo
    field cod-fornec            like mov-ap.cod-fornec
    field cod-estabel           like mov-ap.cod-estabel
    field cod-esp               like mov-ap.cod-esp
    field serie                 like mov-ap.serie
    field nr-docto              like mov-ap.nr-docto
    field parcela               like mov-ap.parcela
    field portador              like mov-ap.portador
    field modalidade            like mov-ap.modalidade
    field nr-cheque             like mov-ap.nr-cheque
    field dt-transacao          like mov-ap.dt-transacao
    field valor-mov             like mov-ap.valor-mov
    field esp-ant               like mov-ap.cod-esp
    field serie-ant             like mov-ap.serie-ant
    field docto-ant             like mov-ap.docto-ant
    field parc-ant              like mov-ap.parc-ant
    field fornec-ant            like mov-ap.fornec-ant
    field usa-antec              as  log
    field retorna-portador       as  log
    field l-video                as  log init no
    field l-multiplanta          as  log init no
    field l-elimina-docto-pcc    as  log init no
    field cod-maq-origem         as  int format "9999"
    field num-processo           as  int format ">>>>>>>>9" initial 0
    field num-sequencia          as  int format ">>>>>9"    initial 0
    field ind-tipo-movto         as  int format "99"        initial 1    
    field data-exec              as  date
    field hora-exec              as  integer
    field destino                as  integer
    field arquivo                as  char
    field usuario                as  char.

def temp-table tt-mov-ap NO-UNDO
    field cod-estabel  like mov-ap.cod-estabel   
    field cod-esp      like mov-ap.cod-esp       
    field dt-transacao like mov-ap.dt-transacao  
    field serie        like mov-ap.serie         
    field nr-docto     like mov-ap.nr-docto 
    field parcela      like mov-ap.parcela
    field cod-fornec   like mov-ap.cod-fornec    
    field nr-cheque    like mov-ap.nr-cheque     
    field portador     like mov-ap.portador      
    field valor-mov    like mov-ap.valor-mov.

def temp-table tt-retorno-erro NO-UNDO
    field cod-erro  as int 
    field desc-erro as char.

def var i-cod-versao-integracao as int                  no-undo.
def var c-param                 as char                 no-undo.
def var c-video                 as char                 no-undo.    
def var da-ini-validac         like empresa.data-inicio no-undo.
def var da-fim-validac         like empresa.data-fim    no-undo.
def var i-num-erro              as  integer             no-undo.
def var c-desc-erro-pagto       as  char                no-undo.
def var row-mov-ap              as  rowid               no-undo.

/* Fim de Include */
