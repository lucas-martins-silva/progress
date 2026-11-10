/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN404DB 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin404db MUT}
&ENDIF

/*******************************************************************************
**
**  boin404db.P - Desembarque
**
**  embarque-imp - Embarque
**
*******************************************************************************/
{cdp/cdcfgdis.i} /* pre-processadores distribuicao */

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY tt-saldo-terc-aux
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME tt-saldo-terc-aux

{include/boini.i}
{inbo/boin404.i RowObject}
{inbo/boin404.i tt-saldo-terc-aux}
{inbo/boin404.i tt-saldo-terc-aux2}
{inbo/boin111a.i tt-item-estrut }

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

DEFINE BUFFER b-saldo-terc-aux for {&TABLE-NAME}.
    
DEFINE TEMP-TABLE tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".
    
def var l-acomp        as logical NO-UNDO initial no.
def var c-embarque     as char    no-undo.
def var c-cod-estabel  as char    no-undo.
def var i-cod-emitente as integer no-undo.
def var c-estab-fisc   as char    no-undo.
def var i-cont         as integer no-undo.
def var c-return1       as char   no-undo.

procedure setConstraint1:
    def input param table for tt-item-estrut.

end procedure.

procedure setConstraint2:
    def input parameter p-cod-emitente   as integer no-undo.
    def input parameter p-cod-estabel    as char    no-undo.
    def input parameter p-estab-fisc     as char    no-undo.    
   
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then do:
            find first param-global no-lock no-error.
            if avail param-global then do:
                if param-global.modulo-en then do:
                    for each {&table-Name}:
                        find first tt-item-estrut no-lock where 
                                   tt-item-estrut.it-codigo = {&table-name}.it-codigo
                                    no-error.
                        assign {&Table-Name}.log-1 = avail tt-item-estrut. 
                    end.

                    open query {&QUERY-NAME} for each {&table-Name} no-lock
                         where {&table-Name}.nr-ato-concessorio  <> "" and
                               {&table-Name}.quantidade > 0 and 
                               {&table-name}.log-1 = YES By {&table-Name}.it-codigo.
                end.
                else do:
                    for each {&table-Name}:
                        assign {&Table-Name}.log-1 = yes. 
                    end.
                    open query {&QUERY-NAME} for each {&table-Name} no-lock
                         where {&table-Name}.nr-ato-concessorio  <> "" and
                               {&table-Name}.quantidade > 0 and 
                               {&table-name}.log-1 = yes By {&Table-Name}.it-codigo.
                end.
            end.
        end.
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
/*{include/bosetcur.i}*/
{include/bogetcur.i}
/*{include/bosersen.i}*/
{include/boprebro.i}
{utp/ut-glob.i}

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
    end.
end procedure.

procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
     
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
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

                for each {&table-name}:
                  find first rowObject where 
                             rowObject.serie-docto  = {&table-name}.serie-docto and
                             rowObject.nro-docto    = {&table-name}.nro-docto and
                             rowObject.cod-emitente = {&table-name}.cod-emitente and
                             rowObject.nat-operacao = {&table-name}.nat-operacao and
                             rowObject.it-codigo    = {&table-name}.it-codigo and
                             rowObject.cod-refer    = {&table-name}.cod-refer and
                             rowObject.sequencia    = {&table-name}.sequencia no-lock no-error.
                  if not avail rowObject then do:                
                        create rowObject.
                        buffer-copy {&table-name} to rowObject.
                        assign rowobject.r-rowid = rowid({&table-name}).
                        GET NEXT {&query-name}.
                        piRowsReturned = piRowsReturned + 1.
                  end. /* if not avail ... */
                end. /* for each table name */

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

procedure carregaTTSaldoTerc:
    /*
    ** Carrega tt-saldo-terc-aux para os itens passados pela tt-item-estrut
    */
    def input param table for tt-saldo-terc-aux.
    def input param c-item as char no-undo.

    for each tt-saldo-terc-aux:
        delete tt-saldo-terc-aux.
    end.
    
    for each saldo-terc
        where saldo-terc.nr-ato-concessorio > "" no-lock:
        if saldo-terc.quantidade <= 0 then
            next.
        
        find tt-item-estrut
            where tt-item-estrut.it-codigo = saldo-terc.it-codigo no-error.
        if avail tt-item-estrut then do:
            create tt-saldo-terc-aux.
            buffer-copy saldo-terc to tt-saldo-terc-aux.
            assign tt-saldo-terc-aux.r-rowid = rowid(tt-saldo-terc-aux).
        end.
        
    end.
    
end procedure.

PROCEDURE retornaSaldoTercAux:
    /*
    ** Retorna temp-table tt-saldo-terc-aux
    */
    def output parameter table for tt-saldo-terc-aux.

end procedure.

procedure carregaTTSaldoTerc1:
         
end procedure.

procedure modificaReClassFisc:
def input-output param table for tt-saldo-terc-aux.
def input param p-re as char no-undo.
def input param r-row as rowid no-undo.
def var c-re as char no-undo.
/*find first tt-saldo-terc-aux where tt-saldo-terc-aux.r-rowid = r-row no-error.
 * message "1".  
 * if avail tt-saldo-terc-aux then do transaction:
 *   assign  c-re = p-re.
 *   for each proc-ped-ent where 
 *            proc-ped-ent.nr-proc-exp = tt-saldo-terc-aux.proc-exp and
 *            proc-ped-ent.cod-estabel = tt-saldo-terc-aux.cod-estab:
 *            message "2".
 *       for each item where 
 *                item.it-codigo = proc-ped-ent.it-codigo and
 *                item.class-fiscal = tt-saldo-terc-aux.class-fisc:
 *               message "3". 
 *                            assign proc-ped-ent.nr-re = c-re.
 *           assign tt-saldo-terc-aux.nr-re  = c-re
 * 
 *                  tt-saldo-terc-aux.proc-exp  = proc-ped-ent.nr-proc-exp
 *                  tt-saldo-terc-aux.cod-estab = proc-ped-ent.cod-estabel
 *                  tt-saldo-terc-aux.class-fiscal    = item.class-fiscal.                
 *        message "4".          
 *       end.         
 *   end.         
 * end.  */
end procedure.
