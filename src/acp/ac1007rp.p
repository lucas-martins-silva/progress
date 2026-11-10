/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC1007RP 2.00.00.031 } /*** 010031 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac1007rp MAC}
&ENDIF

/*******************************************************************************
**
**   Programa: ac1007rp.p
**   Autor...: Datasul S/A.
**   Objetivo: Rotina para Importaá∆o de Cotas  
**   Data....: Julho de 1997
*********************************************************************************/
{utp/ut-glob.i}
/* ********************  Definiá∆o de Temp-Table ****************************** */

/* Temporary Table Definitions ---                                      */

  /* Include com definiá‰es das temp-tables */   
  {acp/acapi001.i}

  /* include com definiá‰es das temp-tables da api cotas*/
  {acp/acapi006.i}  

  /* include com definiá∆o pre-processadores */
  {cdp/cdcfgdis.i}

define temp-table tt-mensagem NO-UNDO
    field cod-estabel      like cotas.cod-estabel
    field cod-canal-venda  like cotas.cod-canal-venda
    field cod-gr-cli       like cotas.cod-gr-cli
    field nome-abrev       like cotas.nome-abrev
    field nome-ab-reg      like cotas.nome-ab-reg
    field nome-mic-reg     like cotas.nome-mic-reg
    field cod-rep          like cotas.cod-rep
    field cd-produto       like cotas.cd-produto
    field dt-inicial       like cotas.dt-inicial format 99/99/99
    field dt-final         like cotas.dt-final
    field qt-prevista      as   decimal format "->>>>>>>,>>9.9999"
    field mensagem         as   character format "x(43)"
    index codigo           cod-estabel
                           cod-rep.

define temp-table tt-param
    field destino          as integer
    field arq-destino      as character
    field arquivo          as character
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

def var h-acomp            as handle                              no-undo.
def var c-parametro        as character format "x(14)"            no-undo.
def var c-impressao        as character format "x(12)"            no-undo.
def var c-destino          as character format "x(10)"            no-undo.
def var c-importa          as character format "x(30)"            no-undo.
def var c-produto          as character format "x(13)"            no-undo.
def var c-previsto         as character format "x(8)"             no-undo.
def var i-reg-lidos        as integer   format ">>>>>9" initial 0 no-undo.
def var i-reg-imp          as integer   format ">>>>>9" initial 0 no-undo.
def var c-dados            as character format "x(130)"           no-undo.
def var c-desc-erro        as character format "x(70)"            no-undo.
define var label-cod-estabel     as character format "x(03)".
define var label-cod-canal       as character format "x(03)".
define var label-venda           as character format "x(03)".
define var label-gr-cli          as character format "x(02)".
define var label-cliente         as character format "x(12)".
define var label-nome-ab-reg     as character format "x(11)".
define var label-nome-mic-reg    as character format "x(12)".
define var label-cod-rep         as character format "x(06)".
define var label-cd-produto      as character format "x(13)".
define var label-data            as character format "x(04)".
define var label-inicial         as character format "x(07)".
define var label-qt-prevista     as character format "x(08)".
define var label-mensagem        as character format "x(16)".
define var l-importa             as logical   initial yes.

define var c-cod-estabel      like cotas.cod-estabel  .
define var i-cod-canal-venda  as int  format "999"  .
define var c-cod-canal-venda  as char format "xxx"  .
define var i-cod-gr-cli       as int  format "9999"   .
define var c-cod-gr-cli       as char format "xx"   .
define var c-nome-ab-reg      like cotas.nome-ab-reg  .
define var c-nome-mic-reg     like cotas.nome-mic-reg .
DEFINE VAR c-cod-rep          AS CHARACTER FORMAT "xxxxx".
define var i-cod-rep          as int format "99999".
define var c-cd-produto       like cotas.cd-produto.
define var da-dt-inicial      as date format 99/99/9999.
define var de-qt-prevista     as decimal format ">>>>,>>>,>>9.99".
define var de-vl-previsto     as decimal format ">>>>,>>>,>>9.99".
define var c-cota-liberada    as char.
define var de-qt-pedida       as decimal format ">>>>,>>>,>>9.99".
define var de-qt-faturada     as decimal format ">>>>,>>>,>>9.99".
define var de-qt-ped-canc     as decimal format ">>>>,>>>,>>9.99".
define var de-qt-fat-canc     as decimal format ">>>>,>>>,>>9.99".
define var de-qt-ped-susp     as decimal format ">>>>,>>>,>>9.99".
define var de-qt-original     as decimal format ">>>>,>>>,>>9.99".
define var de-qt-solicitado   as decimal format ">>>>,>>>,>>9.99".
define var de-vl-pedido       as decimal format ">>>>,>>>,>>9.99".
define var de-vl-faturado     as decimal format ">>>>,>>>,>>9.99".
define var de-vl-ped-canc     as decimal format ">>>>,>>>,>>9.99".
define var de-vl-fat-canc     as decimal format ">>>>,>>>,>>9.99".
define var de-vl-ped-susp     as decimal format ">>>>,>>>,>>9.99".
define var de-vl-original     as decimal format ">>>>,>>>,>>9.99".
define var de-vl-solicitado   as decimal format ">>>>,>>>,>>9.99".
define var da-dt-final        as date format 99/99/9999.
define var c-nome-abrev       like cotas.nome-abrev.
define var c-nome-rep         like repres.nome-abrev.
define var c-nome-est         like estabelec.nome.
define var de-qt-reprov       as decimal format ">>>>,>>>,>>9.99".
define var de-vl-reprov       as decimal format ">>>>,>>>,>>9.99".

def var i-nr-trans            as int no-undo.
DEF BUFFER b-cotas FOR cotas.

/* ************************* Definiá∆o de Stream ***************************** */

def stream s-imp.

