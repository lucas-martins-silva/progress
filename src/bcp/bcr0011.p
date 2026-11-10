/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCR0011 2.00.00.010}  /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" 
&THEN
{include/i-license-manager.i BCR0011 MBC}
&ENDIF



/*****************************************************************************
**
**       Programa: bcr0011.p
**
**       Data....: 20/04/99
**
**       Autor...: DATASUL S.A.
**
**       Objetivo: Relat¢rio de Transaá‰es
**
**       Vers∆o..: 1.00.000 - bc
**
**       OBS.....: Este fonte foi gerado pelo Data Viewer
**
*******************************************************************************/



/****************** Definiá∆o de Tabelas Tempor†rias do Relat¢rio **********************/

def temp-table tt-raw-digita NO-UNDO
    field raw-digita as raw.

define temp-table tt-param NO-UNDO
    field destino              as integer
    field arquivo              as char
    field usuario              as char
    field data-exec            as date
    field hora-exec            as integer
    field parametro            as logical
    field formato              as integer
    field v_num_tip_aces_usuar as integer
    field ep-codigo            LIKE empresa.ep-codigo
    field c-cd-trans-ini       like bc-tipo-trans.cd-trans
    field c-cd-trans-fim       like bc-tipo-trans.cd-trans
.

/****************** INCLUDE COM VARIµVEIS GLOBAIS *********************/

{utp/ut-glob.i}
{include/i_fnctrad.i} 

/****************** FIM INCLUDE COM VARIµVEIS GLOBAIS *********************/
/****************** Definiáao de ParÉmetros do Relat¢rio *********************/ 

/****************** Definiáao de Vari†veis de Seleá∆o do Relat¢rio *********************/ 

def new shared var c-cd-trans-ini like bc-tipo-trans.cd-trans format "x(8)" initial "" no-undo.
def new shared var c-cd-trans-fim like bc-tipo-trans.cd-trans format "x(8)" initial "ZZZZZZZZ" no-undo.

/****************** Definiáao de Vari†veis p/ Campos Virtuais do Relat¢rio *******************/ 

/****************** Definiáao de Vari†veis Campo do Layout do Relat¢rio **********************/ 

def var c-backflush as character.
def var c-branco as character.
def var c-branco2 as character.
def var c-branco3 as character.
def var c-determinante as character.
def var c-diretorio as character.
def var c-etiqueta as character.
def var c-reporte as character.
def var c-reserva as character.
def var teste as character.

/****************** Definiáao de Vari†veis do Relat¢rio N∆o Pedidas em Tela ******************/ 

def var c-linha as character format "x(80)" init "".
def var c-prod as character format "x(25)" init "".
def var c-refugo as character format "x(25)" init "".
def var c-condicional as character format "x(25)" init "".
def var c-ordem as character format "x(10)" init "".
def var c-reserv as character format "x(10)" init "".
def var c-item as character format "x(10)" init "".
def var c-cliente as character format "x(20)" init "".
def var c-unit    as character format "x(10)" init "".
Def Var v-Ltr      As Character No-undo.
Def Var v-Ltr1     As Character No-undo.

/****************** Definiáao de Vari†veis de Total do Relat¢rio *****************************/ 

/****************** Definiáao de Vari†veis dos Calculos do Relat¢rio *************************/ 

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

/****************** Definiáao de Vari†veis de Processamento do Relat¢rio *********************/

def var h-acomp              as handle no-undo.
def var v-cod-destino-impres as char   no-undo.
def var v-num-reg-lidos      as int    no-undo.
def var v-num-point          as int    no-undo.
def var v-num-set            as int    no-undo.
def var v-num-linha          as int    no-undo.

define variable h_api_ccusto               as handle    no-undo.
define variable h_api_cta_ctbl             as handle    no-undo.
define variable c-formato-cta              as character no-undo.
define variable c-formato-ccusto           as character no-undo.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "n£mero" column-label "n£mero"
    field ttv_des_msg_ajuda                as character format "x(40)" label "mensagem ajuda" column-label "mensagem ajuda"
    field ttv_des_msg_erro                 as character format "x(60)" label "mensagem erro" column-label "inconsistància".


