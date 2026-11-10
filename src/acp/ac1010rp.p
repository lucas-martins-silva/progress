/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC1010RP 2.00.00.026 } /*** "010026" 22/05/2025 16:59:47  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac1010rp MAC}
&ENDIF

{include/i_fnctrad.i}
/*******************************************************************************
**
** Ac1010RP.P : C lculo de rateio e Impressao dos parametros do calculo de rateio
**
********************************************************************************/
{utp/ut-glob.i}
/* ********************  Defini‡Æo de Temp-Table ****************************** */

def temp-table tt-raw-digita
   field raw-digita      as raw.

define temp-table tt-param no-undo
    field destino             as integer
    field arquivo             as char format "x(35)"
    field usuario             as char format "x(12)"
    field data-exec           as date
    field hora-exec           as integer
    field cod-estab-ini       like cotas.cod-estabel
    field cod-estab-fim       like cotas.cod-estabel
    field cod-canal-venda-ini like cotas.cod-canal-venda
    field cod-canal-venda-fim like cotas.cod-canal-venda
    field cod-gr-cli-ini      like cotas.cod-gr-cli
    field cod-gr-cli-fim      like cotas.cod-gr-cli
    field nome-abrev-ini      like emitente.nome-abrev
    field nome-abrev-fim      like emitente.nome-abrev
    field nome-ab-reg-ini     like cotas.nome-ab-reg
    field nome-ab-reg-fim     like cotas.nome-ab-reg
    field nome-mic-reg-ini    like cotas.nome-mic-reg
    field nome-mic-reg-fim    like cotas.nome-mic-reg
    field cod-rep-ini         like cotas.cod-rep
    field cod-rep-fim         like cotas.cod-rep
    field produto-ini         like cotas.cd-produto
    field produto-fim         like cotas.cd-produto
    field origem-dados        as integer
    field desc-orig-dados     as char    format "x(40)"
    field cod-plano           as integer format ">>9" 
    field desc-plano          as char    format "x(40)"
    field periodo-ini         as integer format ">>9"
    field periodo-fim         as integer format ">>9"
    field deleta              as logical
    field util-decimal        as logical
    field atualiza            as logical
    field soma-dif            as logical
    field dt-periodo          as date    format "99/99/9999"
    field total-cota          as decimal format ">>>,>>>,>>9.99"
    field codigo              as integer format ">>9"
    field desc-tipo-baserat   as char    format "x(40)"
    field dt-periodo-ini      as date    format "99/99/9999"
    field dt-periodo-fim      as date    format "99/99/9999" .

define temp-table tt-erro-rateio
    field cod-estabel like base-rat.cod-estabel
    field nivel         as char format "x(15)"
    field cd-produto  like base-rat.cd-produto
    field percentual  like base-rat.pct-rateio
    index ch-prod is primary unique cod-estabel nivel cd-produto.

define temp-table tt-estabel
    field cod-estabel like estabelec.cod-estabel
    field log-impl-niveis as log
    index cod-estabel is primary unique cod-estabel.    

define temp-table tt-canal-cotas
    field cod-canal-venda like canal-venda.cod-canal-venda
    index cod-canal-venda is primary unique cod-canal-venda.    

{cdp/cdcfgdis.i}    

{acp/ac9000.i}

/* ************************ Defini‡Æo de Buffers ************************** */
def buffer b-cotas for cotas.
def buffer b-base-cota for base-cota.

/* ************************ Defini‡Æo de parametros ************************** */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

/* ************************ Defini‡Æo de variaveis *************************** */

/* Include i-epc200.i: Defini‡Æo Temp-Table tt-epc e dos programas de UPCs */
{include/i-epc200.i ac1010rp}.

{include/i-rpvar.i}

def var c-processa          as char format "x(20)"              no-undo.
def var c-selecao           as char format "x(11)"              no-undo.
def var c-parametro         as char format "x(14)"              no-undo.
def var c-impressao         as char format "x(12)"              no-undo.
def var c-destino           as char format "x(10)"              no-undo.
def var h-acomp             as handle                           no-undo.
def var i-cont              as integer                          no-undo.
def var da-dt-aux           as date                             no-undo.
def var de-pct-rateio       like base-rat.pct-rateio            no-undo.
def var r-id-cotas          as rowid                            no-undo.
def var c-estab-ini         like cotas.cod-estabel              no-undo.
def var c-estab-fim         like cotas.cod-estabel              no-undo.
def var c-estab-temp        like cotas.cod-estabel              no-undo.
def var c-it-codigo         like cotas.cd-produto               no-undo.
def var de-tot-perc         like base-rat.pct-rateio            no-undo.
def var l-perc-ok           as logical initial yes              no-undo.
def var l-erro-base-cota    as logical initial no               no-undo.
def var l-utiliza-base-cota as logical initial no               no-undo.
def var l-limita            as logical                          no-undo.
def var c-cod-estabel       like base-rat.cod-estabel           no-undo.
def var c-cd-produto        like base-rat.cd-produto            no-undo.
def var da-dt-inicial       like cotas.dt-inicial               no-undo.
def var c-msg-erro          as char format "x(50)"              no-undo.
def var c-produto           as char format "x(16)"              no-undo.
def var c-desc-prod         as char format "x(20)"              no-undo.
def var c-desc-perc         as char format "x(08)"              no-undo.
def var c-desc-item         as char format "x(20)"              no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
def var c-estabel           as char format "x(05)"              no-undo.
&ELSE
def var c-estabel           as char format "x(03)"              no-undo.
&ENDIF
def var c-nivel             as char format "x(15)"              no-undo.
def var c-canal-venda       as char format "x(11)"              no-undo.
def var c-grupo-cliente     as char format "x(13)"              no-undo.
def var c-cliente           as char format "x(07)"              no-undo.
def var c-regiao            as char format "x(06)"              no-undo.
def var c-microrregiao      as char format "x(12)"              no-undo.
def var c-repres            as char format "x(13)"              no-undo.
def var de-valor-base       like base-cota.qt-prevista          no-undo.
def var de-prevista         like cotas.qt-prevista              no-undo.
def var i-prevista          as integer                          no-undo.
def var de-dif-prev         like cotas.qt-prevista              no-undo.
def var de-tot-qt-prev      like cotas.qt-prevista              no-undo.
def var de-total-qt-prevista like base-cota.qt-prevista          no-undo.
def var de-maior-qt-prev     like base-cota.qt-prevista          no-undo.
def var de-maior-qt-bas-prev like base-cota.qt-prevista          no-undo.

/* *********** Defini‡Æo do layout da p gina de parametros ****************** */

form skip(01)

     c-selecao   no-label    skip(1)
     tt-param.cod-estab-ini              colon 40 space(12) "|< >|"
     tt-param.cod-estab-fim           no-label colon 73 skip
     tt-param.cod-canal-venda-ini        colon 40 space(14) "|< >|"
     tt-param.cod-canal-venda-fim     no-label colon 73 skip
     tt-param.cod-gr-cli-ini             colon 40 space(13) "|< >|"
     tt-param.cod-gr-cli-fim          no-label colon 73 skip
     tt-param.nome-abrev-ini            colon 40 space(05) "|< >|"
     tt-param.nome-abrev-fim          no-label colon 73 skip
     tt-param.nome-ab-reg-ini            colon 40 space(05) "|< >|"
     tt-param.nome-ab-reg-fim         no-label colon 73 skip
     tt-param.nome-mic-reg-ini           colon 40 space(05) "|< >|"
     tt-param.nome-mic-reg-fim        no-label colon 73 skip
     tt-param.cod-rep-ini                colon 40 space(12) "|< >|"
     tt-param.cod-rep-fim             no-label colon 73 skip
     tt-param.produto-ini                colon 40 space(1)  "|< >|"
     tt-param.produto-fim             no-label colon 73 skip(1)
     c-parametro no-label        skip(1)
     tt-param.desc-orig-dados            colon 40 skip
     tt-param.cod-plano                  colon 40 space(5)
     tt-param.desc-plano      no-label   colon 48 skip
     tt-param.periodo-ini                colon 40 skip 
     tt-param.periodo-fim                colon 40 skip 
     tt-param.deleta                     colon 40 skip 
     tt-param.util-decimal               colon 40 skip
     tt-param.atualiza                   colon 40 skip
     tt-param.soma-dif                   colon 40 skip
     tt-param.dt-periodo                 colon 40 skip
     tt-param.total-cota                 colon 40 skip
     tt-param.codigo                     colon 40 space(5)
     tt-param.desc-tipo-baserat no-label colon 48 skip
     tt-param.dt-periodo-ini             colon 40 skip
     tt-param.dt-periodo-fim             colon 40 skip(1)
     c-impressao no-label       skip(1)
     c-destino               colon 40
     " - ":U
     tt-param.arquivo no-label format "x(30)":U skip
     tt-param.usuario        colon 40 skip
     with down no-box width 132 side-labels stream-io frame f-parametros.

def var de as dec.

/* *********************** Defini»’o de literais  ***************************** */

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

{utp/ut-liter.i Estabelecimento * L}
assign tt-param.cod-estab-ini:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Canal_Venda * L}
assign tt-param.cod-canal-venda-ini:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Grupo_Cliente * L}
assign tt-param.cod-gr-cli-ini:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Cliente * L}
assign tt-param.nome-abrev-ini:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i RegiÆo * L}
assign tt-param.nome-ab-reg-ini:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i MicrorregiÆo * L}
assign tt-param.nome-mic-reg-ini:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Representante * L}
assign tt-param.cod-rep-ini:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Produto/Item * L}
assign tt-param.produto-ini:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Origem_dos_Dados * L}
assign tt-param.desc-orig-dados:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Plano * L}
assign tt-param.cod-plano:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Per¡odo_Inicial * L}
assign tt-param.periodo-ini:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Per¡odo_Final * L}
assign tt-param.periodo-fim:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Elimina_posi‡Æo_Anterior * R}
assign tt-param.deleta:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Elimina_posi‡Æo_Anterior * R}
assign tt-param.deleta:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i  Utiliza_Decimais * R}
assign tt-param.util-decimal:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Atualiza_Quantidade_original * R}
assign tt-param.atualiza:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Soma_Diferen‡a_Maior_Cota * R}
assign tt-param.soma-dif:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Per¡odo * L}
assign tt-param.dt-periodo:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Total_Cota * L}
assign tt-param.total-cota:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Tipo_Base_Rateio * L}
assign tt-param.codigo:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Total_Cota * L}
assign tt-param.total-cota:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Data_Inicial * L}
assign tt-param.dt-periodo-ini:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Data_Final * L}
assign tt-param.dt-periodo-fim:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Existe(m)_erro(s)_na(s)_base(s)_de_rateio * L}
assign c-msg-erro = trim(return-value).

{utp/ut-field.i mgdis base-rat cd-produto 1}
assign c-produto = trim(return-value).

{utp/ut-liter.i Descri‡Æo * L}
assign c-desc-prod = trim(return-value).

{utp/ut-liter.i %_Rateio * L}
assign c-desc-perc = trim(return-value).

{utp/ut-field.i mgdis base-rat cod-estabel 1}
assign c-estabel = trim(return-value).

{utp/ut-liter.i N¡vel * L}
assign c-nivel = trim(return-value).

{utp/ut-liter.i Canal_Venda * L}
assign c-canal-venda = trim(return-value).

{utp/ut-liter.i Grupo_Cliente * L}
assign c-grupo-cliente = trim(return-value).

{utp/ut-liter.i Cliente * L}
assign c-cliente = trim(return-value).

{utp/ut-liter.i RegiÆo * L}
assign c-regiao = trim(return-value).

{utp/ut-liter.i MicrorregiÆo * L}
assign c-microrregiao = trim(return-value).

{utp/ut-liter.i Representante * L}
assign c-repres = trim(return-value).