/* ************************** Definiá∆o de Form ****************************** */

form skip(01)
     c-parametro no-label    skip(1)
     tt-param.desc-importa   colon 40
     tt-param.arq-entrada    colon 40 skip(1)
     c-impressao no-label    skip(1)
     c-destino               colon 40
     " - ":U
     tt-param.arq-destino no-label format "x(60)":U skip
     tt-param.usuario        colon 40 skip
     with down no-box side-labels width 132 stream-io frame f-parametros.

form skip(1)
     i-reg-lidos  colon 30 
     i-reg-imp    colon 30 
     with stream-io side-labels width 120 no-box frame f-contador.

form skip(1)
     i-reg-lidos                           colon 30 
     c-desc-erro  no-label  format "x(70)" at 23 
     with stream-io side-labels width 120 no-box frame f-contador-erro.



/* ****************************** Literais ********************************** */

{utp/ut-liter.i PAR∂METROS * R}
assign c-parametro = trim(return-value).

{utp/ut-liter.i IMPRESS«O * R}
assign c-impressao = trim(return-value).

{utp/ut-liter.i Destino * L}
assign c-destino:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Usu†rio * L}
assign tt-param.usuario:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Importa_do * L}
assign tt-param.desc-importa:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Arquivo_Entrada * L}
assign tt-param.arq-entrada:label in frame f-parametros = trim(return-value).

{utp/ut-liter.i Produto/Item * R}
assign c-produto = trim(return-value).

{utp/ut-liter.i Importando_Cotas MAC C}
assign c-importa = trim(return-value).

{utp/ut-liter.i Importaá∆o_Cotas MAC C}  
assign c-titulo-relat = return-value.

{utp/ut-liter.i Est MAC C}
assign label-cod-estabel = return-value.

{utp/ut-liter.i Can MAC C}
assign label-cod-canal = return-value.

{utp/ut-liter.i  Ven MAC C}  
assign label-venda  = return-value.

{utp/ut-liter.i  GC MAC C}  
assign label-gr-cli  = return-value.

{utp/ut-liter.i  Cliente MAC C}  
assign label-cliente  = return-value.

{utp/ut-liter.i  Regi∆o MAC C}  
assign label-nome-ab-reg = return-value.

{utp/ut-liter.i  Microrregi∆o MAC C}  
assign label-nome-mic-reg = return-value.

{utp/ut-liter.i  Repres MAC C}  
assign label-cod-rep  = return-value.

{utp/ut-liter.i  Produto/Item MAC C}  
assign label-cd-produto  = return-value.

{utp/ut-liter.i Data MAC C}  
assign label-data    = return-value.

{utp/ut-liter.i Inicial MAC C}  
assign label-inicial    = return-value.

{utp/ut-liter.i Prevista MAC C}  
assign label-qt-prevista = return-value.

{utp/ut-liter.i Mensagem_de_Erro MAC C}  
assign label-mensagem   = return-value.

{utp/ut-liter.i Registros_Lidos * L}
assign i-reg-lidos:label in frame f-contador      = trim(return-value).
assign i-reg-lidos:label in frame f-contador-erro = trim(return-value).


{utp/ut-liter.i Registros_Importados * L}
assign i-reg-imp:label in frame f-contador = trim(return-value).

/* ************************************************************************* */
run utp/ut-trfrrp.p (input frame f-contador-erro:handle).
run utp/ut-trfrrp.p (input frame f-contador:handle).
run utp/ut-trfrrp.p (input frame f-parametros:handle).
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param.

find empresa 
     where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.

{utp/ut-liter.i Cotas MAC L}                 
assign c-programa = "AC/1007"
       c-empresa  = empresa.razao-social
       c-sistema  = return-value
       c-destino  = {varinc/var00002.i 04 tt-param.destino}.

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

Return "OK".
/*fim-do-programa*/

/* ******************** Procedure Interna ******************************* */

