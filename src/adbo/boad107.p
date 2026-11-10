/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD107 2.00.00.029 } /*** "010029" 10/06/2025 09:30:37  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad107 MUT}
&ENDIF

/*
**  BOAD107.P
**
**  estabelec - Estabelecimentos
**
**  Ultima altera‡Æo : 02/04/99 - GeraBO
*/
 
&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY estabelec
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME estabelec
 
{include/boini.i}

/******************************ATENCAO*************************************
 Pre-processador abaixo responsavel por distinguir o produto que
 esta executando o componente ( Magnus ou EMS ). 
 Se estiver definida a variavel bf-mat-comex 
 ( &if defined(bf-mat-comex) &then ), significa que o produto
 chamador e o Magnus se nÆo, EMS. Utilizado pelo produto Comercio Exterior
**************************************************************************/ 
{cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */

{cdp/cdcfgdis.i} /* Include uso de pre-processadores para modulo BN*/
 
{adbo/boad107.i RowObject}
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
 
DEFINE VAR c-inicial as char no-undo.
DEFINE VAR c-final as char no-undo.
procedure setConstraint1:
 
end procedure.
procedure setConstraint2:
    def input parameter p-inicial as char no-undo.
        
    assign c-inicial = p-inicial.
end procedure.
 
procedure setConstraint3:
    def input parameter p-inicial as char no-undo.
    def input parameter p-final as char no-undo.
        
    assign c-inicial = p-inicial
           c-final = p-final.
end procedure.

def var c-cod-estabel-ini as char no-undo.
def var c-cod-estabel-fin as char no-undo.
def var c-nome-ini        as char no-undo.
def var c-nome-fin        as char no-undo.
def var i-ordena          as int  no-undo.

procedure setConstraint4:
   def input param p-cod-estabel-ini as char    no-undo.
   def input param p-cod-estabel-fin as char    no-undo.
   def input param p-nome-ini        as char    no-undo.
   def input param p-nome-fin        as char    no-undo.
   def input param p-ordena          as integer no-undo.

   assign c-cod-estabel-ini = p-cod-estabel-ini
          c-cod-estabel-fin = p-cod-estabel-fin
          c-nome-ini        = p-nome-ini
          c-nome-fin        = p-nome-fin
          i-ordena          = p-ordena.

end procedure.
 
procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
        when 2 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                        where estabelec.cod-estabel >= c-inicial.
        when 3 then
            if c-inicial = c-final then
               open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                        where estabelec.cod-estabel = c-inicial
                              BY {&TABLE-NAME}.nome
                              BY {&TABLE-NAME}.cod-estabel.
            else
               open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock
                        where estabelec.cod-estabel >= c-inicial AND
                              estabelec.cod-estabel <= c-final
                              BY {&TABLE-NAME}.nome
                              BY {&TABLE-NAME}.cod-estabel.
        when 4 then do:
            if i-ordena = 1 then do: 
               if c-cod-estabel-ini = c-cod-estabel-fin then do:
                     open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                          where {&TABLE-NAME}.cod-estabel  = c-cod-estabel-ini AND 
                                {&TABLE-NAME}.nome        >= c-nome-ini        AND
                                {&TABLE-NAME}.nome        <= c-nome-fin      
                                by {&TABLE-NAME}.cod-estabel. 
               end.
               else do:
                     open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                          where {&TABLE-NAME}.cod-estabel >= c-cod-estabel-ini AND 
                                {&TABLE-NAME}.cod-estabel <= c-cod-estabel-fin AND
                                {&TABLE-NAME}.nome        >= c-nome-ini        AND
                                {&TABLE-NAME}.nome        <= c-nome-fin      
                                by {&TABLE-NAME}.cod-estabel. 
               end.            
            end.
            if i-ordena = 2 then do :
               if c-cod-estabel-ini = c-cod-estabel-fin then do:
                     open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                          where {&TABLE-NAME}.cod-estabel  = c-cod-estabel-ini AND 
                                {&TABLE-NAME}.nome        >= c-nome-ini        AND
                                {&TABLE-NAME}.nome        <= c-nome-fin      
                                by {&TABLE-NAME}.nome. 
               end.
               else do:
                     open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock 
                          where {&TABLE-NAME}.cod-estabel >= c-cod-estabel-ini AND 
                                {&TABLE-NAME}.cod-estabel <= c-cod-estabel-fin AND
                                {&TABLE-NAME}.nome        >= c-nome-ini        AND
                                {&TABLE-NAME}.nome        <= c-nome-fin      
                                by {&TABLE-NAME}.nome. 
               end.
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
/*{include/bovaldel.i}*/
 
procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
 
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.
 
{adbo/boad107.i1} /* procedure findCodigo - utilizada no EMS e no Magnus */
 
&if defined(bf-mat-comex) &then            
&else
    procedure validateFields:
        /*
        **  Valida Fields
        */
        find first rowObject
            no-lock no-error.
     
        run startMethod ("validateFields").
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
     
        if rowObject.cd-calen = ? then do:
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
     
        if rowObject.cgc = ? then do:
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
     
        if rowObject.ct-cofins-ft = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-credito = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-despesa = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-equaliz-desp = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-equaliz-rec = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-ext-icms = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-ext-ipi = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-fins-pg = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-finsoc = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-icms-ft = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-icmsub-ft = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-ipi-ft = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-iss-ft = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-pis = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-pis-pg = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.dep-rej-cq = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.deposito-cq = ? then do:
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
     
        if rowObject.ep-codigo = ? then do:
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
     
        if rowObject.nome = ? then do:
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
     
        if rowObject.permissao = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-credito = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-despesa = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-equaliz-desp = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-equaliz-rec = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-ext-icms = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-ext-ipi = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-fins-pg = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-finsoc = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-icms-ft = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-icmsub-ft = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-ipi-ft = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-ir-ret = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-iss-ft = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-pis = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-pis-pg = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.serie = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            run utp/ut-msgs.p (input "msg",
                               input 190,
                               input "").
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 190
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.serie-manual = ? then do:
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
     
        if rowObject.cd-calen = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} cd-calen 1}
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
     
        if rowObject.cgc = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} cgc 1}
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
     
        if rowObject.cod-estabel = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} cod-estabel 1}
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
     
        if rowObject.ct-cofins-ft = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ct-cofins-ft 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-credito = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ct-credito 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-despesa = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ct-despesa 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-equaliz-desp = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ct-equaliz-desp 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-equaliz-rec = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ct-equaliz-rec 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-ext-icms = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ct-ext-icms 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-ext-ipi = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ct-ext-ipi 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-fins-pg = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ct-fins-pg 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-finsoc = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ct-finsoc 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-icms-ft = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ct-icms-ft 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-icmsub-ft = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ct-icmsub-ft 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-ipi-ft = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ct-ipi-ft 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-iss-ft = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ct-iss-ft 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-pis = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ct-pis 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.ct-pis-pg = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ct-pis-pg 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.dep-rej-cq = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} dep-rej-cq 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.deposito-cq = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} deposito-cq 1}
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
     
        if rowObject.ep-codigo = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} ep-codigo 1}
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
     
        if rowObject.nome = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} nome 1}
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
     
        if rowObject.permissao = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} permissao 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-credito = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} sc-credito 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-despesa = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} sc-despesa 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-equaliz-desp = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} sc-equaliz-desp 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-equaliz-rec = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} sc-equaliz-rec 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-ext-icms = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} sc-ext-icms 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-ext-ipi = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} sc-ext-ipi 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-fins-pg = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} sc-fins-pg 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-finsoc = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} sc-finsoc 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-icms-ft = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} sc-icms-ft 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-icmsub-ft = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} sc-icmsub-ft 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-ipi-ft = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} sc-ipi-ft 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-ir-ret = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} sc-ir-ret 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-iss-ft = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} sc-iss-ft 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-pis = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} sc-pis 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.sc-pis-pg = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} sc-pis-pg 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.serie = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} serie 1}
            run utp/ut-msgs.p (input "msg",
                               input 265,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 265
                   tt-bo-erro.mensagem     = return-value.
        end.
     
        if rowObject.serie-manual = ? then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgadm {&TABLE-NAME} serie-manual 1}
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
            find estabelec where
                estabelec.cod-estabel = rowObject.cod-estabel
                no-lock no-error.
            if avail estabelec then do:
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

    procedure validateDelete:
        /*
        **  Valida Delete
        */
        def input-output parameter r-chave as rowid.
        def output parameter table for tt-bo-erro.
     
        run InitializeValidate.
         
        find first rowObject no-lock no-error.   
        
        find {&TABLE-NAME} where
            rowid({&TABLE-NAME}) = r-chave
            exclusive-lock no-error.
        if avail {&TABLE-NAME} then do:
    
           /***** ATENCAO - Uso de Pre-processador *******/
           &if defined (bf_dis_desc_bonif) &then  /* pre-processador */   
               run verificarRelacoesEliminarEstabelec.
           &endif /* preprocessador */
           /***** fim - Uso de Pre-processador *******/
       
           find first tt-bo-erro no-lock no-error.
           if not avail tt-bo-erro then
              run executeDelete.
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
&endif    
 
procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        &IF "{&mguni_version}" >= "2.071" &THEN	
            when "ep-codigo":u then c-value = RowObject.ep-codigo.
        &ENDIF
        when "bairro":u then c-value = RowObject.bairro.
        when "cd-calen":u then c-value = RowObject.cd-calen.
        when "cgc":u then c-value = RowObject.cgc.
        when "char-1":u then c-value = RowObject.char-1.
        when "char-2":u then c-value = RowObject.char-2.
        when "cidade":u then c-value = RowObject.cidade.
        when "cod-estabel":u then c-value = RowObject.cod-estabel.
        when "cod-suframa":u then c-value = RowObject.cod-suframa.
        when "dep-rej-cq":u then c-value = RowObject.dep-rej-cq.
        when "deposito-cq":u then c-value = RowObject.deposito-cq.
        when "endereco":u then c-value = RowObject.endereco.
        when "estado":u then c-value = RowObject.estado.
        when "ins-estadual":u then c-value = RowObject.ins-estadual.
        when "ins-municipal":u then c-value = RowObject.ins-municipal.
        when "nome":u then c-value = RowObject.nome.
        when "pais":u then c-value = RowObject.pais.
        when "permissao":u then c-value = RowObject.permissao.
        when "serie":u then c-value = RowObject.serie.
        when "serie-manual":u then c-value = RowObject.serie-manual.
        when "zip-cod":u then c-value = RowObject.zip-cod.
        &if defined(bf-mat-comex) &then            
            when "u-char-1":u then c-value = RowObject.u-char-1.
            when "u-char-2":u then c-value = RowObject.u-char-2.
        &else
            when "check-sum":u then c-value = RowObject.check-sum.        
            when "condado":u then c-value = RowObject.condado.     
            when "conta-cofins":u then c-value = RowObject.conta-cofins.                   
            when "conta-credito":u then c-value = RowObject.conta-credito.            
            when "conta-cusprod":u then c-value = RowObject.conta-cusprod.            
            when "conta-desconto":u then c-value = RowObject.conta-desconto.            
            when "conta-desp-equaliz":u then c-value = RowObject.conta-desp-equaliz.            
            when "conta-desp-fin":u then c-value = RowObject.conta-desp-fin.            
            when "conta-desp-icms":u then c-value = RowObject.conta-desp-icms.            
            when "conta-desp-iof":u then c-value = RowObject.conta-desp-iof.            
            when "conta-desp-iss":u then c-value = RowObject.conta-desp-iss.            
            when "conta-despesas":u then c-value = RowObject.conta-despesas.            
            when "conta-dev-icms":u then c-value = RowObject.conta-dev-icms.            
            when "conta-dev-ipi":u then c-value = RowObject.conta-dev-ipi.            
            when "conta-devolucao":u then c-value = RowObject.conta-devolucao.            
            when "conta-extorno-icms":u then c-value = RowObject.conta-extorno-icms.            
            when "conta-extorno-ipi":u then c-value = RowObject.conta-extorno-ipi.                        
            when "conta-fin-pag":u then c-value = RowObject.conta-fin-pag.            
            when "conta-icms":u then c-value = RowObject.conta-icms.            
            when "conta-icms-comp":u then c-value = RowObject.conta-icms-comp.  
            when "conta-icms-ft":u then c-value = RowObject.conta-icms-ft.                      
            when "conta-icms-ret":u then c-value = RowObject.conta-icms-ret.            
            when "conta-icmsremes":u then c-value = RowObject.conta-icmsremes.            
            when "conta-icmsub-ft":u then c-value = RowObject.conta-icmsub-ft.            
            when "conta-ipi":u then c-value = RowObject.conta-ipi.            
            when "conta-ipi-fat":u then c-value = RowObject.conta-ipi-fat.            
            when "conta-ir-ret":u then c-value = RowObject.conta-ir-ret.            
            when "conta-iss":u then c-value = RowObject.conta-iss.            
            when "conta-juros-pagos":u then c-value = RowObject.conta-juros-pagos.            
            when "conta-pis":u then c-value = RowObject.conta-pis.            
            when "conta-pis-pag":u then c-value = RowObject.conta-pis-pag.            
            when "conta-pis-rec":u then c-value = RowObject.conta-pis-rec.            
            when "conta-rec-equaliz":u then c-value = RowObject.conta-rec-equaliz.            
            when "conta-recven":u then c-value = RowObject.conta-recven.            
            when "ct-cofins-ft":u then c-value = RowObject.ct-cofins-ft.            
            when "ct-credito":u then c-value = RowObject.ct-credito.            
            when "ct-cusprod":u then c-value = RowObject.ct-cusprod.            
            when "ct-desconto":u then c-value = RowObject.ct-desconto.            
            when "ct-desp-iof":u then c-value = RowObject.ct-desp-iof.                        
            when "ct-desp-juros":u then c-value = RowObject.ct-desp-juros.        
            when "ct-desp-juros-avc":u then c-value = RowObject.ct-desp-juros-avc.                
            when "ct-despesa":u then c-value = RowObject.ct-despesa.            
            when "ct-devolucao":u then c-value = RowObject.ct-devolucao.            
            when "ct-equaliz-desp":u then c-value = RowObject.ct-equaliz-desp.            
            when "ct-equaliz-rec":u then c-value = RowObject.ct-equaliz-rec.
            when "ct-ext-icms":u then c-value = RowObject.ct-ext-icms.
            when "ct-ext-ipi":u then c-value = RowObject.ct-ext-ipi.
            when "ct-fins-pg":u then c-value = RowObject.ct-fins-pg.
            when "ct-finsoc":u then c-value = RowObject.ct-finsoc.
            when "ct-icm":u then c-value = RowObject.ct-icm.
            when "ct-icms-comp":u then c-value = RowObject.ct-icms-comp.
            when "ct-icms-dev":u then c-value = RowObject.ct-icms-dev.
            when "ct-icms-ft":u then c-value = RowObject.ct-icms-ft.
            when "ct-icmsremes":u then c-value = RowObject.ct-icmsremes.      
            when "ct-icmsub-ft":u then c-value = RowObject.ct-icmsub-ft.
            when "ct-ipi":u then c-value = RowObject.ct-ipi.
            when "ct-ipi-dev":u then c-value = RowObject.ct-ipi-dev.
            when "ct-ipi-ft":u then c-value = RowObject.ct-ipi-ft.
            when "ct-ir-ret":u then c-value = RowObject.ct-ir-ret.
            when "ct-iss":u then c-value = RowObject.ct-iss.
            when "ct-iss-ft":u then c-value = RowObject.ct-iss-ft.
            when "ct-pis":u then c-value = RowObject.ct-pis.
            when "ct-pis-pg":u then c-value = RowObject.ct-pis-pg.
            when "ct-recven":u then c-value = RowObject.ct-recven.                  
            when "grupo-aloca":u then c-value = RowObject.grupo-aloca.      
            when "sc-cofins-ft":u then c-value = RowObject.sc-cofins-ft.
            when "sc-credito":u then c-value = RowObject.sc-credito.
            when "sc-cusprod":u then c-value = RowObject.sc-cusprod.              
            when "sc-desconto":u then c-value = RowObject.sc-desconto.      
            when "sc-desp-iof":u then c-value = RowObject.sc-desp-iof.
            when "sc-desp-juros":u then c-value = RowObject.sc-desp-juros.
            when "sc-desp-juros-avc":u then c-value = RowObject.sc-desp-juros-avc.
            when "sc-despesa":u then c-value = RowObject.sc-despesa.
            when "sc-devolucao":u then c-value = RowObject.sc-devolucao.                      
            when "sc-equaliz-desp":u then c-value = RowObject.sc-equaliz-desp.
            when "sc-equaliz-rec":u then c-value = RowObject.sc-equaliz-rec.
            when "sc-ext-icms":u then c-value = RowObject.sc-ext-icms.
            when "sc-ext-ipi":u then c-value = RowObject.sc-ext-ipi.
            when "sc-fins-pg":u then c-value = RowObject.sc-fins-pg.
            when "sc-finsoc":u then c-value = RowObject.sc-finsoc.
            when "sc-icm":u then c-value = RowObject.sc-icm.
            when "sc-icms-comp":u then c-value = RowObject.sc-icms-comp.
            when "sc-icms-dev":u then c-value = RowObject.sc-icms-dev.
            when "sc-icms-ft":u then c-value = RowObject.sc-icms-ft.  
            when "sc-icmsremes":u then c-value = RowObject.sc-icmsremes.                      
            when "sc-icmsub-ft":u then c-value = RowObject.sc-icmsub-ft.
            when "sc-ipi":u then c-value = RowObject.sc-ipi.
            when "sc-ipi-dev":u then c-value = RowObject.sc-ipi-dev.
            when "sc-ipi-ft":u then c-value = RowObject.sc-ipi-ft.
            when "sc-ir-ret":u then c-value = RowObject.sc-ir-ret.
            when "sc-iss":u then c-value = RowObject.sc-iss.
            when "sc-iss-ft":u then c-value = RowObject.sc-iss-ft.
            when "sc-pis":u then c-value = RowObject.sc-pis.
            when "sc-pis-pg":u then c-value = RowObject.sc-pis-pg.
            when "sc-recven":u then c-value = RowObject.sc-recven.            
        &endif        
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "dec-1":u then c-value = RowObject.dec-1.
        when "dec-2":u then c-value = RowObject.dec-2.
        &if defined(bf-mat-comex) &then            
            when "u-dec-1":u then c-value = RowObject.u-dec-1.
            when "u-dec-2":u then c-value = RowObject.u-dec-2.        
        &else
            when "qtd-up-prod[1]":u then c-value = RowObject.qtd-up-prod[1].        
            when "qtd-up-prod[2]":u then c-value = RowObject.qtd-up-prod[2].            
            when "qtd-up-prod[3]":u then c-value = RowObject.qtd-up-prod[3].            
            when "tax-cidade":u then c-value = RowObject.tax-cidade. 
            when "tax-condado":u then c-value = RowObject.tax-condado.                       
            when "tax-estado":u then c-value = RowObject.tax-estado.   
            when "val-desp-total[1]":u then c-value = RowObject.val-desp-total[1].       
            when "val-desp-total[2]":u then c-value = RowObject.val-desp-total[2].
            when "val-desp-total[3]":u then c-value = RowObject.val-desp-total[3].
            when "val-unit-up[1]":u then c-value = RowObject.val-unit-up[1].
            when "val-unit-up[2]":u then c-value = RowObject.val-unit-up[2].
            when "val-unit-up[3]":u then c-value = RowObject.val-unit-up[3].                                      
        &endif        
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.

    case c-field:
        when "cep":u then c-value = RowObject.cep.
        when "cod-emitente":u then c-value = RowObject.cod-emitente.
        WHEN "tipo-emissao-nfe" THEN ASSIGN c-value  = &if "{&BF_DIS_VERSAO_EMS}" >= "2.07" &then
                                                           RowObject.idi-tip-emis-nf-eletro.
                                                       &else
                                                           INT(TRIM(SUBSTRING(RowObject.char-1,168,1))).
                                                       &endif
         &IF "{&mguni_version}" < "2.071" &THEN	
            when "ep-codigo":u then c-value = RowObject.ep-codigo.
        &ENDIF
        when "int-1":u then c-value = RowObject.int-1.
        when "int-2":u then c-value = RowObject.int-2.
        &if defined(bf-mat-comex) &then    
            when "ct-credito":u then c-value = RowObject.ct-credito.
            when "sc-credito":u then c-value = RowObject.sc-credito.    
            when "ct-equaliz-desp":u then c-value = RowObject.ct-equaliz-desp.
            when "sc-equaliz-desp":u then c-value = RowObject.sc-equaliz-desp.                    
            when "ct-desp-juros-avc":u then c-value = RowObject.ct-desp-juros-avc.
            when "sc-desp-juros-avc":u then c-value = RowObject.sc-desp-juros-avc.            
            when "ct-desp-iof":u then c-value = RowObject.ct-desp-iof.            
            when "sc-desp-iof":u then c-value = RowObject.sc-desp-iof.                        
            when "ct-iss-ft":u then c-value = RowObject.ct-iss-ft.                       
            when "sc-iss-ft":u then c-value = RowObject.sc-iss-ft.                        
            when "ct-despesa":u then c-value = RowObject.ct-despesa. 
            when "sc-despesa":u then c-value = RowObject.sc-despesa. 
            when "ct-icms-dev":u then c-value = RowObject.ct-icms-dev.
            when "sc-icms-dev":u then c-value = RowObject.sc-icms-dev.            
            when "ct-ipi-dev":u then c-value = RowObject.ct-ipi-dev.
            when "sc-ipi-dev":u then c-value = RowObject.sc-ipi-dev.            
            when "ct-pis-pg":u then c-value = RowObject.ct-pis-pg.
            when "sc-pis-pg":u then c-value = RowObject.sc-pis-pg.     
            when "ct-ext-icms":u then c-value = RowObject.ct-ext-icms.
            when "sc-ext-icms":u then c-value = RowObject.sc-ext-icms.
            when "ct-ext-ipi":u then c-value = RowObject.ct-ext-ipi.
            when "sc-ext-ipi":u then c-value = RowObject.sc-ext-ipi.            
            when "ct-fins-pg":u then c-value = RowObject.ct-fins-pg.            
            when "sc-fins-pg":u then c-value = RowObject.sc-fins-pg.            
            when "ct-icm":u then c-value = RowObject.ct-icm.
            when "sc-icm":u then c-value = RowObject.sc-icm.
            when "ct-icms-comp":u then c-value = RowObject.ct-icms-comp.
            when "sc-icms-comp":u then c-value = RowObject.sc-icms-comp.           
            when "ct-icms-ft":u then c-value = RowObject.ct-icms-ft. 
            when "sc-icms-ft":u then c-value = RowObject.sc-icms-ft.
            when "ct-icmsub-ft":u then c-value = RowObject.ct-icmsub-ft.
            when "sc-icmsub-ft":u then c-value = RowObject.sc-icmsub-ft.            
            when "ct-ipi":u then c-value = RowObject.ct-ipi.
            when "sc-ipi":u then c-value = RowObject.sc-ipi.
            when "ct-ipi-ft":u then c-value = RowObject.ct-ipi-ft.
            when "sc-ipi-ft":u then c-value = RowObject.sc-ipi-ft.
            when "ct-ir-ret":u then c-value = RowObject.ct-ir-ret.
            when "sc-ir-ret":u then c-value = RowObject.sc-ir-ret.
            when "ct-iss":u then c-value = RowObject.ct-iss.
            when "sc-iss":u then c-value = RowObject.sc-iss.
            when "ct-desp-juros":u then c-value = RowObject.ct-desp-juros.
            when "sc-desp-juros":u then c-value = RowObject.sc-desp-juros.
            when "ct-pis":u then c-value = RowObject.ct-pis.
            when "sc-pis":u then c-value = RowObject.sc-pis.
            when "ct-pis-pg":u then c-value = RowObject.ct-pis-pg.
            when "sc-pis-pg":u then c-value = RowObject.sc-pis-pg.
            when "ct-pis":u then c-value = RowObject.ct-pis.
            when "sc-pis":u then c-value = RowObject.sc-pis.
            when "ct-equaliz-rec":u then c-value = RowObject.ct-equaliz-rec.
            when "sc-equaliz-rec":u then c-value = RowObject.sc-equaliz-rec.
            when "ct-fins-pg":u then c-value = RowObject.ct-fins-pg.
            when "sc-fins-pg":u then c-value = RowObject.sc-fins-pg.            
            when "ct-cofins-ft":u then c-value = RowObject.ct-cofins-ft.
            when "ct-credito":u then c-value = RowObject.ct-credito.
            when "ct-desp-iof":u then c-value = RowObject.ct-desp-iof.
            when "ct-desp-juros":u then c-value = RowObject.ct-desp-juros.
            when "ct-desp-juros-avc":u then c-value = RowObject.ct-desp-juros-avc.
            when "ct-despesa":u then c-value = RowObject.ct-despesa.
            when "ct-equaliz-desp":u then c-value = RowObject.ct-equaliz-desp.
            when "ct-equaliz-rec":u then c-value = RowObject.ct-equaliz-rec.
            when "ct-ext-icms":u then c-value = RowObject.ct-ext-icms.
            when "ct-ext-ipi":u then c-value = RowObject.ct-ext-ipi.
            when "ct-fins-pg":u then c-value = RowObject.ct-fins-pg.
            when "ct-finsoc":u then c-value = RowObject.ct-finsoc.
            when "ct-icm":u then c-value = RowObject.ct-icm.
            when "ct-icms-comp":u then c-value = RowObject.ct-icms-comp.
            when "ct-icms-dev":u then c-value = RowObject.ct-icms-dev.
            when "ct-icms-ft":u then c-value = RowObject.ct-icms-ft.
            when "ct-icmsub-ft":u then c-value = RowObject.ct-icmsub-ft.
            when "ct-ipi":u then c-value = RowObject.ct-ipi.
            when "ct-ipi-dev":u then c-value = RowObject.ct-ipi-dev.
            when "ct-ipi-ft":u then c-value = RowObject.ct-ipi-ft.
            when "ct-ir-ret":u then c-value = RowObject.ct-ir-ret.
            when "ct-iss":u then c-value = RowObject.ct-iss.
            when "ct-iss-ft":u then c-value = RowObject.ct-iss-ft.
            when "ct-pis":u then c-value = RowObject.ct-pis.
            when "ct-pis-pg":u then c-value = RowObject.ct-pis-pg.            
            when "sc-cofins-ft":u then c-value = RowObject.sc-cofins-ft.
            when "sc-credito":u then c-value = RowObject.sc-credito.
            when "sc-desp-iof":u then c-value = RowObject.sc-desp-iof.
            when "sc-desp-juros":u then c-value = RowObject.sc-desp-juros.
            when "sc-desp-juros-avc":u then c-value = RowObject.sc-desp-juros-avc.
            when "sc-despesa":u then c-value = RowObject.sc-despesa.
            when "sc-equaliz-desp":u then c-value = RowObject.sc-equaliz-desp.
            when "sc-equaliz-rec":u then c-value = RowObject.sc-equaliz-rec.
            when "sc-ext-icms":u then c-value = RowObject.sc-ext-icms.
            when "sc-ext-ipi":u then c-value = RowObject.sc-ext-ipi.
            when "sc-fins-pg":u then c-value = RowObject.sc-fins-pg.
            when "sc-finsoc":u then c-value = RowObject.sc-finsoc.
            when "sc-icm":u then c-value = RowObject.sc-icm.
            when "sc-icms-comp":u then c-value = RowObject.sc-icms-comp.
            when "sc-icms-dev":u then c-value = RowObject.sc-icms-dev.
            when "sc-icms-ft":u then c-value = RowObject.sc-icms-ft.
            when "sc-icmsub-ft":u then c-value = RowObject.sc-icmsub-ft.
            when "sc-ipi":u then c-value = RowObject.sc-ipi.
            when "sc-ipi-dev":u then c-value = RowObject.sc-ipi-dev.
            when "sc-ipi-ft":u then c-value = RowObject.sc-ipi-ft.
            when "sc-ir-ret":u then c-value = RowObject.sc-ir-ret.
            when "sc-iss":u then c-value = RowObject.sc-iss.
            when "sc-iss-ft":u then c-value = RowObject.sc-iss-ft.
            when "sc-pis":u then c-value = RowObject.sc-pis.            
            when "sc-pis-pg":u then c-value = RowObject.sc-pis-pg.  
            when "u-int-1":u then c-value = RowObject.u-int-1.
            when "u-int-2":u then c-value = RowObject.u-int-2.                                      
        &else
            when "cod-isencao":u then c-value = RowObject.cod-isencao.        
            when "cod-sit-aval":u then c-value = RowObject.cod-sit-aval.            
            when "custo-contab":u then c-value = RowObject.custo-contab.            
        &endif        
        otherwise return error.

    end case.
    
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
        when "data-1":u then c-value = RowObject.data-1.
        when "data-2":u then c-value = RowObject.data-2.
        when "dt-vcto-cofins[1]":u then c-value = RowObject.dt-vcto-cofins[1].
        when "dt-vcto-cofins[2]":u then c-value = RowObject.dt-vcto-cofins[2].
        when "dt-vcto-cofins[3]":u then c-value = RowObject.dt-vcto-cofins[3].
        when "dt-vcto-icms[1]":u then c-value = RowObject.dt-vcto-icms[1].
        when "dt-vcto-icms[2]":u then c-value = RowObject.dt-vcto-icms[2].
        when "dt-vcto-icms[3]":u then c-value = RowObject.dt-vcto-icms[3].
        when "dt-vcto-ipi[1]":u then c-value = RowObject.dt-vcto-ipi[1].
        when "dt-vcto-ipi[2]":u then c-value = RowObject.dt-vcto-ipi[2].
        when "dt-vcto-ipi[3]":u then c-value = RowObject.dt-vcto-ipi[3].
        when "dt-vcto-irrf[1]":u then c-value = RowObject.dt-vcto-irrf[1].
        when "dt-vcto-irrf[2]":u then c-value = RowObject.dt-vcto-irrf[2].
        when "dt-vcto-irrf[3]":u then c-value = RowObject.dt-vcto-irrf[3].
        when "dt-vcto-iss[1]":u then c-value = RowObject.dt-vcto-iss[1].
        when "dt-vcto-iss[2]":u then c-value = RowObject.dt-vcto-iss[2].
        when "dt-vcto-iss[3]":u then c-value = RowObject.dt-vcto-iss[3].
        when "dt-vcto-pis[1]":u then c-value = RowObject.dt-vcto-pis[1].
        when "dt-vcto-pis[2]":u then c-value = RowObject.dt-vcto-pis[2].
        when "dt-vcto-pis[3]":u then c-value = RowObject.dt-vcto-pis[3].
        when "medio-ate":u then c-value = RowObject.medio-ate.
        otherwise return error.
    end case.
