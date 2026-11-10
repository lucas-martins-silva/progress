/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ACAPI007 2.00.00.012} /*** "010012" 22/05/2025 16:59:47  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ACAPI007 MUT}
&ENDIF



/********************************************************************************
** Programa : acp/acapi002.p
**
** Data     : 28/08/98
**
** Autor    : Datasul S.A.
**
** Objetivo : API que atualiza cotas na release 2.03 .
**
** Versao   : Eder Carlos Querino - Planner - Criacao - 27/08/1998
**
** Alteracao: Emerson Wessling - Planner - 02/1999
**            Adriano Marcelo            - 05/1999 
**            Adriano Marcelo            - 02/2000
********************************************************************************/


/***************************   A T E N C A O   *********************************
 ESSA API E EXECUTADA NA RELEASE 2.03 DO DICIONARIO. EXISTE UMA SEMELHANTE PARA  
 A RELEASE 2.02 DO DICIONARIO. SE VC ALTERAR ESSA, NAO ESQUECA DE VERIFICAR  SE 
 A ACAPI002 TMB N«O PRECISA SER MUDADA.
********************************************************************************/


/** include pre-processador **/
{cdp/cdcfgdis.i}

/*****  Uso de pre-processador ******/
&if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */

{acp/acapi002.i}

def input        param table for tt-configuracao.
def input-output param table for tt-dados.
def output       param table for tt-erros.

def new shared         var i-nr-erro as int extent 3 no-undo. /* usado na epc  */

def var r-cotas       as rowid                 no-undo.
def var de-qt-aux     as decimal               no-undo.
def var de-vl-aux     as decimal               no-undo.
def var l-ja-reprovou as log init no           no-undo.
def var de-cotacao    as decimal               no-undo.
def var de-pontos     like base-cota.nr-pontos no-undo.
def var l-erro        as log                   no-undo.
def var num-sit-com   as int                   no-undo.
def var c-texto       as char extent 2         no-undo.
def var raw-param     as raw                   no-undo.
def var l-atu-reprov  as log                   no-undo. /* se atualizou reprovado */
def var l-reprov      as log                   no-undo.
def var c-produto-aux like cotas.cd-produto    no-undo.
def var i-nr-trans    as int                   no-undo.
def var l-produto     as log                   no-undo.
def var l-reprov-base-cota as log              no-undo.

def buffer b-tt-dados for tt-dados.
def buffer b-cotas    for cotas.
def buffer b-atu-cota for atu-cota.

def temp-table tt-reprov
    field nome-abrev like ped-venda.nome-abrev
    field nr-pedcli  like ped-venda.nr-pedcli
    field cd-produto like cotas.cd-produto.

/* Include i-epc200.i: Definiá∆o Temp-Table tt-epc e dos programas de UPCs */
{include/i-epc200.i acapi007}.


find first tt-configuracao no-error.
if avail tt-configuracao then do:
  if tt-configuracao.cod-versao-integracao <> 1 then do:
    run utp/ut-msgs.p (input "msg", input 3941, input "").    
    create tt-erros.
    assign tt-erros.codigo-erro = 3941
           tt-erros.descricao   = return-value.
    return "NOK".       
  end.
end.
else do:
  run utp/ut-msgs.p (input "msg", input 8646, input "").
  create tt-erros.
  assign tt-erros.codigo-erro = 8646
         tt-erros.descricao = return-value.
  return "NOK".
end.

run pi-validacoes.

/*********************  ATUALIZACAO DE COTAS CFE ATU-COTA ******************
 ***************************************************************************
 * No caso de Cotas ja ter sido atualizado, sera diminuido o valor na tab  * 
 * Cotas baseado em Atu-cota respeitado a operacao que esta sendo realiza- *
 * da. Logo apos a atualizacao, atu-cota e excluida, sendo criada novamen- *
 * te no final deste programa.                                             *
 ***************************************************************************/

for each tt-dados where 
         tt-dados.log-erro = no
    break by tt-dados.nome-abrev 
          by tt-dados.nr-docto: /* usado break by, porque o pedido pode estar repetido na tt-dados, para 
                                   varios itens */

    if  last-of(tt-dados.nome-abrev) 
    or  last-of(tt-dados.nr-docto) then do:

        if  tt-dados.log-docto = yes then do: /* implantacao pedidos */ 

            for each atu-cota where
                     atu-cota.nome-abrev = tt-dados.nome-abrev and
                     atu-cota.nr-pedcli  = tt-dados.nr-docto exclusive-lock:

                find par-cota no-lock where
                     par-cota.cod-estabel = atu-cota.cod-estabel no-error.

                if  not avail par-cota then 
                    next.

                find last base-cota exclusive-lock where
                          base-cota.cod-estabel = atu-cota.cod-estabel and
                          base-cota.cd-produto  = atu-cota.cd-produto and
                          base-cota.dt-inicial <= atu-cota.dt-inicial and
                          base-cota.dt-final   >= atu-cota.dt-final no-error.

                find last  cotas exclusive-lock where
                           cotas.cod-estabel     = atu-cota.cod-estabel
                     and   cotas.cod-canal-venda = atu-cota.cod-canal-venda
                     and   cotas.cod-gr-cli      = atu-cota.cod-gr-cli
                     and   cotas.nome-abrev      = atu-cota.nome-abrev-cotas
                     and   cotas.nome-ab-reg     = atu-cota.nome-ab-reg
                     and   cotas.nome-mic-reg    = atu-cota.nome-mic-reg
                     and   cotas.cod-rep         = atu-cota.cod-rep
                     and   cotas.cd-produto      = atu-cota.cd-produto
                     and   cotas.dt-inicial     <= atu-cota.dt-inicial
                     and   cotas.dt-final       >= atu-cota.dt-final  no-error.

                if avail cotas and avail base-cota then do:
                    if  atu-cota.qt-pedida > 0 then do:
                        assign cotas.qt-pedida = cotas.qt-pedida - atu-cota.qt-pedida
                               cotas.vl-pedido = cotas.vl-pedido - atu-cota.vl-pedido.

                        if cotas.cod-rep <> ? then do:
                           if  par-cota.tipo-controle = 2 then    /* valor */
                               assign base-cota.qt-pedida = base-cota.qt-pedida - atu-cota.vl-pedido.
                           else     /* quantidade, pontos */   
                               assign base-cota.qt-pedida = base-cota.qt-pedida - atu-cota.qt-pedida.
                        end. 

                    end.
                    if  atu-cota.qt-ped-susp > 0 then do:
                        assign cotas.qt-ped-susp = cotas.qt-ped-susp - atu-cota.qt-ped-susp
                               cotas.vl-ped-susp = cotas.vl-ped-susp - atu-cota.vl-ped-susp.
                    end.
                    if  atu-cota.qt-ped-canc > 0 then do:
                        assign cotas.qt-ped-canc = cotas.qt-ped-canc - atu-cota.qt-ped-canc
                               cotas.vl-ped-canc = cotas.vl-ped-canc - atu-cota.vl-ped-canc.               
                    end.
                    if  atu-cota.qt-ped-reprov > 0 then do:
                        assign cotas.qt-ped-reprov = cotas.qt-ped-reprov - atu-cota.qt-ped-reprov
                               cotas.vl-ped-reprov = cotas.vl-ped-reprov - atu-cota.vl-ped-reprov.
                    end.                    

                    delete atu-cota.

                end. /*if avail cotas e base-cota*/
            end. /*for each atu-cota*/
        end. /*log docto*/
    end. /*if last-of*/    

    if tt-dados.nivel = "Representante" then 
       run pi-chamada-upc-desatualizacao.

end. /*for each tt-dados*/

/*************************** ATUALIZACAO DE COTAS **************************/

assign l-reprov = no.

