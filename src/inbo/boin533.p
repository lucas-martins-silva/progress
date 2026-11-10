/******************************************************************************** 
** Copyright DATASUL S.A. (1997) 
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN533 2.00.01.079 } /*** "010179" 13/02/2026 17:19:24 ***/
 
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN 
    {include/i-license-manager.i boin533 MUT}
&ENDIF

/*
**  BOIN533.P
**
**  op-sfc - Ordem Produ‡Æo SFC
**
**  Ultima altera‡Æo : 06/07/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY op-sfc
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME op-sfc
 
{include/boini.i}
{cdp/cdcfgman.i} /* Ativ. 161136 */
 
{inbo/boin533.i RowObject}
{inbo/boin536.i11} /*tt-param-split*/
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

/** Temp Tables utilizadas para cria‡Æo de splits que utilizam o 
    parƒmetro "Reporta para mais de um centro de trabalho" **/
define temp-table ttSplitOperac no-undo like split-operac
    field r-rowid as rowid.
/*********/

/**********Vari vel pra verifica‡Æo de execu‡Æo em lote. Usado no CS0305************/
DEFINE VARIABLE l-execucao-lote AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE h-boin536       AS HANDLE  NO-UNDO.
/**********************/

DEFINE VARIABLE h-cpapi301b AS HANDLE NO-UNDO.


