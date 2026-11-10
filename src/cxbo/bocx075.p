/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX075 2.00.00.010} /*** "010010" 07/10/2024 16:59:54 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx075 MUT}
&ENDIF

/*
**  BOCX075.P
**
**  tb-pr-cex - Tabela de pre‡os das despesas/impostos que serÆo utilizadas nos processos de imposta‡Æo.
**
**  Ultima altera‡Æo : 05/01/99 - GeraBO
*/

{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */

def var c-tab        as char     no-undo.
def var c-moeda      as integer  no-undo.
def var c-fornecedor as integer  no-undo.
def var c-itinerario as integer  no-undo.
def var c-incoterm   as char     no-undo.


def var i-cod-emitente like emitente.cod-emitente no-undo.

DEFINE var c-cod-estabel    like proc-ped-venda.cod-estabel no-undo.
DEFINE var c-nr-proc-exp    like proc-ped-venda.nr-proc-exp no-undo.
DEFINE var c-nr-pedido      like proc-ped-venda.nr-pedido   no-undo.
DEFINE VAR h-bocx195        as handle                       no-undo.
def var c-cod-emitente-ini as integer no-undo.
def var c-cod-emitente-fim as integer no-undo.
def var c-cod-itiner-ini as integer no-undo.
def var c-cod-itiner-fim as integer no-undo.
def var c-cod-incoterm-ini as char no-undo.
def var c-cod-incoterm-fim as char no-undo.
def var c-nr-tab-ini as char no-undo.
def var c-nr-tab-fim as char no-undo.
def var c-mo-codigo-ini as integer no-undo.
def var c-mo-codigo-fim as integer no-undo.

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY tb-pr-cex
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME tb-pr-cex


{include/boini.i}

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
{cxbo/bocx075.i RowObject}
{cxbo/bocx075.i tt-tb-pr-cex}

define buffer bf{&TABLE-NAME} for {&TABLE-NAME}.

procedure setConstraint1:

end.

PROCEDURE setConstraint2:

    def input parameter p-tab        as char no-undo.
    def input parameter p-moeda      as char no-undo.
    def input parameter p-fornecedor as char no-undo.
    def input parameter p-itinerario as char no-undo.
    def input parameter p-incoterm   as char no-undo.

    assign c-tab        = p-tab.
    assign c-moeda      = integer(p-moeda).
    assign c-fornecedor = integer(p-fornecedor).
    assign c-itinerario = integer(p-itinerario).
    assign c-incoterm   = p-incoterm.

END PROCEDURE.


PROCEDURE setConstraint3:
    def input parameter p-tab        as char no-undo.
    def input parameter p-moeda      as char no-undo.
    def input parameter p-fornecedor as char no-undo.
    def input parameter p-itinerario as char no-undo.
    def input parameter p-incoterm   as char no-undo.

    assign c-tab        = p-tab.
    assign c-moeda      = integer(p-moeda).
    assign c-fornecedor = integer(p-fornecedor).
    assign c-itinerario = integer(p-itinerario).
    assign c-incoterm   = p-incoterm.
END PROCEDURE.

procedure setConstraint4:
    def input parameter p-tab          as char no-undo.
    def input parameter p-cod-emitente as integer no-undo.

    assign c-tab          = p-tab
           c-fornecedor   = p-cod-emitente.

end procedure.
 
procedure setConstraint5:
    def input parameter p-cod-emitente-ini as integer no-undo.
    def input parameter p-cod-emitente-fim as integer no-undo.

    assign c-cod-emitente-ini = p-cod-emitente-ini
           c-cod-emitente-fim = p-cod-emitente-fim.

end procedure.

procedure setConstraint6:
    def input parameter p-cod-itiner-ini as integer no-undo.
    def input parameter p-cod-itiner-fim as integer no-undo.

    assign c-cod-itiner-ini = p-cod-itiner-ini
           c-cod-itiner-fim = p-cod-itiner-fim.

end procedure.

procedure setConstraint7:
    def input parameter p-cod-incoterm-ini as char no-undo.
    def input parameter p-cod-incoterm-fim as char no-undo.

    assign c-cod-incoterm-ini = p-cod-incoterm-ini
           c-cod-incoterm-fim = p-cod-incoterm-fim.

end procedure.

procedure setConstraint8:
    def input parameter p-nr-tab-ini as char no-undo.
    def input parameter p-nr-tab-fim as char no-undo.

    assign c-nr-tab-ini   = p-nr-tab-ini
           c-nr-tab-fim   = p-nr-tab-fim.

end procedure.

procedure setConstraint9:
    def input parameter p-mo-codigo-ini as integer no-undo.
    def input parameter p-mo-codigo-fim as integer no-undo.

    assign c-mo-codigo-ini   = p-mo-codigo-ini
           c-mo-codigo-fim   = p-mo-codigo-fim.

end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    assign l-query = yes.
    assign i-bo-query = i-abertura.
    case i-abertura:

        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.

        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where
			                        tb-pr-cex.nr-tab         >= c-tab and ~
			                        tb-pr-cex.mo-codigo      >= c-moeda and ~
			                        tb-pr-cex.cod-emitente   >= c-fornecedor and ~
			                        tb-pr-cex.cod-itiner     >= c-itinerario and ~
			                        tb-pr-cex.cod-incoterm   >= c-incoterm no-lock.

	 when 3 then
            open query {&QUERY-NAME} for each {&TABLE-NAME}  where tb-pr-cex.nr-tab         >= c-tab and ~
                        tb-pr-cex.mo-codigo      >= c-moeda and ~
                        tb-pr-cex.cod-emitente   >= c-fornecedor and ~
                        tb-pr-cex.cod-itiner     >= c-itinerario and ~
                        tb-pr-cex.cod-incoterm   >= c-incoterm  no-lock.
        when 4 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where
			                        tb-pr-cex.nr-tab         >= c-tab and ~
			                        tb-pr-cex.cod-emitente    = c-fornecedor no-lock.
        when 5 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where
			                        tb-pr-cex.cod-emitente >= c-cod-emitente-ini and ~
			                        tb-pr-cex.cod-emitente <= c-cod-emitente-fim no-lock
			                        by tb-pr-cex.cod-emitente.
        when 6 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where
			                        tb-pr-cex.cod-itiner  >= c-cod-itiner-ini and ~
			                        tb-pr-cex.cod-itiner  <= c-cod-itiner-fim no-lock
			                        by tb-pr-cex.cod-itiner.
        when 7 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where
			                        tb-pr-cex.cod-incoterm >= c-cod-incoterm-ini and ~
			                        tb-pr-cex.cod-incoterm <= c-cod-incoterm-fim no-lock
			                        by tb-pr-cex.cod-incoterm.
        when 8 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where
			                        tb-pr-cex.nr-tab >= c-nr-tab-ini and ~
			                        tb-pr-cex.nr-tab <= c-nr-tab-fim no-lock
			                        by tb-pr-cex.nr-tab.
        when 9 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where
			                        tb-pr-cex.mo-codigo >= c-mo-codigo-ini and ~
			                        tb-pr-cex.mo-codigo <= c-mo-codigo-fim no-lock
			                        by tb-pr-cex.mo-codigo.
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
/*{include/boexeupt.i}*/
{include/boexedel.i}
/*{include/bovalupt.i}*/
/*{include/bovaldel.i}*/
{utp/ut-glob.i}


procedure executeUpdate:
    /*
    **  Executa Update
    */
    buffer-copy RowObject except r-rowid cod-emitente cod-itiner cod-incoterm nr-tab to {&TABLE-NAME}.
end procedure.




procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
end procedure.

procedure findCodigo:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter  i-cod-emitente   as inte no-undo.
    def input parameter  i-cod-itinerario as inte no-undo.
    def input parameter  c-cod-incoterm   as char no-undo.
    def input parameter  c-nr-tab         as char no-undo.
    def output PARAMETER c-return         AS CHAR NO-UNDO.

    find tb-pr-cex where
        tb-pr-cex.cod-emitente     = i-cod-emitente 
        and tb-pr-cex.cod-itiner   = i-cod-itinerario
        and tb-pr-cex.cod-incoterm = c-cod-incoterm
        and tb-pr-cex.nr-tab       = c-nr-tab
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

procedure findCodigo-1:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter c-nr-tab as char no-undo.
    def output parameter table for RowObject.

    find first tb-pr-cex where
         tb-pr-cex.nr-tab = c-nr-tab
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

procedure findCodigo-2:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter c-nr-tab as char no-undo.
    def output parameter c-return as char.

    find first tb-pr-cex where
         tb-pr-cex.nr-tab = c-nr-tab
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

    run InitializeValidate.

    for each tt-bo-erro:
        delete tt-bo-erro.
    end.

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
    /*
    **  Valida Fields
    */

    def var c-label as char format "x(06)" no-undo.

    find first rowObject
        no-lock no-error.

    if rowObject.descricao = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&table-name} descricao 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.dt-inicio = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&table-name} dt-inicio 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.dt-termino = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&table-name} dt-termino 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
    if rowObject.dt-termino < rowObject.dt-inicio then do:
        {utp/ut-liter.i in¡cio * l}
        assign c-label = trim(return-value).
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i t‚rmino * l}
        run utp/ut-msgs.p (input "msg",
                           input 89,
                           input c-label + "~~" + return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 89
               tt-bo-erro.mensagem     = return-value.
    end.
    if rowObject.taxa-financ = no then do:
       if rowObject.nr-dias-taxa = 0 then do:
          assign i-seq-erro = i-seq-erro + 1.
          {utp/ut-field.i mgcex {&table-name} nr-dias-taxa 1}
          create tt-bo-erro.
          assign tt-bo-erro.parametros = return-value.
          run utp/ut-msgs.p (input "msg",
                             input 265,
                             input return-value).
          assign tt-bo-erro.i-sequen     = i-seq-erro
                 tt-bo-erro.cd-erro      = 265
                 tt-bo-erro.mensagem     = return-value.
       end.

       if rowObject.perc-taxa = 0 then do:
          assign i-seq-erro = i-seq-erro + 1.
          {utp/ut-field.i mgcex {&table-name} perc-taxa 1}
          create tt-bo-erro.
          assign tt-bo-erro.parametros = return-value. 
          run utp/ut-msgs.p (input "msg",
                             input 265,
                             input return-value).
          assign tt-bo-erro.i-sequen     = i-seq-erro
                 tt-bo-erro.cd-erro      = 265
                 tt-bo-erro.mensagem     = return-value.
       end.
    end.

    /*if rowObject.perc-descto = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&table-name} perc-descto 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.*/

    if rowObject.situacao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&table-name} situacao 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

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

    find {&table-name} where rowid({&table-name}) = r-chave
        exclusive-lock no-error no-wait.
        if locked({&table-name}) then do:
            run utp/ut-msgs.p (input "msg",
	                        input 16096,
 		                 input "").
            assign i-seq-erro = i-seq-erro + 1.
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                tt-bo-erro.cd-erro  = 16096
                tt-bo-erro.mensagem = return-value.
        end.
        else
	    if avail {&table-name} then do:
            if can-find(FIRST desp-tb-pr-cex 
                        WHERE desp-tb-pr-cex.cod-emitente  = tb-pr-cex.cod-emitente 
                          AND desp-tb-pr-cex.cod-itiner    = tb-pr-cex.cod-itiner 
                          AND desp-tb-pr-cex.nr-tab        = tb-pr-cex.nr-tab) then do:

                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-table.i mgcex tb-pr-cex 1}
                create tt-bo-erro.
                assign tt-bo-erro.parametros = return-value.
                run utp/ut-msgs.p (input "msg",
                                   input 31765,
                                   input return-value).
                assign tt-bo-erro.i-sequen = i-seq-erro
                    tt-bo-erro.cd-erro  = 31765
                    tt-bo-erro.mensagem = return-value.
            end.
        end.
    if not can-find(first tt-bo-erro) then do:
        if avail {&TABLE-NAME} then do:
            run executeDelete.
        end.
    
        find next {&TABLE-NAME} no-lock no-error.
        if not avail {&TABLE-NAME} then
            find prev {&TABLE-NAME} no-lock no-error.
        assign r-chave = rowid({&TABLE-NAME}).
    END.

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
    find first rowObject
    no-lock no-error.

    /** Valida Emitente **/

    if rowObject.cod-emitente = 0 then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&table-name} cod-emitente 1}
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
        &if defined(bf-mat-comex) &then                                
            if not can-find(emitente where emitente.cod-emitente = rowObject.cod-emitente 
            and (emitente.identific = "F" or emitente.identific = "A")) then do:
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-field.i mgcex {&table-name} cod-emitente 1}
                create tt-bo-erro.
                assign tt-bo-erro.parametros = return-value.
                run utp/ut-msgs.p (input "msg",
                                   input 2,
                                   input return-value).
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 2
                       tt-bo-erro.mensagem = return-value.
            end.
        &else
            if not can-find(emitente where emitente.cod-emitente = rowObject.cod-emitente 
            and (emitente.identific = 2 or emitente.identific = 3)) then do:
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-field.i mgcex {&table-name} cod-emitente 1}
                create tt-bo-erro.
                assign tt-bo-erro.parametros = return-value.
                run utp/ut-msgs.p (input "msg",
                                   input 2,
                                   input return-value).
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 2
                       tt-bo-erro.mensagem = return-value.
            end.        
        &endif             
        find emitente where emitente.cod-emitente = rowObject.cod-emitente
             no-lock no-error.
        if   avail emitente then do:
             {cdp/cd2502.i} 
        end.
    end.

    /***Valida Incoterm***/
    if  rowObject.cod-incoterm <> "" then do:
        if not can-find(inco-cx where inco-cx.cod-incoterm = rowObject.cod-incoterm ) then do:
             assign i-seq-erro = i-seq-erro + 1.
             {utp/ut-table.i mgcex inco-cx 1}
             create tt-bo-erro.
             assign tt-bo-erro.parametros = return-value.
             run utp/ut-msgs.p (input "msg",
                                input 2,
                                input return-value).
             assign tt-bo-erro.i-sequen = i-seq-erro
                    tt-bo-erro.cd-erro  = 2
                    tt-bo-erro.mensagem = return-value.
         end.
    end.

    /***Valida Itinerario***/
    if rowObject.cod-itiner <> 0 then do:
       if not can-find(itinerario where cod-itiner = rowObject.cod-itiner ) then do:
             assign i-seq-erro = i-seq-erro + 1.
             {utp/ut-table.i mgcex itinerario 1}
             create tt-bo-erro.
             assign tt-bo-erro.parametros = return-value.
             run utp/ut-msgs.p (input "msg",
                                input 2,
                                input return-value).
             assign tt-bo-erro.i-sequen = i-seq-erro
                    tt-bo-erro.cd-erro  = 2
                    tt-bo-erro.mensagem = return-value.
         end.

    end.
    
    if rowObject.nr-tab = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&table-name} nr-tab 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if not can-find(moeda where mo-codigo = rowObject.mo-codigo ) then do:
             assign i-seq-erro = i-seq-erro + 1.
             {utp/ut-table.i mguni moeda 1}
             create tt-bo-erro.
             assign tt-bo-erro.parametros = return-value.
             run utp/ut-msgs.p (input "msg",
                                input 2,
                                input return-value).
             assign tt-bo-erro.i-sequen = i-seq-erro
                    tt-bo-erro.cd-erro  = 2
                    tt-bo-erro.mensagem = return-value.
    end.


    run validateFields.

    find first tt-bo-erro
        no-lock no-error.
    if not available tt-bo-erro then do:
        find tb-pr-cex where
            tb-pr-cex.cod-emitente = rowObject.cod-emitente
        and tb-pr-cex.cod-itiner = rowObject.cod-itiner
        and tb-pr-cex.cod-incoterm = rowObject.cod-incoterm
        and tb-pr-cex.nr-tab = rowObject.nr-tab
            no-lock no-error.
        if avail tb-pr-cex then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex {&TABLE-NAME} 1}
            create tt-bo-erro.
            assign tt-bo-erro.parametros = return-value.
            run utp/ut-msgs.p (input "msg",
                               input 8,
                               input return-value).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 8
                   tt-bo-erro.mensagem     = return-value.
        end.
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
        when "cod-incoterm"  then c-value = RowObject.cod-incoterm.
        when "nr-tab"        then c-value = RowObject.nr-tab.
        when "descricao"     then c-value = RowObject.descricao.
        when "observacao"    then c-value = RowObject.observacao.
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
        when "perc-taxa"    then c-value = RowObject.perc-taxa.
        when "perc-descto"  then c-value = RowObject.perc-descto.
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
        when "nr-dias-taxa" then c-value = RowObject.nr-dias-taxa.
        when "mo-codigo"    then c-value = RowObject.mo-codigo.
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
        when "dt-inicio"  then c-value = RowObject.dt-inicio.
        when "dt-termino" then c-value = RowObject.dt-termino.
        when "data-1"     then c-value = RowObject.data-1.
        when "data-2"     then c-value = RowObject.data-2.
        otherwise return error.
    end case.
