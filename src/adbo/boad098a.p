/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD098A 2.00.00.049 } /*** "010049" 25/12/2025 21:57:50  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad098a MUT}
&ENDIF
 
/*
**  BOAD098a.P
**
**  emitente - Emitentes
**
**  Ultima altera»’o : 30/06/99 - bre18759
*/
 

&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY emitente
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME emitente
&scoped-define PARENT-TABLE repres

{include/boini.i}

{cdp/cdcfgdis.i}
def var i-empresa like empresa.ep-codigo.
def var l-considera-replica-pd as log no-undo.  /*usado na cdapi013.i*/
 
{adbo/boad098.i RowObject}
{adbo/boad098a.i4}
{include/i-epc200.i1 "boad098a":U}
DEF VAR c-nom-prog-dpc-mg97  AS CHAR NO-UNDO.
DEF VAR c-nom-prog-appc-mg97 AS CHAR NO-UNDO.
DEF VAR c-nom-prog-upc-mg97  AS CHAR NO-UNDO.
{pdp/pd9999.i2}  /*defini‡Æo dos campos da cm-param*/
{cdp/cdapi013.i}
{cdp/cdapi013.i1}
{adbo/boad098a.i3}        /* Defini»’o das temp-tables           */
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

/* Defini‡Æo das vari veis necess rias ao setConstraint2 e 11 */
def var i-cod-emit as int no-undo.
def var i-cod-repres as int no-undo.

/* Defini‡Æo das vair veis necess rias ao setContraint6 e 7 */
def var c-nome-abrev as char no-undo.
def var c-cgc        as char no-undo.

procedure setConstraint1:
end procedure.

procedure setConstraint2:
end procedure.

procedure setConstraint3:
def input param p-cod-emit as char no-undo.
   assign i-cod-emit = int(p-cod-emit).
end procedure.

procedure setConstraint4:
def input param p-cod-emit as char no-undo.
   assign i-cod-emit = int(p-cod-emit).
end procedure.

procedure setConstraint5:
def input param p-cod-emit as char no-undo.
   assign i-cod-emit = int(p-cod-emit).
end procedure.

procedure setConstraint6:
def input param p-nome-abrev as char.
  assign c-nome-abrev = p-nome-abrev.
end procedure.

procedure setConstraint7:
def input param p-nome-abrev as char.
  assign c-nome-abrev = p-nome-abrev.
end procedure.

procedure setConstraint8:
def input param p-cgc as char.
  assign c-cgc = p-cgc.
end procedure.



def var c-inicial  as integer no-undo.
def var c-inicial2 as char    no-undo.
def var c-inicial3 as char    no-undo.
def var c-inicial4 as char    no-undo.


procedure setConstraint10:
def input param p-inicial  as integer.
def input param p-inicial2 as char.
def input param p-inicial3 as char.
def input param p-inicial4 as char.

  assign  c-inicial  = p-inicial
          c-inicial2 = p-inicial2
          c-inicial3 = p-inicial3
          c-inicial4 = p-inicial4.                                                                                  
end procedure.

procedure setConstraint11:    
   def input param p-cod-emit as char no-undo.
   def input param p-cod-repres as char no-undo.
   assign i-cod-emit = int(p-cod-emit)
          i-cod-repres = integer(p-cod-repres).
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock INDEXED-REPOSITION.
        when 2 then 
            open query {&query-name} for each {&TABLE-NAME} where emitente.identific <> 2 INDEXED-REPOSITION.
        when 3 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where emitente.cod-emitente = i-cod-emit and 
                                                                  emitente.identific <> 2 INDEXED-REPOSITION.
        when 4 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where emitente.cod-emitente >= i-cod-emit and 
                                                                  emitente.identific <> 2 INDEXED-REPOSITION.
        when 5 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where emitente.cod-emitente >= i-cod-emit and 
                                                                  emitente.identific <> 1 INDEXED-REPOSITION.                                           
	    when 6 then 
		    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
     	                             {&TABLE-NAME}.nome-abrev >= c-nome-abrev AND
					  {&table-name}.identific <> 1 NO-LOCK INDEXED-REPOSITION.
	    when 7 then 
		    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
     	                             {&TABLE-NAME}.nome-abrev = c-nome-abrev AND
					  {&table-name}.identific <> 2 NO-LOCK INDEXED-REPOSITION.	
        when 8 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} where emitente.cod-emitente = i-cod-emit and 
                                                                  emitente.identific <> 1 INDEXED-REPOSITION.   					  															  
        when 9 then 
		    open query {&QUERY-NAME} for each {&TABLE-NAME} where 
     	                             {&TABLE-NAME}.cgc >= c-cgc AND
					  {&table-name}.identific <> 1 NO-LOCK INDEXED-REPOSITION.	
        when 10 then do:
            if c-inicial <> 0 then 
               open query {&QUERY-NAME} for each {&TABLE-NAME} where                            
                          emitente.cod-emitente  >= c-inicial
                      and emitente.identific     <> 1 no-lock BY cod-emitente INDEXED-REPOSITION.    
                             
            if c-inicial2 <> "" then 
               open query {&QUERY-NAME} for each {&TABLE-NAME} where                            
                          emitente.nome-abrev    >= c-inicial2
                      and emitente.identific     <> 1 no-lock BY nome-abrev INDEXED-REPOSITION. 
                      
            if c-inicial3 <> "" then 
               open query {&QUERY-NAME} for each {&TABLE-NAME} where                            
                          emitente.cgc           >= c-inicial3
                      and emitente.identific     <> 1 no-lock BY cgc INDEXED-REPOSITION.
                      
            if c-inicial4 <> "" then 
               open query {&QUERY-NAME} for each {&TABLE-NAME} where                            
                          emitente.nome-emit     >= c-inicial4
                      and emitente.identific     <> 1 no-lock BY nome-emit INDEXED-REPOSITION. 
                      
            if c-inicial = 0 and c-inicial2 = "" and c-inicial3 = "" and c-inicial4 = "" then          
               open query {&QUERY-NAME} for each {&TABLE-NAME} where                                                     
                          emitente.identific <> 1 no-lock BY cod-emitente INDEXED-REPOSITION. 
         end.                       
         when 11 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} where 
                                              {&TABLE-NAME}.cod-emitente >= i-cod-emit and
                                              {&table-name}.identific    <> 2          and 
                                              {&TABLE-NAME}.cod-rep   = i-cod-repres NO-LOCK INDEXED-REPOSITION.
                                                      
    end. /* case */
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
    def input parameter i-cod-emitente as inte no-undo.
    def output parameter c-return as char no-undo.
 
    find emitente where
        emitente.cod-emitente = i-cod-emitente
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
 
