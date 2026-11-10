/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC1012RP 2.00.00.014} /*** "010014" 22/05/2025 16:59:47  ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac1012rp MAC}
&ENDIF

/*******************************************************************************
**
**   Programa: ac1012rp.p
**   Autor...: Datasul S/A.
**   Objetivo: Geraá∆o Base Cota baseado em cotas per°odos anteriores
**   Data....: Maráo de 1999
*********************************************************************************/
{utp/ut-glob.i}

/* Temporary Table Definitions ---                                      */
define temp-table tt-param
    field destino          as integer
    field arquivo          as char
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field cod-estab-ini    like cotas.cod-estabel
    field cod-estab-fim    like cotas.cod-estabel
    field periodo-ini      like cotas.dt-inicial
    field periodo-fim      like cotas.dt-inicial
    field origem           as integer
    field tg-deleta        as log
    field dt-inicial       like cotas.dt-inicial
    field dt-final         like cotas.dt-final.


def temp-table tt-raw-digita
   field raw-digita      as raw.

def temp-table tt-base-cota
   field cod-estabel like base-cota.cod-estabel
   field cd-produto  like base-cota.cd-produto
   field nr-pontos   like item-cota.nr-pontos
   field quantidade  like base-cota.qt-prevista.

/* ************************ Definiá∆o de parametros ************************** */

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

/* ************************ Definiá∆o de Vari†veis ************************** */

{include/i-rpvar.i}        

def var l-est-unico        as logical                     no-undo.
def var h-acomp            as handle                      no-undo.
def var c-selecao          as character format "x(11)"    no-undo.
def var c-parametro        as character format "x(14)"    no-undo.
def var c-impressao        as character format "x(12)"    no-undo.
def var c-destino          as character format "x(10)"    no-undo.
def var c-origem           as character format "x(20)"    no-undo. 

def var de-quantidade      like est-prod.qt-aplicada      no-undo.
def var l-log-produto      as logical                     no-undo.
def var c-it-codigo        like item-cota.it-codigo       no-undo.
def var de-tot-pct-rat     as decimal format ">>9.99"     no-undo.
def var de-valor-aux       as decimal format "->>>,>>>,>>9.99999" no-undo.

def var c-estabel          as character format "x(07)"    no-undo.
def var c-prevista         as character format "x(08)"    no-undo.

def var de-vl-devol-liq    like item-doc-est.valor-ipi[1] no-undo.
def var de-vl-devol-bru    like item-doc-est.valor-ipi[1] no-undo.
def var de-quant-devol     like devol-cli.qt-devolvida    no-undo. 

/* ************************** Definiá∆o de Form ****************************** */

form skip(01)
     base-cota.cod-estabel
     base-cota.cd-produto
     tt-param.dt-inicial
     tt-param.dt-final
     base-cota.nr-pontos
     base-cota.qt-prevista
     with  down width 132 stream-io frame f-tit.

form skip(01)
     c-selecao               no-label skip(1)
     tt-param.cod-estab-ini  colon 40 space(12) "|< >|"
     tt-param.cod-estab-fim  no-label colon 73 skip
     tt-param.periodo-ini    colon 40 space(7)  "|< >|"
     tt-param.periodo-fim    no-label colon 73 skip
     c-parametro no-label    skip(1)
     c-origem                colon 40
     tt-param.tg-deleta      colon 40
     tt-param.dt-inicial     colon 40 skip(1)
     c-impressao no-label    skip(1)
     c-destino               colon 40
     " - ":U
     tt-param.arquivo        no-label format "x(60)":U skip
     tt-param.usuario        colon 40 skip
     with down no-box side-labels width 132 stream-io frame f-parametros.

/* ****************************** Literais ********************************** */
{utp/ut-liter.i SELEÄ«O * R}
assign c-selecao = trim(return-value).
{utp/ut-liter.i PAR∂METROS * R}
assign c-parametro = trim(return-value).
{utp/ut-liter.i IMPRESS«O * R}
assign c-impressao = trim(return-value).
{utp/ut-liter.i Destino * L}
assign c-destino:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Usu†rio * L}
assign tt-param.usuario:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Origem_Base_Cotas * L}
assign c-origem:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Elimina_Base_Cota_Anterior * L}
assign tt-param.tg-deleta:label in frame f-parametros = trim(return-value).
{utp/ut-field.i mgdis base-cota cod-estabel 2}
assign c-estabel = trim(return-value).
{utp/ut-liter.i Prevista * R}
assign c-prevista = trim(return-value).
{utp/ut-liter.i Produto/Item}
assign base-cota.cd-produto:label in frame f-tit = trim(return-value).

