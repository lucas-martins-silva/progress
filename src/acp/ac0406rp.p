/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0406RP 2.00.00.014}  /*** 010014 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ac0406rp MAC}
&ENDIF

/*******************************************************************************
**
** Ac0406RP.P : ImpressÆo do relat¢rio de transferˆncias no per¡odo
**
********************************************************************************/
{utp/ut-glob.i}
/* ************************ Defini‡Æo de vari veis *************************** */

{include/i-rpvar.i}

def var c-selecao      as char format "x(11)"      no-undo.
def var c-parametro    as char format "x(14)"      no-undo.
def var c-impressao    as char format "x(12)"      no-undo.
def var c-destino      as char format "x(10)"      no-undo.
def var h-acomp        as handle                   no-undo.
def var rs-classif     as integer format "9"       no-undo.
def var c-origem       as char    format "x(6)"    no-undo.
def var c-dest         as char    format "x(7)"    no-undo.
def var c-canal        as char    format "x(5)"    no-undo.
def var c-grupo        as char    format "x(5)"    no-undo.
def var c-codigo       as char    format "x(3)"    no-undo.
def var c-venda        as char    format "x(5)"    no-undo.
def var c-cliente      as char    format "x(7)"    no-undo.
def var c-regiao       as char    format "x(6)"    no-undo.
def var c-micro        as char    format "x(12)"   no-undo.
def var c-repres       as char    format "x(6)"    no-undo.
def var c-qt-trans     as char    format "x(14)"   no-undo.
def var c-dt-trans     as char    format "x(09)"   no-undo.
def var dt-inicial     as date format "99/99/9999" no-undo.
def var dt-final       like cotas.dt-inicial       no-undo.
def var c-label-2      as character                no-undo.
DEF VAR c-produto      AS CHAR FORMAT "x(19)"      NO-UNDO.

{cdp/cdcfgdis.i} /*include para pr‚-processadores*/

/* ********************  Defini‡Æo de Temp-Table ****************************** */

def temp-table tt-raw-digita
   field raw-digita      as raw.

{acp/ac0406.i}  /* Defini‡Æo da Temp-table tt-param */

/* ************************ Defini‡Æo de parametros ************************** */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

/* *********** Defini‡Æo do layout da p gina de parƒmetros ****************** */

form c-label-2  at 01
     dt-inicial at 11 space(02) "|<  >|"
     dt-final   no-label colon 27 skip(2)
     with no-box no-label no-attr page-top width 132 stream-io frame f-cabecalho.


form skip(01)
     c-selecao   no-label     skip(1)
     tt-param.cod-estab-ini    colon 40 space(16) "|< >|"
     tt-param.cod-estab-fim no-label colon 73 skip
     tt-param.periodo-ini        colon 40 space(11) "|< >|"
     tt-param.periodo-fim     no-label colon 73 skip
     tt-param.produto-ini        colon 40 space(05) "|< >|"
     tt-param.produto-fim     no-label colon 73 skip
     c-parametro no-label     skip(1)
     tt-param.dt-inicial         colon 40 skip   
     c-impressao no-label     skip(1)
     c-destino                   colon 40
     " - ":U
     tt-param.arquivo no-label format "x(60)":U skip
     tt-param.usuario        colon 40 skip(4)     
     with down no-box side-labels width 132 stream-io frame f-parametros.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-parametros:HANDLE).



/* *********************** Defini‡Æo de literais  ***************************** */

{utp/ut-liter.i SELE€ÇO * R}
assign c-selecao = trim(return-value).

{utp/ut-liter.i PAR¶METROS * R}
assign c-parametro = trim(return-value).

{utp/ut-liter.i IMPRESSÇO * R}
assign c-impressao = trim(return-value).

{utp/ut-liter.i Destino * L}
assign c-destino:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Usu rio * L}
assign tt-param.usuario:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Per¡odo * L}
assign tt-param.periodo-ini:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Produto/Item * R}
assign tt-param.produto-ini:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i ORIGEM * L}
assign c-origem = trim(return-value).

{utp/ut-liter.i DESTINO * L}
assign c-dest = trim(return-value).

{utp/ut-liter.i Canal * L}
assign c-canal = trim(return-value).

{utp/ut-liter.i Grupo * L}
assign c-grupo = trim(return-value).

{utp/ut-liter.i Cod * L}
assign c-codigo = trim(return-value).

{utp/ut-liter.i Venda * L}
assign c-venda = trim(return-value).

{utp/ut-liter.i Cliente * L}
assign c-cliente = trim(return-value).

{utp/ut-liter.i Produto/Item_Origem * L}
assign c-produto = trim(return-value).

{utp/ut-field.i mgdis cotas nome-ab-reg 1}
assign c-regiao = trim(return-value).

{utp/ut-field.i mgdis cotas nome-mic-reg 1}
assign c-micro = trim(return-value).

{utp/ut-field.i mgdis cotas cod-rep 1}
assign c-repres = trim(return-value).

{utp/ut-liter.i Qt_Transferida * L}
assign c-qt-trans = trim(return-value).

