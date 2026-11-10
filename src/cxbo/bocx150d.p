/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX150D 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX150D MUT}
&ENDIF

/*
**  BOCX150D.P
**
**  desp-item - exclusiva zoom
**
*/

def var c-nr-proc-imp     as char no-undo. 
def var i-cod-itiner      as integer no-undo.
def var c-nr-proc-imp-fim as char    initial "ZZZZZZZZZZZZZZZZZ" no-undo. /* formato maior que o do campo nr-proc-imp */
def var i-cod-itiner-fim  as integer initial 999.999             no-undo. /* formato maior que o do campo cod-itiner  */
def var ccod-estab-ini as char no-undo.
def var ccod-estab-fim as char no-undo.
def var cnr-proc-imp-ini as char no-undo.
def var cnr-proc-imp-fim as char no-undo.
def var ccod-itiner-ini as integer no-undo.
def var ccod-itiner-fim as integer no-undo.

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY historico-proc-imp
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME historico-proc-imp

{include/boini.i}

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
{cxbo/bocx150.i RowObject}
{cxbo/bocx150.i tt-historico-proc-imp}

procedure setConstraint1:
end procedure. 
 
procedure setConstraint2:
    def input parameter p-opcao       as char    no-undo.
    def input parameter p-r-chave     as rowid   no-undo.
    def input parameter p-nr-proc-imp as char    no-undo.
    def input parameter p-cod-itiner  as integer no-undo.
    
    assign c-nr-proc-imp-fim = "ZZZZZZZZZZZZZZZZZ" 
           i-cod-itiner-fim  = 999.999.
    case p-opcao:
    when "1" then do:
        find {&table-name} where rowid({&table-name}) = p-r-chave no-lock no-error.
         if avail {&table-name} then
           assign c-nr-proc-imp = {&table-name}.nr-proc-imp
                  i-cod-itiner = {&table-name}.cod-itiner.
        /** A tabela do Filho deve apresentar apenas registros do registro Pai corrente **/
        find last {&table-name} where historico-proc-imp.nr-proc-imp = c-nr-proc-imp and
                               historico-proc-imp.cod-itiner = i-cod-itiner no-lock no-error.
             assign c-nr-proc-imp-fim = {&Table-name}.nr-proc-imp
                  i-cod-itiner-fim = {&table-name}.cod-itiner.
     end.
    when "2" then do:
     /*find {&table-name} where historico-proc-imp.nr-proc-imp = c-nr-proc-imp and
                            historico-proc-imp.cod-itiner = i-cod-itiner no-lock no-error.*/
      assign c-nr-proc-imp = p-nr-proc-imp
             i-cod-itiner = p-cod-itiner.
    end.
    end case.
end procedure.

procedure setConstraint3:
def input param pcod-estab-ini as char no-undo.
def input param pcod-estab-fim as char no-undo.
def input param pnr-proc-imp-ini as char no-undo.
def input param pnr-proc-imp-fim as char no-undo.
def input param pcod-itiner-ini as integer no-undo.
def input param pcod-itiner-fim as integer no-undo.

assign ccod-estab-ini = pcod-estab-ini
       ccod-estab-fim = pcod-estab-fim
       cnr-proc-imp-ini = pnr-proc-imp-ini
       cnr-proc-imp-fim = pnr-proc-imp-fim
       ccod-itiner-ini = pcod-itiner-ini
       ccod-itiner-fim = pcod-itiner-fim.
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock where
                historico-proc-imp.cod-estabel >= ccod-estab-ini and
                historico-proc-imp.cod-estabel <= ccod-estab-fim and
                historico-proc-imp.nr-proc-imp >= cnr-proc-imp-ini and
                historico-proc-imp.nr-proc-imp <= cnr-proc-imp-fim and
                historico-proc-imp.cod-itiner  >= ccod-itiner-ini and
                historico-proc-imp.cod-itiner  <= ccod-itiner-fim 
                by historico-proc-imp.cod-estabel
                by historico-proc-imp.nr-proc-imp
                by historico-proc-imp.cod-itiner.

        when 3 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock where
                historico-proc-imp.cod-estabel >= ccod-estab-ini and
                historico-proc-imp.cod-estabel <= ccod-estab-fim and
                historico-proc-imp.nr-proc-imp >= cnr-proc-imp-ini and
                historico-proc-imp.nr-proc-imp <= cnr-proc-imp-fim and
                historico-proc-imp.cod-itiner  >= ccod-itiner-ini and
                historico-proc-imp.cod-itiner  <= ccod-itiner-fim 
                by historico-proc-imp.nr-proc-imp
                by historico-proc-imp.cod-estabel
                by historico-proc-imp.cod-itiner.
        when 4 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock where
                historico-proc-imp.cod-estabel >= ccod-estab-ini and
                historico-proc-imp.cod-estabel <= ccod-estab-fim and
                historico-proc-imp.nr-proc-imp >= cnr-proc-imp-ini and
                historico-proc-imp.nr-proc-imp <= cnr-proc-imp-fim and
                historico-proc-imp.cod-itiner  >= ccod-itiner-ini and
                historico-proc-imp.cod-itiner  <= ccod-itiner-fim 
                by historico-proc-imp.cod-itiner
                by historico-proc-imp.cod-estabel
                by historico-proc-imp.nr-proc-imp.

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
/*{include/bosersen.i}*/
/*{include/boprebro.i}*/
/* {include/boexecre.i} */
/* {include/boexeupt.i} */
/* {include/boexedel.i} */
/*{include/bovalupt.i}*/
/* {include/bovaldel.i} */


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
             find first rowObject where rowObject.nr-proc-imp = historico-proc-imp.nr-proc-imp
                  and   rowObject.cod-itiner = historico-proc-imp.cod-itiner 
                  and   rowObject.cod-estabel = historico-proc-imp.cod-estabel no-lock no-error.
             if not avail rowObject then do:
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
    **  Usado na navega‡Æo anterior do serverSendRows 
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

