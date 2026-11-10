/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC1011RP 2.00.00.012} /*** "010012" 28/02/2025 09:42:30  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac1011rp MAC}
&ENDIF

{include/i_fnctrad.i}
/*******************************************************************************
**
** Ac1011RP.P : C†lculo do mÇdio impress∆o dos parÉmetros do calculo do medio
**
********************************************************************************/
{utp/ut-glob.i}
/* ********************  Definiá∆o de Temp-Table ****************************** */

/* Include pre-processador */
{cdp/cdcfgdis.i}

def temp-table tt-raw-digita
   field raw-digita      as raw.

define temp-table tt-param no-undo
    field destino             as integer
    field arquivo             as char format "x(35)"
    field usuario             as char format "x(12)"
    field data-exec           as date
    field hora-exec           as integer
    field data-ini            AS DATE
    field data-fim            AS DATE 
    field dt-implant-ini      AS DATE
    field dt-implant-fim      AS DATE
    field periodo-ini         like cotas.dt-inicial
    field percentual          as decimal format "->>9,99"
    field opcao               as integer
    field desc-opcao          as char format "x(20)"
    field tab-preco           LIKE tb-preco.nr-tabpre
    field desc-padrao         as decimal format ">>9.99".


define temp-table tt-cotas
    field cod-estabel     like cotas.cod-estabel
    field cod-canal-venda like cotas.cod-canal-venda
    field cd-produto      like cotas.cd-produto
    field cod-gr-cli      like cotas.cod-gr-cli
    field nome-abrev      like emitente.nome-abrev
    field nome-ab-reg     like cotas.nome-ab-reg
    field nome-mic-reg    like cotas.nome-mic-reg
    field cod-rep         like cotas.cod-rep
    field dt-inicial      like cotas.dt-inicial
    field valor           like cotas.qt-prevista
    field quantidade      like cotas.qt-prevista
    field log-item        as   logical init yes
    INDEX codigo IS PRIMARY UNIQUE 
          cod-estabel
          cod-canal-venda
          cod-gr-cli
          nome-abrev
          nome-ab-reg
          nome-mic-reg
          cod-rep
          cd-produto
          dt-inicial.

/* ************************ Definiá∆o de parametros ************************** */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.


/* ************************ Definiá∆o de vari†veis *************************** */

{include/i-rpvar.i}

def var c-selecao        as character format "x(11)"         no-undo.
def var c-parametro      as character format "x(14)"         no-undo.
def var c-impressao      as character format "x(12)"         no-undo.
def var c-destino        as character format "x(10)"         no-undo.
def var i-cont           as integer                          no-undo.
def var h-acomp          as handle                           no-undo.
def var de-percentual    as decimal   format "->>9,99"       no-undo.
def var de-perc-desc     as decimal   format ">>9,99"        no-undo.
def var de-pr-venda      like preco-item.preco-venda         no-undo.
def var c-tabela         like tb-preco.nr-tabpre             no-undo.
def var r-cotas          as rowid                            no-undo.
def var c-it-codigo      like item.it-codigo                 no-undo.
def var l-log-produto    as logical                          no-undo.

/* *********** Definiá∆o do layout da p†gina de parÉmetros ****************** */

form skip(01)
     c-selecao   no-label      skip(1)
     tt-param.data-ini         colon 40 space(6) "|< >|"
     tt-param.data-fim         no-label colon 65 skip
     c-parametro no-label      SKIP(1)
     tt-param.desc-opcao                 colon 40
     tt-param.tab-preco                  colon 40
     tt-param.desc-padrao                colon 40
     de-percentual                       colon 40
     "%":U                    skip
     tt-param.periodo-ini                colon 40 skip(1)
     c-impressao no-label      skip(1)
     c-destino               colon 40
     " - ":U
     tt-param.arquivo no-label format "x(30)":U skip
     tt-param.usuario        colon 40 skip
     with down no-box width 132 side-labels stream-io frame f-parametros1.