/****************** Definiáao de Forms do Relat¢rio 132 Colunas ***************************************/ 

if not valid-handle(h_api_ccusto) then
  run prgint/utb/utb742za.py persistent set h_api_ccusto.

if not valid-handle(h_api_cta_ctbl) then 
  run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  "",                 /* empresa ems2 */
                                                   input  "",                 /* plano contas */
                                                   input  today,              /* data de transacao */ 
                                                   output c-formato-cta,      /* formato conta */
                                                   output table tt_log_erro). /* erros */
if return-value = "nok" then
  assign c-formato-cta = "x(20)".

run pi_retorna_formato_ccusto in h_api_ccusto (input "",                  /* empresa ems2 */
                                               input "",                  /* plano ccusto */
                                               input today,               /* data de transacao */
                                               output  c-formato-ccusto,  /* formato ccusto */
                                               output table tt_log_erro). /* erros */

if return-value = "nok" then
  assign c-formato-ccusto = "x(20)".

if valid-handle(h_api_ccusto) then
    delete object h_api_ccusto.

if valid-handle(h_api_cta_ctbl) then
    delete object h_api_cta_ctbl.

form bc-tipo-trans.cd-trans label "C¢digo Transaá∆o" format "x(8)" at 006
     teste no-label  format "x(1)" at 037
     bc-tipo-trans.descricao no-label  format "x(30)" at 041
     with down width 132 side-labels no-box stream-io frame f-relat-01-132.
&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
    If Search("utp/ut-trfrrp.p") <> ? Or Search("utp/ut-trfrrp.r") <> ? Then
        Run utp/ut-trfrrp.p (input Frame f-relat-01-132:Handle).
&ENDIF

form bc-tipo-trans.api-atualizacao              label "Programa de Efetivaá∆o......"    format "x(40)"      at 012 skip
     bc-tipo-trans.prog-altera                  label "Programa Alteraá∆o Transaá∆o"    format "x(40)"      at 012 skip
     bc-tipo-trans.prog-etiq                    label "Programa Impress∆o Etiqueta."    format "x(40)"      at 012 skip
     bc-tipo-trans.prog-import                  label "Programa Importaá∆o........."    format "x(40)"      at 012 skip
     bc-tipo-trans.prog-criacao                 label "Programa Criaá∆o Transaá∆o.."    format "x(40)"      at 012 skip
     bc-tipo-trans.prog-leitura                 label "Programa Leitura............"    format "x(40)"      at 012 skip
     c-diretorio                                label "Diret¢rio..................."    format "x(80)"      at 012 skip
     bc-tipo-trans.atualiza-on-line             label "Atualiza On-Line?..........."    format "Sim/N∆o"    at 012 skip
     bc-tipo-trans.erros-on-line                label "Apresenta Erros On-Line....."    format "Sim/N∆o"    at 012 skip
     c-branco2                               no-label                                   format "x(2)"       at 012 skip
     c-backflush                             no-label                                   format "x(20)"      at 012 skip
     c-branco                                no-label                                   format "x(5)"       at 012 skip
     c-reporte                                  label "Reporte.................."       format "x(25)"      at 012 skip
     c-reserva                                  label "Baixar Reserva..........."       format "x(10)"      at 012 skip
     bc-tipo-backflush.codigo-rejei             label "Rejeiá∆o................."       format ">>9"        at 012 skip
     bc-tipo-backflush.cod-cta-ctbl-aplic-unif  label "Conta Aplicaá∆o.........."       format "x(20)"      at 012 skip
     bc-tipo-backflush.cod-ccusto-aplic-unif    label "Centro de Custo Aplicaá∆o"       format "x(20)"      at 012 skip
     bc-tipo-backflush.cod-cta-ctbl-refugo-unif label "Conta Refugo............."       format "x(20)"      at 012 skip
     bc-tipo-backflush.cod-ccusto-refugo-unif   label "Centro de Custo Refugo..."       format "x(20)"      at 012 SKIP
     bc-tipo-backflush.muda-status              label "Muda Estado.............."       format "Sim/N∆o"    at 012 skip
     c-branco3                               no-label                                   format "x(10)"      at 012 skip
     c-etiqueta                              no-label                                   format "x(10)"      at 012
     with down width 132 side-labels no-box stream-io frame f-relat-02-132.
{utp/ut-liter.i Sim/N∆o *}
Assign bc-tipo-trans.atualiza-on-line:format In Frame f-relat-02-132 = Return-value
       bc-tipo-trans.erros-on-line:format In Frame f-relat-02-132 = Return-value
       bc-tipo-backflush.muda-status:format In Frame f-relat-02-132 = Return-value.
