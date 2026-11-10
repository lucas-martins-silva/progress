/******************************************************************************** 
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa. 
*******************************************************************************/
{include/i-prgvrs.i BOIN536 2.00.01.027 } /*** "010127" 17/06/2025 16:40:51 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN 
{include/i-license-manager.i boin536 MUT}
&ENDIF
        
{include/i-epc200.i boin536}

/*
**  BOIN536.P
**
**  rep-oper-ctrab - Reporte Opera‡Æo 
**
**  Ultima altera‡Æo : 28/07/99 - GeraBO
**
*/
 
&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY rep-oper-ctrab
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME rep-oper-ctrab
 
{include/boini.i}
 
{inbo/boin536.i RowObject}
&GLOBAL-DEFINE excludeFrameDefinition YES
{cdp/cd0666.i}
{cdp/cdcfgman.i} 
{cpp/cpapi005.i} /* Defini»’o da temp-table de movimento de GGF            **/
{cpp/cpapi006.i} /* Defini»’o da temp-table de m’o-de-obra direta          **/
{sfc/sf9005.i}   /*pi-verifica-acesso*/

DEF VAR de-tempo-mob-real AS DEC NO-UNDO.
DEF VAR l-real-padrao     AS log NO-UNDO.


DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
 
procedure setConstraint1:
 
end procedure.
 
procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock INDEXED-REPOSITION.
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
{include/bovalupt.i}
{include/bovaldel.i}
 

procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
 
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.
 
procedure findId:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter i-nr-ord-produ as inte no-undo.
    def input parameter i-num-seq-rep as inte no-undo.
    def output parameter c-return as char no-undo.
 
    find rep-oper-ctrab where
        rep-oper-ctrab.nr-ord-produ = i-nr-ord-produ
        and rep-oper-ctrab.num-seq-rep = i-num-seq-rep
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i movind {&TABLE-NAME} 1}
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
    if rowObject.cod-ctrab = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-ctrab 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-equipe-cq = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-equipe-cq 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-model-turno = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-model-turno 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-operador = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-operador 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-usuar-ult-atualiz = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-usuar-ult-atualiz 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.hra-ult-atualiz = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} hra-ult-atualiz 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.log-atualiz-reporte = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} log-atualiz-reporte 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.log-liberd-cq = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} log-liberd-cq 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.log-reporte-estordo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} log-reporte-estordo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.log-reporte-exp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} log-reporte-exp 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-ord-produ = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} nr-ord-produ 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.num-operac-sfc = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} num-operac-sfc 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.num-seq-rep = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} num-seq-rep 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.num-split-operac = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} num-split-oper 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.num-turno = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} num-turno 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-operac-aprov = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-operac-aprov 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-operac-refgda = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-operac-refgda 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-operac-reptda = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-operac-reptda 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-operac-retrab = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-operac-retrab 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-segs-fim-reporte = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-segs-fim-reporte 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-segs-inic-reporte = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-segs-inic-reporte 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-tempo-extra = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-tempo-extra 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-tempo-mod = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-tempo-mod 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-tempo-parada = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-tempo-parada 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-tempo-reporte = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-tempo-reporte 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.val-refer-fim-rep = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} val-refer-fim-rep 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.val-refer-inic-rep = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} val-refer-inic-rep 1}
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
 
    run validateFields.
 
    find first tt-bo-erro
        no-lock no-error.
    if not available tt-bo-erro then do:
        find rep-oper-ctrab where
            rep-oper-ctrab.nr-ord-produ = rowObject.nr-ord-produ
        and rep-oper-ctrab.num-seq-rep = rowObject.num-seq-rep
            no-lock no-error.
        if avail rep-oper-ctrab then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i movind {&TABLE-NAME} 1}
            run utp/ut-msgs.p (input "msg",
                               input 8,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 8
                   tt-bo-erro.mensagem     = return-value.
        end.
        else do:
             run executeCreate.
             assign r-chave = to-rowid(return-value).
        end.
    end.
 
    run endMethod ("validateCreate").
end procedure.
 
procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "cod-ctrab" then c-value = RowObject.cod-ctrab.
        when "cod-equipe" then c-value = RowObject.cod-equipe.
        when "cod-equipe-cq" then c-value = RowObject.cod-equipe-cq.
        when "cod-model-turno" then c-value = RowObject.cod-model-turno.
        when "cod-operador" then c-value = RowObject.cod-operador.
        when "cod-usuar-ult-atualiz" then c-value = RowObject.cod-usuar-ult-atualiz.
        when "hra-ult-atualiz" then c-value = RowObject.hra-ult-atualiz.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "qtd-operac-aprov" then c-value = RowObject.qtd-operac-aprov.
        when "qtd-operac-refgda" then c-value = RowObject.qtd-operac-refgda.
        when "qtd-operac-reptda" then c-value = RowObject.qtd-operac-reptda.
        when "qtd-operac-retrab" then c-value = RowObject.qtd-operac-retrab.
        when "qtd-segs-fim-reporte" then c-value = RowObject.qtd-segs-fim-reporte.
        when "qtd-segs-inic-reporte" then c-value = RowObject.qtd-segs-inic-reporte.
        when "qtd-tempo-extra" then c-value = RowObject.qtd-tempo-extra.
        when "qtd-tempo-mod" then c-value = RowObject.qtd-tempo-mod.
        when "qtd-tempo-parada" then c-value = RowObject.qtd-tempo-parada.
        when "qtd-tempo-reporte" then c-value = RowObject.qtd-tempo-reporte.
        when "val-refer-fim-rep" then c-value = RowObject.val-refer-fim-rep.
        when "val-refer-inic-rep" then c-value = RowObject.val-refer-inic-rep.
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "nr-ord-produ" then c-value = RowObject.nr-ord-produ.
        when "num-operac-sfc" then c-value = RowObject.num-operac-sfc.
        when "num-seq-rep" then c-value = RowObject.num-seq-rep.
        when "num-split-oper" then c-value = RowObject.num-split-operac.
        when "num-turno" then c-value = RowObject.num-turno.
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "dat-fim-reporte" then c-value = RowObject.dat-fim-reporte.
        when "dat-inic-reporte" then c-value = RowObject.dat-inic-reporte.
        when "dat-ult-atualiz" then c-value = RowObject.dat-ult-atualiz.
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
        when "log-atualiz-reporte" then c-value = RowObject.log-atualiz-reporte.
        when "log-liberd-cq" then c-value = RowObject.log-liberd-cq.
        when "log-reporte-estordo" then c-value = RowObject.log-reporte-estordo.
        when "log-reporte-exp" then c-value = RowObject.log-reporte-exp.
        otherwise return error.
    end case.
end procedure.

/************* PROCEDURES NEGOCIO BO *****************/

{inbo/boin536.i7}  /**** Defini‡Æo de temp-tables ****/
{utp/ut-glob.i}    /**** Vari veis globais        ****/
{inbo/boin536.i1}  /**** Procedures Negocio       ****/
{inbo/boin536.i5}  /**** Atualizar Tempo Rep Oper ****/
{sfc/sf9003.i}     /**** pi-sfc-valid-qtd-reptda-pert ****/
ASSIGN v-cod-usuar-corren = c-seg-usuario.


/****************** Fim BOIN536.P ********************/