form skip(01)
     c-selecao   no-label      skip(1)
     tt-param.data-ini         colon 40 space(6) "|< >|"
     tt-param.data-fim         no-label colon 65 skip
     tt-param.dt-implant-ini   colon 40 space(6) "|< >|"
     tt-param.dt-implant-fim   no-label colon 65 skip
     c-parametro no-label      SKIP(1)
     tt-param.desc-opcao                 colon 40
     tt-param.tab-preco                  colon 40
     tt-param.desc-padrao                colon 40
     de-percentual                       colon 40
     "%":U                    skip
     tt-param.periodo-ini                colon 40 skip(1)
     c-impressao no-label      skip(1)
     c-destino               colon 40
     " - ":U
     tt-param.arquivo no-label format "x(30)":U skip
     tt-param.usuario        colon 40 skip
     with down no-box width 132 side-labels stream-io frame f-parametros2.


/* *********************** Definiá∆o de literais  ***************************** */

{utp/ut-liter.i SELEÄ«O * R}
assign c-selecao = trim(return-value).

{utp/ut-liter.i PAR∂METROS * R}
assign c-parametro = trim(return-value).

{utp/ut-liter.i IMPRESS«O * R}
assign c-impressao = trim(return-value).

{utp/ut-liter.i Destino * L}
assign c-destino:label in frame f-parametros1 = trim(return-value).
assign c-destino:label in frame f-parametros2 = trim(return-value).

{utp/ut-liter.i Usu†rio * L}
assign tt-param.usuario:label in frame f-parametros1 = trim(return-value).
assign tt-param.usuario:label in frame f-parametros2 = trim(return-value).

{utp/ut-liter.i C†lculo_Valor_MÇdio * L}
assign tt-param.desc-opcao:label in frame f-parametros1 = trim(return-value).
assign tt-param.desc-opcao:label in frame f-parametros2 = trim(return-value).

{utp/ut-liter.i Desconto_Padr∆o * L}
assign tt-param.desc-padrao:label in frame f-parametros1 = trim(return-value).
assign tt-param.desc-padrao:label in frame f-parametros2 = trim(return-value).

{utp/ut-liter.i Tabela_Preáo * L}
assign tt-param.tab-preco:label in frame f-parametros1 = trim(return-value).
assign tt-param.tab-preco:label in frame f-parametros2 = trim(return-value).

{utp/ut-liter.i Dt_Inicial_Cotas * L}
assign tt-param.periodo-ini:label in frame f-parametros1 = trim(return-value).
assign tt-param.periodo-ini:label in frame f-parametros2 = trim(return-value).

{utp/ut-liter.i Dt_Implantaá∆o * L}
assign tt-param.dt-implant-ini:label in frame f-parametros2 = trim(return-value).

{utp/ut-liter.i Percentual * L}
assign de-percentual:label in frame f-parametros1 = trim(return-value).
assign de-percentual:label in frame f-parametros2 = trim(return-value).


/* ************************ Inicio do programa ****************************** */
run utp/ut-trfrrp.p (input frame f-parametros2:handle).
run utp/ut-trfrrp.p (input frame f-parametros1:handle).
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param no-error.

find empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
if avail empresa then
   assign c-empresa = empresa.razao-social.

{utp/ut-liter.i Controle_de_Cotas MAP C}
assign c-programa = 'ac1011'
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

{utp/ut-liter.i Calculo_de_Valor_Medio MAP C}
assign c-titulo-relat = return-value.

