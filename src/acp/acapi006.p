/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ACAPI006 2.00.00.017 } /*** "010017" 28/02/2025 09:42:30  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i acapi006 MAC}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*************************************************************************
* Programa.: acp~\acapi006.p Cotas
* Autor....: DATASUL S.A. 
* Vers∆o...: 2.00.00.000 - Adriano - Criaá∆o do Programa  20/04/1998
**************************************************************************/

{utp/ut-glob.i}

{cdp/cdcfgdis.i} /* definiá∆o pre-processador */

{acp/acapi006.i}   /* definiá∆o das temp-tables */

/* parametros */
def input        parameter i-versao-integracao as int    .
def input        parameter table for tt-cotas            .
def output       parameter table for tt-erros-api        .

def var i-conta-msg           as integer             no-undo init 0.
def var de-pedida             like cotas.qt-pedida   no-undo.
def var de-prevista           like cotas.qt-prevista no-undo.
def var de-tot-qt-prevista    like cotas.qt-prevista no-undo. 
def var c-texto               as char extent 2       no-undo.
def var l-achou-erro          as logical  init no    no-undo.
def var c-interroga           as char format "x(9)"  no-undo.
def var c-label               as char                no-undo.
def var rw-cotas              as rowid               no-undo.
def var de-valor-base         as dec                 no-undo.

{utp/ut-liter.i Interroga MAC *} c-interroga = trim(return-value).

/***** Verifica vers∆o da api *****/
if i-versao-integracao <> 1 then do:
    run utp/ut-msgs.p ('msg', 3941, '').
    create tt-erros-api.
    assign tt-erros-api.num-sequencia-erro = 1
           tt-erros-api.cod-erro           = 3941
           tt-erros-api.des-erro           = return-value.
    return "NOK".
end.

/*
/***** M¢dulo de Cotas n∆o Implantado *****/
find first param-global no-lock no-error.
if param-global.modulo-08 = no then do:
   create tt-erros-api.
   {utp/ut-table.i movdis cotas 1}
   assign tt-erros-api.label-campo-1 = trim(return-value). 
   run utp/ut-msgs.p ('msg', 2082, return-value).
   assign tt-erros-api.num-sequencia-erro = 1
          tt-erros-api.cod-erro           = 2082
          tt-erros-api.des-erro           = return-value.
   return "NOK".
end. 
*/

/***** N∆o Existe nenhum registro na tt-cotas *****/
if  not can-find(first tt-cotas) then do: 
    create tt-erros-api.
    {utp/ut-liter.i Tabela_Tempor†ria_de_Cotas MAC c}
    assign tt-erros-api.label-campo-1 = trim(return-value).
    run utp/ut-msgs.p ('msg', 5561, return-value).
    assign tt-erros-api.num-sequencia-erro = 1
           tt-erros-api.cod-erro           = 5561
           tt-erros-api.des-erro           = return-value.
    return "NOK".
end.


/******************************************************************************/

bloco-tt-cotas:

