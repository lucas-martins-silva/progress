/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0923 2.00.00.044 } /*** "010044" 28/02/2025 09:42:30  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac0923 MAC}
&ENDIF

/********************************************************************************
** Programa  : acp/ac0923.p
** Data      : 08/10/1998
** Autor     : Datasul S.A.
** Objetivo  : Programa que faz a chamada da api0002.p Atualiza Cota.
** Versoes   : Emerson Wessling 
********************************************************************************/

/* ******************************************
 Programas que chamam o acp/ac0923.p:

 - ft0502.w     Cancelamento de nota-fiscal
 - pd0508.w     Implantacao de pedidos (na efetivacao) 
 - pd9701.p     Atualizacao (devolucao no recebimento) re1001 e re1005,
                Desatualizacao re0402,
                Faturamento ft2002, ft2003,etc.
 - pdapi152.p   Completa, suspensao, reativacao, cancelamento,
                eliminacao do pedido de venda pd0508, pd0502.
 - pd0802a.w    Aprovacao de pedido.
 - pd1509rp.p   Completa pedido Batch pd1509
 - b11di159.w   
****************************************************************  */

/****************  LEGENDA DO PARAMETRO I-TIPO-OPER *********************
*  Objetivo : retornar um valor inteiro, que indica o tipo de operacao  *
*             que sera realizado pela api de efetivacao de cotas        * 
*  Legenda  : 1 - Inclusao                                              *
*             2 - Suspensao                                             *
*             3 - Reativacao                                            *
*             4 - Cancelamento                                          *    
*             5 - Eliminacao                                            *
*             6 - Devolucao - atualizacao nota-fiscal re1001 e re1005   *    
*             7 - Desatualizacao nota fiscal no recebimento - re0402    *
*             8 - Aprova/Desaprova itens do pedido - AC1004.            *
*             9 - Na implantacao, pedido sem credito, atualiza quanti-  *
*                 dade "suspensa" em cotas. Valor setado nesse progra-  *
*                 ma. Nao vem como parametro de outro programa.         *
*            10 - Aprovaá∆o Foráada do Pedido /* ems203 ac1014 */       *
*            11 - Reprovaá∆o Foráada do Pedido /* ems203 ac1014 */      *  
*************************************************************************/

/********* ================ ATENÄ«O ================ *********/
/*         TODAS AS ALTERACOES EFETUADAS NESSE PRO-          */
/*         GRAMA, DEVERAO SER REALIZADAS TAMBEM NO           */
/*         AC1002RP.P - ATUALIZACAO BATCH DE COTAS.          */
/********* ================ ATENCAO ================ *********/

def input parameter rw-ped-venda    as rowid.   /* Recebe o rowid do ped-venda */
def input parameter c-item          like ped-item.it-codigo.   /* Definido para receber o itens que estao na
                                                                  nota fiscal ou documento (recebimento) .
                                                                  Quando e apenas o pedido que esta sendo 
                                                                  tratado, nao importa o item. Mas quando e 
                                                                  nota fiscal, precisamos saber o item. */
def input parameter i-tipo-oper     as int.     /* veja legenda acima */
def input parameter p-log-docto     as logical. /* Tipo de documento: Nota-fiscal ou Pedido  */

def var c-it-codigo                 like item.it-codigo         no-undo.
def var c-produto-aux               like cotas.cd-produto       no-undo. 
def var l-log-produto               like item-cota.log-produto  no-undo.
def var de-pontos                   like item-cota.nr-pontos    no-undo.
def var de-quantidade               like ped-item.qt-pedida     no-undo.
def var de-quantidade-aux           like ped-item.qt-pedida     no-undo.
def var de-quant-temp               like ped-item.qt-pedida     no-undo.
def var l-achou-reprov              as log                      no-undo.
def var l-achou-susp                as log                      no-undo.
def var l-nao-achou-base-cota       as log                      no-undo.
def var c-texto                     as char extent 2            no-undo.
def var dt-ini                      as date                     no-undo.

def var h-bodi605   as handle no-undo.
def var h-pdapi513e as handle no-undo.

def buffer b-ped-venda for ped-venda.

/* Include i-epc200.i: Definiá∆o Temp-Table tt-epc */
{include/i-epc200.i ac0923}

{cdp/cdcfgdis.i} /*include para pre-processadores*/

{acp/acapi002.i}

/*** Inicio chamada UPC ***/
if not(p-log-docto) then
    run pi-chama-upc-nota-fiscal.

if return-value = "NOK" then 
    RETURN "OK".
/*** Fim chamada UPC ***/

find first ped-venda no-lock where
     rowid(ped-venda) = rw-ped-venda no-error.

/*********************************************************************/
/**** Na implantacao de um pedido, se ele for reprovado por credito,**
 **** entao atualiza quantidade suspensa em cotas. i-tipo-oper = 9  **
 *********************************************************************/

/* PIÔs para tratar releases do dicionario */
&if defined (bf_dis_adm_cotas) &then           
     find first para-ped no-lock no-error.

     if  i-tipo-oper             = 1 and   /*implantacao pedido*/
        ((ped-venda.cod-sit-aval <> 2 and   
	   ped-venda.cod-sit-aval <> 3 and      /*avaliado - tem credito, mas vai testar 
                                                 novamente no faturamento */ 
	   para-ped.log-consid-credito-cotas = no) or
 	  (ped-venda.cod-sit-preco <> 2 and     /* Avaliaá∆o de Preáo */
	   para-ped.log-consid-precos-cotas = no) or
	  (ped-venda.ind-sit-desconto <> 2 and  /* Avaliaá∆o de Desconto */ 
	   para-ped.log-consid-desco-cotas = no)) then do:
	  assign i-tipo-oper = 9. 
    /*********************************************************************/
    /**** Verifica se o cliente esta com credito aprovado. Caso nao, *****
     ***** nenhuma atualizacao sera feita em cotas                   *****
     *********************************************************************/
	end.
	else do:
            if (ped-venda.cod-sit-aval <> 2 and   
     	         ped-venda.cod-sit-aval <> 3 and      /*avaliado - tem credito, mas vai testar 
                                                       novamente no faturamento */ 
     	         para-ped.log-consid-credito-cotas = no) or
               (ped-venda.cod-sit-preco <> 2 and     /* Avaliaá∆o de Preáo */
       	  para-ped.log-consid-precos-cotas = no) or
               (ped-venda.ind-sit-desconto <> 2 and  /* Avaliaá∆o de Desconto */ 
     	         para-ped.log-consid-desco-cotas = no) then
               return.
       end.
&else
    if  i-tipo-oper             = 1 and   /*implantacao pedido*/
        ped-venda.cod-sit-aval <> 2 and   /*avaliado - tem credito, mas vai testar 
                                            novamente no faturamento */ 
        ped-venda.cod-sit-aval <> 3 then   /*aprovado*/
          assign i-tipo-oper = 9. 
    /*********************************************************************/
    /**** Verifica se o cliente esta com credito aprovado. Caso nao, *****
     ***** nenhuma atualizacao sera feita em cotas                   *****
     *********************************************************************/
    else do:
       if ped-venda.cod-sit-aval <> 2 and   /*avaliado - tem credito, mas vai testar 
                                              novamente no faturamento */ 
          ped-venda.cod-sit-aval <> 3 then  /*aprovado*/
          return.
    end.
&endif

find natur-oper no-lock 
     where natur-oper.nat-operacao = ped-venda.nat-operacao no-error.

find first para-ped no-lock no-error.
if substring(para-ped.char-2,1,3)  = "yes" then
   find par-cota no-lock
        where par-cota.cod-estabel = para-ped.estab-padrao no-error.
else    
   find par-cota no-lock
        where par-cota.cod-estabel = ped-venda.cod-estabel no-error.  

/* Caso controle cotas somente faturamento e n∆o tenha item/produto cadastrado */
if p-log-docto = yes and /*pedido*/
   par-cota.gera-faturam then do:
   find current ped-venda exclusive-lock no-error.
   for each ped-item of ped-venda exclusive-lock :
       assign ped-item.cod-sit-com = 2.
   end. 
   assign ped-venda.cod-sit-com = 2.

   run pi-envia-email-comercial (input ped-venda.nr-pedcli,
                                 input ped-venda.nome-abrev).
   
   find current ped-venda no-lock no-error.