for each tt-dados where
         tt-dados.log-erro = no
         by tt-dados.nivel: /* o ultimo n°vel a ser lido deve ser "representante", por causa das 
                               consistencias */

    find first par-cota no-lock where
               par-cota.cod-estabel = tt-dados.cod-estabel no-error.

    assign de-vl-aux    = if par-cota.tipo-valor = 1 then tt-dados.valor-unit-bru else tt-dados.valor-unit-liq
           de-qt-aux    = tt-dados.quantidade 
           l-atu-reprov = no.

    if tt-dados.nivel = "Representante" then
       run pi-chamada-upc-atualizacao.

    /*Verifica cotacao da Moeda*/
    if  par-cota.cod-moeda <> 0 then do:
        {pdp/pd9100.i "par-cota.cod-moeda" "tt-dados.dt-emissao" "de-cotacao"}
        if  not avail cotacao then do:
            find moeda no-lock where moeda.mo-codigo = par-cota.cod-moeda no-error.
            run utp/ut-msgs.p (input "show" ,
                               input 316 ,
                               input moeda.descricao + "~~" + string(tt-dados.dt-emissao)).
            assign de-cotacao = 1.
        end.   
        assign de-vl-aux = de-vl-aux * de-cotacao.              
    end.

    find last  base-cota where
               base-cota.cod-estabel = par-cota.cod-estabel and
               base-cota.cd-produto  = tt-dados.it-codigo and
               base-cota.dt-inicial <= ( if par-cota.tipo-data = 1 then
                                            tt-dados.dt-emissao    else
                                            tt-dados.dt-entrega )  and
               base-cota.dt-final   >= ( if par-cota.tipo-data = 1 then
                                            tt-dados.dt-emissao    else
                                            tt-dados.dt-entrega )  exclusive-lock no-error.
    if avail base-cota and
       base-cota.cd-produto <> base-cota.cd-produto-dest then do:
       assign c-produto-aux = base-cota.cd-produto-dest.
       find last  base-cota where
                  base-cota.cod-estabel = par-cota.cod-estabel and
                  base-cota.cd-produto  = c-produto-aux and
                  base-cota.dt-inicial <= ( if par-cota.tipo-data = 1 then
                                               tt-dados.dt-emissao    else
                                               tt-dados.dt-entrega )  and
                  base-cota.dt-final   >= ( if par-cota.tipo-data = 1 then
                                               tt-dados.dt-emissao    else
                                               tt-dados.dt-entrega )  exclusive-lock no-error.
    end.

    for first item-cota fields(log-cota-limite it-codigo) no-lock where
              item-cota.it-codigo = tt-dados.it-original :
    end.                                                 

    /* Vefifica se existe cotas para este pedido ou nota-fiscal para efetuar a atualizaáao*/
    find last cotas where
              cotas.cod-estabel = tt-dados.cod-estabel and
              cotas.cod-canal-venda = tt-dados.cod-canal-venda and
              cotas.cod-gr-cli = tt-dados.cod-gr-cli and
              cotas.nome-abrev = tt-dados.nome-abrev-cotas and
              cotas.nome-ab-reg = tt-dados.nome-ab-reg and
              cotas.nome-mic-reg = tt-dados.nome-mic-reg and
              cotas.cod-rep = tt-dados.cod-rep and
              cotas.cd-produto = base-cota.cd-produto-dest and
              cotas.dt-inicial <= (if par-cota.tipo-data = 1 then 
                                      tt-dados.dt-emissao    else
                                      tt-dados.dt-entrega) and
              cotas.dt-final   >= (if par-cota.tipo-data = 1 then 
                                      tt-dados.dt-emissao    else
                                      tt-dados.dt-entrega ) exclusive-lock no-error.

    /*********************************************************************************************** 
       Para aprovaá∆o e reprovaá∆o foráada de pedidos, est† chamando essa rotina separadamente e n∆o
       passa pelas rotinas seguintes.
     ***********************************************************************************************/   
    if (tt-dados.log-tipo-oper = 10 or tt-dados.log-tipo-oper = 11) and /*aprovacao reprovacao forcada*/
        tt-dados.log-docto     = yes                                then do: /*pedidos*/
       run pi-trata-aprova-reprovacao-forcada.
       next.

    end.     
    /***********************************************************************************************/

    assign l-reprov-base-cota = no. 

    if not avail cotas then
       run pi-nao-encontrou-cotas.

    if  avail cotas then do:

       /*Cotas Maxima*/
       if par-cota.tipo-cota /*maxima*/ = 2   and
          tt-dados.log-docto            = yes and
        ( tt-dados.log-tipo-oper        = 1   or 
          tt-dados.log-tipo-oper        = 3   or
          tt-dados.log-tipo-oper        = 8   or
        ( tt-dados.log-tipo-oper        = 2   and 
          par-cota.aval-ped-susp = yes ) )    then do:

          /*Valida se base de cotas Pedida eh maior que base cota Prevista*/
          if  tt-dados.nivel = "Representante" then
              if (base-cota.qt-pedida + de-qt-aux) > base-cota.qt-prevista and
                  par-cota.cota-geral              = 1  then  /*bloqueia*/
                  assign l-reprov-base-cota = yes
                         tt-dados.cod-sit-com = 3.

          /*Valida se cotas Pedidas eh maior que Cotas prevista*/
          if ((par-cota.tipo-controle   = 2 and (cotas.vl-pedido + de-vl-aux > cotas.vl-previsto))  or
              (par-cota.tipo-controle  <> 2 and (cotas.qt-pedida + de-qt-aux > cotas.qt-prevista))) and
             ( item-cota.log-cota-limite = yes   and
               base-cota.log-cota-limite = yes ) or
             ( item-cota.log-cota-limite = no    and
               base-cota.log-cota-limite = yes ) then do:

             /** Nivel Canal de Venda **/
             if tt-dados.nivel = "Canal" then do:
                if par-cota.aval-cota-canal-venda = 2 then do:
                   run utp/ut-msgs.p (input "msg", input 16208, input tt-dados.it-codigo).
                   create tt-erros.
                   assign tt-erros.codigo-erro = 16208
                          tt-erros.parametros = tt-dados.it-codigo
                          tt-erros.descricao = return-value.
                end.
             end.

             /** Nivel Grupo Cliente **/
             if tt-dados.nivel = "Grupo" then do:
                if par-cota.aval-cota-gr-cli = 2 then do:
                   run utp/ut-msgs.p (input "msg", input 16208, input base-cota.cd-produto-dest).
                   create tt-erros.
                   assign tt-erros.codigo-erro = 16208
                          tt-erros.parametros = base-cota.cd-produto-dest
                          tt-erros.descricao = return-value.
                end.
             end.              

             /** Nivel Cliente **/
             if tt-dados.nivel = "Cliente" then do:
                if par-cota.aval-cota-cliente = 2 then do:
                   run utp/ut-msgs.p (input "msg", input 16208, input base-cota.cd-produto-dest).
                   create tt-erros.
                   assign tt-erros.codigo-erro = 16208
                          tt-erros.parametros = base-cota.cd-produto-dest
                          tt-erros.descricao = return-value.
                end.
             end.              

             /** Nivel Regiao **/
             if tt-dados.nivel = "Regiao" then do:
                if par-cota.aval-cota-ab-reg = 2 then do:
                   run utp/ut-msgs.p (input "msg", input 16208, input base-cota.cd-produto-dest).
                   create tt-erros.
                   assign tt-erros.codigo-erro = 16208
                          tt-erros.parametros = base-cota.cd-produto-dest
                          tt-erros.descricao = return-value.
                end.
             end.              

             /** Nivel Microrregiao **/
             if tt-dados.nivel = "Microrregiao" then do:
                if par-cota.aval-cota-mic-reg = 2 then do:
                   run utp/ut-msgs.p (input "msg", input 16208, input base-cota.cd-produto-dest).
                   create tt-erros.
                   assign tt-erros.codigo-erro = 16208
                          tt-erros.parametros = base-cota.cd-produto-dest
                          tt-erros.descricao = return-value.
                end.
             end.              

             /** Nivel Represente **/
             if tt-dados.nivel = "Representante" then do:
                if par-cota.aval-cota-repres = 2 then do:
                   run utp/ut-msgs.p (input "msg", input 16208, input base-cota.cd-produto-dest).
                   create tt-erros.
                   assign tt-erros.codigo-erro = 16208
                          tt-erros.parametros = base-cota.cd-produto-dest
                          tt-erros.descricao = return-value.
                end.
             end.              

          end.

       end. /*if */

       if  tt-dados.log-docto = yes then do: /* pedidos */

           /* inclusao e reativacao de pedidos */
           if  tt-dados.log-tipo-oper = 1 or
               tt-dados.log-tipo-oper = 3 or
               tt-dados.log-tipo-oper = 8 /* aprovacao/reprovacao ac1004 */ then do:

               /*Cotas Maxima*/
               if par-cota.tipo-cota            = 2  then do:

                  if l-reprov-base-cota = no then do:

                      /*Valida se cotas Pedidas e maior que Cotas prevista*/
                      if ( par-cota.tipo-controle  = 2 and (cotas.vl-pedido + de-vl-aux > cotas.vl-previsto )) or
                         ( par-cota.tipo-controle <> 2 and (cotas.qt-pedida + de-qt-aux > cotas.qt-prevista )) and
                         ( item-cota.log-cota-limite = yes   and
                           base-cota.log-cota-limite = yes ) or
                         ( item-cota.log-cota-limite = no    and
                           base-cota.log-cota-limite = yes ) then do:

                          /** Nivel Canal Venda **/
                          if  tt-dados.nivel = "Canal" then do:
                              if par-cota.aval-cota-canal-venda = 1  and
                                 tt-dados.log-tipo-oper      <> 8  and /* aprova/desaprova */ 
                                 tt-dados.log-tipo-oper      <> 5  then /* diminui */

                                 assign cotas.qt-ped-reprov  = cotas.qt-ped-reprov + de-qt-aux
                                        cotas.vl-ped-reprov  = cotas.vl-ped-reprov + de-vl-aux
                                        l-atu-reprov         = yes
                                        l-reprov             = yes               
                                        tt-dados.cod-sit-com = 3.

                          end.

                          /** Nivel Grupo Cliente **/                                             
                          if  tt-dados.nivel = "Grupo" then do:
                              if par-cota.aval-cota-gr-cli    = 1  and
                                 tt-dados.log-tipo-oper      <> 8  and /* aprova/desaprova */ 
                                 tt-dados.log-tipo-oper      <> 5  then /* diminui */
                                 assign cotas.qt-ped-reprov  = cotas.qt-ped-reprov + de-qt-aux
                                        cotas.vl-ped-reprov  = cotas.vl-ped-reprov + de-vl-aux
                                        l-atu-reprov         = yes  
                                        l-reprov             = yes             
                                        tt-dados.cod-sit-com = 3.
                          end.

                          /** Nivel Cliente **/                                             
                          if  tt-dados.nivel = "Cliente" then do:
                              if par-cota.aval-cota-cliente   = 1  and
                                 tt-dados.log-tipo-oper      <> 8  and  /* aprova/desaprova */ 
                                 tt-dados.log-tipo-oper      <> 5  then /* diminui */

                                 assign cotas.qt-ped-reprov  = cotas.qt-ped-reprov + de-qt-aux
                                        cotas.vl-ped-reprov  = cotas.vl-ped-reprov + de-vl-aux
                                        l-atu-reprov         = yes               
                                        l-reprov             = yes
                                        tt-dados.cod-sit-com = 3.
                          end.

                          /** Nivel Regiao **/                                             
                          if  tt-dados.nivel = "Regiao" then do:
                              if par-cota.aval-cota-ab-reg    = 1  and
                                 tt-dados.log-tipo-oper      <> 8  and  /* aprova/desaprova */ 
                                 tt-dados.log-tipo-oper      <> 5  then /* diminui */
                                 assign cotas.qt-ped-reprov  = cotas.qt-ped-reprov + de-qt-aux
                                        cotas.vl-ped-reprov  = cotas.vl-ped-reprov + de-vl-aux
                                        l-atu-reprov         = yes    
                                        l-reprov             = yes           
                                        tt-dados.cod-sit-com = 3.
                          end.                                                 

                          /** Nivel Microrregiao **/                                             
                          if  tt-dados.nivel = "Microrregiao" then do:
                              if par-cota.aval-cota-mic-reg  = 1  and
                                 tt-dados.log-tipo-oper      <> 8 and  /* aprova/desaprova */ 
                                 tt-dados.log-tipo-oper      <> 5  then /* diminui */
                                 assign cotas.qt-ped-reprov  = cotas.qt-ped-reprov + de-qt-aux
                                        cotas.vl-ped-reprov  = cotas.vl-ped-reprov + de-vl-aux
                                        l-atu-reprov         = yes               
                                        l-reprov             = yes
                                        tt-dados.cod-sit-com = 3.
                          end.                                                 

                          /** Nivel Representante **/                                             
                          if  tt-dados.nivel = "Representante" then do:
                              if par-cota.aval-cota-repres    = 1  and
                                 tt-dados.log-tipo-oper      <> 8 and  /* aprova/desaprova */ 
                                 tt-dados.log-tipo-oper      <> 5  then do: /* diminui */
                                 assign cotas.qt-ped-reprov  = cotas.qt-ped-reprov + de-qt-aux
                                        cotas.vl-ped-reprov  = cotas.vl-ped-reprov + de-vl-aux
                                        l-atu-reprov         = yes  
                                        l-reprov             = yes             
                                        tt-dados.cod-sit-com = 3.
                              end.          
                          end.


                      end. /*if */

                  end. /*l-reprov-base-cota*/

                  else do: /*reprovou por base de cota*/

                      if tt-dados.log-tipo-oper      <> 8 and    /* aprova/desaprova */ 
                         tt-dados.log-tipo-oper      <> 5  then  /* diminui */
                         assign cotas.qt-ped-reprov  = cotas.qt-ped-reprov + de-qt-aux
                                cotas.vl-ped-reprov  = cotas.vl-ped-reprov + de-vl-aux
                                l-atu-reprov         = yes  
                                l-reprov             = yes             
                                tt-dados.cod-sit-com = 3.

                  end.
               end. /*tipo-contole*/

               /* se n∆o for reprovacao */
               if l-atu-reprov = no then do:      

                  assign cotas.qt-pedida = cotas.qt-pedida + de-qt-aux
                         cotas.vl-pedido = cotas.vl-pedido + de-vl-aux
                         tt-dados.cod-sit-com = 2. /*aprovado*/

                  if tt-dados.nivel = "Representante" then do:
                     if l-reprov = no then
                        if par-cota.tipo-controle = 2 then /*valor*/
                           assign base-cota.qt-pedida = base-cota.qt-pedida + de-vl-aux.
                        else /*quantidade, pontos*/ 
                           assign base-cota.qt-pedida = base-cota.qt-pedida + de-qt-aux.   
                  end.         
               end.      

           end.
           else do:

               /* suspensao de pedidos */
               if ( tt-dados.log-tipo-oper = 2 and par-cota.aval-ped-susp = yes ) or
                    tt-dados.log-tipo-oper = 9 then /*implantacao pedido sem credito*/

                    assign cotas.qt-ped-susp    = cotas.qt-ped-susp + de-qt-aux
                           cotas.vl-ped-susp    = cotas.vl-ped-susp + de-vl-aux
                           tt-dados.cod-sit-com = 4. /*suspenso*/
           end.

           /* se n∆o for reprovacao */
           if l-atu-reprov = no then do:
              /* cancelamento de pedidos */
              if tt-dados.log-tipo-oper = 4 then
                 assign cotas.qt-ped-canc    = cotas.qt-ped-canc + de-qt-aux
                        cotas.vl-ped-canc    = cotas.vl-ped-canc + de-vl-aux
                        tt-dados.cod-sit-com = 2. /*cancelado a situacao fica aprovado*/

           end.             
       end.
       else do:  
           /* operacoes com Nota Fiscal */ 

           /* inclusao nota fiscal */
           if tt-dados.log-tipo-oper = 1 then
              assign cotas.qt-faturada = cotas.qt-faturada + de-qt-aux
                     cotas.vl-faturado = cotas.vl-faturado + de-vl-aux.

           /* cancelamento nota fiscal */
           if tt-dados.log-tipo-oper = 4 then 
              assign cotas.qt-fat-canc = cotas.qt-fat-canc + de-qt-aux
                     cotas.vl-fat-canc = cotas.vl-fat-canc + de-vl-aux
                     cotas.qt-faturada = cotas.qt-faturada - de-qt-aux
                     cotas.vl-faturado = cotas.vl-faturado - de-vl-aux.

           /* devolucao nota fiscal */
           if tt-dados.log-tipo-oper = 6 then
              assign cotas.qt-fat-canc = cotas.qt-fat-canc + de-qt-aux
                     cotas.vl-fat-canc = cotas.vl-fat-canc + de-vl-aux
                     cotas.qt-faturada = cotas.qt-faturada - de-qt-aux
                     cotas.vl-faturado = cotas.vl-faturado - de-vl-aux.                

           /* desatualizacao nota fiscal no recebimento */          
           if tt-dados.log-tipo-oper = 7 then
              assign cotas.qt-fat-canc = cotas.qt-fat-canc - de-qt-aux
                     cotas.vl-fat-canc = cotas.vl-fat-canc - de-vl-aux
                     cotas.qt-faturada = cotas.qt-faturada + de-qt-aux
                     cotas.vl-faturado = cotas.vl-faturado + de-vl-aux.                
       end.      

       /********************** CRIACAO DE ATU-COTA *************************
        * Na parte superior desse programa foi diminuido atu-cota, cfe a   *
        * operacao. Agora sera criada uma nova atu-cota com os novos valo- *
        * res, respeitando o tipo de operacao. Atu-cota sera sempre um es- *
        * pelho de Cotas.                                                  *
        ********************************************************************/  

       find last  atu-cota
            where atu-cota.cod-estabel      =  cotas.cod-estabel
            and   atu-cota.cod-canal-venda  =  cotas.cod-canal-venda
            and   atu-cota.cod-gr-cli       =  cotas.cod-gr-cli
            and   atu-cota.nome-abrev-cotas =  cotas.nome-abrev
            and   atu-cota.nome-abrev       =  tt-dados.nome-abrev
            and   atu-cota.nome-ab-reg      =  cotas.nome-ab-reg
            and   atu-cota.nome-mic-reg     =  cotas.nome-mic-reg
            and   atu-cota.cod-rep          =  cotas.cod-rep
            and   atu-cota.cd-produto       =  cotas.cd-produto        
            and   atu-cota.dt-inicial      <= (if par-cota.tipo-data = 1 then tt-dados.dt-emissao else tt-dados.dt-entrega)
            and   atu-cota.nr-pedcli        =  tt-dados.nr-docto exclusive-lock no-error.

       if not avail atu-cota           and
          tt-dados.log-tipo-oper <> 5  and /*em caso de eliminacao nao cria atu-cota*/
          tt-dados.log-docto     = yes then do: /*pedidos*/ 

          create atu-cota.
          assign  atu-cota.nome-abrev       =  tt-dados.nome-abrev
                  atu-cota.nr-pedcli        =  tt-dados.nr-docto
                  atu-cota.cod-estabel      =  cotas.cod-estabel
                  atu-cota.cod-canal-venda  =  cotas.cod-canal-venda
                  atu-cota.cod-gr-cli       =  cotas.cod-gr-cli
                  atu-cota.nome-ab-reg      =  cotas.nome-ab-reg
                  atu-cota.nome-mic-reg     =  cotas.nome-mic-reg
                  atu-cota.cod-rep          =  cotas.cod-rep
                  atu-cota.cd-produto       =  cotas.cd-produto   
                  atu-cota.nome-abrev-cotas =  cotas.nome-abrev    
                  atu-cota.dt-inicial       = (if par-cota.tipo-data = 1 then
                                                  tt-dados.dt-emissao    else
                                                  tt-dados.dt-entrega)
                  atu-cota.dt-final         =  cotas.dt-final no-error.

          /* inclui pedido / reativa / suspende com liberacao */
          if  tt-dados.log-tipo-oper = 1
          or  tt-dados.log-tipo-oper = 3 
          or  tt-dados.log-tipo-oper = 8 then do:

              /* atualiza reprovado */       
              if l-atu-reprov then       
                 assign atu-cota.qt-ped-reprov = de-qt-aux 
                        atu-cota.vl-ped-reprov = de-vl-aux.
              else 
                 assign atu-cota.qt-pedida = de-qt-aux 
                        atu-cota.vl-pedido = de-vl-aux.                        

          end.
          else /* suspende pedido*/

              if  (tt-dados.log-tipo-oper = 2 and par-cota.aval-ped-susp = yes) or
                   tt-dados.log-tipo-oper = 9 then /*implantacao pedido sem credito*/
                   assign atu-cota.qt-ped-susp =  de-qt-aux 
                          atu-cota.vl-ped-susp =  de-vl-aux.

          /*cancela pedido*/ 
          if tt-dados.log-tipo-oper = 4 then
          assign atu-cota.qt-ped-canc = de-qt-aux 
                 atu-cota.vl-ped-canc = de-vl-aux.

       end.
       else do:
          if avail atu-cota                and /* if avail atu-cota */
             tt-dados.log-tipo-oper <> 5   and /*em caso de eliminacao nao cria atu-cota*/
             tt-dados.log-docto     =  yes then do: /*pedidos*/        

            /* inclui pedido / reativa / suspende com liberacao */
            if  tt-dados.log-tipo-oper = 1 
            or  tt-dados.log-tipo-oper = 3
            or  tt-dados.log-tipo-oper = 8 then do:

                /* atualiza reprovado */       
                if l-atu-reprov then       
                   assign atu-cota.qt-ped-reprov = atu-cota.qt-ped-reprov + de-qt-aux 
                          atu-cota.vl-ped-reprov = de-vl-aux + atu-cota.vl-ped-reprov.
                else
                   assign atu-cota.qt-pedida = atu-cota.qt-pedida + de-qt-aux
                          atu-cota.vl-pedido = atu-cota.vl-pedido + de-vl-aux.

            end.
            else /* suspende pedido*/

                if (tt-dados.log-tipo-oper = 2 and par-cota.aval-ped-susp = yes) or
                    tt-dados.log-tipo-oper = 9 then 
                    assign atu-cota.qt-ped-susp = atu-cota.qt-ped-susp + de-qt-aux
                           atu-cota.vl-ped-susp = atu-cota.vl-ped-susp + de-vl-aux.

            /*cancela pedido*/ 
            if tt-dados.log-tipo-oper = 4 then
               assign atu-cota.qt-ped-canc = atu-cota.qt-ped-canc + de-qt-aux 
                      atu-cota.vl-ped-canc = atu-cota.vl-ped-canc + de-vl-aux.


          end. /* avail atu-cota */
       end. /***else do***/
    end. /* if avail cotas */