&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
    If Search("utp/ut-trfrrp.p") <> ? Or Search("utp/ut-trfrrp.r") <> ? Then
        Run utp/ut-trfrrp.p (input Frame f-relat-02-132:Handle).
&ENDIF

form bc-tipo-trans.gera-etiq-total              label "Gera Etiqueta Total ?.."         format "sim/n∆o"    at 012 skip
     bc-tipo-trans.imp-apos-trans               label "Imprime Ap¢s Transaá∆o?"         format "Sim/N∆o"    at 012 skip
     bc-tipo-trans.tipo-etiq                    label "Tipo Etiqueta.........."         format "9999"       at 012 skip
     bc-tipo-trans.tipo-etiq-total              label "Tipo Etiqueta Total...."         format "9999"       at 012 skip
     c-determinante                             label "Determinante..........."         format "x(20)"      at 012
     with down width 132 side-labels no-box stream-io frame f-relat-09-132.
{utp/ut-liter.i Sim/N∆o *}
Assign bc-tipo-trans.gera-etiq-total:format In Frame f-relat-09-132 = Return-value
       bc-tipo-trans.imp-apos-trans:format In Frame f-relat-09-132 = Return-value.  
&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
    If Search("utp/ut-trfrrp.p") <> ? Or Search("utp/ut-trfrrp.r") <> ? Then
        Run utp/ut-trfrrp.p (input Frame f-relat-09-132:Handle).
&ENDIF

create tt-param.
raw-transfer raw-param to tt-param.

def temp-table tt-editor no-undo
    field linha      as integer
    field conteudo   as character format "x(80)"
    index editor-id is primary unique linha.


{include/i-rpvar.i}


{utp/ut-liter.i Relat¢rio_de_Transaá‰es *}
assign c-programa     = "bcr0011"
       c-versao       = "1.00"
       c-revisao      = "000"
       c-titulo-relat = Return-value.
{utp/ut-liter.i Coleta_de_Dados *}
Assign c-sistema      = Return-value.

if  tt-param.formato = 2 then do:


{include/i-rpcab.i &stream="str-rp"}

end. /* tt-param.formato = 2 */


{include/i-rpout.i &stream="stream str-rp"}

    assign i-ep-codigo-usuario = tt-param.ep-codigo
           v_cdn_empres_usuar  = i-ep-codigo-usuario.

    assign c-cd-trans-ini = tt-param.c-cd-trans-ini
           c-cd-trans-fim = tt-param.c-cd-trans-fim
           c-cd-trans-fim = tt-param.c-cd-trans-fim
.


{varinc/var00002.i}

run utp/ut-acomp.p persistent set h-acomp.

find first empresa no-lock
    where empresa.ep-codigo = i-ep-codigo-usuario no-error.
if  avail empresa
then
    assign c-empresa = empresa.razao-social.
else
    assign c-empresa = "".


/* for each e disp */


def var l-imprime as logical no-undo.

assign l-imprime = no.
if  tt-param.destino = 1
then
    assign v-cod-destino-impres = "Impressora".
else
    if  tt-param.destino = 2
    then
        assign v-cod-destino-impres = "Arquivo".
    else
        assign v-cod-destino-impres = "Terminal".
Run utp/ut-liter.p (input v-cod-destino-impres,"*","").
Assign v-cod-destino-impres = Return-value.

form 
    skip 
    c-linha at 06 no-label 
    skip 
with stream-io frame f-linha width 100.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-linha:HANDLE).