end.

/*********************************************************************/

/* Quando o Codigo da situacao da avaliacao comercial do pedido
   for avalia, entao Cotas sera atualizado no programa ac1002.w 
   Atualizacao Bath de Cotas,  retornando mensagem Processo con-
   cluido sem atualizacao on-line.     */

if (i-tipo-oper = 11 or /*reprov forcada*/
    i-tipo-oper = 10 or /*aprova forcada*/
    i-tipo-oper = 8  or /*aprov ou reprov manual de pedidos (ac1004)*/ 
    i-tipo-oper = 5  or /* diminui (ac1004) */
    i-tipo-oper = 4  or /*cancela*/
    i-tipo-oper = 3  or
    i-tipo-oper = 1  or /* avaliaá∆o de credito do pedido */
    ped-venda.cod-sit-com = 2 ) and /* APROVADO PARA FATURAR */ 

    &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
    natur-oper.log-atual-cotas = yes then do: /* CONTROLA COTAS */
    &else
    substr(natur-oper.char-2,31,1) = "1"  then do: /* CONTROLA COTAS */
    &endif        

   if not avail par-cota then do:
      {utp/ut-table.i mgdis par-cota 1}
      run utp/ut-msgs.p (input "msg",
                         input 2,
                         input return-value).
      return.
   end.

   /* se for atualizacao batch e for reativacao, suspensao ou cancelamento, 
      nao considera batch e atualiza as informacoes. o AC1002 e apenas para
      implantacao de pedidos batch*/

   if  not entry(1,program-name(2),' ') begins "pi-reativar"   
   and not entry(1,program-name(2),' ') begins "pi-suspender"  
   and not entry(1,program-name(2),' ') begins "pi-cancelar"   
   and par-cota.tipo-atu = 1 then do:      /* batch */

       for each ped-item fields(cod-sit-com) exclusive-lock where
                ped-item.nome-abrev    = ped-venda.nome-abrev and
                ped-item.nr-pedcli     = ped-venda.nr-pedcli  and
                ped-item.cod-sit-item <> 6 :
           assign ped-item.cod-sit-com  = 1.

       end.

       return.
   end.
   else do: /*on-line*/ 

        find emitente no-lock where
             emitente.cod-emitente = ped-venda.cod-emitente no-error.
        if  not avail emitente then next.

        find repres no-lock where
             repres.nome-abrev = ped-venda.no-ab-reppri no-error.
        if not avail repres then next. 

        /**** Release do dicionario  - 2.03 ****/
        &if defined (bf_dis_adm_cotas) &then          

          /* Verifica Dt inicio controle cotas no canal de venda . Caso data seja maior ,
             aprova normalmente os pedidos . Isso significa que aquele canal n∆o consi-
             ra cotas ainda, naquela data */
          if par-cota.Cont-canal-venda                                                    and
             can-find (first canal-venda where 
                       canal-venda.cod-canal-venda     = ped-venda.cod-canal-venda  and
                       canal-venda.dat-inic-ctrl-cotas >  if par-cota.tipo-data = 1 then
                                                          ped-venda.dt-emissao      else
                                                          ped-venda.dt-entrega)     then do:

             for each ped-item fields(cod-sit-com) exclusive-lock where
                      ped-item.nome-abrev    = ped-venda.nome-abrev and
                      ped-item.nr-pedcli     = ped-venda.nr-pedcli  :
                      assign ped-item.cod-sit-com = 2.    
             end.
             for first b-ped-venda fields(cod-sit-com) exclusive-lock where
                       rowid(b-ped-venda) = rw-ped-venda :
                 assign b-ped-venda.cod-sit-com = 2.
             end.

             run pi-envia-email-comercial (input b-ped-venda.nr-pedcli,      
                                           input b-ped-venda.nome-abrev).    
             
             return "OK" . /* le proximo pedido */
          end.                                   
          /**** Release do dicionario  - 2.03 ****/

        &endif


        for each ped-item 
            where ped-item.nome-abrev    = ped-venda.nome-abrev
            and   ped-item.nr-pedcli     = ped-venda.nr-pedcli EXCLUSIVE-LOCK:

            /* nao vai atualizar em cotas todos os itens do pedido, 
               mas somente aqueles que estiverem na nota fiscal (faturamento) ou 
               no documento fiscal (recebimento) */
            if p-log-docto = no then /*nota-fiscal*/
               if ped-item.it-codigo <> c-item then next.

            /* Caso nao tenha atualizado cotas e tente cancelar, interrompe */
            if ped-item.cod-sit-com  = 1 /*nao avaliado*/ and
               ped-venda.cod-sit-ped = 6 /*cancelado*/ then  
               next.

            /* No CD1004 os itens podem ser aprovados ou reprovados. Esse teste
               ˝ para que os itens reprovados nao sejam tratados em Cotas.     */
            if i-tipo-oper = 8 then
               if ped-item.cod-sit-com = 3 /* reprovado */ then next. 


            /* verifica se natureza de operacao do item controla cotas */
            if ped-venda.nat-operacao <> ped-item.nat-operacao then
               find natur-oper no-lock
                    where natur-oper.nat-operacao = ped-item.nat-operacao no-error.

            &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
              if natur-oper.log-atual-cotas = no then do: /* NAO CONTROLA COTAS */
                 assign ped-item.cod-sit-com = 2.
                 next.
              end.
            &else
              if substr(natur-oper.char-2,31,1) <> "1"  then do: /* NAO CONTROLA COTAS */
                 assign ped-item.cod-sit-com = 2.
                 next.
              end.
            &endif                   

            /* PIÔs para tratar releases do dicionario */
            &if defined (bf_dis_adm_cotas) &then           
                run pi-trata-release-203.
            &else
                run pi-trata-release-202.
            &endif


        end.  /*for each ped-item*/

        /* 
           Na release 2.02 eh chamada a api acapi002.
           Na release 2.03 eh chamada a api acapi007.
         */   

        &if defined (bf_dis_adm_cotas) &then        

            /* RELEASE 2.03 */
            create tt-configuracao.
            assign tt-configuracao.cod-versao-integracao = 1
                   tt-configuracao.tipo-atu              = par-cota.tipo-atu.

            /* Chamada da Api que atualiza Cotas */
            run acp/acapi007.p (input         table tt-configuracao,
                                input-output  table tt-dados,
                                output        table tt-erros).

        &else            

            /* RELEASE 2.02 */
            create tt-configuracao.
            assign tt-configuracao.cod-versao-integracao = 1
                   tt-configuracao.tipo-atu              = par-cota.tipo-atu.

            /* Chamada da Api que atualiza Cotas */
            run acp/acapi002.p (input         table tt-configuracao,
                                input-output  table tt-dados,
                                output        table tt-erros).
        &endif

        assign l-achou-reprov = no
               l-achou-susp   = no. 


        for each tt-dados :

            for first b-ped-venda fields(cod-sit-com) exclusive-lock   where
                rowid(b-ped-venda) = rw-ped-venda :

                 find first ped-item exclusive-lock where
                            ped-item.nome-abrev   = tt-dados.nome-abrev   and
                            ped-item.nr-pedcli    = tt-dados.nr-docto     and
                            ped-item.it-codigo    = tt-dados.it-original  and
                            ped-item.nr-sequencia = tt-dados.nr-sequencia no-error.
                 if  avail ped-item  then do:
                     assign ped-item.cod-sit-com  = tt-dados.cod-sit-com.
                     if  ped-item.cod-sit-com = 3 then
                         assign l-achou-reprov = yes.
                     if  ped-item.cod-sit-com = 4 then
                         assign l-achou-susp = yes.                 
                 end. 
                 if l-achou-reprov = yes then do:
                    assign b-ped-venda.cod-sit-com = 3.

                    run pi-envia-email-comercial (input b-ped-venda.nr-pedcli,
                                                  input b-ped-venda.nome-abrev).

                 end.
                 else
                    if l-achou-susp = yes then do:    
                       assign b-ped-venda.cod-sit-com = 4.
                        
                       run pi-envia-email-comercial (input b-ped-venda.nr-pedcli,
                                                     input b-ped-venda.nome-abrev).
                       
                    end.
                    else do:
                       assign b-ped-venda.cod-sit-com = 2.

                       run pi-envia-email-comercial (input b-ped-venda.nr-pedcli,
                                                     input b-ped-venda.nome-abrev).

                       /* foi chamado pelo ac1014 */
                       if program-name(2) matches "*b20di159*" and
                          tt-dados.nivel = "Representante" then
                          run pi-chama-upc-quando-pedido-aprovado.
                    end.
            end. /*for first ped-venda*/       

        end. /* for each tt-dados */ 

        find first tt-erros no-lock no-error.
        if avail tt-erros then 
           for each tt-erros:
               run utp/ut-msgs.p (input "msg",
                                  input tt-erros.codigo-erro,  
                                  input tt-erros.parametros).
           end.          

   end. /*on-line*/


