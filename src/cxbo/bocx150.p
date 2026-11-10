/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX150 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX150 MUT}
&ENDIF

/*******************************************************************************
**
**  BOCX150.P
**
**  historico-proc-imp - Historico dos processos
**
*******************************************************************************/

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY historico-proc-imp
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME historico-proc-imp

{include/boini.i}
{cxbo/bocx150.i RowObject}
{cdp/cdcfgmat.i}

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

def var c-nr-proc-imp as char no-undo.
def var i-cod-itiner as integer no-undo.  

/* Re-planejamento das parcelas no MRP, conforme atividade 116178 */
&if defined(bf_mat_importacao_mrp) &then
     {cxbo/bocx150.i01}
&endif

procedure setConstraint1:
end procedure. 
 
procedure setConstraint2:
    def input parameter p-nr-proc-imp as char no-undo.
    
    assign c-nr-proc-imp = p-nr-proc-imp.
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                where historico-proc-imp.nr-proc-imp >= c-nr-proc-imp.            
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
/* {include/boexeupt.i} */ 
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

procedure findPrev2:
    /*
    **  Localiza bloco de registro anterior na tabela. 
    **  O bloco é formado pelos registros com mesmo nr-proc-imp e mesmo cod-itiner.
    */
    def output parameter c-return as char.
    
    assign c-nr-proc-imp = {&Table-name}.nr-proc-imp
           i-cod-itiner = {&table-name}.cod-itiner.

    find first {&table-name} where historico-proc-imp.nr-proc-imp = c-nr-proc-imp and
                                   historico-proc-imp.cod-itiner = i-cod-itiner no-lock no-error.
    find prev {&TABLE-NAME}
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        run utp/ut-msgs.p (input "msg",
                           input 7998,
                           input "").
        assign c-return = return-value.                           
    end.
    else run setCurrent.
end procedure.
 
procedure findNext2:
    /*
    **  Localiza proximo bloco de registro na tabela.
    **  O bloco é formado pelos registros com mesmo nr-proc-imp e mesmo cod-itiner.
    */
    def output parameter c-return as char.    

    assign c-nr-proc-imp = {&Table-name}.nr-proc-imp
           i-cod-itiner = {&table-name}.cod-itiner.

    find last {&table-name} where historico-proc-imp.nr-proc-imp = c-nr-proc-imp and
                                  historico-proc-imp.cod-itiner = i-cod-itiner no-lock no-error.
    find next {&TABLE-NAME} no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        run utp/ut-msgs.p (input "msg",
                           input 7999,
                           input "").
        assign c-return = return-value.                           
    end.
    else run setCurrent.
end procedure.

procedure findCh-itiner:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter c-nr-proc-imp   as char    no-undo.
    def input parameter i-cod-itiner    as integer no-undo.
    def input parameter i-cod-pto-contr as integer no-undo.
    def output parameter c-return as char no-undo.
    
    run startMethod("find":U).
 
    find historico-proc-imp where
        historico-proc-imp.nr-proc-imp = c-nr-proc-imp and
        historico-proc-imp.cod-itiner = i-cod-itiner   and
        historico-proc-imp.cod-pto-contr = i-cod-pto-contr
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
    run endMethod("find":U).
end procedure.

procedure executeUpdate:
    /*
    **  Executa Update
    */
      
    buffer-copy RowObject except nr-proc-imp cod-itiner cod-pto-contr r-rowid to {&TABLE-NAME}.
end procedure.

procedure validateCreate:
    /*
    **  Valida cria‡Æo da tabela/duplicidade de registro.
    */
    def input  parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.
    
    def var i-auto-num as integer no-undo.
    def var c-return as char no-undo.
    
    run startMethod("validateCreate":U).
 
    run initializeValidate.
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
 
    find first rowObject no-error.            
        
    if rowObject.nr-proc-imp = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} nr-proc-imp 1}
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
            {utp/ut-table.i mgcex itinerario 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 2
                   tt-bo-erro.mensagem = return-value.
        end.
        else do:
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
                if not can-find(pto-itiner where pto-itiner.cod-itiner = rowObject.cod-itiner and
                                                 pto-itiner.sequencia  = rowObject.sequencia  and
                                                 pto-itiner.cod-pto-contr = rowObject.cod-pto-contr) then do:
                    {utp/ut-table.i mgcex pto-itiner 1}
                    assign c-return = return-value.                                                                           
                    assign i-seq-erro = i-seq-erro + 1.
                    {utp/ut-table.i mgcex itinerario 1}
                    run utp/ut-msgs.p (input "msg",
                                       input 15783,
                                       input c-return + "~~" + return-value).
                    create tt-bo-erro.
                    assign tt-bo-erro.i-sequen = i-seq-erro
                           tt-bo-erro.cd-erro  = 15783
                           tt-bo-erro.mensagem = return-value.
                end.                  
        end.         
         
    run validateFields.
    
    if can-find(first tt-bo-erro) then do:   
        if can-find(first {&TABLE-NAME} where
            {&TABLE-NAME}.nr-proc-imp   = rowObject.nr-proc-imp and
            {&TABLE-NAME}.cod-estabel   = rowObject.cod-estabel and
            {&TABLE-NAME}.cod-itiner    = rowObject.cod-itiner  and
            {&TABLE-NAME}.sequencia     = rowObject.sequencia   and
            {&TABLE-NAME}.cod-pto-contr = rowObject.cod-pto-contr) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex historico-proc-imp 1}
            run utp/ut-msgs.p (input "msg",
                               input 8,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 8
                   tt-bo-erro.mensagem     = return-value.
        end.
    end. 
            
    find first tt-bo-erro no-lock no-error.         
    if not avail tt-bo-erro then do:
         run executeCreate.
         assign r-chave = to-rowid(return-value).
    end.
    run endMethod("validateCreate":U).
end procedure.

procedure validateFields:
    
    find first rowObject no-lock no-error.
 
    run startMethod ("validateFields").    
     
    run endMethod ("validateFields").
 
end procedure.

procedure getCharField:
	define input parameter c-field as char.
	define output parameter c-value as char.
	
	case c-field:
	       when "cod-estabel" then c-value = RowObject.cod-estabel.
	       when "nr-proc-imp" then c-value = RowObject.nr-proc-imp.
	       when "id-meio-transp" then c-value = RowObject.id-meio-transp.
	       when "observacao" then c-value = RowObject.observacao.
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
        when "sequencia" then c-value = RowObject.sequencia.
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
        when "dt-previsao" then c-value = RowObject.dt-previsao.
        when "dt-ult-previsao" then c-value = RowObject.dt-ult-previsao.
        when "dt-efetiva" then c-value = RowObject.dt-efetiva.
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