/* ************************ Inicio do programa ****************************** */
run utp/ut-trfrrp.p (input frame f-parametros:handle).
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.

find empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
if avail empresa then
   assign c-empresa = empresa.razao-social.

assign c-programa = 'ac1010'
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

{utp/ut-liter.i C lculo_de_Rateio MAP C}
assign c-titulo-relat = return-value.

{include/i-rpout.i}
view frame f-cabec.
view frame f-rodape.

/******************************************************************************/
/***                                                                        ***/
/***                         Distribuicao de Cotas                          ***/
/***                                                                        ***/
/******************************************************************************/

   /****************************************/
   /*** Verifica os parametros do pedido ***/
   /****************************************/
   find first para-ped no-lock no-error.
   if substring(para-ped.char-2, 1, 3) = "yes" then
      assign c-estab-ini = para-ped.estab-padrao
             c-estab-fim = para-ped.estab-padrao.
   else
      assign c-estab-ini = tt-param.cod-estab-ini
             c-estab-fim = tt-param.cod-estab-fim.

   /*******************************************/
   /*** Procura por erros na base de rateio ***/
   /*******************************************/
   assign de-tot-perc = 0.
   for each tt-erro-rateio:
       delete tt-erro-rateio.
   end.
   for each tt-estabel:
       delete tt-estabel.
   end.
   for each tt-canal-cotas:
       delete tt-canal-cotas.
   end.

   run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Aguarde... *}
   run pi-inicializar in h-acomp (input  Return-value ).

   &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */  
       for each par-cota no-lock where 
                par-cota.cod-estabel >= c-estab-ini and
                par-cota.cod-estabel <= c-estab-fim:
           create tt-estabel.
           assign tt-estabel.cod-estabel = par-cota.cod-estabel
                  tt-estabel.log-impl-niveis = par-cota.log-impl-niveis.
       end.
       for each canal-venda where
                canal-venda.cod-canal-venda >= tt-param.cod-canal-venda-ini and
                canal-venda.cod-canal-venda <= tt-param.cod-canal-venda-fim no-lock:
           if  canal-venda.dat-inic-ctrl-cotas <= tt-param.dt-periodo-ini then do:
               create tt-canal-cotas.
               assign tt-canal-cotas.cod-canal-venda = canal-venda.cod-canal-venda.
           end.
       end.
       run pi-release202.
       if not l-perc-ok then do:
           put skip(1) c-msg-erro.
           put skip(1) c-produto                   at 001
                       c-desc-prod                 at 018
                       c-desc-perc                 at 039
                       skip
                       "----------------"          at 001
                       fill("-",20) format "x(20)" at 018
                       "--------"                  at 039
                       skip.
       end.
       if  l-perc-ok = yes then do:
           run pi-release203.
           if not l-perc-ok then do:
              put skip(1) c-msg-erro.
              put skip(1) c-estabel                   at 001
                          c-nivel                     at 005
                          c-produto                   at 022
                          c-desc-prod                 at 039
                          c-desc-perc                 at 059
                          skip
                          "---"                       at 001
                          "---------------"           at 005
                          "----------------"          at 022
                          fill("-",20) format "x(20)" at 039
                          "--------"                  at 059
                          skip.
           end.
       end.
   &ELSE     
       for each estabel fields(cod-estabel) no-lock where 
                estabel.cod-estabel >= c-estab-ini and
                estabel.cod-estabel <= c-estab-fim:
           create tt-estabel.
           assign tt-estabel.cod-estabel = estabel.cod-estabel
                  tt-estabel.log-impl-niveis = no.
       end.
       for each canal-venda fields(cod-canal-venda) where
                canal-venda.cod-canal-venda >= tt-param.cod-canal-venda-ini and
                canal-venda.cod-canal-venda <= tt-param.cod-canal-venda-fim no-lock:
           create tt-canal-cotas.
           assign tt-canal-cotas.cod-canal-venda = canal-venda.cod-canal-venda.
       end.
       run pi-release202.
       if not l-perc-ok then do:
          put skip(1) c-msg-erro.
          put skip(1) c-produto                   at 001
                      c-desc-prod                 at 018
                      c-desc-perc                 at 039
                      skip
                      "----------------"          at 001
                      fill("-",20) format "x(20)" at 018
                      "--------"                  at 039
                      skip.
       end.
   &ENDIF

    for each tt-erro-rateio no-lock:
       find item 
            where item.it-codigo = tt-erro-rateio.cd-produto NO-LOCK no-error.
       if avail item then
          assign c-desc-item = item.descricao-1.
       else do:
          &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
              find produto-coml no-lock
                   where produto-coml.cod-produto-coml = tt-erro-rateio.cd-produto no-error.
              if avail produto-coml then
                 assign c-desc-item = produto-coml.des-produto-coml.
              else
                 assign c-desc-item = "".
          &ELSE
              find produto no-lock
                   where produto.cd-produto = tt-erro-rateio.cd-produto no-error.
              if avail produto then
                 assign c-desc-item = produto.descricao.
              else
                 assign c-desc-item = "".
          &ENDIF

       end.
       &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
           if  tt-erro-rateio.cod-estabel <> "" then 
                put tt-erro-rateio.cod-estabel at 001
                    tt-erro-rateio.nivel       at 005
                    tt-erro-rateio.cd-produto  at 022
                    c-desc-item                at 039
                    tt-erro-rateio.percentual  at 059
                    skip.
           else
                put tt-erro-rateio.cd-produto  at 001
                    c-desc-item                at 018
                    tt-erro-rateio.percentual  at 041
                    skip.
       &ElSE
           put tt-erro-rateio.cd-produto  at 001
               c-desc-item                at 018
               tt-erro-rateio.percentual  at 041
               skip.
       &ENDIF

    end.
    run pi-finalizar in h-acomp.

/* **************** Impressao da pagina de parametros ************* */

if page-number > 0 then page.

disp c-selecao
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
     tt-param.produto-ini        
     tt-param.produto-fim        
     c-parametro no-label        
     tt-param.desc-orig-dados    
     tt-param.cod-plano          
     tt-param.desc-plano         
     tt-param.periodo-ini                
     tt-param.periodo-fim                
     tt-param.dt-periodo                 
     tt-param.total-cota                 
     tt-param.codigo                     
     tt-param.desc-tipo-baserat          
     tt-param.dt-periodo-ini             
     tt-param.dt-periodo-fim             
     c-impressao
     c-destino               
     tt-param.arquivo 
     tt-param.usuario 
     with frame f-parametros.

if tt-param.deleta = yes then 
   {utp/ut-liter.i Sim * R} 
else 
   {utp/ut-liter.i NÆo * R} 
disp trim(return-value) @ tt-param.deleta with frame f-parametros.
if tt-param.util-decimal = yes then 
   {utp/ut-liter.i Sim * R} 
else 
   {utp/ut-liter.i NÆo * R} 
disp trim(return-value) @ tt-param.util-decimal with frame f-parametros.
if tt-param.atualiza = yes then 
   {utp/ut-liter.i Sim * R} 
else 
   {utp/ut-liter.i NÆo * R} 
disp trim(return-value) @ tt-param.atualiza with frame f-parametros.
if tt-param.soma-dif = yes then 
   {utp/ut-liter.i Sim * R} 
else 
   {utp/ut-liter.i NÆo * R} 
disp trim(return-value) @ tt-param.soma-dif with frame f-parametros.


down with frame f-parametros.     

{include/i-rpclo.i}

