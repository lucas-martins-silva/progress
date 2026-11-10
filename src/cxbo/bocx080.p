/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX080 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX080 MUT}
&ENDIF

/*
**  BOCX080.P
**
**  desp-tb-pr-cex - Despesas Tabela de pre‡os das despesas/impostos que serÆo utilizadas nos processos de imposta‡Æo.
**
**  Ultima altera‡Æo : 13/09/99 - GeraBO
*/

{cdp/cdcfgmat.i} /* Defini‡Æo de pre-processador */

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY desp-tb-pr-cex
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME desp-tb-pr-cex
    
def var c-tab        as char     no-undo.
def var c-moeda      as integer  no-undo.
def var c-fornecedor as integer  no-undo.
def var c-itinerario as integer  no-undo.
def var c-incoterm   as char     no-undo.
def var i-despesa        as integer  no-undo.
def var i-cond-pag       as integer  no-undo.
def var i-cod-emitente   as integer  no-undo.
def var i-cod-itiner     as integer  no-undo.
def var c-cod-incoterm   as char     no-undo.
def var c-nr-tab         as char     no-undo.
def var c-despesa      as integer  no-undo.
def var c-cond-pag     as integer  no-undo.
def var c-legenda      as character format "x(2000)":U no-undo.
def var h-bocx095      as handle   no-undo.

{include/boini.i}
{cxbo/bocx080.i RowObject}
{cxbo/bocx080.i tt-desp-tb-pr-cex}
{method/dbotterr.i} /* RowErrors */

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
define buffer b-desp-tb-pr-cex for desp-tb-pr-cex.

procedure setConstraint1:

end.

PROCEDURE setConstraint2:
    def input parameter r-chave as rowid no-undo.
    find tb-pr-cex no-lock where rowid(tb-pr-cex) = r-chave no-error.
END PROCEDURE.


PROCEDURE setConstraint3:
def input parameter p-tab      as char no-undo.
def input parameter p-despesas as char no-undo.
def input parameter p-cond-pag as char no-undo.

assign c-tab      = p-tab
       i-despesa  = integer(p-despesas)
       i-cond-pag = integer(p-cond-pag).

END PROCEDURE.

PROCEDURE setConstraint4:

def input parameter p-cod-emitente as int no-undo.
def input parameter p-cod-itiner   as int no-undo.
def input parameter p-cod-incoterm as char no-undo.
def input parameter p-nr-tab       as char no-undo.


assign c-nr-tab       = p-nr-tab
       i-cod-emitente = p-cod-emitente
       i-cod-itiner   = p-cod-itiner
       c-cod-incoterm = p-cod-incoterm.

for each rowObject:
delete rowObject.
end.

END PROCEDURE.


procedure openQuery:
    define input parameter i-abertura as integer no-undo.

    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.

        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where {&TABLE-NAME}.nr-tab = tb-pr-cex.nr-tab and~
                                                                  {&TABLE-NAME}.cod-emitente = tb-pr-cex.cod-emitente and~
                                                                  {&TABLE-NAME}.cod-incoterm = tb-pr-cex.cod-incoterm and~
                                                                  {&TABLE-NAME}.cod-itiner = tb-pr-cex.cod-itiner no-lock.
        when 3 then
            open query {&QUERY-NAME} for each {&TABLE-NAME}  where desp-tb-pr-cex.nr-tab >= c-tab and ~
                                                                   desp-tb-pr-cex.cod-desp >= i-despesa and ~
                                                                   desp-tb-pr-cex.cod-cond-pag >= i-cond-pag no-lock.
        when 4 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where {&TABLE-NAME}.cod-emitente = i-cod-emitente and~
                                                                  {&TABLE-NAME}.cod-itiner = i-cod-itiner and~
                                                                  {&TABLE-NAME}.cod-incoterm = c-cod-incoterm and~
                                                                  {&TABLE-NAME}.nr-tab = c-nr-tab no-lock.
    end case.
    assign i-bo-query = i-abertura
           l-query    = yes.    
end procedure.


{include/bostrmet.i}
{include/boendmet.i}
&if defined(bf-mat-comex) &then    
&else
    {include/bocomver.i}
    {include/bogetver.i}
&endif
{include/bonav.i}
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

 
procedure executeUpdate:
    /*
    **  Executa Update
    */
    buffer-copy RowObject except r-rowid 
                                 cod-emitente 
                                 cod-itiner 
                                 cod-incoterm 
                                 nr-tab 
                                 cod-desp 
                                 cod-cond-pag 
                                 val-min to {&TABLE-NAME}.