end procedure.
 
procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.
 
    case c-field:
        when "log-1":u then c-value = RowObject.log-1.
        when "log-2":u then c-value = RowObject.log-2.
        &if defined(bf-mat-comex) &then            
        &else
            when "cons-ap":u then c-value = RowObject.cons-ap. 
            when "cons-cent-vend":u then c-value = RowObject.cons-cent-vend.    
            when "cons-comp-corp":u then c-value = RowObject.cons-comp-corp.                           
            when "cons-cpv":u then c-value = RowObject.cons-cpv.            
            when "cons-cr":u then c-value = RowObject.cons-cr.            
            when "cons-ft":u then c-value = RowObject.cons-ft.    
            when "cons-pd":u then c-value = RowObject.cons-pd.    
            when "cons-transf-mat":u then c-value = RowObject.cons-transf-mat.          
            when "usa-mensal":u then c-value = RowObject.usa-mensal.      
            when "usa-on-line":u then c-value = RowObject.usa-on-line.                                    
            when "usa-padrao":u then c-value = RowObject.usa-padrao.            
        &endif  
        otherwise return error.
    end case.
end procedure.
 
&if defined(bf-mat-comex) &then            
&else
    Procedure retornaValoresHabilitarRadio:
      
        /*       
                 Retorna o conteudo dos campos usa-mensal, usa-on-line e usa-padrao da tabela estabelec, 
                 para poder habilitar ou desabilitar os itens do Radio-set da tela de parÆmetros.
                 
                 ParÆmetros
                 opar1: p-l-mensal  : Conteudo do campo usa-mensal da tabela estabelec.
                 opar2: p-l-on-line : Conteudo do campo usa-on-line da tabela estabelec.
                 opar3: p-l-padrao  : Conteudo do campo usa-padrao da tabela estabelec.
        */
        
        def output parameter p-l-mensal  as logical no-undo.
        def output parameter p-l-on-line as logical no-undo.
        def output parameter p-l-padrao  as logical no-undo.     
        
        find first param-cp NO-LOCK NO-ERROR.
           find estabelec where estabelec.cod-estabel = param-cp.cod-estabel no-lock no-error.
           if avail estabelec then do:
                
                      assign p-l-mensal = estabelec.usa-mensal.
                      assign p-l-on-line = estabelec.usa-on-line.
                      assign p-l-padrao = estabelec.usa-padrao.
           end.   
         
    end procedure. 
     
     
    /* here comes the business logic methods */
    procedure estabelecCentralVendas:
       /* 
       ** Se l-central = yes Então o estabelecimento é uma central de vendas.   
       ** Estabelecimento
       */
      
       def output parameter l-central as logical no-undo.
       
       assign l-central = ?.
       
    end procedure.
