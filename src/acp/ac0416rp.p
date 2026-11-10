/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0416RP 2.00.00.014 } /*** 010014 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ac0416rp MAC}
&ENDIF

/*******************************************************************************
**
** Ac0416RP.P : ImpressÆo do relat¢rio de Cotas
**
********************************************************************************/
{utp/ut-glob.i}
/* ************************ Defini‡Æo de vari veis *************************** */

{include/i-rpvar.i}

/* Include pre-processadores */
{cdp/cdcfgdis.i}

def var c-selecao        as char format "x(11)"              no-undo.
def var c-parametro      as char format "x(14)"              no-undo.
def var c-impressao      as char format "x(12)"              no-undo.
def var c-destino        as char format "x(10)"              no-undo.
def var h-acomp          as handle                           no-undo.
def var de-tot-original  like cotas.qt-original              no-undo.
def var de-tot-prevista  like cotas.qt-prevista              no-undo.
def var de-tot-pedida    like cotas.qt-pedida                no-undo.
def var de-tot-faturada  like cotas.qt-faturada              no-undo.
def var de-original      like cotas.qt-original              no-undo.
def var de-prevista      like cotas.qt-prevista              no-undo.
def var de-pedida        like cotas.qt-pedida                no-undo.
def var de-faturada      like cotas.qt-faturada              no-undo.
def var c-un-medida      as char format "x(15)"              no-undo.
def var c-nome-abrev     like emitente.nome-abrev            no-undo.
DEF VAR c-desc-produto   LIKE ITEM.desc-item                 NO-UNDO.
DEF VAR c-un             LIKE ITEM.un                        NO-UNDO.

/* ********************  Defini‡Æo de Temp-Table ****************************** */

def temp-table tt-raw-digita
   field raw-digita      as raw.

/* Defini‡Æo da Temp-table tt-param */
define temp-table tt-param
    field destino              as integer
    field arquivo              as char
    field usuario              as char format "x(12)"
    field data-exec            as date
    field hora-exec            as integer
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
    field dt-inicial           like cotas.dt-inicial
    field dt-final             like cotas.dt-inicial
    field l-matriz             as logical
    field l-cancelados         as logical
    field l-suspensos          as logical
    field l-reprovados         as logical.

/* ************************ Defini‡Æo de parametros ************************** */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

/* *********** Defini‡Æo do layout da p gina de parƒmetros ****************** */

form skip(01)
     c-selecao                      no-label    skip(1)
     tt-param.cod-estab-ini            colon 40 space(12) "|< >|"
     tt-param.cod-estab-fim         no-label colon 73 skip
     tt-param.cod-canal-venda-ini      colon 40 space(14) "|< >|"
     tt-param.cod-canal-venda-fim   no-label colon 73 skip
     tt-param.cod-gr-cli-ini           colon 40 space(13) "|< >|"
     tt-param.cod-gr-cli-fim        no-label colon 73 skip
     tt-param.nome-abrev-ini           colon 40 space(5)  "|< >|"
     tt-param.nome-abrev-fim        no-label colon 73 skip     
     tt-param.nome-ab-reg-ini          colon 40 space(05) "|< >|"
     tt-param.nome-ab-reg-fim       no-label colon 73 skip
     tt-param.nome-mic-reg-ini         colon 40 space(05) "|< >|"
     tt-param.nome-mic-reg-fim      no-label colon 73 skip
     tt-param.cod-rep-ini              colon 40 space(12) "|< >|"
     tt-param.cod-rep-fim           no-label colon 73 skip
     tt-param.cd-produto-ini           colon 40 space(1)  "|< >|"
     tt-param.cd-produto-fim        no-label colon 73 skip
     tt-param.dt-inicial               colon 40 space(7)  "|< >|"
     tt-param.dt-final              no-label colon 73 skip(1)     

     c-parametro                    no-label    skip(1)
     tt-param.l-matriz                 colon 40 skip
     tt-param.l-cancelados             colon 40 skip
     tt-param.l-suspensos              colon 40 
     /**************** USO DE PRE-PROCESSADOR *********************/
     &IF DEFINED (bf_dis_adm_cotas) &THEN          
         tt-param.l-reprovados         colon 40  
     &ENDIF
     skip(1) 
     c-impressao                    no-label    skip(1)
     c-destino                         colon 40
     " - ":U
     tt-param.arquivo               no-label format "x(60)":U skip
     tt-param.usuario                  colon 40 skip(1)

     with down no-box side-labels width 132 stream-io frame f-parametros.