end. /* for each tt-dados */

/** 
      Tratamento para cotas Reprovadas, quando controla por n°veis
      Se pelo menos um n°vel foi reprovado, todos os niveis devem
      ser reprovados juntamente 
 **/
/******** TRATA COTAS REPROVADAS *********/

for each tt-reprov :
    delete tt-reprov.
end.


for each tt-dados where 
         tt-dados.log-erro = no : 


    /* cria temp table , pois tlz num pedido, apenas em um item foi reprovado 
       algum n°vel. sem isso , reprova todos os itens do pedido */
    for each atu-cota fields ( nome-abrev nr-pedcli qt-ped-reprov cd-produto) where
             atu-cota.nome-abrev = tt-dados.nome-abrev and
             atu-cota.nr-pedcli  = tt-dados.nr-docto no-lock:
        if atu-cota.qt-ped-reprov > 0 then do:
           find first tt-reprov where
                      tt-reprov.nome-abrev = atu-cota.nome-abrev and
                      tt-reprov.nr-pedcli  = atu-cota.nr-pedcli and
                      tt-reprov.cd-produto = atu-cota.cd-produto no-error. 
           if not avail tt-reprov then do:
              create tt-reprov.
              assign tt-reprov.nome-abrev = atu-cota.nome-abrev
                     tt-reprov.nr-pedcli  = atu-cota.nr-pedcli              
                     tt-reprov.cd-produto = atu-cota.cd-produto.
           end.
        end.
    end.

    /* caso o nivel vendedor da upc seja reprovado */
    if tt-dados.log-reprov-vend = yes then do:
       find first par-cota no-lock where
                  par-cota.cod-estabel = tt-dados.cod-estabel no-error.

       find last  base-cota where
                  base-cota.cod-estabel = par-cota.cod-estabel and
                  base-cota.cd-produto  = tt-dados.it-codigo and
                  base-cota.dt-inicial <= ( if par-cota.tipo-data = 1 then
                                               tt-dados.dt-emissao    else
                                               tt-dados.dt-entrega )  and
                  base-cota.dt-final   >= ( if par-cota.tipo-data = 1 then
                                               tt-dados.dt-emissao    else
                                               tt-dados.dt-entrega )  no-lock no-error.
       if avail base-cota and
          base-cota.cd-produto <> base-cota.cd-produto-dest then do:
          assign c-produto-aux = base-cota.cd-produto-dest.
          find last  base-cota where
                     base-cota.cod-estabel = par-cota.cod-estabel and
                     base-cota.cd-produto  = c-produto-aux and
                     base-cota.dt-inicial <= ( if par-cota.tipo-data = 1 then
                                                  tt-dados.dt-emissao    else
                                                  tt-dados.dt-entrega )  and
                     base-cota.dt-final   >= ( if par-cota.tipo-data = 1 then
                                                  tt-dados.dt-emissao    else
                                                  tt-dados.dt-entrega )  no-lock no-error.
       end. 

       find first tt-reprov where
                  tt-reprov.nome-abrev = tt-dados.nome-abrev and
                  tt-reprov.nr-pedcli  = tt-dados.nr-docto and
                  tt-reprov.cd-produto = tt-dados.it-codigo no-error.
       if not avail tt-reprov then do:
          create tt-reprov.
          assign tt-reprov.nome-abrev = tt-dados.nome-abrev
                 tt-reprov.nr-pedcli  = tt-dados.nr-docto              
                 tt-reprov.cd-produto = base-cota.cd-produto.
       end.              
    end.    