for each tt-cotas :

    /******************** I N C L U S « O ******************************/
    if tt-cotas.ind-tipo-movto = 1 then do: 

       assign l-achou-erro = no.

       /* parametros da tt-cotas incorretos */
       if tt-cotas.log-base-cota     = no  and
          tt-cotas.log-previsto-base = yes then do:
            create tt-erros-api.
            run utp/ut-msgs.p (input "msg",
                               input 17402,
                               input '').

            assign i-conta-msg   = i-conta-msg + 1.
            {acp/acapi006.i1 "17402"}.
            next bloco-tt-cotas .
       end. 

       /*** ParÉmetros de Cotas ***/
       find par-cota no-lock
            where par-cota.cod-estabel = tt-cotas.cod-estabel no-error.
       if not avail par-cota then do:
          create tt-erros-api.
          {utp/ut-table.i mgdis par-cota 1}
          assign tt-erros-api.label-campo-1 = trim(return-value).
          run utp/ut-msgs.p (input "msg",
                             input 2,
                             input return-value).
          assign i-conta-msg   = i-conta-msg + 1.
          {acp/acapi006.i1 "2"}.
          next bloco-tt-cotas .
       end.

       run pi-validacao-chave.

       /* caso tenha acontecido algum erro, là o proximo registro na pi-validacao-chave*/
       if l-achou-erro then
          next bloco-tt-cotas.

       find par-cota no-lock where 
            par-cota.cod-estabel = tt-cotas.cod-estabel no-error.      


       find cotas exclusive-lock where
            cotas.cod-estabel     =  tt-cotas.cod-estabel                                                and
            cotas.cod-canal-venda = (if par-cota.cont-canal-venda then tt-cotas.cod-canal-venda else 0)  and
            cotas.cod-gr-cli      = (if par-cota.cont-gr-cli      then tt-cotas.cod-gr-cli      else 0)  and
            cotas.nome-abrev      = (if par-cota.cont-cliente     then tt-cotas.nome-abrev      else "") and
            cotas.nome-ab-reg     = (if par-cota.cont-ab-reg      then tt-cotas.nome-ab-reg     else "") and
            cotas.nome-mic-reg    = (if par-cota.cont-mic-reg     then tt-cotas.nome-mic-reg    else "") and
            cotas.cod-rep         =  tt-cotas.cod-rep                                                    and  
            cotas.cd-produto      =  tt-cotas.cd-produto                                                 and  
            cotas.dt-inicial      =  tt-cotas.dt-inicial no-error.

       if avail cotas then do:

          /* tentou criar um registro mas j† existia*/ 
          create tt-erros-api. 
          {utp/ut-table.i mgdis cotas 1}
          assign tt-erros-api.label-campo-1 = trim(return-value).
          run utp/ut-msgs.p ('msg', 7, return-value).
          assign i-conta-msg   = i-conta-msg + 1.

          {acp/acapi006.i1 "7"}

          next bloco-tt-cotas.

       end. /*if avail cotas*/

       else do: /* criaá∆o de um registro novo */

          for first item-cota fields(log-cota-limite) no-lock where
                    item-cota.it-codigo = tt-cotas.cd-produto :
          end.
          /**************** USO DE PRE-PROCESSADOR *********************/
          &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
              for first produto-coml fields() no-lock
                   where produto-coml.cod-produto-coml =  tt-cotas.cd-produto .
              end.
          &ELSE
              for first produto fields() no-lock
                   where produto.cd-produto =  tt-cotas.cd-produto .
              end.
          &ENDIF         

          find first base-cota exclusive-lock where
                     base-cota.cod-estabel = tt-cotas.cod-estabel and
                     base-cota.cd-produto  = tt-cotas.cd-produto  and
                     base-cota.dt-inicial  = tt-cotas.dt-inicial  no-error.

          /* j† existe base de cotas */
          if avail base-cota then do:

             if tt-cotas.log-previsto-base = no  and      /* N∆o vai atualizar previsto na base cotas. precisa validar */
                tt-cotas.log-previsto-cota = yes then do: /* vai atualizar previsto em cotas */

                /* validaá∆o do previsto, para n∆o ultrapassar o previsto da base de cotas */
                assign de-tot-qt-prevista = 0.
                for each cotas no-lock use-index produto where
                         cotas.cd-produto   = base-cota.cd-produto and 
                         cotas.cod-estabel  = base-cota.cod-estabel and
                         cotas.dt-inicial   = base-cota.dt-inicial :
                    if par-cota.tipo-controle = 2 then /*valor*/
                       assign de-tot-qt-prevista = de-tot-qt-prevista + cotas.vl-previsto.
                    else /*quantidade,pontos*/
                       assign de-tot-qt-prevista = de-tot-qt-prevista + cotas.qt-prevista.
                end.
                if de-tot-qt-prevista < 0 then assign de-tot-qt-prevista = 0.   

                if par-cota.tipo-controle = 2 then do: /*valor*/

                   /**************** USO DE PRE-PROCESSADOR *********************/
                   &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
                       if par-cota.log-limita-rateio = yes and
                          par-cota.log-impl-niveis    = no  then do:
                          if (de-tot-qt-prevista + tt-cotas.vl-previsto) > base-cota.qt-prevista then do:
                              create tt-erros-api. 
                             {utp/ut-liter.i Valor_Previsto * L}
                              assign tt-erros-api.label-campo-1 = trim(return-value).
                              run utp/ut-msgs.p (input "msg",
                                                 input 15981,
                                                 input return-value).
                              assign i-conta-msg   = i-conta-msg + 1.
                              {acp/acapi006.i1 "15981"}
                              next bloco-tt-cotas.                                      
                          end.    
                       end.

                       run pi-trata-rateio-pai.
                       if l-achou-erro then    
                          next bloco-tt-cotas.               

                       run pi-trata-rateio-filho.
                       if l-achou-erro then    
                          next bloco-tt-cotas.  

                   &ELSE
                       if (de-tot-qt-prevista + tt-cotas.vl-previsto) > base-cota.qt-prevista then do:
                           create tt-erros-api. 
                          {utp/ut-liter.i Valor_Previsto * L}
                           assign tt-erros-api.label-campo-1 = trim(return-value).
                           run utp/ut-msgs.p (input "msg",
                                              input 15981,
                                              input return-value).
                           assign i-conta-msg   = i-conta-msg + 1.
                           {acp/acapi006.i1 "15981"}
                           next bloco-tt-cotas.                                      
                       end.                       
                   &ENDIF
                   /************** FIM USO DE PRE-PROCESSADOR *******************/
                end.             
                else do: /*quantidade e pontos*/      
                   /**************** USO DE PRE-PROCESSADOR *********************/
                   &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
                       if par-cota.log-limita-rateio = yes and
                          par-cota.log-impl-niveis    = no  then do:

                          if (de-tot-qt-prevista + tt-cotas.qt-prevista) > base-cota.qt-prevista then do:
                              create tt-erros-api. 
                             {utp/ut-liter.i Quantidade_Prevista * L}
                              assign tt-erros-api.label-campo-1 = trim(return-value).
                              run utp/ut-msgs.p (input "msg",
                                                 input 15981,
                                                 input return-value).
                              assign i-conta-msg   = i-conta-msg + 1
                                     l-achou-erro  = yes.

                             {acp/acapi006.i1 "15981"}

                             next bloco-tt-cotas.                                       
                          end.
                       end.


                       run pi-trata-rateio-pai.
                       if l-achou-erro then    
                          next bloco-tt-cotas.  

                       run pi-trata-rateio-filho.
                       if l-achou-erro then    
                          next bloco-tt-cotas.                         
                   &ELSE
                       if (de-tot-qt-prevista + tt-cotas.qt-prevista) > base-cota.qt-prevista then do:
                           create tt-erros-api. 
                          {utp/ut-liter.i Quantidade_Prevista * L}
                           assign tt-erros-api.label-campo-1 = trim(return-value).
                           run utp/ut-msgs.p (input "msg",
                                              input 15981,
                                              input return-value).
                           assign i-conta-msg   = i-conta-msg + 1
                                  l-achou-erro  = yes.
                           {acp/acapi006.i1 "15981"}

                           next bloco-tt-cotas.                                       
                       end.                   
                   &ENDIF
                   /************** FIM USO DE PRE-PROCESSADOR *******************/
                end. /* fim validaá∆o */              
             end. /* fim log-previsto-base e log-previsto-cota */

             /* validaá∆o de valores e quantidades */
             if par-cota.tipo-cota = 2 then do: /*minima e m†xima*/
                assign c-label = "".

                if par-cota.tipo-controle = 2 then do: /*valor*/


                   /**************** USO DE PRE-PROCESSADOR *********************/
                  &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
                      if (avail item-cota                  and
                          item-cota.log-cota-limite = yes) or
                          avail produto-coml                then do:
                  &ELSE
                      if (avail item-cota                  and
                          item-cota.log-cota-limite = yes) or
                          avail produto                    then do:
                  &ENDIF

                        &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */

                            if base-cota.log-cota-limite = yes then do:
                               if tt-cotas.vl-pedido   > tt-cotas.vl-previsto then do:
                                  {utp/ut-field.i mgdis cotas vl-pedido 1}   c-label = trim(return-value).
                               end.
                               if tt-cotas.vl-faturado > tt-cotas.vl-previsto then do:
                                  {utp/ut-field.i mgdis cotas vl-faturado 1} c-label = trim(return-value).
                               end.
                            end.

                        &ELSE 

                            if tt-cotas.vl-pedido   > tt-cotas.vl-previsto then do:
                               {utp/ut-field.i mgdis cotas vl-pedido 1}   c-label = trim(return-value).
                            end.
                            if tt-cotas.vl-faturado > tt-cotas.vl-previsto then do:
                               {utp/ut-field.i mgdis cotas vl-faturado 1} c-label = trim(return-value).
                            end.                   

                        &ENDIF

                   end. /* if avail item-cota */

                   if tt-cotas.vl-ped-canc > tt-cotas.vl-previsto then do:
                      {utp/ut-field.i mgdis cotas vl-ped-canc 1} c-label = trim(return-value).
                   end.
                   if tt-cotas.vl-fat-canc > tt-cotas.vl-previsto then do:
                      {utp/ut-field.i mgdis cotas vl-fat-canc 1} c-label = trim(return-value).
                   end.
                   if tt-cotas.vl-ped-susp > tt-cotas.vl-previsto then do:
                      {utp/ut-field.i mgdis cotas vl-ped-susp 1} c-label = trim(return-value).
                   end.

                end.
                else do: /*quantidade/pontos*/

                  /**************** USO DE PRE-PROCESSADOR *********************/
                  &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
                      if (avail item-cota                  and
                          item-cota.log-cota-limite = yes) or
                          avail produto-coml               then do:
                  &ELSE
                      if (avail item-cota                  and
                          item-cota.log-cota-limite = yes) or
                          avail produto                    then do:
                  &ENDIF

                        &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
                            if base-cota.log-cota-limite = yes then do:
                                 if tt-cotas.qt-pedida   > tt-cotas.qt-prevista then do:
                                    {utp/ut-field.i mgdis cotas qt-pedida 1}   c-label = trim(return-value).
                                 end.
                                 if tt-cotas.qt-faturada > tt-cotas.qt-prevista then do:
                                    {utp/ut-field.i mgdis cotas qt-faturada 1} c-label = trim(return-value).
                                 end. 
                            end. 

                        &ELSE

                            if tt-cotas.qt-pedida   > tt-cotas.qt-prevista then do:
                               {utp/ut-field.i mgdis cotas qt-pedida 1}   c-label = trim(return-value).
                            end.
                            if tt-cotas.qt-faturada > tt-cotas.qt-prevista then do:
                               {utp/ut-field.i mgdis cotas qt-faturada 1} c-label = trim(return-value).
                            end.   

                        &ENDIF

                   end. /* if avail item-cota */

                   if tt-cotas.qt-ped-canc > tt-cotas.qt-prevista then do:
                      {utp/ut-field.i mgdis cotas qt-ped-canc 1} c-label = trim(return-value).
                   end.
                   if tt-cotas.qt-fat-canc > tt-cotas.qt-prevista then do:
                      {utp/ut-field.i mgdis cotas qt-fat-canc 1} c-label = trim(return-value).
                   end.
                   if tt-cotas.qt-ped-susp > tt-cotas.qt-prevista then do:
                      {utp/ut-field.i mgdis cotas qt-ped-susp 1} c-label = trim(return-value).
                   end.
                end. 

                if c-label <> "" then do:   
                   create tt-erros-api.
                   assign tt-erros-api.label-campo-1 = c-label.
                   {utp/ut-field.i mgdis cotas.qt-prevista 1}                    
                   assign tt-erros-api.label-campo-2 = trim(return-value).
                   run utp/ut-msgs.p ('msg', 16075, c-label + "~~" + return-value).
                   assign i-conta-msg   = i-conta-msg + 1.
                   {acp/acapi006.i1 "16075"}
                   next bloco-tt-cotas.
                end.             

             end. /*fim validaá∆o de valores e quantidades*/          

             /* atualizaá∆o */
             if par-cota.tipo-controle = 2 /*valor*/ then do:
                assign base-cota.qt-pedida = base-cota.qt-pedida + tt-cotas.vl-pedido.      
                if tt-cotas.log-previsto-base then
                   assign base-cota.qt-prevista = base-cota.qt-prevista + tt-cotas.vl-previsto.
             end.
             else do: /*quantidade/pontos*/
                assign base-cota.qt-pedida = base-cota.qt-pedida + tt-cotas.qt-pedida.      
                if tt-cotas.log-previsto-base then
                   assign base-cota.qt-prevista = base-cota.qt-prevista + tt-cotas.qt-prevista.
             end. 
             /* fim da atualizaá∆o */

          end.

          /* vai criar base de cotas */
          else do:
             if tt-cotas.log-base-cota then do: /* parametro para criar base-cota */
                create base-cota.
                assign base-cota.cod-estabel      = tt-cotas.cod-estabel
                       base-cota.cd-produto       = tt-cotas.cd-produto
                       base-cota.dt-inicial       = tt-cotas.dt-inicial
                       base-cota.dt-final         = tt-cotas.dt-final
                       base-cota.log-consid-cotas = if can-find (item-cota
                                                                    where item-cota.it-codigo = base-cota.cd-produto and
                                                                          item-cota.log-consid-cotas) then yes else no
                &if defined(bf_dis_adm_cotas) &then  /* INICIO PREPROCESSADOR */
                       base-cota.cd-produto-dest  = tt-cotas.cd-produto
                       base-cota.log-cota-limite  = if can-find (item-cota
                                                                    where item-cota.it-codigo = base-cota.cd-produto and
                                                                          item-cota.log-cota-limite) then yes else no
                &endif.

                if par-cota.tipo-controle = 2 /*valor*/ then do:
                   assign base-cota.qt-pedida = tt-cotas.vl-pedido.      
                   if tt-cotas.log-previsto-base then
                      assign base-cota.qt-prevista = tt-cotas.vl-previsto.
                end.
                else do: /*quantidade/pontos*/
                   assign base-cota.qt-pedida = tt-cotas.qt-pedida.      

                   if tt-cotas.log-previsto-base then
                      assign base-cota.qt-prevista = tt-cotas.qt-prevista.
                end. 
             end. /* if log-base-cota*/
             else do: /* se o parametro estiver para n∆o criar base-cota e n∆o existir base cota*/
                 create tt-erros-api. 
                 {utp/ut-liter.i Base_de_Cotas MAC c}
                 assign tt-erros-api.label-campo-1 = trim(return-value).
                 run utp/ut-msgs.p (input "msg",
                                    input 2,
                                    input return-value).
                 assign i-conta-msg   = i-conta-msg + 1.
                 {acp/acapi006.i1 "2"}.              
                 next bloco-tt-cotas.           
             end.

          end.

          create cotas.
          assign cotas.cod-estabel     = tt-cotas.cod-estabel
                 cotas.cod-rep         = tt-cotas.cod-rep
                 cotas.cd-produto      = tt-cotas.cd-produto
                 cotas.dt-inicial      = tt-cotas.dt-inicial                 
                 cotas.cod-canal-venda = tt-cotas.cod-canal-venda
                 cotas.cod-gr-cli      = tt-cotas.cod-gr-cli
                 cotas.nome-abrev      = tt-cotas.nome-abrev
                 cotas.nome-ab-reg     = tt-cotas.nome-ab-reg
                 cotas.nome-mic-reg    = tt-cotas.nome-mic-reg
                 cotas.cota-liberada   = tt-cotas.cota-liberada
                 cotas.dt-final        = tt-cotas.dt-final
                 cotas.pct-variacao    = tt-cotas.pct-variacao
                 cotas.qt-fat-canc     = tt-cotas.qt-fat-canc
                 cotas.qt-faturada     = tt-cotas.qt-faturada
                 cotas.qt-ped-canc     = tt-cotas.qt-ped-canc
                 cotas.qt-ped-susp     = tt-cotas.qt-ped-susp
                 cotas.qt-pedida       = tt-cotas.qt-pedida
                 cotas.qt-solicitado   = tt-cotas.qt-solicitado
                 cotas.vl-fat-canc     = tt-cotas.vl-fat-canc
                 cotas.vl-faturado     = tt-cotas.vl-faturado
                 cotas.vl-medio-prev   = tt-cotas.vl-medio-prev
                 cotas.vl-ped-canc     = tt-cotas.vl-ped-canc
                 cotas.vl-ped-susp     = tt-cotas.vl-ped-susp
                 cotas.vl-pedido       = tt-cotas.vl-pedido
                 cotas.vl-solicitado   = tt-cotas.vl-solicitado.

          &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
                 assign cotas.vl-ped-reprov   = tt-cotas.vl-ped-reprov 
                        cotas.qt-ped-reprov   = tt-cotas.qt-ped-reprov.    
          &ENDIF            

          if par-cota.tipo-controle = 2 /*valor*/ then do:
             assign cotas.vl-previsto = tt-cotas.vl-previsto
                    cotas.vl-original = tt-cotas.vl-original.
          end.
          else do: /*quantidade/pontos*/
             assign cotas.qt-prevista = tt-cotas.qt-prevista
                    cotas.qt-original = tt-cotas.qt-original.
          end. 

       end. /*fim criaá∆o registro*/
    end. /* fim inclus∆o */



    /******************** M O D I F I C A Ä « O *********************************/
    if tt-cotas.ind-tipo-movto = 2 then do: 

       assign l-achou-erro = no.

       /*** ParÉmetros de Cotas ***/
       find par-cota no-lock
            where par-cota.cod-estabel = tt-cotas.cod-estabel no-error.
       if not avail par-cota then do:
          create tt-erros-api. 
          {utp/ut-table.i mgdis par-cota 1}
          assign tt-erros-api.label-campo-1 = trim(return-value).
          run utp/ut-msgs.p (input "msg",
                             input 2,
                             input return-value).
          assign i-conta-msg   = i-conta-msg + 1.

          {acp/acapi006.i1 "2"}.

          next bloco-tt-cotas.

       end.

       find par-cota no-lock where 
            par-cota.cod-estabel = tt-cotas.cod-estabel no-error.      


       find first cotas no-lock where
                  cotas.cod-estabel     = tt-cotas.cod-estabel     and  
                  cotas.cod-canal-venda = tt-cotas.cod-canal-venda and
                  cotas.cod-gr-cli      = tt-cotas.cod-gr-cli      and
                  cotas.nome-abrev      = tt-cotas.nome-abrev      and
                  cotas.nome-ab-reg     = tt-cotas.nome-ab-reg     and
                  cotas.nome-mic-reg    = tt-cotas.nome-mic-reg    and
                  cotas.cod-rep         = tt-cotas.cod-rep         and  
                  cotas.cd-produto      = tt-cotas.cd-produto      and  
                  cotas.dt-inicial      = tt-cotas.dt-inicial      no-error.

       if not avail cotas then do:
          /* registro para ser modificado nao existe*/ 
          create tt-erros-api.
          {utp/ut-table.i mgdis cotas 1}
          assign tt-erros-api.label-campo-1 = trim(return-value).
          run utp/ut-msgs.p ('msg', 56, return-value).
          assign i-conta-msg   = i-conta-msg + 1.

          {acp/acapi006.i1 "56"}

          next bloco-tt-cotas.                                   
       end. /*if not avail cotas*/

       else do: /* modificacao do registro */

          assign rw-cotas = rowid(cotas).

          if par-cota.tipo-controle    = 2 /*valor*/ then
             assign de-pedida          = cotas.vl-pedido
                    de-prevista        = cotas.vl-previsto.
          else   
             assign de-pedida          = cotas.qt-pedida
                    de-prevista        = cotas.qt-prevista.

          for first item-cota fields(log-cota-limite) no-lock where
                    item-cota.it-codigo = tt-cotas.cd-produto :
          end.
          /**************** USO DE PRE-PROCESSADOR *********************/
          &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
              for first produto-coml fields() no-lock
                   where produto-coml.cod-produto-coml =  tt-cotas.cd-produto :
              end.
          &ELSE
              for first produto fields() no-lock
                   where produto.cd-produto =  tt-cotas.cd-produto :
              end.
          &ENDIF                     

          find first base-cota exclusive-lock where
                     base-cota.cod-estabel = tt-cotas.cod-estabel and
                     base-cota.cd-produto  = tt-cotas.cd-produto  and
                     base-cota.dt-inicial  = tt-cotas.dt-inicial  no-error.

          if not avail base-cota then do:
             create tt-erros-api.
            {utp/ut-table.i mgdis base-cota 1}
             assign tt-erros-api.label-campo-1 = trim(return-value).
             run utp/ut-msgs.p (input "msg",
                                input 2,
                                input return-value).
             assign i-conta-msg   = i-conta-msg + 1
                    l-achou-erro  = yes.  
             {acp/acapi006.i1 "2"}
              next bloco-tt-cotas.
          end.          
          else do: /* se encontrar base-cota */

             /* validaá∆o */
             if tt-cotas.log-previsto-base = no  and      /* N∆o vai atualizar previsto na base cotas. precisa validar */
                tt-cotas.log-previsto-cota = yes then do: /* vai atualizar previsto em cotas */

                /* validaá∆o do previsto, para n∆o ultrapassar o previsto da base de cotas */
                assign de-tot-qt-prevista = 0.
                for each cotas no-lock use-index produto
                    where cotas.cd-produto   = base-cota.cd-produto
                    and   cotas.cod-estabel  = base-cota.cod-estabel
                    and   cotas.dt-inicial   = base-cota.dt-inicial :
                    if par-cota.tipo-controle = 2 then /*valor*/
                       assign de-tot-qt-prevista = de-tot-qt-prevista + cotas.vl-previsto.
                    else /*quantidade,pontos*/
                       assign de-tot-qt-prevista = de-tot-qt-prevista + cotas.qt-prevista.
                end.

                if de-tot-qt-prevista < 0 then assign de-tot-qt-prevista = 0.   

                /* menos o valor previsto da cota atual */
                assign de-tot-qt-prevista = de-tot-qt-prevista - de-prevista.

                if par-cota.tipo-controle = 2 then do: /*valor*/

                   /**************** USO DE PRE-PROCESSADOR *********************/
                   &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
                       if par-cota.log-limita-rateio = yes and
                          par-cota.log-impl-niveis    = no  then do:
                            if (de-tot-qt-prevista + tt-cotas.vl-previsto) > base-cota.qt-prevista then do:
                                create tt-erros-api.
                               {utp/ut-liter.i Valor_Previsto * L}
                                assign tt-erros-api.label-campo-1 = trim(return-value).
                                run utp/ut-msgs.p (input "msg",
                                                   input 15981,
                                                   input return-value).
                                assign i-conta-msg   = i-conta-msg + 1.

                                {acp/acapi006.i1 "15981"}

                                next bloco-tt-cotas.                                      

                            end.    
                       end.

                       run pi-trata-rateio-pai.
                       if l-achou-erro then    
                          next bloco-tt-cotas.
                       run pi-trata-rateio-filho.
                       if l-achou-erro then    
                          next bloco-tt-cotas.                                                       

                   &ELSE  
                       if (de-tot-qt-prevista + tt-cotas.vl-previsto) > base-cota.qt-prevista then do:
                           create tt-erros-api.
                          {utp/ut-liter.i Valor_Previsto * L}
                           assign tt-erros-api.label-campo-1 = trim(return-value).
                           run utp/ut-msgs.p (input "msg",
                                              input 15981,
                                              input return-value).
                           assign i-conta-msg   = i-conta-msg + 1.
                           {acp/acapi006.i1 "15981"}
                           next bloco-tt-cotas.                                      
                       end.                       
                   &ENDIF
                   /************** FIM USO DE PRE-PROCESSADOR *******************/

                end.             
                else do: /*quantidade e pontos*/      
                   /**************** USO DE PRE-PROCESSADOR *********************/
                   &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
                       if par-cota.log-limita-rateio = yes and
                          par-cota.log-impl-niveis    = no  then do:
                            if (de-tot-qt-prevista + tt-cotas.qt-prevista) > base-cota.qt-prevista then do:
                                create tt-erros-api.
                               {utp/ut-liter.i Quantidade_Prevista * L}
                                assign tt-erros-api.label-campo-1 = trim(return-value).
                                run utp/ut-msgs.p (input "msg",
                                                   input 15981,
                                                   input return-value).
                                assign i-conta-msg   = i-conta-msg + 1
                                       l-achou-erro  = yes.

                               {acp/acapi006.i1 "15981"}

                               next bloco-tt-cotas.                                       
                            end.
                       end.
                       run pi-trata-rateio-pai.
                       if l-achou-erro then    
                          next bloco-tt-cotas.                         

                       run pi-trata-rateio-filho.
                       if l-achou-erro then    
                          next bloco-tt-cotas.    
                   &ELSE 
                       if (de-tot-qt-prevista + tt-cotas.qt-prevista) > base-cota.qt-prevista then do:
                           create tt-erros-api.
                          {utp/ut-liter.i Quantidade_Prevista * L}
                           assign tt-erros-api.label-campo-1 = trim(return-value).
                           run utp/ut-msgs.p (input "msg",
                                              input 15981,
                                              input return-value).
                           assign i-conta-msg   = i-conta-msg + 1
                                  l-achou-erro  = yes.

                          {acp/acapi006.i1 "15981"}

                          next bloco-tt-cotas.                                       
                       end.                   
                   &ENDIF
                   /************** FIM USO DE PRE-PROCESSADOR *******************/
                end. /* fim validaá∆o */              
             end. /* fim log-previsto-base e log-previst-cota*/           

             /* validaá∆o de valores e quantidades */

             if par-cota.tipo-cota = 2 then do: /*minima e m†xima*/
                assign c-label = "".
                if par-cota.tipo-controle = 2 then do: /*valor*/


                   /**************** USO DE PRE-PROCESSADOR *********************/
                   &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
                       if (avail item-cota                  and
                           item-cota.log-cota-limite = yes) or
                           avail produto-coml               then do:
                   &ELSE
                       if (avail item-cota                  and
                           item-cota.log-cota-limite = yes) or
                           avail produto                    then do:
                   &ENDIF


                        &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */

                            if base-cota.log-cota-limite = yes then do:
                               if tt-cotas.vl-pedido   > tt-cotas.vl-previsto then do:
                                  {utp/ut-field.i mgdis cotas vl-pedido 1}   c-label = trim(return-value).
                               end.
                               if tt-cotas.vl-faturado > tt-cotas.vl-previsto then do:
                                  {utp/ut-field.i mgdis cotas vl-faturado 1} c-label = trim(return-value).
                               end.
                            end. 

                        &ELSE

                            if tt-cotas.vl-pedido   > tt-cotas.vl-previsto then do:
                               {utp/ut-field.i mgdis cotas vl-pedido 1}   c-label = trim(return-value).
                            end.
                            if tt-cotas.vl-faturado > tt-cotas.vl-previsto then do:
                               {utp/ut-field.i mgdis cotas vl-faturado 1} c-label = trim(return-value).
                            end.                   

                        &ENDIF.
                   end. /* avail item-cota */

                   if tt-cotas.vl-ped-canc > tt-cotas.vl-previsto then do:
                      {utp/ut-field.i mgdis cotas vl-ped-canc 1} c-label = trim(return-value).
                   end.
                   if tt-cotas.vl-fat-canc > tt-cotas.vl-previsto then do:
                      {utp/ut-field.i mgdis cotas vl-fat-canc 1} c-label = trim(return-value).
                   end.
                   if tt-cotas.vl-ped-susp > tt-cotas.vl-previsto then do:
                      {utp/ut-field.i mgdis cotas vl-ped-susp 1} c-label = trim(return-value).
                   end.
                end.
                else do: /*quantidade/pontos*/


                   /**************** USO DE PRE-PROCESSADOR *********************/
                   &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
                       if (avail item-cota                  and
                           item-cota.log-cota-limite = yes) or
                           avail produto-coml                then do:
                   &ELSE
                       if (avail item-cota                  and
                           item-cota.log-cota-limite = yes) or
                           avail produto                    then do:
                   &ENDIF


                        &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
                            if base-cota.log-cota-limite = yes then do:
                               if tt-cotas.qt-pedida   > tt-cotas.qt-prevista then do:
                                  {utp/ut-field.i mgdis cotas qt-pedida 1}   c-label = trim(return-value).
                               end.
                               if tt-cotas.qt-faturada > tt-cotas.qt-prevista then do:
                                  {utp/ut-field.i mgdis cotas qt-faturada 1} c-label = trim(return-value).
                               end. 
                            end.
                        &ELSE
                            if tt-cotas.qt-pedida   > tt-cotas.qt-prevista then do:
                               {utp/ut-field.i mgdis cotas qt-pedida 1}   c-label = trim(return-value).
                            end.
                            if tt-cotas.qt-faturada > tt-cotas.qt-prevista then do:
                               {utp/ut-field.i mgdis cotas qt-faturada 1} c-label = trim(return-value).
                            end.                    
                        &ENDIF     
                   end. /* avail item-cota */

                   if tt-cotas.qt-ped-canc > tt-cotas.qt-prevista then do:
                      {utp/ut-field.i mgdis cotas qt-ped-canc 1} c-label = trim(return-value).
                   end.
                   if tt-cotas.qt-fat-canc > tt-cotas.qt-prevista then do:
                      {utp/ut-field.i mgdis cotas qt-fat-canc 1} c-label = trim(return-value).
                   end.
                   if tt-cotas.qt-ped-susp > tt-cotas.qt-prevista then do:
                      {utp/ut-field.i mgdis cotas qt-ped-susp 1} c-label = trim(return-value).
                   end.
                end. 

                if c-label <> "" then do:
                   create tt-erros-api.
                   assign tt-erros-api.label-campo-1 = c-label.
                   {utp/ut-field.i mgdis cotas qt-prevista 1}                    
                   assign tt-erros-api.label-campo-2 = trim(return-value).
                   run utp/ut-msgs.p ('msg', 16075, c-label + "~~" + return-value).
                   assign i-conta-msg   = i-conta-msg + 1.
                   {acp/acapi006.i1 "16075"}
                   next bloco-tt-cotas.
                end.             

             end. /*fim validaá∆o de valores e quantidades*/          


             /* atualizaá∆o base de cotas */
             /*diminui de base de cotas*/
             assign base-cota.qt-pedida = base-cota.qt-pedida - de-pedida.

             /*soma valor atual em base cotas*/
             if par-cota.tipo-controle = 2 /*valor*/ then do:
                assign base-cota.qt-pedida = base-cota.qt-pedida + tt-cotas.vl-pedido.      
                if tt-cotas.log-previsto-base then
                   assign base-cota.qt-prevista = base-cota.qt-prevista + tt-cotas.vl-previsto.
             end.
             else do: /*quantidade/pontos*/
                assign base-cota.qt-pedida = base-cota.qt-pedida + tt-cotas.qt-pedida.      
                if tt-cotas.log-previsto-base then
                   assign base-cota.qt-prevista = base-cota.qt-prevista + tt-cotas.qt-prevista.
             end.
          end.

          find cotas exclusive-lock where rowid(cotas) = rw-cotas no-error.

          assign cotas.cota-liberada   = tt-cotas.cota-liberada
                 cotas.dt-final        = tt-cotas.dt-final
                 cotas.pct-variacao    = tt-cotas.pct-variacao
                 cotas.qt-fat-canc     = tt-cotas.qt-fat-canc
                 cotas.qt-faturada     = tt-cotas.qt-faturada
                 cotas.qt-ped-canc     = tt-cotas.qt-ped-canc
                 cotas.qt-ped-susp     = tt-cotas.qt-ped-susp
                 cotas.qt-pedida       = tt-cotas.qt-pedida
                 cotas.qt-solicitado   = tt-cotas.qt-solicitado
                 cotas.vl-fat-canc     = tt-cotas.vl-fat-canc
                 cotas.vl-faturado     = tt-cotas.vl-faturado
                 cotas.vl-medio-prev   = tt-cotas.vl-medio-prev
                 cotas.vl-ped-canc     = tt-cotas.vl-ped-canc
                 cotas.vl-ped-susp     = tt-cotas.vl-ped-susp
                 cotas.vl-pedido       = tt-cotas.vl-pedido
                 cotas.vl-solicitado   = tt-cotas.vl-solicitado.

          &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
                 assign cotas.vl-ped-reprov   = tt-cotas.vl-ped-reprov 
                        cotas.qt-ped-reprov   = tt-cotas.qt-ped-reprov.    
          &ENDIF                      


          if par-cota.tipo-controle = 2 /*valor*/ then do:
             if tt-cotas.log-previsto-cota then
                 assign cotas.vl-previsto = tt-cotas.vl-previsto.
             if tt-cotas.log-original-cota then
                 assign cotas.vl-original = tt-cotas.vl-original.
          end.
          else do: /*quantidade/pontos*/
             if tt-cotas.log-previsto-cota then
                 assign cotas.qt-prevista = tt-cotas.qt-prevista.
             if tt-cotas.log-original-cota then
                 assign cotas.qt-original = tt-cotas.qt-original.
          end. 

       end. /*fim modificacao registro*/
    end. /* fim se modificacao */

    /******************** E X C L U S « O ******************************/   
    if tt-cotas.ind-tipo-movto = 3 then do: 

       /*** ParÉmetros de Cotas ***/
       find par-cota no-lock
            where par-cota.cod-estabel = tt-cotas.cod-estabel no-error.
       if not avail par-cota then do:
          create tt-erros-api.
         {utp/ut-table.i mgdis par-cota 1}
          assign tt-erros-api.label-campo-1 = trim(return-value).
          run utp/ut-msgs.p (input "msg",
                             input 2,
                             input return-value).
          assign i-conta-msg   = i-conta-msg + 1.

          {acp/acapi006.i1 "2"}. 

         next bloco-tt-cotas .

       end.

       find first cotas exclusive-lock where
                  cotas.cod-estabel     = tt-cotas.cod-estabel     and
                  cotas.cod-canal-venda = tt-cotas.cod-canal-venda and
                  cotas.cod-gr-cli      = tt-cotas.cod-gr-cli      and
                  cotas.nome-abrev      = tt-cotas.nome-abrev      and
                  cotas.nome-ab-reg     = tt-cotas.nome-ab-reg     and
                  cotas.nome-mic-reg    = tt-cotas.nome-mic-reg    and
                  cotas.cod-rep         = tt-cotas.cod-rep         and  
                  cotas.cd-produto      = tt-cotas.cd-produto      and  
                  cotas.dt-inicial      = tt-cotas.dt-inicial no-error.

       if not avail cotas then do:
           /* tentou excluir um registro que n∆o existia */ 
          create tt-erros-api.
          {utp/ut-table.i mgdis cotas 1}
          assign tt-erros-api.label-campo-1 = trim(return-value).
          run utp/ut-msgs.p ('msg', 56, return-value).
          assign i-conta-msg   = i-conta-msg + 1.

          {acp/acapi006.i1 "56"}. 

          next bloco-tt-cotas .
       end. /*if not avail cotas*/
       else do: /* exclusao do registro*/

          find base-cota exclusive-lock where
               base-cota.cod-estabel = cotas.cod-estabel and
               base-cota.cd-produto  = cotas.cd-produto  and
               base-cota.dt-inicial  = cotas.dt-inicial  no-error.
          if avail base-cota then
             if par-cota.tipo-controle = 2 /*valor*/ then
                assign base-cota.qt-pedida = base-cota.qt-pedida - cotas.vl-pedido.      
             else /*quantidade/pontos*/
                assign base-cota.qt-pedida = base-cota.qt-pedida - cotas.qt-pedida.      
          delete cotas.

       end. /*fim exclusao registro*/
    end. /* fim se exclusao */