form skip(2)
     cotas.cod-estabel colon 20 " - " 
     estabelec.nome    no-label
     c-un-medida       colon 100 skip
     c-nome-abrev      colon 20  skip(1)

     with  side-labels down width 132 stream-io frame f-tit.

form "-----------------" colon 38 
     "-----------------"  
     "-----------------"   
     "-----------------"    
     "TOTAL"             colon 10
     de-tot-original     colon 38
     de-tot-prevista 
     de-tot-pedida   
     de-tot-faturada format "->>>>,>>>,>>9.9999" 
     with  no-labels  width 132 stream-io frame f-total.

form cotas.cd-produto 
     c-desc-produto COLUMN-LABEL "                  " FORMAT "x(18)"
     c-un                                             FORMAT "x(02)"
     de-original column-label "          "
     de-prevista column-label "          "
     de-pedida   column-label "          "
     de-faturada column-label "          " format "->>>>,>>>,>>9.9999"
     with  down width 132 stream-io frame f-imp.

/* *********************** Defini‡Æo de literais  ***************************** */

{utp/ut-field.i mgdis par-cota tipo-controle 1}
assign c-un-medida:label in frame f-tit = trim(return-value).

{utp/ut-liter.i Original MAC c} 
assign de-original:label in frame f-imp = trim(return-value). 

{utp/ut-liter.i Previsto MAC c} 
assign de-prevista:label in frame f-imp = trim(return-value). 

{utp/ut-liter.i Pedido MAC c} 
assign de-pedida:label in frame f-imp = trim(return-value). 

{utp/ut-liter.i Faturado MAC c} 
assign de-faturada:label in frame f-imp = trim(return-value). 

{utp/ut-liter.i Descri‡Æo MAC L}
assign c-desc-produto:label in frame f-imp = trim(return-value).

{utp/ut-liter.i Produto/Item * R}
assign cotas.cd-produto:LABEL IN FRAM f-imp = trim(return-value).

{utp/ut-liter.i Produto/Item * R}
assign tt-param.cd-produto-ini:LABEL IN FRAM f-parametros = trim(return-value).

{utp/ut-liter.i SELE€ÇO * R}
assign c-selecao = trim(return-value).

{utp/ut-liter.i PAR¶METROS * R}
assign c-parametro = trim(return-value).

{utp/ut-liter.i Consolida_Matriz * L}
assign tt-param.l-matriz:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Considera_Cancelados * L}
assign tt-param.l-cancelados:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Considera_Suspensos * L}
assign tt-param.l-suspensos:label in frame f-parametros = trim(return-value).

/**************** USO DE PRE-PROCESSADOR *********************/
&IF DEFINED (bf_dis_adm_cotas) &THEN          
  {utp/ut-liter.i Considera_Reprovados * L}
  assign tt-param.l-reprovados:label in frame f-parametros = trim(return-value).
&ENDIF

{utp/ut-liter.i IMPRESSÇO * R}
assign c-impressao = trim(return-value).
{utp/ut-liter.i Destino * L}
assign c-destino:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Usu rio * L}
assign tt-param.usuario:label in frame f-parametros = trim(return-value).

/* ************************ Inicio do programa ****************************** */

