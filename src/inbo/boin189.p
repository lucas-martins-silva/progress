/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN189 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin189 MUT}
&ENDIF

/*
**  BOIN189.P
**
**  localizacao - Arquivo de Localização Física
**
**  Ultima altera‡Æo : 02/04/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY localizacao
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME localizacao
 
{cdp/cdcfgren.i} /* pre-processor indices grendene - nao remover */

{include/boini.i}                                                  
 
{inbo/boin189.i RowObject}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
 
/***********Var SetConstraint2************/
def var c-estabel         as char no-undo.
def var c-dep-ini         as char no-undo.
def var c-dep-fim         as char no-undo.
def var c-localiz-ini     as char no-undo.
def var c-localiz-fim     as char no-undo.
def var c-desc-local-ini  as char no-undo.
def var c-desc-local-fim  as char no-undo.
def var c-local-ini       as char no-undo.
def var c-local-fim       as char no-undo. 
procedure setConstraint1:
 
end procedure.

procedure setConstraint2:

def input param p-estabel        as char no-undo.
def input param p-localiz-ini    as char no-undo.
def input param p-localiz-fim    as char no-undo.
def input param p-dep-ini        as char no-undo.
def input param p-dep-fim        as char no-undo.
def input param p-desc-local-ini as char no-undo.
def input param p-desc-local-fim as char no-undo.

assign c-estabel        = p-estabel
       c-dep-ini        = p-dep-ini
       c-dep-fim        = p-dep-fim
       c-localiz-ini    = p-localiz-ini
       c-localiz-fim    = p-localiz-fim
       c-desc-local-ini = p-desc-local-ini
       c-desc-local-fim = p-desc-local-fim .
 
end procedure.

procedure setConstraint3:

/* Recebe o chave da localiza‡Æo
 * Parƒmetro: 
 * param1: p-local-ini : valor inicial. 
 * param2: p-local-fim : valor final.
*/

def input param p-local-ini as char no-undo.
def input param p-local-fim as char no-undo.

assign c-local-ini = p-local-ini
       c-local-fim = p-local-fim.
 