end.    

for each tt-dados where 
         tt-dados.log-erro = no
    break by tt-dados.nome-abrev 
          by tt-dados.nr-docto : /* usado break by, porque o pedido pode estar repetido na tt-dados, para 
                                     varios itens */

    if  tt-dados.log-docto = yes and /* implantacao pedidos */ 
        par-cota.log-impl-niveis then do: /* por n°veis */ 

        assign l-produto = no.

        /* Quando Ç produto, a atu-cota grava um registro s¢, com aprovados e 
           reprovados juntos, diferente do que acontece quando Ç usado item.
           Por isso, Ç necess†rio fazer um tratamento diferente em relaá∆o a
           base cota e cotas. */
        for first produto-coml fields(cod-produto-coml) where 
                   produto-coml.cod-produto-coml = tt-dados.it-codigo no-lock :
            assign l-produto = yes. 
        end. 

        find first par-cota no-lock where
                   par-cota.cod-estabel = tt-dados.cod-estabel no-error.

        assign l-atu-reprov = no.

        if  last-of(tt-dados.nome-abrev) or
            last-of(tt-dados.nr-docto) then do:

            /* libera pedido parcial */
            if par-cota.ped-parcial then do:

                find first tt-reprov no-error. 
                if avail tt-reprov then 
                   assign l-atu-reprov = yes.

                if l-atu-reprov = yes then do:

                    for each atu-cota exclusive-lock where
                             atu-cota.nome-abrev = tt-dados.nome-abrev and
                             atu-cota.nr-pedcli  = tt-dados.nr-docto :

                       if atu-cota.cod-rep <> ? then do:
                          /* Se ja atualizou vendedor ( upc da grendene ), e depois atualizou o representante. Se esse 
                             representante foi reprovado, o vendedor tmb precisa ser reprovado. Para isso vai ser 
                             chamada essa upc de reprovacao */
                          run pi-chamada-upc-reprovacao.
                       end.                                    

                       if l-produto = no then do: /*n∆o for produto mas item*/
                          find last base-cota exclusive-lock where
                                    base-cota.cod-estabel = atu-cota.cod-estabel and
                                    base-cota.cd-produto  = atu-cota.cd-produto and
                                    base-cota.dt-inicial <= atu-cota.dt-inicial and
                                    base-cota.dt-final   >= atu-cota.dt-final no-error.

                          if avail base-cota       and
                             atu-cota.cod-rep <> ? then 
                             assign base-cota.qt-pedida = base-cota.qt-pedida - 
                                                          (if par-cota.tipo-controle = 2 then 
                                                              atu-cota.vl-pedido else
                                                              atu-cota.qt-pedida).
                       end.

                       if atu-cota.qt-ped-reprov = 0 then do:
                          find first tt-reprov where
                                     tt-reprov.nome-abrev = atu-cota.nome-abrev and
                                     tt-reprov.nr-pedcli  = atu-cota.nr-pedcli  and
                                     tt-reprov.cd-produto = atu-cota.cd-produto no-error.                    
                          if not avail tt-reprov then next.

                          for each b-tt-dados where 
                                   b-tt-dados.nome-abrev = tt-dados.nome-abrev and
                                   b-tt-dados.nr-docto   = tt-dados.nr-docto and
                                   b-tt-dados.it-codigo  = tt-reprov.cd-produto :
                              assign b-tt-dados.cod-sit-com = 3 . /*reprov*/   
                          end.                       

                          find last cotas exclusive-lock where
                                    cotas.cod-estabel      = atu-cota.cod-estabel and
                                    cotas.cod-canal-venda  = atu-cota.cod-canal-venda and
                                    cotas.cod-gr-cli       = atu-cota.cod-gr-cli and
                                    cotas.nome-abrev       = atu-cota.nome-abrev-cotas and
                                    cotas.nome-ab-reg      = atu-cota.nome-ab-reg and
                                    cotas.nome-mic-reg     = atu-cota.nome-mic-reg and
                                    cotas.cod-rep          = atu-cota.cod-rep and
                                    cotas.cd-produto       = atu-cota.cd-produto and
                                    cotas.dt-inicial      <= atu-cota.dt-inicial and
                                    cotas.dt-final        >= atu-cota.dt-final  no-error.
                          if avail cotas then 
                             assign atu-cota.qt-ped-reprov = atu-cota.qt-pedida
                                    atu-cota.vl-ped-reprov = atu-cota.vl-pedido
                                    cotas.qt-ped-reprov    = cotas.qt-ped-reprov + atu-cota.qt-ped-reprov
                                    cotas.vl-ped-reprov    = cotas.vl-ped-reprov + atu-cota.vl-ped-reprov 
                                    cotas.qt-pedida        = cotas.qt-pedida - atu-cota.qt-pedida
                                    cotas.vl-pedido        = cotas.vl-pedido - atu-cota.vl-pedido
                                    atu-cota.qt-pedida     = 0
                                    atu-cota.vl-pedido     = 0.  
                       end.
                    end.  
                end. /*l-atu-reprov*/
            end.    

            /* n∆o libera pedido parcial */

            else do:

                assign c-produto-aux = "".

                for each atu-cota fields ( nome-abrev nr-pedcli qt-ped-reprov cd-produto) where
                         atu-cota.nome-abrev = tt-dados.nome-abrev and
                         atu-cota.nr-pedcli  = tt-dados.nr-docto no-lock:
                    if atu-cota.qt-ped-reprov > 0 then 
                       assign l-atu-reprov = yes.
                end.

                /* caso o nivel vendedor da upc seja reprovado */
                for each b-tt-dados where 
                         b-tt-dados.nome-abrev = tt-dados.nome-abrev and
                         b-tt-dados.nr-docto   = tt-dados.nr-docto :
                    if b-tt-dados.log-reprov-vend = yes then 
                       assign l-atu-reprov = yes.
                end.         

                if l-atu-reprov = yes then do:

                    for each atu-cota exclusive-lock where
                             atu-cota.nome-abrev = tt-dados.nome-abrev and
                             atu-cota.nr-pedcli  = tt-dados.nr-docto:
                       if atu-cota.cod-rep <> ? then do:
                          /* Se ja atualizou vendedor ( upc da grendene ), e depois atualizou o representante. Se esse 
                             representante foi reprovado, o vendedor tmb precisa ser reprovado. Para isso vai ser 
                             chamada essa upc de reprovacao */
                          run pi-chamada-upc-reprovacao.
                       end.                                 

                       find last base-cota exclusive-lock where
                                 base-cota.cod-estabel = atu-cota.cod-estabel and
                                 base-cota.cd-produto  = atu-cota.cd-produto and
                                 base-cota.dt-inicial <= atu-cota.dt-inicial and
                                 base-cota.dt-final   >= atu-cota.dt-final no-error.
                       if avail base-cota           and
                          atu-cota.cod-rep    <> ?  then 
                          assign base-cota.qt-pedida = base-cota.qt-pedida - 
                                                       (if par-cota.tipo-controle = 2 then 
                                                           atu-cota.vl-pedido else
                                                           atu-cota.qt-pedida).

                       if l-produto = no then do: /*quando n∆o for produto mas item*/
                          if atu-cota.qt-ped-reprov = 0 then do:

                               for each b-tt-dados where 
                                        b-tt-dados.nome-abrev = tt-dados.nome-abrev and
                                        b-tt-dados.nr-docto   = tt-dados.nr-docto :
                                   assign b-tt-dados.cod-sit-com = 3 . /*reprov*/   
                               end.                         

                               find last cotas exclusive-lock where
                                         cotas.cod-estabel      = atu-cota.cod-estabel and
                                         cotas.cod-canal-venda  = atu-cota.cod-canal-venda and
                                         cotas.cod-gr-cli       = atu-cota.cod-gr-cli and
                                         cotas.nome-abrev       = atu-cota.nome-abrev-cotas and
                                         cotas.nome-ab-reg      = atu-cota.nome-ab-reg and
                                         cotas.nome-mic-reg     = atu-cota.nome-mic-reg and
                                         cotas.cod-rep          = atu-cota.cod-rep and
                                         cotas.cd-produto       = atu-cota.cd-produto and
                                         cotas.dt-inicial      <= atu-cota.dt-inicial and
                                         cotas.dt-final        >= atu-cota.dt-final  no-error.
                               if avail cotas then 
                                  assign atu-cota.qt-ped-reprov = atu-cota.qt-pedida
                                         atu-cota.vl-ped-reprov = atu-cota.vl-pedido
                                         cotas.qt-ped-reprov    = cotas.qt-ped-reprov + atu-cota.qt-ped-reprov
                                         cotas.vl-ped-reprov    = cotas.vl-ped-reprov + atu-cota.vl-ped-reprov 
                                         cotas.qt-pedida        = cotas.qt-pedida - atu-cota.qt-pedida
                                         cotas.vl-pedido        = cotas.vl-pedido - atu-cota.vl-pedido
                                         atu-cota.qt-pedida     = 0
                                         atu-cota.vl-pedido     = 0.  
                          end.
                       end. /*l-produto*/
                       else do: /*quando for produto*/

                           if  atu-cota.qt-ped-reprov = 0 or
                             (atu-cota.qt-ped-reprov <> 0 and
                              atu-cota.qt-pedida     <> 0) then do:
                            for each b-tt-dados where 
                                     b-tt-dados.nome-abrev = tt-dados.nome-abrev and
                                     b-tt-dados.nr-docto   = tt-dados.nr-docto :
                                assign b-tt-dados.cod-sit-com = 3 . /*reprov*/   
                            end.                         

                            find last cotas exclusive-lock where
                                      cotas.cod-estabel      = atu-cota.cod-estabel and
                                      cotas.cod-canal-venda  = atu-cota.cod-canal-venda and
                                      cotas.cod-gr-cli       = atu-cota.cod-gr-cli and
                                      cotas.nome-abrev       = atu-cota.nome-abrev-cotas and
                                      cotas.nome-ab-reg      = atu-cota.nome-ab-reg and
                                      cotas.nome-mic-reg     = atu-cota.nome-mic-reg and
                                      cotas.cod-rep          = atu-cota.cod-rep and
                                      cotas.cd-produto       = atu-cota.cd-produto and
                                      cotas.dt-inicial      <= atu-cota.dt-inicial and
                                      cotas.dt-final        >= atu-cota.dt-final  no-error.

                            if avail cotas then do:
                               if atu-cota.qt-ped-reprov = 0 then 
                                  assign atu-cota.qt-ped-reprov = atu-cota.qt-ped-reprov + atu-cota.qt-pedida 
                                         atu-cota.vl-ped-reprov = atu-cota.vl-ped-reprov + atu-cota.vl-pedido 
                                         cotas.qt-ped-reprov    = cotas.qt-ped-reprov + atu-cota.qt-ped-reprov 
                                         cotas.vl-ped-reprov    = cotas.vl-ped-reprov + atu-cota.vl-ped-reprov 
                                         cotas.qt-pedida        = cotas.qt-pedida - atu-cota.qt-pedida
                                         cotas.vl-pedido        = cotas.vl-pedido - atu-cota.vl-pedido
                                         atu-cota.qt-pedida     = 0
                                         atu-cota.vl-pedido     = 0.
                               else /*num mesmo pedido, tem um produto aprovado e outro reprovado. isso faz com
                                      que no atu-cota tenhamos um registro s¢, com quantidade aprovada e reprovado*/
                                  assign atu-cota.qt-ped-reprov = atu-cota.qt-ped-reprov + atu-cota.qt-pedida 
                                         atu-cota.vl-ped-reprov = atu-cota.vl-ped-reprov + atu-cota.vl-pedido 
                                         cotas.qt-ped-reprov    = cotas.qt-ped-reprov + atu-cota.qt-pedida 
                                         cotas.vl-ped-reprov    = cotas.vl-ped-reprov + atu-cota.vl-pedido 
                                         cotas.qt-pedida        = cotas.qt-pedida - atu-cota.qt-pedida
                                         cotas.vl-pedido        = cotas.vl-pedido - atu-cota.vl-pedido
                                         atu-cota.qt-pedida     = 0
                                         atu-cota.vl-pedido     = 0.
                            end.          
                          end.
                       end.
                    end.  

                    run pi-chamada-upc-reprovacao.

                end. /*l-atu-aprov*/    
            end. /*ped-parcial*/     
        end. /*last-of*/
    end.  
