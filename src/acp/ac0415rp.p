/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0415RP 2.00.00.008 } /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ac0415rp MAC}
&ENDIF

/*******************************************************************************
**
** Ac0408RP.P : ImpressÆo do relat¢rio de Composi‡Æo de Cotas
**
********************************************************************************/
{utp/ut-glob.i}
/* ************************ Defini‡Æo de vari veis *************************** */

{include/i-rpvar.i}

{cdp/cdcfgdis.i} /*include para pr‚-processadores*/

def var c-processa         as char format "x(20)"         no-undo.
def var c-selecao          as char format "x(11)"         no-undo.
def var c-parametro        as char format "x(14)"         no-undo.
def var c-impressao        as char format "x(12)"         no-undo.
def var c-destino          as char format "x(10)"         no-undo.
def var h-acomp            as handle                      no-undo.
def var c-total            as character format "x(05)"    no-undo.
def var c-estabel          as character format "x(15)"    no-undo.
def var c-desc-regiao      as character format "x(20)"    no-undo.
def var c-nome-abrev       as character format "x(12)"    no-undo.
def var c-nome-mic-reg     as character format "x(12)"    no-undo.
def var c-cliente          as character format "x(7)"     no-undo.
def var c-canal-venda      as character format "x(11)"    no-undo.
def var c-mic-reg          as character format "x(12)"    no-undo.
def var c-ab-reg           as character format "x(06)"    no-undo.
def var c-cod-rep          as character format "x(13)"    no-undo.
def var c-gr-cli           as character format "x(13)"    no-undo.
def var c-dt-movto         as character format "x(8)"     no-undo.
def var c-pedida           as character format "x(6)"     no-undo.
def var c-usuario          as character format "x(7)"     no-undo.
def var c-produto          as character format "x(07)"    no-undo.
def var c-canc-fat         as character format "x(09)"    no-undo.
def var l-imprime          as logical                     no-undo.
def var c-faturada         as character format "x(08)"    no-undo.
def var c-susp-ped         as character format "x(08)"    no-undo.
def var c-reprov-ped       as character format "x(10)"    no-undo.
def var i-cont             as integer                     no-undo.
def var c-pedido           as character format "x(06)"    no-undo.
def var c-canc-ped         as character format "x(09)"    no-undo.
def var c-periodo          as character format "x(12)"    no-undo.
def var de-tot-ped         like cotas.qt-pedida           no-undo.

/* ********************  Defini‡Æo de Temp-Table ****************************** */

{acp/ac9000.i}

def temp-table tt-raw-digita
   field raw-digita      as raw.

define temp-table tt-param
    field destino              as integer
    field arquivo              as char
    field usuario              as char format "x(12)"
    field data-exec            as date
    field hora-exec            as integer
    field classifica           as integer
    field desc-classifica      as char format "x(40)"
    field cod-estab-ini        like cotas.cod-estabel
    field cod-estab-fim        like cotas.cod-estabel
    field cod-canal-venda-ini  like cotas.cod-canal-venda
    field cod-canal-venda-fim  like cotas.cod-canal-venda
    field cod-gr-cli-ini       like cotas.cod-gr-cli
    field cod-gr-cli-fim       like cotas.cod-gr-cli
    field nome-abrev-ini       like cotas.nome-abrev
    field nome-abrev-fim       like cotas.nome-abrev
    field nome-ab-reg-ini      like cotas.nome-ab-reg
    field nome-ab-reg-fim      like cotas.nome-ab-reg
    field nome-mic-reg-ini     like cotas.nome-mic-reg
    field nome-mic-reg-fim     like cotas.nome-mic-reg
    field cod-rep-ini          like cotas.cod-rep
    field cod-rep-fim          like cotas.cod-rep
    field cd-produto-ini       like cotas.cd-produto
    field cd-produto-fim       like cotas.cd-produto
    field dt-inicial           like cotas.dt-inicial.

/* ************************ Defini‡Æo de parametros ************************** */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

/* ************************ Defini‡Æo de buffer ****************************** */

def buffer b-movto-cota for movto-cota.

/* ************************Defini‡Æo de Frames  ***************************** */

form c-estabel          at 01
     ":"                
     estabelec.nome     at 19 skip(2)
     with no-label stream-io page-top frame f-estab.   
     
