/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX135 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX135 MUT}
&ENDIF

/*
**  BOCX135.P
**
**  desp-item - 
**
**  Ultima altera‡Æo : 18/09/99 - GeraBO
**  Bo respons vel pelas inform‡äes da despesa do item exceto a despesa.
*/

def var c-item as char no-undo.
def var i-itiner as integer no-undo.
def var i-pto as integer no-undo.
def var i-desp as integer no-undo.
def var c-tab         as char     no-undo.
def var c-moeda       as integer  no-undo.
def var c-fornecedor  as integer  no-undo.
def var c-itinerario  as integer  no-undo.
def var c-incoterm    as char     no-undo.
def var i-cod-emitente like emitente.cod-emitente no-undo.
def var c-it-codigo   as char     no-undo.
def var l-validou     as logical  initial no no-undo.
def var l-elimina-pai as logical  initial no no-undo.

DEFINE var c-cod-estabel    like proc-ped-venda.cod-estabel no-undo.
DEFINE var c-nr-proc-exp    like proc-ped-venda.nr-proc-exp no-undo.
DEFINE var c-nr-pedido      like proc-ped-venda.nr-pedido   no-undo.
DEFINE VAR h-bocx195        as handle                       no-undo.
def var i-cod-itiner as integer no-undo.

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY desp-item
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME desp-item

{include/boini.i}

DEFINE TEMP-TABLE tt-bo-erro-aux no-undo like tt-bo-erro.

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
{cxbo/bocx135.i RowObject}
{cxbo/bocx135.i tt-desp-item}
{cxbo/bocx135.i tt-desp-item-aux}

DEFINE temp-table tt-desp-item-faixa no-undo
    field cod-desp like desp-imp.cod-desp 
    field cod-itiner like itinerario.cod-itiner
    field cod-pto-contr like pto-contr.cod-pto-contr
    field exclui like desp-item.exclui
    field fm-codigo-ini like item.fm-codigo
    field fm-codigo-fim like item.fm-codigo
    field fm-cod-com-ini like item.fm-cod-com
    field fm-cod-com-fim like item.fm-cod-com
    field class-fiscal-ini like item.class-fiscal
    field class-fiscal-fim like item.class-fiscal
    field cod-emitente-ini like item-fornec.cod-emitente
    field cod-emitente-fim like item-fornec.cod-emitente
    field ge-codigo-ini like item.ge-codigo
    field ge-codigo-fim like item.ge-codigo
    field cparam as char.

procedure setConstraint1:
end.

PROCEDURE setConstraint2:

def input parameter p-item as char no-undo.
def input parameter p-itiner as char no-undo.
def input parameter p-desp as char no-undo.

assign c-item = p-item
       i-itiner = integer(p-itiner)
       i-desp = integer(p-desp).

END PROCEDURE.

procedure setConstraint3:
def input parameter p-it-codigo as char no-undo.

    assign c-it-codigo = p-it-codigo.
    
end.

procedure setConstraint4:
def input parameter p-it-codigo as char no-undo.
def input parameter p-cod-itiner as integer no-undo.

    assign c-it-codigo = p-it-codigo
           i-cod-itiner = p-cod-itiner.
           
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    
    assign i-bo-query = i-abertura.
    assign l-query = yes.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where
                    	                         desp-item.it-codigo >= c-item and ~
                                              desp-item.cod-itiner >= i-itiner and ~
                                              desp-item.cod-desp >= i-desp  no-lock.
        when 3 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where desp-item.it-codigo >= c-it-codigo no-lock.
        when 4 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where desp-item.it-codigo = c-it-codigo and
                                                                  desp-item.cod-itiner = i-cod-itiner no-lock by desp-item.it-codigo.

    end case.
end procedure.

