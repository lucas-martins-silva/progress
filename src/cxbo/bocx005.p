/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX005 2.00.00.009}  /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX005 MUT}
&ENDIF

/*
**  BOCX005.P
**
**  decl-cliente - Cadastro de Declara‡äes por Cliente
**
**  Ultima altera‡Æo : 04/05/99 - GeraBO - Brv9587
*/

{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
   &GLOBAL-DEFINE v9indrep  INDEXED-REPOSITION
&endif

def var i-de-codigo    as integer                 no-undo. 
def var c-idioma       as char                    no-undo.
def var i-cod-emitente like emitente.cod-emitente no-undo.
def var i-cod-emitentei like emitente.cod-emitente no-undo.
def var i-cod-emitentef like emitente.cod-emitente no-undo.

def var c-pais             as char    no-undo.
def var i-de-codigoi       as integer no-undo. 
def var c-idiomai          as char    no-undo.
def var i-de-codigof       as integer no-undo. 
def var c-idiomaf          as char    no-undo.

def var i-de-codigo-ini    as int     no-undo.
def var i-de-codigo-fim    as int     no-undo.
def var i-cod-emitente-ini as int     no-undo.
def var i-cod-emitente-fim as int     no-undo.
def var c-idioma-ini       as char    no-undo.
def var c-idioma-fim       as char    no-undo.
def var h-bocx010          as handle  no-undo.
def var h-boad098          as handle  no-undo.

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY decl-cliente
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME decl-cliente
 
 
 
{include/boini.i}
 
{cxbo/bocx005.i RowObject}
  
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

DEFINE VAR i-moeda-p as integer no-undo.
 
procedure setConstraint1:
    
end procedure.

procedure setConstraint2:
    def input parameter p-cod     as char no-undo.
    def input parameter p-cliente as char no-undo.
    def input parameter p-idioma  as char no-undo.
 
    assign i-de-codigo    = int(p-cod)
           c-idioma       = p-idioma
           i-cod-emitente = int(p-cliente).
end procedure.

procedure setConstraint3:
    def input parameter p-cod     as char no-undo.
    def input parameter p-cliente as char no-undo.
    def input parameter p-idioma  as char no-undo.
 
    assign i-de-codigo    = int(p-cod)
           c-idioma       = p-idioma
           i-cod-emitente = int(p-cliente).
end procedure.

procedure setConstraint4:
    def input parameter p-codi     as char no-undo.
    def input parameter p-codf     as char no-undo.
 
    assign i-de-codigoi    = int(p-codi)
           i-de-codigof    = int(p-codf).
end procedure.

procedure setConstraint5:
    def input parameter p-clientei as char no-undo.
    def input parameter p-clientef as char no-undo.
 
    assign i-cod-emitentei = int(p-clientei)
           i-cod-emitentef = int(p-clientef).
end procedure.

procedure setConstraint6:
    def input parameter p-idiomai  as char no-undo.
    def input parameter p-idiomaf  as char no-undo.    
 
    assign c-idiomai       = p-idiomai
           c-idiomaf       = p-idiomaf.
end procedure.

procedure setConstraint7:
    def input parameter p-de-ini      as int  no-undo.
    def input parameter p-de-fim      as int  no-undo.    
    def input parameter p-cliente-ini as int  no-undo.
    def input parameter p-cliente-fim as int  no-undo.    
    def input parameter p-idioma-ini  as char no-undo.
    def input parameter p-idioma-fim  as char no-undo.    
     
    assign i-de-codigo-ini    = p-de-ini
           i-de-codigo-fim    = p-de-fim
           i-cod-emitente-ini = p-cliente-ini
           i-cod-emitente-fim = p-cliente-fim
           c-idioma-ini       = p-idioma-ini
           c-idioma-fim       = p-idioma-fim.
end procedure.


procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} NO-LOCK
                                              {&v9indrep}.
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where
                                              {&TABLE-NAME}.de-codigo >= i-de-codigo and
                                              {&TABLE-NAME}.cod-emitente >= i-cod-emitente and
                                              {&TABLE-NAME}.cod-idioma >= c-idioma
                                              no-lock
                                              {&v9indrep}.
        when 3 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where
                                              {&TABLE-NAME}.de-codigo >= i-de-codigo and
                                              {&TABLE-NAME}.cod-emitente = i-cod-emitente and
                                              {&TABLE-NAME}.cod-idioma >= c-idioma
                                              no-lock
                                              {&v9indrep}.
        when 4 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where
                                              {&TABLE-NAME}.de-codigo >= i-de-codigoi and
                                              {&TABLE-NAME}.de-codigo <= i-de-codigof
                                              no-lock
                                              /*{&v9indrep}*/.
        when 5 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where
                                              {&TABLE-NAME}.cod-emitente >= i-cod-emitentei and
                                              {&TABLE-NAME}.cod-emitente <= i-cod-emitentef
                                              no-lock
                                              /*{&v9indrep}*/.
         when 6 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                               {&TABLE-NAME}.cod-idioma >= c-idiomai and
                                               {&TABLE-NAME}.cod-idioma <= c-idiomaf
                                               no-lock
                                               /*{&v9indrep}*/.
        when 7 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where
                                              &IF '{&ems_dbtype}' <> 'PROGRESS' &THEN
                                              ({&TABLE-NAME}.de-codigo        > i-de-codigo-ini     or {&TABLE-NAME}.de-codigo          = i-de-codigo-ini)     and
                                              ({&TABLE-NAME}.de-codigo        < i-de-codigo-fim     or {&TABLE-NAME}.de-codigo          = i-de-codigo-fim)     and
                                              ({&TABLE-NAME}.cod-emitente     > i-cod-emitente-ini  OR {&TABLE-NAME}.cod-emitente       = i-cod-emitente-ini)  and
                                              ({&TABLE-NAME}.cod-emitente     < i-cod-emitente-fim  OR {&TABLE-NAME}.cod-emitente       = i-cod-emitente-fim)  AND
                                              (trim({&TABLE-NAME}.cod-idioma) > c-idioma-ini        or trim({&TABLE-NAME}.cod-idioma)   = c-idioma-ini)        and
                                              (trim({&TABLE-NAME}.cod-idioma) < c-idioma-fim        or trim({&TABLE-NAME}.cod-idioma)   = c-idioma-fim)
                                              &Else
                                              {&TABLE-NAME}.de-codigo        >= i-de-codigo-ini    and
                                              {&TABLE-NAME}.de-codigo        <= i-de-codigo-fim    and
                                              {&TABLE-NAME}.cod-emitente     >= i-cod-emitente-ini and
                                              {&TABLE-NAME}.cod-emitente     <= i-cod-emitente-fim AND
                                              trim({&TABLE-NAME}.cod-idioma) >= c-idioma-ini       and
                                              trim({&TABLE-NAME}.cod-idioma) <= c-idioma-fim
                                              &endif
                                              no-lock {&v9indrep}.
    end case.
    assign l-query    = true
           i-bo-query = i-abertura.