{utp/ut-liter.i Dt_Transf * L}
assign c-dt-trans = trim(return-value).

{utp/ut-liter.i Per¡odo * R}
assign c-label-2 = trim(return-value).


/* ************************ Inicio do programa ****************************** */
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.

{include/i-rpout.i}

       

run utp/ut-acomp.p persistent set h-acomp.
find empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
if avail empresa then
   assign c-empresa = empresa.razao-social.

assign c-programa = 'AC0406'
       c-destino  = {varinc/var00002.i 04 tt-param.destino}.
 
{utp/ut-liter.i Relat¢rio_Transferˆncias_no_Per¡odo MAP C}
assign c-titulo-relat = return-value.

view frame f-cabec.
view frame f-rodape.

find first cotas 
     where cotas.dt-inicial = tt-param.dt-inicial no-lock no-error.
if avail cotas then do:
   assign dt-inicial = tt-param.dt-inicial
          dt-final   = cotas.dt-final.
   disp c-label-2
        dt-inicial
        dt-final
        with frame f-cabecalho.
end.        


run pi-inicializar in h-acomp (input "Aguarde...").

main-block:
for each transfer no-lock
    where transfer.cod-estabel  >= tt-param.cod-estab-ini
    and   transfer.cod-estabel  <= tt-param.cod-estab-fim
    and   transfer.dt-transf    >= tt-param.periodo-ini
    and   transfer.dt-transf    <= tt-param.periodo-fim
    and   transfer.cd-produto-o >= tt-param.produto-ini
    and   transfer.cd-produto-o <= tt-param.produto-fim
    and   transfer.dt-inicial    = tt-param.dt-inicial 
    break by transfer.cd-produto-o: 
    
    run pi-acompanhar in h-acomp (input transfer.cd-produto-o).
    
    if first-of(transfer.cd-produto-o) then do:
       if LINE-COUNTER >= 52 then page.
       

       PUT skip(1) c-produto ": "  transfer.cd-produto-o "  -  "  .
       
    &if defined (bf_dis_adm_cotas) &then
       find produto-coml no-lock
            where produto-coml.cod-produto-coml = transfer.cd-produto-o no-error.
       if avail produto-coml then
          PUT produto-coml.des-produto-coml format "x(40)" at 50 SKIP(1).
       ELSE
    &else
       find produto no-lock
            where produto.cd-produto = transfer.cd-produto-o no-error.
       if avail produto then
           PUT produto.descricao format "x(40)" at 50 SKIP(1).
       ELSE 
    &endif
          FOR FIRST ITEM FIELDS (desc-item) WHERE 
                    ITEM.it-codigo = transfer.cd-produto-o NO-LOCK :
              PUT ITEM.desc-item FORMAT "x(50)" AT 50 SKIP(1).
          END.
       
       
       put "|----------------------" c-origem "----------------------|" space(1)
           "|----------------------" c-dest   "----------------------|" skip(1).
       put c-canal  at 03 c-grupo  at 09
           c-codigo at 44 c-canal  at 58
           c-grupo  at 64 c-codigo at 98 skip.
        
       put c-venda    at 03  
           c-cliente  at 09
           c-regiao   at 24  
           c-micro    at 31
           c-repres   at 44  
           c-venda    at 58
           c-cliente  at 64  
           c-regiao   at 78
           c-micro    at 85  
           c-repres   at 98
           c-qt-trans at 108 
           c-dt-trans at 124 
           "-----"    at 03
           "-------"  at 09
           "-------------"   at 17
           "------------"    at 31
           "------"          at 44
           "-----"           at 58
           "-------"         at 64
           "------------"    at 72
           "------------"    at 85
           "------"          at 98
           "--------------"  at 108
           "----------"      at 123  skip.
             
    end.

    put transfer.cod-canal-venda-o  at 05
        transfer.cod-gr-cli-o       at 14
        transfer.nome-ab-reg-o      at 17
        transfer.nome-mic-reg-o     at 31
        transfer.cod-rep-o          at 45
        transfer.cod-canal-venda-d  at 60
        transfer.cod-gr-cli-d       at 69
        transfer.nome-ab-reg-d      at 72
        transfer.nome-mic-reg-d     at 85
        transfer.cod-rep-d          at 99
        transfer.qt-transf    format ">>>,>>>,>>9.99" at 108
        transfer.dt-transf          at 123.
       
end.
run pi-finalizar in h-acomp.

hide frame f-cabecalho.

/* **************** ImpressÆo da p gina de parƒmetros ************* */

if  page-number > 0 then page.
display c-selecao 
        tt-param.cod-estab-ini
        tt-param.cod-estab-fim
        tt-param.periodo-ini   
        tt-param.periodo-fim   
        tt-param.produto-ini    
        tt-param.produto-fim    
        c-parametro
        tt-param.dt-inicial
        c-impressao
        c-destino
        tt-param.arquivo
        tt-param.usuario
        with frame f-parametros.
down with frame f-parametros.

{include/i-rpclo.i}

RETURN "OK".

/* Fim do Programa */




