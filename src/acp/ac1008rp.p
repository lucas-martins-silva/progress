/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC1008RP 2.00.00.011}  /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac1008rp MAC}
&ENDIF

/*******************************************************************************
**
**   Programa: ac1008rp.p
**   Autor...: Datasul S/A.
**   Objetivo: Rotina para Importaá∆o de Base de Cota  
**   Data....: Julho de 1997
*********************************************************************************/
{utp/ut-glob.i}
/* ********************  Definiá∆o de Temp-Table ****************************** */

/* Temporary Table Definitions ---                                      */

{acp/acapi001.i}
  
define temp-table tt-mensagem
    field cod-estabel      like base-cota.cod-estabel
    field cd-produto       like base-cota.cd-produto
    field dt-inicial       like base-cota.dt-inicial
    field dt-final         like base-cota.dt-final
    field qt-prevista      like base-cota.qt-prevista
    field mensagem         as   character format "x(40)".

define temp-table tt-param
    field destino          as integer
    field arquivo          as character
    field arq-destino      as character
    field arq-entrada      as character format "x(40)"
    field importa          as integer
    field desc-importa     as character format "x(40)"
    field usuario          as character
    field data-exec        as date
    field hora-exec        as integer.
    

def temp-table tt-raw-digita
   field raw-digita      as raw.

/* ************************* Definiá∆o de Buffers **************************** */

define buffer b-tt-dados for tt-dados.

/* ************************ Definiá∆o de parametros ************************** */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

/* ************************ Definiá∆o de Vari†veis ************************** */

{include/i-rpvar.i}        

def var h-acomp         as   handle                                no-undo.
def var c-parametro     as   character format "x(14)"              no-undo.
def var c-impressao     as   character format "x(12)"              no-undo.
def var c-destino       as   character format "x(10)"              no-undo.
def var c-importa       as   character format "x(30)"              no-undo.
def var c-data-liber    as   character format "x(14)"              no-undo.
def var c-data-alter    as   character format "x(14)"              no-undo.
def var c-periodo       as   character format "x(7)"               no-undo.
def var i-reg-lidos     as   integer   format ">>>>>9"  initial 0  no-undo.
def var i-reg-imp       as   integer   format ">>>>>9"  initial 0  no-undo.
def var c-dados         as   character                             no-undo.
def var c-mensagem      as   character format "x(40)"              no-undo.
def var l-grava         as   logical                               no-undo.
def var i-cont-colun    as   integer                               no-undo.
def var l-importa       as   logical initial yes                   no-undo.
def var c-cod-estabel   like base-cota.cod-estabel                 no-undo.
def var c-cd-produto    like base-cota.cd-produto                  no-undo.
def var de-qt-prevista  like base-cota.qt-prevista                 no-undo.
def var da-dt-inicial   like base-cota.dt-inicial                  no-undo.
def var da-dt-final     like base-cota.dt-final                    no-undo.
def var de-qt-pedida    like base-cota.qt-pedida                   no-undo.
def var de-qt-liberada  like base-cota.qt-liberada                 no-undo.
def var da-data-liber   like base-cota.data-liber                  no-undo.
def var da-data-alter   like base-cota.data-alter                  no-undo.
def var de-nr-pontos    like base-cota.nr-pontos                   no-undo.

{cdp/cdcfgdis.i} /*include para prÇ-processadores*/

/* ************************ Definiá∆o de Stream ****************************** */

define stream s-imp.

/* ************************** Definiá∆o de Form ****************************** */

form tt-mensagem.cod-estabel at 01
     tt-mensagem.cd-produto  at 07
     tt-mensagem.dt-inicial  at 24
     tt-mensagem.dt-final    at 35
     tt-mensagem.qt-prevista at 46 column-label "        "
     tt-mensagem.mensagem    at 64
     with down width 132 stream-io no-box frame f-tt-erro.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-tt-erro:HANDLE).


form skip(1)
     i-reg-lidos  colon 35 
     i-reg-imp    colon 35 
     with stream-io side-labels width 120 no-box frame f-contador.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-contador:HANDLE).