procedure findCodigoCliente:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter i-cod-emitente as inte no-undo.
    def output parameter c-return as char no-undo.
 
    find emitente where
        emitente.cod-emitente = i-cod-emitente AND
        emitente.identific    <> 2        
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

procedure findCodigoFornecedor:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter i-cod-emitente as inte no-undo.
    def output parameter c-return as char no-undo.
 
    find emitente where
        emitente.cod-emitente = i-cod-emitente AND
        emitente.identific    <> 1        
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



procedure findNome:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter c-nome-abrev as char no-undo.
    def output parameter c-return as char no-undo.
 
    find emitente where
        emitente.nome-abrev = c-nome-abrev
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
    if rowObject.agencia = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.atividade = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.bairro = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.bairro-cob = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.bonificacao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.bx-acatada = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.caixa-postal = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.calcula-multa = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.categoria = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cep = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cgc-cob = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cidade = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cidade-cob = ? then do:
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
 
    if rowObject.cod-cacex = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-emitente = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-gr-cli = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-mensagem = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-rep = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-suframa = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-transp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.


        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.conta-corren = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.contato[01] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.contato[02] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cx-post-cob = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.data-implant = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.emite-etiq = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.end-cobranca = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.endereco = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.endereco-cob = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.esp-pd-venda = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.estado = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.estado-cob = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.forn-exp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.gera-ad = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.gera-difer = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.identific = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ind-apr-cred = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ind-atraso = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ind-aval = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ind-cre-cli = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ind-dif-atrs-1 = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ind-dif-atrs-2 = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ind-div-atraso = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ind-fat-par = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ins-est-cob = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ins-estadual = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ins-municipal = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.istr = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.lim-credito = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.linha-produt = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.mod-prefer = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.modalidade = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nat-operacao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.natureza = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nome-abrev = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nome-emit = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nome-matriz = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-copias-ped = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-mesina = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value. 
    end.
 
    if rowObject.nr-peratr = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-tabpre = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.observacoes = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.pais = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.per-max-canc = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.perc-fat-ped = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.portador = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prox-ad = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ramal[01] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ramal[02] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.resumo-mp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.taxa-financ = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.telefax = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.telefone[01] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.telefone[02] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.telex = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tp-qt-prg = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tr-ar-valor = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.user-libcre = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ven-domingo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        run utp/ut-msgs.p (input "msg",
                           input 190,
                           input "").
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 190
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ven-sabado = ? then do:
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
    **  Valida cria¯Êo da tabela/duplicidade de registro.
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
    if rowObject.agencia = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} agencia 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.atividade = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} atividade 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.bairro = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} bairro 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.bairro-cob = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} bairro-cob 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.bonificacao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} bonificacao 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.bx-acatada = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} bx-acatada 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.caixa-postal = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} caixa-postal 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.calcula-multa = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} calcula-multa 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.categoria = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} categoria 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cep = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cep 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cgc-cob = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cgc-cob 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cidade = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cidade 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cidade-cob = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cidade-cob 1}
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
 
    if rowObject.cod-cacex = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-cacex 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-emitente = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-emitente 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-gr-cli = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-gr-cli 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-mensagem = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-mensagem 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-rep = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-rep 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-suframa = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-suframa 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-transp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cod-transp 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.conta-corren = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} conta-corren 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.contato[01] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} contato 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.contato[02] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} contato 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cx-post-cob = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} cx-post-cob 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.data-implant = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} data-implant 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.emite-etiq = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} emite-etiq 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.end-cobranca = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} end-cobranca 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.endereco = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} endereco 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.endereco-cob = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} endereco-cob 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.esp-pd-venda = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} esp-pd-venda 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.estado = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} estado 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.estado-cob = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} estado-cob 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.forn-exp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} forn-exp 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.gera-ad = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} gera-ad 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.gera-difer = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} gera-difer 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.identific = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} identific 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ind-apr-cred = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} ind-apr-cred 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ind-atraso = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} ind-atraso 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ind-aval = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} ind-aval 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ind-cre-cli = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} ind-cre-cli 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ind-dif-atrs-1 = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} ind-dif-atrs-1 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ind-dif-atrs-2 = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} ind-dif-atrs-2 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ind-div-atraso = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} ind-div-atraso 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ind-fat-par = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} ind-fat-par 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ins-est-cob = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} ins-est-cob 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ins-estadual = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} ins-estadual 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ins-municipal = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} ins-municipal 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.istr = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} istr 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.lim-credito = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} lim-credito 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.linha-produt = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} linha-produt 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.mod-prefer = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} mod-prefer 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.modalidade = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} modalidade 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nat-operacao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} nat-operacao 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.natureza = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} natureza 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nome-abrev = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} nome-abrev 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nome-emit = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} nome-emit 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nome-matriz = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} nome-matriz 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-copias-ped = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} nr-copias-ped 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-mesina = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} nr-mesina 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-peratr = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} nr-peratr 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-tabpre = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} nr-tabpre 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.observacoes = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} observacoes 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.pais = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} pais 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.per-max-canc = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} per-max-canc 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.perc-fat-ped = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} perc-fat-ped 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.portador = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} portador 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.prox-ad = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} prox-ad 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ramal[01] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} ramal 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ramal[02] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} ramal 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.resumo-mp = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} resumo-mp 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.taxa-financ = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} taxa-financ 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.telefax = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} telefax 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.telefone[01] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} telefone 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.telefone[02] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} telefone 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.telex = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} telex 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tp-qt-prg = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} tp-qt-prg 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tr-ar-valor = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} tr-ar-valor 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.user-libcre = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} user-libcre 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ven-domingo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} ven-domingo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.ven-sabado = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i mgadm {&TABLE-NAME} ven-sabado 1}
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
        find emitente where
            emitente.cod-emitente = rowObject.cod-emitente
            no-lock no-error.
        if avail emitente then do:
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
        when "agencia" then c-value = RowObject.agencia.
        when "atividade" then c-value = RowObject.atividade.
        when "bairro" then c-value = RowObject.bairro.
        when "bairro-cob" then c-value = RowObject.bairro-cob.
        when "caixa-postal" then c-value = RowObject.caixa-postal.
        when "categoria" then c-value = RowObject.categoria.
        when "cep" then c-value = RowObject.cep.
        when "cep-cob" then c-value = RowObject.cep-cob.
        when "cgc" then c-value = RowObject.cgc.
        when "cgc-cob" then c-value = RowObject.cgc-cob.
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "check-sum" then c-value = RowObject.check-sum.
        when "cidade" then c-value = RowObject.cidade.
        when "cidade-cob" then c-value = RowObject.cidade-cob.
        when "cn-codigo" then c-value = RowObject.cn-codigo.
        when "cod-cacex" then c-value = RowObject.cod-cacex.
        when "cod-entrega" then c-value = RowObject.cod-entrega.
        when "cod-suframa" then c-value = RowObject.cod-suframa.


        when "conta-corren" then c-value = RowObject.conta-corren.
        when "contato[1]" then c-value = RowObject.contato[1].
        when "contato[2]" then c-value = RowObject.contato[2].
        when "cx-post-cob" then c-value = RowObject.cx-post-cob.
        when "e-mail" then c-value = RowObject.e-mail.
        when "endereco" then c-value = RowObject.endereco.
        when "endereco-cob" then c-value = RowObject.endereco-cob.
        when "endereco2" then c-value = RowObject.endereco2.
        when "estado" then c-value = RowObject.estado.
        when "estado-cob" then c-value = RowObject.estado-cob.
        when "home-page" then c-value = RowObject.home-page.
        when "inf-complementar" then c-value = RowObject.inf-complementar.
        when "ins-est-cob" then c-value = RowObject.ins-est-cob.
        when "ins-estadual" then c-value = RowObject.ins-estadual.
        when "ins-municipal" then c-value = RowObject.ins-municipal.
        when "insc-subs-trib" then c-value = RowObject.insc-subs-trib.
        when "linha-produt" then c-value = RowObject.linha-produt.
        when "nat-ope-ext" then c-value = RowObject.nat-ope-ext.
        when "nat-operacao" then c-value = RowObject.nat-operacao.
        when "nome-abrev" then c-value = RowObject.nome-abrev.
        when "nome-emit" then c-value = RowObject.nome-emit.
        when "nome-matriz" then c-value = RowObject.nome-matriz.
        when "nome-mic-reg" then c-value = RowObject.nome-mic-reg.
        when "nome-tr-red" then c-value = RowObject.nome-tr-red.
        when "nr-tabpre" then c-value = RowObject.nr-tabpre.
        when "obs-entrega" then c-value = RowObject.obs-entrega.
        when "observacoes" then c-value = RowObject.observacoes.
        when "pais" then c-value = RowObject.pais.
        when "pais-cob" then c-value = RowObject.pais-cob.
        when "ramal[1]" then c-value = RowObject.ramal[1].
        when "ramal[2]" then c-value = RowObject.ramal[2].
        when "ramal-fac" then c-value = RowObject.ramal-fac.
        when "ramal-fax" then c-value = RowObject.ramal-fax.
        when "ramal-modem" then c-value = RowObject.ramal-modem.
        when "telef-fac" then c-value = RowObject.telef-fac.
        when "telef-modem" then c-value = RowObject.telef-modem.
        when "telefax" then c-value = RowObject.telefax.
        when "telefone[1]" then c-value = RowObject.telefone[1].
        when "telefone[2]" then c-value = RowObject.telefone[2].
        when "telex" then c-value = RowObject.telex.
        when "user-libcre" then c-value = RowObject.user-libcre.
        when "zip-cob-code" then c-value = RowObject.zip-cob-code.
        when "zip-code" then c-value = RowObject.zip-code.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "bonificacao" then c-value = RowObject.bonificacao.
        when "compr-period" then c-value = RowObject.compr-period.
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "lim-adicional" then c-value = RowObject.lim-adicional.
        when "lim-credito" then c-value = RowObject.lim-credito.
        when "per-max-canc" then c-value = RowObject.per-max-canc.
        when "per-minfat" then c-value = RowObject.per-minfat.
        when "taxa-financ" then c-value = RowObject.taxa-financ.
        when "val-quota-media" then c-value = RowObject.val-quota-media.
        when "valor-minimo" then c-value = RowObject.valor-minimo.
        when "vl-max-devol" then c-value = RowObject.vl-max-devol.
        when "vl-min-ad" then c-value = RowObject.vl-min-ad.
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "bx-acatada" then c-value = RowObject.bx-acatada.
        when "cod-banco" then c-value = RowObject.cod-banco.
        when "cod-canal-venda" then c-value = RowObject.cod-canal-venda.
        when "cod-classif-cliente" then c-value = RowObject.cod-classif-cliente.
        when "cod-classif-fornec" then c-value = RowObject.cod-classif-fornec.
        when "cod-cond-pag" then c-value = RowObject.cod-cond-pag.
        when "cod-emitente" then c-value = RowObject.cod-emitente.
        when "cod-gr-cli" then c-value = RowObject.cod-gr-cli.
        when "cod-gr-forn" then c-value = RowObject.cod-gr-forn.
        when "cod-isencao" then c-value = RowObject.cod-isencao.
        when "cod-mensagem" then c-value = RowObject.cod-mensagem.
        when "cod-parceiro-edi" then c-value = RowObject.cod-parceiro-edi.
        when "cod-rep" then c-value = RowObject.cod-rep.
        when "cod-tax" then c-value = RowObject.cod-tax.
        when "cod-tip-ent" then c-value = RowObject.cod-tip-ent.
        when "cod-transp" then c-value = RowObject.cod-transp.
        when "dias-comp" then c-value = RowObject.dias-comp.
        when "emissao-ped" then c-value = RowObject.emissao-ped.
        when "end-cobranca" then c-value = RowObject.end-cobranca.
        when "esp-pd-venda" then c-value = RowObject.esp-pd-venda.
        when "estoque" then c-value = RowObject.estoque.
        when "flag-pag" then c-value = RowObject.flag-pag.
        when "gera-difer" then c-value = RowObject.gera-difer.
        when "hora-fim" then c-value = RowObject.hora-fim.
        when "hora-ini" then c-value = RowObject.hora-ini.
        when "identific" then c-value = RowObject.identific.
        when "ind-abrange-aval" then c-value = RowObject.ind-abrange-aval.
        when "ind-atraso" then c-value = RowObject.ind-atraso.
        when "ind-aval" then c-value = RowObject.ind-aval.
        when "ind-aval-embarque" then c-value = RowObject.ind-aval-embarque.
        when "ind-cre-cli" then c-value = RowObject.ind-cre-cli.
        when "ind-dif-atrs-1" then c-value = RowObject.ind-dif-atrs-1.
        when "ind-dif-atrs-2" then c-value = RowObject.ind-dif-atrs-2.
        when "ind-div-atraso" then c-value = RowObject.ind-div-atraso.
        when "ind-emit-retencao" then c-value = RowObject.ind-emit-retencao.
        when "ind-moeda-tit" then c-value = RowObject.ind-moeda-tit.
        when "ind-sit-emitente" then c-value = RowObject.ind-sit-emitente.
        when "ins-banc[1]" then c-value = RowObject.ins-banc[1].
        when "ins-banc[2]" then c-value = RowObject.ins-banc[2].
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "istr" then c-value = RowObject.istr.
        when "mod-prefer" then c-value = RowObject.mod-prefer.
        when "modalidade" then c-value = RowObject.modalidade.
        when "moeda-libcre" then c-value = RowObject.moeda-libcre.
        when "natureza" then c-value = RowObject.natureza.
        when "nr-cheque-devol" then c-value = RowObject.nr-cheque-devol.
        when "nr-copias-ped" then c-value = RowObject.nr-copias-ped.
        when "nr-dias" then c-value = RowObject.nr-dias.
        when "nr-dias-atraso" then c-value = RowObject.nr-dias-atraso.
        when "nr-dias-taxa" then c-value = RowObject.nr-dias-taxa.
        when "nr-mesina" then c-value = RowObject.nr-mesina.
        when "nr-peratr" then c-value = RowObject.nr-peratr.
        when "nr-tab-progr" then c-value = RowObject.nr-tab-progr.
        when "nr-titulo" then c-value = RowObject.nr-titulo.
        when "perc-fat-ped" then c-value = RowObject.perc-fat-ped.
        when "periodo-devol" then c-value = RowObject.periodo-devol.
        when "port-prefer" then c-value = RowObject.port-prefer.
        when "portador" then c-value = RowObject.portador.
        when "prox-ad" then c-value = RowObject.prox-ad.
        when "resumo-mp" then c-value = RowObject.resumo-mp.
        when "tip-cob-desp" then c-value = RowObject.tip-cob-desp.
        when "tp-desp-padrao" then c-value = RowObject.tp-desp-padrao.
        when "tp-inspecao" then c-value = RowObject.tp-inspecao.
        when "tp-pagto" then c-value = RowObject.tp-pagto.
        when "tp-qt-prg" then c-value = RowObject.tp-qt-prg.
        when "tp-rec-padrao" then c-value = RowObject.tp-rec-padrao.
        when "tr-ar-valor" then c-value = RowObject.tr-ar-valor.
        when "ven-domingo" then c-value = RowObject.ven-domingo.
        when "ven-feriado" then c-value = RowObject.ven-feriado.
        when "ven-sabado" then c-value = RowObject.ven-sabado.
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "data-1" then c-value = RowObject.data-1.
        when "data-2" then c-value = RowObject.data-2.
        when "data-implant" then c-value = RowObject.data-implant.
        when "data-taxa" then c-value = RowObject.data-taxa.
        when "dt-fim-cred" then c-value = RowObject.dt-fim-cred.
        when "dt-lim-cred" then c-value = RowObject.dt-lim-cred.
        when "dt-ult-venda" then c-value = RowObject.dt-ult-venda.
        otherwise return error.
    end case.