end procedure.
 

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock  INDEXED-REPOSITION.
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                                         by {&TABLE-NAME}.cod-localiz  INDEXED-REPOSITION.
        when 3 then do:
             if c-estabel <> "" then
                open query {&QUERY-NAME} for each {&TABLE-NAME} where
                                                  {&TABLE-NAME}.cod-estabel  = c-estabel        and
                                                  {&TABLE-NAME}.cod-depos   >= c-dep-ini        and
                                                  {&TABLE-NAME}.cod-depos   <= c-dep-fim        and
                                                  {&TABLE-NAME}.descricao   >= c-desc-local-ini and
                                                  {&TABLE-NAME}.descricao   <= c-desc-local-fim and                                                  
                                                  {&TABLE-NAME}.cod-localiz >= c-localiz-ini    and
                                                  {&TABLE-NAME}.cod-localiz <= c-localiz-fim 
                                                   NO-LOCK by {&TABLE-NAME}.cod-localiz  INDEXED-REPOSITION.
            else
                open query {&QUERY-NAME} for each {&TABLE-NAME} where
                                                  {&TABLE-NAME}.descricao   >= c-desc-local-ini and
                                                  {&TABLE-NAME}.descricao   <= c-desc-local-fim and                                                   
                                                  {&TABLE-NAME}.cod-depos   >= c-dep-ini        and
                                                  {&TABLE-NAME}.cod-depos   <= c-dep-fim        and
                                                  {&TABLE-NAME}.descricao   >= c-desc-local-ini and
                                                  {&TABLE-NAME}.descricao   <= c-desc-local-fim and                                                   
                                                  {&TABLE-NAME}.cod-localiz >= c-localiz-ini    and
                                                  {&TABLE-NAME}.cod-localiz <= c-localiz-fim
                                                   NO-LOCK by {&TABLE-NAME}.cod-localiz  INDEXED-REPOSITION.
        end.
        when 4 then do:
             if c-estabel <> "" then
                open query {&QUERY-NAME} for each {&TABLE-NAME} where
                                                  {&TABLE-NAME}.descricao   >= c-desc-local-ini AND 
                                                  {&TABLE-NAME}.descricao   <= c-desc-local-fim AND 
                                                  {&TABLE-NAME}.cod-localiz >= c-localiz-ini    AND 
                                                  {&TABLE-NAME}.cod-localiz <= c-localiz-fim    AND
                                                  {&TABLE-NAME}.cod-estabel  = c-estabel        AND 
                                                  {&TABLE-NAME}.cod-depos   >= c-dep-ini        AND 
                                                  {&TABLE-NAME}.cod-depos   <= c-dep-fim        NO-LOCK  
                                              &IF DEFINED(CUSTOM_GRENDENE) &THEN
                                                  USE-INDEX descricao
                                             &ELSE                 
                                                  BY {&TABLE-NAME}.descricao  
                                             &ENDIF
                                                  INDEXED-REPOSITION.
            else
                open query {&QUERY-NAME} for each {&TABLE-NAME} where
                                                  {&TABLE-NAME}.descricao   >= c-desc-local-ini AND 
                                                  {&TABLE-NAME}.descricao   <= c-desc-local-fim AND 
                                                  {&TABLE-NAME}.cod-localiz >= c-localiz-ini    AND 
                                                  {&TABLE-NAME}.cod-localiz <= c-localiz-fim    AND
                                                  {&TABLE-NAME}.cod-depos   >= c-dep-ini        AND 
                                                  {&TABLE-NAME}.cod-depos   <= c-dep-fim        NO-LOCK  
                                              &IF DEFINED(CUSTOM_GRENDENE) &THEN
                                                  USE-INDEX descricao
                                             &ELSE                 
                                                  BY {&TABLE-NAME}.descricao  
                                             &ENDIF
                                                  INDEXED-REPOSITION.
        end.
        when 5 then do:
                open query {&QUERY-NAME} for each {&TABLE-NAME} where
                                                  {&TABLE-NAME}.cod-estabel >= c-local-ini and
                                                  {&TABLE-NAME}.cod-estabel <= c-local-fim 
                                                   NO-LOCK by {&TABLE-NAME}.cod-estabel  INDEXED-REPOSITION.
 
        end.
        when 6 then do:
                open query {&QUERY-NAME} for each {&TABLE-NAME} where
                                                  {&TABLE-NAME}.descricao >= c-local-ini and
                                                  {&TABLE-NAME}.descricao <= c-local-fim 
                                                   NO-LOCK by {&TABLE-NAME}.descricao  INDEXED-REPOSITION.
        end.
        when 7 then do:
                open query {&QUERY-NAME} for each {&TABLE-NAME} where
                                                  {&TABLE-NAME}.cod-localiz >= c-local-ini and
                                                  {&TABLE-NAME}.cod-localiz <= c-local-fim 
                                                   NO-LOCK by {&TABLE-NAME}.cod-localiz  INDEXED-REPOSITION.
        end.
        when 8 then do:
                open query {&QUERY-NAME} for each {&TABLE-NAME} where
                                                  {&TABLE-NAME}.cod-depos >= c-local-ini and
                                                  {&TABLE-NAME}.cod-depos <= c-local-fim 
                                                   NO-LOCK by {&TABLE-NAME}.cod-depos  INDEXED-REPOSITION.
        end.               
    end case.
    assign l-query = true
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
 
procedure findLocalizacao:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter c-cod-localiz as char no-undo.
    def output parameter c-return as char no-undo.
 
    find first localizacao where
               localizacao.cod-localiz = c-cod-localiz
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
 
