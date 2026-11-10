/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX085A 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX085A MUT}
&ENDIF

/*******************************************************************************
**
**  BOCX085.P
**
**  cotacao-item-cex - Cotacao Despesas do Item
**
*******************************************************************************/

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY cotacao-item-cex
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME cotacao-item-cex

def var i-numero-ordem like cotacao-item-cex.numero-ordem no-undo. 
                          
{include/boini.i}

{cxbo/bocx085.i RowObject}

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling. 

{include/bonav.i}
{include/bosetcur.i}

procedure setConstraint1:
    def input parameter p-numero-ordem as char no-undo.

    assign i-numero-ordem = integer(p-numero-ordem).
end procedure.
 
procedure setConstraint2:
    def input parameter p-numero-ordem as char no-undo.

    assign i-numero-ordem = integer(p-numero-ordem).
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
        when 2 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} where
                cotacao-item-cex.numero-ordem >= i-numero-ordem no-lock.
    end case.
    assign l-query    = true
           i-bo-query = i-abertura.
end procedure.
 
procedure serverSendRows :
    /*
    **  Disponivel no smart data object da V9, e foi reimplementado dentro
    **  da versao 8. Faz consultas utilizando a querie dentro da smartquery,
    **  possibilitando que clientes WebSpeed acessem esta mesma smart-query
    **  e facilitara a migracao destes programas para os Smart Data Objects.
    */
    define input  parameter piStartRow     as  integer   no-undo.
    define input  parameter pcRowIdent     as  character no-undo.
    define input  parameter plNext         as  logical   no-undo.
    define input  parameter piRowsToReturn as  integer   no-undo.
    define output parameter piRowsReturned as  integer   no-undo.
    define output parameter table          for RowObject.
 
    define variable hQuery        as handle    no-undo.
    define variable hBuffer       as handle    no-undo.
    define variable hRowObject    as handle    no-undo.
    define variable hDataQuery    as handle    no-undo.
    define variable cRowIdent     as character no-undo.
    define variable rRowIDs       as rowid     extent 10 no-undo.
    define variable lOK           as logical   no-undo.
    define variable iRow          as integer   no-undo.
 
    for each rowObject:
        delete rowObject.
    end.
    IF true THEN DO:
        IF pcRowIdent NE ? AND pcRowIdent NE "":U THEN DO:
            rRowIDs = ?.
            reposition {&query-name} to rowid to-rowid(pcRowIdent).
            get next {&query-name}.
        END.
        ELSE IF piStartRow NE ? AND piStartRow NE 0 THEN DO:
            REPOSITION  {&query-name} TO ROW piStartRow.
            GET next {&query-name}.
        END.
        IF plNext THEN
            GET next {&query-name}.
        DO WHILE true:            
            if available({&first-table-in-query})  and piRowsReturned < piRowsToReturn then do:                 
                 if not can-find(rowObject where 
                    rowObject.numero-ordem = {&table-name}.numero-ordem and
                    rowObject.cod-emitente = {&table-name}.cod-emitente and
                    rowObject.it-codigo    = {&table-name}.it-codigo and
                    rowObject.seq-cotac    = {&table-name}.seq-cotac and
                    rowObject.mapa-cotacao = {&table-name}.mapa-cotacao ) then do:
                    create rowObject.
                    buffer-copy {&table-name} to rowObject.
                    assign rowObject.r-rowid = rowid({&table-name}).
                    piRowsReturned = piRowsReturned + 1.
                end.
                GET NEXT {&query-name}.                    
            end.
            else
                leave.
        END.
        IF piRowsReturned > 0 THEN DO:
            {&open-query}
            IF piStartRow = ? OR piStartRow = 0 THEN DO:
                get first {&query-name}.
                get prev {&query-name}.
            END.
            ELSE
                REPOSITION  {&query-name} TO ROW (piStartRow).
        END.
    END.
    RETURN.
end procedure.
 
procedure prevBrowseNavigation:
    /*
    **  Usado na navega»’o anterior do serverSendRows 
    */
    def input parameter c-rowid-atual as char no-undo.
    def input parameter i-linhas-prev as integer no-undo.
    def output parameter c-rowid-ant as char no-undo.
 
    def var i-cont as integer no-undo.
 
    reposition {&query-name} to rowid to-rowid(c-rowid-atual).
 
    do while (i-cont < (i-linhas-prev - 1)):
       get prev {&query-name}.
       assign i-cont = i-cont + 1.
    end.
    assign c-rowid-ant = string(rowid({&table-name})).
end procedure.