PROCEDURE PI-IMPORTA-ARQUIVO:

    assign i-reg-imp   = 0
           i-reg-lidos = 0.

    input stream s-imp from value(tt-param.arq-entrada).
    repeat on error undo, leave
        on stop undo, leave transaction:

        assign c-dados = " ".

        import stream s-imp unformatted c-dados.

        if c-dados = " " then
           leave.

        run pi-acompanhar in h-acomp (input i-reg-lidos).

        /** Importaá∆o layout 2.03 - Uso de pre-processador **/
        &if defined (bf_dis_adm_cotas) &then   

            assign i-reg-lidos       = i-reg-lidos + 1
                   c-cod-canal-venda =    trim(substr(c-dados,04,03))
                   c-cd-produto      =    trim(substr(c-dados,07,16))
                   c-nome-abrev      =    trim(substr(c-dados,25,12))
                   c-nome-ab-reg     =    trim(substr(c-dados,37,12))
                   c-nome-mic-reg    =    trim(substr(c-dados,49,12))
                   c-cod-rep         =    TRIM(substr(c-dados,61,05))
                   da-dt-inicial     = date(   substr(c-dados,66,08))
                   da-dt-final       = date(   substr(c-dados,74,08))
                   c-cota-liberada   =         substr(c-dados,82,01)
                   de-qt-prevista    = decimal(substr(c-dados,83,12))  / 100
                   de-qt-pedida      = decimal(substr(c-dados,95,12))  / 100
                   de-qt-faturada    = decimal(substr(c-dados,107,12)) / 100
                   de-qt-ped-canc    = decimal(substr(c-dados,119,12)) / 100
                   de-qt-fat-canc    = decimal(substr(c-dados,131,12)) / 100
                   de-qt-ped-susp    = decimal(substr(c-dados,143,12)) / 100
                   de-qt-original    = decimal(substr(c-dados,155,12)) / 100
                   de-qt-solicitado  = decimal(substr(c-dados,167,12)) / 100
                   de-qt-reprov      = decimal(substr(c-dados,179,12)) / 100

                   de-vl-previsto    = decimal(substr(c-dados,191,12)) / 100
                   de-vl-pedido      = decimal(substr(c-dados,203,12)) / 100
                   de-vl-faturado    = decimal(substr(c-dados,215,12)) / 100
                   de-vl-ped-canc    = decimal(substr(c-dados,227,12)) / 100
                   de-vl-fat-canc    = decimal(substr(c-dados,239,12)) / 100
                   de-vl-ped-susp    = decimal(substr(c-dados,251,12)) / 100
                   de-vl-original    = decimal(substr(c-dados,263,12)) / 100
                   de-vl-solicitado  = decimal(substr(c-dados,275,12)) / 100
                   de-vl-reprov      = decimal(substr(c-dados,287,12)) / 100
                   l-importa         = yes
                   c-cod-estabel     =    trim(substr(c-dados,299,05))
                   c-cod-gr-cli      =    trim(substr(c-dados,304,04)).
        /** Importaá∆o layout 2.02 - Uso de pre-processador **/
        &else
        
            assign i-reg-lidos       = i-reg-lidos + 1
                   &IF "{&mguni_version}" < "2.071" &THEN
                   c-cod-estabel     =    trim(substr(c-dados,01,03))
                   &ENDIF
                   c-cod-canal-venda =    trim(substr(c-dados,04,03))
                   c-cd-produto      =    trim(substr(c-dados,07,16))
                   c-nome-abrev      =    trim(substr(c-dados,25,12))
                   c-nome-ab-reg     =    trim(substr(c-dados,37,12))
                   c-nome-mic-reg    =    trim(substr(c-dados,49,12))
                   c-cod-rep         =    TRIM(substr(c-dados,61,05))
                   da-dt-inicial     = date(   substr(c-dados,66,08))
                   da-dt-final       = date(   substr(c-dados,74,08))
                   c-cota-liberada   =         substr(c-dados,82,01)
                   de-qt-prevista    = decimal(substr(c-dados,83,12))  / 100
                   de-qt-pedida      = decimal(substr(c-dados,95,12))  / 100
                   de-qt-faturada    = decimal(substr(c-dados,107,12)) / 100
                   de-qt-ped-canc    = decimal(substr(c-dados,119,12)) / 100
                   de-qt-fat-canc    = decimal(substr(c-dados,131,12)) / 100
                   de-qt-ped-susp    = decimal(substr(c-dados,143,12)) / 100
                   de-qt-original    = decimal(substr(c-dados,155,12)) / 100
                   de-qt-solicitado  = decimal(substr(c-dados,167,12)) / 100

                   de-vl-previsto    = decimal(substr(c-dados,179,12)) / 100
                   de-vl-pedido      = decimal(substr(c-dados,191,12)) / 100
                   de-vl-faturado    = decimal(substr(c-dados,203,12)) / 100
                   de-vl-ped-canc    = decimal(substr(c-dados,215,12)) / 100
                   de-vl-fat-canc    = decimal(substr(c-dados,227,12)) / 100
                   de-vl-ped-susp    = decimal(substr(c-dados,239,12)) / 100
                   de-vl-original    = decimal(substr(c-dados,251,12)) / 100
                   de-vl-solicitado  = decimal(substr(c-dados,263,12)) / 100 
                   l-importa         = yes
                   &IF "{&mguni_version}" >= "2.071" &THEN
                   c-cod-estabel     =    trim(substr(c-dados,275,05))
                   &ENDIF
                   c-cod-gr-cli      =    trim(substr(c-dados,280,04))
                   .
        &endif 

        /* tratamento para interroga nos campos inteiros */
        if trim(c-cod-canal-venda) = "?" then
           assign i-cod-canal-venda = ?.
        else
           assign i-cod-canal-venda = int(trim(substr(c-dados,04,03))).    

         /** Importaá∆o layout 2.03 - Uso de pre-processador **/
        &if defined (bf_dis_adm_cotas) &then   
           if trim(c-cod-gr-cli) = "?" then 
              assign i-cod-gr-cli = ?.
           else
              assign i-cod-gr-cli = int(trim(substr(c-dados,304,04))).
        &else
           if trim(c-cod-gr-cli) = "?" then                             
              assign i-cod-gr-cli = ?.                                 
           else                                                        
              assign i-cod-gr-cli = int(trim(substr(c-dados,280,04))). 
        &endif 
        
        if trim(c-cod-rep) = "?" then 
           assign i-cod-rep = ?.
        else
           assign i-cod-rep = int(trim(substr(c-dados,61,05))).

        create tt-cotas.
        assign tt-cotas.cod-estabel        = c-cod-estabel
               tt-cotas.cod-canal-venda    = i-cod-canal-venda
               tt-cotas.cod-gr-cli         = i-cod-gr-cli
               tt-cotas.nome-abrev         = c-nome-abrev
               tt-cotas.nome-ab-reg        = c-nome-ab-reg
               tt-cotas.nome-mic-reg       = c-nome-mic-reg
               tt-cotas.cod-rep            = i-cod-rep
               tt-cotas.cd-produto         = c-cd-produto
               tt-cotas.dt-inicial         = da-dt-inicial
               tt-cotas.dt-final           = da-dt-final
               tt-cotas.qt-prevista        = de-qt-prevista
               tt-cotas.qt-pedida          = de-qt-pedida
               tt-cotas.qt-faturada        = de-qt-faturada
               tt-cotas.qt-ped-canc        = de-qt-ped-canc
               tt-cotas.qt-fat-canc        = de-qt-fat-canc
               tt-cotas.qt-ped-susp        = de-qt-ped-susp 
               tt-cotas.qt-original        = de-qt-original
               tt-cotas.qt-solicitado      = de-qt-solicitado
               tt-cotas.vl-previsto        = de-vl-previsto
               tt-cotas.vl-pedido          = de-vl-pedido
               tt-cotas.vl-faturado        = de-vl-faturado
               tt-cotas.vl-ped-canc        = de-vl-ped-canc
               tt-cotas.vl-fat-canc        = de-vl-fat-canc
               tt-cotas.vl-ped-susp        = de-vl-ped-susp
               tt-cotas.vl-original        = de-vl-original
               tt-cotas.vl-solicitado      = de-vl-solicitado
               tt-cotas.log-base-cota      = yes
               tt-cotas.log-previsto-base  = yes
               tt-cotas.log-previsto-cota  = yes
               tt-cotas.log-original-cota  = yes
               tt-cotas.ind-tipo-movto     = 1
               l-importa                   = yes
        /**  Uso de pre-processador **/
        &if defined (bf_dis_adm_cotas) &then                  
               tt-cotas.qt-ped-reprov      = de-qt-reprov
               tt-cotas.vl-ped-reprov      = de-vl-reprov 
        &endif
               .

        if c-cota-liberada = "S" then
           assign tt-cotas.cota-liberada = yes. 
        else
          assign tt-cotas.cota-liberada = no.

        /* chamada e tratamento de erros e a api de cotas para cada registro
           da tabela, para que possa ser verificado se atualizou ou n∆o. */

    end.

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Gravando_Informaá‰es" *}
    run pi-acompanhar in h-acomp (input RETURN-VALUE).
    
    run pi-chama-api-cotas.

    if i-reg-imp = 0 then do:
       {utp/ut-liter.i ATENÄ«O:_Registros_com_erros_n∆o_foram_importados. MAC c}.
       assign c-desc-erro = trim(return-value).      
       disp skip(2)
            i-reg-lidos
            c-desc-erro
            with frame f-contador-erro.

    end.
    else
       disp skip(2)
            i-reg-lidos
            i-reg-imp  
            with  frame f-contador.