end procedure.
 
procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.
 
    case c-field:
        when "agente-retencao" then c-value = RowObject.agente-retencao.
        when "calcula-multa" then c-value = RowObject.calcula-multa.
        when "contrib-icms" then c-value = RowObject.contrib-icms.
        when "emite-bloq" then c-value = RowObject.emite-bloq.
        when "emite-etiq" then c-value = RowObject.emite-etiq.
        when "forn-exp" then c-value = RowObject.forn-exp.
        when "gera-ad" then c-value = RowObject.gera-ad.
        when "ind-apr-cred" then c-value = RowObject.ind-apr-cred.
        when "ind-cred-abat" then c-value = RowObject.ind-cred-abat.
        when "ind-fat-par" then c-value = RowObject.ind-fat-par.
        when "ind-lib-estoque" then c-value = RowObject.ind-lib-estoque.
        when "ind-licenciador" then c-value = RowObject.ind-licenciador.
        when "ind-rendiment" then c-value = RowObject.ind-rendiment.
        when "item-cli" then c-value = RowObject.item-cli.
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.
        when "percepcao" then c-value = RowObject.percepcao.
        when "prog-emit" then c-value = RowObject.prog-emit.
        when "recebe-inf-sci" then c-value = RowObject.recebe-inf-sci.
        otherwise return error.
    end case.