end procedure.
 
{include/bostrmet.i}
{include/boendmet.i}
{include/bocomver.i}
{include/bogetver.i}
/*{include/bonav.i}*/
{include/bofind.i}
{include/bosetcur.i}
{include/bogetcur.i}
{include/bosersen.i}
{include/boprebro.i}
{include/boexecre.i}
/*{include/boexeupt.i}*/
{include/boexedel.i}
/*{include/bovalupt.i}*/
{include/bovaldel.i}
 
procedure executeUpdate:
    /*
    **  Executa Update
    */
    buffer-copy RowObject except r-rowid cod-emitente de-codigo cod-idioma to {&TABLE-NAME}.

end procedure.


procedure initializeValidate:
    /*
    **  Inicializa Validate
    */

    run startMethod ("initializeValidade").

    run endMethod   ("initializeValidade").
end procedure.

procedure findFirst:
    if l-query then
        get first {&QUERY-NAME}
            no-lock no-wait.
    else
        find first {&TABLE-NAME} no-lock no-error.
    run setCurrent.
end procedure.


procedure findPrev:
    def output parameter c-return as char.
    if l-query then
        get prev {&QUERY-NAME} no-lock no-wait.
    else
        find prev {&TABLE-NAME} no-lock no-error.

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
        get next {&QUERY-NAME} no-lock no-wait.
    else
        find next {&TABLE-NAME} no-lock no-error.
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
        find last {&TABLE-NAME} no-lock no-error.
    run setCurrent.