end. /*ped-venda.cod-sit-com = 2*/
else do:

        /* Quando o pedido de venda nao atualizar Cotas, o mesmo ira ficar com o cod-sit-com = 2 para
           ficar disponivel para o faturamento */ 
        for first ped-venda fields(nome-abrev nr-pedcli cod-sit-com)  where
            rowid(ped-venda) = rw-ped-venda                           exclusive-lock :
            assign ped-venda.cod-sit-com = 2. 

            run pi-envia-email-comercial (input ped-venda.nr-pedcli,
                                          input ped-venda.nome-abrev).

            for each ped-item fields(cod-sit-com)                  where
                     ped-item.nome-abrev    = ped-venda.nome-abrev and
                     ped-item.nr-pedcli     = ped-venda.nr-pedcli  and
                     ped-item.cod-sit-item  <> 6                   exclusive-lock :
                assign ped-item.cod-sit-com = 2.
            end.
        end. /* for each ped-venda */   
end. 

&if defined (bf_dis_adm_cotas) &then
/* Caso n∆o encontre base-cota , reprova pedido */
if l-nao-achou-base-cota = yes then do:

   for first ped-venda fields(nome-abrev nr-pedcli cod-sit-com)  where
       rowid(ped-venda) = rw-ped-venda                           exclusive-lock:

       assign ped-venda.cod-sit-com = 3. /*reprov*/ 

       run pi-envia-email-comercial (input ped-venda.nr-pedcli,
                                     input ped-venda.nome-abrev).
       
       for each ped-item fields(cod-sit-com)                  where
                ped-item.nome-abrev    = ped-venda.nome-abrev and
                ped-item.nr-pedcli     = ped-venda.nr-pedcli  and
                ped-item.cod-sit-item  <> 6                   exclusive-lock:

           assign ped-item.cod-sit-com = 3. /*reprov*/

       end.

       if i-tipo-oper = 10 or 
          i-tipo-oper = 11 then do:
          /* N∆o foi encontrado base cota para pedido venda */ 
          {utp/ut-liter.i Base_Cota MAC c} c-texto[1] = trim(return-value). 
          {utp/ut-liter.i Pedido_Venda MAC c} c-texto[2] =
           trim(return-value) + " " + ped-venda.nr-pedcli. 
          run utp/ut-msgs.p (input "msg",
                             input 16381,
                             input c-texto[1] + "~~" + c-texto[2]).
       end.   
   end.   
end.
&endif



/****************************** ++++ PROCEDURES INTERNAS ++++ ******************************/

