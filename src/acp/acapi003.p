/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ACAPI003 2.00.00.016}  /*** 010016 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i acapi003 MAC}
&ENDIF

/********************************************************************************
** Programa  : acp/acapi003.p
** Data      : 08/02/1999
** Autor     : Datasul S.A.
** Objetivo  : API que verifica a quantidade dispon°vel em cotas.
** Versoes   : Emerson Wessling - Planner - Criaá∆o - 08/02/1999
********************************************************************************/

def temp-table tt-dados
    field nome-abrev           like ped-venda.nome-abrev
    field nr-docto             like ped-venda.nr-pedcli
    field cod-estabel          like cotas.cod-estabel
    field cod-canal-venda      like cotas.cod-canal-venda
    field cod-gr-cli           like cotas.cod-gr-cli
    field nome-ab-reg          like cotas.nome-ab-reg
    field nome-mic-reg         like cotas.nome-mic-reg
    field cod-rep              like repres.cod-rep
    field it-codigo            like item.it-codigo
    field dt-emissao           like ped-venda.dt-emissao
    field dt-entrega           like ped-item.dt-entrega
    field quantidade           like ped-item.qt-pedida
    index pedido is primary unique nome-abrev nr-docto it-codigo.

def input  param  rw-ped-venda   as rowid        no-undo.
def input  param  dt-ent-item    as date         no-undo.
def input  param  c-it-codigo    as char         no-undo.
def output param  de-saldo-total as dec          no-undo.
def output param  l-achou-cotas  as log  init no no-undo.

def var r-cotas         as rowid                 no-undo.
def var de-quantidade   as dec                   no-undo.
def var l-log-produto   as logical               no-undo.
def var de-saldo-cota   as dec                   no-undo.
def var de-saldo-ped    as dec                   no-undo.
def var de-pontos       as int                   no-undo.
def var c-produto-aux   as char                  no-undo.

{cdp/cdcfgdis.i} /*include para prÇ-processadores*/
      
/***********************************************************************************************************
**************************** Tratamento para o item atual que est† sendo implantando ***********************
************************************************************************************************************/