assign c-linha = fill("-",80).
{utp/ut-liter.i Produá∆o * L} assign c-prod = trim(return-value).
{utp/ut-liter.i Refugo * L}   assign c-refugo = trim(return-value).
{utp/ut-liter.i Ordem * L}    assign c-ordem = trim(return-value).
{utp/ut-liter.i Reserva * L}  assign c-reserv = trim(return-value).
{utp/ut-liter.i "Aprovado Condicional" * L} assign c-condicional = trim(return-value).
{utp/ut-liter.i Etiqueta * L} assign c-etiqueta = trim(return-value) + ":".
{utp/ut-liter.i Item * L} assign c-item = trim(return-value).
{utp/ut-liter.i "Item/Cliente" * L} assign c-cliente = trim(return-value).
{utp/ut-liter.i "Unit†rio" * L} assign c-unit = trim(return-value).
{utp/ut-liter.i Determinante * L} assign c-determinante:label in frame f-relat-09-132 = trim(return-value) + "...........".
run pi-ut-liter.


run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Processando... *}
run pi-inicializar in h-acomp(input Return-value).

assign v-num-reg-lidos = 0.

assign bc-tipo-backflush.cod-cta-ctbl-aplic-unif    :format in frame f-relat-02-132 = c-formato-cta
       bc-tipo-backflush.cod-ccusto-aplic-unif      :format in frame f-relat-02-132 = c-formato-ccusto
       bc-tipo-backflush.cod-cta-ctbl-refugo-unif   :format in frame f-relat-02-132 = c-formato-cta      
       bc-tipo-backflush.cod-ccusto-refugo-unif     :format in frame f-relat-02-132 = c-formato-ccusto.  

for each bc-tipo-trans no-lock
         where bc-tipo-trans.cd-trans >= c-cd-trans-ini and 
               bc-tipo-trans.cd-trans <= c-cd-trans-fim,
    each bc-tipo-backflush no-lock
         where bc-tipo-backflush.cd-trans = bc-tipo-trans.cd-trans
    break by bc-tipo-trans.cd-trans
          by bc-tipo-trans.api-atualizacao
          by bc-tipo-trans.gera-etiq-total:

    assign v-num-reg-lidos = v-num-reg-lidos + 1.
    Run utp/ut-liter.p (input Replace(bc-tipo-trans.descricao," ","_"),"*","").
    run pi-acompanhar in h-acomp(input Return-value).

    assign teste = "-".
    assign c-branco2 = "  ".
    assign c-branco = "     ".
    assign c-reporte = if bc-tipo-backflush.motivo-backflush = 2 then c-refugo else if bc-tipo-backflush.motivo-backflush = 3 then c-condicional else c-prod.
    assign c-reserva = if bc-tipo-backflush.baixa-reserva = 2 then c-reserv else c-ordem.
    assign c-branco3 = "          ".
    /***  C‡DIGO PARA SA÷DA EM 132 COLUNAS ***/

    if  tt-param.formato = 2 then do:

        view stream str-rp frame f-cabec.
        view stream str-rp frame f-rodape.
        assign l-imprime = yes.

        find first param-bc no-lock no-error.
   if bc-tipo-trans.char-1 <> "" then
      assign c-diretorio = trim(param-bc.nome-dir-etiq) + "~\" + trim(bc-tipo-trans.char-1).
   else
      assign c-diretorio = trim(param-bc.nome-dir-etiq).

   IF bc-tipo-trans.int-2 = 1 THEN
        assign c-determinante = c-item.
   if bc-tipo-trans.int-2 = 2 then
        assign c-determinante = c-cliente.
   if bc-tipo-trans.int-2 = 3 THEN
        assign c-determinante = c-unit.

        if  first-of(bc-tipo-trans.cd-trans) then do:
            display stream str-rp " " with stream-io no-box frame f-branco.
            Run utp/ut-liter.p (input Replace(bc-tipo-trans.cd-trans," ","_"),"*","").
            Assign v-Ltr = Return-value.
            Run utp/ut-liter.p (input Replace(bc-tipo-trans.descricao," ","_"),"*","").
            
            display stream str-rp v-Ltr @ bc-tipo-trans.cd-trans
                                  teste
                                  Return-value @ bc-tipo-trans.descricao
                    with stream-io frame f-relat-01-132.
        end.

        if  first-of(bc-tipo-trans.api-atualizacao) then do:
            display stream str-rp " " with stream-io no-box frame f-branco.
            display stream str-rp bc-tipo-trans.api-atualizacao
                                  bc-tipo-trans.prog-altera
                                  bc-tipo-trans.prog-etiq
                                  bc-tipo-trans.prog-import
                                  bc-tipo-trans.prog-criacao
                                  bc-tipo-trans.prog-leitura
                                  c-diretorio
                                  bc-tipo-trans.atualiza-on-line
                                  bc-tipo-trans.erros-on-line
                                  c-branco2
                                  c-backflush
                                  c-branco
                                  c-reporte
                                  c-reserva
                                  bc-tipo-backflush.codigo-rejei
                                  bc-tipo-backflush.cod-cta-ctbl-aplic-unif
                                  bc-tipo-backflush.cod-ccusto-aplic-unif
                                  bc-tipo-backflush.cod-cta-ctbl-refugo-unif
                                  bc-tipo-backflush.cod-ccusto-refugo-unif
                                  bc-tipo-backflush.muda-status
                                  c-branco3
                                  c-etiqueta
                    with stream-io frame f-relat-02-132.
            display stream str-rp " " with stream-io no-box frame f-branco.
        end.

        display stream str-rp bc-tipo-trans.gera-etiq-total
                              bc-tipo-trans.imp-apos-trans
                              bc-tipo-trans.tipo-etiq
                              bc-tipo-trans.tipo-etiq-total
                              c-determinante
                with stream-io frame f-relat-09-132.
        down stream str-rp with frame f-relat-09-132.
    end.
    display stream str-rp c-linha with frame f-linha.
