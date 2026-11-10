/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX220D 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx220d MUT}
&ENDIF

/*******************************************************************************
**
**  BOCX220D.P
**
**  ordens-embarque - Ordens Embarque
**
*******************************************************************************/

{cdp/cdcfgmat.i} /* DefiniîÒo de prì-processadores */

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY tt-ordens
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME tt-ordens

{include/boini.i}

{cxbo/bocx220d.i RowObject}
{cxbo/bocx220d.i tt-ordens}


def var cCodEstabel as char no-undo.
def var cEmbarque   as char no-undo.

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

procedure setConstraint1:
    def input parameter pcodestabel as char no-undo.
    def input parameter pembarque   as char no-undo.
    
          
    def var lprimeiro as logical initial yes.
    def var i-cont    as integer no-undo.
    assign i-cont = 0.
    
    for each {&TABLE-NAME}:
       delete {&TABLE-NAME}.
    end.
    for each ordens-embarque where
             ordens-embarque.embarque    = pembarque   and
             ordens-embarque.cod-estabel = pcodestabel no-lock
             break by ordens-embarque.identific-container:
             if first-of(ordens-embarque.identific-container) then do:
                i-cont = i-cont + 1.
                find {&TABLE-NAME} where
                     {&TABLE-NAME}.embarque            = ordens-embarque.embarque and
                     {&TABLE-NAME}.cod-estabel         = ordens-embarque.cod-estabel and
                     {&table-name}.identific-container = ordens-embarque.identific-container EXCLUSIVE-LOCK no-error.
                if not avail {&TABLE-NAME} then do:
                    if  ordens-embarque.identific-container <> "" or
                        not can-find(first ordens-embarque where 
                                ordens-embarque.embarque    = pembarque    and
                                ordens-embarque.cod-estabel = pcodestabel and
                                ordens-embarque.identific-container <> "" no-lock) then do:
                         
                         create {&TABLE-NAME}.
                         assign {&TABLE-NAME}.embarque      = pembarque
                                {&TABLE-NAME}.cod-estabel   = pcodestabel
                                {&table-name}.identific-container = ordens-embarque.identific-container
                                {&TABLE-NAME}.tipo-container      = substring(ordens-embarque.char-1,21,20)
                                {&TABLE-NAME}.r-rowid             = to-rowid("0x0" + string(i-cont,"99999"))
                                {&TABLE-NAME}.dDtPrevDev          = IF substring(ordens-embarque.char-1,84,10) = "" THEN ? ELSE date(substring(ordens-embarque.char-1,84,10))
                                {&TABLE-NAME}.dDtDevol            = IF substring(ordens-embarque.char-1,94,10) = "" THEN ? ELSE date(substring(ordens-embarque.char-1,94,10)).
                    end.                    
                end.                    
             end.
    end.
end procedure. 

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then do:
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
        end.
    end case.
    assign l-query    = true
           i-bo-query = i-abertura.
end procedure.

 
{include/bostrmet.i}
{include/boendmet.i}
{include/bocomver.i}
{include/bogetver.i}
/**{include/bonav.i}**/
/**{include/bofind.i}**/
/**{include/bosetcur.i}**/
{include/bogetcur.i}
/*{include/bosersen.i}*/
{include/boprebro.i}

procedure findPk_codigo:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input  parameter c-cod-estabel as char no-undo.
    def input  parameter c-embarque    as char no-undo.
    def output parameter c-return as char no-undo.
    
    run startMethod("find":U).

    find first {&table-name} where
               {&table-name}.cod-estabel = c-cod-estabel and
               {&table-name}.embarque    = c-embarque
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

procedure findPk_codigo_container:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input  parameter c-cod-estabel as char no-undo.
    def input  parameter c-embarque    as char no-undo.
    def input  parameter c-identific   as char no-undo.
    def output parameter c-return as char no-undo.
    
    run startMethod("find":U).

    find first {&table-name} where
               {&table-name}.cod-estabel = c-cod-estabel and
               {&table-name}.embarque    = c-embarque    and
               {&table-name}.identific-container = c-identific
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

procedure FindOrdensAdd:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */

    def input  parameter c-embarque    as char no-undo.
    def input  parameter c-cod-estabel as char no-undo.
    def output parameter l-return      as logical no-undo.
    
    run startMethod("find":U).
    
    find first ordens-embarque where
               ordens-embarque.cod-estabel = c-cod-estabel and
               ordens-embarque.embarque    = c-embarque    and
               ordens-embarque.identific-container = ""  
               no-lock no-error.
    if not avail ordens-embarque then do:
       assign l-return = no.
    end.
    else do:
       assign l-return = yes.
    end.
