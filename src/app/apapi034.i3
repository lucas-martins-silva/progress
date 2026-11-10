/********************************************************************************
***
*** app/apapi001.i2 - Validacao das Notas a serem Substituidas.
***
********************************************************************************/

def var  c-tipo                       as char         no-undo.
def var  c-modalidade1                as char         no-undo.
def var  c-modalidade2                as char         no-undo.
def var  c-modalidade3                as char         no-undo.


def buffer b-tt-duplicatas            for tt-duplicatas.
def buffer b-emitente                 for emitente.


{utp/ut-liter.i Cb_Simples MAP L} 
assign c-modalidade1 = trim(return-value).
{utp/ut-liter.i Carteira MAP L} 
assign c-modalidade2 = trim(return-value).
{utp/ut-liter.i Cheque MAP L} 
assign c-modalidade3 = trim(return-value).


for each tt-duplicatas no-lock:

    /*---- Valida se duplicata j  existe -----*/
    find first tit-ap no-lock 
         where tit-ap.ep-codigo   = tt-duplicatas.tt-dup-ep-codigo
         and   tit-ap.cod-fornec  = tt-duplicatas.tt-dup-cod-fornec
         and   tit-ap.cod-estabel = tt-duplicatas.tt-dup-cod-estabel
         and   tit-ap.cod-esp     = tt-duplicatas.tt-dup-cod-esp         
         and   tit-ap.serie       = tt-duplicatas.tt-dup-serie
         and   tit-ap.nr-docto    = tt-duplicatas.tt-dup-nr-docto
         and   tit-ap.parcela     = tt-duplicatas.tt-dup-parcela                           
         no-error.
    if avail tit-ap then do:
       run utp/ut-msgs.p (Input "help", Input 819, input " ").
       create tt-erro.
       assign tt-erro.cd-erro  = 819
              tt-erro.mensagem = trim(return-value)                      + " " + 
                                 tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                 tt-duplicatas.tt-dup-cod-esp            + " " +
                                 tt-duplicatas.tt-dup-serie              + " " +
                                 tt-duplicatas.tt-dup-nr-docto           + " " +
                                 tt-duplicatas.tt-dup-parcela            + " " + 
                                 string(tt-duplicatas.tt-dup-cod-fornec).
       return "NOK":U.
    end.

    /*---- Valida Estabelecimento -----*/
    find first estabelec no-lock where estabelec.cod-estabel = tt-duplicatas.tt-dup-cod-estabel no-error.
    if  not avail estabelec then do:
       run utp/ut-msgs.p (Input "help", Input 13, input tt-duplicatas.tt-dup-cod-estabel).
       create tt-erro.
       assign tt-erro.cd-erro  = 13
              tt-erro.mensagem = trim(return-value)                      + " " + 
                                 tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                 tt-duplicatas.tt-dup-cod-esp            + " " +
                                 tt-duplicatas.tt-dup-serie              + " " +
                                 tt-duplicatas.tt-dup-nr-docto           + " " +
                                 tt-duplicatas.tt-dup-parcela            + " " + 
                                 string(tt-duplicatas.tt-dup-cod-fornec).
       return "NOK":U.
    end.

    /*----- Valida s‚rie do documento -----*/
    if  tt-duplicatas.tt-dup-serie <> "" then do:
        find serie no-lock
             where serie.serie = tt-duplicatas.tt-dup-serie no-error.
        if  not avail serie then do:
            run utp/ut-msgs.p (Input "msg", Input 1116, input tt-duplicatas.tt-dup-serie).
            create tt-erro.
            assign tt-erro.cd-erro  = 1116
                   tt-erro.mensagem = trim(return-value)                      + " " +  
                                      tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                      tt-duplicatas.tt-dup-cod-esp            + " " +
                                      tt-duplicatas.tt-dup-serie              + " " +
                                      tt-duplicatas.tt-dup-nr-docto           + " " +
                                      tt-duplicatas.tt-dup-parcela            + " " + 
                                      string(tt-duplicatas.tt-dup-cod-fornec).
            return "NOK":U.
        end.             
   end.

   /*---- Valida Esp‚cie de Documento ----*/
   find first espec-ap no-lock where espec-ap.cod-esp = tt-duplicatas.tt-dup-cod-esp no-error.
   if  tt-parametros.tt-tp-subst = 2 or tt-parametros.tt-tp-subst = 3 then do:
       if  not avail espec-ap then do:
           run utp/ut-msgs.p (Input "help", Input 276, input tt-duplicatas.tt-dup-cod-esp).
           create tt-erro.
           assign tt-erro.cd-erro  = 276
                   tt-erro.mensagem = trim(return-value)                      + " " +
                                      tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                      tt-duplicatas.tt-dup-cod-esp            + " " +
                                      tt-duplicatas.tt-dup-serie              + " " +
                                      tt-duplicatas.tt-dup-nr-docto           + " " +
                                      tt-duplicatas.tt-dup-parcela            + " " + 
                                      string(tt-duplicatas.tt-dup-cod-fornec).
           return "NOK":U.
       end.
       if  avail espec-ap and (espec-ap.tipo = 7 or espec-ap.tipo = 9) then do:
           assign c-tipo = {adinc/i01ad104.i 4 7}      .
           run utp/ut-msgs.p (input "help", input 144,
                              input c-tipo + "~~" + {adinc/i01ad104.i 4 9}).
           create tt-erro.
           assign tt-erro.cd-erro  = 144
                  tt-erro.mensagem = trim(return-value)                      + " " +
                                     tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                     tt-duplicatas.tt-dup-cod-esp            + " " +
                                     tt-duplicatas.tt-dup-serie              + " " +
                                     tt-duplicatas.tt-dup-nr-docto           + " " +
                                     tt-duplicatas.tt-dup-parcela            + " " + 
                                     string(tt-duplicatas.tt-dup-cod-fornec).
           return "NOK":U.
       end.
   end.         
   if tt-parametros.tt-tp-subst = 1 then do:
      if avail espec-ap and espec-ap.tipo <> 9 then do:
          assign c-tipo = {adinc/i01ad104.i 4 9}.
          run utp/ut-msgs.p (input "help",
                             input 144,
                             input c-tipo).
          create tt-erro.
          assign tt-erro.cd-erro  = 144
                 tt-erro.mensagem = trim(return-value)                      + " " +
                                    tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                    tt-duplicatas.tt-dup-cod-esp            + " " +
                                    tt-duplicatas.tt-dup-serie              + " " +
                                    tt-duplicatas.tt-dup-nr-docto           + " " +
                                    tt-duplicatas.tt-dup-parcela            + " " + 
                                    string(tt-duplicatas.tt-dup-cod-fornec).
          return "NOK":U.
      end.      
      if  not avail espec-ap then do:
          run utp/ut-msgs.p (input "help",
                             input 15,
                             input tt-duplicatas.tt-dup-cod-esp).
          create tt-erro.
          assign tt-erro.cd-erro  = 15
                 tt-erro.mensagem = trim(return-value)                      + " " +
                                    tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                    tt-duplicatas.tt-dup-cod-esp            + " " +
                                    tt-duplicatas.tt-dup-serie              + " " +
                                    tt-duplicatas.tt-dup-nr-docto           + " " +
                                    tt-duplicatas.tt-dup-parcela            + " " + 
                                    string(tt-duplicatas.tt-dup-cod-fornec).
          return "NOK":U.
      end.
   end.

   /* Todas as DP's tˆm que ser = contabiliza ou todas <> contabiliza conforme as NFïs */
   if  i-tipo-aux <> espec-ap.tipo and tt-parametros.tt-tp-subst <> 1 then do:
       run utp/ut-msgs.p (Input "help", Input 5800, Input "").
       create tt-erro.
       assign tt-erro.cd-erro  = 5800
              tt-erro.mensagem = trim(return-value)                      + " " +
                                 tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                 tt-duplicatas.tt-dup-cod-esp            + " " +
                                 tt-duplicatas.tt-dup-serie              + " " +
                                 tt-duplicatas.tt-dup-nr-docto           + " " +
                                 tt-duplicatas.tt-dup-parcela            + " " + 
                                 string(tt-duplicatas.tt-dup-cod-fornec).
       return "NOK":U.
   end.   

   if  l-contab-aux <> espec-ap.contabiliza then do:
       run utp/ut-msgs.p (Input "help", Input 2588, Input "").
       create tt-erro.
       assign tt-erro.cd-erro  = 2588
              tt-erro.mensagem = trim(return-value)                      + " " +
                                 tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                 tt-duplicatas.tt-dup-cod-esp            + " " +
                                 tt-duplicatas.tt-dup-serie              + " " +
                                 tt-duplicatas.tt-dup-nr-docto           + " " +
                                 tt-duplicatas.tt-dup-parcela            + " " + 
                                 string(tt-duplicatas.tt-dup-cod-fornec).
       return "NOK":U.
   end.

   /*---- Valida n£mero do documento/parcela -----*/
   if  tt-duplicatas.tt-dup-nr-docto = "" or tt-duplicatas.tt-dup-parcela = "" then do:
       run utp/ut-msgs.p (Input "help", Input 2642, Input "").
       create tt-erro.
       assign tt-erro.cd-erro  = 2642
              tt-erro.mensagem = trim(return-value)                      + " " +
                                 tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                 tt-duplicatas.tt-dup-cod-esp            + " " +
                                 tt-duplicatas.tt-dup-serie              + " " +
                                 tt-duplicatas.tt-dup-nr-docto           + " " +
                                 tt-duplicatas.tt-dup-parcela            + " " + 
                                 string(tt-duplicatas.tt-dup-cod-fornec).
       return "NOK":U.
   end.   

   /*---- Valida Fornecedor ----*/
   find first emitente no-lock
        where emitente.cod-emitente = tt-duplicatas.tt-dup-cod-fornec
        and   emitente.identific   <> 1 no-error.
   if  not avail emitente then do:
       run utp/ut-msgs.p (Input "help", Input 654, Input "").
       create tt-erro.
       assign tt-erro.cd-erro  = 654
              tt-erro.mensagem = trim(return-value)                      + " " +
                                 tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                 tt-duplicatas.tt-dup-cod-esp            + " " +
                                 tt-duplicatas.tt-dup-serie              + " " +
                                 tt-duplicatas.tt-dup-nr-docto           + " " +
                                 tt-duplicatas.tt-dup-parcela            + " " + 
                                 string(tt-duplicatas.tt-dup-cod-fornec).
       return "NOK":U.
   end.             
   else do:
      c-matriz = emitente.nome-matriz.
      if  espec-ap.tipo <> 8 /*Retencao*/
      and espec-ap.cod-esp <> param-ap.cod-esp-inss
      and tt-parametros.tt-tp-subst <> 3 then do: 
          /*--- Verifica se o cliente pertence a mesma matriz ----*/
          find first b-emitente no-lock
               where b-emitente.cod-emitente = i-emitente-aux
               and   b-emitente.identific   <> 1 no-error.                               

          if  c-matriz <> b-emitente.nome-matriz then do:
              run utp/ut-msgs.p (Input "help",
                                 Input 3035,
                                 Input string(i-emitente-aux) + "~~" + c-matriz).
              create tt-erro.
              assign tt-erro.cd-erro  = 3035
                     tt-erro.mensagem = trim(return-value)                      + " " +
                                        tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                        tt-duplicatas.tt-dup-cod-esp            + " " +
                                        tt-duplicatas.tt-dup-serie              + " " +
                                        tt-duplicatas.tt-dup-nr-docto           + " " +
                                        tt-duplicatas.tt-dup-parcela            + " " + 
                                        string(tt-duplicatas.tt-dup-cod-fornec).
              return "NOK":U.
          end.
      end.
   end.

   /*---- Verifica se o t¡tulo j  foi digitado ----*/
   find first b-tt-duplicatas no-lock
        where b-tt-duplicatas.tt-dup-ep-codigo    = tt-duplicatas.tt-dup-ep-codigo
        and   b-tt-duplicatas.tt-dup-cod-estabel  = tt-duplicatas.tt-dup-cod-estabel
        and   b-tt-duplicatas.tt-dup-cod-esp      = tt-duplicatas.tt-dup-cod-esp
        and   b-tt-duplicatas.tt-dup-serie        = tt-duplicatas.tt-dup-serie
        and   b-tt-duplicatas.tt-dup-nr-docto     = tt-duplicatas.tt-dup-nr-docto
        and   b-tt-duplicatas.tt-dup-parcela      = tt-duplicatas.tt-dup-parcela
        and   b-tt-duplicatas.tt-dup-cod-fornec   = tt-duplicatas.tt-dup-cod-fornec
        and   rowid(b-tt-duplicatas)             <> rowid(tt-duplicatas) no-error.

   if  avail b-tt-duplicatas then do:
       run utp/ut-msgs.p (Input "help",
                          Input 630,
                          Input string(tt-duplicatas.tt-dup-ep-codigo)          + "~~" +
                                tt-duplicatas.tt-dup-cod-estabel                + "~~" +
                                tt-duplicatas.tt-dup-cod-esp                    + "~~" +
                                tt-duplicatas.tt-dup-serie                      + "~~" +
                                tt-duplicatas.tt-dup-nr-docto                   + "~~" +
                                tt-duplicatas.tt-dup-parcela                    + "~~" +
                                string(tt-duplicatas.tt-dup-cod-fornec)).   
       create tt-erro.
       assign tt-erro.cd-erro  = 630
              tt-erro.mensagem = trim(return-value).      
       return "NOK":U.      
   end.   

   /*---- Verifica conta saldo do fornecedor ----*/
   find first conta-ap no-lock
        where conta-ap.ep-codigo   = tt-duplicatas.tt-dup-ep-codigo
        and   conta-ap.cod-estabel = tt-duplicatas.tt-dup-cod-estabel
        and   conta-ap.cod-esp     = tt-duplicatas.tt-dup-cod-esp
        and   conta-ap.cod-grupo   = emitente.cod-gr-forn no-error.

   if  not avail conta-ap then do:
       run utp/ut-msgs.p (Input "help",
                          Input 629,
                          Input string(emitente.cod-gr-forn)).
       create tt-erro.
       assign tt-erro.cd-erro  = 629
              tt-erro.mensagem = trim(return-value)                      + " " +
                                 tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                 tt-duplicatas.tt-dup-cod-esp            + " " +
                                 tt-duplicatas.tt-dup-serie              + " " +
                                 tt-duplicatas.tt-dup-nr-docto           + " " +
                                 tt-duplicatas.tt-dup-parcela            + " " + 
                                 string(tt-duplicatas.tt-dup-cod-fornec).
       return "NOK":U.
   end.             

   /*---- Data de vencimento deve ser informada ----*/
   if  tt-duplicatas.tt-dup-dt-vencimen = ? then do:
       run utp/ut-msgs.p (Input "help", Input 271, Input "").
       create tt-erro.
       assign tt-erro.cd-erro  = 271
              tt-erro.mensagem = trim(return-value)                      + " " +
                                 tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                 tt-duplicatas.tt-dup-cod-esp            + " " +
                                 tt-duplicatas.tt-dup-serie              + " " +
                                 tt-duplicatas.tt-dup-nr-docto           + " " +
                                 tt-duplicatas.tt-dup-parcela            + " " + 
                                 string(tt-duplicatas.tt-dup-cod-fornec).
       return "NOK":U.
   end.             
   /*---- Data de emissÆo deve ser informada ----*/
   if  tt-duplicatas.tt-dup-dt-emissao = ? then do:
       run utp/ut-msgs.p (Input "help", Input 2055, Input "").
       create tt-erro.
       assign tt-erro.cd-erro  = 2055
              tt-erro.mensagem = trim(return-value)                      + " " +
                                 tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                 tt-duplicatas.tt-dup-cod-esp            + " " +
                                 tt-duplicatas.tt-dup-serie              + " " +
                                 tt-duplicatas.tt-dup-nr-docto           + " " +
                                 tt-duplicatas.tt-dup-parcela            + " " + 
                                 string(tt-duplicatas.tt-dup-cod-fornec).
       return "NOK":U.
   end.        
   /*---- Data de vencimento menor que a data de emissÆo ----*/
   if  tt-duplicatas.tt-dup-dt-vencimen < tt-duplicatas.tt-dup-dt-emissao then do:
       run utp/ut-msgs.p (Input "help", Input 1031, Input "").
       create tt-erro.
       assign tt-erro.cd-erro  = 1031
              tt-erro.mensagem = trim(return-value)                      + " " +
                                 tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                 tt-duplicatas.tt-dup-cod-esp            + " " +
                                 tt-duplicatas.tt-dup-serie              + " " +
                                 tt-duplicatas.tt-dup-nr-docto           + " " +
                                 tt-duplicatas.tt-dup-parcela            + " " + 
                                 string(tt-duplicatas.tt-dup-cod-fornec).
       return "NOK":U.
   end.             
   /*---- Data de emissao maior que a data de substiui‡Æo ----*/
   if  tt-duplicatas.tt-dup-dt-emissao > tt-parametros.tt-da-transacao then do:
       run utp/ut-msgs.p (Input "help",
                          Input 3042,
                          Input string(tt-duplicatas.tt-dup-dt-emissao) + "~~" +
                                string(tt-parametros.tt-da-transacao)).
       create tt-erro.                         
       assign tt-erro.cd-erro  = 3042
              tt-erro.mensagem = trim(return-value)                      + " " +
                                 tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                 tt-duplicatas.tt-dup-cod-esp            + " " +
                                 tt-duplicatas.tt-dup-serie              + " " +
                                 tt-duplicatas.tt-dup-nr-docto           + " " +
                                 tt-duplicatas.tt-dup-parcela            + " " + 
                                 string(tt-duplicatas.tt-dup-cod-fornec).
       return "NOK":U.
   end.             
   /*---- Data de vencimento menor que a data de substiui‡Æo ----*/
   if  tt-duplicatas.tt-dup-dt-vencimen < tt-parametros.tt-da-transacao then do:
       run utp/ut-msgs.p (Input "help",
                          Input 2647,
                          Input string(tt-duplicatas.tt-dup-dt-vencimen) + "~~" +
                                string(tt-parametros.tt-da-transacao)).
       create tt-erro.                                 
       assign tt-erro.cd-erro  = 2647
              tt-erro.mensagem = trim(return-value)                      + " " +
                                 tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                 tt-duplicatas.tt-dup-cod-esp            + " " +
                                 tt-duplicatas.tt-dup-serie              + " " +
                                 tt-duplicatas.tt-dup-nr-docto           + " " +
                                 tt-duplicatas.tt-dup-parcela            + " " + 
                                 string(tt-duplicatas.tt-dup-cod-fornec).
       return "NOK":U.
   end.     

   /*--- Valor da duplicata deve ser maior que zero ---*/
   if  tt-duplicatas.tt-dup-vl-original = 0 then do:
       run utp/ut-msgs.p (Input "help", Input 1073, Input "").
       create tt-erro.
       assign tt-erro.cd-erro  = 1073
              tt-erro.mensagem = trim(return-value)                      + " " +
                                 tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                 tt-duplicatas.tt-dup-cod-esp            + " " +
                                 tt-duplicatas.tt-dup-serie              + " " +
                                 tt-duplicatas.tt-dup-nr-docto           + " " +
                                 tt-duplicatas.tt-dup-parcela            + " " + 
                                 string(tt-duplicatas.tt-dup-cod-fornec).
       return "NOK":U.
   end.                

   /*----- Valida Portador se <> 0 -------*/
   if  tt-duplicatas.tt-dup-cod-port <> 0 then do:         
       find portador no-lock
            where portador.ep-codigo    = tt-duplicatas.tt-dup-ep-codigo
            and   portador.cod-portador = tt-duplicatas.tt-dup-cod-port
            and   portador.modalidade   = tt-duplicatas.tt-dup-modalidade no-error.

        if  not avail portador then do:
            run utp/ut-msgs.p (input "help",
                               input 152,
                               input string(tt-duplicatas.tt-dup-cod-port)).
            create tt-erro.
            assign tt-erro.cd-erro  = 152
                   tt-erro.mensagem = trim(return-value)                      + " " +
                                      tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                      tt-duplicatas.tt-dup-cod-esp            + " " +
                                      tt-duplicatas.tt-dup-serie              + " " +
                                      tt-duplicatas.tt-dup-nr-docto           + " " +
                                      tt-duplicatas.tt-dup-parcela            + " " + 
                                      string(tt-duplicatas.tt-dup-cod-fornec).
            return "NOK":U.
        end.

        if  tt-duplicatas.tt-dup-modalidade <> 1
        and tt-duplicatas.tt-dup-modalidade <> 6
        and tt-duplicatas.tt-dup-modalidade <> 8 then do:              
            run utp/ut-msgs.p(input "help",
                              input 17769,
                              input c-modalidade1 + "~~" +
                                    c-modalidade2 + "~~" +
                                    c-modalidade3).

            create tt-erro.
            assign tt-erro.cd-erro  = 17769
                   tt-erro.mensagem = trim(return-value)                      + " " +
                                      tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                      tt-duplicatas.tt-dup-cod-esp            + " " +
                                      tt-duplicatas.tt-dup-serie              + " " +
                                      tt-duplicatas.tt-dup-nr-docto           + " " +
                                      tt-duplicatas.tt-dup-parcela            + " " + 
                                      string(tt-duplicatas.tt-dup-cod-fornec).
            return "NOK":U.
        end.
    end.

    /*---- Valida Tipo de Receita ----*/
    if  tt-duplicatas.tt-dup-tp-codigo = 0 then do:
        find first tipo-rec-desp no-lock 
             where tipo-rec-desp.tp-codigo = tt-duplicatas.tt-dup-tp-codigo no-error.
    end.
    else do:
        find first tipo-rec-desp no-lock
           where tipo-rec-desp.tp-codigo = tt-duplicatas.tt-dup-tp-codigo
             and tipo-rec-desp.tipo      = 2 no-error.
    end.
    if  not avail tipo-rec-desp then do:
        /* Tipo de despesa nÆo cadastrado */
        run utp/ut-msgs.p (input "help",
                           input 146,
                           input string(tt-duplicatas.tt-dup-tp-codigo)).
        create tt-erro.
        assign tt-erro.cd-erro  = 146
               tt-erro.mensagem = trim(return-value)                      + " " +
                                  tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                  tt-duplicatas.tt-dup-cod-esp            + " " +
                                  tt-duplicatas.tt-dup-serie              + " " +
                                  tt-duplicatas.tt-dup-nr-docto           + " " +
                                  tt-duplicatas.tt-dup-parcela            + " " + 
                                  string(tt-duplicatas.tt-dup-cod-fornec).
        return "NOK":U.
    end.    

   /*--- Valor da moeda ---*/
   find first moeda 
        where moeda.mo-codigo = tt-duplicatas.tt-dup-mo-codigo no-lock no-error.
   if  not avail moeda then do:
       run utp/ut-msgs.p (Input "help", Input 495, Input "").
       create tt-erro.
       assign tt-erro.cd-erro  = 495
              tt-erro.mensagem = trim(return-value)                      + " " +
                                 tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                 tt-duplicatas.tt-dup-cod-esp            + " " +
                                 tt-duplicatas.tt-dup-serie              + " " +
                                 tt-duplicatas.tt-dup-nr-docto           + " " +
                                 tt-duplicatas.tt-dup-parcela            + " " + 
                                 string(tt-duplicatas.tt-dup-cod-fornec).
       return "NOK":U.
   end.                

   /*--- Valor do hist¢rico padrÆo ---*/
   if  tt-duplicatas.tt-dup-i-hist-padrao <> 0 then do:
       find first hist-padrao 
            where hist-padrao.hp-codigo = tt-duplicatas.tt-dup-i-hist-padrao
            no-lock no-error.
       if   not avail hist-padrao then do:     
            run utp/ut-msgs.p (Input "help", Input 319, Input "").
            create tt-erro.
            assign tt-erro.cd-erro  = 319
                   tt-erro.mensagem = trim(return-value)                      + " " +
                                      tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                      tt-duplicatas.tt-dup-cod-esp            + " " +
                                      tt-duplicatas.tt-dup-serie              + " " +
                                      tt-duplicatas.tt-dup-nr-docto           + " " +
                                      tt-duplicatas.tt-dup-parcela            + " " + 
                                      string(tt-duplicatas.tt-dup-cod-fornec).
            return "NOK":U.
       end.     
   end.                


    /*---- Valida data de desconto do t¡tulo ----*/
    if  tt-duplicatas.tt-dup-dt-desconto <> ? then do:
        if  (tt-duplicatas.tt-dup-dt-desconto > tt-duplicatas.tt-dup-dt-vencimen
        or   tt-duplicatas.tt-dup-dt-desconto < tt-duplicatas.tt-dup-dt-emissao) then do:
             /* Data de desconto inv lida */
             run utp/ut-msgs.p (input "help",
                                input 311,
                                input " ").
            create tt-erro.
            assign tt-erro.cd-erro  = 311
                   tt-erro.mensagem = trim(return-value)                      + " " +
                                      tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                      tt-duplicatas.tt-dup-cod-esp            + " " +
                                      tt-duplicatas.tt-dup-serie              + " " +
                                      tt-duplicatas.tt-dup-nr-docto           + " " +
                                      tt-duplicatas.tt-dup-parcela            + " " + 
                                      string(tt-duplicatas.tt-dup-cod-fornec).
            return "NOK":U.                                
        end.
    end.            
    /*---- Valida data desconto sem valor desconto ----*/
    if  tt-duplicatas.tt-dup-dt-desconto <> ? 
    and tt-duplicatas.tt-dup-vl-desconto  = 0 then do:
        run utp/ut-msgs.p (input "help", input 313, input " ").
        create tt-erro.
        assign tt-erro.cd-erro  = 313
               tt-erro.mensagem = trim(return-value)                      + " " +
                                  tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                  tt-duplicatas.tt-dup-cod-esp            + " " +
                                  tt-duplicatas.tt-dup-serie              + " " +
                                  tt-duplicatas.tt-dup-nr-docto           + " " +
                                  tt-duplicatas.tt-dup-parcela            + " " + 
                                  string(tt-duplicatas.tt-dup-cod-fornec).
        return "NOK":U.                                
    end.        
    /*---- Valida valor desconto sem data desconto -----*/
    if  tt-duplicatas.tt-dup-dt-desconto = ? 
    and tt-duplicatas.tt-dup-vl-desconto <> 0 then do:
        run utp/ut-msgs.p (input "help", input 312, input " ").
        create tt-erro.
        assign tt-erro.cd-erro  = 312
               tt-erro.mensagem = trim(return-value)                      + " " +
                                  tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                  tt-duplicatas.tt-dup-cod-esp            + " " +
                                  tt-duplicatas.tt-dup-serie              + " " +
                                  tt-duplicatas.tt-dup-nr-docto           + " " +
                                  tt-duplicatas.tt-dup-parcela            + " " + 
                                  string(tt-duplicatas.tt-dup-cod-fornec).
        return "NOK":U.                                
    end.        
    /*---- Valida Valor do Desconto ----*/
    if  tt-duplicatas.tt-dup-vl-desconto >  tt-duplicatas.tt-dup-vl-original then do:
        run utp/ut-msgs.p (input "help", input 318, input " ").
        create tt-erro.
        assign tt-erro.cd-erro  = 318
               tt-erro.mensagem = trim(return-value)                      + " " +
                                  tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                  tt-duplicatas.tt-dup-cod-esp            + " " +
                                  tt-duplicatas.tt-dup-serie              + " " +
                                  tt-duplicatas.tt-dup-nr-docto           + " " +
                                  tt-duplicatas.tt-dup-parcela            + " " + 
                                  string(tt-duplicatas.tt-dup-cod-fornec).
        return "NOK":U.                                
    end.          

    /*--- Para pagamento centralizado, somente ser  permitido a substitui‡Æo
          de documentos do mesmo estabelecimento ---*/
    run cdp/cd0006b.p (input  "AP",
                       input  tt-duplicatas.tt-dup-ep-codigo,
                       output v-log-centr,
                       output v-log-estab-centr,
                       output v-cod-estab-centr).

    if  v-log-centr = yes then do:
        find first tt-notas where tt-notas.tt-cod-estabel <> tt-duplicatas.tt-dup-cod-estabel no-error.
        if  avail tt-notas then do:
            {utp/ut-liter.i Substitui‡äes}
            run utp/ut-msgs.p (input "help",
                               input 17030,
                               input trim(return-value)).
            create tt-erro.
            assign tt-erro.cd-erro  = 17030
                   tt-erro.mensagem = trim(return-value)                      + " " +
                                      tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                      tt-duplicatas.tt-dup-cod-esp            + " " +
                                      tt-duplicatas.tt-dup-serie              + " " +
                                      tt-duplicatas.tt-dup-nr-docto           + " " +
                                      tt-duplicatas.tt-dup-parcela            + " " + 
                                      string(tt-duplicatas.tt-dup-cod-fornec).
            return "NOK":U.                                
        end.
    end.

    /* Tratamento de decimais - Chile */
    assign l-rejeita-dec = no
           tt-duplicatas.tt-dup-vl-original = fn_vld_ajust_dec(tt-duplicatas.tt-dup-vl-original,tt-parametros.tt-mo-codigo)
           tt-duplicatas.tt-dup-vl-desconto = fn_vld_ajust_dec(tt-duplicatas.tt-dup-vl-desconto,tt-parametros.tt-mo-codigo).

    if  l-rejeita-dec then do:
        run utp/ut-msgs.p (input "help", input 18100, input " ").
        create tt-erro.
        assign tt-erro.cd-erro  = 18100
               tt-erro.mensagem = trim(return-value)                      + " " +
                                  tt-duplicatas.tt-dup-cod-estabel        + " " + 
                                  tt-duplicatas.tt-dup-cod-esp            + " " +
                                  tt-duplicatas.tt-dup-serie              + " " +
                                  tt-duplicatas.tt-dup-nr-docto           + " " +
                                  tt-duplicatas.tt-dup-parcela            + " " + 
                                  string(tt-duplicatas.tt-dup-cod-fornec).
        return "NOK":U.                                
    end.                                                          
    /* fim tratamento decimais - Chile */
end.
return "OK":U.

/* fim include */


