if tt-param.opcao = 2 then do:
    /********************************************************************/
    /***   C†lculo do Valor MÇdio partindo dos pedidos do per°odo     ***/  
    /********************************************************************/

   run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Aguarde *}
   run pi-inicializar in h-acomp (input  Return-value ).

   find first para-ped no-lock no-error.
   for each ped-venda fields(cod-sit-ped cod-estabel dt-emissao cod-emitente no-ab-reppri nome-abrev
                             nr-pedcli cod-canal-venda cod-gr-cli) no-lock USE-INDEX ch-implant where
            ped-venda.dt-implant >= tt-param.dt-implant-ini AND
            ped-venda.dt-implant <= tt-param.dt-implant-fim AND
            ped-venda.cod-sit-ped <> 6 :

       if substring(para-ped.char-2,1,3) = "yes" then
          find par-cota no-lock 
               where par-cota.cod-estabel = para-ped.estab-padrao no-error.
       else
          find par-cota no-lock
               where par-cota.cod-estabel = ped-venda.cod-estabel no-error.
       if not avail par-cota then next.

       /* quando data de emissao */
       if par-cota.tipo-data = 1 then
          if ped-venda.dt-emissao < tt-param.data-ini and
             ped-venda.dt-emissao > tt-param.data-fim then 
             next.        

       for first emitente fields (cod-emitente nome-abrev nome-mic-reg nome-matriz) no-lock
           where emitente.cod-emitente = ped-venda.cod-emitente.
       end. 
       if not avail emitente then next.

       FOR FIRST repres FIELDS (nome-abrev cod-rep nome-ab-reg) NO-LOCK 
           where repres.nome-abrev = ped-venda.no-ab-reppri.
       END.
       IF NOT AVAIL repres THEN NEXT.

       for each  ped-item fields(nome-abrev nr-pedcli cod-sit-item dt-entrega 
                                 it-codigo qt-pedida vl-preori vl-liq-it) no-lock
           where ped-item.nome-abrev    = ped-venda.nome-abrev
           and   ped-item.nr-pedcli     = ped-venda.nr-pedcli
           and   ped-item.cod-sit-item <> 6:

           /*quando data de entrega*/
           if par-cota.tipo-data = 2 then
              if ped-item.dt-entrega < tt-param.data-ini  and
                 ped-item.dt-entrega > tt-param.data-fim  then
                 next.

           run pi-acompanhar in h-acomp (input ped-item.it-codigo).

          /***** Verifica situaá‰es item - item padr∆o, item controlado produto ****/
           assign l-log-produto = no.

           if not par-cota.cont-produto then do:
               assign c-it-codigo  = par-cota.it-codigo-padrao.
               find item-cota no-lock
                    where item-cota.it-codigo = ped-item.it-codigo no-error.
               if not avail item-cota then next.
           end.
           /*verifica se item Ç controlado por produto*/
           else do:
               find item-cota no-lock
                    where item-cota.it-codigo = ped-item.it-codigo no-error.
               if avail item-cota then do:
                  if item-cota.log-produto and
                     par-cota.cont-produto then do : /*controla por produto*/

                     &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
                         find est-prod-coml where est-prod-coml.it-codigo = item-cota.it-codigo no-lock no-error.
                         assign c-it-codigo   = est-prod-coml.cod-produto-coml
                                l-log-produto = yes.
                     &ELSE
                         find est-prod where est-prod.it-codigo = item-cota.it-codigo no-lock no-error.
                         assign c-it-codigo   = est-prod.cd-produto
                                l-log-produto = yes.
                     &ENDIF       
                  end.
                  else    
                     assign c-it-codigo   = item-cota.it-codigo.  
               end.
               else /*se n∆o existir item-cota*/ 
                   next.
           end.

           run acp/acapi004.p (input par-cota.cod-estabel,
                               input repres.cod-rep,
                               input c-it-codigo,     
                               input (if par-cota.tipo-data  = 1   then ped-venda.dt-emissao else ped-item.dt-entrega ),
                               input (if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0),  
                               input (if par-cota.cont-gr-cli      then ped-venda.cod-gr-cli      else 0),
                               input (if par-cota.cont-cliente     then emitente.nome-abrev       else ""),
                               input (if par-cota.cont-ab-reg      then repres.nome-ab-reg        else ""),
                               input (if par-cota.cont-mic-reg     then emitente.nome-mic-reg     else ""),
                               output r-cotas).  

           IF par-cota.cont-cliente THEN DO:

               FIND cotas NO-LOCK WHERE ROWID(cotas) = r-cotas NO-ERROR.
               IF NOT AVAIL cotas THEN DO:

                   IF emitente.nome-abrev <> emitente.nome-matriz THEN DO:

                       run acp/acapi004.p (input par-cota.cod-estabel,                                                                  
                                           input repres.cod-rep,                                                                        
                                           input c-it-codigo,                                                                           
                                           input (if par-cota.tipo-data  = 1   then ped-venda.dt-emissao else ped-item.dt-entrega ),    
                                           input (if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0),                  
                                           input (if par-cota.cont-gr-cli      then ped-venda.cod-gr-cli      else 0),                  
                                           input emitente.nome-matriz,
                                           input (if par-cota.cont-ab-reg      then repres.nome-ab-reg        else ""),                
                                           input (if par-cota.cont-mic-reg     then emitente.nome-mic-reg     else ""),                
                                           output r-cotas).                                                                            

                   END.

               END.

           END.

           find cotas no-lock
                where rowid(cotas) = r-cotas no-error.

           if not avail cotas then next.

           find tt-cotas
                where tt-cotas.cod-estabel     = cotas.cod-estabel
                and   tt-cotas.cod-canal-venda = cotas.cod-canal-venda 
                and   tt-cotas.cod-gr-cli      = cotas.cod-gr-cli
                and   tt-cotas.nome-abrev      = cotas.nome-abrev
                and   tt-cotas.nome-ab-reg     = cotas.nome-ab-reg
                and   tt-cotas.nome-mic-reg    = cotas.nome-mic-reg
                and   tt-cotas.cod-rep         = cotas.cod-rep
                and   tt-cotas.cd-produto      = cotas.cd-produto
                and   tt-cotas.dt-inicial      = cotas.dt-inicial  no-error.

           if not avail tt-cotas then do:
              create tt-cotas.
              assign tt-cotas.cod-estabel     = cotas.cod-estabel
                     tt-cotas.cod-canal-venda = cotas.cod-canal-venda
                     tt-cotas.cod-gr-cli      = cotas.cod-gr-cli
                     tt-cotas.nome-abrev      = cotas.nome-abrev
                     tt-cotas.nome-ab-reg     = cotas.nome-ab-reg
                     tt-cotas.nome-mic-reg    = cotas.nome-mic-reg
                     tt-cotas.cod-rep         = cotas.cod-rep
                     tt-cotas.cd-produto      = cotas.cd-produto
                     tt-cotas.dt-inicial      = cotas.dt-inicial
                     tt-cotas.quantidade      = ped-item.qt-pedida
                     tt-cotas.valor           = if par-cota.tipo-valor = 1 then (ped-item.qt-pedida * ped-item.vl-preori) else ped-item.vl-liq-it.
           end.
           else do:
              assign tt-cotas.quantidade      = tt-cotas.quantidade + ped-item.qt-pedida
                     tt-cotas.valor           = tt-cotas.valor + if par-cota.tipo-valor = 1 then (ped-item.qt-pedida * ped-item.vl-preori) else ped-item.vl-liq-it.
           end.

           run pi-trata-niveis.   

       end.
   end.

   for each cotas exclusive-lock
       where cotas.dt-inicial = tt-param.periodo-ini:
       find first tt-cotas
            where tt-cotas.cod-estabel     = cotas.cod-estabel
            and   tt-cotas.cod-canal-venda = cotas.cod-canal-venda
            and   tt-cotas.cod-gr-cli      = cotas.cod-gr-cli
            and   tt-cotas.nome-ab-reg     = cotas.nome-ab-reg
            and   tt-cotas.nome-mic-reg    = cotas.nome-mic-reg
            and   tt-cotas.cod-rep         = cotas.cod-rep
            and   tt-cotas.cd-produto      = cotas.cd-produto
            and   tt-cotas.dt-inicial     >= cotas.dt-inicial no-error.

       run pi-acompanhar in h-acomp (input cotas.cd-produto).
       if avail tt-cotas then do:
          assign cotas.vl-medio-prev = (tt-cotas.valor / tt-cotas.quantidade) * (1 + (tt-param.percentual / 100)). 
          if cotas.vl-medio-prev = ? then assign cotas.vl-medio-prev = 0.
       end.
   end.
   run pi-finalizar in h-acomp.