end.	

/******** FIM TRATA COTAS REPROVADAS *********/

return "OK".



procedure pi-validacoes.

    /************ Validacoes ************/
    for each tt-dados:

        /* nesse caso , nenhuma validaá∆o ser† feita */
        if tt-dados.log-tipo-oper = 10 or    /*aprova foráado*/
           tt-dados.log-tipo-oper = 11 then  /*reprova foráado*/
           next.

        assign l-erro = no
               num-sit-com = 1.


        find par-cota no-lock where
             par-cota.cod-estabel = tt-dados.cod-estabel no-error.
        if not avail par-cota then 
           assign l-erro  = yes.
        else do:

            /*Verifica se o pedido e Aberto e se controla pedido aberto*/   
            if  tt-dados.tipo-pedido = 2 then do:
                if  par-cota.pedido-aberto = no then
                    assign l-erro = yes.
            end.
            else do:

                /*Verifica se parametros estao Somente Faturamento e for Atualizacao de Pedido*/
                if  par-cota.gera-faturam and tt-dados.log-docto then do:
                    assign l-erro = yes.
                end.
                else do:
                     find last  base-cota where
                                base-cota.cod-estabel = par-cota.cod-estabel and
                                base-cota.cd-produto  = tt-dados.it-codigo and
                                base-cota.dt-inicial <= ( if par-cota.tipo-data = 1 then
                                                             tt-dados.dt-emissao    else
                                                             tt-dados.dt-entrega )  and
                                base-cota.dt-final   >= ( if par-cota.tipo-data = 1 then
                                                             tt-dados.dt-emissao    else
                                                             tt-dados.dt-entrega )  no-lock no-error.

                     if avail base-cota and
                        base-cota.cd-produto <> base-cota.cd-produto-dest then do:
                        assign c-produto-aux = base-cota.cd-produto-dest.
                        find last  base-cota where
                                   base-cota.cod-estabel = par-cota.cod-estabel and
                                   base-cota.cd-produto  = c-produto-aux and
                                   base-cota.dt-inicial <= ( if par-cota.tipo-data = 1 then
                                                                tt-dados.dt-emissao    else
                                                                tt-dados.dt-entrega )  and
                                   base-cota.dt-final   >= ( if par-cota.tipo-data = 1 then
                                                                tt-dados.dt-emissao    else
                                                                tt-dados.dt-entrega )  no-lock no-error.

                     end.

                     if not avail base-cota then 
                        assign l-erro = yes.
                     else do:
                         /** chamada de upc **/
                         if tt-dados.nivel = "Representante" then
                            run pi-chamada-upc-validacoes.

                         assign de-vl-aux    = if par-cota.tipo-valor = 1 then tt-dados.valor-unit-bru else tt-dados.valor-unit-liq
                                de-qt-aux    = tt-dados.quantidade. 


                         find last cotas where
                                   cotas.cod-estabel = tt-dados.cod-estabel and
                                   cotas.cod-canal-venda = tt-dados.cod-canal-venda and
                                   cotas.cod-gr-cli = tt-dados.cod-gr-cli and
                                   cotas.nome-abrev = tt-dados.nome-abrev-cotas and
                                   cotas.nome-ab-reg = tt-dados.nome-ab-reg and
                                   cotas.nome-mic-reg = tt-dados.nome-mic-reg and
                                   cotas.cod-rep = tt-dados.cod-rep and
                                   cotas.cd-produto = base-cota.cd-produto-dest and
                                   cotas.dt-inicial <= (if par-cota.tipo-data = 1 then
                                                           tt-dados.dt-emissao    else
                                                           tt-dados.dt-entrega) and
                                   cotas.dt-final   >= (if par-cota.tipo-data = 1 then
                                                           tt-dados.dt-emissao    else
                                                           tt-dados.dt-entrega) no-lock no-error.

                         if not avail cotas then do:

                            /** Nivel Canal Venda **/ 
                            if  tt-dados.nivel = "Canal" then do:
                                if par-cota.cota-impl-canal-venda   = 1  and
                                   tt-dados.log-tipo-oper          <> 8  and  /* aprova/desaprova */ 
                                   tt-dados.log-tipo-oper          <> 5  then /* diminui */

                                   assign num-sit-com = 3
                                          l-erro      = yes.  
                            end.  


                            /** Nivel Grupo Cliente **/ 
                            if  tt-dados.nivel = "Grupo" then do:
                                if par-cota.cota-impl-gr-cli   = 1  and
                                   tt-dados.log-tipo-oper          <> 8  and  /* aprova/desaprova */ 
                                   tt-dados.log-tipo-oper          <> 5  then /* diminui */

                                   assign num-sit-com = 3
                                          l-erro      = yes.  

                            end. /*grupo cliente*/

                            /** Nivel Cliente **/ 
                            if  tt-dados.nivel = "Cliente" then do:
                                if par-cota.cota-impl-cliente    = 1  and
                                   tt-dados.log-tipo-oper          <> 8  and  /* aprova/desaprova */ 
                                   tt-dados.log-tipo-oper          <> 5  then  /* diminui */

                                   assign num-sit-com = 3
                                          l-erro      = yes.  

                            end. /*cliente*/


                            /** Nivel Regiao **/ 
                            if  tt-dados.nivel = "Regiao" then do:
                                if par-cota.cota-impl-ab-reg        = 1  and
                                   tt-dados.log-tipo-oper          <> 8  and  /* aprova/desaprova */ 
                                   tt-dados.log-tipo-oper          <> 5  then  /* diminui */

                                   assign num-sit-com = 3
                                          l-erro      = yes.  

                            end. /*regiao*/                                 

                            /** Nivel Microrregiao **/ 
                            if  tt-dados.nivel = "Microrregiao" then do:
                                if par-cota.cota-impl-mic-reg   = 1  and
                                   tt-dados.log-tipo-oper          <> 8  and /* aprova/desaprova */ 
                                   tt-dados.log-tipo-oper          <> 5  then  /* diminui */

                                   assign num-sit-com = 3
                                          l-erro      = yes.  

                            end.                                   

                            /** Nivel Representante **/ 
                            if  tt-dados.nivel = "Representante" then do:
                                if par-cota.cota-impl-repres       = 1  and
                                   tt-dados.log-tipo-oper          <> 8  and  /* aprova/desaprova */ 
                                   tt-dados.log-tipo-oper          <> 5  then /* diminui */
                                   assign num-sit-com = 3
                                          l-erro      = yes.  
                            end.    

                         end. /*not avail cotas*/

                         else do:
                            if l-erro = no then do:
                               /* Verifica se o canal controla cotas para o periodo */ 
                               if par-cota.Cont-canal-venda and
                                  cotas.cod-canal-venda <> ? then do:
                                  if can-find(first canal-venda no-lock where 
                                                    canal-venda.cod-canal-venda      = cotas.cod-canal-venda and
                                                    canal-venda.dat-inic-ctrl-cotas  > cotas.dt-inicial    ) then  
                                     assign l-erro = yes.
                               end. 
                            end.      
                         end. /*if avail cotas*/
                     end. /* if avail base-cota */                       
                end. /*else if par-cota*/                            
            end. /*verifica pedido aberto*/
        end. /* if avail par-cota */

        if l-erro = yes then do:
           for each b-tt-dados where
                    b-tt-dados.nome-abrev = tt-dados.nome-abrev and
                    b-tt-dados.nr-docto = tt-dados.nr-docto and
                    b-tt-dados.it-codigo = tt-dados.it-codigo and
                    b-tt-dados.nr-sequencia = tt-dados.nr-sequencia:
                    assign b-tt-dados.cod-sit-com = num-sit-com
                           b-tt-dados.log-erro = yes.
           end.
        end.  
        else do:  
            find first b-tt-dados no-lock where
                       b-tt-dados.nome-abrev = tt-dados.nome-abrev and
                       b-tt-dados.nr-docto = tt-dados.nr-docto and
                       b-tt-dados.it-codigo = tt-dados.it-codigo and
                       b-tt-dados.nr-sequencia = tt-dados.nr-sequencia and
                       b-tt-dados.log-erro = yes no-error.
            if  avail b-tt-dados then 
                assign tt-dados.cod-sit-com = b-tt-dados.cod-sit-com
                       tt-dados.log-erro = yes.
        end.                      

    end. /* for each tt-dados*/