&endif
   



/***** ATENCAO - Uso de Pre-processador *******/
&if defined (bf_dis_desc_bonif) &then  /* pre-processador */   

    procedure verificarRelacoesEliminarEstabelec:
    /*
    M‚todo implementado para realizar a valida‡Æo na  elimina‡Æo da tabela estabelec e verificar se 
    a estabelec  est  sendo usada na tabela param-bonif. 
    */
        def var c-texto       as char extent 2 no-undo.

    
        find first param-global
            no-lock no-error.
    
        if param-global.modulo-09 then do: /* modulo BN */ 
            if can-find (first param-bonif where 
                               param-bonif.cod-estabel = estabelec.cod-estabel) then do:         
               assign i-seq-erro = i-seq-erro + 1.
               {utp/ut-table.i mgadm {&TABLE-NAME} 1}
               assign c-texto[1] = return-value.
               {utp/ut-table.i mgdis param-bonif 1}
               assign c-texto[2] = return-value.     
               run utp/ut-msgs.p (input "msg",
                                  input 5,          /* Estabelec possui relacionamentos ativos com param-bonif.*/
                                  input c-texto[1] + "~~" + c-texto[2]).
               create tt-bo-erro.
               assign tt-bo-erro.i-sequen     = i-seq-erro
                      tt-bo-erro.cd-erro      = 5
                      tt-bo-erro.mensagem     = return-value.  
               assign tt-bo-erro.parametros    = c-texto[1] + "~~" + c-texto[2].
            end.    
        end. /* param-global */    
    end procedure.
    
&endif /* preprocessador */
/***** fim - Uso de Pre-processador *******/ 

