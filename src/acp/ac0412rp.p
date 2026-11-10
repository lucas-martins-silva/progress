/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0412RP 2.00.00.014 } /*** 010014 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ac0412rp MAC}
&ENDIF

/*******************************************************************************
**
** Ac0412RP.P : Relat¢rio de Cotas por Canal/RegiÆo/Repres/Grupo Cliente
**
********************************************************************************/
{utp/ut-glob.i}
/* ************************ Defini‡Æo de vari veis *************************** */

{include/i-rpvar.i}

{cdp/cdcfgdis.i} /*include para pr‚-processadores*/

def var c-regiao          as char format "x(12)"              no-undo.
def var c-nome            as char format "x(14)"              no-undo.
def var c-nome-gr         as char format "x(10)"              no-undo.
def var c-selecao         as char format "x(11)"              no-undo.
def var c-repres          as char format "x(10)"              no-undo.
def var c-cota            as char format "x(05)"              no-undo.
def var c-total           as char format "x(05)"              no-undo.
def var c-tot-ger         as char format "x(11)"              no-undo.
def var c-realizado       as char format "x(09)"              no-undo.
def var c-grupo           as char format "x(13)"              no-undo.
def var c-cliente         as char format "x(08)"              no-undo.
def var c-impressao       as char format "x(12)"              no-undo.
def var c-destino         as char format "x(10)"              no-undo.
def var h-acomp           as handle                           no-undo.
def var de-tot-realizado  like cotas.qt-pedida                no-undo.
def var de-tot-prevista   like cotas.qt-prevista              no-undo.
def var de-tot-prev-canal like cotas.qt-prevista              no-undo.
def var de-tot-real-canal like cotas.qt-pedida                no-undo.

/* ********************  Defini‡Æo de Temp-Table ****************************** */

def temp-table tt-raw-digita
   field raw-digita      as raw.

def temp-table tt-cotas 
   field cod-estabel     like cotas.cod-estabel
   field cod-canal-venda like cotas.cod-canal-venda
   field cod-gr-cli      like cotas.cod-gr-cli
   field nome-ab-reg     like cotas.nome-ab-reg
   field cod-rep         like cotas.cod-rep
   field qt-prevista     like cotas.qt-prevista
   field qt-pedida       like cotas.qt-pedida
   INDEX grupo IS PRIMARY 
                  cod-estabel
                  cod-canal-venda                 
                  nome-ab-reg 
                  cod-gr-cli
                  cod-rep ASCENDING.
   
{acp/ac0412.i}  /* Defini‡Æo da Temp-table tt-param */

/* ************************ Defini‡Æo de parametros ************************** */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

/* *********** Defini‡Æo do layout da p gina de parƒmetros ****************** */

form skip(01)
     c-selecao   no-label    skip(1)
     &IF "{&mguni_version}" >= "2.071" &THEN
     tt-param.cod-estab-ini              colon 40 space(12) "|< >|"           
     &ELSE
     tt-param.cod-estab-ini              colon 40 space(14) "|< >|"
     &ENDIF       
     tt-param.cod-estab-fim           no-label colon 73 skip
     tt-param.cod-canal-venda-ini        colon 40 space(14) "|< >|"
     tt-param.cod-canal-venda-fim     no-label colon 73 skip
     tt-param.cod-gr-cli-ini             colon 40 space(13) "|< >|"
     tt-param.cod-gr-cli-fim          no-label colon 73 skip
     tt-param.nome-ab-reg-ini            colon 40 space(05) "|< >|"
     tt-param.nome-ab-reg-fim         no-label colon 73 skip
     tt-param.cod-rep-ini                colon 40 space(12) "|< >|"
     tt-param.cod-rep-fim             no-label colon 73 skip
     tt-param.dt-inicial                 colon 40 space(7) "|< >|"
     tt-param.dt-final                no-label colon 73 skip
     c-impressao             no-label skip(1)
     c-destino               colon 40
     " - ":U
     tt-param.arquivo no-label format "x(60)":U skip
     tt-param.usuario        colon 40 skip
     with down no-box side-labels width 132 stream-io frame f-parametros.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-parametros:HANDLE).


DO:
form tt-cotas.cod-estabel     at 01                  
     estabelec.nome no-label  at 32 skip
     tt-cotas.cod-canal-venda at 01
     canal-venda.descricao no-label at 32 skip
     skip(1)
     with side-labels stream-io no-attr-space frame f-canal. 
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-canal:HANDLE).

END.  
           

/* *********************** Defini‡Æo de literais  ***************************** */

{utp/ut-liter.i SELE€ÇO * R}
assign c-selecao = trim(return-value).
{utp/ut-liter.i IMPRESSÇO * R}
assign c-impressao = trim(return-value).
{utp/ut-liter.i Destino * L}
assign c-destino:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Usu rio * L}
assign tt-param.usuario:label in frame f-parametros = trim(return-value).

