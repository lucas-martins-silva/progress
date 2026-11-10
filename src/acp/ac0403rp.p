/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0403RP 2.00.00.011 } /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AC0403RP MAC}
&ENDIF



/*******************************************************************************
**
** Ac0403RP.P : Relatorio Comparativo Cotas de Representantes
**
********************************************************************************/
{utp/ut-glob.i}
/* ************************ Defini‡Æo de vari veis *************************** */

{include/i-rpvar.i}

def var c-selecao      as char format "x(11)"              no-undo.
def var c-classifica   as char format "x(14)"              no-undo.
def var c-parametro    as char format "x(14)"              no-undo.
def var c-impressao    as char format "x(12)"              no-undo.
def var c-destino      as char format "x(10)"              no-undo.
def var h-acomp        as handle                           no-undo.
def var rs-classif     as integer format "9"               no-undo.

/* ********************  Defini‡Æo de Temp-Table ****************************** */

def temp-table tt-raw-digita
   field raw-digita      as raw.

{acp/ac0403.i}  /* Defini‡Æo da Temp-table tt-param */

/* ************************ Defini‡Æo de parametros ************************** */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

/* *********** Defini‡Æo do layout da p gina de parƒmetros ****************** */

form skip(01)
     c-selecao   no-label    skip(1)
     tt-param.cod-estab-ini              colon 40 space(12) "|< >|"
     tt-param.cod-estab-fim           no-label colon 73 skip
     tt-param.cod-canal-venda-ini        colon 40 space(14) "|< >|"
     tt-param.cod-canal-venda-fim     no-label colon 73 skip
     tt-param.cod-gr-cli-ini             colon 40 space(13) "|< >|"
     tt-param.cod-gr-cli-fim          no-label colon 73 skip
     tt-param.nome-abrev-ini             colon 40 space(5)  "|< >|"
     tt-param.nome-abrev-fim          no-label colon 73 skip     
     tt-param.nome-ab-reg-ini            colon 40 space(05) "|< >|"
     tt-param.nome-ab-reg-fim         no-label colon 73 skip
     tt-param.nome-mic-reg-ini           colon 40 space(05) "|< >|"
     tt-param.nome-mic-reg-fim        no-label colon 73 skip
     tt-param.cod-rep-ini                colon 40 space(12) "|< >|"
     tt-param.cod-rep-fim             no-label colon 73 skip
     tt-param.cd-produto-ini             colon 40 space(1)  "|< >|"
     tt-param.cd-produto-fim          no-label colon 73 skip(1)

     c-classifica                     no-label skip(1)
     tt-param.desc-classifica            colon 40 skip(1)

     c-parametro                      no-label    skip(1)
     tt-param.dt-inicial                 colon 40 skip   
     tt-param.dt-final                   colon 40 skip
     tt-param.considera                  colon 40 skip(1)

     c-impressao                      no-label    skip(1)
     c-destino                           colon 40
     " - ":U
     tt-param.arquivo                 no-label format "x(60)":U skip
     tt-param.usuario                    colon 40 skip
     with down no-box side-labels width 132 stream-io frame f-parametros.


/* *********************** Defini‡Æo de literais  ***************************** */

{utp/ut-liter.i SELE€ÇO * R}
assign c-selecao = trim(return-value).

{utp/ut-field.i mgdis cotas cod-estabel 1}
assign tt-param.cod-estab-ini:label in frame f-parametros = trim(return-value).

{utp/ut-field.i mgdis cotas cod-canal-venda 1}
assign tt-param.cod-canal-venda-ini:label in frame f-parametros = trim(return-value).

{utp/ut-field.i mgdis cotas cod-gr-cli 1}
assign tt-param.cod-gr-cli-ini:label in frame f-parametros = trim(return-value).

{utp/ut-field.i mgdis cotas nome-ab-reg 1}
assign tt-param.nome-ab-reg-ini:label in frame f-parametros = trim(return-value).

{utp/ut-field.i mgdis cotas nome-mic-reg 1}
assign tt-param.nome-mic-reg-ini:label in frame f-parametros = trim(return-value).

{utp/ut-field.i mgdis cotas cod-rep 1}
assign tt-param.cod-rep-ini:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Produto/Item * R}
assign tt-param.cd-produto-ini:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i CLASSIFICA€ÇO * R}
assign c-classifica = trim(return-value).
{utp/ut-liter.i Classifica * R}
assign tt-param.desc-classifica:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i PAR¶METROS * R}
assign c-parametro = trim(return-value).
{utp/ut-liter.i Primeiro_Per¡odo * L}
assign tt-param.dt-inicial:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Segundo_Per¡odo * L}
assign tt-param.dt-final:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Considera_Cancelados_e_Suspensos * L}
assign tt-param.considera:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i IMPRESSÇO * R}
assign c-impressao = trim(return-value).
{utp/ut-liter.i Destino * L}
assign c-destino:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Usu rio * L}
assign tt-param.usuario:label in frame f-parametros = trim(return-value).

/* ************************ Inicio do programa ****************************** */
run utp/ut-trfrrp.p (input frame f-parametros:handle).
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.

run utp/ut-acomp.p persistent set h-acomp.
find empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
if avail empresa then
   assign c-empresa = empresa.razao-social.

assign c-programa = 'ap0403'
       c-destino  = {varinc/var00002.i 04 tt-param.destino}.

{utp/ut-liter.i Relat¢rio_Comparativo_Cotas_entre_Per¡odos MAP C}
assign c-titulo-relat = return-value.


{include/i-rpout.i}
view frame f-cabec.
view frame f-rodape.
{utp/ut-liter.i Aguarde... *}

run pi-inicializar in h-acomp (input  Return-value ).
main-block:
do  on error  undo main-block, leave main-block
    on endkey undo main-block, leave main-block
    on stop   undo main-block, leave main-block:

    assign rs-classif = tt-param.classifica.       
    if  rs-classif = 1 then do:
      run acp/ac0403a.p (input-output raw-param).
      raw-transfer raw-param to tt-param.
    end.
    if  rs-classif = 2 then do:
      run acp/ac0403b.p (input-output raw-param).
      raw-transfer raw-param to tt-param.
    end.
end.
run pi-finalizar in h-acomp.

/* **************** ImpressÆo da p gina de parƒmetros ************* */

if  page-number > 0 then page.
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
        c-classifica
        tt-param.desc-classifica
        c-parametro
        tt-param.dt-inicial
        tt-param.dt-final
        tt-param.considera     
        c-impressao
        c-destino
        tt-param.arquivo
        tt-param.usuario
        with stream-io frame f-parametros.

if  tt-param.considera = yes then  
    {utp/ut-liter.i Sim * R} 
else 
    {utp/ut-liter.i NÆo * R}.
disp trim(return-value) @ tt-param.considera 
     with stream-io frame f-parametros.
down with frame f-parametros.

{include/i-rpclo.i}

RETURN "OK".

/* Fim do Programa */