for first ped-venda fields(cod-estabel no-ab-reppri cod-canal-venda nr-pedcli nome-abrev cod-gr-cli dt-emissao) where
          rowid(ped-venda) = rw-ped-venda :

    /* verifica estabelecimento */
    for first para-ped fields(estab-padrao char-2) no-lock :
        if substring(para-ped.char-2,1,3) = "yes" then
            find par-cota no-lock where
                 par-cota.cod-estabel = para-ped.estab-padrao no-error.
        else    
            find par-cota no-lock where
                 par-cota.cod-estabel = ped-venda.cod-estabel no-error.   
    
        if not avail par-cota then do:
           {utp/ut-table.i mgdis par-cota 1}
           run utp/ut-msgs.p (input "show",
                              input 2,
                              input return-value).
           return.
        end.
        
        if par-cota.gera-faturam = yes then /*somente faturamento*/
           return.
        
    end.
    
    for first emitente fields(nome-mic-reg nome-abrev) no-lock where
              emitente.nome-abrev = ped-venda.nome-abrev :
    end.
    if not avail emitente then return.
    
    for first repres fields(nome-ab-reg nome-abrev cod-rep) no-lock
         where repres.nome-abrev = ped-venda.no-ab-reppri :
    end.     
    if not avail repres then 
       return. 
     
    find first item-cota no-lock where
               item-cota.it-codigo = c-it-codigo no-error.
    if not avail item-cota then
       return.
    else do:
       
       if item-cota.log-produto      and
          par-cota.cont-produto = yes then do: /*controla por produto*/

          /************************************************************ 
          *  PrÇ-Processador para o m¢dulo de Administraá∆o de Cotas
          ************************************************************/
          &if defined (bf_dis_adm_cotas) &then
              for first est-prod-coml fields(cod-produto-coml qt-aplicada) where
                        est-prod-coml.it-codigo = item-cota.it-codigo no-lock :
                   assign de-quantidade = est-prod-coml.qt-aplicada
                          c-it-codigo   = est-prod-coml.cod-produto-coml 
                          l-log-produto = yes.
              end.            
          &else
              for first est-prod fields(cd-produto qt-aplicada) where
                        est-prod.it-codigo = item-cota.it-codigo no-lock :
                   assign de-quantidade = est-prod.qt-aplicada
                          c-it-codigo   = est-prod.cd-produto 
                          l-log-produto = yes.
              end.            
          &endif
       end.
    end.

    &if defined (bf_dis_adm_cotas) &then
        /*tratamento de produto destino*/
        find last  base-cota where
                   base-cota.cod-estabel = par-cota.cod-estabel and
                   base-cota.cd-produto  = c-it-codigo and
                   base-cota.dt-inicial <= ( if par-cota.tipo-data = 1 then
                                                ped-venda.dt-emissao    else
                                                dt-ent-item )  and
                   base-cota.dt-final   >= ( if par-cota.tipo-data = 1 then
                                                ped-venda.dt-emissao    else
                                                dt-ent-item )  no-lock no-error.
        if avail base-cota and
           base-cota.cd-produto <> base-cota.cd-produto-dest then do:
           assign c-produto-aux = base-cota.cd-produto-dest.
           find last  base-cota where
                      base-cota.cod-estabel = par-cota.cod-estabel and
                      base-cota.cd-produto  = c-produto-aux and
                      base-cota.dt-inicial <= ( if par-cota.tipo-data = 1 then
                                                   ped-venda.dt-emissao    else
                                                   dt-ent-item )  and
                      base-cota.dt-final   >= ( if par-cota.tipo-data = 1 then
                                                   ped-venda.dt-emissao    else
                                                   dt-ent-item )  no-lock no-error.
           IF AVAIL base-cota THEN
              ASSIGN c-it-codigo = c-produto-aux.  
        end.
    &endif
     
    find tt-dados
         where tt-dados.nome-abrev = (if par-cota.cont-cliente then ped-venda.nome-abrev else "") 
         and   tt-dados.nr-docto   = ped-venda.nr-pedcli
         and   tt-dados.it-codigo  = (if par-cota.cont-produto then c-it-codigo else par-cota.it-codigo-padrao)
         no-error. 
    
    if not avail tt-dados then do:
        create tt-dados.
        assign tt-dados.nr-docto             = ped-venda.nr-pedcli
               tt-dados.cod-estabel          = par-cota.cod-estabel
               tt-dados.cod-canal-venda      = if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0
               tt-dados.cod-gr-cli           = if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0
               tt-dados.nome-abrev           = if par-cota.cont-cliente then ped-venda.nome-abrev else "" 
               tt-dados.nome-ab-reg          = if par-cota.cont-ab-reg then repres.nome-ab-reg else ""
               tt-dados.nome-mic-reg         = if par-cota.cont-mic-reg then emitente.nome-mic-reg else ""
               tt-dados.cod-rep              = repres.cod-rep
               tt-dados.it-codigo            = if par-cota.cont-produto then c-it-codigo else par-cota.it-codigo-padrao
               tt-dados.dt-emissao           = ped-venda.dt-emissao
               tt-dados.dt-entrega           = dt-ent-item.
    end.
    
    /* Vefifica se existe cotas para este pedido ou nota-fiscal para efetuar a atualizaá∆o */
    
    run acp/acapi004.p (input tt-dados.cod-estabel,
                        input tt-dados.cod-rep,
                        input tt-dados.it-codigo,
                        input (if par-cota.tipo-data = 1 then tt-dados.dt-emissao else tt-dados.dt-entrega),  
                        input tt-dados.cod-canal-venda,
                        input tt-dados.cod-gr-cli,
                        input tt-dados.nome-abrev,
                        input tt-dados.nome-ab-reg,
                        input tt-dados.nome-mic-reg,
                        output r-cotas).
    
    find cotas no-lock
         where rowid(cotas) = r-cotas no-error.
    
    if avail cotas then do:

       assign l-achou-cotas =  yes.

       if par-cota.tipo-controle = 2 then /*valor*/
          if l-log-produto              and
             par-cota.cont-produto = yes then  /*controla por produto ent∆o multipla pelo fator de convers∆o */
             assign de-saldo-cota = ((cotas.vl-previsto * de-quantidade) - (cotas.vl-pedido * de-quantidade)).
          else
             assign de-saldo-cota = (cotas.vl-previsto - cotas.vl-pedido).
       else /*qtde e pontos*/
          if l-log-produto              and
             par-cota.cont-produto = yes then /*controla por produto ent∆o multipla pelo fator de convers∆o */
             assign de-saldo-cota = ((cotas.qt-prevista * de-quantidade) - (cotas.qt-pedida * de-quantidade)).
          else 
             assign de-saldo-cota = (cotas.qt-prevista  - cotas.qt-pedida).
    end.
    
    if de-saldo-cota < 0 then
       assign de-saldo-cota = 0.
    
    assign de-saldo-total = de-saldo-cota.   

    for each tt-dados.
        delete tt-dados.
    end.

end. /*for first ped-venda*/


/**********************************************************************************************************
**************************** tratamento para os outros pedidos, ainda n∆o atualizados em cotas. ***********
***********************************************************************************************************/