end procedure.

procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.

    case c-field:
        when "taxa-financ" then c-value = RowObject.taxa-financ.
        when "log-1"       then c-value = RowObject.log-1.
        when "log-2"       then c-value = RowObject.log-2.
        otherwise return error.
    end case.
end procedure.
 
procedure verificaTabelaPrecoPadrao:
    /* 
    NÆo deve haver mais de uma tabela de pre‡o padrÆo para tabelas de pre‡os ativas com o mesmo per¡odo de validade,
    fornecedor, itiner rio e incoterm. 
    Quando ocorrer, solicitar confirma‡Æo da altera‡Æo e, caso confirmado, desmarcar este flag no antigo registro e,
    considerar como padrÆo o novo registro. Mensagem a ser utilizada nesta situa‡Æo: 30278.
    */
    &if '{&bf_mat_versao_ems}':U >= '2.062':U &then
    define input  parameter i-cod-emitente     as integer   format ">>>>>>>>9":U no-undo.
    define input  parameter i-cod-itiner       as integer   format ">>,>>9":U    no-undo.
    define input  parameter c-cod-incoterm     as character format "x(3)":U      no-undo.
    define input  parameter c-nr-tab           as character format "x(10)":U     no-undo.
    define input  parameter dt-inicio          as date                           no-undo.
    define input  parameter dt-termino         as date                           no-undo.
    define output parameter c-nr-tab-pad       as character format "x(10)":U     no-undo.
    
    find first bf{&TABLE-NAME}
        where  bf{&TABLE-NAME}.cod-emitente = i-cod-emitente
        and    bf{&TABLE-NAME}.cod-itiner   = i-cod-itiner  
        and    bf{&TABLE-NAME}.cod-incoterm = c-cod-incoterm
        and    bf{&TABLE-NAME}.nr-tab      <> c-nr-tab      
        and    bf{&TABLE-NAME}.situacao     = 1  /*ativa*/
        and    bf{&TABLE-NAME}.log-tab-preco-padr no-lock no-error.
    if  avail  bf{&TABLE-NAME} then do:

        if  dt-inicio  <= bf{&TABLE-NAME}.dt-termino 
        and dt-termino >= bf{&TABLE-NAME}.dt-inicio then
            assign c-nr-tab-pad =  bf{&TABLE-NAME}.nr-tab.
    end.
    
    &endif
    