&if defined (bf_dis_adm_cotas) &then

    procedure pi-trata-release-203.

            /************************************************************************/
            /*** Se nao controla produto atribui o item padrao do estabelecimento ***/
            /************************************************************************/
            assign l-log-produto = no.
            if not par-cota.cont-produto then do:
                assign c-it-codigo  = par-cota.it-codigo-padrao.
                find item-cota no-lock
                     where item-cota.it-codigo = ped-item.it-codigo no-error.
            end.
            /*verifica se item ˝ controlado por produto*/
            else do:
                find item-cota no-lock
                     where item-cota.it-codigo = ped-item.it-codigo no-error.
                if avail item-cota then do:
                   if item-cota.log-produto and
                      par-cota.cont-produto then do : /*controla por produto*/

                      find est-prod-coml where est-prod-coml.it-codigo = item-cota.it-codigo no-lock no-error.
                      assign c-it-codigo   = est-prod-coml.cod-produto-coml
                             l-log-produto = yes.

                      if par-cota.tipo-controle = 2 then /*valor*/
                         assign de-quantidade = est-prod-coml.qt-aplicada.
                      else /*qtde e pontos*/
                         assign de-quantidade = (ped-item.qt-pedida * est-prod-coml.qt-aplicada).
                   end.
                   else    
                      assign c-it-codigo   = item-cota.it-codigo.  
                end.
            end.

            if not avail item-cota then do:
                 if (par-cota.cota-impl-canal-venda = 3   and
                     par-cota.cont-canal-venda ) or
                    (par-cota.cota-impl-gr-cli = 3  and
                     par-cota.cont-gr-cli ) or
                    (par-cota.cota-impl-cliente = 3  and
                     par-cota.cont-cliente ) or
                    (par-cota.cota-impl-ab-reg = 3 and
                     par-cota.cont-ab-reg ) or
                    (par-cota.cota-impl-mic-reg = 3  and
                     par-cota.cont-mic-reg ) or
                     par-cota.cota-impl-repres = 3  then 

                     assign ped-item.cod-sit-com = 2.
                 next.
            end. 

            /********** definicao do nr de pontos ************/
            find last  base-cota no-lock where
                       base-cota.cod-estabel = par-cota.cod-estabel and
                       base-cota.cd-produto  = c-it-codigo          and
                       base-cota.dt-inicial <= (if par-cota.tipo-data = 1 then
                                                   ped-venda.dt-emissao   else
                                                   ped-item.dt-entrega) no-error.

            if not avail base-cota then do:
               assign l-nao-achou-base-cota = yes.
               next.
            end.

            if par-cota.cont-produto = yes then
               assign de-pontos = base-cota.nr-pontos.
            else do:
               find item-cota no-lock
                    where item-cota.it-codigo = ped-item.it-codigo no-error.
               assign de-pontos = if avail item-cota then item-cota.nr-pontos else 1. 
            end.
            if l-log-produto = yes then do: /*item controlado por produto*/
               find item-cota no-lock
                    where item-cota.it-codigo = ped-item.it-codigo no-error.
               assign de-pontos = if avail item-cota then item-cota.nr-pontos else 1. 
            end.   
            if par-cota.tipo-controle <> 3 then de-pontos = 1.


            /* trata data de bloqueio na base de cotas . caso esteja bloqueado, usa a mesma rotina 
               do pedido reprovado por crÇdito */
            if i-tipo-oper = 1 and   /*implantacao pedido*/
               base-cota.dt-bloqueio <= (if par-cota.tipo-data = 1 then
                                            ped-venda.dt-emissao   else
                                            ped-item.dt-entrega) then 
               assign i-tipo-oper = 9. 

            /* PI para criar temp table */
            run pi-cria-temp-table-release-203.


    end procedure.


    procedure pi-cria-temp-table-release-203.

          /* trata item/produto destino */
          find last  base-cota no-lock where
                     base-cota.cod-estabel = par-cota.cod-estabel and
                     base-cota.cd-produto  = c-it-codigo and
                     base-cota.dt-inicial <= (if par-cota.tipo-data = 1 then ped-venda.dt-emissao  else ped-item.dt-entrega)  and
                     base-cota.dt-final   >= (if par-cota.tipo-data = 1 then ped-venda.dt-emissao  else ped-item.dt-entrega)  no-error.
          if avail base-cota and
             base-cota.cd-produto <> base-cota.cd-produto-dest then do:
             assign c-produto-aux = base-cota.cd-produto-dest.
             find last  base-cota no-lock where
                        base-cota.cod-estabel = par-cota.cod-estabel and
                        base-cota.cd-produto  = c-produto-aux and
                        base-cota.dt-inicial <= (if par-cota.tipo-data = 1 then ped-venda.dt-emissao  else ped-item.dt-entrega) and
                        base-cota.dt-final   >= (if par-cota.tipo-data = 1 then ped-venda.dt-emissao  else ped-item.dt-entrega) no-error.
          end.                
          if avail base-cota then
             assign c-it-codigo = base-cota.cd-produto-dest.  


          /********************** Nivel Canal Venda ****************************/
          if par-cota.cont-canal-venda and
             par-cota.log-impl-niveis  then do:
             find first tt-dados exclusive-lock use-index pedido where
                        tt-dados.nr-docto = ped-item.nr-pedcli and
                        tt-dados.nome-abrev = ped-venda.nome-abrev and
                        tt-dados.it-original = ped-item.it-codigo and
                        tt-dados.nr-sequencia = ped-item.nr-sequencia and
                        tt-dados.cod-canal-venda = ped-venda.cod-canal-venda and
                        tt-dados.cod-gr-cli = ( if par-cota.cont-gr-cli then ? else 0 ) and
                        tt-dados.nome-abrev-cotas = ( if par-cota.cont-cliente then ? else "" ) and
                        tt-dados.nome-ab-reg = ( if par-cota.cont-ab-reg then ? else "" ) and
                        tt-dados.nome-mic-reg = ( if par-cota.cont-mic-reg then ? else "" ) and
                        tt-dados.cod-rep = ? no-error.  

             if not avail tt-dados then do:
             /************* caso nao exista tt-dados *************************/

                create tt-dados.
                assign tt-dados.nome-abrev-cotas     = ( if par-cota.cont-cliente then ? else "" )
                       tt-dados.nome-abrev           = ped-venda.nome-abrev /*cliente original, usado na atu-cota*/
                       tt-dados.nr-docto             = ped-item.nr-pedcli
                       tt-dados.nr-sequencia         = ped-item.nr-sequencia
                       tt-dados.cod-estabel          = par-cota.cod-estabel
                       tt-dados.cod-canal-venda      = ped-venda.cod-canal-venda 
                       tt-dados.cod-gr-cli           = ( if par-cota.cont-gr-cli then ? else 0 )
                       tt-dados.nome-ab-reg          = ( if par-cota.cont-ab-reg then ? else "" )
                       tt-dados.nome-mic-reg         = ( if par-cota.cont-mic-reg then ? else "" )
                       tt-dados.cod-rep              = ?
                       tt-dados.nivel                = "Canal"                      
                       tt-dados.it-codigo            = c-it-codigo
                       tt-dados.it-original          = ped-item.it-codigo /*item original, sem considerar se item controlado por produto*/
                       tt-dados.dt-emissao           = ped-venda.dt-emissao
                       tt-dados.dt-entrega           = ped-item.dt-entrega
                       tt-dados.log-tipo-oper        = if ped-item.cod-sit-item = 6 then 4
                                                                                    else i-tipo-oper 
                       tt-dados.log-docto            = p-log-docto /*YES = pedido , NO = nota*/
                       tt-dados.tipo-pedido          = ped-venda.esp-ped
                       tt-dados.cod-sit-com          = ped-item.cod-sit-com
                       tt-dados.cod-sit-ped          = ped-venda.cod-sit-ped
   
                       /*valor liq para item controlado por produto e n o controlado*/
                       tt-dados.valor-unit-liq       = if l-log-produto then (ped-item.vl-liq-it * de-quantidade)
                                                                        else  ped-item.vl-liq-it 
   
                       /*valor bruto para item controlado por produto e n o controlado*/
                       tt-dados.valor-unit-bru       = if l-log-produto then ((ped-item.qt-pedida * ped-item.vl-preori) * de-quantidade)
                                                                        else (ped-item.qt-pedida * ped-item.vl-preori) 
                       tt-dados.quantidade           = if l-log-produto then de-quantidade else ped-item.qt-pedida.

                /*quanto controlado por pontos, multiplica pelo nr de pontos*/
                if par-cota.tipo-controle = 3 then
                    assign tt-dados.quantidade = tt-dados.quantidade * de-pontos.           

             end.
             /****************************** caso ja exista tt-dados **************************/
             else do:

                /*acumula valor liq para item controlado por produto e n o controlado*/
                assign tt-dados.valor-unit-liq     = if l-log-produto then (tt-dados.valor-unit-liq + (ped-item.vl-liq-it * de-quantidade)) 
                                                                      else (tt-dados.valor-unit-liq + ped-item.vl-liq-it )
                       /*acumula valor bruto para item controlado por produto e n o controlado*/
                       tt-dados.valor-unit-bru    = if l-log-produto then (tt-dados.valor-unit-bru + ((ped-item.qt-pedida * ped-item.vl-preori) * de-quantidade )) 
                                                                     else (tt-dados.valor-unit-bru + (ped-item.qt-pedida * ped-item.vl-preori)) .
                /*quanto controlado por pontos, multiplica pelo nr de pontos*/
                /* se tipo controle = 3 entao atualiza nr-pontos senao nr pontos e 1.*/
                assign de-quantidade           = de-quantidade * de-pontos           
                       de-quant-temp           = ped-item.qt-pedida
                       de-quant-temp           = de-quant-temp * de-pontos.           
                assign tt-dados.quantidade     = if l-log-produto then (tt-dados.quantidade + de-quantidade)  else (tt-dados.quantidade + de-quant-temp).
             end.            
          end. /*par-cota*/   

          /********************** Nivel Grupo Cliente ****************************/


          if par-cota.cont-gr-cli and
             par-cota.log-impl-niveis then do:

             find first tt-dados exclusive-lock use-index pedido where
                        tt-dados.nr-docto = ped-item.nr-pedcli and
                        tt-dados.nome-abrev = ped-venda.nome-abrev and
                        tt-dados.it-original = ped-item.it-codigo and
                        tt-dados.nr-sequencia = ped-item.nr-sequencia and
                        tt-dados.cod-canal-venda = ( if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0 ) and
                        tt-dados.cod-gr-cli = ped-venda.cod-gr-cli and
                        tt-dados.nome-abrev-cotas = ( if par-cota.cont-cliente then ? else "" ) and
                        tt-dados.nome-ab-reg = ( if par-cota.cont-ab-reg then ? else "" ) and
                        tt-dados.nome-mic-reg = ( if par-cota.cont-mic-reg then ? else "" ) and
                        tt-dados.cod-rep = ? no-error.  

             if not avail tt-dados then do:
             /************* caso nao exista tt-dados *************************/


                create tt-dados.
                assign tt-dados.nome-abrev-cotas     = ( if par-cota.cont-cliente then ? else "" ) 
                       tt-dados.nome-abrev           = ped-venda.nome-abrev /*cliente original, usado na atu-cota*/
                       tt-dados.nr-docto             = ped-item.nr-pedcli
                       tt-dados.nr-sequencia         = ped-item.nr-sequencia
                       tt-dados.cod-estabel          = par-cota.cod-estabel
                       tt-dados.cod-canal-venda      = ( if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0 ) 
                       tt-dados.cod-gr-cli           = ped-venda.cod-gr-cli 
                       tt-dados.nome-ab-reg          = ( if par-cota.cont-ab-reg then ? else "" ) 
                       tt-dados.nome-mic-reg         = ( if par-cota.cont-mic-reg then ? else "" )
                       tt-dados.cod-rep              = ? 
                       tt-dados.nivel                = "Grupo"                      
                       tt-dados.it-codigo            = c-it-codigo
                       tt-dados.it-original          = ped-item.it-codigo /*item original, sem considerar se item controlado por produto*/
                       tt-dados.dt-emissao           = ped-venda.dt-emissao
                       tt-dados.dt-entrega           = ped-item.dt-entrega
                       tt-dados.log-tipo-oper        = if ped-item.cod-sit-item = 6 then 4
                                                                                    else i-tipo-oper 
                       tt-dados.log-docto            = p-log-docto /*YES = pedido , NO = nota*/
                       tt-dados.tipo-pedido          = ped-venda.esp-ped
                       tt-dados.cod-sit-com          = ped-item.cod-sit-com
                       tt-dados.cod-sit-ped          = ped-venda.cod-sit-ped 
   
                       /*valor liq para item controlado por produto e n o controlado*/
                       tt-dados.valor-unit-liq       = if l-log-produto then (ped-item.vl-liq-it * de-quantidade)
                                                                        else  ped-item.vl-liq-it 
   
                       /*valor bruto para item controlado por produto e n o controlado*/
                       tt-dados.valor-unit-bru       = if l-log-produto then ((ped-item.qt-pedida * ped-item.vl-preori) * de-quantidade)
                                                                        else (ped-item.qt-pedida * ped-item.vl-preori) 
                       tt-dados.quantidade           = if l-log-produto then de-quantidade else ped-item.qt-pedida.

                /*quanto controlado por pontos, multiplica pelo nr de pontos*/
                if par-cota.tipo-controle = 3 then
                    assign tt-dados.quantidade = tt-dados.quantidade * de-pontos.           

             end.
             /****************************** caso ja exista tt-dados **************************/
             else do:

                /*acumula valor liq para item controlado por produto e n o controlado*/
                assign tt-dados.valor-unit-liq     = if l-log-produto then (tt-dados.valor-unit-liq + (ped-item.vl-liq-it * de-quantidade)) 
                                                                      else (tt-dados.valor-unit-liq + ped-item.vl-liq-it )
                       /*acumula valor bruto para item controlado por produto e n o controlado*/
                       tt-dados.valor-unit-bru    = if l-log-produto then (tt-dados.valor-unit-bru + ((ped-item.qt-pedida * ped-item.vl-preori) * de-quantidade )) 
                                                                     else (tt-dados.valor-unit-bru + (ped-item.qt-pedida * ped-item.vl-preori)) .
                /*quanto controlado por pontos, multiplica pelo nr de pontos*/
                /* se tipo controle = 3 entao atualiza nr-pontos senao nr pontos e 1.*/
                assign de-quantidade           = de-quantidade * de-pontos           
                       de-quant-temp           = ped-item.qt-pedida
                       de-quant-temp           = de-quant-temp * de-pontos.           
                assign tt-dados.quantidade     = if l-log-produto then (tt-dados.quantidade + de-quantidade)  else (tt-dados.quantidade + de-quant-temp).
             end.            
          end. /*par-cota*/


          /********************** Nivel Cliente ****************************/

          if par-cota.cont-cliente and
             par-cota.log-impl-niveis  then do:
             find first tt-dados exclusive-lock use-index pedido where
                        tt-dados.nr-docto = ped-item.nr-pedcli and
                        tt-dados.nome-abrev = ped-venda.nome-abrev and
                        tt-dados.it-original = ped-item.it-codigo and
                        tt-dados.nr-sequencia = ped-item.nr-sequencia and
                        tt-dados.cod-canal-venda = ( if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0 ) and
                        tt-dados.cod-gr-cli = ( if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0 ) and
                        tt-dados.nome-abrev-cotas = ped-venda.nome-abrev and
                        tt-dados.nome-ab-reg = ( if par-cota.cont-ab-reg then ? else "" ) and
                        tt-dados.nome-mic-reg = ( if par-cota.cont-mic-reg then ? else "" ) and
                        tt-dados.cod-rep = ? no-error.  

             if not avail tt-dados then do:
             /************* caso nao exista tt-dados *************************/

                create tt-dados.
                assign tt-dados.nome-abrev-cotas     = ped-venda.nome-abrev
                       tt-dados.nome-abrev           = ped-venda.nome-abrev /*cliente original, usado na atu-cota*/
                       tt-dados.nr-docto             = ped-item.nr-pedcli
                       tt-dados.nr-sequencia         = ped-item.nr-sequencia
                       tt-dados.cod-estabel          = par-cota.cod-estabel
                       tt-dados.cod-canal-venda      = ( if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0 )
                       tt-dados.cod-gr-cli           = ( if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0 )
                       tt-dados.nome-ab-reg          = ( if par-cota.cont-ab-reg then ? else "" )
                       tt-dados.nome-mic-reg         = ( if par-cota.cont-mic-reg then ? else "" )
                       tt-dados.cod-rep              = ?
                       tt-dados.nivel                = "Cliente"                      
                       tt-dados.it-codigo            = c-it-codigo
                       tt-dados.it-original          = ped-item.it-codigo /*item original, sem considerar se item controlado por produto*/
                       tt-dados.dt-emissao           = ped-venda.dt-emissao
                       tt-dados.dt-entrega           = ped-item.dt-entrega
                       tt-dados.log-tipo-oper        = if ped-item.cod-sit-item = 6 then 4
                                                                                    else i-tipo-oper 
                       tt-dados.log-docto            = p-log-docto /*YES = pedido , NO = nota*/
                       tt-dados.tipo-pedido          = ped-venda.esp-ped
                       tt-dados.cod-sit-com          = ped-item.cod-sit-com
                       tt-dados.cod-sit-ped          = ped-venda.cod-sit-ped
   
                       /*valor liq para item controlado por produto e n o controlado*/
                       tt-dados.valor-unit-liq       = if l-log-produto then (ped-item.vl-liq-it * de-quantidade)
                                                                        else  ped-item.vl-liq-it 
   
                       /*valor bruto para item controlado por produto e n o controlado*/
                       tt-dados.valor-unit-bru       = if l-log-produto then ((ped-item.qt-pedida * ped-item.vl-preori) * de-quantidade)
                                                                        else (ped-item.qt-pedida * ped-item.vl-preori) 
                       tt-dados.quantidade           = if l-log-produto then de-quantidade else ped-item.qt-pedida.

                /*quanto controlado por pontos, multiplica pelo nr de pontos*/
                if par-cota.tipo-controle = 3 then
                    assign tt-dados.quantidade = tt-dados.quantidade * de-pontos.           

             end.
             /****************************** caso ja exista tt-dados **************************/
             else do:

                /*acumula valor liq para item controlado por produto e n o controlado*/
                assign tt-dados.valor-unit-liq     = if l-log-produto then (tt-dados.valor-unit-liq + (ped-item.vl-liq-it * de-quantidade)) 
                                                                      else (tt-dados.valor-unit-liq + ped-item.vl-liq-it )
                       /*acumula valor bruto para item controlado por produto e n o controlado*/
                       tt-dados.valor-unit-bru    = if l-log-produto then (tt-dados.valor-unit-bru + ((ped-item.qt-pedida * ped-item.vl-preori) * de-quantidade )) 
                                                                     else (tt-dados.valor-unit-bru + (ped-item.qt-pedida * ped-item.vl-preori)) .
                /*quanto controlado por pontos, multiplica pelo nr de pontos*/
                /* se tipo controle = 3 entao atualiza nr-pontos senao nr pontos e 1.*/
                assign de-quantidade           = de-quantidade * de-pontos           
                       de-quant-temp           = ped-item.qt-pedida
                       de-quant-temp           = de-quant-temp * de-pontos.           
                assign tt-dados.quantidade     = if l-log-produto then (tt-dados.quantidade + de-quantidade)  else (tt-dados.quantidade + de-quant-temp).
             end.            
          end. /*par-cota*/               

          /********************** Nivel Regiao ****************************/


          if par-cota.cont-ab-reg and
             par-cota.log-impl-niveis  then do:
             find first tt-dados exclusive-lock use-index pedido where
                        tt-dados.nr-docto = ped-item.nr-pedcli and
                        tt-dados.nome-abrev = ped-venda.nome-abrev and
                        tt-dados.it-original = ped-item.it-codigo and
                        tt-dados.nr-sequencia = ped-item.nr-sequencia and
                        tt-dados.cod-canal-venda = ( if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0 ) and
                        tt-dados.cod-gr-cli = ( if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0 ) and
                        tt-dados.nome-abrev-cotas = ( if par-cota.cont-cliente then ped-venda.nome-abrev else "" ) and
                        tt-dados.nome-ab-reg = repres.nome-ab-reg and
                        tt-dados.nome-mic-reg = ( if par-cota.cont-mic-reg then ? else "" ) and
                        tt-dados.cod-rep = ? no-error.  


             if not avail tt-dados then do:
             /************* caso nao exista tt-dados *************************/

                create tt-dados.
                assign tt-dados.nome-abrev-cotas     = ( if par-cota.cont-cliente then ped-venda.nome-abrev else "" )
                       tt-dados.nome-abrev           = ped-venda.nome-abrev /*cliente original, usado na atu-cota*/
                       tt-dados.nr-docto             = ped-item.nr-pedcli
                       tt-dados.nr-sequencia         = ped-item.nr-sequencia
                       tt-dados.cod-estabel          = par-cota.cod-estabel
                       tt-dados.cod-canal-venda      = ( if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0 ) 
                       tt-dados.cod-gr-cli           = ( if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0 )
                       tt-dados.nome-ab-reg          = repres.nome-ab-reg
                       tt-dados.nome-mic-reg         = ( if par-cota.cont-mic-reg then ? else "" )
                       tt-dados.cod-rep              = ?
                       tt-dados.nivel                = "Regiao"                      
                       tt-dados.it-codigo            = c-it-codigo
                       tt-dados.it-original          = ped-item.it-codigo /*item original, sem considerar se item controlado por produto*/
                       tt-dados.dt-emissao           = ped-venda.dt-emissao
                       tt-dados.dt-entrega           = ped-item.dt-entrega
                       tt-dados.log-tipo-oper        = if ped-item.cod-sit-item = 6 then 4
                                                                                    else i-tipo-oper 
                       tt-dados.log-docto            = p-log-docto /*YES = pedido , NO = nota*/
                       tt-dados.tipo-pedido          = ped-venda.esp-ped
                       tt-dados.cod-sit-com          = ped-item.cod-sit-com
                       tt-dados.cod-sit-ped          = ped-venda.cod-sit-ped
   
                       /*valor liq para item controlado por produto e n o controlado*/
                       tt-dados.valor-unit-liq       = if l-log-produto then (ped-item.vl-liq-it * de-quantidade)
                                                                        else  ped-item.vl-liq-it 
   
                       /*valor bruto para item controlado por produto e n o controlado*/
                       tt-dados.valor-unit-bru       = if l-log-produto then ((ped-item.qt-pedida * ped-item.vl-preori) * de-quantidade)
                                                                        else (ped-item.qt-pedida * ped-item.vl-preori) 
                       tt-dados.quantidade           = if l-log-produto then de-quantidade else ped-item.qt-pedida.

                /*quanto controlado por pontos, multiplica pelo nr de pontos*/
                if par-cota.tipo-controle = 3 then
                    assign tt-dados.quantidade = tt-dados.quantidade * de-pontos.           

             end.
             /****************************** caso ja exista tt-dados **************************/
             else do:

                /*acumula valor liq para item controlado por produto e n o controlado*/
                assign tt-dados.valor-unit-liq     = if l-log-produto then (tt-dados.valor-unit-liq + (ped-item.vl-liq-it * de-quantidade)) 
                                                                      else (tt-dados.valor-unit-liq + ped-item.vl-liq-it )
                       /*acumula valor bruto para item controlado por produto e n o controlado*/
                       tt-dados.valor-unit-bru    = if l-log-produto then (tt-dados.valor-unit-bru + ((ped-item.qt-pedida * ped-item.vl-preori) * de-quantidade )) 
                                                                     else (tt-dados.valor-unit-bru + (ped-item.qt-pedida * ped-item.vl-preori)) .
                /*quanto controlado por pontos, multiplica pelo nr de pontos*/
                /* se tipo controle = 3 entao atualiza nr-pontos senao nr pontos e 1.*/
                assign de-quantidade           = de-quantidade * de-pontos           
                       de-quant-temp           = ped-item.qt-pedida
                       de-quant-temp           = de-quant-temp * de-pontos.           
                assign tt-dados.quantidade     = if l-log-produto then (tt-dados.quantidade + de-quantidade)  else (tt-dados.quantidade + de-quant-temp).
             end.            
          end. /*par-cota*/               

          /********************** Nivel Microrregiao ****************************/

          if par-cota.cont-mic-reg and
             par-cota.log-impl-niveis then do:
             find first tt-dados exclusive-lock use-index pedido where
                        tt-dados.nr-docto = ped-item.nr-pedcli and
                        tt-dados.nome-abrev = ped-venda.nome-abrev and
                        tt-dados.it-original = ped-item.it-codigo and
                        tt-dados.nr-sequencia = ped-item.nr-sequencia and
                        tt-dados.cod-canal-venda = ( if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0 ) and
                        tt-dados.cod-gr-cli = ( if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0 ) and
                        tt-dados.nome-abrev-cotas = ( if par-cota.cont-cliente then ped-venda.nome-abrev else "" ) and
                        tt-dados.nome-ab-reg = ( if par-cota.cont-ab-reg then repres.nome-ab-reg else "" ) and
                        tt-dados.nome-mic-reg = emitente.nome-mic-reg and
                        tt-dados.cod-rep = ? no-error.  

             if not avail tt-dados then do:
             /************* caso nao exista tt-dados *************************/

                create tt-dados.
                assign tt-dados.nome-abrev-cotas     = ( if par-cota.cont-cliente then ped-venda.nome-abrev else "" )
                       tt-dados.nome-abrev           = ped-venda.nome-abrev /*cliente original, usado na atu-cota*/
                       tt-dados.nr-docto             = ped-item.nr-pedcli
                       tt-dados.nr-sequencia         = ped-item.nr-sequencia
                       tt-dados.cod-estabel          = par-cota.cod-estabel
                       tt-dados.cod-canal-venda      = ( if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0 )
                       tt-dados.cod-gr-cli           = ( if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0 )
                       tt-dados.nome-ab-reg          = ( if par-cota.cont-ab-reg then repres.nome-ab-reg else "" )
                       tt-dados.nome-mic-reg         = emitente.nome-mic-reg
                       tt-dados.cod-rep              = ?
                       tt-dados.nivel                = "Microrregiao"                      
                       tt-dados.it-codigo            = c-it-codigo
                       tt-dados.it-original          = ped-item.it-codigo /*item original, sem considerar se item controlado por produto*/
                       tt-dados.dt-emissao           = ped-venda.dt-emissao
                       tt-dados.dt-entrega           = ped-item.dt-entrega
                       tt-dados.log-tipo-oper        = if ped-item.cod-sit-item = 6 then 4
                                                                                    else i-tipo-oper 
                       tt-dados.log-docto            = p-log-docto /*YES = pedido , NO = nota*/
                       tt-dados.tipo-pedido          = ped-venda.esp-ped
                       tt-dados.cod-sit-com          = ped-item.cod-sit-com
                       tt-dados.cod-sit-ped          = ped-venda.cod-sit-ped
   
                       /*valor liq para item controlado por produto e n o controlado*/
                       tt-dados.valor-unit-liq       = if l-log-produto then (ped-item.vl-liq-it * de-quantidade)
                                                                        else  ped-item.vl-liq-it 
   
                       /*valor bruto para item controlado por produto e n o controlado*/
                       tt-dados.valor-unit-bru       = if l-log-produto then ((ped-item.qt-pedida * ped-item.vl-preori) * de-quantidade)
                                                                        else (ped-item.qt-pedida * ped-item.vl-preori) 
                       tt-dados.quantidade           = if l-log-produto then de-quantidade else ped-item.qt-pedida.

                /*quanto controlado por pontos, multiplica pelo nr de pontos*/
                if par-cota.tipo-controle = 3 then
                    assign tt-dados.quantidade = tt-dados.quantidade * de-pontos.           

             end.
             /****************************** caso ja exista tt-dados **************************/
             else do:

                /*acumula valor liq para item controlado por produto e n o controlado*/
                assign tt-dados.valor-unit-liq     = if l-log-produto then (tt-dados.valor-unit-liq + (ped-item.vl-liq-it * de-quantidade)) 
                                                                      else (tt-dados.valor-unit-liq + ped-item.vl-liq-it )
                       /*acumula valor bruto para item controlado por produto e n o controlado*/
                       tt-dados.valor-unit-bru    = if l-log-produto then (tt-dados.valor-unit-bru + ((ped-item.qt-pedida * ped-item.vl-preori) * de-quantidade )) 
                                                                     else (tt-dados.valor-unit-bru + (ped-item.qt-pedida * ped-item.vl-preori)) .
                /*quanto controlado por pontos, multiplica pelo nr de pontos*/
                /* se tipo controle = 3 entao atualiza nr-pontos senao nr pontos e 1.*/
                assign de-quantidade           = de-quantidade * de-pontos           
                       de-quant-temp           = ped-item.qt-pedida
                       de-quant-temp           = de-quant-temp * de-pontos.           
                assign tt-dados.quantidade     = if l-log-produto then (tt-dados.quantidade + de-quantidade)  else (tt-dados.quantidade + de-quant-temp).
             end.            
          end. /*par-cota*/ 


          /********************** Nivel Representante ****************************/

          find first tt-dados exclusive-lock use-index pedido where
                     tt-dados.nr-docto = ped-item.nr-pedcli and
                     tt-dados.nome-abrev = ped-venda.nome-abrev and
                     tt-dados.it-original = ped-item.it-codigo and
                     tt-dados.nr-sequencia = ped-item.nr-sequencia and
                     tt-dados.cod-canal-venda = ( if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0 ) and
                     tt-dados.cod-gr-cli = ( if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0 ) and
                     tt-dados.nome-abrev-cotas = ( if par-cota.cont-cliente then ped-venda.nome-abrev else "" ) and
                     tt-dados.nome-ab-reg = ( if par-cota.cont-ab-reg then repres.nome-ab-reg else "" ) and
                     tt-dados.nome-mic-reg = ( if par-cota.cont-mic-reg then emitente.nome-mic-reg else "" ) and
                     tt-dados.cod-rep = repres.cod-rep no-error.  

          if not avail tt-dados then do:
          /************* caso nao exista tt-dados *************************/

             create tt-dados.
             assign tt-dados.nome-abrev-cotas     = ( if par-cota.cont-cliente then ped-venda.nome-abrev else "" )
                    tt-dados.nome-abrev           = ped-venda.nome-abrev /*cliente original, usado na atu-cota*/
                    tt-dados.nr-docto             = ped-item.nr-pedcli
                    tt-dados.nr-sequencia         = ped-item.nr-sequencia
                    tt-dados.cod-estabel          = par-cota.cod-estabel
                    tt-dados.cod-canal-venda      = ( if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0 )
                    tt-dados.cod-gr-cli           = ( if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0 )
                    tt-dados.nome-ab-reg          = ( if par-cota.cont-ab-reg then repres.nome-ab-reg else "" )
                    tt-dados.nome-mic-reg         = ( if par-cota.cont-mic-reg then emitente.nome-mic-reg else "" )
                    tt-dados.cod-rep              = repres.cod-rep
                    tt-dados.nivel                = "Representante"                      
                    tt-dados.it-codigo            = c-it-codigo
                    tt-dados.it-original          = ped-item.it-codigo /*item original, sem considerar se item controlado por produto*/
                    tt-dados.dt-emissao           = ped-venda.dt-emissao
                    tt-dados.dt-entrega           = ped-item.dt-entrega
                    tt-dados.log-tipo-oper        = if ped-item.cod-sit-item = 6 then 4
                                                                                 else i-tipo-oper 
                    tt-dados.log-docto            = p-log-docto /*YES = pedido , NO = nota*/
                    tt-dados.tipo-pedido          = ped-venda.esp-ped
                    tt-dados.cod-sit-com          = ped-item.cod-sit-com
                    tt-dados.cod-sit-ped          = ped-venda.cod-sit-ped

                    /*valor liq para item controlado por produto e n o controlado*/
                    tt-dados.valor-unit-liq       = if l-log-produto then (ped-item.vl-liq-it * de-quantidade)
                                                                     else  ped-item.vl-liq-it 

                    /*valor bruto para item controlado por produto e n o controlado*/
                    tt-dados.valor-unit-bru       = if l-log-produto then ((ped-item.qt-pedida * ped-item.vl-preori) * de-quantidade)
                                                                     else (ped-item.qt-pedida * ped-item.vl-preori) 
                    tt-dados.quantidade           = if l-log-produto then de-quantidade else ped-item.qt-pedida.

             /*quanto controlado por pontos, multiplica pelo nr de pontos*/
             if par-cota.tipo-controle = 3 then
                 assign tt-dados.quantidade = tt-dados.quantidade * de-pontos.           

          end.
          /****************************** caso ja exista tt-dados **************************/
          else do:

             /*acumula valor liq para item controlado por produto e n o controlado*/
             assign tt-dados.valor-unit-liq     = if l-log-produto then (tt-dados.valor-unit-liq + (ped-item.vl-liq-it * de-quantidade)) 
                                                                   else (tt-dados.valor-unit-liq + ped-item.vl-liq-it )
                    /*acumula valor bruto para item controlado por produto e n o controlado*/
                    tt-dados.valor-unit-bru    = if l-log-produto then (tt-dados.valor-unit-bru + ((ped-item.qt-pedida * ped-item.vl-preori) * de-quantidade )) 
                                                                  else (tt-dados.valor-unit-bru + (ped-item.qt-pedida * ped-item.vl-preori)) .
             /*quanto controlado por pontos, multiplica pelo nr de pontos*/
             /* se tipo controle = 3 entao atualiza nr-pontos senao nr pontos e 1.*/
             assign de-quantidade           = de-quantidade * de-pontos           
                    de-quant-temp           = ped-item.qt-pedida
                    de-quant-temp           = de-quant-temp * de-pontos.           
             assign tt-dados.quantidade     = if l-log-produto then (tt-dados.quantidade + de-quantidade)  else (tt-dados.quantidade + de-quant-temp).
          end.            

    end procedure.