end procedure.

procedure setCurrent:
    /*
    **  Seta registro corrente para a temp-table que sera devolvida.
    */
    for each RowObject:
        delete RowObject.
    end.
    if avail {&TABLE-NAME} then do:
        create RowObject.
        buffer-copy {&TABLE-NAME} to RowObject.
        assign rowObject.r-rowid = {&TABLE-NAME}.r-rowid.
    end.
end procedure.

procedure findRowid:
    /*
    **  Localiza registro pelo rowid e nao retorna o registro.
    */
    def input parameter r-chave as rowid no-undo.
    
    find {&TABLE-NAME} where {&TABLE-NAME}.r-rowid = r-chave no-lock no-error.
    
    if l-query then do:
        reposition {&QUERY-NAME}
            to rowid rowid({&TABLE-NAME}) no-error.
            get next {&QUERY-NAME}
                no-lock no-wait.
    end.
    else
        find {&TABLE-NAME} where
             {&TABLE-NAME}.r-rowid = r-chave no-lock no-error.
    if avail {&TABLE-NAME} then RUN setCurrent.
end procedure.

procedure findFirst:
    if l-query then
        get first {&QUERY-NAME}
            no-lock no-wait.
    else
        find first {&TABLE-NAME}
            no-lock no-error.
    run setCurrent.
end procedure.

procedure findPrev:
    def output parameter c-return as char.
    if l-query then
        get prev {&QUERY-NAME}
            no-lock no-wait.
    else
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

procedure findNext:
    def output parameter c-return as char.
    if l-query then
        get next {&QUERY-NAME}
            no-lock no-wait.
    else
        find next {&TABLE-NAME}
            no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        run utp/ut-msgs.p (input "msg",
                           input 7999,
                           input "").
        assign c-return = return-value.
    end.
    else run setCurrent.
end procedure.

procedure findLast:
    if l-query then
        get last {&QUERY-NAME}
            no-lock no-wait.
    else
        find last {&TABLE-NAME}
            no-lock no-error.
    run setCurrent.
end procedure.

procedure getRowid:
    def output parameter r-chave as rowid no-undo.
    if avail {&TABLE-NAME} then do:
        assign r-chave = {&TABLE-NAME}.r-rowid.
    end.
    else do:
       assign r-chave = ?.
    end.
end procedure.




PROCEDURE serverSendRows :

    /*
    **  Disponivel no smart data object da V9, e foi reimplementado dentro
    **  da versao 8. Faz consultas utilizando a querie dentro da smartquery,
    **  possibilitando que clientes WebSpeed acessem esta mesma smart-query
    **  e facilitara a migracao destes programas para os Smart Data Objects.
    */

    DEFine input  parameter piStartRow     as  integer   no-undo.
    DEFine input  parameter pcRowIdent     as  character no-undo.
    DEFine input  parameter plNext         as  logical   no-undo.
    DEFine input  parameter piRowsToReturn as  integer   no-undo.
    DEFine output parameter piRowsReturned as  integer   no-undo.
    DEFine output parameter table          for RowObject.
 
    DEFine variable hQuery        as handle    no-undo.
    DEFine variable hBuffer       as handle    no-undo.
    DEFine variable hRowObject    as handle    no-undo.
    DEFine variable hDataQuery    as handle    no-undo.
    DEFine variable cRowIdent     as character no-undo.
    DEFine variable rRowIDs       as rowid     extent 10 no-undo.
    DEFine variable lOK           as logical   no-undo.
    DEFine variable iRow          as integer   no-undo.
 
    for each rowObject:
        delete rowObject.
    end.
    IF true THEN DO:
        IF pcRowIdent NE ? AND pcRowIdent NE "":U THEN DO:
            rRowIDs = ?.
            reposition {&query-name} to rowid to-rowid(pcRowIdent) no-error.
            get next {&query-name}.
        END.
        ELSE IF piStartRow NE ? AND piStartRow NE 0 THEN DO:
            REPOSITION  {&query-name} TO ROW piStartRow no-error.
            GET next {&query-name}.
        END.
        IF plNext THEN
            GET next {&query-name}.
        DO WHILE true:
            if available({&first-table-in-query})  and piRowsReturned < piRowsToReturn then do:
                create rowObject.
                buffer-copy {&table-name} to rowObject.
                /* assign rowobject.r-rowid = {&table-name}.r-rowid. */
                assign rowObject.r-rowid = rowid({&table-name}).
                GET NEXT {&query-name}.
                
                piRowsReturned = piRowsReturned + 1.
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
                REPOSITION  {&query-name} TO ROW (piStartRow) no-error.
        END.
    END.
    RETURN.
END PROCEDURE.




