end.


if  l-imprime = no then do:
    if  tt-param.formato = 2 then do:
        view stream str-rp frame f-cabec.
        view stream str-rp frame f-rodape.
    end.
    disp stream str-rp " " with stream-io frame f-nulo.
end.

procedure pi-ut-liter:
{utp/ut-liter.i "Programa de Efetivaá∆o" * L}
assign bc-tipo-trans.api-atualizacao:label in frame f-relat-02-132 = trim(return-value) + "......".
{utp/ut-liter.i "Programa Impress∆o Etiqueta" * L}
assign bc-tipo-trans.prog-etiq:label = trim(return-value) + ".".
{utp/ut-liter.i "Programa Importaá∆o" * L}
assign bc-tipo-trans.prog-import:label = trim(return-value) + ".........".
{utp/ut-liter.i "Programa Criaá∆o Transaá∆o" * L}
assign bc-tipo-trans.prog-criacao:label = trim(return-value) + "..".
{utp/ut-liter.i "Programa Leitura" * L}
assign bc-tipo-trans.prog-leitura:label = trim(return-value) + "............".
{utp/ut-liter.i "Gera Etiqueta Total?" * L}
assign bc-tipo-trans.gera-etiq-total:label  in frame f-relat-09-132 = return-value + "...".
{utp/ut-liter.i "Imprime Ap¢s Transaá∆o?" * L}
assign bc-tipo-trans.imp-apos-trans:label = trim(return-value).
{utp/ut-liter.i "Atualiza On-Line?" * L}
assign bc-tipo-trans.atualiza-on-line:label = trim(return-value) + "...........".
{utp/ut-liter.i "Apresenta Erros On-Line?" * L}
assign bc-tipo-trans.erros-on-line:label = trim(return-value) + "....".
{utp/ut-liter.i "Diret¢rio" * L}
assign c-diretorio:label = trim(return-value) + "...................".
{utp/ut-liter.i "Tipo Backflush:" * L}
assign c-backflush = trim(return-value).
{utp/ut-liter.i "Reporte" * L}
assign c-reporte:label = trim(return-value) + "..................".
{utp/ut-liter.i "Baixar Reserva" * L}
assign c-reserva:label = trim(return-value) + "...........".
{utp/ut-liter.i "Rejeiá∆o" * L}
assign bc-tipo-backflush.codigo-rejei:label = trim(return-value) + ".................".
{utp/ut-liter.i "Conta Aplicaá∆o" * L}
assign bc-tipo-backflush.cod-cta-ctbl-aplic-unif:label = trim(return-value) + "..........".
{utp/ut-liter.i "Centro de Custo Aplicaá∆o" * L}
assign bc-tipo-backflush.cod-ccusto-aplic-unif:label = trim(return-value).
{utp/ut-liter.i "Conta Refugo" * L}
assign bc-tipo-backflush.cod-cta-ctbl-refugo-unif:label = trim(return-value) + ".............".
{utp/ut-liter.i "Centro de Custo Refugo" * L}
assign bc-tipo-backflush.cod-ccusto-refugo-unif:label = trim(return-value) + "...".
{utp/ut-liter.i "Muda Estado" * L}
assign bc-tipo-backflush.muda-status:label = trim(return-value) + "..............".
end procedure.