form c-cod-estabel  at 01
     c-cd-produto   at 07
     da-dt-inicial  at 24
     da-dt-final    at 35
     de-qt-prevista at 46 column-label "        "
     c-mensagem     at 64
     with down width 132 stream-io no-box frame f-erro.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-erro:HANDLE).


form skip(01)
     c-parametro no-label    skip(1)
     tt-param.desc-importa   colon 40
     tt-param.arq-entrada      colon 40 skip(1)
     c-impressao no-label    skip(1)
     c-destino               colon 40
     " - ":U
     tt-param.arq-destino no-label format "x(60)":U skip
     tt-param.usuario        colon 40 skip
     with down no-box side-labels width 132 stream-io frame f-parametros.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-parametros:HANDLE).

 
/* ****************************** Literais ********************************** */

{utp/ut-liter.i Lidos * R}
assign i-reg-lidos:label in frame f-contador = return-value.

{utp/ut-liter.i Importados * R}
assign i-reg-imp:label in frame f-contador = return-value.

{utp/ut-liter.i PAR∂METROS * R}
assign c-parametro = trim(return-value).

{utp/ut-liter.i IMPRESS«O * R}
assign c-impressao = trim(return-value).

{utp/ut-liter.i Destino * L}
assign c-destino:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Usu†rio * L}
assign tt-param.usuario:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Importa_para * L}
assign tt-param.desc-importa:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Arquivo_Entrada * L}
assign tt-param.arq-entrada:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Importando_Base_Cota MCT C}
assign c-importa = trim(return-value).

{utp/ut-liter.i Importaá∆o_Base_Cota MCT C}  
assign c-titulo-relat = return-value.

{utp/ut-field.i mgdis base-cota cod-estabel 2}  
assign c-cod-estabel:label in frame f-erro = return-value.

{utp/ut-field.i mgdis base-cota cd-produto 2}  
assign c-cd-produto:label in frame f-erro = return-value.

{utp/ut-liter.i Mensagem * L}  
assign c-mensagem:label in frame f-erro = return-value.

{utp/ut-liter.i Dt_Inicial * L}  
assign da-dt-inicial:label in frame f-erro = return-value.

{utp/ut-liter.i Dt_Final * L}  
assign da-dt-final:label in frame f-erro = return-value.

{utp/ut-field.i mgdis base-cota qt-prevista 1}  
assign de-qt-prevista:label in frame f-erro = return-value.

{utp/ut-field.i mgdis base-cota cd-produto 1}  
assign tt-mensagem.cd-produto:label in frame f-tt-erro = return-value.

{utp/ut-liter.i Mensagem * L}  
assign tt-mensagem.mensagem:label in frame f-tt-erro = return-value.

{utp/ut-liter.i Dt_Inicial * L}
assign tt-mensagem.dt-inicial:label in frame f-tt-erro = return-value.

{utp/ut-liter.i Dt_Final * L}
assign tt-mensagem.dt-final:label in frame f-tt-erro = return-value.

{utp/ut-field.i mgdis base-cota qt-prevista 1}  
assign tt-mensagem.qt-prevista:label in frame f-tt-erro = return-value.

{utp/ut-field.i mgdis base-cota cod-estabel 2}  
assign tt-mensagem.cod-estabel:label in frame f-tt-erro = return-value.

/* ************************************************************************* */
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param.
find empresa 
     where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.

{utp/ut-liter.i Base_Cota MCT L}                 
assign c-programa = "AC/1008"
       c-empresa  = empresa.razao-social
       c-sistema  = return-value
       c-destino  = {varinc/var00002.i 04 tt-param.destino}
       i-reg-lidos  = 0
       i-reg-imp    = 0.

{include/i-rpout.i &tofile=tt-param.arq-destino}

view frame f-cabec.
view frame f-rodape.

run utp/ut-acomp.p persistent set h-acomp.  
run pi-inicializar in h-acomp (input c-importa).         

if tt-param.importa = 1 then 
   run pi-importa-arquivo.
