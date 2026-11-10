/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX125 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX125 MUT}
&ENDIF

{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */
/*
**  BOCX125.P
**
**  desp-itiner - 
**
**  Ultima altera‡Æo: 04/05/99 - GeraBO
**  Ultima altera‡Æo: 05/05/99 - brv9586.
*/

def var i-cod-itiner  as int.
def var i-pto-contr   as int.
def var i-desp        as int.
DEF VAR l-valida-desp AS LOG.
DEFINE VARIABLE c-trad-1 AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-trad-2 AS CHARACTER NO-UNDO.

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY desp-itiner
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME desp-itiner
 
 
 
{include/boini.i}
 
{cxbo/bocx125.i RowObject}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
 
procedure setconstraint1:

end procedure. 

procedure setConstraint2:
    def input parameter c-cod-itiner as char.
    def input parameter c-pto-contr  as char.
    def input parameter c-desp       as char.
    
    assign i-cod-itiner = int(c-cod-itiner)
           i-pto-contr  = int(c-pto-contr)
           i-desp       = int(c-desp).
end procedure.

procedure setConstraint3:
    def input parameter r-chave as rowid no-undo.
    find pto-itiner no-lock where rowid(pto-itiner) = r-chave no-error.
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then        
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
        when 2 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} where desp-itiner.cod-itiner    = i-cod-itiner and 
                                                                  desp-itiner.cod-desp      = i-desp       and 
                                                                  desp-itiner.cod-pto-contr = i-pto-contr  no-lock.
        when 3 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} of pto-itiner /*where desp-itiner.cod-itiner    = i-cod-itiner and 
 *                                                                                 desp-itiner.cod-desp      = i-desp       and 
 *                                                                                 desp-itiner.cod-pto-contr = i-pto-contr*/  no-lock by {&TABLE-NAME}.cod-itiner.
        when 4 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} of pto-itiner no-lock.
                                                                 
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
/*{include/bovalupt.i}*/
{include/bovaldel.i}
 
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
    def input parameter i-cod-itiner as inte no-undo.
    def input parameter i-cod-pto-contr as inte no-undo.
    def input parameter i-cod-desp as inte no-undo.
    def output parameter c-return as char no-undo.
 
    find desp-itiner where
        desp-itiner.cod-itiner = i-cod-itiner
        and desp-itiner.cod-pto-contr = i-cod-pto-contr
        and desp-itiner.cod-desp = i-cod-desp
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
 
    run startmethod ("ValidateUpdate").

    run InitializeValidate.
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
   
    run validateFields.
    
/*    find {&TABLE-NAME} where rowid({&TABLE-NAME}) = rowObject.r-rowid no-lock no-error.
 *     if {&TABLE-NAME}.cod-itiner <> rowObject.cod-itiner then do:
 *        assign i-seq-erro = i-seq-erro + 1.
 *        {utp/ut-field.i mgcex itinerario cod-itiner 1}
 *        run utp/ut-msgs.p (input "msg",
 *                           input 16913,
 *                           input return-value).
 *        create tt-bo-erro.
 *        assign tt-bo-erro.i-sequen     = i-seq-erro
 *               tt-bo-erro.cd-erro      = 16913
 *               tt-bo-erro.mensagem     = return-value.                    
 *     end.        
 * 
 *     if {&TABLE-NAME}.cod-desp <> rowObject.cod-desp then do:
 *        assign i-seq-erro = i-seq-erro + 1.
 *        {utp/ut-field.i mgcex desp-itiner cod-desp 1}
 *        run utp/ut-msgs.p (input "msg",
 *                           input 16913,
 *                           input return-value).
 *        create tt-bo-erro.
 *        assign tt-bo-erro.i-sequen     = i-seq-erro
 *               tt-bo-erro.cd-erro      = 16913
 *               tt-bo-erro.mensagem     = return-value.                    
 *     end.        
 *     
 *     if {&TABLE-NAME}.cod-pto-contr <> rowObject.cod-pto-contr then do:
 *        assign i-seq-erro = i-seq-erro + 1.
 *        {utp/ut-field.i mgcex desp-itiner cod-pto-contr 1}
 *        run utp/ut-msgs.p (input "msg",
 *                           input 16913,
 *                           input return-value).
 *        create tt-bo-erro.
 *        assign tt-bo-erro.i-sequen     = i-seq-erro
 *               tt-bo-erro.cd-erro      = 16913
 *               tt-bo-erro.mensagem     = return-value.                    
 *     end.        */
    
    find first tt-bo-erro
        no-lock no-error.
    if not avail tt-bo-erro then do:
        find {&TABLE-NAME} where
            rowid({&TABLE-NAME}) = r-chave
            exclusive-lock no-error.
        run executeUpdate.
    end.
  
  run endmethod ("ValidateUpdate").
  
end procedure.
 
procedure findDespesa:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter i-cod-desp as inte no-undo.
    def input parameter i-cod-itiner as inte no-undo.
    def output parameter c-return as char no-undo.
 
    find desp-itiner where
        desp-itiner.cod-desp = i-cod-desp
        and desp-itiner.cod-itiner = i-cod-itiner
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
 
