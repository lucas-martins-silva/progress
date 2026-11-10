/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX130 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX130 MUT}
&ENDIF

/*
**  BOCX130.P
**
**  incoterm-itiner - 
**
**  Ultima altera‡Æo: 04/05/99 - GeraBO
**  Ultima altera‡Æo: 05/05/99 - brv9586
*/

def var i-cod-itiner as integer no-undo.
 
&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY incoterm-itiner
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME incoterm-itiner
 
 
{include/boini.i}
 
{cxbo/bocx130.i RowObject}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
 
procedure setConstraint1:

end procedure.

procedure setConstraint2:

 def input parameter c-cod-itiner as char.
    
 assign i-cod-itiner = int(c-cod-itiner).

end procedure.

procedure setConstraint3:
    def input parameter r-chave as rowid no-undo.
    
    find pto-itiner no-lock where rowid(pto-itiner) = r-chave no-error.

end procedure.

 
procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then      
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
        when 2 then  
            open query {&QUERY-NAME} for each {&TABLE-NAME} where incoterm-itiner.cod-itiner >= i-cod-itiner no-lock.
        when 3 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} of pto-itiner where  incoterm-itiner.cod-itiner >= i-cod-itiner no-lock by incoterm-itiner.cod-itiner.
      
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
    run startMethod ("find").
    def input parameter i-cod-itiner as inte no-undo.
    def input parameter i-cod-pto-contr as inte no-undo.
    def input parameter c-cod-incoterm as char no-undo.
    def output parameter c-return as char no-undo.
 
    find incoterm-itiner where
        incoterm-itiner.cod-itiner = i-cod-itiner
        and incoterm-itiner.cod-pto-contr = i-cod-pto-contr
        and incoterm-itiner.cod-incoterm = c-cod-incoterm
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
    run endMethod ("find").
end procedure.

procedure validateUpdate:
    /*
    **  Valida Update
    */
    
    def input parameter table for RowObject.
    def input parameter r-chave as rowid no-undo.
    def output parameter table for tt-bo-erro.
 
    run startmethod ("ValidateUpdate").
    run InitializeValidate.
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.

    run validateFields. 
    find first rowObject no-lock no-error.   
    
    find {&TABLE-NAME} where rowid({&TABLE-NAME}) = r-chave no-lock no-error.
    if {&TABLE-NAME}.cod-itiner <> rowObject.cod-itiner then do:
       assign i-seq-erro = i-seq-erro + 1.
       {utp/ut-field.i mgcex incoterm-itiner cod-itiner 1}
       run utp/ut-msgs.p (input "msg",
                          input 16913,
                          input return-value).
       create tt-bo-erro.
       assign tt-bo-erro.i-sequen     = i-seq-erro
              tt-bo-erro.cd-erro      = 16913
              tt-bo-erro.mensagem     = return-value.                    
    end.        
    
/*    if {&TABLE-NAME}.cod-incoterm <> rowObject.cod-incoterm then do:
 *        assign i-seq-erro = i-seq-erro + 1.
 *        {utp/ut-field.i mgcex incoterm-itiner cod-incoterm 1}
 *        run utp/ut-msgs.p (input "msg",
 *                           input 16913,
 *                           input return-value).
 *        create tt-bo-erro.
 *        assign tt-bo-erro.i-sequen     = i-seq-erro
 *               tt-bo-erro.cd-erro      = 16913
 *               tt-bo-erro.mensagem     = return-value.                    
 *     end. */       
    
    if {&TABLE-NAME}.cod-pto-contr <> rowObject.cod-pto-contr then do:
       assign i-seq-erro = i-seq-erro + 1.
       {utp/ut-field.i mgcex incoterm-itiner cod-pto-contr 1}
       run utp/ut-msgs.p (input "msg",
                          input 16913,
                          input return-value).
       create tt-bo-erro.
       assign tt-bo-erro.i-sequen     = i-seq-erro
              tt-bo-erro.cd-erro      = 16913
              tt-bo-erro.mensagem     = return-value.                    
    end.           
    
    find first tt-bo-erro
        no-lock no-error.
    if not avail tt-bo-erro then do:
        find {&TABLE-NAME} where
            rowid({&TABLE-NAME}) = r-chave
            exclusive-lock no-error.
        run executeUpdate.
    end.
    
  run startmethod ("ValidateUpdate").   
        
