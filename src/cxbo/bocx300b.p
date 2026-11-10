/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX300B 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX300B MUT}
&ENDIF

/*******************************************************************************
**
**  BOCX300B.P
**
**  cot-ordem - Cota‡äes por Grupo Ordem
**
*******************************************************************************/

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY cot-ordem
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME cot-ordem

{include/boini.i}
{cxbo/bocx300.i RowObject}

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

def var c-cod-agrup  like cot-ordem.cod-agrup no-undo.
def var i-mapa-ordem like cot-ordem.mapa-ordem no-undo.

procedure setConstraint1:
end procedure.

procedure setConstraint2:
    def input parameter p-cod-agrup  like cot-ordem.cod-agrup no-undo.
    
    assign c-cod-agrup  = p-cod-agrup. 
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                where {&TABLE-NAME}.cod-agrup  >= c-cod-agrup.
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
/* {include/bosersen.i} */
/* {include/boprebro.i} */

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
        DO WHILE available({&first-table-in-query}) :
            if piRowsToReturn <> 0 and piRowsReturned >= piRowsToReturn then do:
               leave.
            end.
            if not can-find(rowObject where rowObject.cod-agrup = {&table-name}.cod-agrup and
                                            rowObject.mapa-ordem = {&table-name}.mapa-ordem) then do:
                create rowObject.
                buffer-copy {&table-name} to rowObject.
                assign rowobject.r-rowid = rowid({&table-name}).
            end.                
            GET NEXT {&query-name}.
            piRowsReturned = piRowsReturned + 1.
        END.
        IF piRowsReturned > 0 THEN DO:
            RUN openQuery(i-bo-query).
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
