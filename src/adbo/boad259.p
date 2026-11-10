/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD259 2.00.00.014}  /*** 010014 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOAD259 MUT}
&ENDIF


/*
**  BOAD259.P
**
**  tipo-rec-desp - Tipos de Receita/Despesa
**
**  Ultima altera‡Æo : 02/04/99 - GeraBO
*/

&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY tipo-rec-desp
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME tipo-rec-desp

{include/boini.i}
{include/i_dbtype.i} 
 
{adbo/boad259.i RowObject}

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

procedure setConstraint1:

end procedure.
def var i-rec-desp as int no-undo.

procedure setConstraint2:
  def input parameter p-rec-desp as int no-undo.
  assign i-rec-desp = p-rec-desp. 
end procedure.

procedure setConstraint3:
  def input parameter p-rec-desp as int no-undo.
  assign i-rec-desp = p-rec-desp. 
end procedure.

def var i-tp-codigo-ini as int  no-undo.
def var i-tp-codigo-fin as int  no-undo.
def var c-descricao-ini as char no-undo.
def var c-descricao-fin as char no-undo.
def var i-ordena        as int  no-undo.

procedure setConstraint4:
   def input param p-tp-codigo-ini as integer no-undo.
   def input param p-tp-codigo-fin as integer no-undo.
   def input param p-descricao-ini as char    no-undo.
   def input param p-descricao-fin as char    no-undo.
   def input param p-ordena        as integer no-undo.

   assign i-tp-codigo-ini = p-tp-codigo-ini
          i-tp-codigo-fin = p-tp-codigo-fin
          c-descricao-ini = p-descricao-ini
          c-descricao-fin = p-descricao-fin
          i-ordena        = p-ordena.
end procedure.

