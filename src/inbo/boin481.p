/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN481 2.00.00.014 } /*** "010014" 07/07/2026 15:34:59 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin481 MUT}
&ENDIF

/*
**  BOIN481.P
**
**  proces-item - 
**
**  Ultima altera‡Æo : 24/06/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY proces-item
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME proces-item

{cdp/cdcfgman.i}
  
{include/boini.i}

{inbo/boin481.i RowObject}
{inbo/boin481.i tt-proces-item}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
                                      
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
    def input parameter c-it-codigo as char no-undo.
    def input parameter i-sequencia as inte no-undo.
    def output parameter c-return as char no-undo.
 
    find proces-item where
        proces-item.it-codigo = c-it-codigo
        and proces-item.sequencia = i-sequencia
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
    if rowObject.cod-lista-compon = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} cod-lista-compon 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-roteiro = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} cod-roteiro 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.data-inicio = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} data-inicio 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.data-termino = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} data-termino 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.des-regra-proces = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgind {&TABLE-NAME} des-regra-proces 1}
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
        {utp/ut-field.i mgind {&TABLE-NAME} it-codigo 1}
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
    def output parameter r-chave as rowid.
 
    run initializeValidate.
    run startMethod ("validateCreate").
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
 
    run validateFields.
 
    find first tt-bo-erro
        no-lock no-error.
    if not available tt-bo-erro then do:
        find proces-item where
            proces-item.it-codigo = rowObject.it-codigo
        and proces-item.sequencia = rowObject.sequencia
            no-lock no-error.
        if avail proces-item then do:
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
        else do:
             run executeCreate.
             assign r-chave = to-rowid(return-value).
        end.
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
        when "cod-estabel" then c-value = RowObject.cod-estabel.
        when "cod-lista-compon" then c-value = RowObject.cod-lista-compon.
        when "cod-roteiro" then c-value = RowObject.cod-roteiro.
        when "des-regra-proces" then c-value = RowObject.des-regra-proces.
        when "it-codigo" then c-value = RowObject.it-codigo.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "proporcao" then c-value = RowObject.proporcao.
        when "qtd-max-item" then c-value = RowObject.qtd-max-item.
        when "qtd-min-item" then c-value = RowObject.qtd-min-item.
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "nr-linha" then c-value = RowObject.nr-linha.
        when "sequencia" then c-value = RowObject.sequencia.
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "data-1" then c-value = RowObject.data-1.
        when "data-2" then c-value = RowObject.data-2.
        when "data-inicio" then c-value = RowObject.data-inicio.
        when "data-termino" then c-value = RowObject.data-termino.
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

/********************************************************************************
*** Procedure AtualizarProcesItem
*** Atualiza‡Æo do processo do Item atualiza propor‡äes de listas e roteiros
    associados ao item 
*** Altera‡Æo de propor‡äes altera propor‡äes de uso de listas de componentes
    altera‡Æo de listas de componentes alteram propor‡äes de estrutura do item   
**  Parƒmetros de entrada
    buffer do registro que ser  alterado (b-old)
    temporƒria com a nova altera‡Æo      
********************************************************************************/
PROCEDURE AtualizarProcesItem:

    DEFINE PARAMETER BUFFER b-old-proces-item FOR proces-item.
    DEFINE PARAMETER BUFFER tt-proces-item    FOR tt-proces-item.
    
    on write of rot-item override do: end.

    if tt-proces-item.proporcao <> b-old-proces-item.proporcao then do:
        if tt-proces-item.cod-lista-compon <> "" then do:
            find lista-compon-item where
                 lista-compon-item.cod-lista-compon = tt-proces-item.cod-lista-compon and 
                 lista-compon-item.it-codigo        = tt-proces-item.it-codigo EXCLUSIVE-LOCK NO-ERROR.

            assign lista-compon-item.proporcao = max(0, lista-compon-item.proporcao + tt-proces-item.proporcao - b-old-proces-item.proporcao).
                                                 
                                                 
            for each estrutura EXCLUSIVE-LOCK where
                     estrutura.it-codigo        = lista-compon-item.it-codigo and
                     estrutura.cod-lista-compon = lista-compon-item.cod-lista-compon:
                assign estrutura.prop-proc = lista-compon-item.proporcao.   
            end.        
        end.
        if tt-proces-item.cod-roteiro <> "" then do:
            find first rot-item where
                       rot-item.it-codigo   = tt-proces-item.it-codigo and
                       rot-item.cod-roteiro = tt-proces-item.cod-roteiro EXCLUSIVE-LOCK NO-ERROR. 

            if available rot-item then 
                  assign rot-item.proporcao = max(0, rot-item.proporcao + 
                                                     tt-proces-item.proporcao - b-old-proces-item.proporcao).
            
        end. 
    end.

    /*** Assign da regra de processo ***/
    assign tt-proces-item.des-regra-proces = ""
           tt-proces-item.char-1           = "".

    /*** Altera»„es feitas devido a problemas de formato de campo que os bancos SQL e Oracle 
     *** nao aceitam - favor nao modificar as alteracoes feitas para o campo tt-proces-item.des-regra-proces.
     *** Tambem foi utilizado o campo char-1 para gravar as demais informacoes ***/


    if tt-proces-item.data-inicio   <> ? and
       tt-proces-item.data-termino  <> ? then do:
       {utp/ut-field.i mgind proces-item data-inicio 01}
       assign tt-proces-item.des-regra-proces = return-value + ": " + string(tt-proces-item.data-inicio,"99/99/9999").
       {utp/ut-field.i mgind proces-item data-termino 01}
       assign tt-proces-item.des-regra-proces = tt-proces-item.des-regra-proces + ", " + return-value + ": " + string(tt-proces-item.data-termino,"99/99/9999").
    end.

    if tt-proces-item.qtd-max-item > tt-proces-item.qtd-min-item then do:
       /*{utp/ut-field.i mgind proces-item qtd-min-item 01}*/
       assign tt-proces-item.char-1 = tt-proces-item.char-1 + " - Qtd M¡n: " + string(tt-proces-item.qtd-min-item).
       /*{utp/ut-field.i mgind proces-item qtd-max-item 01}*/
       assign tt-proces-item.char-1 = tt-proces-item.char-1 + ", Qtd M x: " + string(tt-proces-item.qtd-max-item).
    end.
    
    if tt-proces-item.cod-estabel <> "" then do:
       {utp/ut-field.i mgind proces-item cod-estabel 01}
       assign tt-proces-item.char-1 = tt-proces-item.char-1 + " - " + return-value + ": " + tt-proces-item.cod-estabel.
    end.
    
    if tt-proces-item.nr-linha <> 0 then do:
       {utp/ut-field.i mgind proces-item nr-linha 01}
       assign tt-proces-item.char-1 = tt-proces-item.char-1 + " - " + return-value + ": " + string(tt-proces-item.nr-linha).
    end.        

    if tt-proces-item.cod-refer <> "" then do:
       {utp/ut-field.i mgind proces-item cod-refer 01}
       assign tt-proces-item.char-1 = tt-proces-item.char-1 + " - " + return-value + ": " + string(tt-proces-item.cod-refer).
    end.
  
    &IF DEFINED(bf_man_206b) &THEN
       if (can-find(funcao where funcao.cd-funcao = "EMS2-UNIDADE-NEGOCIO" and funcao.ativo = yes))
                             AND tt-proces-item.cod-unid-negoc <> "" then DO:
             {utp/ut-field.i mgind proces-item cod-unid-negoc 01}
             assign tt-proces-item.char-1 = tt-proces-item.char-1 + " - " + return-value + ": " + string(tt-proces-item.cod-unid-negoc).
       END.
    &ENDIF