/* ************************************************************************* */
run utp/ut-trfrrp.p (input frame f-parametros:handle).
run utp/ut-trfrrp.p (input frame f-tit:handle).
{include/i-rpcab.i}


/** Include de pre-processadores **/
{cdp/cdcfgdis.i}

create tt-param.
raw-transfer raw-param to tt-param.

run utp/ut-acomp.p persistent set h-acomp.  
run pi-inicializar in h-acomp (input "Aguarde...").

find empresa 
     where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.

{utp/ut-liter.i Cotas mac c}                 
assign c-programa = "AC1012"
       c-empresa  = empresa.razao-social
       c-sistema  = trim(return-value)
       c-destino  = {varinc/var00002.i 04 tt-param.destino}.

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.


/* Controla estabelecimento unico */
find first para-ped no-lock no-error.
if substring(para-ped.char-2, 1, 3) = "yes" then do:
   find par-cota no-lock
        where par-cota.cod-estabel = para-ped.estab-padrao no-error.
   if avail par-cota then 
      assign l-est-unico = yes.     
   else do: 
      {utp/ut-table.i mgdis par-cota 1}
      run utp/ut-msgs.p (input "msg",
                         input 2,
                         input return-value).
      put return-value at 5 format "x(100)".
      return.
   end.
end.

main-block:
do  on error  undo main-block, leave main-block
    on endkey undo main-block, leave main-block
    on stop   undo main-block, leave main-block:

    /********************************************************************/
    /*** Apaga todos os registros da selecionados da tabela base-cota ***/
    /********************************************************************/

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Eliminando_Base_Cotas_Anterior" *}
    run pi-acompanhar in h-acomp (input RETURN-VALUE + " ..." ).

    /* elimina base de cota anterior */
    if tt-param.tg-deleta then 
       for each base-cota fields() exclusive-lock where
                base-cota.cod-estabel >= tt-param.cod-estab-ini   and
                base-cota.cod-estabel <= tt-param.cod-estab-fim   and
                base-cota.dt-inicial   = tt-param.dt-inicial      :

                delete base-cota.
       end.

    /****************************************************************/
    /*** C†lculo da Base de Cotas de acordo com o tipo escolhido ***/
    /****************************************************************/
    if tt-param.origem = 1 then
       run pi-cotas.
    if tt-param.origem = 2 then
       run pi-pedidos.
    if tt-param.origem = 3 then
       run pi-faturados.

    /* Gera Base de Cota a partir da temp-table*/
    for each tt-base-cota.
       find base-cota exclusive-lock where
            base-cota.cod-estabel = tt-base-cota.cod-estabel and
            base-cota.cd-produto  = tt-base-cota.cd-produto  and
            base-cota.dt-inicial  = tt-param.dt-inicial  no-error.
       if not avail base-cota then do:
          create base-cota.
          assign base-cota.cod-estabel = tt-base-cota.cod-estabel
                 base-cota.cd-produto  = tt-base-cota.cd-produto
          /* pre-processador para a release 2.03 */ 
          &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
                 base-cota.cd-produto-dest = tt-base-cota.cd-produto          
          &ENDIF
                 base-cota.dt-inicial  = tt-param.dt-inicial
                 base-cota.dt-final    = tt-param.dt-final
                 base-cota.nr-pontos   = tt-base-cota.nr-pontos
                 base-cota.qt-prevista = tt-base-cota.quantidade .


       end.
       else
          assign base-cota.qt-prevista = base-cota.qt-prevista + tt-base-cota.quantidade.
    end. /*for each tt-base-cota*/

    /* impress∆o da base gerada*/ 
    for each base-cota no-lock where
             base-cota.cod-estabel >= tt-param.cod-estab-ini   and
             base-cota.cod-estabel <= tt-param.cod-estab-fim   and
             base-cota.dt-inicial   = tt-param.dt-inicial      :

        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Imprimindo" *}
        run pi-acompanhar in h-acomp (input RETURN-VALUE + " ..." ).

        disp base-cota.cod-estabel
             base-cota.cd-produto
             tt-param.dt-inicial
             tt-param.dt-final
             base-cota.nr-pontos 
             base-cota.qt-prevista  
             with frame f-tit.    
         down with frame f-tit.

    end. /*for each base-cota.*/
