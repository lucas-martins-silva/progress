/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0413RP 2.00.00.009 } /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac0413rp MAC}
&ENDIF

{include/i_fnctrad.i}
/*******************************************************************************
**
** Ac0413RP.P : ImpressÆo do relat¢rio de Base de Rateio por Produto
**
********************************************************************************/
{utp/ut-glob.i}
/* ************************ Defini‡Æo de vari veis *************************** */

{include/i-rpvar.i}

def var c-processa        as char format "x(20)"              no-undo.
def var c-selecao         as char format "x(11)"              no-undo.
def var c-parametro       as char format "x(14)"              no-undo.
def var c-impressao       as char format "x(12)"              no-undo.
def var c-destino         as char format "x(10)"              no-undo.
def var h-acomp           as handle                           no-undo.
def var c-estabel         as char format "x(07)"              no-undo.
def var c-canal-venda     as char format "x(11)"              no-undo.
def var c-gr-cliente      as char format "x(10)"              no-undo.
def var c-nome-ab-reg     as char format "x(06)"              no-undo.
def var c-nome-mic-reg    as char format "x(12)"              no-undo.
def var c-repres          as char format "x(06)"              no-undo.
def var c-desc-cod        as char format "x(40)"              no-undo.
def var c-desc-prod       as char format "x(60)"              no-undo.
def var i-num-reg-lido    as integer                          no-undo.
def var de-total-perc     as decimal format ">>9.99"          no-undo.
def var c-total           as char format "x(05)"              no-undo.
def var c-nome-repres     as char format "x(40)"              no-undo.
def var c-tit-nome-repres as char format "x(40)"              no-undo.
def var c-erro-rateio     as char format "x(13)"              no-undo.

{cdp/cdcfgdis.i} /*include para pr‚-processadores*/

def buffer b-base-rat for base-rat.

/* ********************  Defini‡Æo de Temp-Table ****************************** */

def temp-table tt-raw-digita
   field raw-digita      as raw.

{acp/ac0413.i}  /* Defini‡Æo da Temp-table tt-param */

def temp-table tt-base-rat like base-rat.

/* ************************ Defini‡Æo de parametros ************************** */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

/* *********** Defini‡Æo do layout da p gina de parƒmetros ****************** */

form skip(01)
     c-selecao   no-label    skip(1)
     tt-param.codigo-ini              colon 40 space(1) "|< >|"
     tt-param.codigo-fim           no-label colon 58 skip
     c-parametro no-label skip (1)
     tt-param.desc-opcao     colon 40 skip
     c-impressao             no-label skip(1)
     c-destino               colon 40
     " - ":U
     tt-param.arquivo no-label format "x(60)":U skip
     tt-param.usuario        colon 40 skip
     with down no-box side-labels width 132 stream-io frame f-parametros.

form tt-base-rat.codigo 
     " - "
     c-desc-cod no-label
     with no-box side-labels width 132 stream-io frame f-cab-cod.

form skip(1)
     tt-base-rat.cd-produto 
     " - "
     c-desc-prod no-label
     skip(1)
     with no-box side-labels width 132 stream-io frame f-cab-prod.

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
{utp/ut-liter.i Processando * L}
assign c-processa = trim(return-value).

{utp/ut-field.i mgdis base-rat codigo 1}
assign tt-param.codigo-ini:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Estabel * L}
assign c-estabel = trim(return-value).
{utp/ut-liter.i Canal_Venda * L}
assign c-canal-venda = trim(return-value).
{utp/ut-liter.i Gr_Cliente * L}
assign c-gr-cliente = trim(return-value).
{utp/ut-liter.i RegiÆo * L}
assign c-nome-ab-reg = trim(return-value).
{utp/ut-liter.i MicrorregiÆo * L}
assign c-nome-mic-reg = trim(return-value).
{utp/ut-liter.i Repres * L}
assign c-repres = trim(return-value).
{utp/ut-liter.i Total: * L}
assign c-total = trim(return-value).
{utp/ut-liter.i Nome_do_Representante * L}
assign c-tit-nome-repres = trim(return-value).
{utp/ut-liter.i (erro_rateio) * L}
assign c-erro-rateio = trim(return-value).
{utp/ut-liter.i Op‡Æo * L}
assign tt-param.desc-opcao:label in frame f-parametros = trim(return-value).

