/********************************************************************************
** Include   : acp/acapi003.i
** Data      : 26/03/1999
** Autor     : Datasul S.A.
** Objetivo  : Valida informaá‰es de Cotas no PD0508.
** Chamada   : Chamada pela viewer do pd0508c.w - v03di154
********************************************************************************/

find first param-global no-lock no-error.
if param-global.modulo-08 then do:
       find first para-ped no-lock no-error.
       if substring(para-ped.char-2,1,3)  = "yes" then
          find par-cota no-lock
               where par-cota.cod-estabel = para-ped.estab-padrao no-error.
       else    
          find par-cota no-lock
               where par-cota.cod-estabel = ped-venda.cod-estabel no-error.  
      
       if l-achou-cota = no           and      /*n∆o achou cotas - origem acapi003.p*/ 
          par-cota.cota-implant <> 3  then do: /*prossegue normal*/
           {utp/ut-table.i mgdis cotas 1}
           run utp/ut-msgs.p ("show", 56,return-value ).
       end.

       if ped-venda.esp-ped      = 2  and   /*pedido aberto*/
          par-cota.pedido-aberto = no then  /*controla pedido aberto*/
          . /*n∆o faz nada*/
       else do:

            if par-cota.tipo-cota    =  2 and /*deve controlar valor maximo*/
               par-cota.aval-cota    <> 3 then do:  

            /* Verifica se a natureza pedido controla cotas. Caso n∆o , aprova normalmente os pedidos */
            &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
               if can-find ( first natur-oper where
                                   natur-oper.nat-operacao = ped-venda.nat-operacao and
                                   natur-oper.log-atual-cotas = yes) then do:
     
            &else
               if can-find ( first natur-oper where
                                   natur-oper.nat-operacao = ped-venda.nat-operacao and
                                   substr(natur-oper.char-2,31,1) = "1") then do:
            &endif                   
     
                    /************* Tipo Controle por valor *********************/
                    if par-cota.tipo-controle = 2 then do: 
                       if par-cota.tipo-valor = 1 then do: /*bruto*/
                          if ((ped-item.qt-pedida * ped-item.vl-preori) 
                               > de-saldo-cota) then 
       
                               run utp/ut-msgs.p ("show", 17054, "").

                       end. 
                       else /*liquido*/ do:
                          if ped-item.vl-liq-it > de-saldo-cota then 

                             run utp/ut-msgs.p ("show", 17054, "").

                       end.
                    end. 
                    /************* Tipo Controle por quantidade ****************/
                    if par-cota.tipo-controle = 1 then do: 
                       if ped-item.qt-pedida > de-saldo-cota  then
     
                          run utp/ut-msgs.p ("show", 17054, "").

                    end.
                    /************* Tipo Controle por Pontos *******************/
                    if par-cota.tipo-controle = 3 then do: 
                        assign l-log-produto = no.
     
                       /*verifica se item Ç controlado por produto*/
                        find item-cota no-lock
                             where item-cota.it-codigo = ped-item.it-codigo no-error.
                         
                        if avail item-cota then do:
                           if item-cota.log-produto and
                              par-cota.cont-produto then do : /*controla por produto*/
                              /************************************************************ 
                              *  PrÇ-Processador para o m¢dulo de Administraá∆o de Cotas
                              ************************************************************/
 
                              &if defined (bf_dis_adm_cotas) &then
                                  find est-prod-coml where est-prod-coml.it-codigo = item-cota.it-codigo no-lock no-error.
                                  assign de-quantidade = est-prod-coml.qt-aplicada
                                         l-log-produto = yes.
                              &else
                                  find est-prod where est-prod.it-codigo = item-cota.it-codigo no-lock no-error.
                                  assign de-quantidade = est-prod.qt-aplicada
                                         l-log-produto = yes.
                              &endif
                           end.
     
                           if l-log-produto then do:
                              
                              &if defined (bf_dis_adm_cotas) &then /*release 2.03*/
                                  /* multiplica */
                                  if ((ped-item.qt-pedida * de-quantidade ) > de-saldo-cota) then 
                                     run utp/ut-msgs.p ("show", 17054, "").
                              &else
                                  /* divide */
                                  if ((ped-item.qt-pedida / de-quantidade ) > de-saldo-cota) then 
                                     run utp/ut-msgs.p ("show", 17054, "").                              
                              &endif      
                           
                           end.
                           else do:
                              if ped-item.qt-pedida > de-saldo-cota  then
                    
                                 run utp/ut-msgs.p ("show", 17054, "").
                    
                           end. 
                        end. /*avail item-cota*/
                    end. /*tipo controle pontos*/
               end. /*natur-oper*/
            end. /*par-cota*/
       end. /*ped-venda.esp-ped - pedido aberto */
   end. /*par-cota*/
end. /*param-global*/  


/*acapi003.i*/