end procedure.


procedure pi-nao-encontrou-cotas.

    /** Nivel Canal Venda **/ 
    if tt-dados.nivel = "Canal" then do:
       if par-cota.cota-impl-canal-venda = 2 then do:
          if tt-dados.log-tipo-oper = 1 or tt-dados.log-tipo-oper = 3 then do:

             run pi-cria-cotas.

             {utp/ut-liter.i Cotas MAC c} c-texto[1] = trim(return-value).
             {utp/ut-liter.i n°vel_Canal_Venda MAC c} c-texto[2] = trim(return-value).
             run utp/ut-msgs.p (input "msg",
                                input 16381,
                                input c-texto[1] + "~~" + c-texto[2] ).
             create tt-erros.
             assign tt-erros.codigo-erro = 16381
                    tt-erros.parametros = c-texto[1] + "~~" + c-texto[2]
                    tt-erros.descricao   = return-value.
          end.
          else     
              assign tt-dados.cod-sit-com = 3.
       end.
       if par-cota.cota-impl-canal-venda = 3 then do: 

          if tt-dados.log-tipo-oper = 1 or tt-dados.log-tipo-oper = 3 then 
             run pi-cria-cotas.
          else     
             assign tt-dados.cod-sit-com = 3.
       end.  
    end. 

    /** Nivel Grupo Cliente **/ 
    if tt-dados.nivel = "Grupo" then do:
       if par-cota.cota-impl-gr-cli = 2 then do:
          if tt-dados.log-tipo-oper = 1 or tt-dados.log-tipo-oper = 3 then do:
             run pi-cria-cotas.

             {utp/ut-liter.i Cotas MAC c} c-texto[1] = trim(return-value).
             {utp/ut-liter.i n°vel_Grupo MAC c} c-texto[2] = trim(return-value).
             run utp/ut-msgs.p (input "msg",
                                input 16381,
                                input c-texto[1] + "~~" + c-texto[2] ).
             create tt-erros.
             assign tt-erros.codigo-erro = 16381
                    tt-erros.parametros = c-texto[1] + "~~" + c-texto[2]
                    tt-erros.descricao   = return-value.
          end.
          else     
             assign tt-dados.cod-sit-com = 3.
       end.
       if par-cota.cota-impl-gr-cli = 3 then do:
          if tt-dados.log-tipo-oper = 1 or tt-dados.log-tipo-oper = 3 then 
             run pi-cria-cotas.
          else     
             assign tt-dados.cod-sit-com = 3.
       end.                      

    end. /*grupo cliente*/

    /** Nivel Cliente **/ 
    if tt-dados.nivel = "Cliente" then do:
       if par-cota.cota-impl-cliente = 2 then do:
          if tt-dados.log-tipo-oper = 1 or tt-dados.log-tipo-oper = 3 then do:
             run pi-cria-cotas.
             {utp/ut-liter.i Cotas MAC c} c-texto[1] = trim(return-value).
             {utp/ut-liter.i n°vel_Cliente MAC c} c-texto[2] = trim(return-value).
             run utp/ut-msgs.p (input "msg",
                                input 16381,
                                input c-texto[1] + "~~" + c-texto[2] ).
             create tt-erros.
             assign tt-erros.codigo-erro = 16381
                    tt-erros.parametros = c-texto[1] + "~~" + c-texto[2]
                    tt-erros.descricao   = return-value.
          end.
          else     
             assign tt-dados.cod-sit-com = 3.
       end.

       if par-cota.cota-impl-cliente = 3 then do:
          if tt-dados.log-tipo-oper = 1 or tt-dados.log-tipo-oper = 3 then 
             run pi-cria-cotas.
          else     
             assign tt-dados.cod-sit-com = 3.
       end.                      

    end. /*cliente*/


    /** Nivel Regiao **/ 
    if tt-dados.nivel = "Regiao" then do:
       if par-cota.cota-impl-ab-reg = 2 then do: 
          if tt-dados.log-tipo-oper = 1 or tt-dados.log-tipo-oper = 3 then do:
             run pi-cria-cotas.

             {utp/ut-liter.i Cotas MAC c} c-texto[1] = trim(return-value).
             {utp/ut-liter.i n°vel_Regi∆o MAC c} c-texto[2] = trim(return-value).
             run utp/ut-msgs.p (input "msg",
                                input 16381,
                                input c-texto[1] + "~~" + c-texto[2] ).
             create tt-erros.
             assign tt-erros.codigo-erro = 16381
                    tt-erros.parametros = c-texto[1] + "~~" + c-texto[2]
                    tt-erros.descricao   = return-value.
          end.
          else     
             assign tt-dados.cod-sit-com = 3.
       end.
       if par-cota.cota-impl-ab-reg = 3 then do:
          if tt-dados.log-tipo-oper = 1 or tt-dados.log-tipo-oper = 3 then 
             run pi-cria-cotas.
          else     
             assign tt-dados.cod-sit-com = 3.
       end.   
    end. /*regiao*/                                 

    /** Nivel Microrregiao **/ 
    if tt-dados.nivel = "Microrregiao" then do:
       if par-cota.cota-impl-mic-reg = 2 then do:
          if tt-dados.log-tipo-oper = 1 or tt-dados.log-tipo-oper = 3 then do:

             run pi-cria-cotas.

             {utp/ut-liter.i Cotas MAC c} c-texto[1] = trim(return-value).
             {utp/ut-liter.i n°vel_Microrregi∆o MAC c} c-texto[2] = trim(return-value).
             run utp/ut-msgs.p (input "msg",
                                input 16381,
                                input c-texto[1] + "~~" + c-texto[2] ).
             create tt-erros.
             assign tt-erros.codigo-erro = 16381
                    tt-erros.parametros = c-texto[1] + "~~" + c-texto[2]
                    tt-erros.descricao   = return-value.
          end.  
          else     
             assign tt-dados.cod-sit-com = 3.
       end.
       if par-cota.cota-impl-mic-reg = 3 then do:
          if tt-dados.log-tipo-oper = 1 or tt-dados.log-tipo-oper = 3 then 
             run pi-cria-cotas.
          else     
             assign tt-dados.cod-sit-com = 3.
       end.                   
    end.                                   

    /** Nivel Representante **/ 
    if tt-dados.nivel = "Representante" then do:
       if par-cota.cota-impl-repres = 2 then do:
          if tt-dados.log-tipo-oper = 1 or tt-dados.log-tipo-oper = 3 then do:

             run pi-cria-cotas.
             {utp/ut-liter.i Cotas MAC c} c-texto[1] = trim(return-value).
             {utp/ut-liter.i n°vel_Representante MAC c} c-texto[2] = trim(return-value).
             run utp/ut-msgs.p (input "msg",
                                input 16381,
                                input c-texto[1] + "~~" + c-texto[2] ).

             create tt-erros.
             assign tt-erros.codigo-erro = 16381
                    tt-erros.parametros = c-texto[1] + "~~" + c-texto[2]
                    tt-erros.descricao   = return-value.                                                  
          end.  
          else     
             assign tt-dados.cod-sit-com = 3.
       end.
       if par-cota.cota-impl-repres = 3 then do:
          if tt-dados.log-tipo-oper = 1 or tt-dados.log-tipo-oper = 3 then 
             run pi-cria-cotas.
          else     
             assign tt-dados.cod-sit-com = 3.

       end.                    
    end.    