/* ************************ Inicio do programa ****************************** */
run utp/ut-trfrrp.p (input frame f-cab-prod:handle).
run utp/ut-trfrrp.p (input frame f-cab-cod:handle).
run utp/ut-trfrrp.p (input frame f-parametros:handle).
{include/i-rpcab.i}
create tt-param.
raw-transfer raw-param to tt-param no-error.

run utp/ut-acomp.p persistent set h-acomp.
find empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
if avail empresa then
   assign c-empresa = empresa.razao-social.

{utp/ut-liter.i Cotas MAP C}
assign c-programa = 'ap0413'
       c-versao   = 'A.00'
       c-revisao  = '000'
       c-sistema  = return-value
.
&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao001 = {varinc/var00002.i 04 tt-param.destino}.
    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                        INPUT "",
                        INPUT "").
    ASSIGN c-destino  = RETURN-VALUE.
&else
    ASSIGN c-destino  = {varinc/var00002.i 04 tt-param.destino}.
&endif

{utp/ut-liter.i Relat¢rio_de_Base_de_Rateio MAP C}
assign c-titulo-relat = return-value.

{include/i-rpout.i &tofile=tt-param.arquivo}
view frame f-cabec.
view frame f-rodape.

run pi-inicializar in h-acomp (input c-processa).
/*RUN pi-seta-tipo IN h-acomp (INPUT 2).*/
assign i-num-reg-lido = 0
       de-total-perc  = 0.

main-block:
do  on error  undo main-block, leave main-block
    on endkey undo main-block, leave main-block
    on stop   undo main-block, leave main-block:

   run pi-monta-tt.

   for each tt-base-rat
       break by tt-base-rat.codigo
             by tt-base-rat.cd-produto
             by tt-base-rat.cod-estabel
             by tt-base-rat.cod-canal-venda
             by tt-base-rat.cod-gr-cli:

       assign i-num-reg-lido = i-num-reg-lido + 1.
       run pi-acompanhar in h-acomp (input i-num-reg-lido).

       if first-of (tt-base-rat.codigo) then do:
          disp tt-base-rat.codigo with frame f-cab-cod.
          find tipo-baserat no-lock
               where tipo-baserat.codigo = tt-base-rat.codigo no-error.
          if avail tipo-baserat then
             disp tipo-baserat.descricao @ c-desc-cod with frame f-cab-cod.
          else
             disp "" @ c-desc-cod with frame f-cab-cod.
       end.

       if first-of (tt-base-rat.cd-produto) then do:
          disp tt-base-rat.cd-produto with frame f-cab-prod.
          find item no-lock
               where item.it-codigo = tt-base-rat.cd-produto no-error.
          if avail item then
             disp item.desc-item @ c-desc-prod with frame f-cab-prod.
          else do:
             /************************************************************ 
             *  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
             ************************************************************/

             &if defined (bf_dis_adm_cotas) &then
                 find produto-coml no-lock
                      where produto-coml.cod-produto-coml = tt-base-rat.cd-produto no-error.
                 if avail produto-coml then
                    disp produto-coml.des-produto-coml @ c-desc-prod with frame f-cab-prod.
                 else
                    disp "" @ c-desc-prod with frame f-cab-prod.
             &else
                 find produto no-lock
                      where produto.cd-produto = tt-base-rat.cd-produto no-error.
                 if avail produto then
                    disp produto.descricao @ c-desc-prod with frame f-cab-prod.
                 else
                    disp "" @ c-desc-prod with frame f-cab-prod.
             &endif
          end.
          put c-estabel                  at 004
              c-canal-venda              at 012
              c-gr-cliente               at 024
              c-nome-ab-reg              at 035
              c-nome-mic-reg             at 048
              c-repres                   at 061
              c-tit-nome-repres          at 068
              "%":U                      at 109
              skip
              "-------"                   at 004
              "-----------"               at 012
              "----------"                at 024
              "------------"              at 035
              "------------"              at 048
              "------"                    at 061
              fill("-",40) format "x(40)" at 068
              "------"                    at 109
              skip.
       end.

       find repres no-lock
            where repres.cod-rep = tt-base-rat.cod-rep no-error.
       if avail repres then
          assign c-nome-repres = repres.nome.
       else
          assign c-nome-repres = "".

       put tt-base-rat.cod-estabel     to 012
           tt-base-rat.cod-canal-venda at 020
           tt-base-rat.cod-gr-cli      at 030
           tt-base-rat.nome-ab-reg     at 035
           tt-base-rat.nome-mic-reg    at 048
           tt-base-rat.cod-rep         at 062
           c-nome-repres               at 068
           tt-base-rat.pct-rateio      at 109
           skip.

       IF tt-base-rat.cod-rep <> ? THEN
            assign de-total-perc = de-total-perc + tt-base-rat.pct-rateio.

       if last-of (tt-base-rat.cd-produto) then do:
          put "======"      at 109 skip
              c-total       at 100
              de-total-perc at 109.
          if de-total-perc > 100.00 then
             put c-erro-rateio at 117 skip.
          else
             put skip.
          assign de-total-perc = 0.
       end.

       if last-of (tt-base-rat.codigo) then
          page.

   end.

