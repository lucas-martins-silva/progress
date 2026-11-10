/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD018 2.00.00.012}  /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOAD018 MUT}
&ENDIF


/*
**  BOAD018.P
**
**  banco -  Bancos
**
**  Ultima altera‡Æo : 02/04/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY banco
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME banco
 
{include/boini.i}
 
{adbo/boad018.i RowObject}

/******************************ATENCAO*************************************
 Pre-processador abaixo responsavel por distinguir o produto que
 esta executando o componente ( Magnus ou EMS ). 
 Se estiver definida a variavel bf-mat-comex 
 ( &if defined(bf-mat-comex) &then ), significa que o produto
 chamador e o Magnus se nÆo, EMS. Utilizado pelo produto Comercio Exterior
**************************************************************************/ 
{cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
def var i-banco-inicial as integer no-undo.
def var i-banco-final as integer no-undo.
 
procedure setConstraint1:
 
end procedure.

procedure setConstraint2:
  def input parameter p-banco-inicial as integer no-undo.
     assign i-banco-inicial = p-banco-inicial. 
end procedure.

procedure setConstraint3:
  def input parameter p-banco-ini as integer no-undo.
  def input parameter p-banco-fim as integer no-undo.
     assign i-banco-inicial = p-banco-ini
            i-banco-final   = p-banco-fim. 
end procedure.

def var i-cod-banco-ini as int  no-undo.
def var i-cod-banco-fin as int  no-undo.
def var c-nome-ini      as char no-undo.
def var c-nome-fin      as char no-undo.
def var i-ordena        as int  no-undo.

procedure setConstraint4:
   def input param p-cod-banco-ini as integer no-undo.
   def input param p-cod-banco-fin as integer no-undo.
   def input param p-nome-ini      as char    no-undo.
   def input param p-nome-fin      as char    no-undo.
   def input param p-ordena        as integer no-undo.

   assign i-cod-banco-ini = p-cod-banco-ini
          i-cod-banco-fin = p-cod-banco-fin
          c-nome-ini      = p-nome-ini
          c-nome-fin      = p-nome-fin
          i-ordena        = p-ordena.

end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock INDEXED-REPOSITION.
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                 where {&TABLE-NAME}.cod-banco >= i-banco-inicial INDEXED-REPOSITION.
        when 3 then
            if  i-banco-inicial = i-banco-final then
                open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                     where {&TABLE-NAME}.cod-banco = i-banco-inicial INDEXED-REPOSITION.
            else
                open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                     where {&TABLE-NAME}.cod-banco >= i-banco-inicial and
                           {&TABLE-NAME}.cod-banco <= i-banco-final INDEXED-REPOSITION.
        when 4 then do:
            if i-ordena = 1 then do : 
               if  i-cod-banco-ini = i-cod-banco-fin then
                   open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                                where {&TABLE-NAME}.cod-banco   = i-cod-banco-ini AND
                                      {&TABLE-NAME}.nome-banco >= c-nome-ini      AND
                                      {&TABLE-NAME}.nome-banco <= c-nome-fin      
                                      by {&TABLE-NAME}.cod-banco INDEXED-REPOSITION.
               else
                   open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                                where {&TABLE-NAME}.cod-banco  >= i-cod-banco-ini AND 
                                      {&TABLE-NAME}.cod-banco  <= i-cod-banco-fin AND
                                      {&TABLE-NAME}.nome-banco >= c-nome-ini      AND
                                      {&TABLE-NAME}.nome-banco <= c-nome-fin      
                                      by {&TABLE-NAME}.cod-banco INDEXED-REPOSITION.
            end.
            if i-ordena = 2 then do :
               if   i-cod-banco-ini = i-cod-banco-fin then
                    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                                where {&TABLE-NAME}.cod-banco   = i-cod-banco-ini AND 
                                      {&TABLE-NAME}.nome-banco >= c-nome-ini      AND
                                      {&TABLE-NAME}.nome-banco <= c-nome-fin      
                                      by {&TABLE-NAME}.nome-banco.
               else
                    open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                                where {&TABLE-NAME}.cod-banco  >= i-cod-banco-ini AND 
                                      {&TABLE-NAME}.cod-banco  <= i-cod-banco-fin AND
                                      {&TABLE-NAME}.nome-banco >= c-nome-ini      AND
                                      {&TABLE-NAME}.nome-banco <= c-nome-fin      
                                      by {&TABLE-NAME}.nome-banco.
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
 
procedure findCod_banco:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter i-cod-banco as inte no-undo.
    def output parameter c-return as char no-undo.
 
    find first banco where
        banco.cod-banco = i-cod-banco
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
    if rowObject.ag-padrao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-banco = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-febraban = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-resp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.convenio = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nome-banco = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.usa-cob-esc = ? then do:
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
    if rowObject.ag-padrao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} ag-padrao 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-banco = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-banco 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-febraban = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-febraban 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-resp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-resp 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.convenio = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} convenio 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nome-banco = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} nome-banco 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.usa-cob-esc = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} usa-cob-esc 1}
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
        find banco where
            banco.cod-banco = rowObject.cod-banco
            no-lock no-error.
        if avail banco then do:
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