procedure findCodigo:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter c-cod-estabel as char no-undo.
    def input parameter c-cod-depos as char no-undo.
    def input parameter c-cod-localiz as char no-undo.
    def output parameter c-return as char no-undo.
 
    find localizacao where
        localizacao.cod-estabel = c-cod-estabel
        and localizacao.cod-depos = c-cod-depos
        and localizacao.cod-localiz = c-cod-localiz
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i mgind {&TABLE-NAME} 1}
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
    if rowObject.cod-depos = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-estabel = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-localiz = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.descricao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
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
 
    find first rowObject
        no-lock no-error.
    if rowObject.cod-depos = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} cod-depos 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-estabel = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} cod-estabel 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-localiz = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} cod-localiz 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.descricao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} descricao 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    find first tt-bo-erro
        no-lock no-error.
    if not available tt-bo-erro then do:
        find localizacao where
            localizacao.cod-estabel = rowObject.cod-estabel
        and localizacao.cod-depos = rowObject.cod-depos
        and localizacao.cod-localiz = rowObject.cod-localiz
            no-lock no-error.
        if avail localizacao then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgind {&TABLE-NAME} 1}
            run utp/ut-msgs.p (input "msg",
                               input 8,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 8
                   tt-bo-erro.mensagem     = return-value.
        end.
    end.
 
    run validateFields.
    find first tt-bo-erro
        no-lock no-error.
 
    if not avail tt-bo-erro then do:
       run executeCreate.
       assign r-chave = to-rowid(return-value).
    end.
 
    run endMethod ("validateCreate").
end procedure.
 
procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "check-sum" then c-value = RowObject.check-sum.
        when "cod-depos" then c-value = RowObject.cod-depos.
        when "cod-estabel" then c-value = RowObject.cod-estabel.
        when "cod-localiz" then c-value = RowObject.cod-localiz.
        when "descricao" then c-value = RowObject.descricao.
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
 
procedure findPrevLocaliz:
    /*
      Procedure com o objetivo de encontrar o registro anterior da 
      tabela Localizacao desde que seja o primeiro registro da tabela 
      com determinado c¢digo (cod-localiz).
      Parametros:
      ipar1 : r-rowid  : rowid corrente da tabela localizacao
      opar2 : c-return : retorna informa‡Æo - éltimo Registro da Tabela 
    */

    def input  parameter r-rowid  as rowid no-undo.
    def output parameter c-return as char  no-undo.
    
    def var c-cod-anterior as char no-undo.

    find first localizacao where
         rowid(localizacao) = r-rowid no-lock no-error.
 
    if  avail localizacao then 
         assign c-cod-anterior = localizacao.cod-localiz. 
  
    repeat while avail localizacao:
        get prev {&query-name} no-lock.
        if  avail localizacao then do:
            if  localizacao.cod-localiz = c-cod-anterior then
                next.
            else do:
                run setCurrent.
                leave.
            end.
        end.
        else do:
            run utp/ut-msgs.p (input "msg",
                               input 7998,
                               input "").
            assign c-return = return-value .        
            get first {&query-name} no-lock.      
            leave.
        end.
    end.
end.

procedure findNextLocaliz:
    
    /*
      Procedure com o objetivo de encontrar o pr¢ximo registro da 
      tabela Localizacao desde que seja o primeiro registro da tabela 
      com determinado c¢digo (cod-localiz).
      Parametros:
      ipar1 : r-rowid  : rowid corrente da tabela localizacao
      opar2 : c-return : retorna informa‡Æo - éltimo Registro da Tabela 
    */

    def input  parameter r-rowid  as rowid no-undo.
    def output parameter c-return as char  no-undo.
    
    def var c-cod-anterior as char no-undo.

    find first localizacao where
         rowid(localizacao) = r-rowid no-lock no-error.
 
    if  avail localizacao then 
         assign c-cod-anterior = localizacao.cod-localiz. 
  
    repeat while avail localizacao:
        get next {&query-name} no-lock.
        if  avail localizacao then do:
            if  localizacao.cod-localiz = c-cod-anterior then
                next.
            else do:
                run setCurrent.
                leave.
            end.
        end.
        else do:
            run utp/ut-msgs.p (input "msg",
                               input 7999,
                               input "").
            assign c-return = return-value .       
            get last {&query-name} no-lock.      
            leave.
        end.
    end.
end.