end. /*bloco*/   

run pi-finalizar in h-acomp. 

/* **************** Impress∆o da p†gina de parÉmetros ************* */

if  page-number > 0 then page.
display c-selecao 
        tt-param.cod-estab-ini
        tt-param.cod-estab-fim
        tt-param.periodo-ini
        tt-param.periodo-fim
        c-parametro
        tt-param.dt-inicial   
        c-impressao
        c-destino
        tt-param.arquivo        
        tt-param.usuario
        with frame f-parametros.
if tt-param.origem = 1 then
   {utp/ut-liter.i Cotas_Realizadas MAC c} 
if tt-param.origem = 2 then
   {utp/ut-liter.i Pedidos MAC c} 
if tt-param.origem = 3 then
   {utp/ut-liter.i Faturamento MAC c} 
disp trim(return-value) @ c-origem 
     with frame f-parametros.

if  tt-param.tg-deleta = yes then  
    {utp/ut-liter.i Sim * R} 
else 
    {utp/ut-liter.i N∆o * R}.

disp trim(return-value) @ tt-param.tg-deleta 
     with frame f-parametros.

{include/i-rpclo.i}
Return "OK".
/*fim-do-programa*/


/* ************************************ Procedures Internas ************************************ */

/* ************************************ Procedure Base de Cotas por Cotas ************************************ */
procedure pi-cotas.
    for each cotas no-lock where
             cotas.cod-estabel >= (if l-est-unico then para-ped.estab-padrao else tt-param.cod-estab-ini) and
             cotas.cod-estabel <= (if l-est-unico then para-ped.estab-padrao else tt-param.cod-estab-fim) and
             cotas.dt-inicial  >= tt-param.periodo-ini                                                    and
             cotas.dt-inicial  <= tt-param.periodo-fim                                                    and
             cotas.cod-rep     <> ? : 

        run pi-acompanhar in h-acomp (input cotas.cd-produto).

        find par-cota where 
             par-cota.cod-estabel = cotas.cod-estabel no-lock no-error.
        if not avail par-cota then next.

        find item-cota no-lock
             where item-cota.it-codigo = cotas.cd-produto no-error.
        if not avail item-cota then next.             

        /* pre-processador para a release 2.03 */
        &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
            if par-cota.cont-canal-venda then do:
               /* Verifica se o canal controla cotas para o periodo */ 
               if not can-find(first canal-venda no-lock where 
                                     canal-venda.cod-canal-venda      = cotas.cod-canal-venda and
                                     canal-venda.dat-inic-ctrl-cotas <= cotas.dt-inicial) then 
                   next.      
            end.
        &ENDIF         


        find tt-base-cota 
             where tt-base-cota.cod-estabel = cotas.cod-estabel and
                   tt-base-cota.cd-produto  = cotas.cd-produto  no-error.
        if not avail tt-base-cota then do:
           create tt-base-cota.
           assign tt-base-cota.cod-estabel  = cotas.cod-estabel
                  tt-base-cota.cd-produto   = cotas.cd-produto
                  tt-base-cota.nr-pontos    = if par-cota.cont-produto = yes then item-cota.nr-pontos else 0.
                  if par-cota.tipo-controle = 2 then /*controle por valor*/        
                     assign  tt-base-cota.quantidade  = cotas.vl-previsto.
                  else /*controle por qtde/pontos*/
                     assign  tt-base-cota.quantidade  = cotas.qt-prevista.
        end.
        else do:
            if par-cota.tipo-controle = 2 then /*controle por valor*/        
               assign  tt-base-cota.quantidade  = tt-base-cota.quantidade + cotas.vl-previsto.
            else /*controle por qtde/pontos*/
               assign  tt-base-cota.quantidade  = tt-base-cota.quantidade + cotas.qt-prevista.
        end.
    end.         
end procedure.

/* ************************************ Procedure Base de Cotas por Pedidos ************************************ */