END PROCEDURE.


/********************************************************************************
** Procedure AjustarProcesItem100 
** Ajusta os processos do item para 100% e Propor‡Æo de utiliza‡Æo de
** Listas de componentes e roteiros tamb‚m deverÆo ter alterada a propor‡Æo de
   utiliza‡Æo
** Listas de componentes alteram propor‡Æo de estrutura   
********************************************************************************/

PROCEDURE AjustarProcesItem100:
    
    def input parameter p-it-codigo as char format "x(16)".
    
    def var val-old-prop as decimal no-undo.
    def var val-tot      as decimal no-undo.
    def var num-proces   as integer no-undo.

    DEF BUFFER b-proces-item FOR proces-item.
    
    on write of rot-item override do: end.
    for each proces-item where
             proces-item.it-codigo = p-it-codigo no-lock:
       assign val-tot    = val-tot + proces-item.proporcao
              num-proces = num-proces + 1.
    end.

    for each proces-item EXCLUSIVE-LOCK  where
             proces-item.it-codigo = p-it-codigo:
    
       assign val-old-prop          = proces-item.proporcao
              proces-item.proporcao = if proces-item.proporcao /*val-tot*/ > 0 then proces-item.proporcao * 100 / val-tot 
                                      else 100 / num-proces.
                            

       if val-old-prop <> proces-item.proporcao then do:
          if proces-item.cod-roteiro <> "" then do:
              find first rot-item where
                         rot-item.it-codigo   = proces-item.it-codigo and
                         rot-item.cod-roteiro = proces-item.cod-roteiro EXCLUSIVE-LOCK .
              assign rot-item.proporcao = max(0, rot-item.proporcao + 
                                                 proces-item.proporcao - val-old-prop).           
          end.
          if proces-item.cod-lista-compon <> "" then do:
              find first lista-compon-item where
                         lista-compon-item.it-codigo        = proces-item.it-codigo and 
                         lista-compon-item.cod-lista-compon = proces-item.cod-lista-compon EXCLUSIVE-LOCK .
              assign lista-compon-item.proporcao = max(0, lista-compon-item.proporcao + 
                                                          proces-item.proporcao - val-old-prop).           
              for each estrutura EXCLUSIVE-LOCK where
                       estrutura.it-codigo        = lista-compon-item.it-codigo and
                       estrutura.cod-lista-compon = lista-compon-item.cod-lista-compon:
                  assign estrutura.prop-proc = lista-compon-item.proporcao.   
              end.        
          
          end.
       end.
    end.

END PROCEDURE.


{inbo/boin481.i1} /*** EliminarProcesItem ***/

/********************************************************************************
** Procedure EliminarTodosProcesItem 
** Elimina todos os processos do item sem impactar nas propor‡äes de listas e 
   roteiros
********************************************************************************/

PROCEDURE EliminarTodosProcesItem:
    
    
    def input parameter p-it-codigo as char format "x(16)".
    
    for each proces-item where
             proces-item.it-codigo = p-it-codigo exclusive-lock:
        delete proces-item.
    end.
    
    release proces-item.
   

END PROCEDURE.