end procedure.

procedure assinalaFatorConvCtaPagarRec:
/*
   Busca o fator de convers’o correspondente
   para o calculo do Maior/Menor Docto 
   Cta Pagar/Cta Receber
   Par³metros:
*/

 &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN
 if  emitente.moeda-libcre <> 0 then do:
      {pdp/pd9100.i "emitente.moeda-libcre" "today" "de-fator-3"}
 &else
 find first para-ped NO-LOCK no-error.

  if  para-ped.moeda-libcre <> 0 then do:
      {pdp/pd9100.i "para-ped.moeda-libcre" "today" "de-fator-3"}
  &endif
  end.
  else
      assign de-fator-3 = 1.            

  assign de-fator-2 = de-fator-3.       

end procedure.


procedure pi-executa-upc.

        /************************************************** 
         EPC para determinar o n£mero m ximo de dias em atraso 
         Usado no pi-verifica-pd , da cdapi013.i1   
              
         **************************************************/
        
        for each tt-epc
            where tt-epc.cod-event = "replicaPD":
            delete tt-epc.
        end.

        create tt-epc.
        assign tt-epc.cod-event     = "replicaPD"
               tt-epc.cod-parameter = "setaReplicaPD"
               tt-epc.val-parameter = "nao".

        {include/i-epc201.i "replicaPD"}

        if can-find (first tt-epc where
                           tt-epc.cod-event     = "replicaPD" and
                           tt-epc.cod-parameter = "setaReplicaPD" and
                           tt-epc.val-parameter = "sim") then
           assign l-considera-replica-pd = yes.
 
