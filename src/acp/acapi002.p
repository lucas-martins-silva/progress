/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ACAPI002 2.00.00.030}  /*** 010030 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i acapi002 MAC}
&ENDIF

/********************************************************************************
** Programa : acp/acapi002.p
**
** Data     : 28/08/98
**
** Autor    : Datasul S.A.
**
** Objetivo : API que atualiza cotas.
**
** Versao   : Eder Carlos Querino - Planner - Criacao - 27/08/1998
**
** Alteracao: Emerson Wessling - Planner - 02/1999
**            Adriano Marcelo            - 05/1999 
********************************************************************************/

/***************************   A T E N C A O   *********************************
 ESSA API E EXECUTADA NA RELEASE 2.02 DO DICIONARIO. EXISTE UMA SEMELHANTE PARA  
 A RELEASE 2.03 DO DICIONARIO. SE VC ALTERAR ESSA, NAO ESQUECA DE VERIFICAR  SE 
 A ACAPI003 TMB NÇO PRECISA SER MUDADA.
********************************************************************************/

/*** Uso de preprocessador ***/
{cdp/cdcfgdis.i}

/* Usado preprocessador porque na release 2.03 estava dando erro
   de compilacao, na liberacao dos objetos para expedi‡Æo */
&if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */
 /* 2.03 , usa a acapi007 */
&else 
 /* 2.02 , usa essa api */



{acp/acapi002.i}

def input        param table for tt-configuracao.
def input-output param table for tt-dados.
def output       param table for tt-erros.

def var r-cotas       as rowid                 no-undo.
def var de-qt-aux     as decimal               no-undo.
def var de-vl-aux     as decimal               no-undo.
def var l-ja-reprovou as log init no           no-undo.
def var de-cotacao    as decimal               no-undo.
def var l-atualizou   as log init no           no-undo.
def var de-pontos     like base-cota.nr-pontos no-undo.
def var c-texto       as char extent 2         no-undo.
def var i-nr-trans    as int                   no-undo.

DEF BUFFER b-cotas FOR cotas.


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
if tt-configuracao.tipo-atu <> 1 and
   tt-configuracao.tipo-atu <> 2 then do:
  run utp/ut-msgs.p (input "msg", input 8646, input "").
  create tt-erros.
  assign tt-erros.codigo-erro = 8646
         tt-erros.descricao = return-value.
  return "NOK".
end.  

/*********************  ATUALIZACAO DE COTAS CFE ATU-COTA ******************
 ***************************************************************************
 * No caso de Cotas ja ter sido atualizado, sera diminuido o valor na tab  * 
 * Cotas baseado em Atu-cota respeitado a operacao que esta sendo realiza- *
 * da. Logo apos a atualizacao, atu-cota e excluida, sendo criada novamen- *
 * te no final deste programa.                                             *
 ***************************************************************************/

for each tt-dados
    break by tt-dados.nome-abrev 
          by tt-dados.nr-docto:

    if  last-of(tt-dados.nome-abrev) 
    or  last-of(tt-dados.nr-docto) then do:

        if  tt-dados.log-docto = yes then do: /* implantacao pedidos */ 

            for each atu-cota NO-LOCK
               where atu-cota.nome-abrev = tt-dados.nome-abrev
                 and atu-cota.nr-pedcli  = tt-dados.nr-docto:

                find par-cota no-lock
               where par-cota.cod-estabel = atu-cota.cod-estabel no-error.

                if  not avail par-cota then 
                    next.

                find last base-cota exclusive-lock
                     where base-cota.cod-estabel = atu-cota.cod-estabel
                     and   base-cota.cd-produto  = atu-cota.cd-produto
                     and   base-cota.dt-inicial <= atu-cota.dt-inicial no-error.

                find last  cotas exclusive-lock
                     where cotas.cod-estabel     = atu-cota.cod-estabel
                     and   cotas.cod-canal-venda = atu-cota.cod-canal-venda
                     and   cotas.cod-gr-cli      = atu-cota.cod-gr-cli
                     and   cotas.nome-abrev      = tt-dados.nome-abrev-cotas
                     and   cotas.nome-ab-reg     = atu-cota.nome-ab-reg
                     and   cotas.nome-mic-reg    = atu-cota.nome-mic-reg
                     and   cotas.cod-rep         = atu-cota.cod-rep
                     and   cotas.cd-produto      = atu-cota.cd-produto
                     and   cotas.dt-inicial     <= atu-cota.dt-inicial no-error.
                if  avail cotas and avail base-cota then do:

                    if  atu-cota.qt-pedida > 0 then do:
                        assign cotas.qt-pedida = cotas.qt-pedida - atu-cota.qt-pedida
                               cotas.vl-pedido = cotas.vl-pedido - atu-cota.vl-pedido.
                        if  par-cota.tipo-controle = 2 then    /* valor */
                            assign base-cota.qt-pedida = base-cota.qt-pedida - atu-cota.vl-pedido.
                        else     /* quantidade, pontos */   
                            assign base-cota.qt-pedida = base-cota.qt-pedida - atu-cota.qt-pedida.
                    end.
                    if  atu-cota.qt-ped-susp > 0 then do:
                        assign cotas.qt-ped-susp = cotas.qt-ped-susp - atu-cota.qt-ped-susp
                               cotas.vl-ped-susp = cotas.vl-ped-susp - atu-cota.vl-ped-susp.
                    end.
                    if  atu-cota.qt-ped-canc > 0 then do:
                        assign cotas.qt-ped-canc = cotas.qt-ped-canc - atu-cota.qt-ped-canc
                               cotas.vl-ped-canc = cotas.vl-ped-canc - atu-cota.vl-ped-canc.               
                    end.
                    delete atu-cota.

                end. /*if avail cotas e base-cota*/
            end. /*for each atu-cota*/
        end. /*log docto*/
    end. /*if last-of*/    
