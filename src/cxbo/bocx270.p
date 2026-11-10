/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX270 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX270 MUT}
&ENDIF

/*
**  BOCX270.P
**
**  decl-itiner - Cadastro de Declaraá‰es Padr∆o
**
**  Ultima alteraá∆o : bre18074 - 12/05/1999 
*/ 
 
&scoped-define BOVERSION 1.1
&scoped-define CONDICAO /* decl-itiner.cod-itiner = i-cod-itiner and decl-itiner.cod-pto-contr = i-cod-pto-contr ~ */
&scoped-define FIRST-TABLE-IN-QUERY decl-itiner
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME decl-itiner
&scoped-define OPEN-QUERY ~
  open query {&QUERY-NAME} for each {&TABLE-NAME} of pto-itiner where {&CONDICAO} by decl-itiner.de-codigo.
  
{include/boini.i}
 
{cxbo/bocx270.i RowObject}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
 
DEF var i-moeda-p       as integer no-undo.

DEF var i-cod-itiner    as integer no-undo.
DEF var i-cod-pto-contr as integer no-undo.
 
procedure setConstraint:
    /* def input parameter p-de-codigo as char no-undo. */
    def input parameter r-chave as rowid no-undo.
    find pto-itiner no-lock where rowid(pto-itiner) = r-chave no-error.

    /*if avail pto-itiner then do:
      assign i-cod-itiner    = pto-itiner.cod-itiner
             i-cod-pto-contr = pto-itiner.cod-pto-contr.
    end.*/

end procedure.
 
  
procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    assign l-query = yes.
    case i-abertura:
        when 1 then        
          open query {&QUERY-NAME} for each {&TABLE-NAME} of pto-itiner by decl-itiner.de-codigo.
    end case.
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
/*{include/bovalupt.i}*/
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
    def input parameter i-cod-itiner as integer no-undo.
    def input parameter i-cod-pto-contr as integer no-undo.
    def input parameter i-de-codigo as integer no-undo.
    def output parameter table for RowObject.
 
    find decl-itiner where
        decl-itiner.cod-itiner    = i-cod-itiner and
        decl-itiner.cod-pto-contr = i-cod-pto-contr and
        decl-itiner.de-codigo     = i-de-codigo
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

procedure findDeclItiner:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter i-cod-itiner as integer no-undo.
    def input parameter i-cod-pto-contr as integer no-undo.
    def output parameter table for RowObject.
 
    find first decl-itiner where
        decl-itiner.cod-itiner    = i-cod-itiner and
        decl-itiner.cod-pto-contr = i-cod-pto-contr
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
    
    find first rowObject 
         no-lock no-error.    
    
    run validateFields.    
    
    find first tt-bo-erro
        no-lock no-error.
    if not avail tt-bo-erro then do:
        find {&TABLE-NAME} where
            rowid({&TABLE-NAME}) = r-chave            
            exclusive-lock no-error no-wait.

        if locked({&table-name}) then do:
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
	    if avail {&table-name} then
                run executeUpdate.            
    end.
    
end procedure.
 
procedure validateFields:   

    if rowObject.emite-decl-docum = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&table-name} emite-decl-docum 1}
        run utp/ut-msgs.p(input "msg",
                          input 265,
                          input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 265
               tt-bo-erro.mensagem = return-value.                            
    end.

end procedure.
 
procedure validateCreate:
    /*
    **  Valida criaá∆o da tabela/duplicidade de registro.
    */
    def input  parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.
 
    run initializeValidate.
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
 
    find first rowObject no-error.            
            
    if rowObject.cod-itiner = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-itiner 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
    else 
        if not can-find(itinerario where itinerario.cod-itiner = rowObject.cod-itiner) then do:      
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgcex {&TABLE-NAME} cod-itiner 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
        else
            if rowObject.cod-pto-contr = 0 then do:
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-field.i mgcex {&TABLE-NAME} cod-pto-contr 1}
                run utp/ut-msgs.p (input "msg",
                                   input 265,
                                   input return-value).
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 265
                       tt-bo-erro.mensagem     = return-value.
            end.
            else 
                if not can-find(pto-itiner where pto-itiner.cod-itiner    = rowObject.cod-itiner and
                                                 pto-itiner.cod-pto-contr = rowObject.cod-pto-contr) then do:      
                    assign i-seq-erro = i-seq-erro + 1.
                    {utp/ut-field.i mgcex {&TABLE-NAME} cod-pto-contr 1}
                    run utp/ut-msgs.p (input "msg",
                                        input 265,
                                       input return-value).
                    create tt-bo-erro.
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 265
                           tt-bo-erro.mensagem     = return-value.
                end.
        
    if rowObject.de-codigo = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} de-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
    else do: 
        if not can-find(decl-padrao where decl-padrao.de-codigo = rowObject.de-codigo) then do:      
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgcex decl-padrao 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.
        end.
        else do:
             if not can-find(first decl-cliente where 
                             decl-cliente.de-codigo = rowObject.de-codigo and
                             decl-cliente.cod-emitente = 0) then do:
                assign i-seq-erro = i-seq-erro + 1.             
                {utp/ut-table.i mgcex decl-padrao 1}
                run utp/ut-msgs.p (input "msg",
                                   input 18879,
                                   input return-value + "~~" + "0").
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 18879
                       tt-bo-erro.mensagem     = return-value.             
             end.                                                 
        end.     
    end.    
                
        
    run validateFields.             
    
    if can-find(first {&TABLE-NAME} where
                      {&TABLE-NAME}.cod-itiner      = rowObject.cod-itiner and
                      {&TABLE-NAME}.cod-pto-contr   = rowObject.cod-pto-contr and
                      {&TABLE-NAME}.de-codigo       = rowObject.de-codigo) then do:
       assign i-seq-erro = i-seq-erro + 1.
       {utp/ut-table.i mgcex decl-itiner 1}
       run utp/ut-msgs.p (input "msg",
                          input 8,
                          input return-value).
       create tt-bo-erro.
       assign tt-bo-erro.i-sequen     = i-seq-erro
              tt-bo-erro.cd-erro      = 8
              tt-bo-erro.mensagem     = return-value.
    end.
            
    find first tt-bo-erro
        no-lock no-error.        
 
    if not avail tt-bo-erro then do:
         run executeCreate.
         assign r-chave = to-rowid(return-value).
    end. 	
	
end procedure.

procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
    case c-field:
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "check-sum" then c-value = RowObject.check-sum.
        when "destinatario-outros" then c-value = RowObject.destinatario-outros.
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
		when "cod-pto-contr" then c-value = RowObject.cod-pto-contr.    
        when "dias-tolerancia" then c-value = RowObject.dias-tolerancia.
        when "emite-decl-docum" then c-value = RowObject.emite-decl-docum.
        when "int-1" then c-value = RowObject.int-1.
		when "int-2" then c-value = RowObject.int-2.
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
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.
        otherwise return error.
    end case.
end procedure.