if  not program-name(2) matches ("*bogdi033*":U) then do:

    assign de-saldo-ped = 0
           de-pontos    = 0.

    find first para-ped no-lock no-error.
    if  substring(para-ped.char-2,1,3) = "yes" then
        find par-cota no-lock where
             par-cota.cod-estabel = para-ped.estab-padrao no-error.

    for each ped-venda fields(cod-estabel dt-emissao cod-canal-venda cod-gr-cli nome-abrev nr-pedcli) no-lock where
             ped-venda.nome-abrev   = emitente.nome-abrev and
             ped-venda.no-ab-reppri = repres.nome-abrev   and
             ped-venda.completo     = no :

        if  not substring(para-ped.char-2,1,3) = "yes" then    
            find par-cota no-lock where
                 par-cota.cod-estabel = ped-venda.cod-estabel no-error.   

        if  not avail par-cota then
            next.

        for each ped-item fields(nome-abrev nr-pedcli it-codigo dt-entrega vl-preuni qt-pedida) no-lock where
                 ped-item.nome-abrev = ped-venda.nome-abrev and
                 ped-item.nr-pedcli = ped-venda.nr-pedcli and
                 ped-item.it-codigo = c-it-codigo :

            find first item-cota no-lock where
                       item-cota.it-codigo = ped-item.it-codigo no-error.
            if  not avail item-cota then
                next.
            else do:
                if  item-cota.log-produto and
                    par-cota.cont-produto = yes then do: /*controla por produto*/
                    /************************************************************ 
                    *  PrÇ-Processador para o m¢dulo de Administraá∆o de Cotas
                    ************************************************************/
    
                    &if defined (bf_dis_adm_cotas) &then
                        find est-prod-coml where est-prod-coml.it-codigo = item-cota.it-codigo no-lock no-error.
                        if  not avail est-prod-coml then
                            next.
                        else  
                            assign de-quantidade = est-prod-coml.qt-aplicada
                                   c-it-codigo   = est-prod-coml.cod-produto-coml 
                                   l-log-produto = yes.
                    &else
                        find est-prod where est-prod.it-codigo = item-cota.it-codigo no-lock no-error.
                        if  not avail est-prod then 
                            next.
                        else
                            assign de-quantidade = est-prod.qt-aplicada
                                   c-it-codigo   = est-prod.cd-produto 
                                   l-log-produto = yes.
                    &endif
                end.
                else 
                    assign c-it-codigo = ped-item.it-codigo.        
            end.
    
            /*** verifica nr de pontos ****/
            find first base-cota where
                       base-cota.cod-estabel = par-cota.cod-estabel and
                       base-cota.cd-produto  = c-it-codigo  and
                       base-cota.dt-inicial <= (if par-cota.tipo-data = 1 then ped-venda.dt-emissao else ped-item.dt-entrega) no-lock no-error.
    
            if  not avail base-cota then
                next.
    
            find item-cota no-lock where
                 item-cota.it-codigo   = c-it-codigo no-error.
    
            if  par-cota.cont-produto  = yes and
                par-cota.tipo-controle = 3   and
                l-log-produto          = no  then
                assign de-pontos = base-cota.nr-pontos.
            else
                if  par-cota.cont-produto  = no and
                    par-cota.tipo-controle = 3  then  
                    assign de-pontos = item-cota.nr-pontos.
    
            if  par-cota.tipo-controle <> 3 then 
                assign de-pontos = 1.        
            
            /******************************/
    
            &if defined (bf_dis_adm_cotas) &then
    
                if  par-cota.tipo-controle = 2 then /*valor*/
                    if  l-log-produto and
                        par-cota.cont-produto = yes then  /*controla por produto ent∆o multiplica pelo fator de convers∆o */
                        assign de-saldo-ped = de-saldo-ped + ((ped-item.vl-preuni * ped-item.qt-pedida) * de-quantidade).
                   else
                        assign de-saldo-ped = de-saldo-ped + ((ped-item.vl-preuni * ped-item.qt-pedida)) .
                else /*qtde e pontos*/
                   if  l-log-produto and
                       par-cota.cont-produto = yes then /*controla por produto ent∆o multiplica pelo fator de convers∆o */
                       assign de-saldo-ped = de-saldo-ped + ((ped-item.qt-pedida * de-pontos) * de-quantidade).
                   else
                       assign de-saldo-ped = de-saldo-ped + (ped-item.qt-pedida * de-pontos).
            &else

                if  par-cota.tipo-controle = 2 then /*valor*/
                    if  l-log-produto and
                        par-cota.cont-produto = yes then  /*controla por produto ent∆o multipla pelo fator de convers∆o */
                        assign de-saldo-ped = de-saldo-ped + ((ped-item.vl-preuni * ped-item.qt-pedida) / de-quantidade).
                    else
                        assign de-saldo-ped = de-saldo-ped + ((ped-item.vl-preuni * ped-item.qt-pedida)) .
                else /*qtde e pontos*/
                    if  l-log-produto and
                        par-cota.cont-produto = yes then /*controla por produto ent∆o multipla pelo fator de convers∆o */
                        assign de-saldo-ped = de-saldo-ped + ((ped-item.qt-pedida * de-pontos) / de-quantidade).
                    else
                        assign de-saldo-ped = de-saldo-ped + (ped-item.qt-pedida * de-pontos).
            &endif
        end. /* for each ped-item */
    end. /*for each ped-venda*/
end.

if de-saldo-ped < 0 or 
   de-saldo-ped = ? then
   assign de-saldo-ped = 0.

assign de-saldo-total = de-saldo-cota - de-saldo-ped.

if de-saldo-total = ? then
   de-saldo-total = 0.