END.


/* *******************************************************************  */

PROCEDURE PI-IMPORTA-EXCEL:

  define var i-cont-colun       as   integer.
  define var i-linha            as   integer init 1.

  find first tt-param.
  assign i-linha   = 5
         i-reg-imp = 0.

  create tt-configuracao.
  assign tt-configuracao.versao-integracao = 1
         tt-configuracao.arquivo           = tt-param.arq-entrada
         tt-configuracao.planilha          = 1
         tt-configuracao.linha-inicio      = 6
         tt-configuracao.coluna-inicio     = 1
         tt-configuracao.coluna-final      = 19.

  run acp/acapi001.p (input  table tt-configuracao,
                      output table tt-dados,
                      output table tt-erros).

  for each tt-dados
      where tt-dados.valor <> ""
      break by tt-dados.celula-linha
            by tt-dados.celula-coluna:

      if first-of(tt-dados.celula-linha) then do:
         assign l-importa = yes
                i-reg-lidos = i-reg-lidos + 1.
      end.          

      if tt-dados.celula-coluna = 1 then do:
         find estabelec no-lock
              where estabelec.cod-estabel = tt-dados.valor no-error.
         if not avail estabelec and tt-dados.valor <> " " then do:
            {utp/ut-liter.i Estabelecimento_n∆o_Cadastrado * L}
            run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                input return-value).
            assign l-importa = no.
         end.

         find par-cota no-lock 
              where par-cota.cod-estabel = tt-dados.valor no-error.

         if not avail par-cota and tt-dados.valor <> " " then do:
            {utp/ut-liter.i ParÉmetros_de_Cotas_n∆o_Cadastrado * L}
            run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                input return-value).
            assign l-importa = no.
         end.
         assign c-cod-estabel = tt-dados.valor.
      end.   

      if tt-dados.celula-coluna = 2 then do:
         find canal-venda no-lock
              where canal-venda.cod-canal-venda = int(tt-dados.valor) no-error.
         if not avail canal-venda and int(tt-dados.valor) <> 0 and trim(tt-dados.valor) <> "?" then do:
            {utp/ut-liter.i Canal_de_Vendas_n∆o_Cadastrado * L}

            run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                input return-value).
            assign l-importa = no.
         end.
         if avail par-cota and not par-cota.cont-canal-venda and 
            int(tt-dados.valor) <> 0 and trim(tt-dados.valor) <> "?" then do:
              {utp/ut-table.i mgdis canal-venda 1}
              run utp/ut-msgs.p (input "msg",
                                input 29917,
                                input return-value).
             run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                input return-value).
            assign l-importa = no.
         end.
         assign i-cod-canal-venda = int(tt-dados.valor).
      end.

      if tt-dados.celula-coluna = 4 then do:
         find gr-cli no-lock
              where gr-cli.cod-gr-cli = int(tt-dados.valor) no-error.
         if not avail gr-cli and int(tt-dados.valor) <> 0 and trim(tt-dados.valor) <> "?" then do:
            {utp/ut-liter.i Grupo_do_Cliente_n∆o_Cadastrado * L}
            run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                input return-value).
            assign l-importa = no.
         end.

         if avail par-cota and not par-cota.cont-gr-cli and 
            int(tt-dados.valor) <> 0 and trim(tt-dados.valor) <> "?" then do:
              {utp/ut-table.i mgadm gr-cli 1}
              run utp/ut-msgs.p (input "msg",
                                input 29917,
                                input return-value).
             run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                input return-value).
            assign l-importa = no.
         end.         
         assign i-cod-gr-cli = int(tt-dados.valor).
      end.  


      if tt-dados.celula-coluna = 6 then do:
         find emitente no-lock
              where emitente.nome-abrev = tt-dados.valor no-error.
         if not avail emitente and tt-dados.valor <> " " and trim(tt-dados.valor) <> "?" then do:
            {utp/ut-liter.i Cliente_n∆o_Cadastrado * L}
            run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                   input return-value).
            assign l-importa = no.
         end.

         if avail par-cota and not par-cota.cont-cliente and 
            tt-dados.valor <> "" and trim(tt-dados.valor) <> "?" then do:
              {utp/ut-table.i mgadm emitente 1}
              run utp/ut-msgs.p (input "msg",
                                input 29917,
                                input return-value).
             run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                input return-value).
            assign l-importa = no.
         end.         
         if tt-dados.valor = "?" then
            assign c-nome-abrev = ?.
         else
            assign c-nome-abrev = tt-dados.valor.         
      end.  

      if tt-dados.celula-coluna = 7 then do:
         find regiao no-lock
              where regiao.nome-ab-reg = tt-dados.valor no-error.
         if not avail regiao and tt-dados.valor <> " " and trim(tt-dados.valor) <> "?" then do:
            {utp/ut-liter.i Regi∆o_n∆o_Cadastrada * L}
            run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                   input return-value).
            assign l-importa = no.
         end.

         if avail par-cota and not par-cota.cont-ab-reg and 
            tt-dados.valor <> "" and trim(tt-dados.valor) <> "?" then do:
              {utp/ut-table.i mgadm regiao 1}
              run utp/ut-msgs.p (input "msg",
                                input 29917,
                                input return-value).
             run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                input return-value).
            assign l-importa = no.
         end.         
         if tt-dados.valor = "?" then
            assign c-nome-ab-reg = ?.
         else
            assign c-nome-ab-reg = tt-dados.valor. 

      end.  

      if tt-dados.celula-coluna = 8 then do:
         find micro-reg no-lock
              where micro-reg.nome-ab-reg  = c-nome-ab-reg
              and   micro-reg.nome-mic-reg = tt-dados.valor no-error.
         if not avail micro-reg and tt-dados.valor <> " " and trim(tt-dados.valor) <> "?" then do:
            {utp/ut-liter.i Microrregi∆o_n∆o_Cadastrado * L}
            run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                input return-value).
            assign l-importa = no.
         end.
         if avail par-cota and not par-cota.cont-mic-reg and 
            tt-dados.valor <> "" and trim(tt-dados.valor) <> "?" then do:
              {utp/ut-table.i mgdis micro-reg 1}
              run utp/ut-msgs.p (input "msg",
                                input 29917,
                                input return-value).
             run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                input return-value).
            assign l-importa = no.
         end.         
         if tt-dados.valor = "?" then
            assign c-nome-mic-reg = ?.
         else
            assign c-nome-mic-reg = tt-dados.valor.
      end.

      if tt-dados.celula-coluna = 09 then do: 
         find repres no-lock
              where repres.cod-rep     = int(tt-dados.valor) no-error.
         if not avail repres then do:
            {utp/ut-liter.i Representante_n∆o_Cadastrado * L}
            run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                   input return-value).
            assign l-importa = no.
         end.
         assign i-cod-rep = int(tt-dados.valor).         
      end.   

      if tt-dados.celula-coluna = 11 then do:
          if can-find(first item-cota no-lock
                      where item-cota.it-codigo = tt-dados.valor) then do:
              find item-cota
                  where item-cota.it-codigo = tt-dados.valor no-lock no-error.
              if avail item-cota and
                       item-cota.log-produto = yes then do:
              &if defined (bf_dis_adm_cotas) &then /* INICIO PREPROCESSADOR */
                   find first produto-coml no-lock 
                        where produto-coml.cod-produto-coml = tt-dados.valor no-error.
                   if not avail produto-coml then do:
              &else
                   find first produto no-lock 
                        where produto.cd-produto = tt-dados.valor no-error.
                   if not avail produto then do:
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
                      {utp/ut-liter.i Produto/Item_n∆o_cadastrado * L}
                      run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                             input return-value).
                      assign l-importa = no.
                 end.
          end.
          assign c-cd-produto = tt-dados.valor.
      end. 

      if tt-dados.celula-coluna = 13 then do:
         if tt-dados.valor = "" then do:
            {utp/ut-liter.i Per°odo_Inv†lido * L}
            run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                input return-value).
            assign l-importa = no.
         end.
         assign da-dt-inicial = date(tt-dados.valor).         
      end. 

      if tt-dados.celula-coluna = 14 then do:
         if tt-dados.valor = "" then do:
            {utp/ut-liter.i Per°odo_Inv†lido * L}
            run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                   input return-value).
            assign l-importa = no.
         end.
         else if date(tt-dados.valor) < da-dt-inicial then do:
             {utp/ut-liter.i Data_Inicial_deve_ser_maior_que_Data_Final * L}
                 run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                        input return-value).
                 assign l-importa = no.
         end.
         assign da-dt-final = date(tt-dados.valor).         
      end. 

      if tt-dados.celula-coluna = 15 then 
         assign de-qt-prevista = decimal(tt-dados.valor)
                de-vl-previsto = decimal(tt-dados.valor).

      if tt-dados.celula-coluna = 16 then do:
         assign de-qt-pedida = decimal(tt-dados.valor)
                de-vl-pedido = decimal(tt-dados.valor).
                
         /* O que define se sera apresentada a mensagem: "Qtde Prevista ficara menor que Qtde Pedida" e:
         "Tipo Cota = Maxima" (AC0301) e
         "Cota Limite = marcado" (AC0903) ou "Utilizacao do Produto Comercial" (CD0924) e  
         "Cota Limite = marcado" (AC0302) e 
         Qtde Pedida maior que Prevista. */
         /* A regra de negocio acima foi baseada na acapi006.p */
    
         if avail par-cota and par-cota.tipo-cota = 2 then /* Maxima */
         do: 
             find base-cota exclusive-lock
                  where base-cota.cod-estabel = c-cod-estabel
                  and   base-cota.cd-produto  = c-cd-produto
                  and   base-cota.dt-inicial  = da-dt-inicial no-error.
             if avail base-cota then do:
    
                 &IF DEFINED (bf_dis_adm_cotas) &THEN   
                       if ( (avail item-cota and item-cota.log-cota-limite = yes) or avail produto-coml) and
                           base-cota.log-cota-limite = yes then do:
                 &ELSE
                       if (avail item-cota and item-cota.log-cota-limite = yes) or avail produto then do:
                 &ENDIF
    
                           find first cotas no-lock
                                where cotas.cod-estabel     = c-cod-estabel
                                and   cotas.cod-canal-venda = i-cod-canal-venda
                                and   cotas.cod-gr-cli      = i-cod-gr-cli
                                and   cotas.nome-abrev      = c-nome-abrev
                                and   cotas.nome-ab-reg     = c-nome-ab-reg
                                and   cotas.nome-mic-reg    = c-nome-mic-reg
                                and   cotas.cod-rep         = i-cod-rep
                                and   cotas.cd-produto      = c-cd-produto
                                and   cotas.dt-inicial      = da-dt-inicial no-error.
                           if avail cotas then 
                                 if (par-cota.tipo-controle = 2 and 
                                    (cotas.vl-previsto + de-vl-previsto) < (cotas.vl-pedido + de-vl-pedido)) or 
                                    (par-cota.tipo-controle <> 2 and
                                    (cotas.qt-prevista + de-qt-prevista) < (cotas.qt-pedida + de-qt-pedida)) then do:
    
                                         {utp/ut-liter.i Previsto_ficar†_menor_que_Pedido * L}
                                         run PI-GRAVA-MENSAGEM (input tt-dados.celula-linha,
                                         input return-value).
                                         assign l-importa = no.
                                 end.
                       end.
             end.
         end.
      end.
      if tt-dados.celula-coluna = 17 then 
         assign de-qt-faturada = decimal(tt-dados.valor)
                de-vl-faturado = decimal(tt-dados.valor).

      if tt-dados.celula-coluna = 18 then 
         assign de-qt-original = decimal(tt-dados.valor)
                de-vl-original = decimal(tt-dados.valor).  

      if tt-dados.celula-coluna = 19 then
         assign de-qt-solicitado = decimal(tt-dados.valor)
                de-vl-solicitado = decimal(tt-dados.valor).         

      if last-of(tt-dados.celula-linha) and l-importa then do:
          find first par-cota where par-cota.cod-estabel = c-cod-estabel no-lock no-error.
          /*find base-cota exclusive-lock
               where base-cota.cod-estabel = c-cod-estabel
               and   base-cota.cd-produto  = c-cd-produto
               and   base-cota.dt-inicial  = da-dt-inicial no-error.
          if not avail base-cota then do:
             create base-cota.
             assign base-cota.cod-estabel      = c-cod-estabel
                    base-cota.cd-produto       = c-cd-produto
                    base-cota.dt-inicial       = da-dt-inicial
                    base-cota.dt-final         = da-dt-final
                    &if defined (bf_dis_adm_cotas) &then /* INICIO PREPROCESSADOR */
                        base-cota.cd-produto-dest  = base-cota.cd-produto
                        base-cota.log-consid-cotas = /* Se achou marcado no AC0903 ou se Ç produto ent∆o YES */
                        if (can-find 
                              (item-cota where item-cota.it-codigo = base-cota.cd-produto 
                                           and item-cota.log-consid-cotas)) or
                           (can-find 
                              (produto-coml where produto-coml.cod-produto-coml = base-cota.cd-produto)) then yes else no


                        base-cota.log-cota-limite =  /* Se achou marcado no AC0903 ou se Ç produto ent∆o YES */
                        if (can-find 
                              (item-cota where item-cota.it-codigo = base-cota.cd-produto 
                                           and item-cota.log-cota-limite)) or
                           (can-find 
                              (produto-coml where produto-coml.cod-produto-coml = base-cota.cd-produto)) then yes else no
                    &else
                        base-cota.log-consid-cotas = /* Se achou marcado no AC0903 ou se Ç produto ent∆o YES */
                        if (can-find 
                              (item-cota where item-cota.it-codigo = base-cota.cd-produto 
                                           and item-cota.log-consid-cotas)) or
                           (can-find 
                              (produto where produto.cd-produto = base-cota.cd-produto)) then yes else no

                    &endif                                                                                            &if defined(bf_dis_adm_cotas) &then  /* INICIO PREPROCESSADOR */
             &endif.                        
          end.

         if par-cota.tipo-controle = 2 /*valor*/ then
            assign base-cota.qt-prevista = base-cota.qt-prevista + de-vl-previsto.        
         else /* quantidade/pontos*/          
            assign base-cota.qt-prevista = base-cota.qt-prevista + de-qt-prevista.   */     

         find FIRST cotas exclusive-lock
              where cotas.cod-estabel     = c-cod-estabel
              and   cotas.cod-canal-venda = i-cod-canal-venda
              and   cotas.cod-gr-cli      = i-cod-gr-cli
              and   cotas.nome-abrev      = c-nome-abrev
              and   cotas.nome-ab-reg     = c-nome-ab-reg
              and   cotas.nome-mic-reg    = c-nome-mic-reg
              and   cotas.cod-rep         = i-cod-rep
              and   cotas.cd-produto      = c-cd-produto
              and   cotas.dt-inicial      = da-dt-inicial no-error.

         if not avail cotas then do:
            /* nr da transacao */ 
            for last b-cotas fields(nr-trans) no-lock use-index ch-cot :
                assign i-nr-trans =  ( b-cotas.nr-trans + 1 ) .    
            end.
            if not avail b-cotas then
               assign i-nr-trans = 1.    

            create cotas.
            assign cotas.cod-estabel     = c-cod-estabel
                   cotas.cod-canal-venda = i-cod-canal-venda
                   cotas.cod-gr-cli      = i-cod-gr-cli
                   cotas.nome-abrev      = c-nome-abrev
                   cotas.nome-ab-reg     = c-nome-ab-reg
                   cotas.nome-mic-reg    = c-nome-mic-reg
                   cotas.cod-rep         = i-cod-rep
                   cotas.nr-trans        = i-nr-trans
                   cotas.cd-produto      = c-cd-produto
                   cotas.dt-inicial      = da-dt-inicial.
         end. 

         assign cotas.dt-final        = da-dt-final
                i-reg-imp             = i-reg-imp +  1.

         if par-cota.tipo-controle = 2 /*valor*/ then
            assign cotas.vl-previsto     = cotas.vl-previsto + de-vl-previsto
                   cotas.vl-pedido       = cotas.vl-pedido + de-vl-pedido
                   cotas.vl-faturado     = cotas.vl-faturado + de-vl-faturado
                   cotas.vl-ped-canc     = cotas.vl-ped-canc + de-vl-ped-canc
                   cotas.vl-fat-canc     = cotas.vl-fat-canc + de-vl-fat-canc
                   cotas.vl-ped-susp     = cotas.vl-ped-susp + de-vl-ped-susp
                   cotas.vl-original     = cotas.vl-original + de-vl-original. 
         else          
            assign cotas.qt-prevista     = cotas.qt-prevista + de-qt-prevista
                   cotas.qt-pedida       = cotas.qt-pedida + de-qt-pedida
                   cotas.qt-faturada     = cotas.qt-faturada + de-qt-faturada
                   cotas.qt-ped-canc     = cotas.qt-ped-canc + de-qt-ped-canc
                   cotas.qt-fat-canc     = cotas.qt-fat-canc + de-qt-fat-canc
                   cotas.qt-ped-susp     = cotas.qt-ped-susp + de-qt-ped-susp 
                   cotas.qt-original     = cotas.qt-original + de-qt-original
                   cotas.qt-solicitado   = cotas.qt-solicitado + de-qt-solicitado.

         if c-cota-liberada = "S" then
            assign cotas.cota-liberada = yes. 
         else
            assign cotas.cota-liberada = no.
      end.
      
  end.
  run pi-imprime-mensagem.  