end.


procedure pi-trata-aprova-reprovacao-forcada.

    /* atualiza cotas e base-cota para aprovacao e reprovacao forcada */ 
    if not avail cotas then do:
       /* nr da transacao */ 
       for last b-cotas fields(nr-trans) no-lock use-index ch-cot :
           assign i-nr-trans =  ( b-cotas.nr-trans + 1 ) .    
       end.
       if not avail b-cotas then
          assign i-nr-trans = 1.    

       create cotas.
       assign cotas.cod-estabel      = tt-dados.cod-estabel
              cotas.cod-canal-venda  = tt-dados.cod-canal-venda
              cotas.cod-gr-cli       = tt-dados.cod-gr-cli
              cotas.nome-abrev       = tt-dados.nome-abrev-cotas
              cotas.nome-ab-reg      = tt-dados.nome-ab-reg
              cotas.nome-mic-reg     = tt-dados.nome-mic-reg
              cotas.cod-rep          = tt-dados.cod-rep
              cotas.cd-produto       = base-cota.cd-produto-dest
              cotas.dt-inicial       = base-cota.dt-inicial
              cotas.dt-final         = base-cota.dt-final
              cotas.nr-trans         = i-nr-trans
              cotas.vl-previsto      = 0
              cotas.qt-prevista      = 0.
    end.
    if tt-dados.log-tipo-oper = 10 then do: /*aprovacao forcada*/ 
       assign cotas.qt-pedida      = cotas.qt-pedida + de-qt-aux
              cotas.vl-pedido      = cotas.vl-pedido + de-vl-aux
              tt-dados.cod-sit-com = 2. /*aprov*/
              tt-dados.log-erro    = yes /*para que nao entre rotinas posteriores*/ . 

       if tt-dados.cod-rep <> ? then do:
          if par-cota.tipo-controle = 2 then 
             assign base-cota.qt-pedida = base-cota.qt-pedida + de-vl-aux.
          else   
             assign base-cota.qt-pedida = base-cota.qt-pedida + de-qt-aux.
       end.      
    end.          
    if tt-dados.log-tipo-oper = 11 then /*reprovacao forcada*/
       assign cotas.qt-ped-reprov  = cotas.qt-ped-reprov + de-qt-aux
              cotas.vl-ped-reprov  = cotas.vl-ped-reprov + de-vl-aux
              tt-dados.cod-sit-com = 3 /*reprov*/
              tt-dados.log-erro    = yes /*para que nao entre rotinas posteriores*/ . 

    /* atualiza atu-cota */       
    find last  atu-cota
         where atu-cota.cod-estabel      =  cotas.cod-estabel
         and   atu-cota.cod-canal-venda  =  cotas.cod-canal-venda
         and   atu-cota.cod-gr-cli       =  cotas.cod-gr-cli
         and   atu-cota.nome-abrev-cotas =  cotas.nome-abrev
         and   atu-cota.nome-abrev       =  tt-dados.nome-abrev
         and   atu-cota.nome-ab-reg      =  cotas.nome-ab-reg
         and   atu-cota.nome-mic-reg     =  cotas.nome-mic-reg
         and   atu-cota.cod-rep          =  cotas.cod-rep
         and   atu-cota.cd-produto       =  cotas.cd-produto        
         and   atu-cota.dt-inicial      <= (if par-cota.tipo-data = 1 then tt-dados.dt-emissao else tt-dados.dt-entrega)
         and   atu-cota.nr-pedcli        =  tt-dados.nr-docto exclusive-lock no-error.

    if not avail atu-cota then do:
       create atu-cota.
       assign  atu-cota.nome-abrev       =  tt-dados.nome-abrev
               atu-cota.nr-pedcli        =  tt-dados.nr-docto
               atu-cota.cod-estabel      =  cotas.cod-estabel
               atu-cota.cod-canal-venda  =  cotas.cod-canal-venda
               atu-cota.cod-gr-cli       =  cotas.cod-gr-cli
               atu-cota.nome-ab-reg      =  cotas.nome-ab-reg
               atu-cota.nome-mic-reg     =  cotas.nome-mic-reg
               atu-cota.cod-rep          =  cotas.cod-rep
               atu-cota.cd-produto       =  cotas.cd-produto   
               atu-cota.nome-abrev-cotas =  cotas.nome-abrev    
               atu-cota.dt-inicial       = (if par-cota.tipo-data = 1 then
                                               tt-dados.dt-emissao    else
                                               tt-dados.dt-entrega)
               atu-cota.dt-final         =  cotas.dt-final no-error.
       if tt-dados.log-tipo-oper = 10 then  /*aprovacao forcada*/
          assign atu-cota.qt-pedida = de-qt-aux 
                 atu-cota.vl-pedido = de-vl-aux. 
       if tt-dados.log-tipo-oper = 11 then  /*reprovacao forcada*/            
          assign atu-cota.qt-ped-reprov = de-qt-aux 
                 atu-cota.vl-ped-reprov = de-vl-aux.
    end.
    else do:
       if tt-dados.log-tipo-oper = 10 then /*aprovacao forcada*/
          assign atu-cota.qt-pedida = atu-cota.qt-pedida + de-qt-aux
                 atu-cota.vl-pedido = atu-cota.vl-pedido + de-vl-aux.
       if tt-dados.log-tipo-oper = 11 then /*reprovacao forcada*/
          assign atu-cota.qt-ped-reprov = atu-cota.qt-ped-reprov + de-qt-aux 
                 atu-cota.vl-ped-reprov = de-vl-aux + atu-cota.vl-ped-reprov.
    end. 

