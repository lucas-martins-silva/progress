/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX190A 2.00.00.009 } /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx190a MUT}
&ENDIF

/*******************************************************************************
**
**  BOCX190A.P - Desembarque
**
**  embarque-imp - Embarque
**
*******************************************************************************/

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY tt-re-class-fisc
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME tt-re-class-fisc

define var lweb as logical no-undo.

{include/boini.i}
{cxbo/bocx190a.i RowObject}
{cxbo/bocx190a.i tt-re-class-fisc}
{cxbo/bocx190a.i tt-re-class-fisc2}
{cdp/cdcfgmat.i}

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

DEFINE BUFFER b-re-class-fisc for {&TABLE-NAME}.    

    
DEFINE TEMP-TABLE tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".    
    
def var l-acomp        as logical initial no no-undo.

def var d-embarq       as dec     no-undo.
def var c-cod-estabel  as char    no-undo.
def var i-cod-emitente as integer no-undo.
def var c-estab-fisc   as char    no-undo.
def var i-cont         as integer no-undo.
def var c-return1       as char    no-undo.

procedure setConstraint1:
def input parameter r-cod-embarque as rowid no-undo.

end procedure. 

procedure setConstraint2:
    def input parameter p-cod-emitente   as integer no-undo.
    def input parameter p-cod-estabel    as char    no-undo.
    def input parameter p-estab-fisc     as char    no-undo.
    
   
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.    
        when 2 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
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

procedure setserver:
    define input parameter plweb as logical no-undo.
    assign lweb = plweb.
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
                if lweb then do:
                   assign rowobject.r-rowid = {&table-name}.r-rowid.
                end.   
                else do:
                   assign rowobject.r-rowid = rowid({&table-name}).
                end.
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

procedure carregaTTReClassFisc:
  def input param c-nr-proc-exp like processo-exp.nr-proc-exp.
  def input param c-cod-estabel like processo-exp.cod-estabel.

  for each tt-re-class-fisc no-lock.
     delete tt-re-class-fisc.
  end.

  for each proc-ped-ent where 
           proc-ped-ent.nr-proc-exp = c-nr-proc-exp and
           proc-ped-ent.cod-estabel = c-cod-estabel NO-LOCK:

      FOR EACH proc-it-nota-fisc
        WHERE proc-it-nota-fisc.cod-estabel  = proc-ped-ent.cod-estabel
          AND proc-it-nota-fisc.nr-proc-exp  = proc-ped-ent.nr-proc-exp
          AND proc-it-nota-fisc.nr-pedcli    = proc-ped-ent.nr-pedcli 
          AND proc-it-nota-fisc.nr-sequencia = proc-ped-ent.nr-sequencia
          AND proc-it-nota-fisc.it-codigo    = proc-ped-ent.it-codigo
          AND proc-it-nota-fisc.cod-refer    = proc-ped-ent.cod-refer 
          AND proc-it-nota-fisc.nr-entrega   = proc-ped-ent.nr-entrega NO-LOCK:

            FIND FIRST nota-fiscal 
                 WHERE nota-fiscal.cod-estabel = proc-it-nota-fisc.cod-estab-faturam
                   AND nota-fiscal.serie       = proc-it-nota-fisc.serie
                   AND nota-fiscal.nr-nota-fis = proc-it-nota-fisc.nr-nota-fis NO-LOCK NO-ERROR.
            IF AVAIL nota-fiscal
            AND nota-fiscal.dt-cancela <> ? THEN NEXT.

            FIND FIRST it-nota-fisc
                  WHERE it-nota-fisc.cod-estabel = proc-it-nota-fisc.cod-estab-faturam
                    AND it-nota-fisc.serie       = proc-it-nota-fisc.serie
                    AND it-nota-fisc.nr-nota-fis = proc-it-nota-fisc.nr-nota-fis
                    AND it-nota-fisc.nr-seq-fat  = proc-it-nota-fisc.nr-seq-fat
                    AND it-nota-fisc.it-codigo   = proc-it-nota-fisc.it-codigo NO-LOCK NO-ERROR.
            IF AVAIL it-nota-fisc THEN DO:
                find first tt-re-class-fisc 
                     where tt-re-class-fisc.class-fiscal = it-nota-fisc.class-fiscal no-error.

                if not avail tt-re-class-fisc then do:
                   create tt-re-class-fisc.                
                   assign tt-re-class-fisc.nr-re        = proc-ped-ent.nr-re
                          tt-re-class-fisc.proc-exp     = proc-ped-ent.nr-proc-exp
                          tt-re-class-fisc.cod-estab    = proc-ped-ent.cod-estabel
                          tt-re-class-fisc.ncm          = INT(STRING(proc-ped-ent.int-2,"99"))
                          tt-re-class-fisc.class-fiscal = it-nota-fisc.class-fiscal
                          tt-re-class-fisc.r-rowid      = rowid(proc-ped-ent).
                END.
           END.
      END.
  end.         