end. /* for each tt-cotas */


/* caso tenha acontecido algum erro, retorna NOK. */
find first tt-erros-api no-lock no-error.
if avail tt-erros-api then
   return "NOK".
else
   return "OK".



/**************** PI DE VALIDAÄ«O DOS REGISTROS *************/   
procedure pi-validacao-chave.

      find first para-ped no-lock no-error.
      if substring(para-ped.char-2,1,3) = "yes" then do:
         /*** Estabelecimento padr∆o ***/
         if para-ped.estab-padrao <> tt-cotas.cod-estabel then do:
            create tt-erros-api.
            run utp/ut-msgs.p (input "msg",
                               input 17002,
                               input "").
            assign i-conta-msg   = i-conta-msg + 1
                   l-achou-erro  = yes.

            {acp/acapi006.i1 "17002"}         
         end.
      end.

      /*** Estabelecimento ***/
      find estabelec no-lock
           where estabelec.cod-estabel = tt-cotas.cod-estabel no-error.
      if not avail estabelec then do:
         create tt-erros-api. 
         {utp/ut-table.i mgadm estabelec 1}
         assign tt-erros-api.label-campo-1 = trim(return-value).
         run utp/ut-msgs.p (input "msg",
                            input 2,
                            input return-value).
         assign i-conta-msg   = i-conta-msg + 1
                l-achou-erro  = yes.

         {acp/acapi006.i1 "2"}         

      end.

      &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */

        /*** Canal de Venda ***/
        if par-cota.cont-canal-venda 
           and tt-cotas.cod-canal-venda <> ? 
        then do:
           find canal-venda no-lock
                where canal-venda.cod-canal-venda = tt-cotas.cod-canal-venda no-error.
           if not avail canal-venda then do:
              create tt-erros-api.
              {utp/ut-table.i mgdis canal-venda 1}
              assign tt-erros-api.label-campo-1 = trim(return-value).
              run utp/ut-msgs.p (input "msg",
                                 input 2,
                                 input return-value).
              assign i-conta-msg   = i-conta-msg + 1
                     l-achou-erro  = yes.
              {acp/acapi006.i1 "2"}

           end.
           else do:
               find first canal-venda no-lock where 
                          canal-venda.cod-canal-venda       = tt-cotas.cod-canal-venda and
                          canal-venda.dat-inic-ctrl-cotas  <= tt-cotas.dt-inicial      no-error.
               if not avail canal-venda then do:         
                  create tt-erros-api.
                  run utp/ut-msgs.p (input "msg",
                                     input 18643,
                                     input "").
                  assign i-conta-msg   = i-conta-msg + 1
                         l-achou-erro  = yes.
                  {acp/acapi006.i1 "18643"}
               end.
           end. 
        end.

      &ELSE

        /*** Canal de Venda ***/
        if par-cota.cont-canal-venda 
           and tt-cotas.cod-canal-venda <> ? 
        then do:
           find canal-venda no-lock
                where canal-venda.cod-canal-venda = tt-cotas.cod-canal-venda no-error.
           if not avail canal-venda then do:
              create tt-erros-api.
              {utp/ut-table.i mgdis canal-venda 1}
              assign tt-erros-api.label-campo-1 = trim(return-value).
              run utp/ut-msgs.p (input "msg",
                                 input 2,
                                 input return-value).
              assign i-conta-msg   = i-conta-msg + 1
                     l-achou-erro  = yes.
              {acp/acapi006.i1 "2"}

           end.
        end.

      &ENDIF     

      /*** Grupo de Cliente ***/
      if par-cota.cont-gr-cli 
      and tt-cotas.cod-gr-cli <> ? 
      then do:
          find gr-cli no-lock
               where gr-cli.cod-gr-cli = tt-cotas.cod-gr-cli no-error.
          if not avail gr-cli then do:
             create tt-erros-api.
             {utp/ut-table.i mgadm gr-cli 1}
             assign tt-erros-api.label-campo-1 = trim(return-value).
             run utp/ut-msgs.p (input "msg",
                                input 2,
                                input return-value).
             assign i-conta-msg   = i-conta-msg + 1
                    l-achou-erro  = yes.

             {acp/acapi006.i1 "2"}
          end.
      end.

      /*** Cliente ***/

      if par-cota.cont-cliente 
      and tt-cotas.nome-abrev <>  ? 
      then do:
          find emitente no-lock
               where emitente.nome-abrev = tt-cotas.nome-abrev no-error.
          if not avail emitente  then do:
             create tt-erros-api.
             {utp/ut-liter.i Cliente MAC c}
             assign tt-erros-api.label-campo-1 = trim(return-value).
             run utp/ut-msgs.p (input "msg",
                                input 2,
                                input return-value).
             assign i-conta-msg   = i-conta-msg + 1
                    l-achou-erro  = yes.

             {acp/acapi006.i1 "2"}            
          end.
      end.

      /*** Regi∆o ***/
      if par-cota.cont-ab-reg 
      and tt-cotas.nome-ab-reg <>  ? 
      then do:
          find regiao no-lock
               where regiao.nome-ab-reg = tt-cotas.nome-ab-reg no-error.
          if not avail regiao  then do:
             create tt-erros-api.
             {utp/ut-table.i mgadm regiao 1}
             assign tt-erros-api.label-campo-1 = trim(return-value).
             run utp/ut-msgs.p (input "msg",
                                input 2,
                                input return-value).
             assign i-conta-msg   = i-conta-msg + 1
                    l-achou-erro  = yes.

             {acp/acapi006.i1 "2"}
           end.
      end.

      /*** Microrregi∆o ***/
      if par-cota.cont-ab-reg 
      and par-cota.cont-mic-reg 
      and tt-cotas.nome-mic-reg <>  ? 
      then do:
          find micro-reg no-lock
               where micro-reg.nome-ab-reg  = tt-cotas.nome-ab-reg
               and   micro-reg.nome-mic-reg = tt-cotas.nome-mic-reg
               no-error.
          if not avail micro-reg then do:
             create tt-erros-api.
             run utp/ut-msgs.p (input "msg",
                                input 15757,
                                input "").
             assign i-conta-msg   = i-conta-msg + 1
                    l-achou-erro  = yes.

             {acp/acapi006.i1 "15757"}
          end.
      end.


      /* caso n∆o controla item, verifica se item padrao Ç diferente do item da tt-cotas*/
      if par-cota.cont-produto = no                        and
         tt-cotas.cd-produto  <> par-cota.it-codigo-padrao then do:
           create tt-erros-api.
           {utp/ut-field.i mgdis item-cota it-codigo 1}       c-texto[1] = return-value.
           assign tt-erros-api.label-campo-1 = trim(return-value).
           {utp/ut-field.i mgdis par-cota it-codigo-padrao 1} c-texto[2] = return-value.
           assign tt-erros-api.label-campo-2 = trim(return-value).
           run utp/ut-msgs.p ('msg', 5955, c-texto[1] + "~~" + c-texto[2]).
           assign i-conta-msg   = i-conta-msg + 1
                  l-achou-erro  = yes.

           {acp/acapi006.i1 "5955"}
      end.    

      /*** Produto/Item ***/
      if can-find(first item-cota no-lock
                      where item-cota.it-codigo = tt-cotas.cd-produto) then do:
          find item-cota where
               item-cota.it-codigo = tt-cotas.cd-produto no-lock no-error.
          if avail item-cota and
                   item-cota.log-produto = yes then do:
              &if defined (bf_dis_adm_cotas) &then /* INICIO PREPROCESSADOR */
                   if not can-find(first produto-coml no-lock where 
                                         produto-coml.cod-produto-coml = tt-cotas.cd-produto) then do: 
              &else
                   if not can-find(first produto no-lock where 
                                         produto.cd-produto = tt-cotas.cd-produto) then do:
              &endif 
                       create tt-erros-api.
                       {utp/ut-liter.i Produto MAC c}
                       assign tt-erros-api.label-campo-1 = trim(return-value).
                       run utp/ut-msgs.p (input "msg",
                                          input 17406,
                                          input return-value).
                       assign i-conta-msg   = i-conta-msg + 1
                              l-achou-erro  = yes.
                       {acp/acapi006.i1 "17406"}
                   end.
          end.
      end.
      else do:
          &if defined (bf_dis_adm_cotas) &then /* INICIO PREPROCESSADOR */
              if not can-find(first produto-coml no-lock where
                                    produto-coml.cod-produto-coml = tt-cotas.cd-produto) then do:
          &else
              if not can-find(first produto no-lock where
                                    produto.cd-produto = tt-cotas.cd-produto) then do:
          &endif
                  create tt-erros-api.
                  {utp/ut-field.i mgdis cotas cd-produto 1}
                  assign tt-erros-api.label-campo-1 = trim(return-value).
                  run utp/ut-msgs.p (input "msg",
                                     input 56,
                                     input return-value).
                  assign i-conta-msg   = i-conta-msg + 1
                         l-achou-erro  = yes.

                  {acp/acapi006.i1 "56"}
              end.
      end.

      &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */
        if par-cota.log-impl-niveis = yes then do:
          /*** Representante ***/
          if tt-cotas.cod-rep = 0 then do:
             create tt-erros-api.
             {utp/ut-field.i mgadm repres cod-rep 1}
             assign tt-erros-api.label-campo-1 = trim(return-value).
             run utp/ut-msgs.p (input "msg",
                                input 265,
                                input return-value).
             assign i-conta-msg   = i-conta-msg + 1
                    l-achou-erro  = yes.
             {acp/acapi006.i1 "265"}
          end.
          if tt-cotas.cod-rep <> ? then do:
             find repres no-lock
                  where repres.cod-rep = tt-cotas.cod-rep no-error.
             if not avail repres AND tt-cotas.cod-rep <> ? then do:
                create tt-erros-api. 
                {utp/ut-field.i mgadm repres cod-rep 1}
                assign tt-erros-api.label-campo-1 = trim(return-value).
                run utp/ut-msgs.p (input "msg",
                                   input 2,
                                   input return-value).
                assign i-conta-msg   = i-conta-msg + 1
                       l-achou-erro  = yes.
               {acp/acapi006.i1 "2"}
             end.
          end.
        end.  
        else do:
          /*** Representante ***/
          if tt-cotas.cod-rep = 0 then do:
             create tt-erros-api.
             {utp/ut-field.i mgadm repres cod-rep 1}
             assign tt-erros-api.label-campo-1 = trim(return-value).
             run utp/ut-msgs.p (input "msg",
                                input 265,
                                input return-value).
             assign i-conta-msg   = i-conta-msg + 1
                    l-achou-erro  = yes.
             {acp/acapi006.i1 "265"}
          end.

          find repres no-lock
               where repres.cod-rep = tt-cotas.cod-rep no-error.
          if not avail repres AND tt-cotas.cod-rep <> ? then do:
             create tt-erros-api. 
             {utp/ut-field.i mgadm repres cod-rep 1}
             assign tt-erros-api.label-campo-1 = trim(return-value).
             run utp/ut-msgs.p (input "msg",
                                input 2,
                                input return-value).
             assign i-conta-msg   = i-conta-msg + 1
                    l-achou-erro  = yes.
            {acp/acapi006.i1 "2"}
          end.
        end.
      &ELSE

        /*** Representante ***/
        if tt-cotas.cod-rep = 0 then do:
           create tt-erros-api.
           {utp/ut-field.i mgadm repres cod-rep 1}
           assign tt-erros-api.label-campo-1 = trim(return-value).
           run utp/ut-msgs.p (input "msg",
                              input 265,
                              input return-value).
           assign i-conta-msg   = i-conta-msg + 1
                  l-achou-erro  = yes.
           {acp/acapi006.i1 "265"}
        end.

        find repres no-lock
             where repres.cod-rep = tt-cotas.cod-rep no-error.
        if not avail repres AND tt-cotas.cod-rep <> ? then do:
           create tt-erros-api. 
           {utp/ut-field.i mgadm repres cod-rep 1}
           assign tt-erros-api.label-campo-1 = trim(return-value).
           run utp/ut-msgs.p (input "msg",
                              input 2,
                              input return-value).
           assign i-conta-msg   = i-conta-msg + 1
                  l-achou-erro  = yes.
          {acp/acapi006.i1 "2"}
        end.      

      &ENDIF

      run pi-valida-niveis. 

      /*** Data ***/
      if tt-cotas.dt-inicial = ? then do:
         create tt-erros-api. 
         run utp/ut-msgs.p (input "msg", input 16989, input "").
         assign i-conta-msg   = i-conta-msg + 1
                l-achou-erro  = yes.
        {acp/acapi006.i1 "16989"}
      end.
      if tt-cotas.dt-final = ? then do:
         create tt-erros-api. 
         run utp/ut-msgs.p (input "msg", input 16989, input "").
         assign i-conta-msg   = i-conta-msg + 1
                l-achou-erro  = yes.
        {acp/acapi006.i1 "16989"}
      end.
      if tt-cotas.dt-final < tt-cotas.dt-inicial then do:
         create tt-erros-api. 
         run utp/ut-msgs.p (input "msg", input 198, input "").
         assign i-conta-msg   = i-conta-msg + 1
                l-achou-erro  = yes.
        {acp/acapi006.i1 "16989"}
      end.