end.
else do:
    /********************************************************************/
    /***   C†lculo do Valor MÇdio partindo da tabela de preáos        ***/
    /********************************************************************/

   run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Aguarde *}
   run pi-inicializar in h-acomp (input  Return-value ).

   if tt-param.desc-padrao <> 0 then
      assign de-perc-desc = (100 - tt-param.desc-padrao) / 100.

   find tb-preco no-lock 
        where tb-preco.nr-tabpre = tt-param.tab-preco and
              tb-preco.dt-inival = tt-param.data-ini AND
              tb-preco.dt-fimval = tt-param.data-fim no-error.

   if avail tb-preco then
      assign c-tabela = tb-preco.nr-tabpre.

   for each cotas
       where cotas.dt-inicial >= tt-param.periodo-ini
       and   cotas.dt-inicial <= tt-param.periodo-ini EXCLUSIVE-LOCK
       break by cotas.cd-produto :

       run pi-acompanhar in h-acomp (input cotas.cd-produto).

       find first preco-item no-lock 
            where preco-item.nr-tabpre = c-tabela
            and   preco-item.it-codigo = cotas.cd-produto  
            no-error.
       if  avail preco-item then do:
           assign cotas.vl-medio-prev = (preco-item.preco-venda * de-perc-desc). 
           if cotas.vl-medio-prev = ? then 
              assign cotas.vl-medio-prev = 0.
       end.
   end.    
   run pi-finalizar in h-acomp.