{utp/ut-field.i mgdis cotas nome-ab-reg 1}
assign c-regiao = trim(return-value).
{utp/ut-field.i mgdis cotas cod-rep 2}
assign c-repres = trim(return-value).
{utp/ut-field.i mgadm repres nome-abrev 2}
assign c-nome = trim(return-value).
{utp/ut-field.i mgadm gr-cli descricao 1}
assign c-nome-gr = trim(return-value).
{utp/ut-liter.i Cota * R}
assign c-cota = trim(return-value).
{utp/ut-liter.i Grupo_Cliente * R}
assign c-grupo = trim(return-value).
{utp/ut-liter.i Total * R}
assign c-total = trim(return-value).
{utp/ut-liter.i Total_Geral * R}
assign c-tot-ger = trim(return-value).
{utp/ut-liter.i Realizado * R}
assign c-realizado = trim(return-value).

/* ************************ Inicio do programa ****************************** */
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.

run utp/ut-acomp.p persistent set h-acomp.
find empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
if avail empresa then
   assign c-empresa = empresa.razao-social.

{utp/ut-liter.i Cotas MAP C}
assign c-programa = 'ap0412'
       c-sistema  = return-value
       c-destino  = {varinc/var00002.i 04 tt-param.destino}.
 
{utp/ut-liter.i Relat¢rio_Cotas_Realizadas_por_RegiÆo MAP C}
assign c-titulo-relat = return-value.

{include/i-rpout.i}
view frame f-cabec.
view frame f-rodape.