&else

    procedure pi-trata-release-202.

            if  par-cota.tipo-data = 1 then
                assign dt-ini = ped-venda.dt-emissao.
            else
                assign dt-ini = ped-item.dt-entrega.

            /* Chamada EPC para alterar data controle cotas */
            run pi-chama-upc-altera-data.


            /************************************************************************/
            /*** Se nao controla produto atribui o item padrao do estabelecimento ***/
            /************************************************************************/
            assign l-log-produto = no.

            if not par-cota.cont-produto then do:
                assign c-it-codigo  = par-cota.it-codigo-padrao.
                find item-cota no-lock
                     where item-cota.it-codigo = ped-item.it-codigo no-error.
            end.
            /*verifica se item e controlado por produto*/
            else do:
                find item-cota no-lock
                     where item-cota.it-codigo = ped-item.it-codigo no-error.
                if avail item-cota then do:
                   if item-cota.log-produto and
                      par-cota.cont-produto then do : /*controla por produto*/

                      find est-prod where est-prod.it-codigo = item-cota.it-codigo no-lock no-error.
                      assign c-it-codigo   = est-prod.cd-produto
                             l-log-produto = yes.

                      if par-cota.tipo-controle = 2 then /*valor*/
                         assign de-quantidade = est-prod.qt-aplicada.
                      else /*qtde e pontos*/
                         assign de-quantidade = (ped-item.qt-pedida / est-prod.qt-aplicada)
                                de-quantidade-aux = est-prod.qt-aplicada.
                   end.
                   else    
                      assign c-it-codigo   = item-cota.it-codigo.  
                end.
            end.

            if  not avail item-cota then do:
                if  par-cota.cota-implant = 3 then 
                    assign ped-item.cod-sit-com = 2.
                next.
            end.

            /********** definicao do nr de pontos ************/
            find last  base-cota no-lock where 
                       base-cota.cod-estabel = par-cota.cod-estabel and
                       base-cota.cd-produto  = c-it-codigo and
                       base-cota.dt-inicial <= dt-ini  no-error.

            if not avail base-cota then 
               next.

            if par-cota.cont-produto = yes then
               assign de-pontos = base-cota.nr-pontos.
            else do:
               find item-cota no-lock
                    where item-cota.it-codigo = ped-item.it-codigo no-error.
               assign de-pontos = if avail item-cota then item-cota.nr-pontos else 1. 
            end.
            if l-log-produto = yes then do: /*item controlado por produto*/
               find item-cota no-lock
                    where item-cota.it-codigo = ped-item.it-codigo no-error.
               assign de-pontos = if avail item-cota then item-cota.nr-pontos else 1. 
            end.   

            if par-cota.tipo-controle <> 3 then de-pontos = 1.

            /* Pi criacao temp table */
            run pi-cria-temp-table-release-202.

    end procedure.


    procedure pi-cria-temp-table-release-202.

          find first  tt-dados exclusive-lock use-index pedido  where
                      tt-dados.nome-abrev-cotas = (if par-cota.cont-cliente then ped-item.nome-abrev else "")
                and   tt-dados.nr-docto         = ped-item.nr-pedcli 
                and   tt-dados.it-original      = ped-item.it-codigo
                and   tt-dados.nr-sequencia     = ped-item.nr-sequencia no-error.

          if not avail tt-dados then do:
            /************* caso nao exista tt-dados *************************/

             create tt-dados.
             assign tt-dados.nome-abrev-cotas     = if par-cota.cont-cliente then ped-item.nome-abrev else ""
                    tt-dados.nome-abrev           = ped-venda.nome-abrev /*cliente original, usado na atu-cota*/
                    tt-dados.nr-docto             = ped-item.nr-pedcli
                    tt-dados.nr-sequencia         = ped-item.nr-sequencia
                    tt-dados.cod-estabel          = par-cota.cod-estabel
                    tt-dados.cod-canal-venda      = if par-cota.cont-canal-venda then ped-venda.cod-canal-venda else 0
                    tt-dados.cod-gr-cli           = if par-cota.cont-gr-cli then ped-venda.cod-gr-cli else 0
                    tt-dados.nome-ab-reg          = if par-cota.cont-ab-reg then repres.nome-ab-reg else ""
                    tt-dados.nome-mic-reg         = if par-cota.cont-mic-reg then emitente.nome-mic-reg else ""
                    tt-dados.cod-rep              = repres.cod-rep
                    tt-dados.it-codigo            = c-it-codigo
                    tt-dados.it-original          = ped-item.it-codigo /*item original, sem considerar se item controlado por produto*/
                    tt-dados.dt-emissao           = dt-ini
                    tt-dados.dt-entrega           = dt-ini
                    tt-dados.log-tipo-oper        = if ped-item.cod-sit-item = 6 then 4
                                                                                 else i-tipo-oper 
                    tt-dados.log-docto            = p-log-docto /*YES = pedido , NO = nota*/
                    tt-dados.tipo-pedido          = ped-venda.esp-ped
                    tt-dados.cod-sit-com          = ped-item.cod-sit-com
                    tt-dados.cod-sit-ped          = ped-venda.cod-sit-ped

                    /*valor liq para item controlado por produto e n o controlado*/
                    tt-dados.valor-unit-liq       = if l-log-produto then (ped-item.vl-liq-it / de-quantidade)
                                                                     else  ped-item.vl-liq-it 

                    /*valor bruto para item controlado por produto e n o controlado*/
                    tt-dados.valor-unit-bru       = if l-log-produto then ((ped-item.qt-pedida * ped-item.vl-preori) / de-quantidade-aux)
                                                                     else (ped-item.qt-pedida * ped-item.vl-preori) 
                    tt-dados.quantidade           = if l-log-produto then de-quantidade else ped-item.qt-pedida.

             /*quanto controlado por pontos, multiplica pelo nr de pontos*/
             if par-cota.tipo-controle = 3 then
                assign tt-dados.quantidade = tt-dados.quantidade * de-pontos.           

          end.
          /****************************** caso ja exista tt-dados **************************/
          else do:

                      /*acumula valor liq para item controlado por produto e n o controlado*/
               assign tt-dados.valor-unit-liq     = if l-log-produto then (tt-dados.valor-unit-liq + (ped-item.vl-liq-it / de-quantidade)) 
                                                                     else (tt-dados.valor-unit-liq + ped-item.vl-liq-it )
                      /*acumula valor bruto para item controlado por produto e n o controlado*/
                      tt-dados.valor-unit-bru     = if l-log-produto then (tt-dados.valor-unit-bru + ((ped-item.qt-pedida * ped-item.vl-preori) / de-quantidade-aux )) 
                                                                     else (tt-dados.valor-unit-bru + (ped-item.qt-pedida * ped-item.vl-preori)) .
               /*quanto controlado por pontos, multiplica pelo nr de pontos*/
               /* se tipo controle = 3 ent o atualiza nr-pontos sen o nr pontos ˝ 1.*/
               assign de-quantidade           = de-quantidade * de-pontos           
                      de-quant-temp           = ped-item.qt-pedida
                      de-quant-temp           = de-quant-temp * de-pontos.           

               assign tt-dados.quantidade     = if l-log-produto then (tt-dados.quantidade + de-quantidade)  else (tt-dados.quantidade + de-quant-temp).
          end.            
          /**************************************************************************/
    end.