end procedure.


/*procedure modificaReClassFisc:
 * def input-output param table for tt-re-class-fisc.
 * def input param  p-re as char no-undo.
 * def input param  r-row as rowid no-undo.
 * 
 * def var c-re as char no-undo.
 * 
 * /* Criado campo c-rowid pois ao gravar contexto de transa‡Æo no programa wex0190de.p
 *    o campo r-rowid recebe um valor sequencial por defini‡Æo da template de transbo */
 *    
 * find first tt-re-class-fisc
 *     where tt-re-class-fisc.c-rowid = string(r-row) no-error.
 * if avail tt-re-class-fisc then do transaction:
 *     assign  c-re = p-re.
 *     for each proc-ped-ent
 *         where proc-ped-ent.nr-proc-exp = tt-re-class-fisc.proc-exp
 *           and proc-ped-ent.cod-estabel = tt-re-class-fisc.cod-estab
 *           exclusive-lock:
 *         for each item
 *             where item.it-codigo    = proc-ped-ent.it-codigo
 *               and item.class-fiscal = tt-re-class-fisc.class-fisc
 *               no-lock:
 *             assign proc-ped-ent.nr-re = c-re.                               
 *             assign tt-re-class-fisc.nr-re        = c-re
 *                    tt-re-class-fisc.proc-exp     = proc-ped-ent.nr-proc-exp
 *                    tt-re-class-fisc.cod-estab    = proc-ped-ent.cod-estabel
 *                    tt-re-class-fisc.class-fiscal = item.class-fiscal.
 *         end.
 *     end.
 * end.
 *   
 * end procedure.*/

procedure modificaReClassFisc:
def input parameter p-cod-estabel  like estabelec.cod-estabel     no-undo.
def input parameter p-nr-proc-exp  like processo-exp.nr-proc-exp  no-undo.
def input parameter p-class-fiscal like classif-fisc.class-fiscal no-undo.
def input parameter p-re           as   char                      no-undo.
def input parameter p-ncm          as   integer                   no-undo.
def input parameter p-l-re         as   log                       no-undo.

for each proc-ped-ent
   where proc-ped-ent.nr-proc-exp = p-nr-proc-exp
     and proc-ped-ent.cod-estabel = p-cod-estabel EXCLUSIVE-LOCK:

    FOR EACH proc-it-nota-fisc
        WHERE proc-it-nota-fisc.cod-estabel  = proc-ped-ent.cod-estabel
          AND proc-it-nota-fisc.nr-proc-exp  = proc-ped-ent.nr-proc-exp
          AND proc-it-nota-fisc.nr-pedcli    = proc-ped-ent.nr-pedcli 
          AND proc-it-nota-fisc.nr-sequencia = proc-ped-ent.nr-sequencia
          AND proc-it-nota-fisc.it-codigo    = proc-ped-ent.it-codigo
          AND proc-it-nota-fisc.cod-refer    = proc-ped-ent.cod-refer 
          AND proc-it-nota-fisc.nr-entrega   = proc-ped-ent.nr-entrega NO-LOCK:

        FIND FIRST nota-fiscal 
             WHERE nota-fiscal.cod-estabel = proc-it-nota-fisc.cod-estab-faturam
               AND nota-fiscal.serie       = proc-it-nota-fisc.serie
               AND nota-fiscal.nr-nota-fis = proc-it-nota-fisc.nr-nota-fis NO-LOCK NO-ERROR.
        IF AVAIL nota-fiscal
        AND nota-fiscal.dt-cancela <> ? THEN NEXT.

        FIND it-nota-fisc
              WHERE it-nota-fisc.cod-estabel = proc-it-nota-fisc.cod-estab-faturam
                AND it-nota-fisc.serie       = proc-it-nota-fisc.serie
                AND it-nota-fisc.nr-nota-fis = proc-it-nota-fisc.nr-nota-fis
                AND it-nota-fisc.nr-seq-fat  = proc-it-nota-fisc.nr-seq-fat
                AND it-nota-fisc.it-codigo   = proc-it-nota-fisc.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL it-nota-fisc THEN DO:
            if  p-l-re /* modifica RE */
                and it-nota-fisc.class-fiscal = p-class-fiscal  THEN
                    assign proc-ped-ent.nr-re = p-re.

            FIND ITEM where item.it-codigo    = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.
            IF AVAIL ITEM THEN DO:
                IF int(string(ITEM.dec-1,"99")) = p-ncm THEN  /* modifica NCM */
                   assign proc-ped-ent.int-2 = p-ncm.
            END.
        END.
    END.
end.

end procedure.