{include/bostrmet.i}
{include/boendmet.i}
{include/bocomver.i}
{include/bogetver.i}
/*{include/bonav.i}*/
{include/bofind.i}
{include/bosetcur.i}
{include/bogetcur.i}
{include/bosersen.i}
{include/boprebro.i}
{include/boexecre.i}
/*{include/boexeupt.i}*/
{include/boexedel.i}
/*{include/bovalupt.i}*/
/*{include/bovaldel.i}*/
{utp/ut-glob.i}

procedure findFirst:
    if l-query then
        get first {&QUERY-NAME}
            no-lock no-wait.
    else
        find first {&TABLE-NAME}
            no-lock no-error.
    run setCurrent.
end procedure.

procedure findPrev:
    def var p-item as char no-undo.
    def var p-itiner as integer no-undo.
    def output parameter c-return as char.
    
    run getCurrent(output table rowObject).
    assign p-item = rowObject.it-codigo
           p-itiner = rowObject.cod-itiner.
    
    find last {&TABLE-NAME} where {&TABLE-NAME}.it-codigo = p-item and
                                   {&TABLE-NAME}.cod-itiner < p-itiner no-lock no-error.                                               
    if not avail {&TABLE-NAME} then 
      find last {&TABLE-NAME} where {&TABLE-NAME}.it-codigo < p-item no-lock no-error.
                                     
    if not avail {&TABLE-NAME} then do:
        run utp/ut-msgs.p (input "msg",
                           input 7999,
                           input "").
        assign c-return = return-value.
    end.
    else run setCurrent.

end procedure.

procedure findNext:
    def var p-item as char no-undo.
    def var p-itiner as integer no-undo.
    def output parameter c-return as char.
    
    run getCurrent(output table rowObject).
    assign p-item = rowObject.it-codigo
           p-itiner = rowObject.cod-itiner.
    
    find first {&TABLE-NAME} where {&TABLE-NAME}.it-codigo = p-item and
                                   {&TABLE-NAME}.cod-itiner > p-itiner no-lock no-error.                                               
    if not avail {&TABLE-NAME} then 
      find first {&TABLE-NAME} where {&TABLE-NAME}.it-codigo > p-item no-lock no-error.
                                     
    if not avail {&TABLE-NAME} then do:
        run utp/ut-msgs.p (input "msg",
                           input 7999,
                           input "").
        assign c-return = return-value.
    end.
    else run setCurrent.
    
end procedure.

procedure findLast:
    if l-query then
        get last {&QUERY-NAME}
            no-lock no-wait.
    else
        find last {&TABLE-NAME}
            no-lock no-error.
    run setCurrent.
end procedure.

procedure getRowid:
    def output parameter r-chave as rowid no-undo.
    if avail {&TABLE-NAME} then do:
        assign r-chave = rowid({&TABLE-NAME}).
    end.
    else do:
       assign r-chave = ?.
    end.
end procedure.

procedure executeUpdate:
    /*
    **  Executa Update
    */
    buffer-copy RowObject except r-rowid it-codigo cod-itiner to {&TABLE-NAME}.
end procedure.

procedure findCodigo:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter c-it-codigo as char no-undo.
    def input parameter i-cod-itiner as inte no-undo.
    def input parameter i-cod-desp as inte no-undo.
    def output parameter table for RowObject.
 
    find desp-item where
        desp-item.it-codigo = c-it-codigo
        and desp-item.cod-itiner = i-cod-itiner   
        and desp-item.cod-desp = i-cod-desp
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i mgcex {&TABLE-NAME} 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
    end.
    else do:
       run setCurrent.
    end.
end procedure.

procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
end procedure.

procedure findCoditem:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter c-it-codigo as char no-undo.
    def output parameter table for RowObject.
 
    find first desp-item where
        desp-item.it-codigo = c-it-codigo
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i mgcex {&TABLE-NAME} 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
    end.
    else do:
       run setCurrent.
    end.
end procedure.