end.

/** Cria n°veis em Cotas, caso seja controlado por n°veis - release 2.03 **/
procedure pi-trata-niveis.

&IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */

if par-cota.log-impl-niveis = yes then do:

    if par-cota.cont-mic-reg then do:
       find tt-cotas
            where tt-cotas.cod-estabel     = cotas.cod-estabel
            and   tt-cotas.cod-canal-venda = cotas.cod-canal-venda 
            and   tt-cotas.cod-gr-cli      = cotas.cod-gr-cli
            and   tt-cotas.nome-abrev      = cotas.nome-abrev
            and   tt-cotas.nome-ab-reg     = cotas.nome-ab-reg
            and   tt-cotas.nome-mic-reg    = cotas.nome-mic-reg
            and   tt-cotas.cod-rep         = ? 
            and   tt-cotas.cd-produto      = cotas.cd-produto
            and   tt-cotas.dt-inicial      = cotas.dt-inicial  no-error.
       if not avail tt-cotas then do:
          create tt-cotas.
          assign tt-cotas.cod-estabel     = cotas.cod-estabel
                 tt-cotas.cod-canal-venda = cotas.cod-canal-venda
                 tt-cotas.cod-gr-cli      = cotas.cod-gr-cli
                 tt-cotas.nome-abrev      = cotas.nome-abrev
                 tt-cotas.nome-ab-reg     = cotas.nome-ab-reg
                 tt-cotas.nome-mic-reg    = cotas.nome-mic-reg
                 tt-cotas.cod-rep         = ?
                 tt-cotas.cd-produto      = cotas.cd-produto
                 tt-cotas.dt-inicial      = cotas.dt-inicial
                 tt-cotas.quantidade      = ped-item.qt-pedida
                 tt-cotas.valor           = if par-cota.tipo-valor = 1 then (ped-item.qt-pedida * ped-item.vl-preori) else ped-item.vl-liq-it.
       end.
       else
          assign tt-cotas.quantidade      = tt-cotas.quantidade + ped-item.qt-pedida
                 tt-cotas.valor           = tt-cotas.valor + if par-cota.tipo-valor = 1 then (ped-item.qt-pedida * ped-item.vl-preori) else ped-item.vl-liq-it.
    end. /* if par-cota */

    if par-cota.cont-ab-reg then do:
       find tt-cotas
            where tt-cotas.cod-estabel     = cotas.cod-estabel
            and   tt-cotas.cod-canal-venda = cotas.cod-canal-venda 
            and   tt-cotas.cod-gr-cli      = cotas.cod-gr-cli
            and   tt-cotas.nome-abrev      = cotas.nome-abrev
            and   tt-cotas.nome-ab-reg     = cotas.nome-ab-reg
            and   tt-cotas.nome-mic-reg    = (if par-cota.cont-mic-reg then ? else "") 
            and   tt-cotas.cod-rep         = ? 
            and   tt-cotas.cd-produto      = cotas.cd-produto
            and   tt-cotas.dt-inicial      = cotas.dt-inicial  no-error.
       if not avail tt-cotas then do:
          create tt-cotas.
          assign tt-cotas.cod-estabel     = cotas.cod-estabel
                 tt-cotas.cod-canal-venda = cotas.cod-canal-venda
                 tt-cotas.cod-gr-cli      = cotas.cod-gr-cli
                 tt-cotas.nome-abrev      = cotas.nome-abrev
                 tt-cotas.nome-ab-reg     = cotas.nome-ab-reg
                 tt-cotas.nome-mic-reg    = (if par-cota.cont-mic-reg then ? else "")  
                 tt-cotas.cod-rep         = ?
                 tt-cotas.cd-produto      = cotas.cd-produto
                 tt-cotas.dt-inicial      = cotas.dt-inicial
                 tt-cotas.quantidade      = ped-item.qt-pedida
                 tt-cotas.valor           = if par-cota.tipo-valor = 1 then (ped-item.qt-pedida * ped-item.vl-preori) else ped-item.vl-liq-it.
       end.
       else
          assign tt-cotas.quantidade      = tt-cotas.quantidade + ped-item.qt-pedida
                 tt-cotas.valor           = tt-cotas.valor + if par-cota.tipo-valor = 1 then (ped-item.qt-pedida * ped-item.vl-preori) else ped-item.vl-liq-it.
    end.

    if par-cota.cont-cliente then do:
       find tt-cotas
            where tt-cotas.cod-estabel     = cotas.cod-estabel
            and   tt-cotas.cod-canal-venda = cotas.cod-canal-venda 
            and   tt-cotas.cod-gr-cli      = cotas.cod-gr-cli
            and   tt-cotas.nome-abrev      = cotas.nome-abrev
            and   tt-cotas.nome-ab-reg     = (if par-cota.cont-ab-reg then ? else "")
            and   tt-cotas.nome-mic-reg    = (if par-cota.cont-mic-reg then ? else "") 
            and   tt-cotas.cod-rep         = ? 
            and   tt-cotas.cd-produto      = cotas.cd-produto
            and   tt-cotas.dt-inicial      = cotas.dt-inicial  no-error.
       if not avail tt-cotas then do:
          create tt-cotas.
          assign tt-cotas.cod-estabel     = cotas.cod-estabel
                 tt-cotas.cod-canal-venda = cotas.cod-canal-venda
                 tt-cotas.cod-gr-cli      = cotas.cod-gr-cli
                 tt-cotas.nome-abrev      = cotas.nome-abrev
                 tt-cotas.nome-ab-reg     = (if par-cota.cont-ab-reg then ? else "")
                 tt-cotas.nome-mic-reg    = (if par-cota.cont-mic-reg then ? else "")  
                 tt-cotas.cod-rep         = ?
                 tt-cotas.cd-produto      = cotas.cd-produto
                 tt-cotas.dt-inicial      = cotas.dt-inicial
                 tt-cotas.quantidade      = ped-item.qt-pedida
                 tt-cotas.valor           = if par-cota.tipo-valor = 1 then (ped-item.qt-pedida * ped-item.vl-preori) else ped-item.vl-liq-it.
       end.
       else
          assign tt-cotas.quantidade      = tt-cotas.quantidade + ped-item.qt-pedida
                 tt-cotas.valor           = tt-cotas.valor + if par-cota.tipo-valor = 1 then (ped-item.qt-pedida * ped-item.vl-preori) else ped-item.vl-liq-it.
    end. /* if par-cota */        

    if par-cota.cont-gr-cli then do:
       find tt-cotas
            where tt-cotas.cod-estabel     = cotas.cod-estabel
            and   tt-cotas.cod-canal-venda = cotas.cod-canal-venda 
            and   tt-cotas.cod-gr-cli      = cotas.cod-gr-cli
            and   tt-cotas.nome-abrev      = (if par-cota.cont-cliente then ? else "")
            and   tt-cotas.nome-ab-reg     = (if par-cota.cont-ab-reg then ? else "")
            and   tt-cotas.nome-mic-reg    = (if par-cota.cont-mic-reg then ? else "") 
            and   tt-cotas.cod-rep         = ? 
            and   tt-cotas.cd-produto      = cotas.cd-produto
            and   tt-cotas.dt-inicial      = cotas.dt-inicial  no-error.
       if not avail tt-cotas then do:
          create tt-cotas.
          assign tt-cotas.cod-estabel     = cotas.cod-estabel
                 tt-cotas.cod-canal-venda = cotas.cod-canal-venda
                 tt-cotas.cod-gr-cli      = cotas.cod-gr-cli
                 tt-cotas.nome-abrev      = (if par-cota.cont-cliente then ? else "")
                 tt-cotas.nome-ab-reg     = (if par-cota.cont-ab-reg then ? else "")
                 tt-cotas.nome-mic-reg    = (if par-cota.cont-mic-reg then ? else "")  
                 tt-cotas.cod-rep         = ?
                 tt-cotas.cd-produto      = cotas.cd-produto
                 tt-cotas.dt-inicial      = cotas.dt-inicial
                 tt-cotas.quantidade      = ped-item.qt-pedida
                 tt-cotas.valor           = if par-cota.tipo-valor = 1 then (ped-item.qt-pedida * ped-item.vl-preori) else ped-item.vl-liq-it.
       end.
       else
          assign tt-cotas.quantidade      = tt-cotas.quantidade + ped-item.qt-pedida
                 tt-cotas.valor           = tt-cotas.valor + if par-cota.tipo-valor = 1 then (ped-item.qt-pedida * ped-item.vl-preori) else ped-item.vl-liq-it.
    end. /* if par-cota */        

    if par-cota.Cont-canal-venda then do:
       find tt-cotas
            where tt-cotas.cod-estabel      = cotas.cod-estabel
            and   tt-cotas.cod-canal-venda  = cotas.cod-canal-venda 
            and   tt-cotas.cod-gr-cli       = (if par-cota.cont-gr-cli then ? else 0)
            and   tt-cotas.nome-abrev       = (if par-cota.cont-cliente then ? else "")
            and   tt-cotas.nome-ab-reg      = (if par-cota.cont-ab-reg then ? else "")
            and   tt-cotas.nome-mic-reg     = (if par-cota.cont-mic-reg then ? else "") 
            and   tt-cotas.cod-rep          = ? 
            and   tt-cotas.cd-produto       = cotas.cd-produto
            and   tt-cotas.dt-inicial       = cotas.dt-inicial  no-error.
       if not avail tt-cotas then do:
          create tt-cotas.
          assign tt-cotas.cod-estabel     = cotas.cod-estabel
                 tt-cotas.cod-canal-venda = cotas.cod-canal-venda
                 tt-cotas.cod-gr-cli      = (if par-cota.cont-gr-cli then ? else 0)
                 tt-cotas.nome-abrev      = (if par-cota.cont-cliente then ? else "")
                 tt-cotas.nome-ab-reg     = (if par-cota.cont-ab-reg then ? else "")
                 tt-cotas.nome-mic-reg    = (if par-cota.cont-mic-reg then ? else "")  
                 tt-cotas.cod-rep         = ?
                 tt-cotas.cd-produto      = cotas.cd-produto
                 tt-cotas.dt-inicial      = cotas.dt-inicial
                 tt-cotas.quantidade      = ped-item.qt-pedida
                 tt-cotas.valor           = if par-cota.tipo-valor = 1 then (ped-item.qt-pedida * ped-item.vl-preori) else ped-item.vl-liq-it.
       end.
       else
          assign tt-cotas.quantidade      = tt-cotas.quantidade + ped-item.qt-pedida
                 tt-cotas.valor           = tt-cotas.valor + if par-cota.tipo-valor = 1 then (ped-item.qt-pedida * ped-item.vl-preori) else ped-item.vl-liq-it.

    end. /* if par-cota */                          