end procedure.
 
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
    def input parameter i-cod-emitente as integer no-undo.
    def input parameter i-cod-itinerario as integer no-undo.
    def input parameter c-cod-incoterm as char no-undo.
    def input parameter c-nr-tab as char no-undo.
    def input parameter i-cod-desp as inte no-undo.
    def input parameter i-cod-cond-pag as inte no-undo.
    def input parameter de-val-min as deci no-undo.
    def output parameter table for RowObject.
 
    find desp-tb-pr-cex where
        desp-tb-pr-cex.cod-emitente = i-cod-emitente
        and desp-tb-pr-cex.cod-itiner = i-cod-itinerario
        and desp-tb-pr-cex.cod-incoterm = c-cod-incoterm
        and desp-tb-pr-cex.nr-tab = c-nr-tab
        and desp-tb-pr-cex.cod-desp = i-cod-desp
        and desp-tb-pr-cex.cod-cond-pag = i-cod-cond-pag
        and desp-tb-pr-cex.val-min = de-val-min
        no-lock no-error.
    if not avail desp-tb-pr-cex then do:   
        {utp/ut-table.i mgcex desp-tb-pr-cex 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
    end.
    else do:
       run setCurrent.
    end.
    run endMethod ("find").
end procedure.
 
procedure findDesp_imp:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter i-cod-desp as inte no-undo.
    def output parameter table for RowObject.
 
    find desp-tb-pr-cex where
        desp-tb-pr-cex.cod-desp = i-cod-desp
        no-lock no-error.
    if not avail desp-tb-pr-cex then do:    
        {utp/ut-table.i mgcex desp-tb-pr-cex 1}
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
    
    find first rowObject no-lock no-error.
       
    run InitializeValidate.
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
    
    run validateFields.
    
    find first tt-bo-erro no-lock no-error.
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
    /*
    **  Valida Fields
    */
    run startMethod ("validateFields").
     
    if rowObject.situacao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex desp-tb-pr-cex situacao 1}        
        /******************************************/
        create tt-bo-erro.
        assign tt-bo-erro.parametros   = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).                           
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
                
    end.
 
    if rowObject.val-desp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex desp-tb-pr-cex val-desp 1}
        /******************************************/
        create tt-bo-erro.
        assign tt-bo-erro.parametros   = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.val-min = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex desp-tb-pr-cex val-min 1}
        /******************************************/
        create tt-bo-erro.
        assign tt-bo-erro.parametros   = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end. 

    &IF "{&bf_mat_versao_ems}":U >= "2.062":U &THEN
    
    if  rowObject.val-max-desp > 0
    and rowObject.val-max-desp < rowObject.val-min-desp then do:

        assign i-seq-erro = i-seq-erro + 1.
        create tt-bo-erro.
        /*Mensagem: Valor m ximo nÆo deve ser menor que o valor m¡nimo.*/
        run utp/ut-msgs.p (input "msg",
                           input 30279,
                           input "").
        assign tt-bo-erro.parametros   = ""
               tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 30279
               tt-bo-erro.mensagem     = return-value.
    end.

    if  rowObject.dsl-formul-despes <> "" then do:

        if  not valid-handle (h-bocx095) then
            run cxbo/bocx095.p persistent set h-bocx095.
    
        run validaFormulaDespesa in h-bocx095 (input rowObject.dsl-formul-despes,
                                               input "IMP",
                                               output table rowErrors).
        if  can-find (first rowErrors) then do:

            for each rowErrors:

                assign i-seq-erro = i-seq-erro + 1.
                create tt-bo-erro.
                assign tt-bo-erro.parametros   = rowErrors.ErrorParameters 
                       tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = rowErrors.ErrorNumber     
                       tt-bo-erro.mensagem     = rowErrors.ErrorDescription.
            end.
        end.
        else do:

            run geraLegenda in h-bocx095 (input  rowObject.dsl-formul-despes,
                                          output c-legenda).
            assign rowObject.dsl-legenda-formul = c-legenda.
        end.

        if  valid-handle (h-bocx095) then do:
            delete procedure h-bocx095.
            assign h-bocx095 = ?.
        end.
    end.
    &ENDIF

    run endmethod("ValidateFields").
end procedure.