&endif

procedure pi-chama-upc-quando-pedido-aprovado.
  /*
   Chamada de upc num ponto estratÇgico desse programa, quando o pedido vem como 
   aprovado em cotas. 
  */   
  for each tt-epc where tt-epc.cod-event = "aprove".
      delete tt-epc.
  end.

  /* Include i-epc200.i2: Criaá∆o de registro para Temp-Table tt-epc */
  {include/i-epc200.i2 &CodEvent='"aprove"'
                       &CodParameter='"rowid-ped-venda"'
                       &ValueParameter="string(rowid(b-ped-venda))"}

  /* Include i-epc201.i: Chamada do programa de EPC */
  {include/i-epc201.i "aprove"}.

end procedure.

procedure pi-chama-upc-altera-data:
    /*
    Chamada EPC em ponto estratÇgico do programa, 
    para possibilitar a alteraá∆o da data de controle (entrega ou emiss∆o)
    */
    def var i-dia as int.
    def var i-mes as int.
    def var i-ano as int.

    for each tt-epc where tt-epc.cod-event = "updateDate":
        delete tt-epc.
    end.

    /* Include i-epc200.i2: Criaá∆o de registro para temp-table tt-epc */
    {include/i-epc200.i2 &CodEvent='"updateDate"'
                         &CodParameter='"rowid-ped-venda"'
                         &ValueParameter="string(rowid(ped-venda))"}

    /* Include i-epc201.i: Chamada do programa de EPC */
    {include/i-epc201.i "updateDate"}

    if  return-value = "OK" then do:
        find first tt-epc where tt-epc.cod-event = "updateDate" and
                                tt-epc.cod-parameter = "newDate" no-lock no-error.
        if  avail tt-epc then do:
            assign tt-epc.val-parameter = replace(tt-epc.val-parameter,"/","")
                   i-dia  = int(substring(tt-epc.val-parameter,1,2))
                   i-mes  = int(substring(tt-epc.val-parameter,3,2))
                   i-ano  = int(substring(tt-epc.val-parameter,5,4))
                   dt-ini = date(i-mes,i-dia,i-ano).
        end.
    end.
