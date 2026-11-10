/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX050 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX050 MUT}
&ENDIF

/*
**  BOCX050.P
**
**  trad-embalag - Cadastro de Tradu‡äes de Embalagens
**
**  Ultima altera‡Æo : 05/05/99 - GeraBO - Brv9587
*/

def var c-embalagem as char no-undo. 
def var c-idioma    as char no-undo.
def var c-embalagem-ini as char no-undo. 
def var c-embalagem-fin as char no-undo. 
 
&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY trad-embalag
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME trad-embalag
 
{cdp/cdcfgdis.i} 
 
{include/boini.i}
 
{cxbo/bocx050.i RowObject}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
 
procedure setConstraint1:
 
 
end procedure.

procedure setConstraint2:
def input parameter p-embalagem as char no-undo.
def input parameter p-idioma as char no-undo.

assign c-embalagem = p-embalagem
       c-idioma    = p-idioma. 
end procedure. 

procedure setConstraint3:
def input parameter p-embalagem-ini as char no-undo.
def input parameter p-embalagem-fin as char no-undo.

assign c-embalagem-ini = p-embalagem-ini
       c-embalagem-fin = p-embalagem-fin. 
end procedure. 

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where {&TABLE-NAME}.embalagem >= c-embalagem and ~
                                                                  {&TABLE-NAME}.cod-idioma >= c-idioma no-lock by trad-embalag.embalagem.
        when 3 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where {&TABLE-NAME}.embalagem >= c-embalagem-ini and ~
                                                                  {&TABLE-NAME}.embalagem <= c-embalagem-fin no-lock by trad-embalag.embalagem.

    end case.
    assign l-query    = true
           i-bo-query = i-abertura.
end procedure.
 
{include/bostrmet.i}
{include/boendmet.i}
&if defined(bf-dis-comex) &then
&else    
    {include/bocomver.i}
    {include/bogetver.i}
&endif
{include/bonav.i}
{include/bofind.i}
{include/bosetcur.i}
{include/bogetcur.i}
{include/bosersen.i}
{include/boprebro.i}
{include/boexecre.i}
/*{include/boexeupt.i}*/
{include/boexedel.i}
{include/bovalupt.i}
{include/bovaldel.i}

procedure executeUpdate:
    /*
    **  Executa Update
    */
    buffer-copy RowObject except r-rowid cod-idioma embalagem to {&TABLE-NAME}.
end procedure.
 
procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
 
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.

procedure findCh_tr_embalag:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    
    def input parameter c-cod-idioma as char no-undo.
    def input parameter c-embalagem as char no-undo.
    def output parameter table for RowObject.
 
    find trad-embalag where
        trad-embalag.cod-idioma = c-cod-idioma
        and trad-embalag.embalagem = c-embalagem
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
    run endMethod("find").
end procedure.
 
procedure findPk_tr_embalag:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter c-embalagem as char no-undo.
    def input parameter c-cod-idioma as char no-undo.
    def output parameter c-return as char no-undo.
 
    find trad-embalag where
        trad-embalag.embalagem = c-embalagem
        and trad-embalag.cod-idioma = c-cod-idioma
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
    if rowObject.cod-idioma = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
     if rowObject.tr-embalagem = ? or rowObject.tr-embalagem = "" then do:
        assign i-seq-erro = i-seq-erro + 1.

        {utp/ut-field.i mgcex {&TABLE-NAME} tr-embalagem 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
  
    
    if rowObject.tr-sigla-emb = ? or rowObject.tr-sigla-emb = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} tr-sigla-emb 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tr-descricao = ? or rowObject.tr-descricao = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Descri‡Æo_Traduzida * R}
        
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
 
    find first rowObject
        no-lock no-error.
    if rowObject.cod-idioma = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-idioma 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
    &if defined(bf-dis-comex) &then
        else if not can-find(idioma where idioma.id-codigo = rowObject.cod-idioma) then do:
    &else
        else if not can-find(idioma where idioma.cod_idioma = rowObject.cod-idioma) then do:
    &endif    
          assign i-seq-erro = i-seq-erro + 1.
          {utp/ut-table.i mguni idioma 1}
          run utp/ut-msgs.p (input "msg",
                             input 2,
                             input return-value).
          create tt-bo-erro.
          assign tt-bo-erro.i-sequen     = i-seq-erro
                 tt-bo-erro.cd-erro      = 2
                 tt-bo-erro.mensagem     = return-value.          
         end.

    if rowObject.embalagem = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} embalagem 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
    else if not can-find(embalag where embalag.embalagem = rowObject.embalagem) then do:
          assign i-seq-erro = i-seq-erro + 1.
          {utp/ut-table.i mgdis embalag 1}
          run utp/ut-msgs.p (input "msg",
                             input 2,
                             input return-value).
          create tt-bo-erro.
          assign tt-bo-erro.i-sequen     = i-seq-erro
                 tt-bo-erro.cd-erro      = 2
                 tt-bo-erro.mensagem     = return-value.    
         end.        
 
    if rowObject.tr-descricao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} tr-descricao 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tr-embalagem = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} tr-embalagem 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tr-sigla-emb = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} tr-sigla-emb 1}
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
        find trad-embalag where
            trad-embalag.embalagem = rowObject.embalagem
        and trad-embalag.cod-idioma = rowObject.cod-idioma
            no-lock no-error.
        if avail trad-embalag then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i mgcex {&TABLE-NAME} 1}
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
      find trad-embalag where
           trad-embalag.cod-idioma = rowObject.cod-idioma
           and trad-embalag.embalagem = rowObject.embalagem
           no-lock no-error.
      if avail trad-embalag then do:
         assign i-seq-erro = i-seq-erro + 1.
         {utp/ut-table.i mgcex {&TABLE-NAME} 1}
         run utp/ut-msgs.p (input "msg",
                            input 8,
                            input return-value).
         create tt-bo-erro.
         assign tt-bo-erro.i-sequen     = i-seq-erro
                tt-bo-erro.cd-erro      = 8
                tt-bo-erro.mensagem     = return-value.
      end.
    end.   

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
        when "cod-idioma" then c-value = RowObject.cod-idioma.
        when "embalagem" then c-value = RowObject.embalagem.
        when "tr-descricao" then c-value = RowObject.tr-descricao.
        when "tr-embalagem" then c-value = RowObject.tr-embalagem.
        when "tr-sigla-emb" then c-value = RowObject.tr-sigla-emb.
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
 