form c-dt-movto            at 01
     c-produto             at 12
     c-usuario             at 29
     c-pedido              at 53
     c-faturada            at 69
     c-canc-ped            at 86
     c-canc-fat            at 105
     c-susp-ped            at 123
     "----------"          at 01
     "----------------"    at 12
     "------------"        at 29
     "-----------------"   at 42
     "-----------------"   at 60
     "-----------------"   at 78
     "-----------------"   at 96
     "-----------------"   at 114 skip
     with width 132 no-box no-label no-attr stream-io frame f-cab1.  
     
form c-dt-movto            at 01
     c-produto             at 12
     c-usuario             at 29
     c-pedido              at 50
     c-faturada            at 63
     c-canc-ped            at 77
     c-canc-fat            at 93
     c-susp-ped            at 108
     c-reprov-ped          at 123
     "----------"          at 01
     "----------------"    at 12
     "------------"        at 29
     "--------------"      at 42
     "--------------"      at 57
     "--------------"      at 72
     "--------------"      at 87
     "--------------"      at 102
     "--------------"      at 119 skip
     with width 132 no-box no-label no-attr stream-io frame f-cab2.


form skip(2)
     c-canal-venda         no-label at 03
     ":":U
     canal-venda.descricao no-label format "x(25)" at 18
     c-gr-cli              no-label at 01
     ":":U
     gr-cli.descricao      no-label at 18
     c-nome-abrev          no-label at 65
     ":":U
     cotas.nome-abrev      no-label at 80
     c-ab-reg              no-label at 08
     ":":U
     c-desc-regiao         no-label format "x(15)" at 18
     c-mic-reg             no-label at 65
     ":":U
     c-nome-mic-reg        no-label at 80
     c-cod-rep             no-label at 01
     ":":U                 
     repres.nome-abrev     no-label at 18
     c-periodo             no-label at 65
     ":":U
     cotas.dt-inicial      no-label at 80 
     skip(1)     
     with width 132 no-box no-attr stream-io side-label frame f-movto-cota. 
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-movto-cota:HANDLE).
  


form skip(01)
     c-selecao   no-label    skip(1)
     tt-param.cod-estab-ini              colon 40 space(12) "|< >|"
     tt-param.cod-estab-fim           no-label colon 73 skip
     tt-param.cod-canal-venda-ini        colon 40 space(14) "|< >|"
     tt-param.cod-canal-venda-fim     no-label colon 73 skip
     tt-param.cod-gr-cli-ini             colon 40 space(13) "|< >|"
     tt-param.cod-gr-cli-fim          no-label colon 73 skip
     tt-param.nome-abrev-ini             colon 40 space(5) "|< >|"
     tt-param.nome-abrev-fim          no-label colon 73 skip
     tt-param.nome-ab-reg-ini            colon 40 space(05) "|< >|"
     tt-param.nome-ab-reg-fim         no-label colon 73 skip
     tt-param.nome-mic-reg-ini           colon 40 space(05) "|< >|"
     tt-param.nome-mic-reg-fim        no-label colon 73 skip
     tt-param.cod-rep-ini                colon 40 space(12) "|< >|"
     tt-param.cod-rep-fim             no-label colon 73 skip
     tt-param.cd-produto-ini             colon 40 space(1)  "|< >|"
     tt-param.cd-produto-fim          no-label colon 73 skip(1)
     c-parametro no-label    skip(1)
     tt-param.dt-inicial     colon 40 skip(1)   
     c-impressao no-label    skip(1)
     c-destino               colon 40
     " - ":U
     tt-param.arquivo no-label format "x(60)":U skip
     tt-param.usuario        colon 40 skip(1)
     with down no-box side-labels width 132 stream-io frame f-parametros.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-parametros:HANDLE).



/* *********************** Defini‡Æo de literais  ***************************** */


{utp/ut-liter.i SELE€ÇO * R}
assign c-selecao = trim(return-value).
{utp/ut-field.i mgdis cotas cod-estabel 1}
assign tt-param.cod-estab-ini:label in frame f-parametros = trim(return-value).
{utp/ut-field.i mgdis cotas cod-canal-venda 1}
assign tt-param.cod-canal-venda-ini:label in frame f-parametros = trim(return-value).
{utp/ut-field.i mgdis cotas cod-gr-cli 1}
assign tt-param.cod-gr-cli-ini:label in frame f-parametros = trim(return-value).
{utp/ut-field.i mgdis cotas nome-abrev 1}
assign tt-param.nome-abrev-ini:label in frame f-parametros = trim(return-value).
{utp/ut-field.i mgdis cotas nome-ab-reg 1}
assign tt-param.nome-ab-reg-ini:label in frame f-parametros = trim(return-value).
{utp/ut-field.i mgdis cotas nome-mic-reg 1}
assign tt-param.nome-mic-reg-ini:label in frame f-parametros = trim(return-value).
{utp/ut-field.i mgdis cotas cod-rep 1}
assign tt-param.cod-rep-ini:label in frame f-parametros = trim(return-value).
{utp/ut-field.i mgdis cotas cd-produto 1}
assign tt-param.cd-produto-ini:label in frame f-parametros = trim(return-value).