procedure findItemitiner:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter c-it-codigo  as char no-undo.
    def input parameter i-cod-itiner as integer no-undo.
    def output parameter c-return as char no-undo. 

    find first desp-item where desp-item.it-codigo  = c-it-codigo and
                               desp-item.cod-itiner = i-cod-itiner
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
end procedure.
 
procedure validateUpdate:
    /*
    **  Valida Update
    */
    def input parameter table for RowObject.
    def input parameter r-chave as rowid no-undo.
    def output parameter table for tt-bo-erro.
 
    run InitializeValidate.
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
    
    find first rowObject no-lock no-error.
    
    run validateFields.
    
    find first tt-bo-erro
        no-lock no-error.
    if not avail tt-bo-erro then do:
        find {&TABLE-NAME} where
            rowid({&TABLE-NAME}) = r-chave
            exclusive-lock no-error no-wait.

        if locked({&TABLE-NAME}) then do:
            assign i-seq-erro = i-seq-erro + 1.    
            run utp/ut-msgs.p (input "msg",
	                       input 16096,
 			       input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
  	           tt-bo-erro.cd-erro  = 16096
 	           tt-bo-erro.mensagem = return-value.                
        end.
        else 
	    if avail {&TABLE-NAME} then
                run executeUpdate.                        
    end.
    
end procedure.  
 
procedure validateFields:
    /*
    **  Valida Fields
    */    
    def var c-return  as char no-undo.
    def var c-return1 as char no-undo.
    
    find first rowObject no-error.
    
    if rowObject.cod-pto-contr = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-pto-contr 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.        
    end.
    else do:
        if not can-find(pto-contr where pto-contr.cod-pto-contr = rowObject.cod-pto-contr) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex pto-contr 1}
            create tt-bo-erro.
            assign tt-bo-erro.parametros = return-value.                        
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.
        end.
        if not can-find(pto-itiner where pto-itiner.cod-itiner    = rowObject.cod-itiner and
                                         pto-itiner.cod-pto-contr = rowObject.cod-pto-contr) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex pto-itiner 1}
            assign c-return = return-value + string(rowObject.cod-pto-contr).
            {utp/ut-table.i mgcex itinerario 1}
            assign c-return1 = return-value + string(rowObject.cod-itiner).
            create tt-bo-erro.
            assign tt-bo-erro.parametros = c-return + "~~" + c-return1.
            run utp/ut-msgs.p (input "msg",
                               input 16381,
                               input c-return + "~~" + c-return1).
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 16381
                   tt-bo-erro.mensagem = return-value.
        end.
    end.        
       
end procedure. 

procedure validateDelete:
    /*
    **  Valida Delete
    */
    def input-output parameter r-chave as rowid.
    def output parameter table for tt-bo-erro.
 
    run InitializeValidate.
 
    find {&TABLE-NAME} where
        rowid({&TABLE-NAME}) = r-chave
        exclusive-lock no-error.
    if avail {&TABLE-NAME} then do:            
        if l-elimina-pai then do:
            run executeDeleteitem (input-output r-chave).
            leave.
        end.            
        else             
            run executeDelete.
    end.
 
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
end procedure.
 
procedure validateCreate:
    /*
    **  Valida cria‡Æo da tabela/duplicidade de registro.
    */
    def input  parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.
 
    run initializeValidate.
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
 
    find first rowObject no-error.
    
    if not l-validou then do:    
        if not can-find(item where item.it-codigo = rowObject.it-codigo) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgind item 1}
            create tt-bo-erro.
            assign tt-bo-erro.parametros = return-value.
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value. 
        end.                      
        run validateFieldscreate.        
        run validateFields.
    end.        
    
    if not can-find(first tt-bo-erro) then
        if can-find(first {&TABLE-NAME} where {&TABLE-NAME}.it-codigo = rowObject.it-codigo
                                          and {&TABLE-NAME}.cod-itiner = rowObject.cod-itiner        
                                          and {&TABLE-NAME}.cod-desp = rowObject.cod-desp) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex {&TABLE-NAME} 1}
            create tt-bo-erro.
            assign tt-bo-erro.parametros = return-value.            
            run utp/ut-msgs.p (input "msg",
                               input 428,
                               input return-value + "~~" + rowObject.it-codigo).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 428
                   tt-bo-erro.mensagem     = return-value.
        end.   
 
    if not can-find(first tt-bo-erro) then do:       
       run executeCreate.
       assign r-chave = to-rowid(return-value).
    end.
 