procedure setConstraint5:
   def input param p-tp-codigo-ini as integer no-undo.
   def input param p-tp-codigo-fin as integer no-undo.
   def input param p-descricao-ini as char    no-undo.
   def input param p-descricao-fin as char    no-undo.
   def input param p-ordena        as integer no-undo.

   assign i-tp-codigo-ini = p-tp-codigo-ini
          i-tp-codigo-fin = p-tp-codigo-fin
          c-descricao-ini = p-descricao-ini
          c-descricao-fin = p-descricao-fin
          i-ordena        = p-ordena.
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} NO-LOCK &if "{&ems_dbtype}" = "progress" &THEN 
                                                                         INDEXED-REPOSITION 
                                                                    &ENDIF.

        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock  
                        where tipo-rec-desp.tp-codigo >= i-rec-desp &if "{&ems_dbtype}" = "progress" &THEN 
                                                                          INDEXED-REPOSITION 
                                                                    &ENDIF.

        when 3 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                        where tipo-rec-desp.tp-codigo >= i-rec-desp and
                              tipo-rec-desp.tipo = 2 &if "{&ems_dbtype}" = "progress" &THEN 
                                                          INDEXED-REPOSITION 
                                                     &ENDIF.

        when 4 then do:
            if i-ordena = 1 then do : 
               if i-tp-codigo-ini = i-tp-codigo-fin then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                                where {&TABLE-NAME}.tp-codigo      = i-tp-codigo-ini AND
                                      {&TABLE-NAME}.descricao     >= c-descricao-ini AND
                                      {&TABLE-NAME}.descricao     <= c-descricao-fin      
                                      by {&TABLE-NAME}.tp-codigo &if "{&ems_dbtype}" = "progress" &THEN 
                                                                    INDEXED-REPOSITION 
                                                                 &ENDIF.  
               ELSE 

                    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                                where {&TABLE-NAME}.tp-codigo  >= i-tp-codigo-ini    AND 
                                      {&TABLE-NAME}.tp-codigo  <= i-tp-codigo-fin    AND
                                      {&TABLE-NAME}.descricao     >= c-descricao-ini AND
                                      {&TABLE-NAME}.descricao     <= c-descricao-fin      
                                      by {&TABLE-NAME}.tp-codigo &if "{&ems_dbtype}" = "progress" &THEN 
                                                                    INDEXED-REPOSITION 
                                                                 &ENDIF.
            end.
            if i-ordena = 2 then do :
               if i-tp-codigo-ini = i-tp-codigo-fin then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                                where {&TABLE-NAME}.tp-codigo      = i-tp-codigo-ini AND
                                      {&TABLE-NAME}.descricao     >= c-descricao-ini AND
                                      {&TABLE-NAME}.descricao     <= c-descricao-fin      
                                      by {&TABLE-NAME}.descricao &if "{&ems_dbtype}" = "progress" &THEN 
                                                                    INDEXED-REPOSITION 
                                                                 &ENDIF.
               else
                    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                                where {&TABLE-NAME}.tp-codigo  >= i-tp-codigo-ini    AND 
                                      {&TABLE-NAME}.tp-codigo  <= i-tp-codigo-fin    AND
                                      {&TABLE-NAME}.descricao     >= c-descricao-ini AND
                                      {&TABLE-NAME}.descricao     <= c-descricao-fin      
                                      by {&TABLE-NAME}.descricao &if "{&ems_dbtype}" = "progress" &THEN 
                                                                    INDEXED-REPOSITION 
                                                                 &ENDIF.
            end.
	 end.	
        when 5 then do:
            if i-ordena = 1 then do : 
               if  i-tp-codigo-ini = i-tp-codigo-fin then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                                where {&TABLE-NAME}.tp-codigo   = i-tp-codigo-ini AND
                                      {&TABLE-NAME}.descricao  >= c-descricao-ini AND
                                      {&TABLE-NAME}.descricao  <= c-descricao-fin and
     				                   tipo-rec-desp.tipo = 2
                                       by {&TABLE-NAME}.tp-codigo &if "{&ems_dbtype}" = "progress" &THEN 
                                                                    INDEXED-REPOSITION 
                                                                 &ENDIF.
               else                      
                    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                                where {&TABLE-NAME}.tp-codigo  >= i-tp-codigo-ini AND 
                                      {&TABLE-NAME}.tp-codigo  <= i-tp-codigo-fin AND
                                      {&TABLE-NAME}.descricao  >= c-descricao-ini AND
                                      {&TABLE-NAME}.descricao  <= c-descricao-fin and
     				                   tipo-rec-desp.tipo = 2
                                       by {&TABLE-NAME}.tp-codigo &if "{&ems_dbtype}" = "progress" &THEN 
                                                                    INDEXED-REPOSITION 
                                                                  &ENDIF.
            end.
            if i-ordena = 2 then do :
               if  i-tp-codigo-ini = i-tp-codigo-fin then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                                where {&TABLE-NAME}.tp-codigo   = i-tp-codigo-ini AND 
                                      {&TABLE-NAME}.descricao  >= c-descricao-ini AND
                                      {&TABLE-NAME}.descricao  <= c-descricao-fin and
     				                   tipo-rec-desp.tipo = 2
                                       by {&TABLE-NAME}.descricao &if "{&ems_dbtype}" = "progress" &THEN 
                                                                     INDEXED-REPOSITION 
                                                                  &ENDIF.
               else               
                    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                                where {&TABLE-NAME}.tp-codigo  >= i-tp-codigo-ini AND 
                                      {&TABLE-NAME}.tp-codigo  <= i-tp-codigo-fin AND
                                      {&TABLE-NAME}.descricao  >= c-descricao-ini AND
                                      {&TABLE-NAME}.descricao  <= c-descricao-fin and
     				                   tipo-rec-desp.tipo = 2
                                       by {&TABLE-NAME}.descricao &if "{&ems_dbtype}" = "progress" &THEN 
                                                                    INDEXED-REPOSITION 
                                                                 &ENDIF.
            end.
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

procedure findCodigo:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter i-tp-codigo as inte no-undo.
    def output parameter c-return as char no-undo.

    find tipo-rec-desp where
        tipo-rec-desp.tp-codigo = i-tp-codigo
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i mgadm {&TABLE-NAME} 1}
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

    if rowObject.tipo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.tp-codigo = ? then do:
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
    if rowObject.descricao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} descricao 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.tipo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} tipo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.

    if rowObject.tp-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} tp-codigo 1}
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
        find tipo-rec-desp where
            tipo-rec-desp.tp-codigo = rowObject.tp-codigo
            no-lock no-error.
        if avail tipo-rec-desp then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgadm {&TABLE-NAME} 1}
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
        when "cod-retencao" then c-value = RowObject.cod-retencao.
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "nr-tab-progr-fis" then c-value = RowObject.nr-tab-progr-fis.
        when "nr-tab-progr-jur" then c-value = RowObject.nr-tab-progr-jur.
        when "tipo" then c-value = RowObject.tipo.
        when "tp-codigo" then c-value = RowObject.tp-codigo.
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
        when "operacional" then c-value = RowObject.operacional.
        otherwise return error.
    end case.
end procedure.

procedure pi-valida-existe:
    def input  param p-codigo like tipo-rec-desp.tp-codigo.
    def output param p-tipo   like tipo-rec-desp.tipo.

    find tipo-rec-desp where tipo-rec-desp.tp-codigo = p-codigo no-lock no-error.
    if avail tipo-rec-desp then do:
        assign p-tipo = tipo-rec-desp.tipo.
        return "OK":U.
    end.
    else do:
        assign p-tipo = 0.
        return "NOK":U.
    end.
end procedure.