{utp/ut-liter.i PAR¶METROS * R}
assign c-parametro = trim(return-value).
{utp/ut-liter.i Per¡odo * L}
assign tt-param.dt-inicial:label in frame f-parametros = trim(return-value).


{utp/ut-liter.i IMPRESSÇO * R}
assign c-impressao = trim(return-value).
{utp/ut-liter.i Destino * L}
assign c-destino:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Usu rio * L}
assign tt-param.usuario:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Processando * L}
assign c-processa = trim(return-value).
{utp/ut-field.i mgdis cotas nome-abrev 1}
assign c-cliente = trim(return-value).
{utp/ut-field.i mgdis movto-cota dt-movto 1}
assign c-dt-movto = trim(return-value).

{utp/ut-field.i mgdis cotas cod-estabel 1}
assign c-estabel = return-value.
{utp/ut-field.i mgdis cotas cod-canal-venda 1}
assign c-canal-venda = return-value.
{utp/ut-field.i mgdis cotas cod-gr-cli 1}
assign c-gr-cli = return-value.
{utp/ut-field.i mgdis cotas nome-abrev 1}
assign c-nome-abrev = return-value.
{utp/ut-field.i mgdis cotas nome-ab-reg 1}
assign c-ab-reg = return-value.
{utp/ut-field.i mgdis cotas nome-mic-reg 1}
assign c-mic-reg = return-value.
{utp/ut-field.i mgdis cotas cod-rep 1}
assign c-cod-rep = return-value.
{utp/ut-field.i mgdis cotas qt-pedida 1}
assign c-pedido = return-value.
{utp/ut-field.i mgdis cotas cd-produto 1}
assign c-produto = return-value.
{utp/ut-field.i mgdis movto-cota qt-ped-canc 1}
assign c-canc-ped = return-value.
{utp/ut-field.i mgdis movto-cota qt-faturada 1}
assign c-faturada = return-value.
{utp/ut-field.i mgdis movto-cota qt-ped-susp 2}
assign c-susp-ped = return-value.
{utp/ut-field.i mgdis movto-cota qt-fat-canc 2}
assign c-canc-fat = return-value.


/************************************************************ 
*  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
************************************************************/
 
&if defined (bf_dis_adm_cotas) &then
    {utp/ut-field.i mgdis movto-cota qt-ped-reprov 2}
    assign c-reprov-ped = return-value.
&endif

{utp/ut-liter.i Per¡odo * R}
assign c-periodo = return-value.
{utp/ut-liter.i Usu rio * R}
assign c-usuario = return-value.

/* ************************ Inicio do programa ****************************** */
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.

run utp/ut-acomp.p persistent set h-acomp.
find empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
if avail empresa then
   assign c-empresa = empresa.razao-social.

assign c-programa = 'ap0415'
       c-destino  = {varinc/var00002.i 04 tt-param.destino}.
 
{utp/ut-liter.i Relat¢rio_Altera‡äes_Cotas_Realizadas MAP C}
assign c-titulo-relat = return-value.

{include/i-rpout.i}
view frame f-cabec.
view frame f-rodape.
     