end procedure.

procedure pi-chama-upc-nota-fiscal:
    /*
    Chamada EPC em ponto estratÇgico do programa, 
    para n∆o gerar a movimentaá∆o de cotas quando
    tipo documento for igual a nota-fiscal 
    Obs.: Alteraá∆o realizada cforme solitaá∆o da
    grendene FO 776.482.
    */

    /* Include i-epc200.i2: Criaá∆o de registro para temp-table tt-epc */
    {include/i-epc200.i2 &CodEvent='"nota-fiscal"'
                         &CodParameter='"rowid-ped-venda"'
                         &ValueParameter="string(?)"}

    /* Include i-epc201.i: Chamada do programa de EPC */
    {include/i-epc201.i "nota-fiscal"}

end procedure.

procedure pi-envia-email-comercial:

    define input param p-nr-pedcli  as char no-undo.
    define input param p-nome-abrev as char no-undo.

    IF NOT AVAIL para-ped THEN
        FIND FIRST para-ped NO-LOCK NO-ERROR.

    IF SUBSTRING(para-ped.char-1,64,3) = "YES" THEN DO: /* Verifica se o parÉmetro de hist¢rico de pedido esta ativo no PD0301 */

        IF NOT VALID-HANDLE(h-bodi605) THEN                                         
           RUN dibo/bodi605.p PERSISTENT SET h-bodi605.                             
                                                                                    
        RUN logComercial IN h-bodi605 (INPUT p-nr-pedcli,                   
                                       INPUT p-nome-abrev).                 
                                                                                    
        IF VALID-HANDLE(h-bodi605) THEN DELETE PROCEDURE h-bodi605.                 
    END.
                                                                                
    IF NOT VALID-HANDLE(h-pdapi513e) THEN                                       
       RUN pdp/pdapi513e.p PERSISTENT SET h-pdapi513e.                          
                                                                                
    RUN piMandaEmailComercial IN h-pdapi513e (INPUT p-nr-pedcli,        
                                              INPUT p-nome-abrev).      
                                                                                
    IF VALID-HANDLE(h-pdapi513e) THEN DELETE PROCEDURE h-pdapi513e.             
    
end procedure.