end procedure.

procedure procuraMaiorMenorDoctoCtaPagar:
/*
  Procura a data e o valor do maior documento, 
  e a data e valor do œltimo documento das
  contas a pagar.
  Par³metros:
  ipar1 : r-emitente                 : Rowid do registro de emitente selecionado
  opar2 : table for tt-cta-pagar-rec : Tabela de dados do documento
*/

def input param r-emitente as rowid.
def output param table for tt-cta-pagar-rec.

def buffer b-emitente for emitente.
def var de-indice     as decimal format ">>>,>>9.99999999"   no-undo.
def var de-vl-mai-tit as decimal format ">>>,>>>,>>>,>>9.99" no-undo.
def var de-vl-ult-tit as decimal format ">>>,>>>,>>>,>>9.99" no-undo.

 for each tt-cta-pagar-rec:
   delete tt-cta-pagar-rec.
 end.

  find emitente where rowid(emitente) = r-emitente no-lock no-error.
  find first param-global no-lock no-error.

  run assinalaFatorConvCtaPagarRec.
  
  assign de-indice = 1 / de-fator-2.    

  create tt-cta-pagar-rec. /* Cria o registro a ser preenchido */
  
  for each b-emitente where b-emitente.nome-matriz = emitente.nome-abrev
                      and b-emitente.identific  <> 1 no-lock,
      each est-ap where est-ap.cod-fornec = b-emitente.cod-emitente  no-lock:    

        assign de-vl-mai-tit = est-ap.vl-maior-doc * de-indice
               de-vl-ult-tit = est-ap.vl-ult-docto * de-indice.

        if  de-vl-mai-tit > tt-cta-pagar-rec.de-vl-maior  then
            assign tt-cta-pagar-rec.de-vl-maior = de-vl-mai-tit
                   tt-cta-pagar-rec.da-maior    = est-ap.dt-maior-doc.

        if  est-ap.dt-ult-doc > tt-cta-pagar-rec.da-ultimo then
            assign tt-cta-pagar-rec.da-ultimo    = est-ap.dt-ult-doc
                   tt-cta-pagar-rec.de-vl-ultimo = de-vl-ult-tit.      
  end.
  
assign tt-cta-pagar-rec.da-ultimo = if tt-cta-pagar-rec.da-ultimo <> 01/01/1901 then 
                                      tt-cta-pagar-rec.da-ultimo 
                                    else ?.     
end procedure.

procedure procuraMaiorMenorDoctoCtaReceber:
/*
  Procura a data e o valor do maior documento, 
  e a data e valor do œltimo documento das
  contas a receber.
  Par³metros:
  ipar1 : r-emitente                 : Rowid do registro de emitente selecionado
  opar2 : table for tt-cta-pagar-rec : Tabela de dados do documento
*/

def input param r-emitente as rowid.
def output param table for tt-cta-pagar-rec.