procedure findnomebanco:
/****/
   def input  parameter p-cod-banco as char no-undo.
   def output parameter p-descricao as char no-undo.
   find banco where
        banco.cod-banco = int(p-cod-banco)
        no-lock no-error. 
   assign p-descricao = if available banco then banco.nome-banco else "":U. 
end procedure.
 
procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        when "ag-padrao" then c-value = RowObject.ag-padrao.
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "cod-resp" then c-value = RowObject.cod-resp.
        when "nome-abrev" then c-value = RowObject.nome-abrev.
        when "nome-banco" then c-value = RowObject.nome-banco.
        &if defined(bf-mat-comex) &then            
            when "contr-garant" then c-value = RowObject.contr-garant.                        
            when "u-char-1" then c-value = RowObject.u-char-1.
            when "u-char-2" then c-value = RowObject.u-char-2.           
        &else
            when "check-sum" then c-value = RowObject.check-sum.
            when "cod-imagem" then c-value = RowObject.cod-imagem.
        &endif        
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "lim-emprest" then c-value = RowObject.lim-emprest.
        when "vl-lim-aplic" then c-value = RowObject.vl-lim-aplic.
        &if defined(bf-mat-comex) &then                    
            when "u-dec-1" then c-value = RowObject.u-dec-1.
            when "u-dec-2" then c-value = RowObject.u-dec-2.                
        &else
        &endif
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "cod-banco" then c-value = RowObject.cod-banco.
        when "cod-febraban" then c-value = RowObject.cod-febraban.
        when "convenio" then c-value = RowObject.convenio.
        when "ins-banc[1]" then c-value = RowObject.ins-banc[1].
        when "ins-banc[2]" then c-value = RowObject.ins-banc[2].
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        &if defined(bf-mat-comex) &then            
            when "prox-remessa" then c-value = RowObject.prox-remessa.                
            when "prazo-min" then c-value = RowObject.prazo-min.                
            when "prazo-max" then c-value = RowObject.prazo-max.        
            when "carteira[1]" then c-value = RowObject.carteira[1].        
            when "carteira[2]" then c-value = RowObject.carteira[2].        
            when "carteira[3]" then c-value = RowObject.carteira[3].
            when "carteira[4]" then c-value = RowObject.carteira[4].
            when "carteira[5]" then c-value = RowObject.carteira[5].
            when "carteira[6]" then c-value = RowObject.carteira[6].        
            when "mo-vl-max" then c-value = RowObject.mo-vl-max.
            when "num-seq-pag" then c-value = RowObject.num-seq-pag.
            when "u-int-1" then c-value = RowObject.u-int-1.
            when "u-int-2" then c-value = RowObject.u-int-2.        
        &else
            when "emis-extrato" then c-value = RowObject.emis-extrato.        
            when "prazo" then c-value = RowObject.prazo.            
        &endif        
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        &if defined(bf-mat-comex) &then            
        &else
            when "data-1" then c-value = RowObject.data-1.
            when "data-2" then c-value = RowObject.data-2.
        &endif
        otherwise return error.
    end case.
end procedure.
 
procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.
 
    case c-field:
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.
        when "usa-cob-esc" then c-value = RowObject.usa-cob-esc.
        &if defined(bf-mat-comex) &then                    
            when "u-log-1" then c-value = RowObject.u-log-1.
        &else
        &endif        
        otherwise return error.
    end case.
end procedure.