END.


/* ************************************************************************************  */

PROCEDURE PI-GRAVA-MENSAGEM:

   define input parameter i-linha as integer.
   define input parameter c-mens  as char.

   find par-cota no-lock where
        par-cota.cod-estabel = c-cod-estabel no-error.

   create tt-mensagem.
   assign tt-mensagem.mensagem  = c-mens.
   if i-linha <> 0 then do:
        for each b-tt-dados
            where b-tt-dados.celula-linha = i-linha
            break by b-tt-dados.celula-coluna:



            if b-tt-dados.celula-coluna =  1 then
               assign tt-mensagem.cod-estabel       = b-tt-dados.valor.
            if b-tt-dados.celula-coluna =  2 then
               assign tt-mensagem.cod-canal-venda   = int(b-tt-dados.valor).
            if b-tt-dados.celula-coluna =  4 then 
               assign tt-mensagem.cod-gr-cli        = int(b-tt-dados.valor).
            if b-tt-dados.celula-coluna =  6 then
               assign tt-mensagem.nome-abrev        = b-tt-dados.valor.
            if b-tt-dados.celula-coluna =  7 then
               assign tt-mensagem.nome-ab-reg       = b-tt-dados.valor.
            if b-tt-dados.celula-coluna =  8 then
               assign tt-mensagem.nome-mic-reg      = b-tt-dados.valor.
            if b-tt-dados.celula-coluna =  9 then
               assign tt-mensagem.cod-rep           = int(b-tt-dados.valor).
            if b-tt-dados.celula-coluna = 11 then
               assign tt-mensagem.cd-produto        = b-tt-dados.valor.
            if b-tt-dados.celula-coluna = 13  then
               assign tt-mensagem.dt-inicial        = date(b-tt-dados.valor).
            if b-tt-dados.celula-coluna = 14  then
               assign tt-mensagem.dt-final          = date(b-tt-dados.valor).
            if b-tt-dados.celula-coluna = 15 then
               assign tt-mensagem.qt-prevista       = decimal(b-tt-dados.valor).
        end.
   end.
   else 
        assign tt-mensagem.cod-estabel     = c-cod-estabel
               tt-mensagem.cod-canal-venda = i-cod-canal-venda
               tt-mensagem.cod-gr-cli      = i-cod-gr-cli
               tt-mensagem.nome-abrev      = c-nome-abrev
               tt-mensagem.nome-ab-reg     = c-nome-ab-reg
               tt-mensagem.nome-mic-reg    = c-nome-mic-reg
               tt-mensagem.cod-rep         = i-cod-rep
               tt-mensagem.cd-produto      = c-cd-produto
               tt-mensagem.dt-inicial      = da-dt-inicial
               tt-mensagem.dt-final        = da-dt-final
               tt-mensagem.qt-prevista     = if par-cota.tipo-controle = 2 then de-vl-previsto else de-qt-prevista.