define buffer b-emitente for emitente.
def var de-tot-rec    as decimal format "->>>,>>>,>>>,>>>,>>9.99" init 0.00 no-undo.
def var de-val-rec    as decimal format "->>>,>>>,>>>,>>>,>>9.99" init 0.00 no-undo.
def var de-indice     as decimal format ">>>,>>9.99999999"        init 1    no-undo.
def var de-vl-mai-tit as decimal format ">>>,>>>,>>>,>>9.99"                no-undo.
def var de-vl-ult-tit as decimal format ">>>,>>>,>>>,>>9.99"                no-undo.

 for each tt-cta-pagar-rec:
   delete tt-cta-pagar-rec.
 end.
 
 find emitente where rowid(emitente) = r-emitente no-lock no-error.
 find first param-cr no-lock no-error.  

 create tt-cta-pagar-rec.

 RUN assinalaFatorConvCtaPagarRec.

 assign de-indice = 1 / de-fator-2.    

  for each b-emitente where b-emitente.nome-matriz = emitente.nome-abrev no-lock:        
                 
      for each estatist
          where estatist.cod-emitente = b-emitente.cod-emitente no-lock:

          assign de-vl-mai-tit = estatist.vl-maior-tit * de-indice
                 de-vl-ult-tit = estatist.vl-ult-tit   * de-indice.

          if  de-vl-mai-tit > tt-cta-pagar-rec.de-vl-maior  then
              assign tt-cta-pagar-rec.de-vl-maior = de-vl-mai-tit
                     tt-cta-pagar-rec.da-maior    = estatist.dt-maior-tit.

          if  estatist.dt-ult-tit > tt-cta-pagar-rec.da-ultimo then
              assign tt-cta-pagar-rec.da-ultimo    = estatist.dt-ult-tit
                     tt-cta-pagar-rec.de-vl-ultimo = de-vl-ult-tit.
      end.
      
      for each emit-estat
          where emit-estat.cod-emitente = b-emitente.cod-emitente
            and emit-estat.cod-gr-emit  = b-emitente.cod-gr-cli
            and emit-estat.valor-rec > 0 no-lock :
            
          assign de-tot-rec = de-tot-rec + emit-estat.vl-tot-rec
                 de-val-rec = de-val-rec + emit-estat.valor-rec.                 
      end.
                                    
  end.
         
  assign tt-cta-pagar-rec.i-atraso-medio = de-val-rec / de-tot-rec.
         tt-cta-pagar-rec.i-atraso-medio = if tt-cta-pagar-rec.i-atraso-medio = ? then 0 
                                           else 
                                           tt-cta-pagar-rec.i-atraso-medio.         
  
assign tt-cta-pagar-rec.da-ultimo = if tt-cta-pagar-rec.da-ultimo <> 01/01/1901 then 
                                      tt-cta-pagar-rec.da-ultimo 
                                    else ?.     
end procedure.

procedure geraSituacaoGeralCliente:
/*
   Gera a estat¡stica geral do cliente do 
   M¢dulo de pedidos (DIS).
   Parƒmetros:
   ipar1  : p-cod-emitente     : C¢digo do emitente
   ipar2  : p-nome-abrev       : Nome abreviado do emitente
   ipar3  : p-nr-mesina        : N£mero m ximo de meses a ser aceito sem compras do cliente
   ipar4  : p-cod-gr-cli       : C¢digo do grupo do cliente
   ipar5  : p-nr-peratr        : Durante quantos per¡odos nÆo deve haver atraso nos pagtos
   opar6  : p-moeda            : Moeda da estat¡stica
   opar7  : p-totpdcr          : Total de pedidos CR
   opar8  : p-totpdaa          : Total de pedidos A Aprovar
   opar9  : p-totpdre          : Total de pedidos reprovados
   opar10 : p-totpdap          : Total de pedidos aprovados
   opar11 : p-lim-credito      : Limite de cr‚dito
   opar12 : p-p5-vl-cr-abe     : 
   opar13 : p-p6-vl-ap-abe     : 
   opar14 : p-saldo-vw         : Valor do Saldo Atual
   opar15 : p-saldo-ap-vw      : Valor do saldo AP/MP
   opar16 : p-saldo-cr-vw      : Valor do saldo CR/MP
   opar17 : p-vl-nota-vw       : Valor da nota
   opar18 : p-totvlaa-vw       : Valor total dos pedidos A Aprovar
   opar19 : p-totvlre-vw       : Valor total dos pedidos Reprovados
   opar20 : p-vl-ped-vw        : Valor total dos pedidos
   opar21 : p-totvlap-vw       : Valor total dos pedidos aprovados
   opar22 : p-de-tot-tit       : Valor da duplicatas em atraso
   opar23 : p-sinal            : Sinal do saldo
*/

def input param p-cod-emitente like emitente.cod-emitente.
def input param p-nome-abrev   like emitente.nome-abrev.
def input param p-nr-mesina    like emitente.nr-mesina.
def input param p-cod-gr-cli   like emitente.cod-gr-cli.
def input param p-nr-peratr    like emitente.nr-peratr.