run pi-inicializar in h-acomp (input "Aguarde...").
main-block:
do  on error  undo main-block, leave main-block
    on endkey undo main-block, leave main-block
    on stop   undo main-block, leave main-block:

    for each cotas no-lock 
       where   cotas.cod-estabel     >= tt-param.cod-estab-ini
         and   cotas.cod-estabel     <= tt-param.cod-estab-fim
       and   ((cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
         and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim)
         or    cotas.cod-canal-venda  = ? )
       and   ((cotas.cod-gr-cli      >= tt-param.cod-gr-cli-ini
         and   cotas.cod-gr-cli      <= tt-param.cod-gr-cli-fim)
         or    cotas.cod-gr-cli       = ? )
       and   ((cotas.nome-abrev      >= tt-param.nome-abrev-ini
         and   cotas.nome-abrev      <= tt-param.nome-abrev-fim)
         or    cotas.nome-abrev       = ? )          
       and   ((cotas.nome-ab-reg     >= tt-param.nome-ab-reg-ini
         and   cotas.nome-ab-reg     <= tt-param.nome-ab-reg-fim)
         or    cotas.nome-ab-reg      = ? ) 
       and   ((cotas.nome-mic-reg    >= tt-param.nome-mic-reg-ini
         and   cotas.nome-mic-reg    <= tt-param.nome-mic-reg-fim)
         or    cotas.nome-mic-reg     = ? )
       and   ((cotas.cod-rep         >= tt-param.cod-rep-ini
         and   cotas.cod-rep         <= tt-param.cod-rep-fim)
         or    cotas.cod-rep          = ? )
       and     cotas.cd-produto      >= tt-param.cd-produto-ini
         and   cotas.cd-produto      <= tt-param.cd-produto-fim
       and   cotas.dt-inicial         = tt-param.dt-inicial
       break by cotas.cod-estabel
             by cotas.cod-canal-venda
             by cotas.cod-gr-cli
             by cotas.nome-abrev
             by cotas.nome-ab-reg
             by cotas.nome-mic-reg
             by cotas.cod-rep:

       run pi-acompanhar in h-acomp (input cotas.cd-produto).

       if first-of(cotas.cod-estabel) then do:
          assign l-imprime = yes.
       end.
       
       find first movto-cota no-lock
            where  movto-cota.cod-estabel     = cotas.cod-estabel
            and    movto-cota.cod-canal-venda = cotas.cod-canal-venda
            and    movto-cota.cod-gr-cli      = cotas.cod-gr-cli
            and    movto-cota.nome-abrev      = cotas.nome-abrev
            and    movto-cota.nome-ab-reg     = cotas.nome-ab-reg
            and    movto-cota.nome-mic-reg    = cotas.nome-mic-reg
            and    movto-cota.cod-rep         = cotas.cod-rep
            and    movto-cota.cd-produto      = cotas.cd-produto  
            and    movto-cota.dt-inicial      = cotas.dt-inicial no-error.

       if avail movto-cota then do:
          if l-imprime = yes then do:
             disp c-estabel with stream-io frame f-estab.
             find estabelec no-lock 
                  where estabelec.cod-estabel = movto-cota.cod-estabel no-error.
             if avail estabelec then
                disp estabelec.nome with stream-io frame f-estab.
             assign l-imprime = no.   
          end.    
          if first-of(cotas.cod-canal-venda) or first-of(cotas.cod-gr-cli)   or
             first-of(cotas.nome-abrev)      or first-of(cotas.nome-ab-reg)  or
             first-of(cotas.nome-mic-reg)    or first-of(cotas.cod-rep)      then do:
           
             if LINE-COUNTER >= 54 then page.

             disp c-canal-venda with stream-io frame f-movto-cota.
             find canal-venda no-lock where canal-venda.cod-canal-venda = movto-cota.cod-canal-venda no-error.
             if avail canal-venda then 
                disp canal-venda.descricao with stream-io frame f-movto-cota.         

             disp c-gr-cli with stream-io frame f-movto-cota.
             find gr-cli no-lock where gr-cli.cod-gr-cli = movto-cota.cod-gr-cli no-error.
             if avail gr-cli then 
                disp gr-cli.descricao with stream-io frame f-movto-cota.             

             disp c-nome-abrev 
                  cotas.nome-abrev  with stream-io frame f-movto-cota.             

             disp c-ab-reg with stream-io frame f-movto-cota.
             find regiao no-lock where regiao.nome-ab-reg = movto-cota.nome-ab-reg no-error.
             if avail regiao then 
                assign c-desc-regiao = regiao.nome-regiao.             
             disp c-desc-regiao 
                  c-mic-reg with stream-io frame f-movto-cota.

             find micro-reg no-lock where micro-reg.nome-mic-reg = movto-cota.nome-mic-reg no-error.
             if avail micro-reg then
                assign c-nome-mic-reg = micro-reg.nome-mic-reg.
             disp c-nome-mic-reg 
                  c-cod-rep  with stream-io frame f-movto-cota.
           
             find repres no-lock 
                  where repres.cod-rep = cotas.cod-rep no-error.
             if avail repres then 
                disp repres.nome-abrev with stream-io frame f-movto-cota.
             else
                disp "" @ repres.nome-abrev with stream-io frame f-movto-cota.
                
             disp c-periodo
                  cotas.dt-inicial with stream-io frame f-movto-cota.

             /************************************************************ 
             *  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
             ************************************************************/
 
             &if defined (bf_dis_adm_cotas) &then
                 disp c-dt-movto       
                      c-produto       
                      c-usuario
                      c-pedido      
                      c-faturada 
                      c-canc-ped
                      c-canc-fat
                      c-susp-ped
                      c-reprov-ped
                      with frame f-cab2.
             &else
                 disp c-dt-movto       
                      c-produto       
                      c-usuario
                      c-pedido      
                      c-faturada 
                      c-canc-ped
                      c-canc-fat
                      c-susp-ped
                      with frame f-cab1.
             &endif                 
                
             for each b-movto-cota no-lock 
                 where b-movto-cota.cod-estabel     = movto-cota.cod-estabel
                 and   b-movto-cota.cod-canal-venda = movto-cota.cod-canal-venda
                 and   b-movto-cota.cod-gr-cli      = movto-cota.cod-gr-cli
                 and   b-movto-cota.nome-abrev      = movto-cota.nome-abrev
                 and   b-movto-cota.nome-ab-reg     = movto-cota.nome-ab-reg
                 and   b-movto-cota.nome-mic-reg    = movto-cota.nome-mic-reg
                 and   b-movto-cota.cod-rep         = movto-cota.cod-rep
                 and   b-movto-cota.cd-produto      = movto-cota.cd-produto  
                 and   b-movto-cota.dt-inicial      = movto-cota.dt-inicial
                 break by b-movto-cota.dt-movto
                       by b-movto-cota.cd-produto:
        
                 assign i-cont      = i-cont + 1.
                 
                 run pi-acompanhar in h-acomp (input b-movto-cota.cd-produto).
                 
                 /************************************************************ 
                 *  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
                 ************************************************************/
 
                 &if defined (bf_dis_adm_cotas) &then
                     put b-movto-cota.dt-movto      at 01
                         b-movto-cota.cd-produto    at 12
                         b-movto-cota.cod-usu-movto at 29
                         b-movto-cota.qt-pedida     at 42  format ">>>>>>>,>>9.99"
                         b-movto-cota.qt-faturada   at 57  format ">>>>>>>,>>9.99"
                         b-movto-cota.qt-ped-canc   at 72  format ">>>>>>>,>>9.99"
                         b-movto-cota.qt-fat-canc   at 87  format ">>>>>>>,>>9.99"
                         b-movto-cota.qt-ped-susp   at 102 format ">>>>>>>,>>9.99"
                         b-movto-cota.qt-ped-reprov at 119 format ">>>>>>>,>>9.99".
                 &else
                     put b-movto-cota.dt-movto      at 01
                         b-movto-cota.cd-produto    at 12
                         b-movto-cota.cod-usu-movto at 29
                         b-movto-cota.qt-pedida     at 41
                         b-movto-cota.qt-faturada   at 59
                         b-movto-cota.qt-ped-canc   at 77
                         b-movto-cota.qt-fat-canc   at 95
                         b-movto-cota.qt-ped-susp   at 113.
                 &endif
             end.    
          end.
          if last-of(cotas.cod-estabel) then do:
             page.
          end.
       end.  
    end.    
end.

run pi-finalizar in h-acomp.

/* **************** ImpressÆo da p gina de parƒmetros ************* */

if  page-number > 0 then page.
hide frame f-estab.
display c-selecao 
        tt-param.cod-estab-ini   
        tt-param.cod-estab-fim   
        tt-param.cod-canal-venda-ini   
        tt-param.cod-canal-venda-fim   
        tt-param.cod-gr-cli-ini
        tt-param.cod-gr-cli-fim
        tt-param.nome-abrev-ini
        tt-param.nome-abrev-fim
        tt-param.nome-ab-reg-ini    
        tt-param.nome-ab-reg-fim    
        tt-param.nome-mic-reg-ini     
        tt-param.nome-mic-reg-fim    
        tt-param.cod-rep-ini      
        tt-param.cod-rep-fim      
        tt-param.cd-produto-ini   
        tt-param.cd-produto-fim  
        c-parametro
        tt-param.dt-inicial
        c-impressao
        c-destino
        tt-param.arquivo
        tt-param.usuario
        with stream-io frame f-parametros.


{include/i-rpclo.i}

RETURN "OK".

/* Fim do Programa */


