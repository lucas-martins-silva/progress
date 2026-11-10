/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD103 2.00.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOAD103 MUT}
&ENDIF


/*
**  BOAD103.P
**
**  esp-doc - Especies de Documento
**
**  Ultima altera»’o : 02/04/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY esp-doc
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME esp-doc
 
{include/boini.i}
 
 
{adbo/boad103.i RowObject}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
DEFINE VAR c-cod-inicial as char no-undo. 
procedure setConstraint1:
 
end procedure.
procedure setConstraint2:
    def input parameter p-cod-inicial as char no-undo.    
    
    assign c-cod-inicial = p-cod-inicial.
end procedure.

def var c-cod-esp-ini   as char no-undo.
def var c-cod-esp-fin   as char no-undo.
def var c-descricao-ini as char no-undo.
def var c-descricao-fin as char no-undo.
def var i-ordena        as int  no-undo.

procedure setConstraint3:
   def input param p-cod-esp-ini   as char    no-undo.
   def input param p-cod-esp-fin   as char    no-undo.
   def input param p-descricao-ini as char    no-undo.
   def input param p-descricao-fin as char    no-undo.
   def input param p-ordena        as integer no-undo.

   assign c-cod-esp-ini   = p-cod-esp-ini
          c-cod-esp-fin   = p-cod-esp-fin
          c-descricao-ini = p-descricao-ini
          c-descricao-fin = p-descricao-fin
          i-ordena        = p-ordena.

end procedure.
 
procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock INDEXED-REPOSITION.
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME}
                        where esp-doc.cod-esp >= c-cod-inicial INDEXED-REPOSITION.
        when 3 then do:
            if i-ordena = 1 then do : 
               if   c-cod-esp-ini = c-cod-esp-fin then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                                where {&TABLE-NAME}.cod-esp    = c-cod-esp-ini   AND 
                                      {&TABLE-NAME}.descricao >= c-descricao-ini AND
                                      {&TABLE-NAME}.descricao <= c-descricao-fin     
                                      by {&TABLE-NAME}.cod-esp INDEXED-REPOSITION.
               else                       
                    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                                where {&TABLE-NAME}.cod-esp   >= c-cod-esp-ini   AND 
                                      {&TABLE-NAME}.cod-esp   <= c-cod-esp-fin   AND
                                      {&TABLE-NAME}.descricao >= c-descricao-ini AND
                                      {&TABLE-NAME}.descricao <= c-descricao-fin     
                                      by {&TABLE-NAME}.cod-esp INDEXED-REPOSITION.               
            end.
            if i-ordena = 2 then do :
               if  c-cod-esp-ini = c-cod-esp-fin then
                   open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                                where {&TABLE-NAME}.cod-esp    = c-cod-esp-ini   AND 
                                      {&TABLE-NAME}.descricao >= c-descricao-ini AND
                                      {&TABLE-NAME}.descricao <= c-descricao-fin      
                                      by {&TABLE-NAME}.descricao INDEXED-REPOSITION.
               else
                   open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                                where {&TABLE-NAME}.cod-esp   >= c-cod-esp-ini   AND 
                                      {&TABLE-NAME}.cod-esp   <= c-cod-esp-fin   AND
                                      {&TABLE-NAME}.descricao >= c-descricao-ini AND
                                      {&TABLE-NAME}.descricao <= c-descricao-fin      
                                      by {&TABLE-NAME}.descricao INDEXED-REPOSITION.
            end.
	 end.	
    end case.
    assign l-query = true
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
{include/boexecre.i}
{include/boexeupt.i}
{include/boexedel.i}
{include/bovalupt.i}
{include/bovaldel.i}
 
procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
 
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.
 
procedure findCodigo:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter c-cod-esp as char no-undo.
    def output parameter c-return as char no-undo.
 
    find esp-doc where
        esp-doc.cod-esp = c-cod-esp
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i mgadm {&TABLE-NAME} 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.
    end.
    else do:
       run setCurrent.
    end.
    run endMethod ("find").
end procedure.
 
procedure validateFields:
    /*
    **  Valida Fields
    */
    find first rowObject
        no-lock no-error.
 
    run startMethod ("validateFields").
    if rowObject.atual-estat = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-esp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.contabiliza = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.descricao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.emite-dup = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.estat-venda = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.usa-antec = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.usa-prev = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    run endMethod ("validateFields").
 
end procedure.
 