def output param p-moeda         as char.
def output param p-totpdcr       as int.
def output param p-totpdaa       as int.
def output param p-totpdre       as int.
def output param p-totpdap       as int.
def output param p-lim-credito   as dec.
def output param p-p5-vl-cr-abe  as dec.
def output param p-p6-vl-ap-abe  as dec.
def output param p-saldo-vw      as dec.
def output param p-saldo-ap-vw   as dec.
def output param p-saldo-cr-vw   as dec.
def output param p-vl-nota-vw    as dec.
def output param p-totvlaa-vw    as dec.
def output param p-totvlre-vw    as dec.
def output param p-vl-ped-vw     as dec.
def output param p-totvlap-vw    as dec.
def output param p-de-tot-tit    as dec.
def output param p-sinal         as char.

 FOR EACH tt-emitente:
    DELETE tt-emitente.
 END.
 
 find first para-ped NO-LOCK no-error.
 
 &IF "{&bf_dis_versao_ems}":U >= "2.062":U &THEN
        ASSIGN c-cm-cod-estabel = para-ped.estab-padrao.
        /* Engenharia Separacao Modulo MPD - Avaliacao Credito */
        {cmp/cm9999.i2}
    &ELSE
        ASSIGN i-cm-num-dia-atraso                   = para-ped.dias-maxatr            
               i-cm-num-dia-aviso                    = para-ped.dias-admatr             
               i-cm-num-horiz-fix                    = para-ped.horiz-fixo.
        &IF DEFINED (bf_dis_adm_preco) &THEN
               ASSIGN l-cm-log-consid-cotas-credito  = para-ped.log-consid-cotas-credito  
                      l-cm-log-consid-desco-credito  = para-ped.log-consid-desco-credito  
                      l-cm-log-consid-precos-credito = para-ped.log-consid-precos-credito.
        &ENDIF
    &endif
 find first emitente where emitente.cod-emitente = p-cod-emitente no-lock no-error.
 if avail emitente then do:
    create tt-emitente.
    assign tt-emitente.cod-emitente          = emitente.cod-emitente
               tt-emitente.nome-abrev        = emitente.nome-abrev
               tt-emitente.nr-mesina         = emitente.nr-mesina
               tt-emitente.cod-gr-cli        = emitente.cod-gr-cli
               tt-emitente.nr-peratr         = emitente.nr-peratr
                      /*   Informa‡äes para o EMS 5.0   */
               tt-emitente.nr-cheque-devol   = emitente.nr-cheque-devol
               tt-emitente.vl-max-devol      = emitente.vl-max-devol
               tt-emitente.qtd-dias          = &IF "{&bf_dis_versao_ems}" >= "2.062" &THEN 
                                                   emitente.periodo-devol
                                               &ELSE
                                                   if emitente.periodo-devol = 0 then para-ped.periodo-devol
                                                   else emitente.periodo-devol
                                               &endif
               tt-emitente.moeda-credito     = &if "{&bf_dis_versao_ems}" >= "2.062" &then emitente.moeda-libcre &else para-ped.moeda-libcre &endif
               tt-emitente.de_saldo_cr       = 0
               tt-emitente.de_saldo_ap       = 0
               tt-emitente.de_tot_tit_atr_cr = 0
               tt-emitente.de_tot_ad_cr      = 0
               tt-emitente.de_cr_ant_aberto  = 0
               tt-emitente.de_ap_ant_aberto  = 0.
 end. 
 else do:
    CREATE tt-emitente.
    ASSIGN tt-emitente.cod-emitente = p-cod-emitente
           tt-emitente.nome-abrev   = p-nome-abrev
           tt-emitente.nr-mesina    = p-nr-mesina
           tt-emitente.cod-gr-cli  = p-cod-gr-cli
           tt-emitente.nr-peratr   = p-nr-peratr
           tt-emitente.moeda-credito = &if "{&bf_dis_versao_ems}" >= "2.062" &then 0 &else para-ped.moeda-libcre &endif.
 end.      
 ASSIGN de-saldo-ap = 0
        de-totvlap  = 0
        de-totvlre  = 0
        de-totvlaa  = 0
        de-vl-nota  = 0
        de-saldo-cr = 0
        de-saldo-ap = 0
        de-saldo    = 0
        i-tot-pdap  = 0
        i-tot-pdre  = 0
        i-tot-pdaa  = 0
        i-tot-pdcr  = 0
        mp-vl-cr-abe = 0
        mp-vl-ap-abe = 0
        de-tot-tit   = 0.

 find first param-global no-lock no-error.
 
 RUN pi-determina-limite (output p-lim-credito).
 if  param-global.modulo-mp then do: /* Dados Cliente nas outras plantas */
     run pi-verifica-mp.
 end.
 RUN pi-verifica-pd.
 RUN pi-verifica-ft.
 if  param-global.modulo-cr then 
        run pi-saldo-cr (input 3).
 RUN pi-saldo-ap.


   ASSIGN p-moeda        = c-moeda
          p-totpdcr      = i-tot-pdcr
          p-totpdaa      = i-tot-pdaa
          p-totpdre      = i-tot-pdre
          p-totpdap      = i-tot-pdap
          p-p5-vl-cr-abe = mp-vl-cr-abe
          p-p6-vl-ap-abe = mp-vl-ap-abe
          p-saldo-vw     = de-saldo
          p-saldo-ap-vw  = de-saldo-ap
          p-saldo-cr-vw  = de-saldo-cr
          p-vl-nota-vw   = de-vl-nota
          p-totvlaa-vw   = de-totvlaa
          p-totvlre-vw   = de-totvlre
          p-vl-ped-vw    = 0
          p-totvlap-vw   = de-totvlap.

   if p-moeda = "" then
      find first moeda where moeda.mo-codigo = &IF "{&bf_dis_versao_ems}" >= "2.062" &THEN emitente.moeda-libcre &else para-ped.moeda-libcre &endif no-lock no-error.
      if avail moeda then
         assign p-moeda = moeda.descricao.
         
   ASSIGN p-saldo-vw = p-lim-credito + (de-saldo-ap + mp-vl-ap-abe) - (de-saldo-cr + mp-vl-cr-abe + de-vl-nota + de-totvlap).

   &IF DEFINED(BF_DIS_ADM_PRECO) &THEN
            
        if &IF "{&bf_dis_versao_ems}" >= "2.062" &THEN l-cm-log-consid-cr-cr &else para-ped.log-consid-credito-credito  &endif /* considera reprovados */
        then assign p-saldo-vw = p-saldo-vw - de-totvlre.           
                        
   &ENDIF
   
   IF p-saldo-vw < 0 THEN 
       ASSIGN p-saldo-vw = - p-saldo-vw
              p-sinal  = "-".
   ELSE
       ASSIGN p-sinal = "+". 

end procedure.