end procedure. /* fim procedure de validaá‰es */   



procedure pi-valida-niveis.
/* Nessa procedure Ç tratado a seguinte situaá∆o . Se rep estiver sendo informado ( <> ? ) , tudo acima
   dele deve ser <> ? . Se microrregi∆o estiver sendo informado, tudo acima deve ser <> de interroga , e
   assim por diante. Isso ser† tratado apenas na implantaá∆o por n°veis ( disp na release 2.03 ).
*/   
  &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */

     if par-cota.log-impl-niveis = yes then do:

        if   tt-cotas.cod-rep        <> ?    and
           ((par-cota.cont-canal-venda       and
             tt-cotas.cod-canal-venda = ?)   or
            (par-cota.cont-gr-cli            and
             tt-cotas.cod-gr-cli      = ?)   or
            (par-cota.cont-cliente           and 
             tt-cotas.nome-abrev      =  ?)   or
            (par-cota.cont-ab-reg            and             
             tt-cotas.nome-ab-reg     =  ?)   or
            (par-cota.cont-mic-reg           and 
             tt-cotas.nome-mic-reg    =  ?))  then do:

            create tt-erros-api. 
            {utp/ut-field.i movdis cotas cod-rep 1}
            assign tt-erros-api.label-campo-1 = trim(return-value).
            run utp/ut-msgs.p (input "msg", input 18640, input return-value).
            assign i-conta-msg   = i-conta-msg + 1
                   l-achou-erro  = yes.
           {acp/acapi006.i1 "18640"}
        end.

        if  (par-cota.cont-mic-reg           and
             tt-cotas.nome-mic-reg    <>  ?)  and
           ((par-cota.cont-canal-venda       and
             tt-cotas.cod-canal-venda = ?)   or
            (par-cota.cont-gr-cli            and
             tt-cotas.cod-gr-cli      = ?)   or
            (par-cota.cont-cliente           and 
             tt-cotas.nome-abrev      =  ?)   or
            (par-cota.cont-ab-reg            and             
             tt-cotas.nome-ab-reg     =  ?))  then do:          

            create tt-erros-api. 
            {utp/ut-field.i movdis cotas nome-mic-reg 1}
            assign tt-erros-api.label-campo-1 = trim(return-value).
            run utp/ut-msgs.p (input "msg", input 18640, input return-value).
            assign i-conta-msg   = i-conta-msg + 1
                   l-achou-erro  = yes.
           {acp/acapi006.i1 "18640"}
        end.

        if  (par-cota.cont-ab-reg            and  
             tt-cotas.nome-ab-reg     <>  ?)  and
           ((par-cota.cont-canal-venda       and
             tt-cotas.cod-canal-venda = ?)   or
            (par-cota.cont-gr-cli            and
             tt-cotas.cod-gr-cli      = ?)   or
            (par-cota.cont-cliente           and 
             tt-cotas.nome-abrev      =  ?))  then do:               

            create tt-erros-api. 
            {utp/ut-field.i movdis cotas nome-ab-reg 1}
            assign tt-erros-api.label-campo-1 = trim(return-value).
            run utp/ut-msgs.p (input "msg", input 18640, input return-value).
            assign i-conta-msg   = i-conta-msg + 1
                   l-achou-erro  = yes.
           {acp/acapi006.i1 "18640"}

        end.            

        if  (par-cota.cont-cliente           and 
             tt-cotas.nome-abrev     <>  ?)  and
           ((par-cota.cont-canal-venda       and
             tt-cotas.cod-canal-venda = ?)   or
            (par-cota.cont-gr-cli            and
             tt-cotas.cod-gr-cli      = ?))  then do:

            create tt-erros-api. 
            {utp/ut-field.i movdis cotas nome-abrev 1}
            assign tt-erros-api.label-campo-1 = trim(return-value).
            run utp/ut-msgs.p (input "msg", input 18640, input return-value).
            assign i-conta-msg   = i-conta-msg + 1
                   l-achou-erro  = yes.
           {acp/acapi006.i1 "18640"}

        end.

        if  (par-cota.cont-gr-cli            and  
             tt-cotas.cod-gr-cli     <> ?)   and
           ((par-cota.cont-canal-venda       and
             tt-cotas.cod-canal-venda = ?))  then do:
            create tt-erros-api. 

            {utp/ut-field.i movdis cotas cod-gr-cli 1}
            assign tt-erros-api.label-campo-1 = trim(return-value).
            run utp/ut-msgs.p (input "msg", input 18640, input return-value).
            assign i-conta-msg   = i-conta-msg + 1
                   l-achou-erro  = yes.
           {acp/acapi006.i1 "18640"}
        end.
     end.    

  &ENDIF                   