procedure validateCreate:
    /*
    **  Valida cria»’o da tabela/duplicidade de registro.
    */
    def input  parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.
 
    run initializeValidate.
    run startMethod ("validateCreate").
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
 
    find first rowObject
        no-lock no-error.
    if rowObject.atual-estat = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} atual-estat 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-esp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-esp 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.contabiliza = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} contabiliza 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.descricao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} descricao 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.emite-dup = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} emite-dup 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.estat-venda = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} estat-venda 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.usa-antec = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} usa-antec 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.usa-prev = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} usa-prev 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    find first tt-bo-erro
        no-lock no-error.
    if not available tt-bo-erro then do:
        find esp-doc where
            esp-doc.cod-esp = rowObject.cod-esp
            no-lock no-error.
        if avail esp-doc then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgadm {&TABLE-NAME} 1}
            run utp/ut-msgs.p (input "msg",
                               input 8,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 8
                   tt-bo-erro.mensagem     = return-value.
        end.
    end.
 
    run validateFields.
    find first tt-bo-erro
        no-lock no-error.
 
    if not avail tt-bo-erro then do:
       run executeCreate.
       assign r-chave = to-rowid(return-value).
    end.
 
    run endMethod ("validateCreate").
end procedure.
 
procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "check-sum" then c-value = RowObject.check-sum.
        when "cod-esp" then c-value = RowObject.cod-esp.
        when "descricao" then c-value = RowObject.descricao.
        when "esp-cob-esc" then c-value = RowObject.esp-cob-esc.
        when "esp-ligacao" then c-value = RowObject.esp-ligacao.
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
        when "cod-class-esp" then c-value = RowObject.cod-class-esp.
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "tipo" then c-value = RowObject.tipo.
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "data-1" then c-value = RowObject.data-1.
        when "data-2" then c-value = RowObject.data-2.
        otherwise return error.
    end case.
end procedure.
 
procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.
 
    case c-field:
        when "atual-estat" then c-value = RowObject.atual-estat.
        when "calc-var-cmi" then c-value = RowObject.calc-var-cmi.
        when "contabiliza" then c-value = RowObject.contabiliza.
        when "cot-emis-fasb" then c-value = RowObject.cot-emis-fasb.
        when "emite-dup" then c-value = RowObject.emite-dup.
        when "estat-venda" then c-value = RowObject.estat-venda.
        when "fluxo-caixa" then c-value = RowObject.fluxo-caixa.
        when "ind-abat-ft" then c-value = RowObject.ind-abat-ft.
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.
        when "usa-antec" then c-value = RowObject.usa-antec.
        when "usa-prev" then c-value = RowObject.usa-prev.
        otherwise return error.
    end case.
end procedure.
 

procedure lancamento:

/* Esta procedure verifica o sinal do lan»amento se ² "+" ou "-" de acordo com 
a transa»’o, lan»amento e tipo dos movimentos */

define input  parameter i-transacao   as integer no-undo.
define input  parameter i-lancamento  as integer no-undo.
define input  parameter c-codesp      as char    no-undo.
define output parameter c-sinal       as char format "x(01)" no-undo.
       
    assign c-sinal = " ".   
       
    find esp-doc where esp-doc.cod-esp = c-codesp no-lock no-error.       
        
    if  avail esp-doc then do:
    
        if i-transacao = 13 then do:
              if (esp-doc.tipo = 1  or
                  esp-doc.tipo = 4  or
                  esp-doc.tipo = 6  or
                  esp-doc.tipo = 7  or
                  esp-doc.tipo = 9  ) then do:
                  if (i-lancamento = 2) then 
                     assign c-sinal = "+".               
                  else 
                     if (i-lancamento = 1) then 
                         assign c-sinal = "-".
              end.           
              else do:              
                   if (esp-doc.tipo = 2  or esp-doc.tipo = 5) then do:                   
                      if (i-lancamento = 2)  then 
                          assign c-sinal = "-".
                      else  
                         if (i-lancamento = 1) then 
                            assign c-sinal = "+".                                                        
                   end.    
              end.
        end.
                
        if i-transacao = 18 then do:
              if (esp-doc.tipo = 4)  then 
                  assign c-sinal = "-".               
              else do:
                   if (esp-doc.tipo = 5) then 
                      assign c-sinal = "+".
              end.
        end.
           
        if (i-transacao = 14 or i-transacao = 4) then
             assign c-sinal = "+".
        

        if (i-transacao = 2  or
            i-transacao = 3  or
            i-transacao = 21 or
            i-transacao = 22 or
            i-transacao = 23) then
               assign c-sinal = "-".
        if (i-transacao = 1 and esp-doc.tipo = 2) then
            assign c-sinal = "-".      
    end.

end procedure