end procedure.

procedure validateFieldscreate:
    
    find first rowObject no-error.

    if rowObject.cod-itiner = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-itiner 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.        
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 265
               tt-bo-erro.mensagem = return-value.    
    end.
    else 
        if not can-find(first itinerario where itinerario.cod-itiner = rowObject.cod-itiner) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex pto-itiner 1}
            create tt-bo-erro.
            assign tt-bo-erro.parametros = return-value.            
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.
        end.
      
    if rowObject.cod-desp = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-desp 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 265
               tt-bo-erro.mensagem = return-value.
    end.
    else
        if not can-find(desp-imp where desp-imp.cod-desp = rowObject.cod-desp) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex desp-imp 1}
            create tt-bo-erro.
            assign tt-bo-erro.parametros = return-value.
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 2
                   tt-bo-erro.mensagem = return-value.
        end.    
    
end procedure.

procedure setItempai:
/* Grava se o registro que est  sendo eliminado ‚ um registro pai */
def input parameter p-elimina-pai as logical no-undo.

assign l-elimina-pai = p-elimina-pai.
end procedure.

procedure executeDeleteitem:
    /* Elimina registro filhos e o pr¢prio pai */
    def input-output parameter r-chave as rowid no-undo.
    
    def var c-it-codigo as char no-undo.
    def var i-cod-itiner as integer no-undo.

    find {&TABLE-NAME} where rowid({&TABLE-NAME}) = r-chave no-lock no-error.
    if avail {&TABLE-NAME} then
      assign c-it-codigo  = {&TABLE-NAME}.it-codigo
             i-cod-itiner = {&TABLE-NAME}.cod-itiner.                             
    for each {&TABLE-NAME} where
       {&TABLE-NAME}.it-codigo  = c-it-codigo and       
       {&TABLE-NAME}.cod-itiner = i-cod-itiner exclusive-lock:  
       delete {&TABLE-NAME}.       
    end.
    
    find first {&TABLE-NAME} where {&TABLE-NAME}.it-codigo = c-it-codigo and
                                   {&TABLE-NAME}.cod-itiner > i-cod-itiner no-lock no-error.                                               
    if not avail {&TABLE-NAME} then 
      find first {&TABLE-NAME} where {&TABLE-NAME}.it-codigo > c-it-codigo no-lock no-error. 
    if not avail {&TABLE-NAME} then
      find last {&TABLE-NAME} where {&TABLE-NAME}.it-codigo = c-it-codigo and        
                                    {&TABLE-NAME}.cod-itiner < i-cod-itiner no-lock no-error.          
    if not avail {&TABLE-NAME} then 
      find last {&TABLE-NAME} where {&TABLE-NAME}.it-codigo < c-it-codigo no-lock no-error. 
      
    if avail {&TABLE-NAME} then assign r-chave = rowid({&TABLE-NAME}).    
end procedure.

procedure executeCopy:
/* Rowid do registro original da c¢pia */
def input parameter r-chave as rowid no-undo.
/* Nova Tabela Criada */
def input parameter table for rowObject.