run pi-finalizar in h-acomp.

page stream str-rp.

if  tt-param.parametro then do:

   {utp/ut-liter.i SELEÄ«O *}
   disp stream str-rp Return-value skip(01) with stream-io frame f-imp-sel.
   disp stream str-rp 
      c-cd-trans-ini colon 32 "|< >|" c-cd-trans-fim no-label
        with stream-io side-labels overlay row 038 frame f-imp-sel.
   &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
        If Search("utp/ut-trfrrp.p") <> ? Or Search("utp/ut-trfrrp.r") <> ? Then
            Run utp/ut-trfrrp.p (input Frame f-imp-sel:Handle).
    &ENDIF

   {utp/ut-liter.i CLASSIFICAÄ«O *}
   disp stream str-rp Return-value Format "x(13)" skip(01) with stream-io frame f-imp-cla.
   {utp/ut-liter.i ___Por_Transaá‰es *}
   disp stream str-rp Return-value Format "x(17)"
        with stream-io side-labels overlay row 038 frame f-imp-cla.

   {utp/ut-liter.i IMPRESS«O *}
   put stream str-rp unformatted skip(1) Return-value skip(1).

   {utp/ut-liter.i Destino_:_ *}
   put stream str-rp unformatted skip "    " Return-value v-cod-destino-impres " - " tt-param.arquivo format "x(40)".
   {utp/ut-liter.i Execuá∆o:_ *}
   put stream str-rp unformatted skip "    " Return-value if i-num-ped-exec-rpw = 0 then "On-Line" else "Batch".
   {utp/ut-liter.i 80_Colunas *}
   Assign v-Ltr = Return-value.
   {utp/ut-liter.i 132_Colunas *}
   Assign v-Ltr1 = Return-value.
   {utp/ut-liter.i Formato_:_ *}
   put stream str-rp unformatted skip "    " Return-value if tt-param.formato = 1 then v-Ltr else v-Ltr1.
   {utp/ut-liter.i Usu†rio_:_ *}
   put stream str-rp unformatted skip "    " Return-value tt-param.usuario.

end.

output stream str-rp close.


{include/i-rpclo.i &stream="stream str-rp"}


procedure pi-print-editor:

    def input param c-editor    as char    no-undo.
    def input param i-len       as integer no-undo.

    def var i-linha  as integer no-undo.
    def var i-aux    as integer no-undo.
    def var c-aux    as char    no-undo.
    def var c-ret    as char    no-undo.

    for each tt-editor:
        delete tt-editor.
    end.

    assign c-ret = chr(255) + chr(255).

    do  while c-editor <> "":
        if  c-editor <> "" then do:
            assign i-aux = index(c-editor, chr(10)).
            if  i-aux > i-len or (i-aux = 0 and length(c-editor) > i-len) then
                assign i-aux = r-index(c-editor, " ", i-len + 1).
            if  i-aux = 0 then
                assign c-aux = substr(c-editor, 1, i-len)
                       c-editor = substr(c-editor, i-len + 1).
            else
                assign c-aux = substr(c-editor, 1, i-aux - 1)
                       c-editor = substr(c-editor, i-aux + 1).
            if  i-len = 0 then
                assign entry(1, c-ret, chr(255)) = c-aux.
            else do:
                assign i-linha = i-linha + 1.
                create tt-editor.
                assign tt-editor.linha    = i-linha
                       tt-editor.conteudo = c-aux.
            end.
        end.
        if  i-len = 0 then
            return c-ret.
    end.
    return c-ret.
end procedure.

return 'OK'.