end procedure.
 
 
procedure validateFields:
    /*
    **  Valida Fields
    */
    find first rowObject
        no-lock no-error.
 
    run startMethod ("validateFields").

    if rowObject.cod-incoterm = "" or rowObject.cod-incoterm = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&table-name} cod-incoterm }
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.

    end.

    if rowObject.cod-itiner = 0 or rowObject.cod-itiner = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&table-name} cod-itiner }
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.cod-pto-contr = 0 or rowObject.cod-pto-contr = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&table-name} cod-pto-contr }
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
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
        
    find inco-cx where inco-cx.cod-incoterm = rowObject.cod-incoterm no-lock no-error.
    if not avail inco-cx then do:
       {utp/ut-table.i mgcex inco-cx  1}        
       assign i-seq-erro = i-seq-erro + 1.
       run utp/ut-msgs.p (input "msg",
                          input 2,
                          input return-value).
       create tt-bo-erro.
       assign tt-bo-erro.i-sequen = i-seq-erro
              tt-bo-erro.cd-erro  = 2
              tt-bo-erro.mensagem = return-value.
    end.                          
    
    find itinerario where itinerario.cod-itiner = rowObject.cod-itiner no-lock no-error.
    if not avail itinerario then do:
       {utp/ut-table.i mgcex itinerario  1}        
       assign i-seq-erro = i-seq-erro + 1.
       run utp/ut-msgs.p (input "msg",
                          input 2,
                          input return-value).
       create tt-bo-erro.
       assign tt-bo-erro.i-sequen = i-seq-erro
              tt-bo-erro.cd-erro  = 2
              tt-bo-erro.mensagem = return-value.
    end.
    
    find pto-contr where pto-contr.cod-pto-contr = rowObject.cod-pto-contr no-lock no-error.
    if not avail pto-contr then do:
       {utp/ut-table.i mgcex pto-contr 1}        
       assign i-seq-erro = i-seq-erro + 1.
       run utp/ut-msgs.p (input "msg",
                          input 2,
                          input return-value).
       create tt-bo-erro.
       assign tt-bo-erro.i-sequen = i-seq-erro
              tt-bo-erro.cd-erro  = 2
              tt-bo-erro.mensagem = return-value.
    end. 
        
 
    find first tt-bo-erro
        no-lock no-error.
    if not available tt-bo-erro then do:
        find incoterm-itiner where
             incoterm-itiner.cod-itiner    = rowObject.cod-itiner
         and incoterm-itiner.cod-pto-contr = rowObject.cod-pto-contr
         and incoterm-itiner.cod-incoterm  = rowObject.cod-incoterm
             no-lock no-error.
        if avail incoterm-itiner then do:
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
    end.

    IF CAN-FIND(FIRST incoterm-itiner WHERE 
                      incoterm-itiner.cod-itiner    = rowObject.cod-itiner  AND
                      incoterm-itiner.cod-incoterm  = rowObject.cod-incoterm) then do: 
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
 
    run validateFields.
    find first tt-bo-erro
        no-lock no-error.
 
    if not avail tt-bo-erro then do:
       run executeCreate.
       assign r-chave = to-rowid(return-value).
    end.

    run endMethod ("validateCreate").
end procedure.
 
procedure findCoditiner:

   /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter c-itiner as char no-undo.
    def output parameter table for RowObject.
 
    find first incoterm-itiner where
        incoterm-itiner.cod-itiner = int(c-itiner)
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


procedure Codincoterm:

   /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter c-incoterm as char no-undo.
    def output parameter table for RowObject.
 
    find first inco-cx where
        inco-cx.cod-incoterm = c-incoterm
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

procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "check-sum" then c-value = RowObject.check-sum.
        when "cod-incoterm" then c-value = RowObject.cod-incoterm.
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
 