end procedure.



procedure pi-cria-cotas.

    /* nr da transacao */ 
    for last b-cotas fields(nr-trans) no-lock use-index ch-cot :
        assign i-nr-trans =  ( b-cotas.nr-trans + 1 ) .    
    end.
    if not avail b-cotas then
       assign i-nr-trans = 1.    

    if not avail cotas then do: 
       create cotas.
       assign cotas.cod-estabel      = tt-dados.cod-estabel
              cotas.cod-canal-venda  = tt-dados.cod-canal-venda
              cotas.cod-gr-cli       = tt-dados.cod-gr-cli
              cotas.nome-abrev       = tt-dados.nome-abrev-cotas
              cotas.nome-ab-reg      = tt-dados.nome-ab-reg
              cotas.nome-mic-reg     = tt-dados.nome-mic-reg
              cotas.cod-rep          = tt-dados.cod-rep
              cotas.cd-produto       = base-cota.cd-produto-dest
              cotas.dt-inicial       = base-cota.dt-inicial
              cotas.dt-final         = base-cota.dt-final
              cotas.nr-trans         = i-nr-trans
              cotas.vl-previsto      = 0
              cotas.qt-prevista      = 0.
    end.          

end procedure.


procedure pi-chamada-upc-validacoes.
  /*
   Chamada de upc num ponto estratÇgico desse programa, com objetivo de validar outras tabelas, espec°ficas
   de alguns clientes, como por exemplo , a Grendene 
  */   
  for each tt-epc where tt-epc.cod-event = "validation".
      delete tt-epc.
  end.

  raw-transfer tt-dados to raw-param.

  /* Include i-epc200.i2: Criaá∆o de registro para Temp-Table tt-epc */
  {include/i-epc200.i2 &CodEvent='"validation"'
                       &CodParameter='"raw-tt-dados"'
                       &ValueParameter="string(raw-param)"}

  /* Include i-epc201.i: Chamada do programa de EPC */
  {include/i-epc201.i "validation"}.

  /** trata erro **/
  if return-value = "NOK" then 
     assign l-erro = yes.



end procedure.

procedure pi-chamada-upc-desatualizacao.
  /*
   Chamada de upc num ponto estratÇgico desse programa, com objetivo de desatualizar outras tabelas, espec°ficas
   de alguns clientes, como por exemplo , a Grendene 
  */   
  for each tt-epc where tt-epc.cod-event = "unupdate".
      delete tt-epc.
  end.

  raw-transfer tt-dados to raw-param.

  /* Include i-epc200.i2: Criaá∆o de registro para Temp-Table tt-epc */
  {include/i-epc200.i2 &CodEvent='"unupdate"'
                       &CodParameter='"raw-tt-dados"'
                       &ValueParameter="string(raw-param)"}

  /* Include i-epc201.i: Chamada do programa de EPC */
  {include/i-epc201.i "unupdate"}.

end procedure.


procedure pi-chamada-upc-atualizacao.

  /*
   Chamada de upc num ponto estratÇgico desse programa, com objetivo de atualizar outras tabelas, espec°ficas
   de alguns clientes, como por exemplo , a Grendene 
  */   
  for each tt-epc where tt-epc.cod-event = "update".
      delete tt-epc.
  end.

  raw-transfer tt-dados to raw-param.

  /* Include i-epc200.i2: Criaá∆o de registro para Temp-Table tt-epc */
  {include/i-epc200.i2 &CodEvent='"update"'
                       &CodParameter='"raw-tt-dados"'
                       &ValueParameter="string(raw-param)"}

  /* Include i-epc201.i: Chamada do programa de EPC */
  {include/i-epc201.i "update"}.


  /** trata erro **/
  if return-value = "NOK" then do:
     if i-nr-erro[1] <> 0 and
        i-nr-erro[1] = 16208 then do:        
        run utp/ut-msgs.p (input "msg",
                           input i-nr-erro[1],
                           input base-cota.cd-produto-dest).
        create tt-erros.
        assign tt-erros.codigo-erro = i-nr-erro[1]
               tt-erros.parametros  = base-cota.cd-produto-dest
               tt-erros.descricao   = return-value.  
     end. 
     if i-nr-erro[2] <> 0 and
        i-nr-erro[2] = 16381 then do:        
        {utp/ut-liter.i Cotas MAC c} c-texto[1] = trim(return-value).
        {utp/ut-liter.i n°vel_Vendedor MAC c} c-texto[2] = trim(return-value).
        run utp/ut-msgs.p (input "msg",
                           input i-nr-erro[2],
                           input c-texto[1] + "~~" + c-texto[2] ). 

        create tt-erros.
        assign tt-erros.codigo-erro = i-nr-erro[2]
               tt-erros.parametros = c-texto[1] + "~~" + c-texto[2]
               tt-erros.descricao   = return-value.                   
     end. 
     if i-nr-erro[3] = 1 then /* significa que na upc, o nivel de vendedor foi reprovado */
        assign tt-dados.log-reprov-vend = yes
               tt-dados.cod-sit-com     = 3 
               i-nr-erro                = 0. 

     assign i-nr-erro = 0.
  end.
end procedure.


procedure pi-chamada-upc-reprovacao.
  /*
   Chamada de upc num ponto estratÇgico desse programa, com objetivo de reprovar as cotas
   de tabelas espec°ficas de alguns clientes, como por exemplo , a Grendene. 
  */   
  for each tt-epc where tt-epc.cod-event = "reprove".
      delete tt-epc.
  end.

  raw-transfer tt-dados to raw-param.

  /* Include i-epc200.i2: Criaá∆o de registro para Temp-Table tt-epc */
  {include/i-epc200.i2 &CodEvent='"reprove"'
                       &CodParameter='"raw-tt-dados"'
                       &ValueParameter="string(raw-param)"}

  /* Include i-epc201.i: Chamada do programa de EPC */
  {include/i-epc201.i "reprove"}.

end procedure.


&endif