end.
run pi-finalizar in h-acomp.

/* **************** ImpressÆo da p gina de parƒmetros ************* */

if  page-number > 0 then page.
display c-selecao 
        tt-param.codigo-ini   
        tt-param.codigo-fim   
        c-parametro
        tt-param.desc-opcao
        c-impressao
        c-destino
        tt-param.arquivo
        tt-param.usuario
        with frame f-parametros.

{include/i-rpclo.i}

 RETURN "OK".

/* fim do programa  */


/****************************** PROCEDURE INTERNA ************************************/

/**************************/
/*** MONTA A TEMP-TABLE ***/
/**************************/
procedure pi-monta-tt:
def var de-tot-perc as dec format ">>9.99" no-undo.

  /******* Limpa a temp-table *******/
  for each tt-base-rat:
     delete tt-base-rat.
  end.

  assign de-tot-perc = 0.
  for each base-rat no-lock
      where base-rat.codigo >= tt-param.codigo-ini
      and   base-rat.codigo <= tt-param.codigo-fim
      break by base-rat.codigo
            by base-rat.cd-produto:

      assign de-tot-perc = de-tot-perc + base-rat.pct-rateio.

      if last-of (base-rat.cd-produto) then do:
         if tt-param.opcao-perc = 3 then
            run pi-cria-tt.
         else
            if tt-param.opcao-perc = 1 then do:
               if de-tot-perc > 100.00 then
                  run pi-cria-tt.
            end.
            else
               if tt-param.opcao-perc = 2 then do:
                  if de-tot-perc <= 100.00 then
                     run pi-cria-tt.
               end.
         assign de-tot-perc = 0.
      end.

  end.

end procedure.

/*************************/
/*** CRIA A TEMP-TABLE ***/
/*************************/
procedure pi-cria-tt:

   for each b-base-rat no-lock 
       where b-base-rat.codigo     = base-rat.codigo
       and   b-base-rat.cd-produto = base-rat.cd-produto:

       create tt-base-rat.
       buffer-copy b-base-rat to tt-base-rat.

   end.

end procedure.

/* Fim do Programa */