END.

/* ************************************************************************************  */

PROCEDURE PI-IMPRIME-MENSAGEM:
  /* Impress∆o das mensagens*/
  for each tt-mensagem
      break by tt-mensagem.cod-estabel
            by tt-mensagem.cod-rep:

      if first-of(tt-mensagem.cod-estabel) or
         first-of(tt-mensagem.cod-rep)     then do:

         find first estabelec no-lock where 
                    estabelec.cod-estabel = tt-mensagem.cod-estabel no-error.
         if avail estabelec then
            assign c-nome-est = estabelec.nome. 
         find first repres no-lock where
                    repres.cod-rep = tt-mensagem.cod-rep no-error.
         if avail repres then
            assign c-nome-rep = repres.nome-abrev.           

         run pi-acompanhar in h-acomp (input tt-mensagem.cod-rep).

         put skip(1)
             label-cod-estabel       at 05 ": "
             tt-mensagem.cod-estabel "    -  " c-nome-est skip  
             label-cod-rep           at 02 ": "
             tt-mensagem.cod-rep     "  -  " c-nome-rep skip(1)

             label-cod-canal         at 01
             label-data              at 67
             skip
             label-venda             at 01
             label-gr-cli            at 05
             label-cliente           at 11
             label-nome-ab-reg       at 24
             label-nome-mic-reg      at 37
             label-cd-produto        at 50
             label-inicial           at 67
             label-qt-prevista       at 76
             label-mensagem          at 94
             skip
             fill("-",03) format "x(03)" at 01
             fill("-",04) format "x(04)" at 05
             fill("-",12) format "x(12)" at 11
             fill("-",12) format "x(12)" at 24 
             fill("-",12) format "x(12)" at 37
             fill("-",16) format "x(16)" at 50
             fill("-",08) format "x(08)" at 67
             fill("-",17) format "x(17)" at 76
             fill("-",43) format "x(43)" at 94
             skip.

      end.       

      put tt-mensagem.cod-canal-venda  at 01
          tt-mensagem.cod-gr-cli       at 05
          tt-mensagem.nome-abrev       at 11  
          tt-mensagem.nome-ab-reg      at 24
          tt-mensagem.nome-mic-reg     at 37
          tt-mensagem.cd-produto       at 50
          tt-mensagem.dt-inicial       at 67
          tt-mensagem.qt-prevista      at 76   
          tt-mensagem.mensagem         at 94
          skip.
  end.
    if i-reg-imp = 0 then do:
       {utp/ut-liter.i ATENÄ«O:_Registros_com_erros_n∆o_foram_importados. MAC c}.
       assign c-desc-erro = trim(return-value).      
       disp skip(2)
            i-reg-lidos
            c-desc-erro
            with frame f-contador-erro.

    end.
    else
       disp skip(2)
            i-reg-lidos
            i-reg-imp  
            with  frame f-contador.