procedure validateFields:
    /*
    **  Valida Fields
    */
    find first rowObject
        no-lock no-error.
 
    run startMethod ("validateFields").
    
    if rowObject.cod-desp = 0 or rowObject.cod-desp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-desp 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-itiner = 0 or rowObject.cod-itiner = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-itiner 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-pto-contr = 0 or rowObject.cod-pto-contr = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-pto-contr 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    &IF "{&bf_mat_versao_ems}":U >= "2.062":U &THEN
        IF rowObject.cod-emitente <> 0 THEN DO:
            FIND FIRST emitente
                WHERE emitente.cod-emitente = rowObject.cod-emitente NO-LOCK NO-ERROR.
            IF NOT AVAIL emitente THEN DO:
                ASSIGN i-seq-erro = i-seq-erro + 1.
                {utp/ut-liter.i Fornecedor}
                RUN utp/ut-msgs.p (INPUT "msg",
                                   INPUT 2,
                                   INPUT RETURN-VALUE).
                CREATE tt-bo-erro.
                ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 2
                       tt-bo-erro.mensagem     = RETURN-VALUE.
            END.
            ELSE DO:
                IF emitente.identific <> 2 AND emitente.identific <> 3 THEN DO:
                    ASSIGN i-seq-erro = i-seq-erro + 1.
                    {utp/ut-liter.i Emitente}
                    ASSIGN c-trad-1 = RETURN-VALUE.
                    {utp/ut-liter.i Fornecedor}
                    ASSIGN c-trad-2 = RETURN-VALUE.
                    RUN utp/ut-msgs.p (INPUT "msg",
                                       INPUT 17195,
                                       INPUT c-trad-1 + "~~" + c-trad-2).
                    CREATE tt-bo-erro.
                    ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 17195
                           tt-bo-erro.mensagem     = RETURN-VALUE.
                END.
            END.
        END.
    &ENDIF
    
    run endMethod ("validateFields").
 
end procedure.
 
procedure validateCreate:
    /*
    **  Valida cria‡Æo da tabela/duplicidade de registro.
    */

    run startMethod ("validateCreate").

    def input  parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.
 
    run initializeValidate.
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
 
    find first rowObject
        no-lock no-error.
    run validateFields.
    find desp-imp where desp-imp.cod-desp = rowObject.cod-desp no-lock no-error.
    if not avail desp-imp then do:
       assign i-seq-erro = i-seq-erro + 1.
       {utp/ut-table.i mgcex desp-imp 1}
       run utp/ut-msgs.p (input "msg",
                          input 2,
                          input return-value).
       create tt-bo-erro.
       assign tt-bo-erro.i-sequen = i-seq-erro
              tt-bo-erro.cd-erro  = 2
              tt-bo-erro.mensagem = return-value.
    end.                          
        
    find itinerario where itinerario.cod-itiner = rowObject.cod-itiner no-lock no-error.
    if not avail itinerario then do:
       assign i-seq-erro = i-seq-erro + 1.
       {utp/ut-table.i mgcex itinerario 1}
       run utp/ut-msgs.p (input "msg",
                          input 2,
                          input return-value).
       create tt-bo-erro.
       assign tt-bo-erro.i-sequen     = i-seq-erro
              tt-bo-erro.cd-erro      = 2
              tt-bo-erro.mensagem     = return-value.
    end.
    
    find pto-contr where pto-contr.cod-pto-contr = rowObject.cod-pto-contr no-lock no-error.
    if not avail pto-contr then do:
       assign i-seq-erro = i-seq-erro + 1.
       {utp/ut-table.i mgcex pto-contr 1}
       run utp/ut-msgs.p (input "msg",
                          input 2,
                          input return-value).
       create tt-bo-erro.
       assign tt-bo-erro.i-sequen     = i-seq-erro
              tt-bo-erro.cd-erro      = 2
              tt-bo-erro.mensagem     = return-value.
    end.   
    
    ASSIGN l-valida-desp = NO.

    IF CAN-FIND (FIRST desp-itiner
        where desp-itiner.cod-itiner = rowObject.cod-itiner
          and desp-itiner.cod-pto-contr = rowObject.cod-pto-contr 
          and desp-itiner.cod-desp = rowObject.cod-desp) THEN DO:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-table.i mgcex desp-itiner 1}
        run utp/ut-msgs.p (input "msg",
                           input 8,
                           input return-value).
        ASSIGN l-valida-desp = YES.
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
             tt-bo-erro.cd-erro    = 8
             tt-bo-erro.mensagem   = return-value.
    end.

    IF NOT l-valida-desp THEN DO:
        IF CAN-FIND (first desp-itiner 
             where desp-itiner.cod-desp   = rowObject.cod-desp
               and desp-itiner.cod-itiner = rowObject.cod-itiner) THEN DO:
             assign i-seq-erro = i-seq-erro + 1.
             {utp/ut-table.i mgcex desp-itiner 1}
             run utp/ut-msgs.p (input "msg",
                                input 8,
                                input return-value).
             create tt-bo-erro.
             assign tt-bo-erro.i-sequen     = i-seq-erro
                    tt-bo-erro.cd-erro      = 8
                    tt-bo-erro.mensagem     = return-value.
        END.
    END.

    find first tt-bo-erro
        no-lock no-error.
 
    if not avail tt-bo-erro then do:
       run executeCreate.
       assign r-chave = to-rowid(return-value).
    end.
 
    run endMethod ("validateCreate").
end procedure.

procedure findCoditiner:

   /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter c-itiner as char no-undo.
    def output parameter table for RowObject.
 
    find first desp-itiner where
        desp-itiner.cod-itiner = int(c-itiner)
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

procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "check-sum" then c-value = RowObject.check-sum.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "cod-desp" then c-value = RowObject.cod-desp.
        when "cod-itiner" then c-value = RowObject.cod-itiner.
        when "cod-pto-contr" then c-value = RowObject.cod-pto-contr.
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
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
        otherwise return error.
    end case.
end procedure.
 
