/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD176 2.00.00.011}  /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOAD176 MUT}
&ENDIF


/*
**  BOAD176.P
**
**  mensagem - Arquivo de Mensagens
**
**  Ultima altera‡Æo : 02/04/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY mensagem
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME mensagem
 
{include/boini.i}
 
{adbo/boad176.i RowObject}

/******************************ATENCAO*************************************
 Pre-processador abaixo responsavel por distinguir o produto que
 esta executando o componente ( Magnus ou EMS ). 
 Se estiver definida a variavel bf-mat-comex 
 ( &if defined(bf-mat-comex) &then ), significa que o produto
 chamador e o Magnus se nÆo, EMS. Utilizado pelo produto Comercio Exterior
**************************************************************************/ 
{cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
 def var i-cod-ini as integer no-undo.
 def var i-cod-fin as integer no-undo.
def var i-cod-mensagem as integer no-undo.

procedure setConstraint1:
 def input param p-cod-inicial as char no-undo.
 assign i-cod-mensagem = integer(p-cod-inicial).
end procedure.
 
procedure setConstraint2:
 def input param p-cod-inicial as char no-undo.
 def input param p-cod-final as char no-undo.
 assign i-cod-ini = integer(p-cod-inicial)
        i-cod-fin = integer(p-cod-final).
end procedure. 

def var i-cod-mensagem-ini as int  no-undo.
def var i-cod-mensagem-fin as int  no-undo.
def var c-descricao-ini    as char no-undo.
def var c-descricao-fin    as char no-undo.
def var i-ordena           as int  no-undo.

procedure setConstraint3:
   def input param p-cod-mensagem-ini as integer no-undo.
   def input param p-cod-mensagem-fin as integer no-undo.
   def input param p-descricao-ini    as char    no-undo.
   def input param p-descricao-fin    as char    no-undo.
   def input param p-ordena           as integer no-undo.

   assign i-cod-mensagem-ini = p-cod-mensagem-ini
          i-cod-mensagem-fin = p-cod-mensagem-fin
          c-descricao-ini    = p-descricao-ini
          c-descricao-fin    = p-descricao-fin
          i-ordena           = p-ordena.
end procedure.
 
procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where {&TABLE-NAME}.cod-mensagem >= i-cod-mensagem no-lock INDEXED-REPOSITION. 
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where {&TABLE-NAME}.cod-mensagem >= i-cod-ini and ~
                                                                  {&TABLE-NAME}.cod-mensagem <= i-cod-fin no-lock INDEXED-REPOSITION. 
        when 3 then do:
            if i-ordena = 1 then do : 
               open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                           where {&TABLE-NAME}.cod-mensagem  >= i-cod-mensagem-ini AND 
                                 {&TABLE-NAME}.cod-mensagem  <= i-cod-mensagem-fin AND
                                 {&TABLE-NAME}.descricao     >= c-descricao-ini    AND
                                 {&TABLE-NAME}.descricao     <= c-descricao-fin      
                                 by {&TABLE-NAME}.cod-mensagem INDEXED-REPOSITION.
            end.
            if i-ordena = 2 then do :
               open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                           where {&TABLE-NAME}.cod-mensagem  >= i-cod-mensagem-ini AND 
                                 {&TABLE-NAME}.cod-mensagem  <= i-cod-mensagem-fin AND
                                 {&TABLE-NAME}.descricao     >= c-descricao-ini    AND
                                 {&TABLE-NAME}.descricao     <= c-descricao-fin      
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
    def input parameter i-cod-mensagem as inte no-undo.
    def output parameter c-return as char no-undo.
 
    find mensagem where
        mensagem.cod-mensagem = i-cod-mensagem
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

&if defined(bf-mat-comex) &then            
&else       
   procedure validateFields:
       /*
       **  Valida Fields
       */
       find first rowObject
           no-lock no-error.
    
       run startMethod ("validateFields").
       if rowObject.cod-mensagem = ? then do:
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
    
       if rowObject.texto-mensag = ? then do:
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
       if rowObject.cod-mensagem = ? then do:
           assign i-seq-erro = i-seq-erro + 1.
           {utp/ut-field.i mgadm {&TABLE-NAME} cod-mensagem 1}
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
    
       if rowObject.texto-mensag = ? then do:
           assign i-seq-erro = i-seq-erro + 1.
           {utp/ut-field.i mgadm {&TABLE-NAME} texto-mensag 1}
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
           find mensagem where
               mensagem.cod-mensagem = rowObject.cod-mensagem
               no-lock no-error.
           if avail mensagem then do:
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
            when "texto-mensag[1]" then c-value = RowObject.texto-mensag[1].
            when "texto-mensag[2]" then c-value = RowObject.texto-mensag[2].
            when "texto-mensag[3]" then c-value = RowObject.texto-mensag[3].
            when "texto-mensag[4]" then c-value = RowObject.texto-mensag[4].
            when "texto-mensag[5]" then c-value = RowObject.texto-mensag[5].        
            when "u-char-1" then c-value = RowObject.u-char-1.
            when "u-char-2" then c-value = RowObject.u-char-2.                
        &else
            when "check-sum" then c-value = RowObject.check-sum.        
            when "texto-mensag" then c-value = RowObject.texto-mensag.            
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
        when "cod-mensagem" then c-value = RowObject.cod-mensagem.
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        &if defined(bf-mat-comex) &then                    
            when "u-int-1" then c-value = RowObject.u-int-1.
            when "u-int-2" then c-value = RowObject.u-int-2.
        &else
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
        &else
            when "log-2" then c-value = RowObject.log-2.        
        &endif        
        otherwise return error.
    end case.
end procedure.
 