def var c-it-codigo as char no-undo.
def var i-cod-itiner as integer no-undo.

    for each tt-desp-item:
        delete tt-desp-item.
    end.

    find first rowObject no-error.
    
    find {&TABLE-NAME} where rowid({&TABLE-NAME}) = r-chave no-lock no-error.
    if avail {&TABLE-NAME} then do:
        assign c-it-codigo  = {&TABLE-NAME}.it-codigo
               i-cod-itiner = {&TABLE-NAME}.cod-itiner.
        for each {&TABLE-NAME} where {&TABLE-NAME}.it-codigo = c-it-codigo and
                                     {&TABLE-NAME}.cod-itiner = i-cod-itiner no-lock:
            if {&TABLE-NAME}.cod-desp <> rowObject.cod-desp then do:
              create tt-desp-item .
              assign tt-desp-item.it-codigo     = rowObject.it-codigo
                     tt-desp-item.cod-itiner    = rowObject.cod-itiner
                     tt-desp-item.cod-desp      = {&TABLE-NAME}.cod-desp
                     tt-desp-item.cod-pto-contr = {&TABLE-NAME}.cod-pto-contr
                     tt-desp-item.exclui        = {&TABLE-NAME}.exclui.
            end.
        end.  
        for each tt-desp-item:
            create {&TABLE-NAME}.
            buffer-copy tt-desp-item to {&TABLE-NAME}.
        end.
    end.
    
end procedure.

procedure atualizaPorfaixa:
/*
** Atualiza despesas do item (Inclui,Modifica,Elimina) de acordo com a faixa de parƒmetros informada
** Programa que a utiliza "Altera‡Æo Despesas do Item/Faixa - WCD2575.w
*/
    def input  parameter table for tt-desp-item-faixa.
    def output parameter table for tt-bo-erro-aux.    
    def var r-chave as rowid no-undo.
    
    for each tt-bo-erro-aux:
        delete tt-bo-erro-aux.
    end.
    for each rowObject:
        delete rowObject.
    end.
    
    find first tt-desp-item-faixa no-error.
    create rowObject.
    assign rowObject.cod-itiner    = tt-desp-item-faixa.cod-itiner
           rowObject.cod-desp      = tt-desp-item-faixa.cod-desp
           rowObject.cod-pto-contr = tt-desp-item-faixa.cod-pto-contr.           
           
    /* Validacao dos valores informados */           
    run validateFieldscreate.
    run validateFields.    
    assign l-validou = yes.
    for each rowObject:
        delete rowObject.
    end.
    
    find first tt-bo-erro no-error.
    for each tt-bo-erro:
        create tt-bo-erro-aux.
        buffer-copy tt-bo-erro to tt-bo-erro-aux.
    end.

    if avail tt-desp-item-faixa and not avail tt-bo-erro then
        for each item-fornec fields(item-fornec.it-codigo)
            where item-fornec.cod-emitente >= tt-desp-item-faixa.cod-emitente-ini and
                  item-fornec.cod-emitente <= tt-desp-item-faixa.cod-emitente-fim no-lock,
            each item fields(item.it-codigo)
                where item.it-codigo    = item-fornec.it-codigo and 
                      item.fm-codigo    >= tt-desp-item-faixa.fm-codigo-ini and
                      item.fm-codigo    <= tt-desp-item-faixa.fm-codigo-fim and
                      item.fm-cod-com   >= tt-desp-item-faixa.fm-cod-com-ini and
                      item.fm-cod-com   <= tt-desp-item-faixa.fm-cod-com-fim and
                      item.class-fiscal >= tt-desp-item-faixa.class-fiscal-ini and
                      item.class-fiscal <= tt-desp-item-faixa.class-fiscal-fim and                            
                      item.ge-codigo    >= tt-desp-item-faixa.ge-codigo-ini and
                      item.ge-codigo    <= tt-desp-item-faixa.ge-codigo-fim no-lock:
            if tt-desp-item-faixa.cparam = "add" then do: 
                create tt-desp-item-aux.
                assign tt-desp-item-aux.it-codigo     = item.it-codigo
                       tt-desp-item-aux.cod-desp      = tt-desp-item-faixa.cod-desp
                       tt-desp-item-aux.cod-itiner    = tt-desp-item-faixa.cod-itiner
                       tt-desp-item-aux.cod-pto-contr = tt-desp-item-faixa.cod-pto-contr
                       tt-desp-item-aux.exclui        = tt-desp-item-faixa.exclui.
                run validateCreate(input table tt-desp-item-aux,
                                   output table tt-bo-erro,
                                   output r-chave).
                delete tt-desp-item-aux.
            end.
            if tt-desp-item-faixa.cparam = "mod" then do:                            
                find desp-item where desp-item.it-codigo     = item.it-codigo and
                                     desp-item.cod-desp      = tt-desp-item-faixa.cod-desp and
                                     desp-item.cod-itiner    = tt-desp-item-faixa.cod-itiner and
                                     desp-item.cod-pto-contr = tt-desp-item-faixa.cod-pto-contr                                    
                                     no-lock no-error.
                if avail desp-item then do:
                    create tt-desp-item-aux.
                    assign tt-desp-item-aux.it-codigo     = item.it-codigo
                           tt-desp-item-aux.cod-desp      = tt-desp-item-faixa.cod-desp
                           tt-desp-item-aux.cod-itiner    = tt-desp-item-faixa.cod-itiner
                           tt-desp-item-aux.cod-pto-contr = tt-desp-item-faixa.cod-pto-contr
                           tt-desp-item-aux.exclui        = tt-desp-item-faixa.exclui.
                    run validateUpdate(input table tt-desp-item-aux,
                                       input rowid(desp-item),
                                       output table tt-bo-erro).
                    delete tt-desp-item-aux.
                end.                                   
            end.
            if tt-desp-item-faixa.cparam = "del" then do:
                find desp-item where desp-item.it-codigo     = item.it-codigo and
                                     desp-item.cod-desp      = tt-desp-item-faixa.cod-desp and
                                     desp-item.cod-itiner    = tt-desp-item-faixa.cod-itiner and
                                     desp-item.cod-pto-contr = tt-desp-item-faixa.cod-pto-contr
                                     no-lock no-error.
                if avail desp-item then do:
                    assign r-chave = rowid(desp-item).
                    run validateDelete(input-output r-chave,output table tt-bo-erro).
                end.
            end.
            for each tt-bo-erro:
                create tt-bo-erro-aux.
                buffer-copy tt-bo-erro to tt-bo-erro-aux.
            end.
        end.