run utp/ut-trfrrp.p (input frame f-imp:handle).
run utp/ut-trfrrp.p (input frame f-total:handle).
run utp/ut-trfrrp.p (input frame f-tit:handle).
run utp/ut-trfrrp.p (input frame f-parametros:handle).
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.

run utp/ut-acomp.p persistent set h-acomp.

find empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
if avail empresa then
   assign c-empresa = empresa.razao-social.


assign c-programa = 'AC0416'
       c-destino  = {varinc/var00002.i 04 tt-param.destino}.

{utp/ut-liter.i Relat¢rio_Cotas_Realizadas_por_Cliente MAP C}
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

    for each cotas no-lock use-index periodo
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
        and    (cotas.cod-rep         >= tt-param.cod-rep-ini
          and   cotas.cod-rep         <= tt-param.cod-rep-fim
          and   cotas.cod-rep         <> ? )
        and     cotas.cd-produto      >= tt-param.cd-produto-ini
          and   cotas.cd-produto      <= tt-param.cd-produto-fim
        and   cotas.dt-inicial        >= tt-param.dt-inicial
          and cotas.dt-inicial        <= tt-param.dt-final
        break by cotas.cod-estabel
              by cotas.nome-abrev
              by cotas.cd-produto:

        run pi-acompanhar in h-acomp (input cotas.cd-produto).

        find first par-cota where
                   par-cota.cod-estabel = cotas.cod-estabel no-lock no-error.
        if not avail par-cota then next. 

        /****** Quebra por Cliente **********************************/ 

        if first-of(cotas.nome-abrev) then do:
           find estabelec where
                estabelec.cod-estabel = cotas.cod-estabel no-lock no-error.
           if par-cota.cont-cliente then
              find emitente where 
                   emitente.nome-abrev = cotas.nome-abrev no-lock no-error.
           if tt-param.l-matriz then /*consolida matriz*/
              assign c-nome-abrev = if avail emitente then emitente.nome-matriz else "".
           else 
              assign c-nome-abrev = if avail emitente then emitente.nome-abrev else "".   

           disp cotas.cod-estabel
                estabelec.nome
                {diinc/i04di257.i 04 par-cota.tipo-controle} @ c-un-medida
                c-nome-abrev 
                with frame f-tit.
        end. /*if first-of*/     

        /************* Calculo Valores acumulando os itens produtos *******/ 

        if par-cota.tipo-controle = 2 then do: /*controle por valor*/
           assign de-original = de-original + cotas.vl-original 
                  de-prevista = de-prevista + cotas.vl-previsto
                  de-pedida   = de-pedida   + cotas.vl-pedido 
                  de-faturada = de-faturada + cotas.vl-faturado.             
           if tt-param.l-cancelados then /*considera cancelados*/
              assign de-pedida   = de-pedida   + cotas.vl-ped-canc
                     de-faturada = de-faturada + cotas.vl-fat-canc. 
           if tt-param.l-suspensos then /*considera suspensos*/
              assign de-pedida   = de-pedida - cotas.vl-ped-susp.

           /**************** USO DE PRE-PROCESSADOR *********************/
           &IF DEFINED (bf_dis_adm_cotas) &THEN          
               if tt-param.l-reprovados then /*considera reprovados*/
                  assign de-pedida   = de-pedida - cotas.vl-ped-reprov.
           &ENDIF       

        end.
        else do: /*controle por qtde ou pontos*/
           assign de-original = de-original + cotas.qt-original
                  de-prevista = de-prevista + cotas.qt-prevista
                  de-pedida   = de-pedida   + cotas.qt-pedida  
                  de-faturada = de-faturada + cotas.qt-faturada.
           if tt-param.l-cancelados then /*considera cancelados*/
              assign de-pedida   = de-pedida   + cotas.qt-ped-canc
                     de-faturada = de-faturada + cotas.qt-fat-canc. 
           if tt-param.l-suspensos then /*considera suspensos*/
              assign de-pedida   = de-pedida - cotas.qt-ped-susp.          
           /**************** USO DE PRE-PROCESSADOR *********************/
           &IF DEFINED (bf_dis_adm_cotas) &THEN          
               if tt-param.l-reprovados then /*considera reprovados*/
                  assign de-pedida   = de-pedida - cotas.qt-ped-reprov.
           &ENDIF                     
        end.

        /********** Quebra de item/produto *****************/ 

        if last-of(cotas.cd-produto) then do:

           &if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */
               find first produto-coml no-lock where
                          produto-coml.cod-produto-coml = cotas.cd-produto no-error.
               if avail produto-coml then 
                  assign c-desc-produto = produto-coml.des-produto-coml
                         c-un           = produto-coml.un. 
               if not avail produto-coml then do:
           &else
               find first produto no-lock where
                          produto.cd-produto = cotas.cd-produto no-error.
               if avail produto then 
                  assign c-desc-produto = produto.descricao
                         c-un           = produto.un. 
               if not avail produto then do:
           &endif
                  for first item fields(desc-item un) no-lock where
                            item.it-codigo = cotas.cd-produto :
                      assign c-desc-produto = item.desc-item
                             c-un           = ITEM.un.
                  end.
               end.   

           if de-original < 0 then de-original = 0.
           if de-prevista < 0 then de-prevista = 0.
           if de-pedida   < 0 then de-pedida   = 0.
           assign de-tot-original = de-tot-original + de-original
                  de-tot-prevista = de-tot-prevista + de-prevista
                  de-tot-pedida   = de-tot-pedida   + de-pedida
                  de-tot-faturada = de-tot-faturada + de-faturada.

           disp cotas.cd-produto
                c-desc-produto
                c-un
                de-original 
                de-prevista 
                de-pedida   
                de-faturada                 
                with frame f-imp.
           down with frame f-imp.

           assign de-original = 0
                  de-prevista = 0
                  de-pedida   = 0
                  de-faturada = 0.
        end. /*if last-of*/

        /************** ImpressÆo Valores Totais *************/ 

        if last-of(cotas.nome-abrev) then do:
           disp de-tot-original 
                de-tot-prevista 
                de-tot-pedida   
                de-tot-faturada
                with frame f-total. 

           assign de-tot-original = 0
                  de-tot-prevista = 0
                  de-tot-pedida   = 0
                  de-tot-faturada = 0 .           
        end.    

    end. /* for each cotas*/      


