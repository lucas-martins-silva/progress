/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD142 2.00.00.010}  /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOAD142 MUT}
&ENDIF


/*
**  BOAD142.P
**
**  hist-padrao - Cadastro de Historicos Padronizados
**
**  Ultima altera‡Æo : 02/04/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY hist-padrao
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME hist-padrao
 
{include/boini.i}
 
{adbo/boad142.i RowObject}

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

def var c-inicial as char no-undo.
def var c-final as char no-undo.

procedure setConstraint2:
def input parameter p-inicial as char no-undo.
assign c-inicial = p-inicial. 
end procedure.

procedure setConstraint3:
def input parameter p-inicial as char no-undo.
def input parameter p-final as char no-undo.

assign c-inicial = p-inicial
       c-final = p-final. 
end procedure.

def var i-hp-codigo-ini as int  no-undo.
def var i-hp-codigo-fin as int  no-undo.
def var c-descricao-ini as char no-undo.
def var c-descricao-fin as char no-undo.
def var i-ordena        as int  no-undo.

procedure setConstraint4:
   def input param p-hp-codigo-ini as integer no-undo.
   def input param p-hp-codigo-fin as integer no-undo.
   def input param p-descricao-ini as char    no-undo.
   def input param p-descricao-fin as char    no-undo.
   def input param p-ordena        as integer no-undo.

   assign i-hp-codigo-ini = p-hp-codigo-ini
          i-hp-codigo-fin = p-hp-codigo-fin
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
                                     hist-padrao.hp-codigo >= int(c-inicial) INDEXED-REPOSITION.
        when 3 then
            if int(c-inicial) = int(c-final) then
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                         hist-padrao.hp-codigo = int(c-inicial) no-lock by hist-padrao.hp-codigo INDEXED-REPOSITION. 
            else
                open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                         hist-padrao.hp-codigo >= int(c-inicial) and~
                                         hist-padrao.hp-codigo <= int(c-final) no-lock by hist-padrao.hp-codigo INDEXED-REPOSITION. 
        when 4 then do:
            if i-ordena = 1 then do : 
               if i-hp-codigo-ini = i-hp-codigo-fin then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                                where {&TABLE-NAME}.hp-codigo  = i-hp-codigo-ini  AND
                                      {&TABLE-NAME}.descricao >= c-descricao-ini  AND
                                      {&TABLE-NAME}.descricao <= c-descricao-fin      
                                      by {&TABLE-NAME}.hp-codigo INDEXED-REPOSITION.
               else
                    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                                where {&TABLE-NAME}.hp-codigo  >= i-hp-codigo-ini AND 
                                      {&TABLE-NAME}.hp-codigo  <= i-hp-codigo-fin AND
                                      {&TABLE-NAME}.descricao >= c-descricao-ini  AND
                                      {&TABLE-NAME}.descricao <= c-descricao-fin      
                                      by {&TABLE-NAME}.hp-codigo INDEXED-REPOSITION.
            end.
            if i-ordena = 2 then do :
               if  i-hp-codigo-ini = i-hp-codigo-fin then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                                where {&TABLE-NAME}.hp-codigo  = i-hp-codigo-ini AND 
                                      {&TABLE-NAME}.descricao >= c-descricao-ini  AND
                                      {&TABLE-NAME}.descricao <= c-descricao-fin      
                                      by {&TABLE-NAME}.descricao INDEXED-REPOSITION.

               else
                    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                                where {&TABLE-NAME}.hp-codigo  >= i-hp-codigo-ini AND 
                                      {&TABLE-NAME}.hp-codigo  <= i-hp-codigo-fin AND
                                      {&TABLE-NAME}.descricao >= c-descricao-ini  AND
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
 
{adbo/boad142.i1} /* procedure findCodigo - utilizada pelo EMS e pelo Magnus */

&if defined(bf-mat-comex) &then            
&else
    procedure findhist:
        /*
        **  Procura pelo indice, caso nao ache,
        **  retorna mensagem de erro padrao do EMS.
        */
        run startMethod ("find").    
        def input parameter p-hp-codigo as int no-undo.
        def output parameter c-return   as char no-undo.
         
        find hist-padrao where
            hist-padrao.hp-codigo = p-hp-codigo        
            no-lock no-error.
        if not avail {&TABLE-NAME} then do:
            {utp/ut-table.i movadm {&TABLE-NAME} 1}
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
        if rowObject.complemento = ? then do:
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
     
        if rowObject.hp-codigo = ? then do:
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
        if rowObject.complemento = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} complemento 1}
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
     
        if rowObject.hp-codigo = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} hp-codigo 1}
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
            find hist-padrao where
                hist-padrao.hp-codigo = rowObject.hp-codigo
                no-lock no-error.
            if avail hist-padrao then do:
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
        when "descricao" then c-value = RowObject.descricao.
        &if defined(bf-mat-comex) &then            
            when "complemento" then c-value = RowObject.complemento.        
            when "u-char-1" then c-value = RowObject.u-char-1.
            when "u-char-2" then c-value = RowObject.u-char-2.                
        &else
            when "check-sum" then c-value = RowObject.check-sum.        
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
        when "hp-codigo" then c-value = RowObject.hp-codigo.
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        &if defined(bf-mat-comex) &then            
            when "u-int-1" then c-value = RowObject.u-int-1.
            when "u-int-2" then c-value = RowObject.u-int-2.        
        &else
            when "complemento" then c-value = RowObject.complemento.        
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
        when "log-1" then c-value = RowObject.log-1.
        &if defined(bf-mat-comex) &then            
            when "u-log-1" then c-value = RowObject.u-log-1.                
        &else
            when "log-2" then c-value = RowObject.log-2.        
        &endif        
        otherwise return error.
    end case.
end procedure.
 