end procedure.



procedure pi-trata-rateio-pai.
/* Faz tratamento de limite de rateio. N∆o pode ultrapassar a 100% , considerando cada n°vel, quando 
   controlar n°veis ( release 2.03 ).
*/

&IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */

def var l-erro-base-cota    as log  no-undo.
def var l-utiliza-base-cota as log  no-undo.
def var c-cod-estabel       as char no-undo.
def var c-cd-produto        as char no-undo.
def var da-dt-inicial       as date no-undo.

def buffer b-cotas     for cotas.
def buffer b-base-cota for base-cota.


assign l-erro-base-cota    = no
       l-utiliza-base-cota = no
       de-valor-base       = 0
       c-cod-estabel       = tt-cotas.cod-estabel
       c-cd-produto        = tt-cotas.cd-produto
       da-dt-inicial       = tt-cotas.dt-inicial.

if par-cota.log-limita-rateio = yes and
   par-cota.log-impl-niveis   = yes  then do:              


    if  tt-cotas.cod-rep <> ? then do:
       {acp/ac9005.i &cond-base-cota=" par-cota.cont-canal-venda = no and
                       par-cota.cont-gr-cli = no and
                       par-cota.cont-cliente = no and
                       par-cota.cont-ab-reg = no and
                       par-cota.cont-mic-reg = no "
                      &cond-cotas=" where b-cotas.cod-estabel = tt-cotas.cod-estabel and
                       b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda and
                       b-cotas.cod-gr-cli = tt-cotas.cod-gr-cli and
                       b-cotas.nome-abrev = tt-cotas.nome-abrev and
                       b-cotas.nome-ab-reg = tt-cotas.nome-ab-reg and
                       b-cotas.nome-mic-reg = tt-cotas.nome-mic-reg and
                       b-cotas.cod-rep = ? and
                       b-cotas.cd-produto = tt-cotas.cd-produto and
                       b-cotas.dt-inicial = tt-cotas.dt-inicial "}.
    end.
    else do:
        if  tt-cotas.nome-mic-reg <>  ? and
            par-cota.cont-mic-reg then do:


            {acp/ac9005.i &cond-base-cota=" par-cota.cont-canal-venda = no and
                            par-cota.cont-gr-cli = no and
                            par-cota.cont-cliente = no and
                            par-cota.cont-ab-reg = no " 
                           &cond-cotas=" where b-cotas.cod-estabel = tt-cotas.cod-estabel and
                            b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda  and
                            b-cotas.cod-gr-cli = tt-cotas.cod-gr-cli and
                            b-cotas.nome-abrev = tt-cotas.nome-abrev and
                            b-cotas.nome-ab-reg = tt-cotas.nome-ab-reg and
                            b-cotas.nome-mic-reg = (if par-cota.cont-mic-reg then  ? else '') and
                            b-cotas.cod-rep = ? and
                            b-cotas.cd-produto = tt-cotas.cd-produto and
                            b-cotas.dt-inicial = tt-cotas.dt-inicial "}.
        end.
        else do:
            if  tt-cotas.nome-ab-reg <>  ? and
                par-cota.cont-ab-reg then do:

                {acp/ac9005.i &cond-base-cota=" par-cota.cont-canal-venda = no and
                                par-cota.cont-gr-cli = no and
                                par-cota.cont-cliente = no " 
                               &cond-cotas=" where b-cotas.cod-estabel = tt-cotas.cod-estabel and
                                b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda  and
                                b-cotas.cod-gr-cli = tt-cotas.cod-gr-cli and
                                b-cotas.nome-abrev = tt-cotas.nome-abrev and
                                b-cotas.nome-ab-reg = (if par-cota.cont-ab-reg then  ? else '') and
                                b-cotas.nome-mic-reg = (if par-cota.cont-mic-reg then  ? else '') and
                                b-cotas.cod-rep = ? and
                                b-cotas.cd-produto = tt-cotas.cd-produto and
                                b-cotas.dt-inicial = tt-cotas.dt-inicial "}.
            end.
            else do:
                if  tt-cotas.nome-abrev <>  ? and
                    par-cota.cont-cliente then do:

                    {acp/ac9005.i &cond-base-cota=" par-cota.cont-canal-venda = no and
                                    par-cota.cont-gr-cli = no " 
                                   &cond-cotas=" where b-cotas.cod-estabel = tt-cotas.cod-estabel and
                                    b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda  and
                                    b-cotas.cod-gr-cli = tt-cotas.cod-gr-cli and
                                    b-cotas.nome-abrev = (if par-cota.cont-cliente then  ? else '') and
                                    b-cotas.nome-ab-reg = (if par-cota.cont-ab-reg then  ? else '') and
                                    b-cotas.nome-mic-reg = (if par-cota.cont-mic-reg then  ? else '') and
                                    b-cotas.cod-rep = ? and
                                    b-cotas.cd-produto = tt-cotas.cd-produto and
                                    b-cotas.dt-inicial = tt-cotas.dt-inicial "}.
                end.
                else do:   
                    if  tt-cotas.cod-gr-cli <> ? and
                        par-cota.cont-gr-cli then do:

                        {acp/ac9005.i &cond-base-cota=" par-cota.cont-canal-venda = no "
                                       &cond-cotas=" where b-cotas.cod-estabel = tt-cotas.cod-estabel and
                                        b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda and
                                        b-cotas.cod-gr-cli = ? and
                                        b-cotas.nome-abrev = (if par-cota.cont-cliente then  ? else '') and
                                        b-cotas.nome-ab-reg = (if par-cota.cont-ab-reg then  ? else '') and
                                        b-cotas.nome-mic-reg = (if par-cota.cont-mic-reg then  ? else '') and
                                        b-cotas.cod-rep = ? and
                                        b-cotas.cd-produto = tt-cotas.cd-produto and
                                        b-cotas.dt-inicial = tt-cotas.dt-inicial "}.
                    end.
                    else do:
                        if  tt-cotas.cod-canal-venda <> ? and
                            par-cota.cont-canal-venda then do:
                            {acp/ac9005.i &cond-base-cota=" 1 = 1 "
                                           &cond-cotas=" "}. /* "1 = 1" foi o artif°cio utilizado para obrigar
                                                           a entrada no primeiro "if" */
                        end.
                    end.
                end.
            end.
        end.
    end.   

    /* Trata o erro de n∆o encontrar cota prevista */
    if l-erro-base-cota then do:
         create tt-erros-api. 
         run utp/ut-msgs.p (input "msg",
                            input 18654,
                            input "").
         assign i-conta-msg   = i-conta-msg + 1
                l-achou-erro  = yes.
         {acp/acapi006.i1 "18654"}      
    end.
    else  
        run pi-valida-rateio.

end. /* log-limita-rateio */

&ENDIF

end procedure.




procedure pi-valida-rateio :

&IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */

def var de-soma as dec no-undo.
def buffer b-cotas for cotas.

if par-cota.log-limita-rateio = yes then do:

   if par-cota.log-impl-niveis = yes then do:

        assign de-soma = 0.
        if tt-cotas.cod-rep <> ? then do: 
           for each b-cotas no-lock where 
                    b-cotas.cod-estabel     = tt-cotas.cod-estabel and
                    b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda and  
                    b-cotas.cod-gr-cli      = tt-cotas.cod-gr-cli and 
                    b-cotas.nome-abrev      = tt-cotas.nome-abrev and 
                    b-cotas.nome-ab-reg     = tt-cotas.nome-ab-reg and 
                    b-cotas.nome-mic-reg    = tt-cotas.nome-mic-reg and 
                    b-cotas.cod-rep        <> ? and 
                    b-cotas.cd-produto      = tt-cotas.cd-produto and 
                    b-cotas.dt-inicial      = tt-cotas.dt-inicial :
               if par-cota.tipo-controle = 2 then 
                  assign de-soma = de-soma + b-cotas.vl-previsto.
               else 
                  assign de-soma = de-soma + b-cotas.qt-prevista.
           end. /* for each */
        end. /* if input */
        else do:  
            if par-cota.cont-mic-reg      and
               tt-cotas.nome-mic-reg <>  ? then do:
               for each b-cotas no-lock where 
                        b-cotas.cod-estabel     = tt-cotas.cod-estabel and
                        b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda and  
                        b-cotas.cod-gr-cli      = tt-cotas.cod-gr-cli and 
                        b-cotas.nome-abrev      = tt-cotas.nome-abrev and 
                        b-cotas.nome-ab-reg     = tt-cotas.nome-ab-reg and                   
                        b-cotas.nome-mic-reg   <>  ? and 
                        b-cotas.cod-rep         = ? and 
                        b-cotas.cd-produto      = tt-cotas.cd-produto and 
                        b-cotas.dt-inicial      = tt-cotas.dt-inicial :
                   if par-cota.tipo-controle = 2 then 
                      assign de-soma = de-soma + b-cotas.vl-previsto.
                   else 
                      assign de-soma = de-soma + b-cotas.qt-prevista.

               end. /* for each */
            end. /* if par-cota */
            else do:    
                if par-cota.cont-ab-reg      and
                   tt-cotas.nome-ab-reg <>  ? then do:
                   for each b-cotas no-lock where 
                            b-cotas.cod-estabel     = tt-cotas.cod-estabel and 
                            b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda and  
                            b-cotas.cod-gr-cli      = tt-cotas.cod-gr-cli and 
                            b-cotas.nome-abrev      = tt-cotas.nome-abrev and 
                            b-cotas.nome-ab-reg    <>  ? and 
                            b-cotas.nome-mic-reg    = (if par-cota.cont-mic-reg then  ? else "") and 
                            b-cotas.cod-rep         = ? and 
                            b-cotas.cd-produto      = tt-cotas.cd-produto and 
                            b-cotas.dt-inicial      = tt-cotas.dt-inicial :
                       if par-cota.tipo-controle = 2 then 
                          assign de-soma = de-soma + b-cotas.vl-previsto.
                       else 
                          assign de-soma = de-soma + b-cotas.qt-prevista.

                   end. /* for each */
                end. /* if par-cota */        
                else do:
                    if par-cota.cont-cliente    and
                       tt-cotas.nome-abrev <>  ? then do:
                       for each b-cotas no-lock where 
                                b-cotas.cod-estabel     = tt-cotas.cod-estabel and 
                                b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda and  
                                b-cotas.cod-gr-cli      = tt-cotas.cod-gr-cli and                           
                                b-cotas.nome-abrev     <>  ?  and 
                                b-cotas.nome-ab-reg     = (if par-cota.cont-ab-reg then  ? else "")  and 
                                b-cotas.nome-mic-reg    = (if par-cota.cont-mic-reg then  ? else "") and 
                                b-cotas.cod-rep         = ?  and 
                                b-cotas.cd-produto      = tt-cotas.cd-produto and 
                                b-cotas.dt-inicial          = tt-cotas.dt-inicial :
                           if par-cota.tipo-controle = 2 then 
                              assign de-soma = de-soma + b-cotas.vl-previsto.
                           else 
                              assign de-soma = de-soma + b-cotas.qt-prevista.

                       end. /* for each */
                    end. /* if par-cota */        
                    else do:
                        if par-cota.cont-gr-cli     and
                           tt-cotas.cod-gr-cli <> ? then do:
                           for each b-cotas no-lock where 
                                    b-cotas.cod-estabel     = tt-cotas.cod-estabel and 
                                    b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda and  
                                    b-cotas.cod-gr-cli     <> ? and 
                                    b-cotas.nome-abrev      = (if par-cota.cont-cliente then  ? else "") and 
                                    b-cotas.nome-ab-reg     = (if par-cota.cont-ab-reg then  ? else "") and 
                                    b-cotas.nome-mic-reg    = (if par-cota.cont-mic-reg then  ? else "") and 
                                    b-cotas.cod-rep         = ? and 
                                    b-cotas.cd-produto      = tt-cotas.cd-produto and 
                                    b-cotas.dt-inicial      = tt-cotas.dt-inicial :

                               if par-cota.tipo-controle = 2 then 
                                  assign de-soma = de-soma + b-cotas.vl-previsto.
                               else 
                                  assign de-soma = de-soma + b-cotas.qt-prevista.

                           end. /* for each */
                        end. /* if par-cota */        
                        else do:
                            if par-cota.Cont-canal-venda           and
                               tt-cotas.cod-canal-venda <> ? then do:
                               for each b-cotas no-lock where 
                                        b-cotas.cod-estabel      = tt-cotas.cod-estabel and
                                        b-cotas.cod-canal-venda <> ? and  
                                        b-cotas.cod-gr-cli       = (if par-cota.cont-gr-cli then ? else 0) and 
                                        b-cotas.nome-abrev       = (if par-cota.cont-cliente then  ? else "") and 
                                        b-cotas.nome-ab-reg      = (if par-cota.cont-ab-reg then  ? else "") and 
                                        b-cotas.nome-mic-reg     = (if par-cota.cont-mic-reg then  ? else "") and 
                                        b-cotas.cod-rep          = ? and 
                                        b-cotas.cd-produto       = tt-cotas.cd-produto and 
                                        b-cotas.dt-inicial       = tt-cotas.dt-inicial :
                                   if par-cota.tipo-controle = 2 then 
                                      assign de-soma = de-soma + b-cotas.vl-previsto.
                                   else 
                                      assign de-soma = de-soma + b-cotas.qt-prevista.
                               end. /* for each */
                            end. /* if par-cota */                          
                        end.
                    end.
                end.             
            end.
        end.                 


        /** Cotas previstas n∆o podem ultrapassar a cota geral **/
        /* inclus∆o - soma o vlr previsto informado na tela */
        if tt-cotas.ind-tipo-movto = 1 then do:
           if par-cota.tipo-controle = 2 then do: /*valor*/
              if tt-cotas.vl-previsto + de-soma > de-valor-base then do:
                 create tt-erros-api. 
                 run utp/ut-msgs.p (input "msg",
                                    input 18655,
                                    input return-value).
                  assign i-conta-msg   = i-conta-msg + 1
                         l-achou-erro  = yes.
                 {acp/acapi006.i1 "18655"}        
              end.
           end.    
           else do:
              if tt-cotas.qt-prevista + de-soma > de-valor-base then do:
                 create tt-erros-api. 
                 run utp/ut-msgs.p (input "msg",
                                    input 18655,
                                    input return-value).
                  assign i-conta-msg   = i-conta-msg + 1
                         l-achou-erro  = yes.
                 {acp/acapi006.i1 "18655"}        
              end.
           end.            
        /* modificaá∆o - diminui o previsto do registro corrente */
        end.
        else do: 
           if par-cota.tipo-controle = 2 then do: /*valor*/
              if (tt-cotas.vl-previsto - de-prevista) +  de-soma > de-valor-base then do:
                 create tt-erros-api. 
                 run utp/ut-msgs.p (input "msg",
                                    input 18655,
                                    input return-value).
                  assign i-conta-msg   = i-conta-msg + 1
                         l-achou-erro  = yes.
                  {acp/acapi006.i1 "18655"}       
              end.    
           end.
           else do: /*quantidade*/
              if (tt-cotas.qt-prevista - de-prevista) +  de-soma > de-valor-base then do:
                 create tt-erros-api. 
                 run utp/ut-msgs.p (input "msg",
                                    input 18655,
                                    input return-value).
                  assign i-conta-msg   = i-conta-msg + 1
                         l-achou-erro  = yes.
                 {acp/acapi006.i1 "18655"}       
              end.               
           end.   
        end.
   end. /*log-impl-niveis*/
end.

&ENDIF  

end procedure.   



procedure pi-trata-rateio-filho.

&IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */

def buffer b-cotas for cotas.

assign de-valor-base = 0.

if par-cota.log-limita-rateio = yes and
   par-cota.log-impl-niveis   = yes  then do:              

    if  tt-cotas.cod-rep <> ? then do:
        /* N∆o testa quando Ç representante, pois nao tem nivel inferior */
    end.
    else do:  
        if  tt-cotas.nome-mic-reg <> ? and
            par-cota.cont-mic-reg then do:

            {acp/ac9006.i  &cond-cotas=" where b-cotas.cod-estabel = tt-cotas.cod-estabel and
                            b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda  and
                            b-cotas.cod-gr-cli = tt-cotas.cod-gr-cli and
                            b-cotas.nome-abrev = tt-cotas.nome-abrev and
                            b-cotas.nome-ab-reg = tt-cotas.nome-ab-reg and
                            b-cotas.nome-mic-reg = tt-cotas.nome-mic-reg and
                            b-cotas.cod-rep <> ? and
                            b-cotas.cd-produto = tt-cotas.cd-produto and
                            b-cotas.dt-inicial = tt-cotas.dt-inicial "}.
        end.
        else do: 
            if  tt-cotas.nome-ab-reg <> ? and
                par-cota.cont-ab-reg then do:
                if par-cota.cont-mic-reg then do: 

                   {acp/ac9006.i  &cond-cotas=" where b-cotas.cod-estabel = tt-cotas.cod-estabel and
                                   b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda  and
                                   b-cotas.cod-gr-cli = tt-cotas.cod-gr-cli and
                                   b-cotas.nome-abrev = tt-cotas.nome-abrev and
                                   b-cotas.nome-ab-reg = tt-cotas.nome-ab-reg and
                                   b-cotas.nome-mic-reg <> ? and
                                   b-cotas.cod-rep = ? and
                                   b-cotas.cd-produto = tt-cotas.cd-produto and
                                   b-cotas.dt-inicial = tt-cotas.dt-inicial "}.            
                end.
                else do:
                    {acp/ac9006.i  &cond-cotas=" where b-cotas.cod-estabel = tt-cotas.cod-estabel and
                                    b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda  and
                                    b-cotas.cod-gr-cli = tt-cotas.cod-gr-cli and
                                    b-cotas.nome-abrev = tt-cotas.nome-abrev and
                                    b-cotas.nome-ab-reg = tt-cotas.nome-ab-reg and
                                    b-cotas.nome-mic-reg = tt-cotas.nome-mic-reg and
                                    b-cotas.cod-rep <> ? and
                                    b-cotas.cd-produto = tt-cotas.cd-produto and
                                    b-cotas.dt-inicial = tt-cotas.dt-inicial "}.            
                end. 
            end.
            else do:
                if  tt-cotas.nome-abrev <>  ? and
                    par-cota.cont-cliente then do:
                    if par-cota.cont-ab-reg then do:
                        {acp/ac9006.i  &cond-cotas=" where b-cotas.cod-estabel = tt-cotas.cod-estabel and
                                        b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda  and
                                        b-cotas.cod-gr-cli = tt-cotas.cod-gr-cli and
                                        b-cotas.nome-abrev = tt-cotas.nome-abrev and
                                        b-cotas.nome-ab-reg <> ? and
                                        b-cotas.nome-mic-reg = ? and
                                        b-cotas.cod-rep = ? and
                                        b-cotas.cd-produto = tt-cotas.cd-produto and
                                        b-cotas.dt-inicial = tt-cotas.dt-inicial "}.            
                    end.
                    else do:
                        if par-cota.cont-mic-reg then do: 
                           {acp/ac9006.i  &cond-cotas=" where b-cotas.cod-estabel = tt-cotas.cod-estabel and
                                           b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda  and
                                           b-cotas.cod-gr-cli = tt-cotas.cod-gr-cli and
                                           b-cotas.nome-abrev = tt-cotas.nome-abrev and
                                           b-cotas.nome-ab-reg = tt-cotas.nome-ab-reg and
                                           b-cotas.nome-mic-reg <> ? and
                                           b-cotas.cod-rep = ? and
                                           b-cotas.cd-produto = tt-cotas.cd-produto and
                                           b-cotas.dt-inicial = tt-cotas.dt-inicial "}.            
                        end.                    
                        else do:
                            {acp/ac9006.i  &cond-cotas=" where b-cotas.cod-estabel = tt-cotas.cod-estabel and
                                            b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda  and
                                            b-cotas.cod-gr-cli = tt-cotas.cod-gr-cli and
                                            b-cotas.nome-abrev = tt-cotas.nome-abrev and
                                            b-cotas.nome-ab-reg = tt-cotas.nome-ab-reg and
                                            b-cotas.nome-mic-reg = tt-cotas.nome-mic-reg and
                                            b-cotas.cod-rep <> ? and
                                            b-cotas.cd-produto = tt-cotas.cd-produto and
                                            b-cotas.dt-inicial = tt-cotas.dt-inicial "}.            
                        end. 
                    end.
                end.
                else do:   
                    if  tt-cotas.cod-gr-cli <> ? and
                        par-cota.cont-gr-cli then do:
                        if par-cota.cont-cliente then do:
                                {acp/ac9006.i  &cond-cotas=" where b-cotas.cod-estabel = tt-cotas.cod-estabel and
                                                b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda  and
                                                b-cotas.cod-gr-cli = tt-cotas.cod-gr-cli and
                                                b-cotas.nome-abrev <> ? and
                                                b-cotas.nome-ab-reg = ? and
                                                b-cotas.nome-mic-reg = ? and
                                                b-cotas.cod-rep = ? and
                                                b-cotas.cd-produto = tt-cotas.cd-produto and
                                                b-cotas.dt-inicial = tt-cotas.dt-inicial "}.                            
                        end.
                        else do:
                            if par-cota.cont-ab-reg then do:
                                {acp/ac9006.i  &cond-cotas=" where b-cotas.cod-estabel = tt-cotas.cod-estabel and
                                                b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda  and
                                                b-cotas.cod-gr-cli = tt-cotas.cod-gr-cli and
                                                b-cotas.nome-abrev = tt-cotas.nome-abrev and
                                                b-cotas.nome-ab-reg <> ? and
                                                b-cotas.nome-mic-reg = ? and
                                                b-cotas.cod-rep = ? and
                                                b-cotas.cd-produto = tt-cotas.cd-produto and
                                                b-cotas.dt-inicial = tt-cotas.dt-inicial "}.            
                            end.
                            else do:
                                if par-cota.cont-mic-reg then do: 
                                   {acp/ac9006.i  &cond-cotas=" where b-cotas.cod-estabel = tt-cotas.cod-estabel and
                                                   b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda  and
                                                   b-cotas.cod-gr-cli = tt-cotas.cod-gr-cli and
                                                   b-cotas.nome-abrev = tt-cotas.nome-abrev and
                                                   b-cotas.nome-ab-reg = tt-cotas.nome-ab-reg and
                                                   b-cotas.nome-mic-reg <> ? and
                                                   b-cotas.cod-rep = ? and
                                                   b-cotas.cd-produto = tt-cotas.cd-produto and
                                                   b-cotas.dt-inicial = tt-cotas.dt-inicial "}.            
                                end.                    
                                else do:
                                    {acp/ac9006.i  &cond-cotas=" where b-cotas.cod-estabel = tt-cotas.cod-estabel and
                                                    b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda  and
                                                    b-cotas.cod-gr-cli = tt-cotas.cod-gr-cli and
                                                    b-cotas.nome-abrev = tt-cotas.nome-abrev and
                                                    b-cotas.nome-ab-reg = tt-cotas.nome-ab-reg and
                                                    b-cotas.nome-mic-reg = tt-cotas.nome-mic-reg and
                                                    b-cotas.cod-rep <> ? and
                                                    b-cotas.cd-produto = tt-cotas.cd-produto and
                                                    b-cotas.dt-inicial = tt-cotas.dt-inicial "}.            
                                end. 
                            end.
                        end. 
                    end.
                    else do:
                        if  tt-cotas.cod-canal-venda <> ? and
                            par-cota.cont-canal-venda then do:
                            if par-cota.cont-gr-cli then do:
                                {acp/ac9006.i  &cond-cotas=" where b-cotas.cod-estabel = tt-cotas.cod-estabel and
                                                b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda  and
                                                b-cotas.cod-gr-cli <> ? and
                                                b-cotas.nome-abrev = ? and
                                                b-cotas.nome-ab-reg = ? and
                                                b-cotas.nome-mic-reg = ? and
                                                b-cotas.cod-rep = ? and
                                                b-cotas.cd-produto = tt-cotas.cd-produto and
                                                b-cotas.dt-inicial = tt-cotas.dt-inicial "}.                                                  
                            end.
                            else do: 
                                if par-cota.cont-cliente then do:
                                        {acp/ac9006.i  &cond-cotas=" where b-cotas.cod-estabel = tt-cotas.cod-estabel and
                                                        b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda  and
                                                        b-cotas.cod-gr-cli = tt-cotas.cod-gr-cli and
                                                        b-cotas.nome-abrev <> ? and
                                                        b-cotas.nome-ab-reg = ? and
                                                        b-cotas.nome-mic-reg = ? and
                                                        b-cotas.cod-rep = ? and
                                                        b-cotas.cd-produto = tt-cotas.cd-produto and
                                                        b-cotas.dt-inicial = tt-cotas.dt-inicial "}.                            
                                end.
                                else do:
                                    if par-cota.cont-ab-reg then do:
                                        {acp/ac9006.i  &cond-cotas=" where b-cotas.cod-estabel = tt-cotas.cod-estabel and
                                                        b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda  and
                                                        b-cotas.cod-gr-cli = tt-cotas.cod-gr-cli and
                                                        b-cotas.nome-abrev = tt-cotas.nome-abrev and
                                                        b-cotas.nome-ab-reg <> ? and
                                                        b-cotas.nome-mic-reg = ? and
                                                        b-cotas.cod-rep = ? and
                                                        b-cotas.cd-produto = tt-cotas.cd-produto and
                                                        b-cotas.dt-inicial = tt-cotas.dt-inicial "}.            
                                    end.
                                    else do:
                                        if par-cota.cont-mic-reg then do: 
                                           {acp/ac9006.i  &cond-cotas=" where b-cotas.cod-estabel = tt-cotas.cod-estabel and
                                                           b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda  and
                                                           b-cotas.cod-gr-cli = tt-cotas.cod-gr-cli and
                                                           b-cotas.nome-abrev = tt-cotas.nome-abrev and
                                                           b-cotas.nome-ab-reg = tt-cotas.nome-ab-reg and
                                                           b-cotas.nome-mic-reg <> ? and
                                                           b-cotas.cod-rep = ? and
                                                           b-cotas.cd-produto = tt-cotas.cd-produto and
                                                           b-cotas.dt-inicial = tt-cotas.dt-inicial "}.            
                                        end.                    
                                        else do:
                                            {acp/ac9006.i  &cond-cotas=" where b-cotas.cod-estabel = tt-cotas.cod-estabel and
                                                            b-cotas.cod-canal-venda = tt-cotas.cod-canal-venda  and
                                                            b-cotas.cod-gr-cli = tt-cotas.cod-gr-cli and
                                                            b-cotas.nome-abrev = tt-cotas.nome-abrev and
                                                            b-cotas.nome-ab-reg = tt-cotas.nome-ab-reg and
                                                            b-cotas.nome-mic-reg = tt-cotas.nome-mic-reg and
                                                            b-cotas.cod-rep <> ? and
                                                            b-cotas.cd-produto = tt-cotas.cd-produto and
                                                            b-cotas.dt-inicial = tt-cotas.dt-inicial "}.            
                                        end. 
                                    end.
                                end.
                            end. 
                        end.
                    end.
                end.
            end.
        end.
    end.

    /** Cotas previstas n∆o podem ultrapassar a cota filha **/
    if par-cota.tipo-controle = 2 then do: /*valor*/
       if tt-cotas.vl-previsto < de-valor-base then do:
          create tt-erros-api. 
          run utp/ut-msgs.p (input "msg",
                             input 18706,
                             input return-value).
           assign i-conta-msg   = i-conta-msg + 1
                  l-achou-erro  = yes.
          {acp/acapi006.i1 "18706"}        
       end.
    end.    
    else do:
       if tt-cotas.qt-prevista < de-valor-base then do:
          create tt-erros-api. 
          run utp/ut-msgs.p (input "msg",
                             input 18706,
                             input return-value).
           assign i-conta-msg   = i-conta-msg + 1
                  l-achou-erro  = yes.
          {acp/acapi006.i1 "18706"}        
       end.
    end.            

end.

&ENDIF

end procedure.

/* acapi006.p */

