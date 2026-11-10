/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN244 2.00.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN244 MUT}
&ENDIF

/*
**  BOIN244.P
**
**  narrativa - Narrativas dos Itens
**
**  Ultima altera‡Æo : 02/04/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY narrativa
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME narrativa
 
{include/boini.i}
 
{inbo/boin244.i RowObject}

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

def var c-it-codigo as char no-undo.

procedure setConstraint2:
def input parameter p-it-codigo as char no-undo.
assign c-it-codigo = p-it-codigo. 
end procedure.
 
procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock INDEXED-REPOSITION.
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock where
                                     narrativa.it-codigo >= c-it-codigo INDEXED-REPOSITION.
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
 
{inbo/boin244.i1} /* procedure findCodigo - utilizada pelos produtos Magnus e EMS */

&if defined(bf-mat-comex) &then            
    procedure retornaNarrativa:
        /* Procura pelo item e retorna a narrativa do item para o magnus, 
           foi customizado para o magnus, pois a narrativa do item no magnus
           ‚ uma vari vel "extent" */

       def input  parameter c-it-codigo as char no-undo. 
       def output parameter c-descricao as char  no-undo.
       def var cont as int no-undo initial 1.
       
       find {&TABLE-NAME} where {&TABLE-NAME}.it-codigo = c-it-codigo no-lock no-error.
        if avail {&TABLE-NAME} then do:
           do cont = 1 to 5: 
              assign c-descricao = c-descricao + {&TABLE-NAME}.descricao[cont].
           end.
        end.
    end.
&else 
    procedure findNarrativa:
        /*
        **  Procura pelo indice, caso nao ache,
        **  retorna mensagem de erro padrao do EMS.
        */
        run startMethod ("find").
        def input  parameter p-rowid     as rowid no-undo. 
        def output parameter c-return    as char  no-undo.
    
    
     find prazo-compra where rowid(prazo-compra) = p-rowid no-lock no-error.
     if avail prazo-compra then do: 
       find ordem-compra where ordem-compra.numero-ordem = prazo-compra.numero-ordem no-lock no-error.
       find item where ordem-compra.it-codigo = item.it-codigo no-lock no-error.
       find narrativa where narrativa.it-codigo = item.it-codigo no-lock no-error.
        if not avail {&TABLE-NAME} then do:
            {utp/ut-table.i mgind {&TABLE-NAME} 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            assign c-return = return-value.
        end.
        else do:
           run setCurrent.
        end.
        run endMethod ("find").
    end.
    end procedure.
    
    procedure validateFields:
        /*
        **  Valida Fields
        */
        find first rowObject
            no-lock no-error.
     
        run startMethod ("validateFields").
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
     
        if rowObject.it-codigo = ? then do:
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
        if rowObject.descricao = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgind {&TABLE-NAME} descricao 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.it-codigo = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgind {&TABLE-NAME} it-codigo 1}
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
            find narrativa where
                narrativa.it-codigo = rowObject.it-codigo
                no-lock no-error.
            if avail narrativa then do:
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-table.i mgind {&TABLE-NAME} 1}
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
        when "it-codigo" then c-value = RowObject.it-codigo.
        &if defined(bf-mat-comex) &then   
            when "descricao[1]" then c-value = RowObject.descricao[1].
            when "descricao[2]" then c-value = RowObject.descricao[2].
            when "descricao[3]" then c-value = RowObject.descricao[3].
            when "descricao[4]" then c-value = RowObject.descricao[4].
            when "descricao[5]" then c-value = RowObject.descricao[5].        
            when "u-char-1" then c-value = RowObject.u-char-1.                         
        &else 
            when "char-2" then c-value = RowObject.char-2.
            when "check-sum" then c-value = RowObject.check-sum.        
            when "descricao" then c-value = RowObject.descricao.            
        &endif        
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "dec-1" then c-value = RowObject.dec-1.
        &if defined(bf-mat-comex) &then            
        &else         
            when "dec-2" then c-value = RowObject.dec-2.
        &endif
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "int-1" then c-value = RowObject.int-1.
        &if defined(bf-mat-comex) &then            
        &else         
            when "int-2" then c-value = RowObject.int-2.
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
 