procedure pi-release202.

    for each tt-estabel no-lock where   
             tt-estabel.log-impl-niveis = no:
       assign l-limita = yes.

       &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
           find par-cota where par-cota.cod-estabel = tt-estabel.cod-estabel no-lock no-error. 
           if par-cota.log-limita-rateio = no then  /* NÆo Limita o Rateio a 100% */
              assign l-limita = no.
       &ELSE
           /********* Chamada de UPC, para tratar se limita rateio ou nÆo na 2.02 ************/
           for each tt-epc where tt-epc.cod-event = "verificaLimitaRateio".
               delete tt-epc.
           end.

           /* Include i-epc200.i2: Cria‡Æo de registro para Temp-Table tt-epc */
           {include/i-epc200.i2 &CodEvent='"verificaLimitaRateio"'
                                &CodParameter='"var-limita-rateio-envio"'
                                &ValueParameter="string(l-limita)"}

           /* Include i-epc201.i: Chamada do programa de EPC */
           {include/i-epc201.i "verificaLimitaRateio"}.

           find first tt-epc where
                      tt-epc.cod-event = "verificaLimitaRateio" and
                      tt-epc.Cod-Parameter = "var-limita-rateio-retorno" no-error .
           if avail tt-epc then do:
              if tt-epc.val-parameter = "no" then
                 assign l-limita = no.
              else   
                 assign l-limita = yes.
           end.
           /***********************************************************/

       &ENDIF

       if  l-limita then do:
           for each base-rat no-lock
               where (base-rat.cod-estabel = tt-estabel.cod-estabel)
               and   ((base-rat.cod-canal-venda >= tt-param.cod-canal-venda-ini
                 and   base-rat.cod-canal-venda <= tt-param.cod-canal-venda-fim)
                 or    base-rat.cod-canal-venda  = ?)
               and   ((base-rat.cod-gr-cli      >= tt-param.cod-gr-cli-ini
                 and   base-rat.cod-gr-cli      <= tt-param.cod-gr-cli-fim)
                 or    base-rat.cod-gr-cli       = ?)
               and   ((base-rat.nome-abrev      >= tt-param.nome-abrev-ini
                 and   base-rat.nome-abrev      <= tt-param.nome-abrev-fim)
                 or    base-rat.nome-abrev       = ?)
               and   ((base-rat.nome-ab-reg     >= tt-param.nome-ab-reg-ini
                 and   base-rat.nome-ab-reg     <= tt-param.nome-ab-reg-fim)
                 or    base-rat.nome-ab-reg      = ?)
               and   ((base-rat.nome-mic-reg    >= tt-param.nome-mic-reg-ini
                 and   base-rat.nome-mic-reg    <= tt-param.nome-mic-reg-fim)
                 or    base-rat.nome-mic-reg     = ?)
                 and   base-rat.cod-rep         >= tt-param.cod-rep-ini
                 and   base-rat.cod-rep         <= tt-param.cod-rep-fim
                 and   base-rat.cd-produto      >= tt-param.produto-ini
                 and   base-rat.cd-produto      <= tt-param.produto-fim
                 and   base-rat.codigo           = tt-param.codigo
                 and  (can-find(tt-canal-cotas where tt-canal-cotas.cod-canal-venda = base-rat.cod-canal-venda) or
                               base-rat.cod-canal-venda = 0 or
                               base-rat.cod-canal-venda = ?)
                  break by base-rat.cd-produto:

               assign de-tot-perc = de-tot-perc + base-rat.pct-rateio.

               run pi-acompanhar in h-acomp (input de-tot-perc).

               if last-of(base-rat.cd-produto) then do:
                  if de-tot-perc > 100.00 then do:
                     create tt-erro-rateio.
                     assign tt-erro-rateio.cd-produto = base-rat.cd-produto
                            tt-erro-rateio.percentual = de-tot-perc
                            l-perc-ok = no.
                  end.
                  else assign l-perc-ok = yes.
                  assign de-tot-perc = 0.
               end.
           end.
       end.
       else
           assign l-perc-ok = yes.

       /********************************************************/
       /*** Se nao houve nenhum problema nas bases de rateio ***/
       /********************************************************/
       if l-perc-ok then do:
          /*********************************************************/
          /*** Dependendo do parametro, elimina as cotas antigas ***/
          /*********************************************************/
          IF tt-param.deleta THEN DO:
             FOR EACH  base-cota EXCLUSIVE-LOCK USE-INDEX periodo
                 WHERE base-cota.cod-estabel  = tt-estabel.cod-estabel 
                   AND base-cota.cd-produto  >= tt-param.produto-ini 
                   AND base-cota.cd-produto  <= tt-param.produto-fim
                   AND base-cota.dt-inicial   = tt-param.dt-periodo-ini:

                 IF NOT CAN-FIND (FIRST base-rat WHERE 
                                        base-rat.cod-estabel = base-cota.cod-estabel AND
                                        base-rat.cd-produto  = base-cota.cd-produto  AND
                                        base-rat.codigo      = tt-param.codigo) THEN
                    NEXT.

                 for each cotas exclusive-lock
                     where cotas.cod-estabel = base-cota.cod-estabel
                     and   cotas.cd-produto  = base-cota.cd-produto
                     and   cotas.dt-inicial  = base-cota.dt-inicial:
                     delete cotas.
                 end.
                 delete base-cota. 
             end.
          end.

          /****************************************/
          /***   Se for por PrevisÆo de Venda   ***/
          /****************************************/
          if tt-param.origem-dados = 1 then do:

             /* run pi-acompanhar in h-acomp (input base-rat.cd-produto). */

             /*************************************************************************/
             /*** Verifica todas as previs„es de venda do estabelecimento escolhido ***/
             /*** e do plano escolhido                                              ***/
             /*************************************************************************/
             for each  pr-venda no-lock
                 where pr-venda.cod-estabel   = tt-estabel.cod-estabel
                 and   pr-venda.cd-plano      = tt-param.cod-plano
                 AND   pr-venda.it-codigo    >= tt-param.produto-ini
                 AND   pr-venda.it-codigo    <= tt-param.produto-fim
                 BREAK BY pr-venda.it-codigo :

                 IF  NOT AVAIL ITEM-cota
                 OR  item-cota.it-codigo <> pr-venda.it-codigo THEN do:
                     FOR FIRST item-cota NO-LOCK
                         WHERE item-cota.it-codigo = pr-venda.it-codigo:
                     END.
					 assign de-total-qt-prevista = 0.
				 end.

                 IF NOT AVAIL item-cota THEN
                    NEXT.

                 /********************************************************/
                 /*** Acumula a qtde prevista de venda daquele periodo ***/
                 /********************************************************/
                 
                 for each  pr-vend-per no-lock
                     where pr-vend-per.num-id-pr-venda = pr-venda.num-id-pr-venda 
                     and   pr-vend-per.num-per-pm     >= tt-param.periodo-ini
                     and   pr-vend-per.num-per-pm     <= tt-param.periodo-fim:

                     run pi-acompanhar in h-acomp (input pr-vend-per.num-id-pr-venda).

                     assign de-total-qt-prevista = de-total-qt-prevista + pr-vend-per.qt-prevista.

                 end.

                 IF LAST-OF ( pr-venda.it-codigo) AND 
                    de-total-qt-prevista <> 0     THEN DO:
                 
                     /***************************************************************/
                     /*** Se for estab unico usa o padrao senao usa o da previsao ***/
                     /***************************************************************/
                     if substring(para-ped.char-2, 1, 3) = "yes" then
                        assign c-estab-temp = para-ped.estab-padrao.
                     else
                        assign c-estab-temp = pr-venda.cod-estabel.
    
                     find par-cota where par-cota.cod-estabel = c-estab-temp no-lock no-error.
                     if avail par-cota then do:
                        /************************************************************************/
                        /*** Se nao controla produto atribui o item padrao do estabelecimento ***/
                        /************************************************************************/
                        if not par-cota.cont-produto then
                           assign c-it-codigo = par-cota.it-codigo-padrao.
                        else
                           assign c-it-codigo = pr-venda.it-codigo.
                     end.
                     else
                        NEXT.
    
                    IF  AVAIL item-cota
                    AND item-cota.log-produto THEN
                        FOR FIRST est-prod-coml NO-LOCK
                            WHERE est-prod-coml.it-codigo = pr-venda.it-codigo:
                            ASSIGN c-it-codigo = est-prod-coml.cod-produto-coml.
                        END.

                     /*********************************************************************/
                     /*** Localiza Base de Cota, se nao encontrar cria uma nova         ***/
                     /*** Em todos os casos atribui a qtde prevista para a Base de Cota ***/
                     /*********************************************************************/
    
                     find first base-cota
                          where base-cota.cod-estabel = c-estab-temp
                          and   base-cota.cd-produto  = c-it-codigo 
                          and   base-cota.dt-inicial  = tt-param.dt-periodo-ini EXCLUSIVE-LOCK no-error.
                     if not avail base-cota then do:
                        create base-cota.
                        assign base-cota.cod-estabel = c-estab-temp
                               base-cota.cd-produto  = c-it-codigo
                               base-cota.dt-inicial  = tt-param.dt-periodo-ini 
                               base-cota.dt-final    = tt-param.dt-periodo-fim
                               base-cota.qt-prevista = de-total-qt-prevista.
                        &IF DEFINED (bf_dis_adm_cotas) &THEN  
                            IF CAN-FIND (item-cota WHERE
                                         item-cota.it-codigo = c-it-codigo AND
                                         item-cota.log-cota-limite = YES ) THEN
                                ASSIGN base-cota.log-cota-limite = YES.
                            ASSIGN base-cota.cd-produto-dest = c-it-codigo.
                        &ENDIF
    
                     end.
                     else assign base-cota.qt-prevista = base-cota.qt-prevista + de-total-qt-prevista.
                 end. 
             end. 
          end.

          /*************************************************/
          /***  Se for Previsao de Venda ou Base de Cota ***/
          /*************************************************/
          if tt-param.origem-dados = 1 or
             tt-param.origem-dados = 2 then do:


             assign de-total-qt-prevista = 0.

             for each base-rat no-lock
                 where (base-rat.cod-estabel      = tt-estabel.cod-estabel)
                and   ((base-rat.cod-canal-venda >= tt-param.cod-canal-venda-ini
                  and   base-rat.cod-canal-venda <= tt-param.cod-canal-venda-fim)
                  or    base-rat.cod-canal-venda  = ?)
                and   ((base-rat.cod-gr-cli      >= tt-param.cod-gr-cli-ini
                  and   base-rat.cod-gr-cli      <= tt-param.cod-gr-cli-fim)
                  or    base-rat.cod-gr-cli       = ?)
                and   ((base-rat.nome-abrev      >= tt-param.nome-abrev-ini
                  and   base-rat.nome-abrev      <= tt-param.nome-abrev-fim)
                  or    base-rat.nome-abrev       = ?)
                and   ((base-rat.nome-ab-reg     >= tt-param.nome-ab-reg-ini
                  and   base-rat.nome-ab-reg     <= tt-param.nome-ab-reg-fim)
                  or    base-rat.nome-ab-reg      = ?)
                and   ((base-rat.nome-mic-reg    >= tt-param.nome-mic-reg-ini
                  and   base-rat.nome-mic-reg    <= tt-param.nome-mic-reg-fim)
                  or    base-rat.nome-mic-reg     = ?)
                  and   base-rat.cod-rep         >= tt-param.cod-rep-ini
                  and   base-rat.cod-rep         <= tt-param.cod-rep-fim
                  and   base-rat.cd-produto      >= tt-param.produto-ini
                  and   base-rat.cd-produto      <= tt-param.produto-fim
                  and   base-rat.codigo           = tt-param.codigo
                  and  (can-find(tt-canal-cotas where tt-canal-cotas.cod-canal-venda = base-rat.cod-canal-venda) or
                                base-rat.cod-canal-venda = 0 or
                                base-rat.cod-canal-venda = ?)
                  break by base-rat.cd-produto:

                /*********************************************************/
                /*** Se for Previsao de Venda utiliza Periodo Inicial, ***/
                /*** senao utiliza Periodo.                            ***/
                /*********************************************************/
                if tt-param.origem-dados = 1 then
                   assign da-dt-aux = tt-param.dt-periodo-ini.
                else
                   assign da-dt-aux = tt-param.dt-periodo.       

                if tt-param.origem-dados = 2 and 
                   first-of (base-rat.cd-produto) then do: 

                   find base-cota
                        where base-cota.cod-estabel = base-rat.cod-estabel
                        and   base-cota.cd-produto  = base-rat.cd-produto 
                        and   base-cota.dt-inicial  = da-dt-aux NO-LOCK no-error.
                   if avail base-cota then do:       
                      /* cria base de cota */
                      find b-base-cota exclusive-lock
                           where b-base-cota.cod-estabel = base-cota.cod-estabel
                           and   b-base-cota.cd-produto  = base-cota.cd-produto 
                           and   b-base-cota.dt-inicial  = tt-param.dt-periodo-ini no-error.
                      if not avail b-base-cota then do:
                         create b-base-cota.
                         assign b-base-cota.cod-estabel = base-cota.cod-estabel
                                b-base-cota.cd-produto  = base-cota.cd-produto
                                b-base-cota.dt-inicial  = tt-param.dt-periodo-ini 
                                b-base-cota.dt-final    = tt-param.dt-periodo-fim 
                                b-base-cota.qt-prevista = base-cota.qt-prevista.
                         &IF DEFINED (bf_dis_adm_cotas) &THEN  
                             IF CAN-FIND (item-cota WHERE
                                          item-cota.it-codigo = base-cota.cd-produto AND
                                          item-cota.log-cota-limite = YES ) THEN
                                ASSIGN b-base-cota.log-cota-limite = YES.
                             ASSIGN b-base-cota.cd-produto-dest = base-cota.cd-produto-dest.
                         &ENDIF


                      end.
                      else do:
                         if (tt-param.dt-periodo <> tt-param.dt-periodo-ini) or
                            (tt-param.dt-periodo = tt-param.dt-periodo-ini and
                             can-find (first cotas where
                                             cotas.cod-estabel     = base-rat.cod-estabel
                                       and   cotas.cod-canal-venda = base-rat.cod-canal-venda
                                       and   cotas.cod-gr-cli      = base-rat.cod-gr-cli
                                       and   cotas.nome-abrev      = base-rat.nome-abrev
                                       and   cotas.nome-ab-reg     = base-rat.nome-ab-reg
                                       and   cotas.nome-mic-reg    = base-rat.nome-mic-reg
                                       and   cotas.cod-rep         = base-rat.cod-rep
                                       and   cotas.cd-produto      = base-rat.cd-produto
                                       and   cotas.dt-inicial      = tt-param.dt-periodo-ini)) then 
                            assign b-base-cota.qt-prevista = b-base-cota.qt-prevista + base-cota.qt-prevista.
                      end. 
                   end. 
                end.             
                
                run pi-acompanhar in h-acomp (input base-rat.cd-produto).

                find first base-cota
                     where base-cota.cod-estabel = base-rat.cod-estabel
                     and   base-cota.cd-produto  = base-rat.cd-produto 
                     and   base-cota.dt-inicial  = da-dt-aux NO-LOCK no-error.
                if avail base-cota then do:
                   /**************************************************************************/
                   /*** OBS.: Nao ha preocupacao aqui com o estab padrao, pois no for each ***/
                   /***       do base-rat ja foi filtrado isto                             ***/
                   /**************************************************************************/
                   find first cotas exclusive-lock
                        where cotas.cod-estabel     = base-rat.cod-estabel
                        and   cotas.cod-canal-venda = base-rat.cod-canal-venda
                        and   cotas.cod-gr-cli      = base-rat.cod-gr-cli
                        and   cotas.nome-abrev      = base-rat.nome-abrev
                        and   cotas.nome-ab-reg     = base-rat.nome-ab-reg
                        and   cotas.nome-mic-reg    = base-rat.nome-mic-reg
                        and   cotas.cod-rep         = base-rat.cod-rep
                        and   cotas.cd-produto      = base-rat.cd-produto
                        and   cotas.dt-inicial      = tt-param.dt-periodo-ini no-error.

                   if not avail cotas then do:
                      create cotas.
                      assign cotas.cod-estabel     = base-rat.cod-estabel
                             cotas.cod-canal-venda = base-rat.cod-canal-venda
                             cotas.cod-gr-cli      = base-rat.cod-gr-cli
                             cotas.nome-abrev      = base-rat.nome-abrev
                             cotas.nome-ab-reg     = base-rat.nome-ab-reg
                             cotas.nome-mic-reg    = base-rat.nome-mic-reg
                             cotas.cod-rep         = base-rat.cod-rep
                             cotas.cd-produto      = base-rat.cd-produto
                             cotas.dt-inicial      = tt-param.dt-periodo-ini
                             cotas.dt-final        = tt-param.dt-periodo-fim.
                   end.

                   {acp/ac9001.i &param-cota=no}     

                   assign de-prevista       = ((base-rat.pct-rateio * base-cota.qt-prevista) / 100)
                          tt-cotas.prevista = de-prevista
                          tt-cotas.original = tt-cotas.prevista.


                   /********************************************/
                   /******* caso nÆo utilize decimais **********/
                   /********************************************/
                   if tt-param.util-decimal = no then
                      assign tt-cotas.prevista = int(tt-cotas.prevista)
                             tt-cotas.original = int(tt-cotas.original).  

                   /********************************************/
                   /*** Verifica a maior quantidade prevista ***/
                   /********************************************/
                   if first-of (base-rat.cd-produto) then
                      assign de-maior-qt-prev = 0.                   

                   if tt-cotas.prevista > de-maior-qt-prev then 
                      assign de-maior-qt-prev = tt-cotas.prevista
                             r-id-cotas       = rowid(cotas).

                   /*************************************/
                   /*** Acumula a quantidade prevista ***/
                   /*************************************/
                   assign de-total-qt-prevista = de-total-qt-prevista + tt-cotas.prevista.

                   {acp/ac9001.i &param-cota=yes}

                   if tt-param.atualiza = no then
                      assign cotas.qt-original = 0
                             cotas.vl-original = 0.
                   /******************************************************/
                   /*** Se for a ultima base de rateio daquele produto ***/
                   /******************************************************/
                   if last-of(base-rat.cd-produto) then do:

                      /****************************************************************************************/
                      /*** Verifica se a quantidade prevista para a base de cota ² diferente da distribuida ***/
                      /****************************************************************************************/

                      if base-cota.qt-prevista <> de-total-qt-prevista and
                         tt-param.soma-dif and l-limita then do:

                         for first cotas exclusive-lock
                              where rowid(cotas) = r-id-cotas :
                            {acp/ac9001.i &param-cota=no}

                            /********************************************************************/
                            /*** Faz o balanceamento da Qt Prevista na Cota com o maior valor ***/
                            /********************************************************************/
                            find b-base-cota exclusive-lock
                                 where b-base-cota.cod-estabel = base-cota.cod-estabel
                                 and   b-base-cota.cd-produto  = base-cota.cd-produto 
                                 and   b-base-cota.dt-inicial  = tt-param.dt-periodo-ini no-error.
                            if avail b-base-cota then                    
                               if b-base-cota.qt-prevista > de-total-qt-prevista then 
                                  assign tt-cotas.prevista = tt-cotas.prevista + (b-base-cota.qt-prevista - de-total-qt-prevista)
                                         tt-cotas.original = tt-cotas.prevista.
                               else
                                  assign tt-cotas.prevista = tt-cotas.prevista - (de-total-qt-prevista - b-base-cota.qt-prevista)
                                         tt-cotas.original = tt-cotas.prevista.

                            {acp/ac9001.i &param-cota=yes}

                            if tt-param.atualiza = no then
                               assign cotas.qt-original = 0
                                      cotas.vl-original = 0.                            

                         end.   

                      end.
                      assign de-total-qt-prevista = 0.
                   end.
                end.

             end.
          end.

          /**********************************/
          /*** Se for por valor informado ***/
          /**********************************/
          if tt-param.origem-dados = 3 then do:

             assign de-maior-qt-prev = 0
                    de-maior-qt-bas-prev = 0.

             for each base-rat no-lock
                 where (base-rat.cod-estabel       = tt-estabel.cod-estabel)
                 and   ((base-rat.cod-canal-venda >= tt-param.cod-canal-venda-ini
                   and   base-rat.cod-canal-venda <= tt-param.cod-canal-venda-fim)
                   or    base-rat.cod-canal-venda  = ?)
                 and   ((base-rat.cod-gr-cli      >= tt-param.cod-gr-cli-ini
                   and   base-rat.cod-gr-cli      <= tt-param.cod-gr-cli-fim)
                   or    base-rat.cod-gr-cli       = ?)
                 and   ((base-rat.nome-abrev      >= tt-param.nome-abrev-ini
                   and   base-rat.nome-abrev      <= tt-param.nome-abrev-fim)
                   or    base-rat.nome-abrev       = ?)
                 and   ((base-rat.nome-ab-reg     >= tt-param.nome-ab-reg-ini
                   and   base-rat.nome-ab-reg     <= tt-param.nome-ab-reg-fim)
                   or    base-rat.nome-ab-reg      = ?)
                 and   ((base-rat.nome-mic-reg    >= tt-param.nome-mic-reg-ini
                   and   base-rat.nome-mic-reg    <= tt-param.nome-mic-reg-fim)
                   or    base-rat.nome-mic-reg     = ?)
                   and   base-rat.cod-rep         >= tt-param.cod-rep-ini
                   and   base-rat.cod-rep         <= tt-param.cod-rep-fim
                   and   base-rat.cd-produto      >= tt-param.produto-ini
                   and   base-rat.cd-produto      <= tt-param.produto-fim
                   and   base-rat.codigo           = tt-param.codigo
                   and  (can-find(tt-canal-cotas where tt-canal-cotas.cod-canal-venda = base-rat.cod-canal-venda) or
                                 base-rat.cod-canal-venda = 0 or
                                 base-rat.cod-canal-venda = ?)
                   break by base-rat.cd-produto:

                 run pi-acompanhar in h-acomp (input base-rat.cd-produto).

                 /*** OBS.: Nao haÿpreocupacao aqui com o estab padrao, pois no for each ***/
                 /***       do base-rat ja foi filtrado isto                             ***/

                 find cotas exclusive-lock 
                      where cotas.cod-estabel     = base-rat.cod-estabel
                      and   cotas.cod-canal-venda = base-rat.cod-canal-venda
                      and   cotas.cod-gr-cli      = base-rat.cod-gr-cli
                      and   cotas.nome-abrev      = base-rat.nome-abrev
                      and   cotas.nome-ab-reg     = base-rat.nome-ab-reg
                      and   cotas.nome-mic-reg    = base-rat.nome-mic-reg
                      and   cotas.cod-rep         = base-rat.cod-rep
                      and   cotas.cd-produto      = base-rat.cd-produto
                      and   cotas.dt-inicial      = tt-param.dt-periodo-ini no-error.
                 if not avail cotas then do:
                    create cotas.
                    assign cotas.cod-estabel     = base-rat.cod-estabel
                           cotas.cod-canal-venda = base-rat.cod-canal-venda
                           cotas.cod-gr-cli      = base-rat.cod-gr-cli
                           cotas.nome-abrev      = base-rat.nome-abrev
                           cotas.nome-ab-reg     = base-rat.nome-ab-reg
                           cotas.nome-mic-reg    = base-rat.nome-mic-reg
                           cotas.cod-rep         = base-rat.cod-rep
                           cotas.cd-produto      = base-rat.cd-produto
                           cotas.dt-inicial      = tt-param.dt-periodo-ini
                           cotas.dt-final        = tt-param.dt-periodo-fim.

                    {acp/ac9001.i &param-cota=no}     

                    assign de-prevista = (base-rat.pct-rateio * tt-param.total-cota) / 100
                           tt-cotas.prevista = de-prevista
                           tt-cotas.original = tt-cotas.prevista.
                 end.
                 else do:

                     {acp/ac9001.i &param-cota=no}

                     /*** Distribui a cota de acordo com o percentual de rateio sobre o valor informado ***/
                     assign de-prevista = (base-rat.pct-rateio * tt-param.total-cota) / 100
                            tt-cotas.prevista = tt-cotas.prevista + de-prevista
                            tt-cotas.original = tt-cotas.prevista.
                 end.

                 /******* caso nÆo utilize decimais **********/
                 if tt-param.util-decimal = no then
                    assign tt-cotas.prevista = int(tt-cotas.prevista)
                           tt-cotas.original = int(tt-cotas.original).  

                 if first-of (base-rat.cd-produto) then do:
                    /*** Verifica a maior quantidade prevista ***/
                    assign de-maior-qt-prev = 0
                           de-total-qt-prevista = 0.

                    /* cria base de cota */
                    find first base-cota exclusive-lock
                         where base-cota.cod-estabel = tt-cotas.cod-estabel
                         and   base-cota.cd-produto  = tt-cotas.cd-produto 
                         and   base-cota.dt-inicial  = tt-param.dt-periodo-ini no-error.
                    if not avail base-cota then do:
                       create base-cota.
                       assign base-cota.cod-estabel = tt-cotas.cod-estabel
                              base-cota.cd-produto  = tt-cotas.cd-produto
                              base-cota.dt-inicial  = tt-cotas.dt-inicial 
                              base-cota.dt-final    = tt-param.dt-periodo-fim
                              base-cota.qt-prevista = tt-param.total-cota.
                       &IF DEFINED (bf_dis_adm_cotas) &THEN  
                           IF CAN-FIND (item-cota WHERE
                                        item-cota.it-codigo = tt-cotas.cd-produto AND
                                        item-cota.log-cota-limite = YES ) THEN
                              ASSIGN base-cota.log-cota-limite = YES.
                           ASSIGN base-cota.cd-produto-dest = tt-cotas.cd-produto.
                       &ENDIF


                    end.
                    else 
                       assign base-cota.qt-prevista = base-cota.qt-prevista + tt-param.total-cota.
                 end.

                 /*** Acumula a maior qt prevista base-cota***/
                 if base-cota.qt-prevista > de-maior-qt-bas-prev then
                    assign de-maior-qt-bas-prev = base-cota.qt-prevista.

                 /*** Acumula o total previsto de base-cota***/
                 assign de-total-qt-prevista  = de-total-qt-prevista  + tt-cotas.prevista.

                 if tt-cotas.prevista > de-maior-qt-prev then 
                    assign de-maior-qt-prev = tt-cotas.prevista
                           r-id-cotas       = rowid(cotas).                 

                 {acp/ac9001.i &param-cota=yes}

                 if tt-param.atualiza = no then
                   assign cotas.qt-original = 0
                          cotas.vl-original = 0.

                 if last-of(base-rat.cd-produto) then do:

                    if de-maior-qt-bas-prev <> de-total-qt-prevista and
                       tt-param.soma-dif and l-limita then do:

                       for first cotas exclusive-lock 
                           where rowid(cotas) = r-id-cotas :
                           {acp/ac9001.i &param-cota=no}

                           /*** Faz o balanceamento da Qt Prevista na Cota com o maior valor ***/

                           if de-maior-qt-bas-prev > de-total-qt-prevista then 
                              assign tt-cotas.prevista = tt-cotas.prevista + (de-maior-qt-bas-prev - de-total-qt-prevista)
                                     de-dif-prev       = (de-maior-qt-bas-prev - de-total-qt-prevista).
                           else
                              assign tt-cotas.prevista = tt-cotas.prevista - (de-total-qt-prevista - de-maior-qt-bas-prev)
                                     de-dif-prev       = (de-total-qt-prevista - de-maior-qt-bas-prev).

                           {acp/ac9001.i &param-cota=yes}

                           if tt-param.atualiza = no then
                              assign cotas.qt-original = 0
                                     cotas.vl-original = 0.
                       end.                                         
                    end.
                    assign de-total-qt-prevista = 0.
                 end.
             end.

          end.
       end. /*l-perc-ok*/
    end. /*for each estabel*/