end procedure.

procedure sobreporTabelaPrecoPadrao:

    &if '{&bf_mat_versao_ems}':U >= '2.062':U &then
    define input  parameter i-cod-emitente     as integer   format ">>>>>>>>9":U no-undo.
    define input  parameter i-cod-itiner       as integer   format ">>,>>9":U    no-undo.
    define input  parameter c-cod-incoterm     as character format "x(3)":U      no-undo.
    define input  parameter c-nr-tab           as character format "x(10)":U     no-undo.
    define input  parameter dt-inicio          as date                           no-undo.
    define input  parameter dt-termino         as date                           no-undo.
    define input  parameter l-sobrepoe         as logical                        no-undo.

    define variable r-rowid as rowid no-undo.
    
    /* tabela padrao */
    find first bf{&TABLE-NAME}
        where  bf{&TABLE-NAME}.cod-emitente = i-cod-emitente
        and    bf{&TABLE-NAME}.cod-itiner   = i-cod-itiner
        and    bf{&TABLE-NAME}.cod-incoterm = c-cod-incoterm
        and    bf{&TABLE-NAME}.nr-tab      <> c-nr-tab 
        and    bf{&TABLE-NAME}.situacao     = 1  /*ativa*/
        and    bf{&TABLE-NAME}.log-tab-preco-padr exclusive-lock no-error.
    if  avail  bf{&TABLE-NAME} then do:

        if  dt-inicio  <= bf{&TABLE-NAME}.dt-termino 
        and dt-termino >= bf{&TABLE-NAME}.dt-inicio 
        and l-sobrepoe then
            assign  bf{&TABLE-NAME}.log-tab-preco-padr = no.
    end.

    /* nova tabela padrao */
    find first bf{&TABLE-NAME}
        where  bf{&TABLE-NAME}.cod-emitente = i-cod-emitente
        and    bf{&TABLE-NAME}.cod-itiner   = i-cod-itiner
        and    bf{&TABLE-NAME}.cod-incoterm = c-cod-incoterm
        and    bf{&TABLE-NAME}.nr-tab       = c-nr-tab exclusive-lock no-error.
    if  avail  bf{&TABLE-NAME} then do:
        
        assign r-rowid = rowid(bf{&TABLE-NAME}).

        if  l-sobrepoe then
            assign  bf{&TABLE-NAME}.log-tab-preco-padr = yes.
        else
            assign  bf{&TABLE-NAME}.log-tab-preco-padr = no.
    end.

    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
    reposition {&QUERY-NAME} to rowid r-rowid no-error.
    get next {&QUERY-NAME} no-lock no-wait.
    &endif

end procedure.