end procedure.

procedure getRowid:
    def output parameter r-chave as rowid no-undo.
    if avail {&TABLE-NAME} then do:
        assign r-chave = rowid({&TABLE-NAME}).
    end.
    else do:
       assign r-chave = ?.
    end.
end procedure.

procedure findCodigo:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter i-de-codigo    as integer no-undo.
    def input parameter i-cod-emitente as integer no-undo.
    def input parameter c-cod-idioma   as char    no-undo.
    def output parameter c-return      as char    no-undo.
    
    run startMethod ("find").
 
    find decl-cliente where        
         decl-cliente.de-codigo    = i-de-codigo and
         decl-cliente.cod-emitente = i-cod-emitente and
         trim(decl-cliente.cod-idioma)   = c-cod-idioma  no-lock no-error.
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

procedure findCh_cod_emitente:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter i-cod-emitente as integer no-undo.
    def input parameter i-de-codigo    as integer no-undo.
    def input parameter c-cod-idioma   as char    no-undo.
    def output parameter table for RowObject.
    
    run startMethod ("find").
 
    for first decl-cliente no-lock where
              decl-cliente.cod-emitente = i-cod-emitente and
              decl-cliente.de-codigo    = i-de-codigo    and
              trim(decl-cliente.cod-idioma) = c-cod-idioma:
    end.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i mgcex {&TABLE-NAME} 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
    end.
    else do:
       run setCurrent.
    end.
    run endMethod ("find").
end procedure.
 
procedure findCh_cod_idioma:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter c-cod-idioma   as char    no-undo.
    def input parameter i-cod-emitente as integer no-undo.
    def output parameter table for RowObject.
    
    run startMethod ("find").
 
    find decl-cliente where
         decl-cliente.cod-idioma   = c-cod-idioma   and  
         decl-cliente.cod-emitente = i-cod-emitente 
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
   
    find first rowobject no-lock no-error.
    run validateFields.
    
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


procedure findCh_decl_emitente:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter i-de-codigo    like decl-cliente.de-codigo.
    def input parameter i-cod-emitente as integer no-undo.
    def input parameter c-cod-idioma   as char no-undo.
    def output parameter table for RowObject.
 
    find first decl-cliente 
         where decl-cliente.de-codigo    = i-de-codigo     
           and decl-cliente.cod-emitente = i-cod-emitente  
           and decl-cliente.cod-idioma   = c-cod-idioma
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

procedure findPk_codigo:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter i-cod-emitente as integer no-undo.
    def input parameter i-de-codigo    like decl-cliente.de-codigo.
    def input parameter c-cod-idioma   as char no-undo.
    def output parameter table for RowObject.

    run startMethod ("find").

    find decl-cliente where
         decl-cliente.cod-emitente = i-cod-emitente  and
         decl-cliente.de-codigo    = i-de-codigo     and
         decl-cliente.cod-idioma   = c-cod-idioma
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
    run endMethod ("find").

end procedure.