run pi-inicializar in h-acomp (input "Aguarde...").
main-block:
do  on error  undo main-block, leave main-block
    on endkey undo main-block, leave main-block
    on stop   undo main-block, leave main-block:
    
    /************************************************************ 
    *  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
    ************************************************************/
 
    &if defined (bf_dis_adm_cotas) &then
        for each cotas no-lock
            where   cotas.cod-estabel     >= tt-param.cod-estab-ini
              and   cotas.cod-estabel     <= tt-param.cod-estab-fim
            and   ((cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
              and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim)
              or    cotas.cod-canal-venda  = ?)
            and   ((cotas.cod-gr-cli      >= tt-param.cod-gr-cli-ini
              and   cotas.cod-gr-cli      <= tt-param.cod-gr-cli-fim)
              or    cotas.cod-gr-cli       = ?)
            and   ((cotas.nome-ab-reg     >= tt-param.nome-ab-reg-ini
              and   cotas.nome-ab-reg     <= tt-param.nome-ab-reg-fim)
              or    cotas.nome-ab-reg      = ?)
            and     cotas.cod-rep         >= tt-param.cod-rep-ini
              and   cotas.cod-rep         <= tt-param.cod-rep-fim
            and     cotas.dt-inicial      >= tt-param.dt-inicial
              and   cotas.dt-inicial      <= tt-param.dt-final
            break by cotas.cod-estabel
                  by cotas.cod-canal-venda
                  by cotas.cod-gr-cli
                  by cotas.nome-ab-reg
                  by cotas.cod-rep:
    &else
        for each cotas no-lock
            where   cotas.cod-estabel     >= tt-param.cod-estab-ini
              and   cotas.cod-estabel     <= tt-param.cod-estab-fim
            and   ((cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
              and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim)
              or    cotas.cod-canal-venda  = ?)
            and   ((cotas.cod-gr-cli      >= tt-param.cod-gr-cli-ini
              and   cotas.cod-gr-cli      <= tt-param.cod-gr-cli-fim)
              or    cotas.cod-gr-cli       = ?)
            and   ((cotas.nome-ab-reg     >= tt-param.nome-ab-reg-ini
              and   cotas.nome-ab-reg     <= tt-param.nome-ab-reg-fim)
              or    cotas.nome-ab-reg      = ?)
            and   ((cotas.cod-rep         >= tt-param.cod-rep-ini
              and   cotas.cod-rep         <= tt-param.cod-rep-fim)
              or    cotas.cod-rep          = ?)
            and     cotas.dt-inicial      >= tt-param.dt-inicial
              and   cotas.dt-inicial      <= tt-param.dt-final
            break by cotas.cod-estabel
                  by cotas.cod-canal-venda
                  by cotas.cod-gr-cli
                  by cotas.nome-ab-reg
                  by cotas.cod-rep:
    &endif
        
        run pi-acompanhar in h-acomp (input cotas.cod-rep).

        find tt-cotas 
             where tt-cotas.cod-estabel     = cotas.cod-estabel
             and   tt-cotas.cod-canal-venda = cotas.cod-canal-venda
             and   tt-cotas.cod-gr-cli      = cotas.cod-gr-cli
             and   tt-cotas.nome-ab-reg     = cotas.nome-ab-reg
             and   tt-cotas.cod-rep         = cotas.cod-rep  no-error.
               
        if not avail  tt-cotas then do:
           create tt-cotas.
           assign tt-cotas.cod-estabel     = cotas.cod-estabel
                  tt-cotas.cod-canal-venda = cotas.cod-canal-venda
                  tt-cotas.cod-gr-cli      = cotas.cod-gr-cli
                  tt-cotas.nome-ab-reg     = cotas.nome-ab-reg
                  tt-cotas.cod-rep         = cotas.cod-rep
                  tt-cotas.qt-prevista     = cotas.qt-prevista
                  tt-cotas.qt-pedida       = cotas.qt-pedida.
        end.
        else
           assign tt-cotas.qt-prevista = tt-cotas.qt-prevista + cotas.qt-prevista
                  tt-cotas.qt-pedida   = tt-cotas.qt-pedida   + cotas.qt-pedida.
    end.          
    for each tt-cotas use-index grupo 
        break by tt-cotas.cod-estabel
              by tt-cotas.cod-canal-venda
              by tt-cotas.nome-ab-reg
              by tt-cotas.cod-rep
              by tt-cotas.cod-gr-cli:
 
        run pi-acompanhar in h-acomp (input tt-cotas.cod-rep).
    
        if first-of(tt-cotas.cod-canal-venda) or first-of(tt-cotas.nome-ab-reg) then do:
           disp tt-cotas.cod-estabel with frame f-canal.
           find estabelec no-lock where estabelec.cod-estabel = tt-cotas.cod-estabel no-error.
           if avail estabelec then
              disp estabelec.nome with frame f-canal.         
           disp tt-cotas.cod-canal-venda  with frame f-canal.
           find canal-venda no-lock where canal-venda.cod-canal-venda = tt-cotas.cod-canal-venda no-error.
           if avail canal-venda then
              disp canal-venda.descricao no-label with frame f-canal.  
   
           put c-regiao               at 01 
               c-repres               at 13
               c-nome                 at 25
               c-grupo                at 40
               c-nome-gr              at 54
               c-cota                 at 88
               c-realizado            at 101
               "%"                    at 114
               "-----------"          at 01
               "----------"           at 13
               "--------------"       at 25
               "-------------"        at 40
               "--------------------" at 54
               "-----------------"    at 75
               "-----------------"    at 93
               "------"               at 111.
        end.  
        if first-of(tt-cotas.cod-rep) then do:
           put tt-cotas.nome-ab-reg at 01
               tt-cotas.cod-rep     at 18.
           find repres no-lock 
                where repres.cod-rep = tt-cotas.cod-rep no-error.
           if avail repres then
              put repres.nome-abrev at 25.
        end.

        put tt-cotas.cod-gr-cli  at 49.
        find gr-cli no-lock 
             where gr-cli.cod-gr-cli = tt-cotas.cod-gr-cli no-error.
        if avail gr-cli then
           put gr-cli.descricao format "x(20)" at 54.
           
        put tt-cotas.qt-prevista at 75
            tt-cotas.qt-pedida   at 93
            (tt-cotas.qt-pedida * 100) / tt-cotas.qt-prevista format ">>9.99" at 111.

        assign de-tot-prevista = de-tot-prevista + tt-cotas.qt-prevista
               de-tot-realizado = de-tot-realizado + tt-cotas.qt-pedida. 

        if last-of(tt-cotas.cod-rep) then do:
           put  "-----------------" at 75
                "-----------------" at 93
                "%":U               at 114 
                de-tot-prevista     at 75 
                de-tot-realizado    at 93 
               (de-tot-realizado * 100) / de-tot-prevista format ">>9.99" at 111 skip(1).
           
           assign de-tot-prev-canal = de-tot-prev-canal + de-tot-prevista
                  de-tot-real-canal = de-tot-real-canal + de-tot-realizado
                  de-tot-prevista   = 0
                  de-tot-realizado  = 0.
        end.

        if last-of(tt-cotas.cod-canal-venda) then do:
           put  "-----------------" at 75
                "-----------------" at 93
                "%":U               at 114 
                c-tot-ger           at 62                              
                de-tot-prev-canal   at 75 
                de-tot-real-canal   at 93 
                (de-tot-real-canal * 100) / de-tot-prev-canal format ">>9.99" at 111 skip(2).
           /*page.*/
           assign de-tot-prev-canal = 0
                  de-tot-real-canal = 0.           
        end.
        
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
        tt-param.nome-ab-reg-ini    
        tt-param.nome-ab-reg-fim    
        tt-param.cod-rep-ini      
        tt-param.cod-rep-fim      
        tt-param.dt-inicial
        tt-param.dt-final
        c-impressao
        c-destino
        tt-param.arquivo
        tt-param.usuario
        with frame f-parametros.

{include/i-rpclo.i}

RETURN "OK".

/* Fim do Programa */


