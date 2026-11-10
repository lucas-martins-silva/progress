/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX010 2.00.00.016}  /*** "010016" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX010 MUT}
&ENDIF
 
/*
**  BOCX010.P
**
**  decl-padrao - Cadastro de Declara‡äes PadrÆo
**
**  Ultima altera‡Æo : 04/05/99 - GeraBO - Brv9587
*/
 
&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY decl-padrao
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME decl-padrao
 
def var i-de-codigo      as integer no-undo.
def var c-idioma-inicial as char no-undo.
def var i-de-codigoi      as integer no-undo.
def var i-de-codigof      as integer no-undo. 
 
{include/boini.i} 
{cxbo/bocx010.i RowObject}
{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}
{cdp/cdcfgcex.i}
{utp/ut-glob.i}

/* defini‡Æo de vari veis e tt-var utilizadas para a conversÆo das vari veis do texto das declara‡äes*/
{cdp/cd2550.i3}
 
DEFINE TEMP-TABLE tt-variaveis no-undo
    field nome-variavel  as char format "x(30)"
    field descricao as char format "x(40)"
    field modulo as char 
    field cod-modulo as char
       index nome is primary unique 
          nome-variavel modulo.
          
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
 
procedure setConstraint1: 
end procedure.
 
procedure setConstraint2: 
    def input parameter p-de-codigo      as char no-undo.
   
    assign i-de-codigo = integer(p-de-codigo).
 
end procedure.

procedure setConstraint3:
    def input parameter p-de-codigoi     as char no-undo.
    def input parameter p-de-codigof     as char no-undo.
   
    assign i-de-codigoi= integer(p-de-codigoi).
    assign i-de-codigof= integer(p-de-codigof).
 
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.    
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where {&TABLE-NAME}.de-codigo >= i-de-codigo no-lock by decl-padrao.de-codigo.
        when 3 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where {&TABLE-NAME}.de-codigo >= i-de-codigoi and~
                                                                  {&TABLE-NAME}.de-codigo <= i-de-codigof no-lock by decl-padrao.de-codigo.
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
/*{include/boexeupt.i}*/
{include/boexedel.i}
{include/bovalupt.i}
/*{include/bovaldel.i}*/

procedure executeUpdate:
    /*
    **  Executa Update
    */
      
    buffer-copy RowObject except de-codigo r-rowid to {&TABLE-NAME}.

end procedure.

 
procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
 
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.
 
procedure findPk_de_codigo:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter i-de-codigo as inte no-undo.
    def output parameter c-return as char no-undo.
 
    find decl-padrao where
        decl-padrao.de-codigo = i-de-codigo
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
    
    find first rowObject no-lock no-error.
    
    if rowObject.descricao = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgcex {&TABLE-NAME} descricao 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
end procedure.
 
procedure validateCreate:
    /*
    **  Valida cria‡Æo da tabela/duplicidade de registro.
    */
    def input  parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.
 
    def var i-auto-num as integer no-undo.
 
    run initializeValidate.
    run startMethod ("validateCreate").
    
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
 
    find first rowObject no-lock no-error.
             
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
    
    run validateFields.
 
    find first tt-bo-erro no-lock no-error.
    if not available tt-bo-erro then do:
        find decl-padrao where
            decl-padrao.de-codigo = rowObject.de-codigo
            no-lock no-error.
        if avail decl-padrao then do:
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
    
    find first tt-bo-erro no-lock no-error. 
    if not avail tt-bo-erro then do:
       run executeCreate.
       assign r-chave = to-rowid(return-value).
    end.
 
    run endMethod ("validateCreate").
end procedure.

procedure autoNumber:
    def output parameter i-auto-num as integer no-undo.
    def var i-cont as integer init 1 no-undo. /** variável de contador **/
    def output parameter table for tt-bo-erro.

    {include/boautonum.i "99999" "de-codigo"}        
end procedure.

procedure validateCodigo:

    def input parameter c-cod-decl as char no-undo.
    def output parameter table for tt-bo-erro.
    def var i as integer no-undo.
    
    run startMethod("validateCodigo").    
    assign i = int(c-cod-decl) no-error.
    if  error-status:error then do:       
       assign i-seq-erro = i-seq-erro + 1
              c-cod-decl = "0".
       {utp/ut-field.i mgcex inst-negoc cod-inst 1}
       run utp/ut-msgs.p (input "msg",
                          input 16963,
                          input return-value).
       create tt-bo-erro.
       assign tt-bo-erro.i-sequen     = i-seq-erro
              tt-bo-erro.cd-erro      = 16963
              tt-bo-erro.mensagem     = return-value.
    end.
    run endMethod("validateCodigo").           
              
end procedure.
 