end procedure. /*pi-release202*/




procedure pi-release203. /* Por N¡veis */
&IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
    /*** Calcula o percentual de distribui‡Æo para cada n¡vel controlado,
         gerando os erros: Se o rateio ‚ limitado e ultrapassa 100% 
                           Se nÆo possui rateio definido para o n¡vel ***/

for each tt-estabel no-lock where   
         tt-estabel.log-impl-niveis = yes:
  find par-cota no-lock where
       par-cota.cod-estabel = tt-estabel.cod-estabel no-error.
  assign l-perc-ok = yes.
  if  avail par-cota then do:  
    if  par-cota.cont-canal-venda then do:
        {acp/ac1010.i &condicao=" and base-rat.cod-canal-venda >= tt-param.cod-canal-venda-ini
                       and   base-rat.cod-canal-venda <= tt-param.cod-canal-venda-fim
                       and   base-rat.cod-canal-venda <> ?
                       and   base-rat.cod-gr-cli   = (if par-cota.cont-gr-cli  then ? else 0)
                       and   base-rat.nome-abrev   = (if par-cota.cont-cliente then ? else '')
                       and   base-rat.nome-ab-reg  = (if par-cota.cont-ab-reg  then ? else '')
                       and   base-rat.nome-mic-reg = (if par-cota.cont-mic-reg then ? else '')
                       and   base-rat.cod-rep      = ? "
                      &quebra="break by base-rat.cd-produto
                                     by base-rat.cod-estabel"
                      &last="base-rat.cod-estabel"
                      &nivel="Canal Venda"}.
    end.
    if  par-cota.cont-gr-cli then do:
        {acp/ac1010.i &condicao=" and ((base-rat.cod-canal-venda >= tt-param.cod-canal-venda-ini
                       and   base-rat.cod-canal-venda <= tt-param.cod-canal-venda-fim
                       and   base-rat.cod-canal-venda <> ?) 
                        or   base-rat.cod-canal-venda  = (if par-cota.cont-canal-venda = no then 0
                                                         else tt-param.cod-canal-venda-ini)) /*Recurso utilizado pela falta de valores para o else*/
                       and  (base-rat.cod-gr-cli      >= tt-param.cod-gr-cli-ini
                       and   base-rat.cod-gr-cli      <= tt-param.cod-gr-cli-fim
                       and   base-rat.cod-gr-cli      <> ?)
                       and   base-rat.nome-abrev   = (if par-cota.cont-cliente then ? else '')
                       and   base-rat.nome-ab-reg  = (if par-cota.cont-ab-reg  then ? else '')
                       and   base-rat.nome-mic-reg = (if par-cota.cont-mic-reg then ? else '')
                       and   base-rat.cod-rep      = ? "                      
                       &quebra="break by base-rat.cd-produto
                                     by base-rat.cod-estabel
                                     by base-rat.cod-canal-venda"
                      &last="base-rat.cod-canal-venda"
                       &nivel="Grupo Cliente"}.
    end.

    if  par-cota.cont-cliente then do:
        {acp/ac1010.i &condicao=" and ((base-rat.cod-canal-venda >= tt-param.cod-canal-venda-ini
                       and   base-rat.cod-canal-venda <= tt-param.cod-canal-venda-fim
                       and   base-rat.cod-canal-venda <> ?) 
                        or   base-rat.cod-canal-venda  = (if par-cota.cont-canal-venda = no then 0
                                                         else tt-param.cod-canal-venda-ini)) /*Recurso utilizado pela falta de valores para o else*/
                       and ((base-rat.cod-gr-cli      >= tt-param.cod-gr-cli-ini
                       and   base-rat.cod-gr-cli      <= tt-param.cod-gr-cli-fim
                       and   base-rat.cod-gr-cli      <> ?) 
                        or   base-rat.cod-gr-cli       = (if par-cota.cont-gr-cli = no then 0
                                                         else tt-param.cod-gr-cli-ini)) /*Recurso utilizado pela falta de valores para o else*/
                       and  (base-rat.nome-abrev      >= tt-param.nome-abrev-ini
                       and   base-rat.nome-abrev      <= tt-param.nome-abrev-fim
                       and   base-rat.nome-abrev      <> ?)                       
                       and   base-rat.nome-ab-reg  = (if par-cota.cont-ab-reg  then ? else '')
                       and   base-rat.nome-mic-reg = (if par-cota.cont-mic-reg then ? else '')
                       and   base-rat.cod-rep      = ? "
                       &quebra="break by base-rat.cd-produto
                                     by base-rat.cod-estabel
                                     by base-rat.cod-canal-venda
                                     by base-rat.cod-gr-cli"
                      &last="base-rat.cod-gr-cli"
                      &nivel="Cliente"}.
    end.

    if  par-cota.cont-ab-reg then do:
        {acp/ac1010.i &condicao=" and ((base-rat.cod-canal-venda >= tt-param.cod-canal-venda-ini
                       and   base-rat.cod-canal-venda <= tt-param.cod-canal-venda-fim
                       and   base-rat.cod-canal-venda <> ?) 
                        or   base-rat.cod-canal-venda  = (if par-cota.cont-canal-venda = no then 0
                                                         else tt-param.cod-canal-venda-ini)) /*Recurso utilizado pela falta de valores para o else*/
                       and ((base-rat.cod-gr-cli      >= tt-param.cod-gr-cli-ini
                       and   base-rat.cod-gr-cli      <= tt-param.cod-gr-cli-fim
                       and   base-rat.cod-gr-cli      <> ?) 
                        or   base-rat.cod-gr-cli       = (if par-cota.cont-gr-cli = no then 0
                                                         else tt-param.cod-gr-cli-ini)) /*Recurso utilizado pela falta de valores para o else*/
                       and ((base-rat.nome-abrev      >= tt-param.nome-abrev-ini
                       and   base-rat.nome-abrev      <= tt-param.nome-abrev-fim

                       and   base-rat.nome-abrev      <> ?)
                        or   base-rat.nome-abrev       = (if par-cota.cont-cliente = no then ''
                                                         else tt-param.nome-abrev-ini)) /*Recurso utilizado pela falta de valores para o else*/                     
                       and  (base-rat.nome-ab-reg     >= tt-param.nome-ab-reg-ini
                       and   base-rat.nome-ab-reg     <= tt-param.nome-ab-reg-fim
                       and   base-rat.nome-ab-reg     <> ?)
                       and   base-rat.nome-mic-reg = (if par-cota.cont-mic-reg then ? else '')
                       and   base-rat.cod-rep      = ? "
                      &quebra="break by base-rat.cd-produto
                                     by base-rat.cod-estabel
                                     by base-rat.cod-canal-venda
                                     by base-rat.cod-gr-cli
                                     by base-rat.nome-abrev"
                      &last="base-rat.nome-abrev" 
                      &nivel="RegiÆo"}.
                      
    end.

    if  par-cota.cont-mic-reg then do:
        {acp/ac1010.i &condicao=" and ((base-rat.cod-canal-venda >= tt-param.cod-canal-venda-ini
                       and   base-rat.cod-canal-venda <= tt-param.cod-canal-venda-fim
                       and   base-rat.cod-canal-venda <> ?) 
                        or   base-rat.cod-canal-venda  = (if par-cota.cont-canal-venda = no then 0
                                                         else tt-param.cod-canal-venda-ini)) /*Recurso utilizado pela falta de valores para o else*/
                       and ((base-rat.cod-gr-cli      >= tt-param.cod-gr-cli-ini
                       and   base-rat.cod-gr-cli      <= tt-param.cod-gr-cli-fim
                       and   base-rat.cod-gr-cli      <> ?) 
                        or   base-rat.cod-gr-cli       = (if par-cota.cont-gr-cli = no then 0
                                                         else tt-param.cod-gr-cli-ini)) /*Recurso utilizado pela falta de valores para o else*/
                       and ((base-rat.nome-abrev      >= tt-param.nome-abrev-ini
                       and   base-rat.nome-abrev      <= tt-param.nome-abrev-fim
                       and   base-rat.nome-abrev      <> ?)
                        or   base-rat.nome-abrev       = (if par-cota.cont-cliente = no then ''
                                                         else tt-param.nome-abrev-ini)) /*Recurso utilizado pela falta de valores para o else*/                        
                       and ((base-rat.nome-ab-reg     >= tt-param.nome-ab-reg-ini
                       and   base-rat.nome-ab-reg     <= tt-param.nome-ab-reg-fim
                       and   base-rat.nome-ab-reg     <> ?) 
                        or   base-rat.nome-ab-reg      = (if par-cota.cont-ab-reg = no then ''
                                                         else tt-param.nome-ab-reg-ini)) /*Recurso utilizado pela falta de valores para o else*/
                       and  (base-rat.nome-mic-reg    >= tt-param.nome-mic-reg-ini
                       and   base-rat.nome-mic-reg    <= tt-param.nome-mic-reg-fim
                       and   base-rat.nome-mic-reg    <> ?)
                       and   base-rat.cod-rep      = ? "
                      &quebra="break by base-rat.cd-produto
                                     by base-rat.cod-estabel
                                     by base-rat.cod-canal-venda
                                     by base-rat.cod-gr-cli
                                     by base-rat.nome-abrev
                                     by base-rat.nome-ab-reg"
                      &last="base-rat.nome-ab-reg" 
                      &nivel="MicrorregiÆo"}.
                      
    end.
            /* Representante - Sempre Controla */
    {acp/ac1010.i &condicao=" and ((base-rat.cod-canal-venda >= tt-param.cod-canal-venda-ini
                   and   base-rat.cod-canal-venda <= tt-param.cod-canal-venda-fim
                   and   base-rat.cod-canal-venda <> ?) 
                    or   base-rat.cod-canal-venda  = (if par-cota.cont-canal-venda = no then 0
                                                     else tt-param.cod-canal-venda-ini)) /*Recurso utilizado pela falta de valores para o else*/
                   and ((base-rat.cod-gr-cli      >= tt-param.cod-gr-cli-ini
                   and   base-rat.cod-gr-cli      <= tt-param.cod-gr-cli-fim
                   and   base-rat.cod-gr-cli      <> ?) 
                    or   base-rat.cod-gr-cli       = (if par-cota.cont-gr-cli = no then 0
                                                     else tt-param.cod-gr-cli-ini)) /*Recurso utilizado pela falta de valores para o else*/
                   and ((base-rat.nome-abrev      >= tt-param.nome-abrev-ini
                   and   base-rat.nome-abrev      <= tt-param.nome-abrev-fim
                   and   base-rat.nome-abrev      <> ?)
                    or   base-rat.nome-abrev       = (if par-cota.cont-cliente = no then ''
                                                     else tt-param.nome-abrev-ini)) /*Recurso utilizado pela falta de valores para o else*/                        
                   and ((base-rat.nome-ab-reg     >= tt-param.nome-ab-reg-ini
                   and   base-rat.nome-ab-reg     <= tt-param.nome-ab-reg-fim
                   and   base-rat.nome-ab-reg     <> ?) 
                    or   base-rat.nome-ab-reg      = (if par-cota.cont-ab-reg = no then ''
                                                     else tt-param.nome-ab-reg-ini)) /*Recurso utilizado pela falta de valores para o else*/
                   and ((base-rat.nome-mic-reg    >= tt-param.nome-mic-reg-ini                   
                   and   base-rat.nome-mic-reg    <= tt-param.nome-mic-reg-fim
                   and   base-rat.nome-mic-reg    <> ?)
                    or   base-rat.nome-mic-reg     = (if par-cota.cont-mic-reg = no then ''
                                                     else tt-param.nome-mic-reg-ini)) /*Recurso utilizado pela falta de valores para o else*/
                   and  (base-rat.cod-rep         >= tt-param.cod-rep-ini
                   and   base-rat.cod-rep         <= tt-param.cod-rep-fim
                   and   base-rat.cod-rep         <> ?) "
                  &quebra="break by base-rat.cd-produto
                                 by base-rat.cod-estabel
                                 by base-rat.cod-canal-venda
                                 by base-rat.cod-gr-cli
                                 by base-rat.nome-abrev
                                 by base-rat.nome-ab-reg
                                 by base-rat.nome-mic-reg"
                  &last="base-rat.nome-mic-reg"
                  &nivel="Representante"}.


    /********************************************************/
    /*** Se nao houve nenhum problema nas bases de rateio ***/
    /********************************************************/
    if l-perc-ok then do:
       /*********************************************************/
       /*** Dependendo do parametro, elimina as cotas antigas ***/
       /*********************************************************/
       if tt-param.deleta then do:
          for each base-cota USE-INDEX periodo EXCLUSIVE-LOCK 
              where base-cota.cod-estabel  = tt-estabel.cod-estabel
              and   base-cota.cd-produto  >= tt-param.produto-ini
              and   base-cota.cd-produto  <= tt-param.produto-fim
              and   base-cota.dt-inicial   = tt-param.dt-periodo-ini :

              IF NOT CAN-FIND (FIRST base-rat WHERE 
                                     base-rat.cod-estabel = base-cota.cod-estabel AND
                                     base-rat.cd-produto  = base-cota.cd-produto  AND
                                     base-rat.codigo      = tt-param.codigo) THEN
                 NEXT.


              for each cotas exclusive-lock
                  where cotas.cod-estabel = base-cota.cod-estabel
                  and   cotas.cd-produto  = base-cota.cd-produto
                  and   cotas.dt-inicial  = base-cota.dt-inicial:
                  delete cotas.
              end.
              delete base-cota. 
          end.
       end.


       /****************************************/
       /***   Se for por PrevisÆo de Venda   ***/
       /****************************************/
       if  tt-param.origem-dados = 1 then do:

            /*************************************************************************/
            /*** Verifica todas as previs„es de venda do estabelecimento escolhido ***/
            /*** e do plano escolhido                                              ***/
            /*************************************************************************/
           for each  pr-venda no-lock
               where pr-venda.cod-estabel   = tt-estabel.cod-estabel
               and   pr-venda.cd-plano      = tt-param.cod-plano
               AND   pr-venda.it-codigo    >= tt-param.produto-ini
               AND   pr-venda.it-codigo    <= tt-param.produto-fim
               BREAK BY pr-venda.it-codigo :


               IF  NOT AVAIL ITEM-cota
               OR  item-cota.it-codigo <> pr-venda.it-codigo THEN do:
                   FOR FIRST item-cota NO-LOCK
                       WHERE item-cota.it-codigo = pr-venda.it-codigo:
                   END.
				   assign de-total-qt-prevista = 0.
			   end.

               IF NOT AVAIL item-cota THEN
                  NEXT.

                /********************************************************/
                /*** Acumula a qtde prevista de venda daquele periodo ***/
                /********************************************************/
                
                for each  pr-vend-per no-lock
                    where pr-vend-per.num-id-pr-venda = pr-venda.num-id-pr-venda 
                    and   pr-vend-per.num-per-pm     >= tt-param.periodo-ini
                    and   pr-vend-per.num-per-pm     <= tt-param.periodo-fim:

                    run pi-acompanhar in h-acomp (input pr-vend-per.num-id-pr-venda).

                    assign de-total-qt-prevista = de-total-qt-prevista + pr-vend-per.qt-prevista.

                end.

                IF LAST-OF ( pr-venda.it-codigo) AND
                   de-total-qt-prevista <> 0 THEN DO:

                    /***************************************************************/
                    /*** Se for estab unico usa o padrao senao usa o da previsao ***/
                    /***************************************************************/
                    if substring(para-ped.char-2, 1, 3) = "yes" then
                       assign c-estab-temp = para-ped.estab-padrao.
                    else
                       assign c-estab-temp = pr-venda.cod-estabel.
    
                    find par-cota where par-cota.cod-estabel = c-estab-temp no-lock no-error.
                    if avail par-cota then do:
                       /************************************************************************/
                       /*** Se nao controla produto atribui o item padrao do estabelecimento ***/
                       /************************************************************************/
                       if not par-cota.cont-produto then
                          assign c-it-codigo = par-cota.it-codigo-padrao.
                       else
                          assign c-it-codigo = pr-venda.it-codigo.
                    end.
                    else
                       assign c-it-codigo = pr-venda.it-codigo.

                    IF  AVAIL item-cota
                    AND item-cota.log-produto THEN
                        FOR FIRST est-prod-coml NO-LOCK
                            WHERE est-prod-coml.it-codigo = pr-venda.it-codigo:
                            ASSIGN c-it-codigo = est-prod-coml.cod-produto-coml.
                        END.
        
                    /*********************************************************************/
                    /*** Localiza Base de Cota, se nao encontrar cria uma nova         ***/
                    /*** Em todos os casos atribui a qtde prevista para a Base de Cota ***/
                    /*********************************************************************/
                    find base-cota
                         where base-cota.cod-estabel = c-estab-temp
                         and   base-cota.cd-produto  = c-it-codigo 
                         and   base-cota.dt-inicial  = tt-param.dt-periodo-ini EXCLUSIVE-LOCK no-error.
                    if not avail base-cota then do:
                       create base-cota.
                       assign base-cota.cod-estabel = c-estab-temp
                              base-cota.cd-produto  = c-it-codigo
                              base-cota.cd-produto-dest = c-it-codigo
                              base-cota.dt-inicial  = tt-param.dt-periodo-ini 
                              base-cota.dt-final    = tt-param.dt-periodo-fim
                              base-cota.qt-prevista = de-total-qt-prevista.
                       IF CAN-FIND (item-cota WHERE
                                    item-cota.it-codigo = c-it-codigo AND
                                    item-cota.log-cota-limite = YES ) THEN
                           ASSIGN base-cota.log-cota-limite = YES.
                    end.
                    else assign base-cota.qt-prevista = base-cota.qt-prevista + de-total-qt-prevista.

                 end. 
            end. 
       end.


       assign de-maior-qt-prev = 0.
       for each base-rat no-lock
           where (base-rat.cod-estabel      = tt-estabel.cod-estabel)
          and   ((base-rat.cod-canal-venda >= tt-param.cod-canal-venda-ini
            and   base-rat.cod-canal-venda <= tt-param.cod-canal-venda-fim)
            or    base-rat.cod-canal-venda  = (if par-cota.cont-canal-venda then ? else 0))
          and   ((base-rat.cod-gr-cli      >= tt-param.cod-gr-cli-ini
            and   base-rat.cod-gr-cli      <= tt-param.cod-gr-cli-fim)
            or    base-rat.cod-gr-cli       = (if par-cota.cont-gr-cli then ? else 0))
          and   ((base-rat.nome-abrev      >= tt-param.nome-abrev-ini
            and   base-rat.nome-abrev      <= tt-param.nome-abrev-fim)
            or    base-rat.nome-abrev       = (if par-cota.cont-cliente then ? else ''))
          and   ((base-rat.nome-ab-reg     >= tt-param.nome-ab-reg-ini
            and   base-rat.nome-ab-reg     <= tt-param.nome-ab-reg-fim)
            or    base-rat.nome-ab-reg      = (if par-cota.cont-cliente then ? else ''))
          and   ((base-rat.nome-mic-reg    >= tt-param.nome-mic-reg-ini
            and   base-rat.nome-mic-reg    <= tt-param.nome-mic-reg-fim)
            or    base-rat.nome-mic-reg     = (if par-cota.cont-mic-reg then ? else ''))
            and ((base-rat.cod-rep         >= tt-param.cod-rep-ini
            and   base-rat.cod-rep         <= tt-param.cod-rep-fim)
             or   base-rat.cod-rep          = ?)
            and   base-rat.cd-produto      >= tt-param.produto-ini
            and   base-rat.cd-produto      <= tt-param.produto-fim
            and   base-rat.codigo           = tt-param.codigo
            and  (can-find(tt-canal-cotas where tt-canal-cotas.cod-canal-venda = base-rat.cod-canal-venda) or
                          base-rat.cod-canal-venda = 0)
            break by base-rat.cod-estabel descending
                  by base-rat.cod-canal-venda descending
                  by base-rat.cod-gr-cli descending
                  by base-rat.nome-abrev descending
                  by base-rat.nome-ab-reg descending
                  by base-rat.nome-mic-reg descending
                  by base-rat.cod-rep descending
                  by base-rat.cd-produto:

           run pi-acompanhar in h-acomp (input base-rat.cd-produto).   

          /*********************************************************/
          /*** Se for Previsao de Venda utiliza Periodo Inicial, ***/
          /*** senao utiliza Periodo.                            ***/
          /*********************************************************/
          if tt-param.origem-dados = 1 then
             assign da-dt-aux = tt-param.dt-periodo-ini.
          else
             assign da-dt-aux = tt-param.dt-periodo.

          assign l-erro-base-cota = no
          	     l-utiliza-base-cota = no
                 c-cod-estabel = base-rat.cod-estabel
                 c-cd-produto = base-rat.cd-produto
                 da-dt-inicial = da-dt-aux
                 de-valor-base = 0. 
          if  base-rat.cod-rep <> ? then do:

             {acp/ac9005.i &cond-base-cota=" par-cota.cont-canal-venda = no and
                             par-cota.cont-gr-cli = no and
                             par-cota.cont-cliente = no and
                             par-cota.cont-ab-reg = no and
                             par-cota.cont-mic-reg = no "
                            &cond-cotas=" where b-cotas.cod-estabel = base-rat.cod-estabel and
                             b-cotas.cod-canal-venda = base-rat.cod-canal-venda and
                             b-cotas.cod-gr-cli = base-rat.cod-gr-cli and
                             b-cotas.nome-abrev = base-rat.nome-abrev and
                             b-cotas.nome-ab-reg = base-rat.nome-ab-reg and
                             b-cotas.nome-mic-reg = base-rat.nome-mic-reg and
                             b-cotas.cod-rep = ? and
                             b-cotas.cd-produto = base-rat.cd-produto and
                             b-cotas.dt-inicial = tt-param.dt-periodo-ini "}.
          end.
          else do:

              if  base-rat.nome-mic-reg <> ? and
                  par-cota.cont-mic-reg then do:


                  {acp/ac9005.i &cond-base-cota=" par-cota.cont-canal-venda = no and
                                  par-cota.cont-gr-cli = no and
                                  par-cota.cont-cliente = no and
                                  par-cota.cont-ab-reg = no " 
                                 &cond-cotas=" where b-cotas.cod-estabel = base-rat.cod-estabel and
                                  b-cotas.cod-canal-venda = base-rat.cod-canal-venda  and
                                  b-cotas.cod-gr-cli = base-rat.cod-gr-cli and
                                  b-cotas.nome-abrev = base-rat.nome-abrev and
                                  b-cotas.nome-ab-reg = base-rat.nome-ab-reg and
                                  b-cotas.nome-mic-reg = ? and
                                  b-cotas.cod-rep = ? and
                                  b-cotas.cd-produto = base-rat.cd-produto and
                                  b-cotas.dt-inicial = tt-param.dt-periodo-ini "}.
              end.
              else do:
                  if  base-rat.nome-ab-reg <> ? and
                      par-cota.cont-ab-reg then do:


                      {acp/ac9005.i &cond-base-cota=" par-cota.cont-canal-venda = no and
                                      par-cota.cont-gr-cli = no and
                                      par-cota.cont-cliente = no " 
                                     &cond-cotas=" where b-cotas.cod-estabel = base-rat.cod-estabel and
                                      b-cotas.cod-canal-venda = base-rat.cod-canal-venda  and
                                      b-cotas.cod-gr-cli = base-rat.cod-gr-cli and
                                      b-cotas.nome-abrev = base-rat.nome-abrev and
                                      b-cotas.nome-ab-reg = ? and
                                      b-cotas.nome-mic-reg = (if par-cota.cont-mic-reg then ? else '') and
                                      b-cotas.cod-rep = ? and
                                      b-cotas.cd-produto = base-rat.cd-produto and
                                      b-cotas.dt-inicial = tt-param.dt-periodo-ini "}.
                  end.
                  else do:
                      if  base-rat.nome-abrev <> ? and
                          par-cota.cont-cliente then do:


                          {acp/ac9005.i &cond-base-cota=" par-cota.cont-canal-venda = no and
                                          par-cota.cont-gr-cli = no " 
                                         &cond-cotas=" where b-cotas.cod-estabel = base-rat.cod-estabel and
                                          b-cotas.cod-canal-venda = base-rat.cod-canal-venda  and
                                          b-cotas.cod-gr-cli = base-rat.cod-gr-cli and
                                          b-cotas.nome-abrev = ? and
                                          b-cotas.nome-ab-reg = (if par-cota.cont-ab-reg then ? else '') and
                                          b-cotas.nome-mic-reg = (if par-cota.cont-mic-reg then ? else '') and
                                          b-cotas.cod-rep = ? and
                                          b-cotas.cd-produto = base-rat.cd-produto and
                                          b-cotas.dt-inicial = tt-param.dt-periodo-ini "}.
                      end.
                      else do:   
                          if  base-rat.cod-gr-cli <> ? and
                              par-cota.cont-gr-cli then do:


                              {acp/ac9005.i &cond-base-cota=" par-cota.cont-canal-venda = no "
                                             &cond-cotas=" where b-cotas.cod-estabel = base-rat.cod-estabel and
                                              b-cotas.cod-canal-venda = base-rat.cod-canal-venda and
                                              b-cotas.cod-gr-cli = ? and
                                              b-cotas.nome-abrev = (if par-cota.cont-cliente then ? else '') and
                                              b-cotas.nome-ab-reg = (if par-cota.cont-ab-reg then ? else '') and
                                              b-cotas.nome-mic-reg = (if par-cota.cont-mic-reg then ? else '' ) and
                                              b-cotas.cod-rep = ? and
                                              b-cotas.cd-produto = base-rat.cd-produto and
                                              b-cotas.dt-inicial = tt-param.dt-periodo-ini "}.
                          end.
                          else do:
                              if  base-rat.cod-canal-venda <> ? and
                                  par-cota.cont-canal-venda then do:


                                  {acp/ac9005.i &cond-base-cota=" 1 = 1 "
                                                 &cond-cotas=" "}. /* "1 = 1" foi o artif¡cio utilizado para obrigar
                                                                 a entrada no primeiro "if" */
                              end.
                          end.
                      end.
                  end.
              end.
          end.   

          if  tt-param.origem-dados = 3 and
              l-utiliza-base-cota = yes then 
              assign de-valor-base = tt-param.total-cota
                     l-erro-base-cota = no.

          if l-erro-base-cota = no then do:
             if tt-param.origem-dados = 2 and
                l-utiliza-base-cota   = yes then

                if first-of (base-rat.cod-estabel) and
                   first-of (base-rat.cod-canal-venda) and
                   first-of (base-rat.cod-gr-cli) and
                   first-of (base-rat.nome-abrev) and
                   first-of (base-rat.nome-ab-reg) and
                   first-of (base-rat.nome-mic-reg) and
                   first-of (base-rat.cod-rep) and
                   first-of (base-rat.cd-produto) then do:            

                   find base-cota
                        where base-cota.cod-estabel = base-rat.cod-estabel
                        and   base-cota.cd-produto  = base-rat.cd-produto 
                        and   base-cota.dt-inicial  = tt-param.dt-periodo-ini EXCLUSIVE-LOCK no-error.


                   if avail base-cota then do:       
                       if (tt-param.dt-periodo = tt-param.dt-periodo-ini and
                           can-find (first cotas where
                                           cotas.cod-estabel     = base-rat.cod-estabel
                                     and   cotas.cod-canal-venda = base-rat.cod-canal-venda
                                     and   cotas.cod-gr-cli      = base-rat.cod-gr-cli
                                     and   cotas.nome-abrev      = base-rat.nome-abrev
                                     and   cotas.nome-ab-reg     = base-rat.nome-ab-reg
                                     and   cotas.nome-mic-reg    = base-rat.nome-mic-reg
                                     and   cotas.cod-rep         = base-rat.cod-rep
                                     and   cotas.cd-produto      = base-rat.cd-produto
                                     and   cotas.dt-inicial      = tt-param.dt-periodo-ini)) then DO:
                           if tt-param.util-decimal = no then
                              assign base-cota.qt-prevista = int(base-cota.qt-prevista) + int(base-cota.qt-prevista).
                           else   
                              assign base-cota.qt-prevista = base-cota.qt-prevista + base-cota.qt-prevista.
                       END.

                   end. 
                end.          


             /**************************************************************************/
             /*** OBS.: Nao ha preocupacao aqui com o estab padrao, pois no for each ***/
             /***       do base-rat ja foi filtrado isto                             ***/
             /**************************************************************************/
             find cotas exclusive-lock
                  where cotas.cod-estabel     = base-rat.cod-estabel
                  and   cotas.cod-canal-venda = base-rat.cod-canal-venda
                  and   cotas.cod-gr-cli      = base-rat.cod-gr-cli
                  and   cotas.nome-abrev      = base-rat.nome-abrev
                  and   cotas.nome-ab-reg     = base-rat.nome-ab-reg
                  and   cotas.nome-mic-reg    = base-rat.nome-mic-reg
                  and   cotas.cod-rep         = base-rat.cod-rep
                  and   cotas.cd-produto      = base-rat.cd-produto
                  and   cotas.dt-inicial      = tt-param.dt-periodo-ini no-error.

             if not avail cotas then do:
                create cotas.
                assign cotas.cod-estabel     = base-rat.cod-estabel
                       cotas.cod-canal-venda = base-rat.cod-canal-venda
                       cotas.cod-gr-cli      = base-rat.cod-gr-cli
                       cotas.nome-abrev      = base-rat.nome-abrev
                       cotas.nome-ab-reg     = base-rat.nome-ab-reg
                       cotas.nome-mic-reg    = base-rat.nome-mic-reg
                       cotas.cod-rep         = base-rat.cod-rep
                       cotas.cd-produto      = base-rat.cd-produto
                       cotas.dt-inicial      = tt-param.dt-periodo-ini
                       cotas.dt-final        = tt-param.dt-periodo-fim.
                 {acp/ac9001.i &param-cota=no}.      
                 assign de-prevista = ((base-rat.pct-rateio * de-valor-base) / 100)
                        tt-cotas.prevista = de-prevista
                        tt-cotas.original = tt-cotas.prevista.

             end.
             else do:

                 {acp/ac9001.i &param-cota=no}
                 /********************************************************************/
                 /*** Distribui a qt prevista de acordo com o percentual de rateio ***/
                 /********************************************************************/
                 /*Corre‡Æo Inserida*/
                 assign de-prevista       = ((base-rat.pct-rateio * base-cota.qt-prevista) / 100)
                          tt-cotas.prevista = de-prevista
                          tt-cotas.original = tt-cotas.prevista.
             end.

             /********************************************/
             /******* caso nÆo utilize decimais **********/
             /********************************************/
             if tt-param.util-decimal = no then
                assign tt-cotas.prevista = int(tt-cotas.prevista)
                       tt-cotas.original = int(tt-cotas.original).  
             if tt-param.origem-dados = 3 and
                l-utiliza-base-cota = yes then do:
                find base-cota exclusive-lock
                      where base-cota.cod-estabel = tt-cotas.cod-estabel
                      and   base-cota.cd-produto  = tt-cotas.cd-produto 
                      and   base-cota.dt-inicial  = tt-cotas.dt-inicial no-error.
                if not avail base-cota then do:                   
                   create base-cota.
                   assign base-cota.cod-estabel = tt-cotas.cod-estabel
                          base-cota.cd-produto  = tt-cotas.cd-produto
                          base-cota.cd-produto-dest = tt-cotas.cd-produto
                          base-cota.dt-inicial  = tt-cotas.dt-inicial 
                          base-cota.dt-final    = cotas.dt-final
                          base-cota.qt-prevista = tt-cotas.prevista.
                   IF CAN-FIND (item-cota WHERE
                                item-cota.it-codigo = tt-cotas.cd-produto AND
                                item-cota.log-cota-limite = YES ) THEN
                       ASSIGN base-cota.log-cota-limite = YES.
                end.
                else DO:
                   if tt-param.util-decimal = no then
                      assign base-cota.qt-prevista = int(base-cota.qt-prevista) + int(base-cota.qt-prevista).
                   else   
                      assign base-cota.qt-prevista = base-cota.qt-prevista + base-cota.qt-prevista.
                END.
             end.             

             {acp/ac9001.i &param-cota=yes}.

             if tt-param.atualiza = no then
                assign cotas.qt-original = 0
                       cotas.vl-original = 0.             

          end.

      end. 

      /*run pi-balanceamento. - NÆo poder  ser feito pelos motivos
                              - Se a sele‡Æo desconsiderar alguns registros
                              - Se alguns canais da base de rateio nÆo forem controlados no per¡odo*/
    end.
  end.
end.
&ENDIF
end procedure.


procedure pi-balanceamento.

&IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
        /********************************************************************/
        /*** Faz o balanceamento da Qt Prevista na Cota com o maior valor ***/
        /*** para todos os n¡veis controlados.                            ***/
        /********************************************************************/

   assign de-maior-qt-prev = 0
      de-total-qt-prevista = 0.
   if  par-cota.cont-canal-venda = yes then do:
       {acp/ac1010.i1 &condicao=" and cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
                        and cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim
                        and cotas.cod-canal-venda <> ?
                        and cotas.cod-gr-cli       = (if par-cota.cont-gr-cli  then ? else 0)
                        and cotas.nome-abrev       = (if par-cota.cont-cliente then ? else '')
                        and cotas.nome-ab-reg      = (if par-cota.cont-ab-reg  then ? else '')
                        and cotas.nome-mic-reg     = (if par-cota.cont-mic-reg then ? else '')
                        and cotas.cod-rep          = ? "
                       &quebra="break by cotas.cd-produto"
                       &last="cotas.cd-produto"
                       &cond-base-cota=" 1 = 1 "
                       &cond-cotas=" " }. /* "1 = 1" foi o artif¡cio utilizado para obrigar
                                         a entrada no primeiro "if" */
   end.

   if  par-cota.cont-gr-cli then do:
       {acp/ac1010.i1 &condicao=" and ((cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
                       and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim
                       and   cotas.cod-canal-venda <> ?) 
                        or   cotas.cod-canal-venda  = (if par-cota.cont-canal-venda = no then 0
                                                         else tt-param.cod-canal-venda-ini)) /*Recurso utilizado pela falta de valores para o else*/
                       and   cotas.cod-gr-cli      >= tt-param.cod-gr-cli-ini
                       and   cotas.cod-gr-cli      <= tt-param.cod-gr-cli-fim
                       and   cotas.cod-gr-cli      <> ?
                       and   cotas.nome-abrev       = (if par-cota.cont-cliente then ? else '')
                       and   cotas.nome-ab-reg      = (if par-cota.cont-ab-reg  then ? else '')
                       and   cotas.nome-mic-reg     = (if par-cota.cont-mic-reg then ? else '')
                       and   cotas.cod-rep          = ? "
                      &quebra="break by cotas.cd-produto
                                     by cotas.cod-canal-venda"
                      &last="cotas.cod-canal-venda"
                      &cond-base-cota=" par-cota.cont-canal-venda = no "
                      &cond-cotas=" where b-cotas.cod-estabel = cotas.cod-estabel and
                             b-cotas.cod-canal-venda = cotas.cod-canal-venda and
                             b-cotas.cod-gr-cli = ? and
                             b-cotas.nome-abrev = ? and
                             b-cotas.nome-ab-reg = ? and
                             b-cotas.nome-mic-reg = ? and
                             b-cotas.cod-rep = ? and
                             b-cotas.cd-produto = cotas.cd-produto and
                             b-cotas.dt-inicial = cotas.dt-inicial "}.

   end.

   if  par-cota.cont-cliente then do:
       {acp/ac1010.i1 &condicao=" and ((cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
                        and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim
                        and   cotas.cod-canal-venda <> ?) 
                         or   cotas.cod-canal-venda  = (if par-cota.cont-canal-venda = no then 0
                                                          else tt-param.cod-canal-venda-ini)) /*Recurso utilizado pela falta de valores para o else*/
                        and ((cotas.cod-gr-cli      >= tt-param.cod-gr-cli-ini
                        and   cotas.cod-gr-cli      <= tt-param.cod-gr-cli-fim
                        and   cotas.cod-gr-cli      <> ?) 
                         or   cotas.cod-gr-cli       = (if par-cota.cont-gr-cli = no then 0
                                                          else tt-param.cod-gr-cli-ini)) /*Recurso utilizado pela falta de valores para o else*/
                        and  (cotas.nome-abrev      >= tt-param.nome-abrev-ini
                        and   cotas.nome-abrev      <= tt-param.nome-abrev-fim
                        and   cotas.nome-abrev      <> ?)                       
                        and   cotas.nome-ab-reg  = (if par-cota.cont-ab-reg  then ? else '')
                        and   cotas.nome-mic-reg = (if par-cota.cont-mic-reg then ? else '')
                        and   cotas.cod-rep      = ? "
                       &quebra="break by cotas.cd-produto
                                      by cotas.cod-canal-venda
                                      by cotas.cod-gr-cli"
                       &last="cotas.cod-gr-cli"
                       &cond-base-cota=" par-cota.cont-canal-venda = no and
                        par-cota.cont-gr-cli = no "
                       &cond-cotas=" where b-cotas.cod-estabel = cotas.cod-estabel and
                              b-cotas.cod-canal-venda = cotas.cod-canal-venda and
                              b-cotas.cod-gr-cli = cotas.cod-gr-cli and
                              b-cotas.nome-abrev = ? and
                              b-cotas.nome-ab-reg = ? and
                              b-cotas.nome-mic-reg = ? and
                              b-cotas.cod-rep = ? and
                              b-cotas.cd-produto = cotas.cd-produto and
                              b-cotas.dt-inicial = cotas.dt-inicial "}.

   end.

   if  par-cota.cont-ab-reg then do:
       {acp/ac1010.i1 &condicao=" and ((cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
                        and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim
                        and   cotas.cod-canal-venda <> ?)
                         or   cotas.cod-canal-venda  = (if par-cota.cont-canal-venda = no then 0
                                                          else tt-param.cod-canal-venda-ini)) /*Recurso utilizado pela falta de valores para o else*/
                        and ((cotas.cod-gr-cli      >= tt-param.cod-gr-cli-ini
                        and   cotas.cod-gr-cli      <= tt-param.cod-gr-cli-fim
                        and   cotas.cod-gr-cli      <> ?) 
                         or   cotas.cod-gr-cli       = (if par-cota.cont-gr-cli = no then 0
                                                          else tt-param.cod-gr-cli-ini)) /*Recurso utilizado pela falta de valores para o else*/
                        and ((cotas.nome-abrev      >= tt-param.nome-abrev-ini
                        and   cotas.nome-abrev      <= tt-param.nome-abrev-fim
                        and   cotas.nome-abrev      <> ?)
                         or   cotas.nome-abrev       = (if par-cota.cont-cliente = no then ''
                                                          else tt-param.nome-abrev-ini)) /*Recurso utilizado pela falta de valores para o else*/                     
                        and  (cotas.nome-ab-reg     >= tt-param.nome-ab-reg-ini
                        and   cotas.nome-ab-reg     <= tt-param.nome-ab-reg-fim
                        and   cotas.nome-ab-reg     <> ?)
                        and   cotas.nome-mic-reg = (if par-cota.cont-mic-reg then ? else '')
                        and   cotas.cod-rep      = ? "
                       &quebra="break by cotas.cd-produto
                                      by cotas.cod-canal-venda
                                      by cotas.cod-gr-cli
                                      by cotas.nome-abrev"
                       &last="cotas.nome-abrev"
                       &cond-base-cota=" par-cota.cont-canal-venda = no and
                        par-cota.cont-gr-cli = FALSE and
                        par-cota.cont-cliente = FALSE " /*por causa da tradu‡Æo que estava dando erro no espanhol 2.05*/
                       &cond-cotas=" where b-cotas.cod-estabel = cotas.cod-estabel and
                              b-cotas.cod-canal-venda = cotas.cod-canal-venda and
                              b-cotas.cod-gr-cli = cotas.cod-gr-cli and
                              b-cotas.nome-abrev = cotas.nome-abrev and
                              b-cotas.nome-ab-reg = ? and
                              b-cotas.nome-mic-reg = ? and
                              b-cotas.cod-rep = ? and
                              b-cotas.cd-produto = cotas.cd-produto and
                              b-cotas.dt-inicial = cotas.dt-inicial "}.
   end.
   if  par-cota.cont-mic-reg then do:
       {acp/ac1010.i1 &condicao=" and ((cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
                        and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim
                        and   cotas.cod-canal-venda <> ?)
                         or   cotas.cod-canal-venda  = (if par-cota.cont-canal-venda = no then 0
                                                          else tt-param.cod-canal-venda-ini)) /*Recurso utilizado pela falta de valores para o else*/
                        and ((cotas.cod-gr-cli      >= tt-param.cod-gr-cli-ini
                        and   cotas.cod-gr-cli      <= tt-param.cod-gr-cli-fim
                        and   cotas.cod-gr-cli      <> ?) 
                         or   cotas.cod-gr-cli       = (if par-cota.cont-gr-cli = no then 0
                                                          else tt-param.cod-gr-cli-ini)) /*Recurso utilizado pela falta de valores para o else*/
                        and ((cotas.nome-abrev      >= tt-param.nome-abrev-ini
                        and   cotas.nome-abrev      <= tt-param.nome-abrev-fim
                        and   cotas.nome-abrev      <> ?)
                         or   cotas.nome-abrev       = (if par-cota.cont-cliente = no then ''
                                                          else tt-param.nome-abrev-ini)) /*Recurso utilizado pela falta de valores para o else*/                        
                        and ((cotas.nome-ab-reg     >= tt-param.nome-ab-reg-ini
                        and   cotas.nome-ab-reg     <= tt-param.nome-ab-reg-fim
                        and   cotas.nome-ab-reg     <> ?) 
                         or   cotas.nome-ab-reg      = (if par-cota.cont-ab-reg = no then ''
                                                          else tt-param.nome-ab-reg-ini)) /*Recurso utilizado pela falta de valores para o else*/
                        and  (cotas.nome-mic-reg    >= tt-param.nome-mic-reg-ini
                        and   cotas.nome-mic-reg    <= tt-param.nome-mic-reg-fim
                        and   cotas.nome-mic-reg    <> ?)
                        and   cotas.cod-rep      = ? "
                       &quebra="break by cotas.cd-produto
                                      by cotas.cod-canal-venda
                                      by cotas.cod-gr-cli
                                      by cotas.nome-abrev
                                      by cotas.nome-ab-reg"
                       &last="cotas.nome-ab-reg"
                       &cond-base-cota=" par-cota.cont-canal-venda = no and
                        par-cota.cont-gr-cli = no and
                        par-cota.cont-cliente = no and
                        par-cota.cont-ab-reg = no "
                       &cond-cotas=" where b-cotas.cod-estabel = cotas.cod-estabel and
                              b-cotas.cod-canal-venda = cotas.cod-canal-venda and
                              b-cotas.cod-gr-cli = cotas.cod-gr-cli and
                              b-cotas.nome-abrev = cotas.nome-abrev and
                              b-cotas.nome-ab-reg = cotas.nome-ab-reg and
                              b-cotas.nome-mic-reg = ? and
                              b-cotas.cod-rep = ? and
                              b-cotas.cd-produto = cotas.cd-produto and
                              b-cotas.dt-inicial = cotas.dt-inicial "}.
    end. 

    /* Representante - Sempre Controla */
   {acp/ac1010.i1 &condicao=" and ((cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
               and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim
               and   cotas.cod-canal-venda <> ?) 
                or   cotas.cod-canal-venda  = (if par-cota.cont-canal-venda = no then 0
                                                 else tt-param.cod-canal-venda-ini)) /*Recurso utilizado pela falta de valores para o else*/
               and ((cotas.cod-gr-cli      >= tt-param.cod-gr-cli-ini
               and   cotas.cod-gr-cli      <= tt-param.cod-gr-cli-fim
               and   cotas.cod-gr-cli      <> ?) 
                or   cotas.cod-gr-cli       = (if par-cota.cont-gr-cli = no then 0
                                                 else tt-param.cod-gr-cli-ini)) /*Recurso utilizado pela falta de valores para o else*/
               and ((cotas.nome-abrev      >= tt-param.nome-abrev-ini
               and   cotas.nome-abrev      <= tt-param.nome-abrev-fim
               and   cotas.nome-abrev      <> ?)
                or   cotas.nome-abrev       = (if par-cota.cont-cliente = no then ''
                                                 else tt-param.nome-abrev-ini)) /*Recurso utilizado pela falta de valores para o else*/                        
               and ((cotas.nome-ab-reg     >= tt-param.nome-ab-reg-ini
               and   cotas.nome-ab-reg     <= tt-param.nome-ab-reg-fim
               and   cotas.nome-ab-reg     <> ?) 
                or   cotas.nome-ab-reg      = (if par-cota.cont-ab-reg = no then ''
                                                 else tt-param.nome-ab-reg-ini)) /*Recurso utilizado pela falta de valores para o else*/
               and ((cotas.nome-mic-reg    >= tt-param.nome-mic-reg-ini
               and   cotas.nome-mic-reg    <= tt-param.nome-mic-reg-fim
               and   cotas.nome-mic-reg    <> ?)
                or   cotas.nome-mic-reg     = (if par-cota.cont-mic-reg = no then ''
                                                 else tt-param.nome-mic-reg-ini)) /*Recurso utilizado pela falta de valores para o else*/
               and  (cotas.cod-rep         >= tt-param.cod-rep-ini
               and   cotas.cod-rep         <= tt-param.cod-rep-fim
               and   cotas.cod-rep         <> ?) "
               &quebra="break by cotas.cd-produto
                              by cotas.cod-canal-venda
                              by cotas.cod-gr-cli
                              by cotas.nome-abrev
                              by cotas.nome-ab-reg
                              by cotas.nome-mic-reg"
               &last="cotas.nome-mic-reg"
               &cond-base-cota=" par-cota.cont-canal-venda = no and
                par-cota.cont-gr-cli = no and
                par-cota.cont-cliente = no and
                par-cota.cont-ab-reg = no and
                par-cota.cont-mic-reg = no "
               &cond-cotas=" where b-cotas.cod-estabel = cotas.cod-estabel and
                      b-cotas.cod-canal-venda = cotas.cod-canal-venda and
                      b-cotas.cod-gr-cli = cotas.cod-gr-cli and
                      b-cotas.nome-abrev = cotas.nome-abrev and
                      b-cotas.nome-ab-reg = cotas.nome-ab-reg and
                      b-cotas.nome-mic-reg = cotas.nome-mic-reg and
                      b-cotas.cod-rep = ? and
                      b-cotas.cd-produto = cotas.cd-produto and
                      b-cotas.dt-inicial = cotas.dt-inicial "}
&ENDIF
end procedure.