end procedure.

procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.

    case c-field:
        when "it-codigo"     then c-value = RowObject.it-codigo.
        when "char-1"        then c-value = RowObject.char-1.
        when "char-2"        then c-value = RowObject.char-2.
        when "check-sum"     then c-value = RowObject.check-sum.
        otherwise return error.
    end case.
end procedure.

procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.

    case c-field:
        when "dec-1"        then c-value = RowObject.dec-1.
        when "dec-2"        then c-value = RowObject.dec-2.
        otherwise return error.
    end case.
end procedure.

procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.

    case c-field:
        when "cod-itiner"    then c-value = RowObject.cod-itiner.
        when "cod-desp"      then c-value = RowObject.cod-desp.
        when "cod-pto-contr" then c-value = RowObject.cod-pto-contr.
        when "int-1"         then c-value = RowObject.int-1.
        when "int-2"         then c-value = RowObject.int-2.
        otherwise return error.
    end case.
end procedure.

procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.

    case c-field:
        when "data-1"     then c-value = RowObject.data-1.
        when "data-2"     then c-value = RowObject.data-2.
        otherwise return error.
    end case.
end procedure.

procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.

    case c-field:
        when "exclui"      then c-value = RowObject.exclui.
        when "log-1"       then c-value = RowObject.log-1.
        when "log-2"       then c-value = RowObject.log-2.
        otherwise return error.
    end case.
end procedure.