procedure validateFields:
    /*
    **  Valida Fields
    */
    run startMethod ("validateFields").

    if rowObject.texto = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} texto 1}
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

    run startMethod ("validateCreate").

    def input  parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.

    run initializeValidate.

    for each tt-bo-erro:
        delete tt-bo-erro.
    end.

    find first rowObject no-lock no-error.
    run validateFields.
 
    if rowObject.cod-emitente = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} cod-emitente 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
    else do:
       if  rowobject.cod-emitente <> 0 then do:
            if not can-find(emitente where emitente.cod-emitente = rowObject.cod-emitente) then do:
               assign i-seq-erro = i-seq-erro + 1.
               {utp/ut-table.i mgadm emitente 1}
               run utp/ut-msgs.p (input "msg",
                                  input 2,
                                  input return-value).
     
                    create tt-bo-erro.
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 2
                           tt-bo-erro.mensagem     = return-value.
     
            end.
       end.
    end.   
    
    if rowObject.de-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} de-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
    else do:
       if not can-find(decl-padrao where decl-padrao.de-codigo = rowObject.de-codigo) then do:
          assign i-seq-erro = i-seq-erro + 1.
          {utp/ut-table.i mgcex decl-padrao 1}
          run utp/ut-msgs.p (input "msg",
                             input 2,
                             input return-value).

               create tt-bo-erro.
               assign tt-bo-erro.i-sequen     = i-seq-erro
                      tt-bo-erro.cd-erro      = 2
                      tt-bo-erro.mensagem     = return-value.
       end.
    end.   
 
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
    else do:
        &if defined(bf-mat-comex) &then                                
            if not can-find(idioma where idioma.id-codigo = rowObject.cod-idioma) then do:
               assign i-seq-erro = i-seq-erro + 1.
               run utp/ut-msgs.p (input "msg",
                                  input 4774,
                                  input " ").
               create tt-bo-erro.
               assign tt-bo-erro.i-sequen = i-seq-erro
                      tt-bo-erro.cd-erro  = 4774
                      tt-bo-erro.mensagem = return-value.
            end.          
        &else
            if not can-find(idioma where idioma.cod_idioma = rowObject.cod-idioma) then do:
                assign i-seq-erro = i-seq-erro + 1.
                run utp/ut-msgs.p (input "msg",
                                   input 4774,
                                   input " ").
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 4774
                       tt-bo-erro.mensagem = return-value.
            end.          
        &endif    
    end.                                   

    find decl-cliente no-lock 
         where decl-cliente.cod-emitente = rowObject.cod-emitente 
           and decl-cliente.de-codigo    = rowObject.de-codigo    
           and decl-cliente.cod-idioma   = rowObject.cod-idioma no-error.
    if avail decl-cliente then do:
       assign i-seq-erro = i-seq-erro + 1.
       {utp/ut-table.i mgcex decl-cliente 1}
       run utp/ut-msgs.p (input "msg",
                          input 8,
                          input return-value).
       create tt-bo-erro.
       assign tt-bo-erro.i-sequen     = i-seq-erro
              tt-bo-erro.cd-erro      = 8
              tt-bo-erro.mensagem     = return-value.
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
        when "texto" then c-value = RowObject.texto.
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
        when "cod-emitente" then c-value = RowObject.cod-emitente.
        when "de-codigo" then c-value = RowObject.de-codigo.
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
 
PROCEDURE fn-declaracao:

   def input  parameter p-rowid     as rowid.
   def output parameter c-descricao as char.
   
    
   run cxbo/bocx010.p persistent set h-bocx010.
   
   run findPk_de_codigo in h-bocx010(input {&TABLE-NAME}.de-codigo,output c-return).
   if c-return = "" then do:
     run getCharField in h-bocx010 ("descricao", output c-descricao).
   end.
   delete procedure h-bocx010.
   return (c-descricao).
END procedure.

PROCEDURE fn-emitente:

   def input  parameter p-rowid as rowid.
   def output parameter c-nome-abrev   as char.

   run adbo/boad098.p persistent set h-boad098.

   run findCodigo in h-boad098(input {&TABLE-NAME}.cod-emitente,output c-return).  
   if c-return = "" then do:
     run getCharField in h-boad098 ("nome-abrev", output c-nome-abrev).
   end.
  delete procedure h-boad098.
  return (c-nome-abrev).
END procedure.
