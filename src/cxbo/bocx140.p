/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX140 2.00.00.066 } /*** "010066" 09/10/2023 10:56:43  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx140 MUT}
&ENDIF

/*******************************************************************************
**
**  BOCX140.P
**
**  processo-imp - Processo de Importacao
**
*******************************************************************************/

{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY processo-imp
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME processo-imp

{include/boini.i}

{cxbo/bocx140.i RowObject}

{cdp/cd4300.i3}  /* Include para desmembrar atributos livres */
{ccp/cc9019.i50} /* Include para atributos livres (cotacao-item). */
{utp/ut-glob.i}

&IF '{&mgdis_version}' >= '2.06f' &THEN
    def var h-bofn017 as handle no-undo.
    {fnbo/bofn017.i tt_usuar_mestre}
&ELSE
    def var h-boun178 as handle no-undo.
    {unbo/boun178.i tt_usuar_mestre}
&ENDIF


/* Licenciamento Importacao */
&if "{&bf_mat_versao_ems}" >= "2.062":U &then

{cxbo/bocx351.i tt-licenciam-import-oc}
define variable h-bocx351      as handle  no-undo.
define variable l-necessita-li as logical no-undo.

&endif

/* Temp-table para procedure atualizaSituacaoProcesso */
def temp-table tt-embarques NO-UNDO
    field embarque like embarque-imp.embarque
    index codigo is unique primary
        embarque.

define temp-table tt-idioma NO-UNDO
   field cod-idioma as char format "x(12)"
   index idioma cod-idioma.
   
define buffer b-decl-cliente for decl-cliente.   
DEFINE BUFFER b-pto-itiner FOR pto-itiner.

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

def var c-nr-proc-imp     as char    no-undo. 
def var c-idioma          as char    no-undo.
def var i-cod-emitente    as integer no-undo.
def var c-par             as char    no-undo.
def var c-par1            as char    no-undo.
def var c-par2            as char    no-undo.
def var da-emis           as date    no-undo.
def var i-qtd-dias        as integer no-undo.
def var de-unit           as decimal no-undo.
def var c-nr-proc-imp-fim as char    no-undo.
def var i-pos             as integer no-undo.
def var c-cod-idiom-usuar as char    no-undo.
def var l-eliminou-aux    as logical no-undo.
def var c-idiom-usuar     as char    no-undo.
def var c-param1          as char    no-undo.
def var l-pto-embarque    as logical no-undo.
def var l-pto-desembarque as logical no-undo.
def var l-pto-chegada     as logical no-undo.
def var l-erro            as logical no-undo.
def var l-parcela         as logical no-undo.
def var i-total-dias      as integer no-undo.
def var c-time            as char    no-undo.
def var i-seq-chegada     as integer no-undo.
    

/*FO: 1806.191*/
{utp/ut-glob.i}
/*FO: 1806.191*/

procedure setConstraint1:
end procedure.

procedure setConstraint2:
    def input parameter p-cod as char no-undo.

    assign c-nr-proc-imp = p-cod.
    
end procedure.

procedure setConstraint3:
    def input parameter pnr-proc-imp-ini as char no-undo.
    def input parameter pnr-proc-imp-fim as char no-undo.   
    assign c-nr-proc-imp = pnr-proc-imp-ini
           c-nr-proc-imp-fim = pnr-proc-imp-fim.
    
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
        when 2 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                                        where {&TABLE-NAME}.nr-proc-imp >= c-nr-proc-imp
                                        by    {&TABLE-NAME}.nr-proc-imp
                                        by    {&TABLE-NAME}.cod-estabel.   
        when 3 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                                        where {&TABLE-NAME}.nr-proc-imp >= c-nr-proc-imp and
                                              {&TABLE-NAME}.nr-proc-imp <= c-nr-proc-imp-fim
                                        by    {&TABLE-NAME}.nr-proc-imp
                                        by    {&TABLE-NAME}.cod-estabel.   
    end case.
    assign l-query    = true
           i-bo-query = i-abertura.
end procedure.
 
{include/bostrmet.i}
{include/boendmet.i}
{include/bocomver.i}
{include/bogetver.i}
{include/bonav.i}
{include/bofind.i}
{include/bosetcur.i}
{include/bogetcur.i}
{include/bosersen.i}
{include/boprebro.i}
/* {include/boexecre.i} */
/* {include/boexeupt.i} */
/* {include/boexedel.i} */
{include/bovalupt.i}
/* {include/bovaldel.i} */

procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
     
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.

procedure findCh_cod_estabel:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter c-cod-estabel as char no-undo.    
    def output parameter c-return as char no-undo.

    run startMethod ("find":U).    
 
    find processo-imp where
         processo-imp.cod-estabel = c-cod-estabel
         no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i mgcex {&TABLE-NAME} 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.                           
    end.
    else do:
       run setCurrent.
    end.
    run endMethod   ("find":U).    
end procedure. 

procedure findPedido:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter i-num-pedido as integer no-undo.    
    def output parameter c-return    as char no-undo.

    run startMethod ("find":U).
 
    find processo-imp 
        where processo-imp.num-pedido = i-num-pedido
         no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i mgcex {&TABLE-NAME} 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.
    end.
    else do:
       run setCurrent.
    end.
    run endMethod   ("find":U).    
end procedure.

procedure findPk_nr_processo:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter c-nr-proc-imp as char no-undo.
    def output parameter c-return as char no-undo.
     
    run startMethod ("find":U).
    find processo-imp where
        processo-imp.nr-proc-imp = c-nr-proc-imp
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i mgcex {&TABLE-NAME} 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.                           
    end.
    else do:
       run setCurrent.
    end.
    run endMethod   ("find":U).    
end procedure.
 
procedure findprocessoImp:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter c-cod-estabel as char no-undo.
    def input parameter c-nr-proc-imp as char no-undo.
    def output parameter c-return as char no-undo.
    
    run startMethod ("find":U).
         
    find processo-imp where processo-imp.nr-proc-imp = c-nr-proc-imp and
                            processo-imp.cod-estabel = c-cod-estabel
                            no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i mgcex {&TABLE-NAME} 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.                           
    end.
    else do:
        run setCurrent.
    end.
    run endMethod   ("find":U).    
end procedure.


procedure executeCreate:
    /*
    **  Cria registro na tabela.
    */ 
    create {&TABLE-NAME}.
    buffer-copy RowObject except r-rowid situacao to {&TABLE-NAME}.    
    assign {&table-name}.situacao = 1. /*situacao nao encerrada*/
    find param-imp where
         param-imp.cod-estabel = rowObject.cod-estabel no-lock no-error.
    if   avail param-imp then do:
         if    param-imp.hist-processo then do:
               /* Quando encontrar uma ordem de compra, a data final do 
                  hist¢rico do processo ser  a data de entrega da parcela.*/
               ASSIGN l-parcela = NO.
               FOR EACH ordem-compra NO-LOCK
                   WHERE ordem-compra.num-pedido = {&table-name}.num-pedido,
                   FIRST prazo-compra NO-LOCK
                   WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem:
                   ASSIGN da-emis = prazo-compra.data-entrega
                          l-parcela = YES.
                   LEAVE.
               END.
               /* Se ainda nÆo encontrar ordem de compra, a data final do 
                  hist¢rico do processo ser  a data de emissÆo mais a 
                  somat¢ria do n£mero de dias do itiner rio.            */
               IF l-parcela = NO THEN DO:
                  ASSIGN i-total-dias = 0.
                  FOR EACH pto-itiner WHERE  
                      pto-itiner.cod-itiner = {&table-name}.cod-itiner NO-LOCK:
                      ASSIGN i-total-dias = i-total-dias + pto-itiner.nr-dias.
                  END.
                  ASSIGN da-emis = {&table-name}.dt-emissao + i-total-dias.                        
               END.

               find itinerario where 
                    itinerario.cod-itiner = {&table-name}.cod-itiner no-lock no-error.
               if  avail itinerario then do:     

                    /* Licenciamento Importacao */
                    
                    assign l-necessita-li = no.
    
                    IF SUBSTRING(param-imp.char-1,167,1) = "S":U THEN  /* Solicita LI para todos os itens */ 
                        ASSIGN l-necessita-li = YES. 
                    ELSE
                        for each  ordem-compra fields (it-codigo)
                            where ordem-compra.num-pedido = processo-imp.num-pedido
                              and ordem-compra.situacao  <> 4 no-lock,
                            first item fields (log-necessita-li)
                            where item.it-codigo = ordem-compra.it-codigo
                              and item.log-necessita-li no-lock:
                            assign l-necessita-li = yes.
                            leave.
                        end.
                    
                    ASSIGN i-seq-chegada = 0.                                           
                    FOR FIRST pto-itiner NO-LOCK                                        
                        WHERE pto-itiner.cod-itiner    = itinerario.cod-itiner          
                          AND pto-itiner.cod-pto-contr = itinerario.pto-chegada:        
                        ASSIGN i-seq-chegada = pto-itiner.sequencia.                    
                    END.                                                                
                   
                    for each pto-itiner where 
                             pto-itiner.cod-itiner = itinerario.cod-itiner no-lock:

                        /* Licenciamento Importacao */
                        if  not l-necessita-li 
                            and pto-itiner.cod-pto-contr = itinerario.cdn-pto-solic-licenciam-import then next.
                        
                        create historico-proc-imp.
                        assign historico-proc-imp.nr-proc-imp     = {&TABLE-NAME}.nr-proc-imp
                               historico-proc-imp.cod-itiner      = {&TABLE-NAME}.cod-itiner
                               historico-proc-imp.cod-estabel     = {&TABLE-NAME}.cod-estabel
                               historico-proc-imp.sequencia       = pto-itiner.sequencia
                               historico-proc-imp.cod-pto-contr   = pto-itiner.cod-pto-contr.

                        
                        IF pto-itiner.sequencia < i-seq-chegada THEN DO:
                            ASSIGN i-qtd-dias = 0.
                            FOR EACH b-pto-itiner NO-LOCK
                                WHERE b-pto-itiner.cod-itiner  = itinerario.cod-itiner
                                  AND b-pto-itiner.sequencia   > pto-itiner.sequencia
                                  AND b-pto-itiner.sequencia  <= i-seq-chegada:
                                ASSIGN i-qtd-dias = i-qtd-dias + b-pto-itiner.nr-dias.
                            END.
                            ASSIGN historico-proc-imp.dt-previsao = da-emis - i-qtd-dias.
                        END.
    
                        IF pto-itiner.sequencia > i-seq-chegada THEN
                            ASSIGN historico-proc-imp.dt-previsao = da-emis + pto-itiner.nr-dias.
    
                        IF pto-itiner.sequencia = i-seq-chegada THEN
                            ASSIGN historico-proc-imp.dt-previsao = da-emis.
    
                        ASSIGN historico-proc-imp.dt-ult-previsao = historico-proc-imp.dt-previsao.
                        

                        if  pto-itiner.cod-pto-contr = itinerario.pto-chegada then do:
                            FOR EACH ordem-compra 
                               WHERE ordem-compra.num-pedido = {&table-name}.num-pedido NO-LOCK:
                              for each prazo-compra where 
                                       prazo-compra.numero-ordem = ordem-compra.numero-ordem EXCLUSIVE-LOCK:
                                   /* Re-planejamento das parcelas no MRP, conforme atividade 116178 */
                                   /*FO: 1806.191 Modifica‡äes para Criar a alt-ped*/
                                   if  historico-proc-imp.dt-ult-previsao <> prazo-compra.data-entrega then do:
                                           {cxbo/bocx140.i03 today                
                                            c-seg-usuario         
                                            ordem-compra.num-pedido    
                                            ordem-compra.numero-ordem  
                                            prazo-compra.parcela       
                                            prazo-compra.data-entrega  
                                            ?                          
                                            ?                          
                                            ordem-compra.cod-emitente
                                            ordem-compra.gera-edi
                                            ordem-compra.num-pedido 
                                            historico-proc-imp.dt-ult-previsao}
                                   END.
                                   assign prazo-compra.data-entrega = da-emis.
                                   /*Fim FO: 1806.191 Modifica‡äes para Criar a alt-ped*/
                                   &if defined(bf_mat_importacao_mrp) &then
                                       {cxbo/bocx140.i01}
                                   &endif
                               end.
                           end.           
                       end.     
                       
                       for each   tt-idioma NO-LOCK:
                           delete tt-idioma.
                       end.  
                       
                       for each decl-itiner where
                                decl-itiner.cod-itiner     = itinerario.cod-itiner and
                                decl-itiner.cod-pto-contr  = pto-itiner.cod-pto-contr
                                no-lock:
                            create decl-hist-proc-imp.
                            assign decl-hist-proc-imp.cod-estabel = {&table-name}.cod-estabel
                                   decl-hist-proc-imp.nr-proc-imp = {&table-name}.nr-proc-imp
                                   decl-hist-proc-imp.cod-itiner  = {&table-name}.cod-itiner
                                   decl-hist-proc-imp.sequencia   = pto-itiner.sequencia
                                   decl-hist-proc-imp.de-codigo   = decl-itiner.de-codigo
                                   decl-hist-proc-imp.int-1       = decl-itiner.emite-decl-docum
                                   decl-hist-proc-imp.int-2       = decl-itiner.dias-tolerancia.
                            if    decl-itiner.emite-emitente then do:
                                  find emitente where
                                       emitente.cod-emitente = {&table-name}.cod-exportador
                                       no-lock no-error.
                                  if   avail emitente then do:
                                       &if defined(bf-mat-comex) &then                                                                  
                                           find first cont-emit where
                                                      cont-emit.cod-emitente = {&table-name}.cod-exportador no-lock no-error.
                                           if avail cont-emit then 
                                               assign decl-hist-proc-imp.e-mail-emitente = cont-emit.e-mail.   
                                       &else
                                           assign decl-hist-proc-imp.e-mail-emitente = emitente.e-mail.
                                       &endif
                                       find   emitente-cex where
                                              emitente-cex.cod-emitente = emitente.cod-emitente
                                              no-lock no-error.
                                       if     avail emitente-cex then do:
                                              create tt-idioma.
                                              assign tt-idioma.cod-idioma = emitente-cex.cod-idioma.
                                       end.
                                       else do:       
                                            if  c-cod-idiom-usuar <> "" then do:
                                                create tt-idioma.
                                                assign tt-idioma.cod-idioma = c-cod-idiom-usuar.
                                            end.    
                                       end.
                                  end.
                            end.       
                            if    decl-itiner.emite-despachante then do:
                                  find emitente where
                                       emitente.cod-emitente = {&table-name}.cod-despachante
                                       no-lock no-error.
                                  if   avail emitente then do:
                                       &if defined(bf-mat-comex) &then                                                                  
                                           find first cont-emit where
                                                      cont-emit.cod-emitente = {&table-name}.cod-despachante no-lock no-error.
                                           if avail cont-emit then 
                                               assign decl-hist-proc-imp.e-mail-despachante = cont-emit.e-mail.   
                                       &else
                                           assign decl-hist-proc-imp.e-mail-despachante = emitente.e-mail.            
                                       &endif    
                                       find emitente-cex where 
                                            emitente-cex.cod-emitente = emitente.cod-emitente
                                            no-lock no-error.
                                       if   avail emitente-cex then do:
                                            find tt-idioma where  
                                                 tt-idioma.cod-idioma = emitente-cex.cod-idioma
                                                 NO-LOCK no-error.
                                            if   not avail tt-idioma then do:
                                                 create tt-idioma.
                                                 assign tt-idioma.cod-idioma = emitente-cex.cod-idioma.
                                            end.     
                                       end.     
                                  end.     
                            end.
                            if    decl-itiner.emite-agentecarga then do:
                                  find emitente where
                                       emitente.cod-emitente = {&table-name}.cod-agente
                                       no-lock no-error.
                                  if   avail emitente then do:
                                       &if defined(bf-mat-comex) &then                                                                  
                                           find first cont-emit where
                                                      cont-emit.cod-emitente = {&table-name}.cod-agente no-lock no-error.
                                           if avail cont-emit then 
                                               assign decl-hist-proc-imp.e-mail-agente = cont-emit.e-mail.   
                                       &else
                                           assign decl-hist-proc-imp.e-mail-agente = emitente.e-mail.            
                                       &endif
                                       find emitente-cex where
                                            emitente-cex.cod-emitente = emitente.cod-emitente
                                            no-lock no-error.
                                       if   avail emitente-cex then do:
                                            find tt-idioma where  
                                                 tt-idioma.cod-idioma = emitente-cex.cod-idioma
                                                 NO-LOCK no-error.
                                            if   not avail tt-idioma then do:
                                                 create tt-idioma.
                                                 assign tt-idioma.cod-idioma = emitente-cex.cod-idioma.
                                            end.                                        
                                       end.     
                                  end.     
                            end.
                            if    decl-itiner.emite-representante then do:
                                  find emitente-cex where
                                       emitente-cex.cod-emitente = {&table-name}.cod-exportador
                                       no-lock no-error.
                                  if   avail emitente-cex then do:
                                       find  repres where
                                             repres.cod-rep = emitente-cex.cod-repres
                                             no-lock no-error.
                                       if    avail repres then      
                                             &if defined(bf-mat-comex) &then                                                                       
                                                find first cont-emit where
                                                           cont-emit.cod-emitente = {&table-name}.cod-exportador no-lock no-error.
                                                if avail cont-emit then 
                                                    assign decl-hist-proc-imp.e-mail-repres = cont-emit.e-mail.   
                                                find tt-idioma 
                                                     where tt-idioma.cod-idioma = emitente-cex.cod-idioma no-error.
                                                 if not avail tt-idioma then do:
                                                     create tt-idioma.
                                                     assign tt-idioma.cod-idioma = emitente-cex.cod-idioma.
                                                 end.     
                                             &else
                                                 assign decl-hist-proc-imp.e-mail-repres = repres.e-mail.            
                                                 find tt-idioma 
                                                     where tt-idioma.cod-idioma = emitente-cex.cod-idioma no-error.
                                                 if not avail tt-idioma then do:
                                                     create tt-idioma.
                                                     assign tt-idioma.cod-idioma = emitente-cex.cod-idioma.
                                                 end.     
                                             &endif
                                  end.           
                            end.      
                            if    decl-itiner.emite-fabricante then do:
                                  find emitente where
                                       emitente.cod-emitente = {&table-name}.cod-fabricante
                                       no-lock no-error.
                                  if   avail emitente then do:
                                       &if defined(bf-mat-comex) &then                                                                  
                                           find first cont-emit where
                                                      cont-emit.cod-emitente = {&table-name}.cod-exportador no-lock no-error.
                                           if avail cont-emit then 
                                               assign decl-hist-proc-imp.e-mail-fabricante = cont-emit.e-mail.   
                                       &else
                                           assign decl-hist-proc-imp.e-mail-fabricante = emitente.e-mail.            
                                       &endif
                                       find emitente-cex where 
                                            emitente-cex.cod-emitente = emitente.cod-emitente
                                            no-lock no-error.
                                       if   avail emitente-cex then do:
                                            find tt-idioma where  
                                                 tt-idioma.cod-idioma = emitente-cex.cod-idioma
                                                 NO-LOCK no-error.
                                            if   not avail tt-idioma then do:
                                                 create tt-idioma.
                                                 assign tt-idioma.cod-idioma = emitente-cex.cod-idioma.
                                            end.     
                                       end.     
                                  end.                                       
                            end.     
                            if    decl-itiner.emite-outros then do:
                                  assign decl-hist-proc-imp.e-mail-outros = decl-itiner.destinatario-outros.    
                                  find tt-idioma where
                                       tt-idioma.cod-idioma = {&table-name}.cod-idioma
                                       no-error.
                                  if   not avail tt-idioma then do:          
                                       create tt-idioma.
                                       assign tt-idioma.cod-idioma = {&table-name}.cod-idioma.
                                  end.     
                            end.       
                            for  each tt-idioma:
                                 find decl-cliente where 
                                      decl-cliente.cod-emitente = {&table-name}.cod-exportador and
                                      decl-cliente.de-codigo    = decl-itiner.de-codigo        and
                                      decl-cliente.cod-idioma   = tt-idioma.cod-idioma         
                                      no-lock no-error.
                                 if  avail decl-cliente then do:
                                     assign i-pos                    = length(decl-cliente.texto).
                                     if   decl-hist-proc-imp.texto <> " " then 
                                          assign decl-hist-proc-imp.texto = decl-hist-proc-imp.texto + 
                                                                            chr(10) + chr(10) +
                                                                            trim(decl-cliente.texto).                
                                     else assign decl-hist-proc-imp.texto = trim(decl-cliente.texto).                                                                            
                                 end.
                                 else do:
                                      find decl-cliente where
                                           decl-cliente.cod-emitente = 0                     and
                                           decl-cliente.de-codigo    = decl-itiner.de-codigo and
                                           decl-cliente.cod-idioma   = tt-idioma.cod-idioma
                                           no-lock no-error.
                                      if   avail decl-cliente then do:
                                           assign i-pos                    = length(decl-cliente.texto).
                                           if   decl-hist-proc-imp.texto <> " " then 
                                                assign decl-hist-proc-imp.texto = decl-hist-proc-imp.texto + 
                                                                                  chr(10) + chr(10) +
                                                                                  trim(decl-cliente.texto).                
                                           else assign decl-hist-proc-imp.texto = trim(decl-cliente.texto).
                                      end.         
                                 end.
                            end.     
                       end.     
                    end. 
               end.    
         end.      
    end.
    return string(rowid({&TABLE-NAME})).           
end procedure.

procedure executeUpdate:
    /*
    **  Executa Update
    */
    
    buffer-copy RowObject except r-rowid nr-proc-imp cod-estabel to {&TABLE-NAME}.
end procedure.

procedure executeDelete:
    /*
    **  Executa Delete
    */
    
    /* Re-planejamento das parcelas no MRP, conforme atividade 116178 */
    &if defined(bf_mat_importacao_mrp) &then
    
             {cxbo/bocx140.i02}
    &endif

    for each historico-proc-imp where 
             historico-proc-imp.nr-proc-imp   = {&TABLE-NAME}.nr-proc-imp and
             historico-proc-imp.cod-estabel   = {&TABLE-NAME}.cod-estabel exclusive-lock:
        delete historico-proc-imp.
    end.
    for each decl-hist-proc-imp where
             decl-hist-proc-imp.cod-estabel = {&table-name}.cod-estabel and
             decl-hist-proc-imp.nr-proc-imp = {&table-name}.nr-proc-imp exclusive-lock:
        delete decl-hist-proc-imp.
    end.   
    for each ordens-embarque where 
             ordens-embarque.cod-estabel = {&table-name}.cod-estabel and
             ordens-embarque.nr-proc-imp = {&table-name}.nr-proc-imp
             exclusive-lock:
/*        for each decl-hist-embarq-imp where
                 decl-hist-embarq-imp.cod-estabel = ordens-embarque.cod-estabel and
                 decl-hist-embarq-imp.embarque    = ordens-embarque.embarque
                 exclusive-lock:
              delete decl-hist-embarq-imp.
          end.*/     
        
        
        delete ordens-embarque.     
        
    end.
    delete {&TABLE-NAME}.   
end procedure.

procedure validateFields:
    /*
    **  Valida Fields
    */
    
    run startMethod("validateFields":U).
    
    find first rowObject  no-lock no-error.
    if avail rowObject then
    
    find pedido-compr where
         pedido-compr.num-pedido = rowObject.num-pedido no-lock no-error.
    if avail pedido-compr then do:
        if rowObject.cod-exportador <> pedido-compr.cod-emitente then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgcex {&TABLE-NAME} cod-exportador 1}
            
            run utp/ut-msgs.p (input "msg",
                               input 26647,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 26647
                   tt-bo-erro.mensagem     = return-value.
        end.
        
    end. 
    
    if rowObject.dt-emissao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} dt-emissao 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.    

    if rowObject.cod-estabel <> pedido-compr.cod-estabel then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-estabel 1}
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-estabelecimento-do-processo-im AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Estabelecimento_do_Processo_Importa‡Æo" *}
        ASSIGN c-estabelecimento-do-processo-im = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-pedido-de-compra AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Pedido_de_Compra" *}
        ASSIGN c-lbl-liter-pedido-de-compra = TRIM(RETURN-VALUE).
        run utp/ut-msgs.p (input "msg",
                           input 17399,
                           input c-estabelecimento-do-processo-im
                           + "~~" + c-lbl-liter-pedido-de-compra + ": " + pedido-compr.cod-estabel).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 17399
               tt-bo-erro.mensagem     = RETURN-VALUE
               tt-bo-erro.errorHelp    = RETURN-VALUE.
    end.

    if rowObject.cod-fabricante <> 0 then do:
        if not can-find(emitente where emitente.cod-emitente = rowObject.cod-fabricante) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgcex processo-imp cod-fabricante 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 2
                   tt-bo-erro.mensagem = return-value.
        end.
        find emitente where emitente.cod-emitente = rowObject.cod-fabricante
            no-lock no-error.
        if   avail emitente then do:     
            {cdp/cd2500.i} /* Se é estrangeiro ou trading */
            {cdp/cd2502.i} /* Se é fornecedor ou ambos */
        end.              
    end.    
    if rowObject.cod-despachante <> 0 then do:
        if not can-find(emitente where emitente.cod-emitente = rowObject.cod-despachante) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgcex processo-imp cod-despachante 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 2
                   tt-bo-erro.mensagem = return-value.
        end.
        find emitente where emitente.cod-emitente = rowObject.cod-despachante
            no-lock no-error.
        if   avail emitente then do:                
            {cdp/cd2502.i} /* Se é fornecedor ou ambos */
        end.    
    end.
    if rowObject.cod-consignatario <> 0 then do:
        if not can-find(emitente where emitente.cod-emitente = rowObject.cod-consignatario) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgcex processo-imp cod-consignatario 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 2
                   tt-bo-erro.mensagem = return-value.
        end.           
    end.    
    
    if rowObject.cod-transportador <> 0 then do:
        if not can-find(transporte where transporte.cod-transp = rowObject.cod-transportador) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm transporte cod-transp 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 2
                   tt-bo-erro.mensagem = return-value.
        end.
        /* find emitente where emitente.cod-emitente = rowObject.cod-transportador
        **      no-lock no-error.
        ** if avail emitente then do:     
        **   {cdp/cd2502.i} /* Se é fornecedor ou ambos */          
        ** end. */
    end.

    if rowObject.cod-agente <> 0 then do:
        if not can-find(emitente where emitente.cod-emitente = rowObject.cod-agente) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgcex processo-imp cod-agente 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 2
                   tt-bo-erro.mensagem = return-value.
        end.           
    end.       
    if rowObject.estab-fisc = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} estab-fisc 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
    else do:
        if not can-find(estabelec where estabelec.cod-estabel = rowObject.estab-fisc) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgadm estabelec 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 2
                   tt-bo-erro.mensagem = return-value.
        end.           
    end.         
    if rowObject.via-transp = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} via-transp 1}
        run utp/ut-msgs.p (input "msg",
                           input 7965,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 7965
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.cod-itiner = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-itiner 1}
        run utp/ut-msgs.p (input "msg",
                           input 7965,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 7965
               tt-bo-erro.mensagem     = return-value.
    end.
    else do:
        if not can-find(itinerario where itinerario.cod-itiner = rowObject.cod-itiner) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex itinerario 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 2
                   tt-bo-erro.mensagem = return-value.
       end.           
    end.    
    
    if  rowObject.cod-idioma <> "" then do:
        &if defined(bf-mat-comex) &then                                
            if  not can-find(idioma where idioma.id-codigo = rowObject.cod-idioma) then do:
                assign i-seq-erro = i-seq-erro + 1.
                run utp/ut-msgs.p (input "msg",
                                   input 4774,
                                   input return-value).
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 4774
                       tt-bo-erro.mensagem = return-value.
           end.
        &else
            if  not can-find(idioma where idioma.cod_idioma = rowObject.cod-idioma) then do:
                assign i-seq-erro = i-seq-erro + 1.
                run utp/ut-msgs.p (input "msg",
                                   input 4774,
                                   input return-value).
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 4774
                       tt-bo-erro.mensagem = return-value.
           end.
        &endif
    end.

    /* Atividade 129371 Eng_Digita‡Æo_Cabe‡alho_Pedido_Processo_Importa‡Æo */
    &if "{&bf_mat_versao_ems}" >= "2.062":U &then
    
        if rowObject.cdn-corretor-cambio-import <> 0 then do:
          if not can-find(emitente where emitente.cod-emitente = rowObject.cdn-corretor-cambio-import) then do:
              assign i-seq-erro = i-seq-erro + 1.
              {utp/ut-field.i mgcex processo-imp cdn-corretor-cambio-import 1}
              run utp/ut-msgs.p (input "msg",
                                 input 2,
                                 input return-value).
              create tt-bo-erro.
              assign tt-bo-erro.i-sequen = i-seq-erro
                     tt-bo-erro.cd-erro  = 2
                     tt-bo-erro.mensagem = return-value.
          end.           
          find emitente where emitente.cod-emitente = rowObject.cdn-corretor-cambio-import no-lock no-error.
          if avail emitente then do:                
             {cdp/cd2502.i} /* Se ‚ fornecedor ou ambos */
          end.    
        end.       

        if rowObject.cdn-despa-exter-import <> 0 then do:
          if not can-find(emitente where emitente.cod-emitente = rowObject.cdn-despa-exter-import) then do:
              assign i-seq-erro = i-seq-erro + 1.
              {utp/ut-field.i mgcex processo-imp cdn-despa-exter-import 1}
              run utp/ut-msgs.p (input "msg",
                                 input 2,
                                 input return-value).
              create tt-bo-erro.
              assign tt-bo-erro.i-sequen = i-seq-erro
                     tt-bo-erro.cd-erro  = 2
                     tt-bo-erro.mensagem = return-value.
           end.           
           find emitente where emitente.cod-emitente = rowObject.cdn-despa-exter-import no-lock no-error.
           if avail emitente then do:                
             {cdp/cd2502.i} /* Se ‚ fornecedor ou ambos */
           end.    
        end.       

        if rowObject.cdn-segurad-import <> 0 then do:
          if not can-find(emitente where emitente.cod-emitente = rowObject.cdn-segurad-import) then do:
              assign i-seq-erro = i-seq-erro + 1.
              {utp/ut-field.i mgcex processo-imp cdn-segurad-import 1}
              run utp/ut-msgs.p (input "msg",
                                 input 2,
                                 input return-value).
              create tt-bo-erro.
              assign tt-bo-erro.i-sequen = i-seq-erro
                     tt-bo-erro.cd-erro  = 2
                     tt-bo-erro.mensagem = return-value.
          end.           
          find emitente where emitente.cod-emitente = rowObject.cdn-segurad-import no-lock no-error.
          if avail emitente then do:                
             {cdp/cd2502.i} /* Se ‚ fornecedor ou ambos */
          end.    
        end.       

        if rowObject.cdn-corretor-import <> 0 then do:
          if not can-find(emitente where emitente.cod-emitente = rowObject.cdn-corretor-import) then do:
              assign i-seq-erro = i-seq-erro + 1.
              {utp/ut-field.i mgcex processo-imp cdn-corretor-import 1}
              run utp/ut-msgs.p (input "msg",
                                 input 2,
                                 input return-value).
              create tt-bo-erro.
              assign tt-bo-erro.i-sequen = i-seq-erro
                     tt-bo-erro.cd-erro  = 2
                     tt-bo-erro.mensagem = return-value.
          end.           
          find emitente where emitente.cod-emitente = rowObject.cdn-corretor-import no-lock no-error.
          if avail emitente then do:                
             {cdp/cd2502.i} /* Se ‚ fornecedor ou ambos */
          end.    
        end.       
    &endif
    
    for each ordem-compra where ordem-compra.num-pedido = rowObject.num-pedido no-lock:
        &if defined(bf-mat-comex) &then
            if ordem-compra.situacao = "E":U OR         /* Eliminada */         
               ordem-compra.situacao = "R":U THEN NEXT. /* Recebida */
        &else      
            if ordem-compra.situacao = 4 OR         /* Eliminada */
               ordem-compra.situacao = 6 THEN NEXT. /* Recebida */
        &endif          
        
        find cotacao-item
           where cotacao-item.numero-ordem = ordem-compra.numero-ordem
             and cotacao-item.cod-emitente = ordem-compra.cod-emitente
             and cotacao-item.cot-aprovada no-lock no-error.
        if avail cotacao-item then do:
           /*** Busca Incoterm ***/
           &if defined(bf-mat-comex) &then
               assign i-mapa-cotacao-i50  = int(substring(cotacao-item.char-1,6,2))
                      c-cod-incoterm-i50  = substring(cotacao-item.char-1,8,3)
                      i-cod-pto-contr-i50 = int(substring(cotacao-item.char-1,11,5)).
           &else
               {cdp/cd4300.i4 "yes" cotacao-item.char-1}
               {ccp/cc9019.i51 "yes"}
           &endif                
           if not can-find(pto-itiner where pto-itiner.cod-itiner = rowObject.cod-itiner and pto-itiner.cod-pto-contr = i-cod-pto-contr-i50 no-lock)  then do:
                find first tt-bo-erro no-lock no-error.        
                if not avail tt-bo-erro then do:
                    assign i-seq-erro = i-seq-erro + 1.
                    {utp/ut-liter.i "Proc Imp"}
                    assign c-par = return-value.
                    {utp/ut-table.i mgind pedido-compr 1}
                    create tt-bo-erro.
                    assign tt-bo-erro.parametros = string(i-cod-pto-contr-i50) + "~~" + string(cotacao-item.numero-ordem) + "~~" + string(rowObject.cod-itiner).
                    run utp/ut-msgs.p (input "msg",
                                       input 25196,
                                       input string(i-cod-pto-contr-i50) + "~~" + string(cotacao-item.numero-ordem) + "~~" + string(rowObject.cod-itiner)).
                    assign tt-bo-erro.i-sequen = i-seq-erro
                           tt-bo-erro.cd-erro  = 25196
                           tt-bo-erro.mensagem = return-value.
                    undo, return.
                end.
           end.
        end.
    end.
    
    run endMethod("validateFields":U).
end procedure.

procedure validateDelete:
    /*
    **  Valida Delete
    */
    def input-output parameter r-chave as rowid.
    def output parameter table for tt-bo-erro.
    DEF VAR l-eliminou AS LOGICAL INITIAL NO.

    run InitializeValidate.

    for each tt-bo-erro NO-LOCK:
        delete tt-bo-erro.
    END.
 
    find {&TABLE-NAME} where rowid({&TABLE-NAME}) = r-chave EXCLUSIVE-LOCK no-error.
    if avail {&TABLE-NAME} then do:

        FIND FIRST ordens-embarque WHERE
                   ordens-embarque.cod-estabel = {&table-name}.cod-estabel AND
                   ordens-embarque.nr-proc-imp = {&table-name}.nr-proc-imp NO-LOCK NO-ERROR.
        IF AVAIL ordens-embarque THEN DO:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgcex {&TABLE-NAME} nr-proc-imp 2}
            run utp/ut-msgs.p (input "msg",
                               input 27956,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 27956
                   tt-bo-erro.mensagem = return-value.                                           
        END.
        ELSE DO:
            find first historico-proc-imp where
                       historico-proc-imp.cod-estabel = {&table-name}.cod-estabel and
                       historico-proc-imp.nr-proc-imp = {&table-name}.nr-proc-imp and
                       historico-proc-imp.cod-itiner  = {&table-name}.cod-itiner
                       no-lock no-error.
            if  avail historico-proc-imp and
                      historico-proc-imp.dt-efetiva <> ? then do:
                   if  {&table-name}.situacao = 4 OR l-eliminou-aux then do: /* Situacao Encerrada */
                      run executeDelete.
                      ASSIGN l-eliminou = YES.
                   end.        
            end.
            else do:
                run executeDelete.
                ASSIGN l-eliminou = YES.
            end.
        END.
    end.

    IF l-eliminou = YES THEN DO:
        if l-query then
            get next {&QUERY-NAME}
                no-lock no-wait.
        else
            find next {&TABLE-NAME}
                no-lock no-error.
    
        if not avail {&TABLE-NAME} then do:
           if l-query then
               get prev {&QUERY-NAME}
                   no-lock no-wait.
           else
               find prev {&TABLE-NAME}
                   no-lock no-error.
        end.
        assign r-chave = rowid({&TABLE-NAME}).
        return "".
    END.
end procedure.

procedure validateCreate:
    /*
    **  Valida cria‡Æo da tabela/duplicidade de registro.
    */
    def input  parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.
    def var r-cotacao-item    as rowid no-undo.
    

    run startMethod("validateCreate":U).    
 
    run initializeValidate.
 
    for each tt-bo-erro NO-LOCK:
        delete tt-bo-erro.
    end.
 
    find first rowObject NO-LOCK no-error.
    if rowObject.nr-proc-imp = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} nr-proc-imp 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
    
    if rowObject.cod-estabel = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-estabel 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
    else
        if not can-find(estabelec where estabelec.cod-estabel = rowObject.cod-estabel) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgadm estabelec 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 2
                   tt-bo-erro.mensagem = return-value.
       end.
    
    run validarPedidoprocesso  (input rowObject.num-pedido).
    run validarEmitenteprocesso(input rowObject.cod-exportador).
    
    run validateFields.
    
    find first tt-bo-erro
        no-lock no-error.
    if not available tt-bo-erro then do:
        find processo-imp where
            processo-imp.nr-proc-imp = rowObject.nr-proc-imp AND processo-imp.cod-estabel = rowObject.cod-estabel
            no-lock no-error.
        if avail processo-imp then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex {&TABLE-NAME} 1}
            run utp/ut-msgs.p (input "msg",
                               input 8,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 8
                   tt-bo-erro.mensagem     = return-value.
        end.
        find first processo-imp where processo-imp.num-pedido = rowObject.num-pedido no-lock no-error.
        if avail processo-imp then do:
            assign i-seq-erro = i-seq-erro + 1.
            /*{utp/ut-table.i mgcex {&TABLE-NAME} 1}*/
            run utp/ut-msgs.p (input "msg",
                               input 25781,
                               input string(processo-imp.num-pedido) + "~~" + processo-imp.cod-estabel + "~~" + processo-imp.nr-proc-imp + "~~" + return-value).
            create tt-bo-erro.
            assign tt-bo-erro.parametros = string(processo-imp.num-pedido) + "~~" + processo-imp.cod-estabel + "~~" + processo-imp.nr-proc-imp.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 25781
                   tt-bo-erro.mensagem     = return-value.              
        end.
    end.

    find first tt-bo-erro
        no-lock no-error.

    if not avail tt-bo-erro then do:
        run executeCreate.
        assign r-chave = to-rowid(return-value).
    end.
    run endMethod("validateCreate":U).
end procedure.


procedure retornaCodexportador:
/*
** Retorna codigo do exportador
*/
   def input parameter  c-nr-proc-imp   like historico-proc-imp.nr-proc-imp.
   def input parameter  c-cod-itiner    like historico-proc-imp.cod-itiner.   
   def output parameter c-cod-export    like processo-imp.cod-exportador.
   
   find processo-imp where processo-imp.nr-proc-imp = c-nr-proc-imp and
                           processo-imp.cod-itiner  = c-cod-itiner 
                           no-lock no-error.

   assign c-cod-export = if avail processo-imp then processo-imp.cod-exportador else 0.
end procedure. 

procedure RetornaMoedaValor:

   def input  parameter c-nr-proc-imp   like historico-proc-imp.nr-proc-imp.
   def input  parameter c-cod-estabel   like historico-proc-imp.cod-estabel.
   def output parameter de-valor        like cotacao-item.preco-unit.   
   def output parameter i-moeda         like moeda.mo-codigo.
   
   assign de-valor = 0.
   
   find processo-imp where processo-imp.nr-proc-imp = c-nr-proc-imp
                     and   processo-imp.cod-estabel = c-cod-estabel 
                     no-lock no-error.
   if  avail processo-imp then do:
       for each ordem-compra where
                ordem-compra.num-pedido = processo-imp.num-pedido 
                 no-lock:
           find cotacao-item where 
                cotacao-item.numero-ordem = ordem-compra.numero-ordem and
                cotacao-item.it-codigo    = ordem-compra.it-codigo    and
                cotacao-item.cod-emitente = ordem-compra.cod-emitente and
                cotacao-item.cot-aprovada = yes no-lock no-error.      
           if   avail cotacao-item then 
                assign de-unit = cotacao-item.preco-unit
                       i-moeda = cotacao-item.mo-codigo.
           else assign i-moeda = ordem-compra.mo-codigo.                 
           for each prazo-compra where 
                    prazo-compra.numero-ordem = ordem-compra.numero-ordem no-lock:      
               assign de-valor = de-valor + (prazo-compra.quantidade * de-unit).
           end.         
       end.          
   end.                     
end procedure.
 
procedure validateCodigo:
/*
** Validacao do formato e do tipo de dado que esta sendo gravado.
*/
    def input-output parameter c-cod-exportador  as char no-undo.
    def input-output parameter c-cod-fabricante  as char no-undo.
    def input-output parameter c-cod-itiner      as char no-undo.
    def input-output parameter c-cod-despachante as char no-undo.
    def input-output parameter c-cod-transp      as char no-undo.
    def input-output parameter c-cod-banco       as char no-undo.
    def input-output parameter c-cod-consig      as char no-undo.
    def input-output parameter c-cod-mensagem    as char no-undo.
    def input-output parameter c-cod-agente      as char no-undo.
    def input-output parameter c-via-transp      as char no-undo.
    def output parameter table for tt-bo-erro.
  
    def var i-teste as integer no-undo.
    
    assign i-teste = int(c-cod-exportador) no-error.
    if  error-status:error then do:
        assign i-seq-erro = i-seq-erro + 1
               c-cod-exportador = "0".
        {utp/ut-field.i mgcex {&table-name} cod-exportador 1}
        run utp/ut-msgs.p (input "msg",
                           input 16963,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16963
               tt-bo-erro.mensagem     = return-value.
    end.

    assign i-teste = int(c-cod-fabricante) no-error.
    if  error-status:error then do:
        assign i-seq-erro = i-seq-erro + 1
               c-cod-fabricante = "0".
        {utp/ut-field.i mgcex {&table-name} cod-fabricante 1}
        run utp/ut-msgs.p (input "msg",
                           input 16963,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16963
               tt-bo-erro.mensagem     = return-value.
    end.           
    
    assign i-teste = int(c-cod-itiner) no-error.
    if  error-status:error then do:
        assign i-seq-erro = i-seq-erro + 1
               c-cod-itiner = "0".
        {utp/ut-field.i mgcex {&table-name} cod-itiner 1}
        run utp/ut-msgs.p (input "msg",
                           input 16963,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16963
               tt-bo-erro.mensagem     = return-value.
    end.           
    
    assign i-teste = int(c-cod-despachante) no-error.
    if  error-status:error then do:
        assign i-seq-erro = i-seq-erro + 1
               c-cod-despachante = "0".
        {utp/ut-field.i mgcex {&table-name} cod-despachante 1}
        run utp/ut-msgs.p (input "msg",
                           input 16963,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16963
               tt-bo-erro.mensagem     = return-value.
    end.
    
    assign i-teste = int(c-cod-transp) no-error.
    if  error-status:error then do:
        assign i-seq-erro = i-seq-erro + 1
               c-cod-transp = "0".
        {utp/ut-field.i mgcex {&table-name} cod-transportador 1}
        run utp/ut-msgs.p (input "msg",
                           input 16963,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16963
               tt-bo-erro.mensagem     = return-value.
    end.                              
    
    assign i-teste = int(c-cod-banco) no-error.
    if  error-status:error then do:
        assign i-seq-erro = i-seq-erro + 1
               c-cod-banco = "0".
        {utp/ut-field.i mgcex {&table-name} cod-banco 1}
        run utp/ut-msgs.p (input "msg",
                           input 16963,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16963
               tt-bo-erro.mensagem     = return-value.
    end.    
    
    assign i-teste = int(c-cod-consig) no-error.
    if  error-status:error then do:
        assign i-seq-erro = i-seq-erro + 1
               c-cod-consig = "0".
        {utp/ut-field.i mgcex {&table-name} cod-consignatario 1}
        run utp/ut-msgs.p (input "msg",
                           input 16963,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16963
               tt-bo-erro.mensagem     = return-value.
    end.
    
    assign i-teste = int(c-cod-mensagem) no-error.
    if  error-status:error then do:
        assign i-seq-erro = i-seq-erro + 1
               c-cod-mensagem = "0".
        {utp/ut-field.i mgcex {&table-name} cod-mensagem 1}
        run utp/ut-msgs.p (input "msg",
                           input 16963,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16963
               tt-bo-erro.mensagem     = return-value.
    end.        

    assign i-teste = int(c-cod-agente) no-error.
    if  error-status:error then do:
        assign i-seq-erro = i-seq-erro + 1
               c-cod-agente = "0".
        {utp/ut-field.i mgcex {&table-name} cod-agente 1}
        run utp/ut-msgs.p (input "msg",
                           input 16963,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16963
               tt-bo-erro.mensagem     = return-value.
    end.            
            
    assign i-teste = int(c-via-transp) no-error.
    if  error-status:error then do:
        assign i-seq-erro = i-seq-erro + 1
               c-via-transp = "0".
        {utp/ut-field.i mgcex {&table-name} via-transp 1}
        run utp/ut-msgs.p (input "msg",
                           input 16963,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 16963
               tt-bo-erro.mensagem     = return-value.
    end.              
end procedure.

procedure validarInclusaoprocesso:
/*
** Validar inclusao de processos por numero do pedido
*/
def input parameter p-num-pedido like pedido-compr.num-pedido no-undo.
def output parameter table for tt-bo-erro.

for each tt-bo-erro NO-LOCK:
   delete tt-bo-erro.
end.

run validarPedidoprocesso(input p-num-pedido).
find first tt-bo-erro NO-LOCK no-error.
if not avail tt-bo-erro and avail pedido-compr then
    run validarEmitenteprocesso(input pedido-compr.cod-emitente).
end procedure.

procedure validarPedidoprocesso:
/* 
** Valida o n£mero do pedido de compra e o fornecedor (internacional ou trading).
*/ 
    def input parameter p-num-pedido like pedido-compr.num-pedido no-undo.
    
    def var c-return1 as char no-undo.
    
    if p-num-pedido = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} num-pedido 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.        
        run utp/ut-msgs.p (input "msg",
                           input 7965,
                           input return-value).
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 7965
               tt-bo-erro.mensagem = return-value.
    end.
    else do:
        find pedido-compr where pedido-compr.num-pedido = p-num-pedido no-lock no-error.
        if not avail pedido-compr then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgind pedido-compr 1}
            create tt-bo-erro.
            assign tt-bo-erro.parametros = return-value.        
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.    
        end.
    end.
end procedure.

procedure validarEmitenteprocesso:
/* 
** Valida emitente do processo de importacao.
*/
    def input parameter p-cod-emitente as integer no-undo.
    
    def var c-return1 as char no-undo.

    find emitente where emitente.cod-emitente = p-cod-emitente no-lock no-error.
    if avail emitente then do:
        &if defined(bf-mat-comex) &then                                                 
            if emitente.identific <> "F" and emitente.identific <> "A" then do:
        &else            
            if emitente.identific <> 2 and emitente.identific <> 3  then do:
        &endif            
                /* emitente cliente */
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-liter.i Emitente mim L}
                assign c-return1 = trim(return-value).
                {utp/ut-liter.i fornecedor mim L}
                create tt-bo-erro.
                assign tt-bo-erro.parametros = c-return1 + "~~" + return-value.
                run utp/ut-msgs.p (input "msg",
                                   input 17195,
                                   input c-return1 + "~~" + return-value).
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 17195
                       tt-bo-erro.mensagem     = return-value.            
        end.
        &if defined(bf-mat-comex) &then                                                 
            if emitente.natureza <> "E" and emitente.natureza <> "T" then do:        
        &else
            if emitente.natureza <> 3 and emitente.natureza <> 4 then do:
        &endif
            /* emitente nao estrangeiro */
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-liter.i Fornecedor_do_pedido mim L}
            assign c-return1 = trim(return-value).
            {utp/ut-liter.i estrangeiro_ou_trading mim L}
            create tt-bo-erro.
            assign tt-bo-erro.parametros = c-return1 + "~~" + return-value.
            run utp/ut-msgs.p (input "msg",
                               input 17195,
                               input c-return1 + "~~" + return-value).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 17195
                   tt-bo-erro.mensagem     = return-value.                
        end.
    end.
    else do: /* not avail emitente */
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&table-name} cod-emitente 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.            
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 2
               tt-bo-erro.mensagem     = return-value.        
    end.

end procedure.

procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        when "nr-proc-imp" then c-value = RowObject.nr-proc-imp.
        when "nr-conhecimento" then c-value = RowObject.nr-conhecimento.
        when "cod-estabel" then c-value = RowObject.cod-estabel.
        when "carta-credito" then c-value = RowObject.carta-credito.
        when "narrativa" then c-value = RowObject.narrativa.
        when "nr-rof" then c-value = RowObject.nr-rof.
        when "licenca-import" then c-value = RowObject.licenca-import.
        when "declaracao-import" then c-value = RowObject.declaracao-import.
        when "estab-fisc" then c-value = RowObject.estab-fisc.
        when "cod-incoterm" then c-value = RowObject.cod-incoterm.
        when "contrato-cambio" then c-value = RowObject.contrato-cambio.
        when "cod-idioma" then c-value = RowObject.cod-idioma.
        when "merc-orig" then c-value = RowObject.merc-orig.        
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "check-sum" then c-value = RowObject.check-sum.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:        
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        otherwise return error.
    end case.
end procedure.

procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "cod-itiner" then c-value = RowObject.cod-itiner.
        when "cod-despachante" then c-value = RowObject.cod-despachante.
        when "cod-fabricante" then c-value = RowObject.cod-fabricante.
        when "cod-exportador" then c-value = RowObject.cod-exportador.
        when "cod-consignatario" then c-value = RowObject.cod-consignatario.
        when "cod-transportador" then c-value = RowObject.cod-transportador.
        when "cod-banco" then c-value = RowObject.cod-banco.
        when "regime-import" then c-value = RowObject.regime-import.
        when "via-transp" then c-value = RowObject.via-transp.
        when "num-pedido" then c-value = RowObject.num-pedido.
        when "situacao" then c-value = RowObject.situacao.
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2. 

      /* Atividade 129371 Eng_Digita‡Æo_Cabe‡alho_Pedido_Processo_Importa‡Æo */
      &if "{&bf_mat_versao_ems}" >= "2.062":U &then
        when "cdn-corretor-import":U then c-value = RowObject.cdn-corretor-import.
        when "cdn-despa-exter-import":U then c-value = RowObject.cdn-despa-exter-import.
        when "cdn-segurad-import":U then c-value = RowObject.cdn-segurad-import.
        when "cdn-corretor-cambio-import":U then c-value = RowObject.cdn-corretor-cambio-import.
      &endif

        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "dt-emissao" then c-value = RowObject.dt-emissao.
        when "dt-implantacao" then c-value = RowObject.dt-implantacao.
        when "dt-autorizacao" then c-value = RowObject.dt-autorizacao.
        when "data-1" then c-value = RowObject.data-1.
        when "data-2" then c-value = RowObject.data-2.        
        otherwise return error.
    end case.
end procedure.

procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.
 
    case c-field:
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.        
        otherwise return error.
    end case.
end procedure.


procedure pi-recebe-idioma:
    /*
    **  Procedure para receber o idioma do usu rio.
    */
    def input parameter c_cod_idiom_usuar as char format "x(12)".

    assign c-cod-idiom-usuar = c_cod_idiom_usuar.

end procedure.


procedure verificaPedidoprocesso:
    /* 
    ** Verifica se o pedido est  relacionado com um processo.
    */ 
    def input parameter p-num-pedido like pedido-compr.num-pedido no-undo.
    def output parameter c-return1 as integer no-undo.
    def output parameter r-rowid as rowid no-undo.

    find first processo-imp where processo-imp.num-pedido = p-num-pedido no-lock no-error.
    if avail processo-imp then do:
        assign c-return1 = 1 
               r-rowid = rowid(processo-imp).
    end.
    else
       assign c-return1 = 0.
end procedure.


procedure atualizaSituacaoProcesso:
    /*
    ** Atualiza situa‡Æo do processo de importa‡Æo
    */
    def input parameter p-cod-estabel like estabelec.cod-estabel    no-undo.
    def input parameter p-nr-proc-imp like processo-imp.nr-proc-imp no-undo.
    def output parameter table for tt-bo-erro.
    
    def var l-encerrado     as   logical no-undo.
    def var de-quant-prazo  like prazo-compra.quantidade    no-undo.
    def var de-quant-embarq like ordens-embarque.quantidade no-undo.
    
    for first processo-imp fields(num-pedido situacao)
        where processo-imp.cod-estabel = p-cod-estabel
          and processo-imp.nr-proc-imp = p-nr-proc-imp no-lock:
    end.
    if not avail processo-imp then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-table.i mgcex processo-imp 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.            
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 2
               tt-bo-erro.mensagem     = return-value.
        return "NOK":U.
    end.
    
    /*
    ** Totaliza quantidades de todas as parcelas e das parcelas embarcadas
    */
    for each ordem-compra fields(numero-ordem)
        where ordem-compra.num-pedido = processo-imp.num-pedido no-lock
        USE-INDEX pedido:       
        
        for each prazo-compra fields(situacao parcela quantidade)
                              WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem
                              AND   prazo-compra.situacao <> 2
                              AND   prazo-compra.situacao <> 6
                              NO-LOCK:
            
            assign de-quant-prazo = de-quant-prazo + prazo-compra.quantidade.
            
            for each ordens-embarque 
                where ordens-embarque.numero-ordem = ordem-compra.numero-ordem
                  and ordens-embarque.parcela      = prazo-compra.parcela NO-LOCK
                USE-INDEX ordem:

                FOR FIRST embarque-imp NO-LOCK
                    WHERE embarque-imp.embarque = ordens-embarque.cod-estabel
                      AND embarque-imp.cod-estabel = ordens-embarque.embarque:
                END.

                FOR FIRST historico-embarque
                    WHERE historico-embarque.cod-estabel = ordens-embarque.cod-estabel
                      AND historico-embarque.embarque    = ordens-embarque.embarque NO-LOCK:
                END.
                IF NOT AVAIL historico-embarque THEN
                    NEXT.

                FIND itinerario
                    WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK NO-ERROR.
                FIND historico-embarque
                    WHERE historico-embarque.cod-estabel   = ordens-embarque.cod-estabel
                      AND historico-embarque.embarque      = ordens-embarque.embarque 
                      AND historico-embarque.cod-itiner    = itinerario.cod-itiner
                      AND historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-embarq NO-LOCK NO-ERROR.
                IF NOT AVAIL historico-embarque THEN
                    NEXT.

                IF historico-embarque.dt-efetiva <> ? THEN
                    ASSIGN de-quant-embarq = de-quant-embarq + ordens-embarque.quantidade.
                
                if not can-find(tt-embarques 
                          where tt-embarques.embarque = ordens-embarque.embarque) then do:
                    create tt-embarques.
                    assign tt-embarques.embarque = ordens-embarque.embarque.
                end.

            end.
        end.
    end.

    /*
    ** Atualiza situa‡Æo no processo
    */ 
    for first processo-imp fields(num-pedido situacao)
        where processo-imp.cod-estabel = p-cod-estabel
          and processo-imp.nr-proc-imp = p-nr-proc-imp exclusive-lock:
    end.
    
    if de-quant-embarq = 0 then
        assign processo-imp.situacao = 1. /* NÆo Embarcado */
    else
        if de-quant-prazo > de-quant-embarq then
            assign processo-imp.situacao = 2. /* Embarcado Parcial */
        else
            if de-quant-prazo = de-quant-embarq then
                assign processo-imp.situacao = 3. /* Embarcado Total */

    if processo-imp.situacao = 3 then do:  /* Embarcado Total */
        assign l-encerrado = yes.
        for each tt-embarques
            USE-INDEX codigo:
            for last historico-embarque fields(dt-efetiva)
                where historico-embarque.embarque    = tt-embarques.embarque no-lock:
                if historico-embarque.dt-efetiva = ? then
                    assign l-encerrado = no.                  
            end.
        end.                              
    end.
    if l-encerrado then
        assign processo-imp.situacao = 4. /* Encerrado */

    RELEASE processo-imp.

    RETURN "OK":U.
end procedure.

procedure errosPli:

    define input  parameter pNumPedido as integer no-undo.
    define output parameter table for tt-bo-erro.

    for each tt-bo-erro:
        delete tt-bo-erro.
    end.

    return "OK":U.
end procedure.


PROCEDURE BloqueiaEliminacao:
    DEFINE INPUT PARAMETER pl-eliminou AS LOGICAL NO-UNDO.

    ASSIGN l-eliminou-aux = pl-eliminou.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE ValidateItiner:
    DEFINE INPUT PARAMETER c-cod-estabel LIKE processo-imp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER c-nr-proc-imp LIKE processo-imp.nr-proc-imp NO-UNDO.
    DEFINE INPUT PARAMETER i-cod-itiner  LIKE processo-imp.cod-itiner  NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.

    FOR EACH tt-bo-erro:
        DELETE tt-bo-erro.
    END.

    ASSIGN l-pto-embarque    = NO
           l-pto-desembarque = NO
           l-pto-chegada     = NO
           l-erro            = NO
           c-param1          = "".

    FIND FIRST historico-proc-imp
         WHERE historico-proc-imp.cod-estabel = c-cod-estabel
           AND historico-proc-imp.nr-proc-imp = c-nr-proc-imp NO-LOCK NO-ERROR.

    IF AVAIL historico-proc-imp THEN DO:
        IF historico-proc-imp.cod-itiner <> i-cod-itiner THEN DO:
            ASSIGN i-seq-erro = i-seq-erro + 1.
            CREATE tt-bo-erro.
            {utp/ut-liter.i "Proc Imp"}
            ASSIGN c-par1 = RETURN-VALUE.
            {utp/ut-table.i mgcex historico-proc-imp 1}
            ASSIGN c-par2 = RETURN-VALUE.
            ASSIGN tt-bo-erro.parametros = STRING(i-cod-itiner) + "~~" + c-nr-proc-imp + "~~" + STRING(historico-proc-imp.cod-itiner).
            RUN utp/ut-msgs.p (INPUT "msg":U,
                               INPUT 32332,
                               INPUT c-par1 + "~~" + c-par2).
            ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 32332
                   tt-bo-erro.mensagem     = RETURN-VALUE
                   tt-bo-erro.errorSubType = "WARNING":U.
        END.
    END.

    FIND FIRST itinerario 
         WHERE itinerario.cod-itiner = i-cod-itiner NO-LOCK NO-ERROR.

    IF AVAIL itinerario THEN DO:
        ASSIGN l-pto-embarque    = CAN-FIND(FIRST pto-itiner WHERE pto-itiner.cod-pto-contr = itinerario.pto-embarque)
               l-pto-desembarque = CAN-FIND(FIRST pto-itiner WHERE pto-itiner.cod-pto-contr = itinerario.pto-desembarque)
               l-pto-chegada     = CAN-FIND(FIRST pto-itiner WHERE pto-itiner.cod-pto-contr = itinerario.pto-chegada).

        IF NOT l-pto-embarque    OR
           NOT l-pto-desembarque OR
           NOT l-pto-chegada     THEN
            ASSIGN l-erro = YES.
    END.

    IF l-erro THEN DO:

        IF  NOT l-pto-embarque THEN DO:
            {utp/ut-liter.i "Embarque"}
            ASSIGN c-param1 = c-param1 + " " + TRIM(RETURN-VALUE).
        END.

        IF  NOT l-pto-desembarque THEN DO:
            {utp/ut-liter.i "Nacionaliza‡Æo"}
            ASSIGN c-param1 = c-param1 + " " + TRIM(RETURN-VALUE).
        END.

        IF  NOT l-pto-chegada THEN DO:
            {utp/ut-liter.i "Chegada"}
            ASSIGN c-param1 = c-param1 + " " + TRIM(RETURN-VALUE).
        END.

        ASSIGN i-seq-erro = i-seq-erro + 1.
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 32543,
                           INPUT c-param1 + "~~" + STRING(i-cod-itiner)).
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.parametros   = c-param1 + "~~" + STRING(i-cod-itiner)
               tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 32543
               tt-bo-erro.mensagem     = RETURN-VALUE
               tt-bo-erro.errorSubType = "ERROR":U.

    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-liberaregistro:
    RELEASE processo-imp.
END PROCEDURE.

/* BOCX140.P */
