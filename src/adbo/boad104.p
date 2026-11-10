/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD104 2.00.00.012}  /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOAD104 MUT}
&ENDIF


/*
**  BOAD104.P
**
**  espec-ap - Espécies de Documentos do Contas a Pagar
**
**  Ultima altera‡Æo : 02/04/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY espec-ap
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME espec-ap
 
{include/boini.i}
 
{adbo/boad104.i RowObject}

/******************************ATENCAO*************************************
 Pre-processador abaixo responsavel por distinguir o produto que
 esta executando o componente ( Magnus ou EMS ). 
 Se estiver definida a variavel bf-mat-comex 
 ( &if defined(bf-mat-comex) &then ), significa que o produto
 chamador e o Magnus se nÆo, EMS. Utilizado pelo produto Comercio Exterior
**************************************************************************/ 
{cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */ 

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
 
procedure setConstraint1:
 
end procedure.

def var c-cod-esp-ini as char no-undo.
def var c-cod-esp-fin as char no-undo.
def var c-descricao-ini as char no-undo.
def var c-descricao-fin as char no-undo.
def var i-ordena        as int  no-undo.

procedure setConstraint2:
def input param p-cod-esp-ini as char no-undo.
assign c-cod-esp-ini = p-cod-esp-ini.
end procedure.

procedure setConstraint3:
def input param p-cod-esp-ini as char no-undo.
def input param p-cod-esp-fin as char no-undo.

assign c-cod-esp-ini = p-cod-esp-ini
       c-cod-esp-fin = p-cod-esp-fin.
end procedure.

procedure setConstraint4:
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
            open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                     espec-ap.cod-esp >= c-cod-esp-ini INDEXED-REPOSITION.
        when 3 then
            if  c-cod-esp-ini = c-cod-esp-fin then
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                         espec-ap.cod-esp = c-cod-esp-ini no-lock by espec-ap.cod-esp INDEXED-REPOSITION.
            else
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                         espec-ap.cod-esp >= c-cod-esp-ini and~
                                         espec-ap.cod-esp <= c-cod-esp-fin no-lock by espec-ap.cod-esp INDEXED-REPOSITION.
        when 4 then do:
            if i-ordena = 1 then do : 
               if c-cod-esp-ini = c-cod-esp-fin then
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

{adbo/boad104.i1} /* procedure findEspecie - utilizada no Magnus e no EMS */

&if defined(bf-mat-comex) &then            
&else
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
     
        if rowObject.emite-ap = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.tipo = ? then do:
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
     
        if rowObject.usa-previsao = ? then do:
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
        **  Valida cria‡Æo da tabela/duplicidade de registro.
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
     
        if rowObject.emite-ap = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} emite-ap 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.tipo = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} tipo 1}
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
     
        if rowObject.usa-previsao = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} usa-previsao 1}
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
            find espec-ap where
                espec-ap.cod-esp = rowObject.cod-esp
                no-lock no-error.
            if avail espec-ap then do:
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
&endif    
 
procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "cod-esp" then c-value = RowObject.cod-esp.
        when "descricao" then c-value = RowObject.descricao.
        &if defined(bf-mat-comex) &then            
            when "tipo" then c-value = RowObject.tipo.        
            when "u-char-1" then c-value = RowObject.u-char-1.
            when "u-char-2" then c-value = RowObject.u-char-2.
        &else
            when "check-sum" then c-value = RowObject.check-sum.        
            when "esp-ligacao" then c-value = RowObject.esp-ligacao.            
        &endif
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        &if defined(bf-mat-comex) &then                    
            when "u-dec-1" then c-value = RowObject.u-dec-1.
            when "u-dec-2" then c-value = RowObject.u-dec-2.                
        &else
        &endif
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        &if defined(bf-mat-comex) &then            
            when "u-int-1" then c-value = RowObject.u-int-1.
            when "u-int-2" then c-value = RowObject.u-int-2.                
        &else
            when "cod-class-esp" then c-value = RowObject.cod-class-esp.        
            when "tipo" then c-value = RowObject.tipo.            
        &endif        
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        &if defined(bf-mat-comex) &then            
        &else    
            when "data-1" then c-value = RowObject.data-1.
            when "data-2" then c-value = RowObject.data-2.
        &endif
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
        when "emite-ap" then c-value = RowObject.emite-ap.
        when "emite-bord" then c-value = RowObject.emite-bord.
        when "fluxo-caixa" then c-value = RowObject.fluxo-caixa.
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.
        when "usa-antec" then c-value = RowObject.usa-antec.
        when "usa-previsao" then c-value = RowObject.usa-previsao.
        &if defined(bf-mat-comex) &then            
            when "u-log-1" then c-value = RowObject.u-log-1.                
        &else    
            when "usa-cot-emi-fasb" then c-value = RowObject.usa-cot-emi-fasb.        
        &endif        
        otherwise return error.
    end case.
end procedure.
 
Procedure Lancamento:

    /* Esta procedure verifica o sinal do lan‡amento se ‚ "+" ou "-" de acordo com 
    a transa‡Æo, lan‡amento e tipo dos movimentos */
    
    &if defined(bf-mat-comex) &then
    &else
    
        define input  parameter i-transacao   as integer no-undo.
        define input  parameter i-lancamento  as integer no-undo.
        define input  parameter c-codesp      as char    no-undo.
        define output parameter c-sinal       as char format "x(01)" no-undo.
        
        assign c-sinal = " ".
        
        find espec-ap where espec-ap.cod-esp = c-codesp no-lock no-error.
        
        if  avail espec-ap then do:
            
            if  espec-ap.tipo = 2
            or  espec-ap.tipo = 3
            or  espec-ap.tipo = 5
            or  espec-ap.tipo = 10 then do:
                if  i-transacao = 1
                or (i-transacao = 5 and i-lancamento = 2) then
                    assign c-sinal = "+".
                if (i-transacao = 2)
                or (i-transacao = 3)
                or (i-transacao = 5 and i-lancamento = 1) then
                    assign c-sinal = "-".
            end.
            
            if  espec-ap.tipo = 1
            or  espec-ap.tipo = 4
            or  espec-ap.tipo = 7
            or  espec-ap.tipo = 8
            or  espec-ap.tipo = 9 then do:
                
                if  i-transacao = 1
                or (i-transacao = 5 and i-lancamento = 1)
                or (i-transacao = 6 and i-lancamento = 2) then
                    assign c-sinal = "+".
                if  i-transacao = 2
                or (i-transacao = 5 and i-lancamento = 2)
                or (i-transacao = 6 and i-lancamento = 1) then
                    assign c-sinal = "-".
            end.
            
            if  i-transacao = 16 then do:
                case espec-ap.tipo:
                    when 4 then assign c-sinal = "+".
                    when 5 then assign c-sinal = "-".
                end case.
            end.
            
        end.
    &endif
    
End Procedure. /* Lancamento */