else 
   run pi-importa-excel.
   
run pi-finalizar in h-acomp. 

display i-reg-lidos
        i-reg-imp with frame f-contador.
down with frame f-contador.      

/* **************** Impress∆o da p†gina de parÉmetros ************* */


if  page-number > 0 then page.
display c-parametro
        tt-param.desc-importa
        tt-param.arq-entrada
        c-impressao
        c-destino
        tt-param.arq-destino        
        tt-param.usuario
        with frame f-parametros.

{include/i-rpclo.i}
input stream s-imp close.

Return "OK".
/*fim-do-programa*/


/* ************************** Procedure Interna *************************** */

PROCEDURE PI-IMPORTA-ARQUIVO:

    input stream s-imp from value(tt-param.arq-entrada).
    repeat on error undo, leave
        on stop undo, leave transaction:
        assign c-dados = " ".
        import stream s-imp unformatted c-dados.
        if c-dados = " " then
           leave.
    
        assign i-reg-lidos    = i-reg-lidos + 1
               &IF "{&mguni_version}" < "2.071" &THEN
               c-cod-estabel  = trim(substr(c-dados,1,3))
               &ENDIF
               c-cd-produto   = trim(substr(c-dados,4,16))
               da-dt-inicial  = date(substring(c-dados,20,8))
               da-dt-final    = date(substring(c-dados,28,8))               
               de-qt-prevista = (decimal(substr(c-dados,36,12))) / 100
               de-qt-pedida   = (decimal(substr(c-dados,48,12))) / 100
               de-qt-liberada = (decimal(substr(c-dados,60,12))) / 100
               da-data-liber  = date(substr(c-dados,72,8))
               da-data-alter  = date(substr(c-dados,80,8))
               de-nr-pontos   = decimal(substr(c-dados,88,5)) / 100
               l-grava        = yes
               &IF "{&mguni_version}" >= "2.071" &THEN
               c-cod-estabel  = trim(substr(c-dados,93,5))
               &ENDIF
               .

        /* ************** Validaá‰es *******/

        find estabelec no-lock 
             where estabelec.cod-estabel = c-cod-estabel no-error.
        if not avail estabelec then do:
           assign l-grava = no.
           {utp/ut-liter.i Estabelecimento_n∆o_cadastrado * L}
           assign c-mensagem = return-value.
           disp c-cod-estabel
                c-cd-produto
                da-dt-inicial
                da-dt-final
                de-qt-prevista
                c-mensagem
                with frame f-erro.
           down with frame f-erro.
        end.
        
        /***
         *Validaá∆o Produto/Item
         ***/
        if can-find(first item-cota no-lock
                    where item-cota.it-codigo = c-cd-produto) then do:
            find item-cota
                where item-cota.it-codigo = c-cd-produto no-lock no-error.
            if avail item-cota and
                     item-cota.log-produto = yes then do:
            &if defined (bf_dis_adm_cotas) &then /* INICIO PREPROCESSADOR */
                 if not can-find(first produto-coml no-lock where 
                                       produto-coml.cod-produto-coml = c-cd-produto) then do: 
            &else
                 if not can-find(first produto no-lock where 
                                       produto.cd-produto = c-cd-produto) then do:
            &endif 
                     assign l-grava = no.
                    {utp/ut-liter.i Produto_n∆o_cadastrado_para_este_item * L}
                    assign c-mensagem = return-value.
                    disp c-cod-estabel
                         c-cd-produto
                         da-dt-inicial    
                         da-dt-final
                         de-qt-prevista
                         c-mensagem
                         with frame f-erro.
                    down with frame f-erro.     
                 end.
            end.
        end.
        else do:
            &if defined (bf_dis_adm_cotas) &then /* INICIO PREPROCESSADOR */
                if not can-find(first produto-coml no-lock
                                where produto-coml.cod-produto-coml = c-cd-produto) then do:
            &else
                if not can-find(first produto no-lock
                                where produto.cd-produto = c-cd-produto) then do:
            &endif
                    assign l-grava = no.
                    {utp/ut-liter.i Produto/Item_n∆o_cadastrado * L}
                    assign c-mensagem = return-value.
                    disp c-cod-estabel
                         c-cd-produto
                         da-dt-inicial    
                         da-dt-final
                         de-qt-prevista
                         c-mensagem
                         with frame f-erro.
                    down with frame f-erro.     
               end.
        end.
    
        if da-dt-inicial = ? then do:
           assign l-grava = no.
           {utp/ut-liter.i Per°odo_inv†lido * L}
           assign c-mensagem = return-value.
           disp c-cod-estabel
                c-cd-produto
                da-dt-inicial
                da-dt-final
                de-qt-prevista
                c-mensagem
                with frame f-erro.
           down with frame f-erro.     
        end.       
    
        if da-dt-final = ? then do:
           assign l-grava = no.
           {utp/ut-liter.i Per°odo_inv†lido * L}
           assign c-mensagem = return-value.
           disp c-cod-estabel
                c-cd-produto
                da-dt-inicial
                da-dt-final
                de-qt-prevista
                c-mensagem
                with frame f-erro.
           down with frame f-erro.     
        end.    

        if  da-dt-inicial > da-dt-final then do:
           assign l-grava = no.
           {utp/ut-liter.i Data_Inicial_maior_que_Data_Final * L}
           assign c-mensagem = return-value.
           disp c-cod-estabel
                c-cd-produto
                da-dt-inicial
                da-dt-final
                de-qt-prevista
                c-mensagem
                with frame f-erro.
           down with frame f-erro.     
        end.       

        if de-qt-prevista = 0 then do:
           assign l-grava = no.
           {utp/ut-liter.i Quantidade_Prevista_n∆o_pode_ser_zero * L}
           assign c-mensagem = return-value.
           disp c-cod-estabel
                c-cd-produto
                da-dt-inicial
                da-dt-final
                de-qt-prevista
                c-mensagem
                with frame f-erro.
           down with frame f-erro.     
        end.    
        
        if l-grava then do: 
           find base-cota exclusive-lock
                where base-cota.cod-estabel = c-cod-estabel
                and   base-cota.cd-produto  = c-cd-produto
                and   base-cota.dt-inicial  = da-dt-inicial no-error.
           if not avail base-cota  then do:
              create base-cota.
              assign base-cota.cod-estabel = c-cod-estabel
                     base-cota.cd-produto  = c-cd-produto
                     base-cota.dt-inicial  = da-dt-inicial
                     base-cota.dt-final    = da-dt-final
                     base-cota.qt-prevista = de-qt-prevista
                     base-cota.qt-pedida   = de-qt-pedida
                     base-cota.qt-liberada = de-qt-liberada
                     base-cota.data-liber  = da-data-liber
                     base-cota.data-alter  = da-data-alter
                     base-cota.nr-pontos   = de-nr-pontos
                     base-cota.log-consid-cotas = if can-find (item-cota
                                                                  where item-cota.it-codigo = base-cota.cd-produto and
                                                                        item-cota.log-consid-cotas) then yes else no
                     &if defined(bf_dis_adm_cotas) &then
                            base-cota.cd-produto-dest  = base-cota.cd-produto
                            base-cota.log-cota-limite  = if can-find (item-cota
                                                                         where item-cota.it-codigo = base-cota.cd-produto and
                                                                               item-cota.log-cota-limite) then yes else no
                     &endif
                     i-reg-imp = i-reg-imp + 1.
           end.           
           else do:
                {utp/ut-liter.i Registro_j†_existente * L}
                assign c-mensagem = return-value.
                disp c-cod-estabel
                     c-cd-produto
                     da-dt-inicial
                     da-dt-final
                     de-qt-prevista
                     c-mensagem
                     with frame f-erro.
                down with frame f-erro.     
           end.      


        end.

        assign c-cod-estabel  = " "
               c-cd-produto   = " "
               da-dt-inicial  = ?
               da-dt-final    = ?
               de-qt-prevista = 0
               de-qt-pedida   = 0
               de-qt-liberada = 0
               da-data-liber  = ?
               da-data-alter  = ?
               de-nr-pontos   = 0.
    end.    
    
