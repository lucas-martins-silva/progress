/********************************************************************************
** Include: AP0733.i 
** Defini‡Æo das Temp-Table do relat¢rio AP0733 - Relat¢rio de Pis/Cofins/CSLL
**
*******************************************************************************/
define temp-table tt-param  no-undo                        
    field destino               as integer                     
    field arquivo               as char format "x(35)"         
    field usuario               as char format "x(12)"         
    field data-exec             as date                        
    field hora-exec             as integer                     
    field classifica            as integer                     
    field desc-classifica       as char format "x(40)"         
    field ep-codigo             as int                         
    field c-estab-ini           as char                        
    field c-estab-fim           as char                        
    field i-fornec-ini          as int format ">>>>>>>>9"      
    field i-fornec-fim          as int format ">>>>>>>>9"      
    field i-grupo-ini           as int format ">9"             
    field i-grupo-fim           as int format ">9"             
    field dt-prev-pagto-ini     as date                        
    field dt-prev-pagto-fim     as date                        
    field dt-pagto-ini          as date                        
    field dt-pagto-fim          as date  
    FIELD i-fornec-matriz-ini   AS INT
    FIELD i-fornec-matriz-fim   AS INT
    FIELD i-gr-forn-matriz-ini  AS INT
    FIELD i-gr-forn-matriz-fim  AS INT
    field rs-considera          as char                        
    field l-lista-normais       as log                         
    field l-lista-antec         as log
    field l-quebra-pag-fornec   as logical
    field l-imp-pag-param       as log  
    field c-digita-1            as char
    field c-digita-2            as char.

define temp-table tt-digita-1 no-undo
    field cod-espec  like espec-ap.cod-esp
    field descricao  like espec-ap.descricao
    field log-selecionado as LOGICAL
    field marcado      as log
    field confirma     as log
    field rw-digita    as rowid
    INDEX selecionado log-selecionado ASCENDING.

define temp-table tt-digita-2 no-undo
    field cod-espec  like espec-ap.cod-esp
    field descricao  like espec-ap.descricao
    field log-selecionado as LOGICAL
    field marcado      as log
    field confirma     as log
    field rw-digita    as rowid
    INDEX selecionado log-selecionado ASCENDING.



/*--- Fim da Include AP0733.i ---*/