procedure validateDelete:
  def var c-decl-cli   as char.
  def var c-decl-pais  as char.
  def var c-declaracao as char.
  
    /*
    **  Valida Delete
    */
    def input-output parameter r-chave as rowid.
    def output parameter table for tt-bo-erro.
    
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
 
    run InitializeValidate.
 
    find {&TABLE-NAME} where
        rowid({&TABLE-NAME}) = r-chave
        exclusive-lock no-error.
        
    if avail {&TABLE-NAME} then do:
      
      find first decl-cliente no-lock where 
        decl-cliente.de-codigo = {&TABLE-NAME}.de-codigo no-error.
      if avail decl-cliente then do:
        assign i-seq-erro = i-seq-erro + 1.

        {utp/ut-table.i mgcex {&TABLE-NAME} 1}
        assign c-declaracao = return-value.
        
        {utp/ut-table.i mgcex decl-cliente 1}
        assign c-decl-cli   = return-value.
        
        run utp/ut-msgs.p (input "msg",
                           input 5,
                           input c-declaracao + "~~" + c-decl-cli).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 5
               tt-bo-erro.mensagem = return-value.
      end.

      find first decl-pais no-lock where 
        decl-pais.de-codigo = {&TABLE-NAME}.de-codigo no-error.
      if avail decl-pais then do:
        assign i-seq-erro = i-seq-erro + 1.

        {utp/ut-table.i mgcex {&TABLE-NAME} 1}
        assign c-declaracao = return-value.
        
        {utp/ut-table.i mgcex decl-pais 1}
        assign c-decl-pais  = return-value.
        
        run utp/ut-msgs.p (input "msg",
                           input 5,
                           input c-declaracao + "~~" + c-decl-pais).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 5
               tt-bo-erro.mensagem = return-value.
      end.

      if not can-find(first tt-bo-erro) then do:
        run executeDelete.
      end. /* if not can-find ... */
      
    end.
 
    if l-query then
        get next {&QUERY-NAME}
            no-lock no-wait.
    else
        find next {&TABLE-NAME}
            no-lock no-error.

    if not avail {&TABLE-NAME} then do:
       if l-query then
           get prev {&QUERY-NAME}
               no-lock no-wait.
       else
           find prev {&TABLE-NAME}
               no-lock no-error.
    end.
    assign r-chave = rowid({&TABLE-NAME}).
    return "".
end procedure.
 
PROCEDURE validaTexto:
/* Faz a valida‡Æo do campo descri‡Æo da declara‡Æo base, e texto da declara‡Æo para 
   nÆo permitir a inclusÆo de vari veis inv lidas nos cadastros de declara‡Æo base(cd2552)
   e cadastro de declaracÆo(cd2550).*/

DEFINE input  PARAMETER c-linha-desc like decl-cliente.texto. 
DEFINE output PARAMETER table FOR tt-bo-erro.

def var c-caracter as char no-undo.

for each tt-bo-erro:
  delete tt-bo-erro.
end.

for each tt-variaveis:
   delete tt-variaveis.
end.

{cdp/cd2550a.i} /* Cria‡Æo da tt-variaveis */

assign i-pos-f = 0
       c-modulo = " ".
assign /*c-linha-desc = tt-decl-cliente.texto:screen-value in frame fpage0*/
       i-pos-fim = r-index(c-linha-desc,"&").
campo:
Repeat:
   assign i-pos-fim = r-index(c-linha-desc,"&").
   if i-pos-fim > 0 then do:
     assign i-pos-i = index(c-linha-desc,"&")
            i-pos-f = index(substr(c-linha-desc,(i-pos-i + 1), 15000),"&") + i-pos-i.
     if i-pos-i = 0 or i-pos-f = i-pos-i then do:
        assign c-caracter = "&".
        run utp/ut-msgs.p (input "msg",
                           input 26392,
                           input c-caracter).
        create tt-bo-erro.
        assign tt-bo-erro.parametros = c-caracter.
        assign tt-bo-erro.i-sequen = tt-bo-erro.i-sequen + 1
               tt-bo-erro.cd-erro  = 26392
               tt-bo-erro.mensagem = return-value.     
        leave.
     end.
     else do:
         assign i-tam = i-pos-f - i-pos-i - 1  
                c-var = substr(c-linha-desc,(i-pos-i + 1),i-tam)
                c-texto = ""
                l-carrega-desc = yes.
         run cdp/cd2550b.p (output table tt-var). /* cria‡Æo da tt-var */
         find first tt-var where 
                    tt-var.nome-var = c-var no-lock no-error.
         if avail tt-var then do: 
             /* O m¢dulo vai ser "IE" somente na vari vel "data-corrente", que ‚ usada tanto em Importa‡Æo 
                como em Exporta‡Æo */
             find first tt-variaveis where tt-variaveis.nome-variavel = tt-var.nome-var no-error.
             if avail tt-variaveis then do:
                if c-modulo = " " and tt-variaveis.cod-modulo <> "IE" then 
                   assign c-modulo = tt-variaveis.cod-modulo.
                if c-modulo <> tt-variaveis.cod-modulo and tt-variaveis.cod-modulo <> "IE" then do:
                    run utp/ut-msgs.p (input "msg",
                                       input 26204,
                                       input tt-var.nome-var).
                    create tt-bo-erro.
                    assign tt-bo-erro.parametros = trim(tt-var.nome-var).
                    assign tt-bo-erro.i-sequen = tt-bo-erro.i-sequen + 1
                           tt-bo-erro.cd-erro  = 26204
                           tt-bo-erro.mensagem = return-value.
                    leave.
                end.
             end.
             {cdp/cd2550.i2}
             assign c-linha-desc =  substr(c-linha-desc,1,(i-pos-i - 1)) +
                                    string(c-texto) +  
                                    substr(c-linha-desc,(i-pos-f + 1), 15000).
             next campo.                       
         end. /* if avail */
         else do:
            run utp/ut-msgs.p (input "msg",
                               input 26026,
                               input c-var).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = tt-bo-erro.i-sequen + 1
                   tt-bo-erro.cd-erro      = 26026
                   tt-bo-erro.mensagem     = return-value.
            leave.         
         end.
     end. /*else do*/
   end. /*do*/           
   else leave.
end. /*repeat*/

END. 
 
 
 
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
 