DEFINE BUFFER b-ord-prod FOR ord-prod.

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
    def output parameter c-return as char no-undo.
 
    find op-sfc where
        op-sfc.nr-ord-produ = i-nr-ord-produ
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
    if rowObject.cod-item-aux-sfc = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-item-aux-sfc 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-ped-op = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-ped-op 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-refer = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-refer 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.dat-ult-atualiz-cp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} dat-ult-atualiz-cp 1}
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
 
    if rowObject.hra-ult-atualiz-cp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} hra-ult-atualiz-cp 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ind-estado-op = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} ind-estado-op 1}
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
        {utp/ut-field.i movind {&TABLE-NAME} it-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.log-possui-coprodut = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} log-possui-coprodut 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.log-reporte-fecha-op = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} log-reporte-fecha-op 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.log-reporte-item-altern = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} log-reporte-item-altern 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nome-abrev = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} nome-abrev 1}
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
 
    if rowObject.qtd-aprov-sfc = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-aprov-sfc 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-op = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-op 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-op-min = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-op-min 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-refgda-sfc = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-refgda-sfc 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-reptda-sfc = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-reptda-sfc 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-retrab-sfc = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-retrab-sfc 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-segs-fim-op = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-segs-fim-op 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-segs-inic-op = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-segs-inic-op 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-segs-liber-op = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-segs-liber-op 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-segs-ult-pert = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-segs-ult-pert 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.val-priorid-ext = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} val-priorid-ext 1}
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
    def output parameter r-chave as ROWID NO-UNDO.
 
    run initializeValidate.
    run startMethod ("validateCreate").
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
 
    run validateFields.
 
    find first tt-bo-erro
        no-lock no-error.
    if not available tt-bo-erro then do:
        find op-sfc where
            op-sfc.nr-ord-produ = rowObject.nr-ord-produ
            no-lock no-error.
        if avail op-sfc then do:
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
    define input  parameter c-field as CHAR NO-UNDO.
    define output parameter c-value as CHAR NO-UNDO.
 
    case c-field:
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "cod-item-aux-sfc" then c-value = RowObject.cod-item-aux-sfc.
        when "cod-ped-op" then c-value = RowObject.cod-ped-op.
        when "cod-refer" then c-value = RowObject.cod-refer.
        when "hra-fim-op" then c-value = RowObject.hra-fim-op.
        when "hra-inic-op" then c-value = RowObject.hra-inic-op.
        when "hra-ult-atualiz" then c-value = RowObject.hra-ult-atualiz.
        when "hra-ult-atualiz-cp" then c-value = RowObject.hra-ult-atualiz-cp.
        when "it-codigo" then c-value = RowObject.it-codigo.
        when "nome-abrev" then c-value = RowObject.nome-abrev.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as CHAR    NO-UNDO.
    define output parameter c-value as DECIMAL NO-UNDO.
 
    case c-field:
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "qtd-aprov-sfc" then c-value = RowObject.qtd-aprov-sfc.
        when "qtd-op" then c-value = RowObject.qtd-op.
        when "qtd-op-max" then c-value = RowObject.qtd-op-max.
        when "qtd-op-min" then c-value = RowObject.qtd-op-min.
        when "qtd-refgda-sfc" then c-value = RowObject.qtd-refgda-sfc.
        when "qtd-reptda-sfc" then c-value = RowObject.qtd-reptda-sfc.
        when "qtd-retrab-sfc" then c-value = RowObject.qtd-retrab-sfc.
        when "qtd-segs-fim-op" then c-value = RowObject.qtd-segs-fim-op.
        when "qtd-segs-fmt" then c-value = RowObject.qtd-segs-fmt.
        when "qtd-segs-imc" then c-value = RowObject.qtd-segs-imc.
        when "qtd-segs-inic-op" then c-value = RowObject.qtd-segs-inic-op.
        when "qtd-segs-liber-op" then c-value = RowObject.qtd-segs-liber-op.
        when "qtd-segs-ult-pert" then c-value = RowObject.qtd-segs-ult-pert.
        when "val-priorid-ext" then c-value = RowObject.val-priorid-ext.
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as CHAR    NO-UNDO.
    define output parameter c-value as INTEGER NO-UNDO.
 
    case c-field:
        when "ind-estado-op" then c-value = RowObject.ind-estado-op.
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "nr-linha" then c-value = RowObject.nr-linha.
        when "nr-ord-produ" then c-value = RowObject.nr-ord-produ.
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as CHAR NO-UNDO.
    define output parameter c-value as DATE NO-UNDO.
 
    case c-field:
        when "dat-fim-op" then c-value = RowObject.dat-fim-op.
        when "dat-fim-op-cp" then c-value = RowObject.dat-fim-op-cp.
        when "dat-fmt" then c-value = RowObject.dat-fmt.
        when "dat-imc" then c-value = RowObject.dat-imc.
        when "dat-inic-op" then c-value = RowObject.dat-inic-op.
        when "dat-inic-op-cp" then c-value = RowObject.dat-inic-op-cp.
        when "dat-liber-op" then c-value = RowObject.dat-liber-op.
        when "dat-ult-atualiz" then c-value = RowObject.dat-ult-atualiz.
        when "dat-ult-atualiz-cp" then c-value = RowObject.dat-ult-atualiz-cp.
        when "dat-ult-pert" then c-value = RowObject.dat-ult-pert.
        when "data-1" then c-value = RowObject.data-1.
        when "data-2" then c-value = RowObject.data-2.
        otherwise return error.
    end case.
end procedure.
 
procedure getLogField:
    define input  parameter c-field as CHAR    NO-UNDO.
    define output parameter c-value as LOGICAL NO-UNDO.
 
    case c-field:
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.
        when "log-possui-coprodut" then c-value = RowObject.log-possui-coprodut.
        when "log-reporte-fecha-op" then c-value = RowObject.log-reporte-fecha-op.
        when "log-reporte-item-altern" then c-value = RowObject.log-reporte-item-altern.
        otherwise return error.
    end case.
end procedure.



PROCEDURE piFinalizar.

IF VALID-HANDLE(h-cpapi301b) THEN DO:
    DELETE OBJECT h-cpapi301b.
END.
 
END PROCEDURE.

 
/*******************************************************************************
**
** Procedures de Negocio
**
*******************************************************************************/
{inbo/boin533.i1}
{inbo/boin535.i2} /*** CalcularTempoPadrao ***/ /* Ativ. 161136 */