procedure pi-pedidos.

    for each ped-venda fields(cod-sit-ped cod-sit-com nr-pedcli cod-estabel 
                              dt-emissao cod-canal-venda nome-abrev) no-lock where
             ped-venda.cod-sit-ped <> 6 /*cancelado*/     
         and ped-venda.cod-sit-com <> 3 /*atendido total*/:       

        run pi-acompanhar in h-acomp (input ped-venda.nr-pedcli).

        if substring(para-ped.char-2, 1, 3) = "yes" then 
           find par-cota no-lock
                where par-cota.cod-estabel = para-ped.estab-padrao no-error.
        else         
           find par-cota no-lock
                where par-cota.cod-estabel = ped-venda.cod-estabel no-error.
        if not avail par-cota then next. 

        /* quando data de emissao */
        if par-cota.tipo-data = 1 then do:
           if ped-venda.dt-emissao < tt-param.periodo-ini or
              ped-venda.dt-emissao > tt-param.periodo-fim then 
              next.        

           /* pre-processador para a release 2.03 */
           &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
               if par-cota.cont-canal-venda then do:
                  /* Verifica se o canal controla cotas para o periodo */ 
                  if not can-find(first canal-venda no-lock where 
                                        canal-venda.cod-canal-venda      = ped-venda.cod-canal-venda and
                                        canal-venda.dat-inic-ctrl-cotas <= ped-venda.dt-emissao) then  
                     next.      
               end. 
           &ENDIF 
        end.


        for each ped-item fields(nome-abrev nr-pedcli cod-sit-item cod-sit-com nat-operacao
                                 it-codigo dt-entrega vl-preuni qt-pedida vl-liq-it qt-pedida) no-lock
            where ped-item.nome-abrev    = ped-venda.nome-abrev
            and   ped-item.nr-pedcli     = ped-venda.nr-pedcli
            and   ped-item.cod-sit-item <> 6 /*cancelado*/
            and   ped-item.cod-sit-com  <> 3 /*atendido total*/ :

            &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
                if not can-find ( first natur-oper where
                                        natur-oper.nat-operacao = ped-item.nat-operacao and
                                        natur-oper.log-atual-cotas = yes) 
                   then next.              

            &else
                if not can-find ( first natur-oper where
                                        natur-oper.nat-operacao = ped-item.nat-operacao and
                                        substr(natur-oper.char-2,31,1) = "1") 
                   then next.       
            &endif                      

            run pi-acompanhar in h-acomp (input ped-item.it-codigo).

            /*quando data de entrega*/
            if par-cota.tipo-data = 2 then do:
               if ped-item.dt-entrega < tt-param.periodo-ini or 
                  ped-item.dt-entrega > tt-param.periodo-fim then 
                  next. 
               /* pre-processador para a release 2.03 */
               &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
                   if par-cota.cont-canal-venda then do:
                      /* Verifica se o canal controla cotas para o periodo */ 
                      if not can-find(first canal-venda no-lock where 
                                            canal-venda.cod-canal-venda      = ped-venda.cod-canal-venda and
                                            canal-venda.dat-inic-ctrl-cotas <= ped-item.dt-entrega) then  
                         next.      
                   end. 
               &ENDIF            
            end. 

            assign l-log-produto = no.

            /* trata o item. se Ç item padr∆o ou se Ç controlado por produto*/
            if not par-cota.cont-produto then do:
                assign c-it-codigo = par-cota.it-codigo-padrao.
                find item-cota no-lock
                     where item-cota.it-codigo = par-cota.it-codigo-padrao no-error.
                if not avail item-cota then next.     
            end.
            else do:
                find item-cota no-lock
                     where item-cota.it-codigo = ped-item.it-codigo no-error.
                if avail item-cota then do:
                   if item-cota.log-produto and
                      par-cota.cont-produto then do : /*controla por produto*/
                      /* pre-processador para a release 2.03 */ 
                      &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
                          find est-prod-coml where est-prod-coml.it-codigo = item-cota.it-codigo no-lock no-error.
                          assign de-quantidade = est-prod-coml.qt-aplicada
                                 c-it-codigo   = est-prod-coml.cod-produto-coml
                                 l-log-produto = yes.
                      &ELSE
                          find est-prod where est-prod.it-codigo = item-cota.it-codigo no-lock no-error.
                          assign de-quantidade = est-prod.qt-aplicada
                                 c-it-codigo   = est-prod.cd-produto
                                 l-log-produto = yes.
                      &ENDIF
                   end.
                   else    
                      assign c-it-codigo   = item-cota.it-codigo.  
                end.
                else /*se n∆o existir item-cota*/ 
                    next.
            end.

            if par-cota.tipo-controle = 2 then do: /*controla por valor*/
                /* calcula valor bruto ou liquido*/            
                if par-cota.tipo-valor = 1 then
                   assign de-valor-aux = ped-item.vl-preuni * ped-item.qt-pedida. 
                else   
                   assign de-valor-aux = ped-item.vl-liq-it * ped-item.qt-pedida. 
            end.
            else /*controla por pontos ou quantidade*/
                assign de-valor-aux = ped-item.qt-pedida * if par-cota.tipo-controle = 3 then item-cota.nr-pontos else 1. 

            &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR 2.03*/
                /* caso seja controlado por produto - multiplica */  
                if l-log-produto then
                   assign de-valor-aux = de-valor-aux * de-quantidade.
            &ELSE
                /* caso seja controlado por produto - divide */  
                if l-log-produto then
                   assign de-valor-aux = de-valor-aux / de-quantidade.
            &ENDIF   

            /* cria tt-base-cota */
            find tt-base-cota exclusive-lock 
                 where tt-base-cota.cod-estabel = ped-venda.cod-estabel and 
                       tt-base-cota.cd-produto  = c-it-codigo no-error.
            if not avail tt-base-cota then do:
               create tt-base-cota.
               assign tt-base-cota.cod-estabel = ped-venda.cod-estabel
                      tt-base-cota.cd-produto  = c-it-codigo
                      tt-base-cota.nr-pontos   = (if par-cota.cont-produto = yes then item-cota.nr-pontos else 0)
                      tt-base-cota.quantidade  = de-valor-aux.
            end.
            else
               assign tt-base-cota.quantidade  = tt-base-cota.quantidade + de-valor-aux.

        end. /*for each ped-item*/
    end. /*for each ped-venda*/