END.  

/**********************************************************************/
PROCEDURE PI-CHAMA-API-COTAS.

   run acp/acapi006.p ( input  1,
                        input  table tt-cotas,
                        output table tt-erros-api).

   if return-value = "nok" then do:
      for each tt-erros-api :
         /* imprime os erros */

         run pi-acompanhar in h-acomp (input tt-erros-api.num-sequencia-erro).


         find estabelec no-lock where 
              estabelec.cod-estabel = entry(1, tt-erros-api.chave , "~~") no-error.
         find repres    no-lock where
              repres.cod-rep        = int(entry(7, tt-erros-api.chave , "~~")) no-error.

         if avail estabelec and 
            avail repres    then do:

            put skip(1)
                label-cod-estabel       at 05 ": "
                entry(1, tt-erros-api.chave , "~~") "    -  " estabelec.nome skip  
                label-cod-rep           at 02 ": "
                int(entry(7, tt-erros-api.chave , "~~")) "  -  "   repres.nome-abrev skip(1)

                label-cod-canal         at 01
                label-data              at 69
                skip
                label-venda             at 01
                label-gr-cli            at 05
                label-cliente           at 13
                label-nome-ab-reg       at 26
                label-nome-mic-reg      at 39
                label-cd-produto        at 52
                label-inicial           at 69
                label-qt-prevista       at 78
                label-mensagem          at 96
                skip
                fill("-",03) format "x(03)" at 01
                fill("-",04) format "x(04)" at 05
                fill("-",12) format "x(12)" at 13 
                fill("-",12) format "x(12)" at 26 
                fill("-",12) format "x(12)" at 39
                fill("-",16) format "x(16)" at 52
                fill("-",08) format "x(08)" at 69
                fill("-",17) format "x(17)" at 78
                fill("-",40) format "x(50)" at 96 
                skip.

            if entry(2, tt-erros-api.chave , "~~") = 'interroga' then
               put '?' at 01.
            else 
               put entry(2, tt-erros-api.chave , "~~") format "999" at 01. /*canal venda*/

            if entry(3, tt-erros-api.chave , "~~") = 'interroga' then
               put '?' at 05.
            else 
               put entry(3, tt-erros-api.chave , "~~")  at 05. /*grupo cliente*/  

            if entry(4, tt-erros-api.chave , "~~") = 'interroga' then
               put '?' at 13.
            else
               put entry(4, tt-erros-api.chave , "~~") at 13.  /*nome abrev*/

            if entry(5, tt-erros-api.chave , "~~") = 'interroga' then
               put '?' at 26.
            else
               put entry(5, tt-erros-api.chave , "~~") at 26.  /*regi∆o*/

            if entry(6, tt-erros-api.chave , "~~") = 'interroga' then
               put '?' at 39. 
            else
               put entry(6, tt-erros-api.chave , "~~")  at 39. /*microrregi∆o*/

            put entry(8, tt-erros-api.chave , "~~")  at 52 /*produto*/ 
                entry(9, tt-erros-api.chave , "~~")  at 69 /*data inicial*/
                tt-erros-api.des-erro                at 96
                skip.                                    
         end. /* avail estab e repr*/
     end. /*for each tt-erros-api*/
   end. /* return-value nok */

   if return-value = 'ok' then
      assign i-reg-imp = i-reg-lidos.




END PROCEDURE.   



