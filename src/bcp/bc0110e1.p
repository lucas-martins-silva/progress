/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0110E1 2.00.00.011 } /*** "010011" 10/11/2023 10:02:24  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BC0110E1 MBC}
&ENDIF
/*------------------------------------------------------------------------
    File        : bc0110e1.p
    Purpose     : Adapater para API de entrada de documento do Magnus I.00

    Syntax      : run bc0110e1.p (tt-docum-est,tt-item-doc-est,tt-dupli-apagar,
                                  output tt-erro)
    
    Description : Recebe as temp-table do data collection e cria o documento 
                  de entrada.
    Author(s)   : Denis Roberto Eloterio
    Created     : Janeiro/2001
    Notes       : 
----------------------------------------------------------------------*/

{bcp/bccfgpro.i}
&IF '{&DCMagnus}'= 'YES'
&THEN
{cdp/cd0666.i}                                    
{bcp/bc0110e.i} /* temp-table tt-docum-est tt-item-doc-est tt-dupli-apagar */

DEF INPUT PARAM TABLE FOR tt-docum-est.
DEF INPUT PARAM TABLE FOR tt-item-doc-est.
DEF INPUT PARAM TABLE FOR tt-dupli-apagar.
DEF OUTPUT PARAM TABLE FOR tt-erro.

def temp-table tt-it-docum NO-UNDO
    field  num-pedido   like pedido-compr.num-pedido
    field  numero-ordem like ordem-compra.numero-ordem
    field  it-codigo    like ordem-compra.it-codigo
    field  cod-ref      like ordem-compra.cod-ref
    field  sequencia    like rat-ordem.sequencia
    field  quantidade   like prazo-compra.quantidade
    field  qtidade-forn like rat-ordem.qtidade-forn
    field  ct-codigo    like ordem-compra.ct-codigo
    field  sc-codigo    like ordem-compra.sc-codigo
    field  dep-almoxar  like ordem-compra.dep-almoxar
    field  qt-total-seq like prazo-compra.quantidade
    field  qt-total-for like prazo-compra.quantidade
    field  serie-docto  like docum-est.serie-docto
    field  cod-emitente like docum-est.cod-emitente
    field  nro-docto    like docum-est.nro-docto
    field  nat-operacao like docum-est.nat-operacao 
    field  parcela      like prazo-compra.parcela.

def buffer b-emitente for emitente.

DEF BUFFER b-tt-it-docum FOR tt-it-docum.

DEF TEMP-TABLE tt-item-doc-est-aux NO-UNDO LIKE item-doc-est.
DEF TEMP-TABLE tt-rat-ordem-aux NO-UNDO LIKE rat-ordem.

def var c-referencia             as char  format "x(10)"          no-undo.
def var i-cgc                    as dec   format "99999999999999".
def var c-observ                 as char  format "x(456)"         no-undo.
def var c-un                     like item.un                       no-undo.
def var c-class                  as char  format "9999.99.9999"   no-undo.
def var c-nat-operacao           like natur-oper.nat-operacao .
def var i-it-seq                 as int                             no-undo. 

def var i-ordem-ant              as integer.
def var i-contador               as integer                       no-undo.
def var de-indice                as decimal                       no-undo.

def var de-quantidade           like tt-item-doc-est.quantidade     no-undo.
def var de-qt-rateio            like tt-item-doc-est.quantidade     no-undo.
def var de-qt-ratfor            like tt-item-doc-est.quantidade     no-undo.
def var de-qt-total             like tt-item-doc-est.quantidade     no-undo.
def var de-qt-seq               like tt-item-doc-est.quantidade     no-undo.
def var de-qt-seq-for           like tt-item-doc-est.quantidade     no-undo.

def var de-base-ipi              as decimal                       no-undo.
def var de-base-icm              as decimal                       no-undo.
def var de-base-iss              as decimal                       no-undo.
def var de-icm-ntrib             as decimal                       no-undo.
def var de-icm-outras            as decimal                       no-undo.
def var de-iss-ntrib             as decimal                       no-undo.
def var de-iss-outras            as decimal                       no-undo.
def var de-ipi-ntrib             as decimal                       no-undo.
def var de-ipi-outras            as decimal                       no-undo.
def var de-valor-iss             as decimal                       no-undo.
def var de-valor-ipi             as decimal                       no-undo.
def var de-vl-subs               as decimal                       no-undo.
def var de-base-subs             as decimal                       no-undo.

def var de-tbase-ipi             as decimal                       no-undo.
def var de-tbase-iss             as decimal                       no-undo.
def var de-tbase-icm             as decimal                       no-undo.

def var de-ticm-ntrib            as decimal                       no-undo.
def var de-ticm-outras           as decimal                       no-undo.
def var de-tiss-ntrib            as decimal                       no-undo.
def var de-tiss-outras           as decimal                       no-undo.
def var de-tipi-ntrib            as decimal                       no-undo.
def var de-tipi-outras           as decimal                       no-undo.
def var de-tvalor-iss            as decimal                       no-undo.
def var de-tvalor-ipi            as decimal                       no-undo.
def var de-tvalor-icm            as decimal                       no-undo.
def var de-tvl-subs              as decimal                       no-undo.
def var de-tbase-subs            as decimal                       no-undo.
           
def var de-tpeso-liq      like item-doc-est.peso-liquido   no-undo.
def var de-tdespesas      like item-doc-est.despesas[1]    no-undo.
def var de-despesas       like item-doc-est.despesas[1]    no-undo.
def var de-tpreco-total   like item-doc-est.preco-total[1] no-undo.
def var de-preco-total    like item-doc-est.preco-total[1] no-undo.
def var de-tdesconto      like item-doc-est.desconto[1]    no-undo.
def var de-desconto       like item-doc-est.desconto[1]    no-undo.
def var de-tpreco-unit    like item-doc-est.preco-unit[1]  no-undo.
def var de-qtpreuni       like item-doc-est.preco-unit[1]  no-undo.

def var da-data1                 as date                          no-undo.
def var r-registro               as ROWID.
def var c-retorno                as char.
def var l-pais                   as logical.
def var l-seq-nova               as logical.
def var l-pedido                 as logical.
def var l-saldo                  as logical.
def var l-parcela                as logical.


find first param-global no-lock no-error.
find first param-estoq no-lock no-error.

leitura:

for each tt-docum-est:
    
    FIND emitente
         WHERE emitente.cod-emitente = tt-docum-est.cod-emitente
         NO-LOCK NO-ERROR.

    find estabelec
         where estabelec.cod-estabel = tt-docum-est.cod-estabel
         no-lock no-error.

    IF  NOT AVAIL estabelec THEN DO:
        {utp/ut-liter.i "Estabelecimento" * R}
        RUN pi-erro (13,"", "(" + TRIM(RETURN-VALUE) + ": " + tt-docum-est.cod-estabel + ")" ).

        RETURN "NOK".
    END.

    if  not avail emitente THEN DO:

        {utp/ut-liter.i "Emitente" * R}
        RUN pi-erro (3486,"", "(" + TRIM(RETURN-VALUE) + ": " + string(tt-docum-est.cod-emitente) + ")" ).

        RETURN "NOK".
    END.

    FIND FIRST  param-re where param-re.usuario = tt-docum-est.usuario
         no-lock no-error.

    if  not avail param-re then do:

        RUN pi-erro (6203,"",  "(" + TRIM(RETURN-VALUE) + ": " + tt-docum-est.usuario + ")" ).

        RETURN "NOK".
    end.

    find FIRST natur-oper where
         natur-oper.nat-operacao = tt-docum-est.nat-operacao no-lock
         no-error.

   if  not avail natur-oper then do:

         FIND natur-oper where
              natur-oper.nat-operacao = emitente.nat-operacao no-lock
              no-error.

         if  not avail natur-oper then do:
             {utp/ut-liter.i "Natureza Opera‡Æo" * R}
             RUN pi-erro (5220,"", "(" + TRIM(RETURN-VALUE) + ":" + string(tt-docum-est.nat-operacao) + ")" ).

             RETURN "NOK".
         end.

    end.

    ASSIGN c-nat-operacao = natur-oper.nat-operacao.       
    
    find FIRST docum-est where
         docum-est.serie-docto    =  tt-docum-est.serie-docto  and
         docum-est.nro-docto      =  tt-docum-est.nro-docto    and
         docum-est.cod-emitente   =  tt-docum-est.cod-emitente and
         docum-est.nat-operacao   =  c-nat-operacao
         NO-LOCK NO-ERROR .
    
    if  avail docum-est then do:

        
        {utp/ut-liter.i "Documento Entrada" * R}

        RUN pi-erro (1878,"", ( "(" + TRIM(RETURN-VALUE) + ":"
                                  + string(tt-docum-est.nro-docto)
                                  + " / "
                                  + string(tt-docum-est.serie-docto)
                                  + " / "
                                  + string(tt-docum-est.cod-emitente)
                                  + " / "
                                  + string(c-nat-operacao)
                                  + ")")  ).
        

        RETURN "NOK".
    end.
    
    for each tt-item-doc-est where tt-item-doc-est.serie-docto  = tt-docum-est.serie-docto
                               and tt-item-doc-est.nro-docto    = tt-docum-est.nro-docto
                               and tt-item-doc-est.cod-emitente = tt-docum-est.cod-emitente
                               and tt-item-doc-est.nat-operacao = tt-docum-est.nat-operacao:

        find first pedido-compr where
             pedido-compr.num-pedido = integer(tt-item-doc-est.num-pedido)
             no-lock no-error.

        find item-fornec
            where item-fornec.cod-emitente  = emitente.cod-emitente
            and   item-fornec.item-do-forn  = tt-item-doc-est.it-codigo
            no-lock no-error.

        if  avail item-fornec THEN
            assign tt-item-doc-est.it-codigo = item-fornec.it-codigo.

        if avail pedido-compr then do:

           assign l-pedido = yes.

           if  (    pedido-compr.situacao = "E"
                 or pedido-compr.situacao = "3") then do:


               RUN pi-erro (7169,"", "(" + string(tt-item-doc-est.num-pedido) + ")" ).

               RETURN "NOK".

           end.

           if  tt-item-doc-est.num-pedido <> 0 then do:

               find first ordem-compra where
                          ordem-compra.num-pedido = pedido-compr.num-pedido
                      and ordem-compra.it-codigo  = tt-item-doc-est.it-codigo
                      and (   ordem-compra.situacao   = "C"
                           or ordem-compra.situacao   = "2") no-lock no-error.

               /*2 confirm(C) nro(area internacion)*/


               if  not avail ordem-compra then do:   /*2 confirm(C)*/

                   {utp/ut-liter.i "Pedido Compra" * R}
                   RUN pi-erro (15239,"", "(" + TRIM(RETURN-VALUE) + ":" + string(tt-item-doc-est.num-pedido) + ")" ).

                   RETURN "NOK".
               end.
           end.
        end.
        else do:

            if  param-re.sem-pedido = NO then do:

                RUN pi-erro (6900,"", "(" + string(tt-docum-est.usuario) + ")" ).

                RETURN "NOK".

            end.

        end.


        find item where
             item.it-codigo = tt-item-doc-est.it-codigo no-lock no-error.

        if not avail item then do:
           {utp/ut-liter.i "Item" * R}
           RUN pi-erro (90,"", "(" + TRIM(RETURN-VALUE) + ":" + string(tt-item-doc-est.it-codigo) + ")" ).

           RETURN "NOK".

        end.

        assign de-indice = 1
               c-un      = "".

        if item.tipo-contr <> "D" then do:

           find item-fornec where
                item-fornec.it-codigo = tt-item-doc-est.it-codigo and
                item-fornec.cod-emite = tt-docum-est.cod-emitente
                no-lock no-error.

           if  available item-fornec then
               assign de-indice = 1 / ( item-fornec.fator-conver /
                                        exp(10,item-fornec.num-casa-dec))
                           c-un = item-fornec.unid-med-for.
        end.
        ELSE DO:

            find cotacao-item where
                 cotacao-item.numero-ordem = ordem-compra.numero-ordem
             and cotacao-item.cod-emitente = ordem-compra.cod-emitente
             and cotacao-item.data-cotacao = ordem-compra.data-cotacao
                 no-lock no-error.

            FIND FIRST prazo-compra use-index ordem
                 WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                 NO-LOCK NO-ERROR.

            if available cotacao-item
            then do:
               find tab-conv-un where
                    tab-conv-un.unid-med-for = cotacao-item.un
                and tab-conv-un.un           = prazo-compra.un
                    no-lock no-error.
               if available tab-conv-un then
                  assign de-indice = tab-conv-un.fator-conver /
                                     exp(10,tab-conv-un.num-casa-dec).
            end.

        END.

        assign de-quantidade  = tt-item-doc-est.quantidade * de-indice
               c-class        = string(tt-item-doc-est.class-fiscal).

        find classif-fisc where
             classif-fisc.class-fiscal = c-class no-lock no-error.

        IF  NOT AVAIL classif-fisc THEN DO:

            {utp/ut-liter.i "Classifica‡Æo Fiscal" * R}
            RUN pi-erro (6361,"", "(" + TRIM(RETURN-VALUE) + ":" + string(tt-item-doc-est.class-fiscal) + ")" ).

            RETURN "NOK".
        END.

        /*** rateio de ordem e criacao de docum para as ordens ***/

        if  avail pedido-compr then do:


             assign de-qt-rateio  = de-quantidade
                    de-qt-ratfor  = tt-item-doc-est.quantidade
                    i-ordem-ant   = 0.

            /** conversao para a quantidade da empresa a ser usada na conversao do preco unitario **/

            assign de-qtpreuni = tt-item-doc-est.quantidade / de-quantidade.

            find first familia where familia.fm-codigo = item.fm-codigo no-lock no-error.

            for each tt-it-docum:
                delete tt-it-docum.
            end.

            for each  ordem-compra
                where ordem-compra.num-pedido = int(tt-item-doc-est.num-pedido)
                and   ordem-compra.it-codigo  = tt-item-doc-est.it-codigo
                and   ordem-compra.situacao   = "C"
                no-lock,
                each  prazo-compra
                where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                and   prazo-compra.it-codigo    = ordem-compra.it-codigo
                and   prazo-compra.situacao     = "C"
                and   prazo-compra.quant-saldo  > 0
                no-lock
                break by prazo-compra.data-entrega
                      by prazo-compra.numero-ordem
                      by prazo-compra.parcela:


                if de-qt-rateio <= 0 then leave.

                create tt-it-docum.

                assign
                      l-seq-nova               = (if  prazo-compra.numero-ordem
                                                  <>  i-ordem-ant
                                                  then yes
                                                  else no)
                      i-ordem-ant              = (if  l-seq-nova
                                                  then prazo-compra.numero-ordem
                                                  else i-ordem-ant)
                      i-it-seq                 = (if  l-seq-nova
                                                  then i-it-seq + 10
                                                  else i-it-seq)
                      tt-it-docum.serie-docto  = tt-docum-est.serie
                      tt-it-docum.nro-docto    = tt-docum-est.nro-docto
                      tt-it-docum.cod-emitente = tt-docum-est.cod-emitente
                      tt-it-docum.nat-operacao = c-nat-operacao
                      tt-it-docum.sequencia    = i-it-seq
                      tt-it-docum.numero-ordem = prazo-compra.numero-ordem
                      tt-it-docum.num-pedido   = ordem-compra.num-pedido
                      tt-it-docum.parcela      = prazo-compra.parcela
                      tt-it-docum.ct-codigo    = ordem-compra.ct-codigo
                      tt-it-docum.sc-codigo    = ordem-compra.sc-codigo
                      tt-it-docum.dep-almoxar  = ordem-compra.dep-almoxar

                      tt-it-docum.quantidade   = if de-qt-rateio >=
                                                    prazo-compra.quant-saldo
                                                 then prazo-compra.quant-saldo
                                                 else de-qt-rateio

                      tt-it-docum.qtidade-forn = if de-qt-ratfor >=
                                                    prazo-compra.qtd-sal-forn
                                                 then prazo-compra.qtd-sal-forn
                                                 else de-qt-ratfor

                      de-qt-total              = de-qt-total + tt-it-docum.quantidade

                      de-qt-seq                = if l-seq-nova
                                                 then tt-it-docum.quantidade
                                                 else de-qt-seq + tt-it-docum.quantidade

                      de-qt-seq-for            = if l-seq-nova
                                                 then tt-it-docum.qtidade-forn
                                                 else de-qt-seq-for + tt-it-docum.qtidade-forn
                      de-qt-rateio             =  de-qt-rateio
                                                - tt-it-docum.quantidade /*prazo-compra.quant-saldo quantidade  ALTERADO ANTES QUAT-SALDO */
                      de-qt-ratfor             =  de-qt-ratfor
                                                - tt-it-docum.qtidade-forn. /*prazo-compra.qtd-do-forn. ALTERADO ANTES qtd-sal-forn*/

                      assign tt-it-docum.qt-total-seq = de-qt-seq
                             tt-it-docum.qt-total-for = de-qt-seq-for.
            end.

            /* A quantidade a maior fica para a ultima sequencia */

            for each tt-it-docum
                 break by tt-it-docum.sequencia:

                 if last(tt-it-docum.sequencia) then do:

                     if de-qt-rateio > 0 then
                         assign tt-it-docum.qt-total-seq = tt-it-docum.qt-total-seq + de-qt-rateio
                                             de-qt-total = de-qt-total + de-qt-rateio.

                     if de-qt-ratfor > 0 then
                         assign tt-it-docum.qt-total-for = tt-it-docum.qt-total-for + de-qt-ratfor.
                 end.
            end.

            /*** CRIA OS ITENS ***/
            for each  tt-it-docum
                break by tt-it-docum.sequencia:

                if  last-of(tt-it-docum.sequencia) then do:

                    create tt-item-doc-est-aux.

                    assign
                          tt-item-doc-est-aux.cod-emitente    =  tt-docum-est.cod-emitente
                          tt-item-doc-est-aux.nro-docto       =  tt-docum-est.nro-docto
                          tt-item-doc-est-aux.serie-docto     =  tt-docum-est.serie
                          tt-item-doc-est-aux.nat-operacao    =  c-nat-operacao
                          tt-item-doc-est-aux.it-codigo       =  tt-item-doc-est.it-codigo
                          tt-item-doc-est-aux.sequencia       =  tt-it-docum.sequencia

                          tt-item-doc-est-aux.num-pedido      =  pedido-compr.num-pedido
                          tt-item-doc-est-aux.numero-ordem    =  tt-it-docum.numero-ordem
                          tt-item-doc-est-aux.parcela         =  tt-it-docum.parcela

                          tt-item-doc-est-aux.ct-codigo       =  tt-it-docum.ct-codigo
                          tt-item-doc-est-aux.sc-codigo       =  tt-it-docum.sc-codigo

                          tt-item-doc-est-aux.cod-depos       =  if item.contr-qualid
                                                          then
                                                              estabelec.deposito-cq
                                                          else
                                                              tt-it-docum.dep-almoxar
                          tt-item-doc-est-aux.localiza        =  item.localizacao


                          tt-item-doc-est-aux.aliquota-ipi    =  tt-item-doc-est.aliquota-ipi
                          tt-item-doc-est-aux.cd-trib-icm     =  if  tt-item-doc-est.cd-trib-icm
                                                          <> ""
                                                          then
                                                              tt-item-doc-est.cd-trib-icm
                                                          else
                                                          if  tt-item-doc-est.aliquota-icm
                                                          <> 0
                                                          then "T"
                                                          else "I"
                          tt-item-doc-est-aux.cd-trib-ipi     =  if  tt-item-doc-est.cd-trib-ipi
                                                          <> ""
                                                          then
                                                              tt-item-doc-est.cd-trib-ipi
                                                          else
                                                          if  tt-item-doc-est.aliquota-icm
                                                          <> 0
                                                          then "T"
                                                          else "I"
                          tt-item-doc-est-aux.cd-trib-iss     =  if tt-item-doc-est.cd-trib-iss
                                                          <> ""
                                                          then
                                                              tt-item-doc-est.cd-trib-iss
                                                          else
                                                          if tt-item-doc-est.cd-trib-iss
                                                          <> ""
                                                          then "T"
                                                          else "I"
                          tt-item-doc-est-aux.class-fiscal    =  if avail classif-fisc then
                                                          classif-fisc.class-fiscal
                                                          else tt-item-doc-est.class-fiscal

                          tt-item-doc-est-aux.un              =  if c-un <> ""
                                                          then c-un
                                                          else tt-item-doc-est.un
                          tt-item-doc-est-aux.icm-complem[1]  =  tt-item-doc-est.icm-complem[1]
                          tt-item-doc-est-aux.aliquota-icm    =  tt-item-doc-est.aliquota-icm
                          tt-item-doc-est-aux.baixa-ce        =  yes.

                    assign
                      /**** RATEIO ****/
                          tt-item-doc-est-aux.peso-liquido    = {bcp/bc0110e.i1
                                                         "last(tt-it-docum.sequencia)"
                                                         "yes"
                                                         "tt-item-doc-est.peso-liquido"
                                                         "tt-item-doc-est.quantidade"
                                                         "tt-it-docum.qt-total-seq"
                                                         "de-tpeso-liq"
                                                         "4"}

                          tt-item-doc-est-aux.quantidade      =  tt-it-docum.qt-total-seq

                     
                          tt-item-doc-est-aux.base-ipi[1]     = {bcp/bc0110e.i1
                                                      "last(tt-it-docum.sequencia)"
                                                      "yes"
                                                      "tt-item-doc-est.base-ipi[1]"
                                                      "tt-item-doc-est.quantidade"
                                                      "tt-it-docum.qt-total-seq"
                                                      "de-tbase-ipi"
                                                      "2"}

                          tt-item-doc-est-aux.base-icm[1]     = {bcp/bc0110e.i1
                                                      "last(tt-it-docum.sequencia)"
                                                      "yes"
                                                      "tt-item-doc-est.base-icm[1]"
                                                      "tt-item-doc-est.quantidade"
                                                      "tt-it-docum.qt-total-seq"
                                                      "de-tbase-icm"
                                                      "2"}

                          tt-item-doc-est-aux.base-iss[1]     = {bcp/bc0110e.i1
                                                      "last(tt-it-docum.sequencia)"
                                                      "yes"
                                                      "tt-item-doc-est.base-iss[1]"
                                                      "tt-item-doc-est.quantidade"
                                                      "tt-it-docum.qt-total-seq"
                                                      "de-tbase-iss"
                                                      "2"}

                          tt-item-doc-est-aux.despesas[1]     = {bcp/bc0110e.i1
                                                      "last(tt-it-docum.sequencia)"
                                                      "yes"
                                                      "tt-item-doc-est.despesas[1]"
                                                      "tt-item-doc-est.quantidade"
                                                      "tt-it-docum.qt-total-seq"
                                                      "de-tdespesas"
                                                      "2"}

                          tt-item-doc-est-aux.icm-ntrib[1]    = {bcp/bc0110e.i1
                                                      "last(tt-it-docum.sequencia)"
                                                      "yes"
                                                      "tt-item-doc-est.icm-ntrib[1]"
                                                      "tt-item-doc-est.quantidade"
                                                      "tt-it-docum.qt-total-seq"
                                                      "de-ticm-ntrib"
                                                      "2"}

                          tt-item-doc-est-aux.ipi-ntrib[1]    = {bcp/bc0110e.i1
                                                      "last(tt-it-docum.sequencia)"
                                                      "yes"
                                                      "tt-item-doc-est.ipi-ntrib[1]"
                                                      "tt-item-doc-est.quantidade"
                                                      "tt-it-docum.qt-total-seq"
                                                      "de-tipi-ntrib"
                                                      "2"}

                          tt-item-doc-est-aux.iss-ntrib[1]    = {bcp/bc0110e.i1
                                                      "last(tt-it-docum.sequencia)"
                                                      "yes"
                                                      "tt-item-doc-est.iss-ntrib[1]"
                                                      "tt-item-doc-est.quantidade"
                                                      "tt-it-docum.qt-total-seq"
                                                      "de-tiss-ntrib"
                                                      "2"}.

                    assign
                          tt-item-doc-est-aux.icm-outras[1]   = {bcp/bc0110e.i1
                                                      "last(tt-it-docum.sequencia)"
                                                      "yes"
                                                      "tt-item-doc-est.icm-outras[1]"
                                                      "tt-item-doc-est.quantidade"
                                                      "tt-it-docum.qt-total-seq"
                                                      "de-ticm-outras"
                                                      "2"}

                          tt-item-doc-est-aux.ipi-outras[1]   = {bcp/bc0110e.i1
                                                      "last(tt-it-docum.sequencia)"
                                                      "yes"
                                                      "tt-item-doc-est.ipi-outras[1]"
                                                      "tt-item-doc-est.quantidade"
                                                      "tt-it-docum.qt-total-seq"
                                                      "de-tipi-outras"
                                                      "2"}

                          tt-item-doc-est-aux.iss-outras[1]   = {bcp/bc0110e.i1
                                                      "last-of(tt-it-docum.sequencia)"
                                                      "yes"
                                                      "tt-item-doc-est.iss-outras[1]"
                                                      "tt-item-doc-est.quantidade"
                                                      "tt-it-docum.qt-total-seq"
                                                      "de-tiss-outras"
                                                      "2"}.

                    assign
                          tt-item-doc-est-aux.preco-unit[1]   =  (IF  tt-item-doc-est.preco-total[1] = 0
                                                                  THEN
                                                                      tt-item-doc-est.preco-unit[1]
                                                                  ELSE
                                                                      tt-item-doc-est.preco-total[1] 
                                                                     / (IF  de-qtpreuni = 0 THEN 1 ELSE de-qtpreuni) ).

                    assign
                          tt-item-doc-est-aux.desconto[1]     = {bcp/bc0110e.i1
                                                      "last(tt-it-docum.sequencia)"
                                                      "yes"
                                                      "tt-item-doc-est.desconto[1]"
                                                      "tt-item-doc-est.quantidade"
                                                      "tt-it-docum.qt-total-seq"
                                                      "de-tdesconto"
                                                      "2"}

                          tt-item-doc-est-aux.qt-do-forn      =  tt-it-docum.qt-total-for.


                    assign
                          tt-item-doc-est-aux.valor-ipi[1]     = {bcp/bc0110e.i1
                                                      "last(tt-it-docum.sequencia)"
                                                      "yes"
                                                      "tt-item-doc-est.valor-ipi[1]"
                                                      "tt-item-doc-est.quantidade"
                                                      "tt-it-docum.qt-total-seq"
                                                      "de-tvalor-ipi"
                                                      "2"}

                          tt-item-doc-est-aux.valor-icm[1]     = {bcp/bc0110e.i1
                                                      "last(tt-it-docum.sequencia)"
                                                      "yes"
                                                      "tt-item-doc-est.valor-icm[1]"
                                                      "tt-item-doc-est.quantidade"
                                                      "tt-it-docum.qt-total-seq"
                                                      "de-tvalor-icm"
                                                      "2"}

                          tt-item-doc-est-aux.valor-iss[1]     = {bcp/bc0110e.i1
                                                      "last(tt-it-docum.sequencia)"
                                                      "yes"
                                                      "tt-item-doc-est.valor-iss[1]"
                                                      "tt-item-doc-est.quantidade"
                                                      "tt-it-docum.qt-total-seq"
                                                      "de-tvalor-iss"
                                                      "2"}                  

                          tt-item-doc-est-aux.preco-total[1]  = (IF  tt-item-doc-est-aux.preco-unit[1] = 0
                                                                 THEN
                                                                     tt-item-doc-est-aux.preco-total[1]
                                                                 ELSE
                                                                     (  tt-item-doc-est-aux.preco-unit[1]
                                                                      * tt-it-docum.qt-total-seq))


                          tt-item-doc-est-aux.vl-subs[1]     = {bcp/bc0110e.i1
                                                      "last(tt-it-docum.sequencia)"
                                                      "yes"
                                                      "tt-item-doc-est.vl-subs[1]"
                                                      "tt-item-doc-est.quantidade"
                                                      "tt-it-docum.qt-total-seq"
                                                      "de-tvl-subs"
                                                      "2"}

                           tt-item-doc-est-aux.base-subs[1]  = {bcp/bc0110e.i1
                                                      "last-of(tt-it-docum.sequencia)"
                                                      "yes"
                                                      "tt-item-doc-est.base-subs[1]"
                                                      "tt-item-doc-est.quantidade"
                                                      "tt-it-docum.qt-total-seq"
                                                      "de-tbase-subs"
                                                      "2"}.

                   /*** so cria rat-ordem se ja existe rat-ordem para aquela sequencia ***/
                    find first b-tt-it-docum
                             where b-tt-it-docum.sequencia = tt-it-docum.sequencia
                             and   ROWID(b-tt-it-docum) <> ROWID(tt-it-docum)
                             no-lock no-error.

                    if  avail b-tt-it-docum then do:
                        create tt-rat-ordem-aux.
                        assign
                              tt-rat-ordem-aux.serie-docto  = tt-docum-est.serie
                              tt-rat-ordem-aux.nro-docto    = tt-docum-est.nro-docto
                              tt-rat-ordem-aux.cod-emitente = tt-docum-est.cod-emitente
                              tt-rat-ordem-aux.nat-operacao = tt-it-docum.nat-operacao
                              tt-rat-ordem-aux.sequencia    = tt-it-docum.sequencia
                              tt-rat-ordem-aux.numero-ordem = tt-it-docum.numero-ordem
                              tt-rat-ordem-aux.num-pedido   = pedido-compr.num-pedido
                              tt-rat-ordem-aux.parcela      = tt-it-docum.parcela
                              tt-rat-ordem-aux.quantidade   = tt-it-docum.quantidade
                              tt-rat-ordem-aux.qtidade-forn = tt-it-docum.qtidade-for.
                    end.

                    assign
                           de-tbase-ipi   = de-tbase-ipi   + tt-item-doc-est-aux.base-ipi[1]
                           de-tbase-iss   = de-tbase-iss   + tt-item-doc-est-aux.base-iss[1]
                           de-tbase-icm   = de-tbase-icm   + tt-item-doc-est-aux.base-icm[1]
                           de-ticm-ntrib  = de-ticm-ntrib  + tt-item-doc-est-aux.icm-ntrib[1]
                           de-ticm-outras = de-ticm-outras + tt-item-doc-est-aux.icm-outras[1]
                           de-tiss-ntrib  = de-tiss-ntrib  + tt-item-doc-est-aux.iss-ntrib[1]
                           de-tiss-outras = de-tiss-outras + tt-item-doc-est-aux.iss-outras[1]
                           de-tipi-ntrib  = de-tipi-ntrib  + tt-item-doc-est-aux.ipi-ntrib[1]
                           de-tipi-outras = de-tipi-outras + tt-item-doc-est-aux.ipi-outras[1]
                           de-tvalor-iss  = de-tvalor-iss  + tt-item-doc-est-aux.valor-iss[1]
                           de-tvalor-ipi  = de-tvalor-ipi  + tt-item-doc-est-aux.valor-ipi[1]
                           de-tvalor-icm  = de-tvalor-icm  + tt-item-doc-est-aux.valor-icm[1]
                           de-tvl-subs    = de-tvl-subs    + tt-item-doc-est-aux.vl-subs[1]
                           de-tbase-subs  = de-tbase-subs  + tt-item-doc-est-aux.base-subs[1]

                           de-tpeso-liq   = de-tpeso-liq   + tt-item-doc-est-aux.peso-liquido
                           de-tdespesas   = de-tdespesas   + tt-item-doc-est-aux.despesas[1]
                           de-tpreco-total = de-tpreco-total + tt-item-doc-est-aux.preco-total[1]
                           de-tdesconto   = de-tdesconto   + tt-item-doc-est-aux.desconto[1]
                           de-tpreco-unit = de-tpreco-unit + tt-item-doc-est-aux.preco-unit[1]
                           de-tpreco-total = de-tpreco-total + tt-item-doc-est-aux.preco-total[1].
               end.
               else do:

                   create tt-rat-ordem-aux.
                   assign
                          tt-rat-ordem-aux.serie-docto  = tt-docum-est.serie
                          tt-rat-ordem-aux.nro-docto    = tt-docum-est.nro-docto
                          tt-rat-ordem-aux.cod-emitente = tt-docum-est.cod-emitente
                          tt-rat-ordem-aux.nat-operacao = tt-it-docum.nat-operacao
                          tt-rat-ordem-aux.sequencia    = tt-it-docum.sequencia
                          tt-rat-ordem-aux.numero-ordem = tt-it-docum.numero-ordem
                          tt-rat-ordem-aux.num-pedido   = pedido-compr.num-pedido
                          tt-rat-ordem-aux.parcela      = tt-it-docum.parcela
                          tt-rat-ordem-aux.quantidade   = tt-it-docum.quantidade
                          tt-rat-ordem-aux.qtidade-forn = tt-it-docum.qtidade-for.

               end.
            end.
        end.

        /******************* tratamento de itens sem pedidos de compras *************/

        else do:

             create tt-item-doc-est-aux.
             BUFFER-COPY tt-item-doc-est TO tt-item-doc-est-aux.
             assign
                   tt-item-doc-est-aux.cod-emitente    =  tt-docum-est.cod-emitente
                   tt-item-doc-est-aux.nro-docto       =  tt-docum-est.nro-docto
                   tt-item-doc-est-aux.serie-docto     =  tt-docum-est.serie
                   tt-item-doc-est-aux.nat-operacao    =  c-nat-operacao
                   tt-item-doc-est-aux.cd-trib-icm     =  (if tt-item-doc-est.cd-trib-icm <> "" then
                                                            tt-item-doc-est.cd-trib-icm
                                                            else
                                                            if tt-item-doc-est.aliquota-icm <> 0 then
                                                            "T" else "I")
                   tt-item-doc-est-aux.cd-trib-ipi     =  (if tt-item-doc-est.cd-trib-ipi <> "" then
                                                            tt-item-doc-est.cd-trib-ipi
                                                            else
                                                            if tt-item-doc-est.aliquota-icm <> 0 then
                                                            "T" else "I")
                   tt-item-doc-est-aux.cd-trib-iss     =  (if tt-item-doc-est.cd-trib-iss <> "" then
                                                            tt-item-doc-est.cd-trib-iss
                                                            else
                                                            if tt-item-doc-est.cd-trib-iss <> "" then
                                                            "T" else "I")
                   tt-item-doc-est-aux.class-fiscal    =  (if avail classif-fisc then
                                                              classif-fisc.class-fiscal
                                                           else tt-item-doc-est-aux.class-fiscal)
                   tt-item-doc-est-aux.it-codigo       =  tt-item-doc-est.it-codigo
                   tt-item-doc-est-aux.sequencia       =  (if  i-it-seq = 0 then
                                                               tt-item-doc-est.sequencia
                                                          else
                                                               i-it-seq + 10)
                   i-it-seq                            =  tt-item-doc-est-aux.sequencia

                   tt-item-doc-est-aux.peso-liquido    =  tt-item-doc-est.peso-liquido
                   tt-item-doc-est-aux.quantidade      =  tt-item-doc-est.quantidade
                   tt-item-doc-est-aux.un              =  (if c-un <> ""
                                                            then c-un
                                                            else tt-item-doc-est.un)

                   tt-item-doc-est-aux.base-ipi[1]     =  tt-item-doc-est.base-ipi[1]
                   tt-item-doc-est-aux.base-icm[1]     =  tt-item-doc-est.base-icm[1]
                   tt-item-doc-est-aux.base-iss[1]     =  tt-item-doc-est.base-iss[1]
                   tt-item-doc-est-aux.despesas[1]     =  tt-item-doc-est.despesas[1]
                   tt-item-doc-est-aux.ipi-ntrib[1]    =  tt-item-doc-est.ipi-ntrib[1]
                   tt-item-doc-est-aux.icm-ntrib[1]    =  tt-item-doc-est.icm-ntrib[1]
                   tt-item-doc-est-aux.iss-ntrib[1]    =  tt-item-doc-est.iss-ntrib[1]
                   tt-item-doc-est-aux.ipi-outras[1]   =  tt-item-doc-est.ipi-outras[1]
                   tt-item-doc-est-aux.icm-outras[1]   =  tt-item-doc-est.icm-outras[1]
                   tt-item-doc-est-aux.iss-outras[1]   =  tt-item-doc-est.iss-outras[1]

                   tt-item-doc-est-aux.preco-total[1]  =  (if tt-item-doc-est.preco-unit[1] <> 0
                                                           then
                                                               (tt-item-doc-est.preco-unit[1] *
                                                                tt-item-doc-est.quantidade)
                                                            else
                                                                tt-item-doc-est.preco-total[1])

                   tt-item-doc-est-aux.icm-complem[1]  =  tt-item-doc-est.icm-complem[1]

                   tt-item-doc-est-aux.cod-depos       =  (if item.contr-qualid then
                                                               estabelec.deposito-cq
                                                            else
                                                            item.deposito-pad).
             ASSIGN
                   tt-item-doc-est-aux.localiza        =  item.localizacao
                   tt-item-doc-est-aux.aliquota-ipi    =  tt-item-doc-est.aliquota-ipi
                   tt-item-doc-est-aux.aliquota-icm    =  tt-item-doc-est.aliquota-icm
                   tt-item-doc-est-aux.desconto[1]     =  tt-item-doc-est.desconto[1]
                   tt-item-doc-est-aux.num-pedido      =  (if avail pedido-compr then
                                                           pedido-compr.num-pedido
                                                            else tt-item-doc-est-aux.num-pedido)
                   tt-item-doc-est-aux.numero-ordem    =  (if avail ordem-compra then
                                                           ordem-compra.numero-ordem
                                                            else tt-item-doc-est-aux.numero-ordem)
                   tt-item-doc-est-aux.parcela         =  (if avail prazo-compra then
                                                           prazo-compra.parcela
                                                            else tt-item-doc-est-aux.parcela)
                   tt-item-doc-est-aux.qt-do-forn      =  tt-item-doc-est.quantidade
                   tt-item-doc-est-aux.ct-codigo       =  (if avail ordem-compra then
                                                           ordem-compra.ct-codigo
                                                            else item.ct-codigo)
                   tt-item-doc-est-aux.sc-codigo       =  (if avail ordem-compra then
                                                           ordem-compra.sc-codigo
                                                           else item.sc-codigo)
                   tt-item-doc-est-aux.valor-ipi[1]    =  tt-item-doc-est.valor-ipi[1]
                   tt-item-doc-est-aux.valor-icm[1]    =  tt-item-doc-est.valor-ipi[1]
                   tt-item-doc-est-aux.valor-iss[1]    =  tt-item-doc-est.valor-ipi[1] .

            ASSIGN 
                   tt-item-doc-est-aux.preco-unit[1]   =  (if tt-item-doc-est.preco-unit[1] <> 0
                                                           then
                                                               tt-item-doc-est.preco-unit[1]
                                                           else
                                                                 tt-item-doc-est.preco-total[1] 
                                                               / (IF tt-item-doc-est.quantidade = 0 THEN 1 ELSE tt-item-doc-est.quantidade))
                   tt-item-doc-est-aux.baixa-ce        =  tt-item-doc-est.baixa-ce
                   tt-item-doc-est-aux.vl-subs[1]      =  tt-item-doc-est.vl-subs[1]
                   tt-item-doc-est-aux.base-subs[1]    =  tt-item-doc-est.base-subs[1]
                   tt-item-doc-est-aux.despesas[1]     =  tt-item-doc-est.despesas[1].

             assign
                   de-tdesconto    = de-tdesconto    + tt-item-doc-est-aux.desconto[1]
                   de-tpreco-total = de-tpreco-total + tt-item-doc-est-aux.preco-total[1]
                   de-tdespesas    = de-tdespesas    + tt-item-doc-est-aux.despesas[1]
                   de-tbase-ipi   = de-tbase-ipi   + tt-item-doc-est-aux.base-ipi[1]
                   de-tbase-iss   = de-tbase-iss   + tt-item-doc-est-aux.base-iss[1]
                   de-tbase-icm   = de-tbase-icm   + tt-item-doc-est-aux.base-icm[1]
                   de-ticm-ntrib  = de-ticm-ntrib  + tt-item-doc-est-aux.icm-ntrib[1]
                   de-ticm-outras = de-ticm-outras + tt-item-doc-est-aux.icm-outras[1]
                   de-tiss-ntrib  = de-tiss-ntrib  + tt-item-doc-est-aux.iss-ntrib[1]
                   de-tiss-outras = de-tiss-outras + tt-item-doc-est-aux.iss-outras[1]
                   de-tipi-ntrib  = de-tipi-ntrib  + tt-item-doc-est-aux.ipi-ntrib[1]
                   de-tipi-outras = de-tipi-outras + tt-item-doc-est-aux.ipi-outras[1]
                   de-tvalor-iss  = de-tvalor-iss  + tt-item-doc-est-aux.valor-iss[1]
                   de-tvalor-ipi  = de-tvalor-ipi  + tt-item-doc-est-aux.valor-ipi[1]
                   de-tvl-subs    = de-tvl-subs    + tt-item-doc-est-aux.vl-subs[1]
                   de-tbase-subs  = de-tbase-subs  + tt-item-doc-est-aux.base-subs[1].
        end.

        assign de-base-ipi   = de-base-ipi   + de-tbase-ipi
               de-base-iss   = de-base-iss   + de-tbase-iss
               de-base-icm   = de-base-icm   + de-tbase-icm
               de-icm-ntrib  = de-icm-ntrib  + de-ticm-ntrib
               de-icm-outras = de-icm-outras + de-ticm-outras
               de-iss-ntrib  = de-iss-ntrib  + de-tiss-ntrib
               de-iss-outras = de-iss-outras + de-tiss-outras
               de-ipi-ntrib  = de-ipi-ntrib  + de-tipi-ntrib
               de-ipi-outras = de-ipi-outras + de-tipi-outras
               de-valor-iss  = de-valor-iss  + de-tvalor-iss
               de-valor-ipi  = de-valor-ipi  + de-tvalor-ipi
               de-vl-subs    = de-vl-subs    + de-tvl-subs
               de-base-subs  = de-base-subs  + de-tbase-subs
               de-desconto   = de-desconto   + de-tdesconto
               de-preco-total = de-preco-total + de-tpreco-total
               de-despesas   = de-despesas     + de-tdespesas

               de-tbase-ipi    = 0
               de-tbase-iss    = 0
               de-ticm-ntrib   = 0
               de-ticm-outras  = 0
               de-tiss-ntrib   = 0
               de-tiss-outras  = 0
               de-tipi-ntrib   = 0
               de-tipi-outras  = 0
               de-tvalor-iss   = 0
               de-tvalor-ipi   = 0
               de-tvl-subs     = 0
               de-tbase-subs   = 0
               de-tpeso-liq    = 0
               de-tdespesas    = 0
               de-tpreco-total = 0
               de-tdesconto    = 0
               de-tpreco-unit  = 0.

    end.  /* fim for each tt-item-doc-est */

    find first tt-item-doc-est-aux
         WHERE tt-item-doc-est-aux.nro-docto    = tt-docum-est.nro-docto
         AND   tt-item-doc-est-aux.serie-docto  = tt-docum-est.serie-docto
         AND   tt-item-doc-est-aux.cod-emitente = tt-docum-est.cod-emitente
         AND   tt-item-doc-est-aux.nat-operacao = c-nat-operacao
         NO-LOCK no-error.

    if  avail tt-item-doc-est-aux THEN DO:

        find docum-est where
             docum-est.serie-docto    =  tt-docum-est.serie-docto  and
             docum-est.nro-docto      =  tt-docum-est.nro-docto    and
             docum-est.cod-emitente   =  tt-docum-est.cod-emitente and
             docum-est.nat-operacao   =  c-nat-operacao
             NO-LOCK NO-ERROR.

        if  avail docum-est then do:
            {utp/ut-liter.i "Documento Entrada" * R}
            RUN pi-erro (1878,"", "(" + TRIM(RETURN-VALUE) + ":"
                          + string(tt-docum-est.nro-docto)
                          + " / "
                          + string(tt-docum-est.serie-docto)
                          + " / "
                          + string(tt-docum-est.cod-emitente)
                          + " / "
                          + string(c-nat-operacao)
                          + ")" ).
             RETURN "NOK".
        end.

        create docum-est.
        BUFFER-COPY tt-docum-est EXCEPT dt-atualiza TO docum-est.
        assign docum-est.esp-docto           =  "NFE"
               docum-est.nat-operacao        =  c-nat-operacao
               docum-est.pais-origem         = "re1001".

        assign docum-est.dt-venc-ipi         =  tt-docum-est.dt-emissao
               docum-est.dt-venc-icm         =  tt-docum-est.dt-emissao
               docum-est.dt-venc-iss         =  tt-docum-est.dt-emissao
               docum-est.dt-trans            =  today
               docum-est.base-icm            =  (IF  tt-docum-est.base-icm    = 0 THEN de-base-icm ELSE tt-docum-est.base-icm)
               docum-est.base-ipi            =  (IF  tt-docum-est.base-ipi    = 0 THEN de-base-ipi ELSE tt-docum-est.base-ipi)
               docum-est.base-iss            =  (IF  tt-docum-est.base-iss    = 0 THEN de-base-iss ELSE tt-docum-est.base-iss)
               docum-est.sc-transit          =  param-estoq.sc-tr-fornec
               docum-est.ct-transit          =  param-estoq.ct-tr-fornec
               docum-est.cod-estabel         =  estabelec.cod-estabel
               docum-est.uf                  =  emitente.estado.
               
         ASSIGN 
               docum-est.icm-nao-trib        =  (IF  tt-docum-est.icm-nao-trib = 0 THEN de-icm-ntrib ELSE tt-docum-est.icm-nao-trib)
               docum-est.icm-outras          =  (IF  tt-docum-est.icm-outras = 0 THEN de-icm-outras ELSE tt-docum-est.icm-outras)
               docum-est.iss-deb-cre         =  (IF  tt-docum-est.iss-deb-cre = 0 THEN de-valor-iss ELSE tt-docum-est.iss-deb-cre)
               docum-est.ipi-deb-cre         =  (IF  tt-docum-est.ipi-deb-cre = 0 THEN de-valor-ipi ELSE tt-docum-est.ipi-deb-cre)
               docum-est.ipi-nao-trib        =  (IF  tt-docum-est.ipi-nao-trib = 0 THEN de-ipi-ntrib ELSE tt-docum-est.ipi-nao-trib)
               docum-est.iss-nao-trib        =  (IF  tt-docum-est.iss-nao-trib = 0 THEN de-iss-ntrib ELSE tt-docum-est.iss-nao-trib)
               docum-est.ipi-outras          =  (IF  tt-docum-est.ipi-outras = 0 THEN de-ipi-outras ELSE tt-docum-est.ipi-outras)
               docum-est.iss-outras          =  (IF  tt-docum-est.iss-outras = 0 THEN de-iss-outras ELSE tt-docum-est.iss-outras)
               docum-est.estado-cq           =  (if  avail item
                                                 and item.contr-qualid
                                                 THEN 1
                                                 ELSE 0)
               
               docum-est.valor-embal         =  tt-docum-est.valor-embal
               docum-est.valor-frete         =  tt-docum-est.valor-frete
               docum-est.valor-seguro        =  tt-docum-est.valor-seguro               
               docum-est.usuario             =  param-re.usuario               
               docum-est.mod-frete           =  tt-docum-est.mod-frete
               docum-est.nff                 =  tt-docum-est.nff            
               docum-est.estab-fisc          =  estabelec.cod-estabel
               docum-est.vl-subs             =  (IF  tt-docum-est.vl-subs      = 0 THEN de-vl-subs   ELSE tt-docum-est.vl-subs)
               docum-est.base-subs           =  (IF  tt-docum-est.base-subs    = 0 THEN de-base-subs ELSE tt-docum-est.base-subs)
               docum-est.origem              =  "DC2"              
               docum-est.observacao          =  tt-docum-est.observacao              
               docum-est.tot-valor           =  (IF  tt-docum-est.tot-valor    = 0 THEN de-preco-total ELSE tt-docum-est.tot-valor)             
               docum-est.valor-mercad        =  tt-docum-est.valor-mercad             
               docum-est.tot-descont         =  (IF  tt-docum-est.tot-desconto = 0 THEN de-desconto    ELSE tt-docum-est.tot-desconto)
               docum-est.despesa             =  (IF  tt-docum-est.despesa      = 0 THEN de-despesas    ELSE tt-docum-est.despesa).


       /*********  Gerando Itens do Documento ************/
    
       FOR EACH tt-item-doc-est-aux:

           CREATE item-doc-est.
           BUFFER-COPY tt-item-doc-est-aux TO item-doc-est.

       END.

       /********   Gerando Rateio das Ordens dos Itens do Documento ********/

       FOR EACH tt-rat-ordem-aux:
          
           CREATE rat-ordem.
           BUFFER-COPY tt-rat-ordem-aux TO rat-ordem.

       END.

       /********* GERACAO DE DUPLICATA A PAGAR
                  GERACAO AUTOMATICA DO RE0302 **********/
       
       FOR EACH   tt-dupli-apagar
            WHERE tt-dupli-apagar.nro-docto    = tt-docum-est.nro-docto
            AND   tt-dupli-apagar.serie        = tt-docum-est.serie
            AND   tt-dupli-apagar.cod-emitente = tt-docum-est.cod-emitente
            AND   tt-dupli-apagar.nat-operacao = tt-docum-est.nat-operacao
            NO-LOCK:

            create dupli-apagar.
            
            BUFFER-COPY tt-dupli-apagar EXCEPT dt-trans TO dupli-apagar.

            assign
                  dupli-apagar.ep-codigo    = param-global.empresa-prin
                  dupli-apagar.cod-estabel  = docum-est.cod-estabel
                  dupli-apagar.cod-emitente = docum-est.cod-emitente
                  dupli-apagar.dt-emissao   = docum-est.dt-emissao
                  dupli-apagar.dt-trans     = docum-est.dt-trans
                  dupli-apagar.esp-movto    = no   /* debito  credito */
                  dupli-apagar.nat-operacao = docum-est.nat-operacao
                  dupli-apagar.nro-docto    = docum-est.nro-docto
                  dupli-apagar.serie-docto  = docum-est.serie-docto
                  dupli-apagar.tp-despesa   = emitente.tp-desp-padrao
                  dupli-apagar.cod-esp      = if docum-est.nff then
                                                 param-re.esp-def-nff
                                              else
                                                 param-re.esp-def-dup.
       END.
       
   END.
   
   FIND FIRST TT-ERRO NO-ERROR.

   IF AVAIL TT-ERRO
   THEN
       RETURN "NOK".

END.

PROCEDURE PI-ERRO:

DEF INPUT PARAM i-msg  AS INT.
DEF INPUT PARAM c-msg  AS CHAR.
DEF INPUT PARAM c-char AS CHAR.

run utp/ut-msgs.p (input "msg",input i-msg,input c-msg).


  create tt-erro.
  assign tt-erro.i-sequen = 0
         tt-erro.cd-erro  = i-msg
         tt-erro.mensagem = return-value + " " + (IF c-char = ? THEN "?" ELSE c-char).


END PROCEDURE.
&ENDIF