procedure geraSituacaoGeralGrupoCliente:
/*
   Gera a estat¡stica geral do grupo do cliente do 
   M¢dulo de pedidos (DIS).
   Parƒmetros:
   ipar1 : p-cod-emitente     : C¢digo do emitente
   ipar1 : p-nome-abrev       : Nome abreviado do emitente
   ipar1 : p-nr-mesina        : N£mero m ximo de meses a ser aceito sem compras do cliente
   ipar1 : p-cod-gr-cli       : C¢digo do grupo do cliente
   ipar1 : p-nr-peratr        : Durante quantos per¡odos nÆo deve haver atraso nos pagtos
   ipar1 : p-ind-abrange-aval : Abrangˆncia da avalia‡Æo de cr‚dito
   ipar1 : p-nome-matriz      : Nome Abreviado da Matriz a que Pertence o Cliente
   opar1 : p-moeda            : Moeda da estat¡stica
   opar1 : p-totpdcr          : Total de pedidos CR
   opar1 : p-totpdaa          : Total de pedidos A Aprovar
   opar1 : p-totpdre          : Total de pedidos reprovados
   opar1 : p-totpdap          : Total de pedidos aprovados
   opar1 : p-lim-credito      : Limite de cr‚dito
   opar1 : p-p5-vl-cr-abe     : 
   opar1 : p-p6-vl-ap-abe     : 
   opar1 : p-saldo-vw         : Valor do Saldo Atual
   opar1 : p-saldo-ap-vw      : Valor do saldo AP/MP
   opar1 : p-saldo-cr-vw      : Valor do saldo CR/MP
   opar1 : p-vl-nota-vw       : Valor da nota
   opar1 : p-totvlaa-vw       : Valor total dos pedidos A Aprovar
   opar1 : p-totvlre-vw       : Valor total dos pedidos Reprovados
   opar1 : p-vl-ped-vw        : Valor total dos pedidos
   opar1 : p-totvlap-vw       : Valor total dos pedidos aprovados
   opar1 : param p-sinal      : Sinal do saldo
*/

def input param p-cod-emitente     like emitente.cod-emitente.
def input param p-nome-abrev       like emitente.nome-abrev.
def input param p-nr-mesina        like emitente.nr-mesina.
def input param p-cod-gr-cli       like emitente.cod-gr-cli.
def input param p-nr-peratr        like emitente.nr-peratr.
def input param p-ind-abrange-aval like emitente.ind-abrange-aval.
def input param p-nome-matriz      like emitente.nome-matriz.

def output param p-moeda         as char.
def output param p-totpdcr       as int.
def output param p-totpdaa       as int.
def output param p-totpdre       as int.
def output param p-totpdap       as int.
def output param p-lim-credito   as dec.
def output param p-p5-vl-cr-abe  as dec.
def output param p-p6-vl-ap-abe  as dec.
def output param p-saldo-vw      as dec.
def output param p-saldo-ap-vw   as dec.
def output param p-saldo-cr-vw   as dec.
def output param p-vl-nota-vw    as dec.
def output param p-totvlaa-vw    as dec.
def output param p-totvlre-vw    as dec.
def output param p-vl-ped-vw     as dec.
def output param p-totvlap-vw    as dec.
def output param p-sinal         as char.


  FOR EACH tt-emitente:
    DELETE tt-emitente.
  END.

  IF p-ind-abrange-aval = 1 THEN DO:
      CREATE tt-emitente.
      ASSIGN tt-emitente.cod-emitente = p-cod-emitente
             tt-emitente.nome-abrev   = p-nome-abrev
             tt-emitente.nr-mesina    = p-nr-mesina
             tt-emitente.cod-gr-cli   = p-cod-gr-cli
             tt-emitente.nr-peratr    = p-nr-peratr.
  END.
  ELSE DO:
      FOR EACH  b-emitente use-index ch-matriz 
          WHERE b-emitente.nome-matriz      = p-nome-matriz
          AND   b-emitente.ind-abrange-aval = 2 no-lock:
          CREATE tt-emitente.
          ASSIGN tt-emitente.cod-emitente = b-emitente.cod-emitente
                 tt-emitente.nome-abrev   = b-emitente.nome-abrev
                 tt-emitente.nr-mesina    = b-emitente.nr-mesina
                 tt-emitente.cod-gr-cli   = b-emitente.cod-gr-cli
                 tt-emitente.nr-peratr    = b-emitente.nr-peratr.
      END.
  END.
      
  ASSIGN de-saldo-ap = 0
         de-totvlap  = 0
         de-totvlre  = 0
         de-totvlaa  = 0
         de-vl-nota  = 0
         de-saldo-cr = 0
         de-saldo-ap = 0
         de-saldo    = 0
         i-tot-pdap  = 0
         i-tot-pdre  = 0
         i-tot-pdaa  = 0
         i-tot-tit-cr = 0
         mp-vl-cr-abe = 0
         mp-vl-ap-abe = 0.

 RUN pi-determina-limite (output p-lim-credito).

 IF  param-global.modulo-mp THEN DO: /* Dados Cliente nas outras plantas */
     RUN pi-verifica-mp.
 END.  
 RUN pi-verifica-pd.
 RUN pi-verifica-ft.
 RUN pi-saldo-ap.
 RUN pi-saldo-cr (input 3).

   ASSIGN p-moeda        = c-moeda
          p-totpdcr      = i-tot-tit-cr
          p-totpdaa      = i-tot-pdaa
          p-totpdre      = i-tot-pdre
          p-totpdap      = i-tot-pdap
          p-p5-vl-cr-abe = mp-vl-cr-abe
          p-p6-vl-ap-abe = mp-vl-ap-abe
          p-saldo-vw     = de-saldo
          p-saldo-ap-vw  = de-saldo-ap
          p-saldo-cr-vw  = de-saldo-cr
          p-vl-nota-vw   = de-vl-nota
          p-totvlaa-vw   = de-totvlaa
          p-totvlre-vw   = de-totvlre
          p-vl-ped-vw    = 0
          p-totvlap-vw   = de-totvlap.

   ASSIGN p-saldo-vw = p-lim-credito + (de-saldo-ap + mp-vl-ap-abe) - (de-saldo-cr + mp-vl-cr-abe + de-vl-nota + de-totvlap).

   IF p-saldo-vw < 0 THEN
       ASSIGN p-saldo-vw = - p-saldo-vw
              p-sinal  = "-".
   ELSE
       ASSIGN p-sinal = "+". 

end procedure.