end. /*for each tt-dados*/

/*************************** ATUALIZACAO DE COTAS **************************/

for each tt-dados:

    /*verifica se encontra par-cota*/
    find par-cota no-lock
   where par-cota.cod-estabel = tt-dados.cod-estabel no-error.
    if  not avail par-cota then
        next.


/*    /*Tipo de atualizacao Bath-OnLine*/   
    if  tt-configuracao.tipo-atu <> par-cota.tipo-atu then
        next.
*/
    /*Verifica se o pedido ý Aberto e se controla pedido aberto*/   
    if  tt-dados.tipo-pedido = 2 then 
        if  par-cota.pedido-aberto = no then
            next.

    /*Verifica se parametros esta Somente Faturamento e for Atualizacao de Pedido*/
    if  par-cota.gera-faturam and tt-dados.log-docto then
        next.

    find last  base-cota  NO-LOCK
         where base-cota.cod-estabel = par-cota.cod-estabel 
         and   base-cota.cd-produto  = tt-dados.it-codigo 
         and   base-cota.dt-inicial <= (if par-cota.tipo-data = 1 then tt-dados.dt-emissao  else tt-dados.dt-entrega) no-error.

    if not avail base-cota then next.

    /* Verifica Data de bloqueio da Cota */
    if base-cota.dt-bloqueio <=  (if par-cota.tipo-data = 1 then tt-dados.dt-emissao  else tt-dados.dt-entrega) then do:
       assign tt-dados.cod-sit-com = 3 .
       next.
    end.

    assign de-vl-aux    = if par-cota.tipo-valor = 1 then tt-dados.valor-unit-bru else tt-dados.valor-unit-liq
           de-qt-aux    = tt-dados.quantidade. 
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

    /* Vefifica se existe cotas para este pedido ou nota-fiscal para efetuar a atualiza¯Êo*/
    run acp/acapi004.p (input tt-dados.cod-estabel,
                        input tt-dados.cod-rep,
                        input tt-dados.it-codigo,
                        input tt-dados.dt-emissao,                        
                        input tt-dados.cod-canal-venda,
                        input tt-dados.cod-gr-cli,
                        input tt-dados.nome-abrev,
                        input tt-dados.nome-ab-reg,
                        input tt-dados.nome-mic-reg,
                        output r-cotas).

    find cotas exclusive-lock where rowid(cotas) = r-cotas no-error. 
    if not avail cotas then
       run pi-nao-encontrou-cotas.

    if  avail cotas then do:

        assign l-atualizou = yes.
        if  tt-dados.log-tipo-oper <> 8    /* aprova¯Êo/reprova¯Êo*/
        and tt-dados.log-tipo-oper <> 5 then  /*exclusÊo na aprov/reprov*/  
            assign tt-dados.cod-sit-com = 2.

       /*Cotas Maxima*/
       if par-cota.tipo-cota            = 2   and
          tt-dados.log-docto            = yes and
        ( tt-dados.log-tipo-oper        = 1   or 
          tt-dados.log-tipo-oper        = 3   or
          tt-dados.log-tipo-oper        = 8   or
         (tt-dados.log-tipo-oper        = 2   and 
          par-cota.aval-ped-susp = yes)           ) then do:

          /*Valida se cota Pedida ý maior que base cota Prevista*/
          if (base-cota.qt-pedida + de-qt-aux) > base-cota.qt-prevista and
              par-cota.cota-geral              =  1                    then do:  /*rejeita*/
              assign tt-dados.cod-sit-com = 3
                     l-ja-reprovou        = yes.
              next.
          end.  

          /*Valida se cotas Pedida ý maior que base cota Prevista*/
          if (base-cota.qt-pedida + de-qt-aux) > base-cota.qt-prevista and
              par-cota.cota-geral              = 2                     then do: /*prossegue*/

             run utp/ut-msgs.p (input "msg", input 16235 , input "").
             create tt-erros.
             assign tt-erros.codigo-erro = 16235
                    tt-erros.descricao = return-value.

          end.


          /*Valida se cotas Pedidas ý maior que Cotas prevista*/
          if (par-cota.tipo-controle  = 2 and (cotas.vl-pedido + de-vl-aux > cotas.vl-previsto)) or
             (par-cota.tipo-controle <> 2 and (cotas.qt-pedida + de-qt-aux > cotas.qt-prevista)) then do:

             if par-cota.aval-cota           = 1  and
                tt-dados.log-tipo-oper      <> 8  and /* aprova/desaprova */ 
                tt-dados.log-tipo-oper      <> 5  then do: /* diminui */

                assign tt-dados.cod-sit-com = 3
                       l-ja-reprovou        = yes.
                next.
             end.   

             if par-cota.aval-cota = 2 then do:
                run utp/ut-msgs.p (input "msg", input 16208, input tt-dados.it-codigo).
                create tt-erros.
                assign tt-erros.codigo-erro = 16208
                       tt-erros.parametros = tt-dados.it-codigo
                       tt-erros.descricao = return-value.
             end.
          end.

       end. /*if */

       /* Pedido Parcial */
       if  par-cota.ped-parcial    = no  and
           l-ja-reprovou           = yes and
           tt-dados.log-tipo-oper <> 8   and   /* aprova/desaprova */ 
           tt-dados.log-tipo-oper <> 5   then  /* diminui */
            assign tt-dados.cod-sit-com = 3.

       if  tt-dados.log-docto = yes then do: /* pedidos */

            /* inclusao e reativacao de pedidos */
            if  tt-dados.log-tipo-oper = 1 
            or  tt-dados.log-tipo-oper = 3 
            or  tt-dados.log-tipo-oper = 8 /* aprovacao/reprovacao ac1004 */
            then do:
                 assign cotas.qt-pedida = cotas.qt-pedida + de-qt-aux
                        cotas.vl-pedido = cotas.vl-pedido + de-vl-aux.
                 if par-cota.tipo-controle = 2 then /*valor*/
                    assign base-cota.qt-pedida = base-cota.qt-pedida + de-vl-aux.
                 else /*quantidade, pontos*/ 
                    assign base-cota.qt-pedida = base-cota.qt-pedida + de-qt-aux.   
            end.
            else do:            /* suspensao de pedidos */

                if (tt-dados.log-tipo-oper = 2 and par-cota.aval-ped-susp = yes) 
                or  tt-dados.log-tipo-oper = 9 then /*implantacao pedido sem credito*/
                   assign cotas.qt-ped-susp = cotas.qt-ped-susp + de-qt-aux
                          cotas.vl-ped-susp = cotas.vl-ped-susp + de-vl-aux.
            end.

            /* cancelamento de pedidos */
            if tt-dados.log-tipo-oper = 4 then
               assign cotas.qt-ped-canc = cotas.qt-ped-canc + de-qt-aux
                      cotas.vl-ped-canc = cotas.vl-ped-canc + de-vl-aux.

       end.
       else do:  
           /* operacoes com Nota Fiscal */ 

           /* inclusÊo nota fiscal */
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
        * Na parte superior desse programa foi diminuðdo atu-cota, cfe a   *
        * operacao. Agora ser˜ criada uma nova atu-cota com os novos valo- *
        * res, respeitando o tipo de operacao. Atu-cota sera sempre um es- *
        * pelho de Cotas.                                                  *
        ********************************************************************/  

       find last  atu-cota EXCLUSIVE-LOCK
            where atu-cota.cod-estabel     =  cotas.cod-estabel
            and   atu-cota.cod-canal-venda =  cotas.cod-canal-venda
            and   atu-cota.cod-gr-cli      =  cotas.cod-gr-cli
            and   atu-cota.nome-abrev      =  tt-dados.nome-abrev-cotas
            and   atu-cota.nome-ab-reg     =  cotas.nome-ab-reg
            and   atu-cota.nome-mic-reg    =  cotas.nome-mic-reg
            and   atu-cota.cod-rep         =  cotas.cod-rep
            and   atu-cota.cd-produto      =  cotas.cd-produto        
            and   atu-cota.dt-inicial     <= (if par-cota.tipo-data = 1 then tt-dados.dt-emissao else tt-dados.dt-entrega)
            and   atu-cota.nr-pedcli       =  tt-dados.nr-docto no-error.

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
                  atu-cota.dt-inicial       = (if par-cota.tipo-data = 1    then tt-dados.dt-emissao       else tt-dados.dt-entrega)
                  atu-cota.dt-final         =  cotas.dt-final no-error.

          /* inclui pedido / reativa / suspende com liberacao */
          if  tt-dados.log-tipo-oper = 1 
          or  tt-dados.log-tipo-oper = 8
          or  tt-dados.log-tipo-oper = 3 then
              assign atu-cota.qt-pedida = de-qt-aux 
                     atu-cota.vl-pedido = de-vl-aux.
          else          /* suspende pedido*/
              if (tt-dados.log-tipo-oper = 2 and par-cota.aval-ped-susp = yes)  
              or  tt-dados.log-tipo-oper = 9 /*implantacao pedido sem credito*/
              then 
                  assign atu-cota.qt-ped-susp =  de-qt-aux 
                         atu-cota.vl-ped-susp =  de-vl-aux.
          /*cancela pedido*/ 
          if tt-dados.log-tipo-oper = 4 then
          assign atu-cota.qt-ped-canc = de-qt-aux 
                 atu-cota.vl-ped-canc = de-vl-aux.

       end.
       else do:
          if avail atu-cota            and /* if avail atu-cota */
             tt-dados.log-tipo-oper <> 5   and /*em caso de eliminacao nao cria atu-cota*/
             tt-dados.log-docto     =  yes then do: /*pedidos*/        

            /* inclui pedido / reativa / suspende com liberacao */
            if  tt-dados.log-tipo-oper = 1 
            or  tt-dados.log-tipo-oper = 8
            or  tt-dados.log-tipo-oper = 3 then
                assign atu-cota.qt-pedida = atu-cota.qt-pedida + de-qt-aux
                       atu-cota.vl-pedido = atu-cota.vl-pedido + de-vl-aux.
            else              /* suspende pedido*/
                if (tt-dados.log-tipo-oper = 2 and par-cota.aval-ped-susp = yes)   
                or  tt-dados.log-tipo-oper = 9 then 
                    assign atu-cota.qt-ped-susp = atu-cota.qt-ped-susp + de-qt-aux
                           atu-cota.vl-ped-susp = atu-cota.vl-ped-susp + de-vl-aux.

            /*cancela pedido*/ 
            if tt-dados.log-tipo-oper = 4 then
               assign atu-cota.qt-ped-canc = atu-cota.qt-ped-canc + de-qt-aux 
                      atu-cota.vl-ped-canc = atu-cota.vl-ped-canc + de-vl-aux.

          end. /* avail atu-cota */
       end. /***else do***/
    end. /* if avail cotas */
    else 
        assign tt-dados.cod-sit-com = 3. /*reprova*/


end. /* for each tt-dados */

procedure pi-nao-encontrou-cotas.

   if par-cota.cota-implant = 2 then do:
      if tt-dados.log-tipo-oper = 1 or tt-dados.log-tipo-oper = 3 then do:

         run pi-cria-cotas.
         run utp/ut-msgs.p (input "msg",
                            input 26733,
                            input tt-dados.it-codigo).

         create tt-erros.
         assign tt-erros.codigo-erro = 26733
                tt-erros.parametros = tt-dados.it-codigo
                tt-erros.descricao   = return-value.                                                  
      end.  
      else     
         assign tt-dados.cod-sit-com = 3.
   end.
   if par-cota.cota-implant = 3 then do:
      if tt-dados.log-tipo-oper = 1 or tt-dados.log-tipo-oper = 3 then 
         run pi-cria-cotas.
      else     
         assign tt-dados.cod-sit-com = 3.

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
              cotas.cd-produto       = base-cota.cd-produto
              cotas.dt-inicial       = base-cota.dt-inicial
              cotas.dt-final         = base-cota.dt-final
              cotas.nr-trans         = i-nr-trans
              cotas.vl-previsto      = 0
              cotas.qt-prevista      = 0.
    end.          

end procedure.


return "OK".

&endif