procedure validateDelete:
    /*
    **  Valida Delete
    */
    def input-output parameter r-chave as rowid.
    def output parameter table for tt-bo-erro. 
    run InitializeValidate.
    
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
 
    find {&TABLE-NAME} where
        rowid({&TABLE-NAME}) = r-chave
        exclusive-lock no-error no-wait.

        if locked({&TABLE-NAME}) then do:
            run utp/ut-msgs.p (input "msg",
	                        input 16096,
 			          input "").
            assign i-seq-erro = i-seq-erro + 1.
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                tt-bo-erro.cd-erro  = 16096
                tt-bo-erro.mensagem = return-value. 			          
        end.
        else if avail {&TABLE-NAME} then do:
	        run executeDelete.
           end.

  if not can-find(first tt-bo-erro) then do:
       if avail {&TABLE-NAME} then do:
         run executeDelete.
     end.
    end.
    find next {&TABLE-NAME}
         no-lock no-error.
    if not avail {&TABLE-NAME} then
         find prev {&TABLE-NAME}
             no-lock no-error.
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
    run startMethod ("validateCreate").
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
 
    find first rowObject no-lock no-error.
    
    if rowObject.cod-desp = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex desp-tb-pr-cex cod-desp 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros   = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
    else 
    if not can-find(desp-imp where mgcex.desp-imp.cod-desp = rowObject.cod-desp) then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-table.i mgcex desp-imp 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros   = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 2
               tt-bo-erro.mensagem = return-value.
    end.
    
    if rowObject.cod-cond-pag = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
           pre-processador em chamada de includes */
        {utp/ut-field.i mgcex desp-tb-pr-cex cod-cond-pag 1}
        /******************************************/
        create tt-bo-erro.
        assign tt-bo-erro.parametros   = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
    else 
    if not can-find(cond-pagto where cod-cond-pag = rowObject.cod-cond-pag) then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex desp-tb-pr-cex cod-cond-pag 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros   = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 2
               tt-bo-erro.mensagem = return-value.
    end.      
       
    if can-find(first desp-tb-pr-cex where
       desp-tb-pr-cex.cod-emitente     = rowObject.cod-emitente
       and desp-tb-pr-cex.cod-itiner   = rowObject.cod-itiner
       and desp-tb-pr-cex.cod-incoterm = rowObject.cod-incoterm
       and desp-tb-pr-cex.nr-tab       = rowObject.nr-tab
       and desp-tb-pr-cex.cod-desp     = rowObject.cod-desp
       and desp-tb-pr-cex.cod-cond-pag = rowObject.cod-cond-pag) then do:      
       assign i-seq-erro = i-seq-erro + 1.            
       {utp/ut-table.i mgcex desp-tb-pr-cex 1}
       create tt-bo-erro.
       assign tt-bo-erro.parametros   = return-value.
       run utp/ut-msgs.p (input "msg",
                          input 8,
                          input return-value).
       assign tt-bo-erro.i-sequen     = i-seq-erro
              tt-bo-erro.cd-erro      = 8
              tt-bo-erro.mensagem     = return-value.
    end.
   
    run validateFields.

    find first tt-bo-erro no-lock no-error.
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
        when "cod-incoterm"  then c-value = RowObject.cod-incoterm.
        when "nr-tab"        then c-value = RowObject.nr-tab.
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
        when "val-min"      then c-value = RowObject.val-min.
        when "val-desp"     then c-value = RowObject.val-desp.        
        when "perc-descto"  then c-value = RowObject.perc-descto.
        when "val-min-desp" then c-value = RowObject.val-min-desp.        
        when "dec-1"        then c-value = RowObject.dec-1.
        when "dec-2"        then c-value = RowObject.dec-2.
        otherwise return error.
    end case.
end procedure.

procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.

    case c-field:
        when "cod-emitente" then c-value = RowObject.cod-emitente.
        when "cod-itiner"   then c-value = RowObject.cod-itiner.
        when "cod-desp"     then c-value = RowObject.cod-desp.
        when "cod-cond-pag" then c-value = RowObject.cod-cond-pag.
        when "situacao"     then c-value = RowObject.situacao.
        when "int-1"        then c-value = RowObject.int-1.
        when "int-2"        then c-value = RowObject.int-2.
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
        when "log-1"       then c-value = RowObject.log-1.
        when "log-2"       then c-value = RowObject.log-2.
        otherwise return error.
    end case.
end procedure.
 