END PROCEDURE.

PROCEDURE PI-IMPORTA-EXCEL:
      
  find first tt-param no-error.
  
  create tt-configuracao.
  assign tt-configuracao.versao-integracao = 1
         tt-configuracao.arquivo           = tt-param.arq-entrada
         tt-configuracao.planilha          = 1
         tt-configuracao.linha-inicio      = 6
         tt-configuracao.coluna-inicio     = 1
         tt-configuracao.coluna-final      = 11.
         

   
  run acp/acapi001.p (input  table tt-configuracao,
                      output table tt-dados,
                      output table tt-erros).
 
  for each tt-dados
      where tt-dados.valor <> ""
      break by tt-dados.celula-linha
            by tt-dados.celula-coluna:
  
      if first-of(tt-dados.celula-linha) then
         assign l-importa = yes
                i-reg-lidos = i-reg-lidos + 1.
                
      if tt-dados.celula-coluna = 1 then do:
         find estabelec no-lock
              where estabelec.cod-estabel =  tt-dados.valor no-error.
         if not avail estabelec then do:
            {utp/ut-liter.i Estabelecimento_n∆o_Cadastrado * L}
            run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                   input return-value).
            assign l-importa = no.
         end.
         assign c-cod-estabel = tt-dados.valor.
      end. 

      /***
       *Validaá∆o Produto/Item
       ***/
      if tt-dados.celula-coluna = 2 then do:
          if can-find(first item-cota no-lock
                      where item-cota.it-codigo = tt-dados.valor) then do:
              find item-cota
                  where item-cota.it-codigo = tt-dados.valor no-lock no-error.
              if avail item-cota and
                       item-cota.log-produto = yes then do:
              &if defined (bf_dis_adm_cotas) &then /* INICIO PREPROCESSADOR */
                   if not can-find(first produto-coml no-lock where 
                                         produto-coml.cod-produto-coml = tt-dados.valor) then do: 
              &else
                   if not can-find(first produto no-lock where 
                                         produto.cd-produto = tt-dados.valor) then do:
              &endif 

                      {utp/ut-liter.i Produto_n∆o_cadastrado_para_este_item * L}
                      run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                             input return-value).
                      assign l-importa = no.
                   end.
              end.
          end.
          else do:
              &if defined (bf_dis_adm_cotas) &then /* INICIO PREPROCESSADOR */
                  if not can-find(first produto-coml no-lock
                                  where produto-coml.cod-produto-coml = tt-dados.valor) then do:
              &else
                  if not can-find(first produto no-lock
                                  where produto.cd-produto = tt-dados.valor) then do:
              &endif
                      {utp/ut-liter.i Produto/Item_n∆o_Cadastrado * L}
                      run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                             input return-value).
                      assign l-importa = no.
                 end.
          end.
          assign c-cd-produto = tt-dados.valor.
      end. 

      if tt-dados.celula-coluna = 4 then do:
         if tt-dados.valor = "" then do:
            {utp/ut-liter.i Data_Invalida * L}
            run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                   input return-value).
            assign l-importa = no.
         end.
         assign da-dt-inicial = date(tt-dados.valor).
      end. 

      if tt-dados.celula-coluna = 5 then do:
         if tt-dados.valor = "" then do:
            {utp/ut-liter.i Data_Invalida * L}
            run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                   input return-value).
            assign l-importa = no.
          end.
          else if date(tt-dados.valor) < da-dt-inicial then do:
              run utp/ut-msgs.p (input "msg",input 198, input "").
              run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                     input return-value).
              assign l-importa = no.
          end.
          assign da-dt-final = date(tt-dados.valor).
      end. 

      if tt-dados.celula-coluna = 6 then do:
         if tt-dados.valor = "0,00" then do:
            {utp/ut-liter.i Prevista_Inv†lida * L}
            run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                   input return-value).
            assign l-importa = no.
          end.
          assign de-qt-prevista = decimal(tt-dados.valor).
      end. 

      if tt-dados.celula-coluna = 7 then
         assign de-qt-pedida = decimal(tt-dados.valor).
      
      if tt-dados.celula-coluna = 8 then
         assign de-qt-liberada = decimal(tt-dados.valor).

      if tt-dados.celula-coluna = 9 then
         assign da-data-liber = date(tt-dados.valor).

      if tt-dados.celula-coluna = 10 then
         assign da-data-alter = date(tt-dados.valor).

      if tt-dados.celula-coluna = 11 then
         assign de-nr-pontos = decimal(tt-dados.valor).

      if last-of(tt-dados.celula-linha) and l-importa then do:
         find base-cota exclusive-lock
              where base-cota.cod-estabel = c-cod-estabel
              and   base-cota.cd-produto  = c-cd-produto
              and   base-cota.dt-inicial  = da-dt-inicial no-error.
         if not avail base-cota then do:
            create base-cota.
            assign base-cota.cod-estabel = c-cod-estabel
                   base-cota.cd-produto  = c-cd-produto
                   base-cota.dt-inicial  = da-dt-inicial
                   base-cota.dt-final    = da-dt-final
                   base-cota.qt-prevista = de-qt-prevista
                   base-cota.qt-pedida   = de-qt-pedida  
                   base-cota.qt-liberada = de-qt-liberada
                   base-cota.data-liber  = da-data-liber
                   base-cota.data-alter  = da-data-alter
                   base-cota.nr-pontos   = de-nr-pontos
                   base-cota.log-consid-cotas = if can-find (item-cota
                                                                where item-cota.it-codigo = base-cota.cd-produto and
                                                                      item-cota.log-consid-cotas) then yes else no
                   &if defined(bf_dis_adm_cotas) &then
                          base-cota.cd-produto-dest  = base-cota.cd-produto
                          base-cota.log-cota-limite  = if can-find (item-cota
                                                                       where item-cota.it-codigo = base-cota.cd-produto and
                                                                             item-cota.log-cota-limite) then yes else no
                   &endif
                   i-reg-imp = i-reg-imp + 1.
         end.
         else do:
              {utp/ut-liter.i Registro_j†_existente * L}
              run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                     input return-value).
         end.      

         assign c-cod-estabel  = " "
                c-cd-produto   = " "
                da-dt-inicial  = ?
                da-dt-final    = ?
                de-qt-prevista = 0
                de-qt-pedida   = 0
                de-qt-liberada = 0
                da-data-liber  = ?
                da-data-alter  = ?
                de-nr-pontos   = 0.

      end.
  end.
  
  /* Impress∆o das mensagens*/
  for each tt-mensagem:
      disp tt-mensagem.cod-estabel
           tt-mensagem.cd-produto 
           tt-mensagem.dt-inicial 
           tt-mensagem.dt-final
           tt-mensagem.qt-prevista 
           tt-mensagem.mensagem    
           with frame f-tt-erro.
      down with frame f-tt-erro.    
  end.

END PROCEDURE.

PROCEDURE PI-GRAVA-MENSAGEM:

   define input parameter i-linha as integer.
   define input parameter c-mens  as char.
   create tt-mensagem.
   for each b-tt-dados
       where b-tt-dados.celula-linha = i-linha:
       if b-tt-dados.celula-coluna = 1 then
          assign tt-mensagem.cod-estabel  = b-tt-dados.valor.
       if b-tt-dados.celula-coluna = 2 then
          assign tt-mensagem.cd-produto   = b-tt-dados.valor.
       if b-tt-dados.celula-coluna = 4  then
          assign tt-mensagem.dt-inicial   = date(b-tt-dados.valor).
       if b-tt-dados.celula-coluna = 5  then
          assign tt-mensagem.dt-final   = date(b-tt-dados.valor).
       if b-tt-dados.celula-coluna = 6 then
          assign tt-mensagem.qt-prevista  = decimal(b-tt-dados.valor).
   end.
   assign tt-mensagem.mensagem = c-mens.
   
END PROCEDURE.
