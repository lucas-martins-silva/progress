/********************************************************************************
** Include   : acp/acapi006.i
** Data      : 20/04/99
** Autor     : Adriano
** Objetivo  : Include de Definicao, utilizada pela acp/acapi006.p.
********************************************************************************/

define temp-table tt-cotas no-undo 
       like cotas
       field log-previsto-cota as   logical /*se atualiza previsto em cotas*/
       field log-original-cota as   logical /*se atualiza original em cotas*/
       field log-previsto-base as   logical /*se atualiza previsto em base cotas*/
       field log-base-cota     as   logical /*se cria base de cota na inclus∆o*/
       field ind-tipo-movto    as   integer format "99"        initial 1
       index        cod-estabel 
                    cod-canal-venda   
                    cod-gr-cli        
                    nome-abrev        
                    nome-ab-reg       
                    nome-mic-reg                          
                    cod-rep           
                    cd-produto        
                    dt-inicial.       

define temp-table tt-erros-api no-undo
       field num-sequencia-erro             as int  format "999"
       field cod-erro                       as int  format "99999"
       field label-campo-1                  as char format "x(30)" 
       field label-campo-2                  as char format "x(30)"         
       field des-erro                       as char format "x(60)"
       field chave                          as char format "x(150)"
       index codigo   num-sequencia-erro.


/*acapi006.i*/ 