end.

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
        tt-param.dt-inicial
        tt-param.dt-final
        c-parametro
        c-impressao
        c-destino
        tt-param.arquivo
        tt-param.usuario
        with stream-io frame f-parametros.

  if  tt-param.l-matriz = yes then  
      {utp/ut-liter.i Sim * R} 
  else 
      {utp/ut-liter.i NÆo * R}.
  disp trim(return-value) @ tt-param.l-matriz 
       with stream-io frame f-parametros.

  if  tt-param.l-cancelados = yes then  
      {utp/ut-liter.i Sim * R} 
  else 
      {utp/ut-liter.i NÆo * R}.
  disp trim(return-value) @ tt-param.l-cancelados 
       with stream-io frame f-parametros.

  if  tt-param.l-suspensos = yes then  
      {utp/ut-liter.i Sim * R} 
  else 
      {utp/ut-liter.i NÆo * R}.
  disp trim(return-value) @ tt-param.l-suspensos 
       with stream-io frame f-parametros.

  /**************** USO DE PRE-PROCESSADOR *********************/
  &IF DEFINED (bf_dis_adm_cotas) &THEN          
    if  tt-param.l-reprovados = yes then  
        {utp/ut-liter.i Sim * R} 
    else 
        {utp/ut-liter.i NÆo * R}.
    disp trim(return-value) @ tt-param.l-reprovados 
         with stream-io frame f-parametros.
  &ENDIF       


run pi-finalizar in h-acomp.
{include/i-rpclo.i}
RETURN "OK".


/* Fim do Programa */