end procedure.

/* ************************************ Procedure Base de Cotas por Faturados ************************************ */

procedure pi-faturados.


    for each nota-fiscal fields(dt-emis-nota dt-cancela nr-nota-fis 
                                cod-estabel cod-canal-venda serie) use-index ch-sit-nota no-lock where
             nota-fiscal.dt-emis-nota >= tt-param.periodo-ini                                                    and
             nota-fiscal.dt-emis-nota <= tt-param.periodo-fim                                                    and 
             nota-fiscal.dt-cancela    = ?: /*notas canceladas*/ 

       run pi-acompanhar in h-acomp (input nota-fiscal.nr-nota-fis).

       if substring(para-ped.char-2, 1, 3) = "yes" then 
          find par-cota no-lock
               where par-cota.cod-estabel = para-ped.estab-padrao no-error.
       else         
          find par-cota no-lock
               where par-cota.cod-estabel = nota-fiscal.cod-estabel no-error.
       if not avail par-cota then next. 

       /* uso de pre-processador */
       &if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */
          if par-cota.cont-canal-venda then do:
             /* quando canal venda n∆o controla cotas */
             if not can-find(first canal-venda where
                                   canal-venda.cod-canal-venda      = nota-fiscal.cod-canal-venda and
                                   canal-venda.dat-inic-ctrl-cotas <= nota-fiscal.dt-emis-nota)        then
                next.                                    
          end.
       &endif

       for each  it-nota-fisc fields(cod-estabel serie nr-nota-fis dt-cancela nat-operacao it-codigo
                                     vl-preuni qt-faturada[1] vl-merc-sicm nr-seq-fat) no-lock
           where it-nota-fisc.cod-estabel  = nota-fiscal.cod-estabel
           and   it-nota-fisc.serie        = nota-fiscal.serie
           and   it-nota-fisc.nr-nota-fis  = nota-fiscal.nr-nota-fis
           and   it-nota-fisc.dt-cancela   = ?:

           &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
               if not can-find ( first natur-oper where
                                       natur-oper.nat-operacao = it-nota-fisc.nat-operacao and
                                       natur-oper.log-atual-cotas = yes) 
                  then next.              
           &else
               if not can-find ( first natur-oper where
                                       natur-oper.nat-operacao = it-nota-fisc.nat-operacao and
                                       substr(natur-oper.char-2,31,1) = "1") 
                  then next.       
           &endif           

           run pi-acompanhar in h-acomp (input it-nota-fisc.it-codigo).

           assign l-log-produto = no.

           /* trata o item. se Ç item padr∆o ou se Ç controlado por produto*/
           if not par-cota.cont-produto then do:
               assign c-it-codigo = par-cota.it-codigo-padrao.
               find item-cota no-lock
                    where item-cota.it-codigo = par-cota.it-codigo-padrao no-error.
               if not avail item-cota then next.     
           end.
           else do:
               find item-cota no-lock
                    where item-cota.it-codigo = it-nota-fisc.it-codigo no-error.
               if avail item-cota then do:
                  if item-cota.log-produto and
                     par-cota.cont-produto then do : /*controla por produto*/
                     /* pre-processador para a release 2.03 */ 
                     &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
                         find est-prod-coml where est-prod-coml.it-codigo = item-cota.it-codigo no-lock no-error.
                         assign de-quantidade = est-prod-coml.qt-aplicada
                                c-it-codigo   = est-prod-coml.cod-produto-coml
                                l-log-produto = yes.
                     &ELSE
                         find est-prod where est-prod.it-codigo = item-cota.it-codigo no-lock no-error.
                         assign de-quantidade = est-prod.qt-aplicada
                                c-it-codigo   = est-prod.cd-produto
                                l-log-produto = yes.
                     &ENDIF
                  end.
                  else    
                     assign c-it-codigo   = item-cota.it-codigo.  
               end.
               else /*se n∆o existir item-cota*/ 
                   next.
           end.

           if par-cota.tipo-controle = 2 then do: /*controla por valor*/
             /* calcula valor bruto ou liquido*/            
               if par-cota.tipo-valor = 1 then 
                  assign de-valor-aux = it-nota-fisc.vl-preuni * it-nota-fisc.qt-faturada[1]. 
               else
                  assign de-valor-aux = it-nota-fisc.vl-merc-sicm.
           end. 
           else /*controla por pontos ou quantidade*/
               assign de-valor-aux = it-nota-fisc.qt-faturada[1] * if par-cota.tipo-controle = 3 then item-cota.nr-pontos else 1. 

           /**** Desconsidera as Devoluá‰es de notas fiscais *****/
           for first devol-cli fields(qt-devolvida) where
                     devol-cli.cod-estabel = it-nota-fisc.cod-estabel and                 
                     devol-cli.serie = it-nota-fisc.serie and
                     devol-cli.nr-nota-fis = it-nota-fisc.nr-nota-fis and
                     devol-cli.nr-sequencia = it-nota-fisc.nr-seq-fat and
                     devol-cli.it-codigo = it-nota-fisc.it-codigo no-lock :

               assign de-vl-devol-liq = (it-nota-fisc.vl-merc-sicm * devol-cli.qt-devolvida / it-nota-fisc.qt-faturada[1])  
                      de-vl-devol-bru = ((it-nota-fisc.vl-preuni * it-nota-fisc.qt-faturada[1])  * devol-cli.qt-devolvida / it-nota-fisc.qt-faturada[1])
                      de-quant-devol  = devol-cli.qt-devolvida.
               if par-cota.tipo-controle = 2 then do: /*controla por valor*/
                  /*calcula valor bruto ou liquido*/            
                  if par-cota.tipo-valor = 1 then 
                     assign de-valor-aux = de-valor-aux - de-vl-devol-bru.
                  else
                     assign de-valor-aux = de-valor-aux - de-vl-devol-liq.
               end. 
               else /*controla por pontos ou quantidade*/
                  assign de-quant-devol = de-quant-devol * (if par-cota.tipo-controle = 3 then item-cota.nr-pontos else 1)
                         de-valor-aux = de-valor-aux - de-quant-devol.
           end. 
           /**** Fim tratamento Devoluá‰es de notas fiscais *****/

           &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR 2.03 */
               /* caso seja controlado por produto - multiplica */
               if l-log-produto then
                  assign de-valor-aux = de-valor-aux * de-quantidade.
           &ELSE
               /* caso seja controlado por produto - divide */  
               if l-log-produto then
                  assign de-valor-aux = de-valor-aux / de-quantidade.
           &ENDIF


           find tt-base-cota where
                tt-base-cota.cod-estabel = nota-fiscal.cod-estabel and
                tt-base-cota.cd-produto  = c-it-codigo             no-lock no-error.

           if not avail tt-base-cota then do:
              create tt-base-cota.
              assign tt-base-cota.cod-estabel = nota-fiscal.cod-estabel
                     tt-base-cota.cd-produto  = c-it-codigo
                     tt-base-cota.nr-pontos   = (if par-cota.cont-produto = yes then item-cota.nr-pontos else 0)
                     tt-base-cota.quantidade  = de-valor-aux.
           end.
           else
              assign tt-base-cota.quantidade = tt-base-cota.quantidade + de-valor-aux.
       end.
    end.  
end procedure.