end. /*log-impl-niveis*/

&ENDIF

end procedure.

/* **************** Impress∆o da p†gina de parÉmetros ************* */

{include/i-rpout.i}
view frame f-cabec.
view frame f-rodape.

assign de-percentual = tt-param.percentual * 100.

IF  tt-param.opcao = 1 THEN DO:

    {utp/ut-liter.i Per°odo_Tab_Preáo * L}
    assign tt-param.data-ini:label in frame f-parametros1 = trim(return-value).

    disp c-selecao
         tt-param.data-ini
         tt-param.data-fim
         c-parametro no-label
         tt-param.desc-opcao
         tt-param.tab-preco
         tt-param.desc-padrao        
         tt-param.periodo-ini
         de-percentual
         c-impressao
         c-destino               
         tt-param.arquivo 
         tt-param.usuario 
         with frame f-parametros1.

    down with frame f-parametros1.
END.
ELSE DO: 

    FIND FIRST par-cota NO-LOCK NO-ERROR.
    IF AVAIL par-cota THEN 
      IF par-cota.tipo-data = 1 THEN DO:     
         {utp/ut-liter.i Dt_Emiss∆o * L}
         assign tt-param.data-ini:label in frame f-parametros2 = trim(return-value).
      END.
      ELSE DO:
         {utp/ut-liter.i Dt_Entrega * L}
         assign tt-param.data-ini:label in frame f-parametros2 = trim(return-value).
      END.


    disp c-selecao
         tt-param.dt-implant-ini
         tt-param.dt-implant-fim
         tt-param.data-ini
         tt-param.data-fim
         c-parametro no-label
         tt-param.desc-opcao
         tt-param.tab-preco
         tt-param.desc-padrao        
         tt-param.periodo-ini
         de-percentual
         c-impressao
         c-destino               
         tt-param.arquivo 
         tt-param.usuario 
         with frame f-parametros2.
    down with frame f-parametros2.     

END.

{include/i-rpclo.i}

return "ok".

